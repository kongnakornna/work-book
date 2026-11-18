# เล่ม 9: Concurrency, Async, ประสิทธิภาพ, DevOps, Cloud, Deployment, SRE และ Distributed Systems

## คำนำ

หนังสือเล่มนี้เป็นคู่มือภาคปฏิบัติสำหรับนักพัฒนา Python ที่ต้องการเข้าใจและนำทักษะด้าน Concurrency, Async, ประสิทธิภาพ, DevOps, Cloud, Deployment, SRE และ Distributed Systems มาใช้ในงานจริง เนื้อหาครอบคลุมตั้งแต่ GIL, Threading, Multiprocessing, Asyncio ไปจนถึง Docker, Kubernetes, Terraform, Prometheus, OpenTelemetry, CAP Theorem และ Chaos Engineering โดยทุกหัวข้อมีตัวอย่างโค้ดที่พร้อมใช้งานและแหล่งอ้างอิงที่เป็นประโยชน์

---

## ภาค 20: Concurrency, Async และประสิทธิภาพ

### 20.1 Threading

Threading คือการรันหลาย threads ภายใน process เดียวกัน เหมาะสำหรับงาน I/O-bound ที่ต้องรอ network, disk หรือ database

**Threading ทำงานอย่างไร**
Python ใช้ `threading` module ในการสร้างและจัดการ threads แต่เนื่องจาก GIL (Global Interpreter Lock) threads จึงไม่สามารถรัน Python bytecode แบบขนานจริงได้สำหรับงาน CPU-bound

**การใช้งาน**
```python
import threading
import time

def download_file(url, results, index):
    """จำลองการดาวน์โหลดไฟล์ (I/O-bound)"""
    time.sleep(1)  # จำลอง network latency
    results[index] = f"Downloaded: {url}"

urls = [f"https://example.com/file{i}" for i in range(5)]
results = [None] * len(urls)
threads = []

start = time.perf_counter()
for i, url in enumerate(urls):
    t = threading.Thread(target=download_file, args=(url, results, i))
    threads.append(t)
    t.start()

for t in threads:
    t.join()

elapsed = time.perf_counter() - start
print(f"Downloaded {len(urls)} files in {elapsed:.2f}s")
print(results)
```

**ข้อดี**: เหมาะกับ I/O-bound tasks, ใช้หน่วยความจำน้อยกว่า multiprocessing
**ข้อเสีย**: GIL จำกัด parallelism สำหรับ CPU-bound tasks
**ข้อควรระวัง**: ต้องจัดการ synchronization (Lock, Semaphore) เมื่อแชร์ข้อมูล

**อ้างอิง**: [Real Python – Speed Up Python With Concurrency](https://realpython.com/courses/speed-python-concurrency/) 

---

### 20.2 Multiprocessing

Multiprocessing คือการรันหลาย processes แยกกัน แต่ละ process มี Python interpreter และหน่วยความจำของตัวเอง ทำให้ข้ามข้อจำกัดของ GIL ได้

**Multiprocessing ทำงานอย่างไร**
Python ใช้ `multiprocessing` module ที่สร้าง processes ใหม่ผ่าน `fork` (Unix) หรือ `spawn` (Windows/macOS) เหมาะสำหรับงาน CPU-bound

**การใช้งาน**
```python
from multiprocessing import Pool
import time

def cpu_intensive(n):
    """จำลองงาน CPU-bound: คำนวณผลรวม"""
    total = 0
    for i in range(n):
        total += i * i
    return total

if __name__ == "__main__":
    tasks = [10**7] * 4
    
    start = time.perf_counter()
    with Pool(processes=4) as pool:
        results = pool.map(cpu_intensive, tasks)
    elapsed = time.perf_counter() - start
    
    print(f"Computed {len(tasks)} tasks in {elapsed:.2f}s")
    print(f"Results: {results}")
```

**ข้อควรระวัง**: ต้องมี `if __name__ == "__main__":` เพื่อป้องกัน recursive process creation; การแชร์ข้อมูลต้องใช้ `Queue`, `Pipe` หรือ `Manager`

**อ้างอิง**: [Python Concurrency Interview Guide](https://github.com/sinha-19/Python-Interview-Guide) 

---

### 20.3 asyncio

`asyncio` เป็นไลบรารีสำหรับเขียน asynchronous code ด้วย `async`/`await` ใช้ event loop แบบ single-threaded ที่สลับไปมาระหว่าง coroutines เมื่อเจอ `await`

**asyncio ทำงานอย่างไร**
Event loop จะรัน coroutine หนึ่งจนกว่าจะเจอ `await` จากนั้นจะสลับไปรัน coroutine อื่น ทำให้สามารถจัดการ I/O หลายอย่างพร้อมกันได้ด้วย thread เดียว

**การใช้งาน**
```python
import asyncio
import aiohttp
import time

async def fetch(session, url):
    """ดึงข้อมูลจาก URL แบบ async"""
    async with session.get(url) as response:
        return await response.text()

async def main():
    urls = [f"https://httpbin.org/delay/1?id={i}" for i in range(5)]
    
    start = time.perf_counter()
    async with aiohttp.ClientSession() as session:
        tasks = [fetch(session, url) for url in urls]
        results = await asyncio.gather(*tasks)
    elapsed = time.perf_counter() - start
    
    print(f"Fetched {len(urls)} URLs in {elapsed:.2f}s")
    return results

asyncio.run(main())
```

**การใช้ TaskGroup (Python 3.11+)**
```python
async def main():
    async with asyncio.TaskGroup() as tg:
        task1 = tg.create_task(fetch_data(1))
        task2 = tg.create_task(fetch_data(2))
    # task1 และ task2 เสร็จสมบูรณ์แล้ว
    print(task1.result(), task2.result())
```

**อ้างอิง**: [Real Python – Async Programming in Python](https://realpython.com/python-async-features/) 

---

### 20.4 GIL

GIL (Global Interpreter Lock) คือ mutex ที่ป้องกันไม่ให้หลาย threads รัน Python bytecode พร้อมกันใน CPython

**ผลกระทบ**:
- Threading ไม่ช่วยเพิ่ม performance สำหรับ CPU-bound tasks
- Multiprocessing และ asyncio เป็นทางเลือกที่ดีกว่า
- Python 3.13 เพิ่ม experimental free-threading mode

```python
import sys
print(f"GIL enabled: {sys._is_gil_enabled() if hasattr(sys, '_is_gil_enabled') else 'N/A'}")
```

**อ้างอิง**: [LearnAI – Deep Dive into Multithreading, Multiprocessing, and Asyncio](https://learn.aisingapore.org) 

---

### 20.5 concurrent.futures

`concurrent.futures` เป็น high-level interface สำหรับ asynchronous execution ด้วย `ThreadPoolExecutor` และ `ProcessPoolExecutor`

**การใช้งาน**
```python
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor, as_completed
import time

def fetch_url(url):
    time.sleep(1)
    return f"Data from {url}"

# ThreadPoolExecutor สำหรับ I/O-bound
with ThreadPoolExecutor(max_workers=4) as executor:
    futures = [executor.submit(fetch_url, f"https://api.example.com/{i}") 
               for i in range(10)]
    for future in as_completed(futures):
        print(future.result())

# ProcessPoolExecutor สำหรับ CPU-bound
def cpu_task(n):
    return sum(i * i for i in range(n))

with ProcessPoolExecutor(max_workers=4) as executor:
    results = list(executor.map(cpu_task, [10**6] * 4))
    print(results)
```

**อ้างอิง**: [concurrent.futures – Python Documentation](https://docs.python.org/3/library/concurrent.futures.html) 

---

### 20.6–20.9 Async Frameworks

**AnyIO**: abstraction layer ที่รองรับทั้ง asyncio และ Trio
```python
import anyio

async def main():
    async with anyio.create_task_group() as tg:
        tg.start_soon(task1)
        tg.start_soon(task2)
```

**Trio**: async framework ที่เน้น structured concurrency
```python
import trio

async def child(name):
    await trio.sleep(1)
    print(f"Child {name} done")

async def main():
    async with trio.open_nursery() as nursery:
        nursery.start_soon(child, "A")
        nursery.start_soon(child, "B")

trio.run(main)
```

**Curio**: async framework ขนาดเล็กที่ใช้ generator-based coroutines

**อ้างอิง**: [Python asyncio documentation](https://docs.python.org/3/library/asyncio.html)

---

### 20.10–20.13 Async Web

**FastAPI** (async web framework):
```python
from fastapi import FastAPI
import httpx

app = FastAPI()

@app.get("/aggregate")
async def aggregate():
    async with httpx.AsyncClient() as client:
        tasks = [client.get(f"https://api.example.com/{i}") for i in range(5)]
        responses = await asyncio.gather(*tasks)
    return {"count": len(responses)}
```

**aiohttp** (async HTTP client/server):
```python
from aiohttp import web

async def handle(request):
    return web.Response(text="Hello, async world!")

app = web.Application()
app.router.add_get('/', handle)
web.run_app(app, port=8080)
```

---

### 20.14 Parallelism

Parallelism คือการรันงานหลายอย่างพร้อมกันจริง ๆ บนหลาย CPU cores ต่างจาก concurrency ที่สลับไปมา

| รูปแบบ | เหมาะกับ | ข้อจำกัด |
|--------|----------|----------|
| Threading | I/O-bound | GIL |
| Multiprocessing | CPU-bound | หน่วยความจำ, serialization |
| Asyncio | I/O-bound จำนวนมาก | single-threaded |

---

### 20.15 Performance Profiling

การ profiling คือการวัดว่าโปรแกรมใช้เวลาและหน่วยความจำที่ไหนมากที่สุด

```python
import cProfile
import pstats
from io import StringIO

def slow_function():
    total = 0
    for i in range(10**6):
        total += i * i
    return total

# Command-line profiling
# python -m cProfile -s cumulative main.py

# In-code profiling
profiler = cProfile.Profile()
profiler.enable()
slow_function()
profiler.disable()

stream = StringIO()
stats = pstats.Stats(profiler, stream=stream)
stats.sort_stats('cumulative')
stats.print_stats(10)
print(stream.getvalue())
```

**อ้างอิง**: [Performance Profiling & Optimisation (Python)](http://rse.shef.ac.uk/pando-python/) 

---

### 20.16 cProfile

`cProfile` เป็น deterministic profiler ที่วัดเวลาของทุก function call

```bash
python -m cProfile -o profile_output.prof my_script.py
python -c "import pstats; p = pstats.Stats('profile_output.prof'); p.sort_stats('cumulative').print_stats(20)"
```

---

### 20.17 line_profiler

`line_profiler` วัดเวลาต่อบรรทัดของโค้ด

```python
# ติดตั้ง: pip install line-profiler
# ใช้ decorator @profile แล้วรัน: kernprof -l -v script.py

@profile
def process_data(data):
    result = []
    for item in data:
        result.append(item * 2)
    return result
```

---

### 20.18 memory_profiler

`memory_profiler` วัดการใช้หน่วยความจำต่อบรรทัด

```python
# ติดตั้ง: pip install memory-profiler
from memory_profiler import profile

@profile
def create_large_list():
    return [i for i in range(10**6)]
```

---

### 20.19 py-spy

`py-spy` เป็น sampling profiler ที่รันได้โดยไม่ต้องแก้ไขโค้ด

```bash
pip install py-spy
py-spy top --pid 12345
py-spy record -o profile.svg -- python my_script.py
```

---

### 20.20 Optimization Technique

| เทคนิค | คำอธิบาย | เครื่องมือ |
|--------|----------|-----------|
| Algorithm optimization | เลือก algorithm ที่เหมาะสม | Big O analysis |
| Data structure | ใช้โครงสร้างข้อมูลที่เหมาะสม | `dict`, `set`, `deque` |
| Caching | เก็บผลลัพธ์ที่คำนวณแล้ว | `functools.lru_cache` |
| C Extension | เขียนส่วนที่ช้าเป็น C | Cython, Numba, pybind11 |
| JIT Compilation | compile ขณะรัน | Numba, PyPy |

```python
from functools import lru_cache

@lru_cache(maxsize=128)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)
```

---

### 20.21–20.25 C Extension

**Numba JIT**:
```python
from numba import njit
import numpy as np

@njit
def cdist_numba(xs, ys):
    m, p = xs.shape
    n, _ = ys.shape
    res = np.empty((m, n))
    for i in range(m):
        for j in range(n):
            res[i, j] = np.sqrt(np.sum((ys[j] - xs[i])**2))
    return res
```

**Cython**:
```cython
# save as compute.pyx
def sum_range(int n):
    cdef int i
    cdef long total = 0
    for i in range(n):
        total += i
    return total
```

**pybind11**:
```cpp
// C++ code
#include <pybind11/pybind11.h>
int add(int a, int b) { return a + b; }
PYBIND11_MODULE(example, m) {
    m.def("add", &add);
}
```

**ctypes**:
```python
import ctypes

lib = ctypes.CDLL("./mylib.so")
result = lib.my_function(42)
```

**อ้างอิง**: [Enhancing performance – Duke University](https://people.duke.edu/~ccc14/bios-823-2020/notebooks/E05_Code_Optimization.html) 

---

### 20.26 Numba

`Numba` แปลง Python functions เป็น machine code ด้วย LLVM JIT

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

---

### 20.27 Nuitka

`Nuitka` compile Python เป็น C-level program

```bash
pip install nuitka
nuitka --standalone --onefile my_script.py
```

---

### 20.28 PyPy

`PyPy` เป็น Python implementation ที่มี JIT compiler เร็วกว่า CPython หลายเท่าสำหรับ CPU-bound code

---

### 20.29–20.31 Caching Strategy

```python
import redis
import json

cache = redis.Redis(host='localhost', port=6379)

def get_user(user_id):
    # ลองดึงจาก cache
    cached = cache.get(f"user:{user_id}")
    if cached:
        return json.loads(cached)
    
    # ดึงจาก database
    user = db.query(f"SELECT * FROM users WHERE id = {user_id}")
    
    # เก็บใน cache 30 นาที
    cache.setex(f"user:{user_id}", 1800, json.dumps(user))
    return user
```

---

### 20.32–20.35 Load Testing

**Locust**:
```python
# locustfile.py
from locust import HttpUser, task, between

class APIUser(HttpUser):
    wait_time = between(1, 3)
    
    @task(3)
    def get_users(self):
        self.client.get("/api/users")
    
    @task(1)
    def create_user(self):
        self.client.post("/api/users", json={
            "name": "Test User",
            "email": "test@example.com"
        })
```

```bash
locust -f locustfile.py --host=https://api.example.com
```

**k6**:
```javascript
import http from 'k6/http';
import { check } from 'k6';

export const options = { vus: 100, duration: '30s' };

export default function () {
    const res = http.get('https://api.example.com/users');
    check(res, { 'status was 200': (r) => r.status == 200 });
}
```

**อ้างอิง**: [How to Implement Load Testing with Locust](https://raw.githubusercontent.com) 

---

### 20.36 Benchmarking

```python
import timeit

# เปรียบเทียบ performance
setup = "from random import randint; data = [randint(0, 100) for _ in range(1000)]"

list_comp = timeit.timeit("[x * 2 for x in data]", setup=setup, number=10000)
map_func = timeit.timeit("list(map(lambda x: x * 2, data))", setup=setup, number=10000)

print(f"List comprehension: {list_comp:.4f}s")
print(f"Map: {map_func:.4f}s")
```

---

## ภาค 21: DevOps, Cloud, Deployment และ SRE

### 21.1–21.6 Linux, Git, CI/CD

**Git workflow**:
```bash
git checkout -b feature/new-api
git add .
git commit -m "feat: add user authentication endpoint"
git push origin feature/new-api
# สร้าง Pull Request
```

**GitHub Actions CI**:
```yaml
name: Python CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - run: pip install -r requirements.txt
      - run: pytest --cov=src tests/
      - run: ruff check src/
      - run: mypy src/
```

---

### 21.13–21.16 Docker และ Kubernetes

**Dockerfile สำหรับ Python**:
```dockerfile
FROM python:3.12-slim

WORKDIR /app

# ติดตั้ง dependencies ก่อนเพื่อใช้ Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# สร้าง non-root user
RUN useradd -m appuser && chown -R appuser /app
USER appuser

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "app:app"]
```

**Kubernetes Deployment**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: python-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: python-api
  template:
    metadata:
      labels:
        app: python-api
    spec:
      containers:
      - name: api
        image: myregistry/python-api:latest
        ports:
        - containerPort: 8000
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 10
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /ready
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 10
```

**อ้างอิง**: [Docker – Deploy your Python app](https://docs.docker.com.tw/guides/python/deploy/) 

---

### 21.17–21.24 Cloud Platforms

**AWS Lambda handler**:
```python
import json

def lambda_handler(event, context):
    """AWS Lambda handler function"""
    try:
        body = json.loads(event.get('body', '{}'))
        name = body.get('name', 'World')
        return {
            'statusCode': 200,
            'body': json.dumps({'message': f'Hello, {name}!'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
```

**Azure Functions**:
```python
import azure.functions as func

def main(req: func.HttpRequest) -> func.HttpResponse:
    name = req.params.get('name', 'World')
    return func.HttpResponse(f"Hello, {name}!")
```

**อ้างอิง**: [AWS Lambda handler cookbook](https://raw.githubusercontent.com) 

---

### 21.25–21.28 Infrastructure as Code

**Terraform (HCL)**:
```hcl
resource "aws_s3_bucket" "reports" {
  bucket = "acme-reports-prod"
  tags = {
    Environment = "prod"
    Owner       = "data-platform"
  }
}
```

**Pulumi (Python)**:
```python
import pulumi
import pulumi_aws as aws

bucket = aws.s3.Bucket(
    "reports",
    bucket="acme-reports-prod",
    tags={
        "Environment": "prod",
        "Owner": "data-platform",
    },
)
pulumi.export("bucket_name", bucket.id)
```

**อ้างอิง**: [Real Python – Infrastructure as Code](https://realpython.com/ref/software-engineering-glossary/infrastructure-as-code/) 

---

### 21.29–21.30 Ansible

```yaml
# playbook.yml
- hosts: webservers
  become: yes
  tasks:
    - name: Install Python and pip
      apt:
        name: [python3, python3-pip]
        state: present
    
    - name: Install application dependencies
      pip:
        requirements: /app/requirements.txt
        virtualenv: /app/venv
    
    - name: Start application
      systemd:
        name: python-api
        state: started
        enabled: yes
```

---

### 21.31–21.39 Monitoring และ Logging

**Prometheus metrics**:
```python
from prometheus_client import Counter, Histogram, generate_latest
from flask import Flask, Response

app = Flask(__name__)

REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint'])
REQUEST_LATENCY = Histogram('http_request_duration_seconds', 'HTTP request latency')

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype='text/plain')

@app.before_request
def before_request():
    request.start_time = time.time()

@app.after_request
def after_request(response):
    REQUEST_COUNT.labels(method=request.method, endpoint=request.path).inc()
    REQUEST_LATENCY.observe(time.time() - request.start_time)
    return response
```

**structlog**:
```python
import structlog

logger = structlog.get_logger()

logger.info("user_login", user_id=123, ip="192.168.1.1")
# Output: {"event": "user_login", "user_id": 123, "ip": "192.168.1.1", "level": "info", "timestamp": "..."}
```

**อ้างอิง**: [Observability Practices with Prometheus and Grafana](https://github.com/EdgardChambeT/Observability-Practices-with-Prometheus-and-Grafana) 

---

### 21.40–21.43 Tracing

**OpenTelemetry**:
```python
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor, ConsoleSpanExporter

# ตั้งค่า TracerProvider
provider = TracerProvider()
processor = BatchSpanProcessor(ConsoleSpanExporter())
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)

tracer = trace.get_tracer(__name__)

def process_order(order_id):
    with tracer.start_as_current_span("process_order") as span:
        span.set_attribute("order.id", order_id)
        # ... business logic
        with tracer.start_as_current_span("validate_payment"):
            # ... payment validation
            pass
```

```bash
# Zero-code instrumentation
pip install opentelemetry-distro opentelemetry-exporter-otlp
opentelemetry-bootstrap -a install
opentelemetry-instrument --traces_exporter console python app.py
```

**อ้างอิง**: [OpenTelemetry Python – Getting Started](https://opentelemetry.io/docs/languages/python/getting-started/) 

---

### 21.44 Alerting

```python
# Alertmanager configuration
# alertmanager.yml
route:
  receiver: 'slack-notifications'
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h

receivers:
- name: 'slack-notifications'
  slack_configs:
  - api_url: 'https://hooks.slack.com/services/...'
    channel: '#alerts'
    title: '{{ .GroupLabels.alertname }}'
    text: '{{ .CommonAnnotations.description }}'
```

---

### 21.45–21.48 Deployment Strategy

| กลยุทธ์ | คำอธิบาย | ข้อดี |
|---------|----------|-------|
| Blue-Green | สลับ traffic ระหว่าง 2 environments | rollback ทันที |
| Canary | ค่อย ๆ เพิ่ม traffic ไปยัง version ใหม่ | ลดความเสี่ยง |
| Rolling | อัปเดตทีละ pod | ไม่มี downtime |
| Recreate | หยุดทั้งหมดแล้วเริ่มใหม่ | ง่าย แต่มี downtime |

---

### 21.49–21.56 Web Server และ Reverse Proxy

**Gunicorn**:
```bash
gunicorn app:app \
  --bind 0.0.0.0:8000 \
  --workers 4 \
  --worker-class uvicorn.workers.UvicornWorker \
  --timeout 120 \
  --access-logfile - \
  --error-logfile -
```

**Nginx reverse proxy**:
```nginx
upstream python_app {
    server 127.0.0.1:8000;
    server 127.0.0.1:8001;
}

server {
    listen 80;
    server_name api.example.com;
    
    location / {
        proxy_pass http://python_app;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

**Uvicorn** (สำหรับ FastAPI):
```bash
uvicorn app:app --host 0.0.0.0 --port 8000 --workers 4
```

---

### 21.57–21.59 Scaling และ Cost Optimization

```python
# Horizontal Pod Autoscaler
# hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: python-api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: python-api
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

---

### 21.60 Site Reliability Engineering

SRE คือแนวปฏิบัติที่นำ software engineering มาใช้กับ operations เพื่อสร้างระบบที่เชื่อถือได้

---

## ภาค 22: ระบบขนาดใหญ่ สถาปัตยกรรมขั้นสูง และ Distributed Systems

### 22.1–22.5 Distributed System และ CAP Theorem

CAP Theorem กล่าวว่า distributed system ไม่สามารถรับประกันทั้ง Consistency, Availability และ Partition Tolerance พร้อมกันได้ ต้องเลือก 2 จาก 3

| ประเภท | รับประกัน | ตัวอย่าง |
|--------|----------|----------|
| CP | Consistency + Partition Tolerance | HBase, MongoDB |
| AP | Availability + Partition Tolerance | Cassandra, DynamoDB |
| CA | Consistency + Availability | PostgreSQL (single node) |

```python
# ตัวอย่างการจำลอง CAP
class Node:
    def __init__(self, node_id, mode='CP'):
        self.node_id = node_id
        self.mode = mode
        self.data = {}
        self.is_leader = False
    
    def write(self, key, value):
        if self.mode == 'CP' and not self.is_leader:
            return {'error': 'Not the leader', 'leader': False}
        self.data[key] = value
        return {'status': 'ok'}
```

**อ้างอิง**: [Distributed Systems Failure & Consistency Simulators](https://github.com/bhatti/simulators) 

---

### 22.6–22.8 Consensus, Raft, Paxos

**Raft** เป็น consensus algorithm ที่เข้าใจง่าย ใช้ leader election และ log replication

```python
# Raft state
class RaftNode:
    def __init__(self, node_id):
        self.node_id = node_id
        self.state = 'follower'  # follower, candidate, leader
        self.current_term = 0
        self.voted_for = None
        self.log = []
        self.commit_index = 0
        self.last_applied = 0
    
    def request_vote(self, candidate_id, term, last_log_index, last_log_term):
        """RequestVote RPC"""
        if term < self.current_term:
            return {'term': self.current_term, 'vote_granted': False}
        
        if self.voted_for is None or self.voted_for == candidate_id:
            # ตรวจสอบ log
            if last_log_term > self.get_last_log_term() or \
               (last_log_term == self.get_last_log_term() and last_log_index >= len(self.log)):
                self.voted_for = candidate_id
                return {'term': self.current_term, 'vote_granted': True}
        
        return {'term': self.current_term, 'vote_granted': False}
```

**อ้างอิง**: [Distributed Systems Consistency Models](https://blog.csdn.net) 

---

### 22.9–22.13 Replication, Sharding, Consistency

**Consistency models**:

| Model | คำอธิบาย | ตัวอย่าง |
|-------|----------|----------|
| Strong Consistency | อ่านได้ค่า最新เสมอ | PostgreSQL |
| Eventual Consistency | อ่านได้ค่าเก่า แต่ eventually ตรงกัน | DynamoDB |
| Causal Consistency | รักษาความสัมพันธ์因果 | MongoDB |

---

### 22.14–22.15 Idempotency และ Backpressure

**Idempotency**:
```python
from functools import wraps

def idempotent(key_func):
    def decorator(func):
        cache = {}
        @wraps(func)
        def wrapper(*args, **kwargs):
            key = key_func(*args, **kwargs)
            if key in cache:
                return cache[key]
            result = func(*args, **kwargs)
            cache[key] = result
            return result
        return wrapper
    return decorator

@idempotent(lambda user_id, amount: f"{user_id}:{amount}")
def process_payment(user_id, amount):
    # ประมวลผลการชำระเงิน
    return {"status": "success", "transaction_id": "txn_123"}
```

**Backpressure**:
```python
import asyncio

async def producer(queue, n):
    for i in range(n):
        await queue.put(i)
        print(f"Produced: {i}")
    await queue.put(None)  # sentinel

async def consumer(queue):
    while True:
        item = await queue.get()
        if item is None:
            break
        await asyncio.sleep(0.1)  # จำลองการประมวลผล
        print(f"Consumed: {item}")
        queue.task_done()

async def main():
    queue = asyncio.Queue(maxsize=5)  # จำกัดขนาด queue
    await asyncio.gather(
        producer(queue, 20),
        consumer(queue)
    )

asyncio.run(main())
```

---

### 22.16–22.21 Streaming และ Batch Processing

**Kafka producer**:
```python
from kafka import KafkaProducer
import json

producer = KafkaProducer(
    bootstrap_servers=['localhost:9092'],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

producer.send('user-events', {
    'user_id': 123,
    'event': 'login',
    'timestamp': '2026-01-01T00:00:00Z'
})
producer.flush()
```

**Kafka consumer**:
```python
from kafka import KafkaConsumer

consumer = KafkaConsumer(
    'user-events',
    bootstrap_servers=['localhost:9092'],
    auto_offset_reset='earliest',
    group_id='analytics-group',
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

for message in consumer:
    print(f"Received: {message.value}")
```

---

### 22.22–22.27 Distributed Transaction

**Saga Pattern**:
```python
class SagaOrchestrator:
    def __init__(self):
        self.steps = []
        self.compensations = []
    
    def add_step(self, action, compensation):
        self.steps.append(action)
        self.compensations.append(compensation)
    
    def execute(self):
        completed = []
        try:
            for step in self.steps:
                step()
                completed.append(step)
        except Exception as e:
            # Rollback ในลำดับย้อนกลับ
            for comp in reversed(self.compensations[:len(completed)]):
                comp()
            raise e

# การใช้งาน
saga = SagaOrchestrator()
saga.add_step(
    lambda: reserve_inventory(order_id),
    lambda: release_inventory(order_id)
)
saga.add_step(
    lambda: charge_payment(order_id),
    lambda: refund_payment(order_id)
)
saga.add_step(
    lambda: ship_order(order_id),
    lambda: cancel_shipment(order_id)
)
saga.execute()
```

**Outbox Pattern**:
```python
# เขียน event ลง outbox table ใน transaction เดียวกัน
def create_order(order_data):
    with db.transaction():
        order = db.insert('orders', order_data)
        db.insert('outbox', {
            'event_type': 'OrderCreated',
            'payload': json.dumps(order),
            'status': 'pending'
        })
    return order

# Background worker ส่ง events จาก outbox
def publish_outbox_events():
    events = db.query("SELECT * FROM outbox WHERE status = 'pending'")
    for event in events:
        kafka_producer.send(event['event_type'], event['payload'])
        db.update('outbox', event['id'], {'status': 'published'})
```

---

### 22.28–22.31 Observability และ Chaos Engineering

**Chaos Toolkit experiment**:
```json
{
    "version": "1.0.0",
    "title": "Kill Python API pod",
    "description": "ทดสอบว่า API ยังทำงานได้เมื่อ pod ถูก kill",
    "steady-state-hypothesis": {
        "title": "API responds",
        "probes": [{
            "type": "probe",
            "name": "api-responds",
            "tolerance": 200,
            "provider": {
                "type": "http",
                "url": "https://api.example.com/health"
            }
        }]
    },
    "method": [{
        "type": "action",
        "name": "kill-pod",
        "provider": {
            "type": "python",
            "module": "chaosk8s.pod.actions",
            "func": "terminate_pods",
            "arguments": {
                "label_selector": "app=python-api",
                "rand": true
            }
        }
    }]
}
```

**Failure Flags**:
```python
from failureflags import FailureFlag

@FailureFlag(name="database-timeout")
def query_database():
    # โค้ดปกติ
    return db.query("SELECT * FROM users")
```

**อ้างอิง**: [Failure Flags – Python SDK](https://pypi.org/project/failureflags/) 

---

### 22.32–22.37 High Availability และ Disaster Recovery

| แนวคิด | คำอธิบาย |
|--------|----------|
| High Availability | ระบบพร้อมใช้งานสูง (99.99%+) |
| Fault Tolerance | ทนทานต่อความผิดพลาด |
| Disaster Recovery | กู้คืนระบบหลังภัยพิบัติ |
| RTO | Recovery Time Objective |
| RPO | Recovery Point Objective |

```python
# Health check endpoint
@app.route('/health')
def health():
    checks = {
        'database': check_database(),
        'redis': check_redis(),
        'disk_space': check_disk_space()
    }
    
    if all(checks.values()):
        return jsonify({'status': 'healthy', 'checks': checks}), 200
    else:
        return jsonify({'status': 'unhealthy', 'checks': checks}), 503
```

---

## ภาค 34: แพลตฟอร์มและ Cloud เพิ่มเติม

### 34.1–34.16 AWS Services

```python
import boto3

# S3
s3 = boto3.client('s3')
s3.upload_file('local_file.txt', 'my-bucket', 'remote_file.txt')

# DynamoDB
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users')
table.put_item(Item={'user_id': '123', 'name': 'John', 'email': 'john@example.com'})

# SQS
sqs = boto3.client('sqs')
sqs.send_message(
    QueueUrl='https://sqs.us-east-1.amazonaws.com/123456789/my-queue',
    MessageBody=json.dumps({'order_id': '456'})
)

# SNS
sns = boto3.client('sns')
sns.publish(
    TopicArn='arn:aws:sns:us-east-1:123456789:my-topic',
    Message='New order received',
    Subject='Order Notification'
)
```

**อ้างอิง**: [AWS Lambda handler cookbook](https://raw.githubusercontent.com) 

---

### 34.17–34.26 Azure Services

```python
from azure.storage.blob import BlobServiceClient
from azure.cosmos import CosmosClient
from azure.servicebus import ServiceBusClient, ServiceBusMessage

# Blob Storage
blob_service = BlobServiceClient.from_connection_string(CONNECTION_STRING)
blob_client = blob_service.get_blob_client(container="data", blob="file.txt")
blob_client.upload_blob("Hello, Azure!")

# Cosmos DB
cosmos_client = CosmosClient(ENDPOINT, KEY)
database = cosmos_client.get_database_client("mydb")
container = database.get_container_client("users")
container.create_item({"id": "1", "name": "John"})

# Service Bus
with ServiceBusClient.from_connection_string(CONNECTION_STRING) as client:
    with client.get_queue_sender("my-queue") as sender:
        sender.send_messages(ServiceBusMessage("Hello"))
```

---

### 34.27–34.35 GCP Services

```python
from google.cloud import storage, bigquery, pubsub_v1

# Cloud Storage
storage_client = storage.Client()
bucket = storage_client.bucket("my-bucket")
blob = bucket.blob("file.txt")
blob.upload_from_string("Hello, GCP!")

# BigQuery
bq_client = bigquery.Client()
query = "SELECT COUNT(*) FROM `project.dataset.table`"
results = bq_client.query(query).result()

# Pub/Sub
publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path("project", "my-topic")
publisher.publish(topic_path, b"Hello, Pub/Sub!")
```

---

### 34.36–34.42 Serverless Frameworks

**Serverless Framework**:
```yaml
# serverless.yml
service: python-api
provider:
  name: aws
  runtime: python3.12
functions:
  hello:
    handler: handler.hello
    events:
      - http:
          path: hello
          method: get
```

**Chalice** (AWS):
```python
from chalice import Chalice

app = Chalice(app_name='python-api')

@app.route('/')
def index():
    return {'hello': 'world'}

@app.route('/users/{user_id}')
def get_user(user_id):
    return {'user_id': user_id}
```

**Mangum** (FastAPI + Lambda):
```python
from fastapi import FastAPI
from mangum import Mangum

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}

handler = Mangum(app)
```

---

### 34.43–34.49 Kubernetes Resources

```yaml
# ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  DATABASE_HOST: "postgres.default.svc.cluster.local"
  LOG_LEVEL: "INFO"

---
# Secret
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
data:
  DATABASE_PASSWORD: cG9zdGdyZXNfcGFzc3dvcmQ=  # base64

---
# Pod with resource limits
apiVersion: v1
kind: Pod
metadata:
  name: python-app
spec:
  containers:
  - name: app
    image: myapp:latest
    envFrom:
    - configMapRef:
        name: app-config
    - secretRef:
        name: app-secrets
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```

---

### 34.50–34.54 Helm, Kustomize, ArgoCD

**Helm chart structure**:
```
mychart/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
```

```yaml
# values.yaml
replicaCount: 3
image:
  repository: myapp
  tag: latest
resources:
  limits:
    cpu: 500m
    memory: 256Mi
```

```bash
helm install myapp ./mychart --values production.yaml
```

**ArgoCD Application**:
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: python-api
spec:
  project: default
  source:
    repoURL: https://github.com/user/k8s-manifests
    targetRevision: HEAD
    path: overlays/production
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

---

### 34.55–34.66 IaC Tools

**Terraform AWS provider**:
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  
  tags = {
    Name = "Python-Web-Server"
  }
}

resource "aws_rds_cluster" "postgres" {
  cluster_identifier = "python-app-db"
  engine             = "aurora-postgresql"
  database_name      = "appdb"
  master_username    = "dbadmin"
  master_password    = var.db_password
}
```

**Pulumi Python**:
```python
import pulumi
import pulumi_aws as aws

# สร้าง EC2 instance
instance = aws.ec2.Instance("web-server",
    instance_type="t3.micro",
    ami="ami-0c55b159cbfafe1f0",
    tags={"Name": "Python-Web-Server"}
)

# สร้าง RDS cluster
cluster = aws.rds.Cluster("app-db",
    engine="aurora-postgresql",
    database_name="appdb",
    master_username="dbadmin",
    master_password=pulumi.Config().require_secret("db_password")
)

pulumi.export("instance_ip", instance.public_ip)
```

**อ้างอิง**: [Real Python – Infrastructure as Code](https://realpython.com/ref/software-engineering-glossary/infrastructure-as-code/) 

---

### 34.67–34.78 Service Mesh และ API Gateway

**Istio VirtualService**:
```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: python-api
spec:
  hosts:
  - python-api
  http:
  - match:
    - headers:
        canary:
          exact: "true"
    route:
    - destination:
        host: python-api
        subset: v2
  - route:
    - destination:
        host: python-api
        subset: v1
      weight: 90
    - destination:
        host: python-api
        subset: v2
      weight: 10
```

**Kong API Gateway**:
```yaml
# kong.yml
_format_version: "3.0"
services:
- name: python-api
  url: http://python-api:8000
  routes:
  - name: api-route
    paths:
    - /api
    plugins:
    - name: rate-limiting
      config:
        minute: 100
```

---

### 34.79–34.83 Message Queues

**RabbitMQ**:
```python
import pika

connection = pika.BlockingConnection(
    pika.ConnectionParameters('localhost')
)
channel = connection.channel()

channel.queue_declare(queue='task_queue', durable=True)

channel.basic_publish(
    exchange='',
    routing_key='task_queue',
    body=json.dumps({'task': 'process_order', 'order_id': 123}),
    properties=pika.BasicProperties(delivery_mode=2)  # persistent
)
```

**NATS**:
```python
import asyncio
import nats

async def main():
    nc = await nats.connect("nats://localhost:4222")
    
    # Publish
    await nc.publish("orders.new", b'{"order_id": 123}')
    
    # Subscribe
    async def message_handler(msg):
        print(f"Received: {msg.data.decode()}")
    
    sub = await nc.subscribe("orders.*", cb=message_handler)
    await asyncio.sleep(1)
    await sub.unsubscribe()
    await nc.close()

asyncio.run(main())
```

---

### 34.84–34.88 Monitoring Stack

```yaml
# docker-compose.yml สำหรับ monitoring stack
version: '3.8'
services:
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
  
  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
  
  loki:
    image: grafana/loki:latest
    ports:
      - "3100:3100"
  
  tempo:
    image: grafana/tempo:latest
    ports:
      - "4317:4317"
```

**prometheus.yml**:
```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'python-api'
    static_configs:
      - targets: ['python-api:8000']
    metrics_path: /metrics
```

**อ้างอิง**: [Observability Practices with Prometheus and Grafana](https://github.com/EdgardChambeT/Observability-Practices-with-Prometheus-and-Grafana) 

---

### 34.89–34.94 Tracing และ APM

**Jaeger**:
```python
from jaeger_client import Config

config = Config(
    config={
        'sampler': {'type': 'const', 'param': 1},
        'logging': True,
    },
    service_name='python-api',
)
tracer = config.initialize_tracer()

with tracer.start_span('process_order') as span:
    span.set_tag('order_id', 123)
    # business logic
```

**Datadog**:
```python
from ddtrace import tracer, patch_all

patch_all()  # auto-instrument

@tracer.wrap(service="python-api", resource="process_order")
def process_order(order_id):
    # business logic
    pass
```

---

### 34.95–34.98 GitOps และ Platform Engineering

**Flux CD**:
```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: python-api
  namespace: flux-system
spec:
  interval: 1m
  url: https://github.com/user/k8s-manifests
  ref:
    branch: main

---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: python-api
  namespace: flux-system
spec:
  interval: 10m
  sourceRef:
    kind: GitRepository
    name: python-api
  path: ./overlays/production
  prune: true
  healthChecks:
  - apiVersion: apps/v1
    kind: Deployment
    name: python-api
    namespace: production
```

**Backstage catalog**:
```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: python-api
  description: Python API Service
  annotations:
    github.com/project-slug: user/python-api
    backstage.io/techdocs-ref: dir:.
spec:
  type: service
  lifecycle: production
  owner: team-backend
  providesApis:
  - python-api
```

---

## สรุป

หนังสือเล่ม 9 ครอบคลุมเนื้อหาด้าน Concurrency, Async, ประสิทธิภาพ, DevOps, Cloud, Deployment, SRE และ Distributed Systems อย่างครบถ้วน ตั้งแต่ GIL, Threading, Multiprocessing, Asyncio, Profiling, Docker, Kubernetes, Terraform, Prometheus, OpenTelemetry, CAP Theorem ไปจนถึง Chaos Engineering นักพัฒนาสามารถนำตัวอย่างโค้ดและแนวปฏิบัติไปใช้ในงานจริงได้ทันที

**แหล่งอ้างอิงหลัก**:
- [Real Python – Speed Up Python With Concurrency](https://realpython.com/courses/speed-python-concurrency/) 
- [concurrent.futures – Python Documentation](https://docs.python.org/3/library/concurrent.futures.html) 
- [Real Python – Async Programming in Python](https://realpython.com/python-async-features/) 
- [Performance Profiling & Optimisation (Python)](http://rse.shef.ac.uk/pando-python/) 
- [Enhancing performance – Duke University](https://people.duke.edu/~ccc14/bios-823-2020/notebooks/E05_Code_Optimization.html) 
- [Docker – Deploy your Python app](https://docs.docker.com.tw/guides/python/deploy/) 
- [Real Python – Infrastructure as Code](https://realpython.com/ref/software-engineering-glossary/infrastructure-as-code/) 
- [OpenTelemetry Python – Getting Started](https://opentelemetry.io/docs/languages/python/getting-started/) 
- [Distributed Systems Failure & Consistency Simulators](https://github.com/bhatti/simulators) 
- [Failure Flags – Python SDK](https://pypi.org/project/failureflags/) 
- [Observability Practices with Prometheus and Grafana](https://github.com/EdgardChambeT/Observability-Practices-with-Prometheus-and-Grafana) 
- [How to Implement Load Testing with Locust](https://raw.githubusercontent.com) 
- [AWS Lambda handler cookbook](https://raw.githubusercontent.com) 