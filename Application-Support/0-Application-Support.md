# คู่มือ Application Support ออกเป็นเล่มตามสายงาน

## 1. หลักการแบ่งเล่ม

การแบ่งคู่มือออกเป็นเล่มใช้หลักการ **"หนึ่งเล่ม = หนึ่งสายงานที่รับผิดชอบได้จริง"** โดยมีเงื่อนไข:

| หลักการ | คำอธิบาย |
|---|---|
| **Role-based** | แบ่งตามบทบาทผู้อ่าน (Monitoring Engineer, Business App Support, ERP Developer, DBA) ไม่ใช่ตามลำดับตัวอักษร |
| **Self-contained** | แต่ละเล่มอ่านจบได้ในตัวเอง มี Dependency ระบุชัดเจน |
| **No Duplication** | หัวข้อที่ปรากฏหลายบริบท (Kafka, Redis) แยกมุมมองให้ชัด ไม่เขียนซ้ำ |
| **Shared Foundation** | Workflow (PSR/RCA/KPI SMART) อยู่ในเล่ม 1 และทุกเล่มอ้างอิงกลับ |
| **Same Structure** | ทุกเล่มใช้โครงสร้าง 3 ส่วนเหมือนกัน: 3. บทหัวข้อ / 4. Workflow / 5. สรุป |


## 2. ตารางสรุปเล่มทั้ง 10 เล่ม

| เล่ม | ชื่อเล่ม | หัวข้อหลัก | ผู้อ่านหลัก | ต้องอ่านก่อน |
|:---:|---|---|---|---|
| **1** | **Foundation & Workflow** | บทนำ, บทนิยาม, Monitoring Frameworks, **PSR, RCA, KPI SMART**, สรุป | ทุกคน | — |
| **2** | **Infrastructure & Network Monitoring** | Host/Infrastructure Metrics, Network Metrics, Jitter | Monitoring Engineer, Support | เล่ม 1 |
| **3** | **Application Metrics & Metrics Platform** | Application Metrics (RED), Prometheus, Grafana, Alertmanager | Monitoring Engineer, SRE | เล่ม 1, 2 |
| **4** | **Log & Time-Series Analytics** | ELK Stack, InfluxDB | Monitoring Engineer, Support | เล่ม 1 |
| **5** | **Messaging & Caching (Observability)** | Kafka, Redis Cache — ในมุม Monitoring | Support, SRE | เล่ม 1, 3 |
| **6** | **AI & Semantic Search** | Vector Database, RAG | Support, AI Engineer | เล่ม 4, 5 |
| **7** | **CRM Support** | CRM (Customer Relationship Management) | Business App Support | เล่ม 1, 3 |
| **8** | **ERP Architecture (DDD)** | Python DDD, Golang DDD, Node.js TypeScript DDD | ERP Developer, Support | เล่ม 1, 3 |
| **9** | **ERP Database Operations** | PostgreSQL, Oracle, MSSQL, MongoDB | DBA, ERP Support | เล่ม 1, 4 |
| **10** | **ERP Integration Layer** | Redis Cache (ERP), Kafka (ERP) — Outbox, Saga, Cache-Aside | ERP Support, Integration Engineer | เล่ม 8, 9 |


## 3. รายละเอียดแต่ละเล่ม

### เล่ม 1: Foundation & Workflow — "อ่านก่อนเล่มอื่นทั้งหมด"

**กลุ่มงาน:** ทุกสายงาน (บังคับอ่าน)

**หัวข้อ:**
- 1. บทนำ (วัตถุประสงค์, เป้าหมาย)
- 2. บทนิยาม (Metric, PromQL, RED/USE, SLI/SLO, DDD, Aggregate Root, Embedding, RAG)
- 3.5 Monitoring Frameworks (Pull vs Push, Agent vs Agentless)
- 4. Workflow เต็มรูปแบบ: 4.1 PSR, 4.2 RCA, 4.3 KPI SMART + Template PSR Report, 5 Whys Worksheet, KPI Scorecard
- 5. สรุป (ประโยชน์, ข้อดี, ข้อเสีย, ข้อห้าม)

**ทำไมต้องแยกเล่ม:** Workflow ถูกอ้างอิงจากทุกเล่ม — ถ้าเขียนในเล่มอื่นจะซ้ำซ้อน

**ตัวอย่างที่ต้องมีในเล่มนี้:**
- Template PSR Report (Markdown/Google Docs)
- Template RCA 5 Whys Worksheet
- Template KPI Scorecard (ตาราง SMART)
- Decision Tree การเลือก Framework (Pull/Push/Agent/Agentless)

---

### เล่ม 2: Infrastructure & Network Monitoring — "สาย Monitoring พื้นฐาน"

**กลุ่มงาน:** Monitoring Engineer, Infrastructure Support, Network Support

**หัวข้อ:**
- 3.2 Host / Infrastructure Metrics (+ Node Exporter ติดตั้ง/ตั้งค่า/Alert Rules/Dashboard)
- 3.4 Network Metrics (+ iperf3_exporter ติดตั้ง/ตั้งค่า/PromQL)
- 3.12 Jitter (ทฤษฎี, การวัด, Threshold VoIP/Video)

**Dependency:** อ่านเล่ม 1 ก่อน (รู้จัก Pull Model, Alertmanager, RED/USE)

**ตัวอย่างที่ต้องมีในเล่มนี้:**
- `node_exporter.service` (systemd)
- `iperf3_exporter` docker-compose
- PromQL: CPU, Memory, Disk, Network, Jitter
- Alert Rules: HostHighCpuLoad, HostMemoryPressure, HighNetworkJitter
- Dashboard JSON: Node Exporter Full (ID 23562) + Network Quality

---

### เล่ม 3: Application Metrics & Metrics Platform — "หัวใจของ Observability"

**กลุ่มงาน:** SRE, Monitoring Engineer, Application Support (Level 2+)

**หัวข้อ:**
- 3.3 Application Metrics (RED Method) + Instrumentation Python/Go/Node
- 3.11 Prometheus (ติดตั้ง, `prometheus.yml`, PromQL, Recording Rules, Remote Write)
- 3.9 Grafana (ติดตั้ง, Provisioning Data Source, Dashboard JSON)
- 3.10 Alertmanager (`alertmanager.yml` เต็ม, Routing Tree, Inhibition, Silence)

**Dependency:** อ่านเล่ม 1 และเล่ม 2 ก่อน (เข้าใจ Metrics และ Host)

**ตัวอย่างที่ต้องมีในเล่มนี้:**
- `prometheus.yml` พร้อม Static + Kubernetes SD + Pushgateway
- `alertmanager.yml` พร้อม Routing ครบ (Slack/PagerDuty/Email)
- PromQL: RED Metrics ครบชุด
- Alert Rules: HighErrorRate, HighLatencyP99, TrafficDrop
- Dashboard JSON: Application RED Dashboard
- `amtool` commands สำหรับทดสอบ Routing

---

### เล่ม 4: Log & Time-Series Analytics — "ค้นหาและวิเคราะห์ข้อมูลย้อนหลัง"

**กลุ่มงาน:** Support Engineer, Forensic Analyst, SRE

**หัวข้อ:**
- 3.8 ELK Stack (Elasticsearch, Logstash, Kibana) + Filebeat + Grok Pattern + ILM
- 3.13 InfluxDB (Time-Series DB, Remote Write จาก Prometheus, Long-term Retention)

**Dependency:** อ่านเล่ม 1 ก่อน

**ทำไม ELK + InfluxDB อยู่เล่มเดียวกัน:** ทั้งคู่เป็น "Data Backend สำหรับ Analytics" ใช้คู่กับ Grafana (เล่ม 3) แต่ไม่ได้ทำ Alerting Real-time

**ตัวอย่างที่ต้องมีในเล่มนี้:**
- `filebeat.yml`
- `logstash.conf` พร้อม Grok Pattern (Parse Log Application)
- Kibana KQL Queries สำหรับ Incident Investigation
- InfluxDB setup + Remote Write config จาก Prometheus
- Dashboard: Error Log Overview (Kibana), Long-term Metrics (Grafana + InfluxDB)

---

### เล่ม 5: Messaging & Caching (Observability) — "ดูแล Pipeline และ Cache ในมุม Monitoring"

**กลุ่มงาน:** Support Engineer, SRE, Data Pipeline Support

**หัวข้อ:**
- 3.6 Kafka (สถาปัตยกรรม, Consumer Lag, kafka_exporter, Alert Rules)
- 3.7 Redis Cache (redis_exporter, Memory, Hit Rate, Eviction, Replication)

**Dependency:** อ่านเล่ม 1, 3 ก่อน (ต้องรู้ Prometheus/Grafana/Alertmanager เพื่อ Monitor)

**หมายเหตุสำคัญ:** เล่ม 5 เน้น **Observability ของ Kafka/Redis** (Lag, Hit Rate, Eviction) — ไม่ใช่ **Pattern การใช้งาน** ซึ่งอยู่ในเล่ม 10

**ตัวอย่างที่ต้องมีในเล่มนี้:**
- `kafka_exporter` docker-compose
- `redis_exporter` docker-compose
- PromQL: Consumer Lag, `deriv(lag)`, Hit Rate, Eviction
- Alert Rules: KafkaConsumerLagGrowing, KafkaUnderReplicatedPartitions, RedisHighMemoryUsage, RedisLowHitRate
- Dashboard JSON: Kafka Overview, Redis Overview

---

### เล่ม 6: AI & Semantic Search — "สาย AI Support"

**กลุ่มงาน:** AI Engineer, Support Engineer ที่ดูแล AI Application

**หัวข้อ:**
- 3.14 Vector Database (หลักการ, Embedding, Similarity Search, Metrics ที่ต้อง Monitor)
- 3.15 RAG (Retrieval-Augmented Generation) + Pipeline Monitoring

**Dependency:** อ่านเล่ม 4 (ELK — เกี่ยวกับ Retrieval) และเล่ม 5 (Kafka — เกี่ยวกับ Data Pipeline) ก่อน

**ตัวอย่างที่ต้องมีในเล่มนี้:**
- Embedding Pipeline (Python) — Text → Vector → Vector DB
- RAG Pipeline ครบ (Chunking → Embedding → Retrieval → Generation)
- Metrics: Retrieval Latency, Recall@K, Generation Latency, Hallucination Rate
- Alert Rules: RAGRetrievalLatencyHigh, RAGLowRecall
- Dashboard: RAG Quality Overview

---

### เล่ม 7: CRM Support — "สาย Business Application"

**กลุ่มงาน:** Business Application Support, CRM Admin

**หัวข้อ:**
- 3.1 CRM (Customer Relationship Management) — เต็มรูปแบบ
  - Critical Path ของ CRM
  - Org Limits Monitoring (API Requests, Storage)
  - Integration Health (Billing, ERP, Marketing)
  - User Experience Metrics (Page Load, API Latency)
  - Incident Playbook สำหรับ CRM

**Dependency:** อ่านเล่ม 1, 3 ก่อน (ต้องเข้าใจ Prometheus/Grafana เพื่อ Monitor CRM)

**ตัวอย่างที่ต้องมีในเล่มนี้:**
- `crm_limits_exporter.py` (Custom Prometheus Exporter)
- `prometheus.yml` scrape config สำหรับ CRM
- PromQL: API Error Rate, Org Limit Utilization, Integration Success Rate
- Alert Rules: CRMHighApiErrorRate, CRMApiLimitNearFull, CRMIntegrationQueueBacklog
- Dashboard JSON: CRM Health Overview
- Incident Playbook: CRM Outage, API Limit Hit, Integration Failure

---

### เล่ม 8: ERP Architecture (DDD) — "สาย Developer / Tech Lead"

**กลุ่มงาน:** ERP Developer, Solution Architect, Tech Lead

**หัวข้อ:**
- Python DDD (Bounded Context, Aggregate Root, Repository Pattern, Domain Event)
- Golang DDD (Hexagonal Architecture, Interface Segregation, Error Handling)
- Node.js TypeScript DDD (NestJS + DDD, Type Safety, Dependency Injection)

**Dependency:** อ่านเล่ม 1 (Workflow) และเล่ม 3 (Prometheus/Grafana — เพื่อ Monitor Application ที่สร้าง)

**ทำไมทั้งสามภาษาอยู่เล่มเดียวกัน:** ทั้งสามภาษาแก้ปัญหาเดียวกัน (ERP Domain Modeling) — การเปรียบเทียบข้ามภาษาทำให้เข้าใจ DDD ลึกขึ้น

**ตัวอย่างที่ต้องมีในเล่มนี้:**
- **Python DDD:** โครงสร้าง `domain/`, `application/`, `infrastructure/`, `presentation/` + Aggregate Root ตัวอย่าง (Order, Invoice)
- **Golang DDD:** Hexagonal + Interface + Error Handling + Unit Test
- **Node.js TypeScript DDD:** NestJS Module + Domain Entity + Repository Interface
- Instrumentation: Prometheus Metrics ในแต่ละภาษา (Python `prometheus_client`, Go `promhttp`, Node `prom-client`)
- Template Code: Repository Pattern, Use Case, Domain Event, Error Boundary

---

### เล่ม 9: ERP Database Operations — "สาย DBA / ERP Support"

**กลุ่มงาน:** DBA, ERP Support, Data Engineer

**หัวข้อ:**
- PostgreSQL (Performance Tuning, Index, Vacuum, Replication, Monitoring)
- Oracle (AWR, ASH, Execution Plan, Tablespace, Monitoring)
- MSSQL (Execution Plan, DMV, Always On, Monitoring)
- MongoDB (Sharding, Replica Set, Index, Monitoring)

**Dependency:** อ่านเล่ม 1 และเล่ม 4 ก่อน (ต้องเข้าใจ ELK/InfluxDB สำหรับ Log และ Time-Series)

**ทำไมทั้งสี่ฐานข้อมูลอยู่เล่มเดียวกัน:** ERP มักใช้หลายฐานข้อมูลพร้อมกัน (PostgreSQL สำหรับ Service ใหม่, Oracle สำหรับ Core, MSSQL สำหรับ Reporting, MongoDB สำหรับ Document) — Support ต้องเข้าใจทั้งสี่เพื่อวินิจฉัยปัญหา Cross-Database

**ตัวอย่างที่ต้องมีในเล่มนี้:**
- **PostgreSQL:** `postgres_exporter` + PromQL (Connection Pool, Slow Query, Replication Lag) + Alert Rules
- **Oracle:** `oracledb_exporter` + PromQL (Tablespace, Session, Wait Events)
- **MSSQL:** `sql_exporter` + PromQL (Blocking, Deadlock, Buffer Cache)
- **MongoDB:** `mongodb_exporter` + PromQL (Replication Lag, Connection, Index Hit Rate)
- Slow Query Templates (แต่ละ DB)
- Backup / Restore Runbook
- Dashboard JSON: Database Health (4 in 1)

---

### เล่ม 10: ERP Integration Layer — "สาย Integration / ERP Support ขั้นสูง"

**กลุ่มงาน:** Integration Engineer, ERP Support, Solution Architect

**หัวข้อ:**
- **Redis Cache (ERP Context):** Cache-Aside Pattern, Write-Through, Write-Behind, Session Store, Distributed Lock, Cache Invalidation Strategy
- **Kafka (ERP Context):** Transactional Outbox Pattern, Saga Pattern, Event Sourcing, Idempotency, Exactly-Once Semantics

**Dependency:** อ่านเล่ม 5 (Observability ของ Kafka/Redis), เล่ม 8 (DDD), เล่ม 9 (Database) ก่อน

**ทำไม Redis/Kafka ปรากฏสองเล่ม:** เล่ม 5 เน้น **Observability** (Monitor Lag, Hit Rate) — เล่ม 10 เน้น **Pattern การใช้งานใน ERP** (Outbox, Saga, Cache-Aside) ซึ่งเป็นคนละทักษะ

**ตัวอย่างที่ต้องมีในเล่มนี้:**
- **Transactional Outbox:** Code Python/Go/Node (เขียน DB + Event ใน Transaction เดียว)
- **Saga Pattern:** Orchestration vs Choreography + Code ตัวอย่าง
- **Cache-Aside:** Code Python/Go/Node + Invalidation Strategy
- **Distributed Lock:** Redis Redlock + Code
- **Idempotency:** Kafka Consumer + Idempotency Key
- Diagram: ERP Integration Flow (Order → Kafka → Inventory → Billing)
- Runbook: Replay Failed Events, Cache Warm-up, Outbox Table Cleanup


## 4. เส้นทางการอ่านตามสายงาน

### เส้นทาง A: Monitoring / Observability Engineer

```
เล่ม 1 → เล่ม 2 → เล่ม 3 → เล่ม 4 → เล่ม 5
```
**ผลลัพธ์:** ดูแล Monitoring Stack ครบ (Metrics, Logs, Alerts, Dashboards)

---

### เส้นทาง B: Business Application Support (CRM)

```
เล่ม 1 → เล่ม 3 → เล่ม 7
```
**ผลลัพธ์:** ดูแล CRM พร้อม Monitoring และ Incident Playbook

---

### เส้นทาง C: ERP Developer / Tech Lead

```
เล่ม 1 → เล่ม 3 → เล่ม 8 → เล่ม 9 → เล่ม 10
```
**ผลลัพธ์:** ออกแบบ ERP ด้วย DDD + Database + Integration Patterns

---

### เส้นทาง D: ERP Support (Full-stack)

```
เล่ม 1 → เล่ม 3 → เล่ม 4 → เล่ม 5 → เล่ม 8 → เล่ม 9 → เล่ม 10
```
**ผลลัพธ์:** ดูแล ERP ได้ทั้ง Monitoring, Database, Integration

---

### เส้นทาง E: AI Engineer / AI Support

```
เล่ม 1 → เล่ม 4 → เล่ม 5 → เล่ม 6
```
**ผลลัพธ์:** ดูแล Vector DB และ RAG Pipeline

---

## 5. หัวข้อที่ปรากฏซ้ำในหลายเล่ม (ต้องจัดการให้ชัด)

| หัวข้อ | เล่มที่ปรากฏ | มุมมองที่แตกต่าง |
|---|---|---|
| **Kafka** | เล่ม 5, เล่ม 10 | เล่ม 5 = Observability (Lag, Broker Health) / เล่ม 10 = Patterns (Outbox, Saga) |
| **Redis Cache** | เล่ม 5, เล่ม 10 | เล่ม 5 = Observability (Memory, Hit Rate) / เล่ม 10 = Patterns (Cache-Aside, Lock) |
| **Prometheus** | เล่ม 3 (เต็ม), เล่ม 2/4/5/7 (อ้างอิง) | เล่ม 3 = ติดตั้ง/ตั้งค่าเต็ม / เล่มอื่น = ใช้ Scrape Config ที่ให้ไว้ |
| **Grafana** | เล่ม 3 (เต็ม), เล่ม 2/4/5/7/9 (Dashboard) | เล่ม 3 = ติดตั้ง/Provisioning / เล่มอื่น = Dashboard JSON พร้อมใช้ |
| **Workflow (PSR/RCA/KPI)** | เล่ม 1 (เต็ม), ทุกเล่ม (อ้างอิง) | เล่ม 1 = Template เต็ม / เล่มอื่น = Link กลับเล่ม 1 |

**กฎการเขียน:** หัวข้อที่ซ้ำให้เขียนเต็มในเล่มแรกที่ปรากฏ และในเล่มถัดไปให้เขียนเฉพาะ **"สิ่งที่แตกต่าง"** พร้อม Link กลับ


## 6. โครงสร้างภายในแต่ละเล่ม (เหมือนกันทุกเล่ม)

ทุกเล่มใช้โครงสร้างตามที่กำหนดไว้ในคำขอเดิม:

```
เล่ม X: [ชื่อเล่ม]
├── บทนำ (วัตถุประสงค์, เป้าหมายของเล่ม)
├── บทนิยาม (เฉพาะคำศัพท์ใหม่ในเล่มนี้)
├── บทหัวข้อ (แต่ละหัวข้อมี 15 องค์ประกอบครบ)
│   ├── เรื่อง
│   ├── วัตถุประสงค์ / เป้าหมาย
│   ├── เนื้อหา / รายละเอียด
│   ├── การติดตั้ง / การตั้งค่า
│   ├── การวิเคราะห์และแนวทางแก้ไข
│   ├── ลำดับการจัดการปัญหา
│   ├── Template Code
│   ├── Template Dashboard
│   ├── สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม
│   ├── ตัวอย่าง
│   ├── สรุปย่อเพื่อจดจำ
│   └── แหล่งที่มา
├── Workflow (อ้างอิงเล่ม 1 + Incident Playbook เฉพาะเล่ม)
└── สรุป (ประโยชน์, ข้อดี, ข้อเสีย, ข้อห้าม)
```


## 7. ลำดับ

| ลำดับ | เล่ม | เหตุผล |
|:---:|---|---|
| 1 | เล่ม 1 | Foundation — ทุกเล่มอ้างอิง |
| 2 | เล่ม 3 | Metrics Platform — ใช้ในเกือบทุกเล่ม |
| 3 | เล่ม 2 | Infrastructure — ต่อยอดจากเล่ม 3 ได้ทันที |
| 4 | เล่ม 4 | Log & TSDB — เติมเต็ม Observability |
| 5 | เล่ม 5 | Kafka/Redis Observability — ใช้ใน ERP และ AI |
| 6 | เล่ม 9 | Database — ฐานสำหรับ ERP และ CRM |
| 7 | เล่ม 8 | DDD — ต้องใช้ Database (เล่ม 9) ประกอบ |
| 8 | เล่ม 10 | Integration — ต้องใช้ DDD (เล่ม 8) + DB (เล่ม 9) |
| 9 | เล่ม 7 | CRM — ใช้ Metrics Platform (เล่ม 3) + Playbook |
| 10 | เล่ม 6 | AI/RAG — ต้องใช้ ELK (เล่ม 4) + Kafka (เล่ม 5) |


## สรุป

การแบ่งคู่มือออกเป็น **10 เล่มตามสายงาน** ทำให้:

- **ผู้อ่านใหม่** เริ่มจากเล่ม 1 แล้วเลือกเส้นทางตามบทบาท (A–E) ได้ทันที
- **ทีม Support** มี Runbook เฉพาะงานของตน โดยไม่ต้องแบกเนื้อหาที่ไม่เกี่ยวข้อง
- **หัวข้อที่ซ้ำ** (Kafka, Redis, Prometheus, Grafana) ถูกจัดการด้วยหลัก "เขียนเต็มครั้งเดียว + อ้างอิงกลับ"
- **Workflow (PSR/RCA/KPI SMART)** เป็นศูนย์กลางในเล่ม 1 และถูกอ้างอิงจากทุกเล่ม ทำให้มาตรฐานการทำงานสอดคล้องกันทั้งองค์กร

