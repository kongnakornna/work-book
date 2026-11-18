# เล่ม 10: Python ขั้นสูง, Runtime, Internals และ Standard Library

## คำนำ

หนังสือเล่มนี้เป็นคู่มือภาคปฏิบัติสำหรับนักพัฒนา Python ที่ต้องการเข้าใจกลไกภายในของภาษา Python อย่างลึกซึ้ง ตั้งแต่ Metaprogramming, Descriptors, Metaclasses, Memory Management, CPython Internals, Bytecode, AST, ไปจนถึงทางเลือกในการรัน Python บนแพลตฟอร์มต่าง ๆ เช่น PyPy, GraalPy, MicroPython และ WebAssembly รวมถึง Standard Library ที่ควรรู้จักอย่างครบถ้วน เนื้อหาทุกหัวข้อมีตัวอย่างโค้ดที่พร้อมใช้งานและแหล่งอ้างอิงที่น่าเชื่อถือ

---

## ภาค 23: Python ขั้นสูงและภายในภาษา

### 23.1 Metaprogramming

Metaprogramming คือการเขียนโค้ดที่จัดการกับโค้ดด้วยกันเอง Python รองรับผ่าน Decorators, Descriptors, Metaclasses และ AST

**Metaprogramming คืออะไร**
Metaprogramming ช่วยให้โปรแกรมสามารถตรวจสอบ แก้ไข หรือสร้างโค้ดใหม่ได้ในขณะรันไทม์ ทำให้สามารถสร้าง abstraction ที่ทรงพลังและลด boilerplate code ได้

**การใช้งาน: Decorator ที่รับ argument**
```python
import functools
import time

def retry(max_attempts=3, delay=1.0):
    """Decorator สำหรับ retry function ที่ล้มเหลว"""
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(1, max_attempts + 1):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts:
                        raise
                    print(f"Attempt {attempt} failed: {e}. Retrying...")
                    time.sleep(delay)
        return wrapper
    return decorator

@retry(max_attempts=5, delay=0.5)
def unstable_network_call():
    import random
    if random.random() < 0.7:
        raise ConnectionError("Network error")
    return "Success!"
```

**ข้อดี**: ลด code ซ้ำซ้อน, เพิ่มความยืดหยุ่น
**ข้อเสีย**: อาจทำให้โค้ดอ่านยากขึ้น, debug ยาก
**ข้อควรระวัง**: ใช้ `functools.wraps` เสมอเพื่อรักษา metadata ของ function ต้นฉบับ

**อ้างอิง**: [Python Metaprogramming (2025)](https://www.sanmin.com.tw) 

---

### 23.2 Descriptor

Descriptor คือ protocol ที่กำหนดว่าการเข้าถึง attribute บน object จะทำงานอย่างไร ทุกอย่างใน Python ตั้งแต่ `@property`, `@classmethod`, `@staticmethod`, `functools.cached_property` ไปจนถึง bound methods และ ORM columns ล้วนใช้ descriptor protocol ทั้งสิ้น

**Descriptor Protocol ประกอบด้วย 4 methods**:

```python
class Descriptor:
    def __get__(self, instance, owner=None):
        """เรียกเมื่ออ่านค่า attribute"""
        ...
    def __set__(self, instance, value):
        """เรียกเมื่อกำหนดค่า attribute"""
        ...
    def __delete__(self, instance):
        """เรียกเมื่อลบ attribute"""
        ...
    def __set_name__(self, owner, name):
        """PEP 487: เรียนรู้ชื่อ attribute ของตัวเอง"""
        ...
```

**Non-data descriptor vs Data descriptor**:
- **Non-data descriptor**: defines only `__get__` (เช่น functions)
- **Data descriptor**: defines `__set__` and/or `__delete__` (เช่น `property`, `member_descriptor` จาก `__slots__`)

Data descriptors มี precedence เหนือ instance `__dict__`

**ตัวอย่าง: สร้าง Typed Descriptor**
```python
class TypedField:
    """Descriptor ที่บังคับชนิดข้อมูล"""
    def __init__(self, type_, default=None):
        self.type = type_
        self.default = default
        self.name = None

    def __set_name__(self, owner, name):
        self.name = name

    def __get__(self, instance, owner=None):
        if instance is None:
            return self
        return instance.__dict__.get(self.name, self.default)

    def __set__(self, instance, value):
        if not isinstance(value, self.type):
            raise TypeError(
                f"{self.name} must be {self.type.__name__}, "
                f"got {type(value).__name__}"
            )
        instance.__dict__[self.name] = value

class Person:
    name = TypedField(str)
    age = TypedField(int, default=0)

p = Person()
p.name = "Alice"   # OK
p.age = 30         # OK
# p.name = 123     # TypeError!
```

**อ้างอิง**: [Descriptor HowTo Guide](https://docs.python.org/3/howto/descriptor.html) 

---

### 23.3 Decorator ขั้นสูง

Decorator ขั้นสูง ได้แก่ class-based decorators, decorators ที่รับ arguments, และ decorators ที่ทำงานกับ methods

**Class-based Decorator ที่ implement descriptor protocol**:
```python
import functools

class CountCalls:
    """Decorator ที่นับจำนวนครั้งที่ function ถูกเรียก"""
    def __init__(self, func):
        functools.update_wrapper(self, func)
        self.func = func
        self.count = 0

    def __call__(self, *args, **kwargs):
        self.count += 1
        print(f"Call {self.count} of {self.func.__name__}")
        return self.func(*args, **kwargs)

    def __get__(self, instance, owner=None):
        """ต้อง implement descriptor protocol เมื่อ decorate methods"""
        if instance is None:
            return self
        return functools.partial(self.__call__, instance)

class Calculator:
    @CountCalls
    def add(self, a, b):
        return a + b

calc = Calculator()
print(calc.add(2, 3))  # Call 1 of add → 5
print(calc.add(4, 5))  # Call 2 of add → 9
```

เมื่อ decorate instance methods, class-based decorators ต้อง implement `__get__` เพื่อให้ descriptor protocol ทำงานถูกต้อง

---

### 23.4 Context Manager

Context Manager จัดการ resource อย่างปลอดภัยผ่าน `with` statement

```python
import contextlib
import time

@contextlib.contextmanager
def timer(label):
    """Context manager สำหรับวัดเวลา"""
    start = time.perf_counter()
    try:
        yield
    finally:
        elapsed = time.perf_counter() - start
        print(f"{label}: {elapsed:.4f}s")

with timer("Processing"):
    data = [i**2 for i in range(10**6)]
```

**Class-based Context Manager**:
```python
class DatabaseConnection:
    def __init__(self, dsn):
        self.dsn = dsn
        self.conn = None

    def __enter__(self):
        self.conn = connect(self.dsn)
        return self.conn

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.conn.close()
        if exc_type is not None:
            print(f"Error: {exc_val}")
        return False  # ไม่ suppress exception

with DatabaseConnection("postgresql://localhost/mydb") as conn:
    conn.execute("SELECT 1")
```

**อ้างอิง**: [Exploring Python's Standard Library: Hidden Gems](https://codesarray.com/view/Exploring-Python%e2%80%99s-Standard-Library:-Hidden-Gems) 

---

### 23.5 Generator ขั้นสูง

Generator คือ function ที่ใช้ `yield` เพื่อสร้างค่าทีละตัว ช่วยประหยัดหน่วยความจำ

```python
def fibonacci():
    """Infinite Fibonacci generator"""
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# ใช้ itertools.islice เพื่อจำกัดจำนวน
import itertools
fib = fibonacci()
first_10 = list(itertools.islice(fib, 10))
print(first_10)  # [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
```

**Generator Pipeline**:
```python
def read_lines(filepath):
    with open(filepath) as f:
        for line in f:
            yield line.strip()

def filter_comments(lines):
    for line in lines:
        if line and not line.startswith('#'):
            yield line

def parse_config(lines):
    for line in lines:
        key, _, value = line.partition('=')
        yield key.strip(), value.strip()

# Pipeline: อ่าน → กรอง → แปลง
lines = read_lines('config.ini')
filtered = filter_comments(lines)
config = dict(parse_config(filtered))
```

---

### 23.6 Coroutine

Coroutine คือ function ที่สามารถหยุดและกลับมาทำงานต่อได้ ใช้ `async`/`await` สำหรับ asynchronous programming

```python
import asyncio

async def fetch_data(url):
    """Coroutine สำหรับดึงข้อมูล"""
    print(f"Fetching {url}...")
    await asyncio.sleep(1)  # จำลอง I/O
    return f"Data from {url}"

async def main():
    # รัน coroutines พร้อมกัน
    results = await asyncio.gather(
        fetch_data("https://api.example.com/1"),
        fetch_data("https://api.example.com/2"),
        fetch_data("https://api.example.com/3"),
    )
    print(results)

asyncio.run(main())
```

**Async Generator**:
```python
async def async_range(n):
    """Async generator"""
    for i in range(n):
        await asyncio.sleep(0.1)
        yield i

async def main():
    async for value in async_range(5):
        print(value)

asyncio.run(main())
```

---

### 23.7 Async Generator

Async Generator รวม `async` และ `yield` เข้าด้วยกัน ใช้สำหรับ streaming data แบบ asynchronous

```python
import asyncio

async def stream_data(source):
    """จำลองการ stream ข้อมูลจาก source"""
    for i in range(10):
        await asyncio.sleep(0.2)
        yield f"{source}: chunk {i}"

async def process_stream():
    async for chunk in stream_data("sensor"):
        print(f"Processing {chunk}")

asyncio.run(process_stream())
```

---

### 23.8–23.13 Type System, typing, Generic, TypeVar, ParamSpec, Protocol

Python มี type system ที่รองรับ Generics, Protocols และ type hints

```python
from typing import TypeVar, Generic, Protocol, ParamSpec, Callable
from dataclasses import dataclass

T = TypeVar('T')
P = ParamSpec('P')

@dataclass
class Stack(Generic[T]):
    """Generic Stack"""
    items: list[T]

    def push(self, item: T) -> None:
        self.items.append(item)

    def pop(self) -> T:
        return self.items.pop()

# Protocol สำหรับ structural subtyping
class Drawable(Protocol):
    def draw(self) -> str:
        ...

def render(obj: Drawable) -> str:
    return obj.draw()

# ParamSpec สำหรับ decorator
def logged(func: Callable[P, T]) -> Callable[P, T]:
    def wrapper(*args: P.args, **kwargs: P.kwargs) -> T:
        print(f"Calling {func.__name__}")
        return func(*args, **kwargs)
    return wrapper
```

**อ้างอิง**: [Python typing documentation](https://docs.python.org/3/library/typing.html)

---

### 23.14–23.16 Dataclass, attrs, Pydantic

**Dataclass**:
```python
from dataclasses import dataclass, field

@dataclass(frozen=True)
class Point:
    x: float
    y: float
    tags: list[str] = field(default_factory=list)

p = Point(1.0, 2.0)
# p.x = 3.0  # FrozenInstanceError
```

**Pydantic** (validation):
```python
from pydantic import BaseModel, EmailStr, Field

class User(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    email: EmailStr
    age: int = Field(ge=0, le=130)

user = User(name="Alice", email="alice@example.com", age=30)
```

---

### 23.17 `__slots__`

`__slots__` ช่วยลดหน่วยความจำโดยป้องกันการสร้าง `__dict__` และกำหนด attributes ล่วงหน้า

```python
import sys

class WithDict:
    def __init__(self, x, y):
        self.x = x
        self.y = y

class WithSlots:
    __slots__ = ('x', 'y')
    def __init__(self, x, y):
        self.x = x
        self.y = y

obj_dict = WithDict(1, 2)
obj_slots = WithSlots(1, 2)

print(f"With __dict__: {sys.getsizeof(obj_dict.__dict__)} bytes")
# With __dict__: 104 bytes
print(f"With __slots__: {sys.getsizeof(obj_slots)} bytes")
# With __slots__: 48 bytes
```

**ข้อควรระวัง**: ไม่รองรับ multiple inheritance กับ non-slots classes และไม่สามารถเพิ่ม attribute ใหม่ได้

**อ้างอิง**: [Memory Management in Python (2025)](https://www.sanmin.com.tw) 

---

### 23.18–23.21 Memory Management, GC, Interning, C API

**Reference Counting**:
```python
import sys

x = [1, 2, 3]
print(sys.getrefcount(x))  # 2 (x + getrefcount argument)
y = x
print(sys.getrefcount(x))  # 3
del y
print(sys.getrefcount(x))  # 2
```

**Garbage Collection**:
```python
import gc

# ตรวจสอบสถานะ GC
print(gc.isenabled())  # True
print(gc.get_threshold())  # (700, 10, 10)

# ปิด/เปิด GC
gc.disable()
gc.enable()

# บังคับ collection
gc.collect()

# ดู objects ที่ยังมีชีวิต
objects = gc.get_objects()
print(f"Live objects: {len(objects)}")
```

**Weak References**:
```python
import weakref

class Node:
    def __init__(self, value):
        self.value = value
        self.next = None

# สร้าง weak reference
node1 = Node(1)
node2 = Node(2)
node1.next = node2
node2.next = weakref.ref(node1)  # ป้องกัน circular reference

# เมื่อไม่มี strong reference, object จะถูกเก็บ
ref = weakref.ref(node1)
del node1
print(ref())  # None
```

**String Interning**:
```python
import sys

a = "hello"
b = "hello"
print(a is b)  # True (interned)

# บังคับ interning
import sys
c = sys.intern("hello_world" * 100)
```

**อ้างอิง**: [Memory Management in Python (2025)](https://www.sanmin.com.tw) 

---

### 23.22–23.23 CPython Internals และ Python Implementation

**Compilation Pipeline ของ CPython**:

1. **Tokenizer**: แยก source code เป็น tokens
2. **Parser**: สร้าง Abstract Syntax Tree (AST)
3. **AST Optimization**: constant folding, unary expansion
4. **Symbol Table Generation**: วิเคราะห์ scope ของชื่อ
5. **Code Generation**: สร้าง bytecode เป็น `PyCodeObject`

**AST Optimization ตัวอย่าง**:
```python
import ast
import dis

code = """
a = 3 + 4
b = not True
c = [1, 2, 3]
"""

tree = ast.parse(code)

# ดู optimized AST
print(ast.dump(tree, indent=2))
# Constant folding: 3 + 4 → 7, not True → False

# Compile และดู bytecode
compiled = compile(code, '<string>', 'exec')
dis.dis(compiled)
```

**Bytecode Disassembly**:
```python
import dis

def greet(name):
    return f"Hello, {name}!"

dis.dis(greet)
# Output:
#   2           0 LOAD_CONST               1 ('Hello, ')
#               2 LOAD_FAST                0 (name)
#               4 FORMAT_VALUE             0
#               6 BUILD_STRING             2
#               8 RETURN_VALUE
```

**อ้างอิง**: [Bytecode Generation – DeepWiki](https://deepwiki.com/zpoint/CPython-Internals/8.3-bytecode-generation) ; [CPython Internals (2025)](https://www.sanmin.com.tw) 

---

### 23.24–23.27 PyPy, Jython, IronPython, MicroPython

| Interpreter | Implementation Language | Python Version | Key Feature | GIL-free |
|-------------|------------------------|----------------|-------------|----------|
| **CPython** | C | 3.13 | Official, full ecosystem | ❌ |
| **PyPy** | RPython | 3.10 | JIT, 4x faster for CPU-bound | ❌ (has STM) |
| **Jython** | Java | 2.7 (discontinued) | JVM integration | ✅ |
| **IronPython** | C# | 3.4 (community 3.6) | .NET integration | ✅ |
| **GraalPy** | Java/GraalVM | 3.11 | JIT + AOT, polyglot | ✅ |
| **MicroPython** | C | 3.4 subset | Ultra-lightweight, IoT | ✅ |



**การเลือกใช้**:
- **CPython**: default, ecosystem ครบ
- **PyPy**: CPU-bound workloads ที่ไม่มี C extensions
- **Jython**: Java integration (แต่ Python 2.7 เท่านั้น)
- **IronPython**: .NET integration
- **GraalPy**: cloud-native, polyglot
- **MicroPython**: embedded, IoT

**อ้างอิง**: [Python Interpreter Comparison 2025](https://blog.csdn.net/AlienProgrammer/article/details/149808858) 

---

### 23.28–23.29 AST และ Bytecode

**AST Manipulation**:
```python
import ast

class TypeAnnotationTransformer(ast.NodeTransformer):
    """เพิ่ม type annotations อัตโนมัติ"""
    def visit_FunctionDef(self, node):
        # เพิ่ม return type annotation
        if node.returns is None:
            node.returns = ast.Name(id='Any', ctx=ast.Load())
        return self.generic_visit(node)

code = """
def add(a, b):
    return a + b
"""

tree = ast.parse(code)
transformer = TypeAnnotationTransformer()
new_tree = transformer.visit(tree)
ast.fix_missing_locations(new_tree)

# แปลงกลับเป็น source code
print(ast.unparse(new_tree))
# def add(a, b) -> Any:
#     return a + b
```

**การใช้งาน `compile()` และ `exec()`**:
```python
code = compile("print('Hello from bytecode!')", '<string>', 'exec')
exec(code)
```

---

### 23.30–23.32 Import System ขั้นสูง, Packaging, Dynamic Import

**Dynamic Import ด้วย `importlib`**:
```python
import importlib

# Import module ตามชื่อ
module_name = "json"
json_module = importlib.import_module(module_name)
print(json_module.dumps({"key": "value"}))

# Reload module
importlib.reload(json_module)

# Import จาก file path
import importlib.util
spec = importlib.util.spec_from_file_location("mymodule", "/path/to/module.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
```

**Plugin System ด้วย `importlib`**:
```python
import importlib
import pkgutil

def load_plugins(package_name):
    """โหลด plugins ทั้งหมดจาก package"""
    package = importlib.import_module(package_name)
    plugins = {}
    for _, name, _ in pkgutil.iter_modules(package.__path__):
        full_name = f"{package_name}.{name}"
        plugins[name] = importlib.import_module(full_name)
    return plugins

plugins = load_plugins('myapp.plugins')
```

**อ้างอิง**: [Python importlib documentation](https://docs.python.org/3/library/importlib.html) 

---

### 23.33 Monkey Patching

Monkey Patching คือการแก้ไข module หรือ class ในขณะรันไทม์

```python
import datetime

# Monkey patch datetime.datetime
original_now = datetime.datetime.now

def mock_now(tz=None):
    """Mock function สำหรับ testing"""
    return datetime.datetime(2026, 1, 1, 0, 0, 0)

datetime.datetime.now = mock_now

# ทดสอบ
print(datetime.datetime.now())  # 2026-01-01 00:00:00

# คืนค่าเดิม
datetime.datetime.now = original_now
```

**ข้อควรระวัง**: ใช้เฉพาะใน testing เท่านั้น, อาจทำให้โค้ดคาดเดาได้ยาก

---

### 23.34–23.35 Metaclass และ MRO

**Metaclass**:
```python
class SingletonMeta(type):
    """Metaclass ที่ทำให้ class มี instance เดียว"""
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super().__call__(*args, **kwargs)
        return cls._instances[cls]

class Database(metaclass=SingletonMeta):
    def __init__(self):
        self.connection = "connected"

db1 = Database()
db2 = Database()
print(db1 is db2)  # True
```

**MRO (Method Resolution Order)**:
```python
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

print(D.__mro__)
# (<class 'D'>, <class 'B'>, <class 'C'>, <class 'A'>, <class 'object'>)
print(D().method())  # B
```

**อ้างอิง**: [Advanced Python OOP: Metaclasses, Descriptors (2025)](https://github.com/girijesh-ai/ai-interview-codex) 

---

### 23.36–23.38 Abstract Base Class, Plugin Architecture, Design Patterns

**Abstract Base Class**:
```python
from abc import ABC, abstractmethod

class Storage(ABC):
    @abstractmethod
    def save(self, key, value):
        ...

    @abstractmethod
    def load(self, key):
        ...

class FileStorage(Storage):
    def save(self, key, value):
        with open(key, 'w') as f:
            f.write(value)

    def load(self, key):
        with open(key) as f:
            return f.read()

# storage = Storage()  # TypeError!
storage = FileStorage()
```

**Design Patterns ใน Python**:
- **Singleton**: ใช้ metaclass หรือ `__new__`
- **Factory**: ใช้ function หรือ class method
- **Observer**: ใช้ list ของ callbacks
- **Strategy**: ใช้ function เป็น parameter
- **Decorator**: ใช้ `@decorator` syntax

---

## ภาค 27: Python Runtime และ Internals เพิ่มเติม

### 27.1–27.7 CPython, PyPy, GraalPy, Jython, IronPython, MicroPython, CircuitPython

**ตารางเปรียบเทียบ Implementations**:

| Implementation | ข้อดี | ข้อเสีย | เหมาะกับ |
|----------------|------|---------|----------|
| **CPython** | Ecosystem ครบ, debugging ดี | GIL, ช้ากว่า JIT | งานทั่วไป |
| **PyPy** | JIT เร็ว 4x | C extensions ต้อง CFFI | CPU-bound |
| **GraalPy** | Polyglot, JIT, AOT | Ecosystem ยังเล็ก | Cloud-native |
| **Jython** | Java integration | Python 2.7 เท่านั้น | Java legacy |
| **IronPython** | .NET integration | Python 3.4 | .NET |
| **MicroPython** | เบามาก | ไม่ครบ stdlib | IoT, embedded |
| **CircuitPython** | ง่ายสำหรับ maker | ไม่ครบ stdlib | Education |

**อ้างอิง**: [Python Interpreter Comparison 2025](https://blog.csdn.net/AlienProgrammer/article/details/149808858) 

---

### 27.8–27.9 GIL และ Free-threading

GIL (Global Interpreter Lock) ป้องกันไม่ให้หลาย threads รัน Python bytecode พร้อมกัน

**Free-threaded Python (PEP 703)**:
- Python 3.13: experimental `--disable-gil` option
- Performance gap ลดจาก 40% (3.13) เหลือ <10% สำหรับแพลตฟอร์มส่วนใหญ่
- Memory overhead ~20% สำหรับ pyperformance workloads
- Python 3.14: officially supports free-threading

```python
# ตรวจสอบว่าใช้ free-threaded build หรือไม่
import sys
if hasattr(sys, '_is_gil_enabled'):
    print(f"GIL enabled: {sys._is_gil_enabled()}")
else:
    print("Standard build (GIL always enabled)")
```

**อ้างอิง**: [Python Language Summit 2025: State of Free-Threaded Python](https://pyfound.blogspot.com/2025/06/python-language-summit-2025-state-of-free-threaded-python.html) 

---

### 27.10–27.14 Reference Counting, GC, Memory Allocator, obmalloc, Arena

**Memory Allocator Hierarchy**:
1. **System allocator** (`malloc`)
2. **pymalloc**: สำหรับ objects ขนาดเล็ก ≤512 bytes
3. **Arena**: blocks ขนาด 256KB
4. **Pool**: blocks ขนาด 4KB

```python
import sys

# ดูขนาด object
print(sys.getsizeof(42))        # 28 bytes
print(sys.getsizeof("hello"))   # 54 bytes
print(sys.getsizeof([1, 2, 3])) # 88 bytes
```

**อ้างอิง**: [Memory Management in Python (2025)](https://www.sanmin.com.tw) 

---

### 27.15–27.21 Bytecode, dis, Opcode, AST, Symbol Table, Tokenizer, Parser

**Bytecode Inspection ด้วย `dis`**:
```python
import dis

def compute(a, b):
    result = a * b + 10
    return result

dis.dis(compute)
#   2           0 LOAD_FAST                0 (a)
#               2 LOAD_FAST                1 (b)
#               4 BINARY_OP                5 (*)
#               6 LOAD_CONST               1 (10)
#               8 BINARY_OP                0 (+)
#              10 STORE_FAST               2 (result)
#   3          12 LOAD_FAST                2 (result)
#              14 RETURN_VALUE
```

**Tokenizer**:
```python
import tokenize
import io

code = "x = 42  # comment"
tokens = tokenize.generate_tokens(io.StringIO(code).readline)
for token in tokens:
    print(token)
```

---

### 27.22–27.26 importlib, Finder, Loader, Meta Path, Path Hook

**Custom Import Hook**:
```python
import sys
from importlib.abc import MetaPathFinder, Loader

class MyFinder(MetaPathFinder):
    def find_spec(self, fullname, path, target=None):
        if fullname.startswith('myapp.'):
            return importlib.util.spec_from_loader(fullname, MyLoader())
        return None

class MyLoader(Loader):
    def exec_module(self, module):
        # custom loading logic
        pass

sys.meta_path.insert(0, MyFinder())
```

---

### 27.27–27.30 Descriptor, Metaclass, MRO, `__slots__`

(ดูรายละเอียดในหัวข้อ 23.2, 23.34, 23.17)

---

### 27.31–27.32 Weakref และ Contextvars

**Contextvars**:
```python
import contextvars

request_id = contextvars.ContextVar('request_id', default='unknown')

def process_request(rid):
    request_id.set(rid)
    # ค่านี้จะแยกตาม async task
    return handle()

async def handle():
    return f"Processing {request_id.get()}"
```

---

### 27.33–27.39 C API, PyO3, Cython, Numba, CFFI, ctypes, pybind11

**PyO3 (Rust)**:
```rust
use pyo3::prelude::*;

#[pyfunction]
fn sum_as_string(a: usize, b: usize) -> PyResult<String> {
    Ok((a + b).to_string())
}

#[pymodule]
fn my_module(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(sum_as_string, m)?)?;
    Ok(())
}
```

**Cython**:
```cython
# compute.pyx
def sum_range(int n):
    cdef int i
    cdef long total = 0
    for i in range(n):
        total += i
    return total
```

**Numba JIT**:
```python
from numba import njit

@njit
def monte_carlo_pi(n):
    import random
    inside = 0
    for _ in range(n):
        x, y = random.random(), random.random()
        if x*x + y*y <= 1:
            inside += 1
    return 4 * inside / n
```

**อ้างอิง**: [PyO3 documentation](https://github.com/kylebarron/pyo3) 

---

### 27.40–27.44 WASM, Pyodide, PyScript, Brython, Transcrypt

**Pyodide**: CPython compiled to WebAssembly
```html
<script src="https://cdn.jsdelivr.net/pyodide/v0.29.1/full/pyodide.js"></script>
<script>
async function main() {
    let pyodide = await loadPyodide();
    console.log(pyodide.runPython(`
        import sys
        sys.version
    `));
}
main();
</script>
```

**PyScript**:
```html
<script type="py">
    import numpy as np
    arr = np.array([1, 2, 3, 4, 5])
    print(arr * 2)
</script>
```

**อ้างอิง**: [PyScript Offline Guide](https://docs.pyscript.net/2026.7.2/user-guide/offline/) 

---

### 27.45–27.46 Subinterpreters และ Per-Interpreter GIL

**PEP 684: Per-Interpreter GIL** ช่วยให้แต่ละ subinterpreter มี GIL ของตัวเอง ทำให้สามารถรัน Python code แบบขนานได้

```python
# Python 3.14+: concurrent.interpreters module
from concurrent import interpreters

interp = interpreters.create()
interp.exec("print('Hello from subinterpreter')")
```

**อ้างอิง**: [PEP 684 – A Per-Interpreter GIL](https://peps.python.org/pep-0684/) 

---

## ภาค 28: Standard Library ที่ควรรู้เพิ่มเติม

### 28.1–28.6 argparse, click, typer, configparser, tomllib, dotenv

**argparse**:
```python
import argparse

parser = argparse.ArgumentParser(description='Process data')
parser.add_argument('input', help='Input file')
parser.add_argument('--output', '-o', default='output.txt')
parser.add_argument('--verbose', '-v', action='store_true')
args = parser.parse_args()
```

**click** (decorator-based):
```python
import click

@click.command()
@click.option('--count', default=1, help='Number of greetings')
@click.argument('name')
def hello(count, name):
    for _ in range(count):
        click.echo(f"Hello, {name}!")

if __name__ == '__main__':
    hello()
```

**typer** (type-hint based):
```python
import typer

app = typer.Typer()

@app.command()
def hello(name: str, count: int = 1):
    for _ in range(count):
        typer.echo(f"Hello, {name}!")

if __name__ == '__main__':
    app()
```

**tomllib**:
```python
import tomllib

with open('pyproject.toml', 'rb') as f:
    config = tomllib.load(f)
```

---

### 28.7–28.9 logging, warnings, traceback

**logging**:
```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

logger.info("Application started")
logger.warning("Low disk space")
logger.error("Failed to connect")
```

**traceback**:
```python
import traceback

try:
    raise ValueError("Something went wrong")
except Exception:
    traceback.print_exc()
```

---

### 28.10–28.12 inspect, dis, ast

**inspect**:
```python
import inspect

def greet(name: str) -> str:
    return f"Hello, {name}"

sig = inspect.signature(greet)
print(sig)  # (name: str) -> str
print(sig.parameters)  # OrderedDict([('name', <Parameter "name: str">)])
```

---

### 28.13–28.18 itertools, functools, operator, collections, heapq, bisect

**itertools**:
```python
import itertools

# Infinite iterators
counter = itertools.count(10, 2)
print(list(itertools.islice(counter, 5)))  # [10, 12, 14, 16, 18]

# Combinations
letters = ['A', 'B', 'C']
print(list(itertools.permutations(letters, 2)))
# [('A', 'B'), ('A', 'C'), ('B', 'A'), ('B', 'C'), ('C', 'A'), ('C', 'B')]

# Group by
data = [('a', 1), ('a', 2), ('b', 3), ('b', 4)]
for key, group in itertools.groupby(data, key=lambda x: x[0]):
    print(key, list(group))
```

**functools**:
```python
import functools

# lru_cache
@functools.lru_cache(maxsize=128)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

# partial
def power(base, exponent):
    return base ** exponent

square = functools.partial(power, exponent=2)
print(square(5))  # 25

# singledispatch
@functools.singledispatch
def process(value):
    raise TypeError(f"Unsupported type: {type(value)}")

@process.register(int)
def _(value):
    return f"Integer: {value}"

@process.register(str)
def _(value):
    return f"String: {value}"
```

**collections**:
```python
from collections import defaultdict, Counter, deque, OrderedDict

# defaultdict
word_count = defaultdict(int)
for word in ["apple", "banana", "apple"]:
    word_count[word] += 1

# Counter
count = Counter(["apple", "banana", "apple", "orange", "banana", "apple"])
print(count.most_common(2))  # [('apple', 3), ('banana', 2)]

# deque
queue = deque([1, 2, 3])
queue.appendleft(0)
queue.append(4)
print(queue.popleft())  # 0
```

**heapq**:
```python
import heapq

numbers = [3, 1, 4, 1, 5, 9, 2, 6]
heapq.heapify(numbers)
print(numbers)  # [1, 1, 2, 3, 5, 9, 4, 6]
print(heapq.heappushpop(numbers, 0))  # 0
```

**bisect**:
```python
import bisect

sorted_list = [1, 3, 5, 7, 9]
bisect.insort(sorted_list, 4)
print(sorted_list)  # [1, 3, 4, 5, 7, 9]
print(bisect.bisect_left(sorted_list, 5))  # 2
```

**อ้างอิง**: [Exploring Python's Standard Library: Hidden Gems](https://codesarray.com/view/Exploring-Python%e2%80%99s-Standard-Library:-Hidden-Gems) 

---

### 28.19–28.28 decimal, fractions, statistics, random, secrets, uuid, hashlib, hmac, base64

**secrets** (secure random):
```python
import secrets

# สร้าง token
token = secrets.token_hex(32)
print(token)

# สุ่มแบบ secure
choice = secrets.choice(['rock', 'paper', 'scissors'])
```

**uuid**:
```python
import uuid

# UUID4 (random)
id4 = uuid.uuid4()
print(id4)

# UUID1 (time-based)
id1 = uuid.uuid1()
print(id1)
```

**hashlib**:
```python
import hashlib

# SHA-256
hash_obj = hashlib.sha256(b"data")
print(hash_obj.hexdigest())

# Password hashing with salt
salt = b"random_salt"
hash_obj = hashlib.pbkdf2_hmac('sha256', b"password", salt, 100000)
```

---

### 28.29–28.33 ssl, socket, urllib, http.client, http.server

**urllib**:
```python
from urllib.request import urlopen
from urllib.parse import urlencode, quote

# GET request
with urlopen('https://httpbin.org/get') as response:
    print(response.status)
    print(response.read())

# URL encoding
params = urlencode({'name': 'Alice', 'age': 30})
print(params)  # name=Alice&age=30
```

---

### 28.34–28.44 xmlrpc, ipaddress, email, smtplib, imaplib, poplib, ftplib, sqlite3, dbm, shelve

**ipaddress**:
```python
import ipaddress

# ตรวจสอบ IP
ip = ipaddress.ip_address('192.168.1.1')
print(ip.is_private)  # True

# Network
net = ipaddress.ip_network('192.168.1.0/24')
for addr in net.hosts():
    print(addr)  # 192.168.1.1 ... 192.168.1.254
```

**sqlite3**:
```python
import sqlite3

conn = sqlite3.connect(':memory:')
cursor = conn.cursor()

cursor.execute('''CREATE TABLE users
                  (id INTEGER PRIMARY KEY, name TEXT, email TEXT)''')
cursor.execute("INSERT INTO users (name, email) VALUES (?, ?)",
               ("Alice", "alice@example.com"))

cursor.execute("SELECT * FROM users")
print(cursor.fetchall())
conn.close()
```

**smtplib**:
```python
import smtplib
from email.message import EmailMessage

msg = EmailMessage()
msg.set_content("Hello from Python!")
msg['Subject'] = "Test Email"
msg['From'] = "sender@example.com"
msg['To'] = "recipient@example.com"

with smtplib.SMTP('localhost', 1025) as server:
    server.send_message(msg)
```

---

### 28.45–28.52 pickle, copyreg, zlib, gzip, bz2, lzma, zipfile, tarfile

**pickle**:
```python
import pickle

data = {'name': 'Alice', 'scores': [95, 87, 92]}

# Serialize
with open('data.pkl', 'wb') as f:
    pickle.dump(data, f)

# Deserialize
with open('data.pkl', 'rb') as f:
    loaded = pickle.load(f)
```

**gzip**:
```python
import gzip

with gzip.open('file.txt.gz', 'wt') as f:
    f.write("Compressed content")

with gzip.open('file.txt.gz', 'rt') as f:
    print(f.read())
```

**zipfile**:
```python
import zipfile

with zipfile.ZipFile('archive.zip', 'w') as zf:
    zf.write('file1.txt')
    zf.write('file2.txt')

with zipfile.ZipFile('archive.zip', 'r') as zf:
    print(zf.namelist())
    print(zf.read('file1.txt'))
```

---

### 28.53–28.55 shutil, tempfile, mmap

**shutil**:
```python
import shutil

# Copy file
shutil.copy('source.txt', 'destination.txt')

# Copy directory
shutil.copytree('src_dir', 'dst_dir')

# Move
shutil.move('old_location', 'new_location')

# Remove directory
shutil.rmtree('directory_to_remove')
```

**tempfile**:
```python
import tempfile

# สร้าง temporary file
with tempfile.NamedTemporaryFile(mode='w', delete=False) as f:
    f.write("Temporary content")
    temp_path = f.name

# สร้าง temporary directory
with tempfile.TemporaryDirectory() as tmpdir:
    print(f"Temp dir: {tmpdir}")
```

---

### 28.56–28.60 selectors, signal, threading, multiprocessing, asyncio

**signal**:
```python
import signal
import time

def handler(signum, frame):
    print(f"Signal {signum} received")
    exit(0)

signal.signal(signal.SIGINT, handler)
print("Press Ctrl+C...")
time.sleep(10)
```

**threading**:
```python
import threading

def worker(name):
    print(f"Thread {name} starting")
    # งานที่ต้องทำ
    print(f"Thread {name} done")

threads = []
for i in range(3):
    t = threading.Thread(target=worker, args=(f"Worker-{i}",))
    threads.append(t)
    t.start()

for t in threads:
    t.join()
```

---

### 28.61–28.65 contextlib, dataclasses, enum, typing, abc

**enum**:
```python
from enum import Enum, auto

class Status(Enum):
    PENDING = auto()
    PROCESSING = auto()
    COMPLETED = auto()
    FAILED = auto()

print(Status.PENDING.name)   # PENDING
print(Status.PENDING.value)  # 1
```

**dataclasses**:
```python
from dataclasses import dataclass, field

@dataclass
class Config:
    host: str = "localhost"
    port: int = 8080
    tags: list[str] = field(default_factory=list)
    debug: bool = False
```

---

### 28.66–28.72 atexit, gc, weakref, pprint, reprlib, textwrap, string

**pprint**:
```python
import pprint

data = {'users': [{'name': 'Alice', 'age': 30}, {'name': 'Bob', 'age': 25}]}
pprint.pprint(data, width=40, indent=2)
```

**textwrap**:
```python
import textwrap

text = "This is a long text that needs to be wrapped for better readability."
print(textwrap.fill(text, width=40))
```

---

### 28.73–28.78 re, difflib, filecmp, locale, gettext, unicodedata

**re**:
```python
import re

text = "Contact: alice@example.com, bob@test.org"
emails = re.findall(r'[\w.+-]+@[\w-]+\.[\w.]+', text)
print(emails)  # ['alice@example.com', 'bob@test.org']

# Named groups
pattern = re.compile(r'(?P<year>\d{4})-(?P<month>\d{2})-(?P<day>\d{2})')
match = pattern.match('2026-01-15')
print(match.group('year'))  # 2026
```

**difflib**:
```python
import difflib

text1 = "Hello World"
text2 = "Hello Python"

for line in difflib.unified_diff(
    text1.splitlines(), text2.splitlines(),
    fromfile='file1', tofile='file2'
):
    print(line)
```

---

### 28.79–28.83 codecs, platform, sys, os, io

**platform**:
```python
import platform

print(platform.system())   # Linux/Darwin/Windows
print(platform.release())  # kernel version
print(platform.python_version())  # 3.14.0
```

**sys**:
```python
import sys

print(sys.version)
print(sys.executable)
print(sys.path)
print(sys.maxsize)
```

**os**:
```python
import os

print(os.getcwd())
print(os.listdir('.'))
print(os.environ.get('HOME'))
```

---

### 28.84–28.88 time, datetime, zoneinfo, calendar, unittest

**datetime**:
```python
from datetime import datetime, timedelta, timezone

now = datetime.now(timezone.utc)
print(now.isoformat())

# คำนวณ
tomorrow = now + timedelta(days=1)
print(tomorrow)

# Parse
dt = datetime.fromisoformat('2026-01-15T10:30:00+00:00')
```

**zoneinfo**:
```python
from zoneinfo import ZoneInfo
from datetime import datetime

bangkok = ZoneInfo('Asia/Bangkok')
now = datetime.now(bangkok)
print(now)
```

**unittest**:
```python
import unittest

class TestMath(unittest.TestCase):
    def test_addition(self):
        self.assertEqual(2 + 2, 4)

    def test_division(self):
        with self.assertRaises(ZeroDivisionError):
            1 / 0

if __name__ == '__main__':
    unittest.main()
```

---

### 28.89–28.95 doctest, pdb, cProfile, timeit, trace, faulthandler, venv

**doctest**:
```python
def add(a, b):
    """
    >>> add(2, 3)
    5
    >>> add(-1, 1)
    0
    """
    return a + b

if __name__ == '__main__':
    import doctest
    doctest.testmod()
```

**pdb**:
```python
import pdb

def buggy_function(x):
    result = x * 2
    pdb.set_trace()  # breakpoint
    return result + 1
```

**timeit**:
```python
import timeit

# เปรียบเทียบ performance
list_comp = timeit.timeit(
    '[x * 2 for x in range(1000)]',
    number=10000
)
map_func = timeit.timeit(
    'list(map(lambda x: x * 2, range(1000)))',
    number=10000
)
print(f"List comp: {list_comp:.4f}s")
print(f"Map: {map_func:.4f}s")
```

---

### 28.96–28.100 ensurepip, zipapp, runpy, site, sysconfig

**zipapp**:
```bash
# สร้าง executable zip archive
python -m zipapp myapp -o myapp.pyz -p "/usr/bin/env python3"
./myapp.pyz
```

---

### 28.101–28.111 tkinter, turtle, curses, cmd, shlex, getpass, getopt, wsgiref, socketserver, http.cookies, http.cookiejar

**getpass**:
```python
import getpass

password = getpass.getpass("Enter password: ")
print(f"Password length: {len(password)}")
```

**shlex**:
```python
import shlex

command = "python script.py --input 'file with spaces.txt'"
parts = shlex.split(command)
print(parts)  # ['python', 'script.py', '--input', 'file with spaces.txt']
```

**socketserver**:
```python
from socketserver import TCPServer, BaseRequestHandler

class EchoHandler(BaseRequestHandler):
    def handle(self):
        data = self.request.recv(1024)
        self.request.sendall(data)

with TCPServer(('localhost', 9999), EchoHandler) as server:
    server.serve_forever()
```

---

## สรุป

หนังสือเล่ม 10 ครอบคลุมเนื้อหาขั้นสูงของ Python ตั้งแต่ Metaprogramming, Descriptors, Metaclasses, Memory Management, CPython Internals, Bytecode, AST, ทางเลือก Implementations ต่าง ๆ (PyPy, GraalPy, MicroPython, Pyodide) ไปจนถึง Standard Library ที่มีประโยชน์แต่หลายคนยังไม่รู้จัก นักพัฒนาสามารถนำความรู้เหล่านี้ไปใช้ในการ debug, optimize, และเขียนโค้ด Python ที่มีประสิทธิภาพสูงได้

**แหล่งอ้างอิงหลัก**:
- [Python Language Summit 2025: State of Free-Threaded Python](https://pyfound.blogspot.com/2025/06/python-language-summit-2025-state-of-free-threaded-python.html) 
- [Descriptor HowTo Guide](https://docs.python.org/3/howto/descriptor.html) 
- [Bytecode Generation – DeepWiki](https://deepwiki.com/zpoint/CPython-Internals/8.3-bytecode-generation) 
- [CPython Internals (2025)](https://www.sanmin.com.tw) 
- [Memory Management in Python (2025)](https://www.sanmin.com.tw) 
- [Python Interpreter Comparison 2025](https://blog.csdn.net/AlienProgrammer/article/details/149808858) 
- [PyScript Offline Guide](https://docs.pyscript.net/2026.7.2/user-guide/offline/) 
- [Exploring Python's Standard Library: Hidden Gems](https://codesarray.com/view/Exploring-Python%e2%80%99s-Standard-Library:-Hidden-Gems) 
- [PyO3 documentation](https://github.com/kylebarron/pyo3) 
- [PEP 684 – A Per-Interpreter GIL](https://peps.python.org/pep-0684/) 
- [Advanced Python OOP: Metaclasses, Descriptors (2025)](https://github.com/girijesh-ai/ai-interview-codex) 