# เล่ม 1: ปฐมบท พื้นฐาน และสภาพแวดล้อม

**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับสมบูรณ์ (ส่วนที่ 1, 2 และภาค 1–3)

---

## ส่วนที่ 1: Software Architecture — โครงร่างพื้นฐาน

ส่วนนี้เป็น "แผนที่นำทาง" ก่อนเข้าสู่เนื้อหาภาคปฏิบัติ โดยอธิบายว่าเหตุใดการพัฒนาระบบด้วย Python จึงต้องอาศัยความเข้าใจในโครงสร้างพื้นฐานเหล่านี้ และแต่ละหัวข้อจะถูกนำไปใช้ในภาคถัดไปอย่างไร

### 1.1 Data Structures และ Algorithms

**Data Structures** คือโครงสร้างการจัดเก็บข้อมูลในหน่วยความจำ เช่น List, Tuple, Set, Dictionary ซึ่ง Python มี built-in ให้ใช้ทันที โครงสร้างเหล่านี้เป็นรากฐานของการเขียนโปรแกรมทุกประเภท

**Algorithms** คือลำดับขั้นตอนการแก้ปัญหา เช่น การเรียงลำดับ (Sorting) การค้นหา (Searching) การเรียกซ้ำ (Recursion) ซึ่งทำงานร่วมกับ Data Structures เสมอ

**ตัวอย่างการใช้งานจริง:**
```python
# Data Structure: Dictionary สำหรับเก็บข้อมูลนักเรียน
students = {
    "S001": {"name": "สมชาย", "score": 85},
    "S002": {"name": "สมหญิง", "score": 92},
    "S003": {"name": "วิชัย", "score": 78}
}

# Algorithm: การค้นหานักเรียนที่ได้คะแนนสูงสุด
def find_top_student(student_dict):
    top_id = None
    top_score = -1
    for student_id, info in student_dict.items():
        if info["score"] > top_score:
            top_score = info["score"]
            top_id = student_id
    return top_id, student_dict[top_id]

print(find_top_student(students))
# Output: ('S002', {'name': 'สมหญิง', 'score': 92})
```

---

### 1.2 Big O Notation

Big O Notation เป็นเครื่องมือวัดประสิทธิภาพของอัลกอริทึม โดยอธิบายว่าความซับซ้อนของเวลาหรือหน่วยความจำเติบโตอย่างไรเมื่อขนาดข้อมูล (n) เพิ่มขึ้น

| Big O | ความหมาย | ตัวอย่างใน Python |
|-------|----------|------------------|
| O(1) | คงที่ | การเข้าถึง list[index] |
| O(n) | เชิงเส้น | การวนซ้ำ for loop |
| O(n²) | กำลังสอง | nested loop |
| O(log n) | ลอการิทึม | binary search |

**ตัวอย่างการใช้งานจริง:**
```python
import time

def linear_search(data, target):
    for i, item in enumerate(data):
        if item == target:
            return i
    return -1

def binary_search(sorted_data, target):
    low, high = 0, len(sorted_data) - 1
    while low <= high:
        mid = (low + high) // 2
        if sorted_data[mid] == target:
            return mid
        elif sorted_data[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1

data = list(range(1_000_000))
target = 999_999

start = time.time()
linear_search(data, target)
print(f"Linear: {time.time() - start:.4f}s")  # ~0.05s

start = time.time()
binary_search(data, target)
print(f"Binary: {time.time() - start:.6f}s")  # ~0.000002s
```

> **อ้างอิงเพิ่มเติม:** [Big O Cheat Sheet](https://www.bigocheatsheet.com/)

---

### 1.3 Functional Programming

Functional Programming เป็นกระบวนทัศน์ที่เน้นการéviterการเปลี่ยนแปลงสถานะ (immutability) และใช้ฟังก์ชันเป็นหน่วยหลักในการประมวลผล Python รองรับแนวคิดนี้ผ่าน `map()`, `filter()`, `reduce()`, และ `lambda`

**ตัวอย่างการใช้งานจริง — การประมวลผลข้อมูลยอดขาย:**
```python
from functools import reduce

sales = [
    {"product": "A", "amount": 1500, "qty": 3},
    {"product": "B", "amount": 2500, "qty": 1},
    {"product": "C", "amount": 800, "qty": 5},
]

# แบบ Functional: ใช้ map และ reduce
totals = list(map(lambda x: x["amount"] * x["qty"], sales))
grand_total = reduce(lambda a, b: a + b, totals)

print(f"ยอดรวมทั้งหมด: {grand_total:,} บาท")
# Output: ยอดรวมทั้งหมด: 9,000 บาท
```

> **อ้างอิงเพิ่มเติม:** [Functional Programming HOWTO — Python Docs](https://docs.python.org/3/howto/functional.html)

---

### 1.4 OOP (Object-Oriented Programming)

- OOP จัดระเบียบโค้ดด้วย Class และ Object ผ่าน 4 หลักการหลัก: Encapsulation, Inheritance, Abstraction และ Polymorphism
- Encapsulation สะกดว่า เอนแคปซูเลชัน (การห่อหุ้ม)
- Inheritance สะกดว่า อินเฮอริแทนส์ (การสืบทอดคุณสมบัติ)
- Abstraction สะกดว่า แอบสแทรกชัน (การนามธรรม) แนวคิด
- Polymorphism สะกดว่า พอลีมอร์ฟิซึม (การพหุสัณฐาน)
## ขออธิบายแบบ เข้าใจง่ายที่สุด โดยเปรียบเทียบหลักการทั้ง 4 ข้อนี้กับ "รถยนต์" ที่เราเห็นในชีวิตประจำวัน

## 1. Encapsulation (เอนแคปซูเลชัน) - การซ่อนระบบไว้ข้างใน

* เปรียบเหมือน: ฝากระโปรงรถยนต์ ที่ปิดซ่อนเครื่องยนต์และสายไฟที่ซับซ้อนเอาไว้ข้างใน
* ประโยชน์: เพื่อไม่ให้คนขับไปแตะต้องหรือแก้ไขเครื่องยนต์โดยตรงจนเกิดความเสียหาย แต่จะเหลือปุ่มหรือพวงมาลัยไว้ให้สั่งงานภายนอกได้อย่างปลอดภัย

## 2. Inheritance (อินเฮอริแทนส์) - การสืบทอด

* เปรียบเหมือน: รถกระบะ ที่สร้างต่อยอดมาจาก แบบแปลนของรถยนต์ทั่วไป
* ประโยชน์: รถกระบะไม่จำเป็นต้องออกแบบระบบล้อ ระบบพวงมาลัย หรือระบบเบรกใหม่ตั้งแต่ต้น เพราะสามารถ "สืบทอด" โครงสร้างพื้นฐานมาจากรถยนต์ทั่วไปได้เลย แล้วค่อยเพิ่มส่วนกระบะท้ายเข้าไปเอง

## 3. Abstraction (แอบสแทรกชัน) - การมองแค่จุดสำคัญ

* เปรียบเหมือน: แผงหน้าปัดและพวงมาลัย ที่คนขับต้องใช้งาน
* ประโยชน์: เวลาเราจะเลี้ยวรถ เราแค่หมุนพวงมาลัย โดย ไม่ต้องรู้ เลยว่ากลไกข้างในฟันเฟืองทำงานอย่างไร เราแค่สนใจ "ผลลัพธ์" ของมันก็พอ

## 4. Polymorphism (พอลีมอร์ฟิซึม) - การทำงานได้หลายรูปแบบ

* เปรียบเหมือน: ปุ่มสตาร์ทรถ (Start)
* ประโยชน์: ไม่ว่าจะเป็นรถเก๋ง รถกระบะ หรือรถสปอร์ต ทุกคันมีปุ่ม "Start" เหมือนกัน แต่พอเรากดปุ่มนี้ รถแต่ละประเภทจะสตาร์ทเครื่องยนต์ด้วยเสียงและแรงม้าที่ "แตกต่างกัน" ตามประเภทของมันครับ

------------------------------
 


**ตัวอย่างการใช้งานจริง — ระบบจัดการบัญชีธนาคาร:**
```python
class BankAccount:
    def __init__(self, owner: str, balance: float = 0):
        self.owner = owner
        self._balance = balance  # protected

    def deposit(self, amount: float) -> None:
        if amount <= 0:
            raise ValueError("จำนวนเงินต้องมากกว่า 0")
        self._balance += amount

    def withdraw(self, amount: float) -> bool:
        if amount > self._balance:
            print(f"ยอดเงินไม่เพียงพอ (คงเหลือ {self._balance:,.2f})")
            return False
        self._balance -= amount
        return True

    @property
    def balance(self) -> float:
        return self._balance

    def __str__(self) -> str:
        return f"{self.owner}: {self._balance:,.2f} บาท"


class SavingsAccount(BankAccount):
    def __init__(self, owner: str, balance: float = 0, interest_rate: float = 0.02):
        super().__init__(owner, balance)
        self.interest_rate = interest_rate

    def add_interest(self) -> None:
        self.deposit(self._balance * self.interest_rate)


# การใช้งาน
acc = SavingsAccount("สมชาย", 10000, 0.03)
acc.deposit(5000)
acc.withdraw(2000)
acc.add_interest()
print(acc)  # สมชาย: 13,390.00 บาท
```

> **อ้างอิงเพิ่มเติม:** [Real Python — OOP in Python](https://realpython.com/python3-object-oriented-programming/)

---

### 1.5 System Design และ Software Architecture

**System Design** คือการออกแบบโครงสร้างของระบบทั้งหมด ตั้งแต่การแบ่ง component, การสื่อสารระหว่าง component, ไปจนถึงการรองรับ scale

**Software Architecture** คือการตัดสินใจระดับสูงเกี่ยวกับโครงสร้างซอฟต์แวร์ เช่น เลือกใช้ Layered Architecture, Clean Architecture, หรือ Microservices

**ตัวอย่างการแบ่ง Layer ในโปรเจกต์ Python:**
```
project/
├── domain/           # Business Logic (ไม่พึ่งพา framework)
│   ├── entities.py
│   └── value_objects.py
├── application/      # Use Cases
│   └── services.py
├── infrastructure/   # Database, External APIs
│   └── repositories.py
└── presentation/     # API, CLI
    └── api.py
```

---

### 1.6 CI/CD (Continuous Integration / Continuous Deployment)

CI/CD คือกระบวนการอัตโนมัติที่ช่วยให้นักพัฒนาสามารถ integrate โค้ด, ทดสอบ, และ deploy ได้อย่างรวดเร็วและปลอดภัย

**ตัวอย่าง GitHub Actions Workflow สำหรับ Python:**
```yaml
# .github/workflows/ci.yml
name: Python CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.10", "3.11", "3.12"]

    steps:
      - uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
          pip install pytest pytest-cov
      - name: Run tests
        run: pytest --cov=src tests/
      - name: Upload coverage
        uses: codecov/codecov-action@v4
```

> **อ้างอิงเพิ่มเติม:** [GitHub Actions — Python](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-python)

---

### 1.7 Cloud Platform: AWS

AWS เป็นแพลตฟอร์มคลาวด์ที่นิยมที่สุดในโลก Python สามารถใช้งานร่วมกับ AWS ได้ผ่าน **Boto3** (SDK) และ **AWS CDK** (Infrastructure as Code)

**ตัวอย่างการใช้งาน Boto3 — อัปโหลดไฟล์ไปยัง S3:**
```python
import boto3
from pathlib import Path

s3 = boto3.client('s3')

def upload_to_s3(local_path: str, bucket: str, s3_key: str) -> None:
    file_path = Path(local_path)
    if not file_path.exists():
        raise FileNotFoundError(f"ไม่พบไฟล์: {local_path}")

    s3.upload_file(str(file_path), bucket, s3_key)
    print(f"อัปโหลด {file_path.name} ไปยัง s3://{bucket}/{s3_key} สำเร็จ")

upload_to_s3("./data/report.csv", "my-company-bucket", "reports/2024/report.csv")
```

> **อ้างอิงเพิ่มเติม:** [Boto3 Documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)

---

### 1.8 Domain-Driven Design (DDD)

DDD เป็นแนวทางการออกแบบซอฟต์แวร์ที่เน้นความเข้าใจใน **Domain** (ธุรกิจ) เป็นหลัก ประกอบด้วย Building Blocks สำคัญ เช่น Entity, Value Object, Aggregate, Repository
**Domain-Driven Design (DDD)** เน้นการแบ่งโครงสร้างโค้ดตามความหมายของธุรกิจ เพื่อให้ซอฟต์แวร์สะท้อนภาพงานจริงได้ดีที่สุด  เช่น
* **Entity:** วัตถุที่มี **Identity (เอกลักษณ์เฉพาะตัว)** ชัดเจน และมีวงจรชีวิต (Lifecycle) ค่าของข้อมูลภายในเปลี่ยนแปลงได้ตามเวลา แต่ Identity จะไม่เปลี่ยน
* *ตัวอย่าง:* **Order (คำสั่งซื้อ)** มี `Order ID` เดียว ถึงแม้จะเปลี่ยนสถานะจาก "Pending" เป็น "Shipped" ก็ยังคงเป็น Order เดิม


* **Value Object:** วัตถุที่ไม่มี Identity ถูกนิยามด้วย **คุณลักษณะ/ค่า (Value)** ทั้งหมดของมันโดยสมบูรณ์ หากค่าเปลี่ยน ถือว่าเป็น วัตถุชิ้นใหม่ (Immutable)
* *ตัวอย่าง:* **Address (ที่อยู่)** หรือ **Money (จำนวนเงิน + สกุลเงิน)** ถ้าที่อยู่เปลี่ยน ก็แค่นำ Address ชุดใหม่มาวางแทนที่ ไม่จำเป็นต้องติดตามประวัติการเปลี่ยน


* **Aggregate:** กลุ่มของ Entities และ Value Objects ที่ถูกมัดรวมกันเพื่อรักษาความถูกต้องของข้อมูล (Data Consistency / Invariants) โดยมี **Aggregate Root** ทำหน้าที่เป็นทางเข้าออกเดียวในการจัดการวัตถุภายในกลุ่ม
* *ตัวอย่าง:* `Order` ทำหน้าที่เป็น Aggregate Root คอยควบคุม `OrderItem` (รายการสินค้า) หากจะเพิ่ม/ลบรายการ ต้องทำผ่าน `Order` เท่านั้น เพื่อไม่ให้ยอดรวมคำนวณผิดพลาด


* **Repository:** ตัวประสานระหว่าง Domain Logic กับการจัดเก็บข้อมูล (Database) ทำหน้าที่เสมือนเป็น Collection ในหน่วยความจำ ช่วยให้อ่านและบันทึก Aggregate Root ได้โดยที่ Domain ไม่ต้องสนใจรายละเอียดของ SQL หรือตัว Database

---

| Building Block | หน้าที่หลัก | จุดสังเกต |
| --- | --- | --- |
| **Entity** | ระบุตัวตนเฉพาะตัว | มี ID, สถานะเปลี่ยนได้ตลอดเวลา |
| **Value Object** | อธิบายคุณลักษณะ | ไม่มี ID, ห้ามเปลี่ยนค่า (Immutable) |
| **Aggregate** "แอก-กริ-เกิท" | ควบคุมขอบเขตความถูกต้อง | มี Root ชัดเจน, จัดการเป็นกลุ่มก้อนเดียว |
| **Repository** | จัดการ Persistence | ทำงานระดับ Aggregate Root เท่านั้น |

**ตัวอย่าง Entity และ Value Object:**
```python
from dataclasses import dataclass, field
from uuid import UUID, uuid4

# Entity — มี identity ที่ไม่เปลี่ยน
@dataclass
class Customer:
    id: UUID = field(default_factory=uuid4)
    name: str = ""
    email: str = ""

    def __eq__(self, other):
        return self.id == other.id

# Value Object — ไม่มี identity เปรียบเทียบจากค่าทั้งหมด
@dataclass(frozen=True)
class Money:
    amount: float
    currency: str = "THB"

    def __add__(self, other):
        if self.currency != other.currency:
            raise ValueError("สกุลเงินไม่ตรงกัน")
        return Money(self.amount + other.amount, self.currency)


# การใช้งาน
c1 = Customer(name="สมชาย", email="somchai@email.com")
c2 = Customer(name="สมชาย", email="somchai@email.com")
print(c1 == c2)  # False — เป็น Entity คนละ identity

price = Money(100)
tax = Money(7)
print(price + tax)  # Money(amount=107, currency='THB')
```

> **อ้างอิงเพิ่มเติม:** [Domain-Driven Design Reference — Eric Evans](https://www.domainlanguage.com/ddd/reference/)

---
การรวบรวม **DDD (Domain-Driven Design)** ให้สมบูรณ์ ต้องมองเห็นทั้งภาพรวมการออกแบบเชิงยุทธศาสตร์ (**Strategic Design**) และเชิงปฏิบัติการ (**Tactical Design**) รวมถึงการนำไปเชื่อมต่อกับสถาปัตยกรรมระดับระบบ

---

### 1. Strategic Design (การออกแบบเชิงยุทธศาสตร์)

เน้นการเข้าใจธุรกิจและการแบ่งขอบเขตระบบ เพื่อไม่ให้โมเดลใหญ่เกินจนดูแลไม่ได้

* **Domain & Subdomain:**
* **Core Domain:** จุดขายหรือความสามารถหลักของธุรกิจที่สร้างความได้เปรียบทางการแข่งขัน (ควรทุ่มเททรัพยากรสร้างเอง)
* **Supporting Subdomain:** ระบบสนับสนุนที่จำเป็นต่อธุรกิจ แต่ไม่ใช่จุดขายหลัก (สร้างเองแบบเรียบง่าย)
* **Generic Subdomain:** งานทั่วไปที่ไม่ใช่จุดเด่นทางธุรกิจ เช่น ระบบชำระเงิน ระบบส่ง Email (นิยมซื้อสำเร็จรูป หรือใช้ Third-party)


* **Bounded Context:** การขีดเส้นขอบเขตของโมเดลข้อมูลและภาษาเฉพาะ (**Ubiquitous Language**) เพื่อไม่ให้คำศัพท์เดียวกันตีกันในบริบทต่างกัน
* **Context Mapping:** การกำหนดรูปแบบความสัมพันธ์และการสื่อสารระหว่าง Bounded Context เช่น *Customer-Supplier*, *Shared Kernel*, *Anti-Corruption Layer (ACL)* หรือ *Published Language*

---

### 2. Tactical Design (การออกแบบเชิงปฏิบัติการ)

เน้นโครงสร้างโค้ดและการจัดกลุ่มวัตถุในระดับการโปรแกรม

* **Building Blocks หลัก:**
* **Entity:** วัตถุมี Identity (ID) เปลี่ยนแปลงค่าข้างในได้ตลอดวงจรชีวิต (เช่น `User`, `Order`)
* **Value Object:** วัตถุไม่มี ID นิยามด้วยค่าของตัวมันเอง ห้ามแก้ไขค่า (Immutable) หากเปลี่ยนต้องสร้างใหม่ ( เช่น `Address`, `Money`)
* **Aggregate & Aggregate Root:** การมัดรวม Entities และ Value Objects เป็นกลุ่มก้อนเพื่อคุมความถูกต้องข้อมูล โดยมี Aggregate Root เป็นทางเข้าออกเดียว
* **Repository:** Interface สำหรับอ่าน/บันทึก Aggregate Root ลงใน Database โดยแยก Domain Logic ออกจาก SQL/DB


* **Building Blocks สนับสนุน:**
* **Domain Service:** Logic ของธุรกิจที่ไม่เหมาะจะวางไว้ใน Entity หรือ Value Object ใดตัวหนึ่งโดยเฉพาะ (เช่น การคำนวณที่ต้องดึงข้อมูลจากหลาย Aggregate)
* **Domain Event:** เหตุการณ์สำคัญทางธุรกิจที่เกิดขึ้นใน Domain เพื่อแจ้งเตือน Context อื่นๆ (เช่น `OrderPlaced`, `PaymentReceived`)
* **Factory:** ตัวช่วยสร้าง Aggregate หรือ Entity ที่มีความซับซ้อนสูง



---

### 3. Architecture Integration (การนำไปใช้งานจริง)

```
[ User Interface / API Layer ]
              │
[ Application Layer ] ── (Orchestration, Use Cases, Transactions)
              │
[ Domain Layer ] ────── (Entities, Value Objects, Domain Services)
              │
[ Infrastructure Layer ] (Database, External APIs, Message Brokers)

```

* **Hexagonal Architecture / Onion Architecture:** นิยมใช้ครอบ DDD เพื่อให้ **Domain Layer** อยู่ตรงกลางอย่างบริสุทธิ์ ไม่ยึดติดกับ Framework, Database หรือ UI
* **CQRS (Command Query Responsibility Segregation):** แยกการเขียน (Command) และการอ่าน (Query) ออกจากกัน ช่วยให้ Aggregate โฟกัสเฉพาะ Logic การแก้ไขข้อมูล ส่วนการดึงข้อมูลไปแสดงผลสามารถดึงตรงผ่าน Read Model ได้เลย
* **Microservices Alignment:** 1 Bounded Context มักถูกนำไปประยุกต์เป็น 1 Microservice เพื่อให้ทีมพัฒนาและปรับขยายระบบ (Scale) ได้อย่างเป็นอิสระ
 

 
### 1.9 Clean Architecture

Clean Architecture แบ่งระบบออกเป็น 4 Layer โดยมี **Dependency Rule**: dependencies ต้องชี้เข้าด้านในเท่านั้น

```
┌─────────────────────────────────────┐
│  Frameworks & Drivers (Layer 4)     │  ← Database, Web Framework
├─────────────────────────────────────┤
│  Interface Adapters (Layer 3)       │  ← Controllers, Presenters
├─────────────────────────────────────┤
│  Use Cases (Layer 2)                │  ← Application Logic
├─────────────────────────────────────┤
│  Entities (Layer 1)                 │  ← Business Rules
└─────────────────────────────────────┘
         ↑ dependencies point inward
```

**ตัวอย่างโครงสร้างโปรเจกต์ Clean Architecture:**
```python
# domain/entities.py
from dataclasses import dataclass

@dataclass
class User:
    id: str
    email: str
    hashed_password: str

# application/use_cases.py
from domain.entities import User

class RegisterUserUseCase:
    def __init__(self, user_repo, password_hasher):
        self.user_repo = user_repo
        self.password_hasher = password_hasher

    def execute(self, email: str, password: str) -> User:
        if self.user_repo.find_by_email(email):
            raise ValueError("อีเมลนี้ถูกใช้งานแล้ว")
        hashed = self.password_hasher.hash(password)
        user = User(id="", email=email, hashed_password=hashed)
        return self.user_repo.save(user)

# infrastructure/repositories.py
class PostgresUserRepository:
    def find_by_email(self, email: str):
        # SQL query
        ...

    def save(self, user: User):
        # SQL insert
        ...
```

> **อ้างอิงเพิ่มเติม:** [The Clean Architecture — Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

### 1.10 Modular Software Design

Modular Design คือการแบ่งระบบออกเป็นโมดูลย่อยที่ทำงานได้อย่างอิสระ ลดการพึ่งพากัน (loose coupling) และเพิ่ม cohesion ภายในโมดูล

**หลักการสำคัญ:**
- แต่ละโมดูลมี interface ชัดเจน
- โมดูลหนึ่งไม่รู้จัก internal implementation ของอีกโมดูล
- ใช้ Dependency Injection เพื่อลดการผูกติดกัน

---

## ส่วนที่ 2: แม่แบบการเขียนเนื้อหา

ส่วนนี้เป็น "สูตรสำเร็จ" ที่ใช้กับทุกบทในหนังสือทั้ง 12 เล่ม เพื่อให้เนื้อหามีความสม่ำเสมอและครอบคลุมทุกมุมมองที่ผู้อ่านต้องการ

### แม่แบบโครงสร้างบท

ทุกบทจะประกอบด้วยหัวข้อต่อไปนี้ (อาจปรับเพิ่มลดตามความเหมาะสมของเนื้อหา):

1. **บทนำ** — ปัญหาที่เนื้อหานี้แก้ไข, ทำไมต้องเรียนรู้
2. **นิยาม** — คำจำกัดความที่ชัดเจน กระชับ
3. **หัวข้อ** — เนื้อหาหลัก ประกอบด้วย:
   - 3.1 คืออะไร
   - 3.2 ทำงานอย่างไร
   - 3.3 การใช้งาน (พร้อมตัวอย่างโค้ด)
   - 3.4 ข้อดี
   - 3.5 ข้อเสีย
   - 3.6 ข้อควรระวัง / ข้อจำกัด
   - 3.7 สรุป
4. **โครงสร้าง** — สถาปัตยกรรมภายในของหัวข้อนั้น
5. **DDD + Clean Architecture + Modular Software Design** — เชื่อมโยงกับหลักการออกแบบ
6. **แนวทางการประยุกต์ใช้** — ใช้ในโปรเจกต์จริงอย่างไร
7. **Root Cause Analysis (RCA)** — วิเคราะห์ปัญหาที่อาจเกิดขึ้น
8. **การนำไปใช้งานจริง** — Case study
9. **Prompt Templates Python** — คำสั่ง AI ที่เป็นประโยชน์
10. **AI Skill Python** — ทักษะ AI ที่ควรมี
11. **ปัญหาและแนวทางแก้ไข** — Troubleshooting
12. **สรุป** — Key takeaways

### ตัวอย่างการประยุกต์ใช้แม่แบบ

**บทนำ:** การจัดการ Virtual Environment เป็นปัญหาที่นักพัฒนา Python ทุกคนต้องเจอ เพราะโปรเจกต์แต่ละอันต้องการ dependency คนละ version

**นิยาม:** Virtual Environment คือสภาพแวดล้อม Python แยกส่วนที่ช่วยให้แต่ละโปรเจกต์มี package และ interpreter เป็นของตัวเองโดยไม่รบกวนโปรเจกต์อื่น

**3.1 คืออะไร:** Virtual Environment สร้างจาก module `venv` ใน Python 3.3+ สร้างโฟลเดอร์ที่มี interpreter, pip, และ site-packages ของตัวเอง

**3.2 ทำงานอย่างไร:** เมื่อสร้าง venv จะมี symlink ไปยัง Python interpreter หลัก แต่มี site-packages แยกต่างหาก การ activate จะปรับ `PATH` ให้เรียกใช้ python และ pip จากโฟลเดอร์ venv

**3.3 การใช้งาน:**
```bash
# สร้าง
python -m venv .venv

# เปิดใช้งาน (macOS/Linux)
source .venv/bin/activate

# เปิดใช้งาน (Windows)
.venv\Scripts\activate

# ติดตั้ง packages
pip install requests

# บันทึก dependencies
pip freeze > requirements.txt

# ปิด
deactivate
```

> **อ้างอิงเพิ่มเติม:** [Python venv Documentation](https://docs.python.org/3/library/venv.html), [Packaging Guide — pip and venv](https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/)

**3.4 ข้อดี:** แยก dependency ระหว่างโปรเจกต์, ป้องกัน version conflict, reproduce ได้

**3.5 ข้อเสีย:** ต้อง activate ทุกครั้ง, ใช้พื้นที่ดิสก์เพิ่ม, อาจสับสนหากมีหลาย venv

**3.6 ข้อควรระวัง:** อย่า commit โฟลเดอร์ `.venv` ลง Git — ใช้ `.gitignore`; ระวังการ activate ผิด venv

**3.7 สรุป:** Virtual Environment เป็นสิ่งจำเป็นสำหรับทุกโปรเจกต์ Python ที่ใช้ third-party packages

---

## ภาค 1: ปฐมบทและภาพรวม

### 1.1 ความหมายของการพัฒนาระบบด้วย Python

การพัฒนาระบบด้วย Python หมายถึงการใช้ภาษา Python ในการสร้างซอฟต์แวร์ที่ทำงานได้จริง ตั้งแต่ CLI tool ขนาดเล็ก ไปจนถึงระบบ distributed ขนาดใหญ่ Python เป็นภาษาที่อ่านง่าย มี standard library ครอบคลุม และมี ecosystem ของ third-party packages ที่กว้างขวาง

**ตัวอย่างระบบที่พัฒนาด้วย Python ในโลกจริง:**
- **Instagram:** ใช้ Django ในการ serve ข้อมูลผู้ใช้หลายร้อยล้านคน
- **Spotify:** ใช้ Python ใน backend services และ data pipeline
- **Dropbox:** ใช้ Python ทั้งใน desktop client และ server
- **Netflix:** ใช้ Python ในระบบ monitoring, data analysis, และ recommendation

---

### 1.2 บทบาทของ Python ในงานพัฒนาระบบ

Python มีบทบาทในหลายด้าน:

| ด้าน | บทบาท | ตัวอย่าง Tools |
|------|--------|----------------|
| Web Development | สร้าง API และเว็บแอป | Django, Flask, FastAPI |
| Data Science | วิเคราะห์ข้อมูล, ML | Pandas, NumPy, scikit-learn |
| Automation | เขียนสคริปต์, จัดการระบบ | os, subprocess, Ansible |
| DevOps | CI/CD, Infrastructure as Code | Boto3, Pulumi, Ansible |
| AI/GenAI | สร้างโมเดล, LLM apps | PyTorch, LangChain, Transformers |

---

### 1.3 ประเภทของระบบที่พัฒนาได้ด้วย Python

1. **Web Applications** — Django, Flask, FastAPI
2. **REST/GraphQL APIs** — DRF, Strawberry, Ariadne
3. **Data Pipelines** — Airflow, Prefect, Dagster
4. **Machine Learning Systems** — scikit-learn, MLflow, Kubeflow
5. **Desktop Applications** — Tkinter, PyQt, Kivy
6. **Automation Scripts** — Selenium, Playwright, PyAutoGUI
7. **IoT/Embedded Systems** — MicroPython, CircuitPython
8. **CLI Tools** — Click, Typer, argparse
9. **Game Development** — Pygame, Arcade
10. **Blockchain/Web3** — web3.py, Brownie

---

### 1.4 เส้นทางการเรียนรู้จากพื้นฐานถึงขั้นสูง

```
ระดับเริ่มต้น (0–3 เดือน)
├── Python Syntax, Variables, Data Types
├── Control Flow (if/for/while)
├── Functions และ Modules
└── การใช้ Git และ CLI

ระดับกลาง (3–12 เดือน)
├── OOP และ Design Patterns
├── Testing (pytest, unittest)
├── Web Development (Django/FastAPI)
├── Database (SQL, ORM)
└── Concurrency (threading, asyncio)

ระดับสูง (12+ เดือน)
├── System Design และ Architecture
├── Distributed Systems
├── Performance Optimization
├── Cloud และ DevOps
├── AI/ML Engineering
└── Open Source Contribution
```

---

### 1.5 การวางแผนการเรียนรู้และฝึกปฏิบัติ

**หลักการสำคัญ: 70% ลงมือทำ 20% เรียนรู้จากผู้อื่น 10% ทฤษฎี**

**แผน 30 วัน (พื้นฐาน):**
- สัปดาห์ 1: Syntax, Variables, Data Types, Operators
- สัปดาห์ 2: Control Flow, Functions, Modules
- สัปดาห์ 3: Data Structures (List, Dict, Set, Tuple)
- สัปดาห์ 4: File I/O, Error Handling, Project เล็ก ๆ

**แผน 90 วัน (ระดับกลาง):**
- เดือน 1: OOP, Testing, Git Workflow
- เดือน 2: Web Development, Database
- เดือน 3: Project ขนาดกลาง, CI/CD, Deployment

**แผน 1 ปี (ระดับสูง):**
- ไตรมาส 1: พื้นฐาน + OOP + Testing
- ไตรมาส 2: Web/API + Database + Docker
- ไตรมาส 3: System Design + Cloud + CI/CD
- ไตรมาส 4: Specialization (AI, Data, DevOps)

---

### 1.6 เครื่องมือที่ต้องเตรียมก่อนเริ่ม

| ประเภท | เครื่องมือ | เหตุผล |
|--------|-----------|--------|
| Python | Python 3.11+ | เวอร์ชันเสถียร ล่าสุด |
| Editor | VS Code + Python Extension | ฟรี, เบา, รองรับดี |
| IDE | PyCharm Community | ฟีเจอร์ครบสำหรับโปรเจกต์ใหญ่ |
| Version Control | Git + GitHub Account | จำเป็นสำหรับทุกโปรเจกต์ |
| Terminal | Windows Terminal / iTerm2 | จัดการ command line |
| Package Manager | pip (built-in) | ติดตั้ง packages |

> **อ้างอิงเพิ่มเติม:** [VS Code Python Setup](https://code.visualstudio.com/docs/languages/python), [Python Roadmap Setup Guide](https://github.com/vranacse/Python-Roadmap/blob/main/SETUP.md)

---

### 1.7 การตั้งเป้าหมายและแฟ้มสะสมผลงาน

**SMART Goals สำหรับการเรียนรู้ Python:**
- **S**pecific: "สร้าง REST API ด้วย FastAPI ภายใน 60 วัน"
- **M**easurable: "มี 3 โปรเจกต์บน GitHub"
- **A**chievable: เริ่มจากโปรเจกต์เล็กก่อน
- **R**elevant: ตรงกับสายงานที่ต้องการ
- **T**ime-bound: กำหนด deadline ชัดเจน

**Portfolio ที่ดีควรมี:**
1. **README.md** ที่อธิบายโปรเจกต์ชัดเจน
2. **ตัวอย่างโค้ด** ที่มีคุณภาพ (PEP 8, Type Hints, Tests)
3. **Demo** หรือ screenshot
4. **Documentation** ที่เพียงพอให้คนอื่นรันได้
5. **Commit history** ที่สะท้อนการทำงานจริง

---

## ภาค 2: การติดตั้งและสภาพแวดล้อมการพัฒนา

### 2.1 การติดตั้ง Python

**Windows:**
1. ไปที่ [python.org/downloads](https://www.python.org/downloads/)
2. ดาวน์โหลด installer ล่าสุด (แนะนำ Python 3.12+)
3. **สำคัญ:** ติ๊ก "Add Python to PATH" ก่อนกด Install
4. ตรวจสอบด้วย `python --version`

**macOS:**
```bash
# วิธีที่แนะนำ: ใช้ Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install python
python3 --version
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv
python3 --version
```

> **อ้างอิงเพิ่มเติม:** [Python Downloads](https://www.python.org/downloads/), [Real Python — Setting Up Python](https://realpython.com/installing-python/)

---

### 2.2 Python Interpreter

Python Interpreter คือโปรแกรมที่อ่านและรันโค้ด Python โดยแปลเป็น bytecode แล้ว execute ผ่าน Python Virtual Machine (PVM) Python เป็นภาษา interpreted ไม่ต้อง compile ก่อน run

**โหมดการทำงาน:**
- **Interactive Mode:** พิมพ์ `python` ใน terminal แล้วพิมพ์โค้ดทีละบรรทัด
- **Script Mode:** รันไฟล์ `.py` ด้วย `python script.py`

---

### 2.3 การจัดการเวอร์ชัน Python

**pyenv** เป็นเครื่องมือยอดนิยมสำหรับจัดการหลายเวอร์ชัน Python บนเครื่องเดียว:
```bash
# ติดตั้ง pyenv (macOS)
brew install pyenv

# ดูเวอร์ชันที่ใช้ได้
pyenv install --list

# ติดตั้งเวอร์ชันเฉพาะ
pyenv install 3.12.0

# ตั้งค่า global
pyenv global 3.12.0

# ตั้งค่าสำหรับโปรเจกต์
cd my-project
pyenv local 3.11.5
```

**ทางเลือกอื่น:** asdf, mise, uv

---

### 2.4 Virtual Environment (venv)

Virtual Environment เป็นหนึ่งในเครื่องมือที่สำคัญที่สุดสำหรับนักพัฒนา Python ช่วยแยก dependency ระหว่างโปรเจกต์

```bash
# สร้าง venv
python -m venv .venv

# Activate (macOS/Linux)
source .venv/bin/activate

# Activate (Windows)
.venv\Scripts\activate

# ตรวจสอบว่า activate แล้ว
which python
# ควรแสดง path ที่มี .venv

# ติดตั้ง package
pip install requests

# ออกจาก venv
deactivate
```

**ข้อควรปฏิบัติ:**
- ใส่ `.venv/` ใน `.gitignore` เสมอ
- ใช้ชื่อ `.venv` เพื่อให้ tools ต่าง ๆ ตรวจพบอัตโนมัติ
- สร้าง `requirements.txt` ด้วย `pip freeze > requirements.txt`

> **อ้างอิงเพิ่มเติม:** [venv — Creation of virtual environments](https://docs.python.org/3/library/venv.html)

---

### 2.5 pip

**pip** คือ package manager มาตรฐานของ Python ใช้ติดตั้ง packages จาก [PyPI](https://pypi.org/)

```bash
# ติดตั้ง package
pip install requests

# ติดตั้งเวอร์ชันเฉพาะ
pip install django==5.0.1

# ติดตั้งจาก requirements.txt
pip install -r requirements.txt

# อัปเดต package
pip install --upgrade requests

# ลบ package
pip uninstall requests

# ดู packages ที่ติดตั้ง
pip list

# บันทึก dependencies
pip freeze > requirements.txt
```

---

### 2.6 conda

**conda** เป็น package manager และ environment manager ที่นิยมในสาย Data Science สามารถจัดการ packages ที่ไม่ใช่ Python (เช่น CUDA, R) ได้ด้วย

```bash
# สร้าง environment
conda create -n myenv python=3.12

# เปิดใช้งาน
conda activate myenv

# ติดตั้ง package
conda install numpy pandas

# ปิด
conda deactivate

# ลบ environment
conda env remove -n myenv

# Export environment
conda env export > environment.yml
```

---

### 2.7 Poetry

**Poetry** เป็นเครื่องมือจัดการ dependency และ packaging ที่ทันสมัย ใช้ `pyproject.toml` เป็นศูนย์กลาง

```bash
# ติดตั้ง Poetry
curl -sSL https://install.python-poetry.org | python3 -

# สร้างโปรเจกต์ใหม่
poetry new my-project
cd my-project

# เพิ่ม dependency
poetry add requests

# เพิ่ม dev dependency
poetry add --dev pytest black

# ติดตั้ง dependencies ทั้งหมด
poetry install

# รัน script
poetry run python main.py
```

**ข้อดีของ Poetry:**
- Lock file (`poetry.lock`) รับประกัน reproducibility
- จัดการ virtual environment อัตโนมัติ
- Dependency resolution ที่ดีกว่า pip

---

### 2.8 pipenv

**pipenv** เป็นเครื่องมือที่รวม pip และ virtualenv เข้าด้วยกัน ใช้ `Pipfile` และ `Pipfile.lock`

```bash
pip install pipenv

# สร้าง environment และติดตั้ง
pipenv install requests

# Dev dependency
pipenv install --dev pytest

# Activate shell
pipenv shell

# รัน script
pipenv run python main.py
```

---

### 2.9 pyproject.toml

`pyproject.toml` เป็นไฟล์มาตรฐาน (PEP 518, PEP 621) สำหรับกำหนด build system และ metadata ของโปรเจกต์ Python

```toml
[build-system]
requires = ["setuptools>=68", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "my-package"
version = "0.1.0"
description = "A sample Python package"
readme = "README.md"
requires-python = ">=3.10"
license = {text = "MIT"}
authors = [
    {name = "Kongnakorn Jantakun", email = "kongnakornjantakun@gmail.com"}
]
dependencies = [
    "requests>=2.31.0",
    "click>=8.1.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "black>=23.0",
    "ruff>=0.1.0",
]

[project.scripts]
my-cli = "my_package.cli:main"

[tool.black]
line-length = 88
target-version = ["py310", "py311", "py312"]

[tool.ruff]
line-length = 88
select = ["E", "F", "I", "N"]
```

> **อ้างอิงเพิ่มเติม:** [pyproject.toml Specification](https://packaging.python.org/en/latest/specifications/pyproject-toml/)

---

### 2.10 requirements.txt

`requirements.txt` เป็นวิธีดั้งเดิมในการระบุ dependencies ของโปรเจกต์

```
# requirements.txt
requests==2.31.0
click==8.1.7
pydantic>=2.5.0,<3.0.0
```

**Best Practice:**
- ใช้ version pinning (`==`) สำหรับ production
- แยก `requirements-dev.txt` สำหรับ development tools
- ใช้ `pip-tools` สำหรับ compile requirements

---

### 2.11 IDE และ Code Editor

| เครื่องมือ | ประเภท | เหมาะกับ |
|-----------|--------|----------|
| VS Code | Editor | ทุกระดับ, extensible |
| PyCharm | IDE | โปรเจกต์ขนาดใหญ่, Django |
| Jupyter Notebook | Notebook | Data Science, Prototyping |
| Vim/Neovim | Editor | ผู้ใช้ขั้นสูง |

---

### 2.12 VS Code

VS Code เป็น editor ที่ได้รับความนิยมสูงสุดสำหรับ Python Development

**การตั้งค่าพื้นฐาน:**
1. ติดตั้ง [VS Code](https://code.visualstudio.com/)
2. ติดตั้ง extension:
   - **Python** (Microsoft) — IntelliSense, debugging, linting
   - **Pylance** — Type checking ขั้นสูง
   - **Ruff** — Linter และ Formatter ความเร็วสูง
   - **GitLens** — Git integration

3. เลือก Python Interpreter:
   - กด `Ctrl+Shift+P` (Windows/Linux) หรือ `Cmd+Shift+P` (macOS)
   - พิมพ์ "Python: Select Interpreter"
   - เลือก `.venv/bin/python` หรือ interpreter ที่ต้องการ

**ตัวอย่าง `settings.json`:**
```json
{
    "python.defaultInterpreterPath": "${workspaceFolder}/.venv/bin/python",
    "python.formatting.provider": "none",
    "[python]": {
        "editor.defaultFormatter": "charliermarsh.ruff",
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
            "source.organizeImports": "explicit"
        }
    },
    "python.linting.enabled": true,
    "python.linting.ruffEnabled": true,
    "python.analysis.typeCheckingMode": "basic"
}
```

> **อ้างอิงเพิ่มเติม:** [VS Code Python Tutorial](https://code.visualstudio.com/docs/python/python-tutorial)

---

### 2.13 PyCharm

PyCharm เป็น IDE ที่มีฟีเจอร์ครบสำหรับ Python Development โดยเฉพาะ

**ข้อดี:**
- Debugger ที่ทรงพลัง
- Refactoring tools
- Django/FastAPI support
- Database tools (Professional)
- Remote development

**การตั้งค่า:**
1. สร้างโปรเจกต์ใหม่
2. เลือก Python Interpreter: `New environment using Virtualenv`
3. ตั้งค่า interpreter path เป็น `.venv/bin/python`

---

### 2.14 Jupyter Notebook

Jupyter Notebook เป็นเครื่องมือ interactive computing ที่นิยมใน Data Science

```bash
# ติดตั้ง
pip install notebook

# เปิด
jupyter notebook

# หรือ JupyterLab
pip install jupyterlab
jupyter lab
```

**ตัวอย่างการใช้งาน:**
```python
# Cell 1: Import
import pandas as pd
import matplotlib.pyplot as plt

# Cell 2: โหลดข้อมูล
df = pd.read_csv("data.csv")
df.head()

# Cell 3: Visualization
df.plot(kind="bar", x="category", y="sales")
plt.show()
```

---

### 2.15 JupyterLab

JupyterLab เป็น รุ่นต่อไป interface ของ Jupyter ที่รองรับ tabs, terminal, file browser และ extensions

---

### 2.16 Google Colab

Google Colab เป็น Jupyter Notebook บน cloud ฟรี ใช้ GPU/TPU ฟรี (มีข้อจำกัด) เหมาะสำหรับ Machine Learning

**ข้อดี:**
- ไม่ต้องติดตั้งอะไร
- GPU ฟรี (T4)
- แชร์ notebook ได้ง่าย
- เชื่อมต่อ Google Drive ได้

---

### 2.17 การตั้งค่า Debugger

**VS Code Debugger:**
สร้าง `.vscode/launch.json`:
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Current File",
            "type": "debugpy",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal",
            "justMyCode": true
        },
        {
            "name": "Python: pytest",
            "type": "debugpy",
            "request": "launch",
            "module": "pytest",
            "args": ["-v", "tests/"],
            "console": "integratedTerminal"
        }
    ]
}
```

**การใช้ breakpoint ในโค้ด:**
```python
def calculate_total(items):
    total = 0
    for item in items:
        breakpoint()  # หยุดที่นี่เมื่อรันด้วย debugger
        total += item["price"] * item["qty"]
    return total
```

---

### 2.18 การตั้งค่า Linter และ Formatter

**Ruff** — Linter และ Formatter ความเร็วสูง เขียนด้วย Rust แทนที่ Flake8, isort, และ Black ได้ทั้งหมด

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
]
ignore = ["E501"]  # line too long (จัดการโดย formatter)

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
```

**Black** — Formatter ที่ไม่ต้องตั้งค่า (opinionated)
```bash
pip install black
black .
```

**mypy** — Static Type Checker
```bash
pip install mypy
mypy src/
```

> **อ้างอิงเพิ่มเติม:** [Ruff Documentation](https://docs.astral.sh/ruff/), [Black Documentation](https://black.readthedocs.io/)

---

### 2.19 การใช้งาน Git ร่วมกับ Python

**Workflow พื้นฐาน:**
```bash
# เริ่มต้น repository
git init
git add .
git commit -m "Initial commit"

# สร้าง .gitignore สำหรับ Python
cat > .gitignore << 'EOF'
# Byte-compiled / optimized
__pycache__/
*.py[cod]
*$py.class

# Virtual environments
.venv/
venv/
env/

# Distribution / packaging
build/
dist/
*.egg-info/

# Testing
.pytest_cache/
.coverage
htmlcov/

# Environment variables
.env

# IDE
.vscode/
.idea/
EOF

# เชื่อมต่อ remote
git remote add origin https://github.com/username/repo.git
git push -u origin main
```

**Branching Strategy ที่แนะนำ:**
- `main` — production-ready code
- `develop` — integration branch
- `feature/*` — features ใหม่
- `hotfix/*` — แก้ bug เร่งด่วน

---

### 2.20 การจัดการ Environment Variables

**วิธีที่ 1: ใช้ `python-dotenv`**
```bash
pip install python-dotenv
```

```python
# .env
DATABASE_URL=postgresql://user:pass@localhost:5432/mydb
SECRET_KEY=your-secret-key-here
DEBUG=True
```

```python
# config.py
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
SECRET_KEY = os.getenv("SECRET_KEY")
DEBUG = os.getenv("DEBUG", "False").lower() == "true"
```

**วิธีที่ 2: ใช้ `pydantic-settings`**
```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str
    secret_key: str
    debug: bool = False

    class Config:
        env_file = ".env"

settings = Settings()
```

**ข้อควรระวัง:**
- **อย่า commit `.env` ลง Git** — ใส่ใน `.gitignore`
- ใช้ `.env.example` เป็น template
- ใน production ใช้ secrets manager เช่น AWS Secrets Manager, HashiCorp Vault

> **อ้างอิงเพิ่มเติม:** [Pydantic Settings](https://docs.pydantic.dev/latest/concepts/pydantic_settings/), [python-dotenv](https://saurabh-kumar.com/python-dotenv/)

---

## ภาค 3: พื้นฐานภาษา Python

### 3.1 Syntax และโครงสร้างโปรแกรม

Python ใช้ indentation (การเยื้อง) แทน `{}` ในการแบ่ง block ของโค้ด ตาม PEP 8 แนะนำให้ใช้ **4 spaces** ต่อระดับ indentation และไม่ใช้ tab

```python
# โครงสร้างพื้นฐาน
# import statements
import os
import sys
from pathlib import Path
from typing import Optional

# constants
MAX_RETRIES = 3
DEFAULT_TIMEOUT = 30

# functions
def greet(name: str) -> str:
    """Return a greeting message."""
    return f"สวัสดี, {name}!"

# classes
class UserService:
    """Service for managing users."""
    pass

# main block
if __name__ == "__main__":
    print(greet("Python"))
```

---

### 3.2 ตัวแปรและชนิดข้อมูล

Python เป็นภาษา **dynamically typed** — ไม่ต้องประกาศ type ของตัวแปร แต่สามารถใช้ **type hints** เพื่อความชัดเจนได้

```python
# ตัวแปรพื้นฐาน
name: str = "สมชาย"
age: int = 30
salary: float = 45000.50
is_active: bool = True
nothing: None = None

# ตรวจสอบ type
print(type(name))    # <class 'str'>
print(type(age))     # <class 'int'>
print(type(salary))  # <class 'float'>
print(type(is_active))  # <class 'bool'>
```

**Type Hints (Python 3.5+):**
Type hints ช่วยให้ IDE และ linters ตรวจสอบ type ได้ก่อน runtime
```python
from typing import Optional

def find_user(user_id: int) -> Optional[str]:
    """ค้นหาชื่อผู้ใช้จาก ID"""
    users = {1: "สมชาย", 2: "สมหญิง"}
    return users.get(user_id)

# Python 3.10+ ใช้ | แทน Optional
def find_user_v2(user_id: int) -> str | None:
    users = {1: "สมชาย", 2: "สมหญิง"}
    return users.get(user_id)
```

---

### 3.3 Number

Python มี number types หลัก 3 ชนิด: `int`, `float`, `complex`

```python
# Integer (ไม่จำกัดขนาด)
large_num = 10 ** 100  # จำนวนเต็มขนาดใหญ่
print(large_num)

# Float (ทศนิยม)
pi = 3.14159
scientific = 1.5e-3  # 0.0015

# Complex
z = 3 + 4j
print(z.real, z.imag)  # 3.0 4.0

# การดำเนินการทางคณิตศาสตร์
a, b = 10, 3
print(a + b)   # 13
print(a - b)   # 7
print(a * b)   # 30
print(a / b)   # 3.3333...
print(a // b)  # 3 (floor division)
print(a % b)   # 1 (modulo)
print(a ** b)  # 1000 (exponent)

# ระวัง: float precision
print(0.1 + 0.2)  # 0.30000000000000004
# ใช้ decimal สำหรับงานการเงิน
from decimal import Decimal
print(Decimal("0.1") + Decimal("0.2"))  # 0.3
```
โค้ดนี้เป็นตัวอย่างการใช้งาน **ชนิดข้อมูลตัวเลขใน Python** และตัวดำเนินการทางคณิตศาสตร์ พร้อมข้อควรระวังเรื่องทศนิยม

## 1. Integer — จำนวนเต็มไม่จำกัดขนาด
```python
large_num = 10 ** 100
print(large_num)
```
- `10 ** 100` คือ 10 ยกกำลัง 100
- ผลลัพธ์คือเลข 1 ตามด้วย 0 จำนวน 100 ตัว
- Python 3 รองรับจำนวนเต็มขนาดใหญ่ได้ โดยแทบไม่จำกัดขนาดตายตัว แต่จริง ๆ แล้วขึ้นอยู่กับหน่วยความจำของเครื่อง

## 2. Float — จำนวนทศนิยม
```python
pi = 3.14159
scientific = 1.5e-3
```
- `3.14159` เป็นเลขทศนิยมปกติ
- `1.5e-3` คือสัญกรณ์วิทยาศาสตร์ มีค่าเท่ากับ `1.5 × 10⁻³ = 0.0015`
- `float` ใน Python เก็บแบบ binary floating-point จึงมีความคลาดเคลื่อนได้

## 3. Complex — จำนวนเชิงซ้อน
```python
z = 3 + 4j
print(z.real, z.imag)
```
- `z` เป็นจำนวนเชิงซ้อน `3 + 4j`
- `z.real` คือส่วนจริง = `3.0`
- `z.imag` คือส่วนจินตภาพ = `4.0`
- หน่วยจินตภาพใน Python ใช้ `j` ไม่ใช่ `i`

## 4. ตัวดำเนินการทางคณิตศาสตร์
```python
a, b = 10, 3
```
| นิพจน์ | ความหมาย | ผลลัพธ์ |
|---|---|---|
| `a + b` | บวก | `13` |
| `a - b` | ลบ | `7` |
| `a * b` | คูณ | `30` |
| `a / b` | หารปกติ | `3.3333333333333335` |
| `a // b` | หารปัดลง floor division | `3` |
| `a % b` | เศษเหลือ modulo | `1` |
| `a ** b` | ยกกำลัง | `1000` |

จุดสำคัญ:
- `/` จะให้ผลลัพธ์เป็น `float` เสมอ
- `//` คือหารแล้วปัดลง
- `%` คือเศษที่เหลือจากการหาร
- `**` คือยกกำลัง

## 5. ข้อควรระวังเรื่อง float precision
```python
print(0.1 + 0.2)
```
ผลลัพธ์คือ:
```python
0.30000000000000004
```
ทั้งนี้เพราะคอมพิวเตอร์เก็บเลขทศนิยมแบบฐานสอง จึงไม่สามารถแทนค่า `0.1` และ `0.2` ได้อย่างแม่นยำทั้งหมด ทำให้เกิดความคลาดเคลื่อนเล็กน้อย

## 6. ใช้ Decimal สำหรับงานการเงิน
```python
from decimal import Decimal
print(Decimal("0.1") + Decimal("0.2"))
```
ผลลัพธ์:
```python
0.3
```
- `Decimal` ทำงานกับเลขฐานสิบ จึงเหมาะกับงานที่ต้องการความแม่นยำ เช่น เงิน
- ควรสร้างจาก **string** เช่น `Decimal("0.1")` ไม่ควรใช้ `Decimal(0.1)` เพราะ `0.1` แบบ float มีความคลาดเคลื่อนอยู่แล้ว
- ถึงใช้ `Decimal` ก็ยังควรกำหนด rounding และ precision ให้เหมาะสมกับงานจริง

## สรุป
โค้ดนี้แสดงให้เห็นว่า Python มีชนิดข้อมูลตัวเลขหลัก ๆ คือ:
- `int` จำนวนเต็ม
- `float` ทศนิยม
- `complex` จำนวนเชิงซ้อน

พร้อมตัวดำเนินการ `+ - * / // % **` และข้อควรระวังว่า `float` อาจไม่แม่นยำสำหรับงานการเงิน จึงควรใช้ `Decimal` แทน
---

### 3.4 String

String เป็น immutable sequence ของ Unicode characters

```python
# การสร้าง string
s1 = "Hello"
s2 = 'World'
s3 = """Multi-line
string"""

# String methods ที่ใช้บ่อย
text = "  Python Programming  "
print(text.strip())        # "Python Programming"
print(text.lower())        # "  python programming  "
print(text.upper())        # "  PYTHON PROGRAMMING  "
print(text.replace("Python", "Java"))  # "  Java Programming  "
print(text.split())        # ['Python', 'Programming']

# f-strings (Python 3.6+)
name = "สมชาย"
age = 30
print(f"{name} อายุ {age} ปี")  # สมชาย อายุ 30 ปี
print(f"{name=}, {age=}")       # name='สมชาย', age=30

# String formatting
print("ชื่อ: {}, อายุ: {}".format(name, age))
print("ชื่อ: {0}, อายุ: {1}".format(name, age))

# Slicing
s = "Python"
print(s[0])     # P
print(s[-1])    # n
print(s[1:4])   # yth
print(s[::-1])  # nohtyP (reverse)
```

---

### 3.5 Boolean

```python
# Boolean values
is_valid = True
is_empty = False

# Truthy และ Falsy
# Falsy: False, None, 0, 0.0, "", [], {}, set()
print(bool(""))      # False
print(bool("hello")) # True
print(bool(0))       # False
print(bool([1, 2]))  # True

# การดำเนินการทางตรรกะ
print(True and False)  # False
print(True or False)   # True
print(not True)        # False

# Short-circuit evaluation
def check():
    print("called")
    return True

result = False and check()  # check() ไม่ถูกเรียก
result = True or check()    # check() ไม่ถูกเรียก
```

---

### 3.6 None

`None` เป็น singleton object ใช้แทน "ไม่มีค่า"

```python
result = None

# ตรวจสอบ None ต้องใช้ "is" ไม่ใช่ "=="
if result is None:
    print("ยังไม่มีค่า")

# None เป็น falsy
print(bool(None))  # False

# Type hint
from typing import Optional
def get_user(user_id: int) -> Optional[str]:
    if user_id <= 0:
        return None
    return "สมชาย"
```

---

### 3.7 Operator

```python
# Arithmetic
x, y = 10, 3
print(x + y)   # 13
print(x // y)  # 3
print(x ** y)  # 1000

# Comparison
print(x == y)  # False
print(x != y)  # True
print(x > y)   # True

# Logical
a, b = True, False
print(a and b)  # False
print(a or b)   # True
print(not a)    # False

# Identity
list1 = [1, 2, 3]
list2 = [1, 2, 3]
list3 = list1
print(list1 is list2)  # False (คนละ object)
print(list1 is list3)  # True (object เดียวกัน)
print(list1 == list2)  # True (ค่าเท่ากัน)

# Membership
print(2 in [1, 2, 3])     # True
print("a" in "abc")        # True
print("x" not in "abc")   # True

# Walrus Operator (Python 3.8+)
if (n := len("hello")) > 3:
    print(f"ความยาว {n} มากกว่า 3")
```

---

### 3.8 การรับและแสดงผลข้อมูล

```python
# Input
name = input("กรุณาใส่ชื่อ: ")
age = int(input("กรุณาใส่อายุ: "))

# Output
print("Hello")
print("Hello", "World")        # Hello World
print("Hello", "World", sep=", ")  # Hello, World
print("Hello", end="")          # ไม่ขึ้นบรรทัดใหม่

# Formatted output
print(f"ชื่อ: {name}, อายุ: {age}")

# sys.stdout
import sys
sys.stdout.write("Hello\n")
```

---

### 3.9 เงื่อนไข if / elif / else

```python
score = 85

if score >= 80:
    grade = "A"
elif score >= 70:
    grade = "B"
elif score >= 60:
    grade = "C"
elif score >= 50:
    grade = "D"
else:
    grade = "F"

print(f"เกรด: {grade}")  # เกรด: A

# Ternary Operator
status = "ผ่าน" if score >= 50 else "ไม่ผ่าน"

# Match-Case (Python 3.10+)
def handle_command(command: str) -> None:
    match command.split():
        case ["go", direction]:
            print(f"ไปทาง {direction}")
        case ["look"]:
            print("มองไปรอบ ๆ")
        case ["take", item]:
            print(f"หยิบ {item}")
        case _:
            print("คำสั่งไม่รู้จัก")

handle_command("go north")
```

---

### 3.10 การวนซ้ำ for

```python
# วนซ้ำ list
fruits = ["apple", "banana", "cherry"]
for fruit in fruits:
    print(fruit)

# ใช้ enumerate สำหรับ index
for i, fruit in enumerate(fruits, start=1):
    print(f"{i}. {fruit}")

# วนซ้ำ dictionary
person = {"name": "สมชาย", "age": 30, "city": "กรุงเทพ"}
for key, value in person.items():
    print(f"{key}: {value}")

# วนซ้ำ range
for i in range(5):
    print(i)  # 0, 1, 2, 3, 4

for i in range(2, 10, 2):
    print(i)  # 2, 4, 6, 8

# List Comprehension
squares = [x ** 2 for x in range(10)]
print(squares)  # [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

# Nested loop
matrix = [[1, 2], [3, 4], [5, 6]]
for row in matrix:
    for val in row:
        print(val, end=" ")
    print()
```

---

### 3.11 การวนซ้ำ while

```python
# while พื้นฐาน
count = 0
while count < 5:
    print(count)
    count += 1

# while True + break
import random
while True:
    number = random.randint(1, 10)
    print(f"สุ่มได้: {number}")
    if number == 7:
        break

# while + else (ทำงานเมื่อ loop จบปกติ ไม่ใช่ break)
i = 0
while i < 3:
    print(i)
    i += 1
else:
    print("จบการวนซ้ำ")
```

---

### 3.12 break / continue / pass

```python
# break — ออกจาก loop ทันที
for i in range(10):
    if i == 5:
        break
    print(i)  # 0, 1, 2, 3, 4

# continue — ข้ามรอบปัจจุบัน
for i in range(5):
    if i == 2:
        continue
    print(i)  # 0, 1, 3, 4

# pass — ไม่ทำอะไร (placeholder)
def my_function():
    pass  # TODO: implement later

class MyClass:
    pass

# ใช้ pass ใน if
if True:
    pass
```

---

### 3.13 ฟังก์ชัน

```python
# ฟังก์ชันพื้นฐาน
def greet(name: str) -> str:
    """Return a greeting message."""
    return f"สวัสดี, {name}!"

# ฟังก์ชันที่มี default argument
def power(base: float, exponent: float = 2) -> float:
    return base ** exponent

print(power(3))     # 9
print(power(2, 3))  # 8

# Keyword arguments
def create_user(name: str, age: int, city: str = "กรุงเทพ") -> dict:
    return {"name": name, "age": age, "city": city}

user = create_user(name="สมชาย", age=30, city="เชียงใหม่")

# *args และ **kwargs
def sum_all(*args: float) -> float:
    return sum(args)

print(sum_all(1, 2, 3, 4))  # 10

def print_info(**kwargs: str) -> None:
    for key, value in kwargs.items():
        print(f"{key}: {value}")

print_info(name="สมชาย", age="30")
```

---

### 3.14 พารามิเตอร์และอาร์กิวเมนต์

```python
# Positional arguments
def divide(a: float, b: float) -> float:
    return a / b

divide(10, 2)  # 5.0

# Keyword arguments
divide(a=10, b=2)

# Mixed (positional ต้องมาก่อน keyword)
divide(10, b=2)

# Default arguments
def connect(host: str, port: int = 5432, ssl: bool = True):
    print(f"Connecting to {host}:{port} (SSL: {ssl})")

connect("localhost")
connect("localhost", 3306)
connect("localhost", ssl=False)

# ระวัง: mutable default argument
# ❌ ผิด — list ถูกแชร์ระหว่างการเรียก
def add_item_bad(item, items=[]):
    items.append(item)
    return items

# ✅ ถูก — ใช้ None เป็น default
def add_item_good(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```

---

### 3.15 return

```python
# return เดียว
def square(x: int) -> int:
    return x ** 2

# return หลายค่า (tuple)
def min_max(numbers: list[int]) -> tuple[int, int]:
    return min(numbers), max(numbers)

low, high = min_max([3, 1, 4, 1, 5])
print(low, high)  # 1 5

# return None โดยปริยาย
def log(message: str) -> None:
    print(f"[LOG] {message}")

result = log("test")
print(result)  # None

# return เพื่อออกจากฟังก์ชันก่อนเวลา
def find_user(users: list[dict], user_id: int) -> dict | None:
    for user in users:
        if user["id"] == user_id:
            return user
    return None
```

---

### 3.16 Scope และ Namespace

Python ใช้ **LEGB Rule** ในการ resolve ชื่อตัวแปร: **L**ocal → **E**nclosing → **G**lobal → **B**uilt-in

```python
# Global scope
global_var = "global"

def outer():
    # Enclosing scope
    enclosing_var = "enclosing"

    def inner():
        # Local scope
        local_var = "local"
        print(local_var)        # local
        print(enclosing_var)    # enclosing
        print(global_var)       # global
        print(len("hello"))     # built-in

    inner()

outer()

# ใช้ global keyword
counter = 0
def increment():
    global counter
    counter += 1

# ใช้ nonlocal keyword
def make_counter():
    count = 0
    def increment():
        nonlocal count
        count += 1
        return count
    return increment

counter = make_counter()
print(counter())  # 1
print(counter())  # 2
```

---

### 3.17 Lambda Expression

Lambda คือฟังก์ชันไม่ระบุชื่อ (anonymous function) ใช้สำหรับงานสั้น ๆ

```python
# Lambda พื้นฐาน
square = lambda x: x ** 2
print(square(5))  # 25

# ใช้กับ sorted
students = [
    {"name": "สมชาย", "score": 85},
    {"name": "สมหญิง", "score": 92},
    {"name": "วิชัย", "score": 78},
]

sorted_by_score = sorted(students, key=lambda s: s["score"], reverse=True)
# [{'name': 'สมหญิง', 'score': 92}, ...]

# ใช้กับ map
numbers = [1, 2, 3, 4, 5]
squared = list(map(lambda x: x ** 2, numbers))
print(squared)  # [1, 4, 9, 16, 25]

# ใช้กับ filter
evens = list(filter(lambda x: x % 2 == 0, numbers))
print(evens)  # [2, 4]

# ข้อจำกัด: lambda ควรใช้เฉพาะกรณีสั้น ๆ
# ถ้าซับซ้อน ให้ใช้ def แทน
```

---

### 3.18 Recursion

Recursion คือฟังก์ชันที่เรียกตัวเอง ใช้แก้ปัญหาที่แบ่งเป็นปัญหาย่อย ๆ ได้

```python
# Factorial
def factorial(n: int) -> int:
    if n <= 1:
        return 1
    return n * factorial(n - 1)

print(factorial(5))  # 120

# Fibonacci
def fibonacci(n: int) -> int:
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

print(fibonacci(10))  # 55

# Recursion กับ Memoization
from functools import lru_cache

@lru_cache(maxsize=None)
def fibonacci_fast(n: int) -> int:
    if n <= 1:
        return n
    return fibonacci_fast(n - 1) + fibonacci_fast(n - 2)

print(fibonacci_fast(100))  # 354224848179261915075

# ระวัง: Recursion depth limit
import sys
print(sys.getrecursionlimit())  # 1000 (default)
# sys.setrecursionlimit(10000)  # เพิ่มได้แต่ระวัง stack overflow

# Binary Tree Traversal
class TreeNode:
    def __init__(self, value, left=None, right=None):
        self.value = value
        self.left = left
        self.right = right

def inorder(node: TreeNode | None) -> list:
    if node is None:
        return []
    return inorder(node.left) + [node.value] + inorder(node.right)
```

---

### 3.19 Module

Module คือไฟล์ `.py` ที่มีโค้ด Python ช่วยจัดระเบียบโค้ด

```python
# math_utils.py
"""Utility functions for math operations."""

def add(a: float, b: float) -> float:
    return a + b

def multiply(a: float, b: float) -> float:
    return a * b

PI = 3.14159
```

```python
# main.py
import math_utils

print(math_utils.add(2, 3))       # 5
print(math_utils.PI)              # 3.14159

# หรือ import เฉพาะที่ต้องการ
from math_utils import add, PI
print(add(2, 3))
```

---

### 3.20 Package

Package คือโฟลเดอร์ที่มีไฟล์ `__init__.py` (หรือไม่ก็ได้ใน Python 3.3+) ประกอบด้วย modules

```
my_package/
├── __init__.py
├── math_utils.py
├── string_utils.py
└── subpackage/
    ├── __init__.py
    └── advanced.py
```

```python
# __init__.py
"""My package."""
from .math_utils import add, multiply
from .string_utils import capitalize

__all__ = ["add", "multiply", "capitalize"]

# การใช้งาน
from my_package import add, capitalize
from my_package.subpackage.advanced import complex_function
```

---

### 3.21 import

```python
# Import module ทั้งหมด
import os
import sys

# Import เฉพาะฟังก์ชัน/คลาส
from os import path, getcwd

# Import พร้อม alias
import numpy as np
import pandas as pd
from datetime import datetime as dt

# Import ทั้งหมดจาก module (ไม่แนะนำ)
from math import *

# Relative import (ภายใน package)
from . import sibling_module
from .. import parent_module

# ตรวจสอบ module path
import sys
print(sys.path)
```

---

### 3.22 `__name__` และ `__main__`

```python
# my_module.py
def main():
    print("Running as main program")

if __name__ == "__main__":
    main()
```

**ความหมาย:**
- เมื่อรัน `python my_module.py` โดยตรง → `__name__ == "__main__"`
- เมื่อ import จากไฟล์อื่น → `__name__ == "my_module"`

**ประโยชน์:**
- ป้องกันโค้ดรันเมื่อถูก import
- ใช้เป็น entry point ของ script
- ใช้สำหรับ testing module

---

### 3.23 Comment และ Docstring

```python
# นี่คือ comment บรรทัดเดียว

"""
นี่คือ multi-line comment
แต่จริง ๆ แล้วเป็น string ที่ไม่ถูก assign
"""

def calculate_area(width: float, height: float) -> float:
    """
    คำนวณพื้นที่สี่เหลี่ยม

    Args:
        width: ความกว้าง
        height: ความสูง

    Returns:
        พื้นที่ของสี่เหลี่ยม

    Raises:
        ValueError: ถ้า width หรือ height ติดลบ

    Examples:
        >>> calculate_area(3, 4)
        12.0
    """
    if width < 0 or height < 0:
        raise ValueError("ความกว้างและความสูงต้องไม่ติดลบ")
    return width * height

# ดู docstring
print(calculate_area.__doc__)
help(calculate_area)
```

**PEP 257 — Docstring Conventions:**
- ใช้ triple double quotes `"""`
- บรรทัดแรกเป็น summary
- เว้นบรรทัดว่างหลัง summary
- ใช้ Google style หรือ NumPy style

---

### 3.24 PEP 8

PEP 8 เป็น Style Guide อย่างเป็นทางการของ Python

**กฎสำคัญ:**

| หัวข้อ | กฎ |
|--------|-----|
| Indentation | 4 spaces, ห้ามใช้ tab |
| Line Length | สูงสุด 79 characters (แนะนำ 88 สำหรับ Black) |
| Blank Lines | 2 บรรทัดระหว่าง top-level definitions, 1 บรรทัดระหว่าง methods |
| Imports | แยกบรรทัด, จัดกลุ่ม (stdlib, third-party, local) |
| Naming | `snake_case` สำหรับ functions/variables, `PascalCase` สำหรับ classes, `UPPER_CASE` สำหรับ constants |
| Whitespace | เว้น 1 space รอบ operators |
| Comments | ใช้ `# ` นำหน้า |

**ตัวอย่างโค้ดที่เป็นไปตาม PEP 8:**
```python
# ✅ ถูกต้อง
import os
import sys
from typing import List, Dict, Optional


MAX_RETRIES = 3


class UserService:
    """Service for user operations."""

    def __init__(self, db_connection: str):
        self.db_connection = db_connection
        self._cache: Dict[str, dict] = {}

    def find_user(self, user_id: int) -> Optional[dict]:
        """Find user by ID."""
        if user_id in self._cache:
            return self._cache[user_id]
        # ... logic
        return None


def calculate_total(
    items: List[dict],
    tax_rate: float = 0.07,
) -> float:
    """Calculate total price with tax."""
    subtotal = sum(item["price"] * item["qty"] for item in items)
    return subtotal * (1 + tax_rate)
```

**เครื่องมือตรวจสอบ PEP 8:**
```bash
pip install ruff black
ruff check .
ruff format .
```

> **อ้างอิงเพิ่มเติม:** [PEP 8 — Style Guide for Python Code](https://peps.python.org/pep-0008/)

---

### 3.25 Type Hint เบื้องต้น

Type Hints ช่วยให้โค้ดอ่านง่ายขึ้น และ IDE ตรวจสอบ type ได้

```python
from typing import Optional, Union, List, Dict, Tuple, Callable

# ตัวแปร
name: str = "สมชาย"
age: int = 30
scores: List[float] = [85.5, 92.0, 78.5]
user: Dict[str, Union[str, int]] = {"name": "สมชาย", "age": 30}

# ฟังก์ชัน
def greet(name: str, times: int = 1) -> str:
    return f"สวัสดี {name}! " * times

# Optional (อาจเป็น None)
def find_user(user_id: int) -> Optional[str]:
    users = {1: "สมชาย", 2: "สมหญิง"}
    return users.get(user_id)

# Union
def process_id(value: Union[int, str]) -> str:
    return str(value)

# Python 3.10+ ใช้ |
def process_id_v2(value: int | str) -> str:
    return str(value)

# Callable
def apply(func: Callable[[int], int], value: int) -> int:
    return func(value)

# Generic
from typing import TypeVar, Generic

T = TypeVar("T")

def first(items: List[T]) -> T:
    return items[0]

# Pydantic สำหรับ runtime validation
from pydantic import BaseModel, Field

class User(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    age: int = Field(ge=0, le=150)
    email: str

user = User(name="สมชาย", age=30, email="somchai@email.com")
print(user.model_dump())
```

**ข้อดีของ Type Hints:**
- IDE แนะนำได้แม่นยำขึ้น
- ตรวจสอบ type ก่อน runtime (ด้วย mypy, pyright)
- เอกสารประกอบในตัว
- Refactoring ปลอดภัยขึ้น

**ข้อควรระวัง:**
- Type hints ไม่บังคับที่ runtime (ยกเว้นใช้ Pydantic)
- ไม่ควร over-annotate — เพิ่มเมื่อมีประโยชน์จริง ๆ
- ใช้ `from __future__ import annotations` สำหรับ forward references

> **อ้างอิงเพิ่มเติม:** [typing — Support for type hints](https://docs.python.org/3/library/typing.html), [mypy Documentation](https://mypy.readthedocs.io/)

---

## สรุปเล่ม 1

เล่ม 1 วางรากฐานที่จำเป็นสำหรับการเป็นนักพัฒนา Python ที่มีคุณภาพ ครอบคลุมตั้งแต่:

1. **Software Architecture** — เข้าใจภาพรวมของระบบ: Data Structures, Algorithms, Big O, OOP, Functional Programming, System Design, CI/CD, Cloud, DDD, Clean Architecture
2. **แม่แบบการเขียนเนื้อหา** — โครงสร้างที่ทำให้ทุกบทมีความสม่ำเสมอ ครอบคลุมทุกมิติ
3. **ปฐมบทและภาพรวม** — ทำไมต้อง Python, เส้นทางการเรียนรู้, เครื่องมือที่ต้องเตรียม
4. **การติดตั้งและสภาพแวดล้อม** — ตั้งแต่ติดตั้ง Python ไปจนถึง IDE, venv, Git, linting
5. **พื้นฐานภาษา Python** — Syntax, Data Types, Control Flow, Functions, Modules, PEP 8, Type Hints

**สิ่งที่ผู้อ่านควรทำได้หลังอ่านเล่ม 1:**
- ติดตั้ง Python และตั้งค่าสภาพแวดล้อมได้
- เข้าใจ syntax พื้นฐานและเขียนโปรแกรมง่าย ๆ ได้
- ใช้ type hints และ PEP 8 ในการเขียนโค้ด
- ใช้ Git และ Virtual Environment ได้
- เข้าใจภาพรวมของ Software Architecture และหลักการออกแบบ

**ก้าวต่อไป:** เล่ม 2 จะเข้าสู่เนื้อหาเชิงลึกเกี่ยวกับ Data Structures, OOP และ Functional Programming

---

**อ้างอิงหลักของเล่ม 1:**

| แหล่งอ้างอิง | URL |
|-------------|-----|
| Python Official Tutorial | https://docs.python.org/3/tutorial/ |
| PEP 8 Style Guide | https://peps.python.org/pep-0008/ |
| Python venv Documentation | https://docs.python.org/3/library/venv.html |
| typing — Type Hints | https://docs.python.org/3/library/typing.html |
| Real Python — Python Basics | https://realpython.com/learning-paths/python-basics/ |
| Packaging — pip and venv | https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/ |
| VS Code Python Setup | https://code.visualstudio.com/docs/languages/python |
| GitHub Actions for Python | https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-python |
| Boto3 Documentation | https://boto3.amazonaws.com/v1/documentation/api/latest/index.html |
| Clean Architecture | https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html |
| Domain-Driven Design Reference | https://www.domainlanguage.com/ddd/reference/ |
| Big O Cheat Sheet | https://www.bigocheatsheet.com/ |

---

*จบเล่ม 1 — พร้อมสำหรับเล่ม 2: โครงสร้างข้อมูล OOP และ Functional Programming*