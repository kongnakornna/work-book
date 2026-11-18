# 🏛️ สถาปัตยกรรมระบบ Unified AI-Enabled Event-Driven Platform  

> **พิมพ์เขียวสถาปัตยกรรมแบบครบวงจร** — ผสาน ERP + IoT + LLM + Deep Learning + Vector Database (pgvector) เข้าเป็นระบบเดียวที่ **ยืดหยุ่น (Elastic), บำรุงรักษาง่าย (Maintainable), ต่อยอดได้ในอนาคต (Extensible)** ด้วยหลัก **Event-Driven + DDD + Clean Architecture + Modular Monolith → Microservices**

---

# 📑 สารบัญ

1. [บทสรุปผู้บริหาร (Executive Summary)](#1-บทสรุปผู้บริหาร-executive-summary)
2. [หลักการออกแบบ 12 ข้อ (Design Principles)](#2-หลักการออกแบบ-12-ข้อ-design-principles)
3. [ภาพรวมสถาปัตยกรรม (Overall Architecture)](#3-ภาพรวมสถาปัตยกรรม-overall-architecture)
4. [Technology Stack](#4-technology-stack)
5. [Domain-Driven Design — Bounded Contexts](#5-domain-driven-design--bounded-contexts)
6. [โครงสร้าง Module (Clean Architecture + DDD)](#6-โครงสร้าง-module-clean-architecture--ddd)
7. [สถาปัตยกรรมแบบ Event-Driven](#7-สถาปัตยกรรมแบบ-event-driven)
8. [AI / LLM / Deep Learning Layer](#8-ai--llm--deep-learning-layer)
9. [Vector Database & pgvector Integration](#9-vector-database--pgvector-integration)
10. [Data Architecture (SQL + Vector + Time-Series + Object + Cache)](#10-data-architecture-sql--vector--time-series--object--cache)
11. [API Design & Communication Patterns](#11-api-design--communication-patterns)
12. [Observability & Monitoring](#12-observability--monitoring)
13. [Security & Compliance](#13-security--compliance)
14. [Deployment Architecture](#14-deployment-architecture)
15. [Roadmap & Migration Path](#15-roadmap--migration-path)
16. [Templates & Checklists](#16-templates--checklists)
17. [ข้อควรระวัง/ข้อห้าม/แนวทางแก้ปัญหา](#17-ข้อควรระวังข้อห้ามแนวทางแก้ปัญหา)

---

# 1. บทสรุปผู้บริหาร (Executive Summary)

## 1.1 วิสัยทัศน์ (Vision)

สร้าง **ระบบ Platform เดียว** ที่รองรับธุรกิจครบวงจร (ERP + IoT + AI) โดยแยกส่วนประกอบเป็น **Bounded Contexts** ที่ทำงานแบบ **Event-Driven** เพื่อให้:
- ✅ **Elastic** — ขยายเฉพาะส่วนที่ต้องการ ไม่ต้อง Scale ทั้งระบบ
- ✅ **Maintainable** — แก้ Module หนึ่งไม่กระทบ Module อื่น
- ✅ **Extensible** — เพิ่ม Module/Feature ใหม่ได้โดยไม่ต้อง Rewrite
- ✅ **AI-Ready** — ฝัง LLM/RAG/Agent และ Deep Learning ได้ในทุกจุดของธุรกิจ

## 1.2 หลักการหลัก 4 ข้อ (Core Pillars)

```
┌──────────────────────────────────────────────────────────────┐
│  1. DOMAIN-DRIVEN  ─► ออกแบบตามธุรกิจ ไม่ใช่ตามเทคโนโลยี    │
│  2. EVENT-DRIVEN   ─► ทุกการเปลี่ยนแปลงคือ Event ที่ Replay ได้│
│  3. AI-FIRST       ─► LLM/RAG/Agent ฝังเป็น citizens ชั้นแรก │
│  4. MODULAR        ─► 1 Context = 1 Module = 1 Deploy Unit   │
└──────────────────────────────────────────────────────────────┘
```

## 1.3 ขอบเขต (Scope)

**รวมทุกส่วนจากไฟล์ต้นทาง:**
- ERP 55 Modules (Money/Goods/Data Paths)
- IoT Notification System (Sensor + IO Device + Multi-channel)
- YOLO/MLOps Module (Dataset/Training/Prediction/Metrics)
- FastAPI Clean Architecture Template
- PostgreSQL Production Handbook (120 บท)
- **เพิ่มใหม่:** LLM Gateway, RAG Pipeline, Vector Store (pgvector), Agent Orchestrator, Deep Learning Serving, Document Intelligence

---

# 2. หลักการออกแบบ 12 ข้อ (Design Principles)

| # | หลักการ | คำอธิบาย | ตัวอย่างในระบบ |
|---|---|---|---|
| 1 | **Money is Domain Invariant** | ใช้ Decimal + Transaction + Read-Back | `Money` VO ใน Invoice |
| 2 | **Idempotency Everywhere** | ทุก Mutating API มี Idempotency-Key | `POST /invoice` + `Idempotency-Key` |
| 3 | **Append-Only Audit** | ทุกการกระทำเขียน Audit Log | `audit_events` table |
| 4 | **Schema-Per-Tenant** | แยก Company ที่ระดับ Schema | `tenant_acme.bills` |
| 5 | **Outbox for External Sync** | เขียน DB ก่อน แล้ว sync ผ่าน Outbox | `outbox_events` table |
| 6 | **Reversible Ledger** | ไม่ลบรายการบัญชี ใช้ Reversal | `LedgerEntry` + `ReversalEntry` |
| 7 | **Observable by Default** | ทุก Module มี Metric/Log/Trace | Prometheus + Loki + Tempo |
| 8 | **Event-Driven for Analytics** | Business Event วิ่งผ่าน Kafka | `InvoiceIssued`, `StockLow` |
| 9 | **Lot Traceability** | ทุก Lot ตรวจย้อนได้ทั้งสองทาง | `TraceEvent` forward/backward |
| 10 | **Config over Code** | VAT/waste%/pricing เป็น Config | `config` table + ENV |
| 11 | **AI as Citizen** | LLM/Vector/Agent เป็น First-Class Module | `llm_gateway`, `rag`, `agent` |
| 12 | **Vector is Data** | pgvector อยู่ใน PostgreSQL เดียวกัน | `document_chunks` + `embedding` |

---

# 3. ภาพรวมสถาปัตยกรรม (Overall Architecture)

## 3.1 Layered View — 6 ชั้น

```
┌──────────────────────────────────────────────────────────────────────┐
│ L6  PRESENTATION                                                     │
│   Web (Angular/React) │ Mobile │ LINE │ Dashboard │ AI Chat UI       │
├──────────────────────────────────────────────────────────────────────┤
│ L5  API GATEWAY & EDGE                                               │
│   Kong/Traefik │ Rate Limit │ JWT/OAuth2 │ WAF │ CDN                 │
├──────────────────────────────────────────────────────────────────────┤
│ L4  APPLICATION SERVICES (Bounded Contexts)                          │
│   MoneyPath │ GoodsPath │ Ops │ Intelligence │ AI │ IoT │ Admin      │
├──────────────────────────────────────────────────────────────────────┤
│ L3  DOMAIN LAYER (Pure Business Logic)                               │
│   Entities │ Value Objects │ Aggregates │ Domain Events │ Policies   │
├──────────────────────────────────────────────────────────────────────┤
│ L2  INFRASTRUCTURE (Adapters)                                        │
│   PostgreSQL │ pgvector │ Kafka │ Redis │ MinIO │ MQTT │ FastAPI-AI  │
├──────────────────────────────────────────────────────────────────────┤
│ L1  DATA & AI STORAGE                                                │
│   OLTP (PG) │ Vector (pgvector) │ Time-Series (Influx) │ Object │ KV │
└──────────────────────────────────────────────────────────────────────┘
```

## 3.2 Runtime View — 8 กลุ่มบริการ

```
┌─────────────────────────────────────────────────────────────────────┐
│                        EXTERNAL CLIENTS                             │
│   ERP UI │ Mobile App │ LINE Bot │ AI Chat │ Dashboards │ Devices   │
└───────────────────────────┬─────────────────────────────────────────┘
                            │
                    ┌───────▼────────┐
                    │  API Gateway   │  (Kong/Traefik)
                    │  + JWT + Rate  │
                    └───────┬────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│  Core ERP     │  │  AI Services  │  │  IoT Services │
│  (FastAPI)    │  │  (FastAPI)    │  │  (FastAPI)    │
│  Money/Goods  │  │  LLM/RAG/ML   │  │  MQTT/WS      │
└───────┬───────┘  └───────┬───────┘  └───────┬───────┘
        │                  │                  │
        └──────────┬───────┴──────────────────┘
                   │
        ┌──────────▼──────────┐
        │   EVENT BUS (Kafka) │
        │  + Outbox Pattern   │
        └──────────┬──────────┘
                   │
   ┌───────────────┼────────────────┐
   ▼               ▼                ▼
┌───────┐      ┌────────┐       ┌────────┐
│ PG    │      │ pgvector│      │ Influx │
│ OLTP  │      │ Vector  │      │ TSDB   │
└───────┘      └────────┘       └────────┘
   │
   ▼
┌──────────────────────────────────────────┐
│ OBSERVABILITY: Prometheus + Loki + Tempo │
│ + Grafana + Alertmanager                 │
└──────────────────────────────────────────┘
```

## 3.3 Event Topology (Kafka Topics)

```
┌────────────────────────────────────────────────────────────┐
│                       KAFKA CLUSTER                        │
├────────────────────────────────────────────────────────────┤
│  DOMAIN EVENTS (DDD)                                       │
│    money.invoice.issued                                    │
│    money.payment.matched                                   │
│    goods.stock.posted                                      │
│    goods.lot.traced                                        │
│    iot.sensor.reading                                      │
│    iot.alarm.triggered                                     │
│    ai.embedding.generated                                  │
│    ai.prediction.served                                    │
│    ai.llm.completion.generated                             │
│                                                            │
│  INTEGRATION EVENTS (Cross-Context)                        │
│    integration.order.to.invoice                            │
│    integration.stock.to.reorder                            │
│    integration.alarm.to.notification                       │
│                                                            │
│  ANALYTICS EVENTS                                          │
│    analytics.kpi.updated                                   │
│    analytics.drift.detected                                │
│                                                            │
│  DEAD LETTER QUEUE                                         │
│    dlq.all                                                 │
└────────────────────────────────────────────────────────────┘
```

---

# 4. Technology Stack

## 4.1 Core Stack

| Layer | Technology | Version | Purpose |
|---|---|---|---|
| **Language** | Python | 3.11+ | Backend + AI |
| **Web Framework** | FastAPI | 0.115+ | REST API + WebSocket |
| **Validation** | Pydantic | v2 | Schema + DTO |
| **ORM** | SQLAlchemy | 2.0 async | PostgreSQL ORM |
| **Migration** | Alembic | 1.13+ | Schema versioning |
| **DI** | FastAPI `Depends` + `dependency-injector` | - | Dependency Injection |
| **Database** | PostgreSQL | 17+ | OLTP + Vector + JSONB |
| **Vector Extension** | pgvector | 0.7+ | Embedding storage + HNSW |
| **Time-Series** | InfluxDB / TimescaleDB | 3.x / PG ext | IoT + Metrics |
| **Cache** | Redis | 7+ | Cache + Cooldown + Pub/Sub |
| **Message Bus** | Apache Kafka | 3.7+ | Event streaming |
| **MQTT Broker** | Mosquitto / EMQX | 2.x | IoT device connectivity |
| **Object Storage** | MinIO / S3 | RELEASE.2025+ | Backup + Artifacts + Docs |
| **Auth** | JWT (Ed25519) + OAuth2 + OIDC | - | Authentication |
| **API Gateway** | Kong / Traefik | - | Routing + Rate limit + WAF |

## 4.2 AI / ML Stack

| Layer | Technology | Purpose |
|---|---|---|
| **LLM Provider** | OpenAI GPT-4o, Anthropic Claude, Ollama (local) | Text generation |
| **LLM SDK** | `openai`, `anthropic`, `tiktoken` | Client + token counting |
| **Embedding** | `text-embedding-3-small/large`, `bge-large`, `cohere embed-v3` | Vectorization |
| **RAG Framework** | LangChain, LlamaIndex | Pipeline orchestration |
| **Vector Store** | **pgvector** (HNSW/IVFFlat) | Production vector DB |
| **Deep Learning** | PyTorch, Ultralytics (YOLOv8), scikit-learn, XGBoost | Object detection, ML |
| **MLOps** | MLflow, Evidently (drift), Ray (training) | Experiment + Registry |
| **AI Serving** | FastAPI + vLLM / Ollama | LLM serving |
| **Speech/Audio** | Whisper, TTS (optional) | Voice channels |

## 4.3 Observability Stack

| Layer | Technology |
|---|---|
| **Metrics** | Prometheus + postgres_exporter + node_exporter |
| **Logs** | Loki / ELK + structlog + pgBadger |
| **Traces** | Tempo / Jaeger + OpenTelemetry |
| **Visualization** | Grafana |
| **Alerting** | Alertmanager → Slack / PagerDuty / Email / LINE |
| **AI Metrics** | Custom: token usage, latency, drift, hallucination score |

## 4.4 DevOps Stack

| Layer | Technology |
|---|---|
| **Containers** | Docker + Docker Compose |
| **Orchestration** | Kubernetes (K3s → EKS/GKE) |
| **CI/CD** | GitHub Actions / GitLab CI + Argo CD |
| **IaC** | Terraform + Helm |
| **Service Mesh** | Istio / Linkerd (optional) |
| **Secrets** | Vault / Sealed Secrets / K8s Secrets |

---

# 5. Domain-Driven Design — Bounded Contexts

## 5.1 Context Map — 15 Bounded Contexts

```
┌─────────────────────────────────────────────────────────────────┐
│                        CORE DOMAIN                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  Ordering    │  │  Pricing     │  │  AI Agent    │          │
│  │  (Core)      │  │  (Core)      │  │  (Core)      │          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│         │                 │                 │                  │
├─────────┼─────────────────┼─────────────────┼──────────────────┤
│         │    SUPPORTING DOMAIN              │                  │
│  ┌──────▼───────┐  ┌──────▼───────┐  ┌──────▼───────┐          │
│  │  Inventory   │  │  Payment     │  │  LLM Gateway │          │
│  │  (Supporting)│  │  (Supporting)│  │  (Supporting)│          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│         │                 │                 │                  │
│  ┌──────▼───────┐  ┌──────▼───────┐  ┌──────▼───────┐          │
│  │  Shipping    │  │  IoT/Alarm   │  │  RAG Pipeline│          │
│  │  (Supporting)│  │  (Supporting)│  │  (Supporting)│          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                       GENERIC DOMAIN                            │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐           │
│  │  Auth    │ │  Notify  │ │  Report  │ │  Audit   │           │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘           │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐                        │
│  │  Vector  │ │  Storage │ │  Config  │                        │
│  │  Store   │ │  (MinIO) │ │          │                        │
│  └──────────┘ └──────────┘ └──────────┘                        │
└─────────────────────────────────────────────────────────────────┘
```

## 5.2 Context Cards — 15 Contexts

### 5.2.1 Ordering (Core)
```
📦 Context: Ordering
🎯 Type: Core
📝 Responsibility: รับคำสั่งซื้อ, จัดลำดับ, สถานะ lifecycle
🗣️ Ubiquitous Language: Order, OrderLine, OrderStatus, Checkout
🔗 Relationships:
   - Upstream: Customer (Customer-Supplier)
   - Downstream: Payment, Inventory, Shipping (ACL)
   - Pattern: Publisher/Subscriber (Events)
```

### 5.2.2 Pricing (Core)
```
📦 Context: Pricing
🎯 Type: Core
📝 Responsibility: คำนวณราคา, โปรโมชัน, ส่วนลด, ภาษี
🗣️ Ubiquitous Language: Price, Discount, Promotion, Tax, Rule
🔗 Relationships:
   - Upstream: Product, Customer
   - Downstream: Ordering, Invoice
   - Pattern: Open Host Service (API)
```

### 5.2.3 AI Agent (Core) — **ใหม่**
```
📦 Context: AI Agent
🎯 Type: Core
📝 Responsibility: Orchestrate LLM + Tools + Memory + RAG
🗣️ Ubiquitous Language: Agent, Tool, Memory, Plan, ReAct
🔗 Relationships:
   - Upstream: LLM Gateway (ACL)
   - Downstream: RAG, Vector Store, Business Modules (ACL)
   - Pattern: Anti-Corruption Layer (Business API)
```

### 5.2.4 Inventory (Supporting)
```
📦 Context: Inventory
🎯 Type: Supporting
📝 Responsibility: Stock, Lot, Warehouse, Movement
🗣️ Ubiquitous Language: Stock, Lot, FEFO, Adjustment, CycleCount
🔗 Relationships:
   - Downstream: Ordering, Production, Shipping
   - Pattern: Event-Driven (StockPosted, StockLow)
```

### 5.2.5 Payment (Supporting)
```
📦 Context: Payment
🎯 Type: Supporting
📝 Responsibility: รับชำระ, จับคู่, คืนเงิน
🗣️ Ubiquitous Language: Payment, Match, Reversal, Gateway
🔗 Relationships:
   - Upstream: Invoice
   - Downstream: Ledger
   - Pattern: Saga Coordinator
```

### 5.2.6 LLM Gateway (Supporting) — **ใหม่**
```
📦 Context: LLM Gateway
🎯 Type: Supporting
📝 Responsibility: Unified provider abstraction (OpenAI/Anthropic/Ollama)
🗣️ Ubiquitous Language: Provider, Model, Completion, Token, Cost
🔗 Relationships:
   - Upstream: AI Agent, RAG, Chat
   - Downstream: OpenAI/Anthropic/Local
   - Pattern: Adapter + Circuit Breaker + Retry
```

### 5.2.7 IoT / Alarm (Supporting)
```
📦 Context: IoT / Alarm
🎯 Type: Supporting
📝 Responsibility: รับข้อมูล Sensor/IO, ตรวจ Threshold, Cooldown
🗣️ Ubiquitous Language: SensorReading, Alarm, Threshold, Cooldown
🔗 Relationships:
   - Upstream: MQTT Devices
   - Downstream: Notification, Dashboard, Automation
   - Pattern: Event-Driven (SensorReadingReceived)
```

### 5.2.8 RAG Pipeline (Supporting) — **ใหม่**
```
📦 Context: RAG
🎯 Type: Supporting
📝 Responsibility: Chunk → Embed → Retrieve → Rerank → Generate
🗣️ Ubiquitous Language: Chunk, Embedding, Retrieval, Reranker, Citation
🔗 Relationships:
   - Upstream: Vector Store, LLM Gateway
   - Downstream: AI Agent
   - Pattern: Pipeline Pattern
```

### 5.2.9 Shipping (Supporting)
```
📦 Context: Shipping
🎯 Type: Supporting
📝 Responsibility: จัดส่ง, POD, Cold-chain
🗣️ Ubiquitous Language: Shipment, POD, Carrier, Temp
🔗 Relationships:
   - Upstream: Ordering, Inventory
   - Downstream: Delivery
   - Pattern: Event-Driven
```

### 5.2.10 Auth (Generic)
```
📦 Context: Auth
🎯 Type: Generic
📝 Responsibility: Login, JWT, Refresh, API Key, OAuth2/OIDC
🗣️ Ubiquitous Language: User, Role, Token, Session
```

### 5.2.11 Notification (Generic)
```
📦 Context: Notification
🎯 Type: Generic
📝 Responsibility: Multi-channel delivery (Email/LINE/Discord/Telegram/SMS/WS)
🗣️ Ubiquitous Language: Channel, Template, Delivery, Receipt
```

### 5.2.12 Report (Generic)
```
📦 Context: Report
🎯 Type: Generic
📝 Responsibility: D/W/M/Q/Y reports, KPI, Export
🗣️ Ubiquitous Language: Report, Period, Aggregation, Export
```

### 5.2.13 Audit (Generic)
```
📦 Context: Audit
🎯 Type: Generic
📝 Responsibility: Append-only log, PSR, RCA
🗣️ Ubiquitous Language: Event, Actor, Action, Trace
```

### 5.2.14 Vector Store (Generic) — **ใหม่**
```
📦 Context: Vector Store
🎯 Type: Generic
📝 Responsibility: pgvector CRUD + Index (HNSW/IVFFlat) + Search
🗣️ Ubiquitous Language: Collection, Embedding, Similarity, HNSW
```

### 5.2.15 Storage (Generic)
```
📦 Context: Storage
🎯 Type: Generic
📝 Responsibility: Object store (MinIO/S3), File upload
🗣️ Ubiquitous Language: Bucket, Object, Presigned URL
```

## 5.3 Context Map Diagram (Mermaid)

```mermaid
graph TB
    subgraph Core
        Ordering[Ordering]
        Pricing[Pricing]
        AIAgent[AI Agent]
    end
    subgraph Supporting
        Inventory[Inventory]
        Payment[Payment]
        LLMGateway[LLM Gateway]
        RAG[RAG Pipeline]
        IoT[IoT/Alarm]
        Shipping[Shipping]
    end
    subgraph Generic
        Auth[Auth]
        Notify[Notification]
        Report[Report]
        Audit[Audit]
        Vector[Vector Store]
        Storage[Storage]
        Config[Config]
    end
    
    Ordering --> Pricing
    Ordering --> Payment
    Ordering --> Inventory
    Ordering --> Shipping
    Payment --> Inventory
    AIAgent --> LLMGateway
    AIAgent --> RAG
    RAG --> Vector
    RAG --> LLMGateway
    IoT --> Notify
    IoT --> Vector
    Notify --> Auth
    Report --> Ordering
    Report --> Inventory
    Audit --> Ordering
    Audit --> Payment
```

---

# 6. โครงสร้าง Module (Clean Architecture + DDD)

## 6.1 โครงสร้าง Monorepo — Top Level

```
unified-ai-platform/
├── pyproject.toml                    # Poetry / uv
├── docker-compose.yml
├── Makefile
├── README.md
├── .env.example
│
├── apps/                             # Deployable Services
│   ├── core-api/                     # ERP Core (FastAPI)
│   ├── ai-api/                       # AI/LLM/RAG/Agent (FastAPI)
│   ├── iot-api/                      # IoT + MQTT + WebSocket (FastAPI)
│   ├── worker/                       # Background workers (arq/celery)
│   └── dashboard/                    # Frontend (Angular/React)
│
├── packages/                         # Shared Python Packages
│   ├── shared_kernel/                # BaseEntity, Money, Result, Guard
│   ├── contracts/                    # Event schemas (Pydantic)
│   ├── infrastructure/               # DB, Kafka, Redis, MQTT clients
│   └── observability/                # Logging, Tracing, Metrics
│
├── modules/                          # 15 Bounded Contexts
│   ├── ordering/                     # Core
│   ├── pricing/                      # Core
│   ├── ai_agent/                     # Core
│   ├── inventory/                    # Supporting
│   ├── payment/                      # Supporting
│   ├── llm_gateway/                  # Supporting
│   ├── rag/                          # Supporting
│   ├── iot_alarm/                    # Supporting
│   ├── shipping/                     # Supporting
│   ├── auth/                         # Generic
│   ├── notification/                 # Generic
│   ├── report/                       # Generic
│   ├── audit/                        # Generic
│   ├── vector_store/                 # Generic
│   └── storage/                      # Generic
│
├── migrations/                       # Alembic (per-tenant)
├── tests/
│   ├── unit/
│   ├── integration/
│   ├── e2e/
│   └── load/
│
├── deploy/
│   ├── docker/
│   ├── k8s/
│   └── terraform/
│
└── scripts/
    ├── gen_module.py
    ├── seed.py
    └── check_boundaries.py
```

## 6.2 โครงสร้าง Module (4 Layers × 4 Files)

ทุก Module ใช้โครงสร้างนี้เหมือนกัน:

```
modules/{context}/
├── domain/                          # ชั้นในสุด — Pure Business Logic
│   ├── entities.py                  # @dataclass(frozen=True) + __post_init__
│   ├── value_objects.py             # Money, Email, Address, Embedding
│   ├── enums.py                     # (str, Enum)
│   ├── events.py                    # Domain Events (frozen dataclass)
│   ├── policies.py                  # Business Rules (Strategy Pattern)
│   └── exceptions.py                # DomainError
│
├── application/                     # ชั้น Use Case
│   ├── interfaces.py                # Protocol (Repository/Cache/Service)
│   ├── use_cases.py                 # 1 class {Context}UseCases
│   ├── mappers.py                   # ENTITY↔DTO / ENTITY↔MODEL / ENTITY↔CACHE
│   ├── exceptions.py                # ApplicationError
│   └── utils.py                     # Helpers
│
├── infrastructure/                  # ชั้น Adapter
│   ├── models.py                    # SQLAlchemy (extends BaseModel)
│   ├── repositories.py              # Postgres{Entity}Repository (flush, not commit)
│   ├── caches.py                    # Redis{Entity}Cache (never raise)
│   ├── services.py                  # External services (Kafka/MQTT/HTTP)
│   ├── vector_repo.py               # pgvector repository (ถ้าเกี่ยวกับ vector)
│   └── outbox.py                    # Outbox pattern
│
└── presentation/                    # ชั้น Delivery
    ├── routers.py                   # payload → mapper → use_case → mapper
    ├── schemas.py                   # Pydantic v2
    ├── docs.py                      # OpenAPI metadata
    ├── dependencies.py              # Depends factories
    ├── consumers.py                 # Kafka consumers
    └── event_handlers.py            # Domain event subscribers
```

## 6.3 ตัวอย่าง File — `modules/rag/`

### 6.3.1 Domain — `entities.py`

```python
# modules/rag/domain/entities.py
from __future__ import annotations
import uuid
from dataclasses import dataclass, field
from datetime import UTC, datetime
from typing import Any

from packages.shared_kernel.entities import BaseEntity


@dataclass
class Document(BaseEntity):
    """
    TH: เอกสารต้นทาง | EN: Source document
    """
    tenant_id: uuid.UUID
    title: str
    source_uri: str = ""
    content_hash: str = ""
    content_type: str = "text/plain"
    metadata: dict[str, Any] = field(default_factory=dict)
    status: str = "RAW"  # RAW|CHUNKED|EMBEDDED|ARCHIVED
    created_at: datetime = field(default_factory=lambda: datetime.now(UTC))

    def __post_init__(self) -> None:
        if not self.title.strip():
            raise ValueError("title is required")
        if self.status not in ("RAW", "CHUNKED", "EMBEDDED", "ARCHIVED"):
            raise ValueError(f"invalid status: {self.status}")


@dataclass
class Chunk(BaseEntity):
    """
    TH: ชิ้นส่วนเอกสาร | EN: Document chunk
    """
    document_id: uuid.UUID
    tenant_id: uuid.UUID
    content: str
    chunk_index: int
    token_count: int = 0
    metadata: dict[str, Any] = field(default_factory=dict)

    def __post_init__(self) -> None:
        if not self.content.strip():
            raise ValueError("content is required")
        if self.chunk_index < 0:
            raise ValueError("chunk_index must be >= 0")


@dataclass
class Embedding(BaseEntity):
    """
    TH: Embedding vector | EN: Embedding vector
    """
    chunk_id: uuid.UUID
    tenant_id: uuid.UUID
    model: str
    dimension: int
    vector: list[float]
    created_at: datetime = field(default_factory=lambda: datetime.now(UTC))

    def __post_init__(self) -> None:
        if len(self.vector) != self.dimension:
            raise ValueError(
                f"vector length {len(self.vector)} != dimension {self.dimension}"
            )
```

### 6.3.2 Domain — `value_objects.py`

```python
# modules/rag/domain/value_objects.py
from dataclasses import dataclass


@dataclass(frozen=True, slots=True)
class ChunkConfig:
    """
    TH: config การแบ่ง chunk | EN: chunk configuration
    """
    chunk_size: int = 800
    chunk_overlap: int = 100
    strategy: str = "semantic"  # fixed|sentence|semantic|hierarchical

    def __post_init__(self) -> None:
        if self.chunk_size < 100:
            raise ValueError("chunk_size must be >= 100")
        if not 0 <= self.chunk_overlap < self.chunk_size:
            raise ValueError("invalid overlap")
        if self.strategy not in (
            "fixed", "sentence", "semantic", "hierarchical"
        ):
            raise ValueError(f"invalid strategy: {self.strategy}")


@dataclass(frozen=True, slots=True)
class RetrievalConfig:
    """
    TH: config การค้นคืน | EN: retrieval configuration
    """
    top_k: int = 10
    rerank_top_n: int = 5
    min_score: float = 0.7
    use_mmr: bool = True
    mmr_lambda: float = 0.7

    def __post_init__(self) -> None:
        if self.top_k < 1 or self.top_k > 100:
            raise ValueError("top_k must be 1-100")
        if not 0.0 <= self.min_score <= 1.0:
            raise ValueError("min_score must be 0-1")


@dataclass(frozen=True, slots=True)
class RetrievalResult:
    """
    TH: ผลการค้นคืน | EN: retrieval result
    """
    chunk_id: str
    content: str
    score: float
    metadata: dict

    def __post_init__(self) -> None:
        if not 0.0 <= self.score <= 1.0:
            raise ValueError("score must be 0-1")
```

### 6.3.3 Domain — `events.py`

```python
# modules/rag/domain/events.py
from __future__ import annotations
import uuid
from dataclasses import dataclass, field
from datetime import UTC, datetime


@dataclass(frozen=True, slots=True)
class DocumentUploaded:
    """TH: เอกสารถูกอัปโหลด"""
    document_id: uuid.UUID
    tenant_id: uuid.UUID
    title: str
    occurred_at: datetime = field(default_factory=lambda: datetime.now(UTC))


@dataclass(frozen=True, slots=True)
class DocumentChunked:
    """TH: เอกสารถูกแบ่ง chunk"""
    document_id: uuid.UUID
    tenant_id: uuid.UUID
    chunk_count: int
    occurred_at: datetime = field(default_factory=lambda: datetime.now(UTC))


@dataclass(frozen=True, slots=True)
class EmbeddingsGenerated:
    """TH: สร้าง embeddings เสร็จ"""
    document_id: uuid.UUID
    tenant_id: uuid.UUID
    model: str
    count: int
    occurred_at: datetime = field(default_factory=lambda: datetime.now(UTC))


@dataclass(frozen=True, slots=True)
class RetrievalPerformed:
    """TH: มีการค้นคืน"""
    query: str
    tenant_id: uuid.UUID
    results_count: int
    latency_ms: int
    occurred_at: datetime = field(default_factory=lambda: datetime.now(UTC))
```

### 6.3.4 Application — `use_cases.py`

```python
# modules/rag/application/use_cases.py
from __future__ import annotations
import uuid
import structlog

from modules.rag.application.interfaces import (
    DocumentRepository, ChunkRepository, EmbeddingRepository,
    Chunker, Embedder, VectorSearch, Reranker,
    LLMGatewayClient, EventBus, RAGCache,
)
from modules.rag.domain.entities import Document, Chunk, Embedding
from modules.rag.domain.value_objects import (
    ChunkConfig, RetrievalConfig, RetrievalResult,
)
from modules.rag.domain.events import (
    DocumentUploaded, DocumentChunked,
    EmbeddingsGenerated, RetrievalPerformed,
)

log = structlog.get_logger()


class RAGUseCases:
    """
    TH: Use cases ของ RAG | EN: RAG use cases
    """

    def __init__(
        self,
        doc_repo: DocumentRepository,
        chunk_repo: ChunkRepository,
        emb_repo: EmbeddingRepository,
        chunker: Chunker,
        embedder: Embedder,
        vector_search: VectorSearch,
        reranker: Reranker,
        llm: LLMGatewayClient,
        event_bus: EventBus,
        cache: RAGCache,
    ) -> None:
        self._doc_repo = doc_repo
        self._chunk_repo = chunk_repo
        self._emb_repo = emb_repo
        self._chunker = chunker
        self._embedder = embedder
        self._vsearch = vector_search
        self._reranker = reranker
        self._llm = llm
        self._bus = event_bus
        self._cache = cache

    # ─── Ingest ───────────────────────────────────────
    async def ingest_document(
        self,
        tenant_id: uuid.UUID,
        title: str,
        content: str,
        source_uri: str = "",
        metadata: dict | None = None,
        chunk_config: ChunkConfig | None = None,
    ) -> Document:
        """
        TH: นำเข้าเอกสาร → chunk → embed
        EN: Ingest document → chunk → embed
        """
        log.info("rag.ingest.start", title=title, tenant_id=str(tenant_id))
        try:
            # 1) Save document
            doc = Document(
                tenant_id=tenant_id,
                title=title,
                source_uri=source_uri,
                metadata=metadata or {},
            )
            doc = await self._doc_repo.save(doc)
            await self._bus.publish(DocumentUploaded(
                document_id=doc.id,
                tenant_id=tenant_id,
                title=title,
            ))

            # 2) Chunk
            cfg = chunk_config or ChunkConfig()
            chunks_text = await self._chunker.chunk(content, cfg)
            chunk_entities = []
            for i, text in enumerate(chunks_text):
                ch = Chunk(
                    document_id=doc.id,
                    tenant_id=tenant_id,
                    content=text,
                    chunk_index=i,
                )
                ch = await self._chunk_repo.save(ch)
                chunk_entities.append(ch)
            await self._bus.publish(DocumentChunked(
                document_id=doc.id,
                tenant_id=tenant_id,
                chunk_count=len(chunk_entities),
            ))

            # 3) Embed
            vectors = await self._embedder.embed_batch(
                [c.content for c in chunk_entities]
            )
            dim = len(vectors[0]) if vectors else 0
            for chunk, vec in zip(chunk_entities, vectors):
                emb = Embedding(
                    chunk_id=chunk.id,
                    tenant_id=tenant_id,
                    model=self._embedder.model_name,
                    dimension=dim,
                    vector=vec,
                )
                await self._emb_repo.save(emb)

            await self._bus.publish(EmbeddingsGenerated(
                document_id=doc.id,
                tenant_id=tenant_id,
                model=self._embedder.model_name,
                count=len(chunk_entities),
            ))
            return doc

        except Exception:
            log.exception("rag.ingest.failed")
            raise

    # ─── Retrieve ─────────────────────────────────────
    async def retrieve(
        self,
        tenant_id: uuid.UUID,
        query: str,
        config: RetrievalConfig | None = None,
    ) -> list[RetrievalResult]:
        """
        TH: ค้นคืน + rerank
        EN: retrieve + rerank
        """
        cfg = config or RetrievalConfig()
        try:
            # cache check
            cached = await self._cache.get_retrieval(tenant_id, query)
            if cached:
                return cached

            # 1) embed query
            q_vec = await self._embedder.embed_one(query)

            # 2) vector search (pgvector)
            candidates = await self._vsearch.search(
                tenant_id=tenant_id,
                query_vector=q_vec,
                top_k=cfg.top_k,
                min_score=cfg.min_score,
            )

            # 3) MMR (optional)
            if cfg.use_mmr and len(candidates) > cfg.rerank_top_n:
                candidates = self._mmr(candidates, cfg)

            # 4) rerank (cross-encoder)
            reranked = await self._reranker.rerank(
                query=query,
                candidates=candidates,
                top_n=cfg.rerank_top_n,
            )

            await self._cache.set_retrieval(tenant_id, query, reranked)
            await self._bus.publish(RetrievalPerformed(
                query=query,
                tenant_id=tenant_id,
                results_count=len(reranked),
                latency_ms=0,
            ))
            return reranked

        except Exception:
            log.exception("rag.retrieve.failed")
            raise

    # ─── Answer (RAG full pipeline) ───────────────────
    async def answer(
        self,
        tenant_id: uuid.UUID,
        query: str,
        config: RetrievalConfig | None = None,
        system_prompt: str | None = None,
    ) -> dict:
        """
        TH: RAG ครบวงจร: retrieve → prompt → LLM → answer + citations
        EN: full RAG: retrieve → prompt → LLM → answer + citations
        """
        results = await self.retrieve(tenant_id, query, config)
        context = "\n\n".join(
            f"[{i+1}] {r.content}" for i, r in enumerate(results)
        )
        prompt = (
            f"{system_prompt or 'Answer only from context.'}\n\n"
            f"Context:\n{context}\n\n"
            f"Question: {query}\n"
            f"Answer:"
        )
        resp = await self._llm.chat(
            messages=[{"role": "user", "content": prompt}],
            model="gpt-4o-mini",
        )
        return {
            "answer": resp["content"],
            "citations": [
                {"chunk_id": r.chunk_id, "score": r.score}
                for r in results
            ],
            "tokens_used": resp.get("usage", {}),
        }

    # ─── MMR helper ───────────────────────────────────
    @staticmethod
    def _mmr(candidates: list[RetrievalResult],
             cfg: RetrievalConfig) -> list[RetrievalResult]:
        # simplified — production ใช้ embedding similarity
        return candidates[: cfg.rerank_top_n]
```

### 6.3.5 Application — `interfaces.py`

```python
# modules/rag/application/interfaces.py
from __future__ import annotations
import uuid
from abc import ABC, abstractmethod
from typing import Any, Protocol

from modules.rag.domain.entities import Document, Chunk, Embedding
from modules.rag.domain.value_objects import (
    ChunkConfig, RetrievalConfig, RetrievalResult,
)


class DocumentRepository(ABC):
    @abstractmethod
    async def save(self, doc: Document) -> Document: ...
    @abstractmethod
    async def find_by_id(self, tenant_id: uuid.UUID, id: uuid.UUID) -> Document | None: ...


class ChunkRepository(ABC):
    @abstractmethod
    async def save(self, chunk: Chunk) -> Chunk: ...
    @abstractmethod
    async def find_by_document(self, tenant_id: uuid.UUID, doc_id: uuid.UUID) -> list[Chunk]: ...


class EmbeddingRepository(ABC):
    @abstractmethod
    async def save(self, emb: Embedding) -> Embedding: ...


class Chunker(ABC):
    @abstractmethod
    async def chunk(self, content: str, cfg: ChunkConfig) -> list[str]: ...


class Embedder(Protocol):
    model_name: str
    async def embed_one(self, text: str) -> list[float]: ...
    async def embed_batch(self, texts: list[str]) -> list[list[float]]: ...


class VectorSearch(ABC):
    @abstractmethod
    async def search(
        self,
        tenant_id: uuid.UUID,
        query_vector: list[float],
        top_k: int,
        min_score: float,
    ) -> list[RetrievalResult]: ...


class Reranker(ABC):
    @abstractmethod
    async def rerank(
        self,
        query: str,
        candidates: list[RetrievalResult],
        top_n: int,
    ) -> list[RetrievalResult]: ...


class LLMGatewayClient(Protocol):
    async def chat(
        self, messages: list[dict], model: str, **kwargs: Any
    ) -> dict: ...


class EventBus(ABC):
    @abstractmethod
    async def publish(self, event: object) -> None: ...


class RAGCache(ABC):
    @abstractmethod
    async def get_retrieval(self, tenant_id: uuid.UUID, query: str) -> list[RetrievalResult] | None: ...
    @abstractmethod
    async def set_retrieval(
        self, tenant_id: uuid.UUID, query: str, results: list[RetrievalResult]
    ) -> None: ...
```

### 6.3.6 Infrastructure — `models.py` (SQLAlchemy + pgvector)

```python
# modules/rag/infrastructure/models.py
from __future__ import annotations
import uuid
from datetime import datetime
from typing import Optional

from pgvector.sqlalchemy import Vector
from sqlalchemy import (
    CheckConstraint, DateTime, ForeignKey, Index, Integer,
    String, Text, func, text,
)
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column

SCHEMA = "public"


class Base(DeclarativeBase):
    pass


class DocumentModel(Base):
    __tablename__ = "rag_documents"
    __table_args__ = (
        Index("ix_rag_documents_tenant", "tenant_id"),
        Index("ix_rag_documents_status", "tenant_id", "status"),
        {"schema": SCHEMA},
    )

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()"),
    )
    tenant_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    title: Mapped[str] = mapped_column(String(500), nullable=False)
    source_uri: Mapped[str] = mapped_column(Text, nullable=False, server_default="")
    content_hash: Mapped[str] = mapped_column(String(64), nullable=False, server_default="")
    content_type: Mapped[str] = mapped_column(String(100), nullable=False, server_default="text/plain")
    metadata_json: Mapped[dict] = mapped_column(JSONB, nullable=False, server_default=text("'{}'::jsonb"))
    status: Mapped[str] = mapped_column(String(20), nullable=False, server_default="RAW")
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False, server_default=func.now())


class ChunkModel(Base):
    __tablename__ = "rag_chunks"
    __table_args__ = (
        Index("ix_rag_chunks_document", "document_id", "chunk_index"),
        Index("ix_rag_chunks_tenant", "tenant_id"),
        {"schema": SCHEMA},
    )

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()"),
    )
    document_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("public.rag_documents.id", ondelete="CASCADE"), nullable=False,
    )
    tenant_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    content: Mapped[str] = mapped_column(Text, nullable=False)
    chunk_index: Mapped[int] = mapped_column(Integer, nullable=False)
    token_count: Mapped[int] = mapped_column(Integer, nullable=False, server_default="0")
    metadata_json: Mapped[dict] = mapped_column(JSONB, nullable=False, server_default=text("'{}'::jsonb"))


class EmbeddingModel(Base):
    """pgvector embedding store"""
    __tablename__ = "rag_embeddings"
    __table_args__ = (
        Index(
            "ix_rag_embeddings_hnsw",
            "vector",
            postgresql_using="hnsw",
            postgresql_with={"m": 16, "ef_construction": 64},
            postgresql_ops={"vector": "vector_cosine_ops"},
        ),
        Index("ix_rag_embeddings_tenant", "tenant_id"),
        Index("ix_rag_embeddings_chunk", "chunk_id"),
        {"schema": SCHEMA},
    )

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()"),
    )
    chunk_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("public.rag_chunks.id", ondelete="CASCADE"), nullable=False,
    )
    tenant_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    model: Mapped[str] = mapped_column(String(100), nullable=False)
    dimension: Mapped[int] = mapped_column(Integer, nullable=False)
    vector: Mapped[list[float]] = mapped_column(Vector(1536), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False, server_default=func.now())
```

### 6.3.7 Infrastructure — `vector_repo.py`

```python
# modules/rag/infrastructure/vector_repo.py
from __future__ import annotations
import uuid
from sqlalchemy import select, text
from sqlalchemy.ext.asyncio import AsyncSession

from modules.rag.application.interfaces import VectorSearch
from modules.rag.domain.value_objects import RetrievalResult
from modules.rag.infrastructure.models import ChunkModel, EmbeddingModel


class PgVectorSearch(VectorSearch):
    """
    TH: ค้นหาเวกเตอร์ด้วย pgvector (cosine similarity)
    EN: vector search via pgvector (cosine distance)
    """

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def search(
        self,
        tenant_id: uuid.UUID,
        query_vector: list[float],
        top_k: int,
        min_score: float,
    ) -> list[RetrievalResult]:
        # cosine distance: 1 - cosine_similarity
        stmt = (
            select(
                ChunkModel.id,
                ChunkModel.content,
                ChunkModel.metadata_json,
                (1 - EmbeddingModel.vector.cosine_distance(query_vector)).label("score"),
            )
            .join(EmbeddingModel, EmbeddingModel.chunk_id == ChunkModel.id)
            .where(EmbeddingModel.tenant_id == tenant_id)
            .order_by(EmbeddingModel.vector.cosine_distance(query_vector))
            .limit(top_k)
        )
        rows = (await self._session.execute(stmt)).all()
        return [
            RetrievalResult(
                chunk_id=str(r.id),
                content=r.content,
                score=float(r.score),
                metadata=r.metadata_json or {},
            )
            for r in rows
            if float(r.score) >= min_score
        ]
```

### 6.3.8 Presentation — `routers.py`

```python
# modules/rag/presentation/routers.py
from __future__ import annotations
import uuid
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status

from modules.rag.application.use_cases import RAGUseCases
from modules.rag.presentation.dependencies import get_rag_use_cases, get_current_tenant
from modules.rag.presentation.schemas import (
    DocumentIngestRequest, DocumentResponse,
    RetrieveRequest, RetrieveResponse,
    AnswerRequest, AnswerResponse,
)

router = APIRouter(prefix="/rag", tags=["RAG"])


@router.post(
    "/documents",
    response_model=DocumentResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Ingest document → chunk → embed",
)
async def ingest_document(
    payload: DocumentIngestRequest,
    tenant_id: Annotated[uuid.UUID, Depends(get_current_tenant)],
    uc: Annotated[RAGUseCases, Depends(get_rag_use_cases)],
) -> DocumentResponse:
    doc = await uc.ingest_document(
        tenant_id=tenant_id,
        title=payload.title,
        content=payload.content,
        source_uri=payload.source_uri,
        metadata=payload.metadata,
    )
    return DocumentResponse(id=str(doc.id), title=doc.title, status=doc.status)


@router.post("/retrieve", response_model=RetrieveResponse, summary="Vector search")
async def retrieve(
    payload: RetrieveRequest,
    tenant_id: Annotated[uuid.UUID, Depends(get_current_tenant)],
    uc: Annotated[RAGUseCases, Depends(get_rag_use_cases)],
) -> RetrieveResponse:
    results = await uc.retrieve(tenant_id=tenant_id, query=payload.query)
    return RetrieveResponse(
        results=[
            {"chunk_id": r.chunk_id, "content": r.content, "score": r.score}
            for r in results
        ]
    )


@router.post("/answer", response_model=AnswerResponse, summary="RAG answer")
async def answer(
    payload: AnswerRequest,
    tenant_id: Annotated[uuid.UUID, Depends(get_current_tenant)],
    uc: Annotated[RAGUseCases, Depends(get_rag_use_cases)],
) -> AnswerResponse:
    result = await uc.answer(
        tenant_id=tenant_id,
        query=payload.query,
        system_prompt=payload.system_prompt,
    )
    return AnswerResponse(**result)
```

---

# 7. สถาปัตยกรรมแบบ Event-Driven

## 7.1 หลักการ 5 ข้อ (Event-Driven Principles)

| # | หลักการ | คำอธิบาย |
|---|---|---|
| 1 | **Domain Event = Fact** | Event คือข้อเท็จจริงในอดีต เปลี่ยนไม่ได้ (immutable) |
| 2 | **Outbox Pattern** | เขียน DB ก่อน → worker sync ไป Kafka (at-least-once) |
| 3 | **Idempotent Consumer** | Consumer ต้องทนต่อ event ซ้ำได้ |
| 4 | **Schema Versioning** | Event ทุกตัวมี version + schema registry |
| 5 | **DLQ + Retry** | Consumer ล้ม → retry → DLQ + alert |

## 7.2 Outbox Pattern (ทุก Module)

```
┌──────────────────────────────────────────────────────┐
│            TRANSACTION (single DB)                   │
│  ┌────────────────┐      ┌───────────────────────┐   │
│  │ Business Table │      │   Outbox Table        │   │
│  │ (invoices)     │ ───► │ (outbox_events)       │   │
│  └────────────────┘      └───────────┬───────────┘   │
└──────────────────────────────────────┼───────────────┘
                                       │ (COMMIT)
                                       ▼
                          ┌────────────────────────┐
                          │   Outbox Worker        │
                          │  (poll → publish)      │
                          └───────────┬────────────┘
                                      │
                                      ▼
                          ┌────────────────────────┐
                          │   Kafka (Event Bus)    │
                          └────────────────────────┘
```

### Outbox Table Schema

```sql
CREATE TABLE public.outbox_events (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       uuid NOT NULL,
    aggregate_type  varchar(100) NOT NULL,
    aggregate_id    uuid NOT NULL,
    event_type      varchar(200) NOT NULL,
    event_version   int4 NOT NULL DEFAULT 1,
    payload         jsonb NOT NULL,
    occurred_at     timestamptz NOT NULL DEFAULT now(),
    published_at    timestamptz,
    retries         int4 NOT NULL DEFAULT 0,
    last_error      text NOT NULL DEFAULT ''
);

CREATE INDEX ix_outbox_pending
    ON public.outbox_events (occurred_at)
    WHERE published_at IS NULL;
```

### Outbox Worker (Python + arq)

```python
# packages/infrastructure/outbox_worker.py
import asyncio
import uuid
from datetime import UTC, datetime

from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession

from packages.infrastructure.kafka import KafkaProducer
from modules.audit.infrastructure.models import OutboxEventModel


class OutboxWorker:
    """
    TH: worker ที่ poll outbox แล้ว publish ไป Kafka
    EN: poll outbox and publish to Kafka
    """

    def __init__(
        self,
        session_factory,
        producer: KafkaProducer,
        batch_size: int = 100,
        poll_interval: float = 1.0,
    ) -> None:
        self._session_factory = session_factory
        self._producer = producer
        self._batch_size = batch_size
        self._poll_interval = poll_interval

    async def run_forever(self) -> None:
        while True:
            try:
                published = await self._poll_and_publish()
                if published == 0:
                    await asyncio.sleep(self._poll_interval)
            except Exception as e:
                print(f"outbox worker error: {e}")
                await asyncio.sleep(5)

    async def _poll_and_publish(self) -> int:
        async with self._session_factory() as session:
            stmt = (
                select(OutboxEventModel)
                .where(OutboxEventModel.published_at.is_(None))
                .order_by(OutboxEventModel.occurred_at)
                .limit(self._batch_size)
                .with_for_update(skip_locked=True)
            )
            events = (await session.execute(stmt)).scalars().all()
            if not events:
                return 0

            for ev in events:
                try:
                    await self._producer.send(
                        topic=f"{ev.aggregate_type}.{ev.event_type}",
                        key=str(ev.aggregate_id),
                        value={
                            "id": str(ev.id),
                            "tenant_id": str(ev.tenant_id),
                            "event_type": ev.event_type,
                            "event_version": ev.event_version,
                            "aggregate_id": str(ev.aggregate_id),
                            "payload": ev.payload,
                            "occurred_at": ev.occurred_at.isoformat(),
                        },
                    )
                    ev.published_at = datetime.now(UTC)
                except Exception as e:
                    ev.retries += 1
                    ev.last_error = str(e)[:500]

            await session.commit()
            return len([e for e in events if e.published_at])
```

## 7.3 Event Schema (Canonical)

```python
# packages/contracts/base.py
from __future__ import annotations
import uuid
from datetime import datetime
from typing import Any, Generic, TypeVar

from pydantic import BaseModel, ConfigDict, Field

T = TypeVar("T")


class EventEnvelope(BaseModel, Generic[T]):
    """
    TH: โครงสร้าง Event มาตรฐาน
    EN: canonical event envelope
    """
    model_config = ConfigDict(extra="forbid")

    event_id: uuid.UUID = Field(default_factory=uuid.uuid4)
    event_type: str = Field(..., min_length=1, max_length=200)
    event_version: int = Field(default=1, ge=1)
    aggregate_type: str
    aggregate_id: uuid.UUID
    tenant_id: uuid.UUID
    occurred_at: datetime
    correlation_id: uuid.UUID | None = None
    causation_id: uuid.UUID | None = None
    payload: T
```

## 7.4 Event Catalog (ทั้งหมด 30+ Events)

| Context | Event | Consumer |
|---|---|---|
| Ordering | `OrderPlaced` | Payment, Inventory, Shipping |
| Ordering | `OrderCancelled` | Payment, Inventory |
| Ordering | `OrderConfirmed` | Invoice |
| Pricing | `PriceChanged` | Ordering |
| Inventory | `StockPosted` | Report, Analytics |
| Inventory | `StockLow` | Reorder (AI) |
| Inventory | `LotTraced` | Compliance |
| Payment | `PaymentReceived` | Invoice, Ledger |
| Payment | `PaymentMatched` | Ordering |
| Invoice | `InvoiceIssued` | Ledger, Report |
| Invoice | `InvoiceVoided` | Ledger |
| Shipping | `ShipmentDispatched` | Customer (Notify) |
| Shipping | `ShipmentArrived` | Ordering |
| IoT | `SensorReadingReceived` | Alarm, Analytics, Vector |
| IoT | `AlarmTriggered` | Notification, Automation |
| IoT | `DeviceOffline` | Notification |
| IoT | `CooldownCleared` | Notification |
| AI Agent | `AgentPlanCreated` | Audit |
| AI Agent | `AgentActionExecuted` | Audit |
| LLM | `LLMCompletionGenerated` | Billing, Analytics |
| LLM | `TokenLimitExceeded` | Notification |
| RAG | `DocumentUploaded` | Chunking |
| RAG | `DocumentChunked` | Embedding |
| RAG | `EmbeddingsGenerated` | Vector Index |
| RAG | `RetrievalPerformed` | Analytics |
| ML | `TrainingCompleted` | Model Registry |
| ML | `ModelDeployed` | Serving |
| ML | `PredictionServed` | Analytics |
| ML | `ModelDriftDetected` | Notification, Retrain |
| Auth | `UserRegistered` | Email Verify |
| Auth | `UserLoggedIn` | Audit |

## 7.5 Kafka Topic Naming Convention

```
{domain}.{aggregate}.{event}          # e.g., money.invoice.issued
{domain}.{aggregate}.{event}.v{n}     # versioned, e.g., .v2
dlq.{domain}.{aggregate}              # dead letter queue
```

## 7.6 Consumer Pattern (Idempotent)

```python
# packages/infrastructure/kafka_consumer.py
import uuid
from typing import Callable, Awaitable

from packages.infrastructure.redis import RedisClient


class IdempotentConsumer:
    """
    TH: consumer ที่กัน event ซ้ำด้วย Redis
    EN: idempotent consumer using Redis dedup
    """

    def __init__(self, redis: RedisClient, ttl_seconds: int = 86400) -> None:
        self._redis = redis
        self._ttl = ttl_seconds

    async def handle_once(
        self,
        event_id: uuid.UUID,
        handler: Callable[[dict], Awaitable[None]],
        event_data: dict,
    ) -> bool:
        key = f"consumed:{event_id}"
        if await self._redis.set(key, "1", nx=True, ex=self._ttl) is None:
            return False  # already consumed
        try:
            await handler(event_data)
            return True
        except Exception:
            await self._redis.delete(key)  # allow retry
            raise
```

---

# 8. AI / LLM / Deep Learning Layer

## 8.1 AI Stack — 5 ชั้น

```
┌───────────────────────────────────────────────────────────────┐
│  L5  AI APPLICATIONS                                          │
│      Chatbot │ RAG Assistant │ Vision (YOLO) │ Forecast       │
├───────────────────────────────────────────────────────────────┤
│  L4  AGENT ORCHESTRATOR                                       │
│      ReAct Loop │ Tool Registry │ Memory │ Guardrails        │
├───────────────────────────────────────────────────────────────┤
│  L3  AI SERVICES                                              │
│      RAG Pipeline │ Fine-tune │ Model Server │ Embedder       │
├───────────────────────────────────────────────────────────────┤
│  L2  AI GATEWAY                                               │
│      LLM Gateway │ Vector Gateway │ Model Gateway             │
├───────────────────────────────────────────────────────────────┤
│  L1  AI PROVIDERS                                             │
│      OpenAI │ Anthropic │ Ollama │ vLLM │ Triton │ TorchServe│
└───────────────────────────────────────────────────────────────┘
```

## 8.2 LLM Gateway Module (Supporting)

### 8.2.1 Domain Entities

```python
# modules/llm_gateway/domain/entities.py
from __future__ import annotations
import uuid
from dataclasses import dataclass, field
from datetime import UTC, datetime
from decimal import Decimal
from typing import Any

from packages.shared_kernel.entities import BaseEntity


@dataclass
class Provider(BaseEntity):
    """
    TH: ผู้ให้บริการ LLM | EN: LLM provider
    """
    tenant_id: uuid.UUID
    name: str
    provider_type: str  # openai|anthropic|local|azure
    api_key_encrypted: str = ""
    base_url: str = ""
    priority: int = 100
    is_active: bool = True
    metadata: dict[str, Any] = field(default_factory=dict)


@dataclass
class Model(BaseEntity):
    """
    TH: โมเดล LLM | EN: LLM model
    """
    tenant_id: uuid.UUID
    provider_id: uuid.UUID
    name: str
    display_name: str = ""
    context_window: int = 4096
    max_output: int = 4096
    cost_input_per_1k: Decimal = Decimal("0")
    cost_output_per_1k: Decimal = Decimal("0")
    supports_streaming: bool = True
    supports_tools: bool = False
    is_active: bool = True


@dataclass
class Conversation(BaseEntity):
    """
    TH: บทสนทนา | EN: conversation
    """
    tenant_id: uuid.UUID
    user_id: uuid.UUID
    title: str = ""
    model_id: uuid.UUID | None = None
    system_prompt: str = ""
    status: str = "ACTIVE"  # ACTIVE|ARCHIVED|DELETED
    message_count: int = 0
    total_tokens: int = 0
    metadata: dict[str, Any] = field(default_factory=dict)


@dataclass
class Message(BaseEntity):
    """
    TH: ข้อความ | EN: message
    """
    conversation_id: uuid.UUID
    tenant_id: uuid.UUID
    role: str  # system|user|assistant|tool
    content: str = ""
    tool_calls: list[dict] = field(default_factory=list)
    tool_call_id: str = ""
    tokens_input: int = 0
    tokens_output: int = 0
    finish_reason: str = ""
    latency_ms: int = 0

    def __post_init__(self) -> None:
        if self.role not in ("system", "user", "assistant", "tool"):
            raise ValueError(f"invalid role: {self.role}")


@dataclass
class UsageLog(BaseEntity):
    """
    TH: บันทึกการใช้งาน | EN: usage log
    """
    tenant_id: uuid.UUID
    user_id: uuid.UUID
    model_id: uuid.UUID
    conversation_id: uuid.UUID | None = None
    tokens_input: int = 0
    tokens_output: int = 0
    cost_usd: Decimal = Decimal("0")
    source: str = "chat"
    created_at: datetime = field(default_factory=lambda: datetime.now(UTC))
```

### 8.2.2 Provider Registry (Strategy Pattern)

```python
# modules/llm_gateway/infrastructure/providers.py
from abc import ABC, abstractmethod
from typing import AsyncIterator

from openai import AsyncOpenAI
from anthropic import AsyncAnthropic

from modules.llm_gateway.domain.entities import Provider, Model


class BaseLLMClient(ABC):
    """Adapter Pattern — unified LLM interface"""

    @abstractmethod
    async def chat(self, messages: list[dict], model: str, **kwargs) -> dict: ...

    @abstractmethod
    def stream_chat(self, messages: list[dict], model: str, **kwargs) -> AsyncIterator[dict]: ...


class OpenAIClient(BaseLLMClient):
    def __init__(self, api_key: str, base_url: str | None = None) -> None:
        self._client = AsyncOpenAI(api_key=api_key, base_url=base_url)

    async def chat(self, messages: list[dict], model: str, **kwargs) -> dict:
        resp = await self._client.chat.completions.create(
            model=model, messages=messages, **kwargs
        )
        return {
            "content": resp.choices[0].message.content,
            "finish_reason": resp.choices[0].finish_reason,
            "usage": {
                "input_tokens": resp.usage.prompt_tokens,
                "output_tokens": resp.usage.completion_tokens,
            },
        }

    async def stream_chat(self, messages: list[dict], model: str, **kwargs):
        stream = await self._client.chat.completions.create(
            model=model, messages=messages, stream=True, **kwargs
        )
        async for chunk in stream:
            delta = chunk.choices[0].delta.content
            if delta:
                yield {"delta": delta}


class AnthropicClient(BaseLLMClient):
    def __init__(self, api_key: str) -> None:
        self._client = AsyncAnthropic(api_key=api_key)

    async def chat(self, messages: list[dict], model: str, **kwargs) -> dict:
        system = ""
        filtered = []
        for m in messages:
            if m["role"] == "system":
                system = m["content"]
            else:
                filtered.append(m)
        resp = await self._client.messages.create(
            model=model, system=system, messages=filtered, **kwargs
        )
        return {
            "content": resp.content[0].text,
            "finish_reason": resp.stop_reason,
            "usage": {
                "input_tokens": resp.usage.input_tokens,
                "output_tokens": resp.usage.output_tokens,
            },
        }

    async def stream_chat(self, messages: list[dict], model: str, **kwargs):
        async with self._client.messages.stream(
            model=model, messages=messages, **kwargs
        ) as stream:
            async for text in stream.text_stream:
                yield {"delta": text}


class ProviderRegistry:
    """
    TH: registry ที่เลือก provider ตาม model
    EN: registry that selects provider by model
    """

    def __init__(self) -> None:
        self._clients: dict[str, BaseLLMClient] = {}
        self._model_to_provider: dict[str, str] = {}

    def register(self, provider_name: str, client: BaseLLMClient) -> None:
        self._clients[provider_name] = client

    def map_model(self, model_name: str, provider_name: str) -> None:
        self._model_to_provider[model_name] = provider_name

    def get_client(self, model_name: str) -> BaseLLMClient:
        provider = self._model_to_provider.get(model_name)
        if not provider or provider not in self._clients:
            raise ValueError(f"no provider for model: {model_name}")
        return self._clients[provider]
```

### 8.2.3 LLM Gateway Use Case

```python
# modules/llm_gateway/application/use_cases.py
import uuid
import time
import structlog
from decimal import Decimal

from modules.llm_gateway.application.interfaces import (
    ProviderRepository, ModelRepository, ConversationRepository,
    MessageRepository, UsageLogRepository, ProviderRegistry,
    RateLimiter, EventBus,
)
from modules.llm_gateway.domain.entities import Message, UsageLog
from modules.llm_gateway.domain.events import (
    LLMCompletionGenerated, TokenLimitExceeded,
)

log = structlog.get_logger()


class LLMGatewayUseCases:

    def __init__(
        self,
        provider_repo: ProviderRepository,
        model_repo: ModelRepository,
        conv_repo: ConversationRepository,
        msg_repo: MessageRepository,
        usage_repo: UsageLogRepository,
        registry: ProviderRegistry,
        rate_limiter: RateLimiter,
        event_bus: EventBus,
    ) -> None:
        self._provider_repo = provider_repo
        self._model_repo = model_repo
        self._conv_repo = conv_repo
        self._msg_repo = msg_repo
        self._usage_repo = usage_repo
        self._registry = registry
        self._rate = rate_limiter
        self._bus = event_bus

    async def chat(
        self,
        tenant_id: uuid.UUID,
        user_id: uuid.UUID,
        conversation_id: uuid.UUID | None,
        messages: list[dict],
        model_name: str,
        **kwargs,
    ) -> dict:
        log.info("llm.chat.start", model=model_name)
        try:
            # 1) rate limit
            if not await self._rate.check(tenant_id, user_id, cost=1):
                await self._bus.publish(TokenLimitExceeded(
                    tenant_id=tenant_id, user_id=user_id,
                    current_usage=0, limit=0,
                ))
                raise ValueError("rate limit exceeded")

            # 2) select client
            client = self._registry.get_client(model_name)

            # 3) call
            start = time.monotonic()
            try:
                resp = await client.chat(messages, model_name, **kwargs)
            except Exception as e:
                log.warning("llm.provider_failed", error=str(e))
                # fallback: pick secondary model
                raise
            latency_ms = int((time.monotonic() - start) * 1000)

            # 4) usage log (Decimal cost)
            model = await self._model_repo.find_by_name(tenant_id, model_name)
            cost = Decimal("0")
            if model:
                cost = (
                    Decimal(resp["usage"]["input_tokens"]) / 1000 * model.cost_input_per_1k
                    + Decimal(resp["usage"]["output_tokens"]) / 1000 * model.cost_output_per_1k
                )
                await self._usage_repo.create(UsageLog(
                    tenant_id=tenant_id, user_id=user_id,
                    model_id=model.id, conversation_id=conversation_id,
                    tokens_input=resp["usage"]["input_tokens"],
                    tokens_output=resp["usage"]["output_tokens"],
                    cost_usd=cost, source="chat",
                ))

            # 5) persist assistant message
            if conversation_id:
                await self._msg_repo.create(Message(
                    conversation_id=conversation_id,
                    tenant_id=tenant_id,
                    role="assistant",
                    content=resp["content"],
                    finish_reason=resp.get("finish_reason", ""),
                    tokens_output=resp["usage"]["output_tokens"],
                    latency_ms=latency_ms,
                ))

            # 6) publish event
            await self._bus.publish(LLMCompletionGenerated(
                tenant_id=tenant_id,
                model_name=model_name,
                finish_reason=resp.get("finish_reason", ""),
                latency_ms=latency_ms,
                tokens_input=resp["usage"]["input_tokens"],
                tokens_output=resp["usage"]["output_tokens"],
            ))

            return resp

        except Exception:
            log.exception("llm.chat.failed")
            raise
```

## 8.3 Deep Learning — YOLO Module (Supporting)

### 8.3.1 Core Entities

```python
# modules/ai_vision/domain/entities.py
@dataclass
class Dataset(BaseEntity):
    tenant_id: uuid.UUID
    name: str
    source_uri: str
    row_count: int = 0
    status: str = "RAW"  # RAW|LABELED|TRAINED|ARCHIVED
    version: int = 1
    metadata: dict = field(default_factory=dict)


@dataclass
class ModelVersion(BaseEntity):
    tenant_id: uuid.UUID
    name: str
    version: int
    task_type: str = "DETECTION"  # DETECTION|SEGMENTATION|CLASSIFICATION
    algorithm: str = "YOLOv8"
    artifact_uri: str = ""
    metrics: dict = field(default_factory=dict)  # mAP, IoU, precision, recall
    status: str = "DRAFT"  # DRAFT|TRAINED|DEPLOYED|ARCHIVED


@dataclass
class TrainingRun(BaseEntity):
    tenant_id: uuid.UUID
    dataset_id: uuid.UUID
    model_id: uuid.UUID | None = None
    status: str = "PENDING"  # PENDING|RUNNING|SUCCESS|FAILED
    config: dict = field(default_factory=dict)
    metrics: dict = field(default_factory=dict)
    started_at: datetime | None = None
    finished_at: datetime | None = None
    error: str = ""


@dataclass
class Prediction(BaseEntity):
    tenant_id: uuid.UUID
    model_id: uuid.UUID
    input_ref: str  # S3 URI
    output: dict = field(default_factory=dict)  # boxes, classes, scores
    confidence: Decimal = Decimal("0")
    latency_ms: int = 0
    source: str = "api"
```

### 8.3.2 Training Service (PyTorch/Ultralytics)

```python
# modules/ai_vision/infrastructure/services.py
import uuid
import time
from pathlib import Path
from typing import Any

import structlog

log = structlog.get_logger()


class YoloTrainer:
    """
    TH: trainer สำหรับ YOLOv8 | EN: YOLOv8 trainer
    """

    def __init__(self, output_dir: str = "/tmp/ai_models") -> None:
        self._output_dir = Path(output_dir)
        self._output_dir.mkdir(parents=True, exist_ok=True)

    async def train(
        self,
        dataset_uri: str,
        config: dict[str, Any],
        run_id: uuid.UUID,
    ) -> dict[str, Any]:
        from ultralytics import YOLO

        start = time.monotonic()
        try:
            # 1) load base model
            base_model = config.get("base_model", "yolov8n.pt")
            model = YOLO(base_model)

            # 2) train
            results = model.train(
                data=dataset_uri,
                epochs=config.get("epochs", 100),
                imgsz=config.get("imgsz", 640),
                batch=config.get("batch", 16),
                project=str(self._output_dir),
                name=f"run_{run_id}",
                exist_ok=True,
            )

            # 3) extract metrics
            metrics = {
                "mAP50": float(results.box.map50),
                "mAP50_95": float(results.box.map),
                "precision": float(results.box.mp),
                "recall": float(results.box.mr),
            }

            # 4) save artifact
            artifact_uri = f"{self._output_dir}/run_{run_id}/weights/best.pt"
            duration_ms = int((time.monotonic() - start) * 1000)

            return {
                "status": "SUCCESS",
                "metrics": metrics,
                "artifact_uri": str(artifact_uri),
                "duration_ms": duration_ms,
            }

        except Exception as e:
            log.exception("yolo.train.failed", run_id=str(run_id))
            return {"status": "FAILED", "error": str(e)}


class YoloPredictor:
    """
    TH: predictor สำหรับ YOLOv8 | EN: YOLOv8 predictor
    """

    def __init__(self) -> None:
        self._models: dict[str, Any] = {}

    def load(self, model_id: uuid.UUID, artifact_uri: str) -> None:
        from ultralytics import YOLO
        self._models[str(model_id)] = YOLO(artifact_uri)

    async def predict(
        self,
        model_id: uuid.UUID,
        image_uri: str,
        conf_threshold: float = 0.25,
    ) -> dict[str, Any]:
        start = time.monotonic()
        model = self._models.get(str(model_id))
        if model is None:
            raise ValueError(f"model not loaded: {model_id}")

        results = model.predict(source=image_uri, conf=conf_threshold)
        boxes = []
        for r in results:
            for box in r.boxes:
                boxes.append({
                    "xyxy": box.xyxy[0].tolist(),
                    "confidence": float(box.conf[0]),
                    "class_id": int(box.cls[0]),
                    "class_name": model.names[int(box.cls[0])],
                })

        latency_ms = int((time.monotonic() - start) * 1000)
        max_conf = max((b["confidence"] for b in boxes), default=0.0)
        return {
            "predictions": boxes,
            "count": len(boxes),
            "max_confidence": max_conf,
            "latency_ms": latency_ms,
        }
```

### 8.3.3 Drift Detection (Evidently)

```python
# modules/ai_vision/infrastructure/drift.py
import structlog

log = structlog.get_logger()


class EvidentlyDriftDetector:
    """
    TH: ตรวจจับ drift ด้วย Evidently | EN: drift detection via Evidently
    """

    def detect(self, reference: list[dict], current: list[dict]) -> dict:
        try:
            import pandas as pd
            from evidently.metric_preset import DataDriftPreset
            from evidently.report import Report

            ref_df = pd.DataFrame(reference)
            cur_df = pd.DataFrame(current)

            report = Report(metrics=[DataDriftPreset()])
            report.run(reference_data=ref_df, current_data=cur_df)
            result = report.as_dict()

            drift_score = 0.0
            for m in result.get("metrics", []):
                if m.get("metric") == "DatasetDriftMetric":
                    drift_score = float(
                        m.get("result", {}).get("drift_share", 0.0)
                    )
            return {
                "drift_score": drift_score,
                "drifted": drift_score > 0.3,
            }
        except Exception as e:
            log.warning("drift.detect.failed", error=str(e))
            return {"drift_score": 0.0, "drifted": False}
```

## 8.4 AI Agent Orchestrator (Core)

### 8.4.1 Agent Loop (ReAct Pattern)

```python
# modules/ai_agent/application/use_cases.py
import uuid
import json
import structlog
from typing import Any

from modules.ai_agent.application.interfaces import (
    LLMGatewayClient, ToolRegistry, AgentMemory,
    Guardrails, EventBus,
)
from modules.ai_agent.domain.events import (
    AgentPlanCreated, AgentActionExecuted,
)

log = structlog.get_logger()

MAX_ITERATIONS = 10


class AIAgentUseCases:
    """
    TH: orchestrator สำหรับ ReAct agent
    EN: ReAct agent orchestrator
    """

    def __init__(
        self,
        llm: LLMGatewayClient,
        tools: ToolRegistry,
        memory: AgentMemory,
        guardrails: Guardrails,
        event_bus: EventBus,
    ) -> None:
        self._llm = llm
        self._tools = tools
        self._memory = memory
        self._guard = guardrails
        self._bus = event_bus

    async def run(
        self,
        tenant_id: uuid.UUID,
        user_id: uuid.UUID,
        goal: str,
        allowed_tools: list[str] | None = None,
        max_iterations: int = MAX_ITERATIONS,
    ) -> dict:
        log.info("agent.run.start", goal=goal[:100])
        try:
            if not self._guard.check_input(goal):
                raise ValueError("input blocked by guardrails")

            context = await self._memory.get_context(tenant_id, user_id)
            context.append({"role": "user", "content": goal})

            history = []
            for i in range(max_iterations):
                # 1) ask LLM to think + plan
                plan_prompt = self._build_plan_prompt(
                    context, allowed_tools or self._tools.list_names()
                )
                resp = await self._llm.chat(
                    messages=[{"role": "user", "content": plan_prompt}],
                    model="gpt-4o-mini",
                )
                plan = self._parse_json(resp["content"])
                await self._bus.publish(AgentPlanCreated(
                    tenant_id=tenant_id,
                    iteration=i,
                    plan=plan,
                ))

                # 2) if final answer → return
                if plan.get("type") == "final":
                    answer = plan.get("answer", "")
                    if not self._guard.check_output(answer):
                        raise ValueError("output blocked")
                    await self._memory.append(tenant_id, user_id, context, answer)
                    return {"answer": answer, "iterations": i + 1, "history": history}

                # 3) execute tool
                tool_name = plan.get("tool")
                tool_args = plan.get("args", {})
                if tool_name not in (allowed_tools or []):
                    if allowed_tools and tool_name not in allowed_tools:
                        raise ValueError(f"tool not allowed: {tool_name}")

                tool = self._tools.get(tool_name)
                if not tool:
                    raise ValueError(f"unknown tool: {tool_name}")

                result = await tool.run(tenant_id, **tool_args)
                history.append({
                    "iteration": i,
                    "tool": tool_name,
                    "args": tool_args,
                    "result": result,
                })
                await self._bus.publish(AgentActionExecuted(
                    tenant_id=tenant_id,
                    iteration=i,
                    tool=tool_name,
                    success=True,
                ))

                # 4) feed result back into context
                context.append({
                    "role": "assistant",
                    "content": f"Tool {tool_name} returned: {json.dumps(result)[:2000]}",
                })

            return {"answer": "max iterations reached", "iterations": max_iterations, "history": history}

        except Exception:
            log.exception("agent.run.failed")
            raise

    @staticmethod
    def _build_plan_prompt(context: list[dict], tools: list[str]) -> str:
        return f"""You are a ReAct agent. Available tools: {tools}
Context: {context[-5:]}
Reply in JSON:
  {{"type": "action", "tool": "<name>", "args": {{...}}}}
  OR
  {{"type": "final", "answer": "<text>"}}
"""

    @staticmethod
    def _parse_json(text: str) -> dict:
        try:
            return json.loads(text)
        except json.JSONDecodeError:
            # extract first {...}
            start = text.find("{")
            end = text.rfind("}")
            if start >= 0 and end > start:
                return json.loads(text[start : end + 1])
            raise
```

---

# 9. Vector Database & pgvector Integration

## 9.1 ทำไม pgvector?

| เหตุผล | คำอธิบาย |
|---|---|
| **Single Source of Truth** | Vector อยู่ใน PostgreSQL เดียวกับธุรกิจ → Transaction เดียวกันได้ |
| **No Extra Infra** | ไม่ต้องดูแล Vector DB แยก (Pinecone/Weaviate/Qdrant) |
| **Full SQL Power** | JOIN + WHERE + Filter + Vector Search ในคำสั่งเดียว |
| **RLS + Multi-Tenant** | ใช้ Row-Level Security ที่มีอยู่ |
| **Backup/Recovery** | pgBackRest ทำงานได้ทันที |
| **Cost** | ประหยัดค่า SaaS และ Network |

## 9.2 การติดตั้งและตั้งค่า

```sql
-- 1) ติดตั้ง Extension
CREATE EXTENSION IF NOT EXISTS vector;

-- 2) ตรวจสอบ
SELECT extname, extversion FROM pg_extension WHERE extname = 'vector';
-- vector | 0.7.4
```

## 9.3 ตาราง Embedding (Generic Pattern)

```sql
CREATE TABLE public.rag_embeddings (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id   uuid NOT NULL,
    chunk_id    uuid NOT NULL REFERENCES public.rag_chunks(id) ON DELETE CASCADE,
    model       varchar(100) NOT NULL,
    dimension   int4 NOT NULL,
    vector      vector(1536) NOT NULL,
    created_at  timestamptz NOT NULL DEFAULT now()
);

-- HNSW index (แนะนำสำหรับ production)
CREATE INDEX ix_rag_embeddings_hnsw
    ON public.rag_embeddings
    USING hnsw (vector vector_cosine_ops)
    WITH (m = 16, ef_construction = 64);

-- RLS
ALTER TABLE public.rag_embeddings ENABLE ROW LEVEL SECURITY;
CREATE POLICY p_rag_embeddings_tenant ON public.rag_embeddings
    USING (tenant_id = current_setting('app.current_tenant', true)::uuid);
```

## 9.4 Index Comparison

| Index | Build Speed | Query Speed | Memory | Recall | ใช้เมื่อ |
|---|---|---|---|---|---|
| **Flat** (ไม่มี index) | ทันที | ช้ามาก | ต่ำ | 100% | < 10k vectors |
| **IVFFlat** | เร็ว | กลาง | กลาง | 90-95% | 100k–10M vectors |
| **HNSW** | ช้า | เร็ว | สูง | 95-99% | < 10M vectors, ต้องการ recall สูง |

## 9.5 Query Patterns

### 9.5.1 Cosine Similarity (Top-K)

```sql
-- TH: ค้นหา 10 chunks ที่ใกล้กับ query vector มากที่สุด
-- EN: find 10 nearest chunks
SELECT c.id, c.content,
       1 - (e.vector <=> $1::vector) AS similarity
FROM public.rag_chunks c
JOIN public.rag_embeddings e ON e.chunk_id = c.id
WHERE e.tenant_id = current_setting('app.current_tenant')::uuid
ORDER BY e.vector <=> $1::vector
LIMIT 10;
```

### 9.5.2 Hybrid Search (Vector + Keyword)

```sql
WITH vector_results AS (
    SELECT c.id, c.content, 1 - (e.vector <=> $1::vector) AS v_score
    FROM public.rag_chunks c
    JOIN public.rag_embeddings e ON e.chunk_id = c.id
    WHERE e.tenant_id = current_setting('app.current_tenant')::uuid
    ORDER BY e.vector <=> $1::vector
    LIMIT 50
),
keyword_results AS (
    SELECT id, content, ts_rank(to_tsvector('simple', content), plainto_tsquery($2)) AS k_score
    FROM public.rag_chunks
    WHERE tenant_id = current_setting('app.current_tenant')::uuid
      AND to_tsvector('simple', content) @@ plainto_tsquery($2)
    LIMIT 50
)
SELECT COALESCE(v.id, k.id) AS id,
       COALESCE(v.content, k.content) AS content,
       COALESCE(v.v_score, 0) * 0.7 + COALESCE(k.k_score, 0) * 0.3 AS combined_score
FROM vector_results v
FULL OUTER JOIN keyword_results k ON v.id = k.id
ORDER BY combined_score DESC
LIMIT 20;
```

### 9.5.3 MMR (Maximal Marginal Relevance)

```sql
-- ใช้ pgvector + Window Functions
WITH candidates AS (
    SELECT c.id, c.content, 1 - (e.vector <=> $1::vector) AS score, e.vector
    FROM public.rag_chunks c
    JOIN public.rag_embeddings e ON e.chunk_id = c.id
    WHERE e.tenant_id = current_setting('app.current_tenant')::uuid
    ORDER BY score DESC
    LIMIT 50
)
SELECT * FROM candidates
ORDER BY score - 0.3 * (vector <=> $1::vector)  -- MMR approximation
LIMIT 10;
```

## 9.6 Vector Store Module — Clean Architecture

```
modules/vector_store/
├── domain/
│   ├── entities.py           # Collection, Embedding
│   ├── value_objects.py      # DistanceMetric, IndexType
│   └── events.py             # VectorIndexed, VectorDeleted
├── application/
│   ├── interfaces.py         # VectorRepository
│   └── use_cases.py          # VectorUseCases
├── infrastructure/
│   ├── models.py             # pgvector SQLAlchemy
│   ├── repositories.py       # PgVectorRepository
│   └── index_manager.py      # HNSW/IVFFlat management
└── presentation/
    ├── routers.py
    └── schemas.py
```

## 9.7 Performance Tuning pgvector

| Parameter | คำแนะนำ | ผล |
|---|---|---|
| `maintenance_work_mem` | 2GB+ (ตอนสร้าง index) | Build เร็วขึ้น |
| `max_parallel_maintenance_workers` | 4 | Build parallel |
| `hnsw.ef_search` | 40–200 | ↑ = recall ↑, ช้าลง |
| `ivfflat.probes` | sqrt(lists) | ↑ = recall ↑ |
| `shared_buffers` | 25% RAM | Query เร็ว |

```sql
-- ตั้งตอน session
SET hnsw.ef_search = 100;
SET ivfflat.probes = 10;
```

---

# 10. Data Architecture (SQL + Vector + Time-Series + Object + Cache)

## 10.1 Data Layer Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    APPLICATION LAYER                        │
└───────┬──────────────┬──────────────┬──────────────┬────────┘
        │              │              │              │
        ▼              ▼              ▼              ▼
┌──────────────┐ ┌───────────┐ ┌──────────────┐ ┌──────────┐
│ PostgreSQL   │ │ pgvector  │ │ InfluxDB     │ │ Redis    │
│              │ │ (in PG)   │ │ (IoT TS)     │ │ (cache)  │
│ OLTP:        │ │           │ │              │ │          │
│ - users      │ │ embeddings│ │ sensor_read  │ │ - session│
│ - orders     │ │ doc_chunks│ │ metrics      │ │ - cooldown│
│ - invoices   │ │ vec_index │ │ kpi_series   │ │ - pubsub │
│ - inventory  │ │           │ │              │ │          │
│ - audit      │ │ HNSW idx  │ │ retention 90d│ │ TTL 1h   │
│ - outbox     │ │           │ │              │ │          │
└──────────────┘ └───────────┘ └──────────────┘ └──────────┘
        │
        ▼
┌──────────────────────────────────────────────────────────┐
│              Object Storage (MinIO/S3)                    │
│  Backups │ ML Models │ Documents │ Images │ MLflow Artifacts│
└──────────────────────────────────────────────────────────┘
```

## 10.2 PostgreSQL Schema Design

### 10.2.1 Schema Layout (Multi-Tenant)

```sql
-- Shared (cross-tenant)
public.tenants
public.users
public.audit_events
public.outbox_events

-- Per-tenant (schema-per-tenant)
tenant_{id}.customers
tenant_{id}.orders
tenant_{id}.invoices
tenant_{id}.rag_documents
tenant_{id}.rag_embeddings
```

### 10.2.2 Core Tables (Money Path)

```sql
CREATE TABLE tenant_xxx.orders (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number    varchar(50) NOT NULL UNIQUE,
    customer_id     uuid NOT NULL,
    status          varchar(20) NOT NULL DEFAULT 'DRAFT',
    subtotal        numeric(15,2) NOT NULL DEFAULT 0,
    tax_amount      numeric(15,2) NOT NULL DEFAULT 0,
    total_amount    numeric(15,2) NOT NULL DEFAULT 0,
    currency        varchar(3) NOT NULL DEFAULT 'THB',
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE tenant_xxx.invoices (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_number  varchar(50) NOT NULL UNIQUE,
    order_id        uuid NOT NULL REFERENCES tenant_xxx.orders(id),
    customer_id     uuid NOT NULL,
    status          varchar(20) NOT NULL DEFAULT 'DRAFT',
    issued_at       timestamptz,
    paid_at         timestamptz,
    total_amount    numeric(15,2) NOT NULL,
    created_at      timestamptz NOT NULL DEFAULT now()
);
```

### 10.2.3 Core Tables (Goods Path)

```sql
CREATE TABLE tenant_xxx.stock_movements (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id      uuid NOT NULL,
    warehouse_id    uuid NOT NULL,
    lot_id          uuid,
    movement_type   varchar(20) NOT NULL,
    qty             numeric(15,3) NOT NULL,
    reference       varchar(100) NOT NULL DEFAULT '',
    created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE tenant_xxx.stock_balances (
    product_id      uuid NOT NULL,
    warehouse_id    uuid NOT NULL,
    on_hand         numeric(15,3) NOT NULL DEFAULT 0,
    reserved        numeric(15,3) NOT NULL DEFAULT 0,
    available       numeric(15,3) NOT NULL DEFAULT 0,
    PRIMARY KEY (product_id, warehouse_id)
);
```

### 10.2.4 AI/RAG Tables

```sql
-- Already covered in Section 6.3.6 (rag_documents, rag_chunks, rag_embeddings)

CREATE TABLE public.llm_conversations (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       uuid NOT NULL,
    user_id         uuid NOT NULL,
    title           varchar(500) NOT NULL DEFAULT '',
    model_id        uuid,
    system_prompt   text NOT NULL DEFAULT '',
    status          varchar(20) NOT NULL DEFAULT 'ACTIVE',
    message_count   int4 NOT NULL DEFAULT 0,
    total_tokens    int4 NOT NULL DEFAULT 0,
    created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.llm_messages (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id uuid NOT NULL REFERENCES public.llm_conversations(id) ON DELETE CASCADE,
    tenant_id       uuid NOT NULL,
    role            varchar(20) NOT NULL,
    content         text NOT NULL DEFAULT '',
    tool_calls      jsonb NOT NULL DEFAULT '[]'::jsonb,
    tokens_input    int4 NOT NULL DEFAULT 0,
    tokens_output   int4 NOT NULL DEFAULT 0,
    latency_ms      int4 NOT NULL DEFAULT 0,
    created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.llm_usage_logs (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       uuid NOT NULL,
    user_id         uuid NOT NULL,
    model_id        uuid,
    conversation_id uuid,
    tokens_input    int4 NOT NULL DEFAULT 0,
    tokens_output   int4 NOT NULL DEFAULT 0,
    cost_usd        numeric(12,8) NOT NULL DEFAULT 0,
    source          varchar(50) NOT NULL DEFAULT 'chat',
    created_at      timestamptz NOT NULL DEFAULT now()
);
```

### 10.2.5 IoT Tables

```sql
CREATE TABLE public.iot_devices (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       uuid NOT NULL,
    serial_no       varchar(100) NOT NULL UNIQUE,
    device_type     varchar(50) NOT NULL, -- sensor|io|robot
    name            varchar(200) NOT NULL DEFAULT '',
    status          varchar(20) NOT NULL DEFAULT 'active',
    metadata        jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.iot_alarm_configs (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       uuid NOT NULL,
    device_id       uuid NOT NULL REFERENCES public.iot_devices(id),
    status_warning  numeric(12,3) NOT NULL DEFAULT 0,
    status_alert    numeric(12,3) NOT NULL DEFAULT 0,
    recovery_warning numeric(12,3) NOT NULL DEFAULT 0,
    recovery_alert  numeric(12,3) NOT NULL DEFAULT 0,
    cooldown_seconds int4 NOT NULL DEFAULT 600,
    channels        jsonb NOT NULL DEFAULT '[]'::jsonb
);

CREATE TABLE public.iot_notification_logs (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       uuid NOT NULL,
    device_id       uuid NOT NULL,
    alarm_status    int4 NOT NULL,     -- 1..5
    channel         varchar(50) NOT NULL,
    status          varchar(20) NOT NULL DEFAULT 'PENDING',
    sent_at         timestamptz,
    error           text NOT NULL DEFAULT ''
);
```

## 10.3 Time-Series Strategy (InfluxDB / TimescaleDB)

### 10.3.1 TimescaleDB (PostgreSQL extension) — แนะนำ

```sql
CREATE EXTENSION IF NOT EXISTS timescaledb;

CREATE TABLE public.sensor_readings (
    ts              timestamptz NOT NULL,
    tenant_id       uuid NOT NULL,
    device_id       uuid NOT NULL,
    metric          varchar(50) NOT NULL,
    value           numeric(15,4) NOT NULL
);

-- Convert to hypertable
SELECT create_hypertable('public.sensor_readings', 'ts', chunk_time_interval => INTERVAL '1 day');

-- Retention (ลบข้อมูลเก่า 90 วัน)
SELECT add_retention_policy('public.sensor_readings', INTERVAL '90 days');

-- Continuous aggregate (roll-up รายชั่วโมง)
CREATE MATERIALIZED VIEW public.sensor_readings_hourly
WITH (timescaledb.continuous) AS
SELECT time_bucket('1 hour', ts) AS bucket,
       tenant_id, device_id, metric,
       avg(value) AS avg_value,
       min(value) AS min_value,
       max(value) AS max_value,
       count(*) AS sample_count
FROM public.sensor_readings
GROUP BY bucket, tenant_id, device_id, metric;
```

### 10.3.2 Alternative: InfluxDB

- Retention policy 90 days
- Continuous queries สำหรับ roll-up
- Grafana integration

## 10.4 Cache Strategy (Redis)

| Use Case | Key Pattern | TTL |
|---|---|---|
| Session | `session:{user_id}` | 24h |
| JWT Blacklist | `jwt:blacklist:{jti}` | 24h |
| Cooldown | `cooldown:{device_id}:{status}` | 600s |
| Idempotency | `idem:{key}` | 24h |
| Retrieval Cache | `rag:retrieval:{tenant}:{query_hash}` | 1h |
| Rate Limit | `rate:{tenant}:{user}` | 60s |
| Pub/Sub | `events:{channel}` | – |

## 10.5 Object Storage Layout

```
s3://gridcare-bucket/
├── tenants/{tenant_id}/
│   ├── documents/          # PDF, DOCX ที่ ingest
│   ├── images/             # รูปจาก IoT
│   ├── models/             # ML artifacts
│   ├── reports/            # PDF reports
│   └── exports/
├── backups/                # pgBackRest
├── mlflow/                 # MLflow artifacts
└── public/                 # Static assets
```

---

# 11. API Design & Communication Patterns

## 11.1 API Patterns Overview

| Pattern | Use Case | Technology |
|---|---|---|
| **REST** | CRUD, Query | FastAPI + OpenAPI 3.0 |
| **WebSocket** | Real-time dashboard, notifications | python-socketio |
| **SSE** | LLM streaming | FastAPI StreamingResponse |
| **gRPC** | Internal service-to-service | grpcio + protobuf |
| **MQTT** | IoT device telemetry | aiomqtt |
| **Kafka** | Event streaming | aiokafka / confluent-kafka |
| **GraphQL** | Flexible frontend query | Strawberry / Ariadne (optional) |

## 11.2 API Versioning Strategy

```
/api/v1/...
/api/v2/...                  # Breaking change
/rag/v1/documents            # Module-scoped
/ai/v1/chat                  # AI-scoped
/iot/v1/devices              # IoT-scoped
```

## 11.3 REST API Design — 5 Rules

1. **Resource-based** — `/invoices/{id}`, ไม่ใช่ `/getInvoice`
2. **HTTP verbs** — GET/POST/PUT/PATCH/DELETE
3. **Status codes** — 200/201/204/400/401/403/404/409/422/500
4. **Pagination** — `?page=1&size=50` หรือ Keyset
5. **Idempotency** — `Idempotency-Key` header บน mutating endpoints

## 11.4 Error Response (Canonical)

```json
{
  "code": "INVOICE_NOT_FOUND",
  "message": "Invoice {id} not found",
  "details": {"invoice_id": "..."},
  "trace_id": "abc-123",
  "timestamp": "2026-11-07T10:00:00Z"
}
```

## 11.5 WebSocket Pattern

```python
# modules/iot/presentation/websocket.py
import socketio

sio = socketio.AsyncServer(async_mode="asgi", cors_allowed_origins="*")


@sio.event
async def connect(sid, environ, auth):
    token = (auth or {}).get("token")
    if not _verify_jwt(token):
        raise ConnectionRefusedError("invalid token")
    tenant_id = _extract_tenant(token)
    await sio.enter_room(sid, f"tenant:{tenant_id}")


@sio.event
async def subscribe_device(sid, data):
    device_id = data["device_id"]
    await sio.enter_room(sid, f"device:{device_id}")


async def broadcast_alarm(tenant_id: str, alarm: dict) -> None:
    await sio.emit(
        "iot.alarm",
        alarm,
        room=f"tenant:{tenant_id}",
    )
```

## 11.6 LLM Streaming (SSE)

```python
# modules/llm_gateway/presentation/stream.py
from fastapi import APIRouter
from fastapi.responses import StreamingResponse

router = APIRouter()


@router.post("/chat/stream")
async def chat_stream(payload: ChatRequest, uc=Depends(get_llm_uc)):
    async def event_gen():
        async for chunk in uc.chat_stream(
            messages=payload.messages,
            model_name=payload.model,
        ):
            yield f"data: {json.dumps(chunk)}\n\n"
        yield "data: [DONE]\n\n"

    return StreamingResponse(event_gen(), media_type="text/event-stream")
```

## 11.7 Event Schema Versioning

```
Topic: money.invoice.issued
Event: InvoiceIssued.v1 (current)
       InvoiceIssued.v2 (breaking change → new topic)
```

---

# 12. Observability & Monitoring

## 12.1 3 Pillars + AI Metrics

```
┌──────────────────────────────────────────────────────────┐
│                    OBSERVABILITY                         │
├────────────────┬──────────────────┬──────────────────────┤
│ METRICS        │ LOGS             │ TRACES               │
│ Prometheus     │ Loki/ELK         │ Tempo/Jaeger         │
│                │                  │                      │
│ - Business     │ - Structured     │ - Distributed        │
│ - Technical    │ - PII-masked     │ - OpenTelemetry      │
│ - AI           │ - Audit          │ - Service map        │
└────────────────┴──────────────────┴──────────────────────┘
                          +
┌──────────────────────────────────────────────────────────┐
│                 AI-SPECIFIC METRICS                      │
│  Token usage │ Cost │ Latency │ Drift │ Hallucination   │
│  Retrieval precision │ Rerank score │ Agent iterations  │
└──────────────────────────────────────────────────────────┘
```

## 12.2 Metric Taxonomy

| Layer | Metric | Source |
|---|---|---|
| **Infra** | CPU, Memory, Disk, Network | node_exporter |
| **Database** | pg_up, TPS, Connections, Cache hit, XID | postgres_exporter |
| **Business** | Order rate, Revenue, Invoice count | Custom (textfile) |
| **AI/LLM** | Token usage, Cost, LLM latency | llm_gateway exporter |
| **RAG** | Retrieval latency, Hit rate, Precision | rag exporter |
| **IoT** | Sensor rate, Alarm count, Cooldown hits | iot exporter |
| **Events** | Kafka lag, Consumer rate, DLQ size | kafka_exporter |

## 12.3 SLI/SLO/Error Budget

| SLI | SLO | Error Budget |
|---|---|---|
| Availability | 99.9% | 43.8 min/month |
| API p95 latency | < 500ms | – |
| LLM p95 latency | < 3s | – |
| RAG retrieval | > 90% relevant | – |
| IoT event latency | < 1s | – |
| Event processing | 99.99% | 4.3 min/month |

## 12.4 Alert Rules — 4 Tiers

```yaml
# Tier 1: Infrastructure
- alert: PostgresDown
  expr: pg_up == 0
  for: 1m
  labels: {severity: critical, owner: dba}

# Tier 2: Business
- alert: OrderRateDrop
  expr: rate(business_orders_created[5m]) < 10
  for: 15m
  labels: {severity: warning, owner: business}

# Tier 3: AI
- alert: LLMErrorRateHigh
  expr: |
    rate(llm_requests_total{status="error"}[5m])
    / rate(llm_requests_total[5m]) > 0.05
  for: 5m
  labels: {severity: warning, owner: ai}

- alert: ModelDriftDetected
  expr: ai_model_drift_score > 0.3
  for: 1h
  labels: {severity: warning, owner: mlops}

- alert: AgentLoopExceeded
  expr: rate(agent_max_iterations_reached[5m]) > 0
  for: 5m
  labels: {severity: warning, owner: ai}

# Tier 4: Events
- alert: KafkaConsumerLagHigh
  expr: kafka_consumer_lag > 10000
  for: 10m
  labels: {severity: warning, owner: devops}

- alert: DLQSizeGrowing
  expr: increase(kafka_dlq_messages_total[1h]) > 10
  for: 10m
  labels: {severity: critical, owner: devops}
```

## 12.5 Trace Propagation (OpenTelemetry)

```python
# packages/observability/tracing.py
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor


def setup_tracing(app, service_name: str, otlp_endpoint: str) -> None:
    provider = TracerProvider()
    provider.add_span_processor(
        BatchSpanProcessor(OTLPSpanExporter(endpoint=otlp_endpoint))
    )
    trace.set_tracer_provider(provider)
    FastAPIInstrumentor.instrument_app(app)
```

## 12.6 Structured Logging (structlog)

```python
# packages/observability/logging.py
import structlog


def setup_logging(service_name: str) -> None:
    structlog.configure(
        processors=[
            structlog.contextvars.merge_contextvars,
            structlog.processors.add_log_level,
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.processors.StackInfoRenderer(),
            structlog.processors.format_exc_info,
            structlog.processors.JSONRenderer(),
        ],
        wrapper_class=structlog.make_filtering_bound_logger(20),  # INFO
        context_class=dict,
        logger_factory=structlog.PrintLoggerFactory(),
        cache_logger_on_first_use=True,
    )
    structlog.contextvars.bind_contextvars(service=service_name)
```

---

# 13. Security & Compliance

## 13.1 CIA Triad + AI Extension

| หลัก | ระบบนี้ | AI Extension |
|---|---|---|
| **Confidentiality** | TLS, RLS, AES-256 | PII masking ก่อนส่ง LLM |
| **Integrity** | Digital signature, Audit | Prompt/response logging |
| **Availability** | HA, Replication | LLM fallback provider |

## 13.2 Authentication & Authorization

```
┌──────────────────────────────────────────────────────┐
│           AUTH LAYER (Nested JWT)                    │
├──────────────────────────────────────────────────────┤
│  Layer 1: JWS (Ed25519) — sign claims               │
│  Layer 2: JWE (ECDH-ES + A256GCM) — encrypt         │
│  Cookie: HTTP-only, Secure, SameSite=Strict         │
│  RBAC: role + path allowlist (2 gates)              │
│  API Key: HMAC-SHA256 + constant-time compare       │
└──────────────────────────────────────────────────────┘
```

## 13.3 AI-Specific Security

| ความเสี่ยง | การป้องกัน |
|---|---|
| **Prompt Injection** | System prompt แข็ง + input sanitize + guardrails |
| **PII Leakage** | Mask PII ก่อน embed/send LLM (Presidio) |
| **Data Poisoning** | Validate training data + source tracking |
| **Model Theft** | Encrypt model artifacts + access control |
| **Jailbreak** | Guardrails AI, LlamaGuard |
| **Hallucination** | RAG + citation + confidence score + human-in-loop |
| **Token DoS** | Rate limit + token budget + cost alert |
| **Vector Poisoning** | Validate ingest + audit trail + RLS |

## 13.4 Compliance Checklist

- [ ] PDPA / GDPR — consent, right to delete, breach notification
- [ ] RLS เปิดทุกตาราง multi-tenant
- [ ] pgAudit เปิด log ทุก DDL/ROLE
- [ ] PII masking ใน log (Loki)
- [ ] Encryption at rest (LUKS/MinIO SSE)
- [ ] Encryption in transit (TLS 1.2+)
- [ ] Secret management (Vault/K8s Secret)
- [ ] Model card + data card สำหรับ AI
- [ ] EU AI Act risk classification
- [ ] Human-in-the-loop สำหรับ critical decision

---

# 14. Deployment Architecture

## 14.1 Phase 1 — Modular Monolith (Month 1–6)

```
┌──────────────────────────────────────────────────────┐
│  Docker Compose / K3s                                │
├──────────────────────────────────────────────────────┤
│  ┌────────────┐  ┌────────────┐  ┌────────────┐     │
│  │ core-api   │  │ ai-api     │  │ iot-api    │     │
│  │ :8000      │  │ :8001      │  │ :8002      │     │
│  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘     │
│        └───────────────┼────────────────┘            │
│                        │                             │
│  ┌─────────────┐  ┌────▼──────┐  ┌─────────────┐    │
│  │ PostgreSQL  │  │  Kafka    │  │  Redis      │    │
│  │ + pgvector  │  │           │  │             │    │
│  └─────────────┘  └───────────┘  └─────────────┘    │
│  ┌─────────────┐  ┌───────────┐  ┌─────────────┐    │
│  │ MinIO       │  │ Prometheus│  │ Grafana     │    │
│  └─────────────┘  └───────────┘  └─────────────┘    │
└──────────────────────────────────────────────────────┘
```

## 14.2 Phase 2 — Extract Critical Services (Month 7–12)

- แยก LLM Gateway ออกเป็น service
- แยก IoT เป็น service
- ใช้ Kafka ระหว่าง services

## 14.3 Phase 3 — Microservices (Month 13+)

- Extract ตาม Bounded Context
- Service Mesh (Istio/Linkerd)
- Per-service database

## 14.4 Docker Compose (Phase 1)

```yaml
version: "3.9"

services:
  postgres:
    image: pgvector/pgvector:pg17
    environment:
      POSTGRES_USER: appuser
      POSTGRES_PASSWORD: ${PG_PASSWORD}
      POSTGRES_DB: platform
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports: ["6379:6379"]

  kafka:
    image: confluentinc/cp-kafka:7.7.0
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:9092
      KAFKA_AUTO_CREATE_TOPICS_ENABLE: "true"
    depends_on: [zookeeper]

  zookeeper:
    image: confluentinc/cp-zookeeper:7.7.0
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181

  minio:
    image: minio/minio:latest
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: ${MINIO_USER}
      MINIO_ROOT_PASSWORD: ${MINIO_PASSWORD}
    ports: ["9000:9000", "9001:9001"]
    volumes: [miniodata:/data]

  core-api:
    build: {context: ., dockerfile: apps/core-api/Dockerfile}
    command: uvicorn apps.core_api.main:app --host 0.0.0.0 --port 8000
    environment:
      DATABASE_URL: postgresql+asyncpg://appuser:${PG_PASSWORD}@postgres:5432/platform
      REDIS_URL: redis://redis:6379
      KAFKA_BROKER: kafka:9092
    depends_on: [postgres, redis, kafka]

  ai-api:
    build: {context: ., dockerfile: apps/ai-api/Dockerfile}
    command: uvicorn apps.ai_api.main:app --host 0.0.0.0 --port 8001
    environment:
      DATABASE_URL: postgresql+asyncpg://appuser:${PG_PASSWORD}@postgres:5432/platform
      REDIS_URL: redis://redis:6379
      KAFKA_BROKER: kafka:9092
      OPENAI_API_KEY: ${OPENAI_API_KEY}
      ANTHROPIC_API_KEY: ${ANTHROPIC_API_KEY}
    depends_on: [postgres, redis, kafka]

  iot-api:
    build: {context: ., dockerfile: apps/iot-api/Dockerfile}
    command: uvicorn apps.iot_api.main:app --host 0.0.0.0 --port 8002
    environment:
      DATABASE_URL: postgresql+asyncpg://appuser:${PG_PASSWORD}@postgres:5432/platform
      REDIS_URL: redis://redis:6379
      KAFKA_BROKER: kafka:9092
      MQTT_BROKER_HOST: mosquitto
    depends_on: [postgres, redis, kafka, mosquitto]

  mosquitto:
    image: eclipse-mosquitto:2
    ports: ["1883:1883"]

  prometheus:
    image: prom/prometheus:latest
    ports: ["9090:9090"]
    volumes:
      - ./deploy/prometheus.yml:/etc/prometheus/prometheus.yml
      - ./deploy/rules:/etc/prometheus/rules

  grafana:
    image: grafana/grafana:latest
    ports: ["3000:3000"]
    environment:
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_PASSWORD}

  alertmanager:
    image: prom/alertmanager:latest
    ports: ["9093:9093"]
    volumes:
      - ./deploy/alertmanager.yml:/etc/alertmanager/alertmanager.yml

volumes:
  pgdata: {}
  miniodata: {}
```

## 14.5 CI/CD Pipeline

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: {python-version: "3.11"}
      - run: pip install ruff mypy
      - run: ruff check .
      - run: mypy packages modules apps

  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: pgvector/pgvector:pg17
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: test_db
        ports: ["5432:5432"]
    steps:
      - uses: actions/checkout@v4
      - run: pip install -r requirements.txt
      - run: pytest tests/ -v --cov

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: SAST
        run: pip install bandit && bandit -r modules packages
      - name: Dependency scan
        run: pip install safety && safety check
```

---

# 15. Roadmap & Migration Path

## 15.1 6-Phase Roadmap (12 เดือน)

| Phase | เดือน | ผลลัพธ์ | ทีม |
|---|---|---|---|
| **0: Foundation** | 0 | Architecture design, Tech stack decision, Team setup | All |
| **1: Core ERP** | 1–3 | Money Path + Goods Path + Auth | Backend |
| **2: Observability** | 3–4 | Prometheus + Grafana + Alert + Backup | DevOps |
| **3: AI/LLM** | 4–6 | LLM Gateway + RAG + Vector Store + Chatbot | AI |
| **4: IoT** | 6–8 | MQTT + Alarm + Notification + WebSocket | IoT |
| **5: ML/Deep Learning** | 8–10 | YOLO + Training + Drift | ML |
| **6: Scale & Extract** | 10–12 | Extract microservices + Service Mesh | All |

## 15.2 Migration Path: Monolith → Modular → Microservices

```
Month 1-6:  Modular Monolith (1 deploy, 15 modules)
            ↓
Month 7-12: Extract 3-5 critical modules
            (LLM, IoT, Report)
            ↓
Month 13+:  Full microservices ตาม Bounded Context
            (เมื่อจำเป็น — ตาม team size & scale)
```

## 15.3 Acceptance Criteria per Phase

### Phase 1: Core ERP
- [ ] Money Path: Invoice = sum(lines) + VAT
- [ ] Goods Path: Stock in − Stock out = Stock on hand
- [ ] Auth: JWT + Refresh + RBAC
- [ ] Audit: ทุก DDL log
- [ ] Migration: Alembic ทำงาน
- [ ] Test coverage: ≥ 80%

### Phase 2: Observability
- [ ] Prometheus scrape 100% targets up
- [ ] Grafana dashboard ครบ (DBA + DevOps + Business)
- [ ] Alert 23 rules + runbook
- [ ] Restore test ผ่าน (RTO < 30 min)
- [ ] Backup: RPO ≤ 5 min

### Phase 3: AI/LLM
- [ ] LLM Gateway: 3 providers working
- [ ] RAG: retrieval > 90% relevant
- [ ] Vector Store: HNSW index < 100ms p95
- [ ] Chatbot: end-to-end ผ่าน
- [ ] Cost tracking: token usage 100% accurate

### Phase 4: IoT
- [ ] MQTT 10,000 msg/s
- [ ] Alarm: 5 states + cooldown
- [ ] Notification: 6 channels
- [ ] WebSocket: < 1s latency
- [ ] Sensor data → InfluxDB

### Phase 5: ML
- [ ] YOLO train + inference
- [ ] Model registry + versioning
- [ ] Drift detection + alert
- [ ] mAP ≥ 0.85

### Phase 6: Scale
- [ ] Extract 3 modules → microservices
- [ ] Service mesh (Istio)
- [ ] Per-service database
- [ ] Load test: 10,000 req/s

---

# 16. Templates & Checklists

## 16.1 Module Creation Checklist

- [ ] Domain: entities, value_objects, enums, events, policies, exceptions
- [ ] Application: interfaces, use_cases, mappers, exceptions, utils
- [ ] Infrastructure: models, repositories, caches, services, outbox, vector_repo
- [ ] Presentation: routers, schemas, docs, dependencies, consumers, event_handlers
- [ ] Migrations: Alembic revision
- [ ] Tests: unit, integration, property-based
- [ ] Docs: README, OpenAPI metadata, ADR
- [ ] Observability: metrics, logs, traces
- [ ] Security: RLS, auth, input validation
- [ ] CI: passes ruff, mypy, pytest

## 16.2 PR Checklist

- [ ] Change ตรง scope
- [ ] Diff สะอาด (< 400 LOC)
- [ ] Test ผ่าน (unit + integration)
- [ ] ไม่มี secret ใน Code
- [ ] ไม่มี PII ใน log
- [ ] Migration reversible
- [ ] API versioned
- [ ] Docs updated
- [ ] Observability เพิ่ม metric
- [ ] Security: input validation + RLS

## 16.3 Architecture Decision Record (ADR) Template

```markdown
# ADR-{number}: {title}

## Status
Proposed / Accepted / Deprecated / Superseded

## Context
{situation and problem}

## Decision
{what we decided}

## Consequences
### Positive
- ...
### Negative
- ...
### Risks
- ...

## Alternatives Considered
1. {alt 1} — rejected because ...
2. {alt 2} — rejected because ...

## References
- {link}
```

## 16.4 Runbook Template

```markdown
# Runbook: {Alert Name}

## Alert
- Name: {alert_name}
- Severity: {critical|warning|info}
- Metric: {promql}
- Threshold: {value}
- Owner: {team/person}
- Runbook URL: {link}

## Symptoms
- ...

## Diagnosis Steps
1. {command} → {expected output}
2. ...

## Resolution Steps
1. {command} → {expected}
2. ...

## Rollback
- {command}

## Escalation
- L1 (5 min): {person}
- L2 (15 min): {person}
- L3 (30 min): {person}

## Related Alerts
- {alert 1} (inhibited by this)

## Last Reviewed
{date} by {person}
```

## 16.5 Incident Record Template

```markdown
# Incident Record

## Basic Info
- **ID:** INC-YYYY-MM-DD-NNN
- **Severity:** critical/warning/info
- **Started:** YYYY-MM-DD HH:MM:SS
- **Detected:** YYYY-MM-DD HH:MM:SS
- **Resolved:** YYYY-MM-DD HH:MM:SS
- **Duration:** X minutes

## Metrics
- RTO actual: X minutes
- RPO actual: 0 records
- Users affected: N
- Failed transactions: N

## Timeline
- HH:MM:SS — Alert fired
- HH:MM:SS — On-call acknowledged
- HH:MM:SS — Root cause identified
- HH:MM:SS — Fixed
- HH:MM:SS — Verified

## Root Cause
{description}

## Actions Taken
1. ...

## PSR
- Date: YYYY-MM-DD
- Action Items:
  - [ ] {action} — Owner: {person} — Due: {date}
```

## 16.6 KPI Dashboard Template

| KPI | Target | Actual | Trend |
|---|---|---|---|
| Availability | 99.9% | 99.95% | ↑ |
| RTO | < 30 min | 31s | ↑ |
| RPO | 0 | 0 | → |
| p95 latency | < 500ms | 320ms | ↑ |
| LLM cost/month | < $500 | $420 | → |
| RAG relevance | > 90% | 92% | ↑ |
| IoT event latency | < 1s | 0.8s | ↑ |
| Test coverage | ≥ 80% | 85% | ↑ |

## 16.7 Daily Report Template

```markdown
# Daily Report — YYYY-MM-DD

## On My Plate
- {task 1}
- {task 2}

## Yesterday
- Done: {list}
- In progress: {list}
- Blocked: {list}

## Obstacles
- ...

## Today's Plan
- ...

## Need Help With
- ...

## Delivery Plan
- ...
```

---

# 17. ข้อควรระวัง/ข้อห้าม/แนวทางแก้ปัญหา

## 17.1 ข้อห้าม 10 ข้อ (Prohibitions)

| # | ข้อห้าม | เหตุผล |
|---|---|---|
| 1 | ❌ ส่ง PII ตรง ๆ เข้า LLM | ละเมิด PDPA/GDPR |
| 2 | ❌ Deploy โดยไม่มี Rollback Plan | ถ้าล้มจะกู้ยาก |
| 3 | ❌ ใช้ `SELECT *` ใน ORM | เปลือง Memory + Network |
| 4 | ❌ Commit secret / API key | รั่วออก Git history |
| 5 | ❌ ปิด RLS เพื่อความสะดวก | Multi-tenant leak |
| 6 | ❌ Skip Test Coverage < 80% | Bug หลุด Production |
| 7 | ❌ ใช้ `Float` กับเงิน | Rounding error |
| 8 | ❌ `pgvector` scan ทั้ง Table บน Production | Query timeout |
| 9 | ❌ Deploy Friday เย็น | ไม่มีทีมแก้ |
| 10 | ❌ ปิด Monitoring / Alert | ไม่เห็นปัญหา |

## 17.2 ข้อควรระวัง 10 ข้อ (Cautions)

| # | ข้อควรระวัง | แนวทางแก้ |
|---|---|---|
| 1 | LLM cost บานปลาย | Token budget + cache + model selection |
| 2 | Vector index ช้าเมื่อข้อมูลเยอะ | Partition + HNSW tune + retention |
| 3 | Agent loop ไม่จบ | Max iterations + timeout + guardrails |
| 4 | Kafka lag สะสม | Consumer scale + DLQ alert |
| 5 | pgvector dimension ไม่ตรง | Lock dimension ใน schema |
| 6 | Cache stampede | Redis lock + jitter |
| 7 | Prompt injection | Guardrails + input sanitize |
| 8 | RAG hallucination | Citation + confidence + human-in-loop |
| 9 | Drift ของ ML model | Evidently + retrain trigger |
| 10 | Multi-tenant data leak | RLS + test + audit |

## 17.3 แนวทางแก้ปัญหาเมื่อเกิดเหตุ (Troubleshooting Matrix)

| อาการ | Root Cause | Solution |
|---|---|---|
| LLM ช้า | Provider rate limit | Fallback + exponential backoff |
| RAG ไม่ตรง | Chunking ผิด / embedding ไม่ดี | ปรับ chunk config + เปลี่ยน model |
| Vector search ช้า | ไม่มี index / index ผิด | สร้าง HNSW + tune ef_search |
| Agent loop ไม่จบ | Prompt ไม่ชัด / tool ไม่ตอบ | ปรับ prompt + max iteration |
| Kafka lag | Consumer ไม่ทัน | Scale consumer + partition |
| Outbox โต | Worker ตาย | Restart + alert + metric |
| Model drift | ข้อมูลเปลี่ยน | Retrain + A/B test |
| pgvector OOM | HNSW memory | ลด m / ใช้ IVFFlat / แยก table |
| Token cost พุ่ง | Prompt ยาว / cache ไม่ทำงาน | Prompt compress + cache + model selection |
| Multi-tenant leak | RLS ปิด | Enable RLS + test + audit |

---

# ✅ สรุปสถาปัตยกรรม Unified AI-Enabled Event-Driven Platform

## Core Deliverables

| # | Deliverable | สถานะ |
|---|---|---|
| 1 | Design Principles 12 ข้อ | ✅ |
| 2 | 15 Bounded Contexts (DDD) | ✅ |
| 3 | 6-Layer Architecture | ✅ |
| 4 | Clean Architecture + DDD Template (4 layers × 4 files) | ✅ |
| 5 | Event-Driven (Kafka + Outbox + Idempotent Consumer) | ✅ |
| 6 | LLM Gateway (3 providers, fallback, cost tracking) | ✅ |
| 7 | RAG Pipeline (chunk → embed → retrieve → rerank → answer) | ✅ |
| 8 | pgvector Integration (HNSW index, hybrid search, RLS) | ✅ |
| 9 | Deep Learning (YOLO + MLflow + Drift) | ✅ |
| 10 | AI Agent (ReAct loop + tools + guardrails) | ✅ |
| 11 | Multi-Tenant Data (schema-per-tenant + RLS) | ✅ |
| 12 | 5 API patterns (REST, WebSocket, SSE, gRPC, MQTT, Kafka) | ✅ |
| 13 | Observability (Metrics + Logs + Traces + AI metrics) | ✅ |
| 14 | Security (Nested JWT + RLS + Guardrails + PII masking) | ✅ |
| 15 | Deployment (3 phases: Monolith → Modular → Microservices) | ✅ |
| 16 | 12-Month Roadmap | ✅ |
| 17 | Templates (Module, PR, ADR, Runbook, Incident, KPI, Daily) | ✅ |
| 18 | Checklists (16 หัวข้อ) | ✅ |
| 19 | ข้อห้าม/ข้อควรระวัง/แนวทางแก้ปัญหา | ✅ |

## หลักการจำ 3 บรรทัด

> **1. Domain-Driven:** ออกแบบตามธุรกิจ 15 Bounded Contexts แยกชัด  
> **2. Event-Driven:** ทุกการเปลี่ยนแปลงคือ Event — Replay ได้, Audit ได้  
> **3. AI-First:** LLM/RAG/Agent/Deep Learning เป็น citizens ชั้นแรก ไม่ใช่ส่วนเสริม

## คำคมส่งท้าย

> **"สถาปัตยกรรมที่ดีไม่ใช่สถาปัตยกรรมที่ซับซ้อนที่สุด แต่เป็นสถาปัตยกรรมที่ทีมสามารถดูแลได้ 5 ปีข้างหน้า และเพิ่ม AI ได้โดยไม่ต้อง Rewrite"**