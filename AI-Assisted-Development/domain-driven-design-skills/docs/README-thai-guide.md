# คู่มือ Domain-Driven Design Skills — ฉบับสมบูรณ์

> **Version:** 0.0.1 · **License:** Apache 2.0 · **Status:** WIP

---

## สารบัญ

1. [ภาพรวมโปรเจกต์](#1-ภาพรวมโปรเจกต์)
2. [โครงสร้างไฟล์](#2-โครงสร้างไฟล์)
3. [Pipeline 5 ขั้นตอน — Backbone หลัก](#3-pipeline-5-ขั้นตอน)
4. [รายละเอียดแต่ละ Skill](#4-รายละเอียดแต่ละ-skill)
5. [วิธีใช้งาน](#5-วิธีใช้งาน)
6. [ตัวอย่าง Validation — ประกันภัย](#6-ตัวอย่าง-validation)
7. [Ecosystem References](#7-ecosystem-references)
8. [FAQ](#8-faq)

---

## 1. ภาพรวมโปรเจกต์

### คืออะไร?

ชุด **9 Skills สำหรับ AI Agent** ที่ออกแบบมาให้ช่วยนักออกแบบ Domain Model หรือ Software Architect ทำ DDD (Domain-Driven Design) ได้แบบ **เป็นขั้นตอน** — จากการค้นพบปัญหา ไปจนถึงการส่งต่อเป็นข้อกำหนดสำหรับทีมพัฒนา

### จุดเด่น

| คุณสมบัติ | รายละเอียด |
|---|---|
| **Phased Execution** | ทำงานเป็น 5 ขั้นตอน มี Backbone ชัดเจน |
| **Non-Linear** | ด้วย Backtrack Triggers 10 จุด สามารถย้อนกลับได้ตามความจำเป็น |
| **Journal Checkpointing** | บันทึกผลลัพธ์ทุกขั้นตอน — หยุดแล้วเริ่มต่อได้ |
| **Hook-Ready** | ออกแบบมาให้เชื่อมกับ coding agent ได้ |
| **Validation Pipeline** | มีระบบตรวจสอบคุณภาพจากสถานการณ์จริง |

### Boundary ของ Skill นี้

**ครอบคลุม:**
- การค้นพบและแก้ปัญหาเชิง Domain (Discovery)
- การออกแบบ Strategic Design (Subdomains, Contexts, Context Map)
- การออกแบบ Aggregate และ Domain Interactions
- การเชื่อมต่อกับ OpenSpec (ข้อกำหนดเชิงโครงสร้าง)

**ไม่ครอบคลุม:**
- การเขียนโค้ด (ไม่ implement)
- การทดสอบ (ไม่ run tests)
- การตรวจสอบความถูกต้องของสถาปัตยกรรม

---

## 2. โครงสร้างไฟล์

```
domain-driven-design-skills/
├── AGENTS.md                    # คู่มือสำหรับ Qoder agent
├── CLAUDE.md                    # คู่มือสำหรับ Claude Code agent
├── README.md                    # README ภาษาไทย
├── README.en.md                 # README ภาษาอังกฤษ
├── skills/                      # ★ Skill หลัก 9 ตัว
│   ├── ddd-scope/
│   ├── ddd-discover/
│   ├── ddd-subdomains/
│   ├── ddd-contexts/
│   ├── ddd-context-map/
│   ├── ddd-aggregates/
│   ├── ddd-domain-interactions/
│   ├── ddd-model-review/
│   └── ddd-openspec-bridge/
├── docs/                        # เอกสารประกอบ (10 ไฟล์)
│   ├── ddd-quickstart.en.md
│   ├── ddd-skill-system-design.en.md
│   ├── ddd-pipeline-article.en.md
│   ├── ddd-openspec-mapping.md
│   ├── ddd-skills-report.en.md
│   └── *.zh.md (ภาษาจีน)
├── assets/                      # รูปประกอบ
│   ├── ddd_process.png
│   └── ddd_process_en.png
├── validation-cases/            # กรณีทดสอบจริง 2 ชุด
│   ├── cargo-validation/
│   └── insurance-validation/
└── cargo-shipping/              # (ว่าง — ยังไม่มี SHIPPING.md)
```

---

## 3. Pipeline 5 ขั้นตอน

Pipeline คือ ** หลัก** ของระบบนี้ ประกอบด้วย 9 Skills ทำงาน 5 ขั้นตอน:

```
Stage I          Stage II         Stage III        Stage IV         Stage V
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ Discovery│───▶│ Strategy │───▶│ Tactical │───▶│ Review   │───▶│ Bridge   │
│          │    │          │    │          │    │          │    │          │
│ Scope    │    │Subdomains│    │Aggregates│    │Self-     │    │OpenSpec  │
│ Discover │    │Contexts  │    │Interact. │    │ Review   │    │ Bridge   │
│          │    │Ctx.Map   │    │          │    │          │    │          │
└──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘
```

| Stage | ชื่อ | Skills | วัตถุประสงค์ |
|-------|------|-------|--------------|
| I | **Discovery** | `ddd-scope`, `ddd-discover` | ค้นพบปัญหาใน Domain |
| II | **Strategic Design** | `ddd-subdomains`, `ddd-contexts`, `ddd-context-map` | ออกแบบ Boundaries ของ Domain |
| III | **Tactical Modeling** | `ddd-aggregates`, `ddd-domain-interactions` | ออกแบบ Model ภายใน Context |
| IV | **Review** | `ddd-model-review` | ตรวจสอบ Model ด้วยตัวเอง |
| V | **Bridge** | `ddd-openspec-bridge` | เชื่อมต่อเป็นข้อกำหนดสำหรับทีม |

### ลำดับ Pipeline ที่ถูกต้อง

```
@ddd-scope
    └─▶ @ddd-discover
           └─▶ @ddd-subdomains
                  └─▶ @ddd-contexts
                         └─▶ @ddd-context-map
                                └─▶ @ddd-aggregates
                                       └─▶ @ddd-domain-interactions
                                              └─▶ @ddd-model-review
                                                     └─▶ @ddd-openspec-bridge
```

### Non-Linear Workflow — Backtrack Triggers

ออกแบบมาให้ **ไม่ต้องทำงานเป็นเส้นตรงเสมอไป** — มี 10 จุด Backtrack Trigger ที่ให้ย้อนกลับได้:

1. Terminology Conflicts → กลับไปแก้ไข Subdomains
2. Boundary Misplacement → กลับไปแก้ไข Contexts
3. Aggregate Violation → กลับไปแก้ไข Aggregates
4. Missing Event → กลับไปแก้ไข Domain Interactions
5. Review Failures → กลับไปแก้ไข Stage ที่ล้มเหลว
6. OpenSpec Gaps → กลับไปแก้ไข Tactical Modeling
7. Scoring Below Thresholds → กลับไปแก้ไข Stage ที่มีคะแนนต่ำ
8. Missing Dependencies → กลับไปแก้ไข Model
9. Incomplete Journal → กลับไปทำงานที่ยังไม่เสร็จ
10. User-Requested → กลับไปแก้ไขตามคำขอ

---

## 4. รายละเอียดแต่ละ Skill

### 4.1 `ddd-scope` — การจำกัดขอบเขตปัญหา

| รายการ | รายละเอียด |
|--------|------------|
| **Stage** | I — Discovery |
| **Input** | ปัญหาเชิงธุรกิจที่คลุมเครือ |
| **Output** | Problem Statement, Goals/Non-Goals, Constraints, Glossary, Risk List |
| **ภาษา** | ไทย |
| **NZD Schema** | ไม่มี |

**วัตถุประสงค์:** แปลงความต้องการที่คลุมเครือให้เป็น Input ที่ชัดเจนสำหรับ DDD Modeling

---

### 4.2 `ddd-discover` — การค้นพบ Domain ผ่านการร่วมมือ

| รายการ | รายละเอียด |
|--------|------------|
| **Stage** | I — Discovery |
| **Input** | Problem Statement จาก `ddd-scope` |
| **Output** | Event Stream, คำสั่ง/Event ที่เป็นไปได้, จุดร้อน (Hotspots), รายการจุดคลุมเครือ (Gray Areas) |
| **วิธีใช้** | Event Storming หรือ Domain Storytelling |

**วัตถุประสงค์:** ค้นพบ Domain ผ่านการร่วมมือ — สร้าง Event Stream พร้อม Tags

**Distance Metrics:**
- Fuzzy Prompt Match Distance
- Terminology Alignment Score
- Cross-Stage Dependency Score

---

### 4.3 `ddd-subdomains` — การจำแนก Subdomains

| รายการ | รายละเอียด |
|--------|------------|
| **Stage** | II — Strategic Design |
| **Input** | ผลลัพธ์จาก `ddd-discover` |
| **Output** | Core, Supporting, Generic Subdomains พร้อม Domain Capabilities |

**วัตถุประสงค์:** ระบุ Core, Supporting, Generic Subdomains สร้าง Domain Statement หลักและข้อเสนอแนะความเป็นเจ้าของ

**ตัวอย่างจาก Validation (Insurance):**
- **Core:** Underwriting, Policy, Claim
- **Supporting:** Customer, Fraud Investigation
- **Generic:** Payment, Regulatory Compliance

---

### 4.4 `ddd-contexts` — การออกแบบ Bounded Contexts

| รายการ | รายละเอียด |
|--------|------------|
| **Stage** | II — Strategic Design |
| **Input** | ผลลัพธ์จาก `ddd-subdomains` |
| **Output** | Bounded Contexts พร้อม Ubiquitous Language, Boundary ADR |

**วัตถุประสงค์:** ออกแบบ Bounded Context และ Ubiquitous Language

**ตัวอย่างจาก Validation (Insurance):**
- 7 Bounded Contexts: Party, Quotation, Underwriting, Policy, Claim, Payment, Regulatory
- แต่ละ Context มีทีมดูแลชัดเจน

---

### 4.5 `ddd-context-map` — การออกแบบแผนที่ความสัมพันธ์

| รายการ | รายละเอียด |
|--------|------------|
| **Stage** | II — Strategic Design |
| **Input** | ผลลัพธ์จาก `ddd-contexts` |
| **Output** | Context Map พร้อม Relationship Patterns |

**วัตถุประสงค์:** วาดแผนที่ความสัมพันธ์ระหว่าง Bounded Context

**ตัวอย่างจาก Validation (Insurance):**
- Customer-Supplier (Underwriting → Policy)
- Open Host Service + Published Language (Claim → Payment)

---

### 4.6 `ddd-aggregates` — การออกแบบ Aggregate

| รายการ | รายละเอียด |
|--------|------------|
| **Stage** | III — Tactical Modeling |
| **Input** | ผลลัพธ์จาก `ddd-context-map` |
| **Output** | Aggregate Root, Entity, Value Object, Invariants |

**วัตถุประสงค์:** ออกแบบขอบเขต Aggregate จาก Invariants

**ตัวอย่างจาก Validation (Insurance):**
- Aggregates: Application, UnderwritingCase, Policy, Claim, ClaimLineItem, Payment
- Invariants ที่ระบุ: ยอดรวม Claim ต้องไม่เกิน Sum Insured

**หมายเหตุ:** Stage นี้มีคะแนนต่ำสุดในทั้ง 2 ระบบ Validation (Cargo: 2.5/4, Insurance: 3.5/4)

---

### 4.7 `ddd-domain-interactions` — การออกแบบ Domain Interactions

| รายการ | รายละเอียด |
|--------|------------|
| **Stage** | III — Tactical Modeling |
| **Input** | ผลลัพธ์จาก `ddd-aggregates` |
| **Output** | Domain Events, Commands, Event Flows |

**วัตถุประสงค์:** ออกแบบกลไกการทำงานร่วมกันระหว่างส่วนประกอบ

**ตัวอย่างจาก Validation (Insurance):**
- Domain Events: ApplicationSubmitted, UnderwritingDecisionMade, PolicyIssued, ClaimFiled
- ครอบคลุมทุก 7 Bounded Contexts

---

### 4.8 `ddd-model-review` — การตรวจสอบ Model ด้วยตัวเอง

| รายการ | รายละเอียด |
|--------|------------|
| **Stage** | IV — Review |
| **Input** | ผลลัพธ์ทั้งหมดจาก Stage II-III |
| **Output** | Self-Review Scorecard, Issues List, Gap Analysis |

**วัตถุประสงค์:** ประเมินคุณภาพโมเดลภาพรวม — ความสอดคล้อง, ความสมบูรณ์, การวิเคราะห์การเชื่อมต่อ และปิดลูป feedback

**ตัวอย่างจาก Validation (Insurance):**
- Terminology: 9/10
- Boundaries: 8/10
- Invariants: 8/10
- Events: 9/10
- Linkages: 8/10
- ปัญหาที่พบ: TermsSnapshot/TermsVersion naming risk, Claim "God Bounded Context" signal

---

### 4.9 `ddd-openspec-bridge` — การเชื่อมต่อกับ OpenSpec

| รายการ | รายละเอียด |
|--------|------------|
| **Stage** | V — Bridge |
| **Input** | ผลลัพธ์ทั้งหมดจาก Stage IV |
| **Output** | config.yaml, proposal.md, specs/*.md |

**วัตถุประสงค์:** แปลงผลลัพธ์เชิง Domain Modeling เป็นข้อกำหนดเชิงโครงสร้างของ OpenSpec สร้างการเชื่อมต่อที่ราบรื่นจากการ Model Domain ไปสู่การ implement ทางวิศวกรรม

**ตัวอย่างจาก Validation (Insurance):**
- Changeset: `digital-claims-pipeline`
- Files: config.yaml, proposal.md, underwriting-flow.spec.md, claim-flow.spec.md, payment-flow.spec.md

---

## 5. วิธีใช้งาน

### ขั้นตอนเริ่มต้น

1. **ติดตั้ง Skill ให้กับ AI Agent**
   - สำหรับ Claude Code: ใช้ไฟล์ `CLAUDE.md`
   - สำหรับ Qoder: ใช้ไฟล์ `AGENTS.md`

2. **เริ่ม Pipeline ด้วย Problem Statement**
   ```
   เริ่มจาก @ddd-scope — ให้ข้อมูลปัญหาเชิงธุรกิจที่ต้องการแก้ไข
   ```

3. **ทำทีละขั้นตอนตาม Pipeline**
   ```
   @ddd-scope → @ddd-discover → @ddd-subdomains → @ddd-contexts → ...
   ```

4. **ใช้ Journal Checkpoints**
   - ทุกขั้นตอนจะบันทึกผลลัพธ์ลง Journal
   - หยุดได้ทุกเมื่อแล้วเริ่มต่อได้

### ตัวอย่างการใช้งานจริง

**สถานการณ์:** ต้องการออกแบบระบบประกันภัยใหม่

**ขั้นตอนที่ 1 — Scope:**
```
ปัญหา: ระบบประกันภัยเดิมทำงานช้า ลูกค้าต้องรอนาน 30 วัน
เป้าหมาย: ลดเวลาการให้บริการเหลือ 3 วัน
ข้อจำกัด: ต้องปฏิบัติตามกฎหมายประกันภัย
```

**ขั้นตอนที่ 2 — Discover (Event Storming):**
```
- ApplicationSubmitted → UnderwritingCaseCreated → PolicyIssued → ClaimFiled → PaymentProcessed
```

**ขั้นตอนที่ 3-8:** ทำตาม Pipeline ต่อเนื่อง

---

## 6. ตัวอย่าง Validation

ระบบ Validation Pipeline ตรวจสอบคุณภาพของ Skill ด้วย **2 กรณีทดสอบจริง:**

### 6.1 กรณีทดสอบ — ประกันภัย (Insurance)

| สถานการณ์ | ผลลัพธ์ |
|-----------|---------|
| Fuzzy Prompt | สถานการณ์จำลองจากธุรกิจจริง (ไม่มีคำศัพท์ DDD) |
| Pipeline Stages | 9 ขั้นตอน — ทุกขั้นตอนทำงานได้ |
| Weighted Score | **90.9%** (เกณฑ์ Expert: 85%) |
| จุดแข็ง | Discovery & Domain Interactions (4.0/4) |
| จุดอ่อน | Aggregate & Model (3.5/4) |
| OpenSpec Integration | 9/9 ผ่าน |

### 6.2 กรณีทดสอบ — บรรจุภัณฑ์ (Cargo)

| สถานการณ์ | ผลลัพธ์ |
|-----------|---------|
| Fuzzy Prompt | สถานการณ์จำลองจากธุรกิจจริง |
| Pipeline Stages | 8 ขั้นตอน — ทุกขั้นตอนทำงานได้ |
| Weighted Score | **85.8%** (เกณฑ์: 80%) |
| จุดแข็ง | Discovery & Domain Interactions (4.0/4) |
| จุดอ่อน | Aggregate (2.5/4) |
| Backtrack Triggers | 5/5 ผ่าน |

### 6.3 บทเรียนจาก Validation

1. **Aggregate Stage** ต้องการการปรับปรุง — เป็นจุดอ่อนของทั้ง 2 กรณีทดสอบ
2. **Discovery Stage** แข็งแกร่งมาก — แสดงว่า Phased Execution ทำงานได้ดี
3. **Backtrack Triggers** ช่วยให้ Pipeline ไม่ต้องทำงานเป็นเส้นตรง
4. **Journal Checkpoints** ช่วยให้ทำงานต่อจากจุดที่หยุดได้

---

## 7. Ecosystem References

Skill นี้ออกแบบมาให้เชื่อมต่อกับ DDD Ecosystem อื่นๆ ได้ (แต่ไม่ได้ implement ไว้):

| ชื่อ | สถานะ | รายละเอียด |
|------|-------|-----------|
| ddd-quickstart | Reference | คู่มือเริ่มต้นสำหรับผู้เริ่มใช้ DDD |
| ddd-skill-system-design | Reference | การออกแบบ Skill ให้ทำงานร่วมกัน |
| ddd-pipeline-article | Reference | บทความเกี่ยวกับ Pipeline |
| ddd-openspec-mapping | Reference | การเชื่อมต่อกับ OpenSpec |
| ddd-skills-report | Reference | รายงาน Skill ทั้งหมด |

ดูรายละเอียดเพิ่มเติมใน `docs/ddd-skills-report.en.md`

---

## 8. FAQ

### Q: Skill นี้ใช้ภาษาอะไร?
**A:** หลักเป็นภาษาไทย ภาษาอังกฤษใช้ `.en.md` suffix

### Q: ต้องมีทักษะอะไรบ้าง?
**A:** ความรู้พื้นฐานเกี่ยวกับ DDD — อย่างน้อยรู้จัก Aggregate, Bounded Context, Domain Event

### Q: ใช้กับ AI Agent ตัวอื่นได้ไหม?
**A:** ได้ ออกแบบมาให้เชื่อมต่อกับ coding agent ได้ — ดูในไฟล์ `AGENTS.md` และ `CLAUDE.md`

### Q: Pipeline ต้องทำตามลำดับเสมอไหม?
**A:** ไม่ต้อง — Backtrack Triggers 10 จุดช่วยให้ย้อนกลับได้ตามความจำเป็น

### Q: ข้อจำกัดของ Skill นี้?
**A:** ไม่ครอบคลุมการเขียนโค้ด การทดสอบ หรือการตรวจสอบความถูกต้องของสถาปัตยกรรม — เน้นเฉพาะ Domain Modeling

---

> **หมายเหตุ:** เอกสารนี้สร้างจากข้อมูลในโปรเจกต์ ณ วันที่ 4 กันยายน 2568 — สถานะ WIP อาจมีการเปลี่ยนแปลง
