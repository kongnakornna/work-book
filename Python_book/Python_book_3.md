# เล่ม 3: คุณภาพโค้ด ข้อผิดพลาด ไฟล์ และการทดสอบ

**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับสมบูรณ์ (ภาค 7–9)

---

## องค์ประกอบนำเล่ม

- ปก
- หน้าข้อมูลผู้แต่ง
- คำนำ
- สารบัญ
- สารบัญภาพ / ตาราง (ถ้ามี)

---

## คำนำ

เล่ม 3 นี้ต่อยอดจากเล่ม 2 ที่ว่าด้วยโครงสร้างข้อมูล OOP และ Functional Programming มาสู่สิ่งที่แยกนักพัฒนามือสมัครเล่นออกจากมืออาชีพ นั่นคือ **คุณภาพของโค้ด** เนื้อหาครอบคลุม 3 ด้านหลัก:

1. **การจัดการข้อผิดพลาดและการบันทึก (Error Handling & Logging)** — วิธีรับมือกับสิ่งที่ผิดพลาด ตั้งแต่ exception ไปจนถึง logging และ error tracking
2. **ไฟล์ การจัดเก็บ และรูปแบบข้อมูล (Files, Storage & Data Formats)** — การอ่าน/เขียนไฟล์ทุกรูปแบบที่ต้องเจอในงานจริง
3. **การทดสอบและคุณภาพโค้ด (Testing & Code Quality)** — การเขียน test, เครื่องมือ static analysis และแนวปฏิบัติที่ทำให้โค้ดเชื่อถือได้

ทุกภาคมาพร้อมตัวอย่างที่รันได้จริงในบริบทของงานพัฒนาระบบ เพื่อให้ผู้อ่านนำไปใช้ได้ทันที

> **หมายเหตุ:** ทุกบทในเล่มนี้ใช้โครงสร้างย่อยตาม **ส่วนที่ 2: แม่แบบการเขียนเนื้อหา** จากเล่ม 1

---

# ภาค 7: การจัดการข้อผิดพลาดและการบันทึก

## 7.1 Exception

### บทนำ

Exception เป็นกลไกหลักของ Python ในการรับมือกับข้อผิดพลาดที่เกิดขึ้นขณะรันโปรแกรม เข้าใจ exception hierarchy และวิธีใช้อย่างถูกต้องเป็นพื้นฐานของการเขียนโค้ดที่ทนทาน (robust)

### นิยาม

Exception คือ object ที่ Python สร้างขึ้นเมื่อเกิดข้อผิดพลาดขณะรันโปรแกรม และถูก "โยน" (raise) ขึ้นมาตาม call stack จนกว่าจะมีโค้ดที่ "จับ" (catch) มันไว้

### 7.1.1 คืออะไร

Python มี exception hierarchy ที่มี `BaseException` เป็นราก:

```
BaseException
├── SystemExit
├── KeyboardInterrupt
├── GeneratorExit
└── Exception
    ├── ArithmeticError
    │   ├── ZeroDivisionError
    │   └── OverflowError
    ├── LookupError
    │   ├── IndexError
    │   └── KeyError
    ├── OSError
    │   ├── FileNotFoundError
    │   ├── PermissionError
    │   └── ConnectionError
    ├── ValueError
    ├── TypeError
    ├── AttributeError
    ├── RuntimeError
    │   └── RecursionError
    └── StopIteration
```

**หลักการสำคัญ:** จับ `Exception` ไม่ใช่ `BaseException` เพราะ `SystemExit`, `KeyboardInterrupt` ไม่ควรถูกจับโดยไม่ตั้งใจ

### 7.1.2 ทำงานอย่างไร

เมื่อเกิดข้อผิดพลาด Python:
1. สร้าง exception object
2. หยุดการทำงานปกติ
3. ค้นหา handler ใน `try/except` ที่ใกล้ที่สุดใน call stack
4. ถ้าไม่เจอ → terminate โปรแกรมพร้อม traceback

### 7.1.3 การใช้งาน

**Exception ที่พบบ่อย:**

```python
# ValueError — ค่าผิด
try:
    age = int("abc")
except ValueError as e:
    print(f"ค่าไม่ถูกต้อง: {e}")

# TypeError — ชนิดข้อมูลผิด
try:
    result = "5" + 5
except TypeError as e:
    print(f"ชนิดข้อมูลไม่ตรงกัน: {e}")

# KeyError — ไม่มี key
user = {"name": "สมชาย"}
try:
    print(user["age"])
except KeyError as e:
    print(f"ไม่พบ key: {e}")

# IndexError — index เกิน
numbers = [1, 2, 3]
try:
    print(numbers[10])
except IndexError as e:
    print(f"index เกินขอบเขต: {e}")

# FileNotFoundError
try:
    with open("missing.txt") as f:
        content = f.read()
except FileNotFoundError as e:
    print(f"ไม่พบไฟล์: {e}")

# ZeroDivisionError
try:
    result = 10 / 0
except ZeroDivisionError as e:
    print(f"หารด้วยศูนย์: {e}")

# AttributeError
class Empty:
    pass

obj = Empty()
try:
    obj.method()
except AttributeError as e:
    print(f"ไม่มี attribute: {e}")
```

**Exception มี attributes ที่ใช้ได้:**

```python
def risky() -> None:
    raise ValueError("ค่าต้องมากกว่า 0")

try:
    risky()
except ValueError as e:
    print(f"Message: {e.args[0]}")   # ค่าต้องมากกว่า 0
    print(f"Args: {e.args}")          # ('ค่าต้องมากกว่า 0',)
    print(f"Type: {type(e).__name__}")  # ValueError
```

**Chain ของ Exception (`raise ... from ...`):**

```python
class ConfigError(Exception):
    """Configuration error"""


def load_config(path: str) -> dict:
    try:
        with open(path, encoding="utf-8") as f:
            import json
            return json.load(f)
    except FileNotFoundError as e:
        # โยน exception ใหม่ พร้อมบอกสาเหตุ
        raise ConfigError(f"ไม่พบไฟล์ config: {path}") from e


try:
    load_config("config.json")
except ConfigError as e:
    print(f"Error: {e}")
    print(f"Caused by: {e.__cause__}")
```

**Traceback ที่อ่านง่าย:**

```python
import traceback

def level3() -> None:
    raise ValueError("เกิดข้อผิดพลาดที่ level 3")

def level2() -> None:
    level3()

def level1() -> None:
    level2()

try:
    level1()
except ValueError:
    print("=== Traceback ===")
    traceback.print_exc()

# หรือเก็บเป็น string
try:
    level1()
except ValueError:
    tb_str = traceback.format_exc()
    # ส่ง tb_str ไป log ได้
```

**ตัวอย่างการใช้งานจริง — ตรวจสอบข้อมูลก่อนบันทึก:**

```python
from dataclasses import dataclass
from datetime import datetime

@dataclass
class Order:
    id: str
    amount: float
    created_at: datetime


class OrderValidationError(Exception):
    """ข้อผิดพลาดในการตรวจสอบ Order"""

    def __init__(self, field: str, message: str):
        self.field = field
        self.message = message
        super().__init__(f"{field}: {message}")


def create_order(
    order_id: str,
    amount: float,
    created_at: datetime,
) -> Order:
    """สร้าง Order พร้อม validate"""
    if not order_id or not order_id.strip():
        raise OrderValidationError("id", "ต้องไม่ว่าง")

    if amount <= 0:
        raise OrderValidationError("amount", "ต้องมากกว่า 0")

    if created_at > datetime.now():
        raise OrderValidationError("created_at", "ต้องไม่เป็นอนาคต")

    return Order(order_id, amount, created_at)


# ใช้งาน
try:
    order = create_order("ORD-001", -100, datetime.now())
except OrderValidationError as e:
    print(f"Validation failed: {e.field} — {e.message}")
    # Validation failed: amount — ต้องมากกว่า 0
```

### 7.1.4 ข้อดี

- **แยก error handling:** จาก business logic
- **Type-safe:** จับเฉพาะ exception ที่ต้องการ
- **Information-rich:** exception มีข้อมูลเยอะ
- **Propagation:** โยนข้ามชั้นได้
- **Hierarchy:** จัดกลุ่ม exception

### 7.1.5 ข้อเสีย

- **Performance:** try/except มี overhead
- **Overuse:** ใช้ exception แทน control flow
- **Hidden bugs:** จับกว้างเกินไป
- **Traceback noise:** ถ้าโยนซ้ำหลายชั้น

### 7.1.6 ข้อควรระวัง

```python
# ระวัง 1: จับ Exception กว้างเกินไป
# ❌ จับทุกอย่าง รวมถึง KeyboardInterrupt
try:
    risky_operation()
except Exception:
    pass  # กลืน error ทั้งหมด — อันตราย!

# ✅ จับเฉพาะที่คาดไว้
try:
    risky_operation()
except (ValueError, KeyError) as e:
    log_error(e)

# ระวัง 2: ใช้ except แบบเงียบ
# ❌
try:
    process()
except Exception:
    pass  # ไม่รู้ว่าเกิดอะไร

# ✅
try:
    process()
except Exception as e:
    logger.exception("process failed")
    raise  # หรือจัดการอย่างเหมาะสม

# ระวัง 3: try/except แทน control flow
# ❌ ช้าและอ่านยาก
try:
    value = data["key"]
except KeyError:
    value = "default"

# ✅
value = data.get("key", "default")

# ระวัง 4: ลืม raise หรือ return
def bad():
    try:
        return compute()
    except ValueError:
        pass  # ❌ return None โดยไม่ตั้งใจ

# ✅
def good():
    try:
        return compute()
    except ValueError as e:
        logger.warning(f"compute failed: {e}")
        return None

# ระวัง 5: จับ BaseException
# ❌ จะจับ SystemExit, KeyboardInterrupt
try:
    do_work()
except BaseException:
    pass

# ✅
try:
    do_work()
except Exception:
    pass

# ระวัง 6: Exception ใน finally override
def bad2():
    try:
        raise ValueError("original")
    finally:
        raise RuntimeError("override")  # ValueError หาย!
```

### 7.1.7 สรุป

**Exception ใช้เมื่อ:**
- ข้อผิดพลาดที่คาดไม่ถึง
- เงื่อนไขที่ทำต่อไม่ได้
- ทรัพยากรไม่พร้อม (ไฟล์, network)

**ไม่ใช้เมื่อ:**
- Control flow ปกติ
- เงื่อนไขที่ตรวจสอบได้ก่อน

**Best practices:**
- จับเฉพาะ exception ที่รู้วิธีจัดการ
- ใช้ `raise` เปล่า ๆ เพื่อ re-raise
- ใช้ `raise ... from ...` เพื่อ chain
- Log ก่อน swallow
- อย่าใช้ `except:` เปล่า ๆ

> **อ้างอิงเพิ่มเติม:** [Built-in Exceptions](https://docs.python.org/3/library/exceptions.html), [Errors and Exceptions](https://docs.python.org/3/tutorial/errors.html)

---

## 7.2 try / except / else / finally

### บทนำ

โครงสร้าง `try` มี 4 ส่วน: `try`, `except`, `else`, `finally` แต่ละส่วนมีบทบาทชัดเจน การใช้ให้ถูกต้องทำให้ error handling อ่านง่ายและปลอดภัย

### นิยาม

- **try:** โค้ดที่อาจเกิด exception
- **except:** จัดการ exception
- **else:** รันเมื่อ try สำเร็จ (ไม่มี exception)
- **finally:** รันเสมอ ไม่ว่า exception จะเกิดหรือไม่

### 7.2.1 คืออะไร

`else` และ `finally` เป็น optional แต่มีประโยชน์มาก:
- `else` แยก "โค้ดที่อาจ fail" ออกจาก "โค้ดที่ต้องทำเมื่อสำเร็จ"
- `finally` สำหรับ cleanup ที่ต้องรันเสมอ

### 7.2.2 ทำงานอย่างไร

ลำดับการทำงาน:

```
try:
    # 1. รัน
    ...
except SomeError:
    # 2. รันถ้ามี exception
    ...
else:
    # 3. รันถ้าไม่มี exception
    ...
finally:
    # 4. รันเสมอ (ก่อน return หรือ propagate)
    ...
```

### 7.2.3 การใช้งาน

**โครงสร้างครบ:**

```python
def read_number(path: str) -> int:
    try:
        f = open(path, encoding="utf-8")
    except FileNotFoundError as e:
        print(f"ไม่พบไฟล์: {e}")
        raise
    else:
        # รันเฉพาะเมื่อ open สำเร็จ
        try:
            content = f.read()
            return int(content.strip())
        except ValueError as e:
            print(f"เนื้อหาไม่ใช่ตัวเลข: {e}")
            raise
        finally:
            f.close()
```

**`else` แยก logic:**

```python
# ❌ ไม่ใช้ else — โค้ดที่อาจ fail อยู่ใน try ใหญ่เกินไป
def bad_divide(a: float, b: float) -> float:
    try:
        result = a / b
        print(f"ผลลัพธ์: {result}")
        log_to_file(result)  # ❌ ถ้า log fail จะเข้า except
        return result
    except ZeroDivisionError:
        print("หารด้วยศูนย์")
        return 0.0

# ✅ ใช้ else
def good_divide(a: float, b: float) -> float:
    try:
        result = a / b
    except ZeroDivisionError:
        print("หารด้วยศูนย์")
        return 0.0
    else:
        # รันเฉพาะเมื่อไม่มี exception
        print(f"ผลลัพธ์: {result}")
        log_to_file(result)
        return result
```

**`finally` สำหรับ cleanup:**

```python
import time

def timed_operation() -> None:
    start = time.perf_counter()
    try:
        # งานที่อาจ fail
        do_something_risky()
    finally:
        # รันเสมอ แม้ exception
        elapsed = time.perf_counter() - start
        print(f"ใช้เวลา: {elapsed:.4f}s")


# Resource cleanup
def process_file(path: str) -> None:
    f = None
    try:
        f = open(path, encoding="utf-8")
        data = f.read()
        process(data)
    finally:
        if f is not None:
            f.close()
```

**Context Manager — ทางเลือกที่สะอาดกว่า:**

```python
# ✅ ใช้ with — จัดการ cleanup อัตโนมัติ
def process_file_clean(path: str) -> None:
    with open(path, encoding="utf-8") as f:
        data = f.read()
        process(data)
    # f.close() เรียกอัตโนมัติ แม้ exception
```

**Nested try:**

```python
def complex_operation(data: dict) -> str:
    try:
        # ชั้นนอก — จัดการ error ระดับสูง
        try:
            user_id = data["user_id"]
            user = fetch_user(user_id)
        except KeyError:
            raise ValueError("ต้องระบุ user_id") from None
        except ConnectionError as e:
            raise RuntimeError("เชื่อมต่อไม่ได้") from e

        # ดำเนินการต่อ
        return process_user(user)

    except ValueError as e:
        logger.error(f"ข้อมูลไม่ถูกต้อง: {e}")
        return ""
    except RuntimeError as e:
        logger.error(f"ระบบขัดข้อง: {e}")
        return ""
```

**`finally` กับ `return`:**

```python
def with_finally() -> int:
    try:
        return 1
    finally:
        print("finally รันก่อน return")
        # ⚠️ ถ้า finally มี return จะ override

def override() -> int:
    try:
        return 1
    finally:
        return 2  # ⚠️ return 2 — ไม่ควรทำ!

print(override())  # 2
```

**ตัวอย่างการใช้งานจริง — Database Transaction:**

```python
from typing import Any
from contextlib import contextmanager
import logging

logger = logging.getLogger(__name__)


class Database:
    def __init__(self) -> None:
        self.connected = False

    def connect(self) -> None:
        self.connected = True
        print("Connected")

    def disconnect(self) -> None:
        self.connected = False
        print("Disconnected")

    def begin(self) -> None:
        print("BEGIN")

    def commit(self) -> None:
        print("COMMIT")

    def rollback(self) -> None:
        print("ROLLBACK")

    def execute(self, sql: str) -> list[Any]:
        if not self.connected:
            raise RuntimeError("Not connected")
        print(f"Executing: {sql}")
        return []


def transfer_funds(
    db: Database,
    from_account: str,
    to_account: str,
    amount: float,
) -> None:
    """โอนเงินแบบ atomic — rollback ถ้า fail"""
    db.connect()
    try:
        db.begin()
        try:
            db.execute(
                f"UPDATE accounts SET balance = balance - {amount} "
                f"WHERE id = '{from_account}'"
            )
            db.execute(
                f"UPDATE accounts SET balance = balance + {amount} "
                f"WHERE id = '{to_account}'"
            )
        except Exception:
            db.rollback()
            logger.exception("โอนเงินล้มเหลว")
            raise
        else:
            db.commit()
            logger.info(f"โอน {amount} สำเร็จ")
    finally:
        db.disconnect()


# ใช้งาน
db = Database()
transfer_funds(db, "ACC-001", "ACC-002", 1000.0)
# Connected
# BEGIN
# Executing: ...
# Executing: ...
# COMMIT
# Disconnected
```

**ตัวอย่าง — Retry with try/else/finally:**

```python
import time
from typing import TypeVar, Callable

T = TypeVar("T")


def retry(
    func: Callable[[], T],
    max_attempts: int = 3,
    delay: float = 1.0,
    exceptions: tuple[type[Exception], ...] = (Exception,),
) -> T:
    """ลองใหม่จนสำเร็จหรือครบจำนวน"""
    last_error: Exception | None = None

    for attempt in range(1, max_attempts + 1):
        try:
            result = func()
        except exceptions as e:
            last_error = e
            if attempt < max_attempts:
                logger.warning(
                    f"Attempt {attempt}/{max_attempts} failed: {e}. "
                    f"Retrying in {delay}s..."
                )
                time.sleep(delay)
                delay *= 2  # exponential backoff
        else:
            logger.info(f"Success on attempt {attempt}")
            return result
        finally:
            logger.debug(f"Attempt {attempt} finished")

    raise RuntimeError(
        f"Failed after {max_attempts} attempts"
    ) from last_error
```

### 7.2.4 ข้อดี

- **ชัดเจน:** แยก success/failure paths
- **ปลอดภัย:** `finally` การันตี cleanup
- **อ่านง่าย:** โค้ดมีโครงสร้าง
- **ไม่ซ้ำ:** `finally` ไม่ต้องเขียน cleanup ซ้ำ

### 7.2.5 ข้อเสีย

- **Verbose:** 4 ส่วนอาจยาว
- **สับสน:** ลำดับการทำงานไม่ intuitive
- **กับดัก:** `return` ใน `finally`

### 7.2.6 ข้อควรระวัง

```python
# ระวัง 1: return ใน finally override
def bad() -> int:
    try:
        return 1
    finally:
        return 2  # ❌ override

# ระวัง 2: break/continue ใน finally
for i in range(5):
    try:
        if i == 2:
            break
    finally:
        # ⚠️ break ใน finally จะ override
        pass

# ระวัง 3: Exception ใน finally
def bad2():
    try:
        raise ValueError("original")
    finally:
        raise RuntimeError("override")  # ❌ ValueError หาย

# ระวัง 4: try ใหญ่เกินไป
# ❌ โค้ดที่ไม่อาจ fail อยู่ใน try
try:
    user = get_user(user_id)  # อาจ fail
    name = user.name            # ควรอยู่นอก try
    print(name)
except AttributeError:
    pass

# ✅ แยกให้ชัด
try:
    user = get_user(user_id)
except UserNotFound:
    return None

name = user.name
print(name)

# ระวัง 5: else ที่ไม่จำเป็น
# ❌
try:
    result = compute()
except ValueError:
    handle()
else:
    pass  # ไม่มีประโยชน์

# ✅
try:
    result = compute()
except ValueError:
    handle()
```

### 7.2.7 สรุป

**เมื่อใช้แต่ละส่วน:**

| ส่วน | ใช้เมื่อ |
|------|---------|
| `try` | โค้ดที่อาจ raise exception |
| `except` | จัดการ exception |
| `else` | รันเมื่อ try สำเร็จ (แยก logic) |
| `finally` | Cleanup ที่ต้องรันเสมอ |

**Best practices:**
- `try` ให้เล็กที่สุด
- ใช้ `else` แยก success path
- ใช้ `finally` สำหรับ cleanup
- ใช้ `with` เมื่อเป็นไปได้
- อย่า `return` ใน `finally`

> **อ้างอิงเพิ่มเติม:** [The try statement](https://docs.python.org/3/reference/compound_stmts.html#the-try-statement)

---

## 7.3 raise

### บทนำ

`raise` ใช้โยน exception ด้วยตัวเอง ทั้งเพื่อแจ้ง error และเพื่อ re-raise exception ที่จับได้ การใช้ `raise` อย่างถูกต้องเป็นทักษะสำคัญ

### นิยาม

- `raise ExceptionType(...)` — โยน exception ใหม่
- `raise` — re-raise exception ปัจจุบัน
- `raise ... from ...` — chain exception

### 7.3.1 คืออะไร

`raise` หยุดการทำงานปกติและส่ง exception ขึ้น call stack

### 7.3.2 ทำงานอย่างไร

เมื่อ `raise`:
1. Python สร้าง exception object (ถ้ามี argument)
2. ตั้ง `__traceback__`
3. ค้นหา handler
4. ถ้าไม่เจอ → terminate

### 7.3.3 การใช้งาน

**โยน exception พื้นฐาน:**

```python
def set_age(age: int) -> None:
    if age < 0:
        raise ValueError("อายุต้องไม่ติดลบ")
    if age > 150:
        raise ValueError("อายุต้องไม่เกิน 150")
    print(f"อายุ: {age}")


try:
    set_age(-5)
except ValueError as e:
    print(f"Error: {e}")
```

**Re-raise ด้วย `raise` เปล่า:**

```python
import logging

logger = logging.getLogger(__name__)


def process_data(data: dict) -> None:
    try:
        result = validate(data)
        save(result)
    except ValidationError:
        logger.exception("Validation failed")
        raise  # ✅ re-raise — รักษา traceback เดิม
```

**Chain exception ด้วย `from`:**

```python
# ✅ ดี — บอกสาเหตุ
def load_config(path: str) -> dict:
    try:
        with open(path, encoding="utf-8") as f:
            import json
            return json.load(f)
    except (OSError, json.JSONDecodeError) as e:
        raise ConfigError(f"อ่าน config ไม่ได้: {path}") from e


# ❌ ไม่ดี — ไม่บอกสาเหตุ
def bad_load(path: str) -> dict:
    try:
        with open(path) as f:
            import json
            return json.load(f)
    except Exception:
        raise ConfigError("อ่าน config ไม่ได้")  # ขาด context


# ใช้ from None เพื่อ suppress context
def parse_user_id(value: str) -> int:
    try:
        return int(value)
    except ValueError:
        raise ValueError(f"user_id ต้องเป็นตัวเลข: {value!r}") from None
```

**Difference: `from e` vs `from None`:**

```python
# from e — แสดง "The above exception was the direct cause"
def with_cause():
    try:
        int("abc")
    except ValueError as e:
        raise RuntimeError("แปลงไม่ได้") from e

# from None — suppress "During handling of the above exception"
def without_context():
    try:
        int("abc")
    except ValueError:
        raise RuntimeError("แปลงไม่ได้") from None
```

**Custom Exception:**

```python
class AppError(Exception):
    """Base exception ของแอป"""

    def __init__(self, message: str, code: str = "UNKNOWN"):
        self.message = message
        self.code = code
        super().__init__(message)


class ValidationError(AppError):
    def __init__(self, field: str, message: str):
        self.field = field
        super().__init__(
            message=f"{field}: {message}",
            code="VALIDATION_ERROR",
        )


class NotFoundError(AppError):
    def __init__(self, resource: str, id_: str):
        self.resource = resource
        self.id = id_
        super().__init__(
            message=f"{resource} ไม่พบ: {id_}",
            code="NOT_FOUND",
        )


class PermissionError_(AppError):
    def __init__(self, action: str):
        super().__init__(
            message=f"ไม่มีสิทธิ์: {action}",
            code="PERMISSION_DENIED",
        )


# ใช้งาน
def delete_user(user_id: str, requester_role: str) -> None:
    if requester_role != "admin":
        raise PermissionError_("delete_user")

    user = find_user(user_id)
    if user is None:
        raise NotFoundError("User", user_id)

    actually_delete(user)
```

**โยน exception ใน comprehension:**

```python
def parse_numbers(values: list[str]) -> list[int]:
    """แปลง str เป็น int — raise ถ้ามีตัวที่ไม่ใช่เลข"""
    result = []
    for i, value in enumerate(values):
        try:
            result.append(int(value))
        except ValueError as e:
            raise ValueError(
                f"ค่าที่ index {i} ไม่ใช่ตัวเลข: {value!r}"
            ) from e
    return result


# หรือใช้ explicit loop
def parse_numbers_v2(values: list[str]) -> list[int]:
    def parse_one(idx_value: tuple[int, str]) -> int:
        idx, value = idx_value
        try:
            return int(value)
        except ValueError as e:
            raise ValueError(
                f"index {idx}: {value!r} ไม่ใช่ตัวเลข"
            ) from e

    return [parse_one(pair) for pair in enumerate(values)]
```

**ตัวอย่างการใช้งานจริง — API Response:**

```python
from enum import Enum
from typing import Any


class ErrorCode(str, Enum):
    VALIDATION = "VALIDATION_ERROR"
    NOT_FOUND = "NOT_FOUND"
    CONFLICT = "CONFLICT"
    UNAUTHORIZED = "UNAUTHORIZED"
    INTERNAL = "INTERNAL_ERROR"


class APIError(Exception):
    """Base API exception"""

    status_code: int = 500
    error_code: ErrorCode = ErrorCode.INTERNAL

    def __init__(
        self,
        message: str,
        details: dict[str, Any] | None = None,
    ):
        self.message = message
        self.details = details or {}
        super().__init__(message)

    def to_response(self) -> dict[str, Any]:
        return {
            "error": {
                "code": self.error_code.value,
                "message": self.message,
                "details": self.details,
            }
        }


class ValidationAPIError(APIError):
    status_code = 400
    error_code = ErrorCode.VALIDATION

    def __init__(self, field: str, message: str):
        super().__init__(
            message=f"Validation failed: {field}",
            details={"field": field, "reason": message},
        )


class NotFoundAPIError(APIError):
    status_code = 404
    error_code = ErrorCode.NOT_FOUND

    def __init__(self, resource: str, id_: str):
        super().__init__(
            message=f"{resource} not found",
            details={"resource": resource, "id": id_},
        )


class ConflictAPIError(APIError):
    status_code = 409
    error_code = ErrorCode.CONFLICT


# Handler
def handle_api_error(error: APIError) -> tuple[int, dict]:
    return error.status_code, error.to_response()


# ใช้งาน
try:
    raise NotFoundAPIError("User", "U-123")
except APIError as e:
    status, body = handle_api_error(e)
    print(f"Status: {status}")
    print(body)
```

**ตัวอย่าง — Result Type (หลีกเลี่ยง exception):**

```python
from dataclasses import dataclass
from typing import Generic, TypeVar, Union

T = TypeVar("T")
E = TypeVar("E")


@dataclass(frozen=True)
class Ok(Generic[T]):
    value: T

    def is_ok(self) -> bool:
        return True

    def unwrap(self) -> T:
        return self.value


@dataclass(frozen=True)
class Err(Generic[E]):
    error: E

    def is_ok(self) -> bool:
        return False

    def unwrap(self) -> T:
        raise ValueError(f"Cannot unwrap Err: {self.error}")


Result = Union[Ok[T], Err[E]]


def divide(a: float, b: float) -> Result[float, str]:
    if b == 0:
        return Err("หารด้วยศูนย์ไม่ได้")
    return Ok(a / b)


# ใช้งาน
result = divide(10, 2)
if result.is_ok():
    print(f"ผลลัพธ์: {result.unwrap()}")
else:
    print(f"Error: {result.error}")

result = divide(10, 0)
if not result.is_ok():
    print(f"Error: {result.error}")
```

### 7.3.4 ข้อดี

- **ชัดเจน:** บอก intent
- **Type-safe:** custom exception
- **Chain:** รักษา context
- **Flexible:** โยนจากที่ไหนก็ได้

### 7.3.5 ข้อเสีย

- **Performance:** การ raise มี overhead
- **Control flow:** ถ้าใช้ผิดที่
- **Traceback:** อาจยาว

### 7.3.6 ข้อควรระวัง

```python
# ระวัง 1: โยน exception generic
# ❌
def process(data):
    if not data:
        raise Exception("data ว่าง")  # ไม่ specific

# ✅
def process_good(data):
    if not data:
        raise ValueError("data ต้องไม่ว่าง")

# ระวัง 2: ข้อความ error ไม่มีประโยชน์
# ❌
raise ValueError("Error")

# ✅
raise ValueError(
    f"amount ต้องมากกว่า 0, ได้รับ: {amount!r}"
)

# ระวัง 3: raise ใน __init__ ของ exception
class Bad(Exception):
    def __init__(self, msg):
        self.msg = msg
        # ❌ ลืม super().__init__(msg)
        # → str(e) ว่าง

class Good(Exception):
    def __init__(self, msg):
        self.msg = msg
        super().__init__(msg)

# ระวัง 4: raise เปล่า นอก except
# ❌ RuntimeError
def bad():
    raise  # ไม่มี active exception

# ระวัง 5: Exception subclass ที่ไม่ควร
# ❌ สืบทอด BaseException
class MyError(BaseException):  # จับด้วย except Exception ไม่ได้
    pass

# ✅
class MyError(Exception):
    pass

# ระวัง 6: รักษา traceback
# ❌ สูญเสีย traceback
def bad_reraise():
    try:
        risky()
    except ValueError:
        raise ValueError("new message")  # traceback เดิมหาย

# ✅
def good_reraise():
    try:
        risky()
    except ValueError as e:
        raise ValueError("new message") from e
```

### 7.3.7 สรุป

**ใช้ `raise` เมื่อ:**
- ตรวจพบเงื่อนไขที่ทำต่อไม่ได้
- Validate input
- ป้องกัน invariant violation
- Re-raise หลัง log

**Best practices:**
- ใช้ specific exception types
- ข้อความ error มีประโยชน์ (ระบุค่า, บริบท)
- ใช้ `from e` เมื่อ chain
- ใช้ `from None` เมื่อไม่ต้องการ context
- Custom exceptions inherit จาก `Exception`
- เรียก `super().__init__(message)`

> **อ้างอิงเพิ่มเติม:** [The raise statement](https://docs.python.org/3/reference/simple_stmts.html#the-raise-statement)

---

## 7.4 Custom Exception

### บทนำ

Custom Exception ช่วยให้แยกแยะข้อผิดพลาดตาม domain และจัดการได้ตรงจุด เป็นเครื่องมือสำคัญในการออกแบบ API ของ library และ application

### นิยาม

Custom Exception คือ class ที่สืบทอดจาก `Exception` (หรือ subclass) เพื่อแทนข้อผิดพลาดเฉพาะ

### 7.4.1 คืออะไร

Custom Exception ช่วย:
- แยกแยะ error types
- เพิ่มข้อมูลใน exception
- จัดการตาม domain
- สื่อสาร intent

### 7.4.2 ทำงานอย่างไร

สืบทอดจาก `Exception` และเพิ่ม attributes/methods ตามต้องการ

### 7.4.3 การใช้งาน

**Custom Exception พื้นฐาน:**

```python
class AppError(Exception):
    """Base exception ของแอป — จับทั้งหมดด้วยตัวนี้"""


class ValidationError(AppError):
    """ข้อมูลไม่ถูกต้อง"""


class NotFoundError(AppError):
    """ไม่พบข้อมูล"""


class ConflictError(AppError):
    """ข้อมูลขัดแย้ง"""


# ใช้งาน
def create_user(username: str) -> dict:
    if not username:
        raise ValidationError("username ต้องไม่ว่าง")
    if username_exists(username):
        raise ConflictError(f"username นี้มีอยู่แล้ว: {username}")
    return {"username": username}


# จับแบบ specific
try:
    create_user("")
except ValidationError as e:
    print(f"Validation: {e}")
except ConflictError as e:
    print(f"Conflict: {e}")
except AppError as e:
    print(f"App error: {e}")
```

**Custom Exception พร้อมข้อมูล:**

```python
from dataclasses import dataclass
from typing import Any


@dataclass
class FieldError:
    field: str
    value: Any
    message: str


class ValidationError(Exception):
    """Validation error พร้อมรายละเอียด"""

    def __init__(self, errors: list[FieldError]):
        self.errors = errors
        messages = [f"{e.field}: {e.message}" for e in errors]
        super().__init__("; ".join(messages))

    def to_dict(self) -> dict:
        return {
            "errors": [
                {
                    "field": e.field,
                    "value": repr(e.value),
                    "message": e.message,
                }
                for e in self.errors
            ]
        }


def validate_user(data: dict) -> None:
    errors: list[FieldError] = []

    username = data.get("username", "")
    if not username:
        errors.append(FieldError("username", username, "ต้องไม่ว่าง"))
    elif len(username) < 3:
        errors.append(FieldError(
            "username", username, "ต้องมีอย่างน้อย 3 ตัวอักษร"
        ))

    email = data.get("email", "")
    if "@" not in email:
        errors.append(FieldError("email", email, "รูปแบบไม่ถูกต้อง"))

    age = data.get("age")
    if not isinstance(age, int) or not 0 <= age <= 150:
        errors.append(FieldError("age", age, "ต้องเป็น 0-150"))

    if errors:
        raise ValidationError(errors)


# ใช้งาน
try:
    validate_user({"username": "ab", "email": "invalid", "age": 200})
except ValidationError as e:
    print(f"พบ {len(e.errors)} ข้อผิดพลาด:")
    for error in e.errors:
        print(f"  - {error.field}: {error.message}")
```

**Exception Hierarchy ตาม Domain:**

```python
# ========== Base ==========
class DomainError(Exception):
    """Base ของ domain errors ทั้งหมด"""


# ========== User Domain ==========
class UserError(DomainError):
    """Base ของ user errors"""


class UserNotFound(UserError):
    def __init__(self, user_id: str):
        self.user_id = user_id
        super().__init__(f"ไม่พบ user: {user_id}")


class UserAlreadyExists(UserError):
    def __init__(self, username: str):
        self.username = username
        super().__init__(f"user มีอยู่แล้ว: {username}")


class InvalidCredentials(UserError):
    """Username หรือ password ไม่ถูกต้อง"""


class UserSuspended(UserError):
    def __init__(self, user_id: str, reason: str):
        self.user_id = user_id
        self.reason = reason
        super().__init__(f"user {user_id} ถูกระงับ: {reason}")


# ========== Order Domain ==========
class OrderError(DomainError):
    """Base ของ order errors"""


class OrderNotFound(OrderError):
    def __init__(self, order_id: str):
        self.order_id = order_id
        super().__init__(f"ไม่พบ order: {order_id}")


class InsufficientStock(OrderError):
    def __init__(self, product_id: str, requested: int, available: int):
        self.product_id = product_id
        self.requested = requested
        self.available = available
        super().__init__(
            f"สินค้า {product_id} มีไม่พอ: "
            f"ต้องการ {requested}, มี {available}"
        )


class OrderAlreadyShipped(OrderError):
    """ไม่สามารถแก้ไข order ที่ ship แล้ว"""


# ใช้งาน — จัดการตาม hierarchy
def process_order(order_id: str) -> None:
    try:
        order = fetch_order(order_id)
        check_stock(order)
        ship_order(order)
    except OrderNotFound as e:
        # จัดการ specific
        logger.warning(f"ไม่พบ order: {e.order_id}")
    except InsufficientStock as e:
        # จัดการ specific
        logger.warning(f"สต็อกไม่พอ: {e}")
        notify_purchasing(e.product_id)
    except OrderError as e:
        # จับ order errors อื่น ๆ
        logger.error(f"Order error: {e}")
    except DomainError as e:
        # จับ domain errors ทั้งหมด
        logger.error(f"Domain error: {e}")
```

**Exception กับ HTTP Status Code:**

```python
class HTTPError(Exception):
    """Base HTTP error"""

    status_code: int = 500

    def __init__(self, message: str):
        self.message = message
        super().__init__(message)


class BadRequest(HTTPError):
    status_code = 400


class Unauthorized(HTTPError):
    status_code = 401


class Forbidden(HTTPError):
    status_code = 403


class NotFound(HTTPError):
    status_code = 404


class Conflict(HTTPError):
    status_code = 409


class UnprocessableEntity(HTTPError):
    status_code = 422


class InternalServerError(HTTPError):
    status_code = 500


# Handler
def error_to_response(error: HTTPError) -> tuple[int, dict]:
    return error.status_code, {"error": error.message}


# ใช้งาน
try:
    raise NotFound("User not found")
except HTTPError as e:
    status, body = error_to_response(e)
    print(f"HTTP {status}: {body}")
```

**Custom Exception สำหรับ Retry:**

```python
class RetryableError(Exception):
    """Error ที่ retry ได้"""


class NonRetryableError(Exception):
    """Error ที่ retry ไม่ได้"""


class TransientNetworkError(RetryableError):
    """Network error ชั่วคราว"""


class AuthenticationError(NonRetryableError):
    """Authentication ผิด — retry ไม่ช่วย"""


def call_api() -> dict:
    """API call"""


def with_retry(func, max_attempts: int = 3) -> dict:
    last_error: Exception | None = None

    for attempt in range(1, max_attempts + 1):
        try:
            return func()
        except RetryableError as e:
            last_error = e
            logger.warning(f"Attempt {attempt} failed: {e}")
            if attempt < max_attempts:
                time.sleep(2 ** attempt)
        except NonRetryableError:
            raise  # ไม่ retry

    raise RuntimeError("Retry exhausted") from last_error
```

**ตัวอย่างการใช้งานจริง — File Parser:**

```python
from pathlib import Path
from typing import Any


class ParseError(Exception):
    """Base parse error"""

    def __init__(self, message: str, line: int | None = None):
        self.line = line
        if line is not None:
            message = f"บรรทัด {line}: {message}"
        super().__init__(message)


class EmptyFileError(ParseError):
    def __init__(self, path: Path):
        self.path = path
        super().__init__(f"ไฟล์ว่าง: {path}")


class InvalidFormatError(ParseError):
    def __init__(self, line: int, reason: str, content: str):
        self.reason = reason
        self.content = content
        super().__init__(
            f"รูปแบบไม่ถูกต้อง ({reason}): {content[:50]!r}",
            line=line,
        )


class MissingColumnError(ParseError):
    def __init__(self, line: int, column: str, found: list[str]):
        self.column = column
        self.found = found
        super().__init__(
            f"ไม่พบ column '{column}' (พบ: {found})",
            line=line,
        )


def parse_csv(path: Path) -> list[dict[str, str]]:
    """Parse CSV พร้อม custom errors"""
    import csv

    if not path.exists():
        raise FileNotFoundError(path)

    with path.open(encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    if not rows:
        raise EmptyFileError(path)

    # ตรวจสอบ columns
    required = {"id", "name"}
    if reader.fieldnames:
        missing = required - set(reader.fieldnames)
        if missing:
            raise MissingColumnError(
                line=1,
                column=list(missing)[0],
                found=reader.fieldnames,
            )

    # ตรวจสอบข้อมูลแต่ละแถว
    for i, row in enumerate(rows, start=2):
        if not row.get("id"):
            raise InvalidFormatError(
                line=i,
                reason="id ว่าง",
                content=str(row),
            )

    return rows
```

### 7.4.4 ข้อดี

- **Specific:** แยกแยะ error types
- **Information-rich:** เพิ่มข้อมูลได้
- **Organized:** hierarchy ชัดเจน
- **Domain-aligned:** ตรงกับ business
- **Catchable:** จับตามระดับ

### 7.4.5 ข้อเสีย

- **Boilerplate:** สร้าง class เยอะ
- **Over-engineering:** ถ้ามากเกิน
- **Deep hierarchy:** ซับซ้อน

### 7.4.6 ข้อควรระวัง

```python
# ระวัง 1: สร้าง exception เยอะเกินไป
# ❌
class Error1(Exception): pass
class Error2(Exception): pass
# ... 50 classes

# ✅ จัดกลุ่ม + attributes
class ValidationError(Exception):
    def __init__(self, code: str, message: str):
        self.code = code
        super().__init__(message)

# ระวัง 2: Hierarchy ที่ลึกเกินไป
# ❌
# AppError → DomainError → UserError → LoginError → InvalidPassword

# ✅ 2-3 levels
# AppError → UserError → InvalidCredentials

# ระวัง 3: ลืม super().__init__
class Bad(Exception):
    def __init__(self, msg):
        self.msg = msg
        # ❌ ไม่ได้ super().__init__(msg)
        # ทำให้ str(e) เป็น ""

# ระวัง 4: สืบทอดผิด type
# ❌
class MyError(BaseException):  # จับด้วย except Exception ไม่ได้
    pass

# ✅
class MyError(Exception):
    pass

# ระวัง 5: ข้อมูลที่ใส่ใน exception
# ❌ ใส่มากเกินไป
class VerboseError(Exception):
    def __init__(self, data, config, history, user, request):
        # ...

# ✅ ใส่เท่าที่จำเป็น
class AppError(Exception):
    def __init__(self, message: str, code: str = "UNKNOWN"):
        self.code = code
        super().__init__(message)

# ระวัง 6: __str__ ที่ไม่ให้ข้อมูล
class Bad2(Exception):
    def __str__(self):
        return "Something went wrong"  # ❌ ไม่มีประโยชน์
```

### 7.4.7 สรุป

**ใช้ Custom Exception เมื่อ:**
- Domain-specific errors
- ต้องการข้อมูลเพิ่มใน exception
- ต้องการแยกแยะใน caller
- Library/API public interface
- จัดกลุ่ม exception

**Best practices:**
- Base class `AppError` (หรือชื่อแอป)
- 2-3 ระดับ hierarchy
- ใส่ข้อมูลที่จำเป็น
- `super().__init__(message)`
- ใช้ `__str__` ให้ข้อมูล
- Document exception

> **อ้างอิงเพิ่มเติม:** [User-defined Exceptions](https://docs.python.org/3/tutorial/errors.html#user-defined-exceptions)

---

## 7.5 Assertion

### บทนำ

`assert` เป็นเครื่องมือตรวจสอบเงื่อนไขที่ควรเป็นจริง ใช้สำหรับ debugging และ internal invariant แต่ **ไม่ใช่** สำหรับ validation ข้อมูลจากผู้ใช้

### นิยาม

`assert condition, message` — raise `AssertionError` ถ้า condition เป็น False

### 7.5.1 คืออะไร

- ใช้ระหว่าง development
- **ถูกปิด** เมื่อรันด้วย `python -O` (optimize)
- ไม่ควรใช้กับ user input
- เหมาะกับ internal checks

### 7.5.2 ทำงานอย่างไร

เมื่อรัน Python ปกติ `assert` ทำงาน เมื่อใช้ `-O` flag Python จะตัด `assert` ออก

```bash
python script.py       # assert ทำงาน
python -O script.py    # assert ถูกปิด
```

### 7.5.3 การใช้งาน

**ใช้ถูก — Internal Invariants:**

```python
def calculate_average(numbers: list[float]) -> float:
    assert numbers, "numbers ต้องไม่ว่าง"  # internal check
    return sum(numbers) / len(numbers)


def binary_search(sorted_list: list[int], target: int) -> int:
    # assert ว่า list เรียงแล้ว (developer ต้องการันตี)
    assert sorted_list == sorted(sorted_list), "list ต้องเรียงแล้ว"

    low, high = 0, len(sorted_list) - 1
    while low <= high:
        mid = (low + high) // 2
        if sorted_list[mid] == target:
            return mid
        elif sorted_list[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1
```

**Type narrowing:**

```python
from typing import Optional


def process_user(user: Optional[dict]) -> str:
    assert user is not None, "user ต้องไม่ None"
    # ตอนนี้ type checker รู้ว่า user เป็น dict
    return user["name"]


def get_config_value(key: str) -> str:
    value = config.get(key)
    assert value is not None, f"config ขาด key: {key}"
    return value
```

**Post-condition:**

```python
def divide(a: float, b: float) -> float:
    result = a / b

    # ยืนยันผลลัพธ์
    assert result * b == a or abs(result * b - a) < 1e-9, \
        "การหารผิดพลาด"

    return result


def sort_items(items: list[int]) -> list[int]:
    result = sorted(items)

    # Post-condition
    assert len(result) == len(items), "จำนวนไม่ตรงกัน"
    assert all(result[i] <= result[i+1] for i in range(len(result)-1)), \
        "ไม่ได้เรียง"

    return result
```

**ไม่ใช้ผิด — User Input Validation:**

```python
# ❌ ผิด — ใช้ assert กับ user input
def register_user_bad(username: str, age: int) -> dict:
    assert username, "ต้องระบุ username"  # ❌ ถ้า -O จะข้าม
    assert 0 <= age <= 150, "อายุไม่ถูกต้อง"
    return {"username": username, "age": age}


# ✅ ถูก — ใช้ explicit check
def register_user_good(username: str, age: int) -> dict:
    if not username:
        raise ValueError("ต้องระบุ username")
    if not 0 <= age <= 150:
        raise ValueError(f"อายุต้องเป็น 0-150: {age}")
    return {"username": username, "age": age}
```

**Assertion ใน Tests:**

```python
def test_addition() -> None:
    assert 1 + 1 == 2
    assert add(2, 3) == 5


def test_validation() -> None:
    try:
        validate_email("invalid")
    except ValueError:
        pass
    else:
        assert False, "ควร raise ValueError"


# หรือใช้ pytest
def test_validation_pytest() -> None:
    import pytest
    with pytest.raises(ValueError):
        validate_email("invalid")
```

**Custom Assertion Message:**

```python
def calculate_discount(price: float, discount_percent: float) -> float:
    assert price > 0, f"price ต้องมากกว่า 0, ได้รับ {price}"
    assert 0 <= discount_percent <= 100, (
        f"discount ต้องเป็น 0-100, ได้รับ {discount_percent}"
    )

    return price * (1 - discount_percent / 100)
```

**ตัวอย่างการใช้งานจริง — Invariant Checking:**

```python
from dataclasses import dataclass, field


@dataclass
class BankAccount:
    owner: str
    _balance: float = 0.0
    _transactions: list = field(default_factory=list)

    def deposit(self, amount: float) -> None:
        assert amount > 0, f"amount ต้อง > 0: {amount}"
        self._balance += amount
        self._transactions.append(("deposit", amount))
        self._check_invariants()

    def withdraw(self, amount: float) -> bool:
        assert amount > 0, f"amount ต้อง > 0: {amount}"
        if amount > self._balance:
            return False
        self._balance -= amount
        self._transactions.append(("withdraw", amount))
        self._check_invariants()
        return True

    def _check_invariants(self) -> None:
        """ตรวจสอบ invariant ภายใน"""
        assert self._balance >= 0, (
            f"balance ต้องไม่ติดลบ: {self._balance}"
        )
        # ยอดคงเหลือควรเท่ากับผลรวม transactions
        computed = sum(
            amt if op == "deposit" else -amt
            for op, amt in self._transactions
        )
        assert abs(computed - self._balance) < 0.01, (
            f"balance ไม่ตรง: {self._balance} != {computed}"
        )
```

**Assertion กับ State Machine:**

```python
from enum import Enum, auto


class State(Enum):
    IDLE = auto()
    RUNNING = auto()
    DONE = auto()


class Process:
    def __init__(self) -> None:
        self.state = State.IDLE

    def start(self) -> None:
        assert self.state == State.IDLE, (
            f"ต้องอยู่ IDLE ก่อน start, ปัจจุบัน: {self.state}"
        )
        self.state = State.RUNNING

    def finish(self) -> None:
        assert self.state == State.RUNNING, (
            f"ต้องอยู่ RUNNING ก่อน finish, ปัจจุบัน: {self.state}"
        )
        self.state = State.DONE

    def reset(self) -> None:
        assert self.state == State.DONE, (
            f"ต้องอยู่ DONE ก่อน reset"
        )
        self.state = State.IDLE
```

### 7.5.4 ข้อดี

- **Simple:** syntax สั้น
- **Self-documenting:** บอก invariant
- **Debugging:** จับ bug เร็ว
- **Type narrowing:** ช่วย type checker

### 7.5.5 ข้อเสีย

- **ถูกปิดได้:** ด้วย `-O`
- **ไม่เหมาะกับ user input:** ถ้าถูกปิดจะข้าม
- **Performance:** overhead (เล็กน้อย)
- **อาจหาย:** ถ้าลืมเปิด

### 7.5.6 ข้อควรระวัง

```python
# ระวัง 1: ใช้ assert กับ user input
# ❌
def process_order(order_id: str) -> None:
    assert order_id, "ต้องระบุ order_id"  # ❌ -O จะข้าม

# ✅
def process_order_good(order_id: str) -> None:
    if not order_id:
        raise ValueError("ต้องระบุ order_id")

# ระวัง 2: assert ที่มี side effects
# ❌
assert data.pop("key") == "value"  # data เปลี่ยน!

# ✅
value = data.pop("key")
assert value == "value"

# ระวัง 3: assert กับ tuple
# ❌ tuple เป็น truthy เสมอ (ถ้าไม่ว่าง)
assert (x > 0, "x ต้องมากกว่า 0")  # ไม่ raise!

# ✅
assert x > 0, "x ต้องมากกว่า 0"

# ระวัง 4: ใช้ assert เป็น control flow
# ❌
def process(data):
    assert data, "ต้องมี data"
    return data["value"]

# ✅
def process_good(data):
    if not data:
        raise ValueError("ต้องมี data")
    return data["value"]

# ระวัง 5: assert กับ expression ที่มี side effect
# ❌
assert save_to_db(data), "save failed"  # save ถูกข้ามถ้า -O

# ✅
if not save_to_db(data):
    raise RuntimeError("save failed")

# ระวัง 6: __debug__ check
if __debug__:
    # code นี้รันเมื่อไม่ใช่ -O
    assert condition
```

### 7.5.7 สรุป

**ใช้ `assert` เมื่อ:**
- Internal invariants
- Pre/post-conditions
- Type narrowing
- Debugging
- Tests

**ไม่ใช้ `assert` เมื่อ:**
- User input validation
- Production logic
- Side effects
- Error ที่ต้องจัดการ

**Best practices:**
- ใช้กับ internal เท่านั้น
- ข้อความบอกชัดเจน
- อย่าใส่ side effects
- ใช้ `raise` สำหรับ validation
- Document invariant

> **อ้างอิงเพิ่มเติม:** [The assert statement](https://docs.python.org/3/reference/simple_stmts.html#the-assert-statement)

---

## 7.6 Logging

### บทนำ

Logging เป็นเครื่องมือสำคัญสำหรับ production applications ช่วย debug ปัญหา ติดตาม behavior และ audit อย่างเป็นระบบ ดีกว่า `print()` มาก

### นิยาม

Logging คือการบันทึก events ที่เกิดขึ้นในโปรแกรม พร้อม metadata เช่น timestamp, level, source

### 7.6.1 คืออะไร

**ทำไมไม่ใช้ `print()`:**
- `print` ไม่มี level
- ไม่มี timestamp
- ไม่สามารถปิดได้
- ไม่สามารถ redirect
- ไม่มี structured data

### 7.6.2 ทำงานอย่างไร

Python `logging` module ประกอบด้วย:
- **Logger:** entry point
- **Handler:** destination (file, console)
- **Formatter:** รูปแบบ
- **Filter:** กรอง
- **Level:** ระดับความสำคัญ

**Levels:**
```
DEBUG (10) < INFO (20) < WARNING (30) < ERROR (40) < CRITICAL (50)
```

### 7.6.3 การใช้งาน

**Logging พื้นฐาน:**

```python
import logging

# ตั้งค่าเริ่มต้น
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)

logger = logging.getLogger(__name__)

logger.debug("ข้อมูล debug")       # ไม่แสดง (level INFO)
logger.info("แอปเริ่มทำงาน")
logger.warning("คำเตือน")
logger.error("เกิดข้อผิดพลาด")
logger.critical("ร้ายแรง!")

# Output:
# 2024-01-01 12:00:00 [INFO] __main__: แอปเริ่มทำงาน
# 2024-01-01 12:00:00 [WARNING] __main__: คำเตือน
# 2024-01-01 12:00:00 [ERROR] __main__: เกิดข้อผิดพลาด
# 2024-01-01 12:00:00 [CRITICAL] __main__: ร้ายแรง!
```

**Logger Hierarchy:**

```python
# package/module.py
import logging

# ใช้ __name__ เพื่อให้ logger ตรงกับ module
logger = logging.getLogger(__name__)
# __name__ = "package.module"

# Hierarchy:
# root
# └── package
#     └── package.module
```

**Logging ไปยังไฟล์:**

```python
import logging

# สร้าง logger
logger = logging.getLogger("my_app")
logger.setLevel(logging.DEBUG)

# File handler
file_handler = logging.FileHandler("app.log", encoding="utf-8")
file_handler.setLevel(logging.DEBUG)

# Console handler
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.WARNING)

# Formatters
file_format = logging.Formatter(
    "%(asctime)s [%(levelname)s] %(name)s.%(funcName)s:%(lineno)d — %(message)s"
)
console_format = logging.Formatter("%(levelname)s: %(message)s")

file_handler.setFormatter(file_format)
console_handler.setFormatter(console_format)

# เพิ่ม handlers
logger.addHandler(file_handler)
logger.addHandler(console_handler)

# ใช้งาน
logger.debug("Debug ไปไฟล์เท่านั้น")
logger.warning("Warning ไปทั้งคู่")
logger.error("Error ไปทั้งคู่")
```

**Logging กับ Exception:**

```python
logger = logging.getLogger(__name__)


def process_data(data: dict) -> None:
    try:
        result = risky_operation(data)
    except ValueError:
        # ✅ บันทึก traceback ด้วย
        logger.exception("risky_operation failed")

        # หรือ
        logger.error("risky_operation failed", exc_info=True)

        # ❌ ไม่บันทึก traceback
        # logger.error("risky_operation failed")
```

**Logging Formatters — ข้อมูลที่ใช้ได้:**

```python
FORMAT = (
    "%(asctime)s "           # 2024-01-01 12:00:00,123
    "[%(levelname)s] "        # INFO
    "%(name)s "               # myapp.module
    "%(funcName)s "           # process_data
    "%(lineno)d "             # 42
    "%(message)s"             # ข้อความ
)

# %(created)f     — timestamp (float)
# %(process)d     — process ID
# %(processName)s — process name
# %(thread)d      — thread ID
# %(threadName)s  — thread name
# %(pathname)s    — full path
# %(filename)s    — filename
# %(module)s      — module name
```

**Logging กับ Dictionary Config:**

```python
import logging.config

LOGGING_CONFIG = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "standard": {
            "format": "%(asctime)s [%(levelname)s] %(name)s: %(message)s",
            "datefmt": "%Y-%m-%d %H:%M:%S",
        },
        "detailed": {
            "format": (
                "%(asctime)s [%(levelname)s] %(name)s "
                "%(funcName)s:%(lineno)d — %(message)s"
            ),
        },
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "level": "INFO",
            "formatter": "standard",
            "stream": "ext://sys.stdout",
        },
        "file": {
            "class": "logging.handlers.RotatingFileHandler",
            "level": "DEBUG",
            "formatter": "detailed",
            "filename": "logs/app.log",
            "maxBytes": 10 * 1024 * 1024,  # 10MB
            "backupCount": 5,
            "encoding": "utf-8",
        },
    },
    "loggers": {
        "myapp": {
            "level": "DEBUG",
            "handlers": ["console", "file"],
            "propagate": False,
        },
    },
    "root": {
        "level": "WARNING",
        "handlers": ["console"],
    },
}

logging.config.dictConfig(LOGGING_CONFIG)
logger = logging.getLogger("myapp")
logger.info("Hello")
```

**Rotating File Handler:**

```python
from logging.handlers import RotatingFileHandler, TimedRotatingFileHandler

# หมุนตามขนาด
size_handler = RotatingFileHandler(
    "app.log",
    maxBytes=10 * 1024 * 1024,  # 10MB
    backupCount=5,
    encoding="utf-8",
)

# หมุนตามเวลา
time_handler = TimedRotatingFileHandler(
    "app.log",
    when="midnight",   # หมุนทุกเที่ยงคืน
    interval=1,
    backupCount=30,    # เก็บ 30 วัน
    encoding="utf-8",
)
```

**ตัวอย่างการใช้งานจริง — Structured Logging:**

```python
import logging
import json
from typing import Any


class JSONFormatter(logging.Formatter):
    """Formatter ที่ output เป็น JSON"""

    def format(self, record: logging.LogRecord) -> str:
        log_data: dict[str, Any] = {
            "timestamp": self.formatTime(record),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
            "module": record.module,
            "function": record.funcName,
            "line": record.lineno,
        }

        # เพิ่ม exception info
        if record.exc_info:
            log_data["exception"] = self.formatException(record.exc_info)

        # เพิ่ม extra fields
        if hasattr(record, "extra_data"):
            log_data["extra"] = record.extra_data

        return json.dumps(log_data, ensure_ascii=False)


# ตั้งค่า
logger = logging.getLogger("app")
logger.setLevel(logging.INFO)

handler = logging.StreamHandler()
handler.setFormatter(JSONFormatter())
logger.addHandler(handler)

# ใช้งาน
logger.info("User logged in", extra={"extra_data": {
    "user_id": "U123",
    "ip": "192.168.1.1",
}})

# Output:
# {"timestamp": "2024-01-01 12:00:00,000", "level": "INFO",
#  "logger": "app", "message": "User logged in",
#  "extra": {"user_id": "U123", "ip": "192.168.1.1"}, ...}
```

**Context Logger:**

```python
import logging
from contextvars import ContextVar

request_id_var: ContextVar[str] = ContextVar("request_id", default="")


class ContextFilter(logging.Filter):
    """เพิ่ม request_id ในทุก log record"""

    def filter(self, record: logging.LogRecord) -> bool:
        record.request_id = request_id_var.get()
        return True


# ตั้งค่า
logger = logging.getLogger("app")
logger.addFilter(ContextFilter())

handler = logging.StreamHandler()
handler.setFormatter(logging.Formatter(
    "[%(request_id)s] %(levelname)s: %(message)s"
))
logger.addHandler(handler)

# ใช้งาน
request_id_var.set("req-abc-123")
logger.info("Processing request")
# [req-abc-123] INFO: Processing request
```

**Logger Adapter:**

```python
class UserLoggerAdapter(logging.LoggerAdapter):
    """เพิ่ม user info ในทุก log"""

    def process(self, msg, kwargs):
        user_id = self.extra.get("user_id", "anonymous")
        return f"[user={user_id}] {msg}", kwargs


base_logger = logging.getLogger(__name__)
logger = UserLoggerAdapter(base_logger, {"user_id": "U123"})

logger.info("Action performed")
# [user=U123] Action performed
```

### 7.6.4 ข้อดี

- **Levels:** กรองตามความสำคัญ
- **Structured:** เก็บ metadata
- **Configurable:** ปรับได้ runtime
- **Thread-safe:** ใช้ใน concurrent ได้
- **Standard:** เป็น standard library

### 7.6.5 ข้อเสีย

- **Setup:** ต้องตั้งค่า
- **Performance:** มี overhead
- **Complexity:** หลาย components
- **Verbose:** syntax ยาว

### 7.6.6 ข้อควรระวัง

```python
# ระวัง 1: ใช้ print แทน logging
# ❌
print(f"User {user_id} logged in")

# ✅
logger.info("User logged in", extra={"user_id": user_id})

# ระวัง 2: Log ข้อมูล sensitive
# ❌
logger.info(f"Login with password: {password}")

# ✅
logger.info("Login attempt", extra={"username": username})

# ระวัง 3: String formatting ใน log
# ❌ — format ทุกครั้ง แม้ level ไม่แสดง
logger.debug(f"Value: {expensive_computation()}")

# ✅ — lazy formatting
logger.debug("Value: %s", expensive_computation())
# แต่ยังคำนวณ expensive_computation() อยู่ดี

# ✅✅ — guard ด้วย isEnabledFor
if logger.isEnabledFor(logging.DEBUG):
    logger.debug("Value: %s", expensive_computation())

# ระวัง 4: ตั้ง level ผิด
# ❌ — root logger ตั้ง DEBUG → log เยอะ
logging.basicConfig(level=logging.DEBUG)

# ✅ — app logger DEBUG, root INFO
logging.basicConfig(level=logging.INFO)
logging.getLogger("myapp").setLevel(logging.DEBUG)

# ระวัง 5: ลืม handler → ไม่มี output
logger = logging.getLogger("myapp")
logger.setLevel(logging.INFO)
# ❌ ไม่มี handler
logger.info("test")  # ไม่แสดง

# ✅
handler = logging.StreamHandler()
logger.addHandler(handler)

# ระวัง 6: Duplicate handlers
logger = logging.getLogger("myapp")
logger.addHandler(logging.StreamHandler())
logger.addHandler(logging.StreamHandler())
# ⚠️ log 2 ครั้ง

# ✅ ตรวจก่อน หรือใช้ logging.config

# ระวัง 7: Propagate
logger = logging.getLogger("myapp.sub")
# ถ้า propagate=True (default) → log ขึ้น parent ด้วย
# อาจได้ log ซ้ำถ้าตั้ง handler ทั้ง parent และ child
```

### 7.6.7 สรุป

**Log Levels:**

| Level | ใช้เมื่อ |
|-------|---------|
| DEBUG | ข้อมูลละเอียด สำหรับ debug |
| INFO | เหตุการณ์ปกติ (start, stop, user actions) |
| WARNING | สิ่งที่อาจเป็นปัญหา |
| ERROR | ข้อผิดพลาดที่จัดการได้ |
| CRITICAL | ข้อผิดพลาดร้ายแรง |

**Best practices:**
- ใช้ `logging.getLogger(__name__)`
- ใช้ lazy formatting: `logger.info("%s", value)`
- `logger.exception()` สำหรับ exceptions
- อย่า log sensitive data
- ตั้ง level ตาม environment
- ใช้ structured logging สำหรับ production
- Rotate logs

> **อ้างอิงเพิ่มเติม:** [logging Documentation](https://docs.python.org/3/library/logging.html), [Logging HOWTO](https://docs.python.org/3/howto/logging.html), [Logging Cookbook](https://docs.python.org/3/howto/logging-cookbook.html)

---

## 7.7 logging Module

### บทนำ

`logging` module เป็น standard library ที่ให้ infrastructure สำหรับ logging ครบถ้วน เข้าใจ components และการตั้งค่าอย่างถูกต้องเป็นสิ่งจำเป็น

### นิยาม

Components หลัก:
- **Logger:** จุดเข้าใช้งาน
- **Handler:** ปลายทาง
- **Formatter:** รูปแบบ
- **Filter:** กรอง

### 7.7.1 คืออะไร

Logger ส่ง record ไปยัง handlers ที่ผูกไว้ แต่ละ handler อาจมี formatter/filter ต่างกัน

### 7.7.2 ทำงานอย่างไร

Flow:
```
logger.info(msg)
    ↓
Logger (ตรวจ level, filter)
    ↓
Handler(s) (ตรวจ level, filter)
    ↓
Formatter
    ↓
Output
```

### 7.7.3 การใช้งาน

**Components ที่สำคัญ:**

```python
import logging

# Logger
logger = logging.getLogger("myapp")

# Handler
console = logging.StreamHandler()
file_handler = logging.FileHandler("app.log")

# Formatter
formatter = logging.Formatter(
    "%(asctime)s [%(levelname)s] %(name)s: %(message)s"
)

# Filter
class OnlyErrors(logging.Filter):
    def filter(self, record):
        return record.levelno >= logging.ERROR

# ประกอบ
console.setFormatter(formatter)
file_handler.setFormatter(formatter)
file_handler.addFilter(OnlyErrors())

logger.addHandler(console)
logger.addHandler(file_handler)
logger.setLevel(logging.DEBUG)
```

**Logging ใน Library vs Application:**

```python
# ========== Library ==========
# library/module.py
import logging

logger = logging.getLogger(__name__)
# ❌ ไม่ตั้ง level/handler — ให้ app เป็นคนตั้ง
# ✅ แค่ใช้ logger

def library_function():
    logger.debug("Library function called")
    return "result"

# ========== Application ==========
# app/main.py
import logging
import library.module  # import library

# แอปตั้งค่า logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)

# ตั้ง level สำหรับ library
logging.getLogger("library.module").setLevel(logging.DEBUG)
```

**Logging Configuration ด้วย `basicConfig`:**

```python
import logging

# พื้นฐาน
logging.basicConfig(level=logging.INFO)

# กำหนด format
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)

# ไปไฟล์
logging.basicConfig(
    level=logging.DEBUG,
    filename="app.log",
    filemode="a",
    format="%(asctime)s [%(levelname)s] %(message)s",
)
```

**Logging ด้วย `fileConfig`:**

```ini
# logging.ini
[loggers]
keys=root,myapp

[handlers]
keys=console,file

[formatters]
keys=standard,detailed

[logger_root]
level=WARNING
handlers=console

[logger_myapp]
level=DEBUG
handlers=console,file
qualname=myapp
propagate=0

[handler_console]
class=StreamHandler
level=INFO
formatter=standard
args=(sys.stdout,)

[handler_file]
class=handlers.RotatingFileHandler
level=DEBUG
formatter=detailed
args=('app.log', 'a', 10485760, 5, 'utf-8')

[formatter_standard]
format=%(asctime)s [%(levelname)s] %(name)s: %(message)s
datefmt=%Y-%m-%d %H:%M:%S

[formatter_detailed]
format=%(asctime)s [%(levelname)s] %(name)s.%(funcName)s:%(lineno)d — %(message)s
```

```python
import logging.config

logging.config.fileConfig("logging.ini")
logger = logging.getLogger("myapp")
logger.info("Hello")
```

**Logging ด้วย `dictConfig` (แนะนำ):**

```python
import logging.config

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "standard": {
            "format": "%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        },
        "detailed": {
            "format": (
                "%(asctime)s [%(levelname)s] %(name)s "
                "%(funcName)s:%(lineno)d — %(message)s"
            ),
        },
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "level": "INFO",
            "formatter": "standard",
            "stream": "ext://sys.stdout",
        },
        "file": {
            "class": "logging.handlers.RotatingFileHandler",
            "level": "DEBUG",
            "formatter": "detailed",
            "filename": "logs/app.log",
            "maxBytes": 10485760,
            "backupCount": 5,
            "encoding": "utf-8",
        },
    },
    "loggers": {
        "myapp": {
            "level": "DEBUG",
            "handlers": ["console", "file"],
            "propagate": False,
        },
        "sqlalchemy": {
            "level": "WARNING",  # ลด noise
        },
    },
    "root": {
        "level": "WARNING",
        "handlers": ["console"],
    },
}

logging.config.dictConfig(LOGGING)
```

**Dynamic Configuration:**

```python
import os
import logging.config

ENV = os.getenv("APP_ENV", "development")


def get_logging_config(env: str) -> dict:
    base = {
        "version": 1,
        "disable_existing_loggers": False,
        "formatters": {
            "standard": {
                "format": "%(asctime)s [%(levelname)s] %(name)s: %(message)s",
            },
        },
        "handlers": {
            "console": {
                "class": "logging.StreamHandler",
                "formatter": "standard",
                "stream": "ext://sys.stdout",
            },
        },
        "loggers": {},
        "root": {},
    }

    if env == "production":
        base["handlers"]["console"]["level"] = "INFO"
        base["root"] = {"level": "INFO", "handlers": ["console"]}
        base["loggers"]["myapp"] = {
            "level": "INFO",
            "handlers": ["console"],
            "propagate": False,
        }
    else:  # development
        base["handlers"]["console"]["level"] = "DEBUG"
        base["root"] = {"level": "DEBUG", "handlers": ["console"]}
        base["loggers"]["myapp"] = {
            "level": "DEBUG",
            "handlers": ["console"],
            "propagate": False,
        }

    return base


logging.config.dictConfig(get_logging_config(ENV))
```

**Logger กับ `__name__`:**

```python
# app/services/user.py
import logging

logger = logging.getLogger(__name__)
# __name__ = "app.services.user"

def get_user(user_id: str) -> dict:
    logger.debug("Fetching user %s", user_id)
    try:
        user = db.query(user_id)
    except DatabaseError:
        logger.exception("Failed to fetch user %s", user_id)
        raise
    return user
```

**Logger กับ Extra Fields:**

```python
logger = logging.getLogger("app")

# ใช้ extra
logger.info(
    "Order created",
    extra={
        "order_id": "ORD-001",
        "amount": 1500.0,
        "user_id": "U123",
    },
)

# Formatter ที่ใช้ extra
formatter = logging.Formatter(
    "%(asctime)s [%(levelname)s] %(order_id)s %(user_id)s: %(message)s"
)
# Output: 2024-01-01 12:00:00 [INFO] ORD-001 U123: Order created
```

### 7.7.4 ข้อดี

- **Standard:** เป็น built-in
- **Flexible:** config ได้หลากหลาย
- **Extensible:** custom handlers/formatters
- **Thread-safe:** ใช้ใน concurrent
- **Performant:** optimize ได้

### 7.7.5 ข้อเสีย

- **Complex:** หลาย components
- **Setup:** ต้องตั้งค่า
- **Verbose:** ในโค้ด

### 7.7.6 ข้อควรระวัง

```python
# ระวัง 1: Logger Hierarchy
# ถ้า logger "a.b.c" propagate=True
# → log ไปยัง "a.b", "a", root ด้วย
# ⚠️ อาจ log ซ้ำ

# แก้: ตั้ง propagate=False ที่ logger ลูก
logger = logging.getLogger("myapp.module")
logger.propagate = False

# ระวัง 2: Handler ซ้ำ
logger = logging.getLogger("myapp")
if not logger.handlers:
    logger.addHandler(handler)
# ✅ ป้องกันซ้ำ

# ระวัง 3: Level ที่ root
# ❌ root DEBUG → log ทุกอย่าง
logging.basicConfig(level=logging.DEBUG)

# ✅ root WARNING + specific loggers
logging.basicConfig(level=logging.WARNING)
logging.getLogger("myapp").setLevel(logging.DEBUG)

# ระวัง 4: basicConfig ต้องเรียกครั้งแรกเท่านั้น
# ❌ ครั้งที่สองไม่มีผล
logging.basicConfig(level=logging.INFO)
logging.basicConfig(level=logging.DEBUG)  # ไม่มีผล

# ระวัง 5: File handler ไม่ปิด
# ใช้ with หรือ logging.shutdown()
import atexit
atexit.register(logging.shutdown)

# ระวัง 6: Encoding
# ❌ Windows default encoding อาจไม่รองรับภาษาไทย
handler = logging.FileHandler("app.log")
# ✅
handler = logging.FileHandler("app.log", encoding="utf-8")

# ระวัง 7: ใช้ logging ใน __init__.py
# ⚠️ อาจ configure ก่อนเวลา
```

### 7.7.7 สรุป

**Components:**
- Logger: entry point
- Handler: destination
- Formatter: format
- Filter: กรอง

**Best practices:**
- `logging.getLogger(__name__)`
- Library ไม่ตั้ง config
- Application ตั้ง config
- ใช้ `dictConfig` สำหรับ complex
- `propagate=False` สำหรับ custom loggers
- Encoding UTF-8 สำหรับไฟล์
- Rotating handlers สำหรับ production

> **อ้างอิงเพิ่มเติม:** [logging — Logging facility](https://docs.python.org/3/library/logging.html)

---

## 7.8 Log Level

### บทนำ

Log Level กำหนดความสำคัญของ log message ช่วยกรองข้อมูลและจัดการปริมาณ log ในแต่ละ environment ได้อย่างเหมาะสม

### นิยาม

Log Level คือระดับความสำคัญของ log message ตั้งแต่ DEBUG (ต่ำสุด) ถึง CRITICAL (สูงสุด)

### 7.8.1 คืออะไร

Python มี 5 standard levels:

| Level | ค่า | ใช้เมื่อ |
|-------|----|---------|
| DEBUG | 10 | ข้อมูลละเอียดสำหรับ debug |
| INFO | 20 | เหตุการณ์ปกติ |
| WARNING | 30 | สิ่งที่อาจเป็นปัญหา |
| ERROR | 40 | ข้อผิดพลาดที่จัดการได้ |
| CRITICAL | 50 | ข้อผิดพลาดร้ายแรง |

### 7.8.2 ทำงานอย่างไร

เมื่อเรียก `logger.info()`:
- ถ้า logger.level <= INFO (20) → ส่งต่อไป handler
- ถ้า handler.level <= INFO (20) → output

**Effective level:** ระดับที่แท้จริงของ logger (อาจ inherit จาก parent)

### 7.8.3 การใช้งาน

**Level พื้นฐาน:**

```python
import logging

logging.basicConfig(
    level=logging.DEBUG,
    format="%(levelname)s: %(message)s",
)
logger = logging.getLogger(__name__)

logger.debug("ข้อมูล debug — ใช้ตอนพัฒนา")
logger.info("แอปเริ่มทำงาน — เหตุการณ์ปกติ")
logger.warning("ดิสก์ใกล้เต็ม — ควรตรวจสอบ")
logger.error("เชื่อมต่อ DB ไม่ได้ — จัดการได้")
logger.critical("ระบบล่ม — ต้องแก้ทันที")

# Output:
# DEBUG: ข้อมูล debug — ใช้ตอนพัฒนา
# INFO: แอปเริ่มทำงาน — เหตุการณ์ปกติ
# WARNING: ดิสก์ใกล้เต็ม — ควรตรวจสอบ
# ERROR: เชื่อมต่อ DB ไม่ได้ — จัดการได้
# CRITICAL: ระบบล่ม — ต้องแก้ทันที
```

**แยกตาม Environment:**

```python
import os
import logging

ENV = os.getenv("APP_ENV", "development")

LOG_LEVELS = {
    "development": logging.DEBUG,
    "testing": logging.INFO,
    "staging": logging.INFO,
    "production": logging.WARNING,
}

level = LOG_LEVELS.get(ENV, logging.INFO)

logging.basicConfig(
    level=level,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)

logger = logging.getLogger(__name__)
logger.info(f"Log level: {logging.getLevelName(level)}")
```

**ใช้ Level ให้เหมาะสม:**

```python
import logging

logger = logging.getLogger(__name__)


def fetch_user(user_id: str) -> dict:
    # DEBUG — ข้อมูลละเอียด
    logger.debug("Fetching user: %s", user_id)

    if not user_id:
        # ERROR — input ผิด (ข้อผิดพลาด)
        logger.error("Empty user_id")
        raise ValueError("user_id ต้องไม่ว่าง")

    user = db.get(user_id)

    if user is None:
        # WARNING — ไม่พบ (ไม่ใช่ error ร้ายแรง)
        logger.warning("User not found: %s", user_id)
        return {}

    # INFO — เหตุการณ์ปกติ
    logger.info("User fetched: %s", user_id)
    return user


def process_payment(amount: float) -> None:
    if amount <= 0:
        logger.error("Invalid amount: %s", amount)
        raise ValueError("amount ต้อง > 0")

    if amount > 100000:
        # WARNING — ต้องตรวจสอบ
        logger.warning("Large payment: %s — needs review", amount)

    logger.info("Payment processed: %s", amount)
```

**Level Methods:**

```python
logger = logging.getLogger(__name__)

# ตั้ง level
logger.setLevel(logging.DEBUG)

# เช็ค level
if logger.isEnabledFor(logging.DEBUG):
    expensive = compute_expensive()
    logger.debug("Result: %s", expensive)

# รับ level ปัจจุบัน
print(logger.level)                    # 10
print(logger.getEffectiveLevel())      # 10 (อาจ inherit)

# แปลง
print(logging.getLevelName(10))        # DEBUG
print(logging.getLevelName("INFO"))    # 20
```

**Custom Levels:**

```python
import logging

# เพิ่ม custom level
TRACE = 5
logging.addLevelName(TRACE, "TRACE")


def trace(self, message, *args, **kwargs):
    if self.isEnabledFor(TRACE):
        self._log(TRACE, message, args, **kwargs)


logging.Logger.trace = trace


# ใช้งาน
logging.basicConfig(level=TRACE)
logger = logging.getLogger(__name__)
logger.trace("Very detailed info")  # TRACE: Very detailed info
```

**ตัวอย่างการใช้งานจริง — Log Level Strategy:**

```python
import logging
from enum import IntEnum


class AppLogLevel(IntEnum):
    TRACE = 5
    DEBUG = 10
    INFO = 20
    WARNING = 30
    ERROR = 40
    CRITICAL = 50
    SECURITY = 60


logging.addLevelName(AppLogLevel.TRACE, "TRACE")
logging.addLevelName(AppLogLevel.SECURITY, "SECURITY")


def setup_logging(env: str = "development") -> None:
    levels = {
        "development": AppLogLevel.DEBUG,
        "testing": AppLogLevel.INFO,
        "production": AppLogLevel.WARNING,
        "security": AppLogLevel.SECURITY,
    }

    level = levels.get(env, AppLogLevel.INFO)

    logging.basicConfig(
        level=level,
        format=(
            "%(asctime)s [%(levelname)s] "
            "%(name)s: %(message)s"
        ),
        datefmt="%Y-%m-%d %H:%M:%S",
    )


# Usage guide
"""
DEBUG: 
- ค่าตัวแปรใน algorithm
- SQL queries
- API request/response bodies
- Loop iterations

INFO:
- แอป start/stop
- User login/logout
- Order created/completed
- Configuration loaded

WARNING:
- Deprecated API usage
- Retry attempt
- Resource ใกล้หมด
- Fallback ถูกใช้

ERROR:
- Exception ที่จัดการได้
- Validation ล้มเหลว
- External service error
- File ไม่พบ

CRITICAL:
- Database ล่ม
- Disk เต็ม
- Memory หมด
- Service ล่ม

SECURITY:
- Login ล้มเหลว
- Permission denied
- Suspicious activity
- Token หมดอายุ
"""
```

### 7.8.4 ข้อดี

- **กรอง:** ลด log ที่ไม่จำเป็น
- **ยืดหยุ่น:** ปรับตาม environment
- **มาตรฐาน:** ใช้ร่วมกันทั้ง ecosystem
- **Performance:** ข้าม log ที่ไม่ต้องแสดง

### 7.8.5 ข้อเสีย

- **Subjectivity:** ตัดสินใจยาก
- **Inconsistency:** ทีมอาจใช้ไม่เหมือนกัน
- **Config:** ต้องตั้งค่าถูก

### 7.8.6 ข้อควรระวัง

```python
# ระวัง 1: ใช้ ERROR มากเกินไป
# ❌ ทุกอย่างเป็น error
logger.error("User not found")  # ควรเป็น warning
logger.error("Invalid input")    # ควรเป็น warning

# ✅ ใช้ level ให้เหมาะ
logger.warning("User not found: %s", user_id)
logger.error("Database connection failed")

# ระวัง 2: ใช้ DEBUG ใน production
# ❌
logger.debug(f"Password hash: {hash}")  # sensitive

# ✅
if logger.isEnabledFor(logging.DEBUG):
    logger.debug("Hash algorithm: %s", algo)

# ระวัง 3: Level ผิดใน library
# ❌ library ตั้ง level เอง
logging.basicConfig(level=logging.DEBUG)

# ✅ library ไม่แตะ config

# ระวัง 4: Inherit level
# ถ้า logger ลูกไม่มี level → inherit จาก parent
logger = logging.getLogger("myapp")
logger.setLevel(logging.INFO)
child = logging.getLogger("myapp.child")
# child มี effective level = INFO

# ระวัง 5: Level ที่ handler
# ทั้ง logger และ handler ต้องผ่าน
logger.setLevel(logging.DEBUG)
handler.setLevel(logging.WARNING)
# → log INFO ไม่แสดง (handler กรอง)
```

### 7.8.7 สรุป

**ใช้ Level ตาม:**

| ระดับ | ใช้เมื่อ | ตัวอย่าง |
|-------|---------|---------|
| DEBUG | พัฒนา/debug | ค่าตัวแปร, SQL |
| INFO | ปกติ | start, login |
| WARNING | ควรระวัง | retry, fallback |
| ERROR | ผิดพลาด | exception |
| CRITICAL | ร้ายแรง | service down |

**Best practices:**
- development: DEBUG
- testing/staging: INFO
- production: WARNING หรือ INFO
- Library ไม่ตั้ง config
- ใช้ `isEnabledFor` สำหรับ expensive logs
- อย่า log sensitive ที่ DEBUG

> **อ้างอิงเพิ่มเติม:** [Logging Levels](https://docs.python.org/3/library/logging.html#logging-levels)

---

## 7.9 Log Handler

### บทนำ

Handler กำหนดว่า log record จะไปที่ไหน — console, file, network, email หรืออื่น ๆ สามารถมีหลาย handlers พร้อมกันได้

### นิยาม

Handler คือ object ที่รับ log record จาก logger และส่งไปยัง destination

### 7.9.1 คืออะไร

Handlers ที่ใช้บ่อย:

| Handler | Destination |
|---------|-------------|
| `StreamHandler` | stdout/stderr |
| `FileHandler` | ไฟล์ |
| `RotatingFileHandler` | ไฟล์ + หมุนตามขนาด |
| `TimedRotatingFileHandler` | ไฟล์ + หมุนตามเวลา |
| `SysLogHandler` | Syslog |
| `SMTPHandler` | Email |
| `HTTPHandler` | HTTP endpoint |
| `QueueHandler` | Queue (async) |
| `NullHandler` | ทิ้ง |

### 7.9.2 ทำงานอย่างไร

Logger ส่ง record ไปยัง handlers ทุกตัวที่ผูกไว้ แต่ละ handler:
1. ตรวจ level
2. ตรวจ filter
3. Format record
4. ส่งไป destination

### 7.9.3 การใช้งาน

**StreamHandler:**

```python
import logging
import sys

logger = logging.getLogger("app")
logger.setLevel(logging.DEBUG)

# stdout
stdout_handler = logging.StreamHandler(sys.stdout)
stdout_handler.setLevel(logging.INFO)

# stderr
stderr_handler = logging.StreamHandler(sys.stderr)
stderr_handler.setLevel(logging.ERROR)

logger.addHandler(stdout_handler)
logger.addHandler(stderr_handler)

logger.info("Info → stdout")
logger.error("Error → stderr")
```

**FileHandler:**

```python
import logging

logger = logging.getLogger("app")
logger.setLevel(logging.DEBUG)

handler = logging.FileHandler(
    "app.log",
    mode="a",
    encoding="utf-8",
)
handler.setFormatter(logging.Formatter(
    "%(asctime)s [%(levelname)s] %(message)s"
))

logger.addHandler(handler)
logger.info("Hello")
```

**RotatingFileHandler:**

```python
from logging.handlers import RotatingFileHandler

handler = RotatingFileHandler(
    "app.log",
    maxBytes=10 * 1024 * 1024,  # 10MB
    backupCount=5,
    encoding="utf-8",
)
# เมื่อ app.log ถึง 10MB:
# app.log → app.log.1
# app.log.1 → app.log.2
# ...
# app.log.5 ถูกลบ
```

**TimedRotatingFileHandler:**

```python
from logging.handlers import TimedRotatingFileHandler

handler = TimedRotatingFileHandler(
    "app.log",
    when="midnight",    # "S", "M", "H", "D", "midnight", "W0"-"W6"
    interval=1,
    backupCount=30,
    encoding="utf-8",
    utc=True,
)
# เมื่อถึงเที่ยงคืน:
# app.log → app.log.2024-01-01
```

**QueueHandler (Async Logging):**

```python
import logging
import logging.handlers
import queue
import threading


def listener(q: queue.Queue) -> None:
    """Worker thread ที่เขียน log"""
    while True:
        record = q.get()
        if record is None:
            break
        logger = logging.getLogger(record.name)
        logger.handle(record)


# สร้าง queue และ listener
log_queue: queue.Queue = queue.Queue(-1)
queue_handler = logging.handlers.QueueHandler(log_queue)

# ตั้งค่า logger หลัก (ใน main thread)
root = logging.getLogger()
root.setLevel(logging.DEBUG)
root.addHandler(queue_handler)

# ตั้งค่า handler จริง (ใน listener thread)
file_handler = logging.FileHandler("app.log")
file_handler.setFormatter(logging.Formatter(
    "%(asctime)s [%(levelname)s] %(message)s"
))

# Start listener
q_listener = logging.handlers.QueueListener(
    log_queue,
    file_handler,
)
q_listener.start()

# ใช้งาน
logger = logging.getLogger(__name__)
for i in range(10000):
    logger.info("Message %d", i)

q_listener.stop()
```

**NullHandler (Library):**

```python
# library/__init__.py
import logging

# Library ควรมี NullHandler
# เพื่อป้องกัน "No handlers could be found"
logging.getLogger(__name__).addHandler(logging.NullHandler())
```

**Custom Handler:**

```python
import logging
from typing import Any


class SlackHandler(logging.Handler):
    """Handler ที่ส่ง log ไป Slack"""

    def __init__(self, webhook_url: str, level=logging.WARNING):
        super().__init__(level)
        self.webhook_url = webhook_url

    def emit(self, record: logging.LogRecord) -> None:
        try:
            message = self.format(record)
            # ส่งไป Slack (pseudo)
            self._send_to_slack(message)
        except Exception:
            self.handleError(record)

    def _send_to_slack(self, message: str) -> None:
        print(f"[SLACK] {message}")


# ใช้งาน
logger = logging.getLogger("app")
handler = SlackHandler("https://hooks.slack.com/...")
handler.setFormatter(logging.Formatter(
    "*%(levelname)s* [%(name)s] %(message)s"
))
logger.addHandler(handler)

logger.error("Payment failed")  # → [SLACK] *ERROR* [app] Payment failed
```

**HTTPHandler:**

```python
from logging.handlers import HTTPHandler

handler = HTTPHandler(
    host="logs.example.com",
    url="/api/logs",
    method="POST",
)

logger.addHandler(handler)
```

**SMTPHandler:**

```python
from logging.handlers import SMTPHandler

handler = SMTPHandler(
    mailhost=("smtp.example.com", 587),
    fromaddr="app@example.com",
    toaddrs=["admin@example.com"],
    subject="Application Error",
    credentials=("user", "password"),
    secure=(),
)
handler.setLevel(logging.ERROR)

logger.addHandler(handler)
```

**SysLogHandler:**

```python
from logging.handlers import SysLogHandler

handler = SysLogHandler(
    address=("localhost", 514),
    facility=SysLogHandler.LOG_DAEMON,
)

logger.addHandler(handler)
```

**ตัวอย่างการใช้งานจริง — Multi-Handler Setup:**

```python
import logging
import logging.config
import sys


def setup_logging(log_dir: str = "logs") -> None:
    """ตั้งค่า logging สำหรับ application"""
    from pathlib import Path

    Path(log_dir).mkdir(exist_ok=True)

    config = {
        "version": 1,
        "disable_existing_loggers": False,
        "formatters": {
            "simple": {
                "format": "%(levelname)s: %(message)s",
            },
            "detailed": {
                "format": (
                    "%(asctime)s [%(levelname)s] "
                    "%(name)s:%(lineno)d — %(message)s"
                ),
                "datefmt": "%Y-%m-%d %H:%M:%S",
            },
            "json": {
                "()": "pythonjsonlogger.jsonlogger.JsonFormatter",
                "format": (
                    "%(asctime)s %(levelname)s %(name)s "
                    "%(message)s %(pathname)s %(lineno)d"
                ),
            },
        },
        "handlers": {
            "console": {
                "class": "logging.StreamHandler",
                "level": "INFO",
                "formatter": "simple",
                "stream": "ext://sys.stdout",
            },
            "file_all": {
                "class": "logging.handlers.RotatingFileHandler",
                "level": "DEBUG",
                "formatter": "detailed",
                "filename": f"{log_dir}/app.log",
                "maxBytes": 10485760,
                "backupCount": 5,
                "encoding": "utf-8",
            },
            "file_error": {
                "class": "logging.handlers.RotatingFileHandler",
                "level": "ERROR",
                "formatter": "detailed",
                "filename": f"{log_dir}/error.log",
                "maxBytes": 10485760,
                "backupCount": 5,
                "encoding": "utf-8",
            },
        },
        "loggers": {
            "app": {
                "level": "DEBUG",
                "handlers": ["console", "file_all", "file_error"],
                "propagate": False,
            },
            "sqlalchemy.engine": {
                "level": "WARNING",
            },
            "urllib3": {
                "level": "WARNING",
            },
        },
        "root": {
            "level": "WARNING",
            "handlers": ["console"],
        },
    }

    logging.config.dictConfig(config)


# ใช้งาน
setup_logging()
logger = logging.getLogger("app")
logger.info("Application started")
logger.error("Something failed")
```

**Filter Handler:**

```python
import logging


class SensitiveDataFilter(logging.Filter):
    """ลบข้อมูล sensitive จาก log"""

    SENSITIVE_KEYS = {"password", "token", "secret", "api_key"}

    def filter(self, record: logging.LogRecord) -> bool:
        message = record.getMessage()

        for key in self.SENSITIVE_KEYS:
            if key in message.lower():
                record.msg = "[REDACTED]"
                record.args = ()
                break

        return True


handler = logging.StreamHandler()
handler.addFilter(SensitiveDataFilter())

logger = logging.getLogger("app")
logger.addHandler(handler)
logger.setLevel(logging.INFO)

logger.info("User password: secret123")  # [REDACTED]
```

**Handler ที่ผูกกับ Logger Hierarchy:**

```python
# ตัวอย่าง: log ไปไฟล์ต่างกันตาม module
config = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {
        "app_file": {
            "class": "logging.FileHandler",
            "filename": "logs/app.log",
            "encoding": "utf-8",
        },
        "security_file": {
            "class": "logging.FileHandler",
            "filename": "logs/security.log",
            "encoding": "utf-8",
        },
    },
    "loggers": {
        "app": {
            "handlers": ["app_file"],
            "level": "INFO",
            "propagate": False,
        },
        "app.security": {
            "handlers": ["security_file"],
            "level": "INFO",
            "propagate": False,
        },
    },
}

# log ไป app.log
logging.getLogger("app.services").info("Service started")

# log ไป security.log
logging.getLogger("app.security.auth").warning("Login failed")
```

### 7.9.4 ข้อดี

- **Flexible:** หลาย destinations
- **Composable:** ผสม handlers
- **Level ต่างกัน:** แต่ละ handler มี level
- **Custom:** สร้าง handler เองได้

### 7.9.5 ข้อเสีย

- **Setup:** ต้องตั้งค่า
- **Performance:** handlers เยอะ = ช้า
- **Complexity:** หลาย components
- **Thread-safety:** บาง handler ไม่ thread-safe

### 7.9.6 ข้อควรระวัง

```python
# ระวัง 1: Handler ซ้ำ
logger = logging.getLogger("app")
logger.addHandler(logging.StreamHandler())
logger.addHandler(logging.StreamHandler())
# ⚠️ log 2 ครั้ง

# ✅ ตรวจก่อน
if not logger.handlers:
    logger.addHandler(handler)

# ระวัง 2: File handler ไม่ปิด
handler = logging.FileHandler("app.log")
# ต้องปิดเมื่อไม่ใช้ หรือใช้ logging.shutdown()

# ระวัง 3: Encoding
# ❌ Windows default encoding
handler = logging.FileHandler("app.log")

# ✅
handler = logging.FileHandler("app.log", encoding="utf-8")

# ระวัง 4: RotatingFileHandler หลาย process
# ❌ หลาย processes เขียนไฟล์เดียว → conflict
# ✅ ใช้ TimedRotatingFileHandler หรือ log server

# ระวัง 5: Handler level กับ logger level
logger.setLevel(logging.DEBUG)
handler.setLevel(logging.WARNING)
# → log DEBUG ไม่แสดง (handler กรอง)

# ระวัง 6: propagate
logger = logging.getLogger("app.child")
logger.addHandler(handler)
# ถ้า propagate=True (default)
# → log ไป root handler ด้วย
# ⚠️ ซ้ำ

# แก้
logger.propagate = False
```

### 7.9.7 สรุป

**Handlers ที่ควรรู้:**

| Handler | ใช้เมื่อ |
|---------|---------|
| StreamHandler | Console |
| FileHandler | ไฟล์ |
| RotatingFileHandler | ไฟล์ + หมุนตามขนาด |
| TimedRotatingFileHandler | ไฟล์ + หมุนตามเวลา |
| QueueHandler | Async logging |
| NullHandler | Library |
| HTTPHandler | ส่งไป API |
| SMTPHandler | Email alerts |

**Best practices:**
- ใช้ `dictConfig` สำหรับ setup
- แยก error.log จาก app.log
- Encoding UTF-8
- ป้องกัน handler ซ้ำ
- ใช้ `propagate=False` สำหรับ custom loggers
- Rotate ไฟล์เสมอ

> **อ้างอิงเพิ่มเติม:** [logging.handlers](https://docs.python.org/3/library/logging.handlers.html)

---

## 7.10 Log Formatter

### บทนำ

Formatter กำหนดรูปแบบของ log message ช่วยให้ log อ่านง่าย มีข้อมูลที่จำเป็น และ parse ได้โดย tools

### นิยาม

Formatter คือ object ที่แปลง `LogRecord` เป็น string ตาม format string

### 7.10.1 คืออะไร

Formatter กำหนด:
- ลำดับของ fields
- รูปแบบวันที่
- Layout

### 7.10.2 ทำงานอย่างไร

เมื่อ handler ต้องการ output:
1. เรียก `formatter.format(record)`
2. Formatter แทน `%(name)s` ด้วยค่าจาก record
3. คืน string

### 7.10.3 การใช้งาน

**Format Attributes ที่ใช้ได้:**

```python
FORMAT = (
    "%(asctime)s "           # 2024-01-01 12:00:00,123
    "[%(levelname)s] "        # INFO
    "%(name)s "               # myapp.module
    "%(funcName)s:%(lineno)d " # process_data:42
    "%(message)s"             # ข้อความ
)

# Attributes เพิ่มเติม:
# %(process)d       — process ID
# %(processName)s   — process name
# %(thread)d        — thread ID
# %(threadName)s    — thread name
# %(pathname)s      — full path
# %(filename)s      — filename
# %(module)s        — module name
# %(created)f       — timestamp (float)
# %(relativeCreated)d — ms จาก start
# %(msecs)d         — milliseconds
# %(levelno)s       — level number
```

**Date Format:**

```python
formatter = logging.Formatter(
    "%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
# 2024-01-01 12:00:00 [INFO] Hello

# ISO 8601
datefmt="%Y-%m-%dT%H:%M:%S%z"
# 2024-01-01T12:00:00+0700
```

**Multiline:**

```python
formatter = logging.Formatter(
    "%(asctime)s [%(levelname)s] %(name)s\n"
    "  Function: %(funcName)s\n"
    "  Message: %(message)s",
)
```

**JSON Formatter:**

```python
import json
import logging


class JSONFormatter(logging.Formatter):
    """Formatter ที่ output เป็น JSON"""

    def format(self, record: logging.LogRecord) -> str:
        log_data = {
            "timestamp": self.formatTime(record),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
            "module": record.module,
            "function": record.funcName,
            "line": record.lineno,
            "process": record.process,
            "thread": record.thread,
        }

        # Exception
        if record.exc_info:
            log_data["exception"] = {
                "type": record.exc_info[0].__name__,
                "message": str(record.exc_info[1]),
                "traceback": self.formatException(record.exc_info),
            }

        # Extra fields
        for key, value in record.__dict__.items():
            if key not in (
                "name", "msg", "args", "levelname", "levelno",
                "pathname", "filename", "module", "exc_info",
                "exc_text", "stack_info", "lineno", "funcName",
                "created", "msecs", "relativeCreated", "thread",
                "threadName", "processName", "process", "message",
            ):
                log_data[key] = value

        return json.dumps(log_data, ensure_ascii=False, default=str)


# ใช้งาน
logger = logging.getLogger("app")
logger.setLevel(logging.INFO)

handler = logging.StreamHandler()
handler.setFormatter(JSONFormatter())
logger.addHandler(handler)

logger.info("User logged in", extra={"user_id": "U123"})
# {"timestamp": "...", "level": "INFO", "logger": "app",
#  "message": "User logged in", "user_id": "U123", ...}
```

**ใช้ `python-json-logger`:**

```bash
pip install python-json-logger
```

```python
import logging
from pythonjsonlogger import jsonlogger

logger = logging.getLogger("app")
logger.setLevel(logging.INFO)

handler = logging.StreamHandler()
formatter = jsonlogger.JsonFormatter(
    "%(asctime)s %(levelname)s %(name)s %(message)s",
    timestamp=True,
)
handler.setFormatter(formatter)
logger.addHandler(handler)

logger.info("Hello", extra={"user_id": "U123"})
```

**Structured Logging Format:**

```python
class KeyValueFormatter(logging.Formatter):
    """Formatter แบบ key=value — ง่ายต่อ parsing"""

    def format(self, record: logging.LogRecord) -> str:
        base = (
            f"time={self.formatTime(record)} "
            f"level={record.levelname} "
            f"logger={record.name} "
            f"msg={json.dumps(record.getMessage())}"
        )

        # Extra fields
        extras = []
        for key, value in record.__dict__.items():
            if key not in (
                "name", "msg", "args", "levelname", "levelno",
                "pathname", "filename", "module", "exc_info",
                "exc_text", "stack_info", "lineno", "funcName",
                "created", "msecs", "relativeCreated", "thread",
                "threadName", "processName", "process", "message",
            ):
                extras.append(f"{key}={value}")

        if extras:
            base += " " + " ".join(extras)

        if record.exc_info:
            base += "\n" + self.formatException(record.exc_info)

        return base
```

**Custom Formatter:**

```python
class ColoredFormatter(logging.Formatter):
    """Formatter พร้อมสีสำหรับ console"""

    COLORS = {
        "DEBUG": "\033[36m",     # Cyan
        "INFO": "\033[32m",      # Green
        "WARNING": "\033[33m",   # Yellow
        "ERROR": "\033[31m",     # Red
        "CRITICAL": "\033[1;31m", # Bold Red
    }
    RESET = "\033[0m"

    def format(self, record: logging.LogRecord) -> str:
        color = self.COLORS.get(record.levelname, "")
        message = super().format(record)
        return f"{color}{message}{self.RESET}"


# ใช้งาน
handler = logging.StreamHandler()
handler.setFormatter(ColoredFormatter(
    "%(asctime)s [%(levelname)s] %(name)s: %(message)s"
))
```

**ตัวอย่างการใช้งานจริง — Environment-based Formatter:**

```python
import json
import logging
import os


class DevFormatter(logging.Formatter):
    """Colorful formatter สำหรับ development"""

    COLORS = {
        "DEBUG": "\033[36m",
        "INFO": "\033[32m",
        "WARNING": "\033[33m",
        "ERROR": "\033[31m",
        "CRITICAL": "\033[1;31m",
    }
    RESET = "\033[0m"

    def format(self, record):
        color = self.COLORS.get(record.levelname, "")
        record.levelname = f"{color}{record.levelname}{self.RESET}"
        return super().format(record)


class ProdFormatter(logging.Formatter):
    """JSON formatter สำหรับ production"""

    def format(self, record):
        data = {
            "ts": self.formatTime(record),
            "level": record.levelname,
            "logger": record.name,
            "msg": record.getMessage(),
        }
        if record.exc_info:
            data["exc"] = self.formatException(record.exc_info)
        return json.dumps(data, ensure_ascii=False)


def setup_logging() -> None:
    env = os.getenv("APP_ENV", "development")

    formatter = (
        DevFormatter(
            "%(asctime)s [%(levelname)s] %(name)s: %(message)s",
            datefmt="%H:%M:%S",
        )
        if env == "development"
        else ProdFormatter()
    )

    handler = logging.StreamHandler()
    handler.setFormatter(formatter)

    root = logging.getLogger()
    root.setLevel(logging.INFO)
    root.addHandler(handler)
```

### 7.10.4 ข้อดี

- **Consistent:** รูปแบบเดียวกัน
- **Parseable:** สำหรับ log tools
- **Informative:** ข้อมูลครบ
- **Customizable:** ปรับได้

### 7.10.5 ข้อเสีย

- **Setup:** ต้องตั้งค่า
- **Performance:** formatting มี overhead
- **Verbose:** format ยาว

### 7.10.6 ข้อควรระวัง

```python
# ระวัง 1: Format string ผิด
# ❌ KeyError
formatter = logging.Formatter("%(invalid)s")

# ✅ ตรวจสอบ attributes
formatter = logging.Formatter("%(levelname)s: %(message)s")

# ระวัง 2: Exception ใน format
class BadFormatter(logging.Formatter):
    def format(self, record):
        return 1 / 0  # ❌

# ระวัง 3: Performance
# ❌ format ทุกครั้ง แม้ไม่แสดง
if logger.isEnabledFor(logging.DEBUG):
    logger.debug("Data: %s", big_data)

# ระวัง 4: Extra fields ที่ไม่มี
# ❌ KeyError ถ้า extra ไม่มี
formatter = logging.Formatter("%(user_id)s: %(message)s")
logger.info("test")  # KeyError: user_id

# ✅ ใช้ default
class SafeFormatter(logging.Formatter):
    def format(self, record):
        if not hasattr(record, "user_id"):
            record.user_id = "N/A"
        return super().format(record)

# ระวัง 5: Date format ผิด
# ❌
formatter = logging.Formatter(
    "%(asctime)s %(message)s",
    datefmt="%Q",  # ไม่ valid
)

# ระวัง 6: Unicode
# ✅ ใช้ ensure_ascii=False ใน json
json.dumps(data, ensure_ascii=False)
```

### 7.10.7 สรุป

**Formatter ใช้เมื่อ:**
- Development: human-readable + colors
- Production: JSON สำหรับ log aggregation
- File: detailed with timestamps
- Console: simple

**Attributes ที่ใช้บ่อย:**
- `%(asctime)s` — timestamp
- `%(levelname)s` — level
- `%(name)s` — logger name
- `%(funcName)s` — function
- `%(lineno)d` — line number
- `%(message)s` — message

**Best practices:**
- Development: colored, simple
- Production: JSON, structured
- ระวัง performance
- ใช้ `datefmt` สำหรับวันที่
- ใช้ `ensure_ascii=False` สำหรับ JSON

> **อ้างอิงเพิ่มเติม:** [LogRecord attributes](https://docs.python.org/3/library/logging.html#logrecord-attributes)

---

## 7.11 Structlog

### บทนำ

`structlog` เป็น third-party library ที่ให้ structured logging ที่สะอาดและยืดหยุ่นกว่า `logging` มาตรฐาน เหมาะกับ production และ microservices

### นิยาม

Structlog คือ logging library ที่เน้น structured data (key-value) แทน string formatting

### 7.11.1 คืออะไร

ข้อดี:
- Structured data
- Context binding
- Processors pipeline
- Async support
- Better testing

### 7.11.2 ทำงานอย่างไร

```python
logger.info("event", key=value)
    ↓
Processors (transform, filter, enrich)
    ↓
Renderer (JSON, console, key-value)
    ↓
Output
```

### 7.11.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install structlog
```

**พื้นฐาน:**

```python
import structlog

logger = structlog.get_logger()

logger.info("user_logged_in", user_id="U123", ip="192.168.1.1")
# 2024-01-01 12:00:00 [info     ] user_logged_in user_id=U123 ip=192.168.1.1

logger.error("payment_failed", order_id="ORD-001", amount=1500)
# 2024-01-01 12:00:00 [error    ] payment_failed order_id=ORD-001 amount=1500
```

**Configuration:**

```python
import structlog
import logging

structlog.configure(
    processors=[
        structlog.contextvars.merge_contextvars,
        structlog.processors.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.JSONRenderer(ensure_ascii=False),
    ],
    wrapper_class=structlog.make_filtering_bound_logger(logging.INFO),
    context_class=dict,
    logger_factory=structlog.PrintLoggerFactory(),
    cache_logger_on_first_use=True,
)

logger = structlog.get_logger()
logger.info("hello", user="สมชาย")
# {"event": "hello", "user": "สมชาย", "level": "info",
#  "timestamp": "2024-01-01T12:00:00Z"}
```

**Context Binding:**

```python
import structlog

logger = structlog.get_logger()

# Bind context
log = logger.bind(user_id="U123", request_id="req-abc")
log.info("processing")
# user_id=U123 request_id=req-abc event=processing

log.info("completed")
# user_id=U123 request_id=req-abc event=completed

# Unbind
log2 = log.unbind("user_id")
log2.info("test")
# request_id=req-abc event=test
```

**Context Variables (Async):**

```python
import structlog
from structlog.contextvars import (
    bind_contextvars,
    clear_contextvars,
)

logger = structlog.get_logger()

async def handle_request(request_id: str, user_id: str):
    clear_contextvars()
    bind_contextvars(request_id=request_id, user_id=user_id)

    logger.info("request_started")
    # request_id=req-abc user_id=U123 event=request_started

    await process()

    logger.info("request_completed")
    # request_id=req-abc user_id=U123 event=request_completed
```

**Processors:**

```python
import structlog

def add_app_info(logger, method_name, event_dict):
    """เพิ่ม app info ในทุก log"""
    event_dict["app"] = "myapp"
    event_dict["version"] = "1.0.0"
    return event_dict


def censor_password(logger, method_name, event_dict):
    """ลบ password จาก log"""
    if "password" in event_dict:
        event_dict["password"] = "***"
    return event_dict


structlog.configure(
    processors=[
        add_app_info,
        censor_password,
        structlog.processors.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.dev.ConsoleRenderer(colors=True),
    ],
)

logger = structlog.get_logger()
logger.info("login", user="somchai", password="secret123")
# app=myapp version=1.0.0 user=somchai password=*** level=info ...
```

**Exception Handling:**

```python
import structlog

logger = structlog.get_logger()

try:
    result = 1 / 0
except ZeroDivisionError:
    logger.exception("calculation_failed", operation="division")
    # รวม traceback อัตโนมัติ
```

**Testing:**

```python
import structlog
from structlog.testing import capture_logs

with capture_logs() as captured:
    logger.info("test_event", key="value")

print(captured)
# [{"event": "test_event", "key": "value", "log_level": "info"}]
```

**ตัวอย่างการใช้งานจริง — Web Application:**

```python
import structlog
import logging
import sys
from structlog.contextvars import bind_contextvars, clear_contextvars


def configure_logging(env: str = "development") -> None:
    """ตั้งค่า structlog ตาม environment"""
    shared_processors = [
        structlog.contextvars.merge_contextvars,
        structlog.processors.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
    ]

    if env == "production":
        processors = shared_processors + [
            structlog.processors.JSONRenderer(ensure_ascii=False),
        ]
    else:
        processors = shared_processors + [
            structlog.dev.ConsoleRenderer(colors=True),
        ]

    structlog.configure(
        processors=processors,
        wrapper_class=structlog.make_filtering_bound_logger(
            logging.INFO if env == "production" else logging.DEBUG
        ),
        logger_factory=structlog.PrintLoggerFactory(),
        cache_logger_on_first_use=True,
    )

    # เชื่อมกับ standard logging
    logging.basicConfig(
        format="%(message)s",
        stream=sys.stdout,
        level=logging.INFO,
    )


# ใช้งาน
configure_logging()
logger = structlog.get_logger()


class RequestHandler:
    def __init__(self) -> None:
        self.logger = logger

    async def handle(self, request: dict) -> dict:
        clear_contextvars()
        bind_contextvars(
            request_id=request.get("id"),
            user_id=request.get("user_id"),
            path=request.get("path"),
        )

        self.logger.info("request_received")

        try:
            result = await self.process(request)
        except Exception:
            self.logger.exception("request_failed")
            raise
        else:
            self.logger.info("request_completed", status="success")
            return result

    async def process(self, request: dict) -> dict:
        self.logger.debug("processing_request")
        return {"status": "ok"}
```

**ตัวอย่าง — Microservice Logging:**

```python
import structlog
import logging
import time
from contextlib import contextmanager

structlog.configure(
    processors=[
        structlog.contextvars.merge_contextvars,
        structlog.processors.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.format_exc_info,
        structlog.processors.JSONRenderer(ensure_ascii=False),
    ],
    wrapper_class=structlog.make_filtering_bound_logger(logging.INFO),
)

logger = structlog.get_logger()


@contextmanager
def log_operation(operation: str, **context):
    """Context manager สำหรับ log operation"""
    log = logger.bind(operation=operation, **context)
    start = time.perf_counter()

    log.info("operation_started")

    try:
        yield log
    except Exception as e:
        log.exception("operation_failed",
                     duration_ms=(time.perf_counter() - start) * 1000)
        raise
    else:
        log.info("operation_completed",
                duration_ms=(time.perf_counter() - start) * 1000)


# ใช้งาน
def process_order(order_id: str) -> dict:
    with log_operation("process_order", order_id=order_id) as log:
        log.debug("validating_order")
        validate(order_id)

        log.debug("charging_payment")
        charge(order_id)

        log.info("order_processed")
        return {"status": "ok"}
```

### 7.11.4 ข้อดี

- **Structured:** Key-value data
- **Context:** bind/unbind
- **Processors:** ยืดหยุ่น
- **Testable:** capture_logs
- **Async:** contextvars support

### 7.11.5 ข้อเสีย

- **Third-party:** ต้องติดตั้ง
- **Learning curve:** concepts ใหม่
- **Overhead:** processors pipeline

### 7.11.6 ข้อควรระวัง

```python
# ระวัง 1: Configuration ก่อนใช้
# ❌ ไม่ configure
import structlog
logger = structlog.get_logger()
logger.info("test")  # ใช้ default

# ✅ configure ก่อน
structlog.configure(...)

# ระวัง 2: Context ไม่ clear
# ❌ context leak ระหว่าง requests
bind_contextvars(request_id="123")
# ... ทำงาน
# ลืม clear

# ✅
clear_contextvars()

# ระวัง 3: Sensitive data
# ❌
logger.info("login", password=password)

# ✅
logger.info("login", user=user)  # ไม่ log password

# ระวัง 4: Performance
# ❌
logger.debug("data", big=expensive_computation())

# ✅
if logger.isEnabledFor(logging.DEBUG):
    logger.debug("data", big=expensive_computation())

# ระวัง 5: Exception ใน processor
def bad_processor(logger, method_name, event_dict):
    return 1 / 0  # ❌ หยุด logging

# ✅ ใช้ try/except
def safe_processor(logger, method_name, event_dict):
    try:
        event_dict["extra"] = compute()
    except Exception:
        event_dict["extra_error"] = True
    return event_dict
```

### 7.11.7 สรุป

**ใช้ structlog เมื่อ:**
- ต้องการ structured logging
- Microservices
- Production systems
- ต้อง parse logs
- Context propagation

**Features:**
- `bind()` / `unbind()` — context
- `bind_contextvars()` — async context
- Processors — pipeline
- `capture_logs()` — testing
- Renderers — JSON, console

**Best practices:**
- Configure ที่ entry point
- ใช้ contextvars สำหรับ async
- Clear context หลัง request
- Processors เล็ก ๆ
- Test ด้วย capture_logs

> **อ้างอิงเพิ่มเติม:** [structlog Documentation](https://www.structlog.org/)

---

## 7.12 Loguru

### บทนำ

`loguru` เป็น logging library ที่เน้นความง่าย — ใช้งานได้ทันทีโดยไม่ต้องตั้งค่า เหมาะกับ scripts และ applications ที่ต้องการ logging เร็ว ๆ

### นิยาม

Loguru คือ logging library ที่รวมทุกอย่างไว้ใน `logger` object เดียว

### 7.12.1 คืออะไร

ข้อเด่น:
- ใช้ได้ทันที
- Syntax สวยงาม
- Built-in features (rotation, retention)
- Exception formatting
- ไม่ต้อง config

### 7.12.2 ทำงานอย่างไร

Loguru มี `logger` singleton ที่พร้อมใช้:
- มี handler เริ่มต้น (stderr)
- Format สวยงาม
- Colors
- Rotation built-in

### 7.12.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install loguru
```

**พื้นฐาน:**

```python
from loguru import logger

logger.debug("ข้อมูล debug")
logger.info("แอปเริ่มทำงาน")
logger.warning("คำเตือน")
logger.error("เกิดข้อผิดพลาด")
logger.critical("ร้ายแรง")

# Output สวยงามพร้อมสี:
# 2024-01-01 12:00:00.000 | INFO     | __main__:<module>:5 - แอปเริ่มทำงาน
```

**Format:**

```python
from loguru import logger
import sys

# ลบ default handler
logger.remove()

# เพิ่ม handler พร้อม format
logger.add(
    sys.stderr,
    format=(
        "<green>{time:YYYY-MM-DD HH:mm:ss}</green> | "
        "<level>{level: <8}</level> | "
        "<cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> | "
        "<level>{message}</level>"
    ),
    level="DEBUG",
    colorize=True,
)

logger.info("Hello")
```

**ไปไฟล์:**

```python
from loguru import logger

logger.add(
    "logs/app.log",
    rotation="10 MB",        # หมุนที่ 10MB
    retention="30 days",     # เก็บ 30 วัน
    compression="zip",       # บีบอัด
    encoding="utf-8",
    format="{time} | {level} | {message}",
    level="INFO",
)

logger.info("Hello")
```

**Rotation Options:**

```python
# ตามขนาด
logger.add("app.log", rotation="100 MB")

# ตามเวลา
logger.add("app.log", rotation="00:00")   # ทุกเที่ยงคืน
logger.add("app.log", rotation="1 week")   # ทุกสัปดาห์
logger.add("app.log", rotation="12:00")    # ทุกเที่ยง

# ตามจำนวน
logger.add("app.log", rotation=lambda msg, _: "ERROR" in msg)
```

**Retention:**

```python
logger.add(
    "app.log",
    rotation="10 MB",
    retention=5,                  # เก็บ 5 ไฟล์
    # หรือ
    # retention="30 days",         # เก็บ 30 วัน
    # retention="10:00",           # เก็บ 10 ชั่วโมง
)
```

**Context Binding:**

```python
from loguru import logger

# bind
log = logger.bind(user_id="U123", request_id="req-abc")
log.info("processing")
# 2024-01-01 12:00:00 | INFO | processing (user_id=U123 request_id=req-abc)

# contextualize
with logger.contextualize(task_id="T-001"):
    logger.info("inside context")  # มี task_id
logger.info("outside")  # ไม่มี

# patch
log = logger.patch(lambda record: record["extra"].update(app="myapp"))
```

**Catch Decorator:**

```python
from loguru import logger


@logger.catch
def risky_operation():
    return 1 / 0


risky_operation()
# บันทึก exception พร้อม traceback อัตโนมัติ
```

**Async:**

```python
from loguru import logger
import asyncio


async def async_work():
    logger.info("Starting")
    await asyncio.sleep(1)
    logger.info("Done")


# loguru รองรับ async โดยอัตโนมัติ
asyncio.run(async_work())
```

**Structured Logging:**

```python
from loguru import logger
import json

# ใช้ serialize=True สำหรับ JSON
logger.add(
    "logs/app.json",
    serialize=True,  # JSON output
)

logger.info("event", user_id="U123", action="login")

# {"text": "...", "record": {
#     "message": "event",
#     "extra": {"user_id": "U123", "action": "login"},
#     ...
# }}
```

**ตัวอย่างการใช้งานจริง — CLI Application:**

```python
from loguru import logger
import sys
from pathlib import Path


def setup_logging(
    log_dir: str = "logs",
    verbose: bool = False,
) -> None:
    """ตั้งค่า loguru"""
    logger.remove()  # ลบ default

    # Console
    logger.add(
        sys.stderr,
        level="DEBUG" if verbose else "INFO",
        format=(
            "<green>{time:HH:mm:ss}</green> | "
            "<level>{level: <8}</level> | "
            "<level>{message}</level>"
        ),
        colorize=True,
    )

    # File
    Path(log_dir).mkdir(exist_ok=True)
    logger.add(
        f"{log_dir}/app.log",
        rotation="10 MB",
        retention="7 days",
        compression="gz",
        encoding="utf-8",
        level="DEBUG",
        format=(
            "{time:YYYY-MM-DD HH:mm:ss.SSS} | "
            "{level: <8} | "
            "{name}:{function}:{line} | "
            "{message}"
        ),
    )

    # Error file
    logger.add(
        f"{log_dir}/error.log",
        rotation="10 MB",
        retention="30 days",
        level="ERROR",
        encoding="utf-8",
        backtrace=True,     # full traceback
        diagnose=True,      # ตัวแปรใน traceback
    )


# ใช้งาน
setup_logging(verbose=True)
logger.info("Application started")
logger.debug("Debug info")
logger.error("Something failed")
```

**ตัวอย่าง — Web Application:**

```python
from loguru import logger
from contextvars import ContextVar

request_id_ctx: ContextVar[str] = ContextVar("request_id", default="")


def request_id_patcher(record):
    """เพิ่ม request_id ในทุก log"""
    record["extra"]["request_id"] = request_id_ctx.get() or "N/A"


logger = logger.patch(request_id_patcher)

# ตั้งค่า
logger.remove()
logger.add(
    sys.stdout,
    format=(
        "{time:YYYY-MM-DD HH:mm:ss} | {level} | "
        "[{extra[request_id]}] {message}"
    ),
)


async def handle_request(request_id: str):
    request_id_ctx.set(request_id)
    logger.info("Request received")
    # [req-123] Request received

    await process()
    logger.info("Request completed")
    # [req-123] Request completed
```

**ตัวอย่าง — Data Pipeline:**

```python
from loguru import logger
from dataclasses import dataclass


@dataclass
class PipelineContext:
    pipeline_name: str
    run_id: str


def setup_pipeline_logging(ctx: PipelineContext) -> None:
    logger.remove()

    logger.add(
        f"logs/{ctx.pipeline_name}_{ctx.run_id}.log",
        format=(
            "{time:YYYY-MM-DD HH:mm:ss} | "
            "{level: <8} | "
            "{message}"
        ),
        level="DEBUG",
        enqueue=True,  # thread-safe
    )

    logger.add(
        sys.stderr,
        level="INFO",
        format="<level>{level}: {message}</level>",
        colorize=True,
    )


def process_step(step_name: str, data: list) -> list:
    log = logger.bind(step=step_name)

    log.info(f"Starting step with {len(data)} items")

    try:
        result = transform(data)
    except Exception:
        log.exception(f"Step failed")
        raise
    else:
        log.info(f"Step completed: {len(result)} items")
        return result


# ใช้งาน
ctx = PipelineContext("etl_users", "run-001")
setup_pipeline_logging(ctx)

logger.info("Pipeline started")
data = process_step("extract", [1, 2, 3])
data = process_step("transform", data)
logger.info("Pipeline completed")
```

### 7.12.4 ข้อดี

- **Easy:** ใช้ได้ทันที
- **Beautiful:** output สวย
- **Feature-rich:** rotation, retention, compression
- **Async:** built-in
- **Exception:** formatting ดี

### 7.12.5 ข้อเสีย

- **Third-party:** เพิ่ม dependency
- **Performance:** อาจช้ากว่า logging
- **Integration:** กับ stdlib logging ต้องตั้งค่า
- **Singleton:** logger global

### 7.12.6 ข้อควรระวัง

```python
# ระวัง 1: Default handler
# ❌ มี handler default อยู่แล้ว
logger.info("test")  # ใช้ stderr

# ✅ ลบก่อนถ้าต้องการ custom
logger.remove()
logger.add(...)

# ระวัง 2: Encoding
logger.add("app.log", encoding="utf-8")  # ✅

# ระวัง 3: Log ซ้ำ
logger.add("app.log")
logger.add("app.log")  # ❌ log 2 ครั้ง

# ระวัง 4: Performance
# ❌ expensive computation
logger.debug(f"Data: {expensive()}")

# ✅ ใช้ lazy
logger.opt(lazy=True).debug("Data: {}", expensive)

# ระวัง 5: Enqueue สำหรับ multi-process
# ถ้าใช้ multiprocessing
logger.add("app.log", enqueue=True)  # ✅

# ระวัง 6: Retention ไม่ตั้ง
# ❌ ไฟล์จะโตเรื่อย ๆ
logger.add("app.log")

# ✅
logger.add("app.log", rotation="10 MB", retention="7 days")
```

### 7.12.7 สรุป

**ใช้ loguru เมื่อ:**
- ต้องการ setup เร็ว
- Scripts / CLI
- ไม่ต้องการ config เยอะ
- ชอบ output สวย

**Features:**
- `logger.add()` — เพิ่ม handler
- `logger.remove()` — ลบ handler
- `logger.bind()` — context
- `logger.contextualize()` — temporary context
- `@logger.catch` — exception handling
- `rotation`, `retention`, `compression`

**Best practices:**
- Remove default handler
- ตั้ง rotation + retention
- Encoding UTF-8
- `enqueue=True` สำหรับ multi-thread/process
- ใช้ `opt(lazy=True)` สำหรับ expensive

> **อ้างอิงเพิ่มเติม:** [Loguru Documentation](https://loguru.readthedocs.io/)

---

## 7.13 Error Tracking

### บทนำ

Error Tracking คือการเก็บ รวบรวม และวิเคราะห์ errors ที่เกิดขึ้นใน production ช่วยให้ทีมรู้ปัญหาและแก้ไขได้รวดเร็ว

### นิยาม

Error Tracking System คือระบบที่รับ errors จาก application, จัดกลุ่ม, แจ้งเตือน และให้ข้อมูลสำหรับ debug

### 7.13.1 คืออะไร

**ประโยชน์:**
- รู้ปัญหาใน production
- จัดกลุ่ม errors ที่คล้ายกัน
- แจ้งเตือนทันที
- ติดตาม trends
- ข้อมูลสำหรับ debug (stack trace, context)

**Tools ยอดนิยม:**
- Sentry
- Rollbar
- Bugsnag
- Airbrake
- Raygun

### 7.13.2 ทำงานอย่างไร

Flow:
1. Application ส่ง error ไปยัง tracking service
2. Service จัดกลุ่มตาม fingerprint
3. แจ้งเตือน (email, Slack)
4. Dashboard แสดงข้อมูล

### 7.13.3 การใช้งาน

**Sentry (ยอดนิยมที่สุด):**

ติดตั้ง:
```bash
pip install sentry-sdk
```

**พื้นฐาน:**

```python
import sentry_sdk

sentry_sdk.init(
    dsn="https://your-key@sentry.io/project-id",
    traces_sample_rate=1.0,  # 100% สำหรับ performance
    environment="production",
    release="myapp@1.0.0",
)

# errors จะถูกส่งอัตโนมัติ
def divide(a, b):
    return a / b

divide(1, 0)  # ส่ง ZeroDivisionError ไป Sentry
```

**กับ Integrations:**

```python
import sentry_sdk
from sentry_sdk.integrations.django import DjangoIntegration
from sentry_sdk.integrations.logging import LoggingIntegration
from sentry_sdk.integrations.redis import RedisIntegration
from sentry_sdk.integrations.sqlalchemy import SqlalchemyIntegration

sentry_sdk.init(
    dsn="https://...",
    integrations=[
        DjangoIntegration(),
        LoggingIntegration(level=logging.INFO, event_level=logging.ERROR),
        RedisIntegration(),
        SqlalchemyIntegration(),
    ],
    traces_sample_rate=0.1,  # 10% performance
    profiles_sample_rate=0.1,
    environment="production",
    release="myapp@1.0.0",
)
```

**Manual Capture:**

```python
import sentry_sdk

# Capture exception
try:
    risky_operation()
except Exception as e:
    sentry_sdk.capture_exception(e)
    # จัดการต่อ

# Capture message
sentry_sdk.capture_message("Something important", level="warning")
```

**Context:**

```python
import sentry_sdk

# User context
sentry_sdk.set_user({
    "id": "U123",
    "email": "user@example.com",
    "username": "somchai",
})

# Tags
sentry_sdk.set_tag("environment", "production")
sentry_sdk.set_tag("version", "1.0.0")

# Extra data
sentry_sdk.set_extra("order_id", "ORD-001")
sentry_sdk.set_extra("items_count", 5)

# Context
sentry_sdk.set_context("order", {
    "id": "ORD-001",
    "total": 1500.0,
    "status": "pending",
})
```

**Breadcrumbs:**

```python
import sentry_sdk

# Breadcrumbs — เหตุการณ์ก่อน error
sentry_sdk.add_breadcrumb(
    category="auth",
    message="User logged in",
    level="info",
)

# Automatic breadcrumbs (จาก integration)
# - HTTP requests
# - Database queries
# - Log messages
```

**Scopes:**

```python
import sentry_sdk

# ใช้ scope
with sentry_sdk.configure_scope() as scope:
    scope.set_tag("component", "payment")
    scope.set_extra("amount", 1500)
    sentry_sdk.capture_exception(error)
# scope กลับเป็นเดิม
```

**ตัวอย่างการใช้งานจริง — FastAPI:**

```python
import sentry_sdk
from sentry_sdk.integrations.fastapi import FastApiIntegration
from sentry_sdk.integrations.starlette import StarletteIntegration
from fastapi import FastAPI, HTTPException

sentry_sdk.init(
    dsn="https://...",
    integrations=[
        StarletteIntegration(),
        FastApiIntegration(),
    ],
    traces_sample_rate=0.1,
    environment="production",
    release="api@1.0.0",
    attach_stacktrace=True,
    send_default_pii=False,  # ไม่ส่ง PII
)

app = FastAPI()


@app.get("/users/{user_id}")
async def get_user(user_id: str):
    # ตั้ง user context
    sentry_sdk.set_user({"id": user_id})

    user = await fetch_user(user_id)
    if not user:
        sentry_sdk.capture_message(
            f"User not found: {user_id}",
            level="warning",
        )
        raise HTTPException(404, "User not found")

    return user


@app.post("/orders")
async def create_order(order: dict):
    with sentry_sdk.configure_scope() as scope:
        scope.set_tag("order_type", order.get("type"))
        scope.set_extra("order_data", order)

        try:
            result = await process_order(order)
        except Exception as e:
            scope.set_context("order", order)
            sentry_sdk.capture_exception(e)
            raise HTTPException(500, "Order failed")

        return result
```

**ตัวอย่าง — Celery:**

```python
import sentry_sdk
from sentry_sdk.integrations.celery import CeleryIntegration

sentry_sdk.init(
    dsn="https://...",
    integrations=[CeleryIntegration()],
)

# errors ใน tasks จะถูกส่งอัตโนมัติ
```

**Custom Error Tracking:**

```python
import logging
import traceback
from typing import Any
from datetime import datetime
from collections import defaultdict


class ErrorTracker:
    """Simple error tracker"""

    def __init__(self) -> None:
        self._errors: dict[str, list[dict]] = defaultdict(list)
        self._logger = logging.getLogger(__name__)

    def capture(
        self,
        error: Exception,
        context: dict[str, Any] | None = None,
    ) -> str:
        """บันทึก error และ return fingerprint"""
        fingerprint = self._fingerprint(error)
        entry = {
            "type": type(error).__name__,
            "message": str(error),
            "traceback": traceback.format_exc(),
            "context": context or {},
            "timestamp": datetime.now().isoformat(),
        }

        self._errors[fingerprint].append(entry)
        self._logger.error(
            f"Error captured: {fingerprint}",
            extra={"context": context},
        )

        # แจ้งเตือนถ้า error ซ้ำ
        if len(self._errors[fingerprint]) > 5:
            self._alert(fingerprint, entry)

        return fingerprint

    def _fingerprint(self, error: Exception) -> str:
        """สร้าง fingerprint จาก type + traceback"""
        tb = traceback.extract_tb(error.__traceback__)
        if tb:
            last = tb[-1]
            return f"{type(error).__name__}:{last.filename}:{last.lineno}"
        return f"{type(error).__name__}:unknown"

    def _alert(self, fingerprint: str, entry: dict) -> None:
        count = len(self._errors[fingerprint])
        self._logger.warning(
            f"Repeated error {fingerprint} ({count} times)",
        )

    def stats(self) -> dict[str, int]:
        return {k: len(v) for k, v in self._errors.items()}


# ใช้งาน
tracker = ErrorTracker()

try:
    risky_operation()
except Exception as e:
    fingerprint = tracker.capture(e, context={"user_id": "U123"})
    print(f"Tracked: {fingerprint}")

print(tracker.stats())
```

### 7.13.4 ข้อดี

- **Visibility:** รู้ปัญหา production
- **Grouping:** จัดกลุ่มอัตโนมัติ
- **Alerting:** แจ้งเตือนทันที
- **Context:** ข้อมูล debug ครบ
- **Trends:** เห็นแนวโน้ม

### 7.13.5 ข้อเสีย

- **Cost:** services มีค่าใช้จ่าย
- **Privacy:** ส่งข้อมูลออก
- **Setup:** ต้องตั้งค่า
- **Performance:** overhead เล็กน้อย
- **Noise:** alerts เยอะเกิน

### 7.13.6 ข้อควรระวัง

```python
# ระวัง 1: ส่ง PII
# ❌
sentry_sdk.set_user({"email": user.email, "password": password})

# ✅
sentry_sdk.set_user({"id": user.id})
sentry_sdk.init(send_default_pii=False)

# ระวัง 2: Sample rate สูงเกินไป
# ❌ 100% ในระบบใหญ่
sentry_sdk.init(traces_sample_rate=1.0)

# ✅
sentry_sdk.init(traces_sample_rate=0.1)

# ระวัง 3: ไม่ตั้ง release
# ❌ ไม่รู้ version
sentry_sdk.init(dsn="...")

# ✅
sentry_sdk.init(dsn="...", release="myapp@1.0.0")

# ระวัง 4: Environment
# ❌ ใช้ production ใน dev
sentry_sdk.init(environment="production")

# ✅
import os
sentry_sdk.init(environment=os.getenv("APP_ENV", "development"))

# ระวัง 5: Alert fatigue
# ตั้ง alert rules ให้เหมาะสม
```

### 7.13.7 สรุป

**Error Tracking ใช้เมื่อ:**
- Production applications
- ต้องการ visibility
- ทีมต้องแจ้งเตือน
- ต้อง debug ปัญหา

**Best practices:**
- ตั้ง `release` และ `environment`
- ไม่ส่ง PII
- Sample rate เหมาะสม
- ตั้ง alerts ฉลาด
- ใช้ context (user, tags, extra)
- Breadcrumbs สำหรับ debug

> **อ้างอิงเพิ่มเติม:** [Sentry Python SDK](https://docs.sentry.io/platforms/python/)

---

## 7.14 Sentry

### บทนำ

Sentry เป็น error tracking platform ที่นิยมที่สุด ให้ข้อมูลเชิงลึกสำหรับ debug ปัญหาใน production

### นิยาม

Sentry คือ platform ที่รับ, จัดกลุ่ม, แจ้งเตือน และวิเคราะห์ errors จาก applications

### 7.14.1 คืออะไร

**Features:**
- Error tracking
- Performance monitoring
- Session replay
- Alerts
- Release tracking
- Issue grouping

### 7.14.2 ทำงานอย่างไร

1. SDK ใน app ส่ง error
2. Sentry server จัดกลุ่ม (fingerprint)
3. แจ้งเตือน
4. Dashboard แสดง

### 7.14.3 การใช้งาน

**Setup:**

```bash
pip install --upgrade sentry-sdk
```

**Configuration:**

```python
import sentry_sdk
import os

sentry_sdk.init(
    dsn=os.getenv("SENTRY_DSN"),
    environment=os.getenv("APP_ENV", "development"),
    release=os.getenv("APP_VERSION", "dev"),
    traces_sample_rate=0.1,
    profiles_sample_rate=0.1,
    send_default_pii=False,
    attach_stacktrace=True,
    max_breadcrumbs=50,
    debug=False,
    before_send=lambda event, hint: event,  # filter
)
```

**Filtering Events:**

```python
import sentry_sdk
from typing import Any


def before_send(event: dict, hint: dict) -> dict | None:
    """Filter events ก่อนส่ง"""
    # ไม่ส่ง 404
    if event.get("exception"):
        exc_values = event["exception"].get("values", [])
        for exc in exc_values:
            if exc.get("type") == "HTTPException":
                if "404" in str(exc.get("value", "")):
                    return None

    # ลบ sensitive data
    if "request" in event:
        headers = event["request"].get("headers", {})
        headers.pop("Authorization", None)
        headers.pop("Cookie", None)

    return event


sentry_sdk.init(
    dsn="...",
    before_send=before_send,
)
```

**Filtering Breadcrumbs:**

```python
def before_breadcrumb(crumb: dict, hint: dict) -> dict | None:
    """กรอง breadcrumbs"""
    # ไม่เก็บ console logs
    if crumb.get("category") == "console":
        return None

    # ลบ sensitive URLs
    if "data" in crumb:
        url = crumb["data"].get("url", "")
        if "password" in url:
            crumb["data"]["url"] = "[FILTERED]"

    return crumb


sentry_sdk.init(
    dsn="...",
    before_breadcrumb=before_breadcrumb,
)
```

**Performance Monitoring:**

```python
import sentry_sdk
from sentry_sdk import start_transaction, start_span

sentry_sdk.init(
    dsn="...",
    traces_sample_rate=0.1,  # 10% transactions
)


def process_order(order_id: str) -> dict:
    with sentry_sdk.start_transaction(
        op="task",
        name="process_order",
    ) as transaction:
        transaction.set_tag("order_id", order_id)

        with sentry_sdk.start_span(op="db", description="fetch_order"):
            order = db.get(order_id)

        with sentry_sdk.start_span(op="http", description="charge_payment"):
            charge(order)

        transaction.set_data("order_total", order.total)
        return order
```

**Release Tracking:**

```python
# ใช้ commit hash เป็น release
import subprocess

release = subprocess.check_output(
    ["git", "rev-parse", "--short", "HEAD"]
).decode().strip()

sentry_sdk.init(
    dsn="...",
    release=f"myapp@{release}",
    # หรือ
    # release=os.getenv("GIT_SHA"),
)
```

**Source Maps / Debug Info:**

```python
# ส่ง source code context
sentry_sdk.init(
    dsn="...",
    include_source_context=True,
    include_local_variables=True,  # ระวัง PII
)
```

**Sampling:**

```python
import sentry_sdk
from sentry_sdk.types import SamplingContext


def traces_sampler(sampling_context: SamplingContext) -> float:
    """กำหนด sample rate ตาม context"""
    # transaction ที่สำคัญ sample 100%
    transaction = sampling_context.get("transaction_context", {})
    op = transaction.get("op", "")

    if op == "http.server":
        # HTTP requests → 10%
        return 0.1
    elif op == "task":
        # Background tasks → 50%
        return 0.5
    else:
        # อื่น ๆ → 1%
        return 0.01


sentry_sdk.init(
    dsn="...",
    traces_sampler=traces_sampler,
)
```

**Custom Fingerprint:**

```python
import sentry_sdk

with sentry_sdk.configure_scope() as scope:
    # จัดกลุ่มตาม custom criteria
    scope.fingerprint = ["{{ default }}", "order_processing"]
    sentry_sdk.capture_exception(error)
```

**ตัวอย่างการใช้งานจริง — FastAPI + Sentry:**

```python
import sentry_sdk
from sentry_sdk.integrations.fastapi import FastApiIntegration
from sentry_sdk.integrations.starlette import StarletteIntegration
from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse

sentry_sdk.init(
    dsn="https://...",
    integrations=[
        StarletteIntegration(
            transaction_style="endpoint",
        ),
        FastApiIntegration(),
    ],
    traces_sample_rate=0.1,
    profiles_sample_rate=0.1,
    environment="production",
    release="api@1.0.0",
    send_default_pii=False,
    before_send=lambda event, hint: (
        None if _is_health_check(event) else event
    ),
)

app = FastAPI()


def _is_health_check(event: dict) -> bool:
    request = event.get("request", {})
    return request.get("url", "").endswith("/health")


@app.exception_handler(HTTPException)
async def http_exception_handler(
    request: Request,
    exc: HTTPException,
) -> JSONResponse:
    # 4xx ไม่ต้องส่ง Sentry
    if 400 <= exc.status_code < 500:
        return JSONResponse(
            status_code=exc.status_code,
            content={"detail": exc.detail},
        )

    # 5xx → Sentry
    sentry_sdk.capture_exception(exc)
    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": "Internal error"},
    )


@app.middleware("http")
async def sentry_context_middleware(request: Request, call_next):
    """เพิ่ม context ให้ Sentry"""
    with sentry_sdk.configure_scope() as scope:
        scope.set_tag("endpoint", request.url.path)
        scope.set_tag("method", request.method)

        # User context (ถ้ามี)
        user_id = request.headers.get("X-User-Id")
        if user_id:
            sentry_sdk.set_user({"id": user_id})

        response = await call_next(request)
        scope.set_tag("status_code", response.status_code)
        return response


@app.get("/users/{user_id}")
async def get_user(user_id: str):
    with sentry_sdk.start_transaction(
        op="db.query",
        name="fetch_user",
    ):
        user = await fetch_user(user_id)

    if not user:
        sentry_sdk.capture_message(
            f"User not found: {user_id}",
            level="warning",
        )
        raise HTTPException(404, "User not found")

    return user
```

**ตัวอย่าง — Error Grouping:**

```python
import sentry_sdk
from sentry_sdk import set_tag, set_context, set_user


class OrderError(Exception):
    def __init__(self, order_id: str, reason: str):
        self.order_id = order_id
        self.reason = reason
        super().__init__(f"Order {order_id} failed: {reason}")


def process_order(order: dict, user: dict) -> dict:
    set_user({
        "id": user["id"],
        "segment": user.get("segment"),
    })
    set_tag("order_type", order.get("type", "standard"))
    set_context("order", {
        "id": order["id"],
        "total": order["total"],
        "items": len(order["items"]),
    })

    try:
        validate(order)
        charge(order)
        fulfill(order)
    except PaymentError as e:
        with sentry_sdk.configure_scope() as scope:
            scope.fingerprint = ["payment_error", e.code]
            scope.set_tag("payment_provider", e.provider)
            sentry_sdk.capture_exception(e)
        raise
    except Exception as e:
        sentry_sdk.capture_exception(e)
        raise

    return {"status": "success"}
```

### 7.14.4 ข้อดี

- **Comprehensive:** error + performance
- **Integrations:** frameworks มากมาย
- **Grouping:** อัจฉริยะ
- **Context:** ข้อมูลครบ
- **Alerts:** ยืดหยุ่น

### 7.14.5 ข้อเสีย

- **Cost:** paid plans
- **Privacy:** ส่งข้อมูลออก
- **Setup:** ต้องตั้งค่า
- **Overhead:** เล็กน้อย

### 7.14.6 ข้อควรระวัง

```python
# ระวัง 1: ไม่ตั้ง sample rate
# ❌
sentry_sdk.init(dsn="...")  # traces 100%

# ✅
sentry_sdk.init(dsn="...", traces_sample_rate=0.1)

# ระวัง 2: ส่ง PII
# ✅
sentry_sdk.init(send_default_pii=False)

# ระวัง 3: Error ซ้ำ
# ใช้ before_send filter
def before_send(event, hint):
    if event.get("logger") == "urllib3":
        return None
    return event

# ระวัง 4: Release ไม่ตั้ง
# ทำให้ track regression ยาก

# ระวัง 5: Alert fatigue
# ตั้ง alert rules แยกตาม severity

# ระวัง 6: Performance ใน high-traffic
# sample rate ต่ำ + before_send filter

# ระวัง 7: ไม่ปิดใน tests
import os
if os.getenv("APP_ENV") == "test":
    sentry_sdk.init(dsn="")  # disable
```

### 7.14.7 สรุป

**Sentry ใช้เมื่อ:**
- Production apps
- ต้องการ error visibility
- Performance monitoring
- ต้อง alert ทีม

**Setup:**
```python
sentry_sdk.init(
    dsn="...",
    environment="production",
    release="app@1.0.0",
    traces_sample_rate=0.1,
    send_default_pii=False,
)
```

**Best practices:**
- ตั้ง environment + release
- ไม่ส่ง PII
- Sample rate เหมาะสม
- before_send filter
- Context ครบ (user, tags, extra)
- แยก alert rules
- Disable ใน tests

> **อ้างอิงเพิ่มเติม:** [Sentry Documentation](https://docs.sentry.io/)

---

## 7.15 การออกแบบข้อความ Error ที่ดี

### บทนำ

ข้อความ error ที่ดีช่วยให้ debug เร็ว เข้าใจปัญหา และแก้ไขได้ตรงจุด เป็นส่วนสำคัญของ UX สำหรับ developers

### นิยาม

Error message ที่ดีคือข้อความที่บอก **อะไรผิด**, **ทำไม**, และ **ทำอย่างไรต่อ**

### 7.15.1 คืออะไร

**หลัก 3 ข้อ:**
1. **What:** เกิดอะไรขึ้น
2. **Why:** ทำไม (ถ้ารู้)
3. **How:** แก้อย่างไร (ถ้าเป็นไปได้)

### 7.15.2 ทำงานอย่างไร

Error message ที่ดี:
- Specific ไม่กำกวม
- มี context (ค่า, ตำแหน่ง)
- Actionable (บอกทางแก้)
- ไม่ blame ผู้ใช้
- ปลอดภัย (ไม่ leak sensitive)

### 7.15.3 การใช้งาน

**หลักการ:**

```python
# ❌ แย่ — กำกวม ไม่มี context
raise ValueError("Invalid input")

# ✅ ดี — specific + context
raise ValueError(
    f"age ต้องเป็นจำนวนเต็ม 0-150, ได้รับ: {age!r} (type: {type(age).__name__})"
)

# ❌ แย่ — ไม่บอกว่าแก้อะไร
raise KeyError("key not found")

# ✅ ดี — บอก key
raise KeyError(
    f"ไม่พบ key 'user_id' ใน config "
    f"(keys ที่มี: {list(config.keys())})"
)

# ❌ แย่ — blame ผู้ใช้
raise ValueError("คุณใส่ข้อมูลผิด")

# ✅ ดี — บอกปัญหา
raise ValueError(
    "อีเมลต้องมี @ เช่น user@example.com"
)
```

**Validation Error:**

```python
from dataclasses import dataclass, field
from typing import Any


@dataclass
class ValidationError:
    field: str
    value: Any
    message: str
    expected: str = ""

    def __str__(self) -> str:
        parts = [
            f"field '{self.field}'",
            f"ค่า {self.value!r}",
            self.message,
        ]
        if self.expected:
            parts.append(f"(คาดหวัง: {self.expected})")
        return " — ".join(parts)


def validate_age(age: Any) -> int:
    if not isinstance(age, int):
        raise ValidationError(
            field="age",
            value=age,
            message="ต้องเป็นจำนวนเต็ม",
            expected="int",
        )
    if not 0 <= age <= 150:
        raise ValidationError(
            field="age",
            value=age,
            message="ต้องอยู่ระหว่าง 0-150",
        )
    return age


# ใช้งาน
try:
    validate_age("abc")
except ValidationError as e:
    print(e)
    # field 'age' — ค่า 'abc' ต้องเป็นจำนวนเต็ม (คาดหวัง: int)
```

**HTTP Error:**

```python
# ❌ แย่
raise HTTPException(404, "Not found")

# ✅ ดี
raise HTTPException(
    status_code=404,
    detail={
        "code": "USER_NOT_FOUND",
        "message": "ไม่พบผู้ใช้",
        "details": {
            "user_id": user_id,
        },
        "hint": "ตรวจสอบ user_id หรือสมัครสมาชิกใหม่",
    },
)
```

**File Error:**

```python
from pathlib import Path

# ❌ แย่
raise FileNotFoundError("File not found")

# ✅ ดี
def load_config(path: Path) -> dict:
    if not path.exists():
        # บอก path จริง + suggestion
        parent = path.parent
        similar = []
        if parent.exists():
            similar = [
                str(p.name)
                for p in parent.iterdir()
                if p.suffix == path.suffix
            ][:5]

        message = f"ไม่พบไฟล์ config: {path.resolve()}"
        if similar:
            message += f"\nไฟล์ที่คล้ายกัน: {', '.join(similar)}"

        raise FileNotFoundError(message)

    with path.open(encoding="utf-8") as f:
        import json
        return json.load(f)
```

**Database Error:**

```python
# ❌ แย่
raise RuntimeError("Query failed")

# ✅ ดี
def find_user(user_id: str) -> dict | None:
    try:
        result = db.execute(
            "SELECT * FROM users WHERE id = %s",
            (user_id,),
        )
    except DatabaseError as e:
        raise RuntimeError(
            f"ค้นหาผู้ใช้ไม่สำเร็จ (user_id={user_id!r})"
        ) from e
    return result[0] if result else None
```

**API Client Error:**

```python
import httpx


# ❌ แย่
raise APIError("Request failed")

# ✅ ดี
def call_api(url: str, payload: dict) -> dict:
    try:
        response = httpx.post(url, json=payload, timeout=30)
    except httpx.TimeoutException as e:
        raise APIError(
            f"API timeout หลังจาก 30s (url={url})"
        ) from e
    except httpx.RequestError as e:
        raise APIError(
            f"เชื่อมต่อ API ไม่ได้ (url={url}, error={e})"
        ) from e

    if response.status_code >= 400:
        raise APIError(
            f"API ตอบกลับ {response.status_code} "
            f"(url={url}, body={response.text[:200]!r})"
        )

    return response.json()
```

**Pattern: Error Message Builder:**

```python
from typing import Any


class ErrorMessage:
    """Builder สำหรับ error message ที่ดี"""

    def __init__(self, problem: str):
        self._problem = problem
        self._details: dict[str, Any] = {}
        self._hint: str = ""
        self._example: str = ""

    def with_detail(self, key: str, value: Any) -> "ErrorMessage":
        self._details[key] = value
        return self

    def with_hint(self, hint: str) -> "ErrorMessage":
        self._hint = hint
        return self

    def with_example(self, example: str) -> "ErrorMessage":
        self._example = example
        return self

    def __str__(self) -> str:
        parts = [self._problem]

        if self._details:
            details = ", ".join(
                f"{k}={v!r}" for k, v in self._details.items()
            )
            parts.append(f"({details})")

        if self._hint:
            parts.append(f"\nคำแนะนำ: {self._hint}")

        if self._example:
            parts.append(f"\nตัวอย่าง: {self._example}")

        return " ".join(parts[:2]) + "".join(parts[2:])


# ใช้งาน
def validate_email(email: str) -> str:
    import re

    if not email:
        raise ValueError(str(
            ErrorMessage("อีเมลต้องไม่ว่าง")
            .with_hint("ระบุอีเมล เช่น user@example.com")
            .with_example("somchai@email.com")
        ))

    if not re.match(r"^[\w.+-]+@[\w-]+\.[\w.]+$", email):
        raise ValueError(str(
            ErrorMessage("รูปแบบอีเมลไม่ถูกต้อง")
            .with_detail("email", email)
            .with_detail("expected", "user@domain.com")
            .with_hint("ตรวจสอบว่าไม่มีช่องว่างและมี @")
        ))

    return email.lower()


# ใช้งาน
try:
    validate_email("invalid-email")
except ValueError as e:
    print(e)
```

**ตัวอย่างการใช้งานจริง — Configuration Errors:**

```python
import os
from typing import Any


class ConfigError(Exception):
    """Configuration error พร้อม context"""

    def __init__(
        self,
        key: str,
        value: Any,
        problem: str,
        hint: str = "",
        expected: str = "",
    ):
        self.key = key
        self.value = value
        self.problem = problem
        self.hint = hint
        self.expected = expected

        message = f"Config '{key}' ไม่ถูกต้อง: {problem}"
        if expected:
            message += f" (คาดหวัง: {expected})"
        message += f"\n  ค่าที่ได้รับ: {value!r}"
        if hint:
            message += f"\n  คำแนะนำ: {hint}"

        super().__init__(message)


def load_config() -> dict[str, Any]:
    config: dict[str, Any] = {}

    # PORT
    port_str = os.getenv("APP_PORT", "8000")
    try:
        port = int(port_str)
    except ValueError:
        raise ConfigError(
            key="APP_PORT",
            value=port_str,
            problem="ต้องเป็นตัวเลข",
            expected="integer 1-65535",
            hint="ตัวอย่าง: APP_PORT=8000",
        )

    if not 1 <= port <= 65535:
        raise ConfigError(
            key="APP_PORT",
            value=port,
            problem="อยู่นอกช่วงที่ถูกต้อง",
            expected="1-65535",
            hint="พอร์ตทั่วไป: 3000, 8000, 8080",
        )
    config["port"] = port

    # DATABASE_URL
    db_url = os.getenv("DATABASE_URL", "")
    if not db_url:
        raise ConfigError(
            key="DATABASE_URL",
            value=db_url,
            problem="ต้องระบุ",
            hint=(
                "ตั้งค่า DATABASE_URL ใน environment\n"
                "  ตัวอย่าง: postgresql://user:pass@localhost:5432/db"
            ),
        )
    config["database_url"] = db_url

    return config


# ใช้งาน
try:
    config = load_config()
except ConfigError as e:
    print(f"ตั้งค่าไม่ถูกต้อง:\n{e}")
    raise SystemExit(1)
```

**ตัวอย่าง — User-Facing Error:**

```python
class UserFacingError(Exception):
    """Error ที่แสดงให้ผู้ใช้ — ไม่มี technical details"""

    def __init__(
        self,
        message: str,
        code: str,
        action: str = "",
    ):
        self.code = code
        self.action = action
        super().__init__(message)


def transfer_money(
    from_account: str,
    to_account: str,
    amount: float,
) -> None:
    if amount <= 0:
        raise UserFacingError(
            message="จำนวนเงินต้องมากกว่า 0",
            code="INVALID_AMOUNT",
            action="กรุณาระบุจำนวนเงินที่มากกว่า 0",
        )

    balance = get_balance(from_account)
    if amount > balance:
        raise UserFacingError(
            message=f"ยอดเงินไม่เพียงพอ (คงเหลือ ฿{balance:,.2f})",
            code="INSUFFICIENT_FUNDS",
            action="กรุณาเติมเงินหรือโอนจำนวนน้อยลง",
        )

    if from_account == to_account:
        raise UserFacingError(
            message="ไม่สามารถโอนเข้าบัญชีตัวเองได้",
            code="SAME_ACCOUNT",
            action="กรุณาระบุบัญชีปลายทางอื่น",
        )

    # ... โอนเงิน


# API handler
def handle_error(e: UserFacingError) -> dict:
    return {
        "error": {
            "code": e.code,
            "message": str(e),
            "action": e.action,
        }
    }
```

### 7.15.4 ข้อดี

- **Debug เร็ว:** เข้าใจปัญหาทันที
- **UX ดี:** ผู้ใช้รู้ว่าต้องทำอะไร
- **Support:** ลด tickets
- **Documentation:** บอกวิธีใช้
- **Professional:** ดูมืออาชีพ

### 7.15.5 ข้อเสีย

- **Effort:** ต้องคิด
- **Verbose:** ข้อความยาว
- **Maintenance:** ต้อง update

### 7.15.6 ข้อควรระวัง

```python
# ระวัง 1: Leak sensitive data
# ❌
raise ValueError(f"Invalid password: {password}")

# ✅
raise ValueError("รหัสผ่านไม่ถูกต้อง")

# ระวัง 2: Blame ผู้ใช้
# ❌
raise ValueError("คุณทำผิด")

# ✅
raise ValueError("รูปแบบอีเมลไม่ถูกต้อง")

# ระวัง 3: ไม่มี context
# ❌
raise ValueError("Invalid")

# ✅
raise ValueError(f"amount ต้อง > 0, ได้รับ: {amount}")

# ระวัง 4: Technical jargon กับ end users
# ❌ สำหรับ user
raise ValueError("NullPointerException in field")

# ✅
raise ValueError("กรุณากรอกชื่อ")

# ระวัง 5: Error ที่ไม่ actionable
# ❌
raise RuntimeError("Something went wrong")

# ✅
raise RuntimeError(
    "เชื่อมต่อ database ไม่ได้ "
    "(host=db.example.com, timeout=30s) "
    "— ตรวจสอบ network หรือ database server"
)

# ระวัง 6: ข้อความไม่สอดคล้อง
# ❌
raise ValueError("Invalid email")
raise ValueError("email ไม่ถูกต้อง")

# ✅ เลือกภาษาเดียว
raise ValueError("รูปแบบอีเมลไม่ถูกต้อง")

# ระวัง 7: ยาวเกินไป
# ❌
raise ValueError(
    "ในกรณีที่คุณต้องการสมัครสมาชิก "
    "คุณจำเป็นต้องกรอกอีเมลที่ถูกต้อง "
    "ซึ่งประกอบด้วย username และ domain "
    "โดยมี @ คั่นกลาง..."
)

# ✅ กระชับ
raise ValueError(
    "อีเมลต้องอยู่ในรูปแบบ user@domain.com"
)
```

### 7.15.7 สรุป

**Error Message ที่ดี:**
- **Specific:** บอกชัดว่าอะไรผิด
- **Context:** มีค่า, ตำแหน่ง
- **Actionable:** บอกทางแก้
- **Safe:** ไม่ leak sensitive
- **Consistent:** ภาษาเดียวกัน
- **Concise:** กระชับ

**Template:**
```
[What] เกิดอะไรขึ้น (field, value)
[Why] ทำไม (expected, constraint)
[How] แก้อย่างไร (hint, example)
```

**Best practices:**
- ระบุ field + value
- บอก expected format
- ให้ example
- ใช้ `repr()` สำหรับค่า
- ไม่ blame ผู้ใช้
- แยก user-facing vs developer-facing
- Test error messages

> **อ้างอิงเพิ่มเติม:** [Writing Good Error Messages](https://www.nngroup.com/articles/error-message-guidelines/)

---

## สรุปภาค 7

ภาค 7 ครอบคลุมการจัดการข้อผิดพลาดและการบันทึก:

**Exception:**
- Exception hierarchy
- try/except/else/finally
- raise และ chaining
- Custom exceptions
- Assertion

**Logging:**
- logging module
- Log levels
- Handlers
- Formatters
- Structlog
- Loguru

**Error Tracking:**
- Error tracking concepts
- Sentry
- Good error messages

**ก้าวต่อไป:** ภาค 8 จะเข้าสู่ไฟล์ การจัดเก็บ และรูปแบบข้อมูล

---

# ภาค 8: ไฟล์ การจัดเก็บ และรูปแบบข้อมูล

## 8.1 File I/O

### บทนำ

การอ่านและเขียนไฟล์เป็นงานพื้นฐานที่สุดในโปรแกรมมิ่ง Python มี built-in support ที่สะดวกและปลอดภัย

### นิยาม

File I/O คือการอ่านข้อมูลจากไฟล์และการเขียนข้อมูลลงไฟล์

### 8.1.1 คืออะไร

Python ใช้ `open()` สร้าง file object ซึ่งมี methods:
- `read()`, `readline()`, `readlines()` — อ่าน
- `write()`, `writelines()` — เขียน
- `seek()`, `tell()` — ตำแหน่ง
- `close()` — ปิด

### 8.1.2 ทำงานอย่างไร

`open()` รับ parameters:
- `file` — path
- `mode` — `r`, `w`, `a`, `x`, `b`, `t`, `+`
- `encoding` — สำหรับ text mode
- `errors` — จัดการ encoding errors

### 8.1.3 การใช้งาน

**Modes:**

```python
# r — อ่าน (default)
with open("file.txt", "r", encoding="utf-8") as f:
    content = f.read()

# w — เขียน (ทับ)
with open("file.txt", "w", encoding="utf-8") as f:
    f.write("Hello")

# a — เขียนต่อท้าย
with open("file.txt", "a", encoding="utf-8") as f:
    f.write("World\n")

# x — สร้างใหม่ (error ถ้ามีอยู่)
try:
    with open("new.txt", "x", encoding="utf-8") as f:
        f.write("New file")
except FileExistsError:
    print("ไฟล์มีอยู่แล้ว")

# b — binary
with open("image.png", "rb") as f:
    data = f.read()

# t — text (default)
with open("file.txt", "rt", encoding="utf-8") as f:
    content = f.read()

# + — read + write
with open("file.txt", "r+", encoding="utf-8") as f:
    content = f.read()
    f.seek(0)
    f.write("New")
```

**อ่านไฟล์:**

```python
# อ่านทั้งหมด
with open("file.txt", encoding="utf-8") as f:
    content = f.read()
    print(content)

# อ่านทีละบรรทัด
with open("file.txt", encoding="utf-8") as f:
    for line in f:
        print(line.rstrip())

# อ่านด้วย readline
with open("file.txt", encoding="utf-8") as f:
    while line := f.readline():
        print(line.rstrip())

# อ่านทั้งหมดเป็น list
with open("file.txt", encoding="utf-8") as f:
    lines = f.readlines()

# อ่านบางส่วน
with open("file.txt", encoding="utf-8") as f:
    chunk = f.read(1024)  # 1024 chars
```

**เขียนไฟล์:**

```python
# เขียน string
with open("output.txt", "w", encoding="utf-8") as f:
    f.write("Hello\n")
    f.write("World\n")

# เขียนหลายบรรทัด
lines = ["Line 1\n", "Line 2\n", "Line 3\n"]
with open("output.txt", "w", encoding="utf-8") as f:
    f.writelines(lines)

# print() ไปไฟล์
with open("output.txt", "w", encoding="utf-8") as f:
    print("Hello", file=f)
    print("World", file=f)

# Binary write
data = b"\x00\x01\x02\x03"
with open("output.bin", "wb") as f:
    f.write(data)
```

**File Object Methods:**

```python
with open("file.txt", "r+", encoding="utf-8") as f:
    # ตำแหน่งปัจจุบัน
    pos = f.tell()          # 0
    print(pos)

    # อ่าน 5 chars
    content = f.read(5)
    print(f.tell())         # 5

    # ไปตำแหน่ง
    f.seek(0)
    print(f.read(5))

    # ไปท้ายไฟล์
    f.seek(0, 2)            # whence=2 → จากท้าย
    size = f.tell()

    # ไปต้นไฟล์
    f.seek(0)

    # flush buffer
    f.flush()

    # ตรวจสอบ
    print(f.closed)         # False
    print(f.readable())     # True
    print(f.writable())     # True
    print(f.seekable())     # True
    print(f.name)           # file.txt
    print(f.mode)           # r+

# หลังปิด
print(f.closed)             # True
```

**Why `with`:**

```python
# ❌ ไม่ใช้ with — ลืมปิดได้
f = open("file.txt", encoding="utf-8")
try:
    content = f.read()
finally:
    f.close()

# ✅ ใช้ with — ปิดอัตโนมัติ
with open("file.txt", encoding="utf-8") as f:
    content = f.read()
# f.close() เรียกอัตโนมัติ แม้ exception
```

**หลายไฟล์พร้อมกัน:**

```python
with (
    open("input.txt", encoding="utf-8") as fin,
    open("output.txt", "w", encoding="utf-8") as fout,
):
    for line in fin:
        fout.write(line.upper())
```

**การอ่านไฟล์ขนาดใหญ่:**

```python
# ✅ วนซ้ำทีละบรรทัด — ประหยัด memory
def count_lines(path: str) -> int:
    with open(path, encoding="utf-8") as f:
        return sum(1 for _ in f)


# ✅ อ่านเป็น chunks
def read_in_chunks(path: str, chunk_size: int = 8192):
    with open(path, encoding="utf-8") as f:
        while chunk := f.read(chunk_size):
            yield chunk


# ❌ อ่านทั้งหมด — กิน memory
def bad_read(path: str) -> str:
    with open(path, encoding="utf-8") as f:
        return f.read()  # ไฟล์ 1GB → RAM 1GB
```

**ตัวอย่างการใช้งานจริง — Log Processor:**

```python
from pathlib import Path
from collections import Counter
from typing import Iterator
import re


LOG_PATTERN = re.compile(
    r'(?P<ip>\d+\.\d+\.\d+\.\d+).*?"(?P<method>\w+)\s+(?P<path>\S+)'
)


def process_log(path: Path) -> dict:
    """ประมวลผล log file ขนาดใหญ่"""
    ip_counts: Counter[str] = Counter()
    path_counts: Counter[str] = Counter()
    method_counts: Counter[str] = Counter()

    with path.open(encoding="utf-8") as f:
        for line in f:
            match = LOG_PATTERN.search(line)
            if not match:
                continue
            ip_counts[match["ip"]] += 1
            path_counts[match["path"]] += 1
            method_counts[match["method"]] += 1

    return {
        "total": sum(ip_counts.values()),
        "top_ips": ip_counts.most_common(10),
        "top_paths": path_counts.most_common(10),
        "methods": dict(method_counts),
    }
```

**ตัวอย่าง — File Copy:**

```python
def copy_file(src: str, dst: str, buffer_size: int = 8192) -> None:
    """คัดลอกไฟล์แบบ streaming — รองรับไฟล์ใหญ่"""
    with (
        open(src, "rb") as fin,
        open(dst, "wb") as fout,
    ):
        while chunk := fin.read(buffer_size):
            fout.write(chunk)


def copy_text_file(src: str, dst: str) -> None:
    """คัดลอกไฟล์ text — บรรทัดต่อบรรทัด"""
    with (
        open(src, encoding="utf-8") as fin,
        open(dst, "w", encoding="utf-8") as fout,
    ):
        for line in fin:
            fout.write(line)
```

### 8.1.4 ข้อดี

- **Built-in:** ไม่ต้อง library
- **Simple:** API ง่าย
- **Efficient:** buffered I/O
- **Flexible:** modes ครบ

### 8.1.5 ข้อเสีย

- **Manual:** ต้องจัดการ encoding, newline
- **Platform differences:** newline ต่างกัน
- **Error prone:** ลืม close, จัดการ exception

### 8.1.6 ข้อควรระวัง

```python
# ระวัง 1: ลืม encoding
# ❌ platform-dependent
with open("file.txt") as f:
    content = f.read()

# ✅
with open("file.txt", encoding="utf-8") as f:
    content = f.read()

# ระวัง 2: mode "w" ทับไฟล์
# ❌
with open("important.txt", "w") as f:
    f.write("new")  # ข้อมูลเดิมหาย!

# ✅ ใช้ "a" หรือ backup ก่อน
# ระวัง 3: อ่าน/เขียน binary ด้วย text mode
# ❌
with open("image.png", "r") as f:
    data = f.read()  # error

# ✅
with open("image.png", "rb") as f:
    data = f.read()

# ระวัง 4: newline
# ❌ Windows/Linux ต่างกัน
with open("file.txt", "w") as f:
    f.write("line1\nline2")

# ✅
with open("file.txt", "w", encoding="utf-8", newline="\n") as f:
    f.write("line1\nline2")

# ระวัง 5: seek() กับ text mode
# ⚠️ ใช้ได้เฉพาะ offset จาก tell() เท่านั้น
with open("file.txt", encoding="utf-8") as f:
    f.read(5)
    pos = f.tell()
    f.seek(pos)  # ✅
    # f.seek(10)  # ⚠️ อาจผิดถ้าไม่ใช่ position จาก tell()

# ระวัง 6: ไฟล์ไม่ปิด
# ใช้ with เสมอ

# ระวัง 7: Path traversal
# ❌
def read_file(filename):
    path = f"/data/{filename}"
    with open(path) as f:
        return f.read()

# read_file("../../etc/passwd")  # ❌ อ่านไฟล์ระบบ

# ✅ validate path
from pathlib import Path

def read_file_safe(filename: str) -> str:
    base = Path("/data").resolve()
    target = (base / filename).resolve()

    if not target.is_relative_to(base):
        raise ValueError("Path traversal detected")

    with target.open(encoding="utf-8") as f:
        return f.read()
```

### 8.1.7 สรุป

**Modes:**

| Mode | ความหมาย |
|------|----------|
| `r` | อ่าน |
| `w` | เขียน (ทับ) |
| `a` | เขียนต่อท้าย |
| `x` | สร้างใหม่ |
| `b` | binary |
| `t` | text |
| `+` | read + write |

**Best practices:**
- ใช้ `with` เสมอ
- ระบุ `encoding="utf-8"`
- ใช้ streaming สำหรับไฟล์ใหญ่
- ใช้ `newline=""` สำหรับ cross-platform
- Validate paths

> **อ้างอิงเพิ่มเติม:** [Reading and Writing Files](https://docs.python.org/3/tutorial/inputoutput.html#reading-and-writing-files)

---

## 8.2 pathlib

### บทนำ

`pathlib` เป็น module ที่ให้ object-oriented API สำหรับจัดการ paths ทันสมัยกว่า `os.path` และอ่านง่ายกว่า

### นิยาม

`pathlib.Path` คือ object ที่แทน path ใน filesystem มี methods และ operators สำหรับจัดการ

### 8.2.1 คืออะไร

ข้อดี:
- Object-oriented
- Operators (`/`)
- Methods ครบ
- Cross-platform
- อ่านง่าย

### 8.2.2 ทำงานอย่างไร

`Path` เก็บ path เป็น string ภายใน มี methods สำหรับ:
- สร้าง/รวม path
- ตรวจสอบ (exists, is_file, is_dir)
- อ่าน/เขียน
- วนซ้ำ
- ค้นหา

### 8.2.3 การใช้งาน

**สร้าง Path:**

```python
from pathlib import Path

# ปัจจุบัน
cwd = Path.cwd()
home = Path.home()

# จาก string
p1 = Path("/usr/local/bin")
p2 = Path("data", "file.txt")       # data/file.txt
p3 = Path("data") / "sub" / "f.txt" # data/sub/f.txt

# จาก parts
parts = ["data", "2024", "file.csv"]
p4 = Path(*parts)

# Windows
p5 = Path("C:/Users/name")  # ใช้ / ได้
# หรือ
p6 = Path(r"C:\Users\name")

# พิเศษ
Path(".")     # ปัจจุบัน
Path("..")    # parent
Path("~")     # home (ต้อง expanduser)
Path("~").expanduser()
```

**Operators:**

```python
base = Path("/data")

# / — join
file = base / "users" / "data.json"
print(file)  # /data/users/data.json

# + — ต่อ string (ระวัง!)
# ❌
new = base + "_backup"  # PosixPath('/data_backup')

# ✅
new = base.with_name(base.name + "_backup")
```

**Attributes:**

```python
p = Path("/home/user/docs/report.pdf")

print(p.name)       # report.pdf
print(p.stem)       # report
print(p.suffix)     # .pdf
print(p.suffixes)   # ['.pdf']
print(p.parent)     # /home/user/docs
print(p.parents[0]) # /home/user/docs
print(p.parts)      # ('/', 'home', 'user', 'docs', 'report.pdf')
print(p.anchor)     # /

# ไฟล์ซับซ้อน
p2 = Path("archive.tar.gz")
print(p2.suffix)    # .gz
print(p2.suffixes)  # ['.tar', '.gz']
print(p2.stem)      # archive.tar
```

**ตรวจสอบ:**

```python
p = Path("file.txt")

p.exists()      # มีอยู่?
p.is_file()     # เป็นไฟล์?
p.is_dir()      # เป็น directory?
p.is_symlink()  # เป็น symlink?
p.is_absolute() # absolute path?
p.is_relative_to(Path("/data"))  # อยู่ใน /data?
```

**อ่าน/เขียน:**

```python
p = Path("data.txt")

# อ่าน
content = p.read_text(encoding="utf-8")
lines = p.read_text(encoding="utf-8").splitlines()
data = p.read_bytes()

# เขียน
p.write_text("Hello", encoding="utf-8")
p.write_bytes(b"\x00\x01")

# เปิด
with p.open(encoding="utf-8") as f:
    for line in f:
        print(line.rstrip())
```

**สร้าง/ลบ:**

```python
# Directory
d = Path("new_dir")
d.mkdir(exist_ok=True)          # สร้าง 1 level
d.mkdir(parents=True, exist_ok=True)  # สร้าง parents ด้วย

# ไฟล์
f = Path("new.txt")
f.touch()                        # สร้างไฟล์ว่าง
f.touch(exist_ok=True)          # ไม่ error ถ้ามี

# ลบ
f.unlink(missing_ok=True)       # ลบไฟล์
d.rmdir()                        # ลบ empty directory

# ลบ directory + contents
import shutil
shutil.rmtree(d)
```

**ย้าย/เปลี่ยนชื่อ:**

```python
src = Path("old.txt")
dst = Path("new.txt")

src.rename(dst)          # เปลี่ยนชื่อ
src.replace(dst)         # เปลี่ยนชื่อ (ทับ)

# ย้าย
import shutil
shutil.move(src, dst)

# copy
shutil.copy(src, dst)         # copy ไฟล์
shutil.copy2(src, dst)        # copy + metadata
shutil.copytree(src_dir, dst_dir)  # copy directory
```

**วนซ้ำ:**

```python
d = Path(".")

# ไฟล์และ dirs ใน level เดียว
for item in d.iterdir():
    print(item.name, "dir" if item.is_dir() else "file")

# recursive
for item in d.rglob("*.py"):
    print(item)

# glob pattern
for item in d.glob("*.txt"):
    print(item)

# หลาย patterns
for item in d.glob("**/*.py"):
    print(item)
```

**Absolute / Resolve:**

```python
p = Path("file.txt")

# absolute
abs_path = p.absolute()
abs_path = p.resolve()  # resolve symlinks ด้วย

# relative
rel = p.relative_to(Path("/data"))
```

**เปลี่ยนส่วนประกอบ:**

```python
p = Path("/data/report.pdf")

p.with_name("summary.pdf")     # /data/summary.pdf
p.with_stem("summary")          # /data/summary.pdf
p.with_suffix(".txt")           # /data/report.txt
```

**ตัวอย่างการใช้งานจริง — File Organizer:**

```python
from pathlib import Path
import shutil
from datetime import datetime


def organize_downloads(downloads_dir: Path) -> dict[str, int]:
    """จัดระเบียบไฟล์ใน Downloads ตามประเภท"""
    categories = {
        "images": {".jpg", ".jpeg", ".png", ".gif", ".webp"},
        "videos": {".mp4", ".mov", ".avi", ".mkv"},
        "documents": {".pdf", ".doc", ".docx", ".txt", ".xlsx"},
        "audio": {".mp3", ".wav", ".flac"},
        "archives": {".zip", ".tar", ".gz", ".7z"},
        "code": {".py", ".js", ".java", ".cpp"},
    }

    counts: dict[str, int] = {}

    for file in downloads_dir.iterdir():
        if file.is_dir() or file.name.startswith("."):
            continue

        # หา category
        category = "other"
        for cat, extensions in categories.items():
            if file.suffix.lower() in extensions:
                category = cat
                break

        # สร้าง directory
        target_dir = downloads_dir / category
        target_dir.mkdir(exist_ok=True)

        # ย้าย
        target = target_dir / file.name
        if not target.exists():
            shutil.move(str(file), str(target))
            counts[category] = counts.get(category, 0) + 1

    return counts
```

**ตัวอย่าง — Project Structure Validator:**

```python
from pathlib import Path


def validate_project(root: Path) -> list[str]:
    """ตรวจสอบโครงสร้างโปรเจกต์ Python"""
    errors: list[str] = []

    # ต้องมี
    required = {
        "pyproject.toml": "file",
        "README.md": "file",
        "src": "dir",
        "tests": "dir",
    }

    for name, kind in required.items():
        path = root / name
        if kind == "file" and not path.is_file():
            errors.append(f"ขาดไฟล์: {name}")
        elif kind == "dir" and not path.is_dir():
            errors.append(f"ขาด directory: {name}")

    # ไม่ควรมี
    forbidden = {
        "__pycache__": "directory",
        ".pytest_cache": "directory",
    }

    for name in forbidden:
        for path in root.rglob(name):
            errors.append(f"ไม่ควรมี: {path.relative_to(root)}")

    return errors


# ใช้งาน
errors = validate_project(Path("."))
for e in errors:
    print(f"  - {e}")
```

**ตัวอย่าง — Find Files:**

```python
from pathlib import Path
from datetime import datetime, timedelta


def find_files(
    root: Path,
    pattern: str = "*",
    min_size: int = 0,
    max_age_days: int | None = None,
) -> list[Path]:
    """ค้นหาไฟล์ตามเงื่อนไข"""
    results = []

    for path in root.rglob(pattern):
        if not path.is_file():
            continue

        if path.stat().st_size < min_size:
            continue

        if max_age_days is not None:
            mtime = datetime.fromtimestamp(path.stat().st_mtime)
            if datetime.now() - mtime > timedelta(days=max_age_days):
                continue

        results.append(path)

    return results


# ไฟล์ .py ที่ใหญ่กว่า 10KB แก้ใน 7 วัน
files = find_files(
    Path("."),
    pattern="*.py",
    min_size=10_000,
    max_age_days=7,
)
```

**File Information:**

```python
p = Path("file.txt")

if p.exists():
    stat = p.stat()
    print(f"ขนาด: {stat.st_size} bytes")
    print(f"แก้ไขล่าสุด: {datetime.fromtimestamp(stat.st_mtime)}")
    print(f"สร้าง: {datetime.fromtimestamp(stat.st_ctime)}")

    # หรือใช้ methods
    print(f"ขนาด: {p.stat().st_size}")
    print(f"แก้ไข: {datetime.fromtimestamp(p.stat().st_mtime)}")

    # ตรวจสอบสิทธิ์
    import os
    print(f"อ่านได้: {os.access(p, os.R_OK)}")
    print(f"เขียนได้: {os.access(p, os.W_OK)}")
```

### 8.2.4 ข้อดี

- **Object-oriented:** methods ชัดเจน
- **Operators:** `/` join สวยงาม
- **Cross-platform:** จัดการ `\` vs `/`
- **Type-safe:** `Path` object
- **Methods ครบ:** เกือบทุกอย่างที่ต้องใช้

### 8.2.5 ข้อเสีย

- **ไม่ backward compatible:** กับ `os.path`
- **บาง library:** ยังต้องการ string
- **Performance:** เล็กน้อย

### 8.2.6 ข้อควรระวัง

```python
# ระวัง 1: Path + string
# ❌ TypeError
# Path("/data") + "/file.txt"

# ✅
Path("/data") / "file.txt"

# ระวัง 2: with_name กับ suffix
p = Path("archive.tar.gz")
p.with_suffix(".zip")  # archive.tar.zip (ไม่ใช่ archive.zip)

# ระวัง 3: resolve() กับ symlink
p = Path("link_to_file")
p.resolve()  # target ของ symlink

# ใช้ absolute() ถ้าไม่ต้องการ resolve
p.absolute()

# ระวัง 4: iterating while modifying
# ❌
for f in Path(".").iterdir():
    if f.is_file():
        f.unlink()  # ⚠️ อาจข้ามบางไฟล์

# ✅
files = [f for f in Path(".").iterdir() if f.is_file()]
for f in files:
    f.unlink()

# ระวัง 5: rglob("**") ซ้ำ
# ❌
Path(".").rglob("**/*.py")  # ซ้ำ
# ✅
Path(".").rglob("*.py")

# ระวัง 6: Windows path
# ใช้ Path เสมอ ไม่ต้อง manual
```

### 8.2.7 สรุป

**Operations ที่ใช้บ่อย:**

| Operation | Code |
|-----------|------|
| Join | `Path(a) / b` |
| Current dir | `Path.cwd()` |
| Home | `Path.home()` |
| Read text | `p.read_text()` |
| Write text | `p.write_text()` |
| List dir | `p.iterdir()` |
| Find | `p.rglob("*.py")` |
| Create dir | `p.mkdir(parents=True)` |
| Delete | `p.unlink()` |

**Best practices:**
- ใช้ `Path` แทน string
- ใช้ `/` สำหรับ join
- `resolve()` สำหรับ absolute
- `rglob` สำหรับ recursive
- ใช้ `with` เมื่อเปิดไฟล์

> **อ้างอิงเพิ่มเติม:** [pathlib Documentation](https://docs.python.org/3/library/pathlib.html)

---

## 8.3 os.path

### บทนำ

`os.path` เป็น module แบบดั้งเดิมสำหรับจัดการ paths ยังใช้ในโค้ดเก่าและบาง library แม้ `pathlib` จะทันสมัยกว่า

### นิยาม

`os.path` ให้ functions สำหรับจัดการ path strings แบบ platform-independent

### 8.3.1 คืออะไร

Functions หลัก:
- `join()`, `split()`, `splitext()`
- `exists()`, `isfile()`, `isdir()`
- `abspath()`, `realpath()`
- `basename()`, `dirname()`

### 8.3.2 ทำงานอย่างไร

`os.path` ทำงานกับ string โดยตรง ปรับ separator ตาม platform อัตโนมัติ

### 8.3.3 การใช้งาน

```python
import os.path

# Join
p = os.path.join("data", "2024", "file.csv")
# Linux: data/2024/file.csv
# Windows: data\2024\file.csv

# Split
head, tail = os.path.split("/home/user/file.txt")
# head = /home/user, tail = file.txt

# Separator
os.path.sep        # / (Linux) หรือ \ (Windows)

# Extension
root, ext = os.path.splitext("report.pdf")
# root = report, ext = .pdf

# Basename / Dirname
os.path.basename("/home/user/file.txt")  # file.txt
os.path.dirname("/home/user/file.txt")   # /home/user

# Exists
os.path.exists("file.txt")
os.path.isfile("file.txt")
os.path.isdir("data")
os.path.islink("link")

# Absolute
os.path.abspath("file.txt")     # /current/dir/file.txt
os.path.realpath("link")        # resolve symlink

# Normalize
os.path.normpath("data/../file.txt")  # file.txt

# Expand
os.path.expanduser("~/docs")    # /home/user/docs
os.path.expandvars("$HOME/docs")  # /home/user/docs

# Size / time
os.path.getsize("file.txt")
os.path.getmtime("file.txt")
os.path.getctime("file.txt")

# Common prefix
os.path.commonprefix(["/a/b/c", "/a/b/d"])  # /a/b/
os.path.commonpath(["/a/b/c", "/a/b/d"])    # /a/b
```

**ตัวอย่าง:**

```python
import os.path

def get_unique_path(path: str) -> str:
    """สร้าง path ที่ไม่ซ้ำ — เพิ่ม (1), (2), ..."""
    if not os.path.exists(path):
        return path

    base, ext = os.path.splitext(path)
    counter = 1

    while True:
        new_path = f"{base} ({counter}){ext}"
        if not os.path.exists(new_path):
            return new_path
        counter += 1


print(get_unique_path("report.pdf"))
# report.pdf
# ถ้ามี: report (1).pdf
# ถ้ามีอีก: report (2).pdf
```

### 8.3.4 ข้อดี

- **Standard:** มีมานาน
- **Simple:** ใช้ string
- **Compatible:** กับ library เก่า

### 8.3.5 ข้อเสีย

- **String-based:** ไม่ type-safe
- **Verbose:** ยาวกว่า pathlib
- **Error-prone:** manual join

### 8.3.6 ข้อควรระวัง

```python
# ระวัง 1: Manual join
# ❌ platform-dependent
path = "data" + "/" + "file.txt"

# ✅
path = os.path.join("data", "file.txt")

# ระวัง 2: splitext กับ dotfiles
os.path.splitext(".gitignore")  # ('.gitignore', '')
os.path.splitext("file.tar.gz")  # ('file.tar', '.gz')

# ระวัง 3: commonprefix vs commonpath
os.path.commonprefix(["/a/bc", "/a/bd"])
# '/a/b' — string prefix!

os.path.commonpath(["/a/bc", "/a/bd"])
# '/a' — path-aware

# ระวัง 4: abspath กับ ..
# os.path.abspath("./../file")
# อาจไม่ตรงที่คิด ถ้า cwd เปลี่ยน

# ✅ ใช้ realpath หรือ pathlib.resolve()
```

### 8.3.7 สรุป

**ใช้ `pathlib` เมื่อ:**
- โปรเจกต์ใหม่
- ต้องการ type safety
- Object-oriented style

**ใช้ `os.path` เมื่อ:**
- โค้ดเก่า
- Library ต้องการ string
- ต้องการ function style

> **อ้างอิงเพิ่มเติม:** [os.path Documentation](https://docs.python.org/3/library/os.path.html)

---

## 8.4 shutil

### บทนำ

`shutil` ให้ high-level operations สำหรับไฟล์และ directories เช่น copy, move, remove tree และ disk usage

### นิยาม

`shutil` เป็น module สำหรับ file operations ระดับสูง

### 8.4.1 คืออะไร

Functions หลัก:
- `copy()`, `copy2()`, `copyfile()`
- `copytree()`, `rmtree()`
- `move()`
- `disk_usage()`
- `make_archive()`, `unpack_archive()`
- `which()`

### 8.4.2 ทำงานอย่างไร

`shutil` ทำงานกับ file objects, paths และ metadata

### 8.4.3 การใช้งาน

**Copy:**

```python
import shutil

# copyfile — copy แค่ content
shutil.copyfile("src.txt", "dst.txt")

# copy — copy content + permissions
shutil.copy("src.txt", "dst.txt")
shutil.copy("src.txt", "dir/")  # เข้า directory

# copy2 — copy content + permissions + metadata
shutil.copy2("src.txt", "dst.txt")  # เก็บ timestamps ด้วย

# copytree — copy directory
shutil.copytree("src_dir", "dst_dir")
shutil.copytree("src", "dst", dirs_exist_ok=True)  # Python 3.8+

# ignore patterns
shutil.copytree(
    "src",
    "dst",
    ignore=shutil.ignore_patterns("*.pyc", "__pycache__", ".git"),
)
```

**Move:**

```python
shutil.move("src.txt", "dst.txt")
shutil.move("src.txt", "dir/")
shutil.move("src_dir", "new_location/")
```

**Remove:**

```python
import shutil
import os

# ลบไฟล์
os.remove("file.txt")
os.unlink("file.txt")  # เหมือนกัน

# ลบ directory ว่าง
os.rmdir("empty_dir")

# ลบ directory + contents
shutil.rmtree("dir_with_contents")

# ignore errors
shutil.rmtree("dir", ignore_errors=True)

# onerror callback
def handle_error(func, path, exc_info):
    print(f"Error: {func} {path}")

shutil.rmtree("dir", onerror=handle_error)
```

**Disk Usage:**

```python
import shutil

usage = shutil.disk_usage("/")
print(f"Total: {usage.total / (1024**3):.2f} GB")
print(f"Used: {usage.used / (1024**3):.2f} GB")
print(f"Free: {usage.free / (1024**3):.2f} GB")
```

**Archive:**

```python
import shutil

# สร้าง archive
shutil.make_archive(
    "backup",        # base name
    "zip",           # format
    "data",          # root dir
)
# → backup.zip

shutil.make_archive("backup", "gztar", "data")
# → backup.tar.gz

# แตก archive
shutil.unpack_archive("backup.zip", "extracted/")
shutil.unpack_archive("backup.tar.gz", "extracted/")

# ดู formats ที่รองรับ
print(shutil.get_archive_formats())
print(shutil.get_unpack_formats())
```

**Which:**

```python
import shutil

# หา path ของ executable
python = shutil.which("python")
print(python)  # /usr/bin/python

git = shutil.which("git")
if git:
    print(f"Git: {git}")
else:
    print("ไม่พบ git")
```

**Terminal Size:**

```python
import shutil

size = shutil.get_terminal_size()
print(f"Terminal: {size.columns}x{size.lines}")
```

**ตัวอย่างการใช้งานจริง — Backup Script:**

```python
import shutil
from pathlib import Path
from datetime import datetime


def backup_directory(
    src: Path,
    backup_dir: Path,
    name: str = "backup",
) -> Path:
    """สำรองข้อมูลเป็น zip"""
    backup_dir.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    base_name = backup_dir / f"{name}_{timestamp}"

    archive = shutil.make_archive(
        str(base_name),
        "zip",
        str(src),
    )
    return Path(archive)


def cleanup_old_backups(
    backup_dir: Path,
    keep: int = 5,
) -> list[Path]:
    """ลบ backups เก่า เก็บไว้ n ไฟล์"""
    backups = sorted(
        backup_dir.glob("*.zip"),
        key=lambda p: p.stat().st_mtime,
        reverse=True,
    )

    removed = []
    for old in backups[keep:]:
        old.unlink()
        removed.append(old)

    return removed


# ใช้งาน
backup = backup_directory(
    Path("data"),
    Path("backups"),
    name="daily",
)
print(f"Backup created: {backup}")

removed = cleanup_old_backups(Path("backups"), keep=7)
print(f"Removed {len(removed)} old backups")
```

**ตัวอย่าง — Sync Directory:**

```python
import shutil
from pathlib import Path
from filecmp import dircmp


def sync_directory(src: Path, dst: Path) -> dict[str, int]:
    """Sync จาก src ไป dst (one-way)"""
    stats = {"copied": 0, "updated": 0, "removed": 0}

    # Copy ใหม่/อัปเดต
    for src_file in src.rglob("*"):
        if not src_file.is_file():
            continue

        rel = src_file.relative_to(src)
        dst_file = dst / rel
        dst_file.parent.mkdir(parents=True, exist_ok=True)

        if not dst_file.exists():
            shutil.copy2(src_file, dst_file)
            stats["copied"] += 1
        elif src_file.stat().st_mtime > dst_file.stat().st_mtime:
            shutil.copy2(src_file, dst_file)
            stats["updated"] += 1

    # ลบไฟล์ที่ไม่มีใน src
    for dst_file in dst.rglob("*"):
        if not dst_file.is_file():
            continue

        rel = dst_file.relative_to(dst)
        if not (src / rel).exists():
            dst_file.unlink()
            stats["removed"] += 1

    return stats
```

### 8.4.4 ข้อดี

- **High-level:** operations ครบ
- **Cross-platform:** จัดการ platform
- **Metadata:** copy2 เก็บ metadata
- **Archives:** สร้าง/แตกได้

### 8.4.5 ข้อเสีย

- **Risk:** rmtree อันตราย
- **Limited:** ไม่มี advanced

### 8.4.6 ข้อควรระวัง

```python
# ระวัง 1: rmtree กับ path ผิด
# ❌
shutil.rmtree("/")  # ลบทั้งระบบ!

# ✅ validate path
from pathlib import Path

def safe_rmtree(path: Path) -> None:
    resolved = path.resolve()
    if resolved == Path("/"):
        raise ValueError("ไม่สามารถลบ root")
    if not resolved.is_relative_to(Path("/home")):
        raise ValueError("ต้องอยู่ใน /home เท่านั้น")
    shutil.rmtree(resolved)

# ระวัง 2: copyfile ไม่ copy metadata
# ❌
shutil.copyfile("src", "dst")  # timestamps หาย

# ✅
shutil.copy2("src", "dst")

# ระวัง 3: move ข้าม filesystem
# shutil.move ใช้ copy+delete ถ้าข้าม FS
# อาจช้าและใช้ disk space

# ระวัง 4: copytree กับ symlinks
shutil.copytree(
    "src",
    "dst",
    symlinks=True,  # เก็บ symlink แทน copy target
)

# ระวัง 5: disk_usage กับ path ที่ไม่มี
# ⚠️ FileNotFoundError ถ้า path ไม่มี
if path.exists():
    usage = shutil.disk_usage(path)

# ระวัง 6: make_archive ไม่เก็บ empty dirs
# ⚠️ บาง format ไม่เก็บ
```

### 8.4.7 สรุป

**Operations:**

| Function | ใช้ |
|----------|-----|
| `copy` | Copy ไฟล์ |
| `copy2` | Copy + metadata |
| `copytree` | Copy directory |
| `move` | Move/rename |
| `rmtree` | ลบ tree |
| `disk_usage` | Disk info |
| `make_archive` | สร้าง archive |
| `which` | หา executable |

**Best practices:**
- ใช้ `copy2` สำหรับ metadata
- Validate paths ก่อน `rmtree`
- `ignore_patterns` สำหรับ copytree
- ตรวจสอบ disk space

> **อ้างอิงเพิ่มเติม:** [shutil Documentation](https://docs.python.org/3/library/shutil.html)

---

## 8.5 glob

### บทนำ

`glob` ใช้ค้นหาไฟล์ตาม pattern คล้าย shell wildcards รองรับ `*`, `?`, `[]` และ `**` (recursive)

### นิยาม

`glob` เป็น module สำหรับค้นหา files/directories ตาม pattern

### 8.5.1 คืออะไร

Patterns:
- `*` — อะไรก็ได้ (ไม่ข้าม `/`)
- `?` — 1 ตัวอักษร
- `[abc]` — ตัวอักษรใน set
- `[!abc]` — ไม่อยู่ใน set
- `**` — recursive (กับ recursive=True)

### 8.5.2 ทำงานอย่างไร

`glob.glob()` คืน list ของ paths ที่ตรง pattern `glob.iglob()` คืน iterator

### 8.5.3 การใช้งาน

```python
import glob

# ไฟล์ .py ใน directory ปัจจุบัน
py_files = glob.glob("*.py")

# ไฟล์ .txt
txt_files = glob.glob("*.txt")

# ไฟล์ที่มี "test" ในชื่อ
tests = glob.glob("*test*")

# Directory
dirs = glob.glob("*/")

# หลาย patterns
files = glob.glob("*.py") + glob.glob("*.txt")

# ทุกไฟล์
all_files = glob.glob("*")

# Hidden files (Linux/Mac)
hidden = glob.glob(".*")

# ? — 1 char
files = glob.glob("file?.txt")  # file1.txt, fileA.txt

# [] — set
files = glob.glob("file[0-9].txt")  # file0.txt - file9.txt
files = glob.glob("file[abc].txt")  # filea.txt, fileb.txt, filec.txt
files = glob.glob("file[!0-9].txt") # ไม่ใช่ตัวเลข

# ** — recursive
all_py = glob.glob("**/*.py", recursive=True)

# หรือ (Python 3.5+)
all_py = glob.glob("**/*.py", recursive=True)
```

**`iglob` — Iterator:**

```python
import glob

# ✅ ประหยัด memory
for path in glob.iglob("**/*.py", recursive=True):
    print(path)

# เทียบกับ
for path in glob.glob("**/*.py", recursive=True):  # โหลดทั้งหมด
    print(path)
```

**Escape Characters:**

```python
import glob

# ❌ [abc] เป็น pattern
files = glob.glob("file[1].txt")  # pattern

# ✅ ใช้ escape
files = glob.glob("file[[]1].txt")  # literal [1]

# ใช้ glob.escape
pattern = glob.escape("file[1]")
files = glob.glob(f"{pattern}.txt")
```

**ตัวอย่างการใช้งานจริง — Find Files:**

```python
import glob
from pathlib import Path


def find_recent_logs(
    log_dir: str,
    pattern: str = "*.log",
    max_files: int = 10,
) -> list[str]:
    """หา log files ล่าสุด"""
    files = glob.glob(
        f"{log_dir}/**/{pattern}",
        recursive=True,
    )

    # เรียงตามเวลาแก้ไข (ใหม่สุดก่อน)
    files.sort(
        key=lambda p: Path(p).stat().st_mtime,
        reverse=True,
    )

    return files[:max_files]


# ใช้งาน
logs = find_recent_logs("logs")
for log in logs:
    print(log)
```

**ตัวอย่าง — Project Scanner:**

```python
import glob
from pathlib import Path


def count_by_extension(root: str = ".") -> dict[str, int]:
    """นับไฟล์ตามนามสกุล"""
    from collections import Counter

    counts: Counter[str] = Counter()

    # ทุกไฟล์ (ไม่รวม dirs)
    for path in glob.iglob(
        f"{root}/**/*",
        recursive=True,
    ):
        p = Path(path)
        if not p.is_file():
            continue

        ext = p.suffix.lower() or "(no extension)"
        counts[ext] += 1

    return dict(counts.most_common())


# ใช้งาน
stats = count_by_extension(".")
for ext, count in stats.items():
    print(f"{ext:15} {count:5}")
```

**ตัวอย่าง — Clean Build Artifacts:**

```python
import glob
import shutil
from pathlib import Path


def clean_python_artifacts(root: str = ".") -> dict[str, int]:
    """ลบ build artifacts ของ Python"""
    removed = {"pycache": 0, "pyc": 0, "pyo": 0, "egg_info": 0}

    # __pycache__ directories
    for cache_dir in glob.glob(
        f"{root}/**/__pycache__",
        recursive=True,
    ):
        shutil.rmtree(cache_dir, ignore_errors=True)
        removed["pycache"] += 1

    # .pyc, .pyo
    for ext in ("pyc", "pyo"):
        files = glob.glob(f"{root}/**/*.{ext}", recursive=True)
        for f in files:
            try:
                Path(f).unlink()
                removed[ext] += 1
            except OSError:
                pass

    # *.egg-info
    for egg_dir in glob.glob(
        f"{root}/**/*.egg-info",
        recursive=True,
    ):
        if Path(egg_dir).is_dir():
            shutil.rmtree(egg_dir, ignore_errors=True)
            removed["egg_info"] += 1

    return removed


# ใช้งาน
result = clean_python_artifacts(".")
print(f"ลบ __pycache__: {result['pycache']}")
print(f"ลบ .pyc: {result['pyc']}")
```

### 8.5.4 ข้อดี

- **Simple:** pattern ง่าย
- **Shell-like:** คุ้นเคย
- **Recursive:** ด้วย `**`
- **Built-in:** ไม่ต้องติดตั้ง

### 8.5.5 ข้อเสีย

- **String-based:** ไม่ type-safe
- **จำกัด:** ไม่มี regex
- **Performance:** ช้ากว่า pathlib.rglob
- **Platform:** บาง pattern ต่างกัน

### 8.5.6 ข้อควรระวัง

```python
# ระวัง 1: ** ต้องมี recursive=True
# ❌ ไม่ recursive
files = glob.glob("**/*.py")  # แค่ *.py ในปัจจุบัน

# ✅
files = glob.glob("**/*.py", recursive=True)

# ระวัง 2: Pattern traversal
# ❌
files = glob.glob(f"{user_input}/*.txt")
# ถ้า user_input = "../etc" → อ่านไฟล์ระบบ

# ✅ validate
from pathlib import Path

def safe_glob(base: str, pattern: str) -> list[str]:
    base_path = Path(base).resolve()
    results = []

    for f in glob.glob(f"{base}/*.txt"):
        p = Path(f).resolve()
        if p.is_relative_to(base_path):
            results.append(f)

    return results

# ระวัง 3: Performance กับ **
# ใน directory ใหญ่ recursive ช้า
# ใช้ pathlib.rglob หรือ os.walk

# ระวัง 4: glob ไม่รวม hidden
# ❌ glob.glob("*") ไม่เจอ .hidden
# ✅ ต้องใช้ .* pattern แยก

# ระวัง 5: Symlink loops
# ** อาจวนไม่จบถ้ามี symlink loop
# ใช้ pathlib.rglob หรือ os.walk ที่จัดการได้
```

### 8.5.7 สรุป

**Patterns:**

| Pattern | ความหมาย |
|---------|----------|
| `*` | อะไรก็ได้ (ไม่ข้าม `/`) |
| `?` | 1 ตัวอักษร |
| `[abc]` | ตัวใน set |
| `[!abc]` | ตัวนอก set |
| `**` | recursive (ต้อง `recursive=True`) |

**Best practices:**
- ใช้ `iglob` สำหรับไฟล์เยอะ
- `recursive=True` สำหรับ `**`
- Validate paths
- ใช้ `glob.escape` สำหรับ special chars
- พิจารณา `pathlib.rglob`

> **อ้างอิงเพิ่มเติม:** [glob Documentation](https://docs.python.org/3/library/glob.html)

---

## 8.6 CSV

### บทนำ

CSV (Comma-Separated Values) เป็น format ที่ใช้กันมากที่สุดสำหรับ tabular data Python มี `csv` module ที่จัดการ edge cases ได้ดี

### นิยาม

CSV คือ text format ที่ใช้คั่นข้อมูลด้วย comma (หรือ delimiter อื่น) แต่ละบรรทัดเป็น record

### 8.6.1 คืออะไร

CSV มี variations:
- Delimiter: `,` `;` `\t` `|`
- Quotechar: `"` `'`
- Quoting: minimal, all, nonnumeric
- Header: มี/ไม่มี

### 8.6.2 ทำงานอย่างไร

`csv` module แยกแยะ:
- `reader` / `writer` — list-based
- `DictReader` / `DictWriter` — dict-based

### 8.6.3 การใช้งาน

**อ่าน CSV:**

```python
import csv

# reader — list
with open("data.csv", encoding="utf-8") as f:
    reader = csv.reader(f)
    header = next(reader)  # ['name', 'age', 'city']
    for row in reader:
        print(row)  # ['Alice', '30', 'NYC']

# DictReader — dict (แนะนำ)
with open("data.csv", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        print(row["name"], row["age"])

# ระบุ fieldnames (ถ้าไม่มี header)
with open("data.csv", encoding="utf-8") as f:
    reader = csv.DictReader(
        f,
        fieldnames=["id", "name", "score"],
    )
    for row in reader:
        print(row)
```

**เขียน CSV:**

```python
import csv

# writer
data = [
    ["name", "age", "city"],
    ["Alice", 30, "NYC"],
    ["Bob", 25, "LA"],
]

with open("output.csv", "w", encoding="utf-8", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["name", "age", "city"])
    writer.writerows(data[1:])

# DictWriter (แนะนำ)
rows = [
    {"name": "Alice", "age": 30, "city": "NYC"},
    {"name": "Bob", "age": 25, "city": "LA"},
]

with open("output.csv", "w", encoding="utf-8", newline="") as f:
    writer = csv.DictWriter(
        f,
        fieldnames=["name", "age", "city"],
    )
    writer.writeheader()
    writer.writerows(rows)
```

**Dialects:**

```python
import csv

# ดู dialects ที่มี
print(csv.list_dialects())  # ['excel', 'excel-tab', 'unix']

# excel — default
# delimiter=',', quotechar='"', \r\n

# excel-tab
# delimiter='\t'

# unix
# delimiter=',', quotechar='"', \n

# ใช้ dialect
with open("data.csv", encoding="utf-8", newline="") as f:
    reader = csv.reader(f, dialect="excel-tab")
    for row in reader:
        print(row)

# Custom dialect
csv.register_dialect(
    "custom",
    delimiter=";",
    quotechar="'",
    quoting=csv.QUOTE_MINIMAL,
)

with open("data.csv", encoding="utf-8", newline="") as f:
    reader = csv.reader(f, dialect="custom")
```

**Parameters:**

```python
with open("data.csv", encoding="utf-8", newline="") as f:
    reader = csv.reader(
        f,
        delimiter=",",          # ตัวคั่น
        quotechar='"',          # ตัว quote
        quoting=csv.QUOTE_MINIMAL,  # QUOTE_ALL, QUOTE_NONNUMERIC, QUOTE_NONE
        skipinitialspace=True,  # ข้าม space หลัง delimiter
        lineterminator="\n",    # บรรทัด
        escapechar="\\",        # ตัว escape
    )
```

**DictReader กับ Type Conversion:**

```python
import csv
from dataclasses import dataclass
from typing import Iterator


@dataclass
class User:
    id: int
    name: str
    email: str
    age: int


def read_users(path: str) -> Iterator[User]:
    """อ่าน CSV และแปลงเป็น dataclass"""
    with open(path, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for i, row in enumerate(reader, start=2):
            try:
                yield User(
                    id=int(row["id"]),
                    name=row["name"].strip(),
                    email=row["email"].strip().lower(),
                    age=int(row["age"]),
                )
            except (KeyError, ValueError) as e:
                raise ValueError(
                    f"บรรทัด {i}: ข้อมูลไม่ถูกต้อง ({e})"
                ) from e


# ใช้งาน
for user in read_users("users.csv"):
    print(user)
```

**ตัวอย่างการใช้งานจริง — CSV Processor:**

```python
import csv
from pathlib import Path
from typing import Any
from dataclasses import dataclass, fields


@dataclass
class Product:
    id: str
    name: str
    price: float
    quantity: int

    @property
    def total(self) -> float:
        return self.price * self.quantity


def load_products(path: Path) -> list[Product]:
    """โหลด products จาก CSV"""
    products = []

    with path.open(encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f)

        for line_num, row in enumerate(reader, start=2):
            try:
                products.append(Product(
                    id=row["id"],
                    name=row["name"],
                    price=float(row["price"]),
                    quantity=int(row["quantity"]),
                ))
            except (KeyError, ValueError) as e:
                print(f"ข้ามบรรทัด {line_num}: {e}")

    return products


def save_products(products: list[Product], path: Path) -> None:
    """บันทึก products เป็น CSV"""
    fieldnames = [f.name for f in fields(Product)] + ["total"]

    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()

        for p in products:
            writer.writerow({
                "id": p.id,
                "name": p.name,
                "price": p.price,
                "quantity": p.quantity,
                "total": p.total,
            })


# ใช้งาน
products = load_products(Path("products.csv"))
total = sum(p.total for p in products)
print(f"Total: {total:,.2f}")
```

**ตัวอย่าง — CSV กับ Delimiter Detection:**

```python
import csv
from pathlib import Path


def detect_dialect(path: Path, sample_size: int = 8192) -> csv.Dialect:
    """ตรวจสอบ dialect ของ CSV"""
    with path.open(encoding="utf-8", newline="") as f:
        sample = f.read(sample_size)

    try:
        dialect = csv.Sniffer().sniff(sample)
        return dialect
    except csv.Error:
        return csv.excel  # default


def read_csv_auto(path: Path) -> list[dict]:
    """อ่าน CSV โดยตรวจจับ dialect"""
    dialect = detect_dialect(path)

    has_header = True
    with path.open(encoding="utf-8", newline="") as f:
        sample = f.read(8192)
        try:
            has_header = csv.Sniffer().has_header(sample)
        except csv.Error:
            pass

    with path.open(encoding="utf-8", newline="") as f:
        if has_header:
            return list(csv.DictReader(f, dialect=dialect))
        else:
            reader = csv.reader(f, dialect=dialect)
            return [row for row in reader]


# ใช้งาน
data = read_csv_auto(Path("unknown.csv"))
```

### 8.6.4 ข้อดี

- **Standard:** format ธรรมดา
- **Universal:** ทุก tool รองรับ
- **Human-readable:** อ่านได้
- **Built-in:** ไม่ต้อง library
- **Dialects:** ยืดหยุ่น

### 8.6.5 ข้อเสีย

- **No types:** ทุกอย่างเป็น string
- **No schema:** ไม่มี validation
- **Encoding:** ปัญหาได้
- **Large files:** ต้อง streaming
- **Complex data:** ไม่เหมาะ

### 8.6.6 ข้อควรระวัง

```python
# ระวัง 1: ลืม newline=""
# ❌ บน Windows อาจมี \r\r\n
with open("data.csv", "w") as f:
    writer = csv.writer(f)

# ✅
with open("data.csv", "w", newline="") as f:
    writer = csv.writer(f)

# ระวัง 2: Encoding
# ❌
with open("data.csv") as f:  # platform default
    reader = csv.reader(f)

# ✅
with open("data.csv", encoding="utf-8") as f:
    reader = csv.reader(f)

# Excel ไทย: ใช้ utf-8-sig
with open("data.csv", encoding="utf-8-sig") as f:
    reader = csv.reader(f)

# ระวัง 3: ลืม next() header
# ❌ header เป็น data
with open("data.csv") as f:
    for row in csv.reader(f):
        process(row)  # row[0] = "name"

# ✅
with open("data.csv") as f:
    reader = csv.reader(f)
    next(reader)  # ข้าม header
    for row in reader:
        process(row)

# ระวัง 4: ข้อมูลมี comma
# csv module จัดการให้ ถ้าเขียนผ่าน csv.writer

# ระวัง 5: ไฟล์ใหญ่
# ❌ อ่านทั้งหมด
with open("large.csv") as f:
    rows = list(csv.reader(f))

# ✅ streaming
with open("large.csv") as f:
    for row in csv.reader(f):
        process(row)

# ระวัง 6: Numeric conversion
# CSV ทุกอย่างเป็น string
row = {"price": "100", "qty": "5"}
total = row["price"] * row["qty"]  # ❌ TypeError
total = float(row["price"]) * int(row["qty"])  # ✅
```

### 8.6.7 สรุป

**Reader:**
- `csv.reader` — list
- `csv.DictReader` — dict (แนะนำ)

**Writer:**
- `csv.writer` — list
- `csv.DictWriter` — dict (แนะนำ)

**Best practices:**
- `encoding="utf-8"` (หรือ `utf-8-sig` สำหรับ Excel)
- `newline=""` ตอนเขียน
- DictReader/DictWriter อ่านง่ายกว่า
- Streaming สำหรับไฟล์ใหญ่
- แปลง type เอง
- Validate ข้อมูล

> **อ้างอิงเพิ่มเติม:** [csv Documentation](https://docs.python.org/3/library/csv.html)

---

## 8.7 JSON

### บทนำ

JSON (JavaScript Object Notation) เป็น format ที่นิยมที่สุดสำหรับ data interchange Python มี `json` module ที่ใช้งานง่าย

### นิยาม

JSON คือ text format สำหรับ structured data รองรับ: object, array, string, number, boolean, null

### 8.7.1 คืออะไร

JSON types → Python types:
- object → dict
- array → list
- string → str
- number → int/float
- boolean → bool
- null → None

### 8.7.2 ทำงานอย่างไร

`json.dumps()` — serialize Python → JSON string
`json.loads()` — deserialize JSON string → Python
`json.dump()` — เขียนไปไฟล์
`json.load()` — อ่านจากไฟล์

### 8.7.3 การใช้งาน

**พื้นฐาน:**

```python
import json

# Python → JSON string
data = {
    "name": "สมชาย",
    "age": 30,
    "tags": ["python", "developer"],
    "active": True,
    "salary": None,
}

json_str = json.dumps(data)
print(json_str)
# {"name": "\u0e2a\u0e21\u0e0a\u0e32\u0e22", "age": 30, ...}

# pretty print
json_str = json.dumps(data, indent=2, ensure_ascii=False)
print(json_str)
# {
#   "name": "สมชาย",
#   "age": 30,
#   ...
# }

# JSON → Python
parsed = json.loads(json_str)
print(parsed["name"])  # สมชาย
```

**อ่าน/เขียนไฟล์:**

```python
import json

# เขียน
with open("data.json", "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

# อ่าน
with open("data.json", encoding="utf-8") as f:
    loaded = json.load(f)

print(loaded["name"])
```

**Parameters:**

```python
json.dumps(
    data,
    indent=2,                    # pretty print
    ensure_ascii=False,          # เก็บ Unicode
    sort_keys=True,              # เรียง keys
    separators=(",", ": "),      # ตัวคั่น
    default=str,                 # fallback สำหรับ non-serializable
    allow_nan=False,             # error ถ้ามี NaN/Infinity
    cls=None,                    # custom encoder
)
```

**Custom Types:**

```python
import json
from datetime import datetime
from decimal import Decimal
from dataclasses import dataclass, asdict


@dataclass
class User:
    id: int
    name: str
    created_at: datetime
    balance: Decimal


def default_encoder(obj):
    """จัดการ types ที่ JSON ไม่รองรับ"""
    if isinstance(obj, datetime):
        return obj.isoformat()
    if isinstance(obj, Decimal):
        return str(obj)
    if hasattr(obj, "__dataclass_fields__"):
        return asdict(obj)
    if isinstance(obj, set):
        return list(obj)
    raise TypeError(f"ไม่รองรับ {type(obj)}")


user = User(
    id=1,
    name="สมชาย",
    created_at=datetime.now(),
    balance=Decimal("1500.50"),
)

json_str = json.dumps(user, default=default_encoder, indent=2)
print(json_str)
```

**Custom JSONEncoder:**

```python
import json
from datetime import datetime
from decimal import Decimal
from dataclasses import asdict


class AppJSONEncoder(json.JSONEncoder):
    """JSON encoder สำหรับ types ของแอป"""

    def default(self, obj):
        if isinstance(obj, datetime):
            return obj.isoformat()
        if isinstance(obj, Decimal):
            return float(obj)
        if hasattr(obj, "__dataclass_fields__"):
            return asdict(obj)
        if isinstance(obj, set):
            return sorted(obj)
        if isinstance(obj, bytes):
            return obj.decode("utf-8", errors="replace")
        return super().default(obj)


# ใช้งาน
data = {
    "created": datetime.now(),
    "price": Decimal("99.99"),
    "tags": {"python", "json"},
}

json_str = json.dumps(data, cls=AppJSONEncoder, indent=2)
```

**Custom Decoder (Object Hook):**

```python
import json
from datetime import datetime
from typing import Any


class User:
    def __init__(self, id: int, name: str, created_at: datetime):
        self.id = id
        self.name = name
        self.created_at = created_at


def decode_user(dct: dict[str, Any]) -> Any:
    """Object hook สำหรับ decode"""
    if "created_at" in dct:
        dct["created_at"] = datetime.fromisoformat(dct["created_at"])
    if "name" in dct and "id" in dct and "created_at" in dct:
        return User(**dct)
    return dct


# ใช้งาน
json_str = '{"id": 1, "name": "Alice", "created_at": "2024-01-01T12:00:00"}'
user = json.loads(json_str, object_hook=decode_user)
print(user.name)  # Alice
print(user.created_at)  # datetime
```

**JSON Lines (NDJSON):**

```python
import json
from pathlib import Path


def write_jsonl(path: Path, items: list[dict]) -> None:
    """เขียน JSON Lines — 1 JSON ต่อบรรทัด"""
    with path.open("w", encoding="utf-8") as f:
        for item in items:
            f.write(json.dumps(item, ensure_ascii=False) + "\n")


def read_jsonl(path: Path):
    """อ่าน JSON Lines — streaming"""
    with path.open(encoding="utf-8") as f:
        for line in f:
            if line.strip():
                yield json.loads(line)


# ใช้งาน
items = [
    {"id": 1, "name": "Alice"},
    {"id": 2, "name": "Bob"},
]

write_jsonl(Path("data.jsonl"), items)

for item in read_jsonl(Path("data.jsonl")):
    print(item)
```

**ตัวอย่างการใช้งานจริง — Config Management:**

```python
import json
from pathlib import Path
from typing import Any


class ConfigManager:
    """จัดการ config ด้วย JSON"""

    def __init__(self, path: Path):
        self.path = path
        self._data: dict[str, Any] = {}
        self.load()

    def load(self) -> None:
        if not self.path.exists():
            self._data = {}
            return

        with self.path.open(encoding="utf-8") as f:
            self._data = json.load(f)

    def save(self) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)

        with self.path.open("w", encoding="utf-8") as f:
            json.dump(
                self._data,
                f,
                indent=2,
                ensure_ascii=False,
                sort_keys=True,
            )

    def get(self, key: str, default: Any = None) -> Any:
        keys = key.split(".")
        value: Any = self._data

        for k in keys:
            if not isinstance(value, dict):
                return default
            value = value.get(k)
            if value is None:
                return default

        return value

    def set(self, key: str, value: Any) -> None:
        keys = key.split(".")
        target = self._data

        for k in keys[:-1]:
            target = target.setdefault(k, {})

        target[keys[-1]] = value
        self.save()


# ใช้งาน
config = ConfigManager(Path("config.json"))
config.set("app.name", "MyApp")
config.set("app.debug", True)
config.set("database.host", "localhost")

print(config.get("app.name"))       # MyApp
print(config.get("database.host"))  # localhost
```

**ตัวอย่าง — API Response:**

```python
import json
from dataclasses import dataclass, asdict
from typing import Any, Generic, TypeVar

T = TypeVar("T")


@dataclass
class APIResponse(Generic[T]):
    success: bool
    data: T | None = None
    error: str | None = None
    meta: dict[str, Any] | None = None

    def to_json(self) -> str:
        return json.dumps(
            asdict(self),
            ensure_ascii=False,
            default=str,
        )

    @classmethod
    def from_json(cls, json_str: str) -> "APIResponse":
        data = json.loads(json_str)
        return cls(
            success=data["success"],
            data=data.get("data"),
            error=data.get("error"),
            meta=data.get("meta"),
        )


# ใช้งาน
response = APIResponse(
    success=True,
    data={"id": 1, "name": "สมชาย"},
    meta={"page": 1, "total": 100},
)

json_str = response.to_json()
print(json_str)

parsed = APIResponse.from_json(json_str)
print(parsed.data)
```

### 8.7.4 ข้อดี

- **Universal:** ทุกภาษา/แพลตฟอร์ม
- **Human-readable:** อ่านได้
- **Standard:** RFC 8259
- **Simple:** ง่าย
- **Built-in:** ไม่ต้อง library

### 8.7.5 ข้อเสีย

- **No comments:** JSON ไม่รองรับ
- **Limited types:** ไม่มี datetime, binary
- **No schema:** ไม่มี validation
- **Size:** กินพื้นที่
- **Parsing:** ช้ากว่า binary

### 8.7.6 ข้อควรระวัง

```python
# ระวัง 1: Unicode
# ❌ \uXXXX
json.dumps({"name": "สมชาย"})
# {"name": "\u0e2a\u0e21\u0e0a\u0e32\u0e22"}

# ✅
json.dumps({"name": "สมชาย"}, ensure_ascii=False)
# {"name": "สมชาย"}

# ระวัง 2: Non-serializable
# ❌
json.dumps({"date": datetime.now()})  # TypeError

# ✅
json.dumps({"date": datetime.now()}, default=str)

# ระวัง 3: NaN / Infinity
# ❌ ไม่ standard
json.dumps({"value": float("nan")})  # NaN

# ✅
json.dumps({"value": float("nan")}, allow_nan=False)  # error

# หรือจัดการก่อน
def safe_float(v):
    if v != v:  # NaN
        return None
    return v

# ระวัง 4: Circular reference
# ❌
data = {}
data["self"] = data
json.dumps(data)  # ValueError: Circular reference

# ระวัง 5: Float precision
json.dumps({"price": 0.1 + 0.2})
# {"price": 0.30000000000000004}

# ✅ ใช้ string สำหรับเงิน
json.dumps({"price": "0.30"})

# ระวัง 6: Integer keys
# ❌ JSON keys ต้องเป็น string
json.dumps({1: "a", 2: "b"})
# {"1": "a", "2": "b"}

# ระวัง 7: Large files
# ❌
with open("huge.json") as f:
    data = json.load(f)  # โหลดทั้งหมด

# ✅ ใช้ ijson หรือ jsonlines สำหรับไฟล์ใหญ่
```

### 8.7.7 สรุป

**Operations:**

| Operation | Function |
|-----------|----------|
| Python → JSON string | `json.dumps()` |
| JSON string → Python | `json.loads()` |
| Python → File | `json.dump()` |
| File → Python | `json.load()` |

**Best practices:**
- `ensure_ascii=False` สำหรับ Unicode
- `indent=2` สำหรับ human-readable
- `default=str` สำหรับ types พิเศษ
- Custom encoder/decoder สำหรับ domain types
- JSON Lines สำหรับ streaming
- ระวัง circular references
- ใช้ string สำหรับ precision-sensitive

> **อ้างอิงเพิ่มเติม:** [json Documentation](https://docs.python.org/3/library/json.html)

---

## 8.8 XML

### บทนำ

XML (eXtensible Markup Language) เป็น format เก่าแต่ยังใช้ใน enterprise และ SOAP APIs Python มีหลาย modules สำหรับจัดการ XML

### นิยาม

XML คือ markup language ที่ใช้ tags สำหรับ structured data

### 8.8.1 คืออะไร

Modules:
- `xml.etree.ElementTree` — API ง่าย (แนะนำ)
- `xml.dom.minidom` — DOM API
- `xml.sax` — event-based
- `lxml` — third-party, feature-rich

### 8.8.2 ทำงานอย่างไร

ElementTree สร้าง tree ของ Elements:
- `Element` — node
- `SubElement` — child
- `ElementTree` — document

### 8.8.3 การใช้งาน

**Parse XML:**

```python
import xml.etree.ElementTree as ET

xml_str = """
<?xml version="1.0" encoding="UTF-8"?>
<users>
    <user id="1">
        <name>สมชาย</name>
        <email>somchai@email.com</email>
        <age>30</age>
    </user>
    <user id="2">
        <name>สมหญิง</name>
        <email>somying@email.com</email>
        <age>25</age>
    </user>
</users>
"""

# Parse string
root = ET.fromstring(xml_str)

# Parse file
# tree = ET.parse("data.xml")
# root = tree.getroot()

print(root.tag)  # users

# วนซ้ำ
for user in root.findall("user"):
    user_id = user.get("id")
    name = user.find("name").text
    email = user.find("email").text
    age = user.find("age").text
    print(f"{user_id}: {name} ({email}), age {age}")
```

**สร้าง XML:**

```python
import xml.etree.ElementTree as ET

root = ET.Element("users")

for i, (name, email, age) in enumerate([
    ("สมชาย", "somchai@email.com", 30),
    ("สมหญิง", "somying@email.com", 25),
], start=1):
    user = ET.SubElement(root, "user", id=str(i))
    ET.SubElement(user, "name").text = name
    ET.SubElement(user, "email").text = email
    ET.SubElement(user, "age").text = str(age)

# สร้าง XML string
ET.indent(root, space="  ")
xml_str = ET.tostring(root, encoding="unicode")
print(xml_str)

# เขียนไฟล์
tree = ET.ElementTree(root)
ET.indent(tree, space="  ")
tree.write("users.xml", encoding="utf-8", xml_declaration=True)
```

**XPath-like Queries:**

```python
import xml.etree.ElementTree as ET

xml_str = """
<library>
    <book category="fiction">
        <title lang="en">Harry Potter</title>
        <price>29.99</price>
    </book>
    <book category="tech">
        <title lang="en">Python Guide</title>
        <price>49.99</price>
    </book>
    <book category="tech">
        <title lang="en">Clean Code</title>
        <price>39.99</price>
    </book>
</library>
"""

root = ET.fromstring(xml_str)

# findall — หา child
titles = root.findall("book/title")
for title in titles:
    print(title.text)

# ด้วย attribute
tech_books = root.findall("book[@category='tech']")
for book in tech_books:
    print(book.find("title").text)

# find — หาตัวแรก
first_book = root.find("book")

# iter — วนซ้ำทุก element
for title in root.iter("title"):
    print(title.text, title.get("lang"))

# XPath
# .// — descendant
titles = root.findall(".//title")

# [@attr] — มี attribute
books = root.findall(".//book[@category]")

# [@attr='value']
tech = root.findall(".//book[@category='tech']")

# [position]
first = root.findall(".//book[1]")
```

**Namespaces:**

```python
import xml.etree.ElementTree as ET

xml_str = """
<root xmlns:ns="http://example.com/ns">
    <ns:item>Value 1</ns:item>
    <ns:item>Value 2</ns:item>
</root>
"""

root = ET.fromstring(xml_str)

# ใช้ namespace map
ns = {"ns": "http://example.com/ns"}

for item in root.findall("ns:item", ns):
    print(item.text)
```

**Modify XML:**

```python
import xml.etree.ElementTree as ET

xml_str = "<root><item>old</item></root>"
root = ET.fromstring(xml_str)

# แก้ text
item = root.find("item")
item.text = "new"

# แก้ attribute
item.set("updated", "true")

# ลบ
root.remove(item)

# เพิ่ม
new_item = ET.SubElement(root, "new")
new_item.text = "value"

print(ET.tostring(root, encoding="unicode"))
```

**Pretty Print:**

```python
import xml.etree.ElementTree as ET
from xml.dom import minidom


def prettify(elem: ET.Element) -> str:
    """Pretty print XML"""
    rough = ET.tostring(elem, encoding="unicode")
    parsed = minidom.parseString(rough)
    return parsed.toprettyxml(indent="  ")


# หรือ Python 3.9+
root = ET.fromstring("<root><a>1</a></root>")
ET.indent(root, space="  ")
print(ET.tostring(root, encoding="unicode"))
```

**ตัวอย่างการใช้งานจริง — RSS Feed Parser:**

```python
import xml.etree.ElementTree as ET
import urllib.request
from dataclasses import dataclass
from datetime import datetime


@dataclass
class FeedItem:
    title: str
    link: str
    description: str
    pub_date: str | None = None


def parse_rss(xml_content: str) -> list[FeedItem]:
    """Parse RSS feed"""
    root = ET.fromstring(xml_content)
    items = []

    channel = root.find("channel")
    if channel is None:
        return items

    for item in channel.findall("item"):
        title = item.findtext("title", "")
        link = item.findtext("link", "")
        desc = item.findtext("description", "")
        pub_date = item.findtext("pubDate")

        items.append(FeedItem(
            title=title.strip(),
            link=link.strip(),
            description=desc.strip(),
            pub_date=pub_date,
        ))

    return items


# ใช้งาน
# url = "https://example.com/feed.xml"
# with urllib.request.urlopen(url) as response:
#     content = response.read().decode("utf-8")
# items = parse_rss(content)
```

**ตัวอย่าง — Config XML:**

```python
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Any


class XMLConfig:
    """Config จาก XML"""

    def __init__(self, path: Path):
        self.path = path
        self.tree = ET.parse(path)
        self.root = self.tree.getroot()

    def get(self, path: str, default: Any = None) -> Any:
        """ดึงค่าด้วย path เช่น 'database/host'"""
        parts = path.split("/")
        node = self.root

        for part in parts:
            node = node.find(part)
            if node is None:
                return default

        return node.text or default

    def get_attr(self, path: str, attr: str, default: Any = None) -> Any:
        parts = path.split("/")
        node = self.root

        for part in parts:
            node = node.find(part)
            if node is None:
                return default

        return node.get(attr, default)

    def set(self, path: str, value: str) -> None:
        parts = path.split("/")
        node = self.root

        for part in parts[:-1]:
            child = node.find(part)
            if child is None:
                child = ET.SubElement(node, part)
            node = child

        target = node.find(parts[-1])
        if target is None:
            target = ET.SubElement(node, parts[-1])
        target.text = value

    def save(self) -> None:
        ET.indent(self.tree, space="  ")
        self.tree.write(self.path, encoding="utf-8", xml_declaration=True)


# ใช้งาน
# config = XMLConfig(Path("config.xml"))
# print(config.get("database/host"))
# config.set("database/port", "5432")
# config.save()
```

### 8.8.4 ข้อดี

- **Standard:** W3C standard
- **Schema:** XSD validation
- **Namespaces:** จัดการ conflicts
- **Transform:** XSLT
- **Enterprise:** ใช้ใน SOAP, config

### 8.8.5 ข้อเสีย

- **Verbose:** เยอะกว่า JSON
- **Parsing:** ช้ากว่า JSON
- **Security:** XXE attacks
- **Complexity:** API ซับซ้อน

### 8.8.6 ข้อควรระวัง

```python
# ระวัง 1: XXE Attack (XML External Entity)
# ❌ vulnerable
import xml.etree.ElementTree as ET
tree = ET.parse("untrusted.xml")  # ❌ อาจอ่านไฟล์ระบบ

# ✅ ElementTree ไม่รองรับ external entities โดย default
# แต่ใช้ defusedxml สำหรับความปลอดภัย

from defusedxml import ElementTree as DefusedET
tree = DefusedET.parse("untrusted.xml")

# ระวัง 2: Billion Laughs Attack
# ❌ XML entity expansion
# ✅ ใช้ defusedxml

# ระวัง 3: find() return None
# ❌
root = ET.fromstring("<root/>")
name = root.find("user/name").text  # ❌ AttributeError

# ✅
user = root.find("user/name")
name = user.text if user is not None else ""

# ระวัง 4: Encoding
# ระบุ encoding ชัดเจน
tree.write("file.xml", encoding="utf-8", xml_declaration=True)

# ระวัง 5: Namespace
# ต้องใช้ namespace map
root.findall("item")          # ❌ ไม่เจอถ้ามี namespace
root.findall("ns:item", ns)   # ✅

# ระวัง 6: Large files
# ElementTree โหลดทั้งหมดใน memory
# ใช้ iterparse สำหรับไฟล์ใหญ่

def parse_large_xml(path):
    for event, elem in ET.iterparse(path, events=("end",)):
        if elem.tag == "item":
            yield process(elem)
            elem.clear()  # ✅ ลด memory
```

### 8.8.7 สรุป

**Modules:**

| Module | ใช้ |
|--------|-----|
| `ElementTree` | ทั่วไป (แนะนำ) |
| `minidom` | DOM API |
| `sax` | Streaming events |
| `lxml` | Feature-rich |
| `defusedxml` | Secure parsing |

**Best practices:**
- ใช้ `defusedxml` สำหรับ untrusted
- `iterparse` สำหรับไฟล์ใหญ่
- ระวัง namespaces
- ตรวจสอบ `None` จาก `find()`
- ระบุ encoding
- `ET.indent()` สำหรับ pretty print

> **อ้างอิงเพิ่มเติม:** [xml.etree.ElementTree](https://docs.python.org/3/library/xml.etree.elementtree.html), [defusedxml](https://github.com/tiran/defusedxml)

---

## 8.9 YAML

### บทนำ

YAML (YAML Ain't Markup Language) เป็น format ที่อ่านง่ายมาก นิยมใน config files และ CI/CD

### นิยาม

YAML คือ human-friendly data serialization format ใช้ indentation

### 8.9.1 คืออะไร

ต้องติดตั้ง `PyYAML`:
```bash
pip install pyyaml
```

### 8.9.2 ทำงานอย่างไร

YAML → Python:
- mapping → dict
- sequence → list
- scalar → str, int, float, bool, None

### 8.9.3 การใช้งาน

**พื้นฐาน:**

```python
import yaml

# YAML string
yaml_str = """
name: สมชาย
age: 30
skills:
  - python
  - sql
address:
  city: กรุงเทพ
  country: ไทย
active: true
salary: null
"""

# Parse
data = yaml.safe_load(yaml_str)
print(data)
# {'name': 'สมชาย', 'age': 30, 'skills': ['python', 'sql'],
#  'address': {'city': 'กรุงเทพ', 'country': 'ไทย'},
#  'active': True, 'salary': None}

# Serialize
yaml_str = yaml.safe_dump(data, allow_unicode=True)
print(yaml_str)
```

**อ่าน/เขียนไฟล์:**

```python
import yaml

# อ่าน
with open("config.yaml", encoding="utf-8") as f:
    config = yaml.safe_load(f)

# เขียน
with open("config.yaml", "w", encoding="utf-8") as f:
    yaml.safe_dump(
        config,
        f,
        allow_unicode=True,
        default_flow_style=False,
        sort_keys=False,
    )
```

**`safe_load` vs `load`:**

```python
# ❌ load — อันตราย (รันโค้ดได้)
data = yaml.load(untrusted_yaml)  # ⚠️

# ✅ safe_load — ปลอดภัย
data = yaml.safe_load(untrusted_yaml)

# safe_load รองรับ types ปกติเท่านั้น:
# str, int, float, bool, None, list, dict
```

**Custom Tags:**

```python
import yaml
from datetime import datetime


# Register custom constructor
def construct_datetime(loader, node):
    value = loader.construct_scalar(node)
    return datetime.fromisoformat(value)


yaml.SafeLoader.add_constructor(
    "!datetime",
    construct_datetime,
)


# Register custom representer
def represent_datetime(dumper, data):
    return dumper.represent_scalar(
        "!datetime",
        data.isoformat(),
    )


yaml.SafeDumper.add_representer(
    datetime,
    represent_datetime,
)


# ใช้งาน
yaml_str = """
event: Meeting
time: !datetime 2024-01-01T10:00:00
"""

data = yaml.safe_load(yaml_str)
print(data["time"])  # datetime
print(type(data["time"]))

# Serialize
yaml_str = yaml.safe_dump(data, allow_unicode=True)
```

**Multiple Documents:**

```python
import yaml

yaml_str = """
name: doc1
value: 1
---
name: doc2
value: 2
"""

# อ่านหลาย documents
docs = list(yaml.safe_load_all(yaml_str))
for doc in docs:
    print(doc)

# เขียนหลาย documents
with open("multi.yaml", "w") as f:
    yaml.safe_dump_all(docs, f)
```

**Anchors และ Aliases:**

```python
import yaml

yaml_str = """
defaults: &defaults
  timeout: 30
  retries: 3

service_a:
  <<: *defaults
  url: https://api-a.example.com

service_b:
  <<: *defaults
  url: https://api-b.example.com
  timeout: 60
"""

data = yaml.safe_load(yaml_str)
print(data)
# {'defaults': {'timeout': 30, 'retries': 3},
#  'service_a': {'timeout': 30, 'retries': 3, 'url': '...'},
#  'service_b': {'timeout': 60, 'retries': 3, 'url': '...'}}
```

**ตัวอย่างการใช้งานจริง — Config Loader:**

```python
import yaml
from pathlib import Path
from typing import Any


class Config:
    """Config จาก YAML"""

    def __init__(self, path: Path):
        self.path = path
        self._data: dict[str, Any] = {}
        self.load()

    def load(self) -> None:
        if not self.path.exists():
            raise FileNotFoundError(f"ไม่พบไฟล์: {self.path}")

        with self.path.open(encoding="utf-8") as f:
            self._data = yaml.safe_load(f) or {}

    def get(self, path: str, default: Any = None) -> Any:
        """ดึงค่าด้วย dotted path"""
        keys = path.split(".")
        value: Any = self._data

        for key in keys:
            if not isinstance(value, dict):
                return default
            value = value.get(key)
            if value is None:
                return default

        return value

    def __repr__(self) -> str:
        return f"Config({self._data})"


# config.yaml:
# app:
#   name: MyApp
#   version: 1.0.0
#   debug: false
# database:
#   host: localhost
#   port: 5432
#   name: mydb
# logging:
#   level: INFO
#   file: logs/app.log

# ใช้งาน
config = Config(Path("config.yaml"))
print(config.get("app.name"))         # MyApp
print(config.get("database.port"))    # 5432
print(config.get("logging.level"))    # INFO
```

**ตัวอย่าง — CI/CD Config:**

```python
import yaml
from dataclasses import dataclass, field
from pathlib import Path


@dataclass
class Step:
    name: str
    run: str
    env: dict[str, str] = field(default_factory=dict)


@dataclass
class Job:
    name: str
    steps: list[Step]
    runs_on: str = "ubuntu-latest"


def parse_pipeline(path: Path) -> list[Job]:
    """Parse YAML pipeline"""
    with path.open(encoding="utf-8") as f:
        data = yaml.safe_load(f)

    jobs = []
    for job_name, job_data in data.get("jobs", {}).items():
        steps = [
            Step(
                name=s["name"],
                run=s["run"],
                env=s.get("env", {}),
            )
            for s in job_data.get("steps", [])
        ]
        jobs.append(Job(
            name=job_name,
            steps=steps,
            runs_on=job_data.get("runs-on", "ubuntu-latest"),
        ))

    return jobs


# ใช้งาน
jobs = parse_pipeline(Path(".github/workflows/ci.yaml"))
for job in jobs:
    print(f"Job: {job.name} ({job.runs_on})")
    for step in job.steps:
        print(f"  - {step.name}")
```

### 8.9.4 ข้อดี

- **Readable:** อ่านง่ายมาก
- **Comments:** รองรับ
- **Anchors:** DRY
- **Multi-doc:** หลาย documents
- **Config-friendly:** นิยม

### 8.9.5 ข้อเสีย

- **Indentation:** sensitive มาก
- **Parsing:** ช้า
- **Security:** `load()` อันตราย
- **Complexity:** spec เยอะ
- **Ambiguity:** บางอย่างกำกวม

### 8.9.6 ข้อควรระวัง

```python
# ระวัง 1: ใช้ load() แทน safe_load()
# ❌ อันตราย
data = yaml.load(untrusted_yaml)

# ✅
data = yaml.safe_load(untrusted_yaml)

# ระวัง 2: Indentation
# ❌ ใช้ tab
# key:
# \tvalue

# ✅ ใช้ spaces (2 หรือ 4)
# key:
#   value

# ระวัง 3: Special characters
# ❌
name: "John: Doe"  # : ใน string
# ✅
name: "John: Doe"  # quote

# ระวัง 4: Yes/No/On/Off
# YAML 1.1 ตีความเป็น boolean
active: yes   # → True
active: no    # → False
active: on    # → True
active: off   # → False

# ถ้าต้องการ string ต้อง quote
active: "yes"  # → "yes"

# ระวัง 5: Norwegian problem
country: NO  # → False (Norway)
country: "NO"  # → "NO"

# ระวัง 6: Large files
# yaml.safe_load โหลดทั้งหมด
# ไม่มี streaming parser ที่ดี

# ระวัง 7: Duplicate keys
# YAML ไม่ error แต่ใช้ค่าสุดท้าย
key: value1
key: value2  # → value2
```

### 8.9.7 สรุป

**ใช้ `yaml.safe_load()` และ `yaml.safe_dump()` เสมอ**

**Types:**

| YAML | Python |
|------|--------|
| mapping | dict |
| sequence | list |
| scalar | str/int/float/bool/None |

**Best practices:**
- `safe_load()` / `safe_dump()`
- `allow_unicode=True`
- ใช้ spaces ไม่ใช่ tabs
- Quote strings ที่มี special chars
- ระวัง yes/no/on/off
- ระวัง duplicate keys

> **อ้างอิงเพิ่มเติม:** [PyYAML Documentation](https://pyyaml.org/wiki/PyYAMLDocumentation)

---

## 8.10 TOML

### บทนำ

TOML (Tom's Obvious Minimal Language) เป็น format config ที่ชัดเจนและอ่านง่าย นิยมใน `pyproject.toml`

### นิยาม

TOML คือ config format ที่มี syntax ชัดเจน ใช้ `[section]` และ `key = value`

### 8.10.1 คืออะไร

Python 3.11+ มี `tomllib` built-in สำหรับอ่าน สำหรับเขียนต้องใช้ `tomli-w`

```bash
pip install tomli-w  # สำหรับเขียน (Python < 3.11)
pip install tomli    # สำหรับอ่าน (Python < 3.11)
```

### 8.10.2 ทำงานอย่างไร

TOML → Python:
- table → dict
- array → list
- string, integer, float, boolean, datetime

### 8.10.3 การใช้งาน

**อ่าน TOML:**

```python
# Python 3.11+
import tomllib

with open("config.toml", "rb") as f:
    config = tomllib.load(f)

# Python < 3.11
# import tomli
# with open("config.toml", "rb") as f:
#     config = tomli.load(f)

print(config)
```

**เขียน TOML:**

```python
import tomli_w

data = {
    "app": {
        "name": "MyApp",
        "version": "1.0.0",
        "debug": False,
    },
    "database": {
        "host": "localhost",
        "port": 5432,
        "name": "mydb",
    },
    "logging": {
        "level": "INFO",
        "file": "logs/app.log",
    },
}

with open("config.toml", "wb") as f:
    tomli_w.dump(data, f)
```

**Syntax:**

```toml
# config.toml

# Comments
# ใช้ # สำหรับ comment

# String
name = "MyApp"
path = 'C:\Users\name'  # literal string

# Multi-line
description = """
Line 1
Line 2
"""

# Integer
port = 8080
hex = 0xDEADBEEF
oct = 0o755
binary = 0b11010110

# Float
pi = 3.14159
scientific = 1e-9
infinity = inf
nan = nan

# Boolean
debug = true
verbose = false

# Date/Time
date = 2024-01-01
time = 12:00:00
datetime = 2024-01-01T12:00:00Z

# Array
tags = ["python", "toml", "config"]
numbers = [1, 2, 3]

# Multi-line array
dependencies = [
    "requests>=2.31.0",
    "click>=8.1.0",
]

# Table
[database]
host = "localhost"
port = 5432

# Nested table
[database.credentials]
username = "admin"
password = "secret"

# Array of tables
[[servers]]
name = "server1"
ip = "192.168.1.1"

[[servers]]
name = "server2"
ip = "192.168.1.2"

# Inline table
point = { x = 1, y = 2 }

# Dotted keys
app.name = "MyApp"
app.version = "1.0.0"
```

**pyproject.toml:**

```toml
[build-system]
requires = ["setuptools>=68", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "my-package"
version = "0.1.0"
description = "A sample package"
readme = "README.md"
requires-python = ">=3.10"
license = {text = "MIT"}
authors = [
    {name = "Author", email = "author@example.com"}
]
dependencies = [
    "requests>=2.31.0",
    "click>=8.1.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "ruff>=0.1.0",
]

[project.scripts]
my-cli = "my_package.cli:main"

[tool.ruff]
line-length = 88
target-version = "py310"

[tool.ruff.lint]
select = ["E", "F", "I", "N"]

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v --cov=src"
```

**ตัวอย่างการใช้งานจริง — Config Manager:**

```python
import tomllib
from pathlib import Path
from typing import Any

try:
    import tomli_w
    HAS_WRITER = True
except ImportError:
    HAS_WRITER = False


class TOMLConfig:
    """Config จาก TOML"""

    def __init__(self, path: Path):
        self.path = path
        self._data: dict[str, Any] = {}
        self.load()

    def load(self) -> None:
        if not self.path.exists():
            self._data = {}
            return

        with self.path.open("rb") as f:
            self._data = tomllib.load(f)

    def save(self) -> None:
        if not HAS_WRITER:
            raise RuntimeError("ต้องติดตั้ง tomli-w")

        self.path.parent.mkdir(parents=True, exist_ok=True)

        with self.path.open("wb") as f:
            tomli_w.dump(self._data, f)

    def get(self, path: str, default: Any = None) -> Any:
        keys = path.split(".")
        value: Any = self._data

        for key in keys:
            if not isinstance(value, dict):
                return default
            value = value.get(key)
            if value is None:
                return default

        return value

    def __repr__(self) -> str:
        return f"TOMLConfig({self._data})"


# ใช้งาน
config = TOMLConfig(Path("config.toml"))
print(config.get("database.host"))
print(config.get("app.debug"))
```

**ตัวอย่าง — Project Analyzer:**

```python
import tomllib
from pathlib import Path
from dataclasses import dataclass


@dataclass
class ProjectInfo:
    name: str
    version: str
    description: str
    python_requires: str
    dependencies: list[str]
    dev_dependencies: list[str]


def analyze_project(path: Path) -> ProjectInfo:
    """อ่าน pyproject.toml"""
    with path.open("rb") as f:
        data = tomllib.load(f)

    project = data.get("project", {})
    optional = project.get("optional-dependencies", {})

    return ProjectInfo(
        name=project.get("name", "unknown"),
        version=project.get("version", "0.0.0"),
        description=project.get("description", ""),
        python_requires=project.get("requires-python", ""),
        dependencies=project.get("dependencies", []),
        dev_dependencies=optional.get("dev", []),
    )


# ใช้งาน
info = analyze_project(Path("pyproject.toml"))
print(f"Project: {info.name} v{info.version}")
print(f"Python: {info.python_requires}")
print(f"Dependencies: {len(info.dependencies)}")
for dep in info.dependencies:
    print(f"  - {dep}")
```

### 8.10.4 ข้อดี

- **Clear:** syntax ชัดเจน
- **Typed:** มี types
- **Standard:** Python standard (tomllib)
- **Readable:** อ่านง่าย
- **Config-friendly:** เหมาะกับ config

### 8.10.5 ข้อเสีย

- **New:** ใหม่กว่า JSON/YAML
- **Writer:** ต้อง third-party
- **Limited:** ไม่รองรับทุกอย่าง

### 8.10.6 ข้อควรระวัง

```python
# ระวัง 1: tomllib อ่าน binary mode
# ❌
with open("config.toml", "r") as f:
    data = tomllib.load(f)

# ✅
with open("config.toml", "rb") as f:
    data = tomllib.load(f)

# ระวัง 2: tomllib อ่านเท่านั้น
# ไม่สามารถเขียนด้วย tomllib
# ต้องใช้ tomli-w

# ระวัง 3: Order of keys
# dict ใน Python 3.7+ รักษาลำดับ
# แต่ tomllib อาจไม่

# ระวัง 4: Datetime
# TOML datetime → Python datetime
# ต้องจัดการ timezone

# ระวัง 5: Large files
# ไม่มี streaming
```

### 8.10.7 สรุป

**Operations:**

| Operation | Library |
|-----------|---------|
| อ่าน (3.11+) | `tomllib` |
| อ่าน (<3.11) | `tomli` |
| เขียน | `tomli-w` |

**Best practices:**
- ใช้ `tomllib` (3.11+)
- `tomli-w` สำหรับเขียน
- Binary mode เสมอ
- ใช้ใน `pyproject.toml`
- ระวัง types

> **อ้างอิงเพิ่มเติม:** [tomllib Documentation](https://docs.python.org/3/library/tomllib.html), [TOML Spec](https://toml.io/)

---

## 8.11 INI

### บทนำ

INI เป็น format config เก่าที่เรียบง่าย ใช้ `[section]` และ `key = value` Python มี `configparser` built-in

### นิยาม

INI คือ config format ที่แบ่งเป็น sections แต่ละ section มี key-value pairs

### 8.11.1 คืออะไร

`configparser` ให้ API สำหรับอ่าน/เขียน INI

### 8.11.2 ทำงานอย่างไร

INI → Python:
- `[section]` → dict
- `key = value` → key-value

### 8.11.3 การใช้งาน

**อ่าน INI:**

```python
import configparser

config = configparser.ConfigParser()
config.read("config.ini", encoding="utf-8")

# ดู sections
print(config.sections())  # ['database', 'logging']

# อ่านค่า
print(config["database"]["host"])       # localhost
print(config.get("database", "port"))   # 5432

# ด้วย fallback
print(config.get("database", "timeout", fallback=30))

# Type conversion
port = config.getint("database", "port")
timeout = config.getfloat("app", "timeout")
debug = config.getboolean("app", "debug")
```

**config.ini:**

```ini
[database]
host = localhost
port = 5432
name = mydb
user = admin

[logging]
level = INFO
file = logs/app.log
format = %(asctime)s - %(message)s

[app]
debug = true
timeout = 30.5
max_retries = 3
```

**เขียน INI:**

```python
import configparser

config = configparser.ConfigParser()

config["database"] = {
    "host": "localhost",
    "port": "5432",
    "name": "mydb",
}

config["logging"] = {
    "level": "INFO",
    "file": "logs/app.log",
}

with open("config.ini", "w", encoding="utf-8") as f:
    config.write(f)
```

**Default Section:**

```python
import configparser

config = configparser.ConfigParser()

# ค่า default ที่ทุก section มี
config["DEFAULT"] = {
    "timeout": "30",
    "retries": "3",
}

config["database"] = {
    "host": "localhost",
}

config["cache"] = {
    "host": "redis",
    "timeout": "60",  # override default
}

# ทุก section มี timeout และ retries
print(config["database"]["timeout"])  # 30
print(config["cache"]["timeout"])     # 60
```

**Interpolation:**

```python
import configparser

config = configparser.ConfigParser()
config.read_string("""
[paths]
home = /home/user
data = %(home)s/data
logs = %(home)s/logs
""")

print(config["paths"]["data"])  # /home/user/data
print(config["paths"]["logs"])  # /home/user/logs
```

**ตัวอย่างการใช้งานจริง — App Config:**

```python
import configparser
from pathlib import Path
from dataclasses import dataclass


@dataclass
class DatabaseConfig:
    host: str
    port: int
    name: str
    user: str
    password: str = ""


@dataclass
class AppConfig:
    debug: bool
    log_level: str
    database: DatabaseConfig


def load_config(path: Path) -> AppConfig:
    """โหลด config จาก INI"""
    config = configparser.ConfigParser()
    config.read(path, encoding="utf-8")

    db = DatabaseConfig(
        host=config.get("database", "host"),
        port=config.getint("database", "port"),
        name=config.get("database", "name"),
        user=config.get("database", "user"),
        password=config.get("database", "password", fallback=""),
    )

    return AppConfig(
        debug=config.getboolean("app", "debug", fallback=False),
        log_level=config.get("logging", "level", fallback="INFO"),
        database=db,
    )


# ใช้งาน
# config = load_config(Path("config.ini"))
# print(config.database.host)
# print(config.debug)
```

### 8.11.4 ข้อดี

- **Simple:** ง่ายมาก
- **Built-in:** ไม่ต้อง library
- **Widely used:** ระบบเก่า
- **Human-readable:** อ่านได้

### 8.11.5 ข้อเสีย

- **Limited:** ไม่รองรับ nested
- **No types:** ทุกอย่างเป็น string
- **Ambiguous:** spec ไม่ชัด
- **Old:** format เก่า

### 8.11.6 ข้อควรระวัง

```python
# ระวัง 1: ทุกอย่างเป็น string
# ❌
port = config["database"]["port"]  # "5432"
port + 1  # ❌ TypeError

# ✅
port = config.getint("database", "port")

# ระวัง 2: Case sensitivity
# keys เป็น lowercase โดย default
config = configparser.ConfigParser()
config.optionxform = str  # เก็บ case

# ระวัง 3: Interpolation
# อาจ error ถ้า key ไม่มี
# ปิด interpolation ได้
config = configparser.ConfigParser(interpolation=None)

# ระวัง 4: Default section
# [DEFAULT] ถูก inherit ทุก section

# ระวัง 5: Comments
# ; และ # เป็น comments
# แต่ inline comments อาจไม่ทำงาน
key = value ; comment  # อาจไม่ comment

# ระวัง 6: Empty values
# key =  → ""
# key = "" → '""'
```

### 8.11.7 สรุป

**ใช้ INI เมื่อ:**
- Config ง่าย ๆ
- ระบบเก่า
- ไม่ต้องการ nested
- Human edit

**Best practices:**
- ใช้ `getint`, `getfloat`, `getboolean`
- `fallback` สำหรับ optional
- `encoding="utf-8"`
- ระวัง interpolation
- พิจารณา TOML สำหรับโปรเจกต์ใหม่

> **อ้างอิงเพิ่มเติม:** [configparser Documentation](https://docs.python.org/3/library/configparser.html)

---

## 8.12 Pickle

### บทนำ

Pickle เป็น Python-specific serialization format ที่ serialize objects ได้เกือบทุกอย่าง แต่มีข้อควรระวังด้านความปลอดภัย

### นิยาม

Pickle คือ binary protocol สำหรับ serialize/deserialize Python objects

### 8.12.1 คืออะไร

Pickle รองรับ:
- Built-in types
- Classes/functions (reference)
- Nested structures
- Cycles

### 8.12.2 ทำงานอย่างไร

- `pickle.dump()` / `pickle.load()` — ไฟล์
- `pickle.dumps()` / `pickle.loads()` — bytes

### 8.12.3 การใช้งาน

**พื้นฐาน:**

```python
import pickle

data = {
    "name": "สมชาย",
    "age": 30,
    "scores": [85, 92, 78],
    "metadata": {"active": True, "level": 5},
}

# Serialize to bytes
serialized = pickle.dumps(data)
print(type(serialized))  # <class 'bytes'>

# Deserialize
loaded = pickle.loads(serialized)
print(loaded == data)  # True
```

**ไฟล์:**

```python
import pickle

data = {"key": "value", "numbers": [1, 2, 3]}

# เขียน
with open("data.pkl", "wb") as f:
    pickle.dump(data, f)

# อ่าน
with open("data.pkl", "rb") as f:
    loaded = pickle.load(f)

print(loaded)
```

**Protocols:**

```python
import pickle

data = {"key": "value"}

# Protocol versions
# 0 — ASCII (เก่าสุด)
# 1 — binary เก่า
# 2 — Python 2.3+
# 3 — Python 3.0+
# 4 — Python 3.4+
# 5 — Python 3.8+

# ใช้ protocol สูงสุด
serialized = pickle.dumps(data, protocol=pickle.HIGHEST_PROTOCOL)
```

**Classes:**

```python
import pickle
from dataclasses import dataclass


@dataclass
class User:
    id: int
    name: str
    email: str


user = User(1, "สมชาย", "somchai@email.com")

# Serialize
with open("user.pkl", "wb") as f:
    pickle.dump(user, f)

# Deserialize
with open("user.pkl", "rb") as f:
    loaded = pickle.load(f)

print(loaded)
print(type(loaded))  # <class '__main__.User'>
```

**Custom `__reduce__`:**

```python
import pickle


class Connection:
    """Object ที่ต้องการ custom serialization"""

    def __init__(self, host: str, port: int):
        self.host = host
        self.port = port
        self.connected = False

    def connect(self):
        self.connected = True

    def __getstate__(self):
        """ระบุ state ที่จะ serialize"""
        state = self.__dict__.copy()
        # ไม่ serialize connection state
        state["connected"] = False
        return state

    def __setstate__(self, state):
        """กำหนดวิธี restore state"""
        self.__dict__.update(state)
        # restore เฉพาะ field
        if self.connected:
            self.connect()


conn = Connection("localhost", 5432)
conn.connect()
data = pickle.dumps(conn)
restored = pickle.loads(data)
print(restored.connected)  # False (ไม่ serialize)
```

**`__reduce__` สำหรับ custom:**

```python
import pickle


class Point:
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y

    def __reduce__(self):
        # (callable, args)
        return (Point, (self.x, self.y))

    def __repr__(self):
        return f"Point({self.x}, {self.y})"


p = Point(1, 2)
data = pickle.dumps(p)
restored = pickle.loads(data)
print(restored)  # Point(1, 2)
```

**ตัวอย่างการใช้งานจริง — Cache:**

```python
import pickle
import hashlib
from pathlib import Path
from functools import wraps
from typing import Callable, TypeVar

F = TypeVar("F", bound=Callable)


def disk_cache(cache_dir: Path):
    """Decorator ที่ cache ผลลัพธ์ลง disk"""
    cache_dir.mkdir(parents=True, exist_ok=True)

    def decorator(func: F) -> F:
        @wraps(func)
        def wrapper(*args, **kwargs):
            # สร้าง cache key
            key_data = pickle.dumps((args, kwargs))
            key = hashlib.sha256(key_data).hexdigest()
            cache_file = cache_dir / f"{func.__name__}_{key}.pkl"

            # ลองอ่านจาก cache
            if cache_file.exists():
                try:
                    with cache_file.open("rb") as f:
                        return pickle.load(f)
                except (pickle.PickleError, EOFError):
                    pass

            # คำนวณ
            result = func(*args, **kwargs)

            # บันทึก
            with cache_file.open("wb") as f:
                pickle.dump(result, f)

            return result

        return wrapper  # type: ignore
    return decorator


# ใช้งาน
@disk_cache(Path(".cache"))
def expensive_computation(n: int) -> list[int]:
    print(f"Computing for {n}...")
    return [i ** 2 for i in range(n)]


print(expensive_computation(1000))  # Computing...
print(expensive_computation(1000))  # (จาก cache)
```

### 8.12.4 ข้อดี

- **Powerful:** serialize ได้เกือบทุกอย่าง
- **Fast:** เร็วกว่า JSON/XML
- **Compact:** binary format
- **Python-native:** รองรับ classes

### 8.12.5 ข้อเสีย

- **Security:** อันตรายมาก!
- **Python-only:** ไม่ cross-language
- **Version:** อาจไม่ compatible
- **Opaque:** อ่านไม่ได้

### 8.12.6 ข้อควรระวัง

```python
# ⚠️⚠️⚠️ อันตรายที่สุด: อย่า unpickle จาก untrusted source
# ❌
import pickle
data = pickle.loads(user_input)  # ❌ รันโค้ดได้!

# ตัวอย่างอันตราย:
# class Evil:
#     def __reduce__(self):
#         import os
#         return (os.system, ("rm -rf /",))

# ✅ ใช้ JSON แทนสำหรับ untrusted data

# ระวัง 1: Version compatibility
# ❌ pickle ข้าม version อาจไม่ compatible
# ✅ ระบุ protocol และ test

# ระวัง 2: Class changes
# ถ้า class เปลี่ยน pickle เก่าอาจใช้ไม่ได้

# ระวัง 3: Large files
# pickle โหลดทั้งหมดใน memory
# ✅ ใช้ pickle streaming (dump หลายครั้ง) สำหรับข้อมูลใหญ่

# ระวัง 4: Functions/lambdas
# ❌ pickle lambda ไม่ได้
# f = lambda x: x * 2
# pickle.dumps(f)  # PicklingError

# ✅ ใช้ named function หรือ dill

# ระวัง 5: File handles, sockets
# ❌ pickle ไม่ได้
# ✅ custom __getstate__/__setstate__

# ระวัง 6: Cross-platform
# binary format อาจต่างกัน
```

### 8.12.7 สรุป

**ใช้ Pickle เมื่อ:**
- Cache ภายใน
- Python-to-Python
- State ที่ซับซ้อน
- Performance

**ไม่ใช้เมื่อ:**
- ข้อมูลจาก untrusted source **⚠️**
- Cross-language
- Long-term storage
- Public data

**Best practices:**
- **อย่า unpickle จาก untrusted source**
- ระบุ `protocol`
- ใช้ `__getstate__`/`__setstate__` สำหรับ custom
- Test ข้าม version
- พิจารณา JSON/MessagePack แทน

> **อ้างอิงเพิ่มเติม:** [pickle Documentation](https://docs.python.org/3/library/pickle.html)

---

## 8.13 Marshal

### บทนำ

`marshal` เป็น internal serialization format ของ Python ใช้สำหรับ `.pyc` files ไม่แนะนำสำหรับ general use

### นิยาม

`marshal` คือ low-level serialization สำหรับ Python objects ที่จำกัด

### 8.13.1 คืออะไร

**ข้อจำกัด:**
- Types จำกัด
- Version-specific
- ไม่ documented fully
- ไม่ security

### 8.13.2 ทำงานอย่างไร

เหมือน pickle แต่ simple กว่า:
- `marshal.dump()` / `marshal.load()`
- `marshal.dumps()` / `marshal.loads()`

### 8.13.3 การใช้งาน

```python
import marshal

# Basic types
data = {
    "name": "สมชาย",
    "age": 30,
    "scores": [85, 92],
    "active": True,
    "salary": None,
}

# Serialize
serialized = marshal.dumps(data)
print(f"Size: {len(serialized)} bytes")

# Deserialize
loaded = marshal.loads(serialized)
print(loaded)

# ไฟล์
with open("data.marshal", "wb") as f:
    marshal.dump(data, f)

with open("data.marshal", "rb") as f:
    loaded = marshal.load(f)
```

**Version:**

```python
import marshal

# ระบุ version
data = marshal.dumps({"key": "value"}, version=4)
```

### 8.13.4 ข้อดี

- **Fast:** เร็วกว่า pickle
- **Compact:** เล็กกว่า
- **Built-in:** standard library

### 8.13.5 ข้อเสีย

- **Limited types:** ไม่รองรับ classes
- **Version-specific:** ไม่ portable
- **Not for general use:** internal เท่านั้น
- **Not secure:** เหมือน pickle

### 8.13.6 ข้อควรระวัง

```python
# ระวัง 1: Types ที่รองรับจำกัด
import marshal

class User:
    pass

# ❌ ไม่รองรับ classes
# marshal.dumps(User())  # ValueError

# รองรับ:
# None, bool, int, float, complex, str, bytes, tuple, list, dict, set, frozenset

# ระวัง 2: Version compatibility
# ❌ marshal ไม่ compatible ข้าม version

# ระวัง 3: Security เหมือน pickle
# ❌ อย่า unmarshal จาก untrusted source

# ระวัง 4: ไม่ใช่ format สาธารณะ
# อาจเปลี่ยนได้ในอนาคต

# แนะนำ: ใช้ pickle หรือ json แทน
```

### 8.13.7 สรุป

**ใช้ marshal เฉพาะ:**
- อ่าน/เขียน `.pyc`
- Internal Python use
- Performance-critical simple data

**ไม่ใช้สำหรับ:**
- General serialization
- Cross-version
- Untrusted data
- Complex objects

**แนะนำ:** ใช้ `pickle` สำหรับ Python objects, `json` สำหรับ interchange

> **อ้างอิงเพิ่มเติม:** [marshal Documentation](https://docs.python.org/3/library/marshal.html)

---

## 8.14 SQLite

### บทนำ

SQLite เป็น embedded database ที่ไม่ต้อง server Python มี `sqlite3` built-in เหมาะกับ local storage, prototypes และ small applications

### นิยาม

SQLite คือ serverless, self-contained, zero-configuration SQL database engine

### 8.14.1 คืออะไร

ข้อดี:
- ไม่ต้อง server
- ไฟล์เดียว
- ACID transactions
- SQL support
- Built-in

### 8.14.2 ทำงานอย่างไร

`sqlite3` module:
- `connect()` — เปิด/สร้าง database
- `cursor()` — execute queries
- `commit()` / `rollback()`
- `close()`

### 8.14.3 การใช้งาน

**พื้นฐาน:**

```python
import sqlite3

# เชื่อมต่อ (สร้างไฟล์ถ้าไม่มี)
conn = sqlite3.connect("database.db")

# Cursor
cursor = conn.cursor()

# สร้าง table
cursor.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        age INTEGER,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
""")

# Insert
cursor.execute(
    "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
    ("สมชาย", "somchai@email.com", 30),
)

# Commit
conn.commit()

# Close
conn.close()
```

**ใช้ `with` (แนะนำ):**

```python
import sqlite3

with sqlite3.connect("database.db") as conn:
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
        ("สมหญิง", "somying@email.com", 25),
    )
    # commit อัตโนมัติเมื่อ exit normally
    # rollback อัตโนมัติเมื่อ exception
```

**Query:**

```python
import sqlite3

with sqlite3.connect("database.db") as conn:
    conn.row_factory = sqlite3.Row  # เข้าถึงด้วยชื่อ column
    cursor = conn.cursor()

    # Select all
    cursor.execute("SELECT * FROM users")
    for row in cursor:
        print(dict(row))
        # {'id': 1, 'name': 'สมชาย', ...}

    # Select one
    cursor.execute(
        "SELECT * FROM users WHERE id = ?",
        (1,),
    )
    user = cursor.fetchone()
    if user:
        print(user["name"])  # สมชาย

    # Select many
    cursor.execute(
        "SELECT * FROM users WHERE age >= ?",
        (18,),
    )
    users = cursor.fetchall()
```

**Parameters (SQL Injection Prevention):**

```python
# ✅ ใช้ placeholders
cursor.execute(
    "SELECT * FROM users WHERE name = ? AND age > ?",
    (name, age),
)

# ✅ Named parameters
cursor.execute(
    "SELECT * FROM users WHERE name = :name AND age > :age",
    {"name": name, "age": age},
)

# ❌ อย่าใช้ string formatting!
# cursor.execute(f"SELECT * FROM users WHERE name = '{name}'")  # ❌ SQL Injection!
```

**Transactions:**

```python
import sqlite3

conn = sqlite3.connect("database.db")

try:
    cursor = conn.cursor()
    cursor.execute("UPDATE accounts SET balance = balance - ? WHERE id = ?", (100, 1))
    cursor.execute("UPDATE accounts SET balance = balance + ? WHERE id = ?", (100, 2))
    conn.commit()
except Exception:
    conn.rollback()
    raise
finally:
    conn.close()
```

**Row Factory:**

```python
import sqlite3
from dataclasses import dataclass


@dataclass
class User:
    id: int
    name: str
    email: str
    age: int


def user_factory(cursor, row):
    """แปลง row เป็น User object"""
    fields = [column[0] for column in cursor.description]
    return User(**dict(zip(fields, row)))


with sqlite3.connect("database.db") as conn:
    conn.row_factory = user_factory
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users")
    for user in cursor:
        print(user.name)
```

**ตัวอย่างการใช้งานจริง — Repository:**

```python
import sqlite3
from dataclasses import dataclass
from pathlib import Path
from typing import Iterator
from contextlib import contextmanager


@dataclass
class User:
    id: int | None
    name: str
    email: str
    age: int


class UserRepository:
    """Repository สำหรับ users"""

    def __init__(self, db_path: Path):
        self.db_path = db_path
        self._init_db()

    @contextmanager
    def _connect(self) -> Iterator[sqlite3.Connection]:
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row
        try:
            yield conn
            conn.commit()
        except Exception:
            conn.rollback()
            raise
        finally:
            conn.close()

    def _init_db(self) -> None:
        with self._connect() as conn:
            conn.execute("""
                CREATE TABLE IF NOT EXISTS users (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT NOT NULL,
                    email TEXT UNIQUE NOT NULL,
                    age INTEGER NOT NULL
                )
            """)

    def create(self, user: User) -> User:
        with self._connect() as conn:
            cursor = conn.execute(
                "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
                (user.name, user.email, user.age),
            )
            user.id = cursor.lastrowid
            return user

    def get_by_id(self, user_id: int) -> User | None:
        with self._connect() as conn:
            row = conn.execute(
                "SELECT * FROM users WHERE id = ?",
                (user_id,),
            ).fetchone()

            if row is None:
                return None
            return User(**dict(row))

    def get_by_email(self, email: str) -> User | None:
        with self._connect() as conn:
            row = conn.execute(
                "SELECT * FROM users WHERE email = ?",
                (email,),
            ).fetchone()
            return User(**dict(row)) if row else None

    def list_all(self) -> list[User]:
        with self._connect() as conn:
            rows = conn.execute("SELECT * FROM users").fetchall()
            return [User(**dict(row)) for row in rows]

    def update(self, user: User) -> bool:
        if user.id is None:
            raise ValueError("user.id ต้องมีค่า")

        with self._connect() as conn:
            cursor = conn.execute(
                "UPDATE users SET name = ?, email = ?, age = ? WHERE id = ?",
                (user.name, user.email, user.age, user.id),
            )
            return cursor.rowcount > 0

    def delete(self, user_id: int) -> bool:
        with self._connect() as conn:
            cursor = conn.execute(
                "DELETE FROM users WHERE id = ?",
                (user_id,),
            )
            return cursor.rowcount > 0


# ใช้งาน
repo = UserRepository(Path("app.db"))

# Create
user = repo.create(User(None, "สมชาย", "somchai@email.com", 30))
print(f"Created: {user.id}")

# Read
found = repo.get_by_id(user.id)
print(found)

# Update
user.age = 31
repo.update(user)

# List
for u in repo.list_all():
    print(u)

# Delete
repo.delete(user.id)
```

**ตัวอย่าง — Migration:**

```python
import sqlite3
from pathlib import Path


class Migration:
    def __init__(self, version: int, sql: str):
        self.version = version
        self.sql = sql


MIGRATIONS = [
    Migration(1, """
        CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL
        )
    """),
    Migration(2, """
        ALTER TABLE users ADD COLUMN email TEXT
    """),
    Migration(3, """
        CREATE INDEX idx_users_email ON users(email)
    """),
]


def migrate(db_path: Path) -> None:
    """Apply migrations"""
    with sqlite3.connect(db_path) as conn:
        # สร้าง migrations table
        conn.execute("""
            CREATE TABLE IF NOT EXISTS schema_migrations (
                version INTEGER PRIMARY KEY,
                applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)

        # ดู version ปัจจุบัน
        cursor = conn.execute(
            "SELECT MAX(version) FROM schema_migrations"
        )
        current = cursor.fetchone()[0] or 0

        # Apply migrations ที่ยังไม่ทำ
        for migration in MIGRATIONS:
            if migration.version <= current:
                continue

            print(f"Applying migration {migration.version}...")
            conn.executescript(migration.sql)
            conn.execute(
                "INSERT INTO schema_migrations (version) VALUES (?)",
                (migration.version,),
            )

        print(f"Database at version {len(MIGRATIONS)}")


# ใช้งาน
migrate(Path("app.db"))
```

### 8.14.4 ข้อดี

- **Serverless:** ไม่ต้อง server
- **File-based:** ง่ายต่อ backup
- **ACID:** transactions
- **SQL:** standard
- **Built-in:** ไม่ต้องติดตั้ง

### 8.14.5 ข้อเสีย

- **Single writer:** เขียนทีละ process
- **Limited concurrency:** ไม่เหมาะ high-traffic
- **No network:** local เท่านั้น
- **Size:** ไม่เหมาะข้อมูลใหญ่มาก

### 8.14.6 ข้อควรระวัง

```python
# ระวัง 1: SQL Injection
# ❌
cursor.execute(f"SELECT * FROM users WHERE name = '{name}'")

# ✅
cursor.execute("SELECT * FROM users WHERE name = ?", (name,))

# ระวัง 2: ลืม commit
# ❌
cursor.execute("INSERT ...")
# conn.commit()  # ลืม → หายเมื่อปิด

# ✅ ใช้ with หรือ commit

# ระวัง 3: Concurrency
# ❌ หลาย threads เขียนพร้อมกัน
# ✅ ใช้ connection per thread หรือ WAL mode

conn.execute("PRAGMA journal_mode=WAL")

# ระวัง 4: Types
# SQLite มี types จำกัด:
# NULL, INTEGER, REAL, TEXT, BLOB

# ระวัง 5: Dates
# ไม่มี date type — เก็บเป็น TEXT
# ✅ ใช้ ISO format
cursor.execute(
    "INSERT INTO events (date) VALUES (?)",
    (datetime.now().isoformat(),),
)

# ระวัง 6: Memory database
# ":memory:" สำหรับ temporary
conn = sqlite3.connect(":memory:")

# ระวัง 7: Connection pooling
# sqlite3 ไม่มี pooling
# ใช้ connection per request
```

### 8.14.7 สรุป

**ใช้ SQLite เมื่อ:**
- Local storage
- Prototypes
- Mobile apps
- Small web apps
- Data analysis
- Testing

**ไม่ใช้เมื่อ:**
- High concurrency
- Network access
- Multi-user
- Large data

**Best practices:**
- ใช้ `?` placeholders
- `with` สำหรับ connection
- `row_factory` สำหรับ named access
- WAL mode สำหรับ concurrency
- ISO format สำหรับ dates
- Migrations

> **อ้างอิงเพิ่มเติม:** [sqlite3 Documentation](https://docs.python.org/3/library/sqlite3.html)

---

## 8.15 Compression

### บทนำ

Python มี modules สำหรับ compression หลายรูปแบบ ตั้งแต่ gzip, bz2, lzma ไปจนถึง zip และ tar

### นิยาม

Compression คือการลดขนาดข้อมูลโดยใช้ algorithms

### 8.15.1 คืออะไร

Modules:
- `zlib`, `gzip` — DEFLATE
- `bz2` — Bzip2
- `lzma` — LZMA/XZ
- `zipfile` — ZIP archives
- `tarfile` — TAR archives

### 8.15.2 ทำงานอย่างไร

| Algorithm | Speed | Ratio | Use |
|-----------|-------|-------|-----|
| zlib/gzip | เร็ว | ดี | ทั่วไป |
| bz2 | ช้า | ดีกว่า | ไฟล์ใหญ่ |
| lzma/xz | ช้าสุด | ดีสุด | เก็บระยะยาว |

### 8.15.3 การใช้งาน

**gzip:**

```python
import gzip

# เขียน
with gzip.open("file.txt.gz", "wt", encoding="utf-8") as f:
    f.write("Hello, World!\n")
    f.write("สวัสดี\n")

# อ่าน
with gzip.open("file.txt.gz", "rt", encoding="utf-8") as f:
    content = f.read()
    print(content)

# Binary
data = b"binary data" * 1000
compressed = gzip.compress(data)
decompressed = gzip.decompress(compressed)
print(f"Original: {len(data)}, Compressed: {len(compressed)}")
```

**bz2:**

```python
import bz2

with bz2.open("file.txt.bz2", "wt", encoding="utf-8") as f:
    f.write("Hello\n")

with bz2.open("file.txt.bz2", "rt", encoding="utf-8") as f:
    print(f.read())

# Bytes
compressed = bz2.compress(b"data" * 1000)
decompressed = bz2.decompress(compressed)
```

**lzma:**

```python
import lzma

with lzma.open("file.txt.xz", "wt", encoding="utf-8") as f:
    f.write("Hello\n")

with lzma.open("file.txt.xz", "rt", encoding="utf-8") as f:
    print(f.read())

# Bytes
compressed = lzma.compress(b"data" * 1000)
decompressed = lzma.decompress(compressed)
```

**zlib (low-level):**

```python
import zlib

data = b"Hello, World!" * 1000

# Compress
compressed = zlib.compress(data, level=9)

# Decompress
decompressed = zlib.decompress(compressed)

# Streaming
compressor = zlib.compressobj(level=6)
decompressor = zlib.decompressobj()

chunks = []
for i in range(0, len(data), 1024):
    chunk = data[i:i+1024]
    chunks.append(compressor.compress(chunk))
chunks.append(compressor.flush())
compressed = b"".join(chunks)
```

**zipfile:**

```python
import zipfile

# สร้าง ZIP
with zipfile.ZipFile("archive.zip", "w", zipfile.ZIP_DEFLATED) as zf:
    zf.write("file1.txt")
    zf.write("file2.txt", arcname="renamed.txt")
    zf.writestr("text.txt", "Hello from string")

# อ่าน ZIP
with zipfile.ZipFile("archive.zip", "r") as zf:
    # ดูรายการ
    for info in zf.infolist():
        print(f"{info.filename}: {info.file_size} bytes")

    # อ่านไฟล์
    content = zf.read("file1.txt")
    print(content)

    # แตกไฟล์ทั้งหมด
    zf.extractall("extracted/")

    # แตกไฟล์เดียว
    zf.extract("file1.txt", "extracted/")
```

**tarfile:**

```python
import tarfile

# สร้าง TAR
with tarfile.open("archive.tar.gz", "w:gz") as tf:
    tf.add("file1.txt")
    tf.add("directory/")
    tf.add("file2.txt", arcname="renamed.txt")

# อ่าน TAR
with tarfile.open("archive.tar.gz", "r:gz") as tf:
    for member in tf.getmembers():
        print(f"{member.name}: {member.size} bytes")

    # แตกไฟล์
    tf.extractall("extracted/")

    # อ่านไฟล์
    f = tf.extractfile("file1.txt")
    if f:
        print(f.read())
```

**ตัวอย่างการใช้งานจริง — Log Rotation:**

```python
import gzip
import shutil
from pathlib import Path
from datetime import datetime


def rotate_log(
    log_file: Path,
    archive_dir: Path,
    keep_days: int = 30,
) -> Path:
    """หมุนและบีบอัด log"""
    archive_dir.mkdir(parents=True, exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    archive_name = archive_dir / f"{log_file.stem}_{timestamp}.log.gz"

    # บีบอัด
    with (
        log_file.open("rb") as f_in,
        gzip.open(archive_name, "wb") as f_out,
    ):
        shutil.copyfileobj(f_in, f_out)

    # ลบไฟล์เดิม
    log_file.unlink()

    # ลบ archives เก่า
    cutoff = datetime.now() - timedelta(days=keep_days)
    for archive in archive_dir.glob("*.log.gz"):
        mtime = datetime.fromtimestamp(archive.stat().st_mtime)
        if mtime < cutoff:
            archive.unlink()

    return archive_name
```

**ตัวอย่าง — Backup System:**

```python
import tarfile
from pathlib import Path
from datetime import datetime


def create_backup(
    source_dir: Path,
    backup_dir: Path,
    compression: str = "gz",
) -> Path:
    """สร้าง backup เป็น tar"""
    backup_dir.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = backup_dir / f"backup_{timestamp}.tar.{compression}"

    mode = f"w:{compression}" if compression != "none" else "w"

    with tarfile.open(backup_file, mode) as tf:
        tf.add(source_dir, arcname=source_dir.name)

    return backup_file


def restore_backup(
    backup_file: Path,
    target_dir: Path,
) -> None:
    """Restore จาก backup"""
    target_dir.mkdir(parents=True, exist_ok=True)

    # ตรวจจับ compression
    if backup_file.suffix == ".gz":
        mode = "r:gz"
    elif backup_file.suffix == ".bz2":
        mode = "r:bz2"
    elif backup_file.suffix == ".xz":
        mode = "r:xz"
    else:
        mode = "r"

    with tarfile.open(backup_file, mode) as tf:
        tf.extractall(target_dir)
```

**ตัวอย่าง — Streaming Compression:**

```python
import gzip
from pathlib import Path
from typing import Iterator


def compress_file(
    src: Path,
    dst: Path,
    chunk_size: int = 8192,
) -> None:
    """บีบอัดไฟล์แบบ streaming — รองรับไฟล์ใหญ่"""
    with (
        src.open("rb") as f_in,
        gzip.open(dst, "wb", compresslevel=6) as f_out,
    ):
        while chunk := f_in.read(chunk_size):
            f_out.write(chunk)


def read_compressed_lines(path: Path) -> Iterator[str]:
    """อ่านบรรทัดจากไฟล์ gzip"""
    with gzip.open(path, "rt", encoding="utf-8") as f:
        yield from f
```

### 8.15.4 ข้อดี

- **ประหยัดพื้นที่:** ลดขนาดไฟล์
- **ประหยัด bandwidth:** ส่งเร็วขึ้น
- **Built-in:** standard library
- **หลาย formats:** เลือกได้

### 8.15.5 ข้อเสีย

- **CPU:** compression ใช้เวลา
- **Random access:** ช้า
- **ไม่ช่วย:** กับข้อมูลที่บีบอัดแล้ว

### 8.15.6 ข้อควรระวัง

```python
# ระวัง 1: เปิด mode ผิด
# ❌ binary mode กับ text
with gzip.open("file.gz", "r") as f:  # bytes
    f.read()  # bytes

# ✅ text mode
with gzip.open("file.gz", "rt", encoding="utf-8") as f:
    f.read()  # str

# ระวัง 2: zip slip
# ❌ extractall กับ untrusted zip
with zipfile.ZipFile(untrusted) as zf:
    zf.extractall()  # ❌ อาจเขียนนอก directory

# ✅ validate paths
def safe_extract(zf, target):
    target = Path(target).resolve()
    for member in zf.namelist():
        member_path = (target / member).resolve()
        if not member_path.is_relative_to(target):
            raise ValueError(f"Unsafe path: {member}")
    zf.extractall(target)

# ระวัง 3: Tarfile security
# ปิด features ที่ไม่ปลอดภัย
tarfile.open(name, mode, filter="data")  # Python 3.12+

# ระวัง 4: Compression level
# ❌ level สูงเกินไป — ช้ามาก
gzip.compress(data, compresslevel=9)

# ✅ สมดุล
gzip.compress(data, compresslevel=6)  # default

# ระวัง 5: Memory
# ❌ อ่านทั้งหมด
data = gzip.open("huge.gz", "rb").read()

# ✅ streaming
with gzip.open("huge.gz", "rb") as f:
    while chunk := f.read(8192):
        process(chunk)
```

### 8.15.7 สรุป

**Formats:**

| Format | Module | Speed | Ratio |
|--------|--------|-------|-------|
| gzip | `gzip` | เร็ว | ดี |
| bz2 | `bz2` | กลาง | ดีกว่า |
| xz | `lzma` | ช้า | ดีสุด |
| zip | `zipfile` | เร็ว | ดี |
| tar | `tarfile` | - | - |

**Best practices:**
- gzip สำหรับทั่วไป
- xz สำหรับเก็บระยะยาว
- Streaming สำหรับไฟล์ใหญ่
- ระวัง security (zip slip)
- ระบุ `encoding`

> **อ้างอิงเพิ่มเติม:** [gzip](https://docs.python.org/3/library/gzip.html), [zipfile](https://docs.python.org/3/library/zipfile.html), [tarfile](https://docs.python.org/3/library/tarfile.html)

---

## 8.16 Zip / Tar / Gzip

### บทนำ

ส่วนนี้เจาะลึก archive formats ทั้งสามที่ใช้บ่อย: ZIP, TAR และ GZIP แต่ละแบบมีข้อดีและ use cases ต่างกัน

### นิยาม

- **ZIP:** archive + compression ในตัว
- **TAR:** archive (รวมไฟล์) — ต้อง compress แยก
- **GZIP:** compress ไฟล์เดียว

### 8.16.1 คืออะไร

| Format | Archive | Compress | Random Access |
|--------|---------|----------|---------------|
| .zip | ✅ | ✅ | ✅ |
| .tar | ✅ | ❌ | ❌ |
| .tar.gz | ✅ | ✅ | ❌ |
| .gz | ❌ | ✅ | ❌ |

### 8.16.2 ทำงานอย่างไร

- **ZIP:** แต่ละไฟล์ compress แยก → random access ได้
- **TAR:** รวมไฟล์ก่อน → compress ทั้งหมด → sequential
- **GZIP:** compress stream

### 8.16.3 การใช้งาน

**ZIP — สร้าง:**

```python
import zipfile
from pathlib import Path

# สร้าง ZIP
with zipfile.ZipFile("archive.zip", "w") as zf:
    # ไฟล์เดียว
    zf.write("file.txt")

    # เปลี่ยนชื่อใน archive
    zf.write("file.txt", arcname="renamed.txt")

    # เขียนจาก string
    zf.writestr("generated.txt", "content")

    # จาก bytes
    zf.writestr("data.bin", b"\x00\x01\x02")

    # Compression
    zf.write("big.txt", compress_type=zipfile.ZIP_DEFLATED)
```

**ZIP — อ่าน:**

```python
import zipfile

with zipfile.ZipFile("archive.zip", "r") as zf:
    # รายการ
    for info in zf.infolist():
        print(f"{info.filename}")
        print(f"  size: {info.file_size}")
        print(f"  compressed: {info.compress_size}")
        print(f"  date: {info.date_time}")
        print(f"  CRC: {info.CRC}")

    # ทดสอบ integrity
    bad = zf.testzip()
    if bad:
        print(f"Corrupted: {bad}")

    # อ่าน
    content = zf.read("file.txt")
    text = zf.read("file.txt").decode("utf-8")

    # อ่านเป็น stream
    with zf.open("big.txt") as f:
        for line in f:
            process(line)

    # แตก
    zf.extract("file.txt", "output/")
    zf.extractall("output/")
```

**TAR — สร้าง:**

```python
import tarfile

# ไม่บีบอัด
with tarfile.open("archive.tar", "w") as tf:
    tf.add("file.txt")
    tf.add("directory/")

# gzip
with tarfile.open("archive.tar.gz", "w:gz") as tf:
    tf.add("file.txt")

# bzip2
with tarfile.open("archive.tar.bz2", "w:bz2") as tf:
    tf.add("file.txt")

# xz
with tarfile.open("archive.tar.xz", "w:xz") as tf:
    tf.add("file.txt")

# เพิ่มจาก bytes
import io

info = tarfile.TarInfo(name="generated.txt")
content = b"Hello"
info.size = len(content)
with tarfile.open("archive.tar", "w") as tf:
    tf.addfile(info, io.BytesIO(content))
```

**TAR — อ่าน:**

```python
import tarfile

with tarfile.open("archive.tar.gz", "r:gz") as tf:
    # รายการ
    for member in tf.getmembers():
        print(f"{member.name}")
        print(f"  size: {member.size}")
        print(f"  type: {'dir' if member.isdir() else 'file'}")
        print(f"  mode: {oct(member.mode)}")
        print(f"  mtime: {member.mtime}")

    # อ่านไฟล์
    f = tf.extractfile("file.txt")
    if f:
        content = f.read()

    # แตก
    tf.extract("file.txt", "output/")
    tf.extractall("output/")

    # filter (Python 3.12+)
    tf.extractall("output/", filter="data")  # ปลอดภัย
```

**GZIP:**

```python
import gzip

# บีบอัดไฟล์เดียว
with open("file.txt", "rb") as f_in:
    with gzip.open("file.txt.gz", "wb") as f_out:
        f_out.write(f_in.read())

# หรือใช้ shutil
import shutil

with open("file.txt", "rb") as f_in:
    with gzip.open("file.txt.gz", "wb") as f_out:
        shutil.copyfileobj(f_in, f_out)

# อ่าน
with gzip.open("file.txt.gz", "rt", encoding="utf-8") as f:
    for line in f:
        print(line.rstrip())
```

**ตัวอย่างการใช้งานจริง — Archive Manager:**

```python
import zipfile
import tarfile
from pathlib import Path
from enum import Enum


class ArchiveType(Enum):
    ZIP = "zip"
    TAR = "tar"
    TAR_GZ = "tar.gz"
    TAR_BZ2 = "tar.bz2"
    TAR_XZ = "tar.xz"
    GZ = "gz"
    UNKNOWN = "unknown"


def detect_archive(path: Path) -> ArchiveType:
    """ตรวจจับประเภท archive จากนามสกุล"""
    name = path.name.lower()

    if name.endswith(".tar.gz") or name.endswith(".tgz"):
        return ArchiveType.TAR_GZ
    if name.endswith(".tar.bz2"):
        return ArchiveType.TAR_BZ2
    if name.endswith(".tar.xz") or name.endswith(".txz"):
        return ArchiveType.TAR_XZ
    if name.endswith(".tar"):
        return ArchiveType.TAR
    if name.endswith(".zip"):
        return ArchiveType.ZIP
    if name.endswith(".gz"):
        return ArchiveType.GZ
    return ArchiveType.UNKNOWN


def list_archive(path: Path) -> list[str]:
    """ดูรายการไฟล์ใน archive"""
    archive_type = detect_archive(path)

    if archive_type == ArchiveType.ZIP:
        with zipfile.ZipFile(path) as zf:
            return zf.namelist()

    if archive_type in (
        ArchiveType.TAR,
        ArchiveType.TAR_GZ,
        ArchiveType.TAR_BZ2,
        ArchiveType.TAR_XZ,
    ):
        with tarfile.open(path) as tf:
            return tf.getnames()

    return []


def extract_archive(
    path: Path,
    target: Path,
    safe: bool = True,
) -> int:
    """แตก archive อย่างปลอดภัย"""
    target = target.resolve()
    target.mkdir(parents=True, exist_ok=True)

    archive_type = detect_archive(path)
    count = 0

    if archive_type == ArchiveType.ZIP:
        with zipfile.ZipFile(path) as zf:
            for member in zf.infolist():
                member_path = (target / member.filename).resolve()

                if safe and not member_path.is_relative_to(target):
                    raise ValueError(f"Unsafe path: {member.filename}")

                zf.extract(member, target)
                count += 1

    elif archive_type in (
        ArchiveType.TAR,
        ArchiveType.TAR_GZ,
        ArchiveType.TAR_BZ2,
        ArchiveType.TAR_XZ,
    ):
        with tarfile.open(path) as tf:
            if safe:
                # Python 3.12+
                tf.extractall(target, filter="data")
            else:
                tf.extractall(target)
            count = len(tf.getmembers())

    return count
```

### 8.16.4 ข้อดี

- **ZIP:** Random access, cross-platform
- **TAR:** เก็บ permissions, Unix-friendly
- **GZIP:** เร็ว, simple
- **Built-in:** standard library

### 8.16.5 ข้อเสีย

- **ZIP:** ไม่เก็บ permissions เต็ม
- **TAR:** Sequential เท่านั้น
- **GZIP:** ไฟล์เดียว

### 8.16.6 ข้อควรระวัง

```python
# ระวัง 1: Zip Slip
# ❌
with zipfile.ZipFile(untrusted) as zf:
    zf.extractall("/output")  # ❌ อาจเขียนนอก

# ✅ validate paths

# ระวัง 2: Tarfile filter
# Python 3.12+
with tarfile.open(path) as tf:
    tf.extractall(filter="data")  # ✅

# Python < 3.12
# ต้อง validate เอง

# ระวัง 3: Memory
# ❌
data = zf.read("huge_file")  # โหลดทั้งหมด

# ✅ streaming
with zf.open("huge_file") as f:
    for chunk in iter(lambda: f.read(8192), b""):
        process(chunk)

# ระวัง 4: Empty directories
# ZIP ไม่เก็บ empty dirs
# TAR เก็บ

# ระวัง 5: Symlinks
# ระวัง symlinks ใน archives
# อ่าน symlink อาจได้ไฟล์นอก archive

# ระวัง 6: Path separators
# ZIP ใช้ / เสมอ
# TAR ใช้ platform-specific

# ระวัง 7: Filename encoding
# ZIP: cp437 (default) หรือ utf-8
# ระบุ encoding
with zipfile.ZipFile(path) as zf:
    zf.extractall(encoding="utf-8")
```

### 8.16.7 สรุป

**เลือก Format:**

| Use | Format |
|-----|--------|
| ทั่วไป, cross-platform | ZIP |
| Unix, permissions | TAR.GZ |
| ไฟล์เดียว | GZIP |
| เก็บระยะยาว | TAR.XZ |
| Windows เท่านั้น | ZIP |

**Best practices:**
- Validate paths (Zip Slip)
- `filter="data"` สำหรับ tarfile
- Streaming สำหรับไฟล์ใหญ่
- ระบุ encoding
- ตรวจสอบ integrity

> **อ้างอิงเพิ่มเติม:** [zipfile](https://docs.python.org/3/library/zipfile.html), [tarfile](https://docs.python.org/3/library/tarfile.html), [gzip](https://docs.python.org/3/library/gzip.html)

---

## 8.17 การอ่านและเขียนไฟล์ขนาดใหญ่

### บทนำ

การจัดการไฟล์ขนาดใหญ่ (GB+) ต้องระวังเรื่อง memory และ performance ต้องใช้ streaming แทนการโหลดทั้งหมด

### นิยาม

Streaming I/O คือการอ่าน/เขียนทีละส่วน (chunk) แทนทั้งหมดในครั้งเดียว

### 8.17.1 คืออะไร

**ปัญหา:**
- ไฟล์ 10GB → RAM 10GB ถ้าอ่านทั้งหมด
- อาจ OOM

**วิธีแก้:**
- อ่านทีละ chunk
- ใช้ generator
- ใช้ mmap

### 8.17.2 ทำงานอย่างไร

Streaming:
1. เปิดไฟล์
2. อ่าน chunk
3. ประมวลผล
4. ไป chunk ถัดไป

Memory = size ของ chunk เท่านั้น

### 8.17.3 การใช้งาน

**อ่านทีละบรรทัด:**

```python
from pathlib import Path
from typing import Iterator


def process_large_text(path: Path) -> dict:
    """อ่านทีละบรรทัด — ประหยัด memory"""
    stats = {"lines": 0, "chars": 0, "words": 0}

    with path.open(encoding="utf-8") as f:
        for line in f:  # ✅ lazy
            stats["lines"] += 1
            stats["chars"] += len(line)
            stats["words"] += len(line.split())

    return stats
```

**อ่านทีละ chunk:**

```python
from pathlib import Path
from typing import Iterator


def read_in_chunks(
    path: Path,
    chunk_size: int = 8192,
) -> Iterator[bytes]:
    """อ่านไฟล์เป็น chunks"""
    with path.open("rb") as f:
        while chunk := f.read(chunk_size):
            yield chunk


# ใช้งาน
total = 0
for chunk in read_in_chunks(Path("huge.bin")):
    total += len(chunk)
print(f"Total: {total:,} bytes")
```

**เขียนทีละ chunk:**

```python
from pathlib import Path
from typing import Iterator


def write_chunks(
    path: Path,
    chunks: Iterator[bytes],
    chunk_size: int = 8192,
) -> int:
    """เขียน chunks ลงไฟล์"""
    total = 0

    with path.open("wb") as f:
        for chunk in chunks:
            f.write(chunk)
            total += len(chunk)

    return total
```

**Copy ไฟล์ใหญ่:**

```python
import shutil
from pathlib import Path


def copy_large_file(src: Path, dst: Path) -> None:
    """คัดลอกไฟล์ใหญ่"""
    # shutil.copyfileobj ทำ streaming ให้
    with src.open("rb") as f_in, dst.open("wb") as f_out:
        shutil.copyfileobj(f_in, f_out, length=1024 * 1024)  # 1MB chunks
```

**Memory-mapped files:**

```python
import mmap
from pathlib import Path


def search_in_large_file(path: Path, pattern: bytes) -> list[int]:
    """ค้นหา pattern ในไฟล์ใหญ่ด้วย mmap"""
    positions = []

    with path.open("rb") as f:
        with mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ) as mm:
            pos = 0
            while True:
                pos = mm.find(pattern, pos)
                if pos == -1:
                    break
                positions.append(pos)
                pos += len(pattern)

    return positions


# mmap เหมาะกับ:
# - Random access
# - ไฟล์ที่ access บ่อย
# - Binary data
```

**Line-by-line processing:**

```python
from pathlib import Path
from typing import Iterator
import csv
import json


def process_jsonl(path: Path) -> Iterator[dict]:
    """อ่าน JSON Lines — streaming"""
    with path.open(encoding="utf-8") as f:
        for line in f:
            if line.strip():
                yield json.loads(line)


def process_csv_large(path: Path) -> Iterator[dict]:
    """อ่าน CSV — streaming"""
    with path.open(encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            yield row


# ใช้งาน — ไม่โหลดทั้งหมด
for record in process_jsonl(Path("huge.jsonl")):
    process(record)
```

**ตัวอย่างการใช้งานจริง — Log Analyzer:**

```python
from pathlib import Path
from collections import Counter
from dataclasses import dataclass
import re


@dataclass
class LogStats:
    total_lines: int
    matched_lines: int
    errors: int
    warnings: int
    top_ips: list[tuple[str, int]]


LOG_PATTERN = re.compile(
    r'(?P<ip>\d+\.\d+\.\d+\.\d+).*?'
    r'\[(?P<level>\w+)\]'
)


def analyze_large_log(path: Path) -> LogStats:
    """วิเคราะห์ log ขนาดใหญ่ — streaming"""
    total = 0
    matched = 0
    errors = 0
    warnings = 0
    ip_counter: Counter[str] = Counter()

    with path.open(encoding="utf-8") as f:
        for line in f:
            total += 1

            match = LOG_PATTERN.search(line)
            if not match:
                continue

            matched += 1
            ip_counter[match["ip"]] += 1

            level = match["level"].upper()
            if level == "ERROR":
                errors += 1
            elif level == "WARNING":
                warnings += 1

    return LogStats(
        total_lines=total,
        matched_lines=matched,
        errors=errors,
        warnings=warnings,
        top_ips=ip_counter.most_common(10),
    )


# ใช้งาน — ไฟล์ 10GB ก็ไม่ OOM
stats = analyze_large_log(Path("app.log"))
print(f"Total: {stats.total_lines:,}")
print(f"Errors: {stats.errors:,}")
```

**ตัวอย่าง — File Splitter:**

```python
from pathlib import Path


def split_file(
    path: Path,
    output_dir: Path,
    max_size: int = 100 * 1024 * 1024,  # 100MB
) -> list[Path]:
    """แบ่งไฟล์ใหญ่เป็นหลายไฟล์"""
    output_dir.mkdir(parents=True, exist_ok=True)
    parts: list[Path] = []

    part_num = 1
    current_size = 0
    current_file = None

    try:
        with path.open("rb") as f_in:
            for chunk in iter(lambda: f_in.read(8192), b""):
                if current_file is None or current_size + len(chunk) > max_size:
                    if current_file:
                        current_file.close()

                    part_path = output_dir / f"{path.stem}.part{part_num:03d}"
                    current_file = part_path.open("wb")
                    parts.append(part_path)
                    part_num += 1
                    current_size = 0

                current_file.write(chunk)
                current_size += len(chunk)
    finally:
        if current_file:
            current_file.close()

    return parts


def merge_files(parts: list[Path], output: Path) -> None:
    """รวมไฟล์ที่แบ่งไว้"""
    with output.open("wb") as f_out:
        for part in sorted(parts):
            with part.open("rb") as f_in:
                while chunk := f_in.read(8192):
                    f_out.write(chunk)
```

### 8.17.4 ข้อดี

- **Memory:** ใช้คงที่
- **Scalable:** รองรับไฟล์เท่าไรก็ได้
- **Responsive:** เริ่ม process ได้ทันที
- **Resumable:** หยุด/ต่อได้

### 8.17.5 ข้อเสีย

- **Complexity:** ซับซ้อนกว่า
- **Random access:** ยาก
- **Multiple passes:** ถ้าต้องอ่านซ้ำ

### 8.17.6 ข้อควรระวัง

```python
# ระวัง 1: อ่านทั้งหมด
# ❌
with open("huge.txt") as f:
    content = f.read()  # OOM

# ✅
with open("huge.txt") as f:
    for line in f:
        process(line)

# ระวัง 2: readlines()
# ❌
lines = f.readlines()  # โหลดทั้งหมด

# ✅
for line in f:
    process(line)

# ระวัง 3: list comprehension
# ❌
lines = [line for line in f]  # โหลดทั้งหมด

# ✅ generator
lines = (line for line in f)

# ระวัง 4: join() ทั้งหมด
# ❌
content = "".join(f)
# ✅ ถ้าจำเป็นต้องใช้ ก็ใช้
# แต่ memory = ขนาดไฟล์

# ระวัง 5: Binary vs Text
# binary เร็วกว่า, ไม่ต้อง decode
with open(path, "rb") as f:
    for chunk in iter(lambda: f.read(8192), b""):
        process(chunk)

# ระวัง 6: Encoding errors
with open(path, encoding="utf-8", errors="replace") as f:
    ...

# ระวัง 7: Buffer size
# 8192-65536 เหมาะสม
# เล็กเกิน → syscall เยอะ
# ใหญ่เกิน → memory
```

### 8.17.7 สรุป

**Patterns:**

| Pattern | ใช้ |
|---------|-----|
| `for line in f` | Text files |
| `read(chunk)` | Binary/chunks |
| `iter(callable, sentinel)` | Chunks |
| `mmap` | Random access |
| `shutil.copyfileobj` | Copy |

**Best practices:**
- Streaming เสมอสำหรับไฟล์ใหญ่
- Chunk size 8KB-1MB
- Generator สำหรับ pipelines
- `mmap` สำหรับ random access
- ระวัง `read()`, `readlines()`, `list()`

> **อ้างอิงเพิ่มเติม:** [io — Core tools](https://docs.python.org/3/library/io.html), [mmap](https://docs.python.org/3/library/mmap.html)

---

## 8.18 Encoding และ Unicode

### บทนำ

การจัดการ encoding เป็นสิ่งที่ต้องระวังใน Python 3 โดยเฉพาะเมื่อทำงานกับข้อความหลายภาษา Unicode เป็นมาตรฐานที่ Python 3 ใช้

### นิยาม

- **Unicode:** มาตรฐานสำหรับตัวอักษรทุกภาษา
- **Encoding:** วิธีแปลง Unicode → bytes
- **UTF-8:** encoding ที่นิยม (variable-width)

### 8.18.1 คืออะไร

Python 3:
- `str` = Unicode code points
- `bytes` = raw bytes
- ต้อง encode/decode ระหว่างกัน

### 8.18.2 ทำงานอย่างไร

```
str (Unicode) --encode--> bytes
bytes --decode--> str (Unicode)
```

### 8.18.3 การใช้งาน

**พื้นฐาน:**

```python
# str → bytes
text = "สวัสดี"
encoded = text.encode("utf-8")
print(encoded)  # b'\xe0\xb8\xaa...'

# bytes → str
decoded = encoded.decode("utf-8")
print(decoded)  # สวัสดี

# ดู code points
for char in "Hello":
    print(f"{char}: U+{ord(char):04X}")
# H: U+0048
# e: U+0065
# ...

# ดู bytes
for byte in "Hi".encode("utf-8"):
    print(f"0x{byte:02X}")
```

**Encodings ที่พบบ่อย:**

```python
text = "สวัสดี Hello 你好"

# UTF-8 (แนะนำ)
utf8 = text.encode("utf-8")
print(f"UTF-8: {len(utf8)} bytes")

# UTF-16
utf16 = text.encode("utf-16")
print(f"UTF-16: {len(utf16)} bytes")

# ASCII (ไม่รองรับ Unicode)
try:
    ascii_bytes = text.encode("ascii")
except UnicodeEncodeError as e:
    print(f"ไม่สามารถ encode: {e}")

# Latin-1 (ISO-8859-1)
try:
    latin = text.encode("latin-1")
except UnicodeEncodeError:
    print("latin-1 ไม่รองรับ")

# TIS-620 (ไทย)
thai = "สวัสดี"
tis = thai.encode("tis-620")
print(tis)
```

**Encoding Errors:**

```python
text = "สวัสดี"

# errors="strict" (default) — raise
try:
    text.encode("ascii")
except UnicodeEncodeError as e:
    print(f"Error: {e}")

# errors="ignore" — ข้าม
result = text.encode("ascii", errors="ignore")
print(result)  # b''

# errors="replace" — แทนด้วย ?
result = text.encode("ascii", errors="replace")
print(result)  # b'??????'

# errors="xmlcharrefreplace" — XML entity
result = text.encode("ascii", errors="xmlcharrefreplace")
print(result)  # b'&#3626;&#3623;...'

# errors="backslashreplace"
result = text.encode("ascii", errors="backslashreplace")
print(result)  # b'\\u0e2a...'
```

**Decode Errors:**

```python
data = b"\xe0\xb8\xaa\xe0\xb8\xa7"  # incomplete UTF-8

# strict
try:
    data.decode("utf-8")
except UnicodeDecodeError as e:
    print(f"Error: {e}")

# ignore
print(data.decode("utf-8", errors="ignore"))

# replace
print(data.decode("utf-8", errors="replace"))

# backslashreplace
print(data.decode("utf-8", errors="backslashreplace"))
```

**Encoding Detection:**

```python
# ใช้ chardet (third-party)
# pip install chardet
import chardet

data = b"\xe0\xb8\xaa\xe0\xb8\xa7\xe0\xb8\xb1\xe0\xb8\xaa\xe0\xb8\x94\xe0\xb8\xb5"
result = chardet.detect(data)
print(result)
# {'encoding': 'TIS-620', 'confidence': 0.99, ...}

# ใช้ charset-normalizer (เร็วกว่า)
# pip install charset-normalizer
from charset_normalizer import from_bytes

data = b"\xe0\xb8\xaa..."
best = from_bytes(data).best()
if best:
    print(best.encoding)
    print(str(best))
```

**ตัวอย่างการใช้งานจริง — Safe File Reader:**

```python
from pathlib import Path
from typing import Iterator


def read_text_safe(
    path: Path,
    encodings: list[str] | None = None,
) -> str:
    """อ่านไฟล์โดยลองหลาย encodings"""
    if encodings is None:
        encodings = ["utf-8", "utf-8-sig", "tis-620", "latin-1"]

    data = path.read_bytes()

    for encoding in encodings:
        try:
            return data.decode(encoding)
        except UnicodeDecodeError:
            continue

    # fallback
    return data.decode("utf-8", errors="replace")


def read_lines_safe(
    path: Path,
    encodings: list[str] | None = None,
) -> Iterator[str]:
    """อ่านบรรทัดจากไฟล์โดยลองหลาย encodings"""
    content = read_text_safe(path, encodings)
    yield from content.splitlines()
```

**Unicode Normalization:**

```python
import unicodedata

# NFC — composed (แนะนำสำหรับ storage)
# NFD — decomposed
# NFKC — compatibility composed
# NFKD — compatibility decomposed

# ตัวอย่าง: é
s1 = "é"           # U+00E9 (single char)
s2 = "e\u0301"     # e + combining accent

print(s1 == s2)  # False
print(len(s1), len(s2))  # 1 2

# Normalize
s1_nfc = unicodedata.normalize("NFC", s1)
s2_nfc = unicodedata.normalize("NFC", s2)
print(s1_nfc == s2_nfc)  # True

# ไทย
s1 = "กำ"  # กำ (precomposed)
s2 = "กำ"  # ก + ำ (decomposed)
print(unicodedata.normalize("NFC", s1) == unicodedata.normalize("NFC", s2))
```

**Unicode Properties:**

```python
import unicodedata

char = "ก"
print(unicodedata.name(char))       # THAI CHARACTER KO KAI
print(unicodedata.category(char))   # Lo (Letter, other)
print(unicodedata.combining(char))  # 0 (ไม่ combining)
print(unicodedata.east_asian_width(char))  # N

# Categories:
# L* — Letter
# N* — Number
# P* — Punctuation
# S* — Symbol
# Z* — Separator
# C* — Other

def is_printable(char: str) -> bool:
    category = unicodedata.category(char)
    return not category.startswith("C")
```

**ตัวอย่างการใช้งานจริง — Text Cleaner:**

```python
import unicodedata
import re


def clean_text(text: str) -> str:
    """ทำความสะอาดข้อความ"""
    # Normalize
    text = unicodedata.normalize("NFC", text)

    # ลบ control characters
    text = "".join(
        c for c in text
        if unicodedata.category(c) != "Cc" or c in "\n\t"
    )

    # แทน whitespace หลายตัว
    text = re.sub(r"[ \t]+", " ", text)

    # ลบบรรทัดว่าง
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    text = "\n".join(lines)

    return text


def slugify(text: str) -> str:
    """สร้าง slug จากข้อความ"""
    # Normalize
    text = unicodedata.normalize("NFKD", text)

    # ลบ non-ASCII (สำหรับภาษาอังกฤษ)
    text = text.encode("ascii", "ignore").decode("ascii")

    # แทน whitespace ด้วย -
    text = re.sub(r"[^\w\s-]", "", text.lower())
    text = re.sub(r"[-\s]+", "-", text)

    return text.strip("-")


print(slugify("Hello World!"))  # hello-world
print(slugify("Python 3.12"))   # python-312
```

**ตัวอย่าง — CSV Encoding:**

```python
import csv
from pathlib import Path


def read_csv_with_encoding(
    path: Path,
    encoding: str = "utf-8-sig",
) -> list[dict]:
    """อ่าน CSV โดยจัดการ BOM"""
    # utf-8-sig จะลบ BOM อัตโนมัติ
    with path.open(encoding=encoding, newline="") as f:
        reader = csv.DictReader(f)
        return list(reader)


def write_csv_with_bom(
    path: Path,
    rows: list[dict],
    fieldnames: list[str],
) -> None:
    """เขียน CSV พร้อม BOM — สำหรับ Excel"""
    # utf-8-sig จะเพิ่ม BOM อัตโนมัติ
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)
```

### 8.18.4 ข้อดี

- **Universal:** รองรับทุกภาษา
- **Standard:** Unicode standard
- **UTF-8:** ใช้ทั่วไป

### 8.18.5 ข้อเสีย

- **Complexity:** ต้องเข้าใจ
- **Size:** UTF-8 ใช้หลาย bytes
- **Confusion:** str vs bytes

### 8.18.6 ข้อควรระวัง

```python
# ระวัง 1: Mixed str and bytes
# ❌
# "hello" + b" world"  # TypeError

# ✅
"hello" + b" world".decode()  # "hello world"
"hello".encode() + b" world"  # b"hello world"

# ระวัง 2: Default encoding
# ❌ platform-dependent
open("file.txt")  # encoding อาจต่างกัน

# ✅ ระบุชัดเจน
open("file.txt", encoding="utf-8")

# ระวัง 3: Windows
# Windows default = cp1252 (หรือ cp874 สำหรับไทย)
# ❌
open("thai.txt")  # อาจ error

# ✅
open("thai.txt", encoding="utf-8")

# ระวัง 4: len() กับ Unicode
text = "สวัสดี"
print(len(text))               # 6 (code points)
print(len(text.encode("utf-8")))  # 18 (bytes)

# ระวัง 5: Slicing
# ❌ อาจตัดกลาง character
text = "สวัสดี"
# text[:3]  # ✅ OK (code points)

# กับ bytes
data = text.encode("utf-8")
# data[:3]  # ⚠️ อาจตัดกลาง

# ระวัง 6: Normalization
# ❌ เปรียบเทียบโดยไม่ normalize
s1 = "é"      # U+00E9
s2 = "e\u0301"  # decomposed
# s1 == s2  # False!

# ✅
unicodedata.normalize("NFC", s1) == unicodedata.normalize("NFC", s2)

# ระวัง 7: Surrogate pairs
# emoji ใช้ 2 code units ใน UTF-16
```

### 8.18.7 สรุป

**Encodings:**

| Encoding | ใช้ |
|----------|-----|
| utf-8 | แนะนำ |
| utf-8-sig | พร้อม BOM (Excel) |
| tis-620 | ไทย (เก่า) |
| latin-1 | ทั่วไป |

**Best practices:**
- `encoding="utf-8"` เสมอ
- `errors="replace"` หรือ `"ignore"` สำหรับข้อมูลเสีย
- Normalize ก่อนเปรียบเทียบ
- ระวัง BOM (`utf-8-sig`)
- ใช้ `chardet` สำหรับ unknown encoding
- `str` สำหรับ text, `bytes` สำหรับ binary

> **อ้างอิงเพิ่มเติม:** [Unicode HOWTO](https://docs.python.org/3/howto/unicode.html)

---

## 8.19 Regular Expression

### บทนำ

Regular Expression (regex) เป็นเครื่องมือที่ทรงพลังสำหรับ pattern matching และ text processing Python มี `re` module

### นิยาม

Regex คือ pattern สำหรับอธิบายชุดของ strings ใช้สำหรับ:
- ค้นหา
- แทนที่
- แยก
- Validate

### 8.19.1 คืออะไร

Syntax พื้นฐาน:
- `.` — ตัวอักษรใดก็ได้
- `*` — 0 หรือมากกว่า
- `+` — 1 หรือมากกว่า
- `?` — 0 หรือ 1
- `\d` — digit
- `\w` — word character
- `\s` — whitespace
- `[]` — character class
- `()` — group
- `|` — alternation
- `^` `$` — start/end

### 8.19.2 ทำงานอย่างไร

`re` module compile pattern เป็น object แล้วใช้กับ strings

### 8.19.3 การใช้งาน

**Functions หลัก:**

```python
import re

text = "ติดต่อ: 081-234-5678 หรือ 089-876-5432"

# search — หาตัวแรก
match = re.search(r"\d{3}-\d{3}-\d{4}", text)
if match:
    print(match.group())  # 081-234-5678

# findall — หาทั้งหมด
phones = re.findall(r"\d{3}-\d{3}-\d{4}", text)
print(phones)  # ['081-234-5678', '089-876-5432']

# finditer — iterator ของ matches
for match in re.finditer(r"\d{3}-\d{3}-\d{4}", text):
    print(match.group(), match.start(), match.end())

# match — ต้องตรงจากต้น
result = re.match(r"\d+", "123abc")  # ✅
result = re.match(r"\d+", "abc123")  # ❌ None

# fullmatch — ต้องตรงทั้งหมด
result = re.fullmatch(r"\d+", "123")  # ✅
result = re.fullmatch(r"\d+", "123abc")  # ❌

# sub — แทนที่
masked = re.sub(r"\d{3}-\d{3}-\d{4}", "XXX-XXX-XXXX", text)
print(masked)

# split — แยก
parts = re.split(r"[,;]\s*", "a, b;c, d")
print(parts)  # ['a', 'b', 'c', 'd']
```

**Compile Pattern:**

```python
import re

# compile ครั้งเดียว ใช้ซ้ำ
PHONE_PATTERN = re.compile(r"\d{3}-\d{3}-\d{4}")

text = "081-234-5678"
match = PHONE_PATTERN.search(text)

# ประหยัดเวลาเมื่อใช้หลายครั้ง
```

**Groups:**

```python
import re

# Capturing groups
pattern = re.compile(r"(\d{4})-(\d{2})-(\d{2})")
match = pattern.search("วันที่ 2024-01-15")
if match:
    print(match.group(0))  # 2024-01-15 (ทั้งหมด)
    print(match.group(1))  # 2024 (year)
    print(match.group(2))  # 01 (month)
    print(match.group(3))  # 15 (day)
    print(match.groups())  # ('2024', '01', '15')

# Named groups
pattern = re.compile(r"(?P<year>\d{4})-(?P<month>\d{2})-(?P<day>\d{2})")
match = pattern.search("2024-01-15")
if match:
    print(match.group("year"))    # 2024
    print(match.groupdict())      # {'year': '2024', ...}

# Non-capturing group
pattern = re.compile(r"(?:\d{3}-){2}\d{4}")  # ไม่เก็บ groups

# Backreference
pattern = re.compile(r"(\w+)\s+\1")  # คำซ้ำ
match = pattern.search("hello hello")
```

**Character Classes:**

```python
import re

# Predefined
r"\d"    # [0-9]
r"\D"    # [^0-9]
r"\w"    # [a-zA-Z0-9_]
r"\W"    # [^a-zA-Z0-9_]
r"\s"    # [ \t\n\r\f\v]
r"\S"    # [^ \t\n\r\f\v]

# Custom
r"[abc]"     # a, b, หรือ c
r"[^abc]"    # ไม่ใช่ a, b, c
r"[a-z]"     # a ถึง z
r"[a-zA-Z]"  # a-z หรือ A-Z
r"[0-9_]"    # digit หรือ _

# Thai characters
r"[\u0E00-\u0E7F]"  # Thai Unicode block
```

**Quantifiers:**

```python
r"a*"     # 0 หรือมากกว่า
r"a+"     # 1 หรือมากกว่า
r"a?"     # 0 หรือ 1
r"a{3}"   # 3 ตัว
r"a{2,5}" # 2-5 ตัว
r"a{2,}"  # 2 ขึ้นไป

# Greedy (default)
r"<.*>"   # ครอบคลุมมากสุด

# Non-greedy
r"<.*?>"  # ครอบคลุมน้อยสุด
```

**Anchors:**

```python
r"^"      # เริ่มต้น (หรือหลัง \n ถ้า MULTILINE)
r"$"      # สิ้นสุด
r"\A"     # เริ่มต้น string เท่านั้น
r"\Z"     # สิ้นสุด string เท่านั้น
r"\b"     # word boundary
r"\B"     # ไม่ใช่ word boundary
```

**Flags:**

```python
import re

# IGNORECASE
re.search(r"hello", "HELLO", re.IGNORECASE)

# MULTILINE — ^$ ต่อบรรทัด
re.findall(r"^\w+", "a\nb\nc", re.MULTILINE)

# DOTALL — . ตรง \n ด้วย
re.search(r"a.b", "a\nb", re.DOTALL)

# VERBOSE — อ่านง่าย
pattern = re.compile(r"""
    \d{4}    # year
    -
    \d{2}    # month
    -
    \d{2}    # day
""", re.VERBOSE)

# ASCII — \w เฉพาะ ASCII
re.search(r"\w+", "สวัสดี", re.ASCII)

# รวม flags
re.search(r"hello", "HELLO", re.IGNORECASE | re.MULTILINE)
```

**Lookahead / Lookbehind:**

```python
# Positive lookahead — (?=...)
# match "foo" ถ้าตามด้วย "bar"
re.search(r"foo(?=bar)", "foobar")  # ✅

# Negative lookahead — (?!...)
re.search(r"foo(?!bar)", "foobar")  # ❌
re.search(r"foo(?!bar)", "foobaz")  # ✅

# Positive lookbehind — (?<=...)
# match "bar" ถ้าก่อนด้วย "foo"
re.search(r"(?<=foo)bar", "foobar")  # ✅

# Negative lookbehind — (?<!...)
re.search(r"(?<!foo)bar", "bazbar")  # ✅
```

**ตัวอย่างการใช้งานจริง — Log Parser:**

```python
import re
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Iterator


LOG_PATTERN = re.compile(r"""
    (?P<ip>\d{1,3}(?:\.\d{1,3}){3})\s+
    -\s+-\s+
    \[(?P<time>[^\]]+)\]\s+
    "(?P<method>\w+)\s+(?P<path>\S+)\s+HTTP/[\d.]+"\s+
    (?P<status>\d{3})\s+
    (?P<size>\d+)
""", re.VERBOSE)


@dataclass
class LogEntry:
    ip: str
    time: datetime
    method: str
    path: str
    status: int
    size: int


def parse_log(path: Path) -> Iterator[LogEntry]:
    """Parse Apache log"""
    with path.open(encoding="utf-8") as f:
        for line in f:
            match = LOG_PATTERN.search(line)
            if not match:
                continue

            try:
                yield LogEntry(
                    ip=match["ip"],
                    time=datetime.strptime(
                        match["time"],
                        "%d/%b/%Y:%H:%M:%S %z",
                    ),
                    method=match["method"],
                    path=match["path"],
                    status=int(match["status"]),
                    size=int(match["size"]),
                )
            except ValueError:
                continue
```

**ตัวอย่าง — Email Validator:**

```python
import re

# RFC 5322 simplified
EMAIL_PATTERN = re.compile(r"""
    ^
    (?P<local>
        [a-zA-Z0-9._%+-]+
    )
    @
    (?P<domain>
        [a-zA-Z0-9.-]+
    )
    \.
    (?P<tld>
        [a-zA-Z]{2,}
    )
    $
""", re.VERBOSE)


def validate_email(email: str) -> bool:
    return EMAIL_PATTERN.match(email) is not None


def parse_email(email: str) -> dict | None:
    match = EMAIL_PATTERN.match(email)
    if not match:
        return None
    return match.groupdict()


# ใช้งาน
print(validate_email("user@example.com"))    # True
print(validate_email("invalid"))              # False
print(parse_email("user.name@example.co.th"))
# {'local': 'user.name', 'domain': 'example.co', 'tld': 'th'}
```

**ตัวอย่าง — Template Engine:**

```python
import re
from typing import Any


TEMPLATE_PATTERN = re.compile(
    r"\{\{\s*(?P<key>\w+)\s*\}\}"
)


def render(template: str, context: dict[str, Any]) -> str:
    """Render template อย่างง่าย"""
    def replace(match: re.Match) -> str:
        key = match["key"]
        if key not in context:
            return match.group(0)  # เก็บไว้ถ้าไม่มี
        return str(context[key])

    return TEMPLATE_PATTERN.sub(replace, template)


# ใช้งาน
template = "Hello, {{ name }}! You have {{ count }} messages."
result = render(template, {"name": "สมชาย", "count": 5})
print(result)
# Hello, สมชาย! You have 5 messages.
```

**ตัวอย่าง — URL Router:**

```python
import re
from typing import Callable


class Router:
    def __init__(self) -> None:
        self._routes: list[tuple[re.Pattern, Callable]] = []

    def route(self, pattern: str) -> Callable:
        """Decorator สำหรับ register route"""
        # แปลง :param เป็น named group
        regex_pattern = re.sub(
            r":(\w+)",
            r"(?P<\1>[^/]+)",
            pattern,
        )
        compiled = re.compile(f"^{regex_pattern}$")

        def decorator(func: Callable) -> Callable:
            self._routes.append((compiled, func))
            return func

        return decorator

    def match(self, path: str) -> tuple[Callable, dict] | None:
        for pattern, handler in self._routes:
            match = pattern.match(path)
            if match:
                return handler, match.groupdict()
        return None


# ใช้งาน
router = Router()


@router.route("/users/:user_id")
def get_user(user_id: str) -> dict:
    return {"id": user_id}


@router.route("/posts/:post_id/comments/:comment_id")
def get_comment(post_id: str, comment_id: str) -> dict:
    return {"post": post_id, "comment": comment_id}


result = router.match("/users/123")
if result:
    handler, params = result
    print(handler(**params))  # {'id': '123'}
```

### 8.19.4 ข้อดี

- **Powerful:** match patterns ซับซ้อน
- **Concise:** เขียนสั้น
- **Standard:** ใช้ในทุกภาษา
- **Built-in:** `re` module

### 8.19.5 ข้อเสีย

- **Complex:** อ่านยาก
- **Performance:** อาจช้า (catastrophic backtracking)
- **Debug:** ยาก
- **Overuse:** ใช้เมื่อไม่ควร

### 8.19.6 ข้อควรระวัง

```python
# ระวัง 1: Raw strings
# ❌ \d อาจถูกตีความ
pattern = "\d+"  # "\d" = "\\d" OK แต่ "\." ไม่

# ✅ ใช้ raw string
pattern = r"\d+"
pattern = r"file\.txt"  # ✅

# ระวัง 2: Catastrophic backtracking
# ❌
re.match(r"(a+)+b", "aaaaaaaaaaaaaaaaaaaaaaaaaaaaab")  # ช้ามาก

# ระวัง 3: Compile pattern ที่ใช้บ่อย
# ❌ compile ทุกครั้ง
for line in lines:
    re.search(r"\d+", line)

# ✅
pattern = re.compile(r"\d+")
for line in lines:
    pattern.search(line)

# ระวัง 4: search vs match
# match — จากต้น string
# search — หาที่ไหนก็ได้
re.match(r"\d+", "abc123")    # None
re.search(r"\d+", "abc123")   # Match

# ระวัง 5: Anchors
# ❌ $ match ก่อน \n
re.search(r"abc$", "abc\n")  # Match!

# ✅ ใช้ \Z
re.search(r"abc\Z", "abc\n")  # None

# ระวัง 6: Lookbehind ต้อง fixed-width
# ❌
# re.search(r"(?<=a+)b", "aab")  # error

# ✅
re.search(r"(?<=aa)b", "aab")

# ระวัง 7: ไม่ควรใช้ regex กับ HTML/XML
# ใช้ parser แทน
from html.parser import HTMLParser
```

### 8.19.7 สรุป

**Functions:**

| Function | ใช้ |
|----------|-----|
| `search` | หาตัวแรก |
| `findall` | หาทั้งหมด |
| `finditer` | Iterator |
| `match` | จากต้น |
| `fullmatch` | ทั้งหมด |
| `sub` | แทนที่ |
| `split` | แยก |

**Best practices:**
- `re.compile` สำหรับ reuse
- Raw strings `r"..."`
- Named groups `(?P<name>...)`
- `re.VERBOSE` สำหรับ pattern ยาว
- ระวัง catastrophic backtracking
- ไม่ใช้ regex กับ HTML/XML

> **อ้างอิงเพิ่มเติม:** [re — Regular expression operations](https://docs.python.org/3/library/re.html), [Regular Expression HOWTO](https://docs.python.org/3/howto/regex.html)

---

## 8.20 datetime

### บทนำ

`datetime` module ให้ classes สำหรับจัดการวันที่และเวลา: `date`, `time`, `datetime`, `timedelta`, `timezone`

### นิยาม

- **date:** วันที่ (year, month, day)
- **time:** เวลา (hour, minute, second, microsecond)
- **datetime:** ทั้งวันที่และเวลา
- **timedelta:** ช่วงเวลา
- **timezone:** timezone info

### 8.20.1 คืออะไร

`datetime` เป็น module มาตรฐานสำหรับงานวันที่และเวลา

### 8.20.2 ทำงานอย่างไร

Objects เป็น immutable สร้างใหม่เมื่อแก้

### 8.20.3 การใช้งาน

**สร้าง:**

```python
from datetime import date, time, datetime, timedelta, timezone

# date
d = date(2024, 1, 15)
print(d)  # 2024-01-15
print(d.year, d.month, d.day)  # 2024 1 15

# time
t = time(14, 30, 45)
print(t)  # 14:30:45
print(t.hour, t.minute, t.second)  # 14 30 45

# datetime
dt = datetime(2024, 1, 15, 14, 30, 45)
print(dt)  # 2024-01-15 14:30:45

# timedelta
delta = timedelta(days=7, hours=3, minutes=30)
print(delta)  # 7 days, 3:30:00

# ปัจจุบัน
now = datetime.now()
utc_now = datetime.now(timezone.utc)
today = date.today()
```

**Parse & Format:**

```python
from datetime import datetime

# strftime — format
dt = datetime(2024, 1, 15, 14, 30, 45)

print(dt.strftime("%Y-%m-%d"))              # 2024-01-15
print(dt.strftime("%d/%m/%Y %H:%M"))        # 15/01/2024 14:30
print(dt.strftime("%A, %B %d, %Y"))         # Monday, January 15, 2024
print(dt.strftime("%Y-%m-%dT%H:%M:%S"))     # ISO 8601
print(dt.isoformat())                        # 2024-01-15T14:30:45

# strptime — parse
dt = datetime.strptime("2024-01-15", "%Y-%m-%d")
dt = datetime.strptime("15/01/2024 14:30", "%d/%m/%Y %H:%M")
dt = datetime.fromisoformat("2024-01-15T14:30:45")
```

**Format codes:**

```python
# %Y — 2024 (4-digit year)
# %y — 24 (2-digit year)
# %m — 01-12 (month)
# %B — January (full month name)
# %b — Jan (abbreviated)
# %d — 01-31 (day)
# %A — Monday (full weekday)
# %a — Mon (abbreviated)
# %H — 00-23 (hour 24h)
# %I — 01-12 (hour 12h)
# %M — 00-59 (minute)
# %S — 00-59 (second)
# %f — microseconds
# %p — AM/PM
# %z — +0700 (UTC offset)
# %Z — timezone name
# %j — day of year (001-366)
# %W — week number
```

**Arithmetic:**

```python
from datetime import datetime, timedelta

now = datetime(2024, 1, 15, 12, 0)

# บวก/ลบ timedelta
tomorrow = now + timedelta(days=1)
next_week = now + timedelta(weeks=1)
last_hour = now - timedelta(hours=1)

# ต่างเวลา
delta = tomorrow - now
print(delta.days)        # 1
print(delta.total_seconds())  # 86400.0

# เปรียบเทียบ
print(now < tomorrow)  # True
print(now == now)      # True

# แก้ไข (สร้างใหม่)
new = now.replace(year=2025, month=6)
```

**Timezone:**

```python
from datetime import datetime, timezone, timedelta

# UTC
utc_now = datetime.now(timezone.utc)
print(utc_now.tzinfo)  # UTC

# Custom offset
thai_tz = timezone(timedelta(hours=7), "ICT")
thai_now = datetime.now(thai_tz)
print(thai_now)  # 2024-01-15 19:00:00+07:00

# Convert
utc_time = thai_now.astimezone(timezone.utc)
print(utc_time)

# Naive vs Aware
naive = datetime.now()                    # ไม่มี tzinfo
aware = datetime.now(timezone.utc)        # มี tzinfo

# ❌ เปรียบเทียบ naive กับ aware ไม่ได้
# naive < aware  # TypeError

# ✅ แปลงให้เป็น aware
naive_aware = naive.replace(tzinfo=timezone.utc)
```

**ตัวอย่างการใช้งานจริง — Age Calculator:**

```python
from datetime import date, datetime


def calculate_age(birth_date: date) -> int:
    """คำนวณอายุ"""
    today = date.today()
    age = today.year - birth_date.year

    # ยังไม่ถึงวันเกิดปีนี้
    if (today.month, today.day) < (birth_date.month, birth_date.day):
        age -= 1

    return age


def days_until_birthday(birth_date: date) -> int:
    """จำนวนวันถึงวันเกิดถัดไป"""
    today = date.today()
    next_birthday = birth_date.replace(year=today.year)

    if next_birthday < today:
        next_birthday = next_birthday.replace(year=today.year + 1)

    return (next_birthday - today).days


# ใช้งาน
birth = date(1990, 5, 15)
print(f"อายุ: {calculate_age(birth)} ปี")
print(f"อีก {days_until_birthday(birth)} วัน")
```

**ตัวอย่าง — Date Range:**

```python
from datetime import date, timedelta
from typing import Iterator


def date_range(
    start: date,
    end: date,
    step: timedelta = timedelta(days=1),
) -> Iterator[date]:
    """สร้าง range ของวันที่"""
    current = start
    while current < end:
        yield current
        current += step


def business_days(
    start: date,
    end: date,
) -> Iterator[date]:
    """เฉพาะวันทำการ (จ.-ศ.)"""
    for day in date_range(start, end):
        if day.weekday() < 5:  # 0-4 = Mon-Fri
            yield day


# ใช้งาน
start = date(2024, 1, 1)
end = date(2024, 1, 31)

print("ทุกวัน:", list(date_range(start, end))[:5])
print("วันทำการ:", list(business_days(start, end))[:5])
```

**ตัวอย่าง — Schedule:**

```python
from datetime import datetime, timedelta, timezone
from dataclasses import dataclass
from typing import Iterator


@dataclass
class Event:
    name: str
    start: datetime
    duration: timedelta

    @property
    def end(self) -> datetime:
        return self.start + self.duration


def find_conflicts(events: list[Event]) -> list[tuple[Event, Event]]:
    """หา events ที่ทับซ้อน"""
    conflicts = []
    sorted_events = sorted(events, key=lambda e: e.start)

    for i, e1 in enumerate(sorted_events):
        for e2 in sorted_events[i + 1:]:
            if e2.start >= e1.end:
                break  # ไม่ทับกันแล้ว

            if e1.start < e2.end and e2.start < e1.end:
                conflicts.append((e1, e2))

    return conflicts


# ใช้งาน
events = [
    Event("Meeting A", datetime(2024, 1, 15, 10), timedelta(hours=1)),
    Event("Meeting B", datetime(2024, 1, 15, 10, 30), timedelta(hours=1)),
    Event("Meeting C", datetime(2024, 1, 15, 14), timedelta(hours=1)),
]

conflicts = find_conflicts(events)
for e1, e2 in conflicts:
    print(f"Conflict: {e1.name} กับ {e2.name}")
```

**ตัวอย่าง — Relative Time:**

```python
from datetime import datetime, timezone


def relative_time(dt: datetime) -> str:
    """แสดงเวลาแบบ relative"""
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)

    now = datetime.now(timezone.utc)
    delta = now - dt
    seconds = int(delta.total_seconds())

    if seconds < 0:
        return "อนาคต"
    if seconds < 60:
        return "เมื่อสักครู่"
    if seconds < 3600:
        return f"{seconds // 60} นาทีที่แล้ว"
    if seconds < 86400:
        return f"{seconds // 3600} ชั่วโมงที่แล้ว"
    if seconds < 2592000:  # 30 days
        return f"{seconds // 86400} วันที่แล้ว"
    if seconds < 31536000:  # 1 year
        return f"{seconds // 2592000} เดือนที่แล้ว"
    return f"{seconds // 31536000} ปีที่แล้ว"


# ใช้งาน
from datetime import timedelta
now = datetime.now(timezone.utc)
print(relative_time(now))                          # เมื่อสักครู่
print(relative_time(now - timedelta(minutes=5)))  # 5 นาทีที่แล้ว
print(relative_time(now - timedelta(hours=2)))    # 2 ชั่วโมงที่แล้ว
print(relative_time(now - timedelta(days=3)))     # 3 วันที่แล้ว
```

### 8.20.4 ข้อดี

- **Built-in:** standard library
- **Complete:** ครบทุกอย่าง
- **Immutable:** ปลอดภัย
- **Arithmetic:** บวกลบได้
- **Timezone:** รองรับ

### 8.20.5 ข้อเสีย

- **Naive/aware:** สับสนได้
- **DST:** จัดการยาก
- **Parsing:** ต้องรู้ format
- **Timezone db:** ต้อง `zoneinfo` หรือ `pytz`

### 8.20.6 ข้อควรระวัง

```python
# ระวัง 1: Naive vs Aware
# ❌
naive = datetime.now()
aware = datetime.now(timezone.utc)
# naive < aware  # TypeError

# ✅ ใช้ aware เสมอ
from datetime import timezone
now = datetime.now(timezone.utc)

# ระวัง 2: datetime.now() vs utcnow()
# ⚠️ utcnow() return naive
# ✅ ใช้ now(timezone.utc)
utc_now = datetime.now(timezone.utc)

# ระวัง 3: replace() กับ timezone
# ⚠️ replace(tzinfo=...) ไม่ convert
# ✅ astimezone()
dt = datetime.now(timezone.utc)
# ❌
# thai = dt.replace(tzinfo=timezone(timedelta(hours=7)))  # ผิด!
# ✅
thai = dt.astimezone(timezone(timedelta(hours=7)))

# ระวัง 4: DST
# ⚠️ timedelta ไม่จัดการ DST
# ✅ ใช้ timezone ที่ถูกต้อง

# ระวัง 5: strptime format
# ❌
datetime.strptime("2024-01-15", "%Y/%m/%d")  # ValueError

# ✅
datetime.strptime("2024-01-15", "%Y-%m-%d")

# ระวัง 6: Overflow
# ⚠️ datetime มีขอบเขต
# datetime(9999, 12, 31) + timedelta(days=1)  # OverflowError

# ระวัง 7: datetime.now() ใน loop
# ❌ เรียกทุกรอบ
for item in items:
    item.timestamp = datetime.now()

# ✅ ครั้งเดียว
now = datetime.now()
for item in items:
    item.timestamp = now
```

### 8.20.7 สรุป

**Classes:**

| Class | ใช้ |
|-------|-----|
| `date` | วันที่ |
| `time` | เวลา |
| `datetime` | วันที่+เวลา |
| `timedelta` | ช่วงเวลา |
| `timezone` | Timezone |

**Best practices:**
- ใช้ aware datetime (`timezone.utc`)
- `datetime.now(timezone.utc)` แทน `utcnow()`
- `astimezone()` สำหรับ convert
- ISO 8601 สำหรับ storage
- `zoneinfo` สำหรับ named timezones
- ระวัง DST

> **อ้างอิงเพิ่มเติม:** [datetime Documentation](https://docs.python.org/3/library/datetime.html)

---

## 8.21 zoneinfo

### บทนำ

`zoneinfo` เป็น module มาตรฐาน (Python 3.9+) สำหรับจัดการ named timezones แทน `pytz` ได้

### นิยาม

`zoneinfo` ให้ `ZoneInfo` class ที่ represent timezone จาก IANA database

### 8.21.1 คืออะไร

- Built-in (Python 3.9+)
- ใช้ IANA timezone database
- เร็วกว่า `pytz`
- API สะอาดกว่า

### 8.21.2 ทำงานอย่างไร

`ZoneInfo("Asia/Bangkok")` โหลด timezone info จาก system หรือ `tzdata` package

### 8.21.3 การใช้งาน

**พื้นฐาน:**

```python
from zoneinfo import ZoneInfo
from datetime import datetime

# สร้าง timezone
bangkok = ZoneInfo("Asia/Bangkok")
new_york = ZoneInfo("America/New_York")
utc = ZoneInfo("UTC")

# datetime กับ timezone
now_bkk = datetime.now(bangkok)
print(now_bkk)  # 2024-01-15 19:00:00+07:00

now_nyc = datetime.now(new_york)
print(now_nyc)  # 2024-01-15 07:00:00-05:00

# Convert
nyc_time = now_bkk.astimezone(new_york)
print(nyc_time)
```

**Timezone Database:**

```python
from zoneinfo import available_timezones

# ดู timezones ทั้งหมด
all_tz = available_timezones()
print(f"Total: {len(all_tz)}")

# ตัวอย่าง
thai_tz = [tz for tz in all_tz if "Bangkok" in tz]
print(thai_tz)  # ['Asia/Bangkok']

us_tz = [tz for tz in all_tz if tz.startswith("America/")]
print(us_tz[:5])
```

**DST Handling:**

```python
from zoneinfo import ZoneInfo
from datetime import datetime

nyc = ZoneInfo("America/New_York")

# ก่อน DST
winter = datetime(2024, 1, 15, 12, tzinfo=nyc)
print(winter)  # 2024-01-15 12:00:00-05:00

# หลัง DST
summer = datetime(2024, 7, 15, 12, tzinfo=nyc)
print(summer)  # 2024-07-15 12:00:00-04:00

# Offset ต่างกัน!
print(winter.utcoffset())  # -5:00:00
print(summer.utcoffset())  # -4:00:00
```

**Fallback Timezones:**

```python
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

def get_timezone(name: str) -> ZoneInfo:
    """ดึง timezone พร้อม fallback"""
    try:
        return ZoneInfo(name)
    except ZoneInfoNotFoundError:
        print(f"ไม่พบ timezone: {name}, ใช้ UTC")
        return ZoneInfo("UTC")


bkk = get_timezone("Asia/Bangkok")
unknown = get_timezone("Invalid/Zone")
```

**ตัวอย่างการใช้งานจริง — Multi-Timezone Clock:**

```python
from zoneinfo import ZoneInfo
from datetime import datetime
from dataclasses import dataclass


@dataclass
class City:
    name: str
    timezone: str

    @property
    def tz(self) -> ZoneInfo:
        return ZoneInfo(self.timezone)


def show_clocks(cities: list[City]) -> None:
    """แสดงเวลาของหลายเมือง"""
    now_utc = datetime.now(ZoneInfo("UTC"))

    print(f"{'City':<20} {'Local Time':<25} {'Offset'}")
    print("-" * 60)

    for city in cities:
        local = now_utc.astimezone(city.tz)
        offset = local.strftime("%z")
        print(f"{city.name:<20} {local.strftime('%Y-%m-%d %H:%M'):<25} {offset}")


# ใช้งาน
cities = [
    City("Bangkok", "Asia/Bangkok"),
    City("New York", "America/New_York"),
    City("London", "Europe/London"),
    City("Tokyo", "Asia/Tokyo"),
]

show_clocks(cities)
```

**ตัวอย่าง — Meeting Scheduler:**

```python
from zoneinfo import ZoneInfo
from datetime import datetime, timedelta


def find_meeting_time(
    participants: list[tuple[str, str]],  # (name, timezone)
    duration_hours: int = 1,
    start_hour: int = 9,
    end_hour: int = 18,
) -> list[datetime]:
    """หาเวลาประชุมที่ทุกคนว่าง"""
    # เริ่มจาก UTC
    today = datetime.now(ZoneInfo("UTC")).replace(
        hour=0, minute=0, second=0, microsecond=0,
    )

    valid_times = []

    for hour in range(start_hour, end_hour - duration_hours + 1):
        utc_time = today + timedelta(hours=hour)
        is_valid = True

        for name, tz_name in participants:
            local = utc_time.astimezone(ZoneInfo(tz_name))
            local_hour = local.hour

            if not (start_hour <= local_hour <= end_hour - duration_hours):
                is_valid = False
                break

        if is_valid:
            valid_times.append(utc_time)

    return valid_times


# ใช้งาน
participants = [
    ("Alice", "America/New_York"),
    ("Bob", "Europe/London"),
    ("Charlie", "Asia/Bangkok"),
]

times = find_meeting_time(participants)
print("เวลาที่ทุกคนว่าง (UTC):")
for t in times[:5]:
    print(f"  {t.strftime('%H:%M')}")
```

### 8.21.4 ข้อดี

- **Built-in:** Python 3.9+
- **Fast:** เร็วกว่า pytz
- **Simple API:** ไม่ต้อง localize
- **IANA database:** มาตรฐาน
- **Immutable:** ปลอดภัย

### 8.21.5 ข้อเสีย

- **Python 3.9+:** ไม่รองรับเวอร์ชันเก่า
- **Data:** ต้อง `tzdata` บางระบบ
- **Less features:** กว่า pytz

### 8.21.6 ข้อควรระวัง

```python
# ระวัง 1: tzdata ไม่มี
# ⚠️ Windows อาจไม่มี timezone data
# ✅ pip install tzdata

# ระวัง 2: ZoneInfo cache
# ZoneInfo cache objects
tz1 = ZoneInfo("Asia/Bangkok")
tz2 = ZoneInfo("Asia/Bangkok")
print(tz1 is tz2)  # True (cached)

# ระวัง 3: Invalid timezone
# ❌ raises ZoneInfoNotFoundError
# ✅ handle
from zoneinfo import ZoneInfoNotFoundError

try:
    tz = ZoneInfo("Invalid/Zone")
except ZoneInfoNotFoundError:
    tz = ZoneInfo("UTC")

# ระวัง 4: Ambiguous times (DST)
# ในช่วง DST change เวลาอาจซ้ำ
# ZoneInfo จัดการให้แต่อาจสับสน

# ระวัง 5: Historical changes
# timezone rules เปลี่ยนได้
# สำหรับอดีตไกล อาจไม่แม่น

# ระวัง 6: ไม่ควรใช้ pytz ร่วมกับ zoneinfo
# เลือกอันเดียว
```

### 8.21.7 สรุป

**ใช้ zoneinfo เมื่อ:**
- Python 3.9+
- ต้องการ timezone
- แทน pytz
- โปรเจกต์ใหม่

**Best practices:**
- `ZoneInfo("Asia/Bangkok")`
- `astimezone()` สำหรับ convert
- Handle `ZoneInfoNotFoundError`
- `tzdata` package สำหรับ Windows
- Fallback เป็น UTC

> **อ้างอิงเพิ่มเติม:** [zoneinfo Documentation](https://docs.python.org/3/library/zoneinfo.html)

---

## 8.22 math

### บทนำ

`math` module ให้ mathematical functions ที่ใช้บ่อย

### นิยาม

`math` มี constants และ functions สำหรับคณิตศาสตร์

### 8.22.1 คืออะไร

Functions: sqrt, floor, ceil, log, exp, sin, cos, ...
Constants: pi, e, tau, inf, nan

### 8.22.2 ทำงานอย่างไร

Functions เหล่านี้ทำงานกับ floats (ยกเว้นบางตัว)

### 8.22.3 การใช้งาน

**Constants:**

```python
import math

print(math.pi)      # 3.141592653589793
print(math.e)       # 2.718281828459045
print(math.tau)     # 6.283185307179586
print(math.inf)     # inf
print(math.nan)     # nan
```

**พื้นฐาน:**

```python
import math

# กำลัง
print(math.sqrt(16))     # 4.0
print(math.pow(2, 10))   # 1024.0
print(math.isqrt(17))    # 4 (integer sqrt)

# ปัด
print(math.floor(3.7))   # 3
print(math.ceil(3.2))    # 4
print(math.trunc(3.7))   # 3

# ค่าสัมบูรณ์
print(math.fabs(-5.5))   # 5.5

# เหลือ
print(math.fmod(10, 3))  # 1.0

# GCD / LCM
print(math.gcd(12, 18))  # 6
print(math.lcm(4, 6))    # 12
```

**Log และ Exp:**

```python
import math

print(math.log(100, 10))  # 2.0
print(math.log(math.e))   # 1.0
print(math.log2(8))       # 3.0
print(math.log10(1000))   # 3.0
print(math.exp(1))        # e
print(math.expm1(1))      # e - 1 (แม่นกว่า)
```

**ตรีโกณมิติ:**

```python
import math

# radians
print(math.sin(math.pi / 2))   # 1.0
print(math.cos(0))              # 1.0
print(math.tan(math.pi / 4))   # 1.0

# inverse
print(math.asin(1))             # pi/2
print(math.acos(1))             # 0
print(math.atan(1))             # pi/4
print(math.atan2(1, 1))        # pi/4

# Degrees/radians
print(math.degrees(math.pi))    # 180.0
print(math.radians(180))        # pi

# Hyperbolic
print(math.sinh(1))
print(math.cosh(1))
print(math.tanh(1))
```

**ระยะทาง:**

```python
import math

# Euclidean distance
def distance(p1: tuple[float, float], p2: tuple[float, float]) -> float:
    return math.hypot(p2[0] - p1[0], p2[1] - p1[1])

print(distance((0, 0), (3, 4)))  # 5.0

# n มิติ
def distance_nd(p1: tuple[float, ...], p2: tuple[float, ...]) -> float:
    return math.dist(p1, p2)

print(distance_nd((0, 0, 0), (1, 2, 2)))  # 3.0
```

**การตรวจสอบ:**

```python
import math

# ไม่จำกัด
print(math.isfinite(1.5))  # True
print(math.isfinite(math.inf))  # False
print(math.isinf(math.inf))  # True
print(math.isnan(math.nan))  # True
print(math.isclose(0.1 + 0.2, 0.3))  # True
```

**ตัวอย่างการใช้งานจริง — Statistics:**

```python
import math
from typing import Sequence


def mean(values: Sequence[float]) -> float:
    return sum(values) / len(values)


def variance(values: Sequence[float]) -> float:
    avg = mean(values)
    return sum((x - avg) ** 2 for x in values) / len(values)


def std_dev(values: Sequence[float]) -> float:
    return math.sqrt(variance(values))


def correlation(x: Sequence[float], y: Sequence[float]) -> float:
    """Pearson correlation"""
    n = len(x)
    if n != len(y):
        raise ValueError("Lists must have same length")

    mean_x = mean(x)
    mean_y = mean(y)

    numerator = sum((xi - mean_x) * (yi - mean_y) for xi, yi in zip(x, y))
    denom_x = math.sqrt(sum((xi - mean_x) ** 2 for xi in x))
    denom_y = math.sqrt(sum((yi - mean_y) ** 2 for yi in y))

    if denom_x == 0 or denom_y == 0:
        return 0.0

    return numerator / (denom_x * denom_y)


# ใช้งาน
x = [1, 2, 3, 4, 5]
y = [2, 4, 6, 8, 10]

print(f"Mean: {mean(x):.2f}")
print(f"Std: {std_dev(x):.2f}")
print(f"Correlation: {correlation(x, y):.4f}")
```

**ตัวอย่าง — Geometry:**

```python
import math
from dataclasses import dataclass


@dataclass
class Point:
    x: float
    y: float

    def distance_to(self, other: "Point") -> float:
        return math.hypot(other.x - self.x, other.y - self.y)

    def angle_to(self, other: "Point") -> float:
        """มุมเป็น degrees"""
        return math.degrees(
            math.atan2(other.y - self.y, other.x - self.x)
        )


@dataclass
class Circle:
    center: Point
    radius: float

    @property
    def area(self) -> float:
        return math.pi * self.radius ** 2

    @property
    def circumference(self) -> float:
        return 2 * math.pi * self.radius

    def contains(self, point: Point) -> bool:
        return self.center.distance_to(point) <= self.radius


# ใช้งาน
p1 = Point(0, 0)
p2 = Point(3, 4)
print(f"Distance: {p1.distance_to(p2)}")  # 5.0
print(f"Angle: {p1.angle_to(p2):.2f}°")  # 53.13

circle = Circle(p1, 5)
print(f"Area: {circle.area:.2f}")
print(f"Contains (3,4): {circle.contains(p2)}")  # True
```

### 8.22.4 ข้อดี

- **Built-in:** standard library
- **Fast:** implement ใน C
- **Complete:** functions ครบ

### 8.22.5 ข้อเสีย

- **Float only:** ยกเว้นบางตัว
- **No complex:** ใช้ `cmath`
- **Precision:** float limitations

### 8.22.6 ข้อควรระวัง

```python
# ระวัง 1: Float precision
# ❌
print(0.1 + 0.2 == 0.3)  # False

# ✅
print(math.isclose(0.1 + 0.2, 0.3))  # True

# ระวัง 2: log(0)
# ❌
# math.log(0)  # ValueError

# ✅
# ใช้ -inf สำหรับ log(0)
# หรือตรวจสอบก่อน

# ระวัง 3: sqrt ของค่าลบ
# ❌
# math.sqrt(-1)  # ValueError

# ✅ ใช้ cmath
import cmath
print(cmath.sqrt(-1))  # 1j

# ระวัง 4: Division
# math.gcd กับ 0
print(math.gcd(0, 5))  # 5
print(math.gcd(0, 0))  # 0

# ระวัง 5: Degrees vs Radians
# ❌ ใช้ radians กับ sin โดยตรง
# math.sin(90)  # ผิด — 90 radians ไม่ใช่ 90°

# ✅
math.sin(math.radians(90))  # 1.0
```

### 8.22.7 สรุป

**Functions ที่ใช้บ่อย:**

| Function | ใช้ |
|----------|-----|
| `sqrt` | รากที่สอง |
| `pow` | ยกกำลัง |
| `floor`/`ceil` | ปัด |
| `log`/`exp` | log/exponential |
| `sin`/`cos`/`tan` | ตรีโกณ |
| `hypot` | ระยะทาง |
| `isclose` | เปรียบเทียบ float |
| `gcd`/`lcm` | ห.ร.ม./ค.ร.น. |

**Best practices:**
- `math.isclose()` สำหรับ float
- `math.radians()` ก่อนตรีโกณ
- `cmath` สำหรับ complex
- `math.dist()` สำหรับระยะทาง

> **อ้างอิงเพิ่มเติม:** [math Documentation](https://docs.python.org/3/library/math.html)

---

## 8.23 random

### บทนำ

`random` module ให้ functions สำหรับสุ่มตัวเลข ไม่ควรใช้เพื่อความปลอดภัย (ใช้ `secrets` แทน)

### นิยาม

`random` เป็น pseudo-random number generator (PRNG) ใช้ Mersenne Twister

### 8.23.1 คืออะไร

**⚠️ ไม่ปลอดภัย!** สำหรับ security ใช้ `secrets`

### 8.23.2 ทำงานอย่างไร

PRNG ใช้ seed เริ่มต้น ถ้า seed เดียวกัน → ลำดับเดียวกัน

### 8.23.3 การใช้งาน

**พื้นฐาน:**

```python
import random

# ตั้ง seed (สำหรับ reproducibility)
random.seed(42)

# Float [0, 1)
print(random.random())  # 0.6394267984578837

# Int [a, b]
print(random.randint(1, 10))  # 1-10

# Int [a, b)
print(random.randrange(1, 10))  # 1-9
print(random.randrange(0, 100, 10))  # 0, 10, 20, ..., 90

# Float [a, b)
print(random.uniform(1.5, 3.5))

# Gaussian
print(random.gauss(0, 1))       # mean=0, std=1
print(random.normalvariate(0, 1))
```

**เลือกจาก sequence:**

```python
import random

items = ["apple", "banana", "cherry"]

# 1 ตัว
print(random.choice(items))

# n ตัว (ซ้ำได้)
print(random.choices(items, k=5))

# n ตัว (ไม่ซ้ำ)
print(random.sample(items, k=2))

# สุ่มลำดับ
random.shuffle(items)
print(items)

# ถ่วงน้ำหนัก
colors = ["red", "green", "blue"]
weights = [0.5, 0.3, 0.2]
print(random.choices(colors, weights=weights, k=10))
```

**Distributions:**

```python
import random

# Uniform
random.uniform(0, 1)

# Gaussian
random.gauss(0, 1)

# Exponential
random.expovariate(1.5)

# Triangular
random.triangular(0, 10, 5)

# Beta
random.betavariate(2, 5)

# Gamma
random.gammavariate(2, 1)

# Normal
random.normalvariate(0, 1)

# Log-normal
random.lognormvariate(0, 1)
```

**ตัวอย่างการใช้งานจริง — Password Generator:**

```python
import random
import string


def generate_password(
    length: int = 16,
    use_upper: bool = True,
    use_lower: bool = True,
    use_digits: bool = True,
    use_symbols: bool = True,
) -> str:
    """สร้างรหัสผ่าน
    ⚠️ ใช้ secrets สำหรับ password จริง
    """
    chars = ""
    if use_lower:
        chars += string.ascii_lowercase
    if use_upper:
        chars += string.ascii_uppercase
    if use_digits:
        chars += string.digits
    if use_symbols:
        chars += "!@#$%^&*()_+-=[]{}"

    if not chars:
        raise ValueError("ต้องเลือก character set อย่างน้อย 1")

    return "".join(random.choices(chars, k=length))


# ใช้งาน
print(generate_password(20))
```

**ตัวอย่าง — Sampling:**

```python
import random
from dataclasses import dataclass


@dataclass
class Student:
    id: str
    name: str
    grade: str


def stratified_sample(
    students: list[Student],
    sample_size: int,
) -> list[Student]:
    """Sampling แบบ stratified ตาม grade"""
    from collections import defaultdict

    by_grade: dict[str, list[Student]] = defaultdict(list)
    for s in students:
        by_grade[s.grade].append(s)

    total = len(students)
    result = []

    for grade, group in by_grade.items():
        n = round(sample_size * len(group) / total)
        result.extend(random.sample(group, min(n, len(group))))

    return result


# ใช้งาน
students = [
    Student(f"S{i:03d}", f"Student {i}", random.choice("ABC"))
    for i in range(100)
]

sample = stratified_sample(students, 20)
print(f"Sampled: {len(sample)}")
```

**ตัวอย่าง — Dice Simulator:**

```python
import random
from collections import Counter


def roll_dice(
    num_dice: int = 2,
    sides: int = 6,
    rolls: int = 10000,
) -> dict[int, float]:
    """จำลองการทอยลูกเต๋า"""
    counter: Counter[int] = Counter()

    for _ in range(rolls):
        total = sum(
            random.randint(1, sides)
            for _ in range(num_dice)
        )
        counter[total] += 1

    return {
        total: count / rolls
        for total, count in sorted(counter.items())
    }


# ใช้งาน
results = roll_dice(2, 6, 100000)
for total, prob in results.items():
    bar = "█" * int(prob * 100)
    print(f"{total:2d}: {prob:.4f} {bar}")
```

### 8.23.4 ข้อดี

- **Built-in:** standard library
- **Reproducible:** ด้วย seed
- **Distributions:** หลายแบบ
- **Fast:** เร็ว

### 8.23.5 ข้อเสีย

- **Not secure:** ไม่ควรใช้กับ security
- **Global state:** seed เป็น global
- **Predictable:** ถ้ารู้ seed

### 8.23.6 ข้อควรระวัง

```python
# ⚠️⚠️⚠️ ระวัง 1: อย่าใช้ random สำหรับ security
# ❌
import random
token = "".join(random.choices("abcdef", k=32))  # ไม่ปลอดภัย!

# ✅
import secrets
token = secrets.token_hex(32)

# ระวัง 2: seed ใน production
# ❌
random.seed(42)  # predictable
# ✅ ไม่ต้อง seed สำหรับ production

# ระวัง 3: Global state
import random
random.seed(42)
# ถ้า library อื่น seed → impact

# ✅ ใช้ random.Random() instance
rng = random.Random(42)
rng.randint(1, 10)

# ระวัง 4: randint รวมปลาย
random.randint(1, 10)  # 1-10 (รวม 10)

# randrange ไม่รวมปลาย
random.randrange(1, 10)  # 1-9

# ระวัง 5: shuffle in-place
items = [1, 2, 3]
random.shuffle(items)  # แก้ items
# ✅ ถ้าไม่ต้องการ
shuffled = random.sample(items, len(items))

# ระวัง 6: Performance กับ large sample
# ❌
random.sample(range(10**9), 5)  # OK
# สำหรับ range ใหญ่ ใช้
random.sample(range(10**9), 5)  # ทำงานได้
```

### 8.23.7 สรุป

**Functions:**

| Function | ใช้ |
|----------|-----|
| `random()` | Float [0,1) |
| `randint(a,b)` | Int [a,b] |
| `randrange(a,b)` | Int [a,b) |
| `choice(seq)` | 1 ตัว |
| `choices(seq, k)` | k ตัว (ซ้ำได้) |
| `sample(seq, k)` | k ตัว (ไม่ซ้ำ) |
| `shuffle(seq)` | สุ่มลำดับ |
| `uniform(a,b)` | Float [a,b) |
| `gauss(m,s)` | Gaussian |

**Best practices:**
- `secrets` สำหรับ security
- `random.Random()` สำหรับ instance
- `seed` สำหรับ reproducibility
- ระวัง `shuffle` in-place
- ระวัง global state

> **อ้างอิงเพิ่มเติม:** [random Documentation](https://docs.python.org/3/library/random.html)

---

## 8.24 secrets

### บทนำ

`secrets` module ให้ cryptographically secure random numbers สำหรับ security-sensitive applications

### นิยาม

`secrets` ใช้ OS-provided randomness (เช่น `/dev/urandom`) ที่ปลอดภัยสำหรับ cryptography

### 8.24.1 คืออะไร

**ใช้สำหรับ:**
- Passwords
- Tokens
- API keys
- Session IDs
- Password reset links

### 8.24.2 ทำงานอย่างไร

ใช้ `os.urandom()` ที่ให้ cryptographically secure random bytes

### 8.24.3 การใช้งาน

**Tokens:**

```python
import secrets

# Hex token (32 bytes = 64 hex chars)
token = secrets.token_hex(32)
print(token)
# "a1b2c3d4e5f6..."

# URL-safe token
token = secrets.token_urlsafe(32)
print(token)
# "abc123_-XYZ..."

# Bytes token
token = secrets.token_bytes(16)
print(token)
# b'\x00\x01...'
```

**Random choices:**

```python
import secrets
import string

# เลือก 1 ตัว
print(secrets.choice("abcdef"))

# สุ่ม n ตัว
chars = string.ascii_letters + string.digits
password = "".join(secrets.choice(chars) for _ in range(16))
print(password)

# ใช้ secrets.randbelow
print(secrets.randbelow(100))  # 0-99
```

**Compare:**

```python
import secrets

def safe_compare(a: str, b: str) -> bool:
    """เปรียบเทียบแบบ constant-time"""
    return secrets.compare_digest(a, b)


# ใช้งาน
stored = "secret_token_123"
provided = "secret_token_123"
print(safe_compare(stored, provided))  # True
```

**Password Generator:**

```python
import secrets
import string


def generate_password(
    length: int = 16,
    include_symbols: bool = True,
) -> str:
    """สร้างรหัสผ่านที่ปลอดภัย"""
    alphabet = string.ascii_letters + string.digits
    if include_symbols:
        alphabet += "!@#$%^&*"

    while True:
        password = "".join(
            secrets.choice(alphabet)
            for _ in range(length)
        )

        # ตรวจสอบว่ามีทุก type
        if (
            any(c.islower() for c in password)
            and any(c.isupper() for c in password)
            and any(c.isdigit() for c in password)
            and (not include_symbols or any(c in "!@#$%^&*" for c in password))
        ):
            return password


print(generate_password(20))
```

**ตัวอย่างการใช้งานจริง — API Key Manager:**

```python
import secrets
import hashlib
from dataclasses import dataclass, field
from datetime import datetime, timedelta


@dataclass
class APIKey:
    key_id: str
    hashed_key: str
    created_at: datetime
    expires_at: datetime | None = None
    scopes: list[str] = field(default_factory=list)


def create_api_key(
    scopes: list[str] | None = None,
    expires_in_days: int | None = None,
) -> tuple[str, APIKey]:
    """สร้าง API key — return (raw_key, stored_api_key)"""
    key_id = secrets.token_hex(8)
    raw_key = secrets.token_urlsafe(32)
    full_key = f"{key_id}.{raw_key}"

    expires_at = None
    if expires_in_days:
        expires_at = datetime.now() + timedelta(days=expires_in_days)

    api_key = APIKey(
        key_id=key_id,
        hashed_key=hashlib.sha256(raw_key.encode()).hexdigest(),
        created_at=datetime.now(),
        expires_at=expires_at,
        scopes=scopes or [],
    )

    return full_key, api_key


def verify_api_key(
    provided_key: str,
    stored: APIKey,
) -> bool:
    """ตรวจสอบ API key"""
    if "." not in provided_key:
        return False

    key_id, raw_key = provided_key.split(".", 1)

    if not secrets.compare_digest(key_id, stored.key_id):
        return False

    hashed = hashlib.sha256(raw_key.encode()).hexdigest()

    if not secrets.compare_digest(hashed, stored.hashed_key):
        return False

    if stored.expires_at and datetime.now() > stored.expires_at:
        return False

    return True


# ใช้งาน
raw_key, stored_key = create_api_key(scopes=["read", "write"])
print(f"API Key: {raw_key}")

print(verify_api_key(raw_key, stored_key))  # True
print(verify_api_key("invalid", stored_key))  # False
```

**ตัวอย่าง — Password Reset Token:**

```python
import secrets
import hashlib
from datetime import datetime, timedelta
from dataclasses import dataclass


@dataclass
class ResetToken:
    user_id: str
    token_hash: str
    expires_at: datetime
    used: bool = False


def create_reset_token(user_id: str) -> tuple[str, ResetToken]:
    """สร้าง password reset token"""
    token = secrets.token_urlsafe(32)
    token_hash = hashlib.sha256(token.encode()).hexdigest()

    reset = ResetToken(
        user_id=user_id,
        token_hash=token_hash,
        expires_at=datetime.now() + timedelta(hours=1),
    )

    return token, reset


def verify_reset_token(
    token: str,
    stored: ResetToken,
) -> bool:
    """ตรวจสอบ reset token"""
    if stored.used:
        return False
    if datetime.now() > stored.expires_at:
        return False

    token_hash = hashlib.sha256(token.encode()).hexdigest()
    return secrets.compare_digest(token_hash, stored.token_hash)


# ใช้งาน
token, stored = create_reset_token("user123")
print(f"Reset link: https://app.com/reset?token={token}")

if verify_reset_token(token, stored):
    print("Token valid")
    stored.used = True
```

### 8.24.4 ข้อดี

- **Secure:** cryptographically secure
- **Built-in:** standard library
- **Simple:** API ง่าย
- **OS-backed:** ใช้ OS randomness

### 8.24.5 ข้อเสีย

- **Slower:** กว่า `random`
- **No distributions:** แค่ uniform
- **No seeding:** ไม่ reproducible

### 8.24.6 ข้อควรระวัง

```python
# ระวัง 1: ใช้ random แทน secrets
# ❌
import random
token = "".join(random.choices("abcdef", k=32))

# ✅
import secrets
token = secrets.token_urlsafe(32)

# ระวัง 2: Token length
# ❌ สั้นเกินไป
token = secrets.token_hex(4)  # 8 chars — เดาง่าย

# ✅
token = secrets.token_hex(32)  # 64 chars

# ระวัง 3: เปรียบเทียบแบบปกติ
# ❌ timing attack
if token == stored_token:
    pass

# ✅ constant-time
if secrets.compare_digest(token, stored_token):
    pass

# ระวัง 4: เก็บ token
# ❌ เก็บ plain text
db.save({"token": token})

# ✅ hash ก่อน
db.save({"token_hash": hashlib.sha256(token.encode()).hexdigest()})

# ระวัง 5: ไม่ต้อง seed
# ✅ secrets ไม่ต้อง seed (ใช้ OS)

# ระวัง 6: Performance
# ❌ secrets ใน hot loop
for i in range(1000000):
    secrets.randbelow(100)  # ช้ากว่า random

# ✅ ใช้ random สำหรับ non-security
```

### 8.24.7 สรุป

**Functions:**

| Function | ใช้ |
|----------|-----|
| `token_hex(n)` | Hex token |
| `token_urlsafe(n)` | URL-safe token |
| `token_bytes(n)` | Bytes token |
| `choice(seq)` | เลือก 1 |
| `randbelow(n)` | Int [0, n) |
| `compare_digest(a,b)` | Safe compare |

**ใช้สำหรับ:**
- Passwords
- API keys
- Tokens
- Session IDs
- CSRF tokens

**Best practices:**
- `secrets` สำหรับ security
- `token_hex(32)` ขึ้นไป
- `compare_digest` เปรียบเทียบ
- Hash tokens ก่อนเก็บ
- ตรวจสอบ expiration

> **อ้างอิงเพิ่มเติม:** [secrets Documentation](https://docs.python.org/3/library/secrets.html)

---

## สรุปภาค 8

ภาค 8 ครอบคลุมการจัดการไฟล์และข้อมูล:

**File I/O:**
- File I/O พื้นฐาน
- pathlib
- os.path
- shutil
- glob

**Data Formats:**
- CSV
- JSON
- XML
- YAML
- TOML
- INI

**Serialization:**
- Pickle
- Marshal

**Storage:**
- SQLite

**Compression:**
- Compression
- Zip/Tar/Gzip

**Advanced:**
- Large files
- Encoding/Unicode
- Regular Expression
- datetime
- zoneinfo
- math
- random
- secrets

**ก้าวต่อไป:** ภาค 9 จะเข้าสู่การทดสอบและคุณภาพโค้ด

---

# ภาค 9: การทดสอบและคุณภาพโค้ด

## 9.1 Unit Testing

### บทนำ

Unit Testing คือการทดสอบหน่วยย่อยที่สุดของโค้ด (function, method, class) แยกจากส่วนอื่น เป็นพื้นฐานของการทดสอบที่มีประสิทธิภาพ

### นิยาม

Unit Test คือ automated test ที่ทดสอบ behavior ของหน่วยเดียวของโค้ด โดยไม่พึ่งพา dependencies ภายนอก

### 9.1.1 คืออะไร

**หลักการ:**
- **Fast:** รันเร็ว
- **Isolated:** ไม่พึ่ง external
- **Repeatable:** ผลเหมือนเดิม
- **Self-validating:** pass/fail ชัดเจน
- **Timely:** เขียนพร้อมโค้ด

### 9.1.2 ทำงานอย่างไร

Unit Test:
1. Setup — เตรียมข้อมูล
2. Execute — เรียกโค้ดที่ทดสอบ
3. Assert — ตรวจสอบผลลัพธ์
4. Teardown — cleanup

### 9.1.3 การใช้งาน

**ทดสอบ function:**

```python
# calculator.py
def add(a: float, b: float) -> float:
    return a + b


def divide(a: float, b: float) -> float:
    if b == 0:
        raise ValueError("หารด้วยศูนย์ไม่ได้")
    return a / b


# test_calculator.py
def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0
    assert add(1.5, 2.5) == 4.0


def test_divide():
    assert divide(10, 2) == 5
    assert divide(10, 4) == 2.5


def test_divide_by_zero():
    import pytest
    with pytest.raises(ValueError):
        divide(10, 0)
```

**ทดสอบ class:**

```python
# bank.py
class BankAccount:
    def __init__(self, balance: float = 0):
        if balance < 0:
            raise ValueError("ยอดเงินต้องไม่ติดลบ")
        self._balance = balance

    @property
    def balance(self) -> float:
        return self._balance

    def deposit(self, amount: float) -> None:
        if amount <= 0:
            raise ValueError("จำนวนต้องมากกว่า 0")
        self._balance += amount

    def withdraw(self, amount: float) -> bool:
        if amount <= 0:
            raise ValueError("จำนวนต้องมากกว่า 0")
        if amount > self._balance:
            return False
        self._balance -= amount
        return True


# test_bank.py
import pytest


class TestBankAccount:
    def test_init(self):
        acc = BankAccount(100)
        assert acc.balance == 100

    def test_init_negative(self):
        with pytest.raises(ValueError):
            BankAccount(-100)

    def test_deposit(self):
        acc = BankAccount(100)
        acc.deposit(50)
        assert acc.balance == 150

    def test_deposit_invalid(self):
        acc = BankAccount(100)
        with pytest.raises(ValueError):
            acc.deposit(0)
        with pytest.raises(ValueError):
            acc.deposit(-10)

    def test_withdraw(self):
        acc = BankAccount(100)
        assert acc.withdraw(50) is True
        assert acc.balance == 50

    def test_withdraw_insufficient(self):
        acc = BankAccount(100)
        assert acc.withdraw(200) is False
        assert acc.balance == 100
```

**AAA Pattern:**

```python
def test_user_registration():
    # Arrange — เตรียมข้อมูล
    username = "somchai"
    email = "somchai@email.com"
    password = "Secure123!"

    # Act — เรียกโค้ด
    user = register_user(username, email, password)

    # Assert — ตรวจสอบ
    assert user.username == username
    assert user.email == email
    assert user.is_active is True
    assert user.password_hash != password  # hash แล้ว
```

**ทดสอบ Edge Cases:**

```python
def parse_age(value: str) -> int:
    """แปลง string เป็นอายุ"""
    age = int(value)
    if not 0 <= age <= 150:
        raise ValueError("อายุต้องอยู่ 0-150")
    return age


# test_parse_age.py
import pytest


def test_valid_ages():
    assert parse_age("0") == 0
    assert parse_age("30") == 30
    assert parse_age("150") == 150


def test_invalid_ages():
    with pytest.raises(ValueError):
        parse_age("-1")
    with pytest.raises(ValueError):
        parse_age("151")


def test_invalid_format():
    with pytest.raises(ValueError):
        parse_age("abc")
    with pytest.raises(ValueError):
        parse_age("")
    with pytest.raises(ValueError):
        parse_age("12.5")


def test_whitespace():
    assert parse_age("  30  ") == 30  # ถ้า strip
    # หรือ pytest.raises ถ้าไม่ strip
```

**Test Doubles:**

```python
from unittest.mock import Mock


class EmailService:
    def send(self, to: str, subject: str) -> bool:
        # ส่งจริง
        ...


class UserService:
    def __init__(self, email_service: EmailService):
        self.email_service = email_service

    def register(self, email: str) -> dict:
        user = {"email": email, "active": True}
        self.email_service.send(email, "Welcome")
        return user


# test_user_service.py
def test_register_sends_email():
    # Arrange
    mock_email = Mock(spec=EmailService)
    service = UserService(mock_email)

    # Act
    user = service.register("test@email.com")

    # Assert
    assert user["email"] == "test@email.com"
    mock_email.send.assert_called_once_with(
        "test@email.com",
        "Welcome",
    )
```

**ตัวอย่างการใช้งานจริง — Test Suite:**

```python
# src/calculator.py
from typing import Union

Number = Union[int, float]


class Calculator:
    def add(self, a: Number, b: Number) -> Number:
        return a + b

    def subtract(self, a: Number, b: Number) -> Number:
        return a - b

    def multiply(self, a: Number, b: Number) -> Number:
        return a * b

    def divide(self, a: Number, b: Number) -> float:
        if b == 0:
            raise ZeroDivisionError("หารด้วยศูนย์ไม่ได้")
        return a / b

    def power(self, base: Number, exp: Number) -> Number:
        return base ** exp

    def sqrt(self, n: Number) -> float:
        if n < 0:
            raise ValueError("รากที่สองของจำนวนลบไม่ได้")
        return n ** 0.5


# tests/test_calculator.py
import pytest
from src.calculator import Calculator


@pytest.fixture
def calc():
    return Calculator()


class TestAdd:
    def test_integers(self, calc):
        assert calc.add(2, 3) == 5
        assert calc.add(-1, 1) == 0

    def test_floats(self, calc):
        assert calc.add(1.5, 2.5) == 4.0

    def test_mixed(self, calc):
        assert calc.add(1, 2.5) == 3.5


class TestDivide:
    def test_normal(self, calc):
        assert calc.divide(10, 2) == 5
        assert calc.divide(7, 2) == 3.5

    def test_by_zero(self, calc):
        with pytest.raises(ZeroDivisionError):
            calc.divide(10, 0)

    def test_negative(self, calc):
        assert calc.divide(-10, 2) == -5


class TestSqrt:
    def test_positive(self, calc):
        assert calc.sqrt(4) == 2
        assert calc.sqrt(9) == 3
        assert calc.sqrt(2) == pytest.approx(1.414, rel=1e-3)

    def test_zero(self, calc):
        assert calc.sqrt(0) == 0

    def test_negative(self, calc):
        with pytest.raises(ValueError):
            calc.sqrt(-1)
```

### 9.1.4 ข้อดี

- **เร็ว:** รันเร็วมาก
- **Isolated:** ไม่พึ่ง external
- **Debug ง่าย:** ระบุจุดผิด
- **Documentation:** บอก behavior
- **Refactor:** ปลอดภัย
- **Regression:** จับ bug

### 9.1.5 ข้อเสีย

- **ไม่พอ:** ต้อง integration test
- **Time:** เขียนใช้เวลา
- **Maintenance:** ต้อง update
- **False confidence:** อาจไม่ครอบคลุม

### 9.1.6 ข้อควรระวัง

```python
# ระวัง 1: Test coupling กับ implementation
# ❌
def test_user_service():
    service = UserService()
    service.create_user("test")
    assert service._users == {"test"}  # ผูก internal

# ✅
def test_user_service():
    service = UserService()
    user = service.create_user("test")
    assert user.name == "test"
    assert service.get_user("test") == user

# ระวัง 2: Test ที่ไม่ deterministic
# ❌
def test_random():
    result = random.randint(1, 10)
    assert result > 0  # อาจ fail นาน ๆ ครั้ง

# ✅ ใช้ seed หรือ mock

# ระวัง 3: Test หลายอย่างใน 1 test
# ❌
def test_everything():
    assert add(1, 2) == 3
    assert subtract(5, 3) == 2
    assert multiply(2, 3) == 6

# ✅ แยก
def test_add():
    assert add(1, 2) == 3

def test_subtract():
    assert subtract(5, 3) == 2

# ระวัง 4: Test ที่ depend on order
# ❌
def test_a():
    global state
    state = 1

def test_b():
    assert state == 1  # depend on test_a

# ✅ isolated

# ระวัง 5: ไม่ทดสอบ edge cases
# ❌
def test_divide():
    assert divide(10, 2) == 5
    # ไม่ทดสอบ divide by zero

# ✅
def test_divide_by_zero():
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)

# ระวัง 6: Test ช้า
# ❌
def test_api():
    response = requests.get("https://api.example.com")  # ช้า
    assert response.status_code == 200

# ✅ mock
def test_api(mock_requests):
    mock_requests.get.return_value.status_code = 200
    ...
```

### 9.1.7 สรุป

**หลัก AAA:**
- **A**rrange — เตรียม
- **A**ct — ทำ
- **A**ssert — ตรวจ

**Best practices:**
- Test เดียว ทดสอบเดียว
- ชื่อบอก behavior
- ครอบคลุม edge cases
- ไม่ผูก implementation
- Deterministic
- เร็ว
- Isolated

**Coverage:**
- Happy path
- Edge cases
- Error cases
- Boundary values

> **อ้างอิงเพิ่มเติม:** [unittest](https://docs.python.org/3/library/unittest.html), [pytest](https://docs.pytest.org/)

---

## 9.2 unittest

### บทนำ

`unittest` เป็น testing framework มาตรฐานของ Python มาพร้อม Python ใช้ `TestCase` class

### นิยาม

`unittest` เป็น xUnit-style testing framework ใน standard library

### 9.2.1 คืออะไร

**Components:**
- `TestCase` — base class
- `TestSuite` — กลุ่ม tests
- `TestLoader` — โหลด tests
- `TestRunner` — รัน tests
- `assert*` methods

### 9.2.2 ทำงานอย่างไร

1. สร้าง class ที่ inherit `unittest.TestCase`
2. สร้าง methods ที่ขึ้นต้นด้วย `test_`
3. รันด้วย `unittest.main()` หรือ `pytest`

### 9.2.3 การใช้งาน

**พื้นฐาน:**

```python
import unittest


def add(a: int, b: int) -> int:
    return a + b


class TestAdd(unittest.TestCase):
    def test_positive(self):
        self.assertEqual(add(2, 3), 5)

    def test_negative(self):
        self.assertEqual(add(-1, -2), -3)

    def test_zero(self):
        self.assertEqual(add(0, 0), 0)


if __name__ == "__main__":
    unittest.main()
```

**Assertion Methods:**

```python
import unittest


class TestAssertions(unittest.TestCase):
    def test_equality(self):
        self.assertEqual(1 + 1, 2)
        self.assertNotEqual(1, 2)

    def test_truth(self):
        self.assertTrue(1 < 2)
        self.assertFalse(1 > 2)

    def test_none(self):
        self.assertIsNone(None)
        self.assertIsNotNone(0)

    def test_identity(self):
        a = [1, 2]
        b = a
        self.assertIs(a, b)
        self.assertIsNot(a, [1, 2])

    def test_membership(self):
        self.assertIn(1, [1, 2, 3])
        self.assertNotIn(4, [1, 2, 3])

    def test_comparison(self):
        self.assertGreater(5, 3)
        self.assertGreaterEqual(5, 5)
        self.assertLess(3, 5)
        self.assertLessEqual(5, 5)

    def test_types(self):
        self.assertIsInstance(1, int)
        self.assertNotIsInstance(1, str)

    def test_almost_equal(self):
        self.assertAlmostEqual(0.1 + 0.2, 0.3, places=7)

    def test_raises(self):
        with self.assertRaises(ValueError):
            int("abc")

    def test_regex(self):
        self.assertRegex("hello123", r"\d+")
        self.assertNotRegex("hello", r"\d+")

    def test_collections(self):
        self.assertListEqual([1, 2], [1, 2])
        self.assertDictEqual({"a": 1}, {"a": 1})
        self.assertSetEqual({1, 2}, {2, 1})
```

**setUp / tearDown:**

```python
import unittest


class BankAccount:
    def __init__(self, balance: float = 0):
        self._balance = balance

    @property
    def balance(self) -> float:
        return self._balance

    def deposit(self, amount: float) -> None:
        if amount <= 0:
            raise ValueError("ต้องมากกว่า 0")
        self._balance += amount

    def withdraw(self, amount: float) -> bool:
        if amount > self._balance:
            return False
        self._balance -= amount
        return True


class TestBankAccount(unittest.TestCase):
    def setUp(self):
        """เรียกก่อนทุก test"""
        self.account = BankAccount(100)

    def tearDown(self):
        """เรียกหลังทุก test"""
        self.account = None

    def test_initial_balance(self):
        self.assertEqual(self.account.balance, 100)

    def test_deposit(self):
        self.account.deposit(50)
        self.assertEqual(self.account.balance, 150)

    def test_withdraw(self):
        self.assertTrue(self.account.withdraw(50))
        self.assertEqual(self.account.balance, 50)


class TestBankAccountWithClassSetup(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        """เรียกครั้งเดียวก่อนทุก test ใน class"""
        cls.shared_data = {"initial_balance": 100}

    @classmethod
    def tearDownClass(cls):
        """เรียกครั้งเดียวหลังทุก test"""
        cls.shared_data = None

    def test_something(self):
        self.assertEqual(self.shared_data["initial_balance"], 100)
```

**Skip Tests:**

```python
import unittest
import sys


class TestSkip(unittest.TestCase):
    @unittest.skip("ยังไม่ implement")
    def test_not_ready(self):
        pass

    @unittest.skipIf(sys.version_info < (3, 10), "ต้อง Python 3.10+")
    def test_new_feature(self):
        pass

    @unittest.skipUnless(sys.platform == "linux", "Linux only")
    def test_linux_specific(self):
        pass

    @unittest.expectedFailure
    def test_known_bug(self):
        self.assertEqual(1, 2)  # คาดว่าจะ fail
```

**SubTest:**

```python
import unittest


class TestMultipleCases(unittest.TestCase):
    def test_multiple_values(self):
        cases = [
            (2, 3, 5),
            (0, 0, 0),
            (-1, 1, 0),
            (100, 200, 300),
        ]

        for a, b, expected in cases:
            with self.subTest(a=a, b=b):
                self.assertEqual(a + b, expected)
```

**Command Line:**

```bash
# รันทุก tests
python -m unittest

# รัน module
python -m unittest tests.test_calculator

# รัน class
python -m unittest tests.test_calculator.TestCalculator

# รัน method
python -m unittest tests.test_calculator.TestCalculator.test_add

# Verbose
python -m unittest -v

# Pattern
python -m unittest discover -s tests -p "test_*.py"
```

**ตัวอย่างการใช้งานจริง — Test Suite:**

```python
# src/user.py
from dataclasses import dataclass, field
from datetime import datetime
import re


@dataclass
class User:
    username: str
    email: str
    created_at: datetime = field(default_factory=datetime.now)
    is_active: bool = True


class UserValidationError(Exception):
    pass


def validate_username(username: str) -> str:
    if not username:
        raise UserValidationError("username ต้องไม่ว่าง")
    if not re.match(r"^[a-zA-Z0-9_]{3,20}$", username):
        raise UserValidationError(
            "username ต้องมี 3-20 ตัวอักษร (a-z, A-Z, 0-9, _)"
        )
    return username


def validate_email(email: str) -> str:
    if not email:
        raise UserValidationError("email ต้องไม่ว่าง")
    if not re.match(r"^[\w.+-]+@[\w-]+\.[\w.]+$", email):
        raise UserValidationError("email ไม่ถูกต้อง")
    return email.lower()


def create_user(username: str, email: str) -> User:
    return User(
        username=validate_username(username),
        email=validate_email(email),
    )


# tests/test_user.py
import unittest
from datetime import datetime
from src.user import (
    User,
    UserValidationError,
    create_user,
    validate_username,
    validate_email,
)


class TestValidateUsername(unittest.TestCase):
    def test_valid(self):
        valid = ["user1", "user_name", "USER123", "abc"]
        for username in valid:
            with self.subTest(username=username):
                self.assertEqual(validate_username(username), username)

    def test_empty(self):
        with self.assertRaises(UserValidationError):
            validate_username("")

    def test_too_short(self):
        with self.assertRaises(UserValidationError):
            validate_username("ab")

    def test_too_long(self):
        with self.assertRaises(UserValidationError):
            validate_username("a" * 21)

    def test_invalid_chars(self):
        with self.assertRaises(UserValidationError):
            validate_username("user-name")
        with self.assertRaises(UserValidationError):
            validate_username("user@name")


class TestValidateEmail(unittest.TestCase):
    def test_valid(self):
        valid = [
            "user@example.com",
            "user.name@example.com",
            "user+tag@example.co.th",
        ]
        for email in valid:
            with self.subTest(email=email):
                self.assertEqual(
                    validate_email(email),
                    email.lower(),
                )

    def test_normalizes_to_lowercase(self):
        self.assertEqual(
            validate_email("USER@EXAMPLE.COM"),
            "user@example.com",
        )

    def test_invalid(self):
        invalid = ["", "invalid", "@example.com", "user@", "user@.com"]
        for email in invalid:
            with self.subTest(email=email):
                with self.assertRaises(UserValidationError):
                    validate_email(email)


class TestCreateUser(unittest.TestCase):
    def test_creates_user(self):
        user = create_user("testuser", "test@example.com")
        self.assertIsInstance(user, User)
        self.assertEqual(user.username, "testuser")
        self.assertEqual(user.email, "test@example.com")
        self.assertTrue(user.is_active)

    def test_created_at(self):
        before = datetime.now()
        user = create_user("testuser", "test@example.com")
        after = datetime.now()
        self.assertGreaterEqual(user.created_at, before)
        self.assertLessEqual(user.created_at, after)


if __name__ == "__main__":
    unittest.main()
```

### 9.2.4 ข้อดี

- **Built-in:** ไม่ต้องติดตั้ง
- **Standard:** xUnit style
- **Complete:** assert methods ครบ
- **Test discovery:** อัตโนมัติ

### 9.2.5 ข้อเสีย

- **Verbose:** เยอะกว่า pytest
- **Boilerplate:** ต้อง inherit
- **Less features:** กว่า pytest
- **Assertions:** ต้องใช้ `self.assert*`

### 9.2.6 ข้อควรระวัง

```python
# ระวัง 1: ชื่อ method
# ❌
class TestCalc(unittest.TestCase):
    def check_add(self):  # ไม่ถูกรัน
        pass

# ✅
class TestCalc(unittest.TestCase):
    def test_add(self):  # ต้องขึ้นต้น test_
        pass

# ระวัง 2: setUp กับ instance
# ❌
class TestX(unittest.TestCase):
    def setUp(self):
        self.value = 10  # per test

    def test_a(self):
        self.value = 20  # แก้ — ไม่กระทบ test_b

    def test_b(self):
        self.assertEqual(self.value, 10)  # ✅ ยังเป็น 10

# ระวัง 3: assertEqual กับ floats
# ❌
self.assertEqual(0.1 + 0.2, 0.3)  # fail

# ✅
self.assertAlmostEqual(0.1 + 0.2, 0.3)

# ระวัง 4: assertRaises แบบเก่า
# ❌ (deprecated)
self.assertRaises(ValueError, int, "abc")

# ✅
with self.assertRaises(ValueError):
    int("abc")

# ระวัง 5: Test order
# unittest อาจรันตามชื่อ (alphabetical)
# อย่าพึ่งพาลำดับ
```

### 9.2.7 สรุป

**Structure:**

```python
class TestX(unittest.TestCase):
    def setUp(self): ...
    def tearDown(self): ...
    def test_something(self): ...
```

**Assertions:**

| Method | ใช้ |
|--------|-----|
| `assertEqual` | เท่ากัน |
| `assertTrue`/`False` | boolean |
| `assertIsNone` | None |
| `assertIn` | membership |
| `assertRaises` | exception |
| `assertAlmostEqual` | float |

**Best practices:**
- inherit `TestCase`
- `test_` prefix
- `setUp`/`tearDown`
- `subTest` สำหรับ cases
- `assertRaises` context manager

> **อ้างอิงเพิ่มเติม:** [unittest Documentation](https://docs.python.org/3/library/unittest.html)

---

## 9.3 pytest

### บทนำ

`pytest` เป็น testing framework ที่นิยมที่สุดใน Python ใช้ `assert` ธรรมดา มี fixtures, parametrize และ plugins

### นิยาม

`pytest` เป็น third-party testing framework ที่เรียบง่ายแต่ทรงพลัง

### 9.3.1 คืออะไร

**ข้อดี:**
- `assert` ธรรมดา
- Fixtures
- Parametrize
- Plugins เยอะ
- Auto-discovery

### 9.3.2 ทำงานอย่างไร

pytest หา `test_*.py` หรือ `*_test.py` และ functions `test_*`

### 9.3.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install pytest
```

**พื้นฐาน:**

```python
# test_calculator.py
def add(a: int, b: int) -> int:
    return a + b


def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
```

**Assertions:**

```python
import pytest


def test_assertions():
    # ใช้ assert ธรรมดา
    assert 1 + 1 == 2
    assert "hello".upper() == "HELLO"
    assert [1, 2, 3] == [1, 2, 3]

    # Exception
    with pytest.raises(ValueError):
        int("abc")

    # Exception message
    with pytest.raises(ValueError, match="invalid literal"):
        int("abc")

    # Float
    assert 0.1 + 0.2 == pytest.approx(0.3)
    assert 1.0001 == pytest.approx(1.0, rel=1e-3)

    # ตรวจสอบ
    assert 1 in [1, 2, 3]
    assert "key" in {"key": "value"}
    assert hasattr("string", "upper")
```

**Fixtures:**

```python
import pytest


@pytest.fixture
def sample_data():
    """Fixture พื้นฐาน"""
    return [1, 2, 3, 4, 5]


def test_sum(sample_data):
    assert sum(sample_data) == 15


def test_length(sample_data):
    assert len(sample_data) == 5


# Fixture with setup/teardown
@pytest.fixture
def db_connection():
    """Fixture ที่มี cleanup"""
    conn = create_connection()
    yield conn
    conn.close()


def test_query(db_connection):
    result = db_connection.execute("SELECT 1")
    assert result == 1


# Fixture scope
@pytest.fixture(scope="module")
def expensive_resource():
    """สร้างครั้งเดียวต่อ module"""
    print("Creating...")
    return {"data": "expensive"}


def test_a(expensive_resource):
    assert expensive_resource["data"] == "expensive"

def test_b(expensive_resource):
    assert expensive_resource["data"] == "expensive"


# Fixture ที่ใช้ fixture อื่น
@pytest.fixture
def user(sample_data):
    return {"name": "test", "data": sample_data}


def test_user(user):
    assert len(user["data"]) == 5
```

**conftest.py:**

```python
# conftest.py — ใช้ร่วมทุก tests
import pytest


@pytest.fixture
def app_config():
    return {
        "debug": True,
        "database": "test_db",
    }


# tests/unit/test_a.py
def test_config(app_config):
    assert app_config["debug"] is True
```

**Parametrize:**

```python
import pytest


@pytest.mark.parametrize(
    "a,b,expected",
    [
        (1, 2, 3),
        (0, 0, 0),
        (-1, 1, 0),
        (100, 200, 300),
    ],
)
def test_add(a, b, expected):
    assert a + b == expected


# กับ exception
@pytest.mark.parametrize(
    "value,expected",
    [
        ("1", 1),
        ("42", 42),
        ("-10", -10),
    ],
)
def test_valid_int(value, expected):
    assert int(value) == expected


@pytest.mark.parametrize(
    "value",
    ["abc", "", "1.5", None],
)
def test_invalid_int(value):
    with pytest.raises((ValueError, TypeError)):
        int(value)
```

**Markers:**

```python
import pytest


@pytest.mark.slow
def test_slow_operation():
    import time
    time.sleep(1)


@pytest.mark.skip(reason="ยังไม่ implement")
def test_not_ready():
    pass


@pytest.mark.skipif(
    sys.version_info < (3, 10),
    reason="ต้อง Python 3.10+",
)
def test_new_feature():
    pass


@pytest.mark.xfail(reason="known bug")
def test_known_bug():
    assert False


# Custom marker
@pytest.mark.integration
def test_database():
    pass
```

**pytest.ini / pyproject.toml:**

```ini
# pytest.ini
[pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
markers =
    slow: marks tests as slow
    integration: integration tests
addopts = -v --tb=short
```

```toml
# pyproject.toml
[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v --cov=src --cov-report=term-missing"
markers = [
    "slow: marks tests as slow",
    "integration: integration tests",
]
```

**ตัวอย่างการใช้งานจริง — Test Suite:**

```python
# src/order.py
from dataclasses import dataclass, field
from decimal import Decimal
from enum import Enum
from typing import Optional


class OrderStatus(Enum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    SHIPPED = "shipped"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"


@dataclass
class OrderItem:
    product_id: str
    name: str
    price: Decimal
    quantity: int

    @property
    def subtotal(self) -> Decimal:
        return self.price * self.quantity


@dataclass
class Order:
    customer_id: str
    items: list[OrderItem] = field(default_factory=list)
    status: OrderStatus = OrderStatus.PENDING
    _id: Optional[str] = None

    @property
    def total(self) -> Decimal:
        return sum(item.subtotal for item in self.items)

    def add_item(self, item: OrderItem) -> None:
        if self.status != OrderStatus.PENDING:
            raise ValueError("ไม่สามารถเพิ่มสินค้าได้")
        self.items.append(item)

    def confirm(self) -> None:
        if not self.items:
            raise ValueError("ไม่มีสินค้า")
        if self.status != OrderStatus.PENDING:
            raise ValueError("สถานะไม่ถูกต้อง")
        self.status = OrderStatus.CONFIRMED

    def cancel(self) -> None:
        if self.status in (OrderStatus.SHIPPED, OrderStatus.DELIVERED):
            raise ValueError("ไม่สามารถยกเลิกได้")
        self.status = OrderStatus.CANCELLED


# tests/test_order.py
import pytest
from decimal import Decimal
from src.order import Order, OrderItem, OrderStatus


@pytest.fixture
def sample_item():
    return OrderItem(
        product_id="P001",
        name="Laptop",
        price=Decimal("35000"),
        quantity=1,
    )


@pytest.fixture
def sample_items():
    return [
        OrderItem("P001", "Laptop", Decimal("35000"), 1),
        OrderItem("P002", "Mouse", Decimal("850"), 2),
    ]


@pytest.fixture
def order(sample_items):
    return Order(customer_id="C001", items=sample_items)


class TestOrderItem:
    def test_subtotal(self, sample_item):
        assert sample_item.subtotal == Decimal("35000")

    def test_subtotal_multiple(self):
        item = OrderItem("P001", "Test", Decimal("100"), 5)
        assert item.subtotal == Decimal("500")


class TestOrder:
    def test_total(self, order):
        expected = Decimal("35000") + Decimal("850") * 2
        assert order.total == expected

    def test_empty_order_total(self):
        order = Order(customer_id="C001")
        assert order.total == Decimal("0")

    def test_initial_status(self, order):
        assert order.status == OrderStatus.PENDING

    def test_add_item(self, order):
        new_item = OrderItem("P003", "Keyboard", Decimal("2500"), 1)
        order.add_item(new_item)
        assert len(order.items) == 3
        assert new_item in order.items

    def test_add_item_to_confirmed_order(self, order):
        order.confirm()
        with pytest.raises(ValueError, match="ไม่สามารถเพิ่ม"):
            order.add_item(OrderItem("P003", "Test", Decimal("100"), 1))


class TestOrderConfirm:
    def test_confirm(self, order):
        order.confirm()
        assert order.status == OrderStatus.CONFIRMED

    def test_confirm_empty(self):
        order = Order(customer_id="C001")
        with pytest.raises(ValueError, match="ไม่มีสินค้า"):
            order.confirm()

    def test_confirm_twice(self, order):
        order.confirm()
        with pytest.raises(ValueError):
            order.confirm()


class TestOrderCancel:
    def test_cancel_pending(self, order):
        order.cancel()
        assert order.status == OrderStatus.CANCELLED

    def test_cancel_confirmed(self, order):
        order.confirm()
        order.cancel()
        assert order.status == OrderStatus.CANCELLED

    @pytest.mark.parametrize(
        "status",
        [OrderStatus.SHIPPED, OrderStatus.DELIVERED],
    )
    def test_cancel_shipped_delivered(self, order, status):
        order.status = status
        with pytest.raises(ValueError, match="ไม่สามารถยกเลิก"):
            order.cancel()


# Parameterized test
@pytest.mark.parametrize(
    "items,expected_total",
    [
        ([], Decimal("0")),
        ([OrderItem("P1", "A", Decimal("100"), 1)], Decimal("100")),
        ([OrderItem("P1", "A", Decimal("100"), 3)], Decimal("300")),
        (
            [
                OrderItem("P1", "A", Decimal("100"), 1),
                OrderItem("P2", "B", Decimal("50"), 2),
            ],
            Decimal("200"),
        ),
    ],
)
def test_total_calculation(items, expected_total):
    order = Order(customer_id="C001", items=items)
    assert order.total == expected_total
```

**Command Line:**

```bash
# รันทุก tests
pytest

# Verbose
pytest -v

# หยุดที่ fail แรก
pytest -x

# รัน file
pytest tests/test_order.py

# รัน class
pytest tests/test_order.py::TestOrder

# รัน method
pytest tests/test_order.py::TestOrder::test_total

# รันตาม marker
pytest -m slow
pytest -m "not slow"

# Show locals
pytest -l

# Coverage
pytest --cov=src --cov-report=html

# Parallel
pytest -n auto  # ต้อง pytest-xdist

# Last failed
pytest --lf

# Failed first
pytest --ff
```

### 9.3.4 ข้อดี

- **Simple:** `assert` ธรรมดา
- **Powerful:** fixtures, parametrize
- **Extensible:** plugins เยอะ
- **Discovery:** อัตโนมัติ
- **Output:** อ่านง่าย

### 9.3.5 ข้อเสีย

- **Third-party:** ต้องติดตั้ง
- **Magic:** fixtures อาจซับซ้อน
- **Learning:** ต้องเรียนรู้

### 9.3.6 ข้อควรระวัง

```python
# ระวัง 1: Fixture scope
# ❌ default = function
@pytest.fixture
def expensive():
    return load_expensive()  # ทุก test

# ✅ ถ้าใช้ร่วมได้
@pytest.fixture(scope="session")
def expensive():
    return load_expensive()

# ระวัง 2: Fixture ที่ mutate
# ❌
@pytest.fixture
def items():
    return []  # แต่ default = function scope → OK

# ⚠️ ถ้า scope ใหญ่
@pytest.fixture(scope="module")
def items():
    return []  # แชร์ระหว่าง tests!

# ระวัง 3: ใช้ assert ใน fixture
# ❌
@pytest.fixture
def data():
    result = load()
    assert result is not None  # ❌
    return result

# ✅
@pytest.fixture
def data():
    return load()

# ระวัง 4: Test order
# pytest ไม่การันตี order
# อย่าพึ่งพา

# ระวัง 5: Monkey patch
def test_something(monkeypatch):
    monkeypatch.setenv("DEBUG", "true")
    # ...

# ระวัง 6: Capturing output
def test_print(capsys):
    print("hello")
    captured = capsys.readouterr()
    assert captured.out == "hello\n"
```

### 9.3.7 สรุป

**Core Concepts:**

| Concept | ใช้ |
|---------|-----|
| `assert` | ตรวจสอบ |
| `pytest.raises` | Exception |
| `@pytest.fixture` | Setup |
| `@pytest.mark.parametrize` | หลาย cases |
| `@pytest.mark.skip` | ข้าม |
| `conftest.py` | Fixtures ร่วม |

**Best practices:**
- `assert` ธรรมดา
- Fixtures สำหรับ setup
- Parametrize สำหรับ cases
- `conftest.py` สำหรับ shared
- Markers สำหรับ categories
- ใช้ `pytest.approx` สำหรับ float

> **อ้างอิงเพิ่มเติม:** [pytest Documentation](https://docs.pytest.org/)

---

## 9.4 doctest

### บทนำ

`doctest` เป็น module ที่ทดสอบ docstrings โดยรันตัวอย่างใน docstring และเปรียบเทียบผลลัพธ์

### นิยาม

doctest คือ testing framework ที่ใช้ interactive Python examples ใน docstrings เป็น tests

### 9.4.1 คืออะไร

**ข้อดี:**
- Documentation เป็น test
- ง่ายต่อการเขียน
- ตรวจสอบ examples

**ข้อเสีย:**
- จำกัด
- ไม่เหมาะ complex logic
- Fragile

### 9.4.2 ทำงานอย่างไร

doctest:
1. หา `>>>` ใน docstring
2. รันคำสั่ง
3. เปรียบเทียบ output กับที่เขียน

### 9.4.3 การใช้งาน

**พื้นฐาน:**

```python
def add(a: int, b: int) -> int:
    """
    บวกเลขสองจำนวน

    >>> add(2, 3)
    5
    >>> add(-1, 1)
    0
    >>> add(0, 0)
    0
    """
    return a + b


if __name__ == "__main__":
    import doctest
    doctest.testmod()
```

**รัน:**

```bash
# รัน doctests
python -m doctest -v mymodule.py

# หรือใน code
import doctest
doctest.testmod()
```

**Exceptions:**

```python
def divide(a: float, b: float) -> float:
    """
    หารเลข

    >>> divide(10, 2)
    5.0
    >>> divide(10, 0)
    Traceback (most recent call last):
        ...
    ZeroDivisionError: division by zero
    """
    return a / b
```

**Multiple lines:**

```python
def process(items: list[int]) -> list[int]:
    """
    Process items

    >>> items = [1, 2, 3]
    >>> result = process(items)
    >>> result
    [2, 4, 6]
    >>> len(result)
    3
    """
    return [x * 2 for x in items]
```

**Print:**

```python
def greet(name: str) -> None:
    """
    ทักทาย

    >>> greet("World")
    Hello, World!
    """
    print(f"Hello, {name}!")
```

**ELLIPSIS:**

```python
def get_data() -> dict:
    """
    >>> get_data()  # doctest: +ELLIPSIS
    {'id': ..., 'name': 'test', 'timestamp': ...}
    """
    import time
    return {"id": 1, "name": "test", "timestamp": time.time()}


# หรือใช้ # doctest: +ELLIPSIS ที่ module level
```

**Directives:**

```python
def example() -> None:
    """
    >>> 1 + 1  # doctest: +SKIP
    999

    >>> print("hello")  # doctest: +NORMALIZE_WHITESPACE
    hello

    >>> sorted([3, 1, 2])
    [1, 2, 3]
    """
```

**Common Directives:**

| Directive | ใช้ |
|-----------|-----|
| `+SKIP` | ข้าม |
| `+ELLIPSIS` | `...` match อะไรก็ได้ |
| `+NORMALIZE_WHITESPACE` | ไม่สน whitespace |
| `+IGNORE_EXCEPTION_DETAIL` | ไม่สน exception details |
| `+IGNORE_WHITESPACE` | ลบ whitespace |

**ตัวอย่างการใช้งานจริง — Utility Functions:**

```python
# string_utils.py


def slugify(text: str) -> str:
    """
    สร้าง slug จาก text

    >>> slugify("Hello World")
    'hello-world'
    >>> slugify("Python 3.12")
    'python-312'
    >>> slugify("  spaces  ")
    'spaces'
    >>> slugify("Special!@#chars")
    'specialchars'
    """
    import re
    text = text.lower().strip()
    text = re.sub(r"[^\w\s-]", "", text)
    text = re.sub(r"[-\s]+", "-", text)
    return text.strip("-")


def truncate(text: str, length: int, suffix: str = "...") -> str:
    """
    ตัด text ให้สั้นลง

    >>> truncate("Hello World", 8)
    'Hello...'
    >>> truncate("Short", 10)
    'Short'
    >>> truncate("Hello World", 8, ">>")
    'Hello>>'
    >>> truncate("", 5)
    ''
    """
    if len(text) <= length:
        return text
    return text[:length - len(suffix)] + suffix


def to_camel_case(text: str) -> str:
    """
    แปลงเป็น camelCase

    >>> to_camel_case("hello world")
    'helloWorld'
    >>> to_camel_case("foo_bar_baz")
    'fooBarBaz'
    >>> to_camel_case("Already-Camel")
    'alreadyCamel'
    """
    import re
    words = re.split(r"[-_\s]+", text.lower())
    if not words:
        return ""
    return words[0] + "".join(w.title() for w in words[1:])


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
```

**ตัวอย่าง — Class:**

```python
class Stack:
    """
    Stack implementation

    >>> s = Stack()
    >>> s.is_empty()
    True
    >>> s.push(1)
    >>> s.push(2)
    >>> s.peek()
    2
    >>> s.pop()
    2
    >>> len(s)
    1
    >>> bool(s)
    True
    >>> s.pop()
    1
    >>> s.is_empty()
    True
    >>> bool(s)
    False
    """

    def __init__(self) -> None:
        self._items: list = []

    def push(self, item) -> None:
        self._items.append(item)

    def pop(self):
        if self.is_empty():
            raise IndexError("pop from empty stack")
        return self._items.pop()

    def peek(self):
        if self.is_empty():
            raise IndexError("peek from empty stack")
        return self._items[-1]

    def is_empty(self) -> bool:
        return len(self._items) == 0

    def __len__(self) -> int:
        return len(self._items)

    def __bool__(self) -> bool:
        return bool(self._items)
```

**pytest integration:**

```bash
# รัน doctests ผ่าน pytest
pytest --doctest-modules

# หรือใน pyproject.toml
```

```toml
[tool.pytest.ini_options]
addopts = "--doctest-modules"
```

### 9.4.4 ข้อดี

- **Documentation:** docstring เป็น test
- **Easy:** เขียนง่าย
- **Always updated:** examples ตรง
- **No dependencies:** built-in

### 9.4.5 ข้อเสีย

- **Limited:** ไม่เหมาะ complex
- **Fragile:** ไวต่อ formatting
- **Verbose:** docstring ยาว
- **Slow:** รันทุก example

### 9.4.6 ข้อควรระวัง

```python
# ระวัง 1: Whitespace
def bad():
    """
    >>> print("hello")
    hello
    """  # ✅

def bad2():
    """
    >>> print("hello")
    hello   ← trailing space ❌
    """

# ระวัง 2: Dict ordering
def bad3():
    """
    >>> {"b": 2, "a": 1}  # ⚠️ order อาจต่าง
    {'a': 1, 'b': 2}
    """

# ✅ ใช้ sorted
def good3():
    """
    >>> sorted({"b": 2, "a": 1}.items())
    [('a', 1), ('b', 2)]
    """

# ระวัง 3: Float precision
def bad4():
    """
    >>> 0.1 + 0.2  # ❌
    0.3
    """

# ✅
def good4():
    """
    >>> round(0.1 + 0.2, 10)
    0.3
    """

# ระวัง 4: Random/time
def bad5():
    """
    >>> import random
    >>> random.randint(1, 10)  # ❌
    5
    """

# ✅ ใช้ seed หรือ skip

# ระวัง 5: Long output
def bad6():
    """
    >>> list(range(100))  # ❌ ยาวเกิน
    [0, 1, 2, ...]
    """

# ✅ ใช้ len หรือ slice
def good6():
    """
    >>> len(list(range(100)))
    100
    """
```

### 9.4.7 สรุป

**ใช้ doctest เมื่อ:**
- Utility functions
- Simple examples
- Documentation
- API examples

**Directives:**

| Directive | ใช้ |
|-----------|-----|
| `+SKIP` | ข้าม |
| `+ELLIPSIS` | `...` wildcard |
| `+NORMALIZE_WHITESPACE` | whitespace |

**Best practices:**
- Examples สั้น ชัดเจน
- หลีกเลี่ยง random/time
- `round()` สำหรับ float
- `sorted()` สำหรับ dict
- รันด้วย pytest `--doctest-modules`

> **อ้างอิงเพิ่มเติม:** [doctest Documentation](https://docs.python.org/3/library/doctest.html)

---

## 9.5 Test Fixture

### บทนำ

Fixture คือกลไกสำหรับ setup/teardown state ที่ tests ต้องการ เป็นหัวใจของ pytest

### นิยาม

Fixture คือ function ที่ pytest เรียกก่อน test เพื่อเตรียมข้อมูล/resources และอาจ cleanup หลัง test

### 9.5.1 คืออะไร

**ประโยชน์:**
- Setup/teardown
- Reuse
- Dependency injection
- Scoping

### 9.5.2 ทำงานอย่างไร

pytest:
1. เห็น test ต้องการ fixture (parameter)
2. หา fixture ที่ตรงชื่อ
3. เรียก fixture
4. ส่งผลลัพธ์ให้ test
5. Cleanup หลัง test

### 9.5.3 การใช้งาน

**พื้นฐาน:**

```python
import pytest


@pytest.fixture
def sample_data():
    return [1, 2, 3, 4, 5]


def test_sum(sample_data):
    assert sum(sample_data) == 15


def test_max(sample_data):
    assert max(sample_data) == 5
```

**Setup/Teardown:**

```python
import pytest


@pytest.fixture
def temp_file(tmp_path):
    """สร้าง temp file และลบหลัง test"""
    file = tmp_path / "test.txt"
    file.write_text("hello")

    yield file  # ส่งให้ test

    # Cleanup (optional — tmp_path ลบอัตโนมัติ)
    if file.exists():
        file.unlink()


def test_read_file(temp_file):
    assert temp_file.read_text() == "hello"
```

**Scope:**

```python
import pytest


@pytest.fixture(scope="function")  # default
def func_scope():
    print("setup function")
    yield
    print("teardown function")


@pytest.fixture(scope="class")
def class_scope():
    print("setup class")
    yield
    print("teardown class")


@pytest.fixture(scope="module")
def module_scope():
    print("setup module")
    yield
    print("teardown module")


@pytest.fixture(scope="session")
def session_scope():
    print("setup session")
    yield
    print("teardown session")
```

**conftest.py:**

```python
# tests/conftest.py
import pytest


@pytest.fixture
def db_config():
    return {
        "host": "localhost",
        "port": 5432,
        "database": "test",
    }


@pytest.fixture
def mock_user():
    return {
        "id": 1,
        "name": "test_user",
        "email": "test@example.com",
    }


# tests/test_user.py
def test_user(mock_user):
    assert mock_user["name"] == "test_user"
```

**Fixture ที่ depend on fixture:**

```python
import pytest


@pytest.fixture
def user_data():
    return {"name": "test", "email": "test@example.com"}


@pytest.fixture
def active_user(user_data):
    user_data["active"] = True
    return user_data


def test_active_user(active_user):
    assert active_user["active"] is True
    assert active_user["name"] == "test"
```

**Autouse:**

```python
import pytest


@pytest.fixture(autouse=True)
def setup_environment():
    """รันทุก test อัตโนมัติ"""
    import os
    original = os.environ.get("TESTING")
    os.environ["TESTING"] = "1"
    yield
    if original:
        os.environ["TESTING"] = original
    else:
        del os.environ["TESTING"]


def test_something():
    import os
    assert os.environ["TESTING"] == "1"
```

**Parametrized Fixtures:**

```python
import pytest


@pytest.fixture(params=["sqlite", "postgres", "mysql"])
def database(request):
    """Fixture ที่รันหลายครั้ง"""
    db_type = request.param
    db = create_database(db_type)
    yield db
    db.close()


def test_query(database):
    # รัน 3 ครั้ง — sqlite, postgres, mysql
    result = database.query("SELECT 1")
    assert result == 1
```

**Factory Fixture:**

```python
import pytest


@pytest.fixture
def make_user():
    """Factory ที่สร้าง users"""
    created = []

    def _make(name: str, email: str = None):
        if email is None:
            email = f"{name}@example.com"
        user = {"name": name, "email": email}
        created.append(user)
        return user

    yield _make

    # Cleanup
    created.clear()


def test_multiple_users(make_user):
    user1 = make_user("alice")
    user2 = make_user("bob")

    assert user1["email"] == "alice@example.com"
    assert user2["email"] == "bob@example.com"
```

**ตัวอย่างการใช้งานจริง — Database Fixture:**

```python
# tests/conftest.py
import pytest
import sqlite3
from pathlib import Path


@pytest.fixture(scope="session")
def db_schema() -> str:
    """Schema SQL"""
    return """
        CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            email TEXT UNIQUE NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );

        CREATE TABLE posts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            content TEXT,
            FOREIGN KEY (user_id) REFERENCES users(id)
        );
    """


@pytest.fixture
def db(db_schema):
    """In-memory database per test"""
    conn = sqlite3.connect(":memory:")
    conn.row_factory = sqlite3.Row
    conn.executescript(db_schema)

    yield conn

    conn.close()


@pytest.fixture
def populated_db(db):
    """Database ที่มีข้อมูล"""
    users = [
        ("alice", "alice@example.com"),
        ("bob", "bob@example.com"),
    ]

    for username, email in users:
        db.execute(
            "INSERT INTO users (username, email) VALUES (?, ?)",
            (username, email),
        )
    db.commit()

    return db


# tests/test_db.py
def test_empty_db(db):
    cursor = db.execute("SELECT COUNT(*) FROM users")
    assert cursor.fetchone()[0] == 0


def test_populated_db(populated_db):
    cursor = populated_db.execute("SELECT * FROM users")
    users = cursor.fetchall()
    assert len(users) == 2
    assert users[0]["username"] == "alice"
```

**ตัวอย่าง — API Client Fixture:**

```python
# tests/conftest.py
import pytest
from unittest.mock import Mock, patch
import httpx


@pytest.fixture
def mock_httpx():
    """Mock httpx client"""
    with patch("httpx.Client") as mock:
        client = Mock()
        mock.return_value.__enter__.return_value = client
        yield client


@pytest.fixture
def api_client(mock_httpx):
    """API client ที่ใช้ mock"""
    class APIClient:
        def __init__(self, base_url: str):
            self.base_url = base_url
            self.client = mock_httpx

        def get(self, path: str) -> dict:
            response = self.client.get(f"{self.base_url}{path}")
            return response.json()

    return APIClient("https://api.example.com")


# tests/test_api.py
def test_get_user(api_client, mock_httpx):
    mock_httpx.get.return_value.json.return_value = {
        "id": 1,
        "name": "test",
    }

    result = api_client.get("/users/1")

    assert result["id"] == 1
    mock_httpx.get.assert_called_once_with(
        "https://api.example.com/users/1"
    )
```

### 9.5.4 ข้อดี

- **Reusable:** ใช้ซ้ำได้
- **Composable:** fixtures ต่อกันได้
- **Scoped:** จัดการ lifecycle
- **Dependency injection:** ชัดเจน
- **Testable:** แยก concerns

### 9.5.5 ข้อเสีย

- **Magic:** อาจซับซ้อน
- **Learning:** ต้องเข้าใจ
- **Hidden:** ไม่เห็นใน test

### 9.5.6 ข้อควรระวัง

```python
# ระวัง 1: Scope ที่ผิด
# ❌ mutable state แชร์
@pytest.fixture(scope="module")
def items():
    return []  # แชร์ทุก test ใน module

def test_a(items):
    items.append(1)

def test_b(items):
    assert len(items) == 0  # ❌ fail! items มี [1]

# ✅ function scope
@pytest.fixture
def items():
    return []

# ระวัง 2: Teardown ไม่ทำงาน
# ❌
@pytest.fixture
def resource():
    r = acquire()
    return r  # ❌ ไม่มี yield → ไม่ teardown

# ✅
@pytest.fixture
def resource():
    r = acquire()
    yield r
    r.release()

# ระวัง 3: Exception ใน teardown
# ✅ ใช้ try/finally
@pytest.fixture
def resource():
    r = acquire()
    try:
        yield r
    finally:
        r.release()

# ระวัง 4: autouse มากเกินไป
# ❌
@pytest.fixture(autouse=True)
def setup():
    do_something()  # ทุก test

# ✅ ใช้เมื่อจำเป็นจริง ๆ

# ระวัง 5: Fixture ซ้อนลึก
# ❌ a → b → c → d → e
# ✅ อย่าให้ลึกเกิน 3-4

# ระวัง 6: Circular fixtures
# ❌ a depends on b, b depends on a
```

### 9.5.7 สรุป

**Scopes:**

| Scope | ใช้ |
|-------|-----|
| `function` | Default, per test |
| `class` | Per class |
| `module` | Per module |
| `package` | Per package |
| `session` | Per session |

**Patterns:**
- `yield` สำหรับ teardown
- Factory fixtures
- `autouse` สำหรับ setup ทั่วไป
- `conftest.py` สำหรับ shared

**Best practices:**
- ใช้ scope ให้เหมาะสม
- `yield` สำหรับ teardown
- `try/finally` สำหรับ cleanup
- Factory fixtures สำหรับ mutable
- หลีกเลี่ยง `autouse` ที่ไม่จำเป็น

> **อ้างอิงเพิ่มเติม:** [pytest Fixtures](https://docs.pytest.org/en/stable/fixture.html)

---

## 9.6 Mocking

### บทนำ

Mocking คือการแทน object จริงด้วย object ปลอมที่ควบคุมได้ ใช้สำหรับ isolate code ที่ทดสอบจาก dependencies

### นิยาม

Mock คือ object ที่บันทึกการเรียกใช้ และกำหนด return value ได้

### 9.6.1 คืออะไร

**ใช้เมื่อ:**
- Dependency ภายนอก (API, DB)
- Slow operations
- Non-deterministic (time, random)
- Side effects ที่ไม่ต้องการ

### 9.6.2 ทำงานอย่างไร

`unittest.mock` ให้:
- `Mock` — general purpose
- `MagicMock` — มี magic methods
- `patch` — แทนชั่วคราว
- `PropertyMock` — สำหรับ properties

### 9.6.3 การใช้งาน

**Mock พื้นฐาน:**

```python
from unittest.mock import Mock

# สร้าง mock
mock = Mock()

# เรียกใช้
result = mock.method(1, 2, key="value")
print(result)  # <Mock name='mock.method()' id='...'>

# ตรวจสอบการเรียก
mock.method.assert_called_once()
mock.method.assert_called_with(1, 2, key="value")
print(mock.method.call_count)  # 1
print(mock.method.call_args)   # call(1, 2, key='value')

# กำหนด return value
mock.method.return_value = 42
assert mock.method() == 42

# Side effect
mock.method.side_effect = [1, 2, 3]
assert mock.method() == 1
assert mock.method() == 2

# Side effect เป็น function
def double(x):
    return x * 2

mock.method.side_effect = double
assert mock.method(5) == 10

# Side effect เป็น exception
mock.method.side_effect = ValueError("error")
try:
    mock.method()
except ValueError as e:
    print(e)
```

**Patch:**

```python
from unittest.mock import patch
import requests


def get_user(user_id: int) -> dict:
    response = requests.get(f"https://api.example.com/users/{user_id}")
    response.raise_for_status()
    return response.json()


# test
@patch("requests.get")
def test_get_user(mock_get):
    # กำหนด return value
    mock_get.return_value.json.return_value = {"id": 1, "name": "test"}
    mock_get.return_value.raise_for_status = Mock()

    result = get_user(1)

    assert result == {"id": 1, "name": "test"}
    mock_get.assert_called_once_with(
        "https://api.example.com/users/1"
    )


# Context manager
def test_get_user_cm():
    with patch("requests.get") as mock_get:
        mock_get.return_value.json.return_value = {"id": 1}
        mock_get.return_value.raise_for_status = Mock()

        result = get_user(1)
        assert result["id"] == 1
```

**patch.object:**

```python
from unittest.mock import patch


class UserService:
    def get_user(self, user_id: int) -> dict:
        return {"id": user_id}


def test_patch_method():
    service = UserService()

    with patch.object(service, "get_user") as mock_get:
        mock_get.return_value = {"id": 999, "mocked": True}

        result = service.get_user(1)
        assert result["mocked"] is True
```

**patch decorator:**

```python
from unittest.mock import patch
import datetime


@patch("datetime.datetime")
def test_datetime(mock_datetime):
    mock_datetime.now.return_value = datetime.datetime(2024, 1, 15)

    now = datetime.datetime.now()
    assert now.year == 2024
    assert now.month == 1
```

**MagicMock:**

```python
from unittest.mock import MagicMock

# MagicMock รองรับ magic methods
mock = MagicMock()

# len()
mock.__len__.return_value = 5
assert len(mock) == 5

# iteration
mock.__iter__.return_value = iter([1, 2, 3])
assert list(mock) == [1, 2, 3]

# context manager
mock.__enter__.return_value = "entered"
with mock as m:
    assert m == "entered"

# str()
mock.__str__.return_value = "mocked"
assert str(mock) == "mocked"
```

**spec:**

```python
from unittest.mock import Mock, create_autospec


class UserService:
    def get_user(self, user_id: int) -> dict:
        return {}

    def create_user(self, name: str) -> dict:
        return {}


# spec — จำกัด attributes
mock = Mock(spec=UserService)
mock.get_user.return_value = {"id": 1}

# mock.get_invalid()  # ❌ AttributeError

# create_autospec — จำกัด signature ด้วย
mock = create_autospec(UserService)
mock.get_user(1)  # ✅
# mock.get_user("string")  # ❌ TypeError
```

**ตัวอย่างการใช้งานจริง — Service Test:**

```python
# src/user_service.py
from dataclasses import dataclass
from typing import Protocol


class UserRepository(Protocol):
    def find_by_id(self, user_id: int) -> dict | None: ...
    def save(self, user: dict) -> dict: ...


class EmailService(Protocol):
    def send(self, to: str, subject: str, body: str) -> None: ...


class UserService:
    def __init__(
        self,
        repository: UserRepository,
        email_service: EmailService,
    ):
        self.repository = repository
        self.email_service = email_service

    def register(self, name: str, email: str) -> dict:
        user = {"name": name, "email": email, "active": True}
        saved = self.repository.save(user)
        self.email_service.send(
            email,
            "Welcome",
            f"Hello {name}",
        )
        return saved

    def get(self, user_id: int) -> dict | None:
        return self.repository.find_by_id(user_id)


# tests/test_user_service.py
from unittest.mock import Mock, create_autospec
import pytest
from src.user_service import UserService, UserRepository, EmailService


@pytest.fixture
def mock_repository():
    return create_autospec(UserRepository)


@pytest.fixture
def mock_email():
    return create_autospec(EmailService)


@pytest.fixture
def service(mock_repository, mock_email):
    return UserService(mock_repository, mock_email)


class TestRegister:
    def test_saves_user(self, service, mock_repository):
        mock_repository.save.return_value = {
            "id": 1,
            "name": "test",
            "email": "test@example.com",
        }

        result = service.register("test", "test@example.com")

        assert result["id"] == 1
        mock_repository.save.assert_called_once_with({
            "name": "test",
            "email": "test@example.com",
            "active": True,
        })

    def test_sends_welcome_email(self, service, mock_repository, mock_email):
        mock_repository.save.return_value = {"id": 1}

        service.register("test", "test@example.com")

        mock_email.send.assert_called_once_with(
            "test@example.com",
            "Welcome",
            "Hello test",
        )

    def test_no_email_on_error(self, service, mock_repository, mock_email):
        mock_repository.save.side_effect = ValueError("DB error")

        with pytest.raises(ValueError):
            service.register("test", "test@example.com")

        mock_email.send.assert_not_called()


class TestGet:
    def test_returns_user(self, service, mock_repository):
        mock_repository.find_by_id.return_value = {
            "id": 1,
            "name": "test",
        }

        result = service.get(1)

        assert result["id"] == 1
        mock_repository.find_by_id.assert_called_once_with(1)

    def test_returns_none(self, service, mock_repository):
        mock_repository.find_by_id.return_value = None

        assert service.get(999) is None
```

**ตัวอย่าง — HTTP Mock:**

```python
# src/api_client.py
import httpx
from typing import Any


class APIClient:
    def __init__(self, base_url: str):
        self.base_url = base_url.rstrip("/")

    def get(self, path: str) -> dict[str, Any]:
        response = httpx.get(f"{self.base_url}{path}")
        response.raise_for_status()
        return response.json()

    def post(self, path: str, data: dict) -> dict[str, Any]:
        response = httpx.post(f"{self.base_url}{path}", json=data)
        response.raise_for_status()
        return response.json()


# tests/test_api_client.py
from unittest.mock import patch, Mock
import httpx
import pytest
from src.api_client import APIClient


@pytest.fixture
def client():
    return APIClient("https://api.example.com")


@patch("httpx.get")
def test_get_success(mock_get, client):
    mock_response = Mock()
    mock_response.json.return_value = {"id": 1, "name": "test"}
    mock_response.raise_for_status = Mock()
    mock_get.return_value = mock_response

    result = client.get("/users/1")

    assert result == {"id": 1, "name": "test"}
    mock_get.assert_called_once_with(
        "https://api.example.com/users/1"
    )


@patch("httpx.get")
def test_get_error(mock_get, client):
    mock_response = Mock()
    mock_response.raise_for_status.side_effect = httpx.HTTPStatusError(
        "404",
        request=Mock(),
        response=Mock(),
    )
    mock_get.return_value = mock_response

    with pytest.raises(httpx.HTTPStatusError):
        client.get("/not-found")
```

### 9.6.4 ข้อดี

- **Isolation:** แยก dependencies
- **Speed:** เร็ว
- **Control:** กำหนด behavior
- **Deterministic:** ผลคงที่
- **Verify:** ตรวจสอบการเรียก

### 9.6.5 ข้อเสีย

- **Over-mocking:** test ไม่จริง
- **Coupling:** ผูก implementation
- **Complexity:** ซับซ้อน
- **False confidence:** อาจไม่ตรงจริง

### 9.6.6 ข้อควรระวัง

```python
# ระวัง 1: Mock ทุกอย่าง
# ❌
def test_add(mock_add):
    mock_add.return_value = 5
    assert add(2, 3) == 5  # test mock ตัวเอง

# ✅ test ของจริง
def test_add():
    assert add(2, 3) == 5

# ระวัง 2: patch path ผิด
# ❌ patch ที่ definition
@patch("requests.get")  # ✅ patch ที่ usage

# ❌
@patch("mymodule.requests.get")  # ถ้า import ต่าง

# ระวัง 3: ไม่ cleanup
# ✅ ใช้ context manager หรือ decorator
# (จัดการอัตโนมัติ)

# ระวัง 4: assert กับ mock มากเกินไป
# ❌
mock.method.assert_called_once_with(
    arg1, arg2, key="value", another="thing"
)  # fragile

# ✅
mock.method.assert_called_once()
call_args = mock.method.call_args
assert call_args[0][0] == arg1

# ระวัง 5: mock return value ที่ไม่ตรง type
# ❌
mock.get_user.return_value = "string"  # ควรเป็น dict

# ✅
mock.get_user.return_value = {"id": 1, "name": "test"}

# ระวัง 6: ลืม side_effect สำหรับ exception
# ✅
mock.method.side_effect = ValueError("error")

# ระวัง 7: Mock recursion
# ❌ อาจ infinite
mock.return_value = mock  # ⚠️
```

### 9.6.7 สรุป

**Tools:**

| Tool | ใช้ |
|------|-----|
| `Mock` | Object ปลอม |
| `MagicMock` | + magic methods |
| `patch` | แทนชั่วคราว |
| `create_autospec` | + spec |
| `PropertyMock` | properties |

**Methods:**
- `return_value` — กำหนดค่า return
- `side_effect` — exception/function
- `assert_called_with` — ตรวจสอบ
- `assert_called_once` — เรียกครั้งเดียว
- `assert_not_called` — ไม่ถูกเรียก

**Best practices:**
- Mock เฉพาะ boundary
- `spec` สำหรับ type safety
- อย่า over-mock
- ตรวจสอบ behavior ไม่ใช่ implementation
- ใช้ `create_autospec`

> **อ้างอิงเพิ่มเติม:** [unittest.mock](https://docs.python.org/3/library/unittest.mock.html)

---

## 9.7 unittest.mock

### บทนำ

`unittest.mock` เป็น module มาตรฐานสำหรับ mocking และ patching ใช้แทน objects ใน tests

### นิยาม

`unittest.mock` ให้ classes และ functions สำหรับสร้าง test doubles

### 9.7.1 คืออะไร

**Components:**
- `Mock` — general purpose
- `MagicMock` — magic methods
- `NonCallableMock` — ไม่ callable
- `patch` — decorator/context manager
- `PropertyMock` — properties
- `AsyncMock` — async

### 9.7.2 ทำงานอย่างไร

Mock บันทึกทุกการเรียก มี attributes:
- `call_count`
- `call_args`
- `call_args_list`
- `mock_calls`
- `method_calls`

### 9.7.3 การใช้งาน

**Mock attributes:**

```python
from unittest.mock import Mock

mock = Mock()

# เรียก
mock(1, 2, key="value")
mock.method("arg")

# ตรวจสอบ
print(mock.call_count)          # 1
print(mock.call_args)           # call(1, 2, key='value')
print(mock.method.call_count)   # 1
print(mock.method.call_args)    # call('arg')

# call_args_list
mock(3)
mock(4)
print(mock.call_args_list)
# [call(1, 2, key='value'), call(3), call(4)]

# method_calls
print(mock.method_calls)
# [call.method('arg')]

# reset
mock.reset_mock()
print(mock.call_count)  # 0
```

**Assertion methods:**

```python
from unittest.mock import Mock, call

mock = Mock()
mock(1, 2)
mock(3, 4)
mock.method("a")

# ถูกเรียก
mock.assert_called()
mock.method.assert_called()

# ครั้งเดียว
# mock.assert_called_once()  # ❌ (2 ครั้ง)

# with args
mock.assert_called_with(3, 4)  # ครั้งล่าสุด
mock.assert_any_call(1, 2)     # ครั้งใดก็ได้

# จำนวนครั้ง
mock.assert_called_once_with(3, 4)  # ❌ ไม่จริง

# ไม่ถูกเรียก
mock.other.assert_not_called()

# call list
expected = [call(1, 2), call(3, 4)]
mock.assert_has_calls(expected)

# any_order
mock.assert_has_calls([call(3, 4), call(1, 2)], any_order=True)
```

**side_effect:**

```python
from unittest.mock import Mock

# Exception
mock = Mock(side_effect=ValueError("error"))
try:
    mock()
except ValueError as e:
    print(e)

# Sequence
mock = Mock(side_effect=[1, 2, 3])
print(mock())  # 1
print(mock())  # 2

# Function
def process(x):
    if x < 0:
        raise ValueError("negative")
    return x * 2

mock = Mock(side_effect=process)
print(mock(5))  # 10

try:
    mock(-1)
except ValueError:
    print("caught")

# Generator (self-returning)
def self_return(*args, **kwargs):
    return mock

mock = Mock(side_effect=self_return)
mock().method()  # chainable
```

**wraps:**

```python
from unittest.mock import Mock


def real_function(x: int) -> int:
    return x * 2


mock = Mock(wraps=real_function)
print(mock(5))  # 10 (เรียก real)

# ยัง track
print(mock.call_count)  # 1
mock.assert_called_once_with(5)
```

**patch:**

```python
from unittest.mock import patch
import os


# Decorator
@patch("os.getcwd")
def test_cwd(mock_getcwd):
    mock_getcwd.return_value = "/mocked"
    assert os.getcwd() == "/mocked"


# Context manager
def test_cwd_cm():
    with patch("os.getcwd") as mock_getcwd:
        mock_getcwd.return_value = "/mocked"
        assert os.getcwd() == "/mocked"


# Multiple patches
@patch("os.getcwd")
@patch("os.environ")
def test_multiple(mock_env, mock_getcwd):
    # ลำดับกลับกัน (bottom-up)
    mock_getcwd.return_value = "/mocked"
    mock_env.get.return_value = "value"

    assert os.getcwd() == "/mocked"
    assert os.environ.get("KEY") == "value"


# patch.object
class MyClass:
    def method(self) -> str:
        return "real"


def test_patch_object():
    obj = MyClass()
    with patch.object(obj, "method", return_value="mocked"):
        assert obj.method() == "mocked"


# patch.dict
def test_patch_dict():
    with patch.dict("os.environ", {"TEST": "1"}):
        assert os.environ["TEST"] == "1"
```

**PropertyMock:**

```python
from unittest.mock import patch, PropertyMock


class User:
    @property
    def name(self) -> str:
        return "real"


def test_property():
    with patch.object(
        User,
        "name",
        new_callable=PropertyMock,
    ) as mock_name:
        mock_name.return_value = "mocked"
        assert User().name == "mocked"
```

**AsyncMock:**

```python
from unittest.mock import AsyncMock
import asyncio
import pytest


async def fetch_data() -> dict:
    return {"id": 1}


@pytest.mark.asyncio
async def test_async():
    mock = AsyncMock(return_value={"id": 999})

    result = await mock()
    assert result["id"] == 999
    mock.assert_awaited_once()


# patch async
class Service:
    async def get(self, id: int) -> dict:
        return {"id": id}


@pytest.mark.asyncio
async def test_patch_async():
    service = Service()

    with patch.object(service, "get", new_callable=AsyncMock) as mock_get:
        mock_get.return_value = {"id": 999}
        result = await service.get(1)
        assert result["id"] == 999
```

**ตัวอย่างการใช้งานจริง — Repository Test:**

```python
# src/repository.py
from typing import Protocol


class Repository(Protocol):
    def find(self, id: int) -> dict | None: ...
    def save(self, data: dict) -> dict: ...
    def delete(self, id: int) -> bool: ...


class UserService:
    def __init__(self, repo: Repository):
        self.repo = repo

    def get_or_create(self, user_id: int, name: str) -> dict:
        user = self.repo.find(user_id)
        if user is None:
            user = self.repo.save({"id": user_id, "name": name})
        return user

    def delete_all(self, ids: list[int]) -> int:
        deleted = 0
        for id_ in ids:
            if self.repo.delete(id_):
                deleted += 1
        return deleted


# tests/test_user_service.py
from unittest.mock import Mock, create_autospec, call
import pytest
from src.repository import Repository, UserService


@pytest.fixture
def mock_repo():
    return create_autospec(Repository)


@pytest.fixture
def service(mock_repo):
    return UserService(mock_repo)


class TestGetOrCreate:
    def test_existing_user(self, service, mock_repo):
        mock_repo.find.return_value = {"id": 1, "name": "existing"}

        result = service.get_or_create(1, "new")

        assert result["name"] == "existing"
        mock_repo.save.assert_not_called()

    def test_new_user(self, service, mock_repo):
        mock_repo.find.return_value = None
        mock_repo.save.return_value = {"id": 1, "name": "new"}

        result = service.get_or_create(1, "new")

        assert result["name"] == "new"
        mock_repo.save.assert_called_once_with({"id": 1, "name": "new"})


class TestDeleteAll:
    def test_all_deleted(self, service, mock_repo):
        mock_repo.delete.return_value = True

        count = service.delete_all([1, 2, 3])

        assert count == 3
        mock_repo.delete.assert_has_calls([
            call(1), call(2), call(3),
        ])

    def test_partial(self, service, mock_repo):
        mock_repo.delete.side_effect = [True, False, True]

        count = service.delete_all([1, 2, 3])

        assert count == 2
```

### 9.7.4 ข้อดี

- **Built-in:** standard library
- **Powerful:** ครบ
- **Flexible:** หลาย modes
- **Track:** บันทึกทุกอย่าง

### 9.7.5 ข้อเสีย

- **Complex:** API เยอะ
- **Magic:** อาจสับสน
- **Over-mock:** risk

### 9.7.6 ข้อควรระวัง

```python
# ระวัง 1: patch path
# ❌ patch ที่ definition
# mymodule.py: from requests import get
@patch("requests.get")  # ❌ ไม่มีผล

# ✅ patch ที่ import
@patch("mymodule.get")

# ระวัง 2: Mock ไม่ callable
from unittest.mock import NonCallableMock
mock = NonCallableMock()
# mock()  # ❌ TypeError

# ระวัง 3: spec
# ❌
mock = Mock()
mock.nonexistent_method()  # ✅ (ไม่ error)

# ✅
mock = Mock(spec=MyClass)
# mock.nonexistent_method()  # ❌ AttributeError

# ระวัง 4: Return value chain
# ❌
mock.get.return_value.json.return_value = {...}  # verbose

# ✅
mock.get.return_value = Mock(json=Mock(return_value={...}))

# ระวัง 5: reset หลัง test
# ✅ ใช้ fixture
@pytest.fixture
def mock():
    m = Mock()
    yield m
    m.reset_mock()

# ระวัง 6: assert_called_with vs assert_called_once_with
# assert_called_with — ครั้งล่าสุด
# assert_called_once_with — ทั้งหมดครั้งเดียว

# ระวัง 7: Mock ไม่ thread-safe
```

### 9.7.7 สรุป

**Classes:**

| Class | ใช้ |
|-------|-----|
| `Mock` | ทั่วไป |
| `MagicMock` | + magic |
| `AsyncMock` | async |
| `PropertyMock` | property |
| `NonCallableMock` | ไม่ callable |

**patch:**

| วิธี | ใช้ |
|------|-----|
| `@patch` | decorator |
| `with patch` | context |
| `patch.object` | attribute |
| `patch.dict` | dict |

**Best practices:**
- `spec` / `create_autospec`
- patch ที่ usage
- reset หลัง test
- อย่า over-mock
- ตรวจสอบ behavior

> **อ้างอิงเพิ่มเติม:** [unittest.mock](https://docs.python.org/3/library/unittest.mock.html)

---

## 9.8 pytest-mock

### บทนำ

`pytest-mock` เป็น plugin ที่ให้ `mocker` fixture สำหรับ mocking ใน pytest style สะอาดกว่า `unittest.mock`

### นิยาม

`pytest-mock` เป็น pytest plugin ที่ wrap `unittest.mock`

### 9.8.1 คืออะไร

**ข้อดี:**
- `mocker` fixture
- Auto cleanup
- Syntax สะอาด
- pytest integration

### 9.8.2 ทำงานอย่างไร

`mocker` fixture ให้ access ถึง mocking API และ cleanup อัตโนมัติ

### 9.8.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install pytest-mock
```

**พื้นฐาน:**

```python
def test_mock(mocker):
    # สร้าง mock
    mock = mocker.Mock()
    mock.return_value = 42

    assert mock() == 42

    # ตรวจสอบ
    mock.assert_called_once()


def test_patch(mocker):
    mock_get = mocker.patch("requests.get")
    mock_get.return_value.json.return_value = {"id": 1}

    import requests
    result = requests.get("https://api.example.com").json()

    assert result["id"] == 1


def test_patch_object(mocker):
    import os

    mock_getcwd = mocker.patch.object(os, "getcwd")
    mock_getcwd.return_value = "/mocked"

    assert os.getcwd() == "/mocked"


def test_spy(mocker):
    """mocker.spy — wrap object จริง"""
    class Calculator:
        def add(self, a, b):
            return a + b

    calc = Calculator()
    spy = mocker.spy(calc, "add")

    result = calc.add(2, 3)

    assert result == 5  # ยังทำงานจริง
    spy.assert_called_once_with(2, 3)


def test_stub(mocker):
    """mocker.stub — สร้าง stub function"""
    callback = mocker.stub(name="callback")
    callback("arg")

    callback.assert_called_once_with("arg")
```

**patch methods:**

```python
def test_patch_dict(mocker):
    mocker.patch.dict("os.environ", {"DEBUG": "true"})
    import os
    assert os.environ["DEBUG"] == "true"


def test_patch_multiple(mocker):
    mock_a = mocker.patch("module.a")
    mock_b = mocker.patch("module.b")

    mock_a.return_value = 1
    mock_b.return_value = 2


def test_patch_context(mocker):
    with mocker.patch("os.getcwd") as mock:
        mock.return_value = "/mocked"
        import os
        assert os.getcwd() == "/mocked"
```

**PropertyMock:**

```python
def test_property(mocker):
    mock_prop = mocker.patch.object(
        MyClass,
        "value",
        new_callable=mocker.PropertyMock,
        return_value=42,
    )

    assert MyClass().value == 42
```

**Auto cleanup:**

```python
def test_first(mocker):
    mock = mocker.patch("module.func")
    mock.return_value = "first"


def test_second(mocker):
    # mock ใหม่ — ไม่มี state จาก test_first
    mock = mocker.patch("module.func")
    # mock.return_value ยังเป็น default
    assert mock.called is False
```

**ตัวอย่างการใช้งานจริง — Service Test:**

```python
# src/order_service.py
from dataclasses import dataclass
from typing import Protocol


class PaymentGateway(Protocol):
    def charge(self, amount: float) -> bool: ...


class OrderRepository(Protocol):
    def save(self, order: dict) -> dict: ...


class NotificationService(Protocol):
    def send(self, user_id: str, message: str) -> None: ...


@dataclass
class OrderService:
    payment: PaymentGateway
    repository: OrderRepository
    notification: NotificationService

    def create_order(
        self,
        user_id: str,
        amount: float,
    ) -> dict:
        if not self.payment.charge(amount):
            raise RuntimeError("Payment failed")

        order = {
            "user_id": user_id,
            "amount": amount,
            "status": "paid",
        }
        saved = self.repository.save(order)

        self.notification.send(
            user_id,
            f"Order confirmed: ${amount}",
        )

        return saved


# tests/test_order_service.py
import pytest
from src.order_service import OrderService


@pytest.fixture
def mock_payment(mocker):
    return mocker.Mock()


@pytest.fixture
def mock_repo(mocker):
    return mocker.Mock()


@pytest.fixture
def mock_notification(mocker):
    return mocker.Mock()


@pytest.fixture
def service(mock_payment, mock_repo, mock_notification):
    return OrderService(
        payment=mock_payment,
        repository=mock_repo,
        notification=mock_notification,
    )


class TestCreateOrder:
    def test_success(
        self,
        service,
        mock_payment,
        mock_repo,
        mock_notification,
    ):
        mock_payment.charge.return_value = True
        mock_repo.save.return_value = {"id": "ORD-001", "amount": 100}

        result = service.create_order("U001", 100)

        assert result["id"] == "ORD-001"

        mock_payment.charge.assert_called_once_with(100)
        mock_repo.save.assert_called_once()
        mock_notification.send.assert_called_once_with(
            "U001",
            "Order confirmed: $100",
        )

    def test_payment_fails(
        self,
        service,
        mock_payment,
        mock_repo,
        mock_notification,
    ):
        mock_payment.charge.return_value = False

        with pytest.raises(RuntimeError, match="Payment failed"):
            service.create_order("U001", 100)

        mock_repo.save.assert_not_called()
        mock_notification.send.assert_not_called()


class TestSpy:
    def test_spy_on_real_object(self, mocker):
        class Logger:
            def log(self, message: str) -> str:
                return f"LOG: {message}"

        logger = Logger()
        spy = mocker.spy(logger, "log")

        result = logger.log("test")

        assert result == "LOG: test"  # ทำงานจริง
        spy.assert_called_once_with("test")
```

**ตัวอย่าง — Time Mock:**

```python
# src/token.py
from datetime import datetime, timedelta
import secrets


def create_token(expires_in_seconds: int = 3600) -> dict:
    return {
        "token": secrets.token_urlsafe(32),
        "created_at": datetime.now(),
        "expires_at": datetime.now() + timedelta(seconds=expires_in_seconds),
    }


# tests/test_token.py
from datetime import datetime, timedelta


def test_create_token(mocker):
    # Mock datetime
    mock_datetime = mocker.patch("src.token.datetime")
    fixed_time = datetime(2024, 1, 15, 12, 0, 0)
    mock_datetime.now.return_value = fixed_time

    from src.token import create_token
    result = create_token(expires_in_seconds=3600)

    assert result["created_at"] == fixed_time
    assert result["expires_at"] == fixed_time + timedelta(hours=1)
    assert len(result["token"]) > 0
```

### 9.8.4 ข้อดี

- **Clean:** syntax สะอาด
- **Auto cleanup:** ไม่ต้อง reset
- **Fixture:** ใช้ `mocker`
- **pytest-native:** integrate

### 9.8.5 ข้อเสีย

- **Third-party:** ต้องติดตั้ง
- **Extra:** เพิ่ม dependency

### 9.8.6 ข้อควรระวัง

```python
# ระวัง 1: mocker scope
# mocker เป็น function scope
def test_a(mocker):
    mock = mocker.patch("module.func")
    # ...

def test_b(mocker):
    # mock ใหม่
    # ...

# ระวัง 2: spy vs mock
# spy — เรียกจริง + track
# mock — ไม่เรียกจริง

def test_spy(mocker):
    obj = SomeClass()
    spy = mocker.spy(obj, "method")
    obj.method()  # ✅ เรียกจริง
    spy.assert_called_once()

# ระวัง 3: patch path
# เหมือน unittest.mock

# ระวัง 4: reset
# mocker cleanup อัตโนมัติ
# ไม่ต้อง reset_mock()

# ระวัง 5: mocker.patch กับ class methods
class MyClass:
    @staticmethod
    def static_method():
        return "real"

    @classmethod
    def class_method(cls):
        return "real"

def test_static(mocker):
    mocker.patch.object(MyClass, "static_method", return_value="mocked")
    assert MyClass.static_method() == "mocked"
```

### 9.8.7 สรุป

**API:**

| Method | ใช้ |
|--------|-----|
| `mocker.Mock()` | สร้าง mock |
| `mocker.patch()` | patch |
| `mocker.patch.object()` | patch attribute |
| `mocker.patch.dict()` | patch dict |
| `mocker.spy()` | spy |
| `mocker.stub()` | stub |

**Best practices:**
- ใช้ `mocker` fixture
- Auto cleanup
- `spy` สำหรับ real objects
- เหมือน `unittest.mock` แต่สะอาด

> **อ้างอิงเพิ่มเติม:** [pytest-mock Documentation](https://pytest-mock.readthedocs.io/)

---

## 9.9 Parameterized Test

### บทนำ

Parameterized Test คือการรัน test เดียวกับหลาย inputs ลด duplication และเพิ่ม coverage

### นิยาม

Parameterized Test คือ test ที่รับ parameters และรันซ้ำสำหรับแต่ละชุด

### 9.9.1 คืออะไร

**ประโยชน์:**
- ลด duplication
- Coverage มากขึ้น
- ชื่อ test บอก case
- เพิ่ม case ง่าย

### 9.9.2 ทำงานอย่างไร

pytest `@pytest.mark.parametrize` สร้าง test หลายตัวจาก function เดียว

### 9.9.3 การใช้งาน

**พื้นฐาน:**

```python
import pytest


@pytest.mark.parametrize(
    "a,b,expected",
    [
        (1, 2, 3),
        (0, 0, 0),
        (-1, 1, 0),
        (100, 200, 300),
        (1.5, 2.5, 4.0),
    ],
)
def test_add(a, b, expected):
    assert a + b == expected
```

**หลาย parameters:**

```python
import pytest


@pytest.mark.parametrize("x", [1, 2, 3])
@pytest.mark.parametrize("y", [10, 20])
def test_multiply(x, y):
    # 6 combinations: (1,10), (1,20), (2,10), ...
    assert x * y == y * x
```

**Parameter IDs:**

```python
import pytest


@pytest.mark.parametrize(
    "value,expected",
    [
        pytest.param("1", 1, id="single-digit"),
        pytest.param("42", 42, id="two-digits"),
        pytest.param("-10", -10, id="negative"),
        pytest.param("0", 0, id="zero"),
    ],
)
def test_parse_int(value, expected):
    assert int(value) == expected
```

**กับ Exception:**

```python
import pytest


@pytest.mark.parametrize(
    "value,exception",
    [
        ("abc", ValueError),
        ("", ValueError),
        (None, TypeError),
        ("1.5", ValueError),
    ],
)
def test_invalid_int(value, exception):
    with pytest.raises(exception):
        int(value)
```

**กับ Fixtures:**

```python
import pytest


@pytest.fixture(params=["sqlite", "postgres", "mysql"])
def database(request):
    """Fixture ที่รันหลายครั้ง"""
    db = create_connection(request.param)
    yield db
    db.close()


def test_query(database):
    # รัน 3 ครั้ง — sqlite, postgres, mysql
    result = database.execute("SELECT 1")
    assert result == 1
```

**Indirect Parametrization:**

```python
import pytest


@pytest.fixture
def user(request):
    return request.param


@pytest.mark.parametrize(
    "user",
    ["admin", "user", "guest"],
    indirect=True,
)
def test_permissions(user):
    # user fixture รับค่า
    if user == "admin":
        assert can_delete(user)
    else:
        assert not can_delete(user)
```

**Stacking:**

```python
import pytest


@pytest.mark.parametrize("operation", ["add", "subtract"])
@pytest.mark.parametrize("a", [1, 10])
@pytest.mark.parametrize("b", [2, 20])
def test_operations(operation, a, b):
    # 2 × 2 × 2 = 8 combinations
    if operation == "add":
        assert a + b == b + a
    else:
        assert a - b == -(b - a)
```

**ตัวอย่างการใช้งานจริง — Validation Test:**

```python
# src/validators.py
import re


class ValidationError(Exception):
    pass


def validate_username(value: str) -> str:
    if not value:
        raise ValidationError("ต้องไม่ว่าง")
    if len(value) < 3:
        raise ValidationError("ต้องมีอย่างน้อย 3 ตัวอักษร")
    if len(value) > 20:
        raise ValidationError("ต้องไม่เกิน 20 ตัวอักษร")
    if not re.match(r"^[a-zA-Z0-9_]+$", value):
        raise ValidationError("เฉพาะ a-z, A-Z, 0-9, _")
    return value


def validate_age(value: int) -> int:
    if not isinstance(value, int):
        raise ValidationError("ต้องเป็นจำนวนเต็ม")
    if not 0 <= value <= 150:
        raise ValidationError("ต้องอยู่ 0-150")
    return value


def validate_email(value: str) -> str:
    if not re.match(r"^[\w.+-]+@[\w-]+\.[\w.]+$", value):
        raise ValidationError("รูปแบบไม่ถูกต้อง")
    return value.lower()


# tests/test_validators.py
import pytest
from src.validators import (
    ValidationError,
    validate_username,
    validate_age,
    validate_email,
)


class TestValidateUsername:
    @pytest.mark.parametrize(
        "value",
        [
            "abc",
            "user_1",
            "TestUser",
            "a" * 20,
            "UPPERCASE",
            "with_underscore",
        ],
    )
    def test_valid(self, value):
        assert validate_username(value) == value

    @pytest.mark.parametrize(
        "value,error_match",
        [
            ("", "ไม่ว่าง"),
            ("ab", "อย่างน้อย 3"),
            ("a" * 21, "ไม่เกิน 20"),
            ("user-name", "เฉพาะ"),
            ("user@name", "เฉพาะ"),
            ("user name", "เฉพาะ"),
        ],
    )
    def test_invalid(self, value, error_match):
        with pytest.raises(ValidationError, match=error_match):
            validate_username(value)


class TestValidateAge:
    @pytest.mark.parametrize(
        "value",
        [0, 1, 25, 50, 100, 150],
    )
    def test_valid(self, value):
        assert validate_age(value) == value

    @pytest.mark.parametrize(
        "value",
        [-1, -100, 151, 200, 1000],
    )
    def test_out_of_range(self, value):
        with pytest.raises(ValidationError, match="0-150"):
            validate_age(value)

    @pytest.mark.parametrize(
        "value",
        ["25", 25.5, None, [], {}],
    )
    def test_wrong_type(self, value):
        with pytest.raises(ValidationError, match="จำนวนเต็ม"):
            validate_age(value)


class TestValidateEmail:
    @pytest.mark.parametrize(
        "value,expected",
        [
            ("user@example.com", "user@example.com"),
            ("USER@EXAMPLE.COM", "user@example.com"),
            ("user.name@example.com", "user.name@example.com"),
            ("user+tag@example.co.th", "user+tag@example.co.th"),
        ],
    )
    def test_valid(self, value, expected):
        assert validate_email(value) == expected

    @pytest.mark.parametrize(
        "value",
        [
            "",
            "invalid",
            "@example.com",
            "user@",
            "user@.com",
            "user name@example.com",
        ],
    )
    def test_invalid(self, value):
        with pytest.raises(ValidationError):
            validate_email(value)
```

**ตัวอย่าง — API Test:**

```python
# tests/test_api.py
import pytest
from decimal import Decimal


@pytest.mark.parametrize(
    "amount,expected_tax",
    [
        (Decimal("100"), Decimal("7")),
        (Decimal("200"), Decimal("14")),
        (Decimal("1000"), Decimal("70")),
        (Decimal("0"), Decimal("0")),
        (Decimal("99.99"), Decimal("7.00")),
    ],
)
def test_calculate_tax(amount, expected_tax):
    from src.tax import calculate_tax
    result = calculate_tax(amount)
    assert result.quantize(Decimal("0.01")) == expected_tax


@pytest.mark.parametrize(
    "status_code,should_retry",
    [
        (200, False),
        (201, False),
        (400, False),
        (401, False),
        (404, False),
        (429, True),
        (500, True),
        (502, True),
        (503, True),
    ],
)
def test_should_retry(status_code, should_retry):
    from src.http import should_retry
    assert should_retry(status_code) == should_retry
```

### 9.9.4 ข้อดี

- **DRY:** ไม่ต้องเขียนซ้ำ
- **Coverage:** cases เยอะ
- **Readable:** ชื่อบอก case
- **Maintainable:** เพิ่ม case ง่าย

### 9.9.5 ข้อเสีย

- **Output:** อาจยาว
- **Debug:** ยากกว่า test เดียว
- **Setup:** ต้องเตรียม data

### 9.9.6 ข้อควรระวัง

```python
# ระวัง 1: Parameters เยอะเกินไป
# ❌
@pytest.mark.parametrize("a,b,c,d,e,f,g,h,i,j", [...])  # 10 params

# ✅ แยก
@pytest.mark.parametrize("input,expected", [...])

# ระวัง 2: Cases ซ้ำ
# ❌
@pytest.mark.parametrize("x", [1, 2, 3, 1, 2, 3])  # ซ้ำ

# ระวัง 3: ไม่มี id
# ❌ อ่านยาก
@pytest.mark.parametrize("value", ["abc123", "def456", ...])
def test_x(value): ...

# ✅
@pytest.mark.parametrize(
    "value",
    [
        pytest.param("abc123", id="alphanumeric"),
        pytest.param("def456", id="another"),
    ],
)
def test_x(value): ...

# ระวัง 4: Stacking มากเกินไป
# ❌ combinations เยอะเกิน
@pytest.mark.parametrize("a", range(10))
@pytest.mark.parametrize("b", range(10))
@pytest.mark.parametrize("c", range(10))
# 1000 tests!

# ระวัง 5: Mutable params
# ⚠️ ถ้า param เป็น mutable และ test แก้
@pytest.mark.parametrize("items", [[1, 2], [3, 4]])
def test_x(items):
    items.append(5)  # ⚠️ กระทบ test ถัดไป (ถ้า scope ใหญ่)

# ✅ ใช้ copy
def test_x(items):
    items = items.copy()
    items.append(5)
```

### 9.9.7 สรุป

**ใช้เมื่อ:**
- Test เดียวกัน หลาย inputs
- Validation
- Edge cases
- Combinations

**Best practices:**
- `pytest.param` สำหรับ id
- แยก tests ถ้า logic ต่าง
- หลีกเลี่ยง mutable params
- ใช้ `indirect` สำหรับ fixtures
- อย่า stack มากเกินไป

> **อ้างอิงเพิ่มเติม:** [pytest Parametrize](https://docs.pytest.org/en/stable/parametrize.html)

---

## 9.10 Coverage

### บทนำ

Code Coverage คือตัวชี้วัดว่ามีโค้ดกี่เปอร์เซ็นต์ที่ถูกทดสอบ ช่วยหา dead code และ uncovered paths

### นิยาม

Coverage คือเปอร์เซ็นต์ของโค้ดที่ถูก execute ระหว่าง tests

### 9.10.1 คืออะไร

**Types:**
- **Line coverage:** บรรทัดที่รัน
- **Branch coverage:** branches ที่รัน
- **Function coverage:** functions ที่เรียก
- **Statement coverage:** statements

### 9.10.2 ทำงานอย่างไร

Coverage tools:
1. Instrument code
2. รัน tests
3. บันทึกบรรทัดที่รัน
4. รายงาน

### 9.10.3 การใช้งาน

**coverage.py:**

```bash
pip install coverage
```

```bash
# รัน tests พร้อม coverage
coverage run -m pytest

# รายงาน
coverage report

# HTML
coverage html

# XML (สำหรับ CI)
coverage xml
```

**Output:**

```
Name                    Stmts   Miss  Cover
-------------------------------------------
src/calculator.py          10      2    80%
src/user.py                20      0   100%
-------------------------------------------
TOTAL                      30      2    93%
```

**pytest-cov:**

```bash
pip install pytest-cov
```

```bash
# รัน pytest พร้อม coverage
pytest --cov=src

# รายงานละเอียด
pytest --cov=src --cov-report=term-missing

# HTML
pytest --cov=src --cov-report=html

# หลาย formats
pytest --cov=src --cov-report=html --cov-report=xml

# Fail ถ้า coverage ต่ำ
pytest --cov=src --cov-fail-under=80
```

**Configuration:**

```toml
# pyproject.toml
[tool.coverage.run]
source = ["src"]
branch = true
omit = [
    "*/tests/*",
    "*/__init__.py",
    "*/migrations/*",
]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
    "@abstractmethod",
]
show_missing = true
skip_covered = false
fail_under = 80
```

**.coveragerc:**

```ini
[run]
source = src
branch = True
omit =
    */tests/*
    */__init__.py

[report]
exclude_lines =
    pragma: no cover
    def __repr__
    if TYPE_CHECKING:
    raise NotImplementedError
    @abstractmethod
show_missing = True
fail_under = 80
```

**Exclude lines:**

```python
def my_function(x: int) -> int:
    if x < 0:
        raise ValueError("negative")  # pragma: no cover
    return x * 2


def debug_only() -> None:  # pragma: no cover
    """ฟังก์ชันสำหรับ debug"""
    ...


if TYPE_CHECKING:  # pragma: no cover
    from typing import Any


class Base:
    @abstractmethod
    def method(self) -> None:  # pragma: no cover
        ...
```

**Branch Coverage:**

```python
def check_value(x: int) -> str:
    if x > 0:  # branch
        return "positive"
    elif x < 0:  # branch
        return "negative"
    else:  # branch
        return "zero"


# Line coverage: อาจ 100% แม้ไม่ test ทุก branch
# Branch coverage: ต้อง test ทุก path
```

**ตัวอย่างการใช้งานจริง — Coverage Report:**

```python
# src/calculator.py
from typing import Union

Number = Union[int, float]


class Calculator:
    def add(self, a: Number, b: Number) -> Number:
        return a + b

    def subtract(self, a: Number, b: Number) -> Number:
        return a - b

    def multiply(self, a: Number, b: Number) -> Number:
        return a * b

    def divide(self, a: Number, b: Number) -> float:
        if b == 0:
            raise ZeroDivisionError("division by zero")
        return a / b

    def power(self, base: Number, exp: Number) -> Number:
        return base ** exp


# tests/test_calculator.py
import pytest
from src.calculator import Calculator


@pytest.fixture
def calc():
    return Calculator()


def test_add(calc):
    assert calc.add(2, 3) == 5


def test_subtract(calc):
    assert calc.subtract(5, 3) == 2


def test_multiply(calc):
    assert calc.multiply(2, 3) == 6


def test_divide(calc):
    assert calc.divide(10, 2) == 5


# ❌ ไม่ test divide by zero
# ❌ ไม่ test power


# Coverage:
# Name                    Stmts   Miss  Cover
# -------------------------------------------
# src/calculator.py          14      3    79%
# -------------------------------------------
# Missing: divide (b==0), power
```

**CI Integration:**

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Install dependencies
        run: |
          pip install -e ".[dev]"

      - name: Run tests with coverage
        run: |
          pytest --cov=src --cov-report=xml --cov-fail-under=80

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          files: ./coverage.xml
```

### 9.10.4 ข้อดี

- **Visibility:** เห็น uncovered code
- **Quality:** metric สำหรับ quality
- **Dead code:** หาโค้ดที่ไม่ใช้
- **Confidence:** รู้ว่าทดสอบครอบคลุม

### 9.10.5 ข้อเสีย

- **False confidence:** 100% ไม่ได้แปลว่า perfect
- **Gaming:** อาจ test เพื่อ coverage
- **Time:** เพิ่มเวลา test
- **Overhead:** instrument code

### 9.10.6 ข้อควรระวัง

```python
# ระวัง 1: Coverage ≠ Quality
def test_add():
    add(1, 2)  # coverage 100% แต่ไม่มี assert!

# ✅
def test_add():
    assert add(1, 2) == 3

# ระวัง 2: 100% ไม่ได้แปลว่าไม่มี bug
# Coverage วัดว่าโค้ดถูกรัน ไม่ได้วัดว่าถูกต้อง

# ระวัง 3: Line vs Branch
def check(x):
    if x > 0:
        return "positive"
    return "non-positive"

# Line coverage: 100% ถ้า test x=1 (รันทุกบรรทัด)
# Branch coverage: ต้อง test x=1 และ x=-1

# ระวัง 4: Exclude มากเกินไป
# ❌
def process():  # pragma: no cover
    ...  # ทั้ง function

# ✅ exclude เฉพาะที่จำเป็น

# ระวัง 5: Coverage ไม่ใช่ goal
# ตั้งเป้า 80% ดีกว่า 100% ที่ไม่ meaningful

# ระวัง 6: Integration coverage
# Coverage ใน unit test อาจไม่ครอบคลุม integration paths

# ระวัง 7: Configuration files
# อย่า exclude config files ทั้งหมด
# อาจมี bug
```

### 9.10.7 สรุป

**Tools:**

| Tool | ใช้ |
|------|-----|
| `coverage` | CLI |
| `pytest-cov` | pytest integration |
| `codecov` | CI/hosting |

**Commands:**

```bash
# รัน
pytest --cov=src

# รายงาน
pytest --cov=src --cov-report=term-missing
pytest --cov=src --cov-report=html

# Fail
pytest --cov=src --cov-fail-under=80
```

**Best practices:**
- ตั้งเป้า 80%+ (ไม่ต้อง 100%)
- Branch coverage ด้วย
- Exclude เฉพาะที่จำเป็น
- Focus ที่ critical paths
- Coverage ≠ Quality

> **อ้างอิงเพิ่มเติม:** [coverage.py](https://coverage.readthedocs.io/), [pytest-cov](https://pytest-cov.readthedocs.io/)

---

## 9.11 coverage.py

### บทนำ

`coverage.py` เป็นเครื่องมือวัด code coverage ที่นิยมที่สุดใน Python ใช้ได้ทั้ง standalone และกับ pytest

### นิยาม

`coverage.py` เป็น tool ที่วัดว่าโค้ดบรรทัดไหนถูกรันระหว่าง tests

### 9.11.1 คืออะไร

**Features:**
- Line coverage
- Branch coverage
- HTML reports
- Multiple output formats
- Configuration

### 9.11.2 ทำงานอย่างไร

1. Instrument code
2. รัน tests
3. เก็บข้อมูล
4. รายงาน

### 9.11.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install coverage
```

**คำสั่งพื้นฐาน:**

```bash
# รัน
coverage run -m pytest

# รัน script
coverage run script.py

# รายงาน
coverage report

# รายงานละเอียด
coverage report -m  # show missing

# HTML
coverage html
# เปิด htmlcov/index.html

# XML
coverage xml

# JSON
coverage json

# ลบข้อมูล
coverage erase

# รวม
coverage combine
```

**Configuration (.coveragerc):**

```ini
[run]
source = src
branch = True
omit =
    */tests/*
    */__init__.py
    */migrations/*
    setup.py
parallel = True
concurrency = multiprocessing

[report]
exclude_lines =
    pragma: no cover
    def __repr__
    def __str__
    if TYPE_CHECKING:
    if __name__ == .__main__.:
    raise NotImplementedError
    @abstractmethod
    @overload
show_missing = True
precision = 2
skip_covered = False
fail_under = 80

[html]
directory = htmlcov
title = Coverage Report
```

**pyproject.toml:**

```toml
[tool.coverage.run]
source = ["src"]
branch = true
omit = ["*/tests/*", "*/__init__.py"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
    "@abstractmethod",
]
show_missing = true
fail_under = 80

[tool.coverage.html]
directory = "htmlcov"
```

**Multiple sources:**

```bash
# หลาย packages
coverage run --source=src,lib -m pytest

# รวม
coverage combine
coverage report
```

**Branch Coverage:**

```ini
[run]
branch = True
```

```python
def check(x: int) -> str:
    if x > 0:
        return "positive"
    elif x < 0:
        return "negative"
    return "zero"


# Line coverage: 100% ถ้า test x=1
# Branch coverage: ต้อง test x=1, x=-1, x=0
```

**Coverage Output:**

```
Name                    Stmts   Miss Branch BrPart  Cover   Missing
---------------------------------------------------------------------
src/calculator.py          14      3      4      1    79%   12, 18-19
src/user.py                25      0      6      0   100%
---------------------------------------------------------------------
TOTAL                      39      3     10      1    89%
```

- **Stmts:** statements ทั้งหมด
- **Miss:** statements ที่ไม่ถูกรัน
- **Branch:** branches ทั้งหมด
- **BrPart:** branches ที่ partial
- **Cover:** เปอร์เซ็นต์
- **Missing:** บรรทัดที่ไม่ถูกรัน

**ตัวอย่าง — Coverage Workflow:**

```python
# src/order.py
from dataclasses import dataclass
from decimal import Decimal
from enum import Enum
from typing import Optional


class OrderStatus(Enum):
    PENDING = "pending"
    PAID = "paid"
    SHIPPED = "shipped"
    CANCELLED = "cancelled"


@dataclass
class Order:
    id: str
    amount: Decimal
    status: OrderStatus = OrderStatus.PENDING

    def pay(self) -> None:
        if self.status != OrderStatus.PENDING:
            raise ValueError("Order ต้องอยู่สถานะ pending")
        self.status = OrderStatus.PAID

    def ship(self) -> None:
        if self.status != OrderStatus.PAID:
            raise ValueError("Order ต้องชำระแล้ว")
        self.status = OrderStatus.SHIPPED

    def cancel(self) -> None:
        if self.status == OrderStatus.SHIPPED:
            raise ValueError("ไม่สามารถยกเลิกได้")
        self.status = OrderStatus.CANCELLED


# tests/test_order.py
import pytest
from decimal import Decimal
from src.order import Order, OrderStatus


@pytest.fixture
def order():
    return Order(id="ORD-001", amount=Decimal("100"))


def test_pay(order):
    order.pay()
    assert order.status == OrderStatus.PAID


def test_ship(order):
    order.pay()
    order.ship()
    assert order.status == OrderStatus.SHIPPED


def test_cancel_pending(order):
    order.cancel()
    assert order.status == OrderStatus.CANCELLED


# Coverage จะเห็น:
# - pay: 100% (test_pay)
# - ship: 100% (test_ship)
# - cancel: partial (test เฉพาะ pending)
# - ไม่มี test: cancel shipped
```

**HTML Report:**

```bash
coverage html
# เปิด htmlcov/index.html
```

แสดง:
- สรุปทุกไฟล์
- คลิกดูรายละเอียด
- บรรทัดที่ถูกรันเป็นสีเขียว
- บรรทัดที่ไม่ถูกรันเป็นสีแดง
- Partial branches

### 9.11.4 ข้อดี

- **Standard:** เครื่องมือมาตรฐาน
- **Feature-rich:** ครบ
- **HTML:** รายงานสวย
- **Configurable:** ปรับได้

### 9.11.5 ข้อเสีย

- **Overhead:** ช้าลง
- **Setup:** ต้องตั้งค่า
- **False confidence:** 100% ไม่ได้แปลว่า perfect

### 9.11.6 ข้อควรระวัง

```python
# ระวัง 1: Coverage ≠ Quality
def test_add():
    add(1, 2)  # coverage 100% ไม่มี assert
    # ❌

# ระวัง 2: Exclude มากเกินไป
# ❌ exclude ทั้ง module
# ✅ exclude เฉพาะบรรทัด

# ระวัง 3: Branch coverage
# เปิด branch = True ด้วย
# เพราะ line coverage อาจสูง แต่ไม่ครอบคลุม branches

# ระวัง 4: omit patterns
# ระวัง pattern กว้างเกิน
omit =
    */tests/*  # ✅
    # test_*  # ❌ อาจ omit ไฟล์ผิด

# ระวัง 5: parallel
# ถ้าใช้ pytest-xdist
# ต้อง parallel = True

# ระวัง 6: Multiple processes
# ถ้า subprocess
# concurrency = multiprocessing

# ระวัง 7: Config files
# อย่า exclude ทั้งหมด
# อาจมี bug ใน config loading
```

### 9.11.7 สรุป

**Commands:**

| Command | ใช้ |
|---------|-----|
| `coverage run` | รัน |
| `coverage report` | รายงาน |
| `coverage html` | HTML |
| `coverage xml` | XML |
| `coverage combine` | รวม |
| `coverage erase` | ลบ |

**Configuration:**
- `.coveragerc` หรือ `pyproject.toml`
- `source`, `omit`, `branch`
- `exclude_lines`
- `fail_under`

**Best practices:**
- Branch coverage
- ตั้งเป้า realistic (80%+)
- Exclude เฉพาะที่จำเป็น
- HTML สำหรับ review
- XML สำหรับ CI

> **อ้างอิงเพิ่มเติม:** [coverage.py Documentation](https://coverage.readthedocs.io/)

---

## 9.12 pytest-cov

### บทนำ

`pytest-cov` เป็น pytest plugin ที่รวม coverage.py เข้ากับ pytest อย่างแนบเนียน

### นิยาม

`pytest-cov` ให้ `--cov` option สำหรับ pytest

### 9.12.1 คืออะไร

**Features:**
- `--cov` option
- Multiple report formats
- Fail under threshold
- Config via pytest

### 9.12.2 ทำงานอย่างไร

pytest-cov เรียก coverage.py อัตโนมัติเมื่อใช้ `--cov`

### 9.12.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install pytest-cov
```

**คำสั่งพื้นฐาน:**

```bash
# Coverage ของ src
pytest --cov=src

# หลาย sources
pytest --cov=src --cov=lib

# รายงาน term-missing
pytest --cov=src --cov-report=term-missing

# HTML
pytest --cov=src --cov-report=html

# XML
pytest --cov=src --cov-report=xml

# หลาย reports
pytest --cov=src --cov-report=html --cov-report=xml

# Fail ถ้าต่ำกว่า 80%
pytest --cov=src --cov-fail-under=80

# ไม่มีรายงาน
pytest --cov=src --cov-report=
```

**Configuration:**

```toml
# pyproject.toml
[tool.pytest.ini_options]
addopts = [
    "--cov=src",
    "--cov-report=term-missing",
    "--cov-report=html",
    "--cov-fail-under=80",
]

[tool.coverage.run]
branch = true
source = ["src"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
    "@abstractmethod",
]
```

**Combine กับ pytest options:**

```bash
# Verbose + coverage
pytest -v --cov=src

# Parallel + coverage
pytest -n auto --cov=src  # ต้อง pytest-xdist

# Specific test + coverage
pytest tests/test_calculator.py --cov=src.calculator
```

**Coverage ของ module เฉพาะ:**

```bash
# เฉพาะ module
pytest --cov=src.calculator

# เฉพาะ package
pytest --cov=src.models
```

**ตัวอย่างการใช้งานจริง:**

```python
# src/user_service.py
from dataclasses import dataclass
from typing import Optional


@dataclass
class User:
    id: int
    name: str
    email: str
    active: bool = True


class UserService:
    def __init__(self):
        self._users: dict[int, User] = {}
        self._next_id = 1

    def create(self, name: str, email: str) -> User:
        if not name:
            raise ValueError("name ต้องไม่ว่าง")
        if "@" not in email:
            raise ValueError("email ไม่ถูกต้อง")

        user = User(
            id=self._next_id,
            name=name,
            email=email,
        )
        self._users[user.id] = user
        self._next_id += 1
        return user

    def get(self, user_id: int) -> Optional[User]:
        return self._users.get(user_id)

    def deactivate(self, user_id: int) -> bool:
        user = self._users.get(user_id)
        if user is None:
            return False
        user.active = False
        return True

    def list_active(self) -> list[User]:
        return [u for u in self._users.values() if u.active]


# tests/test_user_service.py
import pytest
from src.user_service import UserService, User


@pytest.fixture
def service():
    return UserService()


class TestCreate:
    def test_valid(self, service):
        user = service.create("Alice", "alice@example.com")
        assert user.id == 1
        assert user.name == "Alice"
        assert user.active is True

    def test_empty_name(self, service):
        with pytest.raises(ValueError, match="name"):
            service.create("", "test@example.com")

    def test_invalid_email(self, service):
        with pytest.raises(ValueError, match="email"):
            service.create("Alice", "invalid")


class TestGet:
    def test_found(self, service):
        created = service.create("Alice", "alice@example.com")
        found = service.get(created.id)
        assert found == created

    def test_not_found(self, service):
        assert service.get(999) is None


class TestDeactivate:
    def test_success(self, service):
        user = service.create("Alice", "alice@example.com")
        assert service.deactivate(user.id) is True
        assert service.get(user.id).active is False

    def test_not_found(self, service):
        assert service.deactivate(999) is False


class TestListActive:
    def test_empty(self, service):
        assert service.list_active() == []

    def test_mixed(self, service):
        u1 = service.create("Alice", "alice@example.com")
        u2 = service.create("Bob", "bob@example.com")
        service.deactivate(u2.id)

        active = service.list_active()
        assert len(active) == 1
        assert active[0].id == u1.id


# รัน:
# pytest --cov=src --cov-report=term-missing
#
# Output:
# Name                     Stmts   Miss Branch BrPart  Cover   Missing
# ---------------------------------------------------------------------
# src/user_service.py         35      0      8      0   100%
# ---------------------------------------------------------------------
# TOTAL                       35      0      8      0   100%
```

### 9.12.4 ข้อดี

- **Easy:** `--cov` option
- **Integrated:** กับ pytest
- **Flexible:** หลาย formats
- **Configurable:** ผ่าน pytest

### 9.12.5 ข้อเสีย

- **Third-party:** ต้องติดตั้ง
- **Overhead:** เพิ่มเวลา

### 9.12.6 ข้อควรระวัง

```python
# ระวัง 1: addopts ใน config
# ถ้าใส่ --cov ใน addopts
# ทุก pytest run จะมี coverage (ช้า)

# ✅ ถ้าไม่ต้องการทุกครั้ง
# ใช้ command line หรือแยก config

# ระวัง 2: Coverage scope
# --cov=src ครอบคลุมทั้ง package
# --cov=src.module เฉพาะ module
# --cov=. ทั้งหมด (รวม tests!)

# ระวัง 3: fail-under
# ⚠️ อาจ block development
# ตั้งค่าที่สมเหตุสมผล

# ระวัง 4: Parallel
# ต้องมี pytest-xdist
# และ config coverage

# ระวัง 5: Subprocess
# Coverage ไม่ track subprocess โดย default

# ระวัง 6: Exclude tests
# อย่า include tests ใน coverage
# --cov=src ไม่ใช่ --cov=.
```

### 9.12.7 สรุป

**Options:**

| Option | ใช้ |
|--------|-----|
| `--cov=src` | Coverage ของ src |
| `--cov-report=term-missing` | แสดงบรรทัดที่ขาด |
| `--cov-report=html` | HTML |
| `--cov-report=xml` | XML |
| `--cov-fail-under=80` | Fail ถ้าต่ำ |

**Best practices:**
- `--cov=src` ไม่ใช่ `--cov=.`
- ใช้ `term-missing` สำหรับ dev
- HTML สำหรับ review
- XML สำหรับ CI
- ตั้ง `fail-under` ที่สมเหตุสมผล
- Config ใน `pyproject.toml`

> **อ้างอิงเพิ่มเติม:** [pytest-cov Documentation](https://pytest-cov.readthedocs.io/)

---

## 9.13 Integration Testing

### บทนำ

Integration Testing ทดสอบการทำงานร่วมกันของ components หลายตัว แตกต่างจาก unit test ที่ทดสอบแยก

### นิยาม

Integration Test คือการทดสอบที่ตรวจสอบว่า components ทำงานร่วมกันได้อย่างถูกต้อง

### 9.13.1 คืออะไร

**ขอบเขต:**
- Module ↔ Module
- Service ↔ Database
- Service ↔ External API
- Frontend ↔ Backend

**เปรียบเทียบ:**

| Aspect | Unit | Integration |
|--------|------|-------------|
| Scope | 1 unit | หลาย units |
| Speed | เร็วมาก | ช้า |
| Dependencies | Mock | จริง/บางส่วน |
| Purpose | Logic | Interaction |

### 9.13.2 ทำงานอย่างไร

Integration test:
1. Setup environment (DB, services)
2. รัน components จริง
3. ตรวจสอบ interaction
4. Cleanup

### 9.13.3 การใช้งาน

**Database Integration:**

```python
import pytest
import sqlite3
from pathlib import Path


@pytest.fixture
def db_path(tmp_path: Path) -> Path:
    return tmp_path / "test.db"


@pytest.fixture
def db(db_path: Path):
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    conn.executescript("""
        CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL
        );
    """)
    yield conn
    conn.close()


class UserRepository:
    def __init__(self, conn: sqlite3.Connection):
        self.conn = conn

    def create(self, name: str, email: str) -> dict:
        cursor = self.conn.execute(
            "INSERT INTO users (name, email) VALUES (?, ?)",
            (name, email),
        )
        self.conn.commit()
        return self.get(cursor.lastrowid)

    def get(self, user_id: int) -> dict | None:
        row = self.conn.execute(
            "SELECT * FROM users WHERE id = ?",
            (user_id,),
        ).fetchone()
        return dict(row) if row else None


class TestUserRepositoryIntegration:
    """Integration test กับ SQLite จริง"""

    def test_create_and_retrieve(self, db):
        repo = UserRepository(db)

        created = repo.create("Alice", "alice@example.com")
        retrieved = repo.get(created["id"])

        assert retrieved["name"] == "Alice"
        assert retrieved["email"] == "alice@example.com"

    def test_unique_email_constraint(self, db):
        repo = UserRepository(db)
        repo.create("Alice", "alice@example.com")

        with pytest.raises(sqlite3.IntegrityError):
            repo.create("Bob", "alice@example.com")
```

**API Integration:**

```python
import pytest
import httpx
from fastapi import FastAPI
from fastapi.testclient import TestClient


# app.py
app = FastAPI()

users_db: dict[int, dict] = {}


@app.post("/users")
def create_user(name: str, email: str):
    user_id = len(users_db) + 1
    user = {"id": user_id, "name": name, "email": email}
    users_db[user_id] = user
    return user


@app.get("/users/{user_id}")
def get_user(user_id: int):
    if user_id not in users_db:
        raise HTTPException(404, "User not found")
    return users_db[user_id]


# test_api.py
@pytest.fixture
def client():
    users_db.clear()
    return TestClient(app)


class TestUserAPI:
    def test_create_user(self, client):
        response = client.post(
            "/users",
            params={"name": "Alice", "email": "alice@example.com"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["name"] == "Alice"
        assert data["id"] == 1

    def test_get_user(self, client):
        # Create
        create_response = client.post(
            "/users",
            params={"name": "Alice", "email": "alice@example.com"},
        )
        user_id = create_response.json()["id"]

        # Get
        get_response = client.get(f"/users/{user_id}")

        assert get_response.status_code == 200
        assert get_response.json()["name"] == "Alice"

    def test_get_nonexistent(self, client):
        response = client.get("/users/999")
        assert response.status_code == 404
```

**Service Integration:**

```python
import pytest
from dataclasses import dataclass
from decimal import Decimal


@dataclass
class Inventory:
    items: dict[str, int]

    def reserve(self, item: str, qty: int) -> bool:
        if self.items.get(item, 0) < qty:
            return False
        self.items[item] -= qty
        return True


@dataclass
class Cart:
    items: list[tuple[str, int]]

    def total_items(self) -> int:
        return sum(qty for _, qty in self.items)


class OrderService:
    def __init__(self, inventory: Inventory):
        self.inventory = inventory

    def place_order(self, cart: Cart) -> dict:
        reserved = []

        for item, qty in cart.items:
            if not self.inventory.reserve(item, qty):
                # Rollback
                for r_item, r_qty in reserved:
                    self.inventory.items[r_item] += r_qty
                return {"success": False, "error": f"Out of stock: {item}"}
            reserved.append((item, qty))

        return {"success": True, "items": cart.total_items()}


class TestOrderServiceIntegration:
    @pytest.fixture
    def inventory(self):
        return Inventory(items={"A": 10, "B": 5, "C": 0})

    @pytest.fixture
    def service(self, inventory):
        return OrderService(inventory)

    def test_successful_order(self, service, inventory):
        cart = Cart(items=[("A", 3), ("B", 2)])
        result = service.place_order(cart)

        assert result["success"] is True
        assert inventory.items["A"] == 7
        assert inventory.items["B"] == 3

    def test_insufficient_stock(self, service, inventory):
        cart = Cart(items=[("A", 3), ("C", 1)])
        result = service.place_order(cart)

        assert result["success"] is False
        assert "C" in result["error"]
        # ✅ Rollback — A ต้องไม่เปลี่ยน
        assert inventory.items["A"] == 10
```

**Docker Integration:**

```python
# tests/integration/conftest.py
import pytest
import subprocess
import time
import httpx


@pytest.fixture(scope="session")
def docker_postgres():
    """Start PostgreSQL container"""
    container_id = subprocess.check_output([
        "docker", "run", "-d",
        "--rm",
        "-p", "5432:5432",
        "-e", "POSTGRES_PASSWORD=test",
        "-e", "POSTGRES_DB=testdb",
        "postgres:15",
    ]).decode().strip()

    # รอ ready
    for _ in range(30):
        try:
            result = subprocess.run(
                ["docker", "exec", container_id,
                 "pg_isready", "-U", "postgres"],
                capture_output=True,
            )
            if result.returncode == 0:
                break
        except Exception:
            pass
        time.sleep(1)

    yield {
        "host": "localhost",
        "port": 5432,
        "database": "testdb",
        "user": "postgres",
        "password": "test",
    }

    # Cleanup
    subprocess.run(["docker", "stop", container_id])


@pytest.fixture
def postgres_conn(docker_postgres):
    import psycopg2
    conn = psycopg2.connect(**docker_postgres)
    yield conn
    conn.close()
```

**pytest markers:**

```python
import pytest


@pytest.mark.integration
def test_database_integration():
    ...


# pytest.ini
# markers =
#     integration: Integration tests
#     slow: Slow tests

# รัน
# pytest -m integration
# pytest -m "not integration"
```

### 9.13.4 ข้อดี

- **Realistic:** ทดสอบจริง
- **Catch bugs:** integration bugs
- **Confidence:** มั่นใจกว่า unit
- **End-to-end:** ครอบคลุม

### 9.13.5 ข้อเสีย

- **ช้า:** ช้ากว่า unit
- **Setup:** ต้อง setup เยอะ
- **Flaky:** อาจไม่เสถียร
- **Debug:** ยากกว่า

### 9.13.6 ข้อควรระวัง

```python
# ระวัง 1: Integration test ช้า
# แยกจาก unit tests
# ใช้ marker

# ระวัง 2: Shared state
# ❌
class TestA:
    def test_create(self):
        global_db.create("user")

class TestB:
    def test_count(self):
        assert global_db.count() == 0  # ❌ depend on order

# ✅ cleanup ระหว่าง tests

# ระวัง 3: External services
# ❌ depend on production API
# ✅ ใช้ test containers หรือ mock server

# ระวัง 4: Database state
@pytest.fixture(autouse=True)
def cleanup_db(db):
    yield
    db.execute("DELETE FROM users")
    db.commit()

# ระวัง 5: Port conflicts
# ⚠️ หลาย tests ใช้ port เดียว
# ✅ random ports

# ระวัง 6: Timeouts
# Integration tests อาจค้าง
@pytest.mark.timeout(30)
def test_api():
    ...

# ระวัง 7: CI/CD
# Integration tests ต้องมี services
# ใช้ docker-compose ใน CI
```

### 9.13.7 สรุป

**Types:**
- Module integration
- Database integration
- API integration
- Service integration
- End-to-end

**Tools:**
- `testcontainers` — Docker
- `pytest-docker`
- `httpx` / `requests` — API
- `TestClient` — FastAPI

**Best practices:**
- แยกจาก unit tests
- ใช้ markers
- Cleanup state
- Testcontainers สำหรับ DB
- Timeouts
- CI/CD setup

> **อ้างอิงเพิ่มเติม:** [Testcontainers Python](https://testcontainers-python.readthedocs.io/)

---

## 9.14 End-to-End Testing

### บทนำ

End-to-End (E2E) Testing ทดสอบระบบทั้งหมดจาก user perspective จำลองการใช้งานจริง

### นิยาม

E2E Test คือการทดสอบ flow ทั้งหมดของ application จาก UI ถึง database

### 9.14.1 คืออะไร

**Scope:**
- UI → Backend → Database
- User workflows
- Real environment

### 9.14.2 ทำงานอย่างไร

E2E tools:
1. เปิด browser
2. Navigate
3. Interact (click, type)
4. Assert
5. Cleanup

### 9.14.3 การใช้งาน

**Playwright:**

```bash
pip install playwright
playwright install
```

```python
import pytest
from playwright.sync_api import Page, expect


def test_homepage(page: Page):
    page.goto("https://example.com")

    expect(page).to_have_title("Example Domain")
    expect(page.locator("h1")).to_have_text("Example Domain")


def test_login_flow(page: Page):
    page.goto("https://app.example.com/login")

    # Fill form
    page.fill("#username", "testuser")
    page.fill("#password", "testpass")

    # Click
    page.click("button[type=submit]")

    # Assert redirect
    expect(page).to_have_url("https://app.example.com/dashboard")
    expect(page.locator(".welcome")).to_contain_text("Welcome, testuser")


def test_add_to_cart(page: Page):
    page.goto("https://shop.example.com")

    # Search
    page.fill("#search", "laptop")
    page.press("#search", "Enter")

    # Add to cart
    page.click("text=Add to Cart")

    # Verify
    expect(page.locator(".cart-count")).to_have_text("1")


# Fixtures
@pytest.fixture(scope="session")
def browser_context_args():
    return {
        "viewport": {"width": 1280, "height": 720},
    }


@pytest.fixture
def logged_in_page(page: Page):
    page.goto("https://app.example.com/login")
    page.fill("#username", "testuser")
    page.fill("#password", "testpass")
    page.click("button[type=submit]")
    page.wait_for_url("**/dashboard")
    return page


def test_dashboard(logged_in_page: Page):
    expect(logged_in_page.locator("h1")).to_have_text("Dashboard")
```

**Selenium:**

```python
import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


@pytest.fixture
def driver():
    driver = webdriver.Chrome()
    driver.implicitly_wait(10)
    yield driver
    driver.quit()


def test_login(driver):
    driver.get("https://app.example.com/login")

    driver.find_element(By.ID, "username").send_keys("testuser")
    driver.find_element(By.ID, "password").send_keys("testpass")
    driver.find_element(By.CSS_SELECTOR, "button[type=submit]").click()

    WebDriverWait(driver, 10).until(
        EC.url_contains("/dashboard")
    )

    assert "Dashboard" in driver.title
```

**pytest-playwright:**

```toml
# pyproject.toml
[tool.pytest.ini_options]
addopts = "--browser=chromium --headed"
```

```python
# tests/e2e/test_shop.py
import pytest
from playwright.sync_api import Page, expect


@pytest.mark.e2e
class TestShoppingFlow:
    def test_complete_purchase(self, page: Page):
        # 1. Homepage
        page.goto("/")
        expect(page).to_have_title("Shop")

        # 2. Search
        page.fill("[name=search]", "laptop")
        page.click("[type=submit]")
        expect(page.locator(".product")).to_have_count(1)

        # 3. Add to cart
        page.click(".product >> text=Add to Cart")
        expect(page.locator(".cart-badge")).to_have_text("1")

        # 4. Checkout
        page.click("text=Checkout")
        expect(page).to_have_url("/checkout")

        # 5. Fill shipping
        page.fill("#name", "Test User")
        page.fill("#address", "123 Test St")
        page.fill("#city", "Bangkok")
        page.select_option("#country", "TH")

        # 6. Payment
        page.fill("#card", "4242424242424242")
        page.fill("#expiry", "12/25")
        page.fill("#cvv", "123")

        # 7. Submit
        page.click("text=Place Order")

        # 8. Verify
        expect(page.locator(".success")).to_contain_text("Order confirmed")
        expect(page.locator(".order-id")).to_be_visible()
```

**API E2E:**

```python
import pytest
import httpx


@pytest.mark.e2e
def test_user_registration_flow():
    base_url = "https://api.example.com"

    with httpx.Client(base_url=base_url) as client:
        # 1. Register
        response = client.post("/auth/register", json={
            "email": "newuser@example.com",
            "password": "SecurePass123!",
            "name": "New User",
        })
        assert response.status_code == 201
        user_id = response.json()["id"]

        # 2. Login
        response = client.post("/auth/login", json={
            "email": "newuser@example.com",
            "password": "SecurePass123!",
        })
        assert response.status_code == 200
        token = response.json()["access_token"]

        # 3. Get profile
        response = client.get(
            "/users/me",
            headers={"Authorization": f"Bearer {token}"},
        )
        assert response.status_code == 200
        assert response.json()["name"] == "New User"

        # 4. Update profile
        response = client.patch(
            "/users/me",
            headers={"Authorization": f"Bearer {token}"},
            json={"name": "Updated Name"},
        )
        assert response.status_code == 200

        # 5. Delete account
        response = client.delete(
            "/users/me",
            headers={"Authorization": f"Bearer {token}"},
        )
        assert response.status_code == 204

        # 6. Verify deleted
        response = client.get(
            "/users/me",
            headers={"Authorization": f"Bearer {token}"},
        )
        assert response.status_code == 401
```

**Page Object Model:**

```python
from playwright.sync_api import Page, expect


class LoginPage:
    def __init__(self, page: Page):
        self.page = page
        self.url = "/login"

    def goto(self):
        self.page.goto(self.url)

    def login(self, username: str, password: str):
        self.page.fill("#username", username)
        self.page.fill("#password", password)
        self.page.click("button[type=submit]")


class DashboardPage:
    def __init__(self, page: Page):
        self.page = page

    @property
    def welcome_message(self):
        return self.page.locator(".welcome")

    def expect_visible(self):
        expect(self.welcome_message).to_be_visible()


# tests
def test_login(page: Page):
    login = LoginPage(page)
    dashboard = DashboardPage(page)

    login.goto()
    login.login("testuser", "testpass")

    dashboard.expect_visible()
```

**ตัวอย่างการใช้งานจริง:**

```python
# tests/e2e/conftest.py
import pytest
import subprocess
import time
import httpx
from playwright.sync_api import Page


@pytest.fixture(scope="session")
def server():
    """Start application server"""
    process = subprocess.Popen(
        ["uvicorn", "app.main:app", "--port", "8000"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    # รอ ready
    for _ in range(30):
        try:
            httpx.get("http://localhost:8000/health")
            break
        except httpx.ConnectError:
            time.sleep(0.5)

    yield "http://localhost:8000"

    process.terminate()
    process.wait()


@pytest.fixture
def test_data(server):
    """สร้าง test data"""
    response = httpx.post(f"{server}/api/test-data")
    yield response.json()
    httpx.delete(f"{server}/api/test-data")


# tests/e2e/test_user_flow.py
@pytest.mark.e2e
def test_user_can_register_and_login(page: Page, server: str):
    # Navigate
    page.goto(f"{server}/register")

    # Register
    page.fill("#email", "e2e@example.com")
    page.fill("#password", "TestPass123!")
    page.fill("#confirm-password", "TestPass123!")
    page.click("button[type=submit]")

    # Should be logged in
    expect(page).to_have_url(f"{server}/dashboard")
    expect(page.locator(".welcome")).to_contain_text("e2e@example.com")

    # Logout
    page.click(".logout")

    # Login
    page.fill("#email", "e2e@example.com")
    page.fill("#password", "TestPass123!")
    page.click("button[type=submit]")

    # Should be logged in again
    expect(page).to_have_url(f"{server}/dashboard")
```

### 9.14.4 ข้อดี

- **Realistic:** จำลองผู้ใช้จริง
- **Complete:** ครอบคลุมทั้งหมด
- **Confidence:** มั่นใจที่สุด
- **Regression:** จับ bugs

### 9.14.5 ข้อเสีย

- **ช้ามาก:** ใช้เวลานาน
- **Flaky:** อาจไม่เสถียร
- **Setup:** ต้อง setup เยอะ
- **Maintenance:** ต้อง update บ่อย
- **Debug:** ยาก

### 9.14.6 ข้อควรระวัง

```python
# ระวัง 1: Flaky tests
# ❌ depend on timing
page.click("button")
page.click("next-button")  # ⚠️ อาจ fail

# ✅ wait
page.click("button")
page.wait_for_selector("next-button")
page.click("next-button")

# ระวัง 2: Hard-coded waits
# ❌
time.sleep(5)  # ช้าและไม่แน่นอน

# ✅
page.wait_for_selector(".loaded")

# ระวัง 3: Shared state
# ❌
def test_a(page):
    page.goto("/create-user")
    # ...

def test_b(page):
    page.goto("/delete-user")  # depend on test_a

# ✅ isolated

# ระวัง 4: Multiple browsers
# ✅ ใช้ parametrize
@pytest.mark.parametrize("browser_name", ["chromium", "firefox", "webkit"])
def test_cross_browser(page, browser_name):
    ...

# ระวัง 5: Slow in CI
# ✅ รันเฉพาะ critical paths
# ✅ Parallel execution

# ระวัง 6: Screenshots on failure
# ✅
@pytest.fixture
def page(browser, request):
    context = browser.new_context()
    page = context.new_page()
    yield page
    if request.node.rep_call.failed:
        page.screenshot(path=f"failures/{request.node.name}.png")

# ระวัง 7: Test data cleanup
# ✅ ใช้ fixtures สำหรับ setup/teardown
```

### 9.14.7 สรุป

**Tools:**

| Tool | ใช้ |
|------|-----|
| Playwright | Modern, เร็ว |
| Selenium | Traditional |
| Cypress | JavaScript |
| pytest-playwright | Integration |

**Best practices:**
- แยกจาก unit tests (`@pytest.mark.e2e`)
- Page Object Model
- Wait explicitly (อย่า sleep)
- Screenshots on failure
- Test เฉพาะ critical paths
- Parallel execution
- Cleanup data

> **อ้างอิงเพิ่มเติม:** [Playwright Python](https://playwright.dev/python/), [Selenium](https://selenium-python.readthedocs.io/)

---

## 9.15 Regression Testing

### บทนำ

Regression Testing คือการทดสอบซ้ำเพื่อให้แน่ใจว่าการเปลี่ยนแปลงไม่ทำให้ functionality เดิมเสีย

### นิยาม

Regression Test คือ test suite ที่รันซ้ำเมื่อโค้ดเปลี่ยน เพื่อจับ bugs ที่เกิดจากการเปลี่ยนแปลง

### 9.15.1 คืออะไร

**เป้าหมาย:**
- จับ bugs ใหม่
- ป้องกันการ "พัง" ของ features เก่า
- เพิ่มความมั่นใจในการ refactor

### 9.15.2 ทำงานอย่างไร

1. รัน test suite เดิม
2. ถ้า pass → โค้ดใหม่ไม่พังของเก่า
3. ถ้า fail → มี regression

### 9.15.3 การใช้งาน

**Snapshot Testing:**

```python
import pytest
import json
from pathlib import Path


class Snapshot:
    def __init__(self, snapshot_dir: Path):
        self.dir = snapshot_dir
        self.dir.mkdir(parents=True, exist_ok=True)

    def assert_match(self, name: str, value):
        """เปรียบเทียบกับ snapshot"""
        snapshot_file = self.dir / f"{name}.json"

        if not snapshot_file.exists():
            # สร้าง snapshot ครั้งแรก
            snapshot_file.write_text(
                json.dumps(value, indent=2, ensure_ascii=False),
                encoding="utf-8",
            )
            pytest.skip(f"Created snapshot: {name}")
            return

        expected = json.loads(snapshot_file.read_text(encoding="utf-8"))
        assert value == expected, (
            f"Snapshot mismatch for {name}\n"
            f"Run with --update-snapshots to update"
        )


@pytest.fixture
def snapshot(tmp_path):
    return Snapshot(tmp_path / "snapshots")


def test_api_response(snapshot):
    response = {
        "id": 1,
        "name": "Test",
        "items": [
            {"id": 1, "qty": 2},
            {"id": 2, "qty": 1},
        ],
    }
    snapshot.assert_match("api_response", response)
```

**Golden Files:**

```python
from pathlib import Path


def test_report_generation(golden_dir: Path):
    """เปรียบเทียบ output กับ golden file"""
    report = generate_report(sample_data)

    golden_file = golden_dir / "expected_report.txt"
    expected = golden_file.read_text(encoding="utf-8")

    assert report == expected
```

**Characterization Tests:**

```python
def test_legacy_calculation():
    """Test behavior ที่มีอยู่ (แม้ไม่รู้ว่าถูกหรือไม่)"""
    # บันทึก behavior ปัจจุบัน
    cases = [
        (0, 0),
        (1, 1),
        (2, 4),
        (10, 100),
        (-5, 25),
    ]

    for input_val, expected_output in cases:
        result = legacy_function(input_val)
        assert result == expected_output, (
            f"Behavior changed for {input_val}"
        )
```

**pytest-regressions:**

```bash
pip install pytest-regressions
```

```python
# tests/test_data.py
def test_dataframe(data_regression):
    import pandas as pd

    df = pd.DataFrame({
        "name": ["Alice", "Bob"],
        "age": [30, 25],
    })

    data_regression.check(df.to_dict())


def test_file(file_regression):
    content = "Hello\nWorld\n"
    file_regression.check(content, extension=".txt")


def test_number(num_regression):
    result = {"pi": 3.14159, "e": 2.71828}
    num_regression.check(result)
```

**ตัวอย่างการใช้งานจริง — API Contract:**

```python
# tests/regression/test_api_contract.py
import json
from pathlib import Path
import pytest


CONTRACTS_DIR = Path(__file__).parent / "contracts"


@pytest.fixture
def contract_loader():
    def load(name: str) -> dict:
        file = CONTRACTS_DIR / f"{name}.json"
        return json.loads(file.read_text(encoding="utf-8"))
    return load


class TestAPIContract:
    def test_user_response_shape(self, contract_loader, client):
        """ตรวจสอบโครงสร้าง response"""
        response = client.get("/api/users/1")
        data = response.json()

        expected_keys = contract_loader("user_response")["keys"]
        assert set(data.keys()) == set(expected_keys), (
            f"Response keys changed!\n"
            f"Expected: {expected_keys}\n"
            f"Got: {list(data.keys())}"
        )

    def test_error_format(self, contract_loader, client):
        """ตรวจสอบรูปแบบ error"""
        response = client.get("/api/users/999")
        data = response.json()

        expected = contract_loader("error_response")
        assert "error" in data
        assert set(data["error"].keys()) == set(expected["error_keys"])
```

**Database Migration Regression:**

```python
import pytest
import sqlite3
from pathlib import Path


def migrate(db: sqlite3.Connection, version: int) -> None:
    """Apply migrations up to version"""
    for v in range(1, version + 1):
        apply_migration(db, v)


def test_migration_from_v1_to_v3(tmp_path: Path):
    """ทดสอบ migration เก่า → ใหม่"""
    db = sqlite3.connect(tmp_path / "test.db")

    # Setup version 1
    migrate(db, 1)
    db.execute("INSERT INTO users (name) VALUES ('test')")
    db.commit()

    # Migrate to version 3
    migrate(db, 3)

    # ข้อมูลเดิมต้องอยู่
    row = db.execute("SELECT name FROM users").fetchone()
    assert row[0] == "test"

    # Schema ใหม่ต้องมี
    cursor = db.execute("PRAGMA table_info(users)")
    columns = [row[1] for row in cursor.fetchall()]
    assert "email" in columns  # เพิ่มใน v2
    assert "created_at" in columns  # เพิ่มใน v3
```

**Visual Regression:**

```python
# ใช้ pytest-playwright
def test_homepage_visual(page, assert_snapshot):
    page.goto("/")
    assert_snapshot(page.screenshot(), "homepage.png")


def test_button_states(page, assert_snapshot):
    page.goto("/components/button")
    assert_snapshot(page.locator(".button").screenshot(), "button.png")
```

### 9.15.4 ข้อดี

- **Protection:** ป้องกัน regression
- **Confidence:** มั่นใจในการ refactor
- **Documentation:** บันทึก behavior
- **CI/CD:** รันอัตโนมัติ

### 9.15.5 ข้อเสีย

- **Maintenance:** ต้อง update
- **Slow:** ถ้า suite ใหญ่
- **False alarms:** อาจ fail จาก formatting

### 9.15.6 ข้อควรระวัง

```python
# ระวัง 1: Snapshot ที่เปราะบาง
# ❌ include timestamps, random IDs
snapshot = {
    "id": str(uuid4()),  # เปลี่ยนทุกครั้ง
    "created": datetime.now().isoformat(),
}

# ✅ exclude หรือ normalize
snapshot = {
    "id": "UUID",
    "created": "TIMESTAMP",
}

# ระวัง 2: Update โดยไม่ดู
# ❌ --update-snapshots อัตโนมัติ
# ✅ review diff ก่อน update

# ระวัง 3: Flaky regression tests
# ✅ deterministic data

# ระวัง 4: มากเกินไป
# ไม่ต้อง snapshot ทุกอย่าง
# เน้น critical paths

# ระวัง 5: Golden files ใหญ่
# ✅ เฉพาะส่วนสำคัญ

# ระวัง 6: Platform differences
# ⚠️ line endings, formatting
# ✅ normalize

# ระวัง 7: Version control
# ✅ commit snapshots
# ✅ แต่ exclude ถ้า generate จาก tests
```

### 9.15.7 สรุป

**Types:**
- Snapshot testing
- Golden files
- Characterization tests
- Contract testing
- Visual regression
- Migration testing

**Tools:**
- `pytest-regressions`
- `pytest-playwright`
- Custom snapshot

**Best practices:**
- Deterministic data
- Normalize output
- Review updates
- Critical paths only
- Commit snapshots
- Clear naming

> **อ้างอิงเพิ่มเติม:** [pytest-regressions](https://pytest-regressions.readthedocs.io/)

---

## 9.16 Performance Testing

### บทนำ

Performance Testing วัดความเร็วและประสิทธิภาพของโค้ด ช่วยหา bottlenecks และเปรียบเทียบ implementations

### นิยาม

Performance Test คือการวัดเวลา หน่วยความจำ และ throughput ของโค้ด

### 9.16.1 คืออะไร

**Types:**
- **Micro-benchmark:** วัด function เดียว
- **Profiling:** หา bottleneck
- **Load testing:** วัดภายใต้โหลด

### 9.16.2 ทำงานอย่างไร

- `timeit` — micro-benchmark
- `cProfile` — profiling
- `pytest-benchmark` — integrated benchmarking
- `memory_profiler` — memory

### 9.16.3 การใช้งาน

**timeit:**

```python
import timeit

# วัด expression
time = timeit.timeit(
    "sum(range(100))",
    number=10000,
)
print(f"Time: {time:.4f}s")

# กับ setup
time = timeit.timeit(
    "sum(data)",
    setup="data = list(range(1000))",
    number=10000,
)

# เปรียบเทียบ
t1 = timeit.timeit(
    "[x * 2 for x in range(100)]",
    number=10000,
)
t2 = timeit.timeit(
    "list(map(lambda x: x * 2, range(100)))",
    number=10000,
)
print(f"Comprehension: {t1:.4f}s")
print(f"Map: {t2:.4f}s")

# ใช้ Timer
timer = timeit.Timer(
    "func()",
    setup="from mymodule import func",
)
print(timer.timeit(1000))
```

**pytest-benchmark:**

```bash
pip install pytest-benchmark
```

```python
def test_list_comprehension(benchmark):
    result = benchmark(lambda: [x * 2 for x in range(1000)])
    assert len(result) == 1000


def test_map(benchmark):
    result = benchmark(lambda: list(map(lambda x: x * 2, range(1000))))
    assert len(result) == 1000


# รัน
# pytest --benchmark-only
# pytest --benchmark-compare
# pytest --benchmark-autosave
```

**cProfile:**

```python
import cProfile
import pstats
from io import StringIO


def profile_function():
    # ... code ที่ต้องการ profile
    total = 0
    for i in range(10000):
        total += sum(range(100))
    return total


# Profile
profiler = cProfile.Profile()
profiler.enable()
profile_function()
profiler.disable()

# Report
stream = StringIO()
stats = pstats.Stats(profiler, stream=stream)
stats.sort_stats("cumulative")
stats.print_stats(10)
print(stream.getvalue())
```

**Output:**

```
   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
     1    0.001    0.001    0.523    0.523 script.py:5(profile_function)
 10000    0.522    0.000    0.522    0.000 {built-in method builtins.sum}
```

- **ncalls:** จำนวนครั้งที่เรียก
- **tottime:** เวลาทั้งหมดใน function (ไม่รวม subcalls)
- **cumtime:** เวลารวม (รวม subcalls)
- **percall:** เฉลี่ยต่อครั้ง

**line_profiler:**

```bash
pip install line-profiler
```

```python
from line_profiler import LineProfiler


def process_data(items):
    result = []
    for item in items:
        transformed = item * 2
        result.append(transformed)
    return result


lp = LineProfiler()
lp.add_function(process_data)
lp.runcall(process_data, list(range(10000)))
lp.print_stats()
```

**memory_profiler:**

```bash
pip install memory-profiler
```

```python
from memory_profiler import profile


@profile
def create_large_list():
    data = [i for i in range(1000000)]
    return data


@profile
def create_generator():
    return (i for i in range(1000000))


create_large_list()
create_generator()
```

**ตัวอย่างการใช้งานจริง — Benchmark Suite:**

```python
# tests/benchmarks/test_data_processing.py
import pytest


class TestListProcessing:
    def test_list_comprehension(self, benchmark):
        data = list(range(10000))
        result = benchmark(lambda: [x * 2 for x in data])
        assert len(result) == 10000

    def test_map_function(self, benchmark):
        data = list(range(10000))
        result = benchmark(lambda: list(map(lambda x: x * 2, data)))
        assert len(result) == 10000


class TestStringBuilding:
    def test_concatenation(self, benchmark):
        def build():
            result = ""
            for i in range(1000):
                result += str(i)
            return result
        benchmark(build)

    def test_join(self, benchmark):
        def build():
            return "".join(str(i) for i in range(1000))
        benchmark(build)

    def test_string_io(self, benchmark):
        from io import StringIO

        def build():
            buf = StringIO()
            for i in range(1000):
                buf.write(str(i))
            return buf.getvalue()
        benchmark(build)


class TestDictAccess:
    def test_dict_get(self, benchmark):
        data = {i: i * 2 for i in range(1000)}
        benchmark(lambda: data.get(500))

    def test_dict_bracket(self, benchmark):
        data = {i: i * 2 for i in range(1000)}
        benchmark(lambda: data[500])
```

**CI Integration:**

```yaml
# .github/workflows/benchmark.yml
name: Benchmarks

on:
  push:
    branches: [main]
  pull_request:

jobs:
  benchmark:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - run: pip install -e ".[dev]"

      - name: Run benchmarks
        run: pytest tests/benchmarks --benchmark-json=output.json

      - name: Store benchmark result
        uses: benchmark-action/github-action-benchmark@v1
        with:
          tool: pytest
          output-file-path: output.json
          github-token: ${{ secrets.GITHUB_TOKEN }}
          auto-push: true
```

### 9.16.4 ข้อดี

- **Data-driven:** ตัดสินใจจากข้อมูล
- **Bottlenecks:** หาจุดที่ควร optimize
- **Comparison:** เปรียบเทียบ
- **Regression:** จับ performance regression

### 9.16.5 ข้อเสีย

- **Context-dependent:** ผลต่างกับ environment
- **Time:** ใช้เวลา
- **Noise:** อาจไม่เสถียร
- **Overhead:** instrument code

### 9.16.6 ข้อควรระวัง

```python
# ระวัง 1: Benchmark ช้า
# ❌ วัดครั้งเดียว
import time
start = time.time()
func()
elapsed = time.time() - start
# ⚠️ noise สูง

# ✅ timeit หรือ pytest-benchmark

# ระวัง 2: วัดสิ่งที่ต้องการจริง
# ❌
def test_bad(benchmark):
    benchmark(lambda: create_data())  # สร้าง data เท่านั้น

def test_good(benchmark):
    data = create_data()  # สร้างนอก benchmark
    benchmark(lambda: process_data(data))

# ระวัง 3: Warm-up
# Python อาจ optimize ในรอบแรก ๆ
# ✅ benchmark tools จัดการให้

# ระวัง 4: GC
# ⚠️ GC อาจกระทบ
# ✅ disable สำหรับ stable benchmark
import gc
gc.disable()
# ... benchmark
gc.enable()

# ระวัง 5: อย่า optimize โดยไม่มีข้อมูล
# ❌
# "นี่น่าจะช้า" → optimize

# ✅ profile ก่อน

# ระวัง 6: Premature optimization
# "Premature optimization is the root of all evil"
# — Donald Knuth

# ระวัง 7: CI benchmarks
# ⚠️ CI environment noisy
# ✅ ใช้ statistical significance
```

### 9.16.7 สรุป

**Tools:**

| Tool | ใช้ |
|------|-----|
| `timeit` | Micro-benchmark |
| `pytest-benchmark` | pytest integration |
| `cProfile` | Profiling |
| `line_profiler` | Line-by-line |
| `memory_profiler` | Memory |

**Best practices:**
- Profile ก่อน optimize
- วัดสิ่งที่ต้องการจริง
- หลาย iterations
- Statistical significance
- CI benchmarks
- ระวัง premature optimization

> **อ้างอิงเพิ่มเติม:** [pytest-benchmark](https://pytest-benchmark.readthedocs.io/)

---

## 9.17 Load Testing

### บทนำ

Load Testing ทดสอบว่าระบบรองรับการใช้งานจริงได้แค่ไหน วัด throughput, latency และ error rate ภายใต้โหลด

### นิยาม

Load Test คือการจำลองผู้ใช้จำนวนมากเข้าใช้งานระบบพร้อมกัน

### 9.17.1 คืออะไร

**Types:**
- **Load testing:** โหลดปกติ
- **Stress testing:** โหลดสูงสุด
- **Soak testing:** โหลดนาน
- **Spike testing:** โหลดพุ่ง

### 9.17.2 ทำงานอย่างไร

Tools:
1. จำลอง virtual users
2. ยิง requests
3. วัด metrics
4. รายงาน

### 9.17.3 การใช้งาน

**Locust:**

```bash
pip install locust
```

```python
# locustfile.py
from locust import HttpUser, task, between


class WebsiteUser(HttpUser):
    wait_time = between(1, 3)  # รอ 1-3 วินาที

    def on_start(self):
        """เรียกเมื่อ user เริ่ม"""
        self.client.post("/login", json={
            "username": "test",
            "password": "test123",
        })

    @task(3)  # น้ำหนัก 3
    def view_homepage(self):
        self.client.get("/")

    @task(2)
    def view_profile(self):
        self.client.get("/profile")

    @task(1)
    def create_post(self):
        self.client.post("/posts", json={
            "title": "Test Post",
            "content": "Test content",
        })


class APIUser(HttpUser):
    host = "https://api.example.com"
    wait_time = between(0.5, 1)

    @task
    def get_users(self):
        self.client.get("/users")

    @task
    def create_user(self):
        self.client.post("/users", json={
            "name": "Test",
            "email": "test@example.com",
        })
```

**รัน Locust:**

```bash
# Web UI
locust -f locustfile.py

# Headless
locust -f locustfile.py \
    --headless \
    -u 100 \
    -r 10 \
    -t 5m \
    --host https://api.example.com

# Output
# -u 100      : 100 users
# -r 10       : spawn rate 10/s
# -t 5m       : run 5 minutes
```

**Metrics:**

```
Type     Name              # reqs   # fails   Avg    Min    Max    Median   req/s
--------|----------------|--------|--------|------|------|------|--------|-------
GET     /                 | 1234   | 0      | 45   | 12   | 500  | 40     | 20.5
POST    /login            | 456    | 2      | 120  | 50   | 800  | 100    | 7.6
GET     /profile          | 789    | 0      | 30   | 10   | 200  | 25     | 13.1
--------|----------------|--------|--------|------|------|------|--------|-------
Total                     | 2479   | 2      | 52   | 10   | 800  | 45     | 41.2
```

**Locustfile แบบละเอียด:**

```python
from locust import HttpUser, task, between, events
from locust.env import Environment
import json


class APIUser(HttpUser):
    wait_time = between(0.5, 2)
    token: str = ""

    def on_start(self):
        """Login และเก็บ token"""
        response = self.client.post("/auth/login", json={
            "username": "load_test_user",
            "password": "password123",
        })
        if response.status_code == 200:
            self.token = response.json()["token"]
            self.client.headers.update({
                "Authorization": f"Bearer {self.token}",
            })

    def on_stop(self):
        """Logout"""
        self.client.post("/auth/logout")

    @task(5)
    def browse_products(self):
        self.client.get("/products")

    @task(3)
    def view_product(self):
        self.client.get("/products/123")

    @task(1)
    def add_to_cart(self):
        self.client.post("/cart", json={
            "product_id": 123,
            "quantity": 1,
        })

    @task(1)
    def checkout(self):
        self.client.post("/checkout", json={
            "payment_method": "credit_card",
        })


@events.test_start.add_listener
def on_test_start(environment, **kwargs):
    print("Load test starting...")


@events.test_stop.add_listener
def on_test_stop(environment, **kwargs):
    print("Load test finished")
```

**Locust with Stages:**

```python
from locust import HttpUser, task, between, LoadTestShape


class StagesShape(LoadTestShape):
    """
    จำลอง:
    1. Ramp up: 0 → 100 users (1 นาที)
    2. Steady: 100 users (3 นาที)
    3. Spike: 100 → 500 users (30 วินาที)
    4. Ramp down: 500 → 0 (30 วินาที)
    """

    stages = [
        {"duration": 60, "users": 100, "spawn_rate": 10},
        {"duration": 240, "users": 100, "spawn_rate": 10},
        {"duration": 270, "users": 500, "spawn_rate": 50},
        {"duration": 300, "users": 0, "spawn_rate": 50},
    ]

    def tick(self):
        run_time = self.get_run_time()

        for stage in self.stages:
            if run_time < stage["duration"]:
                return (stage["users"], stage["spawn_rate"])

        return None
```

**ตัวอย่างการใช้งานจริง — API Load Test:**

```python
# loadtest/api_load.py
from locust import HttpUser, task, between
import random
import string


def random_string(length: int = 10) -> str:
    return "".join(random.choices(string.ascii_lowercase, k=length))


class APIUser(HttpUser):
    wait_time = between(1, 3)
    token: str = ""

    def on_start(self):
        # Register/Login
        username = f"user_{random_string(8)}"
        response = self.client.post("/api/auth/register", json={
            "username": username,
            "email": f"{username}@test.com",
            "password": "TestPass123!",
        })

        if response.status_code == 201:
            self.token = response.json()["token"]
            self.user_id = response.json()["user_id"]
        else:
            # Login if exists
            response = self.client.post("/api/auth/login", json={
                "username": username,
                "password": "TestPass123!",
            })
            self.token = response.json()["token"]
            self.user_id = response.json()["user_id"]

        self.client.headers["Authorization"] = f"Bearer {self.token}"

    @task(5)
    def get_users(self):
        with self.client.get(
            "/api/users",
            catch_response=True,
            name="/api/users [GET]",
        ) as response:
            if response.status_code == 200:
                data = response.json()
                if len(data) > 0:
                    response.success()
                else:
                    response.failure("Empty response")
            else:
                response.failure(f"Status: {response.status_code}")

    @task(3)
    def get_user(self):
        self.client.get(
            f"/api/users/{self.user_id}",
            name="/api/users/[id] [GET]",
        )

    @task(2)
    def update_user(self):
        self.client.patch(
            f"/api/users/{self.user_id}",
            json={"name": random_string()},
            name="/api/users/[id] [PATCH]",
        )

    @task(1)
    def create_post(self):
        self.client.post(
            "/api/posts",
            json={
                "title": f"Post {random_string()}",
                "content": random_string(100),
            },
            name="/api/posts [POST]",
        )
```

**รัน:**

```bash
locust -f loadtest/api_load.py \
    --host=https://staging.example.com \
    --users=200 \
    --spawn-rate=20 \
    --run-time=5m \
    --headless \
    --html=report.html \
    --csv=results
```

**k6:**

```javascript
// k6-script.js
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

const errorRate = new Rate('errors');
const responseTime = new Trend('response_time');

export const options = {
    stages: [
        { duration: '1m', target: 50 },
        { duration: '3m', target: 50 },
        { duration: '1m', target: 100 },
        { duration: '1m', target: 0 },
    ],
    thresholds: {
        http_req_duration: ['p(95)<500'],  // 95% < 500ms
        errors: ['rate<0.01'],  // error rate < 1%
    },
};

export default function () {
    const response = http.get('https://api.example.com/users');

    check(response, {
        'status is 200': (r) => r.status === 200,
        'response time < 500ms': (r) => r.timings.duration < 500,
    });

    errorRate.add(response.status !== 200);
    responseTime.add(response.timings.duration);

    sleep(1);
}
```

### 9.17.4 ข้อดี

- **Realistic:** จำลองจริง
- **Capacity:** รู้ขีดจำกัด
- **Bottlenecks:** หาจุดที่ช้า
- **Scalability:** วางแผนได้

### 9.17.5 ข้อเสีย

- **Resources:** ต้องเครื่องมาก
- **Setup:** ต้อง setup
- **Time:** ใช้เวลา
- **Cost:** อาจมีค่าใช้จ่าย

### 9.17.6 ข้อควรระวัง

```python
# ระวัง 1: Load test production
# ❌ อาจทำให้ล่ม
# ✅ ใช้ staging หรือ off-peak

# ระวัง 2: ไม่ realistic
# ❌ users 10 คน spam requests
# ✅ จำลอง behavior จริง (wait_time)

# ระวัง 3: ไม่มี baseline
# ✅ test ก่อนเปลี่ยนแปลง

# ระวัง 4: Database state
# ⚠️ Load test สร้างข้อมูลเยอะ
# ✅ cleanup หรือใช้ test DB

# ระวัง 5: External dependencies
# ⚠️ Load test อาจกระทบ services อื่น
# ✅ mock external

# ระวัง 6: Metrics ที่สำคัญ
# ✅ latency (p50, p95, p99), throughput, error rate

# ระวัง 7: ไม่ test recovery
# ✅ test หลัง load ลด — ระบบกลับปกติไหม
```

### 9.17.7 สรุป

**Tools:**

| Tool | ใช้ |
|------|-----|
| Locust | Python, flexible |
| k6 | JavaScript, modern |
| JMeter | Java, traditional |
| Artillery | Node.js |

**Metrics:**
- Response time (avg, p50, p95, p99)
- Throughput (req/s)
- Error rate
- Concurrent users

**Best practices:**
- Staging environment
- Realistic scenarios
- Baseline ก่อน
- Ramp up/down
- Monitor resources
- Thresholds

> **อ้างอิงเพิ่มเติม:** [Locust Documentation](https://docs.locust.io/), [k6 Documentation](https://k6.io/docs/)

---

## 9.18 Security Testing

### บทนำ

Security Testing ตรวจหาช่องโหว่ในโค้ดและระบบ เป็นส่วนสำคัญของ SDLC ที่ไม่ควรละเลย

### นิยาม

Security Test คือการทดสอบเพื่อหาช่องโหว่ที่อาจถูกโจมตี

### 9.18.1 คืออะไร

**Types:**
- **SAST:** Static analysis
- **DAST:** Dynamic analysis
- **Dependency scanning**
- **Secret scanning**
- **Penetration testing**

### 9.18.2 ทำงานอย่างไร

Tools:
- `bandit` — SAST สำหรับ Python
- `safety` — dependency scan
- `pip-audit` — vulnerability scan
- OWASP ZAP — DAST

### 9.18.3 การใช้งาน

**Bandit:**

```bash
pip install bandit
```

```bash
# Scan
bandit -r src/

# JSON output
bandit -r src/ -f json -o bandit-report.json

# กำหนด severity
bandit -r src/ -ll  # medium+
bandit -r src/ -lll  # high only

# Config
bandit -r src/ -c pyproject.toml
```

**ตัวอย่างผลลัพธ์:**

```
>> Issue: [B101:assert_used] Use of assert detected.
   Severity: Low   Confidence: High
   Location: src/validation.py:15
```

**Config (pyproject.toml):**

```toml
[tool.bandit]
exclude_dirs = ["tests", "venv"]
skips = ["B101"]  # assert (ใช้ใน tests ได้)

[tool.bandit.assert_used]
skips = ["*/test_*.py"]
```

**pip-audit:**

```bash
pip install pip-audit
```

```bash
# Scan dependencies
pip-audit

# Requirements file
pip-audit -r requirements.txt

# Fix
pip-audit --fix

# JSON
pip-audit --format=json -o audit.json

# Ignore
pip-audit --ignore-vuln GHSA-xxxx
```

**Safety:**

```bash
pip install safety
```

```bash
# Scan
safety check

# Requirements
safety check -r requirements.txt

# JSON
safety check --json

# Policy file
safety check --policy-file .safety-policy.yml
```

**Secret Scanning:**

```bash
pip install detect-secrets
```

```bash
# Scan
detect-secrets scan

# Baseline
detect-secrets scan > .secrets.baseline

# Audit
detect-secrets audit .secrets.baseline

# Hook (pre-commit)
detect-secrets-hook --baseline .secrets.baseline
```

**gitleaks:**

```bash
# ติดตั้ง
brew install gitleaks  # macOS
# หรือ
docker run -v $(pwd):/path zricethezav/gitleaks:latest detect --source="/path"

# Scan git history
gitleaks detect --source=. --verbose

# Scan files
gitleaks protect --staged
```

**Bandit กับ CI:**

```yaml
# .github/workflows/security.yml
name: Security

on: [push, pull_request]

jobs:
  bandit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - run: pip install bandit

      - name: Run Bandit
        run: bandit -r src/ -ll -f json -o bandit-report.json

      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: bandit-report
          path: bandit-report.json

  dependency-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - run: pip install pip-audit

      - name: Run pip-audit
        run: pip-audit --format=json -o audit.json

  secret-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**ตัวอย่างการใช้งานจริง — Secure Code:**

```python
# src/auth.py
import hashlib
import hmac
import secrets
from typing import Optional


def hash_password(password: str, salt: Optional[bytes] = None) -> tuple[str, str]:
    """Hash password อย่างปลอดภัย"""
    if salt is None:
        salt = secrets.token_bytes(32)

    # ✅ ใช้ PBKDF2 (ควรใช้ bcrypt/argon2 ใน production)
    hashed = hashlib.pbkdf2_hmac(
        "sha256",
        password.encode(),
        salt,
        100000,
    )

    return hashed.hex(), salt.hex()


def verify_password(password: str, hashed: str, salt: str) -> bool:
    """ตรวจสอบ password"""
    expected_hash, _ = hash_password(password, bytes.fromhex(salt))
    # ✅ ใช้ constant-time comparison
    return hmac.compare_digest(expected_hash, hashed)


def generate_token() -> str:
    """สร้าง secure token"""
    # ✅ ใช้ secrets
    return secrets.token_urlsafe(32)


# src/db.py
import sqlite3
from typing import Any


def get_user(conn: sqlite3.Connection, user_id: int) -> dict[str, Any] | None:
    # ✅ ใช้ parameterized query
    cursor = conn.execute(
        "SELECT * FROM users WHERE id = ?",
        (user_id,),
    )
    row = cursor.fetchone()
    return dict(row) if row else None


def get_user_bad(conn: sqlite3.Connection, user_id: str) -> dict | None:
    # ❌ SQL Injection!
    cursor = conn.execute(
        f"SELECT * FROM users WHERE id = '{user_id}'"
    )
    row = cursor.fetchone()
    return dict(row) if row else None


# src/api.py
from pathlib import Path


def read_file(filename: str, base_dir: Path) -> str:
    """อ่านไฟล์อย่างปลอดภัย"""
    # ✅ ป้องกัน path traversal
    base = base_dir.resolve()
    target = (base / filename).resolve()

    if not target.is_relative_to(base):
        raise ValueError("Path traversal detected")

    return target.read_text(encoding="utf-8")


def read_file_bad(filename: str) -> str:
    # ❌ Path traversal!
    return open(f"/data/{filename}").read()
```

**Custom Security Test:**

```python
# tests/security/test_security.py
import pytest
from src.auth import hash_password, verify_password, generate_token


class TestPassword:
    def test_hash_not_plaintext(self):
        password = "Secret123!"
        hashed, salt = hash_password(password)
        assert password not in hashed
        assert len(hashed) > 0

    def test_different_salts(self):
        password = "Secret123!"
        hashed1, salt1 = hash_password(password)
        hashed2, salt2 = hash_password(password)
        assert salt1 != salt2
        assert hashed1 != hashed2

    def test_verify(self):
        password = "Secret123!"
        hashed, salt = hash_password(password)
        assert verify_password(password, hashed, salt) is True
        assert verify_password("wrong", hashed, salt) is False


class TestToken:
    def test_uniqueness(self):
        tokens = {generate_token() for _ in range(100)}
        assert len(tokens) == 100

    def test_length(self):
        token = generate_token()
        assert len(token) >= 32


class TestSQLInjection:
    @pytest.mark.parametrize("payload", [
        "1' OR '1'='1",
        "1; DROP TABLE users; --",
        "1' UNION SELECT * FROM passwords --",
    ])
    def test_parameterized_query_safe(self, db, payload):
        # ✅ parameterized — ปลอดภัย
        from src.db import get_user
        result = get_user(db, int("1"))  # int → ไม่มี injection
        assert result is None or isinstance(result, dict)

    @pytest.mark.parametrize("payload", [
        "../../etc/passwd",
        "..\\..\\windows\\system32",
        "/etc/shadow",
    ])
    def test_path_traversal(self, tmp_path, payload):
        from src.api import read_file
        with pytest.raises((ValueError, FileNotFoundError)):
            read_file(payload, tmp_path)
```

### 9.18.4 ข้อดี

- **Proactive:** หาช่องโหว่ก่อน
- **Compliance:** ตาม standards
- **Confidence:** มั่นใจในความปลอดภัย
- **Automated:** รันอัตโนมัติ

### 9.18.5 ข้อเสีย

- **False positives:** อาจรายงานผิด
- **Limited:** ไม่ได้ครอบคลุมทุกอย่าง
- **Time:** ต้อง review
- **Tools:** ต้อง setup

### 9.18.6 ข้อควรระวัง

```python
# ระวัง 1: False positives
# ✅ review ก่อน dismiss
# ✅ ใช้ # nosec comment ถ้า necessary
# bandit: # nosec B101

# ระวัง 2: แค่ scan ไม่พอ
# ✅ ต้อง review code ด้วย
# ✅ security training

# ระวัง 3: Dependencies
# ✅ scan เป็นประจำ
# ✅ update

# ระวัง 4: Secrets ใน git history
# ⚠️ แม้ลบแล้ว history ยังมี
# ✅ ใช้ git-filter-repo หรือ BFG

# ระวัง 5: Configuration
# ⚠️ config ที่ insecure
# ✅ review config

# ระวัง 6: อย่า commit secrets
# ✅ .gitignore
# ✅ .env.example
# ✅ pre-commit hooks

# ระวัง 7: Security ≠ Feature
# ✅ Security ต้องออกแบบตั้งแต่ต้น
```

### 9.18.7 สรุป

**Tools:**

| Tool | ใช้ |
|------|-----|
| `bandit` | SAST |
| `pip-audit` | Dependency scan |
| `safety` | Dependency scan |
| `detect-secrets` | Secret scan |
| `gitleaks` | Secret scan |
| OWASP ZAP | DAST |

**Best practices:**
- Scan ใน CI
- Review findings
- Update dependencies
- ไม่ commit secrets
- Security training
- Defense in depth

> **อ้างอิงเพิ่มเติม:** [Bandit](https://bandit.readthedocs.io/), [pip-audit](https://pypi.org/project/pip-audit/), [OWASP](https://owasp.org/)

---

## 9.19 Property-Based Testing

### บทนำ

Property-Based Testing ทดสอบ properties ที่ควรเป็นจริงสำหรับ inputs ใด ๆ แทนการทดสอบ specific cases

### นิยาม

Property-Based Test คือการทดสอบที่กำหนด properties และให้ tool generate random inputs

### 9.19.1 คืออะไร

**เปรียบเทียบ:**

| Example-Based | Property-Based |
|---------------|----------------|
| `assert add(2,3)==5` | `assert add(a,b)==add(b,a)` |
| Specific cases | Properties |
| Manual | Auto-generated |

### 9.19.2 ทำงานอย่างไร

1. กำหนด property
2. Tool สร้าง random inputs
3. รัน test
4. ถ้า fail → shrink หา minimal case

### 9.19.3 การใช้งาน

**Hypothesis:**

```bash
pip install hypothesis
```

**พื้นฐาน:**

```python
from hypothesis import given, strategies as st


@given(st.integers(), st.integers())
def test_addition_commutative(a, b):
    assert a + b == b + a


@given(st.lists(st.integers()))
def test_sort_idempotent(lst):
    sorted_once = sorted(lst)
    sorted_twice = sorted(sorted_once)
    assert sorted_once == sorted_twice


@given(st.text())
def test_reverse_twice(s):
    assert s[::-1][::-1] == s
```

**Strategies:**

```python
from hypothesis import given, strategies as st


# Integers
@given(st.integers())
def test_int(x): ...

@given(st.integers(min_value=0, max_value=100))
def test_bounded(x): ...

# Floats
@given(st.floats(allow_nan=False, allow_infinity=False))
def test_float(x): ...

# Text
@given(st.text(min_size=1, max_size=10))
def test_text(s): ...

@given(st.text(alphabet="abc"))
def test_alpha(s): ...

# Lists
@given(st.lists(st.integers(), min_size=1))
def test_list(lst): ...

# Dicts
@given(st.dictionaries(st.text(), st.integers()))
def test_dict(d): ...

# Tuples
@given(st.tuples(st.integers(), st.text()))
def test_tuple(t): ...

# Optional
@given(st.none() | st.integers())
def test_optional(x): ...

# One of
@given(st.one_of(st.integers(), st.text()))
def test_one_of(x): ...

# Composite
@st.composite
def user_strategy(draw):
    name = draw(st.text(min_size=1, max_size=50))
    age = draw(st.integers(min_value=0, max_value=150))
    return {"name": name, "age": age}


@given(user_strategy())
def test_user(user):
    assert user["age"] >= 0
```

**Properties ที่ทดสอบบ่อย:**

```python
from hypothesis import given, strategies as st


# Commutativity
@given(st.integers(), st.integers())
def test_add_commutative(a, b):
    assert a + b == b + a


# Associativity
@given(st.integers(), st.integers(), st.integers())
def test_add_associative(a, b, c):
    assert (a + b) + c == a + (b + c)


# Identity
@given(st.integers())
def test_add_identity(a):
    assert a + 0 == a


# Inverse
@given(st.integers())
def test_encode_decode(s):
    assert decode(encode(s)) == s


# Idempotence
@given(st.lists(st.integers()))
def test_sort_idempotent(lst):
    assert sorted(sorted(lst)) == sorted(lst)


# Invariant
@given(st.lists(st.integers()))
def test_sort_preserves_length(lst):
    assert len(sorted(lst)) == len(lst)


# Oracle
@given(st.lists(st.integers()))
def test_my_sort(lst):
    assert my_sort(lst) == sorted(lst)  # เทียบกับ reference
```

**Shrinking:**

```python
from hypothesis import given, strategies as st


@given(st.lists(st.integers()))
def test_sum_positive(lst):
    # ❌ property ผิด
    assert sum(lst) > 0
```

**Output:**

```
Falsifying example: test_sum_positive(lst=[])
# Hypothesis พบ minimal case: list ว่าง
```

**Assume:**

```python
from hypothesis import given, assume, strategies as st


@given(st.integers(), st.integers())
def test_division(a, b):
    assume(b != 0)  # ข้ามถ้า b == 0
    assert (a / b) * b == pytest.approx(a)
```

**Settings:**

```python
from hypothesis import given, settings, strategies as st


@settings(max_examples=1000, deadline=None)
@given(st.lists(st.integers()))
def test_slow(lst):
    result = slow_function(lst)
    assert result is not None
```

**ตัวอย่างการใช้งานจริง — Data Structure:**

```python
# src/stack.py
from typing import Generic, TypeVar, Optional

T = TypeVar("T")


class Stack(Generic[T]):
    def __init__(self):
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        if not self._items:
            raise IndexError("empty")
        return self._items.pop()

    def peek(self) -> T:
        if not self._items:
            raise IndexError("empty")
        return self._items[-1]

    def __len__(self) -> int:
        return len(self._items)

    def is_empty(self) -> bool:
        return len(self._items) == 0


# tests/test_stack_properties.py
from hypothesis import given, strategies as st, assume
from src.stack import Stack
import pytest


class TestStackProperties:
    @given(st.lists(st.integers()))
    def test_push_pop_lifo(self, items):
        """Property: LIFO order"""
        stack = Stack()
        for item in items:
            stack.push(item)

        popped = []
        while not stack.is_empty():
            popped.append(stack.pop())

        assert popped == list(reversed(items))

    @given(st.lists(st.integers()))
    def test_length_invariant(self, items):
        """Property: len ตรงกับจำนวนที่ push"""
        stack = Stack()
        for i, item in enumerate(items):
            stack.push(item)
            assert len(stack) == i + 1

    @given(st.integers())
    def test_peek_after_push(self, item):
        """Property: peek คืน item ล่าสุด"""
        stack = Stack()
        stack.push(item)
        assert stack.peek() == item

    @given(st.lists(st.integers(), min_size=1))
    def test_peek_doesnt_change(self, items):
        """Property: peek ไม่เปลี่ยน state"""
        stack = Stack()
        for item in items:
            stack.push(item)

        initial_len = len(stack)
        initial_peek = stack.peek()

        stack.peek()

        assert len(stack) == initial_len
        assert stack.peek() == initial_peek

    def test_pop_empty_raises(self):
        """Empty stack raises"""
        stack = Stack()
        with pytest.raises(IndexError):
            stack.pop()


# tests/test_encoding.py
from hypothesis import given, strategies as st


def encode(text: str) -> bytes:
    return text.encode("utf-8")


def decode(data: bytes) -> str:
    return data.decode("utf-8")


class TestEncodingProperties:
    @given(st.text())
    def test_roundtrip(self, text):
        """Property: decode(encode(s)) == s"""
        assert decode(encode(text)) == text

    @given(st.text())
    def test_encode_type(self, text):
        """Property: encode returns bytes"""
        assert isinstance(encode(text), bytes)

    @given(st.binary())
    def test_bytes_roundtrip(self, data):
        """Property: encode(decode(b)) == b สำหรับ valid UTF-8"""
        try:
            text = decode(data)
        except UnicodeDecodeError:
            assume(False)  # ข้าม invalid UTF-8

        assert encode(text) == data
```

**ตัวอย่าง — Sort:**

```python
# tests/test_sort_properties.py
from hypothesis import given, strategies as st


def my_sort(lst: list[int]) -> list[int]:
    """Bubble sort (ช้าแต่ถูกต้อง)"""
    result = lst.copy()
    n = len(result)
    for i in range(n):
        for j in range(n - i - 1):
            if result[j] > result[j + 1]:
                result[j], result[j + 1] = result[j + 1], result[j]
    return result


class TestSortProperties:
    @given(st.lists(st.integers()))
    def test_length_preserved(self, lst):
        """Property: ความยาวเท่าเดิม"""
        assert len(my_sort(lst)) == len(lst)

    @given(st.lists(st.integers()))
    def test_sorted_order(self, lst):
        """Property: เรียงจากน้อยไปมาก"""
        result = my_sort(lst)
        for i in range(len(result) - 1):
            assert result[i] <= result[i + 1]

    @given(st.lists(st.integers()))
    def test_permutation(self, lst):
        """Property: elements เดิม"""
        assert sorted(my_sort(lst)) == sorted(lst)

    @given(st.lists(st.integers()))
    def test_idempotent(self, lst):
        """Property: sort ซ้ำได้ผลเดิม"""
        once = my_sort(lst)
        twice = my_sort(once)
        assert once == twice

    @given(st.lists(st.integers()))
    def test_matches_builtin(self, lst):
        """Property: ตรงกับ sorted()"""
        assert my_sort(lst) == sorted(lst)
```

### 9.19.4 ข้อดี

- **Coverage:** cases ที่ไม่คิดถึง
- **Edge cases:** พบอัตโนมัติ
- **Shrinking:** minimal case
- **Properties:** ทดสอบ invariants
- **Confidence:** มั่นใจกว่า

### 9.19.5 ข้อเสีย

- **Learning:** ต้องเข้าใจ properties
- **Setup:** ต้องตั้งค่า
- **Chance:** อาจไม่เจอทุกอย่าง
- **Time:** อาจช้า

### 9.19.6 ข้อควรระวัง

```python
# ระวัง 1: Property ที่ไม่จริง
@given(st.integers())
def test_bad(x):
    assert x > 0  # ❌ ไม่จริง

# ระวัง 2: assume มากเกินไป
@given(st.integers())
def test_bad2(x):
    assume(x > 0)  # ทิ้งค่าลบ
    assume(x < 100)  # ทิ้งค่ามาก
    assert x > 0  # trivial

# ✅ ใช้ strategy ที่จำกัด
@given(st.integers(min_value=1, max_value=99))
def test_good(x):
    assert x > 0

# ระวัง 3: ไม่ deterministic
@given(st.integers())
def test_bad3(x):
    assert random.random() > 0.5  # ❌ flaky

# ระวัง 4: Slow tests
@settings(max_examples=10000)  # ⚠️ ช้า
@given(st.lists(st.integers()))
def test_slow(lst): ...

# ระวัง 5: Database/API ใน property test
# ❌ ช้าและไม่ deterministic
@given(st.text())
def test_api(s):
    requests.post(url, json={"text": s})  # ❌

# ระวัง 6: Composite ที่ซับซ้อน
# ✅ เริ่มง่าย ๆ

# ระวัง 7: Ignore ตัวอย่างที่ fail
# ❌
@example(x=0)  # skip
@given(st.integers())
def test(x):
    ...
# ✅ แก้โค้ด ไม่ใช่ ignore
```

### 9.19.7 สรุป

**Hypothesis:**

| Element | ใช้ |
|---------|-----|
| `@given` | กำหนด inputs |
| `st.integers()` | Strategies |
| `assume()` | กรอง |
| `@settings` | Config |
| `@example` | Specific cases |

**Properties:**
- Commutativity
- Associativity
- Identity
- Inverse
- Idempotence
- Invariant
- Oracle

**Best practices:**
- เริ่มจาก properties ง่าย ๆ
- ใช้ `assume` น้อย
- Strategies ที่เหมาะ
- Limit examples สำหรับ slow tests
- ใช้ `@example` สำหรับ edge cases

> **อ้างอิงเพิ่มเติม:** [Hypothesis Documentation](https://hypothesis.readthedocs.io/)

---

## 9.20 Hypothesis

### บทนำ

Hypothesis เป็น library สำหรับ Property-Based Testing ที่ทรงพลังที่สุดใน Python

### นิยาม

Hypothesis เป็น Python library ที่ implement Property-Based Testing

### 9.20.1 คืออะไร

**Features:**
- Strategies library
- Shrinking
- Database ของ failures
- Integration กับ pytest
- Stateful testing

### 9.20.2 ทำงานอย่างไร

1. Generate random inputs
2. รัน test
3. ถ้า pass → ลอง inputs ใหม่
4. ถ้า fail → shrink และ report

### 9.20.3 การใช้งาน

**Strategies:**

```python
from hypothesis import given, strategies as st

# Numbers
st.integers()
st.integers(min_value=0, max_value=100)
st.floats()
st.floats(allow_nan=False, allow_infinity=False)
st.decimals()
st.fractions()

# Text
st.text()
st.text(alphabet="abc")
st.characters()
st.from_regex(r"\d{3}-\d{4}")

# Collections
st.lists(st.integers())
st.sets(st.integers())
st.frozensets(st.integers())
st.dictionaries(st.text(), st.integers())
st.tuples(st.integers(), st.text())

# Dates
st.dates()
st.times()
st.datetimes()
st.timedeltas()

# Special
st.none()
st.booleans()
st.uuids()
st.emails()
st.urls()

# Combinators
st.one_of(st.integers(), st.text())
st.optional(st.integers())  # None หรือ int
st.sampled_from([1, 2, 3])
st.permutations([1, 2, 3])
st.recursive(st.integers(), lambda x: st.lists(x))
```

**Composite Strategies:**

```python
from hypothesis import given, strategies as st
from dataclasses import dataclass


@dataclass
class User:
    id: int
    name: str
    email: str
    age: int


@st.composite
def user_strategy(draw):
    user_id = draw(st.integers(min_value=1))
    name = draw(st.text(
        min_size=1,
        max_size=50,
        alphabet=st.characters(whitelist_categories=("L",)),
    ))
    email = draw(st.emails())
    age = draw(st.integers(min_value=0, max_value=150))

    return User(user_id, name, email, age)


@given(user_strategy())
def test_user_creation(user):
    assert user.id > 0
    assert len(user.name) >= 1
    assert "@" in user.email
    assert 0 <= user.age <= 150
```

**Stateful Testing:**

```python
from hypothesis import given, strategies as st
from hypothesis.stateful import (
    RuleBasedStateMachine,
    rule,
    initialize,
    precondition,
    invariant,
)


class Database:
    def __init__(self):
        self._data: dict[str, str] = {}

    def set(self, key: str, value: str) -> None:
        self._data[key] = value

    def get(self, key: str) -> str | None:
        return self._data.get(key)

    def delete(self, key: str) -> bool:
        return self._data.pop(key, None) is not None

    def keys(self) -> list[str]:
        return list(self._data.keys())


class DatabaseStateMachine(RuleBasedStateMachine):
    """
    Stateful test — ทดสอบ sequence ของ operations
    """

    def __init__(self):
        super().__init__()
        self.db = Database()
        self.model: dict[str, str] = {}  # reference model

    @rule(key=st.text(), value=st.text())
    def set_value(self, key: str, value: str):
        self.db.set(key, value)
        self.model[key] = value

    @rule(key=st.text())
    def delete_value(self, key: str):
        result = self.db.delete(key)
        expected = key in self.model

        if expected:
            del self.model[key]

        assert result == expected

    @rule(key=st.text())
    def get_value(self, key: str):
        result = self.db.get(key)
        expected = self.model.get(key)
        assert result == expected

    @invariant()
    def keys_match(self):
        assert sorted(self.db.keys()) == sorted(self.model.keys())


TestDatabase = DatabaseStateMachine.TestCase
```

**Settings:**

```python
from hypothesis import given, settings, strategies as st
from hypothesis import HealthCheck


@settings(
    max_examples=500,
    deadline=1000,  # ms
    suppress_health_check=[
        HealthCheck.too_slow,
    ],
)
@given(st.lists(st.integers()))
def test_slow(lst):
    ...


# Profile
from hypothesis import settings, Phase

settings.register_profile(
    "ci",
    max_examples=1000,
    deadline=None,
)
settings.register_profile(
    "dev",
    max_examples=100,
    deadline=1000,
)

# ใช้งาน
settings.load_profile("dev")
```

**Database:**

```python
# Hypothesis เก็บ failures ใน .hypothesis/
# รันซ้ำได้
```

**pytest Integration:**

```python
# conftest.py
from hypothesis import settings, Verbosity

settings.register_profile(
    "default",
    max_examples=100,
    verbosity=Verbosity.normal,
)

settings.register_profile(
    "ci",
    max_examples=1000,
    verbosity=Verbosity.normal,
)

# รัน
# pytest --hypothesis-profile=ci
```

**ตัวอย่างการใช้งานจริง — API Model:**

```python
# tests/test_api_properties.py
from hypothesis import given, strategies as st, settings
from dataclasses import dataclass
import json


@dataclass
class Product:
    id: int
    name: str
    price: float
    quantity: int


@st.composite
def product_strategy(draw):
    return Product(
        id=draw(st.integers(min_value=1)),
        name=draw(st.text(min_size=1, max_size=100)),
        price=draw(st.floats(
            min_value=0.01,
            max_value=999999.99,
            allow_nan=False,
            allow_infinity=False,
        )),
        quantity=draw(st.integers(min_value=0, max_value=10000)),
    )


class TestProductSerialization:
    @given(product_strategy())
    def test_json_roundtrip(self, product):
        """Property: JSON serialization roundtrip"""
        data = {
            "id": product.id,
            "name": product.name,
            "price": product.price,
            "quantity": product.quantity,
        }

        serialized = json.dumps(data)
        deserialized = json.loads(serialized)

        assert deserialized["id"] == product.id
        assert deserialized["name"] == product.name
        assert deserialized["price"] == product.price
        assert deserialized["quantity"] == product.quantity

    @given(product_strategy())
    def test_total_price(self, product):
        """Property: total = price * quantity"""
        total = product.price * product.quantity
        assert total == product.price * product.quantity
        assert total >= 0


# tests/test_parsers.py
from hypothesis import given, strategies as st
from src.parsers import parse_date, format_date


class TestDateParser:
    @given(st.dates())
    def test_roundtrip(self, date):
        """Property: parse(format(d)) == d"""
        formatted = format_date(date)
        parsed = parse_date(formatted)
        assert parsed == date

    @given(st.dates(min_value=date(1970, 1, 1)))
    def test_format_length(self, date):
        """Property: format ได้ YYYY-MM-DD"""
        formatted = format_date(date)
        assert len(formatted) == 10
        assert formatted[4] == "-"
        assert formatted[7] == "-"


# tests/test_calculator_properties.py
from hypothesis import given, strategies as st, assume
from decimal import Decimal


@given(
    st.decimals(
        min_value=Decimal("0.01"),
        max_value=Decimal("1000000"),
        allow_nan=False,
        allow_infinity=False,
    )
)
def test_tax_calculation(amount):
    """Property: tax = amount * 0.07"""
    from src.tax import calculate_tax

    result = calculate_tax(amount)
    expected = amount * Decimal("0.07")

    assert abs(result - expected) < Decimal("0.01")


@given(
    st.decimals(min_value=Decimal("0")),
    st.decimals(min_value=Decimal("0")),
)
def test_addition_commutative(a, b):
    assert a + b == b + a
```

### 9.20.4 ข้อดี

- **Powerful:** Strategies ครบ
- **Shrinking:** Minimal cases
- **Stateful:** ทดสอบ sequences
- **Integration:** กับ pytest
- **Database:** เก็บ failures

### 9.20.5 ข้อเสีย

- **Learning curve:** ต้องเข้าใจ
- **Time:** อาจช้า
- **Random:** ไม่ deterministic
- **False positives:** properties ผิด

### 9.20.6 ข้อควรระวัง

```python
# ระวัง 1: Properties ที่ไม่จริง
# ❌
@given(st.integers())
def test_bad(x):
    assert x > 0  # ไม่จริง

# ระวัง 2: assume มากเกินไป
# ❌
@given(st.integers())
def test_bad2(x):
    assume(x > 0)
    assume(x < 10)
    assume(x % 2 == 0)
    # เหลือ few cases

# ✅ ใช้ strategy
@given(st.integers(min_value=2, max_value=8).filter(lambda x: x % 2 == 0))
def test_good(x): ...

# ระวัง 3: Slow strategies
# ❌
@given(st.lists(st.text(), min_size=10000))
def test_slow(lst): ...

# ระวัง 4: Database/network
# ✅ mock

# ระวัง 5: Deadline
# CI อาจช้า
@settings(deadline=None)  # ปิด deadline

# ระวัง 6: Health checks
# suppress เฉพาะที่จำเป็น
@settings(suppress_health_check=[HealthCheck.too_slow])

# ระวัง 7: Profile ใน CI
# ✅ ใช้ profile ที่เหมาะ
```

### 9.20.7 สรุป

**Core:**

| Element | ใช้ |
|---------|-----|
| `@given` | Inputs |
| `st.*` | Strategies |
| `@st.composite` | Custom strategies |
| `@settings` | Config |
| `RuleBasedStateMachine` | Stateful |

**Profiles:**
- `default`: 100 examples
- `ci`: 1000 examples
- `dev`: fewer examples

**Best practices:**
- Properties ที่ meaningful
- ใช้ strategies แทน assume
- Settings ที่เหมาะ
- Database สำหรับ CI
- Stateful สำหรับ complex
- Profile ตาม environment

> **อ้างอิงเพิ่มเติม:** [Hypothesis Documentation](https://hypothesis.readthedocs.io/)

---

## 9.21 Behavior-Driven Development

### บทนำ

Behavior-Driven Development (BDD) เป็นแนวทางที่เน้น collaboration ระหว่าง developers, QA และ business ใช้ภาษาใกล้เคียงธุรกิจ

### นิยาม

BDD คือ development approach ที่ใช้ Given-When-Then scenarios อธิบาย behavior

### 9.21.1 คืออะไร

**Given-When-Then:**
- **Given:** สถานะเริ่มต้น
- **When:** การกระทำ
- **Then:** ผลลัพธ์ที่คาดหวัง

### 9.21.2 ทำงานอย่างไร

1. เขียน scenarios ใน `.feature` files
2. Implement steps
3. รัน tests

### 9.21.3 การใช้งาน

**Gherkin Syntax:**

```gherkin
# features/login.feature
Feature: User Login
  As a user
  I want to log in
  So that I can access my account

  Scenario: Successful login
    Given I am on the login page
    When I enter valid credentials
    And I click the login button
    Then I should be redirected to the dashboard
    And I should see a welcome message

  Scenario: Failed login
    Given I am on the login page
    When I enter invalid credentials
    And I click the login button
    Then I should see an error message
    And I should remain on the login page

  Scenario Outline: Login with different roles
    Given I am on the login page
    When I login as "<role>" with password "<password>"
    Then I should have access to "<feature>"

    Examples:
      | role   | password  | feature      |
      | admin  | admin123  | user_manage  |
      | user   | user123   | profile      |
      | guest  | guest123  | public_pages |
```

**behave:**

```bash
pip install behave
```

**features/steps/login_steps.py:**

```python
from behave import given, when, then
from selenium import webdriver


@given("I am on the login page")
def step_on_login_page(context):
    context.driver = webdriver.Chrome()
    context.driver.get("https://app.example.com/login")


@when("I enter valid credentials")
def step_enter_valid_credentials(context):
    context.driver.find_element("id", "username").send_keys("testuser")
    context.driver.find_element("id", "password").send_keys("testpass")


@when("I enter invalid credentials")
def step_enter_invalid_credentials(context):
    context.driver.find_element("id", "username").send_keys("testuser")
    context.driver.find_element("id", "password").send_keys("wrongpass")


@when("I click the login button")
def step_click_login(context):
    context.driver.find_element("css selector", "button[type=submit]").click()


@then("I should be redirected to the dashboard")
def step_redirected_to_dashboard(context):
    assert "/dashboard" in context.driver.current_url


@then("I should see a welcome message")
def step_see_welcome(context):
    element = context.driver.find_element("css selector", ".welcome")
    assert "Welcome" in element.text


@then("I should see an error message")
def step_see_error(context):
    element = context.driver.find_element("css selector", ".error")
    assert element.is_displayed()


@then("I should remain on the login page")
def step_remain_on_login(context):
    assert "/login" in context.driver.current_url
```

**pytest-bdd:**

```bash
pip install pytest-bdd
```

**features/calculator.feature:**

```gherkin
Feature: Calculator
  As a user
  I want to perform calculations
  So that I can solve math problems

  Scenario: Addition
    Given a calculator
    When I add 2 and 3
    Then the result should be 5

  Scenario: Division by zero
    Given a calculator
    When I divide 10 by 0
    Then I should get an error "division by zero"
```

**tests/test_calculator_bdd.py:**

```python
import pytest
from pytest_bdd import scenarios, given, when, then, parsers


# Link feature file
scenarios("features/calculator.feature")


@pytest.fixture
def calculator():
    from src.calculator import Calculator
    return Calculator()


@given("a calculator", target_fixture="calc")
def calc(calculator):
    return calculator


@when(parsers.parse("I add {a:d} and {b:d}"))
def add_numbers(calc, a, b):
    calc.result = calc.add(a, b)


@when(parsers.parse("I divide {a:d} by {b:d}"))
def divide_numbers(calc, a, b):
    try:
        calc.result = calc.divide(a, b)
        calc.error = None
    except ZeroDivisionError as e:
        calc.error = str(e)


@then(parsers.parse("the result should be {expected:d}"))
def check_result(calc, expected):
    assert calc.result == expected


@then(parsers.parse('I should get an error "{message}"'))
def check_error(calc, message):
    assert calc.error == message
```

**ตัวอย่างการใช้งานจริง — E-commerce:**

```gherkin
# features/cart.feature
Feature: Shopping Cart
  As a customer
  I want to manage my shopping cart
  So that I can buy products

  Background:
    Given an empty cart
    And the following products exist:
      | id | name     | price | stock |
      | 1  | Laptop   | 35000 | 10    |
      | 2  | Mouse    | 850   | 50    |
      | 3  | Keyboard | 2500  | 5     |

  Scenario: Add product to cart
    When I add product "1" with quantity 1
    Then the cart should contain 1 item
    And the cart total should be 35000

  Scenario: Add multiple products
    When I add product "1" with quantity 1
    And I add product "2" with quantity 2
    Then the cart should contain 3 items
    And the cart total should be 36700

  Scenario: Remove product
    Given I add product "1" with quantity 1
    And I add product "2" with quantity 2
    When I remove product "1"
    Then the cart should contain 2 items
    And the cart total should be 1700

  Scenario: Cannot add more than stock
    When I try to add product "3" with quantity 10
    Then I should get error "insufficient stock"

  Scenario: Empty cart after checkout
    Given I add product "1" with quantity 1
    When I checkout
    Then the cart should be empty
```

**steps/cart_steps.py:**

```python
from behave import given, when, then
from src.cart import Cart, Product, InsufficientStockError


@given("an empty cart")
def step_empty_cart(context):
    context.cart = Cart()
    context.products = {}


@given("the following products exist:")
def step_products_exist(context):
    for row in context.table:
        product = Product(
            id=int(row["id"]),
            name=row["name"],
            price=float(row["price"]),
            stock=int(row["stock"]),
        )
        context.products[product.id] = product


@when('I add product "{product_id}" with quantity {qty:d}')
def step_add_product(context, product_id, qty):
    product = context.products[int(product_id)]
    context.cart.add(product, qty)


@when('I try to add product "{product_id}" with quantity {qty:d}')
def step_try_add_product(context, product_id, qty):
    product = context.products[int(product_id)]
    try:
        context.cart.add(product, qty)
        context.error = None
    except InsufficientStockError as e:
        context.error = str(e)


@when('I remove product "{product_id}"')
def step_remove_product(context, product_id):
    context.cart.remove(int(product_id))


@when("I checkout")
def step_checkout(context):
    context.cart.checkout()


@then("the cart should contain {count:d} items")
def step_check_count(context, count):
    assert context.cart.item_count() == count


@then("the cart total should be {total:g}")
def step_check_total(context, total):
    assert context.cart.total() == total


@then('I should get error "{message}"')
def step_check_error(context, message):
    assert context.error == message


@then("the cart should be empty")
def step_check_empty(context):
    assert context.cart.is_empty()
```

### 9.21.4 ข้อดี

- **Collaboration:** ทีมเข้าใจตรงกัน
- **Documentation:** Scenarios เป็น docs
- **Readable:** ภาษาธุรกิจ
- **Living docs:** อัปเดตอัตโนมัติ
- **Coverage:** ครอบคลุม behavior

### 9.21.5 ข้อเสีย

- **Overhead:** Setup
- **Maintenance:** features ต้องดูแล
- **Learning:** ต้องเข้าใจ
- **May be slow:** ถ้า UI tests
- **Overkill:** สำหรับ projects เล็ก

### 9.21.6 ข้อควรระวัง

```python
# ระวัง 1: Scenarios ที่ procedural
# ❌
Scenario: Test login
  Given I go to page
  When I click #username
  And I type "test"
  # ... low-level

# ✅
Scenario: User logs in
  Given a registered user
  When they log in with valid credentials
  Then they see the dashboard

# ระวัง 2: ขาด business value
# ❌ scenarios ที่ test technical details
# ✅ focus ที่ behavior

# ระวัง 3: Steps ซ้ำ
# ✅ ใช้ Background หรือ reusable steps

# ระวัง 4: Scenarios เยอะเกินไป
# ✅ focus ที่ critical paths

# ระวัง 5: Slow tests
# ❌ UI tests สำหรับทุกอย่าง
# ✅ unit tests สำหรับ logic, BDD สำหรับ workflows

# ระวัง 6: Maintenance
# ✅ ใช้ Page Objects
# ✅ separate concerns

# ระวัง 7: Language
# ✅ ใช้ภาษาที่ทีมเข้าใจ
# ✅ consistent terminology
```

### 9.21.7 สรุป

**Given-When-Then:**
- **Given:** Setup
- **When:** Action
- **Then:** Assertion

**Tools:**

| Tool | ใช้ |
|------|-----|
| behave | BDD framework |
| pytest-bdd | pytest integration |
| radish | Alternative |

**Best practices:**
- Focus business behavior
- หลีกเลี่ยง procedural steps
- Reusable steps
- Background สำหรับ common setup
- Scenario Outline สำหรับ variations
- Page Objects สำหรับ UI

> **อ้างอิงเพิ่มเติม:** [behave](https://behave.readthedocs.io/), [pytest-bdd](https://pytest-bdd.readthedocs.io/)

---

## 9.22 behave

### บทนำ

`behave` เป็น BDD framework ที่ใช้ Gherkin syntax เขียน scenarios เป็น `.feature` files

### นิยาม

behave เป็น Python BDD framework ที่ implement Gherkin

### 9.22.1 คืออะไร

**Structure:**

```
project/
├── features/
│   ├── login.feature
│   ├── steps/
│   │   └── login_steps.py
│   └── environment.py
```

### 9.22.2 ทำงานอย่างไร

1. อ่าน `.feature` files
2. จับคู่ steps กับ Python functions
3. รันตามลำดับ

### 9.22.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install behave
```

**Feature file:**

```gherkin
# features/calculator.feature
Feature: Calculator
  Simple calculator

  Scenario: Add two numbers
    Given I have a calculator
    When I add 2 and 3
    Then the result should be 5

  Scenario: Divide by zero
    Given I have a calculator
    When I divide 10 by 0
    Then I should see error "division by zero"
```

**Steps:**

```python
# features/steps/calculator_steps.py
from behave import given, when, then


@given("I have a calculator")
def step_have_calculator(context):
    from src.calculator import Calculator
    context.calc = Calculator()


@when("I add {a:d} and {b:d}")
def step_add(context, a, b):
    context.result = context.calc.add(a, b)


@when("I divide {a:d} by {b:d}")
def step_divide(context, a, b):
    try:
        context.result = context.calc.divide(a, b)
        context.error = None
    except ZeroDivisionError as e:
        context.error = str(e)


@then("the result should be {expected:d}")
def step_check_result(context, expected):
    assert context.result == expected


@then('I should see error "{message}"')
def step_check_error(context, message):
    assert context.error == message
```

**environment.py:**

```python
# features/environment.py
from selenium import webdriver
from src.app import create_app


def before_all(context):
    """เรียกครั้งเดียวก่อนทุก feature"""
    context.app = create_app(testing=True)


def before_feature(context, feature):
    """เรียกก่อนแต่ละ feature"""
    print(f"Starting feature: {feature.name}")


def before_scenario(context, scenario):
    """เรียกก่อนแต่ละ scenario"""
    context.db = create_test_db()


def after_scenario(context, scenario):
    """เรียกหลังแต่ละ scenario"""
    context.db.rollback()
    context.db.close()


def after_feature(context, feature):
    """เรียกหลังแต่ละ feature"""
    print(f"Finished: {feature.name}")


def after_all(context):
    """เรียกครั้งเดียวหลังทุก feature"""
    context.app.cleanup()


def before_step(context, step):
    """เรียกก่อนแต่ละ step"""
    context.step_start = time.time()
```

**Scenario Outline:**

```gherkin
Scenario Outline: Calculator operations
  Given I have a calculator
  When I <operation> <a> and <b>
  Then the result should be <expected>

  Examples:
    | operation | a  | b | expected |
    | add       | 2  | 3 | 5        |
    | add       | 0  | 0 | 0        |
    | subtract  | 5  | 3 | 2        |
    | multiply  | 4  | 5 | 20       |
```

```python
@when("I {operation} {a:d} and {b:d}")
def step_operation(context, operation, a, b):
    ops = {
        "add": context.calc.add,
        "subtract": context.calc.subtract,
        "multiply": context.calc.multiply,
    }
    context.result = ops[operation](a, b)
```

**Tables:**

```gherkin
Scenario: Add multiple products
  Given the following products:
    | name     | price | qty |
    | Laptop   | 35000 | 1   |
    | Mouse    | 850   | 2   |
  When I calculate the total
  Then the total should be 36700
```

```python
@given("the following products:")
def step_products(context):
    context.products = []
    for row in context.table:
        context.products.append({
            "name": row["name"],
            "price": float(row["price"]),
            "qty": int(row["qty"]),
        })


@when("I calculate the total")
def step_calculate_total(context):
    context.total = sum(
        p["price"] * p["qty"] for p in context.products
    )


@then("the total should be {expected:g}")
def step_check_total(context, expected):
    assert context.total == expected
```

**Tags:**

```gherkin
@smoke
Feature: Login

  @fast
  Scenario: Valid login
    ...

  @slow @integration
  Scenario: Login with 2FA
    ...
```

```bash
# รันเฉพาะ tag
behave --tags=@smoke
behave --tags=@fast
behave --tags=@smoke --tags=@fast
behave --tags=@smoke,@fast  # OR
behave --tags=-@slow  # NOT
```

```python
# environment.py
def before_scenario(context, scenario):
    if "slow" in scenario.tags:
        context.timeout = 60
    else:
        context.timeout = 10
```

**Run:**

```bash
# รันทั้งหมด
behave

# Feature เดียว
behave features/login.feature

# Tags
behave --tags=@smoke

# Format
behave -f json -o report.json
behave -f html -o report.html

# Parallel
behave -j 4  # ต้อง behave-parallel

# Verbose
behave -v
```

**ตัวอย่างการใช้งานจริง — Todo App:**

```gherkin
# features/todo.feature
Feature: Todo List
  Manage personal tasks

  Background:
    Given an empty todo list

  Scenario: Add a task
    When I add task "Buy groceries"
    Then the list should have 1 task
    And task 1 should be "Buy groceries"
    And task 1 should be incomplete

  Scenario: Complete a task
    Given I add task "Buy groceries"
    When I complete task 1
    Then task 1 should be complete

  Scenario: Remove a task
    Given I add task "Buy groceries"
    And I add task "Walk the dog"
    When I remove task 1
    Then the list should have 1 task
    And task 1 should be "Walk the dog"

  Scenario: Cannot add empty task
    When I try to add task ""
    Then I should get error "Task cannot be empty"

  Scenario Outline: Add multiple tasks
    When I add tasks "<tasks>"
    Then the list should have <count> tasks

    Examples:
      | tasks                    | count |
      | Buy groceries            | 1     |
      | Task 1, Task 2           | 2     |
      | A, B, C, D               | 4     |
```

```python
# features/steps/todo_steps.py
from behave import given, when, then
from src.todo import TodoList, ValidationError


@given("an empty todo list")
def step_empty_list(context):
    context.todo = TodoList()


@when('I add task "{description}"')
def step_add_task(context, description):
    context.todo.add(description)


@when('I add tasks "{tasks}"')
def step_add_tasks(context, tasks):
    for task in tasks.split(","):
        context.todo.add(task.strip())


@when('I try to add task "{description}"')
def step_try_add_task(context, description):
    try:
        context.todo.add(description)
        context.error = None
    except ValidationError as e:
        context.error = str(e)


@when("I complete task {index:d}")
def step_complete(context, index):
    context.todo.complete(index - 1)


@when("I remove task {index:d}")
def step_remove(context, index):
    context.todo.remove(index - 1)


@then("the list should have {count:d} tasks")
def step_check_count(context, count):
    assert len(context.todo) == count


@then('task {index:d} should be "{description}"')
def step_check_task(context, index, description):
    assert context.todo[index - 1].description == description


@then("task {index:d} should be complete")
def step_check_complete(context, index):
    assert context.todo[index - 1].completed is True


@then("task {index:d} should be incomplete")
def step_check_incomplete(context, index):
    assert context.todo[index - 1].completed is False


@then('I should get error "{message}"')
def step_check_error(context, message):
    assert context.error == message
```

### 9.22.4 ข้อดี

- **Readable:** Gherkin ชัดเจน
- **Collaboration:** ทีมเข้าใจ
- **Organization:** features/steps
- **Tags:** จัดกลุ่ม
- **Hooks:** environment.py

### 9.22.5 ข้อเสีย

- **Setup:** ต้องตั้งค่า
- **Verbose:** features ยาว
- **Maintenance:** ต้องดูแล
- **Slow:** ถ้า UI

### 9.22.6 ข้อควรระวัง

```python
# ระวัง 1: Steps ที่ผูกกับ implementation
# ❌
When I click the button with id "submit-btn"

# ✅
When I submit the form

# ระวัง 2: Steps ซ้ำ
# ✅ ใช้ common steps

# ระวัง 3: State ระหว่าง scenarios
# ❌
context.user = create_user()  # ใน before_all
# ✅ before_scenario

# ระวัง 4: Hard-coded values
# ✅ ใช้ Scenario Outline

# ระวัง 5: Slow tests
# ✅ แยก unit tests

# ระวัง 6: Cleanup
def after_scenario(context, scenario):
    # ✅ cleanup resources
    if hasattr(context, "driver"):
        context.driver.quit()

# ระวัง 7: Tags
# ✅ ใช้ tags ให้เป็นระบบ
```

### 9.22.7 สรุป

**Structure:**

```
features/
├── *.feature
├── steps/
│   └── *_steps.py
└── environment.py
```

**Commands:**

```bash
behave
behave features/login.feature
behave --tags=@smoke
behave -f json -o report.json
```

**Hooks:**
- `before_all` / `after_all`
- `before_feature` / `after_feature`
- `before_scenario` / `after_scenario`
- `before_step` / `after_step`

**Best practices:**
- Focus business behavior
- Reusable steps
- Scenario Outline
- Tags สำหรับ categories
- Hooks สำหรับ setup/teardown
- Page Objects สำหรับ UI

> **อ้างอิงเพิ่มเติม:** [behave Documentation](https://behave.readthedocs.io/)

---

## 9.23 pytest-bdd

### บทนำ

`pytest-bdd` เป็น BDD plugin สำหรับ pytest ที่ integrate Gherkin กับ pytest ecosystem

### นิยาม

pytest-bdd ให้ Gherkin support ใน pytest

### 9.23.1 คืออะไร

**ข้อดี:**
- pytest fixtures
- pytest markers
- pytest plugins
- Pythonic

### 9.23.2 ทำงานอย่างไร

1. อ่าน `.feature` files
2. ใช้ `scenarios()` link
3. จับคู่ steps กับ functions
4. รันด้วย pytest

### 9.23.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install pytest-bdd
```

**Feature:**

```gherkin
# features/calculator.feature
Feature: Calculator

  Scenario: Add two numbers
    Given a calculator
    When I add 2 and 3
    Then the result should be 5

  Scenario: Divide by zero
    Given a calculator
    When I divide 10 by 0
    Then I should get error "division by zero"
```

**Test file:**

```python
# tests/test_calculator_bdd.py
import pytest
from pytest_bdd import scenarios, given, when, then, parsers


# Link feature file
scenarios("features/calculator.feature")


@pytest.fixture
def calc():
    from src.calculator import Calculator
    return Calculator()


@given("a calculator", target_fixture="calculator")
def calculator(calc):
    return calc


@when(parsers.parse("I add {a:d} and {b:d}"))
def add_numbers(calculator, a, b):
    calculator.result = calculator.add(a, b)


@when(parsers.parse("I divide {a:d} by {b:d}"))
def divide_numbers(calculator, a, b):
    try:
        calculator.result = calculator.divide(a, b)
        calculator.error = None
    except ZeroDivisionError as e:
        calculator.error = str(e)


@then(parsers.parse("the result should be {expected:d}"))
def check_result(calculator, expected):
    assert calculator.result == expected


@then(parsers.parse('I should get error "{message}"'))
def check_error(calculator, message):
    assert calculator.error == message
```

**pytest Fixtures:**

```python
import pytest
from pytest_bdd import scenarios, given, when, then, parsers


scenarios("features/user.feature")


@pytest.fixture
def db(tmp_path):
    """pytest fixture ใช้ได้"""
    import sqlite3
    conn = sqlite3.connect(tmp_path / "test.db")
    conn.executescript("""
        CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT
        );
    """)
    yield conn
    conn.close()


@given("a database with a user", target_fixture="user")
def db_with_user(db):
    db.execute(
        "INSERT INTO users (name, email) VALUES (?, ?)",
        ("Test", "test@example.com"),
    )
    db.commit()
    return {"id": 1, "name": "Test", "email": "test@example.com"}


@when(parsers.parse("I update the user's name to {name}"))
def update_name(db, user, name):
    db.execute(
        "UPDATE users SET name = ? WHERE id = ?",
        (name, user["id"]),
    )
    db.commit()


@then(parsers.parse("the user's name should be {name}"))
def check_name(db, user, name):
    row = db.execute(
        "SELECT name FROM users WHERE id = ?",
        (user["id"],),
    ).fetchone()
    assert row[0] == name
```

**Parametrized Scenarios:**

```python
from pytest_bdd import scenarios, given, when, then, parsers
import pytest


scenarios("features/math.feature")


@pytest.fixture
def calc():
    from src.calculator import Calculator
    return Calculator()


@given("a calculator", target_fixture="calculator")
def calculator(calc):
    return calc


@when(
    parsers.parse("I {operation} {a:d} and {b:d}"),
    target_fixture="result",
)
def operation(calculator, operation, a, b):
    ops = {
        "add": calculator.add,
        "subtract": calculator.subtract,
        "multiply": calculator.multiply,
    }
    return ops[operation](a, b)


@then(parsers.parse("the result should be {expected:d}"))
def check_result(result, expected):
    assert result == expected
```

**pytest-bdd markers:**

```python
import pytest
from pytest_bdd import scenarios, given, when, then


scenarios("features/login.feature")


@pytest.mark.smoke
@given("a registered user")
def registered_user():
    return {"username": "test", "password": "test123"}


@pytest.mark.integration
@when("they log in")
def login(registered_user):
    from src.auth import login
    return login(
        registered_user["username"],
        registered_user["password"],
    )


@then("they should be authenticated")
def check_auth(login):
    assert login["authenticated"] is True
```

**Scenarios ทั้ง folder:**

```python
# tests/test_all_features.py
from pytest_bdd import scenarios


# โหลดทุก features
scenarios("features/")


# หรือ specific
# scenarios("features/login.feature")
# scenarios("features/cart.feature")
```

**ตัวอย่างการใช้งานจริง — API:**

```gherkin
# features/api.feature
Feature: User API

  Background:
    Given the API is running
    And the following users exist:
      | id | name  | email               |
      | 1  | Alice | alice@example.com   |
      | 2  | Bob   | bob@example.com     |

  Scenario: Get user by ID
    When I request GET /api/users/1
    Then the response status should be 200
    And the response should contain:
      | field | value             |
      | id    | 1                 |
      | name  | Alice             |
      | email | alice@example.com |

  Scenario: Get nonexistent user
    When I request GET /api/users/999
    Then the response status should be 404

  Scenario: Create user
    When I POST to /api/users with:
      | name  | Charlie           |
      | email | charlie@example.com |
    Then the response status should be 201
    And the response should have field "id"

  Scenario Outline: Invalid email
    When I POST to /api/users with:
      | name  | Test              |
      | email | <email>           |
    Then the response status should be 400

    Examples:
      | email           |
      | invalid         |
      | @example.com    |
      | user@           |
      | user@.com       |
```

```python
# tests/test_api_bdd.py
import pytest
from pytest_bdd import scenarios, given, when, then, parsers
from fastapi.testclient import TestClient


scenarios("features/api.feature")


@pytest.fixture
def api():
    from src.app import app
    return TestClient(app)


@pytest.fixture
def response():
    return {}


@given("the API is running", target_fixture="client")
def api_running(api):
    return api


@given("the following users exist:")
def users_exist(client, datatable):
    for row in datatable:
        client.post("/api/users", json={
            "name": row["name"],
            "email": row["email"],
        })


@when(parsers.parse("I request GET {path}"))
def get_request(client, response, path):
    resp = client.get(path)
    response["status"] = resp.status_code
    response["body"] = resp.json()


@when("I POST to {path} with:", target_fixture="create_response")
def post_request(client, path, datatable):
    data = dict(datatable[0])
    resp = client.post(path, json=data)
    return {"status": resp.status_code, "body": resp.json()}


@then(parsers.parse("the response status should be {status:d}"))
def check_status(response, status):
    assert response["status"] == status


@then("the response should contain:")
def check_response(response, datatable):
    for row in datatable:
        field = row["field"]
        expected = row["value"]
        assert str(response["body"][field]) == expected


@then(parsers.parse('the response should have field "{field}"'))
def check_field(response, field):
    assert field in response["body"]
```

### 9.23.4 ข้อดี

- **pytest ecosystem:** ใช้ fixtures, markers
- **Pythonic:** API สะอาด
- **Flexible:** ยืดหยุ่น
- **Integrated:** กับ pytest

### 9.23.5 ข้อเสีย

- **Third-party:** ต้องติดตั้ง
- **Learning:** ต้องเข้าใจ BDD

### 9.23.6 ข้อควรระวัง

```python
# ระวัง 1: scenarios() path
# ต้องตรงกับ feature file
scenarios("features/login.feature")  # ✅
scenarios("wrong/path.feature")  # ❌ error

# ระวัง 2: Fixture names
# target_fixture ช่วยให้ใช้ใน steps อื่น
@given("a user", target_fixture="user")
def user_fixture():
    return {"id": 1}

@when("...")
def step(user):  # ✅ ใช้ fixture
    ...

# ระวัง 3: Parsers
# ต้อง match กับ feature file
@when(parsers.parse("I add {a:d} and {b:d}"))
# feature: When I add 2 and 3

# ระวัง 4: datatable
# feature table
@given("the following users:")
def users(datatable):
    for row in datatable:
        ...

# ระวัง 5: State sharing
# ✅ ใช้ fixtures
# ✅ return values

# ระวัง 6: Multiple scenarios()
# ✅ scenarios("features/") สำหรับทั้งหมด

# ระวัง 7: Slow UI tests
# ✅ แยก markers
```

### 9.23.7 สรุป

**API:**

| Function | ใช้ |
|----------|-----|
| `scenarios()` | Link feature |
| `@given` | Setup |
| `@when` | Action |
| `@then` | Assert |
| `parsers.parse()` | Parse params |
| `target_fixture` | Return fixture |

**Best practices:**
- ใช้ pytest fixtures
- `target_fixture` สำหรับ return values
- Markers สำหรับ categories
- `datatable` สำหรับ tables
- `parsers.parse` สำหรับ typed params
- scenarios() ทั้ง folder

> **อ้างอิงเพิ่มเติม:** [pytest-bdd Documentation](https://pytest-bdd.readthedocs.io/)

---

## 9.24 Test-Driven Development

### บทนำ

Test-Driven Development (TDD) เป็นแนวทางที่เขียน test ก่อนเขียนโค้ด ช่วยออกแบบและเพิ่มคุณภาพ

### นิยาม

TDD คือ process: Red → Green → Refactor

### 9.24.1 คืออะไร

**TDD Cycle:**
1. **Red:** เขียน test ที่ fail
2. **Green:** เขียนโค้ดให้ pass
3. **Refactor:** ปรับปรุงโค้ด

### 9.24.2 ทำงานอย่างไร

```
1. เขียน test
2. รัน → fail (Red)
3. เขียนโค้ด minimal
4. รัน → pass (Green)
5. Refactor
6. รัน → ยัง pass
7. กลับไป 1
```

### 9.24.3 การใช้งาน

**ตัวอย่าง TDD:**

**Step 1: Red — เขียน test**

```python
# test_fizzbuzz.py
def test_returns_1_for_1():
    assert fizzbuzz(1) == "1"


def test_returns_2_for_2():
    assert fizzbuzz(2) == "2"


def test_returns_fizz_for_3():
    assert fizzbuzz(3) == "Fizz"


def test_returns_buzz_for_5():
    assert fizzbuzz(5) == "Buzz"


def test_returns_fizzbuzz_for_15():
    assert fizzbuzz(15) == "FizzBuzz"
```

**Step 2: รัน → fail (Red)**

```bash
pytest test_fizzbuzz.py
# NameError: name 'fizzbuzz' is not defined
```

**Step 3: Green — เขียนโค้ด minimal**

```python
# fizzbuzz.py
def fizzbuzz(n: int) -> str:
    return str(n)
```

**Step 4: รัน → บาง test pass**

```bash
pytest test_fizzbuzz.py
# test_returns_1_for_1 PASSED
# test_returns_2_for_2 PASSED
# test_returns_fizz_for_3 FAILED
```

**Step 5: ทำซ้ำจน pass ทุก test**

```python
def fizzbuzz(n: int) -> str:
    if n % 15 == 0:
        return "FizzBuzz"
    if n % 3 == 0:
        return "Fizz"
    if n % 5 == 0:
        return "Buzz"
    return str(n)
```

**Step 6: Refactor**

```python
def fizzbuzz(n: int) -> str:
    result = ""
    if n % 3 == 0:
        result += "Fizz"
    if n % 5 == 0:
        result += "Buzz"
    return result or str(n)
```

**ตัวอย่างการใช้งานจริง — Shopping Cart:**

```python
# test_cart.py
import pytest
from decimal import Decimal


class TestCart:
    """TDD ทีละ feature"""

    # 1. Empty cart
    def test_new_cart_is_empty(self):
        from src.cart import Cart
        cart = Cart()
        assert len(cart) == 0

    def test_empty_cart_total_is_zero(self):
        cart = Cart()
        assert cart.total == Decimal("0")

    # 2. Add item
    def test_add_one_item(self):
        cart = Cart()
        cart.add("Apple", Decimal("10"), 1)
        assert len(cart) == 1

    def test_total_after_adding(self):
        cart = Cart()
        cart.add("Apple", Decimal("10"), 1)
        assert cart.total == Decimal("10")

    def test_adding_same_item_increases_qty(self):
        cart = Cart()
        cart.add("Apple", Decimal("10"), 1)
        cart.add("Apple", Decimal("10"), 2)
        assert len(cart) == 1
        assert cart.total == Decimal("30")

    # 3. Remove item
    def test_remove_item(self):
        cart = Cart()
        cart.add("Apple", Decimal("10"), 1)
        cart.remove("Apple")
        assert len(cart) == 0

    # 4. Quantity
    def test_add_negative_quantity_raises(self):
        cart = Cart()
        with pytest.raises(ValueError):
            cart.add("Apple", Decimal("10"), -1)

    def test_add_zero_quantity_raises(self):
        cart = Cart()
        with pytest.raises(ValueError):
            cart.add("Apple", Decimal("10"), 0)

    # 5. Edge cases
    def test_remove_nonexistent_raises(self):
        cart = Cart()
        with pytest.raises(KeyError):
            cart.remove("Nothing")

    def test_clear_cart(self):
        cart = Cart()
        cart.add("Apple", Decimal("10"), 1)
        cart.add("Banana", Decimal("5"), 2)
        cart.clear()
        assert len(cart) == 0
        assert cart.total == Decimal("0")
```

**Implementation:**

```python
# src/cart.py
from decimal import Decimal
from dataclasses import dataclass, field


@dataclass
class CartItem:
    name: str
    price: Decimal
    quantity: int


class Cart:
    def __init__(self):
        self._items: dict[str, CartItem] = {}

    def add(self, name: str, price: Decimal, quantity: int) -> None:
        if quantity <= 0:
            raise ValueError("Quantity must be positive")

        if name in self._items:
            self._items[name].quantity += quantity
        else:
            self._items[name] = CartItem(name, price, quantity)

    def remove(self, name: str) -> None:
        if name not in self._items:
            raise KeyError(name)
        del self._items[name]

    def clear(self) -> None:
        self._items.clear()

    @property
    def total(self) -> Decimal:
        return sum(
            item.price * item.quantity
            for item in self._items.values()
        )

    def __len__(self) -> int:
        return len(self._items)
```

**TDD กับ pytest:**

```python
# tests/test_user_service.py
import pytest
from unittest.mock import Mock


class TestUserService:
    """TDD ทีละ requirement"""

    @pytest.fixture
    def mock_repo(self):
        return Mock()

    @pytest.fixture
    def service(self, mock_repo):
        from src.user_service import UserService
        return UserService(mock_repo)

    # Requirement 1: Get user
    def test_get_user_returns_user(self, service, mock_repo):
        mock_repo.find_by_id.return_value = {"id": 1, "name": "Alice"}

        result = service.get(1)

        assert result == {"id": 1, "name": "Alice"}
        mock_repo.find_by_id.assert_called_once_with(1)

    # Requirement 2: Handle not found
    def test_get_user_returns_none_if_not_found(self, service, mock_repo):
        mock_repo.find_by_id.return_value = None

        result = service.get(999)

        assert result is None

    # Requirement 3: Create user
    def test_create_user_saves(self, service, mock_repo):
        mock_repo.save.return_value = {"id": 1, "name": "Alice"}

        result = service.create("Alice", "alice@example.com")

        assert result["id"] == 1
        mock_repo.save.assert_called_once()

    # Requirement 4: Validate email
    def test_create_user_validates_email(self, service):
        with pytest.raises(ValueError, match="email"):
            service.create("Alice", "invalid")

    # Requirement 5: Validate name
    def test_create_user_validates_name(self, service):
        with pytest.raises(ValueError, match="name"):
            service.create("", "alice@example.com")

    # Requirement 6: Duplicate email
    def test_create_user_duplicate_email_raises(self, service, mock_repo):
        mock_repo.find_by_email.return_value = {"id": 1}

        with pytest.raises(ValueError, match="already exists"):
            service.create("Alice", "alice@example.com")
```

### 9.24.4 ข้อดี

- **Design:** บังคับคิดก่อนเขียน
- **Coverage:** tests ครอบคลุม
- **Confidence:** refactor ได้
- **Documentation:** tests อธิบาย behavior
- **Debug:** ง่ายกว่า
- **Less bugs:** พบ bugs เร็ว

### 9.24.5 ข้อเสีย

- **Learning curve:** ต้องฝึก
- **Time:** เริ่มช้ากว่า
- **Over-testing:** ถ้าไม่ระวัง
- **Not for everything:** exploratory code

### 9.24.6 ข้อควรระวัง

```python
# ระวัง 1: TDD ไม่ใช่ religion
# ❌ บังคับ TDD ทุกอย่าง
# ✅ ใช้เมื่อเหมาะสม

# ระวัง 2: Test ที่ผูก implementation
# ❌
def test_user_service():
    service = UserService()
    service.create("test")
    assert service._users == {"test"}  # ❌ ผูก internal

# ✅
def test_user_service():
    service = UserService()
    user = service.create("test")
    assert service.get(user.id) == user

# ระวัง 3: Refactor โดยไม่รัน test
# ✅ รัน test ทุกครั้ง

# ระวัง 4: ข้าม Red phase
# ❌ เขียนโค้ดก่อน test
# ✅ test ต้อง fail ก่อน

# ระวัง 5: Test มากเกินไป
# ✅ ครอบคลุม behavior ไม่ใช่ implementation

# ระวัง 6: Slow feedback
# ✅ unit tests เร็ว
# ✅ integration tests แยก

# ระวัง 7: TDD ไม่แทน design
# ✅ TDD เป็น tool ไม่ใช่ goal
```

### 9.24.7 สรุป

**TDD Cycle:**
1. **Red:** เขียน test ที่ fail
2. **Green:** เขียนโค้ด minimal
3. **Refactor:** ปรับปรุง

**Benefits:**
- Better design
- Higher coverage
- Confidence to refactor
- Living documentation

**Best practices:**
- ทีละ small step
- รัน test ทุกครั้ง
- Refactor หลัง green
- Test behavior ไม่ใช่ implementation
- ใช้เมื่อเหมาะสม

> **อ้างอิงเพิ่มเติม:** [Test-Driven Development](https://en.wikipedia.org/wiki/Test-driven_development)

---

## 9.25 Static Analysis

### บทนำ

Static Analysis คือการวิเคราะห์โค้ดโดยไม่รัน หา bugs, type errors, code smells และ style issues

### นิยาม

Static Analysis คือการตรวจสอบโค้ดเชิง静态 โดยใช้ tools

### 9.25.1 คืออะไร

**Types:**
- **Type checking:** mypy, pyright
- **Linting:** pylint, flake8, ruff
- **Security:** bandit
- **Complexity:** radon
- **Dead code:** vulture

### 9.25.2 ทำงานอย่างไร

Tools:
1. Parse code เป็น AST
2. วิเคราะห์
3. รายงาน issues

### 9.25.3 การใช้งาน

**mypy:**

```bash
pip install mypy
```

```python
# src/example.py
def greet(name: str) -> str:
    return f"Hello, {name}"


greet(42)  # mypy: error
```

```bash
mypy src/
# src/example.py:5: error: Argument 1 to "greet" has incompatible type "int"; expected "str"
```

**pyright:**

```bash
pip install pyright
```

```bash
pyright src/
```

**pylint:**

```bash
pip install pylint
```

```bash
pylint src/

# Output:
# src/example.py:1:0: C0114: Missing module docstring (missing-module-docstring)
# src/example.py:5:0: C0103: Function name "badName" doesn't conform to snake_case naming style (invalid-name)
```

**flake8:**

```bash
pip install flake8
```

```bash
flake8 src/
```

**ruff:**

```bash
pip install ruff
```

```bash
ruff check src/
ruff check --fix src/  # auto-fix
ruff format src/
```

**ruff configuration:**

```toml
# pyproject.toml
[tool.ruff]
line-length = 88
target-version = "py310"

[tool.ruff.lint]
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "N",   # pep8-naming
    "UP",  # pyupgrade
    "B",   # flake8-bugbear
    "C4",  # flake8-comprehensions
    "SIM", # flake8-simplify
    "S",   # flake8-bandit
    "RUF", # Ruff-specific
]
ignore = [
    "E501",  # line too long (handled by formatter)
]

[tool.ruff.lint.per-file-ignores]
"tests/*" = ["S101"]  # assert ใน tests
```

**Pre-commit:**

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.7.0
    hooks:
      - id: mypy
        additional_dependencies: [types-requests]

  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.5
    hooks:
      - id: bandit
        args: [-r, src/]
```

**ตัวอย่างการใช้งานจริง — CI:**

```yaml
# .github/workflows/quality.yml
name: Code Quality

on: [push, pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - run: pip install -e ".[dev]"

      - name: Ruff
        run: ruff check src/ tests/

      - name: Ruff format
        run: ruff format --check src/ tests/

      - name: mypy
        run: mypy src/

      - name: Bandit
        run: bandit -r src/ -ll

      - name: pytest
        run: pytest --cov=src --cov-fail-under=80
```

**Type Checker Configuration:**

```toml
# pyproject.toml

[tool.mypy]
python_version = "3.12"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_any_generics = true
check_untyped_defs = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true
warn_unreachable = true

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false

[[tool.mypy.overrides]]
module = "some_library.*"
ignore_missing_imports = true
```

**ตัวอย่าง — Static Analysis Output:**

```python
# src/example.py
import os
from typing import List, Optional


def find_files(directory: str) -> List[str]:
    """Find all files in directory"""
    result = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            result.append(os.path.join(root, file))
    return result


def get_user(user_id: int) -> Optional[dict]:
    users = {1: {"name": "Alice"}}
    return users.get(user_id)


def bad_function(x):
    # ❌ no type hints
    if x == None:  # ❌ comparison to None
        return []
    return x


result: int = "string"  # ❌ type mismatch
```

**mypy output:**

```
src/example.py:19: error: Function is missing a type annotation
src/example.py:20: error: Comparison to None should be 'if cond is None:'
src/example.py:25: error: Incompatible types in assignment (expression has type "str", variable has type "int")
```

**ruff output:**

```
src/example.py:1:1: F401 `os` imported but unused
src/example.py:15:5: E722 Do not use bare `except`
src/example.py:20:8: E711 Comparison to `None` should be `cond is None`
```

### 9.25.4 ข้อดี

- **Early detection:** พบ bugs ก่อนรัน
- **Consistency:** รูปแบบเดียวกัน
- **Automation:** ใน CI
- **Documentation:** type hints
- **Refactoring:** ปลอดภัย

### 9.25.5 ข้อเสีย

- **False positives:** อาจรายงานผิด
- **Setup:** ต้องตั้งค่า
- **Time:** เพิ่มเวลา CI
- **Resistance:** ทีมอาจต่อต้าน

### 9.25.6 ข้อควรระวัง

```python
# ระวัง 1: Type hints ไม่ครบ
# ❌ ไม่มี hints
def process(data):
    return data

# ✅
def process(data: dict[str, Any]) -> list[str]:
    return list(data.keys())

# ระวัง 2: ignore มากเกินไป
# ❌
result = something()  # type: ignore

# ✅ ignore เฉพาะที่จำเป็น
result = something()  # type: ignore[specific-error]

# ระวัง 3: strict mode ในโปรเจกต์เก่า
# ✅ เริ่มผ่อนก่อน
# ✅ ค่อย ๆ เข้มขึ้น

# ระวัง 4: Tools conflict
# ✅ ใช้ ruff แทน flake8 + isort + black
# ✅ consistent configuration

# ระวัง 5: CI blocks
# ✅ แยก critical vs warning
# ✅ ใช้ incremental

# ระวัง 6: ไม่ fix warnings
# ✅ fix หรือ suppress อย่างมีเหตุผล

# ระวัง 7: Over-configuration
# ✅ เริ่มง่าย ๆ
```

### 9.25.7 สรุป

**Tools:**

| Tool | ใช้ |
|------|-----|
| `ruff` | Linting + formatting |
| `mypy` | Type checking |
| `pyright` | Type checking (fast) |
| `pylint` | Comprehensive linting |
| `bandit` | Security |
| `vulture` | Dead code |

**Best practices:**
- ใช้ ruff (แทน flake8, isort, black)
- Type hints ทุก function
- Pre-commit hooks
- CI integration
- Fix warnings
- Consistent config

> **อ้างอิงเพิ่มเติม:** [Ruff](https://docs.astral.sh/ruff/), [mypy](https://mypy.readthedocs.io/), [Pyright](https://microsoft.github.io/pyright/)

---

## 9.26 mypy

### บทนำ

`mypy` เป็น static type checker ที่นิยมที่สุดสำหรับ Python ตรวจสอบ type hints โดยไม่รันโค้ด

### นิยาม

mypy เป็น optional static type checker สำหรับ Python

### 9.26.1 คืออะไร

**Features:**
- Type checking
- Type inference
- Generic types
- Protocols
- Incremental

### 9.26.2 ทำงานอย่างไร

mypy:
1. Parse code
2. วิเคราะห์ types
3. ตรวจสอบ compatibility
4. รายงาน errors

### 9.26.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install mypy
```

**พื้นฐาน:**

```python
# src/example.py
def add(a: int, b: int) -> int:
    return a + b


result = add(1, 2)      # ✅
result = add("1", "2")  # ❌ mypy error
```

```bash
mypy src/
# src/example.py:6: error: Argument 1 to "add" has incompatible type "str"; expected "int"
```

**Type Annotations:**

```python
from typing import Optional, Union, List, Dict, Tuple, Any, Callable


# พื้นฐาน
name: str = "Alice"
age: int = 30
scores: list[float] = [85.5, 92.0]
user: dict[str, Union[str, int]] = {"name": "Alice", "age": 30}


# Optional
def find(name: str) -> Optional[int]:
    users = {"Alice": 1}
    return users.get(name)


# Union (Python 3.10+)
def process(value: int | str) -> str:
    return str(value)


# Callable
def apply(func: Callable[[int], int], value: int) -> int:
    return func(value)


# Generics
from typing import TypeVar

T = TypeVar("T")

def first(items: list[T]) -> T:
    return items[0]


# Classes
class User:
    def __init__(self, name: str, age: int) -> None:
        self.name = name
        self.age = age

    def greet(self) -> str:
        return f"Hello, {self.name}"


# Protocol
from typing import Protocol

class Drawable(Protocol):
    def draw(self) -> str: ...


def render(item: Drawable) -> None:
    print(item.draw())
```

**Common Errors:**

```python
# 1. Type mismatch
x: int = "string"  # error

# 2. Missing return
def get_name() -> str:
    pass  # error: Missing return statement

# 3. Optional access
def get_user() -> Optional[dict]:
    return None

user = get_user()
print(user["name"])  # error: Item "None" has no attribute "__getitem__"

# ✅
if user is not None:
    print(user["name"])

# 4. Argument type
def greet(name: str) -> str:
    return f"Hello, {name}"

greet(42)  # error

# 5. List invariance
def process(items: list[int]) -> None: ...

numbers: list[int] = [1, 2, 3]
process(numbers)  # ✅

mixed: list[int | str] = [1, "a"]
process(mixed)  # error
```

**Configuration:**

```toml
# pyproject.toml
[tool.mypy]
python_version = "3.12"

# Strictness
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_any_generics = true
disallow_untyped_calls = true
disallow_incomplete_defs = true
check_untyped_defs = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true
warn_unreachable = true

# Per-module
[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false

[[tool.mypy.overrides]]
module = [
    "requests.*",
    "yaml.*",
]
ignore_missing_imports = true
```

**Incremental:**

```bash
# mypy สร้าง .mypy_cache
mypy src/

# ลบ cache
mypy --no-incremental src/

# หรือ
rm -rf .mypy_cache
```

**Type Stubs:**

```bash
# ติดตั้ง stubs สำหรับ libraries
pip install types-requests
pip install types-pyyaml
pip install types-python-dateutil

# หรือ
pip install mypy --install-types
```

**ตัวอย่างการใช้งานจริง — Typed Code:**

```python
# src/user_service.py
from dataclasses import dataclass
from typing import Protocol, Optional
from decimal import Decimal


@dataclass
class User:
    id: int
    name: str
    email: str
    balance: Decimal = Decimal("0")


class UserRepository(Protocol):
    def find_by_id(self, user_id: int) -> Optional[User]: ...
    def find_by_email(self, email: str) -> Optional[User]: ...
    def save(self, user: User) -> User: ...


class ValidationError(Exception):
    pass


class UserService:
    def __init__(self, repository: UserRepository) -> None:
        self._repo = repository

    def get(self, user_id: int) -> Optional[User]:
        return self._repo.find_by_id(user_id)

    def register(self, name: str, email: str) -> User:
        if not name:
            raise ValidationError("Name required")

        if "@" not in email:
            raise ValidationError("Invalid email")

        existing = self._repo.find_by_email(email)
        if existing is not None:
            raise ValidationError("Email already exists")

        user = User(id=0, name=name, email=email)
        return self._repo.save(user)

    def deposit(self, user_id: int, amount: Decimal) -> User:
        if amount <= 0:
            raise ValidationError("Amount must be positive")

        user = self._repo.find_by_id(user_id)
        if user is None:
            raise ValidationError("User not found")

        user.balance += amount
        return self._repo.save(user)
```

**mypy check:**

```bash
mypy src/user_service.py
# Success: no issues found
```

**Runtime type checking:**

```python
from typing import get_type_hints
import inspect


def validate_types(func):
    """Decorator ที่ตรวจสอบ types ตอน runtime"""
    hints = get_type_hints(func)

    def wrapper(*args, **kwargs):
        # ตรวจสอบ args
        sig = inspect.signature(func)
        bound = sig.bind(*args, **kwargs)
        bound.apply_defaults()

        for param_name, value in bound.arguments.items():
            if param_name in hints:
                expected = hints[param_name]
                if not isinstance(value, expected):
                    raise TypeError(
                        f"{param_name}: expected {expected}, got {type(value)}"
                    )

        result = func(*args, **kwargs)

        # ตรวจสอบ return
        if "return" in hints:
            expected = hints["return"]
            if not isinstance(result, expected):
                raise TypeError(
                    f"return: expected {expected}, got {type(result)}"
                )

        return result

    return wrapper


@validate_types
def add(a: int, b: int) -> int:
    return a + b


add(1, 2)      # ✅
# add("1", 2)  # ❌ TypeError
```

### 9.26.4 ข้อดี

- **Early detection:** พบ bugs ก่อนรัน
- **Documentation:** types อธิบายโค้ด
- **IDE support:** autocomplete
- **Refactoring:** ปลอดภัย
- **Standard:** PEP 484

### 9.26.5 ข้อเสีย

- **Setup:** ต้องตั้งค่า
- **Verbose:** type hints เยอะ
- **False positives:** อาจรายงานผิด
- **Learning:** ต้องเข้าใจ typing

### 9.26.6 ข้อควรระวัง

```python
# ระวัง 1: Optional ไม่ได้หมายถึง optional parameter
# ❌ สับสน
def greet(name: Optional[str] = None) -> str:
    return f"Hello, {name}"  # name อาจเป็น None

# ✅
def greet(name: str = "World") -> str:
    return f"Hello, {name}"

# ระวัง 2: Any
# ❌ Any ทำลาย type checking
def process(data: Any) -> Any:
    return data

# ✅ ใช้ type ที่เฉพาะเจาะจง

# ระวัง 3: ignore โดยไม่ดู
# ❌
result = something()  # type: ignore

# ✅
result = something()  # type: ignore[arg-type]  # เหตุผล

# ระวัง 4: strict mode ทันที
# ✅ เริ่มจาก default แล้วค่อย strict

# ระวัง 5: Type stubs
# ✅ ติดตั้ง types-* สำหรับ third-party

# ระวัง 6: Circular imports
# ✅ ใช้ from __future__ import annotations
from __future__ import annotations

class Node:
    def __init__(self, next: Node | None = None):  # ✅
        self.next = next

# ระวัง 7: mypy version
# ✅ pin version ใน requirements
```

### 9.26.7 สรุป

**Commands:**

```bash
mypy src/
mypy --strict src/
mypy --install-types
```

**Types:**

| Type | ใช้ |
|------|-----|
| `int`, `str`, `float`, `bool` | พื้นฐาน |
| `list[T]`, `dict[K,V]` | Collections |
| `Optional[T]` | `T \| None` |
| `Union[A,B]` | `A \| B` |
| `Callable[[A],B]` | Functions |
| `Protocol` | Structural |

**Best practices:**
- Type hints ทุก public function
- `strict = true` สำหรับโปรเจกต์ใหม่
- Type stubs สำหรับ third-party
- `from __future__ import annotations`
- Incremental adoption
- CI integration

> **อ้างอิงเพิ่มเติม:** [mypy Documentation](https://mypy.readthedocs.io/)

---

## 9.27 pyright

### บทนำ

`pyright` เป็น static type checker ที่พัฒนาโดย Microsoft เน้นความเร็วและ IDE integration

### นิยาม

Pyright เป็น type checker สำหรับ Python เขียนด้วย TypeScript

### 9.27.1 คืออะไร

**ข้อดี:**
- เร็วมาก
- IDE integration (VS Code/Pylance)
- Type inference ดี
- Strict mode

### 9.27.2 ทำงานอย่างไร

Pyright:
1. Parse code
2. วิเคราะห์ types
3. ตรวจสอบ
4. รายงาน

### 9.27.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install pyright
```

**รัน:**

```bash
pyright src/

# Output:
# src/example.py
#   src/example.py:5:9 - error: Argument of type "int" cannot be assigned to parameter "name" of type "str"
# 1 error, 0 warnings, 0 informations
```

**Configuration (pyrightconfig.json):**

```json
{
  "include": ["src"],
  "exclude": ["**/node_modules", "**/__pycache__", "tests"],
  "ignore": [],
  "strict": ["src/core/**"],
  "typeCheckingMode": "strict",
  "reportMissingImports": true,
  "reportMissingTypeStubs": false,
  "pythonVersion": "3.12",
  "pythonPlatform": "Linux",
  "venvPath": ".",
  "venv": ".venv"
}
```

**pyproject.toml:**

```toml
[tool.pyright]
include = ["src"]
exclude = ["**/node_modules", "**/__pycache__", "tests"]
strict = ["src/core"]
typeCheckingMode = "strict"
pythonVersion = "3.12"
reportMissingImports = true
reportMissingTypeStubs = false
```

**Type Checking Modes:**

| Mode | ระดับ |
|------|-------|
| `off` | ปิด |
| `basic` | พื้นฐาน |
| `standard` | มาตรฐาน |
| `strict` | เข้มงวด |

**Basic:**

```python
def greet(name: str) -> str:
    return f"Hello, {name}"

greet(42)  # error
```

**Standard:**

```python
# เพิ่มการตรวจสอบ optional
def get_user() -> dict | None:
    return None

user = get_user()
user["name"]  # error: "None" ไม่มี __getitem__
```

**Strict:**

```python
# ต้องมี type hints ทุกที่
def process(data):  # error: missing type annotation
    return data

# ต้องตรวจสอบ None
def get_name() -> str | None:
    return None

name = get_name()
print(name.upper())  # error

# ต้องใช้ specific types
from typing import Any

def process(data: Any) -> None:  # warning
    ...
```

**VS Code Integration:**

```json
// .vscode/settings.json
{
    "python.analysis.typeCheckingMode": "strict",
    "python.analysis.autoImportCompletions": true,
    "python.analysis.inlayHints.variableTypes": true,
    "python.analysis.inlayHints.functionReturnTypes": true,
    "python.analysis.diagnosticMode": "workspace"
}
```

**CLI options:**

```bash
# ตรวจสอบไฟล์เดียว
pyright src/example.py

# ตรวจสอบ folder
pyright src/

# Watch mode
pyright --watch src/

# Output JSON
pyright --outputjson src/

# Stats
pyright --stats src/

# Version
pyright --version
```

**ตัวอย่างการใช้งานจริง:**

```python
# src/api.py
from dataclasses import dataclass
from typing import Protocol
from decimal import Decimal


@dataclass
class PaymentResult:
    success: bool
    transaction_id: str | None = None
    error: str | None = None


class PaymentGateway(Protocol):
    def charge(self, amount: Decimal) -> PaymentResult: ...


class StripeGateway:
    def __init__(self, api_key: str) -> None:
        self._api_key = api_key

    def charge(self, amount: Decimal) -> PaymentResult:
        if amount <= 0:
            return PaymentResult(
                success=False,
                error="Amount must be positive",
            )
        return PaymentResult(
            success=True,
            transaction_id="stripe_123",
        )


class PaymentService:
    def __init__(self, gateway: PaymentGateway) -> None:
        self._gateway = gateway

    def process(
        self,
        amount: Decimal,
        currency: str = "THB",
    ) -> PaymentResult:
        if amount <= 0:
            return PaymentResult(
                success=False,
                error="Invalid amount",
            )

        return self._gateway.charge(amount)


# ✅ Type-safe
service = PaymentService(StripeGateway("key"))
result = service.process(Decimal("100"))
print(result.transaction_id)  # str | None
```

**pyright output:**

```bash
pyright src/api.py
# 0 errors, 0 warnings, 0 informations
```

**CI Integration:**

```yaml
# .github/workflows/typecheck.yml
name: Type Check

on: [push, pull_request]

jobs:
  pyright:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - uses: actions/setup-node@v4
        with:
          node-version: '20'

      - run: pip install -e ".[dev]"

      - name: Run pyright
        uses: jakebailey/pyright-action@v2
        with:
          version: latest
```

### 9.27.4 ข้อดี

- **Fast:** เร็วกว่า mypy
- **IDE:** Pylance
- **Accurate:** inference ดี
- **Configurable:** modes

### 9.27.5 ข้อเสีย

- **Node.js:** ต้องติดตั้ง
- **Less mature:** กว่า mypy
- **Different:** จาก mypy

### 9.27.6 ข้อควรระวัง

```python
# ระวัง 1: Modes ต่างกัน
# ✅ เลือก mode ให้เหมาะ
# ✅ test ก่อน switch

# ระวัง 2: Third-party stubs
# ✅ ใช้ pyright's bundled stubs
# ✅ ignore missing ถ้าจำเป็น

# ระวัง 3: Performance
# ⚠️ strict mode ช้า
# ✅ ใช้ include/exclude

# ระวัง 4: In VS Code
# Pylance อาจ conflict กับ mypy extension
# ✅ เลือกอันเดียว

# ระวัง 5: Version compatibility
# ✅ pin version

# ระวัง 6: False positives
# ✅ report กับ Microsoft
# ✅ workaround

# ระวัง 7: CI
# ✅ ใช้ GitHub Action
```

### 9.27.7 สรุป

**Modes:**
- `off`
- `basic`
- `standard`
- `strict`

**Config:**

```json
{
  "include": ["src"],
  "exclude": ["tests"],
  "strict": ["src/core"],
  "typeCheckingMode": "strict"
}
```

**ใช้เมื่อ:**
- ต้องการความเร็ว
- ใช้ VS Code
- ต้องการ IDE integration

**Best practices:**
- เริ่มจาก basic
- strict สำหรับ core
- VS Code Pylance
- CI integration
- Consistent กับ mypy

> **อ้างอิงเพิ่มเติม:** [Pyright Documentation](https://microsoft.github.io/pyright/)

---

## 9.28 pylint

### บทนำ

`pylint` เป็น linter แบบครบวงจรที่ตรวจสอบ style, errors, code smells และ refactoring suggestions

### นิยาม

pylint เป็น static code analyzer ที่ตรวจสอบคุณภาพโค้ด Python

### 9.28.1 คืออะไร

**ตรวจสอบ:**
- Style (PEP 8)
- Errors
- Warnings
- Refactoring
- Conventions
- Complexity

### 9.28.2 ทำงานอย่างไร

pylint:
1. Parse code
2. วิเคราะห์ AST
3. รัน checkers
4. ให้คะแนน (0-10)

### 9.28.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install pylint
```

**รัน:**

```bash
pylint src/
pylint src/module.py

# Output:
# ************* Module src.module
# src/module.py:1:0: C0114: Missing module docstring (missing-module-docstring)
# src/module.py:5:0: C0103: Variable name "x" doesn't conform to snake_case naming style (invalid-name)
# src/module.py:10:4: W0612: Unused variable 'result' (unused-variable)
#
# -------------------------------------------------------------------
# Your code has been rated at 6.67/10
```

**Categories:**

| Code | หมวด |
|------|------|
| C | Convention |
| R | Refactor |
| W | Warning |
| E | Error |
| F | Fatal |

**Messages:**

```python
# C0103: invalid-name
def BadName():  # ควรเป็น bad_name
    pass

# W0612: unused-variable
def process():
    result = compute()  # ไม่ได้ใช้
    return None

# E1101: no-member
class User:
    pass

user = User()
user.name  # error: no attribute

# R0913: too-many-arguments
def complex_function(a, b, c, d, e, f, g):  # เยอะเกิน
    pass

# C0114: missing-module-docstring
# ไม่มี docstring ที่ module

# W0212: protected-access
class MyClass:
    def __init__(self):
        self._value = 1

obj = MyClass()
print(obj._value)  # protected access
```

**Configuration (.pylintrc):**

```ini
[MASTER]
ignore = migrations,node_modules
ignore-patterns = test_.*?py
persistent = yes
jobs = 4

[MESSAGES CONTROL]
disable =
    C0114,  # missing-module-docstring
    C0116,  # missing-function-docstring
    R0903,  # too-few-public-methods
    R0913,  # too-many-arguments
    W0212,  # protected-access

[FORMAT]
max-line-length = 100
indent-string = '    '

[DESIGN]
max-args = 8
max-attributes = 10
max-bool-expr = 5
max-branches = 12
max-locals = 15
max-parents = 7
max-public-methods = 20
max-returns = 6
max-statements = 50
min-public-methods = 1

[VARIABLES]
dummy-variables-rgx = _|dummy

[SIMILARITIES]
min-similarity-lines = 5
ignore-comments = yes
ignore-docstrings = yes
```

**pyproject.toml:**

```toml
[tool.pylint.main]
ignore = ["migrations"]
jobs = 4

[tool.pylint.messages_control]
disable = [
    "missing-module-docstring",
    "missing-function-docstring",
    "too-few-public-methods",
]

[tool.pylint.format]
max-line-length = 100

[tool.pylint.design]
max-args = 8
max-locals = 15
```

**Inline disable:**

```python
# ทั้งไฟล์
# pylint: disable=missing-module-docstring

# บรรทัด
x = 1  # pylint: disable=invalid-name

# บล็อก
# pylint: disable=too-many-arguments
def complex_function(a, b, c, d, e, f, g):
    pass
# pylint: enable=too-many-arguments
```

**Score:**

```bash
# ไม่ให้คะแนน
pylint --score=n src/

# ตั้งคะแนนขั้นต่ำ
pylint --fail-under=8 src/

# Output format
pylint --output-format=json src/
pylint --output-format=parseable src/
```

**ตัวอย่างการใช้งานจริง — Clean Code:**

```python
# src/calculator.py
"""Calculator module."""

from typing import Union

Number = Union[int, float]


class Calculator:
    """Simple calculator class."""

    def add(self, a: Number, b: Number) -> Number:
        """Add two numbers."""
        return a + b

    def subtract(self, a: Number, b: Number) -> Number:
        """Subtract b from a."""
        return a - b

    def multiply(self, a: Number, b: Number) -> Number:
        """Multiply two numbers."""
        return a * b

    def divide(self, a: Number, b: Number) -> float:
        """Divide a by b.

        Raises:
            ZeroDivisionError: If b is zero.
        """
        if b == 0:
            raise ZeroDivisionError("Cannot divide by zero")
        return a / b


def main() -> None:
    """Main entry point."""
    calc = Calculator()
    result = calc.add(2, 3)
    print(f"Result: {result}")


if __name__ == "__main__":
    main()
```

```bash
pylint src/calculator.py
# ************* Module src.calculator
# Your code has been rated at 10.00/10
```

**Bad Code Example:**

```python
# ❌ pylint จะ complain หลายอย่าง
import os
import sys
import json  # unused

def calc(x,y):
    result=x+y
    return result
    print("never")  # unreachable

class bad_class:
    def __init__(self):
        self.x=1
        self.y=2
        self.z=3
        self.a=4
        # ... too many attributes
```

```bash
pylint bad_code.py
# bad_code.py:1:0: C0114: Missing module docstring
# bad_code.py:2:0: W0611: Unused import sys
# bad_code.py:4:0: W0611: Unused import json
# bad_code.py:6:0: C0103: Function name "calc" doesn't conform to snake_case
# bad_code.py:6:0: C0116: Missing function docstring
# bad_code.py:6:11: C0103: Argument name "x" doesn't conform to snake_case
# bad_code.py:9:4: W0101: Unreachable code
# bad_code.py:12:0: C0103: Class name "bad_class" doesn't conform to PascalCase
```

### 9.28.4 ข้อดี

- **Comprehensive:** ตรวจสอบเยอะ
- **Scoring:** ให้คะแนน
- **Configurable:** ปรับได้
- **Documentation:** messages อธิบาย

### 9.28.5 ข้อเสีย

- **ช้า:** กว่า ruff
- **Verbose:** เยอะ
- **False positives:** อาจรายงานผิด
- **Strict:** อาจเข้มเกิน

### 9.28.6 ข้อควรระวัง

```python
# ระวัง 1: Disable มากเกินไป
# ❌ disable ทุกอย่าง
# ✅ disable เฉพาะที่จำเป็น

# ระวัง 2: Score ≠ Quality
# 10/10 ไม่ได้แปลว่า perfect
# ✅ focus ที่ meaningful issues

# ระวัง 3: Performance
# ⚠️ pylint ช้า
# ✅ ใช้ ruff สำหรับ fast feedback
# ✅ pylint ใน CI

# ระวัง 4: Config ที่ไม่เหมาะ
# ✅ ปรับตามโปรเจกต์

# ระวัง 5: Duplicate กับ ruff/flake8
# ✅ เลือก tool เดียว หรือ configure ให้ complement

# ระวัง 6: False positives
# ✅ report bugs
# ✅ inline disable พร้อม comment

# ระวัง 7: ไม่ fix warnings
# ✅ fix หรือ disable อย่างมีเหตุผล
```

### 9.28.7 สรุป

**Categories:**

| Code | หมวด |
|------|------|
| C | Convention |
| R | Refactor |
| W | Warning |
| E | Error |
| F | Fatal |

**Commands:**

```bash
pylint src/
pylint --fail-under=8 src/
pylint --output-format=json src/
```

**Best practices:**
- ใช้ ruff สำหรับ fast feedback
- pylint สำหรับ deep analysis
- Config ตามโปรเจกต์
- Fix warnings
- Inline disable พร้อมเหตุผล
- CI integration

> **อ้างอิงเพิ่มเติม:** [Pylint Documentation](https://pylint.readthedocs.io/)

---

## 9.29 flake8

### บทนำ

`flake8` เป็น linter ที่รวม PyFlakes, pycodestyle และ McCabe complexity checker

### นิยาม

flake8 เป็นเครื่องมือตรวจสอบ style และ errors ในโค้ด Python

### 9.29.1 คืออะไร

**Components:**
- PyFlakes — logical errors
- pycodestyle — PEP 8
- McCabe — complexity

### 9.29.2 ทำงานอย่างไร

flake8:
1. Parse code
2. รัน checkers
3. รายงาน

### 9.29.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install flake8
```

**รัน:**

```bash
flake8 src/
flake8 src/module.py

# Output:
# src/example.py:1:1: F401 'os' imported but unused
# src/example.py:5:80: E501 line too long (85 > 79 characters)
# src/example.py:10:1: E302 expected 2 blank lines, got 1
# src/example.py:15:5: F841 local variable 'x' is assigned to but never used
```

**Error Codes:**

| Prefix | ใช้ |
|--------|-----|
| E | PEP 8 errors |
| W | PEP 8 warnings |
| F | PyFlakes |
| C | Complexity |

**Common Errors:**

```python
# E501: line too long
x = "very long string that exceeds the maximum line length limit of 79 characters"

# E302: expected 2 blank lines
def func1():
    pass
def func2():  # E302
    pass

# E303: too many blank lines
def func():
    pass



# E711: comparison to None
if x == None:  # E711
    pass

# E712: comparison to True/False
if x == True:  # E712
    pass

# W291: trailing whitespace
x = 1   # W291

# W293: whitespace on blank line

# F401: unused import
import os  # F401

# F841: unused variable
def func():
    x = 1  # F841
    return None

# F-string missing placeholders
name = "Alice"
print(f"Hello")  # F541: f-string without placeholders
```

**Configuration (.flake8):**

```ini
[flake8]
max-line-length = 88
max-complexity = 10
exclude =
    .git,
    __pycache__,
    .venv,
    build,
    dist,
    migrations
ignore =
    E203,  # whitespace before ':'
    W503,  # line break before binary operator
    E501,  # line too long (handled by formatter)
per-file-ignores =
    __init__.py:F401
    tests/*:S101,E501
select =
    E,
    W,
    F,
    C
```

**pyproject.toml (ต้องใช้ flake8-pyproject):**

```toml
[tool.flake8]
max-line-length = 88
max-complexity = 10
exclude = [".git", "__pycache__", ".venv", "build"]
ignore = ["E203", "W503", "E501"]
per-file-ignores = { "__init__.py" = ["F401"] }
```

**Plugins:**

```bash
# ติดตั้ง plugins
pip install flake8-docstrings
pip install flake8-bugbear
pip install flake8-comprehensions
pip install flake8-simplify
pip install flake8-bandit
pip install flake8-annotations
```

```ini
[flake8]
# Docstrings
docstring-convention = google

# Bugbear
extend-select = B
# B008: function call in default argument
# B006: mutable default argument
```

**ตัวอย่างการใช้งานจริง:**

```python
# ❌ Bad code
import os
import sys


def bad_function(x,y):
    result=x+y
    unused = 42
    return result


class bad_class:
    pass
```

```bash
flake8 bad_code.py
# bad_code.py:2:1: F401 'sys' imported but unused
# bad_code.py:5:1: E302 expected 2 blank lines, got 1
# bad_code.py:5:17: E231 missing whitespace after ','
# bad_code.py:6:11: E225 missing whitespace around operator
# bad_code.py:7:5: F841 local variable 'unused' is assigned to but never used
# bad_code.py:10:1: E302 expected 2 blank lines, got 1
# bad_code.py:10:7: N801 class name 'bad_class' should use CapWords convention
```

**Good code:**

```python
"""Example module."""

import os


def good_function(x: int, y: int) -> int:
    """Add two numbers."""
    return x + y


class GoodClass:
    """Example class."""

    pass
```

```bash
flake8 good_code.py
# No output (clean)
```

**CI Integration:**

```yaml
# .github/workflows/lint.yml
name: Lint

on: [push, pull_request]

jobs:
  flake8:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - run: pip install flake8 flake8-bugbear flake8-comprehensions

      - name: Run flake8
        run: flake8 src/ tests/ --statistics
```

### 9.29.4 ข้อดี

- **Standard:** PEP 8
- **Fast:** เร็วกว่า pylint
- **Extensible:** plugins
- **Popular:** ใช้กันมาก

### 9.29.5 ข้อเสีย

- **Less features:** กว่า pylint
- **Conflicts:** กับ black
- **Configuration:** ไม่มีใน pyproject (ต้อง plugin)

### 9.29.6 ข้อควรระวัง

```python
# ระวัง 1: ขัดกับ black
# E203: whitespace before ':'
# Black สร้าง code ที่ E203
ignore = E203

# W503: line break before binary operator
# Black จัดการต่าง
ignore = W503

# ระวัง 2: Line length
# Black ใช้ 88
max-line-length = 88

# ระวัง 3: Plugins ที่ไม่ได้ตั้งใจ
# ✅ pin versions
# ✅ configure

# ระวัง 4: Exclude paths
# ✅ exclude venv, build, .git

# ระวัง 5: per-file-ignores
per-file-ignores =
    __init__.py:F401  # imports สำหรับ package
    tests/*:E501  # line length ใน tests

# ระวัง 6: pyproject.toml
# ต้องติดตั้ง flake8-pyproject

# ระวัง 7: เลือก tool เดียว
# ✅ ruff แทน flake8 + isort + black
```

### 9.29.7 สรุป

**Commands:**

```bash
flake8 src/
flake8 --statistics src/
flake8 --count src/
```

**Codes:**

| Prefix | ใช้ |
|--------|-----|
| E | PEP 8 errors |
| W | PEP 8 warnings |
| F | PyFlakes |
| C | Complexity |

**Config:**

```ini
[flake8]
max-line-length = 88
max-complexity = 10
exclude = .git,__pycache__,.venv
ignore = E203,W503,E501
```

**Best practices:**
- ใช้ ruff แทนถ้าเริ่มใหม่
- Config ให้เข้ากับ black
- Plugins สำหรับ features เพิ่ม
- CI integration
- per-file-ignores

> **อ้างอิงเพิ่มเติม:** [flake8 Documentation](https://flake8.pycqa.org/)

---

## 9.30 ruff

### บทนำ

`ruff` เป็น linter และ formatter ที่เขียนด้วย Rust เร็วมาก แทน flake8, isort, black และอื่น ๆ

### นิยาม

Ruff เป็น Python linter + formatter ที่เร็วที่สุด

### 9.30.1 คืออะไร

**แทน:**
- flake8
- isort
- black
- pyupgrade
- autoflake
- และอื่น ๆ อีก 50+

### 9.30.2 ทำงานอย่างไร

Ruff:
1. Parse code ด้วย Rust
2. รัน rules
3. Fix อัตโนมัติ (บาง rules)

### 9.30.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install ruff
```

**คำสั่ง:**

```bash
# Lint
ruff check src/
ruff check --fix src/  # auto-fix

# Format
ruff format src/
ruff format --check src/  # ตรวจสอบ

# ทั้งหมด
ruff check --fix src/ && ruff format src/
```

**Configuration:**

```toml
# pyproject.toml
[tool.ruff]
line-length = 88
target-version = "py310"
src = ["src", "tests"]
exclude = [
    ".git",
    ".venv",
    "__pycache__",
    "build",
    "dist",
]

[tool.ruff.lint]
select = [
    "E",    # pycodestyle errors
    "W",    # pycodestyle warnings
    "F",    # pyflakes
    "I",    # isort
    "N",    # pep8-naming
    "UP",   # pyupgrade
    "B",    # flake8-bugbear
    "C4",   # flake8-comprehensions
    "SIM",  # flake8-simplify
    "S",    # flake8-bandit
    "T20",  # flake8-print
    "PT",   # flake8-pytest-style
    "RUF",  # Ruff-specific
]
ignore = [
    "E501",  # line too long
    "B008",  # function call in default arg
]

# Auto-fix
fixable = ["ALL"]
unfixable = ["F401"]  # ไม่ auto-fix unused imports

# Per-file
[tool.ruff.lint.per-file-ignores]
"__init__.py" = ["F401", "E402"]
"tests/*" = ["S101", "T20", "PT011"]

[tool.ruff.lint.isort]
known-first-party = ["src"]
known-third-party = ["pytest", "httpx"]
force-single-line = false

[tool.ruff.lint.flake8-quotes]
inline-quotes = "double"
docstring-quotes = "double"

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
line-ending = "auto"
skip-magic-trailing-comma = false
```

**Rule Categories:**

```toml
[tool.ruff.lint]
select = [
    "E", "W",   # pycodestyle
    "F",        # pyflakes
    "I",        # isort
    "N",        # pep8-naming
    "D",        # pydocstyle
    "UP",       # pyupgrade
    "ANN",      # flake8-annotations
    "ASYNC",    # flake8-async
    "S",        # flake8-bandit
    "BLE",      # flake8-blind-except
    "FBT",      # flake8-boolean-trap
    "B",        # flake8-bugbear
    "A",        # flake8-builtins
    "COM",      # flake8-commas
    "C4",       # flake8-comprehensions
    "DTZ",      # flake8-datetimez
    "T10",      # flake8-debugger
    "EM",       # flake8-errmsg
    "EXE",      # flake8-executable
    "FA",       # flake8-future-annotations
    "ISC",      # flake8-implicit-str-concat
    "ICN",      # flake8-import-conventions
    "LOG",      # flake8-logging
    "G",        # flake8-logging-format
    "INP",      # flake8-no-pep420
    "PIE",      # flake8-pie
    "T20",      # flake8-print
    "PYI",      # flake8-pyi
    "PT",       # flake8-pytest-style
    "Q",        # flake8-quotes
    "RSE",      # flake8-raise
    "RET",      # flake8-return
    "SLF",      # flake8-self
    "SLOT",     # flake8-slots
    "SIM",      # flake8-simplify
    "TID",      # flake8-tidy-imports
    "TCH",      # flake8-type-checking
    "INT",      # flake8-gettext
    "ARG",      # flake8-unused-arguments
    "PTH",      # flake8-use-pathlib
    "TD",       # flake8-todos
    "FIX",      # flake8-fixme
    "ERA",      # eradicate
    "PD",       # pandas-vet
    "PGH",      # pygrep-hooks
    "PL",       # pylint
    "TRY",      # tryceratops
    "FLY",      # flynt
    "NPY",      # numpy
    "FAST",     # fastapi
    "AIR",      # airflow
    "PERF",     # perflint
    "FURB",     # refurb
    "RUF",      # Ruff-specific
]
```

**Auto-fix:**

```bash
# ดูว่าจะ fix อะไร
ruff check --diff src/

# Fix
ruff check --fix src/

# Fix unsafe
ruff check --fix --unsafe-fixes src/

# Fix เฉพาะ rules
ruff check --fix --select F401 src/
```

**Format:**

```bash
# Format
ruff format src/

# ตรวจสอบ
ruff format --check src/

# Diff
ruff format --diff src/
```

**Configuration file (.ruff.toml):**

```toml
line-length = 88
target-version = "py310"

[lint]
select = ["E", "F", "I", "N", "UP", "B", "SIM"]
ignore = ["E501"]

[lint.per-file-ignores]
"tests/*" = ["S101"]

[format]
quote-style = "double"
```

**ตัวอย่างการใช้งานจริง:**

```python
# ❌ Bad code
import os
import sys
import json


def process(data):
    result = []
    for item in data:
        if item != None:
            result.append(item)
    return result


x = 1
```

```bash
ruff check bad_code.py
# bad_code.py:1:1: F401 [*] `os` imported but unused
# bad_code.py:2:1: F401 [*] `sys` imported but unused
# bad_code.py:3:1: F401 [*] `json` imported but unused
# bad_code.py:6:12: ANN001 Missing type annotation for function argument `data`
# bad_code.py:7:5: ANN202 Missing return type annotation for private function
# bad_code.py:9:19: E711 Comparison to `None` should be `cond is None`
# bad_code.py:13:1: F841 Local variable `x` is assigned to but never used

# Fix
ruff check --fix bad_code.py
# Fixed 4 errors
```

**After fix:**

```python
# ✅ Code after ruff --fix
def process(data):
    result = []
    for item in data:
        if item is not None:
            result.append(item)
    return result
```

**Ruff vs others:**

```bash
# Speed comparison (informal)
# ruff:   ~0.1s for 1000 files
# flake8: ~10s for 1000 files
# pylint: ~60s for 1000 files
```

**CI:**

```yaml
# .github/workflows/lint.yml
name: Lint

on: [push, pull_request]

jobs:
  ruff:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: chartboost/ruff-action@v1
        with:
          args: check --output-format=github

      - uses: chartboost/ruff-action@v1
        with:
          args: format --check
```

**Pre-commit:**

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
```

### 9.30.4 ข้อดี

- **เร็วมาก:** 10-100x เร็วกว่า
- **ครบ:** แทนหลาย tools
- **Auto-fix:** fix อัตโนมัติ
- **Modern:** rules ทันสมัย
- **Config:** เดียว

### 9.30.5 ข้อเสีย

- **New:** ใหม่กว่า
- **Less mature:** กว่า flake8
- **Rust:** binary

### 9.30.6 ข้อควรระวัง

```python
# ระวัง 1: Unsafe fixes
# ❌ fix โดยไม่ดู
ruff check --fix --unsafe-fixes

# ✅ review ก่อน

# ระวัง 2: Rules เยอะเกินไป
# ❌ select ALL
# ✅ เริ่มจากที่จำเป็น

# ระวัง 3: Conflicts กับ formatter
# ✅ ใช้ ruff format แทน black

# ระวัง 4: per-file-ignores
# ✅ configure ให้เหมาะ

# ระวัง 5: Auto-fix ใน CI
# ✅ CI ควร --check ไม่ใช่ --fix

# ระวัง 6: Version pinning
# ✅ pin version

# ระวัง 7: Migration
# ✅ ทำทีละขั้น
# ✅ เริ่มจาก rules ง่าย
```

### 9.30.7 สรุป

**Commands:**

```bash
ruff check src/           # Lint
ruff check --fix src/     # Auto-fix
ruff format src/          # Format
ruff format --check src/  # Check format
```

**Config:**

```toml
[tool.ruff]
line-length = 88
target-version = "py310"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "UP", "B", "SIM"]
ignore = ["E501"]
```

**Best practices:**
- ใช้ ruff แทน flake8/isort/black
- เริ่มจาก rules พื้นฐาน
- Auto-fix สำหรับ dev
- `--check` สำหรับ CI
- Pre-commit hooks
- Pin version

> **อ้างอิงเพิ่มเติม:** [Ruff Documentation](https://docs.astral.sh/ruff/)

---

## 9.31 bandit

### บทนำ

`bandit` เป็น security linter ที่หา common security issues ในโค้ด Python

### นิยาม

Bandit เป็น tool สำหรับหา security vulnerabilities ใน Python code

### 9.31.1 คืออะไร

**ตรวจสอบ:**
- SQL injection
- Command injection
- Hardcoded passwords
- Insecure crypto
- Unsafe YAML/pickle
- และอื่น ๆ

### 9.31.2 ทำงานอย่างไร

Bandit:
1. Parse code เป็น AST
2. รัน plugins
3. รายงาน issues ตาม severity/confidence

### 9.31.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install bandit
```

**รัน:**

```bash
bandit -r src/
bandit -r src/ -ll  # medium+
bandit -r src/ -lll  # high only

# Output:
# >> Issue: [B101:assert_used] Use of assert detected.
#    Severity: Low   Confidence: High
#    CWE: CWE-703 (https://cwe.mitre.org/data/definitions/703.html)
#    Location: src/validation.py:15:4
```

**Severity Levels:**
- LOW
- MEDIUM
- HIGH

**Confidence:**
- LOW
- MEDIUM
- HIGH

**Common Issues:**

```python
# B101: assert_used
assert user.is_admin  # ❌ ไม่ควรใช้ assert สำหรับ security

# B102: exec_used
exec(code)  # ❌

# B105/B106/B107: hardcoded_password
password = "secret123"  # ❌

# B301: pickle
import pickle
data = pickle.loads(untrusted)  # ❌

# B303: md5
import hashlib
hashlib.md5(data)  # ❌ อ่อนแอ

# B307: eval
eval(user_input)  # ❌

# B311: random
import random
random.random()  # ❌ ไม่ secure

# B324: hashlib
hashlib.sha1(data)  # ❌

# B501-B504: requests
requests.get(url, verify=False)  # ❌

# B602: subprocess_popen_with_shell_equals_true
subprocess.call(cmd, shell=True)  # ❌ command injection

# B608: hardcoded_sql_expressions
query = f"SELECT * FROM users WHERE id = {user_id}"  # ❌

# B701: jinja2_autoescape_false
jinja2.Environment(autoescape=False)  # ❌ XSS
```

**Configuration (.bandit):**

```yaml
# .bandit.yaml
exclude_dirs:
  - tests
  - .venv
  - venv

skips:
  - B101  # assert_used (OK ใน tests)

# Per test
assert_used:
  skips: ['*_test.py', 'test_*.py']

hardcoded_tmp_directory:
  tmp_dirs: ['/tmp', '/var/tmp', '/dev/shm']

# Severity
any_other_function_with_shell_equals_true:
  no_shell: [os.execl, os.execle, os.execlp, os.execlpe, os.execv,
             os.execve, os.execvp, os.execvpe, os.spawnl, os.spawnle,
             os.spawnlp, os.spawnlpe, os.spawnv, os.spawnve, os.spawnvp,
             os.spawnvpe, os.startfile]
```

**pyproject.toml:**

```toml
[tool.bandit]
exclude_dirs = ["tests", ".venv"]
skips = ["B101"]

[tool.bandit.assert_used]
skips = ["*/test_*.py"]
```

**Inline skip:**

```python
# Skip ทั้งบรรทัด
password = "test"  # nosec

# Skip เฉพาะ test
password = "test"  # nosec B105

# Skip block
# nosec
```

**Output formats:**

```bash
# Text (default)
bandit -r src/

# JSON
bandit -r src/ -f json -o report.json

# CSV
bandit -r src/ -f csv

# HTML
bandit -r src/ -f html -o report.html

# XML
bandit -r src/ -f xml
```

**ตัวอย่างการใช้งานจริง:**

```python
# ❌ Vulnerable code
import hashlib
import pickle
import subprocess
from flask import Flask, request

app = Flask(__name__)
SECRET_KEY = "hardcoded_secret_123"


@app.route("/login")
def login():
    user_id = request.args.get("user_id")
    query = f"SELECT * FROM users WHERE id = {user_id}"  # SQL injection
    db.execute(query)
    return "OK"


def process_data(data):
    return pickle.loads(data)  # Unsecure deserialization


def hash_password(password):
    return hashlib.md5(password.encode()).hexdigest()  # Weak hash


def run_command(cmd):
    return subprocess.call(cmd, shell=True)  # Command injection
```

```bash
bandit vulnerable.py
# >> Issue: [B105:hardcoded_password_string] Possible hardcoded password
#    Severity: Low   Confidence: Medium
#    Location: vulnerable.py:7:13

# >> Issue: [B608:hardcoded_sql_expressions] Possible SQL injection vector
#    Severity: Medium   Confidence: Low
#    Location: vulnerable.py:13:12

# >> Issue: [B301:blacklist] Pickle and modules that wrap it can be unsafe
#    Severity: Medium   Confidence: High
#    Location: vulnerable.py:18:11

# >> Issue: [B303:blacklist] Use of insecure MD2, MD4, MD5, or SHA1 hash
#    Severity: Medium   Confidence: High
#    Location: vulnerable.py:22:11

# >> Issue: [B602:subprocess_popen_with_shell_equals_true] subprocess call with shell=True
#    Severity: High   Confidence: High
#    Location: vulnerable.py:26:11
```

**Secure code:**

```python
# ✅ Secure code
import secrets
import sqlite3
import subprocess
import bcrypt
from flask import Flask, request

app = Flask(__name__)
SECRET_KEY = os.environ["SECRET_KEY"]  # จาก env


@app.route("/login")
def login():
    user_id = request.args.get("user_id")
    # Parameterized query
    cursor = db.execute(
        "SELECT * FROM users WHERE id = ?",
        (user_id,),
    )
    return "OK"


def process_data(data: dict) -> dict:
    # ใช้ JSON แทน pickle
    import json
    return json.loads(data)


def hash_password(password: str) -> bytes:
    # ใช้ bcrypt
    return bcrypt.hashpw(
        password.encode(),
        bcrypt.gensalt(),
    )


def run_command(args: list[str]) -> int:
    # ✅ shell=False (default)
    return subprocess.call(args, shell=False)


def generate_token() -> str:
    # ✅ cryptographically secure
    return secrets.token_urlsafe(32)
```

**CI:**

```yaml
# .github/workflows/security.yml
name: Security

on: [push, pull_request]

jobs:
  bandit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - run: pip install bandit[toml]

      - name: Run Bandit
        run: |
          bandit -r src/ \
            -c pyproject.toml \
            -f json \
            -o bandit-report.json \
            -ll

      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: bandit-report
          path: bandit-report.json

      - name: Check for issues
        run: bandit -r src/ -ll -q
```

### 9.31.4 ข้อดี

- **Security:** หาช่องโหว่
- **Standard:** rules ครบ
- **Configurable:** ปรับได้
- **CI:** integrate

### 9.31.5 ข้อเสีย

- **False positives:** อาจรายงานผิด
- **Limited:** ไม่ครอบคลุมทุกอย่าง
- **Context:** ไม่เข้าใจ business logic

### 9.31.6 ข้อควรระวัง

```python
# ระวัง 1: False positives
# ✅ review
# ✅ inline nosec พร้อมเหตุผล

# ระวัง 2: nosec มากเกินไป
# ❌ nosec ทุกที่
# ✅ เฉพาะที่จำเป็น

# ระวัง 3: Skips
# ❌ skip B105 ทั้งหมด
# ✅ ใช้ environment variables

# ระวัง 4: Severity levels
# ✅ -ll สำหรับ critical
# ✅ -lll สำหรับ strict

# ระวัง 5: Configuration
# ✅ exclude tests
# ✅ per-file configs

# ระวัง 6: CI fail
# ✅ เริ่มจาก -lll ก่อน
# ✅ ค่อย ๆ เข้มขึ้น

# ระวัง 7: ไม่ใช่ security ทั้งหมด
# ✅ ใช้ร่วมกับ tools อื่น
# ✅ manual review
```

### 9.31.7 สรุป

**Commands:**

```bash
bandit -r src/
bandit -r src/ -ll
bandit -r src/ -lll
bandit -r src/ -f json -o report.json
```

**Common Issues:**

| Code | ใช้ |
|------|-----|
| B101 | assert |
| B105 | hardcoded password |
| B301 | pickle |
| B303 | md5/sha1 |
| B307 | eval |
| B602 | shell=True |
| B608 | SQL injection |

**Best practices:**
- รันใน CI
- `-ll` สำหรับ medium+
- Config ใน pyproject.toml
- Exclude tests
- Review findings
- `# nosec` พร้อมเหตุผล

> **อ้างอิงเพิ่มเติม:** [Bandit Documentation](https://bandit.readthedocs.io/)

---

## 9.32 Black

### บทนำ

`black` เป็น code formatter ที่ไม่ต้องตั้งค่า (opinionated) ช่วยให้โค้ดมีรูปแบบเดียวกันทั้งทีม

### นิยาม

Black เป็น Python code formatter ที่ format อัตโนมัติ

### 9.32.1 คืออะไร

**ปรัชญา:**
- "Any color you like"
- ไม่ต้อง debate style
- Deterministic

### 9.32.2 ทำงานอย่างไร

Black:
1. Parse code
2. Re-format
3. Output

### 9.32.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install black
```

**รัน:**

```bash
# Format
black src/

# Check
black --check src/

# Diff
black --diff src/

# Specific file
black src/module.py

# Verbose
black -v src/
```

**Configuration (pyproject.toml):**

```toml
[tool.black]
line-length = 88
target-version = ['py310', 'py311', 'py312']
include = '\.pyi?$'
extend-exclude = '''
/(
    \.git
  | \.venv
  | build
  | dist
  | migrations
)/
'''
skip-string-normalization = false
skip-magic-trailing-comma = false
preview = false
```

**Before/After:**

```python
# Before
def long_function_name(
    arg1: int, arg2: str, arg3: float, arg4: dict,
    arg5: list, arg6: bool = False
) -> dict:
    result = {'key1': 'value1', 'key2': 'value2', 'key3': 'value3', 'key4': 'value4'}
    return result


# After black
def long_function_name(
    arg1: int,
    arg2: str,
    arg3: float,
    arg4: dict,
    arg5: list,
    arg6: bool = False,
) -> dict:
    result = {
        "key1": "value1",
        "key2": "value2",
        "key3": "value3",
        "key4": "value4",
    }
    return result
```

**String Normalization:**

```python
# Before
name = 'Alice'
message = "Hello"
docstring = '''Multi
line'''

# After
name = "Alice"
message = "Hello"
docstring = """Multi
line"""
```

**Skip:**

```python
# fmt: off
matrix = [
    1, 0, 0,
    0, 1, 0,
    0, 0, 1,
]
# fmt: on
```

**pyproject.toml:**

```toml
[tool.black]
line-length = 88
target-version = ["py310"]

[tool.black]
# หรือใช้ ruff format แทน
```

**Pre-commit:**

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/psf/black
    rev: 23.12.0
    hooks:
      - id: black
        language_version: python3.12
```

**ตัวอย่างการใช้งานจริง:**

```python
# ❌ Before
from typing import List, Dict, Optional
import os, sys

def process(items: List[Dict[str, int]], threshold: int=100, verbose: bool=False) -> Optional[Dict[str, int]]:
    if not items: return None
    result = {k: v for d in items for k, v in d.items() if v > threshold}
    return result if result else None

class Calculator:
    def __init__(self, value: float=0): self.value=value
    def add(self, x): self.value += x; return self
    def multiply(self, x): self.value *= x; return self
```

```bash
black example.py
```

```python
# ✅ After
import os
import sys
from typing import Dict, List, Optional


def process(
    items: List[Dict[str, int]],
    threshold: int = 100,
    verbose: bool = False,
) -> Optional[Dict[str, int]]:
    if not items:
        return None
    result = {k: v for d in items for k, v in d.items() if v > threshold}
    return result if result else None


class Calculator:
    def __init__(self, value: float = 0):
        self.value = value

    def add(self, x):
        self.value += x
        return self

    def multiply(self, x):
        self.value *= x
        return self
```

**Line Length:**

```python
# line-length = 88 (default)

# 88 chars หรือน้อยกว่า → บรรทัดเดียว
result = some_function(argument1, argument2, argument3, argument4)

# เกิน → แยกบรรทัด
result = some_function(
    argument1,
    argument2,
    argument3,
    argument4,
)
```

**Trailing Comma:**

```python
# With trailing comma → explode
result = some_function(
    arg1,
    arg2,
)

# Without → try to fit
result = some_function(arg1, arg2)
```

**CI:**

```yaml
# .github/workflows/format.yml
name: Format

on: [push, pull_request]

jobs:
  black:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - run: pip install black

      - name: Check formatting
        run: black --check --diff src/
```

### 9.32.4 ข้อดี

- **No config:** ไม่ต้อง debate
- **Deterministic:** ผลเดียวกันเสมอ
- **Fast:** เร็ว
- **Standard:** ใช้กันมาก

### 9.32.5 ข้อเสีย

- **Opinionated:** ไม่ยืดหยุ่น
- **Changes:** อาจต่างจาก style เดิม
- **Conflicts:** กับ flake8

### 9.32.6 ข้อควรระวัง

```python
# ระวัง 1: Conflicts กับ flake8
# E203, W503 → ignore ใน flake8

# ระวัง 2: Line length
# Black ใช้ 88 (ไม่ใช่ 79)
max-line-length = 88  # flake8

# ระวัง 3: skip-string-normalization
# ⚠️ อาจไม่ consistent
# ✅ เปิด (default)

# ระวัง 4: Preview features
# ⚠️ อาจเปลี่ยน
# ✅ ปิดใน production

# ระวัง 5: Large diff
# format ทั้งโปรเจกต์ → diff ใหญ่
# ✅ ทีละ module

# ระวัง 6: Git blame
# format → blame หาย
# ✅ ใช้ .git-blame-ignore-revs

# ระวัง 7: ruff format
# ruff format แทน black ได้
# ✅ เลือกอันเดียว
```

### 9.32.7 สรุป

**Commands:**

```bash
black src/
black --check src/
black --diff src/
```

**Config:**

```toml
[tool.black]
line-length = 88
target-version = ["py310"]
```

**Best practices:**
- ใช้ black หรือ ruff format
- Pre-commit hook
- CI check
- line-length 88
- ignore E203, W503 ใน flake8
- อย่า format มือ

> **อ้างอิงเพิ่มเติม:** [Black Documentation](https://black.readthedocs.io/)

---

## 9.33 isort

### บทนำ

`isort` เป็น tool สำหรับจัดเรียง imports ตามมาตรฐาน

### นิยาม

isort เป็น Python utility ที่จัดเรียง imports อัตโนมัติ

### 9.33.1 คืออะไร

**จัดเรียง:**
1. Standard library
2. Third-party
3. Local imports

แต่ละกลุ่มเรียงตามตัวอักษร

### 9.33.2 ทำงานอย่างไร

isort:
1. Parse imports
2. แบ่งกลุ่ม
3. เรียง
4. Output

### 9.33.3 การใช้งาน

**ติดตั้ง:**

```bash
pip install isort
```

**รัน:**

```bash
isort src/
isort --check src/
isort --diff src/
```

**Before/After:**

```python
# Before
from myproject import utils
import sys
import os
from typing import Any, Optional
import requests
from myproject.models import User
import json


# After
import json
import os
import sys
from typing import Any, Optional

import requests

from myproject import utils
from myproject.models import User
```

**Configuration:**

```toml
# pyproject.toml
[tool.isort]
profile = "black"
line_length = 88
multi_line_output = 3
include_trailing_comma = true
force_grid_wrap = 0
use_parentheses = true
ensure_newline_before_comments = true

# กลุ่ม
known_first_party = ["src"]
known_third_party = ["pytest", "httpx"]
known_local_folder = ["scripts", "tools"]

# Section
sections = [
    "FUTURE",
    "STDLIB",
    "THIRDPARTY",
    "FIRSTPARTY",
    "LOCALFOLDER",
]

# Force
force_single_line = false
force_sort_within_sections = false
```

**Profiles:**

```toml
[tool.isort]
profile = "black"  # สำหรับ black
# profile = "django"
# profile = "google"
# profile = "pycharm"
```

**จัดเรียงตาม Type:**

```python
# With isort
import os
import sys
from typing import Any

import requests
from pydantic import BaseModel

from myproject.models import User
from myproject.utils import helper
```

**Force single line:**

```toml
force_single_line = true
```

```python
import os
import sys
from typing import Any
from typing import Dict
from typing import List
```

**ตัวอย่างการใช้งานจริง:**

```python
# ❌ Before isort
from __future__ import annotations
import json
from src.utils import helper
import sys
import os
from typing import Any, Dict, List
from src.models import User, Post
import requests
from pydantic import BaseModel
import logging


# ✅ After isort
from __future__ import annotations

import json
import logging
import os
import sys
from typing import Any, Dict, List

import requests
from pydantic import BaseModel

from src.models import Post, User
from src.utils import helper
```

**Skip:**

```python
# isort: skip
from module import something  # isort: skip

# isort: off
from a import z
from b import a
# isort: on
```

**CI:**

```yaml
# .github/workflows/lint.yml
- name: isort
  run: isort --check --diff src/ tests/
```

**Pre-commit:**

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/PyCQA/isort
    rev: 5.13.2
    hooks:
      - id: isort
        args: [--profile=black]
```

### 9.33.4 ข้อดี

- **Standard:** จัดเรียงอัตโนมัติ
- **Configurable:** ปรับได้
- **Profiles:** สำหรับ black/django
- **Fast:** เร็ว

### 9.33.5 ข้อเสีย

- **Extra step:** ต้องรัน
- **Config:** ต้องตั้งค่า
- **Ruff:** มี isort built-in

### 9.33.6 ข้อควรระวัง

```python
# ระวัง 1: Conflicts กับ black
# ✅ profile = "black"
# ✅ line_length เท่ากัน

# ระวัง 2: First vs Third party
# ✅ configure known_first_party

# ระวัง 3: Circular imports
# isort ไม่แก้ circular
# ✅ refactor

# ระวัง 4: __init__.py
# F401 ใน __init__ เป็นเรื่องปกติ
# ✅ per-file-ignores

# ระวัง 5: ruff แทน isort
# ruff มี "I" rules
# ✅ ใช้ ruff ถ้าใช้ ruff อยู่แล้ว

# ระวัง 6: force_single_line
# ⚠️ ทำให้ imports ยาว
# ✅ ปิด (default)

# ระวัง 7: Conditional imports
# isort อาจสับสน
# ✅ # isort: skip
```

### 9.33.7 สรุป

**Commands:**

```bash
isort src/
isort --check src/
isort --diff src/
```

**Config:**

```toml
[tool.isort]
profile = "black"
known_first_party = ["src"]
```

**Section order:**
1. `__future__`
2. Standard library
3. Third-party
4. First-party
5. Local

**Best practices:**
- `profile = "black"`
- Config known_first_party
- Pre-commit hook
- CI check
- ใช้ ruff "I" rules ถ้าใช้ ruff

> **อ้างอิงเพิ่มเติม:** [isort Documentation](https://pycqa.github.io/isort/)

---

## 9.34 Code Review

### บทนำ

Code Review เป็นกระบวนการตรวจสอบโค้ดโดยเพื่อนร่วมทีม ช่วยหาปัญหา แชร์ความรู้ และรักษาคุณภาพ

### นิยาม

Code Review คือการที่ developers ตรวจสอบโค้ดของกันและกันก่อน merge

### 9.34.1 คืออะไร

**เป้าหมาย:**
- หา bugs
- ปรับปรุงคุณภาพ
- แชร์ความรู้
- รักษามาตรฐาน
- ลด technical debt

### 9.34.2 ทำงานอย่างไร

Process:
1. Developer สร้าง PR
2. Reviewer อ่านโค้ด
3. Comment/suggest
4. Developer แก้
5. Approve
6. Merge

### 9.34.3 การใช้งาน

**Pull Request Template:**

```markdown
<!-- .github/pull_request_template.md -->
## Description
<!-- อธิบายการเปลี่ยนแปลง -->

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation

## Related Issues
Closes #123

## How Has This Been Tested?
<!-- อธิบายการทดสอบ -->

## Checklist
- [ ] Tests pass
- [ ] Linting passes
- [ ] Type checking passes
- [ ] Documentation updated
- [ ] No breaking changes (or documented)

## Screenshots (ถ้ามี)
```

**Review Guidelines:**

```markdown
<!-- CONTRIBUTING.md -->
# Code Review Guidelines

## สำหรับ Author
- PR เล็ก (ไม่เกิน 400 บรรทัด)
- Description ชัดเจน
- Tests ครบ
- Self-review ก่อน
- ตอบ comments ทุกอัน

## สำหรับ Reviewer
- ตรวจสอบภายใน 24 ชั่วโมง
- ให้ feedback สร้างสรรค์
- แยก critical vs nitpick
- อธิบายเหตุผล
- Approve ถ้าพร้อม
```

**Comment Types:**

```python
# [blocking] ต้องแก้ก่อน merge
# [suggestion] ควรแก้ แต่ไม่ blocking
# [question] คำถาม
# [nitpick] เล็กน้อย
# [praise] ชื่นชม
```

**ตัวอย่าง Review:**

```python
# PR: Add user validation

# Reviewer comment:
# [blocking] ไม่ควรใช้ assert สำหรับ user input
# เพราะ assert ถูกปิดด้วย -O flag
def validate_user(user):
    assert user.email, "Email required"  # ❌

# [suggestion] ควรใช้ explicit check
def validate_user(user):
    if not user.email:
        raise ValueError("Email required")
```

**Review Tools:**

```bash
# GitHub CLI
gh pr create
gh pr review --approve
gh pr review --request-changes

# GitLab
glab mr create
glab mr approve

# Gerrit
git review
```

**Review Checklist:**

```markdown
## Code Review Checklist

### Functionality
- [ ] ทำงานตาม requirements
- [ ] Edge cases handled
- [ ] Error handling เหมาะสม

### Design
- [ ] Structure ชัดเจน
- [ ] Single responsibility
- [ ] ไม่มี duplication
- [ ] Abstraction เหมาะสม

### Readability
- [ ] ชื่อสื่อความหมาย
- [ ] Comments ที่จำเป็น
- [ ] ไม่ซับซ้อนเกิน

### Testing
- [ ] Tests ครอบคลุม
- [ ] Test quality ดี
- [ ] Edge cases tested

### Security
- [ ] ไม่มี vulnerabilities
- [ ] Input validated
- [ ] Secrets ไม่ hardcoded

### Performance
- [ ] ไม่มี obvious bottlenecks
- [ ] Efficient algorithms
- [ ] ไม่มี N+1 queries

### Style
- [ ] ตาม style guide
- [ ] Formatting consistent
- [ ] No linting errors
```

**ตัวอย่างการใช้งานจริง — PR:**

```python
# src/user_service.py
"""User service module."""

from dataclasses import dataclass
from typing import Optional


@dataclass
class User:
    id: int
    name: str
    email: str


class UserService:
    """Service for user operations."""

    def __init__(self, repository):
        self._repository = repository

    def create_user(self, name: str, email: str) -> User:
        """Create a new user.

        Args:
            name: User's name.
            email: User's email.

        Returns:
            Created user.

        Raises:
            ValueError: If name or email is invalid.
        """
        if not name:
            raise ValueError("Name cannot be empty")

        if "@" not in email:
            raise ValueError("Invalid email format")

        existing = self._repository.find_by_email(email)
        if existing:
            raise ValueError(f"Email already exists: {email}")

        user = User(id=0, name=name, email=email)
        return self._repository.save(user)
```

**Good PR:**

```markdown
## Description
เพิ่ม validation สำหรับ email ใน UserService

## Changes
- เพิ่ม email format validation
- เพิ่ม duplicate email check
- เพิ่ม tests สำหรับ edge cases

## Testing
- Unit tests: 15 passed
- Coverage: 95%
- Manual: tested with Postman

## Related Issues
Closes #456
```

**Review Comments:**

```markdown
## Review

### src/user_service.py

Line 25:
```python
if "@" not in email:
```
[suggestion] ควรใช้ regex สำหรับ email validation ที่แม่นยำกว่า

Line 30:
```python
existing = self._repository.find_by_email(email)
```
[question] ถ้า repository ล่มจะทำอย่างไร?

### tests/test_user_service.py
[praise] Tests ครอบคลุมดีมาก

### Overall
✅ Approved with minor suggestions
```

**Common Review Issues:**

```python
# 1. Naming
# ❌
def calc(a, b):
    return a + b

# ✅
def add_numbers(a: int, b: int) -> int:
    return a + b


# 2. Magic numbers
# ❌
if age > 18:
    pass

# ✅
ADULT_AGE = 18
if age > ADULT_AGE:
    pass


# 3. Long functions
# ❌ 100+ บรรทัด
def process_everything(data):
    # ... 100 บรรทัด
    pass

# ✅ แยก
def extract(data): ...
def transform(data): ...
def load(data): ...


# 4. Deep nesting
# ❌
def process(items):
    if items:
        for item in items:
            if item.valid:
                if item.active:
                    process(item)

# ✅ early return
def process(items):
    if not items:
        return

    for item in items:
        if not item.valid or not item.active:
            continue
        process(item)


# 5. Duplication
# ❌
def process_user(user):
    validate(user.email)
    save(user)

def process_admin(admin):
    validate(admin.email)
    save(admin)

# ✅
def process_entity(entity):
    validate(entity.email)
    save(entity)
```

**Review Automation:**

```yaml
# .github/workflows/review.yml
name: PR Checks

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
      - run: pip install -e ".[dev]"
      - run: ruff check src/
      - run: mypy src/

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
      - run: pip install -e ".[dev]"
      - run: pytest --cov=src --cov-fail-under=80

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: pip install bandit
      - run: bandit -r src/ -ll

  size:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check PR size
        run: |
          LINES=$(git diff --stat origin/main...HEAD | tail -1 | awk '{print $1}')
          if [ "$LINES" -gt 500 ]; then
            echo "⚠️ PR ใหญ่เกินไป: $LINES บรรทัด"
            exit 1
          fi
```

### 9.34.4 ข้อดี

- **Quality:** คุณภาพสูงขึ้น
- **Knowledge:** แชร์ความรู้
- **Bugs:** หา bugs เร็ว
- **Standards:** รักษามาตรฐาน
- **Mentoring:** สอนกัน

### 9.34.5 ข้อเสีย

- **Time:** ใช้เวลา
- **Conflict:** อาจขัดแย้ง
- **Bottleneck:** รอ review
- **Subjectivity:** ความคิดเห็น

### 9.34.6 ข้อควรระวัง

```python
# ระวัง 1: PR ใหญ่เกินไป
# ❌ 1000+ บรรทัด
# ✅ < 400 บรรทัด

# ระวัง 2: Nitpick มากเกินไป
# ✅ focus ที่สำคัญ

# ระวัง 3: Personal attacks
# ❌ "โค้ดแย่มาก"
# ✅ "ตรงนี้สามารถปรับได้..."

# ระวัง 4: Review ผิวเผิน
# ✅ อ่านจริง ๆ

# ระวัง 5: Delay
# ✅ review ภายใน 24 ชม.

# ระวัง 6: Rubber stamp
# ❌ approve ทันที
# ✅ review จริง

# ระวัง 7: Blocking โดยไม่มีเหตุผล
# ✅ อธิบายและเสนอทางออก
```

### 9.34.7 สรุป

**Process:**
1. สร้าง PR
2. Reviewer อ่าน
3. Comment
4. แก้ไข
5. Approve
6. Merge

**Comment types:**
- `[blocking]` — ต้องแก้
- `[suggestion]` — ควรแก้
- `[question]` — ถาม
- `[nitpick]` — เล็กน้อย
- `[praise]` — ชื่นชม

**Best practices:**
- PR เล็ก
- Description ชัดเจน
- Review เร็ว
- Constructive feedback
- Automate ที่ทำได้
- Checklist

> **อ้างอิงเพิ่มเติม:** [Google Engineering Practices](https://google.github.io/eng-practices/review/)

---

## 9.35 Refactoring

### บทนำ

Refactoring คือการปรับปรุงโครงสร้างโค้ดโดยไม่เปลี่ยน behavior เพื่อเพิ่มคุณภาพและ maintainability

### นิยาม

Refactoring คือการเปลี่ยนแปลงโครงสร้างภายในของโค้ดโดยไม่เปลี่ยน external behavior

### 9.35.1 คืออะไร

**เป้าหมาย:**
- อ่านง่ายขึ้น
- Maintain ง่ายขึ้น
- ลด duplication
- ลด complexity
- เพิ่ม testability

### 9.35.2 ทำงานอย่างไร

Refactoring:
1. มี tests ครอบคลุม
2. เปลี่ยนโครงสร้าง
3. รัน tests
4. ถ้า pass → ทำต่อ
5. ถ้า fail → แก้

### 9.35.3 การใช้งาน

**Extract Function:**

```python
# ❌ Before
def process_order(order):
    # Validate
    if not order.items:
        raise ValueError("Empty order")
    if order.total < 0:
        raise ValueError("Invalid total")

    # Calculate
    subtotal = sum(item.price * item.qty for item in order.items)
    tax = subtotal * 0.07
    total = subtotal + tax

    # Save
    db.save(order)
    email.send(order.customer, f"Total: {total}")

    return total


# ✅ After
def validate_order(order) -> None:
    if not order.items:
        raise ValueError("Empty order")
    if order.total < 0:
        raise ValueError("Invalid total")


def calculate_total(order) -> float:
    subtotal = sum(item.price * item.qty for item in order.items)
    tax = subtotal * 0.07
    return subtotal + tax


def process_order(order) -> float:
    validate_order(order)
    total = calculate_total(order)
    db.save(order)
    email.send(order.customer, f"Total: {total}")
    return total
```

**Extract Variable:**

```python
# ❌ Before
if user.age >= 18 and user.country == "TH" and user.verified:
    allow_access()

# ✅ After
is_adult = user.age >= 18
is_thai = user.country == "TH"
is_verified = user.verified

if is_adult and is_thai and is_verified:
    allow_access()
```

**Rename:**

```python
# ❌ Before
def calc(a, b, c):
    return a * b + c

# ✅ After
def calculate_price(base_price: float, quantity: int, shipping: float) -> float:
    return base_price * quantity + shipping
```

**Introduce Parameter Object:**

```python
# ❌ Before
def create_user(name, email, age, country, city):
    ...

# ✅ After
@dataclass
class UserInfo:
    name: str
    email: str
    age: int
    country: str
    city: str

def create_user(info: UserInfo):
    ...
```

**Replace Conditional with Polymorphism:**

```python
# ❌ Before
def calculate_pay(employee):
    if employee.type == "hourly":
        return employee.hours * employee.rate
    elif employee.type == "salaried":
        return employee.salary
    elif employee.type == "commission":
        return employee.sales * employee.commission_rate

# ✅ After
from abc import ABC, abstractmethod

class Employee(ABC):
    @abstractmethod
    def calculate_pay(self) -> float:
        pass

class HourlyEmployee(Employee):
    def calculate_pay(self) -> float:
        return self.hours * self.rate

class SalariedEmployee(Employee):
    def calculate_pay(self) -> float:
        return self.salary

class CommissionEmployee(Employee):
    def calculate_pay(self) -> float:
        return self.sales * self.commission_rate
```

**Replace Magic Numbers:**

```python
# ❌ Before
def calculate_tax(amount):
    return amount * 0.07

def is_adult(age):
    return age >= 18

# ✅ After
VAT_RATE = 0.07
ADULT_AGE = 18

def calculate_tax(amount):
    return amount * VAT_RATE

def is_adult(age):
    return age >= ADULT_AGE
```

**Simplify Conditionals:**

```python
# ❌ Before
def get_status(user):
    if user.is_active:
        if user.is_verified:
            return "active"
        else:
            return "pending"
    else:
        return "inactive"

# ✅ After
def get_status(user):
    if not user.is_active:
        return "inactive"
    if user.is_verified:
        return "active"
    return "pending"
```

**Remove Duplication:**

```python
# ❌ Before
def process_csv(path):
    with open(path) as f:
        reader = csv.reader(f)
        return [row for row in reader]

def process_json(path):
    with open(path) as f:
        return json.load(f)

# ✅ After
def read_file(path):
    with open(path) as f:
        return f.read()

def process_csv(path):
    content = read_file(path)
    return list(csv.reader(content.splitlines()))

def process_json(path):
    content = read_file(path)
    return json.loads(content)
```

**ตัวอย่างการใช้งานจริง — Refactoring Legacy:**

```python
# ❌ Before
def process(data):
    r = []
    for d in data:
        if d['type'] == 'A':
            v = d['value'] * 1.1
            if v > 100:
                v = 100
            r.append(v)
        elif d['type'] == 'B':
            v = d['value'] * 0.9
            if v < 0:
                v = 0
            r.append(v)
        elif d['type'] == 'C':
            v = d['value'] * 1.5
            r.append(v)
    return r


# ✅ After
from dataclasses import dataclass
from enum import Enum
from typing import Protocol


class ItemType(Enum):
    A = "A"
    B = "B"
    C = "C"


class Transformer(Protocol):
    def transform(self, value: float) -> float: ...


class TypeATransformer:
    MAX_VALUE = 100
    MULTIPLIER = 1.1

    def transform(self, value: float) -> float:
        result = value * self.MULTIPLIER
        return min(result, self.MAX_VALUE)


class TypeBTransformer:
    MIN_VALUE = 0
    MULTIPLIER = 0.9

    def transform(self, value: float) -> float:
        result = value * self.MULTIPLIER
        return max(result, self.MIN_VALUE)


class TypeCTransformer:
    MULTIPLIER = 1.5

    def transform(self, value: float) -> float:
        return value * self.MULTIPLIER


TRANSFORMERS: dict[ItemType, Transformer] = {
    ItemType.A: TypeATransformer(),
    ItemType.B: TypeBTransformer(),
    ItemType.C: TypeCTransformer(),
}


def transform_value(item: dict) -> float:
    item_type = ItemType(item["type"])
    transformer = TRANSFORMERS[item_type]
    return transformer.transform(item["value"])


def process(data: list[dict]) -> list[float]:
    return [transform_value(item) for item in data]
```

**Refactoring Tools:**

```bash
# Rope
pip install rope

# PyCharm — built-in refactoring
# VS Code — Pylance refactoring
```

**Automated Refactoring:**

```bash
# autoflake — ลบ unused imports/variables
pip install autoflake
autoflake --in-place --remove-all-unused-imports src/

# pyupgrade — modernize syntax
pip install pyupgrade
pyupgrade --py312-plus src/*.py

# flynt — f-string conversion
pip install flynt
flynt src/

# refurb — modernize
pip install refurb
refurb src/
```

### 9.35.4 ข้อดี

- **Quality:** โค้ดดีขึ้น
- **Maintainability:** ดูแลง่าย
- **Testability:** test ง่าย
- **Performance:** อาจเร็วขึ้น
- **Understanding:** เข้าใจง่าย

### 9.35.5 ข้อเสีย

- **Time:** ใช้เวลา
- **Risk:** อาจ introduce bugs
- **Diff:** diff ใหญ่
- **Scope:** อาจขยายเรื่อย ๆ

### 9.35.6 ข้อควรระวัง

```python
# ระวัง 1: ไม่มี tests
# ❌ refactor โดยไม่มี tests
# ✅ tests ก่อน

# ระวัง 2: เปลี่ยน behavior
# refactoring = ไม่เปลี่ยน behavior
# ✅ รัน tests ทุกครั้ง

# ระวัง 3: Refactor ใหญ่เกินไป
# ✅ ทีละ step เล็ก ๆ

# ระวัง 4: Mix กับ feature
# ❌ PR เดียว: refactor + feature
# ✅ แยก PRs

# ระวัง 5: Premature abstraction
# ✅ รอจนมี pattern ชัดเจน

# ระวัง 6: Over-engineering
# ✅ Simple > Clever

# ระวัง 7: Git blame
# ✅ แยก commits
# ✅ .git-blame-ignore-revs
```

### 9.35.7 สรุป

**Techniques:**
- Extract Function
- Extract Variable
- Rename
- Introduce Parameter Object
- Replace Conditional with Polymorphism
- Remove Duplication
- Simplify Conditionals

**Tools:**
- `autoflake`
- `pyupgrade`
- `flynt`
- `refurb`

**Best practices:**
- Tests ก่อน
- ทีละ step
- รัน tests ทุกครั้ง
- ไม่เปลี่ยน behavior
- แยกจาก feature
- Commit บ่อย

> **อ้างอิงเพิ่มเติม:** [Refactoring Guru](https://refactoring.guru/refactoring), [Martin Fowler — Refactoring](https://martinfowler.com/books/refactoring.html)

---

## 9.36 Technical Debt

### บทนำ

Technical Debt คือ "หนี้" ที่เกิดจากการเลือกทางลัดในการพัฒนา ต้อง "จ่ายคืน" ด้วย refactoring

### นิยาม

Technical Debt คือ cost ในอนาคตที่เกิดจาก shortcuts ในปัจจุบัน

### 9.36.1 คืออะไร

**ที่มา:**
- Deadlines
- Lack of knowledge
- Changing requirements
- Poor design
- Skipped tests

**Types:**
- **Deliberate:** ตั้งใจ
- **Inadvertent:** ไม่ตั้งใจ
- **Reckless:** ไม่ระวัง
- **Prudent:** รอบคอบ

### 9.36.2 ทำงานอย่างไร

Debt:
1. สร้าง
2. สะสม
3. ดอกเบี้ย (แก้ยากขึ้น)
4. ต้องจ่าย (refactor)

### 9.36.3 การใช้งาน

**Identifying Debt:**

```python
# TODO comments
# TODO: Refactor this function
# FIXME: This is a hack
# HACK: Temporary workaround
# XXX: This is broken
```

```bash
# หา TODO/FIXME
grep -rn "TODO\|FIXME\|HACK\|XXX" src/
```

**Tracking Debt:**

```markdown
<!-- tech-debt.md -->
# Technical Debt Register

## High Priority

### TD-001: Duplicated validation logic
- **Location:** `src/user.py`, `src/admin.py`
- **Impact:** Bug fixes ต้องแก้ 2 ที่
- **Effort:** 2 days
- **Priority:** High

### TD-002: Missing tests for payment module
- **Location:** `src/payment.py`
- **Impact:** ไม่กล้า refactor
- **Effort:** 3 days
- **Priority:** High

## Medium Priority

### TD-003: Outdated dependencies
- **Location:** `requirements.txt`
- **Impact:** Security vulnerabilities
- **Effort:** 1 day
- **Priority:** Medium

## Low Priority

### TD-004: Inconsistent naming
- **Location:** `src/utils/`
- **Impact:** อ่านยาก
- **Effort:** 4 hours
- **Priority:** Low
```

**Measuring Debt:**

```python
# วัดด้วย tools
# radon — complexity
# vulture — dead code
# pylint — code smells

# radon
pip install radon
radon cc src/  # cyclomatic complexity
radon mi src/  # maintainability index
radon raw src/ # raw metrics
```

**radon output:**

```
src/complex.py
    F 10:0 calculate - A (3)
    F 20:0 process - C (15)  # ❌ สูง
    F 30:0 handle - B (8)

src/simple.py
    F 1:0 add - A (1)
```

**Complexity Grades:**
- A: 1-5 (ดี)
- B: 6-10 (OK)
- C: 11-20 (ควรปรับ)
- D: 21-30 (แย่)
- E: 31-40 (แย่มาก)
- F: 41+ (ต้องแก้)

**vulture:**

```bash
pip install vulture
vulture src/
# src/utils.py:10: unused function 'old_helper' (60% confidence)
# src/models.py:25: unused variable 'temp' (60% confidence)
```

**Managing Debt:**

```python
# 1. ทำ visible
# TODO: [TD-001] Refactor validation
def validate(data):
    pass


# 2. จัดลำดับความสำคัญ
# Impact × Probability / Effort


# 3. วางแผน
# - Sprint ละ %
# - Tech debt sprint
# - Boy scout rule


# 4. วัด
# - Code coverage
# - Complexity
# - Bug rate
# - Velocity
```

**Boy Scout Rule:**

```python
# "Leave the code better than you found it"

# ❌ แก้ feature โดยไม่แตะ
def process(data):
    # ... existing messy code
    pass

# ✅ improve เล็กน้อย
def process(data: list[dict]) -> list[dict]:
    """Process data items."""
    # ... existing code
    return [item for item in data if item.get("valid")]
```

**ตัวอย่างการใช้งานจริง — Debt Reduction:**

```python
# Before: Technical debt ใน code

# src/payment.py
def process_payment(amount, type, user_id, card=None, bank=None):
    """Legacy payment processing — ต้อง refactor"""
    # TODO: [TD-005] แยกตาม payment type
    # FIXME: [TD-006] ไม่มี error handling
    if type == "card":
        if card:
            result = charge_card(card, amount)
        else:
            result = {"error": "no card"}
    elif type == "bank":
        if bank:
            result = charge_bank(bank, amount)
        else:
            result = {"error": "no bank"}
    elif type == "wallet":
        result = charge_wallet(user_id, amount)
    else:
        result = {"error": "unknown type"}

    return result
```

```python
# After: Refactored

from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum
from typing import Protocol


class PaymentError(Exception):
    """Payment processing error."""


class PaymentMethod(Protocol):
    def charge(self, amount: float) -> dict: ...


@dataclass
class CardPayment:
    card_number: str
    cvv: str

    def charge(self, amount: float) -> dict:
        if not self.card_number:
            raise PaymentError("Card number required")
        return {"status": "success", "amount": amount}


@dataclass
class BankPayment:
    account: str

    def charge(self, amount: float) -> dict:
        if not self.account:
            raise PaymentError("Account required")
        return {"status": "success", "amount": amount}


class WalletPayment:
    def __init__(self, user_id: str):
        self._user_id = user_id

    def charge(self, amount: float) -> dict:
        return {"status": "success", "amount": amount}


class PaymentProcessor:
    def __init__(self):
        self._methods: dict[str, type[PaymentMethod]] = {
            "card": CardPayment,
            "bank": BankPayment,
        }

    def process(
        self,
        method: str,
        amount: float,
        **kwargs,
    ) -> dict:
        if method == "wallet":
            return WalletPayment(kwargs["user_id"]).charge(amount)

        if method not in self._methods:
            raise PaymentError(f"Unknown payment method: {method}")

        payment = self._methods[method](**kwargs)
        return payment.charge(amount)
```

**Debt Metrics:**

```python
# scripts/debt_report.py
"""Generate technical debt report."""
import subprocess
import json
from pathlib import Path


def count_todos(src_dir: Path) -> dict[str, int]:
    """Count TODO/FIXME comments."""
    counts = {"TODO": 0, "FIXME": 0, "HACK": 0, "XXX": 0}

    for py_file in src_dir.rglob("*.py"):
        content = py_file.read_text()
        for key in counts:
            counts[key] += content.count(f"# {key}")

    return counts


def get_complexity(src_dir: Path) -> list[dict]:
    """Get complexity from radon."""
    result = subprocess.run(
        ["radon", "cc", str(src_dir), "-j"],
        capture_output=True,
        text=True,
    )
    data = json.loads(result.stdout)

    issues = []
    for file, items in data.items():
        for item in items:
            if item["complexity"] >= 11:
                issues.append({
                    "file": file,
                    "name": item["name"],
                    "complexity": item["complexity"],
                })

    return issues


def generate_report(src_dir: Path) -> dict:
    return {
        "todos": count_todos(src_dir),
        "high_complexity": get_complexity(src_dir),
    }


if __name__ == "__main__":
    report = generate_report(Path("src"))
    print(json.dumps(report, indent=2))
```

### 9.36.4 ข้อดี

- **Visibility:** เห็น debt
- **Planning:** วางแผนได้
- **Priority:** จัดลำดับ
- **Communication:** สื่อสาร

### 9.36.5 ข้อเสีย

- **Overwhelming:** อาจเยอะ
- **Time:** ใช้เวลา
- **Subjectivity:** ตัดสินยาก
- **Pressure:** อาจกดดัน

### 9.36.6 ข้อควรระวัง

```python
# ระวัง 1: สร้าง debt โดยไม่รู้
# ✅ conscious decisions
# ✅ document ถ้าตั้งใจ

# ระวัง 2: Debt ไม่มีวันหมด
# ✅ จัดการเป็น ongoing
# ✅ % ของ sprint

# ระวัง 3: Focus เฉพาะ debt
# ❌ หยุด feature
# ✅ สมดุล

# ระวัง 4: ไม่ document
# ✅ TODO พร้อม ID
# ✅ debt register

# ระวัง 5: Debt ที่ไม่สำคัญ
# ✅ focus ที่ impactful

# ระวัง 6: Over-measuring
# ✅ metrics ที่ useful

# ระวัง 7: Blame
# ❌ กล่าวโทษ
# ✅ improve
```

### 9.36.7 สรุป

**Types:**
- Deliberate vs Inadvertent
- Reckless vs Prudent

**Measuring:**
- `radon` — complexity
- `vulture` — dead code
- `TODO`/`FIXME` counts
- Coverage
- Bug rate

**Managing:**
- Document (debt register)
- Prioritize (impact × probability / effort)
- Plan (sprint %)
- Measure
- Boy Scout Rule

**Best practices:**
- ทำ visible
- จัดลำดับ
- วางแผน
- วัด
- สมดุล
- ไม่ blame

> **อ้างอิงเพิ่มเติม:** [Martin Fowler — Technical Debt](https://martinfowler.com/bliki/TechnicalDebt.html)

---

## สรุปภาค 9

ภาค 9 ครอบคลุมการทดสอบและคุณภาพโค้ด:

**Testing:**
- Unit Testing
- unittest
- pytest
- doctest
- Fixtures
- Mocking
- unittest.mock
- pytest-mock
- Parameterized Tests
- Coverage
- coverage.py
- pytest-cov

**Advanced Testing:**
- Integration Testing
- End-to-End Testing
- Regression Testing
- Performance Testing
- Load Testing
- Security Testing
- Property-Based Testing
- Hypothesis
- BDD
- behave
- pytest-bdd
- TDD

**Code Quality:**
- Static Analysis
- mypy
- pyright
- pylint
- flake8
- ruff
- bandit
- black
- isort

**Process:**
- Code Review
- Refactoring
- Technical Debt

**ก้าวต่อไป:** เล่ม 4 จะเข้าสู่แพ็กเกจ โมดูล สถาปัตยกรรม และเครื่องมือ

---

**อ้างอิงหลักของเล่ม 3:**

| แหล่งอ้างอิง | URL |
|-------------|-----|
| Python Exceptions | https://docs.python.org/3/library/exceptions.html |
| Errors and Exceptions | https://docs.python.org/3/tutorial/errors.html |
| logging | https://docs.python.org/3/library/logging.html |
| Logging HOWTO | https://docs.python.org/3/howto/logging.html |
| structlog | https://www.structlog.org/ |
| loguru | https://loguru.readthedocs.io/ |
| Sentry | https://docs.sentry.io/ |
| pathlib | https://docs.python.org/3/library/pathlib.html |
| shutil | https://docs.python.org/3/library/shutil.html |
| csv | https://docs.python.org/3/library/csv.html |
| json | https://docs.python.org/3/library/json.html |
| xml.etree.ElementTree | https://docs.python.org/3/library/xml.etree.elementtree.html |
| PyYAML | https://pyyaml.org/ |
| tomllib | https://docs.python.org/3/library/tomllib.html |
| configparser | https://docs.python.org/3/library/configparser.html |
| pickle | https://docs.python.org/3/library/pickle.html |
| sqlite3 | https://docs.python.org/3/library/sqlite3.html |
| gzip | https://docs.python.org/3/library/gzip.html |
| zipfile | https://docs.python.org/3/library/zipfile.html |
| tarfile | https://docs.python.org/3/library/tarfile.html |
| Unicode HOWTO | https://docs.python.org/3/howto/unicode.html |
| re | https://docs.python.org/3/library/re.html |
| datetime | https://docs.python.org/3/library/datetime.html |
| zoneinfo | https://docs.python.org/3/library/zoneinfo.html |
| math | https://docs.python.org/3/library/math.html |
| random | https://docs.python.org/3/library/random.html |
| secrets | https://docs.python.org/3/library/secrets.html |
| unittest | https://docs.python.org/3/library/unittest.html |
| pytest | https://docs.pytest.org/ |
| doctest | https://docs.python.org/3/library/doctest.html |
| unittest.mock | https://docs.python.org/3/library/unittest.mock.html |
| pytest-mock | https://pytest-mock.readthedocs.io/ |
| coverage.py | https://coverage.readthedocs.io/ |
| pytest-cov | https://pytest-cov.readthedocs.io/ |
| Hypothesis | https://hypothesis.readthedocs.io/ |
| behave | https://behave.readthedocs.io/ |
| pytest-bdd | https://pytest-bdd.readthedocs.io/ |
| Ruff | https://docs.astral.sh/ruff/ |
| mypy | https://mypy.readthedocs.io/ |
| Pyright | https://microsoft.github.io/pyright/ |
| Pylint | https://pylint.readthedocs.io/ |
| flake8 | https://flake8.pycqa.org/ |
| Bandit | https://bandit.readthedocs.io/ |
| Black | https://black.readthedocs.io/ |
| isort | https://pycqa.github.io/isort/ |
| Locust | https://docs.locust.io/ |
| Playwright | https://playwright.dev/python/ |
| Refactoring Guru | https://refactoring.guru/ |
| Google Engineering Practices | https://google.github.io/eng-practices/ |

---
 