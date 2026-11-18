# เล่ม 5: เว็บ API และฐานข้อมูล
## คู่มือการทำงานฉบับสมบูรณ์ พร้อมตัวอย่างการใช้งานจริง

---

## บทนำเล่ม

หนังสือเล่มนี้พาคุณเข้าสู่โลกของการพัฒนาเว็บแอปพลิเคชันและ API ด้วย Python ตั้งแต่พื้นฐาน HTTP ไปจนถึงการออกแบบระบบฐานข้อมูลระดับ production เนื้อหาครอบคลุมสามภาคหลัก:

1. **การพัฒนาเว็บและ API** — Django, Flask, FastAPI, GraphQL, gRPC, WebSocket, Authentication, Background Jobs, Web Scraping
2. **ฐานข้อมูลและระบบจัดเก็บข้อมูล** — SQL, ORM, NoSQL, Vector Database, Data Warehouse, ETL
3. **Data Platform เพิ่มเติม** — Data Mesh, Lakehouse, Kafka, Data Quality, RAG, GDPR/PDPA

ทุกหัวข้อจะมี **ตัวอย่างโค้ดที่รันได้จริง**, **คำสั่ง setup**, และ **แนวปฏิบัติจากอุตสาหกรรม** พร้อมลิงก์อ้างอิง


## ภาค 12: การพัฒนาเว็บและ API

### 12.1 HTTP (HyperText Transfer Protocol)

**คืออะไร:** โปรโตคอลพื้นฐานของเว็บ ทำงานแบบ request-response ผ่าน TCP/IP

**โครงสร้าง HTTP Request:**

```
GET /api/users/123 HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
Accept: application/json
User-Agent: MyApp/1.0
```

**โครงสร้าง HTTP Response:**

```
HTTP/1.1 200 OK
Content-Type: application/json
Cache-Control: max-age=3600

{"id": 123, "name": "สมชาย", "email": "somchai@example.com"}
```

**ตัวอย่าง Python — ดู HTTP request/response:**

```python
import http.client

conn = http.client.HTTPSConnection("api.github.com")
conn.request("GET", "/users/torvalds", headers={"User-Agent": "Python-Demo"})
response = conn.getresponse()

print(f"Status: {response.status} {response.reason}")
print(f"Headers: {dict(response.getheaders())}")
print(f"Body: {response.read().decode()[:200]}")
conn.close()
```

**อ้างอิง:** [MDN HTTP Guide](https://developer.mozilla.org/en-US/docs/Web/HTTP)


### 12.3 HTTP Method

**คืออะไร:** คำกริยาที่บอกว่าต้องการทำอะไรกับ resource

| Method | ความหมาย | Idempotent | Safe | ตัวอย่าง |
|--------|----------|------------|------|----------|
| GET | อ่านข้อมูล | ✅ | ✅ | ดึงรายการสินค้า |
| POST | สร้างใหม่ | ❌ | ❌ | สร้างออเดอร์ |
| PUT | แทนที่ทั้งหมด | ✅ | ❌ | อัปเดตโปรไฟล์ |
| PATCH | แก้ไขบางส่วน | ❌ | ❌ | เปลี่ยนอีเมล |
| DELETE | ลบ | ✅ | ❌ | ลบสินค้า |
| HEAD | เหมือน GET แต่ได้แค่ header | ✅ | ✅ | ตรวจสอบว่ามีไฟล์ |
| OPTIONS | ดู methods ที่รองรับ | ✅ | ✅ | CORS preflight |

**ข้อควรระวัง:** PUT ต้องส่งข้อมูลทั้งหมด ส่วน PATCH ส่งเฉพาะที่เปลี่ยน การใช้ผิดอาจทำให้ข้อมูลหาย


### 12.4 HTTP Status Code

**คืออะไร:** รหัส 3 หลักที่บอกผลลัพธ์ของ request

**กลุ่มหลัก:**

```
2xx — สำเร็จ
  200 OK              — สำเร็จทั่วไป
  201 Created         — สร้างใหม่สำเร็จ (POST)
  204 No Content      — สำเร็จแต่ไม่มี body (DELETE)

3xx — เปลี่ยนเส้นทาง
  301 Moved Permanently — ย้ายถาวร
  302 Found             — ย้ายชั่วคราว
  304 Not Modified      — cache ยังใช้ได้

4xx — ข้อผิดพลาดจาก client
  400 Bad Request       — ข้อมูลส่งมาไม่ถูกต้อง
  401 Unauthorized      — ยังไม่ login
  403 Forbidden         — login แล้วแต่ไม่มีสิทธิ์
  404 Not Found         — ไม่พบ resource
  409 Conflict          — ชนกัน (เช่น email ซ้ำ)
  422 Unprocessable     — validation fail
  429 Too Many Requests — rate limit

5xx — ข้อผิดพลาดจาก server
  500 Internal Server Error — bug
  502 Bad Gateway           — upstream ล่ม
  503 Service Unavailable   — server ล่มชั่วคราว
  504 Gateway Timeout       — upstream timeout
```

**ตัวอย่างการเลือกใช้:**

```python
from fastapi import FastAPI, HTTPException, status

app = FastAPI()

@app.get("/users/{user_id}")
def get_user(user_id: int):
    user = find_user(user_id)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"ไม่พบผู้ใช้ ID {user_id}"
        )
    return user

@app.post("/users", status_code=status.HTTP_201_CREATED)
def create_user(user: UserCreate):
    if user_exists(user.email):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="อีเมลนี้ถูกใช้แล้ว"
        )
    return create(user)
```


### 12.8 WSGI vs 12.9 ASGI

**คืออะไร:**
- **WSGI** (Web Server Gateway Interface) — มาตรฐานซิงโครนัสสำหรับ Python web apps (PEP 3333)
- **ASGI** (Asynchronous Server Gateway Interface) — มาตรฐานใหม่ที่รองรับ async, WebSocket, HTTP/2

**เปรียบเทียบ:**

| ประเภท | WSGI | ASGI |
|--------|------|------|
| Framework | Flask, Django (เดิม) | FastAPI, Starlette, Django 3+ |
| Server | Gunicorn, uWSGI | Uvicorn, Hypercorn, Daphne |
| Async | ❌ | ✅ |
| WebSocket | ❌ | ✅ |
| Performance | ดี | ดีมาก (I/O-bound) |

**ตัวอย่าง WSGI app:**

```python
# wsgi_app.py
def application(environ, start_response):
    status = "200 OK"
    headers = [("Content-Type", "text/plain; charset=utf-8")]
    start_response(status, headers)
    return [b"Hello from WSGI!"]

# รัน: gunicorn wsgi_app:application
```

**ตัวอย่าง ASGI app:**

```python
# asgi_app.py
async def application(scope, receive, send):
    assert scope["type"] == "http"
    await send({
        "type": "http.response.start",
        "status": 200,
        "headers": [(b"content-type", b"text/plain; charset=utf-8")],
    })
    await send({
        "type": "http.response.body",
        "body": b"Hello from ASGI!",
    })

# รัน: uvicorn asgi_app:application
```


### 12.10 Django + Domain-Driven Design (DDD)

**คืออะไร:** Django เป็น full-stack framework ที่มาพร้อม ORM, Admin, Auth, Migration การประยุกต์ DDD กับ Django ต้องแยก business logic ออกจาก ORM models

**โครงสร้างโปรเจกต์ตาม DDD:**

```
myproject/
├── manage.py
├── config/                 # Django settings
│   ├── settings/
│   │   ├── base.py
│   │   ├── dev.py
│   │   └── prod.py
│   └── urls.py
├── domain/                 # Business logic ล้วน — ไม่พึ่ง Django
│   ├── entities/
│   │   └── order.py
│   ├── value_objects/
│   │   └── money.py
│   └── repositories/       # Interface เท่านั้น
│       └── order_repository.py
├── application/            # Use cases
│   └── use_cases/
│       └── place_order.py
├── infrastructure/         # Django ORM, external services
│   ├── models/
│   │   └── order_model.py
│   └── repositories/
│       └── django_order_repository.py
└── interfaces/             # Views, serializers, URLs
    ├── api/
    │   └── order_view.py
    └── urls.py
```

**ตัวอย่าง Domain Entity:**

```python
# domain/entities/order.py
from dataclasses import dataclass, field
from decimal import Decimal
from datetime import datetime
from uuid import UUID, uuid4

@dataclass
class OrderLine:
    product_id: str
    quantity: int
    unit_price: Decimal

    @property
    def subtotal(self) -> Decimal:
        return self.unit_price * self.quantity

@dataclass
class Order:
    id: UUID = field(default_factory=uuid4)
    customer_id: str = ""
    lines: list[OrderLine] = field(default_factory=list)
    status: str = "pending"
    created_at: datetime = field(default_factory=datetime.utcnow)

    def add_line(self, product_id: str, quantity: int, unit_price: Decimal) -> None:
        if quantity <= 0:
            raise ValueError("จำนวนต้องมากกว่าศูนย์")
        self.lines.append(OrderLine(product_id, quantity, unit_price))

    @property
    def total(self) -> Decimal:
        return sum(line.subtotal for line in self.lines)

    def confirm(self) -> None:
        if not self.lines:
            raise ValueError("ออเดอร์ว่างเปล่า")
        self.status = "confirmed"
```

**ตัวอย่าง Repository Interface (domain):**

```python
# domain/repositories/order_repository.py
from abc import ABC, abstractmethod
from domain.entities.order import Order

class OrderRepository(ABC):
    @abstractmethod
    def save(self, order: Order) -> None: ...
    @abstractmethod
    def find_by_id(self, order_id: str) -> Order | None: ...
```

**ตัวอย่าง Django ORM Implementation:**

```python
# infrastructure/models/order_model.py
from django.db import models

class OrderModel(models.Model):
    id = models.UUIDField(primary_key=True)
    customer_id = models.CharField(max_length=100, db_index=True)
    status = models.CharField(max_length=20)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "orders"

class OrderLineModel(models.Model):
    order = models.ForeignKey(OrderModel, related_name="lines", on_delete=models.CASCADE)
    product_id = models.CharField(max_length=100)
    quantity = models.PositiveIntegerField()
    unit_price = models.DecimalField(max_digits=12, decimal_places=2)
```

```python
# infrastructure/repositories/django_order_repository.py
from decimal import Decimal
from domain.entities.order import Order, OrderLine
from domain.repositories.order_repository import OrderRepository
from infrastructure.models.order_model import OrderModel, OrderLineModel

class DjangoOrderRepository(OrderRepository):
    def save(self, order: Order) -> None:
        OrderModel.objects.update_or_create(
            id=order.id,
            defaults={
                "customer_id": order.customer_id,
                "status": order.status,
            },
        )
        OrderLineModel.objects.filter(order_id=order.id).delete()
        OrderLineModel.objects.bulk_create([
            OrderLineModel(
                order_id=order.id,
                product_id=line.product_id,
                quantity=line.quantity,
                unit_price=line.unit_price,
            )
            for line in order.lines
        ])

    def find_by_id(self, order_id: str) -> Order | None:
        try:
            m = OrderModel.objects.prefetch_related("lines").get(id=order_id)
        except OrderModel.DoesNotExist:
            return None
        order = Order(
            id=m.id, customer_id=m.customer_id,
            status=m.status, created_at=m.created_at,
        )
        for line in m.lines.all():
            order.lines.append(
                OrderLine(line.product_id, line.quantity, line.unit_price)
            )
        return order
```

**ข้อดี:** Business logic ทดสอบได้โดยไม่ต้องใช้ database, เปลี่ยน ORM ได้, รองรับทีมใหญ่
**ข้อเสีย:** โค้ดเยอะขึ้น, Django Admin ใช้งานยากขึ้นเพราะใช้ ORM model เป็นหลัก


### 12.24 FastAPI + DDD

**คืออะไร:** FastAPI เป็น async web framework ที่เหมาะกับ DDD เพราะใช้ Pydantic สำหรับ validation และ dependency injection

**ตัวอย่างโปรเจกต์ FastAPI + DDD:**

```
src/
├── domain/
│   ├── entities/user.py
│   └── repositories/user_repository.py
├── application/
│   └── use_cases/register_user.py
├── infrastructure/
│   ├── db/
│   │   ├── models.py
│   │   └── session.py
│   └── repositories/sql_user_repository.py
└── interfaces/
    ├── api/
    │   ├── schemas/user_schema.py
    │   └── routes/user_routes.py
    └── dependencies.py
```

**Domain Layer:**

```python
# domain/entities/user.py
from dataclasses import dataclass, field
from datetime import datetime
from uuid import UUID, uuid4
import re

@dataclass
class User:
    id: UUID = field(default_factory=uuid4)
    email: str = ""
    name: str = ""
    hashed_password: str = ""
    created_at: datetime = field(default_factory=datetime.utcnow)

    def __post_init__(self):
        if not re.match(r"^[\w\.-]+@[\w\.-]+\.\w+$", self.email):
            raise ValueError("อีเมลไม่ถูกต้อง")
        if len(self.name) < 2:
            raise ValueError("ชื่อต้องมีอย่างน้อย 2 ตัวอักษร")
```

**Use Case Layer:**

```python
# application/use_cases/register_user.py
from domain.entities.user import User
from domain.repositories.user_repository import UserRepository
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class EmailAlreadyExistsError(Exception):
    pass

class RegisterUserUseCase:
    def __init__(self, repo: UserRepository):
        self.repo = repo

    def execute(self, email: str, name: str, password: str) -> User:
        if self.repo.find_by_email(email):
            raise EmailAlreadyExistsError(f"อีเมล {email} ถูกใช้แล้ว")
        user = User(
            email=email,
            name=name,
            hashed_password=pwd_context.hash(password),
        )
        self.repo.save(user)
        return user
```

**Interface Layer (FastAPI):**

```python
# interfaces/api/schemas/user_schema.py
from pydantic import BaseModel, EmailStr, Field

class UserRegisterRequest(BaseModel):
    email: EmailStr
    name: str = Field(min_length=2, max_length=100)
    password: str = Field(min_length=8)

class UserResponse(BaseModel):
    id: str
    email: str
    name: str
```

```python
# interfaces/api/routes/user_routes.py
from fastapi import APIRouter, Depends, HTTPException, status
from application.use_cases.register_user import (
    RegisterUserUseCase, EmailAlreadyExistsError,
)
from interfaces.api.schemas.user_schema import UserRegisterRequest, UserResponse
from interfaces.dependencies import get_register_user_use_case

router = APIRouter(prefix="/users", tags=["users"])

@router.post("", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def register(
    payload: UserRegisterRequest,
    use_case: RegisterUserUseCase = Depends(get_register_user_use_case),
):
    try:
        user = use_case.execute(payload.email, payload.name, payload.password)
        return UserResponse(id=str(user.id), email=user.email, name=user.name)
    except EmailAlreadyExistsError as e:
        raise HTTPException(status_code=409, detail=str(e))
    except ValueError as e:
        raise HTTPException(status_code=422, detail=str(e))
```

**Dependencies:**

```python
# interfaces/dependencies.py
from fastapi import Depends
from sqlalchemy.orm import Session
from infrastructure.db.session import get_session
from infrastructure.repositories.sql_user_repository import SqlUserRepository
from application.use_cases.register_user import RegisterUserUseCase

def get_register_user_use_case(
    session: Session = Depends(get_session),
) -> RegisterUserUseCase:
    repo = SqlUserRepository(session)
    return RegisterUserUseCase(repo)
```

**อ้างอิง:** [FastAPI Documentation](https://fastapi.tiangolo.com)


### 12.25 Pydantic

**คืออะไร:** Library สำหรับ data validation และ settings management ใช้ type hints เป็นหลัก

**ตัวอย่างการใช้งาน:**

```python
from pydantic import BaseModel, Field, EmailStr, field_validator, model_validator
from datetime import date
from typing import Optional

class Address(BaseModel):
    street: str
    city: str
    postal_code: str = Field(pattern=r"^\d{5}$")

class User(BaseModel):
    id: int
    name: str = Field(min_length=2, max_length=100)
    email: EmailStr
    birth_date: date
    address: Optional[Address] = None
    tags: list[str] = Field(default_factory=list)

    @field_validator("name")
    @classmethod
    def name_must_not_be_empty(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("ชื่อต้องไม่ว่าง")
        return v.strip()

    @model_validator(mode="after")
    def check_adult(self) -> "User":
        age = (date.today() - self.birth_date).days // 365
        if age < 18:
            raise ValueError("ผู้ใช้ต้องมีอายุ 18 ปีขึ้นไป")
        return self

# ใช้งาน
user = User(
    id=1,
    name="  สมชาย  ",
    email="somchai@example.com",
    birth_date=date(1990, 5, 15),
    tags=["vip", "premium"],
)
print(user.model_dump_json(indent=2))
```

**Validation Error Handling:**

```python
from pydantic import ValidationError

try:
    User(id=1, name="A", email="invalid", birth_date=date(2020, 1, 1))
except ValidationError as e:
    print(e.errors())
    # [
    #   {'type': 'string_too_short', 'loc': ('name',), ...},
    #   {'type': 'value_error', 'loc': ('email',), ...},
    #   {'type': 'value_error', 'loc': (), 'msg': 'ผู้ใช้ต้องมีอายุ 18 ปีขึ้นไป'}
    # ]
```

**Settings Management:**

```python
# config.py
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    app_name: str = "MyApp"
    database_url: str
    secret_key: str
    debug: bool = False
    allowed_hosts: list[str] = ["localhost"]

settings = Settings()
```

**อ้างอิง:** [Pydantic Documentation](https://docs.pydantic.dev)


### 12.43 JWT (JSON Web Token)

**คืออะไร:** มาตรฐานเปิด (RFC 7519) สำหรับส่งข้อมูลที่ลงนามแล้วระหว่างสองฝ่าย โครงสร้าง: `header.payload.signature`

**การใช้งานกับ FastAPI:**

```python
# auth/jwt_handler.py
from datetime import datetime, timedelta, timezone
from typing import Any
from jose import JWTError, jwt
from passlib.context import CryptContext

SECRET_KEY = "your-secret-key-from-env"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)

def create_access_token(data: dict[str, Any], expires_delta: timedelta | None = None) -> str:
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire, "iat": datetime.now(timezone.utc)})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def decode_token(token: str) -> dict[str, Any]:
    try:
        return jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    except JWTError as e:
        raise ValueError(f"Token ไม่ถูกต้อง: {e}") from e
```

**Dependency สำหรับ Authentication:**

```python
# auth/dependencies.py
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from auth.jwt_handler import decode_token

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/token")

def get_current_user(token: str = Depends(oauth2_scheme)) -> dict:
    try:
        payload = decode_token(token)
        user_id = payload.get("sub")
        if not user_id:
            raise ValueError("ไม่มี subject ใน token")
        return {"user_id": user_id, "roles": payload.get("roles", [])}
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e),
            headers={"WWW-Authenticate": "Bearer"},
        )

def require_role(role: str):
    def checker(user: dict = Depends(get_current_user)) -> dict:
        if role not in user["roles"]:
            raise HTTPException(status_code=403, detail=f"ต้องมี role: {role}")
        return user
    return checker
```

**การใช้งาน:**

```python
@app.get("/me")
def read_me(user: dict = Depends(get_current_user)):
    return user

@app.delete("/admin/users/{user_id}")
def delete_user(user_id: str, user: dict = Depends(require_role("admin"))):
    return {"deleted": user_id}
```

**ข้อควรระวัง:**
- เก็บ SECRET_KEY ใน environment variable ไม่ใช่ในโค้ด
- ใช้ HTTPS เท่านั้น
- ตั้ง expiration สั้น (15-30 นาที) และใช้ refresh token
- อย่าเก็บข้อมูลสำคัญใน payload (JWT ไม่ได้เข้ารหัส แค่ลงนาม)


### 12.62 Celery

**คืออะไร:** ระบบ distributed task queue สำหรับรันงานเบื้องหลัง (background jobs) แบบ async

**การติดตั้ง:**

```bash
pip install celery[redis] flower
```

**ตัวอย่างการใช้งาน:**

```python
# celery_app.py
from celery import Celery
from celery.schedules import crontab

app = Celery(
    "myapp",
    broker="redis://localhost:6379/0",
    backend="redis://localhost:6379/1",
)

app.conf.update(
    task_serializer="json",
    accept_content=["json"],
    result_serializer="json",
    timezone="Asia/Bangkok",
    enable_utc=True,
    task_acks_late=True,
    worker_prefetch_multiplier=1,
    task_time_limit=600,
)

app.conf.beat_schedule = {
    "cleanup-old-sessions": {
        "task": "tasks.cleanup_sessions",
        "schedule": crontab(hour=3, minute=0),  # ทุกวัน 03:00
    },
}
```

**Tasks:**

```python
# tasks.py
from celery_app import app
import time

@app.task(bind=True, max_retries=3, default_retry_delay=60)
def send_email(self, to: str, subject: str, body: str) -> dict:
    try:
        # จำลองการส่งอีเมล
        time.sleep(2)
        return {"status": "sent", "to": to}
    except Exception as exc:
        raise self.retry(exc=exc)

@app.task
def process_image(image_path: str) -> str:
    from PIL import Image
    img = Image.open(image_path)
    img.thumbnail((800, 800))
    output_path = image_path.replace(".", "_thumb.")
    img.save(output_path)
    return output_path

@app.task
def cleanup_sessions() -> int:
    # ลบ sessions เก่า
    return 42
```

**การเรียกใช้จาก API:**

```python
from fastapi import FastAPI
from tasks import send_email, process_image

app = FastAPI()

@app.post("/notify")
def notify(email: str):
    task = send_email.delay(email, "ยินดีต้อนรับ", "ขอบคุณที่สมัคร!")
    return {"task_id": task.id, "status": "queued"}

@app.post("/upload")
def upload(path: str):
    task = process_image.delay(path)
    return {"task_id": task.id}

@app.get("/task/{task_id}")
def task_status(task_id: str):
    from celery.result import AsyncResult
    result = AsyncResult(task_id)
    return {"state": result.state, "result": result.result if result.ready() else None}
```

**การรัน:**

```bash
# รัน worker
celery -A celery_app worker --loglevel=info --concurrency=4

# รัน beat (สำหรับ scheduled tasks)
celery -A celery_app beat --loglevel=info

# รัน Flower (monitoring UI)
celery -A celery_app flower --port=5555
```

**อ้างอิง:** [Celery Documentation](https://docs.celeryq.dev)


### 12.70 Web Scraping

**คืออะไร:** การดึงข้อมูลจากเว็บไซต์อัตโนมัติ

**ตัวอย่างด้วย requests + BeautifulSoup:**

```python
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

def scrape_books(url: str) -> list[dict]:
    response = requests.get(url, timeout=10, headers={
        "User-Agent": "Mozilla/5.0 (compatible; MyBot/1.0)"
    })
    response.raise_for_status()
    soup = BeautifulSoup(response.text, "html.parser")

    books = []
    for article in soup.select("article.product_pod"):
        title = article.select_one("h3 a")["title"]
        price = article.select_one(".price_color").text
        stock = article.select_one(".instock.availability").text.strip()
        books.append({
            "title": title,
            "price": price,
            "stock": stock,
        })
    return books

books = scrape_books("https://books.toscrape.com/")
for b in books[:3]:
    print(b)
```

**ตัวอย่างด้วย Playwright (สำหรับ JavaScript-heavy sites):**

```python
from playwright.sync_api import sync_playwright

def scrape_dynamic(url: str) -> list[dict]:
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto(url, wait_until="networkidle")
        page.wait_for_selector(".product-card", timeout=10000)

        items = page.eval_on_selector_all(
            ".product-card",
            """els => els.map(el => ({
                name: el.querySelector('.name')?.innerText,
                price: el.querySelector('.price')?.innerText,
            }))"""
        )
        browser.close()
        return items
```

**ข้อควรระวัง:**
- ตรวจสอบ `robots.txt` ก่อนเสมอ
- ใส่ `User-Agent` ที่ชัดเจน
- ใช้ rate limiting (sleep ระหว่าง request)
- อย่า scrape ข้อมูลส่วนตัว (ผิด PDPA/GDPR)
- ถ้ามี API ทางการ ใช้ API ดีกว่า

**อ้างอิง:** [Playwright Python](https://playwright.dev/python/)


## ภาค 13: ฐานข้อมูลและระบบจัดเก็บข้อมูล

### 13.1 Relational Database

**คืออะไร:** ฐานข้อมูลที่เก็บข้อมูลเป็นตาราง (relation) มี schema ชัดเจน รองรับ ACID และใช้ SQL ในการ query

**ตัวอย่าง Schema:**

```sql
CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    total DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status_created ON orders(status, created_at DESC);
```

**อ้างอิง:** [PostgreSQL Tutorial](https://www.postgresql.org/docs/current/tutorial.html)


### 13.7 Index

**คืออะไร:** โครงสร้างข้อมูลที่ช่วยให้ query เร็วขึ้น แลกกับพื้นที่จัดเก็บและเวลาเขียน

**ประเภทของ Index:**

```sql
-- B-tree (default) — เหมาะกับ =, <, >, BETWEEN
CREATE INDEX idx_users_email ON users(email);

-- Unique
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);

-- Composite — ลำดับสำคัญ!
CREATE INDEX idx_orders_customer_status ON orders(customer_id, status);
-- ใช้ได้: WHERE customer_id = 1
--         WHERE customer_id = 1 AND status = 'paid'
-- ไม่ใช้เต็มที่: WHERE status = 'paid'  (ข้ามคอลัมน์แรก)

-- Partial — index เฉพาะแถวที่ตรงเงื่อนไข
CREATE INDEX idx_orders_pending ON orders(created_at)
WHERE status = 'pending';

-- GIN — สำหรับ JSONB, array, full-text
CREATE INDEX idx_products_tags ON products USING GIN(tags);

-- Hash — เฉพาะ =
CREATE INDEX idx_sessions_token ON sessions USING HASH(token);
```

**ตรวจสอบการใช้ Index:**

```sql
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE customer_id = 123 AND status = 'paid';
```

**ข้อควรระวัง:**
- Index ทำให้ INSERT/UPDATE/DELETE ช้าลง
- อย่า index ทุกคอลัมน์ — วิเคราะห์ query ก่อน
- Index ที่ไม่ถูกใช้ควรลบออก (ตรวจด้วย `pg_stat_user_indexes`)


### 13.8 Transaction & 13.10 Isolation Level

**คืออะไร:** Transaction คือกลุ่ม operation ที่ต้องสำเร็จทั้งหมดหรือล้มเหลวทั้งหมด

**ตัวอย่างด้วย psycopg:**

```python
import psycopg

with psycopg.connect("postgresql://user:pass@localhost/db") as conn:
    with conn.transaction():
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE accounts SET balance = balance - %s WHERE id = %s",
                (100, 1),
            )
            cur.execute(
                "UPDATE accounts SET balance = balance + %s WHERE id = %s",
                (100, 2),
            )
        # commit อัตโนมัติเมื่อออกจาก with
```

**Isolation Levels:**

| Level | Dirty Read | Non-repeatable Read | Phantom Read | ใช้เมื่อ |
|-------|-----------|---------------------|--------------|---------|
| Read Uncommitted | ✅ | ✅ | ✅ | ไม่แนะนำ |
| Read Committed | ❌ | ✅ | ✅ | Default ของ PostgreSQL |
| Repeatable Read | ❌ | ❌ | ❌* | ต้องการ consistency |
| Serializable | ❌ | ❌ | ❌ | การเงิน, ข้อมูลสำคัญ |

**ตัวอย่างการตั้ง Isolation Level:**

```python
with conn.transaction(isolation_level="SERIALIZABLE"):
    # ...
    pass
```

**แนวปฏิบัติ:** ใช้ Read Committed เป็น default, ใช้ Serializable สำหรับการเงิน, retry เมื่อเกิด serialization failure


### 13.22 SQLAlchemy

**คืออะไร:** ORM และ SQL toolkit ที่ได้รับความนิยมสูงสุดใน Python รองรับทั้ง Core (SQL expression) และ ORM

**Modern SQLAlchemy 2.0 style:**

```python
# models.py
from datetime import datetime
from decimal import Decimal
from sqlalchemy import String, ForeignKey, Numeric, DateTime, func
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship

class Base(DeclarativeBase):
    pass

class Customer(Base):
    __tablename__ = "customers"

    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    name: Mapped[str] = mapped_column(String(100))
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    orders: Mapped[list["Order"]] = relationship(
        back_populates="customer", cascade="all, delete-orphan"
    )

class Order(Base):
    __tablename__ = "orders"

    id: Mapped[int] = mapped_column(primary_key=True)
    customer_id: Mapped[int] = mapped_column(ForeignKey("customers.id"), index=True)
    status: Mapped[str] = mapped_column(String(20), default="pending")
    total: Mapped[Decimal] = mapped_column(Numeric(12, 2))
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    customer: Mapped[Customer] = relationship(back_populates="orders")
```

**Session Management:**

```python
# db.py
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from contextlib import contextmanager

engine = create_engine(
    "postgresql+psycopg://user:pass@localhost/db",
    pool_size=10,
    max_overflow=20,
    pool_pre_ping=True,
    echo=False,
)

SessionLocal = sessionmaker(bind=engine, expire_on_commit=False)

@contextmanager
def get_session() -> Session:
    session = SessionLocal()
    try:
        yield session
        session.commit()
    except Exception:
        session.rollback()
        raise
    finally:
        session.close()
```

**Query 2.0 style:**

```python
from sqlalchemy import select, func
from models import Customer, Order

with get_session() as session:
    # SELECT
    stmt = select(Customer).where(Customer.email == "somchai@example.com")
    customer = session.scalars(stmt).first()

    # JOIN + aggregate
    stmt = (
        select(Customer.name, func.count(Order.id).label("order_count"))
        .join(Order)
        .group_by(Customer.id)
        .having(func.count(Order.id) > 5)
    )
    for name, count in session.execute(stmt):
        print(f"{name}: {count} ออเดอร์")

    # Eager loading (แก้ N+1)
    stmt = select(Customer).options(
        selectinload(Customer.orders)
    ).limit(10)
    customers = session.scalars(stmt).all()

    # INSERT
    new_customer = Customer(email="new@example.com", name="ลูกค้าใหม่")
    session.add(new_customer)

    # UPDATE
    customer.name = "ชื่อใหม่"

    # DELETE
    session.delete(customer)
```

**อ้างอิง:** [SQLAlchemy 2.0 Documentation](https://docs.sqlalchemy.org/en/20/)


### 13.42 Vector Database

**คืออะไร:** ฐานข้อมูลที่ออกแบบสำหรับเก็บและค้นหา embedding vector (ใช้ใน semantic search, RAG)

**ตัวอย่างด้วย pgvector:**

```sql
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE documents (
    id BIGSERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    embedding vector(1536)  -- OpenAI text-embedding-3-small
);

-- HNSW index สำหรับ approximate nearest neighbor
CREATE INDEX ON documents USING hnsw (embedding vector_cosine_ops);
```

```python
# pgvector_demo.py
import psycopg
from pgvector.psycopg import register_vector
from openai import OpenAI

client = OpenAI()
conn = psycopg.connect("postgresql://user:pass@localhost/db", autocommit=True)
register_vector(conn)

def embed(text: str) -> list[float]:
    response = client.embeddings.create(
        model="text-embedding-3-small",
        input=text,
    )
    return response.data[0].embedding

# Insert
docs = [
    "Python เป็นภาษาโปรแกรมมิ่งที่นิยมใช้ใน data science",
    "FastAPI เป็น web framework ที่รองรับ async",
    "PostgreSQL เป็น relational database ที่ทรงพลัง",
]
with conn.cursor() as cur:
    for doc in docs:
        cur.execute(
            "INSERT INTO documents (content, embedding) VALUES (%s, %s)",
            (doc, embed(doc)),
        )

# Semantic search
query = "web framework สำหรับ Python"
query_vec = embed(query)
with conn.cursor() as cur:
    cur.execute(
        """
        SELECT content, 1 - (embedding <=> %s) AS similarity
        FROM documents
        ORDER BY embedding <=> %s
        LIMIT 3
        """,
        (query_vec, query_vec),
    )
    for content, similarity in cur.fetchall():
        print(f"{similarity:.3f}  {content}")
```

**เปรียบเทียบ Vector DB:**

| DB | จุดเด่น | เหมาะกับ |
|----|--------|---------|
| pgvector | ใช้ PostgreSQL เดิม | โปรเจกต์เล็ก-กลาง |
| Pinecone | Managed, scale ง่าย | Production, ไม่ต้องดูแล |
| Weaviate | Hybrid search, module | Semantic + keyword |
| Milvus | Performance สูง | ข้อมูลขนาดใหญ่ |
| Chroma | เบา, ฝังในแอป | Prototype, RAG เล็ก |
| Qdrant | Rust, เร็ว | Performance + filter |

**อ้างอิง:** [pgvector GitHub](https://github.com/pgvector/pgvector)


### 13.58 Airflow

**คืออะไร:** Platform สำหรับเขียน, schedule และ monitor data pipeline (workflow orchestration)

**ตัวอย่าง DAG:**

```python
# dags/sales_etl.py
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook

default_args = {
    "owner": "data-team",
    "retries": 3,
    "retry_delay": timedelta(minutes=5),
    "email_on_failure": True,
    "email": ["data-alerts@example.com"],
}

def extract_sales(**context):
    hook = PostgresHook(postgres_conn_id="source_db")
    df = hook.get_pandas_df(
        "SELECT * FROM sales WHERE date = %(ds)s",
        parameters={"ds": context["ds"]},
    )
    context["ti"].xcom_push(key="row_count", value=len(df))
    df.to_parquet(f"/tmp/sales_{context['ds']}.parquet")

def transform_sales(**context):
    import pandas as pd
    df = pd.read_parquet(f"/tmp/sales_{context['ds']}.parquet")
    df["revenue"] = df["quantity"] * df["unit_price"]
    df = df.groupby("product_id").agg(
        total_revenue=("revenue", "sum"),
        total_quantity=("quantity", "sum"),
    ).reset_index()
    df.to_parquet(f"/tmp/sales_agg_{context['ds']}.parquet")

def load_sales(**context):
    import pandas as pd
    df = pd.read_parquet(f"/tmp/sales_agg_{context['ds']}.parquet")
    hook = PostgresHook(postgres_conn_id="warehouse_db")
    hook.insert_rows(
        table="fact_sales_daily",
        rows=df.values.tolist(),
        target_fields=df.columns.tolist(),
    )

with DAG(
    "sales_etl",
    default_args=default_args,
    description="ETL ขายรายวัน",
    schedule="0 2 * * *",
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=["etl", "sales"],
) as dag:

    create_table = PostgresOperator(
        task_id="create_table",
        postgres_conn_id="warehouse_db",
        sql="""
            CREATE TABLE IF NOT EXISTS fact_sales_daily (
                product_id INT,
                total_revenue NUMERIC(12,2),
                total_quantity INT,
                etl_date DATE DEFAULT CURRENT_DATE
            );
        """,
    )

    extract = PythonOperator(task_id="extract", python_callable=extract_sales)
    transform = PythonOperator(task_id="transform", python_callable=transform_sales)
    load = PythonOperator(task_id="load", python_callable=load_sales)

    create_table >> extract >> transform >> load
```

**อ้างอิง:** [Apache Airflow Documentation](https://airflow.apache.org/docs/)


## ภาค 31: ข้อมูลและ Data Platform เพิ่มเติม

### 31.3 Data Lake & 31.4 Lakehouse

**คืออะไร:**
- **Data Lake** — เก็บข้อมูลดิบทุกชนิด (structured, semi, unstructured) ในที่เดียว เช่น S3, GCS
- **Lakehouse** — รวมข้อดีของ Data Lake + Data Warehouse: ACID, schema, performance

**เปรียบเทียบ:**

| คุณสมบัติ | Data Warehouse | Data Lake | Lakehouse |
|----------|---------------|-----------|-----------|
| ข้อมูล | Structured | ทุกชนิด | ทุกชนิด |
| Schema | Schema-on-write | Schema-on-read | Hybrid |
| ACID | ✅ | ❌ | ✅ |
| Cost | แพง | ถูก | กลาง |
| Use case | BI, reporting | ML, exploration | ทั้งหมด |

**เทคโนโลยี Lakehouse:**

```python
# Delta Lake ตัวอย่าง
from deltalake import DeltaTable, write_deltalake
import pandas as pd

# เขียน
df = pd.DataFrame({"id": [1, 2, 3], "value": [10.0, 20.0, 30.0]})
write_deltalake("./delta/sales", df, mode="overwrite")

# Merge (upsert)
from deltalake import DeltaTable
dt = DeltaTable("./delta/sales")
new_data = pd.DataFrame({"id": [2, 4], "value": [25.0, 40.0]})
dt.merge(
    source=new_data,
    predicate="target.id = source.id",
    source_alias="source",
    target_alias="target",
).when_matched_update({"value": "source.value"}) \
 .when_not_matched_insert_all() \
 .execute()

# Time travel
old_version = DeltaTable("./delta/sales", version=0)
print(old_version.to_pandas())
```

**อ้างอิง:** [Delta Lake Documentation](https://docs.delta.io/)


### 31.56 RAG (Retrieval-Augmented Generation)

**คืออะไร:** เทคนิคที่ให้ LLM ตอบคำถามโดยอ้างอิงจากเอกสารที่ retrieve มาได้ ช่วยลด hallucination

**Pipeline:**

```
Question → Embed → Vector Search → Top-K Docs → LLM (Prompt + Docs) → Answer
```

**ตัวอย่างสมบูรณ์ด้วย LangChain + pgvector:**

```python
# rag_pipeline.py
from langchain_openai import ChatOpenAI, OpenAIEmbeddings
from langchain_postgres import PGVector
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_core.documents import Document
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser

# 1. โหลดและแบ่งเอกสาร
def load_and_split(path: str) -> list[Document]:
    with open(path, encoding="utf-8") as f:
        text = f.read()
    splitter = RecursiveCharacterTextSplitter(
        chunk_size=500,
        chunk_overlap=50,
        separators=["\n\n", "\n", " ", ""],
    )
    return splitter.create_documents([text])

docs = load_and_split("manual.md")

# 2. สร้าง vector store
embeddings = OpenAIEmbeddings(model="text-embedding-3-small")
vectorstore = PGVector.from_documents(
    documents=docs,
    embedding=embeddings,
    collection_name="manual",
    connection="postgresql+psycopg://user:pass@localhost/db",
)
retriever = vectorstore.as_retriever(search_kwargs={"k": 4})

# 3. สร้าง RAG chain
prompt = ChatPromptTemplate.from_template("""
ตอบคำถามโดยอ้างอิงจาก context ด้านล่างเท่านั้น
ถ้าไม่พบคำตอบใน context ให้ตอบว่า "ไม่พบข้อมูลในเอกสาร"

Context:
{context}

คำถาม: {question}

คำตอบ:""")

llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)

def format_docs(docs: list[Document]) -> str:
    return "\n\n".join(d.page_content for d in docs)

chain = (
    {"context": retriever | format_docs, "question": RunnablePassthrough()}
    | prompt
    | llm
    | StrOutputParser()
)

# 4. ใช้งาน
answer = chain.invoke("วิธีติดตั้งเป็นอย่างไร?")
print(answer)
```

**เทคนิคเพิ่มความแม่นยำ:**
- **Chunking ที่ดี** — แบ่งตามโครงสร้าง (heading, paragraph)
- **Hybrid Search** — รวม vector + keyword (BM25)
- **Reranking** — ใช้ cross-encoder จัดอันดับใหม่
- **Metadata Filtering** — กรองตามวันที่, หมวดหมู่
- **Query Rewriting** — ให้ LLM เขียน query ใหม่ให้ชัดเจน

**อ้างอิง:** [LangChain RAG Tutorial](https://python.langchain.com/docs/tutorials/rag/)


### 31.65 GDPR & 31.66 PDPA

**คืออะไร:**
- **GDPR** (General Data Protection Regulation) — กฎหมายคุ้มครองข้อมูลส่วนบุคคลของ EU
- **PDPA** (Personal Data Protection Act) — กฎหมายไทย พ.ศ. 2562

**หลักการสำคัญ:**

| หลักการ | GDPR | PDPA | การปฏิบัติ |
|--------|------|------|-----------|
| Consent | ✅ | ✅ | ขอความยินยอมชัดเจน |
| Right to Access | ✅ | ✅ | ให้ผู้ใช้ดูข้อมูลตัวเอง |
| Right to Erasure | ✅ | ✅ | ลบข้อมูลตามคำขอ |
| Data Portability | ✅ | ✅ | export ข้อมูลเป็น JSON/CSV |
| Breach Notification | 72 ชม. | 72 ชม. | แจ้งหน่วยงาน |
| DPO | บังคับบางกรณี | บังคับบางกรณี | ตั้งผู้รับผิดชอบ |

**การ implement Right to Erasure:**

```python
# services/gdpr_service.py
from sqlalchemy import delete, update
from models import User, Order, AuditLog
from db import get_session

class GDPRService:
    def __init__(self, session):
        self.session = session

    def erase_user_data(self, user_id: int) -> dict:
        """ลบข้อมูลส่วนตัว แต่เก็บข้อมูลที่ต้องเก็บตามกฎหมาย"""
        # 1. Anonymize ข้อมูลใน audit log (ต้องเก็บ 5 ปีตามกฎหมาย)
        self.session.execute(
            update(AuditLog)
            .where(AuditLog.user_id == user_id)
            .values(
                user_id=None,
                ip_address=None,
                user_agent="[REDACTED]",
            )
        )

        # 2. Anonymize ข้อมูลใน order (ต้องเก็บเพื่อบัญชี)
        self.session.execute(
            update(Order)
            .where(Order.customer_id == user_id)
            .values(customer_name="[DELETED]", customer_email="deleted@example.com")
        )

        # 3. ลบข้อมูลส่วนตัวจริงๆ
        self.session.execute(delete(User).where(User.id == user_id))

        self.session.commit()
        return {"status": "erased", "user_id": user_id}

    def export_user_data(self, user_id: int) -> dict:
        """Right to Data Portability"""
        user = self.session.get(User, user_id)
        orders = self.session.query(Order).filter_by(customer_id=user_id).all()
        return {
            "user": {
                "email": user.email,
                "name": user.name,
                "created_at": user.created_at.isoformat(),
            },
            "orders": [
                {"id": o.id, "total": str(o.total), "status": o.status}
                for o in orders
            ],
        }
```

**แนวปฏิบัติ:**
- เก็บข้อมูลเท่าที่จำเป็น (Data Minimization)
- เข้ารหัสข้อมูล sensitive (PII) at rest และ in transit
- Log การเข้าถึงข้อมูลส่วนบุคคล
- ทำ Data Processing Agreement กับ vendor
- อบรมพนักงานเรื่อง PDPA/GDPR

**อ้างอิง:** [PDPC Thailand](https://www.pdpc.or.th), [GDPR.eu](https://gdpr.eu)


## สรุป

หนังสือเล่ม 5 ครอบคลุมการพัฒนาเว็บ API และฐานข้อมูลอย่างครบวงจร:

1. **พื้นฐานเว็บ** — HTTP, methods, status codes, WSGI/ASGI
2. **Frameworks** — Django + DDD, FastAPI + DDD, Pydantic
3. **Security** — JWT, OAuth2, การจัดการ authentication/authorization
4. **Background Jobs** — Celery สำหรับ async tasks
5. **Web Scraping** — requests, BeautifulSoup, Playwright
6. **ฐานข้อมูล** — SQL, Index, Transaction, SQLAlchemy 2.0
7. **Modern Data** — Vector DB, pgvector, RAG
8. **Data Platform** — Airflow, Lakehouse, Delta Lake
9. **กฎหมาย** — GDPR, PDPA และการ implement

**หลักการสำคัญ:**
- ออกแบบ API ให้ RESTful และ consistent
- แยก business logic ออกจาก framework (DDD)
- ใช้ Pydantic validate ทุก input
- ใช้ connection pooling และ index อย่างชาญฉลาด
- ระวัง N+1 query และใช้ eager loading
- เก็บข้อมูลเท่าที่จำเป็น (PDPA/GDPR)
- ใช้ async เมื่อมี I/O-bound operations

**แหล่งอ้างอิงหลัก:**
- [FastAPI Documentation](https://fastapi.tiangolo.com)
- [SQLAlchemy 2.0](https://docs.sqlalchemy.org/en/20/)
- [Pydantic](https://docs.pydantic.dev)
- [Celery](https://docs.celeryq.dev)
- [pgvector](https://github.com/pgvector/pgvector)
- [LangChain RAG](https://python.langchain.com/docs/tutorials/rag/)
- [Apache Airflow](https://airflow.apache.org/docs/)
- [PDPC Thailand](https://www.pdpc.or.th)