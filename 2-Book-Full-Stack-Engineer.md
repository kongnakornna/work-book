# 📘 เล่ม 2: คู่มือ Full-Stack Engineer (Frontend + Backend + Python)
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
- [8. Frontend Standards (React / TypeScript)](#8-frontend-standards-react--typescript)
- [9. Backend Standards (Python / FastAPI)](#9-backend-standards-python--fastapi)
- [10. Testing Standards](#10-testing-standards)
- [11. Definition of Done (DoD) และข้อห้าม](#11-definition-of-done-dod-และข้อห้าม)
- [12. Case Study](#12-case-study)
- [13. KPI & SMART Criteria](#13-kpi--smart-criteria)
- [14. คู่มือการทดสอบ (Developer Test & UAT Support)](#14-คู่มือการทดสอบ-developer-test--uat-support)
- [15. คู่มือการใช้งานสำหรับ Developer (Developer Guide)](#15-คู่มือการใช้งานสำหรับ-developer-developer-guide)
- [16. คู่มือการบำรุงรักษา (Maintenance Guide)](#16-คู่มือการบำรุงรักษา-maintenance-guide)
- [17. คู่มือการขยาย/แก้ไข (Extension Guide)](#17-คู่มือการขยายแก้ไข-extension-guide)
- [18. Code Review & PR Checklist](#18-code-review--pr-checklist)
- [19. Root Cause Analysis (RCA)](#19-root-cause-analysis-rca)
- [20. ภาคผนวก: คำศัพท์สองภาษา และเอกสารอ้างอิง](#20-ภาคผนวก-คำศัพท์สองภาษา-และเอกสารอ้างอิง)

---

# 1. บทนำ (Introduction)

## 1.1 ภาพรวมคืออะไร (What is it?)

คู่มือนี้สำหรับ **Full-Stack Engineer** ในทีม **Financial & Accounting Technology Solutions — ** ที่รับผิดชอบพัฒนาระบบตั้งแต่ Frontend (React/TypeScript) → Backend API (Node.js/Python/FastAPI) → Database → Integration → Deployment → Production Support

เป้าหมายคือสร้างมาตรฐานการพัฒนาโค้ดที่มีคุณภาพ มีความปลอดภัย ทดสอบได้ และบำรุงรักษาได้ในระยะยาว สำหรับระบบการเงินและบัญชีที่มีความ sensitive สูง

## 1.2 คำนำ (Preface)

ระบบ FinTech & Accounting มีความซับซ้อนและผลกระทบสูง:

- ข้อมูลการเงินผิดเพียงรายการเดียวอาจกระทบการปิดบัญชี
- Integration กับ Oracle ERP / Databricks / Power BI ต้องมี Idempotency และ Reconciliation
- ผู้ใช้เป็นทีม Finance/Accounting ที่ต้องการความถูกต้องและ Audit Trail
- Compliance เช่น SOX, PDPA, ISO 27001 ต้องถูกออกแบบตั้งแต่ต้น

Full-Stack Engineer จึงต้องไม่ใช่แค่ “เขียนโค้ดให้รันได้” แต่ต้องเข้าใจ **Business Logic**, **Data Integrity**, **Security**, **Observability**, และ **Maintainability**

## 1.3 วัตถุประสงค์ (Objectives)

1. กำหนดมาตรฐานการพัฒนา Full-Stack ของทีม
2. ลด Defect และ Rework จากโค้ดที่ไม่มีมาตรฐาน
3. ทำให้ Code Review และ Onboarding มีประสิทธิภาพ
4. สร้างวัฒนธรรม Test-Driven และ Security-First
5. รองรับ AI-Assisted Development ผ่าน `/tb-*` Skills อย่างมีวินัย

## 1.4 เป้าหมาย (Goals)

- Unit Test Coverage ≥ 80% ใน Critical Modules
- Defect Leakage < 5%
- Rework Rate < 10%
- CI Pipeline Pass Rate ≥ 95%
- Time to First PR ≤ 1 วัน
- MTTR ≤ 30 นาทีสำหรับ Incident ที่เกี่ยวกับโค้ด

---

# 2. บทนิยาม (Definitions)

| คำ | ความหมาย |
|----|----------|
| **Full-Stack Engineer** | Developer ที่ทำงานได้ทั้ง Frontend, Backend, Database, Integration และ Deployment |
| **Clean Architecture** | การแยกชั้น Handler → Service → Repository เพื่อลด Coupling |
| **DTO** | Data Transfer Object ใช้ส่งข้อมูลระหว่างชั้น |
| **Idempotency** | คุณสมบัติที่ทำให้ request ซ้ำไม่สร้างข้อมูลซ้ำ |
| **Retry with Backoff** | การลองใหม่แบบเว้นระยะเพิ่มขึ้นเมื่อเกิด failure ชั่วคราว |
| **Reconciliation** | การกระทบยอดข้อมูลระหว่างสองระบบ |
| **Observability** | ความสามารถในการสังเกตระบบผ่าน Log, Metric, Trace |
| **Feature Flag** | สวิตช์เปิด/ปิดฟีเจอร์โดยไม่ต้อง deploy ใหม่ |
| **DoD** | Definition of Done — เงื่อนไขว่างานเสร็จสมบูรณ์ |
| **Scrutinize Gate** | ด่านตรวจ Logic และ Side Effects ก่อน Merge ผ่าน `/tb-scrutinize` |

---

# 3. บทบาทและความรับผิดชอบ (Roles & Responsibilities)

## 3.1 Role Matrix

| กิจกรรม | Full-Stack Dev | Architect | QA | DevOps | Reviewer | PO/BA |
|---------|----------------|-----------|----|--------|----------|-------|
| อ่านและ Clarify Requirement | **R** | C | C | I | I | **R** |
| ออกแบบ Technical Solution | **R** | **A** | C | C | C | C |
| เขียน Frontend | **R** | C | I | I | C | I |
| เขียน Backend API | **R** | C | I | I | C | I |
| เขียน Unit/Integration Test | **R** | I | C | I | C | I |
| CI/CD Pipeline | C | C | I | **R** | I | I |
| Code Review | C | C | I | I | **R** | C |
| Deploy Staging | C | I | I | **R** | I | I |
| Production Support | **R** | C | I | **R** | I | I |
| Incident Fix | **R** | C | C | C | C | I |
| Documentation | **R** | C | C | C | C | C |

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
## 3.2 ความรับผิดชอบหลัก

1. แปลง User Story + Acceptance Criteria เป็น Implementation Plan
2. พัฒนา Frontend/Backend ตาม Standards
3. เขียน Test ให้ครอบคลุม Critical Paths
4. รักษา API Contract และ Documentation
5. ดูแล Observability ในโค้ดที่ตนเองเขียน
6. แก้ Defect และ Incident ตาม SLA
7. ไม่ Commit Secrets และไม่ข้าม CI

---

# 4. ความรู้พื้นฐานที่ต้องมี (Prerequisites)

| ด้าน | ความรู้ที่ต้องมี |
|------|------------------|
| Frontend | React, TypeScript, Hooks, State Management, Accessibility, Testing Library |
| Backend | Python, FastAPI, Pydantic, Async/Await, REST, OpenAPI |
| Database | SQL, Index, Migration, Transaction, MongoDB basics |
| Integration | HTTP, Retry, Idempotency, Circuit Breaker, Reconciliation |
| Security | OWASP Top 10, SSO/RBAC, Secrets Management |
| DevOps | Git Flow, Docker, CI/CD, Kubernetes basics |
| Observability | Structured Logging, Metrics, Tracing |
| AI-Assisted | `/tb-brainstorming`, `/tb-writing-plans`, `/tb-executing-plans`, `/tb-scrutinize` |

---

# 5. โครงสร้างการทำงาน (Team Structure)

```text
┌─────────────────────────────────────────────────────────────┐
│              FULL-STACK TEAM STRUCTURE                      │
└─────────────────────────────────────────────────────────────┘

        ┌──────────────┐
        │ Architect    │  System Design / ADR
        └──────┬───────┘
               │
     ┌─────────┼─────────┐
     ▼         ▼         ▼
┌─────────┐ ┌─────────┐ ┌─────────┐
│ FE Dev  │ │ BE Dev  │ │ Full-Stack│
│ React/TS│ │ Python  │ │ Engineer │
└────┬────┘ └────┬────┘ └────┬────┘
     │           │           │
     └───────────┼───────────┘
                 ▼
        ┌─────────────────┐
        │ QA / DevOps / PO│
        └─────────────────┘
```

## 5.1 การสื่อสาร

| กิจกรรม | ความถี่ | ผู้เข้าร่วม |
|---------|---------|------------|
| Daily Standup | ทุกวัน | Dev, QA, PO |
| Backlog Grooming | สัปดาห์/ครั้ง | PO, BA, Dev, QA |
| Sprint Planning | 2 สัปดาห์/ครั้ง | ทีมทั้งหมด |
| Technical Design Review | ตามงาน | Dev, Architect, QA |
| Code Review | ทุก PR | Reviewer |
| Incident Review | ตามเหตุการณ์ | Dev, DevOps, On-call |

---

# 6. หลักการทำงาน (Concept)

## 6.1 หลักการ 6 ประการของ Full-Stack Engineer

1. **Correctness First** — ถูกต้องก่อนสวยงาม
2. **Test before Merge** — ไม่มี Test = ไม่มี Merge
3. **Secure by Default** — Validate input, No Secrets, Least Privilege
4. **Observable by Design** — Log, Metric, Trace ตั้งแต่ต้น
5. **Small PR, Fast Feedback** — PR เล็ก Review ง่าย
6. **Document Decisions** — API Contract, ADR, README อัปเดต

## 6.2 AI-Assisted Development Workflow

```text
Story Task
   │
   ▼
/tb-brainstorming      ทำความเข้าใจ + หา Assumption
   │
   ▼
/tb-writing-plans      แตก Subtask + Decision Log
   │
   ▼
/tb-executing-plans    Implement + Test
   │
   ▼
/tb-scrutinize         MANDATORY GATE ตรวจ Logic + Side Effects
   │
   ▼
PR + Code Review + CI
   │
   ▼
Merge + Deploy + Monitor
```

## 6.3 Bug Fix Workflow

```text
/tb-investigate-error
   │
   ├── Path A: แก้หลายจุด → /tb-writing-plans → /tb-executing-plans
   │
   └── Path B: แก้จุดเดียว → /tb-test-driven-development
   │
   ▼
/tb-scrutinize (MANDATORY)
   │
   ▼
PR + Review + Deploy
```

---

# 7. Workflow และ Dataflow

## 7.1 Development Workflow

```text
1. รับ Story + AC
2. /tb-brainstorming
3. /tb-writing-plans
4. สร้าง Branch ตาม Git Flow
5. Implement Frontend + Backend + Test
6. Run Local Test + Lint + Type Check
7. /tb-scrutinize
8. เปิด PR + แนบ Test Evidence
9. Code Review + CI ผ่าน
10. Merge → Deploy Staging
11. Monitor + UAT Support
```

## 7.2 Dataflow ตัวอย่าง: POST /employee

```text
[React Form]
    │  POST /employee (JSON)
    ▼
[FastAPI Router]
    │  Validate Pydantic
    ▼
[EmployeeService]
    │  Business Rule: email ห้ามซ้ำ
    ▼
[EmployeeRepository]
    │  Insert
    ▼
[Database]
    │  Return saved entity
    ▼
[Service → DTO]
    │
    ▼
[Response 201 Created]
```

---

# 8. Frontend Standards (React / TypeScript)

## 8.1 โครงสร้าง Component

```typescript
// components/EmployeeForm/EmployeeForm.tsx
import { useState } from 'react';
import type { EmployeeCreateRequest } from '@/types/employee';

interface EmployeeFormProps {
  onSubmit: (data: EmployeeCreateRequest) => Promise<void>;
  isLoading?: boolean;
}

export function EmployeeForm({ onSubmit, isLoading = false }: EmployeeFormProps) {
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    try {
      await onSubmit({ full_name: fullName, email });
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error');
    }
  };

  return (
    <form onSubmit={handleSubmit} aria-label="Employee form">
      <label htmlFor="fullName">Full Name</label>
      <input
        id="fullName"
        value={fullName}
        onChange={(e) => setFullName(e.target.value)}
        required
        aria-invalid={!!error}
      />

      <label htmlFor="email">Email</label>
      <input
        id="email"
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
      />

      {error && <p role="alert">{error}</p>}

      <button type="submit" disabled={isLoading}>
        {isLoading ? 'Saving...' : 'Save'}
      </button>
    </form>
  );
}
```

## 8.2 Frontend Checklist

- [ ] Component Reusable + Typed
- [ ] State Management คาดเดาได้
- [ ] Loading / Empty / Error States ครบ
- [ ] Accessibility: Label, ARIA, Keyboard Navigation
- [ ] Responsive Design
- [ ] Unit Test ด้วย Vitest / Testing Library
- [ ] ไม่มี `any` โดยไม่จำเป็น
- [ ] ไม่มี Hardcoded Secrets
- [ ] Error Message เป็นมิตรกับผู้ใช้
- [ ] ไม่ Re-render เกินจำเป็น

## 8.3 Frontend Testing ตัวอย่าง

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
```

---

# 9. Backend Standards (Python / FastAPI)

## 9.1 โครงสร้าง Folder

```bash
pms/
├── api/
│   ├── main.py
│   └── modules/employee/
│       ├── router.py
│       ├── schemas.py
│       └── router_test.py
└── pkg/employee/
    ├── models.py
    ├── repository.py
    ├── service.py
    ├── service_test.py
    └── mocks/
```

## 9.2 Service (Clean Architecture)

```python
# pkg/employee/service.py
from datetime import datetime
from pkg.employee.models import Employee, EmployeeCreate, EmployeeDTO
from pkg.employee.repository import EmployeeRepository


class EmailTakenError(Exception):
    pass


class ValidationError(Exception):
    pass


class EmployeeService:
    def __init__(self, repo: EmployeeRepository) -> None:
        self.repo = repo

    async def create(self, payload: EmployeeCreate) -> EmployeeDTO:
        if not payload.full_name or not payload.full_name.strip():
            raise ValidationError("full_name is required")

        if await self.repo.find_by_email(payload.email) is not None:
            raise EmailTakenError("email already exists")

        now = datetime.utcnow()
        employee = Employee(
            full_name=payload.full_name.strip(),
            email=payload.email,
            created_at=now,
            updated_at=now,
        )
        saved = await self.repo.save(employee)
        return EmployeeDTO(**saved.model_dump())
```

## 9.3 Router + Error Mapping

```python
# api/modules/employee/router.py
from fastapi import APIRouter, HTTPException, status
from pkg.employee.models import EmployeeCreate, EmployeeDTO
from pkg.employee.service import EmployeeService, EmailTakenError, ValidationError

router = APIRouter(prefix="/employee", tags=["employee"])


@router.post("", response_model=EmployeeDTO, status_code=status.HTTP_201_CREATED)
async def create_employee(payload: EmployeeCreate) -> EmployeeDTO:
    service = EmployeeService(repo=...)
    try:
        return await service.create(payload)
    except ValidationError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except EmailTakenError as exc:
        raise HTTPException(status_code=409, detail=str(exc)) from exc
```

## 9.4 Backend Checklist

- [ ] Clean Architecture: Router → Service → Repository
- [ ] Pydantic Validation ครบ
- [ ] Async/Await สำหรับ I/O Bound
- [ ] API Contract (OpenAPI) อัปเดต
- [ ] Error Handling 400/401/403/404/409/500
- [ ] Unit Test Coverage ≥ 80%
- [ ] Structured Logging ไม่มี PII/Secrets
- [ ] Transaction ถูกต้อง
- [ ] Idempotency สำหรับ Endpoint ที่เสี่ยงซ้ำ
- [ ] Authorization Check ทุก Endpoint ที่ต้องป้องกัน

## 9.5 Integration Standards

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
                },
            )
            resp.raise_for_status()
            return resp.json()
```

**ข้อกำหนด Integration:**

- ต้องมี Idempotency-Key สำหรับ POST ที่สร้างข้อมูล
- ต้องมี Retry with Exponential Backoff
- ต้องมี Timeout
- ต้องมี Circuit Breaker เมื่อเหมาะสม
- ต้องมี Reconciliation Job สำหรับข้อมูลสำคัญ
- ต้อง Log correlation_id / request_id

---

# 10. Testing Standards

## 10.1 Testing Pyramid

```text
        ┌─────────────┐
        │  E2E Tests  │  ~10%
        ├─────────────┤
        │ Integration │  ~20%
        ├─────────────┤
        │  Unit Tests │  ~70%
        └─────────────┘
```

## 10.2 Coverage Target

| ระดับ | Target |
|-------|--------|
| Unit Test | ≥ 80% Critical Modules |
| Integration Test | Critical Paths ครบ |
| E2E Test | User Journeys หลัก |
| Security Scan | ทุก Release |

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

## 10.4 Commands

```bash
# Frontend
npm test -- --coverage
npm run lint
npm run typecheck

# Backend
pytest --cov=pkg --cov-report=term-missing
ruff check .
mypy pkg/
```

---

# 11. Definition of Done (DoD) และข้อห้าม

## 11.1 Definition of Done

- [ ] Code ผ่าน Lint + Type Check
- [ ] Unit Test Coverage ≥ 80%
- [ ] Integration Test ผ่าน
- [ ] Code Review Approve ≥ 1
- [ ] CI Pipeline ผ่าน
- [ ] Documentation / API Contract อัปเดต
- [ ] Deploy บน Staging ได้
- [ ] Observability พร้อม
- [ ] ไม่มี Secrets ในโค้ด
- [ ] ผ่าน `/tb-scrutinize`

## 11.2 ข้อห้าม (Prohibitions)

- ❌ Commit Secrets ลง Git
- ❌ Deploy โดยไม่มี Code Review
- ❌ Hardcode Password / API Key
- ❌ ข้าม CI Pipeline
- ❌ แก้ Production โดยตรง
- ❌ Merge โดยไม่มี Test
- ❌ ใช้ `any` แบบหลีกเลี่ยง Type Safety โดยไม่จำเป็น
- ❌ Log PII / Secrets
- ❌ เขียน SQL แบบต่อ String จนเสี่ยง Injection
- ❌ เปิด Endpoint โดยไม่มี Authorization Check

---

# 12. Case Study

## Case Study 1: POST /employee — เพิ่มข้อมูลพนักงาน

### 12.1.1 Requirement

- full_name required
- email required และห้ามซ้ำ
- id เป็น UUID v4 อัตโนมัติ
- created_at = updated_at ตอน Create
- Duplicate email → HTTP 409

### 12.1.2 Implementation Plan

1. สร้าง Pydantic Models
2. สร้าง Repository
3. สร้าง Service + Business Rules
4. สร้าง Router + Error Mapping
5. เขียน Unit Test + Integration Test
6. Run `/tb-scrutinize`
7. เปิด PR

### 12.1.3 Acceptance Criteria Mapping

| AC | Test Case |
|----|-----------|
| Create สำเร็จ | `test_create_employee_success` |
| full_name ว่าง | `test_create_employee_empty_name` |
| email ว่าง | `test_create_employee_empty_email` |
| email ซ้ำ | `test_create_employee_duplicate_email` |
| id เป็น UUID | assert UUID format |
| created_at = updated_at | assert equality |

### 12.1.4 KPI

| KPI | Target |
|-----|--------|
| Coverage | ≥ 80% |
| API Response Time | ≤ 300 ms |
| Defect Leakage | < 5% |
| Rework Rate | < 10% |

---

## Case Study 2: Payment Reconciliation — Auto Match

### 12.2.1 Technical Scope

- Import Bank Statement (CSV/API)
- Auto Match Payment กับ Bank Statement
- Manual Review รายการ Unmatched
- Audit Trail
- Export Journal Entry to Oracle ERP

### 12.2.2 Data Model

| Table | Field หลัก |
|-------|-----------|
| `bank_statement` | id, bank_account, statement_date, amount, reference, imported_at |
| `payment` | id, payment_date, amount, currency, reference, status |
| `reconciliation` | id, payment_id, bank_statement_id, match_rule, matched_at, matched_by, status |
| `reconciliation_log` | id, action, actor, timestamp, detail |

### 12.2.3 Integration Rules

- Import ต้องมี Duplicate Detection
- Auto Match ต้องบันทึก `match_rule`
- Export ERP ต้องมี Idempotency-Key
- ทุก Action ต้องมี Audit Trail

### 12.2.4 Test Strategy

- Unit Test: Matching Rules
- Integration Test: Import → Match → Review
- E2E Test: User Journey กระทบยอด
- Performance Test: Import 10,000 รายการ ≤ 5 นาที

---

## Case Study 3: Oracle ERP Sync

### 12.3.1 Technical Scope

- Sync Payment ไป Oracle ERP
- Retry with Backoff
- Idempotency
- Daily Reconciliation

### 12.3.2 Acceptance Criteria ตัวอย่าง

```markdown
### AC-1: Sync สำเร็จ
- Given Payment ถูก approve
- When ระบบส่งไป Oracle ERP
- Then ERP ตอบ success และบันทึก erp_reference

### AC-2: ป้องกันข้อมูลซ้ำ
- Given ระบบ retry ด้วย Idempotency-Key เดิม
- When ERP ได้รับ request ซ้ำ
- Then ERP ต้องไม่สร้างรายการซ้ำ

### AC-3: ERP ล่ม
- Given Oracle ERP ไม่ตอบสนอง
- When ระบบส่งข้อมูล
- Then Retry 3 ครั้ง แล้วเข้าสถานะ Pending Sync
```

---

# 13. KPI & SMART Criteria

## 13.1 KPI หลักของ Full-Stack Engineer

| KPI | เป้าหมาย | วิธีวัด |
|-----|----------|---------|
| Unit Test Coverage | ≥ 80% | Coverage Report |
| CI Pass Rate | ≥ 95% | CI Dashboard |
| Rework Rate | < 10% | PR ที่ต้องแก้หลัง Review |
| Defect Leakage | < 5% | Defect ที่พบหลัง Release |
| Time to First PR | ≤ 1 วัน | วัดจากเริ่ม Task ถึง PR แรก |
| Review Turnaround | ≤ 24 ชั่วโมง | วัดจาก PR เปิดถึง Approve |
| Scrutinize Pass Rate | ≥ 95% | ผ่าน Gate ครั้งแรก |

## 13.2 SMART ตัวอย่าง

| SMART | รายละเอียด |
|-------|-----------|
| **S** | เพิ่ม Unit Test Coverage ของ Module Employee |
| **M** | ≥ 80% |
| **A** | เขียน Test ควบคู่กับ Implementation |
| **R** | ลด Defect ใน Module สำคัญ |
| **T** | ภายใน Sprint ถัดไป |

---

# 14. คู่มือการทดสอบ (Developer Test & UAT Support)

## 14.1 ก่อนส่งงานให้ QA

- [ ] รัน Unit Test ผ่าน
- [ ] รัน Integration Test ผ่าน
- [ ] Lint ผ่าน
- [ ] Type Check ผ่าน
- [ ] ทดสอบ Manual บน Local
- [ ] Deploy Staging สำเร็จ
- [ ] แนบ Test Evidence ใน PR

## 14.2 การสนับสนุน UAT

- เตรียม Test Data
- อธิบาย Behavior ให้ Key User
- แก้ Defect ภายใน SLA
- อัปเดต Staging ตามรอบ
- บันทึก Known Issues

## 14.3 Defect Fix Workflow

```text
รับ Defect
   │
   ▼
/tb-investigate-error
   │
   ▼
Reproduce + เขียน Test ที่ Fail
   │
   ▼
แก้ไข + Test ผ่าน
   │
   ▼
/tb-scrutinize
   │
   ▼
PR + Review + Deploy Staging
   │
   ▼
แจ้ง QA Retest
```

---

# 15. คู่มือการใช้งานสำหรับ Developer (Developer Guide)

## 15.1 Local Setup

```bash
# Frontend
cd frontend
npm install
npm run dev

# Backend
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn api.main:app --reload
```

## 15.2 Branch Naming

```text
feature/PMS-101-add-employee-api
bugfix/PMS-202-fix-null-email
refactor/PMS-404-clean-auth-service
hotfix/v1.0.1-fix-payment-timeout
```

## 15.3 Commit Message

```text
feat(employee): add POST /employee endpoint

- Auto-generate UUID for id
- Validate full_name and email
- Reject duplicate email with 409 Conflict

Closes: #PMS-101
```

## 15.4 Daily Checklist

- [ ] Pull Latest Develop
- [ ] อัปเดต Branch
- [ ] รัน Test ก่อน Commit
- [ ] ไม่ Commit Secrets
- [ ] อัปเดต PR Status
- [ ] ตอบ Review Comment ภายใน 24 ชั่วโมง

---

# 16. คู่มือการบำรุงรักษา (Maintenance Guide)

## 16.1 Dependency Updates

- ตรวจ Dependabot / Renovate ทุกสัปดาห์
- อัปเดต Patch Version ก่อน
- ทดสอบ Regression ก่อน Merge
- หลีกเลี่ยง Major Upgrade โดยไม่มี Plan

## 16.2 Database Migration

- ใช้ Migration Tool
- ห้ามแก้ Schema บน Production โดยตรง
- ต้องมี Backup ก่อน Migrate
- ต้องมี Rollback Plan
- Dry-run บน Staging ก่อน

## 16.3 Logging & Monitoring

- ใช้ Structured Logging
- ใส่ `request_id`, `user_id` (ไม่ใช่ PII)
- หลีกเลี่ยง Log ข้อมูลบัตร/Payment Sensitive
- ตั้ง Alert สำหรับ Error Rate และ Latency

## 16.4 Feature Flags

- ใช้สำหรับฟีเจอร์เสี่ยง
- ตั้งชื่อชัดเจน
- มี Owner และวันหมดอายุ
- ลบ Flag ที่ไม่ใช้แล้ว

---

# 17. คู่มือการขยาย/แก้ไข (Extension Guide)

## 17.1 การเพิ่ม Module ใหม่

1. สร้าง Folder ตาม Clean Architecture
2. สร้าง Models / DTOs
3. สร้าง Repository
4. สร้าง Service + Business Rules
5. สร้าง Router
6. เขียน Test
7. อัปเดต API Contract
8. ผ่าน `/tb-scrutinize`
9. PR + Review

## 17.2 การเพิ่ม Endpoint ใหม่

- ระบุ HTTP Method + Path
- ระบุ Request/Response Schema
- ระบุ Error Codes
- ระบุ Authorization
- ระบุ Rate Limit (ถ้าจำเป็น)
- เขียน Test ทุก AC

## 17.3 การเพิ่ม Integration ใหม่

- ระบุ System Boundary
- ระบุ Data Contract
- ระบุ Idempotency / Retry / Timeout
- ระบุ Reconciliation
- ระบุ Observability
- ให้ Architect Review

## 17.4 Governance

- การเพิ่ม Dependency ต้องผ่าน Review
- การเปลี่ยน API Contract ต้องแจ้ง PO/BA
- การเปลี่ยน Schema ต้องมี Migration
- การเปลี่ยน Security ต้องผ่าน Security Review

---

# 18. Code Review & PR Checklist

## 18.1 PR Template

```markdown
# Pull Request: [ชื่อ]

**Ticket:** [Link]
**Type:** [Feature/Bugfix/Refactor/Chore]
**Priority:** [P0/P1/P2/P3]

## What
[อธิบายสิ่งที่เปลี่ยน]

## Why
[เหตุผล]

## How
[วิธีที่ใช้]

## Test Plan
- [ ] Unit Test ผ่าน
- [ ] Integration Test ผ่าน
- [ ] Manual Test บน Staging

## Risks & Rollback Plan
[ความเสี่ยงและวิธี Rollback]

## Checklist
- [ ] Code follows style guide
- [ ] Tests pass
- [ ] Documentation updated
- [ ] No secrets committed
- [ ] ผ่าน /tb-scrutinize
```

## 18.2 Developer Self-Review Checklist

- [ ] โค้ดอ่านง่าย ตั้งชื่อสื่อความหมาย
- [ ] ไม่มี Dead Code
- [ ] ไม่มีโค้ดซ้ำ (DRY)
- [ ] Handle Edge Cases ครบ
- [ ] Error Handling ครบ
- [ ] Unit Test ครอบคลุม
- [ ] ไม่มี Secrets
- [ ] Input Validation ครบ
- [ ] Authorization Check ครบ
- [ ] Query มี Index เหมาะสม
- [ ] Frontend ไม่ Re-render เกินจำเป็น
- [ ] API Contract อัปเดต
- [ ] Documentation อัปเดต

## 18.3 สิ่งที่ Reviewer จะตรวจ

1. ความถูกต้องตาม Requirement
2. Edge Cases
3. Security
4. Readability
5. DRY
6. Performance
7. Style / Architecture
8. Tests
9. Observability
10. Documentation

---

# 19. Root Cause Analysis (RCA)

## 19.1 ตัวอย่าง RCA: ข้อมูล Payment ซ้ำใน Oracle ERP

### Problem
Payment ถูกสร้างซ้ำใน Oracle ERP ระหว่างช่วง Network Timeout

### 5 Whys

1. **Why?** — ระบบ Retry หลัง Timeout
2. **Why?** — ไม่มี Idempotency-Key ใน Request
3. **Why?** — API Contract ไม่ได้ออกแบบรองรับ Retry
4. **Why?** — ขาด Design Review สำหรับ Integration
5. **Why?** — ไม่มี Checklist บังคับสำหรับ Integration Design

### Root Cause
ขาด Checklist และ Design Review สำหรับ Integration ที่ต้องรองรับ Retry

### Corrective Action
- ลบรายการซ้ำใน ERP
- เพิ่ม Idempotency-Key ใน Client

### Preventive Action
- เพิ่ม Integration Checklist ใน DoD
- บังคับ Architect Review สำหรับ Integration ใหม่
- เพิ่ม Reconciliation Job ตรวจข้อมูลซ้ำรายวัน

## 19.2 RCA Checklist สำหรับ Developer

- [ ] มี Timeline
- [ ] มี Log / Metric / Trace
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
| สถาปัตยกรรมสะอาด | Clean Architecture | แยกชั้น Handler/Service/Repository |
| วัตถุส่งข้อมูล | DTO | Data Transfer Object |
| การป้องกันข้อมูลซ้ำ | Idempotency | Request ซ้ำไม่สร้างข้อมูลซ้ำ |
| การลองใหม่ | Retry | ลองส่งซ้ำเมื่อล้มเหลว |
| การกระทบยอด | Reconciliation | ตรวจเทียบข้อมูลสองแหล่ง |
| ความสามารถในการสังเกต | Observability | Log/Metric/Trace |
| ธงฟีเจอร์ | Feature Flag | เปิด/ปิดฟีเจอร์ |
| สัญญา API | API Contract | ข้อตกลงการเชื่อมต่อ |
| การตรวจทานโค้ด | Code Review | ตรวจคุณภาพโค้ด |
| การวิเคราะห์สาเหตุราก | RCA | หาสาเหตุที่แท้จริง |

## 20.2 เอกสารอ้างอิง

- Complete Multi-Role Work Manuals — FinTech & Accounting Technology Solutions
- เล่ม 1: คู่มือ Product Owner / Business Analyst
- เล่ม 3: คู่มือ Solution Architect / Tech Lead
- เล่ม 4: คู่มือ QA / Test Engineer
- เล่ม 5: คู่มือ DevOps / Platform Engineer
- เล่ม 6: คู่มือ Code Reviewer
- เล่ม 10: คู่มือ AI-Assisted Development (`tb-*` Skills)
- เล่ม 12: คู่มือ CI/CD & Git Flow
- เล่ม 13: คู่มือ RCA
- เล่ม 14: คู่มือ Security & Compliance

---

# ✅ ภาคผนวกท้ายเล่ม: Full-Stack Daily Checklist

## ก่อนเริ่มงาน
- [ ] อ่าน Story + AC ครบ
- [ ] ผ่าน `/tb-brainstorming`
- [ ] มี Plan / Subtask
- [ ] สร้าง Branch ถูกต้อง

## ระหว่างพัฒนา
- [ ] เขียน Test ควบคู่
- [ ] รัน Lint + Type Check
- [ ] ไม่ Commit Secrets
- [ ] อัปเดต API Contract

## ก่อนเปิด PR
- [ ] Test ผ่านทั้งหมด
- [ ] Coverage ≥ 80%
- [ ] ผ่าน `/tb-scrutinize`
- [ ] แนบ Test Evidence
- [ ] มี Rollback Plan

## หลัง Merge
- [ ] Deploy Staging สำเร็จ
- [ ] Monitor Log/Metric
- [ ] แจ้ง QA / PO
- [ ] อัปเดต Documentation

---

**จบเล่ม 2: คู่มือ Full-Stack Engineer (Frontend + Backend + Python) —  Financial & Accounting Technology Solutions**

> หมายเหตุ: เอกสารนี้เป็น **Living Document** ควรทบทวนทุกไตรมาส โดยมี Owner ชัดเจน และปรับปรุงตามการเปลี่ยนแปลงของ Technology Stack และ Business Requirement

--- 