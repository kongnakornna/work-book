# เล่ม 2: โครงสร้างข้อมูล OOP และ Functional Programming

**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับสมบูรณ์ (ภาค 4–6)

---

## องค์ประกอบนำเล่ม

- ปก
- หน้าข้อมูลผู้แต่ง
- คำนำ
- สารบัญ
- สารบัญภาพ / ตาราง (ถ้ามี)

---

## คำนำ

เล่ม 2 นี้ต่อยอดจากเล่ม 1 ที่วางรากฐานภาษา Python ไปสู่เนื้อหาเชิงลึก 3 ด้านหลัก:

1. **โครงสร้างข้อมูลและอัลกอริทึม** — เครื่องมือสำคัญในการจัดเก็บและประมวลผลข้อมูลอย่างมีประสิทธิภาพ
2. **การเขียนโปรแกรมเชิงวัตถุ (OOP)** — กระบวนทัศน์ที่ช่วยจัดระเบียบโค้ดขนาดใหญ่ให้ manageable
3. **การเขียนโปรแกรมเชิงฟังก์ชัน (FP)** — กระบวนทัศน์ที่เน้นความบริสุทธิ์ของฟังก์ชันและการไม่เปลี่ยนแปลงข้อมูล

ทุกภาคจะมาพร้อมตัวอย่างการใช้งานจริงในบริบทของงานพัฒนาระบบ เพื่อให้ผู้อ่านสามารถนำไปประยุกต์ใช้ได้ทันที

> **หมายเหตุ:** ทุกบทในเล่มนี้ใช้โครงสร้างย่อยตาม **ส่วนที่ 2: แม่แบบการเขียนเนื้อหา** จากเล่ม 1

---

# ภาค 4: โครงสร้างข้อมูลและอัลกอริทึม

## 4.1 List

### บทนำ

List เป็นโครงสร้างข้อมูลที่ยืดหยุ่นที่สุดใน Python ใช้เก็บข้อมูลหลายรายการเรียงตามลำดับ รองรับการเพิ่ม ลบ แก้ไข และเข้าถึงข้อมูลได้อย่างรวดเร็ว เป็นโครงสร้างข้อมูลที่นักพัฒนา Python ใช้บ่อยที่สุด

### นิยาม

List คือ mutable sequence ของ Python objects เรียงตาม index เริ่มจาก 0 สามารถเก็บข้อมูลชนิดใดก็ได้ (heterogeneous) และเปลี่ยนแปลงขนาดได้ตลอดเวลา

### 4.1.1 คืออะไร

List เป็น built-in data structure ที่ implement เป็น dynamic array ใน CPython เมื่อเพิ่มข้อมูลเกิน capacity จะ resize อัตโนมัติ (โดยประมาณ 1.125 เท่า)

### 4.1.2 ทำงานอย่างไร

List จัดเก็บ pointer ไปยัง objects ในหน่วยความจำแบบต่อเนื่อง ทำให้:
- **การเข้าถึงด้วย index:** O(1)
- **การเพิ่มท้าย (append):** amortized O(1)
- **การแทรก/ลบกลาง:** O(n)
- **การค้นหา (linear search):** O(n)

### 4.1.3 การใช้งาน

**การสร้าง List:**
```python
# วิธีต่าง ๆ ในการสร้าง list
empty = []
numbers = [1, 2, 3, 4, 5]
mixed = [1, "hello", 3.14, True, None]
nested = [[1, 2], [3, 4], [5, 6]]
from_range = list(range(10))
from_string = list("Python")  # ['P', 'y', 't', 'h', 'o', 'n']

# List comprehension
squares = [x ** 2 for x in range(10)]
evens = [x for x in range(20) if x % 2 == 0]
```

**การเข้าถึงและแก้ไข:**
```python
fruits = ["apple", "banana", "cherry", "date"]

# เข้าถึงด้วย index
print(fruits[0])     # apple
print(fruits[-1])    # date
print(fruits[1:3])   # ['banana', 'cherry']

# แก้ไข
fruits[1] = "blueberry"
print(fruits)  # ['apple', 'blueberry', 'cherry', 'date']

# Slicing assignment
fruits[1:3] = ["kiwi", "mango"]
print(fruits)  # ['apple', 'kiwi', 'mango', 'date']
```

**Methods ที่ใช้บ่อย:**
```python
numbers = [3, 1, 4, 1, 5, 9, 2, 6]

# เพิ่ม
numbers.append(8)         # เพิ่มท้าย
numbers.insert(0, 0)      # แทรกที่ index 0
numbers.extend([7, 10])   # ต่อท้ายด้วย list อื่น

# ลบ
numbers.remove(1)         # ลบตัวแรกที่เจอ
popped = numbers.pop()    # ลบตัวสุดท้ายและคืนค่า
del numbers[0]            # ลบตาม index
numbers.clear()           # ลบทั้งหมด

# ค้นหาและนับ
numbers = [3, 1, 4, 1, 5, 9, 2, 6]
print(numbers.index(4))   # 2
print(numbers.count(1))   # 2
print(4 in numbers)       # True

# เรียงลำดับ
numbers.sort()                  # เรียงจากน้อยไปมาก (in-place)
numbers.sort(reverse=True)      # เรียงจากมากไปน้อย
sorted_copy = sorted(numbers)   # คืน list ใหม่

# กลับลำดับ
numbers.reverse()
```

**ตัวอย่างการใช้งานจริง — ระบบจัดการรายการสินค้า:**
```python
from dataclasses import dataclass

@dataclass
class Product:
    name: str
    price: float
    qty: int

class ShoppingCart:
    def __init__(self):
        self.items: list[Product] = []

    def add_product(self, product: Product) -> None:
        # ถ้ามีอยู่แล้วให้บวกจำนวน
        for item in self.items:
            if item.name == product.name:
                item.qty += product.qty
                return
        self.items.append(product)

    def remove_product(self, name: str) -> bool:
        for i, item in enumerate(self.items):
            if item.name == name:
                self.items.pop(i)
                return True
        return False

    def total(self) -> float:
        return sum(item.price * item.qty for item in self.items)

    def top_expensive(self, n: int = 3) -> list[Product]:
        return sorted(self.items, key=lambda p: p.price, reverse=True)[:n]

# การใช้งาน
cart = ShoppingCart()
cart.add_product(Product("Laptop", 35000, 1))
cart.add_product(Product("Mouse", 850, 2))
cart.add_product(Product("Keyboard", 2500, 1))
cart.add_product(Product("Monitor", 12000, 2))

print(f"ยอดรวม: {cart.total():,.2f} บาท")
# ยอดรวม: 62,200.00 บาท

for p in cart.top_expensive():
    print(f"{p.name}: {p.price:,} บาท")
```

### 4.1.4 ข้อดี

- **ยืดหยุ่นสูง:** เก็บข้อมูลชนิดใดก็ได้
- **เข้าถึงเร็ว:** O(1) ด้วย index
- **Methods ครบ:** append, sort, reverse, index, count
- **Comprehension:** สร้าง list ใหม่ได้กระชับ
- **Slicing:** ตัดข้อมูลเป็นช่วงได้ง่าย

### 4.1.5 ข้อเสีย

- **ค้นหาช้า:** O(n) ถ้าไม่มี index
- **แทรก/ลบกลางช้า:** O(n) เพราะต้องเลื่อน elements
- **ใช้หน่วยความจำมาก:** เก็บ pointer + overhead ของ object
- **ไม่เหมาะกับข้อมูลขนาดใหญ่มาก:** ควรใช้ array, numpy

### 4.1.6 ข้อควรระวัง

```python
# ระวัง 1: List เป็น mutable — การ assign คือ reference
a = [1, 2, 3]
b = a           # b ชี้ไปที่ list เดียวกัน
b.append(4)
print(a)        # [1, 2, 3, 4] ← a เปลี่ยนด้วย!

# ต้องใช้ copy
c = a.copy()    # shallow copy
d = a[:]        # shallow copy อีกวิธี
import copy
e = copy.deepcopy(a)  # deep copy (สำหรับ nested)

# ระวัง 2: ลบขณะวนซ้ำ
numbers = [1, 2, 3, 4, 5]
for n in numbers:
    if n % 2 == 0:
        numbers.remove(n)  # ❌ ผลลัพธ์ผิด
print(numbers)  # [1, 3, 5] — แต่อาจพลาดบางตัว

# ✅ ถูกต้อง: วนซ้ำบน copy หรือใช้ comprehension
numbers = [n for n in numbers if n % 2 != 0]

# ระวัง 3: sort กับ lambda ที่ return หลายค่า
products = [("A", 3), ("B", 1), ("C", 2)]
products.sort(key=lambda x: (x[1], x[0]))  # เรียงตาม qty แล้วชื่อ
```

### 4.1.7 สรุป

List เป็นโครงสร้างข้อมูลพื้นฐานที่ขาดไม่ได้ ใช้เมื่อ:
- ต้องการเก็บข้อมูลเรียงลำดับ
- ต้องเข้าถึงด้วย index บ่อย
- ข้อมูลมีการเปลี่ยนแปลงบ่อย
- ไม่ต้องการประสิทธิภาพสูงสุดในกรณีค้นหา/แทรกกลาง

> **อ้างอิงเพิ่มเติม:** [Python List Documentation](https://docs.python.org/3/tutorial/datastructures.html), [TimeComplexity — Python Wiki](https://wiki.python.org/moin/TimeComplexity)

---

## 4.2 Tuple

### บทนำ

Tuple เป็นโครงสร้างข้อมูล immutable ที่มีประสิทธิภาพสูงกว่า List ในด้านความเร็วและหน่วยความจำ ใช้เมื่อต้องการข้อมูลที่ไม่เปลี่ยนแปลง

### นิยาม

Tuple คือ immutable sequence ของ Python objects เขียนด้วยวงเล็บ `()` หรือไม่มีก็ได้ (ในบริบทที่ชัดเจน)

### 4.2.1 คืออะไร

Tuple เป็น built-in data structure ที่ไม่สามารถแก้ไขได้หลังสร้างเสร็จ ขนาดคงที่ ทำให้ใช้หน่วยความจำน้อยกว่า List และเข้าถึงเร็วกว่า

### 4.2.2 ทำงานอย่างไร

Tuple จัดเก็บ pointer ไปยัง objects ในหน่วยความจำแบบต่อเนื่องเช่นเดียวกับ List แต่ไม่สามารถ resize ได้ CPython ยังมี optimization สำหรับ tuple ว่างและ tuple ขนาดเล็ก (singleton)

### 4.2.3 การใช้งาน

```python
# การสร้าง tuple
empty = ()
single = (1,)        # ต้องมี comma ไม่งั้นเป็น int
coordinates = (10.5, 20.3)
mixed = (1, "hello", 3.14)
from_list = tuple([1, 2, 3])
nested = ((1, 2), (3, 4))

# เข้าถึง
print(coordinates[0])    # 10.5
print(coordinates[-1])   # 20.3
print(coordinates[0:2])  # (10.5, 20.3)

# Unpacking
x, y = coordinates
print(x, y)  # 10.5 20.3

# Unpacking ด้วย *
first, *rest = (1, 2, 3, 4, 5)
print(first, rest)  # 1 [2, 3, 4, 5]

# แลกค่า
a, b = 1, 2
a, b = b, a

# Methods
t = (1, 2, 3, 2, 4, 2)
print(t.count(2))  # 3
print(t.index(3))  # 2

# Named Tuple (อ่านง่ายกว่า)
from collections import namedtuple

Point = namedtuple("Point", ["x", "y"])
p = Point(10, 20)
print(p.x, p.y)  # 10 20

# typing.NamedTuple (แนะนำ)
from typing import NamedTuple

class Employee(NamedTuple):
    name: str
    age: int
    department: str

emp = Employee("สมชาย", 30, "IT")
print(emp.name)  # สมชาย
```

**ตัวอย่างการใช้งานจริง — การคืนค่าหลายค่าจากฟังก์ชัน:**
```python
from typing import NamedTuple

class BoundingBox(NamedTuple):
    x_min: float
    y_min: float
    x_max: float
    y_max: float

    @property
    def width(self) -> float:
        return self.x_max - self.x_min

    @property
    def height(self) -> float:
        return self.y_max - self.y_min

    @property
    def area(self) -> float:
        return self.width * self.height

def detect_face(image) -> BoundingBox | None:
    """ตรวจจับใบหน้าและคืนค่า bounding box"""
    # ... logic การตรวจจับ
    return BoundingBox(100, 50, 300, 250)

box = detect_face("image.jpg")
if box:
    print(f"พื้นที่ใบหน้า: {box.area:,} ตารางพิกเซล")
    print(f"ขนาด: {box.width}x{box.height}")
```

**ใช้เป็น dictionary key:**
```python
# Tuple ใช้เป็น key ได้ (เพราะ immutable)
locations = {
    (13.7563, 100.5018): "กรุงเทพ",
    (18.7883, 98.9853): "เชียงใหม่",
    (7.8804, 98.3923): "ภูเก็ต",
}

# List ใช้เป็น key ไม่ได้
# bad = {[1, 2]: "value"}  # ❌ TypeError
```

### 4.2.4 ข้อดี

- **Immutable:** ปลอดภัยจาก unintended modification
- **เร็วกว่า:** เข้าถึงเร็วกว่า List เล็กน้อย
- **ใช้หน่วยความจำน้อยกว่า:** ประหยัด RAM
- **Hashable:** ใช้เป็น dict key หรือ set member ได้
- **Unpacking:** ใช้งานสะดวก

### 4.2.5 ข้อเสีย

- **แก้ไขไม่ได้:** ต้องสร้างใหม่ถ้าต้องการเปลี่ยน
- **Methods น้อย:** มีแค่ count, index
- **ไม่เหมาะกับข้อมูลที่เปลี่ยนแปลงบ่อย**

### 4.2.6 ข้อควรระวัง

```python
# ระวัง: tuple ที่มี mutable object ข้างใน
t = (1, [2, 3])
t[1].append(4)  # ✅ ทำได้ (แก้ list ข้างใน)
print(t)        # (1, [2, 3, 4])
# t[1] = [5]   # ❌ ไม่ได้ (แก้ tuple โดยตรง)

# ระวัง: single element ต้องมี comma
not_tuple = (1)     # เป็น int
is_tuple = (1,)     # เป็น tuple
```

### 4.2.7 สรุป

ใช้ Tuple เมื่อ:
- ข้อมูลไม่เปลี่ยนแปลง (เช่น coordinates, config)
- ต้องการ performance สูงกว่า List
- ต้องการใช้เป็น dict key
- ต้องการคืนค่าหลายค่าจากฟังก์ชัน

> **อ้างอิงเพิ่มเติม:** [Python Tuple Documentation](https://docs.python.org/3/tutorial/datastructures.html#tuples-and-sequences)

---

## 4.3 Set

### บทนำ

Set เป็นโครงสร้างข้อมูลที่ไม่เรียงลำดับ เก็บค่าที่ไม่ซ้ำกัน เหมาะสำหรับงานที่ต้องการตรวจสอบ membership อย่างรวดเร็ว หรือดำเนินการทางเซต (union, intersection)

### นิยาม

Set คือ mutable, unordered collection ของ unique hashable objects ใช้ hash table ในการจัดเก็บ

### 4.3.1 คืออะไร

Set เป็น built-in data structure ที่ implement ตาม mathematical set รองรับ operations เช่น union, intersection, difference และ symmetric difference

### 4.3.2 ทำงานอย่างไร

Set ใช้ hash table:
- **การเพิ่ม/ลบ/ตรวจสอบ membership:** เฉลี่ย O(1)
- **กรณีแย่สุด:** O(n) ถ้า hash ชนกันมาก
- **ไม่รักษาลำดับ:** เพราะ hash-based

### 4.3.3 การใช้งาน

```python
# การสร้าง set
empty = set()  # ต้องใช้ set() ไม่ใช่ {} (นั่นคือ dict)
numbers = {1, 2, 3, 4, 5}
from_list = set([1, 2, 2, 3, 3, 3])  # {1, 2, 3}
from_string = set("hello")  # {'h', 'e', 'l', 'o'}

# เพิ่มและลบ
fruits = {"apple", "banana"}
fruits.add("cherry")
fruits.remove("apple")     # error ถ้าไม่มี
fruits.discard("xyz")      # ไม่ error ถ้าไม่มี
popped = fruits.pop()      # ลบและคืนค่าตัวใดตัวหนึ่ง

# Membership (เร็วมาก)
print("banana" in fruits)  # True
```

**Set Operations:**
```python
a = {1, 2, 3, 4, 5}
b = {4, 5, 6, 7, 8}

# Union — รวม
print(a | b)          # {1, 2, 3, 4, 5, 6, 7, 8}
print(a.union(b))

# Intersection — ส่วนร่วม
print(a & b)          # {4, 5}
print(a.intersection(b))

# Difference — ส่วนต่าง
print(a - b)          # {1, 2, 3}
print(a.difference(b))

# Symmetric Difference — ส่วนต่างทั้งสองทาง
print(a ^ b)          # {1, 2, 3, 6, 7, 8}
print(a.symmetric_difference(b))

# Subset / Superset
print({1, 2}.issubset(a))    # True
print(a.issuperset({1, 2}))  # True

# Disjoint
print({1, 2}.isdisjoint({3, 4}))  # True
```

**Frozen Set (immutable):**
```python
fs = frozenset([1, 2, 3])
# fs.add(4)  # ❌ AttributeError
# ใช้เป็น dict key ได้
d = {frozenset([1, 2]): "value"}
```

**ตัวอย่างการใช้งานจริง — การตรวจจับข้อมูลซ้ำ:**
```python
import hashlib
from pathlib import Path
from collections import defaultdict

def find_duplicate_files(directory: str) -> dict[str, list[Path]]:
    """ค้นหาไฟล์ที่มีเนื้อหาซ้ำกันโดยใช้ hash"""
    hashes: dict[str, list[Path]] = defaultdict(list)

    for file_path in Path(directory).rglob("*"):
        if not file_path.is_file():
            continue

        # คำนวณ SHA-256
        sha = hashlib.sha256()
        with open(file_path, "rb") as f:
            for chunk in iter(lambda: f.read(8192), b""):
                sha.update(chunk)

        hashes[sha.hexdigest()].append(file_path)

    # คืนเฉพาะกลุ่มที่มีไฟล์ซ้ำ
    return {h: files for h, files in hashes.items() if len(files) > 1}

duplicates = find_duplicate_files("./documents")
for h, files in duplicates.items():
    print(f"Hash {h[:8]}: {len(files)} ไฟล์ซ้ำ")
    for f in files:
        print(f"  - {f}")
```

**ตัวอย่าง — การตรวจสอบ tag:**
```python
class Article:
    def __init__(self, title: str, tags: set[str]):
        self.title = title
        self.tags = set(tags)

    def similar_to(self, other: "Article") -> float:
        """คำนวณ Jaccard similarity"""
        if not self.tags and not other.tags:
            return 1.0
        intersection = self.tags & other.tags
        union = self.tags | other.tags
        return len(intersection) / len(union)

a1 = Article("Python Basics", {"python", "programming", "tutorial"})
a2 = Article("Advanced Python", {"python", "programming", "oop"})
print(f"ความคล้าย: {a1.similar_to(a2):.2%}")  # 50.00%
```

### 4.3.4 ข้อดี

- **เร็วมาก:** O(1) สำหรับ membership, add, remove
- **Unique:** ไม่มีข้อมูลซ้ำโดยอัตโนมัติ
- **Operations ครบ:** union, intersection, difference
- **เหมาะกับงาน Deduplication**

### 4.3.5 ข้อเสีย

- **ไม่เรียงลำดับ:** ไม่สามารถเข้าถึงด้วย index
- **ต้อง hashable:** เก็บ list หรือ dict ไม่ได้
- **ใช้หน่วยความจำมากกว่า List:** เพราะมี overhead ของ hash table

### 4.3.6 ข้อควรระวัง

```python
# ระวัง: set ไม่เรียงลำดับ — อย่าพึ่งพาลำดับ
s = {3, 1, 2}
print(s)  # อาจเป็น {1, 2, 3} หรือ {3, 1, 2} ขึ้นกับ version

# ระวัง: empty set ต้องใช้ set()
not_set = {}      # นี่คือ dict ว่าง
empty_set = set()

# ระวัง: mutable objects ใส่ set ไม่ได้
# bad = {[1, 2], [3, 4]}  # ❌ TypeError
good = {(1, 2), (3, 4)}   # ✅ ใช้ tuple แทน

# ระวัง: remove vs discard
s = {1, 2, 3}
s.remove(99)   # ❌ KeyError
s.discard(99)  # ✅ ไม่ error
```

### 4.3.7 สรุป

ใช้ Set เมื่อ:
- ต้องการตรวจสอบ membership เร็ว ๆ
- ต้องการข้อมูล unique
- ต้องการดำเนินการทางเซต (union, intersection)
- ต้องการ deduplicate ข้อมูล

> **อ้างอิงเพิ่มเติม:** [Python Set Documentation](https://docs.python.org/3/tutorial/datastructures.html#sets)

---

## 4.4 Dictionary

### บทนำ

Dictionary เป็นโครงสร้างข้อมูล key-value ที่ทรงพลังที่สุดใน Python ใช้ hash table ในการจัดเก็บ ทำให้เข้าถึงค่าได้เร็วมาก เหมาะสำหรับการ lookup, mapping และการจัดกลุ่มข้อมูล

### นิยาม

Dictionary คือ mutable mapping ของ unique keys ไปยัง values keys ต้องเป็น hashable objects

### 4.4.1 คืออะไร

Dict เป็น built-in data structure ที่ implement เป็น hash table ใน CPython ตั้งแต่ Python 3.7 รับประกันการรักษาลำดับการ insert (insertion order)

### 4.4.2 ทำงานอย่างไร

Dict ใช้ hash function แปลง key เป็น index ใน hash table:
- **การเข้าถึง/เพิ่ม/ลบ:** เฉลี่ย O(1)
- **กรณีแย่สุด:** O(n) ถ้า hash ชนกันมาก
- **Iteration:** O(n) เรียงตามลำดับ insert

### 4.4.3 การใช้งาน

```python
# การสร้าง dict
empty = {}
person = {"name": "สมชาย", "age": 30, "city": "กรุงเทพ"}
from_pairs = dict([("a", 1), ("b", 2)])
from_kwargs = dict(name="สมชาย", age=30)
from_zip = dict(zip(["a", "b", "c"], [1, 2, 3]))

# Dict comprehension
squares = {x: x ** 2 for x in range(5)}
# {0: 0, 1: 1, 2: 4, 3: 9, 4: 16}

# เข้าถึงค่า
print(person["name"])              # สมชาย
print(person.get("salary", 0))     # 0 (default)
# person["salary"]  # ❌ KeyError

# เพิ่ม/แก้ไข
person["email"] = "somchai@email.com"
person["age"] = 31

# ลบ
del person["city"]
email = person.pop("email")
person.clear()

# ตรวจสอบ key
print("name" in person)  # True

# Iteration
person = {"name": "สมชาย", "age": 30, "city": "กรุงเทพ"}
for key in person:                    # keys
    print(key)

for value in person.values():         # values
    print(value)

for key, value in person.items():     # items
    print(f"{key}: {value}")

# Merge (Python 3.9+)
d1 = {"a": 1, "b": 2}
d2 = {"b": 3, "c": 4}
merged = d1 | d2  # {'a': 1, 'b': 3, 'c': 4}

# Merge (แบบเก่า)
merged2 = {**d1, **d2}

# Update in-place
d1.update(d2)
```

**Methods ที่ใช้บ่อย:**
```python
d = {"a": 1, "b": 2, "c": 3}

# setdefault — ตั้งค่า default ถ้า key ไม่มี
d.setdefault("d", 4)  # d = {"a": 1, "b": 2, "c": 3, "d": 4}
d.setdefault("a", 99) # a ยังเป็น 1 (ไม่ override)

# fromkeys — สร้าง dict จาก keys
keys = ["x", "y", "z"]
new_d = dict.fromkeys(keys, 0)  # {'x': 0, 'y': 0, 'z': 0}

# copy
import copy
shallow = d.copy()
deep = copy.deepcopy(d)
```

**defaultdict — จัดกลุ่มข้อมูลอัตโนมัติ:**
```python
from collections import defaultdict

# แทนที่จะต้องตรวจสอบ key ก่อน
words = ["apple", "banana", "avocado", "blueberry", "cherry"]
by_letter = defaultdict(list)

for word in words:
    by_letter[word[0]].append(word)

print(dict(by_letter))
# {'a': ['apple', 'avocado'], 'b': ['banana', 'blueberry'], 'c': ['cherry']}

# Counter สำหรับนับ
from collections import Counter

text = "the quick brown fox jumps over the lazy dog the fox"
word_counts = Counter(text.split())
print(word_counts.most_common(3))
# [('the', 3), ('fox', 2), ('quick', 1)]
```

**ตัวอย่างการใช้งานจริง — Cache ด้วย Dict:**
```python
from functools import wraps
from time import time

def simple_cache(func):
    """Simple memoization decorator"""
    cache: dict = {}

    @wraps(func)
    def wrapper(*args):
        if args not in cache:
            cache[args] = func(*args)
        return cache[args]
    return wrapper

@simple_cache
def fibonacci(n: int) -> int:
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

start = time()
print(fibonacci(100))  # 354224848179261915075
print(f"ใช้เวลา: {time() - start:.4f}s")
```

**ตัวอย่าง — Configuration Management:**
```python
from typing import Any
import json
from pathlib import Path

class Config:
    def __init__(self, defaults: dict[str, Any] | None = None):
        self._data = defaults or {}

    def load_from_file(self, path: str) -> None:
        with open(path, encoding="utf-8") as f:
            file_data = json.load(f)
        self._data = self._deep_merge(self._data, file_data)

    @staticmethod
    def _deep_merge(base: dict, override: dict) -> dict:
        result = base.copy()
        for key, value in override.items():
            if (
                key in result
                and isinstance(result[key], dict)
                and isinstance(value, dict)
            ):
                result[key] = Config._deep_merge(result[key], value)
            else:
                result[key] = value
        return result

    def get(self, key: str, default: Any = None) -> Any:
        keys = key.split(".")
        value: Any = self._data
        for k in keys:
            if not isinstance(value, dict) or k not in value:
                return default
            value = value[k]
        return value

config = Config({
    "database": {"host": "localhost", "port": 5432},
    "debug": False,
})

config.load_from_file("config.json")
print(config.get("database.host"))  # localhost
```

**Dictionary View Objects:**
```python
d = {"a": 1, "b": 2, "c": 3}

keys = d.keys()      # dict_keys(['a', 'b', 'c'])
values = d.values()  # dict_values([1, 2, 3])
items = d.items()    # dict_items([('a', 1), ('b', 2), ('c', 3)])

# Views เป็น dynamic — สะท้อนการเปลี่ยนแปลง
d["d"] = 4
print(list(keys))  # ['a', 'b', 'c', 'd']
```

### 4.4.4 ข้อดี

- **เร็วมาก:** O(1) สำหรับ lookup
- **ยืดหยุ่น:** keys และ values ชนิดใดก็ได้
- **Methods ครบ:** get, setdefault, pop, update
- **Comprehension:** สร้างได้กระชับ
- **รับประกันลำดับ:** Python 3.7+

### 4.4.5 ข้อเสีย

- **ใช้หน่วยความจำมาก:** เพราะ hash table + overhead
- **Keys ต้อง hashable:** ใช้ list เป็น key ไม่ได้
- **ไม่เหมาะกับข้อมูลเรียงลำดับ:** ใช้ List หรือ tuple

### 4.4.6 ข้อควรระวัง

```python
# ระวัง 1: อย่าแก้ dict ขณะ iterate
d = {"a": 1, "b": 2, "c": 3}
# for key in d:
#     if key == "b":
#         del d[key]  # ❌ RuntimeError

# ✅ ถูกต้อง: วนซ้ำบน list ของ keys
for key in list(d.keys()):
    if key == "b":
        del d[key]

# ระวัง 2: get vs []
d = {"a": 1}
print(d.get("b"))     # None
# print(d["b"])       # ❌ KeyError

# ระวัง 3: dict ไม่ใช่ hashable
# bad = {{"a": 1}: "value"}  # ❌ TypeError

# ระวัง 4: การ merge ที่ไม่ recursive
d1 = {"a": {"x": 1}}
d2 = {"a": {"y": 2}}
print(d1 | d2)  # {'a': {'y': 2}} — x หายไป!
```

### 4.4.7 สรุป

ใช้ Dictionary เมื่อ:
- ต้องการ lookup เร็ว ๆ ด้วย key
- ต้องการ map ระหว่างสองสิ่ง
- ต้องการจัดกลุ่มข้อมูล
- ต้องการ cache / memoization

> **อ้างอิงเพิ่มเติม:** [Python Dict Documentation](https://docs.python.org/3/tutorial/datastructures.html#dictionaries), [PEP 584 — Union Operators](https://peps.python.org/pep-0584/)

---

## 4.5 String ขั้นสูง

### บทนำ

String เป็น immutable sequence ของ Unicode characters ที่ใช้บ่อยมากในงานจริง การเข้าใจ methods ขั้นสูงและการจัดการ Unicode อย่างถูกต้องเป็นสิ่งจำเป็น

### นิยาม

String ใน Python 3 เป็น sequence ของ Unicode code points (ไม่ใช่ bytes) เขียนด้วย `'...'`, `"..."`, `'''...'''` หรือ `"""..."""`

### 4.5.1 คืออะไร

String เป็น immutable object รองรับ operations มากมาย เช่น concatenation, slicing, formatting, searching, replacing และ regular expressions

### 4.5.2 ทำงานอย่างไร

String ใน CPython จัดเก็บเป็น array ของ code points แต่ละ string มี metadata เช่น length, hash (คำนวณเมื่อต้องการ) และ hash cache

### 4.5.3 การใช้งาน

```python
# Methods สำคัญ
s = "  Hello, World!  "

# ทำความสะอาด
print(s.strip())             # "Hello, World!"
print(s.lstrip())            # "Hello, World!  "
print(s.rstrip())            # "  Hello, World!"

# Case
print("hello".upper())       # HELLO
print("HELLO".lower())       # hello
print("hello world".title()) # Hello World
print("hello world".capitalize())  # Hello world
print("hello".swapcase())    # HELLO

# ค้นหาและแทนที่
text = "the quick brown fox jumps over the lazy dog"
print(text.find("fox"))       # 16
print(text.find("cat"))       # -1
print(text.index("fox"))      # 16
# text.index("cat")           # ❌ ValueError
print(text.count("the"))      # 2
print(text.replace("fox", "cat"))
print(text.startswith("the")) # True
print(text.endswith("dog"))   # True

# แยกและรวม
csv = "apple,banana,cherry"
parts = csv.split(",")        # ['apple', 'banana', 'cherry']
print(" | ".join(parts))      # apple | banana | cherry

# Split ด้วย maxsplit
print("a-b-c-d".split("-", maxsplit=2))  # ['a', 'b', 'c-d']

# แบ่งบรรทัด
multiline = "line1\nline2\nline3"
print(multiline.splitlines())  # ['line1', 'line2', 'line3']

# จัดตำแหน่ง
print("hello".center(11, "*"))  # ***hello***
print("hello".ljust(10, "."))   # hello.....
print("hello".rjust(10, "."))   # .....hello
print("42".zfill(5))            # 00042

# ตรวจสอบ
print("abc123".isalnum())     # True
print("abc".isalpha())        # True
print("123".isdigit())        # True
print("   ".isspace())        # True
print("Hello World".istitle())  # True
```

**f-strings ขั้นสูง:**
```python
name = "สมชาย"
salary = 45000.5
ratio = 0.8567

# Format spec
print(f"{salary:,.2f}")        # 45,000.50
print(f"{ratio:.1%}")          # 85.7%
print(f"{name:>10}")           #      สมชาย
print(f"{name:^10}")           #   สมชาย   
print(f"{42:08b}")             # 00101010 (binary)
print(f"{255:x}")              # ff (hex)

# f-string กับ expression
items = [1, 2, 3, 4, 5]
print(f"Sum: {sum(items)}, Avg: {sum(items)/len(items):.2f}")

# Nested f-string
width = 10
print(f"{'hi':>{width}}")      #         hi

# Debug format (Python 3.8+)
x = 42
y = [1, 2, 3]
print(f"{x=}, {y=}")           # x=42, y=[1, 2, 3]
```

**Regular Expressions:**
```python
import re

# ค้นหา
text = "ติดต่อ: 081-234-5678 หรือ 089-876-5432"
pattern = r"\d{3}-\d{3}-\d{4}"
matches = re.findall(pattern, text)
print(matches)  # ['081-234-5678', '089-876-5432']

# แทนที่
masked = re.sub(pattern, "XXX-XXX-XXXX", text)
print(masked)

# Groups
email_pattern = r"(\w+)@(\w+)\.(\w+)"
match = re.search(email_pattern, "somchai@example.com")
if match:
    print(match.group(0))  # somchai@example.com
    print(match.group(1))  # somchai
    print(match.group(2))  # example
    print(match.group(3))  # com

# Named groups
pattern = r"(?P<user>\w+)@(?P<domain>\w+)\.(?P<tld>\w+)"
match = re.search(pattern, "somchai@example.com")
if match:
    print(match.groupdict())
    # {'user': 'somchai', 'domain': 'example', 'tld': 'com'}

# Compile สำหรับ reuse
phone_re = re.compile(r"\d{3}-\d{3}-\d{4}")
print(phone_re.findall(text))

# Verbose mode (อ่านง่าย)
email_re = re.compile(r"""
    (?P<user>[\w.+-]+)     # username
    @                       # @ symbol
    (?P<domain>[\w.-]+)    # domain
    \.                      # dot
    (?P<tld>[a-zA-Z]{2,})  # TLD
""", re.VERBOSE)

match = email_re.match("somchai.j@example.co.th")
if match:
    print(match.groupdict())
```

**การจัดการ Unicode:**
```python
# Unicode ใน Python 3
s = "สวัสดีครับ"
print(len(s))               # 11 (code points)
print(s.encode("utf-8"))    # bytes
print(len(s.encode("utf-8")))  # 33 (bytes)

# กลับเป็น string
b = b"\xe0\xb8\xaa\xe0\xb8\xa7"
print(b.decode("utf-8"))    # สวัสดี

# Unicode normalization
import unicodedata

# NFC (composed) vs NFD (decomposed)
s1 = "é"                     # single codepoint
s2 = "e\u0301"               # e + combining accent
print(s1 == s2)              # False
print(unicodedata.normalize("NFC", s1) == unicodedata.normalize("NFC", s2))  # True

# อ่านชื่อ Unicode
char = "ก"
print(unicodedata.name(char))  # THAI CHARACTER KO KAI
print(unicodedata.category(char))  # Lo (Letter, other)

# ตรวจสอบอักขระ
print(char.isalpha())  # True
```

**ตัวอย่างการใช้งานจริง — Log Parser:**
```python
import re
from datetime import datetime
from collections import Counter

LOG_PATTERN = re.compile(r"""
    (?P<ip>\d+\.\d+\.\d+\.\d+)\s+-\s+-\s+
    \[(?P<time>[^\]]+)\]\s+
    "(?P<method>\w+)\s+(?P<path>\S+)\s+\S+"\s+
    (?P<status>\d+)\s+
    (?P<size>\d+)
""", re.VERBOSE)

def parse_log_line(line: str) -> dict | None:
    match = LOG_PATTERN.match(line)
    if not match:
        return None
    data = match.groupdict()
    data["status"] = int(data["status"])
    data["size"] = int(data["size"])
    return data

def analyze_logs(log_file: str) -> dict:
    status_counts = Counter()
    path_counts = Counter()
    total_bytes = 0

    with open(log_file) as f:
        for line in f:
            entry = parse_log_line(line)
            if not entry:
                continue
            status_counts[entry["status"]] += 1
            path_counts[entry["path"]] += 1
            total_bytes += entry["size"]

    return {
        "status": dict(status_counts),
        "top_paths": path_counts.most_common(5),
        "total_mb": total_bytes / 1024 / 1024,
    }
```

### 4.5.4 ข้อดี

- **Immutable:** ปลอดภัยจาก unintended modification
- **Methods ครบ:** กว่า 40 methods
- **f-strings:** Formatting ที่ทรงพลัง
- **Unicode support:** รองรับทุกภาษา
- **Regular expressions:** ผ่าน `re` module

### 4.5.5 ข้อเสีย

- **Immutable:** การต่อ string ใน loop ช้า
- **ใช้หน่วยความจำ:** string ขนาดใหญ่กิน RAM
- **Regular expressions ซับซ้อน:** อาจอ่านยาก

### 4.5.6 ข้อควรระวัง

```python
# ระวัง 1: การต่อ string ใน loop
# ❌ ช้า — สร้าง string ใหม่ทุกครั้ง
result = ""
for i in range(10000):
    result += str(i)

# ✅ เร็ว — ใช้ list + join
parts = []
for i in range(10000):
    parts.append(str(i))
result = "".join(parts)

# ✅ หรือใช้ StringIO
from io import StringIO
buf = StringIO()
for i in range(10000):
    buf.write(str(i))
result = buf.getvalue()

# ระวัง 2: การเปรียบเทียบ string กับ None
s = ""
if s is None:  # ❌
    pass
if not s:      # ✅
    pass

# ระวัง 3: Unicode กับ bytes
# s = "สวัสดี"
# s + b"world"  # ❌ TypeError
# ต้อง encode/decode ก่อน

# ระวัง 4: regex กับ special characters
# ❌ ผิด — . คือ any char
# re.search("file.txt", text)
# ✅ ถูก — escape dot
re.search(r"file\.txt", text)
```

### 4.5.7 สรุป

String เป็นโครงสร้างข้อมูลพื้นฐานที่สุด ควรเข้าใจ:
- Methods ที่ใช้บ่อย (strip, split, join, replace)
- f-strings สำหรับ formatting
- Regular expressions สำหรับ pattern matching
- Unicode และ encoding

> **อ้างอิงเพิ่มเติม:** [Python String Methods](https://docs.python.org/3/library/stdtypes.html#string-methods), [re — Regular expression operations](https://docs.python.org/3/library/re.html), [Unicode HOWTO](https://docs.python.org/3/howto/unicode.html)

---

## 4.6 Bytes และ Bytearray

### บทนำ

เมื่อทำงานกับข้อมูล binary เช่น ไฟล์, network protocols, การเข้ารหัส จำเป็นต้องใช้ `bytes` และ `bytearray` ซึ่งจัดการข้อมูลเป็น sequence ของ integers 0-255

### นิยาม

- **bytes:** immutable sequence ของ integers 0-255
- **bytearray:** mutable version ของ bytes

### 4.6.1 คืออะไร

`bytes` และ `bytearray` ใช้เก็บข้อมูล binary ดิบ ไม่ผ่านการตีความเป็น Unicode ต่างจาก string ที่เก็บ Unicode code points

### 4.6.2 ทำงานอย่างไร

ทั้งสองเก็บข้อมูลเป็น array ของ bytes (0-255) `bytes` ไม่สามารถแก้ไขได้ ส่วน `bytearray` แก้ไขได้

### 4.6.3 การใช้งาน

```python
# การสร้าง bytes
b1 = b"hello"              # literal
b2 = bytes([72, 101, 108, 108, 111])  # from ints
b3 = bytes(5)              # b'\x00\x00\x00\x00\x00'
b4 = "สวัสดี".encode("utf-8")  # from string

# การสร้าง bytearray
ba = bytearray(b"hello")
ba[0] = 72  # ✅ แก้ไขได้
ba.append(33)  # เพิ่ม !

# การเข้าถึง
b = b"hello"
print(b[0])          # 104 (int, ไม่ใช่ char)
print(b[0:3])        # b'hel'
print(list(b))       # [104, 101, 108, 108, 111]

# แปลง bytes ↔ string
text = "สวัสดี"
encoded = text.encode("utf-8")
print(encoded)         # b'\xe0\xb8\xaa...'
decoded = encoded.decode("utf-8")
print(decoded)         # สวัสดี

# Hex
b = b"\x48\x65\x6c\x6c\x6f"
print(b.hex())         # 48656c6c6f
print(bytes.fromhex("48656c6c6f"))  # b'Hello'

# Base64
import base64
data = b"Hello, World!"
encoded = base64.b64encode(data)
print(encoded)          # b'SGVsbG8sIFdvcmxkIQ=='
print(base64.b64decode(encoded))  # b'Hello, World!'
```

**ตัวอย่างการใช้งานจริง — อ่านไฟล์ Binary:**
```python
def read_binary_header(file_path: str, num_bytes: int = 16) -> bytes:
    """อ่าน header ของไฟล์ binary"""
    with open(file_path, "rb") as f:
        return f.read(num_bytes)

# ตรวจสอบ magic number
def detect_file_type(file_path: str) -> str:
    signatures = {
        b"\x89PNG\r\n\x1a\n": "PNG",
        b"\xff\xd8\xff": "JPEG",
        b"GIF87a": "GIF",
        b"GIF89a": "GIF",
        b"PK\x03\x04": "ZIP",
        b"%PDF": "PDF",
    }
    header = read_binary_header(file_path, 8)
    for sig, file_type in signatures.items():
        if header.startswith(sig):
            return file_type
    return "Unknown"
```

**ตัวอย่าง — Protocol Buffer ขนาดเล็ก:**
```python
import struct

def pack_message(msg_type: int, payload: bytes) -> bytes:
    """Pack message ด้วย format: [type:1][length:4][payload]"""
    return struct.pack(">BI", msg_type, len(payload)) + payload

def unpack_message(data: bytes) -> tuple[int, bytes]:
    """Unpack message"""
    header_size = struct.calcsize(">BI")
    msg_type, length = struct.unpack(">BI", data[:header_size])
    payload = data[header_size:header_size + length]
    return msg_type, payload

# การใช้งาน
message = pack_message(1, b"Hello")
print(message)  # b'\x00\x00\x00\x00\x05Hello'
msg_type, payload = unpack_message(message)
print(msg_type, payload)  # 1 b'Hello'
```

### 4.6.4 ข้อดี

- **จัดการ binary:** ใช้กับไฟล์, network, crypto ได้
- **หน่วยความจำต่ำ:** เก็บ byte ดิบ
- **struct module:** pack/unpack binary ได้
- **bytearray แก้ไขได้:** เหมาะกับ buffer

### 4.6.5 ข้อเสีย

- **อ่านยาก:** ไม่เหมือน string
- **ต้อง encode/decode:** เมื่อสลับกับ string
- **ไม่มี methods ของ string:** ต้องใช้ bytes methods

### 4.6.6 ข้อควรระวัง

```python
# ระวัง: string กับ bytes ต่างกัน
# b"hello" + "world"  # ❌ TypeError
b"hello" + b"world"    # ✅

# ระวัง: encode/decode ต้องระบุ encoding
text.encode("utf-8")   # ✅
# text.encode()        # ใช้ default (utf-8) แต่ควรระบุ

# ระวัง: bytes เป็น sequence ของ int ไม่ใช่ char
b = b"ABC"
print(b[0])            # 65 ไม่ใช่ 'A'
print(chr(b[0]))       # 'A'
```

### 4.6.7 สรุป

ใช้ `bytes` และ `bytearray` เมื่อ:
- อ่าน/เขียนไฟล์ binary
- ทำงานกับ network protocols
- การเข้ารหัส/ถอดรหัส
- ทำงานกับ struct, pickle, marshal

> **อ้างอิงเพิ่มเติม:** [Bytes Objects](https://docs.python.org/3/library/stdtypes.html#bytes-objects), [struct — Interpret bytes as packed binary data](https://docs.python.org/3/library/struct.html)

---

## 4.7 Comprehension

### บทนำ

Comprehension เป็น syntax ที่กระชับและรวดเร็วในการสร้าง list, dict, set, และ generator จาก iterable อื่น เป็นเอกลักษณ์ของ Python ที่ทำให้โค้ดอ่านง่ายและมีประสิทธิภาพ

### นิยาม

Comprehension คือ expression ที่สร้าง collection ใหม่จาก iterable โดยมี optional condition

### 4.7.1 คืออะไร

Python รองรับ comprehension 4 ชนิด:
- **List comprehension:** `[expr for x in iterable if cond]`
- **Dict comprehension:** `{k_expr: v_expr for x in iterable}`
- **Set comprehension:** `{expr for x in iterable}`
- **Generator expression:** `(expr for x in iterable)`

### 4.7.2 ทำงานอย่างไร

Comprehension ถูก compile เป็น bytecode ที่เร็วกว่า for loop ปกติ เพราะ:
- ไม่ต้องเรียก `append` ในแต่ละรอบ (optimized เป็น `LIST_APPEND` opcode)
- Scope ของตัวแปรเป็น local
- ไม่มี function call overhead

### 4.7.3 การใช้งาน

**List Comprehension:**
```python
# พื้นฐาน
squares = [x ** 2 for x in range(10)]

# มี condition
evens = [x for x in range(20) if x % 2 == 0]

# Nested
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flattened = [n for row in matrix for n in row]
# [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Multiple conditions
result = [x for x in range(100) if x % 2 == 0 if x % 3 == 0]
# เท่ากับ if x % 2 == 0 and x % 3 == 0

# Conditional expression (ternary)
labels = ["even" if x % 2 == 0 else "odd" for x in range(10)]
```

**Dict Comprehension:**
```python
# key: value
squares = {x: x ** 2 for x in range(5)}

# สลับ key-value
original = {"a": 1, "b": 2}
swapped = {v: k for k, v in original.items()}

# กรอง
scores = {"สมชาย": 85, "สมหญิง": 92, "วิชัย": 78}
passed = {name: score for name, score in scores.items() if score >= 80}

# จัดกลุ่ม
from collections import defaultdict
words = ["apple", "banana", "avocado", "blueberry"]
by_letter = {
    letter: [w for w in words if w.startswith(letter)]
    for letter in set(w[0] for w in words)
}
```

**Set Comprehension:**
```python
# unique squares
unique_squares = {x ** 2 for x in range(-5, 6)}
# {0, 1, 4, 9, 16, 25}

# หาคำ unique
words = ["apple", "banana", "APPLE", "Banana"]
unique_lower = {w.lower() for w in words}
# {'apple', 'banana'}
```

**Generator Expression:**
```python
# ใช้ memory น้อยกว่า list comprehension
total = sum(x ** 2 for x in range(1_000_000))

# ไม่สร้าง list ทั้งหมดในหน่วยความจำ
squares_gen = (x ** 2 for x in range(10))
print(next(squares_gen))  # 0
print(next(squares_gen))  # 1

# ใช้กับ any/all
has_negative = any(x < 0 for x in [1, 2, -3, 4])
all_positive = all(x > 0 for x in [1, 2, 3, 4])
```

**ตัวอย่างการใช้งานจริง — Data Transformation:**
```python
from dataclasses import dataclass

@dataclass
class RawUser:
    first_name: str
    last_name: str
    age_str: str
    email: str

@dataclass
class User:
    full_name: str
    age: int
    email: str
    is_adult: bool

raw_users = [
    RawUser("สมชาย", "ใจดี", "30", "somchai@email.com"),
    RawUser("สมหญิง", "รักเรียน", "17", "somying@email.com"),
    RawUser("วิชัย", "ขยัน", "25", "wichai@email.com"),
]

users = [
    User(
        full_name=f"{r.first_name} {r.last_name}",
        age=int(r.age_str),
        email=r.email.lower(),
        is_adult=int(r.age_str) >= 18,
    )
    for r in raw_users
]

for u in users:
    print(f"{u.full_name} (อายุ {u.age}) - ผู้ใหญ่: {u.is_adult}")
```

**ตัวอย่าง — จัดกลุ่มด้วย Dict Comprehension:**
```python
transactions = [
    {"id": 1, "type": "income", "amount": 5000},
    {"id": 2, "type": "expense", "amount": 1200},
    {"id": 3, "type": "income", "amount": 8000},
    {"id": 4, "type": "expense", "amount": 500},
]

# จัดกลุ่มตาม type
grouped = {}
for t in transactions:
    grouped.setdefault(t["type"], []).append(t)

# หรือใช้ comprehension (แต่ต้อง initialize ก่อน)
grouped2 = {
    t_type: [t for t in transactions if t["type"] == t_type]
    for t_type in {t["type"] for t in transactions}
}

# หาผลรวมตาม type
totals = {
    t_type: sum(t["amount"] for t in transactions if t["type"] == t_type)
    for t_type in {t["type"] for t in transactions}
}
print(totals)  # {'income': 13000, 'expense': 1700}
```

### 4.7.4 ข้อดี

- **กระชับ:** เขียนสั้นกว่า for loop
- **เร็ว:** เร็วกว่า for loop + append
- **อ่านง่าย:** ถ้าไม่ซับซ้อนเกินไป
- **ไม่ต้อง initialize:** สร้าง collection ในที่เดียว

### 4.7.5 ข้อเสีย

- **อ่านยากถ้าซับซ้อน:** nested comprehension หลายชั้น
- **Debug ยาก:** ไม่สามารถใส่ print ใน comprehension ได้ง่าย
- **ไม่เหมาะกับ logic ซับซ้อน:** ควรใช้ for loop
- **Side effects:** ไม่ควรมี side effect ใน comprehension

### 4.7.6 ข้อควรระวัง

```python
# ระวัง 1: Nested comprehension ที่อ่านยาก
# ❌ ยาก
result = [[y for y in range(x)] for x in range(5)]

# ✅ ถ้าซับซ้อน ใช้ for loop
result = []
for x in range(5):
    row = []
    for y in range(x):
        row.append(y)
    result.append(row)

# ระวัง 2: Comprehension มี scope ของตัวเอง
x = 10
squares = [x ** 2 for x in range(5)]
print(x)  # 10 (ไม่เปลี่ยน)

# แต่ใน Python 2 เคย leak — ระวังถ้าดูโค้ดเก่า

# ระวัง 3: อย่าใช้ side effects
# ❌ ไม่ควร
results = [print(x) for x in range(5)]

# ✅ ใช้ for loop
for x in range(5):
    print(x)

# ระวัง 4: Generator expression ใช้ได้ครั้งเดียว
gen = (x ** 2 for x in range(5))
print(sum(gen))  # 30
print(sum(gen))  # 0 (ใช้หมดแล้ว!)
```

### 4.7.7 สรุป

ใช้ Comprehension เมื่อ:
- สร้าง collection ใหม่จาก iterable
- Logic ไม่ซับซ้อน (1-2 บรรทัด)
- ไม่มี side effects
- ต้องการประสิทธิภาพ

ใช้ for loop เมื่อ:
- Logic ซับซ้อน
- ต้องมี side effects
- ต้องการ debug ง่าย ๆ

> **อ้างอิงเพิ่มเติม:** [List Comprehensions](https://docs.python.org/3/tutorial/datastructures.html#list-comprehensions), [PEP 202 — List Comprehensions](https://peps.python.org/pep-0202/)

---

## 4.8 Iterator

### บทนำ

Iterator เป็นแนวคิดพื้นฐานที่ทำให้ Python สามารถวนซ้ำข้อมูลได้อย่างมีประสิทธิภาพ เข้าใจ iterator จะช่วยให้เข้าใจ generator, for loop, และ comprehension ลึกซึ้งขึ้น

### นิยาม

Iterator คือ object ที่ implement `__iter__()` และ `__next__()` methods ใช้สำหรับวนซ้ำข้อมูลทีละ element

### 4.8.1 คืออะไร

Iterator protocol ใน Python ประกอบด้วย:
- `__iter__()` — คืน iterator object (มักคืน self)
- `__next__()` — คืน element ถัดไป หรือ raise `StopIteration` เมื่อหมด

### 4.8.2 ทำงานอย่างไร

For loop ทำงานกับ iterator ดังนี้:
```python
for x in [1, 2, 3]:
    print(x)

# เทียบเท่ากับ
iterator = iter([1, 2, 3])
while True:
    try:
        x = next(iterator)
        print(x)
    except StopIteration:
        break
```

### 4.8.3 การใช้งาน

**สร้าง Iterator เอง:**
```python
class CountDown:
    """นับถอยหลังจาก n ถึง 1"""
    def __init__(self, start: int):
        self.current = start

    def __iter__(self):
        return self

    def __next__(self) -> int:
        if self.current <= 0:
            raise StopIteration
        value = self.current
        self.current -= 1
        return value

for n in CountDown(5):
    print(n)  # 5, 4, 3, 2, 1
```

**ตัวอย่างการใช้งานจริง — อ่านไฟล์ขนาดใหญ่ทีละบรรทัด:**
```python
def read_in_chunks(file_path: str, chunk_size: int = 8192):
    """Iterator ที่อ่านไฟล์ทีละ chunk"""
    with open(file_path, "rb") as f:
        while True:
            chunk = f.read(chunk_size)
            if not chunk:
                break
            yield chunk

# ประมวลผลไฟล์ขนาดหลาย GB โดยไม่กิน RAM
total_size = sum(len(chunk) for chunk in read_in_chunks("large_file.bin"))
print(f"ขนาดไฟล์: {total_size:,} bytes")
```

**Iterator สำหรับ Pagination:**
```python
import httpx

class PaginatedAPI:
    """Iterator ที่ดึงข้อมูลจาก API ทีละหน้า"""
    def __init__(self, base_url: str, per_page: int = 100):
        self.base_url = base_url
        self.per_page = per_page
        self.page = 1
        self.has_more = True

    def __iter__(self):
        return self

    def __next__(self) -> dict:
        if not self.has_more:
            raise StopIteration

        response = httpx.get(
            self.base_url,
            params={"page": self.page, "per_page": self.per_page},
        )
        response.raise_for_status()
        data = response.json()

        items = data.get("items", [])
        if not items or self.page >= data.get("total_pages", 1):
            self.has_more = False

        self.page += 1
        return data

# การใช้งาน
# api = PaginatedAPI("https://api.example.com/users")
# for page in api:
#     for user in page["items"]:
#         process_user(user)
```

**itertools — Iterator Tools:**
```python
import itertools

# chain — ต่อ iterators
combined = itertools.chain([1, 2], [3, 4], [5, 6])
print(list(combined))  # [1, 2, 3, 4, 5, 6]

# cycle — วนซ้ำไม่รู้จบ
colors = itertools.cycle(["red", "green", "blue"])
# next(colors) → 'red', 'green', 'blue', 'red', ...

# repeat — ทำซ้ำ
print(list(itertools.repeat("x", 5)))  # ['x', 'x', 'x', 'x', 'x']

# islice — slice iterator
nums = itertools.count(10)  # 10, 11, 12, ...
print(list(itertools.islice(nums, 5)))  # [10, 11, 12, 13, 14]

# takewhile / dropwhile
data = [1, 2, 3, 4, 1, 2]
print(list(itertools.takewhile(lambda x: x < 3, data)))  # [1, 2]
print(list(itertools.dropwhile(lambda x: x < 3, data)))  # [3, 4, 1, 2]

# groupby
data = [("a", 1), ("a", 2), ("b", 3), ("b", 4)]
for key, group in itertools.groupby(data, key=lambda x: x[0]):
    print(key, list(group))

# combinations / permutations
print(list(itertools.combinations([1, 2, 3, 4], 2)))
# [(1, 2), (1, 3), (1, 4), (2, 3), (2, 4), (3, 4)]

print(list(itertools.permutations([1, 2, 3], 2)))
# [(1, 2), (1, 3), (2, 1), (2, 3), (3, 1), (3, 2)]

# product — Cartesian product
print(list(itertools.product([1, 2], ["a", "b"])))
# [(1, 'a'), (1, 'b'), (2, 'a'), (2, 'b')]
```

**ตัวอย่างการใช้งานจริง — Batch Processing:**
```python
import itertools

def batch_iterator(iterable, batch_size: int):
    """แบ่ง iterable เป็น batch"""
    iterator = iter(iterable)
    while True:
        batch = list(itertools.islice(iterator, batch_size))
        if not batch:
            break
        yield batch

# การใช้งาน — ส่งข้อมูลเป็น batch
user_ids = range(1, 1_000_001)
for batch in batch_iterator(user_ids, 100):
    # ส่ง batch ละ 100 รายการ
    print(f"Processing {len(batch)} items: {batch[0]}..{batch[-1]}")
```

### 4.8.4 ข้อดี

- **ประหยัดหน่วยความจำ:** ไม่ต้องโหลดข้อมูลทั้งหมด
- **Lazy evaluation:** คำนวณเมื่อต้องการ
- **Composable:** ต่อ iterator หลายตัวได้
- **Unified interface:** ใช้กับ for loop, comprehension

### 4.8.5 ข้อเสีย

- **ใช้ได้ครั้งเดียว:** ไม่สามารถ rewind
- **ไม่รู้ขนาดล่วงหน้า:** ไม่มี len()
- **Debug ยาก:** เพราะ lazy
- **ต้องระวัง state:** iterator มี state

### 4.8.6 ข้อควรระวัง

```python
# ระวัง 1: iterator ใช้ได้ครั้งเดียว
nums = iter([1, 2, 3])
print(list(nums))  # [1, 2, 3]
print(list(nums))  # [] — ใช้หมดแล้ว!

# ระวัง 2: การ iter หลายรอบต้องสร้างใหม่
# ❌ ผิด
def process_twice(data):
    total = sum(data)      # iter ครั้งแรก
    count = sum(1 for _ in data)  # iter ครั้งที่สอง — ได้ 0!
    return total / count

# ✅ ถูก
def process_twice(data):
    data = list(data)  # materialize ก่อน
    total = sum(data)
    count = len(data)
    return total / count

# ระวัง 3: zip หยุดที่ iterator สั้นที่สุด
a = iter([1, 2, 3])
b = iter([10, 20])
print(list(zip(a, b)))  # [(1, 10), (2, 20)] — 3 หาย

# ระวัง 4: อย่าใช้ iter กับ object เดียวกันหลายที่
```

### 4.8.7 สรุป

ใช้ Iterator เมื่อ:
- ทำงานกับข้อมูลขนาดใหญ่
- ต้องการ lazy evaluation
- ต้องการประมวลผลแบบ streaming
- ต้องการ pipeline ของ operations

> **อ้างอิงเพิ่มเติม:** [Iterator Protocol](https://docs.python.org/3/library/stdtypes.html#iterator-types), [itertools — Functions creating iterators](https://docs.python.org/3/library/itertools.html)

---

## 4.9 Generator

### บทนำ

Generator เป็นวิธีที่ง่ายและทรงพลังที่สุดในการสร้าง iterator ใน Python ใช้ `yield` keyword ทำให้เขียน iterator ได้เหมือนฟังก์ชันปกติ

### นิยาม

Generator คือฟังก์ชันที่มี `yield` keyword เมื่อเรียกจะคืน generator object โดยไม่ execute โค้ดทันที

### 4.9.1 คืออะไร

Generator function เมื่อถูกเรียกจะคืน generator object ที่ implement iterator protocol โดยอัตโนมัติ ทุกครั้งที่เรียก `next()` โค้ดจะรันจนถึง `yield` แล้วหยุด รอการเรียกครั้งถัดไป

### 4.9.2 ทำงานอย่างไร

```python
def simple_generator():
    print("Start")
    yield 1
    print("Middle")
    yield 2
    print("End")
    yield 3

gen = simple_generator()  # ยังไม่พิมพ์อะไร
print(next(gen))  # "Start", 1
print(next(gen))  # "Middle", 2
print(next(gen))  # "End", 3
# next(gen)  # ❌ StopIteration
```

Generator ใช้ stack frame ที่ถูก suspend ไว้ ทำให้ประหยัดหน่วยความจำกว่า iterator ที่ implement เอง

### 4.9.3 การใช้งาน

**Generator พื้นฐาน:**
```python
def fibonacci(limit: int):
    """Generate Fibonacci numbers"""
    a, b = 0, 1
    count = 0
    while count < limit:
        yield a
        a, b = b, a + b
        count += 1

for n in fibonacci(10):
    print(n, end=" ")  # 0 1 1 2 3 5 8 13 21 34
```

**Generator Expression:**
```python
# Generator expression — เขียนสั้น
squares = (x ** 2 for x in range(10))
print(sum(squares))  # 285

# ประหยัดหน่วยความจำกว่า list comprehension
import sys
list_comp = [x ** 2 for x in range(10000)]
gen_expr = (x ** 2 for x in range(10000))
print(sys.getsizeof(list_comp))  # ~87,624 bytes
print(sys.getsizeof(gen_expr))   # ~104 bytes
```

**send() และ yield from:**
```python
def echo():
    """Generator ที่รับค่าผ่าน send()"""
    while True:
        received = yield
        if received is None:
            break
        print(f"Received: {received}")

gen = echo()
next(gen)  # เริ่ม generator
gen.send("hello")
gen.send("world")
gen.send(None)  # หยุด

# yield from — delegate ให้ generator อื่น
def chain_generators(*iterables):
    for it in iterables:
        yield from it

result = list(chain_generators([1, 2], [3, 4], [5]))
print(result)  # [1, 2, 3, 4, 5]
```

**ตัวอย่างการใช้งานจริง — อ่านไฟล์ CSV ขนาดใหญ่:**
```python
import csv
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Iterator

@dataclass
class Transaction:
    id: str
    date: datetime
    amount: float
    category: str

def read_transactions(file_path: str) -> Iterator[Transaction]:
    """อ่าน transactions จาก CSV แบบ streaming"""
    with open(file_path, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            yield Transaction(
                id=row["id"],
                date=datetime.fromisoformat(row["date"]),
                amount=float(row["amount"]),
                category=row["category"],
            )

def filter_by_category(
    transactions: Iterator[Transaction],
    category: str,
) -> Iterator[Transaction]:
    """กรองตาม category"""
    for t in transactions:
        if t.category == category:
            yield t

def total_amount(transactions: Iterator[Transaction]) -> float:
    """คำนวณยอดรวม"""
    return sum(t.amount for t in transactions)

# Chain generators — ไม่โหลดข้อมูลทั้งหมดในหน่วยความจำ
transactions = read_transactions("transactions.csv")
food_transactions = filter_by_category(transactions, "food")
total = total_amount(food_transactions)
print(f"ยอดรวมอาหาร: {total:,.2f} บาท")
```

**ตัวอย่าง — Infinite Generator:**
```python
def id_generator(prefix: str = "ID"):
    """Generate unique IDs ไม่รู้จบ"""
    counter = 1
    while True:
        yield f"{prefix}-{counter:06d}"
        counter += 1

# ใช้เท่าที่ต้องการ
gen = id_generator("USER")
for _ in range(5):
    print(next(gen))
# USER-000001, USER-000002, ...
```

**ตัวอย่าง — Pipeline ประมวลผลข้อมูล:**
```python
def read_lines(file_path: str):
    with open(file_path, encoding="utf-8") as f:
        yield from f

def strip_lines(lines):
    for line in lines:
        yield line.strip()

def skip_empty(lines):
    for line in lines:
        if line:
            yield line

def parse_numbers(lines):
    for line in lines:
        try:
            yield float(line)
        except ValueError:
            continue

def moving_average(numbers, window: int = 3):
    buffer: list[float] = []
    for n in numbers:
        buffer.append(n)
        if len(buffer) > window:
            buffer.pop(0)
        if len(buffer) == window:
            yield sum(buffer) / window

# Pipeline — แต่ละขั้นเป็น generator
lines = read_lines("data.txt")
stripped = strip_lines(lines)
non_empty = skip_empty(stripped)
numbers = parse_numbers(non_empty)
averages = moving_average(numbers, window=5)

for avg in averages:
    print(f"MA(5) = {avg:.4f}")
```

### 4.9.4 ข้อดี

- **ประหยัดหน่วยความจำ:** ไม่โหลดข้อมูลทั้งหมด
- **เขียนง่าย:** เหมือนฟังก์ชันปกติ
- **Lazy:** คำนวณเมื่อต้องการ
- **Pipeline:** ต่อกันเป็น chain ได้
- **Infinite:** สร้างลำดับไม่รู้จบได้

### 4.9.5 ข้อเสีย

- **ใช้ได้ครั้งเดียว:** ต้องสร้างใหม่ถ้าต้องการวนซ้ำ
- **Debug ยาก:** เพราะ lazy evaluation
- **ไม่มี len():** ไม่รู้ขนาดล่วงหน้า
- **ไม่ picklable:** ส่งข้าม process ได้ยาก

### 4.9.6 ข้อควรระวัง

```python
# ระวัง 1: generator ใช้ได้ครั้งเดียว
def numbers():
    yield from range(5)

gen = numbers()
print(sum(gen))  # 10
print(sum(gen))  # 0 (ใช้หมดแล้ว!)

# ระวัง 2: อย่าใช้ return ใน generator (ยกเว้น Python 3.3+)
def bad_gen():
    yield 1
    return "done"  # ค่า return เก็บใน StopIteration.value

# ระวัง 3: ต้องปิด generator ถ้าไม่ใช้
gen = (x for x in range(1000000))
# ถ้าไม่ใช้ต่อ ควรปิดเพื่อคืนทรัพยากร
gen.close()

# ระวัง 4: generator ที่เปิดไฟล์ต้องปิดไฟล์
def read_file_bad(path):
    f = open(path)
    yield f.read()
    # ถ้าไม่ปิด → resource leak

def read_file_good(path):
    with open(path) as f:
        yield f.read()
    # with จะปิดอัตโนมัติ
```

### 4.9.7 สรุป

ใช้ Generator เมื่อ:
- ประมวลผลข้อมูลขนาดใหญ่
- ต้องการ lazy evaluation
- สร้าง pipeline ของ operations
- ทำงานกับ infinite sequences
- ประหยัดหน่วยความจำ

> **อ้างอิงเพิ่มเติม:** [Generator Documentation](https://docs.python.org/3/tutorial/classes.html#generators), [PEP 255 — Simple Generators](https://peps.python.org/pep-0255/), [PEP 342 — Coroutines via Enhanced Generators](https://peps.python.org/pep-0342/)

---

## 4.10 Iterable

### บทนำ

Iterable เป็นแนวคิดกว้าง ๆ ที่ครอบคลุมทุก object ที่สามารถวนซ้ำได้ ตั้งแต่ list, tuple, dict, set ไปจนถึง generator และ custom objects การเข้าใจความแตกต่างระหว่าง iterable และ iterator เป็นสิ่งสำคัญ

### นิยาม

- **Iterable:** object ที่ implement `__iter__()` (คืน iterator) หรือ `__getitem__()` (sequence protocol)
- **Iterator:** object ที่ implement `__next__()` (และมัก `__iter__()` คืน self)

**ทุก iterator เป็น iterable แต่ iterable ไม่จำเป็นต้องเป็น iterator**

### 4.10.1 คืออะไร

Iterable คือ object ที่สามารถ iter ได้ เช่น:
- Sequences: list, tuple, str, bytes
- Collections: dict, set, frozenset
- Generators: generator functions, generator expressions
- Files: file objects
- Custom objects ที่มี `__iter__`

### 4.10.2 ทำงานอย่างไร

```python
# ตรวจสอบ iterable
from collections.abc import Iterable, Iterator

print(isinstance([1, 2, 3], Iterable))    # True
print(isinstance([1, 2, 3], Iterator))    # False
print(isinstance(iter([1, 2, 3]), Iterator))  # True

# ลำดับการทำงาน
data = [1, 2, 3]

# 1. iter() เรียก __iter__() คืน iterator
it = iter(data)

# 2. next() เรียก __next__() คืนค่า
print(next(it))  # 1
print(next(it))  # 2
print(next(it))  # 3

# 3. StopIteration เมื่อหมด
try:
    next(it)
except StopIteration:
    print("จบ")
```

### 4.10.3 การใช้งาน

**Custom Iterable:**
```python
from collections.abc import Iterator

class Playlist:
    """Playlist ที่ iterable ได้"""
    def __init__(self, songs: list[str]):
        self.songs = songs

    def __iter__(self) -> Iterator[str]:
        return iter(self.songs)

    def __len__(self) -> int:
        return len(self.songs)

    def __getitem__(self, index: int) -> str:
        return self.songs[index]

playlist = Playlist(["Song A", "Song B", "Song C"])

for song in playlist:
    print(song)

# ใช้ len() ได้
print(len(playlist))

# ใช้ index ได้
print(playlist[0])  # Song A
```

**Object ที่เป็นทั้ง Iterable และ Container:**
```python
class TemperatureLog:
    """บันทึกอุณหภูมิ พร้อม iterate ตามวัน"""
    def __init__(self):
        self._data: dict[str, list[float]] = {}

    def add(self, date: str, temp: float) -> None:
        self._data.setdefault(date, []).append(temp)

    def __iter__(self):
        """Iterate over dates"""
        return iter(self._data)

    def __getitem__(self, date: str) -> list[float]:
        return self._data[date]

    def __contains__(self, date: str) -> bool:
        return date in self._data

    def __len__(self) -> int:
        return len(self._data)

log = TemperatureLog()
log.add("2024-01-01", 25.5)
log.add("2024-01-01", 28.0)
log.add("2024-01-02", 23.5)

for date in log:
    print(f"{date}: {log[date]}")

print("2024-01-01" in log)  # True
print(len(log))              # 2
```

**การตรวจสอบ Iterable:**
```python
from collections.abc import Iterable

def is_iterable(obj) -> bool:
    """ตรวจสอบว่า obj เป็น iterable"""
    try:
        iter(obj)
        return True
    except TypeError:
        return False

print(is_iterable([1, 2, 3]))     # True
print(is_iterable("hello"))        # True
print(is_iterable(42))             # False
print(is_iterable({"a": 1}))       # True
print(is_iterable(range(5)))       # True
```

**ตัวอย่างการใช้งานจริง — Data Source Abstraction:**
```python
from typing import Iterator, Protocol
from pathlib import Path
import csv

class DataSource(Protocol):
    """Protocol สำหรับ data source"""
    def __iter__(self) -> Iterator[dict]:
        ...

class CSVSource:
    def __init__(self, path: str):
        self.path = path

    def __iter__(self) -> Iterator[dict]:
        with open(self.path, encoding="utf-8") as f:
            yield from csv.DictReader(f)

class ListSource:
    def __init__(self, data: list[dict]):
        self.data = data

    def __iter__(self) -> Iterator[dict]:
        yield from self.data

class APISource:
    def __init__(self, url: str):
        self.url = url

    def __iter__(self) -> Iterator[dict]:
        # สมมติว่าดึงจาก API
        yield {"id": 1, "name": "from API"}

def process_data(source: DataSource) -> None:
    """ทำงานกับ data source ใดก็ได้"""
    for row in source:
        print(row)

# ใช้ได้กับทุก source
process_data(CSVSource("data.csv"))
process_data(ListSource([{"id": 1}]))
process_data(APISource("https://api.example.com"))
```

**การทำงานกับ Iterable ใน Functional Style:**
```python
from itertools import chain, islice

def take(n: int, iterable):
    """เอา n elements แรก"""
    return islice(iterable, n)

def flatten(iterables):
    """Flatten iterable of iterables"""
    return chain.from_iterable(iterables)

def unique(iterable):
    """คืน unique elements ตามลำดับ"""
    seen = set()
    for item in iterable:
        if item not in seen:
            seen.add(item)
            yield item

# ใช้กับ iterable ใดก็ได้
data = [[1, 2], [2, 3], [3, 4]]
flat = flatten(data)              # 1, 2, 2, 3, 3, 4
uniq = unique(flat)                # 1, 2, 3, 4
first_3 = take(3, uniq)            # 1, 2, 3
print(list(first_3))
```

### 4.10.4 ข้อดี

- **Abstraction:** ทำงานกับ data source ใดก็ได้
- **Polymorphism:** ใช้ for loop กับทุก iterable
- **Composable:** ต่อ iterables เข้าด้วยกัน
- **Memory efficient:** ด้วย generator

### 4.10.5 ข้อเสีย

- **สับสนกับ Iterator:** ต้องเข้าใจความแตกต่าง
- **ตรวจสอบได้ยาก:** ต้องใช้ try/except หรือ isinstance
- **Consumption:** บาง iterable ใช้ได้ครั้งเดียว

### 4.10.6 ข้อควรระวัง

```python
# ระวัง 1: แยกแยะ Iterable กับ Iterator
from collections.abc import Iterable, Iterator

data = [1, 2, 3]
print(isinstance(data, Iterable))   # True
print(isinstance(data, Iterator))   # False

# List เป็น iterable แต่ไม่ใช่ iterator
# ต้องเรียก iter() ก่อน

# ระวัง 2: อย่าสมมติว่า iterable มี __len__
def process(data):
    # ❌ อาจ error ถ้า data เป็น generator
    # total = len(data)
    # ✅ ใช้ sum กับ generator
    total = sum(1 for _ in data)
    return total

# ระวัง 3: ตรวจสอบ __iter__ vs __getitem__
class WeirdClass:
    def __getitem__(self, index):
        if index >= 3:
            raise IndexError
        return index * 2

# ทำงานได้เพราะ __getitem__ (แต่ไม่ recommended)
for x in WeirdClass():
    print(x)  # 0, 2, 4
```

### 4.10.7 สรุป

**Iterable** = object ที่ iter ได้ (มี `__iter__`)
**Iterator** = object ที่ iter ได้ + คืนค่าถัดไปได้ (มี `__next__`)

ใช้ Iterable เมื่อ:
- ต้องการ abstraction ของ data source
- ทำงานกับ data หลายรูปแบบ
- สร้าง custom collection

> **อ้างอิงเพิ่มเติม:** [Iterables vs Iterators](https://docs.python.org/3/glossary.html#term-iterable), [collections.abc](https://docs.python.org/3/library/collections.abc.html)

---

## 4.11 Stack

### บทนำ

Stack เป็นโครงสร้างข้อมูลแบบ LIFO (Last In, First Out) ใช้ในอัลกอริทึมมากมาย เช่น การประเมิน expression, DFS, undo/redo

### นิยาม

Stack คือ collection ที่เพิ่มและลบข้อมูลได้เฉพาะด้านบนสุด (top) เท่านั้น operations หลักคือ push (เพิ่ม) และ pop (ลบ)

### 4.11.1 คืออะไร

Stack เป็น abstract data type ที่มี operations:
- `push(item)` — เพิ่มด้านบน
- `pop()` — ลบด้านบน
- `peek()` / `top()` — ดูด้านบน
- `is_empty()` — ตรวจสอบว่าง
- `size()` — ขนาด

### 4.11.2 ทำงานอย่างไร

ใน Python สามารถ implement Stack ด้วย:
- **List:** ใช้ `append()` และ `pop()` — เร็ว O(1)
- **deque:** ใช้ `append()` และ `pop()`
- **Custom class:** ห่อ list เพื่อความชัดเจน

### 4.11.3 การใช้งาน

**List-based Stack:**
```python
# ง่ายที่สุด — ใช้ list เป็น stack
stack = []
stack.append(1)  # push
stack.append(2)
stack.append(3)
print(stack.pop())  # 3
print(stack.pop())  # 2
print(stack[-1])    # 1 (peek)
```

**Custom Stack Class:**
```python
from typing import Generic, TypeVar, Optional

T = TypeVar("T")

class Stack(Generic[T]):
    """Stack implementation using list"""

    def __init__(self):
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        if self.is_empty():
            raise IndexError("pop from empty stack")
        return self._items.pop()

    def peek(self) -> T:
        if self.is_empty():
            raise IndexError("peek from empty stack")
        return self._items[-1]

    def is_empty(self) -> bool:
        return len(self._items) == 0

    def size(self) -> int:
        return len(self._items)

    def __len__(self) -> int:
        return len(self._items)

    def __bool__(self) -> bool:
        return bool(self._items)

    def __repr__(self) -> str:
        return f"Stack({self._items})"

# การใช้งาน
s = Stack[int]()
s.push(1)
s.push(2)
s.push(3)
print(s)           # Stack([1, 2, 3])
print(s.pop())     # 3
print(s.peek())    # 2
print(len(s))      # 2
```

**ตัวอย่างการใช้งานจริง 1 — ตรวจสอบวงเล็บ:**
```python
def is_balanced(expression: str) -> bool:
    """ตรวจสอบว่าวงเล็บสมดุลหรือไม่"""
    pairs = {")": "(", "]": "[", "}": "{"}
    stack: list[str] = []

    for char in expression:
        if char in "([{":
            stack.append(char)
        elif char in ")]}":
            if not stack or stack[-1] != pairs[char]:
                return False
            stack.pop()

    return len(stack) == 0

# ทดสอบ
print(is_balanced("({[]})"))     # True
print(is_balanced("({[}])"))     # False
print(is_balanced("((()))"))     # True
print(is_balanced("(()"))        # False
```

**ตัวอย่าง 2 — Undo/Redo System:**
```python
from dataclasses import dataclass
from typing import Callable

@dataclass
class Command:
    execute: Callable[[], None]
    undo: Callable[[], None]
    description: str

class CommandManager:
    def __init__(self):
        self._undo_stack: list[Command] = []
        self._redo_stack: list[Command] = []

    def execute(self, command: Command) -> None:
        command.execute()
        self._undo_stack.append(command)
        self._redo_stack.clear()

    def undo(self) -> bool:
        if not self._undo_stack:
            return False
        command = self._undo_stack.pop()
        command.undo()
        self._redo_stack.append(command)
        return True

    def redo(self) -> bool:
        if not self._redo_stack:
            return False
        command = self._redo_stack.pop()
        command.execute()
        self._undo_stack.append(command)
        return True

# การใช้งาน
class TextEditor:
    def __init__(self):
        self.text = ""
        self.manager = CommandManager()

    def insert(self, text: str, position: int) -> None:
        original = self.text
        self.text = self.text[:position] + text + self.text[position:]

        def undo():
            self.text = original

        def execute():
            self.text = self.text[:position] + text + self.text[position:]

        self.manager.execute(Command(execute, undo, f"Insert '{text}'"))

editor = TextEditor()
editor.insert("Hello", 0)
editor.insert(" World", 5)
print(editor.text)  # Hello World

editor.manager.undo()
print(editor.text)  # Hello

editor.manager.redo()
print(editor.text)  # Hello World
```

**ตัวอย่าง 3 — DFS ด้วย Stack:**
```python
def dfs_iterative(graph: dict[str, list[str]], start: str) -> list[str]:
    """Depth-First Search แบบ iterative"""
    visited = set()
    stack = [start]
    result = []

    while stack:
        node = stack.pop()
        if node in visited:
            continue
        visited.add(node)
        result.append(node)

        # เพิ่ม neighbors (กลับลำดับเพื่อให้ visit ตามลำดับ)
        for neighbor in reversed(graph.get(node, [])):
            if neighbor not in visited:
                stack.append(neighbor)

    return result

graph = {
    "A": ["B", "C"],
    "B": ["D", "E"],
    "C": ["F"],
    "D": [],
    "E": ["F"],
    "F": [],
}

print(dfs_iterative(graph, "A"))  # ['A', 'B', 'D', 'E', 'F', 'C']
```

### 4.11.4 ข้อดี

- **ง่าย:** ใช้ list ก็ได้
- **เร็ว:** O(1) สำหรับ push/pop
- **เหมาะกับ recursive problems:** แปลง recursion เป็น iteration
- **LIFO:** เหมาะกับ undo, parsing, DFS

### 4.11.5 ข้อเสีย

- **เข้าถึงกลางไม่ได้:** ต้อง pop ก่อน
- **ค้นหาช้า:** O(n) ถ้าต้องหาค่า
- **ไม่มี built-in:** ต้อง implement เองหรือใช้ list

### 4.11.6 ข้อควรระวัง

```python
# ระวัง 1: pop จาก stack ว่าง
stack = []
# stack.pop()  # ❌ IndexError

# ✅ ตรวจสอบก่อน
if stack:
    stack.pop()

# ระวัง 2: อย่าใช้ list เป็น queue
# ❌ ช้า — pop(0) เป็น O(n)
queue = [1, 2, 3]
queue.pop(0)

# ✅ ใช้ deque สำหรับ queue
from collections import deque
queue = deque([1, 2, 3])
queue.popleft()

# ระวัง 3: การเก็บ reference ใน stack
class Item:
    def __init__(self):
        self.data = [0] * 1000000

stack = []
for _ in range(1000):
    stack.append(Item())  # กิน RAM มาก

# ควร clear เมื่อไม่ใช้
stack.clear()
```

### 4.11.7 สรุป

ใช้ Stack เมื่อ:
- ต้องการ LIFO
- แปลง recursion เป็น iteration
- Undo/Redo
- Expression parsing
- DFS graph traversal

> **อ้างอิงเพิ่มเติม:** [Stack Data Structure](https://en.wikipedia.org/wiki/Stack_(abstract_data_type))

---

## 4.12 Queue

### บทนำ

Queue เป็นโครงสร้างข้อมูลแบบ FIFO (First In, First Out) ใช้ในงาน scheduling, BFS, message passing

### นิยาม

Queue คือ collection ที่เพิ่มข้อมูลด้านท้าย (enqueue) และลบด้านหน้า (dequeue) เท่านั้น

### 4.12.1 คืออะไร

Queue เป็น abstract data type ที่มี operations:
- `enqueue(item)` — เพิ่มท้าย
- `dequeue()` — ลบหน้า
- `front()` — ดูหน้า
- `is_empty()`
- `size()`

### 4.12.2 ทำงานอย่างไร

ใน Python ใช้ `collections.deque` เป็น queue ที่มีประสิทธิภาพ:
- `append()` — enqueue O(1)
- `popleft()` — dequeue O(1)

**อย่าใช้ list** เพราะ `pop(0)` เป็น O(n)

### 4.12.3 การใช้งาน

**deque-based Queue:**
```python
from collections import deque

queue = deque()
queue.append(1)      # enqueue
queue.append(2)
queue.append(3)
print(queue.popleft())  # 1 (dequeue)
print(queue[0])         # 2 (front)
print(len(queue))       # 2
```

**Custom Queue Class:**
```python
from collections import deque
from typing import Generic, TypeVar

T = TypeVar("T")

class Queue(Generic[T]):
    def __init__(self):
        self._items: deque[T] = deque()

    def enqueue(self, item: T) -> None:
        self._items.append(item)

    def dequeue(self) -> T:
        if self.is_empty():
            raise IndexError("dequeue from empty queue")
        return self._items.popleft()

    def front(self) -> T:
        if self.is_empty():
            raise IndexError("front from empty queue")
        return self._items[0]

    def is_empty(self) -> bool:
        return len(self._items) == 0

    def size(self) -> int:
        return len(self._items)

    def __len__(self) -> int:
        return len(self._items)

    def __repr__(self) -> str:
        return f"Queue({list(self._items)})"
```

**ตัวอย่างการใช้งานจริง — Task Scheduler:**
```python
from collections import deque
from dataclasses import dataclass, field
from datetime import datetime
from typing import Callable

@dataclass
class Task:
    name: str
    func: Callable[[], None]
    created_at: datetime = field(default_factory=datetime.now)

class TaskScheduler:
    def __init__(self, max_concurrent: int = 1):
        self.queue: deque[Task] = deque()
        self.max_concurrent = max_concurrent
        self.running: list[Task] = []

    def submit(self, task: Task) -> None:
        self.queue.append(task)
        print(f"Task '{task.name}' เข้าคิว (คิว: {len(self.queue)})")

    def run_next(self) -> Task | None:
        if not self.queue:
            return None

        task = self.queue.popleft()
        self.running.append(task)
        try:
            task.func()
        finally:
            self.running.remove(task)
        return task

    def run_all(self) -> int:
        count = 0
        while self.queue:
            self.run_next()
            count += 1
        return count

# การใช้งาน
scheduler = TaskScheduler()
scheduler.submit(Task("Send email", lambda: print("  → ส่งอีเมล")))
scheduler.submit(Task("Generate report", lambda: print("  → สร้างรายงาน")))
scheduler.submit(Task("Backup database", lambda: print("  → สำรองข้อมูล")))

print(f"\nรันทั้งหมด {scheduler.run_all()} tasks")
```

**ตัวอย่าง — BFS Graph Traversal:**
```python
from collections import deque

def bfs(graph: dict[str, list[str]], start: str) -> list[str]:
    """Breadth-First Search"""
    visited = {start}
    queue = deque([start])
    result = []

    while queue:
        node = queue.popleft()
        result.append(node)

        for neighbor in graph.get(node, []):
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)

    return result

graph = {
    "A": ["B", "C"],
    "B": ["D", "E"],
    "C": ["F"],
    "D": [],
    "E": ["F"],
    "F": ["G"],
    "G": [],
}

print(bfs(graph, "A"))  # ['A', 'B', 'C', 'D', 'E', 'F', 'G']
```

**ตัวอย่าง — Producer-Consumer Pattern:**
```python
import threading
import time
from collections import deque
from queue import Queue, Empty

# ใช้ queue.Queue สำหรับ thread-safe
task_queue: Queue = Queue(maxsize=10)

def producer(name: str, num_items: int):
    for i in range(num_items):
        item = f"{name}-item-{i}"
        task_queue.put(item)
        print(f"[{name}] produced: {item}")
        time.sleep(0.1)

def consumer(name: str):
    while True:
        try:
            item = task_queue.get(timeout=2)
            print(f"[{name}] consumed: {item}")
            time.sleep(0.2)
            task_queue.task_done()
        except Empty:
            print(f"[{name}] no more items, exiting")
            break

# รัน
producers = [
    threading.Thread(target=producer, args=(f"P{i}", 5))
    for i in range(2)
]
consumers = [
    threading.Thread(target=consumer, args=(f"C{i}",))
    for i in range(3)
]

for t in producers:
    t.start()
for t in consumers:
    t.start()

for t in producers + consumers:
    t.join()

print("All done")
```

### 4.12.4 ข้อดี

- **FIFO:** ยุติธรรมตามลำดับ
- **deque เร็ว:** O(1) สำหรับ enqueue/dequeue
- **Thread-safe:** ด้วย `queue.Queue`
- **เหมาะกับ BFS, scheduling**

### 4.12.5 ข้อเสีย

- **เข้าถึงกลางช้า:** O(n)
- **ไม่มี priority:** ต้องใช้ PriorityQueue
- **Memory:** ต้องเก็บข้อมูลทั้งหมดในคิว

### 4.12.6 ข้อควรระวัง

```python
# ระวัง 1: อย่าใช้ list เป็น queue
# ❌ ช้ามาก
queue = [1, 2, 3]
queue.pop(0)  # O(n)

# ✅ ใช้ deque
from collections import deque
queue = deque([1, 2, 3])
queue.popleft()  # O(1)

# ระวัง 2: deque ไม่ thread-safe สำหรับ multi-producer
# ใช้ queue.Queue แทนถ้ามีหลาย threads

# ระวัง 3: unbounded queue อาจกิน RAM
from queue import Queue
q = Queue()  # ไม่จำกัดขนาด
# ถ้า producer เร็วกว่า consumer มาก อาจ OOM

# ✅ จำกัดขนาด
q = Queue(maxsize=1000)
# q.put() จะ block ถ้าเต็ม
```

### 4.12.7 สรุป

ใช้ Queue เมื่อ:
- ต้องการ FIFO
- BFS graph traversal
- Task scheduling
- Producer-consumer
- Message passing ระหว่าง threads

> **อ้างอิงเพิ่มเติม:** [collections.deque](https://docs.python.org/3/library/collections.html#collections.deque), [queue — A synchronized queue class](https://docs.python.org/3/library/queue.html)

---

## 4.13 Deque

### บทนำ

Deque (double-ended queue) เป็นโครงสร้างข้อมูลที่เพิ่ม/ลบข้อมูลได้ทั้งสองด้านอย่างมีประสิทธิภาพ เป็นเครื่องมือที่ทรงพลังสำหรับ sliding window, palindrome, และงานอื่น ๆ

### นิยาม

Deque คือ generalization ของ stack และ queue ที่รองรับ operations ที่ทั้งสองด้าน O(1)

### 4.13.1 คืออะไร

`collections.deque` เป็น implementation ที่ optimize สำหรับ:
- `append()` / `pop()` — ด้านขวา
- `appendleft()` / `popleft()` — ด้านซ้าย
- `rotate()` — หมุน
- `maxlen` — จำกัดขนาด (auto-drop)

### 4.13.2 ทำงานอย่างไร

Deque implement เป็น doubly-linked list ของ blocks ขนาดคงที่ ทำให้:
- append/pop สองด้าน O(1)
- random access O(n) (แต่เร็วกว่า linked list)
- memory efficient

### 4.13.3 การใช้งาน

```python
from collections import deque

# สร้าง
d = deque([1, 2, 3])
d2 = deque(maxlen=5)  # จำกัดขนาด

# เพิ่ม/ลบ
d.append(4)         # [1, 2, 3, 4]
d.appendleft(0)     # [0, 1, 2, 3, 4]
d.pop()             # 4
d.popleft()         # 0

# Rotate
d = deque([1, 2, 3, 4, 5])
d.rotate(2)         # [4, 5, 1, 2, 3]
d.rotate(-1)        # [5, 1, 2, 3, 4]

# maxlen — auto-drop
recent = deque(maxlen=3)
for i in range(10):
    recent.append(i)
print(recent)  # deque([7, 8, 9], maxlen=3)

# extend
d = deque([1, 2])
d.extend([3, 4])       # [1, 2, 3, 4]
d.extendleft([0, -1])  # [-1, 0, 1, 2, 3, 4] (กลับลำดับ)
```

**ตัวอย่างการใช้งานจริง — Sliding Window Maximum:**
```python
from collections import deque

def sliding_window_max(nums: list[int], k: int) -> list[int]:
    """หาค่าสูงสุดใน sliding window ขนาด k"""
    result = []
    dq: deque[int] = deque()  # เก็บ indices

    for i, n in enumerate(nums):
        # ลบ indices ที่หลุด window
        while dq and dq[0] <= i - k:
            dq.popleft()

        # ลบ indices ที่ค่าน้อยกว่า n (ไม่มีทางเป็น max)
        while dq and nums[dq[-1]] < n:
            dq.pop()

        dq.append(i)

        # เริ่มเก็บผลลัพธ์เมื่อ window ครบ
        if i >= k - 1:
            result.append(nums[dq[0]])

    return result

nums = [1, 3, -1, -3, 5, 3, 6, 7]
k = 3
print(sliding_window_max(nums, k))
# [3, 3, 5, 5, 6, 7]
```

**ตัวอย่าง — Palindrome Check:**
```python
from collections import deque

def is_palindrome(text: str) -> bool:
    """ตรวจสอบ palindrome ด้วย deque"""
    # ทำความสะอาด
    chars = deque(c.lower() for c in text if c.isalnum())

    while len(chars) > 1:
        if chars.popleft() != chars.pop():
            return False
    return True

print(is_palindrome("A man, a plan, a canal: Panama"))  # True
print(is_palindrome("race a car"))                       # False
print(is_palindrome(""))                                 # True
print(is_palindrome("a"))                                # True
```

**ตัวอย่าง — Recent Items Cache:**
```python
from collections import deque
from dataclasses import dataclass
from datetime import datetime
from typing import Any

@dataclass
class CacheEntry:
    key: str
    value: Any
    timestamp: datetime

class LRUCache:
    """Least Recently Used Cache ด้วย deque"""

    def __init__(self, max_size: int = 100):
        self.max_size = max_size
        self._cache: dict[str, Any] = {}
        self._order: deque[str] = deque(maxlen=max_size)

    def get(self, key: str) -> Any | None:
        if key not in self._cache:
            return None
        # ย้ายไปท้าย (recent)
        self._order.remove(key)
        self._order.append(key)
        return self._cache[key]

    def put(self, key: str, value: Any) -> None:
        if key in self._cache:
            self._order.remove(key)
        elif len(self._order) >= self.max_size:
            # ลบตัวที่เก่าสุด
            oldest = self._order.popleft()
            del self._cache[oldest]

        self._cache[key] = value
        self._order.append(key)

    def __repr__(self) -> str:
        return f"LRUCache({list(self._order)})"

cache = LRUCache(max_size=3)
cache.put("a", 1)
cache.put("b", 2)
cache.put("c", 3)
print(cache)  # LRUCache(['a', 'b', 'c'])

cache.get("a")  # ทำให้ a เป็น recent
cache.put("d", 4)  # ลบ b
print(cache)  # LRUCache(['c', 'a', 'd'])
```

**ตัวอย่าง — Moving Average แบบ Streaming:**
```python
from collections import deque

class MovingAverage:
    def __init__(self, window_size: int):
        self.window_size = window_size
        self.window: deque[float] = deque(maxlen=window_size)
        self.sum = 0.0

    def next(self, val: float) -> float:
        # ถ้าเต็มแล้ว ลบค่าเก่า
        if len(self.window) == self.window_size:
            self.sum -= self.window[0]
        self.window.append(val)
        self.sum += val
        return self.sum / len(self.window)

# การใช้งาน
ma = MovingAverage(3)
for x in [1, 10, 3, 5]:
    print(f"Input: {x}, MA: {ma.next(x):.2f}")
# Input: 1, MA: 1.00
# Input: 10, MA: 5.50
# Input: 3, MA: 4.67
# Input: 5, MA: 6.00
```

### 4.13.4 ข้อดี

- **O(1) ทั้งสองด้าน:** เพิ่ม/ลบหัว-ท้าย
- **maxlen:** auto-drop เมื่อเต็ม
- **rotate:** หมุนได้
- **Memory efficient:** กว่า list ในบางกรณี

### 4.13.5 ข้อเสีย

- **Random access ช้า:** O(n) สำหรับ index กลาง
- **ใช้ memory มากกว่า list:** สำหรับข้อมูลเล็ก ๆ
- **ไม่มี slicing:** ไม่รองรับ `d[1:3]`

### 4.13.6 ข้อควรระวัง

```python
# ระวัง 1: deque ไม่รองรับ slicing
d = deque([1, 2, 3, 4, 5])
# d[1:3]  # ❌ TypeError

# ต้องใช้ itertools.islice
from itertools import islice
print(list(islice(d, 1, 3)))  # [2, 3]

# ระวัง 2: maxlen drop โดยไม่แจ้งเตือน
d = deque(maxlen=3)
for i in range(10):
    d.append(i)
# d = [7, 8, 9] — หายไป 7 ตัว

# ระวัง 3: remove() เป็น O(n)
d = deque([1, 2, 3, 2, 1])
d.remove(2)  # ลบตัวแรกที่เจอ O(n)

# ระวัง 4: อย่าใช้ deque สำหรับ random access บ่อย
# ใช้ list แทน
```

### 4.13.7 สรุป

ใช้ Deque เมื่อ:
- ต้องการเพิ่ม/ลบทั้งสองด้าน
- Sliding window
- LRU cache
- Palindrome check
- Recent items tracking

> **อ้างอิงเพิ่มเติม:** [collections.deque Documentation](https://docs.python.org/3/library/collections.html#collections.deque)

---

## 4.14 Linked List

### บทนำ

Linked List เป็นโครงสร้างข้อมูลเชิงเส้นที่แต่ละ node เก็บข้อมูลและ pointer ไปยัง node ถัดไป ต่างจาก array ที่ข้อมูลอยู่ติดกัน Linked List มีข้อดีในเรื่องการแทรก/ลบ แต่ช้าในการเข้าถึง

### นิยาม

Linked List คือ sequence ของ nodes ที่แต่ละ node มี data และ reference ไปยัง node ถัดไป (และ/หรือก่อนหน้า)

### 4.14.1 คืออะไร

ประเภทของ Linked List:
- **Singly Linked List:** แต่ละ node ชี้ไป node ถัดไป
- **Doubly Linked List:** node ชี้ทั้งไปและกลับ
- **Circular Linked List:** node สุดท้ายชี้กลับไป node แรก

### 4.14.2 ทำงานอย่างไร

**Singly Linked List:**
```
[data|next] → [data|next] → [data|next] → None
   head
```

**Doubly Linked List:**
```
None ← [prev|data|next] ⇄ [prev|data|next] ⇄ [prev|data|next] → None
        head                                       tail
```

Operations:
- **Prepend:** O(1)
- **Append:** O(1) ถ้ามี tail pointer
- **Insert/Delete:** O(1) ถ้ามี reference
- **Search:** O(n)
- **Access by index:** O(n)

### 4.14.3 การใช้งาน

**Singly Linked List Implementation:**
```python
from typing import Generic, TypeVar, Optional, Iterator

T = TypeVar("T")

class Node(Generic[T]):
    def __init__(self, data: T, next: Optional["Node[T]"] = None):
        self.data = data
        self.next = next

class SinglyLinkedList(Generic[T]):
    def __init__(self):
        self.head: Node[T] | None = None
        self._size = 0

    def prepend(self, data: T) -> None:
        """เพิ่มด้านหน้า O(1)"""
        new_node = Node(data, self.head)
        self.head = new_node
        self._size += 1

    def append(self, data: T) -> None:
        """เพิ่มด้านหลัง O(n) ถ้าไม่มี tail"""
        new_node = Node(data)
        if self.head is None:
            self.head = new_node
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = new_node
        self._size += 1

    def delete(self, data: T) -> bool:
        """ลบ node แรกที่พบ O(n)"""
        if self.head is None:
            return False

        if self.head.data == data:
            self.head = self.head.next
            self._size -= 1
            return True

        current = self.head
        while current.next:
            if current.next.data == data:
                current.next = current.next.next
                self._size -= 1
                return True
            current = current.next
        return False

    def find(self, data: T) -> Node[T] | None:
        """ค้นหา O(n)"""
        current = self.head
        while current:
            if current.data == data:
                return current
            current = current.next
        return None

    def reverse(self) -> None:
        """กลับลำดับ O(n)"""
        prev = None
        current = self.head
        while current:
            next_node = current.next
            current.next = prev
            prev = current
            current = next_node
        self.head = prev

    def __iter__(self) -> Iterator[T]:
        current = self.head
        while current:
            yield current.data
            current = current.next

    def __len__(self) -> int:
        return self._size

    def __repr__(self) -> str:
        return f"LinkedList({list(self)})"

# การใช้งาน
ll = SinglyLinkedList[int]()
ll.append(1)
ll.append(2)
ll.append(3)
ll.prepend(0)
print(ll)  # LinkedList([0, 1, 2, 3])

ll.delete(2)
print(ll)  # LinkedList([0, 1, 3])

ll.reverse()
print(ll)  # LinkedList([3, 1, 0])

print(1 in ll)  # False
print(len(ll))   # 3
```

**Doubly Linked List:**
```python
class DNode(Generic[T]):
    def __init__(
        self,
        data: T,
        prev: Optional["DNode[T]"] = None,
        next: Optional["DNode[T]"] = None,
    ):
        self.data = data
        self.prev = prev
        self.next = next

class DoublyLinkedList(Generic[T]):
    def __init__(self):
        self.head: DNode[T] | None = None
        self.tail: DNode[T] | None = None
        self._size = 0

    def append(self, data: T) -> None:
        """เพิ่มด้านหลัง O(1)"""
        new_node = DNode(data)
        if self.tail is None:
            self.head = self.tail = new_node
        else:
            new_node.prev = self.tail
            self.tail.next = new_node
            self.tail = new_node
        self._size += 1

    def prepend(self, data: T) -> None:
        """เพิ่มด้านหน้า O(1)"""
        new_node = DNode(data)
        if self.head is None:
            self.head = self.tail = new_node
        else:
            new_node.next = self.head
            self.head.prev = new_node
            self.head = new_node
        self._size += 1

    def remove_node(self, node: DNode[T]) -> None:
        """ลบ node O(1)"""
        if node.prev:
            node.prev.next = node.next
        else:
            self.head = node.next

        if node.next:
            node.next.prev = node.prev
        else:
            self.tail = node.prev

        self._size -= 1

    def __iter__(self) -> Iterator[T]:
        current = self.head
        while current:
            yield current.data
            current = current.next

    def __reversed__(self) -> Iterator[T]:
        current = self.tail
        while current:
            yield current.data
            current = current.prev

    def __len__(self) -> int:
        return self._size
```

**ตัวอย่างการใช้งานจริง — LRU Cache ด้วย Doubly Linked List:**
```python
class LRUNode:
    __slots__ = ("key", "value", "prev", "next")

    def __init__(self, key: str = "", value: int = 0):
        self.key = key
        self.value = value
        self.prev: LRUNode | None = None
        self.next: LRUNode | None = None

class LRUCache:
    """O(1) LRU cache using doubly linked list + hashmap"""

    def __init__(self, capacity: int):
        self.capacity = capacity
        self.cache: dict[str, LRUNode] = {}

        # dummy head/tail
        self.head = LRUNode()
        self.tail = LRUNode()
        self.head.next = self.tail
        self.tail.prev = self.head

    def _remove(self, node: LRUNode) -> None:
        node.prev.next = node.next
        node.next.prev = node.prev

    def _add_to_head(self, node: LRUNode) -> None:
        node.next = self.head.next
        node.prev = self.head
        self.head.next.prev = node
        self.head.next = node

    def get(self, key: str) -> int:
        if key not in self.cache:
            return -1
        node = self.cache[key]
        self._remove(node)
        self._add_to_head(node)
        return node.value

    def put(self, key: str, value: int) -> None:
        if key in self.cache:
            node = self.cache[key]
            node.value = value
            self._remove(node)
            self._add_to_head(node)
        else:
            if len(self.cache) >= self.capacity:
                # ลบ tail (LRU)
                lru = self.tail.prev
                self._remove(lru)
                del self.cache[lru.key]

            new_node = LRUNode(key, value)
            self.cache[key] = new_node
            self._add_to_head(new_node)

# การใช้งาน
cache = LRUCache(2)
cache.put("a", 1)
cache.put("b", 2)
print(cache.get("a"))  # 1
cache.put("c", 3)      # ลบ "b"
print(cache.get("b"))  # -1
print(cache.get("c"))  # 3
```

### 4.14.4 ข้อดี

- **Dynamic size:** ไม่ต้องกำหนดขนาดล่วงหน้า
- **Fast insert/delete:** O(1) ถ้ามี reference
- **Memory efficient:** สำหรับข้อมูลที่ insert/delete บ่อย
- **Implement structures อื่นได้:** stack, queue, LRU cache

### 4.14.5 ข้อเสีย

- **Random access ช้า:** O(n)
- **ใช้ memory มากกว่า array:** เพราะเก็บ pointer
- **Cache locality แย่:** กว่า array (ข้อมูลไม่ติดกัน)
- **Search ช้า:** O(n)
- **Implement ซับซ้อน:** กว่า list

### 4.14.6 ข้อควรระวัง

```python
# ระวัง 1: การ update pointer ผิดลำดับ
def wrong_remove(node):
    node.prev.next = node.next  # ถ้า node.prev เป็น None → error
    # ต้องเช็คก่อน

# ✅ ถูกต้อง
def correct_remove(self, node):
    if node.prev:
        node.prev.next = node.next
    else:
        self.head = node.next
    # ...

# ระวัง 2: Memory leak จาก cycles
# Python มี GC จัดการ แต่ถ้าใช้ __del__ อาจมีปัญหา

# ระวัง 3: Recursion ใน linked list ขนาดใหญ่
# ❌ อาจ stack overflow
def traverse_recursive(node):
    if node:
        print(node.data)
        traverse_recursive(node.next)

# ✅ ใช้ iteration
def traverse_iterative(node):
    while node:
        print(node.data)
        node = node.next
```

### 4.14.7 สรุป

ใช้ Linked List เมื่อ:
- ต้องการ insert/delete บ่อย
- ไม่ต้องการ random access
- Implement structures อื่น (LRU cache, stack, queue)
- **หมายเหตุ:** ใน Python มักใช้ list หรือ deque แทน ยกเว้นกรณีเฉพาะ

> **อ้างอิงเพิ่มเติม:** [Linked List](https://en.wikipedia.org/wiki/Linked_list)

---

## 4.15 Tree

### บทนำ

Tree เป็นโครงสร้างข้อมูลแบบ hierarchical ที่แต่ละ node มี parent (ยกเว้น root) และ children ใช้ในไฟล์ systems, databases, parsing, AI (decision tree) และอื่น ๆ อีกมาก

### นิยาม

Tree คือ connected acyclic graph ที่มี:
- **Root:** node บนสุด (ไม่มี parent)
- **Leaf:** node ที่ไม่มี children
- **Internal node:** node ที่มี children
- **Edge:** เส้นเชื่อมระหว่าง nodes
- **Depth:** ระยะจาก root
- **Height:** ระยะสูงสุดจาก root ถึง leaf

### 4.15.1 คืออะไร

**Binary Tree:** tree ที่แต่ละ node มีไม่เกิน 2 children (left, right)

**Binary Search Tree (BST):** binary tree ที่:
- left subtree มีค่าน้อยกว่า root
- right subtree มีค่ามากกว่า root

**Balanced Trees:** AVL, Red-Black ที่รักษาความสูง O(log n)

### 4.15.2 ทำงานอย่างไร

**BST operations:**
- **Search:** O(log n) ถ้า balanced, O(n) ถ้า unbalanced
- **Insert:** O(log n)
- **Delete:** O(log n)
- **Min/Max:** O(log n)
- **In-order traversal:** O(n) ได้ค่าที่เรียงแล้ว

### 4.15.3 การใช้งาน

**Binary Search Tree Implementation:**
```python
from typing import Generic, TypeVar, Optional, Iterator

T = TypeVar("T")

class TreeNode(Generic[T]):
    def __init__(self, value: T):
        self.value = value
        self.left: TreeNode[T] | None = None
        self.right: TreeNode[T] | None = None

class BST(Generic[T]):
    def __init__(self):
        self.root: TreeNode[T] | None = None
        self._size = 0

    def insert(self, value: T) -> None:
        if self.root is None:
            self.root = TreeNode(value)
        else:
            self._insert(self.root, value)
        self._size += 1

    def _insert(self, node: TreeNode[T], value: T) -> None:
        if value < node.value:
            if node.left is None:
                node.left = TreeNode(value)
            else:
                self._insert(node.left, value)
        else:
            if node.right is None:
                node.right = TreeNode(value)
            else:
                self._insert(node.right, value)

    def search(self, value: T) -> bool:
        return self._search(self.root, value)

    def _search(self, node: TreeNode[T] | None, value: T) -> bool:
        if node is None:
            return False
        if value == node.value:
            return True
        if value < node.value:
            return self._search(node.left, value)
        return self._search(node.right, value)

    def inorder(self) -> Iterator[T]:
        """เรียงลำดับจากน้อยไปมาก"""
        yield from self._inorder(self.root)

    def _inorder(self, node: TreeNode[T] | None) -> Iterator[T]:
        if node:
            yield from self._inorder(node.left)
            yield node.value
            yield from self._inorder(node.right)

    def preorder(self) -> Iterator[T]:
        yield from self._preorder(self.root)

    def _preorder(self, node: TreeNode[T] | None) -> Iterator[T]:
        if node:
            yield node.value
            yield from self._preorder(node.left)
            yield from self._preorder(node.right)

    def postorder(self) -> Iterator[T]:
        yield from self._postorder(self.root)

    def _postorder(self, node: TreeNode[T] | None) -> Iterator[T]:
        if node:
            yield from self._postorder(node.left)
            yield from self._postorder(node.right)
            yield node.value

    def height(self) -> int:
        return self._height(self.root)

    def _height(self, node: TreeNode[T] | None) -> int:
        if node is None:
            return 0
        return 1 + max(self._height(node.left), self._height(node.right))

    def min_value(self) -> T | None:
        if self.root is None:
            return None
        node = self.root
        while node.left:
            node = node.left
        return node.value

    def max_value(self) -> T | None:
        if self.root is None:
            return None
        node = self.root
        while node.right:
            node = node.right
        return node.value

    def __len__(self) -> int:
        return self._size

    def __contains__(self, value: T) -> bool:
        return self.search(value)

# การใช้งาน
bst = BST[int]()
for x in [50, 30, 70, 20, 40, 60, 80]:
    bst.insert(x)

print(list(bst.inorder()))   # [20, 30, 40, 50, 60, 70, 80]
print(list(bst.preorder()))  # [50, 30, 20, 40, 70, 60, 80]
print(list(bst.postorder())) # [20, 40, 30, 60, 80, 70, 50]
print(bst.min_value())       # 20
print(bst.max_value())       # 80
print(bst.height())          # 3
print(40 in bst)             # True
```

**ตัวอย่างการใช้งานจริง — File System Tree:**
```python
from dataclasses import dataclass, field
from pathlib import Path

@dataclass
class FileNode:
    name: str
    is_dir: bool
    children: list["FileNode"] = field(default_factory=list)
    size: int = 0

    def add_child(self, node: "FileNode") -> None:
        self.children.append(node)

    def total_size(self) -> int:
        if not self.is_dir:
            return self.size
        return sum(c.total_size() for c in self.children)

    def find(self, name: str) -> "FileNode | None":
        if self.name == name:
            return self
        for child in self.children:
            if result := child.find(name):
                return result
        return None

    def print_tree(self, indent: int = 0) -> None:
        prefix = "  " * indent
        icon = "📁" if self.is_dir else "📄"
        size_str = f" ({self.size:,} bytes)" if not self.is_dir else ""
        print(f"{prefix}{icon} {self.name}{size_str}")
        for child in self.children:
            child.print_tree(indent + 1)

def build_tree_from_path(root_path: str) -> FileNode:
    """สร้าง tree จากไฟล์ system"""
    path = Path(root_path)

    def build(p: Path) -> FileNode:
        node = FileNode(name=p.name, is_dir=p.is_dir())
        if p.is_file():
            node.size = p.stat().st_size
        else:
            for child in sorted(p.iterdir()):
                node.add_child(build(child))
        return node

    return build(path)

# tree = build_tree_from_path("./my_project")
# tree.print_tree()
```

**ตัวอย่าง — Expression Tree:**
```python
from abc import ABC, abstractmethod

class Expr(ABC):
    @abstractmethod
    def evaluate(self) -> float:
        ...

    @abstractmethod
    def __str__(self) -> str:
        ...

class Number(Expr):
    def __init__(self, value: float):
        self.value = value

    def evaluate(self) -> float:
        return self.value

    def __str__(self) -> str:
        return str(self.value)

class BinaryOp(Expr):
    def __init__(self, left: Expr, op: str, right: Expr):
        self.left = left
        self.op = op
        self.right = right

    def evaluate(self) -> float:
        left = self.left.evaluate()
        right = self.right.evaluate()
        ops = {
            "+": lambda a, b: a + b,
            "-": lambda a, b: a - b,
            "*": lambda a, b: a * b,
            "/": lambda a, b: a / b,
        }
        return ops[self.op](left, right)

    def __str__(self) -> str:
        return f"({self.left} {self.op} {self.right})"

# สร้าง: (3 + 4) * (10 - 5)
tree = BinaryOp(
    BinaryOp(Number(3), "+", Number(4)),
    "*",
    BinaryOp(Number(10), "-", Number(5)),
)

print(tree)             # ((3.0 + 4.0) * (10.0 - 5.0))
print(tree.evaluate())  # 35.0
```

### 4.15.4 ข้อดี

- **Hierarchical:** เหมาะกับข้อมูลที่มีโครงสร้างต้นไม้
- **BST:** ค้นหาเร็ว O(log n)
- **In-order:** ได้ข้อมูลเรียงลำดับ
- **Recursive:** เหมาะกับ recursive algorithms
- **ยืดหยุ่น:** หลายชนิด (BST, AVL, Red-Black, Trie, Segment)

### 4.15.5 ข้อเสีย

- **Unbalanced:** BST อาจกลายเป็น linked list O(n)
- **Memory overhead:** แต่ละ node เก็บ pointer
- **Implement ซับซ้อน:** โดยเฉพาะ balanced trees
- **Cache locality แย่:** กว่า array

### 4.15.6 ข้อควรระวัง

```python
# ระวัง 1: BST ที่ unbalanced
bst = BST[int]()
for x in range(1000):
    bst.insert(x)
# กลายเป็น linked list → search เป็น O(n)

# ✅ ใช้ balanced tree (AVL, Red-Black) หรือ sortedcontainers

# ระวัง 2: Recursion depth
# Tree สูง 1000+ อาจ stack overflow
# ใช้ iterative traversal แทน

def inorder_iterative(root):
    stack = []
    current = root
    while stack or current:
        while current:
            stack.append(current)
            current = current.left
        current = stack.pop()
        yield current.value
        current = current.right

# ระวัง 3: Delete node ที่มี 2 children
# ต้องหา inorder successor/predecessor มาทดแทน
```

### 4.15.7 สรุป

ใช้ Tree เมื่อ:
- ข้อมูลมีโครงสร้าง hierarchical
- ต้องการค้นหาเร็ว (BST)
- ต้องการเรียงลำดับ (in-order traversal)
- Expression parsing, file systems, decision trees

> **อ้างอิงเพิ่มเติม:** [Binary Search Tree](https://en.wikipedia.org/wiki/Binary_search_tree), [Tree Data Structure](https://en.wikipedia.org/wiki/Tree_(data_structure))

---

## 4.16 Graph

### บทนำ

Graph เป็นโครงสร้างข้อมูลที่ทรงพลังที่สุดในบรรดาโครงสร้างทั้งหมด ใช้แทนความสัมพันธ์ระหว่าง objects ใช้ใน social networks, maps, recommendation systems และอื่น ๆ อีกมาก

### นิยาม

Graph ประกอบด้วย:
- **Vertices (Nodes):** จุด
- **Edges:** เส้นเชื่อมระหว่าง vertices

**ประเภท:**
- **Directed / Undirected**
- **Weighted / Unweighted**
- **Cyclic / Acyclic**
- **Connected / Disconnected**

### 4.16.1 คืออะไร

Graph สามารถแทนด้วย:
- **Adjacency List:** dict ของ node → list ของ neighbors (ประหยัด memory)
- **Adjacency Matrix:** 2D array (เร็วในการเช็ค edge)

### 4.16.2 ทำงานอย่างไร

**Adjacency List:**
```python
graph = {
    "A": ["B", "C"],
    "B": ["A", "D"],
    "C": ["A", "D"],
    "D": ["B", "C"],
}
```

**Adjacency Matrix:**
```
   A B C D
A [0 1 1 0]
B [1 0 0 1]
C [1 0 0 1]
D [0 1 1 0]
```

### 4.16.3 การใช้งาน

**Graph Class:**
```python
from collections import defaultdict, deque
from typing import Generic, TypeVar, Iterator
import heapq

T = TypeVar("T")

class Graph(Generic[T]):
    def __init__(self, directed: bool = False):
        self.directed = directed
        self.adj: dict[T, list[tuple[T, float]]] = defaultdict(list)

    def add_edge(self, u: T, v: T, weight: float = 1.0) -> None:
        self.adj[u].append((v, weight))
        if not self.directed:
            self.adj[v].append((u, weight))

    def add_vertex(self, v: T) -> None:
        if v not in self.adj:
            self.adj[v] = []

    def neighbors(self, v: T) -> list[tuple[T, float]]:
        return self.adj.get(v, [])

    def bfs(self, start: T) -> Iterator[T]:
        """Breadth-First Search"""
        visited = {start}
        queue = deque([start])

        while queue:
            node = queue.popleft()
            yield node
            for neighbor, _ in self.neighbors(node):
                if neighbor not in visited:
                    visited.add(neighbor)
                    queue.append(neighbor)

    def dfs(self, start: T) -> Iterator[T]:
        """Depth-First Search (iterative)"""
        visited = set()
        stack = [start]

        while stack:
            node = stack.pop()
            if node in visited:
                continue
            visited.add(node)
            yield node
            for neighbor, _ in reversed(self.neighbors(node)):
                if neighbor not in visited:
                    stack.append(neighbor)

    def dijkstra(self, start: T) -> dict[T, float]:
        """Shortest path ด้วย Dijkstra"""
        distances: dict[T, float] = {start: 0}
        pq = [(0, start)]

        while pq:
            current_dist, current = heapq.heappop(pq)

            if current_dist > distances.get(current, float("inf")):
                continue

            for neighbor, weight in self.neighbors(current):
                distance = current_dist + weight
                if distance < distances.get(neighbor, float("inf")):
                    distances[neighbor] = distance
                    heapq.heappush(pq, (distance, neighbor))

        return distances

    def has_cycle(self) -> bool:
        """ตรวจสอบว่ามี cycle หรือไม่"""
        visited = set()
        rec_stack = set()

        def dfs_visit(node: T) -> bool:
            visited.add(node)
            rec_stack.add(node)

            for neighbor, _ in self.neighbors(node):
                if neighbor not in visited:
                    if dfs_visit(neighbor):
                        return True
                elif neighbor in rec_stack:
                    return True

            rec_stack.remove(node)
            return False

        for node in list(self.adj.keys()):
            if node not in visited:
                if dfs_visit(node):
                    return True
        return False

    def __len__(self) -> int:
        return len(self.adj)
```

**ตัวอย่างการใช้งานจริง — Social Network:**
```python
class SocialNetwork:
    def __init__(self):
        self.graph: dict[str, set[str]] = defaultdict(set)

    def add_friendship(self, a: str, b: str) -> None:
        self.graph[a].add(b)
        self.graph[b].add(a)

    def mutual_friends(self, a: str, b: str) -> set[str]:
        return self.graph[a] & self.graph[b]

    def shortest_path(self, start: str, end: str) -> list[str] | None:
        """หา shortest path ผ่าน BFS"""
        if start == end:
            return [start]

        visited = {start}
        queue = deque([(start, [start])])

        while queue:
            node, path = queue.popleft()
            for friend in self.graph[node]:
                if friend == end:
                    return path + [friend]
                if friend not in visited:
                    visited.add(friend)
                    queue.append((friend, path + [friend]))
        return None

    def recommendations(self, user: str, limit: int = 5) -> list[tuple[str, int]]:
        """แนะนำเพื่อนจาก mutual friends"""
        friends = self.graph[user]
        candidates: dict[str, int] = defaultdict(int)

        for friend in friends:
            for friend_of_friend in self.graph[friend]:
                if friend_of_friend != user and friend_of_friend not in friends:
                    candidates[friend_of_friend] += 1

        return sorted(candidates.items(), key=lambda x: -x[1])[:limit]

# การใช้งาน
sn = SocialNetwork()
sn.add_friendship("Alice", "Bob")
sn.add_friendship("Alice", "Charlie")
sn.add_friendship("Bob", "David")
sn.add_friendship("Charlie", "David")
sn.add_friendship("David", "Eve")

print("Mutual friends:", sn.mutual_friends("Alice", "David"))
print("Path:", sn.shortest_path("Alice", "Eve"))
print("Recommendations for Alice:", sn.recommendations("Alice"))
```

**ตัวอย่าง — Weighted Graph (Dijkstra):**
```python
# Graph แทนเมืองและระยะทาง
cities = Graph[str](directed=False)
cities.add_edge("Bangkok", "Chiang Mai", 700)
cities.add_edge("Bangkok", "Pattaya", 150)
cities.add_edge("Chiang Mai", "Chiang Rai", 200)
cities.add_edge("Chiang Rai", "Luang Prabang", 400)
cities.add_edge("Bangkok", "Khon Kaen", 450)

distances = cities.dijkstra("Bangkok")
for city, dist in sorted(distances.items(), key=lambda x: x[1]):
    print(f"Bangkok → {city}: {dist} km")
```

**ตัวอย่าง — Topological Sort (DAG):**
```python
def topological_sort(graph: dict[str, list[str]]) -> list[str]:
    """เรียงลำดับ dependencies ใน DAG"""
    # นับ in-degree
    in_degree: dict[str, int] = {node: 0 for node in graph}
    for neighbors in graph.values():
        for n in neighbors:
            in_degree[n] = in_degree.get(n, 0) + 1

    # เริ่มจาก nodes ที่ in-degree = 0
    queue = deque([n for n, d in in_degree.items() if d == 0])
    result = []

    while queue:
        node = queue.popleft()
        result.append(node)
        for neighbor in graph.get(node, []):
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0:
                queue.append(neighbor)

    if len(result) != len(in_degree):
        raise ValueError("Graph has cycle")

    return result

# ตัวอย่าง: build dependencies
build_deps = {
    "app": ["lib", "frontend"],
    "frontend": ["ui_lib"],
    "lib": ["utils"],
    "ui_lib": ["utils"],
    "utils": [],
}

order = topological_sort(build_deps)
print("Build order:", order)
# ['app', 'lib', 'frontend', 'utils', 'ui_lib'] — ต้องเช็ค
```

### 4.16.4 ข้อดี

- **ยืดหยุ่นที่สุด:** แทนได้เกือบทุกความสัมพันธ์
- **อัลกอริทึมมากมาย:** BFS, DFS, Dijkstra, A*, Bellman-Ford
- **ใช้ในหลาย領域:** social, maps, networks, dependencies

### 4.16.5 ข้อเสีย

- **Memory:** อาจกิน RAM มาก (โดยเฉพาะ dense graph)
- **อัลกอริทึมซับซ้อน:** บางอย่างเข้าใจยาก
- **NP-hard problems:** เช่น TSP, graph coloring

### 4.16.6 ข้อควรระวัง

```python
# ระวัง 1: Cycle detection
# Graph ที่มี cycle — ระวัง infinite loop
# ต้อง track visited เสมอ

# ระวัง 2: Adjacency Matrix สำหรับ sparse graph
# ❌ กิน memory มาก O(V²)
matrix = [[0] * 10000 for _ in range(10000)]  # 100M cells!

# ✅ ใช้ adjacency list สำหรับ sparse
adj_list = defaultdict(list)

# ระวัง 3: Dijkstra กับ negative weights
# ❌ ใช้ไม่ได้ ต้องใช้ Bellman-Ford

# ระวัง 4: Recursion depth ใน DFS
# Graph ลึก 1000+ อาจ stack overflow
# ใช้ iterative DFS
```

### 4.16.7 สรุป

ใช้ Graph เมื่อ:
- แทนความสัมพันธ์ (social, transport, dependencies)
- Path finding
- Network analysis
- Recommendation systems
- Scheduling problems

> **อ้างอิงเพิ่มเติม:** [Graph Theory](https://en.wikipedia.org/wiki/Graph_theory), [NetworkX Documentation](https://networkx.org/documentation/stable/)

---

## 4.17 Hash Table

### บทนำ

Hash Table เป็นโครงสร้างข้อมูลที่ทำให้การค้นหา การเพิ่ม และการลบทำได้ในเวลาเฉลี่ย O(1) เป็นพื้นฐานของ dict และ set ใน Python

### นิยาม

Hash Table เก็บข้อมูลเป็น key-value pairs โดยใช้ hash function แปลง key เป็น index ใน array

### 4.17.1 คืออะไร

Hash Table ประกอบด้วย:
- **Hash function:** แปลง key → integer
- **Buckets:** array ของ slots
- **Collision resolution:** จัดการเมื่อ 2 keys hash ไปที่เดียวกัน (chaining หรือ open addressing)

### 4.17.2 ทำงานอย่างไร

```python
# แนวคิด
hash("hello") % table_size  # → index

# Python มี built-in hash()
print(hash("hello"))          # ค่าคงที่ต่อ session
print(hash(42))               # 42
print(hash((1, 2, 3)))        # hash ของ tuple

# hash() ของ mutable objects ไม่ได้
# hash([1, 2, 3])  # ❌ TypeError
```

**Load Factor:** อัตราส่วนระหว่างจำนวน items กับขนาด table เมื่อเกิน threshold (0.66 ใน CPython) จะ resize

### 4.17.3 การใช้งาน

**Hash Table Implementation:**
```python
from typing import Generic, TypeVar, Optional

K = TypeVar("K")
V = TypeVar("V")

class HashTable(Generic[K, V]):
    """Simple hash table with chaining"""

    def __init__(self, capacity: int = 16):
        self.capacity = capacity
        self.buckets: list[list[tuple[K, V]]] = [[] for _ in range(capacity)]
        self._size = 0
        self._load_factor = 0.75

    def _hash(self, key: K) -> int:
        return hash(key) % self.capacity

    def put(self, key: K, value: V) -> None:
        index = self._hash(key)

        # เช็คว่ามี key อยู่แล้วหรือไม่
        for i, (k, v) in enumerate(self.buckets[index]):
            if k == key:
                self.buckets[index][i] = (key, value)
                return

        self.buckets[index].append((key, value))
        self._size += 1

        # Resize ถ้า load factor สูงเกิน
        if self._size / self.capacity > self._load_factor:
            self._resize()

    def get(self, key: K) -> V | None:
        index = self._hash(key)
        for k, v in self.buckets[index]:
            if k == key:
                return v
        return None

    def delete(self, key: K) -> bool:
        index = self._hash(key)
        bucket = self.buckets[index]
        for i, (k, v) in enumerate(bucket):
            if k == key:
                bucket.pop(i)
                self._size -= 1
                return True
        return False

    def _resize(self) -> None:
        old_buckets = self.buckets
        self.capacity *= 2
        self.buckets = [[] for _ in range(self.capacity)]
        self._size = 0

        for bucket in old_buckets:
            for key, value in bucket:
                self.put(key, value)

    def __getitem__(self, key: K) -> V:
        value = self.get(key)
        if value is None:
            raise KeyError(key)
        return value

    def __setitem__(self, key: K, value: V) -> None:
        self.put(key, value)

    def __contains__(self, key: K) -> bool:
        return self.get(key) is not None

    def __len__(self) -> int:
        return self._size

# การใช้งาน
ht = HashTable[str, int]()
ht.put("a", 1)
ht.put("b", 2)
ht["c"] = 3

print(ht.get("a"))   # 1
print("b" in ht)     # True
print(len(ht))       # 3
```

**ตัวอย่างการใช้งานจริง — Frequency Counter:**
```python
from collections import Counter

def word_frequency(text: str, top_n: int = 10) -> list[tuple[str, int]]:
    """นับความถี่ของคำ"""
    # แยกคำและทำ lowercase
    words = text.lower().split()

    # ใช้ Counter (hash table)
    counter = Counter(words)
    return counter.most_common(top_n)

text = """
Python is great. Python is fast. Python is powerful.
Python can do anything. Python is easy to learn.
"""

for word, count in word_frequency(text):
    print(f"{word}: {count}")
```

**ตัวอย่าง — Consistent Hashing:**
```python
import hashlib

class ConsistentHash:
    """Consistent hashing สำหรับ distributed systems"""

    def __init__(self, nodes: list[str], replicas: int = 100):
        self.replicas = replicas
        self.ring: dict[int, str] = {}
        self._sorted_keys: list[int] = []

        for node in nodes:
            self.add_node(node)

    def _hash(self, key: str) -> int:
        return int(hashlib.md5(key.encode()).hexdigest(), 16)

    def add_node(self, node: str) -> None:
        for i in range(self.replicas):
            key = self._hash(f"{node}:{i}")
            self.ring[key] = node
            self._sorted_keys.append(key)
        self._sorted_keys.sort()

    def remove_node(self, node: str) -> None:
        for i in range(self.replicas):
            key = self._hash(f"{node}:{i}")
            del self.ring[key]
            self._sorted_keys.remove(key)

    def get_node(self, key: str) -> str:
        """หา node ที่รับผิดชอบ key"""
        if not self.ring:
            raise ValueError("No nodes in ring")

        hash_key = self._hash(key)
        # Binary search หา node แรกที่ hash >= hash_key
        import bisect
        index = bisect.bisect_right(self._sorted_keys, hash_key)
        if index == len(self._sorted_keys):
            index = 0
        return self.ring[self._sorted_keys[index]]

# การใช้งาน
ch = ConsistentHash(["server1", "server2", "server3"])
for user in ["alice", "bob", "charlie", "david"]:
    server = ch.get_node(user)
    print(f"{user} → {server}")
```

### 4.17.4 ข้อดี

- **เร็วมาก:** O(1) เฉลี่ยสำหรับ get/put/delete
- **ยืดหยุ่น:** keys ชนิดใดก็ได้ (ที่ hashable)
- **พื้นฐานของ dict/set:** ใช้ทุกที่
- **Scalable:** resize ได้อัตโนมัติ

### 4.17.5 ข้อเสีย

- **Worst case O(n):** ถ้า hash ชนกันมาก
- **ไม่เรียงลำดับ:** ไม่สามารถเข้าถึงแบบ sorted
- **Memory overhead:** กิน RAM มากกว่า array
- **Keys ต้อง hashable:** list, dict ใช้ไม่ได้

### 4.17.6 ข้อควรระวัง

```python
# ระวัง 1: Custom objects ต้อง implement __hash__ และ __eq__
class BadKey:
    def __init__(self, value):
        self.value = value

# ❌ ใช้เป็น dict key ได้ แต่ความหมายอาจผิด
d = {BadKey(1): "a"}
print(d[BadKey(1)])  # ❌ KeyError เพราะ object ใหม่

# ✅ ต้อง implement
class GoodKey:
    def __init__(self, value):
        self.value = value

    def __hash__(self):
        return hash(self.value)

    def __eq__(self, other):
        return isinstance(other, GoodKey) and self.value == other.value

d = {GoodKey(1): "a"}
print(d[GoodKey(1)])  # 'a'

# ระวัง 2: Mutable objects ที่ hash เปลี่ยน
# อย่าใช้ mutable เป็น key
# d[[1, 2]] = "value"  # ❌ TypeError

# ระวัง 3: hash collision attacks
# Python ใช้ SipHash (randomized) ป้องกัน DOS

# ระวัง 4: Memory สำหรับ sparse data
# ใช้ dict สำหรับ sparse, array สำหรับ dense
```

### 4.17.7 สรุป

Hash Table เป็นพื้นฐานของ dict และ set ใน Python ใช้เมื่อ:
- ต้องการ lookup O(1)
- ต้องการ unique keys
- ต้องการนับ/จัดกลุ่มข้อมูล
- ต้องการ cache

> **อ้างอิงเพิ่มเติม:** [Hash Table](https://en.wikipedia.org/wiki/Hash_table), [Python Data Model — __hash__](https://docs.python.org/3/reference/datamodel.html#object.__hash__)

---

## 4.18 Heap

### บทนำ

Heap เป็น tree-based data structure ที่รักษา property: parent มีค่ามากกว่าหรือเท่ากับ (max-heap) หรือน้อยกว่าหรือเท่ากับ (min-heap) children ใช้ใน priority queue, heap sort, และ graph algorithms

### นิยาม

Binary Heap เป็น complete binary tree ที่:
- **Min-heap:** parent ≤ children
- **Max-heap:** parent ≥ children

Operations:
- **Insert:** O(log n)
- **Extract min/max:** O(log n)
- **Peek:** O(1)
- **Build heap:** O(n)

### 4.18.1 คืออะไร

Python มี `heapq` module ที่ implement min-heap บน list สำหรับ max-heap ต้องใช้ trick (ใส่ค่าลบ)

### 4.18.2 ทำงานอย่างไร

Heap เก็บใน array โดย:
- Root: `arr[0]`
- Left child: `arr[2*i + 1]`
- Right child: `arr[2*i + 2]`
- Parent: `arr[(i-1) // 2]`

`heappush` และ `heappop` รักษา heap property ด้วยการ swap

### 4.18.3 การใช้งาน

**heapq พื้นฐาน:**
```python
import heapq

# สร้าง heap
heap = []
heapq.heappush(heap, 5)
heapq.heappush(heap, 2)
heapq.heappush(heap, 8)
heapq.heappush(heap, 1)

print(heap)                  # [1, 2, 8, 5] (min-heap)
print(heapq.heappop(heap))   # 1
print(heapq.heappop(heap))   # 2
print(heap[0])               # 5 (peek)

# Heapify จาก list — O(n)
data = [5, 2, 8, 1, 9, 3]
heapq.heapify(data)
print(data)  # [1, 2, 3, 5, 9, 8]

# N largest/smallest
numbers = [1, 5, 3, 8, 2, 9, 4]
print(heapq.nlargest(3, numbers))   # [9, 8, 5]
print(heapq.nsmallest(3, numbers))  # [1, 2, 3]

# Max-heap ด้วยค่าลบ
max_heap = []
for x in [5, 2, 8, 1]:
    heapq.heappush(max_heap, -x)
print(-heapq.heappop(max_heap))  # 8
```

**Priority Queue:**
```python
import heapq
from dataclasses import dataclass, field
from itertools import count

@dataclass(order=True)
class PriorityItem:
    priority: int
    task: str = field(compare=False)

pq: list[PriorityItem] = []
heapq.heappush(pq, PriorityItem(3, "Low priority"))
heapq.heappush(pq, PriorityItem(1, "High priority"))
heapq.heappush(pq, PriorityItem(2, "Medium priority"))

while pq:
    item = heapq.heappop(pq)
    print(f"Processing: {item.task}")
# High priority → Medium → Low
```

**ตัวอย่างการใช้งานจริง — Task Scheduler:**
```python
import heapq
from dataclasses import dataclass, field
from datetime import datetime
from typing import Any

@dataclass(order=True)
class ScheduledTask:
    run_at: float
    task_id: str = field(compare=False)
    func: Any = field(compare=False)

class Scheduler:
    def __init__(self):
        self.tasks: list[ScheduledTask] = []

    def schedule(self, delay: float, task_id: str, func) -> None:
        import time
        run_at = time.time() + delay
        heapq.heappush(self.tasks, ScheduledTask(run_at, task_id, func))

    def run_pending(self) -> int:
        import time
        now = time.time()
        count = 0

        while self.tasks and self.tasks[0].run_at <= now:
            task = heapq.heappop(self.tasks)
            task.func()
            count += 1

        return count
```

**ตัวอย่าง — Merge K Sorted Lists:**
```python
import heapq

def merge_k_sorted(lists: list[list[int]]) -> list[int]:
    """Merge k sorted lists เป็น list เดียว"""
    result = []
    # heap ของ (value, list_index, element_index)
    heap = []

    for i, lst in enumerate(lists):
        if lst:
            heapq.heappush(heap, (lst[0], i, 0))

    while heap:
        value, list_idx, elem_idx = heapq.heappop(heap)
        result.append(value)

        if elem_idx + 1 < len(lists[list_idx]):
            next_val = lists[list_idx][elem_idx + 1]
            heapq.heappush(heap, (next_val, list_idx, elem_idx + 1))

    return result

lists = [
    [1, 4, 7, 10],
    [2, 5, 8, 11],
    [3, 6, 9, 12],
]
print(merge_k_sorted(lists))
# [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
```

**ตัวอย่าง — Top K Frequent Elements:**
```python
import heapq
from collections import Counter

def top_k_frequent(nums: list[int], k: int) -> list[int]:
    """หา k elements ที่พบบ่อยที่สุด"""
    counter = Counter(nums)
    # ใช้ nlargest กับ heap ภายใน
    return heapq.nlargest(k, counter.keys(), key=counter.get)

nums = [1, 1, 1, 2, 2, 3, 4, 4, 4, 4]
print(top_k_frequent(nums, 2))  # [4, 1]
```

**ตัวอย่าง — Median Maintenance:**
```python
import heapq

class MedianFinder:
    """หา median ใน streaming data"""

    def __init__(self):
        self.small: list[int] = []  # max-heap (เก็บค่าลบ)
        self.large: list[int] = []  # min-heap

    def add_num(self, num: int) -> None:
        # เพิ่มใน max-heap ก่อน
        heapq.heappush(self.small, -num)

        # ย้ายค่ามากสุดของ small ไป large
        if self.small and self.large and -self.small[0] > self.large[0]:
            val = -heapq.heappop(self.small)
            heapq.heappush(self.large, val)

        # Balance sizes
        if len(self.small) > len(self.large) + 1:
            val = -heapq.heappop(self.small)
            heapq.heappush(self.large, val)
        if len(self.large) > len(self.small):
            val = heapq.heappop(self.large)
            heapq.heappush(self.small, -val)

    def find_median(self) -> float:
        if len(self.small) == len(self.large):
            return (-self.small[0] + self.large[0]) / 2
        return float(-self.small[0])

# การใช้งาน
mf = MedianFinder()
for x in [1, 2, 3, 4, 5]:
    mf.add_num(x)
    print(f"Median after adding {x}: {mf.find_median()}")
```

### 4.18.4 ข้อดี

- **Priority queue:** O(log n) สำหรับ insert/pop
- **Peek min/max:** O(1)
- **Heap sort:** O(n log n)
- **Memory efficient:** เก็บใน array
- **Dijkstra, Prim:** ใช้ heap

### 4.18.5 ข้อเสีย

- **ไม่มี sorted order:** ต้อง pop ทีละตัว
- **Search O(n):** ไม่เหมาะกับการค้นหา
- **Min-heap only:** heapq ไม่มี max-heap
- **No decrease-key:** ต้อง push ใหม่

### 4.18.6 ข้อควรระวัง

```python
# ระวัง 1: heapq เป็น min-heap เท่านั้น
# ต้องใช้ค่าลบสำหรับ max-heap

# ระวัง 2: การ compare ต้องได้
# ❌ ถ้า items เท่ากันใน field แรก heapq จะ compare field ถัดไป
# ต้อง implement __lt__ ให้ครบ

# ระวัง 3: ค่าติดลบกับ tuple
# ❌ heapq.heappush(heap, (-num, str))  # -num อาจเท่ากัน → compare str
# ✅ ใช้ count เพื่อ tiebreak
counter = count()
heapq.heappush(heap, (-num, next(counter), item))

# ระวัง 4: memory — heap เก็บ reference
# ลบ tasks ที่ยกเลิกด้วย lazy deletion
```

### 4.18.7 สรุป

ใช้ Heap เมื่อ:
- ต้องการ priority queue
- หา k largest/smallest
- Merge sorted lists
- Median maintenance
- Dijkstra/Prim algorithms

> **อ้างอิงเพิ่มเติม:** [heapq Documentation](https://docs.python.org/3/library/heapq.html), [Binary Heap](https://en.wikipedia.org/wiki/Binary_heap)

---

## 4.19 Sorting Algorithms

### บทนำ

Sorting เป็น operation พื้นฐานที่ใช้บ่อยที่สุดในงานจริง Python มี built-in `sorted()` และ `list.sort()` ที่ใช้ Timsort ซึ่งเป็น stable sort ที่มีประสิทธิภาพสูง

### นิยาม

Sorting Algorithm คืออัลกอริทึมที่จัดเรียงข้อมูลตามเกณฑ์ที่กำหนด

### 4.19.1 คืออะไร

อัลกอริทึมเรียงลำดับที่สำคัญ:

| Algorithm | Best | Average | Worst | Stable | Space |
|-----------|------|---------|-------|--------|-------|
| Bubble Sort | O(n) | O(n²) | O(n²) | ✅ | O(1) |
| Selection Sort | O(n²) | O(n²) | O(n²) | ❌ | O(1) |
| Insertion Sort | O(n) | O(n²) | O(n²) | ✅ | O(1) |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | ✅ | O(n) |
| Quick Sort | O(n log n) | O(n log n) | O(n²) | ❌ | O(log n) |
| Heap Sort | O(n log n) | O(n log n) | O(n log n) | ❌ | O(1) |
| Counting Sort | O(n+k) | O(n+k) | O(n+k) | ✅ | O(k) |
| Radix Sort | O(nk) | O(nk) | O(nk) | ✅ | O(n+k) |
| Timsort | O(n) | O(n log n) | O(n log n) | ✅ | O(n) |

### 4.19.2 ทำงานอย่างไร

**Timsort** (ที่ Python ใช้):
- Hybrid ของ Merge Sort และ Insertion Sort
- หา runs (ลำดับที่เรียงแล้ว) แล้ว merge
- ใช้ Insertion Sort สำหรับ runs สั้น
- Performance ดีกับ real-world data

### 4.19.3 การใช้งาน

**Built-in Sorting:**
```python
# sorted() — คืน list ใหม่
numbers = [3, 1, 4, 1, 5, 9, 2, 6]
sorted_nums = sorted(numbers)
print(sorted_nums)  # [1, 1, 2, 3, 4, 5, 6, 9]

# list.sort() — in-place
numbers.sort()
print(numbers)  # [1, 1, 2, 3, 4, 5, 6, 9]

# Reverse
sorted(numbers, reverse=True)

# Key function
words = ["banana", "apple", "cherry", "date"]
sorted(words, key=len)
# ['date', 'apple', 'banana', 'cherry']

# Multiple keys
students = [
    {"name": "Alice", "age": 25, "grade": 85},
    {"name": "Bob", "age": 23, "grade": 92},
    {"name": "Charlie", "age": 25, "grade": 78},
]
sorted(students, key=lambda s: (-s["grade"], s["name"]))
# เรียงตาม grade มากไปน้อย, ถ้าเท่ากันเรียงตาม name

# ใช้ operator
from operator import itemgetter, attrgetter
sorted(students, key=itemgetter("grade"))

# Stable sort — ลำดับเดิมคงไว้เมื่อ key เท่ากัน
data = [("a", 3), ("b", 1), ("c", 3), ("d", 2)]
sorted(data, key=lambda x: x[1])
# [('b', 1), ('d', 2), ('a', 3), ('c', 3)]  ← a ก่อน c (stable)
```

**Bubble Sort (เพื่อการศึกษา):**
```python
def bubble_sort(arr: list) -> list:
    """Bubble sort — O(n²)"""
    n = len(arr)
    result = arr.copy()
    for i in range(n):
        swapped = False
        for j in range(n - i - 1):
            if result[j] > result[j + 1]:
                result[j], result[j + 1] = result[j + 1], result[j]
                swapped = True
        if not swapped:  # optimize: หยุดถ้าเรียงแล้ว
            break
    return result
```

**Insertion Sort:**
```python
def insertion_sort(arr: list) -> list:
    """Insertion sort — O(n²) แต่เร็วกับข้อมูลเล็ก"""
    result = arr.copy()
    for i in range(1, len(result)):
        key = result[i]
        j = i - 1
        while j >= 0 and result[j] > key:
            result[j + 1] = result[j]
            j -= 1
        result[j + 1] = key
    return result
```

**Merge Sort:**
```python
def merge_sort(arr: list) -> list:
    """Merge sort — O(n log n), stable"""
    if len(arr) <= 1:
        return arr

    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])

    return _merge(left, right)

def _merge(left: list, right: list) -> list:
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result
```

**Quick Sort:**
```python
import random

def quick_sort(arr: list) -> list:
    """Quick sort — average O(n log n)"""
    if len(arr) <= 1:
        return arr

    pivot = random.choice(arr)
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]

    return quick_sort(left) + middle + quick_sort(right)
```

**Counting Sort (สำหรับ integers):**
```python
def counting_sort(arr: list[int]) -> list[int]:
    """Counting sort — O(n+k) สำหรับ integers"""
    if not arr:
        return []

    min_val = min(arr)
    max_val = max(arr)
    range_size = max_val - min_val + 1

    count = [0] * range_size
    for x in arr:
        count[x - min_val] += 1

    # Cumulative
    for i in range(1, range_size):
        count[i] += count[i - 1]

    result = [0] * len(arr)
    for x in reversed(arr):
        count[x - min_val] -= 1
        result[count[x - min_val]] = x

    return result
```

**ตัวอย่างการใช้งานจริง — เรียงข้อมูลตามหลายเกณฑ์:**
```python
from dataclasses import dataclass
from datetime import datetime

@dataclass
class Order:
    id: str
    customer: str
    amount: float
    created_at: datetime
    status: str

def sort_orders(orders: list[Order]) -> list[Order]:
    """เรียงตาม: status (pending first) → amount (desc) → created_at"""
    status_priority = {"pending": 0, "processing": 1, "shipped": 2, "done": 3}

    return sorted(
        orders,
        key=lambda o: (
            status_priority.get(o.status, 99),
            -o.amount,
            o.created_at,
        ),
    )
```

**Partial Sorting ด้วย heapq:**
```python
import heapq

# ถ้าต้องการแค่ top 10 จากข้อมูลล้านรายการ
# ❌ sorted() จะ sort ทั้งหมด O(n log n)
# ✅ nlargest ใช้ heap O(n log k)
top_10 = heapq.nlargest(10, huge_list)
```

**ตัวอย่าง — Custom Sort Key:**
```python
from functools import total_ordering

@total_ordering
class Version:
    """Version comparison แบบ semantic versioning"""

    def __init__(self, version_str: str):
        self.parts = tuple(int(x) for x in version_str.split("."))

    def __eq__(self, other):
        return self.parts == other.parts

    def __lt__(self, other):
        return self.parts < other.parts

    def __str__(self):
        return ".".join(str(p) for p in self.parts)

versions = ["1.2.3", "2.0.0", "1.10.0", "1.2.10", "0.9.0"]
sorted_versions = sorted(versions, key=Version)
print(sorted_versions)
# ['0.9.0', '1.2.3', '1.2.10', '1.10.0', '2.0.0']
```

### 4.19.4 ข้อดี (Built-in Sorting)

- **Timsort:** เร็วที่สุดใน practice
- **Stable:** ลำดับเดิมคงไว้
- **Optimized:** เขียนด้วย C
- **Versatile:** รองรับ key function

### 4.19.5 ข้อเสีย

- **O(n log n) เท่านั้น:** comparison-based
- **Memory:** sorted() สร้าง list ใหม่
- **Custom comparison ช้า:** ใช้ key function แทน

### 4.19.6 ข้อควรระวัง

```python
# ระวัง 1: sort() in-place vs sorted() ใหม่
data = [3, 1, 2]
result = data.sort()  # result = None
print(data)           # [1, 2, 3] (แก้ data)

result = sorted(data) # result = [1, 2, 3]
print(data)           # [1, 2, 3] (ไม่แก้)

# ระวัง 2: key function ถูกเรียกครั้งเดียวต่อ element
# ไม่ใช่ทุกครั้งที่ compare (ดีมาก)
sorted(words, key=lambda w: expensive_function(w))

# ระวัง 3: sorting objects ที่ไม่มี __lt__
class Item:
    def __init__(self, value):
        self.value = value

# sorted([Item(1), Item(2)])  # ❌ TypeError
# ✅ ใช้ key
sorted([Item(2), Item(1)], key=lambda i: i.value)

# ระวัง 4: เรียงแล้วไม่ควร sort ซ้ำ — waste
```

### 4.19.7 สรุป

ใช้ `sorted()` หรือ `list.sort()` เสมอ ยกเว้นมีเหตุผลเฉพาะ:
- **Stable sort:** ต้องการรักษาลำดับเดิม
- **Key function:** สำหรับ custom comparison
- **Partial sort:** `heapq.nlargest/nsmallest`
- **Counting sort:** สำหรับ integers ใน range จำกัด

> **อ้างอิงเพิ่มเติม:** [Sorting HOW TO](https://docs.python.org/3/howto/sorting.html), [Timsort](https://en.wikipedia.org/wiki/Timsort)

---

## 4.20 Searching Algorithms

### บทนำ

Searching เป็น operation พื้นฐานที่ใช้ตรวจสอบว่าข้อมูลอยู่ใน collection หรือไม่ หรือหาตำแหน่งของข้อมูล

### นิยาม

Searching Algorithm คืออัลกอริทึมที่หา element ใน collection

### 4.20.1 คืออะไร

**ประเภทหลัก:**
- **Linear Search:** O(n) — ตรวจทุกตัว
- **Binary Search:** O(log n) — ต้องเรียงก่อน
- **Hash-based:** O(1) — ด้วย dict/set

### 4.20.2 ทำงานอย่างไร

**Linear Search:** iterate ทุก element
**Binary Search:** แบ่งครึ่งเรื่อย ๆ
**Hash Search:** คำนวณ hash → index

### 4.20.3 การใช้งาน

**Linear Search:**
```python
def linear_search(arr: list, target) -> int:
    """คืน index หรือ -1"""
    for i, x in enumerate(arr):
        if x == target:
            return i
    return -1

# ใช้ in operator (idiomatic)
if target in arr:
    index = arr.index(target)
```

**Binary Search:**
```python
import bisect

def binary_search(arr: list, target) -> int:
    """ต้องเรียงแล้ว"""
    low, high = 0, len(arr) - 1

    while low <= high:
        mid = (low + high) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1

# ใช้ bisect module
arr = [1, 3, 5, 7, 9, 11]
print(bisect.bisect_left(arr, 5))   # 2 (index ที่ควรแทรกซ้าย)
print(bisect.bisect_right(arr, 5))  # 3 (index ที่ควรแทรกขวา)
print(bisect.bisect_left(arr, 6))   # 3
print(bisect.bisect_left(arr, 0))   # 0

# ตรวจสอบว่ามี
def contains(arr, target):
    i = bisect.bisect_left(arr, target)
    return i < len(arr) and arr[i] == target
```

**ตัวอย่างการใช้งานจริง — Autocomplete:**
```python
import bisect

class Autocomplete:
    def __init__(self, words: list[str]):
        self.words = sorted(set(words))

    def suggest(self, prefix: str, limit: int = 5) -> list[str]:
        """หา words ที่ขึ้นต้นด้วย prefix"""
        index = bisect.bisect_left(self.words, prefix)

        results = []
        for i in range(index, len(self.words)):
            if not self.words[i].startswith(prefix):
                break
            results.append(self.words[i])
            if len(results) >= limit:
                break

        return results

ac = Autocomplete([
    "apple", "application", "apply", "apricot",
    "banana", "band", "bandwidth", "bank",
])

print(ac.suggest("app"))   # ['apple', 'application', 'apply']
print(ac.suggest("ban"))   # ['banana', 'band', 'bandwidth', 'bank']
print(ac.suggest("xyz"))   # []
```

**ตัวอย่าง — Range Search:**
```python
import bisect

def count_in_range(sorted_arr: list, low, high) -> int:
    """นับ elements ในช่วง [low, high]"""
    left = bisect.bisect_left(sorted_arr, low)
    right = bisect.bisect_right(sorted_arr, high)
    return right - left

data = [1, 3, 3, 5, 5, 5, 7, 9, 11]
print(count_in_range(data, 3, 5))  # 5 (3, 3, 5, 5, 5)
print(count_in_range(data, 2, 8))  # 6
```

**ตัวอย่าง — Binary Search on Answer:**
```python
def sqrt_floor(n: int) -> int:
    """หา sqrt(n) แบบ floor โดยใช้ binary search"""
    if n < 2:
        return n

    low, high = 1, n // 2
    result = 1

    while low <= high:
        mid = (low + high) // 2
        if mid * mid <= n:
            result = mid
            low = mid + 1
        else:
            high = mid - 1

    return result

print(sqrt_floor(16))   # 4
print(sqrt_floor(17))   # 4
print(sqrt_floor(100))  # 10
```

**ตัวอย่าง — Searching in Complex Data:**
```python
import bisect
from dataclasses import dataclass
from datetime import datetime

@dataclass(order=True)
class Event:
    timestamp: datetime
    name: str

class EventLog:
    def __init__(self):
        self.events: list[Event] = []

    def add(self, event: Event) -> None:
        # เพิ่มแบบรักษาลำดับ (insertion sort)
        bisect.insort(self.events, event)

    def events_between(
        self,
        start: datetime,
        end: datetime,
    ) -> list[Event]:
        """หา events ในช่วงเวลา"""
        start_idx = bisect.bisect_left(
            self.events,
            Event(start, ""),
        )
        end_idx = bisect.bisect_right(
            self.events,
            Event(end, "\uffff"),  # ใช้ \uffff เพื่อให้ end รวมอยู่ด้วย
        )
        return self.events[start_idx:end_idx]
```

### 4.20.4 ข้อดี

- **Linear:** ใช้กับ unsorted data ได้
- **Binary:** เร็วมาก O(log n)
- **Hash:** เร็วที่สุด O(1)
- **bisect:** built-in module

### 4.20.5 ข้อเสีย

- **Linear:** ช้าสำหรับข้อมูลเยอะ
- **Binary:** ต้อง sort ก่อน (O(n log n))
- **Hash:** ต้อง hashable, ไม่เรียงลำดับ

### 4.20.6 ข้อควรระวัง

```python
# ระวัง 1: Binary search บน unsorted data
# ❌ ผลลัพธ์ผิด
unsorted = [3, 1, 4, 1, 5]
# binary_search(unsorted, 4)  # ไม่การันตี

# ✅ sort ก่อน
sorted_data = sorted(unsorted)

# ระวัง 2: bisect_left vs bisect_right
# สำหรับ duplicates
arr = [1, 2, 2, 2, 3]
print(bisect.bisect_left(arr, 2))   # 1
print(bisect.bisect_right(arr, 2))  # 4

# ระวัง 3: ใช้ `in` กับ list เป็น O(n)
# ❌ ช้า
if x in huge_list:  # O(n)

# ✅ ใช้ set
if x in huge_set:  # O(1)

# ระวัง 4: Hash search ต้องการ hashable
# ใช้ set สำหรับ membership, dict สำหรับ lookup
```

### 4.20.7 สรุป

เลือก Searching Algorithm:
- **Unsorted data:** Linear search
- **Sorted data, search บ่อย:** Binary search / bisect
- **Membership check:** set / dict
- **Range search:** bisect
- **String prefix:** trie หรือ bisect

> **อ้างอิงเพิ่มเติม:** [bisect Documentation](https://docs.python.org/3/library/bisect.html)

---

## 4.21 Recursion และ Backtracking

### บทนำ

Recursion เป็นเทคนิคที่ฟังก์ชันเรียกตัวเอง ใช้แก้ปัญหาที่แบ่งเป็นปัญหาย่อยได้ Backtracking เป็นการประยุกต์ recursion เพื่อค้นหา solutions โดยลองทุกทางและย้อนกลับเมื่อไม่สำเร็จ

### นิยาม

- **Recursion:** ฟังก์ชันเรียกตัวเอง
- **Backtracking:** ลองทุกทางเลือกและย้อนกลับ (undo) เมื่อไม่สำเร็จ

### 4.21.1 คืออะไร

**Recursion ประกอบด้วย:**
- **Base case:** เงื่อนไขหยุด
- **Recursive case:** เรียกตัวเองกับ input ที่เล็กกว่า

**Backtracking เหมาะกับ:**
- N-Queens
- Sudoku Solver
- Maze solving
- Permutations/Combinations
- Subset sum

### 4.21.2 ทำงานอย่างไร

Recursion ใช้ call stack แต่ละ call มี frame ของตัวเอง Python มี default limit 1000

Backtracking ทำตาม pattern:
```
1. เลือก (choose)
2. สำรวจ (explore)
3. ยกเลิก (un-choose)
```

### 4.21.3 การใช้งาน

**Recursion พื้นฐาน:**
```python
# Factorial
def factorial(n: int) -> int:
    if n <= 1:
        return 1
    return n * factorial(n - 1)

# Binary search (recursive)
def binary_search_recursive(arr, target, low=0, high=None):
    if high is None:
        high = len(arr) - 1

    if low > high:
        return -1

    mid = (low + high) // 2
    if arr[mid] == target:
        return mid
    elif arr[mid] < target:
        return binary_search_recursive(arr, target, mid + 1, high)
    else:
        return binary_search_recursive(arr, target, low, mid - 1)
```

**Backtracking — N-Queens:**
```python
def solve_n_queens(n: int) -> list[list[str]]:
    """แก้ปัญหา N-Queens"""
    solutions = []
    board = [["."] * n for _ in range(n)]

    def is_safe(row: int, col: int) -> bool:
        # เช็คคอลัมน์
        for i in range(row):
            if board[i][col] == "Q":
                return False

        # เช็ค diagonals
        for i, j in zip(range(row - 1, -1, -1), range(col - 1, -1, -1)):
            if board[i][j] == "Q":
                return False
        for i, j in zip(range(row - 1, -1, -1), range(col + 1, n)):
            if board[i][j] == "Q":
                return False

        return True

    def backtrack(row: int) -> None:
        if row == n:
            solutions.append(["".join(r) for r in board])
            return

        for col in range(n):
            if is_safe(row, col):
                board[row][col] = "Q"      # choose
                backtrack(row + 1)         # explore
                board[row][col] = "."      # un-choose

    backtrack(0)
    return solutions

solutions = solve_n_queens(4)
print(f"พบ {len(solutions)} solutions")
for sol in solutions:
    for row in sol:
        print(row)
    print()
```

**Backtracking — Sudoku Solver:**
```python
def solve_sudoku(board: list[list[str]]) -> bool:
    """แก้ Sudoku"""

    def is_valid(row: int, col: int, num: str) -> bool:
        # เช็ค row
        if num in board[row]:
            return False

        # เช็ค column
        if any(board[i][col] == num for i in range(9)):
            return False

        # เช็ค 3x3 box
        box_r, box_c = 3 * (row // 3), 3 * (col // 3)
        for i in range(box_r, box_r + 3):
            for j in range(box_c, box_c + 3):
                if board[i][j] == num:
                    return False
        return True

    def backtrack() -> bool:
        for i in range(9):
            for j in range(9):
                if board[i][j] == ".":
                    for num in "123456789":
                        if is_valid(i, j, num):
                            board[i][j] = num      # choose
                            if backtrack():         # explore
                                return True
                            board[i][j] = "."      # un-choose
                    return False
        return True

    return backtrack()
```

**Backtracking — Permutations:**
```python
def permutations(nums: list[int]) -> list[list[int]]:
    """สร้าง permutations ทั้งหมด"""
    result = []
    used = [False] * len(nums)
    current = []

    def backtrack():
        if len(current) == len(nums):
            result.append(current.copy())
            return

        for i in range(len(nums)):
            if used[i]:
                continue
            used[i] = True
            current.append(nums[i])
            backtrack()
            current.pop()
            used[i] = False

    backtrack()
    return result

print(permutations([1, 2, 3]))
# [[1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], [3,2,1]]
```

**Backtracking — Combination Sum:**
```python
def combination_sum(candidates: list[int], target: int) -> list[list[int]]:
    """หา combinations ที่รวมได้ target"""
    result = []
    candidates.sort()

    def backtrack(start: int, current: list[int], remaining: int):
        if remaining == 0:
            result.append(current.copy())
            return
        if remaining < 0:
            return

        for i in range(start, len(candidates)):
            # Prune: ถ้า candidate เกิน remaining ให้หยุด
            if candidates[i] > remaining:
                break

            current.append(candidates[i])
            # ใช้ i (ไม่ใช่ i+1) เพราะใช้ซ้ำได้
            backtrack(i, current, remaining - candidates[i])
            current.pop()

    backtrack(0, [], target)
    return result

print(combination_sum([2, 3, 6, 7], 7))
# [[2, 2, 3], [7]]
```

**ตัวอย่างการใช้งานจริง — File System Search:**
```python
from pathlib import Path
from typing import Iterator

def find_files_recursive(
    root: str,
    pattern: str,
    max_depth: int | None = None,
) -> Iterator[Path]:
    """ค้นหาไฟล์แบบ recursive"""
    root_path = Path(root)

    def search(path: Path, depth: int) -> Iterator[Path]:
        if max_depth is not None and depth > max_depth:
            return

        try:
            for item in path.iterdir():
                if item.is_file() and item.match(pattern):
                    yield item
                elif item.is_dir():
                    yield from search(item, depth + 1)
        except PermissionError:
            return

    yield from search(root_path, 0)

# การใช้งาน
for f in find_files_recursive(".", "*.py", max_depth=3):
    print(f)
```

**Memoization สำหรับ Recursion:**
```python
from functools import lru_cache

@lru_cache(maxsize=None)
def fib(n: int) -> int:
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)

# ไม่มี cache: O(2^n)
# มี cache: O(n)

# สำหรับ state ที่ hashable ไม่ได้ ใช้ dict เอง
def edit_distance(s1: str, s2: str) -> int:
    """Levenshtein distance"""
    memo: dict[tuple[int, int], int] = {}

    def helper(i: int, j: int) -> int:
        if (i, j) in memo:
            return memo[(i, j)]

        if i == 0:
            return j
        if j == 0:
            return i

        if s1[i - 1] == s2[j - 1]:
            result = helper(i - 1, j - 1)
        else:
            result = 1 + min(
                helper(i - 1, j),      # delete
                helper(i, j - 1),      # insert
                helper(i - 1, j - 1),  # replace
            )

        memo[(i, j)] = result
        return result

    return helper(len(s1), len(s2))

print(edit_distance("kitten", "sitting"))  # 3
```

### 4.21.4 ข้อดี

- **Elegant:** โค้ดสั้นและอ่านง่าย
- **Natural:** เหมาะกับ problems ที่ recursive
- **Backtracking:** แก้ constraint satisfaction
- **Divide & Conquer:** merge sort, quick sort

### 4.21.5 ข้อเสีย

- **Stack overflow:** Python limit 1000
- **ช้ากว่า iteration:** function call overhead
- **Memory:** ใช้ stack
- **อาจ redundant:** ถ้าไม่มี memoization

### 4.21.6 ข้อควรระวัง

```python
# ระวัง 1: ลืม base case → infinite recursion
def bad(n):
    return bad(n - 1)  # ❌ ไม่มี base case

# ระวัง 2: Recursion depth
def deep(n):
    if n == 0:
        return 0
    return 1 + deep(n - 1)

# deep(2000)  # ❌ RecursionError
# ✅ เพิ่ม limit (ระวัง stack overflow)
import sys
sys.setrecursionlimit(10000)

# ระวัง 3: mutable default argument
# ❌ buggy
def bad_backtrack(path=[]):
    path.append(1)
    bad_backtrack(path)

# ✅ ใช้ None
def good_backtrack(path=None):
    if path is None:
        path = []

# ระวัง 4: ต้อง un-choose ให้ครบ
def backtrack(path, choices):
    for choice in choices:
        path.append(choice)     # choose
        backtrack(path, choices)  # explore
        path.pop()              # un-choose ← สำคัญ!
```

### 4.21.7 สรุป

ใช้ Recursion เมื่อ:
- Problem มีโครงสร้าง recursive (tree, graph)
- Divide & Conquer
- Backtracking problems
- Code สั้นกว่า iteration มาก

ใช้ Iteration เมื่อ:
- Depth สูง (> 1000)
- Performance critical
- Simple loops

> **อ้างอิงเพิ่มเติม:** [sys.setrecursionlimit](https://docs.python.org/3/library/sys.html#sys.setrecursionlimit), [functools.lru_cache](https://docs.python.org/3/library/functools.html#functools.lru_cache)

---

## 4.22 Dynamic Programming

### บทนำ

Dynamic Programming (DP) เป็นเทคนิคแก้ปัญหาที่ซับซ้อนโดยแบ่งเป็นปัญหาย่อยที่ทับซ้อนกัน (overlapping subproblems) และเก็บผลลัพธ์ไว้ใช้ซ้ำ

### นิยาม

DP ใช้เมื่อปัญหา:
- **Optimal substructure:** optimal solution สร้างจาก optimal solutions ของ subproblems
- **Overlapping subproblems:** subproblems ถูกใช้ซ้ำ

### 4.22.1 คืออะไร

**2 รูปแบบหลัก:**
- **Top-down (Memoization):** recursion + cache
- **Bottom-up (Tabulation):** สร้าง table จาก base cases

### 4.22.2 ทำงานอย่างไร

**Top-down:** เริ่มจากปัญหาใหญ่ แบ่งเป็น subproblems เก็บผลใน cache
**Bottom-up:** เริ่มจาก subproblems เล็ก ๆ สร้างขึ้นมา

### 4.22.3 การใช้งาน

**Fibonacci — เปรียบเทียบวิธี:**
```python
# 1. Naive recursion — O(2^n)
def fib_naive(n):
    if n <= 1:
        return n
    return fib_naive(n-1) + fib_naive(n-2)

# 2. Top-down (memoization) — O(n)
from functools import lru_cache

@lru_cache(maxsize=None)
def fib_memo(n):
    if n <= 1:
        return n
    return fib_memo(n-1) + fib_memo(n-2)

# 3. Bottom-up (tabulation) — O(n) time, O(n) space
def fib_tab(n):
    if n <= 1:
        return n
    dp = [0] * (n + 1)
    dp[1] = 1
    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    return dp[n]

# 4. Space-optimized — O(n) time, O(1) space
def fib_opt(n):
    if n <= 1:
        return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b
```

**Classic DP — Coin Change:**
```python
def coin_change(coins: list[int], amount: int) -> int:
    """หาจำนวนเหรียญน้อยที่สุดที่รวมได้ amount"""
    # dp[i] = จำนวนเหรียญน้อยสุดที่รวมได้ i
    dp = [float("inf")] * (amount + 1)
    dp[0] = 0

    for i in range(1, amount + 1):
        for coin in coins:
            if coin <= i:
                dp[i] = min(dp[i], dp[i - coin] + 1)

    return dp[amount] if dp[amount] != float("inf") else -1

print(coin_change([1, 5, 10, 25], 63))  # 6 (25+25+10+1+1+1)
print(coin_change([2], 3))               # -1
```

**Longest Common Subsequence:**
```python
def lcs(s1: str, s2: str) -> int:
    """ความยาว LCS"""
    m, n = len(s1), len(s2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])

    return dp[m][n]

def lcs_string(s1: str, s2: str) -> str:
    """คืน LCS string"""
    m, n = len(s1), len(s2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])

    # Backtrack
    result = []
    i, j = m, n
    while i > 0 and j > 0:
        if s1[i-1] == s2[j-1]:
            result.append(s1[i-1])
            i -= 1
            j -= 1
        elif dp[i-1][j] > dp[i][j-1]:
            i -= 1
        else:
            j -= 1

    return "".join(reversed(result))

print(lcs("ABCDGH", "AEDFHR"))              # 3
print(lcs_string("ABCDGH", "AEDFHR"))       # ADH
```

**Knapsack Problem:**
```python
def knapsack(weights: list[int], values: list[int], capacity: int) -> int:
    """0/1 Knapsack — มูลค่าสูงสุด"""
    n = len(weights)
    dp = [[0] * (capacity + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        w, v = weights[i-1], values[i-1]
        for cap in range(capacity + 1):
            # ไม่เลือก item i
            dp[i][cap] = dp[i-1][cap]
            # เลือก item i ถ้าใส่ได้
            if w <= cap:
                dp[i][cap] = max(dp[i][cap], dp[i-1][cap - w] + v)

    return dp[n][capacity]

weights = [2, 3, 4, 5]
values = [3, 4, 5, 6]
capacity = 5
print(knapsack(weights, values, capacity))  # 7 (item 1+2)
```

**Edit Distance:**
```python
def edit_distance(s1: str, s2: str) -> int:
    """Levenshtein distance (bottom-up)"""
    m, n = len(s1), len(s2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    # Base cases
    for i in range(m + 1):
        dp[i][0] = i
    for j in range(n + 1):
        dp[0][j] = j

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1]
            else:
                dp[i][j] = 1 + min(
                    dp[i-1][j],      # delete
                    dp[i][j-1],      # insert
                    dp[i-1][j-1],    # replace
                )

    return dp[m][n]

print(edit_distance("kitten", "sitting"))  # 3
print(edit_distance("sunday", "saturday")) # 3
```

**ตัวอย่างการใช้งานจริง — Word Break:**
```python
def word_break(s: str, word_dict: list[str]) -> bool:
    """ตรวจสอบว่า s แบ่งเป็นคำใน dict ได้หรือไม่"""
    word_set = set(word_dict)
    n = len(s)
    dp = [False] * (n + 1)
    dp[0] = True

    for i in range(1, n + 1):
        for j in range(i):
            if dp[j] and s[j:i] in word_set:
                dp[i] = True
                break

    return dp[n]

print(word_break("leetcode", ["leet", "code"]))         # True
print(word_break("applepenapple", ["apple", "pen"]))    # True
print(word_break("catsandog", ["cats", "dog", "sand", "and", "cat"]))  # False
```

**ตัวอย่าง — Maximum Subarray (Kadane):**
```python
def max_subarray(nums: list[int]) -> int:
    """หาผลรวม subarray สูงสุด (Kadane's algorithm)"""
    max_ending = max_so_far = nums[0]

    for x in nums[1:]:
        max_ending = max(x, max_ending + x)
        max_so_far = max(max_so_far, max_ending)

    return max_so_far

print(max_subarray([-2, 1, -3, 4, -1, 2, 1, -5, 4]))  # 6
# subarray [4, -1, 2, 1] = 6
```

### 4.22.4 ข้อดี

- **เร็วกว่า brute force มาก:** ลด exponential เป็น polynomial
- **แก้ปัญหายากได้:** เช่น TSP, knapsack
- **Optimal solution:** การันตีคำตอบที่ดีที่สุด
- **ใช้ใน competitive programming**

### 4.22.5 ข้อเสีย

- **ต้องเข้าใจปัญหา:** ระบุ state และ transition
- **Memory:** อาจกิน RAM มาก (2D tables)
- **ไม่เหมาะกับทุกปัญหา:** ต้องมี optimal substructure

### 4.22.6 ข้อควรระวัง

```python
# ระวัง 1: State definition ผิด
# ต้องชัดเจนว่า dp[i] แทนอะไร

# ระวัง 2: Base cases
# ลืมหรือผิด base case → ผลลัพธ์ผิดทั้งหมด

# ระวัง 3: Iteration order
# Bottom-up ต้อง fill ในลำดับที่ถูกต้อง

# ระวัง 4: Memory optimization
# บางปัญหาลด dimension ได้
# เช่น LCS ใช้แค่ 2 rows แทน m*n

def lcs_optimized(s1, s2):
    m, n = len(s1), len(s2)
    prev = [0] * (n + 1)
    curr = [0] * (n + 1)

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s1[i-1] == s2[j-1]:
                curr[j] = prev[j-1] + 1
            else:
                curr[j] = max(prev[j], curr[j-1])
        prev, curr = curr, prev

    return prev[n]  # O(n) space แทน O(m*n)
```

### 4.22.7 สรุป

ใช้ DP เมื่อ:
- Problem มี optimal substructure
- มี overlapping subproblems
- Brute force เป็น exponential
- ต้องการ optimal solution

**ขั้นตอน:**
1. ระบุ state: `dp[i]` แทนอะไร
2. หา recurrence relation
3. กำหนด base cases
4. เลือกลำดับ (top-down/bottom-up)
5. Optimize memory ถ้าจำเป็น

> **อ้างอิงเพิ่มเติม:** [Dynamic Programming](https://en.wikipedia.org/wiki/Dynamic_programming)

---

## 4.23 Greedy Algorithm

### บทนำ

Greedy Algorithm เป็นวิธีการแก้ปัญหาที่เลือกทางที่ดีที่สุด ณ ขณะนั้น (local optimum) โดยหวังว่าจะนำไปสู่คำตอบที่ดีที่สุด (global optimum) ใช้ได้กับปัญหาที่มี greedy choice property

### นิยาม

Greedy Algorithm สร้าง solution ทีละขั้น โดยแต่ละขั้นเลือกสิ่งที่ดีที่สุดในขณะนั้นโดยไม่ย้อนกลับ

### 4.23.1 คืออะไร

**ใช้ได้เมื่อ:**
- **Greedy choice property:** local optimal → global optimal
- **Optimal substructure:** optimal solution มี optimal subsolutions

**ไม่ใช้ได้เมื่อ:** ต้องการการพิจารณาย้อนหลัง (เช่น knapsack 0/1)

### 4.23.2 ทำงานอย่างไร

Greedy Algorithm ทำตาม pattern:
```
1. เรียงข้อมูลตามเกณฑ์
2. เลือกที่ดีที่สุดในขณะนั้น
3. ตรวจสอบว่ายัง satisfy constraints
4. ทำซ้ำจนได้คำตอบ
```

### 4.23.3 การใช้งาน

**Activity Selection:**
```python
def max_activities(activities: list[tuple[int, int]]) -> list[tuple[int, int]]:
    """เลือก activities สูงสุดที่ไม่ทับกัน (start, end)"""
    # เรียงตามเวลาจบ
    sorted_acts = sorted(activities, key=lambda x: x[1])

    result = []
    last_end = 0

    for start, end in sorted_acts:
        if start >= last_end:
            result.append((start, end))
            last_end = end

    return result

activities = [(1, 4), (3, 5), (0, 6), (5, 7), (3, 9), (5, 9), (6, 10)]
print(max_activities(activities))
# [(1, 4), (5, 7), (6, 10)] — 3 activities
```

**Coin Change (Greedy):**
```python
def coin_change_greedy(coins: list[int], amount: int) -> list[int]:
    """Coin change แบบ greedy
    ⚠️ ใช้ได้เฉพาะเมื่อ coin system เป็น canonical
    """
    coins = sorted(coins, reverse=True)
    result = []

    for coin in coins:
        while amount >= coin:
            result.append(coin)
            amount -= coin

    return result if amount == 0 else []

# ใช้ได้กับ US coins
print(coin_change_greedy([25, 10, 5, 1], 63))
# [25, 25, 10, 1, 1, 1] — 6 coins ✅

# ❌ ใช้ไม่ได้กับ coin system ที่ไม่ canonical
print(coin_change_greedy([4, 3, 1], 6))
# [4, 1, 1] — 3 coins
# ✅ Optimal: [3, 3] — 2 coins
```

**Fractional Knapsack:**
```python
def fractional_knapsack(
    items: list[tuple[float, float]],  # (weight, value)
    capacity: float,
) -> float:
    """Fractional knapsack — เอาได้บางส่วน"""
    # เรียงตาม value/weight ratio
    items_sorted = sorted(
        items,
        key=lambda x: x[1] / x[0],
        reverse=True,
    )

    total_value = 0.0
    for weight, value in items_sorted:
        if capacity >= weight:
            total_value += value
            capacity -= weight
        else:
            # เอาส่วนที่เหลือ
            total_value += value * (capacity / weight)
            break

    return total_value

items = [(10, 60), (20, 100), (30, 120)]
print(fractional_knapsack(items, 50))  # 240.0
```

**Huffman Coding:**
```python
import heapq
from collections import Counter

class HuffmanNode:
    def __init__(self, char: str | None, freq: int):
        self.char = char
        self.freq = freq
        self.left: HuffmanNode | None = None
        self.right: HuffmanNode | None = None

    def __lt__(self, other):
        return self.freq < other.freq

def build_huffman_tree(text: str) -> HuffmanNode:
    """สร้าง Huffman tree"""
    freq = Counter(text)
    heap = [HuffmanNode(char, count) for char, count in freq.items()]
    heapq.heapify(heap)

    while len(heap) > 1:
        left = heapq.heappop(heap)
        right = heapq.heappop(heap)

        parent = HuffmanNode(None, left.freq + right.freq)
        parent.left = left
        parent.right = right
        heapq.heappush(heap, parent)

    return heap[0]

def build_codes(node: HuffmanNode, prefix: str = "") -> dict[str, str]:
    """สร้าง Huffman codes"""
    codes = {}
    if node.char is not None:
        codes[node.char] = prefix or "0"
    else:
        codes.update(build_codes(node.left, prefix + "0"))
        codes.update(build_codes(node.right, prefix + "1"))
    return codes

text = "this is an example of a huffman tree"
tree = build_huffman_tree(text)
codes = build_codes(tree)

for char, code in sorted(codes.items(), key=lambda x: len(x[1])):
    print(f"'{char}': {code}")
```

**Interval Scheduling / Merge Intervals:**
```python
def merge_intervals(intervals: list[list[int]]) -> list[list[int]]:
    """รวม intervals ที่ทับกัน"""
    if not intervals:
        return []

    sorted_intervals = sorted(intervals, key=lambda x: x[0])
    merged = [sorted_intervals[0]]

    for start, end in sorted_intervals[1:]:
        if start <= merged[-1][1]:
            merged[-1][1] = max(merged[-1][1], end)
        else:
            merged.append([start, end])

    return merged

print(merge_intervals([[1,3], [2,6], [8,10], [15,18]]))
# [[1, 6], [8, 10], [15, 18]]
```

**Gas Station:**
```python
def can_complete_circuit(gas: list[int], cost: list[int]) -> int:
    """หาจุดเริ่มที่วิ่งได้ครบวง"""
    if sum(gas) < sum(cost):
        return -1

    start = 0
    tank = 0
    total = 0

    for i in range(len(gas)):
        tank += gas[i] - cost[i]
        total += gas[i] - cost[i]

        if tank < 0:
            start = i + 1
            tank = 0

    return start if total >= 0 else -1

gas = [1, 2, 3, 4, 5]
cost = [3, 4, 5, 1, 2]
print(can_complete_circuit(gas, cost))  # 3
```

**ตัวอย่างการใช้งานจริง — Task Scheduling with Deadlines:**
```python
def schedule_tasks(
    tasks: list[tuple[str, int, int]],  # (name, deadline, profit)
) -> tuple[list[str], int]:
    """เลือก tasks ที่ให้ profit สูงสุดภายใน deadline"""
    # เรียงตาม profit มากไปน้อย
    sorted_tasks = sorted(tasks, key=lambda x: x[2], reverse=True)

    max_deadline = max(t[1] for t in tasks)
    slots: list[str | None] = [None] * max_deadline

    total_profit = 0
    scheduled = []

    for name, deadline, profit in sorted_tasks:
        # หา slot ว่างก่อน deadline (จากท้ายสุด)
        for i in range(min(deadline, max_deadline) - 1, -1, -1):
            if slots[i] is None:
                slots[i] = name
                scheduled.append(name)
                total_profit += profit
                break

    return scheduled, total_profit

tasks = [
    ("A", 2, 100),
    ("B", 1, 19),
    ("C", 2, 27),
    ("D", 1, 25),
    ("E", 3, 15),
]
print(schedule_tasks(tasks))
# (['C', 'A', 'E'], 142)
```

### 4.23.4 ข้อดี

- **ง่าย:** เข้าใจและ implement ง่าย
- **เร็ว:** มักเป็น O(n log n) หรือเร็วกว่า
- **มีประสิทธิภาพ:** สำหรับปัญหาที่เหมาะ

### 4.23.5 ข้อเสีย

- **ไม่การันตี optimal:** ในทุกปัญหา
- **ต้องพิสูจน์:** ว่า greedy choice ถูกต้อง
- **ใช้ได้จำกัด:** เฉพาะปัญหาที่มี greedy property

### 4.23.6 ข้อควรระวัง

```python
# ระวัง 1: Greedy ไม่ใช่คำตอบ optimal เสมอ
# Coin change กับ [4, 3, 1] amount=6:
# Greedy: [4, 1, 1] = 3 coins
# Optimal: [3, 3] = 2 coins

# ระวัง 2: ต้องพิสูจน์ greedy choice
# ใช้ exchange argument:
# - สมมติว่า optimal solution ไม่ใช้ greedy choice
# - แสดงว่าสลับได้โดยไม่แย่ลง

# ระวัง 3: เรียงลำดับสำคัญ
# Activity selection: เรียงตาม end time (ไม่ใช่ start)
# Fractional knapsack: เรียงตาม value/weight ratio
```

### 4.23.7 สรุป

ใช้ Greedy เมื่อ:
- Problem มี greedy choice property
- Local optimal → global optimal
- ต้องการคำตอบเร็ว
- พิสูจน์ได้ว่าถูกต้อง

**ตัวอย่างปัญหาที่ใช้ Greedy:**
- Activity selection
- Fractional knapsack
- Huffman coding
- Dijkstra's algorithm
- Minimum spanning tree (Prim, Kruskal)
- Interval scheduling

> **อ้างอิงเพิ่มเติม:** [Greedy Algorithm](https://en.wikipedia.org/wiki/Greedy_algorithm)

---

## 4.24 Graph Algorithm

### บทนำ

Graph algorithms เป็นเครื่องมือสำคัญในการแก้ปัญหาที่เกี่ยวกับความสัมพันธ์ ตั้งแต่ shortest path ไปจนถึง minimum spanning tree

### นิยาม

Graph Algorithm คืออัลกอริทึมที่ทำงานกับ graph structures เพื่อแก้ปัญหาเช่น การหา path, connectivity, flow

### 4.24.1 คืออะไร

อัลกอริทึมที่สำคัญ:

| Algorithm | ใช้กับ | Time |
|-----------|--------|------|
| BFS | Unweighted shortest path | O(V + E) |
| DFS | Traversal, cycle detection | O(V + E) |
| Dijkstra | Weighted shortest path (non-neg) | O((V+E) log V) |
| Bellman-Ford | Shortest path with neg weights | O(V*E) |
| Floyd-Warshall | All-pairs shortest path | O(V³) |
| Prim | Minimum Spanning Tree | O((V+E) log V) |
| Kruskal | Minimum Spanning Tree | O(E log E) |
| Topological Sort | DAG ordering | O(V + E) |
| Union-Find | Connected components | ~O(α(n)) |

### 4.24.2 ทำงานอย่างไร

แต่ละอัลกอริทึมเหมาะกับปัญหาต่างกัน:
- **BFS:** ใช้ queue ไล่ทีละระดับ
- **DFS:** ใช้ stack/recursion ไล่ลึก
- **Dijkstra:** greedy + priority queue
- **Bellman-Ford:** relax edges V-1 ครั้ง
- **Floyd-Warshall:** DP บน matrix

### 4.24.3 การใช้งาน

**Union-Find (Disjoint Set Union):**
```python
class UnionFind:
    def __init__(self, n: int):
        self.parent = list(range(n))
        self.rank = [0] * n
        self.components = n

    def find(self, x: int) -> int:
        """Path compression"""
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x: int, y: int) -> bool:
        """Union by rank"""
        rx, ry = self.find(x), self.find(y)
        if rx == ry:
            return False

        if self.rank[rx] < self.rank[ry]:
            rx, ry = ry, rx
        self.parent[ry] = rx
        if self.rank[rx] == self.rank[ry]:
            self.rank[rx] += 1

        self.components -= 1
        return True

    def connected(self, x: int, y: int) -> bool:
        return self.find(x) == self.find(y)

# การใช้งาน
uf = UnionFind(10)
uf.union(1, 2)
uf.union(3, 4)
uf.union(2, 3)
print(uf.connected(1, 4))  # True
print(uf.connected(1, 5))  # False
```

**Minimum Spanning Tree — Kruskal:**
```python
def kruskal_mst(
    n: int,
    edges: list[tuple[int, int, float]],
) -> tuple[list[tuple[int, int, float]], float]:
    """Kruskal's MST algorithm"""
    # เรียง edges ตาม weight
    sorted_edges = sorted(edges, key=lambda x: x[2])
    uf = UnionFind(n)

    mst = []
    total_weight = 0.0

    for u, v, w in sorted_edges:
        if uf.union(u, v):
            mst.append((u, v, w))
            total_weight += w
            if len(mst) == n - 1:
                break

    return mst, total_weight

edges = [
    (0, 1, 4), (0, 7, 8), (1, 2, 8), (1, 7, 11),
    (2, 3, 7), (2, 8, 2), (2, 5, 4), (3, 4, 9),
    (3, 5, 14), (4, 5, 10), (5, 6, 2), (6, 7, 1),
    (6, 8, 6), (7, 8, 7),
]

mst, total = kruskal_mst(9, edges)
print(f"MST edges: {len(mst)}, weight: {total}")
```

**Bellman-Ford (Shortest Path with Negative Weights):**
```python
def bellman_ford(
    n: int,
    edges: list[tuple[int, int, float]],
    start: int,
) -> tuple[list[float], bool]:
    """คืน (distances, has_negative_cycle)"""
    INF = float("inf")
    dist = [INF] * n
    dist[start] = 0

    # Relax edges V-1 ครั้ง
    for _ in range(n - 1):
        updated = False
        for u, v, w in edges:
            if dist[u] != INF and dist[u] + w < dist[v]:
                dist[v] = dist[u] + w
                updated = True
        if not updated:
            break

    # ตรวจสอบ negative cycle
    has_negative_cycle = False
    for u, v, w in edges:
        if dist[u] != INF and dist[u] + w < dist[v]:
            has_negative_cycle = True
            break

    return dist, has_negative_cycle
```

**Floyd-Warshall (All-Pairs Shortest Path):**
```python
def floyd_warshall(
    n: int,
    edges: list[tuple[int, int, float]],
) -> list[list[float]]:
    """คืน distance matrix"""
    INF = float("inf")
    dist = [[INF] * n for _ in range(n)]

    for i in range(n):
        dist[i][i] = 0

    for u, v, w in edges:
        dist[u][v] = min(dist[u][v], w)

    for k in range(n):
        for i in range(n):
            for j in range(n):
                if dist[i][k] + dist[k][j] < dist[i][j]:
                    dist[i][j] = dist[i][k] + dist[k][j]

    return dist
```

**Topological Sort:**
```python
from collections import deque

def topological_sort_dfs(graph: dict) -> list:
    """Topological sort ด้วย DFS"""
    visited = set()
    result = []

    def dfs(node):
        visited.add(node)
        for neighbor in graph.get(node, []):
            if neighbor not in visited:
                dfs(neighbor)
        result.append(node)

    for node in graph:
        if node not in visited:
            dfs(node)

    return result[::-1]

def topological_sort_kahn(graph: dict) -> list:
    """Topological sort ด้วย Kahn's algorithm (BFS)"""
    in_degree = {node: 0 for node in graph}
    for neighbors in graph.values():
        for n in neighbors:
            in_degree[n] = in_degree.get(n, 0) + 1

    queue = deque([n for n, d in in_degree.items() if d == 0])
    result = []

    while queue:
        node = queue.popleft()
        result.append(node)
        for neighbor in graph.get(node, []):
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0:
                queue.append(neighbor)

    if len(result) != len(in_degree):
        raise ValueError("Graph has cycle")

    return result
```

**ตัวอย่างการใช้งานจริง — Network Routing:**
```python
import heapq
from dataclasses import dataclass, field

@dataclass
class Router:
    """Router ใน network"""
    name: str
    neighbors: dict[str, float] = field(default_factory=dict)

class Network:
    def __init__(self):
        self.routers: dict[str, Router] = {}

    def add_router(self, name: str) -> Router:
        router = Router(name)
        self.routers[name] = router
        return router

    def add_link(self, a: str, b: str, latency: float) -> None:
        self.routers[a].neighbors[b] = latency
        self.routers[b].neighbors[a] = latency

    def shortest_path(
        self,
        src: str,
        dst: str,
    ) -> tuple[list[str], float]:
        """Dijkstra หา path ที่ latency ต่ำสุด"""
        distances = {name: float("inf") for name in self.routers}
        distances[src] = 0
        previous: dict[str, str | None] = {src: None}
        pq = [(0, src)]

        while pq:
            current_dist, current = heapq.heappop(pq)

            if current == dst:
                break

            if current_dist > distances[current]:
                continue

            for neighbor, latency in self.routers[current].neighbors.items():
                distance = current_dist + latency
                if distance < distances[neighbor]:
                    distances[neighbor] = distance
                    previous[neighbor] = current
                    heapq.heappush(pq, (distance, neighbor))

        # Reconstruct path
        if distances[dst] == float("inf"):
            return [], float("inf")

        path = []
        current = dst
        while current is not None:
            path.append(current)
            current = previous.get(current)

        return path[::-1], distances[dst]

# การใช้งาน
net = Network()
for name in ["A", "B", "C", "D", "E"]:
    net.add_router(name)

net.add_link("A", "B", 4)
net.add_link("A", "C", 2)
net.add_link("B", "C", 1)
net.add_link("B", "D", 5)
net.add_link("C", "D", 8)
net.add_link("C", "E", 10)
net.add_link("D", "E", 2)

path, latency = net.shortest_path("A", "E")
print(f"Path: {' → '.join(path)} (latency: {latency})")
# Path: A → C → B → D → E (latency: 10)
```

### 4.24.4 ข้อดี

- **แก้ปัญหาหลากหลาย:** จาก simple ถึง complex
- **มีประสิทธิภาพ:** optimized สำหรับแต่ละประเภท
- **ใช้งานจริง:** social, maps, networks, scheduling

### 4.24.5 ข้อเสีย

- **ซับซ้อน:** ต้องเข้าใจแต่ละ algorithm
- **เลือกผิด:** ผลลัพธ์ผิดหรือช้า
- **Memory:** บาง algorithm กิน RAM

### 4.24.6 ข้อควรระวัง

```python
# ระวัง 1: เลือก algorithm ผิด
# Shortest path:
# - Unweighted → BFS
# - Non-negative weights → Dijkstra
# - Negative weights → Bellman-Ford
# - All-pairs → Floyd-Warshall

# ระวัง 2: Cycle detection
# Undirected graph: ใช้ Union-Find หรือ DFS
# Directed graph: ใช้ DFS กับ rec_stack

# ระวัง 3: Graph representation
# Sparse graph → adjacency list
# Dense graph → adjacency matrix

# ระวัง 4: Negative cycles
# Dijkstra ใช้ไม่ได้ → Bellman-Ford
```

### 4.24.7 สรุป

เลือก Graph Algorithm ตามปัญหา:

| ปัญหา | Algorithm |
|-------|-----------|
| Unweighted shortest path | BFS |
| Weighted shortest path (non-neg) | Dijkstra |
| Weighted shortest path (neg) | Bellman-Ford |
| All-pairs shortest path | Floyd-Warshall |
| MST | Kruskal, Prim |
| Topological order | Kahn, DFS |
| Connected components | Union-Find, DFS |
| Cycle detection | DFS, Union-Find |

> **อ้างอิงเพิ่มเติม:** [Graph Algorithms](https://en.wikipedia.org/wiki/Graph_algorithm)

---

## 4.25 Big O Notation

### บทนำ

Big O Notation เป็นเครื่องมือสำคัญในการวิเคราะห์ประสิทธิภาพของอัลกอริทึม ช่วยเปรียบเทียบว่าอัลกอริทึมใดดีกว่ากันเมื่อข้อมูลมีขนาดใหญ่

### นิยาม

Big O Notation อธิบาย **upper bound** ของ growth rate ของฟังก์ชัน เมื่อ input มีขนาดเข้าใกล้อนันต์

### 4.25.1 คืออะไร

**สัญลักษณ์:**
- **O(f(n)):** upper bound
- **Ω(f(n)):** lower bound
- **Θ(f(n)):** tight bound (ทั้ง O และ Ω)
- **o(f(n)):** strict upper bound

**คลาสที่สำคัญ (จากเร็วไปช้า):**
- **O(1):** constant
- **O(log n):** logarithmic
- **O(n):** linear
- **O(n log n):** linearithmic
- **O(n²):** quadratic
- **O(2^n):** exponential
- **O(n!):** factorial

### 4.25.2 ทำงานอย่างไร

**Rules:**
1. Drop constants: O(2n) → O(n)
2. Drop lower terms: O(n² + n) → O(n²)
3. Different inputs = different variables: O(a + b)
4. Nested = multiply: O(n) × O(m) = O(n*m)

### 4.25.3 การใช้งาน

```python
# O(1) — Constant
def get_first(arr):
    return arr[0] if arr else None

# O(log n) — Logarithmic
def binary_search(arr, target):
    low, high = 0, len(arr) - 1
    while low <= high:
        mid = (low + high) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1

# O(n) — Linear
def find_max(arr):
    if not arr:
        return None
    max_val = arr[0]
    for x in arr:
        if x > max_val:
            max_val = x
    return max_val

# O(n log n) — Linearithmic
def sort_arr(arr):
    return sorted(arr)

# O(n²) — Quadratic
def find_duplicates_naive(arr):
    dupes = []
    for i in range(len(arr)):
        for j in range(i + 1, len(arr)):
            if arr[i] == arr[j]:
                dupes.append(arr[i])
    return dupes

# O(n²) — Bubble sort
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
    return arr

# O(2^n) — Exponential
def fib_naive(n):
    if n <= 1:
        return n
    return fib_naive(n - 1) + fib_naive(n - 2)

# O(n!) — Factorial
def permutations(arr):
    if len(arr) <= 1:
        return [arr]
    result = []
    for i in range(len(arr)):
        rest = arr[:i] + arr[i + 1:]
        for p in permutations(rest):
            result.append([arr[i]] + p)
    return result
```

**ตารางเปรียบเทียบ Operations:**

| Operation | List | Dict | Set | Deque |
|-----------|------|------|-----|-------|
| Access by index | O(1) | - | - | O(n) |
| Access by key | - | O(1) | - | - |
| Search | O(n) | O(1) | O(1) | O(n) |
| Insert (end) | O(1)* | O(1)* | O(1)* | O(1) |
| Insert (front) | O(n) | - | - | O(1) |
| Insert (middle) | O(n) | - | - | O(n) |
| Delete (end) | O(1) | O(1) | O(1) | O(1) |
| Delete (front) | O(n) | - | - | O(1) |
| Min/Max | O(n) | O(n) | O(n) | O(n) |

*amortized

**การวิเคราะห์ Code:**
```python
# ตัวอย่าง: analyze
def example(arr):
    n = len(arr)

    # O(1)
    first = arr[0]

    # O(n)
    total = sum(arr)

    # O(n)
    for x in arr:
        print(x)

    # O(n²) — nested loop
    for i in range(n):
        for j in range(n):
            print(arr[i], arr[j])

    # O(n log n) — sort
    sorted_arr = sorted(arr)

    # Total: O(1) + O(n) + O(n) + O(n²) + O(n log n)
    #      = O(n²)
```

**Space Complexity:**
```python
# O(1) space — in-place
def reverse_inplace(arr):
    left, right = 0, len(arr) - 1
    while left < right:
        arr[left], arr[right] = arr[right], arr[left]
        left += 1
        right -= 1

# O(n) space — สร้าง list ใหม่
def reverse_copy(arr):
    return arr[::-1]

# O(n) space — recursion
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)  # n stack frames
```

**Best/Average/Worst Case:**
```python
# Linear search
def linear_search(arr, target):
    for x in arr:
        if x == target:
            return True
    return False

# Best: O(1) — target อยู่ตัวแรก
# Average: O(n/2) = O(n)
# Worst: O(n) — target อยู่ตัวสุดท้ายหรือไม่มี

# Quick sort
# Best: O(n log n) — pivot แบ่งครึ่งพอดี
# Average: O(n log n)
# Worst: O(n²) — pivot ที่แย่ (sorted data + pivot = first)
```

**ตัวอย่างการใช้งานจริง — เลือก Data Structure:**
```python
# ❌ ใช้ list ผิดจุดประสงค์
def has_duplicate_bad(items: list) -> bool:
    """O(n²) — ช้ามาก"""
    for i in range(len(items)):
        for j in range(i + 1, len(items)):
            if items[i] == items[j]:
                return True
    return False

# ✅ ใช้ set — O(n)
def has_duplicate_good(items: list) -> bool:
    seen = set()
    for item in items:
        if item in seen:
            return True
        seen.add(item)
    return False

# ✅ ใช้ set comprehension — สั้นและเร็ว
def has_duplicate_best(items: list) -> bool:
    return len(set(items)) != len(items)

# ทดสอบ
import random
import time

data = [random.randint(1, 100000) for _ in range(100000)]

# ✅ เร็ว
start = time.time()
has_duplicate_good(data)
print(f"Set method: {time.time() - start:.4f}s")

# ❌ ช้า (จะใช้เวลานานมาก — ไม่รันจริง)
# has_duplicate_bad(data)
```

### 4.25.4 ข้อดี

- **Universal:** เปรียบเทียบ algorithms ได้
- **Scalable:** เข้าใจพฤติกรรมเมื่อ data โต
- **Language-agnostic:** ใช้ได้ทุกภาษา
- **Predictable:** คาดเดา performance ได้

### 4.25.5 ข้อเสีย

- **Upper bound เท่านั้น:** ไม่บอกค่าคงที่
- **Asymptotic:** ไม่บอก performance กับ data เล็ก
- **Ignore constants:** O(2n) และ O(100n) เป็น O(n) เหมือนกัน
- **ไม่บอก memory access patterns:** cache effects

### 4.25.6 ข้อควรระวัง

```python
# ระวัง 1: Constants สำคัญกับ data เล็ก
# O(n log n) sort อาจช้ากว่า O(n²) insertion sort
# สำหรับ n < 10-20
# → Timsort ใช้ insertion sort สำหรับ runs สั้น

# ระวัง 2: Amortized vs Worst case
# list.append() เป็น amortized O(1)
# แต่บางครั้ง (ตอน resize) เป็น O(n)
# แต่ amortized = O(1)

# ระวัง 3: Hidden loops
# string concatenation ใน loop เป็น O(n²)
# because string เป็น immutable

# ❌ O(n²)
result = ""
for s in strings:
    result += s  # สร้าง string ใหม่ทุกครั้ง

# ✅ O(n)
result = "".join(strings)

# ระวัง 4: Python-specific overhead
# Python operations มี overhead สูง
# บางครั้ง algorithm ที่ "ดีกว่า" ใน theory อาจช้ากว่าใน practice
# ควร benchmark จริง
```

### 4.25.7 สรุป

**หลักการ:**
1. ระบุ input size (n)
2. นับ operations เป็นฟังก์ชันของ n
3. Drop constants และ lower terms
4. Focus on worst case (มัก)

**เป้าหมาย:**
- **O(1) หรือ O(log n):** ยอดเยี่ยม
- **O(n):** ดี
- **O(n log n):** ยอมรับได้
- **O(n²):** ระวังกับ n ใหญ่
- **O(2^n):** ใช้กับ n เล็กเท่านั้น

> **อ้างอิงเพิ่มเติม:** [Big-O Cheat Sheet](https://www.bigocheatsheet.com/), [Python TimeComplexity](https://wiki.python.org/moin/TimeComplexity)

---

## 4.26 การวิเคราะห์เวลาและหน่วยความจำ

### บทนำ

การวิเคราะห์เวลาและหน่วยความจำเป็นทักษะสำคัญที่ช่วยให้เลือก algorithms และ data structures ได้อย่างเหมาะสม เข้าใจ trade-offs และ optimize code ที่ critical

### นิยาม

- **Time Complexity:** การเติบโตของเวลาที่ใช้เมื่อ input โต
- **Space Complexity:** การเติบโตของหน่วยความจำที่ใช้

### 4.26.1 คืออะไร

การวิเคราะห์ทำได้ 2 วิธี:
- **Theoretical:** Big O analysis
- **Empirical:** benchmark จริง

### 4.26.2 ทำงานอย่างไร

**Time-Space Trade-off:**
- ใช้เวลาเพิ่ม → ประหยัด memory (เช่น re-compute)
- ใช้ memory เพิ่ม → ประหยัดเวลา (เช่น cache)

### 4.26.3 การใช้งาน

**Profiling ด้วย cProfile:**
```python
import cProfile
import pstats
from io import StringIO

def slow_function():
    total = 0
    for i in range(100000):
        total += sum(range(100))
    return total

# Profile
profiler = cProfile.Profile()
profiler.enable()
slow_function()
profiler.disable()

# แสดงผล
stream = StringIO()
stats = pstats.Stats(profiler, stream=stream)
stats.sort_stats("cumulative")
stats.print_stats(10)
print(stream.getvalue())
```

**Timeit สำหรับ Micro-benchmarks:**
```python
import timeit

# เปรียบเทียบ methods
setup = "data = list(range(1000))"

# วิธี 1: list comprehension
t1 = timeit.timeit(
    "[x * 2 for x in data]",
    setup=setup,
    number=10000,
)

# วิธี 2: map
t2 = timeit.timeit(
    "list(map(lambda x: x * 2, data))",
    setup=setup,
    number=10000,
)

print(f"List comprehension: {t1:.4f}s")
print(f"Map: {t2:.4f}s")

# เปรียบเทียบ string concatenation
setup2 = "strings = ['a'] * 1000"
t3 = timeit.timeit(
    "result = ''\nfor s in strings: result += s",
    setup=setup2,
    number=1000,
)
t4 = timeit.timeit(
    "''.join(strings)",
    setup=setup2,
    number=1000,
)
print(f"Concat: {t3:.4f}s")
print(f"Join: {t4:.4f}s")
```

**Memory Profiling:**
```python
import sys
from memory_profiler import profile

# ขนาดของ objects
print(sys.getsizeof(1))          # 28 bytes (int)
print(sys.getsizeof("a"))        # 50 bytes (str)
print(sys.getsizeof([]))         # 56 bytes (empty list)
print(sys.getsizeof([1, 2, 3]))  # 88 bytes
print(sys.getsizeof({}))         # 64 bytes (empty dict)

# Profiling memory
@profile
def memory_hungry():
    # list comprehension
    data1 = [i for i in range(1000000)]

    # generator (ประหยัด memory)
    data2 = (i for i in range(1000000))

    # set (ประหยัดกว่า list สำหรับ unique)
    data3 = {i for i in range(1000000)}

    return data1, data2, data3

# memory_hungry()
```

**ตัวอย่างการใช้งานจริง — เลือก Data Structure ที่เหมาะ:**
```python
import time
import random
import sys

def benchmark_membership():
    """เปรียบเทียบ membership check"""
    n = 1_000_000
    data_list = list(range(n))
    data_set = set(range(n))
    data_dict = {i: True for i in range(n)}

    # ทดสอบ 1000 ครั้ง
    targets = [random.randint(0, n) for _ in range(1000)]

    # List — O(n)
    start = time.time()
    for t in targets:
        _ = t in data_list
    list_time = time.time() - start

    # Set — O(1)
    start = time.time()
    for t in targets:
        _ = t in data_set
    set_time = time.time() - start

    # Dict — O(1)
    start = time.time()
    for t in targets:
        _ = t in data_dict
    dict_time = time.time() - start

    print(f"List (O(n)): {list_time:.4f}s")
    print(f"Set (O(1)): {set_time:.4f}s")
    print(f"Dict (O(1)): {dict_time:.4f}s")

    # Memory
    print(f"\nMemory:")
    print(f"List: {sys.getsizeof(data_list):,} bytes")
    print(f"Set: {sys.getsizeof(data_set):,} bytes")
    print(f"Dict: {sys.getsizeof(data_dict):,} bytes")

benchmark_membership()
```

**ตัวอย่าง — Optimize Loop:**
```python
import timeit

# ❌ ช้า — สร้าง list กลาง
def sum_squares_bad(n):
    return sum([x ** 2 for x in range(n)])

# ✅ เร็ว — generator
def sum_squares_good(n):
    return sum(x ** 2 for x in range(n))

# ✅ เร็วมาก — math formula
def sum_squares_best(n):
    return n * (n + 1) * (2 * n + 1) // 6

n = 1000000

t1 = timeit.timeit(lambda: sum_squares_bad(n), number=10)
t2 = timeit.timeit(lambda: sum_squares_good(n), number=10)
t3 = timeit.timeit(lambda: sum_squares_best(n), number=10)

print(f"List comp: {t1:.4f}s")
print(f"Generator: {t2:.4f}s")
print(f"Formula: {t3:.6f}s")
```

**ตัวอย่าง — เลือก Algorithm ที่เหมาะ:**
```python
import timeit

def find_duplicates_sort(arr):
    """O(n log n) — sort แล้วเทียบ"""
    if len(arr) < 2:
        return []
    sorted_arr = sorted(arr)
    dupes = []
    for i in range(1, len(sorted_arr)):
        if sorted_arr[i] == sorted_arr[i-1]:
            dupes.append(sorted_arr[i])
    return dupes

def find_duplicates_set(arr):
    """O(n) — ใช้ set"""
    seen = set()
    dupes = set()
    for x in arr:
        if x in seen:
            dupes.add(x)
        else:
            seen.add(x)
    return list(dupes)

import random
data = [random.randint(1, 10000) for _ in range(100000)]

t1 = timeit.timeit(lambda: find_duplicates_sort(data), number=1)
t2 = timeit.timeit(lambda: find_duplicates_set(data), number=1)

print(f"Sort-based: {t1:.4f}s")
print(f"Set-based: {t2:.4f}s")
```

**Memory Optimization Techniques:**
```python
# 1. ใช้ __slots__ ลด memory
class WithSlots:
    __slots__ = ("x", "y", "z")
    def __init__(self, x, y, z):
        self.x, self.y, self.z = x, y, z

class WithoutSlots:
    def __init__(self, x, y, z):
        self.x, self.y, self.z = x, y, z

obj1 = WithSlots(1, 2, 3)
obj2 = WithoutSlots(1, 2, 3)

print(f"With __slots__: {sys.getsizeof(obj1)} bytes")
print(f"Without: {sys.getsizeof(obj2)} bytes + __dict__")

# 2. ใช้ generator แทน list
def process_large_file_bad(path):
    with open(path) as f:
        lines = f.readlines()  # ❌ โหลดทั้งหมด
    return [line.strip() for line in lines]

def process_large_file_good(path):
    with open(path) as f:
        for line in f:  # ✅ ทีละบรรทัด
            yield line.strip()

# 3. ใช้ array module สำหรับ numeric data
import array

# List of ints
list_data = list(range(1000000))
array_data = array.array("i", range(1000000))

print(f"List: {sys.getsizeof(list_data):,} bytes")
print(f"Array: {sys.getsizeof(array_data):,} bytes")

# 4. ใช้ numpy สำหรับ numeric computation
import numpy as np

np_data = np.arange(1000000, dtype=np.int32)
print(f"NumPy: {np_data.nbytes:,} bytes")
```

**Trade-off ตัวอย่าง:**
```python
# Time-Memory Trade-off

# ❌ ใช้เวลา O(n²) — ไม่ใช้ memory
def find_common_no_cache(a, b):
    result = []
    for x in a:
        if x in b:  # O(len(b)) ถ้า b เป็น list
            result.append(x)
    return result

# ✅ ใช้เวลา O(n) — ใช้ memory เพิ่ม
def find_common_with_cache(a, b):
    set_b = set(b)  # O(len(b)) memory
    return [x for x in a if x in set_b]  # O(1) lookup

# ❌ ใช้เวลา O(2^n) — fibonacci naive
def fib_slow(n):
    if n <= 1:
        return n
    return fib_slow(n-1) + fib_slow(n-2)

# ✅ ใช้เวลา O(n) — ใช้ cache
from functools import lru_cache

@lru_cache(maxsize=None)
def fib_fast(n):
    if n <= 1:
        return n
    return fib_fast(n-1) + fib_fast(n-2)
```

### 4.26.4 ข้อดี

- **เลือกได้ดี:** algorithms/data structures ที่เหมาะ
- **Optimize จุดที่ควร:** ไม่เสียเวลากับส่วนที่ไม่สำคัญ
- **Predictable:** คาดเดา performance ได้
- **Trade-offs:** เข้าใจ cost ของการตัดสินใจ

### 4.26.5 ข้อเสีย

- **Time-consuming:** profiling ใช้เวลา
- **Context-dependent:** ผลในเครื่องหนึ่งอาจไม่เหมือนอีกเครื่อง
- **Premature optimization:** อาจทำให้โค้ดอ่านยาก
- **Asymptotic ≠ reality:** constants สำคัญ

### 4.26.6 ข้อควรระวัง

```python
# ระวัง 1: Premature optimization
# "Premature optimization is the root of all evil" — Knuth
# ควรเขียนให้ถูกต้องและอ่านง่ายก่อน แล้วค่อย optimize

# ระวัง 2: Optimize จุดที่ไม่สำคัญ
# ถ้า function ใช้เวลา 1% ของ total ไม่ควร optimize

# ระวัง 3: Benchmark ไม่ดี
# ❌ ใช้ time.time() สำหรับ micro-benchmarks
# ✅ ใช้ timeit ซึ่งทำ warmup และ repeat

# ระวัง 4: Cache effects
# O(n) algorithm ที่ access memory แบบ random อาจช้ากว่า
# O(n log n) ที่ access แบบ sequential

# ระวัง 5: GIL
# Python threads ไม่ช่วย CPU-bound tasks
# ใช้ multiprocessing แทน
```

### 4.26.7 สรุป

**ขั้นตอน optimize:**
1. **Measure:** profile ก่อน optimize
2. **Identify:** หา bottleneck จริง
3. **Analyze:** ระบุ time/space complexity
4. **Improve:** เลือก algorithm/data structure ที่เหมาะ
5. **Verify:** benchmark หลัง optimize
6. **Iterate:** ทำซ้ำถ้าจำเป็น

**เครื่องมือ:**
- `cProfile`, `line_profiler` — code profiling
- `timeit` — micro-benchmarks
- `memory_profiler` — memory profiling
- `sys.getsizeof` — object size
- `pytest-benchmark` — test benchmarks

> **อ้างอิงเพิ่มเติม:** [Python Profilers](https://docs.python.org/3/library/profile.html), [timeit Documentation](https://docs.python.org/3/library/timeit.html)

---

## สรุปภาค 4

ภาค 4 ครอบคลุมโครงสร้างข้อมูลและอัลกอริทึมที่จำเป็นสำหรับนักพัฒนา Python:

**โครงสร้างข้อมูลพื้นฐาน:**
- **List:** mutable, ordered, เหมาะกับข้อมูลที่เปลี่ยนแปลง
- **Tuple:** immutable, เร็วกว่า, เหมาะกับข้อมูลคงที่
- **Set:** unique, hash-based, เหมาะกับ membership check
- **Dict:** key-value, O(1) lookup, เหมาะกับ mapping

**ขั้นสูง:**
- **String/Bytes:** ข้อความและ binary data
- **Comprehension:** สร้าง collection กระชับ
- **Iterator/Generator:** ประมวลผลแบบ lazy
- **Iterable:** abstraction ของ data source

**โครงสร้างเฉพาะ:**
- **Stack:** LIFO
- **Queue:** FIFO
- **Deque:** double-ended
- **Linked List:** insert/delete เร็ว
- **Tree:** hierarchical
- **Graph:** ความสัมพันธ์
- **Hash Table:** O(1) lookup
- **Heap:** priority queue

**อัลกอริทึม:**
- **Sorting:** Timsort (built-in), merge, quick, heap
- **Searching:** linear, binary, hash
- **Recursion/Backtracking:** แก้ปัญหาที่ย้อนกลับได้
- **DP:** optimal solutions
- **Greedy:** local optimal → global optimal
- **Graph:** BFS, DFS, Dijkstra, MST, topological sort

**การวิเคราะห์:**
- **Big O:** เปรียบเทียบ algorithms
- **Profiling:** measure จริง

**ก้าวต่อไป:** ภาค 5 จะเข้าสู่การเขียนโปรแกรมเชิงวัตถุ (OOP)

---

# ภาค 5: การเขียนโปรแกรมเชิงวัตถุ

## 5.1 Class และ Object

### บทนำ

Class และ Object เป็นหัวใจของ Object-Oriented Programming (OOP) ช่วยให้จัดระเบียบโค้ดเป็น units ที่มีความหมาย ง่ายต่อการ maintain และ extend

### นิยาม

- **Class:** blueprint หรือ template สำหรับสร้าง objects
- **Object:** instance ของ class ที่มี state (attributes) และ behavior (methods)

### 5.1.1 คืออะไร

Class กำหนด:
- **Attributes:** ข้อมูลที่ object เก็บ
- **Methods:** ฟังก์ชันที่ object ทำได้
- **Constructor:** วิธีสร้าง object

Object คือ instance จริงที่สร้างจาก class

### 5.1.2 ทำงานอย่างไร

เมื่อสร้าง object:
1. Python เรียก `__new__()` เพื่อสร้าง instance
2. เรียก `__init__()` เพื่อ initialize attributes
3. คืน object ที่พร้อมใช้งาน

### 5.1.3 การใช้งาน

**Class พื้นฐาน:**
```python
class Dog:
    """A simple dog class"""

    # Class attribute (shared)
    species = "Canis familiaris"

    def __init__(self, name: str, age: int):
        # Instance attributes (unique per object)
        self.name = name
        self.age = age

    def bark(self) -> str:
        return f"{self.name} says woof!"

    def birthday(self) -> None:
        self.age += 1

# สร้าง objects
dog1 = Dog("Buddy", 3)
dog2 = Dog("Max", 5)

# เข้าถึง attributes
print(dog1.name)      # Buddy
print(dog2.age)       # 5
print(Dog.species)    # Canis familiaris

# เรียก methods
print(dog1.bark())    # Buddy says woof!
dog1.birthday()
print(dog1.age)       # 4

# ตรวจสอบ type
print(type(dog1))     # <class '__main__.Dog'>
print(isinstance(dog1, Dog))  # True
```

**Class vs Instance Attributes:**
```python
class Counter:
    count = 0  # class attribute

    def __init__(self, name: str):
        self.name = name  # instance attribute
        Counter.count += 1  # แก้ class attribute ผ่าน class

    def get_count(self):
        return Counter.count

c1 = Counter("first")
c2 = Counter("second")
print(Counter.count)  # 2
print(c1.get_count()) # 2
```

**ตัวอย่างการใช้งานจริง — User Management:**
```python
from dataclasses import dataclass, field
from datetime import datetime
from typing import Optional
import re
import hashlib

@dataclass
class User:
    username: str
    email: str
    password_hash: str = ""
    created_at: datetime = field(default_factory=datetime.now)
    last_login: Optional[datetime] = None
    is_active: bool = True

    def set_password(self, password: str) -> None:
        """Hash และเก็บ password"""
        if len(password) < 8:
            raise ValueError("Password ต้องมีอย่างน้อย 8 ตัวอักษร")
        self.password_hash = hashlib.sha256(
            password.encode()
        ).hexdigest()

    def verify_password(self, password: str) -> bool:
        """ตรวจสอบ password"""
        return self.password_hash == hashlib.sha256(
            password.encode()
        ).hexdigest()

    def login(self, password: str) -> bool:
        """พยายาม login"""
        if not self.is_active:
            raise ValueError("บัญชีถูกระงับ")
        if not self.verify_password(password):
            return False
        self.last_login = datetime.now()
        return True

    def deactivate(self) -> None:
        self.is_active = False

    def __str__(self) -> str:
        status = "active" if self.is_active else "inactive"
        return f"@{self.username} ({self.email}) [{status}]"

# การใช้งาน
user = User(username="somchai", email="somchai@email.com")
user.set_password("securepass123")

print(user)  # @somchai (somchai@email.com) [active]
print(user.login("wrongpass"))       # False
print(user.login("securepass123"))   # True
print(user.last_login is not None)   # True
```

**Class-level Operations:**
```python
class Temperature:
    def __init__(self, celsius: float):
        self._celsius = celsius

    @property
    def celsius(self) -> float:
        return self._celsius

    @celsius.setter
    def celsius(self, value: float) -> None:
        if value < -273.15:
            raise ValueError("ต่ำกว่าศูนย์สัมบูรณ์")
        self._celsius = value

    @property
    def fahrenheit(self) -> float:
        return self._celsius * 9/5 + 32

    @fahrenheit.setter
    def fahrenheit(self, value: float) -> None:
        self.celsius = (value - 32) * 5/9

    @property
    def kelvin(self) -> float:
        return self._celsius + 273.15

    @classmethod
    def from_fahrenheit(cls, f: float) -> "Temperature":
        return cls((f - 32) * 5/9)

    @staticmethod
    def is_freezing(celsius: float) -> bool:
        return celsius <= 0

    def __repr__(self) -> str:
        return f"Temperature({self._celsius}°C)"

    def __eq__(self, other) -> bool:
        if not isinstance(other, Temperature):
            return NotImplemented
        return abs(self._celsius - other._celsius) < 1e-9

# การใช้งาน
t1 = Temperature(25)
print(t1.fahrenheit)  # 77.0
print(t1.kelvin)      # 298.15

t2 = Temperature.from_fahrenheit(77)
print(t1 == t2)       # True

print(Temperature.is_freezing(-5))  # True
```

### 5.1.4 ข้อดี

- **Organization:** จัดกลุ่ม data + behavior
- **Reusability:** สร้าง instance ได้มากมาย
- **Encapsulation:** ซ่อน implementation details
- **Inheritance:** extend class ได้
- **Polymorphism:** ใช้ interface เดียวกัน

### 5.1.5 ข้อเสีย

- **Overhead:** class instance มี overhead
- **Complexity:** สำหรับงานง่าย ๆ อาจ overkill
- **Learning curve:** ต้องเข้าใจ OOP concepts

### 5.1.6 ข้อควรระวัง

```python
# ระวัง 1: mutable class attribute
class Bad:
    items = []  # ❌ shared ระหว่าง instances

    def add(self, item):
        self.items.append(item)

b1, b2 = Bad(), Bad()
b1.add(1)
print(b2.items)  # [1] — ❌ bug!

# ✅ ใช้ instance attribute
class Good:
    def __init__(self):
        self.items = []  # ✅ per instance

# ระวัง 2: ไม่ควรเข้าถึง __dict__ โดยตรง
class MyClass:
    pass

obj = MyClass()
obj.x = 1
print(obj.__dict__)  # {'x': 1}

# ระวัง 3: hasattr ก่อน getattr
if hasattr(obj, "y"):
    print(obj.y)
# หรือใช้ getattr กับ default
print(getattr(obj, "y", "default"))

# ระวัง 4: Circular references
class Node:
    def __init__(self):
        self.parent = None
        self.children = []

# a.parent = b; b.children.append(a)
# → circular reference (GC จัดการได้ แต่ใช้ memory)
```

### 5.1.7 สรุป

ใช้ Class เมื่อ:
- มี data + behavior ที่เกี่ยวข้องกัน
- ต้องการสร้าง instances หลายตัว
- ต้องการ encapsulation
- ต้องการ inheritance

**Best practices:**
- `__init__` สำหรับ initialize
- Methods สื่อความหมาย
- ใช้ type hints
- Docstrings

> **อ้างอิงเพิ่มเติม:** [Python Classes](https://docs.python.org/3/tutorial/classes.html), [Real Python — OOP](https://realpython.com/python3-object-oriented-programming/)

---

## 5.2 Attribute และ Method

### บทนำ

Attributes เก็บ state ของ object ส่วน methods กำหนด behavior การเข้าใจความแตกต่างระหว่าง instance, class และ static methods เป็นสิ่งสำคัญ

### นิยาม

- **Instance attribute:** unique per object, เก็บใน `__dict__`
- **Class attribute:** shared ระหว่าง instances
- **Instance method:** รับ `self` เป็น argument แรก
- **Class method:** รับ `cls` แทน `self`
- **Static method:** ไม่รับ `self` หรือ `cls`

### 5.2.1 คืออะไร

**Access levels (convention):**
- `name` — public
- `_name` — protected (convention)
- `__name` — name mangling
- `__name__` — dunder (special)

### 5.2.2 ทำงานอย่างไร

Method lookup:
1. Instance `__dict__`
2. Class `__dict__`
3. Parent classes (MRO)

### 5.2.3 การใช้งาน

```python
class Employee:
    company = "TechCorp"  # class attribute
    _next_id = 1

    def __init__(self, name: str, salary: float):
        self.id = Employee._next_id
        Employee._next_id += 1

        self.name = name
        self._salary = salary  # protected
        self.__bonus = 0  # private (name mangled)

    # Instance method
    def get_info(self) -> str:
        return f"#{self.id} {self.name}"

    # Instance method แก้ state
    def give_raise(self, percent: float) -> None:
        self._salary *= (1 + percent / 100)

    @property
    def salary(self) -> float:
        return self._salary

    @salary.setter
    def salary(self, value: float) -> None:
        if value < 0:
            raise ValueError("Salary ต้องไม่ติดลบ")
        self._salary = value

    # Class method — ใช้เป็น alternative constructor
    @classmethod
    def from_string(cls, data: str) -> "Employee":
        name, salary = data.split(",")
        return cls(name.strip(), float(salary))

    # Static method — utility
    @staticmethod
    def is_workday(day: str) -> bool:
        return day.lower() not in ("saturday", "sunday")

    # Name-mangled method
    def _Employee__apply_bonus(self, amount: float) -> None:
        self.__bonus += amount

# การใช้งาน
emp = Employee("สมชาย", 50000)
print(emp.get_info())              # #1 สมชาย
print(emp.salary)                  # 50000
emp.give_raise(10)
print(emp.salary)                  # 55000.0

emp2 = Employee.from_string("สมหญิง, 60000")
print(emp2.get_info())             # #2 สมหญิง

print(Employee.is_workday("Monday"))   # True
print(Employee.is_workday("Sunday"))   # False
```

**Property กับ Validation:**
```python
from datetime import datetime

class BankAccount:
    def __init__(self, owner: str, balance: float = 0):
        self.owner = owner
        self._balance = balance
        self._transactions: list[tuple[datetime, float, str]] = []

    @property
    def balance(self) -> float:
        return self._balance

    @balance.setter
    def balance(self, value: float) -> None:
        if value < 0:
            raise ValueError("ยอดเงินต้องไม่ติดลบ")
        self._balance = value

    def deposit(self, amount: float) -> None:
        if amount <= 0:
            raise ValueError("จำนวนเงินต้องมากกว่า 0")
        self._balance += amount
        self._transactions.append((datetime.now(), amount, "deposit"))

    def withdraw(self, amount: float) -> None:
        if amount <= 0:
            raise ValueError("จำนวนเงินต้องมากกว่า 0")
        if amount > self._balance:
            raise ValueError("ยอดเงินไม่เพียงพอ")
        self._balance -= amount
        self._transactions.append((datetime.now(), -amount, "withdraw"))

    @property
    def statement(self) -> str:
        lines = [f"Statement for {self.owner}"]
        for dt, amount, kind in self._transactions:
            sign = "+" if amount > 0 else ""
            lines.append(f"  {dt:%Y-%m-%d %H:%M} {kind}: {sign}{amount:,.2f}")
        lines.append(f"  Balance: {self._balance:,.2f}")
        return "\n".join(lines)

# การใช้งาน
acc = BankAccount("สมชาย", 1000)
acc.deposit(500)
acc.withdraw(200)
print(acc.statement)
```

**Dynamic Attributes:**
```python
class Config:
    def __init__(self, **kwargs):
        for key, value in kwargs.items():
            setattr(self, key, value)

    def __getattr__(self, name: str):
        """เรียกเมื่อ attribute ไม่มี"""
        print(f"Attribute '{name}' not found, using default")
        return None

    def __setattr__(self, name: str, value):
        """เรียกทุกครั้งที่ set attribute"""
        print(f"Setting {name} = {value}")
        super().__setattr__(name, value)

config = Config(debug=True, port=8080)
print(config.debug)   # True
print(config.unknown) # None (จาก __getattr__)

# ตรวจสอบ attributes
print(config.__dict__)  # {'debug': True, 'port': 8080}
```

**ตัวอย่างการใช้งานจริง — Model Layer:**
```python
from typing import Any
from datetime import datetime

class Model:
    """Base model with ORM-like features"""

    _table_name: str = ""

    def __init__(self, **kwargs):
        for key, value in kwargs.items():
            setattr(self, key, value)

    def to_dict(self) -> dict[str, Any]:
        """แปลงเป็น dict"""
        return {
            key: value
            for key, value in self.__dict__.items()
            if not key.startswith("_")
        }

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> "Model":
        return cls(**data)

    def __repr__(self) -> str:
        attrs = ", ".join(f"{k}={v!r}" for k, v in self.to_dict().items())
        return f"{self.__class__.__name__}({attrs})"

class User(Model):
    _table_name = "users"

    username: str
    email: str
    created_at: datetime

# การใช้งาน
data = {
    "username": "somchai",
    "email": "somchai@email.com",
    "created_at": datetime.now(),
}
user = User.from_dict(data)
print(user)
print(user.to_dict())
```

### 5.2.4 ข้อดี

- **Clear interface:** methods และ properties
- **Validation:** ด้วย property
- **Flexible:** dynamic attributes
- **Readable:** `@property` อ่านง่ายกว่า getter/setter

### 5.2.5 ข้อเสีย

- **Overhead:** property มี overhead
- **Magic:** `__getattr__` อาจทำให้ debug ยาก
- **Name mangling:** `__name` อาจสับสน

### 5.2.6 ข้อควรระวัง

```python
# ระวัง 1: ชื่อ mangling
class MyClass:
    def __init__(self):
        self.__private = 42  # กลายเป็น _MyClass__private

obj = MyClass()
# print(obj.__private)          # ❌ AttributeError
print(obj._MyClass__private)    # ✅ 42 (แต่อย่าทำ)

# ระวัง 2: property ที่มี side effects
class Bad:
    @property
    def value(self):
        print("Computing...")  # ❌ side effect ใน property
        return self._value

# ระวัง 3: __getattr__ vs __getattribute__
# __getattribute__ เรียกทุกครั้ง (ระวัง recursion)
# __getattr__ เรียกเฉพาะเมื่อ attribute ไม่มี

# ระวัง 4: class attribute ที่ mutable
# ใช้ instance attribute เสมอ

# ระวัง 5: อย่าใช้ hasattr กับ property
class WithProp:
    @property
    def val(self):
        raise RuntimeError("error")

obj = WithProp()
print(hasattr(obj, "val"))  # ❌ return False (เพราะ property raise)
```

### 5.2.7 สรุป

**เมื่อไหร่ใช้อะไร:**
- **Instance method:** default, ทำงานกับ instance state
- **Class method:** alternative constructors, class-level operations
- **Static method:** utility functions ที่ไม่ต้องใช้ state
- **Property:** computed attributes, validation
- **Public:** ใช้ทั่วไป
- **Protected (`_`):** ภายใน class/module
- **Private (`__`):** ไม่ควรเข้าถึงจากภายนอก

> **อ้างอิงเพิ่มเติม:** [Class and Instance Variables](https://docs.python.org/3/tutorial/classes.html#class-and-instance-variables), [Descriptor HowTo](https://docs.python.org/3/howto/descriptor.html)

---

## 5.3 Constructor

### บทนำ

Constructor เป็น method พิเศษที่ถูกเรียกเมื่อสร้าง object ใช้สำหรับ initialize state และ validate inputs

### นิยาม

- `__new__()` — สร้าง instance (static method)
- `__init__()` — initialize instance (instance method)

### 5.3.1 คืออะไร

`__init__` เป็น constructor ที่ใช้บ่อยที่สุด รับ `self` เป็น argument แรก และ parameters อื่น ๆ

### 5.3.2 ทำงานอย่างไร

```python
obj = MyClass(arg1, arg2)

# เทียบเท่ากับ
obj = MyClass.__new__(MyClass)
MyClass.__init__(obj, arg1, arg2)
```

### 5.3.3 การใช้งาน

**Constructor พื้นฐาน:**
```python
class Point:
    def __init__(self, x: float = 0, y: float = 0):
        self.x = x
        self.y = y

    def __repr__(self) -> str:
        return f"Point({self.x}, {self.y})"

# ใช้ default values
p1 = Point()
p2 = Point(3, 4)
print(p1)  # Point(0, 0)
print(p2)  # Point(3, 4)
```

**Multiple Constructors (class methods):**
```python
from datetime import datetime

class Date:
    def __init__(self, year: int, month: int, day: int):
        self.year = year
        self.month = month
        self.day = day

    @classmethod
    def from_string(cls, date_str: str) -> "Date":
        """สร้างจาก 'YYYY-MM-DD'"""
        year, month, day = map(int, date_str.split("-"))
        return cls(year, month, day)

    @classmethod
    def from_datetime(cls, dt: datetime) -> "Date":
        return cls(dt.year, dt.month, dt.day)

    @classmethod
    def today(cls) -> "Date":
        return cls.from_datetime(datetime.now())

    def __repr__(self) -> str:
        return f"Date({self.year}, {self.month}, {self.day})"

    def __str__(self) -> str:
        return f"{self.year:04d}-{self.month:02d}-{self.day:02d}"

# หลายวิธีสร้าง
d1 = Date(2024, 1, 15)
d2 = Date.from_string("2024-01-15")
d3 = Date.today()
print(d1)  # 2024-01-15
```

**`__new__` สำหรับ Immutable Objects:**
```python
class PositiveInt:
    """Integer ที่ต้องเป็นบวก"""
    _cache: dict[int, "PositiveInt"] = {}

    def __new__(cls, value: int):
        if value <= 0:
            raise ValueError("ต้องเป็นจำนวนเต็มบวก")

        # Caching (flyweight pattern)
        if value in cls._cache:
            return cls._cache[value]

        instance = super().__new__(cls)
        cls._cache[value] = instance
        return instance

    def __init__(self, value: int):
        self.value = value

    def __repr__(self) -> str:
        return f"PositiveInt({self.value})"

    def __eq__(self, other):
        return isinstance(other, PositiveInt) and self.value == other.value

# Caching
p1 = PositiveInt(5)
p2 = PositiveInt(5)
print(p1 is p2)  # True (cache)
```

**Validation ใน Constructor:**
```python
from dataclasses import dataclass, field
from datetime import datetime
import re

class ValidationError(Exception):
    pass

@dataclass
class User:
    username: str
    email: str
    age: int

    def __post_init__(self):
        """เรียกหลัง __init__ (dataclass specific)"""
        self._validate_username()
        self._validate_email()
        self._validate_age()

    def _validate_username(self):
        if not re.match(r"^[a-zA-Z0-9_]{3,20}$", self.username):
            raise ValidationError(
                "Username ต้องมี 3-20 ตัวอักษร (a-z, A-Z, 0-9, _)"
            )

    def _validate_email(self):
        if not re.match(r"^[\w.+-]+@[\w-]+\.[\w.]+$", self.email):
            raise ValidationError(f"Invalid email: {self.email}")

    def _validate_age(self):
        if not 0 <= self.age <= 150:
            raise ValidationError("Age ต้องอยู่ระหว่าง 0-150")

# การใช้งาน
try:
    user = User("somchai", "somchai@email.com", 30)
    print(user)
except ValidationError as e:
    print(f"Error: {e}")

try:
    bad_user = User("ab", "invalid-email", -5)
except ValidationError as e:
    print(f"Error: {e}")  # Error: Username ต้องมี 3-20...
```

**Singleton Pattern:**
```python
class Singleton:
    _instance: "Singleton | None" = None

    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self, config: str = "default"):
        # ระวัง: __init__ ถูกเรียกทุกครั้ง
        if not hasattr(self, "_initialized"):
            self.config = config
            self._initialized = True

# การใช้งาน
s1 = Singleton("first")
s2 = Singleton("second")
print(s1 is s2)       # True
print(s1.config)      # "first" (ไม่เปลี่ยน)
```

**Factory Pattern ด้วย Constructor:**
```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        pass

class Circle(Shape):
    def __init__(self, radius: float):
        if radius <= 0:
            raise ValueError("Radius ต้องมากกว่า 0")
        self.radius = radius

    def area(self) -> float:
        import math
        return math.pi * self.radius ** 2

class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        if width <= 0 or height <= 0:
            raise ValueError("Width และ Height ต้องมากกว่า 0")
        self.width = width
        self.height = height

    def area(self) -> float:
        return self.width * self.height

class ShapeFactory:
    @staticmethod
    def create(shape_type: str, **kwargs) -> Shape:
        shapes = {
            "circle": Circle,
            "rectangle": Rectangle,
        }
        if shape_type not in shapes:
            raise ValueError(f"Unknown shape: {shape_type}")
        return shapes[shape_type](**kwargs)

# การใช้งาน
circle = ShapeFactory.create("circle", radius=5)
rect = ShapeFactory.create("rectangle", width=4, height=6)
print(f"Circle area: {circle.area():.2f}")
print(f"Rect area: {rect.area()}")
```

**ตัวอย่างการใช้งานจริง — Config Class:**
```python
from typing import Any
from pathlib import Path
import json
import os

class Config:
    """Configuration ที่ load จากหลาย sources"""

    def __init__(
        self,
        file_path: str | None = None,
        env_prefix: str = "APP_",
        **overrides: Any,
    ):
        self._data: dict[str, Any] = {}
        self._env_prefix = env_prefix

        # 1. Defaults
        self._data.update(self._defaults())

        # 2. จากไฟล์
        if file_path:
            self._load_file(file_path)

        # 3. จาก environment variables
        self._load_env()

        # 4. Overrides (สูงสุด)
        self._data.update(overrides)

        self._validate()

    def _defaults(self) -> dict[str, Any]:
        return {
            "debug": False,
            "host": "localhost",
            "port": 8000,
        }

    def _load_file(self, path: str) -> None:
        with open(path, encoding="utf-8") as f:
            self._data.update(json.load(f))

    def _load_env(self) -> None:
        for key, value in os.environ.items():
            if key.startswith(self._env_prefix):
                config_key = key[len(self._env_prefix):].lower()
                self._data[config_key] = value

    def _validate(self) -> None:
        if not isinstance(self._data["port"], int):
            try:
                self._data["port"] = int(self._data["port"])
            except ValueError:
                raise ValueError("port ต้องเป็น integer")

    def get(self, key: str, default: Any = None) -> Any:
        return self._data.get(key, default)

    def __getitem__(self, key: str) -> Any:
        return self._data[key]

    def __repr__(self) -> str:
        return f"Config({self._data})"

# การใช้งาน
config = Config(debug=True, port=9000)
print(config["port"])    # 9000
print(config.get("host"))  # localhost
```

### 5.3.4 ข้อดี

- **Initialization:** ตั้งค่า state เริ่มต้น
- **Validation:** ตรวจสอบ inputs
- **Multiple ways:** สร้างได้หลายวิธี
- **Override:** `__new__` สำหรับ special cases

### 5.3.5 ข้อเสีย

- **Performance:** validation มี overhead
- **Complexity:** หลาย constructors อาจสับสน
- **`__new__` ซับซ้อน:** ต้องเข้าใจ low-level

### 5.3.6 ข้อควรระวัง

```python
# ระวัง 1: return ใน __init__
class Bad:
    def __init__(self):
        return 42  # ❌ TypeError: __init__ should return None

# ระวัง 2: การเรียก parent __init__
class Parent:
    def __init__(self, x):
        self.x = x

class Child(Parent):
    def __init__(self, x, y):
        # ❌ ลืม super().__init__(x)
        self.y = y
        # child.x จะไม่มี

# ✅ ถูก
class Child(Parent):
    def __init__(self, x, y):
        super().__init__(x)
        self.y = y

# ระวัง 3: dataclass กับ inheritance
from dataclasses import dataclass

@dataclass
class Base:
    a: int = 0
    b: int = 0

@dataclass
class Derived(Base):
    c: int = 0
    # ✅ fields ที่มี default ต้องอยู่หลัง

# ระวัง 4: Singleton ที่ __init__ ถูกเรียกทุกครั้ง
# ต้องเช็ค flag

# ระวัง 5: mutable default ใน __init__
# ❌
def __init__(self, items=[]):  # shared!
    self.items = items

# ✅
def __init__(self, items=None):
    self.items = items if items is not None else []
```

### 5.3.7 สรุป

**Best practices:**
- ใช้ `__init__` สำหรับ initialize
- Validate inputs ทันที
- ใช้ `@classmethod` สำหรับ alternative constructors
- ใช้ `__new__` สำหรับ singleton/caching/immutable
- `super().__init__()` เสมอใน subclass
- หลีกเลี่ยง mutable defaults

> **อ้างอิงเพิ่มเติม:** [__init__ Documentation](https://docs.python.org/3/reference/datamodel.html#object.__init__), [__new__ Documentation](https://docs.python.org/3/reference/datamodel.html#object.__new__)

---

## 5.4 Destructor

### บทนำ

Destructor ใช้สำหรับ cleanup resources เมื่อ object ถูกทำลาย Python มี garbage collection อัตโนมัติ แต่บางกรณีต้อง cleanup เอง เช่น ไฟล์, connections

### นิยาม

- `__del__()` — destructor ที่ถูกเรียกเมื่อ object กำลังถูกทำลาย
- `__enter__`/`__exit__` — context manager สำหรับ `with`

### 5.4.1 คืออะไร

`__del__` ไม่ควรใช้เป็นหลัก เพราะ:
- ไม่การันตีว่าเรียกเมื่อไหร่
- อาจไม่เรียกเลยตอน interpreter shutdown
- ไม่ควรใช้กับ critical resources

**แนะนำ:** ใช้ context manager (`with`) หรือ explicit `close()`

### 5.4.2 ทำงานอย่างไร

`__del__` ถูกเรียกเมื่อ:
- Reference count = 0
- ก่อน GC ลบ object ที่อยู่ใน cycle

แต่ไม่ควรพึ่งพา

### 5.4.3 การใช้งาน

**Destructor พื้นฐาน:**
```python
class Resource:
    def __init__(self, name: str):
        self.name = name
        print(f"เปิด {name}")

    def __del__(self):
        print(f"ปิด {self.name}")

r = Resource("file.txt")
del r  # เรียก __del__ ทันที
```

**Context Manager (แนะนำ):**
```python
class DatabaseConnection:
    def __init__(self, host: str, port: int):
        self.host = host
        self.port = port
        self.connected = False

    def __enter__(self):
        print(f"เชื่อมต่อ {self.host}:{self.port}")
        self.connected = True
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        print(f"ปิด connection")
        self.connected = False
        # return False เพื่อให้ exception propagate
        return False

    def execute(self, query: str):
        if not self.connected:
            raise RuntimeError("ยังไม่เชื่อมต่อ")
        print(f"Execute: {query}")

# ใช้งาน — ปิดอัตโนมัติเสมอ
with DatabaseConnection("localhost", 5432) as conn:
    conn.execute("SELECT * FROM users")
# ปิดอัตโนมัติเมื่อออกจาก block
```

**`contextlib.contextmanager` (ทางเลือกที่สะอาด):**
```python
from contextlib import contextmanager
from typing import Iterator
import time

@contextmanager
def timer(name: str) -> Iterator[None]:
    start = time.perf_counter()
    try:
        yield
    finally:
        elapsed = time.perf_counter() - start
        print(f"{name}: {elapsed:.4f}s")

# การใช้งาน
with timer("คำนวณ"):
    total = sum(i ** 2 for i in range(1000000))
```

**ตัวอย่างการใช้งานจริง — File Handler:**
```python
from pathlib import Path
from typing import TextIO
import csv

class CSVWriter:
    def __init__(self, path: str, fieldnames: list[str]):
        self.path = path
        self.fieldnames = fieldnames
        self.file: TextIO | None = None
        self.writer = None

    def __enter__(self):
        self.file = open(self.path, "w", encoding="utf-8", newline="")
        self.writer = csv.DictWriter(self.file, fieldnames=self.fieldnames)
        self.writer.writeheader()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.file:
            self.file.close()
        return False

    def write(self, row: dict) -> None:
        if not self.writer:
            raise RuntimeError("ใช้ CSVWriter ผ่าน 'with' เท่านั้น")
        self.writer.writerow(row)

# การใช้งาน
data = [
    {"name": "สมชาย", "score": 85},
    {"name": "สมหญิง", "score": 92},
]

with CSVWriter("scores.csv", ["name", "score"]) as writer:
    for row in data:
        writer.write(row)
# ไฟล์ถูกปิดอัตโนมัติ
```

**`__del__` สำหรับ Logging:**
```python
class TrackedResource:
    def __init__(self, name: str):
        self.name = name

    def __del__(self):
        # ❌ ไม่ควรใช้กับ critical resources
        # ✅ OK สำหรับ logging/testing
        try:
            print(f"[DEBUG] {self.name} ถูกลบ")
        except Exception:
            pass  # อย่า raise ใน __del__

# ระวัง: ไม่ควรใช้กับ:
# - ไฟล์ (ใช้ with)
# - Network connections (ใช้ with)
# - Locks (ใช้ with)
# - Database (ใช้ connection pool)
```

**Resource Management ด้วย `contextlib.ExitStack`:**
```python
from contextlib import ExitStack

def process_multiple_files(file_paths: list[str]) -> None:
    """เปิดหลายไฟล์พร้อมกัน"""
    with ExitStack() as stack:
        files = [
            stack.enter_context(open(path, encoding="utf-8"))
            for path in file_paths
        ]

        for f in files:
            content = f.read()
            print(f"{f.name}: {len(content)} chars")
    # ทุกไฟล์ปิดอัตโนมัติ
```

### 5.4.4 ข้อดี (Context Manager)

- **การันตี:** `__exit__` ถูกเรียกเสมอ
- **Exception-safe:** ทำงานแม้มี exception
- **ชัดเจน:** `with` block ชัดเจน
- **Composable:** `ExitStack` สำหรับหลาย resources

### 5.4.5 ข้อเสีย

- **`__del__` ไม่น่าเชื่อถือ:** ไม่การันตี
- **Complexity:** ต้อง implement `__enter__`/`__exit__`

### 5.4.6 ข้อควรระวัง

```python
# ระวัง 1: __del__ ไม่การันตีเวลา
class R:
    def __del__(self):
        print("del")

r = R()
# ไม่รู้ว่า "del" จะพิมพ์เมื่อไหร่

# ระวัง 2: Exception ใน __del__
class Bad:
    def __del__(self):
        raise RuntimeError("error")  # ❌ ignore แต่ noisy

# ระวัง 3: Circular references
class Node:
    def __init__(self):
        self.ref = None

a, b = Node(), Node()
a.ref = b
b.ref = a
# __del__ อาจไม่ถูกเรียกเพราะ cycle
# GC จัดการ แต่ __del__ มีปัญหา

# ระวัง 4: อย่าใช้ __del__ สำหรับ critical cleanup
# ใช้ with หรือ try/finally แทน

# ✅ ถูกต้อง
try:
    resource = acquire()
    use(resource)
finally:
    resource.release()
```

### 5.4.7 สรุป

**ใช้ context manager (`with`):**
- ไฟล์, network connections
- Locks, semaphores
- Database transactions
- Temporary changes (env vars, cwd)
- Timers

**หลีกเลี่ยง `__del__`:**
- ไม่การันตีเวลาเรียก
- ไม่ควรใช้กับ critical resources

**Implementation options:**
- `__enter__`/`__exit__` — full control
- `@contextmanager` — สั้นกว่า
- `ExitStack` — สำหรับ dynamic resources

> **อ้างอิงเพิ่มเติม:** [Context Manager Protocol](https://docs.python.org/3/reference/datamodel.html#with-statement-context-managers), [contextlib Documentation](https://docs.python.org/3/library/contextlib.html)

---

## 5.5 Inheritance

### บทนำ

Inheritance เป็นกลไกที่ช่วย reuse โค้ดและสร้างความสัมพันธ์แบบ "is-a" ระหว่าง classes ช่วยลด duplication และ extend functionality

### นิยาม

Inheritance คือกลไกที่ class หนึ่ง (subclass/derived) สืบทอด attributes และ methods จาก class อื่น (superclass/base)

### 5.5.1 คืออะไร

ความสัมพันธ์:
- **IS-A:** Dog IS-A Animal → inheritance
- **HAS-A:** Car HAS-A Engine → composition

### 5.5.2 ทำงานอย่างไร

Method Resolution Order (MRO) กำหนดลำดับการค้นหา methods:
```python
class A: pass
class B(A): pass
class C(A): pass
class D(B, C): pass

print(D.__mro__)
# (D, B, C, A, object)
```

### 5.5.3 การใช้งาน

**Single Inheritance:**
```python
class Animal:
    def __init__(self, name: str, sound: str):
        self.name = name
        self.sound = sound

    def speak(self) -> str:
        return f"{self.name} says {self.sound}"

    def eat(self) -> str:
        return f"{self.name} is eating"


class Dog(Animal):
    def __init__(self, name: str):
        super().__init__(name, "Woof")

    def fetch(self) -> str:
        return f"{self.name} is fetching"


class Cat(Animal):
    def __init__(self, name: str):
        super().__init__(name, "Meow")

    def scratch(self) -> str:
        return f"{self.name} is scratching"


dog = Dog("Buddy")
cat = Cat("Whiskers")

print(dog.speak())    # Buddy says Woof
print(cat.speak())    # Whiskers says Meow
print(dog.fetch())    # Buddy is fetching
print(cat.scratch())  # Whiskers is scratching

# IS-A check
print(isinstance(dog, Animal))  # True
print(issubclass(Dog, Animal))  # True
```

**Multiple Inheritance:**
```python
class Flyable:
    def fly(self) -> str:
        return "Flying"


class Swimmable:
    def swim(self) -> str:
        return "Swimming"


class Duck(Animal, Flyable, Swimmable):
    def __init__(self, name: str):
        super().__init__(name, "Quack")

    def move(self) -> str:
        return "Waddling"


duck = Duck("Donald")
print(duck.speak())  # Donald says Quack
print(duck.fly())    # Flying
print(duck.swim())   # Swimming

print(Duck.__mro__)
# (Duck, Animal, Flyable, Swimmable, object)
```

**Method Overriding:**
```python
class Shape:
    def area(self) -> float:
        raise NotImplementedError

    def describe(self) -> str:
        return f"This is a {self.__class__.__name__} with area {self.area():.2f}"


class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius

    def area(self) -> float:
        import math
        return math.pi * self.radius ** 2

    def describe(self) -> str:
        # เรียก parent
        base = super().describe()
        return f"{base} (radius={self.radius})"


class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height

    def area(self) -> float:
        return self.width * self.height


# Polymorphism — ใช้ interface เดียวกัน
shapes = [Circle(5), Rectangle(4, 6), Circle(3)]
for shape in shapes:
    print(shape.describe())
```

**`super()` ใน Multiple Inheritance:**
```python
class Base:
    def __init__(self):
        print("Base.__init__")
        super().__init__()


class Mixin1(Base):
    def __init__(self):
        print("Mixin1.__init__")
        super().__init__()


class Mixin2(Base):
    def __init__(self):
        print("Mixin2.__init__")
        super().__init__()


class Combined(Mixin1, Mixin2):
    def __init__(self):
        print("Combined.__init__")
        super().__init__()


obj = Combined()
# Combined.__init__
# Mixin1.__init__
# Mixin2.__init__
# Base.__init__
```

**Abstract Base Class:**
```python
from abc import ABC, abstractmethod

class PaymentProcessor(ABC):
    @abstractmethod
    def process(self, amount: float) -> bool:
        """Process a payment"""
        pass

    @abstractmethod
    def refund(self, transaction_id: str) -> bool:
        pass

    def log_transaction(self, info: str) -> None:
        """Concrete method ที่ใช้ร่วมกัน"""
        print(f"[LOG] {info}")


class StripeProcessor(PaymentProcessor):
    def process(self, amount: float) -> bool:
        self.log_transaction(f"Stripe: charge ${amount}")
        return True

    def refund(self, transaction_id: str) -> bool:
        self.log_transaction(f"Stripe: refund {transaction_id}")
        return True


class PayPalProcessor(PaymentProcessor):
    def process(self, amount: float) -> bool:
        self.log_transaction(f"PayPal: charge ${amount}")
        return True

    def refund(self, transaction_id: str) -> bool:
        self.log_transaction(f"PayPal: refund {transaction_id}")
        return True


# ❌ ไม่สามารถ instantiate abstract class
# processor = PaymentProcessor()  # TypeError

# ✅ ใช้ concrete classes
processors = [StripeProcessor(), PayPalProcessor()]
for p in processors:
    p.process(99.99)
```

**ตัวอย่างการใช้งานจริง — Repository Pattern:**
```python
from abc import ABC, abstractmethod
from typing import Generic, TypeVar, Optional
from dataclasses import dataclass, field
from uuid import UUID, uuid4

T = TypeVar("T")
ID = TypeVar("ID")

@dataclass
class User:
    id: UUID = field(default_factory=uuid4)
    username: str = ""
    email: str = ""


class Repository(ABC, Generic[T, ID]):
    """Generic repository interface"""

    @abstractmethod
    def find_by_id(self, id: ID) -> Optional[T]:
        pass

    @abstractmethod
    def save(self, entity: T) -> T:
        pass

    @abstractmethod
    def delete(self, id: ID) -> bool:
        pass

    @abstractmethod
    def find_all(self) -> list[T]:
        pass


class InMemoryUserRepository(Repository[User, UUID]):
    def __init__(self):
        self._store: dict[UUID, User] = {}

    def find_by_id(self, id: UUID) -> Optional[User]:
        return self._store.get(id)

    def save(self, entity: User) -> User:
        self._store[entity.id] = entity
        return entity

    def delete(self, id: UUID) -> bool:
        return self._store.pop(id, None) is not None

    def find_all(self) -> list[User]:
        return list(self._store.values())


# การใช้งาน
repo = InMemoryUserRepository()
user = User(username="somchai", email="somchai@email.com")
saved = repo.save(user)

print(repo.find_by_id(saved.id))
print(len(repo.find_all()))
```

### 5.5.4 ข้อดี

- **Reusability:** ใช้โค้ดซ้ำ
- **Polymorphism:** interface เดียว หลาย implementations
- **Organization:** จัดกลุ่ม classes
- **Extensibility:** extend โดยไม่แก้ base

### 5.5.5 ข้อเสีย

- **Tight coupling:** subclass ผูกกับ base
- **Fragile base class:** เปลี่ยน base กระทบ subclass
- **Deep hierarchies:** ยาก maintain
- **Diamond problem:** multiple inheritance ซับซ้อน

### 5.5.6 ข้อควรระวัง

```python
# ระวัง 1: Favor composition over inheritance
# ❌ inheritance สำหรับ "has-a"
class Car(Engine):  # ผิด — car ไม่ใช่ engine
    pass

# ✅ composition
class Car:
    def __init__(self):
        self.engine = Engine()

# ระวัง 2: Liskov Substitution Principle
# Subclass ต้องใช้แทน base ได้
class Bird:
    def fly(self):
        return "flying"

class Penguin(Bird):  # ❌ penguin บินไม่ได้
    def fly(self):
        raise NotImplementedError

# ✅ แยก class
class Bird:
    pass

class FlyingBird(Bird):
    def fly(self):
        return "flying"

class Penguin(Bird):
    def swim(self):
        return "swimming"

# ระวัง 3: super() กับ multiple inheritance
class A:
    def __init__(self):
        super().__init__()
        print("A")

class B:
    def __init__(self):
        super().__init__()
        print("B")

class C(A, B):
    def __init__(self):
        super().__init__()
        print("C")

# ลำดับ: C → A → B → object
c = C()  # พิมพ์: B, A, C (reverse)

# ระวัง 4: Abstract methods ไม่ได้บังคับใน Python
# ใช้ ABC สำหรับ enforcement

# ระวัง 5: __init__ ไม่ auto-call
class Parent:
    def __init__(self, x):
        self.x = x

class Child(Parent):
    def __init__(self, x, y):
        # ❌ ลืม super().__init__(x)
        self.y = y
```

### 5.5.7 สรุป

**ใช้ inheritance เมื่อ:**
- IS-A relationship ชัดเจน
- ต้องการ polymorphism
- ต้องการ reuse behavior

**ใช้ composition เมื่อ:**
- HAS-A relationship
- ต้องการ flexibility
- หลีกเลี่ยง tight coupling

**Best practices:**
- Favor composition
- หลีกเลี่ยง deep hierarchies
- ใช้ ABC สำหรับ interfaces
- ใช้ `super()` สม่ำเสมอ
- เข้าใจ MRO

> **อ้างอิงเพิ่มเติม:** [Inheritance Documentation](https://docs.python.org/3/tutorial/classes.html#inheritance), [ABC Documentation](https://docs.python.org/3/library/abc.html)

---

## 5.6 Polymorphism

### บทนำ

Polymorphism เป็นความสามารถของ objects ที่แตกต่างกันในการตอบสนองต่อ method call เดียวกัน ช่วยให้เขียนโค้ดที่ยืดหยุ่นและ extensible

### นิยาม

Polymorphism (จาก Greek: "many forms") คือความสามารถของ objects ต่าง classes ในการใช้ interface เดียวกัน

### 5.6.1 คืออะไร

**ประเภท:**
- **Compile-time (static):** Method overloading (Python ไม่รองรับโดยตรง)
- **Runtime (dynamic):** Method overriding
- **Duck typing:** ถ้าเดินเหมือนเป็ด... (Python's approach)

### 5.6.2 ทำงานอย่างไร

Python ใช้ dynamic dispatch — ตัดสินใจตอน runtime ว่า method ไหนจะเรียก ตาม type ของ object

**Duck Typing:**
"If it walks like a duck and quacks like a duck, it's a duck."

### 5.6.3 การใช้งาน

**Runtime Polymorphism (Overriding):**
```python
from abc import ABC, abstractmethod
from typing import Protocol

class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        pass

    @abstractmethod
    def perimeter(self) -> float:
        pass

    def describe(self) -> str:
        return (
            f"{self.__class__.__name__}: "
            f"area={self.area():.2f}, "
            f"perimeter={self.perimeter():.2f}"
        )


class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius

    def area(self) -> float:
        import math
        return math.pi * self.radius ** 2

    def perimeter(self) -> float:
        import math
        return 2 * math.pi * self.radius


class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height

    def area(self) -> float:
        return self.width * self.height

    def perimeter(self) -> float:
        return 2 * (self.width + self.height)


class Triangle(Shape):
    def __init__(self, a: float, b: float, c: float):
        self.a = a
        self.b = b
        self.c = c

    def area(self) -> float:
        s = (self.a + self.b + self.c) / 2
        return (s * (s - self.a) * (s - self.b) * (s - self.c)) ** 0.5

    def perimeter(self) -> float:
        return self.a + self.b + self.c


# Polymorphism — ใช้ interface เดียวกัน
def print_shape_info(shapes: list[Shape]) -> None:
    for shape in shapes:
        print(shape.describe())


shapes = [
    Circle(5),
    Rectangle(4, 6),
    Triangle(3, 4, 5),
]
print_shape_info(shapes)
```

**Duck Typing:**
```python
class FileWriter:
    def write(self, data: str) -> None:
        print(f"Writing to file: {data}")


class ConsoleWriter:
    def write(self, data: str) -> None:
        print(f">> {data}")


class NetworkWriter:
    def write(self, data: str) -> None:
        print(f"Sending over network: {data}")


def log(writer, message: str) -> None:
    """ไม่สนใจ type แค่มี write() ก็พอ"""
    writer.write(f"[LOG] {message}")


# ทำงานได้กับทุก writer
log(FileWriter(), "test")
log(ConsoleWriter(), "test")
log(NetworkWriter(), "test")
```

**Protocol (Structural Subtyping):**
```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class Drawable(Protocol):
    def draw(self) -> str:
        ...


class Circle:
    def draw(self) -> str:
        return "Drawing circle"


class Square:
    def draw(self) -> str:
        return "Drawing square"


class NotDrawable:
    def something_else(self):
        return "nope"


def render(item: Drawable) -> None:
    print(item.draw())


render(Circle())
render(Square())
# render(NotDrawable())  # ❌ type error (แต่ทำงานได้ตอน runtime)

# Runtime check
print(isinstance(Circle(), Drawable))   # True
print(isinstance(NotDrawable(), Drawable))  # False
```

**Method Overloading (Python-style):**
```python
from functools import singledispatch
from typing import Union, overload

# Python ไม่รองรับ overloading โดยตรง
# ใช้ default arguments หรือ type checking

def greet(name, greeting="Hello"):
    return f"{greeting}, {name}!"

print(greet("World"))                # Hello, World!
print(greet("World", "Hi"))          # Hi, World!

# ใช้ singledispatch (Python 3.4+)
@singledispatch
def process(value):
    raise NotImplementedError(f"ไม่รองรับ {type(value)}")

@process.register(int)
def _(value: int):
    return f"Integer: {value}"

@process.register(str)
def _(value: str):
    return f"String: {value}"

@process.register(list)
def _(value: list):
    return f"List with {len(value)} items"

print(process(42))            # Integer: 42
print(process("hello"))       # String: hello
print(process([1, 2, 3]))     # List with 3 items

# Type hints + Union
def format_value(value: Union[int, float, str]) -> str:
    if isinstance(value, (int, float)):
        return f"{value:,.2f}"
    return value
```

**Operator Overloading:**
```python
from typing import Self

class Vector:
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y

    def __add__(self, other: Self) -> Self:
        return Vector(self.x + other.x, self.y + other.y)

    def __sub__(self, other: Self) -> Self:
        return Vector(self.x - other.x, self.y - other.y)

    def __mul__(self, scalar: float) -> Self:
        return Vector(self.x * scalar, self.y * scalar)

    def __rmul__(self, scalar: float) -> Self:
        return self * scalar

    def __abs__(self) -> float:
        return (self.x ** 2 + self.y ** 2) ** 0.5

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Vector):
            return NotImplemented
        return self.x == other.x and self.y == other.y

    def __repr__(self) -> str:
        return f"Vector({self.x}, {self.y})"


v1 = Vector(1, 2)
v2 = Vector(3, 4)

print(v1 + v2)      # Vector(4, 6)
print(v2 - v1)      # Vector(2, 2)
print(v1 * 2)       # Vector(2, 4)
print(2 * v1)       # Vector(2, 4) — __rmul__
print(abs(v1))      # 2.236...
```

**ตัวอย่างการใช้งานจริง — Plugin System:**
```python
from abc import ABC, abstractmethod
from typing import Any

class Plugin(ABC):
    """Plugin interface"""

    @property
    @abstractmethod
    def name(self) -> str:
        pass

    @abstractmethod
    def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        pass


class ValidationPlugin(Plugin):
    @property
    def name(self) -> str:
        return "validator"

    def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        errors = []
        if "email" not in data:
            errors.append("missing email")
        return {"valid": len(errors) == 0, "errors": errors}


class EnrichmentPlugin(Plugin):
    @property
    def name(self) -> str:
        return "enricher"

    def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        data["enriched"] = True
        data["source"] = "enrichment"
        return data


class LoggingPlugin(Plugin):
    @property
    def name(self) -> str:
        return "logger"

    def execute(self, data: dict[str, Any]) -> dict[str, Any]:
        print(f"[LOG] Processing: {data}")
        return data


class Pipeline:
    def __init__(self):
        self.plugins: list[Plugin] = []

    def register(self, plugin: Plugin) -> None:
        self.plugins.append(plugin)

    def run(self, data: dict[str, Any]) -> dict[str, Any]:
        for plugin in self.plugins:
            print(f"Running plugin: {plugin.name}")
            data = plugin.execute(data)
        return data


# การใช้งาน
pipeline = Pipeline()
pipeline.register(LoggingPlugin())
pipeline.register(ValidationPlugin())
pipeline.register(EnrichmentPlugin())

result = pipeline.run({"email": "test@example.com"})
print(result)
```

### 5.6.4 ข้อดี

- **Flexible:** ใช้ interface เดียวกัน
- **Extensible:** เพิ่ม types ใหม่ได้
- **Decoupled:** clients ไม่ผูกกับ types
- **Duck typing:** ยืดหยุ่นกว่า static typing

### 5.6.5 ข้อเสีย

- **Runtime errors:** type errors เกิดตอน runtime
- **Debugging:** ยากกว่า static typing
- **Documentation:** ต้อง document ชัดเจน
- **IDE support:** น้อยกว่า static typing

### 5.6.6 ข้อควรระวัง

```python
# ระวัง 1: Duck typing อาจ mask bugs
def process(item):
    return item.process()  # ถ้า item ไม่มี process() → AttributeError

# ✅ เพิ่ม type hints + validation
def process(item: "Processor") -> Any:
    return item.process()

# ระวัง 2: isinstance สำหรับ polymorphism
# ❌ แทน polymorphism
def area(shape):
    if isinstance(shape, Circle):
        return 3.14 * shape.r ** 2
    elif isinstance(shape, Rectangle):
        return shape.w * shape.h

# ✅ ใช้ polymorphism
def area(shape: Shape):
    return shape.area()

# ระวัง 3: Overloading ไม่มีจริงใน Python
# ต้องใช้ default args, *args, หรือ singledispatch

# ระวัง 4: Protocol vs ABC
# Protocol = structural (duck typing + type hints)
# ABC = nominal (ต้อง inherit)
```

### 5.6.7 สรุป

**Polymorphism ใน Python:**
- **Duck typing:** ไม่สนใจ type, สนใจ behavior
- **Method overriding:** subclass แทน method ของ base
- **Protocol:** structural subtyping ที่ type-check ได้
- **ABC:** interfaces ที่บังคับ
- **Operator overloading:** dunder methods
- **singledispatch:** function overloading

**Best practices:**
- ใช้ polymorphism แทน type checking
- ใช้ Protocol สำหรับ interfaces
- ใช้ `singledispatch` สำหรับ function overloading
- ใช้ type hints เพื่อ document interface

> **อ้างอิงเพิ่มเติม:** [Polymorphism](https://docs.python.org/3/tutorial/classes.html#inheritance), [Protocol Documentation](https://docs.python.org/3/library/typing.html#typing.Protocol)

---

## 5.7 Encapsulation

### บทนำ

Encapsulation คือการซ่อน internal state และบังคับให้เข้าถึงผ่าน public interface ช่วยป้องกันการแก้ไขที่ไม่เหมาะสมและรักษา invariants

### นิยาม

Encapsulation คือการรวม data และ methods ไว้ด้วยกัน พร้อมจำกัดการเข้าถึงจากภายนอก

### 5.7.1 คืออะไร

Python ไม่มี access modifiers จริง (เช่น `private` ใน Java) ใช้ conventions:
- `public` — เข้าถึงได้ทั่วไป
- `_protected` — convention: ใช้ภายใน class/module
- `__private` — name mangling: `_ClassName__private`
- `__dunder__` — special methods

**ปรัชญา Python:** "We are all consenting adults here" — เชื่อใจนักพัฒนา

### 5.7.2 ทำงานอย่างไร

**Name mangling:** `__name` → `_ClassName__name`

### 5.7.3 การใช้งาน

**Convention levels:**
```python
class BankAccount:
    def __init__(self, owner: str, balance: float):
        self.owner = owner              # public
        self._balance = balance          # protected
        self.__pin = "0000"              # private (mangled)

    def get_balance(self) -> float:
        return self._balance

    def _log_transaction(self, msg: str) -> None:
        """Internal method"""
        print(f"[LOG] {msg}")

    def __verify_pin(self, pin: str) -> bool:
        """Private method"""
        return pin == self.__pin

    def withdraw(self, pin: str, amount: float) -> bool:
        if not self.__verify_pin(pin):
            self._log_transaction("Invalid PIN")
            return False
        if amount > self._balance:
            self._log_transaction("Insufficient funds")
            return False
        self._balance -= amount
        self._log_transaction(f"Withdrew {amount}")
        return True


acc = BankAccount("สมชาย", 1000)
print(acc.owner)          # ✅ public
print(acc._balance)       # ⚠️ เข้าถึงได้ (แต่ไม่ควร)
# print(acc.__pin)        # ❌ AttributeError
print(acc._BankAccount__pin)  # ⚠️ เข้าถึงได้ผ่าน mangled name
```

**Property for Encapsulation:**
```python
class Temperature:
    def __init__(self, celsius: float = 0):
        self._celsius = 0
        self.celsius = celsius  # ผ่าน setter

    @property
    def celsius(self) -> float:
        """Read-only access"""
        return self._celsius

    @celsius.setter
    def celsius(self, value: float) -> None:
        """Validation"""
        if value < -273.15:
            raise ValueError("ต่ำกว่าศูนย์สัมบูรณ์")
        self._celsius = value

    @property
    def fahrenheit(self) -> float:
        """Computed property"""
        return self._celsius * 9 / 5 + 32

    @fahrenheit.setter
    def fahrenheit(self, value: float) -> None:
        self.celsius = (value - 32) * 5 / 9


temp = Temperature(25)
print(temp.celsius)     # 25
print(temp.fahrenheit)  # 77.0
temp.fahrenheit = 100
print(temp.celsius)     # 37.78
```

**Read-Only Properties:**
```python
class Person:
    def __init__(self, name: str, birth_year: int):
        self._name = name
        self._birth_year = birth_year

    @property
    def name(self) -> str:
        return self._name

    @property
    def birth_year(self) -> int:
        return self._birth_year

    @property
    def age(self) -> int:
        from datetime import datetime
        return datetime.now().year - self._birth_year


p = Person("สมชาย", 1990)
# p.name = "ใหม่"  # ❌ AttributeError: can't set attribute
```

**`__slots__` สำหรับ Performance + Encapsulation:**
```python
class Point:
    __slots__ = ("_x", "_y")

    def __init__(self, x: float, y: float):
        self._x = x
        self._y = y

    @property
    def x(self) -> float:
        return self._x

    @property
    def y(self) -> float:
        return self._y

# ประโยชน์:
# 1. ป้องกันการเพิ่ม attributes แบบ dynamic
# 2. ลด memory (ไม่มี __dict__)
# 3. เร็วกว่า

p = Point(1, 2)
# p.z = 3  # ❌ AttributeError

import sys
print(sys.getsizeof(p))  # เล็กกว่า class ปกติ
```

**ตัวอย่างการใช้งานจริง — Money Class:**
```python
from decimal import Decimal, ROUND_HALF_UP
from typing import Self
from dataclasses import dataclass

@dataclass(frozen=True)
class Money:
    """Immutable money value object"""

    amount: Decimal
    currency: str

    def __post_init__(self):
        # Validate
        if not isinstance(self.amount, Decimal):
            object.__setattr__(
                self,
                "amount",
                Decimal(str(self.amount)).quantize(
                    Decimal("0.01"), rounding=ROUND_HALF_UP
                ),
            )
        if len(self.currency) != 3:
            raise ValueError("Currency ต้องเป็น 3-letter code")
        object.__setattr__(self, "currency", self.currency.upper())

    def __add__(self, other: Self) -> Self:
        if self.currency != other.currency:
            raise ValueError(f"ไม่สามารถบวก {self.currency} กับ {other.currency}")
        return Money(self.amount + other.amount, self.currency)

    def __sub__(self, other: Self) -> Self:
        if self.currency != other.currency:
            raise ValueError(f"ไม่สามารถลบ {self.currency} กับ {other.currency}")
        return Money(self.amount - other.amount, self.currency)

    def __mul__(self, factor: float) -> Self:
        return Money(
            (self.amount * Decimal(str(factor))).quantize(
                Decimal("0.01"), rounding=ROUND_HALF_UP
            ),
            self.currency,
        )

    def __str__(self) -> str:
        return f"{self.amount:,.2f} {self.currency}"


# การใช้งาน
price = Money(Decimal("29.99"), "USD")
tax = Money(Decimal("2.40"), "USD")
total = price + tax
print(total)  # 32.39 USD

# ❌ ไม่สามารถแก้ได้ (frozen)
# total.amount = Decimal("0")  # FrozenInstanceError
```

**ตัวอย่าง — State Machine ที่มี Encapsulation:**
```python
from enum import Enum, auto

class OrderState(Enum):
    PENDING = auto()
    PAID = auto()
    SHIPPED = auto()
    DELIVERED = auto()
    CANCELLED = auto()


class Order:
    # State transitions
    _valid_transitions = {
        OrderState.PENDING: {OrderState.PAID, OrderState.CANCELLED},
        OrderState.PAID: {OrderState.SHIPPED, OrderState.CANCELLED},
        OrderState.SHIPPED: {OrderState.DELIVERED},
        OrderState.DELIVERED: set(),
        OrderState.CANCELLED: set(),
    }

    def __init__(self, order_id: str, total: float):
        self._id = order_id
        self._total = total
        self._state = OrderState.PENDING

    @property
    def id(self) -> str:
        return self._id

    @property
    def total(self) -> float:
        return self._total

    @property
    def state(self) -> OrderState:
        return self._state

    def _transition_to(self, new_state: OrderState) -> None:
        """Private — ห้ามเรียกจากภายนอก"""
        valid = self._valid_transitions[self._state]
        if new_state not in valid:
            raise ValueError(
                f"ไม่สามารถเปลี่ยนจาก {self._state.name} เป็น {new_state.name}"
            )
        self._state = new_state

    def pay(self) -> None:
        self._transition_to(OrderState.PAID)

    def ship(self) -> None:
        self._transition_to(OrderState.SHIPPED)

    def deliver(self) -> None:
        self._transition_to(OrderState.DELIVERED)

    def cancel(self) -> None:
        self._transition_to(OrderState.CANCELLED)


# การใช้งาน
order = Order("ORD-001", 1000)
print(order.state)  # OrderState.PENDING

order.pay()
print(order.state)  # OrderState.PAID

order.ship()
print(order.state)  # OrderState.SHIPPED

# ❌ ไม่สามารถทำได้
# order._transition_to(OrderState.PENDING)  # แต่ convention บอกว่าไม่ควร
```

### 5.7.4 ข้อดี

- **Data integrity:** ป้องกันการแก้ไขผิด
- **Abstraction:** ซ่อน implementation
- **Maintainability:** เปลี่ยน internals ได้
- **Clear interface:** public API ชัดเจน

### 5.7.5 ข้อเสีย

- **Convention only:** ไม่บังคับจริง
- **Overhead:** property มี overhead
- **Learning curve:** ต้องเข้าใจ conventions
- **ไม่ใช่ security:** ไม่ใช่ security mechanism

### 5.7.6 ข้อควรระวัง

```python
# ระวัง 1: Python ไม่มี private จริง
class MyClass:
    def __init__(self):
        self.__secret = 42

obj = MyClass()
# print(obj.__secret)              # ❌ AttributeError
print(obj._MyClass__secret)         # ✅ 42 — เข้าถึงได้

# ระวัง 2: Name mangling ใน subclass
class Parent:
    def __init__(self):
        self.__value = 1

class Child(Parent):
    def get_parent_value(self):
        # return self.__value  # ❌ AttributeError
        return self._Parent__value  # ⚠️

# ระวัง 3: property ที่มี side effects
class Bad:
    @property
    def value(self):
        self.counter += 1  # ❌ side effect ใน property
        return self._value

# ระวัง 4: Encapsulation ≠ Security
# Python ไม่ใช่ secure language สำหรับ secrets
# ใช้ OS-level mechanisms

# ระวัง 5: อย่า over-encapsulate
# Python philosophy: pragmatic
# ใช้ property เมื่อต้องการ validation/computed
# ไม่ต้อง getter/setter สำหรับทุกอย่าง
```

### 5.7.7 สรุป

**Encapsulation ใน Python:**
- **Convention-based** ไม่ใช่ enforced
- **`_protected`** — ใช้ภายใน
- **`__private`** — name mangling
- **`@property`** — access control + validation
- **`__slots__`** — ป้องกัน dynamic attributes

**Best practices:**
- ใช้ `_` สำหรับ internal
- ใช้ `@property` สำหรับ computed attributes และ validation
- อย่า over-encapsulate
- หลีกเลี่ยง `__` ยกเว้นจำเป็น
- Trust other developers (Python philosophy)

> **อ้างอิงเพิ่มเติม:** [Private Variables](https://docs.python.org/3/tutorial/classes.html#private-variables), [Property Documentation](https://docs.python.org/3/library/functions.html#property)

---

## 5.8 Abstraction

### บทนำ

Abstraction คือการซ่อน complexity และแสดงเฉพาะสิ่งที่จำเป็น Abstraction แตกต่างจาก Encapsulation — abstraction จัดการกับ "what" (interface) ส่วน encapsulation จัดการกับ "how" (implementation)

### นิยาม

Abstraction คือการกำหนด interface ที่ชัดเจน โดยซ่อนรายละเอียดการทำงาน

### 5.8.1 คืออะไร

ใน Python มีหลายวิธี:
- **Abstract Base Class (ABC)** — บังคับให้ subclass implement
- **Protocol** — structural typing
- **Duck typing** — implicit interface

### 5.8.2 ทำงานอย่างไร

ABC ใช้ `abc` module:
- `@abstractmethod` — บังคับ implement
- `ABC` — base class
- instantiate ABC ไม่ได้ถ้ามี abstract methods

### 5.8.3 การใช้งาน

**Abstract Base Class:**
```python
from abc import ABC, abstractmethod
from typing import Iterator

class DataSource(ABC):
    """Abstract interface สำหรับ data source"""

    @abstractmethod
    def read(self) -> Iterator[dict]:
        """อ่านข้อมูล"""
        pass

    @abstractmethod
    def write(self, data: dict) -> None:
        """เขียนข้อมูล"""
        pass

    @property
    @abstractmethod
    def name(self) -> str:
        """ชื่อ source"""
        pass

    def process(self) -> int:
        """Concrete method ที่ใช้ abstract methods"""
        count = 0
        for item in self.read():
            self.write(item)
            count += 1
        return count


class CSVSource(DataSource):
    def __init__(self, path: str):
        self.path = path

    @property
    def name(self) -> str:
        return f"CSV({self.path})"

    def read(self) -> Iterator[dict]:
        import csv
        with open(self.path, encoding="utf-8") as f:
            yield from csv.DictReader(f)

    def write(self, data: dict) -> None:
        print(f"Writing: {data}")


class JSONSource(DataSource):
    def __init__(self, path: str):
        self.path = path

    @property
    def name(self) -> str:
        return f"JSON({self.path})"

    def read(self) -> Iterator[dict]:
        import json
        with open(self.path, encoding="utf-8") as f:
            data = json.load(f)
            yield from data

    def write(self, data: dict) -> None:
        print(f"Writing JSON: {data}")


# ❌ ไม่สามารถ instantiate ABC ที่มี abstract methods
# source = DataSource()  # TypeError

# ✅ ใช้ concrete subclasses
# csv = CSVSource("data.csv")
# for item in csv.read():
#     print(item)
```

**Abstract Properties และ Class Methods:**
```python
from abc import ABC, abstractmethod

class Repository(ABC):
    @property
    @abstractmethod
    def table_name(self) -> str:
        pass

    @classmethod
    @abstractmethod
    def from_connection(cls, conn) -> "Repository":
        pass

    @abstractmethod
    def find(self, id: int) -> dict | None:
        pass


class UserRepository(Repository):
    @property
    def table_name(self) -> str:
        return "users"

    @classmethod
    def from_connection(cls, conn) -> "UserRepository":
        return cls()

    def find(self, id: int) -> dict | None:
        return {"id": id, "name": "test"}
```

**Partial Implementation:**
```python
from abc import ABC, abstractmethod

class BaseProcessor(ABC):
    """Abstract class ที่มีบางส่วน implement แล้ว"""

    def process(self, data: str) -> str:
        """Template method — กำหนดโครงสร้าง"""
        cleaned = self.clean(data)
        validated = self.validate(cleaned)
        transformed = self.transform(validated)
        return self.format_output(transformed)

    @abstractmethod
    def clean(self, data: str) -> str:
        pass

    @abstractmethod
    def validate(self, data: str) -> str:
        pass

    @abstractmethod
    def transform(self, data: str) -> str:
        pass

    def format_output(self, data: str) -> str:
        """Default implementation"""
        return data.upper()


class EmailProcessor(BaseProcessor):
    def clean(self, data: str) -> str:
        return data.strip().lower()

    def validate(self, data: str) -> str:
        if "@" not in data:
            raise ValueError("Invalid email")
        return data

    def transform(self, data: str) -> str:
        user, domain = data.split("@")
        return f"{user[:3]}***@{domain}"


processor = EmailProcessor()
print(processor.process("  Test@Example.COM  "))
# TEST***@EXAMPLE.COM
```

**Virtual Subclass (register):**
```python
from abc import ABC, abstractmethod
from typing import Iterator

class Iterable(ABC):
    @abstractmethod
    def __iter__(self) -> Iterator:
        pass

# Register classes ที่ไม่ inherit
class MyCustomList:
    def __init__(self, items):
        self.items = items

    def __iter__(self):
        return iter(self.items)

# ทำให้ MyCustomList เป็น Iterable
Iterable.register(MyCustomList)

lst = MyCustomList([1, 2, 3])
print(isinstance(lst, Iterable))  # True
```

**ตัวอย่างการใช้งานจริง — Payment Gateway Abstraction:**
```python
from abc import ABC, abstractmethod
from dataclasses import dataclass
from decimal import Decimal
from typing import Optional

@dataclass
class PaymentResult:
    success: bool
    transaction_id: Optional[str] = None
    error: Optional[str] = None


class PaymentGateway(ABC):
    """Abstract payment gateway"""

    @abstractmethod
    def charge(self, amount: Decimal, currency: str) -> PaymentResult:
        pass

    @abstractmethod
    def refund(self, transaction_id: str) -> PaymentResult:
        pass

    @abstractmethod
    def supports_currency(self, currency: str) -> bool:
        pass


class StripeGateway(PaymentGateway):
    def charge(self, amount: Decimal, currency: str) -> PaymentResult:
        if not self.supports_currency(currency):
            return PaymentResult(False, error="Currency not supported")
        # Stripe API call...
        return PaymentResult(True, transaction_id="stripe_123")

    def refund(self, transaction_id: str) -> PaymentResult:
        # Stripe refund logic...
        return PaymentResult(True, transaction_id=transaction_id)

    def supports_currency(self, currency: str) -> bool:
        return currency in {"USD", "EUR", "GBP"}


class PromptPayGateway(PaymentGateway):
    def charge(self, amount: Decimal, currency: str) -> PaymentResult:
        if currency != "THB":
            return PaymentResult(False, error="PromptPay only supports THB")
        return PaymentResult(True, transaction_id="pp_456")

    def refund(self, transaction_id: str) -> PaymentResult:
        return PaymentResult(True, transaction_id=transaction_id)

    def supports_currency(self, currency: str) -> bool:
        return currency == "THB"


class PaymentService:
    """Service ที่ใช้ gateway — ไม่สนใจ implementation"""

    def __init__(self, gateways: list[PaymentGateway]):
        self.gateways = gateways

    def charge(
        self,
        amount: Decimal,
        currency: str,
    ) -> PaymentResult:
        for gateway in self.gateways:
            if gateway.supports_currency(currency):
                return gateway.charge(amount, currency)
        return PaymentResult(False, error="No gateway for currency")


# การใช้งาน — เพิ่ม gateway ใหม่ได้โดยไม่แก้ PaymentService
service = PaymentService([
    StripeGateway(),
    PromptPayGateway(),
])

print(service.charge(Decimal("100"), "USD"))  # Stripe
print(service.charge(Decimal("1000"), "THB"))  # PromptPay
```

### 5.8.4 ข้อดี

- **Clear interface:** บอกชัดว่าต้อง implement อะไร
- **Contract:** รับประกัน behavior
- **Polymorphism:** ใช้แทนกันได้
- **Documentation:** ABC เป็น documentation

### 5.8.5 ข้อเสีย

- **Overhead:** abstract check มี overhead
- **Rigid:** ต้อง inherit จริง (สำหรับ ABC)
- **Boilerplate:** ต้อง define methods ซ้ำ

### 5.8.6 ข้อควรระวัง

```python
# ระวัง 1: ABC กับ __init__
class Base(ABC):
    def __init__(self, value):
        self.value = value

    @abstractmethod
    def method(self):
        pass

# Subclass ต้องเรียก super().__init__
class Child(Base):
    def __init__(self, value, extra):
        super().__init__(value)  # ✅
        self.extra = extra

    def method(self):
        return self.value

# ระวัง 2: Abstract property + setter
class Base(ABC):
    @property
    @abstractmethod
    def value(self):
        pass

    @value.setter
    @abstractmethod
    def value(self, v):
        pass

# ระวัง 3: อย่า over-abstract
# ถ้ามี implementation เดียว ไม่ต้อง ABC

# ระวัง 4: ABC vs Protocol
# ABC — nominal (inherit)
# Protocol — structural (duck typing + type check)
```

### 5.8.7 สรุป

**ใช้ Abstraction เมื่อ:**
- ต้องการ interface ที่ชัดเจน
- หลาย implementations
- ต้องการบังคับ contract
- Framework/plugin system

**เครื่องมือ:**
- **ABC** — nominal typing, บังคับ inherit
- **Protocol** — structural typing, ยืดหยุ่น
- **Duck typing** — implicit, Pythonic

**Best practices:**
- ใช้ ABC สำหรับ public APIs
- ใช้ Protocol สำหรับ internal interfaces
- ใช้ duck typing สำหรับ flexibility
- หลีกเลี่ยง over-abstraction

> **อ้างอิงเพิ่มเติม:** [abc Module](https://docs.python.org/3/library/abc.html), [Abstract Base Classes](https://docs.python.org/3/reference/datamodel.html#abstract-base-classes)

---

## 5.9 Method Overriding

### บทนำ

Method Overriding คือการที่ subclass แทน method ของ superclass ด้วย implementation ของตัวเอง ช่วยให้ customize behavior ได้

### นิยาม

Method Overriding คือการ define method ใน subclass ที่มีชื่อเดียวกับ method ใน superclass

### 5.9.1 คืออะไร

Overriding:
- Method signature เดียวกัน
- เกิดใน subclass
- Runtime polymorphism

**Overloading (ต่างจาก overriding):**
- หลาย methods ชื่อเดียวกัน
- Parameters ต่างกัน
- Python ไม่รองรับโดยตรง

### 5.9.2 ทำงานอย่างไร

เมื่อเรียก `obj.method()`:
1. Python หา `method` ใน `type(obj).__mro__`
2. ใช้ตัวแรกที่เจอ
3. ถ้า subclass override → ใช้ของ subclass

### 5.9.3 การใช้งาน

**Basic Overriding:**
```python
class Animal:
    def __init__(self, name: str):
        self.name = name

    def speak(self) -> str:
        return "..."


class Dog(Animal):
    def speak(self) -> str:
        return f"{self.name}: Woof!"


class Cat(Animal):
    def speak(self) -> str:
        return f"{self.name}: Meow!"


animals = [Dog("Rex"), Cat("Whiskers"), Animal("Generic")]
for animal in animals:
    print(animal.speak())
# Rex: Woof!
# Whiskers: Meow!
# Generic: ...
```

**`super()` สำหรับ Extend:**
```python
class Logger:
    def log(self, message: str) -> None:
        print(f"[LOG] {message}")


class TimestampLogger(Logger):
    def log(self, message: str) -> None:
        from datetime import datetime
        timestamped = f"{datetime.now():%Y-%m-%d %H:%M:%S} - {message}"
        super().log(timestamped)  # เรียก parent


class FileLogger(TimestampLogger):
    def __init__(self, path: str):
        self.path = path

    def log(self, message: str) -> None:
        # เขียนไฟล์
        with open(self.path, "a", encoding="utf-8") as f:
            f.write(message + "\n")
        # เรียก parent (TimestampLogger)
        super().log(message)


logger = FileLogger("app.log")
logger.log("Application started")
# [LOG] 2024-01-01 12:00:00 - Application started
```

**Override Property:**
```python
class Shape:
    @property
    def area(self) -> float:
        return 0.0

    @property
    def name(self) -> str:
        return self.__class__.__name__


class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius

    @property
    def area(self) -> float:
        import math
        return math.pi * self.radius ** 2

    @property
    def name(self) -> str:
        return f"Circle(r={self.radius})"


class Square(Shape):
    def __init__(self, side: float):
        self.side = side

    @property
    def area(self) -> float:
        return self.side ** 2


shapes = [Circle(5), Square(4)]
for shape in shapes:
    print(f"{shape.name}: {shape.area:.2f}")
```

**Override `__str__` และ `__repr__`:**
```python
from dataclasses import dataclass

@dataclass
class User:
    name: str
    email: str

    def __str__(self) -> str:
        """User-friendly representation"""
        return f"{self.name} <{self.email}>"

    def __repr__(self) -> str:
        """Developer-friendly representation"""
        return f"User(name={self.name!r}, email={self.email!r})"


user = User("สมชาย", "somchai@email.com")
print(str(user))   # สมชาย <somchai@email.com>
print(repr(user))  # User(name='สมชาย', email='somchai@email.com')
```

**Override Comparison Methods:**
```python
from functools import total_ordering

@total_ordering
class Version:
    def __init__(self, major: int, minor: int, patch: int):
        self.major = major
        self.minor = minor
        self.patch = patch

    @property
    def _key(self):
        return (self.major, self.minor, self.patch)

    def __eq__(self, other):
        if not isinstance(other, Version):
            return NotImplemented
        return self._key == other._key

    def __lt__(self, other):
        if not isinstance(other, Version):
            return NotImplemented
        return self._key < other._key

    def __str__(self):
        return f"{self.major}.{self.minor}.{self.patch}"


versions = [Version(1, 2, 3), Version(2, 0, 0), Version(1, 10, 0)]
for v in sorted(versions):
    print(v)
# 1.2.3
# 1.10.0
# 2.0.0
```

**Template Method Pattern:**
```python
from abc import ABC, abstractmethod

class DataMiner(ABC):
    """Template method pattern"""

    def mine(self, path: str) -> None:
        """Template method — กำหนด skeleton"""
        file = self.open_file(path)
        data = self.extract_data(file)
        parsed = self.parse_data(data)
        analysis = self.analyze_data(parsed)
        self.send_report(analysis)
        self.close_file(file)

    @abstractmethod
    def open_file(self, path: str):
        pass

    @abstractmethod
    def extract_data(self, file):
        pass

    @abstractmethod
    def parse_data(self, data):
        pass

    def analyze_data(self, data):
        """Default analysis"""
        return {"count": len(data), "data": data}

    def send_report(self, analysis: dict) -> None:
        print(f"Report: {analysis}")

    @abstractmethod
    def close_file(self, file):
        pass


class CSVDataMiner(DataMiner):
    def open_file(self, path: str):
        print(f"Opening CSV: {path}")
        return path

    def extract_data(self, file):
        print(f"Extracting CSV data")
        return []

    def parse_data(self, data):
        print(f"Parsing CSV")
        return [{"col": 1}, {"col": 2}]

    def close_file(self, file):
        print(f"Closing CSV")


class PDFDataMiner(DataMiner):
    def open_file(self, path: str):
        print(f"Opening PDF: {path}")
        return path

    def extract_data(self, file):
        print(f"Extracting PDF data")
        return []

    def parse_data(self, data):
        print(f"Parsing PDF")
        return [{"page": 1, "text": "..."}]

    def analyze_data(self, data):
        """Override default analysis"""
        return {"pages": len(data), "words": 100}

    def close_file(self, file):
        print(f"Closing PDF")


# การใช้งาน
CSVDataMiner().mine("data.csv")
print()
PDFDataMiner().mine("document.pdf")
```

**ตัวอย่างการใช้งานจริง — Serialization:**
```python
from typing import Any
import json
from datetime import datetime

class Serializable:
    def to_dict(self) -> dict[str, Any]:
        """Override เพื่อ custom serialization"""
        return {
            k: v for k, v in self.__dict__.items()
            if not k.startswith("_")
        }

    def to_json(self) -> str:
        """Concrete — ใช้ to_dict"""
        return json.dumps(self.to_dict(), default=str)


class User(Serializable):
    def __init__(self, name: str, email: str, password: str):
        self.name = name
        self.email = email
        self._password = password  # ไม่ serialize

    def to_dict(self) -> dict[str, Any]:
        """Override เพื่อไม่รวม password"""
        return {
            "name": self.name,
            "email": self.email,
        }


class Post(Serializable):
    def __init__(self, title: str, content: str, author: User):
        self.title = title
        self.content = content
        self.author = author
        self.created_at = datetime.now()

    def to_dict(self) -> dict[str, Any]:
        """Override เพื่อ format date"""
        return {
            "title": self.title,
            "content": self.content,
            "author": self.author.to_dict(),
            "created_at": self.created_at.isoformat(),
        }


user = User("สมชาย", "somchai@email.com", "secret123")
post = Post("Hello World", "This is a post", user)
print(post.to_json())
# {"title": "Hello World", ..., "author": {"name": "สมชาย", ...}}
```

### 5.9.4 ข้อดี

- **Customize:** ปรับ behavior ได้
- **Polymorphism:** runtime dispatch
- **Reuse:** extend parent
- **Template Method:** กำหนด skeleton

### 5.9.5 ข้อเสีย

- **Fragile:** เปลี่ยน parent กระทบ child
- **ซับซ้อน:** ยาก debug ถ้า hierarchy ลึก
- **Performance:** method lookup overhead

### 5.9.6 ข้อควรระวัง

```python
# ระวัง 1: อย่าเปลี่ยน signature
class Base:
    def method(self, x: int) -> int:
        return x

class Bad(Base):
    def method(self, x, y, z):  # ❌ signature เปลี่ยน
        return x

# ระวัง 2: super() ใน subclass
class Parent:
    def method(self):
        return "parent"

class Child(Parent):
    def method(self):
        # ❌ ลืม super()
        return "child"

# ✅ ถ้าต้องการ extend
class Child2(Parent):
    def method(self):
        parent_result = super().method()
        return f"{parent_result} + child"

# ระวัง 3: MRO ใน multiple inheritance
class A:
    def method(self):
        return "A"

class B(A):
    def method(self):
        return "B"

class C(A):
    def method(self):
        return "C"

class D(B, C):
    pass

print(D().method())  # B (ตาม MRO)

# ระวัง 4: อย่าใช้ isinstance แทน polymorphism
# ❌
def process(obj):
    if isinstance(obj, TypeA):
        obj.method_a()
    elif isinstance(obj, TypeB):
        obj.method_b()

# ✅
def process(obj):
    obj.method()  # polymorphic

# ระวัง 5: Override __eq__ ต้อง override __hash__ ด้วย
class Bad:
    def __eq__(self, other):
        return self.id == other.id
    # ❌ __hash__ กลายเป็น None → unhashable

class Good:
    def __init__(self, id):
        self.id = id

    def __eq__(self, other):
        return isinstance(other, Good) and self.id == other.id

    def __hash__(self):
        return hash(self.id)
```

### 5.9.7 สรุป

**Method Overriding:**
- Subclass แทน method ของ parent
- ใช้ `super()` เพื่อ extend
- Runtime polymorphism

**Template Method Pattern:**
- Parent กำหนด skeleton
- Subclass implement steps

**Best practices:**
- ใช้ `super()` เสมอ
- รักษา signature
- Override `__hash__` เมื่อ override `__eq__`
- ใช้ polymorphism แทน isinstance

> **อ้างอิงเพิ่มเติม:** [Inheritance](https://docs.python.org/3/tutorial/classes.html#inheritance)

---

## 5.10 Method Overloading แบบ Python

### บทนำ

Python ไม่รองรับ method overloading แบบ traditional (หลาย methods ชื่อเดียวกัน) แต่มีเทคนิคหลายอย่างที่ให้ผลคล้ายกัน

### นิยาม

Method Overloading คือการมีหลาย methods ชื่อเดียวกัน แต่ parameters ต่างกัน

### 5.10.1 คืออะไร

Python แทน method overloading ด้วย:
1. **Default arguments**
2. **`*args` และ `**kwargs`**
3. **`singledispatch`**
4. **Type checking ใน method เดียว**

### 5.10.2 ทำงานอย่างไร

Python เก็บ method ใน class `__dict__` ชื่อเดียว → method ใหม่ทับอันเก่า

### 5.10.3 การใช้งาน

**Default Arguments:**
```python
class Greeter:
    def greet(self, name: str, greeting: str = "Hello") -> str:
        return f"{greeting}, {name}!"

g = Greeter()
print(g.greet("World"))                # Hello, World!
print(g.greet("World", "Hi"))          # Hi, World!
print(g.greet("World", greeting="Hey"))  # Hey, World!
```

**`*args` และ `**kwargs`:**
```python
class Calculator:
    def add(self, *args: float) -> float:
        return sum(args)

    def concat(self, *strings: str, sep: str = " ") -> str:
        return sep.join(strings)

    def create_user(self, **kwargs) -> dict:
        defaults = {"role": "user", "active": True}
        defaults.update(kwargs)
        return defaults

calc = Calculator()
print(calc.add(1, 2, 3, 4))            # 10
print(calc.concat("a", "b", "c"))       # a b c
print(calc.concat("a", "b", sep="-"))   # a-b
print(calc.create_user(name="สมชาย", age=30))
```

**Type Dispatch:**
```python
class Formatter:
    def format(self, value) -> str:
        if isinstance(value, str):
            return value
        elif isinstance(value, int):
            return f"{value:,}"
        elif isinstance(value, float):
            return f"{value:.2f}"
        elif isinstance(value, list):
            return ", ".join(str(v) for v in value)
        elif isinstance(value, dict):
            return ", ".join(f"{k}={v}" for k, v in value.items())
        return str(value)

fmt = Formatter()
print(fmt.format("hello"))      # hello
print(fmt.format(1000000))      # 1,000,000
print(fmt.format(3.14159))      # 3.14
print(fmt.format([1, 2, 3]))    # 1, 2, 3
print(fmt.format({"a": 1}))     # a=1
```

**`singledispatchmethod` (Python 3.8+):**
```python
from functools import singledispatchmethod

class Serializer:
    @singledispatchmethod
    def serialize(self, value):
        raise NotImplementedError(f"ไม่รองรับ {type(value).__name__}")

    @serialize.register
    def _(self, value: int) -> str:
        return f"INT:{value}"

    @serialize.register
    def _(self, value: str) -> str:
        return f"STR:{value}"

    @serialize.register
    def _(self, value: float) -> str:
        return f"FLOAT:{value:.4f}"

    @serialize.register
    def _(self, value: list) -> str:
        return "[" + ",".join(self.serialize(v) for v in value) + "]"

    @serialize.register
    def _(self, value: dict) -> str:
        items = (f"{self.serialize(k)}:{self.serialize(v)}"
                 for k, v in value.items())
        return "{" + ",".join(items) + "}"


s = Serializer()
print(s.serialize(42))                # INT:42
print(s.serialize("hello"))           # STR:hello
print(s.serialize(3.14159))           # FLOAT:3.1416
print(s.serialize([1, "two", 3.0]))   # [INT:1,STR:two,FLOAT:3.0000]
print(s.serialize({"a": 1}))          # {STR:a:INT:1}
```

**Generic Methods:**
```python
from typing import TypeVar, Generic, overload

T = TypeVar("T")

class Container(Generic[T]):
    def __init__(self):
        self._items: list[T] = []

    @overload
    def add(self, item: T) -> None: ...
    @overload
    def add(self, items: list[T]) -> None: ...
    def add(self, item_or_items):
        if isinstance(item_or_items, list):
            self._items.extend(item_or_items)
        else:
            self._items.append(item_or_items)

    def get_all(self) -> list[T]:
        return self._items.copy()

# การใช้งาน
c = Container[int]()
c.add(1)
c.add([2, 3, 4])
print(c.get_all())  # [1, 2, 3, 4]
```

**ตัวอย่างการใช้งานจริง — API Response Builder:**
```python
from functools import singledispatchmethod
from dataclasses import dataclass, asdict
from datetime import datetime
import json

class ResponseBuilder:
    @singledispatchmethod
    def build(self, data):
        """Default — convert to string"""
        return {"data": str(data)}

    @build.register
    def _(self, data: dict) -> dict:
        return {"data": data}

    @build.register
    def _(self, data: list) -> dict:
        return {"data": [self._serialize_item(item) for item in data]}

    @build.register
    def _(self, data: datetime) -> dict:
        return {"data": data.isoformat()}

    @build.register
    def _(self, data: type(None)) -> dict:
        return {"data": None}

    def _serialize_item(self, item):
        if hasattr(item, "__dataclass_fields__"):
            return asdict(item)
        return self.build(item)["data"]

    def to_json(self, data) -> str:
        return json.dumps(self.build(data))


@dataclass
class User:
    name: str
    email: str


builder = ResponseBuilder()

print(builder.to_json({"key": "value"}))
# {"data": {"key": "value"}}

print(builder.to_json([User("สมชาย", "a@b.com")]))
# {"data": [{"name": "สมชาย", "email": "a@b.com"}]}

print(builder.to_json(datetime.now()))
# {"data": "2024-01-01T12:00:00"}

print(builder.to_json(None))
# {"data": null}
```

**ตัวอย่าง — Configuration Loader:**
```python
from pathlib import Path
from typing import Any
import json
import yaml  # pip install pyyaml
import tomllib  # Python 3.11+

class ConfigLoader:
    def load(self, path: str | Path, **overrides: Any) -> dict[str, Any]:
        """Load config จากไฟล์ — รองรับหลาย format"""
        path = Path(path)
        if not path.exists():
            raise FileNotFoundError(path)

        # Dispatch ตาม extension
        loaders = {
            ".json": self._load_json,
            ".yaml": self._load_yaml,
            ".yml": self._load_yaml,
            ".toml": self._load_toml,
        }

        suffix = path.suffix.lower()
        if suffix not in loaders:
            raise ValueError(f"ไม่รองรับ {suffix}")

        data = loaders[suffix](path)
        data.update(overrides)
        return data

    def _load_json(self, path: Path) -> dict:
        with open(path, encoding="utf-8") as f:
            return json.load(f)

    def _load_yaml(self, path: Path) -> dict:
        with open(path, encoding="utf-8") as f:
            return yaml.safe_load(f)

    def _load_toml(self, path: Path) -> dict:
        with open(path, "rb") as f:
            return tomllib.load(f)
```

### 5.10.4 ข้อดี

- **Flexible:** รับได้หลาย types
- **Pythonic:** ใช้ default args, *args
- **Single method:** ง่าย debug
- **`singledispatch`:** clean สำหรับ type-based

### 5.10.5 ข้อเสีย

- **ไม่ enforced:** type checking ตอน runtime
- **Boilerplate:** สำหรับ type dispatch
- **Documentation:** ต้อง document types
- **Performance:** type checking มี overhead

### 5.10.6 ข้อควรระวัง

```python
# ระวัง 1: Python ทับ method เก่า
class Bad:
    def method(self, x: int) -> int:
        return x

    def method(self, x: str) -> str:  # ทับอันเก่า!
        return x

# มีแค่ method ที่สอง

# ระวัง 2: Default args กับ mutable
def bad(self, items=[]):  # ❌ shared
    items.append(1)
    return items

# ✅
def good(self, items=None):
    if items is None:
        items = []
    items.append(1)
    return items

# ระวัง 3: singledispatch กับ class methods
# ใช้ singledispatchmethod (Python 3.8+) สำหรับ instance methods

# ระวัง 4: อย่าใช้ type checking มากเกินไป
# ❌ ยาวและซ้ำ
def process(self, x):
    if isinstance(x, int):
        ...
    elif isinstance(x, str):
        ...
    elif isinstance(x, list):
        ...

# ✅ polymorphic
def process(self, x):
    return x.process()  # ถ้า x มี method process
```

### 5.10.7 สรุป

**วิธีทำ Overloading ใน Python:**
1. **Default arguments** — สำหรับ optional params
2. **`*args` / `**kwargs`** — สำหรับ variable params
3. **`singledispatchmethod`** — สำหรับ type-based dispatch
4. **Type checking** — สำหรับ complex cases
5. **`@overload`** — สำหรับ type hints เท่านั้น

**Best practices:**
- ใช้ default args เมื่อเป็นไปได้
- ใช้ `singledispatchmethod` สำหรับ type-based
- Document types ชัดเจน
- หลีกเลี่ยง type checking ที่ซับซ้อน

> **อ้างอิงเพิ่มเติม:** [singledispatchmethod](https://docs.python.org/3/library/functools.html#functools.singledispatchmethod), [typing.overload](https://docs.python.org/3/library/typing.html#typing.overload)

---

## 5.11 Multiple Inheritance

### บทนำ

Multiple Inheritance ให้ class สืบทอดจากหลาย parents พร้อมกัน แม้จะซับซ้อน แต่มีประโยชน์ใน Mixin patterns

### นิยาม

Multiple Inheritance คือ class ที่มี parents มากกว่าหนึ่ง

### 5.11.1 คืออะไร

MRO (Method Resolution Order) กำหนดลำดับการค้นหา methods ใช้ C3 Linearization algorithm

**Diamond Problem:** เมื่อ subclass สืบทอดจาก classes ที่มี common ancestor

### 5.11.2 ทำงานอย่างไร

C3 Linearization:
- Subclass มาก่อน parent
- Parent ตามลำดับใน class definition
- Common ancestor อยู่ท้าย

```python
class A: pass
class B(A): pass
class C(A): pass
class D(B, C): pass

print(D.__mro__)
# (D, B, C, A, object)
```

### 5.11.3 การใช้งาน

**Mixin Pattern:**
```python
class LoggableMixin:
    """Mixin ให้ class log ได้"""

    def log(self, message: str) -> None:
        class_name = self.__class__.__name__
        print(f"[{class_name}] {message}")


class SerializableMixin:
    """Mixin ให้ class serialize ได้"""

    def to_dict(self) -> dict:
        return {
            k: v for k, v in self.__dict__.items()
            if not k.startswith("_")
        }


class TimestampMixin:
    """Mixin เพิ่ม timestamps"""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        from datetime import datetime
        self.created_at = datetime.now()


class User(LoggableMixin, SerializableMixin, TimestampMixin):
    def __init__(self, name: str, email: str):
        super().__init__()
        self.name = name
        self.email = email


user = User("สมชาย", "somchai@email.com")
user.log("User created")           # [User] User created
print(user.to_dict())              # {'created_at': ..., 'name': ..., 'email': ...}
```

**Diamond Problem Resolution:**
```python
class A:
    def method(self):
        print("A.method")
        super().method()  # ต้องเรียก super() เสมอ


class B(A):
    def method(self):
        print("B.method")
        super().method()


class C(A):
    def method(self):
        print("C.method")
        super().method()


class D(B, C):
    def method(self):
        print("D.method")
        super().method()


# MRO: D → B → C → A → object
D().method()
# D.method
# B.method
# C.method
# A.method
```

**Abstract + Mixin:**
```python
from abc import ABC, abstractmethod

class Drawable(ABC):
    @abstractmethod
    def draw(self) -> str:
        pass


class ClickableMixin:
    def on_click(self) -> str:
        return f"{self.__class__.__name__} clicked"


class HoverableMixin:
    def on_hover(self) -> str:
        return f"{self.__class__.__name__} hovered"


class Button(Drawable, ClickableMixin, HoverableMixin):
    def __init__(self, label: str):
        self.label = label

    def draw(self) -> str:
        return f"[{self.label}]"


button = Button("Submit")
print(button.draw())        # [Submit]
print(button.on_click())    # Button clicked
print(button.on_hover())    # Button hovered
```

**Cooperative Multiple Inheritance:**
```python
class Base:
    def __init__(self, **kwargs):
        # เก็บ kwargs ที่เหลือ
        super().__init__(**kwargs)


class A(Base):
    def __init__(self, a: int = 0, **kwargs):
        super().__init__(**kwargs)
        self.a = a


class B(Base):
    def __init__(self, b: int = 0, **kwargs):
        super().__init__(**kwargs)
        self.b = b


class C(A, B):
    def __init__(self, c: int = 0, **kwargs):
        super().__init__(**kwargs)
        self.c = c


# ทุก __init__ ถูกเรียกตาม MRO
obj = C(a=1, b=2, c=3)
print(obj.a, obj.b, obj.c)  # 1 2 3
```

**ตัวอย่างการใช้งานจริง — Validation Mixins:**
```python
import re
from datetime import datetime

class EmailValidationMixin:
    EMAIL_PATTERN = re.compile(r"^[\w.+-]+@[\w-]+\.[\w.]+$")

    def validate_email(self, email: str) -> str:
        if not self.EMAIL_PATTERN.match(email):
            raise ValueError(f"Invalid email: {email}")
        return email.lower()


class AgeValidationMixin:
    def validate_age(self, age: int) -> int:
        if not 0 <= age <= 150:
            raise ValueError(f"Invalid age: {age}")
        return age


class UsernameValidationMixin:
    def validate_username(self, username: str) -> str:
        if not re.match(r"^[a-zA-Z0-9_]{3,20}$", username):
            raise ValueError(f"Invalid username: {username}")
        return username


class PasswordValidationMixin:
    def validate_password(self, password: str) -> str:
        if len(password) < 8:
            raise ValueError("Password ต้องมีอย่างน้อย 8 ตัวอักษร")
        if not any(c.isupper() for c in password):
            raise ValueError("Password ต้องมีตัวพิมพ์ใหญ่")
        if not any(c.isdigit() for c in password):
            raise ValueError("Password ต้องมีตัวเลข")
        return password


class User(
    EmailValidationMixin,
    AgeValidationMixin,
    UsernameValidationMixin,
    PasswordValidationMixin,
):
    def __init__(self, username: str, email: str, age: int, password: str):
        self.username = self.validate_username(username)
        self.email = self.validate_email(email)
        self.age = self.validate_age(age)
        self.password = self.validate_password(password)

    def __repr__(self) -> str:
        return f"User(username={self.username!r}, email={self.email!r}, age={self.age})"


# การใช้งาน
user = User("somchai", "somchai@Email.com", 30, "Secure123")
print(user)
# User(username='somchai', email='somchai@email.com', age=30)

try:
    User("ab", "invalid", 30, "weak")
except ValueError as e:
    print(f"Error: {e}")
```

**ตัวอย่าง — Repository Mixins:**
```python
from typing import TypeVar, Generic, Optional, Any
from datetime import datetime

T = TypeVar("T")

class CRUDMixin(Generic[T]):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._items: dict[int, T] = {}
        self._next_id = 1

    def create(self, item: T) -> T:
        id_ = self._next_id
        self._next_id += 1
        self._items[id_] = item
        return item

    def read(self, id_: int) -> Optional[T]:
        return self._items.get(id_)

    def update(self, id_: int, item: T) -> bool:
        if id_ not in self._items:
            return False
        self._items[id_] = item
        return True

    def delete(self, id_: int) -> bool:
        return self._items.pop(id_, None) is not None

    def list_all(self) -> list[T]:
        return list(self._items.values())


class PaginationMixin:
    def paginate(self, page: int = 1, per_page: int = 10) -> dict:
        items = self.list_all()  # type: ignore
        total = len(items)
        start = (page - 1) * per_page
        end = start + per_page

        return {
            "items": items[start:end],
            "page": page,
            "per_page": per_page,
            "total": total,
            "pages": (total + per_page - 1) // per_page,
        }


class TimestampMixin:
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.created_at = datetime.now()
        self.updated_at = datetime.now()

    def touch(self) -> None:
        self.updated_at = datetime.now()


class UserRepository(CRUDMixin[dict], PaginationMixin, TimestampMixin):
    pass


# การใช้งาน
repo = UserRepository()
for i in range(25):
    repo.create({"id": i, "name": f"User{i}"})

page1 = repo.paginate(page=1, per_page=10)
print(f"Page {page1['page']}/{page1['pages']}: {len(page1['items'])} items")
# Page 1/3: 10 items

print(f"Created at: {repo.created_at}")
```

### 5.11.4 ข้อดี

- **Mixin pattern:** แชร์ behavior
- **Flexible:** รวม features จากหลาย sources
- **Reusability:** ใช้ mixins ซ้ำได้
- **Composition via inheritance:** ทางเลือกกับ composition

### 5.11.5 ข้อเสีย

- **ซับซ้อน:** MRO ยากเข้าใจ
- **Diamond problem:** conflict resolution
- **Fragile:** เปลี่ยน mixin กระทบ users
- **Debugging:** ยากกว่า single inheritance

### 5.11.6 ข้อควรระวัง

```python
# ระวัง 1: ใช้ super() ให้สม่ำเสมอ
# ❌ ไม่เรียก super() → MRO chain ขาด
class BadMixin:
    def method(self):
        return "bad"  # ไม่เรียก super

# ✅
class GoodMixin:
    def method(self):
        result = super().method()
        return f"good + {result}"

# ระวัง 2: Mixin ไม่ควรมี __init__ ที่ซับซ้อน
# ถ้ามี ต้องรับ *args, **kwargs

# ระวัง 3: ลำดับ mixins สำคัญ
class MyClass(MixinA, MixinB, Base):  # A ถูกเรียกก่อน B
    pass

# ระวัง 4: อย่าใช้ multiple inheritance สำหรับ "is-a"
# ❌
class FlyingCar(Car, Airplane):
    pass

# ✅ composition
class FlyingCar:
    def __init__(self):
        self.car = Car()
        self.airplane = Airplane()

# ระวัง 5: ตรวจสอบ MRO
print(MyClass.__mro__)
# ตรวจสอบว่าไม่มี conflicts

# ระวัง 6: Abstract + Mixin
# Mixin ไม่ควรเป็น ABC ถ้าไม่จำเป็น
```

### 5.11.7 สรุป

**ใช้ Multiple Inheritance สำหรับ:**
- **Mixin pattern:** แชร์ behavior ที่ไม่ใช่ "is-a"
- **Cooperative multiple inheritance:** ทุก class เรียก super()
- **Cross-cutting concerns:** logging, validation, serialization

**หลีกเลี่ยงเมื่อ:**
- มี hierarchy ที่ซับซ้อน
- ต้องการ composition
- ไม่แน่ใจเรื่อง MRO

**Best practices:**
- Mixins ควรเป็น stateless
- ใช้ `super()` เสมอ
- Mixins ควรอยู่ซ้ายสุด
- Document MRO

> **อ้างอิงเพิ่มเติม:** [Multiple Inheritance](https://docs.python.org/3/tutorial/classes.html#multiple-inheritance), [MRO](https://www.python.org/download/releases/2.3/mro/)

---

## 5.12 MRO

### บทนำ

Method Resolution Order (MRO) คือลำดับที่ Python ค้นหา methods และ attributes ใน class hierarchy เข้าใจ MRO เป็นสิ่งจำเป็นสำหรับ multiple inheritance

### นิยาม

MRO คือลำดับของ classes ที่ Python ใช้เมื่อ resolve method หรือ attribute

### 5.12.1 คืออะไร

Python ใช้ C3 Linearization algorithm ซึ่ง:
- Subclass มาก่อน parent
- รักษาลำดับของ class definition
- Monotonic (consistent)

### 5.12.2 ทำงานอย่างไร

```python
class A: pass
class B(A): pass
class C(A): pass
class D(B, C): pass

print(D.__mro__)
# (D, B, C, A, object)

# ลำดับการค้นหา method:
# 1. D
# 2. B
# 3. C
# 4. A
# 5. object
```

### 5.12.3 การใช้งาน

**MRO พื้นฐาน:**
```python
class Base:
    def method(self):
        return "Base"


class A(Base):
    def method(self):
        return "A"


class B(Base):
    def method(self):
        return "B"


class C(A, B):
    pass  # ใช้ A.method (A ก่อน B)


print(C().method())  # A
print(C.__mro__)
# (C, A, B, Base, object)
```

**Cooperative super():**
```python
class Base:
    def __init__(self):
        print("Base")
        super().__init__()


class A(Base):
    def __init__(self):
        print("A")
        super().__init__()


class B(Base):
    def __init__(self):
        print("B")
        super().__init__()


class C(A, B):
    def __init__(self):
        print("C")
        super().__init__()


c = C()
# C
# A
# B
# Base
# object.__init__() ไม่ print

print(C.__mro__)
# (C, A, B, Base, object)
```

**MRO Conflict:**
```python
# ❌ MRO conflict
class A: pass
class B(A): pass
class C(A, B): pass  # TypeError: Cannot create consistent MRO

# เหตุผล: B ต้องมาก่อน A (เพราะ B(A))
# แต่ C บอกว่า A ต้องมาก่อน B
# ขัดกัน

# ✅ ถูกต้อง
class A: pass
class B(A): pass
class C(B): pass  # OK

# หรือ
class C(B, A): pass  # OK — B มาก่อน A อยู่แล้ว
```

**`super()` ที่ไม่มี argument (Python 3):**
```python
class Parent:
    def greet(self):
        return "Hello from Parent"


class Child(Parent):
    def greet(self):
        # Python 3: super() ใช้ __class__ อัตโนมัติ
        parent_greet = super().greet()
        return f"{parent_greet} + Child"


# เทียบเท่ากับ
class Child2(Parent):
    def greet(self):
        parent_greet = super(Child2, self).greet()  # แบบเก่า
        return f"{parent_greet} + Child"
```

**Diamond Inheritance:**
```python
class A:
    def method(self):
        print("A")


class B(A):
    def method(self):
        print("B")
        super().method()


class C(A):
    def method(self):
        print("C")
        super().method()


class D(B, C):
    def method(self):
        print("D")
        super().method()


print(D.__mro__)
# (D, B, C, A, object)

D().method()
# D
# B
# C
# A
```

**ตัวอย่างการใช้งานจริง — Plugin System:**
```python
from abc import ABC, abstractmethod

class PluginBase(ABC):
    """Base plugin ที่มี lifecycle"""

    def on_load(self):
        print(f"{self.__class__.__name__}: loading")

    def on_unload(self):
        print(f"{self.__class__.__name__}: unloading")

    @abstractmethod
    def process(self, data):
        pass


class LoggingPlugin(PluginBase):
    def on_load(self):
        super().on_load()
        print(f"{self.__class__.__name__}: logging enabled")

    def process(self, data):
        print(f"[LOG] {data}")
        return data


class MetricsPlugin(PluginBase):
    def on_load(self):
        super().on_load()
        print(f"{self.__class__.__name__}: metrics enabled")

    def process(self, data):
        print(f"[METRIC] {len(data)} items")
        return data


class CachePlugin(PluginBase):
    def on_load(self):
        super().on_load()
        self._cache = {}

    def process(self, data):
        key = str(data)
        if key not in self._cache:
            self._cache[key] = data
        return self._cache[key]


# ลำดับ MRO ที่ชัดเจน
class FullPlugin(LoggingPlugin, MetricsPlugin, CachePlugin):
    def process(self, data):
        return super().process(data)


plugin = FullPlugin()
plugin.on_load()
# FullPlugin: loading
# LoggingPlugin: logging enabled
# MetricsPlugin: metrics enabled

print(FullPlugin.__mro__)
# (FullPlugin, LoggingPlugin, MetricsPlugin, CachePlugin, PluginBase, ABC, object)
```

**ตรวจสอบ MRO:**
```python
def print_mro(cls):
    print(f"MRO of {cls.__name__}:")
    for i, c in enumerate(cls.__mro__):
        print(f"  {i}. {c.__name__}")

class A: pass
class B(A): pass
class C(A): pass
class D(B, C): pass

print_mro(D)
# MRO of D:
#   0. D
#   1. B
#   2. C
#   3. A
#   4. object

# ใช้ issubclass
print(issubclass(D, B))   # True
print(issubclass(D, C))   # True
print(issubclass(D, A))   # True
print(issubclass(B, C))   # False

# ใช้ isinstance
d = D()
print(isinstance(d, A))   # True
print(isinstance(d, B))   # True
print(isinstance(d, C))   # True
```

### 5.12.4 ข้อดี

- **Predictable:** รู้ลำดับการค้นหา
- **Cooperative:** `super()` ทำงานได้ถูกต้อง
- **Consistent:** ไม่มี ambiguity
- **Powerful:** multiple inheritance จัดการได้

### 5.12.5 ข้อเสีย

- **ซับซ้อน:** C3 algorithm เข้าใจยาก
- **Debugging:** ยากถ้า MRO ไม่ชัดเจน
- **Conflicts:** อาจเกิด MRO conflict

### 5.12.6 ข้อควรระวัง

```python
# ระวัง 1: MRO conflict
# class C(A, B) เมื่อ B(A) → conflict
# เพราะ B ต้องมาก่อน A แต่ C บอก A มาก่อน B

# ระวัง 2: super() กับ explicit call
class A:
    def method(self):
        return "A"

class B(A):
    def method(self):
        # ❌ ไม่ควรเรียก parent โดยตรง
        # return A.method(self)  # ข้าม MRO

        # ✅ ใช้ super()
        return "B + " + super().method()

# ระวัง 3: __init__ ที่ไม่ cooperative
class Bad:
    def __init__(self):
        # ❌ ไม่เรียก super().__init__()
        pass

class Good:
    def __init__(self, **kwargs):
        # ✅
        super().__init__(**kwargs)

# ระวัง 4: ตรวจสอบ MRO ก่อน debug
# print(MyClass.__mro__) เพื่อดูจริง

# ระวัง 5: บาง MRO ไม่สามารถสร้างได้
# ลองใช้ MRO algorithm ก่อน

# ระวัง 6: __init__ ที่ต้องส่ง args
# ต้องใช้ **kwargs สำหรับ cooperative inheritance
```

### 5.12.7 สรุป

**MRO คือ:**
- ลำดับการค้นหา methods/attributes
- ใช้ C3 Linearization
- รับประกัน consistency

**กฎ:**
1. Subclass มาก่อน parent
2. ตามลำดับ class definition
3. Common ancestor อยู่ท้าย

**Best practices:**
- ใช้ `super()` เสมอ
- Cooperative `__init__` ด้วย `**kwargs`
- ตรวจสอบ `__mro__` เมื่อ debug
- ออกแบบ mixins ให้ stateless

> **อ้างอิงเพิ่มเติม:** [MRO Documentation](https://www.python.org/download/releases/2.3/mro/)

---

## 5.13 Magic Method

### บทนำ

Magic methods (dunder methods) เริ่มและจบด้วย `__` เป็นวิธีที่ Python ให้ objects ทำงานกับ syntax และ built-in functions ได้อย่างเป็นธรรมชาติ

### นิยาม

Magic methods คือ special methods ที่ Python เรียกอัตโนมัติในสถานการณ์ต่าง ๆ เช่น `+`, `len()`, `print()`

### 5.13.1 คืออะไร

ประเภทหลัก:
- **Construction:** `__new__`, `__init__`, `__del__`
- **Representation:** `__str__`, `__repr__`, `__format__`
- **Comparison:** `__eq__`, `__lt__`, `__hash__`
- **Arithmetic:** `__add__`, `__mul__`, `__sub__`
- **Container:** `__len__`, `__getitem__`, `__setitem__`, `__contains__`
- **Iteration:** `__iter__`, `__next__`
- **Context:** `__enter__`, `__exit__`
- **Callable:** `__call__`

### 5.13.2 ทำงานอย่างไร

เมื่อเขียน `a + b` Python เรียก `a.__add__(b)` ถ้าไม่มี จะลอง `b.__radd__(a)`

### 5.13.3 การใช้งาน

**Representation:**
```python
class Money:
    def __init__(self, amount: float, currency: str = "THB"):
        self.amount = amount
        self.currency = currency

    def __str__(self) -> str:
        """User-friendly — เรียกโดย str() และ print()"""
        return f"{self.amount:,.2f} {self.currency}"

    def __repr__(self) -> str:
        """Developer-friendly — เรียกโดย repr() และใน REPL"""
        return f"Money({self.amount!r}, {self.currency!r})"

    def __format__(self, spec: str) -> str:
        """Format spec — ใช้กับ f-strings"""
        if spec == "short":
            return f"{self.amount:.0f} {self.currency}"
        return str(self)


m = Money(1234.5, "THB")
print(m)              # 1,234.50 THB
print(repr(m))        # Money(1234.5, 'THB')
print(f"{m:short}")   # 1235 THB
```

**Comparison:**
```python
from functools import total_ordering

@total_ordering
class Version:
    def __init__(self, major: int, minor: int):
        self.major = major
        self.minor = minor

    def __eq__(self, other) -> bool:
        if not isinstance(other, Version):
            return NotImplemented
        return (self.major, self.minor) == (other.major, other.minor)

    def __lt__(self, other) -> bool:
        if not isinstance(other, Version):
            return NotImplemented
        return (self.major, self.minor) < (other.major, other.minor)

    def __hash__(self) -> int:
        return hash((self.major, self.minor))


# total_ordering สร้าง __le__, __gt__, __ge__ ให้
print(Version(1, 0) < Version(1, 1))    # True
print(Version(2, 0) >= Version(1, 9))   # True
print(Version(1, 5) == Version(1, 5))   # True
```

**Arithmetic:**
```python
class Vector:
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y

    def __add__(self, other: "Vector") -> "Vector":
        return Vector(self.x + other.x, self.y + other.y)

    def __sub__(self, other: "Vector") -> "Vector":
        return Vector(self.x - other.x, self.y - other.y)

    def __mul__(self, scalar: float) -> "Vector":
        return Vector(self.x * scalar, self.y * scalar)

    def __rmul__(self, scalar: float) -> "Vector":
        """2 * v → v.__rmul__(2)"""
        return self * scalar

    def __truediv__(self, scalar: float) -> "Vector":
        return Vector(self.x / scalar, self.y / scalar)

    def __neg__(self) -> "Vector":
        return Vector(-self.x, -self.y)

    def __abs__(self) -> float:
        return (self.x ** 2 + self.y ** 2) ** 0.5

    def __iadd__(self, other: "Vector") -> "Vector":
        """+= ในplace"""
        self.x += other.x
        self.y += other.y
        return self

    def __repr__(self) -> str:
        return f"Vector({self.x}, {self.y})"


v1 = Vector(1, 2)
v2 = Vector(3, 4)
print(v1 + v2)     # Vector(4, 6)
print(v2 - v1)     # Vector(2, 2)
print(v1 * 2)      # Vector(2, 4)
print(2 * v1)      # Vector(2, 4)
print(-v1)         # Vector(-1, -2)
print(abs(v1))     # 2.236...
```

**Container Protocol:**
```python
from typing import Iterator

class Playlist:
    def __init__(self, songs: list[str]):
        self._songs = list(songs)

    def __len__(self) -> int:
        """len(playlist)"""
        return len(self._songs)

    def __getitem__(self, index):
        """playlist[0] หรือ playlist[1:3]"""
        return self._songs[index]

    def __setitem__(self, index: int, value: str) -> None:
        """playlist[0] = "new" """
        self._songs[index] = value

    def __delitem__(self, index: int) -> None:
        """del playlist[0]"""
        del self._songs[index]

    def __contains__(self, item: str) -> bool:
        """'song' in playlist"""
        return item in self._songs

    def __iter__(self) -> Iterator[str]:
        """for song in playlist"""
        return iter(self._songs)

    def __reversed__(self) -> Iterator[str]:
        """reversed(playlist)"""
        return reversed(self._songs)


playlist = Playlist(["A", "B", "C"])
print(len(playlist))         # 3
print(playlist[0])           # A
print(playlist[1:])          # ['B', 'C']
print("A" in playlist)       # True

for song in playlist:
    print(song)

playlist[0] = "A2"
print(playlist[0])           # A2

del playlist[0]
print(len(playlist))         # 2
```

**Iteration:**
```python
class Fibonacci:
    def __init__(self, limit: int):
        self.limit = limit

    def __iter__(self) -> Iterator[int]:
        a, b = 0, 1
        count = 0
        while count < self.limit:
            yield a
            a, b = b, a + b
            count += 1

    def __reversed__(self):
        # ต้องสร้าง list ก่อน
        return reversed(list(self))


for n in Fibonacci(10):
    print(n, end=" ")  # 0 1 1 2 3 5 8 13 21 34
```

**Context Manager:**
```python
class Timer:
    def __init__(self, name: str):
        self.name = name

    def __enter__(self):
        import time
        self.start = time.perf_counter()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        import time
        self.elapsed = time.perf_counter() - self.start
        print(f"{self.name}: {self.elapsed:.4f}s")
        return False  # ไม่ suppress exceptions


with Timer("Loop"):
    total = sum(i ** 2 for i in range(1000000))
```

**Callable:**
```python
class Multiplier:
    def __init__(self, factor: int):
        self.factor = factor

    def __call__(self, x: int) -> int:
        return x * self.factor


double = Multiplier(2)
triple = Multiplier(3)

print(double(5))   # 10
print(triple(5))   # 15

# ใช้เป็น function
print(list(map(double, [1, 2, 3])))  # [2, 4, 6]
```

**ตัวอย่างการใช้งานจริง — Matrix:**
```python
from typing import Union

class Matrix:
    def __init__(self, data: list[list[float]]):
        self.data = data
        self.rows = len(data)
        self.cols = len(data[0]) if data else 0

    def __repr__(self) -> str:
        rows = "\n".join(" ".join(f"{x:6.2f}" for x in row) for row in self.data)
        return f"Matrix:\n{rows}"

    def __add__(self, other: "Matrix") -> "Matrix":
        if (self.rows, self.cols) != (other.rows, other.cols):
            raise ValueError("Dimensions must match")
        result = [
            [self.data[i][j] + other.data[i][j] for j in range(self.cols)]
            for i in range(self.rows)
        ]
        return Matrix(result)

    def __mul__(self, other: Union["Matrix", float]) -> "Matrix":
        if isinstance(other, (int, float)):
            # Scalar multiplication
            result = [
                [x * other for x in row] for row in self.data
            ]
            return Matrix(result)

        # Matrix multiplication
        if self.cols != other.rows:
            raise ValueError("Cannot multiply")
        result = [
            [
                sum(self.data[i][k] * other.data[k][j] for k in range(self.cols))
                for j in range(other.cols)
            ]
            for i in range(self.rows)
        ]
        return Matrix(result)

    def __matmul__(self, other: "Matrix") -> "Matrix":
        """a @ b"""
        return self * other

    def __eq__(self, other) -> bool:
        return isinstance(other, Matrix) and self.data == other.data

    def __len__(self) -> int:
        return self.rows

    def __getitem__(self, key):
        """m[0] หรือ m[0, 1]"""
        if isinstance(key, tuple):
            i, j = key
            return self.data[i][j]
        return self.data[key]

    def transpose(self) -> "Matrix":
        result = [
            [self.data[i][j] for i in range(self.rows)]
            for j in range(self.cols)
        ]
        return Matrix(result)


m1 = Matrix([[1, 2], [3, 4]])
m2 = Matrix([[5, 6], [7, 8]])

print(m1 + m2)
print(m1 * m2)
print(m1 * 2)
print(m1[0, 1])       # 2
print(len(m1))        # 2
print(m1.transpose())
```

**ตัวอย่าง — Builder Pattern ด้วย Magic Methods:**
```python
class QueryBuilder:
    def __init__(self):
        self._select = "*"
        self._from = ""
        self._where: list[str] = []
        self._order_by = ""
        self._limit: int | None = None

    def __call__(self, *fields: str) -> "QueryBuilder":
        """SELECT fields"""
        self._select = ", ".join(fields) if fields else "*"
        return self

    def __getattr__(self, name: str):
        """table.fields"""
        # เรียก qb.users.age → เพิ่ม "users.age"
        if name.startswith("_"):
            raise AttributeError(name)
        return self.__class__()

    def from_(self, table: str) -> "QueryBuilder":
        self._from = table
        return self

    def where(self, condition: str) -> "QueryBuilder":
        self._where.append(condition)
        return self

    def order(self, field: str, desc: bool = False) -> "QueryBuilder":
        self._order_by = f"{field} {'DESC' if desc else 'ASC'}"
        return self

    def limit(self, n: int) -> "QueryBuilder":
        self._limit = n
        return self

    def build(self) -> str:
        parts = [f"SELECT {self._select}"]
        parts.append(f"FROM {self._from}")
        if self._where:
            parts.append("WHERE " + " AND ".join(self._where))
        if self._order_by:
            parts.append(f"ORDER BY {self._order_by}")
        if self._limit:
            parts.append(f"LIMIT {self._limit}")
        return " ".join(parts)


query = (
    QueryBuilder()
    ("name", "email")
    .from_("users")
    .where("age > 18")
    .where("active = true")
    .order("name")
    .limit(10)
    .build()
)
print(query)
# SELECT name, email FROM users WHERE age > 18 AND active = true ORDER BY name ASC LIMIT 10
```

### 5.13.4 ข้อดี

- **Pythonic:** ใช้ syntax ธรรมชาติ
- **Intuitive:** `+`, `len()`, `in` ทำงานได้
- **Consistent:** กับ built-in types
- **Powerful:** custom behaviors

### 5.13.5 ข้อเสีย

- **Magic:** อาจ obscure logic
- **Debugging:** ยากกว่า regular methods
- **Learning curve:** ต้องรู้จัก dunder
- **Overhead:** บาง dunder methods มี overhead

### 5.13.6 ข้อควรระวัง

```python
# ระวัง 1: __eq__ และ __hash__ ต้องสอดคล้องกัน
class Bad:
    def __eq__(self, other):
        return self.id == other.id
    # ❌ __hash__ หายไป → unhashable

class Good:
    def __init__(self, id):
        self.id = id

    def __eq__(self, other):
        return isinstance(other, Good) and self.id == other.id

    def __hash__(self):
        return hash(self.id)

# ระวัง 2: __eq__ ต้อง return NotImplemented สำหรับ types ที่ไม่รู้จัก
def __eq__(self, other):
    if not isinstance(other, MyType):
        return NotImplemented  # ✅
    return self.value == other.value

# ระวัง 3: __repr__ vs __str__
# __repr__ — debug, ควร unambiguous
# __str__ — user-friendly, default ใช้ __repr__

# ระวัง 4: __getitem__ กับ negative index
def __getitem__(self, index):
    if isinstance(index, slice):
        return self._data[index]
    if index < 0:
        index += len(self)
    return self._data[index]

# ระวัง 5: __init__ ควร return None
# อย่า return อะไร

# ระวัง 6: __bool__ สำหรับ truthiness
class Empty:
    def __len__(self):
        return 0
    # bool(Empty()) → False (จาก __len__)

class Custom:
    def __bool__(self):
        return self._is_valid
```

### 5.13.7 สรุป

**Magic Methods ที่ใช้บ่อย:**

| Method | เรียกโดย |
|--------|---------|
| `__init__` | `MyClass()` |
| `__str__` | `str()`, `print()` |
| `__repr__` | `repr()`, REPL |
| `__eq__` | `==` |
| `__lt__` | `<` |
| `__hash__` | `hash()` |
| `__add__` | `+` |
| `__len__` | `len()` |
| `__getitem__` | `obj[key]` |
| `__iter__` | `for` |
| `__next__` | `next()` |
| `__contains__` | `in` |
| `__enter__` | `with` |
| `__exit__` | `with` |
| `__call__` | `obj()` |

**Best practices:**
- `__eq__` และ `__hash__` คู่กัน
- `__repr__` ควร unambiguous
- ใช้ `total_ordering` สำหรับ comparisons
- `__eq__` return `NotImplemented`

> **อ้างอิงเพิ่มเติม:** [Data Model](https://docs.python.org/3/reference/datamodel.html)

---

## 5.14 Property

### บทนำ

Property เป็น built-in decorator ที่ให้ method ทำงานเหมือน attribute ใช้สำหรับ computed attributes, validation และ lazy evaluation

### นิยาม

Property คือ descriptor ที่ให้ control การเข้าถึง attribute ผ่าน getter, setter, deleter

### 5.14.1 คืออะไร

`property` เป็น class ที่ implement descriptor protocol ทำให้ method ถูกเรียกเมื่อ access attribute

### 5.14.2 ทำงานอย่างไร

```python
class MyClass:
    @property
    def value(self):
        return self._value

# เทียบเท่ากับ
class MyClass:
    def _get_value(self):
        return self._value
    value = property(_get_value)
```

### 5.14.3 การใช้งาน

**Basic Property:**
```python
class Circle:
    def __init__(self, radius: float):
        self.radius = radius

    @property
    def area(self) -> float:
        """Computed property (read-only)"""
        import math
        return math.pi * self.radius ** 2

    @property
    def circumference(self) -> float:
        import math
        return 2 * math.pi * self.radius


c = Circle(5)
print(c.area)           # 78.54
print(c.circumference)  # 31.42
# c.area = 100  # ❌ AttributeError: can't set attribute
```

**Getter + Setter:**
```python
class Temperature:
    def __init__(self, celsius: float = 0):
        self._celsius = 0  # ใช้ _ เพื่อไม่ให้ recursive
        self.celsius = celsius  # ผ่าน setter

    @property
    def celsius(self) -> float:
        return self._celsius

    @celsius.setter
    def celsius(self, value: float) -> None:
        if value < -273.15:
            raise ValueError("ต่ำกว่าศูนย์สัมบูรณ์")
        self._celsius = value

    @property
    def fahrenheit(self) -> float:
        return self._celsius * 9/5 + 32

    @fahrenheit.setter
    def fahrenheit(self, value: float) -> None:
        self.celsius = (value - 32) * 5/9


t = Temperature(25)
print(t.celsius)        # 25
print(t.fahrenheit)     # 77.0

t.fahrenheit = 100
print(t.celsius)        # 37.78

try:
    t.celsius = -300
except ValueError as e:
    print(f"Error: {e}")
```

**Deleter:**
```python
class Config:
    def __init__(self):
        self._data: dict = {}
        self._cache: dict = {}

    @property
    def value(self) -> str | None:
        return self._cache.get("value")

    @value.setter
    def value(self, v: str) -> None:
        self._cache["value"] = v

    @value.deleter
    def value(self) -> None:
        self._cache.pop("value", None)


config = Config()
config.value = "hello"
print(config.value)  # hello

del config.value
print(config.value)  # None
```

**Lazy Property:**
```python
class DataAnalyzer:
    def __init__(self, data: list[float]):
        self.data = data
        self._stats: dict | None = None

    @property
    def stats(self) -> dict:
        """คำนวณเมื่อต้องการครั้งแรก แล้ว cache"""
        if self._stats is None:
            print("Computing stats...")
            n = len(self.data)
            mean = sum(self.data) / n
            variance = sum((x - mean) ** 2 for x in self.data) / n
            self._stats = {
                "mean": mean,
                "variance": variance,
                "std": variance ** 0.5,
                "min": min(self.data),
                "max": max(self.data),
            }
        return self._stats


analyzer = DataAnalyzer([1, 2, 3, 4, 5])
print(analyzer.stats)  # Computing stats... { ... }
print(analyzer.stats)  # (ไม่ compute อีก)
```

**`cached_property` (Python 3.8+):**
```python
from functools import cached_property
import hashlib

class File:
    def __init__(self, path: str):
        self.path = path

    @cached_property
    def content(self) -> str:
        """อ่านไฟล์ครั้งเดียว"""
        print(f"Reading {self.path}")
        with open(self.path, encoding="utf-8") as f:
            return f.read()

    @cached_property
    def hash(self) -> str:
        """คำนวณ hash ครั้งเดียว"""
        return hashlib.sha256(self.content.encode()).hexdigest()


# f = File("data.txt")
# print(f.content)  # Reading data.txt ...
# print(f.content)  # (ไม่ print อีก)
```

**Property กับ Inheritance:**
```python
class Base:
    @property
    def value(self) -> int:
        return 42


class Child(Base):
    @property
    def value(self) -> int:
        # Override
        return super().value * 2


print(Child().value)  # 84
```

**ตัวอย่างการใช้งานจริง — Model with Validation:**
```python
import re
from datetime import datetime
from typing import Optional

class User:
    """User model with property validation"""

    EMAIL_PATTERN = re.compile(r"^[\w.+-]+@[\w-]+\.[\w.]+$")

    def __init__(
        self,
        username: str,
        email: str,
        age: int,
        password: str,
    ):
        self.username = username
        self.email = email
        self.age = age
        self.password = password
        self._created_at = datetime.now()

    @property
    def username(self) -> str:
        return self._username

    @username.setter
    def username(self, value: str) -> None:
        if not re.match(r"^[a-zA-Z0-9_]{3,20}$", value):
            raise ValueError(
                "Username ต้องมี 3-20 ตัวอักษร (a-z, A-Z, 0-9, _)"
            )
        self._username = value

    @property
    def email(self) -> str:
        return self._email

    @email.setter
    def email(self, value: str) -> None:
        if not self.EMAIL_PATTERN.match(value):
            raise ValueError(f"Invalid email: {value}")
        self._email = value.lower()

    @property
    def age(self) -> int:
        return self._age

    @age.setter
    def age(self, value: int) -> None:
        if not 0 <= value <= 150:
            raise ValueError("Age ต้องอยู่ระหว่าง 0-150")
        self._age = value

    @property
    def password(self) -> str:
        """ไม่ควรเข้าถึง — return masked"""
        return "********"

    @password.setter
    def password(self, value: str) -> None:
        if len(value) < 8:
            raise ValueError("Password ต้องมีอย่างน้อย 8 ตัวอักษร")
        # Hash จริง ๆ ควรใช้ bcrypt
        import hashlib
        self._password_hash = hashlib.sha256(
            value.encode()
        ).hexdigest()

    def verify_password(self, password: str) -> bool:
        import hashlib
        return self._password_hash == hashlib.sha256(
            password.encode()
        ).hexdigest()

    @property
    def created_at(self) -> datetime:
        return self._created_at

    def __repr__(self) -> str:
        return f"User(username={self._username!r}, email={self._email!r})"


# การใช้งาน
user = User("somchai", "Somchai@Email.com", 30, "Secure123")
print(user)               # User(username='somchai', email='somchai@email.com')
print(user.password)      # ********
print(user.verify_password("Secure123"))  # True

try:
    user.age = 200
except ValueError as e:
    print(f"Error: {e}")
```

**ตัวอย่าง — Money with Currency:**
```python
from decimal import Decimal

class Money:
    def __init__(self, amount: Decimal | float, currency: str = "THB"):
        self.amount = Decimal(str(amount))
        self.currency = currency.upper()
        self._history: list[str] = []

    @property
    def amount(self) -> Decimal:
        return self._amount

    @amount.setter
    def amount(self, value: Decimal) -> None:
        if not isinstance(value, Decimal):
            value = Decimal(str(value))
        if value < 0:
            raise ValueError("Amount ต้องไม่ติดลบ")
        self._amount = value.quantize(Decimal("0.01"))

    @property
    def currency(self) -> str:
        return self._currency

    @currency.setter
    def currency(self, value: str) -> None:
        if len(value) != 3 or not value.isalpha():
            raise ValueError("Currency ต้องเป็น 3-letter code")
        self._currency = value.upper()

    @property
    def formatted(self) -> str:
        return f"{self._amount:,.2f} {self._currency}"

    def __add__(self, other: "Money") -> "Money":
        if self._currency != other._currency:
            raise ValueError("สกุลเงินต้องตรงกัน")
        return Money(self._amount + other._amount, self._currency)

    def __str__(self) -> str:
        return self.formatted


m = Money(1234.567, "thb")
print(m)               # 1,234.57 THB
print(m.currency)      # THB

# ❌ จะ error
try:
    m2 = Money(-100)
except ValueError as e:
    print(f"Error: {e}")
```

### 5.14.4 ข้อดี

- **Clean syntax:** `obj.value` แทน `obj.get_value()`
- **Validation:** setter ตรวจสอบได้
- **Computed:** คำนวณจาก attributes อื่น
- **Backward compatible:** เปลี่ยน attribute เป็น property ได้

### 5.14.5 ข้อเสีย

- **Overhead:** property ช้ากว่า attribute ปกติ
- **Verbose:** ต้องเขียน getter/setter
- **Confusing:** อาจสับสนกับ attribute ปกติ
- **Not free:** ทุก access มี function call

### 5.14.6 ข้อควรระวัง

```python
# ระวัง 1: Recursive setter
class Bad:
    @property
    def value(self):
        return self.value  # ❌ RecursionError

    @value.setter
    def value(self, v):
        self.value = v  # ❌ RecursionError

# ✅ ใช้ _value
class Good:
    @property
    def value(self):
        return self._value

    @value.setter
    def value(self, v):
        self._value = v

# ระวัง 2: Property ที่มี side effects
class Bad2:
    @property
    def value(self):
        self.counter += 1  # ❌ side effect
        return self._value

# ระวัง 3: __init__ ต้องใช้ setter
class Good2:
    def __init__(self, value):
        # ✅ ผ่าน setter (validate)
        self.value = value
        # ❌ self._value = value (ข้าม validate)

# ระวัง 4: Property vs Class attribute
class MyClass:
    @property
    def value(self):
        return 42

# MyClass.value  # <property object> ไม่ใช่ 42
# MyClass().value  # 42

# ระวัง 5: Property กับ type hints
class MyClass:
    @property
    def value(self) -> int:
        return self._value

    @value.setter
    def value(self, v: int) -> None:
        self._value = v

# Type checker เห็นเป็น int
```

### 5.14.7 สรุป

**ใช้ Property เมื่อ:**
- Computed attributes
- Validation
- Lazy evaluation
- Backward compatibility (เปลี่ยน attr → property)

**ใช้ Attribute ปกติ เมื่อ:**
- เก็บค่าตรง ๆ
- ไม่ต้อง validation
- Performance critical

**Best practices:**
- ใช้ `_name` สำหรับ storage
- `__init__` ผ่าน setter
- หลีกเลี่ยง side effects
- ใช้ `cached_property` สำหรับ expensive computations

> **อ้างอิงเพิ่มเติม:** [property Documentation](https://docs.python.org/3/library/functions.html#property), [Descriptor HowTo](https://docs.python.org/3/howto/descriptor.html)

---

## 5.15 Class Method

### บทนำ

Class Method เป็น method ที่ผูกกับ class ไม่ใช่ instance ใช้สำหรับ alternative constructors, factory methods และ operations ที่เกี่ยวกับ class ทั้งหมด

### นิยาม

Class Method คือ method ที่รับ `cls` (class) เป็น argument แรก แทน `self` (instance)

### 5.15.1 คืออะไร

- ใช้ `@classmethod` decorator
- รับ `cls` เป็น argument แรก
- เรียกได้ทั้ง class และ instance
- เข้าถึง class attributes/methods

### 5.15.2 ทำงานอย่างไร

เมื่อเรียก `MyClass.method()` หรือ `instance.method()`:
- Python pass class เป็น argument แรก (cls)

### 5.15.3 การใช้งาน

**Alternative Constructor:**
```python
from datetime import datetime

class Date:
    def __init__(self, year: int, month: int, day: int):
        self.year = year
        self.month = month
        self.day = day

    @classmethod
    def from_string(cls, date_str: str) -> "Date":
        """สร้างจาก 'YYYY-MM-DD'"""
        year, month, day = map(int, date_str.split("-"))
        return cls(year, month, day)

    @classmethod
    def from_datetime(cls, dt: datetime) -> "Date":
        return cls(dt.year, dt.month, dt.day)

    @classmethod
    def today(cls) -> "Date":
        return cls.from_datetime(datetime.now())

    @classmethod
    def from_dict(cls, data: dict) -> "Date":
        return cls(**data)

    def __repr__(self) -> str:
        return f"Date({self.year}, {self.month}, {self.day})"

    def __str__(self) -> str:
        return f"{self.year:04d}-{self.month:02d}-{self.day:02d}"


# หลายวิธีสร้าง
d1 = Date(2024, 1, 15)
d2 = Date.from_string("2024-01-15")
d3 = Date.from_datetime(datetime.now())
d4 = Date.today()
d5 = Date.from_dict({"year": 2024, "month": 1, "day": 15})

print(d1)  # 2024-01-15
```

**Factory Method:**
```python
class Shape:
    def area(self) -> float:
        raise NotImplementedError

    @classmethod
    def create(cls, shape_type: str, **kwargs) -> "Shape":
        """Factory method"""
        shapes = {
            "circle": Circle,
            "rectangle": Rectangle,
            "triangle": Triangle,
        }
        if shape_type not in shapes:
            raise ValueError(f"Unknown shape: {shape_type}")
        return shapes[shape_type](**kwargs)


class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius

    def area(self) -> float:
        import math
        return math.pi * self.radius ** 2


class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height

    def area(self) -> float:
        return self.width * self.height


class Triangle(Shape):
    def __init__(self, base: float, height: float):
        self.base = base
        self.height = height

    def area(self) -> float:
        return 0.5 * self.base * self.height


# ใช้ factory method
circle = Shape.create("circle", radius=5)
rect = Shape.create("rectangle", width=4, height=6)
print(circle.area())  # 78.54
print(rect.area())    # 24
```

**Class-level State:**
```python
class User:
    _next_id = 1
    _count = 0

    def __init__(self, name: str):
        self.id = User._next_id
        User._next_id += 1
        User._count += 1
        self.name = name

    @classmethod
    def get_count(cls) -> int:
        return cls._count

    @classmethod
    def reset_counter(cls) -> None:
        cls._next_id = 1
        cls._count = 0


u1 = User("Alice")
u2 = User("Bob")
print(User.get_count())  # 2

User.reset_counter()
print(User.get_count())  # 0
```

**`super()` ใน Class Method:**
```python
class Base:
    @classmethod
    def create(cls, data: dict) -> "Base":
        print(f"Base.create for {cls.__name__}")
        return cls()


class Child(Base):
    @classmethod
    def create(cls, data: dict) -> "Child":
        # เรียก parent classmethod
        base = super().create(data)
        print(f"Child customization")
        return cls()


# cls จะเป็น Child ไม่ใช่ Base
obj = Child.create({})
# Base.create for Child
# Child customization
print(type(obj).__name__)  # Child
```

**`classmethod` vs `staticmethod`:**
```python
class MyClass:
    class_var = "class"

    @classmethod
    def class_method(cls):
        """รับ cls"""
        print(f"Class method: {cls.__name__}")
        print(f"Class var: {cls.class_var}")
        return cls()

    @staticmethod
    def static_method():
        """ไม่รับ cls หรือ self"""
        print("Static method")
        # ❌ เข้าถึง class_var ไม่ได้โดยตรง
        # ✅ ใช้ MyClass.class_var


MyClass.class_method()   # Class method: MyClass
MyClass.static_method()  # Static method
```

**ตัวอย่างการใช้งานจริง — Repository Factory:**
```python
from abc import ABC, abstractmethod
from typing import Generic, TypeVar

T = TypeVar("T")

class Repository(ABC, Generic[T]):
    """Abstract repository"""

    _instances: dict[str, "Repository"] = {}

    @classmethod
    def get_instance(cls) -> "Repository":
        """Singleton-like factory"""
        name = cls.__name__
        if name not in cls._instances:
            cls._instances[name] = cls()
        return cls._instances[name]

    @abstractmethod
    def find(self, id_: int) -> T | None:
        pass

    @abstractmethod
    def save(self, item: T) -> T:
        pass


class UserRepository(Repository[dict]):
    def __init__(self):
        self._data: dict[int, dict] = {}
        self._next_id = 1

    def find(self, id_: int) -> dict | None:
        return self._data.get(id_)

    def save(self, item: dict) -> dict:
        id_ = item.get("id") or self._next_id
        self._next_id = max(self._next_id, id_ + 1)
        item["id"] = id_
        self._data[id_] = item
        return item


# Singleton per class
repo1 = UserRepository.get_instance()
repo2 = UserRepository.get_instance()
print(repo1 is repo2)  # True
```

**ตัวอย่าง — Configuration:**
```python
import json
import os
from pathlib import Path

class Config:
    _instance: "Config | None" = None
    _data: dict = {}

    def __init__(self):
        # Private constructor
        pass

    @classmethod
    def load(cls, path: str | None = None) -> "Config":
        """Load configuration"""
        if cls._instance is None:
            cls._instance = cls()

        if path:
            with open(path, encoding="utf-8") as f:
                cls._data = json.load(f)

        # Override with env vars
        for key, value in os.environ.items():
            if key.startswith("APP_"):
                config_key = key[4:].lower()
                cls._data[config_key] = value

        return cls._instance

    @classmethod
    def get(cls, key: str, default=None):
        return cls._data.get(key, default)

    @classmethod
    def set(cls, key: str, value) -> None:
        cls._data[key] = value

    @classmethod
    def reset(cls) -> None:
        cls._instance = None
        cls._data = {}


# การใช้งาน
config = Config.load()
Config.set("debug", True)
print(Config.get("debug"))  # True
```

**ตัวอย่าง — Plugin Registry:**
```python
from typing import Callable, Type

class PluginRegistry:
    _plugins: dict[str, type] = {}

    @classmethod
    def register(cls, name: str) -> Callable:
        """Decorator สำหรับ register plugin"""
        def decorator(plugin_class: type) -> type:
            cls._plugins[name] = plugin_class
            return plugin_class
        return decorator

    @classmethod
    def get(cls, name: str) -> type:
        if name not in cls._plugins:
            raise ValueError(f"Plugin not found: {name}")
        return cls._plugins[name]

    @classmethod
    def create(cls, name: str, **kwargs):
        plugin_class = cls.get(name)
        return plugin_class(**kwargs)

    @classmethod
    def list_plugins(cls) -> list[str]:
        return list(cls._plugins.keys())


# Register plugins
@PluginRegistry.register("csv")
class CSVPlugin:
    def __init__(self, path: str):
        self.path = path


@PluginRegistry.register("json")
class JSONPlugin:
    def __init__(self, path: str):
        self.path = path


# ใช้งาน
print(PluginRegistry.list_plugins())  # ['csv', 'json']

plugin = PluginRegistry.create("csv", path="data.csv")
print(type(plugin).__name__)  # CSVPlugin
```

### 5.15.4 ข้อดี

- **Alternative constructors:** สร้างได้หลายวิธี
- **Factory methods:** สร้าง objects
- **Class-level state:** เข้าถึงได้
- **Polymorphic:** `cls` ปรับตาม subclass
- **Singleton:** จัดการ instances

### 5.15.5 ข้อเสีย

- **Confusing:** กับ static method
- **Abuse:** อาจใช้ผิดวัตถุประสงค์
- **Testability:** singleton ยาก test

### 5.15.6 ข้อควรระวัง

```python
# ระวัง 1: classmethod ต้อง return cls() ไม่ใช่ ClassName()
class Base:
    @classmethod
    def create(cls) -> "Base":
        # ❌ return Base() — ไม่ polymorphic
        return cls()  # ✅ ใช้ cls

class Child(Base):
    pass

print(type(Child.create()).__name__)  # Child ✅

# ระวัง 2: classmethod กับ inheritance
class Parent:
    @classmethod
    def create(cls):
        return cls()  # cls เป็น subclass

class Child(Parent):
    def __init__(self):
        super().__init__()
        self.extra = "child"

obj = Child.create()
print(obj.extra)  # "child"

# ระวัง 3: classmethod vs instance method
class MyClass:
    def instance_method(self):
        return self

    @classmethod
    def class_method(cls):
        return cls()  # ไม่มี self

# ระวัง 4: class attribute แก้ผ่าน cls
class MyClass:
    counter = 0

    @classmethod
    def increment(cls):
        cls.counter += 1  # ✅ แก้ class attr

# ระวัง 5: อย่าใช้ classmethod สำหรับ logic ที่ต้องการ instance
```

### 5.15.7 สรุป

**ใช้ `@classmethod` เมื่อ:**
- **Alternative constructors:** `from_string()`, `from_dict()`
- **Factory methods:** `create()`, `build()`
- **Class-level operations:** counter, registry
- **Polymorphic creation:** ใช้ `cls()`

**ใช้ `@staticmethod` เมื่อ:**
- Utility functions ที่ไม่ต้อง state
- Helper functions
- ไม่ต้องการ instance หรือ class

**Best practices:**
- ใช้ `cls()` สำหรับ polymorphism
- Document alternative constructors
- หลีกเลี่ยง class state ที่ซับซ้อน
- ใช้ `singledispatch` สำหรับ type-based

> **อ้างอิงเพิ่มเติม:** [classmethod Documentation](https://docs.python.org/3/library/functions.html#classmethod)

---

## 5.16 Static Method

### บทนำ

Static Method เป็น method ที่ไม่ผูกกับ instance หรือ class ใช้เป็น utility functions ที่ logically อยู่ใน class

### นิยาม

Static Method คือ method ที่ไม่รับ `self` หรือ `cls` เป็น argument แรก

### 5.16.1 คืออะไร

- ใช้ `@staticmethod` decorator
- ไม่รับ self หรือ cls
- เรียกได้ทั้ง class และ instance
- เหมือน regular function แต่ namespace ใน class

### 5.16.2 ทำงานอย่างไร

Python ไม่ pass อะไรให้ automatic ต้อง pass arguments เอง

### 5.16.3 การใช้งาน

**Utility Functions:**
```python
class MathUtils:
    @staticmethod
    def add(a: float, b: float) -> float:
        return a + b

    @staticmethod
    def is_prime(n: int) -> bool:
        if n < 2:
            return False
        for i in range(2, int(n ** 0.5) + 1):
            if n % i == 0:
                return False
        return True

    @staticmethod
    def factorial(n: int) -> int:
        if n <= 1:
            return 1
        result = 1
        for i in range(2, n + 1):
            result *= i
        return result


print(MathUtils.add(2, 3))         # 5
print(MathUtils.is_prime(17))      # True
print(MathUtils.factorial(5))      # 120

# เรียกผ่าน instance ได้
m = MathUtils()
print(m.add(1, 2))  # 3
```

**Validation:**
```python
import re

class Validator:
    @staticmethod
    def is_email(value: str) -> bool:
        pattern = r"^[\w.+-]+@[\w-]+\.[\w.]+$"
        return bool(re.match(pattern, value))

    @staticmethod
    def is_phone(value: str) -> bool:
        pattern = r"^0\d{9}$"
        return bool(re.match(pattern, value))

    @staticmethod
    def is_strong_password(value: str) -> bool:
        if len(value) < 8:
            return False
        has_upper = any(c.isupper() for c in value)
        has_lower = any(c.islower() for c in value)
        has_digit = any(c.isdigit() for c in value)
        return has_upper and has_lower and has_digit


print(Validator.is_email("test@example.com"))     # True
print(Validator.is_phone("0812345678"))           # True
print(Validator.is_strong_password("Secure123"))  # True
```

**Factory-like Static Methods:**
```python
class Converter:
    @staticmethod
    def celsius_to_fahrenheit(c: float) -> float:
        return c * 9/5 + 32

    @staticmethod
    def fahrenheit_to_celsius(f: float) -> float:
        return (f - 32) * 5/9

    @staticmethod
    def celsius_to_kelvin(c: float) -> float:
        return c + 273.15

    @staticmethod
    def kelvin_to_celsius(k: float) -> float:
        return k - 273.15


print(Converter.celsius_to_fahrenheit(25))  # 77.0
print(Converter.fahrenheit_to_celsius(77))  # 25.0
```

**Static Method กับ Decorators:**
```python
class API:
    @staticmethod
    @lru_cache(maxsize=128)
    def expensive_computation(n: int) -> int:
        """Static method with cache"""
        import time
        time.sleep(0.1)
        return n ** 2


from functools import lru_cache
print(API.expensive_computation(5))  # 25
print(API.expensive_computation(5))  # 25 (cached)
```

**ตัวอย่างการใช้งานจริง — Format Utils:**
```python
from datetime import datetime
from decimal import Decimal
from typing import Any

class Formatters:
    """Collection of static formatting utilities"""

    @staticmethod
    def currency(amount: float | Decimal, symbol: str = "฿") -> str:
        return f"{symbol}{amount:,.2f}"

    @staticmethod
    def percentage(value: float, decimals: int = 2) -> str:
        return f"{value:.{decimals}%}"

    @staticmethod
    def file_size(bytes_: int) -> str:
        for unit in ["B", "KB", "MB", "GB", "TB"]:
            if bytes_ < 1024:
                return f"{bytes_:.2f} {unit}"
            bytes_ /= 1024
        return f"{bytes_:.2f} PB"

    @staticmethod
    def relative_time(dt: datetime) -> str:
        delta = datetime.now() - dt
        seconds = int(delta.total_seconds())

        if seconds < 60:
            return f"{seconds} วินาทีที่แล้ว"
        elif seconds < 3600:
            return f"{seconds // 60} นาทีที่แล้ว"
        elif seconds < 86400:
            return f"{seconds // 3600} ชั่วโมงที่แล้ว"
        else:
            return f"{seconds // 86400} วันที่แล้ว"

    @staticmethod
    def truncate(text: str, length: int = 50, suffix: str = "...") -> str:
        if len(text) <= length:
            return text
        return text[:length - len(suffix)] + suffix


# การใช้งาน
print(Formatters.currency(1234.5))         # ฿1,234.50
print(Formatters.percentage(0.8567))       # 85.67%
print(Formatters.file_size(1536000))       # 1.46 MB
print(Formatters.truncate("ข้อความยาว...", 10))  # ข้อความ...
```

**ตัวอย่าง — Data Transformation:**
```python
from typing import Any
import json
from datetime import datetime

class DataTransform:
    """Static methods สำหรับ transform data"""

    @staticmethod
    def to_snake_case(name: str) -> str:
        """CamelCase → snake_case"""
        import re
        s1 = re.sub(r"(.)([A-Z][a-z]+)", r"\1_\2", name)
        return re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", s1).lower()

    @staticmethod
    def to_camel_case(name: str) -> str:
        """snake_case → camelCase"""
        parts = name.split("_")
        return parts[0] + "".join(p.title() for p in parts[1:])

    @staticmethod
    def flatten(data: dict, prefix: str = "") -> dict:
        """Flatten nested dict"""
        result = {}
        for key, value in data.items():
            new_key = f"{prefix}.{key}" if prefix else key
            if isinstance(value, dict):
                result.update(DataTransform.flatten(value, new_key))
            else:
                result[new_key] = value
        return result

    @staticmethod
    def serialize_json(data: Any) -> str:
        """Serialize with default handler"""
        def default(obj):
            if isinstance(obj, datetime):
                return obj.isoformat()
            if hasattr(obj, "__dict__"):
                return obj.__dict__
            return str(obj)

        return json.dumps(data, default=default)


# การใช้งาน
print(DataTransform.to_snake_case("CamelCaseName"))  # camel_case_name
print(DataTransform.to_camel_case("snake_case_name"))  # snakeCaseName

nested = {"a": {"b": {"c": 1}}, "d": 2}
print(DataTransform.flatten(nested))
# {'a.b.c': 1, 'd': 2}
```

**Static Method สำหรับ Validation Schema:**
```python
from typing import Any

class Schema:
    """Static validation methods"""

    @staticmethod
    def validate_type(value: Any, expected_type: type) -> bool:
        return isinstance(value, expected_type)

    @staticmethod
    def validate_range(value: float, min_val: float, max_val: float) -> bool:
        return min_val <= value <= max_val

    @staticmethod
    def validate_length(value: str | list, min_len: int, max_len: int) -> bool:
        return min_len <= len(value) <= max_len

    @staticmethod
    def validate_pattern(value: str, pattern: str) -> bool:
        import re
        return bool(re.match(pattern, value))

    @staticmethod
    def validate_required(data: dict, keys: list[str]) -> list[str]:
        """Return missing keys"""
        return [k for k in keys if k not in data or data[k] is None]


# การใช้งาน
print(Schema.validate_type(42, int))            # True
print(Schema.validate_range(25, 0, 100))       # True
print(Schema.validate_length("hello", 1, 10))  # True
print(Schema.validate_required({"a": 1}, ["a", "b"]))  # ['b']
```

### 5.16.4 ข้อดี

- **Namespace:** จัดกลุ่ม utility functions
- **No state:** ไม่ต้อง instance
- **Testable:** ทดสอบง่าย
- **Reusable:** ใช้ได้ทุกที่

### 5.16.5 ข้อเสีย

- **No inheritance:** ไม่ polymorphic
- **Can be outside class:** ไม่จำเป็นต้องอยู่ใน class
- **Overhead:** namespace lookup
- **Confusing:** กับ class/instance methods

### 5.16.6 ข้อควรระวัง

```python
# ระวัง 1: Static method ไม่ polymorphic
class Base:
    @staticmethod
    def create():
        return "base"

class Child(Base):
    pass

print(Child.create())  # "base" — ไม่ polymorphic

# ✅ ใช้ classmethod สำหรับ polymorphism
class Base2:
    @classmethod
    def create(cls):
        return cls.__name__

class Child2(Base2):
    pass

print(Child2.create())  # "Child2"

# ระวัง 2: ถ้าไม่ต้องใช้ class context ใช้ function ปกติได้
# ❌ ไม่จำเป็น
class Math:
    @staticmethod
    def add(a, b):
        return a + b

# ✅ ก็ได้
def add(a, b):
    return a + b

# ระวัง 3: Static method ใช้ self/cls ไม่ได้
class Bad:
    @staticmethod
    def method():
        # ❌ print(self)  # NameError
        # ❌ print(cls)   # NameError
        pass

# ระวัง 4: อย่าใช้ static method สำหรับ state
```

### 5.16.7 สรุป

**ใช้ `@staticmethod` เมื่อ:**
- Utility functions ที่ logically อยู่ใน class
- ไม่ต้อง instance/class state
- Helper functions
- Validation, formatting

**ใช้ function ปกติ เมื่อ:**
- ไม่ต้อง namespace ใน class
- Utility ที่ไม่ผูกกับ class

**ใช้ `@classmethod` เมื่อ:**
- ต้องการ polymorphism
- ต้องการ class state
- Alternative constructors

> **อ้างอิงเพิ่มเติม:** [staticmethod Documentation](https://docs.python.org/3/library/functions.html#staticmethod)

---

## 5.17 Dataclass

### บทนำ

Dataclass เป็น decorator ที่ generate boilerplate code (init, repr, eq) อัตโนมัติ ลดโค้ดซ้ำและเพิ่ม readability

### นิยาม

`@dataclass` เป็น decorator ที่สร้าง `__init__`, `__repr__`, `__eq__` จาก class annotations

### 5.17.1 คืออะไร

Features:
- Auto-generate `__init__`, `__repr__`, `__eq__`
- Field defaults
- Type hints
- `frozen` (immutable)
- `order` (comparison)
- `slots` (memory)

### 5.17.2 ทำงานอย่างไร

`@dataclass` inspect `__annotations__` และ generate methods ตาม field definitions

### 5.17.3 การใช้งาน

**Basic Dataclass:**
```python
from dataclasses import dataclass, field
from typing import Optional

@dataclass
class User:
    name: str
    email: str
    age: int = 0
    is_active: bool = True
    tags: list[str] = field(default_factory=list)

# Auto-generated __init__
user = User("สมชาย", "somchai@email.com", 30)
print(user)
# User(name='สมชาย', email='somchai@email.com', age=30, is_active=True, tags=[])

# Auto __eq__
user2 = User("สมชาย", "somchai@email.com", 30)
print(user == user2)  # True
```

**Default Values:**
```python
from dataclasses import dataclass, field
from datetime import datetime

@dataclass
class Config:
    host: str = "localhost"
    port: int = 8080
    debug: bool = False
    tags: list[str] = field(default_factory=list)
    metadata: dict = field(default_factory=dict)
    created_at: datetime = field(default_factory=datetime.now)
    _internal: str = field(default="", repr=False)


# ❌ mutable default ปกติใช้ไม่ได้
# @dataclass
# class Bad:
#     items: list = []  # ValueError

# ✅ ใช้ field(default_factory=...)
@dataclass
class Good:
    items: list = field(default_factory=list)
```

**Frozen (Immutable):**
```python
@dataclass(frozen=True)
class Point:
    x: float
    y: float


p = Point(1.0, 2.0)
# p.x = 3.0  # ❌ FrozenInstanceError

# แต่สามารถ hash ได้
print(hash(p))  # ใช้เป็น dict key ได้
d = {p: "origin"}
print(d[Point(1.0, 2.0)])  # "origin"
```

**Order (Comparisons):**
```python
@dataclass(order=True)
class Version:
    major: int
    minor: int
    patch: int


versions = [
    Version(1, 2, 3),
    Version(2, 0, 0),
    Version(1, 10, 0),
]

for v in sorted(versions):
    print(v)
# Version(major=1, minor=2, patch=3)
# Version(major=1, minor=10, patch=0)
# Version(major=2, minor=0, patch=0)
```

**Inheritance:**
```python
@dataclass
class Person:
    name: str
    age: int


@dataclass
class Employee(Person):
    employee_id: str
    salary: float = 0.0


emp = Employee("สมชาย", 30, "EMP001", 50000)
print(emp)
# Employee(name='สมชาย', age=30, employee_id='EMP001', salary=50000.0)
```

**Post-init Processing:**
```python
@dataclass
class User:
    name: str
    email: str
    age: int

    def __post_init__(self):
        """เรียกหลัง __init__ — สำหรับ validation, computed fields"""
        self.email = self.email.lower()
        if self.age < 0:
            raise ValueError("Age ต้องไม่ติดลบ")
        # Computed field
        self.username = self.email.split("@")[0]


user = User("สมชาย", "Somchai@Email.COM", 30)
print(user.email)     # somchai@email.com
print(user.username)  # somchai
```

**Field Options:**
```python
@dataclass
class Product:
    id: int
    name: str
    price: float
    internal_code: str = field(repr=False)  # ไม่แสดงใน repr
    secret: str = field(repr=False, default="")
    computed: str = field(init=False, default="")  # ไม่รับใน __init__

    def __post_init__(self):
        self.computed = f"{self.name}-{self.id}"


p = Product(1, "Laptop", 35000, "INT-001")
print(p)
# Product(id=1, name='Laptop', price=35000)
```

**`slots=True` (Python 3.10+):**
```python
@dataclass(slots=True)
class Point:
    x: float
    y: float


import sys
p = Point(1.0, 2.0)
print(sys.getsizeof(p))  # เล็กกว่า class ปกติ
```

**ตัวอย่างการใช้งานจริง — Domain Model:**
```python
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from decimal import Decimal
from typing import Optional
from uuid import UUID, uuid4

class OrderStatus(Enum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    SHIPPED = "shipped"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"


@dataclass
class OrderItem:
    product_id: UUID
    product_name: str
    quantity: int
    unit_price: Decimal

    def __post_init__(self):
        if self.quantity <= 0:
            raise ValueError("Quantity ต้องมากกว่า 0")
        if self.unit_price < 0:
            raise ValueError("Price ต้องไม่ติดลบ")

    @property
    def subtotal(self) -> Decimal:
        return self.unit_price * self.quantity


@dataclass
class Order:
    customer_id: UUID
    items: list[OrderItem] = field(default_factory=list)
    status: OrderStatus = OrderStatus.PENDING
    id: UUID = field(default_factory=uuid4)
    created_at: datetime = field(default_factory=datetime.now)
    updated_at: datetime = field(default_factory=datetime.now)
    notes: Optional[str] = None
    _internal_flag: bool = field(default=False, repr=False)

    @property
    def total(self) -> Decimal:
        return sum(item.subtotal for item in self.items)

    def add_item(self, item: OrderItem) -> None:
        if self.status != OrderStatus.PENDING:
            raise ValueError("ไม่สามารถเพิ่มสินค้าได้")
        self.items.append(item)
        self.updated_at = datetime.now()

    def confirm(self) -> None:
        if not self.items:
            raise ValueError("ไม่มีสินค้า")
        self.status = OrderStatus.CONFIRMED
        self.updated_at = datetime.now()

    def cancel(self, reason: str = "") -> None:
        if self.status == OrderStatus.SHIPPED:
            raise ValueError("ไม่สามารถยกเลิกได้")
        self.status = OrderStatus.CANCELLED
        self.notes = reason
        self.updated_at = datetime.now()


# การใช้งาน
order = Order(customer_id=uuid4())
order.add_item(OrderItem(
    product_id=uuid4(),
    product_name="Laptop",
    quantity=1,
    unit_price=Decimal("35000"),
))
order.add_item(OrderItem(
    product_id=uuid4(),
    product_name="Mouse",
    quantity=2,
    unit_price=Decimal("850"),
))

print(f"Total: ฿{order.total:,.2f}")  # ฿36,700.00
order.confirm()
print(f"Status: {order.status.value}")  # confirmed
```

**ตัวอย่าง — API Response:**
```python
from dataclasses import dataclass, asdict, field
from typing import Any, Generic, TypeVar, Optional
import json

T = TypeVar("T")

@dataclass
class APIResponse(Generic[T]):
    success: bool
    data: Optional[T] = None
    error: Optional[str] = None
    meta: dict[str, Any] = field(default_factory=dict)

    def to_json(self) -> str:
        return json.dumps(asdict(self), default=str)

    @classmethod
    def ok(cls, data: T, **meta) -> "APIResponse[T]":
        return cls(success=True, data=data, meta=meta)

    @classmethod
    def fail(cls, error: str, **meta) -> "APIResponse[T]":
        return cls(success=False, error=error, meta=meta)


# การใช้งาน
response = APIResponse.ok(
    {"id": 1, "name": "สมชาย"},
    page=1,
    total=100,
)
print(response.to_json())
# {"success": true, "data": {"id": 1, "name": "สมชาย"}, "error": null, "meta": {"page": 1, "total": 100}}

error = APIResponse.fail("Not found")
print(error.to_json())
```

**Dataclass vs Alternatives:**
```python
# 1. NamedTuple — immutable, tuple-like
from typing import NamedTuple

class Point(NamedTuple):
    x: float
    y: float

# 2. attrs — feature-rich
# pip install attrs
import attr

@attr.s
class Point3:
    x = attr.ib()
    y = attr.ib()

# 3. Pydantic — validation + serialization
from pydantic import BaseModel, Field

class UserModel(BaseModel):
    name: str = Field(min_length=1)
    age: int = Field(ge=0, le=150)

# 4. dataclass — standard library
from dataclasses import dataclass

@dataclass
class UserDC:
    name: str
    age: int
```

### 5.17.4 ข้อดี

- **Less boilerplate:** ไม่ต้องเขียน `__init__` เอง
- **Type hints:** ใช้ annotations
- **Immutable option:** `frozen=True`
- **Field control:** `field()` สำหรับ options
- **Standard library:** ไม่ต้อง install

### 5.17.5 ข้อเสีย

- **No validation:** ไม่ validate by default (ต้องใช้ `__post_init__`)
- **Limited:** ไม่มี serialization
- **`__post_init__`:** อาจสับสน

### 5.17.6 ข้อควรระวัง

```python
# ระวัง 1: mutable default
# ❌
@dataclass
class Bad:
    items: list = []  # ValueError

# ✅
@dataclass
class Good:
    items: list = field(default_factory=list)

# ระวัง 2: inheritance กับ defaults
@dataclass
class Base:
    a: int = 0

@dataclass
class Child(Base):
    b: int = 0  # ✅ OK — defaults อยู่ท้าย

# ❌ ถ้า Child มี field ที่ไม่มี default หลัง Base ที่มี default

# ระวัง 3: field(init=False) กับ computed
@dataclass
class Item:
    price: float
    qty: int
    total: float = field(init=False)

    def __post_init__(self):
        self.total = self.price * self.qty

# ระวัง 4: frozen + __post_init__
@dataclass(frozen=True)
class Point:
    x: float
    y: float
    mag: float = field(init=False)

    def __post_init__(self):
        # ต้องใช้ object.__setattr__ สำหรับ frozen
        object.__setattr__(self, "mag", (self.x**2 + self.y**2) ** 0.5)

# ระวัง 5: asdict() กับ nested objects
# ✅ asdict() recursive
# ❌ ไม่จัดการ custom types (ต้องใช้ default=str)

# ระวัง 6: __hash__ กับ eq
# @dataclass ตั้ง __hash__ = None ถ้า eq=True (default)
# ต้องใช้ frozen=True หรือ unsafe_hash=True
```

### 5.17.7 สรุป

**ใช้ Dataclass เมื่อ:**
- Data container
- ต้องการ boilerplate น้อย
- Type hints อยู่แล้ว
- Immutable objects (frozen)

**ใช้ NamedTuple เมื่อ:**
- Immutable + tuple behavior
- Performance critical

**ใช้ attrs เมื่อ:**
- ต้องการ validators, converters
- ต้องการ feature เพิ่ม

**ใช้ Pydantic เมื่อ:**
- ต้อง validation + serialization
- API models

**Best practices:**
- `field(default_factory=...)` สำหรับ mutable
- `__post_init__` สำหรับ validation
- `frozen=True` สำหรับ value objects
- `slots=True` สำหรับ performance

> **อ้างอิงเพิ่มเติม:** [dataclasses Documentation](https://docs.python.org/3/library/dataclasses.html), [PEP 557](https://peps.python.org/pep-0557/)

---

## 5.18 Abstract Base Class

### บทนำ

Abstract Base Class (ABC) เป็น class ที่ไม่สามารถ instantiate ได้โดยตรง ใช้กำหนด interface ที่บังคับให้ subclass implement

### นิยาม

ABC คือ class ที่มี abstract methods ที่ subclass ต้อง implement ก่อนจึงจะ instantiate ได้

### 5.18.1 คืออะไร

- ใช้ `abc.ABC` base class
- `@abstractmethod` decorator
- บังคับ implement ใน subclass
- ไม่สามารถ instantiate ABC โดยตรง

### 5.18.2 ทำงานอย่างไร

Python track abstract methods ใน `__abstractmethods__` เมื่อ instantiate จะเช็คว่าทุก abstract methods ถูก override แล้วหรือยัง

### 5.18.3 การใช้งาน

**Basic ABC:**
```python
from abc import ABC, abstractmethod

class Animal(ABC):
    def __init__(self, name: str):
        self.name = name

    @abstractmethod
    def speak(self) -> str:
        """ต้อง implement"""
        pass

    @abstractmethod
    def move(self) -> str:
        """ต้อง implement"""
        pass

    def describe(self) -> str:
        """Concrete method — ใช้ร่วมกัน"""
        return f"{self.name} says {self.speak()}"


class Dog(Animal):
    def speak(self) -> str:
        return "Woof"

    def move(self) -> str:
        return "runs"


class Bird(Animal):
    def speak(self) -> str:
        return "Tweet"

    def move(self) -> str:
        return "flies"


# ❌ ไม่สามารถ instantiate abstract class
# a = Animal("Generic")  # TypeError

# ✅ ใช้ concrete subclasses
dog = Dog("Rex")
print(dog.describe())  # Rex says Woof
print(dog.move())      # runs

bird = Bird("Tweety")
print(bird.describe())  # Tweety says Tweet
```

**Abstract Properties:**
```python
class Shape(ABC):
    @property
    @abstractmethod
    def area(self) -> float:
        pass

    @property
    @abstractmethod
    def perimeter(self) -> float:
        pass

    @property
    def name(self) -> str:
        """Concrete property"""
        return self.__class__.__name__

    def describe(self) -> str:
        return f"{self.name}: area={self.area:.2f}, perimeter={self.perimeter:.2f}"


class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius

    @property
    def area(self) -> float:
        import math
        return math.pi * self.radius ** 2

    @property
    def perimeter(self) -> float:
        import math
        return 2 * math.pi * self.radius


print(Circle(5).describe())
# Circle: area=78.54, perimeter=31.42
```

**Abstract Class Method:**
```python
class DataProcessor(ABC):
    @classmethod
    @abstractmethod
    def from_file(cls, path: str) -> "DataProcessor":
        pass

    @abstractmethod
    def process(self) -> list:
        pass


class CSVProcessor(DataProcessor):
    def __init__(self, data: list[dict]):
        self.data = data

    @classmethod
    def from_file(cls, path: str) -> "CSVProcessor":
        import csv
        with open(path, encoding="utf-8") as f:
            return cls(list(csv.DictReader(f)))

    def process(self) -> list:
        return [row for row in self.data]
```

**Abstract Static Method:**
```python
class Validator(ABC):
    @staticmethod
    @abstractmethod
    def validate(value) -> bool:
        pass

    def check(self, value) -> None:
        if not self.validate(value):
            raise ValueError(f"Invalid: {value}")


class EmailValidator(Validator):
    @staticmethod
    def validate(value: str) -> bool:
        import re
        return bool(re.match(r"^[\w.+-]+@[\w-]+\.[\w.]+$", value))


v = EmailValidator()
v.check("test@example.com")
# v.check("invalid")  # ValueError
```

**Partial Implementation (Abstract + Concrete):**
```python
class BaseRepository(ABC):
    """Repository ที่มีบางส่วน implement"""

    @abstractmethod
    def _connect(self):
        pass

    @abstractmethod
    def _disconnect(self):
        pass

    @abstractmethod
    def _execute(self, query: str, params: tuple = ()):
        pass

    # Concrete methods — ใช้ abstract methods
    def find_by_id(self, id_: int) -> dict | None:
        self._connect()
        try:
            results = self._execute(
                "SELECT * FROM t WHERE id = %s", (id_,)
            )
            return results[0] if results else None
        finally:
            self._disconnect()

    def find_all(self) -> list[dict]:
        self._connect()
        try:
            return self._execute("SELECT * FROM t")
        finally:
            self._disconnect()
```

**Register Virtual Subclass:**
```python
from abc import ABC, abstractmethod
from typing import Iterator

class Sized(ABC):
    @abstractmethod
    def __len__(self) -> int:
        pass


class MyCollection:
    """ไม่ inherit จาก Sized"""
    def __init__(self, items):
        self._items = items

    def __len__(self) -> int:
        return len(self._items)


# Register เป็น virtual subclass
Sized.register(MyCollection)

c = MyCollection([1, 2, 3])
print(isinstance(c, Sized))   # True
print(issubclass(MyCollection, Sized))  # True
```

**ตัวอย่างการใช้งานจริง — Payment Gateway:**
```python
from abc import ABC, abstractmethod
from dataclasses import dataclass
from decimal import Decimal
from typing import Optional

@dataclass
class PaymentResult:
    success: bool
    transaction_id: Optional[str] = None
    message: str = ""


class PaymentGateway(ABC):
    """Abstract payment gateway"""

    @property
    @abstractmethod
    def name(self) -> str:
        pass

    @abstractmethod
    def charge(
        self,
        amount: Decimal,
        currency: str,
        customer_id: str,
    ) -> PaymentResult:
        pass

    @abstractmethod
    def refund(
        self,
        transaction_id: str,
        amount: Optional[Decimal] = None,
    ) -> PaymentResult:
        pass

    @abstractmethod
    def supports_currency(self, currency: str) -> bool:
        pass

    def process_with_fee(
        self,
        amount: Decimal,
        currency: str,
        customer_id: str,
        fee_percent: float = 0.03,
    ) -> PaymentResult:
        """Template method ที่ใช้ abstract methods"""
        if not self.supports_currency(currency):
            return PaymentResult(False, message="Currency not supported")

        total = amount * (1 + Decimal(str(fee_percent)))
        return self.charge(total, currency, customer_id)


class StripeGateway(PaymentGateway):
    @property
    def name(self) -> str:
        return "Stripe"

    def charge(self, amount, currency, customer_id):
        # Stripe API...
        return PaymentResult(True, "stripe_123")

    def refund(self, transaction_id, amount=None):
        return PaymentResult(True, transaction_id)

    def supports_currency(self, currency: str) -> bool:
        return currency in {"USD", "EUR", "GBP"}


class PromptPayGateway(PaymentGateway):
    @property
    def name(self) -> str:
        return "PromptPay"

    def charge(self, amount, currency, customer_id):
        if currency != "THB":
            return PaymentResult(False, message="Only THB supported")
        return PaymentResult(True, "pp_456")

    def refund(self, transaction_id, amount=None):
        return PaymentResult(True, transaction_id)

    def supports_currency(self, currency: str) -> bool:
        return currency == "THB"


# การใช้งาน — polymorphic
gateways: list[PaymentGateway] = [
    StripeGateway(),
    PromptPayGateway(),
]

for gateway in gateways:
    result = gateway.process_with_fee(
        Decimal("100"),
        "USD",
        "cust_001",
    )
    print(f"{gateway.name}: {result.success}")
```

**ตัวอย่าง — Plugin Architecture:**
```python
from abc import ABC, abstractmethod
from typing import Any

class Plugin(ABC):
    """Base plugin interface"""

    @property
    @abstractmethod
    def name(self) -> str:
        pass

    @property
    @abstractmethod
    def version(self) -> str:
        pass

    @abstractmethod
    def initialize(self, config: dict[str, Any]) -> None:
        pass

    @abstractmethod
    def execute(self, input_data: dict[str, Any]) -> dict[str, Any]:
        pass

    @abstractmethod
    def cleanup(self) -> None:
        pass

    def __repr__(self) -> str:
        return f"{self.name} v{self.version}"


class PluginManager:
    def __init__(self):
        self._plugins: list[Plugin] = []

    def register(self, plugin: Plugin) -> None:
        self._plugins.append(plugin)
        print(f"Registered: {plugin}")

    def initialize_all(self, config: dict) -> None:
        for plugin in self._plugins:
            plugin.initialize(config)

    def execute_all(self, data: dict) -> list[dict]:
        results = []
        for plugin in self._plugins:
            result = plugin.execute(data)
            results.append({"plugin": plugin.name, "result": result})
        return results

    def cleanup_all(self) -> None:
        for plugin in self._plugins:
            plugin.cleanup()


class LoggerPlugin(Plugin):
    @property
    def name(self) -> str:
        return "logger"

    @property
    def version(self) -> str:
        return "1.0.0"

    def initialize(self, config):
        self.level = config.get("level", "INFO")

    def execute(self, input_data):
        print(f"[{self.level}] {input_data}")
        return input_data

    def cleanup(self):
        print("Logger cleaned up")


class ValidatorPlugin(Plugin):
    @property
    def name(self) -> str:
        return "validator"

    @property
    def version(self) -> str:
        return "1.0.0"

    def initialize(self, config):
        self.required = config.get("required_fields", [])

    def execute(self, input_data):
        missing = [f for f in self.required if f not in input_data]
        return {"valid": not missing, "missing": missing}

    def cleanup(self):
        pass


# การใช้งาน
manager = PluginManager()
manager.register(LoggerPlugin())
manager.register(ValidatorPlugin())

manager.initialize_all({"level": "DEBUG", "required_fields": ["id", "name"]})
results = manager.execute_all({"id": 1})
manager.cleanup_all()
```

### 5.18.4 ข้อดี

- **Contract:** บังคับ implement
- **Documentation:** interface ชัดเจน
- **Polymorphism:** ใช้แทนกันได้
- **Design:** ช่วยออกแบบที่ดี

### 5.18.5 ข้อเสีย

- **Rigid:** ต้อง inherit
- **Overhead:** abstract check
- **Cannot instantiate:** อาจจำกัด

### 5.18.6 ข้อควรระวัง

```python
# ระวัง 1: Abstract method ไม่ได้บังคับถ้าไม่ raise
class Bad(ABC):
    @abstractmethod
    def method(self):
        return "default"  # ✅ ยังบังคับ

# ระวัง 2: super().__init__() กับ ABC
class Base(ABC):
    def __init__(self, x):
        self.x = x

    @abstractmethod
    def method(self):
        pass

class Child(Base):
    def __init__(self, x, y):
        super().__init__(x)  # ✅ ต้องเรียก
        self.y = y

    def method(self):
        return self.x + self.y

# ระวัง 3: ABC กับ dataclass
from dataclasses import dataclass

# ❌ ใช้ร่วมยาก
# @dataclass
# class Base(ABC):
#     ...

# ✅ แยกหรือใช้ abstract method ใน dataclass
@dataclass
class Base(ABC):
    x: int

    @abstractmethod
    def process(self):
        pass

# ระวัง 4: อย่า over-abstract
# ถ้ามี implementation เดียว ไม่ต้อง ABC

# ระวัง 5: Protocol vs ABC
# ABC — nominal (ต้อง inherit)
# Protocol — structural (duck typing + type check)

# ระวัง 6: @abstractmethod ไม่บังคับ attributes
class Bad(ABC):
    @property
    @abstractmethod
    def value(self):
        pass
    # ❌ ไม่บังคับให้ subclass มี attribute

# ✅ บังคับ implement property
class Good(ABC):
    @property
    @abstractmethod
    def value(self):
        pass

class Impl(Good):
    @property
    def value(self):
        return 42
```

### 5.18.7 สรุป

**ใช้ ABC เมื่อ:**
- ต้องการ interface ที่บังคับ
- หลาย implementations
- Framework design
- Template Method pattern

**ใช้ Protocol เมื่อ:**
- ต้องการ structural typing
- Duck typing กับ type hints
- ไม่ต้องการบังคับ inherit

**เครื่องมือ:**
- `ABC` — base class
- `@abstractmethod` — บังคับ method
- `@abstractproperty` — บังคับ property (deprecated)
- `register()` — virtual subclass

**Best practices:**
- Document abstract methods
- Concrete methods สำหรับ shared behavior
- ใช้ `super().__init__()`
- พิจารณา Protocol ก่อน ABC

> **อ้างอิงเพิ่มเติม:** [abc Module](https://docs.python.org/3/library/abc.html)

---

## 5.19 Protocol

### บทนำ

Protocol (PEP 544) ให้ structural subtyping — object ที่มี methods/attributes ตรงตาม interface ถือว่า implement interface นั้น ไม่ต้อง inherit

### นิยาม

Protocol คือ class ที่ define interface โดยใช้ structural typing แทน nominal typing

### 5.19.1 คืออะไร

**Structural Typing:**
- Class A "เป็น" Protocol X ถ้ามี methods/attributes ครบ
- ไม่ต้อง `class A(X)`
- Static type checker ตรวจสอบได้

**Nominal Typing (ABC):**
- ต้อง inherit
- ชัดเจนกว่า

### 5.19.2 ทำงานอย่างไร

Protocol ใช้ `typing.Protocol` เป็น base class กำหนด methods พร้อม type hints Type checker (mypy, pyright) ตรวจสอบ structure

### 5.19.3 การใช้งาน

**Basic Protocol:**
```python
from typing import Protocol, runtime_checkable

class Drawable(Protocol):
    def draw(self) -> str:
        ...


class Circle:
    def draw(self) -> str:
        return "Circle"


class Square:
    def draw(self) -> str:
        return "Square"


def render(item: Drawable) -> None:
    print(item.draw())


# ✅ ทำงานได้ — structure ตรง
render(Circle())
render(Square())


# ❌ Type checker error (แต่ runtime OK)
class NotDrawable:
    pass

# render(NotDrawable())  # mypy จะ error
```

**Runtime Check:**
```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class Sized(Protocol):
    def __len__(self) -> int:
        ...


class MyList:
    def __init__(self, items):
        self._items = items

    def __len__(self):
        return len(self._items)


print(isinstance(MyList([1, 2]), Sized))     # True
print(isinstance([1, 2], Sized))              # True (list มี __len__)
print(isinstance(42, Sized))                  # False
```

**Protocol กับ Properties:**
```python
from typing import Protocol

class Named(Protocol):
    @property
    def name(self) -> str:
        ...


class Person:
    def __init__(self, name: str):
        self._name = name

    @property
    def name(self) -> str:
        return self._name


class Company:
    def __init__(self, name: str):
        self.name = name  # attribute ปกติ


def greet(entity: Named) -> str:
    return f"Hello, {entity.name}!"


print(greet(Person("สมชาย")))      # Hello, สมชาย!
print(greet(Company("TechCorp")))  # Hello, TechCorp!
```

**Protocol กับ Methods:**
```python
from typing import Protocol, Iterator

class Readable(Protocol):
    def read(self, size: int = -1) -> bytes:
        ...


class Closeable(Protocol):
    def close(self) -> None:
        ...


# Protocol composition
class ReadableCloseable(Readable, Closeable, Protocol):
    pass


def read_all(source: Readable) -> bytes:
    chunks = []
    while chunk := source.read(8192):
        chunks.append(chunk)
    return b"".join(chunks)


# File object ตรงตาม Protocol
with open(__file__, "rb") as f:
    content = read_all(f)
    print(f"Read {len(content)} bytes")
```

**Generic Protocol:**
```python
from typing import Protocol, TypeVar, Generic

T = TypeVar("T")
U = TypeVar("U")

class Mapper(Protocol[T, U]):
    def __call__(self, item: T) -> U:
        ...


def apply_mapper(items: list[T], mapper: Mapper[T, U]) -> list[U]:
    return [mapper(item) for item in items]


# Function ตรงตาม Protocol
result = apply_mapper([1, 2, 3], lambda x: x * 2)
print(result)  # [2, 4, 6]

result = apply_mapper(["a", "b"], str.upper)
print(result)  # ['A', 'B']
```

**Protocol สำหรับ Dependency Injection:**
```python
from typing import Protocol
from dataclasses import dataclass

class Logger(Protocol):
    def info(self, message: str) -> None:
        ...

    def error(self, message: str, exc: Exception | None = None) -> None:
        ...


class ConsoleLogger:
    def info(self, message: str) -> None:
        print(f"[INFO] {message}")

    def error(self, message: str, exc: Exception | None = None) -> None:
        print(f"[ERROR] {message}")
        if exc:
            print(f"  {exc}")


class UserService:
    def __init__(self, logger: Logger):
        self.logger = logger

    def create_user(self, name: str) -> dict:
        self.logger.info(f"Creating user: {name}")
        try:
            # ... logic
            return {"name": name}
        except Exception as e:
            self.logger.error("Failed to create user", e)
            raise


# Inject dependency
service = UserService(ConsoleLogger())
service.create_user("สมชาย")
```

**ตัวอย่างการใช้งานจริง — Repository Protocol:**
```python
from typing import Protocol, TypeVar, Generic, Optional

T = TypeVar("T")
ID = TypeVar("ID")

class Repository(Protocol[T, ID]):
    """Repository interface (structural)"""

    def find_by_id(self, id_: ID) -> Optional[T]:
        ...

    def find_all(self) -> list[T]:
        ...

    def save(self, entity: T) -> T:
        ...

    def delete(self, id_: ID) -> bool:
        ...


@dataclass
class User:
    id: int
    name: str


class InMemoryUserRepo:
    def __init__(self):
        self._data: dict[int, User] = {}
        self._next_id = 1

    def find_by_id(self, id_: int) -> Optional[User]:
        return self._data.get(id_)

    def find_all(self) -> list[User]:
        return list(self._data.values())

    def save(self, entity: User) -> User:
        if entity.id == 0:
            entity.id = self._next_id
            self._next_id += 1
        self._data[entity.id] = entity
        return entity

    def delete(self, id_: int) -> bool:
        return self._data.pop(id_, None) is not None


# Service ไม่รู้จัก concrete class
class UserService:
    def __init__(self, repo: Repository[User, int]):
        self.repo = repo

    def register(self, name: str) -> User:
        user = User(id=0, name=name)
        return self.repo.save(user)

    def get(self, user_id: int) -> Optional[User]:
        return self.repo.find_by_id(user_id)


# ใช้งาน
service = UserService(InMemoryUserRepo())
user = service.register("สมชาย")
print(user)  # User(id=1, name='สมชาย')
```

**ตัวอย่าง — Payment Gateway Protocol:**
```python
from typing import Protocol
from decimal import Decimal
from dataclasses import dataclass

@dataclass
class PaymentResult:
    success: bool
    transaction_id: str = ""


class PaymentGateway(Protocol):
    @property
    def name(self) -> str:
        ...

    def charge(self, amount: Decimal, currency: str) -> PaymentResult:
        ...

    def supports_currency(self, currency: str) -> bool:
        ...


# ไม่ต้อง inherit — แค่ structure ตรง
class StripeAPI:
    @property
    def name(self) -> str:
        return "stripe"

    def charge(self, amount, currency):
        return PaymentResult(True, "stripe_123")

    def supports_currency(self, currency):
        return currency in {"USD", "EUR"}


class PayPalAPI:
    @property
    def name(self) -> str:
        return "paypal"

    def charge(self, amount, currency):
        return PaymentResult(True, "pp_456")

    def supports_currency(self, currency):
        return currency == "USD"


def process_payment(
    gateways: list[PaymentGateway],
    amount: Decimal,
    currency: str,
) -> PaymentResult:
    for gateway in gateways:
        if gateway.supports_currency(currency):
            return gateway.charge(amount, currency)
    return PaymentResult(False)


# ใช้งานกับทั้ง Stripe และ PayPal (ไม่มี inherit)
gateways = [StripeAPI(), PayPalAPI()]
result = process_payment(gateways, Decimal("100"), "USD")
print(result)
```

**Protocol vs ABC:**
```python
# Protocol — structural, ไม่ต้อง inherit
class Flyer(Protocol):
    def fly(self) -> None:
        ...

# ABC — nominal, ต้อง inherit
from abc import ABC, abstractmethod

class Flyer2(ABC):
    @abstractmethod
    def fly(self) -> None:
        pass

# ✅ Protocol: คลาสใดก็ได้ที่มี fly()
class Bird:
    def fly(self) -> None:
        print("flying")

def use_flyer(f: Flyer):
    f.fly()

use_flyer(Bird())  # OK

# ABC: ต้อง inherit Flyer2
class Plane(Flyer2):
    def fly(self) -> None:
        print("flying")

# class Plane2:  # ❌ ไม่ inherit
#     def fly(self):
#         print("flying")
```

### 5.19.4 ข้อดี

- **Structural:** ไม่ต้อง inherit
- **Flexible:** classes ใดก็ได้ที่ structure ตรง
- **Type-safe:** static checking
- **Decoupled:** ลด coupling

### 5.19.5 ข้อเสีย

- **Static checkers only:** ไม่ enforce runtime
- **ไม่ชัดเจน:** ไม่รู้ว่า implement Protocol ไหน
- **Limited runtime:** isinstance ต้อง `@runtime_checkable`

### 5.19.6 ข้อควรระวัง

```python
# ระวัง 1: runtime_checkable ตรวจ method names เท่านั้น
@runtime_checkable
class Sized(Protocol):
    def __len__(self) -> int: ...

class Wrong:
    def __len__(self):  # ✅ ตรงตาม name
        return "not int"  # ❌ return type ผิด

# isinstance ผ่าน แต่ type checker error

# ระวัง 2: Protocol กับ isinstance ช้า
# isinstance(obj, Protocol) — ตรวจ method names ทุกครั้ง
# ควรใช้ type checker แทน

# ระวัง 3: Protocol ไม่ enforce runtime
class MyProtocol(Protocol):
    def method(self) -> int: ...

class NotImpl:
    pass

# ✅ Runtime OK (ไม่เช็ค)
obj: MyProtocol = NotImpl()
# obj.method()  # ❌ AttributeError ตอน runtime

# ระวัง 4: Property ใน Protocol
class Config(Protocol):
    @property
    def value(self) -> str: ...

# ✅ ทั้ง property และ attribute ตรง
class WithProperty:
    @property
    def value(self) -> str:
        return "x"

class WithAttribute:
    value: str = "x"

# ระวัง 5: Protocol กับ overload
# ต้องใช้ @overload ใน Protocol ด้วย

# ระวัง 6: Protocol ไม่สามารถ inherit concrete class
class MyProtocol(SomeClass, Protocol):  # ⚠️ ระวัง MRO
    pass
```

### 5.19.7 สรุป

**ใช้ Protocol เมื่อ:**
- ต้องการ structural typing
- ลด coupling ระหว่าง modules
- Third-party classes
- Duck typing กับ type hints

**ใช้ ABC เมื่อ:**
- ต้องการบังคับ inherit
- Clear interface hierarchy
- Provide concrete methods
- Framework design

**Best practices:**
- Protocol สำหรับ interfaces
- ABC สำหรับ base classes ที่มี logic
- `@runtime_checkable` เฉพาะเมื่อจำเป็น
- Type checker ดีกว่า runtime check

> **อ้างอิงเพิ่มเติม:** [PEP 544 — Protocols](https://peps.python.org/pep-0544/), [typing.Protocol](https://docs.python.org/3/library/typing.html#typing.Protocol)

---

## 5.20 Composition

### บทนำ

Composition คือการสร้าง class ที่ประกอบด้วย objects อื่น (HAS-A relationship) เป็นทางเลือกที่ยืดหยุ่นกว่า inheritance และเป็นหลักการสำคัญของ OOP design

### นิยาม

Composition คือความสัมพันธ์แบบ HAS-A ที่ object หนึ่งเป็นเจ้าของ object อื่น

### 5.20.1 คืออะไร

**Composition vs Inheritance:**
- **Inheritance:** IS-A
- **Composition:** HAS-A

**Favor composition over inheritance** (Gang of Four)

### 5.20.2 ทำงานอย่างไร

Composition:
- Object เก็บ references ไปยัง objects อื่น
- Delegation: เรียก methods ของ objects ที่ประกอบ
- Lifecycle: โดยทั่วไป composed objects ตายพร้อม owner

### 5.20.3 การใช้งาน

**Basic Composition:**
```python
class Engine:
    def __init__(self, horsepower: int, fuel_type: str):
        self.horsepower = horsepower
        self.fuel_type = fuel_type

    def start(self) -> str:
        return f"Engine started ({self.horsepower} hp)"

    def stop(self) -> str:
        return "Engine stopped"


class Wheel:
    def __init__(self, size: int):
        self.size = size

    def rotate(self) -> str:
        return f"Wheel (size {self.size}) rotating"


class Car:
    """Car HAS-A Engine และ HAS-A 4 Wheels"""

    def __init__(self, engine: Engine, wheels: list[Wheel]):
        self.engine = engine
        self.wheels = wheels

    def start(self) -> str:
        return self.engine.start()

    def drive(self) -> str:
        return (
            self.engine.start() + ", " +
            ", ".join(w.rotate() for w in self.wheels)
        )

    def stop(self) -> str:
        return self.engine.stop()


engine = Engine(200, "gasoline")
wheels = [Wheel(18) for _ in range(4)]
car = Car(engine, wheels)

print(car.start())
print(car.drive())
print(car.stop())
```

**Composition กับ Dependency Injection:**
```python
class Logger:
    def log(self, message: str) -> None:
        print(f"[LOG] {message}")


class Database:
    def __init__(self, host: str):
        self.host = host

    def query(self, sql: str) -> list:
        print(f"Query on {self.host}: {sql}")
        return []


class UserService:
    """Composition — inject dependencies"""

    def __init__(self, db: Database, logger: Logger):
        self.db = db
        self.logger = logger

    def get_user(self, user_id: int) -> dict | None:
        self.logger.log(f"Getting user {user_id}")
        results = self.db.query(f"SELECT * FROM users WHERE id={user_id}")
        return results[0] if results else None

    def create_user(self, name: str) -> dict:
        self.logger.log(f"Creating user {name}")
        self.db.query(f"INSERT INTO users (name) VALUES ('{name}')")
        return {"name": name}


# Inject dependencies — ง่ายต่อ test
service = UserService(
    db=Database("localhost"),
    logger=Logger(),
)
```

**Composition กับ Delegation:**
```python
class FileSystem:
    def read(self, path: str) -> str:
        with open(path, encoding="utf-8") as f:
            return f.read()

    def write(self, path: str, content: str) -> None:
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)


class CachedFileSystem:
    """Delegation + caching"""

    def __init__(self, fs: FileSystem):
        self._fs = fs
        self._cache: dict[str, str] = {}

    def read(self, path: str) -> str:
        if path not in self._cache:
            self._cache[path] = self._fs.read(path)
        return self._cache[path]

    def write(self, path: str, content: str) -> None:
        self._fs.write(path, content)
        self._cache[path] = content  # update cache

    def clear_cache(self) -> None:
        self._cache.clear()
```

**Strategy Pattern ด้วย Composition:**
```python
from abc import ABC, abstractmethod
from typing import Protocol

class SortStrategy(Protocol):
    def sort(self, data: list[int]) -> list[int]:
        ...


class BubbleSort:
    def sort(self, data: list[int]) -> list[int]:
        result = data.copy()
        n = len(result)
        for i in range(n):
            for j in range(n - i - 1):
                if result[j] > result[j + 1]:
                    result[j], result[j + 1] = result[j + 1], result[j]
        return result


class QuickSort:
    def sort(self, data: list[int]) -> list[int]:
        if len(data) <= 1:
            return data
        pivot = data[len(data) // 2]
        left = [x for x in data if x < pivot]
        mid = [x for x in data if x == pivot]
        right = [x for x in data if x > pivot]
        return self.sort(left) + mid + self.sort(right)


class Sorter:
    """Context — ใช้ strategy"""

    def __init__(self, strategy: SortStrategy):
        self._strategy = strategy

    def set_strategy(self, strategy: SortStrategy) -> None:
        self._strategy = strategy

    def sort(self, data: list[int]) -> list[int]:
        return self._strategy.sort(data)


# เปลี่ยน strategy ได้ runtime
sorter = Sorter(QuickSort())
print(sorter.sort([3, 1, 4, 1, 5, 9, 2, 6]))

sorter.set_strategy(BubbleSort())
print(sorter.sort([3, 1, 4, 1, 5, 9, 2, 6]))
```

**ตัวอย่างการใช้งานจริง — E-commerce Order:**
```python
from dataclasses import dataclass, field
from decimal import Decimal
from typing import Protocol
from uuid import UUID, uuid4

@dataclass
class OrderItem:
    product_id: UUID
    name: str
    price: Decimal
    quantity: int

    @property
    def subtotal(self) -> Decimal:
        return self.price * self.quantity


class DiscountStrategy(Protocol):
    def apply(self, subtotal: Decimal) -> Decimal:
        ...


class NoDiscount:
    def apply(self, subtotal: Decimal) -> Decimal:
        return Decimal("0")


class PercentageDiscount:
    def __init__(self, percent: float):
        self.percent = Decimal(str(percent))

    def apply(self, subtotal: Decimal) -> Decimal:
        return subtotal * (self.percent / Decimal("100"))


class FixedDiscount:
    def __init__(self, amount: Decimal):
        self.amount = amount

    def apply(self, subtotal: Decimal) -> Decimal:
        return min(self.amount, subtotal)


class ShippingCalculator(Protocol):
    def calculate(self, subtotal: Decimal) -> Decimal:
        ...


class FlatRateShipping:
    def __init__(self, rate: Decimal):
        self.rate = rate

    def calculate(self, subtotal: Decimal) -> Decimal:
        return self.rate


class FreeShippingOver:
    def __init__(self, threshold: Decimal):
        self.threshold = threshold

    def calculate(self, subtotal: Decimal) -> Decimal:
        if subtotal >= self.threshold:
            return Decimal("0")
        return Decimal("50")


@dataclass
class Order:
    """Order composed of items + strategies"""

    customer_id: UUID
    items: list[OrderItem] = field(default_factory=list)
    discount_strategy: DiscountStrategy = field(default_factory=NoDiscount)
    shipping_calculator: ShippingCalculator = field(
        default_factory=lambda: FlatRateShipping(Decimal("50"))
    )
    id: UUID = field(default_factory=uuid4)

    @property
    def subtotal(self) -> Decimal:
        return sum(item.subtotal for item in self.items)

    @property
    def discount(self) -> Decimal:
        return self.discount_strategy.apply(self.subtotal)

    @property
    def shipping(self) -> Decimal:
        return self.shipping_calculator.calculate(self.subtotal)

    @property
    def total(self) -> Decimal:
        return self.subtotal - self.discount + self.shipping

    def print_invoice(self) -> None:
        print(f"Order {self.id}")
        for item in self.items:
            print(f"  {item.name} x{item.quantity}: ฿{item.subtotal:,.2f}")
        print(f"  Subtotal: ฿{self.subtotal:,.2f}")
        print(f"  Discount: -฿{self.discount:,.2f}")
        print(f"  Shipping: ฿{self.shipping:,.2f}")
        print(f"  Total:    ฿{self.total:,.2f}")


# การใช้งาน — compose strategies
order = Order(
    customer_id=uuid4(),
    items=[
        OrderItem(uuid4(), "Laptop", Decimal("35000"), 1),
        OrderItem(uuid4(), "Mouse", Decimal("850"), 2),
    ],
    discount_strategy=PercentageDiscount(10),
    shipping_calculator=FreeShippingOver(Decimal("1000")),
)

order.print_invoice()
```

**ตัวอย่าง — Notification System:**
```python
from typing import Protocol

class Notifier(Protocol):
    def send(self, recipient: str, message: str) -> bool:
        ...


class EmailNotifier:
    def send(self, recipient: str, message: str) -> bool:
        print(f"Email to {recipient}: {message}")
        return True


class SMSNotifier:
    def send(self, recipient: str, message: str) -> bool:
        print(f"SMS to {recipient}: {message}")
        return True


class SlackNotifier:
    def __init__(self, channel: str):
        self.channel = channel

    def send(self, recipient: str, message: str) -> bool:
        print(f"Slack #{self.channel} to {recipient}: {message}")
        return True


class NotificationService:
    """Composed of multiple notifiers"""

    def __init__(self, notifiers: list[Notifier]):
        self.notifiers = notifiers

    def notify(self, recipient: str, message: str) -> dict[str, bool]:
        results = {}
        for notifier in self.notifiers:
            name = notifier.__class__.__name__
            try:
                results[name] = notifier.send(recipient, message)
            except Exception as e:
                print(f"Failed: {e}")
                results[name] = False
        return results


# Compose notifiers
service = NotificationService([
    EmailNotifier(),
    SMSNotifier(),
    SlackNotifier("alerts"),
])

service.notify("somchai@email.com", "Your order shipped!")
```

### 5.20.4 ข้อดี

- **Flexible:** เปลี่ยน behavior ได้ runtime
- **Loose coupling:** ลดการผูกติดกัน
- **Testable:** inject mocks ได้ง่าย
- **Single Responsibility:** แต่ละ class ทำหน้าที่เดียว
- **Reusable:** components ใช้ซ้ำได้

### 5.20.5 ข้อเสีย

- **Indirection:** ต้อง delegate methods
- **More objects:** สร้าง objects เยอะขึ้น
- **Lifecycle:** ต้องจัดการ ownership

### 5.20.6 ข้อควรระวัง

```python
# ระวัง 1: Deep composition chains
# car.engine.fuel_system.pump.pressure_sensor.value
# อาจ violate Law of Demeter

# ✅ ให้ method ที่ car level
class Car:
    def get_engine_pressure(self) -> float:
        return self.engine.get_pressure()

# ระวัง 2: Ownership
# - Composition: owner เป็นเจ้าของ (strong)
# - Aggregation: shared (weak)

# Composition: parts ตายพร้อม owner
class House:
    def __init__(self):
        self.rooms = [Room() for _ in range(5)]

# Aggregation: parts อยู่ได้เอง
class Team:
    def __init__(self, players: list[Player]):
        self.players = players  # รับมา ไม่ได้สร้าง

# ระวัง 3: Circular composition
# A มี B, B มี A → memory leak (ถ้ามี __del__)

# ระวัง 4: Delegation ที่ไม่จำเป็น
# ❌ wrapper ที่ไม่ทำอะไร
class MyList:
    def __init__(self):
        self._list = []
    def append(self, x):
        return self._list.append(x)
    # ... ทุก method

# ✅ ถ้าไม่จำเป็น ใช้ list ตรง ๆ

# ระวัง 5: shallow copy กับ composition
import copy
class Container:
    def __init__(self):
        self.items = [1, 2, 3]

c1 = Container()
c2 = copy.copy(c1)  # shallow
c2.items.append(4)
print(c1.items)  # [1, 2, 3, 4] ❌ shared!
```

### 5.20.7 สรุป

**ใช้ Composition เมื่อ:**
- HAS-A relationship
- ต้องการ flexibility
- เปลี่ยน behavior runtime
- ลด coupling
- หลาย strategies

**ใช้ Inheritance เมื่อ:**
- IS-A relationship ชัดเจน
- ต้องการ polymorphism
- Shared behavior

**Best practices:**
- Favor composition over inheritance
- ใช้ Dependency Injection
- ใช้ Protocol สำหรับ interfaces
- ระวัง Law of Demeter
- Document ownership

> **อ้างอิงเพิ่มเติม:** [Design Patterns — Composition](https://refactoring.guru/design-patterns/composite)

---

## 5.21 Aggregation

### บทนำ

Aggregation เป็นความสัมพันธ์แบบ "HAS-A" ที่ weak กว่า composition — object ที่เป็นส่วนหนึ่งสามารถอยู่ได้เองโดยไม่ขึ้นกับ owner

### นิยาม

Aggregation คือความสัมพันธ์ที่ object หนึ่งมี objects อื่น แต่ objects เหล่านั้นอยู่ได้เอง

### 5.21.1 คืออะไร

**Composition vs Aggregation:**

| Aspect | Composition | Aggregation |
|--------|-------------|-------------|
| Relationship | Strong | Weak |
| Lifecycle | Parts die with owner | Parts survive |
| Ownership | Exclusive | Shared |
| UML | ◆── | ◇── |

### 5.21.2 ทำงานอย่างไร

ใน Python ไม่มีความแตกต่างทาง technical — เป็น conceptual ต่างกันที่ design intent

### 5.21.3 การใช้งาน

**Basic Aggregation:**
```python
class Professor:
    def __init__(self, name: str, specialty: str):
        self.name = name
        self.specialty = specialty

    def teach(self) -> str:
        return f"{self.name} teaches {self.specialty}"


class Department:
    """Department aggregates professors — ไม่ได้เป็นเจ้าของ"""

    def __init__(self, name: str):
        self.name = name
        self.professors: list[Professor] = []

    def add_professor(self, professor: Professor) -> None:
        """รับ professor ที่มีอยู่แล้ว"""
        self.professors.append(professor)

    def remove_professor(self, professor: Professor) -> None:
        self.professors.remove(professor)

    def list_professors(self) -> list[str]:
        return [p.name for p in self.professors]


# Professor อยู่ได้เอง
prof1 = Professor("ดร.สมชาย", "Computer Science")
prof2 = Professor("ดร.สมหญิง", "Mathematics")

# Department ใช้ professors
cs_dept = Department("Computer Science")
cs_dept.add_professor(prof1)
cs_dept.add_professor(prof2)

# ลบ department — professors ยังอยู่
del cs_dept
print(prof1.teach())  # ยังใช้ได้
```

**Aggregation vs Composition:**
```python
# ❌ Composition — House owns Rooms
class Room:
    def __init__(self, purpose: str):
        self.purpose = purpose


class House:
    def __init__(self):
        # House สร้าง rooms เอง
        self.rooms = [
            Room("bedroom"),
            Room("kitchen"),
            Room("bathroom"),
        ]

# ลบ house → rooms ตายด้วย


# ✅ Aggregation — Team uses Players
class Player:
    def __init__(self, name: str):
        self.name = name


class Team:
    def __init__(self, name: str, players: list[Player]):
        # รับ players ที่มีอยู่แล้ว
        self.name = name
        self.players = players  # reference

# ลบ team → players ยังอยู่
```

**Shared Aggregation:**
```python
class Course:
    def __init__(self, code: str, title: str):
        self.code = code
        self.title = title
        self.students: list["Student"] = []

    def enroll(self, student: "Student") -> None:
        if student not in self.students:
            self.students.append(student)
            student.courses.append(self)

    def __repr__(self):
        return f"Course({self.code})"


class Student:
    def __init__(self, student_id: str, name: str):
        self.student_id = student_id
        self.name = name
        self.courses: list[Course] = []

    def enroll(self, course: Course) -> None:
        course.enroll(self)

    def __repr__(self):
        return f"Student({self.student_id}: {self.name})"


# Students และ Courses aggregate กันและกัน
alice = Student("S001", "Alice")
bob = Student("S002", "Bob")

python = Course("CS101", "Python Programming")
math = Course("MA101", "Calculus")

alice.enroll(python)
alice.enroll(math)
bob.enroll(python)

print(python.students)  # [Alice, Bob]
print(alice.courses)    # [CS101, MA101]

# ลบ course — students ยังอยู่
del python
print(alice.courses)  # [CS101, MA101] — ยังอยู่ (แต่ CS101 ตาย)
```

**ตัวอย่างการใช้งานจริง — Library System:**
```python
from dataclasses import dataclass, field
from datetime import datetime, timedelta
from typing import Optional
from uuid import UUID, uuid4

@dataclass
class Book:
    """Book อยู่ได้เอง ไม่ขึ้นกับ library"""
    isbn: str
    title: str
    author: str
    id: UUID = field(default_factory=uuid4)

    def __hash__(self):
        return hash(self.id)


@dataclass
class Member:
    """Member อยู่ได้เอง"""
    member_id: str
    name: str
    email: str


@dataclass
class Loan:
    """Loan เป็น record — composition กับ book และ member"""
    book: Book
    member: Member
    loan_date: datetime = field(default_factory=datetime.now)
    due_date: datetime = field(
        default_factory=lambda: datetime.now() + timedelta(days=14)
    )
    return_date: Optional[datetime] = None

    def is_overdue(self) -> bool:
        if self.return_date:
            return self.return_date > self.due_date
        return datetime.now() > self.due_date

    def return_book(self) -> None:
        self.return_date = datetime.now()


class Library:
    """Library aggregates books และ members"""

    def __init__(self, name: str):
        self.name = name
        self.books: dict[UUID, Book] = {}
        self.members: dict[str, Member] = {}
        self.loans: list[Loan] = []

    def add_book(self, book: Book) -> None:
        """Aggregation — book มาจากภายนอก"""
        self.books[book.id] = book

    def register_member(self, member: Member) -> None:
        self.members[member.member_id] = member

    def lend(self, book: Book, member: Member) -> Loan:
        if book.id not in self.books:
            raise ValueError("Book not in library")
        if member.member_id not in self.members:
            raise ValueError("Member not registered")

        loan = Loan(book=book, member=member)
        self.loans.append(loan)
        return loan

    def find_overdue_loans(self) -> list[Loan]:
        return [loan for loan in self.loans if loan.is_overdue()]


# การใช้งาน
library = Library("Central Library")

# Books ที่มีอยู่แล้ว (aggregate)
book1 = Book("978-0-13-468599-1", "Clean Code", "Robert Martin")
book2 = Book("978-0-13-235088-4", "The Pragmatic Programmer", "Hunt & Thomas")

library.add_book(book1)
library.add_book(book2)

# Members
alice = Member("M001", "Alice", "alice@email.com")
bob = Member("M002", "Bob", "bob@email.com")
library.register_member(alice)
library.register_member(bob)

# Loans
loan1 = library.lend(book1, alice)
loan2 = library.lend(book2, bob)

print(f"Overdue: {len(library.find_overdue_loans())}")

# ลบ library — books/members ยังอยู่
del library
print(book1.title)  # ยังใช้ได้
print(alice.name)   # ยังใช้ได้
```

**ตัวอย่าง — Project Management:**
```python
from dataclasses import dataclass, field
from typing import Optional
from uuid import UUID, uuid4
from datetime import datetime

@dataclass
class User:
    """User อยู่ได้เอง"""
    username: str
    email: str
    id: UUID = field(default_factory=uuid4)


@dataclass
class Task:
    """Task อยู่ได้เอง"""
    title: str
    status: str = "todo"
    assignee: Optional[User] = None  # Aggregation
    id: UUID = field(default_factory=uuid4)

    def assign_to(self, user: User) -> None:
        self.assignee = user


@dataclass
class Project:
    """Project aggregates tasks และ members"""
    name: str
    members: list[User] = field(default_factory=list)
    tasks: list[Task] = field(default_factory=list)
    created_at: datetime = field(default_factory=datetime.now)
    id: UUID = field(default_factory=uuid4)

    def add_member(self, user: User) -> None:
        if user not in self.members:
            self.members.append(user)

    def remove_member(self, user: User) -> None:
        self.members.remove(user)
        # Unassign tasks
        for task in self.tasks:
            if task.assignee is user:
                task.assignee = None

    def add_task(self, task: Task) -> None:
        self.tasks.append(task)

    def assign_task(self, task: Task, user: User) -> None:
        if user not in self.members:
            raise ValueError("User not a member")
        task.assign_to(user)

    def progress(self) -> float:
        if not self.tasks:
            return 100.0
        done = sum(1 for t in self.tasks if t.status == "done")
        return (done / len(self.tasks)) * 100


# การใช้งาน
alice = User("alice", "alice@email.com")
bob = User("bob", "bob@email.com")

project = Project("Website Redesign")
project.add_member(alice)
project.add_member(bob)

task1 = Task("Design mockup")
task2 = Task("Implement frontend")
task3 = Task("Write tests")

project.add_task(task1)
project.add_task(task2)
project.add_task(task3)

project.assign_task(task1, alice)
project.assign_task(task2, bob)

task1.status = "done"
print(f"Progress: {project.progress():.1f}%")  # 33.3%

# ลบ user — project ยังอยู่
del bob
print(project.members)  # [alice] — bob ถูกลบแล้ว
```

### 5.21.4 ข้อดี

- **Loose coupling:** parts อยู่ได้เอง
- **Shared:** ใช้ร่วมกันได้
- **Flexible:** เพิ่ม/ลบ parts ได้
- **Reusable:** parts ใช้ซ้ำได้
- **Clear ownership:** ไม่ซับซ้อน

### 5.21.5 ข้อเสีย

- **Lifecycle:** ต้องจัดการ references
- **Complexity:** ต้อง track relationships
- **Dangling references:** parts ถูกลบแต่ยังมี reference

### 5.21.6 ข้อควรระวัง

```python
# ระวัง 1: Dangling references
class Container:
    def __init__(self, items: list):
        self.items = items

items = [1, 2, 3]
c = Container(items)

# ลบ items ข้างนอก
del items
# c.items ยัง reference list อยู่

# ระวัง 2: Shared mutation
class Team:
    def __init__(self, members: list):
        self.members = members

team1_members = ["Alice", "Bob"]
team1 = Team(team1_members)
team2 = Team(team1_members)  # shared!

team1.members.append("Charlie")
print(team2.members)  # ['Alice', 'Bob', 'Charlie'] ❌

# ✅ ใช้ copy
team2 = Team(team1_members.copy())

# ระวัง 3: Bidirectional relationships
class A:
    def __init__(self):
        self.b_list = []

class B:
    def __init__(self, a):
        self.a = a
        a.b_list.append(self)
# ต้องจัดการทั้งสองทางให้สอดคล้อง

# ระวัง 4: Memory leaks
# Aggregation มักไม่ leak (weak refs)
# แต่ถ้ามี cycles + __del__ อาจ leak

# ระวัง 5: Type checking กับ None
class Team:
    def __init__(self, leader: Optional[User] = None):
        self.leader = leader

team = Team()
if team.leader:  # ✅ ต้องเช็ค
    print(team.leader.name)
```

### 5.21.7 สรุป

**ใช้ Aggregation เมื่อ:**
- Objects อยู่ได้เอง
- Shared ownership
- Loosely coupled
- Parts reusable

**ใช้ Composition เมื่อ:**
- Parts ตายพร้อม owner
- Exclusive ownership
- Strong coupling

**ความแตกต่างหลัก:**
- **Composition:** "owns" — exclusive
- **Aggregation:** "has" — shared

**Best practices:**
- Document ownership
- ระวัง shared mutation
- ใช้ `Optional` type hints
- จัดการ bidirectional relationships

> **อ้างอิงเพิ่มเติม:** [UML Association](https://en.wikipedia.org/wiki/Class_diagram#Association)

---

## 5.22 Association

### บทนำ

Association เป็นความสัมพันธ์ทั่วไประหว่าง classes ที่ไม่ใช่ inheritance ไม่ได้หมายถึง ownership แต่เป็น "ใช้" หรือ "รู้จัก" กัน

### นิยาม

Association คือความสัมพันธ์ระหว่าง objects ที่ independent ต่อกัน ทั้งคู่มี lifecycle ของตัวเอง

### 5.22.1 คืออะไร

**Types of Association:**
- **Unidirectional:** A → B
- **Bidirectional:** A ↔ B
- **One-to-one:** 1:1
- **One-to-many:** 1:N
- **Many-to-many:** M:N

**Association vs Aggregation vs Composition:**

| | Association | Aggregation | Composition |
|-|-------------|-------------|-------------|
| Ownership | ไม่มี | Weak | Strong |
| Lifecycle | Independent | Independent | Dependent |
| UML | ─── | ◇── | ◆── |

### 5.22.2 ทำงานอย่างไร

Association มัก implement เป็น:
- Reference ใน attribute
- Method parameter
- Return value

### 5.22.3 การใช้งาน

**Unidirectional Association:**
```python
class Author:
    def __init__(self, name: str):
        self.name = name


class Book:
    """Book รู้จัก Author แต่ Author ไม่รู้จัก Book"""

    def __init__(self, title: str, author: Author):
        self.title = title
        self.author = author  # association

    def describe(self) -> str:
        return f"'{self.title}' by {self.author.name}"


author = Author("Robert Martin")
book = Book("Clean Code", author)
print(book.describe())
```

**Bidirectional Association:**
```python
class Course:
    def __init__(self, code: str, title: str):
        self.code = code
        self.title = title
        self.enrolled: list["Student"] = []

    def enroll(self, student: "Student") -> None:
        if student not in self.enrolled:
            self.enrolled.append(student)
            student.courses.append(self)

    def unenroll(self, student: "Student") -> None:
        if student in self.enrolled:
            self.enrolled.remove(student)
            student.courses.remove(self)


class Student:
    def __init__(self, student_id: str):
        self.student_id = student_id
        self.courses: list[Course] = []

    def enroll(self, course: Course) -> None:
        course.enroll(self)

    def unenroll(self, course: Course) -> None:
        course.unenroll(self)


# ใช้งาน — ทั้งสองฝ่ายสอดคล้องกัน
alice = Student("S001")
python = Course("CS101", "Python")

alice.enroll(python)
print(alice.courses)    # [CS101]
print(python.enrolled)  # [S001]

alice.unenroll(python)
print(alice.courses)    # []
print(python.enrolled)  # []
```

**Many-to-Many Association:**
```python
class Tag:
    def __init__(self, name: str):
        self.name = name
        self.articles: list["Article"] = []

    def __repr__(self):
        return f"Tag({self.name})"


class Article:
    def __init__(self, title: str):
        self.title = title
        self.tags: list[Tag] = []

    def add_tag(self, tag: Tag) -> None:
        if tag not in self.tags:
            self.tags.append(tag)
            tag.articles.append(self)

    def remove_tag(self, tag: Tag) -> None:
        if tag in self.tags:
            self.tags.remove(tag)
            tag.articles.remove(self)


# ใช้งาน
python = Tag("python")
tutorial = Tag("tutorial")

article1 = Article("Python Basics")
article2 = Article("Advanced Python")

article1.add_tag(python)
article1.add_tag(tutorial)
article2.add_tag(python)

print(python.articles)   # [Python Basics, Advanced Python]
print(article1.tags)     # [python, tutorial]
```

**Association ผ่าน Method Parameter:**
```python
class MailService:
    """ไม่เก็บ reference — แค่ใช้เป็น parameter"""

    def send(self, user: "User", message: str) -> None:
        print(f"Sending to {user.email}: {message}")


class User:
    def __init__(self, name: str, email: str):
        self.name = name
        self.email = email


# Association เฉพาะชั่วคราว — ไม่ persist
service = MailService()
user = User("สมชาย", "somchai@email.com")
service.send(user, "Welcome!")
```

**Association Class:**
```python
from dataclasses import dataclass
from datetime import datetime

@dataclass
class Enrollment:
    """Association class — เก็บข้อมูลของความสัมพันธ์"""
    student: "Student"
    course: "Course"
    enrolled_at: datetime
    grade: str | None = None

    def set_grade(self, grade: str) -> None:
        self.grade = grade


class Student:
    def __init__(self, student_id: str, name: str):
        self.student_id = student_id
        self.name = name
        self.enrollments: list[Enrollment] = []

    def enroll(self, course: "Course") -> Enrollment:
        enrollment = Enrollment(
            student=self,
            course=course,
            enrolled_at=datetime.now(),
        )
        self.enrollments.append(enrollment)
        course.enrollments.append(enrollment)
        return enrollment


class Course:
    def __init__(self, code: str, title: str):
        self.code = code
        self.title = title
        self.enrollments: list[Enrollment] = []


# ใช้งาน
alice = Student("S001", "Alice")
python = Course("CS101", "Python")

enrollment = alice.enroll(python)
enrollment.set_grade("A")

print(alice.enrollments[0].grade)  # A
print(python.enrollments[0].student.name)  # Alice
```

**ตัวอย่างการใช้งานจริง — Social Network:**
```python
from dataclasses import dataclass, field
from datetime import datetime
from typing import Optional

@dataclass
class User:
    user_id: str
    name: str
    followers: list["User"] = field(default_factory=list)
    following: list["User"] = field(default_factory=list)
    posts: list["Post"] = field(default_factory=list)

    def follow(self, other: "User") -> None:
        """Follow — bidirectional association"""
        if other not in self.following:
            self.following.append(other)
            other.followers.append(self)

    def unfollow(self, other: "User") -> None:
        if other in self.following:
            self.following.remove(other)
            other.followers.remove(self)

    def post(self, content: str) -> "Post":
        post = Post(author=self, content=content)
        self.posts.append(post)
        return post

    def feed(self) -> list["Post"]:
        """รวม posts จาก users ที่ follow"""
        all_posts = []
        for user in self.following:
            all_posts.extend(user.posts)
        return sorted(all_posts, key=lambda p: p.created_at, reverse=True)


@dataclass
class Post:
    author: User
    content: str
    created_at: datetime = field(default_factory=datetime.now)
    likes: list[User] = field(default_factory=list)

    def like(self, user: User) -> None:
        if user not in self.likes:
            self.likes.append(user)

    def unlike(self, user: User) -> None:
        if user in self.likes:
            self.likes.remove(user)


# ใช้งาน
alice = User("U001", "Alice")
bob = User("U002", "Bob")
charlie = User("U003", "Charlie")

alice.follow(bob)
alice.follow(charlie)
bob.follow(alice)

bob.post("Hello world!")
charlie.post("Learning Python")
alice.post("My first post")

print(f"Alice follows: {[u.name for u in alice.following]}")
print(f"Bob's followers: {[u.name for u in bob.followers]}")

feed = alice.feed()
print(f"\nAlice's feed:")
for post in feed:
    print(f"  {post.author.name}: {post.content}")
```

**ตัวอย่าง — Order System:**
```python
from dataclasses import dataclass, field
from datetime import datetime
from decimal import Decimal
from uuid import UUID, uuid4
from typing import Optional

@dataclass
class Customer:
    name: str
    email: str
    id: UUID = field(default_factory=uuid4)


@dataclass
class Product:
    name: str
    price: Decimal
    id: UUID = field(default_factory=uuid4)


@dataclass
class OrderLine:
    """Association class ระหว่าง Order และ Product"""
    product: Product
    quantity: int
    unit_price: Decimal

    @property
    def subtotal(self) -> Decimal:
        return self.unit_price * self.quantity


@dataclass
class Order:
    customer: Customer  # association
    lines: list[OrderLine] = field(default_factory=list)
    created_at: datetime = field(default_factory=datetime.now)
    status: str = "pending"
    id: UUID = field(default_factory=uuid4)

    def add_product(self, product: Product, quantity: int) -> None:
        line = OrderLine(
            product=product,
            quantity=quantity,
            unit_price=product.price,  # snapshot ราคา
        )
        self.lines.append(line)

    @property
    def total(self) -> Decimal:
        return sum(line.subtotal for line in self.lines)


class ProductCatalog:
    """Catalog — ไม่ owns products, แค่ reference"""

    def __init__(self):
        self.products: dict[UUID, Product] = {}

    def add(self, product: Product) -> None:
        self.products[product.id] = product

    def find(self, product_id: UUID) -> Optional[Product]:
        return self.products.get(product_id)


# ใช้งาน
customer = Customer("สมชาย", "somchai@email.com")

catalog = ProductCatalog()
laptop = Product("Laptop", Decimal("35000"))
mouse = Product("Mouse", Decimal("850"))

catalog.add(laptop)
catalog.add(mouse)

# Customer สร้าง order — association กับ customer และ products
order = Order(customer=customer)
order.add_product(laptop, 1)
order.add_product(mouse, 2)

print(f"Order for {order.customer.name}: ฿{order.total:,.2f}")

# ลบ catalog — products ยังอยู่
del catalog
print(laptop.name)  # ยังใช้ได้
```

### 5.22.4 ข้อดี

- **Loose:** ไม่มี ownership
- **Flexible:** เพิ่ม/ลบความสัมพันธ์ได้
- **Reusable:** objects ใช้ร่วมได้
- **Simple:** ไม่ต้องจัดการ lifecycle

### 5.22.5 ข้อเสีย

- **Maintenance:** ต้องจัดการ bidirectional
- **Consistency:** ต้องรักษาความสอดคล้อง
- **Cycles:** อาจเกิด reference cycles

### 5.22.6 ข้อควรระวัง

```python
# ระวัง 1: Bidirectional consistency
class A:
    def link_to(self, b):
        self.b = b
        # ❌ ลืม b.a = self

# ✅ รักษาทั้งสองทาง
class A:
    def link_to(self, b: "B"):
        self.b = b
        b.a = self

# ระวัง 2: Reference cycles
class Node:
    def __init__(self):
        self.parent = None
        self.children = []

# parent ↔ children cycle
# Python GC จัดการได้ แต่ใช้ memory

# ระวัง 3: Association กับ weak references
import weakref

class Observer:
    def __init__(self, subject):
        # ❌ strong reference → subject ไม่ถูกลบ
        # self.subject = subject

        # ✅ weak reference
        self.subject_ref = weakref.ref(subject)

# ระวัง 4: Type hints กับ forward references
from __future__ import annotations

class Student:
    courses: list[Course]  # ✅ ใช้ future annotations

# หรือใช้ string
class Student2:
    courses: list["Course"]  # ✅ string

# ระวัง 5: Circular imports
# ถ้า A import B และ B import A → circular
# ใช้ TYPE_CHECKING หรือ string
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from module_b import B

class A:
    def use(self, b: "B") -> None: ...
```

### 5.22.7 สรุป

**ความสัมพันธ์แบบ UML:**

| Type | Ownership | Lifecycle | UML |
|------|-----------|-----------|-----|
| Dependency | ไม่มี | - | ┈→ |
| Association | ไม่มี | Independent | ─── |
| Aggregation | Weak | Independent | ◇── |
| Composition | Strong | Dependent | ◆── |
| Inheritance | - | - | ─▷ |

**ใช้ Association เมื่อ:**
- Objects แค่ "รู้จัก" กัน
- ไม่มี ownership
- Lifecycles independent
- ความสัมพันธ์ทั่วไป

**Best practices:**
- Document multiplicity (1:1, 1:N, M:N)
- รักษา bidirectional consistency
- ใช้ weak references สำหรับ observers
- จัดการ cycles

> **อ้างอิงเพิ่มเติม:** [UML Relationships](https://www.uml-diagrams.org/class-reference.html)

---

## 5.23 SOLID Principles

### บทนำ

SOLID เป็นหลักการออกแบบ OOP 5 ข้อที่ช่วยให้โค้ด maintainable, extensible และ testable เป็นรากฐานของ design patterns และ clean architecture

### นิยาม

SOLID ย่อมาจาก:
- **S**ingle Responsibility Principle
- **O**pen/Closed Principle
- **L**iskov Substitution Principle
- **I**nterface Segregation Principle
- **D**ependency Inversion Principle

### 5.23.1 คืออะไร

แต่ละหลักการแก้ปัญหา specific:
- **SRP:** class ใหญ่เกินไป
- **OCP:** แก้ไขบ่อยเกินไป
- **LSP:** subclass แทน base ไม่ได้
- **ISP:** interface ใหญ่เกินไป
- **DIP:** tight coupling

### 5.23.2 ทำงานอย่างไร

SOLID ทำงานร่วมกัน:
- SRP → classes เล็ก focused
- OCP + LSP → extensible hierarchies
- ISP + DIP → decoupled modules

### 5.23.3 การใช้งาน

**S — Single Responsibility Principle:**

"A class should have only one reason to change."

```python
# ❌ ผิด — class ทำหลายอย่าง
class User:
    def __init__(self, name, email):
        self.name = name
        self.email = email

    def save_to_db(self):
        # Database logic
        pass

    def send_email(self):
        # Email logic
        pass

    def generate_report(self):
        # Report logic
        pass

    def validate(self):
        # Validation logic
        pass


# ✅ ถูก — แยก responsibilities
from dataclasses import dataclass

@dataclass
class User:
    name: str
    email: str


class UserValidator:
    def validate(self, user: User) -> bool:
        return "@" in user.email


class UserRepository:
    def save(self, user: User) -> None:
        # DB logic
        pass


class EmailService:
    def send_welcome(self, user: User) -> None:
        # Email logic
        pass


class UserReportGenerator:
    def generate(self, user: User) -> str:
        return f"Report for {user.name}"
```

**O — Open/Closed Principle:**

"Software entities should be open for extension but closed for modification."

```python
# ❌ ผิด — ต้องแก้ class ทุกครั้งที่เพิ่ม type
class PaymentProcessor:
    def process(self, payment_type: str, amount: float):
        if payment_type == "credit_card":
            # ...
        elif payment_type == "paypal":
            # ...
        elif payment_type == "crypto":  # ต้องแก้ทุกครั้ง
            # ...


# ✅ ถูก — extend ได้โดยไม่แก้
from abc import ABC, abstractmethod

class PaymentMethod(ABC):
    @abstractmethod
    def process(self, amount: float) -> bool:
        pass


class CreditCardPayment(PaymentMethod):
    def process(self, amount: float) -> bool:
        print(f"Processing ${amount} via credit card")
        return True


class PayPalPayment(PaymentMethod):
    def process(self, amount: float) -> bool:
        print(f"Processing ${amount} via PayPal")
        return True


class CryptoPayment(PaymentMethod):
    """เพิ่มใหม่ — ไม่ต้องแก้ PaymentProcessor"""

    def process(self, amount: float) -> bool:
        print(f"Processing ${amount} via crypto")
        return True


class PaymentProcessor:
    def __init__(self, method: PaymentMethod):
        self.method = method

    def process(self, amount: float) -> bool:
        return self.method.process(amount)
```

**L — Liskov Substitution Principle:**

"Objects of a superclass should be replaceable with objects of its subclasses without breaking the application."

```python
# ❌ ผิด — subclass เปลี่ยน behavior
class Bird:
    def fly(self) -> str:
        return "flying"


class Penguin(Bird):
    def fly(self) -> str:
        raise NotImplementedError("Penguins can't fly")  # ❌


# ✅ ถูก — แยก interface
class Bird(ABC):
    @abstractmethod
    def move(self) -> str:
        pass


class FlyingBird(Bird):
    def move(self) -> str:
        return "flying"


class SwimmingBird(Bird):
    def move(self) -> str:
        return "swimming"


class Eagle(FlyingBird):
    def move(self) -> str:
        return "Eagle flying"


class Penguin(SwimmingBird):
    def move(self) -> str:
        return "Penguin swimming"


# ใช้งาน — ใช้ได้กับทุก Bird
def describe(bird: Bird) -> None:
    print(bird.move())


describe(Eagle())
describe(Penguin())
```

**อีกตัวอย่าง LSP:**

```python
# ❌ ผิด — Rectangle vs Square
class Rectangle:
    def __init__(self, width: float, height: float):
        self._width = width
        self._height = height

    @property
    def width(self):
        return self._width

    @width.setter
    def width(self, value):
        self._width = value

    @property
    def height(self):
        return self._height

    @height.setter
    def height(self, value):
        self._height = value

    def area(self) -> float:
        return self._width * self._height


class Square(Rectangle):
    """Square ไม่ควร inherit Rectangle"""

    def __init__(self, side: float):
        super().__init__(side, side)

    @Rectangle.width.setter
    def width(self, value):
        self._width = value
        self._height = value  # ❌ เปลี่ยน behavior

    @Rectangle.height.setter
    def height(self, value):
        self._width = value
        self._height = value


def resize(rect: Rectangle) -> None:
    rect.width = 5
    rect.height = 4
    # Rectangle: area = 20
    # Square: area = 16 ❌ ผิด!


# ✅ ถูก — แยกเป็น class hierarchy ที่ต่างกัน
class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        pass


class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height

    def area(self) -> float:
        return self.width * self.height


class Square(Shape):
    def __init__(self, side: float):
        self.side = side

    def area(self) -> float:
        return self.side ** 2
```

**I — Interface Segregation Principle:**

"Clients should not be forced to depend on interfaces they do not use."

```python
# ❌ ผิด — interface ใหญ่เกินไป
class Worker(ABC):
    @abstractmethod
    def work(self):
        pass

    @abstractmethod
    def eat(self):
        pass

    @abstractmethod
    def sleep(self):
        pass


class Robot(Worker):
    def work(self):
        print("Working")

    def eat(self):
        raise NotImplementedError  # ❌ Robot ไม่กิน

    def sleep(self):
        raise NotImplementedError  # ❌ Robot ไม่นอน


# ✅ ถูก — แยก interfaces
class Workable(Protocol):
    def work(self) -> None:
        ...


class Feedable(Protocol):
    def eat(self) -> None:
        ...


class Sleepable(Protocol):
    def sleep(self) -> None:
        ...


class Human:
    def work(self) -> None:
        print("Working")

    def eat(self) -> None:
        print("Eating")

    def sleep(self) -> None:
        print("Sleeping")


class Robot:
    def work(self) -> None:
        print("Working")


# Client ระบุ interface ที่ต้องการ
def manage_worker(worker: Workable) -> None:
    worker.work()

manage_worker(Human())
manage_worker(Robot())
```

**D — Dependency Inversion Principle:**

"High-level modules should not depend on low-level modules. Both should depend on abstractions."

```python
# ❌ ผิด — high-level ผูกกับ low-level
class MySQLDatabase:
    def query(self, sql: str):
        print(f"MySQL: {sql}")


class UserService:
    def __init__(self):
        # ❌ ผูกกับ MySQL
        self.db = MySQLDatabase()

    def get_user(self, user_id: int):
        return self.db.query(f"SELECT * FROM users WHERE id={user_id}")


# ✅ ถูก — depend on abstraction
class Database(Protocol):
    def query(self, sql: str) -> list:
        ...


class MySQLDatabase:
    def query(self, sql: str) -> list:
        print(f"MySQL: {sql}")
        return []


class PostgresDatabase:
    def query(self, sql: str) -> list:
        print(f"Postgres: {sql}")
        return []


class InMemoryDatabase:
    def query(self, sql: str) -> list:
        print(f"Memory: {sql}")
        return []


class UserService:
    def __init__(self, db: Database):
        # ✅ depend on abstraction
        self.db = db

    def get_user(self, user_id: int) -> dict | None:
        results = self.db.query(f"SELECT * FROM users WHERE id={user_id}")
        return results[0] if results else None


# ใช้ได้กับทุก database
service = UserService(MySQLDatabase())
service2 = UserService(PostgresDatabase())
service3 = UserService(InMemoryDatabase())  # test
```

**ตัวอย่างการใช้งานจริง — SOLID Together:**

```python
from abc import ABC, abstractmethod
from dataclasses import dataclass
from decimal import Decimal
from typing import Protocol
from uuid import UUID, uuid4

# ==================== Domain ====================

@dataclass
class Order:
    """SRP: แค่ domain model"""
    customer_id: UUID
    items: list["OrderItem"]
    id: UUID = None

    def __post_init__(self):
        if self.id is None:
            self.id = uuid4()

    @property
    def total(self) -> Decimal:
        return sum(item.subtotal for item in self.items)


@dataclass
class OrderItem:
    product_id: UUID
    name: str
    price: Decimal
    quantity: int

    @property
    def subtotal(self) -> Decimal:
        return self.price * self.quantity


# ==================== DIP: Abstractions ====================

class OrderRepository(Protocol):
    """Abstraction — high-level รู้จักแค่นี้"""
    def save(self, order: Order) -> None:
        ...

    def find_by_id(self, id: UUID) -> Order | None:
        ...


class PaymentGateway(Protocol):
    def charge(self, amount: Decimal) -> bool:
        ...


class NotificationService(Protocol):
    def send_confirmation(self, customer_id: UUID, order_id: UUID) -> None:
        ...


class DiscountPolicy(Protocol):
    """OCP + ISP: policy ที่แยกได้"""
    def calculate_discount(self, order: Order) -> Decimal:
        ...


# ==================== Implementations ====================

class InMemoryOrderRepository:
    def __init__(self):
        self._orders: dict[UUID, Order] = {}

    def save(self, order: Order) -> None:
        self._orders[order.id] = order

    def find_by_id(self, id: UUID) -> Order | None:
        return self._orders.get(id)


class StripePaymentGateway:
    def charge(self, amount: Decimal) -> bool:
        print(f"Charging ฿{amount} via Stripe")
        return True


class EmailNotificationService:
    def send_confirmation(self, customer_id: UUID, order_id: UUID) -> None:
        print(f"Email sent for order {order_id}")


class NoDiscountPolicy:
    def calculate_discount(self, order: Order) -> Decimal:
        return Decimal("0")


class VipDiscountPolicy:
    def calculate_discount(self, order: Order) -> Decimal:
        return order.total * Decimal("0.1")


# ==================== Service ====================

class OrderService:
    """SRP: แค่ orchestrate use case"""

    def __init__(
        self,
        repository: OrderRepository,
        payment: PaymentGateway,
        notification: NotificationService,
        discount: DiscountPolicy,
    ):
        self.repository = repository
        self.payment = payment
        self.notification = notification
        self.discount = discount

    def place_order(self, order: Order) -> bool:
        discount = self.discount.calculate_discount(order)
        final_amount = order.total - discount

        if not self.payment.charge(final_amount):
            return False

        self.repository.save(order)
        self.notification.send_confirmation(order.customer_id, order.id)
        return True


# ==================== Usage ====================

service = OrderService(
    repository=InMemoryOrderRepository(),
    payment=StripePaymentGateway(),
    notification=EmailNotificationService(),
    discount=VipDiscountPolicy(),
)

order = Order(
    customer_id=uuid4(),
    items=[
        OrderItem(uuid4(), "Laptop", Decimal("35000"), 1),
        OrderItem(uuid4(), "Mouse", Decimal("850"), 2),
    ],
)

service.place_order(order)
```

### 5.23.4 ข้อดี

- **Maintainable:** ง่ายต่อการ maintain
- **Extensible:** เพิ่ม features ได้
- **Testable:** test ง่าย
- **Reusable:** components ใช้ซ้ำ
- **Understandable:** โค้ดอ่านง่าย

### 5.23.5 ข้อเสีย

- **Learning curve:** ต้องเข้าใจ
- **Over-engineering:** สำหรับโปรเจกต์เล็ก
- **Boilerplate:** เพิ่ม code
- **Complexity:** abstraction มากขึ้น

### 5.23.6 ข้อควรระวัง

```python
# ระวัง 1: Over-engineering
# ❌ ใช้ pattern ทุกที่ แม้ไม่จำเป็น
# ✅ ใช้เมื่อมีเหตุผล

# ระวัง 2: SRP มากเกินไป
# ❌ แยก class จนเกินไป — class ละ 1 method
# ✅ class ควร cohesive

# ระวัง 3: OCP กับ premature abstraction
# ❌ สร้าง interface ก่อนมี 2 implementations
# ✅ เริ่ม concrete แล้ว refactor

# ระวัง 4: LSP ไม่ใช่ override ทุกอย่างได้
# Subclass ต้องรักษา contract:
# - ไม่ raise exception ที่ base ไม่ raise
# - ไม่เปลี่ยน return type
# - ไม่เพิ่ม preconditions
# - ไม่ลด postconditions

# ระวัง 5: DIP — abstract ต้องไม่ leak implementation
class BadDatabase(Protocol):
    def mysql_query(self, sql: str):  # ❌ leak MySQL
        ...

class GoodDatabase(Protocol):
    def query(self, sql: str) -> list:  # ✅ generic
        ...

# ระวัง 6: ใช้ Protocol vs ABC
# Protocol — structural, ยืดหยุ่น
# ABC — nominal, บังคับ
```

### 5.23.7 สรุป

**แต่ละหลักการแก้ปัญหา:**

| Principle | แก้ปัญหา | ใช้ |
|-----------|---------|-----|
| SRP | Class ใหญ่เกินไป | แยก responsibilities |
| OCP | แก้บ่อยเกินไป | Extension points |
| LSP | Subclass ผิด | Contract preservation |
| ISP | Interface ใหญ่ | Segregation |
| DIP | Tight coupling | Abstractions |

**Best practices:**
- เริ่ม simple, refactor เมื่อจำเป็น
- ใช้ SOLID เป็น guideline ไม่ใช่กฎ
- หลีกเลี่ยง over-engineering
- Test หลัง refactor

> **อ้างอิงเพิ่มเติม:** [SOLID Principles](https://en.wikipedia.org/wiki/SOLID), [Clean Architecture — Robert Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## 5.24 Design Patterns เบื้องต้น

### บทนำ

Design Patterns เป็น solutions ที่พิสูจน์แล้วสำหรับปัญหาที่พบบ่อยในการออกแบบซอฟต์แวร์ ช่วยให้สื่อสารระหว่าง developers และ reuse solutions

### นิยาม

Design Pattern คือ reusable solution สำหรับปัญหาการออกแบบที่พบบ่อย

### 5.24.1 คืออะไร

**3 ประเภทหลัก:**
- **Creational:** Singleton, Factory, Builder, Prototype
- **Structural:** Adapter, Decorator, Facade, Proxy
- **Behavioral:** Observer, Strategy, Command, Template Method

### 5.24.2 ทำงานอย่างไร

แต่ละ pattern:
- มีชื่อ
- อธิบาย problem
- ให้ solution template
- มี trade-offs

### 5.24.3 การใช้งาน

**Singleton:**
```python
class Config:
    _instance: "Config | None" = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._data = {}
        return cls._instance

    def set(self, key: str, value) -> None:
        self._data[key] = value

    def get(self, key: str, default=None):
        return self._data.get(key, default)


c1 = Config()
c2 = Config()
print(c1 is c2)  # True

c1.set("debug", True)
print(c2.get("debug"))  # True
```

**Factory Method:**
```python
from abc import ABC, abstractmethod

class Document(ABC):
    @abstractmethod
    def open(self) -> str:
        pass


class PDFDocument(Document):
    def open(self) -> str:
        return "Opening PDF"


class WordDocument(Document):
    def open(self) -> str:
        return "Opening Word"


class DocumentFactory:
    _types = {
        "pdf": PDFDocument,
        "word": WordDocument,
    }

    @classmethod
    def create(cls, doc_type: str) -> Document:
        if doc_type not in cls._types:
            raise ValueError(f"Unknown type: {doc_type}")
        return cls._types[doc_type]()


pdf = DocumentFactory.create("pdf")
print(pdf.open())  # Opening PDF
```

**Builder:**
```python
from dataclasses import dataclass, field

@dataclass
class Pizza:
    size: str = "medium"
    cheese: bool = False
    pepperoni: bool = False
    mushrooms: bool = False
    olives: bool = False
    extra_cheese: bool = False


class PizzaBuilder:
    def __init__(self, size: str = "medium"):
        self.pizza = Pizza(size=size)

    def with_cheese(self) -> "PizzaBuilder":
        self.pizza.cheese = True
        return self

    def with_pepperoni(self) -> "PizzaBuilder":
        self.pizza.pepperoni = True
        return self

    def with_mushrooms(self) -> "PizzaBuilder":
        self.pizza.mushrooms = True
        return self

    def with_extra_cheese(self) -> "PizzaBuilder":
        self.pizza.extra_cheese = True
        return self

    def build(self) -> Pizza:
        return self.pizza


pizza = (
    PizzaBuilder("large")
    .with_cheese()
    .with_pepperoni()
    .with_mushrooms()
    .with_extra_cheese()
    .build()
)
print(pizza)
```

**Observer:**
```python
from abc import ABC, abstractmethod

class Observer(ABC):
    @abstractmethod
    def update(self, message: str) -> None:
        pass


class Subject:
    def __init__(self):
        self._observers: list[Observer] = []

    def attach(self, observer: Observer) -> None:
        self._observers.append(observer)

    def detach(self, observer: Observer) -> None:
        self._observers.remove(observer)

    def notify(self, message: str) -> None:
        for observer in self._observers:
            observer.update(message)


class EmailObserver(Observer):
    def update(self, message: str) -> None:
        print(f"Email: {message}")


class SMSObserver(Observer):
    def update(self, message: str) -> None:
        print(f"SMS: {message}")


# ใช้งาน
news = Subject()
news.attach(EmailObserver())
news.attach(SMSObserver())
news.notify("Breaking news!")
# Email: Breaking news!
# SMS: Breaking news!
```

**Strategy:**
```python
from typing import Protocol

class CompressionStrategy(Protocol):
    def compress(self, data: bytes) -> bytes:
        ...


class ZipCompression:
    def compress(self, data: bytes) -> bytes:
        print("Compressing with ZIP")
        return data


class GzipCompression:
    def compress(self, data: bytes) -> bytes:
        print("Compressing with GZIP")
        return data


class Compressor:
    def __init__(self, strategy: CompressionStrategy):
        self.strategy = strategy

    def compress(self, data: bytes) -> bytes:
        return self.strategy.compress(data)


# เปลี่ยน strategy runtime
compressor = Compressor(ZipCompression())
compressor.compress(b"data")

compressor.strategy = GzipCompression()
compressor.compress(b"data")
```

**Decorator:**
```python
from abc import ABC, abstractmethod

class Coffee(ABC):
    @abstractmethod
    def cost(self) -> float:
        pass

    @abstractmethod
    def description(self) -> str:
        pass


class SimpleCoffee(Coffee):
    def cost(self) -> float:
        return 2.0

    def description(self) -> str:
        return "Coffee"


class CoffeeDecorator(Coffee):
    def __init__(self, coffee: Coffee):
        self._coffee = coffee

    def cost(self) -> float:
        return self._coffee.cost()

    def description(self) -> str:
        return self._coffee.description()


class MilkDecorator(CoffeeDecorator):
    def cost(self) -> float:
        return self._coffee.cost() + 0.5

    def description(self) -> str:
        return self._coffee.description() + " + Milk"


class SugarDecorator(CoffeeDecorator):
    def cost(self) -> float:
        return self._coffee.cost() + 0.25

    def description(self) -> str:
        return self._coffee.description() + " + Sugar"


# Compose decorators
coffee = SimpleCoffee()
coffee = MilkDecorator(coffee)
coffee = SugarDecorator(coffee)

print(f"{coffee.description()}: ${coffee.cost()}")
# Coffee + Milk + Sugar: $2.75
```

**Adapter:**
```python
# Third-party API ที่ไม่ตรงกับที่ต้องการ
class OldPaymentAPI:
    def make_payment(self, amount_cents: int) -> dict:
        return {"status": "ok", "cents": amount_cents}


# Interface ที่ต้องการ
class PaymentGateway(Protocol):
    def charge(self, amount: float) -> bool:
        ...


class PaymentAdapter:
    """Adapter ให้ OldPaymentAPI ใช้กับ interface ใหม่ได้"""

    def __init__(self, old_api: OldPaymentAPI):
        self.old_api = old_api

    def charge(self, amount: float) -> bool:
        cents = int(amount * 100)
        result = self.old_api.make_payment(cents)
        return result["status"] == "ok"


# ใช้งาน
gateway = PaymentAdapter(OldPaymentAPI())
print(gateway.charge(99.99))
```

**Facade:**
```python
class CPU:
    def freeze(self):
        print("CPU freeze")

    def jump(self, address: int):
        print(f"CPU jump to {address}")

    def execute(self):
        print("CPU execute")


class Memory:
    def load(self, address: int, data: bytes):
        print(f"Memory load at {address}")

    def free(self, address: int):
        print(f"Memory free at {address}")


class HardDrive:
    def read(self, sector: int, size: int) -> bytes:
        print(f"HD read sector {sector}")
        return b""


class ComputerFacade:
    """Simplify การใช้ subsystem ที่ซับซ้อน"""

    def __init__(self):
        self.cpu = CPU()
        self.memory = Memory()
        self.hd = HardDrive()

    def start(self) -> None:
        self.cpu.freeze()
        self.memory.load(0, self.hd.read(0, 1024))
        self.cpu.jump(0)
        self.cpu.execute()


# ใช้งานง่าย
computer = ComputerFacade()
computer.start()
```

**Command:**
```python
from abc import ABC, abstractmethod

class Command(ABC):
    @abstractmethod
    def execute(self) -> None:
        pass

    @abstractmethod
    def undo(self) -> None:
        pass


class Light:
    def on(self):
        print("Light on")

    def off(self):
        print("Light off")


class TurnOnCommand(Command):
    def __init__(self, light: Light):
        self.light = light

    def execute(self) -> None:
        self.light.on()

    def undo(self) -> None:
        self.light.off()


class RemoteControl:
    def __init__(self):
        self.history: list[Command] = []

    def press(self, command: Command) -> None:
        command.execute()
        self.history.append(command)

    def undo(self) -> None:
        if self.history:
            command = self.history.pop()
            command.undo()


# ใช้งาน
light = Light()
remote = RemoteControl()

remote.press(TurnOnCommand(light))  # Light on
remote.undo()                        # Light off
```

**Template Method:**
```python
from abc import ABC, abstractmethod

class DataProcessor(ABC):
    """Template method pattern"""

    def process(self, source: str) -> str:
        """Template — ขั้นตอนตายตัว"""
        data = self.read(source)
        parsed = self.parse(data)
        transformed = self.transform(parsed)
        return self.output(transformed)

    @abstractmethod
    def read(self, source: str) -> str:
        pass

    @abstractmethod
    def parse(self, data: str) -> dict:
        pass

    def transform(self, data: dict) -> dict:
        """Default implementation"""
        return data

    def output(self, data: dict) -> str:
        return str(data)


class CSVProcessor(DataProcessor):
    def read(self, source: str) -> str:
        print(f"Reading CSV: {source}")
        return "a,b,c"

    def parse(self, data: str) -> dict:
        parts = data.split(",")
        return {"columns": parts}


class JSONProcessor(DataProcessor):
    def read(self, source: str) -> str:
        print(f"Reading JSON: {source}")
        return '{"key": "value"}'

    def parse(self, data: str) -> dict:
        import json
        return json.loads(data)

    def transform(self, data: dict) -> dict:
        return {k.upper(): v for k, v in data.items()}


# ใช้งาน
processor = CSVProcessor()
print(processor.process("data.csv"))

processor = JSONProcessor()
print(processor.process("data.json"))
```

### 5.24.4 ข้อดี

- **Proven solutions:** แก้ปัญหาที่รู้จัก
- **Communication:** ภาษากลาง
- **Reusability:** ใช้ซ้ำได้
- **Best practices:** เป็น best practices

### 5.24.5 ข้อเสีย

- **Over-engineering:** อาจไม่จำเป็น
- **Complexity:** เพิ่ม abstraction
- **Learning curve:** ต้องเข้าใจ
- **Misuse:** ใช้ผิดที่

### 5.24.6 ข้อควรระวัง

```python
# ระวัง 1: Pattern ไม่ใช่ silver bullet
# ใช้เมื่อมีเหตุผล ไม่ใช่เพราะสวยงาม

# ระวัง 2: Python มี built-in ที่ทำได้
# - Singleton → module-level variable
# - Iterator → generator
# - Decorator → functools.wraps
# - Strategy → function parameter

# ระวัง 3: อย่าใช้ Singleton กับ testing
# ยาก test (global state)

# ระวัง 4: Factory ที่ซับซ้อนเกินไป
# ถ้ามี 2-3 types ใช้ if/else ก็พอ

# ระวัง 5: Decorator pattern กับ Python decorators
# ต่างกัน!
# - GoF Decorator: wrap object
# - Python @decorator: wrap function
```

### 5.24.7 สรุป

**เมื่อใช้ Design Patterns:**
- มีปัญหาที่ pattern แก้
- ทีมเข้าใจ pattern
- ไม่ over-engineer
- Pattern ที่เหมาะกับ Python

**Patterns ที่ใช้บ่อย:**
- **Factory** — สร้าง objects
- **Strategy** — interchangeable algorithms
- **Observer** — event notification
- **Decorator** — เพิ่ม features
- **Template Method** — skeleton algorithm

**Pythonic alternatives:**
- Singleton → module
- Iterator → generator
- Strategy → functions
- Command → closures

> **อ้างอิงเพิ่มเติม:** [Refactoring Guru — Design Patterns](https://refactoring.guru/design-patterns), [Python Patterns](https://python-patterns.guide/)

---

## สรุปภาค 5

ภาค 5 ครอบคลุม OOP อย่างละเอียด:

**พื้นฐาน:**
- Class และ Object
- Attributes และ Methods
- Constructor/Destructor
- Inheritance, Polymorphism
- Encapsulation, Abstraction

**ขั้นสูง:**
- Method Overriding/Overloading
- Multiple Inheritance, MRO
- Magic Methods
- Property
- Class/Static Methods
- Dataclass
- ABC, Protocol

**ความสัมพันธ์:**
- Composition (strong HAS-A)
- Aggregation (weak HAS-A)
- Association (uses)

**หลักการออกแบบ:**
- SOLID Principles
- Design Patterns

**ก้าวต่อไป:** ภาค 6 จะเข้าสู่ Functional Programming

---

# ภาค 6: การเขียนโปรแกรมเชิงฟังก์ชัน

## 6.1 Pure Function

### บทนำ

Pure Function เป็นรากฐานของ Functional Programming — ฟังก์ชันที่ไม่มี side effects และให้ผลลัพธ์เดียวกันเสมอสำหรับ input เดียวกัน

### นิยาม

Pure Function คือฟังก์ชันที่:
1. **Deterministic:** input เดียวกัน → output เดียวกันเสมอ
2. **No side effects:** ไม่แก้ state ภายนอก

### 6.1.1 คืออะไร

**Pure:**
```python
def add(a: int, b: int) -> int:
    return a + b
```

**Impure:**
```python
counter = 0

def increment() -> int:
    global counter
    counter += 1  # side effect
    return counter

import random
def roll_dice() -> int:
    return random.randint(1, 6)  # non-deterministic
```

### 6.1.2 ทำงานอย่างไร

Pure functions:
- อ่านได้แค่ arguments
- เขียนได้แค่ local variables
- Return output
- ไม่แตะ global state, files, network, DB

### 6.1.3 การใช้งาน

**Pure vs Impure:**
```python
# ✅ Pure
def calculate_tax(amount: float, rate: float) -> float:
    return amount * rate

def filter_even(numbers: list[int]) -> list[int]:
    return [n for n in numbers if n % 2 == 0]

def format_name(first: str, last: str) -> str:
    return f"{first} {last}".strip()


# ❌ Impure
def log_and_calculate(amount: float) -> float:
    print(f"Calculating...")  # side effect
    return amount * 1.07

def append_to_list(item, items=[]):  # ❌ mutable default
    items.append(item)
    return items

counter = 0
def increment_and_get():
    global counter
    counter += 1
    return counter

import datetime
def get_current_time():
    return datetime.datetime.now()  # non-deterministic
```

**ประโยชน์ — Testability:**
```python
# Pure — test ง่าย
def is_valid_email(email: str) -> bool:
    import re
    return bool(re.match(r"^[\w.+-]+@[\w-]+\.[\w.]+$", email))


# Test
def test_is_valid_email():
    assert is_valid_email("test@example.com") == True
    assert is_valid_email("invalid") == False
    assert is_valid_email("") == False
    print("All tests passed!")


# Impure — test ยาก
class EmailService:
    def __init__(self):
        self.sent_emails = []

    def send_email(self, to: str, subject: str) -> bool:
        # ❌ side effect — ส่งอีเมลจริง
        # smtp.send(...)
        self.sent_emails.append({"to": to, "subject": subject})
        return True

# ต้อง mock smtp
```

**ประโยชน์ — Caching/Memoization:**
```python
from functools import lru_cache

# Pure function — cache ได้
@lru_cache(maxsize=None)
def fibonacci(n: int) -> int:
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

# เร็วมากเพราะ cache
print(fibonacci(100))  # 354224848179261915075

# Impure — cache ไม่ได้ (ผลลัพธ์เปลี่ยนตามเวลา)
def get_price(product_id: str) -> float:
    # ดึงราคาจาก DB — เปลี่ยนได้
    return 100.0
```

**ประโยชน์ — Concurrency:**
```python
# Pure — safe ใน multithreading
def process_batch(items: list[int]) -> list[int]:
    return [x * 2 for x in items]

from concurrent.futures import ThreadPoolExecutor

with ThreadPoolExecutor() as executor:
    results = executor.map(process_batch, [[1, 2], [3, 4], [5, 6]])
    # ✅ ไม่มี race condition
```

**ตัวอย่างการใช้งานจริง — Business Logic:**
```python
from dataclasses import dataclass
from decimal import Decimal
from typing import Optional

@dataclass(frozen=True)
class OrderItem:
    price: Decimal
    quantity: int
    discount_percent: Decimal = Decimal("0")

    @property
    def subtotal(self) -> Decimal:
        discount = self.price * self.quantity * (self.discount_percent / 100)
        return self.price * self.quantity - discount


@dataclass(frozen=True)
class Order:
    items: tuple[OrderItem, ...]

    @property
    def subtotal(self) -> Decimal:
        return sum(item.subtotal for item in self.items)

    @property
    def total(self) -> Decimal:
        return self.subtotal * Decimal("1.07")  # +7% VAT


# ✅ ทุกอย่าง pure — ไม่มี side effects
def calculate_discount(
    subtotal: Decimal,
    customer_tier: str,
) -> Decimal:
    """Pure function — deterministic"""
    rates = {
        "bronze": Decimal("0"),
        "silver": Decimal("0.05"),
        "gold": Decimal("0.10"),
        "platinum": Decimal("0.15"),
    }
    return subtotal * rates.get(customer_tier, Decimal("0"))


def calculate_shipping(
    subtotal: Decimal,
    weight_kg: float,
    is_express: bool,
) -> Decimal:
    """Pure function"""
    if subtotal >= Decimal("1000"):
        return Decimal("0")

    base = Decimal("50") + Decimal(str(weight_kg)) * Decimal("10")
    if is_express:
        base *= Decimal("2")
    return base


def calculate_final_total(
    order: Order,
    customer_tier: str,
    weight_kg: float,
    is_express: bool,
) -> dict:
    """Compose pure functions"""
    subtotal = order.subtotal
    discount = calculate_discount(subtotal, customer_tier)
    shipping = calculate_shipping(subtotal - discount, weight_kg, is_express)
    total = subtotal - discount + shipping

    return {
        "subtotal": subtotal,
        "discount": discount,
        "shipping": shipping,
        "total": total,
    }


# ใช้งาน — test ง่าย ไม่ต้อง mock
order = Order(items=(
    OrderItem(Decimal("100"), 2),
    OrderItem(Decimal("50"), 1, Decimal("10")),
))

result = calculate_final_total(order, "gold", 2.5, False)
print(result)
```

**ตัวอย่าง — Data Transformation Pipeline:**
```python
from typing import Callable, TypeVar
from functools import reduce

T = TypeVar("T")

def pipe(*functions: Callable) -> Callable:
    """Compose functions left-to-right"""
    def composed(value):
        return reduce(lambda acc, f: f(acc), functions, value)
    return composed


# Pure transformation functions
def parse_int(value: str) -> int:
    return int(value)


def double(value: int) -> int:
    return value * 2


def add_ten(value: int) -> int:
    return value + 10


def to_string(value: int) -> str:
    return f"Result: {value}"


# Compose
process = pipe(parse_int, double, add_ten, to_string)
print(process("5"))  # Result: 20

# ทดสอบแต่ละ function แยกกันได้
assert parse_int("42") == 42
assert double(21) == 42
assert add_ten(32) == 42
```

### 6.1.4 ข้อดี

- **Testable:** test ง่าย ไม่ต้อง mock
- **Predictable:** deterministic
- **Cacheable:** memoization ได้
- **Parallelizable:** safe concurrent
- **Composable:** ต่อกันได้
- **Debuggable:** หาสาเหตุง่าย

### 6.1.5 ข้อเสีย

- **ไม่ practical เสมอ:** I/O ต้อง impure
- **Performance:** immutable อาจช้า
- **Memory:** สร้าง objects ใหม่
- **จำกัด:** บางอย่างต้อง side effects

### 6.1.6 ข้อควรระวัง

```python
# ระวัง 1: Hidden side effects
def process(items: list[int]) -> list[int]:
    items.sort()  # ❌ mutate input!
    return items

# ✅ ใช้ sorted() ที่คืน list ใหม่
def process_pure(items: list[int]) -> list[int]:
    return sorted(items)

# ระวัง 2: Mutable default
def bad(items=[]):  # ❌ shared
    items.append(1)
    return items

def good(items=None):
    items = items or []
    items.append(1)
    return items

# ระวัง 3: Global state
cache = {}

def get_user(user_id: int) -> dict:
    if user_id not in cache:  # อ่าน global
        cache[user_id] = fetch(user_id)  # เขียน global
    return cache[user_id]

# ✅ explicit caching
def get_user_pure(user_id: int, cache: dict) -> dict:
    if user_id not in cache:
        cache[user_id] = fetch(user_id)
    return cache[user_id]

# ระวัง 4: Time/Random เป็น impure
import time
def timestamp() -> float:
    return time.time()  # ❌

# ✅ inject
def timestamp_pure(clock=time.time) -> float:
    return clock()

# ระวัง 5: Exceptions
def divide(a, b):
    return a / b  # ❌ raise ZeroDivisionError

# ✅ return explicit
def divide_safe(a, b) -> tuple[float, str | None]:
    if b == 0:
        return 0, "division by zero"
    return a / b, None
```

### 6.1.7 สรุป

**Pure Function:**
- Deterministic
- No side effects
- Same input → same output

**ประโยชน์:**
- Testable
- Cacheable
- Parallelizable
- Composable

**Best practices:**
- แยก pure และ impure
- Pure functions สำหรับ business logic
- Impure ที่ boundaries (I/O)
- Inject dependencies (time, random)
- ใช้ immutable data

> **อ้างอิงเพิ่มเติม:** [Functional Programming HOWTO](https://docs.python.org/3/howto/functional.html)

---

## 6.2 First-Class Function

### บทนำ

Python treat functions เป็น first-class citizens — สามารถ assign, pass, return ได้เหมือน values อื่น ๆ

### นิยาม

First-Class Function คือฟังก์ชันที่:
- Assign ให้ variable
- Pass เป็น argument
- Return จาก function
- เก็บใน data structures

### 6.2.1 คืออะไร

Functions เป็น objects ใน Python มี attributes, methods และ id

```python
def greet(name: str) -> str:
    return f"Hello, {name}"

print(type(greet))     # <class 'function'>
print(greet.__name__)  # greet
print(id(greet))       # memory address
```

### 6.2.2 ทำงานอย่างไร

Functions เป็น objects ของ type `function` สามารถ treat เหมือน values

### 6.2.3 การใช้งาน

**Assign to Variable:**
```python
def greet(name: str) -> str:
    return f"Hello, {name}"

# Assign
say_hello = greet
print(say_hello("สมชาย"))  # Hello, สมชาย

# เก็บใน list
operations = [greet, str.upper, str.lower]
for op in operations:
    try:
        print(op("Hello"))
    except TypeError:
        pass
```

**Pass as Argument:**
```python
def apply(func, value):
    return func(value)

def double(x: int) -> int:
    return x * 2

def square(x: int) -> int:
    return x ** 2

print(apply(double, 5))   # 10
print(apply(square, 5))   # 25
print(apply(len, "hello")) # 5
```

**Return from Function:**
```python
def create_multiplier(factor: int):
    """Factory — return function"""
    def multiplier(x: int) -> int:
        return x * factor
    return multiplier

double = create_multiplier(2)
triple = create_multiplier(3)

print(double(5))  # 10
print(triple(5))  # 15
```

**Store in Data Structures:**
```python
def add(a, b): return a + b
def sub(a, b): return a - b
def mul(a, b): return a * b
def div(a, b): return a / b

operations = {
    "+": add,
    "-": sub,
    "*": mul,
    "/": div,
}

def calculate(a: float, op: str, b: float) -> float:
    if op not in operations:
        raise ValueError(f"Unknown operator: {op}")
    return operations[op](a, b)

print(calculate(10, "+", 5))  # 15
print(calculate(10, "*", 5))  # 50
```

**Callback Pattern:**
```python
from typing import Callable

def process_data(
    data: list[int],
    on_success: Callable[[int], None],
    on_error: Callable[[int], None],
) -> None:
    for item in data:
        if item < 0:
            on_error(item)
        else:
            on_success(item)


def handle_success(item: int) -> None:
    print(f"✓ {item}")


def handle_error(item: int) -> None:
    print(f"✗ {item}")


process_data([1, -2, 3, -4, 5], handle_success, handle_error)
# ✓ 1
# ✗ -2
# ✓ 3
# ✗ -4
# ✓ 5
```

**Higher-Order Function:**
```python
from typing import Callable, TypeVar

T = TypeVar("T")
R = TypeVar("R")

def compose(*functions: Callable) -> Callable:
    """Compose functions right-to-left"""
    def composed(value):
        result = value
        for f in reversed(functions):
            result = f(result)
        return result
    return composed


def pipe(*functions: Callable) -> Callable:
    """Pipe functions left-to-right"""
    def piped(value):
        result = value
        for f in functions:
            result = f(result)
        return result
    return piped


# ใช้งาน
add_one = lambda x: x + 1
double = lambda x: x * 2

process = pipe(add_one, double, add_one)
print(process(5))  # ((5 + 1) * 2) + 1 = 13
```

**ตัวอย่างการใช้งานจริง — Event System:**
```python
from typing import Callable, Any
from collections import defaultdict

class EventBus:
    def __init__(self):
        self._handlers: dict[str, list[Callable]] = defaultdict(list)

    def on(self, event: str) -> Callable:
        """Decorator สำหรับ register handler"""
        def decorator(handler: Callable) -> Callable:
            self._handlers[event].append(handler)
            return handler
        return decorator

    def emit(self, event: str, *args, **kwargs) -> None:
        for handler in self._handlers[event]:
            try:
                handler(*args, **kwargs)
            except Exception as e:
                print(f"Error in handler: {e}")


# ใช้งาน
bus = EventBus()

@bus.on("user.created")
def send_welcome_email(user: dict) -> None:
    print(f"Sending welcome to {user['email']}")


@bus.on("user.created")
def create_user_profile(user: dict) -> None:
    print(f"Creating profile for {user['name']}")


@bus.on("order.placed")
def notify_warehouse(order: dict) -> None:
    print(f"Notifying warehouse for order {order['id']}")


# Trigger events
bus.emit("user.created", {"name": "สมชาย", "email": "somchai@email.com"})
bus.emit("order.placed", {"id": "ORD-001"})
```

**ตัวอย่าง — Validation Pipeline:**
```python
from typing import Callable, Any
from dataclasses import dataclass, field

@dataclass
class ValidationRule:
    name: str
    check: Callable[[Any], bool]
    message: str


class Validator:
    def __init__(self):
        self.rules: dict[str, list[ValidationRule]] = {}

    def add_rule(self, field_name: str, rule: ValidationRule) -> None:
        self.rules.setdefault(field_name, []).append(rule)

    def validate(self, data: dict) -> dict[str, list[str]]:
        errors: dict[str, list[str]] = {}

        for field_name, rules in self.rules.items():
            value = data.get(field_name)
            field_errors = []

            for rule in rules:
                try:
                    if not rule.check(value):
                        field_errors.append(rule.message)
                except Exception as e:
                    field_errors.append(f"Error: {e}")

            if field_errors:
                errors[field_name] = field_errors

        return errors


# Define rules
validator = Validator()

validator.add_rule("email", ValidationRule(
    name="format",
    check=lambda v: v and "@" in v,
    message="Invalid email format",
))

validator.add_rule("age", ValidationRule(
    name="range",
    check=lambda v: v is not None and 0 <= v <= 150,
    message="Age must be 0-150",
))

validator.add_rule("name", ValidationRule(
    name="length",
    check=lambda v: v and 1 <= len(v) <= 100,
    message="Name must be 1-100 chars",
))


# Validate
errors = validator.validate({
    "email": "invalid",
    "age": 200,
    "name": "",
})

for field, msgs in errors.items():
    print(f"{field}: {msgs}")
```

### 6.2.4 ข้อดี

- **Flexible:** functions เป็น values
- **Composable:** ต่อกันได้
- **Abstract:** pass behavior
- **Callback:** async/event handling
- **Higher-order:** powerful abstractions

### 6.2.5 ข้อเสีย

- **Complexity:** อาจอ่านยาก
- **Debugging:** ยากกว่า direct call
- **Performance:** function call overhead

### 6.2.6 ข้อควรระวัง

```python
# ระวัง 1: Late binding ใน loops
functions = []
for i in range(3):
    functions.append(lambda: i)  # ❌ ทั้งหมด return 2

for f in functions:
    print(f())  # 2, 2, 2

# ✅ ใช้ default argument
functions = []
for i in range(3):
    functions.append(lambda i=i: i)

for f in functions:
    print(f())  # 0, 1, 2

# ระวัง 2: __name__ ของ lambda
func = lambda x: x
print(func.__name__)  # <lambda>

# ระวัง 3: Functions เป็น mutable
def greet():
    pass

greet.custom_attr = "value"  # ✅ ทำได้
print(greet.custom_attr)

# ระวัง 4: Closure captures reference
def make_counter():
    count = 0
    def increment():
        nonlocal count
        count += 1
        return count
    return increment

counter1 = make_counter()
counter2 = make_counter()
print(counter1())  # 1
print(counter1())  # 2
print(counter2())  # 1 (แยกกัน)
```

### 6.2.7 สรุป

**First-Class Functions:**
- Assign to variables
- Pass as arguments
- Return from functions
- Store in data structures

**ใช้เมื่อ:**
- Callbacks
- Strategy pattern
- Event handling
- Composition
- Factory functions

**Best practices:**
- ใช้ named functions สำหรับ logic ที่ซับซ้อน
- ใช้ lambda สำหรับสั้น ๆ
- ระวัง late binding
- Type hints สำหรับ callables

> **อ้างอิงเพิ่มเติม:** [First-Class Functions](https://en.wikipedia.org/wiki/First-class_function)

---

## 6.3 Higher-Order Function

### บทนำ

Higher-Order Function คือ function ที่รับ function เป็น argument หรือ return function เป็นผลลัพธ์ เป็นหัวใจของ Functional Programming

### นิยาม

Higher-Order Function (HOF) คือฟังก์ชันที่:
- รับ function เป็น argument, หรือ
- Return function

### 6.3.1 คืออะไร

Examples:
- `map()`, `filter()`, `reduce()`
- `sorted(key=...)`
- Decorators
- `functools.partial()`

### 6.3.2 ทำงานอย่างไร

HOF abstract behavior และให้ caller กำหนด specifics

### 6.3.3 การใช้งาน

**map():**
```python
# map — apply function กับทุก element
numbers = [1, 2, 3, 4, 5]

# ด้วย map
squared = list(map(lambda x: x ** 2, numbers))
print(squared)  # [1, 4, 9, 16, 25]

# เทียบกับ comprehension (มักอ่านง่ายกว่า)
squared = [x ** 2 for x in numbers]

# map กับ multiple iterables
a = [1, 2, 3]
b = [10, 20, 30]
sums = list(map(lambda x, y: x + y, a, b))
print(sums)  # [11, 22, 33]
```

**filter():**
```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# filter — เก็บเฉพาะที่ผ่าน
evens = list(filter(lambda x: x % 2 == 0, numbers))
print(evens)  # [2, 4, 6, 8, 10]

# Comprehension
evens = [x for x in numbers if x % 2 == 0]

# filter(None, ...) เก็บ truthy
truthy = list(filter(None, [0, 1, "", "hello", None, [], [1]]))
print(truthy)  # [1, 'hello', [1]]
```

**reduce():**
```python
from functools import reduce

numbers = [1, 2, 3, 4, 5]

# reduce — accumulate
total = reduce(lambda acc, x: acc + x, numbers)
print(total)  # 15

# มี initial value
total = reduce(lambda acc, x: acc + x, numbers, 100)
print(total)  # 115

# หาค่าสูงสุด
max_val = reduce(lambda a, b: a if a > b else b, numbers)
print(max_val)  # 5

# Flatten
nested = [[1, 2], [3, 4], [5, 6]]
flat = reduce(lambda acc, x: acc + x, nested, [])
print(flat)  # [1, 2, 3, 4, 5, 6]
```

**sorted() กับ key:**
```python
students = [
    {"name": "สมชาย", "score": 85, "age": 22},
    {"name": "สมหญิง", "score": 92, "age": 20},
    {"name": "วิชัย", "score": 78, "age": 23},
]

# เรียงตาม score
by_score = sorted(students, key=lambda s: s["score"], reverse=True)
for s in by_score:
    print(f"{s['name']}: {s['score']}")

# หลายเกณฑ์
by_multi = sorted(students, key=lambda s: (-s["score"], s["age"]))
```

**functools.partial:**
```python
from functools import partial

def power(base: float, exponent: float) -> float:
    return base ** exponent

# Fix exponent
square = partial(power, exponent=2)
cube = partial(power, exponent=3)

print(square(5))  # 25
print(cube(5))    # 125

# ใช้กับ map
numbers = [1, 2, 3, 4, 5]
squares = list(map(square, numbers))
print(squares)  # [1, 4, 9, 16, 25]

# Real-world: logging
import logging

def log_message(level: str, logger, message: str) -> None:
    getattr(logger, level)(message)

logger = logging.getLogger(__name__)
info = partial(log_message, "info", logger)
error = partial(log_message, "error", logger)

info("Application started")
error("Something went wrong")
```

**Custom Higher-Order Functions:**
```python
from typing import Callable, TypeVar, Iterable

T = TypeVar("T")
R = TypeVar("R")

def my_map(func: Callable[[T], R], iterable: Iterable[T]) -> list[R]:
    """Implementation ของ map"""
    return [func(x) for x in iterable]


def my_filter(func: Callable[[T], bool], iterable: Iterable[T]) -> list[T]:
    """Implementation ของ filter"""
    return [x for x in iterable if func(x)]


def my_reduce(func: Callable[[R, T], R], iterable: Iterable[T], initial: R) -> R:
    """Implementation ของ reduce"""
    acc = initial
    for x in iterable:
        acc = func(acc, x)
    return acc


# Test
print(my_map(lambda x: x * 2, [1, 2, 3]))       # [2, 4, 6]
print(my_filter(lambda x: x > 2, [1, 2, 3, 4])) # [3, 4]
print(my_reduce(lambda a, b: a + b, [1, 2, 3], 0))  # 6
```

**Decorator — HOF ที่พบบ่อย:**
```python
from functools import wraps
import time
from typing import Callable, TypeVar

F = TypeVar("F", bound=Callable)

def timing(func: F) -> F:
    """Decorator — วัดเวลา"""
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        try:
            return func(*args, **kwargs)
        finally:
            elapsed = time.perf_counter() - start
            print(f"{func.__name__}: {elapsed:.4f}s")
    return wrapper  # type: ignore


def retry(max_attempts: int = 3, delay: float = 1.0):
    """Decorator factory — retry on exception"""
    def decorator(func: F) -> F:
        @wraps(func)
        def wrapper(*args, **kwargs):
            last_exc = None
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    last_exc = e
                    if attempt < max_attempts - 1:
                        time.sleep(delay)
            raise last_exc  # type: ignore
        return wrapper  # type: ignore
    return decorator


@timing
@retry(max_attempts=3, delay=0.1)
def fetch_data(url: str) -> str:
    import random
    if random.random() < 0.7:
        raise ConnectionError("Failed")
    return f"data from {url}"


try:
    print(fetch_data("https://api.example.com"))
except Exception as e:
    print(f"Failed: {e}")
```

**ตัวอย่างการใช้งานจริง — Data Pipeline:**
```python
from typing import Callable, TypeVar, Iterable
from functools import reduce, partial

T = TypeVar("T")

def pipeline(*steps: Callable) -> Callable:
    """สร้าง pipeline จาก functions"""
    def run(data):
        return reduce(lambda acc, step: step(acc), steps, data)
    return run


def where(predicate: Callable[[T], bool]) -> Callable[[Iterable[T]], list[T]]:
    """Filter step"""
    def step(iterable):
        return [x for x in iterable if predicate(x)]
    return step


def select(transform: Callable[[T], T]) -> Callable[[Iterable[T]], list[T]]:
    """Map step"""
    def step(iterable):
        return [transform(x) for x in iterable]
    return step


def take(n: int) -> Callable[[Iterable[T]], list[T]]:
    """Limit step"""
    def step(iterable):
        return list(iterable)[:n]
    return step


# ใช้งาน
data = [
    {"name": "สมชาย", "age": 30, "salary": 50000},
    {"name": "สมหญิง", "age": 25, "salary": 45000},
    {"name": "วิชัย", "age": 35, "salary": 70000},
    {"name": "มานะ", "age": 40, "salary": 80000},
    {"name": "ปิด", "age": 22, "salary": 30000},
]

process = pipeline(
    where(lambda x: x["age"] >= 25),
    select(lambda x: {**x, "salary_after_tax": x["salary"] * 0.93}),
    take(3),
)

for item in process(data):
    print(item)
```

**ตัวอย่าง — Retry และ Circuit Breaker:**
```python
from functools import wraps
from typing import Callable, TypeVar
import time
from datetime import datetime, timedelta
from dataclasses import dataclass, field

F = TypeVar("F", bound=Callable)

@dataclass
class CircuitBreaker:
    failure_threshold: int = 5
    recovery_timeout: float = 60.0
    _failures: int = 0
    _last_failure: datetime | None = None
    _state: str = "closed"  # closed, open, half-open

    def call(self, func: Callable, *args, **kwargs):
        if self._state == "open":
            if self._last_failure:
                elapsed = (datetime.now() - self._last_failure).total_seconds()
                if elapsed < self.recovery_timeout:
                    raise RuntimeError("Circuit breaker is OPEN")
            self._state = "half-open"

        try:
            result = func(*args, **kwargs)
            if self._state == "half-open":
                self._state = "closed"
                self._failures = 0
            return result
        except Exception as e:
            self._failures += 1
            self._last_failure = datetime.now()

            if self._failures >= self.failure_threshold:
                self._state = "open"

            raise e

    def __call__(self, func: F) -> F:
        @wraps(func)
        def wrapper(*args, **kwargs):
            return self.call(func, *args, **kwargs)
        return wrapper  # type: ignore


# ใช้งาน
breaker = CircuitBreaker(failure_threshold=3, recovery_timeout=5.0)

@breaker
def unreliable_service() -> str:
    import random
    if random.random() < 0.5:
        raise ConnectionError("Service unavailable")
    return "success"


for i in range(10):
    try:
        result = unreliable_service()
        print(f"Attempt {i}: {result}")
    except Exception as e:
        print(f"Attempt {i}: {type(e).__name__}: {e}")
    time.sleep(0.5)
```

### 6.3.4 ข้อดี

- **Abstraction:** ซ่อนรายละเอียด
- **Reusability:** ใช้ซ้ำได้
- **Composition:** ต่อกันได้
- **Declarative:** บอก "อะไร" ไม่ใช่ "อย่างไร"
- **DRY:** ลด duplication

### 6.3.5 ข้อเสีย

- **Performance:** function call overhead
- **Readability:** อาจอ่านยาก
- **Debugging:** stack trace ซับซ้อน
- **Over-engineering:** สำหรับงานง่าย

### 6.3.6 ข้อควรระวัง

```python
# ระวัง 1: reduce สำหรับ simple cases
# ❌
total = reduce(lambda a, b: a + b, [1, 2, 3, 4])
# ✅
total = sum([1, 2, 3, 4])

# ระวัง 2: map/filter vs comprehension
# comprehension อ่านง่ายกว่าและเร็วกว่า
# ❌
result = list(map(lambda x: x * 2, filter(lambda x: x > 0, numbers)))
# ✅
result = [x * 2 for x in numbers if x > 0]

# ระวัง 3: อย่าใช้ lambda ที่ซับซ้อน
# ❌
func = lambda x: x if x > 0 else (x * 2 if x < 0 else 0)
# ✅ ใช้ def
def process(x):
    if x > 0:
        return x
    elif x < 0:
        return x * 2
    return 0

# ระวัง 4: HOF ช้าใน performance-critical
import timeit
data = list(range(10000))

t1 = timeit.timeit(lambda: [x * 2 for x in data], number=1000)
t2 = timeit.timeit(lambda: list(map(lambda x: x * 2, data)), number=1000)
print(f"Comprehension: {t1:.3f}s, Map: {t2:.3f}s")

# ระวัง 5: partial กับ method
class MyClass:
    def method(self, x, y):
        return x + y

obj = MyClass()
# ❌ partial(obj.method, 5) — แต่ obj.method เป็น bound method
# ✅
from functools import partial
add_five = partial(obj.method, 5)
print(add_five(10))  # 15
```

### 6.3.7 สรุป

**Higher-Order Functions:**
- รับ/คืน functions
- Abstract behavior
- Composition

**Built-in HOFs:**
- `map()` — transform
- `filter()` — select
- `reduce()` — accumulate
- `sorted(key=...)` — sort

**ใช้เมื่อ:**
- Abstract behavior
- Composition
- Callbacks
- Decorators
- Functional pipelines

**Best practices:**
- Comprehension > map/filter
- Simple functions > complex lambdas
- Type hints
- Document behavior

> **อ้างอิงเพิ่มเติม:** [functools Documentation](https://docs.python.org/3/library/functools.html)

---

## 6.4 Lambda

### บทนำ

Lambda เป็น anonymous function ที่เขียนสั้น ๆ ในบรรทัดเดียว เหมาะสำหรับฟังก์ชันเล็ก ๆ ที่ใช้ครั้งเดียว

### นิยาม

Lambda Expression คือฟังก์ชันไม่ระบุชื่อที่เขียนในรูปแบบ `lambda args: expression`

### 6.4.1 คืออะไร

Syntax:
```python
lambda parameters: expression
```

- ไม่มี `return` (expression เป็น implicit return)
- ไม่มี statements (แค่ expression)
- Anonymous

### 6.4.2 ทำงานอย่างไร

Lambda สร้าง function object เหมือน `def` แต่สั้นกว่า

```python
# เทียบเท่า
def add(a, b): return a + b
add = lambda a, b: a + b
```

### 6.4.3 การใช้งาน

**Basic:**
```python
# ไม่มี args
f = lambda: 42
print(f())  # 42

# 1 arg
square = lambda x: x ** 2
print(square(5))  # 25

# หลาย args
add = lambda a, b: a + b
print(add(2, 3))  # 5

# Default args
greet = lambda name, greeting="Hello": f"{greeting}, {name}"
print(greet("World"))  # Hello, World

# *args
total = lambda *args: sum(args)
print(total(1, 2, 3))  # 6
```

**กับ sorted:**
```python
# เรียงตาม key
words = ["banana", "apple", "cherry", "date"]
print(sorted(words, key=lambda w: len(w)))
# ['date', 'apple', 'banana', 'cherry']

# หลาย keys
students = [
    ("Alice", 85, 22),
    ("Bob", 92, 20),
    ("Charlie", 85, 21),
]
sorted_students = sorted(students, key=lambda s: (-s[1], s[2]))
# [('Bob', 92, 20), ('Charlie', 85, 21), ('Alice', 85, 22)]
```

**กับ map/filter:**
```python
numbers = [1, 2, 3, 4, 5]

# map
squared = list(map(lambda x: x ** 2, numbers))

# filter
evens = list(filter(lambda x: x % 2 == 0, numbers))

# reduce
from functools import reduce
total = reduce(lambda a, b: a + b, numbers)
```

**กับ Dictionary:**
```python
# เรียง dict
scores = {"Alice": 85, "Bob": 92, "Charlie": 78}

# เรียงตาม value
sorted_by_score = dict(sorted(
    scores.items(),
    key=lambda item: item[1],
    reverse=True,
))
print(sorted_by_score)

# หาค่าสูงสุด
max_entry = max(scores.items(), key=lambda x: x[1])
print(max_entry)  # ('Bob', 92)
```

**Immediately Invoked:**
```python
# IIFE — Immediately Invoked Function Expression
result = (lambda x, y: x + y)(3, 4)
print(result)  # 7

# ประโยชน์ — สร้าง namespace
config = (lambda: {
    "host": "localhost",
    "port": 8080,
    "debug": False,
})()
```

**ตัวอย่างการใช้งานจริง — Query Builder:**
```python
from typing import Any, Callable

class QueryBuilder:
    def __init__(self, table: str):
        self.table = table
        self._wheres: list[tuple[str, str, Any]] = []
        self._order: list[tuple[str, bool]] = []
        self._limit: int | None = None

    def where(self, field: str, op: str, value: Any) -> "QueryBuilder":
        self._wheres.append((field, op, value))
        return self

    def order_by(self, field: str, desc: bool = False) -> "QueryBuilder":
        self._order.append((field, desc))
        return self

    def limit(self, n: int) -> "QueryBuilder":
        self._limit = n
        return self

    def build(self) -> str:
        sql = f"SELECT * FROM {self.table}"

        if self._wheres:
            conditions = [
                f"{field} {op} {self._quote(value)}"
                for field, op, value in self._wheres
            ]
            sql += " WHERE " + " AND ".join(conditions)

        if self._order:
            orders = [
                f"{field} {'DESC' if desc else 'ASC'}"
                for field, desc in self._order
            ]
            sql += " ORDER BY " + ", ".join(orders)

        if self._limit:
            sql += f" LIMIT {self._limit}"

        return sql

    @staticmethod
    def _quote(value: Any) -> str:
        if isinstance(value, str):
            return f"'{value}'"
        return str(value)


query = (
    QueryBuilder("users")
    .where("age", ">", 18)
    .where("status", "=", "active")
    .order_by("name")
    .limit(10)
    .build()
)
print(query)
```

**ตัวอย่าง — Event Handlers:**
```python
from typing import Callable
from collections import defaultdict

class EventEmitter:
    def __init__(self):
        self._handlers: dict[str, list[Callable]] = defaultdict(list)

    def on(self, event: str, handler: Callable) -> None:
        self._handlers[event].append(handler)

    def emit(self, event: str, *args, **kwargs) -> None:
        for handler in self._handlers[event]:
            handler(*args, **kwargs)


# ใช้งาน — lambda สำหรับ handlers
emitter = EventEmitter()

# Simple logging
emitter.on("user.login", lambda user: print(f"Logged in: {user}"))

# Formatting
emitter.on("order.created", lambda order: print(
    f"Order #{order['id']}: ฿{order['total']:,.2f}"
))

# Conditional logic
emitter.on("error", lambda e: (
    print(f"ERROR: {e}")
    if "critical" in str(e).lower()
    else None
))

emitter.emit("user.login", "สมชาย")
emitter.emit("order.created", {"id": 123, "total": 1500})
emitter.emit("error", "Critical error!")
```

**Lambda ใน Higher-Order Functions:**
```python
from functools import reduce
from typing import Callable, TypeVar

T = TypeVar("T")

# Composition
def compose(*fns: Callable) -> Callable:
    return lambda x: reduce(lambda acc, f: f(acc), reversed(fns), x)


def pipe(*fns: Callable) -> Callable:
    return lambda x: reduce(lambda acc, f: f(acc), fns, x)


# ใช้งาน
process = pipe(
    lambda x: x + 1,
    lambda x: x * 2,
    lambda x: x - 3,
)
print(process(10))  # ((10 + 1) * 2) - 3 = 19

# กับ list operations
operations = {
    "double": lambda x: x * 2,
    "square": lambda x: x ** 2,
    "negate": lambda x: -x,
}

def apply_ops(value: int, op_names: list[str]) -> int:
    return pipe(*(operations[name] for name in op_names))(value)

print(apply_ops(5, ["double", "square"]))  # (5*2)^2 = 100
```

### 6.4.4 ข้อดี

- **Concise:** เขียนสั้น
- **Inline:** ไม่ต้อง define
- **Functional:** เหมาะกับ HOF
- **Readable:** สำหรับ logic ง่าย

### 6.4.5 ข้อเสีย

- **Limited:** แค่ expression
- **Debugging:** ไม่มีชื่อใน stack trace
- **Readability:** ซับซ้อนอ่านยาก
- **Testing:** ยาก test แยก

### 6.4.6 ข้อควรระวัง

```python
# ระวัง 1: Late binding
funcs = []
for i in range(3):
    funcs.append(lambda: i)  # ❌

print([f() for f in funcs])  # [2, 2, 2]

# ✅ ใช้ default arg
funcs = []
for i in range(3):
    funcs.append(lambda i=i: i)
print([f() for f in funcs])  # [0, 1, 2]

# ระวัง 2: ไม่ควรใช้ lambda สำหรับ side effects
# ❌
result = (lambda x: print(x) or x * 2)(5)

# ✅
print(5)
result = 5 * 2

# ระวัง 3: lambda ที่ซับซ้อน
# ❌ อ่านยาก
process = lambda x: x if x > 0 else (x * 2 if x < 0 else 0)

# ✅ ใช้ def
def process(x):
    if x > 0:
        return x
    if x < 0:
        return x * 2
    return 0

# ระวัง 4: lambda ใน class
class MyClass:
    # ❌ lambda ไม่รับ self อัตโนมัติ
    # method = lambda self: self.value

    # ✅ ใช้ def
    def method(self):
        return self.value

# ระวัง 5: Recursion
# ❌ lambda ไม่สามารถเรียกตัวเองได้โดยตรง
# factorial = lambda n: 1 if n <= 1 else n * factorial(n-1)  # NameError

# ✅ ใช้ Y combinator หรือ def
def factorial(n):
    return 1 if n <= 1 else n * factorial(n - 1)
```

### 6.4.7 สรุป

**ใช้ Lambda เมื่อ:**
- Function สั้น (1 expression)
- ใช้ครั้งเดียว
- ส่งเป็น argument
- `key=` ใน sorted/min/max
- Callbacks ง่าย ๆ

**ใช้ `def` เมื่อ:**
- Logic ซับซ้อน
- หลาย statements
- ต้อง docstring
- ใช้ซ้ำ
- ต้องการชื่อ

**Best practices:**
- Lambda สำหรับ inline สั้น ๆ
- ใช้ `operator` module เมื่อเป็นไปได้
- Comprehension > map/filter + lambda
- หลีกเลี่ยง side effects

> **อ้างอิงเพิ่มเติม:** [Lambda Expressions](https://docs.python.org/3/tutorial/controlflow.html#lambda-expressions)

---

## 6.5 map / filter / reduce

### บทนำ

`map`, `filter`, `reduce` เป็น functional primitives ที่ใช้ transform, select, accumulate data เป็นรากฐานของ data processing

### นิยาม

- **map(f, xs):** apply f กับทุก element
- **filter(p, xs):** เก็บ elements ที่ p เป็น True
- **reduce(f, xs, init):** accumulate

### 6.5.1 คืออะไร

ทั้งสามเป็น Higher-Order Functions ที่ทำงานกับ iterables

### 6.5.2 ทำงานอย่างไร

- **map:** lazy ใน Python 3 (return iterator)
- **filter:** lazy เช่นกัน
- **reduce:** eager, return single value

### 6.5.3 การใช้งาน

**map():**
```python
# พื้นฐาน
numbers = [1, 2, 3, 4, 5]

# map object
m = map(lambda x: x ** 2, numbers)
print(type(m))  # <class 'map'>
print(list(m))  # [1, 4, 9, 16, 25]

# หลาย iterables
names = ["Alice", "Bob", "Charlie"]
ages = [25, 30, 35]
people = list(map(lambda n, a: {"name": n, "age": a}, names, ages))
print(people)
# [{'name': 'Alice', 'age': 25}, ...]

# กับ built-in functions
strings = ["1", "2", "3", "4"]
numbers = list(map(int, strings))
print(numbers)  # [1, 2, 3, 4]

# กับ method
words = ["hello", "world"]
uppercase = list(map(str.upper, words))
print(uppercase)  # ['HELLO', 'WORLD']
```

**filter():**
```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# พื้นฐาน
evens = list(filter(lambda x: x % 2 == 0, numbers))
print(evens)  # [2, 4, 6, 8, 10]

# กับ None — filter truthy
data = [0, 1, "", "hello", None, [], [1, 2], False, True]
truthy = list(filter(None, data))
print(truthy)  # [1, 'hello', [1, 2], True]

# กับ custom predicate
def is_adult(person: dict) -> bool:
    return person["age"] >= 18

people = [
    {"name": "Alice", "age": 25},
    {"name": "Bob", "age": 15},
    {"name": "Charlie", "age": 30},
]
adults = list(filter(is_adult, people))
print(adults)
```

**reduce():**
```python
from functools import reduce
from operator import add, mul

numbers = [1, 2, 3, 4, 5]

# Sum
total = reduce(add, numbers)
print(total)  # 15

# Product
product = reduce(mul, numbers)
print(product)  # 120

# Max
max_val = reduce(lambda a, b: a if a > b else b, numbers)
print(max_val)  # 5

# Flatten
nested = [[1, 2], [3, 4], [5, 6]]
flat = reduce(lambda acc, x: acc + x, nested, [])
print(flat)  # [1, 2, 3, 4, 5, 6]

# Group by
items = [("a", 1), ("b", 2), ("a", 3), ("b", 4)]
def group_by_key(acc, item):
    key, value = item
    acc.setdefault(key, []).append(value)
    return acc

grouped = reduce(group_by_key, items, {})
print(grouped)  # {'a': [1, 3], 'b': [2, 4]}
```

**Chaining:**
```python
# map + filter + reduce
numbers = range(1, 11)

# Sum of squares of evens
result = reduce(
    add,
    map(lambda x: x ** 2,
        filter(lambda x: x % 2 == 0, numbers)),
    0,
)
print(result)  # 4 + 16 + 36 + 64 + 100 = 220

# ✅ อ่านง่ายกว่าด้วย generator
result = sum(x ** 2 for x in numbers if x % 2 == 0)
```

**Operator Module (เร็วกว่า lambda):**
```python
from operator import add, mul, itemgetter, attrgetter
from functools import reduce

# add, mul เร็วกว่า lambda
numbers = range(1, 101)
total = reduce(add, numbers)

# itemgetter — เร็วกว่า lambda x: x[i]
data = [("Alice", 85), ("Bob", 92), ("Charlie", 78)]
sorted_by_score = sorted(data, key=itemgetter(1), reverse=True)
print(sorted_by_score)

# attrgetter — เร็วกว่า lambda x: x.attr
from dataclasses import dataclass

@dataclass
class User:
    name: str
    age: int

users = [User("Alice", 30), User("Bob", 25), User("Charlie", 35)]
sorted_by_age = sorted(users, key=attrgetter("age"))
print(sorted_by_age)
```

**ตัวอย่างการใช้งานจริง — Data Processing:**
```python
from dataclasses import dataclass
from datetime import datetime, timedelta
from functools import reduce
from operator import attrgetter

@dataclass
class Transaction:
    id: str
    user_id: str
    amount: float
    category: str
    date: datetime


transactions = [
    Transaction("T001", "U1", 100.0, "food", datetime(2024, 1, 1)),
    Transaction("T002", "U1", 50.0, "transport", datetime(2024, 1, 2)),
    Transaction("T003", "U2", 200.0, "food", datetime(2024, 1, 3)),
    Transaction("T004", "U1", 75.0, "food", datetime(2024, 1, 4)),
    Transaction("T005", "U2", 300.0, "shopping", datetime(2024, 1, 5)),
]


# คำนวณยอดรวมอาหารของผู้ใช้ U1
def total_u1_food(transactions: list[Transaction]) -> float:
    return reduce(
        lambda acc, t: acc + t.amount,
        filter(
            lambda t: t.user_id == "U1" and t.category == "food",
            transactions,
        ),
        0.0,
    )


print(total_u1_food(transactions))  # 175.0


# ✅ อ่านง่ายกว่าด้วย generator
def total_u1_food_v2(transactions: list[Transaction]) -> float:
    return sum(
        t.amount
        for t in transactions
        if t.user_id == "U1" and t.category == "food"
    )


# Group by category
def group_by_category(
    transactions: list[Transaction],
) -> dict[str, list[Transaction]]:
    def reducer(acc: dict, t: Transaction) -> dict:
        acc.setdefault(t.category, []).append(t)
        return acc

    return reduce(reducer, transactions, {})


grouped = group_by_category(transactions)
for category, items in grouped.items():
    total = reduce(lambda a, t: a + t.amount, items, 0.0)
    print(f"{category}: {total:.2f}")
```

**ตัวอย่าง — ETL Pipeline:**
```python
from functools import reduce
from typing import Any

def extract(raw_data: list[dict]) -> list[dict]:
    """Extract — clean data"""
    return list(filter(
        lambda row: row.get("id") and row.get("amount", 0) > 0,
        raw_data,
    ))


def transform(rows: list[dict]) -> list[dict]:
    """Transform — add computed fields"""
    return list(map(
        lambda row: {
            **row,
            "amount_with_tax": row["amount"] * 1.07,
            "category_upper": row["category"].upper(),
        },
        rows,
    ))


def load(rows: list[dict]) -> dict[str, float]:
    """Load — aggregate by category"""
    def reducer(acc: dict, row: dict) -> dict:
        category = row["category_upper"]
        acc[category] = acc.get(category, 0) + row["amount_with_tax"]
        return acc

    return reduce(reducer, rows, {})


# Pipeline
raw_data = [
    {"id": "T1", "amount": 100, "category": "food"},
    {"id": "T2", "amount": -50, "category": "food"},  # invalid
    {"id": "T3", "amount": 200, "category": "transport"},
    {"id": "", "amount": 100, "category": "food"},  # invalid
    {"id": "T4", "amount": 150, "category": "food"},
]

# Chained
result = load(transform(extract(raw_data)))
print(result)
# {'FOOD': 267.5, 'TRANSPORT': 214.0}
```

**Comprehension vs map/filter:**
```python
import timeit

data = list(range(1000))

# map/filter
t1 = timeit.timeit(
    lambda: list(map(lambda x: x * 2, filter(lambda x: x % 2 == 0, data))),
    number=1000,
)

# comprehension
t2 = timeit.timeit(
    lambda: [x * 2 for x in data if x % 2 == 0],
    number=1000,
)

print(f"map/filter: {t1:.4f}s")
print(f"comprehension: {t2:.4f}s")
# comprehension มักเร็วกว่า
```

### 6.5.4 ข้อดี

- **Functional:** declarative style
- **Chainable:** ต่อกันได้
- **Lazy:** map/filter เป็น lazy
- **Composable:** ใช้กับ HOF อื่น

### 6.5.5 ข้อเสีย

- **Readability:** comprehension อ่านง่ายกว่า
- **Performance:** reduce ช้ากว่า sum/min/max
- **Debugging:** stack trace ซับซ้อน
- **Iterators:** ใช้ได้ครั้งเดียว

### 6.5.6 ข้อควรระวัง

```python
# ระวัง 1: map/filter return iterator
m = map(lambda x: x * 2, [1, 2, 3])
print(list(m))  # [2, 4, 6]
print(list(m))  # [] — ใช้หมดแล้ว!

# ระวัง 2: reduce กับ empty iterable
from functools import reduce
try:
    reduce(lambda a, b: a + b, [])  # ❌ TypeError
except TypeError as e:
    print(e)

# ✅ ใส่ initial
result = reduce(lambda a, b: a + b, [], 0)
print(result)  # 0

# ระวัง 3: ไม่ควรใช้ reduce สำหรับทุกอย่าง
# ❌
max_val = reduce(lambda a, b: a if a > b else b, [1, 2, 3])
# ✅
max_val = max([1, 2, 3])

# ระวัง 4: Complex reduce อ่านยาก
# ❌
result = reduce(
    lambda acc, x: {**acc, x[0]: acc.get(x[0], 0) + x[1]},
    items,
    {},
)
# ✅ ใช้ defaultdict
from collections import defaultdict
result = defaultdict(int)
for key, value in items:
    result[key] += value
```

### 6.5.7 สรุป

**map:**
- Transform ทุก element
- Lazy (iterator)
- ใช้กับ built-in functions

**filter:**
- Select elements
- Lazy
- `filter(None, ...)` สำหรับ truthy

**reduce:**
- Accumulate
- Eager
- ต้อง initial value

**Best practices:**
- Comprehension > map/filter + lambda
- ใช้ `operator` module
- `sum()`, `min()`, `max()` > reduce
- Type hints
- ระวัง iterator consumption

> **อ้างอิงเพิ่มเติม:** [Functional Programming Tools](https://docs.python.org/3/howto/functional.html#built-in-functions)

---

## 6.6 Closure

### บทนำ

Closure คือฟังก์ชันที่ "จำ" สภาพแวดล้อมที่สร้างขึ้น (lexical scope) แม้ scope นั้นจะจบไปแล้ว

### นิยาม

Closure คือ nested function ที่จดจำ variables จาก enclosing scope แม้ enclosing function return แล้ว

### 6.6.1 คืออะไร

Closure ประกอบด้วย:
1. Function
2. Environment (enclosing variables)

### 6.6.2 ทำงานอย่างไร

Python เก็บ enclosing variables ใน `__closure__` cell objects

```python
def outer():
    x = 10  # enclosing
    def inner():
        return x  # closure captures x
    return inner

fn = outer()
print(fn())  # 10
print(fn.__closure__)  # (<cell at ...>,)
print(fn.__closure__[0].cell_contents)  # 10
```

### 6.6.3 การใช้งาน

**Counter:**
```python
def make_counter(start: int = 0):
    """Factory — return counter function"""
    count = start

    def counter() -> int:
        nonlocal count
        count += 1
        return count

    return counter


counter1 = make_counter()
counter2 = make_counter(100)

print(counter1())  # 1
print(counter1())  # 2
print(counter2())  # 101
print(counter1())  # 3
```

**Function Factory:**
```python
def make_multiplier(factor: int):
    def multiplier(x: int) -> int:
        return x * factor
    return multiplier


double = make_multiplier(2)
triple = make_multiplier(3)

print(double(5))  # 10
print(triple(5))  # 15
```

**Configuration Capture:**
```python
def create_logger(prefix: str, level: str = "INFO"):
    def log(message: str) -> None:
        print(f"[{level}] {prefix}: {message}")
    return log


user_log = create_logger("USER", "DEBUG")
order_log = create_logger("ORDER")

user_log("User logged in")    # [DEBUG] USER: User logged in
order_log("Order placed")     # [INFO] ORDER: Order placed
```

**Partial Application:**
```python
def make_power(exponent: int):
    def power(base: float) -> float:
        return base ** exponent
    return power


square = make_power(2)
cube = make_power(3)

print(square(5))  # 25
print(cube(5))    # 125
```

**Data Encapsulation:**
```python
def create_account(initial_balance: float = 0):
    """Closure-based encapsulation"""
    balance = initial_balance
    transactions: list[tuple[str, float]] = []

    def deposit(amount: float) -> float:
        nonlocal balance
        if amount <= 0:
            raise ValueError("Amount must be positive")
        balance += amount
        transactions.append(("deposit", amount))
        return balance

    def withdraw(amount: float) -> float:
        nonlocal balance
        if amount <= 0:
            raise ValueError("Amount must be positive")
        if amount > balance:
            raise ValueError("Insufficient funds")
        balance -= amount
        transactions.append(("withdraw", amount))
        return balance

    def get_balance() -> float:
        return balance

    def get_statement() -> list:
        return transactions.copy()

    return {
        "deposit": deposit,
        "withdraw": withdraw,
        "balance": get_balance,
        "statement": get_statement,
    }


account = create_account(1000)
account["deposit"](500)
account["withdraw"](200)
print(account["balance"]())  # 1300
print(account["statement"]())
# [('deposit', 500), ('withdraw', 200)]
```

**Decorator with State:**
```python
from functools import wraps
from typing import Callable, TypeVar
import time

F = TypeVar("F", bound=Callable)

def rate_limit(max_calls: int, period: float):
    """Decorator — จำกัดจำนวนครั้งที่เรียก"""
    def decorator(func: F) -> F:
        calls: list[float] = []

        @wraps(func)
        def wrapper(*args, **kwargs):
            now = time.time()
            # ลบ calls เก่า
            calls[:] = [t for t in calls if now - t < period]

            if len(calls) >= max_calls:
                raise RuntimeError(
                    f"Rate limit: {max_calls} calls per {period}s"
                )

            calls.append(now)
            return func(*args, **kwargs)

        return wrapper  # type: ignore
    return decorator


@rate_limit(max_calls=3, period=1.0)
def api_call() -> str:
    return "Response"


for i in range(5):
    try:
        print(f"Call {i}: {api_call()}")
    except RuntimeError as e:
        print(f"Call {i}: {e}")
    time.sleep(0.3)
```

**ตัวอย่างการใช้งานจริง — Dependency Container:**
```python
from typing import Callable, Any

def create_container():
    """Simple DI container ด้วย closure"""
    services: dict[str, Any] = {}

    def register(name: str, factory: Callable[[], Any]) -> None:
        services[name] = factory

    def resolve(name: str) -> Any:
        if name not in services:
            raise KeyError(f"Service '{name}' not registered")
        service = services[name]
        # Lazy instantiation
        if callable(service):
            instance = service()
            services[name] = instance  # cache
            return instance
        return service

    def singleton(name: str, instance: Any) -> None:
        services[name] = instance

    return register, resolve, singleton


# ใช้งาน
register, resolve, singleton = create_container()


class Database:
    def __init__(self):
        self.connection = "connected"

    def query(self, sql: str) -> list:
        return []


class UserService:
    def __init__(self, db: Database):
        self.db = db

    def find(self, user_id: int) -> dict:
        return {"id": user_id, "name": "test"}


# Register
register("database", lambda: Database())
register("user_service", lambda: UserService(resolve("database")))

# Resolve
db = resolve("database")
print(db.connection)  # connected

# Singleton
db2 = resolve("database")
print(db is db2)  # True (cached)

service = resolve("user_service")
print(service.find(1))
```

**ตัวอย่าง — Memoization:**
```python
from typing import Callable, TypeVar, Any
from functools import wraps
import time

F = TypeVar("F", bound=Callable)

def memoize(func: F) -> F:
    """Closure-based memoization"""
    cache: dict = {}

    @wraps(func)
    def wrapper(*args, **kwargs):
        # ต้อง hashable
        key = (args, tuple(sorted(kwargs.items())))

        if key not in cache:
            cache[key] = func(*args, **kwargs)
        return cache[key]

    wrapper.cache = cache  # expose cache
    wrapper.clear_cache = cache.clear

    return wrapper  # type: ignore


@memoize
def slow_fibonacci(n: int) -> int:
    if n <= 1:
        return n
    return slow_fibonacci(n - 1) + slow_fibonacci(n - 2)


start = time.time()
print(slow_fibonacci(100))
print(f"Time: {time.time() - start:.4f}s")

# Clear cache
slow_fibonacci.clear_cache()
```

**ตัวอย่าง — Validation Framework:**
```python
from typing import Callable, Any

def make_validator():
    """Closure-based validation rules"""
    rules: list[tuple[str, Callable, str]] = []

    def add_rule(
        field: str,
        check: Callable[[Any], bool],
        message: str,
    ) -> Callable:
        rules.append((field, check, message))
        return add_rule  # chainable

    def validate(data: dict) -> list[str]:
        errors = []
        for field, check, message in rules:
            value = data.get(field)
            try:
                if not check(value):
                    errors.append(f"{field}: {message}")
            except Exception as e:
                errors.append(f"{field}: {e}")
        return errors

    return add_rule, validate


# ใช้งาน
add_rule, validate = make_validator()

(add_rule("email", lambda v: v and "@" in v, "Invalid email")
    ("username", lambda v: v and len(v) >= 3, "Min 3 chars")
    ("age", lambda v: v and 0 <= v <= 150, "Invalid age"))

errors = validate({
    "email": "invalid",
    "username": "ab",
    "age": 200,
})

for error in errors:
    print(error)
```

### 6.6.4 ข้อดี

- **Encapsulation:** ซ่อน state
- **Factory:** สร้าง functions
- **State:** จำ state ระหว่าง calls
- **Functional:** pure-ish functions
- **No classes:** ไม่ต้องใช้ class

### 6.6.5 ข้อเสีย

- **Memory:** ถือ reference ไว้
- **Debugging:** เข้าใจยาก
- **Pickling:** ไม่สามารถ pickle
- **Testing:** ยาก test

### 6.6.6 ข้อควรระวัง

```python
# ระวัง 1: Late binding
def make_functions():
    funcs = []
    for i in range(3):
        funcs.append(lambda: i)  # ❌ ทั้งหมดได้ 2
    return funcs

# ✅ ใช้ default
def make_functions_fixed():
    return [lambda i=i: i for i in range(3)]

# ระวัง 2: Loop variable capture
funcs = [lambda: i for i in range(3)]
print([f() for f in funcs])  # [2, 2, 2]

# ✅
funcs = [lambda i=i: i for i in range(3)]
print([f() for f in funcs])  # [0, 1, 2]

# ระวัง 3: Memory leak
def create_closure():
    large_data = [0] * 10_000_000
    def closure():
        return len(large_data)  # ถือ reference
    return closure

# ถ้าไม่ใช้ large_data → memory leak
# ✅ ใช้ del
def create_closure_fixed():
    large_data = [0] * 10_000_000
    size = len(large_data)
    del large_data
    def closure():
        return size
    return closure

# ระวัง 4: nonlocal กับ mutable
def make_counter():
    count = [0]  # mutable เพื่อหลีก nonlocal
    def counter():
        count[0] += 1
        return count[0]
    return counter

# ✅ ใช้ nonlocal
def make_counter_v2():
    count = 0
    def counter():
        nonlocal count
        count += 1
        return count
    return counter

# ระวัง 5: Pickling closures
# ❌ ไม่สามารถ pickle
# import pickle
# counter = make_counter()
# pickle.dumps(counter)  # AttributeError

# ✅ ใช้ class แทน
class Counter:
    def __init__(self):
        self.count = 0

    def __call__(self):
        self.count += 1
        return self.count
```

### 6.6.7 สรุป

**Closure ใช้เมื่อ:**
- Function factory
- Private state
- Decorators
- Partial application
- Configuration capture

**ข้อดี:**
- Encapsulation
- Functional
- Simple factories

**ข้อควรระวัง:**
- Late binding
- Memory leaks
- Pickling
- Loop variable

**Best practices:**
- ใช้ `nonlocal` ชัดเจน
- ระวัง late binding
- Cleanup references
- ใช้ class ถ้าซับซ้อน

> **อ้างอิงเพิ่มเติม:** [Closures](https://docs.python.org/3/reference/executionmodel.html#naming-and-binding)

---

## 6.7 Decorator

### บทนำ

Decorator เป็น Higher-Order Function ที่ wrap function เพื่อเพิ่ม behavior โดยไม่แก้โค้ดต้นฉบับ เป็น Pythonic pattern ที่ทรงพลัง

### นิยาม

Decorator คือ callable ที่รับ function และ return function ใหม่

### 6.7.1 คืออะไร

Syntax:
```python
@decorator
def func():
    pass

# เทียบเท่า
func = decorator(func)
```

### 6.7.2 ทำงานอย่างไร

Decorators apply ตอน definition time:

1. Python เห็น `@decorator`
2. ส่ง function ให้ decorator
3. ได้ function ใหม่มาแทน
4. Bind ชื่อ

### 6.7.3 การใช้งาน

**Basic Decorator:**
```python
from functools import wraps
from typing import Callable, TypeVar

F = TypeVar("F", bound=Callable)

def simple_decorator(func: F) -> F:
    @wraps(func)
    def wrapper(*args, **kwargs):
        print(f"Before {func.__name__}")
        result = func(*args, **kwargs)
        print(f"After {func.__name__}")
        return result
    return wrapper  # type: ignore


@simple_decorator
def greet(name: str) -> str:
    return f"Hello, {name}"


print(greet("World"))
# Before greet
# After greet
# Hello, World
```

**Decorator with Arguments:**
```python
def repeat(times: int):
    """Decorator factory"""
    def decorator(func: F) -> F:
        @wraps(func)
        def wrapper(*args, **kwargs):
            for _ in range(times - 1):
                func(*args, **kwargs)
            return func(*args, **kwargs)
        return wrapper  # type: ignore
    return decorator


@repeat(3)
def say_hi():
    print("Hi!")


say_hi()
# Hi!
# Hi!
# Hi!
```

**Timing Decorator:**
```python
import time

def timing(func: F) -> F:
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        try:
            return func(*args, **kwargs)
        finally:
            elapsed = time.perf_counter() - start
            print(f"{func.__name__}: {elapsed:.4f}s")
    return wrapper  # type: ignore


@timing
def process_data(n: int) -> int:
    return sum(i ** 2 for i in range(n))


process_data(1_000_000)
# process_data: 0.1234s
```

**Retry Decorator:**
```python
import time

def retry(
    max_attempts: int = 3,
    delay: float = 1.0,
    backoff: float = 1.0,
    exceptions: tuple = (Exception,),
):
    def decorator(func: F) -> F:
        @wraps(func)
        def wrapper(*args, **kwargs):
            current_delay = delay
            last_exc = None

            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except exceptions as e:
                    last_exc = e
                    if attempt < max_attempts - 1:
                        print(f"Attempt {attempt + 1} failed: {e}. Retrying...")
                        time.sleep(current_delay)
                        current_delay *= backoff

            raise last_exc  # type: ignore
        return wrapper  # type: ignore
    return decorator


@retry(max_attempts=3, delay=0.1, backoff=2.0)
def unreliable_call():
    import random
    if random.random() < 0.7:
        raise ConnectionError("Network error")
    return "Success"


try:
    print(unreliable_call())
except ConnectionError as e:
    print(f"All attempts failed: {e}")
```

**Cache/Memoize:**
```python
def memoize(func: F) -> F:
    cache: dict = {}

    @wraps(func)
    def wrapper(*args, **kwargs):
        key = (args, tuple(sorted(kwargs.items())))
        if key not in cache:
            cache[key] = func(*args, **kwargs)
        return cache[key]

    wrapper.cache = cache  # type: ignore
    wrapper.clear_cache = cache.clear  # type: ignore
    return wrapper  # type: ignore


@memoize
def fibonacci(n: int) -> int:
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)


print(fibonacci(50))  # 12586269025
```

**Logging Decorator:**
```python
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def logged(func: F) -> F:
    @wraps(func)
    def wrapper(*args, **kwargs):
        logger.info(
            f"Calling {func.__name__} "
            f"args={args} kwargs={kwargs}"
        )
        try:
            result = func(*args, **kwargs)
            logger.info(f"{func.__name__} returned {result!r}")
            return result
        except Exception as e:
            logger.exception(f"{func.__name__} raised {type(e).__name__}")
            raise
    return wrapper  # type: ignore


@logged
def divide(a: float, b: float) -> float:
    return a / b


divide(10, 2)
```

**Access Control:**
```python
from functools import wraps
from typing import Callable, TypeVar
import time

F = TypeVar("F", bound=Callable)


def requires_auth(func: F) -> F:
    @wraps(func)
    def wrapper(*args, **kwargs):
        user = kwargs.get("user") or (args[0] if args else None)
        if not user or not user.get("authenticated"):
            raise PermissionError("Authentication required")
        return func(*args, **kwargs)
    return wrapper  # type: ignore


def requires_role(role: str):
    def decorator(func: F) -> F:
        @wraps(func)
        def wrapper(*args, **kwargs):
            user = kwargs.get("user") or (args[0] if args else None)
            if not user:
                raise PermissionError("No user")
            if role not in user.get("roles", []):
                raise PermissionError(f"Role '{role}' required")
            return func(*args, **kwargs)
        return wrapper  # type: ignore
    return decorator


@requires_auth
@requires_role("admin")
def delete_user(user: dict, target_id: int) -> str:
    return f"Deleted user {target_id}"


admin = {"authenticated": True, "roles": ["admin"]}
print(delete_user(user=admin, target_id=42))

try:
    regular = {"authenticated": True, "roles": ["user"]}
    delete_user(user=regular, target_id=42)
except PermissionError as e:
    print(f"Error: {e}")
```

**Class Decorator:**
```python
# Decorator ที่ใช้กับ class
def add_method(cls):
    def new_method(self):
        return "added by decorator"
    cls.new_method = new_method
    return cls


@add_method
class MyClass:
    def original(self):
        return "original"


obj = MyClass()
print(obj.original())   # original
print(obj.new_method()) # added by decorator
```

**Decorator รับ Decorator:**
```python
import time
from functools import wraps

def profile(report_threshold: float = 0.5):
    """Decorator factory ที่มี options"""
    def decorator(func: F) -> F:
        total_time = 0.0
        call_count = 0

        @wraps(func)
        def wrapper(*args, **kwargs):
            nonlocal total_time, call_count
            start = time.perf_counter()
            result = func(*args, **kwargs)
            elapsed = time.perf_counter() - start

            total_time += elapsed
            call_count += 1

            avg = total_time / call_count

            if elapsed > report_threshold:
                print(
                    f"SLOW {func.__name__}: {elapsed:.4f}s "
                    f"(avg: {avg:.4f}s)"
                )

            return result

        wrapper.stats = lambda: {
            "calls": call_count,
            "total": total_time,
            "average": total_time / call_count if call_count else 0,
        }

        return wrapper  # type: ignore
    return decorator


@profile(report_threshold=0.01)
def slow_function():
    time.sleep(0.05)


@profile(report_threshold=0.01)
def fast_function():
    return 42


for _ in range(3):
    slow_function()
    fast_function()

print(slow_function.stats())  # type: ignore
```

**ตัวอย่างการใช้งานจริง — FastAPI-style Routing:**
```python
from typing import Callable, Any
from dataclasses import dataclass, field

@dataclass
class Route:
    method: str
    path: str
    handler: Callable


class Router:
    def __init__(self):
        self.routes: list[Route] = []

    def route(self, method: str, path: str):
        def decorator(func: Callable) -> Callable:
            self.routes.append(Route(method, path, func))
            return func
        return decorator

    def get(self, path: str):
        return self.route("GET", path)

    def post(self, path: str):
        return self.route("POST", path)

    def handle(self, method: str, path: str, **kwargs) -> Any:
        for route in self.routes:
            if route.method == method and route.path == path:
                return route.handler(**kwargs)
        raise ValueError(f"Route not found: {method} {path}")


# ใช้งาน
app = Router()


@app.get("/users/{user_id}")
def get_user(user_id: int) -> dict:
    return {"id": user_id, "name": "สมชาย"}


@app.post("/users")
def create_user(name: str) -> dict:
    return {"id": 1, "name": name}


print(app.handle("GET", "/users/{user_id}", user_id=42))
print(app.handle("POST", "/users", name="สมหญิง"))
```

**ตัวอย่าง — Retry with Circuit Breaker:**
```python
from functools import wraps
from datetime import datetime, timedelta
import time
from typing import Callable, TypeVar

F = TypeVar("F", bound=Callable)


class CircuitBreaker:
    def __init__(
        self,
        failure_threshold: int = 5,
        recovery_timeout: float = 30.0,
    ):
        self.failure_threshold = failure_threshold
        self.recovery_timeout = recovery_timeout
        self.failures = 0
        self.last_failure_time: datetime | None = None
        self.state = "closed"

    def __call__(self, func: F) -> F:
        @wraps(func)
        def wrapper(*args, **kwargs):
            self._check_state()

            try:
                result = func(*args, **kwargs)
                self._on_success()
                return result
            except Exception as e:
                self._on_failure()
                raise e

        return wrapper  # type: ignore

    def _check_state(self):
        if self.state == "open":
            if self.last_failure_time:
                elapsed = (datetime.now() - self.last_failure_time).total_seconds()
                if elapsed >= self.recovery_timeout:
                    self.state = "half-open"
                    print("Circuit breaker: half-open")
                else:
                    raise RuntimeError("Circuit breaker is OPEN")

    def _on_success(self):
        if self.state == "half-open":
            print("Circuit breaker: closed")
        self.failures = 0
        self.state = "closed"

    def _on_failure(self):
        self.failures += 1
        self.last_failure_time = datetime.now()

        if self.failures >= self.failure_threshold:
            self.state = "open"
            print(f"Circuit breaker: OPEN ({self.failures} failures)")


breaker = CircuitBreaker(failure_threshold=3, recovery_timeout=2.0)


@breaker
def external_api() -> str:
    import random
    if random.random() < 0.7:
        raise ConnectionError("API unavailable")
    return "Success"


for i in range(10):
    try:
        result = external_api()
        print(f"Call {i}: {result}")
    except Exception as e:
        print(f"Call {i}: {type(e).__name__}: {e}")
    time.sleep(0.3)
```

### 6.7.4 ข้อดี

- **DRY:** ไม่ต้องเขียนซ้ำ
- **Separation:** แยก concerns
- **Composable:** ต่อกันได้
- **Readable:** `@decorator` ชัดเจน
- **Reusable:** ใช้ซ้ำได้

### 6.7.5 ข้อเสีย

- **Magic:** อาจ obscure
- **Debugging:** stack trace ซับซ้อน
- **Performance:** function call overhead
- **Introspection:** ต้องใช้ `@wraps`

### 6.7.6 ข้อควรระวัง

```python
# ระวัง 1: ลืม @wraps
# ❌ สูญเสีย metadata
def bad_decorator(func):
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper

@bad_decorator
def my_func():
    """My docstring"""
    pass

print(my_func.__name__)  # wrapper ❌
print(my_func.__doc__)   # None ❌

# ✅ ใช้ @wraps
from functools import wraps

def good_decorator(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper

# ระวัง 2: Decorator ที่รับ arguments
# ❌ ทั้ง 3 แบบ
# @decorator           — รับ func
# @decorator()         — รับ ()
# @decorator(arg)      — รับ (arg)

# ✅ Handle ทั้งคู่
def flexible_decorator(func=None, *, option=None):
    def decorator(f):
        @wraps(f)
        def wrapper(*args, **kwargs):
            return f(*args, **kwargs)
        return wrapper

    if func is None:
        return decorator
    return decorator(func)

# ระวัง 3: Signature
import inspect
def strict_decorator(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper

# @wraps คัดลอก signature
sig = inspect.signature(strict_decorator(lambda x, y: x + y))
print(sig)  # (x, y)

# ระวัง 4: ลำดับ decorator (จากล่างขึ้นบน)
@decorator_a
@decorator_b
def func():
    pass

# เท่ากับ func = decorator_a(decorator_b(func))

# ระวัง 5: Decorator สำหรับ methods
class MyClass:
    @my_decorator
    def method(self):
        pass
    # self ถูก pass ปกติ

# ระวัง 6: Async decorators
import asyncio

def async_decorator(func):
    @wraps(func)
    async def wrapper(*args, **kwargs):
        print("Before")
        result = await func(*args, **kwargs)
        print("After")
        return result
    return wrapper


@async_decorator
async def fetch():
    await asyncio.sleep(0.1)
    return "data"

# asyncio.run(fetch())
```

### 6.7.7 สรุป

**ใช้ Decorator เมื่อ:**
- Cross-cutting concerns (logging, timing, auth)
- Retry/circuit breaker
- Caching
- Registration
- Validation

**Types:**
- Simple: `@decorator`
- With args: `@decorator(args)`
- Class-based: `__call__`
- Async: `async def wrapper`

**Best practices:**
- ใช้ `@wraps` เสมอ
- Support signature ปกติ
- Document behavior
- ระวัง performance
- Composable — decorator เล็ก ๆ

> **อ้างอิงเพิ่มเติม:** [PEP 318 — Decorators](https://peps.python.org/pep-0318/), [functools.wraps](https://docs.python.org/3/library/functools.html#functools.wraps)

---

## 6.8 Function Composition

### บทนำ

Function Composition คือการรวม functions เล็ก ๆ เป็น function ใหญ่ เป็นหัวใจของ Functional Programming ช่วยให้โค้ด modular และ reusable

### นิยาม

Function Composition คือการนำ output ของ function หนึ่งเป็น input ของอีก function

`(f ∘ g)(x) = f(g(x))`

### 6.8.1 คืออะไร

- **compose(f, g)(x) = f(g(x))** — right-to-left
- **pipe(f, g)(x) = g(f(x))** — left-to-right (มัก intuitive กว่า)

### 6.8.2 ทำงานอย่างไร

Python ไม่มี built-in `compose` แต่เขียนได้ง่าย ๆ ด้วย `functools.reduce`

### 6.8.3 การใช้งาน

**Basic Composition:**
```python
from functools import reduce
from typing import Callable, TypeVar

T = TypeVar("T")

def compose(*functions: Callable) -> Callable:
    """Compose right-to-left: compose(f, g)(x) = f(g(x))"""
    def composed(value):
        return reduce(lambda acc, f: f(acc), reversed(functions), value)
    return composed


def pipe(*functions: Callable) -> Callable:
    """Pipe left-to-right: pipe(f, g)(x) = g(f(x))"""
    def piped(value):
        return reduce(lambda acc, f: f(acc), functions, value)
    return piped


# ใช้งาน
add_one = lambda x: x + 1
double = lambda x: x * 2
square = lambda x: x ** 2

# compose(f, g, h)(x) = f(g(h(x)))
f1 = compose(add_one, double, square)
print(f1(3))  # add_one(double(square(3))) = add_one(18) = 19

# pipe(f, g, h)(x) = h(g(f(x)))
f2 = pipe(add_one, double, square)
print(f2(3))  # square(double(add_one(3))) = square(8) = 64
```

**Named Functions:**
```python
def normalize(text: str) -> str:
    return text.strip().lower()


def remove_punctuation(text: str) -> str:
    import re
    return re.sub(r"[^\w\s]", "", text)


def replace_spaces(text: str) -> str:
    return text.replace(" ", "_")


# Compose เป็น pipeline
slugify = pipe(normalize, remove_punctuation, replace_spaces)

print(slugify("  Hello, World!  "))
# hello_world

print(slugify("Python Programming — Basics"))
# python_programming__basics
```

**Currying:**
```python
from typing import Callable

def curry(func: Callable) -> Callable:
    """Convert f(a, b) → f(a)(b)"""
    import inspect
    sig = inspect.signature(func)
    params = list(sig.parameters.values())

    if len(params) == 1:
        return func

    def curried(a):
        def partially_applied(*args):
            return func(a, *args)
        return curried(partially_applied) if len(params) > 2 else partially_applied

    return curried


# ใช้ functools.partial แทน (Pythonic)
from functools import partial

def add(a: int, b: int, c: int) -> int:
    return a + b + c


# Manual currying ด้วย partial
add_5 = partial(add, 5)
add_5_10 = partial(add_5, 10)
print(add_5_10(20))  # 35
```

**Composition กับ Data:**
```python
from dataclasses import dataclass
from typing import Callable

@dataclass
class User:
    name: str
    email: str
    age: int


# Individual transforms
def normalize_name(user: User) -> User:
    return User(
        name=user.name.strip().title(),
        email=user.email,
        age=user.age,
    )


def normalize_email(user: User) -> User:
    return User(
        name=user.name,
        email=user.email.lower(),
        age=user.age,
    )


def add_email_domain(user: User) -> User:
    if "@" not in user.email:
        return User(
            name=user.name,
            email=f"{user.email}@example.com",
            age=user.age,
        )
    return user


# Compose
normalize_user = pipe(normalize_name, normalize_email, add_email_domain)

user = User("  สมชาย  ", "SOMCHAI", 30)
print(normalize_user(user))
# User(name='สมชาย', email='somchai@example.com', age=30)
```

**ตัวอย่างการใช้งานจริง — API Request Pipeline:**
```python
from typing import Callable, Any
from dataclasses import dataclass

@dataclass
class Request:
    url: str
    method: str = "GET"
    headers: dict[str, str] = None
    body: Any = None

    def __post_init__(self):
        if self.headers is None:
            self.headers = {}


@dataclass
class Response:
    status: int
    data: Any = None
    error: str = ""


# Middleware-like functions
def add_auth_header(req: Request) -> Request:
    headers = {**req.headers, "Authorization": "Bearer token123"}
    return Request(req.url, req.method, headers, req.body)


def add_user_agent(req: Request) -> Request:
    headers = {**req.headers, "User-Agent": "MyApp/1.0"}
    return Request(req.url, req.method, headers, req.body)


def add_content_type(req: Request) -> Request:
    if req.method in ("POST", "PUT"):
        headers = {**req.headers, "Content-Type": "application/json"}
        return Request(req.url, req.method, headers, req.body)
    return req


# Pipeline
prepare_request = pipe(add_auth_header, add_user_agent, add_content_type)

req = Request("https://api.example.com/users", "POST", body={"name": "test"})
prepared = prepare_request(req)

for key, value in prepared.headers.items():
    print(f"{key}: {value}")
```

**ตัวอย่าง — Validation Pipeline:**
```python
from typing import Callable, Any
from dataclasses import dataclass, field

@dataclass
class ValidationError:
    field: str
    message: str


@dataclass
class ValidationResult:
    is_valid: bool = True
    errors: list[ValidationError] = field(default_factory=list)

    def add_error(self, field: str, message: str) -> "ValidationResult":
        return ValidationResult(
            is_valid=False,
            errors=self.errors + [ValidationError(field, message)],
        )


# Validators
def validate_required(data: dict) -> ValidationResult:
    errors = []
    for field in ["name", "email", "age"]:
        if not data.get(field):
            errors.append(ValidationError(field, "Required"))
    if errors:
        return ValidationResult(is_valid=False, errors=errors)
    return ValidationResult()


def validate_email(data: dict) -> ValidationResult:
    import re
    email = data.get("email", "")
    if not re.match(r"^[\w.+-]+@[\w-]+\.[\w.]+$", email):
        return ValidationResult().add_error("email", "Invalid format")
    return ValidationResult()


def validate_age(data: dict) -> ValidationResult:
    age = data.get("age")
    if not isinstance(age, int) or not 0 <= age <= 150:
        return ValidationResult().add_error("age", "Must be 0-150")
    return ValidationResult()


# Combine validators
def combine_validators(*validators: Callable) -> Callable:
    def combined(data: dict) -> ValidationResult:
        result = ValidationResult()
        for validator in validators:
            r = validator(data)
            if not r.is_valid:
                result = ValidationResult(
                    is_valid=False,
                    errors=result.errors + r.errors,
                )
        return result
    return combined


validate_user = combine_validators(
    validate_required,
    validate_email,
    validate_age,
)

# Test
valid = {"name": "สมชาย", "email": "somchai@email.com", "age": 30}
print(validate_user(valid))  # ValidationResult(is_valid=True, errors=[])

invalid = {"name": "", "email": "bad", "age": 200}
result = validate_user(invalid)
for error in result.errors:
    print(f"{error.field}: {error.message}")
```

**Composition กับ Async:**
```python
import asyncio
from typing import Callable, Awaitable, TypeVar

T = TypeVar("T")


def async_pipe(*functions: Callable[[T], Awaitable[T]]) -> Callable[[T], Awaitable[T]]:
    async def piped(value: T) -> T:
        result = value
        for func in functions:
            result = await func(result)
        return result
    return piped


async def fetch_data(url: str) -> dict:
    await asyncio.sleep(0.1)
    return {"url": url, "data": [1, 2, 3]}


async def filter_data(response: dict) -> dict:
    await asyncio.sleep(0.05)
    return {
        "url": response["url"],
        "data": [x for x in response["data"] if x > 1],
    }


async def enrich_data(response: dict) -> dict:
    await asyncio.sleep(0.05)
    return {**response, "enriched": True, "count": len(response["data"])}


# Compose async functions
process = async_pipe(fetch_data, filter_data, enrich_data)


async def main():
    result = await process("https://api.example.com")
    print(result)


# asyncio.run(main())
```

### 6.8.4 ข้อดี

- **Modular:** functions เล็ก ๆ
- **Reusable:** compose ใหม่ได้
- **Testable:** test แยกได้
- **Readable:** pipeline ชัดเจน
- **Functional:** declarative

### 6.8.5 ข้อเสีย

- **Debugging:** stack trace ซับซ้อน
- **Performance:** function call overhead
- **Type hints:** ท้าทาย
- **Over-abstraction:** สำหรับงานง่าย

### 6.8.6 ข้อควรระวัง

```python
# ระวัง 1: Type compatibility
# แต่ละ function ต้องรับ type ของ previous
# ❌
# pipe(len, str.upper)  # len returns int, upper expects str

# ✅ ตรวจสอบ types
from typing import TypeVar
A = TypeVar("A")
B = TypeVar("B")
C = TypeVar("C")

def compose(f: Callable[[B], C], g: Callable[[A], B]) -> Callable[[A], C]:
    def composed(x: A) -> C:
        return f(g(x))
    return composed

# ระวัง 2: Function signature ต่างกัน
# ถ้า functions รับ args ต่างกัน → ใช้ partial

# ระวัง 3: Side effects
# Composition ควรใช้ pure functions
# ถ้ามี side effects ลำดับสำคัญ

# ระวัง 4: Empty compose
def compose(*fns):
    if not fns:
        return lambda x: x  # identity
    return ...

# ระวัง 5: Debugging
# แทน pipe สำหรับ complex pipelines
from typing import Callable

def trace(name: str) -> Callable:
    def trace_step(value):
        print(f"{name}: {value}")
        return value
    return trace_step

# ใช้
pipeline = pipe(
    trace("input"),
    normalize,
    trace("after normalize"),
    remove_punctuation,
    trace("after punctuation"),
)
```

### 6.8.7 สรุป

**Function Composition:**
- รวม functions เล็กเป็นใหญ่
- `compose` (right-to-left)
- `pipe` (left-to-right)

**ใช้เมื่อ:**
- Data pipelines
- Multiple transformations
- Functional style
- Middleware

**Best practices:**
- Pure functions
- Type hints
- Small functions
- `pipe` อ่านง่ายกว่า
- Trace สำหรับ debug

> **อ้างอิงเพิ่มเติม:** [Function Composition](https://en.wikipedia.org/wiki/Function_composition_(computer_science))

---

## 6.9 Immutability

### บทนำ

Immutability คือการที่ข้อมูลไม่สามารถเปลี่ยนแปลงได้หลังสร้าง เป็นหลักการสำคัญของ Functional Programming ช่วยลด bugs และทำให้โค้ดง่ายต่อการเข้าใจ

### นิยาม

Immutable object คือ object ที่ state ไม่เปลี่ยนหลังสร้าง ทุก "modification" สร้าง object ใหม่

### 6.9.1 คืออะไร

**Python built-in immutables:**
- `int`, `float`, `complex`
- `str`, `bytes`
- `tuple`
- `frozenset`
- `bool`, `None`

**Mutables:**
- `list`, `dict`, `set`
- `bytearray`
- Custom classes

### 6.9.2 ทำงานอย่างไร

Immutable objects:
- สามารถ hash ได้
- ใช้เป็น dict key ได้
- Thread-safe
- Cache ได้
- เปรียบเทียบเร็ว

### 6.9.3 การใช้งาน

**Tuple แทน List:**
```python
# ❌ Mutable
def process_bad(items: list[int]) -> list[int]:
    items.append(999)  # side effect!
    return items

data = [1, 2, 3]
process_bad(data)
print(data)  # [1, 2, 3, 999]

# ✅ Immutable
def process_good(items: tuple[int, ...]) -> tuple[int, ...]:
    return items + (999,)

data = (1, 2, 3)
result = process_good(data)
print(data)    # (1, 2, 3) — ไม่เปลี่ยน
print(result)  # (1, 2, 3, 999)
```

**Frozen Dataclass:**
```python
from dataclasses import dataclass

@dataclass(frozen=True)
class Point:
    x: float
    y: float

    def translate(self, dx: float, dy: float) -> "Point":
        """Returns new Point — ไม่แก้เดิม"""
        return Point(self.x + dx, self.y + dy)

    def scale(self, factor: float) -> "Point":
        return Point(self.x * factor, self.y * factor)


p1 = Point(1, 2)
p2 = p1.translate(3, 4)
print(p1)  # Point(x=1, y=2)
print(p2)  # Point(x=4, y=6)

# ✅ Hashable
locations = {p1: "origin"}
print(locations[p1])

# ❌ ไม่สามารถแก้
# p1.x = 10  # FrozenInstanceError
```

**Frozen Set:**
```python
# ❌ Set เป็น mutable
tags = {"python", "code"}
# ใช้เป็น dict key ไม่ได้

# ✅ frozenset
tags_frozen = frozenset(["python", "code"])
d = {tags_frozen: "value"}

# ใช้ใน nested structures
data = {
    frozenset(["a", "b"]): 1,
    frozenset(["c", "d"]): 2,
}
```

**Immutable Updates:**
```python
# Lists → tuples
old_list = [1, 2, 3]
new_tuple = tuple(old_list) + (4,)

# Dicts → new dict
old_dict = {"a": 1, "b": 2}
new_dict = {**old_dict, "c": 3}

# Nested updates (ต้อง manual)
old_data = {"user": {"name": "Alice", "age": 30}}
new_data = {
    **old_data,
    "user": {**old_data["user"], "age": 31},
}
print(old_data["user"]["age"])  # 30 (ไม่เปลี่ยน)
print(new_data["user"]["age"])  # 31
```

**`dataclasses.replace`:**
```python
from dataclasses import dataclass, replace

@dataclass(frozen=True)
class User:
    name: str
    email: str
    age: int


user = User("Alice", "alice@email.com", 30)

# สร้างใหม่โดยเปลี่ยนบาง field
updated = replace(user, age=31)
print(user)     # User(name='Alice', email='alice@email.com', age=30)
print(updated)  # User(name='Alice', email='alice@email.com', age=31)
```

**ตัวอย่างการใช้งานจริง — Immutable State:**
```python
from dataclasses import dataclass, field, replace
from typing import Optional

@dataclass(frozen=True)
class Todo:
    id: int
    title: str
    done: bool = False

    def complete(self) -> "Todo":
        return replace(self, done=True)

    def rename(self, new_title: str) -> "Todo":
        return replace(self, title=new_title)


@dataclass(frozen=True)
class TodoList:
    todos: tuple[Todo, ...] = ()
    _next_id: int = 1

    def add(self, title: str) -> "TodoList":
        todo = Todo(id=self._next_id, title=title)
        return TodoList(
            todos=self.todos + (todo,),
            _next_id=self._next_id + 1,
        )

    def complete(self, todo_id: int) -> "TodoList":
        new_todos = tuple(
            t.complete() if t.id == todo_id else t
            for t in self.todos
        )
        return replace(self, todos=new_todos)

    def remove(self, todo_id: int) -> "TodoList":
        new_todos = tuple(t for t in self.todos if t.id != todo_id)
        return replace(self, todos=new_todos)

    def active(self) -> tuple[Todo, ...]:
        return tuple(t for t in self.todos if not t.done)


# ใช้งาน — แต่ละ operation สร้าง list ใหม่
todo_list = TodoList()
todo_list = todo_list.add("Learn Python")
todo_list = todo_list.add("Write code")
todo_list = todo_list.add("Test")

print(f"Total: {len(todo_list.todos)}")      # 3
print(f"Active: {len(todo_list.active())}")  # 3

todo_list = todo_list.complete(1)
print(f"Active: {len(todo_list.active())}")  # 2

todo_list = todo_list.remove(2)
print(f"Total: {len(todo_list.todos)}")      # 2
```

**ตัวอย่าง — Event Sourcing:**
```python
from dataclasses import dataclass
from typing import Union
from datetime import datetime

@dataclass(frozen=True)
class AccountOpened:
    account_id: str
    initial_balance: float
    timestamp: datetime

@dataclass(frozen=True)
class MoneyDeposited:
    account_id: str
    amount: float
    timestamp: datetime

@dataclass(frozen=True)
class MoneyWithdrawn:
    account_id: str
    amount: float
    timestamp: datetime

Event = Union[AccountOpened, MoneyDeposited, MoneyWithdrawn]


@dataclass(frozen=True)
class AccountState:
    account_id: str
    balance: float
    is_open: bool


def apply_event(state: AccountState | None, event: Event) -> AccountState:
    """Apply event → new state (immutable)"""
    if isinstance(event, AccountOpened):
        return AccountState(
            account_id=event.account_id,
            balance=event.initial_balance,
            is_open=True,
        )

    if state is None:
        raise ValueError("Account not opened")

    if isinstance(event, MoneyDeposited):
        return AccountState(
            account_id=state.account_id,
            balance=state.balance + event.amount,
            is_open=state.is_open,
        )

    if isinstance(event, MoneyWithdrawn):
        if event.amount > state.balance:
            raise ValueError("Insufficient funds")
        return AccountState(
            account_id=state.account_id,
            balance=state.balance - event.amount,
            is_open=state.is_open,
        )

    raise ValueError(f"Unknown event: {event}")


# Rebuild state from events
events = [
    AccountOpened("ACC-001", 1000.0, datetime.now()),
    MoneyDeposited("ACC-001", 500.0, datetime.now()),
    MoneyWithdrawn("ACC-001", 200.0, datetime.now()),
    MoneyDeposited("ACC-001", 100.0, datetime.now()),
]

state = None
for event in events:
    state = apply_event(state, event)

print(state)
# AccountState(account_id='ACC-001', balance=1400.0, is_open=True)
```

**Performance Considerations:**
```python
# Immutable updates สำหรับ lists ใหญ่ อาจช้า
import time

def update_list_mutable(items: list[int], index: int, value: int) -> list[int]:
    items[index] = value
    return items

def update_list_immutable(items: tuple[int, ...], index: int, value: int) -> tuple:
    return items[:index] + (value,) + items[index + 1:]

data = tuple(range(100000))
data_list = list(range(100000))

# Benchmark
start = time.time()
for _ in range(1000):
    data_list_copy = data_list.copy()
    update_list_mutable(data_list_copy, 0, 999)
mutable_time = time.time() - start

start = time.time()
for _ in range(1000):
    update_list_immutable(data, 0, 999)
immutable_time = time.time() - start

print(f"Mutable: {mutable_time:.4f}s")
print(f"Immutable: {immutable_time:.4f}s")
# Immutable ช้ากว่ามาก!

# ✅ ใช้ persistent data structures หรือ list ในกรณีนี้
```

### 6.9.4 ข้อดี

- **Predictable:** ไม่เปลี่ยนโดยไม่ตั้งใจ
- **Thread-safe:** concurrent โดยไม่ต้อง lock
- **Hashable:** ใช้เป็น key
- **Cacheable:** memoization ได้
- **Debuggable:** ง่ายกว่า

### 6.9.5 ข้อเสีย

- **Performance:** การ copy มี cost
- **Memory:** สร้าง objects ใหม่
- **Verbose:** syntax ยาว
- **Learning curve:** ต้องเปลี่ยน mindset

### 6.9.6 ข้อควรระวัง

```python
# ระวัง 1: "Immutable" อาจ leak
@dataclass(frozen=True)
class Container:
    items: list[int]  # ❌ list ยัง mutable

c = Container([1, 2, 3])
c.items.append(4)  # ✅ ทำได้!
print(c.items)  # [1, 2, 3, 4]

# ✅ ใช้ tuple
@dataclass(frozen=True)
class Container2:
    items: tuple[int, ...]

# ระวัง 2: Deep vs shallow immutability
@dataclass(frozen=True)
class User:
    name: str
    tags: tuple[str, ...]  # immutable ✓

@dataclass(frozen=True)
class UserBad:
    name: str
    tags: list[str]  # ⚠️ mutable ข้างใน

# ระวัง 3: Performance
# Immutable updates สำหรับ large collections ช้า

# ระวัง 4: Hidden mutations
def process(items: tuple) -> tuple:
    # items += (1,)  # ✅ สร้างใหม่
    # items.append(1)  # ❌ tuple ไม่มี append
    return items

# ระวัง 5: Equality vs identity
t1 = (1, 2, 3)
t2 = (1, 2, 3)
print(t1 == t2)  # True
print(t1 is t2)  # อาจ True (interning) หรือ False

# ระวัง 6: String intern
s1 = "hello"
s2 = "hello"
print(s1 is s2)  # True (interned)
```

### 6.9.7 สรุป

**ใช้ Immutability เมื่อ:**
- Value objects
- Configuration
- State management
- Concurrent code
- Caching

**Tools:**
- `tuple` แทน `list`
- `frozenset` แทน `set`
- `@dataclass(frozen=True)`
- `dataclasses.replace()`
- `MappingProxyType`

**Python built-in immutables:**
- int, float, str, bytes
- tuple, frozenset
- bool, None

**Best practices:**
- Value objects immutable
- ระวัง nested mutables
- Performance-aware
- Type hints

> **อ้างอิงเพิ่มเติม:** [Immutable Objects](https://docs.python.org/3/reference/datamodel.html)

---

## 6.10 Iterator และ Generator แบบฟังก์ชัน

### บทนำ

Iterator และ Generator เป็นพื้นฐานของ lazy evaluation ใน Python ทำงานร่วมกับ functional programming ได้อย่างมีประสิทธิภาพ

### นิยาม

- **Iterator:** object ที่ implement `__iter__` และ `__next__`
- **Generator:** function ที่ใช้ `yield` — สร้าง iterator อัตโนมัติ

### 6.10.1 คืออะไร

Generators เป็น lazy:
- ไม่คำนวณจนกว่าจะต้องการ
- ประหยัด memory
- ใช้กับ infinite sequences

### 6.10.2 ทำงานอย่างไร

Generators suspend ที่ `yield` และ resume เมื่อเรียก `next()` ใช้ stack frame

### 6.10.3 การใช้งาน

**Generator พื้นฐาน:**
```python
def count_up(n: int):
    """Generate 0 ถึง n-1"""
    i = 0
    while i < n:
        yield i
        i += 1


for x in count_up(5):
    print(x, end=" ")  # 0 1 2 3 4

# Generator object
gen = count_up(3)
print(next(gen))  # 0
print(next(gen))  # 1
print(next(gen))  # 2
# next(gen)  # StopIteration
```

**Infinite Generators:**
```python
def fibonacci():
    """Infinite Fibonacci"""
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b


fib = fibonacci()
for _ in range(10):
    print(next(fib), end=" ")
# 0 1 1 2 3 5 8 13 21 34


# ใช้ islice จำกัด
from itertools import islice

first_10 = list(islice(fibonacci(), 10))
print(first_10)
```

**Generator Expression:**
```python
# Generator expression — lazy
squares = (x ** 2 for x in range(1_000_000))

# ใช้ memory น้อย
print(next(squares))  # 0
print(next(squares))  # 1

# Sum of squares ของเลขคู่ 1-100
total = sum(x ** 2 for x in range(1, 101) if x % 2 == 0)
print(total)  # 171700
```

**Pipeline ของ Generators:**
```python
def read_lines(text: str):
    """Yield lines"""
    for line in text.split("\n"):
        yield line


def strip_lines(lines):
    for line in lines:
        yield line.strip()


def skip_empty(lines):
    for line in lines:
        if line:
            yield line


def parse_csv(lines):
    for line in lines:
        yield line.split(",")


# Pipeline — lazy processing
text = """
name,age,city
Alice,30,NYC

Bob,25,LA
Charlie,35,SF

"""

pipeline = parse_csv(
    skip_empty(
        strip_lines(
            read_lines(text)
        )
    )
)

for row in pipeline:
    print(row)
# ['name', 'age', 'city']
# ['Alice', '30', 'NYC']
# ['Bob', '25', 'LA']
# ['Charlie', '35', 'SF']
```

**yield from:**
```python
def chain(*iterables):
    """Chain multiple iterables"""
    for iterable in iterables:
        yield from iterable


result = list(chain([1, 2], [3, 4], [5, 6]))
print(result)  # [1, 2, 3, 4, 5, 6]

# Recursive generator
def flatten(nested):
    for item in nested:
        if isinstance(item, (list, tuple)):
            yield from flatten(item)
        else:
            yield item


data = [1, [2, 3], [4, [5, 6]], 7]
print(list(flatten(data)))  # [1, 2, 3, 4, 5, 6, 7]
```

**Generator กับ send():**
```python
def accumulator():
    """Coroutine-style generator"""
    total = 0
    while True:
        value = yield total
        if value is None:
            break
        total += value


acc = accumulator()
next(acc)  # เริ่ม
print(acc.send(10))  # 10
print(acc.send(20))  # 30
print(acc.send(5))   # 35
```

**ตัวอย่างการใช้งานจริง — Streaming Data:**
```python
from typing import Iterator, Any
from dataclasses import dataclass
import json

@dataclass
class Record:
    id: int
    name: str
    value: float


def stream_records(file_path: str) -> Iterator[Record]:
    """อ่าน JSON Lines ทีละบรรทัด — ประหยัด memory"""
    with open(file_path, encoding="utf-8") as f:
        for line in f:
            data = json.loads(line)
            yield Record(
                id=data["id"],
                name=data["name"],
                value=data["value"],
            )


def filter_by_value(
    records: Iterator[Record],
    min_value: float,
) -> Iterator[Record]:
    for record in records:
        if record.value >= min_value:
            yield record


def transform_values(
    records: Iterator[Record],
    factor: float,
) -> Iterator[Record]:
    for record in records:
        yield Record(
            id=record.id,
            name=record.name,
            value=record.value * factor,
        )


def take(n: int, records: Iterator) -> Iterator:
    """เอา n records"""
    for i, record in enumerate(records):
        if i >= n:
            break
        yield record


def count(records: Iterator) -> int:
    return sum(1 for _ in records)


# ใช้ pipeline — ไม่โหลดทั้งไฟล์
# pipeline = take(
#     10,
#     transform_values(
#         filter_by_value(
#             stream_records("data.jsonl"),
#             100.0,
#         ),
#         factor=1.1,
#     ),
# )
# for record in pipeline:
#     print(record)
```

**ตัวอย่าง — Batch Processing:**
```python
from itertools import islice
from typing import Iterator, TypeVar, Iterable

T = TypeVar("T")


def batch(iterable: Iterable[T], size: int) -> Iterator[list[T]]:
    """แบ่ง iterable เป็น batches"""
    iterator = iter(iterable)
    while True:
        chunk = list(islice(iterator, size))
        if not chunk:
            break
        yield chunk


# ใช้งาน — ส่งข้อมูลเป็น batches
def process_batch(items: list[int]) -> int:
    return sum(items)


data = range(1, 21)
total = 0
for i, chunk in enumerate(batch(data, 5)):
    batch_total = process_batch(chunk)
    total += batch_total
    print(f"Batch {i}: {chunk} → {batch_total}")

print(f"Total: {total}")
```

**ตัวอย่าง — Cycle และ Group:**
```python
from itertools import cycle, islice, groupby
from collections import defaultdict

# Cycle — วนซ้ำ
colors = cycle(["red", "green", "blue"])
for _ in range(7):
    print(next(colors), end=" ")
# red green blue red green blue red

# Groupby
data = [
    ("fruit", "apple"),
    ("fruit", "banana"),
    ("vegetable", "carrot"),
    ("fruit", "cherry"),
    ("vegetable", "broccoli"),
]

# ต้อง sort ก่อน
data.sort()
for category, items in groupby(data, key=lambda x: x[0]):
    print(f"{category}: {list(items)}")

# Group with dict (ไม่ต้อง sort)
grouped = defaultdict(list)
for category, item in data:
    grouped[category].append(item)
print(dict(grouped))
```

**ตัวอย่าง — Async Generators:**
```python
import asyncio
from typing import AsyncIterator

async def fetch_page(page: int) -> list[dict]:
    await asyncio.sleep(0.1)
    return [{"id": i, "page": page} for i in range(page * 10, (page + 1) * 10)]


async def paginated_fetch(total_pages: int) -> AsyncIterator[dict]:
    """Async generator สำหรับ pagination"""
    for page in range(1, total_pages + 1):
        items = await fetch_page(page)
        for item in items:
            yield item


async def main():
    async for item in paginated_fetch(3):
        print(item)


# asyncio.run(main())
```

### 6.10.4 ข้อดี

- **Memory efficient:** lazy
- **Composable:** pipeline
- **Infinite:** สร้าง sequences ไม่รู้จบ
- **Clean:** syntax อ่านง่าย

### 6.10.5 ข้อเสีย

- **One-time:** ใช้ได้ครั้งเดียว
- **Debugging:** harder
- **Cannot pickle:** ส่งข้าม process ยาก

### 6.10.6 ข้อควรระวัง

```python
# ระวัง 1: Generators ใช้ได้ครั้งเดียว
gen = (x for x in range(5))
print(list(gen))  # [0, 1, 2, 3, 4]
print(list(gen))  # [] — หมดแล้ว

# ระวัง 2: ลำดับการ execute
def gen():
    print("Start")
    yield 1
    print("Middle")
    yield 2
    print("End")

g = gen()
print("Created")
print(next(g))  # Start, 1
print(next(g))  # Middle, 2

# ระวัง 3: finally ใน generator
def with_cleanup():
    try:
        yield 1
        yield 2
    finally:
        print("Cleanup")

g = with_cleanup()
print(next(g))  # 1
# ถ้าไม่ exhaust — finally ไม่เรียก
del g  # ถึงตอนนี้ finally เรียก

# ระวัง 4: Exception handling
def safe_gen():
    try:
        yield 1
        yield 2
    except GeneratorExit:
        print("Closed")
        raise

# ระวัง 5: Side effects
def bad_gen():
    for i in range(3):
        print(f"Side effect {i}")  # เกิดเมื่อ iterate เท่านั้น
        yield i

# ยังไม่ print
g = bad_gen()
# print เมื่อ iterate
for x in g:
    print(x)

# ระวัง 6: Nested generators ซับซ้อน
# ใช้ async generators สำหรับ async pipelines
```

### 6.10.7 สรุป

**Iterator:**
- Object ที่มี `__iter__` และ `__next__`
- Protocol สำหรับ iteration

**Generator:**
- Function ที่มี `yield`
- สร้าง iterator อัตโนมัติ
- Lazy evaluation

**ใช้เมื่อ:**
- ข้อมูลขนาดใหญ่
- Pipelines
- Infinite sequences
- Streaming

**Best practices:**
- Generator pipelines
- `yield from` สำหรับ delegate
- ระวัง one-time consumption
- Async generators สำหรับ I/O
- `itertools` สำหรับ common patterns

> **อ้างอิงเพิ่มเติม:** [Generators](https://docs.python.org/3/tutorial/classes.html#generators), [itertools Documentation](https://docs.python.org/3/library/itertools.html)

---

## 6.11 Functional Programming กับงานจริง

### บทนำ

Functional Programming ไม่ใช่แค่ทฤษฎี — ใช้ได้จริงในงาน production โดยเฉพาะ data processing, pipelines และ distributed systems

### นิยาม

Functional Programming in Practice คือการใช้ functional concepts (pure functions, immutability, composition) ในโค้ดจริง โดยไม่ต้อง 100% functional

### 6.11.1 คืออะไร

**Python เป็น multi-paradigm:**
- ผสม OOP + FP
- ใช้ FP ที่เหมาะสม
- ไม่ต้องบังคับ

### 6.11.2 ทำงานอย่างไร

**Functional Core, Imperative Shell:**
- Pure functions สำหรับ business logic
- Side effects ที่ boundaries (I/O)

### 6.11.3 การใช้งาน

**Example 1: Data Processing Pipeline:**
```python
from dataclasses import dataclass, replace
from typing import Iterable
from datetime import datetime
from decimal import Decimal

@dataclass(frozen=True)
class Transaction:
    id: str
    user_id: str
    amount: Decimal
    category: str
    date: datetime
    is_refunded: bool = False

    def refund(self) -> "Transaction":
        return replace(self, is_refunded=True)


@dataclass(frozen=True)
class Summary:
    user_id: str
    total: Decimal
    count: int
    categories: dict[str, Decimal]


# Pure functions
def filter_valid(transactions: Iterable[Transaction]) -> list[Transaction]:
    """เอาเฉพาะ transactions ที่ไม่ refund"""
    return [t for t in transactions if not t.is_refunded]


def filter_by_date(
    transactions: Iterable[Transaction],
    start: datetime,
    end: datetime,
) -> list[Transaction]:
    return [t for t in transactions if start <= t.date <= end]


def group_by_user(
    transactions: Iterable[Transaction],
) -> dict[str, list[Transaction]]:
    result: dict[str, list[Transaction]] = {}
    for t in transactions:
        result.setdefault(t.user_id, []).append(t)
    return result


def summarize(user_id: str, transactions: list[Transaction]) -> Summary:
    total = sum(t.amount for t in transactions)
    categories: dict[str, Decimal] = {}
    for t in transactions:
        categories[t.category] = categories.get(t.category, Decimal(0)) + t.amount

    return Summary(
        user_id=user_id,
        total=total,
        count=len(transactions),
        categories=categories,
    )


def summarize_all(
    transactions: Iterable[Transaction],
) -> list[Summary]:
    """Compose functions"""
    valid = filter_valid(transactions)
    grouped = group_by_user(valid)
    return [summarize(uid, txs) for uid, txs in grouped.items()]


# ใช้งาน
transactions = [
    Transaction("T1", "U1", Decimal("100"), "food", datetime(2024, 1, 1)),
    Transaction("T2", "U1", Decimal("50"), "transport", datetime(2024, 1, 2)),
    Transaction("T3", "U2", Decimal("200"), "food", datetime(2024, 1, 3)),
    Transaction("T4", "U1", Decimal("75"), "food", datetime(2024, 1, 4), is_refunded=True),
    Transaction("T5", "U2", Decimal("300"), "shopping", datetime(2024, 1, 5)),
]

summaries = summarize_all(transactions)
for s in summaries:
    print(f"User {s.user_id}: ฿{s.total}, {s.count} transactions")
```

**Example 2: Retry Logic:**
```python
from typing import Callable, TypeVar, Optional
from dataclasses import dataclass
import time
import random

T = TypeVar("T")


@dataclass(frozen=True)
class RetryResult:
    success: bool
    value: Optional[T] = None
    error: Optional[Exception] = None
    attempts: int = 0


def retry_pure(
    operation: Callable[[], T],
    max_attempts: int = 3,
    delay_fn: Callable[[int], float] = lambda n: 0,
    should_retry: Callable[[Exception], bool] = lambda e: True,
    sleep: Callable[[float], None] = time.sleep,
) -> RetryResult:
    """Pure-ish retry — inject sleep for testability"""
    last_error: Optional[Exception] = None

    for attempt in range(1, max_attempts + 1):
        try:
            value = operation()
            return RetryResult(success=True, value=value, attempts=attempt)
        except Exception as e:
            last_error = e
            if not should_retry(e):
                break
            if attempt < max_attempts:
                sleep(delay_fn(attempt))

    return RetryResult(
        success=False,
        error=last_error,
        attempts=max_attempts,
    )


# ใช้งาน
def exponential_backoff(attempt: int) -> float:
    return 2 ** attempt * 0.1


def flaky_call() -> str:
    if random.random() < 0.7:
        raise ConnectionError("Failed")
    return "Success"


result = retry_pure(
    flaky_call,
    max_attempts=5,
    delay_fn=exponential_backoff,
)

if result.success:
    print(f"Success after {result.attempts} attempts: {result.value}")
else:
    print(f"Failed after {result.attempts}: {result.error}")
```

**Example 3: Configuration Management:**
```python
from dataclasses import dataclass, replace, field
from typing import Callable, Any
from pathlib import Path
import json
import os

@dataclass(frozen=True)
class Config:
    host: str = "localhost"
    port: int = 8000
    debug: bool = False
    database_url: str = ""
    api_keys: tuple[tuple[str, str], ...] = ()  # frozen

    def with_overrides(self, **kwargs) -> "Config":
        """Return new config"""
        return replace(self, **kwargs)

    def get_api_key(self, name: str) -> str | None:
        for key_name, value in self.api_keys:
            if key_name == name:
                return value
        return None


# Pure transformation functions
def load_json(path: str) -> dict:
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def load_env(prefix: str = "APP_") -> dict:
    result = {}
    for key, value in os.environ.items():
        if key.startswith(prefix):
            config_key = key[len(prefix):].lower()
            result[config_key] = value
    return result


def parse_bool(value: Any) -> bool:
    if isinstance(value, bool):
        return value
    return str(value).lower() in ("true", "1", "yes")


def normalize(data: dict) -> dict:
    """Pure normalization"""
    result = data.copy()
    if "port" in result:
        result["port"] = int(result["port"])
    if "debug" in result:
        result["debug"] = parse_bool(result["debug"])
    if "api_keys" in result and isinstance(result["api_keys"], dict):
        result["api_keys"] = tuple(result["api_keys"].items())
    return result


def create_config(
    loaders: list[Callable[[], dict]],
) -> Config:
    """Compose loaders"""
    merged: dict = {}
    for loader in loaders:
        merged.update(loader())
    return Config(**normalize(merged))


# ใช้งาน
config = create_config([
    lambda: {"host": "localhost", "port": "8080"},  # defaults
    lambda: load_env("APP_"),                         # env
    lambda: {"debug": True},                          # overrides
])

print(config)
# Config(host='localhost', port=8080, debug=True, ...)

# Update — immutable
new_config = config.with_overrides(port=9000)
print(config.port)      # 8080
print(new_config.port)  # 9000
```

**Example 4: Event Processing:**
```python
from dataclasses import dataclass, field
from datetime import datetime
from typing import Union, Callable
from functools import reduce

@dataclass(frozen=True)
class UserCreated:
    user_id: str
    email: str
    timestamp: datetime

@dataclass(frozen=True)
class UserUpdated:
    user_id: str
    field: str
    new_value: str
    timestamp: datetime

@dataclass(frozen=True)
class UserDeleted:
    user_id: str
    timestamp: datetime

Event = Union[UserCreated, UserUpdated, UserDeleted]


@dataclass(frozen=True)
class User:
    user_id: str
    email: str
    name: str = ""
    is_deleted: bool = False


@dataclass(frozen=True)
class UserStore:
    users: dict[str, User] = field(default_factory=dict)

    def with_event(self, event: Event) -> "UserStore":
        """Apply event → new store"""
        if isinstance(event, UserCreated):
            new_user = User(user_id=event.user_id, email=event.email)
            return UserStore({**self.users, event.user_id: new_user})

        if isinstance(event, UserUpdated):
            if event.user_id not in self.users:
                return self
            old = self.users[event.user_id]
            new_user = User(
                user_id=old.user_id,
                email=event.new_value if event.field == "email" else old.email,
                name=event.new_value if event.field == "name" else old.name,
                is_deleted=old.is_deleted,
            )
            return UserStore({**self.users, event.user_id: new_user})

        if isinstance(event, UserDeleted):
            if event.user_id not in self.users:
                return self
            old = self.users[event.user_id]
            new_user = User(
                user_id=old.user_id,
                email=old.email,
                name=old.name,
                is_deleted=True,
            )
            return UserStore({**self.users, event.user_id: new_user})

        return self


def apply_events(events: list[Event]) -> UserStore:
    """Reduce events → state"""
    return reduce(lambda store, event: store.with_event(event), events, UserStore())


# ใช้งาน
events = [
    UserCreated("U1", "alice@email.com", datetime.now()),
    UserCreated("U2", "bob@email.com", datetime.now()),
    UserUpdated("U1", "name", "Alice", datetime.now()),
    UserDeleted("U2", datetime.now()),
]

store = apply_events(events)
for user in store.users.values():
    print(user)
```

**Example 5: Validation DSL:**
```python
from dataclasses import dataclass
from typing import Callable, Any, Generic, TypeVar

T = TypeVar("T")


@dataclass(frozen=True)
class ValidationError:
    field: str
    message: str


@dataclass(frozen=True)
class Validated(Generic[T]):
    value: T | None
    errors: tuple[ValidationError, ...] = ()

    @property
    def is_valid(self) -> bool:
        return len(self.errors) == 0

    def map(self, func: Callable[[T], Any]) -> "Validated":
        if not self.is_valid:
            return self
        return Validated(value=func(self.value))  # type: ignore

    def flat_map(self, func: Callable[[T], "Validated"]) -> "Validated":
        if not self.is_valid:
            return self
        return func(self.value)  # type: ignore

    def combine(self, other: "Validated") -> "Validated":
        return Validated(
            value=self.value if self.is_valid else other.value,
            errors=self.errors + other.errors,
        )


# Validators
def required(field: str, value: Any) -> Validated:
    if not value:
        return Validated(None, (ValidationError(field, "Required"),))
    return Validated(value)


def min_length(field: str, value: str, min_len: int) -> Validated:
    if len(value) < min_len:
        return Validated(None, (ValidationError(
            field,
            f"Min {min_len} chars",
        ),))
    return Validated(value)


def matches(field: str, value: str, pattern: str) -> Validated:
    import re
    if not re.match(pattern, value):
        return Validated(None, (ValidationError(field, f"Must match {pattern}"),))
    return Validated(value)


def combine(*results: Validated) -> Validated:
    return reduce(
        lambda acc, r: acc.combine(r),
        results[1:],
        results[0],
    )


# Schema
def validate_user(data: dict) -> Validated:
    email_result = combine(
        required("email", data.get("email")),
        min_length("email", data.get("email", ""), 5),
        matches("email", data.get("email", ""), r"^[\w.+-]+@[\w-]+\.[\w.]+$"),
    )

    name_result = combine(
        required("name", data.get("name")),
        min_length("name", data.get("name", ""), 2),
    )

    return Validated(
        value=data if email_result.is_valid and name_result.is_valid else None,
        errors=email_result.errors + name_result.errors,
    )


# ใช้งาน
result = validate_user({"email": "invalid", "name": ""})
print(result.is_valid)  # False
for error in result.errors:
    print(f"{error.field}: {error.message}")
```

**Example 6: Middleware Pipeline:**
```python
from typing import Callable, Awaitable, Any
from dataclasses import dataclass, field
from functools import reduce

@dataclass
class Request:
    method: str
    path: str
    headers: dict = field(default_factory=dict)
    body: Any = None

@dataclass
class Response:
    status: int
    body: Any = None


Middleware = Callable[[Request, Callable], Response]


def compose_middleware(*middlewares: Middleware) -> Middleware:
    """Compose middleware — first ใน list อยู่ outermost"""
    def composed(request: Request, handler: Callable) -> Response:
        def build_chain(index: int) -> Callable:
            if index >= len(middlewares):
                return handler

            current = middlewares[index]
            next_handler = build_chain(index + 1)
            return lambda req: current(req, next_handler)

        return build_chain(0)(request)

    return composed


# Middleware functions
def logging_middleware(req: Request, next_handler: Callable) -> Response:
    print(f"→ {req.method} {req.path}")
    response = next_handler(req)
    print(f"← {response.status}")
    return response


def auth_middleware(req: Request, next_handler: Callable) -> Response:
    if "Authorization" not in req.headers:
        return Response(status=401, body="Unauthorized")
    return next_handler(req)


def rate_limit_middleware(req: Request, next_handler: Callable) -> Response:
    # ตรวจสอบ rate limit
    return next_handler(req)


def actual_handler(req: Request) -> Response:
    return Response(status=200, body=f"Hello from {req.path}")


# Compose
app = compose_middleware(
    logging_middleware,
    auth_middleware,
    rate_limit_middleware,
)

# Test
request = Request(
    method="GET",
    path="/users",
    headers={"Authorization": "Bearer token"},
)

response = app(request, actual_handler)
print(f"Status: {response.status}, Body: {response.body}")
```

### 6.11.4 ข้อดี

- **Testable:** pure functions
- **Composable:** functions รวมกัน
- **Predictable:** immutable
- **Parallelizable:** thread-safe
- **Debuggable:** fewer side effects

### 6.11.5 ข้อเสีย

- **Performance:** immutability มี cost
- **Memory:** สร้าง objects เยอะ
- **Verbose:** บางอย่างยาวกว่า
- **I/O:** ต้องจัดการที่ boundaries

### 6.11.6 ข้อควรระวัง

```python
# ระวัง 1: Over-engineering
# ไม่ต้อง functional 100%
# ใช้เมื่อเหมาะสม

# ระวัง 2: Performance
# Immutable updates ช้า สำหรับ data ใหญ่
# ใช้ mutable ใน performance-critical

# ระวัง 3: ไม่ใช้ OOP — Python เป็น multi-paradigm
# ผสมได้: classes + functional methods

# ระวัง 4: I/O ที่ boundaries
# Pure core + imperative shell
def process_order(order: dict) -> dict:
    """Pure"""
    ...

def handle_request(request):
    """Impure — I/O"""
    order = parse(request.body)          # impure
    result = process_order(order)        # pure
    save(result)                          # impure
    return result

# ระวัง 5: ยาก debug ถ้า chain ยาว
# ใช้ trace functions

# ระวัง 6: Type hints ซับซ้อน
from typing import TypeVar, Callable
A = TypeVar("A")
B = TypeVar("B")
C = TypeVar("C")

def compose(
    f: Callable[[B], C],
    g: Callable[[A], B],
) -> Callable[[A], C]:
    return lambda x: f(g(x))
```

### 6.11.7 สรุป

**Functional Programming in Production:**

**ใช้:**
- Business logic (pure)
- Data pipelines
- Validation
- Event processing
- Configuration
- Middleware

**Patterns:**
- Pure core + imperative shell
- Immutable value objects
- Function composition
- Generator pipelines
- Reducers

**Best practices:**
- Pure functions สำหรับ logic
- I/O ที่ boundaries
- Immutable data structures
- Composition over inheritance
- Type hints
- Test-friendly

**Pythonic FP:**
- Comprehensions > map/filter
- Generators > manual iterators
- `dataclass(frozen=True)` > manual immutables
- `functools` module
- `itertools` module
- ผสมกับ OOP

> **อ้างอิงเพิ่มเติม:** [Functional Programming HOWTO](https://docs.python.org/3/howto/functional.html)

---

## สรุปภาค 6

ภาค 6 ครอบคลุม Functional Programming:

**พื้นฐาน:**
- Pure Functions — deterministic, no side effects
- First-Class Functions — functions เป็น values
- Higher-Order Functions — รับ/คืน functions

**Built-in Tools:**
- `lambda` — anonymous functions
- `map`, `filter`, `reduce`
- `functools`: `partial`, `wraps`, `reduce`, `lru_cache`

**Concepts:**
- Closure — functions ที่จำ environment
- Decorator — wrap functions
- Function Composition — `compose`, `pipe`
- Immutability — `tuple`, `frozenset`, `frozen=True`

**Generators:**
- `yield` — lazy evaluation
- Generator expressions
- Pipelines
- `yield from`
- Async generators

**Practical Application:**
- Functional core, imperative shell
- Data processing pipelines
- Validation
- Event sourcing
- Middleware
- Configuration

**ก้าวต่อไป:** เล่ม 3 จะเข้าสู่คุณภาพโค้ด การจัดการข้อผิดพลาด ไฟล์ และการทดสอบ

---

**อ้างอิงหลักของเล่ม 2:**

| แหล่งอ้างอิง | URL |
|-------------|-----|
| Python Data Structures | https://docs.python.org/3/tutorial/datastructures.html |
| Python Data Model | https://docs.python.org/3/reference/datamodel.html |
| Python Classes | https://docs.python.org/3/tutorial/classes.html |
| abc Module | https://docs.python.org/3/library/abc.html |
| typing Module | https://docs.python.org/3/library/typing.html |
| dataclasses | https://docs.python.org/3/library/dataclasses.html |
| functools | https://docs.python.org/3/library/functools.html |
| itertools | https://docs.python.org/3/library/itertools.html |
| Collections | https://docs.python.org/3/library/collections.html |
| Functional Programming HOWTO | https://docs.python.org/3/howto/functional.html |
| PEP 8 Style Guide | https://peps.python.org/pep-0008/ |
| PEP 484 Type Hints | https://peps.python.org/pep-0484/ |
| PEP 544 Protocols | https://peps.python.org/pep-0544/ |
| PEP 557 Dataclasses | https://peps.python.org/pep-0557/ |
| SOLID Principles | https://en.wikipedia.org/wiki/SOLID |
| Design Patterns | https://refactoring.guru/design-patterns |
| Big O Cheat Sheet | https://www.bigocheatsheet.com/ |

---
 