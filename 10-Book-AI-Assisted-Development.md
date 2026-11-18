## 📘 เล่ม 10 (ฉบับขยาย): คู่มือ AI-Assisted Development (tb-* Skills)
**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับสมบูรณ์ (ส่วนที่ 1, 2 และภาค 1–3)

> **หมายเหตุ:** เอกสารนี้เป็นฉบับขยายของเล่ม 10 ใน Master Index โดยเพิ่มรายละเอียดเชิงปฏิบัติสำหรับ Developer ที่ใช้ AI-Assisted Development ผ่าน Skills `tb-*` ได้แก่ Skill Deep-Dive แต่ละตัว, Prompt Patterns, Context Management, ตัวอย่างจริง (Before/After), Anti-Patterns, Fallback เมื่อ AI ผิด, Integration กับ Git/PR และ KPIs

---
## 10.0 บทนำและปรัชญา

### 10.0.1 ทำไมต้อง AI-Assisted Development?

```
┌─────────────────────────────────────────────────────────────┐
│              PROBLEM vs SOLUTION                            │
└─────────────────────────────────────────────────────────────┘

  ปัญหาของการพัฒนาแบบเดิม:
  • เข้าใจ Task ผิด → Rework สูง
  • ไม่มี Plan → Implement วกวน
  • ไม่มี Safety Net → บั๊กหลุดถึง Prod
  • Context หาย → AI ตอบผิด

  Solution: Structured AI Workflow
  • Brainstorm ก่อน → ลด Misunderstanding
  • Plan ก่อน → ลด Rework
  • Scrutinize ก่อน Merge → ลด Defect
  • Context ชัด → AI ตอบตรง
```

### 10.0.2 ปรัชญา 3 ข้อ

| หลักการ | ความหมาย | ผลลัพธ์ |
|---------|----------|---------|
| **Think Before Code** | เข้าใจก่อนลงมือ | ลด Rework |
| **Plan Before Execute** | วางแผนก่อนทำ | ลดการวกวน |
| **Verify Before Merge** | ตรวจสอบก่อนรวม | ลด Defect |

### 10.0.3 AI เป็น "Pair Programmer" ไม่ใช่ "Auto-Coder"

```
❌ ผิด: Developer → AI → Code → Merge
   (AI ทำงานแทนทั้งหมด)

✅ ถูก: Developer ↔ AI (Brainstorm) → Plan → Execute → Scrutinize → Merge
   (AI เป็นคู่คิด, Developer เป็นผู้ตัดสินใจ)
```

**Developer ยังต้อง:**
- ตัดสินใจสุดท้าย (Final Decision)
- เข้าใจ Code ที่ AI สร้าง
- รับผิดชอบต่อ Code ที่ Merge
- Review ก่อน Commit

---

## 10.1 Skills Overview (Deep Dive)

### 10.1.1 แผนผัง Skills

```
┌─────────────────────────────────────────────────────────────┐
│                    tb-* SKILLS MAP                          │
└─────────────────────────────────────────────────────────────┘

  ┌──────────────────────────────────────────────────────┐
  │                  UNDERSTANDING PHASE                 │
  │  /tb-brainstorming  ──►  ทำความเข้าใจ · หา Assumption │
  └──────────────────────┬───────────────────────────────┘
                         │
                         ▼
  ┌──────────────────────────────────────────────────────┐
  │                  PLANNING PHASE                      │
  │  /tb-writing-plans  ──►  แบ่ง Subtask · Decision Log  │
  └──────────────────────┬───────────────────────────────┘
                         │
                         ▼
  ┌──────────────────────────────────────────────────────┐
  │                  EXECUTION PHASE                     │
  │  /tb-executing-plans  ──►  Implement + Test          │
  │  /tb-test-driven-development  ──►  Fix + Test        │
  └──────────────────────┬───────────────────────────────┘
                         │
                         ▼
  ┌──────────────────────────────────────────────────────┐
  │                  VERIFICATION PHASE                  │
  │  /tb-scrutinize  ──►  Logic + Side Effects (GATE)    │
  └──────────────────────┬───────────────────────────────┘
                         │
                         ▼
  ┌──────────────────────────────────────────────────────┐
  │                  DEBUGGING PHASE                     │
  │  /tb-investigate-error  ──►  Root Cause              │
  └──────────────────────────────────────────────────────┘
```

### 10.1.2 ตาราง Skills (ละเอียด)

| Skill | เฟส | ใช้เมื่อ | Input | Output | เวลา |
|-------|-----|---------|-------|--------|------|
| `/tb-brainstorming` | Understanding | เริ่ม Task ใหม่ / ไม่ชัด | Task Description, Context | Assumptions, Questions, Scope | 5–15 นาที |
| `/tb-writing-plans` | Planning | ต้องวางแผน | Brainstorm Output | Subtasks, Decisions, Risks | 10–20 นาที |
| `/tb-executing-plans` | Execution | ลงมือ | Plan | Code + Tests | ตาม Task |
| `/tb-investigate-error` | Debugging | Bug / Error | Error Log, Reproduction | Root Cause, Fix Direction | 10–30 นาที |
| `/tb-test-driven-development` | Execution | แก้ Bug จุดเดียว | Bug Description | Test + Fix | 5–15 นาที |
| `/tb-scrutinize` | Verification | ก่อน Merge (บังคับ) | Code Diff, Context | Review Report, Issues | 5–10 นาที |

---

## 10.2 /tb-brainstorming — Deep Dive

### 10.2.1 วัตถุประสงค์

**แปลง Task ที่คลุมเครือ → ความเข้าใจที่ชัดเจน** ก่อนลงมือทำ

### 10.2.2 เมื่อไหร่ใช้

- ✅ เริ่ม Task ใหม่ทุกครั้ง
- ✅ Task ที่ Requirement ไม่ชัด
- ✅ Task ที่มีหลาย Approach
- ✅ Task ที่กระทบหลาย Module
- ❌ Task ที่ชัดเจนมาก (เช่น แก้ Typo) — ข้ามได้

### 10.2.3 Prompt Pattern

```markdown
# /tb-brainstorming

## Task
[อธิบาย Task ที่ได้รับ]

## Context
- Repository: [ชื่อ]
- Tech Stack: [React, Python, FastAPI, MongoDB]
- Related Files: [ถ้ามี]
- Constraints: [Deadline, Performance, Security]

## Questions
1. [คำถามที่ 1]
2. [คำถามที่ 2]

## Expected Output
- Assumptions ที่ต้องยืนยัน
- Scope ที่ชัดเจน
- Questions ที่ต้องถาม PO/BA
- Potential Risks
```

### 10.2.4 ตัวอย่างจริง: POST /employee

**Input:**

```
/tb-brainstorming

Task: เพิ่ม API สำหรับสร้างพนักงานใหม่ (POST /employee)

Context:
- Repo: pms-api
- Stack: Python 3.11, FastAPI, MongoDB
- Model: Employee (id, full_name, email, created_at, updated_at)
- Constraint: Email ต้องไม่ซ้ำ, Response ต้องมี id เป็น UUID
```

**AI Output (ตัวอย่าง):**

```markdown
# Brainstorming: POST /employee

## Assumptions (ต้องยืนยัน)
1. id เป็น UUID v4 (auto-generate) ไม่ใช่ ObjectId
2. email unique index ที่ DB level (ไม่ใช่แค่ App level)
3. created_at = updated_at ตอนสร้าง
4. ไม่ต้องมี Authentication ใน Version นี้ (Internal API)
5. Response ใช้ Pydantic DTO ไม่ใช่ Raw Model
6. Duplicate email → 409 Conflict (ไม่ใช่ 400)

## Questions (ถาม PO/BA)
1. full_name มี Max Length เท่าไหร่? (แนะนำ 255)
2. email มี Max Length เท่าไหร่? (แนะนำ 255)
3. ต้อง Validate email format ที่ App หรือ DB?
4. ต้องมี Soft Delete ไหม? (ตอนนี้ยังไม่มี)

## Scope
### In Scope
- POST /employee endpoint
- Validation (full_name required, email required + format)
- Duplicate email check
- Unit Test (success + duplicate)

### Out of Scope
- Authentication
- Soft Delete
- Update / Delete endpoint

## Potential Risks
1. Race Condition ตอน Duplicate Check → ต้องมี Unique Index ที่ DB
2. Email Case Sensitivity → ต้อง Normalize (lowercase)
3. Timezone ของ created_at → ใช้ UTC
```

**Developer Action:**
- ✅ ยืนยัน Assumptions กับ PO/BA
- ✅ ตอบ Questions (หรือถาม PO)
- ✅ ใช้ Scope เป็น Baseline
- ✅ จด Risks ไว้ใน Plan

### 10.2.5 Anti-Patterns

| ❌ Anti-Pattern | ✅ ควรทำ |
|----------------|----------|
| เริ่ม Execute ทันที | Brainstorm ก่อน |
| ไม่ระบุ Context | ระบุ Repo, Stack, Model |
| ไม่ถามคำถาม | ถาม PO/BA ถ้าไม่ชัด |
| ยอมรับ Assumption โดยไม่ตรวจ | ยืนยันทุก Assumption |

---

## 10.3 /tb-writing-plans — Deep Dive

### 10.3.1 วัตถุประสงค์

**แปลง Brainstorm → แผนปฏิบัติการที่ทำตามได้** (Subtasks, Decisions, Risks)

### 10.3.2 เมื่อไหร่ใช้

- ✅ หลัง Brainstorm ทุกครั้ง
- ✅ Task ที่มีหลาย Step
- ✅ Bug ที่ต้องแก้หลายจุด
- ❌ Task เดี่ยวที่ชัดเจนมาก — ข้ามได้

### 10.3.3 Prompt Pattern

```markdown
# /tb-writing-plans

## Brainstorm Output
[แนบผลจาก /tb-brainstorming]

## Constraints
- Timeline: [ถ้ามี]
- Must Use: [Library/Framework ที่บังคับ]
- Must Not: [สิ่งที่ไม่ทำ]

## Expected Output
- Subtasks ที่ทำตามลำดับ
- Decision Log (เลือกอะไร ทำไม)
- Test Strategy
- Definition of Done
```

### 10.3.4 ตัวอย่างจริง: POST /employee (ต่อ)

**AI Output:**

```markdown
# Plan: POST /employee

## Decision Log
| # | Decision | Rationale | Alternatives |
|---|----------|-----------|--------------|
| D1 | ใช้ UUID v4 | Standard, ไม่ชนกัน | ObjectId (ไม่ตรง Spec) |
| D2 | Unique Index ที่ DB | ป้องกัน Race Condition | App-level check only (เสี่ยง) |
| D3 | Normalize email เป็น lowercase | ป้องกัน duplicate case | ใช้ Case-sensitive (ผิด) |
| D4 | Pydantic DTO สำหรับ Response | Type-safe, Auto-docs | Raw dict (ไม่ type-safe) |
| D5 | 409 Conflict สำหรับ duplicate | Semantic ถูกต้อง | 400 Bad Request (ไม่ตรง) |

## Subtasks (ตามลำดับ)

### Subtask 1: สร้าง Model (pkg/employee/models.py)
- [ ] Employee (domain model)
- [ ] EmployeeCreate (request DTO)
- [ ] EmployeeDTO (response DTO)
- [ ] Test: Model validation

### Subtask 2: สร้าง Repository (pkg/employee/repository.py)
- [ ] EmployeeRepository (interface)
- [ ] MongoEmployeeRepository (implementation)
- [ ] find_by_email()
- [ ] save()
- [ ] Test: Mock repository

### Subtask 3: สร้าง Service (pkg/employee/service.py)
- [ ] EmployeeService.create()
- [ ] Validation (full_name required)
- [ ] Duplicate check (call repo)
- [ ] Email normalize
- [ ] Test: Service logic (mock repo)

### Subtask 4: สร้าง Router (api/modules/employee/router.py)
- [ ] POST /employee
- [ ] Error handling (400, 409, 500)
- [ ] Test: API integration test

### Subtask 5: เพิ่ม Unique Index (database/migrations/)
- [ ] Migration: create unique index on email
- [ ] Test: Migration run

## Test Strategy
| Level | Tool | Coverage |
|-------|------|----------|
| Unit (Model) | pytest | Validation |
| Unit (Service) | pytest + mock | Business Logic |
| Integration (API) | httpx + ASGITransport | Endpoint |
| DB (Index) | pytest + test DB | Unique Constraint |

## Definition of Done
- [ ] Code ผ่าน Lint (ruff)
- [ ] Type Check ผ่าน (mypy)
- [ ] Unit Test Coverage ≥ 80%
- [ ] Integration Test ผ่าน
- [ ] Code Review Approved
- [ ] CI Pipeline ผ่าน
- [ ] Documentation อัปเดต (OpenAPI auto)

## Risks & Mitigation
| Risk | Mitigation |
|------|------------|
| Race Condition | Unique Index ที่ DB |
| Email case | Normalize lowercase |
| Timezone | ใช้ UTC + ISO format |
```

### 10.3.5 Anti-Patterns

| ❌ Anti-Pattern | ✅ ควรทำ |
|----------------|----------|
| Plan กว้างเกิน (1 Subtask = ทั้ง Module) | แบ่ง Subtask ให้เล็ก (≤ 1 ชม.) |
| ไม่มี Decision Log | บันทึกทุก Decision |
| ไม่มี Test Strategy | ระบุ Test ทุก Level |
| ไม่มี DoD | ระบุ DoD ชัดเจน |

---

## 10.4 /tb-executing-plans — Deep Dive

### 10.4.1 วัตถุประสงค์

**ลงมือ Implement ตาม Plan** ทีละ Subtask พร้อม Test ควบคู่

### 10.4.2 เมื่อไหร่ใช้

- ✅ หลัง Plan ทุกครั้ง
- ✅ Implement ทีละ Subtask
- ✅ Test ควบคู่ทุก Subtask

### 10.4.3 Prompt Pattern

```markdown
# /tb-executing-plans

## Plan
[แนบ Plan จาก /tb-writing-plans]

## Current Subtask
Subtask [N]: [ชื่อ]

## Context Files
- [File 1]: [บทบาท]
- [File 2]: [บทบาท]

## Constraints
- Follow existing patterns
- No hardcoded secrets
- Use type hints
- Add tests

## Expected Output
- Code
- Tests
- Explanation (ทำไมเขียนแบบนี้)
```

### 10.4.4 ตัวอย่างจริง: Subtask 1 (Model)

**AI Output:**

```python
# pkg/employee/models.py
from datetime import datetime
from uuid import UUID, uuid4
from pydantic import BaseModel, EmailStr, Field


class Employee(BaseModel):
    """Domain model for Employee."""
    id: UUID = Field(default_factory=uuid4)
    full_name: str = Field(..., min_length=1, max_length=255)
    email: EmailStr
    created_at: datetime
    updated_at: datetime


class EmployeeCreate(BaseModel):
    """Request DTO for creating an Employee."""
    full_name: str = Field(..., min_length=1, max_length=255)
    email: EmailStr


class EmployeeDTO(BaseModel):
    """Response DTO for Employee."""
    id: UUID
    full_name: str
    email: EmailStr
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
```

**Test:**

```python
# pkg/employee/models_test.py
import pytest
from uuid import UUID
from pydantic import ValidationError
from pkg.employee.models import EmployeeCreate


def test_employee_create_valid():
    emp = EmployeeCreate(full_name="Somchai", email="somchai@example.com")
    assert emp.full_name == "Somchai"
    assert emp.email == "somchai@example.com"


def test_employee_create_empty_name():
    with pytest.raises(ValidationError):
        EmployeeCreate(full_name="", email="somchai@example.com")


def test_employee_create_invalid_email():
    with pytest.raises(ValidationError):
        EmployeeCreate(full_name="Somchai", email="not-an-email")
```

**Explanation:**
- ใช้ `UUID` + `uuid4` ตาม Decision D1
- `EmailStr` จาก Pydantic จัดการ Format validation
- `Field(min_length=1)` ป้องกัน Empty string
- `EmployeeDTO` แยกจาก `Employee` เพื่อไม่ให้ Response มี Field ที่ไม่ต้องการ
- `from_attributes = True` ช่วยให้ map จาก ORM/Object ได้

### 10.4.5 Workflow ทีละ Subtask

```
┌─────────────────────────────────────────────────────────────┐
│              EXECUTING PLANS — SUBTASK LOOP                 │
└─────────────────────────────────────────────────────────────┘

  ┌──────────────────────────┐
  │ 1. เลือก Subtask ถัดไป     │
  └────────────┬─────────────┘
               ▼
  ┌──────────────────────────┐
  │ 2. Execute (AI + Dev)    │
  └────────────┬─────────────┘
               ▼
  ┌──────────────────────────┐
  │ 3. Write Test            │
  └────────────┬─────────────┘
               ▼
  ┌──────────────────────────┐
  │ 4. Run Test              │
  └────────────┬─────────────┘
               ▼
        ┌──────────────┐
        │ ผ่าน?         │
        └──┬───────┬───┘
          Yes      No
           │        │
           │        ▼
           │   ┌──────────────┐
           │   │ Fix + Re-run │
           │   └──────┬───────┘
           │          │
           ▼          ▼
  ┌──────────────────────────┐
  │ 5. Mark Subtask Done     │
  └────────────┬─────────────┘
               ▼
  ┌──────────────────────────┐
  │ 6. ยังมี Subtask? → กลับ 1 │
  │    หมด → /tb-scrutinize   │
  └──────────────────────────┘
```

### 10.4.6 Anti-Patterns

| ❌ Anti-Pattern | ✅ ควรทำ |
|----------------|----------|
| Implement ทุก Subtask พร้อมกัน | ทีละ Subtask + Test |
| ไม่ Run Test | Run Test ทุก Subtask |
| ไม่ Commit ตาม Subtask | Commit ทุก Subtask (Atomic) |
| Skip Explanation | อ่าน Explanation ทุกครั้ง |
| Copy Code โดยไม่เข้าใจ | ต้องเข้าใจทุกบรรทัด |

---

## 10.5 /tb-investigate-error — Deep Dive

### 10.5.1 วัตถุประสงค์

**หา Root Cause ของ Bug** ก่อนแก้ (ไม่ใช่แก้ที่ Symptom)

### 10.5.2 เมื่อไหร่ใช้

- ✅ เจอ Bug / Error ใหม่
- ✅ Bug ที่ไม่ชัดว่ามาจากไหน
- ✅ Bug ที่เคยแก้แล้วกลับมา
- ✅ Bug ที่กระทบหลายจุด

### 10.5.3 Prompt Pattern

```markdown
# /tb-investigate-error

## Error
[ข้อความ Error / Stack Trace]

## Reproduction Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Environment
- OS: [OS]
- Runtime: [Node 20 / Python 3.11]
- Version: [Commit SHA / Version]

## Recent Changes
- [Change 1: commit SHA]
- [Change 2: commit SHA]

## Logs
[แนบ Log ที่เกี่ยวข้อง]

## Expected Output
- Root Cause (ไม่ใช่ Symptom)
- Evidence
- Fix Direction
- Prevention
```

### 10.5.4 ตัวอย่างจริง: Duplicate Email ไม่ถูก Block

**Input:**

```
/tb-investigate-error

Error: POST /employee ด้วย email ซ้ำ กลับ 201 Created (ควรเป็น 409)

Reproduction:
1. POST /employee {full_name: "A", email: "test@example.com"} → 201
2. POST /employee {full_name: "B", email: "test@example.com"} → 201 (ผิด!)

Environment: Python 3.11, FastAPI, MongoDB, Local

Recent Changes: เพิ่ม endpoint POST /employee (commit abc123)
```

**AI Output:**

```markdown
# Error Investigation: Duplicate Email

## Symptom
POST /employee ด้วย email ซ้ำ กลับ 201 (ควรเป็น 409)

## Hypothesis (เรียงตามความน่าจะเป็น)
1. **Unique Index ไม่ถูกสร้างใน MongoDB** (น่าจะเป็นที่สุด)
2. **Service ไม่ได้เรียก find_by_email()** ก่อน save
3. **find_by_email() return None เสมอ** (bug)
4. **Transaction ไม่ Rollback** ตอน duplicate

## Investigation Steps

### Step 1: ตรวจ Unique Index ใน MongoDB
```bash
mongosh pms_dev --eval "db.employees.getIndexes()"
```
**Expected:** มี index `{ email: 1 }` แบบ unique
**ถ้าไม่มี:** นี่คือ Root Cause

### Step 2: ตรวจ Service Code
```python
# pkg/employee/service.py
async def create(self, payload: EmployeeCreate) -> EmployeeDTO:
    if not payload.full_name.strip():
        raise ValidationError("full_name is required")
    existing = await self.repo.find_by_email(payload.email)
    if existing is not None:
        raise EmailTakenError("email already exists")
    # ...
```
**ตรวจ:** `find_by_email` ถูกเรียกจริงไหม? return อะไร?

### Step 3: ตรวจ Repository
```python
async def find_by_email(self, email: str) -> Employee | None:
    doc = await self.collection.find_one({"email": email})
    return Employee(**doc) if doc else None
```
**ตรวจ:** query ถูกต้องไหม? Case-sensitive?

### Step 4: ตรวจ Transaction
- MongoDB single-doc write เป็น atomic อยู่แล้ว
- แต่ถ้า check-then-write โดยไม่มี unique index → race condition

## Root Cause (น่าจะเป็น)
**Unique Index ไม่ถูกสร้างใน MongoDB** ทำให้:
- check-then-write มี race window
- ถึงแม้ service check แล้ว แต่ 2 requests พร้อมกันอาจผ่านทั้งคู่

## Fix Direction
1. **เพิ่ม Unique Index** (สำคัญที่สุด)
   ```python
   await db.employees.create_index("email", unique=True)
   ```
2. **Handle DuplicateKeyError** ใน Service
   ```python
   from pymongo.errors import DuplicateKeyError
   
   try:
       saved = await self.repo.save(employee)
   except DuplicateKeyError:
       raise EmailTakenError("email already exists")
   ```
3. **Normalize email** เป็น lowercase ก่อน save

## Prevention
- เพิ่ม Migration สำหรับ Unique Index
- เพิ่ม Test: Concurrent duplicate requests
- เพิ่ม Test: Case-insensitive duplicate
- Code Review: ตรวจ Index ทุกครั้งที่เพิ่ม Field ที่ต้อง unique
```

**Developer Action:**
- ✅ ทำตาม Investigation Steps
- ✅ ยืนยัน Root Cause
- ✅ Fix ตาม Direction
- ✅ เพิ่ม Prevention

### 10.5.5 Anti-Patterns

| ❌ Anti-Pattern | ✅ ควรทำ |
|----------------|----------|
| แก้ที่ Symptom | หา Root Cause ก่อน |
| ไม่ Reproduce | Reproduce ให้ได้ก่อน |
| เดาสาเหตุ | ใช้ Investigation Steps |
| แก้โดยไม่ Test | Test หลังแก้ |

---

## 10.6 /tb-test-driven-development — Deep Dive

### 10.6.1 วัตถุประสงค์

**แก้ Bug จุดเดียวด้วย Test-First** — เขียน Test ที่ Fail ก่อน แล้วแก้ให้ Pass

### 10.6.2 เมื่อไหร่ใช้

- ✅ Bug ที่ชัดเจนและแคบ (จุดเดียว)
- ✅ Bug ที่ Reproduce ได้แน่นอน
- ✅ Bug ที่ไม่กระทบ Architecture
- ❌ Bug ที่กระทบหลาย Module → ใช้ /tb-writing-plans + /tb-executing-plans

### 10.6.3 Prompt Pattern

```markdown
# /tb-test-driven-development

## Bug
[อธิบาย Bug]

## Expected Behavior
[สิ่งที่ควรเป็น]

## Actual Behavior
[สิ่งที่เป็น]

## Reproduction
[ขั้นตอน Reproduce]

## Expected Output
- Test ที่ Fail (ก่อนแก้)
- Fix
- Test ที่ Pass (หลังแก้)
```

### 10.6.4 ตัวอย่างจริง: full_name เป็น Space แล้วผ่าน

**Input:**

```
/tb-test-driven-development

Bug: POST /employee ด้วย full_name = "   " (space เท่านั้น) กลับ 201
Expected: 400 Bad Request
Actual: 201 Created

Reproduction:
POST /employee {full_name: "   ", email: "test@example.com"}
```

**AI Output:**

```python
# Step 1: Write Failing Test
# pkg/employee/service_test.py

@pytest.mark.asyncio
async def test_create_employee_whitespace_name():
    """full_name ที่เป็น space เท่านั้น ต้อง raise ValidationError"""
    repo = MockEmployeeRepository()
    service = EmployeeService(repo)
    
    with pytest.raises(ValidationError, match="full_name is required"):
        await service.create(
            EmployeeCreate(full_name="   ", email="test@example.com")
        )
```

**Run Test → Fail (เพราะ Service ยังไม่ strip/check)**

```python
# Step 2: Fix
# pkg/employee/service.py

async def create(self, payload: EmployeeCreate) -> EmployeeDTO:
    stripped_name = payload.full_name.strip()
    if not stripped_name:
        raise ValidationError("full_name is required")
    # ... ใช้ stripped_name ต่อ
```

**Run Test → Pass ✅**

**Test เพิ่มเติม (Regression):**
```python
@pytest.mark.asyncio
async def test_create_employee_normal_name():
    """full_name ปกติ ต้องผ่าน"""
    repo = MockEmployeeRepository()
    service = EmployeeService(repo)
    
    result = await service.create(
        EmployeeCreate(full_name="Somchai", email="test@example.com")
    )
    assert result.full_name == "Somchai"
```

### 10.6.5 TDD Cycle (Red-Green-Refactor)

```
┌─────────────────────────────────────────────────────────────┐
│                    TDD CYCLE                                │
└─────────────────────────────────────────────────────────────┘

  🔴 RED: เขียน Test ที่ Fail
         │
         ▼
  🟢 GREEN: แก้ให้ Test ผ่าน (ง่ายที่สุด)
         │
         ▼
  🔵 REFACTOR: ปรับ Code ให้ดีขึ้น (Test ยังผ่าน)
         │
         ▼
  กลับไป 🔴 RED (Test ถัดไป)
```

### 10.6.6 Anti-Patterns

| ❌ Anti-Pattern | ✅ ควรทำ |
|----------------|----------|
| แก้ก่อน Test | Test ก่อน (Red) |
| Test ผ่านทั้งที่ยังไม่แก้ | ตรวจ Test ให้ Fail ก่อน |
| Refactor เยอะเกินไป | Refactor ทีละนิด |
| Test กว้างเกิน | Test แคบ (จุดเดียว) |

---

## 10.7 /tb-scrutinize — Deep Dive (MANDATORY GATE)

### 10.7.1 วัตถุประสงค์

**Gate สุดท้ายก่อน Merge** — ตรวจ Logic + Side Effects + Security

### 10.7.2 เมื่อไหร่ใช้

- ✅ **บังคับ** ก่อน Merge ทุกครั้ง
- ✅ หลัง Execute เสร็จ
- ✅ หลัง Bug Fix เสร็จ
- ❌ ห้ามข้าม (Mandatory Gate)

### 10.7.3 Prompt Pattern

```markdown
# /tb-scrutinize

## Code Changes
[แนบ Diff / ไฟล์ที่เปลี่ยน]

## Context
- Task: [อธิบาย Task]
- Related Files: [ไฟล์ที่เกี่ยวข้อง]
- Business Rules: [กฎธุรกิจ]

## Scrutinize Checklist
1. Logic ถูกต้องตาม Requirement?
2. Edge Cases ครบ?
3. Side Effects?
4. Security?
5. Performance?
6. Error Handling?
7. Test Coverage?
8. Observability?
9. Breaking Changes?
10. Documentation?

## Expected Output
- ✅ ผ่าน / ❌ ไม่ผ่าน
- Issues (ถ้ามี) + Severity
- Recommendations
```

### 10.7.4 ตัวอย่างจริง: Scrutinize POST /employee

**AI Output:**

```markdown
# Scrutinize Report: POST /employee

## Overall: ⚠️ PASS WITH CONDITIONS

## 1. Logic ✅
- ✅ Validation full_name required
- ✅ Email duplicate check
- ⚠️ Email case sensitivity: ต้อง normalize lowercase (ดู Issue #1)

## 2. Edge Cases ⚠️
- ✅ Empty full_name
- ✅ Whitespace full_name
- ⚠️ Email ที่มี space ข้างหน้า/หลัง → ต้อง strip (Issue #2)
- ❌ Concurrent duplicate requests → ต้อง handle DuplicateKeyError (Issue #3)

## 3. Side Effects ✅
- ✅ ไม่กระทบ Module อื่น
- ✅ ไม่มี Global State

## 4. Security ⚠️
- ✅ ไม่มี Secrets
- ✅ Input Validation
- ⚠️ ไม่มี Rate Limiting (Issue #4 — ถ้าเป็น Public API)
- ✅ ไม่มี SQL Injection (ใช้ MongoDB)

## 5. Performance ✅
- ✅ ไม่มี N+1
- ✅ Unique Index ที่ DB
- ✅ Async I/O

## 6. Error Handling ⚠️
- ✅ 400 ValidationError
- ✅ 409 EmailTakenError
- ❌ ไม่ handle DuplicateKeyError → 500 (Issue #3)
- ⚠️ ไม่ handle DB Connection Error (Issue #5)

## 7. Test Coverage ✅
- ✅ Unit Test Model
- ✅ Unit Test Service
- ✅ Integration Test API
- ⚠️ ขาด Test: Concurrent duplicate (Issue #3)
- ⚠️ ขาด Test: Email with space (Issue #2)

## 8. Observability ⚠️
- ✅ Structured Logging
- ⚠️ ไม่มี Metric (Issue #6 — Nice to have)

## 9. Breaking Changes ✅
- ✅ ไม่มี Breaking Change

## 10. Documentation ✅
- ✅ OpenAPI auto-generated
- ✅ Docstring ครบ

---

## Issues

| # | Issue | Severity | Fix |
|---|-------|----------|-----|
| 1 | Email case-sensitive | 🔴 High | Normalize lowercase |
| 2 | Email with space | 🟡 Medium | Strip ก่อน save |
| 3 | Concurrent duplicate | 🔴 High | Handle DuplicateKeyError |
| 4 | No rate limiting | 🟡 Medium | ถ้า Public API ต้องมี |
| 5 | DB error not handled | 🟡 Medium | เพิ่ม try/except |
| 6 | No metric | 🟢 Low | Nice to have |

## Recommendations
1. **ก่อน Merge (บล็อก):** Fix Issue #1, #2, #3
2. **ก่อน Merge (แนะนำ):** Fix Issue #5
3. **หลัง Merge (Follow-up):** Issue #4, #6

## Verdict
**❌ NOT READY FOR MERGE** — ต้อง fix Issue #1, #2, #3 ก่อน
```

**Developer Action:**
- ✅ Fix Issues ที่ Block
- ✅ Run /tb-scrutinize อีกครั้ง
- ✅ ถ้าผ่าน → Merge

### 10.7.5 Scrutinize Checklist (10 ข้อ)

| # | หัวข้อ | คำถาม |
|---|--------|-------|
| 1 | Logic | ตรงตาม Requirement? |
| 2 | Edge Cases | Null, Empty, Emoji, Concurrent? |
| 3 | Side Effects | กระทบ Module อื่น? |
| 4 | Security | Secrets, Injection, Auth? |
| 5 | Performance | N+1, Loop ซ้อน? |
| 6 | Error Handling | 400, 409, 500 ครบ? |
| 7 | Test Coverage | Unit, Integration, Edge? |
| 8 | Observability | Log, Metric, Trace? |
| 9 | Breaking Changes | API, DB, Config? |
| 10 | Documentation | README, OpenAPI, ADR? |

### 10.7.6 Anti-Patterns

| ❌ Anti-Pattern | ✅ ควรทำ |
|----------------|----------|
| ข้าม Scrutinize | บังคับทุกครั้ง |
| Merge ทั้งที่ Fail | Fix ก่อน Merge |
| Ignore Issue Low | จดเป็น Tech Debt |
| Scrutinize โดยไม่ Context | ให้ Context ครบ |

---

## 10.8 Workflows (ครบทุก Scenario)

### 10.8.1 Normal Development Workflow

```
┌─────────────────────────────────────────────────────────────┐
│              NORMAL DEVELOPMENT WORKFLOW                    │
└─────────────────────────────────────────────────────────────┘

  Step 1: รับ Story Task จาก PO
         │
         ▼
  Step 2: /tb-brainstorming
         ├─ ระบุ Assumptions
         ├─ ถาม Questions
         └─ ยืนยัน Scope
         │
         ▼
  Step 3: /tb-writing-plans
         ├─ แบ่ง Subtasks
         ├─ Decision Log
         └─ Test Strategy
         │
         ▼
  Step 4: /tb-executing-plans (ทีละ Subtask)
         ├─ Implement
         ├─ Test
         └─ Commit (Atomic)
         │
         ▼
  Step 5: /tb-scrutinize (MANDATORY GATE)
         ├─ ผ่าน → Step 6
         └─ Fail → Fix → Step 5
         │
         ▼
  Step 6: PR + Code Review → Merge → Deploy
```

### 10.8.2 Bug Fix Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                   BUG FIX WORKFLOW                          │
└─────────────────────────────────────────────────────────────┘

  🔍 Step 1: /tb-investigate-error (เริ่มเสมอ)
         │
         ├─ Path A: แก้หลายจุด
         │   │
         │   ▼
         │   /tb-writing-plans → /tb-executing-plans
         │
         └─ Path B: แก้จุดเดียว
             │
             ▼
             /tb-test-driven-development
         │
         ▼
  🛡 Step 2: /tb-scrutinize (MANDATORY GATE)
         ├─ ผ่าน → Merge
         └─ Fail → Fix → Scrutinize
         │
         ▼
  📝 Step 3: เพิ่ม Regression Test
         │
         ▼
  🔄 Step 4: Merge → Deploy
```

### 10.8.3 Greenfield Workflow (Feature ใหม่ทั้งหมด)

```
┌─────────────────────────────────────────────────────────────┐
│               GREENFIELD WORKFLOW                           │
└─────────────────────────────────────────────────────────────┘

  Step 1: /tb-brainstorming (ยาว — 15-30 นาที)
         ├─ ทำความเข้าใจ Domain
         ├─ ระบุ Assumptions
         └─ ยืนยันกับ PO/BA
         │
         ▼
  Step 2: /tb-writing-plans (ยาว — 20-30 นาที)
         ├─ Architecture Decision
         ├─ Subtasks (เยอะ)
         └─ Test Strategy
         │
         ▼
  Step 3: /tb-executing-plans (ทีละ Subtask)
         │
         ▼
  Step 4: /tb-scrutinize (ทุก Subtask ใหญ่)
         │
         ▼
  Step 5: PR → Code Review → Merge
```

### 10.8.4 Refactor Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                  REFACTOR WORKFLOW                          │
└─────────────────────────────────────────────────────────────┘

  Step 1: /tb-brainstorming
         ├─ Scope ของ Refactor
         ├─ สิ่งที่ไม่เปลี่ยน (Behavior)
         └─ Test ที่มีอยู่
         │
         ▼
  Step 2: /tb-writing-plans
         ├─ ลำดับการ Refactor
         ├─ Safety Net (Test)
         └─ Rollback Plan
         │
         ▼
  Step 3: /tb-executing-plans (ทีละ Step)
         ├─ Refactor
         ├─ Run Test (ต้องผ่านทุกครั้ง)
         └─ Commit (Atomic)
         │
         ▼
  Step 4: /tb-scrutinize
         ├─ Behavior ไม่เปลี่ยน?
         └─ Performance ไม่แย่ลง?
         │
         ▼
  Step 5: PR → Code Review → Merge
```

---

## 10.9 Context Management

### 10.9.1 หลักการให้ Context

```
┌─────────────────────────────────────────────────────────────┐
│                  CONTEXT PYRAMID                            │
└─────────────────────────────────────────────────────────────┘

  ┌───────────────────────┐
  │  Business Context     │  ← ทำไมต้องทำ?
  │  (Task, Requirement)  │
  └───────────┬───────────┘
              ▼
  ┌───────────────────────┐
  │  Technical Context    │  ← ทำที่ไหน?
  │  (Repo, Stack, Files) │
  └───────────┬───────────┘
              ▼
  ┌───────────────────────┐
  │  Constraint Context   │  ← ข้อจำกัด?
  │  (Deadline, Security) │
  └───────────┬───────────┘
              ▼
  ┌───────────────────────┐
  │  Related Context      │  ← กระทบอะไร?
  │  (Dependencies)       │
  └───────────────────────┘
```

### 10.9.2 สิ่งที่ต้องให้ Context

| ประเภท | ตัวอย่าง | จำเป็น |
|--------|----------|:------:|
| **Task** | User Story, Bug Report | ✅ |
| **Stack** | React, Python, MongoDB | ✅ |
| **Files** | ไฟล์ที่เกี่ยวข้อง | ✅ |
| **Patterns** | Coding style, Architecture | ✅ |
| **Constraints** | Deadline, Security, Performance | ✅ |
| **Business Rules** | Validation, Logic | ✅ |
| **Tests** | Test ที่มีอยู่ | ⚠️ ถ้ามี |

### 10.9.3 สิ่งที่ไม่ควรให้ Context

| ❌ ไม่ควร | เหตุผล |
|----------|--------|
| Secrets / Password | รั่วไหล |
| PII (ข้อมูลลูกค้า) | PDPA |
| Code ทั้ง Repo (ไม่คัด) | AI สับสน |
| ไฟล์ที่ไม่เกี่ยวข้อง | Noise |
| Context ยาวเกิน (10K+ tokens) | AI ลืม |

### 10.9.4 Context Template

```markdown
## Task
[อธิบาย Task]

## Repository
- Name: [ชื่อ]
- Stack: [React 18, TypeScript, FastAPI, MongoDB]
- Structure: [Monorepo / Single]

## Related Files
- `pkg/employee/models.py` — Model
- `pkg/employee/service.py` — Service
- `pkg/employee/repository.py` — Repository
- `api/modules/employee/router.py` — API

## Patterns
- Clean Architecture (Handler → Service → Repository)
- Pydantic สำหรับ Validation
- pytest สำหรับ Test

## Constraints
- Performance: Response ≤ 200ms
- Security: No hardcoded secrets
- Compatibility: Python 3.11+

## Business Rules
- Email ต้องไม่ซ้ำ
- full_name ต้องไม่เป็น space เท่านั้น
```

---

## 10.10 Prompt Patterns (สำหรับ tb-* Skills)

### 10.10.1 โครงสร้าง Prompt ที่ดี

```
┌─────────────────────────────────────────────────────────────┐
│                  PROMPT STRUCTURE                           │
└─────────────────────────────────────────────────────────────┘

  1. ROLE (ถ้าจำเป็น)
     "You are a senior Python developer..."

  2. TASK
     "/tb-brainstorming"
     [อธิบาย Task]

  3. CONTEXT
     - Repo, Stack, Files
     - Patterns, Constraints

  4. INPUT
     - Code, Log, Error

  5. EXPECTED OUTPUT
     - รูปแบบที่ต้องการ

  6. CONSTRAINTS
     - สิ่งที่ต้อง/ไม่ต้องทำ
```

### 10.10.2 ตัวอย่าง Prompt ที่ดี vs ไม่ดี

**❌ ไม่ดี:**
```
ช่วยเขียน API ให้หน่อย
```

**✅ ดี:**
```
/tb-brainstorming

Task: เพิ่ม API POST /employee สำหรับสร้างพนักงาน

Context:
- Stack: Python 3.11, FastAPI, MongoDB
- Model: Employee (id, full_name, email, created_at, updated_at)
- Pattern: Clean Architecture

Business Rules:
- Email unique (case-insensitive)
- full_name required (ไม่เป็น space)
- id เป็น UUID v4

Expected Output:
- Assumptions
- Questions
- Scope
- Risks
```

### 10.10.3 Iterative Refinement

```
รอบ 1: /tb-brainstorming → ได้ Assumptions
         │
         ▼
รอบ 2: ตอบ Questions → /tb-brainstorming อีกครั้ง (ถ้าจำเป็น)
         │
         ▼
รอบ 3: /tb-writing-plans → ได้ Plan
         │
         ▼
รอบ 4: /tb-executing-plans ทีละ Subtask
         │
         ▼
รอบ 5: /tb-scrutinize → ถ้า Fail → Fix → Scrutinize
```

---

## 10.11 Fallback เมื่อ AI ผิด

### 10.11.1 ประเภทของ AI ผิด

| ประเภท | ตัวอย่าง | วิธีแก้ |
|--------|----------|--------|
| **Hallucination** | สร้าง API ที่ไม่มี | ตรวจ Docs จริง |
| **Logic Error** | Logic ผิด | เขียน Test, Scrutinize |
| **Outdated** | ใช้ API เก่า | ระบุ Version |
| **Incomplete** | ทำไม่ครบ | ถามเพิ่ม |
| **Over-engineered** | ทำเกินจำเป็น | ระบุ Scope |
| **Wrong Pattern** | ไม่ตรง Architecture | ระบุ Pattern |

### 10.11.2 Fallback Protocol

```
┌─────────────────────────────────────────────────────────────┐
│                  FALLBACK PROTOCOL                          │
└─────────────────────────────────────────────────────────────┘

  AI ผิด?
     │
     ▼
  ┌──────────────────────┐
  │ 1. ระบุว่าผิดตรงไหน   │
  └──────────┬───────────┘
             ▼
  ┌──────────────────────┐
  │ 2. ให้ Context เพิ่ม  │
  └──────────┬───────────┘
             ▼
  ┌──────────────────────┐
  │ 3. ขอให้แก้           │
  └──────────┬───────────┘
             ▼
        ┌──────────┐
        │ ถูก?      │
        └──┬───┬───┘
          Yes  No
           │    │
           │    ▼
           │  ┌──────────────────────┐
           │  │ 4. ลอง Approach อื่น │
           │  └──────────┬───────────┘
           │             ▼
           │  ┌──────────────────────┐
           │  │ 5. ถ้ายังไม่ได้ →      │
           │  │    ถามคน (Pair)      │
           │  └──────────────────────┘
           ▼
        Merge
```

### 10.11.3 ตัวอย่าง Fallback

**AI สร้าง Code ที่ใช้ Library เก่า:**

```
Developer: "Library นี้ไม่รองรับ Python 3.11 แล้ว ช่วยใช้ version ใหม่"
AI: [สร้างใหม่ด้วย version ใหม่]
Developer: ตรวจ → ผ่าน
```

**AI สร้าง Logic ผิด:**

```
Developer: "Logic นี้ผิด — ต้อง check duplicate ก่อน save ไม่ใช่หลัง"
AI: [แก้]
Developer: /tb-scrutinize → ผ่าน
```

---

## 10.12 Integration กับ Git / PR

### 10.12.1 Git Workflow กับ tb-* Skills

```
┌─────────────────────────────────────────────────────────────┐
│              GIT + TB-* WORKFLOW                            │
└─────────────────────────────────────────────────────────────┘

  main
   │
   ├── feature/PMS-101-add-employee
   │   │
   │   ├── /tb-brainstorming → (ไม่ Commit)
   │   ├── /tb-writing-plans → Commit (docs/plan.md)
   │   ├── /tb-executing-plans
   │   │   ├── Subtask 1 → Commit (feat: add model)
   │   │   ├── Subtask 2 → Commit (feat: add repository)
   │   │   ├── Subtask 3 → Commit (feat: add service)
   │   │   └── Subtask 4 → Commit (feat: add router)
   │   ├── /tb-scrutinize → (ไม่ Commit — เป็น Gate)
   │   └── PR → Review → Merge
```

### 10.12.2 Commit Message ที่ดี (สำหรับ AI-Assisted)

```
feat(employee): add POST /employee endpoint

- Auto-generate UUID v4 for id
- Validate full_name (required, non-whitespace)
- Normalize email to lowercase
- Reject duplicate email with 409 Conflict
- Add unique index on email

AI-Assisted: /tb-executing-plans (Subtask 1-4)
Scrutinized: /tb-scrutinize (PASS)

Closes: #PMS-101
```

### 10.12.3 PR Template (AI-Assisted)

```markdown
# Pull Request: [ชื่อ]

**Ticket:** [Link]
**Type:** Feature / Bugfix / Refactor
**AI Skills Used:**
- [x] /tb-brainstorming
- [x] /tb-writing-plans
- [x] /tb-executing-plans
- [x] /tb-scrutinize

## 📝 What
[อธิบาย]

## 🎯 Why
[เหตุผล]

## 🔧 How
[วิธี]

## 🤖 AI-Assisted Notes
- **Assumptions ยืนยันแล้ว:** [ระบุ]
- **Decision Log:** [Link to docs/plan.md]
- **Scrutinize Result:** ✅ PASS / ⚠️ PASS WITH CONDITIONS
- **Issues ที่ Defer:** [ระบุ + Ticket]

## 🧪 Test Plan
- [ ] Unit Test ผ่าน
- [ ] Integration Test ผ่าน
- [ ] Manual Test บน Staging

## ⚠️ Risks & Rollback
[ระบุ]
```

---

## 10.13 KPIs สำหรับ AI-Assisted Development

### 10.13.1 KPI หลัก

| KPI | คำนิยาม | เป้าหมาย | วิธีวัด |
|-----|---------|----------|---------|
| **Rework Rate** | % งานที่ต้องแก้หลัง Merge | < 10% | Bugs / Stories |
| **Defect Leakage** | % บั๊กที่หลุดถึง Prod | < 5% | Prod Bugs / Total |
| **Time to First PR** | เวลาจากเริ่ม Task ถึง PR แรก | ≤ 1 วัน | Git timestamp |
| **Scrutinize Pass Rate** | % ที่ผ่าน Scrutinize ครั้งแรก | ≥ 95% | Scrutinize log |
| **Brainstorm Coverage** | % Task ที่ใช้ Brainstorm | 100% | Process audit |
| **Plan Adherence** | % ที่ทำตาม Plan | ≥ 90% | Plan vs Actual |
| **Test Coverage** | % Code ที่มี Test | ≥ 80% | Coverage tool |
| **Developer Satisfaction** | ความพึงพอใจ | ≥ 4/5 | Survey |

### 10.13.2 KPI Dashboard (ตัวอย่าง)

```
┌─────────────────────────────────────────────────────────────┐
│           AI-ASSISTED DEVELOPMENT — KPI DASHBOARD           │
│                  Sprint 24 (2024-11)                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Rework Rate:      ████░░░░░░  8%   🟢 (Target <10%)       │
│  Defect Leakage:   ██░░░░░░░░  3%   🟢 (Target <5%)        │
│  Time to First PR: ████████░░  0.8d 🟢 (Target ≤1d)        │
│  Scrutinize Pass:  █████████░  96%  🟢 (Target ≥95%)       │
│  Brainstorm Cov:   ██████████  100% 🟢 (Target 100%)       │
│  Plan Adherence:   ████████░░  88%  🟡 (Target ≥90%)       │
│  Test Coverage:    ████████░░  82%  🟢 (Target ≥80%)       │
│                                                              │
│  Developer Sat:    4.4/5            🟢                      │
│                                                              │
│  Highlights:                                                 │
│  • Scrutinize ช่วยจับ Bug ได้ 12 ตัวก่อน Merge             │
│  • ลด Rework จาก 15% → 8% ใน 3 Sprint                      │
│                                                              │
│  Concerns:                                                   │
│  • Plan Adherence ลดลง → บาง Task ไม่ได้ Plan ล่วงหน้า     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 10.13.3 วิธีวัดผล

| KPI | Data Source | ความถี่ |
|-----|-------------|---------|
| Rework Rate | Git + Bug Tracker | Sprint |
| Defect Leakage | Bug Tracker | Sprint |
| Time to First PR | Git + Issue Tracker | Task |
| Scrutinize Pass Rate | Scrutinize Log | Sprint |
| Brainstorm Coverage | Process Audit | Sprint |
| Plan Adherence | Plan vs Actual | Sprint |
| Test Coverage | Coverage Tool | ทุก PR |
| Developer Sat | Survey | ไตรมาส |

---

## 10.14 FAQ

**Q1: ต้องใช้ทุก Skill ทุกครั้งไหม?**
A: ไม่ — Task เล็กมาก (แก้ Typo) ข้าม Brainstorm/Plan ได้ แต่ **Scrutinize บังคับทุกครั้ง**

**Q2: ถ้า AI ตอบช้า / ค้าง ทำไง?**
A: ลองแบ่ง Prompt ให้เล็กลง, ให้ Context น้อยลง, ลอง Skill ที่เล็กลง (เช่น TDD แทน Execute)

**Q3: AI สร้าง Code ที่ไม่เข้าใจ ทำไง?**
A: **ห้าม Merge** — ถาม AI ให้อธิบายทีละบรรทัด หรือให้เขียน Comment ถ้ายังไม่เข้าใจ → ปรึกษา Senior

**Q4: Scrutinize ผ่าน แต่ Code Review ไม่ผ่าน ทำไง?**
A: ใช้ Feedback จาก Code Review มา Improve — อาจต้องกลับไป Brainstorm/Plan ใหม่

**Q5: ใช้ AI กับ Legacy Code ได้ไหม?**
A: ได้ — แต่ต้องให้ Context เยอะขึ้น (Architecture, Pattern) และระวัง AI ไม่รู้ Context เก่า

**Q6: AI แนะนำ Library ที่ไม่รู้จัก ควรใช้ไหม?**
A: **อย่าเพิ่ง** — ตรวจ:
1. Library มีจริงไหม?
2. Maintain อยู่ไหม?
3. License OK ไหม?
4. Security (CVE) ไหม?
ถ้าไม่แน่ใจ → ปรึกษา Architect

**Q7: ต้อง Commit Plan ไหม?**
A: **แนะนำ** — Commit `docs/plan-PMS-101.md` เพื่อเป็น Reference ในอนาคต

**Q8: ใช้ AI กับ Production โดยตรงได้ไหม?**
A: **ไม่ได้** — ต้องผ่าน Branch → PR → Review → Merge → Deploy ตามปกติ

**Q9: Scrutinize ใช้ AI ตัวเดียวกับ Execute ได้ไหม?**
A: ได้ — แต่ **แนะนำ** ให้ใช้ AI คนละ Session (หรือคนละ Model) เพื่อลด Bias

**Q10: วัดผล AI-Assisted ยังไง?**
A: ดู KPI 10.13 — หลักๆ คือ Rework Rate, Defect Leakage, Time to First PR

---

## 10.15 Anti-Patterns (ภาพรวม)

| # | Anti-Pattern | ผลกระทบ | วิธีแก้ |
|---|--------------|---------|--------|
| 1 | เริ่ม Execute ทันที | Rework สูง | Brainstorm ก่อน |
| 2 | ไม่มี Plan | วกวน | Plan ก่อน Execute |
| 3 | ข้าม Scrutinize | บั๊กหลุด | บังคับทุกครั้ง |
| 4 | Merge โดยไม่เข้าใจ | Maintain ไม่ได้ | ต้องเข้าใจทุกบรรทัด |
| 5 | ใช้ AI แทนคิด | ทีมไม่โต | AI เป็นคู่คิด ไม่ใช่แทน |
| 6 | ไม่ให้ Context | AI ตอบผิด | ให้ Context ครบ |
| 7 | Prompt กว้างเกิน | AI สับสน | แบ่ง Prompt เล็กลง |
| 8 | ไม่มี Test | Bug เยอะ | Test ทุก Subtask |
| 9 | Commit รวมใหญ่ | Review ยาก | Commit Atomic |
| 10 | ไม่บันทึก Decision | ลืมเหตุผล | Decision Log |

---

## 10.16 Best Practices

### 10.16.1 Do's

- ✅ Brainstorm ก่อนทุก Task ใหม่
- ✅ Plan ก่อน Execute
- ✅ Scrutinize ก่อน Merge (บังคับ)
- ✅ Test ทุก Subtask
- ✅ Commit Atomic
- ✅ บันทึก Decision Log
- ✅ อ่านและเข้าใจ Code ที่ AI สร้าง
- ✅ ให้ Context ครบ
- ✅ ใช้ AI เป็นคู่คิด ไม่ใช่ Auto-Coder
- ✅ วัดผลด้วย KPI

### 10.16.2 Don'ts

- ❌ ข้าม Scrutinize
- ❌ Merge โดยไม่เข้าใจ
- ❌ ใช้ AI กับ Production โดยตรง
- ❌ Commit Secrets
- ❌ ใช้ Library ที่ไม่ตรวจสอบ
- ❌ ปล่อยให้ AI ตัดสินใจสุดท้าย
- ❌ ทำ Task ใหญ่ในครั้งเดียว
- ❌ ไม่เขียน Test
- ❌ ไม่บันทึก Plan
- ❌ Over-engineered

---

## 10.17 ตัวอย่าง End-to-End (ครบ Workflow)

### 10.17.1 Scenario: เพิ่ม API POST /employee

**Step 1: รับ Task**

```
จาก PO: "เพิ่ม API สำหรับสร้างพนักงานใหม่"
```

**Step 2: /tb-brainstorming**

```
Input:
- Task: เพิ่ม POST /employee
- Context: Python, FastAPI, MongoDB
- Business Rules: Email unique, full_name required

Output:
- 6 Assumptions
- 4 Questions
- Scope (In/Out)
- 3 Risks
```

**Step 3: ยืนยัน Assumptions กับ PO**

```
Developer: "id เป็น UUID v4 ใช่ไหม?"
PO: "ใช่"
Developer: "Email case-sensitive ไหม?"
PO: "ไม่ — ต้อง case-insensitive"
```

**Step 4: /tb-writing-plans**

```
Output:
- 5 Decisions
- 5 Subtasks
- Test Strategy
- DoD
- 3 Risks + Mitigation
```

**Step 5: /tb-executing-plans (ทีละ Subtask)**

```
Subtask 1: Model → Commit "feat: add employee model"
Subtask 2: Repository → Commit "feat: add employee repository"
Subtask 3: Service → Commit "feat: add employee service"
Subtask 4: Router → Commit "feat: add POST /employee endpoint"
Subtask 5: Migration → Commit "feat: add unique index on email"
```

**Step 6: /tb-scrutinize**

```
Result: ⚠️ PASS WITH CONDITIONS
Issues:
- #1 Email case-sensitive (High)
- #2 Email with space (Medium)
- #3 Concurrent duplicate (High)

Action: Fix ทั้ง 3 ก่อน Merge
```

**Step 7: Fix + Scrutinize อีกครั้ง**

```
Result: ✅ PASS

Action: Merge
```

**Step 8: PR + Code Review**

```
Reviewer: Approved (1)
CI: Passed
Merge: Squash & Merge
```

**Step 9: Deploy + Monitor**

```
Deploy: Staging → Prod
Monitor: 24 ชั่วโมง
```

**Step 10: Retrospective**

```
What went well:
- Brainstorm จับ Assumption ผิดได้ 1 ตัว
- Scrutinize จับ Bug ได้ 3 ตัวก่อน Merge

What to improve:
- Plan ยาวเกินไป (5 Subtasks ใน 1 วัน)
- ควร Commit ถี่กว่านี้
```

---

## 10.18 Glossary

| คำ | ความหมาย |
|----|----------|
| **AI-Assisted** | การพัฒนาที่ใช้ AI ช่วย |
| **Assumption** | สิ่งที่สมมติว่าจริง (ต้องยืนยัน) |
| **Context** | ข้อมูลที่ให้ AI |
| **Decision Log** | บันทึกการตัดสินใจ |
| **Defect Leakage** | บั๊กที่หลุดถึง Prod |
| **DoD** | Definition of Done |
| **Fallback** | แผนสำรองเมื่อ AI ผิด |
| **Greenfield** | Feature ใหม่ทั้งหมด |
| **Hallucination** | AI สร้างข้อมูลที่ไม่มีจริง |
| **Legacy Code** | Code เก่าที่มีอยู่ |
| **Prompt** | คำสั่งที่ให้ AI |
| **Rework** | งานที่ต้องแก้ |
| **Scrutinize** | การตรวจสอบอย่างละเอียด |
| **Subtask** | งานย่อย |
| **tb-*** | Prefix ของ Skills |
| **TDD** | Test-Driven Development |

---

## 10.19 ความเชื่อมโยงกับเล่มอื่น

| เล่ม | ความเชื่อมโยงกับเล่ม 10 |
|------|-------------------------|
| **เล่ม 1 (PO/BA)** | User Story ที่ AI ช่วย Implement |
| **เล่ม 2 (Full-Stack)** | Coding Standards ที่ AI ต้องทำตาม |
| **เล่ม 3 (Architect)** | ADR ที่ AI ต้องอ้างอิง |
| **เล่ม 4 (QA)** | Test ที่ AI สร้าง + Scrutinize |
| **เล่ม 6 (Reviewer)** | Scrutinize เป็น Pre-check ก่อน Code Review |
| **เล่ม 12 (CI/CD)** | Pipeline ที่ AI-Assisted Code ต้องผ่าน |
| **เล่ม 13 (RCA)** | /tb-investigate-error เชื่อมกับ RCA |
| **เล่ม 14 (Security)** | Scrutinize ตรวจ Security |

---

## 10.20 สรุปสาระสำคัญ (Key Takeaways)

```text
┌─────────────────────────────────────────────────────────────┐
│              AI-ASSISTED DEVELOPMENT                        │
│                     KEY TAKEAWAYS                           │
└─────────────────────────────────────────────────────────────┘

  1. AI เป็นคู่คิด ไม่ใช่ Auto-Coder — Developer ตัดสินใจสุดท้าย
  2. Brainstorm ก่อนทุก Task — ลด Misunderstanding
  3. Plan ก่อน Execute — ลด Rework
  4. Execute ทีละ Subtask + Test — ลด Bug
  5. Scrutinize ก่อน Merge — บังคับทุกครั้ง
  6. Investigate ก่อน Fix Bug — หา Root Cause
  7. TDD สำหรับ Bug จุดเดียว — Red → Green → Refactor
  8. Context ครบ — AI ตอบตรง
  9. Fallback เมื่อ AI ผิด — ระบุ, เพิ่ม Context, ลองใหม่
  10. วัดผลด้วย KPI — Rework, Defect, Time to First PR
  11. Git Workflow — Commit Atomic, PR Template
  12. อย่า Merge โดยไม่เข้าใจ — ต้องเข้าใจทุกบรรทัด
```

---
 