### 🎯 ตัวอย่างเต็ม: Module `forecast`

### Metadata

| หัวข้อ | รายละเอียด |
|---|---|
| **ชื่อ Module** | `forecast` |
| **Layer** | `5` (Intelligence) |
| **Priority** | 🟠 |
| **Phase** | 5 |
| **Dependencies** | `analytics`, `reporting`, `production`, `inventory`, `agriculture` |
| **Domain Concepts** | `Forecast` (entity), `ForecastResult` (VO), `ForecastMethod` (enum) |
| **Prefix** | `fc` |
| **Tables** | `tenant_fc.forecasts` |

### 🎯 Prompt (Copy ทั้งหมด)

```markdown
# สร้าง Module `forecast`

## บริบท
- ERP + CRM + IoT สำหรับ SME
- Clean Architecture + DDD (4 layers)
- **Invariants:** `MAPE < 20%`, `Forecast non-negative`
- **Events:** `ForecastGenerated`, `ForecastUpdated`, `ForecastAccuracyDropped`
- รองรับ methods: LSTM, PROPHET, XGBOOST, ARIMA, ENSEMBLE

## ข้อกำหนด

### 1. Domain Layer (`domain/`)

**`domain/entities.py` — Forecast**
```python
@dataclass
class Forecast(BaseEntity):
    """Forecast entity — เอนทิตีพยากรณ์"""
    product_id: str = ""
    branch_id: str = ""
    forecast_date: date | None = None
    predicted_qty: Decimal = Decimal("0.000")
    actual_qty: Decimal | None = None
    method: str = "LSTM"
    mape: Decimal | None = None
    confidence: Decimal = Decimal("0.00")  # 0-1
    horizon_days: int = 30

    def __post_init__(self):
        self._validate()

    def _validate(self) -> None:
        if self.predicted_qty < 0:
            raise DomainError("Predicted qty cannot be negative")
        if self.actual_qty is not None and self.actual_qty < 0:
            raise DomainError("Actual qty cannot be negative")
        if not 0 <= self.confidence <= 1:
            raise DomainError("Confidence must be 0-1")

    def update_actual(self, actual_qty: Decimal) -> None:
        """Update actual and calculate MAPE — อัปเดตค่าจริงและคำนวณ MAPE"""
        if actual_qty < 0:
            raise DomainError("Actual qty cannot be negative")
        self.actual_qty = actual_qty
        if actual_qty > 0:
            self.mape = (abs(self.predicted_qty - actual_qty) / actual_qty * 100).quantize(Decimal("0.01"))

    def is_accurate(self) -> bool:
        """MAPE < 20% — ตรวจสอบความแม่นยำ"""
        return self.mape is not None and self.mape < 20

    def error(self) -> Decimal | None:
        if self.actual_qty is None:
            return None
        return self.predicted_qty - self.actual_qty
```

**`domain/value_objects.py`**
```python
@dataclass(frozen=True)
class ForecastResult:
    """Forecast result VO — ผลลัพธ์พยากรณ์"""
    predicted: Decimal
    actual: Decimal | None
    error: Decimal | None
    mape: Decimal | None
    confidence: Decimal

@dataclass(frozen=True)
class ForecastHorizon:
    """Forecast horizon VO — วัตถุขอบเขต"""
    days: int
    granularity: str  # DAY, WEEK, MONTH

    def __post_init__(self):
        if self.days <= 0:
            raise DomainError("Horizon days must be positive")
        if self.granularity not in ("DAY", "WEEK", "MONTH"):
            raise DomainError(f"Invalid granularity: {self.granularity}")
```

**`domain/enums.py`**
```python
class ForecastMethod(str, Enum):
    LSTM = "LSTM"
    PROPHET = "PROPHET"
    XGBOOST = "XGBOOST"
    ARIMA = "ARIMA"
    ENSEMBLE = "ENSEMBLE"

class ForecastType(str, Enum):
    DEMAND = "DEMAND"
    PRODUCTION = "PRODUCTION"
    YIELD = "YIELD"
    PRICE = "PRICE"

class Granularity(str, Enum):
    DAY = "DAY"
    WEEK = "WEEK"
    MONTH = "MONTH"
```

### 2. Application Layer (`application/`)

**`application/use_cases.py`**
```python
class ForecastUseCases:
    """Forecast use cases — กรณีการใช้งานพยากรณ์"""

    def __init__(self, repo, analytics_repo, ml_service, cache, audit, events):
        ...

    async def generate_forecast(
        self,
        product_id: str,
        branch_id: str,
        days: int,
        method: str = "LSTM",
    ) -> list[Forecast]:
        """Generate forecast — สร้างพยากรณ์"""
        try:
            # Load historical data
            data = await self.analytics_repo.get_history(product_id, branch_id, days * 3)
            if len(data) < 30:
                raise InsufficientDataException("Need at least 30 data points")

            # Predict
            predictions = await self.ml_service.predict(data, days, method)

            # Save
            forecasts = []
            for pred in predictions:
                forecast = Forecast(
                    product_id=product_id,
                    branch_id=branch_id,
                    forecast_date=pred["date"],
                    predicted_qty=pred["qty"],
                    method=method,
                    confidence=pred.get("confidence", Decimal("0.8")),
                    horizon_days=days,
                )
                forecast = await self.repo.save(forecast)
                forecasts.append(forecast)

            await self.audit.log("forecast.generated", product_id)
            await self.events.publish("ForecastGenerated", {
                "product_id": product_id,
                "branch_id": branch_id,
                "method": method,
                "count": len(forecasts),
            })
            return forecasts
        except StandardException:
            raise
        except DomainError as e:
            raise DomainException(e)
        except Exception as e:
            logger.opt(exception=e).error("Error in generate_forecast")
            raise ForecastException()

    async def update_actual(self, forecast_id: str, actual_qty: Decimal) -> Forecast:
        try:
            forecast = await self.repo.get_by_id(forecast_id)
            if not forecast:
                raise ForecastNotFoundException()
            forecast.update_actual(actual_qty)
            forecast = await self.repo.save(forecast)
            await self.cache.delete(forecast_id)

            if forecast.mape and forecast.mape > 20:
                await self.events.publish("ForecastAccuracyDropped", {
                    "forecast_id": forecast_id,
                    "mape": str(forecast.mape),
                })
            await self.audit.log("forecast.actual_updated", forecast_id)
            return forecast
        except StandardException:
            raise
        except DomainError as e:
            raise DomainException(e)
        except Exception as e:
            logger.opt(exception=e).error("Error in update_actual")
            raise ForecastException()

    async def backtest(self, product_id: str, days: int, method: str) -> dict:
        """Backtest — ทดสอบย้อนหลัง"""
        try:
            data = await self.analytics_repo.get_history(product_id, None, days * 2)
            train = data[:len(data) // 2]
            test = data[len(data) // 2:]

            predictions = await self.ml_service.predict(train, len(test), method)
            mape_values = []
            for pred, actual in zip(predictions, test):
                if actual["qty"] > 0:
                    mape = abs(pred["qty"] - actual["qty"]) / actual["qty"] * 100
                    mape_values.append(float(mape))

            avg_mape = sum(mape_values) / len(mape_values) if mape_values else 0
            return {
                "product_id": product_id,
                "method": method,
                "avg_mape": round(avg_mape, 2),
                "is_accurate": avg_mape < 20,
                "samples": len(mape_values),
            }
        except Exception as e:
            logger.opt(exception=e).error("Error in backtest")
            raise ForecastException()
```

**`application/mappers.py`** — `ForecastMapper`
**`application/exceptions.py`** — `ForecastException`, `ForecastNotFoundException`, `InsufficientDataException`
**`application/utils.py`** — `calculate_mape()`

### 3. Infrastructure Layer (`infrastructure/`)

**`infrastructure/models.py`**
```python
class ForecastModel(BaseModel):
    __tablename__ = "forecasts"
    product_id = Column(String(36), nullable=False, index=True)
    branch_id = Column(String(36), nullable=False, index=True)
    forecast_date = Column(Date, nullable=False, index=True)
    predicted_qty = Column(Numeric(15, 3), nullable=False)
    actual_qty = Column(Numeric(15, 3))
    method = Column(String(20), nullable=False, default="LSTM")
    mape = Column(Numeric(5, 2))
    confidence = Column(Numeric(5, 4), default=0)
    horizon_days = Column(Integer, nullable=False, default=30)
    __table_args__ = (
        UniqueConstraint("tenant_id", "product_id", "branch_id", "forecast_date", "method",
                         name="uq_forecast"),
        CheckConstraint("predicted_qty >= 0", name="ck_forecast_predicted"),
    )
```

**`infrastructure/repositories.py`** — `PostgresForecastRepository`
**`infrastructure/caches.py`** — `RedisForecastCache`
**`infrastructure/services.py`**
```python
class MLForecastService:
    """ML forecast service — บริการ ML พยากรณ์"""
    async def predict(self, data: list[dict], days: int, method: str) -> list[dict]:
        if method == "LSTM":
            return await self._lstm(data, days)
        elif method == "PROPHET":
            return await self._prophet(data, days)
        elif method == "ENSEMBLE":
            return await self._ensemble(data, days)
        else:
            raise DomainError(f"Unsupported method: {method}")

    async def _lstm(self, data: list[dict], days: int) -> list[dict]:
        # Load LSTM model, predict
        ...

    async def _prophet(self, data: list[dict], days: int) -> list[dict]:
        ...

    async def _ensemble(self, data: list[dict], days: int) -> list[dict]:
        results = await asyncio.gather(
            self._lstm(data, days),
            self._prophet(data, days),
        )
        # Average
        return [
            {"date": r[0]["date"], "qty": sum(x["qty"] for x in r) / len(r), "confidence": Decimal("0.85")}
            for r in zip(*results)
        ]
```

### 4. Presentation Layer (`presentation/`)

**`presentation/routers.py`**
```python
router = APIRouter(prefix="/api/v1/forecast", tags=["Forecast"])

@router.post("/generate/")
async def generate(
    product_id: str, branch_id: str, days: int = 30, method: str = "LSTM",
    ...): ...

@router.get("/{product_id}/")
async def get_forecasts(product_id: str, from_date: date | None = None, ...): ...

@router.patch("/{forecast_id}/actual/")
async def update_actual(forecast_id: str, payload: ActualRequest, ...): ...

@router.post("/backtest/")
async def backtest(product_id: str, days: int, method: str = "LSTM", ...): ...

@router.get("/accuracy/{product_id}/")
async def get_accuracy(product_id: str, ...): ...
```

**`presentation/schemas.py`** — `ForecastGenerateRequest`, `ForecastResponse`, `ActualRequest`, `BacktestResponse`
**`presentation/docs.py`** — router_docs
**`presentation/dependencies.py`** — `get_forecast_use_cases()`

### 5. Invariants
- `predicted_qty >= 0`
- `actual_qty >= 0`
- `confidence` 0-1
- `MAPE < 20%` = accurate
- `error == predicted - actual`

### 6. Domain Events
- `ForecastGenerated`, `ForecastUpdated`, `ForecastAccuracyDropped`

### 7. Tests
```python
async def test_generate_forecast(): ...
async def test_mape_calculation():
    f = Forecast(product_id="p1", branch_id="b1", predicted_qty=Decimal("100"))
    f.update_actual(Decimal("110"))
    assert f.mape == Decimal("9.09")  # (|100-110|/110)*100

async def test_forecast_accurate():
    f = Forecast(product_id="p1", branch_id="b1", predicted_qty=Decimal("100"))
    f.update_actual(Decimal("105"))
    assert f.is_accurate()

async def test_forecast_inaccurate():
    f = Forecast(product_id="p1", branch_id="b1", predicted_qty=Decimal("100"))
    f.update_actual(Decimal("200"))
    assert not f.is_accurate()

async def test_property_forecast_non_negative():
    for _ in range(100):
        f = Forecast(product_id="p1", branch_id="b1", predicted_qty=Decimal(str(random.uniform(0, 10000))))
        assert f.predicted_qty >= 0
```

## Output
- 23 ไฟล์
- Comment 2 ภาษา
- พร้อมรัน
```

### 📄 SQL Migration สำหรับ `forecast`

**`db/migrations/V001__create_forecast.sql`**
```sql
BEGIN;

CREATE TABLE tenant_fc.forecasts (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       UUID NOT NULL,
    product_id      UUID NOT NULL,
    branch_id       UUID NOT NULL,
    forecast_date   DATE NOT NULL,
    predicted_qty   NUMERIC(15,3) NOT NULL CHECK (predicted_qty >= 0),
    actual_qty      NUMERIC(15,3) CHECK (actual_qty IS NULL OR actual_qty >= 0),
    method          VARCHAR(20) NOT NULL DEFAULT 'LSTM',
    mape            NUMERIC(5,2),
    confidence      NUMERIC(5,4) NOT NULL DEFAULT 0 CHECK (confidence BETWEEN 0 AND 1),
    horizon_days    INTEGER NOT NULL DEFAULT 30,
    version         INTEGER NOT NULL DEFAULT 1,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_forecast UNIQUE (tenant_id, product_id, branch_id, forecast_date, method)
);

CREATE INDEX ix_forecast_product ON tenant_fc.forecasts(product_id, forecast_date);
CREATE INDEX ix_forecast_accuracy ON tenant_fc.forecasts(mape) WHERE mape IS NOT NULL;

ALTER TABLE tenant_fc.forecasts ENABLE ROW LEVEL SECURITY;
CREATE POLICY p_forecasts_tenant ON tenant_fc.forecasts
    USING (tenant_id = current_setting('app.current_tenant')::uuid);

COMMIT;
```

**`db/migrations/V002__seed_forecast.sql`**
```sql
BEGIN;
-- No seed data needed
COMMIT;
```

**`db/migrations/V003__rollback_forecast.sql`**
```sql
BEGIN;
DROP TABLE IF EXISTS tenant_fc.forecasts CASCADE;
COMMIT;
```

### 🧪 Tests สำหรับ `forecast`

**`tests/unit/test_forecast.py`**
```python
import pytest
from decimal import Decimal
from app.modules.forecast.domain.entities import Forecast

class TestForecastDomain:
    def test_create_valid(self):
        f = Forecast(product_id="p1", branch_id="b1", predicted_qty=Decimal("100"))
        assert f.predicted_qty == Decimal("100")

    def test_negative_predicted_raises(self):
        with pytest.raises(Exception):
            Forecast(product_id="p1", branch_id="b1", predicted_qty=Decimal("-10"))

    def test_mape_calculation(self):
        f = Forecast(product_id="p1", branch_id="b1", predicted_qty=Decimal("100"))
        f.update_actual(Decimal("110"))
        assert f.mape == Decimal("9.09")

    def test_is_accurate(self):
        f = Forecast(product_id="p1", branch_id="b1", predicted_qty=Decimal("100"))
        f.update_actual(Decimal("105"))
        assert f.is_accurate()

    def test_is_inaccurate(self):
        f = Forecast(product_id="p1", branch_id="b1", predicted_qty=Decimal("100"))
        f.update_actual(Decimal("200"))
        assert not f.is_accurate()

    def test_error_calculation(self):
        f = Forecast(product_id="p1", branch_id="b1", predicted_qty=Decimal("100"))
        f.update_actual(Decimal("90"))
        assert f.error() == Decimal("10")

    def test_property_predicted_non_negative(self):
        import random
        for _ in range(100):
            qty = Decimal(str(random.uniform(0, 10000)))
            f = Forecast(product_id="p1", branch_id="b1", predicted_qty=qty)
            assert f.predicted_qty >= 0
```

**`tests/integration/test_forecast_repository.py`** — testcontainers
**`tests/property/test_forecast_invariants.py`** — hypothesis
**`tests/manual/manual_test_forecast.md`** — manual test cases

---

## ✅ สรุป Layer 5 (Intelligence) — 7/65 ไฟล์

| # | Module | Prefix | Entities | Tables |
|---|---|---|---|---|
| 5.1 | `reporting` | `rpt` | Report, Schedule | `reports`, `report_executions` |
| 5.2 | `analytics` | `anl` | Metric, Snapshot | `metrics`, `metric_snapshots` |
| 5.3 | `forecast` | `fc` | Forecast | `forecasts` |
| 5.4 | `kpi` | `kpi` | KPI, KPIValue | `kpis`, `kpi_values` |
| 5.5 | `satisfaction` | `csat` | Survey, Response | `surveys`, `survey_responses` |
| 5.6 | `recommendation` | `reco` | Recommendation | `recommendations` |
| 5.7 | `oee` | `oee` | OEE, OEERecord | `oee_records` |

**Layer 5 เสร็จสมบูรณ์ — ต่อไปคือ Layer 6 (Monitoring)**

---
