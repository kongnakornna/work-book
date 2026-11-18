# 🔑 การนำ API Key ไปใช้กับ API

> คู่มือฉบับสมบูรณ์สำหรับ **ฝั่ง client** (คนที่ถือ API Key) และ **ฝั่ง server** (คนที่ต้องเปิด endpoint ให้ API Key เข้าถึงได้)

---

## 1. ภาพรวมการทำงาน

API Key ถูกออกแบบมาสำหรับ **service-to-service authentication** — client ส่ง key ผ่าน header ตรง ๆ โดยไม่ต้องมี session cookie

```
Client                              Server (FastAPI)
  │                                     │
  │  GET /api/v1/<endpoint>            │
  │  X-API-Key: iap_xxxxx              │
  ├────────────────────────────────────▶│
  │                                     │  1. APIKeyHeader อ่าน header
  │                                     │  2. hash(plain) → HMAC-SHA256
  │                                     │  3. ค้นหาใน Redis
  │                                     │     └─ miss → ค้นหาใน Postgres
  │                                     │  4. verify + is_active + expires_at
  │                                     │  5. ตรวจ SECURITY_API_KEY_ALLOWED_PATHS
  │                                     │  6. คืน Key entity
  │  200 OK + data                     │
  │◀────────────────────────────────────│
```

---

## 2. ฝั่ง Client — วิธีส่ง Key

### 2.1 Header Name มาจากไหน

server อ่าน header ตาม `settings.AUTH_API_KEY_NAME`:

```python
# app/core/security.py
api_key_header = APIKeyHeader(
    name=settings.AUTH_API_KEY_NAME,        # ← ชื่อ header
    scheme_name=settings.AUTH_API_KEY_SCHEME_NAME,
    description=settings.AUTH_API_KEY_DESCRIPTION,
    auto_error=False,                       # ← ไม่โยน 403 เอง
)
```

ตรวจค่าจริงได้จาก `.env`:

```dotenv
AUTH_API_KEY_NAME=X-API-Key
AUTH_API_KEY_SCHEME_NAME=ApiKeyAuth
AUTH_API_KEY_DESCRIPTION=API key for service-to-service authentication
```

> 📌 **ค่า default ที่แนะนำ:** `X-API-Key` (เป็น convention สากล)

### 2.2 ตัวอย่างการเรียกใช้

#### cURL

```bash
curl -X GET http://localhost:8000/api/v1/<endpoint>/ \
  -H "X-API-Key: iap_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5aB3d"
```

#### Python (httpx)

```python
import httpx

API_KEY = "iap_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5aB3d"
BASE_URL = "http://localhost:8000"

async with httpx.AsyncClient() as client:
    response = await client.get(
        f"{BASE_URL}/api/v1/<endpoint>/",
        headers={"X-API-Key": API_KEY},
    )
    response.raise_for_status()
    print(response.json())
```

#### Python (requests)

```python
import requests

response = requests.get(
    "http://localhost:8000/api/v1/<endpoint>/",
    headers={"X-API-Key": "iap_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5aB3d"},
)
print(response.json())
```

#### JavaScript (fetch)

```javascript
const response = await fetch("http://localhost:8000/api/v1/<endpoint>/", {
  method: "GET",
  headers: {
    "X-API-Key": process.env.API_KEY,
  },
});
const data = await response.json();
```

#### JavaScript (axios)

```javascript
import axios from "axios";

const api = axios.create({
  baseURL: "http://localhost:8000",
  headers: { "X-API-Key": process.env.API_KEY },
});

const { data } = await api.get("/api/v1/<endpoint>/");
```

#### Go

```go
req, _ := http.NewRequest("GET", "http://localhost:8000/api/v1/<endpoint>/", nil)
req.Header.Set("X-API-Key", os.Getenv("API_KEY"))

resp, err := http.DefaultClient.Do(req)
```

#### Postman

```
Method: GET
URL:    {{base_url}}/api/v1/<endpoint>/
Headers:
  X-API-Key: iap_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5aB3d
```

> 💡 ไม่ต้องใช้ cookie ใด ๆ — API Key เป็น **stateless** authentication

---

## 3. ฝั่ง Server — เปิด Endpoint ให้ API Key เข้าถึง

มี **2 ส่วน** ที่ต้องตั้งค่า

### 3.1 ใช้ `Depends(authenticate_api_key)` ใน Route

```python
# app/modules/<module>/presentation/routers.py
from fastapi import APIRouter, Depends
from typing import Annotated

from app.core.security import authenticate_api_key
from app.modules.key.domain.entities import Key

router = APIRouter(prefix="/api/v1/device", tags=["Device"])

@router.get("/")
async def list_devices(
    key: Annotated[Key, Depends(authenticate_api_key)],   # ← สำคัญ
) -> list[DeviceResponse]:
    # key = API Key ที่ authenticate ผ่าน
    # key.created_by, key.id, key.name ใช้ได้
    ...
```

> ⚠️ ถ้า route ใช้ `Depends(authenticate_admin)` เฉย ๆ → API Key จะใช้ไม่ได้

### 3.2 เพิ่ม Path Rule ใน Settings

```python
# app/core/settings.py
SECURITY_API_KEY_ALLOWED_PATHS: tuple[PathRule, ...] = (
    PathRule(endpoint="/api/v1/device",          method="GET"),
    PathRule(endpoint="/api/v1/device/{id}",     method="GET"),
    PathRule(endpoint="/api/v1/device",          method="POST"),
    PathRule(endpoint="/api/v1/telemetry",       method="POST"),
)
```

**ถ้าไม่เพิ่ม path rule** → ได้ **403** `UserHasNotPermissionException` แม้ API Key จะถูกต้อง

### 3.3 Path Rule Syntax

| Endpoint ที่เขียน | Match อะไร |
|-------------------|-----------|
| `/api/v1/device` | `/api/v1/device` และ `/api/v1/device/` |
| `/api/v1/device/{id}` | `/api/v1/device/abc`, `/api/v1/device/123` |
| `/api/v1/device/{id}/status` | `/api/v1/device/abc/status` |
| `/api/v1/device/*` | ❌ **ไม่ทำงาน** (wildcard ถูก escape) |

> ❗ **ห้ามใช้ `*`** — `_compile_path_rule` จะ `re.escape()` ทำให้ `*` กลายเป็น literal `\*`

### 3.4 ตัวอย่าง Flow เต็ม (ฝั่ง server)

```python
# app/core/security.py (มีอยู่แล้ว)
async def _resolve_api_key(
    request: Request,
    background_tasks: BackgroundTasks,
    plain_key: str | None = Depends(api_key_header),
    repository: IKeyRepository = Depends(get_key_repository),
    cache: IKeyCache = Depends(get_key_cache),
) -> Key:
    # 1. ไม่มี header
    if not plain_key:
        raise ApiKeyNotProvidedException()                     # → 401

    # 2. hash + cache lookup
    fingerprint = _api_key_fingerprint(plain_key)
    db_key = await cache.get_by_hashed_key(fingerprint)

    # 3. cache miss → DB + insert cache
    if db_key is None:
        db_key = await repository.get_key_by_hashed_key(fingerprint)
        if db_key is not None:
            background_tasks.add_task(cache.insert, db_key)

    # 4. ไม่เจอ / hash ไม่ตรง
    if db_key is None or not verify_api_key(plain_key, db_key.hashed_key):
        raise ApiKeyInvalidException()                         # → 401

    # 5. ถูก revoke
    if not db_key.is_active:
        raise ApiKeyRevokedException()                         # → 401

    # 6. หมดอายุ
    if db_key.expires_at is not None and db_key.expires_at < datetime.now(UTC):
        raise ApiKeyExpiredException()                         # → 401

    return db_key


async def authenticate_api_key(
    request: Request, key: Key = Depends(_resolve_api_key)
) -> Key:
    # 7. ตรวจ path rule
    if not _has_access_to_api_key_endpoint(request.url.path, request.method):
        raise UserHasNotPermissionException()                  # → 403
    return key
```

---

## 4. การจัดการ Error ฝั่ง Client

### 4.1 Error Codes ทั้งหมด

| HTTP | Message (`details.data.errors`) | สาเหตุ | วิธีแก้ |
|------|--------------------------------|--------|--------|
| **401** | `API key was not provided.` | ไม่มี header | เพิ่ม header `X-API-Key` |
| **401** | `Invalid API key.` | Key ไม่มีในระบบ / hash ไม่ตรง | ตรวจ key, regenerate |
| **401** | `The provided API key has been revoked...` | `is_active = false` | Rotate หรือสร้างใหม่ |
| **401** | `The provided API key has expired...` | `expires_at < now` | Rotate |
| **403** | `User does not have permission...` | Path ไม่อยู่ใน allowlist | แจ้ง admin เพิ่ม path rule |
| **500** | `An unexpected error occurred...` | Internal | แจ้งทีม backend |

### 4.2 ตัวอย่าง Response

**401 — Key ไม่ถูกต้อง:**
```json
{
  "code": 401,
  "method": "GET",
  "path": "/api/v1/device/",
  "timestamp": "2026-10-01T07:02:13Z",
  "details": {
    "message": "Unauthorized access",
    "data": {
      "errors": "Invalid API key. The provided key is not valid or does not exist."
    }
  }
}
```

**403 — Path ไม่ได้รับอนุญาต:**
```json
{
  "code": 403,
  "method": "GET",
  "path": "/api/v1/device/",
  "timestamp": "2026-10-01T07:02:13Z",
  "details": {
    "message": "Unauthorized access",
    "data": {
      "errors": "User does not have permission to perform this action."
    }
  }
}
```

### 4.3 Client-Side Error Handling (Python)

```python
import httpx
from enum import Enum

class ApiKeyError(Exception):
    def __init__(self, status: int, message: str):
        self.status = status
        self.message = message
        super().__init__(f"[{status}] {message}")


async def call_api(endpoint: str, api_key: str) -> dict:
    async with httpx.AsyncClient() as client:
        response = await client.get(
            f"https://api.example.com{endpoint}",
            headers={"X-API-Key": api_key},
            timeout=10.0,
        )

    if response.status_code == 200:
        return response.json()

    if response.status_code == 401:
        errors = response.json().get("details", {}).get("data", {}).get("errors", "")
        if "revoked" in errors or "expired" in errors:
            raise ApiKeyError(401, "API key ถูก revoke หรือหมดอายุ — ต้อง rotate")
        if "not provided" in errors:
            raise ApiKeyError(401, "ไม่ได้ส่ง API key")
        raise ApiKeyError(401, "API key ไม่ถูกต้อง")

    if response.status_code == 403:
        raise ApiKeyError(403, "Endpoint นี้ไม่อนุญาตให้ใช้ API key")

    response.raise_for_status()
```

### 4.4 Retry Strategy

| Error | ควร retry? | หมายเหตุ |
|-------|-----------|----------|
| 401 invalid | ❌ | ต้องแก้ key |
| 401 expired/revoked | ❌ | ต้อง rotate |
| 403 | ❌ | ต้องแก้ config |
| 500 | ✅ (exponential backoff) | error ชั่วคราว |
| 502/504 | ✅ (exponential backoff) | upstream |
| Network timeout | ✅ (exponential backoff) | — |

```python
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type
import httpx

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=1, max=10),
    retry=retry_if_exception_type((httpx.TimeoutException, httpx.HTTPStatusError)),
)
async def call_with_retry(...):
    ...
```

---

## 5. Best Practices ฝั่ง Client

### 5.1 เก็บ Key อย่างปลอดภัย

```bash
# ❌ ผิด — hardcode ใน code
API_KEY = "iap_a1b2c3d4..."

# ❌ ผิด — commit ลง git
# .env ที่ push ขึ้น repo

# ✅ ถูก — อ่านจาก environment variable
import os
API_KEY = os.environ["API_KEY"]

# ✅ ถูก — ใช้ secret manager
from aws_secretsmanager import get_secret_value
API_KEY = get_secret_value("prod/erpiot/api-key")
```

### 5.2 Checklist การใช้งาน

- [ ] เก็บ key ใน secret manager (Vault / AWS SM / GH Secrets)
- [ ] **ห้าม** commit ลง git
- [ ] **ห้าม** log `plain_key` (log แค่ prefix + last_four)
- [ ] ตั้ง timeout ทุกครั้ง (default ~10s)
- [ ] Handle 401 ทันที (ไม่ retry)
- [ ] Retry เฉพาะ 5xx + network error
- [ ] Monitor error rate
- [ ] หมุน key ตามรอบ (แนะนำ ≤ 90 วัน)
- [ ] ใช้ 1 key ต่อ 1 service (แยก revoke ได้)

### 5.3 Multi-Service Pattern

```
┌──────────────┐  iap_xxx (key A)   ┌──────────┐
│ CI pipeline  ├───────────────────▶│          │
└──────────────┘                    │          │
                                    │  ERPIoT  │
┌──────────────┐  iap_yyy (key B)   │   API    │
│ Partner A    ├───────────────────▶│          │
└──────────────┘                    │          │
                                    │          │
┌──────────────┐  iap_zzz (key C)   │          │
│ IoT Gateway  ├───────────────────▶│          │
└──────────────┘                    └──────────┘
```

**ข้อดี:**
- Revoke เจาะจงได้ (ถ้า partner A โดน compromised → revoke แค่ key B)
- Audit แยกตาม service (`key.id` ปรากฏใน log)
- ตั้ง expiration ต่างกันตามความเสี่ยง

### 5.4 Monitoring

```python
import logging

logger = logging.getLogger(__name__)

# ✅ log แบบปลอดภัย
logger.info(f"Calling API with key prefix={api_key[:8]}...{api_key[-4:]}")

# ❌ อย่าทำ — รั่ว secret
logger.info(f"Calling API with key={api_key}")
```

**Metrics ที่ควรเก็บ:**
- อัตรา 401 / 403 แยกตาม endpoint
- อัตรา 5xx
- p95/p99 latency
- จำนวนครั้งที่ใช้ key (เทียบกับ `last_used_at` ฝั่ง server)

---

## 6. การทดสอบ

### 6.1 ทดสอบด้วย cURL

```bash
# 1. ตรวจว่า key ใช้ได้
curl -i -X GET http://localhost:8000/api/v1/device/ \
  -H "X-API-Key: iap_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5aB3d"

# 2. ดู response headers
# HTTP/1.1 200 OK
# ...

# 3. ลองด้วย key ปลอม → ต้องได้ 401
curl -i -X GET http://localhost:8000/api/v1/device/ \
  -H "X-API-Key: iap_fake_key"
```

### 6.2 ทดสอบด้วย Postman

1. สร้าง Collection ใหม่
2. เพิ่ม Collection Variables:
   - `base_url` = `http://localhost:8000`
   - `api_key` = `iap_xxx` (ตั้ง type = secret)
3. สร้าง Request:
   - Method: `GET`
   - URL: `{{base_url}}/api/v1/device/`
   - Headers: `X-API-Key: {{api_key}}`
4. รันและตรวจว่าได้ 200

### 6.3 Automated Test (pytest)

```python
import pytest
from httpx import AsyncClient

@pytest.mark.asyncio
async def test_api_key_authenticates(client: AsyncClient, api_key: str):
    response = await client.get(
        "/api/v1/device/",
        headers={"X-API-Key": api_key},
    )
    assert response.status_code == 200

@pytest.mark.asyncio
async def test_missing_api_key_returns_401(client: AsyncClient):
    response = await client.get("/api/v1/device/")
    assert response.status_code == 401
    assert "not provided" in response.json()["details"]["data"]["errors"]

@pytest.mark.asyncio
async def test_invalid_api_key_returns_401(client: AsyncClient):
    response = await client.get(
        "/api/v1/device/",
        headers={"X-API-Key": "iap_invalid"},
    )
    assert response.status_code == 401

@pytest.mark.asyncio
async def test_revoked_api_key_returns_401(client: AsyncClient, revoked_key: str):
    response = await client.get(
        "/api/v1/device/",
        headers={"X-API-Key": revoked_key},
    )
    assert response.status_code == 401
    assert "revoked" in response.json()["details"]["data"]["errors"]
```

---

## 7. เปรียบเทียบ: API Key vs Session Cookie

| ประเด็น | Session Cookie | API Key |
|---------|---------------|---------|
| **เหมาะกับ** | Human user (browser) | Service / external system |
| **Header** | `Cookie: access_token=...` | `X-API-Key: iap_...` |
| **State** | Stateful (มี refresh flow) | Stateless |
| **หมดอายุ** | access สั้น (นาที) | 7 วัน – never |
| **Rotate** | Refresh token flow | `PATCH /rotate/` |
| **Revoke** | Logout | `DELETE /api/v1/key/{id}/` |
| **Tier** | user / manager / admin | ขึ้นกับ `SECURITY_API_KEY_ALLOWED_PATHS` |
| **Endpoint ที่ใช้** | `authenticate_user/manager/admin` | `authenticate_api_key` |

---

## 8. Troubleshooting

### 🔴 `401 — API key was not provided`

**สาเหตุ:** ไม่มี header หรือ header name ผิด

**ตรวจ:**
```bash
# ดู header name จาก .env
grep AUTH_API_KEY_NAME .env
# → AUTH_API_KEY_NAME=X-API-Key
```

**แก้:** เพิ่ม header `X-API-Key` (ตัวพิมพ์ต้องตรง — HTTP headers case-insensitive แต่ Postman บางทีกดวก)

---

### 🔴 `401 — Invalid API key`

**สาเหตุ:**
1. Key ไม่มีใน DB จริง
2. Hash ไม่ตรง (เช่น key ถูกแก้)
3. Key อยู่ใน environment ผิด

**ตรวจ:**
```sql
-- ตรวจว่า hashed_key มีในระบบ
-- (client ต้องรู้ fingerprint — ไม่สามารถคำนวณได้ถ้าไม่รู้ secret)
-- วิธีง่ายสุด: สร้าง key ใหม่ แล้วทดสอบ
SELECT id, name, is_active, expires_at
FROM erp_keys
WHERE is_active = true
ORDER BY created_at DESC LIMIT 5;
```

**แก้:** สร้าง key ใหม่ ถ้าไม่แน่ใจ

---

### 🔴 `401 — API key has been revoked`

**สาเหตุ:** `is_active = false`

**ตรวจ:**
```sql
SELECT id, name, is_active, updated_at
FROM erp_keys WHERE id = '<key-uuid>';
```

**แก้:** สร้างใหม่ หรือ rotate (rotate ใช้ได้เฉพาะ active key)

---

### 🔴 `401 — API key has expired`

**สาเหตุ:** `expires_at < now()`

**ตรวจ:**
```sql
SELECT id, name, expires_at, now() AS current_time
FROM erp_keys WHERE id = '<key-uuid>';
```

**แก้:** ใช้ `PATCH /api/v1/key/{id}/rotate/` — rotate จะรีเซ็ต `hashed_key` และ `plain_key` แต่ **ไม่รีเซ็ต `expires_at`** → ต้องสร้าง key ใหม่

> ⚠️ **ข้อสังเกต:** `rotate()` ใน use case **ไม่ได้อัปเดต `expires_at`** → key ที่หมดอายุแล้ว rotate แล้วยังหมดอายุอยู่

---

### 🔴 `403 — User does not have permission`

**สาเหตุ:** Path ไม่อยู่ใน `SECURITY_API_KEY_ALLOWED_PATHS`

**ตรวจ:**
```python
# app/core/settings.py
SECURITY_API_KEY_ALLOWED_PATHS = (
    PathRule(endpoint="/api/v1/device", method="GET"),
    # ← เพิ่ม endpoint ที่ต้องการตรงนี้
)
```

**แก้:** เพิ่ม path rule + restart service

---

### 🔴 ผ่าน cache แล้วได้ข้อมูลเก่า

**สาเหตุ:** cache hit กับ entry ที่ลบไม่ออก

**แก้:**
```bash
# ล้าง cache ทั้งหมดของ key
redis-cli --scan --pattern "erpiot:key:hashed_key:*" | xargs redis-cli DEL
```

---

## 9. ตัวอย่างครบวงจร

### ฝั่ง Server — Device Module ที่ใช้ API Key

```python
# app/modules/device/presentation/routers.py
from __future__ import annotations

from typing import Annotated

from fastapi import APIRouter, Depends
from loguru import logger

from app.core.security import authenticate_api_key
from app.modules.device.application.use_cases import DeviceUseCases
from app.modules.device.presentation.dependencies import get_device_use_cases
from app.modules.device.presentation.schemas import DeviceResponse
from app.modules.key.domain.entities import Key

router = APIRouter(prefix="/api/v1/device", tags=["Device"])


@router.get("/")
async def list_devices(
    key: Annotated[Key, Depends(authenticate_api_key)],
    use_case: Annotated[DeviceUseCases, Depends(get_device_use_cases)],
) -> list[DeviceResponse]:
    """List devices — accessible via API Key."""
    logger.info(f"Device list requested by API key '{key.id}'")
    return await use_case.list_all()
```

```python
# app/core/settings.py
SECURITY_API_KEY_ALLOWED_PATHS: tuple[PathRule, ...] = (
    PathRule(endpoint="/api/v1/device", method="GET"),
    PathRule(endpoint="/api/v1/device/{id}", method="GET"),
    PathRule(endpoint="/api/v1/telemetry", method="POST"),
)
```

### ฝั่ง Client — Production-ready

```python
# client/erpiot_client.py
from __future__ import annotations

import os
from dataclasses import dataclass

import httpx
from tenacity import (
    retry,
    retry_if_exception_type,
    stop_after_attempt,
    wait_exponential,
)


@dataclass
class ErpiotClient:
    base_url: str
    api_key: str
    timeout: float = 10.0

    @classmethod
    def from_env(cls) -> "ErpiotClient":
        return cls(
            base_url=os.environ["ERPIOT_BASE_URL"],
            api_key=os.environ["ERPIOT_API_KEY"],
        )

    def _headers(self) -> dict[str, str]:
        return {"X-API-Key": self.api_key}

    @retry(
        stop=stop_after_attempt(3),
        wait=wait_exponential(multiplier=1, min=1, max=10),
        retry=retry_if_exception_type(
            (httpx.TimeoutException, httpx.ConnectError)
        ),
    )
    async def get(self, path: str) -> dict:
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            response = await client.get(
                f"{self.base_url}{path}",
                headers=self._headers(),
            )

        if response.status_code == 401:
            # ไม่ retry — ต้องแก้ key
            raise RuntimeError(
                f"API key rejected: {response.json()['details']['data']['errors']}"
            )
        if response.status_code == 403:
            raise RuntimeError(
                f"Endpoint not allowed for API key: {path}"
            )

        response.raise_for_status()
        return response.json()


# usage
async def main():
    client = ErpiotClient.from_env()
    devices = await client.get("/api/v1/device/")
    print(devices)
```

---

## 10. สรุปสั้น ๆ

| คำถาม | คำตอบ |
|-------|-------|
| ส่ง API Key ที่ไหน? | Header `X-API-Key` (ชื่อตาม `settings.AUTH_API_KEY_NAME`) |
| ฝั่ง server ต้องทำอะไร? | ใช้ `Depends(authenticate_api_key)` + เพิ่ม path ใน `SECURITY_API_KEY_ALLOWED_PATHS` |
| ถ้าได้ 401? | ปัญหา key (ไม่ส่ง / ผิด / revoke / expired) |
| ถ้าได้ 403? | Path ไม่อยู่ใน allowlist — แจ้ง admin |
| Cache ทำงานยังไง? | cache-aside + tombstone กัน race |
| Rotate บ่อยแค่ไหน? | ≤ 90 วัน หรือเมื่อ suspect leak |
| เก็บ key ที่ไหน? | Secret manager — ห้าม commit / log |

> 📌 **หลักการ:** API Key = credential ของ **service** ไม่ใช่ **user** — ใช้ 1 key ต่อ 1 service, rotate ตามรอบ, monitor อย่างสม่ำเสมอ



 
curl -X GET http://localhost:8000/api/v1/key/?page=1&limit=10&sort_by=updated_at&sort_order=desc/ \
  -H "X-API-Key: 8aac3c17-27d6-4130-9f42-be41347f3f98"



curl -X 'POST' \
  'http://localhost:8000/api/v1/authentication/login/' \
  -H 'accept: */*' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'grant_type=password&username=string&email=admin@example.com&password=MyP@ssword123&scope=&client_id=string&client_secret=string'
