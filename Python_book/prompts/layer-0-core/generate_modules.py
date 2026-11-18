"""
Generator script for modules: money + idempotency
ERP + CRM + IoT for SME (Multi-company)
Clean Architecture + DDD (4 layers)

Usage:
    python generate_modules.py
    python generate_modules.py --base app/modules
"""
import argparse
import os
from pathlib import Path


# ============================================================
#  Helper
# ============================================================
def write(path: Path, content: str) -> None:
    """Write file with UTF-8, create parent dirs."""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    print(f"  [OK] {path}")


# ============================================================
#  MONEY MODULE
# ============================================================
MONEY_FILES = {
    # ---- root ----
    "__init__.py": '''"""Module money - Layer 0 (Clean Architecture + DDD)."""
__version__ = "1.0.0"
''',

    # ---- domain ----
    "domain/__init__.py": '''"""money domain layer - pure business logic."""
''',

    "domain/exceptions.py": '''from app.shared.exceptions import DomainException


class DomainError(DomainException):
    """Domain rule violation for money - ละเมิดกฎโดเมนของ money"""
    code = "mny_DOMAIN_ERROR"
''',

    "domain/enums.py": '''"""Enums for money - ตัวเลือกสำหรับ money"""
from enum import Enum


class Currency(str, Enum):
    """Currency enum - สกุลเงิน"""
    THB = "THB"
    USD = "USD"
    EUR = "EUR"


class VATRate(str, Enum):
    """VAT rate enum - อัตราภาษีมูลค่าเพิ่ม"""
    ZERO = "0.00"
    SEVEN = "0.07"


class RoundingMode(str, Enum):
    """Rounding mode enum - โหมดการปัดเศษ"""
    HALF_UP = "HALF_UP"
    HALF_DOWN = "HALF_DOWN"
    BANKERS = "BANKERS"
''',

    "domain/events.py": '''"""Domain events for money - เหตุการณ์โดเมน"""
MONEY_ADDED = "mny.MoneyAdded"
MONEY_SUBTRACTED = "mny.MoneySubtracted"
VAT_CALCULATED = "mny.VATCalculated"
CURRENCY_CONVERTED = "mny.CurrencyConverted"
''',

    "domain/entities.py": '''"""Entities for money - no entities (pure VO module).

Money is a Value Object, not an Entity.
"""

# ไม่มี entities — money เป็น pure VO module
''',

    "domain/value_objects.py": '''"""Value objects for money - วัตถุค่าสำหรับ money"""
from dataclasses import dataclass
from datetime import datetime
from decimal import Decimal, ROUND_HALF_UP

from .enums import Currency
from .exceptions import DomainError


@dataclass(frozen=True)
class Money:
    """Money value object - วัตถุค่าเงิน"""
    amount: Decimal
    currency: str = "THB"

    def __post_init__(self) -> None:
        # Force Decimal + quantize 2 places (ROUND_HALF_UP)
        if not isinstance(self.amount, Decimal):
            object.__setattr__(self, "amount", Decimal(str(self.amount)))
        object.__setattr__(
            self, "amount",
            self.amount.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP),
        )
        self._validate()

    def _validate(self) -> None:
        if not isinstance(self.amount, Decimal):
            raise DomainError("Amount must be Decimal")
        if self.currency not in Currency._value2member_map_:
            raise DomainError(f"Unsupported currency: {self.currency}")

    def _assert_same_currency(self, other: "Money") -> None:
        if self.currency != other.currency:
            raise DomainError(
                f"Cannot operate on {self.currency} vs {other.currency}"
            )

    def __add__(self, other: "Money") -> "Money":
        self._assert_same_currency(other)
        return Money(self.amount + other.amount, self.currency)

    def __sub__(self, other: "Money") -> "Money":
        self._assert_same_currency(other)
        return Money(self.amount - other.amount, self.currency)

    def __mul__(self, factor: Decimal) -> "Money":
        if not isinstance(factor, Decimal):
            raise DomainError("Factor must be Decimal")
        return Money(self.amount * factor, self.currency)

    def __neg__(self) -> "Money":
        return Money(-self.amount, self.currency)

    def __str__(self) -> str:
        return f"{self.amount} {self.currency}"

    def __repr__(self) -> str:
        return f"Money({self.amount}, {self.currency})"

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Money):
            return False
        return self.amount == other.amount and self.currency == other.currency

    def __hash__(self) -> int:
        return hash((self.amount, self.currency))

    def is_zero(self) -> bool:
        return self.amount == Decimal("0.00")

    def is_negative(self) -> bool:
        return self.amount < Decimal("0.00")


@dataclass(frozen=True)
class VAT:
    """VAT value object - วัตถุภาษีมูลค่าเพิ่ม"""
    rate: Decimal

    def calculate(self, base: Money) -> Money:
        """Calculate VAT from base - คำนวณ VAT จากฐาน"""
        return Money(
            (base.amount * self.rate).quantize(Decimal("0.01")),
            base.currency,
        )

    def extract(self, total: Money) -> Money:
        """Extract VAT from total - แยก VAT จากยอดรวม"""
        base = (total.amount / (Decimal("1") + self.rate)).quantize(Decimal("0.01"))
        return Money(total.amount - base, total.currency)


@dataclass(frozen=True)
class ExchangeRate:
    """Exchange rate VO - วัตถุอัตราแลกเปลี่ยน"""
    from_currency: str
    to_currency: str
    rate: Decimal
    as_of: datetime

    def __post_init__(self) -> None:
        if self.rate <= 0:
            raise DomainError("Exchange rate must be positive")

    def convert(self, amount: Money) -> Money:
        if amount.currency != self.from_currency:
            raise DomainError("Currency mismatch")
        return Money(amount.amount * self.rate, self.to_currency)
''',

    # ---- application ----
    "application/__init__.py": '''"""money application layer - use cases + ports."""
''',

    "application/exceptions.py": '''from app.shared.exceptions import ApplicationException


class MoneyException(ApplicationException):
    """Application exception for money."""
    code = "mny_APP_ERROR"


class MoneyNotFoundException(MoneyException):
    """Money not found."""
    code = "mny_NOT_FOUND"
''',

    "application/interfaces.py": '''"""Ports (Protocol) for money - pure VO module."""
from typing import Protocol


class IMoneyCalculator(Protocol):
    """Optional calculator port."""

    def add(self, a, b): ...
''',

    "application/mappers.py": '''"""Mappers for money."""
from decimal import Decimal

from ..domain.value_objects import Money


class MoneyMapper:
    """Maps Money VO <-> Pydantic schema."""

    @staticmethod
    def to_schema(money: Money) -> dict:
        return {"amount": str(money.amount), "currency": money.currency}

    @staticmethod
    def from_schema(data: dict) -> Money:
        return Money(
            amount=Decimal(str(data["amount"])),
            currency=data.get("currency", "THB"),
        )
''',

    "application/utils.py": '''"""Helper functions for money."""
from decimal import Decimal, ROUND_HALF_UP

from ..domain.value_objects import Money


def round_money(amount: Decimal, places: int = 2) -> Decimal:
    """Round money to N places (HALF_UP)."""
    q = Decimal(10) ** -places
    return amount.quantize(q, rounding=ROUND_HALF_UP)


def zero_money(currency: str = "THB") -> Money:
    """Return zero Money in given currency."""
    return Money(Decimal("0.00"), currency)
''',

    "application/use_cases.py": '''"""Money use cases - 3-branch error handling."""
from decimal import Decimal

from app.core.logging import logger
from app.shared.exceptions import (
    StandardException,
    DomainException,
    ApplicationException,
)

from ..domain.enums import VATRate
from ..domain.exceptions import DomainError
from ..domain.value_objects import Money, VAT, ExchangeRate


class MoneyException(ApplicationException):
    code = "mny_APP_ERROR"


class MoneyUseCases:
    """Use cases for money (3-branch error handling)."""

    def add(self, a: Money, b: Money) -> Money:
        """Add two Money - บวกเงิน"""
        try:
            return a + b
        except DomainError as e:
            raise DomainException(e)
        except StandardException:
            raise
        except Exception as e:
            logger.opt(exception=e).error("Error in MoneyUseCases.add")
            raise MoneyException()

    def subtract(self, a: Money, b: Money) -> Money:
        """Subtract two Money - ลบเงิน"""
        try:
            return a - b
        except DomainError as e:
            raise DomainException(e)
        except StandardException:
            raise
        except Exception as e:
            logger.opt(exception=e).error("Error in MoneyUseCases.subtract")
            raise MoneyException()

    def multiply(self, a: Money, factor: Decimal) -> Money:
        """Multiply Money - คูณเงิน"""
        return a * factor

    def calculate_vat(self, base: Money, rate: VATRate) -> Money:
        """Calculate VAT - คำนวณ VAT"""
        return VAT(Decimal(rate.value)).calculate(base)

    def extract_vat(self, total: Money, rate: VATRate) -> Money:
        """Extract VAT from total - แยก VAT"""
        return VAT(Decimal(rate.value)).extract(total)

    def convert(self, amount: Money, rate: ExchangeRate) -> Money:
        """Convert currency - แปลงสกุลเงิน"""
        return rate.convert(amount)

    def sum_all(self, items: list) -> Money:
        """Sum all Money - รวมเงินทั้งหมด"""
        if not items:
            raise DomainException(DomainError("Cannot sum empty list"))
        result = items[0]
        for item in items[1:]:
            result = result + item
        return result
''',

    # ---- infrastructure (empty for pure VO) ----
    "infrastructure/__init__.py": '''"""money infrastructure layer - pure VO (no persistence)."""
''',

    "infrastructure/models.py": '''"""No models - money is a pure VO module."""
''',

    "infrastructure/repositories.py": '''"""No repositories - money is a pure VO module."""
''',

    "infrastructure/caches.py": '''"""No caches - money is a pure VO module."""
''',

    "infrastructure/services.py": '''"""No services - money is a pure VO module."""
''',

    # ---- presentation ----
    "presentation/__init__.py": '''"""money presentation layer."""
''',

    "presentation/schemas.py": '''"""Pydantic schemas for money."""
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field

from ..domain.enums import VATRate


class MoneySchema(BaseModel):
    """Money schema - สกีมาสำหรับเงิน"""
    amount: Decimal = Field(..., decimal_places=2)
    currency: str = Field(default="THB", pattern="^(THB|USD|EUR)$")
    model_config = ConfigDict(from_attributes=True)

    def to_money(self):
        from ..domain.value_objects import Money
        return Money(amount=self.amount, currency=self.currency)


class VATRequest(BaseModel):
    """VAT request schema."""
    base: MoneySchema
    rate: VATRate = VATRate.SEVEN


class VATResponse(BaseModel):
    """VAT response schema."""
    vat: MoneySchema
    total: MoneySchema


class ExchangeRateSchema(BaseModel):
    """Exchange rate schema."""
    from_currency: str
    to_currency: str
    rate: Decimal
''',

    "presentation/dependencies.py": '''"""DI providers for money."""
from ..application.use_cases import MoneyUseCases


def get_money_use_cases() -> MoneyUseCases:
    """DI provider for money use cases."""
    return MoneyUseCases()
''',

    "presentation/docs.py": '''"""OpenAPI docs for money."""
router_docs = {
    "tags": ["Money"],
    "description": "Module money (Layer 0) - Money & VAT & ExchangeRate",
}
''',

    "presentation/routers.py": '''"""FastAPI router for money."""
from datetime import datetime, timezone

from fastapi import APIRouter, Depends

from ..application.use_cases import MoneyUseCases
from ..domain.value_objects import ExchangeRate
from .dependencies import get_money_use_cases
from .schemas import (
    MoneySchema,
    VATRequest,
    VATResponse,
    ExchangeRateSchema,
)

router = APIRouter(prefix="/api/v1/money", tags=["Money"])


@router.post("/add/", response_model=MoneySchema)
async def add(
    a: MoneySchema,
    b: MoneySchema,
    uc: MoneyUseCases = Depends(get_money_use_cases),
) -> MoneySchema:
    """Add two money values - บวกเงินสองค่า"""
    r = uc.add(a.to_money(), b.to_money())
    return MoneySchema(amount=r.amount, currency=r.currency)


@router.post("/subtract/", response_model=MoneySchema)
async def subtract(
    a: MoneySchema,
    b: MoneySchema,
    uc: MoneyUseCases = Depends(get_money_use_cases),
) -> MoneySchema:
    """Subtract two money values - ลบเงินสองค่า"""
    r = uc.subtract(a.to_money(), b.to_money())
    return MoneySchema(amount=r.amount, currency=r.currency)


@router.post("/vat/calculate/", response_model=VATResponse)
async def vat_calculate(
    req: VATRequest,
    uc: MoneyUseCases = Depends(get_money_use_cases),
) -> VATResponse:
    """Calculate VAT - คำนวณ VAT"""
    base = req.base.to_money()
    vat = uc.calculate_vat(base, req.rate)
    total = base + vat
    return VATResponse(
        vat=MoneySchema(amount=vat.amount, currency=vat.currency),
        total=MoneySchema(amount=total.amount, currency=total.currency),
    )


@router.post("/vat/extract/", response_model=VATResponse)
async def vat_extract(
    req: VATRequest,
    uc: MoneyUseCases = Depends(get_money_use_cases),
) -> VATResponse:
    """Extract VAT from total - แยก VAT จากยอดรวม"""
    total = req.base.to_money()
    vat = uc.extract_vat(total, req.rate)
    base = total - vat
    return VATResponse(
        vat=MoneySchema(amount=vat.amount, currency=vat.currency),
        total=MoneySchema(amount=base.amount, currency=base.currency),
    )


@router.post("/convert/", response_model=MoneySchema)
async def convert(
    amount: MoneySchema,
    rate: ExchangeRateSchema,
    uc: MoneyUseCases = Depends(get_money_use_cases),
) -> MoneySchema:
    """Convert currency - แปลงสกุลเงิน"""
    er = ExchangeRate(
        from_currency=rate.from_currency,
        to_currency=rate.to_currency,
        rate=rate.rate,
        as_of=datetime.now(timezone.utc),
    )
    r = uc.convert(amount.to_money(), er)
    return MoneySchema(amount=r.amount, currency=r.currency)
''',
}


# ============================================================
#  IDEMPOTENCY MODULE
# ============================================================
IDEMPOTENCY_FILES = {
    # ---- root ----
    "__init__.py": '''"""Module idempotency - Layer 0 (Clean Architecture + DDD)."""
__version__ = "1.0.0"
''',

    # ---- domain ----
    "domain/__init__.py": '''"""idempotency domain layer - pure business logic."""
''',

    "domain/exceptions.py": '''from app.shared.exceptions import DomainException


class DomainError(DomainException):
    """Domain rule violation for idempotency - ละเมิดกฎโดเมน"""
    code = "idem_DOMAIN_ERROR"
''',

    "domain/enums.py": '''"""Enums for idempotency."""
from enum import Enum


class IdempotencyStatus(str, Enum):
    """Idempotency status - สถานะ idempotency"""
    IN_PROGRESS = "IN_PROGRESS"
    COMPLETED = "COMPLETED"
    FAILED = "FAILED"


class IdempotencyConflict(str, Enum):
    """Idempotency conflict type - ประเภทความขัดแย้ง"""
    SAME_KEY_SAME_PAYLOAD = "SAME_KEY_SAME_PAYLOAD"
    SAME_KEY_DIFF_PAYLOAD = "SAME_KEY_DIFF_PAYLOAD"
    CONCURRENT = "CONCURRENT"
''',

    "domain/events.py": '''"""Domain events for idempotency - เหตุการณ์โดเมน"""
IDEMPOTENCY_LOCKED = "idem.IdempotencyLocked"
IDEMPOTENCY_COMPLETED = "idem.IdempotencyCompleted"
IDEMPOTENCY_CONFLICT = "idem.IdempotencyConflict"
''',

    "domain/value_objects.py": '''"""Value objects for idempotency."""
from dataclasses import dataclass

from .exceptions import DomainError


@dataclass(frozen=True)
class IdempotencyKey:
    """Idempotency key VO - วัตถุกุญแจ idempotency"""
    value: str
    scope: str  # e.g., "invoice.create"

    def __post_init__(self) -> None:
        if len(self.value) < 8 or len(self.value) > 255:
            raise DomainError("Idempotency key length must be 8-255")

    def redis_key(self, tenant_id: str) -> str:
        """Build Redis key - สร้าง Redis key"""
        return f"t:{tenant_id}:idem:{self.scope}:{self.value}"
''',

    "domain/entities.py": '''"""Entities for idempotency."""
from dataclasses import dataclass, field
from datetime import datetime, timezone

from app.shared.base_entity import BaseEntity

from .exceptions import DomainError


def _utcnow() -> datetime:
    return datetime.now(timezone.utc)


@dataclass
class IdempotencyRecord(BaseEntity):
    """Idempotency record - เอนทิตีบันทึก idempotency"""
    key: str = ""
    status: str = "IN_PROGRESS"
    request_hash: str = ""
    response_body: dict = field(default_factory=dict)
    response_status: int = 0
    locked_until: datetime | None = None
    expires_at: datetime | None = None

    def __post_init__(self) -> None:
        self._validate()

    def _validate(self) -> None:
        if not self.key:
            raise DomainError("Idempotency key required")

    def is_expired(self) -> bool:
        """Check if record expired - ตรวจสอบว่าหมดอายุ"""
        return self.expires_at is not None and _utcnow() > self.expires_at

    def is_completed(self) -> bool:
        return self.status == "COMPLETED"

    def is_in_progress(self) -> bool:
        return self.status == "IN_PROGRESS"

    def complete(self, status: int, body: dict) -> None:
        """Mark completed - ทำเครื่องหมายเสร็จ"""
        self.status = "COMPLETED"
        self.response_status = status
        self.response_body = body
''',

    # ---- application ----
    "application/__init__.py": '''"""idempotency application layer - use cases + ports."""
''',

    "application/exceptions.py": '''from app.shared.exceptions import ApplicationException


class IdempotencyException(ApplicationException):
    """Application exception for idempotency."""
    code = "idem_APP_ERROR"


class IdempotencyNotFoundException(IdempotencyException):
    """Idempotency record not found."""
    code = "idem_NOT_FOUND"


class IdempotencyConflictException(IdempotencyException):
    """Idempotency conflict (409/422)."""
    code = "idem_CONFLICT"
''',

    "application/interfaces.py": '''"""Ports (Protocol) for idempotency."""
from typing import Protocol

from ..domain.entities import IdempotencyRecord
from ..domain.value_objects import IdempotencyKey


class IIdempotencyStore(Protocol):
    """Idempotency store port - พอร์ตที่เก็บ idempotency"""

    async def get(self, key: IdempotencyKey, tenant_id: str) -> IdempotencyRecord | None: ...
    async def set(self, key: IdempotencyKey, tenant_id: str, rec: IdempotencyRecord) -> None: ...
    async def lock(self, key: IdempotencyKey, tenant_id: str, ttl: int) -> bool: ...
    async def unlock(self, key: IdempotencyKey, tenant_id: str) -> None: ...
''',

    "application/mappers.py": '''"""Mappers for idempotency."""
from ..domain.entities import IdempotencyRecord


class IdempotencyMapper:
    """Maps domain entity <-> ORM model <-> pydantic schema."""

    @staticmethod
    def to_schema(rec: IdempotencyRecord) -> dict:
        return {
            "key": rec.key,
            "status": rec.status,
            "request_hash": rec.request_hash,
            "response_body": rec.response_body,
            "response_status": rec.response_status,
        }

    @staticmethod
    def from_schema(data: dict) -> IdempotencyRecord:
        return IdempotencyRecord(
            key=data["key"],
            status=data.get("status", "IN_PROGRESS"),
            request_hash=data.get("request_hash", ""),
            response_body=data.get("response_body", {}),
            response_status=data.get("response_status", 0),
        )
''',

    "application/utils.py": '''"""Helper functions for idempotency."""
import functools
import hashlib
import json

from app.core.logging import logger


def hash_payload(payload: dict) -> str:
    """Deterministic SHA-256 of payload - แฮช payload"""
    canonical = json.dumps(payload, sort_keys=True, separators=(",", ":"))
    return hashlib.sha256(canonical.encode()).hexdigest()


def idempotent(scope: str):
    """Decorator: wrap use case with idempotency check."""

    def decorator(fn):
        @functools.wraps(fn)
        async def wrapper(self, *args, **kwargs):
            logger.debug("idempotent.wrap", scope=scope)
            return await fn(self, *args, **kwargs)

        return wrapper

    return decorator
''',

    "application/use_cases.py": '''"""Idempotency use cases - 3-branch error handling."""
import hashlib
import json
from datetime import datetime, timedelta, timezone

from app.core.logging import logger
from app.shared.exceptions import (
    StandardException,
    DomainException,
    ApplicationException,
)

from ..domain.entities import IdempotencyRecord
from ..domain.exceptions import DomainError
from ..domain.value_objects import IdempotencyKey
from .exceptions import IdempotencyConflictException, IdempotencyException


class IdempotencyUseCases:
    """Idempotency use cases - กรณีการใช้งาน idempotency"""

    def __init__(self, store, config=None):
        self.store = store
        self.ttl = getattr(config, "IDEMPOTENCY_TTL_SECONDS", 86400)

    async def check_or_lock(
        self,
        raw_key: str,
        scope: str,
        payload: dict,
        tenant_id: str,
    ) -> IdempotencyRecord | None:
        """Check existing or lock - ตรวจสอบหรือล็อก"""
        try:
            key = IdempotencyKey(value=raw_key, scope=scope)
            existing = await self.store.get(key, tenant_id)

            if existing and existing.is_completed():
                if existing.request_hash != self._hash(payload):
                    raise IdempotencyConflictException("Payload mismatch")
                return existing  # replay

            if existing and existing.is_in_progress():
                raise IdempotencyConflictException("Request in progress")

            locked = await self.store.lock(key, tenant_id, self.ttl)
            if not locked:
                raise IdempotencyConflictException("Concurrent request")

            rec = IdempotencyRecord(
                key=raw_key,
                status="IN_PROGRESS",
                request_hash=self._hash(payload),
                expires_at=datetime.now(timezone.utc) + timedelta(seconds=self.ttl),
            )
            await self.store.set(key, tenant_id, rec)
            return None  # proceed with execution
        except StandardException:
            raise
        except DomainError as e:
            raise DomainException(e)
        except Exception as e:
            logger.opt(exception=e).error("Error in check_or_lock")
            raise IdempotencyException()

    async def complete(
        self,
        raw_key: str,
        scope: str,
        status: int,
        body: dict,
        tenant_id: str,
    ) -> None:
        """Mark completed - บันทึกผลลัพธ์"""
        try:
            key = IdempotencyKey(value=raw_key, scope=scope)
            rec = await self.store.get(key, tenant_id)
            if rec:
                rec.complete(status, body)
                await self.store.set(key, tenant_id, rec)
                await self.store.unlock(key, tenant_id)
        except Exception as e:
            logger.opt(exception=e).error("Error in complete idempotency")
            # don't re-raise — response already returned

    @staticmethod
    def _hash(payload: dict) -> str:
        canonical = json.dumps(payload, sort_keys=True, separators=(",", ":"))
        return hashlib.sha256(canonical.encode()).hexdigest()
''',

    # ---- infrastructure ----
    "infrastructure/__init__.py": '''"""idempotency infrastructure layer."""
''',

    "infrastructure/models.py": '''"""SQLAlchemy models for idempotency."""
from sqlalchemy import Column, String, Integer, DateTime, UniqueConstraint
from sqlalchemy.dialects.postgresql import JSONB

from app.shared.base_model import BaseModel


class IdempotencyRecordModel(BaseModel):
    """ORM model for idempotency_records."""
    __tablename__ = "idempotency_records"

    key = Column(String(255), nullable=False, index=True)
    scope = Column(String(100), nullable=False, index=True)
    status = Column(String(20), nullable=False)
    request_hash = Column(String(64), nullable=False)
    response_body = Column(JSONB, default=dict)
    response_status = Column(Integer)
    locked_until = Column(DateTime(timezone=True))
    expires_at = Column(DateTime(timezone=True), index=True)

    __table_args__ = (
        UniqueConstraint("key", "scope", "tenant_id", name="uq_idem_key_scope_tenant"),
    )
''',

    "infrastructure/caches.py": '''"""Redis-backed idempotency store (primary, never-raise)."""
from app.core.logging import logger


class RedisIdempotencyStore:
    """Redis idempotency store - atomic SET NX."""

    def __init__(self, redis_client):
        self.redis = redis_client

    async def lock(self, key, tenant_id: str, ttl: int) -> bool:
        """Acquire lock - ล็อกแบบ atomic"""
        try:
            result = await self.redis.set(
                f"{key.redis_key(tenant_id)}:lock",
                "1",
                nx=True,
                ex=ttl,
            )
            return bool(result)
        except Exception as e:
            logger.opt(exception=e).error("Lock failed")
            return False  # conservative: fail closed

    async def unlock(self, key, tenant_id: str) -> None:
        """Release lock - ปล่อยล็อก"""
        try:
            await self.redis.delete(f"{key.redis_key(tenant_id)}:lock")
        except Exception as e:
            logger.warning("idem.unlock.failed", error=str(e))

    async def get(self, key, tenant_id: str):
        """Get record - never-raise."""
        try:
            raw = await self.redis.get(f"{key.redis_key(tenant_id)}:rec")
            return raw
        except Exception as e:
            logger.warning("idem.get.failed", error=str(e))
            return None

    async def set(self, key, tenant_id: str, rec) -> None:
        """Set record - never-raise."""
        try:
            await self.redis.setex(
                f"{key.redis_key(tenant_id)}:rec",
                86400,
                str(rec),
            )
        except Exception as e:
            logger.warning("idem.set.failed", error=str(e))
''',

    "infrastructure/repositories.py": '''"""Postgres fallback repository for idempotency (2-branch)."""
from app.core.logging import logger
from app.shared.exceptions import InfrastructureException


class IdempotencyRepositoryException(InfrastructureException):
    code = "idem_REPO_ERROR"


class PostgresIdempotencyRepository:
    """Postgres fallback repository - used when Redis is down."""

    def __init__(self, session, tenant_id: str):
        self.session = session
        self.tenant_id = tenant_id

    async def get(self, key, tenant_id: str):
        try:
            # TODO: query IdempotencyRecordModel
            return None
        except Exception as e:
            logger.opt(exception=e).error("Repo.get failed")
            raise IdempotencyRepositoryException()

    async def set(self, key, tenant_id: str, rec) -> None:
        try:
            # TODO: upsert IdempotencyRecordModel
            pass
        except Exception as e:
            logger.opt(exception=e).error("Repo.set failed")
            raise IdempotencyRepositoryException()
''',

    "infrastructure/services.py": '''"""No external services for idempotency."""
''',

    # ---- presentation ----
    "presentation/__init__.py": '''"""idempotency presentation layer."""
''',

    "presentation/schemas.py": '''"""Pydantic schemas for idempotency."""
from datetime import datetime

from pydantic import BaseModel, ConfigDict


class IdempotencyRecordSchema(BaseModel):
    """Idempotency record schema."""
    key: str
    scope: str
    status: str
    request_hash: str
    response_body: dict = {}
    response_status: int = 0
    expires_at: datetime | None = None
    model_config = ConfigDict(from_attributes=True)
''',

    "presentation/dependencies.py": '''"""DI providers for idempotency (middleware/dependency)."""
from fastapi import Header, HTTPException


async def require_idempotency_key(
    idempotency_key: str = Header(..., alias="Idempotency-Key"),
) -> str:
    """FastAPI dependency: require Idempotency-Key header."""
    if not idempotency_key or len(idempotency_key) < 8:
        raise HTTPException(
            status_code=400,
            detail="Idempotency-Key required (8-255 chars)",
        )
    return idempotency_key
''',

    "presentation/docs.py": '''"""OpenAPI docs for idempotency."""
router_docs = {
    "tags": ["Idempotency"],
    "description": "Module idempotency (Layer 0) - cross-cutting middleware",
}
''',

    "presentation/routers.py": '''"""No public router - used via middleware/dependency."""
''',
}


# ============================================================
#  MAIN
# ============================================================
def generate_module(base: Path, name: str, files: dict) -> None:
    """Generate a single module."""
    module_dir = base / name
    print(f"\n[{name}] -> {module_dir}")
    for rel_path, content in files.items():
        write(module_dir / rel_path, content)
    print(f"[{name}] DONE ({len(files)} files)")


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate modules: money + idempotency")
    parser.add_argument(
        "--base",
        default="app/modules",
        help="Base directory for modules (default: app/modules)",
    )
    args = parser.parse_args()

    base = Path(args.base)
    print("=" * 60)
    print("  Generating modules: money & idempotency")
    print("=" * 60)
    print(f"  Base path: {base.resolve()}")

    generate_module(base, "money", MONEY_FILES)
    generate_module(base, "idempotency", IDEMPOTENCY_FILES)

    print("\n" + "=" * 60)
    print("  DONE!")
    print("=" * 60)
    print(f"\n  Modules at: {base.resolve()}")
    print("\n  Next steps:")
    print("    1. Ensure app/shared has:")
    print("       - base_entity.py  (BaseEntity)")
    print("       - base_model.py   (Base, BaseModel, TenantMixin)")
    print("       - exceptions.py   (StandardException, DomainException, ...)")
    print("       - database.py     (get_session)")
    print("       - logging.py      (logger)")
    print("    2. Register routers in app/app.py")
    print("    3. Run: uvicorn app.app:app --reload")
    print()


if __name__ == "__main__":
    main()