# 📘 เล่ม 1: คู่มือ Product Owner / Business Analyst
## Financial & Accounting Technology Solutions
**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับ
**Reference:** https://github.com/kongnakornna/work-book

---
# 📑 สารบัญ (Table of Contents)

- [1. บทนำ (Introduction)](#1-บทนำ-introduction)
- [2. บทนิยาม (Definitions)](#2-บทนิยาม-definitions)
- [3. บทบาทและความรับผิดชอบ (Roles & Responsibilities)](#3-บทบาทและความรับผิดชอบ-roles--responsibilities)
- [4. ความรู้พื้นฐานที่ต้องมี (Prerequisites)](#4-ความรู้พื้นฐานที่ต้องมี-prerequisites)
- [5. โครงสร้างการทำงาน (Team Structure)](#5-โครงสร้างการทำงาน-team-structure)
- [6. หลักการทำงาน (Concept)](#6-หลักการทำงาน-concept)
- [7. Workflow และ Dataflow](#7-workflow-และ-dataflow)
- [8. Product Backlog Management](#8-product-backlog-management)
- [9. User Story & Acceptance Criteria](#9-user-story--acceptance-criteria)
- [10. Case Study](#10-case-study)
- [11. KPI & SMART Criteria](#11-kpi--smart-criteria)
- [12. สรุป (Summary)](#12-สรุป-summary)
- [13. คู่มือการทดสอบ (UAT Guide)](#13-คู่มือการทดสอบ-uat-guide)
- [14. คู่มือการใช้งาน (User Guide)](#14-คู่มือการใช้งาน-user-guide)
- [15. คู่มือการบำรุงรักษา (Maintenance Guide)](#15-คู่มือการบำรุงรักษา-maintenance-guide)
- [16. คู่มือการขยาย/แก้ไข (Extension Guide)](#16-คู่มือการขยายแก้ไข-extension-guide)
- [17. Code Review & PR Checklist (สำหรับ PO/BA ที่ร่วม Review)](#17-code-review--pr-checklist-สำหรับ-poba-ที่ร่วม-review)
- [18. Root Cause Analysis (RCA)](#18-root-cause-analysis-rca)
- [19. ภาคผนวก: คำศัพท์สองภาษา](#19-ภาคผนวก-คำศัพท์สองภาษา)
- [20. เอกสารอ้างอิง (References)](#20-เอกสารอ้างอิง-references)

---

# 1. บทนำ (Introduction)

## 1.1 ภาพรวมคืออะไร (What is it?)

คู่มือนี้จัดทำขึ้นสำหรับ **Product Owner (PO)**, **Business Analyst (BA)** และ **Product Manager (PM)** ในทีม **Financial & Accounting Technology Solutions** เพื่อใช้เป็นแนวทางปฏิบัติงานตั้งแต่การค้นหาความต้องการ (Discover) ไปจนถึงการยอมรับงาน (Accept) โดยมุ่งเน้นการแปลง **Workflow ทางธุรกิจด้านการเงินและบัญชี** ที่ซับซ้อนให้เป็น **User Story** และ **Acceptance Criteria** ที่ชัดเจน ส่งต่อให้ทีมวิศวกรพัฒนาเป็นผลิตภัณฑ์ที่ใช้งานได้จริง

## 1.2 คำนำ (Preface)

ในองค์กรขนาดใหญ่ งานด้านการเงินและบัญชีเกี่ยวข้องกับผู้ใช้หลายกลุ่ม ระบบหลายระบบ (Oracle ERP, Databricks, Power BI, SharePoint, SFTP, Email, Webhooks) และกฎเกณฑ์ทางธุรกิจที่เข้มงวด PO/BA จึงต้องเป็น **สะพานเชื่อม (Bridge)** ระหว่าง **Business** และ **Technology** ที่สามารถ:

- เข้าใจ Pain Points ของผู้ใช้ Finance/Accounting อย่างลึกซึ้ง
- แปลงความคลุมเครือให้เป็นข้อกำหนดที่วัดผลได้
- จัดลำดับความสำคัญของ Backlog ตามคุณค่าธุรกิจ
- สื่อสารกับทีมวิศวกรและ Stakeholder ได้อย่างมีประสิทธิภาพ

คู่มือนี้รวบรวม **หลักการ (Concept)**, **Workflow**, **แม่แบบ (Templates)**, **Case Study**, **KPI**, และ **Checklist** ที่พร้อมใช้งานจริง

## 1.3 วัตถุประสงค์ (Objectives)

1. กำหนดมาตรฐานการทำงานของ PO/BA ในทีม FinTech & Accounting
2. สร้างความเข้าใจร่วมกันระหว่าง Business และ Technology
3. ลดความคลุมเครือ (Ambiguity) ในการแปลงความต้องการเป็น User Story
4. ยกระดับคุณภาพของ Acceptance Criteria และ UAT
5. สร้างวัฒนธรรมการตัดสินใจที่บันทึกเหตุผล (Decision Log) และวัดผลได้ (KPI)

## 1.4 เป้าหมาย (Goals)

- **ลด Lead Time** ของการ Refine Story ให้ ≤ 2 วัน
- **เพิ่มความสมบูรณ์** ของ Acceptance Criteria เป็น 100%
- **ยกระดับ UAT Pass Rate** (First Round) ≥ 90%
- **เพิ่มความพึงพอใจ** ของ Stakeholder ≥ 4.5/5
- **ลด Defect Leakage** จาก Requirement ที่คลุมเครือ < 5%

## 1.5 ความรู้พื้นฐานที่ต้องมี (Prerequisites)

| ด้าน | ความรู้ที่ต้องมี |
|------|------------------|
| **Business Domain** | กระบวนการการเงิน/บัญชี, ERP (Oracle), Financial Reporting |
| **Requirement Engineering** | User Story, Acceptance Criteria, Given-When-Then |
| **Agile/Scrum** | Sprint, Backlog Grooming, Retrospective, DoD |
| **Prioritization** | MoSCoW, WSJF, RICE |
| **Tools** | Jira/Linear, Confluence, Miro/Figma, Excel/Sheets |
| **Communication** | การสัมภาษณ์, การนำเสนอ, การเขียนเอกสาร |
| **Technical Literacy** | เข้าใจ API, Database, Integration พื้นฐาน |

## 1.6 กลุ่มเป้าหมาย (Target Audience)

| กลุ่ม | บทบาท |
|-------|-------|
| **Product Owner (PO)** | เจ้าของผลิตภัณฑ์, จัดลำดับ Backlog, Accept งาน |
| **Business Analyst (BA)** | วิเคราะห์ธุรกิจ, เขียน Requirement, ออกแบบ Workflow |
| **Product Manager (PM)** | กำหนด Vision, Strategy, Roadmap |
| **Key User (Finance/Accounting)** | ผู้ใช้หลักที่ให้ข้อมูลความต้องการ |

---

# 2. บทนิยาม (Definitions)

## 2.1 Product Owner (PO) คืออะไร

**Product Owner** คือผู้ที่เป็นเจ้าของผลิตภัณฑ์ (Product) มีหน้าที่ **กำหนดทิศทาง**, **จัดลำดับความสำคัญของ Backlog**, และ **ยอมรับงาน (Accept)** ที่ทีมส่งมอบ

- **วัตถุประสงค์:** ทำให้ผลิตภัณฑ์ตอบโจทย์ธุรกิจและผู้ใช้สูงสุด
- **เป้าหมาย:** ส่งมอบคุณค่า (Value) อย่างต่อเนื่องและวัดผลได้

## 2.2 Business Analyst (BA) คืออะไร

**Business Analyst** คือผู้วิเคราะห์ธุรกิจ มีหน้าที่ **ค้นหาความต้องการ**, **วิเคราะห์ Workflow**, และ **แปลงเป็นข้อกำหนด** ที่ชัดเจน

- **วัตถุประสงค์:** ลดช่องว่าง (Gap) ระหว่าง Business และ Technology
- **เป้าหมาย:** ข้อกำหนดที่ชัดเจน ครบถ้วน วัดผลได้

## 2.3 Product Manager (PM) คืออะไร

**Product Manager** คือผู้กำหนด **Vision**, **Strategy**, และ **Roadmap** ของผลิตภัณฑ์

- **วัตถุประสงค์:** ทำให้ผลิตภัณฑ์สอดคล้องกับกลยุทธ์องค์กร
- **เป้าหมาย:** ผลิตภัณฑ์ที่สร้างคุณค่าทางธุรกิจอย่างยั่งยืน

## 2.4 User Story คืออะไร

**User Story** คือคำอธิบายความต้องการจากมุมมองผู้ใช้ ในรูปแบบ:

> **As a** [ผู้ใช้]
> **I want** [ความต้องการ]
> **So that** [คุณค่าทางธุรกิจ]

## 2.5 Acceptance Criteria คืออะไร

**Acceptance Criteria** คือเงื่อนไขที่ต้องผ่านเพื่อยอมรับ Story ว่าเสร็จสมบูรณ์ นิยมเขียนแบบ **Given-When-Then**

## 2.6 Definition of Ready (DoR) และ Definition of Done (DoD)

- **DoR:** เงื่อนไขที่ Story ต้องพร้อมก่อนเข้าสู่ Sprint
- **DoD:** เงื่อนไขที่ Story ต้องผ่านก่อนถือว่าเสร็จ

## 2.7 PSR (Problem-Solution-Result)

โครงสร้างการคิดและการนำเสนอ 3 ส่วน:
- **Problem (ปัญหา):** สถานการณ์ที่ต้องแก้ไข
- **Solution (วิธีแก้):** แนวทางที่ใช้
- **Result (ผลลัพธ์):** ผลที่เกิดขึ้น วัดผลได้

---

# 3. บทบาทและความรับผิดชอบ (Roles & Responsibilities)

## 3.1 ตารางบทบาท (Role Matrix)
----
ตัวย่อ	คำเต็ม (ภาษาอังกฤษ)	คำอ่าน (ภาษาไทย)	คำแปล (ภาษาไทย)
PO	Product Owner	โพร-ดักต์ โอน-เนอร์	เจ้าของผลิตภัณฑ์
BA	Business Analyst	บิส-ซิ-เนส แอ-นา-ลิสต์	นักวิเคราะห์ธุรกิจ / นักวิเคราะห์ระบบงาน
PM	Project Manager	โพร-เจกต์ แม-เน-เจอร์	ผู้จัดการโครงการ
Key User	Key User	คีย์ ยูส-เซอร์	ผู้ใช้งานหลัก / ตัวแทนผู้ใช้งาน
Dev	Developer	ดี-เวล-ลอป-เปอร์	นักพัฒนาซอฟต์แวร์ / โปรแกรมเมอร์
QA	Quality Assurance	ควอ-ลิ-ตี้ แอส-ชัว-แรนซ์	ผู้ดูแลคุณภาพซอฟต์แวร์ / ผู้ทดสอบระบบ
Architect	System / Software Architect	อาร์-คิ-เทคต์	สถาปนิกระบบ / สถาปนิกซอฟต์แวร์

คำอธิบายบทบาทหน้าที่โดยย่อ

```bash
• PO (Product Owner). กำหนดทิศทาง วิสัยทัศน์ และจัดลำดับความสำคัญของฟีเจอร์ต่างๆ เพื่อให้ผลิตภัณฑ์สร้างคุณค่าทางธุรกิจได้สูงสุด.
• BA (Business Analyst). รวบรวมความต้องการจากผู้ใช้งาน แล้วนำมาวิเคราะห์และเขียนเป็นเอกสารข้อกำหนด (Requirement / User Story) ให้ทีมพัฒนาเข้าใจตรงกัน.
• PM (Project Manager). บริหารจัดการแผนงาน ระยะเวลา งบประมาณ และทรัพยากรของโครงการให้เดินหน้าไปได้อย่างราบรื่น.
• Key User. ตัวแทนผู้ใช้งานจริงที่ให้ข้อมูลความต้องการเชิงลึก และร่วมทดสอบระบบในขั้นตอน UAT เพื่อยืนยันว่าใช้งานได้จริง.
• Dev (Developer). ออกแบบโครงสร้างโค้ดและเขียนโปรแกรมเพื่อพัฒนาฟีเจอร์ต่างๆ ตามข้อกำหนดที่ได้รับ.
• QA (Quality Assurance). วางแผนและทดสอบการทำงานของระบบ เพื่อค้นหาข้อผิดพลาด (Bug) และรับรองคุณภาพก่อนส่งมอบ.
• Architect. ออกแบบสถาปัตยกรรมภาพรวมของระบบ โครงสร้างฐานข้อมูล และเลือกใช้เทคโนโลยีให้รองรับการขยายตัวในอนาคต.
```
----

| กิจกรรม | PO | BA | PM | Key User | Dev | QA | Architect |
|---------|----|----|----|----------|-----|----|-----------|
| กำหนด Vision/Strategy | C | I | **R** | I | I | I | C |
| Discover Requirement | A | **R** | C | **R** | C | C | C |
| เขียน User Story | **R** | **R** | I | C | C | C | I |
| Acceptance Criteria | **R** | **R** | I | C | C | C | I |
| จัดลำดับ Backlog | **R** | C | A | C | C | I | I |
| Refine กับทีม | **R** | **R** | I | C | **R** | **R** | C |
| UAT | **R** | **R** | I | **R** | C | C | I |
| Accept/Sign-off | **R** | C | A | C | I | I | I |
| Stakeholder Communication | **R** | C | **R** | I | I | I | I |

**R** = Responsible | **A** = Accountable | **C** = Consulted | **I** = Informed
----
```bash
R = Responsible (ริส-ปอน-ซิ-เบิล : ผู้ลงมือทำ) 
A = Accountable (แอค-เคาน์-ทะ-เบิล : ผู้รับผิดชอบหลัก/ผู้อนุมัติ) 
C = Consulted (คอน-ซัล-ทิด : ผู้ให้คำปรึกษา) 
I = Informed (อิน-ฟอร์มด์ : ผู้รับทราบข้อมูล)
รายละเอียดคำแปลและคำอ่านทีละตัว
• R = Responsible อ่านว่า ริส-ปอน-ซิ-เบิล แปลว่า ผู้รับผิดชอบลงมือทำ. คือคนที่ปฏิบัติงานนั้นให้เสร็จตามหน้าที่ที่ได้รับมอบหมาย.
• A = Accountable อ่านว่า แอค-เคาน์-ทะ-เบิล แปลว่า ผู้รับผิดชอบหลักและมีอำนาจตัดสินใจ. คือเจ้าของงานที่รับผิดชอบต่อผลลัพธ์สุดท้ายและเป็นผู้อนุมัติงาน.
• C = Consulted อ่านว่า คอน-ซัล-ทิด แปลว่า ผู้ให้คำปรึกษา. คือผู้เชี่ยวชาญหรือผู้เกี่ยวข้องที่ต้องให้ข้อมูลและความเห็นก่อนหรือระหว่างทำงาน.
• I = Informed อ่านว่า อิน-ฟอร์มด์ แปลว่า ผู้รับทราบข้อมูล. คือผู้ที่ต้องได้รับแจ้งความคืบหน้าหรือผลลัพธ์ของงานนั้นๆ.
```
## 3.2 ความรับผิดชอบหลักของ PO

1. เป็นเจ้าของ Product Backlog และจัดลำดับความสำคัญ
2. กำหนด Acceptance Criteria ร่วมกับ BA
3. Accept งานที่ผ่าน UAT
4. สื่อสารกับ Stakeholder ตามรอบ
5. ตัดสินใจเรื่อง Scope และ Priority

## 3.3 ความรับผิดชอบหลักของ BA

1. สัมภาษณ์ผู้ใช้และรวบรวมความต้องการ
2. วิเคราะห์ Workflow และ Pain Points
3. เขียน User Story และ Acceptance Criteria
4. ออกแบบ Process Diagram / Wireframe (ร่วมกับ Designer)
5. ช่วยทีม Dev ในการ Clarify Requirement

## 3.4 ความรับผิดชอบหลักของ PM

1. กำหนด Vision, Strategy, Roadmap
2. จัดลำดับ Epic ตามคุณค่าธุรกิจ
3. ตัดสินใจเชิงกลยุทธ์ (Build/Buy/Partner)
4. สื่อสารกับผู้บริหาร
5. วัดผลผลิตภัณฑ์ด้วย KPI ระดับองค์กร

---

# 4. ความรู้พื้นฐานที่ต้องมี (Prerequisites)

## 4.1 ความรู้ด้านธุรกิจ (Business Domain)

| หัวข้อ | รายละเอียด |
|-------|-----------|
| **Financial Workflow** | การรับเงิน, การจ่ายเงิน, การกระทบยอด, การปิดบัญชี |
| **Accounting** | Debit/Credit, Journal Entry, Trial Balance, GL |
| **ERP** | Oracle ERP (AP, AR, GL modules) |
| **Reporting** | Financial Statement, P&L, Balance Sheet |
| **Compliance** | SOX, PDPA, มาตรฐานบัญชีไทย |

## 4.2 ความรู้ด้าน Requirement Engineering

- **User Story Mapping** — แผนที่การเดินทางของผู้ใช้
- **Acceptance Criteria** — Given-When-Then
- **MoSCoW** — Must/Should/Could/Won't
- **WSJF** — Weighted Shortest Job First
- **RICE** — Reach, Impact, Confidence, Effort

## 4.3 ความรู้ด้าน Agile/Scrum

- Sprint (2 สัปดาห์)
- Backlog Grooming (สัปดาห์ละครั้ง)
- Sprint Planning / Review / Retrospective
- Definition of Ready / Done

## 4.4 ความรู้ด้าน Technical Literacy

- **API:** REST, JSON, HTTP Status Codes
- **Database:** Table, Field, Index, Migration
- **Integration:** Idempotency, Retry, Reconciliation
- **Security:** SSO/RBAC, Secrets Management
- **Observability:** Log, Metric, Trace

---

# 5. โครงสร้างการทำงาน (Team Structure)

```
┌─────────────────────────────────────────────────────────────┐
│                  TEAM STRUCTURE (FinTech & Acc)             │
└─────────────────────────────────────────────────────────────┘

                    ┌──────────────┐
                    │ Product Mgr  │  (Vision, Strategy, Roadmap)
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │    PO    │ │    BA    │ │ Key User │
        │(Backlog) │ │(Require) │ │(Finance) │
        └────┬─────┘ └────┬─────┘ └────┬─────┘
             │            │            │
             └────────────┼────────────┘
                          ▼
              ┌───────────────────────┐
              │  Cross-Functional Team│
              ├───────────────────────┤
              │ • Full-Stack Engineer │
              │ • Solution Architect  │
              │ • QA / Test Engineer  │
              │ • DevOps / SRE        │
              │ • UX Designer         │
              └───────────────────────┘
```

## 5.1 บทบาทในทีม

| บทบาท | จำนวน | หน้าที่หลัก |
|-------|-------|-------------|
| Product Manager | 1 | Vision, Strategy, Roadmap |
| Product Owner | 1 | Backlog, Priority, Accept |
| Business Analyst | 1–2 | Requirement, Workflow |
| Key User (Finance/Acc) | 2–3 | ให้ข้อมูล, UAT |
| Solution Architect | 1 | System Design, ADR |
| Full-Stack Engineer | 3–5 | Development |
| QA / Test Engineer | 1–2 | Test Strategy, UAT Support |
| DevOps / SRE | 1 | CI/CD, Observability |
| UX Designer | 1 | Wireframe, Prototype |

## 5.2 การสื่อสาร (Communication)

| การประชุม | ความถี่ | ผู้เข้าร่วม | ระยะเวลา |
|----------|---------|-----------|----------|
| Daily Standup | ทุกวัน | Dev Team | 15 นาที |
| Backlog Grooming | สัปดาห์/ครั้ง | PO, BA, Dev, QA | 1 ชั่วโมง |
| Sprint Planning | 2 สัปดาห์/ครั้ง | ทีมทั้งหมด | 2 ชั่วโมง |
| Sprint Review | 2 สัปดาห์/ครั้ง | ทีม + Stakeholder | 1 ชั่วโมง |
| Retrospective | 2 สัปดาห์/ครั้ง | ทีม | 1 ชั่วโมง |
| Stakeholder Update | เดือน/ครั้ง | PM, PO, Mgmt | 1 ชั่วโมง |
| UAT Session | ตามรอบ Release | PO, BA, Key User, QA | 2–4 ชั่วโมง |

---

# 6. หลักการทำงาน (Concept)

## 6.1 หลักการ 5 ประการของ PO/BA

### 1. **Business Value First** (คุณค่าธุรกิจมาก่อน)
ทุก Story ต้องตอบคำถามได้ว่า "สร้างคุณค่าอะไรให้ธุรกิจ/ผู้ใช้"

### 2. **Clarity over Completeness** (ชัดเจนดีกว่าครบถ้วน)
Story ที่ชัดเจน 100% ดีกว่า Story ที่คลุมเครือ 500 บรรทัด

### 3. **Collaborate, Don't Dictate** (ร่วมมือ ไม่ใช่สั่งการ)
PO/BA ทำงานร่วมกับ Dev/QA ในการ Refine ไม่ใช่สั่งงานทางเดียว

### 4. **Decide & Document** (ตัดสินใจและบันทึก)
ทุกการตัดสินใจสำคัญต้องบันทึกเป็น **Decision Log** (ADR-style)

### 5. **Measure & Iterate** (วัดผลและปรับปรุง)
ใช้ KPI วัดผล และปรับปรุงกระบวนการอย่างต่อเนื่อง

## 6.2 PSR Framework (Problem-Solution-Result)

```
┌──────────────────────────────────────────────────────────────┐
│                    PSR FRAMEWORK                             │
└──────────────────────────────────────────────────────────────┘

  ┌────────────┐      ┌────────────┐      ┌────────────┐
  │  PROBLEM   │─────▶│  SOLUTION  │─────▶│   RESULT   │
  │  (ปัญหา)   │      │  (วิธีแก้)  │      │  (ผลลัพธ์)  │
  └────────────┘      └────────────┘      └────────────┘
        │                   │                   │
        ▼                   ▼                   ▼
  • Pain Point        • User Story        • KPI
  • Impact            • Acceptance        • Metric
  • User Group        • Design            • Outcome
```

**หลักการจำ PSR:**
1. **Story** — เริ่มด้วยตัวร้าย (Problem) → วิธีสู้ (Solution) → ฉากจบแฮปปี้ (Result)
2. **Emotion** — ปัญหากระตุ้นความรู้สึกอยากช่วย ผลลัพธ์สร้างความภูมิใจ
3. **Chunking** — แบ่งเป็น 3 ก้อน ชัดเจน จำง่าย

## 6.3 หลักการจัดลำดับความสำคัญ (Prioritization)

| Framework | ใช้เมื่อ | ตัวอย่าง |
|-----------|---------|----------|
| **MoSCoW** | จัดลำดับ Feature | Must/Should/Could/Won't |
| **WSJF** | เรียงตาม Cost of Delay | (Business Value + Time Criticality + Risk Reduction) / Job Size |
| **RICE** | Score Feature | (Reach × Impact × Confidence) / Effort |
| **Kano** | วิเคราะห์ความพึงพอใจ | Basic / Performance / Delighter |

## 6.4 หลักการเขียน Acceptance Criteria ที่ดี

- **Specific** — เจาะจง วัดผลได้
- **Testable** — ทดสอบได้จริง
- **Independent** — ไม่ขึ้นกับ Story อื่น
- **Complete** — ครอบคลุม Happy Path + Edge Cases
- **Given-When-Then** — โครงสร้างชัดเจน

---

# 7. Workflow และ Dataflow

## 7.1 PO/BA Workflow หลัก (6 ขั้น)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    PO/BA WORKFLOW (6 STEPS)                         │
└─────────────────────────────────────────────────────────────────────┘

  ┌──────────────┐
  │ 1. DISCOVER  │  สัมภาษณ์ผู้ใช้ · สังเกต Workflow · รวบรวม Pain Points
  └──────┬───────┘
         ▼
  ┌──────────────┐
  │ 2. DEFINE    │  เขียน Problem Statement · กำหนด Scope
  └──────┬───────┘
         ▼
  ┌──────────────┐
  │ 3. PRIORITIZE│  จัดลำดับ P0/P1/P2/P3 · ใช้ MoSCoW/WSJF
  └──────┬───────┘
         ▼
  ┌──────────────┐
  │ 4. REFINE    │  Backlog Grooming · แยก Technical Task
  └──────┬───────┘
         ▼
  ┌──────────────┐
  │ 5. ACCEPT    │  UAT · ตรวจ Acceptance Criteria · Sign-off
  └──────┬───────┘
         ▼
  ┌──────────────┐
  │ 6. MEASURE   │  วัด KPI · เก็บ Feedback · Iterate
  └──────────────┘
```

## 7.2 Dataflow Diagram (จำลองลักษณะ Flowchart)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    DATAFLOW: Requirement → Delivery                 │
└─────────────────────────────────────────────────────────────────────┘

┌────────────┐    ┌────────────┐    ┌────────────┐    ┌────────────┐
│ Key User   │───▶│  PO / BA   │───▶│  Backlog   │───▶│ Dev Team   │
│ (Finance)  │    │ (Discover) │    │  (Jira)    │    │ (Refine)   │
└────────────┘    └────────────┘    └────────────┘    └─────┬──────┘
                                                            │
                                                            ▼
┌────────────┐    ┌────────────┐    ┌────────────┐    ┌────────────┐
│  KPI       │◀───│  Accept    │◀───│    UAT     │◀───│  Staging   │
│  (Measure) │    │ (Sign-off) │    │  (Test)    │    │ (Deploy)   │
└────────────┘    └────────────┘    └────────────┘    └────────────┘
       │
       ▼
┌────────────┐
│ Feedback   │───▶ กลับไปยัง Discover (Iterate)
│ Loop       │
└────────────┘
```

## 7.3 อธิบาย Workflow แบบละเอียด

### ขั้นตอนที่ 1: Discover (ค้นหาปัญหา)

- **ผู้รับผิดชอบ:** BA (หลัก), PO (ร่วม), Key User (ให้ข้อมูล)
- **กิจกรรม:**
  - สัมภาษณ์ผู้ใช้ Finance/Accounting
  - สังเกต Workflow จริง (Job Shadowing)
  - รวบรวม Pain Points และ Wish List
  - วิเคราะห์ As-Is Process
- **ผลลัพธ์:** Problem Statement + As-Is Process Diagram
- **เครื่องมือ:** Interview Guide, Miro, Excel
- **ระยะเวลา:** 2–3 วัน

### ขั้นตอนที่ 2: Define (กำหนดข้อกำหนด)

- **ผู้รับผิดชอบ:** PO + BA
- **กิจกรรม:**
  - เขียน Problem Statement (PSR)
  - กำหนด Scope (In/Out)
  - ร่าง User Story + Acceptance Criteria
  - ระบุ Dependencies
- **ผลลัพธ์:** User Story Draft + Scope Document
- **เครื่องมือ:** Jira, Confluence
- **ระยะเวลา:** 2–3 วัน

### ขั้นตอนที่ 3: Prioritize (จัดลำดับ)

- **ผู้รับผิดชอบ:** PO (หลัก), PM (อนุมัติ)
- **กิจกรรม:**
  - จัดลำดับ P0/P1/P2/P3
  - ใช้ MoSCoW / WSJF / RICE
  - ตรวจสอบกับ Roadmap
- **ผลลัพธ์:** Prioritized Backlog
- **เครื่องมือ:** Jira, Excel (Score Card)
- **ระยะเวลา:** 1 วัน

### ขั้นตอนที่ 4: Refine (กลั่นกรอง)

- **ผู้รับผิดชอบ:** PO + BA + Dev + QA
- **กิจกรรม:**
  - Backlog Grooming
  - แยก Technical Task
  - Clarify Requirement
  - ตรวจสอบ DoR
- **ผลลัพธ์:** Ready Story (ผ่าน DoR)
- **เครื่องมือ:** Jira, Miro
- **ระยะเวลา:** 1 ชั่วโมง/สัปดาห์

### ขั้นตอนที่ 5: Accept (ยอมรับงาน)

- **ผู้รับผิดชอบ:** PO (หลัก), BA, Key User, QA
- **กิจกรรม:**
  - UAT ตาม Acceptance Criteria
  - ตรวจ Edge Cases
  - Sign-off
- **ผลลัพธ์:** Accepted Story / Rejected with Feedback
- **เครื่องมือ:** Test Case, UAT Sign-off Form
- **ระยะเวลา:** 2–4 ชั่วโมง/รอบ

### ขั้นตอนที่ 6: Measure (วัดผล)

- **ผู้รับผิดชอบ:** PO + PM
- **กิจกรรม:**
  - วัด KPI หลัง Release
  - เก็บ Feedback ผู้ใช้
  - Iterate / ปรับปรุง
- **ผลลัพธ์:** KPI Report + Improvement Plan
- **เครื่องมือ:** Dashboard, Survey
- **ระยะเวลา:** ต่อเนื่อง

## 7.4 Workflow สถานะของ Story (State Diagram)

```
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│ Backlog  │──▶│  Ready   │──▶│In Progress│──▶│  Review  │──▶│   Done   │
└──────────┘   └──────────┘   └──────────┘   └──────────┘   └──────────┘
     ▲              │               │               │              │
     │              │               │               │              │
     │              ▼               ▼               ▼              │
     │         ┌──────────┐   ┌──────────┐   ┌──────────┐         │
     └─────────│ Blocked  │   │  Reject  │   │  Reject  │◀────────┘
               └──────────┘   └──────────┘   └──────────┘
                                (กลับไป In Progress / Backlog)
```

---

# 8. Product Backlog Management

## 8.1 โครงสร้าง Backlog

```
ID | Feature | Description | Priority | Complexity | Status | Sprint | Owner
```

| Field | คำอธิบาย | ตัวอย่าง |
|-------|----------|----------|----------|
| **ID** | รหัส Feature | F-001 |
| **Feature** | ชื่อ Feature | Payment Reconciliation |
| **Description** | คำอธิบายสั้น | กระทบยอดอัตโนมัติ |
| **Priority** | P0/P1/P2/P3 | P0 |
| **Complexity** | S/M/L/XL | L |
| **Status** | Backlog/Ready/In Progress/Done | In Progress |
| **Sprint** | Sprint Number | Sprint 12 |
| **Owner** | ผู้รับผิดชอบ | Somchai |

## 8.2 ตัวอย่าง Backlog (จริง)

| ID | Feature | Description | Priority | Complexity | Status |
|----|---------|-------------|----------|-----------|--------|
| F-001 | Payment Reconciliation | กระทบยอดอัตโนมัติจาก ERP | P0 | L | In Progress |
| F-002 | ERP Sync | Sync ข้อมูลกับ Oracle ERP | P1 | L | Ready |
| F-003 | Dashboard Report | Dashboard การเงิน Real-time | P2 | M | Backlog |
| F-004 | Export to Excel | Export รายงานเป็น Excel | P2 | S | Backlog |
| F-005 | Email Notification | แจ้งเตือนทางอีเมล | P3 | S | Backlog |

## 8.3 การจัดลำดับความสำคัญ (Prioritization)

### 8.3.1 ระดับความสำคัญ (Priority Levels)

| ระดับ | ความหมาย | ตัวอย่าง | SLA |
|-------|----------|----------|-----|
| **P0 — Critical** | ระบบล่ม / Compliance / Blocking | Payment ล่ม | ทันที |
| **P1 — High** | สำคัญต่อธุรกิจ / Deadline ใกล้ | ERP Sync | ≤ 1 Sprint |
| **P2 — Medium** | ปรับปรุงประสิทธิภาพ | Dashboard | ≤ 2 Sprints |
| **P3 — Low** | Nice to have | Email Notification | ตามว่าง |

### 8.3.2 WSJF (Weighted Shortest Job First)

```
WSJF = (Business Value + Time Criticality + Risk Reduction) / Job Size
```

| Feature | BV | TC | RR | Size | WSJF | Priority |
|---------|----|----|----|------|------|----------|
| F-001 | 8 | 9 | 7 | 5 | 4.8 | 1 (P0) |
| F-002 | 7 | 6 | 6 | 8 | 2.4 | 2 (P1) |
| F-003 | 5 | 4 | 3 | 3 | 4.0 | 3 (P2) |
| F-004 | 3 | 2 | 2 | 1 | 7.0 | 4 (P2) |

## 8.4 Backlog Grooming Checklist

- [ ] Story ผ่าน Definition of Ready (DoR)
- [ ] Acceptance Criteria ชัดเจน วัดผลได้
- [ ] Dependencies ระบุครบ
- [ ] Technical Task แยกแล้ว
- [ ] Effort Estimate (Story Point)
- [ ] Priority ยืนยันแล้ว
- [ ] Owner ระบุแล้ว
- [ ] UI/Wireframe (ถ้ามี) แนบแล้ว

## 8.5 Definition of Ready (DoR)

Story พร้อมเข้าสู่ Sprint เมื่อ:

- [ ] มี Title และ Description ที่ชัดเจน
- [ ] มี Acceptance Criteria (Given-When-Then)
- [ ] มี Business Value ระบุ
- [ ] มี Effort Estimate (Story Point)
- [ ] มี Dependencies ระบุ
- [ ] มี UI/Wireframe (ถ้าจำเป็น)
- [ ] ทีมเข้าใจ Story (ผ่าน Refine)

## 8.6 Definition of Done (DoD)

Story เสร็จสมบูรณ์เมื่อ:

- [ ] Code ผ่าน Code Review
- [ ] Unit Test ผ่าน Coverage ≥ 80%
- [ ] Integration Test ผ่าน
- [ ] Acceptance Criteria ผ่านทุกข้อ
- [ ] Deploy บน Staging
- [ ] UAT Sign-off
- [ ] Documentation อัปเดต
- [ ] No Defect (หรือ Defect ที่ Accept ได้)

---

# 9. User Story & Acceptance Criteria

## 9.1 User Story Template

```markdown
# User Story: [ชื่อ Story]

**ID:** US-XXX
**Epic:** [Epic Name]
**Priority:** [P0/P1/P2/P3]
**Sprint:** [Sprint Number]
**Owner:** [ชื่อ PO/BA]
**Status:** [Backlog/Ready/In Progress/Done]

## 📖 Story

**As a** [บทบาทผู้ใช้]
**I want** [ความต้องการ]
**So that** [คุณค่าทางธุรกิจ]

## 🎯 Acceptance Criteria (Given-When-Then)

### AC-1: [ชื่อเกณฑ์]
- **Given** [บริบทเริ่มต้น]
- **When** [การกระทำ]
- **Then** [ผลลัพธ์ที่คาดหวัง]

### AC-2: [ชื่อเกณฑ์]
- **Given** [บริบท]
- **When** [การกระทำ]
- **Then** [ผลลัพธ์]

## 📊 Business Value

- **คุณค่าทางธุรกิจ:** [อธิบาย]
- **ผลกระทบต่อ KPI:** [เช่น ลดเวลาทำงาน 20%]
- **ผู้ใช้ที่ได้รับประโยชน์:** [จำนวน/กลุ่ม]

## 🔗 Dependencies

- [ ] [Story/Task ที่ต้องทำก่อน]
- [ ] [Story/Task ที่เกี่ยวข้อง]

## 🚫 Out of Scope

- [สิ่งที่ไม่รวมใน Story นี้]

## 🧪 Test Data

- full_name: "Somchai Jaidee"
- email: "somchai@example.com"

## 📎 Attachments

- Wireframe: [link]
- Diagram: [link]
- Prototype: [link]

## 📝 Notes

[หมายเหตุเพิ่มเติม]
```

## 9.2 ตัวอย่าง User Story (จริง)

### ตัวอย่าง: POST /employee — เพิ่มข้อมูลพนักงาน

```markdown
# User Story: เพิ่มข้อมูลพนักงาน

**ID:** US-101
**Epic:** Employee Management
**Priority:** P0
**Sprint:** Sprint 12
**Owner:** Somchai (BA)
**Status:** Ready

## 📖 Story

**As a** ผู้ใช้ Finance/Accounting
**I want** เพิ่มข้อมูลพนักงานผ่านระบบ
**So that** ข้อมูลพนักงานถูกบันทึกและใช้ในการคำนวณเงินเดือนได้อย่างถูกต้อง

## 🎯 Acceptance Criteria

### AC-1: เพิ่มข้อมูลสำเร็จ
- **Given** ผู้ใช้กรอก full_name และ email ที่ไม่ซ้ำ
- **When** ผู้ใช้คลิก Submit
- **Then** ระบบบันทึกข้อมูลและ return HTTP 201 พร้อม id (UUID), created_at = updated_at

### AC-2: full_name ว่าง
- **Given** ผู้ใช้ไม่กรอก full_name
- **When** ผู้ใช้คลิก Submit
- **Then** ระบบ return HTTP 400 พร้อมข้อความ "full_name is required"

### AC-3: email ว่าง
- **Given** ผู้ใช้ไม่กรอก email
- **When** ผู้ใช้คลิก Submit
- **Then** ระบบ return HTTP 400 พร้อมข้อความ "email is required"

### AC-4: email ซ้ำ
- **Given** มี email นี้ในระบบแล้ว
- **When** ผู้ใช้กรอก email ซ้ำและคลิก Submit
- **Then** ระบบ return HTTP 409 พร้อมข้อความ "email already exists"

### AC-5: id auto-generate UUID
- **Given** ผู้ใช้กรอกข้อมูลครบ
- **When** ระบบบันทึก
- **Then** id ถูก generate เป็น UUID v4 อัตโนมัติ

### AC-6: created_at = updated_at ตอน Create
- **Given** ผู้ใช้กรอกข้อมูลครบ
- **When** ระบบบันทึก
- **Then** created_at และ updated_at เป็นเวลาเดียวกัน (เวลาที่ Create)

## 📊 Business Value

- **คุณค่าทางธุรกิจ:** ลดเวลาการบันทึกด้วยมือ 60%
- **ผลกระทบต่อ KPI:** ลดข้อผิดพลาดข้อมูล 80%
- **ผู้ใช้ที่ได้รับประโยชน์:** ทีมบัญชี 20 คน

## 🔗 Dependencies

- [ ] Database Schema: Employee Table
- [ ] API Contract: POST /employee

## 🚫 Out of Scope

- การแก้ไขข้อมูลพนักงาน (Update)
- การลบข้อมูลพนักงาน (Delete)

## 🧪 Test Data

| full_name | email | Expected |
|-----------|-------|----------|
| Somchai | somchai@example.com | 201 Created |
| (ว่าง) | test@example.com | 400 Bad Request |
| Test | (ว่าง) | 400 Bad Request |
| Test | somchai@example.com | 409 Conflict |

## 📎 Attachments

- Wireframe: [link]
- API Spec: [link]
```

## 9.3 หลักการเขียน Acceptance Criteria ที่ดี

### ✅ ควรทำ

- ใช้ **Given-When-Then** ทุกข้อ
- ครอบคลุม **Happy Path + Edge Cases**
- วัดผลได้ (Testable)
- อิสระจากกัน (Independent)
- ระบุ **HTTP Status Code** (สำหรับ API)
- ระบุ **ข้อความ Error** ที่ชัดเจน

### ❌ ไม่ควรทำ

- เขียนคลุมเครือ ("ระบบควรทำงานได้ดี")
- รวมหลายเงื่อนไขในข้อเดียว
- ไม่ระบุผลลัพธ์ที่วัดได้
- ขึ้นกับ Story อื่น
- ละเลย Edge Cases

## 9.4 ตัวอย่าง Acceptance Criteria ที่ไม่ดี vs ดี

### ❌ ไม่ดี
> ระบบต้องเพิ่มพนักงานได้

### ✅ ดี
> **Given** ผู้ใช้กรอก full_name และ email ที่ไม่ซ้ำ
> **When** ผู้ใช้คลิก Submit
> **Then** ระบบ return HTTP 201 พร้อม id (UUID), full_name, email, created_at, updated_at

---

# 10. Case Study

## Case Study 1: Payment Reconciliation (P2R)