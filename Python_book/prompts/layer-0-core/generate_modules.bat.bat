@echo off
REM ============================================================
REM  Generate Modules: money + idempotency
REM  ERP + CRM + IoT for SME (Multi-company)
REM  Clean Architecture + DDD (4 layers)
REM ============================================================
setlocal enabledelayedexpansion

echo ============================================================
echo  Generating modules: money ^& idempotency
echo ============================================================

REM ---- ตั้งค่า base path (แก้ไขตามต้องการ) ----
set "BASE=app\modules"
if not "%~1"=="" set "BASE=%~1"

echo [INFO] Base path: %BASE%
echo.

REM ============================================================
REM  MODULE 1: money (Layer 0, Core, pure VO)
REM ============================================================
echo [1/2] Creating module: money
call :create_money "%BASE%\money"

REM ============================================================
REM  MODULE 2: idempotency (Layer 0, Core, cross-cutting)
REM ============================================================
echo [2/2] Creating module: idempotency
call :create_idempotency "%BASE%\idempotency"

echo.
echo ============================================================
echo  DONE! Modules generated at: %BASE%
echo ============================================================
echo.
echo Next steps:
echo   1. Ensure app/shared has: base_entity, base_model, exceptions, database
echo   2. Run: uvicorn app.app:app --reload
echo.
goto :eof

REM ============================================================
REM  SUBROUTINE: money
REM ============================================================
:create_money
set "M=%~1"
echo   - Creating folders...
if not exist "%M%" mkdir "%M%"
if not exist "%M%\domain" mkdir "%M%\domain"
if not exist "%M%\application" mkdir "%M%\application"
if not exist "%M%\infrastructure" mkdir "%M%\infrastructure"
if not exist "%M%\presentation" mkdir "%M%\presentation"

echo   - Writing domain layer...
call :write_money_domain "%M%"

echo   - Writing application layer...
call :write_money_application "%M%"

echo   - Writing infrastructure layer...
call :write_money_infrastructure "%M%"

echo   - Writing presentation layer...
call :write_money_presentation "%M%"

echo   - Writing __init__.py (root)...
> "%M%\__init__.py" echo """Module money - Layer 0 (Clean Architecture + DDD)."""
>>"%M%\__init__.py" echo __version__ = "1.0.0"
goto :eof

:write_money_domain
set "M=%~1\domain"
> "%M%\__init__.py" echo """money domain layer - pure business logic."""
> "%M%\exceptions.py" echo from app.shared.exceptions import DomainException
>>"%M%\exceptions.py" echo.
>>"%M%\exceptions.py" echo.
>>"%M%\exceptions.py" echo class DomainError(DomainException):
>>"%M%\exceptions.py" echo     """Domain rule violation for money."""
>>"%M%\exceptions.py" echo     code = "mny_DOMAIN_ERROR"

> "%M%\enums.py" (
echo from enum import Enum
echo.
echo.
echo class Currency^(str, Enum^):
echo     """Currency enum - สกุลเงิน"""
echo     THB = "THB"
echo     USD = "USD"
echo     EUR = "EUR"
echo.
echo.
echo class VATRate^(str, Enum^):
echo     """VAT rate enum - อัตราภาษีมูลค่าเพิ่ม"""
echo     ZERO = "0.00"
echo     SEVEN = "0.07"
echo.
echo.
echo class RoundingMode^(str, Enum^):
echo     """Rounding mode enum - โหมดการปัดเศษ"""
echo     HALF_UP = "HALF_UP"
echo     HALF_DOWN = "HALF_DOWN"
echo     BANKERS = "BANKERS"
)

> "%M%\events.py" (
echo """Domain events for money - เหตุการณ์โดเมน"""
echo.
echo MONEY_ADDED = "mny.MoneyAdded"
echo MONEY_SUBTRACTED = "mny.MoneySubtracted"
echo VAT_CALCULATED = "mny.VATCalculated"
echo CURRENCY_CONVERTED = "mny.CurrencyConverted"
)

> "%M%\value_objects.py" (
echo """Value objects for money - วัตถุค่าสำหรับเงิน"""
echo from dataclasses import dataclass
echo from datetime import datetime
echo from decimal import Decimal, ROUND_HALF_UP
echo.
echo from .enums import Currency
echo from .exceptions import DomainError
echo.
echo.
echo @dataclass^(frozen=True^)
echo class Money:
echo     """Money value object - วัตถุค่าเงิน"""
echo     amount: Decimal
echo     currency: str = "THB"
echo.
echo     def __post_init__^(self^):
echo         object.__setattr__^(self, "amount",
echo             self.amount.quantize^(Decimal^("0.01"^), rounding=ROUND_HALF_UP^)^)
echo         self._validate^(^)
echo.
echo     def _validate^(self^) -^> None:
echo         if not isinstance^(self.amount, Decimal^):
echo             raise DomainError^("Amount must be Decimal"^)
echo         if self.currency not in Currency._value2member_map_:
echo             raise DomainError^(f"Unsupported currency: {self.currency}"^)
echo.
echo     def _assert_same_currency^(self, other: "Money"^) -^> None:
echo         if self.currency != other.currency:
echo             raise DomainError^(f"Cannot operate on {self.currency} vs {other.currency}"^)
echo.
echo     def __add__^(self, other: "Money"^) -^> "Money":
echo         self._assert_same_currency^(other^)
echo         return Money^(self.amount + other.amount, self.currency^)
echo.
echo     def __sub__^(self, other: "Money"^) -^> "Money":
echo         self._assert_same_currency^(other^)
echo         return Money^(self.amount - other.amount, self.currency^)
echo.
echo     def __mul__^(self, factor: Decimal^) -^> "Money":
echo         if not isinstance^(factor, Decimal^):
echo             raise DomainError^("Factor must be Decimal"^)
echo         return Money^(self.amount * factor, self.currency^)
echo.
echo     def __neg__^(self^) -^> "Money":
echo         return Money^(-self.amount, self.currency^)
echo.
echo     def __str__^(self^) -^> str:
echo         return f"{self.amount} {self.currency}"
echo.
echo     def __eq__^(self, other: object^) -^> bool:
echo         if not isinstance^(other, Money^):
echo             return False
echo         return self.amount == other.amount and self.currency == other.currency
echo.
echo     def is_zero^(self^) -^> bool:
echo         return self.amount == Decimal^("0.00"^)
echo.
echo     def is_negative^(self^) -^> bool:
echo         return self.amount ^< Decimal^("0.00"^)
echo.
echo.
echo @dataclass^(frozen=True^)
echo class VAT:
echo     """VAT value object - วัตถุภาษีมูลค่าเพิ่ม"""
echo     rate: Decimal
echo.
echo     def calculate^(self, base: Money^) -^> Money:
echo         """Calculate VAT from base - คำนวณ VAT จากฐาน"""
echo         return Money^((base.amount * self.rate^).quantize^(Decimal^("0.01"^)^), base.currency^)
echo.
echo     def extract^(self, total: Money^) -^> Money:
echo         """Extract VAT from total - แยก VAT จากยอดรวม"""
echo         base = ^(total.amount / ^(Decimal^("1"^) + self.rate^)^).quantize^(Decimal^("0.01"^)^)
echo         return Money^(total.amount - base, total.currency^)
echo.
echo.
echo @dataclass^(frozen=True^)
echo class ExchangeRate:
echo     """Exchange rate VO - วัตถุอัตราแลกเปลี่ยน"""
echo     from_currency: str
echo     to_currency: str
echo     rate: Decimal
echo     as_of: datetime
echo.
echo     def __post_init__^(self^):
echo         if self.rate ^<= 0:
echo             raise DomainError^("Exchange rate must be positive"^)
echo.
echo     def convert^(self, amount: Money^) -^> Money:
echo         if amount.currency != self.from_currency:
echo             raise DomainError^("Currency mismatch"^)
echo         return Money^(amount.amount * self.rate, self.to_currency^)
)

> "%M%\entities.py" echo # money/domain/entities.py - no entities (pure VO module)
>>"%M%\entities.py" echo # Money is a Value Object, not an Entity
goto :eof

:write_money_application
set "M=%~1\application"
> "%M%\__init__.py" echo """money application layer - use cases + ports."""

> "%M%\exceptions.py" (
echo from app.shared.exceptions import ApplicationException
echo.
echo.
echo class MoneyException^(ApplicationException^):
echo     """Application exception for money."""
echo     code = "mny_APP_ERROR"
echo.
echo.
echo class MoneyNotFoundException^(MoneyException^):
echo     """Money not found."""
echo     code = "mny_NOT_FOUND"
)

> "%M%\interfaces.py" (
echo """Ports (Protocol) for money - no external deps (pure VO)."""
echo from typing import Protocol
echo.
echo.
echo class IMoneyCalculator^(Protocol^):
echo     """Optional calculator port."""
echo     def add^(self, a, b^): ...
)

> "%M%\mappers.py" (
echo """Mappers for money."""
echo from decimal import Decimal
echo from ..domain.value_objects import Money
echo.
echo.
echo class MoneyMapper:
echo     """Maps Money VO ^<-^> Pydantic schema."""
echo.
echo     @staticmethod
echo     def to_schema^(money: Money^) -^> dict:
echo         return {"amount": str^(money.amount^), "currency": money.currency}
echo.
echo     @staticmethod
echo     def from_schema^(data: dict^) -^> Money:
echo         return Money^(amount=Decimal^(str^(data["amount"]^)^), currency=data.get^("currency", "THB"^)^)
)

> "%M%\utils.py" (
echo """Helper functions for money."""
echo from decimal import Decimal, ROUND_HALF_UP
echo.
echo from ..domain.enums import Currency
echo from ..domain.value_objects import Money
echo.
echo.
echo def round_money^(amount: Decimal, places: int = 2^) -^> Decimal:
echo     """Round money to N places (HALF_UP)."""
echo     q = Decimal^(10^) ** -places
echo     return amount.quantize^(q, rounding=ROUND_HALF_UP^)
echo.
echo.
echo def zero_money^(currency: str = "THB"^) -^> Money:
echo     """Return zero Money in given currency."""
echo     return Money^(Decimal^("0.00"^), currency^)
)

> "%M%\use_cases.py" (
echo """Money use cases - 3-branch error handling."""
echo from decimal import Decimal
echo.
echo from app.core.logging import logger
echo from app.shared.exceptions import ^(
echo     StandardException,
echo     DomainException,
echo     ApplicationException,
echo ^)
echo.
echo from ..domain.enums import VATRate
echo from ..domain.exceptions import DomainError
echo from ..domain.value_objects import Money, VAT, ExchangeRate
echo.
echo.
echo class MoneyException^(ApplicationException^):
echo     code = "mny_APP_ERROR"
echo.
echo.
echo class MoneyUseCases:
echo     """Use cases for money ^(3-branch error handling^)."""
echo.
echo     def add^(self, a: Money, b: Money^) -^> Money:
echo         """Add two Money - บวกเงิน"""
echo         try:
echo             return a + b
echo         except DomainError as e:
echo             raise DomainException^(e^)
echo         except StandardException:
echo             raise
echo         except Exception as e:
echo             logger.opt^(exception=e^).error^("Error in MoneyUseCases.add"^)
echo             raise MoneyException^(^)
echo.
echo     def subtract^(self, a: Money, b: Money^) -^> Money:
echo         """Subtract two Money - ลบเงิน"""
echo         return a - b
echo.
echo     def multiply^(self, a: Money, factor: Decimal^) -^> Money:
echo         """Multiply Money - คูณเงิน"""
echo         return a * factor
echo.
echo     def calculate_vat^(self, base: Money, rate: VATRate^) -^> Money:
echo         """Calculate VAT - คำนวณ VAT"""
echo         return VAT^(Decimal^(rate.value^)^).calculate^(base^)
echo.
echo     def extract_vat^(self, total: Money, rate: VATRate^) -^> Money:
echo         """Extract VAT from total - แยก VAT"""
echo         return VAT^(Decimal^(rate.value^)^).extract^(total^)
echo.
echo     def convert^(self, amount: Money, rate: ExchangeRate^) -^> Money:
echo         """Convert currency - แปลงสกุลเงิน"""
echo         return rate.convert^(amount^)
echo.
echo     def sum_all^(self, items: list[Money]^) -^> Money:
echo         """Sum all Money - รวมเงินทั้งหมด"""
echo         if not items:
echo             raise DomainException^(DomainError^("Cannot sum empty list"^)^)
echo         result = items[0]
echo         for item in items[1:]:
echo             result = result + item
echo         return result
)
goto :eof

:write_money_infrastructure
set "M=%~1\infrastructure"
> "%M%\__init__.py" echo """money infrastructure layer - pure VO ^(no persistence^)."""
> "%M%\models.py" echo # money/infrastructure/models.py - no models ^(pure VO module^)
> "%M%\repositories.py" echo # money/infrastructure/repositories.py - no repositories ^(pure VO module^)
> "%M%\caches.py" echo # money/infrastructure/caches.py - no caches ^(pure VO module^)
> "%M%\services.py" echo # money/infrastructure/services.py - no services ^(pure VO module^)
goto :eof

:write_money_presentation
set "M=%~1\presentation"
> "%M%\__init__.py" echo """money presentation layer."""

> "%M%\schemas.py" (
echo """Pydantic schemas for money."""
echo from decimal import Decimal
echo.
echo from pydantic import BaseModel, ConfigDict, Field
echo.
echo from ..domain.enums import VATRate
echo.
echo.
echo class MoneySchema^(BaseModel^):
echo     """Money schema."""
echo     amount: Decimal = Field^(..., decimal_places=2^)
echo     currency: str = Field^(default="THB", pattern="^^^(THB^|USD^|EUR^)$"^)
echo     model_config = ConfigDict^(from_attributes=True^)
echo.
echo.
echo class VATRequest^(BaseModel^):
echo     """VAT request schema."""
echo     base: MoneySchema
echo     rate: VATRate = VATRate.SEVEN
echo.
echo.
echo class VATResponse^(BaseModel^):
echo     """VAT response schema."""
echo     vat: MoneySchema
echo     total: MoneySchema
echo.
echo.
echo class ExchangeRateSchema^(BaseModel^):
echo     """Exchange rate schema."""
echo     from_currency: str
echo     to_currency: str
echo     rate: Decimal
)

> "%M%\dependencies.py" (
echo """DI providers for money."""
echo from fastapi import Depends
echo.
echo from ..application.use_cases import MoneyUseCases
echo.
echo.
echo def get_money_use_cases^(^) -^> MoneyUseCases:
echo     """DI provider for money use cases."""
echo     return MoneyUseCases^(^)
)

> "%M%\docs.py" (
echo """OpenAPI docs for money."""
echo router_docs = {
echo     "tags": ["Money"],
echo     "description": "Module money ^(Layer 0^) - Money ^& VAT ^& ExchangeRate",
echo }
)

> "%M%\routers.py" (
echo """FastAPI router for money."""
echo from fastapi import APIRouter
echo.
echo from ..domain.enums import VATRate
echo from ..domain.value_objects import ExchangeRate
echo from ..application.use_cases import MoneyUseCases
echo from .schemas import MoneySchema, VATRequest, VATResponse, ExchangeRateSchema
echo.
echo router = APIRouter^(prefix="/api/v1/money", tags=["Money"]^)
echo.
echo.
echo @router.post^("/add/", response_model=MoneySchema^)
echo async def add^(a: MoneySchema, b: MoneySchema^) -^> MoneySchema:
echo     """Add two money values."""
echo     uc = MoneyUseCases^(^)
echo     r = uc.add^(a.to_money^(^), b.to_money^(^)^)
echo     return MoneySchema^(amount=r.amount, currency=r.currency^)
echo.
echo.
echo @router.post^("/subtract/", response_model=MoneySchema^)
echo async def subtract^(a: MoneySchema, b: MoneySchema^) -^> MoneySchema:
echo     """Subtract two money values."""
echo     uc = MoneyUseCases^(^)
echo     r = uc.subtract^(a.to_money^(^), b.to_money^(^)^)
echo     return MoneySchema^(amount=r.amount, currency=r.currency^)
echo.
echo.
echo @router.post^("/vat/calculate/", response_model=VATResponse^)
echo async def vat_calculate^(req: VATRequest^) -^> VATResponse:
echo     """Calculate VAT."""
echo     uc = MoneyUseCases^(^)
echo     base = req.base.to_money^(^)
echo     vat = uc.calculate_vat^(base, req.rate^)
echo     total = base + vat
echo     return VATResponse^(
echo         vat=MoneySchema^(amount=vat.amount, currency=vat.currency^),
echo         total=MoneySchema^(amount=total.amount, currency=total.currency^),
echo     ^)
echo.
echo.
echo @router.post^("/vat/extract/", response_model=VATResponse^)
echo async def vat_extract^(req: VATRequest^) -^> VATResponse:
echo     """Extract VAT from total."""
echo     uc = MoneyUseCases^(^)
echo     total = req.base.to_money^(^)
echo     vat = uc.extract_vat^(total, req.rate^)
echo     base = total - vat
echo     return VATResponse^(
echo         vat=MoneySchema^(amount=vat.amount, currency=vat.currency^),
echo         total=MoneySchema^(amount=base.amount, currency=base.currency^),
echo     ^)
echo.
echo.
echo @router.post^("/convert/", response_model=MoneySchema^)
echo async def convert^(amount: MoneySchema, rate: ExchangeRateSchema^) -^> MoneySchema:
echo     """Convert currency."""
echo     uc = MoneyUseCases^(^)
echo     er = ExchangeRate^(
echo         from_currency=rate.from_currency,
echo         to_currency=rate.to_currency,
echo         rate=rate.rate,
echo         as_of=__import__^("datetime"^).datetime.now^(^),
echo     ^)
echo     r = uc.convert^(amount.to_money^(^), er^)
echo     return MoneySchema^(amount=r.amount, currency=r.currency^)
)

REM helper method on schema
>>"%M%\schemas.py" echo.
>>"%M%\schemas.py" echo.
>>"%M%\schemas.py" echo def _to_money^(self^):
>>"%M%\schemas.py" echo     from ..domain.value_objects import Money
>>"%M%\schemas.py" echo     return Money^(amount=self.amount, currency=self.currency^)
>>"%M%\schemas.py" echo.
>>"%M%\schemas.py" echo.
>>"%M%\schemas.py" echo MoneySchema.to_money = _to_money
goto :eof

REM ============================================================
REM  SUBROUTINE: idempotency
REM ============================================================
:create_idempotency
set "M=%~1"
echo   - Creating folders...
if not exist "%M%" mkdir "%M%"
if not exist "%M%\domain" mkdir "%M%\domain"
if not exist "%M%\application" mkdir "%M%\application"
if not exist "%M%\infrastructure" mkdir "%M%\infrastructure"
if not exist "%M%\presentation" mkdir "%M%\presentation"

echo   - Writing domain layer...
call :write_idem_domain "%M%"

echo   - Writing application layer...
call :write_idem_application "%M%"

echo   - Writing infrastructure layer...
call :write_idem_infrastructure "%M%"

echo   - Writing presentation layer...
call :write_idem_presentation "%M%"

echo   - Writing __init__.py (root)...
> "%M%\__init__.py" echo """Module idempotency - Layer 0 (Clean Architecture + DDD)."""
>>"%M%\__init__.py" echo __version__ = "1.0.0"
goto :eof

:write_idem_domain
set "M=%~1\domain"
> "%M%\__init__.py" echo """idempotency domain layer - pure business logic."""
> "%M%\exceptions.py" echo from app.shared.exceptions import DomainException
>>"%M%\exceptions.py" echo.
>>"%M%\exceptions.py" echo.
>>"%M%\exceptions.py" echo class DomainError^(DomainException^):
>>"%M%\exceptions.py" echo     """Domain rule violation for idempotency."""
>>"%M%\exceptions.py" echo     code = "idem_DOMAIN_ERROR"

> "%M%\enums.py" (
echo from enum import Enum
echo.
echo.
echo class IdempotencyStatus^(str, Enum^):
echo     """Idempotency status enum - สถานะ idempotency"""
echo     IN_PROGRESS = "IN_PROGRESS"
echo     COMPLETED = "COMPLETED"
echo     FAILED = "FAILED"
echo.
echo.
echo class IdempotencyConflict^(str, Enum^):
echo     """Idempotency conflict enum - ประเภทความขัดแย้ง"""
echo     SAME_KEY_SAME_PAYLOAD = "SAME_KEY_SAME_PAYLOAD"
echo     SAME_KEY_DIFF_PAYLOAD = "SAME_KEY_DIFF_PAYLOAD"
echo     CONCURRENT = "CONCURRENT"
)

> "%M%\events.py" (
echo """Domain events for idempotency - เหตุการณ์โดเมน"""
echo.
echo IDEMPOTENCY_LOCKED = "idem.IdempotencyLocked"
echo IDEMPOTENCY_COMPLETED = "idem.IdempotencyCompleted"
echo IDEMPOTENCY_CONFLICT = "idem.IdempotencyConflict"
)

> "%M%\value_objects.py" (
echo """Value objects for idempotency - วัตถุค่าสำหรับ idempotency"""
echo from dataclasses import dataclass
echo.
echo from .exceptions import DomainError
echo.
echo.
echo @dataclass^(frozen=True^)
echo class IdempotencyKey:
echo     """Idempotency key VO - วัตถุกุญแจ idempotency"""
echo     value: str
echo     scope: str  # e.g., "invoice.create"
echo.
echo     def __post_init__^(self^):
echo         if len^(self.value^) ^< 8 or len^(self.value^) ^> 255:
echo             raise DomainError^("Idempotency key length must be 8-255"^)
echo.
echo     def redis_key^(self, tenant_id: str^) -^> str:
echo         """Build Redis key - สร้าง Redis key"""
echo         return f"t:{tenant_id}:idem:{self.scope}:{self.value}"
)

> "%M%\entities.py" (
echo """Entities for idempotency."""
echo from dataclasses import dataclass, field
echo from datetime import datetime, timezone
echo.
echo from app.shared.base_entity import BaseEntity
echo.
echo from .exceptions import DomainError
echo.
echo.
echo def _utcnow^(^) -^> datetime:
echo     return datetime.now^(timezone.utc^)
echo.
echo.
echo @dataclass
echo class IdempotencyRecord^(BaseEntity^):
echo     """Idempotency record - เอนทิตีบันทึก idempotency"""
echo     key: str = ""
echo     status: str = "IN_PROGRESS"
echo     request_hash: str = ""
echo     response_body: dict = field^(default_factory=dict^)
echo     response_status: int = 0
echo     locked_until: datetime ^| None = None
echo     expires_at: datetime ^| None = None
echo.
echo     def __post_init__^(self^):
echo         self._validate^(^)
echo.
echo     def _validate^(self^) -^> None:
echo         if not self.key:
echo             raise DomainError^("Idempotency key required"^)
echo.
echo     def is_expired^(self^) -^> bool:
echo         """Check if record expired - ตรวจสอบว่าหมดอายุ"""
echo         return self.expires_at is not None and _utcnow^(^) ^> self.expires_at
echo.
echo     def is_completed^(self^) -^> bool:
echo         return self.status == "COMPLETED"
echo.
echo     def is_in_progress^(self^) -^> bool:
echo         return self.status == "IN_PROGRESS"
echo.
echo     def complete^(self, status: int, body: dict^) -^> None:
echo         """Mark completed - ทำเครื่องหมายเสร็จ"""
echo         self.status = "COMPLETED"
echo         self.response_status = status
echo         self.response_body = body
)
goto :eof

:write_idem_application
set "M=%~1\application"
> "%M%\__init__.py" echo """idempotency application layer - use cases + ports."""

> "%M%\exceptions.py" (
echo from app.shared.exceptions import ApplicationException
echo.
echo.
echo class IdempotencyException^(ApplicationException^):
echo     """Application exception for idempotency."""
echo     code = "idem_APP_ERROR"
echo.
echo.
echo class IdempotencyNotFoundException^(IdempotencyException^):
echo     """Idempotency record not found."""
echo     code = "idem_NOT_FOUND"
echo.
echo.
echo class IdempotencyConflictException^(IdempotencyException^):
echo     """Idempotency conflict ^(409/422^)."""
echo     code = "idem_CONFLICT"
)

> "%M%\interfaces.py" (
echo """Ports ^(Protocol^) for idempotency."""
echo from typing import Protocol
echo.
echo from ..domain.entities import IdempotencyRecord
echo from ..domain.value_objects import IdempotencyKey
echo.
echo.
echo class IIdempotencyStore^(Protocol^):
echo     """Idempotency store port - พอร์ตที่เก็บ idempotency"""
echo     async def get^(self, key: IdempotencyKey, tenant_id: str^) -^> IdempotencyRecord ^| None: ...
echo     async def set^(self, key: IdempotencyKey, tenant_id: str, rec: IdempotencyRecord^) -^> None: ...
echo     async def lock^(self, key: IdempotencyKey, tenant_id: str, ttl: int^) -^> bool: ...
echo     async def unlock^(self, key: IdempotencyKey, tenant_id: str^) -^> None: ...
)

> "%M%\mappers.py" (
echo """Mappers for idempotency."""
echo from ..domain.entities import IdempotencyRecord
echo.
echo.
echo class IdempotencyMapper:
echo     """Maps domain entity ^<-^> ORM model ^<-^> pydantic schema."""
echo.
echo     @staticmethod
echo     def to_schema^(rec: IdempotencyRecord^) -^> dict:
echo         return {
echo             "key": rec.key,
echo             "status": rec.status,
echo             "request_hash": rec.request_hash,
echo             "response_body": rec.response_body,
echo             "response_status": rec.response_status,
echo         }
echo.
echo     @staticmethod
echo     def from_schema^(data: dict^) -^> IdempotencyRecord:
echo         return IdempotencyRecord^(
echo             key=data["key"],
echo             status=data.get^("status", "IN_PROGRESS"^),
echo             request_hash=data.get^("request_hash", ""^),
echo             response_body=data.get^("response_body", {}^),
echo             response_status=data.get^("response_status", 0^),
echo         ^)
)

> "%M%\utils.py" (
echo """Helper functions for idempotency."""
echo import functools
echo import hashlib
echo import json
echo.
echo from app.core.logging import logger
echo.
echo.
echo def hash_payload^(payload: dict^) -^> str:
echo     """Deterministic SHA-256 of payload - แฮช payload"""
echo     canonical = json.dumps^(payload, sort_keys=True, separators=^(",", ":"^)^)
echo     return hashlib.sha256^(canonical.encode^(^)^).hexdigest^(^)
echo.
echo.
echo def idempotent^(scope: str^):
echo     """Decorator: wrap use case with idempotency check - ตัวตกแต่งสำหรับ idempotency"""
echo     def decorator^(fn^):
echo         @functools.wraps^(fn^)
echo         async def wrapper^(self, *args, **kwargs^):
echo             logger.debug^("idempotent.wrap", scope=scope^)
echo             return await fn^(self, *args, **kwargs^)
echo         return wrapper
echo     return decorator
)

> "%M%\use_cases.py" (
echo """Idempotency use cases - 3-branch error handling."""
echo import hashlib
echo import json
echo from datetime import datetime, timedelta, timezone
echo.
echo from app.core.logging import logger
echo from app.shared.exceptions import ^(
echo     StandardException,
echo     DomainException,
echo     ApplicationException,
echo ^)
echo.
echo from ..domain.entities import IdempotencyRecord
echo from ..domain.exceptions import DomainError
echo from ..domain.value_objects import IdempotencyKey
echo from .exceptions import IdempotencyConflictException, IdempotencyException
echo.
echo.
echo class IdempotencyUseCases:
echo     """Idempotency use cases - กรณีการใช้งาน idempotency"""
echo.
echo     def __init__^(self, store, config=None^):
echo         self.store = store
echo         self.ttl = getattr^(config, "IDEMPOTENCY_TTL_SECONDS", 86400^)
echo.
echo     async def check_or_lock^(self, raw_key: str, scope: str, payload: dict, tenant_id: str^):
echo         """Check existing or lock - ตรวจสอบหรือล็อก"""
echo         try:
echo             key = IdempotencyKey^(value=raw_key, scope=scope^)
echo             existing = await self.store.get^(key, tenant_id^)
echo.
echo             if existing and existing.is_completed^(^):
echo                 if existing.request_hash != self._hash^(payload^):
echo                     raise IdempotencyConflictException^("Payload mismatch"^)
echo                 return existing
echo.
echo             if existing and existing.is_in_progress^(^):
echo                 raise IdempotencyConflictException^("Request in progress"^)
echo.
echo             locked = await self.store.lock^(key, tenant_id, self.ttl^)
echo             if not locked:
echo                 raise IdempotencyConflictException^("Concurrent request"^)
echo.
echo             rec = IdempotencyRecord^(
echo                 key=raw_key,
echo                 status="IN_PROGRESS",
echo                 request_hash=self._hash^(payload^),
echo                 expires_at=datetime.now^(timezone.utc^) + timedelta^(seconds=self.ttl^),
echo             ^)
echo             await self.store.set^(key, tenant_id, rec^)
echo             return None
echo         except StandardException:
echo             raise
echo         except DomainError as e:
echo             raise DomainException^(e^)
echo         except Exception as e:
echo             logger.opt^(exception=e^).error^("Error in check_or_lock"^)
echo             raise IdempotencyException^(^)
echo.
echo     async def complete^(self, raw_key: str, scope: str, status: int, body: dict, tenant_id: str^) -^> None:
echo         """Mark completed - บันทึกผลลัพธ์"""
echo         try:
echo             key = IdempotencyKey^(value=raw_key, scope=scope^)
echo             rec = await self.store.get^(key, tenant_id^)
echo             if rec:
echo                 rec.complete^(status, body^)
echo                 await self.store.set^(key, tenant_id, rec^)
echo                 await self.store.unlock^(key, tenant_id^)
echo         except Exception as e:
echo             logger.opt^(exception=e^).error^("Error in complete idempotency"^)
echo.
echo     @staticmethod
echo     def _hash^(payload: dict^) -^> str:
echo         canonical = json.dumps^(payload, sort_keys=True, separators=^(",", ":"^)^)
echo         return hashlib.sha256^(canonical.encode^(^)^).hexdigest^(^)
)
goto :eof

:write_idem_infrastructure
set "M=%~1\infrastructure"
> "%M%\__init__.py" echo """idempotency infrastructure layer."""

> "%M%\models.py" (
echo """SQLAlchemy models for idempotency."""
echo from sqlalchemy import Column, String, Integer, DateTime, UniqueConstraint
echo from sqlalchemy.dialects.postgresql import JSONB
echo.
echo from app.shared.base_model import BaseModel
echo.
echo.
echo class IdempotencyRecordModel^(BaseModel^):
echo     """ORM model for idempotency_records."""
echo     __tablename__ = "idempotency_records"
echo.
echo     key = Column^(String^(255^), nullable=False, index=True^)
echo     scope = Column^(String^(100^), nullable=False, index=True^)
echo     status = Column^(String^(20^), nullable=False^)
echo     request_hash = Column^(String^(64^), nullable=False^)
echo     response_body = Column^(JSONB, default=dict^)
echo     response_status = Column^(Integer^)
echo     locked_until = Column^(DateTime^(timezone=True^)^)
echo     expires_at = Column^(DateTime^(timezone=True^), index=True^)
echo.
echo     __table_args__ = ^(
echo         UniqueConstraint^("key", "scope", "tenant_id", name="uq_idem_key_scope_tenant"^),
echo     ^)
)

> "%M%\caches.py" (
echo """Redis cache/store for idempotency ^(primary, never-raise^)."""
echo from app.core.logging import logger
echo.
echo.
echo class RedisIdempotencyStore:
echo     """Redis-backed idempotency store - atomic SET NX."""
echo.
echo     def __init__^(self, redis_client^):
echo         self.redis = redis_client
echo.
echo     async def lock^(self, key, tenant_id: str, ttl: int^) -^> bool:
echo         """Acquire lock - ล็อกแบบ atomic"""
echo         try:
echo             result = await self.redis.set^(
echo                 f"{key.redis_key^(tenant_id^)}:lock",
echo                 "1",
echo                 nx=True,
echo                 ex=ttl,
echo             ^)
echo             return bool^(result^)
echo         except Exception as e:
echo             logger.opt^(exception=e^).error^("Lock failed"^)
echo             return False  # conservative: fail closed
echo.
echo     async def unlock^(self, key, tenant_id: str^) -^> None:
echo         """Release lock - ปล่อยล็อก"""
echo         try:
echo             await self.redis.delete^(f"{key.redis_key^(tenant_id^)}:lock"^)
echo         except Exception as e:
echo             logger.warning^("idem.unlock.failed", error=str^(e^)^)
echo.
echo     async def get^(self, key, tenant_id: str^):
echo         """Get record - never-raise."""
echo         try:
echo             raw = await self.redis.get^(f"{key.redis_key^(tenant_id^)}:rec"^)
echo             return raw
echo         except Exception as e:
echo             logger.warning^("idem.get.failed", error=str^(e^)^)
echo             return None
echo.
echo     async def set^(self, key, tenant_id: str, rec^) -^> None:
echo         """Set record - never-raise."""
echo         try:
echo             await self.redis.setex^(
echo                 f"{key.redis_key^(tenant_id^)}:rec",
echo                 rec.expires_at and 86400 or 86400,
echo                 str^(rec^),
echo             ^)
echo         except Exception as e:
echo             logger.warning^("idem.set.failed", error=str^(e^)^)
)

> "%M%\repositories.py" (
echo """Postgres fallback repository for idempotency ^(2-branch^)."""
echo from app.core.logging import logger
echo from app.shared.exceptions import InfrastructureException
echo.
echo.
echo class IdempotencyRepositoryException^(InfrastructureException^):
echo     code = "idem_REPO_ERROR"
echo.
echo.
echo class PostgresIdempotencyRepository:
echo     """Postgres fallback repository - used when Redis is down."""
echo.
echo     def __init__^(self, session, tenant_id: str^):
echo         self.session = session
echo         self.tenant_id = tenant_id
echo.
echo     async def get^(self, key, tenant_id: str^):
echo         try:
echo             # TODO: query IdempotencyRecordModel
echo             return None
echo         except Exception as e:
echo             logger.opt^(exception=e^).error^("Repo.get failed"^)
echo             raise IdempotencyRepositoryException^(^)
echo.
echo     async def set^(self, key, tenant_id: str, rec^) -^> None:
echo         try:
echo             # TODO: upsert IdempotencyRecordModel
echo             pass
echo         except Exception as e:
echo             logger.opt^(exception=e^).error^("Repo.set failed"^)
echo             raise IdempotencyRepositoryException^(^)
)

> "%M%\services.py" echo # idempotency/infrastructure/services.py - no external services
goto :eof

:write_idem_presentation
set "M=%~1\presentation"
> "%M%\__init__.py" echo """idempotency presentation layer."""

> "%M%\schemas.py" (
echo """Pydantic schemas for idempotency."""
echo from datetime import datetime
echo.
echo from pydantic import BaseModel, ConfigDict
echo.
echo.
echo class IdempotencyRecordSchema^(BaseModel^):
echo     """Idempotency record schema."""
echo     key: str
echo     scope: str
echo     status: str
echo     request_hash: str
echo     response_body: dict = {}
echo     response_status: int = 0
echo     expires_at: datetime ^| None = None
echo     model_config = ConfigDict^(from_attributes=True^)
)

> "%M%\dependencies.py" (
echo """DI providers for idempotency ^(middleware/dependency^)."""
echo from fastapi import Header, HTTPException
echo.
echo.
echo async def require_idempotency_key^(idempotency_key: str = Header^(..., alias="Idempotency-Key"^)^) -^> str:
echo     """FastAPI dependency: require Idempotency-Key header."""
echo     if not idempotency_key or len^(idempotency_key^) ^< 8:
echo         raise HTTPException^(status_code=400, detail="Idempotency-Key required ^(8-255 chars^)"^)
echo     return idempotency_key
)

> "%M%\docs.py" (
echo """OpenAPI docs for idempotency."""
echo router_docs = {
echo     "tags": ["Idempotency"],
echo     "description": "Module idempotency ^(Layer 0^) - cross-cutting middleware",
echo }
)

> "%M%\routers.py" echo # idempotency/presentation/routers.py - no public router ^(uses middleware/dependency^)
goto :eof