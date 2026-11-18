# 🏛️ Forecast Module  — Full Design (ทุกมิติ)

> **Module:** `forecast` (Layer 5 — Intelligence) · **Prefix:** `fc` · **Version:** 2.0
> **Stack:** Clean Architecture + DDD + Event Sourcing + Hash-Chain Audit + KPI (SMART) + Cache Layer

---

## 📐 1. Architecture Overview (ทุกมิติ)

```
┌──────────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                               │
│  FastAPI Routers · Schemas (Pydantic) · Dependencies · Rate Limit · Auth │
│  ── /api/v1/forecast/{generate, backtest, accuracy, kpi, audit, verify}  │
└──────────────────────────────┬───────────────────────────────────────────┘
                               │ HTTP / JWT / Tenant Context
┌──────────────────────────────▼───────────────────────────────────────────┐
│                        APPLICATION LAYER                                 │
│  ForecastUseCases · ForecastKPIService · AuditService · HashChainService│
│  Mappers (DTO ⇄ Entity) · Exceptions · Utils (MAPE, Bias, Coverage)      │
└──────────────────────────────┬───────────────────────────────────────────┘
                               │ Pure Domain Calls
┌──────────────────────────────▼───────────────────────────────────────────┐
│                          DOMAIN LAYER (Pure)                             │
│  Entities:    Forecast · ForecastEvent · ForecastAuditLog · ForecastKPI  │
│  VOs:         ForecastResult · ForecastHorizon · HashChain · MAPE        │
│  Enums:       ForecastMethod · ForecastType · Granularity · AuditAction  │
│  Events:      7 domain events (Generated/Updated/AccuracyDropped/...)    │
│  Invariants:  non-negative · MAPE<20 · hash_valid · append_only · SMART  │
└──────────────────────────────┬───────────────────────────────────────────┘
                               │ Ports / Protocols
┌──────────────────────────────▼───────────────────────────────────────────┐
│                      INFRASTRUCTURE LAYER                                │
│  Repos:    PostgresForecastRepository · EventStoreRepository             │
│            AuditLogRepository · KPIRepository                           │
│  Cache:    RedisForecastCache (L1 in-proc LRU + L2 Redis)                │
│  Ledger:   LedgerAdapter (Postgres | QLDB | Hyperledger Fabric)          │
│  ML:       MLForecastService (LSTM · Prophet · XGBoost · ARIMA · Ens.)   │
│  Services: HashChainService · MAPEService · AuditService                 │
└──────────────────────────────┬───────────────────────────────────────────┘
                               │
┌──────────────────────────────▼───────────────────────────────────────────┐
│                          DATA TIER                                       │
│  PostgreSQL 15 (RLS + partitions + append-only triggers)                │
│  Redis 7 (cache + rate-limit + distributed lock)                        │
│  Object Storage (S3/MinIO) — model artifacts (.h5, .pkl, .onnx)         │
│  Kafka/NATS — domain event bus (optional external)                      │
└──────────────────────────────────────────────────────────────────────────┘
```

### 1.1 Multi-Tenancy Strategy
| ด้าน | วิธี |
|---|---|
| **Isolation** | Schema-per-module (`tenant_fc`), Row-level via `tenant_id` + RLS |
| **Auth** | `app.current_tenant` GUC set ต่อ request |
| **Encryption** | TLS transit + AES-256 at-rest (TDE/pgcrypto) |
| **Backup** | PITR + WAL archiving แยกต่อ tenant (enterprise tier) |

### 1.2 Scalability Dimensions
| มิติ | Solution |
|---|---|
| **Read** | Read replica + Redis cache + materialized views |
| **Write** | Partitioning by `forecast_date` (monthly) |
| **ML compute** | Async worker (Celery/Arq) + GPU pool |
| **Event throughput** | Kafka partition by `aggregate_id` |
| **Hot path** | L1 LRU (in-process) → L2 Redis → Postgres |

### 1.3 Reliability
- **Idempotency**: `forecast_id` + `method` + `forecast_date` unique
- **Retry**: exponential backoff (3 attempts, jitter)
- **Circuit breaker**: ML service calls
- **Dead letter queue**: failed events → `forecast_dlq`
- **Graceful degradation**: cache miss + ML unavailable → return stale forecast

---

## 🗄️ 2. Database Design (Full)

### 2.1 Entity Relationship Diagram

```
                    ┌────────────────────┐
                    │  tenant_fc.forecasts│
                    │  ──────────────    │
                    │  id (PK)           │
                    │  tenant_id         │
                    │  product_id        │──┐
                    │  branch_id         │  │
                    │  forecast_date     │  │ 1
                    │  predicted_qty     │  │
                    │  actual_qty        │  │
                    │  method            │  │
                    │  mape              │  │
                    │  confidence        │  │
                    │  horizon_days      │  │
                    └─────────┬──────────┘  │
                              │ 1           │
                              │             │
             ┌────────────────┼─────────────┘
             │ N              │ N
   ┌─────────▼──────────┐  ┌──▼─────────────────┐
   │ forecast_events    │  │ forecast_audit_logs│
   │ ──────────────     │  │ ────────────────   │
   │ id (PK)            │  │ id (PK)            │
   │ aggregate_id (FK)  │  │ forecast_id (FK)   │
   │ event_type         │  │ sequence           │
   │ version            │  │ action             │
   │ payload (JSONB)    │  │ actor_id           │
   │ occurred_at        │  │ payload_hash       │
   │ UNIQUE(agg,ver)    │  │ prev_hash          │
   └────────────────────┘  │ entry_hash         │
                           │ UNIQUE(fid,seq)    │
                           └────────────────────┘

   ┌───────────────────────────────┐
   │ forecast_kpis                 │
   │ ─────────────                 │
   │ id (PK)                       │
   │ name · metric · target        │
   │ actual · direction            │
   │ period_start · period_end     │
   │ owner_id · relevant_to        │
   │ UNIQUE(name, period)          │
   └───────────────────────────────┘
```

### 2.2 DDL — ตาราง `forecasts` (core)

```sql
-- Partitioned by forecast_date (monthly)
CREATE TABLE tenant_fc.forecasts (
    id              UUID        NOT NULL DEFAULT gen_random_uuid(),
    tenant_id       UUID        NOT NULL,
    product_id      UUID        NOT NULL,
    branch_id       UUID        NOT NULL,
    forecast_date   DATE        NOT NULL,
    predicted_qty   NUMERIC(15,3) NOT NULL,
    actual_qty      NUMERIC(15,3),
    method          VARCHAR(20) NOT NULL DEFAULT 'LSTM',
    mape            NUMERIC(5,2),
    confidence      NUMERIC(5,4) NOT NULL DEFAULT 0,
    horizon_days    INTEGER     NOT NULL DEFAULT 30,
    version         INTEGER     NOT NULL DEFAULT 1,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    PRIMARY KEY (id, forecast_date),
    CONSTRAINT ck_pred_nonneg     CHECK (predicted_qty >= 0),
    CONSTRAINT ck_actual_nonneg   CHECK (actual_qty IS NULL OR actual_qty >= 0),
    CONSTRAINT ck_confidence      CHECK (confidence BETWEEN 0 AND 1),
    CONSTRAINT ck_horizon_pos     CHECK (horizon_days > 0),
    CONSTRAINT ck_mape_range      CHECK (mape IS NULL OR mape >= 0),
    CONSTRAINT uq_forecast        UNIQUE (tenant_id, product_id, branch_id,
                                          forecast_date, method)
) PARTITION BY RANGE (forecast_date);

-- Auto-create partitions (run monthly)
CREATE TABLE tenant_fc.forecasts_2026_01
    PARTITION OF tenant_fc.forecasts
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
CREATE TABLE tenant_fc.forecasts_2026_02
    PARTITION OF tenant_fc.forecasts
    FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');
-- ... (automated via pg_partman)

-- Indexes (per partition inherit)
CREATE INDEX ix_fc_product_date  ON tenant_fc.forecasts (product_id, forecast_date DESC);
CREATE INDEX ix_fc_branch_date   ON tenant_fc.forecasts (branch_id, forecast_date DESC);
CREATE INDEX ix_fc_method        ON tenant_fc.forecasts (method);
CREATE INDEX ix_fc_accuracy      ON tenant_fc.forecasts (mape)
                                 WHERE mape IS NOT NULL;
CREATE INDEX ix_fc_pending_actual ON tenant_fc.forecasts (forecast_date)
                                 WHERE actual_qty IS NULL;
-- BRIN for time-series scan
CREATE INDEX ix_fc_date_brin     ON tenant_fc.forecasts
                                 USING BRIN (forecast_date);

-- Trigger: update updated_at
CREATE OR REPLACE FUNCTION tenant_fc.touch_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); NEW.version = OLD.version + 1; RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_fc_touch
    BEFORE UPDATE ON tenant_fc.forecasts
    FOR EACH ROW EXECUTE FUNCTION tenant_fc.touch_updated_at();
```

### 2.3 DDL — `forecast_events` (Event Store)

```sql
CREATE TABLE tenant_fc.forecast_events (
    id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id     UUID        NOT NULL,
    aggregate_id  UUID        NOT NULL,
    event_type    VARCHAR(40) NOT NULL,
    version       INTEGER     NOT NULL CHECK (version >= 1),
    payload       JSONB       NOT NULL DEFAULT '{}'::jsonb,
    actor_id      UUID,
    correlation_id UUID,
    occurred_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_event_agg_ver UNIQUE (tenant_id, aggregate_id, version)
);

CREATE INDEX ix_evt_agg       ON tenant_fc.forecast_events (aggregate_id, version);
CREATE INDEX ix_evt_type_time ON tenant_fc.forecast_events (event_type, occurred_at DESC);
CREATE INDEX ix_evt_payload   ON tenant_fc.forecast_events USING GIN (payload jsonb_path_ops);

-- Append-only
REVOKE UPDATE, DELETE ON tenant_fc.forecast_events FROM PUBLIC;
```

### 2.4 DDL — `forecast_audit_logs` (Hash Chain)

```sql
CREATE TABLE tenant_fc.forecast_audit_logs (
    id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id     UUID        NOT NULL,
    forecast_id   UUID        NOT NULL,
    sequence      BIGINT      NOT NULL CHECK (sequence >= 1),
    action        VARCHAR(30) NOT NULL,
    actor_id      UUID,
    ip_address    INET,
    user_agent    TEXT,
    payload_hash  CHAR(64)    NOT NULL,   -- SHA-256 hex
    prev_hash     CHAR(64)    NOT NULL,   -- 'GENESIS' or hex
    entry_hash    CHAR(64)    NOT NULL,   -- SHA-256 hex
    occurred_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_audit_seq UNIQUE (tenant_id, forecast_id, sequence)
);

CREATE INDEX ix_audit_fid_seq ON tenant_fc.forecast_audit_logs (forecast_id, sequence);
CREATE INDEX ix_audit_actor   ON tenant_fc.forecast_audit_logs (actor_id, occurred_at DESC);
CREATE INDEX ix_audit_action  ON tenant_fc.forecast_audit_logs (action);

REVOKE UPDATE, DELETE ON tenant_fc.forecast_audit_logs FROM PUBLIC;
```

### 2.5 DDL — `forecast_kpis`

```sql
CREATE TABLE tenant_fc.forecast_kpis (
    id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id     UUID        NOT NULL,
    name          VARCHAR(120) NOT NULL,
    description   TEXT,
    metric        VARCHAR(30) NOT NULL,
    target        NUMERIC(15,3) NOT NULL CHECK (target >= 0),
    actual        NUMERIC(15,3),
    unit          VARCHAR(10) DEFAULT '%',
    direction     VARCHAR(20) NOT NULL DEFAULT 'LOWER_BETTER',
    period_start  DATE        NOT NULL,
    period_end    DATE        NOT NULL,
    owner_id      UUID,
    relevant_to   VARCHAR(120),
    last_eval_at  TIMESTAMPTZ,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT ck_period  CHECK (period_start <= period_end),
    CONSTRAINT ck_metric  CHECK (metric IN
        ('MAPE','ACCURACY','BIAS','COVERAGE','FRESHNESS_HOURS')),
    CONSTRAINT ck_dir     CHECK (direction IN ('LOWER_BETTER','HIGHER_BETTER')),
    CONSTRAINT uq_kpi     UNIQUE (tenant_id, name, period_start, period_end)
);

CREATE INDEX ix_kpi_period ON tenant_fc.forecast_kpis (period_start, period_end);
CREATE INDEX ix_kpi_owner  ON tenant_fc.forecast_kpis (owner_id);
```

### 2.6 Append-Only Enforcement

```sql
CREATE OR REPLACE FUNCTION tenant_fc.block_mutation()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'APPEND_ONLY_VIOLATION: table % cannot be % ',
        TG_TABLE_NAME, TG_OP
        USING ERRCODE = 'P0001';
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_evt_append_only
    BEFORE UPDATE OR DELETE ON tenant_fc.forecast_events
    FOR EACH ROW EXECUTE FUNCTION tenant_fc.block_mutation();

CREATE TRIGGER trg_audit_append_only
    BEFORE UPDATE OR DELETE ON tenant_fc.forecast_audit_logs
    FOR EACH ROW EXECUTE FUNCTION tenant_fc.block_mutation();
```

### 2.7 RLS Policies

```sql
ALTER TABLE tenant_fc.forecasts           ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenant_fc.forecast_events     ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenant_fc.forecast_audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenant_fc.forecast_kpis       ENABLE ROW LEVEL SECURITY;

CREATE POLICY p_fc_tenant ON tenant_fc.forecasts
    USING (tenant_id = current_setting('app.current_tenant', true)::uuid)
    WITH CHECK (tenant_id = current_setting('app.current_tenant', true)::uuid);

CREATE POLICY p_evt_tenant ON tenant_fc.forecast_events
    USING (tenant_id = current_setting('app.current_tenant', true)::uuid)
    WITH CHECK (tenant_id = current_setting('app.current_tenant', true)::uuid);

CREATE POLICY p_audit_tenant ON tenant_fc.forecast_audit_logs
    USING (tenant_id = current_setting('app.current_tenant', true)::uuid)
    WITH CHECK (tenant_id = current_setting('app.current_tenant', true)::uuid);

CREATE POLICY p_kpi_tenant ON tenant_fc.forecast_kpis
    USING (tenant_id = current_setting('app.current_tenant', true)::uuid)
    WITH CHECK (tenant_id = current_setting('app.current_tenant', true)::uuid);
```

### 2.8 Materialized Views (Analytics)

```sql
-- Daily accuracy rollup
CREATE MATERIALIZED VIEW tenant_fc.mv_forecast_accuracy_daily AS
SELECT
    tenant_id,
    product_id,
    branch_id,
    method,
    forecast_date,
    COUNT(*)                        AS samples,
    AVG(mape)                       AS avg_mape,
    MAX(mape)                       AS max_mape,
    AVG(error)                      AS avg_bias,
    SUM(CASE WHEN mape < 20 THEN 1 ELSE 0 END)::FLOAT
        / NULLIF(COUNT(*), 0)       AS accuracy_rate
FROM (
    SELECT *, (predicted_qty - actual_qty) AS error
    FROM tenant_fc.forecasts
    WHERE actual_qty IS NOT NULL
) t
GROUP BY tenant_id, product_id, branch_id, method, forecast_date;

CREATE UNIQUE INDEX ON tenant_fc.mv_forecast_accuracy_daily
    (tenant_id, product_id, branch_id, method, forecast_date);

-- Refresh hourly via cron
```

### 2.9 Partition Management (pg_partman)

```sql
CREATE EXTENSION IF NOT EXISTS pg_partman;

SELECT partman.create_parent(
    p_parent_table => 'tenant_fc.forecasts',
    p_control      => 'forecast_date',
    p_type         => 'range',
    p_interval     => '1 month',
    p_premake      => 3
);

-- Retention: 36 months hot, archive to cold storage afterwards
UPDATE partman.part_config
SET retention = '36 months',
    retention_keep_table = true
WHERE parent_table = 'tenant_fc.forecasts';
```

### 2.10 Backup / DR

| รายการ | นโยบาย |
|---|---|
| **Full backup** | รายวัน 02:00 UTC (retain 30 วัน) |
| **WAL archiving** | ต่อเนื่อง → S3 (RPO ≤ 5 นาที) |
| **PITR window** | 14 วัน |
| **Read replica** | 1 sync + 1 async (cross-AZ) |
| **DR drill** | รายไตรมาส (RTO ≤ 1 ชม.) |

---

## 💾 3. Cache Management (Full Design)

### 3.1 Cache Layers (3-Tier)

```
┌─────────────────────────────────────────────────────────────┐
│  L1  In-Process LRU (per worker)                            │
│  ├ tool: cachetools.LRUCache                                │
│  ├ size: 10,000 entries                                     │
│  ├ ttl:  30s                                                │
│  └ use:  hot items (< 1s latency needs)                     │
├─────────────────────────────────────────────────────────────┤
│  L2  Redis Cluster                                          │
│  ├ mode: cluster (3 shards × 2 replicas)                    │
│  ├ evict: allkeys-lru                                       │
│  ├ ttl:  varies 60s–24h (see table)                         │
│  └ use:  cross-worker shared                                │
├─────────────────────────────────────────────────────────────┤
│  L3  PostgreSQL Materialized Views                          │
│  ├ refresh: hourly / on-demand                              │
│  └ use:  heavy analytics & KPI evaluation                   │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Cache Key Naming Convention

```
fc:{tenant}:{resource}:{scope}:{hash}

Examples:
fc:t_01:forecast:p_42:b_07:d_2026-01-15:LSTM      → Forecast entity
fc:t_01:forecast_list:p_42:b_07:2026-01           → monthly list
fc:t_01:accuracy:p_42:2026-01                     → accuracy rollup
fc:t_01:kpi:scorecard:2026-01                     → KPI scorecard
fc:t_01:audit_chain:p_42:head                     → chain head
fc:t_01:model:LSTM:v3                             → model artifact
fc:t_01:lock:forecast:p_42:b_07                   → distributed lock
```

### 3.3 TTL Strategy (per resource)

| Resource | Key pattern | TTL | Invalidation |
|---|---|---|---|
| Forecast entity | `fc:*:forecast:{id}` | 1h | Write-through (delete) |
| Forecast list | `fc:*:forecast_list:*` | 30m | Tag-based delete |
| Accuracy rollup | `fc:*:accuracy:*` | 6h | On `update_actual` |
| KPI scorecard | `fc:*:kpi:scorecard:*` | 1h | Manual + on eval |
| Audit chain head | `fc:*:audit_chain:{id}:head` | 24h | Append (delete) |
| Model artifact meta | `fc:*:model:*` | 7d | Version bump |
| ML prediction temp | `fc:*:pred:*` | 5m | n/a |
| Idempotency key | `fc:*:idem:{key}` | 24h | n/a |

### 3.4 Cache Patterns

#### 3.4.1 Read-Through (default)
```python
async def get_forecast(self, forecast_id: str) -> Forecast:
    key = f"fc:{self.tenant}:forecast:{forecast_id}"
    # L1
    if cached := self.l1.get(key):
        return cached
    # L2
    if cached := await self.redis.get(key):
        self.l1[key] = cached
        return cached
    # L3
    entity = await self.repo.get_by_id(forecast_id)
    await self._set_multi(key, entity, ttl=3600)
    return entity
```

#### 3.4.2 Write-Through (invalidate + populate)
```python
async def update_actual(self, forecast_id, actual_qty):
    forecast = await self.repo.get_by_id(forecast_id)
    forecast.update_actual(actual_qty)
    forecast = await self.repo.save(forecast)
    # Invalidate dependent keys (tags)
    await self.cache.invalidate_tags([
        f"forecast:{forecast_id}",
        f"product:{forecast.product_id}",
        f"branch:{forecast.branch_id}",
    ])
    # Write-through
    await self._set_multi(f"fc:{self.tenant}:forecast:{forecast_id}",
                          forecast, ttl=3600)
    return forecast
```

#### 3.4.3 Stampede Protection (distributed lock)
```python
async def _get_or_compute(self, key, ttl, compute_fn):
    # Try L1/L2 fast path
    if v := await self._multi_get(key):
        return v
    # Acquire lock
    lock_key = f"{key}:lock"
    async with self.redis.lock(lock_key, timeout=10, blocking_timeout=5):
        # Double-check
        if v := await self._multi_get(key):
            return v
        v = await compute_fn()
        await self._set_multi(key, v, ttl)
        return v
```

#### 3.4.4 Tag-Based Invalidation
```python
class TaggedCache:
    """Group cache keys by tags → bulk invalidate."""

    async def set(self, key, value, ttl, tags: list[str]):
        await self.redis.setex(key, ttl, value)
        for tag in tags:
            await self.redis.sadd(f"tag:{tag}", key)
            await self.redis.expire(f"tag:{tag}", ttl + 60)

    async def invalidate_tag(self, tag: str):
        keys = await self.redis.smembers(f"tag:{tag}")
        if keys:
            await self.redis.delete(*keys)
        await self.redis.delete(f"tag:{tag}")
```

### 3.5 Cache Cluster Topology

```
Redis Cluster (3 shards × 2 replicas)
├── shard-0: master @az-a · replica @az-b
├── shard-1: master @az-b · replica @az-c
└── shard-2: master @az-c · replica @az-a

Config:
  maxmemory: 8GB
  maxmemory-policy: allkeys-lru
  appendonly: yes (AOF everysec)
  save: 900 1 / 300 10 / 60 10000
  tcp-keepalive: 300
```

### 3.6 Cache Metrics (Prometheus)

```
fc_cache_hits_total{layer="l1|l2",resource="forecast|kpi|audit"}
fc_cache_misses_total{layer,resource}
fc_cache_latency_seconds{layer,quantile}
fc_cache_evictions_total{layer}
fc_cache_size_bytes{layer}
fc_cache_stampede_prevented_total
fc_cache_invalidations_total{tag}
```

### 3.7 Invalidation Matrix

| Event | Invalidates |
|---|---|
| `generate_forecast` | `forecast_list:*`, `accuracy:*`, `kpi:scorecard:*` |
| `update_actual` | `forecast:{id}`, `forecast_list:*`, `accuracy:*`, `kpi:scorecard:*` |
| `backtest` | `accuracy:*` |
| `append_audit` | `audit_chain:{id}:head` |
| `evaluate_kpis` | `kpi:scorecard:*`, `kpi:{id}` |
| Model retrain | `model:*`, `accuracy:*` |
| **Tenant purge** | `fc:{tenant}:*` (SCAN + DEL) |

### 3.8 Cache Config (`config.py`)

```python
class CacheConfig(BaseSettings):
    # L1
    l1_size: int = 10_000
    l1_ttl_sec: int = 30
    # L2
    redis_url: str = "redis://redis-cluster:6379/0"
    redis_max_connections: int = 100
    redis_socket_timeout: float = 1.0
    redis_socket_connect_timeout: float = 1.0
    redis_retry_on_timeout: bool = True
    # Default TTLs
    ttl_forecast: int = 3600
    ttl_list: int = 1800
    ttl_accuracy: int = 21600
    ttl_kpi: int = 3600
    ttl_audit_head: int = 86400
    ttl_model: int = 604800
    # Lock
    lock_timeout: int = 10
    lock_block_timeout: int = 5
    # Feature flags
    cache_enabled: bool = True
    cache_warm_on_startup: bool = True
```

---

## 🧩 4. Domain Layer (Full)

### 4.1 Entities

```python
# domain/entities/forecast.py
@dataclass
class Forecast(BaseEntity):
    product_id: str = ""
    branch_id: str = ""
    forecast_date: date | None = None
    predicted_qty: Decimal = Decimal("0.000")
    actual_qty: Decimal | None = None
    method: str = "LSTM"
    mape: Decimal | None = None
    confidence: Decimal = Decimal("0.00")
    horizon_days: int = 30

    def _validate(self):
        if self.predicted_qty < 0:
            raise DomainError("predicted_qty < 0")
        if self.actual_qty is not None and self.actual_qty < 0:
            raise DomainError("actual_qty < 0")
        if not (0 <= self.confidence <= 1):
            raise DomainError("confidence out of [0,1]")
        if self.horizon_days <= 0:
            raise DomainError("horizon_days must be > 0")

    def update_actual(self, actual_qty: Decimal) -> None: ...
    def is_accurate(self, threshold: Decimal = Decimal("20")) -> bool: ...
    def error(self) -> Decimal | None: ...
```

```python
# domain/entities/forecast_event.py
@dataclass
class ForecastEvent(BaseEntity):
    aggregate_id: str = ""
    event_type: str = ""
    version: int = 0
    payload: dict = field(default_factory=dict)
    actor_id: str = ""
    correlation_id: str | None = None
    occurred_at: datetime | None = None
```

```python
# domain/entities/forecast_audit_log.py
@dataclass
class ForecastAuditLog(BaseEntity):
    forecast_id: str = ""
    sequence: int = 0
    action: str = "CREATE"
    actor_id: str = ""
    ip_address: str | None = None
    payload_hash: str = ""
    prev_hash: str = ""
    entry_hash: str = ""
    occurred_at: datetime | None = None

    def compute_entry_hash(self) -> str: ...
    def seal(self) -> None: ...
    def is_valid(self) -> bool: ...
```

```python
# domain/entities/forecast_kpi.py
@dataclass
class ForecastKPI(BaseEntity):
    name: str = ""
    description: str = ""
    metric: str = "MAPE"
    target: Decimal = Decimal("20")
    actual: Decimal | None = None
    unit: str = "%"
    direction: str = "LOWER_BETTER"
    period_start: date | None = None
    period_end: date | None = None
    owner_id: str = ""
    relevant_to: str = ""

    def is_smart(self) -> bool: ...
    def is_achieved(self) -> bool: ...
    def progress_pct(self) -> Decimal: ...
```

### 4.2 Value Objects

```python
@dataclass(frozen=True)
class ForecastResult:
    predicted: Decimal
    actual: Decimal | None
    error: Decimal | None
    mape: Decimal | None
    confidence: Decimal

@dataclass(frozen=True)
class ForecastHorizon:
    days: int
    granularity: str  # DAY|WEEK|MONTH

@dataclass(frozen=True)
class HashChain:
    prev_hash: str
    entry_hash: str
    sequence: int

@dataclass(frozen=True)
class AccuracyScore:
    mape: Decimal
    accuracy: Decimal      # 100 - MAPE
    bias: Decimal
    samples: int
    def grade(self) -> str:  # A/B/C/D
        ...
```

### 4.3 Domain Events (7 events)

| Event | Trigger | Payload |
|---|---|---|
| `ForecastGenerated` | generate_forecast | product_id, branch_id, method, count |
| `ForecastUpdated` | update_actual | forecast_id, new_mape |
| `ForecastAccuracyDropped` | mape > 20 | forecast_id, mape |
| `ForecastAuditAppended` | every write | forecast_id, seq, hash |
| `ForecastKPIUpdated` | evaluate_kpis | kpi, actual, achieved |
| `ForecastKPITargetBreached` | !is_achieved | kpi, target, actual |
| `ForecastChainBroken` 🚨 | verify fail | forecast_id, reason |

### 4.4 Invariants (ทั้งหมด)

| # | Invariant | Enforcement |
|---|---|---|
| 1 | `predicted_qty >= 0` | `_validate()` + DB CHECK |
| 2 | `actual_qty >= 0` (or null) | `_validate()` + DB CHECK |
| 3 | `0 <= confidence <= 1` | `_validate()` + DB CHECK |
| 4 | `MAPE < 20%` ⇒ accurate | `is_accurate()` |
| 5 | `error == predicted - actual` | `error()` |
| 6 | `hash_chain_valid` | `verify_audit_chain()` |
| 7 | `sequence_continuous` | `verify_audit_chain()` |
| 8 | `append_only` | DB trigger |
| 9 | `kpi_smart` | `is_smart()` |
| 10 | `event_version_monotonic` | UNIQUE + service |

---

## ⚙️ 5. Application Layer (Full)

### 5.1 Use Cases List

| Use Case | Input | Output | Cache | Audit | Events |
|---|---|---|---|---|---|
| `generate_forecast` | product, branch, days, method | list[Forecast] | invalidate | ✅ | ✅ |
| `get_forecasts` | product, from_date, to_date | list[Forecast] | read-through | ❌ | ❌ |
| `update_actual` | forecast_id, actual_qty | Forecast | write-through | ✅ | ✅ |
| `backtest` | product, days, method | BacktestResult | cached 6h | ❌ | ❌ |
| `get_accuracy` | product, period | AccuracyScore | cached 6h | ❌ | ❌ |
| `get_audit_trail` | forecast_id | list[AuditLog] | read-through 24h | ❌ | ❌ |
| `verify_audit_chain` | forecast_id | ChainStatus | no-cache | ✅ | ✅ if fail |
| `replay_events` | forecast_id | list[Event] | no-cache | ❌ | ✅ |
| `evaluate_kpis` | period | list[KPI] | invalidate | ✅ | ✅ |
| `get_kpi_scorecard` | period | Scorecard | cached 1h | ❌ | ❌ |
| `schedule_retrain` | product, method | Job | n/a | ✅ | ✅ |

### 5.2 Service Composition (DI)

```python
def get_forecast_use_cases(
    repo: ForecastRepository = Depends(get_forecast_repo),
    analytics_repo = Depends(get_analytics_repo),
    ml_service = Depends(get_ml_service),
    cache = Depends(get_forecast_cache),
    audit = Depends(get_audit_service),
    events = Depends(get_event_bus),
    ledger_repo = Depends(get_ledger_repo),
    kpi_repo = Depends(get_kpi_repo),
    hash_service = Depends(get_hash_service),
) -> ForecastUseCases:
    return ForecastUseCases(
        repo, analytics_repo, ml_service, cache, audit, events,
        ledger_repo, kpi_repo, hash_service,
    )
```

---

## 🏗️ 6. Infrastructure Layer (Full)

### 6.1 Repositories

```python
class PostgresForecastRepository(ForecastRepository):
    async def save(self, f: Forecast) -> Forecast: ...
    async def get_by_id(self, id: str) -> Forecast | None: ...
    async def list_by_product(self, pid, from_date, to_date) -> list[Forecast]: ...
    async def avg_mape(self, start, end) -> Decimal: ...
    async def avg_bias(self, start, end) -> Decimal: ...
    async def coverage_pct(self, start, end) -> Decimal: ...
    async def freshness_hours(self) -> Decimal: ...

class EventStoreRepository:
    async def append_event(self, evt: ForecastEvent) -> ForecastEvent: ...
    async def list_events(self, agg_id) -> list[ForecastEvent]: ...
    async def last_event(self, agg_id) -> ForecastEvent | None: ...

class AuditLogRepository:
    async def append(self, log: ForecastAuditLog) -> ForecastAuditLog: ...
    async def list_by_forecast(self, fid) -> list[ForecastAuditLog]: ...
    async def head(self, fid) -> ForecastAuditLog | None: ...

class KPIRepository:
    async def save(self, kpi) -> ForecastKPI: ...
    async def list_by_period(self, start, end) -> list[ForecastKPI]: ...
```

### 6.2 ML Forecast Service

```python
class MLForecastService:
    SUPPORTED = {"LSTM", "PROPHET", "XGBOOST", "ARIMA", "ENSEMBLE"}

    async def predict(self, data, days, method) -> list[dict]:
        if method not in self.SUPPORTED:
            raise DomainError(f"Unsupported method: {method}")
        handler = getattr(self, f"_{method.lower()}")
        return await handler(data, days)

    async def _lstm(self, data, days): ...
    async def _prophet(self, data, days): ...
    async def _xgboost(self, data, days): ...
    async def _arima(self, data, days): ...
    async def _ensemble(self, data, days):
        results = await asyncio.gather(
            self._lstm(data, days),
            self._prophet(data, days),
            self._xgboost(data, days),
        )
        # weighted mean by historical MAPE
        ...
```

### 6.3 Ledger Adapter (Pluggable)

```python
# base.py
class LedgerAdapter(Protocol):
    async def append(self, log: ForecastAuditLog) -> ForecastAuditLog: ...
    async def list_by_forecast(self, fid: str) -> list[ForecastAuditLog]: ...
    async def head(self, fid: str) -> ForecastAuditLog | None: ...

# postgres_adapter.py  (default)
class PostgresLedgerAdapter(LedgerAdapter):
    ...uses tenant_fc.forecast_audit_logs...

# qldb_adapter.py  (option)
class QLDBLedgerAdapter(LedgerAdapter):
    """Uses Amazon QLDB — cryptographic verifiable journal."""
    ...

# hyperledger_adapter.py  (option)
class HyperledgerLedgerAdapter(LedgerAdapter):
    """Uses Hyperledger Fabric — consortium ledger."""
    ...
```

เลือกผ่าน env: `LEDGER_BACKEND=postgres|qldb|fabric`

### 6.4 Cache Layer

```python
class ForecastCache:
    """L1 (LRU) + L2 (Redis) + tag invalidation + stampede lock."""
    def __init__(self, config: CacheConfig):
        self.l1 = LRUCache(maxsize=config.l1_size)
        self.redis = Redis.from_url(config.redis_url)
        self.cfg = config

    async def get(self, key, resource) -> Any | None: ...
    async def set(self, key, value, ttl, tags=None) -> None: ...
    async def delete(self, *keys) -> int: ...
    async def invalidate_tag(self, tag) -> int: ...
    async def get_or_compute(self, key, ttl, fn, tags=None) -> Any: ...
```

### 6.5 Event Bus

```python
class EventBus:
    async def publish(self, event_type: str, payload: dict) -> None:
        # Persist first (outbox pattern)
        await self.outbox.save(event_type, payload)
        # Publish async
        await self.producer.send(self.topic, key=payload.get("aggregate_id"),
                                 value=payload)
```

**Transactional Outbox** — รับประกัน at-least-once + atomicity กับ DB transaction

---

## 🎛️ 7. Presentation Layer (Full)

### 7.1 Endpoints (v2)

| Method | Path | Purpose | Cache |
|---|---|---|---|
| `POST` | `/api/v1/forecast/generate/` | Generate | invalidate |
| `GET` | `/api/v1/forecast/{product_id}/` | List | read-through |
| `PATCH` | `/api/v1/forecast/{id}/actual/` | Update actual | write-through |
| `POST` | `/api/v1/forecast/backtest/` | Backtest | cached 6h |
| `GET` | `/api/v1/forecast/accuracy/{product_id}/` | Accuracy | cached 6h |
| `GET` | `/api/v1/forecast/{id}/audit/` | Audit trail | read-through |
| `POST` | `/api/v1/forecast/{id}/audit/verify/` | Verify chain | no-cache |
| `POST` | `/api/v1/forecast/{id}/replay/` | Event replay | no-cache |
| `POST` | `/api/v1/forecast/kpi/evaluate/` | Evaluate KPIs | invalidate |
| `GET` | `/api/v1/forecast/kpi/scorecard/` | Scorecard | cached 1h |
| `GET` | `/api/v1/forecast/{id}/integrity/` | Full integrity check | no-cache |

### 7.2 Example: Generate

```python
@router.post("/generate/", response_model=list[ForecastResponse])
@limiter.limit("30/minute")
async def generate(
    payload: ForecastGenerateRequest,
    request: Request,
    uc: ForecastUseCases = Depends(get_forecast_use_cases),
    user: User = Depends(current_user),
):
    """
    Generate forecast — สร้างพยากรณ์
    Side effects: invalidates list/accuracy/kpi caches
    """
    return await uc.generate_forecast(
        product_id=payload.product_id,
        branch_id=payload.branch_id,
        days=payload.days,
        method=payload.method,
    )
```

### 7.3 Schemas

```python
class ForecastGenerateRequest(BaseModel):
    product_id: UUID
    branch_id: UUID
    days: int = Field(30, ge=1, le=365)
    method: ForecastMethod = ForecastMethod.LSTM

class ForecastResponse(BaseModel):
    id: UUID
    product_id: UUID
    branch_id: UUID
    forecast_date: date
    predicted_qty: Decimal
    actual_qty: Decimal | None
    mape: Decimal | None
    confidence: Decimal
    method: str

class ChainVerifyResponse(BaseModel):
    valid: bool
    entries: int
    head: str
    reason: str | None = None

class ScorecardResponse(BaseModel):
    period_start: date
    period_end: date
    score: Decimal        # 0..1
    grade: str            # A/B/C/D
    kpis: list[KPIResponse]
```

---

## 📊 8. Observability

### 8.1 Metrics (Prometheus)

| Metric | Type | Labels |
|---|---|---|
| `fc_forecast_generated_total` | counter | tenant, method |
| `fc_forecast_mape` | histogram | method, product |
| `fc_forecast_accuracy_rate` | gauge | tenant, period |
| `fc_audit_appended_total` | counter | tenant, action |
| `fc_chain_verify_total` | counter | tenant, result |
| `fc_kpi_achieved_total` | counter | tenant, kpi |
| `fc_ml_predict_seconds` | histogram | method |
| `fc_cache_hits_total` | counter | layer, resource |
| `fc_cache_misses_total` | counter | layer, resource |

### 8.2 Logs (Structured)

```json
{
  "ts": "2026-01-15T10:23:45Z",
  "level": "INFO",
  "module": "forecast",
  "event": "generate_forecast",
  "tenant_id": "t_01",
  "product_id": "p_42",
  "method": "LSTM",
  "count": 30,
  "duration_ms": 234,
  "correlation_id": "req-abc-123"
}
```

### 8.3 Traces (OpenTelemetry)

```
[generate_forecast]
  ├─ analytics_repo.get_history (12ms)
  ├─ ml_service.predict          (180ms)
  │   └─ _lstm                    (170ms)
  ├─ repo.save × 30              (35ms)
  ├─ audit.append × 30            (8ms)
  └─ events.publish               (3ms)
```

### 8.4 Alerts

| Alert | Condition | Severity |
|---|---|---|
| High MAPE | `avg(mape) > 20 for 1h` | warning |
| Chain broken | `ChainBroken` event | critical |
| Cache stampede | `fc_cache_stampede_prevented > 100/min` | warning |
| ML latency | `p99(fc_ml_predict_seconds) > 5s` | warning |
| Event lag | `kafka_consumer_lag > 10000` | critical |
| KPI breach | `KPITargetBreached` × 3 consecutive | warning |

---

## 🔐 9. Security & Compliance

| ด้าน | มาตรการ |
|---|---|
| **AuthN** | OAuth2 + JWT (RS256), refresh token |
| **AuthZ** | RBAC (`forecast:read`, `forecast:write`, `forecast:audit`) |
| **Tenant isolation** | RLS + `app.current_tenant` GUC |
| **Audit immutability** | Hash chain + DB trigger + REVOKE |
| **Encryption** | TLS 1.3 + pgcrypto for PII columns |
| **Rate limiting** | Redis token bucket per tenant/user |
| **Input validation** | Pydantic v2 strict mode |
| **OWASP** | ASVS L2 compliance |
| **GDPR/PDPA** | Right to erasure → tombstone (not delete) with reason |
| **SOC2** | Audit trail covers CC7.2, CC7.3 |

---

## 🧪 10. Test Matrix

| Layer | Type | Coverage target |
|---|---|---|
| Domain | Unit | 100% |
| Domain | Property (hypothesis) | invariants |
| Application | Unit (mocked) | 95% |
| Infrastructure | Integration (testcontainers) | 80% |
| Presentation | Contract (schemathesis) | 90% |
| E2E | Manual + auto | critical paths |
| Perf | Locust (1000 RPS) | p95 < 200ms |
| Chaos | toxiproxy (redis down, pg fail) | graceful degrade |

---

## 📁 11. File Tree (36 ไฟล์)

```
app/modules/forecast/
├── __init__.py
├── domain/
│   ├── __init__.py
│   ├── entities/
│   │   ├── __init__.py
│   │   ├── forecast.py
│   │   ├── forecast_event.py
│   │   ├── forecast_audit_log.py
│   │   └── forecast_kpi.py
│   ├── value_objects.py
│   ├── enums.py
│   ├── events.py
│   ├── exceptions.py
│   └── invariants.py
├── application/
│   ├── __init__.py
│   ├── use_cases.py
│   ├── services/
│   │   ├── audit_service.py
│   │   ├── hash_chain_service.py
│   │   └── kpi_service.py
│   ├── mappers.py
│   ├── exceptions.py
│   └── utils.py
├── infrastructure/
│   ├── __init__.py
│   ├── models.py
│   ├── repositories.py
│   ├── caches.py
│   ├── services.py
│   ├── event_bus.py
│   ├── outbox.py
│   └── ledger/
│       ├── __init__.py
│       ├── base.py
│       ├── postgres_adapter.py
│       ├── qldb_adapter.py
│       └── hyperledger_adapter.py
└── presentation/
    ├── __init__.py
    ├── routers.py
    ├── schemas.py
    ├── dependencies.py
    └── docs.py

db/migrations/
├── V001__create_forecast.sql
├── V002__seed_forecast.sql
├── V003__rollback_forecast.sql
├── V004__create_forecast_ledger.sql
├── V005__seed_forecast_kpis.sql
├── V006__append_only_triggers.sql
├── V007__rls_policies.sql
├── V008__partitions.sql
└── V009__materialized_views.sql

tests/
├── unit/
│   ├── test_forecast_entity.py
│   ├── test_audit_chain.py
│   ├── test_kpi_smart.py
│   └── test_use_cases.py
├── integration/
│   ├── test_forecast_repository.py
│   ├── test_append_only_trigger.py
│   ├── test_rls.py
│   └── test_cache.py
├── property/
│   ├── test_forecast_invariants.py
│   └── test_append_only.py
└── manual/
    └── manual_test_forecast.md
```

---

## 🚀 12. Deployment

### 12.1 Kubernetes Resources

```yaml
# Deployment (API)
apiVersion: apps/v1
kind: Deployment
metadata: { name: forecast-api }
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: api
          image: erp/forecast:v2.0
          env:
            - { name: LEDGER_BACKEND, value: postgres }
            - { name: REDIS_URL, valueFrom: { secretKeyRef: { name: redis, key: url } } }
          resources:
            requests: { cpu: 500m, memory: 512Mi }
            limits:   { cpu: 2000m, memory: 2Gi }
          livenessProbe:  { httpGet: { path: /healthz, port: 8000 } }
          readinessProbe: { httpGet: { path: /readyz,  port: 8000 } }
---
# Worker (ML)
apiVersion: apps/v1
kind: Deployment
metadata: { name: forecast-ml-worker }
spec:
  replicas: 2
  template:
    spec:
      containers:
        - name: worker
          image: erp/forecast-ml:v2.0
          resources:
            limits: { nvidia.com/gpu: 1 }
---
# CronJob (KPI evaluation)
apiVersion: batch/v1
kind: CronJob
metadata: { name: kpi-eval }
spec:
  schedule: "0 * * * *"   # hourly
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: eval
              image: erp/forecast:v2.0
              command: ["python", "-m", "forecast.jobs.evaluate_kpis"]
---
# CronJob (Chain verification)
apiVersion: batch/v1
kind: CronJob
metadata: { name: chain-verify }
spec:
  schedule: "0 3 * * *"   # daily 03:00
  ...
```

### 12.2 Environment Variables

```env
# App
APP_ENV=production
LOG_LEVEL=INFO

# Database
DB_URL=postgresql+asyncpg://fc_user:pwd@pg-primary:5432/erp
DB_READ_URL=postgresql+asyncpg://fc_user:pwd@pg-replica:5432/erp
DB_POOL_SIZE=20
DB_MAX_OVERFLOW=40

# Redis
REDIS_URL=redis://redis-cluster:6379/0
REDIS_CLUSTER=true

# ML
ML_SERVICE_URL=http://ml-inference:8080
ML_TIMEOUT_SEC=30

# Ledger
LEDGER_BACKEND=postgres   # | qldb | fabric
QLDB_LEDGER_NAME=erp-audit

# Feature flags
FEATURE_KPI=true
FEATURE_AUDIT=true
FEATURE_EVENT_SOURCING=true
CACHE_ENABLED=true
```

---

## ✅ 13. Summary Checklist

| มิติ | ครบ? | รายละเอียด |
|---|---|---|
| **Domain** | ✅ | 4 entities, 4 VOs, 3 enums, 7 events, 10 invariants |
| **Application** | ✅ | 11 use cases, 3 services, mappers, DTOs |
| **Infrastructure** | ✅ | 4 repos, cache, event bus, outbox, 3 ledger adapters, ML service |
| **Presentation** | ✅ | 11 endpoints, schemas, DI, rate limit |
| **Database** | ✅ | 4 tables, partitioning, RLS, triggers, MV, pg_partman |
| **Cache** | ✅ | L1+L2, 8 TTL classes, tag invalidation, stampede lock, metrics |
| **Audit** | ✅ | Hash chain SHA-256, append-only, verification, QLDB/Fabric option |
| **KPI** | ✅ | SMART framework, 5 metrics, scorecard, alerts |
| **Observability** | ✅ | Metrics, logs, traces, alerts |
| **Security** | ✅ | RLS, JWT, RBAC, encryption, PDPA |
| **Deployment** | ✅ | K8s manifests, cronjobs, env config |
| **Testing** | ✅ | Unit, integration, property, E2E, perf, chaos |

---

 