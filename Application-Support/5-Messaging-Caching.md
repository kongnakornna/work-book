## เล่ม 5: Messaging & Caching (Observability) — "ดูแล Pipeline และ Cache ในมุม Monitoring"
**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับ

> **กลุ่มงาน:** Support Engineer, SRE, Data Pipeline Support
> **Dependency:** อ่านเล่ม 1 (Foundation & Workflow) และเล่ม 3 (Application Metrics & Metrics Platform) ก่อน
> **เวอร์ชัน:** 1.0

---

## บทนำ

### วัตถุประสงค์ของเล่ม

เล่มนี้ครอบคลุม **"Observability ของ Kafka และ Redis"** — ระบบกลางที่เกือบทุก Service ในองค์กรพึ่งพา ทั้งในฐานะ **Message Broker** (Kafka) และ **Cache/Session Store** (Redis) เมื่ออ่านจบ ผู้อ่านจะสามารถ:

1. เข้าใจสถาปัตยกรรม Kafka และ Redis ในมุมที่ Support ต้องรู้
2. ติดตั้ง **`kafka_exporter`** และ **`redis_exporter`** เพื่อดึง Metrics
3. เขียน PromQL สำหรับ **Consumer Lag**, **Hit Rate**, **Eviction**, **Replication Lag**
4. ตั้ง Alert Rules ที่ **actionable** (ไม่ใช่ noise)
5. สร้าง Dashboard ที่ตอบ "ระบบ Messaging/Cache กำลังมีปัญหาหรือไม่" ภายใน 10 วินาที
6. ใช้ Incident Playbook สำหรับ Kafka/Redis โดยเฉพาะ

### เป้าหมายของเล่ม

| เป้าหมาย | ตัวชี้วัดความสำเร็จ |
|---|---|
| เห็น Consumer Lag ก่อน user ร้องเรียน | Alert `KafkaConsumerLagGrowing` fire ก่อน SLA แตก |
| Cache Hit Rate ไม่ต่ำกว่าเป้า | Alert `RedisLowHitRate` fire เมื่อ hit rate < 80% |
| ทราบ Redis Memory ก่อน OOM | Alert `RedisHighMemoryUsage` fire ที่ 85% |
| Kafka Topic ไม่ under-replicated | Alert fire ภายใน 2 นาทีเมื่อ ISR < RF |
| Incident Triage เร็ว | MTTR ลดลงจากการเห็น Lag/Hit Rate ทันที |

### สิ่งที่ **ไม่** อยู่ในเล่มนี้

- **Pattern การใช้งาน** (Outbox, Saga, Cache-Aside) → **เล่ม 10 (ERP Integration Layer)**
- Kafka/Redis ติดตั้งแบบ Production Tuning (JVM, OS, Broker config) → นอกขอบเขต (เฉพาะ Observability)
- Infrastructure Metrics (CPU/RAM/Disk ของ Broker) → **เล่ม 2**
- Log Analysis (ELK) → **เล่ม 4**
- Application Instrumentation ทั่วไป → **เล่ม 3**

### ทำไม Kafka + Redis อยู่เล่มเดียวกัน

ทั้งคู่เป็น **"Stateful Middleware"** ที่ทุก Service พึ่งพา และมี **Observability Pattern ที่คล้ายกัน**:

| ด้าน | Kafka | Redis |
|---|---|---|
| **Health Indicator** | Consumer Lag, ISR | Hit Rate, Eviction |
| **Failure Mode** | Lag โต, Partition offline | Memory เต็ม, Eviction storm |
| **Exporter** | `kafka_exporter` | `redis_exporter` |
| **Support Action** | Scale consumer, rebalance | เพิ่ม Memory, ทบทวน TTL |

> **หมายเหตุสำคัญ:** เล่ม 5 = **Observability** (Lag, Hit Rate, Eviction) — เล่ม 10 = **Patterns** (Outbox, Saga, Cache-Aside, Distributed Lock) — เป็น **คนละทักษะ** ห้ามเขียนซ้ำ

---

## บทนิยาม (เฉพาะคำศัพท์ใหม่ในเล่มนี้)

### Kafka

| คำศัพท์ | ความหมาย |
|---|---|
| **Broker** | Server 1 ตัวใน Kafka Cluster ที่เก็บ Partition |
| **Topic** | หมวดหมู่ของ Message (เปรียบเหมือน Table) |
| **Partition** | ชิ้นส่วนของ Topic ที่เรียงลำดับ (ordering guarantee ภายใน Partition) |
| **Replication Factor (RF)** | จำนวนสำเนาของ Partition (RF=3 = ทน node เสีย 2 ตัว) |
| **ISR (In-Sync Replica)** | Replica ที่ตาม Leader ทัน — ถ้า ISR < RF = under-replicated |
| **Leader / Follower** | Partition มี Leader 1 ตัว (write/read), Follower sync ข้อมูล |
| **Consumer Group** | กลุ่ม Consumer ที่แบ่ง Partition กันอ่าน |
| **Consumer Lag** | `Log End Offset − Consumer Offset` = จำนวน message ที่ยังไม่ถูกอ่าน |
| **Log End Offset (LEO)** | ตำแหน่งล่าสุดของ message ใน Partition |
| **Consumer Offset** | ตำแหน่งที่ Consumer อ่านถึง |
| **Rebalance** | กระบวนการ redistribute Partition เมื่อ Consumer เข้า/ออก |
| **Under-Replicated Partition** | Partition ที่ ISR < RF = เสี่ยงข้อมูลหาย |
| **Offline Partition** | Partition ที่ไม่มี Leader = อ่าน/เขียนไม่ได้ |
| **`kafka_exporter`** | Prometheus Exporter (ภาษา Go) ดึง Metrics จาก Kafka |

### Redis

| คำศัพท์ | ความหมาย |
|---|---|
| **Cache Hit / Miss** | Request ที่เจอ / ไม่เจอข้อมูลใน Cache |
| **Hit Rate** | `hits / (hits + misses)` — ยิ่งสูงยิ่งดี (เป้า > 80%) |
| **Eviction** | การลบ key ออกเมื่อ Memory เต็ม (ตาม `maxmemory-policy`) |
| **Eviction Policy** | นโยบายลบ: `noeviction`, `allkeys-lru`, `volatile-lru`, `allkeys-lfu`, ฯลฯ |
| **TTL (Time-To-Live)** | เวลาหมดอายุของ key |
| **Replication Lag** | ความล่าช้าระหว่าง Master → Replica (bytes หรือ seconds) |
| **Sentinel / Cluster** | กลไก HA ของ Redis (Sentinel = failover, Cluster = sharding) |
| **Keyspace Hit Rate** | Hit rate ที่คำนวณจาก `keyspace_hits / (keyspace_hits + keyspace_misses)` |
| **Connected Clients** | จำนวน Client ที่เชื่อมต่ออยู่ |
| **Blocked Clients** | Client ที่รอ BLPOP/BRPOP — ถ้าเยอะ = มีปัญหา |
| **`redis_exporter`** | Prometheus Exporter (ภาษา Go) ดึง Metrics จาก Redis INFO |

---

## บทหัวข้อ

---

## 3.6 Kafka (สถาปัตยกรรม, Consumer Lag, `kafka_exporter`, Alert Rules)

### เรื่อง
Observability ของ Kafka — มุมมองที่ Support ต้องรู้เพื่อตอบว่า "Pipeline กำลังติดขัดหรือไม่"

### วัตถุประสงค์ / เป้าหมาย
- เห็น **Consumer Lag** ก่อน user ร้องเรียน
- ตรวจ **Under-Replicated Partition** ทันที (เสี่ยงข้อมูลหาย)
- รู้ **Throughput** ของ Producer/Consumer (messages/sec)
- Alert ที่ **actionable** — บอกว่า "ต้องทำอะไร" ไม่ใช่แค่ "Lag สูง"

### เนื้อหา / รายละเอียด

#### สถาปัตยกรรม (มุมมอง Observability)

```
┌──────────┐    ┌────────────────────────────────┐    ┌──────────┐
│ Producer │───▶│  Kafka Cluster                 │───▶│ Consumer │
│ (App)    │    │  ┌─────────┐  ┌─────────┐      │    │ (App)    │
└──────────┘    │  │Broker 1 │  │Broker 2 │ ...  │    └──────────┘
                │  │Topic A  │  │Topic A  │      │
                │  │ P0(L)   │  │ P0(F)   │      │
                │  │ P1(F)   │  │ P1(L)   │      │
                │  └─────────┘  └─────────┘      │
                │       ▲              ▲           │
                │       │              │           │
                │  ┌────┴──────────────┴────┐      │
                │  │  kafka_exporter        │      │
                │  │  (scrape ทุก 30s)      │      │
                │  └───────────┬────────────┘      │
                └──────────────┼───────────────────┘
                               │
                        ┌──────▼──────┐
                        │ Prometheus  │
                        └─────────────┘
```

#### Metrics ที่ Support ต้องดู (จัดลำดับความสำคัญ)

| ลำดับ | Metric | ความหมาย | ค่าปกติ |
|:---:|---|---|---|
| **1** | `kafka_consumergroup_lag` | จำนวน message ค้าง | < 1000 (ขึ้นกับ throughput) |
| **2** | `kafka_topic_partition_under_replicated_partition` | ISR < RF | **0** (ต้องเป็น 0) |
| **3** | `kafka_topic_partition_offline` | Partition ไม่มี Leader | **0** |
| **4** | `kafka_consumergroup_current_offset` | Offset ล่าสุดของ Consumer | เพิ่มขึ้นเรื่อยๆ |
| **5** | `kafka_topic_partition_current_offset` | LEO ของ Partition | เพิ่มขึ้น |
| **6** | `kafka_brokers` | จำนวน Broker ที่ UP | = cluster size |
| **7** | `kafka_topic_partitions` | จำนวน Partition | คงที่ |
| **8** | `kafka_consumergroup_members` | สมาชิกใน Consumer Group | = ค่าที่ออกแบบ |

#### Consumer Lag — สูตรและการตีความ

```
lag = log_end_offset - consumer_offset
```

**การตีความ:**

| สถานการณ์ | ความหมาย | Action |
|---|---|---|
| Lag คงที่ (แบนราบ) | Consumer ตามทันแล้ว | ✅ ปกติ |
| Lag เพิ่มขึ้นเรื่อยๆ (trend up) | Consumer ตามไม่ทัน | ⚠️ Scale consumer / ตรวจ slow processing |
| Lag ลดลงหลังเพิ่ม | กำลัง catch up | ✅ ปกติ (ชั่วคราว) |
| Lag = 0 | ไม่มี message ค้าง | ✅ ปกติ |
| Lag กระโดดเฉียบพลัน | Producer burst หรือ Consumer ตาย | 🚨 Incident |

> **กฎ:** ดู **`deriv(lag)`** ไม่ใช่แค่ **`lag`** — เพราะ Lag 1000 ที่คงที่ ≠ Lag 1000 ที่เพิ่ม 100/วินาที

### การติดตั้ง / การตั้งค่า

#### Docker Compose (Kafka + `kafka_exporter`)

```yaml
version: "3.8"
services:

  # ── Kafka (KRaft mode — ไม่ต้องมี Zookeeper)
  kafka:
    image: bitnami/kafka:3.7
    container_name: kafka
    restart: unless-stopped
    environment:
      - KAFKA_CFG_NODE_ID=0
      - KAFKA_CFG_PROCESS_ROLES=controller,broker
      - KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@kafka:9093
      - KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093,EXTERNAL://:9094
      - KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092,EXTERNAL://localhost:9094
      - KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,EXTERNAL:PLAINTEXT
      - KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
      - KAFKA_CFG_INTER_BROKER_LISTENER_NAME=PLAINTEXT
      - KAFKA_CFG_OFFSETS_TOPIC_REPLICATION_FACTOR=1   # dev; prod = 3
      - KAFKA_CFG_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1
    ports:
      - "9092:9092"
      - "9094:9094"
    networks: [monitoring]

  # ── kafka_exporter
  kafka-exporter:
    image: danielqsj/kafka-exporter:v1.7.0
    container_name: kafka-exporter
    restart: unless-stopped
    command:
      - "--kafka.server=kafka:9092"
      - "--group.filter=.*"                    # ดึงทุก consumer group
      - "--topic.filter=.*"                    # ดึงทุก topic
      - "--web.listen-address=:9308"
      - "--log.level=info"
    ports:
      - "9308:9308"
    depends_on: [kafka]
    networks: [monitoring]

networks:
  monitoring:
    driver: bridge
```

#### Prometheus Scrape Config

```yaml
# prometheus.yml (ต่อจากเล่ม 3)
scrape_configs:
  - job_name: "kafka-exporter"
    static_configs:
      - targets: ["kafka-exporter:9308"]
        labels:
          cluster: prod-kafka-1
          env: production
    scrape_interval: 30s      # kafka_exporter ช้า — 30s พอ
```

#### Alert Rules — Kafka

```yaml
# rules/kafka-alerts.yml
groups:
  - name: kafka-observability
    interval: 30s
    rules:

      # ═══════════════════════════════════════════
      # 1) Consumer Lag — เพิ่มขึ้นต่อเนื่อง (สำคัญสุด)
      # ═══════════════════════════════════════════
      - alert: KafkaConsumerLagGrowing
        expr: |
          deriv(kafka_consumergroup_lag[10m]) > 10
          and kafka_consumergroup_lag > 1000
        for: 10m
        labels:
          severity: warning
          team: data-platform
        annotations:
          summary: "Consumer lag growing on {{ $labels.consumergroup }}/{{ $labels.topic }}"
          description: "Lag = {{ $value | humanize }} (เพิ่มขึ้นต่อเนื่อง 10m) — Consumer ตามไม่ทัน"
          runbook_url: "https://wiki.example.com/runbook/kafka-lag"

      # ═══════════════════════════════════════════
      # 2) Consumer Lag — สูงมาก (Critical)
      # ═══════════════════════════════════════════
      - alert: KafkaConsumerLagCritical
        expr: kafka_consumergroup_lag > 100000
        for: 5m
        labels:
          severity: critical
          team: data-platform
        annotations:
          summary: "CRITICAL lag on {{ $labels.consumergroup }}/{{ $labels.topic }}: {{ $value | humanize }}"
          description: "Lag > 100K — Pipeline อาจ backlog หนัก — ตรวจ Consumer"
          runbook_url: "https://wiki.example.com/runbook/kafka-lag-critical"

      # ═══════════════════════════════════════════
      # 3) Under-Replicated Partition (เสี่ยงข้อมูลหาย)
      # ═══════════════════════════════════════════
      - alert: KafkaUnderReplicatedPartitions
        expr: kafka_topic_partition_under_replicated_partition > 0
        for: 2m
        labels:
          severity: critical
          team: data-platform
        annotations:
          summary: "{{ $value }} under-replicated partitions on {{ $labels.instance }}"
          description: "ISR < RF — Broker อาจล่ม — ข้อมูลเสี่ยงหายถ้า Leader ล่ม"
          runbook_url: "https://wiki.example.com/runbook/kafka-urp"

      # ═══════════════════════════════════════════
      # 4) Offline Partition (อ่าน/เขียนไม่ได้)
      # ═══════════════════════════════════════════
      - alert: KafkaOfflinePartitions
        expr: kafka_topic_partition_offline > 0
        for: 1m
        labels:
          severity: critical
          team: data-platform
        annotations:
          summary: "{{ $value }} offline partitions"
          description: "Partition ไม่มี Leader — Producer/Consumer จะ block"
          runbook_url: "https://wiki.example.com/runbook/kafka-offline"

      # ═══════════════════════════════════════════
      # 5) Broker DOWN
      # ═══════════════════════════════════════════
      - alert: KafkaBrokerDown
        expr: up{job="kafka-exporter"} == 0
          or kafka_brokers < 3
        for: 2m
        labels:
          severity: critical
          team: data-platform
        annotations:
          summary: "Kafka broker count < expected"
          description: "ตรวจ Broker ที่ล่ม + partition rebalance"

      # ═══════════════════════════════════════════
      # 6) Consumer Group ไม่มีสมาชิก
      # ═══════════════════════════════════════════
      - alert: KafkaConsumerGroupEmpty
        expr: kafka_consumergroup_members == 0
        for: 5m
        labels:
          severity: warning
          team: data-platform
        annotations:
          summary: "Consumer group {{ $labels.consumergroup }} has no members"
          description: "Consumer ตายหรือไม่ start — Lag จะโตขึ้น"

      # ═══════════════════════════════════════════
      # 7) Producer Throughput Drop
      # ═══════════════════════════════════════════
      - alert: KafkaProducerThroughputDrop
        expr: |
          sum by (topic) (rate(kafka_topic_partition_current_offset[5m]))
            / sum by (topic) (rate(kafka_topic_partition_current_offset[5m] offset 1h))
            < 0.5
        for: 10m
        labels:
          severity: warning
          team: data-platform
        annotations:
          summary: "Producer throughput drop > 50% on {{ $labels.topic }}"
          description: "อาจมี upstream failure — ตรวจ Producer service"
```

#### PromQL — Kafka ครบชุด

```promql
# ── Consumer Lag ──────────────────────────────────────
# Lag ปัจจุบัน (ทุก group/topic)
kafka_consumergroup_lag

# Lag รวมตาม topic
sum by (topic) (kafka_consumergroup_lag)

# Lag growing rate (messages/sec)
deriv(kafka_consumergroup_lag[10m])

# Lag มากสุด top 10
topk(10, kafka_consumergroup_lag)

# ── Throughput ────────────────────────────────────────
# Producer rate (messages/sec per topic)
sum by (topic) (rate(kafka_topic_partition_current_offset[5m]))

# Consumer rate
sum by (consumergroup) (rate(kafka_consumergroup_current_offset[5m]))

# ── Cluster Health ────────────────────────────────────
# Under-replicated partitions
sum(kafka_topic_partition_under_replicated_partition)

# Offline partitions
sum(kafka_topic_partition_offline)

# Broker count
kafka_brokers

# ── Consumer Group Health ─────────────────────────────
# Members per group
kafka_consumergroup_members

# Group ที่ไม่มีสมาชิก
kafka_consumergroup_members == 0

# ── Partition Info ────────────────────────────────────
# จำนวน partition ต่อ topic
sum by (topic) (kafka_topic_partitions)

# ISR ลดลง (ควรเป็น 0)
sum by (topic) (kafka_topic_partition_under_replicated_partition)
```

#### Dashboard JSON — Kafka Overview

```json
{
  "title": "Kafka Overview",
  "uid": "kafka-overview-v1",
  "tags": ["kafka", "messaging"],
  "templating": {
    "list": [
      {
        "name": "cluster",
        "type": "query",
        "datasource": {"type": "prometheus", "uid": "prometheus"},
        "query": "label_values(kafka_brokers, cluster)",
        "refresh": 1
      },
      {
        "name": "topic",
        "type": "query",
        "datasource": {"type": "prometheus", "uid": "prometheus"},
        "query": "label_values(kafka_topic_partitions{cluster=\"$cluster\"}, topic)",
        "refresh": 1,
        "multi": true,
        "includeAll": true
      }
    ]
  },
  "panels": [
    {
      "id": 1, "type": "stat", "title": "Brokers UP",
      "gridPos": {"h": 4, "w": 4, "x": 0, "y": 0},
      "targets": [{"expr": "kafka_brokers{cluster=\"$cluster\"}"}],
      "fieldConfig": {"defaults": {
        "thresholds": {"steps": [
          {"color": "red", "value": null},
          {"color": "green", "value": 3}
        ]}
      }}
    },
    {
      "id": 2, "type": "stat", "title": "Under-Replicated Partitions",
      "gridPos": {"h": 4, "w": 5, "x": 4, "y": 0},
      "targets": [{"expr": "sum(kafka_topic_partition_under_replicated_partition{cluster=\"$cluster\"})"}],
      "fieldConfig": {"defaults": {
        "thresholds": {"steps": [
          {"color": "green", "value": null},
          {"color": "yellow", "value": 1},
          {"color": "red", "value": 5}
        ]}
      }}
    },
    {
      "id": 3, "type": "stat", "title": "Offline Partitions",
      "gridPos": {"h": 4, "w": 5, "x": 9, "y": 0},
      "targets": [{"expr": "sum(kafka_topic_partition_offline{cluster=\"$cluster\"})"}],
      "fieldConfig": {"defaults": {
        "thresholds": {"steps": [
          {"color": "green", "value": null},
          {"color": "red", "value": 1}
        ]}
      }}
    },
    {
      "id": 4, "type": "stat", "title": "Max Consumer Lag",
      "gridPos": {"h": 4, "w": 5, "x": 14, "y": 0},
      "targets": [{"expr": "max(kafka_consumergroup_lag{cluster=\"$cluster\"})"}],
      "fieldConfig": {"defaults": {"unit": "short"}}
    },
    {
      "id": 5, "type": "stat", "title": "Producer Msg/s",
      "gridPos": {"h": 4, "w": 5, "x": 19, "y": 0},
      "targets": [{"expr": "sum(rate(kafka_topic_partition_current_offset{cluster=\"$cluster\",topic=~\"$topic\"}[5m]))"}]
    },
    {
      "id": 10, "type": "timeseries", "title": "Consumer Lag by Group/Topic",
      "gridPos": {"h": 9, "w": 16, "x": 0, "y": 4},
      "targets": [{
        "expr": "kafka_consumergroup_lag{cluster=\"$cluster\",topic=~\"$topic\"}",
        "legendFormat": "{{consumergroup}} / {{topic}}"
      }]
    },
    {
      "id": 11, "type": "timeseries", "title": "Lag Growth Rate (msg/s)",
      "gridPos": {"h": 9, "w": 8, "x": 16, "y": 4},
      "targets": [{
        "expr": "deriv(kafka_consumergroup_lag{cluster=\"$cluster\"}[10m])",
        "legendFormat": "{{consumergroup}}"
      }]
    },
    {
      "id": 12, "type": "timeseries", "title": "Producer vs Consumer Rate",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 13},
      "targets": [
        {"expr": "sum by (topic) (rate(kafka_topic_partition_current_offset{cluster=\"$cluster\",topic=~\"$topic\"}[5m]))", "legendFormat": "Produce {{topic}}"},
        {"expr": "sum by (consumergroup) (rate(kafka_consumergroup_current_offset{cluster=\"$cluster\"}[5m]))", "legendFormat": "Consume {{consumergroup}}"}
      ]
    },
    {
      "id": 13, "type": "timeseries", "title": "Under-Replicated by Topic",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 13},
      "targets": [{
        "expr": "sum by (topic) (kafka_topic_partition_under_replicated_partition{cluster=\"$cluster\"})",
        "legendFormat": "{{topic}}"
      }]
    }
  ],
  "time": {"from": "now-1h", "to": "now"},
  "refresh": "30s"
}
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุที่เป็นไปได้ | แนวทางแก้ไข |
|---|---|---|
| Lag เพิ่มขึ้นเรื่อยๆ | Consumer ช้า / ตาย / Partition ไม่พอ | Scale consumer, เพิ่ม partition, ตรวจ slow processing |
| Lag กระโดดเฉียบพลัน | Producer burst / Consumer ตาย | ตรวจ Consumer log, `kafka-consumer-groups.sh --describe` |
| Under-replicated > 0 | Broker ล่ม / Network | ตรวจ Broker health, `kafka-topics.sh --describe` |
| Offline partition | ไม่มี Leader / Controller ล่ม | Restart Broker, ตรวจ KRaft quorum |
| Consumer group ไม่มี member | Consumer ตาย / Rebalance ค้าง | ตรวจ Consumer log, `kafka-consumer-groups.sh --list` |
| Producer throughput ตก | Upstream fail / Network | ตรวจ upstream service (Application metrics) |
| `kafka_exporter` timeout | Broker ช้า / Consumer group เยอะ | เพิ่ม timeout, กรอง group/topic |

### ลำดับการจัดการปัญหา (Consumer Lag Growing)

1. **ยืนยัน Lag** — `kafka-consumer-groups.sh --describe --group <group>` — ดู CONSUMER-ID, HOST, LAG
2. **ตรวจ Consumer** — Pod/Process ยังรันไหม? `kubectl get pods` / `ps aux`
3. **ตรวจ Consumer log** — มี error processing? (ดูใน Kibana เล่ม 4)
4. **ตรวจ Consumer rate** — `rate(kafka_consumergroup_current_offset[5m])` เทียบกับ producer rate
5. **ตรวจ Partition count** — Partition พอไหม? (Consumer > Partition = บางตัวว่างงาน)
6. **ตรวจ Broker** — Under-replicated? Offline? (ถ้าใช่ → Incident Kafka Cluster)
7. **Scale Consumer** — เพิ่ม instance (ไม่เกิน Partition count)
8. **ถ้า Consumer ช้า** — ตรวจ DB/External API ที่ Consumer เรียก
9. **ระหว่างแก้** — `kafka-consumer-groups.sh --reset-offsets` เฉพาะกรณีจำเป็น (ระวัง data loss)

### Template Code
→ ดู Docker Compose, Alert Rules, PromQL ด้านบน

### Template Dashboard
→ ดู Kafka Overview JSON ด้านบน

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** เห็น Pipeline ติดขัดก่อน user ร้องเรียน, ตรวจ Cluster Health ในที่เดียว
- **ข้อควรระวัง:** **Lag ≠ ปัญหา** — ต้องดู `deriv()` ประกอบ; Lag คงที่ไม่ใช่เรื่องร้าย
- **ข้อดี:** `kafka_exporter` ตั้งง่าย, Metrics ครอบคลุม
- **ข้อเสีย:** `kafka_exporter` ช้าเมื่อ topic/group เยอะ (กรองด้วย filter); ไม่มี JMX metric ลึก (ต้องใช้ `jmx_exporter` แยก)
- **ข้อห้าม:**
  - ❌ ใช้ Lag อย่างเดียวตัดสิน — ต้องดู `deriv()` + throughput
  - ❌ Alert `KafkaConsumerLag > 1000` โดยไม่มี `for:` — จะ noise
  - ❌ `--group.filter=.*` บน cluster ใหญ่ (>500 group) — exporter จะ timeout
  - ❌ ใช้ `kafka_exporter` แทน JMX metric (ต้องการ `jmx_exporter` สำหรับ broker internals)

### ตัวอย่าง (เพิ่ม `jmx_exporter` — Broker Internals)

```yaml
# ถ้าต้องการ JMX metric (GC, request latency, network)
# ใช้ jmx_exporter เป็น Java agent บน broker
# แล้ว scrape จาก Prometheus (port 9404)
scrape_configs:
  - job_name: "kafka-jmx"
    static_configs:
      - targets: ["kafka-1:9404", "kafka-2:9404", "kafka-3:9404"]
```

### สรุปย่อเพื่อจดจำ
> **Kafka Observability** — Lag (ดู `deriv()` ด้วย) — URP = 0, Offline = 0 — Alert `LagGrowing` (10m > 10 msg/s) — `kafka_exporter` ทุก 30s — Scale consumer ≤ partition count

### แหล่งที่มา
- https://github.com/danielqsj/kafka-exporter
- https://kafka.apache.org/documentation/#monitoring
- Confluent, "Kafka Monitoring Best Practices"
- Jay Kreps, "Benchmarking Apache Kafka" (2014)

---

## 3.7 Redis Cache (Memory, Hit Rate, Eviction, Replication)

### เรื่อง
Observability ของ Redis — มุมมองที่ Support ต้องรู้เพื่อตอบว่า "Cache กำลังทำงานถูกต้องหรือไม่" และ "Memory ใกล้เต็มหรือยัง"

### วัตถุประสงค์ / เป้าหมาย
- เห็น **Hit Rate** ก่อน user บ่นว่า "ช้า"
- ตรวจ **Memory** ก่อน OOM / Eviction Storm
- รู้ **Replication Lag** (ถ้าใช้ Master-Replica)
- Alert `RedisLowHitRate` (บอกว่า Cache ไม่ทำงาน)
- Alert `RedisHighMemoryUsage` (บอกว่าใกล้เต็ม)
- Alert `RedisEvictionRate` (บอกว่า evict หนัก — performance ตก)

### เนื้อหา / รายละเอียด

#### สถาปัตยกรรม (มุมมอง Observability)

```
┌──────────┐   GET/SET   ┌──────────────────────┐
│ App      │────────────▶│  Redis Master        │
│ (Client) │             │  - keys, memory      │
└──────────┘             │  - hits, misses      │
                         │  - evictions         │
                         └──────────┬───────────┘
                                    │ replication
                                    ▼
                         ┌──────────────────────┐
                         │  Redis Replica       │
                         │  (read-only)         │
                         └──────────────────────┘
                                    ▲
                                    │ INFO
                         ┌──────────┴───────────┐
                         │  redis_exporter      │
                         │  (scrape ทุก 15s)    │
                         └──────────┬───────────┘
                                    │
                             ┌──────▼──────┐
                             │ Prometheus  │
                             └─────────────┘
```

#### Metrics ที่ Support ต้องดู (จัดลำดับความสำคัญ)

| ลำดับ | Metric | ความหมาย | ค่าปกติ |
|:---:|---|---|---|
| **1** | `redis_memory_used_bytes` / `redis_memory_max_bytes` | Memory utilization | < 80% |
| **2** | `redis_keyspace_hits_total` / `redis_keyspace_misses_total` | Hit rate | > 80% |
| **3** | `rate(redis_evicted_keys_total[5m])` | Eviction rate | 0 (ปกติ) |
| **4** | `redis_connected_clients` | Clients | ตาม design |
| **5** | `redis_blocked_clients` | Clients blocked (BLPOP) | 0 |
| **6** | `redis_master_repl_offset` − `redis_slave_repl_offset` | Replication lag | < 1MB |
| **7** | `redis_commands_processed_total` | Total commands | เพิ่มขึ้น |
| **8** | `redis_rejected_connections_total` | Connections rejected | 0 |
| **9** | `redis_expired_keys_total` | Keys หมดอายุ | ตาม TTL |
| **10** | `redis_rdb_last_bgsave_status` | Backup status | `ok` |

#### Hit Rate — สูตรและการตีความ

```
hit_rate = keyspace_hits / (keyspace_hits + keyspace_misses)
```

**การตีความ:**

| Hit Rate | ความหมาย | Action |
|---|---|---|
| **> 90%** | Cache ทำงานดีมาก | ✅ ปกติ |
| **80–90%** | ยอมรับได้ | ⚠️ ตรวจ TTL / keyspace size |
| **50–80%** | Cache เริ่มไม่ทำงาน | 🚨 ตรวจ key design, TTL สั้นไป |
| **< 50%** | Cache แทบไม่ทำงาน | 🚨 Incident — ตรวจ app logic, eviction |

**สาเหตุ Hit Rate ต่ำ:**

1. **TTL สั้นเกินไป** — key หมดอายุก่อนถูกเรียกซ้ำ
2. **Working Set > Memory** — evict บ่อย, key หายก่อนใช้
3. **Pattern ผิด** — cache key ที่ไม่ค่อยถูกเรียก (write-heavy)
4. **Cache stampede** — หลาย request miss พร้อมกัน
5. **Cold start** — เพิ่ง restart

#### Eviction — นโยบายและผลกระทบ

| Policy | พฤติกรรม | ใช้เมื่อ |
|---|---|---|
| `noeviction` | Error เมื่อเต็ม | **ห้าม** สำหรับ Cache (แต่ใช้กับ Session ได้) |
| `allkeys-lru` | Evict key ที่ใช้ล่าสุดนานสุด | ✅ Cache ทั่วไป (แนะนำ) |
| `volatile-lru` | Evict key ที่มี TTL | Cache + persistent mix |
| `allkeys-lfu` | Evict key ที่ใช้น้อยสุด | Cache ที่มี hot/cold ชัด |
| `volatile-ttl` | Evict key ที่ TTL ใกล้หมด | ไม่ค่อยแนะนำ |

> **คำแนะนำ:** ใช้ **`allkeys-lru`** สำหรับ Cache ทั่วไป — และ **`noeviction`** สำหรับ Session Store (ยอม error ดีกว่า session หาย)

### การติดตั้ง / การตั้งค่า

#### Docker Compose (Redis + `redis_exporter`)

```yaml
version: "3.8"
services:

  # ── Redis
  redis:
    image: redis:7.2-alpine
    container_name: redis
    restart: unless-stopped
    command:
      - "redis-server"
      - "--maxmemory=2gb"
      - "--maxmemory-policy=allkeys-lru"
      - "--appendonly=yes"
      - "--save=900 1"
      - "--requirepass=${REDIS_PASSWORD}"
    volumes:
      - redis-data:/data
    ports:
      - "6379:6379"
    networks: [monitoring]

  # ── redis_exporter
  redis-exporter:
    image: oliver006/redis_exporter:v1.62.0
    container_name: redis-exporter
    restart: unless-stopped
    environment:
      - REDIS_ADDR=redis://redis:6379
      - REDIS_PASSWORD=${REDIS_PASSWORD}
      - REDIS_EXPORTER_WEB_LISTEN_ADDRESS=:9121
      - REDIS_EXPORTER_CHECK_KEYS=session:*,cache:*
      - REDIS_EXPORTER_LOG_FORMAT=json
    ports:
      - "9121:9121"
    depends_on: [redis]
    networks: [monitoring]

volumes:
  redis-data:

networks:
  monitoring:
    driver: bridge
```

#### Prometheus Scrape Config

```yaml
scrape_configs:
  - job_name: "redis-exporter"
    static_configs:
      - targets: ["redis-exporter:9121"]
        labels:
          cluster: prod-redis-1
          env: production
    scrape_interval: 15s
```

#### Alert Rules — Redis

```yaml
# rules/redis-alerts.yml
groups:
  - name: redis-observability
    interval: 15s
    rules:

      # ═══════════════════════════════════════════
      # 1) Memory ใกล้เต็ม (85%)
      # ═══════════════════════════════════════════
      - alert: RedisHighMemoryUsage
        expr: |
          (redis_memory_used_bytes / redis_memory_max_bytes) > 0.85
        for: 5m
        labels:
          severity: warning
          team: platform
        annotations:
          summary: "Redis memory > 85% on {{ $labels.instance }}"
          description: "Used = {{ $value | humanizePercentage }} — ใกล้ eviction storm"
          runbook_url: "https://wiki.example.com/runbook/redis-memory"

      # ═══════════════════════════════════════════
      # 2) Memory เต็มมาก (95% — Critical)
      # ═══════════════════════════════════════════
      - alert: RedisMemoryCritical
        expr: |
          (redis_memory_used_bytes / redis_memory_max_bytes) > 0.95
        for: 2m
        labels:
          severity: critical
          team: platform
        annotations:
          summary: "CRITICAL Redis memory > 95%"
          description: "Eviction หนักมาก — performance ตก"
          runbook_url: "https://wiki.example.com/runbook/redis-memory"

      # ═══════════════════════════════════════════
      # 3) Hit Rate ต่ำ (Cache ไม่ทำงาน)
      # ═══════════════════════════════════════════
      - alert: RedisLowHitRate
        expr: |
          rate(redis_keyspace_hits_total[10m])
            / (rate(redis_keyspace_hits_total[10m]) + rate(redis_keyspace_misses_total[10m]))
            < 0.8
        for: 15m
        labels:
          severity: warning
          team: platform
        annotations:
          summary: "Redis hit rate < 80% on {{ $labels.instance }}"
          description: "Cache ไม่ทำงานตามเป้า — ตรวจ TTL / working set / app logic"
          runbook_url: "https://wiki.example.com/runbook/redis-hitrate"

      # ═══════════════════════════════════════════
      # 4) Eviction Rate สูง (กำลัง evict หนัก)
      # ═══════════════════════════════════════════
      - alert: RedisEvictionRate
        expr: rate(redis_evicted_keys_total[5m]) > 100
        for: 10m
        labels:
          severity: warning
          team: platform
        annotations:
          summary: "Redis evicting {{ $value | humanize }} keys/s"
          description: "Working set > Memory — ต้องเพิ่ม memory หรือลด key size"
          runbook_url: "https://wiki.example.com/runbook/redis-eviction"

      # ═══════════════════════════════════════════
      # 5) Replication Lag สูง
      # ═══════════════════════════════════════════
      - alert: RedisReplicationLag
        expr: |
          (redis_master_repl_offset - redis_slave_repl_offset) > 10485760
        for: 5m
        labels:
          severity: warning
          team: platform
        annotations:
          summary: "Redis replication lag > 10MB on {{ $labels.instance }}"
          description: "Replica ตาม Master ไม่ทัน — ตรวจ network / replica load"
          runbook_url: "https://wiki.example.com/runbook/redis-replication"

      # ═══════════════════════════════════════════
      # 6) Redis DOWN
      # ═══════════════════════════════════════════
      - alert: RedisDown
        expr: up{job="redis-exporter"} == 0
        for: 2m
        labels:
          severity: critical
          team: platform
        annotations:
          summary: "Redis exporter cannot reach Redis on {{ $labels.instance }}"
          description: "ตรวจ Redis process / network"
          runbook_url: "https://wiki.example.com/runbook/redis-down"

      # ═══════════════════════════════════════════
      # 7) Rejected Connections
      # ═══════════════════════════════════════════
      - alert: RedisRejectedConnections
        expr: rate(redis_rejected_connections_total[5m]) > 0
        for: 5m
        labels:
          severity: warning
          team: platform
        annotations:
          summary: "Redis rejecting connections on {{ $labels.instance }}"
          description: "maxclients เต็ม — ตรวจ connection leak / pool size"

      # ═══════════════════════════════════════════
      # 8) Backup (RDB) ล้มเหลว
      # ═══════════════════════════════════════════
      - alert: RedisBackupFailed
        expr: redis_rdb_last_bgsave_status == 0
        for: 5m
        labels:
          severity: warning
          team: platform
        annotations:
          summary: "Redis RDB backup failed"
          description: "ตรวจ disk space / fork / memory"
```

#### PromQL — Redis ครบชุด

```promql
# ── Memory ────────────────────────────────────────────
# Memory utilization (%)
redis_memory_used_bytes / redis_memory_max_bytes * 100

# Memory used (bytes)
redis_memory_used_bytes

# Memory fragmentation ratio (>1.5 = fragment เยอะ)
redis_mem_fragmentation_ratio

# ── Hit Rate ──────────────────────────────────────────
# Hit rate (5m window)
sum(rate(redis_keyspace_hits_total[5m]))
  / (sum(rate(redis_keyspace_hits_total[5m]))
     + sum(rate(redis_keyspace_misses_total[5m])))

# Hits vs Misses (rate)
rate(redis_keyspace_hits_total[5m])
rate(redis_keyspace_misses_total[5m])

# ── Eviction ──────────────────────────────────────────
# Eviction rate (keys/sec)
rate(redis_evicted_keys_total[5m])

# Total evicted (cumulative)
redis_evicted_keys_total

# ── Connections ───────────────────────────────────────
# Connected clients
redis_connected_clients

# Blocked clients (BLPOP/BRPOP)
redis_blocked_clients

# Rejected connections (rate)
rate(redis_rejected_connections_total[5m])

# ── Commands ──────────────────────────────────────────
# Command throughput (ops/sec)
rate(redis_commands_processed_total[5m])

# ── Replication ───────────────────────────────────────
# Replication lag (bytes)
redis_master_repl_offset - redis_slave_repl_offset

# ── Keys ──────────────────────────────────────────────
# Total keys (ทุก db)
sum(redis_db_keys)

# Keys with TTL vs no TTL
sum(redis_db_keys_expiring) by (db)
sum(redis_db_keys) - sum(redis_db_keys_expiring)

# Expired keys rate
rate(redis_expired_keys_total[5m])
```

#### Dashboard JSON — Redis Overview

```json
{
  "title": "Redis Overview",
  "uid": "redis-overview-v1",
  "tags": ["redis", "cache"],
  "templating": {
    "list": [
      {
        "name": "instance",
        "type": "query",
        "datasource": {"type": "prometheus", "uid": "prometheus"},
        "query": "label_values(redis_up, instance)",
        "refresh": 1,
        "multi": true,
        "includeAll": true
      }
    ]
  },
  "panels": [
    {
      "id": 1, "type": "stat", "title": "Memory Usage",
      "gridPos": {"h": 5, "w": 5, "x": 0, "y": 0},
      "targets": [{
        "expr": "redis_memory_used_bytes{instance=~\"$instance\"} / redis_memory_max_bytes{instance=~\"$instance\"} * 100"
      }],
      "fieldConfig": {"defaults": {
        "unit": "percent",
        "thresholds": {"steps": [
          {"color": "green", "value": null},
          {"color": "yellow", "value": 80},
          {"color": "red", "value": 90}
        ]}
      }}
    },
    {
      "id": 2, "type": "stat", "title": "Hit Rate",
      "gridPos": {"h": 5, "w": 5, "x": 5, "y": 0},
      "targets": [{
        "expr": "sum(rate(redis_keyspace_hits_total{instance=~\"$instance\"}[5m])) / (sum(rate(redis_keyspace_hits_total{instance=~\"$instance\"}[5m])) + sum(rate(redis_keyspace_misses_total{instance=~\"$instance\"}[5m])))"
      }],
      "fieldConfig": {"defaults": {
        "unit": "percentunit",
        "min": 0, "max": 1,
        "thresholds": {"steps": [
          {"color": "red", "value": null},
          {"color": "yellow", "value": 0.8},
          {"color": "green", "value": 0.9}
        ]}
      }}
    },
    {
      "id": 3, "type": "stat", "title": "Evicted Keys/s",
      "gridPos": {"h": 5, "w": 4, "x": 10, "y": 0},
      "targets": [{"expr": "rate(redis_evicted_keys_total{instance=~\"$instance\"}[5m])"}],
      "fieldConfig": {"defaults": {
        "thresholds": {"steps": [
          {"color": "green", "value": null},
          {"color": "yellow", "value": 1},
          {"color": "red", "value": 100}
        ]}
      }}
    },
    {
      "id": 4, "type": "stat", "title": "Connected Clients",
      "gridPos": {"h": 5, "w": 5, "x": 14, "y": 0},
      "targets": [{"expr": "redis_connected_clients{instance=~\"$instance\"}"}]
    },
    {
      "id": 5, "type": "stat", "title": "Ops/sec",
      "gridPos": {"h": 5, "w": 5, "x": 19, "y": 0},
      "targets": [{"expr": "rate(redis_commands_processed_total{instance=~\"$instance\"}[5m])"}]
    },
    {
      "id": 10, "type": "timeseries", "title": "Memory Used vs Max",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 5},
      "targets": [
        {"expr": "redis_memory_used_bytes{instance=~\"$instance\"}", "legendFormat": "Used {{instance}}"},
        {"expr": "redis_memory_max_bytes{instance=~\"$instance\"}", "legendFormat": "Max {{instance}}"}
      ],
      "fieldConfig": {"defaults": {"unit": "bytes"}}
    },
    {
      "id": 11, "type": "timeseries", "title": "Hit vs Miss Rate",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 5},
      "targets": [
        {"expr": "rate(redis_keyspace_hits_total{instance=~\"$instance\"}[5m])", "legendFormat": "Hits"},
        {"expr": "rate(redis_keyspace_misses_total{instance=~\"$instance\"}[5m])", "legendFormat": "Misses"}
      ]
    },
    {
      "id": 12, "type": "timeseries", "title": "Eviction Rate",
      "gridPos": {"h": 7, "w": 8, "x": 0, "y": 13},
      "targets": [{
        "expr": "rate(redis_evicted_keys_total{instance=~\"$instance\"}[5m])",
        "legendFormat": "{{instance}}"
      }]
    },
    {
      "id": 13, "type": "timeseries", "title": "Replication Lag (bytes)",
      "gridPos": {"h": 7, "w": 8, "x": 8, "y": 13},
      "targets": [{
        "expr": "(redis_master_repl_offset{instance=~\"$instance\"} - redis_slave_repl_offset{instance=~\"$instance\"})",
        "legendFormat": "{{instance}}"
      }],
      "fieldConfig": {"defaults": {"unit": "bytes"}}
    },
    {
      "id": 14, "type": "timeseries", "title": "Commands/sec",
      "gridPos": {"h": 7, "w": 8, "x": 16, "y": 13},
      "targets": [{
        "expr": "rate(redis_commands_processed_total{instance=~\"$instance\"}[5m])",
        "legendFormat": "{{instance}}"
      }]
    }
  ],
  "time": {"from": "now-1h", "to": "now"},
  "refresh": "15s"
}
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุที่เป็นไปได้ | แนวทางแก้ไข |
|---|---|---|
| Hit rate ต่ำ (<80%) | TTL สั้น / working set > memory / pattern ผิด | ตรวจ TTL, เพิ่ม memory, ทบทวน cache key design |
| Eviction สูง | Memory เต็ม / working set ใหญ่ | เพิ่ม `maxmemory`, ลด key size, ใช้ `allkeys-lfu` |
| Memory fragment สูง (>1.5) | Allocator fragment (jemalloc) | `MEMORY PURGE` หรือ restart (ชั่วคราว); ปรับ `activedefrag yes` |
| Replication lag สูง | Network / Replica ช้า / Master write เยอะ | ตรวจ network, เพิ่ม replica resource |
| Rejected connections | `maxclients` เต็ม / connection leak | เพิ่ม `maxclients`, ตรวจ pool size ในแอป |
| Blocked clients > 0 | BLPOP/BRPOP ค้าง (list ว่าง) | ตรวจ producer ที่ควร push list |
| RDB backup fail | Disk เต็ม / OOM | `df -h`, `redis-cli INFO persistence` |
| Redis DOWN | Process ตาย / OOM killer | ตรวจ `dmesg`, `redis-server --version`, restart |

### ลำดับการจัดการปัญหา (Hit Rate ต่ำ)

1. **ยืนยัน Hit Rate** — Grafana panel / `rate(redis_keyspace_hits_total[10m]) / ...`
2. **ตรวจ Eviction** — `rate(redis_evicted_keys_total[5m])` — ถ้าสูง = memory ไม่พอ
3. **ตรวจ Memory** — `redis_memory_used_bytes / redis_memory_max_bytes` — % เท่าไร
4. **ตรวจ Keyspace** — `redis-cli INFO keyspace` — db ไหนมี key เท่าไร
5. **ดู Key distribution** — `redis-cli --bigkeys`, `redis-cli --scan --pattern 'cache:*' | head`
6. **ตรวจ TTL** — `redis-cli TTL <key>` — TTL สั้นเกินไป?
7. **ตรวจ Pattern ในแอป** — มี cache key ที่ถูก GET ครั้งเดียวแล้วไม่ถูกเรียกซ้ำ?
8. **แก้:**
   - ถ้า memory ไม่พอ → เพิ่ม `maxmemory` หรือ scale Redis
   - ถ้า TTL สั้นไป → ปรับ TTL ในแอป
   - ถ้า pattern ผิด → ทบทวน cache key (เพิ่ม key ที่ hot, ลบ key ที่ cold)

### ลำดับการจัดการปัญหา (Memory เต็ม)

1. **ตรวจ Memory** — `redis-cli INFO memory` — `used_memory_human`, `maxmemory_human`
2. **ตรวจ Eviction** — `redis-cli INFO stats | grep evicted`
3. **ดู Big Keys** — `redis-cli --bigkeys` — key ไหนใหญ่ผิดปกติ
4. **ตรวจ Keyspace** — `redis-cli INFO keyspace` — db ไหนเยอะ
5. **ตรวจ Replication** — ถ้ามี replica, memory ต้องพอทั้ง master + replica
6. **แก้:**
   - เพิ่ม `maxmemory` (ถ้า RAM พอ)
   - ลบ key ที่ไม่ใช้ (`redis-cli --scan --pattern 'temp:*' | xargs redis-cli DEL`)
   - ปรับ `maxmemory-policy` (เช่น `allkeys-lfu` ถ้า hot/cold ชัด)
   - Scale: Redis Cluster (sharding) หรือเพิ่ม memory

### Template Code
→ ดู Docker Compose, Alert Rules, PromQL ด้านบน

### Template Dashboard
→ ดู Redis Overview JSON ด้านบน

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** เห็น Cache health ก่อน user ร้องเรียน, ตรวจ Memory ก่อน OOM
- **ข้อควรระวัง:** **Hit rate ≠ คุณภาพ Cache** — hit rate 100% อาจหมายถึง cache ค้าง (ไม่ refresh)
- **ข้อดี:** `redis_exporter` ตั้งง่าย, Metrics ครบ (INFO command ครอบคลุม)
- **ข้อเสีย:** `redis_exporter` ใช้ `INFO` ซึ่งเป็น blocking (ช้าเมื่อ keyspace ใหญ่); ไม่มี per-key metric
- **ข้อห้าม:**
  - ❌ ใช้ `noeviction` กับ Cache (จะ error เมื่อเต็ม)
  - ❌ ใช้ `allkeys-lru` กับ Session Store (session หายได้)
  - ❌ ตั้ง `maxmemory = 0` (infinite) บน production
  - ❌ ใช้ `redis_exporter` กับ Redis ขนาด >100GB (INFO ช้า)
  - ❌ Alert `RedisLowHitRate` ในช่วง cold start (หลัง restart) — ต้องมี `for: 15m` ขึ้นไป

### ตัวอย่าง (Redis Config ที่ดี)

```conf
# redis.conf — production
maxmemory 4gb
maxmemory-policy allkeys-lru       # สำหรับ Cache
# maxmemory-policy noeviction      # สำหรับ Session Store (เลือกอย่างใดอย่างหนึ่ง)

# Persistence (ถ้าต้องการ)
appendonly yes
appendfsync everysec
save 900 1
save 300 10
save 60 10000

# Memory management
activedefrag yes
lazyfree-lazy-eviction yes
lazyfree-lazy-expire yes

# Security
requirepass <strong-password>
rename-command FLUSHALL ""
rename-command CONFIG ""
```

### สรุปย่อเพื่อจดจำ
> **Redis Observability** — Memory < 80% — Hit Rate > 80% — Eviction = 0 — `allkeys-lru` สำหรับ Cache — `noeviction` สำหรับ Session — `redis_exporter` ทุก 15s — ระวัง cold start ทำให้ hit rate ต่ำชั่วคราว

### แหล่งที่มา
- https://github.com/oliver006/redis_exporter
- https://redis.io/docs/management/optimization/memory-optimization/
- https://redis.io/docs/reference/optimization/latency/
- Redis, "Redis Best Practices" (official docs)

---

## Workflow (อ้างอิงเล่ม 1 + Incident Playbook เฉพาะเล่ม)

### อ้างอิง Workflow หลักจากเล่ม 1

| Workflow | ใช้ในเล่มนี้เมื่อ |
|---|---|
| **PSR** | เขียนรายงานหลัง Incident ที่เกี่ยวกับ Kafka/Redis |
| **RCA 5 Whys** | หา Root Cause ของ Lag โต / Hit Rate ตก |
| **KPI SMART** | ตั้ง KPI ของ Messaging/Cache (เช่น Lag < 1000, Hit Rate > 80%) |

→ Template เต็มอยู่ใน **เล่ม 1 หัวข้อ 4**

### Incident Playbook เฉพาะเล่ม 5

#### Playbook A: Kafka Consumer Lag Growing (Pipeline ติดขัด)

1. **ยืนยัน Lag** — `kafka-consumer-groups.sh --describe --group <group> --bootstrap-server kafka:9092`
2. **ตรวจ Consumer Process** — Pod/Process ยังรันไหม? `kubectl get pods -l app=<consumer>`
3. **ตรวจ Consumer log** — มี error processing? (Kibana เล่ม 4)
4. **ตรวจ Consumer rate** — `rate(kafka_consumergroup_current_offset[5m])` เทียบ producer rate
5. **ตรวจ Partition count** — Consumer > Partition? (บางตัวว่างงาน)
6. **ตรวจ Broker** — URP, Offline? (ถ้าใช่ → Incident Kafka Cluster)
7. **Scale Consumer** — เพิ่ม instance (ไม่เกิน partition count)
8. **ถ้า Consumer ช้า** — ตรวจ downstream (DB/External API)
9. **ระหว่างแก้** — `kafka-consumer-groups.sh --reset-offsets` เฉพาะจำเป็น (data loss risk)

#### Playbook B: Kafka Under-Replicated Partition (เสี่ยงข้อมูลหาย)

1. **ตรวจ URP** — `kafka-topics.sh --describe --under-replicated-partitions --bootstrap-server kafka:9092`
2. **ตรวจ Broker health** — `kafka-broker-api-versions.sh --bootstrap-server kafka:9092`
3. **ตรวจ Controller** — `kafka-metadata-quorum.sh --describe`
4. **ตรวจ Network** — Broker ถึงกันได้? (firewall, DNS)
5. **ตรวจ Disk** — Broker disk เต็ม? (`df -h` บน broker)
6. **ตรวจ GC** — JMX metric (ถ้ามี) — GC pause นาน?
7. **แก้:**
   - Restart Broker ที่ล่ม (ถ้า recover ได้)
   - ถ้า broker ตายถาวร → `kafka-reassign-partitions.sh` ย้าย partition
   - ตรวจ `min.insync.replicas` — ถ้า URP เยอะ อาจเขียนไม่ได้ (acks=all)

#### Playbook C: Redis Memory เต็ม / Eviction Storm

1. **ตรวจ Memory** — `redis-cli INFO memory` — `used_memory_human`, `maxmemory_human`
2. **ตรวจ Eviction** — `redis-cli INFO stats | grep evicted`
3. **ดู Big Keys** — `redis-cli --bigkeys` — key ไหนใหญ่ผิดปกติ
4. **ตรวจ Keyspace** — `redis-cli INFO keyspace` — db ไหนเยอะ
5. **ตรวจ TTL** — `redis-cli --scan --pattern 'cache:*' | head -10 | xargs -I{} redis-cli TTL {}`
6. **แก้:**
   - เพิ่ม `maxmemory` (ถ้า RAM พอ)
   - ลบ key ที่ไม่ใช้: `redis-cli --scan --pattern 'temp:*' | xargs -r redis-cli DEL`
   - ปรับ `maxmemory-policy` → `allkeys-lfu` (ถ้า hot/cold ชัด)
   - Scale: Redis Cluster (sharding)

#### Playbook D: Redis Hit Rate ต่ำ

1. **ยืนยัน Hit Rate** — `rate(redis_keyspace_hits_total[10m]) / (...)` — < 80%
2. **ตรวจ Eviction** — evict เยอะ? → memory ไม่พอ
3. **ตรวจ Cold Start** — เพิ่ง restart? (hit rate จะค่อยๆ ขึ้นใน 5–15 นาที)
4. **ตรวจ TTL** — TTL สั้นเกินไป? (key หมดอายุก่อนถูกเรียกซ้ำ)
5. **ตรวจ Key pattern** — มี cache key ที่ถูก GET ครั้งเดียว?
6. **ตรวจ Application** — แอป cache ผิด key? (เช่น cache ตาม request_id)
7. **แก้:**
   - TTL สั้นไป → ปรับ TTL ในแอป
   - Working set ใหญ่ → เพิ่ม memory / scale
   - Pattern ผิด → ทบทวน cache key design (cache key ที่ hot, ลบ cold)

#### Playbook E: Redis Replication Lag

1. **ตรวจ Lag** — `redis_master_repl_offset - redis_slave_repl_offset` — bytes
2. **ตรวจ Network** — `redis-cli -h replica INFO replication` — `master_link_status:up`?
3. **ตรวจ Replica Load** — Replica ทำ read เยอะเกิน?
4. **ตรวจ Master Write Rate** — `rate(redis_commands_processed_total[5m])` — write burst?
5. **ตรวจ Disk I/O** — Replica disk ช้า? (ถ้ามี persistence)
6. **แก้:**
   - Network → ตรวจ firewall / bandwidth
   - Replica load → ลด read traffic / เพิ่ม replica
   - Master write burst → ตรวจ application (batch write)

---

## สรุป (ประโยชน์, ข้อดี, ข้อเสีย, ข้อห้าม)

### ประโยชน์ของเล่ม 5

- **Pipeline Visibility:** เห็น Consumer Lag ก่อน user ร้องเรียน
- **Cache Health:** Hit Rate / Eviction / Memory ครบในที่เดียว
- **Alert ที่ Actionable:** แต่ละ alert บอกว่า "ต้องทำอะไร" (เช่น `RedisLowHitRate` → ตรวจ TTL)
- **Runbook พร้อม:** Incident Playbook 5 สถานการณ์ที่พบบ่อย
- **Integration:** Metrics ทั้งหมดใช้ Prometheus/Grafana จากเล่ม 3

### ข้อดี

| ด้าน | ผลลัพธ์ |
|---|---|
| **MTTD** | เห็น Lag/Hit Rate ทันที (ก่อน user บ่น) |
| **MTTR** | Runbook เฉพาะ → แก้เร็วขึ้น |
| **Capacity** | เห็น Memory/Lag trend → วางแผนล่วงหน้า |
| **Standardization** | ใช้ Metrics Platform เดียวกับเล่ม 3 |
| **Cross-team** | Data Platform + App Support ดู Dashboard เดียวกัน |

### ข้อเสีย / ข้อจำกัด

- **`kafka_exporter` ช้า** เมื่อ topic/group เยอะ (>500) — ต้องกรอง
- **`redis_exporter` ใช้ INFO** ซึ่ง blocking — Redis ใหญ่มากจะช้า
- **ไม่มี per-key metric** — ต้องใช้ `MEMORY USAGE <key>` manual
- **JMX metric ไม่ครบ** — ต้องใช้ `jmx_exporter` เสริม (broker internals)
- **Cluster mode** — exporter ต้อง scrape ทุก node (config เยอะขึ้น)

### ข้อห้าม (สรุป)

1. ❌ **ห้ามดู Lag อย่างเดียว** — ต้องดู `deriv()` + throughput ประกอบ
2. ❌ **ห้าม Alert `KafkaConsumerLag > 1000`** โดยไม่มี `for:` — จะ noise
3. ❌ **ห้ามใช้ `noeviction` กับ Cache** — Redis จะ error เมื่อเต็ม
4. ❌ **ห้ามใช้ `allkeys-lru` กับ Session Store** — session หายได้
5. ❌ **ห้ามตั้ง `maxmemory = 0`** บน production — memory จะโตจน OOM
6. ❌ **ห้ามใช้ `redis_exporter` กับ Redis >100GB** — INFO ช้า
7. ❌ **ห้าม Alert `RedisLowHitRate` ในช่วง cold start** — ต้องมี `for: 15m` ขึ้นไป
8. ❌ **ห้าม Scale Consumer เกิน Partition count** — บางตัวว่างงาน
9. ❌ **ห้ามใช้ `--group.filter=.*`** บน cluster ใหญ่ (>500 group) — exporter timeout
10. ❌ **ห้าม Deploy Kafka/Redis Observability โดยไม่ตั้ง Alert** — Metrics ไม่มีประโยชน์ถ้าไม่มีคนดู

---

## เส้นทางอ่านต่อ

| ถ้าคุณเป็น | อ่านต่อ |
|---|---|
| Monitoring Engineer | → อ่านจบเส้นทาง A (เล่ม 1–5) แล้ว |
| Business App Support | → **เล่ม 7** (CRM Support) |
| ERP Support (Full-stack) | → **เล่ม 8** (DDD) → **เล่ม 9** (DB) → **เล่ม 10** (Integration) |
| AI Engineer | → **เล่ม 6** (AI & Semantic Search) |
| Data Platform Engineer | → อ่าน **เล่ม 10** (Kafka/Redis Patterns) เพิ่ม |

---

> **เวอร์ชันเอกสาร:** 1.0
> **ผู้รับผิดชอบ:** SRE Team + Data Platform Team
> **ปรับปรุงล่าสุด:** ตามรอบ Quarter
> **สถานะ:** ✅ Ready for Review

---