## เล่ม 10: ERP Integration Layer — "สาย Integration / ERP Support ขั้นสูง"

> **กลุ่มงาน:** Integration Engineer, ERP Support, Solution Architect
> **Dependency:** อ่านเล่ม 5 (Observability ของ Kafka/Redis), เล่ม 8 (DDD), เล่ม 9 (Database) ก่อน
> **เวอร์ชัน:** 1.0


## บทนำ

### วัตถุประสงค์ของเล่ม

เล่มนี้ครอบคลุม **Pattern การใช้งาน Redis และ Kafka ในบริบท ERP** — ไม่ใช่ Observability (นั่นคือเล่ม 5) แต่เป็น **วิธีออกแบบ Integration ที่ถูกต้อง** เพื่อให้ ERP หลาย Bounded Context (Order, Inventory, Billing, Accounting) ทำงานร่วมกันได้อย่างถูกต้อง มี Consistency และทนต่อ Failure เมื่ออ่านจบ ผู้อ่านจะสามารถ:

1. เลือกใช้ **Cache Pattern** ที่เหมาะสม (Cache-Aside, Write-Through, Write-Behind) และออกแบบ **Cache Invalidation** ที่ถูกต้อง
2. ใช้ **Redis Distributed Lock (Redlock)** สำหรับ Critical Section
3. Implement **Transactional Outbox Pattern** เพื่อให้ DB + Event สอดคล้องกัน (ไม่หาย, ไม่ซ้ำ)
4. ออกแบบ **Saga Pattern** (Orchestration vs Choreography) สำหรับ Distributed Transaction
5. Implement **Idempotency** ใน Kafka Consumer
6. ใช้ **Event Sourcing** สำหรับ Audit-heavy Domain
7. ใช้ **Runbook** สำหรับ Replay Failed Events, Cache Warm-up, Outbox Cleanup

### เป้าหมายของเล่ม

| เป้าหมาย | ตัวชี้วัดความสำเร็จ |
|---|---|
| ไม่มี Event หาย | Outbox Pattern ทำงาน 100% (DB + Event atomic) |
| ไม่มี Double-processing | Idempotency Key ครบทุก Consumer |
| Cache สอดคล้องกับ DB | Invalidation Strategy ชัดเจน (TTL + Event-based) |
| Saga Compensate ได้ | ทุก Step มี Compensation Logic |
| Runbook พร้อม | 3 Runbook สำหรับ Operation ที่พบบ่อย |

### สิ่งที่ **ไม่** อยู่ในเล่มนี้

- Kafka/Redis Observability (Lag, Hit Rate) → **เล่ม 5**
- DDD Aggregate / Repository → **เล่ม 8**
- Database Tuning → **เล่ม 9**
- Kafka/Redis ติดตั้ง → **เล่ม 5**

### ทำไม Redis/Kafka ปรากฏสองเล่ม

| เล่ม | เน้น | ผู้อ่าน |
|---|---|---|
| **เล่ม 5** | **Observability** — Monitor Lag, Hit Rate, Eviction, Alert | Support, SRE |
| **เล่ม 10** | **Patterns** — Outbox, Saga, Cache-Aside, Lock, Idempotency | Developer, Integration Engineer |

> **กฎ:** เล่ม 5 ตอบ "ระบบมีสุขภาพดีไหม" — เล่ม 10 ตอบ "ออกแบบอย่างไรให้ถูกต้อง" — เป็น **คนละทักษะ** แต่ต้องอ่านทั้งคู่


## บทนิยาม (เฉพาะคำศัพท์ใหม่ในเล่มนี้)

### Redis Patterns

| คำศัพท์ | ความหมาย |
|---|---|
| **Cache-Aside** | App ตรวจ Cache ก่อน — ถ้า Miss → อ่าน DB → เขียน Cache (App จัดการ 2 ที่) |
| **Write-Through** | เขียน Cache + DB พร้อมกัน (Consistency สูง, ช้ากว่า) |
| **Write-Behind (Write-Back)** | เขียน Cache ก่อน → async เขียน DB (เร็ว, เสี่ยง data loss) |
| **Read-Through** | Cache Layer อ่าน DB แทน App (App คุยกับ Cache เท่านั้น) |
| **TTL (Time-To-Live)** | เวลาหมดอายุของ Cache Key |
| **Cache Stampede (Thundering Herd)** | หลาย Request Miss พร้อมกัน → ถล่ม DB |
| **Cache Warming** | โหลดข้อมูลเข้า Cache ล่วงหน้า (ก่อน Traffic มา) |
| **Cache Invalidation** | การลบ/อัปเดต Cache เมื่อข้อมูลเปลี่ยน |
| **Distributed Lock** | Lock ที่ทำงานข้าม Process/Node (Redis Redlock) |
| **Redlock** | Algorithm ของ Redis สำหรับ Distributed Lock (5 master, quorum) |
| **Fencing Token** | ตัวเลขที่เพิ่มขึ้นเรื่อยๆ เพื่อกัน Lock ที่หมดอายุแล้วยังทำงาน |

### Kafka Patterns

| คำศัพท์ | ความหมาย |
|---|---|
| **Transactional Outbox** | เขียน Event ลง Outbox Table ใน Transaction เดียวกับ Business Data → Background process ส่งไป Kafka |
| **Saga Pattern** | Distributed Transaction ที่แบ่งเป็น Local Transaction + Compensation |
| **Orchestration Saga** | มี Coordinator (Saga Orchestrator) สั่งแต่ละ Step |
| **Choreography Saga** | แต่ละ Service ฟัง Event และทำงานเอง (ไม่มี Coordinator) |
| **Compensating Transaction** | การย้อนกลับเมื่อ Step ใด Step หนึ่งล้มเหลว |
| **Event Sourcing** | เก็บ State เป็น Sequence ของ Event (ไม่ใช่ State ปัจจุบัน) |
| **Idempotency** | การประมวลผลซ้ำได้ผลเหมือนเดิม (ไม่ double-process) |
| **Idempotency Key** | Key ที่ใช้ตรวจว่าข้อความนี้เคยประมวลผลแล้วหรือยัง |
| **Exactly-Once Semantics (EOS)** | Kafka Feature ที่รับประกันว่าข้อความถูกประมวลผลครั้งเดียว (ต้องใช้ Kafka Transactions) |
| **At-Least-Once** | ข้อความอาจถูกประมวลผลซ้ำ (Default) — ต้อง Idempotent |
| **At-Most-Once** | ข้อความอาจหาย (ไม่รับประกัน) |
| **Dead Letter Topic (DLT)** | Topic เก็บ Message ที่ประมวลผลไม่สำเร็จ |
| **Saga Compensation Log** | Log ที่บันทึก Step ที่ทำแล้ว เพื่อ Compensate |


## บทหัวข้อ


## 10.1 Redis Cache (ERP Context) — Cache-Aside, Write-Through, Write-Behind, Session Store, Distributed Lock, Cache Invalidation

### เรื่อง
Cache Patterns สำหรับ ERP — เลือกใช้ให้ถูกกับ Use Case และออกแบบ Invalidation ให้สอดคล้อง

### วัตถุประสงค์ / เป้าหมาย
- เลือก Cache Pattern ที่เหมาะกับแต่ละ Use Case
- ออกแบบ Cache Invalidation ที่ไม่ทำให้ข้อมูลเก่า
- ใช้ Distributed Lock สำหรับ Critical Section
- หลีกเลี่ยง Cache Stampede

### เนื้อหา / รายละเอียด

#### 4 Cache Patterns หลัก

| Pattern | วิธีการ | Consistency | Performance | ใช้เมื่อ |
|---|---|---|---|---|
| **Cache-Aside** | App ตรวจ Cache → Miss → อ่าน DB → เขียน Cache | ปานกลาง | ดี | **แนะนำ** สำหรับ ERP ทั่วไป |
| **Read-Through** | Cache Layer อ่าน DB แทน App | ปานกลาง | ดี | เมื่อมี Cache Library ที่รองรับ |
| **Write-Through** | เขียน Cache + DB พร้อมกัน | สูง | ช้ากว่า | ข้อมูลสำคัญ (ราคา, Stock) |
| **Write-Behind** | เขียน Cache → async DB | ต่ำ | เร็วสุด | Counter, Log (ยอมเสียได้) |

#### Cache-Aside — Flow

```
Read:
  App → GET cache:key
    ├─ HIT → return
    └─ MISS → GET DB → SET cache:key (with TTL) → return

Write:
  App → UPDATE DB → DELETE cache:key (ไม่ใช่ SET!)
```

> **กฎเหล็ก:** Write = **DELETE** Cache (ไม่ใช่ SET) — เพื่อหลีกเลี่ยง Race Condition ระหว่าง Writer หลายตัว

#### Cache Invalidation — 4 กลยุทธ์

| กลยุทธ์ | วิธี | ใช้เมื่อ |
|---|---|---|
| **TTL-based** | ตั้ง TTL สั้น (เช่น 5 นาที) — ข้อมูลเก่าได้สูงสุด TTL | ข้อมูลที่ยอมเก่าได้ |
| **Event-based** | Publish Event เมื่อข้อมูลเปลี่ยน → Consumer ลบ Cache | ข้อมูลสำคัญ (Stock, ราคา) |
| **Write-Through** | เขียน Cache + DB พร้อมกัน | Consistency สูง |
| **Version-based** | ใส่ Version ใน Key (`product:v2:123`) — เปลี่ยน Version = Cache ใหม่ | Schema เปลี่ยน |

> **แนะนำสำหรับ ERP:** ใช้ **TTL + Event-based** ร่วมกัน — TTL เป็น Safety Net, Event-based เป็น Real-time Invalidation

#### Cache Stampede — ปัญหาและวิธีแก้

**ปัญหา:** Key หมดอายุพร้อมกัน → 1000 requests Miss พร้อมกัน → ถล่ม DB

**วิธีแก้:**

1. **Distributed Lock** — ให้ 1 request ไปโหลด DB, ที่เหลือรอ
2. **Probabilistic Early Expiration** — Refresh Cache ก่อนหมดอายุ (แบบสุ่ม)
3. **Singleflight** (Go) / **asyncio.Lock** (Python)

### การติดตั้ง / การตั้งค่า

#### Cache-Aside — Python

```python
# src/infrastructure/cache/redis_cache.py
import json
import asyncio
from typing import Optional, TypeVar, Generic
from redis.asyncio import Redis

T = TypeVar("T")


class RedisCache(Generic[T]):
    def __init__(self, redis: Redis, default_ttl: int = 300):
        self.redis = redis
        self.default_ttl = default_ttl
        self._locks: dict[str, asyncio.Lock] = {}

    async def get(self, key: str) -> Optional[T]:
        raw = await self.redis.get(key)
        return json.loads(raw) if raw else None

    async def set(self, key: str, value: T, ttl: Optional[int] = None) -> None:
        await self.redis.set(
            key, json.dumps(value, default=str),
            ex=ttl or self.default_ttl,
        )

    async def delete(self, key: str) -> None:
        await self.redis.delete(key)

    async def get_or_load(self, key: str, loader, ttl: Optional[int] = None) -> T:
        """Cache-Aside with anti-stampede lock"""
        cached = await self.get(key)
        if cached is not None:
            return cached

        # Anti-stampede: 1 loader per key
        lock = self._locks.setdefault(key, asyncio.Lock())
        async with lock:
            # Double-check หลังได้ lock
            cached = await self.get(key)
            if cached is not None:
                return cached

            value = await loader()
            await self.set(key, value, ttl)
            return value


# ── Usage ─────────────────────────────────────────────
cache = RedisCache(redis_client, default_ttl=300)

async def get_product(product_id: str):
    return await cache.get_or_load(
        key=f"product:{product_id}",
        loader=lambda: product_repo.find_by_id(product_id),
        ttl=300,
    )
```

#### Cache-Aside — Go

```go
// internal/infrastructure/cache/redis_cache.go
package cache

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/redis/go-redis/v9"
	"golang.org/x/sync/singleflight"
)

type RedisCache struct {
	client *redis.Client
	sf     singleflight.Group
}

func NewRedisCache(client *redis.Client) *RedisCache {
	return &RedisCache{client: client}
}

func (c *RedisCache) GetOrLoad(
	ctx context.Context,
	key string,
	ttl time.Duration,
	loader func(ctx context.Context) (any, error),
) (any, error) {
	// 1. Try cache
	raw, err := c.client.Get(ctx, key).Result()
	if err == nil {
		var v any
		if err := json.Unmarshal([]byte(raw), &v); err == nil {
			return v, nil
		}
	} else if !errors.Is(err, redis.Nil) {
		return nil, err
	}

	// 2. Singleflight — 1 loader per key
	v, err, _ := c.sf.Do(key, func() (any, error) {
		// Double-check
		raw, err := c.client.Get(ctx, key).Result()
		if err == nil {
			var v any
			if err := json.Unmarshal([]byte(raw), &v); err == nil {
				return v, nil
			}
		}

		// Load from DB
		value, err := loader(ctx)
		if err != nil {
			return nil, err
		}

		// Store in cache
		data, _ := json.Marshal(value)
		c.client.Set(ctx, key, data, ttl)
		return value, nil
	})

	return v, err
}
```

#### Cache-Aside — TypeScript

```typescript
// src/infrastructure/cache/redis-cache.ts
import { Injectable } from '@nestjs/common';
import { Redis } from 'ioredis';

@Injectable()
export class RedisCache {
  private inFlight = new Map<string, Promise<unknown>>();

  constructor(private readonly redis: Redis) {}

  async getOrLoad<T>(
    key: string,
    ttlSeconds: number,
    loader: () => Promise<T>,
  ): Promise<T> {
    // 1. Try cache
    const raw = await this.redis.get(key);
    if (raw) return JSON.parse(raw) as T;

    // 2. Anti-stampede: dedupe in-flight
    if (this.inFlight.has(key)) {
      return this.inFlight.get(key) as Promise<T>;
    }

    const promise = (async () => {
      try {
        // Double-check after lock
        const raw2 = await this.redis.get(key);
        if (raw2) return JSON.parse(raw2) as T;

        const value = await loader();
        await this.redis.set(key, JSON.stringify(value), 'EX', ttlSeconds);
        return value;
      } finally {
        this.inFlight.delete(key);
      }
    })();

    this.inFlight.set(key, promise);
    return promise;
  }

  async invalidate(key: string): Promise<void> {
    await this.redis.del(key);
  }
}
```

#### Distributed Lock (Redlock)

```python
# src/infrastructure/lock/redis_lock.py
from contextlib import asynccontextmanager
from uuid import uuid4
from redis.asyncio import Redis

@asynccontextmanager
async def redis_lock(
    redis: Redis,
    resource: str,
    ttl_ms: int = 10000,
    wait_timeout_ms: int = 5000,
):
    """Distributed lock with Redlock-like semantics"""
    lock_key = f"lock:{resource}"
    token = str(uuid4())
    acquired = False

    # Try to acquire with timeout
    import asyncio, time
    deadline = time.monotonic() + wait_timeout_ms / 1000

    while time.monotonic() < deadline:
        acquired = await redis.set(
            lock_key, token,
            nx=True,           # Only if not exists
            px=ttl_ms,         # TTL in ms
        )
        if acquired:
            break
        await asyncio.sleep(0.05)  # Retry backoff

    if not acquired:
        raise TimeoutError(f"Could not acquire lock: {resource}")

    try:
        yield token
    finally:
        # Release only if still ours (Lua script for atomicity)
        lua = """
        if redis.call("get", KEYS[1]) == ARGV[1] then
            return redis.call("del", KEYS[1])
        else
            return 0
        end
        """
        await redis.eval(lua, 1, lock_key, token)


# ── Usage ─────────────────────────────────────────────
async def update_stock(product_id: str, delta: int):
    async with redis_lock(redis, f"stock:{product_id}"):
        current = int(await redis.get(f"stock:{product_id}") or 0)
        await redis.set(f"stock:{product_id}", current + delta)
```

> **คำเตือน:** Redlock ของ Redis ถูกวิจารณ์เรื่องความปลอดภัย (Martin Kleppmann vs Salvatore Sanfilippo) — **ใช้ Fencing Token** เสมอถ้า Critical

#### Event-based Invalidation

```python
# Consumer ลบ Cache เมื่อ Product เปลี่ยน
async def on_product_updated(event):
    product_id = event['product_id']
    await cache.delete(f"product:{product_id}")
    await cache.delete(f"product:list:page:*")  # ถ้ามี list cache
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| ข้อมูล Cache เก่า | ไม่มี Invalidation | ใช้ TTL + Event-based |
| Cache Stampede | Key หมดอายุพร้อมกัน | ใช้ Lock/Singleflight |
| Cache กับ DB ไม่ตรง | Write-Through ผิด | เปลี่ยนเป็น Cache-Aside + DELETE |
| Lock ค้าง | TTL นาน, Process ตาย | ตั้ง TTL สั้น + Fencing Token |

### ลำดับการจัดการปัญหา

1. Cache ผิดไหม? — เปรียบเทียบ `GET cache:key` กับ DB
2. Invalidation ครบไหม? — Write/Delete path เรียก `cache.delete`?
3. Stampede? — ใช้ Lock/Singleflight?
4. Lock ค้าง? — `redis-cli TTL lock:xxx`

### Template Code
→ ดู Cache-Aside (Python/Go/TS), Lock ด้านบน

### Template Dashboard
→ ใช้ **Redis Overview** (เล่ม 5) + Panel: Hit Rate, Eviction

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** ลด Latency, ลด DB Load, Pattern ชัดเจน
- **ข้อควรระวัง:** **DELETE ไม่ใช่ SET** เมื่อ Write; **TTL + Event-based** ร่วมกัน; **Anti-stampede** ทุกครั้ง
- **ข้อดี:** Cache-Aside ยืดหยุ่น, Distributed Lock ทำงานข้าม Node
- **ข้อเสีย:** Redlock ถูกวิจารณ์เรื่อง Safety (ต้องมี Fencing Token)
- **ข้อห้าม:**
  - ❌ `SET` Cache เมื่อ Write — ใช้ `DELETE`
  - ❌ ตั้ง TTL = 0 (ไม่หมดอายุ) บน Cache
  - ❌ ใช้ Redlock โดยไม่มี Fencing Token ใน Critical Section
  - ❌ ใช้ Distributed Lock แทน DB Transaction (มันไม่ใช่)

### ตัวอย่าง (Fencing Token)

```python
# ทุกครั้งที่ได้ Lock → เพิ่ม Token
token = await redis.incr("fence:stock")
async with redis_lock(redis, "stock:123"):
    # ใช้ token นี้ตรวจก่อน write ลง DB
    if token < last_seen_token:
        raise StaleLockError()
    await db.execute("UPDATE stock SET ... WHERE last_token < %s", token)
```

### สรุปย่อเพื่อจดจำ
> **Redis Cache** — Cache-Aside = ตรวจ Cache → Miss → Load DB → Set Cache — **DELETE on Write** — TTL + Event-based Invalidation — Anti-stampede ด้วย Lock/Singleflight — Redlock + Fencing Token

### แหล่งที่มา
- AWS, "Caching Best Practices" 
- Martin Kleppmann, "How to do Distributed Locking" (2016)
- Redis Docs: Distributed Locks
- Salvatore Sanfilippo, "Is Redlock safe?" (2016)


## 10.2 Kafka (ERP Context) — Transactional Outbox, Saga, Event Sourcing, Idempotency, Exactly-Once Semantics

### เรื่อง
Kafka Patterns สำหรับ ERP — ให้ DB + Event สอดคล้องกัน, Distributed Transaction, และ Idempotency

### วัตถุประสงค์ / เป้าหมาย
- ไม่มี Event หาย (Transactional Outbox)
- Distributed Transaction ที่ Compensate ได้ (Saga)
- Consumer ไม่ Double-process (Idempotency)
- Event Sourcing สำหรับ Audit-heavy Domain
- Exactly-Once Semantics

### เนื้อหา / รายละเอียด

#### ปัญหา: Dual Write (DB + Kafka)

```
┌─────────────┐
│  Service    │
│             │
│  1. DB Write│──┐
│             │  │ ถ้า fail ที่นี่ → DB ok, Event หาย
│  2. Kafka   │──┘
│     Publish │  │ ถ้า fail ที่นี่ → Event ok, DB หาย
└─────────────┘
```

**ปัญหา:** ถ้าเขียน DB สำเร็จแต่ Publish Kafka ล้มเหลว (หรือกลับกัน) → **ข้อมูลไม่สอดคล้อง**

#### วิธีแก้: Transactional Outbox Pattern

```
┌────────────────────────────────────────────┐
│  Service                                   │
│  ┌──────────────────────────────────────┐  │
│  │ BEGIN TRANSACTION                    │  │
│  │   INSERT INTO orders ...             │  │
│  │   INSERT INTO outbox (event) ...     │  │
│  │ COMMIT                               │  │
│  └──────────────────────────────────────┘  │
│                    │                       │
│                    ▼                       │
│  ┌──────────────────────────────────────┐  │
│  │ Outbox Relay (Background)            │  │
│  │   SELECT * FROM outbox WHERE sent=false│
│  │   → Publish to Kafka                 │  │
│  │   → UPDATE outbox SET sent=true      │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
```

**ข้อดี:**
- DB + Event atomic (Transaction เดียว)
- ทนต่อ Kafka down (Relay retry)
- ไม่มี Event หาย

**ข้อเสีย:**
- At-least-once (อาจมี duplicate) → ต้อง Idempotent Consumer
- ต้องมี Relay process

#### Saga Pattern — 2 แบบ

| แบบ | Coordinator | ข้อดี | ข้อเสีย |
|---|---|---|---|
| **Orchestration** | มี (Saga Orchestrator) | มองเห็น Flow ชัด, Debug ง่าย | Single Point of Failure |
| **Choreography** | ไม่มี | ไม่มี SPOF, Loose coupling | Debug ยาก, Flow กระจัดกระจาย |

**Orchestration Saga Flow (Order → Inventory → Billing):**

```
OrderService (Orchestrator)
    │
    ├─▶ 1. Create Order (local tx)
    │      │ (fail) → end
    │      ▼
    ├─▶ 2. Reserve Inventory (call InventoryService)
    │      │ (fail) → Compensate: Cancel Order
    │      ▼
    ├─▶ 3. Charge Payment (call BillingService)
    │      │ (fail) → Compensate: Release Inventory + Cancel Order
    │      ▼
    └─▶ 4. Confirm Order (local tx)
```

#### Idempotency — 3 ระดับ

| ระดับ | วิธี | ใช้เมื่อ |
|---|---|---|
| **Idempotency Key** | Consumer เก็บ key ที่เคยประมวลผล → skip ถ้าซ้ำ | Consumer ทั่วไป |
| **Idempotent Operation** | Operation ที่ทำซ้ำได้ (UPSERT, SET) | DB Write |
| **Kafka Transactions (EOS)** | Kafka รับประกัน exactly-once | Producer + Consumer ใน Kafka เดียว |

> **แนะนำ:** ใช้ **Idempotency Key + UPSERT** — ง่ายและทนต่อ Failure ทุกแบบ

### การติดตั้ง / การตั้งค่า

#### Transactional Outbox — Schema

```sql
CREATE TABLE outbox_events (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    aggregate_id UUID NOT NULL,
    event_type   VARCHAR(100) NOT NULL,
    payload      JSONB NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    sent_at      TIMESTAMPTZ,
    retry_count  INT NOT NULL DEFAULT 0,
    last_error   TEXT
);

CREATE INDEX idx_outbox_unsent ON outbox_events (created_at)
    WHERE sent_at IS NULL;
```

#### Outbox — Python (Write in Transaction)

```python
# src/application/use_cases/place_order.py
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import insert
import json

class PlaceOrderUseCase:
    def __init__(self, session: AsyncSession, order_repo, outbox_repo):
        self.session = session
        self.order_repo = order_repo
        self.outbox_repo = outbox_repo

    async def execute(self, input: PlaceOrderInput) -> OrderId:
        order = Order.create(customer_id=CustomerId(input.customer_id))
        for line in input.lines:
            order.add_line(line.product_id, line.quantity, Money(line.unit_price))
        order.confirm()

        async with self.session.begin():
            # 1. Save Domain
            await self.order_repo.save(order)

            # 2. Save Outbox (ใน Transaction เดียว!)
            for event in order.collect_events():
                await self.outbox_repo.save({
                    "aggregate_id": order.id.value,
                    "event_type": event.event_type,
                    "payload": json.dumps(asdict(event), default=str),
                })

        # Transaction commit → DB + Outbox atomic
        return order.id
```

#### Outbox Relay — Python

```python
# src/infrastructure/messaging/outbox_relay.py
import asyncio
from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession

class OutboxRelay:
    def __init__(self, session_factory, producer, interval=1.0, batch_size=100):
        self.session_factory = session_factory
        self.producer = producer
        self.interval = interval
        self.batch_size = batch_size
        self._running = False

    async def start(self):
        self._running = True
        while self._running:
            try:
                await self._relay_batch()
            except Exception as e:
                print(f"Relay error: {e}")
            await asyncio.sleep(self.interval)

    async def _relay_batch(self):
        async with self.session_factory() as session:
            async with session.begin():
                # 1. Lock rows (SELECT ... FOR UPDATE SKIP LOCKED)
                result = await session.execute(
                    select(OutboxEvent)
                    .where(OutboxEvent.sent_at.is_(None))
                    .order_by(OutboxEvent.created_at)
                    .limit(self.batch_size)
                    .with_for_update(skip_locked=True)
                )
                events = result.scalars().all()

                for event in events:
                    try:
                        await self.producer.send(
                            topic=f"erp.{event.event_type}",
                            key=str(event.aggregate_id),
                            value=event.payload,
                        )
                        event.sent_at = datetime.utcnow()
                    except Exception as e:
                        event.retry_count += 1
                        event.last_error = str(e)
```

> **หมายเหตุ:** ใน Production ควรใช้ **Debezium** (CDC จาก PostgreSQL WAL) แทน Relay — เร็วและไม่ต้อง poll

#### Transactional Outbox — Go

```go
// internal/application/order/place_order.go
func (uc *PlaceOrderUseCase) Execute(ctx context.Context, input PlaceOrderInput) (domain.OrderID, error) {
	order, err := domain.NewOrder(parseCustomerID(input.CustomerID))
	if err != nil { return domain.OrderID{}, err }

	for _, line := range input.Lines {
		if err := order.AddLine(line.ProductID, line.Quantity, domain.NewMoney(line.UnitPrice, "THB")); err != nil {
			return domain.OrderID{}, err
		}
	}
	if err := order.Confirm(); err != nil {
		return domain.OrderID{}, err
	}

	// Transaction เดียว: Order + Outbox
	err = uc.uow.Do(ctx, func(txCtx context.Context) error {
		if err := uc.orderRepo.Save(txCtx, order); err != nil {
			return err
		}
		for _, event := range order.CollectEvents() {
			if err := uc.outboxRepo.Save(txCtx, event); err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil { return domain.OrderID{}, err }
	return order.ID, nil
}
```

#### Idempotent Consumer — Python

```python
# src/infrastructure/messaging/idempotent_consumer.py
import json
from aiokafka import AIOKafkaConsumer

class IdempotentConsumer:
    def __init__(self, consumer: AIOKafkaConsumer, db, handler):
        self.consumer = consumer
        self.db = db
        self.handler = handler

    async def run(self):
        async for msg in self.consumer:
            event = json.loads(msg.value)
            idempotency_key = f"{msg.topic}:{msg.partition}:{msg.offset}"

            # ตรวจว่าเคยประมวลผลแล้วหรือยัง
            async with self.db.begin():
                result = await self.db.execute(
                    "INSERT INTO processed_events (idempotency_key, processed_at) "
                    "VALUES (%s, now()) ON CONFLICT DO NOTHING RETURNING id",
                    (idempotency_key,),
                )
                inserted = await result.fetchone()

                if not inserted:
                    # Duplicate → skip
                    continue

                # ประมวลผล Business Logic
                await self.handler(event)

            await self.consumer.commit()
```

#### Idempotent Consumer — Go

```go
// internal/infrastructure/messaging/idempotent_consumer.go
func (c *Consumer) Run(ctx context.Context) error {
	for {
		msg, err := c.reader.FetchMessage(ctx)
		if err != nil { return err }

		key := fmt.Sprintf("%s:%d:%d", msg.Topic, msg.Partition, msg.Offset)

		// Idempotency check + business logic ใน transaction เดียว
		err = c.uow.Do(ctx, func(txCtx context.Context) error {
			inserted, err := c.idempotencyRepo.MarkProcessed(txCtx, key)
			if err != nil || !inserted {
				return nil // already processed
			}
			return c.handler(txCtx, msg)
		})
		if err != nil {
			return err // จะ retry
		}

		if err := c.reader.CommitMessages(ctx, msg); err != nil {
			return err
		}
	}
}
```

#### Saga Orchestration — Python

```python
# src/application/sagas/place_order_saga.py
from enum import Enum

class SagaState(Enum):
    STARTED = "started"
    INVENTORY_RESERVED = "inventory_reserved"
    PAYMENT_CHARGED = "payment_charged"
    COMPLETED = "completed"
    COMPENSATING = "compensating"
    FAILED = "failed"

class PlaceOrderSaga:
    def __init__(self, order_service, inventory_service, billing_service, saga_log):
        self.order_service = order_service
        self.inventory_service = inventory_service
        self.billing_service = billing_service
        self.saga_log = saga_log

    async def execute(self, order_id: str, lines: list, customer_id: str):
        state = SagaState.STARTED
        compensation_stack = []

        try:
            # Step 1: Reserve Inventory
            await self.inventory_service.reserve(order_id, lines)
            compensation_stack.append(
                lambda: self.inventory_service.release(order_id, lines)
            )
            state = SagaState.INVENTORY_RESERVED
            await self.saga_log.record(order_id, "inventory_reserved")

            # Step 2: Charge Payment
            await self.billing_service.charge(order_id, customer_id, amount)
            compensation_stack.append(
                lambda: self.billing_service.refund(order_id)
            )
            state = SagaState.PAYMENT_CHARGED
            await self.saga_log.record(order_id, "payment_charged")

            # Step 3: Confirm Order
            await self.order_service.confirm(order_id)
            state = SagaState.COMPLETED
            await self.saga_log.record(order_id, "completed")

        except Exception as e:
            # Compensate (ย้อนหลังตามลำดับ)
            state = SagaState.COMPENSATING
            for compensate in reversed(compensation_stack):
                try:
                    await compensate()
                except Exception as comp_err:
                    # Log ไว้ manual intervention
                    await self.saga_log.record_compensation_failure(order_id, comp_err)

            state = SagaState.FAILED
            raise
```

#### Saga Choreography — Event-driven

```python
# Consumer ฟัง Event และทำงานต่อ
# OrderService
async def on_order_placed(event):
    await inventory_service.reserve(event['order_id'], event['lines'])
    await kafka.publish("inventory.reserved", {"order_id": event['order_id']})

# InventoryService → เมื่อ reserve สำเร็จ
async def on_inventory_reserved(event):
    await billing_service.charge(event['order_id'])
    await kafka.publish("payment.charged", {"order_id": event['order_id']})

# BillingService → เมื่อ charge สำเร็จ
async def on_payment_charged(event):
    await order_service.confirm(event['order_id'])
    await kafka.publish("order.confirmed", {"order_id": event['order_id']})

# Compensation: ฟัง Event ที่ fail
async def on_payment_failed(event):
    # ย้อน inventory
    await inventory_service.release(event['order_id'])
    await kafka.publish("inventory.released", {"order_id": event['order_id']})
```

#### Event Sourcing (Audit-heavy)

```python
# Event Store (แทนการเก็บ State ปัจจุบัน)
CREATE TABLE event_store (
    aggregate_id UUID NOT NULL,
    version INT NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    payload JSONB NOT NULL,
    occurred_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (aggregate_id, version)
);

# Replay State จาก Event
async def rebuild_order(order_id):
    events = await db.fetch(
        "SELECT * FROM event_store WHERE aggregate_id = $1 ORDER BY version",
        order_id,
    )
    order = None
    for event in events:
        if event['event_type'] == 'order.created':
            order = Order.create(...)
        elif event['event_type'] == 'order.line_added':
            order.add_line(...)
        elif event['event_type'] == 'order.confirmed':
            order.confirm()
    return order
```

> **Event Sourcing ใช้เมื่อ:** ต้องการ Audit Trail ครบ, Temporal Query ("state ณ วันที่ X"), Debug ที่ต้อง replay

#### Exactly-Once Semantics (Kafka Transactions)

```python
# Producer — EOS
producer = AIOKafkaProducer(
    bootstrap_servers="kafka:9092",
    transactional_id="order-producer-1",   # ต้อง unique per producer instance
    enable_idempotence=True,
)
await producer.start_transaction()
try:
    await producer.send_and_wait("orders", order_event)
    await producer.send_and_wait("inventory", inventory_event)
    await producer.commit_transaction()
except Exception:
    await producer.abort_transaction()

# Consumer — read_committed
consumer = AIOKafkaConsumer(
    "orders",
    bootstrap_servers="kafka:9092",
    isolation_level="read_committed",   # ไม่เห็น uncommitted
)
```

> **หมายเหตุ:** EOS ของ Kafka รับประกันเฉพาะ **Kafka → Kafka** — ถ้ามี DB ด้วย ต้องใช้ Outbox + Idempotency

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| Event หาย | Dual Write (ไม่ใช้ Outbox) | ใช้ Outbox Pattern |
| Duplicate processing | Consumer ไม่ Idempotent | เพิ่ม Idempotency Key |
| Outbox โตไม่หยุด | Relay ตาย / Kafka down | ตรวจ Relay, Monitor Outbox size |
| Saga ค้าง | Compensate ล้มเหลว | Manual intervention, Alert |
| Event ordering ผิด | หลาย Partition | ใช้ Key เดียว (partition เดียว) |

### ลำดับการจัดการปัญหา (Event หาย)

1. **ตรวจ Outbox** — มี record `sent_at IS NULL` ไหม?
2. **ตรวจ Relay** — Process รันไหม? Log?
3. **ตรวจ Kafka** — Topic มีอยู่? Broker UP?
4. **ตรวจ Consumer** — Subscribe topic? Commit offset?
5. **แก้:** Restart Relay, ตรวจ Kafka, Replay จาก Outbox

### Template Code
→ ดู Outbox (Python/Go), Idempotent Consumer, Saga ด้านบน

### Template Dashboard
→ เพิ่ม Panel: **Outbox Pending**, **Saga State Distribution**, **Idempotency Skip Rate** ใน Application Dashboard (เล่ม 3)

### Diagram: ERP Integration Flow

```
┌──────────────┐
│ OrderService │
│  (Create)    │
└──────┬───────┘
       │ 1. DB + Outbox (atomic)
       ▼
┌──────────────┐
│   Outbox     │
│   Table      │
└──────┬───────┘
       │ 2. Relay
       ▼
┌──────────────┐
│    Kafka     │
│ order.placed │
└──┬───────┬───┘
   │       │
   ▼       ▼
┌────────┐ ┌────────┐
│Inventory│ │Billing │
│Service │ │Service │
└────────┘ └────────┘
   │            │
   ▼            ▼
┌────────┐ ┌────────┐
│Order   │ │Payment │
│State   │ │State   │
└────────┘ └────────┘
```

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** DB + Event atomic, Saga Compensate ได้, Idempotency ครบ
- **ข้อควรระวัง:** **Outbox Relay ต้อง Monitor** — ถ้าตาย Event จะค้าง; **Idempotency Key ต้อง Unique**; **EOS เฉพาะ Kafka→Kafka**
- **ข้อดี:** Outbox ทนทานทุก Failure, Saga มองเห็น Flow
- **ข้อเสีย:** Outbox เพิ่ม Table + Relay; Saga Orchestration = SPOF
- **ข้อห้าม:**
  - ❌ Dual Write (DB + Kafka ในที่เดียว) — ใช้ Outbox เสมอ
  - ❌ Consumer ไม่ Idempotent (At-least-once = duplicate)
  - ❌ ใช้ `acks=0` สำหรับ Critical Event (อาจหาย)
  - ❌ Saga Compensate โดยไม่มี Log (จะไม่รู้ว่าทำอะไรไปแล้ว)
  - ❌ ใช้ Event Sourcing สำหรับ Domain ที่ไม่ต้อง Audit (Over-engineering)
  - ❌ ลืม Monitor Outbox Table (จะโตไม่หยุดถ้า Relay ตาย)

### ตัวอย่าง (Debezium Outbox แทน Custom Relay)

```json
{
  "name": "outbox-connector",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "postgres",
    "database.dbname": "erp",
    "table.include.list": "public.outbox_events",
    "transforms": "outbox",
    "transforms.outbox.type": "io.debezium.transforms.outbox.EventRouter",
    "transforms.outbox.route.by.field": "event_type"
  }
}
```

### สรุปย่อเพื่อจดจำ
> **Kafka ERP Patterns** — Transactional Outbox (DB + Event atomic) — Saga (Orchestration = Coordinator, Choreography = Event) — Idempotency Key + UPSERT — EOS เฉพาะ Kafka→Kafka — Event Sourcing สำหรับ Audit

### แหล่งที่มา
- Chris Richardson, *Microservices Patterns* (Manning, 2018)
- microservices.io: Transactional Outbox, Saga
- Debezium Docs: Outbox Event Router
- Confluent, "Exactly-Once Semantics" (2018)


## Workflow (อ้างอิงเล่ม 1 + Incident Playbook เฉพาะเล่ม)

### อ้างอิง Workflow หลักจากเล่ม 1

| Workflow | ใช้ในเล่มนี้เมื่อ |
|---|---|
| **PSR** | เขียนรายงานหลัง Integration Incident |
| **RCA 5 Whys** | หา Root Cause ของ Event หาย / Duplicate |
| **KPI SMART** | ตั้ง KPI ของ Integration (เช่น 0 Event หาย, Duplicate < 0.01%) |

→ Template เต็มอยู่ใน **เล่ม 1 หัวข้อ 4**

### Incident Playbook เฉพาะเล่ม 10

#### Playbook A: Outbox ค้าง (Event ไม่ถึง Kafka)

1. **ตรวจ Outbox** — `SELECT COUNT(*) FROM outbox_events WHERE sent_at IS NULL;`
2. **ตรวจ Relay** — Process รันไหม? Log?
3. **ตรวจ Kafka** — `kafka-topics.sh --list`, Broker UP?
4. **ตรวจ Lock** — Relay ติด Lock ไหม? (`SELECT * FROM outbox_events FOR UPDATE`)
5. **แก้:** Restart Relay, ตรวจ Kafka, Clear Stale Locks
6. **Monitor** — `rate(outbox_events_unsent)` — ต้องลดลง

#### Playbook B: Duplicate Processing

1. **ยืนยัน** — Consumer log มี "duplicate" หรือผลลัพธ์ซ้ำ?
2. **ตรวจ Idempotency Table** — `SELECT COUNT(*) FROM processed_events WHERE idempotency_key = ...`
3. **ตรวจ Consumer** — ใช้ Idempotency Key ไหม?
4. **ตรวจ EOS** — `isolation_level=read_committed`?
5. **แก้:** เพิ่ม Idempotency Key ใน Consumer, ใช้ UPSERT

#### Playbook C: Saga ค้าง (Compensation ล้มเหลว)

1. **ตรวจ Saga Log** — `SELECT * FROM saga_log WHERE state = 'compensating'`
2. **ตรวจ Step ที่ Fail** — Error อะไร?
3. **Manual Compensate** — เรียก compensation ด้วยมือ
4. **แก้ Root Cause** — ปรับ retry / timeout
5. **Alert** — `SagaStuck` alert

#### Playbook D: Cache Stampede

1. **ยืนยัน** — DB Load spike ตอน Cache Miss
2. **ตรวจ Cache** — Key หมดอายุพร้อมกัน?
3. **แก้:** ใช้ Lock/Singleflight, Probabilistic Early Expiration
4. **ระหว่างแก้** — Pre-warm Cache

### Runbook: Replay Failed Events

```bash
# 1. ดู Event ที่ค้าง
psql -c "SELECT id, event_type, retry_count, last_error FROM outbox_events WHERE sent_at IS NULL AND retry_count > 3;"

# 2. Reset retry_count (หลังแก้ Root Cause)
psql -c "UPDATE outbox_events SET retry_count = 0 WHERE sent_at IS NULL AND retry_count > 3;"

# 3. Relay จะส่งใหม่ภายใน 1 วินาที
```

### Runbook: Cache Warm-up

```python
async def warm_cache():
    """โหลดข้อมูล Hot เข้า Cache ล่วงหน้า"""
    products = await db.fetch("SELECT * FROM products WHERE popular = true LIMIT 1000")
    for p in products:
        await cache.set(f"product:{p['id']}", p, ttl=3600)
    print(f"Warmed {len(products)} products")
```

### Runbook: Outbox Table Cleanup

```sql
-- ลบ Outbox ที่ส่งสำเร็จแล้วเกิน 7 วัน
DELETE FROM outbox_events
WHERE sent_at IS NOT NULL
  AND sent_at < now() - INTERVAL '7 days';

-- ตรวจ Outbox ที่ค้างนาน
SELECT COUNT(*), MAX(now() - created_at) AS oldest_age
FROM outbox_events
WHERE sent_at IS NULL;
```


## สรุป (ประโยชน์, ข้อดี, ข้อเสีย, ข้อห้าม)

### ประโยชน์ของเล่ม 10

- **Correctness:** DB + Event atomic (Outbox), Distributed Transaction (Saga), Idempotency ครบ
- **Resilience:** ทนต่อ Kafka down, Compensate ได้
- **Audit:** Event Sourcing สำหรับ Compliance
- **Runbook พร้อม:** 3 Runbook + 4 Playbook
- **Integration:** ใช้ DDD (เล่ม 8) + DB (เล่ม 9) + Observability (เล่ม 5)

### ข้อดี

| ด้าน | ผลลัพธ์ |
|---|---|
| **Data Integrity** | 0 Event หาย, Duplicate < 0.01% |
| **Resilience** | ทนต่อ Failure ทุก Layer |
| **Debug** | Saga Log + Outbox Table = X-Ray |
| **Compliance** | Event Sourcing ครบ |
| **Standardization** | Pattern เดียวทั้งองค์กร |

### ข้อเสีย / ข้อจำกัด

- **Complexity:** Outbox + Relay + Idempotency = Code เยอะ
- **Latency:** Outbox Relay เพิ่ม 1-5s (ถ้า poll)
- **Storage:** Outbox + Event Store โตเร็ว
- **Saga Orchestration** = SPOF (ต้อง HA)
- **Redlock** ถูกวิจารณ์ (ต้อง Fencing Token)

### ข้อห้าม (สรุป)

1. ❌ **Dual Write** (DB + Kafka ในที่เดียว) — ใช้ Outbox เสมอ
2. ❌ **Consumer ไม่ Idempotent** — At-least-once = duplicate
3. ❌ **`acks=0`** สำหรับ Critical Event — ใช้ `acks=all`
4. ❌ **Saga Compensate โดยไม่มี Log** — จะไม่รู้ว่าทำอะไรไป
5. ❌ **Event Sourcing สำหรับ Domain ง่าย** — Over-engineering
6. ❌ **ลืม Monitor Outbox** — จะโตไม่หยุดถ้า Relay ตาย
7. ❌ **`SET` Cache เมื่อ Write** — ใช้ `DELETE`
8. ❌ **Redlock โดยไม่มี Fencing Token** — Critical Section เสี่ยง
9. ❌ **Outbox Cleanup ไม่ตั้งเวลา** — Table โตไม่หยุด
10. ❌ **ใช้ EOS แทน Outbox** — EOS ครอบคลุมแค่ Kafka→Kafka

---

## บทส่งท้าย: สรุปทั้งชุด 10 เล่ม

### เส้นทางการอ่านครบทั้ง 10 เล่ม

| เส้นทาง | ลำดับ | ผลลัพธ์ |
|---|---|---|
| **A: Monitoring Engineer** | 1 → 2 → 3 → 4 → 5 | ดูแล Monitoring Stack ครบ |
| **B: Business App Support** | 1 → 3 → 7 | ดูแล CRM พร้อม Monitoring |
| **C: ERP Developer** | 1 → 3 → 8 → 9 → 10 | ออกแบบ ERP DDD + DB + Integration |
| **D: ERP Support (Full-stack)** | 1 → 3 → 4 → 5 → 8 → 9 → 10 | ดูแล ERP ครบทุก Layer |
| **E: AI Engineer** | 1 → 4 → 5 → 6 | ดูแล Vector DB และ RAG |

### หลักการที่สอดคล้องกันทั้งชุด

1. **Workflow กลาง:** PSR / RCA / KPI SMART (เล่ม 1) — ทุกเล่มอ้างอิง
2. **Observability Stack:** Prometheus + Grafana + Alertmanager (เล่ม 3) — ทุกเล่มใช้
3. **No Duplication:** หัวข้อซ้ำ (Kafka, Redis, Prometheus) — เขียนเต็มครั้งแรก + อ้างอิงกลับ
4. **Role-based:** แต่ละเล่มตรงกับบทบาทผู้อ่าน
5. **Self-contained:** แต่ละเล่มอ่านจบได้ในตัวเอง

### สิ่งที่ต้องทำต่อ (Continuous Improvement)

- **Quarterly Review:** ทบทวน Metrics / Alert / Runbook ทุก Quarter
- **Post-Incident Update:** หลัง Incident ใหญ่ — อัปเดต Playbook
- **Golden Set Update:** สำหรับ RAG (เล่ม 6) — อัปเดตทุก Quarter
- **Version Pinning:** ทุก Tool (Prometheus, Grafana, Kafka, Redis) — Pin version

---

## เส้นทางอ่านต่อ (จากเล่ม 10)

| ถ้าคุณเป็น | อ่านต่อ |
|---|---|
| Integration Engineer | → ฝึก Debezium + Kafka Transactions เพิ่ม |
| ERP Support | → อ่านจบเส้นทาง D แล้ว |
| Solution Architect | → อ่าน *Microservices Patterns* (Richardson) + *Enterprise Integration Patterns* (Hohpe) |

---

> **เวอร์ชันเอกสาร:** 1.0
> **ผู้รับผิดชอบ:** Integration Team + SRE Team
> **ปรับปรุงล่าสุด:** ตามรอบ Quarter
> **สถานะ:** ✅ Ready for Review
> **ชุดเอกสาร:** ครบ 10 เล่ม (1–10)

---
 