# 📘 เล่ม 3: คู่มือ Solution Architect / Tech Lead
## Financial & Accounting Technology Solutions

---

# 📑 สารบัญ (Table of Contents)

- [1. บทนำ (Introduction)](#1-บทนำ-introduction)
- [2. บทนิยาม (Definitions)](#2-บทนิยาม-definitions)
- [3. บทบาทและความรับผิดชอบ (Roles & Responsibilities)](#3-บทบาทและความรับผิดชอบ-roles--responsibilities)
- [4. ความรู้พื้นฐานที่ต้องมี (Prerequisites)](#4-ความรู้พื้นฐานที่ต้องมี-prerequisites)
- [5. โครงสร้างการทำงาน (Team Structure)](#5-โครงสร้างการทำงาน-team-structure)
- [6. หลักการทำงาน (Concept)](#6-หลักการทำงาน-concept)
- [7. Workflow และ Dataflow](#7-workflow-และ-dataflow)
- [8. System Design Standards](#8-system-design-standards)
- [9. Integration Patterns](#9-integration-patterns)
- [10. Architecture Decision Record (ADR)](#10-architecture-decision-record-adr)
- [11. Security & Compliance Architecture](#11-security--compliance-architecture)
- [12. Observability & Scalability](#12-observability--scalability)
- [13. Case Study](#13-case-study)
- [14. KPI & SMART Criteria](#14-kpi--smart-criteria)
- [15. คู่มือการทดสอบ (Architecture Validation & Review)](#15-คู่มือการทดสอบ-architecture-validation--review)
- [16. คู่มือการใช้งาน (Architect Guide)](#16-คู่มือการใช้งาน-architect-guide)
- [17. คู่มือการบำรุงรักษา (Maintenance Guide)](#17-คู่มือการบำรุงรักษา-maintenance-guide)
- [18. คู่มือการขยาย/แก้ไข (Extension Guide)](#18-คู่มือการขยายแก้ไข-extension-guide)
- [19. Code Review & PR Checklist สำหรับ Architect](#19-code-review--pr-checklist-สำหรับ-architect)
- [20. Root Cause Analysis (Architecture-Level)](#20-root-cause-analysis-architecture-level)
- [21. ภาคผนวก: คำศัพท์สองภาษา และเอกสารอ้างอิง](#21-ภาคผนวก-คำศัพท์สองภาษา-และเอกสารอ้างอิง)

---

# 1. บทนำ (Introduction)

## 1.1 ภาพรวมคืออะไร (What is it?)

คู่มือนี้สำหรับ **Solution Architect** และ **Tech Lead** ในทีม **Financial & Accounting Technology Solutions — ** ที่รับผิดชอบ:

- ออกแบบ **System Architecture** ที่ตอบโจทย์ธุรกิจการเงินและบัญชี
- ตัดสินใจเรื่อง **Application, Data, Integration, Security, Infrastructure**
- บันทึกเหตุผลการตัดสินใจ (ADR)
- นำและ Mentor ทีม Developer
- Review Architecture และ Technical Design

Solution Architect = ผู้ออกแบบสถาปัตยกรรมระดับระบบ
Tech Lead = ผู้นำทีมเทคนิคระดับ Implementation

## 1.2 คำนำ (Preface)

ระบบ FinTech & Accounting ของ  มีความซับซ้อนสูง:

- Integration กับ Oracle ERP, Databricks, Power BI, SFTP, Email, Webhooks
- ข้อมูลการเงินต้องการความถูกต้อง 100% และ Audit Trail
- ผู้ใช้หลายกลุ่ม: Finance, Accounting, Management
- Compliance: SOX, PDPA, ISO 27001
- SLA ต้องการ Uptime ≥ 99.9% และ MTTR ≤ 30 นาที

Architect จึงต้อง баланระหว่าง **Business Value** กับ **Technical Quality** และบันทึก **Trade-offs** ทุกครั้ง

## 1.3 วัตถุประสงค์ (Objectives)

1. กำหนดมาตรฐานการออกแบบ System Architecture ของทีม
2. ลด Technical Debt และ Over-engineering
3. ทำให้การตัดสินใจมีเหตุผลและตรวจสอบย้อนหลังได้ผ่าน ADR
4. สร้างความสอดคล้องระหว่าง Architecture และ Business Requirement
5. ยกระดับคุณภาพการ Review และ Mentor ทีม

## 1.4 เป้าหมาย (Goals)

- ADR Completeness 100% ของการตัดสินใจสำคัญ
- Architecture Review Pass Rate ≥ 90%
- Technical Debt Ratio < 5%
- System Uptime ≥ 99.9%
- MTTR ≤ 30 นาที
- Integration Defect < 1% ของจำนวนธุรกรรม

---

# 2. บทนิยาม (Definitions)

| คำ | ความหมาย |
|----|----------|
| **Solution Architecture** | การออกแบบระบบโดยรวมที่ตอบโจทย์ธุรกิจ ครอบคลุม App/Data/Integration/Security/Infra |
| **Tech Lead** | ผู้นำด้านเทคนิคของทีม รับผิดชอบคุณภาพ Implementation และ Mentor |
| **ADR (Architecture Decision Record)** | บันทึกการตัดสินใจทางสถาปัตยกรรม พร้อมบริบทและผลกระทบ |
| **System Boundary** | ขอบเขตของระบบที่รับผิดชอบ vs ระบบภายนอก |
| **Data Model** | โครงสร้างข้อมูลและความสัมพันธ์ (ER Diagram) |
| **API Contract** | ข้อตกลง Interface ระหว่างระบบ (OpenAPI Spec) |
| **Integration Pattern** | รูปแบบการเชื่อมต่อ เช่น Idempotency, Retry, Saga |
| **Circuit Breaker** | กลไกตัดการเชื่อมต่อชั่วคราวเมื่อระบบปลายทางล่ม |
| **Reconciliation** | การกระทบยอดข้อมูลระหว่างสองระบบ |
| **Observability** | ความสามารถในการสังเกตระบบผ่าน Log, Metric, Trace |
| **Trade-off** | การแลกเปลี่ยนระหว่างคุณสมบัติ (เช่น Performance vs Cost) |
| **Technical Debt** | หนี้ทางเทคนิคที่ต้องชำระในอนาคต |
| **Fitness Function** | ตัววัดว่าสถาปัตยกรรมยังคงตอบโจทย์คุณสมบัติที่ต้องการ |

---

# 3. บทบาทและความรับผิดชอบ (Roles & Responsibilities)

## 3.1 Role Matrix

```bash
**R** = Responsible | **A** = Accountable | **C** = Consulted | **I** = Informed

• RACI อ่านว่า เร-ซี่ (ออกเสียงคล้ายคำว่า "เรซซิ่ง" ที่ตัดเสียง "ง" ท้ายออก) หรือบางครั้งก็อ่านเรียงตัวว่า อาร์-เอ-ซี-ไอ
• R = Responsible อ่านว่า ริส-ปอน-ซิ-เบิล (แปลว่า ผู้รับผิดชอบลงมือทำ)
• A = Accountable อ่านว่า แอค-เคาน์-ทะ-เบิล (แปลว่า ผู้รับผิดชอบหลักและมีอำนาจตัดสินใจ)
• C = Consulted อ่านว่า คอน-ซัล-ทิด หรือ คอน-ซัล-เต็ด (แปลว่า ผู้ให้คำปรึกษา)
• I = Informed อ่านว่า อิน-ฟอร์มด์ (แปลว่า ผู้รับทราบข้อมูล)
คำย่อ RACI คือเครื่องมือบริหารโครงการที่ใช้กำหนดบทบาทและความรับผิดชอบของคนในทีมให้ชัดเจน 
• R = Responsible (ผู้รับผิดชอบลงมือทำ). คือคนที่ลงมือปฏิบัติงานนั้นให้สำเร็จตามที่ได้รับมอบหมาย ซึ่งใน 1 งานอาจมีผู้ลงมือทำหลายคนได้.
• A = Accountable (ผู้รับผิดชอบหลักและมีอำนาจตัดสินใจ). คือเจ้าของงานตัวจริงที่ต้องรับผิดชอบต่อผลลัพธ์สุดท้ายและเป็นคนอนุมัติงาน ซึ่งใน 1 งานควรมีเพียงคนเดียวเท่านั้นเพื่อไม่ให้เกิดความสับสน.
• C = Consulted (ผู้ให้คำปรึกษา). คือผู้เชี่ยวชาญหรือผู้เกี่ยวข้องที่ทีมต้องสอบถามข้อมูลและความคิดเห็นก่อนหรือระหว่างทำงาน.
• I = Informed (ผู้รับทราบข้อมูล). คือผู้ที่ต้องได้รับแจ้งอัปเดตความคืบหน้าหรือผลลัพธ์ของงาน แต่ไม่ได้มีส่วนร่วมในการลงมือทำหรือตัดสินใจโดยตรง

```

---
ในด้านเทคโนโลยีสารสนเทศ (IT) คำว่า ADR มีความหมายหลักที่นิยมใช้กันอย่างแพร่หลายอยู่ 2 ความหมาย ขึ้นอยู่กับสายงาน

1. Architecture Decision Record (สายพัฒนาซอฟต์แวร์และสถาปัตยกรรมระบบ)

Architecture Decision Record (ADR) คือ เอกสารบันทึกการตัดสินใจทางสถาปัตยกรรมซอฟต์แวร์ เป็นไฟล์เอกสารสั้นๆ (มักเขียนเป็นไฟล์ Markdown เก็บไว้ใน Git Repository ร่วมกับโค้ด) เพื่อบันทึกว่าทีมพัฒนาตัดสินใจเลือกใช้เทคโนโลยี โครงสร้างระบบ หรือแนวทางแก้ปัญหาแบบใด และมีเหตุผลเบื้องหลังอย่างไร
• องค์ประกอบหลักในเอกสาร ADR:
	• Title: ชื่อหัวข้อการตัดสินใจ (เช่น ADR-001 เลือกใช้ PostgreSQL เป็นฐานข้อมูลหลัก)
	• Status: สถานะปัจจุบัน (เช่น Proposed, Accepted, Deprecated)
	• Context: บริบท ปัญหา หรือข้อจำกัดที่ทำให้ต้องตัดสินใจเรื่องนี้
	• Decision: สิ่งที่ทีมตกลงเลือกทำจริง
	• Consequences: ผลกระทบที่ตามมา ทั้งข้อดี ข้อเสีย และความเสี่ยงที่ต้องยอมรับ
• ประโยชน์ในการทำงาน: ช่วยให้พนักงานใหม่หรือทีมงานในอนาคตเข้าใจที่มาที่ไปของโครงสร้างระบบ ลดการถกเถียงซ้ำในเรื่องเดิมที่เคยตัดสินใจไปแล้ว

2. Automatic Diagnostic Repository (สายดูแลระบบและฐานข้อมูล Oracle)

Automatic Diagnostic Repository (ADR) คือ คลังจัดเก็บข้อมูลการวินิจฉัยปัญหาอัตโนมัติ ของระบบฐานข้อมูล Oracle Database และ Oracle Middleware เป็นโครงสร้างโฟลเดอร์กลางที่อยู่นอกตัวฐานข้อมูล เพื่อเก็บข้อมูลเมื่อระบบเกิดข้อผิดพลาด (Error) หรือทำงานผิดปกติ
• ข้อมูลสำคัญที่เก็บไว้ใน ADR:
	• Alert Logs: บันทึกเหตุการณ์สำคัญและการแจ้งเตือนข้อผิดพลาดร้ายแรงของระบบ
	• Trace Files: ไฟล์รายละเอียดเชิงลึกของการทำงานเบื้องหลังเมื่อเกิดปัญหา
	• Health Monitor Reports: รายงานผลการตรวจสอบสุขภาพของฐานข้อมูล
	• Incident Packages: ชุดข้อมูลสรุปปัญหาที่รวบรวมไว้พร้อมส่งให้ทีมสนับสนุน (Oracle Support) วิเคราะห์ต่อ
• เครื่องมือจัดการ: ผู้ดูแลระบบ (DBA) สามารถใช้คำสั่ง ADRCI (ADR Command Interpreter) ผ่านหน้าจอ Command Line เพื่อค้นหา อ่าน Log และล้างข้อมูลเก่าที่หมดอายุออกจากระบบ

ตารางเปรียบเทียบความแตกต่าง

หัวข้อเปรียบเทียบ	Architecture Decision Record	Automatic Diagnostic Repository
กลุ่มผู้ใช้งานหลัก	Software Architect, Developer, DevOps	Database Administrator (DBA), System Admin
รูปแบบข้อมูล	เอกสารข้อความ (Markdown / Text) ที่คนเขียนขึ้น	ไฟล์ Log และข้อมูลระบบที่ Oracle สร้างอัตโนมัติ
วัตถุประสงค์	บันทึกเหตุผลการออกแบบระบบ (Knowledge Management)	ใช้ตรวจสอบและแก้ไขข้อผิดพลาดของระบบ (Troubleshooting)

 
 

| กิจกรรม | Architect | Tech Lead | Dev | QA | DevOps | PO/BA | PM |
|---------|-----------|-----------|-----|----|--------|-------|----|
| System Architecture Design | **R** | C | I | I | C | C | A |
| ADR | **R** | C | C | I | C | C | I |
| Data Model | **R** | C | C | I | I | C | I |
| API Contract | **R** | **R** | C | C | I | C | I |
| Integration Design | **R** | **R** | C | I | C | C | I |
| Security Architecture | **R** | C | C | I | C | I | A |
| Infrastructure Design | C | C | I | I | **R** | I | I |
| Technical Design Review | **R** | **R** | C | C | C | I | I |
| Code Review (Deep) | C | **R** | C | I | I | I | I |
| Mentor Developer | C | **R** | I | I | I | I | I |
| Incident Technical Lead | C | **R** | C | I | **R** | I | A |
| Tech Debt Management | **R** | **R** | C | I | C | C | A |

**R** = Responsible | **A** = Accountable | **C** = Consulted | **I** = Informed

## 3.2 ความรับผิดชอบหลักของ Solution Architect

1. ออกแบบ System Architecture ที่ตอบโจทย์ธุรกิจ
2. ตัดสินใจเรื่อง Application, Data, Integration, Security, Infrastructure
3. บันทึก ADR ทุกครั้งที่มีการตัดสินใจสำคัญ
4. Review Architecture กับทีมก่อน Approve
5. ควบคุม Technical Debt ให้อยู่ในระดับที่ยอมรับได้
6. Mentor Tech Lead และ Developer

## 3.3 ความรับผิดชอบหลักของ Tech Lead

1. แปลง Architecture เป็น Implementation Plan
2. Review Technical Design ของทีม
3. Review Code ในเชิงลึก
4. Mentor Developer ในทีม
5. นำ Incident Response ในเชิงเทคนิค
6. ดูแลคุณภาพ Release และ Technical Debt

## 3.4 ขอบเขตที่ Architect ไม่ควรทำ

- ❌ เขียนโค้ดทุกส่วนเอง (ยกเว้น Prototype/POC)
- ❌ ตัดสินใจโดยไม่ปรึกษาทีม
- ❌ Over-engineer เพื่อความสมบูรณ์แบบทางทฤษฎี
- ❌ Approve Architecture โดยไม่มี ADR

## 3.5 ขอบเขตที่ Tech Lead ไม่ควรทำ

- ❌ Approve PR ของตนเอง
- ❌ ข้าม Code Review เพราะ “ไว้ใจ”
- ❌ แก้ Production โดยตรง
- ❌ ปล่อย Technical Debt โดยไม่มี Plan

---

# 4. ความรู้พื้นฐานที่ต้องมี (Prerequisites)

| ด้าน | ความรู้ที่ต้องมี |
|------|------------------|
| Architecture | Clean Architecture, Layered, Hexagonal, Microservices, Modular Monolith |
| Data | Relational, NoSQL, Data Modeling, Indexing, Sharding, CQRS |
| Integration | REST, gRPC, Message Queue, Event-Driven, Idempotency, Saga |
| Cloud | Azure (AKS, Key Vault, App Service), Docker, Kubernetes |
| Security | OWASP Top 10, Zero Trust, RBAC, Secrets Management, TLS |
| Observability | Prometheus, Grafana, Loki, Tempo/Jaeger, OpenTelemetry |
| DevOps | CI/CD, Git Flow, Blue-Green, Canary, Feature Flag |
| Compliance | SOX, PDPA, ISO 27001 |
| Business | Finance/Accounting Workflow, ERP Integration |
| Leadership | Mentor, Facilitation, Decision Making |

---

# 5. โครงสร้างการทำงาน (Team Structure)

```text
┌─────────────────────────────────────────────────────────────┐
│           ARCHITECT / TECH LEAD STRUCTURE                   │
└─────────────────────────────────────────────────────────────┘

                    ┌──────────────┐
                    │ Product Mgr  │
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │  Architect   │  System Design / ADR
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │Tech Lead │ │Tech Lead │ │Tech Lead │
        │ (FE)     │ │ (BE)     │ │(Integr.) │
        └────┬─────┘ └────┬─────┘ └────┬─────┘
             │            │            │
             ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │ FE Dev   │ │ BE Dev   │ │Integration│
        └──────────┘ └──────────┘ └──────────┘
                           │
                           ▼
                 ┌─────────────────┐
                 │ QA / DevOps /PO │
                 └─────────────────┘
```

## 5.1 การสื่อสาร

| กิจกรรม | ความถี่ | ผู้เข้าร่วม |
|---------|---------|------------|
| Architecture Review | ตามงาน | Architect, Tech Lead, QA, DevOps |
| Technical Design Review | ต่อ Feature ใหญ่ | Tech Lead, Dev, QA |
| ADR Review | ต่อการตัดสินใจ | Architect, Tech Lead, PM |
| Mentor Session | สัปดาห์/ครั้ง | Tech Lead, Dev |
| Tech Debt Review | Sprint/ครั้ง | Architect, Tech Lead |
| Post-Incident Review | ตามเหตุการณ์ | Architect, Tech Lead, DevOps, On-call |

---

# 6. หลักการทำงาน (Concept)

## 6.1 หลักการ 7 ประการของ Architect

1. **Business Value First** — สถาปัตยกรรมต้องตอบโจทย์ธุรกิจก่อนความสวยงามทางทฤษฎี
2. **Simplicity over Cleverness** — เรียบง่าย ดูแลง่าย ดีกว่า Clever แต่เปราะบาง
3. **Decide & Document** — ทุกการตัดสินใจสำคัญต้องมี ADR
4. **Trade-offs Explicit** — ระบุ Trade-off ทุกครั้ง (Performance / Cost / Maintainability)
5. **Security by Design** — ความปลอดภัยต้องออกแบบตั้งแต่ต้น
6. **Observable by Default** — Log / Metric / Trace ต้องมีตั้งแต่ Design
7. **Iterate & Evolve** — สถาปัตยกรรมเป็น Living Thing ปรับได้ตามการเรียนรู้

## 6.2 Mental Model: Business → Architecture → Implementation

```text
┌──────────────────┐
│ Business Goal    │   ทำไมต้องมีระบบนี้
└────────┬─────────┘
         ▼
┌──────────────────┐
│ Capabilities     │   ต้องทำอะไรได้บ้าง
└────────┬─────────┘
         ▼
┌──────────────────┐
│ Architecture     │   ออกแบบอย่างไร
└────────┬─────────┘
         ▼
┌──────────────────┐
│ Implementation   │   ลงมืออย่างไร
└──────────────────┘
```

## 6.3 Architecture Principles ของทีม

| หลักการ | ความหมาย | ตัวอย่าง |
|---------|----------|----------|
| **Modular by Domain** | แยก Module ตาม Business Domain | Employee, Payment, Reconciliation |
| **Contract-First** | ออกแบบ API Contract ก่อน Implement | OpenAPI Spec ก่อนเขียน Router |
| **Idempotent by Default** | Endpoint ที่สร้างข้อมูลต้องรองรับ Idempotency | POST /payment |
| **Asynchronous for Long-Running** | งานนานใช้ Queue | Export Report, ERP Sync |
| **Least Privilege** | ให้สิทธิ์น้อยที่สุด | RBAC + Service Account |
| **Data Integrity > Performance** | ข้อมูลการเงินต้องถูกต้องก่อน | Transactional + Reconciliation |
| **Fail-Safe** | ระบบต้องไม่ทำให้ข้อมูลเสียหายเมื่อล่ม | Circuit Breaker + Retry |

## 6.4 Trade-off Framework

เมื่อต้องตัดสินใจ ให้ใช้ **4 มิติ:**

| มิติ | คำถาม |
|------|--------|
| **Performance** | เร็วพอหรือไม่? |
| **Cost** | ค่าใช้จ่ายสมเหตุสมผลหรือไม่? |
| **Maintainability** | ทีมดูแลต่อได้หรือไม่? |
| **Time to Market** | ส่งมอบเร็วพอต่อธุรกิจหรือไม่? |

**Rule of Thumb:**

> ไม่มี Architecture ที่ดีที่สุด — มีแต่ Architecture ที่เหมาะกับ Context ที่สุด ณ เวลานั้น

---

# 7. Workflow และ Dataflow

## 7.1 Architecture Workflow

```text
┌──────────────────────────────────────────────────────────────┐
│              ARCHITECTURE WORKFLOW                           │
└──────────────────────────────────────────────────────────────┘

Business Workflow
     │
     ▼
1. System Boundary        ระบบทำอะไร / ไม่ทำอะไร
     │
     ▼
2. Capability Map         Business Capabilities
     │
     ▼
3. Data Model             ER Diagram / Data Flow
     │
     ▼
4. API Contract           OpenAPI Spec
     │
     ▼
5. Integration Pattern    Idempotency / Retry / Saga
     │
     ▼
6. Security Design        SSO / RBAC / Secrets
     │
     ▼
7. Infrastructure         Docker / K8s / Azure
     │
     ▼
8. Observability          Log / Metric / Trace / Alert
     │
     ▼
9. ADR                    Decision Log
     │
     ▼
10. Architecture Review   Approve / Revise
     │
     ▼
11. Handoff to Team
```

## 7.2 Dataflow Diagram: System Context (ตัวอย่าง)

```text
┌─────────────────────────────────────────────────────────────┐
│                 PMS SYSTEM CONTEXT                          │
└─────────────────────────────────────────────────────────────┘

   ┌──────────┐                            ┌──────────────┐
   │ Finance  │──── SSO (Azure AD) ───────▶│              │
   │  Users   │                            │              │
   └──────────┘                            │              │
                                           │              │
   ┌──────────┐      HTTPS / REST          │     PMS      │
   │ Power BI │◀──── Data Export ─────────│   (Core)     │
   └──────────┘                            │              │
                                           │              │
   ┌──────────┐      HTTPS / REST          │              │
   │ Oracle   │◀──── Payment Sync ────────▶│              │
   │   ERP    │                            │              │
   └──────────┘                            │              │
                                           │              │
   ┌──────────┐      SFTP / CSV            │              │
   │  Bank    │──── Bank Statement ───────▶│              │
   └──────────┘                            │              │
                                           │              │
   ┌──────────┐      REST / Webhook        │              │
   │Databricks│◀──── Data Pipeline ────────│              │
   └──────────┘                            └──────────────┘
```

## 7.3 State Diagram: Payment Lifecycle

```text
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│  Draft   │──▶│ Submitted│──▶│ Approved │──▶│ Synced   │
└──────────┘   └──────────┘   └──────────┘   └──────────┘
                    │               │               │
                    ▼               ▼               ▼
              ┌──────────┐   ┌──────────┐   ┌──────────┐
              │ Rejected │   │  Failed  │   │ Reconciled│
              └──────────┘   └──────────┘   └──────────┘
```

---

# 8. System Design Standards

## 8.1 Layered Architecture (Reference)

```text
┌─────────────────────────────────────────┐
│          Presentation Layer             │  React / API
├─────────────────────────────────────────┤
│          Application Layer              │  Use Cases / Handlers
├─────────────────────────────────────────┤
│          Domain Layer                   │  Business Rules / Entities
├─────────────────────────────────────────┤
│          Infrastructure Layer           │  DB / External Clients
└─────────────────────────────────────────┘
```

**กฎสำคัญ:**

- ชั้นบนเรียกชั้นล่างได้ แต่ชั้นล่างห้ามเรียกชั้นบน
- Domain ไม่รู้จัก Database หรือ External Service
- Infrastructure Implement Interface ที่ Domain กำหนด (Dependency Inversion)

## 8.2 Data Model Standards

- ใช้ **UUID v4** เป็น Primary Key สำหรับ Entity ที่อาจ Sync ข้ามระบบ
- ใช้ **created_at / updated_at** ทุก Table
- ใช้ **soft delete** (deleted_at) สำหรับข้อมูลที่ต้องเก็บ Audit
- ใช้ **Index** ในคอลัมน์ที่ค้นหาบ่อย
- หลีกเลี่ยง **N+1 Query**
- ใช้ **Transaction** สำหรับ Operation ที่ต้อง Atomic
- ใช้ **Migration Tool** เท่านั้น ห้ามแก้ Schema Production โดยตรง

## 8.3 API Contract Standards

- ใช้ **OpenAPI 3.1** Spec
- Version API: `/v1/...`
- ใช้ **HTTP Status Codes** ตามมาตรฐาน (200/201/204/400/401/403/404/409/422/500)
- Error Response มี **code + message + correlation_id**
- Pagination ใช้ `limit` + `cursor` หรือ `offset`
- Rate Limit ระบุใน Contract
- Authorization ระบุใน Contract

## 8.4 System Design Checklist

- [ ] System Boundary ชัดเจน
- [ ] Capability Map ครบ
- [ ] Data Model (ER Diagram)
- [ ] API Contract (OpenAPI Spec)
- [ ] Integration Pattern (Idempotency / Retry / Reconciliation)
- [ ] Security (SSO/RBAC / Secrets / TLS)
- [ ] Infrastructure (Docker / K8s / Azure)
- [ ] Observability (Log / Metric / Trace / Alert)
- [ ] Scalability & Performance Target
- [ ] Disaster Recovery Plan
- [ ] ADR บันทึกครบ

---

# 9. Integration Patterns

## 9.1 Pattern Matrix

| Pattern | ใช้เมื่อ | ตัวอย่าง |
|---------|---------|----------|
| **Idempotency** | ป้องกันข้อมูลซ้ำ | `Idempotency-Key` header |
| **Retry with Backoff** | Network Timeout | Exponential backoff |
| **Circuit Breaker** | External Service ล่ม | ตัดการเชื่อมต่อชั่วคราว |
| **Bulkhead** | แยก Pool สำหรับ Service ที่สำคัญ | แยก Connection Pool |
| **Timeout** | ป้องกันการรอไม่จำกัด | 30s / 60s ตาม Use Case |
| **Reconciliation** | กระทบยอดข้อมูล | Daily job ตรวจข้อมูลซ้ำ |
| **Saga** | Distributed Transaction | Compensating actions |
| **Outbox Pattern** | ส่ง Event ให้ Reliable | เขียน Outbox ก่อนส่ง |
| **Dead Letter Queue** | จัดการ Message ที่ล้มเหลว | เก็บไว้ Retry / ตรวจ |

## 9.2 ตัวอย่าง Integration Design (Oracle ERP)

```python
# pkg/integration/oracle_erp/client.py
import httpx
from tenacity import retry, stop_after_attempt, wait_exponential


class OracleERPClient:
    def __init__(self, base_url: str, token: str) -> None:
        self.base_url = base_url
        self.token = token

    @retry(
        stop=stop_after_attempt(3),
        wait=wait_exponential(multiplier=1, min=2, max=10),
    )
    async def post_payment(self, payload: dict, idempotency_key: str) -> dict:
        async with httpx.AsyncClient(timeout=30) as client:
            resp = await client.post(
                f"{self.base_url}/payments",
                json=payload,
                headers={
                    "Authorization": f"Bearer {self.token}",
                    "Idempotency-Key": idempotency_key,
                    "X-Correlation-ID": payload.get("correlation_id", ""),
                },
            )
            resp.raise_for_status()
            return resp.json()
```

## 9.3 Reconciliation Design

```text
┌─────────────────────────────────────────────────────────────┐
│           RECONCILIATION DESIGN                             │
└─────────────────────────────────────────────────────────────┘

   PMS                    ERP
    │                      │
    │   Daily Snapshot     │
    ├──────────┐    ┌──────┤
    │          ▼    ▼      │
    │     ┌─────────────┐  │
    │     │ Reconciler  │  │
    │     └──────┬──────┘  │
    │            │         │
    │            ▼         │
    │     ┌─────────────┐  │
    │     │ Mismatch?   │  │
    │     └──────┬──────┘  │
    │       Yes  │  No     │
    │            ▼         │
    │     ┌─────────────┐  │
    │     │ Alert + Log │  │
    │     └─────────────┘  │
```

## 9.4 Integration Checklist

- [ ] มี Idempotency-Key สำหรับ POST ที่สร้างข้อมูล
- [ ] มี Retry with Exponential Backoff
- [ ] มี Timeout ที่เหมาะสม
- [ ] มี Circuit Breaker (ถ้าใช้)
- [ ] มี Reconciliation Job สำหรับข้อมูลสำคัญ
- [ ] มี Correlation ID ในทุก Log
- [ ] มี Dead Letter Queue (ถ้าใช้ Queue)
- [ ] มี Alerting เมื่อ Integration ล้มเหลว

---

# 10. Architecture Decision Record (ADR)

## 10.1 ADR Template

```markdown
# ADR-001: [ชื่อการตัดสินใจ]

**Status:** [Proposed / Accepted / Deprecated / Superseded]
**Date:** [YYYY-MM-DD]
**Deciders:** [ชื่อผู้ตัดสินใจ]
**Consulted:** [ชื่อ]
**Informed:** [ชื่อ]

## Context
[บริบทและปัญหาที่ต้องตัดสินใจ]

## Decision
[การตัดสินใจที่เลือก]

## Consequences
### Positive
- [ผลบวก]

### Negative
- [ผลลบ]

### Risks
- [ความเสี่ยง]

## Alternatives Considered
1. [ทางเลือก 1] — เหตุผลที่ไม่เลือก
2. [ทางเลือก 2] — เหตุผลที่ไม่เลือก

## References
- [ลิงก์/เอกสารอ้างอิง]
```

## 10.2 ตัวอย่าง ADR: Idempotency-Key

```markdown
# ADR-005: ใช้ Idempotency-Key สำหรับ Payment Sync

**Status:** Accepted
**Date:** 2026-01-15
**Deciders:** Solution Architect, Tech Lead, DevOps Lead

## Context
Payment Sync ไป Oracle ERP ผ่าน HTTP อาจเกิด Timeout และ Retry
ทำให้เกิดความเสี่ยงข้อมูลซ้ำใน ERP ที่กระทบการปิดบัญชี

## Decision
ใช้ `Idempotency-Key` header ในทุก Request ที่สร้างข้อมูล
โดย Key มาจาก UUID ที่ Generate ครั้งแรกและเก็บใน Database
ตลอด Lifecycle ของ Payment (จนกว่า Sync สำเร็จ)

## Consequences

### Positive
- ป้องกันข้อมูลซ้ำได้ 100% แม้ Retry หลายครั้ง
- มี Audit Trail ที่ตรวจสอบย้อนหลังได้
- ตรงกับมาตรฐาน REST API

### Negative
- ERP ต้องรองรับ Idempotency-Key (ตรวจสอบแล้วรองรับ)
- ต้องมี Storage สำหรับ Key (ใช้ Table `idempotency_key`)

### Risks
- ถ้า ERP ไม่ enforce จริง จะต้องเพิ่ม Reconciliation Job
- ต้องมี Retention Policy สำหรับ Key (ลบหลัง 30 วัน)

## Alternatives Considered
1. **ใช้ Timestamp-based deduplication** — ไม่แม่นยำเมื่อ Clock ต่างกัน
2. **ไม่มี Idempotency** — เสี่ยงข้อมูลซ้ำ (ปฏิเสธ)

## References
- RFC 7231 (HTTP Semantics)
- ERP Integration Spec v2.3
```

## 10.3 เมื่อไรต้องเขียน ADR

- เลือก Technology / Framework
- ออกแบบ Integration Pattern
- เปลี่ยน Data Model ที่สำคัญ
- เปลี่ยน Security Model
- ตัดสินใจไม่ทำอะไร (Non-decision)
- Trade-off ที่สำคัญ

## 10.4 ADR Lifecycle

```text
Proposed ──▶ Accepted ──▶ (Deprecated / Superseded)
   │
   └──▶ Rejected
```

## 10.5 ADR Checklist

- [ ] มี Context ที่ชัดเจน
- [ ] มี Decision ชัดเจน
- [ ] มี Consequences ครบ (Positive / Negative / Risks)
- [ ] มี Alternatives Considered
- [ ] มี References
- [ ] มี Status + Date + Deciders
- [ ] Review กับทีมก่อน Approve

---

# 11. Security & Compliance Architecture

## 11.1 Security Architecture Layers

```text
┌─────────────────────────────────────────┐
│   Identity    │  Azure AD SSO + MFA     │
├───────────────┼─────────────────────────┤
│   Access      │  RBAC + Least Privilege │
├───────────────┼─────────────────────────┤
│   Transport   │  TLS 1.2+ / mTLS        │
├───────────────┼─────────────────────────┤
│   Data        │  Encryption at Rest     │
├───────────────┼─────────────────────────┤
│   Secrets     │  Azure Key Vault        │
├───────────────┼─────────────────────────┤
│   Audit       │  Structured Log + SIEM  │
└───────────────┴─────────────────────────┘
```

## 11.2 RBAC Design

- Role ออกแบบตาม **Job Function** ไม่ใช่ **Person**
- ใช้ **Least Privilege** — ให้สิทธิ์น้อยที่สุดที่จำเป็น
- ทุก Endpoint ที่ Sensitive ต้องมี **Authorization Check**
- แยก **Service Account** สำหรับ Integration
- Audit Log ทุกครั้งที่มีการเปลี่ยนสิทธิ์

## 11.3 Secrets Management

- ใช้ **Azure Key Vault** เป็นศูนย์กลาง
- Rotate Secrets เป็นประจำ
- ห้าม Commit Secrets ใน Git
- ห้ามฝัง Secrets ใน Docker Image
- ใช้ **Managed Identity** สำหรับ Azure Resources

## 11.4 Compliance Mapping

| มาตรฐาน | ข้อกำหนด | ผลต่อ Architecture |
|---------|----------|---------------------|
| **SOX** | Financial Reporting Integrity | Audit Trail, Separation of Duties |
| **PDPA** | Data Privacy | Data Retention, PII Masking |
| **ISO 27001** | ISMS | Access Control, Incident Response |
| **PCI-DSS** | Payment Card | Encryption, Network Segmentation |

## 11.5 Threat Modeling (STRIDE)

| Threat | ตัวอย่าง | Mitigation |
|--------|----------|------------|
| **Spoofing** | ปลอม Token | SSO + MFA |
| **Tampering** | แก้ Request | TLS + Signature |
| **Repudiation** | ปฏิเสธการกระทำ | Audit Log |
| **Information Disclosure** | ข้อมูลหลุด | Encryption + RBAC |
| **Denial of Service** | DDoS | Rate Limit + WAF |
| **Elevation of Privilege** | ยกระดับสิทธิ์ | Least Privilege |

---

# 12. Observability & Scalability

## 12.1 Observability Pillars

| Pillar | เครื่องมือ | ใช้ทำอะไร |
|--------|-----------|-----------|
| **Log** | Loki / ELK | Structured Logging |
| **Metric** | Prometheus + Grafana | Performance Monitoring |
| **Trace** | Tempo / Jaeger | Distributed Tracing |
| **Alert** | Alertmanager + Slack | Incident Alerting |

## 12.2 Observability Standards

- ทุก Request ต้องมี **Correlation ID**
- Log ต้องเป็น **Structured (JSON)**
- Log ห้ามมี PII / Secrets
- ทุก Service ต้อง expose **/health** และ **/ready**
- Metric สำคัญ: latency, error rate, throughput, saturation

## 12.3 Golden Signals

1. **Latency** — เวลาตอบสนอง
2. **Traffic** — ปริมาณ Request
3. **Errors** — อัตรา Error
4. **Saturation** — การใช้ Resource

## 12.4 Scalability Design

| ระดับ | วิธี |
|-------|------|
| **Vertical** | เพิ่ม CPU/RAM |
| **Horizontal** | เพิ่ม Instance (Stateless) |
| **Data** | Read Replica / Sharding / Partition |
| **Cache** | Redis / CDN |
| **Async** | Queue / Worker |

## 12.5 Performance Target

| Endpoint | p95 | p99 |
|----------|-----|-----|
| GET (read) | ≤ 200 ms | ≤ 500 ms |
| POST (write) | ≤ 500 ms | ≤ 1 s |
| Report Export | ≤ 30 s | ≤ 60 s |
| ERP Sync | ≤ 5 s | ≤ 10 s |

## 12.6 Disaster Recovery

- **RPO:** ≤ 15 นาที
- **RTO:** ≤ 1 ชั่วโมง
- Backup Database รายวัน + Retention 30 วัน
- ซ้อม Restore ทุกไตรมาส
- มี Runbook สำหรับ DR

---

# 13. Case Study

## Case Study 1: Payment Reconciliation System (P2R)

### 13.1.1 System Boundary

**ในขอบเขต:**

- Import Bank Statement
- Auto Match
- Manual Review
- Export to ERP
- Dashboard

**นอกขอบเขต:**

- Bank Gateway (external)
- Oracle ERP (external)
- Accounting Logic (อยู่ใน ERP)

### 13.1.2 Architecture Diagram

```text
┌─────────────────────────────────────────────────────────────┐
│              PAYMENT RECONCILIATION ARCHITECTURE            │
└─────────────────────────────────────────────────────────────┘

   ┌──────────┐     CSV/API    ┌─────────────────────────┐
   │  Bank    │───────────────▶│  Import Service         │
   └──────────┘                └────────────┬────────────┘
                                            │
                                            ▼
   ┌──────────┐   HTTPS/REST   ┌─────────────────────────┐
   │ Finance  │◀──────────────▶│  PMS API (FastAPI)      │
   │  Users   │                │  ┌───────────────────┐  │
   └──────────┘                │  │ Matching Engine   │  │
                               │  ├───────────────────┤  │
                               │  │ Manual Review     │  │
                               │  ├───────────────────┤  │
                               │  │ Export Service    │  │
                               │  └───────────────────┘  │
                               └────┬───────────────┬────┘
                                    │               │
                                    ▼               ▼
                          ┌──────────────┐  ┌──────────────┐
                          │  PostgreSQL  │  │  Oracle ERP  │
                          └──────────────┘  └──────────────┘
                                    │
                                    ▼
                          ┌──────────────┐
                          │  Power BI    │
                          └──────────────┘
```

### 13.1.3 Data Model (หลัก)

```text
bank_statement
  ├── id (UUID, PK)
  ├── bank_account (varchar)
  ├── statement_date (date)
  ├── amount (numeric)
  ├── reference (varchar)
  ├── imported_at (timestamp)

payment
  ├── id (UUID, PK)
  ├── payment_date (date)
  ├── amount (numeric)
  ├── currency (char 3)
  ├── reference (varchar)
  ├── status (enum)
  ├── created_at (timestamp)
  ├── updated_at (timestamp)

reconciliation
  ├── id (UUID, PK)
  ├── payment_id (FK)
  ├── bank_statement_id (FK)
  ├── match_rule (varchar)
  ├── matched_at (timestamp)
  ├── matched_by (varchar)
  ├── status (enum)

reconciliation_log
  ├── id (UUID, PK)
  ├── reconciliation_id (FK)
  ├── action (varchar)
  ├── actor (varchar)
  ├── timestamp (timestamp)
  ├── detail (jsonb)
```

### 13.1.4 Integration Decisions

| Integration | Pattern |
|-------------|---------|
| Import Bank Statement | Idempotent + Duplicate Detection |
| Export to ERP | Idempotency-Key + Retry + Reconciliation |
| Power BI | Read-only Replica + Daily Refresh |

### 13.1.5 ADR ที่เกี่ยวข้อง

- ADR-P2R-001: ใช้ PostgreSQL เป็น Source of Truth
- ADR-P2R-002: Auto Match ใช้ Rule-based ไม่ใช้ ML ใน Phase 1
- ADR-P2R-003: ERP Sync ใช้ Idempotency-Key + Daily Reconciliation
- ADR-P2R-004: Dashboard ใช้ Power BI ต่อ Read-only Replica

### 13.1.6 KPI

| KPI | Target |
|-----|--------|
| Auto Match Rate | ≥ 85% |
| Reconciliation Time | ≤ 4 ชั่วโมง |
| ERP Sync Success Rate | ≥ 99% |
| Duplicate Rate | 0% |
| System Uptime | ≥ 99.9% |

---

## Case Study 2: Oracle ERP Integration

### 13.2.1 Integration Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│              ERP INTEGRATION ARCHITECTURE                   │
└─────────────────────────────────────────────────────────────┘

  PMS API
    │
    ▼
┌────────────────┐    ┌─────────────┐    ┌─────────────┐
│ Outbox Table   │───▶│ Queue       │───▶│ Worker      │
│ (Transactional)│    │ (Redis)     │    │ (Async)     │
└────────────────┘    └─────────────┘    └──────┬──────┘
                                                 │
                                                 ▼
                                        ┌────────────────┐
                                        │ Oracle ERP     │
                                        │ Client (httpx) │
                                        └────────┬───────┘
                                                 │
                                                 ▼
                                        ┌────────────────┐
                                        │ Reconciler     │
                                        │ (Daily Job)    │
                                        └────────────────┘
```

### 13.2.2 Decision Highlights

- **Outbox Pattern** เพื่อให้การส่งข้อมูล Reliable
- **Idempotency-Key** เพื่อป้องกันข้อมูลซ้ำ
- **Retry with Backoff** (3 ครั้ง, 2–10s)
- **Daily Reconciliation** เพื่อจับ Mismatch
- **Dead Letter Queue** สำหรับ Message ที่ล้มเหลว

### 13.2.3 Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| ERP ล่ม | Sync ค้าง | Queue + Retry + Pending Status |
| Network Timeout | ซ้ำ | Idempotency-Key |
| Schema เปลี่ยน | Sync Fail | Contract Test + Versioning |
| Clock Skew | Date ผิด | Server Time + UTC |

---

## Case Study 3: Dashboard & Reporting

### 13.3.1 Architecture

- Read-only Replica สำหรับ Query หนัก
- Caching Layer (Redis) สำหรับ Aggregate
- Power BI ต่อ Replica โดยตรง
- Export Service สร้างไฟล์แบบ Async

### 13.3.2 Decisions

- แยก Read / Write Path (CQRS-light)
- ไม่ Query Production DB โดยตรง
- Dashboard Freshness ≤ 15 นาที

---

# 14. KPI & SMART Criteria

## 14.1 KPI หลักของ Architect

| KPI | เป้าหมาย | วิธีวัด |
|-----|----------|---------|
| ADR Completeness | 100% | ตรวจ Decision Log |
| Architecture Review Pass Rate | ≥ 90% | passed / total |
| Technical Debt Ratio | < 5% | SonarQube |
| System Uptime | ≥ 99.9% | Monitoring |
| Integration Defect Rate | < 1% | Defect / Transactions |
| Architecture Change Lead Time | ≤ 5 วัน | วัดจาก Proposal → Approve |

## 14.2 KPI หลักของ Tech Lead

| KPI | เป้าหมาย | วิธีวัด |
|-----|----------|---------|
| Code Review Turnaround | ≤ 24 ชั่วโมง | PR Dashboard |
| Team PR Quality | ≥ 95% Approve รอบแรก | PR Metrics |
| Mentor Sessions | ≥ 2/เดือน | Calendar |
| Incident MTTR | ≤ 30 นาที | Incident Log |
| Team Technical Debt | ลดลงทุก Sprint | SonarQube Trend |

## 14.3 SMART ตัวอย่าง

| SMART | รายละเอียด |
|-------|-----------|
| **S** | เพิ่ม ADR Completeness ของการตัดสินใจสำคัญ |
| **M** | 100% ของ Decision ที่มี Impact ≥ Medium |
| **A** | บังคับ ADR ใน Architecture Review Checklist |
| **R** | ลดการตัดสินใจที่ไม่มีเหตุผลรองรับ |
| **T** | ภายใน 2 Sprint |

---

# 15. คู่มือการทดสอบ (Architecture Validation & Review)

## 15.1 Architecture Validation Methods

| วิธี | ใช้เมื่อ | ผลลัพธ์ |
|------|----------|---------|
| **Design Review** | ก่อน Approve Architecture | Feedback + Approval |
| **Prototype / POC** | เมื่อ Technology ใหม่ | ยืนยัน Feasibility |
| **Fitness Function** | ต่อเนื่อง | ตรวจ Architecture Property |
| **Load Test** | ก่อน Release | ยืนยัน Performance |
| **Chaos Test** | ระบบสำคัญ | ยืนยัน Resilience |
| **Security Review** | ก่อน Production | ยืนยัน Security Posture |
| **ADR Review** | ต่อ Decision | ยืนยัน Rationale |

## 15.2 Fitness Functions ตัวอย่าง

| Property | วัดอย่างไร |
|----------|-----------|
| **Modularity** | จำนวน Cross-module Dependency |
| **Coupling** | Afferent / Efferent Coupling |
| **Performance** | p95 ≤ Target |
| **Security** | 0 Critical Vulnerability |
| **Observability** | ทุก Service มี /health + Metric |
| **Idempotency** | POST ทุก Endpoint มี Idempotency Key |

## 15.3 Load Test Plan ตัวอย่าง

```text
Target: POST /payment
- Baseline: 10 RPS, p95 ≤ 500ms
- Peak: 50 RPS, p95 ≤ 1s
- Soak: 1 ชั่วโมงที่ 30 RPS, ไม่มี Error
- Spike: 100 RPS เป็นเวลา 1 นาที, ระบบต้องไม่ล่ม
```

## 15.4 Architecture Review Checklist

- [ ] System Boundary ชัดเจน
- [ ] Capability Map ครบ
- [ ] Data Model มี Index + Migration Plan
- [ ] API Contract (OpenAPI) ครบ
- [ ] Integration Pattern เหมาะสม
- [ ] Security Model ครบ
- [ ] Observability Design ครบ
- [ ] Scalability Target ระบุ
- [ ] DR Plan ระบุ
- [ ] ADR ครบทุก Decision สำคัญ
- [ ] Trade-offs ระบุชัดเจน
- [ ] Risk + Mitigation ครบ

## 15.5 Architecture Review Sign-off Template

```markdown
# Architecture Review: [System Name]

**Date:** [Date]
**Reviewers:** [ชื่อ]
**Author:** [ชื่อ]

## Scope Reviewed
- System Boundary
- Data Model
- API Contract
- Integration Pattern
- Security
- Observability
- ADRs

## Findings
| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 1 | ...     | High     | ...            |

## Decision
☑ Approved
☐ Approved with Conditions
☐ Rejected

**Sign-off:**
- Architect: __________ Date: ______
- Tech Lead: __________ Date: ______
- DevOps: ___________ Date: ______
- Security: __________ Date: ______
```

---

# 16. คู่มือการใช้งาน (Architect Guide)

## 16.1 Daily Workflow ของ Architect

```text
เช้า:
1. ตรวจ ADR ที่รอ Review
2. ประชุมกับ Tech Lead
3. Clarify Requirement ที่คลุมเครือ

ระหว่างวัน:
4. ออกแบบ Architecture สำหรับ Feature ใหม่
5. Review Technical Design
6. เขียน ADR
7. Mentor Tech Lead / Dev

เย็น:
8. อัปเดต Decision Log
9. ตรวจ Technical Debt
```

## 16.2 Daily Workflow ของ Tech Lead

```text
เช้า:
1. Daily Standup
2. ตรวจ PR ที่รอ Review
3. Unblock Dev

ระหว่างวัน:
4. Design Review กับ Dev
5. Review Code ที่ Sensitive
6. แก้ Incident (ถ้ามี)

เย็น:
7. อัปเดต Technical Debt Backlog
8. เตรียม Mentor Session
```

## 16.3 การสร้าง ADR ใหม่

1. ระบุ Problem / Context
2. รวบรวม Alternatives
3. วิเคราะห์ Trade-offs
4. ตัดสินใจ
5. เขียน ADR ตาม Template
6. Review กับทีม
7. เปลี่ยน Status เป็น Accepted
8. เก็บใน Repository (docs/adr/)

## 16.4 การ Review Technical Design

- อ่าน Design Doc
- ตรวจว่าสอดคล้องกับ ADR ที่มีอยู่
- ตรวจ Security / Performance / Observability
- ให้ Feedback แบบ Specific
- Approve / Request Changes / Reject

## 16.5 การ Mentor

- Mentor Session ทุกสัปดาห์
- Pair Design กับ Dev
- Review Code แบบให้ความรู้ ไม่ใช่แค่ชี้ผิด
- เปิดพื้นที่ให้ถาม
- Document Lessons Learned

---

# 17. คู่มือการบำรุงรักษา (Maintenance Guide)

## 17.1 Architecture Maintenance

- ทบทวน Architecture ทุกไตรมาส
- ตรวจ Fitness Functions
- อัปเดต ADR ที่ Deprecated
- ตรวจ Technical Debt Trend
- ตรวจ Security Posture

## 17.2 Technical Debt Management

| ประเภท | ตัวอย่าง | วิธีจัดการ |
|--------|----------|------------|
| **Code Debt** | Duplication, Complex Code | Refactor Plan |
| **Design Debt** | Coupling สูง, Architecture Drift | ADR + Refactor |
| **Test Debt** | Coverage ต่ำ | เพิ่ม Test |
| **Infra Debt** | Config Manual | Automate |
| **Doc Debt** | Doc ล้าสมัย | Review Cycle |

**Rule:**

- Technical Debt ทุกตัวต้องมี **Owner + Plan + Due Date**
- ห้ามปล่อย Debt สะสมเกิน 5% ของ Sprint Capacity

## 17.3 ADR Maintenance

- อัปเดต Status เมื่อ Decision เปลี่ยน
- เก็บ ADR ที่ Superseded ไว้ (ไม่ลบ)
- Link ADR ใหม่กับ ADR เก่า
- Review ADR ทุกไตรมาส

## 17.4 Documentation Maintenance

| เอกสาร | Owner | Review Cycle |
|--------|-------|--------------|
| ADR | Architect | ต่อเนื่อง |
| System Design | Architect | ไตรมาส |
| Data Model | Tech Lead | ไตรมาส |
| API Contract | Tech Lead | ต่อ Release |
| Runbook | DevOps | ไตรมาส |
| Architecture Diagram | Architect | ไตรมาส |

---

# 18. คู่มือการขยาย/แก้ไข (Extension Guide)

## 18.1 การเพิ่ม Service ใหม่

1. ระบุ Capability ที่ Service รับผิดชอบ
2. ระบุ System Boundary
3. ออกแบบ Data Model
4. ออกแบบ API Contract
5. ระบุ Integration Pattern
6. ระบุ Observability
7. เขียน ADR
8. Architecture Review
9. Handoff to Team

## 18.2 การเพิ่ม Integration ใหม่

- ระบุปลายทาง + Protocol
- ระบุ Idempotency Strategy
- ระบุ Retry + Timeout
- ระบุ Reconciliation
- ระบุ Monitoring + Alerting
- เขียน ADR
- Integration Test + Contract Test

## 18.3 การเปลี่ยน Data Model

- เขียน Migration Plan
- ระบุ Rollback Plan
- Dry-run บน Staging
- Backup ก่อน Migrate
- แจ้ง Stakeholder
- Update ADR

## 18.4 การเปลี่ยน Technology

- เขียน ADR พร้อม Trade-offs
- ทำ POC ถ้าเป็นของใหม่
- ระบุ Migration Plan
- ระบุ Training Plan
- Architecture Review

## 18.5 Governance

- การเพิ่ม Service ต้องผ่าน Architect
- การเปลี่ยน API Contract ต้องแจ้ง PO/BA + QA
- การเปลี่ยน Security ต้องผ่าน Security Review
- การเปลี่ยน Infrastructure ต้องผ่าน DevOps
- การเปลี่ยน Data Model ต้องมี Migration Plan

---

# 19. Code Review & PR Checklist สำหรับ Architect

## 19.1 สิ่งที่ Architect ตรวจใน PR

- [ ] สอดคล้องกับ ADR ที่มีอยู่
- [ ] ไม่มี Architecture Drift
- [ ] Layer Separation ถูกต้อง
- [ ] API Contract ตรงกับ Design
- [ ] Security Check ครบ
- [ ] Observability ครบ
- [ ] Performance Impact ประเมินแล้ว
- [ ] Technical Debt ใหม่มี Plan
- [ ] Documentation อัปเดต
- [ ] ไม่มี Over-engineering

## 19.2 สิ่งที่ Tech Lead ตรวจใน PR

- [ ] Code Quality ตาม Standards
- [ ] Test Coverage ≥ 80%
- [ ] Edge Cases ครบ
- [ ] Error Handling ครบ
- [ ] Performance OK (ไม่มี N+1)
- [ ] Security OK
- [ ] Observability OK
- [ ] Documentation OK
- [ ] ผ่าน `/tb-scrutinize`

## 19.3 สิ่งที่ Architect/Tech Lead ไม่ควรทำ

- ❌ Approve PR ของตนเอง
- ❌ Comment เรื่อง Style ถ้า Linter ผ่าน
- ❌ บังคับ Refactor โดยไม่มีเหตุผล
- ❌ Delay Review เกิน 24 ชั่วโมง
- ❌ ใช้คำพูดที่ทำร้ายกำลังใจ

## 19.4 การให้ Feedback ที่ดี

**✅ แบบนี้:**

> “Function นี้ทำงานถูกต้อง แต่ถ้าเรา Extract เป็น Utility จะใช้ซ้ำได้ใน Module อื่น — ลองพิจารณาดูไหมครับ”

**❌ แบบนี้:**

> “เขียนโค้ดแย่มาก ทำไมไม่แยก Function”

---

# 20. Root Cause Analysis (Architecture-Level)

## 20.1 ตัวอย่าง RCA: Payment Sync ซ้ำใน ERP

### Problem
Payment ถูกสร้างซ้ำใน Oracle ERP ระหว่างช่วง Network Timeout ทำให้ยอดใน ERP ไม่ตรงกับ PMS

### Impact
- ยอดบัญชีคลาดเคลื่อน
- ต้องแก้ไขด้วยมือ ใช้เวลา 1–2 วัน
- เสี่ยงต่อ SOX Compliance

### 5 Whys

1. **Why?** — ระบบ Retry หลัง Timeout
2. **Why?** — ไม่มี Idempotency-Key ใน Request
3. **Why?** — API Contract ไม่ได้ออกแบบรองรับ Retry
4. **Why?** — ขาด Design Review สำหรับ Integration
5. **Why?** — ไม่มี Checklist บังคับสำหรับ Integration Design

### Root Cause
ขาด **Integration Design Checklist** และ **Design Review Process** ที่บังคับใช้

### Corrective Action
- ลบรายการซ้ำใน ERP
- เพิ่ม Idempotency-Key ใน Client ทันที

### Preventive Action
- เพิ่ม Integration Design Checklist ใน Architecture Review
- บังคับ Architect Review สำหรับ Integration ใหม่ทุกตัว
- เพิ่ม Daily Reconciliation Job
- เพิ่ม Alert เมื่อ Mismatch > 0.5%
- Update ADR ให้ Idempotency เป็น Standard

### Monitoring
- KPI: Duplicate Rate (Target = 0%)
- KPI: Reconciliation Mismatch (Target < 0.5%)
- Duration: ต่อเนื่อง 3 เดือน
- Owner: Architect

## 20.2 RCA Checklist สำหรับ Architect

- [ ] มี Timeline ครบ
- [ ] มีหลักฐาน (Log, Metric, Trace)
- [ ] มี 5 Whys หรือ Fishbone
- [ ] ระบุ Root Cause ไม่ใช่ Symptom
- [ ] มี Corrective Action
- [ ] มี Preventive Action ที่ยั่งยืน
- [ ] มี Owner + Due Date
- [ ] มีการติดตามผล
- [ ] อัปเดต ADR / Checklist / Runbook ที่เกี่ยวข้อง

---

# 21. ภาคผนวก: คำศัพท์สองภาษา และเอกสารอ้างอิง

## 21.1 คำศัพท์สองภาษา

| ไทย | English | ความหมาย |
|-----|---------|----------|
| สถาปัตยกรรมระบบ | System Architecture | การออกแบบระบบโดยรวม |
| ขอบเขตระบบ | System Boundary | ขอบเขตที่ระบบรับผิดชอบ |
| บันทึกการตัดสินใจ | ADR | Architecture Decision Record |
| รูปแบบการเชื่อมต่อ | Integration Pattern | รูปแบบการเชื่อมต่อ |
| การป้องกันข้อมูลซ้ำ | Idempotency | Request ซ้ำไม่สร้างข้อมูลซ้ำ |
| การตัดการเชื่อมต่อชั่วคราว | Circuit Breaker | ตัดเมื่อปลายทางล่ม |
| การกระทบยอด | Reconciliation | ตรวจเทียบข้อมูลสองแหล่ง |
| ความสามารถในการสังเกต | Observability | Log/Metric/Trace |
| หนี้ทางเทคนิค | Technical Debt | ภาระที่ต้องชำระในอนาคต |
| การแลกเปลี่ยน | Trade-off | การเลือกแลกคุณสมบัติ |
| ฟังก์ชันวัดสุขภาพ | Fitness Function | ตัววัด Architecture Property |
| การทดสอบโหลด | Load Test | ทดสอบ Performance |
| การทดสอบความทนทาน | Chaos Test | ทดสอบ Resilience |

## 21.2 เอกสารอ้างอิง

- Complete Multi-Role Work Manuals — FinTech & Accounting Technology Solutions
- เล่ม 1: คู่มือ Product Owner / Business Analyst
- เล่ม 2: คู่มือ Full-Stack Engineer
- เล่ม 4: คู่มือ QA / Test Engineer
- เล่ม 5: คู่มือ DevOps / Platform Engineer
- เล่ม 6: คู่มือ Code Reviewer
- เล่ม 7: คู่มือ Incident Commander / On-call
- เล่ม 10: คู่มือ AI-Assisted Development (`tb-*` Skills)
- เล่ม 11: คู่มือ Hotfix & Rollback
- เล่ม 12: คู่มือ CI/CD & Git Flow
- เล่ม 13: คู่มือ RCA
- เล่ม 14: คู่มือ Security & Compliance

## 21.3 มาตรฐานและ Framework อ้างอิง

- **ISO/IEC/IEEE 42010** — Architecture Description
- **TOGAF** — Enterprise Architecture Framework
- **C4 Model** — Architecture Diagram
- **OWASP Top 10** — Security
- **STRIDE** — Threat Modeling
- **OpenAPI 3.1** — API Contract
- **12-Factor App** — Application Design
- **Google SRE Book** — Observability & Reliability

---

# ✅ ภาคผนวกท้ายเล่ม: Architect / Tech Lead Daily Checklist

## ก่อนเริ่ม Sprint
- [ ] ทบทวน Requirement ที่จะเข้า Sprint
- [ ] ระบุ Architecture Impact
- [ ] เขียน ADR ถ้ามี Decision ใหม่
- [ ] ทบทวน Technical Debt Backlog
- [ ] เตรียม Mentor Session

## ระหว่าง Sprint
- [ ] Review Technical Design
- [ ] Review PR ที่ Sensitive
- [ ] Unblock Dev
- [ ] ตรวจ Architecture Drift
- [ ] อัปเดต ADR / Documentation

## ก่อน Release
- [ ] Architecture Review ผ่าน
- [ ] Security Review ผ่าน
- [ ] Performance Test ผ่าน
- [ ] Observability ครบ
- [ ] DR Plan พร้อม
- [ ] Runbook อัปเดต

## หลัง Release
- [ ] Monitor Log / Metric
- [ ] ตรวจ Technical Debt ใหม่
- [ ] อัปเดต ADR / Checklist
- [ ] บันทึก Lessons Learned
- [ ] แชร์ความรู้กับทีม

---
 