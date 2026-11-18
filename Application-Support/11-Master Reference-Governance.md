## เล่ม 11: Master Reference & Governance — "ดัชนีรวม, อภิธานศัพท์, และการจัดการเวอร์ชัน"

> **กลุ่มงาน:** ทุกสายงาน (Reference Volume — ใช้ร่วมกับเล่ม 1–10)
> **Dependency:** อ่านเล่ม 1 ก่อน — ใช้เล่มนี้เป็น **จุดอ้างอิงกลาง** สำหรับทั้งชุด
> **เวอร์ชัน:** 1.0
> **สถานะ:** ✅ Ready for Review


## บทนำ

### วัตถุประสงค์ของเล่ม

เล่ม 11 เป็น **"Reference Volume"** ที่ไม่ได้สอนเนื้อหาใหม่ แต่ทำหน้าที่เป็น **ศูนย์กลางการอ้างอิง (Single Source of Reference)** สำหรับชุดคู่มือทั้ง 10 เล่ม ประกอบด้วย:

| หมวด | เนื้อหา | ใช้เมื่อ |
|---|---|---|
| **A. Master Index** | ดัชนีรวมทุกหัวข้อ ทุกเล่ม | ค้นหาหัวข้อที่ต้องการ |
| **B. Combined Glossary** | อภิธานศัพท์รวม (100+ คำ) | ไม่เข้าใจคำศัพท์ |
| **C. Cross-Reference Matrix** | ตารางอ้างอิงข้ามเล่ม | หัวข้อซ้ำ / Dependency |
| **D. Reading Paths** | เส้นทางการอ่าน 5 สายงาน | วางแผนการเรียนรู้ |
| **E. Tool Version Matrix** | เวอร์ชันเครื่องมือทั้งหมด | ติดตั้ง / Upgrade |
| **F. Metrics & Alert Catalog** | แคตตาล็อก Metrics และ Alert | ออกแบบ Monitoring |
| **G. Runbook & Template Index** | ดัชนี Runbook และ Template | Incident Response |
| **H. Version Control Guide** | การจัดการเวอร์ชันเอกสาร | Update / Review |
| **I. Contribution Guide** | การมีส่วนร่วม / Review Process | เพิ่ม / แก้ไขเนื้อหา |
| **J. Maintenance Calendar** | ปฏิทินบำรุงรักษา | วางแผนรายปี |

### เป้าหมายของเล่ม

| เป้าหมาย | ตัวชี้วัดความสำเร็จ |
|---|---|
| ค้นหาหัวข้อได้ใน < 30 วินาที | Master Index ครบทุกหัวข้อ |
| เข้าใจคำศัพท์ตรงกันทั้งองค์กร | Glossary ครอบคลุม 100+ คำ |
| Version Control ชัดเจน | ทุกเล่มมี Changelog + Owner |
| Review Process มีมาตรฐาน | Pull Request + Reviewer Checklist |
| ไม่มีเนื้อหาซ้ำ | Cross-Reference Matrix ครบ |

### สิ่งที่ **ไม่** อยู่ในเล่มนี้

- เนื้อหาการติดตั้ง/ตั้งค่า (อยู่ในเล่ม 1–10)
- Workflow PSR/RCA/KPI SMART แบบเต็ม (อยู่ในเล่ม 1)
- Incident Playbook แบบเต็ม (อยู่ในเล่มที่เกี่ยวข้อง)

### ทำไมต้องมีเล่ม 11

เมื่อคู่มือมี **10 เล่ม** ปัญหาที่ตามมาคือ:

1. **ค้นหายาก** — ไม่รู้ว่าหัวข้ออยู่เล่มไหน
2. **คำศัพท์ไม่ตรงกัน** — เล่ม 3 เรียก "Duration" เล่ม 8 เรียก "Latency"
3. **Version สับสน** — แต่ละเล่มใช้ Tool version ต่างกัน
4. **เนื้อหาซ้ำ** — Kafka อยู่ในเล่ม 5 และ 10
5. **Update ไม่ทั่วถึง** — แก้เล่ม 3 แต่ลืมแก้เล่ม 5

เล่ม 11 แก้ปัญหาทั้ง 5 ข้อนี้

---

## A. Master Index — ดัชนีรวมทุกเล่ม

### A.1 ดัชนีตามหัวข้อ (Topic Index)

| # | หัวข้อ | เล่ม | หน้าโดยประมาณ | Dependency |
|:---:|---|:---:|:---:|---|
| **1** | Workflow PSR/RCA/KPI SMART | 1 | 4.x | — |
| **2** | Monitoring Frameworks (Pull/Push) | 1 | 3.5 | — |
| **3** | Host/Infrastructure Metrics | 2 | 3.2 | 1 |
| **4** | Network Metrics + Jitter | 2 | 3.4, 3.12 | 1 |
| **5** | Application Metrics (RED) | 3 | 3.3 | 1, 2 |
| **6** | Prometheus (ติดตั้ง/PromQL/Recording Rules) | 3 | 3.11 | 1, 2 |
| **7** | Grafana (Provisioning/Dashboard) | 3 | 3.9 | 1, 2 |
| **8** | Alertmanager (Routing/Inhibition/Silence) | 3 | 3.10 | 1, 2 |
| **9** | ELK Stack (Elasticsearch/Logstash/Kibana) | 4 | 3.8 | 1 |
| **10** | InfluxDB (Long-term Retention) | 4 | 3.13 | 1 |
| **11** | Kafka Observability (Consumer Lag, ISR) | 5 | 3.6 | 1, 3 |
| **12** | Redis Observability (Hit Rate, Eviction) | 5 | 3.7 | 1, 3 |
| **13** | Vector Database (Qdrant, Milvus, pgvector) | 6 | 3.14 | 1, 4, 5 |
| **14** | RAG Pipeline (Embed → Retrieve → Generate) | 6 | 3.15 | 1, 4, 5 |
| **15** | CRM Support (Org Limits, Integration, UX) | 7 | 3.1 | 1, 3 |
| **16** | Python DDD | 8 | 8.1 | 1, 3 |
| **17** | Golang DDD (Hexagonal) | 8 | 8.2 | 1, 3 |
| **18** | Node.js TypeScript DDD (NestJS) | 8 | 8.3 | 1, 3 |
| **19** | PostgreSQL (Monitoring/Vacuum/Replication) | 9 | 9.1 | 1, 4 |
| **20** | Oracle (AWR/ASH/Tablespace) | 9 | 9.2 | 1, 4 |
| **21** | MSSQL (DMV/Always On) | 9 | 9.3 | 1, 4 |
| **22** | MongoDB (Replica Set/WiredTiger) | 9 | 9.4 | 1, 4 |
| **23** | Redis Cache Patterns (Cache-Aside, Lock) | 10 | 10.1 | 5, 8, 9 |
| **24** | Kafka Patterns (Outbox, Saga, Idempotency) | 10 | 10.2 | 5, 8, 9 |

### A.2 ดัชนีตามคำสำคัญ (Keyword Index)

| คำสำคัญ | หัวข้อ | เล่ม |
|---|---|---|
| **AWR** | Oracle Diagnostics | 9 |
| **Alertmanager** | Routing, Inhibition, Silence | 3 |
| **Aggregate Root** | DDD Pattern | 8 |
| **Bounded Context** | DDD Pattern | 8 |
| **Cache-Aside** | Redis Pattern | 10 |
| **Consumer Lag** | Kafka Observability | 5 |
| **DDD** | Domain-Driven Design | 8 |
| **Deadlock** | PostgreSQL, MSSQL | 9 |
| **Domain Event** | DDD + Integration | 8, 10 |
| **ELK Stack** | Centralized Logging | 4 |
| **Eviction** | Redis Memory | 5 |
| **Faithfulness** | RAG Quality | 6 |
| **Grafana** | Visualization | 3 |
| **Grok Pattern** | Logstash Parsing | 4 |
| **Hallucination** | RAG Quality | 6 |
| **Hexagonal Architecture** | Golang DDD | 8 |
| **Idempotency** | Kafka Consumer | 10 |
| **ILM** | Elasticsearch Lifecycle | 4 |
| **InfluxDB** | Long-term Metrics | 4 |
| **Jitter** | Network Quality | 2 |
| **KQL** | Kibana Query | 4 |
| **Kafka** | Messaging (Observability + Patterns) | 5, 10 |
| **Outbox Pattern** | Kafka + DB Atomicity | 10 |
| **Prometheus** | Metrics Platform | 3 |
| **PromQL** | Prometheus Query | 3 |
| **RAG** | Retrieval-Augmented Generation | 6 |
| **RCA** | Root Cause Analysis | 1 |
| **RED Method** | Application Metrics | 3 |
| **Redlock** | Distributed Lock | 10 |
| **Redis** | Cache (Observability + Patterns) | 5, 10 |
| **Replication Lag** | PostgreSQL, MongoDB | 9 |
| **Saga Pattern** | Distributed Transaction | 10 |
| **Transactional Outbox** | DB + Kafka Atomicity | 10 |
| **Vector Database** | Embedding Storage | 6 |
| **Vacuum** | PostgreSQL Maintenance | 9 |
| **WiredTiger** | MongoDB Storage Engine | 9 |

### A.3 ดัชนีตามไฟล์ (File Index)

| ไฟล์ | ชื่อ | เล่ม |
|---|---|---|
| `0-Application-Support.md` | หลักการแบ่งเล่ม | — |
| `1-Foundation-Workflow.md` | Foundation & Workflow | 1 |
| `2-Infrastructure-Network.md` | Infrastructure & Network Monitoring | 2 |
| `3-Application-Metrics.md` | Application Metrics & Metrics Platform | 3 |
| `4-Log-TSDB.md` | Log & Time-Series Analytics | 4 |
| `5-Messaging-Caching-Obs.md` | Messaging & Caching (Observability) | 5 |
| `6-AI-Semantic-Search.md` | AI & Semantic Search | 6 |
| `7-CRM-Support.md` | CRM Support | 7 |
| `8-ERP-Architecture-DDD.md` | ERP Architecture (DDD) | 8 |
| `9-ERP-Database.md` | ERP Database Operations | 9 |
| `10-ERP-Integration.md` | ERP Integration Layer | 10 |
| `11-Master-Reference.md` | Master Reference & Governance | 11 |

---

## B. Combined Glossary — อภิธานศัพท์รวม

### B.1 วิธีใช้ Glossary

- **เรียงตามตัวอักษร A–Z** (ภาษาอังกฤษ) + **ก–ฮ** (ภาษาไทย)
- แต่ละคำระบุ **เล่มที่นิยามครั้งแรก** และ **เล่มที่ใช้งาน**
- คำที่มีความหมายต่างกันในแต่ละบริบท → ระบุ **บริบท**

### B.2 Glossary (A–Z)

| คำ | ความหมาย | นิยามครั้งแรก | ใช้งานใน |
|---|---|---|---|
| **Aggregate** | กลุ่ม Entity ที่ถูก treat เป็นหน่วยเดียว | 8 | 8, 10 |
| **Aggregate Root** | Entity หลักของ Aggregate — ทางเข้าเดียว | 8 | 8, 10 |
| **Alertmanager** | Component ของ Prometheus ที่จัดการ Alert Routing | 3 | 3, 5, 7, 9 |
| **ANN (Approximate Nearest Neighbor)** | การค้นหา Vector แบบประมาณ | 6 | 6 |
| **Anti-Corruption Layer (ACL)** | ชั้นแปลข้อมูลระหว่าง 2 Bounded Context | 8 | 8, 10 |
| **AWR (Automatic Workload Repository)** | Snapshot ประสิทธิภาพ Oracle ทุก 1 ชม. | 9 | 9 |
| **ASH (Active Session History)** | ข้อมูล Session Oracle ที่ active ทุก 1 วินาที | 9 | 9 |
| **Bounded Context** | ขอบเขตของ Domain Model ที่มีความหมายเฉพาะ | 8 | 8, 10 |
| **Cache-Aside** | Pattern: App ตรวจ Cache → Miss → อ่าน DB → เขียน Cache | 10 | 10 |
| **Cache Hit / Miss** | Request ที่เจอ / ไม่เจอข้อมูลใน Cache | 5 | 5, 10 |
| **Cache Stampede** | หลาย Request Miss พร้อมกัน → ถล่ม DB | 10 | 10 |
| **Chunk** | ส่วนของเอกสารที่ถูกแบ่งเพื่อ Embed | 6 | 6 |
| **Collection** | หน่วยเก็บข้อมูลใน Vector DB | 6 | 6 |
| **Compensating Transaction** | การย้อนกลับเมื่อ Saga Step ล้มเหลว | 10 | 10 |
| **Consumer Group** | กลุ่ม Consumer ที่แบ่ง Partition กันอ่าน | 5 | 5, 10 |
| **Consumer Lag** | `Log End Offset − Consumer Offset` | 5 | 5, 10 |
| **Counter** | Metric Type ที่เพิ่มอย่างเดียว | 3 | 3, 7 |
| **Critical Path** | เส้นทางทำงานหลักที่ถ้าล่มกระทบธุรกิจทันที | 7 | 7 |
| **Data Stream** | Abstraction เหนือ Index สำหรับ append-only log | 4 | 4 |
| **DDD (Domain-Driven Design)** | วิธีการออกแบบที่เน้น Domain Model เป็นศูนย์กลาง | 8 | 8, 10 |
| **Dead Letter Queue (DLQ)** | คิวเก็บ Message ที่ประมวลผลไม่สำเร็จ | 7, 10 | 7, 10 |
| **DMV (Dynamic Management View)** | View พิเศษใน MSSQL แสดงสถานะภายใน | 9 | 9 |
| **Domain Event** | เหตุการณ์ที่เกิดขึ้นใน Domain | 8 | 8, 10 |
| **Downsampling** | ลดความละเอียดของข้อมูลเก่าเพื่อประหยัดพื้นที่ | 4 | 4 |
| **Embedding** | การแปลงข้อความเป็น Vector | 6 | 6 |
| **Entity** | Object ที่มี Identity | 8 | 8 |
| **Eviction** | การลบ key ออกจาก Redis เมื่อ Memory เต็ม | 5 | 5, 10 |
| **Exactly-Once Semantics (EOS)** | Kafka Feature ที่รับประกันประมวลผลครั้งเดียว | 10 | 10 |
| **Faithfulness** | ระดับที่คำตอบ RAG สอดคล้องกับ Context | 6 | 6 |
| **Fencing Token** | ตัวเลขเพิ่มขึ้นเรื่อยๆ เพื่อกัน Lock หมดอายุ | 10 | 10 |
| **Gauge** | Metric Type ที่ขึ้นลงได้ | 3 | 3, 7 |
| **Grok Pattern** | Regex แบบมีชื่อ ใช้ใน Logstash | 4 | 4 |
| **Hallucination** | คำตอบ LLM สร้างเองโดยไม่มีหลักฐาน | 6 | 6 |
| **Hexagonal Architecture** | สถาปัตยกรรมแยก Core ออกจาก Adapter | 8 | 8 |
| **Histogram** | Metric Type ที่เก็บการกระจายตัว (bucket) | 3 | 3, 5, 6, 7 |
| **Hit Rate** | `hits / (hits + misses)` | 5 | 5, 10 |
| **Idempotency** | การประมวลผลซ้ำได้ผลเหมือนเดิม | 10 | 10 |
| **ILM (Index Lifecycle Management)** | นโยบายหมุนเวียน Index ใน Elasticsearch | 4 | 4 |
| **Ingest Node** | Elasticsearch Node ที่ parse document ก่อน index | 4 | 4 |
| **Invariant** | กฎที่ต้องเป็นจริงเสมอ — protect ใน Aggregate | 8 | 8 |
| **ISR (In-Sync Replica)** | Replica ที่ตาม Leader ทัน | 5 | 5 |
| **Jitter** | ความแปรปรวนของ Network Latency | 2 | 2 |
| **KQL (Kibana Query Language)** | ภาษาคิวรีใน Kibana | 4 | 4 |
| **Log End Offset (LEO)** | ตำแหน่งล่าสุดของ message ใน Partition | 5 | 5 |
| **Mapping** | Schema ของ Index ใน Elasticsearch | 4 | 4 |
| **Oplog** | Operation Log ของ MongoDB | 9 | 9 |
| **Orchestration Saga** | Saga ที่มี Coordinator สั่งแต่ละ Step | 10 | 10 |
| **Org Limits** | โควตาของ CRM Platform (API, Storage) | 7 | 7 |
| **Outbox Pattern** | เขียน Event ลง Table ใน Transaction เดียวกับ Data | 10 | 10 |
| **Port** | Interface ที่ Domain ประกาศ | 8 | 8 |
| **PromQL** | ภาษาคิวรีของ Prometheus | 3 | 3, 5, 7, 9 |
| **Pull Model** | Prometheus ดึง Metrics จาก Target | 1 | 1, 2, 3 |
| **Push Model** | Target ส่ง Metrics ไป Prometheus (ผ่าน Pushgateway) | 1 | 1, 2, 3 |
| **Qdrant** | Vector Database (เน้น Latency ต่ำ) | 6 | 6 |
| **RAG (Retrieval-Augmented Generation)** | สถาปัตยกรรมดึงข้อมูลภายนอกมาเสริมให้ LLM ตอบ | 6 | 6 |
| **RCA (Root Cause Analysis)** | การวิเคราะห์หาสาเหตุราก | 1 | ทุกเล่ม |
| **Recall@K** | สัดส่วน True Top-K ที่ระบบดึงได้ | 6 | 6 |
| **Recording Rule** | PromQL ที่คำนวณล่วงหน้าและเก็บเป็น Metric ใหม่ | 3 | 3 |
| **RED Method** | Rate, Errors, Duration | 3 | 3, 5, 7 |
| **Redlock** | Algorithm Distributed Lock ของ Redis | 10 | 10 |
| **Remote Write** | Prometheus ส่ง Metrics ไปปลายทางอื่น | 3 | 3, 4 |
| **Replica Set** | กลุ่ม MongoDB Node (Primary + Secondary) | 9 | 9 |
| **Repository** | Abstraction สำหรับดึง/เก็บ Aggregate | 8 | 8, 10 |
| **Retention Policy** | นโยบายลบข้อมูลเก่าอัตโนมัติ | 4 | 4 |
| **Saga Pattern** | Distributed Transaction ที่แบ่งเป็น Local Tx + Compensation | 10 | 10 |
| **Shard** | ชิ้นส่วนของ Index (Elasticsearch) / ข้อมูล (MongoDB) | 4, 9 | 4, 9 |
| **Similarity Search** | การค้นหา Vector ที่ใกล้ที่สุด | 6 | 6 |
| **Singleflight** | Go Library ที่ dedupe concurrent calls | 10 | 10 |
| **SLI / SLO** | Service Level Indicator / Objective | 1 | 1, 3 |
| **Summary** | Metric Type ที่คำนวณ Quantile ฝั่ง Client | 3 | 3 |
| **Tablespace** | หน่วยเก็บข้อมูลใน Oracle | 9 | 9 |
| **Top-K** | จำนวนผลลัพธ์ที่ดึงมา | 6 | 6 |
| **Transactional Outbox** | Outbox Pattern + Transaction | 10 | 10 |
| **TTL (Time-To-Live)** | เวลาหมดอายุของ key | 5, 10 | 5, 10 |
| **Ubiquitous Language** | ภาษากลางที่ Developer + Domain Expert ใช้ร่วม | 8 | 8 |
| **Under-Replicated Partition** | Partition ที่ ISR < RF | 5 | 5 |
| **Unit of Work** | การรวมหลาย Repository Operation ใน Transaction เดียว | 8 | 8 |
| **Value Object** | Object ที่ไม่มี Identity (Money, Address) | 8 | 8 |
| **Vector Database** | ฐานข้อมูลที่เก็บ Embedding | 6 | 6 |
| **WiredTiger** | Storage Engine ของ MongoDB | 9 | 9 |
| **pg_stat_statements** | Extension PostgreSQL สำหรับ track query | 9 | 9 |
| **pg_stat_activity** | View PostgreSQL แสดง session | 9 | 9 |
| **pg_replication_slots** | Slot PostgreSQL สำหรับ WAL | 9 | 9 |

### B.3 Glossary (ภาษาไทย)

| คำ | ความหมาย | เล่ม |
|---|---|---|
| **การแจ้งเตือน (Alerting)** | การแจ้งเมื่อ Metrics ผิดปกติ | 3 |
| **ค่าผิดปกติ (Anomaly)** | ค่าที่เบี่ยงเบนจาก Baseline | 3 |
| **จุดอ้างอิง (Baseline)** | ค่าปกติที่วัดไว้เป็นมาตรฐาน | 3 |
| **ดัชนี (Index)** | โครงสร้างช่วยค้นหาเร็ว | 4, 9 |
| **ทุกข์ (Bottleneck)** | จุดที่ทำให้ระบบช้า | 3, 9 |
| **ประสิทธิภาพ (Performance)** | ความเร็ว/ความสามารถของระบบ | ทุกเล่ม |
| **ผลผลิต (Throughput)** | จำนวนงานที่ทำได้ต่อหน่วยเวลา | 3, 5 |
| **เวลาแฝง (Latency)** | เวลาที่ใช้ในการตอบสนอง | 3, 6 |
| **เสถียรภาพ (Reliability)** | ความสามารถทำงานได้ต่อเนื่อง | ทุกเล่ม |
| **ห่วงโซ่ (Pipeline)** | ลำดับขั้นตอนการทำงาน | 4, 5, 6 |
| **อัตราความสำเร็จ (Success Rate)** | สัดส่วนที่ทำงานสำเร็จ | 3, 7 |
| **อัตราความล้มเหลว (Failure Rate)** | สัดส่วนที่ล้มเหลว | 3, 7 |

---

## C. Cross-Reference Matrix — ตารางอ้างอิงข้ามเล่ม

### C.1 หัวข้อที่ปรากฏซ้ำ (Duplicated Topics)

| หัวข้อ | เล่มที่ปรากฏ | มุมมองที่แตกต่าง | กฎการเขียน |
|---|---|---|---|
| **Kafka** | 5, 10 | เล่ม 5 = Observability / เล่ม 10 = Patterns | เขียนเต็มใน 5, อ้างอิงใน 10 |
| **Redis Cache** | 5, 10 | เล่ม 5 = Observability / เล่ม 10 = Patterns | เขียนเต็มใน 5, อ้างอิงใน 10 |
| **Prometheus** | 3 (เต็ม), 2/4/5/7/9 (อ้างอิง) | เล่ม 3 = ติดตั้งเต็ม / เล่มอื่น = scrape config | เขียนเต็มใน 3 |
| **Grafana** | 3 (เต็ม), 2/4/5/7/9 (Dashboard) | เล่ม 3 = Provisioning / เล่มอื่น = Dashboard JSON | เขียนเต็มใน 3 |
| **Workflow (PSR/RCA/KPI)** | 1 (เต็ม), ทุกเล่ม (อ้างอิง) | เล่ม 1 = Template เต็ม / เล่มอื่น = Link | เขียนเต็มใน 1 |
| **RED Method** | 3, 5, 7 | เล่ม 3 = ติดตั้ง / เล่ม 5/7 = ใช้งาน | เขียนเต็มใน 3 |
| **Jitter** | 2, 3 | เล่ม 2 = Network / เล่ม 3 = Alerting | เขียนเต็มใน 2 |
| **Vector DB** | 6 | 6 เท่านั้น | ไม่ซ้ำ |
| **DDD** | 8 (เต็ม), 10 (อ้างอิง) | เล่ม 8 = Pattern / เล่ม 10 = ใช้ใน Integration | เขียนเต็มใน 8 |

### C.2 Dependency Matrix

| เล่ม | ต้องอ่านก่อน (Hard) | แนะนำ (Soft) | ใช้ต่อใน |
|:---:|---|---|---|
| **1** | — | — | ทุกเล่ม |
| **2** | 1 | — | 3, 4, 5 |
| **3** | 1, 2 | — | 4, 5, 6, 7, 8, 9, 10 |
| **4** | 1 | 3 | 6, 9 |
| **5** | 1, 3 | 2 | 6, 10 |
| **6** | 4, 5 | 3 | — |
| **7** | 1, 3 | — | — |
| **8** | 1, 3 | 9 | 10 |
| **9** | 1, 4 | 3 | 10 |
| **10** | 5, 8, 9 | 3 | — |
| **11** | 1 | ทุกเล่ม | — |

### C.3 ลำดับการอ่านที่แนะนำ (Recommended Order)

```
Foundation → Metrics → Infra → Log → Messaging → DB → DDD → Integration
   1    →    3    →   2   →  4  →    5     →  9  →  8  →     10
```

> **เหตุผล:** เริ่มจาก Foundation (1) → Metrics Platform (3) ที่ทุกเล่มใช้ → Infrastructure (2) → Log (4) → Messaging (5) → Database (9) → DDD (8) → Integration (10)

### C.4 คำศัพท์ที่ใช้ต่างกันในแต่ละเล่ม (Terminology Consistency)

| แนวคิด | เล่ม 1 | เล่ม 3 | เล่ม 5 | เล่ม 8 | เล่ม 10 | **มาตรฐาน** |
|---|---|---|---|---|---|---|
| เวลาตอบสนอง | Response Time | Duration | Latency | — | — | **Latency** |
| อัตราความล้มเหลว | Error Rate | Error Rate | Error Rate | — | — | **Error Rate** |
| การแจ้งเตือน | Alert | Alert | Alert | — | — | **Alert** |
| ฐานข้อมูล | DB | — | — | Repository | Store | **Database** |
| เหตุการณ์ | Event | — | Message | Domain Event | Domain Event | **Domain Event** (DDD) / **Message** (Kafka) |
| กลุ่มข้อมูล | Collection | — | Topic | Aggregate | Aggregate | **Aggregate** (DDD) / **Collection** (Vector DB) / **Topic** (Kafka) |

> **กฎ:** ใช้คำมาตรฐานตามคอลัมน์สุดท้าย — ถ้าต้องใช้คำอื่น ให้ระบุในวงเล็บ

---

## D. Reading Paths — เส้นทางการอ่าน

### D.1 เส้นทางทั้ง 5 (สรุปจากเล่ม 0)

| เส้นทาง | ผู้อ่าน | ลำดับ | ผลลัพธ์ |
|---|---|---|---|
| **A: Monitoring Engineer** | SRE, Monitoring | 1 → 2 → 3 → 4 → 5 | ดูแล Monitoring Stack ครบ |
| **B: Business App Support** | CRM Admin | 1 → 3 → 7 | ดูแล CRM + Monitoring |
| **C: ERP Developer** | Developer, Tech Lead | 1 → 3 → 8 → 9 → 10 | ออกแบบ ERP DDD + DB + Integration |
| **D: ERP Support** | Support, DBA | 1 → 3 → 4 → 5 → 8 → 9 → 10 | ดูแล ERP ครบทุก Layer |
| **E: AI Engineer** | AI Engineer | 1 → 4 → 5 → 6 | ดูแล Vector DB + RAG |

### D.2 ตารางเรียนแนะนำ (8 สัปดาห์)

| สัปดาห์ | เส้นทาง A | เส้นทาง B | เส้นทาง C | เส้นทาง D | เส้นทาง E |
|:---:|---|---|---|---|---|
| **1** | เล่ม 1 | เล่ม 1 | เล่ม 1 | เล่ม 1 | เล่ม 1 |
| **2** | เล่ม 2 | เล่ม 3 | เล่ม 3 | เล่ม 3 | เล่ม 4 |
| **3** | เล่ม 3 | เล่ม 7 | เล่ม 8 | เล่ม 4 | เล่ม 5 |
| **4** | เล่ม 4 | — | เล่ม 9 | เล่ม 5 | เล่ม 6 |
| **5** | เล่ม 5 | — | เล่ม 10 | เล่ม 8 | — |
| **6** | — | — | — | เล่ม 9 | — |
| **7** | — | — | — | เล่ม 10 | — |
| **8** | ทบทวน | ทบทวน | ทบทวน | ทบทวน | ทบทวน |

---

## E. Tool Version Matrix — เวอร์ชันเครื่องมือ

### E.1 Version Matrix (ณ วันที่ปรับปรุง)

| Tool | Version | ใช้ในเล่ม | หมายเหตุ |
|---|---|---|---|
| **Prometheus** | v2.53.0 | 3, 4, 5, 7, 9 | LTS แนะนำ |
| **Alertmanager** | v0.27.0 | 3, 5, 7, 9 | คู่กับ Prometheus v2.53 |
| **Grafana** | 11.1.0 | 3, 4, 5, 7, 9 | LTS |
| **Elasticsearch** | 8.15.0 | 4 | ต้องใช้ Java 21 |
| **Logstash** | 8.15.0 | 4 | |
| **Kibana** | 8.15.0 | 4 | |
| **Filebeat** | 8.15.0 | 4 | |
| **InfluxDB** | 2.7 | 4 | 3.x ยังไม่แนะนำ |
| **Qdrant** | v1.19.0 | 6 | |
| **qdrant-exporter** | latest | 6 | |
| **kafka_exporter** | v1.7.0 | 5 | |
| **redis_exporter** | v1.62.0 | 5 | |
| **postgres_exporter** | v0.19.1 | 9 | |
| **oracledb_exporter** | v0.5.0 | 9 | ต้องมี Instant Client |
| **mssql-prometheus-exporter** | latest | 9 | Official Microsoft |
| **mongodb_exporter** | 0.43.1 | 9 | Percona |
| **Python** | 3.11+ | 8 | |
| **Go** | 1.23 | 8 | |
| **Node.js** | 20 LTS | 8 | |
| **NestJS** | 10.4 | 8 | |
| **PostgreSQL** | 16 | 9 | |
| **Oracle** | 19c / 21c | 9 | |
| **MSSQL** | 2022 | 9 | |
| **MongoDB** | 7.0 | 9 | |
| **Kafka** | 3.7 (KRaft) | 5, 10 | |
| **Redis** | 7.2 | 5, 10 | |

### E.2 Upgrade Policy

| ระดับ | Tool | นโยบาย |
|---|---|---|
| **LTS** | Prometheus, Grafana, Elasticsearch | Upgrade ทุก **6 เดือน** |
| **Stable** | Kafka, Redis, PostgreSQL | Upgrade ทุก **12 เดือน** |
| **Fast-moving** | Qdrant, Exporter | Upgrade ทุก **3 เดือน** |
| **Language** | Python, Go, Node.js | Upgrade ตาม **LTS cycle** |

> **กฎ:** Upgrade ใน **Staging ก่อน** — รัน Integration Test ครบ — แล้วจึง Upgrade Production

---

## F. Metrics & Alert Catalog — แคตตาล็อก Metrics และ Alert

### F.1 Metrics Catalog (สรุปทุกเล่ม)

| Metric | เล่ม | Type | คำอธิบาย | เป้า |
|---|---|---|---|---|
| `node_cpu_seconds_total` | 2 | Counter | CPU Usage | < 80% |
| `node_memory_MemAvailable_bytes` | 2 | Gauge | Memory Available | > 20% |
| `node_network_receive_bytes_total` | 2 | Counter | Network RX | ตาม Baseline |
| `http_requests_total` | 3 | Counter | HTTP Requests | — |
| `http_request_duration_seconds_bucket` | 3 | Histogram | Latency | P99 < 500ms |
| `up` | 3 | Gauge | Target UP/DOWN | 1 |
| `kafka_consumergroup_lag` | 5 | Gauge | Consumer Lag | < 1000 |
| `kafka_topic_partition_under_replicated_partition` | 5 | Gauge | URP | 0 |
| `redis_memory_used_bytes` | 5 | Gauge | Redis Memory | < 80% |
| `redis_keyspace_hits_total` | 5 | Counter | Hit Rate | > 80% |
| `qdrant_indexed_vectors_ratio` | 6 | Gauge | Indexed Ratio | 1.0 |
| `rag_recall_at_k` | 6 | Gauge | Recall@K | > 0.9 |
| `rag_faithfulness_score` | 6 | Histogram | Faithfulness | > 0.9 |
| `crm_api_usage_percent` | 7 | Gauge | API Usage | < 80% |
| `crm_integration_success_total` | 7 | Counter | Integration Success | > 99% |
| `pg_stat_activity_count` | 9 | Gauge | PG Connections | < 85% |
| `pg_replication_lag` | 9 | Gauge | PG Replication Lag | < 30s |
| `oracledb_tablespace_bytes` | 9 | Gauge | Oracle Tablespace | < 85% |
| `mongodb_mongod_replset_member_replication_lag` | 9 | Gauge | Mongo Repl Lag | < 10s |

### F.2 Alert Catalog (สรุปทุกเล่ม)

| Alert | เล่ม | Severity | เงื่อนไข | Runbook |
|---|---|---|---|---|
| `HostHighCpuLoad` | 2 | warning | CPU > 80% (5m) | เล่ม 2 |
| `HostMemoryPressure` | 2 | warning | Memory > 85% | เล่ม 2 |
| `HighErrorRate` | 3 | critical | Error Rate > 5% | เล่ม 3 |
| `HighLatencyP99` | 3 | warning | P99 > 2s | เล่ม 3 |
| `ServiceDown` | 3 | critical | `up == 0` (2m) | เล่ม 3 |
| `KafkaConsumerLagGrowing` | 5 | warning | deriv(lag) > 10 + lag > 1000 | เล่ม 5 |
| `KafkaUnderReplicatedPartitions` | 5 | critical | URP > 0 (2m) | เล่ม 5 |
| `RedisHighMemoryUsage` | 5 | warning | Memory > 85% | เล่ม 5 |
| `RedisLowHitRate` | 5 | warning | Hit Rate < 80% (15m) | เล่ม 5 |
| `VectorDBIndexedRatioLow` | 6 | warning | Indexed Ratio < 0.95 | เล่ม 6 |
| `RAGLowRecall` | 6 | warning | Recall@K < 0.9 (1h) | เล่ม 6 |
| `RAGHighHallucinationRate` | 6 | critical | Hallucination > 5% | เล่ม 6 |
| `CRMApiLimitNearFull` | 7 | warning | API Usage > 80% | เล่ม 7 |
| `CRMIntegrationFailure` | 7 | warning | Success < 99% | เล่ม 7 |
| `PostgreSQLHighConnections` | 9 | critical | Conn > 85% | เล่ม 9 |
| `PostgreSQLReplicationLag` | 9 | critical | Lag > 30s | เล่ม 9 |
| `PostgreSQLReplicationSlotLag` | 9 | warning | WAL > 1GB | เล่ม 9 |
| `OracleTablespaceHigh` | 9 | warning | Tablespace > 85% | เล่ม 9 |
| `MSSQLDeadlock` | 9 | warning | Deadlock > 0 | เล่ม 9 |
| `MongoDBReplicationLag` | 9 | critical | Lag > 10s | เล่ม 9 |

### F.3 SLO Catalog

| Service | SLI | SLO | Error Budget |
|---|---|---|---|
| API Gateway | Availability | 99.9% | 43m/เดือน |
| API Gateway | Latency (P99) | < 500ms | 99% ของ requests |
| Database | Availability | 99.95% | 22m/เดือน |
| Kafka | Consumer Lag | < 1000 | 99% ของเวลา |
| Redis | Hit Rate | > 80% | 99% ของเวลา |
| CRM | API Limit | < 80% | 100% ของเวลา |
| RAG | Faithfulness | > 0.9 | 99% ของเวลา |

---

## G. Runbook & Template Index — ดัชนี Runbook และ Template

### G.1 Incident Playbooks

| Playbook | เล่ม | สถานการณ์ |
|---|---|---|
| Playbook A: Alert ไม่มา | 3 | No Alert Firing |
| Playbook B: Alert ท่วม | 3 | Alert Storm |
| Playbook C: Metrics หาย | 3 | Grafana No Data |
| Playbook D: Alertmanager CrashLoop | 3 | AM Down |
| Playbook A: Forensic Investigation | 4 | Incident Timeline |
| Playbook B: Log ไม่เข้า | 4 | Pipeline Broken |
| Playbook C: Disk เต็ม (ELK) | 4 | Retention Issue |
| Playbook D: InfluxDB Remote Write | 4 | Long-term Storage |
| Playbook A: Kafka Consumer Lag | 5 | Pipeline ติดขัด |
| Playbook B: Under-Replicated | 5 | Data Loss Risk |
| Playbook C: Redis Memory เต็ม | 5 | Eviction Storm |
| Playbook D: Redis Hit Rate ต่ำ | 5 | Cache ไม่ทำงาน |
| Playbook E: Redis Replication Lag | 5 | Replica Lag |
| Playbook A: Hallucination สูง | 6 | RAG Quality |
| Playbook B: RetrievalLatencyHigh | 6 | Vector DB ช้า |
| Playbook C: RAGLowRecall | 6 | Retrieval ตก |
| Playbook D: Empty Results | 6 | Retrieve ไม่ได้ |
| Playbook A: CRM Outage | 7 | Salesforce Down |
| Playbook B: API Limit Exhausted | 7 | 403 REQUEST_LIMIT |
| Playbook C: Integration Failure | 7 | Sync ค้าง |
| Playbook D: Page Load ช้า | 7 | UX ตก |
| Playbook E: Storage ใกล้เต็ม | 7 | Storage |
| Playbook A: Domain Logic Bug | 8 | Invariant หลุด |
| Playbook B: Layer ทะลุ | 8 | Import ผิด |
| Playbook C: Performance ตก | 8 | App ช้า |
| Playbook D: Event ไม่ Publish | 8 | Event หาย |
| Playbook A: Connection Saturation | 9 | ทุก DB |
| Playbook B: Replication Lag | 9 | PG/Mongo/MSSQL |
| Playbook C: Disk Full | 9 | WAL/Redo/Oplog |
| Playbook D: Deadlock/Blocking | 9 | PG/MSSQL |
| Playbook E: Slow Query | 9 | ทุก DB |
| Playbook A: Outbox ค้าง | 10 | Event ไม่ถึง Kafka |
| Playbook B: Duplicate Processing | 10 | Idempotency |
| Playbook C: Saga ค้าง | 10 | Compensation |
| Playbook D: Cache Stampede | 10 | Cache Miss |

### G.2 Runbooks (Operational)

| Runbook | เล่ม | ใช้เมื่อ |
|---|---|---|
| Replay Failed Events | 10 | Outbox ค้าง |
| Cache Warm-up | 10 | หลัง restart / cold start |
| Outbox Table Cleanup | 10 | Table โต |
| Backup / Restore (PostgreSQL) | 9 | Disaster Recovery |
| Backup / Restore (Oracle) | 9 | Disaster Recovery |
| Backup / Restore (MSSQL) | 9 | Disaster Recovery |
| Backup / Restore (MongoDB) | 9 | Disaster Recovery |
| pg_drop_replication_slot | 9 | Inactive slot |
| VACUUM FREEZE | 9 | Wraparound |
| Kafka Reassign Partitions | 5 | Broker ตายถาวร |

### G.3 Templates

| Template | เล่ม | ใช้เมื่อ |
|---|---|---|
| PSR Report | 1 | หลัง Incident |
| RCA 5 Whys Worksheet | 1 | หา Root Cause |
| KPI Scorecard (SMART) | 1 | ตั้ง KPI |
| Decision Tree (Pull/Push) | 1 | เลือก Framework |
| `prometheus.yml` | 3 | ติดตั้ง Prometheus |
| `alertmanager.yml` | 3 | ติดตั้ง Alertmanager |
| `filebeat.yml` | 4 | ติดตั้ง Filebeat |
| `logstash.conf` | 4 | ติดตั้ง Logstash |
| ILM Policy | 4 | Elasticsearch Retention |
| `kafka_exporter` Compose | 5 | Kafka Monitoring |
| `redis_exporter` Compose | 5 | Redis Monitoring |
| `crm_limits_exporter.py` | 7 | CRM Custom Exporter |
| `postgres_exporter` Compose | 9 | PostgreSQL Monitoring |
| `oracledb_exporter` Compose | 9 | Oracle Monitoring |
| `mongodb_exporter` Compose | 9 | MongoDB Monitoring |
| Cache-Aside (Python/Go/TS) | 10 | Cache Implementation |
| Outbox (Python/Go) | 10 | Outbox Pattern |
| Idempotent Consumer | 10 | Kafka Consumer |
| Saga Orchestration | 10 | Distributed Transaction |

---

## H. Version Control Guide — การจัดการเวอร์ชันเอกสาร

### H.1 Versioning Scheme (Semantic Versioning)

ใช้ **SemVer** สำหรับเอกสาร:

```
MAJOR.MINOR.PATCH
  │     │     │
  │     │     └─ แก้ Typo, ปรับถ้อยคำ (ไม่กระทบเนื้อหา)
  │     └─ เพิ่มหัวข้อใหม่, ปรับปรุงเนื้อหา (Backward-compatible)
  └─ เปลี่ยนโครงสร้าง, ลบหัวข้อ, เปลี่ยน Tool version หลัก (Breaking)
```

**ตัวอย่าง:**

| Version | การเปลี่ยนแปลง |
|---|---|
| `1.0.0` | เผยแพร่ครั้งแรก |
| `1.1.0` | เพิ่มหัวข้อ "Redis Replication Lag" |
| `1.1.1` | แก้ Typo ใน PromQL |
| `2.0.0` | เปลี่ยน Prometheus version, ลบหัวข้อเก่า |

### H.2 Metadata ของแต่ละเล่ม (Front Matter)

ทุกเล่มต้องมี Metadata นี้ที่ด้านบน:

```yaml
---
title: "เล่ม 3: Application Metrics & Metrics Platform"
version: "1.0.0"
status: "Ready for Review"   # Draft | Ready for Review | Approved | Deprecated
owner: "SRE Team"
reviewers:
  - "Tech Lead A"
  - "SRE Lead B"
created: "2025-01-15"
last_updated: "2025-01-20"
next_review: "2025-04-15"
changelog: "CHANGELOG-03.md"
dependencies:
  hard: ["1", "2"]
  soft: []
---
```

### H.3 Changelog Format

ทุกเล่มมี `CHANGELOG-XX.md` แยก:

```markdown
# Changelog — เล่ม 3

## [1.1.0] — 2025-01-20
### Added
- หัวข้อ 3.10 Alertmanager: เพิ่ม Inhibition rule สำหรับ ServiceDown
- Template Dashboard: เพิ่ม panel Apdex

### Changed
- PromQL: เปลี่ยน `avg()` เป็น `histogram_quantile(0.99, ...)` ใน panel Latency
- Alert Rules: เพิ่ม `for: 10m` ใน HighLatencyP99 (ลด noise)

### Fixed
- แก้ Typo ใน `alertmanager.yml` (routing_key → routing_key_file)

## [1.0.0] — 2025-01-15
### Added
- เผยแพร่ครั้งแรก
```

### H.4 Branching Strategy (Git)

```
main ─────●─────────────●─────────────●─────▶
          │             │             │
          │  PR #123    │  PR #145    │
          │  (แก้เล่ม 3) │  (แก้เล่ม 5) │
          │             │             │
        feature/       feature/       feature/
        fix-3-alert    fix-5-lag      add-11-glossary
```

**กฎ:**

- `main` = Production (Approved เท่านั้น)
- `feature/*` = การแก้ไข (ต้องผ่าน PR)
- `hotfix/*` = แก้ฉุกเฉิน (merge ตรงเข้า `main` + tag)
- ทุก PR ต้องมี **1 Reviewer** (2 สำหรับ Breaking Change)

### H.5 Git Commit Convention

```
type(scope): subject

body (optional)

footer (optional)
```

**Type:** `feat`, `fix`, `docs`, `refactor`, `chore`

**ตัวอย่าง:**

```
docs(vol-3): add inhibition rule for ServiceDown

- เพิ่ม inhibition rule ใน alertmanager.yml
- อัปเดต Playbook B (Alert Storm)
- Fix typo ใน PromQL

Closes #123
```

### H.6 Release Process (ขั้นตอนการ Release)

| ขั้น | ผู้รับผิดชอบ | สิ่งที่ทำ |
|:---:|---|---|
| 1 | Author | สร้าง PR + อัปเดต CHANGELOG |
| 2 | Reviewer | ตรวจเนื้อหา, รัน Test (ถ้ามี) |
| 3 | Owner | Approve PR, Merge เข้า `main` |
| 4 | CI/CD | Build (ถ้ามี), Deploy |
| 5 | Owner | Tag version (`v3.1.0`), อัปเดต Master Index (เล่ม 11) |
| 6 | Owner | Announce ในทีม |

### H.7 Deprecation Policy

เมื่อหัวข้อ/เล่มเลิกใช้:

1. เพิ่ม Metadata `status: "Deprecated"` + `deprecated_date`
2. ใส่ **Warning Box** ที่ด้านบน: `> ⚠️ DEPRECATED: ใช้ เล่ม X แทน`
3. เก็บไว้อ่านได้ 6 เดือน → ย้ายไป `archive/`
4. อัปเดต Master Index (เล่ม 11)

---

## I. Contribution Guide — การมีส่วนร่วม

### I.1 บทบาทและความรับผิดชอบ

| บทบาท | หน้าที่ | สิทธิ์ |
|---|---|---|
| **Author** | เขียน/แก้ไขเนื้อหา | สร้าง PR |
| **Reviewer** | ตรวจเนื้อหา, ความถูกต้อง | Comment, Request Change |
| **Owner** | Approve, Merge, Tag version | Merge, Release |
| **Maintainer** | ดูแลโครงสร้างรวม (เล่ม 11) | แก้ Master Index, Glossary |

### I.2 Reviewer Checklist

ก่อน Approve PR ต้องตรวจ:

- [ ] **เนื้อหาถูกต้อง** — Technical Fact ถูกต้อง
- [ ] **ไม่มีเนื้อหาซ้ำ** — ถ้าซ้ำ ต้องมี Cross-Reference (ไม่ copy)
- [ ] **คำศัพท์ตรงกับ Glossary** (เล่ม 11) — ถ้าเพิ่มคำใหม่ ต้องอัปเดต Glossary
- [ ] **Tool Version ตรงกับ Version Matrix** (เล่ม 11)
- [ ] **Dependency ถูกต้อง** — ระบุเล่มที่ต้องอ่านก่อน
- [ ] **Code ทำงานได้** — ถ้าเป็น Code Template ต้อง Test
- [ ] **มี Playbook/Runbook** — ถ้าเป็นหัวข้อ Incident
- [ ] **CHANGELOG อัปเดต**
- [ ] **Metadata ครบ** (version, owner, reviewers, last_updated)
- [ ] **ไม่มี Sensitive Data** — password, token, IP ภายใน

### I.3 การเพิ่มหัวข้อใหม่ (Workflow)

```
1. ตรวจสอบว่ามีอยู่แล้วหรือไม่ (Master Index)
   ↓
2. ระบุเล่มที่เหมาะสม (Role-based, Dependency)
   ↓
3. เขียนตามโครงสร้าง 15 องค์ประกอบ (เล่ม 1 หัวข้อ 6)
   ↓
4. อัปเดต Glossary (ถ้ามีคำใหม่)
   ↓
5. อัปเดต Cross-Reference Matrix (ถ้าซ้ำกับเล่มอื่น)
   ↓
6. อัปเดต Master Index (เล่ม 11)
   ↓
7. สร้าง PR + CHANGELOG
   ↓
8. Review → Merge → Tag → Announce
```

### I.4 การแก้ไขเนื้อหาที่มีอยู่ (Workflow)

```
1. ระบุ Version ที่จะเปลี่ยน (PATCH/MINOR/MAJOR)
   ↓
2. แก้เนื้อหา
   ↓
3. อัปเดต CHANGELOG
   ↓
4. อัปเดต last_updated
   ↓
5. สร้าง PR
   ↓
6. Review → Merge → Tag
```

### I.5 Review Process (SLA)

| ประเภท PR | Reviewer | SLA |
|---|---|---|
| **Typo / ถ้อยคำ** | 1 | 2 วัน |
| **เนื้อหาใหม่** | 1 (2 ถ้า Breaking) | 5 วัน |
| **Breaking Change** | 2 (Owner + Maintainer) | 10 วัน |
| **Hotfix** | 1 (Owner) | 24 ชั่วโมง |

### I.6 Communication Channels

| ช่องทาง | ใช้เมื่อ |
|---|---|
| **GitHub Issues** | แจ้งปัญหา / เสนอหัวข้อ |
| **GitHub PR** | ส่งการแก้ไข |
| **Slack #docs** | ถาม-ตอบ, Announce |
| **Monthly Meeting** | Review สรุปรายเดือน |

---

## J. Maintenance Calendar — ปฏิทินบำรุงรักษา

### J.1 รายปี (Annual)

| เดือน | กิจกรรม | ผู้รับผิดชอบ |
|:---:|---|---|
| **ม.ค.** | ทบทวน Tool Version Matrix + Upgrade LTS | Owner |
| **มี.ค.** | ทบทวน SLO Catalog | SRE Lead |
| **เม.ย.** | ทบทวน Alert Rules (ลบ Noise) | SRE Team |
| **มิ.ย.** | ทบทวน Glossary + Master Index | Maintainer |
| **ก.ค.** | Upgrade Stable Tools (Kafka, Redis) | Owner |
| **ก.ย.** | ทบทวน Incident Playbooks (จาก Incident 6 เดือน) | SRE Team |
| **ต.ค.** | อัปเดต Golden Set (RAG) | AI Team |
| **ธ.ค.** | Annual Review — สรุปทั้งชุด | Maintainer |

### J.2 ราย Quarter (Quarterly)

| สัปดาห์ | กิจกรรม |
|:---:|---|
| **สัปดาห์ 1** | Review Metrics / Alert ที่ fire บ่อย (Noise) |
| **สัปดาห์ 2** | อัปเดต Runbook จาก Incident ล่าสุด |
| **สัปดาห์ 3** | Upgrade Fast-moving Tools (Exporter) |
| **สัปดาห์ 4** | สรุป Report + วางแผน Quarter ถัดไป |

### J.3 รายเดือน (Monthly)

| วัน | กิจกรรม |
|:---:|---|
| **วันที่ 1** | ตรวจ CHANGELOG ทุกเล่ม |
| **วันที่ 15** | Review PR ที่ค้าง |
| **วันสุดท้าย** | สรุป Metrics (MTTR, MTTD) |

### J.4 Post-Incident (ทันที)

หลัง Incident ทุกครั้ง:

1. **ภายใน 24 ชม.** — เขียน PSR Report (เล่ม 1)
2. **ภายใน 1 สัปดาห์** — RCA 5 Whys + อัปเดต Playbook
3. **ภายใน 2 สัปดาห์** — อัปเดต Alert Rules (ถ้าจำเป็น)
4. **ภายใน 1 เดือน** — Review ว่า Incident นี้ควรแก้เล่มไหน

---

## K. Quick Reference Card — บัตรอ้างอิงด่วน

### K.1 PromQL Cheat Sheet

```promql
# Rate (ต่อวินาที)
rate(metric_total[5m])

# Increase (ต่อช่วง)
increase(metric_total[1h])

# Percentile (จาก Histogram)
histogram_quantile(0.99, sum by (le) (rate(metric_bucket[5m])))

# Ratio (%)
sum(rate(metric_total{status=~"5.."}[5m])) / sum(rate(metric_total[5m])) * 100

# Derivative (การเปลี่ยนแปลง)
deriv(gauge_metric[10m])

# Top K
topk(10, metric)

# Absent (หาค่าที่หาย)
absent(metric) == 1

# Predict (ทำนาย 4 ชม.ข้างหน้า)
predict_linear(metric[1h], 4*3600)
```

### K.2 SQL Diagnostic Cheat Sheet

```sql
-- PostgreSQL: Top Slow Query
SELECT left(query, 80), calls, total_exec_time
FROM pg_stat_statements ORDER BY total_exec_time DESC LIMIT 10;

-- PostgreSQL: Blocking
SELECT pid, pg_blocking_pids(pid) FROM pg_stat_activity WHERE cardinality(pg_blocking_pids(pid)) > 0;

-- Oracle: Tablespace
SELECT tablespace_name, ROUND(used_percent, 2) FROM dba_tablespace_usage_metrics ORDER BY used_percent DESC;

-- MSSQL: Blocking
SELECT session_id, blocking_session_id, wait_time/1000.0 AS wait_s FROM sys.dm_exec_requests WHERE blocking_session_id > 0;

-- MongoDB: Replication Lag
rs.status().members.forEach(m => print(m.name, m.optimeDate));
```

### K.3 KQL Cheat Sheet

```kql
# Error ล่าสุด
level: "ERROR" and @timestamp >= now-1h

# ตาม trace_id
trace_id: "abc123"

# ตาม service
service: "order-api" and level: "ERROR"

# Slow request
http.duration_ms > 2000

# Exists
error.type: *
```

### K.4 Emergency Contacts Template

```markdown
| บทบาท | ชื่อ | เบอร์ | Slack |
|---|---|---|---|
| SRE On-call | (ตามเวร) | +66-XX-XXX-XXXX | @sre-oncall |
| DBA On-call | (ตามเวร) | +66-XX-XXX-XXXX | @dba-oncall |
| CRM Admin | (ตามเวร) | +66-XX-XXX-XXXX | @crm-admin |
| AI Platform | (ตามเวร) | +66-XX-XXX-XXXX | @ai-oncall |
| Escalation (Manager) | (ตามเวร) | +66-XX-XXX-XXXX | @eng-manager |
| Salesforce Support | — | 1-800-XXX-XXXX | — |
| AWS Support | — | (Console) | — |
```

---

## Workflow (อ้างอิงเล่ม 1 + Governance Workflow)

### อ้างอิง Workflow หลักจากเล่ม 1

| Workflow | ใช้ในเล่มนี้เมื่อ |
|---|---|
| **PSR** | เขียนรายงานหลัง Incident ที่กระทบเอกสาร |
| **RCA 5 Whys** | หา Root Cause ของปัญหา Version / เนื้อหาซ้ำ |
| **KPI SMART** | ตั้ง KPI ของเอกสาร (เช่น Review SLA < 5d, Glossary Coverage > 95%) |

→ Template เต็มอยู่ใน **เล่ม 1 หัวข้อ 4**

### Governance Workflow เฉพาะเล่ม 11

#### Workflow A: Annual Review (รายปี)

```
1. Owner ทบทวน Tool Version Matrix
   ↓
2. ระบุ Tool ที่ต้อง Upgrade
   ↓
3. ทดสอบใน Staging
   ↓
4. อัปเดตเล่มที่เกี่ยวข้อง + CHANGELOG
   ↓
5. Merge + Tag MAJOR version (ถ้า Breaking)
   ↓
6. Announce
```

#### Workflow B: Post-Incident Document Update

```
1. Incident เกิดขึ้น → PSR Report (เล่ม 1)
   ↓
2. ระบุว่า Incident เกี่ยวกับเล่มไหน
   ↓
3. อัปเดต Playbook / Runbook ในเล่มนั้น
   ↓
4. อัปเดต Alert Rules (ถ้าจำเป็น)
   ↓
5. อัปเดต CHANGELOG + Tag MINOR
   ↓
6. ถ้าเป็น Pattern ใหม่ → เพิ่มใน Glossary (เล่ม 11)
```

#### Workflow C: Glossary Update

```
1. มีคำใหม่ / คำที่ใช้ต่างกัน
   ↓
2. เพิ่มใน Glossary (เล่ม 11)
   ↓
3. ระบุเล่มที่นิยามครั้งแรก + เล่มที่ใช้งาน
   ↓
4. อัปเดต Cross-Reference Matrix (ถ้าซ้ำ)
   ↓
5. อัปเดตเล่มที่เกี่ยวข้อง (ถ้าต้องใช้คำมาตรฐาน)
```

---

## สรุป (ประโยชน์, ข้อดี, ข้อเสีย, ข้อห้าม)

### ประโยชน์ของเล่ม 11

- **Single Source of Reference:** ทุกอย่างอยู่ที่เดียว — ค้นหาง่าย
- **Glossary กลาง:** คำศัพท์ตรงกันทั้งองค์กร
- **Version Control ชัดเจน:** ทุกเล่มมี Changelog + Owner
- **Review Process มาตรฐาน:** Reviewer Checklist ครบ
- **Maintenance Calendar:** วางแผนรายปีได้

### ข้อดี

| ด้าน | ผลลัพธ์ |
|---|---|
| **Searchability** | ค้นหาหัวข้อได้ < 30 วินาที |
| **Consistency** | คำศัพท์ / Version ตรงกัน |
| **Quality** | Review Checklist ลดข้อผิดพลาด |
| **Maintainability** | Update ตาม Calendar |
| **Onboarding** | ผู้อ่านใหม่เริ่มจาก Reading Paths |

### ข้อเสีย / ข้อจำกัด

- **ต้อง Maintain:** ถ้าไม่ Update จะกลายเป็นข้อมูลเก่า
- **Overhead:** ทุก PR ต้องอัปเดต Metadata + CHANGELOG
- **Single Point of Failure:** ถ้า Maintainer หยุด → เอกสารไม่ Update
- **ไม่ใช่เนื้อหาใหม่:** ผู้อ่านที่ต้องการเรียนรู้ต้องอ่านเล่ม 1–10

### ข้อห้าม (สรุป)

1. ❌ **Merge PR โดยไม่อัปเดต CHANGELOG**
2. ❌ **เพิ่มคำใหม่โดยไม่อัปเดต Glossary**
3. ❌ **แก้เนื้อหาโดยไม่ระบุ Version**
4. ❌ **Copy เนื้อหาข้ามเล่ม** — ใช้ Cross-Reference
5. ❌ **ใช้ Tool Version ไม่ตรงกับ Version Matrix**
6. ❌ **ลืม Review ตาม Calendar** — เอกสารจะเก่า
7. ❌ **ไม่มี Owner** — ทุกเล่มต้องมี Owner ชัดเจน
8. ❌ **Merge โดยไม่มี Reviewer** — อย่างน้อย 1 คน
9. ❌ **เก็บ Sensitive Data ในเอกสาร** — password, token, IP ภายใน
10. ❌ **ลบหัวข้อโดยไม่ Deprecate** — ต้องมี Warning + Archive

---

## เส้นทางอ่านต่อ

| ถ้าคุณเป็น | อ่านต่อ |
|---|---|
| ผู้อ่านใหม่ | → กลับไป **เล่ม 1** แล้วเลือก Reading Path (D.1) |
| Author / Contributor | → อ่าน **H, I** (Version Control + Contribution) |
| Maintainer | → อ่าน **J** (Maintenance Calendar) + ตั้ง Calendar |
| Tech Lead | → ใช้ **F** (Metrics/Alert Catalog) ตั้ง SLO |

---

> **เวอร์ชันเอกสาร:** 1.0
> **ผู้รับผิดชอบ:** Maintainer Team + SRE Team
> **ปรับปรุงล่าสุด:** ตามรอบ Quarter
> **สถานะ:** ✅ Ready for Review
> **ชุดเอกสาร:** ครบ 11 เล่ม (1–11)

---
 