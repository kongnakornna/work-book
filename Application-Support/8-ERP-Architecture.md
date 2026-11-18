## เล่ม 8: ERP Architecture (DDD) — "สาย Developer / Tech Lead"

> **ผู้แต่ง:** kongnakorn jantakun
> **อีเมล:** kongnakornjantakun@gmail.com
> **สถานะ:** ต้นฉบับ
> **กลุ่มงาน:** ERP Developer, Solution Architect, Tech Lead
> **Dependency:** อ่านเล่ม 1 (Foundation & Workflow) และเล่ม 3 (Application Metrics & Metrics Platform) ก่อน
> **เวอร์ชัน:** 1.0

---

## บทนำ

### วัตถุประสงค์ของเล่ม

ERP (Enterprise Resource Planning) เป็นระบบที่ซับซ้อนที่สุดในองค์กร — มี Domain หลายตัว (Order, Inventory, Billing, Accounting, HR) ที่ทำงานข้ามกัน การออกแบบด้วย **DDD (Domain-Driven Design)** เป็นวิธีเดียวที่ทำให้ ERP ขนาดใหญ่ maintain ได้ในระยะยาว เล่มนี้ครอบคลุม **DDD ใน 3 ภาษา** (Python, Golang, Node.js TypeScript) เพื่อให้ Developer/Tech Lead เลือกใช้ตาม Stack ของทีม เมื่ออ่านจบ ผู้อ่านจะสามารถ:

1. ออกแบบ **Bounded Context** ของ ERP ที่แยกขอบเขตชัดเจน
2. Implement **Aggregate Root, Repository, Domain Event** ในทั้ง 3 ภาษา
3. เลือกใช้ **Hexagonal Architecture** (Go) หรือ **NestJS Module + DDD** (TypeScript) ตามบริบท
4. Instrument **Prometheus Metrics** ใน Application ที่สร้าง
5. หลีกเลี่ยง **Anti-pattern** ที่พบบ่อยใน ERP DDD
6. ออกแบบ **Domain Event** ที่รองรับ Integration Layer (เล่ม 10)

### เป้าหมายของเล่ม

| เป้าหมาย | ตัวชี้วัดความสำเร็จ |
|---|---|
| Bounded Context ชัดเจน | ไม่มี "God Model" ที่ทุก Context ใช้ร่วม |
| Aggregate Root ถูกต้อง | Invariant ถูก protect ภายใน Aggregate เดียว |
| Repository แยก Domain จาก Infrastructure | Domain Layer ไม่ import ORM |
| Domain Event ทำงาน | Integration Layer subscribe ได้ (เล่ม 10) |
| Application Monitor ได้ | Prometheus Metrics ครบ RED Method |

### สิ่งที่ **ไม่** อยู่ในเล่มนี้

- Prometheus/Grafana/Alertmanager ติดตั้ง → **เล่ม 3**
- Database Operations (PostgreSQL, Oracle, MSSQL, MongoDB) → **เล่ม 9**
- Integration Patterns (Outbox, Saga, Cache-Aside) → **เล่ม 10**
- Workflow PSR/RCA/KPI SMART → **เล่ม 1**

### ทำไมทั้งสามภาษาอยู่เล่มเดียวกัน

ทั้ง Python, Golang, และ Node.js TypeScript แก้ปัญหาเดียวกัน (**ERP Domain Modeling**) — การเปรียบเทียบข้ามภาษาทำให้เข้าใจ DDD ลึกขึ้น เพราะแต่ละภาษามี idiom ต่างกัน:

| ภาษา | จุดเด่น | ใช้เมื่อ |
|---|---|---|
| **Python** | อ่านง่าย, Ecosystem เยอะ, Rapid Development | MVP, Data-heavy, AI Integration |
| **Go** | Performance, Concurrency, Type Safety (static) | High-throughput, Microservice, Infrastructure |
| **TypeScript (NestJS)** | Type Safety + DI, Ecosystem เยอะ, Frontend-sharing | Full-stack, Team คุ้น JS |

> **กฎ:** เลือกภาษาตาม **ทีม** ไม่ใช่ตาม Trend — DDD ที่ดีทำได้ทุกภาษา

---

## บทนิยาม (เฉพาะคำศัพท์ใหม่ในเล่มนี้)

| คำศัพท์ | ความหมาย |
|---|---|
| **DDD (Domain-Driven Design)** | วิธีการออกแบบซอฟต์แวร์ที่เน้น Domain Model เป็นศูนย์กลาง (Eric Evans, 2003) |
| **Bounded Context** | ขอบเขตของ Domain Model ที่มีความหมายเฉพาะ (Order ใน Sales ≠ Order ใน Billing) |
| **Ubiquitous Language** | ภาษากลางที่ Developer + Domain Expert ใช้ร่วมกัน (เช่น "Order" หมายถึงอะไรชัดเจน) |
| **Aggregate** | กลุ่มของ Entity ที่ถูก treat เป็นหน่วยเดียว (Order + OrderLine) |
| **Aggregate Root** | Entity หลักของ Aggregate — เป็นทางเข้าเดียว (Order เป็น Root ของ OrderLine) |
| **Entity** | Object ที่มี Identity (Order, Customer) |
| **Value Object** | Object ที่ไม่มี Identity (Money, Address, Email) — Immutable |
| **Domain Event** | เหตุการณ์ที่เกิดขึ้นใน Domain (`OrderPlaced`, `InvoicePaid`) |
| **Repository** | Abstraction สำหรับดึง/เก็บ Aggregate (interface ใน Domain, implement ใน Infrastructure) |
| **Use Case / Application Service** | orchestrate Domain Logic + Transaction (เช่น `PlaceOrderUseCase`) |
| **Hexagonal Architecture** | สถาปัตยกรรมที่แยก Core (Domain) ออกจาก Adapter (DB, HTTP, Message) |
| **Port** | Interface ที่ Domain ประกาศ (Repository, EventPublisher) |
| **Adapter** | Implementation ของ Port (PostgresRepository, KafkaPublisher) |
| **Anti-Corruption Layer (ACL)** | ชั้นแปลข้อมูลระหว่าง 2 Bounded Context (กัน Domain อีกฝั่งทะลุเข้ามา) |
| **Invariant** | กฎที่ต้องเป็นจริงเสมอ (Order ต้องมี Item ≥ 1) — protect ใน Aggregate |
| **Dependency Injection (DI)** | การฉีด Dependency เข้า Constructor (ทำให้ test ได้) |
| **Unit of Work** | การรวมหลาย Repository Operation ใน Transaction เดียว |
| **Error Boundary** | จุดที่ catch error และแปลงเป็น HTTP error (Presentation Layer) |

---

## บทหัวข้อ

---

## 8.1 Python DDD (Bounded Context, Aggregate Root, Repository Pattern, Domain Event)

### เรื่อง
การ implement DDD ใน Python สำหรับ ERP — เน้น Bounded Context, Aggregate Root, Repository, และ Domain Event

### วัตถุประสงค์ / เป้าหมาย
- แยก Layer ชัดเจน: `domain/`, `application/`, `infrastructure/`, `presentation/`
- Aggregate Root protect Invariant
- Repository แยก Domain จาก ORM
- Domain Event พร้อมส่งต่อ Integration Layer (เล่ม 10)

### เนื้อหา / รายละเอียด

#### โครงสร้าง Project (Python DDD)

```
erp-order-service/
├── src/
│   ├── domain/                    # ← Business Logic บริสุทธิ์
│   │   ├── order/
│   │   │   ├── aggregate.py        # Order (Aggregate Root)
│   │   │   ├── entities.py         # OrderLine
│   │   │   ├── value_objects.py    # Money, OrderId, Address
│   │   │   ├── events.py           # OrderPlaced, OrderShipped
│   │   │   ├── repository.py       # OrderRepository (interface)
│   │   │   └── exceptions.py       # OrderDomainError
│   │   └── shared/
│   │       └── value_objects.py    # Money, Currency
│   ├── application/               # ← Orchestration
│   │   ├── use_cases/
│   │   │   ├── place_order.py      # PlaceOrderUseCase
│   │   │   └── ship_order.py
│   │   └── ports/
│   │       ├── event_publisher.py  # EventPublisher (interface)
│   │       └── unit_of_work.py     # UnitOfWork (interface)
│   ├── infrastructure/            # ← Implementation
│   │   ├── persistence/
│   │   │   ├── models.py           # SQLAlchemy models
│   │   │   ├── order_repository.py # PostgresOrderRepository
│   │   │   └── unit_of_work.py
│   │   ├── messaging/
│   │   │   └── kafka_publisher.py  # KafkaEventPublisher
│   │   └── observability/
│   │       └── metrics.py          # Prometheus metrics
│   └── presentation/              # ← HTTP/FastAPI
│       ├── api/
│       │   └── order_routes.py
│       └── middleware/
│           └── metrics_middleware.py
├── tests/
│   ├── unit/                      # Domain + Application (ไม่ต้อง DB)
│   └── integration/               # Infrastructure (ต้อง DB)
└── pyproject.toml
```

#### Domain Layer — Aggregate Root

```python
# src/domain/order/aggregate.py
from dataclasses import dataclass, field
from datetime import datetime
from decimal import Decimal
from typing import List, Optional
from uuid import UUID, uuid4

from src.domain.order.value_objects import Money, OrderId, CustomerId, OrderStatus
from src.domain.order.entities import OrderLine
from src.domain.order.events import OrderPlaced, OrderLineAdded
from src.domain.order.exceptions import (
    OrderAlreadyConfirmedError,
    EmptyOrderError,
    InvalidQuantityError,
)


@dataclass
class Order:
    """Order = Aggregate Root

    Invariants:
    - Order ต้องมี OrderLine ≥ 1 ก่อนยืนยัน
    - Quantity ต้อง > 0
    - ยืนยันแล้วห้ามแก้
    """
    id: OrderId
    customer_id: CustomerId
    status: OrderStatus = OrderStatus.DRAFT
    lines: List[OrderLine] = field(default_factory=list)
    created_at: datetime = field(default_factory=datetime.utcnow)
    _events: List = field(default_factory=list, repr=False)

    # ── Factory Method ──────────────────────────────
    @classmethod
    def create(cls, customer_id: CustomerId) -> "Order":
        return cls(
            id=OrderId(uuid4()),
            customer_id=customer_id,
        )

    # ── Business Methods ────────────────────────────
    def add_line(self, product_id: str, quantity: int, unit_price: Money) -> None:
        if self.status != OrderStatus.DRAFT:
            raise OrderAlreadyConfirmedError(self.id)

        if quantity <= 0:
            raise InvalidQuantityError(quantity)

        line = OrderLine(
            product_id=product_id,
            quantity=quantity,
            unit_price=unit_price,
        )
        self.lines.append(line)
        self._events.append(OrderLineAdded(
            order_id=self.id,
            product_id=product_id,
            quantity=quantity,
        ))

    def confirm(self) -> None:
        if self.status != OrderStatus.DRAFT:
            raise OrderAlreadyConfirmedError(self.id)

        if not self.lines:
            raise EmptyOrderError(self.id)

        self.status = OrderStatus.CONFIRMED
        self._events.append(OrderPlaced(
            order_id=self.id,
            customer_id=self.customer_id,
            total_amount=self.total_amount(),
            lines_count=len(self.lines),
            occurred_at=datetime.utcnow(),
        ))

    # ── Read-Only Queries ───────────────────────────
    def total_amount(self) -> Money:
        return sum((line.subtotal() for line in self.lines), start=Money(Decimal("0")))

    # ── Domain Events ───────────────────────────────
    def collect_events(self) -> List:
        events = self._events.copy()
        self._events.clear()
        return events
```

#### Value Object

```python
# src/domain/order/value_objects.py
from dataclasses import dataclass
from decimal import Decimal
from uuid import UUID
from enum import Enum


@dataclass(frozen=True)  # ← Immutable
class Money:
    amount: Decimal
    currency: str = "THB"

    def __post_init__(self):
        if self.amount < 0:
            raise ValueError("Amount cannot be negative")
        if self.currency not in ("THB", "USD", "EUR"):
            raise ValueError(f"Unsupported currency: {self.currency}")

    def __add__(self, other: "Money") -> "Money":
        if self.currency != other.currency:
            raise ValueError("Cannot add different currencies")
        return Money(self.amount + other.amount, self.currency)

    def __mul__(self, multiplier: int) -> "Money":
        return Money(self.amount * multiplier, self.currency)


@dataclass(frozen=True)
class OrderId:
    value: UUID

    def __str__(self) -> str:
        return str(self.value)


@dataclass(frozen=True)
class CustomerId:
    value: UUID


class OrderStatus(str, Enum):
    DRAFT = "draft"
    CONFIRMED = "confirmed"
    SHIPPED = "shipped"
    CANCELLED = "cancelled"
```

#### Entity (OrderLine)

```python
# src/domain/order/entities.py
from dataclasses import dataclass
from src.domain.order.value_objects import Money


@dataclass
class OrderLine:
    """Entity ที่มี Identity ภายใน Aggregate"""
    product_id: str
    quantity: int
    unit_price: Money

    def subtotal(self) -> Money:
        return self.unit_price * self.quantity
```

#### Domain Event

```python
# src/domain/order/events.py
from dataclasses import dataclass
from datetime import datetime
from decimal import Decimal
from src.domain.order.value_objects import OrderId, CustomerId


@dataclass(frozen=True)
class OrderLineAdded:
    order_id: OrderId
    product_id: str
    quantity: int


@dataclass(frozen=True)
class OrderPlaced:
    order_id: OrderId
    customer_id: CustomerId
    total_amount: object  # Money
    lines_count: int
    occurred_at: datetime

    @property
    def event_type(self) -> str:
        return "order.placed"
```

#### Repository (Interface)

```python
# src/domain/order/repository.py
from abc import ABC, abstractmethod
from typing import Optional
from src.domain.order.aggregate import Order
from src.domain.order.value_objects import OrderId


class OrderRepository(ABC):
    """Port — Domain ประกาศ, Infrastructure implement"""

    @abstractmethod
    async def save(self, order: Order) -> None: ...

    @abstractmethod
    async def find_by_id(self, order_id: OrderId) -> Optional[Order]: ...

    @abstractmethod
    async def next_id(self) -> OrderId: ...
```

#### Application Layer — Use Case

```python
# src/application/use_cases/place_order.py
from dataclasses import dataclass
from typing import List
from decimal import Decimal

from src.domain.order.aggregate import Order
from src.domain.order.value_objects import CustomerId, Money, OrderId
from src.domain.order.repository import OrderRepository
from src.application.ports.event_publisher import EventPublisher
from src.application.ports.unit_of_work import UnitOfWork


@dataclass
class OrderLineInput:
    product_id: str
    quantity: int
    unit_price: Decimal


@dataclass
class PlaceOrderInput:
    customer_id: str
    lines: List[OrderLineInput]


class PlaceOrderUseCase:
    """Application Service — orchestrate Domain + Infrastructure"""

    def __init__(
        self,
        order_repo: OrderRepository,
        event_publisher: EventPublisher,
        uow: UnitOfWork,
    ):
        self.order_repo = order_repo
        self.event_publisher = event_publisher
        self.uow = uow

    async def execute(self, input: PlaceOrderInput) -> OrderId:
        # 1. Build Aggregate
        order = Order.create(customer_id=CustomerId(input.customer_id))

        for line in input.lines:
            order.add_line(
                product_id=line.product_id,
                quantity=line.quantity,
                unit_price=Money(line.unit_price),
            )

        order.confirm()

        # 2. Persist + Publish (Transactional)
        async with self.uow:
            await self.order_repo.save(order)
            for event in order.collect_events():
                await self.event_publisher.publish(event)

        return order.id
```

#### Infrastructure — PostgreSQL Repository

```python
# src/infrastructure/persistence/order_repository.py
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload

from src.domain.order.aggregate import Order
from src.domain.order.entities import OrderLine
from src.domain.order.value_objects import (
    OrderId, CustomerId, Money, OrderStatus,
)
from src.domain.order.repository import OrderRepository
from src.infrastructure.persistence.models import OrderModel, OrderLineModel


class PostgresOrderRepository(OrderRepository):
    def __init__(self, session: AsyncSession):
        self.session = session

    async def save(self, order: Order) -> None:
        model = await self.session.get(OrderModel, order.id.value)
        if model is None:
            model = OrderModel(
                id=order.id.value,
                customer_id=order.customer_id.value,
                status=order.status.value,
                created_at=order.created_at,
            )
            self.session.add(model)

        model.status = order.status.value
        model.lines = [
            OrderLineModel(
                order_id=order.id.value,
                product_id=line.product_id,
                quantity=line.quantity,
                unit_price=line.unit_price.amount,
                currency=line.unit_price.currency,
            )
            for line in order.lines
        ]

    async def find_by_id(self, order_id: OrderId) -> Optional[Order]:
        result = await self.session.execute(
            select(OrderModel)
            .where(OrderModel.id == order_id.value)
            .options(selectinload(OrderModel.lines))
        )
        model = result.scalar_one_or_none()
        if model is None:
            return None

        return Order(
            id=OrderId(model.id),
            customer_id=CustomerId(model.customer_id),
            status=OrderStatus(model.status),
            lines=[
                OrderLine(
                    product_id=line.product_id,
                    quantity=line.quantity,
                    unit_price=Money(line.unit_price, line.currency),
                )
                for line in model.lines
            ],
            created_at=model.created_at,
        )

    async def next_id(self) -> OrderId:
        from uuid import uuid4
        return OrderId(uuid4())
```

#### Presentation — FastAPI

```python
# src/presentation/api/order_routes.py
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import List
from decimal import Decimal

from src.application.use_cases.place_order import PlaceOrderUseCase, PlaceOrderInput, OrderLineInput
from src.presentation.dependencies import get_place_order_use_case

router = APIRouter(prefix="/orders", tags=["orders"])


class OrderLineRequest(BaseModel):
    product_id: str
    quantity: int
    unit_price: Decimal


class PlaceOrderRequest(BaseModel):
    customer_id: str
    lines: List[OrderLineRequest]


class PlaceOrderResponse(BaseModel):
    order_id: str
    status: str = "confirmed"


@router.post("/", response_model=PlaceOrderResponse, status_code=201)
async def place_order(
    request: PlaceOrderRequest,
    use_case: PlaceOrderUseCase = Depends(get_place_order_use_case),
):
    try:
        order_id = await use_case.execute(PlaceOrderInput(
            customer_id=request.customer_id,
            lines=[
                OrderLineInput(
                    product_id=line.product_id,
                    quantity=line.quantity,
                    unit_price=line.unit_price,
                )
                for line in request.lines
            ],
        ))
        return PlaceOrderResponse(order_id=str(order_id))
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
```

#### Prometheus Metrics (Python)

```python
# src/infrastructure/observability/metrics.py
from prometheus_client import Counter, Histogram, Gauge

order_placed_total = Counter(
    "erp_order_placed_total",
    "Total orders placed",
    ["status"],  # success | failed
)

order_value_thb = Histogram(
    "erp_order_value_thb",
    "Order value in THB",
    buckets=[100, 500, 1000, 5000, 10000, 50000, 100000],
)

order_processing_seconds = Histogram(
    "erp_order_processing_seconds",
    "Time to process order placement",
    buckets=[0.01, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5],
)

active_orders = Gauge(
    "erp_orders_active",
    "Currently active (draft) orders",
)
```

### การติดตั้ง / การตั้งค่า

#### `pyproject.toml`

```toml
[project]
name = "erp-order-service"
version = "1.0.0"
requires-python = ">=3.11"
dependencies = [
    "fastapi>=0.115.0",
    "uvicorn[standard]>=0.32.0",
    "sqlalchemy[asyncio]>=2.0.0",
    "asyncpg>=0.30.0",
    "pydantic>=2.9.0",
    "prometheus-client>=0.20.0",
    "prometheus-fastapi-instrumentator>=7.0.0",
    "aiokafka>=0.11.0",
    "pytest>=8.3.0",
    "pytest-asyncio>=0.24.0",
]
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| Domain import SQLAlchemy | Layer ทะลุ | Domain ห้าม import `infrastructure/` |
| Invariant หลุด | ไม่มี Aggregate Root protect | รวม logic ไว้ใน Aggregate |
| Test ยาก | Domain ผูกกับ DB | Mock Repository interface |
| Domain Event ไม่ถูกส่ง | ไม่ได้ collect หลัง save | เรียก `collect_events()` ใน Use Case |

### ลำดับการจัดการปัญหา

1. Domain Layer import อะไร? — ต้องมีแค่ `domain/` และ `shared/`
2. Aggregate มี Invariant ครบไหม? — Test ด้วย Unit Test (ไม่ต้อง DB)
3. Use Case orchestrates ถูกไหม? — 1 Use Case = 1 Transaction
4. Repository interface อยู่ใน `domain/` ไหม? — ต้องอยู่ (Port)

### Template Code
→ ดู Domain, Application, Infrastructure, Presentation ด้านบน

### Template Dashboard
→ ใช้ Application RED Dashboard (เล่ม 3) + เพิ่ม panel `erp_order_placed_total`

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** Domain บริสุทธิ์ Test ง่าย เปลี่ยน DB ไม่กระทบ Business Logic
- **ข้อควรระวัง:** **อย่าให้ Domain import Infrastructure** — Layer ทะลุจะพังทันที
- **ข้อดี:** Python อ่านง่าย, `dataclass` + `frozen` ทำ Value Object ได้สวย
- **ข้อเสีย:** ไม่มี Static Type (ใช้ mypy ช่วย), Performance ช้ากว่า Go
- **ข้อห้าม:**
  - ❌ Domain import SQLAlchemy/Pydantic
  - ❌ Repository ใน Domain รู้จัก DB schema
  - ❌ Business Logic ใน FastAPI route
  - ❌ Aggregate ข้าม Context (Order import Customer)

### ตัวอย่าง (Unit Test ที่ไม่ต้อง DB)

```python
# tests/unit/domain/test_order.py
import pytest
from decimal import Decimal
from uuid import uuid4
from src.domain.order.aggregate import Order
from src.domain.order.value_objects import CustomerId, Money
from src.domain.order.exceptions import EmptyOrderError


def test_confirm_empty_order_raises():
    order = Order.create(CustomerId(uuid4()))
    with pytest.raises(EmptyOrderError):
        order.confirm()


def test_add_line_with_zero_quantity_raises():
    order = Order.create(CustomerId(uuid4()))
    with pytest.raises(ValueError):
        order.add_line("P-1", 0, Money(Decimal("100")))


def test_confirm_order_emits_event():
    order = Order.create(CustomerId(uuid4()))
    order.add_line("P-1", 2, Money(Decimal("100")))
    order.confirm()
    events = order.collect_events()
    assert len(events) == 2  # OrderLineAdded + OrderPlaced
    assert events[1].event_type == "order.placed"
```

### สรุปย่อเพื่อจดจำ
> **Python DDD** — 4 Layers: `domain/`, `application/`, `infrastructure/`, `presentation/` — Aggregate Root protect Invariant — Repository interface อยู่ `domain/` — Domain Event collect หลัง save — Test Domain โดยไม่ต้อง DB

### แหล่งที่มา
- Eric Evans, *Domain-Driven Design* (2003)
- Vaughn Vernon, *Implementing Domain-Driven Design* (2013)
- Python DDD examples: https://github.com/cosmicpython/book
- Harry Percival & Bob Gregory, *Architecture Patterns with Python* (O'Reilly, 2020)

---

## 8.2 Golang DDD (Hexagonal Architecture, Interface Segregation, Error Handling)

### เรื่อง
การ implement DDD ใน Golang — เน้น Hexagonal Architecture, Interface Segregation, และ Error Handling

### วัตถุประสงค์ / เป้าหมาย
- Hexagonal Architecture: Core (Domain) แยกจาก Adapter
- Interface เล็ก (Interface Segregation Principle)
- Error Handling ที่ชัดเจน (ไม่ใช้ `panic`)
- Domain Event publish ผ่าน Port

### เนื้อหา / รายละเอียด

#### Hexagonal Architecture

```
┌─────────────────────────────────────────────┐
│            Adapters (Driving)              │
│  ┌────────┐  ┌────────┐  ┌────────┐        │
│  │ HTTP   │  │ gRPC   │  │  CLI   │        │
│  └───┬────┘  └───┬────┘  └───┬────┘        │
└──────┼───────────┼───────────┼─────────────┘
       │           │           │
       ▼           ▼           ▼
┌─────────────────────────────────────────────┐
│           Application (Use Cases)           │
│  ┌──────────────────────────────────┐       │
│  │  PlaceOrderUseCase               │       │
│  └──────────────────────────────────┘       │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│         Domain (Core — ไม่รู้อะไร)          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  Order   │  │ OrderLine│  │  Events  │  │
│  │(Aggregate)│  │ (Entity) │  │          │  │
│  └──────────┘  └──────────┘  └──────────┘  │
└──────────────────┬──────────────────────────┘
                   │ (Ports — interfaces)
                   ▼
┌─────────────────────────────────────────────┐
│          Adapters (Driven)                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ Postgres │  │  Kafka   │  │Prometheus│  │
│  └──────────┘  └──────────┘  └──────────┘  │
└─────────────────────────────────────────────┘
```

#### โครงสร้าง Project (Go DDD)

```
erp-order-service/
├── cmd/
│   └── api/
│       └── main.go             # Wire dependencies
├── internal/
│   ├── domain/
│   │   └── order/
│   │       ├── order.go        # Aggregate Root
│   │       ├── order_line.go   # Entity
│   │       ├── money.go        # Value Object
│   │       ├── events.go       # Domain Events
│   │       ├── repository.go   # Port (interface)
│   │       └── errors.go       # Domain errors
│   ├── application/
│   │   └── order/
│   │       ├── place_order.go  # Use Case
│   │       └── ports.go        # EventPublisher (interface)
│   ├── infrastructure/
│   │   ├── persistence/
│   │   │   └── order_repository.go
│   │   ├── messaging/
│   │   │   └── kafka_publisher.go
│   │   └── observability/
│   │       └── metrics.go
│   └── adapter/
│       └── http/
│           └── order_handler.go
├── go.mod
└── go.sum
```

#### Domain — Aggregate Root

```go
// internal/domain/order/order.go
package order

import (
	"errors"
	"time"

	"github.com/google/uuid"
)

// Order = Aggregate Root
type Order struct {
	ID         OrderID
	CustomerID CustomerID
	Status     Status
	Lines      []OrderLine
	CreatedAt  time.Time
	events     []DomainEvent // unexported — protect invariant
}

// Factory
func NewOrder(customerID CustomerID) (*Order, error) {
	if customerID.IsZero() {
		return nil, errors.New("customer id is required")
	}
	return &Order{
		ID:         OrderID{Value: uuid.New()},
		CustomerID: customerID,
		Status:     StatusDraft,
		Lines:      make([]OrderLine, 0),
		CreatedAt:  time.Now().UTC(),
	}, nil
}

// Reconstruct — สำหรับ load จาก DB
func Reconstruct(id OrderID, customerID CustomerID, status Status, lines []OrderLine, createdAt time.Time) *Order {
	return &Order{
		ID:         id,
		CustomerID: customerID,
		Status:     status,
		Lines:      lines,
		CreatedAt:  createdAt,
	}
}

// AddLine — business method
func (o *Order) AddLine(productID string, quantity int, unitPrice Money) error {
	if o.Status != StatusDraft {
		return ErrOrderAlreadyConfirmed
	}
	if quantity <= 0 {
		return ErrInvalidQuantity
	}
	if unitPrice.Amount < 0 {
		return ErrInvalidPrice
	}

	o.Lines = append(o.Lines, OrderLine{
		ProductID: productID,
		Quantity:  quantity,
		UnitPrice: unitPrice,
	})

	o.events = append(o.events, OrderLineAdded{
		OrderID:   o.ID,
		ProductID: productID,
		Quantity:  quantity,
	})
	return nil
}

// Confirm — business method (protect invariant)
func (o *Order) Confirm() error {
	if o.Status != StatusDraft {
		return ErrOrderAlreadyConfirmed
	}
	if len(o.Lines) == 0 {
		return ErrEmptyOrder
	}

	o.Status = StatusConfirmed
	o.events = append(o.events, OrderPlaced{
		OrderID:     o.ID,
		CustomerID:  o.CustomerID,
		TotalAmount: o.TotalAmount(),
		LinesCount:  len(o.Lines),
		OccurredAt:  time.Now().UTC(),
	})
	return nil
}

// TotalAmount — query
func (o *Order) TotalAmount() Money {
	total := NewMoney(0, "THB")
	for _, line := range o.Lines {
		total = total.Add(line.Subtotal())
	}
	return total
}

// CollectEvents — Application Layer เรียก
func (o *Order) CollectEvents() []DomainEvent {
	events := o.events
	o.events = nil
	return events
}
```

#### Value Object — Money

```go
// internal/domain/order/money.go
package order

import "fmt"

// Money = Value Object (immutable)
type Money struct {
	Amount   int64  // เก็บเป็น satang (1 THB = 100 satang)
	Currency string
}

func NewMoney(amount int64, currency string) Money {
	return Money{Amount: amount, Currency: currency}
}

func (m Money) Add(other Money) Money {
	if m.Currency != other.Currency {
		panic(fmt.Sprintf("cannot add %s and %s", m.Currency, other.Currency))
	}
	return Money{Amount: m.Amount + other.Amount, Currency: m.Currency}
}

func (m Money) Multiply(n int) Money {
	return Money{Amount: m.Amount * int64(n), Currency: m.Currency}
}

func (m Money) IsZero() bool {
	return m.Amount == 0
}

func (m Money) String() string {
	return fmt.Sprintf("%.2f %s", float64(m.Amount)/100.0, m.Currency)
}
```

#### Type Definitions

```go
// internal/domain/order/types.go
package order

import "github.com/google/uuid"

type OrderID struct{ Value uuid.UUID }
type CustomerID struct{ Value uuid.UUID }

func (id OrderID) IsZero() bool      { return id.Value == uuid.Nil }
func (id CustomerID) IsZero() bool   { return id.Value == uuid.Nil }
func (id OrderID) String() string    { return id.Value.String() }
func (id CustomerID) String() string { return id.Value.String() }

type Status string

const (
	StatusDraft     Status = "draft"
	StatusConfirmed Status = "confirmed"
	StatusShipped   Status = "shipped"
	StatusCancelled Status = "cancelled"
)

type OrderLine struct {
	ProductID string
	Quantity  int
	UnitPrice Money
}

func (l OrderLine) Subtotal() Money {
	return l.UnitPrice.Multiply(l.Quantity)
}
```

#### Domain Errors

```go
// internal/domain/order/errors.go
package order

import "errors"

var (
	ErrOrderAlreadyConfirmed = errors.New("order already confirmed")
	ErrEmptyOrder            = errors.New("order has no lines")
	ErrInvalidQuantity       = errors.New("quantity must be > 0")
	ErrInvalidPrice          = errors.New("price cannot be negative")
	ErrOrderNotFound         = errors.New("order not found")
)
```

#### Domain Events

```go
// internal/domain/order/events.go
package order

import "time"

// DomainEvent = marker interface
type DomainEvent interface {
	EventType() string
	OccurredAt() time.Time
}

type OrderLineAdded struct {
	OrderID   OrderID
	ProductID string
	Quantity  int
	At        time.Time
}

func (e OrderLineAdded) EventType() string  { return "order.line_added" }
func (e OrderLineAdded) OccurredAt() time.Time {
	if e.At.IsZero() { return time.Now().UTC() }
	return e.At
}

type OrderPlaced struct {
	OrderID     OrderID
	CustomerID  CustomerID
	TotalAmount Money
	LinesCount  int
	OccurredAt  time.Time
}

func (e OrderPlaced) EventType() string      { return "order.placed" }
func (e OrderPlaced) OccurredAtTime() time.Time { return e.OccurredAt }
// Note: field name conflict with method — ใช้ชื่อ field "OccurredAt" แล้ว method แยก
```

> **แก้ไข:** ใน Go ไม่สามารถมี field และ method ชื่อเดียวกันได้ — ใช้วิธี embed หรือเปลี่ยนชื่อ field

```go
// internal/domain/order/events.go (แก้ไข)
package order

import "time"

type DomainEvent interface {
	EventType() string
	GetOccurredAt() time.Time
}

type OrderPlaced struct {
	OrderID     OrderID
	CustomerID  CustomerID
	TotalAmount Money
	LinesCount  int
	At          time.Time
}

func (e OrderPlaced) EventType() string       { return "order.placed" }
func (e OrderPlaced) GetOccurredAt() time.Time {
	if e.At.IsZero() { return time.Now().UTC() }
	return e.At
}
```

#### Repository (Port)

```go
// internal/domain/order/repository.go
package order

import "context"

// Repository = Port (Domain ประกาศ)
type Repository interface {
	Save(ctx context.Context, order *Order) error
	FindByID(ctx context.Context, id OrderID) (*Order, error)
}
```

#### Application — Use Case + Ports

```go
// internal/application/order/ports.go
package order

import (
	"context"
	domain "erp-order-service/internal/domain/order"
)

// EventPublisher = Port
type EventPublisher interface {
	Publish(ctx context.Context, events ...domain.DomainEvent) error
}

// UnitOfWork = Port
type UnitOfWork interface {
	Do(ctx context.Context, fn func(ctx context.Context) error) error
}
```

```go
// internal/application/order/place_order.go
package order

import (
	"context"
	"fmt"

	domain "erp-order-service/internal/domain/order"
)

type PlaceOrderLine struct {
	ProductID string
	Quantity  int
	UnitPrice int64 // satang
}

type PlaceOrderInput struct {
	CustomerID string
	Lines      []PlaceOrderLine
}

type PlaceOrderUseCase struct {
	orderRepo domain.Repository
	publisher EventPublisher
	uow       UnitOfWork
}

func NewPlaceOrderUseCase(
	repo domain.Repository,
	publisher EventPublisher,
	uow UnitOfWork,
) *PlaceOrderUseCase {
	return &PlaceOrderUseCase{
		orderRepo: repo,
		publisher: publisher,
		uow:       uow,
	}
}

func (uc *PlaceOrderUseCase) Execute(ctx context.Context, input PlaceOrderInput) (domain.OrderID, error) {
	customerID, err := parseCustomerID(input.CustomerID)
	if err != nil {
		return domain.OrderID{}, fmt.Errorf("invalid customer id: %w", err)
	}

	order, err := domain.NewOrder(customerID)
	if err != nil {
		return domain.OrderID{}, err
	}

	for _, line := range input.Lines {
		if err := order.AddLine(line.ProductID, line.Quantity, domain.NewMoney(line.UnitPrice, "THB")); err != nil {
			return domain.OrderID{}, err
		}
	}

	if err := order.Confirm(); err != nil {
		return domain.OrderID{}, err
	}

	var orderID domain.OrderID
	err = uc.uow.Do(ctx, func(txCtx context.Context) error {
		if err := uc.orderRepo.Save(txCtx, order); err != nil {
			return fmt.Errorf("save order: %w", err)
		}
		events := order.CollectEvents()
		if err := uc.publisher.Publish(txCtx, events...); err != nil {
			return fmt.Errorf("publish events: %w", err)
		}
		orderID = order.ID
		return nil
	})
	if err != nil {
		return domain.OrderID{}, err
	}

	return orderID, nil
}
```

#### Infrastructure — Postgres Repository

```go
// internal/infrastructure/persistence/order_repository.go
package persistence

import (
	"context"
	"database/sql"
	"errors"

	domain "erp-order-service/internal/domain/order"

	"github.com/google/uuid"
)

type PostgresOrderRepository struct {
	db *sql.DB
}

func NewPostgresOrderRepository(db *sql.DB) *PostgresOrderRepository {
	return &PostgresOrderRepository{db: db}
}

func (r *PostgresOrderRepository) Save(ctx context.Context, o *domain.Order) error {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	_, err = tx.ExecContext(ctx, `
		INSERT INTO orders (id, customer_id, status, created_at)
		VALUES ($1, $2, $3, $4)
		ON CONFLICT (id) DO UPDATE SET status = EXCLUDED.status
	`, o.ID.Value, o.CustomerID.Value, string(o.Status), o.CreatedAt)
	if err != nil {
		return err
	}

	// Replace lines (simplified)
	if _, err = tx.ExecContext(ctx, `DELETE FROM order_lines WHERE order_id = $1`, o.ID.Value); err != nil {
		return err
	}
	for _, line := range o.Lines {
		_, err = tx.ExecContext(ctx, `
			INSERT INTO order_lines (order_id, product_id, quantity, unit_price, currency)
			VALUES ($1, $2, $3, $4, $5)
		`, o.ID.Value, line.ProductID, line.Quantity, line.UnitPrice.Amount, line.UnitPrice.Currency)
		if err != nil {
			return err
		}
	}

	return tx.Commit()
}

func (r *PostgresOrderRepository) FindByID(ctx context.Context, id domain.OrderID) (*domain.Order, error) {
	row := r.db.QueryRowContext(ctx, `
		SELECT id, customer_id, status, created_at FROM orders WHERE id = $1
	`, id.Value)

	var (
		orderID    uuid.UUID
		customerID uuid.UUID
		status     string
		createdAt  sql.NullTime
	)
	if err := row.Scan(&orderID, &customerID, &status, &createdAt); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, domain.ErrOrderNotFound
		}
		return nil, err
	}

	// Load lines
	rows, err := r.db.QueryContext(ctx, `
		SELECT product_id, quantity, unit_price, currency FROM order_lines WHERE order_id = $1
	`, orderID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var lines []domain.OrderLine
	for rows.Next() {
		var (
			productID string
			quantity  int
			price     int64
			currency  string
		)
		if err := rows.Scan(&productID, &quantity, &price, &currency); err != nil {
			return nil, err
		}
		lines = append(lines, domain.OrderLine{
			ProductID: productID,
			Quantity:  quantity,
			UnitPrice: domain.NewMoney(price, currency),
		})
	}

	return domain.Reconstruct(
		domain.OrderID{Value: orderID},
		domain.CustomerID{Value: customerID},
		domain.Status(status),
		lines,
		createdAt.Time,
	), nil
}
```

#### Adapter — HTTP Handler

```go
// internal/adapter/http/order_handler.go
package http

import (
	"encoding/json"
	"net/http"

	apporder "erp-order-service/internal/application/order"
	domain "erp-order-service/internal/domain/order"
)

type OrderHandler struct {
	placeOrder *apporder.PlaceOrderUseCase
}

func NewOrderHandler(placeOrder *apporder.PlaceOrderUseCase) *OrderHandler {
	return &OrderHandler{placeOrder: placeOrder}
}

type placeOrderRequest struct {
	CustomerID string `json:"customer_id"`
	Lines      []struct {
		ProductID string `json:"product_id"`
		Quantity  int    `json:"quantity"`
		UnitPrice int64  `json:"unit_price"`
	} `json:"lines"`
}

func (h *OrderHandler) PlaceOrder(w http.ResponseWriter, r *http.Request) {
	var req placeOrderRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, http.StatusBadRequest, "invalid json")
		return
	}

	lines := make([]apporder.PlaceOrderLine, len(req.Lines))
	for i, l := range req.Lines {
		lines[i] = apporder.PlaceOrderLine{
			ProductID: l.ProductID,
			Quantity:  l.Quantity,
			UnitPrice: l.UnitPrice,
		}
	}

	orderID, err := h.placeOrder.Execute(r.Context(), apporder.PlaceOrderInput{
		CustomerID: req.CustomerID,
		Lines:      lines,
	})
	if err != nil {
		switch {
		case isDomainError(err):
			writeError(w, http.StatusBadRequest, err.Error())
		default:
			writeError(w, http.StatusInternalServerError, "internal error")
		}
		return
	}

	writeJSON(w, http.StatusCreated, map[string]string{
		"order_id": orderID.String(),
	})
}

func isDomainError(err error) bool {
	return err == domain.ErrEmptyOrder ||
		err == domain.ErrInvalidQuantity ||
		err == domain.ErrOrderAlreadyConfirmed
}
```

#### Prometheus Metrics (Go)

```go
// internal/infrastructure/observability/metrics.go
package observability

import "github.com/prometheus/client_golang/prometheus"
import "github.com/prometheus/client_golang/prometheus/promauto"

var (
	OrderPlacedTotal = promauto.NewCounterVec(prometheus.CounterOpts{
		Name: "erp_order_placed_total",
		Help: "Total orders placed",
	}, []string{"status"})

	OrderValueTHB = promauto.NewHistogram(prometheus.HistogramOpts{
		Name:    "erp_order_value_thb",
		Help:    "Order value in THB satang",
		Buckets: []float64{10000, 50000, 100000, 500000, 1000000, 5000000},
	})

	OrderProcessingSeconds = promauto.NewHistogram(prometheus.HistogramOpts{
		Name:    "erp_order_processing_seconds",
		Help:    "Order placement duration",
		Buckets: prometheus.DefBuckets,
	})
)
```

#### Unit Test (Go)

```go
// internal/domain/order/order_test.go
package order_test

import (
	"testing"

	. "erp-order-service/internal/domain/order"

	"github.com/google/uuid"
)

func TestOrder_Confirm_EmptyOrder(t *testing.T) {
	order, _ := NewOrder(CustomerID{Value: uuid.New()})
	err := order.Confirm()
	if err != ErrEmptyOrder {
		t.Fatalf("expected ErrEmptyOrder, got %v", err)
	}
}

func TestOrder_AddLine_InvalidQuantity(t *testing.T) {
	order, _ := NewOrder(CustomerID{Value: uuid.New()})
	err := order.AddLine("P-1", 0, NewMoney(100, "THB"))
	if err != ErrInvalidQuantity {
		t.Fatalf("expected ErrInvalidQuantity, got %v", err)
	}
}

func TestOrder_Confirm_EmitsEvents(t *testing.T) {
	order, _ := NewOrder(CustomerID{Value: uuid.New()})
	_ = order.AddLine("P-1", 2, NewMoney(10000, "THB"))
	_ = order.Confirm()

	events := order.CollectEvents()
	if len(events) != 2 {
		t.Fatalf("expected 2 events, got %d", len(events))
	}
	if events[1].EventType() != "order.placed" {
		t.Fatalf("expected order.placed, got %s", events[1].EventType())
	}
}
```

### การติดตั้ง / การตั้งค่า

#### `go.mod`

```go
module erp-order-service

go 1.23

require (
	github.com/google/uuid v1.6.0
	github.com/prometheus/client_golang v1.19.0
	github.com/lib/pq v1.10.9
	github.com/segmentio/kafka-go v0.4.47
)
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| Domain import `database/sql` | Layer ทะลุ | Domain ห้าม import adapter |
| Error Handling ใช้ `panic` | Anti-pattern | Return error ทุกที่ |
| Interface ใหญ่เกิน | ISP violation | แยก interface เล็ก |
| Test ยาก | ผูกกับ DB | ใช้ interface + mock |

### ลำดับการจัดการปัญหา

1. Domain import อะไร? — ต้องมีแค่ stdlib + uuid
2. Interface เล็กพอไหม? — Repository ควรมีแค่ 2-3 method
3. Error Handling ใช้ `errors.Is` ถูกไหม? — Domain error ใช้ sentinel
4. Use Case orchestrates ถูกไหม? — 1 Use Case = 1 Transaction (ผ่าน UnitOfWork)

### Template Code
→ ดู Domain, Application, Infrastructure, Adapter ด้านบน

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** Performance สูง, Type Safety, Concurrency ดี
- **ข้อควรระวัง:** **Interface ต้องเล็ก** — อย่าให้ Repository มี 20 methods; **Error Handling** ต้องชัด (wrap ด้วย `%w`)
- **ข้อดี:** Static Type + Compiler ช่วย, Hexagonal test ง่าย
- **ข้อเสีย:** Verbose กว่า Python, ไม่มี Generics ที่ทรงพลังเท่า TypeScript
- **ข้อห้าม:**
  - ❌ Domain import `database/sql` หรือ adapter ใดๆ
  - ❌ ใช้ `panic` สำหรับ business error — ใช้ error return
  - ❌ Interface ใหญ่ (ISP violation)
  - ❌ Business logic ใน HTTP Handler

### ตัวอย่าง (Unit of Work)

```go
// internal/infrastructure/persistence/unit_of_work.go
package persistence

import (
	"context"
	"database/sql"
)

type SqlUnitOfWork struct {
	db *sql.DB
}

func NewSqlUnitOfWork(db *sql.DB) *SqlUnitOfWork {
	return &SqlUnitOfWork{db: db}
}

func (u *SqlUnitOfWork) Do(ctx context.Context, fn func(ctx context.Context) error) error {
	tx, err := u.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	txCtx := context.WithValue(ctx, "tx", tx)
	if err := fn(txCtx); err != nil {
		return err
	}
	return tx.Commit()
}
```

### สรุปย่อเพื่อจดจำ
> **Go DDD** — Hexagonal: Domain → Application → Adapter — Interface เล็ก (ISP) — Error Return ไม่ใช้ Panic — UnitOfWork สำหรับ Transaction — Test Domain โดยไม่ต้อง DB

### แหล่งที่มา
- Alistair Cockburn, "Hexagonal Architecture" (2005)
- Vaughn Vernon, *Implementing Domain-Driven Design* (2013)
- Go DDD examples: https://github.com/ThreeDotsLabs/wild-workouts-go-ddd-example
- Dave Cheney, "Error Handling in Go" (2019)

---

## 8.3 Node.js TypeScript DDD (NestJS + DDD, Type Safety, Dependency Injection)

### เรื่อง
การ implement DDD ใน Node.js TypeScript ด้วย NestJS — เน้น Type Safety และ Dependency Injection

### วัตถุประสงค์ / เป้าหมาย
- NestJS Module + DDD Layers
- Type Safety ด้วย TypeScript
- DI สำหรับ testability
- Domain Event ผ่าน EventEmitter (หรือ Kafka)

### เนื้อหา / รายละเอียด

#### โครงสร้าง Project (NestJS + DDD)

```
erp-order-service/
├── src/
│   ├── domain/
│   │   ├── order/
│   │   │   ├── order.aggregate.ts
│   │   │   ├── order-line.entity.ts
│   │   │   ├── money.vo.ts
│   │   │   ├── order.events.ts
│   │   │   ├── order.repository.ts   # interface (abstract class)
│   │   │   └── order.errors.ts
│   │   └── shared/
│   │       └── money.vo.ts
│   ├── application/
│   │   └── order/
│   │       ├── place-order.usecase.ts
│   │       └── event-publisher.port.ts
│   ├── infrastructure/
│   │   ├── persistence/
│   │   │   ├── order.typeorm.repository.ts
│   │   │   └── order.orm-entity.ts
│   │   ├── messaging/
│   │   │   └── kafka-event-publisher.ts
│   │   └── observability/
│   │       └── metrics.ts
│   ├── presentation/
│   │   └── http/
│   │       ├── order.controller.ts
│   │       └── dto/
│   │           └── place-order.dto.ts
│   ├── app.module.ts
│   └── main.ts
├── test/
└── package.json
```

#### Domain — Aggregate Root

```typescript
// src/domain/order/order.aggregate.ts
import { OrderId, CustomerId } from './types';
import { OrderLine } from './order-line.entity';
import { Money } from './money.vo';
import { OrderStatus } from './types';
import { OrderPlaced, OrderLineAdded, DomainEvent } from './order.events';
import {
  EmptyOrderError,
  InvalidQuantityError,
  OrderAlreadyConfirmedError,
} from './order.errors';
import { randomUUID } from 'crypto';

export class Order {
  private readonly _events: DomainEvent[] = [];

  private constructor(
    public readonly id: OrderId,
    public readonly customerId: CustomerId,
    private _status: OrderStatus,
    private _lines: OrderLine[],
    public readonly createdAt: Date,
  ) {}

  // ── Factory ───────────────────────────────────────
  static create(customerId: CustomerId): Order {
    return new Order(
      { value: randomUUID() },
      customerId,
      OrderStatus.DRAFT,
      [],
      new Date(),
    );
  }

  // ── Reconstruct (จาก DB) ──────────────────────────
  static reconstruct(props: {
    id: OrderId;
    customerId: CustomerId;
    status: OrderStatus;
    lines: OrderLine[];
    createdAt: Date;
  }): Order {
    return new Order(props.id, props.customerId, props.status, props.lines, props.createdAt);
  }

  // ── Getters ───────────────────────────────────────
  get status(): OrderStatus { return this._status; }
  get lines(): ReadonlyArray<OrderLine> { return this._lines; }

  // ── Business Methods ──────────────────────────────
  addLine(productId: string, quantity: number, unitPrice: Money): void {
    if (this._status !== OrderStatus.DRAFT) {
      throw new OrderAlreadyConfirmedError(this.id.value);
    }
    if (quantity <= 0) {
      throw new InvalidQuantityError(quantity);
    }

    this._lines.push({
      productId,
      quantity,
      unitPrice,
    });

    this._events.push({
      type: 'order.line_added',
      orderId: this.id,
      productId,
      quantity,
    });
  }

  confirm(): void {
    if (this._status !== OrderStatus.DRAFT) {
      throw new OrderAlreadyConfirmedError(this.id.value);
    }
    if (this._lines.length === 0) {
      throw new EmptyOrderError(this.id.value);
    }

    this._status = OrderStatus.CONFIRMED;

    this._events.push({
      type: 'order.placed',
      orderId: this.id,
      customerId: this.customerId,
      totalAmount: this.totalAmount(),
      linesCount: this._lines.length,
      occurredAt: new Date(),
    });
  }

  // ── Queries ───────────────────────────────────────
  totalAmount(): Money {
    return this._lines.reduce(
      (sum, line) => sum.add(line.subtotal()),
      Money.zero('THB'),
    );
  }

  // ── Events ────────────────────────────────────────
  collectEvents(): DomainEvent[] {
    const events = [...this._events];
    this._events.length = 0;
    return events;
  }
}
```

#### Value Object (Money)

```typescript
// src/domain/order/money.vo.ts
export class Money {
  private constructor(
    public readonly amount: number,   // satang
    public readonly currency: string,
  ) {
    if (amount < 0) throw new Error('Amount cannot be negative');
    if (!['THB', 'USD', 'EUR'].includes(currency)) {
      throw new Error(`Unsupported currency: ${currency}`);
    }
  }

  static of(amount: number, currency = 'THB'): Money {
    return new Money(Math.round(amount), currency);
  }

  static zero(currency = 'THB'): Money {
    return new Money(0, currency);
  }

  add(other: Money): Money {
    if (this.currency !== other.currency) {
      throw new Error(`Cannot add ${this.currency} and ${other.currency}`);
    }
    return new Money(this.amount + other.amount, this.currency);
  }

  multiply(n: number): Money {
    return new Money(this.amount * n, this.currency);
  }

  equals(other: Money): boolean {
    return this.amount === other.amount && this.currency === other.currency;
  }

  toString(): string {
    return `${(this.amount / 100).toFixed(2)} ${this.currency}`;
  }
}
```

#### Domain Events

```typescript
// src/domain/order/order.events.ts
import { OrderId, CustomerId } from './types';
import { Money } from './money.vo';

export type DomainEvent = OrderLineAddedEvent | OrderPlacedEvent;

export interface OrderLineAddedEvent {
  type: 'order.line_added';
  orderId: OrderId;
  productId: string;
  quantity: number;
}

export interface OrderPlacedEvent {
  type: 'order.placed';
  orderId: OrderId;
  customerId: CustomerId;
  totalAmount: Money;
  linesCount: number;
  occurredAt: Date;
}
```

#### Repository (Interface — abstract class สำหรับ DI token)

```typescript
// src/domain/order/order.repository.ts
import { Order } from './order.aggregate';
import { OrderId } from './types';

export abstract class OrderRepository {
  abstract save(order: Order): Promise<void>;
  abstract findById(id: OrderId): Promise<Order | null>;
}
```

#### Application — Use Case

```typescript
// src/application/order/place-order.usecase.ts
import { Injectable, Inject } from '@nestjs/common';
import { Order } from '../../domain/order/order.aggregate';
import { OrderRepository } from '../../domain/order/order.repository';
import { CustomerId, OrderId } from '../../domain/order/types';
import { Money } from '../../domain/order/money.vo';
import { EventPublisher } from './event-publisher.port';

export interface PlaceOrderLineInput {
  productId: string;
  quantity: number;
  unitPrice: number; // satang
}

export interface PlaceOrderInput {
  customerId: string;
  lines: PlaceOrderLineInput[];
}

@Injectable()
export class PlaceOrderUseCase {
  constructor(
    @Inject(OrderRepository) private readonly orderRepo: OrderRepository,
    @Inject(EventPublisher) private readonly publisher: EventPublisher,
  ) {}

  async execute(input: PlaceOrderInput): Promise<OrderId> {
    const order = Order.create({ value: input.customerId });

    for (const line of input.lines) {
      order.addLine(
        line.productId,
        line.quantity,
        Money.of(line.unitPrice, 'THB'),
      );
    }

    order.confirm();

    await this.orderRepo.save(order);
    await this.publisher.publishAll(order.collectEvents());

    return order.id;
  }
}
```

#### Infrastructure — TypeORM Repository

```typescript
// src/infrastructure/persistence/order.typeorm.repository.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { OrderRepository } from '../../domain/order/order.repository';
import { Order } from '../../domain/order/order.aggregate';
import { OrderId, OrderStatus } from '../../domain/order/types';
import { Money } from '../../domain/order/money.vo';
import { OrderOrmEntity } from './order.orm-entity';

@Injectable()
export class TypeOrmOrderRepository implements OrderRepository {
  constructor(
    @InjectRepository(OrderOrmEntity)
    private readonly repo: Repository<OrderOrmEntity>,
  ) {}

  async save(order: Order): Promise<void> {
    const entity = this.repo.create({
      id: order.id.value,
      customerId: order.customerId.value,
      status: order.status,
      createdAt: order.createdAt,
      lines: order.lines.map((line) => ({
        productId: line.productId,
        quantity: line.quantity,
        unitPrice: line.unitPrice.amount,
        currency: line.unitPrice.currency,
      })),
    });
    await this.repo.save(entity);
  }

  async findById(id: OrderId): Promise<Order | null> {
    const entity = await this.repo.findOne({
      where: { id: id.value },
      relations: ['lines'],
    });
    if (!entity) return null;

    return Order.reconstruct({
      id: { value: entity.id },
      customerId: { value: entity.customerId },
      status: entity.status as OrderStatus,
      lines: entity.lines.map((line) => ({
        productId: line.productId,
        quantity: line.quantity,
        unitPrice: Money.of(line.unitPrice, line.currency),
      })),
      createdAt: entity.createdAt,
    });
  }
}
```

#### Presentation — Controller (NestJS)

```typescript
// src/presentation/http/order.controller.ts
import { Body, Controller, Post, HttpCode } from '@nestjs/common';
import { PlaceOrderUseCase } from '../../application/order/place-order.usecase';
import { PlaceOrderDto } from './dto/place-order.dto';

@Controller('orders')
export class OrderController {
  constructor(private readonly placeOrderUseCase: PlaceOrderUseCase) {}

  @Post()
  @HttpCode(201)
  async placeOrder(@Body() dto: PlaceOrderDto) {
    const orderId = await this.placeOrderUseCase.execute({
      customerId: dto.customerId,
      lines: dto.lines.map((l) => ({
        productId: l.productId,
        quantity: l.quantity,
        unitPrice: l.unitPrice,
      })),
    });
    return { orderId: orderId.value };
  }
}
```

```typescript
// src/presentation/http/dto/place-order.dto.ts
import { IsString, IsArray, IsInt, Min, ValidateNested, IsNotEmpty } from 'class-validator';
import { Type } from 'class-transformer';

export class OrderLineDto {
  @IsString()
  @IsNotEmpty()
  productId: string;

  @IsInt()
  @Min(1)
  quantity: number;

  @IsInt()
  @Min(0)
  unitPrice: number;
}

export class PlaceOrderDto {
  @IsString()
  @IsNotEmpty()
  customerId: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => OrderLineDto)
  lines: OrderLineDto[];
}
```

#### Module (DI Wiring)

```typescript
// src/app.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { OrderController } from './presentation/http/order.controller';
import { PlaceOrderUseCase } from './application/order/place-order.usecase';
import { OrderRepository } from './domain/order/order.repository';
import { TypeOrmOrderRepository } from './infrastructure/persistence/order.typeorm.repository';
import { EventPublisher } from './application/order/event-publisher.port';
import { KafkaEventPublisher } from './infrastructure/messaging/kafka-event-publisher';
import { OrderOrmEntity } from './infrastructure/persistence/order.orm-entity';

@Module({
  imports: [
    TypeOrmModule.forRoot({ /* config */ }),
    TypeOrmModule.forFeature([OrderOrmEntity]),
  ],
  controllers: [OrderController],
  providers: [
    PlaceOrderUseCase,
    { provide: OrderRepository, useClass: TypeOrmOrderRepository },
    { provide: EventPublisher, useClass: KafkaEventPublisher },
  ],
})
export class AppModule {}
```

#### Prometheus Metrics (Node.js)

```typescript
// src/infrastructure/observability/metrics.ts
import { Counter, Histogram } from 'prom-client';

export const orderPlacedTotal = new Counter({
  name: 'erp_order_placed_total',
  help: 'Total orders placed',
  labelNames: ['status'],
});

export const orderValueTHB = new Histogram({
  name: 'erp_order_value_thb',
  help: 'Order value in THB satang',
  buckets: [10000, 50000, 100000, 500000, 1000000, 5000000],
});

export const orderProcessingSeconds = new Histogram({
  name: 'erp_order_processing_seconds',
  help: 'Order placement duration',
  buckets: [0.01, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5],
});
```

#### Unit Test (Jest)

```typescript
// test/domain/order.aggregate.spec.ts
import { Order } from '../../src/domain/order/order.aggregate';
import { Money } from '../../src/domain/order/money.vo';
import { EmptyOrderError, InvalidQuantityError } from '../../src/domain/order/order.errors';

describe('Order Aggregate', () => {
  it('throws when confirming empty order', () => {
    const order = Order.create({ value: 'cust-1' });
    expect(() => order.confirm()).toThrow(EmptyOrderError);
  });

  it('throws when adding zero quantity', () => {
    const order = Order.create({ value: 'cust-1' });
    expect(() => order.addLine('P-1', 0, Money.of(100))).toThrow(InvalidQuantityError);
  });

  it('emits two events on confirm', () => {
    const order = Order.create({ value: 'cust-1' });
    order.addLine('P-1', 2, Money.of(10000));
    order.confirm();

    const events = order.collectEvents();
    expect(events).toHaveLength(2);
    expect(events[1].type).toBe('order.placed');
  });
});
```

### การติดตั้ง / การตั้งค่า

#### `package.json`

```json
{
  "name": "erp-order-service",
  "version": "1.0.0",
  "scripts": {
    "build": "nest build",
    "start": "nest start",
    "start:dev": "nest start --watch",
    "test": "jest",
    "test:e2e": "jest --config ./test/jest-e2e.json"
  },
  "dependencies": {
    "@nestjs/common": "^10.4.0",
    "@nestjs/core": "^10.4.0",
    "@nestjs/platform-express": "^10.4.0",
    "@nestjs/typeorm": "^10.0.0",
    "typeorm": "^0.3.20",
    "pg": "^8.12.0",
    "class-validator": "^0.14.0",
    "class-transformer": "^0.5.1",
    "prom-client": "^15.1.0",
    "kafkajs": "^2.2.4",
    "reflect-metadata": "^0.2.0",
    "rxjs": "^7.8.0"
  },
  "devDependencies": {
    "@nestjs/cli": "^10.4.0",
    "@nestjs/testing": "^10.4.0",
    "@types/node": "^22.0.0",
    "jest": "^29.7.0",
    "ts-jest": "^29.2.0",
    "typescript": "^5.6.0"
  }
}
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| Domain import TypeORM | Layer ทะลุ | Domain ห้าม import `infrastructure/` |
| DI ไม่ทำงาน | Module ไม่ได้ provide | ตรวจ `providers` ใน Module |
| Validation ไม่ทำงาน | ไม่ได้เปิด `ValidationPipe` | `app.useGlobalPipes(new ValidationPipe())` |
| Type ไม่ตรง | `any` เยอะ | เปิด `strict: true` ใน `tsconfig.json` |
| Test ยาก | ผูกกับ NestJS | Test Domain แยก (ไม่ต้อง Nest) |

### ลำดับการจัดการปัญหา

1. Domain import อะไร? — ต้องมีแค่ type และ domain
2. DI Wiring ถูกไหม? — `providers` ใน `AppModule` ครบ?
3. Validation เปิดไหม? — `ValidationPipe` ใน `main.ts`
4. `tsconfig.json` เปิด `strict` ไหม? — ต้องเปิด
5. Repository interface อยู่ Domain ไหม? — ต้องอยู่

### Template Code
→ ดู Domain, Application, Infrastructure, Presentation, Module ด้านบน

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** Type Safety + DI + Testability, Ecosystem NestJS ครบ
- **ข้อควรระวัง:** **`tsconfig` ต้อง `strict: true`** — ไม่งั้น Type Safety ไม่จริง; **Domain ห้าม import NestJS**
- **ข้อดี:** NestJS Module จัดการ DI สวย, TypeScript type-check ตอน compile
- **ข้อเสีย:** Build ช้ากว่า Go, Runtime overhead สูงกว่า Go (Node.js single-thread)
- **ข้อห้าม:**
  - ❌ Domain import `@nestjs/*` หรือ `typeorm`
  - ❌ ใช้ `any` (ปิด Type Safety)
  - ❌ Business logic ใน Controller
  - ❌ Repository ใน Domain รู้จัก ORM entity

### ตัวอย่าง (Event Publisher — Kafka)

```typescript
// src/infrastructure/messaging/kafka-event-publisher.ts
import { Injectable } from '@nestjs/common';
import { Kafka } from 'kafkajs';
import { EventPublisher } from '../../application/order/event-publisher.port';
import { DomainEvent } from '../../domain/order/order.events';

@Injectable()
export class KafkaEventPublisher implements EventPublisher {
  private kafka = new Kafka({ brokers: ['kafka:9092'] });
  private producer = this.kafka.producer();

  async onModuleInit() {
    await this.producer.connect();
  }

  async publishAll(events: DomainEvent[]): Promise<void> {
    await this.producer.send({
      topic: 'erp.order.events',
      messages: events.map((e) => ({
        key: 'orderId' in e ? e.orderId.value : '',
        value: JSON.stringify(e),
      })),
    });
  }
}
```

### สรุปย่อเพื่อจดจำ
> **NestJS DDD** — 4 Layers: `domain/`, `application/`, `infrastructure/`, `presentation/` — DI ผ่าน `@Injectable` — Repository เป็น abstract class (DI token) — Domain Event ผ่าน `collectEvents()` — `tsconfig` ต้อง `strict: true` — Test Domain แยกจาก NestJS

### แหล่งที่มา
- NestJS Docs: https://docs.nestjs.com/
- Khalil Stemmler, "Software Design and Architecture" (2020)
- Node.js DDD examples: https://github.com/stemmlerjs/ddd-forum
- TypeScript Deep Dive: https://basarat.gitbook.io/typescript/

---

## Workflow (อ้างอิงเล่ม 1 + Incident Playbook เฉพาะเล่ม)

### อ้างอิง Workflow หลักจากเล่ม 1

| Workflow | ใช้ในเล่มนี้เมื่อ |
|---|---|
| **PSR** | เขียนรายงานหลัง Incident ที่เกี่ยวกับ ERP Application |
| **RCA 5 Whys** | หา Root Cause ของ Bug ใน Domain Logic |
| **KPI SMART** | ตั้ง KPI ของ Developer (เช่น Test Coverage > 80%, MTTR < 4h) |

→ Template เต็มอยู่ใน **เล่ม 1 หัวข้อ 4**

### Incident Playbook เฉพาะเล่ม 8

#### Playbook A: Domain Logic Bug (Invariant หลุด)

1. **Identify Invariant** — กฎอะไรที่ถูกละเมิด? (เช่น Order ไม่มี Line แต่ Confirm ได้)
2. **Trace Aggregate** — Method ไหนไม่ protect?
3. **เขียน Test ที่ Fail** — Reproduce Bug ด้วย Unit Test
4. **แก้ที่ Aggregate** — ใส่ Invariant check ใน Method
5. **ตรวจ Use Case** — อย่าแก้ที่ Use Case (Business Logic ต้องอยู่ Domain)
6. **Deploy + Monitor** — ตรวจ Metrics ว่า Bug ไม่กลับมา

#### Playbook B: Layer ทะลุ (Domain import Infrastructure)

1. **ตรวจ Import Graph** — `grep -r "from.*infrastructure" src/domain/` (Python/TS), `grep -r "infrastructure" internal/domain/` (Go)
2. **ย้าย Logic** — ถ้า Domain ต้องใช้ DB → ใช้ Repository Interface
3. **Refactor** — แยก Interface ไป `domain/`, implement ใน `infrastructure/`
4. **เพิ่ม Lint Rule** — `import-linter` (Python), `depguard` (Go), `eslint-plugin-boundaries` (TS)

#### Playbook C: Performance ตก (Application ช้า)

1. **ตรวจ Metrics** — RED Dashboard (เล่ม 3) — Latency P99 สูง?
2. **Profile** — Python `cProfile`, Go `pprof`, Node `clinic`
3. **ตรวจ N+1 Query** — Repository ดึงข้อมูลช้า?
4. **ตรวจ Aggregate Size** — Aggregate ใหญ่เกิน (load Entity 1000 ตัว)?
5. **แก้:**
   - N+1 → ใช้ `selectinload` (SQLAlchemy) / `Preload` (GORM) / `relations` (TypeORM)
   - Aggregate ใหญ่ → แยก Aggregate เล็กลง
   - Serialization → ใช้ Caching

#### Playbook D: Event ไม่ถูก Publish

1. **ตรวจ Collect** — Use Case เรียก `collectEvents()` หลัง save ไหม?
2. **ตรวจ Publisher** — Kafka/EventEmitter connect ไหม?
3. **ตรวจ Outbox** — ถ้าใช้ Outbox Pattern (เล่ม 10) — Table Outbox มี event ไหม?
4. **ตรวจ Consumer** — Consumer subscribe topic ถูกไหม?
5. **แก้:**
   - ไม่ collect → เพิ่มใน Use Case
   - Publish fail → ใช้ Outbox Pattern
   - Consumer ผิด → ตรวจ topic/group

---

## สรุป (ประโยชน์, ข้อดี, ข้อเสีย, ข้อห้าม)

### ประโยชน์ของเล่ม 8

- **Cross-Language DDD:** เห็น DDD ใน 3 ภาษา — เลือกตาม Stack ของทีม
- **Layer Separation:** Domain บริสุทธิ์ Test ง่าย เปลี่ยน DB ไม่กระทบ Business Logic
- **Aggregate Root:** Invariant ถูก protect — Bug น้อยลง
- **Domain Event:** พร้อมต่อ Integration Layer (เล่ม 10)
- **Observability:** Instrument Prometheus Metrics ในทุกภาษา

### ข้อดี

| ด้าน | ผลลัพธ์ |
|---|---|
| **Maintainability** | Domain Logic อยู่ที่เดียว |
| **Testability** | Unit Test Domain ไม่ต้อง DB |
| **Flexibility** | เปลี่ยน DB/Message Broker ไม่กระทบ Domain |
| **Team Scaling** | Bounded Context แยกทีมได้ |
| **Integration** | Domain Event ต่อ ERP Integration (เล่ม 10) |

### ข้อเสีย / ข้อจำกัด

- **Learning Curve:** DDD ต้องฝึก 2-4 สัปดาห์
- **Boilerplate:** Code เยอะกว่า CRUD ปกติ 2-3 เท่า
- **Over-engineering:** Domain ง่ายๆ ไม่ต้อง DDD (ใช้ CRUD)
- **Performance:** Layer เยอะกว่า (แต่ไม่มาก)
- **Cross-Language:** ทีมต้องเลือกภาษาให้ชัด (ไม่ใช่ 3 ภาษาพร้อมกัน)

### ข้อห้าม (สรุป)

1. ❌ **Domain import Infrastructure** — Layer ทะลุจะพังทันที
2. ❌ **Business Logic ใน Controller/Handler** — ต้องอยู่ Domain
3. ❌ **Aggregate ข้าม Context** — Order import Customer (ใช้ ACL แทน)
4. ❌ **Repository มี 20 Methods** — Interface Segregation
5. ❌ **ใช้ `panic` (Go) / `throw` (TS) สำหรับ Business Error** — Return error
6. ❌ **ใช้ `any` (TS) หรือ `interface{}` (Go) โดยไม่จำเป็น** — ปิด Type Safety
7. ❌ **Test Domain ด้วย DB** — ใช้ Mock Repository
8. ❌ **ใช้ CRUD Pattern สำหรับ Domain ที่ซับซ้อน** — ใช้ DDD
9. ❌ **ใช้ DDD สำหรับ Domain ง่าย** — Over-engineering (ใช้ CRUD)
10. ❌ **Publish Event โดยไม่มี Outbox** — Event หายถ้า Broker ล่ม (ดูเล่ม 10)

---

## เส้นทางอ่านต่อ

| ถ้าคุณเป็น | อ่านต่อ |
|---|---|
| ERP Developer | → **เล่ม 9** (Database Operations) → **เล่ม 10** (Integration Layer) |
| Solution Architect | → **เล่ม 9** → **เล่ม 10** |
| Tech Lead | → **เล่ม 9** → **เล่ม 10** + อ่าน *Implementing DDD* (Vernon) |
| ERP Support | → **เล่ม 9** → **เล่ม 10** |

---

> **เวอร์ชันเอกสาร:** 1.0
> **ผู้แต่ง:** kongnakorn jantakun
> **อีเมล:** kongnakornjantakun@gmail.com
> **สถานะ:** ต้นฉบับ
> **ผู้รับผิดชอบ:** ERP Engineering Team
> **ปรับปรุงล่าสุด:** ตามรอบ Quarter
> **สถานะการตรวจทาน:** ✅ Ready for Review

--- 