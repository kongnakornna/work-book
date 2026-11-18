ขอรับ — ผมจะแยกเป็น **2 เวอร์ชัน** (ไทย และ อังกฤษ) สำหรับทั้งไฟล์ `SKILL.md` และ `README.md` รวมเป็น **4 ไฟล์** ดังนี้ครับ

---

## 🇹🇭 เวอร์ชันภาษาไทย

### ไฟล์: `SKILL.md` (Thai)

```markdown
---
name: dev-workflow
description: "ชุดเครื่องมือวงจรการพัฒนาซอฟต์แวร์แบบครบวงจร ใช้ได้ทุกโปรเจกต์ ครอบคลุม brainstorming, planning, execution, scrutiny, debugging และ planning-cards ใช้สำหรับทุกงานพัฒนาตั้งแต่ไอเดียจนถึงการผลิต"
---

# Development Workflow Skill

> **เป้าหมาย:** เป็นคู่มือการพัฒนาซอฟต์แวร์แบบครบวงจร ใช้ได้กับทุกโปรเจกต์ (Frontend, Backend, Full‑Stack) ทุกรูปแบบสถาปัตยกรรม

---

## หลักการทำงาน (Core Principles)

1. **แยกความกังวล** — แยก Business Logic, Infrastructure, และ Presentation ออกจากกัน (Clean Architecture / Hexagonal / Onion)
2. **Dependency Rule** — จากภายนอกเข้าสู่ภายในเท่านั้น (Inner layers ไม่รู้จัก outer layers)
3. **Testability** — เขียน Unit Test สำหรับทุก Use Case และ Repository/Service ที่มีเงื่อนไขเชิงธุรกิจ
4. **Communication** — ใช้ภาษาไทยในการสื่อสารกับผู้ใช้ (ยกเว้นโค้ด, path, command, identifier)

---

## 🧠 1. Brainstorming — การออกแบบก่อนลงมือทำ

**ใช้เมื่อ:** เริ่มต้นงานใหม่ ฟีเจอร์ใหม่ หรือการเปลี่ยนแปลงใหญ่

### ขั้นตอน

0. **โหลดรูปแบบการสื่อสาร** (ถ้ามี) — เพื่อให้การสนทนาเป็นไปตามสไตล์ที่กำหนด
1. **สำรวจบริบท** — ตรวจสอบโครงสร้างโปรเจกต์ (ไฟล์, เอกสาร, commits ล่าสุด)
2. **ถามคำถามทีละข้อ** — เพื่อให้เข้าใจเป้าหมาย ข้อจำกัด และเกณฑ์สำเร็จ
3. **เสนอ 2–3 แนวทาง** — พร้อมข้อดี/ข้อเสีย และคำแนะนำ
4. **นำเสนอ Design** — แบ่งเป็นส่วน ๆ ตามความซับซ้อน (สถาปัตยกรรม, คอมโพเนนต์, Data Flow, Error Handling, Testing)
5. **ตรวจสอบ Design ด้วยตนเอง** — มองหาจุดที่ยังไม่ชัด, ขัดแย้ง, หรือคลุมเครือ
6. **ขออนุมัติจากผู้ใช้** — ก่อนไปขั้นตอนต่อไป
7. **ถามเรื่อง Unit Test** — ถามว่าต้องเขียนหรือไม่ (แนะนำให้เขียน)
8. **ส่งต่อให้ Writing Plans** — เมื่อ Design ได้รับอนุมัติแล้ว

> ⛔ **ห้ามเขียนโค้ดหรือสร้างไฟล์ใด ๆ จนกว่าจะผ่านขั้นตอนนี้**

---

## 📝 2. Writing Plans — การเขียนแผนปฏิบัติการ

**ใช้เมื่อ:** มี Design ที่อนุมัติแล้ว (จาก Brainstorming) และต้องการสร้างแผนละเอียด

### โครงสร้างแผน

- **ภาษา:** เขียนเป็นไทย (ยกเว้นโค้ด, path, command, identifier)
- **บันทึกที่:** `docs/plan/YYYY-MM-DD-<feature-name>.md`
- **เปิดไฟล์อัตโนมัติ:** ใช้ `code "docs/plan/..."` (ถ้าติดตั้ง `code` command)

### ส่วนประกอบของแผน

| ส่วน | คำอธิบาย |
|------|-----------|
| **ภาพรวมการแก้ไข** | ตารางสรุปทุกการเปลี่ยนแปลง (ลำดับ, Layer, ไฟล์, สิ่งที่แก้) |
| **แต่ละส่วน (ตามลำดับ workflow)** | ระบุไฟล์:บรรทัด, จาก → ถึง, รายละเอียดการแก้ไข (พร้อมโค้ด) |
| **Unit Tests** | ระบุชัดเจนว่าจะเขียนหรือไม่ และกรณีทดสอบอะไรบ้าง |
| **คำสั่งยืนยัน** | รอให้ผู้ใช้พิมพ์ `ยืนยัน เริ่ม implement plan` ก่อนลงมือ |

> 🛑 **ห้ามเริ่ม Implement จนกว่าผู้ใช้จะยืนยัน**

---

## ⚙️ 3. Executing Plans — การลงมือปฏิบัติตามแผน

**ใช้เมื่อ:** ผู้ใช้ยืนยัน (`ยืนยัน เริ่ม implement plan`) และมีไฟล์แผนพร้อม

### ขั้นตอน

1. **โหลดแผน** — อ่านไฟล์ `docs/plan/...md`
2. **ตรวจสอบความถูกต้อง** — เปิดไฟล์จริงทุกไฟล์ที่แผนอ้างถึง เปรียบเทียบกับสถานะ "จาก"
3. **ดำเนินการตามแผนทุกส่วน** — ทำตามลำดับ ครั้งเดียว ไม่หยุด (ยกเว้นปัญหาสำคัญ)
4. **เขียน Unit Test** — ถ้าแผนกำหนดให้เขียน
5. **ตรวจสอบ** — `build` ผ่าน, `test` ผ่าน (ทั้งเก่าและใหม่)
6. **รายงานผล** — ตารางสรุปสถานะ (✅ / ⚠️ / ❌) + ผลการทดสอบ + การเบี่ยงเบน (ถ้ามี)

> 🚫 **ไม่มีการ Commit** — ปล่อยให้ผู้ใช้รีวิว diff แล้ว commit เอง

---

## 🔍 4. Scrutinize — การทบทวนแผน/PR/โค้ดอย่างเป็นระบบ

**ใช้เมื่อ:** ต้องการตรวจสอบว่าแผนหรือการเปลี่ยนแปลงนั้นถูกต้อง สมบูรณ์ และมีทางเลือกที่ดีกว่า

### ขั้นตอน

0. **โหลดรูปแบบการสื่อสาร** (ถ้ามี)
1. **Intent** — เข้าใจเป้าหมายของงาน
2. **มีวิธีที่ง่ายกว่าไหม?** — พิจารณาทางเลือกอื่น (ทำน้อยลง, ใช้ของเดิม, แก้ที่ Layer อื่น)
3. **Trace** — เดินตามเส้นทางโค้ดจริง (Entry → Call → Branch → State → Exit) ทั้งที่เปลี่ยนแปลงและไม่เปลี่ยนแปลง
4. **Verify** — การเปลี่ยนแปลงทำตามที่กล่าวอ้างจริงหรือไม่? ทดสอบ Edge Cases, Concurrency, Error Paths
5. **Report** — สรุปเป็นข้อ ๆ พร้อมไฟล์:บรรทัด, เหตุผล, หลักฐาน, ข้อเสนอแก้ไข

> ✅ **Output:** ผ่าน / แก้ก่อนแล้วผ่าน / ต้องรื้อทำใหม่ / ไม่ผ่าน พร้อมเหตุผลหลัก

---

## 🐞 5. Investigate Error — การดีบักอย่างมีระเบียบ

**ใช้เมื่อ:** มีข้อผิดพลาด, Exception, หรือพฤติกรรมผิดปกติ

### คำกล่าวเปิด (Mantra) — ต้องท่องก่อนเริ่ม

> 1. **ทำซ้ำได้ก่อน** — สร้าง Repro ที่เชื่อถือได้
> 2. **รู้เส้นทางล้มเหลว** — Debugger ก่อน; แล้ว Trace Source + Knob Enumeration; แล้ว Instrument
> 3. **ตั้งคำถามกับสมมติฐาน** — อะไรจะพิสูจน์ว่าผิด?
> 4. **ทุกการรันคือเบาะแส** — เก็บ Log ทุกการทดลอง

### ขั้นตอนปฏิบัติ

- **Reproduce** — สร้างการทดสอบที่ล้มเหลวซ้ำได้ (1–5 วินาที, deterministic)
- **Find fail path** — ใช้ Debugger → Source Trace → Instrument (printf)
- **Generate hypotheses** — 3–5 สมมติฐาน จัดอันดับ และพยายามพิสูจน์ว่าผิดก่อน
- **Keep ledger** — บันทึกทุกการทดลอง (เปลี่ยนอะไร → ผลลัพธ์ → สรุป)
- **เมื่อพบ Root Cause** — ถามผู้ใช้: เขียน Plan ก่อน หรือ แก้เลย (มี/ไม่มี Unit Test)

> 🛑 **ห้ามเสนอ Fix โดยยังไม่มี Repro ที่เชื่อถือได้**

---

## 🗂️ 6. Planning Cards — สร้างแผนงานแบบ Miro Card + Flowchart

**ใช้เมื่อ:** ผู้ใช้ขอ "แผนงาน", "plan cards", "flowchart", หรือใช้คำสั่ง `/planning-cards`

### ข้อกำหนด

- **Output:** ไฟล์ Markdown และ/หรือ HTML ที่ `docs/planning/{card-number}/rtrpms-{card-number}.{md|html}`
- **ภาษา:** ไทย, ยกเว้นคำศัพท์เทคนิคและชื่อไฟล์
- **โครงสร้าง:** Title, Mermaid Flowchart (เฉพาะ HTML), ตาราง Task/Objective Cards, Error Code / i18n (ถ้ามี), Open Questions, Manual Test
- **การ์ด Task:** ต้องมี Layer Label (`[repo|service|handler|component|...]`), file path, Input, Output, Flow, Unit test requirement
- **การ์ด Objective:** ระบุขั้นตอนการทำงาน, Success Condition, Error Path
- **สี:** 🔵 Backend, 🟢 Frontend (ใช้เพื่อแยกประเภท)

### การตรวจสอบก่อนส่ง

- ทุก Task มีทั้ง Task Card และ Objective Card
- ทุก Task Card มีครบทุกฟิลด์
- Mermaid Flow สอดคล้องกับตาราง
- Path และ Function ชื่อต้องเป็นจริง (ไม่ใช่ของสมมติ)
- Manual Test ครอบคลุม Positive และ Negative

> 💡 **ถ้า Layer ใดไม่ต้องแก้ไขเลย** — อย่าสร้าง Task Card แต่ให้ระบุไว้ใน Open Questions

---

## 🔄 การทำงานร่วมกันของทั้ง 6 ขั้นตอน

```
ผู้ใช้ขอฟีเจอร์ / แก้บั๊ก
    ↓
🧠 Brainstorming (ออกแบบ)
    ↓ (อนุมัติ)
📝 Writing Plans (เขียนแผน)
    ↓ (ผู้ใช้ยืนยัน)
⚙️ Executing Plans (ลงมือทำ)
    ↓ (เสร็จ)
🔍 Scrutinize (ทบทวน) ← อาจทำก่อนหรือหลังก็ได้
    ↓
🐞 Investigate Error (ถ้าเจอปัญหา)
    ↓
🗂️ Planning Cards (ใช้เมื่อต้องการแผนแบบ Miro)
```

---

## 📌 ข้อควรจำ

- **ไม่ต้องสร้าง `plan` ซ้ำซ้อน** — Brainstorming เก็บ Design ไว้ในบทสนทนา, Writing Plans เป็นผู้สร้างไฟล์ `docs/plan/...` เพียงรายเดียว
- **การสื่อสาร:** ใช้ภาษาไทยตลอด, ยกเว้นโค้ด/คำสั่ง/ชื่อตัวแปร
- **YAGNI** — ไม่เพิ่มสิ่งที่ยังไม่จำเป็น
- **ทดสอบเสมอ** — ถ้าไม่เขียน Unit Test ให้ระบุเหตุผล

---

> 🚀 **เริ่มต้นใช้งาน:** เมื่อผู้ใช้เริ่มหัวข้อใด ๆ ให้เลือกขั้นตอนที่เหมาะสมตามบริบท แล้วดำเนินการตามลำดับของขั้นตอนนั้น
```

---

### ไฟล์: `README.md` (Thai)

```markdown
# Development Workflow Skill Suite

> ชุดเครื่องมือสำหรับวงจรการพัฒนาซอฟต์แวร์ ครอบคลุมตั้งแต่การออกแบบไปจนถึงการดีบักและการวางแผนงาน ใช้ได้กับทุกโปรเจกต์ทุกรูปแบบ

## ภาพรวม

Skill นี้รวม 6 ขั้นตอนการทำงานหลักที่ช่วยให้ทีมพัฒนามีกระบวนการที่เป็นระบบ ยืดหยุ่น และมีคุณภาพ:

1. **Brainstorming** — ออกแบบฟีเจอร์ใหม่ผ่านการถาม-ตอบ และได้ Design ที่อนุมัติ
2. **Writing Plans** — แปลง Design เป็นแผนปฏิบัติการละเอียด (ไฟล์ Markdown)
3. **Executing Plans** — ลงมือทำตามแผน พร้อมตรวจสอบ Build/Test และรายงานผล
4. **Scrutinize** — ทบทวนแผน/PR/โค้ดจากมุมมองภายนอก เพื่อหาแนวทางที่ง่ายกว่าและตรวจสอบเส้นทางจริง
5. **Investigate Error** — ดีบักอย่างเป็นระบบด้วยหลัก 4 ขั้นตอน (Reproduce → Trace → Falsify → Breadcrumb)
6. **Planning Cards** — สร้างแผนงานแบบ Miro Card + Mermaid Flowchart (HTML/Markdown)

## การทำงานร่วมกัน

ขั้นตอนเหล่านี้สามารถใช้แยกกันหรือต่อเนื่องกัน ขึ้นอยู่กับสถานการณ์:

- **เริ่มต้นงานใหม่** → ใช้ Brainstorming → Writing Plans → Executing Plans → Scrutinize
- **แก้บั๊ก** → ใช้ Investigate Error → (อาจต่อด้วย Writing Plans หรือแก้เลย)
- **ต้องการแผนนำเสนอ** → ใช้ Planning Cards

## โครงสร้างไฟล์ที่เกี่ยวข้อง

- **แผนปฏิบัติการ (จาก Writing Plans):** `docs/plan/YYYY-MM-DD-<feature-name>.md`
- **แผนการ์ด (จาก Planning Cards):** `docs/planning/{card-number}/rtrpms-{card-number}.{md|html}`

## ข้อกำหนดเบื้องต้น

- มีเครื่องมือที่ใช้สำหรับ build/test ของโปรเจกต์นั้น ๆ (เช่น Node.js, Python, Java, .NET)
- (ถ้าต้องการเปิดไฟล์แผนอัตโนมัติ) ติดตั้ง `code` command ของ VS Code หรือโปรแกรมแก้ไขที่รองรับ

## การปรับแต่ง

Skill นี้ถูกออกแบบให้เป็นกลางและยืดหยุ่น:

- สามารถเลือกใช้เฉพาะบางขั้นตอนตามความต้องการ
- รองรับทั้งโปรเจกต์ Frontend, Backend, และ Full‑Stack
- สามารถปรับภาษา (ไทย/อังกฤษ) และเพิ่มกฎเฉพาะของทีมได้ในส่วน "หลักการทำงาน"

---

**ผู้ดูแล:** ทีมพัฒนา  
**ปรับปรุงล่าสุด:** 2 กันยายน 2569

> **Tip:** ใช้คำสั่ง `/planning-cards --artifact` เพื่อสร้างแผนในรูปแบบ IDE Artifact ที่แสดงในหน้าต่างแชทโดยตรง
```

---

## 🇬🇧 English Version

### File: `SKILL.md` (English)

```markdown
---
name: dev-workflow
description: "Complete development workflow for any software project. Includes brainstorming, planning, execution, scrutiny, debugging, and planning-cards. Use for any development task from idea to production."
---

# Development Workflow Skill

> **Goal:** A comprehensive software development guide applicable to any project (Frontend, Backend, Full‑Stack) and any architectural pattern.

---

## Core Principles

1. **Separation of Concerns** — Isolate Business Logic, Infrastructure, and Presentation (Clean Architecture / Hexagonal / Onion).
2. **Dependency Rule** — Dependencies point inward only (inner layers know nothing about outer layers).
3. **Testability** — Write Unit Tests for every Use Case and Repository/Service containing business logic.
4. **Communication** — Use Thai when communicating with the user (except for code, paths, commands, and identifiers).

---

## 🧠 1. Brainstorming — Design Before Implementation

**Use when:** Starting a new task, feature, or major change.

### Steps

0. **Load communication style** (if available) — to align with the defined tone.
1. **Explore context** — Review project structure (files, docs, recent commits).
2. **Ask one question at a time** — Understand goals, constraints, and success criteria.
3. **Propose 2–3 approaches** — With trade-offs and a recommendation.
4. **Present Design** — Break down by complexity (Architecture, Components, Data Flow, Error Handling, Testing).
5. **Self-review the Design** — Check for unclear points, contradictions, or ambiguities.
6. **Get user approval** — Before proceeding.
7. **Ask about Unit Tests** — Recommend writing them.
8. **Hand off to Writing Plans** — After the design is approved.

> ⛔ **Do NOT write any code or create files until this step is complete.**

---

## 📝 2. Writing Plans — Creating Actionable Plans

**Use when:** An approved design (from Brainstorming) exists and a detailed plan is needed.

### Plan Structure

- **Language:** Written in Thai (except for code, paths, commands, identifiers).
- **Save to:** `docs/plan/YYYY-MM-DD-<feature-name>.md`
- **Auto-open file:** Use `code "docs/plan/..."` (if the `code` command is installed).

### Plan Sections

| Section | Description |
|---------|-------------|
| **Overview of Changes** | Summary table of all changes (Order, Layer, File, What to change). |
| **Each Section (workflow order)** | Specify `file:line`, `from → to`, and detailed edit (with actual code). |
| **Unit Tests** | Clearly state whether to write them and what cases to cover. |
| **Confirmation Gate** | Wait for the user to type `confirm start implement plan` before executing. |

> 🛑 **Do NOT start Implementation until the user confirms.**

---

## ⚙️ 3. Executing Plans — Implementing the Plan

**Use when:** The user confirms (`confirm start implement plan`) and the plan file is ready.

### Steps

1. **Load Plan** — Read `docs/plan/...md`.
2. **Verify against reality** — Open every file mentioned and compare with the "from" state.
3. **Execute all sections** — Follow the order, one pass, no stopping (except for critical issues).
4. **Write Unit Tests** — If the plan requires them.
5. **Verify** — Build passes, Tests pass (both old and new).
6. **Report results** — Summary table (✅ / ⚠️ / ❌) + Test results + Deviations (if any).

> 🚫 **No commit** — Leave the diff for the user to review and commit manually.

---

## 🔍 4. Scrutinize — Systematic Review of Plans/PRs/Code

**Use when:** You need to check if a plan or change is correct, complete, and has better alternatives.

### Steps

0. **Load communication style** (if available).
1. **Intent** — Understand the goal of the work.
2. **Is there a simpler way?** — Consider alternatives (do less, use existing, fix at another layer).
3. **Trace** — Walk the real code path (Entry → Call → Branch → State → Exit), including both changed and unchanged code.
4. **Verify** — Does the change actually do what it claims? Test Edge Cases, Concurrency, Error Paths.
5. **Report** — List findings with `file:line`, rationale, evidence, and fix suggestions.

> ✅ **Output:** Pass / Fix then Pass / Redo / Fail — with the primary reason.

---

## 🐞 5. Investigate Error — Disciplined Debugging

**Use when:** There is an error, exception, or unexpected behavior.

### Opening Mantra — Recite before starting

> 1. **First is reproducibility.** Build a reliable repro.
> 2. **Know the fail path.** Debugger first; then source trace + knob enumeration; then instrumentation.
> 3. **Question your hypothesis.** What would disprove it?
> 4. **Every run is a breadcrumb.** Keep a ledger of all experiments.

### Procedure

- **Reproduce** — Create a reliably failing test (1–5 seconds, deterministic).
- **Find fail path** — Use Debugger → Source Trace → Instrument (printf).
- **Generate hypotheses** — 3–5 ranked hypotheses and try to disprove them first.
- **Keep ledger** — Log every experiment (what changed → outcome → conclusion).
- **When root cause is found** — Ask the user: Write Plan first, or Fix now (with/without Unit Tests).

> 🛑 **Do NOT propose a fix without a reliable repro.**

---

## 🗂️ 6. Planning Cards — Miro-style Cards + Flowchart

**Use when:** The user requests "plan", "plan cards", "flowchart", or uses the `/planning-cards` command.

### Requirements

- **Output:** Markdown and/or HTML files at `docs/planning/{card-number}/rtrpms-{card-number}.{md|html}`
- **Language:** Thai, except for technical terms and file names.
- **Structure:** Title, Mermaid Flowchart (HTML only), Task/Objective Cards table, Error Code / i18n (if applicable), Open Questions, Manual Test.
- **Task Card:** Must have Layer Label (`[repo|service|handler|component|...]`), file path, Input, Output, Flow, Unit test requirement.
- **Objective Card:** Specify implementation details, Success Condition, Error Path.
- **Colors:** 🔵 Backend, 🟢 Frontend (for categorization).

### Pre-delivery Checks

- Every Task has both Task Card and Objective Card.
- Every Task Card has all required fields.
- Mermaid Flow matches the table content.
- File paths and function names are real (not fabricated).
- Manual Test covers both Positive and Negative cases.

> 💡 **If a layer requires zero code changes** — Do NOT create a Task Card; mention it in Open Questions instead.

---

## 🔄 Interaction of All 6 Steps

```
User requests a feature / fix
    ↓
🧠 Brainstorming (Design)
    ↓ (Approved)
📝 Writing Plans (Write Plan)
    ↓ (User confirms)
⚙️ Executing Plans (Implement)
    ↓ (Done)
🔍 Scrutinize (Review) ← Can be done before or after
    ↓
🐞 Investigate Error (If issues arise)
    ↓
🗂️ Planning Cards (When Miro-style plan is needed)
```

---

## 📌 Key Reminders

- **No duplicate `plan` creation** — Brainstorming keeps the design in conversation; Writing Plans is the sole creator of `docs/plan/...`.
- **Communication:** Use Thai throughout, except for code/commands/identifiers.
- **YAGNI** — Don't add things not yet needed.
- **Always test** — If not writing Unit Tests, state the reason explicitly.

---

> 🚀 **Getting Started:** When the user initiates a topic, select the appropriate step based on context and follow the sequence within that step.
```

---

### File: `README.md` (English)

```markdown
# Development Workflow Skill Suite

> A complete toolset for the software development lifecycle, covering design, planning, execution, review, debugging, and roadmap creation. Works for any project of any type.

## Overview

This skill integrates 6 core development workflows to help teams maintain a systematic, flexible, and high-quality process:

1. **Brainstorming** — Design new features through Q&A to get an approved design.
2. **Writing Plans** — Convert the design into a detailed action plan (Markdown file).
3. **Executing Plans** — Implement the plan, verifying Build/Test, and reporting results.
4. **Scrutinize** — Review plans/PRs/code from an outsider's perspective to find simpler alternatives and verify actual execution paths.
5. **Investigate Error** — Debug systematically using 4 steps (Reproduce → Trace → Falsify → Breadcrumb).
6. **Planning Cards** — Generate Miro-style cards + Mermaid Flowchart (HTML/Markdown).

## Collaboration Flow

These steps can be used independently or sequentially, depending on the situation:

- **New feature / project** → Brainstorming → Writing Plans → Executing Plans → Scrutinize
- **Bug fix** → Investigate Error → (Optional: Writing Plans or Fix directly)
- **Need a presentation roadmap** → Planning Cards

## Related File Structure

- **Action Plan (from Writing Plans):** `docs/plan/YYYY-MM-DD-<feature-name>.md`
- **Planning Cards (from Planning Cards):** `docs/planning/{card-number}/rtrpms-{card-number}.{md|html}`

## Prerequisites

- The relevant build/test tooling for your project (e.g., Node.js, Python, Java, .NET).
- (For auto-open plan files) Install the `code` command for VS Code or a compatible editor.

## Customization

This skill is designed to be neutral and flexible:

- You can use only specific steps as needed.
- It supports Frontend, Backend, and Full‑Stack projects.
- You can adjust the language (Thai/English) and add team-specific rules in the "Core Principles" section.

---

**Maintained by:** Development Team  
**Last Updated:** September 2, 2026

> **Tip:** Use `/planning-cards --artifact` to generate the plan as an IDE Artifact that displays directly in the chat window.
```

---
