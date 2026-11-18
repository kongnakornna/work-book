# 📘 เล่ม 6: คู่มือ Code Reviewer
## Financial & Accounting Technology Solutions
**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับสมบูรณ์ (ส่วนที่ 1, 2 และภาค 1–3)

---
# 📑 สารบัญ (Table of Contents)

- [1. บทนำ (Introduction)](#1-บทนำ-introduction)
- [2. บทนิยาม (Definitions)](#2-บทนิยาม-definitions)
- [3. บทบาทและความรับผิดชอบ (Roles & Responsibilities)](#3-บทบาทและความรับผิดชอบ-roles--responsibilities)
- [4. ความรู้พื้นฐานที่ต้องมี (Prerequisites)](#4-ความรู้พื้นฐานที่ต้องมี-prerequisites)
- [5. โครงสร้างการทำงาน (Team Structure)](#5-โครงสร้างการทำงาน-team-structure)
- [6. หลักการทำงาน (Concept)](#6-หลักการทำงาน-concept)
- [7. Workflow และ Dataflow](#7-workflow-และ-dataflow)
- [8. Code Review Criteria (10 หมวด)](#8-code-review-criteria-10-หมวด)
- [9. Code Review Checklist](#9-code-review-checklist)
- [10. การให้ Feedback ที่มีประสิทธิภาพ](#10-การให้-feedback-ที่มีประสิทธิภาพ)
- [11. PR Template & Standards](#11-pr-template--standards)
- [12. Case Study](#12-case-study)
- [13. KPI & SMART Criteria](#13-kpi--smart-criteria)
- [14. คู่มือการทดสอบ (Review Validation)](#14-คู่มือการทดสอบ-review-validation)
- [15. คู่มือการใช้งาน (Reviewer Guide)](#15-คู่มือการใช้งาน-reviewer-guide)
- [16. คู่มือการบำรุงรักษา (Maintenance Guide)](#16-คู่มือการบำรุงรักษา-maintenance-guide)
- [17. คู่มือการขยาย/แก้ไข (Extension Guide)](#17-คู่มือการขยายแก้ไข-extension-guide)
- [18. Self-Review Checklist สำหรับ Developer](#18-self-review-checklist-สำหรับ-developer)
- [19. Root Cause Analysis (RCA)](#19-root-cause-analysis-rca)
- [20. ภาคผนวก: คำศัพท์สองภาษา และเอกสารอ้างอิง](#20-ภาคผนวก-คำศัพท์สองภาษา-และเอกสารอ้างอิง)

---

# 1. บทนำ (Introduction)

## 1.1 ภาพรวมคืออะไร (What is it?)

คู่มือนี้สำหรับ **Code Reviewer** ซึ่งได้แก่ **Senior Developer**, **Tech Lead**, **Peer Developer** ในทีม **Financial & Accounting Technology Solutions** ที่รับผิดชอบ:

- ตรวจคุณภาพโค้ด ความถูกต้อง ความปลอดภัย
- ให้ข้อเสนอแนะเชิงสร้างสรรค์
- รักษามาตรฐานทีม
- ป้องกัน Defect ไม่ให้หลุดไป Production
- แชร์ความรู้และยกระดับทีม

Code Review ไม่ใช่ "การจับผิด" แต่เป็น **Quality Gate** และ **Knowledge Sharing** ที่ทำให้ทีมเติบโตไปด้วยกัน

## 1.2 คำนำ (Preface)

ระบบ FinTech & Accounting มีความ sensitive สูง:

- ข้อมูลการเงินผิดเพียงบรรทัดเดียวอาจกระทบการปิดบัญชี
- Bug ที่หลุดไป Production อาจกระทบ Compliance
- Integration กับ Oracle ERP ต้องมี Idempotency และ Reconciliation
- Security ต้องเข้มงวด (OWASP Top 10)
- Audit Trail ต้องครบถ้วน

Code Reviewer จึงต้องเป็น **ด่านสุดท้าย** ก่อน Merge ที่มีวินัย รู้จักถาม รู้จักชี้แนะ และเข้าใจ Business Context ไม่ใช่แค่ดู Syntax

## 1.3 วัตถุประสงค์ (Objectives)

1. กำหนดมาตรฐานการ Code Review ของทีม
2. ลด Defect Leakage จากโค้ดที่ Review ไม่ครบ
3. ทำให้ Code Review เป็นกระบวนการที่ Fast, Constructive, Consistent
4. ยกระดับคุณภาพโค้ดและความรู้ของทีม
5. สร้างวัฒนธรรมที่ทุกคนกล้าแสดงความคิดเห็นอย่างสร้างสรรค์

## 1.4 เป้าหมาย (Goals)

- Review Turnaround Time ≤ 24 ชั่วโมง
- Defect Found in Review ≥ 2 ต่อ PR (มีคุณค่า)
- Approval Accuracy ≥ 95%
- Defect Leakage จาก Review < 5%
- ทีม Satisfaction ต่อ Review ≥ 4.5/5

---

# 2. บทนิยาม (Definitions)

| คำ | ความหมาย |
|----|----------|
| **Code Review** | การตรวจสอบโค้ดโดยบุคคลอื่นก่อน Merge |
| **PR (Pull Request)** | คำขอรวมโค้ดจาก Branch หนึ่งไปยังอีก Branch |
| **Reviewer** | ผู้ทำการ Review |
| **Author** | ผู้เขียนโค้ด/เจ้าของ PR |
| **Approval** | การอนุมัติให้ Merge |
| **Request Changes** | การขอให้แก้ไขก่อน Merge |
| **Comment** | ข้อคิดเห็นบนบรรทัดโค้ด |
| **Nit** | Comment เรื่องเล็กน้อย (ไม่บังคับแก้) |
| **Blocker** | Comment ที่ต้องแก้ก่อน Merge |
| **Nitpick** | การจับผิดเรื่องเล็กเกินไป (ไม่ควรทำ) |
| **LGTM** | Looks Good To Me — อนุมัติ |
| **Refactor** | ปรับโครงสร้างโค้ดโดยไม่เปลี่ยน Behavior |
| **Dead Code** | โค้ดที่ไม่ได้ถูกเรียกใช้ |
| **DRY** | Don't Repeat Yourself — ไม่เขียนซ้ำ |
| **YAGNI** | You Aren't Gonna Need It — ไม่ทำสิ่งที่ยังไม่ต้องใช้ |
| **KISS** | Keep It Simple, Stupid — ทำให้เรียบง่าย |
| **SOLID** | หลักการออกแบบ OOP 5 ข้อ |
| **N+1 Query** | ปัญหา Query ซ้ำใน Loop |
| **Race Condition** | ปัญหาเมื่อหลาย Thread แย่ง Resource |
| **Idempotency** | Request ซ้ำไม่สร้างข้อมูลซ้ำ |
| **Self-Review** | การ Review โค้ดของตนเองก่อนเปิด PR |

---

# 3. บทบาทและความรับผิดชอบ (Roles & Responsibilities)

## 3.1 Role Matrix

| กิจกรรม | Author | Reviewer | Tech Lead | Architect | QA |
|---------|--------|----------|-----------|-----------|-----|
| Self-Review | **R** | I | I | I | I |
| เปิด PR | **R** | I | I | I | I |
| Review Code | I | **R** | C | C | I |
| Approve | I | **R** | **R** | C | I |
| Request Changes | I | **R** | **R** | C | I |
| Escalate Conflict | I | C | **R** | **R** | I |
| Merge | C | C | **R** | I | I |
| Post-Merge Monitoring | C | C | C | I | **R** |

**R** = Responsible | **A** = Accountable | **C** = Consulted | **I** = Informed
```bash
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
## 3.2 ความรับผิดชอบหลักของ Reviewer

1. อ่าน PR ให้ครบ (ไม่ใช่แค่ Diff)
2. ตรวจตาม Review Criteria (10 หมวด)
3. ให้ Feedback ที่ Specific และ Constructive
4. Approve / Request Changes ภายใน 24 ชั่วโมง
5. ถามเมื่อไม่เข้าใจ (ไม่เดา)
6. แชร์ความรู้ที่เกี่ยวข้อง

## 3.3 ความรับผิดชอบหลักของ Author

1. เขียน PR ที่มี Context ครบ (What / Why / How)
2. Self-Review ก่อนเปิด PR
3. แนบ Test Evidence
4. ตอบ Comment ภายใน 24 ชั่วโมง
5. แก้ตาม Feedback หรืออธิบายเหตุผลที่ไม่แก้

## 3.4 ขอบเขตที่ Reviewer ไม่ควรทำ

- ❌ Approve โดยไม่อ่าน
- ❌ Comment เรื่องสไตล์ส่วนตัวถ้า Linter ผ่าน
- ❌ บังคับ Refactor โดยไม่มีเหตุผลเชิงธุรกิจ
- ❌ Delay Review เกิน 24 ชั่วโมง
- ❌ ใช้คำพูดที่ทำร้ายกำลังใจ
- ❌ Comment ซ้ำในเรื่องเดิมหลายรอบ
- ❌ Review PR ของตนเอง (Self-approve)

---

# 4. ความรู้พื้นฐานที่ต้องมี (Prerequisites)

| ด้าน | ความรู้ที่ต้องมี |
|------|------------------|
| Programming | Python, TypeScript, React, FastAPI |
| Design Principles | SOLID, DRY, KISS, YAGNI |
| Architecture | Clean Architecture, Layered |
| Testing | Unit / Integration / E2E, Coverage |
| Security | OWASP Top 10, Input Validation, Auth |
| Database | SQL, Index, N+1, Transaction |
| Performance | Big-O, Caching, Async |
| API Design | REST, OpenAPI, HTTP Status |
| Business Domain | Finance/Accounting Workflow |
| Communication | Constructive Feedback, Empathy |

---

# 5. โครงสร้างการทำงาน (Team Structure)

```text
┌─────────────────────────────────────────────────────────────┐
│                 CODE REVIEW STRUCTURE                       │
└─────────────────────────────────────────────────────────────┘

                    ┌──────────────┐
                    │  Architect   │  Architecture Review
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │  Tech Lead   │  Final Approver
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │ Senior   │ │  Peer    │ │Junior Dev│
        │ Dev      │ │  Dev     │ │(Learning)│
        └──────────┘ └──────────┘ └──────────┘
```

## 5.1 การสื่อสาร

| กิจกรรม | ความถี่ | ผู้เข้าร่วม |
|---------|---------|------------|
| PR Review | ต่อเนื่อง | Author, Reviewer |
| Review Sync (ถ้าติดปัญหา) | ตามต้องการ | Author, Reviewer, Tech Lead |
| Retrospective | 2 สัปดาห์/ครั้ง | ทั้งทีม |
| Code Review Calibration | เดือน/ครั้ง | Reviewer ทุกคน |
| Tech Talk | 2 สัปดาห์/ครั้ง | ทั้งทีม |

## 5.2 Review Assignment

| ขนาด PR | Reviewer ที่ต้องการ |
|---------|---------------------|
| Small (≤ 100 LOC) | 1 Reviewer |
| Medium (100–300 LOC) | 1 Senior |
| Large (300–500 LOC) | 2 Reviewers |
| Critical (> 500 LOC หรือ Sensitive) | Tech Lead + 1 Senior |

---

# 6. หลักการทำงาน (Concept)

## 6.1 หลักการ 7 ประการของ Code Reviewer

1. **Read Before Review** — อ่าน Context ก่อน (Ticket, AC, Design)
2. **Constructive, Not Critical** — เน้นสร้างสรรค์ ไม่จับผิด
3. **Ask, Don't Dictate** — ถามมากกว่าสั่ง
4. **Explain Why** — อธิบายเหตุผล ไม่ใช่แค่ "ไม่ดี"
5. **Focus on Value** — เน้นจุดที่กระทบคุณภาพ/ความปลอดภัย
6. **Be Timely** — Review ภายใน 24 ชั่วโมง
7. **Be Consistent** — ใช้เกณฑ์เดียวกันทุก PR

## 6.2 Review Mindset

```text
┌─────────────────────────────────────────────────────────────┐
│                   REVIEW MINDSET                            │
└─────────────────────────────────────────────────────────────┘

   ❌ Fixed Mindset           ✅ Growth Mindset
   ─────────────────          ─────────────────
   "โค้ดแย่มาก"              "โค้ดนี้ทำงานได้ แต่ถ้า..."
   "ทำไมไม่ทำแบบนี้"         "ลองพิจารณาแบบนี้ดูไหม"
   "ผิด"                     "น่าจะมี Edge Case ที่..."
   "ไม่ผ่าน"                 "ขอให้ปรับตรงนี้ก่อน Merge"
```

## 6.3 3 Layers of Code Review

| Layer | คำถาม |
|-------|--------|
| **Correctness** | โค้ดทำงานถูกต้องตาม Requirement หรือไม่? |
| **Quality** | โค้ดอ่านง่าย บำรุงรักษาได้ หรือไม่? |
| **Safety** | ปลอดภัย ไม่มีช่องโหว่ หรือไม่? |

## 6.4 Review Focus (ลำดับความสำคัญ)

```text
1. Correctness      ★★★★★   สำคัญที่สุด
2. Security         ★★★★★
3. Data Integrity   ★★★★★
4. Test Coverage    ★★★★
5. Maintainability  ★★★★
6. Readability      ★★★
7. Performance      ★★★
8. Style            ★★       Linter ควรจัดการ
```

## 6.5 Trade-off Framework

| สถานการณ์ | แนวทาง |
|-----------|--------|
| Deadline ใกล้ vs Code Quality | Merge ได้ถ้าไม่มี Blocker, สร้าง Tech Debt Ticket |
| Small PR vs Complete Feature | เล็กดีกว่า — แยก PR |
| Perfectionism vs Pragmatism | Merge ถ้าดีพอ ไม่ต้องสมบูรณ์แบบ |
| Style vs Substance | เน้น Substance, Style ใช้ Linter |

## 6.6 Anti-Patterns ที่ควรหลีกเลี่ยง

| Anti-Pattern | คำอธิบาย | วิธีแก้ |
|--------------|----------|--------|
| **Rubber Stamping** | Approve โดยไม่อ่าน | อ่านทุก Diff |
| **Bikeshedding** | จับผิดเรื่องเล็ก | Focus ที่ Value |
| **Nitpicking** | Comment ทุกจุดเล็ก | ระบุ Nit ให้ชัด |
| **Gatekeeping** | Block โดยไม่มีเหตุผล | อธิบายเหตุผล |
| **Ghosting** | ไม่ Review สักที | 24 ชั่วโมง |
| **Rewrite Demand** | บังคับให้เขียนใหม่ทั้งหมด | ชี้จุดที่ต้องแก้ |
| **Silo Review** | มีคนเดียว Review | กระจาย |

---

# 7. Workflow และ Dataflow

## 7.1 Code Review Workflow

```text
┌──────────────────────────────────────────────────────────────┐
│               CODE REVIEW WORKFLOW                           │
└──────────────────────────────────────────────────────────────┘

1. Author: Self-Review
       │
       ▼
2. Author: เปิด PR + Template ครบ
       │
       ▼
3. CI: Pipeline รัน (Lint, Test, Scan)
       │
       ▼
4. Reviewer: อ่าน Context (Ticket, AC)
       │
       ▼
5. Reviewer: ตรวจ Diff + Test
       │
       ▼
6. Reviewer: Comment / Approve / Request Changes
       │
       ├── Request Changes ──▶ Author: แก้ ──▶ Reviewer: Re-review
       │
       └── Approve ──▶ 7. Merge (Tech Lead / Author)
                            │
                            ▼
                       8. Deploy + Monitor
```

## 7.2 PR State Diagram

```text
┌──────────┐   ┌──────────┐   ┌──────────────┐   ┌──────────┐
│  Draft   │──▶│  Open    │──▶│  In Review   │──▶│ Approved │
└──────────┘   └──────────┘   └──────────────┘   └────┬─────┘
                                     │                 │
                                     ▼                 ▼
                              ┌──────────────┐   ┌──────────┐
                              │ Changes      │──▶│  Merged  │
                              │ Requested    │   └──────────┘
                              └──────┬───────┘
                                     │
                                     ▼
                              ┌──────────────┐
                              │  Re-review   │
                              └──────────────┘
```

## 7.3 Review Timeline (Target)

| Stage | Target |
|-------|--------|
| PR เปิด → Reviewer Acknowledged | ≤ 4 ชั่วโมง |
| Reviewer Acknowledged → Review เสร็จ | ≤ 24 ชั่วโมง |
| Author แก้ → Re-review | ≤ 24 ชั่วโมง |
| Approved → Merge | ≤ 1 ชั่วโมง |

## 7.4 Escalation Path

| สถานการณ์ | Escalate ไปที่ |
|-----------|-----------------|
| Reviewer กับ Author ตกลงไม่ได้ | Tech Lead |
| Architecture Concern | Architect |
| Security Concern | Security Lead |
| Deadline vs Quality | PO + Tech Lead |

---

# 8. Code Review Criteria (10 หมวด)

## 8.1 หมวดที่ 1: ความถูกต้อง (Does it work?)

### 1. ตรงตาม Requirement

- [ ] ทำงานถูกต้องตาม Ticket / User Story
- [ ] ตรงตาม Acceptance Criteria ทุกข้อ
- [ ] ไม่มี Scope Creep
- [ ] ไม่มี Behavior ที่ทำให้ผู้ใช้สับสน

**ตัวอย่าง Comment:**

> "Story นี้ต้อง return 409 เมื่อ email ซ้ำ แต่โค้ด return 400 — รบกวนตรวจสอบ AC-4 ด้วยครับ"

### 2. รองรับ Edge Cases

- [ ] Null / Empty
- [ ] Boundary Values (0, -1, Max)
- [ ] Unicode / Emoji
- [ ] Network Loss / Timeout
- [ ] Concurrent Request
- [ ] Duplicate Submission
- [ ] Large Payload

**ตัวอย่าง Comment:**

> "ถ้า `full_name` มีช่องว่างหน้า-หลัง ระบบจะ trim ไหมครับ? AC ระบุว่าต้อง trim"

### 3. ความถูกต้องของ Business Logic

- [ ] การคำนวณเงินถูกต้อง (ทศนิยม, ปัดเศษ)
- [ ] Status Transition ถูกต้อง
- [ ] Idempotency ครบ
- [ ] Transaction ครบ

**ตัวอย่าง Comment:**

> "Payment ถูก insert แต่ Outbox ไม่ได้เขียนใน Transaction เดียวกัน — ถ้า Process ตายกลางทาง Outbox จะหายไปครับ"

## 8.2 หมวดที่ 2: ความปลอดภัย (Is it secure?)

### 4. Input Validation

- [ ] Validate ทุก Input (Type, Length, Format)
- [ ] ใช้ Pydantic / Zod
- [ ] ป้องกัน SQL Injection (Parameterized)
- [ ] ป้องกัน XSS (Escape)
- [ ] ป้องกัน SSRF (Allowlist)

**ตัวอย่าง Comment:**

> "Query นี้ต่อ String จาก `user_input` — เสี่ยง SQL Injection ครับ แนะนำใช้ Parameterized Query"

### 5. Authorization & Authentication

- [ ] Endpoint ที่ Sensitive มี Authorization Check
- [ ] Role Check ถูกต้อง (RBAC)
- [ ] Token Validation ครบ
- [ ] Session Management ถูกต้อง

**ตัวอย่าง Comment:**

> "Endpoint `/employee/{id}` ไม่มี `require_role` — ตอนนี้ User ทั่วไปลบ Employee ได้ครับ"

### 6. Secrets Management

- [ ] ไม่มี Hardcoded Password / API Key
- [ ] ไม่มี Secret ใน Log
- [ ] ไม่มี Secret ใน Error Message
- [ ] ใช้ Key Vault / Secrets Manager

**ตัวอย่าง Comment:**

> "บรรทัด 42 มี `API_KEY = 'abc123'` — ต้องย้ายไป Azure Key Vault ครับ และ rotate ทันที"

## 8.3 หมวดที่ 3: คุณภาพโค้ด (Is it clean?)

### 7. Readability

- [ ] ชื่อ Variable / Function สื่อความหมาย
- [ ] Function สั้น อ่านจบใน 30 วินาที
- [ ] Comment อธิบาย Why ไม่ใช่ What
- [ ] ไม่มี Dead Code
- [ ] ไม่มี Comment ที่ Comment Out

**ตัวอย่าง Comment:**

> "Function `doStuff()` ไม่สื่อความหมาย — แนะนำเปลี่ยนเป็น `matchPaymentWithStatement()` ครับ"

### 8. DRY (Don't Repeat Yourself)

- [ ] ไม่มีโค้ดซ้ำ
- [ ] Extract Function กลางถ้าใช้ซ้ำ
- [ ] ไม่ Copy-Paste
- [ ] ใช้ Helper / Utility ที่มีอยู่

**ตัวอย่าง Comment:**

> "Logic validate email ซ้ำใน 3 ที่แล้ว — แนะนำ Extract เป็น `validate_email()` ใน `utils/validation.py` ครับ"

### 9. Architecture & Design

- [ ] Layer Separation ถูกต้อง (Router → Service → Repository)
- [ ] Domain ไม่รู้จัก Infrastructure
- [ ] Dependency Injection ใช้ถูก
- [ ] ไม่มี Circular Dependency
- [ ] SOLID ครบ

**ตัวอย่าง Comment:**

> "Service เรียก DB ตรงๆ แทนที่จะผ่าน Repository — จะทำให้ Test ยากครับ แนะนำ Inject Repository"

## 8.4 หมวดที่ 4: ประสิทธิภาพ (Is it efficient?)

### 10. Performance

- [ ] ไม่มี N+1 Query
- [ ] ไม่มี Loop ซ้อนโดยไม่จำเป็น
- [ ] ใช้ Index ใน Query
- [ ] ใช้ Pagination สำหรับ List
- [ ] ใช้ Async สำหรับ I/O
- [ ] Cache เมื่อเหมาะสม

**ตัวอย่าง Comment:**

> "Loop นี้เรียก `repo.find_by_id()` ทุกรอบ — ถ้ามี 100 items จะเป็น 100 Queries (N+1) แนะนำใช้ `find_by_ids()` ครั้งเดียว"

## 8.5 หมวดที่ 5: การทดสอบ (Is it tested?)

### 11. Test Coverage

- [ ] Unit Test ครอบคลุม Business Logic
- [ ] Test ครอบคลุม Edge Cases
- [ ] Integration Test ครอบคลุม Critical Paths
- [ ] Coverage ≥ 80%
- [ ] ไม่มี Test ที่ Comment Out

**ตัวอย่าง Comment:**

> "Test นี้ไม่ครอบคลุม Case ที่ `full_name` ว่าง — AC-2 บอกว่าต้อง return 400 รบกวนเพิ่ม Test ด้วยครับ"

### 12. Test Quality

- [ ] Arrange-Act-Assert
- [ ] Independent
- [ ] Deterministic (ไม่ Flaky)
- [ ] มีชื่อบอก Behavior
- [ ] ไม่มี Sleep / Hardcoded Delay

**ตัวอย่าง Comment:**

> "Test นี้ใช้ `time.sleep(2)` — เสี่ยง Flaky แนะนำใช้ `await expect(...).toBeVisible()` แทน"

## 8.6 หมวดที่ 6: การดูแลรักษา (Can we maintain it?)

### 13. Observability

- [ ] Structured Logging ครบ
- [ ] มี Correlation ID
- [ ] Log Level เหมาะสม
- [ ] ไม่มี PII / Secrets ใน Log
- [ ] Metric สำหรับ Business Event
- [ ] Error Message เป็นมิตร

**ตัวอย่าง Comment:**

> "Error นี้ log แค่ `str(e)` — ไม่มี `correlation_id` และ `payment_id` จะ debug ยากครับ"

### 14. Documentation

- [ ] API Contract อัปเดต (OpenAPI)
- [ ] README อัปเดต (ถ้าจำเป็น)
- [ ] ADR อัปเดต (ถ้ามี Decision ใหม่)
- [ ] Comment อธิบาย Complex Logic
- [ ] Runbook อัปเดต (ถ้าเกี่ยวกับ Ops)

**ตัวอย่าง Comment:**

> "Endpoint นี้เพิ่ม `X-Correlation-ID` แต่ OpenAPI ยังไม่ update ครับ"

## 8.7 หมวดที่ 7: Integration

### 15. Integration Safety

- [ ] Idempotency-Key ครบ
- [ ] Retry with Backoff
- [ ] Timeout เหมาะสม
- [ ] Circuit Breaker (ถ้าจำเป็น)
- [ ] Error Handling ครบ
- [ ] Reconciliation (ถ้าจำเป็น)

**ตัวอย่าง Comment:**

> "POST นี้ไม่มี Idempotency-Key — ถ้า Retry จะสร้าง Payment ซ้ำใน ERP ครับ"

## 8.8 หมวดที่ 8: Data Integrity

### 16. Data Integrity

- [ ] Transaction ครบ
- [ ] Constraint ถูกต้อง
- [ ] Migration มี Rollback Plan
- [ ] ไม่มี Data Loss Risk
- [ ] Timestamp ใช้ UTC

**ตัวอย่าง Comment:**

> "Insert นี้ไม่ครอบด้วย Transaction — ถ้า Update ล้มเหลวหลัง Insert จะเกิด Data Inconsistency ครับ"

## 8.9 หมวดที่ 9: Dependency Management

### 17. Dependency Safety

- [ ] Dependency ใหม่มีเหตุผล
- [ ] ไม่มี Vulnerability
- [ ] License เข้ากันได้
- [ ] Version Pinned
- [ ] ไม่มี Dependency ซ้ำซ้อน

**ตัวอย่าง Comment:**

> "เพิ่ม `lodash` ทั้งที่ใช้แค่ `debounce` — มี `utils/debounce` ในโปรเจกต์แล้วครับ"

## 8.10 หมวดที่ 10: Frontend Specific

### 18. Frontend Quality

- [ ] Accessibility (ARIA, Keyboard)
- [ ] Loading / Empty / Error States
- [ ] Responsive
- [ ] ไม่ Re-render เกินจำเป็น
- [ ] Error Message เป็นมิตร
- [ ] ไม่มี Hardcoded Text (ใช้ i18n)
- [ ] ไม่มี `any` โดยไม่จำเป็น
- [ ] State Management ถูกต้อง

**ตัวอย่าง Comment:**

> "Input นี้ไม่มี `aria-label` — จะทำให้ Screen Reader ใช้ไม่ได้ครับ"

---

# 9. Code Review Checklist

## 9.1 Master Checklist (ทุก PR)

### Correctness
- [ ] ตรงตาม Requirement / AC
- [ ] Handle Edge Cases
- [ ] Business Logic ถูกต้อง
- [ ] Idempotency ครบ (ถ้าสร้างข้อมูล)

### Security
- [ ] Input Validation ครบ
- [ ] Authorization ครบ
- [ ] ไม่มี Secrets ในโค้ด / Log
- [ ] ป้องกัน SQL Injection / XSS

### Code Quality
- [ ] อ่านง่าย ชื่อสื่อความหมาย
- [ ] ไม่มี Dead Code
- [ ] ไม่มีโค้ดซ้ำ (DRY)
- [ ] Architecture ถูกต้อง

### Performance
- [ ] ไม่มี N+1 Query
- [ ] Index เหมาะสม
- [ ] Async สำหรับ I/O
- [ ] Pagination ครบ

### Testing
- [ ] Unit Test ครอบคลุม
- [ ] Edge Cases มี Test
- [ ] Coverage ≥ 80%
- [ ] ไม่มี Flaky Test

### Maintainability
- [ ] Observability ครบ
- [ ] Documentation อัปเดต
- [ ] API Contract อัปเดต
- [ ] ไม่มี Tech Debt ที่ไม่บันทึก

### Integration (ถ้ามี)
- [ ] Idempotency-Key
- [ ] Retry + Timeout
- [ ] Reconciliation

### Data Integrity
- [ ] Transaction ครบ
- [ ] Migration มี Rollback Plan

### Frontend (ถ้ามี)
- [ ] Accessibility
- [ ] States ครบ
- [ ] Responsive

### CI
- [ ] Pipeline ผ่าน
- [ ] Security Scan ผ่าน
- [ ] Coverage Gate ผ่าน
- [ ] ผ่าน `/tb-scrutinize` (ถ้าใช้)

## 9.2 Red Flags (หยุดทันที)

- 🔴 Secret ในโค้ด
- 🔴 SQL ต่อ String จาก Input
- 🔴 ไม่มี Authorization ใน Sensitive Endpoint
- 🔴 Test ถูกลบ / Comment Out โดยไม่อธิบาย
- 🔴 Dependency ที่มี Critical CVE
- 🔴 Hardcoded Credentials
- 🔴 ลบ Error Handling โดยไม่อธิบาย
- 🔴 เปลี่ยน API Contract โดยไม่แจ้ง

## 9.3 Yellow Flags (ต้องถาม)

- 🟡 Logic ซับซ้อน
- 🟡 Loop ซ้อน / Query ซ้ำ
- 🟡 Function ยาวเกิน 50 บรรทัด
- 🟡 Comment ไม่ชัดเจน
- 🟡 Exception Catching กว้างเกิน
- 🟡 Test ที่ดูไม่ Stable
- 🟡 Dependency ใหม่
- 🟡 Architecture ที่ไม่ตรง Convention

---

# 10. การให้ Feedback ที่มีประสิทธิภาพ

## 10.1 หลักการ Feedback ที่ดี

| หลักการ | ตัวอย่าง |
|---------|----------|
| **Specific** | "บรรทัด 42: `user_input` ต่อ String ใน SQL — เสี่ยง Injection" |
| **Constructive** | "ลองใช้ Parameterized Query แบบนี้ดูไหมครับ: ..." |
| **Explain Why** | "ถ้า Retry จะเกิดข้อมูลซ้ำ เพราะไม่มี Idempotency" |
| **Ask, Don't Dictate** | "ทำไมเลือกใช้ Loop ที่นี่ครับ? ถ้าใช้ `map` จะอ่านง่ายกว่าไหม" |
| **Empathetic** | "โค้ดนี้ทำงานได้ครับ แต่..." |
| **Actionable** | "เพิ่ม `require_role('admin')` ที่ decorator" |

## 10.2 Comment Types

| Type | Prefix | ต้องแก้? |
|------|--------|----------|
| **Blocker** | `[BLOCKER]` | ✅ ต้องแก้ |
| **Suggestion** | `[SUGGESTION]` | ❌ ไม่บังคับ |
| **Question** | `[QUESTION]` | ตอบให้ชัด |
| **Nit** | `[NIT]` | ❌ ไม่บังคับ (เรื่องเล็ก) |
| **Praise** | `[PRAISE]` | ❌ ชม |
| **FYI** | `[FYI]` | ❌ แค่แจ้ง |

## 10.3 ตัวอย่าง Comment ที่ดี

### ✅ Constructive

> **[BLOCKER] Security:** บรรทัด 42 — `user_input` ถูกต่อใน SQL String โดยตรง เสี่ยง SQL Injection ครับ แนะนำ:
> ```python
> await db.execute("SELECT * FROM users WHERE id = :id", {"id": user_input})
> ```

> **[SUGGESTION] Readability:** Function `process()` ยาว 120 บรรทัด — แนะนำแยกเป็น `validate()`, `transform()`, `persist()` จะอ่านง่ายขึ้นครับ

> **[QUESTION]:** ทำไมใช้ `time.sleep(2)` ใน Test ครับ? ถ้าเป็นเรื่อง Async แนะนำใช้ `await asyncio.sleep()` หรือ `await expect().toBeVisible()` ครับ

> **[NIT]:** `usrNm` → `user_name` (ไม่บังคับ)

> **[PRAISE]:** Test ของคุณครอบคลุม Edge Cases ครบมากครับ 👍

### ❌ Non-Constructive

- ❌ "โค้ดแย่มาก"
- ❌ "ทำไมไม่รู้เรื่องนี้"
- ❌ "ผิด" (ไม่มีรายละเอียด)
- ❌ "Rewrite ใหม่ทั้งหมด"
- ❌ Comment เรื่อง Format ถ้า Linter ผ่าน

## 10.4 การตอบ Comment ของ Author

| สถานการณ์ | วิธีตอบ |
|-----------|--------|
| เห็นด้วย | "แก้แล้วครับ — commit abc123" |
| ไม่เห็นด้วย | "อธิบายเหตุผล + เสนอทางเลือก" |
| ต้องการ Discuss | "ขอ Discuss เพิ่มครับ — นัด Sync" |
| ไม่เข้าใจ | "ขอ Clarify ครับ" |

## 10.5 Conflict Resolution

```text
1. Author ไม่เห็นด้วย
       │
       ▼
2. ตอบด้วยเหตุผล
       │
       ▼
3. ถ้ายังไม่ตรงกัน ──▶ Tech Lead
       │
       ▼
4. ถ้าเป็น Architecture ──▶ Architect
       │
       ▼
5. ถ้าเป็น Security ──▶ Security Lead
```

## 10.6 Empathy Guidelines

- ✅ ใช้ "เรา" ไม่ใช่ "คุณ"
- ✅ เน้นที่โค้ด ไม่ใช่ที่คน
- ✅ ชมเมื่อดี
- ✅ ถามเมื่อไม่เข้าใจ
- ✅ อธิบายเหตุผล
- ✅ เสนอทางเลือก
- ❌ อย่าใช้ sarcasm
- ❌ อย่าตำหนิต่อหน้าคนอื่น
- ❌ อย่าเปรียบเทียบกับคนอื่น

---

# 11. PR Template & Standards

## 11.1 PR Template

```markdown
# Pull Request: [ชื่อ]

**Ticket:** [JIRA/GitHub Issue Link]
**Type:** [Feature/Bugfix/Refactor/Chore]
**Priority:** [P0/P1/P2/P3]
**Size:** [S/M/L]  (LOC changed)

## 📝 What
[อธิบายสิ่งที่เปลี่ยนแปลง]

## 🎯 Why
[เหตุผลที่เปลี่ยนแปลง - link กับ Ticket/AC]

## 🔧 How
[วิธีที่ใช้ - Technical Approach]

## 📸 Screenshots (ถ้ามี UI Changes)
[แนบรูป Before/After]

## 🧪 Test Plan
- [ ] Unit Test ผ่าน
- [ ] Integration Test ผ่าน
- [ ] Manual Test บน Staging
- [ ] Performance Test (ถ้าจำเป็น)
- [ ] Security Scan ผ่าน

## 📊 Test Evidence
- Coverage: [X]%
- Test Report: [link]
- Screenshot: [link]

## ⚠️ Risks & Rollback Plan
**Risks:**
- [Risk 1]
- [Risk 2]

**Rollback:**
- [ขั้นตอน Rollback]

## 📎 Related PRs / ADRs
- [Link]

## ✅ Author Checklist
- [ ] Self-Reviewed
- [ ] Tests pass
- [ ] No secrets
- [ ] Docs updated
- [ ] API contract updated
- [ ] ผ่าน /tb-scrutinize
```

## 11.2 PR Size Guidelines

| Size | LOC | Review Time | Reviewers |
|------|-----|-------------|-----------|
| XS | ≤ 50 | ≤ 15 นาที | 1 |
| S | 50–100 | ≤ 30 นาที | 1 |
| M | 100–300 | ≤ 1 ชั่วโมง | 1 Senior |
| L | 300–500 | ≤ 2 ชั่วโมง | 2 |
| XL | > 500 | ❌ ควรแยก | Tech Lead |

**กฎ:** ถ้า PR ใหญ่เกิน ให้แยกเป็น PR ย่อย

## 11.3 PR Title Convention

```text
<type>(<scope>): <subject>

ตัวอย่าง:
feat(employee): add POST /employee endpoint
fix(payment): prevent duplicate sync to ERP
refactor(auth): extract RBAC middleware
docs(api): update OpenAPI for employee
test(p2r): add edge cases for matching
```

## 11.4 PR Description Best Practices

- ✅ ใส่ Context (Why มากกว่า What)
- ✅ แนบ Test Evidence
- ✅ ระบุ Risk
- ✅ ระบุ Rollback Plan
- ✅ Link กับ Ticket
- ✅ แนบ Screenshot (ถ้า UI)
- ❌ อย่าใส่ "Fix bug" ลอยๆ
- ❌ อย่าใส่ Description ว่าง
- ❌ อย่าใส่ PR ที่เปลี่ยนหลายเรื่อง

## 11.5 Branch Naming

| Type | Pattern | ตัวอย่าง |
|------|---------|----------|
| Feature | `feature/<TICKET>-<desc>` | `feature/PMS-101-add-employee-api` |
| Bugfix | `bugfix/<TICKET>-<desc>` | `bugfix/PMS-202-fix-null-email` |
| Refactor | `refactor/<TICKET>-<scope>` | `refactor/PMS-404-clean-auth` |
| Hotfix | `hotfix/<version>-<desc>` | `hotfix/v1.0.1-fix-payment` |

---

# 12. Case Study

## Case Study 1: POST /employee — Review เต็มรูปแบบ

### 12.1.1 PR ที่ส่งมา

```python
# api/modules/employee/router.py
@router.post("/employee")
async def create_employee(payload: dict):
    db = get_db()
    existing = db.execute(
        f"SELECT * FROM employee WHERE email = '{payload['email']}'"
    ).fetchone()
    if existing:
        return {"error": "exists"}
    
    new_emp = {
        "id": str(uuid.uuid4()),
        "full_name": payload["full_name"],
        "email": payload["email"],
        "created_at": datetime.utcnow(),
    }
    db.execute(f"INSERT INTO employee VALUES ('{new_emp['id']}', ...)")
    db.commit()
    return new_emp
```

### 12.1.2 Review Comments

**[BLOCKER] Security:** บรรทัด 3 — `payload['email']` ต่อ String ใน SQL โดยตรง เสี่ยง SQL Injection ครับ แนะนำ:
```python
db.execute("SELECT * FROM employee WHERE email = :email", {"email": payload["email"]})
```

**[BLOCKER] Security:** บรรทัด 5 — Return `{"error": "exists"}` พร้อม HTTP 200 ไม่ตรงกับ AC-4 ที่ต้อง return HTTP 409 แนะนำ:
```python
raise HTTPException(status_code=409, detail="email already exists")
```

**[BLOCKER] Validation:** ไม่มี Validation `full_name` และ `email` เลย — AC-2 และ AC-3 ระบุว่าต้อง return 400 ถ้าว่าง แนะนำใช้ Pydantic Model:
```python
class EmployeeCreate(BaseModel):
    full_name: str = Field(..., min_length=1)
    email: EmailStr
```

**[BLOCKER] Data Integrity:** ไม่ได้ตั้ง `updated_at` — AC-6 ระบุว่าตอน Create ต้อง `created_at = updated_at`

**[BLOCKER] Architecture:** ใช้ `payload: dict` แทน Pydantic Model — จะทำให้ Validation และ Documentation (OpenAPI) หายไป แนะนำใช้ `EmployeeCreate`

**[BLOCKER] Architecture:** เรียก DB ตรงๆ ใน Router แทนที่จะผ่าน Service/Repository — ผิด Convention ของทีม ทำให้ Test ยาก

**[SUGGESTION] Response:** ไม่ได้ return `created_at` และ `updated_at` ใน Response — AC-1 ระบุว่าต้องมี ครบ

**[NIT]:** `new_emp` → `employee` (ตาม Convention)

**[QUESTION]:** ไม่เห็น Test เลยครับ — รบกวนเพิ่ม Test ครอบคลุม AC-1 ถึง AC-6 ด้วย

### 12.1.3 สรุป Review

| Type | จำนวน |
|------|-------|
| Blocker | 6 |
| Suggestion | 1 |
| Question | 1 |
| Nit | 1 |
| Praise | 0 |

**Decision:** Request Changes

### 12.1.4 หลังแก้

Author แก้ครบทุก Blocker แล้ว Reviewer Approve — Merge ได้

**Defect ที่จับได้:** 6 ตัว (Security 2, Validation 1, Data Integrity 1, Architecture 2)

### 12.1.5 Learning

- ใช้ Pydantic Model แทน `dict` ทุกครั้ง
- ใช้ Parameterized Query ทุกครั้ง
- Service Layer ต้องมี
- Test ต้องมีก่อนเปิด PR

---

## Case Study 2: Payment Sync — จับ Integration Bug

### 12.2.1 PR ที่ส่งมา

```python
async def sync_payment(payment: Payment):
    async with httpx.AsyncClient() as client:
        resp = await client.post(
            f"{ERP_URL}/payments",
            json=payment.dict(),
            headers={"Authorization": f"Bearer {TOKEN}"},
        )
        resp.raise_for_status()
    return resp.json()
```

### 12.2.2 Review Comments

**[BLOCKER] Integration:** ไม่มี `Idempotency-Key` — ถ้า Caller Retry จะสร้าง Payment ซ้ำใน ERP ครับ แนะนำ:
```python
headers={
    "Authorization": f"Bearer {TOKEN}",
    "Idempotency-Key": payment.id,
}
```

**[BLOCKER] Integration:** ไม่มี Timeout — ถ้า ERP ไม่ตอบสนองจะค้างไม่จำกัด แนะนำ `timeout=30`

**[BLOCKER] Resilience:** ไม่มี Retry — AC-3 ระบุว่าต้อง Retry 3 ครั้ง แนะนำใช้ `tenacity`

**[BLOCKER] Error Handling:** `raise_for_status()` ทำให้ Caller ต้อง handle เอง แต่ไม่มี Retry — แนะนำ Wrap ใน Function ที่ Handle ครบ

**[SUGGESTION] Observability:** ไม่มี Log — แนะนำ Log `payment_id`, `correlation_id`, `latency_ms` หลังสำเร็จ

**[QUESTION]:** Token มาจากไหนครับ? ถ้า Hardcode ต้องย้ายไป Vault

### 12.2.3 สรุป

- Blocker 4 ตัว (Integration + Resilience)
- Defect ที่จับได้: Retry Duplicate, Timeout Hang, No Retry, Token Risk

**Impact ถ้าไม่จับ:** Production จะมี Payment ซ้ำใน ERP ระหว่าง Network Timeout — กระทบการปิดบัญชี

---

## Case Study 3: Frontend — Accessibility

### 12.3.1 PR ที่ส่งมา

```tsx
function EmployeeForm({ onSubmit }) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  
  const handleSubmit = async () => {
    await onSubmit({ name, email });
  };
  
  return (
    <div>
      <input 
        placeholder="Name" 
        value={name} 
        onChange={e => setName(e.target.value)} 
      />
      <input 
        placeholder="Email" 
        value={email} 
        onChange={e => setEmail(e.target.value)} 
      />
      <button onClick={handleSubmit}>Submit</button>
    </div>
  );
}
```

### 12.3.2 Review Comments

**[BLOCKER] Accessibility:** `<input>` ไม่มี `<label>` — จะทำให้ Screen Reader อ่านไม่ได้ แนะนำ:
```tsx
<label htmlFor="name">Name</label>
<input id="name" ... />
```

**[BLOCKER] Accessibility:** ใช้ `onClick` บน `<button>` แทน `<form onSubmit>` — ทำให้กด Enter ไม่ Submit แนะนำใช้ `<form>`

**[BLOCKER] UX:** ไม่มี Loading / Error State — AC ระบุว่าต้องมี

**[BLOCKER] Validation:** ไม่มี Client-side Validation — AC-2/AC-3 ระบุ

**[SUGGESTION] Types:** ไม่มี TypeScript Types — แนะนำ:
```tsx
interface Props {
  onSubmit: (data: EmployeeCreateRequest) => Promise<void>;
}
```

**[SUGGESTION] i18n:** Hardcoded "Submit" — ควรใช้ i18n

**[NIT]:** `name` → `fullName` (ตาม API Contract)

### 12.3.3 สรุป

- Defect: Accessibility 2, UX 2, Validation 1
- ถ้าไม่จับ: ผู้ใช้ Keyboard / Screen Reader ใช้งานไม่ได้, ไม่มี Error Handling

---

# 13. KPI & SMART Criteria

## 13.1 KPI หลักของ Code Reviewer

| KPI | เป้าหมาย | วิธีวัด |
|-----|----------|---------|
| **Review Turnaround Time** | ≤ 24 ชั่วโมง | PR Opened → Review Submitted |
| **Defect Found in Review** | ≥ 2 ต่อ PR (มีคุณค่า) | Comments ที่เป็น Blocker |
| **Approval Accuracy** | ≥ 95% | PR ที่ Merge แล้วไม่มี Bug ใน 30 วัน |
| **Defect Leakage from Review** | < 5% | Bug ใน Prod ที่ Review ควรจับได้ |
| **Review Thoroughness** | 100% Checklist | % PR ที่ Cover ทุกหมวด |
| **Author Satisfaction** | ≥ 4.5/5 | Survey |
| **Re-review Time** | ≤ 24 ชั่วโมง | Changes → Re-review |
| **Comment Constructiveness** | ≥ 90% | ไม่มี Complaint |

## 13.2 KPI หลักของทีม

| KPI | เป้าหมาย |
|-----|----------|
| PR Cycle Time | ≤ 2 วัน |
| PR Size (Median) | ≤ 300 LOC |
| PRs per Day | ≥ 3 |
| Review Coverage | 100% (ทุก PR) |
| Escalation Rate | < 10% |

## 13.3 SMART ตัวอย่าง

| SMART | รายละเอียด |
|-------|-----------|
| **S** | ลด Review Turnaround Time ของทีม |
| **M** | จาก 36 ชั่วโมง → ≤ 24 ชั่วโมง |
| **A** | ตั้ง Reviewer Rotation + Notification |
| **R** | ทำให้ PR Cycle Time สั้นลง |
| **T** | ภายใน 2 Sprint |

---

# 14. คู่มือการทดสอบ (Review Validation)

## 14.1 วิธีตรวจสอบว่า Review มีคุณภาพ

| วิธี | ใช้ทำอะไร |
|------|-----------|
| **Defect Leakage Tracking** | ติดตาม Bug ใน Prod ที่ Review ควรจับได้ |
| **Review Retrospective** | ทบทวน Review ที่ดี/ไม่ดี |
| **Calibration Session** | ให้ Reviewer หลายคน Review PR เดียวกัน แล้วเทียบ |
| **Author Survey** | ถาม Author ว่า Review มีคุณค่าไหม |
| **Spot Check** | สุ่มตรวจ PR ที่ Merge แล้ว |

## 14.2 Calibration Session

```text
1. เลือก PR ที่ Merge แล้ว 1–2 ตัว
2. ให้ Reviewer ทุกคน Review คนละเวลา
3. เปรียบเทียบ Comments
4. หาจุดที่บางคนจับ บางคนไม่จับ
5. ปรับ Checklist / Criteria
```

**ทำทุกเดือน**

## 14.3 Review Retrospective

คำถาม:

- Review ครั้งล่าสุดจับ Defect อะไรได้?
- มี Defect ที่หลุดไหม? ทำไม?
- Review ที่ดีเป็นอย่างไร?
- Review ที่ไม่ดีเป็นอย่างไร?
- Checklist ต้องปรับอะไร?

## 14.4 ตัวอย่าง: Defect ที่ Review ควรจับได้

| Defect | Review ควรจับได้? | ทำไม |
|--------|-------------------|------|
| SQL Injection | ✅ | Checklist ข้อ Security |
| Missing Authorization | ✅ | Checklist ข้อ Security |
| N+1 Query | ✅ | Checklist ข้อ Performance |
| Test ไม่ครอบคลุม | ✅ | Checklist ข้อ Testing |
| Race Condition | ⚠️ | ยาก — ต้องใช้ Concurrency Test |
| Business Logic ผิด | ✅ | ถ้า Reviewer อ่าน AC |
| Performance ต่ำ | ⚠️ | ต้องมี Performance Test |
| Data Loss Risk | ✅ | Checklist ข้อ Data Integrity |

## 14.5 Review Quality Checklist

- [ ] อ่าน Context ก่อน (Ticket / AC / Design)
- [ ] อ่าน Diff ทุกบรรทัด
- [ ] ตรวจ Test
- [ ] ตรวจ Security
- [ ] ตรวจ Observability
- [ ] Comment แบบ Specific
- [ ] ระบุ Type (Blocker / Suggestion / Nit)
- [ ] ตอบภายใน 24 ชั่วโมง
- [ ] Approve / Request Changes ชัดเจน

---

# 15. คู่มือการใช้งาน (Reviewer Guide)

## 15.1 Daily Workflow ของ Reviewer

```text
เช้า:
1. ตรวจ PR ที่รอ Review
2. เลือก PR ที่มี Priority สูง
3. อ่าน Context (Ticket / AC / Design)

ระหว่างวัน:
4. Review Code
5. Comment
6. Approve / Request Changes

เย็น:
7. Re-review PR ที่แก้แล้ว
8. ตรวจ Status PR ที่ค้าง
```

## 15.2 ขั้นตอนการ Review ทีละขั้น

### Step 1: อ่าน Context

- เปิด Ticket / Story
- อ่าน AC
- อ่าน Design (ถ้ามี)
- อ่าน PR Description

**ใช้เวลา:** 2–5 นาที

### Step 2: Scan PR Overview

- ดู LOC changed
- ดูไฟล์ที่เปลี่ยน
- ดู Commit Message

### Step 3: Review Code

- อ่าน Diff ทุกบรรทัด
- ใช้ Checklist (10 หมวด)
- Comment ทันทีที่เจอ

### Step 4: Review Tests

- ตรวจ Test Coverage
- ตรวจ Edge Cases
- ตรวจ Flaky Risk

### Step 5: ตรวจ CI

- Pipeline ผ่าน?
- Security Scan ผ่าน?
- Coverage Gate ผ่าน?

### Step 6: สรุป

- Approve / Request Changes
- เขียน Summary Comment (ถ้ามีหลายจุด)

## 15.3 ตัวอย่าง Summary Comment

```markdown
## Review Summary

**Overall:** โค้ดโดยรวมดีครับ — Architecture ถูกต้อง Test ครอบคลุม

**Blockers (ต้องแก้):**
- [ ] Security: SQL Injection (บรรทัด 42)
- [ ] Validation: ไม่มี Pydantic Model
- [ ] Data Integrity: `updated_at` ไม่ได้ตั้ง

**Suggestions (แนะนำ):**
- เพิ่ม Structured Log

**Nit:**
- เปลี่ยนชื่อ `new_emp` → `employee`

**Decision:** Request Changes — รบกวนแก้ Blocker แล้วแจ้ง Re-review ครับ
```

## 15.4 การ Approve

**Approve เมื่อ:**

- [ ] ไม่มี Blocker
- [ ] Test ครบ
- [ ] CI ผ่าน
- [ ] Security ครบ
- [ ] ตรงตาม AC

**ไม่ Approve เมื่อ:**

- มี Blocker
- Test ไม่ครบ
- CI Fail
- Security ไม่ผ่าน
- ไม่ตรง AC

## 15.5 การ Request Changes

- ระบุ Blocker ชัดเจน
- ระบุเหตุผล
- เสนอทางเลือก
- ไม่ Block โดยไม่มีเหตุผล
- ตอบ Author ภายใน 24 ชั่วโมง

## 15.6 Daily Checklist

- [ ] ตรวจ PR ใหม่ทันที
- [ ] Review ภายใน 24 ชั่วโมง
- [ ] ใช้ Checklist ครบ
- [ ] Comment แบบ Specific
- [ ] ตอบ Re-review ภายใน 24 ชั่วโมง
- [ ] ไม่ Approve โดยไม่อ่าน

---

# 16. คู่มือการบำรุงรักษา (Maintenance Guide)

## 16.1 Checklist Maintenance

- ทบทวน Checklist ทุกไตรมาส
- เพิ่มข้อที่พบบ่อย
- ลบข้อที่ไม่ค่อยเจอ
- ปรับตาม Technology เปลี่ยน

## 16.2 Guideline Maintenance

| เอกสาร | Owner | Review Cycle |
|--------|-------|--------------|
| Review Checklist | Tech Lead | ไตรมาส |
| Comment Guidelines | Tech Lead | ไตรมาส |
| PR Template | Tech Lead | ไตรมาส |
| Calibration Notes | Architect | เดือน |

## 16.3 Calibration Session

**ทำทุกเดือน:**

1. เลือก PR ที่ Merge แล้ว
2. ให้ Reviewer ทุกคน Review
3. เปรียบเทียบ
4. หาจุดต่าง
5. ปรับ Checklist

**Output:** Checklist ที่อัปเดต + Note การปรับ

## 16.4 Review Metrics Review

**ทำทุก Sprint:**

- Review Turnaround Time
- Defect Found
- Defect Leakage
- Author Satisfaction

**ใช้ทำอะไร:**

- ปรับ Rotation
- เพิ่ม Training
- ปรับ Checklist
- ปรับ Process

## 16.5 Knowledge Base

```text
docs/
├── code-review/
│   ├── checklist.md
│   ├── comment-guidelines.md
│   ├── pr-template.md
│   ├── calibration-notes.md
│   └── review-metrics.md
```

---

# 17. คู่มือการขยาย/แก้ไข (Extension Guide)

## 17.1 การเพิ่ม Checklist ใหม่

1. ระบุเหตุผล (Defect ที่เจอบ่อย)
2. เขียน Checklist ที่ Specific
3. Review กับทีม
4. เพิ่มใน Guideline
5. ประชาสัมพันธ์
6. Track Effectiveness

## 17.2 การเพิ่ม Review Category

ตัวอย่าง: ถ้าต้องการเพิ่มหมวด **Accessibility**

1. ระบุ Criteria
2. เขียน Checklist
3. เขียน Comment ตัวอย่าง
4. เพิ่มใน Guideline
5. Training
6. Track

## 17.3 การปรับ Process

- ถ้า Turnaround Time สูง → เพิ่ม Reviewer
- ถ้า Defect Leakage สูง → เพิ่ม Checklist
- ถ้า Author Satisfaction ต่ำ → ปรับ Comment Style
- ถ้า Review ไม่มีคุณค่า → Calibration

## 17.4 Governance

- การเปลี่ยน Checklist ต้องผ่าน Tech Lead
- การเปลี่ยน Process ต้องผ่าน Retrospective
- การเพิ่ม Category ต้องผ่าน Architect
- การเปลี่ยน Template ต้องผ่านทีม

---

# 18. Self-Review Checklist สำหรับ Developer

## 18.1 Self-Review ก่อนเปิด PR

- [ ] อ่าน Diff ทุกบรรทัด
- [ ] ไม่มี Debug Log ค้าง
- [ ] ไม่มี Comment Out Code
- [ ] ไม่มี Secret
- [ ] ไม่มี `console.log` / `print` ค้าง
- [ ] ไม่มี Hardcoded Value (ที่ควรเป็น Config)
- [ ] Test ผ่านทั้งหมด
- [ ] Coverage ≥ 80%
- [ ] Lint ผ่าน
- [ ] Type Check ผ่าน
- [ ] Documentation อัปเดต
- [ ] API Contract อัปเดต
- [ ] PR Description ครบ

## 18.2 Self-Review Questions

ก่อนเปิด PR ถามตัวเอง:

1. ถ้าฉันเป็น Reviewer ฉันจะ Approve PR นี้ไหม?
2. Code นี้ทำงานถูกต้องตาม AC ทุกข้อไหม?
3. มี Edge Case ที่ยังไม่ Test ไหม?
4. มี Secret หรือ Sensitive Data ไหม?
5. PR นี้ใหญ่เกินไปไหม? ควรแยกไหม?
6. Test ครอบคลุม Critical Paths ไหม?
7. Error Handling ครบไหม?
8. Observability ครบไหม?

## 18.3 ถ้า Self-Review เจอปัญหา

- แก้ก่อนเปิด PR
- อย่าหวังให้ Reviewer จับ
- Reviewer มีเวลาจำกัด

---

# 19. Root Cause Analysis (RCA)

## 19.1 ตัวอย่าง RCA: Defect Leakage จาก Review

### Problem
Bug เกี่ยวกับ SQL Injection หลุดไป Production ผ่าน Code Review

### Impact
- ข้อมูลเกือบรั่ว
- ต้องแก้ Hotfix
- เสียความเชื่อมั่น

### 5 Whys

1. **Why?** — Reviewer Approve โค้ดที่มี SQL Injection
2. **Why?** — Reviewer ไม่ได้อ่านบรรทัดนั้น
3. **Why?** — PR ใหญ่ 800 LOC — Reviewer ใช้เวลาไม่พอ
4. **Why?** — ไม่มี Policy เรื่อง PR Size
5. **Why?** — ไม่มี Checklist บังคับให้ Check PR Size

### Root Cause
ขาด Policy เรื่อง PR Size และ Checklist ที่บังคับ

### Corrective Action
- แก้ Hotfix
- Audit PR ที่ Merge ไปแล้ว

### Preventive Action
- กำหนด PR Size Limit (≤ 500 LOC)
- เพิ่ม Checklist ข้อ "PR Size"
- บังคับ Reviewer 2 คนสำหรับ PR ใหญ่
- เพิ่ม Automated Security Scan ใน CI
- Training Reviewer เรื่อง Security

### Monitoring
- KPI: Defect Leakage < 5%
- KPI: PR Size Median ≤ 300 LOC
- Duration: ต่อเนื่อง
- Owner: Tech Lead

## 19.2 ตัวอย่าง RCA: Review Turnaround Time สูง

### Problem
Review Turnaround Time เฉลี่ย 48 ชั่วโมง (เป้า ≤ 24)

### 5 Whys

1. **Why?** — Reviewer ไม่ Review ทันที
2. **Why?** — Reviewer ไม่รู้ว่ามี PR ใหม่
3. **Why?** — ไม่มี Notification
4. **Why?** — ไม่มี Rotation
5. **Why?** — ไม่มี Process

### Root Cause
ขาด Process การ Assign Reviewer และ Notification

### Preventive Action
- ตั้ง Reviewer Rotation
- ตั้ง Notification (Slack / GitHub)
- ตั้ง SLA ใน Guideline
- Track Metric ทุก Sprint

## 19.3 RCA Checklist สำหรับ Reviewer

- [ ] มี Timeline
- [ ] มี Evidence (PR, Comment, Bug Report)
- [ ] มี 5 Whys
- [ ] ระบุ Root Cause
- [ ] มี Corrective Action
- [ ] มี Preventive Action
- [ ] มี Owner + Due Date
- [ ] Update Checklist / Guideline

---

# 20. ภาคผนวก: คำศัพท์สองภาษา และเอกสารอ้างอิง

## 20.1 คำศัพท์สองภาษา

| ไทย | English | ความหมาย |
|-----|---------|----------|
| การตรวจทานโค้ด | Code Review | ตรวจสอบโค้ดก่อน Merge |
| คำขอรวมโค้ด | Pull Request (PR) | คำขอ Merge |
| ผู้อนุมัติ | Approver | ผู้อนุมัติ PR |
| การอนุมัติ | Approval | การ Approve |
| การขอแก้ไข | Request Changes | ขอแก้ก่อน Merge |
| ข้อคิดเห็น | Comment | ความคิดเห็น |
| จุดเล็กน้อย | Nit | Comment เรื่องเล็ก |
| บล็อกเกอร์ | Blocker | ต้องแก้ก่อน Merge |
| การรีแฟคเตอร์ | Refactor | ปรับโครงสร้างไม่เปลี่ยน Behavior |
| โค้ดตาย | Dead Code | โค้ดที่ไม่ได้ใช้ |
| เขียนซ้ำ | DRY | ไม่เขียนซ้ำ |
| ทำให้เรียบง่าย | KISS | Keep It Simple |
| ปัญหา N+1 | N+1 Query | Query ซ้ำใน Loop |
| การป้องกันซ้ำ | Idempotency | Request ซ้ำไม่สร้างซ้ำ |
| การตรวจตัวเอง | Self-Review | Review โค้ดตัวเองก่อน |
| การสอบเทียบ | Calibration | เทียบมาตรฐาน Reviewer |
| การไหลของ Defect | Defect Leakage | Defect ที่หลุด Prod |
| เวลาตอบกลับ | Turnaround Time | เวลาตั้งแต่เปิดถึง Review |
| วัฒนธรรมเชิงบวก | Constructive Culture | วัฒนธรรมให้ Feedback ดี |

## 20.2 เอกสารอ้างอิง

- Complete Multi-Role Work Manuals — Financial & Accounting Technology Solutions
- เล่ม 1: คู่มือ Product Owner / Business Analyst
- เล่ม 2: คู่มือ Full-Stack Engineer
- เล่ม 3: คู่มือ Solution Architect / Tech Lead
- เล่ม 4: คู่มือ QA / Test Engineer
- เล่ม 5: คู่มือ DevOps / Platform Engineer
- เล่ม 7: คู่มือ Incident Commander / On-call
- เล่ม 10: คู่มือ AI-Assisted Development (`tb-*` Skills)
- เล่ม 12: คู่มือ CI/CD & Git Flow
- เล่ม 13: คู่มือ RCA
- เล่ม 14: คู่มือ Security & Compliance

## 20.3 มาตรฐานและ Framework อ้างอิง

- **Google Engineering Practices** — Code Review Guidelines
- **Conventional Comments** — Comment Format Standard
- **Conventional Commits** — Commit Message Standard
- **OWASP Top 10** — Security Checklist
- **SOLID Principles** — Design Principles
- **Clean Code** — Robert C. Martin
- **The Pragmatic Programmer** — Hunt & Thomas
- **Refactoring** — Martin Fowler
- **Working Effectively with Legacy Code** — Michael Feathers

---

# ✅ ภาคผนวกท้ายเล่ม: Code Reviewer Daily Checklist

## ก่อนเริ่ม Review
- [ ] อ่าน Ticket / AC / Design
- [ ] อ่าน PR Description
- [ ] ตรวจ PR Size (≤ 500 LOC)
- [ ] ตรวจ CI Status

## ระหว่าง Review
- [ ] อ่าน Diff ทุกบรรทัด
- [ ] ใช้ Checklist (10 หมวด)
- [ ] Comment แบบ Specific + Constructive
- [ ] ระบุ Type (Blocker / Suggestion / Nit)
- [ ] ตรวจ Test Coverage
- [ ] ตรวจ Security

## หลัง Review
- [ ] เขียน Summary Comment
- [ ] Approve / Request Changes ชัดเจน
- [ ] ตอบ Re-review ภายใน 24 ชั่วโมง
- [ ] Track Metric

## Weekly
- [ ] ทบทวน Review Metrics
- [ ] ตอบ Survey (ถ้ามี)
- [ ] ประชุม Calibration (เดือน)
- [ ] อัปเดต Checklist (ไตรมาส)

---
 
