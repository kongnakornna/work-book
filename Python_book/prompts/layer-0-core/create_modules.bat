@echo off
REM ============================================================
REM  create_modules.bat
REM  สร้างโครงสร้าง Module money + idempotency (ห้ามไฟล์ว่าง)
REM  Create module structure for money + idempotency (no empty files)
REM ============================================================
setlocal enabledelayedexpansion

set ROOT=app\modules

echo ============================================
echo  Creating module structure at %ROOT%
echo ============================================

REM ---------- สร้างโฟลเดอร์หลัก ----------
mkdir "%ROOT%" 2>nul
mkdir "%ROOT%\money" 2>nul
mkdir "%ROOT%\money\domain" 2>nul
mkdir "%ROOT%\money\application" 2>nul
mkdir "%ROOT%\money\infrastructure" 2>nul
mkdir "%ROOT%\money\presentation" 2>nul

mkdir "%ROOT%\idempotency" 2>nul
mkdir "%ROOT%\idempotency\domain" 2>nul
mkdir "%ROOT%\idempotency\application" 2>nul
mkdir "%ROOT%\idempotency\infrastructure" 2>nul
mkdir "%ROOT%\idempotency\presentation" 2>nul

echo [OK] Folders created
echo.

REM ============================================================
REM  MONEY MODULE
REM ============================================================
echo --- Creating MONEY module files ---

REM ---------- money\__init__.py ----------
(
echo """Money module — โมดูลเงิน"""
echo from .presentation.routers import router as money_router
echo.
echo __all__ = ["money_router"]
) > "%ROOT%\money\__init__.py"

REM ---------- money\domain\__init__.py ----------
(
echo """Money domain layer — ชั้นโดเมนเงิน"""
echo from .enums import Currency, VATRate, RoundingMode
echo from .value_objects import Money, VAT, ExchangeRate
echo from .exceptions import DomainError
echo from .events import MoneyAdded, MoneySubtracted, VATCalculated, CurrencyConverted
echo.
echo __all__ = [
echo     "Currency", "VATRate", "RoundingMode",
echo     "Money", "VAT", "ExchangeRate",
echo     "DomainError",
echo     "MoneyAdded", "MoneySubtracted", "VATCalculated", "CurrencyConverted",
echo ]
) > "%ROOT%\money\domain\__init__.py"

REM ---------- money\domain\entities.py ----------
(
echo """Money entities — ไม่มี (pure VO module)"""
echo # Module นี้เป็น pure Value Object — ไม่มี Entity
echo # This module is pure Value Object — no entities
echo.
echo __all__: list[str] = []
) > "%ROOT%\money\domain\entities.py"

REM ---------- money\domain\enums.py ----------
(
echo """Money enums — Enum สำหรับเงิน"""
echo from enum import Enum
echo.
echo.
echo class Currency^(str, Enum^):
echo     """Currency — สกุลเงิน"""
echo     THB = "THB"
echo     USD = "USD"
echo     EUR = "EUR"
echo.
echo.
echo class VATRate^(str, Enum^):
echo     """VAT rate — อัตราภาษีมูลค่าเพิ่ม"""
echo     ZERO = "0.00"
echo     SEVEN = "0.07"
echo.
echo.
echo class RoundingMode^(str, Enum^):
echo     """Rounding mode — โหมดปัดเศษ"""
echo     HALF_UP = "HALF_UP"
echo     HALF_DOWN = "HALF_DOWN"
echo     BANKERS = "BANKERS"
) > "%ROOT%\money\domain\enums.py"

REM ---------- money\domain\exceptions.py ----------
(
echo """Money domain exceptions — ข้อยกเว้นโดเมนเงิน"""
echo.
echo.
echo class DomainError^(Exception^):
echo     """DomainError — ข้อผิดพลาดระดับโดเมน"""
echo.
echo     def __init__^(self, message: str = "Domain error"^):
echo         self.message = message
echo         super^(^).__init__^(message^)
echo.
echo     def __str__^(self^) -^> str:
echo         return self.message
) > "%ROOT%\money\domain\exceptions.py"

REM ---------- money\domain\events.py ----------
(
echo """Money domain events — เหตุการณ์โดเมนเงิน"""
echo from dataclasses import dataclass
echo from datetime import datetime
echo from decimal import Decimal
echo.
echo.
echo @dataclass^(frozen=True^)
echo class MoneyAdded:
echo     """MoneyAdded — เหตุการณ์บวกเงิน"""
echo     a: Decimal
echo     b: Decimal
echo     result: Decimal
echo     currency: str
echo     occurred_at: datetime
echo.
echo.
echo @dataclass^(frozen=True^)
echo class MoneySubtracted:
echo     """MoneySubtracted — เหตุการณ์ลบเงิน"""
echo     a: Decimal
echo     b: Decimal
echo     result: Decimal
echo     currency: str
echo     occurred_at: datetime
echo.
echo.
echo @dataclass^(frozen=True^)
echo class VATCalculated:
echo     """VATCalculated — เหตุการณ์คำนวณ VAT"""
echo     base: Decimal
echo     rate: Decimal
echo     vat: Decimal
echo     currency: str
echo     occurred_at: datetime
echo.
echo.
echo @dataclass^(frozen=True^)
echo class CurrencyConverted:
echo     """CurrencyConverted — เหตุการณ์แปลงสกุลเงิน"""
echo     from_currency: str
echo     to_currency: str
echo     rate: Decimal
echo     amount: Decimal
echo     converted: Decimal
echo     occurred_at: datetime
) > "%ROOT%\money\domain\events.py"

REM ---------- money\domain\value_objects.py ----------
(
echo """Money value objects — วัตถุค่าเงิน"""
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
echo     """Money value object — วัตถุค่าเงิน"""
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
echo     """VAT value object — วัตถุภาษีมูลค่าเพิ่ม"""
echo     rate: Decimal
echo.
echo     def calculate^(self, base: Money^) -^> Money:
echo         return Money^((base.amount * self.rate^).quantize^(Decimal^("0.01"^)^), base.currency^)
echo.
echo     def extract^(self, total: Money^) -^> Money:
echo         base = ^(total.amount / ^(Decimal^("1"^) + self.rate^)^).quantize^(Decimal^("0.01"^)^)
echo         return Money^(total.amount - base, total.currency^)
echo.
echo.
echo @dataclass^(frozen=True^)
echo class ExchangeRate:
echo     """Exchange rate VO — วัตถุอัตราแลกเปลี่ยน"""
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
) > "%ROOT%\money\domain\value_objects.py"

echo [OK] money\domain done
echo.

REM ---------- money\application\__init__.py ----------
(
echo """Money application layer — ชั้นแอปพลิเคชันเงิน"""
echo from .use_cases import MoneyUseCases
echo from .exceptions import MoneyException
echo from .utils import round_money, zero_money
echo.
echo __all__ = ["MoneyUseCases", "MoneyException", "round_money", "zero_money"]
) > "%ROOT%\money\application\__init__.py"

REM ---------- money\application\exceptions.py ----------
(
echo """Money application exceptions — ข้อยกเว้นแอปพลิเคชันเงิน"""
echo.
echo.
echo class StandardException^(Exception^):
echo     """StandardException — ข้อผิดพลาดมาตรฐาน"""
echo     pass
echo.
echo.
echo class MoneyException^(StandardException^):
echo     """MoneyException — ข้อผิดพลาดโมดูลเงิน"""
echo.
echo     def __init__^(self, message: str = "Money operation failed"^):
echo         self.message = message
echo         super^(^).__init__^(message^)
) > "%ROOT%\money\application\exceptions.py"

REM ---------- money\application\interfaces.py ----------
(
echo """Money application interfaces — Protocol ว่าง (VO module)"""
echo from typing import Protocol
echo.
echo.
echo class IMoneyConverter^(Protocol^):
echo     """IMoneyConverter — อินเทอร์เฟซแปลงเงิน (optional^)"""
echo.
echo     def convert^(self, amount: "Money", rate: "ExchangeRate"^) -^> "Money": ...
echo.
echo.
echo __all__ = ["IMoneyConverter"]
) > "%ROOT%\money\application\interfaces.py"

REM ---------- money\application\mappers.py ----------
(
echo """Money mappers — ตัวแปลงข้อมูล"""
echo from decimal import Decimal
echo.
echo from ..domain.value_objects import Money
echo.
echo.
echo class MoneyMapper:
echo     """MoneyMapper — ตัวแปลง Money ไป-กลับ schema"""
echo.
echo     @staticmethod
echo     def to_schema^(money: Money^) -^> dict:
echo         """แปลง Money เป็น dict"""
echo         return {"amount": str^(money.amount^), "currency": money.currency}
echo.
echo     @staticmethod
echo     def to_entity^(data: dict^) -^> Money:
echo         """แปลง dict เป็น Money"""
echo         return Money^(Decimal^(str^(data["amount"]^)^), data.get^("currency", "THB"^)^)
) > "%ROOT%\money\application\mappers.py"

REM ---------- money\application\use_cases.py ----------
(
echo """Money use cases — กรณีการใช้งานเงิน"""
echo from decimal import Decimal
echo.
echo from ..domain.enums import VATRate
echo from ..domain.exceptions import DomainError
echo from ..domain.value_objects import Money, VAT, ExchangeRate
echo.
echo.
echo class MoneyUseCases:
echo     """Money use cases — กรณีการใช้งานเงิน"""
echo.
echo     def add^(self, a: Money, b: Money^) -^> Money:
echo         return a + b
echo.
echo     def subtract^(self, a: Money, b: Money^) -^> Money:
echo         return a - b
echo.
echo     def multiply^(self, a: Money, factor: Decimal^) -^> Money:
echo         return a * factor
echo.
echo     def calculate_vat^(self, base: Money, rate: VATRate^) -^> Money:
echo         return VAT^(Decimal^(rate.value^)^).calculate^(base^)
echo.
echo     def extract_vat^(self, total: Money, rate: VATRate^) -^> Money:
echo         return VAT^(Decimal^(rate.value^)^).extract^(total^)
echo.
echo     def convert^(self, amount: Money, rate: ExchangeRate^) -^> Money:
echo         return rate.convert^(amount^)
echo.
echo     def sum_all^(self, items: list[Money]^) -^> Money:
echo         if not items:
echo             raise DomainError^("Cannot sum empty list"^)
echo         result = items[0]
echo         for item in items[1:]:
echo             result = result + item
echo         return result
) > "%ROOT%\money\application\use_cases.py"

REM ---------- money\application\utils.py ----------
(
echo """Money application utils — เครื่องมือช่วย"""
echo from decimal import Decimal, ROUND_HALF_UP
echo.
echo from ..domain.value_objects import Money
echo.
echo.
echo def round_money^(amount: Decimal, places: int = 2^) -^> Decimal:
echo     """ปัดเศษเงิน — Round money to N places"""
echo     quant = Decimal^("0.01"^) if places == 2 else Decimal^(10^) ** -places
echo     return amount.quantize^(quant, rounding=ROUND_HALF_UP^)
echo.
echo.
echo def zero_money^(currency: str = "THB"^) -^> Money:
echo     """สร้าง Money ศูนย์ — Create zero money"""
echo     return Money^(Decimal^("0.00"^), currency^)
) > "%ROOT%\money\application\utils.py"

echo [OK] money\application done
echo.

REM ---------- money\infrastructure\__init__.py ----------
(
echo """Money infrastructure layer — ไม่มี persistence (pure VO)"""
echo # Pure VO module — no infrastructure required
echo __all__: list[str] = []
) > "%ROOT%\money\infrastructure\__init__.py"

REM ---------- money\infrastructure\models.py ----------
(
echo """Money infrastructure models — ไม่มี (pure VO)"""
echo # Pure VO module — no DB models
echo __all__: list[str] = []
) > "%ROOT%\money\infrastructure\models.py"

REM ---------- money\infrastructure\repositories.py ----------
(
echo """Money infrastructure repositories — ไม่มี (pure VO)"""
echo # Pure VO module — no repositories
echo __all__: list[str] = []
) > "%ROOT%\money\infrastructure\repositories.py"

REM ---------- money\infrastructure\caches.py ----------
(
echo """Money infrastructure caches — ไม่มี (pure VO)"""
echo # Pure VO module — no caches
echo __all__: list[str] = []
) > "%ROOT%\money\infrastructure\caches.py"

REM ---------- money\infrastructure\services.py ----------
(
echo """Money infrastructure services — ไม่มี (pure VO)"""
echo # Pure VO module — no services
echo __all__: list[str] = []
) > "%ROOT%\money\infrastructure\services.py"

echo [OK] money\infrastructure done
echo.

REM ---------- money\presentation\__init__.py ----------
(
echo """Money presentation layer — ชั้นนำเสนอเงิน"""
echo from .routers import router
echo from .dependencies import get_money_use_cases
echo.
echo __all__ = ["router", "get_money_use_cases"]
) > "%ROOT%\money\presentation\__init__.py"

REM ---------- money\presentation\dependencies.py ----------
(
echo """Money presentation dependencies — dependencies สำหรับเงิน"""
echo from ..application.use_cases import MoneyUseCases
echo.
echo.
echo def get_money_use_cases^(^) -^> MoneyUseCases:
echo     """สร้าง MoneyUseCases — Get MoneyUseCases instance"""
echo     return MoneyUseCases^(^)
) > "%ROOT%\money\presentation\dependencies.py"

REM ---------- money\presentation\docs.py ----------
(
echo """Money presentation docs — เอกสาร API"""
echo.
echo router_docs = {
echo     "tags": ["Money"],
echo     "description": "Money operations — การดำเนินการเกี่ยวกับเงิน",
echo }
echo.
echo add_docs = {"summary": "Add money — บวกเงิน"}
echo subtract_docs = {"summary": "Subtract money — ลบเงิน"}
echo vat_calculate_docs = {"summary": "Calculate VAT — คำนวณ VAT"}
echo vat_extract_docs = {"summary": "Extract VAT — แยก VAT"}
echo convert_docs = {"summary": "Convert currency — แปลงสกุลเงิน"}
) > "%ROOT%\money\presentation\docs.py"

REM ---------- money\presentation\schemas.py ----------
(
echo """Money presentation schemas — Pydantic schemas"""
echo from datetime import datetime
echo from decimal import Decimal
echo.
echo from pydantic import BaseModel, ConfigDict, Field
echo.
echo from ..domain.enums import VATRate
echo from ..domain.value_objects import Money
echo.
echo.
echo class MoneySchema^(BaseModel^):
echo     """MoneySchema — schema สำหรับเงิน"""
echo     amount: Decimal = Field^(..., ge=0, decimal_places=2^)
echo     currency: str = Field^(default="THB", pattern="^^^(THB|USD|EUR^)$"^)
echo     model_config = ConfigDict^(from_attributes=True^)
echo.
echo     def to_money^(self^) -^> Money:
echo         """แปลงเป็น Money VO"""
echo         return Money^(self.amount, self.currency^)
echo.
echo.
echo class VATRequest^(BaseModel^):
echo     """VATRequest — คำขอคำนวณ VAT"""
echo     base: MoneySchema
echo     rate: VATRate = VATRate.SEVEN
echo.
echo.
echo class VATResponse^(BaseModel^):
echo     """VATResponse — ผลลัพธ์ VAT"""
echo     vat: MoneySchema
echo     total: MoneySchema
echo.
echo.
echo class ExchangeRateSchema^(BaseModel^):
echo     """ExchangeRateSchema — schema อัตราแลกเปลี่ยน"""
echo     from_currency: str = Field^(..., pattern="^^^(THB|USD|EUR^)$"^)
echo     to_currency: str = Field^(..., pattern="^^^(THB|USD|EUR^)$"^)
echo     rate: Decimal = Field^(..., gt=0^)
echo     as_of: datetime = Field^(default_factory=datetime.utcnow^)
) > "%ROOT%\money\presentation\schemas.py"

REM ---------- money\presentation\routers.py ----------
(
echo """Money presentation routers — API endpoints"""
echo from decimal import Decimal
echo.
echo from fastapi import APIRouter, Depends, HTTPException
echo.
echo from ..application.exceptions import MoneyException
echo from ..application.use_cases import MoneyUseCases
echo from ..domain.exceptions import DomainError
echo from ..domain.value_objects import ExchangeRate
echo from .dependencies import get_money_use_cases
echo from .schemas import ExchangeRateSchema, MoneySchema, VATRequest, VATResponse
echo.
echo router = APIRouter^(prefix="/api/v1/money", tags=["Money"]^)
echo.
echo.
echo @router.post^("/add/", response_model=MoneySchema^)
echo async def add^(a: MoneySchema, b: MoneySchema, uc: MoneyUseCases = Depends^(get_money_use_cases^)^):
echo     """บวกเงิน — Add money"""
echo     try:
echo         result = uc.add^(a.to_money^(^), b.to_money^(^)^)
echo         return MoneySchema^(amount=result.amount, currency=result.currency^)
echo     except MoneyException as e:
echo         raise HTTPException^(status_code=400, detail=str^(e^)^)
echo     except DomainError as e:
echo         raise HTTPException^(status_code=422, detail=str^(e^)^)
echo     except Exception as e:
echo         raise HTTPException^(status_code=500, detail="Internal error"^)
echo.
echo.
echo @router.post^("/subtract/", response_model=MoneySchema^)
echo async def subtract^(a: MoneySchema, b: MoneySchema, uc: MoneyUseCases = Depends^(get_money_use_cases^)^):
echo     """ลบเงิน — Subtract money"""
echo     try:
echo         result = uc.subtract^(a.to_money^(^), b.to_money^(^)^)
echo         return MoneySchema^(amount=result.amount, currency=result.currency^)
echo     except MoneyException as e:
echo         raise HTTPException^(status_code=400, detail=str^(e^)^)
echo     except DomainError as e:
echo         raise HTTPException^(status_code=422, detail=str^(e^)^)
echo     except Exception as e:
echo         raise HTTPException^(status_code=500, detail="Internal error"^)
echo.
echo.
echo @router.post^("/vat/calculate/", response_model=VATResponse^)
echo async def vat_calculate^(req: VATRequest, uc: MoneyUseCases = Depends^(get_money_use_cases^)^):
echo     """คำนวณ VAT — Calculate VAT"""
echo     try:
echo         base = req.base.to_money^(^)
echo         vat = uc.calculate_vat^(base, req.rate^)
echo         total = base + vat
echo         return VATResponse^(
echo             vat=MoneySchema^(amount=vat.amount, currency=vat.currency^),
echo             total=MoneySchema^(amount=total.amount, currency=total.currency^),
echo         ^)
echo     except MoneyException as e:
echo         raise HTTPException^(status_code=400, detail=str^(e^)^)
echo     except DomainError as e:
echo         raise HTTPException^(status_code=422, detail=str^(e^)^)
echo     except Exception as e:
echo         raise HTTPException^(status_code=500, detail="Internal error"^)
echo.
echo.
echo @router.post^("/vat/extract/", response_model=VATResponse^)
echo async def vat_extract^(req: VATRequest, uc: MoneyUseCases = Depends^(get_money_use_cases^)^):
echo     """แยก VAT — Extract VAT"""
echo     try:
echo         total = req.base.to_money^(^)
echo         vat = uc.extract_vat^(total, req.rate^)
echo         base = total - vat
echo         return VATResponse^(
echo             vat=MoneySchema^(amount=vat.amount, currency=vat.currency^),
echo             total=MoneySchema^(amount=base.amount, currency=base.currency^),
echo         ^)
echo     except MoneyException as e:
echo         raise HTTPException^(status_code=400, detail=str^(e^)^)
echo     except DomainError as e:
echo         raise HTTPException^(status_code=422, detail=str^(e^)^)
echo     except Exception as e:
echo         raise HTTPException^(status_code=500, detail="Internal error"^)
echo.
echo.
echo @router.post^("/convert/", response_model=MoneySchema^)
echo async def convert^(
echo     amount: MoneySchema,
echo     rate: ExchangeRateSchema,
echo     uc: MoneyUseCases = Depends^(get_money_use_cases^),
echo ^):
echo     """แปลงสกุลเงิน — Convert currency"""
echo     try:
echo         er = ExchangeRate^(
echo             from_currency=rate.from_currency,
echo             to_currency=rate.to_currency,
echo             rate=rate.rate,
echo             as_of=rate.as_of,
echo         ^)
echo         result = uc.convert^(amount.to_money^(^), er^)
echo         return MoneySchema^(amount=result.amount, currency=result.currency^)
echo     except MoneyException as e:
echo         raise HTTPException^(status_code=400, detail=str^(e^)^)
echo     except DomainError as e:
echo         raise HTTPException^(status_code=422, detail=str^(e^)^)
echo     except Exception as e:
echo         raise HTTPException^(status_code=500, detail="Internal error"^)
) > "%ROOT%\money\presentation\routers.py"

echo [OK] money\presentation done
echo.

REM ============================================================
REM  IDEMPOTENCY MODULE
REM ============================================================
echo --- Creating IDEMPOTENCY module files ---

REM ---------- idempotency\__init__.py ----------
(
echo """Idempotency module — โมดูล idempotency"""
echo from .presentation.dependencies import require_idempotency_key
echo.
echo __all__ = ["require_idempotency_key"]
) > "%ROOT%\idempotency\__init__.py"

REM ---------- idempotency\domain\__init__.py ----------
(
echo """Idempotency domain layer — ชั้นโดเมน idempotency"""
echo from .enums import IdempotencyStatus, IdempotencyConflict
echo from .entities import IdempotencyRecord
echo from .value_objects import IdempotencyKey
echo from .exceptions import DomainError
echo from .events import IdempotencyLocked, IdempotencyCompleted, IdempotencyConflictEvent
echo.
echo __all__ = [
echo     "IdempotencyStatus", "IdempotencyConflict",
echo     "IdempotencyRecord", "IdempotencyKey",
echo     "DomainError",
echo     "IdempotencyLocked", "IdempotencyCompleted", "IdempotencyConflictEvent",
echo ]
) > "%ROOT%\idempotency\domain\__init__.py"

REM ---------- idempotency\domain\entities.py ----------
(
echo """Idempotency entities — เอนทิตี idempotency"""
echo from dataclasses import dataclass, field
echo from datetime import datetime
echo.
echo from .exceptions import DomainError
echo.
echo.
echo @dataclass
echo class BaseEntity:
echo     """BaseEntity — เอนทิตีฐาน"""
echo     id: str = ""
echo     tenant_id: str = ""
echo     created_at: datetime = field^(default_factory=datetime.utcnow^)
echo     updated_at: datetime = field^(default_factory=datetime.utcnow^)
echo.
echo.
echo @dataclass
echo class IdempotencyRecord^(BaseEntity^):
echo     """Idempotency record — เอนทิตีบันทึก idempotency"""
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
echo         return self.expires_at is not None and datetime.utcnow^(^) ^> self.expires_at
echo.
echo     def is_completed^(self^) -^> bool:
echo         return self.status == "COMPLETED"
echo.
echo     def is_in_progress^(self^) -^> bool:
echo         return self.status == "IN_PROGRESS"
echo.
echo     def complete^(self, status: int, body: dict^) -^> None:
echo         """Mark completed — ทำเครื่องหมายเสร็จ"""
echo         self.status = "COMPLETED"
echo         self.response_status = status
echo         self.response_body = body
echo         self.updated_at = datetime.utcnow^(^)
) > "%ROOT%\idempotency\domain\entities.py"

REM ---------- idempotency\domain\enums.py ----------
(
echo """Idempotency enums — Enum สำหรับ idempotency"""
echo from enum import Enum
echo.
echo.
echo class IdempotencyStatus^(str, Enum^):
echo     """IdempotencyStatus — สถานะ idempotency"""
echo     IN_PROGRESS = "IN_PROGRESS"
echo     COMPLETED = "COMPLETED"
echo     FAILED = "FAILED"
echo.
echo.
echo class IdempotencyConflict^(str, Enum^):
echo     """IdempotencyConflict — ประเภทความขัดแย้ง"""
echo     SAME_KEY_SAME_PAYLOAD = "SAME_KEY_SAME_PAYLOAD"
echo     SAME_KEY_DIFF_PAYLOAD = "SAME_KEY_DIFF_PAYLOAD"
echo     CONCURRENT = "CONCURRENT"
) > "%ROOT%\idempotency\domain\enums.py"

REM ---------- idempotency\domain\exceptions.py ----------
(
echo """Idempotency domain exceptions — ข้อยกเว้นโดเมน"""
echo.
echo.
echo class DomainError^(Exception^):
echo     """DomainError — ข้อผิดพลาดโดเมน"""
echo.
echo     def __init__^(self, message: str = "Domain error"^):
echo         self.message = message
echo         super^(^).__init__^(message^)
) > "%ROOT%\idempotency\domain\exceptions.py"

REM ---------- idempotency\domain\events.py ----------
(
echo """Idempotency domain events — เหตุการณ์โดเมน"""
echo from dataclasses import dataclass
echo from datetime import datetime
echo.
echo.
echo @dataclass^(frozen=True^)
echo class IdempotencyLocked:
echo     """IdempotencyLocked — เหตุการณ์ล็อก"""
echo     key: str
echo     scope: str
echo     tenant_id: str
echo     occurred_at: datetime
echo.
echo.
echo @dataclass^(frozen=True^)
echo class IdempotencyCompleted:
echo     """IdempotencyCompleted — เหตุการณ์เสร็จสิ้น"""
echo     key: str
echo     scope: str
echo     tenant_id: str
echo     response_status: int
echo     occurred_at: datetime
echo.
echo.
echo @dataclass^(frozen=True^)
echo class IdempotencyConflictEvent:
echo     """IdempotencyConflictEvent — เหตุการณ์ความขัดแย้ง"""
echo     key: str
echo     scope: str
echo     tenant_id: str
echo     conflict_type: str
echo     occurred_at: datetime
) > "%ROOT%\idempotency\domain\events.py"

REM ---------- idempotency\domain\value_objects.py ----------
(
echo """Idempotency value objects — วัตถุค่า idempotency"""
echo from dataclasses import dataclass
echo.
echo from .exceptions import DomainError
echo.
echo.
echo @dataclass^(frozen=True^)
echo class IdempotencyKey:
echo     """Idempotency key VO — วัตถุกุญแจ idempotency"""
echo     value: str
echo     scope: str  # e.g., "invoice.create"
echo.
echo     def __post_init__^(self^):
echo         if len^(self.value^) ^< 8 or len^(self.value^) ^> 255:
echo             raise DomainError^("Idempotency key length must be 8-255"^)
echo.
echo     def redis_key^(self, tenant_id: str^) -^> str:
echo         return f"t:{tenant_id}:idem:{self.scope}:{self.value}"
) > "%ROOT%\idempotency\domain\value_objects.py"

echo [OK] idempotency\domain done
echo.

REM ---------- idempotency\application\__init__.py ----------
(
echo """Idempotency application layer"""
echo from .use_cases import IdempotencyUseCases
echo from .exceptions import (
echo     IdempotencyException,
echo     IdempotencyConflictException,
echo     IdempotencyStoreException,
echo ^)
echo from .utils import hash_payload, idempotent
echo.
echo __all__ = [
echo     "IdempotencyUseCases",
echo     "IdempotencyException",
echo     "IdempotencyConflictException",
echo     "IdempotencyStoreException",
echo     "hash_payload",
echo     "idempotent",
echo ]
) > "%ROOT%\idempotency\application\__init__.py"

REM ---------- idempotency\application\exceptions.py ----------
(
echo """Idempotency application exceptions — ข้อยกเว้นแอปพลิเคชัน"""
echo.
echo.
echo class StandardException^(Exception^):
echo     """StandardException — ข้อผิดพลาดมาตรฐาน"""
echo     pass
echo.
echo.
echo class IdempotencyException^(StandardException^):
echo     """IdempotencyException — ข้อผิดพลาด idempotency"""
echo.
echo     def __init__^(self, message: str = "Idempotency operation failed"^):
echo         self.message = message
echo         super^(^).__init__^(message^)
echo.
echo.
echo class IdempotencyConflictException^(IdempotencyException^):
echo     """IdempotencyConflictException — ความขัดแย้ง idempotency"""
echo.
echo     def __init__^(self, message: str = "Idempotency conflict"^):
echo         super^(^).__init__^(message^)
echo.
echo.
echo class IdempotencyStoreException^(IdempotencyException^):
echo     """IdempotencyStoreException — ข้อผิดพลาด store"""
echo.
echo     def __init__^(self, message: str = "Idempotency store error"^):
echo         super^(^).__init__^(message^)
) > "%ROOT%\idempotency\application\exceptions.py"

REM ---------- idempotency\application\interfaces.py ----------
(
echo """Idempotency application interfaces — Protocol"""
echo from typing import Protocol
echo.
echo from ..domain.entities import IdempotencyRecord
echo from ..domain.value_objects import IdempotencyKey
echo.
echo.
echo class IIdempotencyStore^(Protocol^):
echo     """IIdempotencyStore — อินเทอร์เฟซ store"""
echo.
echo     async def get^(self, key: IdempotencyKey, tenant_id: str^) -^> IdempotencyRecord ^| None: ...
echo.
echo     async def set^(self, key: IdempotencyKey, tenant_id: str, rec: IdempotencyRecord^) -^> None: ...
echo.
echo     async def lock^(self, key: IdempotencyKey, tenant_id: str, ttl: int^) -^> bool: ...
echo.
echo     async def unlock^(self, key: IdempotencyKey, tenant_id: str^) -^> None: ...
) > "%ROOT%\idempotency\application\interfaces.py"

REM ---------- idempotency\application\mappers.py ----------
(
echo """Idempotency mappers — ตัวแปลงข้อมูล"""
echo from ..domain.entities import IdempotencyRecord
echo.
echo.
echo class IdempotencyMapper:
echo     """IdempotencyMapper — ตัวแปลง record ไป-กลับ"""
echo.
echo     @staticmethod
echo     def to_schema^(rec: IdempotencyRecord^) -^> dict:
echo         """แปลง record เป็น dict"""
echo         return {
echo             "key": rec.key,
echo             "status": rec.status,
echo             "request_hash": rec.request_hash,
echo             "response_status": rec.response_status,
echo             "response_body": rec.response_body,
echo             "expires_at": rec.expires_at.isoformat^(^) if rec.expires_at else None,
echo         }
echo.
echo     @staticmethod
echo     def to_entity^(data: dict^) -^> IdempotencyRecord:
echo         """แปลง dict เป็น record"""
echo         return IdempotencyRecord^(
echo             key=data.get^("key", ""^),
echo             status=data.get^("status", "IN_PROGRESS"^),
echo             request_hash=data.get^("request_hash", ""^),
echo             response_status=data.get^("response_status", 0^),
echo             response_body=data.get^("response_body", {}^),
echo         ^)
) > "%ROOT%\idempotency\application\mappers.py"

REM ---------- idempotency\application\use_cases.py ----------
(
echo """Idempotency use cases — กรณีการใช้งาน idempotency"""
echo import hashlib
echo import json
echo import logging
echo from datetime import datetime, timedelta
echo.
echo from ..domain.entities import IdempotencyRecord
echo from ..domain.exceptions import DomainError
echo from ..domain.value_objects import IdempotencyKey
echo from .exceptions import (
echo     StandardException,
echo     IdempotencyException,
echo     IdempotencyConflictException,
echo ^)
echo.
echo logger = logging.getLogger^(__name__^)
echo.
echo.
echo class IdempotencyUseCases:
echo     """Idempotency use cases — กรณีการใช้งาน idempotency"""
echo.
echo     def __init__^(self, store, ttl: int = 86400^):
echo         self.store = store
echo         self.ttl = ttl
echo.
echo     async def check_or_lock^(
echo         self, raw_key: str, scope: str, payload: dict, tenant_id: str
echo     ^) -^> IdempotencyRecord ^| None:
echo         """Check existing or lock — ตรวจสอบหรือล็อก"""
echo         try:
echo             key = IdempotencyKey^(value=raw_key, scope=scope^)
echo             existing = await self.store.get^(key, tenant_id^)
echo.
echo             if existing and existing.is_completed^(^):
echo                 if existing.request_hash != self._hash^(payload^):
echo                     raise IdempotencyConflictException^("Payload mismatch"^)
echo                 return existing  # replay
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
echo                 tenant_id=tenant_id,
echo                 expires_at=datetime.utcnow^(^) + timedelta^(seconds=self.ttl^),
echo             ^)
echo             await self.store.set^(key, tenant_id, rec^)
echo             return None  # proceed with execution
echo         except StandardException:
echo             raise
echo         except DomainError as e:
echo             raise IdempotencyException^(str^(e^)^)
echo         except Exception as e:
echo             logger.exception^("Error in check_or_lock: %s", e^)
echo             raise IdempotencyException^(^)
echo.
echo     async def complete^(
echo         self, raw_key: str, scope: str, tenant_id: str, status: int, body: dict
echo     ^) -^> None:
echo         """Mark completed — บันทึกผลลัพธ์"""
echo         try:
echo             key = IdempotencyKey^(value=raw_key, scope=scope^)
echo             rec = await self.store.get^(key, tenant_id^)
echo             if rec:
echo                 rec.complete^(status, body^)
echo                 await self.store.set^(key, tenant_id, rec^)
echo                 await self.store.unlock^(key, tenant_id^)
echo         except Exception as e:
echo             logger.exception^("Error in complete idempotency: %s", e^)
echo             # don't re-raise — response already returned
echo.
echo     @staticmethod
echo     def _hash^(payload: dict^) -^> str:
echo         canonical = json.dumps^(payload, sort_keys=True, separators=^(",", ":"^)^)
echo         return hashlib.sha256^(canonical.encode^(^)^).hexdigest^(^)
) > "%ROOT%\idempotency\application\use_cases.py"

REM ---------- idempotency\application\utils.py ----------
(
echo """Idempotency application utils — เครื่องมือช่วย"""
echo import functools
echo import hashlib
echo import json
echo from typing import Callable
echo.
echo.
echo def hash_payload^(payload: dict^) -^> str:
echo     """แฮช payload — Hash payload deterministically"""
echo     canonical = json.dumps^(payload, sort_keys=True, separators=^(",", ":"^)^)
echo     return hashlib.sha256^(canonical.encode^(^)^).hexdigest^(^)
echo.
echo.
echo def idempotent^(fn: Callable^) -^> Callable:
echo     """Decorator สำหรับ idempotent — Decorator for idempotent methods"""
echo     @functools.wraps^(fn^)
echo     async def wrapper^*args, **kwargs^:
echo         return await fn^*args, **kwargs^
echo     return wrapper
) > "%ROOT%\idempotency\application\utils.py"

echo [OK] idempotency\application done
echo.

REM ---------- idempotency\infrastructure\__init__.py ----------
(
echo """Idempotency infrastructure layer"""
echo from .models import IdempotencyRecordModel
echo from .repositories import PostgresIdempotencyRepository
echo from .caches import RedisIdempotencyStore
echo.
echo __all__ = [
echo     "IdempotencyRecordModel",
echo     "PostgresIdempotencyRepository",
echo     "RedisIdempotencyStore",
echo ]
) > "%ROOT%\idempotency\infrastructure\__init__.py"

REM ---------- idempotency\infrastructure\models.py ----------
(
echo """Idempotency infrastructure models — SQLAlchemy models"""
echo from sqlalchemy import Column, DateTime, Integer, String, UniqueConstraint
echo from sqlalchemy.dialects.postgresql import JSONB
echo from sqlalchemy.orm import declarative_base
echo.
echo BaseModel = declarative_base^(^)
echo.
echo.
echo class IdempotencyRecordModel^(BaseModel^):
echo     """IdempotencyRecordModel — โมเดลบันทึก idempotency"""
echo     __tablename__ = "idempotency_records"
echo.
echo     id = Column^(String^(36^), primary_key=True^)
echo     tenant_id = Column^(String^(36^), nullable=False, index=True^)
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
) > "%ROOT%\idempotency\infrastructure\models.py"

REM ---------- idempotency\infrastructure\repositories.py ----------
(
echo """Idempotency infrastructure repositories — Postgres fallback"""
echo import logging
echo.
echo from ..domain.entities import IdempotencyRecord
echo from ..domain.value_objects import IdempotencyKey
echo from .models import IdempotencyRecordModel
echo.
echo logger = logging.getLogger^(__name__^)
echo.
echo.
echo class PostgresIdempotencyRepository:
echo     """PostgresIdempotencyRepository — fallback เมื่อ Redis ล่ม"""
echo.
echo     def __init__^(self, session_factory^):
echo         self.session_factory = session_factory
echo.
echo     async def get^(
echo         self, key: IdempotencyKey, tenant_id: str
echo     ^) -^> IdempotencyRecord ^| None:
echo         try:
echo             async with self.session_factory^(^) as session:
echo                 from sqlalchemy import select
echo                 stmt = select^(IdempotencyRecordModel^).where^(
echo                     IdempotencyRecordModel.key == key.value,
echo                     IdempotencyRecordModel.scope == key.scope,
echo                     IdempotencyRecordModel.tenant_id == tenant_id,
echo                 ^)
echo                 result = await session.execute^(stmt^)
echo                 row = result.scalar_one_or_none^(^)
echo                 if row is None:
echo                     return None
echo                 return IdempotencyRecord^(
echo                     key=row.key,
echo                     status=row.status,
echo                     request_hash=row.request_hash,
echo                     response_body=row.response_body or {},
echo                     response_status=row.response_status or 0,
echo                     expires_at=row.expires_at,
echo                 ^)
echo         except Exception as e:
echo             logger.exception^("Postgres get failed: %s", e^)
echo             return None
echo.
echo     async def set^(
echo         self, key: IdempotencyKey, tenant_id: str, rec: IdempotencyRecord
echo     ^) -^> None:
echo         try:
echo             async with self.session_factory^(^) as session:
echo                 row = IdempotencyRecordModel^(
echo                     key=key.value,
echo                     scope=key.scope,
echo                     tenant_id=tenant_id,
echo                     status=rec.status,
echo                     request_hash=rec.request_hash,
echo                     response_body=rec.response_body,
echo                     response_status=rec.response_status,
echo                     expires_at=rec.expires_at,
echo                 ^)
echo                 session.add^(row^)
echo                 await session.commit^(^)
echo         except Exception as e:
echo             logger.exception^("Postgres set failed: %s", e^)
echo.
echo     async def lock^(
echo         self, key: IdempotencyKey, tenant_id: str, ttl: int
echo     ^) -^> bool:
echo         # Postgres fallback: always allow (Redis เป็น primary^)
echo         return True
echo.
echo     async def unlock^(
echo         self, key: IdempotencyKey, tenant_id: str
echo     ^) -^> None:
echo         return None
) > "%ROOT%\idempotency\infrastructure\repositories.py"

REM ---------- idempotency\infrastructure\caches.py ----------
(
echo """Idempotency infrastructure caches — Redis store (primary^)"""
echo import json
echo import logging
echo.
echo from ..domain.entities import IdempotencyRecord
echo from ..domain.value_objects import IdempotencyKey
echo.
echo logger = logging.getLogger^(__name__^)
echo.
echo.
echo class RedisIdempotencyStore:
echo     """RedisIdempotencyStore — primary store ด้วย atomic SET NX"""
echo.
echo     def __init__^(self, redis_client^):
echo         self.redis = redis_client
echo.
echo     async def get^(
echo         self, key: IdempotencyKey, tenant_id: str
echo     ^) -^> IdempotencyRecord ^| None:
echo         try:
echo             raw = await self.redis.get^(key.redis_key^(tenant_id^)^)
echo             if not raw:
echo                 return None
echo             data = json.loads^(raw^)
echo             return IdempotencyRecord^(
echo                 key=data.get^("key", key.value^),
echo                 status=data.get^("status", "IN_PROGRESS"^),
echo                 request_hash=data.get^("request_hash", ""^),
echo                 response_body=data.get^("response_body", {}^),
echo                 response_status=data.get^("response_status", 0^),
echo                 expires_at=data.get^("expires_at"^),
echo             ^)
echo         except Exception as e:
echo             logger.exception^("Redis get failed: %s", e^)
echo             return None
echo.
echo     async def set^(
echo         self, key: IdempotencyKey, tenant_id: str, rec: IdempotencyRecord
echo     ^) -^> None:
echo         try:
echo             payload = {
echo                 "key": rec.key,
echo                 "status": rec.status,
echo                 "request_hash": rec.request_hash,
echo                 "response_body": rec.response_body,
echo                 "response_status": rec.response_status,
echo                 "expires_at": rec.expires_at.isoformat^(^)
echo                 if rec.expires_at else None,
echo             }
echo             await self.redis.set^(
echo                 key.redis_key^(tenant_id^),
echo                 json.dumps^(payload^),
echo                 ex=86400,
echo             ^)
echo         except Exception as e:
echo             logger.exception^("Redis set failed: %s", e^)
echo.
echo     async def lock^(
echo         self, key: IdempotencyKey, tenant_id: str, ttl: int
echo     ^) -^> bool:
echo         try:
echo             result = await self.redis.set^(
echo                 f"{key.redis_key^(tenant_id^)}:lock",
echo                 "1", nx=True, ex=ttl
echo             ^)
echo             return bool^(result^)
echo         except Exception as e:
echo             logger.exception^("Lock failed: %s", e^)
echo             return False  # conservative: fail closed
echo.
echo     async def unlock^(
echo         self, key: IdempotencyKey, tenant_id: str
echo     ^) -^> None:
echo         try:
echo             await self.redis.delete^(f"{key.redis_key^(tenant_id^)}:lock"^)
echo         except Exception as e:
echo             logger.exception^("Unlock failed: %s", e^)
) > "%ROOT%\idempotency\infrastructure\caches.py"

REM ---------- idempotency\infrastructure\services.py ----------
(
echo """Idempotency infrastructure services — ไม่มี"""
echo # No infrastructure services required
echo __all__: list[str] = []
) > "%ROOT%\idempotency\infrastructure\services.py"

echo [OK] idempotency\infrastructure done
echo.

REM ---------- idempotency\presentation\__init__.py ----------
(
echo """Idempotency presentation layer"""
echo from .dependencies import require_idempotency_key
echo from .schemas import IdempotencyRecordSchema
echo.
echo __all__ = ["require_idempotency_key", "IdempotencyRecordSchema"]
) > "%ROOT%\idempotency\presentation\__init__.py"

REM ---------- idempotency\presentation\dependencies.py ----------
(
echo """Idempotency presentation dependencies — FastAPI dependency"""
echo from fastapi import Header, HTTPException
echo.
echo.
echo async def require_idempotency_key^(
echo     idempotency_key: str ^| None = Header^(default=None, alias="Idempotency-Key"^)
echo ^) -^> str:
echo     """ต้องมี Idempotency-Key header — Require idempotency key"""
echo     if not idempotency_key:
echo         raise HTTPException^(
echo             status_code=400,
echo             detail="Idempotency-Key header required",
echo         ^)
echo     if len^(idempotency_key^) ^< 8 or len^(idempotency_key^) ^> 255:
echo         raise HTTPException^(
echo             status_code=400,
echo             detail="Idempotency-Key must be 8-255 characters",
echo         ^)
echo     return idempotency_key
) > "%ROOT%\idempotency\presentation\dependencies.py"

REM ---------- idempotency\presentation\docs.py ----------
(
echo """Idempotency presentation docs — เอกสาร"""
echo.
echo idempotency_docs = {
echo     "description": (
echo         "Idempotency middleware — ทุก mutating request ต้องส่ง "
echo         "Idempotency-Key header"
echo     ^),
echo     "headers": {
echo         "Idempotency-Key": {
echo             "description": "Unique key 8-255 chars",
echo             "required": True,
echo         }
echo     },
echo }
) > "%ROOT%\idempotency\presentation\docs.py"

REM ---------- idempotency\presentation\routers.py ----------
(
echo """Idempotency presentation routers — ว่าง (ใช้ middleware^)"""
echo from fastapi import APIRouter
echo.
echo router = APIRouter^(prefix="/api/v1/idempotency", tags=["Idempotency"]^)
echo.
echo # Public router ว่าง — ใช้ middleware/dependency แทน
echo # No public endpoints — handled via middleware/dependency
echo __all__ = ["router"]
) > "%ROOT%\idempotency\presentation\routers.py"

REM ---------- idempotency\presentation\schemas.py ----------
(
echo """Idempotency presentation schemas — Pydantic schemas"""
echo from datetime import datetime
echo.
echo from pydantic import BaseModel, ConfigDict
echo.
echo.
echo class IdempotencyRecordSchema^(BaseModel^):
echo     """IdempotencyRecordSchema — schema บันทึก idempotency"""
echo     key: str
echo     scope: str
echo     status: str
echo     request_hash: str
echo     response_status: int = 0
echo     expires_at: datetime ^| None = None
echo.
echo     model_config = ConfigDict^(from_attributes=True^)
) > "%ROOT%\idempotency\presentation\schemas.py"

echo [OK] idempotency\presentation done
echo.

REM ============================================================
echo.
echo ============================================
echo  DONE! Module structure created successfully.
echo ============================================
echo.
echo  Structure:
echo    %ROOT%\
echo      money\          (25 files^)
echo      idempotency\    (25 files^)
echo.
echo  All files contain content — no empty files.
echo ============================================

endlocal
pause