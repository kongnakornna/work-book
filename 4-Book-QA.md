# 📘 เล่ม 4: คู่มือ QA / Test Engineer
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
- [8. Test Strategy & Testing Pyramid](#8-test-strategy--testing-pyramid)
- [9. Test Case Design Techniques](#9-test-case-design-techniques)
- [10. Automated Testing Standards](#10-automated-testing-standards)
- [11. Defect Management](#11-defect-management)
- [12. Case Study](#12-case-study)
- [13. KPI & SMART Criteria](#13-kpi--smart-criteria)
- [14. คู่มือการทดสอบ (Test Execution Guide)](#14-คู่มือการทดสอบ-test-execution-guide)
- [15. คู่มือการใช้งาน (QA Guide)](#15-คู่มือการใช้งาน-qa-guide)
- [16. คู่มือการบำรุงรักษา (Maintenance Guide)](#16-คู่มือการบำรุงรักษา-maintenance-guide)
- [17. คู่มือการขยาย/แก้ไข (Extension Guide)](#17-คู่มือการขยายแก้ไข-extension-guide)
- [18. Code Review & PR Checklist สำหรับ QA](#18-code-review--pr-checklist-สำหรับ-qa)
- [19. Root Cause Analysis (RCA)](#19-root-cause-analysis-rca)
- [20. ภาคผนวก: คำศัพท์สองภาษา และเอกสารอ้างอิง](#20-ภาคผนวก-คำศัพท์สองภาษา-และเอกสารอ้างอิง)

---

# 1. บทนำ (Introduction)

## 1.1 ภาพรวมคืออะไร (What is it?)

คู่มือนี้สำหรับ **QA Engineer**, **SDET (Software Development Engineer in Test)** และ **Tester** ในทีม **Financial & Accounting Technology Solutions — CP AXTRA** ที่รับผิดชอบ:

- ออกแบบ **Test Strategy** ที่เหมาะกับระบบการเงินและบัญชี
- เขียน **Test Case** (Manual + Automated) ที่ครอบคลุม
- รัน Test และรายงาน **Defect** อย่างมีคุณภาพ
- ตรวจสอบ **Acceptance Criteria** ก่อน UAT
- สนับสนุน **UAT** ร่วมกับ PO/BA และ Key User
- รักษาคุณภาพของ Release และลด **Defect Leakage**

## 1.2 คำนำ (Preface)

ระบบ FinTech & Accounting มีความ sensitive สูง:

- ข้อมูลการเงินผิดเพียงรายการเดียวอาจกระทบการปิดบัญชี
- Integration กับ Oracle ERP / Databricks / Power BI ต้องมี **Reconciliation** และ **Idempotency**
- Compliance เช่น SOX, PDPA, ISO 27001 ต้องมี **Audit Trail**
- ผู้ใช้เป็นทีม Finance/Accounting ที่คาดหวังความถูกต้อง 100%

QA จึงไม่ใช่แค่ "หาบั๊ก" แต่ต้องเป็น **Quality Advocate** ที่ทำให้ทีมมั่นใจว่าสิ่งที่ส่งมอบถูกต้อง ปลอดภัย และพร้อมใช้งานจริง

## 1.3 วัตถุประสงค์ (Objectives)

1. กำหนดมาตรฐานการทดสอบของทีม FinTech & Accounting
2. ลด Defect Leakage ให้ < 5%
3. ยกระดับ Test Automation Coverage ≥ 70%
4. ทำให้ Defect Report มีคุณภาพและตรวจสอบย้อนหลังได้
5. สร้างวัฒนธรรม Quality-First ที่ทุกคนมีส่วนร่วม

## 1.4 เป้าหมาย (Goals)

- Defect Leakage Rate < 5%
- Test Automation Coverage ≥ 70%
- UAT Pass Rate (First Round) ≥ 90%
- Test Execution Time ≤ 30 นาที
- Critical Defect ใน Production = 0
- Regression Test ครอบคลุมทุก Release

---

# 2. บทนิยาม (Definitions)

| คำ | ความหมาย |
|----|----------|
| **QA (Quality Assurance)** | การประกันคุณภาพผ่านกระบวนการและมาตรฐาน |
| **QC (Quality Control)** | การตรวจสอบคุณภาพผ่านการทดสอบ |
| **SDET** | Software Development Engineer in Test — QA ที่เขียน Automation Code ได้ |
| **Test Strategy** | แผนภาพรวมการทดสอบของทีม/ระบบ |
| **Test Plan** | แผนทดสอบเฉพาะ Release/Feature |
| **Test Case** | ขั้นตอนทดสอบพร้อม Expected Result |
| **Test Suite** | กลุ่ม Test Case ที่รันด้วยกัน |
| **Test Data** | ข้อมูลที่ใช้ทดสอบ |
| **Test Environment** | สภาพแวดล้อมที่ใช้ทดสอบ (Dev/Staging) |
| **Regression Test** | ทดสอบซ้ำเพื่อยืนยันว่าไม่มีอะไรพัง |
| **Smoke Test** | ทดสอบเร็วเพื่อยืนยันว่าระบบพื้นฐานทำงาน |
| **Sanity Test** | ทดสอบเฉพาะจุดที่แก้ไข |
| **UAT** | User Acceptance Testing — ทดสอบโดยผู้ใช้จริง |
| **Defect** | ข้อบกพร่องของระบบ |
| **Severity** | ระดับความรุนแรงของ Defect |
| **Priority** | ระดับความเร่งด่วนในการแก้ |
| **Defect Leakage** | Defect ที่หลุดไปถึง Production |
| **False Positive** | Defect ที่รายงานผิด (ไม่ใช่บั๊กจริง) |
| **False Negative** | บั๊กจริงที่ QA มองข้าม |
| **Flaky Test** | Test ที่ผลไม่แน่นอน |
| **Test Coverage** | สัดส่วนที่ Test ครอบคลุม |
| **Shift-Left Testing** | ทดสอบเร็วตั้งแต่ต้น Waterfall |

---

# 3. บทบาทและความรับผิดชอบ (Roles & Responsibilities)

## 3.1 Role Matrix

| กิจกรรม | QA | SDET | Dev | PO/BA | DevOps | Architect | Key User |
|---------|-----|------|-----|-------|--------|-----------|----------|
| Test Strategy | **R** | C | C | C | C | C | I |
| Test Plan | **R** | C | I | C | I | I | I |
| Test Case Design | **R** | **R** | C | C | I | I | C |
| Test Data Preparation | **R** | **R** | C | C | C | I | C |
| Manual Testing | **R** | C | I | I | I | I | I |
| Test Automation | C | **R** | C | I | C | I | I |
| Test Environment | C | C | I | I | **R** | I | I |
| Defect Reporting | **R** | **R** | I | I | I | I | I |
| Defect Triage | **R** | **R** | **R** | C | I | I | I |
| Regression Test | **R** | **R** | I | I | I | I | I |
| UAT Support | **R** | C | C | **R** | I | I | **R** |
| Performance Test | C | **R** | C | I | C | C | I |
| Security Test | C | **R** | C | I | C | C | I |
| Test Report | **R** | C | I | I | I | I | I |
| Release Sign-off | C | C | I | **R** | C | C | C |

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


## 3.2 ความรับผิดชอบหลักของ QA

1. ออกแบบ Test Strategy และ Test Plan
2. เขียน Test Case (Manual + Automated)
3. เตรียม Test Data ที่เหมาะสม
4. รัน Test และรายงาน Defect
5. ตรวจ Acceptance Criteria ก่อน UAT
6. รักษา Regression Suite ให้ทันสมัย
7. สนับสนุน UAT และ Sign-off

## 3.3 ความรับผิดชอบหลักของ SDET

1. ออกแบบ Test Automation Framework
2. เขียน Automated Test (Unit / Integration / E2E)
3. บำรุงรักษา Test Suite
4. ลด Flaky Test
5. Integrate Test เข้า CI/CD
6. ทำ Performance Test และ Security Test (ถ้าจำเป็น)

## 3.4 ขอบเขตที่ QA ไม่ควรทำ

- ❌ Approve Release โดยไม่มี Test Evidence
- ❌ ปล่อย Defect Critical โดยไม่ Escalate
- ❌ รับ Defect ที่ไม่มี Steps to Reproduce
- ❌ ทำงานโดยไม่มี Test Plan
- ❌ ปล่อย Test ที่ Flaky โดยไม่แก้

---

# 4. ความรู้พื้นฐานที่ต้องมี (Prerequisites)

| ด้าน | ความรู้ที่ต้องมี |
|------|------------------|
| Testing Fundamentals | Testing Pyramid, Test Design, Test Levels |
| Test Design | Equivalence Partitioning, Boundary Value, Decision Table, State Transition |
| Automation | pytest, Playwright, Cypress, Supertest, httpx |
| Programming | Python (หลัก), TypeScript (เสริม) |
| API Testing | REST, HTTP Status, JSON, OpenAPI |
| Database | SQL, Query, Transaction |
| Security Testing | OWASP Top 10, Trivy, OWASP ZAP |
| Performance Testing | k6, JMeter, Load Test Concept |
| CI/CD | GitHub Actions, Git Flow |
| Business Domain | Finance/Accounting Workflow, ERP Integration |
| Tools | Jira, TestRail, Confluence, Postman |

---

# 5. โครงสร้างการทำงาน (Team Structure)

```text
┌─────────────────────────────────────────────────────────────┐
│                  QA TEAM STRUCTURE                          │
└─────────────────────────────────────────────────────────────┘

                    ┌──────────────┐
                    │  QA Lead     │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │Manual QA │ │  SDET    │ │Perf/Sec  │
        │          │ │Automation│ │QA        │
        └──────────┘ └──────────┘ └──────────┘
```

## 5.1 การสื่อสาร

| กิจกรรม | ความถี่ | ผู้เข้าร่วม |
|---------|---------|------------|
| Daily Standup | ทุกวัน | QA, Dev, PO |
| Backlog Grooming | สัปดาห์/ครั้ง | PO, BA, QA, Dev |
| Test Plan Review | ต่อ Release | QA, PO, DevOps |
| Defect Triage | ทุกวัน | QA, Dev, PO |
| Sprint Review | 2 สัปดาห์/ครั้ง | ทีม + Stakeholder |
| UAT Session | ตามรอบ Release | QA, PO, BA, Key User |
| Post-Incident Review | ตามเหตุการณ์ | QA, Dev, DevOps, On-call |

## 5.2 Test Environment

| Environment | Branch | ใช้ทำอะไร |
|-------------|--------|-----------|
| Local | feature/* | Dev Test |
| Development | develop | Smoke Test |
| Staging | release/* | Full Test + UAT |
| Production | main | Monitor + Post-Release Test |

---

# 6. หลักการทำงาน (Concept)

## 6.1 หลักการ 7 ประการของ QA

1. **Quality is Team's Responsibility** — QA ไม่ใช่ตำรวจ แต่เป็น Quality Advocate
2. **Shift-Left** — ทดสอบเร็วตั้งแต่ Requirement
3. **Risk-Based Testing** — เน้นทดสอบส่วนที่เสี่ยงสูงก่อน
4. **Automate What Matters** — Automate Test ที่รันบ่อยและมีคุณค่าสูง
5. **Test Pyramid** — Unit มาก, Integration ปานกลาง, E2E น้อย
6. **Evidence-Based** — ทุก Defect ต้องมี Evidence
7. **Continuous Improvement** — วัดผลและปรับปรุงทุก Sprint

## 6.2 Testing Pyramid

```text
        ┌─────────────┐
        │  E2E Tests  │  ~10%   (Playwright, Cypress)
        ├─────────────┤
        │ Integration │  ~20%   (httpx, Supertest)
        │    Tests    │
        ├─────────────┤
        │  Unit Tests │  ~70%   (pytest, Vitest)
        └─────────────┘
```

**หลักการ:** Test ที่ต่ำกว่า = เร็วและถูกกว่า, Test ที่สูงกว่า = ช้ากว่าและแพงกว่า

## 6.3 Testing Quadrants

| Quadrant | ประเภท | ตัวอย่าง |
|----------|--------|----------|
| Q1 | Unit + Component | Unit Test, Component Test |
| Q2 | Functional | Integration, E2E, UAT |
| Q3 | Exploratory | Manual Test, Session-Based |
| Q4 | Non-Functional | Performance, Security, Accessibility |

## 6.4 Risk-Based Testing

**Risk Score = Likelihood × Impact**

| Likelihood | Impact | Priority |
|------------|--------|----------|
| High | High | Test ก่อนเสมอ |
| High | Low | Test ตามเวลา |
| Low | High | Test ตามเวลา |
| Low | Low | Test ถ้ามีเวลา |

**Risk สูงในระบบการเงิน:**

- การคำนวณเงิน
- Integration กับ ERP
- Authorization / Access Control
- Data Integrity
- Payment Workflow

## 6.5 Test Levels

| ระดับ | ผู้รับผิดชอบ | Scope |
|-------|-------------|-------|
| Unit Test | Dev + SDET | Function / Class |
| Integration Test | Dev + SDET | Module + External |
| System Test | QA | ทั้งระบบ |
| UAT | PO/BA + Key User | Business Flow |
| Regression | QA + SDET | ระบบทั้งหมด |
| Performance | SDET | Load / Stress |
| Security | SDET | OWASP / Scan |

---

# 7. Workflow และ Dataflow

## 7.1 QA Workflow หลัก (6 ขั้น)

```text
┌──────────────────────────────────────────────────────────────┐
│                     QA WORKFLOW                              │
└──────────────────────────────────────────────────────────────┘

1. ANALYZE          อ่าน Story + AC, ระบุ Risk
       │
       ▼
2. PLAN             เขียน Test Plan, Test Strategy
       │
       ▼
3. DESIGN           เขียน Test Case, เตรียม Test Data
       │
       ▼
4. EXECUTE          รัน Test (Manual + Automated)
       │
       ▼
5. REPORT           บันทึก Defect, ติดตามแก้ไข
       │
       ▼
6. VERIFY           Retest + Regression + Sign-off
```

## 7.2 Dataflow: Requirement → Release

```text
┌────────────┐    ┌────────────┐    ┌────────────┐
│ User Story │───▶│  QA Test   │───▶│ Test Suite │
│ + AC       │    │  Plan      │    │            │
└────────────┘    └────────────┘    └─────┬──────┘
                                          │
                                          ▼
┌────────────┐    ┌────────────┐    ┌────────────┐
│ Production │◀───│  Sign-off  │◀───│   Run      │
│            │    │  + Report  │    │   Tests    │
└────────────┘    └────────────┘    └─────┬──────┘
                                          │
                                          ▼
                                    ┌────────────┐
                                    │  Defect    │
                                    │  Triage    │
                                    └────────────┘
```

## 7.3 Defect Lifecycle

```text
New ──▶ Assigned ──▶ In Progress ──▶ Fixed ──▶ Retest
  │                                                 │
  ▼                                                 ▼
Rejected                                       Reopened ──▶ Fixed
  │                                                 │
  ▼                                                 ▼
Closed ◀──────────────────────────────────────── Verified
```

## 7.4 Sprint Testing Timeline

| ช่วง | กิจกรรม |
|------|---------|
| Sprint Day 1–2 | Analyze + Plan Test |
| Sprint Day 3–7 | Test Case Design + Smoke Test |
| Sprint Day 8–10 | Execute Test + Report Defect |
| Sprint Day 11 | Retest + Regression |
| Sprint Day 12 | Test Report + UAT Support |
| Sprint Day 13 | Sign-off + Retrospective |

---

# 8. Test Strategy & Testing Pyramid

## 8.1 Test Strategy Document

```markdown
# Test Strategy: [Project/System Name]

**Version:** [X.X]
**Owner:** [QA Lead]
**Last Updated:** [Date]

## 1. Scope
- In Scope: [ระบุ]
- Out of Scope: [ระบุ]

## 2. Test Levels
- Unit Test: [เครื่องมือ + Target]
- Integration Test: [เครื่องมือ + Target]
- System Test: [เครื่องมือ + Target]
- UAT: [ขั้นตอน]
- Regression: [ขั้นตอน]

## 3. Test Types
- Functional
- Non-Functional (Performance, Security, Accessibility)

## 4. Risk Assessment
[Risk Matrix]

## 5. Environments
- Dev / Staging / Prod

## 6. Tools
- Test Management: Jira / TestRail
- Automation: pytest / Playwright
- Performance: k6
- Security: Trivy / OWASP ZAP

## 7. Entry / Exit Criteria
- Entry: [ระบุ]
- Exit: [ระบุ]

## 8. Roles & Responsibilities
[Role Matrix]

## 9. Schedule
[Timeline]

## 10. Risks & Mitigation
```

## 8.2 Test Plan Template

```markdown
# Test Plan: [Release/Feature Name]

**Release:** [Version]
**Period:** [Start] – [End]
**Owner:** [QA]

## 1. Objective
[เป้าหมาย]

## 2. Scope
- Features: [...]
- Stories: [...]

## 3. Test Approach
- Manual: [รายการ]
- Automated: [รายการ]
- Regression: [รายการ]

## 4. Test Data
[ชุดข้อมูล]

## 5. Environment
[Staging]

## 6. Schedule
| Day | Activity |
|-----|----------|
| 1–2 | ... |

## 7. Entry Criteria
- [ ] Deploy Staging
- [ ] Test Data พร้อม
- [ ] AC ครบ

## 8. Exit Criteria
- [ ] Test Case ผ่าน ≥ 95%
- [ ] Critical/High Defect = 0
- [ ] Regression ผ่าน
- [ ] UAT Sign-off

## 9. Risks
[ระบุ]

## 10. Approvals
- QA Lead: ______
- PO: ______
```

## 8.3 Test Level Coverage Target

| Level | Target | Owner |
|-------|--------|-------|
| Unit Test Coverage | ≥ 80% | Dev + SDET |
| Integration Test | Critical Paths ครบ | Dev + SDET |
| E2E Test | User Journeys หลัก | SDET |
| Manual Test | ทุก Story | QA |
| Regression Test | ระบบทั้งหมด | QA + SDET |
| Performance Test | ตาม Spec | SDET |
| Security Test | ทุก Release | SDET |

---

# 9. Test Case Design Techniques

## 9.1 Test Case Template

```markdown
# Test Case: TC-001

**Feature:** [ชื่อฟีเจอร์]
**Story:** [US-XXX]
**Priority:** [P0/P1/P2/P3]
**Type:** [Functional/Integration/E2E/Performance]
**Automation:** [Yes/No]

## Preconditions
- [เงื่อนไขก่อนทดสอบ]

## Test Steps
1. [ขั้นตอน 1]
2. [ขั้นตอน 2]
3. [ขั้นตอน 3]

## Test Data
| Field | Value |
|-------|-------|
| full_name | "Somchai" |
| email | "somchai@example.com" |

## Expected Result
- HTTP 201 Created
- Response มี id (UUID)
- created_at = updated_at

## Actual Result
[ผลจริง]

## Status
[Pass/Fail/Blocked/Skipped]

## Evidence
- Screenshot: [link]
- Log: [link]

## Notes
[หมายเหตุ]
```

## 9.2 Test Design Techniques

### 9.2.1 Equivalence Partitioning

แบ่ง Input เป็นกลุ่มที่ได้ผลลัพธ์เดียวกัน ทดสอบเพียง 1 ค่าต่อกลุ่ม

| Field | Valid Partition | Invalid Partition |
|-------|-----------------|-------------------|
| age | 18–60 | <18, >60, empty |
| email | รูปแบบ email ถูกต้อง | ไม่มี @, ไม่มี domain |

### 9.2.2 Boundary Value Analysis

ทดสอบค่าที่ขอบเขต

| Field | Boundaries | Test Values |
|-------|------------|-------------|
| age (18–60) | 17, 18, 60, 61 | 17, 18, 59, 60, 61 |
| amount (> 0) | 0, 0.01 | 0, 0.01, -1 |

### 9.2.3 Decision Table

| Condition 1 | Condition 2 | Action |
|-------------|-------------|--------|
| full_name ครบ | email ไม่ซ้ำ | 201 Created |
| full_name ครบ | email ซ้ำ | 409 Conflict |
| full_name ว่าง | - | 400 Bad Request |
| - | email ว่าง | 400 Bad Request |

### 9.2.4 State Transition

```text
Draft ──▶ Submitted ──▶ Approved ──▶ Synced
   │           │             │
   ▼           ▼             ▼
Cancelled   Rejected      Failed
```

Test ทุก Transition รวมทั้ง Invalid Transition (เช่น Draft → Synced โดยตรง)

### 9.2.5 Pairwise Testing

ทดสอบ Combination ของ Input ที่สำคัญ

| Browser | OS | Locale |
|---------|-----|--------|
| Chrome | Windows | TH |
| Chrome | Mac | EN |
| Firefox | Windows | EN |
| Safari | Mac | TH |

## 9.3 ตัวอย่าง Test Case: POST /employee

```markdown
# Test Case: TC-EMP-001

**Feature:** Create Employee
**Story:** US-101
**Priority:** P0
**Automation:** Yes

## Preconditions
- Database พร้อม
- ไม่มี email "somchai@example.com" ในระบบ

## Test Steps
1. POST /employee
2. Body: {"full_name": "Somchai", "email": "somchai@example.com"}

## Expected Result
- HTTP 201 Created
- Response มี id (UUID v4)
- created_at = updated_at
- full_name = "Somchai"

## Test Data
| Field | Value |
|-------|-------|
| full_name | Somchai |
| email | somchai@example.com |

## Status
[Pass/Fail]
```

## 9.4 Test Case Checklist

- [ ] ครอบคลุม Happy Path
- [ ] ครอบคลุม Edge Cases
- [ ] ครอบคลุม Negative Cases
- [ ] มี Preconditions ชัดเจน
- [ ] มี Expected Result วัดผลได้
- [ ] มี Test Data
- [ ] Independent จาก Test Case อื่น
- [ ] Traceability ไปยัง AC

## 9.5 Traceability Matrix

| Story | AC | Test Case | Status |
|-------|----|-----------| -------|
| US-101 | AC-1 | TC-EMP-001 | Pass |
| US-101 | AC-2 | TC-EMP-002 | Pass |
| US-101 | AC-3 | TC-EMP-003 | Pass |
| US-101 | AC-4 | TC-EMP-004 | Pass |
| US-101 | AC-5 | TC-EMP-005 | Pass |

---

# 10. Automated Testing Standards

## 10.1 Automation Strategy

**Automate เมื่อ:**

- Test รันบ่อย (Regression, Smoke)
- Test มี Steps ชัดเจน (ไม่ exploratory)
- Test มี Data ที่จัดการได้
- Test มีคุณค่าสูง (Critical Path)

**ไม่ Automate เมื่อ:**

- Test ที่ต้องใช้ Judgment (UX, Usability)
- Test ที่รันครั้งเดียว (One-off)
- Test ที่不稳定 (Flaky โดยธรรมชาติ)
- Test ที่ต้องใช้ Setup แพงมาก

## 10.2 Framework Stack

| ระดับ | เครื่องมือ |
|-------|-----------|
| Unit (FE) | Vitest |
| Unit (BE) | pytest |
| Integration (FE) | Testing Library |
| Integration (BE) | httpx / Supertest |
| E2E | Playwright / Cypress |
| API | pytest + httpx |
| Performance | k6 |
| Security | Trivy / OWASP ZAP |

## 10.3 Backend Test ตัวอย่าง

```python
# tests/test_employee_api.py
import pytest
from httpx import AsyncClient, ASGITransport
from api.main import app


@pytest.mark.asyncio
async def test_create_employee_success():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        resp = await client.post(
            "/employee",
            json={"full_name": "Somchai", "email": "somchai@example.com"},
        )
        assert resp.status_code == 201
        data = resp.json()
        assert data["full_name"] == "Somchai"
        assert data["created_at"] == data["updated_at"]
        assert len(data["id"]) == 36  # UUID


@pytest.mark.asyncio
async def test_create_employee_duplicate_email():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        await client.post(
            "/employee",
            json={"full_name": "A", "email": "dup@example.com"},
        )
        resp = await client.post(
            "/employee",
            json={"full_name": "B", "email": "dup@example.com"},
        )
        assert resp.status_code == 409
```

## 10.4 Frontend Test ตัวอย่าง

```typescript
// EmployeeForm.test.tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { EmployeeForm } from './EmployeeForm';

test('submits full name and email', async () => {
  const onSubmit = vi.fn().mockResolvedValue(undefined);
  render(<EmployeeForm onSubmit={onSubmit} />);

  await userEvent.type(screen.getByLabelText('Full Name'), 'Somchai');
  await userEvent.type(screen.getByLabelText('Email'), 'somchai@example.com');
  await userEvent.click(screen.getByRole('button', { name: 'Save' }));

  expect(onSubmit).toHaveBeenCalledWith({
    full_name: 'Somchai',
    email: 'somchai@example.com',
  });
});

test('shows error on failure', async () => {
  const onSubmit = vi.fn().mockRejectedValue(new Error('Email taken'));
  render(<EmployeeForm onSubmit={onSubmit} />);

  await userEvent.type(screen.getByLabelText('Full Name'), 'A');
  await userEvent.type(screen.getByLabelText('Email'), 'a@b.com');
  await userEvent.click(screen.getByRole('button', { name: 'Save' }));

  expect(await screen.findByRole('alert')).toHaveTextContent('Email taken');
});
```

## 10.5 E2E Test ตัวอย่าง (Playwright)

```typescript
// e2e/employee.spec.ts
import { test, expect } from '@playwright/test';

test('create employee and verify in list', async ({ page }) => {
  await page.goto('/employee');
  await page.getByLabel('Full Name').fill('Somchai');
  await page.getByLabel('Email').fill('somchai@example.com');
  await page.getByRole('button', { name: 'Save' }).click();

  await expect(page.getByText('Created successfully')).toBeVisible();

  await page.goto('/employee/list');
  await expect(page.getByText('Somchai')).toBeVisible();
});
```

## 10.6 Automation Standards

- **One Assertion per Test** (หรือกลุ่มเดียว)
- **Arrange-Act-Assert** ทุก Test
- **Isolation** — Test ต้องไม่ขึ้นกัน
- **Deterministic** — ผลต้องแน่นอน
- **Fast** — Unit ≤ 100ms, Integration ≤ 1s
- **Readable** — ชื่อ Test บอก Behavior
- **No Sleep** — ใช้ Wait แบบมีเงื่อนไข
- **Cleanup** — ลบ Test Data หลัง Test
- **Tagged** — ใช้ Tag (`@smoke`, `@regression`) เพื่อรันเฉพาะกลุ่ม

## 10.7 Flaky Test Management

**สาเหตุทั่วไป:**

- Race Condition
- Timing / Sleep
- External Dependency
- Shared Test Data
- Non-deterministic UI

**วิธีแก้:**

- Retry เฉพาะที่จำเป็น
- ใช้ Wait แบบมีเงื่อนไข
- Mock External Service
- แยก Test Data ต่อ Test
- Quarantine Test ที่ Flaky แล้วแก้

## 10.8 Automation Checklist

- [ ] Test มีชื่อบอก Behavior
- [ ] Arrange-Act-Assert
- [ ] Independent
- [ ] Deterministic
- [ ] Fast
- [ ] Cleanup
- [ ] Tagged
- [ ] No Hardcoded Sleep
- [ ] Integrated ใน CI/CD
- [ ] Report Result ชัดเจน

---

# 11. Defect Management

## 11.1 Defect Severity vs Priority

| Severity | ความหมาย | ตัวอย่าง |
|----------|----------|----------|
| **Critical** | ระบบล่ม / ข้อมูลเสียหาย | Payment ล่ม, ข้อมูลซ้ำ |
| **High** | ฟีเจอร์หลักไม่ทำงาน | Login ไม่ได้, Save ไม่ได้ |
| **Medium** | ฟีเจอร์ทำงานผิด | Error Message ผิด |
| **Low** | UI / Cosmetic | ปุ่มเยื้อง |

| Priority | ความหมาย |
|----------|----------|
| **P0** | แก้ทันที |
| **P1** | แก้ใน Sprint ปัจจุบัน |
| **P2** | แก้ Sprint ถัดไป |
| **P3** | แก้ถ้ามีเวลา |

## 11.2 Defect Report Template

```markdown
# Defect: BUG-001

**Severity:** [Critical/High/Medium/Low]
**Priority:** [P0/P1/P2/P3]
**Environment:** [Dev/Staging/Prod]
**Reporter:** [ชื่อ]
**Assignee:** [ชื่อ]
**Release:** [Version]
**Date:** [Date]

## Summary
[สรุปสั้น 1 บรรทัด]

## Description
[อธิบายรายละเอียด]

## Steps to Reproduce
1. [ขั้นตอน 1]
2. [ขั้นตอน 2]
3. [ขั้นตอน 3]

## Expected Behavior
[สิ่งที่ควรเกิดขึ้น]

## Actual Behavior
[สิ่งที่เกิดขึ้นจริง]

## Test Data
| Field | Value |
|-------|-------|
| email | dup@example.com |

## Evidence
- Screenshot: [link]
- Log: [link]
- Video: [link]
- Correlation ID: [id]

## Frequency
[Always / Intermittent / Once]

## Root Cause (ถ้าทราบ)
[สาเหตุ]

## Suggested Fix
[ข้อเสนอแนะ]

## Related Defects
- BUG-XXX

## Affected Test Case
TC-EMP-001
```

## 11.3 ตัวอย่าง Defect ที่ดี

```markdown
# Defect: BUG-EMP-012

**Severity:** High
**Priority:** P1
**Environment:** Staging
**Reporter:** QA-Somchai
**Assignee:** Dev-Anan

## Summary
POST /employee with duplicate email returns 500 instead of 409

## Steps to Reproduce
1. POST /employee {"full_name":"A","email":"dup@example.com"} → 201
2. POST /employee {"full_name":"B","email":"dup@example.com"}
3. Observe response

## Expected
HTTP 409 with detail "email already exists"

## Actual
HTTP 500 with detail "Internal Server Error"

## Evidence
- Log: [link]
- Correlation ID: c7b8a9d0

## Root Cause
Service throws EmailTakenError but Router ไม่ได้ catch

## Suggested Fix
เพิ่ม except EmailTakenError ใน Router → return 409
```

## 11.4 Defect ที่ไม่ดี (ตัวอย่าง)

```markdown
Summary: บันทึกไม่ได้

Steps: กด Save แล้ว error
```

**ปัญหา:** ไม่มี Steps ที่ชัดเจน, ไม่มี Test Data, ไม่มี Expected/Actual

## 11.5 Defect Triage

| กิจกรรม | ความถี่ | ผู้เข้าร่วม |
|---------|---------|------------|
| Daily Triage | ทุกวัน | QA, Dev, PO |
| Sprint Review | 2 สัปดาห์/ครั้ง | ทั้งทีม |

**เกณฑ์ Triage:**

- Severity vs Priority
- Business Impact
- Fix Complexity
- Workaround ที่มี

## 11.6 Defect Metrics

| Metric | สูตร | Target |
|--------|------|--------|
| Defect Density | Defects / KLOC | < 5 |
| Defect Leakage | (Prod Defects / Total Defects) × 100 | < 5% |
| Defect Rejection Rate | (Rejected / Total) × 100 | < 10% |
| Reopened Rate | (Reopened / Fixed) × 100 | < 5% |
| MTTR | Average Fix Time | ≤ 3 วัน (P1) |

## 11.7 Defect Management Checklist

- [ ] มี Summary ที่ชัดเจน
- [ ] มี Steps to Reproduce
- [ ] มี Expected + Actual
- [ ] มี Test Data
- [ ] มี Evidence (Screenshot/Log)
- [ ] มี Severity + Priority
- [ ] มี Environment
- [ ] มี Affected Test Case
- [ ] Link กับ Ticket / Story
- [ ] Update Status ตาม Lifecycle

---

# 12. Case Study

## Case Study 1: POST /employee — Test Suite

### 12.1.1 Test Cases

| ID | Test Case | AC | Priority |
|----|-----------|----|---------:| 
| TC-EMP-001 | Create สำเร็จ | AC-1 | P0 |
| TC-EMP-002 | full_name ว่าง | AC-2 | P0 |
| TC-EMP-003 | email ว่าง | AC-3 | P0 |
| TC-EMP-004 | email ซ้ำ | AC-4 | P0 |
| TC-EMP-005 | id เป็น UUID | AC-5 | P1 |
| TC-EMP-006 | created_at = updated_at | AC-6 | P1 |
| TC-EMP-007 | full_name มีช่องว่างหน้า-หลัง | Edge | P2 |
| TC-EMP-008 | email ตัวพิมพ์ใหญ่ | Edge | P2 |
| TC-EMP-009 | full_name ยาว 500 ตัว | Boundary | P2 |
| TC-EMP-010 | email รูปแบบผิด | Negative | P1 |

### 12.1.2 Automation Coverage

- Unit Test: Service (5 cases)
- Integration Test: Router (10 cases)
- E2E Test: UI → API → DB (3 cases)

### 12.1.3 KPI

| KPI | Target | Actual |
|-----|--------|--------|
| Coverage | 100% AC | 100% |
| Automation Rate | ≥ 70% | 80% |
| Execution Time | ≤ 30s | 25s |
| Defect Found | - | 3 |

---

## Case Study 2: Payment Reconciliation — Full Test

### 12.2.1 Test Scope

- Import Bank Statement (CSV/API)
- Auto Match
- Manual Review
- Export to ERP
- Dashboard

### 12.2.2 Risk Assessment

| Risk | Likelihood | Impact | Priority |
|------|-----------|--------|----------|
| Match ผิด | High | High | P0 |
| ข้อมูลซ้ำ | High | High | P0 |
| ERP Sync Fail | Medium | High | P0 |
| Dashboard ช้า | Medium | Medium | P1 |
| Export ผิด Format | Low | Medium | P2 |

### 12.2.3 Test Cases หลัก

| ID | Test Case | Priority |
|----|-----------|----------|
| TC-P2R-001 | Import CSV สำเร็จ | P0 |
| TC-P2R-002 | Import CSV ซ้ำ → Skip | P0 |
| TC-P2R-003 | Auto Match ด้วย Reference | P0 |
| TC-P2R-004 | Auto Match ด้วย Amount+Date | P0 |
| TC-P2R-005 | Amount ไม่ตรง → Unmatched | P0 |
| TC-P2R-006 | Manual Review → Confirm | P0 |
| TC-P2R-007 | Export ERP สำเร็จ | P0 |
| TC-P2R-008 | Export ERP ซ้ำ → ไม่สร้างซ้ำ | P0 |
| TC-P2R-009 | Audit Trail ครบ | P0 |
| TC-P2R-010 | Dashboard โหลด ≤ 3s | P1 |

### 12.2.4 Performance Test

| Scenario | Target |
|----------|--------|
| Import 10,000 รายการ | ≤ 5 นาที |
| Auto Match 10,000 รายการ | ≤ 2 นาที |
| Export 1,000 JE | ≤ 30 วินาที |
| Dashboard p95 | ≤ 3 วินาที |

### 12.2.5 KPI

| KPI | Target |
|-----|--------|
| Test Case Pass Rate | ≥ 95% |
| Automation Coverage | ≥ 70% |
| Defect Leakage | < 5% |
| UAT Pass Rate | ≥ 90% |

---

## Case Study 3: ERP Sync — Integration Test

### 12.3.1 Test Scope

- Sync Payment → Oracle ERP
- Idempotency
- Retry
- Reconciliation

### 12.3.2 Test Cases

| ID | Test Case | Priority |
|----|-----------|----------|
| TC-ERP-001 | Sync สำเร็จ | P0 |
| TC-ERP-002 | ERP Timeout → Retry | P0 |
| TC-ERP-003 | Retry แล้วสำเร็จ | P0 |
| TC-ERP-004 | Idempotency-Key ป้องกันซ้ำ | P0 |
| TC-ERP-005 | ERP ล่ม 3 ครั้ง → Pending | P0 |
| TC-ERP-006 | Daily Reconciliation ตรวจ Mismatch | P0 |
| TC-ERP-007 | Correlation ID ครบใน Log | P1 |

### 12.3.3 Test Environment

- Mock ERP ด้วย WireMock / httpx MockTransport
- Chaos Test: จำลอง Timeout / 500 Error

### 12.3.4 KPI

| KPI | Target |
|-----|--------|
| Sync Success Rate | ≥ 99% |
| Duplicate Rate | 0% |
| Retry Success Rate | ≥ 95% |

---

# 13. KPI & SMART Criteria

## 13.1 KPI หลักของ QA

| KPI | เป้าหมาย | วิธีวัด |
|-----|----------|---------|
| **Defect Leakage Rate** | < 5% | Prod Defects / Total Defects |
| **Test Automation Coverage** | ≥ 70% | Automated / Total Test Cases |
| **Test Execution Time** | ≤ 30 นาที | CI/CD Report |
| **UAT Pass Rate (First Round)** | ≥ 90% | Passed / Total UAT |
| **Defect Rejection Rate** | < 10% | Rejected / Total |
| **Test Coverage of AC** | 100% | Traceability Matrix |
| **Flaky Test Rate** | < 3% | Flaky / Total Automated |

## 13.2 KPI หลักของ SDET

| KPI | เป้าหมาย | วิธีวัด |
|-----|----------|---------|
| Automation Coverage | ≥ 70% | Coverage Report |
| Test Suite Runtime | ≤ 15 นาที | CI Report |
| Flaky Test Rate | < 3% | Test Trend |
| Automation ROI | เพิ่มขึ้นทุก Sprint | Manual vs Automated |
| Pipeline Integration | 100% | CI/CD Config |

## 13.3 SMART ตัวอย่าง

| SMART | รายละเอียด |
|-------|-----------|
| **S** | ลด Defect Leakage ของ Module Payment |
| **M** | < 5% |
| **A** | เพิ่ม Test Case + Regression Suite |
| **R** | ป้องกันข้อมูลการเงินผิดพลาด |
| **T** | ภายใน 2 Sprint |

---

# 14. คู่มือการทดสอบ (Test Execution Guide)

## 14.1 Test Execution Workflow

```text
1. ตรวจ Entry Criteria
       │
       ▼
2. เตรียม Test Environment
       │
       ▼
3. เตรียม Test Data
       │
       ▼
4. Run Smoke Test
       │
       ▼
5. Execute Full Test Suite
       │
       ▼
6. บันทึก Result (Pass/Fail/Blocked)
       │
       ▼
7. Report Defect
       │
       ▼
8. Retest Defect ที่แก้แล้ว
       │
       ▼
9. Regression Test
       │
       ▼
10. Test Report + Sign-off
```

## 14.2 Entry Criteria ก่อนรัน Test

- [ ] Deploy Staging สำเร็จ
- [ ] Smoke Test ผ่าน
- [ ] Test Data พร้อม
- [ ] Test Case ครบและ Reviewed
- [ ] Test Environment พร้อม
- [ ] AC ครบ
- [ ] ไม่มี Blocker

## 14.3 Exit Criteria

- [ ] Test Case ผ่าน ≥ 95%
- [ ] Critical Defect = 0
- [ ] High Defect = 0 (หรือ Accepted)
- [ ] Regression ผ่าน 100%
- [ ] Performance ผ่าน Target
- [ ] Security Scan ผ่าน
- [ ] UAT Sign-off

## 14.4 Test Report Template

```markdown
# Test Report: [Release/Feature]

**Period:** [Start] – [End]
**Owner:** [QA]
**Environment:** [Staging]

## 1. Summary
- Total Test Cases: [X]
- Passed: [X]
- Failed: [X]
- Blocked: [X]
- Pass Rate: [X]%

## 2. Coverage
| Type | Target | Actual |
|------|--------|--------|
| AC Coverage | 100% | [X]% |
| Automation | ≥ 70% | [X]% |
| Regression | 100% | [X]% |

## 3. Defects
| Severity | Open | Closed |
|----------|------|--------|
| Critical | [X] | [X] |
| High | [X] | [X] |
| Medium | [X] | [X] |
| Low | [X] | [X] |

## 4. Performance
| Metric | Target | Actual |
|--------|--------|--------|
| p95 Latency | ≤ 500ms | [X]ms |

## 5. Security
- Scan Result: [Pass/Fail]
- Critical Vulnerabilities: [X]

## 6. Issues & Risks
- [รายการ]

## 7. Conclusion
☑ Ready for Release
☐ Ready with Conditions
☐ Not Ready

**Sign-off:**
- QA Lead: ______ Date: ______
- PO: ______ Date: ______
```

## 14.5 Regression Test Strategy

| ระดับ | Scope | ความถี่ |
|-------|-------|---------|
| Smoke | Critical Paths | ทุก Deploy |
| Core Regression | ระบบหลัก | ทุก Sprint |
| Full Regression | ทั้งระบบ | ก่อน Release |
| Targeted Regression | เฉพาะจุดที่แก้ | ต่อ PR |

## 14.6 Smoke Test Suite ตัวอย่าง

| Test | Duration |
|------|----------|
| Login | ≤ 5s |
| Dashboard Load | ≤ 3s |
| Create Employee | ≤ 2s |
| Create Payment | ≤ 2s |
| ERP Sync | ≤ 10s |

**Target:** ≤ 5 นาที

---

# 15. คู่มือการใช้งาน (QA Guide)

## 15.1 Daily Workflow ของ QA

```text
เช้า:
1. Daily Standup
2. ตรวจ Defect ที่รอ Retest
3. รัน Smoke Test (ถ้ามี Deploy)

ระหว่างวัน:
4. Execute Test Case
5. Report Defect
6. Clarify กับ Dev/BA

เย็น:
7. อัปเดต Test Status
8. เตรียม Test Case สำหรับวันถัดไป
```

## 15.2 การใช้งาน Jira / TestRail

| งาน | วิธีทำ |
|-----|--------|
| สร้าง Test Case | Create → Test → ใส่ Steps + Expected |
| Link กับ Story | Link → Tested by |
| บันทึก Result | Update Status → Pass/Fail/Blocked |
| Report Defect | Create → Bug → ใส่ Severity/Priority |
| สร้าง Test Cycle | Create → Test Cycle → เพิ่ม Test Case |

## 15.3 การใช้งาน Postman / pytest

```bash
# Postman
- Import OpenAPI
- Run Collection
- Save Example Response

# pytest
pytest tests/ -v
pytest tests/ -k "employee"
pytest tests/ --cov=pkg --cov-report=html
```

## 15.4 การใช้งาน Playwright

```bash
npx playwright test
npx playwright test --headed
npx playwright test --project=chromium
npx playwright test --grep "@smoke"
```

## 15.5 Daily Checklist

- [ ] เข้าใจ Story + AC
- [ ] Test Case ครบ
- [ ] Test Data พร้อม
- [ ] Environment พร้อม
- [ ] Test Execution ตามแผน
- [ ] Defect Report คุณภาพ
- [ ] Update Status

---

# 16. คู่มือการบำรุงรักษา (Maintenance Guide)

## 16.1 Test Suite Maintenance

- ทบทวน Test Case ทุก Sprint
- ลบ Test ที่ Obsolete
- อัปเดต Test ที่เปลี่ยน Behavior
- เพิ่ม Test สำหรับ Edge Cases ใหม่

## 16.2 Test Data Maintenance

- สร้าง Test Data Factory สำหรับ Auto-generated
- ลบ Test Data หลัง Test
- หลีกเลี่ยง PII ใน Test Data
- Seed ข้อมูลพื้นฐานสำหรับ Smoke Test

## 16.3 Regression Suite Maintenance

| ประเภท | Review Cycle |
|--------|--------------|
| Smoke | ทุก Release |
| Core | ทุก Sprint |
| Full | ทุกไตรมาส |
| Performance | ทุก Release ใหญ่ |

## 16.4 Automation Maintenance

- ลด Flaky Test ทุก Sprint
- อัปเดต Framework Version
- Refactor Test ที่อ่านยาก
- ลบ Test ที่ไม่ Stable
- ตรวจ Runtime ทุก Sprint

## 16.5 Documentation Maintenance

| เอกสาร | Owner | Review Cycle |
|--------|-------|--------------|
| Test Strategy | QA Lead | ไตรมาส |
| Test Plan | QA | ต่อ Release |
| Test Case | QA | ต่อ Sprint |
| Defect Metrics | QA Lead | เดือน |
| Test Report | QA | ต่อ Release |

---

# 17. คู่มือการขยาย/แก้ไข (Extension Guide)

## 17.1 การเพิ่ม Test Suite ใหม่

1. ระบุ Scope
2. ระบุ Risk
3. ออกแบบ Test Cases
4. เตรียม Test Data
5. เลือก Manual vs Automated
6. กำหนด Entry/Exit Criteria
7. Integrate เข้า CI/CD

## 17.2 การเพิ่ม Automation Framework

- ระบุ Test Type ที่จะ Automate
- เลือก Framework ให้เหมาะ
- ออกแบบ Page Object / Helper
- สร้าง Test Data Factory
- Integrate Report
- CI/CD Pipeline

## 17.3 การเพิ่ม Performance Test

- ระบุ Scenario
- ระบุ Load Profile
- เตรียม Test Data
- ตั้ง Baseline
- รันและเปรียบเทียบ

## 17.4 Governance

- Test Case ใหม่ต้องผ่าน Review
- Automation ใหม่ต้องผ่าน Code Review
- Defect Template ต้องเป็นมาตรฐาน
- Metric ต้อง Review ทุกไตรมาส

---

# 18. Code Review & PR Checklist สำหรับ QA

## 18.1 QA PR Checklist

- [ ] Test ตรงกับ Story + AC
- [ ] Test Case มีชื่อบอก Behavior
- [ ] Arrange-Act-Assert
- [ ] Independent
- [ ] Deterministic
- [ ] Cleanup Test Data
- [ ] ไม่มี Hardcoded Sleep
- [ ] Tagged (`@smoke`, `@regression`)
- [ ] Integrate CI/CD
- [ ] Report Result ชัดเจน

## 18.2 สิ่งที่ QA Review ใน Dev PR

- [ ] Test Coverage ≥ 80%
- [ ] Unit Test ผ่าน
- [ ] Integration Test ผ่าน
- [ ] Edge Cases ครบ
- [ ] Error Handling ครบ
- [ ] Test Data ปลอดภัย
- [ ] ไม่มี Test ที่ Comment Out

## 18.3 สิ่งที่ QA ไม่ควรทำ

- ❌ Approve PR โดยไม่มี Test
- ❌ Comment เรื่อง Style ถ้า Linter ผ่าน
- ❌ บังคับ Test ที่ไม่มีประโยชน์
- ❌ Delay Review เกิน 24 ชั่วโมง

---

# 19. Root Cause Analysis (RCA)

## 19.1 ตัวอย่าง RCA: Defect Leakage สูง

### Problem
Defect Leakage ของ Module Payment สูงถึง 8% ในไตรมาสที่ผ่านมา

### 5 Whys

1. **Why?** — Defect หลุดไป Production 5 ตัว
2. **Why?** — Test Case ไม่ครอบคลุม Edge Cases ของ Amount
3. **Why?** — Test Design ไม่ได้ใช้ Boundary Value Analysis
4. **Why?** — QA ไม่มี Checklist บังคับสำหรับ Test Design
5. **Why?** — ขาด Training เรื่อง Test Design Techniques

### Root Cause
ขาด Checklist และ Training เรื่อง Test Design Techniques

### Corrective Action
- เพิ่ม Test Case สำหรับ Edge Cases ที่พลาด
- Re-test Module Payment

### Preventive Action
- เพิ่ม Test Design Checklist ใน Definition of Done
- จัด Training เรื่อง Equivalence / Boundary / Decision Table
- บังคับ Peer Review Test Case
- เพิ่ม Coverage Report ใน Sprint Review

### Monitoring
- KPI: Defect Leakage (Target < 5%)
- Duration: 3 เดือน
- Owner: QA Lead

## 19.2 ตัวอย่าง RCA: Flaky Test สูง

### Problem
Flaky Test Rate ของ E2E Suite สูงถึง 15%

### 5 Whys

1. **Why?** — Test ล้มเหลวแบบไม่แน่นอน
2. **Why?** — มี Hardcoded Sleep ใน Test
3. **Why?** — Test ไม่รอ Element พร้อมใช้งาน
4. **Why?** — QA ไม่ได้ใช้ Wait แบบมีเงื่อนไข
5. **Why?** — ไม่มี Guideline สำหรับ E2E Test

### Root Cause
ขาด Guideline สำหรับการเขียน E2E Test ที่ Stable

### Preventive Action
- แทนที่ Sleep ด้วย `expect().toBeVisible()`
- เพิ่ม Guideline E2E Test
- บังคับ Code Review สำหรับ Test
- Monitor Flaky Rate ทุก Sprint

## 19.3 RCA Checklist สำหรับ QA

- [ ] มี Timeline
- [ ] มี Evidence (Test Report, Log)
- [ ] มี 5 Whys หรือ Fishbone
- [ ] ระบุ Root Cause ไม่ใช่ Symptom
- [ ] มี Corrective Action
- [ ] มี Preventive Action
- [ ] มี Owner + Due Date
- [ ] มีการติดตามผล

---

# 20. ภาคผนวก: คำศัพท์สองภาษา และเอกสารอ้างอิง

## 20.1 คำศัพท์สองภาษา

| ไทย | English | ความหมาย |
|-----|---------|----------|
| การประกันคุณภาพ | Quality Assurance (QA) | กระบวนการรักษาคุณภาพ |
| การควบคุมคุณภาพ | Quality Control (QC) | การตรวจสอบคุณภาพ |
| กรณีทดสอบ | Test Case | ขั้นตอนทดสอบ |
| ชุดทดสอบ | Test Suite | กลุ่ม Test Case |
| ข้อมูลทดสอบ | Test Data | ข้อมูลที่ใช้ทดสอบ |
| การทดสอบถดถอย | Regression Test | ทดสอบซ้ำเพื่อยืนยัน |
| การทดสอบควัน | Smoke Test | ทดสอบเร็วขั้นพื้นฐาน |
| การทดสอบการยอมรับ | UAT | ทดสอบโดยผู้ใช้จริง |
| ข้อบกพร่อง | Defect / Bug | ความผิดพลาดของระบบ |
| ความรุนแรง | Severity | ระดับความรุนแรง |
| ความเร่งด่วน | Priority | ระดับความเร่งด่วน |
| การรั่วไหลของข้อบกพร่อง | Defect Leakage | Defect ที่หลุดถึง Prod |
| การทดสอบอัตโนมัติ | Automated Testing | ทดสอบด้วย Code |
| การทดสอบแบบสํารวจ | Exploratory Testing | ทดสอบแบบไม่มี Script |
| การทดสอบประสิทธิภาพ | Performance Test | ทดสอบความเร็ว/โหลด |
| การทดสอบความปลอดภัย | Security Test | ทดสอบช่องโหว่ |
| การทดสอบแบบคู่ | Pairwise Testing | ทดสอบ Combination |
| เส้นตาย | Deadline | เวลาสิ้นสุด |

## 20.2 เอกสารอ้างอิง

- Complete Multi-Role Work Manuals — FinTech & Accounting Technology Solutions
- เล่ม 1: คู่มือ Product Owner / Business Analyst
- เล่ม 2: คู่มือ Full-Stack Engineer
- เล่ม 3: คู่มือ Solution Architect / Tech Lead
- เล่ม 5: คู่มือ DevOps / Platform Engineer
- เล่ม 6: คู่มือ Code Reviewer
- เล่ม 7: คู่มือ Incident Commander / On-call
- เล่ม 10: คู่มือ AI-Assisted Development (`tb-*` Skills)
- เล่ม 12: คู่มือ CI/CD & Git Flow
- เล่ม 13: คู่มือ RCA
- เล่ม 14: คู่มือ Security & Compliance

## 20.3 มาตรฐานและ Framework อ้างอิง

- **ISTQB Foundation Level** — Testing Fundamentals
- **ISO/IEC/IEEE 29119** — Software Testing Standard
- **OWASP Top 10** — Security Testing
- **Testing Pyramid** — Mike Cohn
- **Testing Quadrants** — Brian Marick
- **Risk-Based Testing** — Rex Black
- **Page Object Model** — Selenium / Playwright Pattern

---

# ✅ ภาคผนวกท้ายเล่ม: QA Daily Checklist

## ก่อนเริ่ม Sprint
- [ ] อ่าน Story + AC ครบ
- [ ] ระบุ Risk
- [ ] ออกแบบ Test Case
- [ ] เตรียม Test Data
- [ ] ตรวจ Environment

## ระหว่าง Sprint
- [ ] Run Smoke Test
- [ ] Execute Test Case
- [ ] Report Defect คุณภาพ
- [ ] Retest Defect ที่แก้
- [ ] Update Status

## ก่อน Release
- [ ] Full Regression ผ่าน
- [ ] Critical/High Defect = 0
- [ ] Performance Test ผ่าน
- [ ] Security Scan ผ่าน
- [ ] Test Report ครบ
- [ ] UAT Sign-off

## หลัง Release
- [ ] Monitor Production
- [ ] วัด Defect Leakage
- [ ] อัปเดต Test Case
- [ ] บันทึก Lessons Learned
- [ ] แชร์ความรู้กับทีม

---
 