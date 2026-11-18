# 📚 ERPIoT Developer Handbook

> **เวอร์ชัน:** 1.0
> **อัปเดตล่าสุด:** 2026-10-01
> **กลุ่มเป้าหมาย:** Backend Developer, DevOps, SRE, QA

---

## สารบัญ

1. [บทนำและภาพรวมโครงการ](#1-บทนำและภาพรวมโครงการ)
2. [สถาปัตยกรรมระบบ](#2-สถาปัตยกรรมระบบ)
3. [โครงสร้าง Modules](#3-โครงสร้าง-modules)
4. [มาตรฐานการพัฒนา](#4-มาตรฐานการพัฒนา-development-standards)
5. [ขั้นตอนการทำงาน](#5-ขั้นตอนการทำงาน-workflow)
6. [คู่มือการติดตั้งและตั้งค่า](#6-คู่มือการติดตั้งและตั้งค่า)
7. [คู่มือการพัฒนา Module](#7-คู่มือการพัฒนา-module)
8. [คู่มือการทดสอบ](#8-คู่มือการทดสอบ)
9. [คู่มือการ Deploy](#9-คู่มือการ-deploy)
10. [คู่มือการ Operations](#10-คู่มือการ-operations)
11. [คู่มือการแก้ปัญหา](#11-คู่มือการแก้ปัญหา-troubleshooting)
12. [Templates และ Checklists](#12-templates-และ-checklists)
13. [ภาคผนวก](#13-ภาคผนวก)

---

## 1. บทนำและภาพรวมโครงการ

### 1.1 วัตถุประสงค์

**ERPIoT** คือ Python FastAPI backend template ที่ออกแบบตามหลัก **Clean Architecture** และ **Domain-Driven Design (DDD)** ครอบคลุม:

- Modular scaffolding สำหรับเริ่มโปรเจกต์ใหม่
- Dependency management + Docker support
- Testing boilerplate + CI/CD-friendly setup
- Best practices ที่ยั่งยืนสำหรับ maintainability

### 1.2 โดเมนของระบบ

| Module | หน้าที่ | Tier |
|--------|--------|------|
| **Authentication** | Login / Refresh / Logout (JWT JWE) | public |
| **User** | ข้อมูลผู้ใช้ + auto-register | public / user |
| **Key** | API Key สำหรับ service-to-service | admin |
| **Knowledge** | Knowledge base + broadcast notification | manager |
| **Notification** | แจ้งเตือนรายบุคคล + broadcast | user |
| **Health** | Liveness + Alembic version | public / admin |
| **WebSocket** | Real-time notification | authenticated |
| **Example** | Scaffolding reference | public |

### 1.3 เทคโนโลยีหลัก

| Layer | Technology |
|-------|-----------|
| **Framework** | FastAPI |
| **Language** | Python 3.11+ |
| **Database** | PostgreSQL (SQLAlchemy 2.x async + Alembic) |
| **Cache** | Redis (async) |
| **Auth** | JWT (JWE + JWS EdDSA), API Key HMAC-SHA256 |
| **Hashing** | pwdlib (Argon2 recommended) |
| **Logging** | Loguru |
| **Validation** | Pydantic v2 |
| **Testing** | pytest + pytest-asyncio |
| **Container** | Docker + Docker Compose |

### 1.4 Convention สำคัญ

- **Table prefix:** `erp_` (กำหนดใน `settings.APPLICATION_TABLE_PREFIX`)
- **PK ของ user:** BIGINT 11+ หลัก (Identity start 10_000_000_000)
- **PK ของ key/authentication:** UUID
- **Timezone:** BRASILIA_TZ (สำหรับ resolve_expires_at)
- **Enum ใน DB:** ใช้ **member name** (uppercase) ไม่ใช่ `.value` (lowercase)

---

## 2. สถาปัตยกรรมระบบ

### 2.1 Layered Architecture

```
┌───────────────────────────────────────────────────────────┐
│                    Presentation Layer                     │
│  routers.py · schemas.py · docs.py · dependencies.py      │
├───────────────────────────────────────────────────────────┤
│                    Application Layer                      │
│  use_cases.py · mappers.py · interfaces.py · exceptions  │
├───────────────────────────────────────────────────────────┤
│                      Domain Layer                         │
│         entities.py · enums.py · value_objects.py         │
│                  (ไม่มี external dependency)              │
├───────────────────────────────────────────────────────────┤
│                  Infrastructure Layer                     │
│   models.py · repositories.py · caches.py · services.py   │
└───────────────────────────────────────────────────────────┘
```

### 2.2 Dependency Rule

```
Presentation  ──▶  Application  ──▶  Domain
      │                 │              ▲
      │                 │              │
      └────▶ Infrastructure ──────────┘
                (implements interfaces)
```

**กฎ:**
- Domain **ห้าม** import อะไรจาก layer อื่น
- Application **ห้าม** import infrastructure ตรง ๆ → ใช้ interface (Protocol)
- Infrastructure implements interface ที่ประกาศใน application
- Presentation wire ทุกอย่างผ่าน `dependencies.py`

### 2.3 Request Flow (ตัวอย่าง: Create API Key)

```
POST /api/v1/key/
  │
  ▼
[FastAPI Router]  routers.py :: create()
  │
  ├─▶ Depends(authenticate_admin)     ← app/core/security.py
  │        │
  │        └─▶ decode_nested_access_token
  │             │
  │             └─▶ cache.get_by_access_token / repository
  │
  ├─▶ Depends(get_key_use_cases)      ← presentation/dependencies.py
  │
  ├─▶ create_entity_mapper(payload, auth)   ← application/mappers.py
  │
  ├─▶ KeyUseCases.create(key)
  │        │
  │        ├─▶ KeyService.generate(key)      → สร้าง plain_key + hashed_key
  │        ├─▶ KeyRepository.create(key)     → INSERT
  │        └─▶ (plain_key ถูก attach กลับเข้า entity)
  │
  ├─▶ entity_create_mapper(response)  ← application/mappers.py
  │
  ▼
[FastAPI Response]  CreateKeyResponse(api_key=...)
```

### 2.4 Cache-aside Pattern (API Key)

```
_resolve_api_key(plain_key)
  │
  ├─ fingerprint = HMAC(secret, "api-key:" + plain_key)
  ├─ cache.get_by_hashed_key(fingerprint)
  │     │
  │     └─ MISS
  │          │
  │          ├─ repository.get_key_by_hashed_key(fingerprint)
  │          │
  │          └─ เจอ → background_tasks.add_task(cache.insert, db_key)
  │
  └─ verify + is_active + expires_at
```

### 2.5 Tombstone Pattern (กัน race ตอน revoke)

ปัญหาที่แก้: cache miss → อ่าน DB → concurrent revoke ลบ cache → insert ตามหลัง

```
DELETE:
  1. set tombstone (TTL สั้น)
  2. delete entry จริง

INSERT:
  1. if tombstone exists: return (skip write)
  2. set entry
```

---

## 3. โครงสร้าง Modules

### 3.1 โครงสร้าง Root

```
erpiot/
├── app/
│   ├── core/                      # Cross-cutting concerns
│   │   ├── cache.py              # get_cache_session
│   │   ├── database.py           # get_async_session
│   │   ├── security.py           # JWT + API Key + hash
│   │   └── settings.py           # Settings, PathRule
│   │
│   └── modules/
│       ├── authentication/
│       ├── key/
│       ├── user/
│       ├── knowledge/
│       ├── notification/
│       ├── health/
│       ├── websocket/
│       ├── example/
│       └── shared/               # Shared kernel
│
├── alembic/                      # migrations
├── tests/                        # pytest
├── docker/                       # Dockerfiles
├── docker-compose.yml
├── pyproject.toml
├── .env.example
└── README.md
```

### 3.2 โครงสร้าง Module มาตรฐาน

```
app/modules/<module>/
├── domain/                       # Business rules (ไม่มี external dep)
│   ├── entities.py               # Entity + List + Pagination
│   ├── enums.py                  # Enums เฉพาะ module
│   └── value_objects.py          # VO (ถ้ามี)
│
├── application/                  # Use cases + interfaces
│   ├── exceptions.py             # Exception เฉพาะ module
│   ├── interfaces.py             # Repository / Cache / Service Protocol
│   ├── mappers.py                # entity ↔ model ↔ cache ↔ dto
│   ├── use_cases.py              # Business orchestration
│   └── utils.py                  # (ถ้ามี)
│
├── infrastructure/               # Adapters to external world
│   ├── models.py                 # SQLAlchemy models
│   ├── repositories.py           # Postgres implementation
│   ├── caches.py                 # Redis implementation
│   └── services.py               # Domain services
│
└── presentation/                 # HTTP entry point
    ├── dependencies.py           # DI wiring
    ├── docs.py                   # OpenAPI examples
    ├── routers.py                # APIRouter + endpoints
    └── schemas.py                # Pydantic request/response
```

### 3.3 Shared Kernel (`app/modules/shared/`)

| Layer | ไฟล์ | มีอะไร |
|-------|------|--------|
| domain | `entities.py` | BaseEntity, DomainError, DomainErrors, PaginatedList, Pagination |
| domain | `enums.py` | Role, SortOrder, ResponseMessages |
| domain | `value_objects.py` | RESOURCE_NAME_PATTERN, UNSET, Name |
| application | `exceptions.py` | StandardException, DomainException |
| application | `utils.py` | BRASILIA_TZ |
| presentation | `schemas.py` | StandardResponse, PaginationMeta, DeleteResponse, UpdateResponse |

---

## 4. มาตรฐานการพัฒนา (Development Standards)

### 4.1 Coding Conventions

| หัวข้อ | มาตรฐาน |
|--------|---------|
| **Python version** | 3.11+ |
| **Type hints** | บังคับทุก function signature |
| **`from __future__ import annotations`** | ทุกไฟล์ |
| **Formatter** | Ruff (หรือ Black) |
| **Linter** | Ruff |
| **Type checker** | mypy (strict mode) |
| **Line length** | 88 (default) |
| **Naming** | `snake_case` ฟังก์ชัน, `PascalCase` class, `UPPER_SNAKE` constant |
| **Docstrings** | Google style สำหรับ public API |

### 4.2 Naming Convention ของ Layer

| ประเภท | Pattern | ตัวอย่าง |
|--------|---------|---------|
| Entity | `<Name>` | `Key`, `User` |
| List entity | `<Name>List` | `KeyList` |
| Pagination | `<Name>Pagination` | `KeyPagination` |
| Interface | `I<Name><Type>` | `IKeyRepository`, `IKeyCache` |
| Use case | `<Name>UseCases` | `KeyUseCases` |
| Exception (generic) | `<Module>Exception` | `KeyException` |
| Exception (specific) | `<Reason>Exception` | `KeyNotFoundException` |
| Mapper (in) | `create_entity_mapper` | request → entity |
| Mapper (out) | `entity_create_mapper` | entity → response |
| Repository | `Postgres<Name>Repository` | `PostgresKeyRepository` |
| Cache | `Redis<Name>Cache` | `RedisKeyCache` |
| Service | `<Name>Service` | `KeyService` |
| Router | `<verb>` function | `create`, `get_all`, `update` |
| Schema Request | `<Verb>Request` | `CreateRequest` |
| Schema Response | `<Verb>Response` | `CreateKeyResponse` |

### 4.3 Import Order

```python
# 1. __future__
from __future__ import annotations

# 2. Standard library
import json
from datetime import datetime

# 3. Third-party
from fastapi import APIRouter
from loguru import logger
from sqlalchemy import select

# 4. Local — เรียงตาม layer
from app.core.settings import settings
from app.modules.key.application.exceptions import KeyException
from app.modules.key.domain.entities import Key
```

### 4.4 Exception Hierarchy

```
StandardException (base)
├── DomainException          (จาก DomainError)
├── AuthenticationException
│   ├── AuthenticationTokenException
│   │   ├── AuthenticationTokenExpiredException
│   │   ├── AuthenticationTokenInvalidException
│   │   └── AuthenticationTokenMalformedError
│   ├── RefreshTokenException
│   └── UserHasNotPermissionException    ← 403
└── KeyException
    ├── KeyNotFoundException              ← 404
    ├── KeyNotModifiedException           ← 400
    ├── ApiKeyNotProvidedException        ← 401
    ├── ApiKeyInvalidException            ← 401
    ├── ApiKeyRevokedException            ← 401
    └── ApiKeyExpiredException            ← 401
```

### 4.5 Try/Except Pattern (บังคับ)

```python
async def some_use_case(...):
    try:
        # business logic
        ...
    except StandardException:
        raise                              # ← ปล่อยผ่าน
    except DomainError as e:
        raise DomainException(e)           # ← แปลง domain → application
    except Exception as e:
        logger.opt(exception=e).error("...")
        raise <Module>Exception()          # ← กลืน + re-raise generic
```

### 4.6 Logging Convention

```python
# Debug: เข้า/ออก use case
logger.debug(f"Initializing create key use case for key '{key.name}'.")

# Info: business event สำคัญ
logger.info(f"Api key '{key.id}' created successfully by user {user.id}.")

# Warning: non-fatal + ต้องตามต่อ
logger.warning(f"Cache delete failed: {type(e).__name__}.")

# Error: fatal + ต้อง log exception
logger.opt(exception=e).error("An unexpected error occurred.")
```

### 4.7 UNSET vs None (สำคัญมาก)

| ค่า | ความหมาย | ใช้ที่ไหน |
|-----|----------|----------|
| `UNSET` | "ไม่ได้ส่งมา" | PATCH request, mapper merge |
| `None` | "ส่ง null มา" (ล้างค่า) | field ที่ nullable |

```python
# UpdateRequest mapper
name=payload.name if "name" in payload.model_fields_set else UNSET,
description=payload.description if "description" in payload.model_fields_set else UNSET,
```

ใน use case:
```python
merged = Key(
    name=key.name if key.name is not UNSET else existing.name,
    description=key.description if key.description is not UNSET else existing.description,
)
```

---

## 5. ขั้นตอนการทำงาน (Workflow)

### 5.1 Git Branching

```
main ─────────●────────●────────●───────▶  (production)
              ▲        ▲        ▲
              │        │        │
release/*  ───┘        │        │
                       │        │
develop ────●───●───●──┴───●────┴──────▶  (integration)
            ▲   ▲
            │   │
feature/* ──┘   └── feature/*
```

| Branch | ใช้ทำอะไร | Merge ไป |
|--------|-----------|----------|
| `main` | Production-ready | — |
| `develop` | Integration | `main` (ผ่าน release) |
| `feature/<ticket>-<slug>` | พัฒนาฟีเจอร์ | `develop` |
| `hotfix/<ticket>-<slug>` | แก้บั๊ก production | `main` + `develop` |
| `release/<version>` | เตรียม release | `main` |

### 5.2 Commit Message (Conventional Commits)

```
<type>(<scope>): <subject>

<body>

<footer>
```

| Type | ใช้เมื่อ |
|------|---------|
| `feat` | ฟีเจอร์ใหม่ |
| `fix` | แก้บั๊ก |
| `refactor` | เปลี่ยนโครงสร้างโดยไม่เปลี่ยน behavior |
| `perf` | ปรับ performance |
| `test` | เพิ่ม/แก้ test |
| `docs` | เอกสาร |
| `chore` | build, deps, config |
| `style` | format ไม่กระทบ logic |

**ตัวอย่าง:**
```
feat(key): add rotate endpoint for API key secret

- Add PATCH /api/v1/key/{id}/rotate/
- Invalidate cache before rotate to prevent stale auth
- Return new secret exactly once

Closes #123
```

### 5.3 Pull Request Flow

```
1. สร้าง branch จาก develop
2. เขียน code + test
3. Run: ruff check / mypy / pytest
4. Push + เปิด PR
5. CI ผ่าน + review 1+ คน
6. Squash & merge → develop
7. ลบ branch
```

### 5.4 Definition of Done (DoD)

- [ ] Code ผ่าน linter + type checker
- [ ] Test ใหม่ครอบคลุม use case
- [ ] Coverage ไม่ลดลง
- [ ] Docs (OpenAPI examples) อัปเดต
- [ ] PR review ผ่าน 1+ คน
- [ ] CI green
- [ ] ไม่มี TODO ค้างในโค้ดที่ merge

---

## 6. คู่มือการติดตั้งและตั้งค่า

### 6.1 ความต้องการของระบบ

| Component | Version |
|-----------|---------|
| Python | 3.11+ |
| PostgreSQL | 14+ |
| Redis | 6+ |
| Docker | 20.10+ (ถ้าใช้) |
| Docker Compose | v2 |

### 6.2 ติดตั้ง Local

```bash
# 1. Clone
git clone <repo-url> erpiot && cd erpiot

# 2. Virtual env
python -m venv .venv
source .venv/bin/activate       # Linux/macOS
# .venv\Scripts\activate        # Windows

# 3. Deps
pip install -e ".[dev]"

# 4. Env
cp .env.example .env
# → แก้ค่าใน .env (ดูหัวข้อ 6.3)

# 5. Database
createdb erpiot
alembic upgrade head

# 6. Run
uvicorn app.main:app --reload --port 8000
```

### 6.3 ตัวแปรสภาพแวดล้อมสำคัญ

```dotenv
# ─── Application ────────────────────────
APPLICATION_URL=http://localhost:8000
APPLICATION_TABLE_PREFIX=erp

# ─── Database ───────────────────────────
DATABASE_URL=postgresql+asyncpg://user:pass@localhost:5432/erpiot

# ─── Redis ──────────────────────────────
REDIS_URL=redis://localhost:6379/0
REDIS_NAMESPACE=erpiot
REDIS_DEFAULT_TTL_SECONDS=300
REDIS_SESSION_TTL_SECONDS=3600
REDIS_TOMBSTONE_TTL_SECONDS=60

# ─── JWT ────────────────────────────────
JWT_ISSUER=erpiot
JWT_AUDIENCE=erpiot-clients
JWT_HASH_FINGERPRINT=<hex-secret>
JWT_SIGNING_PRIVATE_KEY=<ed25519-pem>
JWT_SIGNING_PUBLIC_KEY=<ed25519-pem>
JWT_ENCRYPTION_PRIVATE_KEY=<ecdh-pem>
JWT_ENCRYPTION_PUBLIC_KEY=<ecdh-pem>

# ─── Cookies ────────────────────────────
COOKIES_ACCESS_TOKEN_KEY=access_token
COOKIES_REFRESH_TOKEN_KEY=refresh_token
COOKIES_DEVICE_KEY=device_id

# ─── API Key ────────────────────────────
API_KEY_PREFIX=iap
API_KEY_ENTROPY_BYTES=32
API_KEY_HASH_FINGERPRINT=<hex-secret>
AUTH_API_KEY_NAME=X-API-Key
AUTH_API_KEY_SCHEME_NAME=ApiKeyAuth
AUTH_API_KEY_DESCRIPTION=API key for service-to-service authentication

# ─── Security ───────────────────────────
SECURITY_ADMIN_EMAIL=admin@admin.com
SECURITY_ADMIN_PASSWORD=<strong-password>
SECURITY_EMAIL_ALLOWED_DOMAINS=["admin.com"]
SECURITY_ALLOW_ORIGINS=["http://localhost:3000"]

# Path allowlists (tuple ของ PathRule)
SECURITY_NO_AUTH_PATHS=[...]
SECURITY_USER_ALLOWED_PATHS=[...]
SECURITY_MANAGER_ALLOWED_PATHS=[...]
SECURITY_ADMIN_ALLOWED_PATHS=[...]
SECURITY_API_KEY_ALLOWED_PATHS=[...]
```

### 6.4 สร้าง JWT Keys

```bash
# Ed25519 signing key
openssl genpkey -algorithm ED25519 -out jwt_signing.pem
openssl pkey -in jwt_signing.pem -pubout -out jwt_signing.pub.pem

# ECDH encryption key
openssl ecparam -name prime256v1 -genkey -noout -out jwt_encryption.pem
openssl ec -in jwt_encryption.pem -pubout -out jwt_encryption.pub.pem

# Fingerprint (HMAC key)
openssl rand -hex 32
```

### 6.5 Docker Compose

```yaml
version: "3.9"
services:
  api:
    build:
      context: .
      dockerfile: docker/Dockerfile
    ports: ["8000:8000"]
    env_file: .env
    depends_on:
      db:    { condition: service_healthy }
      cache: { condition: service_healthy }
    volumes:
      - ./app:/app/app

  db:
    image: postgres:16
    environment:
      POSTGRES_DB: erpiot
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user"]
      interval: 5s
    volumes:
      - pgdata:/var/lib/postgresql/data

  cache:
    image: redis:7
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s

volumes:
  pgdata:
```

---

## 7. คู่มือการพัฒนา Module

### 7.1 Checklist สร้าง Module ใหม่

ใช้ pattern เดียวกับ Key module — ทำตามลำดับ:

#### Step 1: Domain Layer

```python
# app/modules/<name>/domain/enums.py
from enum import Enum

class <Name>Status(str, Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"

# app/modules/<name>/domain/entities.py
from __future__ import annotations
from dataclasses import dataclass, field

from app.modules.shared.domain.entities import (
    BaseEntity, DomainErrors, PaginatedList, Pagination,
)
from app.modules.shared.domain.value_objects import UNSET

@dataclass(kw_only=True, slots=True)
class <Name>(BaseEntity):
    name: str = field(default=None, repr=True, compare=True)
    description: str | None = field(default=UNSET, repr=False, compare=False)

    def __post_init__(self):
        errors: list[str] = []
        # validation
        if errors:
            raise DomainErrors(errors)

@dataclass(kw_only=True, slots=True)
class <Name>List(PaginatedList):
    items: list[<Name>] = field(default_factory=list)

@dataclass(kw_only=True, slots=True)
class <Name>Pagination(Pagination):
    pass
```

#### Step 2: Application Layer — Interfaces

```python
# app/modules/<name>/application/interfaces.py
from typing import Protocol
from app.modules.<name>.domain.entities import <Name>, <Name>List, <Name>Pagination

class I<Name>Repository(Protocol):
    async def create(self, entity: <Name>) -> <Name>: ...
    async def get_by_id(self, entity: <Name>) -> <Name> | None: ...
    async def get_all(self, entity: <Name>, pagination: <Name>Pagination) -> <Name>List: ...
    async def update(self, entity: <Name>) -> <Name>: ...

class I<Name>Cache(Protocol):
    async def insert(self, entity: <Name>, ttl: int | None = None) -> None: ...
    async def delete(self, entity: <Name>) -> None: ...
```

#### Step 3: Application Layer — Exceptions

```python
# app/modules/<name>/application/exceptions.py
from http import HTTPStatus
from app.modules.shared.application.exceptions import StandardException
from app.modules.shared.domain.enums import ResponseMessages

class <Name>Exception(StandardException):
    def __init__(self) -> None:
        super().__init__(
            status_code=HTTPStatus.INTERNAL_SERVER_ERROR,
            message=ResponseMessages.INTERNAL_ERROR.value,
            data={"errors": "An unexpected error occurred..."},
        )

class <Name>NotFoundException(StandardException):
    def __init__(self, id: str) -> None:
        super().__init__(
            status_code=HTTPStatus.NOT_FOUND,
            message=ResponseMessages.RESOURCE_NOT_FOUND.value,
            data={"errors": f"<Name> with id '{id}' not found."},
        )
```

#### Step 4: Infrastructure — Model

```python
# app/modules/<name>/infrastructure/models.py
from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column
from app.core.settings import settings
from app.modules.shared.infrastructure.models import BaseModel

class <Name>Model(BaseModel):
    __tablename__ = f"{settings.APPLICATION_TABLE_PREFIX}_<names>"
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
```

#### Step 5: Infrastructure — Repository

```python
# app/modules/<name>/infrastructure/repositories.py
class Postgres<Name>Repository(I<Name>Repository):
    def __init__(self, session: AsyncSession) -> None:
        self.session = session

    async def create(self, entity: <Name>) -> <Name>:
        try:
            ...
        except StandardException:
            raise
        except Exception as e:
            logger.opt(exception=e).error("...")
            raise <Name>Exception()
```

#### Step 6: Presentation — Schemas

```python
# app/modules/<name>/presentation/schemas.py
class CreateRequest(BaseModel):
    name: str = Field(..., min_length=3, max_length=255)
    description: str | None = Field(default=None, max_length=1000)

    model_config = ConfigDict(
        extra="forbid",
        str_strip_whitespace=True,
    )

class Create<Name>Response(BaseModel):
    id: UUID
    name: str
    ...
```

#### Step 7: Presentation — Dependencies

```python
# app/modules/<name>/presentation/dependencies.py
def get_<name>_repository(
    session: Annotated[AsyncSession, Depends(get_async_session)],
) -> I<Name>Repository:
    return Postgres<Name>Repository(session=session)

def get_<name>_use_cases(
    repository: Annotated[I<Name>Repository, Depends(get_<name>_repository)],
    ...
) -> <Name>UseCases:
    return <Name>UseCases(repository=repository, ...)
```

#### Step 8: Presentation — Router

```python
# app/modules/<name>/presentation/routers.py
router = APIRouter(**router_docs)

@router.post("/", **create_docs)
@router.post("", include_in_schema=False)
async def create(
    payload: CreateRequest,
    authentication: Annotated[Authentication, Depends(authenticate_admin)],
    use_case: Annotated[<Name>UseCases, Depends(get_<name>_use_cases)],
) -> Create<Name>Response:
    try:
        request_domain = create_entity_mapper(payload, authentication)
        response_domain = await use_case.create(request_domain)
        output = entity_create_mapper(response_domain)
        return output
    except StandardException:
        raise
    except DomainError as e:
        raise DomainException(e)
    except Exception as e:
        logger.opt(exception=e).error("...")
        raise <Name>Exception()
```

#### Step 9: Register Router

```python
# app/main.py
from app.modules.<name>.presentation.routers import router as <name>_router

app.include_router(<name>_router)
```

#### Step 10: Migration

```bash
alembic revision --autogenerate -m "add <name> table"
alembic upgrade head
```

---

## 8. คู่มือการทดสอบ

### 8.1 โครงสร้าง Tests

```
tests/
├── conftest.py                # fixtures กลาง
├── unit/                      # unit tests (no DB)
│   ├── key/
│   │   ├── test_entities.py
│   │   ├── test_mappers.py
│   │   └── test_use_cases.py
│   └── shared/
├── integration/               # ใช้ test DB + Redis
│   ├── key/
│   │   ├── test_repository.py
│   │   └── test_cache.py
│   └── authentication/
└── e2e/                       # ผ่าน HTTP
    ├── test_key_endpoints.py
    └── test_auth_flow.py
```

### 8.2 Fixtures ตัวอย่าง

```python
# tests/conftest.py
import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

@pytest.fixture
async def session() -> AsyncSession:
    async with async_session_maker() as s:
        yield s
        await s.rollback()

@pytest.fixture
async def client(app) -> AsyncClient:
    async with AsyncClient(app=app, base_url="http://test") as c:
        yield c

@pytest.fixture
async def admin_client(client, admin_credentials) -> AsyncClient:
    await client.post("/api/v1/authentication/login/", data=admin_credentials)
    return client
```

### 8.3 ตัวอย่าง Test

```python
# tests/unit/key/test_entities.py
import pytest
from app.modules.key.domain.entities import Key
from app.modules.shared.domain.entities import DomainErrors

class TestKeyEntity:
    def test_name_is_normalized(self):
        key = Key(name="  ci   pipeline  ")
        assert key.name == "Ci pipeline"

    def test_name_too_short_raises(self):
        with pytest.raises(DomainErrors):
            Key(name="ab")

# tests/e2e/test_key_endpoints.py
import pytest

@pytest.mark.asyncio
async def test_create_key_returns_secret(admin_client):
    response = await admin_client.post("/api/v1/key/", json={
        "name": "Test key",
        "expires_in": "30_days",
    })
    assert response.status_code == 201
    data = response.json()["details"]["data"]
    assert data["api_key"].startswith("iap_")

@pytest.mark.asyncio
async def test_non_admin_gets_403(user_client):
    response = await user_client.post("/api/v1/key/", json={...})
    assert response.status_code == 403
```

### 8.4 Coverage

```bash
pytest --cov=app --cov-report=html --cov-report=term-missing
```

**เป้าหมาย:**
- Domain layer: ≥ 95%
- Application layer: ≥ 90%
- Infrastructure layer: ≥ 80%
- Presentation layer: ≥ 75%

### 8.5 Running Tests

```bash
# ทั้งหมด
pytest

# Unit only
pytest tests/unit -v

# Single file
pytest tests/unit/key/test_entities.py -v

# Single test
pytest tests/unit/key/test_entities.py::TestKeyEntity::test_name_is_normalized -v

# Markers
pytest -m "not slow"
pytest -m integration
```

---

## 9. คู่มือการ Deploy

### 9.1 Docker Build

```dockerfile
# docker/Dockerfile
FROM python:3.11-slim AS builder
WORKDIR /app
COPY pyproject.toml .
RUN pip install --no-cache-dir -e "."

FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY . .
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

```bash
docker build -t erpiot:latest -f docker/Dockerfile .
```

### 9.2 Environment Matrix

| Env | Database | Redis | Replicas | Auto-scale |
|-----|----------|-------|----------|-----------|
| **dev** | shared | shared | 1 | ❌ |
| **staging** | dedicated | dedicated | 2 | ❌ |
| **prod** | HA cluster | HA cluster | 3+ | ✅ |

### 9.3 Pre-Deploy Checklist

- [ ] CI green (tests + lint + type check)
- [ ] Migration ผ่านบน staging
- [ ] `.env` ใหม่พร้อมใน secret manager
- [ ] Backup DB ก่อน deploy
- [ ] Rollback plan พร้อม
- [ ] Feature flags ตั้งค่าถูกต้อง

### 9.4 Deploy Steps

```bash
# 1. Migration (รันก่อน deploy code)
kubectl exec -it deploy/erpiot-api -- alembic upgrade head

# 2. Rolling update
kubectl set image deploy/erpiot-api api=erpiot:v1.2.3

# 3. Watch rollout
kubectl rollout status deploy/erpiot-api

# 4. Smoke test
curl -f https://api.example.com/health/
```

### 9.5 Rollback

```bash
# Rollback image
kubectl rollout undo deploy/erpiot-api

# Rollback migration (ถ้าจำเป็น)
alembic downgrade -1
```

---

## 10. คู่มือการ Operations

### 10.1 Health Checks

| Endpoint | ใช้ทำ | ตรวจอะไร |
|----------|-------|----------|
| `GET /health/` | Liveness | process ตอบ |
| `GET /api/v1/alembic-version/` | Readiness (admin) | schema version |

### 10.2 Monitoring Metrics

| Metric | แหล่ง | Threshold |
|--------|-------|-----------|
| Request rate | FastAPI middleware | — |
| Error rate (5xx) | logs | < 1% |
| p95 latency | APM | < 500ms |
| DB pool utilization | SQLAlchemy | < 80% |
| Redis hit rate | cache | > 90% |
| API key auth failures | logs | baseline ±3σ |

### 10.3 Log Aggregation

**Structured log pattern (Loguru):**

```
2026-10-01T07:02:13.394Z | INFO  | app.modules.key.presentation.routers:create:45 | Api key 'CI pipeline' created by user 10000000001.
```

**Query ตัวอย่าง (Loki / CloudWatch):**

```logql
{app="erpiot"} |= "ERROR" | json | level="ERROR"
{app="erpiot"} |= "ApiKeyExpiredException" | rate(5m)
```

### 10.4 Cache Invalidation

```bash
# Key cache
redis-cli KEYS "erpiot:key:hashed_key:*" | xargs redis-cli DEL

# ทั้งหมดของ namespace
redis-cli --scan --pattern "erpiot:*" | xargs redis-cli DEL
```

### 10.5 Backup

| Resource | ความถี่ | Retention |
|----------|---------|-----------|
| PostgreSQL | Daily full + WAL | 30 วัน |
| Redis | ไม่ backup (ephemeral) | — |
| Secrets | Change-triggered | ตลอด |

### 10.6 Capacity Planning

| ตัวชี้วัด | Baseline | Scale trigger |
|----------|---------|---------------|
| CPU | 40% | > 70% |
| Memory | 60% | > 80% |
| DB connections | 30% pool | > 70% pool |
| Request queue | < 5 | > 20 |

---

## 11. คู่มือการแก้ปัญหา (Troubleshooting)

### 11.1 Decision Tree — HTTP Error

```
401 Unauthorized
  │
  ├─ "API key was not provided" → ไม่มี header `X-API-Key`
  ├─ "Invalid API key" → hash ไม่เจอใน DB
  ├─ "revoked" → `is_active = false`
  └─ "expired" → `expires_at < now`
      │
      └─ ตรวจ: SELECT expires_at FROM erp_keys WHERE hashed_key = '...'

403 Forbidden
  │
  ├─ [authenticate_admin] permission != Role.ADMIN
  │      │
  │      └─ SELECT role FROM erp_users WHERE id = <user_id>
  │
  └─ [authenticate_admin] path rule ไม่ผ่าน
         │
         └─ ตรวจ settings.SECURITY_ADMIN_ALLOWED_PATHS
            ให้มี entry: {method: POST, endpoint: "/api/v1/key"}

404 Not Found
  │
  └─ SELECT id, is_active FROM erp_keys WHERE id = '<uuid>'
        │
        └─ ถ้า is_active=false → ถือเป็น "not found"

500 Internal Server Error
  │
  ├─ ดู log ระดับ ERROR
  ├─ ตรวจ DB connection pool
  └─ ตรวจ Redis connection
```

### 11.2 ปัญหาที่พบบ่อย

#### ❌ `403 Forbidden` ตอนเรียก `POST /api/v1/key/`

**สาเหตุที่เป็นไปได้:**
1. User ที่ login **ไม่ใช่ admin** (role != `Role.ADMIN`)
2. Path ไม่อยู่ใน `SECURITY_ADMIN_ALLOWED_PATHS`
3. Token เก่า (ออกก่อน promote role)

**วินิจฉัย:**
```sql
SELECT id, email, role FROM erp_users WHERE email = '<อีเมล login>';
```
- ถ้า `role != 'ADMIN'` → grant role แล้ว **login ใหม่**
- ถ้า `role = 'ADMIN'` → ตรวจ path allowlist ใน `settings.py`

#### ❌ `ValueError: badly formed hexadecimal UUID string` ใน cache

**สาเหตุ:** `cache_entity_mapper` พยายาม `UUID("10000000001")` — user id เป็น BIGINT

**แก้:**
```python
# app/modules/key/application/mappers.py
# BEFORE
created_by=User(id=UUID(data["created_by"])) if data["created_by"] else None,

# AFTER
created_by=User(id=int(data["created_by"])) if data["created_by"] else None,
```

#### ❌ `InvalidTextRepresentation` ตอน migrate

**สาเหตุ:** `server_default` ใช้ `.value` (lowercase) แทน `.name` (uppercase)

**แก้:**
```python
# ✅ ถูก
server_default=Role.USER.name    # → 'USER'

# ❌ ผิด
server_default=Role.USER.value   # → 'user'
```

#### ❌ Cache hit แล้วได้ข้อมูลเก่าหลัง revoke

**สาเหตุ:** tombstone TTL สั้นเกินไป หรือ insert เขียนหลัง tombstone หมดอายุ

**แก้:**
- เพิ่ม `REDIS_TOMBSTONE_TTL_SECONDS`
- ตรวจว่า `delete()` เขียน tombstone **ก่อน** `del` entry

#### ❌ Refresh token ถูก reject

**สาเหตุ:**
1. Cookie หมดอายุ
2. Device cookie หาย
3. Token ถูก revoke ใน DB

**วินิจฉัย:**
```python
# ดู log ที่มี "[DEBUG-REFRESH #N]"
logger.debug(
    f"[DEBUG-REFRESH #{i}] user_id={authentication.user.id} "
    f"device={device!r} user_agent={user_agent!r} "
    f"hashed_jti={authentication.refresh_token.hashed_jti}"
)
```

### 11.3 Useful Queries

```sql
-- หา API key ที่ใกล้หมดอายุ
SELECT id, name, expires_at
FROM erp_keys
WHERE is_active = TRUE
  AND expires_at IS NOT NULL
  AND expires_at < now() + interval '7 days'
ORDER BY expires_at;

-- หา key ที่ไม่เคยถูกใช้
SELECT id, name, created_at
FROM erp_keys
WHERE is_active = TRUE
  AND last_used_at IS NULL
  AND created_at < now() - interval '30 days';

-- ดู user + role
SELECT id, email, role, status
FROM erp_users
WHERE email = '<email>';
```

### 11.4 Log Search Patterns

```bash
# Error ทั้งหมดใน 1 ชั่วโมงล่าสุด
grep '"level":"ERROR"' app.log | tail -n 100

# เฉพาะ key module
grep 'app.modules.key' app.log | grep 'ERROR'

# Trace request id (ถ้ามี)
grep '<request_id>' app.log
```

---

## 12. Templates และ Checklists

### 12.1 Template — สร้าง Module ใหม่

```markdown
## Module: <name>

### Domain
- [ ] entities.py: <Name>, <Name>List, <Name>Pagination
- [ ] enums.py: enum ที่จำเป็น
- [ ] Validation ใน `__post_init__`

### Application
- [ ] interfaces.py: I<Name>Repository, I<Name>Cache
- [ ] exceptions.py: <Name>Exception + specific
- [ ] mappers.py: create/get/update/delete mappers
- [ ] use_cases.py: <Name>UseCases

### Infrastructure
- [ ] models.py: <Name>Model (FK BIGINT)
- [ ] repositories.py: Postgres<Name>Repository
- [ ] caches.py: Redis<Name>Cache (ถ้ามี)
- [ ] services.py: <Name>Service (ถ้ามี)

### Presentation
- [ ] dependencies.py: DI wires
- [ ] schemas.py: Request + Response
- [ ] docs.py: OpenAPI examples
- [ ] routers.py: 6 endpoints (CRUD)

### Integration
- [ ] Register router ใน app/main.py
- [ ] Alembic migration
- [ ] เพิ่ม path rules ใน settings
- [ ] Tests: unit + e2e
```

### 12.2 Template — Create Endpoint

```python
@router.post("/", **create_docs)
@router.post("", include_in_schema=False)
async def create(
    payload: CreateRequest,
    authentication: Annotated[Authentication, Depends(authenticate_admin)],
    use_case: Annotated[<Name>UseCases, Depends(get_<name>_use_cases)],
) -> Create<Name>Response:
    try:
        request_domain = create_entity_mapper(payload, authentication)
        response_domain = await use_case.create(request_domain)
        output = entity_create_mapper(response_domain)
        return output
    except StandardException:
        raise
    except DomainError as e:
        raise DomainException(e)
    except Exception as e:
        logger.opt(exception=e).error("An error occurred in create endpoint.")
        raise <Name>Exception()
```

### 12.3 Template — Exception

```python
class <Reason>Exception(StandardException):
    def __init__(self, <params>) -> None:
        super().__init__(
            status_code=HTTPStatus.<CODE>,
            message=ResponseMessages.<MESSAGE>.value,
            data={"errors": "<f-string message>"},
        )
```

### 12.4 Template — Mapper

```python
# IN (request → entity)
def create_entity_mapper(payload: CreateRequest, authentication: Authentication) -> <Name>:
    return mapper.to(<Name>).map(
        payload,
        fields_mapping={
            "field1": payload.field1,
            "created_by": authentication.user,
        },
    )

# OUT (entity → response)
def entity_create_mapper(entity: <Name>) -> Create<Name>Response:
    return mapper.to(Create<Name>Response).map(entity, fields_mapping={...})
```

### 12.5 Checklist — PR Review

```markdown
### Functionality
- [ ] ตรงตาม requirement
- [ ] Edge cases จัดการครบ
- [ ] ไม่มี regression

### Code Quality
- [ ] ผ่าน ruff + mypy
- [ ] ไม่มี duplicate code
- [ ] Naming ตาม convention
- [ ] Type hints ครบ

### Testing
- [ ] Unit test ใหม่
- [ ] E2E test (ถ้ามี endpoint ใหม่)
- [ ] Coverage ไม่ลด

### Docs
- [ ] OpenAPI examples อัปเดต
- [ ] README / handbook อัปเดต (ถ้าจำเป็น)

### Security
- [ ] ไม่มี secret ใน code
- [ ] ตรวจสิทธิ์ (tier) ถูกต้อง
- [ ] Input validation ครบ
```

### 12.6 Checklist — Release

```markdown
### Pre-Release
- [ ] Version bump ใน pyproject.toml
- [ ] CHANGELOG.md อัปเดต
- [ ] Migration ทดสอบบน staging
- [ ] Load test ผ่าน
- [ ] Security scan ผ่าน

### Release Day
- [ ] Backup DB
- [ ] Freeze deploy อื่น ๆ
- [ ] Deploy migration
- [ ] Deploy code (rolling)
- [ ] Smoke test
- [ ] Monitor 15 นาที

### Post-Release
- [ ] Tag version ใน git
- [ ] Announce ใน team channel
- [ ] Close related issues
- [ ] Retrospective (ถ้า major)
```

### 12.7 Checklist — On-Call Handoff

```markdown
### Active Issues
- [ ] รายการ incident ที่ยังเปิดอยู่
- [ ] งานที่ค้าง (unfinished deploy, migration)

### Recent Changes
- [ ] Deploy ล่าสุด + impact
- [ ] Config changes

### Known Issues
- [ ] Bug ที่รู้แต่ยังไม่แก้
- [ ] Workaround ที่ต้องใช้

### Escalation
- [ ] ช่องทางติดต่อ (Slack, PagerDuty)
- [ ] Secondary on-call
```

---

## 13. ภาคผนวก

### 13.1 Glossary

| คำ | ความหมาย |
|-----|----------|
| **Tier** | ระดับสิทธิ์: public / user / manager / admin |
| **UNSET** | Sentinel แทน "ไม่ได้ส่ง field มา" (ต่างจาก None) |
| **Entity** | Business object ใน domain layer |
| **Mapper** | ฟังก์ชันแปลงระหว่าง layer |
| **Use Case** | Orchestration ของ business operation |
| **Tombstone** | Marker ใน cache กัน race condition ตอน revoke |
| **Cache-aside** | Pattern: อ่าน DB ถ้า cache miss แล้วเขียน cache |
| **JWE** | JSON Web Encryption (5 segments) |
| **JWS** | JSON Web Signature (3 segments) |
| **HMAC** | Hash-based Message Authentication Code |
| **Soft delete** | Mark inactive โดยไม่ลบจริง |

### 13.2 HTTP Status Code Summary

| Code | ใช้เมื่อ | Exception |
|------|---------|-----------|
| 200 | OK | — |
| 201 | Created | — |
| 400 | Bad Request | `KeyNotModifiedException`, validation |
| 401 | Unauthorized | `ApiKey*Exception`, `Authentication*Exception` |
| 403 | Forbidden | `UserHasNotPermissionException` |
| 404 | Not Found | `KeyNotFoundException` |
| 405 | Method Not Allowed | FastAPI default |
| 422 | Validation Error | Pydantic |
| 500 | Server Error | `KeyException`, `AuthenticationException` |
| 502 | Bad Gateway | upstream |
| 504 | Gateway Timeout | upstream |

### 13.3 Path Rules Syntax

```python
PathRule(endpoint="/api/v1/key",           method="POST")
PathRule(endpoint="/api/v1/key",           method="GET")
PathRule(endpoint="/api/v1/key/{id}",      method="GET")
PathRule(endpoint="/api/v1/key/{id}",      method="PATCH")
PathRule(endpoint="/api/v1/key/{id}/rotate", method="PATCH")
PathRule(endpoint="/api/v1/key/{id}",      method="DELETE")
```

**หมายเหตุ:**
- `{id}` → regex `[^/]+`
- Trailing slash → optional (`/?`)
- **ห้ามใช้ wildcard `*`** — `re.escape()` จะ escape

### 13.4 Module Dependency Matrix

| Module | Depends on |
|--------|-----------|
| authentication | user, shared |
| key | user, authentication, shared |
| user | shared |
| knowledge | user, notification, shared |
| notification | user, shared |
| health | shared |
| websocket | authentication, notification, shared |
| example | shared |

> **กฎ:** module ต้อง **ไม่** import จาก sibling โดยตรง ยกเว้นผ่าน interface ที่ประกาศใน shared หรือผ่าน use case

### 13.5 Environment Variables — Full List

| Variable | Required | Default | ใช้ที่ |
|----------|---------|---------|--------|
| `APPLICATION_URL` | ✅ | — | JWT client_id |
| `APPLICATION_TABLE_PREFIX` | ✅ | `erp` | Model table names |
| `DATABASE_URL` | ✅ | — | SQLAlchemy |
| `REDIS_URL` | ✅ | — | Cache |
| `REDIS_NAMESPACE` | ✅ | `erpiot` | Cache prefix |
| `REDIS_DEFAULT_TTL_SECONDS` | ❌ | 300 | Cache default |
| `REDIS_SESSION_TTL_SECONDS` | ❌ | 3600 | Session cache |
| `REDIS_TOMBSTONE_TTL_SECONDS` | ❌ | 60 | Revoke safety |
| `JWT_ISSUER` | ✅ | — | Token iss claim |
| `JWT_AUDIENCE` | ✅ | — | Token aud claim |
| `JWT_HASH_FINGERPRINT` | ✅ | — | HMAC key |
| `JWT_SIGNING_PRIVATE_KEY` | ✅ | — | EdDSA sign |
| `JWT_SIGNING_PUBLIC_KEY` | ✅ | — | EdDSA verify |
| `JWT_ENCRYPTION_PRIVATE_KEY` | ✅ | — | JWE decrypt |
| `JWT_ENCRYPTION_PUBLIC_KEY` | ✅ | — | JWE encrypt |
| `COOKIES_ACCESS_TOKEN_KEY` | ✅ | `access_token` | Cookie name |
| `COOKIES_REFRESH_TOKEN_KEY` | ✅ | `refresh_token` | Cookie name |
| `COOKIES_DEVICE_KEY` | ✅ | `device_id` | Cookie name |
| `API_KEY_PREFIX` | ✅ | `iap` | Key prefix |
| `API_KEY_ENTROPY_BYTES` | ✅ | 32 | Random bytes |
| `API_KEY_HASH_FINGERPRINT` | ✅ | — | HMAC key |
| `AUTH_API_KEY_NAME` | ✅ | `X-API-Key` | Header name |
| `SECURITY_ADMIN_EMAIL` | ✅ | — | Seed admin |
| `SECURITY_ADMIN_PASSWORD` | ✅ | — | Seed admin |
| `SECURITY_EMAIL_ALLOWED_DOMAINS` | ✅ | `[]` | Register check |
| `SECURITY_ALLOW_ORIGINS` | ✅ | `[]` | CORS |
| `SECURITY_NO_AUTH_PATHS` | ✅ | `()` | Public endpoints |
| `SECURITY_USER_ALLOWED_PATHS` | ✅ | `()` | User tier |
| `SECURITY_MANAGER_ALLOWED_PATHS` | ✅ | `()` | Manager tier |
| `SECURITY_ADMIN_ALLOWED_PATHS` | ✅ | `()` | Admin tier |
| `SECURITY_API_KEY_ALLOWED_PATHS` | ✅ | `()` | API Key scope |

### 13.6 References

| หัวข้อ | แหล่ง |
|--------|-------|
| FastAPI | https://fastapi.tiangolo.com |
| Pydantic v2 | https://docs.pydantic.dev |
| SQLAlchemy 2.x | https://docs.sqlalchemy.org |
| Alembic | https://alembic.sqlalchemy.org |
| jwcrypto | https://jwcrypto.readthedocs.io |
| Loguru | https://loguru.readthedocs.io |
| Clean Architecture | Martin, R. C. (2017) |
| DDD | Evans, E. (2003) |
| Conventional Commits | https://conventionalcommits.org |

### 13.7 Contact

| บทบาท | ผู้รับผิดชอบ | ช่องทาง |
|-------|-------------|---------|
| Backend Lead | — | `#backend` |
| DevOps | — | `#devops` |
| Security | — | `#security` |
| On-call | — | PagerDuty |

---

## 📝 สรุป

เอกสารนี้ครอบคลุม:

1. ✅ **ภาพรวม** — ERPIoT คืออะไร ทำอะไรได้
2. ✅ **สถาปัตยกรรม** — 4 layers + dependency rule + request flow
3. ✅ **โครงสร้าง** — module pattern มาตรฐาน + shared kernel
4. ✅ **มาตรฐาน** — naming, imports, exception, logging, UNSET pattern
5. ✅ **Workflow** — git flow + commit convention + PR + DoD
6. ✅ **ติดตั้ง** — local, docker, env vars, JWT keys
7. ✅ **พัฒนา module** — 10 ขั้นตอน + templates
8. ✅ **ทดสอบ** — structure, fixtures, coverage targets
9. ✅ **Deploy** — docker, env matrix, rollout/rollback
10. ✅ **Operations** — monitoring, backup, capacity
11. ✅ **Troubleshooting** — decision tree + common issues
12. ✅ **Templates** — checklist ครบทุกขั้นตอน
13. ✅ **ภาคผนวก** — glossary, env vars, references

> **หลักการสำคัญ:** Domain ไม่รู้จักโลกภายนอก · Application orchestrates · Infrastructure adapts · Presentation แค่แปลง HTTP ↔ entity
