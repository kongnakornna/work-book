## เล่ม 9: ERP Database Operations — "สาย DBA / ERP Support"

> **กลุ่มงาน:** DBA, ERP Support, Data Engineer
> **Dependency:** อ่านเล่ม 1 (Foundation & Workflow) และเล่ม 4 (Log & Time-Series Analytics) ก่อน
> **เวอร์ชัน:** 1.0


## บทนำ

### วัตถุประสงค์ของเล่ม

ERP มักใช้ **หลายฐานข้อมูลพร้อมกัน** — PostgreSQL สำหรับ Service ใหม่, Oracle สำหรับ Core ที่มีอายุยาว, MSSQL สำหรับ Reporting, และ MongoDB สำหรับ Document/NoSQL เล่มนี้ครอบคลุม **Database Operations & Observability** ของทั้ง 4 ระบบ เพื่อให้ DBA และ ERP Support วินิจฉัยปัญหา **Cross-Database** ได้ เมื่ออ่านจบ ผู้อ่านจะสามารถ:

1. ติดตั้ง **Exporter** ของแต่ละฐานข้อมูล (postgres_exporter, oracledb_exporter, mssql-prometheus-exporter, mongodb_exporter) และเชื่อมต่อ Prometheus
2. เข้าใจ **Metrics ที่สำคัญ** ของแต่ละฐานข้อมูล (Connection, Query Performance, Replication, Locks, Vacuum/Bloat)
3. เขียน **PromQL และ Alert Rules** ที่ actionable
4. ใช้ **Diagnostic Tools** เฉพาะของแต่ละ DB (pg_stat_statements, AWR/ASH, DMV, WiredTiger)
5. ใช้ **Incident Playbook** สำหรับ Database Incident ที่พบบ่อย

### เป้าหมายของเล่ม

| เป้าหมาย | ตัวชี้วัดความสำเร็จ |
|---|---|
| Connection ไม่เต็ม | Alert `ConnectionSaturation` fire ที่ 85% |
| Replication Lag < 30s | Alert `ReplicationLagHigh` fire เมื่อ lag > 30s |
| ไม่มี Disk Full จาก WAL/Redo | Alert `ReplicationSlotLag` / `TablespaceHigh` fire |
| Deadlock ตรวจพบเร็ว | Alert `DeadlockDetected` fire ภายใน 2 นาที |
| Slow Query มีข้อมูล | `pg_stat_statements` / AWR / DMV ทำงาน |

### สิ่งที่ **ไม่** อยู่ในเล่มนี้

- Database Schema Design / DDD Aggregate → **เล่ม 8**
- Prometheus/Grafana ติดตั้ง → **เล่ม 3**
- Log Analysis (ELK) → **เล่ม 4**
- Integration Patterns (Outbox, Saga) → **เล่ม 10**

### ทำไมทั้ง 4 ฐานข้อมูลอยู่เล่มเดียวกัน

ERP ในองค์กรขนาดกลาง-ใหญ่ **มักใช้หลายฐานข้อมูลพร้อมกัน** แต่ละตัวมีจุดแข็งต่างกัน:

| Database | ใช้ใน ERP | จุดแข็ง |
|---|---|---|
| **PostgreSQL** | Service ใหม่, Microservice, JSONB | Open-source, Extension เยอะ, ACID |
| **Oracle** | Core ERP (Finance, HR) | Reliability สูง, AWR/ASH ทรงพลัง |
| **MSSQL** | Reporting, BI, Integration | T-SQL, SSRS/SSIS, Always On |
| **MongoDB** | Document, Catalog, Log | Flexible schema, Horizontal scale |

Support ต้องเข้าใจ **ทั้งสี่** เพื่อวินิจฉัยปัญหา Cross-Database (เช่น ERP Service เขียน PostgreSQL แต่ Report อ่าน MSSQL — ถ้า Sync ช้า จะเห็นได้จาก Metrics ของทั้งคู่)


## บทนิยาม (เฉพาะคำศัพท์ใหม่ในเล่มนี้)

### PostgreSQL

| คำศัพท์ | ความหมาย |
|---|---|
| **`pg_stat_statements`** | Extension ที่ track query performance (ต้อง `shared_preload_libraries`) |
| **`pg_stat_activity`** | View แสดง session ที่กำลังทำงาน |
| **`pg_stat_replication`** | View แสดงสถานะ replication (lag, state) |
| **`pg_replication_slots`** | Slot ที่เก็บ WAL สำหรับ Replica — ถ้า inactive จะสะสม WAL |
| **Bloat** | พื้นที่ที่ dead tuple ยังไม่ถูก vacuum — ทำให้ Table โตโดยไม่จำเป็น |
| **`autovacuum`** | Process ที่ลบ dead tuple อัตโนมัติ |
| **Transaction ID Wraparound** | `age(datfrozenxid)` ใกล้ 2 พันล้าน → Database shutdown (ภัยร้ายแรง) |
| **Cache Hit Ratio** | `blks_hit / (blks_hit + blks_read)` — ควร > 99% สำหรับ OLTP |
| **PgBouncer** | Connection pooler สำหรับ PostgreSQL |

### Oracle

| คำศัพท์ | ความหมาย |
|---|---|
| **AWR (Automatic Workload Repository)** | Snapshot ประสิทธิภาพทุก 1 ชั่วโมง (เก็บ 8 วัน default) |
| **ASH (Active Session History)** | ข้อมูล Session ที่ active ทุก 1 วินาที |
| **ADDM (Automatic Database Diagnostic Monitor)** | วิเคราะห์ AWR หา Root Cause |
| **Tablespace** | หน่วยเก็บข้อมูล (เปรียบเหมือน Tablespace ใน Oracle) |
| **Wait Class** | หมวดหมู่ของ Wait Event (Application, Concurrency, Network, User I/O) |
| **SGA (System Global Area)** | Shared Memory ของ Oracle |
| **`oracledb_exporter`** | Prometheus Exporter สำหรับ Oracle (Go) |

### MSSQL

| คำศัพท์ | ความหมาย |
|---|---|
| **DMV (Dynamic Management View)** | View พิเศษที่แสดงสถานะภายในของ SQL Server |
| **`sys.dm_os_wait_stats`** | สถิติการรอ (Wait Statistics) |
| **`sys.dm_exec_requests`** | Request ที่กำลังทำงาน |
| **Always On Availability Group** | HA/DR Solution ของ MSSQL (คล้าย Replication) |
| **Blocking** | Session หนึ่งรอ Lock ที่ Session อื่นถือ |
| **Deadlock** | Circular wait — SQL Server เลือก Victim 1 ตัว |
| **`mssql-prometheus-exporter`** | Exporter อย่างเป็นทางการจาก Microsoft |

### MongoDB

| คำศัพท์ | ความหมาย |
|---|---|
| **Replica Set** | กลุ่ม Node (Primary + Secondary) ที่ sync ข้อมูล |
| **Sharded Cluster** | Cluster ที่แบ่งข้อมูลตาม Shard Key |
| **Oplog** | Operation Log — ใช้สำหรับ Replication |
| **WiredTiger** | Storage Engine ของ MongoDB (ตั้งแต่ 3.0) |
| **Cache Dirty Bytes** | ข้อมูลที่ยังไม่ flush ลง Disk — ถ้า > 20% = เสี่ยง |
| **`mongodb_exporter`** | Prometheus Exporter (Percona) |


## บทหัวข้อ


## 9.1 PostgreSQL (Performance Tuning, Index, Vacuum, Replication, Monitoring)

### เรื่อง
Database Operations & Observability สำหรับ PostgreSQL — ฐานข้อมูลหลักของ ERP Service ใหม่

### วัตถุประสงค์ / เป้าหมาย
- เห็น **Connection Saturation** ก่อน pool เต็ม
- เห็น **Replication Lag** และ **Replication Slot** ที่ค้าง
- เห็น **Vacuum/Bloat** ก่อน Table โตผิดปกติ
- เห็น **Slow Query** จาก `pg_stat_statements`

### เนื้อหา / รายละเอียด

#### 5 เสาหลักของ PostgreSQL Monitoring

| เสา | สิ่งที่ Monitor | เครื่องมือ |
|---|---|---|
| **1. Connections** | `numbackends / max_connections`, idle in transaction | `pg_stat_activity` |
| **2. Query Performance** | Slow query, total exec time | `pg_stat_statements` |
| **3. Vacuum & Bloat** | `n_dead_tup`, `last_autovacuum`, `age(datfrozenxid)` | `pg_stat_user_tables` |
| **4. Replication** | `replay_lag`, `pg_replication_slots` | `pg_stat_replication` |
| **5. Locks** | Blocked queries, lock waits | `pg_stat_activity` + `pg_blocking_pids()` |

#### Metrics ที่ต้อง Monitor

| Metric | Healthy | Alert |
|---|---|---|
| `numbackends / max_connections` | < 70% | **85%** (Critical) |
| Idle in transaction (oldest) | < 60s | **10 min** |
| Cache hit ratio | > 99% (OLTP) | < 95% |
| `n_dead_tup / n_live_tup` | < 10% | **> 20%** (Bloat) |
| `age(datfrozenxid)` | ห่างจาก 2B มาก | **> 1.5B** (Wraparound) |
| Replication lag | < 1s | **> 30s** (Critical) |
| Inactive replication slot WAL | 0 | **> 1GB** (Disk Full Risk) |
| Deadlocks | 0 | **> 5/min** |

### การติดตั้ง / การตั้งค่า

#### เปิด `pg_stat_statements`

```sql
-- postgresql.conf
shared_preload_libraries = 'pg_stat_statements'
pg_stat_statements.track = all
pg_stat_statements.max = 10000

-- แล้ว restart PostgreSQL
-- จากนั้น:
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
```

#### สร้าง Monitoring User

```sql
CREATE USER prometheus WITH PASSWORD 'StrongPassword';
GRANT pg_monitor TO prometheus;  -- แนะนำ (ไม่ต้อง superuser)
-- หรือ grant SELECT บน view ที่ต้องการ
GRANT SELECT ON pg_stat_statements TO prometheus;
```

> **กฎ:** ใช้ `pg_monitor` role — **ห้ามใช้ superuser** สำหรับ monitoring

#### Docker Compose (`postgres_exporter`)

```yaml
  postgres-exporter:
    image: prometheuscommunity/postgres-exporter:v0.19.1
    container_name: postgres-exporter
    restart: unless-stopped
    environment:
      - DATA_SOURCE_NAME=postgresql://prometheus:StrongPassword@postgres:5432/postgres?sslmode=disable
      - PG_EXPORTER_AUTO_DISCOVER_DATABASES=true
    ports:
      - "9187:9187"
    networks: [monitoring]
```

#### Prometheus Scrape Config

```yaml
scrape_configs:
  - job_name: "postgres"
    static_configs:
      - targets: ["postgres-exporter:9187"]
        labels:
          cluster: prod-postgres-1
          env: production
    scrape_interval: 15s
```

#### Alert Rules — PostgreSQL

```yaml
groups:
  - name: postgres-observability
    rules:

      - alert: PostgreSQLDown
        expr: pg_up == 0
        for: 1m
        labels: {severity: critical}
        annotations:
          summary: "PostgreSQL instance is down"

      - alert: PostgreSQLHighConnections
        expr: |
          sum(pg_stat_activity_count{datname!~"template.*|postgres"})
            / pg_settings_max_connections * 100 > 85
        for: 5m
        labels: {severity: critical}
        annotations:
          summary: "Connection usage > 85%"

      - alert: PostgreSQLReplicationLag
        expr: pg_replication_lag > 30
        for: 2m
        labels: {severity: critical}
        annotations:
          summary: "Replication lag > 30s"

      - alert: PostgreSQLReplicationSlotLag
        expr: pg_replication_slots_pg_wal_lsn_diff > 1073741824
        for: 5m
        labels: {severity: warning}
        annotations:
          summary: "Inactive replication slot retaining > 1GB WAL — disk full risk"

      - alert: PostgreSQLDeadlock
        expr: rate(pg_stat_database_deadlocks[5m]) > 0.1
        for: 5m
        labels: {severity: warning}
        annotations:
          summary: "Deadlocks detected (>5/min)"

      - alert: PostgreSQLTableBloat
        expr: |
          pg_stat_user_tables_n_dead_tup
            / (pg_stat_user_tables_n_live_tup + 1) > 0.2
        for: 30m
        labels: {severity: warning}
        annotations:
          summary: "Table {{ $labels.relname }} bloat > 20%"

      - alert: PostgreSQLTransactionIDWraparound
        expr: |
          pg_database_age_datfrozenxid > 1500000000
        for: 1h
        labels: {severity: critical}
        annotations:
          summary: "Transaction ID age > 1.5B — wraparound approaching"
```

#### PromQL — PostgreSQL

```promql
# Connection usage
sum(pg_stat_activity_count{datname!~"template.*|postgres"})
  / pg_settings_max_connections * 100

# Cache hit ratio
sum(rate(pg_stat_database_blks_hit[5m]))
  / (sum(rate(pg_stat_database_blks_hit[5m]))
     + sum(rate(pg_stat_database_blks_read[5m])))

# Replication lag (seconds)
pg_replication_lag

# WAL retained by inactive slots
pg_replication_slots_pg_wal_lsn_diff

# Deadlocks rate
rate(pg_stat_database_deadlocks[5m])

# Table bloat ratio
pg_stat_user_tables_n_dead_tup
  / (pg_stat_user_tables_n_live_tup + 1)
```

#### Slow Query Templates

```sql
-- Top 10 queries by total time (สำคัญสุด)
SELECT
  left(query, 100) AS query,
  calls,
  round(total_exec_time::numeric, 1) AS total_ms,
  round(mean_exec_time::numeric, 1) AS avg_ms,
  rows
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;

-- Blocked queries
SELECT
  blocked.pid,
  blocked.query,
  blocking.pid AS blocker_pid,
  blocking.query AS blocker_query
FROM pg_stat_activity blocked
JOIN pg_stat_activity blocking
  ON blocking.pid = ANY(pg_blocking_pids(blocked.pid))
WHERE cardinality(pg_blocking_pids(blocked.pid)) > 0;

-- Idle in transaction (นานเกิน)
SELECT pid, state, now() - state_change AS duration, query
FROM pg_stat_activity
WHERE state = 'idle in transaction'
  AND now() - state_change > interval '10 minutes';
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| Connection > 85% | Connection leak, pool ไม่พอ | เพิ่ม `max_connections`, ใช้ PgBouncer |
| Replication Lag > 30s | Replica ช้า, Network, Write burst | ตรวจ Network, เพิ่ม Replica resource |
| Inactive slot สะสม WAL | Replica ถูก drop แต่ slot ไม่ถูกลบ | `SELECT pg_drop_replication_slot('slot_name')` |
| Bloat > 20% | Autovacuum ตามไม่ทัน | ปรับ `autovacuum_vacuum_scale_factor`, manual `VACUUM ANALYZE` |
| `age(datfrozenxid)` > 1.5B | Vacuum ไม่ทำงาน | `VACUUM FREEZE` ทันที — อย่ารอ |
| Deadlock | Lock ordering ไม่สม่ำเสมอ | ตรวจ Query pattern, เรียง Lock |

### ลำดับการจัดการปัญหา (Replication Lag)

1. **ยืนยัน** — `pg_replication_lag` > 30s
2. **ตรวจสถานะ** — `SELECT * FROM pg_stat_replication;`
3. **ตรวจ Slot** — `pg_replication_slots_pg_wal_lsn_diff` — สะสม WAL?
4. **ตรวจ Network** — `ping`, `iperf3` ระหว่าง Primary-Replica
5. **ตรวจ Replica** — CPU/RAM/Disk I/O (เล่ม 2)
6. **แก้:** เพิ่ม Resource, ลด Write load, ใช้ Synchronous Replication (ถ้าต้องการ Consistency)

### Template Code
→ ดู Docker Compose, Alert Rules, PromQL ด้านบน

### Template Dashboard
→ ใช้ **PostgreSQL Dashboard** (Grafana ID 9628 — PostgreSQL Database) + Panel: Connection, Replication Lag, Bloat, Cache Hit

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** เห็น Connection, Lag, Bloat ก่อน user บ่น — ใช้ `pg_stat_statements` หา Slow Query
- **ข้อควรระวัง:** **Inactive Replication Slot** = Disk Full (สาเหตุที่พบบ่อยที่สุด) — ต้อง Alert ทันที; `pg_monitor` role เพียงพอ — ห้ามใช้ superuser
- **ข้อดี:** Open-source, Exporter เสถียร, Metrics ครบ
- **ข้อเสีย:** `pg_stat_statements` ต้อง `shared_preload_libraries` (ต้อง restart)
- **ข้อห้าม:**
  - ❌ ใช้ superuser สำหรับ monitoring
  - ❌ ลืม Monitor Replication Slot
  - ❌ รอ `age(datfrozenxid)` > 2B (database จะ shutdown)
  - ❌ ใช้ `numbackends` โดยไม่เทียบ `max_connections`

### ตัวอย่าง (Top Query by Total Time)

```sql
SELECT left(query, 80) AS query, calls,
       round(total_exec_time::numeric, 1) AS total_ms
FROM pg_stat_statements
ORDER BY total_exec_time DESC LIMIT 5;
```

### สรุปย่อเพื่อจดจำ
> **PostgreSQL** — 5 เสา: Connection, Query, Vacuum, Replication, Lock — `pg_stat_statements` คือ Query X-Ray — Alert `ReplicationSlotLag` (Disk Full Risk) — `pg_monitor` role — Bloat > 20% ต้อง Vacuum

### แหล่งที่มา
- Guance, "PostgreSQL Monitoring: The Complete 2026 Guide" 
- JusDB, "PostgreSQL Monitoring with Prometheus and postgres_exporter" 
- PostgreSQL Docs: Monitoring

---

## 9.2 Oracle (AWR, ASH, Execution Plan, Tablespace, Monitoring)

### เรื่อง
Database Operations & Observability สำหรับ Oracle — ฐานข้อมูล Core ของ ERP ขนาดใหญ่

### วัตถุประสงค์ / เป้าหมาย
- เห็น **Tablespace Usage** ก่อนเต็ม
- เห็น **Session Activity** และ **Wait Events**
- ใช้ **AWR/ASH** สำหรับ Historical Analysis
- Monitor ผ่าน `oracledb_exporter`

### เนื้อหา / รายละเอียด

#### AWR vs ASH vs ADDM

| Tool | เก็บอะไร | ใช้เมื่อ |
|---|---|---|
| **AWR** | Snapshot ทุก 1 ชม. (เก็บ 8 วัน) | วิเคราะห์ย้อนหลัง, Trend |
| **ASH** | Session active ทุก 1 วินาที | ดู Real-time, ใครกิน resource |
| **ADDM** | วิเคราะห์ AWR อัตโนมัติ | หา Root Cause |

> **กฎ:** AWR/ASH เป็น **Diagnostic Tool** — ใช้เมื่อมีปัญหา; Prometheus ใช้ **Monitoring** — ใช้ดู Trend และ Alert

#### Metrics ที่ต้อง Monitor (ผ่าน `oracledb_exporter`)

| Metric | ความหมาย | Alert |
|---|---|---|
| `oracledb_tablespace_bytes` | ขนาด Tablespace | > 85% |
| `oracledb_sessions_activity` | Session active | ตาม Baseline |
| `oracledb_wait_time_*` | Wait Time แยก Class | Application > 50% |
| `oracledb_sga_memory` | SGA Usage | > 90% |
| `oracledb_resource_limit` | Resource limit | ใกล้ Max |

### การติดตั้ง / การตั้งค่า

#### สร้าง Monitoring User

```sql
CREATE USER prometheus IDENTIFIED BY "StrongPassword";
GRANT CONNECT, CREATE SESSION TO prometheus;
GRANT SELECT ON V_$INSTANCE TO prometheus;
GRANT SELECT ON V_$SYSSTAT TO prometheus;
GRANT SELECT ON V_$SYSTEM_EVENT TO prometheus;
GRANT SELECT ON V_$SESSION TO prometheus;
GRANT SELECT ON V_$WAITCLASSMETRIC TO prometheus;
GRANT SELECT ON DBA_TABLESPACES TO prometheus;
GRANT SELECT ON DBA_DATA_FILES TO prometheus;
GRANT SELECT ON DBA_FREE_SPACE TO prometheus;
GRANT SELECT ON V_$SQL TO prometheus;
GRANT SELECT ON V_$SQLAREA TO prometheus;
```

> **หมายเหตุ:** ต้องติดตั้ง Oracle Instant Client บน host ที่รัน exporter 

#### Docker Compose (`oracledb_exporter`)

```yaml
  oracledb-exporter:
    image: prometheuscommunity/oracledb_exporter:v0.5.0
    container_name: oracledb-exporter
    restart: unless-stopped
    environment:
      - DATA_SOURCE_NAME=oracle://prometheus:StrongPassword@//oracle:1521/ORCLPDB1
    ports:
      - "9161:9161"
    networks: [monitoring]
```

#### Prometheus Scrape Config

```yaml
scrape_configs:
  - job_name: "oracle"
    static_configs:
      - targets: ["oracledb-exporter:9161"]
        labels:
          cluster: prod-oracle-1
          env: production
    scrape_interval: 30s
```

#### Alert Rules — Oracle

```yaml
groups:
  - name: oracle-observability
    rules:

      - alert: OracleTablespaceHigh
        expr: |
          oracledb_tablespace_bytes
            / oracledb_tablespace_max_bytes * 100 > 85
        for: 10m
        labels: {severity: warning}
        annotations:
          summary: "Tablespace {{ $labels.tablespace }} > 85%"

      - alert: OracleSessionHigh
        expr: oracledb_sessions_activity{type="active"} > 100
        for: 10m
        labels: {severity: warning}
        annotations:
          summary: "Active sessions > 100"

      - alert: OracleWaitApplicationHigh
        expr: |
          rate(oracledb_wait_time_application[5m])
            / rate(oracledb_wait_time_total[5m]) > 0.5
        for: 10m
        labels: {severity: warning}
        annotations:
          summary: "Application wait > 50% — ตรวจ row lock / index"

      - alert: OracleDown
        expr: oracledb_up == 0
        for: 1m
        labels: {severity: critical}
        annotations:
          summary: "Oracle instance is down"
```

#### PromQL — Oracle

```promql
# Tablespace usage (%)
oracledb_tablespace_bytes / oracledb_tablespace_max_bytes * 100

# Active sessions
oracledb_sessions_activity{type="active"}

# Wait time by class
rate(oracledb_wait_time_application[5m])

# SGA usage
oracledb_sga_memory
```

#### AWR/ASH Templates

```sql
-- AWR: Top SQL by Elapsed Time
SELECT * FROM TABLE(
  DBMS_XPLAN.DISPLAY_AWR('&sql_id')
);

-- ASH: Active sessions by Wait Class (last 5 min)
SELECT wait_class, COUNT(*) AS sessions
FROM v$active_session_history
WHERE sample_time > SYSTIMESTAMP - INTERVAL '5' MINUTE
GROUP BY wait_class
ORDER BY sessions DESC;

-- Tablespace usage
SELECT tablespace_name,
       ROUND(used_percent, 2) AS used_pct
FROM dba_tablespace_usage_metrics
ORDER BY used_percent DESC;
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| Tablespace > 85% | ข้อมูลโต, ไม่มี Autoextend | เพิ่ม Datafile, Autoextend, ลบข้อมูลเก่า |
| Application Wait > 50% | Row lock, Index missing | ตรวจ ASH, เพิ่ม Index |
| Active sessions > 100 | Connection pool เยอะ | ใช้ Connection Pool (UCP) |
| SGA > 90% | Shared pool / Buffer cache ไม่พอ | ปรับ `SGA_TARGET` |

### ลำดับการจัดการปัญหา (Tablespace Full)

1. **ยืนยัน** — `oracledb_tablespace_bytes / max > 85%`
2. **ตรวจ Top Segments** — `SELECT * FROM dba_segments ORDER BY bytes DESC`
3. **ตรวจ Autoextend** — `dba_data_files`
4. **แก้:** `ALTER DATABASE DATAFILE ... AUTOEXTEND ON NEXT 100M MAXSIZE 10G;`
5. **ระหว่างแก้** — Monitor `oracledb_tablespace_bytes` ทุก 5 นาที

### Template Code
→ ดู Docker Compose, Alert Rules, PromQL ด้านบน

### Template Dashboard
→ ใช้ **Oracle Dashboard** (Grafana ID 3333) + Panel: Tablespace, Session, Wait

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** เห็น Tablespace, Session, Wait — ใช้ AWR/ASH หา Root Cause
- **ข้อควรระวัง:** `oracledb_exporter` ต้องใช้ Oracle Instant Client — ต้องติดตั้งบน host; Monitoring User ต้องมีสิทธิ์บน `V$` views
- **ข้อดี:** `oracledb_exporter` แปลง `V$` views เป็น Metrics — DBA คุ้นเคย
- **ข้อเสีย:** ต้อง License Oracle Client; Exporter ช้ากว่า PostgreSQL
- **ข้อห้าม:**
  - ❌ ใช้ `SYSDBA` สำหรับ monitoring
  - ❌ ลืม Monitor Tablespace (Oracle ไม่ Autoextend โดย default)
  - ❌ ใช้ AWR แทน Real-time Alert (AWR เป็น Snapshot ทุก 1 ชม.)
  - ❌ ละเลย `Application Wait` (มักเป็น Row Lock)

### ตัวอย่าง (ASH Top Wait)

```sql
SELECT wait_class, COUNT(*) AS sessions
FROM v$active_session_history
WHERE sample_time > SYSTIMESTAMP - INTERVAL '5' MINUTE
GROUP BY wait_class ORDER BY sessions DESC;
```

### สรุปย่อเพื่อจดจำ
> **Oracle** — AWR (Snapshot) + ASH (Real-time) + ADDM (Auto) — `oracledb_exporter` แปลง `V$` views — Alert Tablespace > 85% — Monitoring User ห้าม `SYSDBA`

### แหล่งที่มา
- Oracle Docs: AWR, ASH, ADDM
- CSDN, "Prometheus 监控 Oracle 全栈实战" 
- oracledb_exporter GitHub

---

## 9.3 MSSQL (Execution Plan, DMV, Always On, Monitoring)

### เรื่อง
Database Operations & Observability สำหรับ MSSQL — ฐานข้อมูล Reporting และ Integration

### วัตถุประสงค์ / เป้าหมาย
- เห็น **Blocking / Deadlock** ก่อน user บ่น
- เห็น **Buffer Cache Hit Ratio**
- Monitor **Always On Availability Group**
- ใช้ **DMV** สำหรับ Diagnostics

### เนื้อหา / รายละเอียด

#### DMV ที่ต้องรู้

| DMV | ใช้เมื่อ |
|---|---|
| `sys.dm_exec_requests` | Request ที่กำลังทำงาน |
| `sys.dm_os_wait_stats` | Wait Statistics |
| `sys.dm_db_index_usage_stats` | Index Usage |
| `sys.dm_hadr_availability_replica_states` | Always On Health  |
| `sys.dm_hadr_database_replica_states` | Database Sync Status  |

#### Metrics ที่ต้อง Monitor

| Metric | Alert |
|---|---|
| `mssql_deadlocks_total` | rate > 0  |
| `mssql_connections` | > 80% ของ Max |
| Buffer cache hit ratio | < 95% |
| Always On Sync Lag | > 5s |

### การติดตั้ง / การตั้งค่า

#### สร้าง Monitoring Login

```sql
USE master;
CREATE LOGIN prometheus WITH PASSWORD = 'StrongPassword';
GRANT VIEW SERVER STATE TO prometheus;
GRANT VIEW ANY DEFINITION TO prometheus;
-- สำหรับ Always On:
GRANT VIEW ANY AVAILABILITY GROUP TO prometheus;
```

#### Docker Compose (`mssql-prometheus-exporter`)

```yaml
  mssql-exporter:
    image: mcr.microsoft.com/mssql/server:2022-latest  # หรือใช้ exporter binary
    # แนะนำใช้ microsoft/mssql-prometheus-exporter
    # (official)
```

#### Alert Rules — MSSQL

```yaml
- alert: MSSQLDeadlock
  expr: rate(mssql_deadlocks_total[5m]) > 0
  for: 2m
  labels: {severity: warning}
  annotations:
    summary: "Deadlock detected"

- alert: MSSQLConnectionHigh
  expr: |
    mssql_connections{state="current"}
      / (mssql_connections{state="current"} + mssql_connections{state="available"}) > 0.8
  for: 5m
```

#### DMV Templates

```sql
-- Blocking sessions
SELECT
  blocked.session_id AS blocked_session,
  blocking.session_id AS blocking_session,
  blocked.wait_time / 1000.0 AS wait_seconds
FROM sys.dm_exec_requests blocked
JOIN sys.dm_exec_requests blocking
  ON blocked.blocking_session_id = blocking.session_id
WHERE blocked.blocking_session_id > 0;

-- Always On replica health
SELECT
  ag.name AS ag_name,
  ar.replica_server_name,
  ars.role_desc,
  ars.synchronization_health_desc
FROM sys.dm_hadr_availability_replica_states ars
JOIN sys.availability_replicas ar ON ar.replica_id = ars.replica_id
JOIN sys.availability_groups ag ON ag.group_id = ar.group_id;

-- Top wait stats
SELECT TOP 10 wait_type, wait_time_ms, waiting_tasks_count
FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE '%SLEEP%'
ORDER BY wait_time_ms DESC;
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| Deadlock | Lock order ไม่สม่ำเสมอ | ตรวจ Execution Plan, เรียง Lock |
| Blocking นาน | Transaction ใหญ่ | ตรวจ `sys.dm_exec_requests`, ลด Transaction size |
| Always On Sync ช้า | Network, Redo Queue | ตรวจ Network, เพิ่ม Resource |

### ลำดับการจัดการปัญหา (Blocking)

1. **ยืนยัน** — DMV: `sys.dm_exec_requests` — มี `blocking_session_id > 0`
2. **ตรวจ Blocker** — `sys.dm_exec_sql_text` — Query อะไร?
3. **ตรวจ Wait** — `sys.dm_os_wait_stats`
4. **แก้:** Kill blocker (ถ้าจำเป็น), เพิ่ม Index, ลด Transaction

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** DMV ทรงพลัง — เห็น Blocking, Deadlock, Always On
- **ข้อควรระวัง:** **Always On** ต้องใช้ DMV เฉพาะ — `sys.dm_hadr_*`
- **ข้อดี:** Microsoft Official Exporter — เสถียร
- **ข้อเสีย:** DMV บางตัวต้อง `VIEW SERVER STATE` (สิทธิ์สูง)
- **ข้อห้าม:** ❌ ใช้ `sa` สำหรับ monitoring — ❌ ลืม Monitor Always On Sync

### ตัวอย่าง (Deadlock Alert)

```yaml
- alert: MSSQLDeadlock
  expr: rate(mssql_deadlocks_total[5m]) > 0
  for: 2m
```

### สรุปย่อเพื่อจดจำ
> **MSSQL** — DMV = `sys.dm_exec_requests`, `sys.dm_os_wait_stats`, `sys.dm_hadr_*` — Alert `Deadlock` (rate > 0) — Always On ใช้ DMV เฉพาะ — `VIEW SERVER STATE`

### แหล่งที่มา
- Microsoft Docs: Always On DMV 
- CSDN, "Prometheus 监控 SQL Server 全栈实战" 
- mssql-prometheus-exporter GitHub

---

## 9.4 MongoDB (Sharding, Replica Set, Index, Monitoring)

### เรื่อง
Database Operations & Observability สำหรับ MongoDB — ฐานข้อมูล Document และ Catalog

### วัตถุประสงค์ / เป้าหมาย
- เห็น **Replication Lag** ก่อน Secondary ล้า
- เห็น **Connection Saturation**
- เห็น **WiredTiger Cache Dirty Bytes**
- Monitor **Sharded Cluster**

### เนื้อหา / รายละเอียด

#### Metrics ที่ต้อง Monitor

| Metric | Alert |
|---|---|
| `mongodb_rs_members_optimeDate` (lag) | > 10s  |
| `mongodb_connections` | > 80%  |
| WiredTiger Cache Dirty | > 20%  |
| Oplog Window | < 24 ชม. |
| Replica Health | != 1 |

### การติดตั้ง / การตั้งค่า

#### Docker Compose (`mongodb_exporter`)

```yaml
  mongodb-exporter:
    image: percona/mongodb_exporter:0.43.1
    container_name: mongodb-exporter
    restart: unless-stopped
    environment:
      - MONGODB_URI=mongodb://monitor:password@mongodb:27017/admin?authSource=admin
    command:
      - "--collect-all"
      - "--compatible-mode"
    ports:
      - "9216:9216"
    networks: [monitoring]
```

#### Prometheus Scrape Config

```yaml
scrape_configs:
  - job_name: "mongodb"
    static_configs:
      - targets: ["mongodb-exporter:9216"]
        labels:
          cluster: prod-mongo-1
    scrape_interval: 15s
```

#### Alert Rules — MongoDB

```yaml
groups:
  - name: mongodb-observability
    rules:

      - alert: MongoDBReplicationLag
        expr: mongodb_mongod_replset_member_replication_lag > 10
        for: 2m
        labels: {severity: critical}
        annotations:
          summary: "Replication lag > 10s on {{ $labels.member }}"

      - alert: MongoDBConnectionsHigh
        expr: |
          mongodb_ss_connections{conn_type="current"}
            / (mongodb_ss_connections{conn_type="current"}
               + mongodb_ss_connections{conn_type="available"}) > 0.8
        for: 5m
        labels: {severity: warning}
        annotations:
          summary: "Connection usage > 80%"

      - alert: MongoDBCacheDirtyHigh
        expr: |
          mongodb_ss_wt_cache_bytes_dirty
            / mongodb_ss_wt_cache_max_bytes > 0.2
        for: 5m
        labels: {severity: warning}
        annotations:
          summary: "WiredTiger cache dirty > 20%"

      - alert: MongoDBNodeNotHealthy
        expr: mongodb_mongod_replset_member_health != 1
        for: 1m
        labels: {severity: critical}
        annotations:
          summary: "Replica set member unhealthy"
```

#### PromQL — MongoDB

```promql
# Replication lag
mongodb_mongod_replset_member_replication_lag

# Connection usage (%)
mongodb_ss_connections{conn_type="current"}
  / (mongodb_ss_connections{conn_type="current"}
     + mongodb_ss_connections{conn_type="available"}) * 100

# WiredTiger cache dirty ratio
mongodb_ss_wt_cache_bytes_dirty / mongodb_ss_wt_cache_max_bytes

# Oplog window (seconds)
mongodb_mongod_replset_oplog_tail_timestamp
  - mongodb_mongod_replset_oplog_head_timestamp
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| Replication Lag > 10s | Secondary ช้า, Network, Write burst | ตรวจ Network, เพิ่ม Secondary resource |
| Connection > 80% | Connection leak, pool ไม่พอ | ตรวจ `maxIncomingConnections`, pool size |
| Cache Dirty > 20% | Disk ช้า, Write เยอะ | ตรวจ Disk I/O, เพิ่ม IOPS |
| Oplog Window < 24h | Write เยอะ, Oplog เล็ก | เพิ่ม Oplog size |

### ลำดับการจัดการปัญหา (Replication Lag)

1. **ยืนยัน** — `mongodb_mongod_replset_member_replication_lag` > 10s
2. **ตรวจ `rs.status()`** — Secondary state?
3. **ตรวจ Network** — `ping`, `iperf3`
4. **ตรวจ Disk** — Secondary Disk I/O
5. **แก้:** เพิ่ม Resource, ลด Write load

### Template Code
→ ดู Docker Compose, Alert Rules, PromQL ด้านบน

### Template Dashboard
→ ใช้ **MongoDB Dashboard** (Grafana ID 2583) + Panel: Replication Lag, Connection, Cache Dirty

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** เห็น Replication Lag, Connection, Cache Dirty — ครอบคลุม Replica Set และ Sharded Cluster
- **ข้อควรระวัง:** **WiredTiger Cache Dirty > 20%** = เสี่ยง Disk คอขวด; **Oplog Window** ต้อง > 24h
- **ข้อดี:** `mongodb_exporter` (Percona) เสถียร, Metrics ครบ
- **ข้อเสีย:** `--collect-all` กิน Resource (กรอง collector ถ้าไม่จำเป็น)
- **ข้อห้าม:**
  - ❌ ใช้ `--collect-all` บน Cluster ใหญ่ (ช้า)
  - ❌ ลืม Monitor Oplog Window
  - ❌ ใช้ `root` user สำหรับ monitoring

### ตัวอย่าง (Replication Lag Alert)

```yaml
- alert: MongoDBReplicationLag
  expr: mongodb_mongod_replset_member_replication_lag > 10
  for: 2m
  labels: {severity: critical}
```

### สรุปย่อเพื่อจดจำ
> **MongoDB** — Alert `ReplicationLag` > 10s — Connection > 80% — Cache Dirty > 20% — Oplog Window > 24h — `mongodb_exporter` (Percona) — Replica Health = 1

### แหล่งที่มา
- OneUptime, "How to Monitor MongoDB with Prometheus and Grafana" 
- OneUptime, "How to Set Up Automated Alerts for MongoDB" 
- Percona `mongodb_exporter` GitHub


## Workflow (อ้างอิงเล่ม 1 + Incident Playbook เฉพาะเล่ม)

### อ้างอิง Workflow หลักจากเล่ม 1

| Workflow | ใช้ในเล่มนี้เมื่อ |
|---|---|
| **PSR** | เขียนรายงานหลัง Database Incident |
| **RCA 5 Whys** | หา Root Cause ของ Connection Full / Replication Lag |
| **KPI SMART** | ตั้ง KPI ของ DB (เช่น Connection < 85%, Replication Lag < 30s) |

→ Template เต็มอยู่ใน **เล่ม 1 หัวข้อ 4**

### Incident Playbook เฉพาะเล่ม 9

#### Playbook A: Connection Saturation (ทุก DB)

1. **ยืนยัน** — Metrics: `numbackends / max_connections` (PG) หรือ `mssql_connections` (MSSQL) หรือ `mongodb_connections` (Mongo)
2. **ตรวจ Active Sessions** — PG: `pg_stat_activity`, MSSQL: `sys.dm_exec_requests`, Mongo: `db.currentOp()`
3. **หาต้นเหตุ** — Connection leak? Pool size ไม่พอ? Long-running query?
4. **แก้ชั่วคราว** — Kill idle sessions (ระวัง!), เพิ่ม `max_connections`
5. **แก้ถาวร** — ใช้ Connection Pooler (PgBouncer, UCP), ปรับ Pool size

#### Playbook B: Replication Lag (PG / Mongo / MSSQL)

1. **ยืนยัน** — `pg_replication_lag` (PG) / `mongodb_mongod_replset_member_replication_lag` (Mongo)
2. **ตรวจ Network** — `ping`, `iperf3` ระหว่าง Primary-Replica
3. **ตรวจ Replica Resource** — CPU/RAM/Disk (เล่ม 2)
4. **ตรวจ Write Burst** — Primary เขียนเยอะผิดปกติ?
5. **แก้:** เพิ่ม Resource, ลด Write, ใช้ Parallel Replication (PG)

#### Playbook C: Disk Full จาก WAL/Redo/Oplog

1. **PG** — ตรวจ `pg_replication_slots_pg_wal_lsn_diff` — Inactive slot? → `pg_drop_replication_slot()`
2. **Oracle** — ตรวจ `oracledb_tablespace_bytes` — เพิ่ม Datafile / Autoextend
3. **MSSQL** — ตรวจ Log File Size — Backup Log, Shrink
4. **MongoDB** — ตรวจ Oplog Size — เพิ่ม Oplog

#### Playbook D: Deadlock/Blocking

1. **PG** — `pg_blocking_pids()` — ดู Blocker
2. **MSSQL** — `sys.dm_exec_requests` + `blocking_session_id`
3. **Mongo** — `db.currentOp()` — ดู Waiting
4. **แก้:** เรียง Lock order, ลด Transaction size, เพิ่ม Index

#### Playbook E: Slow Query (ทุก DB)

| DB | Tool | คำสั่ง |
|---|---|---|
| **PG** | `pg_stat_statements` | `ORDER BY total_exec_time DESC` |
| **Oracle** | AWR / ASH | `DBMS_XPLAN.DISPLAY_AWR` |
| **MSSQL** | DMV | `sys.dm_exec_query_stats` |
| **Mongo** | `db.currentOp()` / Profiler | `db.setProfilingLevel(1, {slowms: 100})` |


## สรุป (ประโยชน์, ข้อดี, ข้อเสีย, ข้อห้าม)

### ประโยชน์ของเล่ม 9

- **Cross-Database Visibility:** เห็น Metrics ของทั้ง 4 DB ใน Prometheus เดียว
- **Standardized Alerting:** Alert Rules ครบทุก DB
- **Diagnostic Depth:** ใช้ Tools เฉพาะ DB (pg_stat_statements, AWR, DMV, WiredTiger)
- **Runbook พร้อม:** 5 Playbook สำหรับ Incident ที่พบบ่อย
- **Integration:** ใช้ Metrics Platform จากเล่ม 3

### ข้อดี

| ด้าน | ผลลัพธ์ |
|---|---|
| **MTTD** | เห็น Connection/Lag/Deadlock ก่อน user บ่น |
| **MTTR** | Playbook เฉพาะ DB → แก้เร็ว |
| **Capacity** | เห็น Trend → วางแผน Resource |
| **Standardization** | ใช้ Prometheus/Grafana/Alertmanager เดียวกัน |
| **Cross-team** | DBA + ERP Support ดู Dashboard เดียวกัน |

### ข้อเสีย / ข้อจำกัด

- **Exporter ต่างกัน** — 4 DB ใช้ 4 Exporter (config เยอะ)
- **Oracle ต้อง Instant Client** — ติดตั้งยากกว่า
- **AWR/ASH ต้อง License** (Oracle Diagnostic Pack)
- **Metrics บางตัว Cardinality สูง** (per-table, per-index)
- **`pg_stat_statements` ต้อง restart** (ครั้งแรก)

### ข้อห้าม (สรุป)

1. ❌ **ใช้ superuser / sa / SYSDBA** สำหรับ monitoring — ใช้ read-only role
2. ❌ **ลืม Monitor Replication Slot (PG)** — Disk Full Risk
3. ❌ **ลืม Monitor Tablespace (Oracle)** — ไม่ Autoextend โดย default
4. ❌ **ลืม Monitor Always On Sync (MSSQL)** — ใช้ DMV เฉพาะ
5. ❌ **ลืม Monitor Oplog Window (MongoDB)** — < 24h = เสี่ยง
6. ❌ **ใช้ `--collect-all`** บน Cluster ใหญ่ (Mongo) — กรอง collector
7. ❌ **รอ `age(datfrozenxid)` > 2B (PG)** — Database shutdown
8. ❌ **ใช้ AWR แทน Real-time Alert** — AWR เป็น Snapshot ทุก 1 ชม.
9. ❌ **ไม่ตั้ง Alert Deadlock** — ตรวจพบช้า → กระทบนาน
10. ❌ **Deploy DB Monitoring โดยไม่มี Dashboard** — Metrics ไม่มีประโยชน์ถ้าไม่มีคนดู

---

## เส้นทางอ่านต่อ

| ถ้าคุณเป็น | อ่านต่อ |
|---|---|
| DBA / ERP Support | → **เล่ม 10** (ERP Integration Layer) |
| ERP Developer | → **เล่ม 10** (Outbox, Saga, Cache-Aside) |
| Solution Architect | → **เล่ม 10** |
| Monitoring Engineer | → อ่านจบเส้นทาง A แล้ว — ฝึก PromQL + Grafana เพิ่ม |

---

> **เวอร์ชันเอกสาร:** 1.0
> **ผู้รับผิดชอบ:** DBA Team + SRE Team
> **ปรับปรุงล่าสุด:** ตามรอบ Quarter
> **สถานะ:** ✅ Ready for Review