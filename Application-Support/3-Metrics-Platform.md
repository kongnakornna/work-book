## เล่ม 3: Application Metrics & Metrics Platform — "หัวใจของ Observability"

> **กลุ่มงาน:** SRE, Monitoring Engineer, Application Support (Level 2+)
> **Dependency:** อ่านเล่ม 1 (Foundation & Workflow) และเล่ม 2 (Infrastructure & Network Monitoring) ก่อน
> **เวอร์ชัน:** 1.0

---

## บทนำ

### วัตถุประสงค์ของเล่ม

เล่มนี้เป็น **"หัวใจของ Observability"** เพราะครอบคลุมแพลตฟอร์ม Metrics ที่ทุกเล่มถัดไปต้องพึ่งพา ได้แก่ **Prometheus** (เก็บข้อมูล), **Grafana** (แสดงผล), และ **Alertmanager** (แจ้งเตือน) — เมื่ออ่านจบ ผู้อ่านจะสามารถ:

1. ออกแบบและติดตั้ง Metrics Platform ตั้งแต่ศูนย์ (Greenfield) จนพร้อมใช้งาน Production
2. Instrument Application (Python/Go/Node.js) ให้ปล่อย Metrics ตามมาตรฐาน **RED Method**
3. เขียน PromQL ที่ถูกต้องและมีประสิทธิภาพ (รวมถึง Recording Rules)
4. ตั้งค่า Alert Routing, Inhibition, และ Silence อย่างมีวินัย
5. สร้าง Dashboard ที่ตอบโจทย์ Incident Response (ไม่ใช่แค่สวย)

### เป้าหมายของเล่ม

| เป้าหมาย | ตัวชี้วัดความสำเร็จ |
|---|---|
| Metrics Platform พร้อมใช้ | Prometheus + Grafana + Alertmanager ทำงานครบวงจร |
| Application ปล่อย Metrics | ทุก Service มี `/metrics` endpoint ที่มี RED ครบ |
| Alert มีคุณภาพ | Alert ที่ fire มี Actionable > 90% (ไม่มี Noise) |
| Dashboard ตอบโจทย์ | MTTR ลดลงจากการเห็นข้อมูลเร็วขึ้น |

### สิ่งที่ **ไม่** อยู่ในเล่มนี้

- Infrastructure Metrics (CPU/RAM/Disk) → **เล่ม 2**
- Log Analysis (ELK) → **เล่ม 4**
- Kafka/Redis Observability → **เล่ม 5**
- Workflow PSR/RCA/KPI SMART → **เล่ม 1** (อ้างอิงกลับ)

---

## บทนิยาม (เฉพาะคำศัพท์ใหม่ในเล่มนี้)

| คำศัพท์ | ความหมาย |
|---|---|
| **RED Method** | ชุด Metrics 3 ตัวสำหรับ Service: **R**ate (Request/sec), **E**rrors (Error rate), **D**uration (Latency distribution) |
| **PromQL** | ภาษาคิวรีของ Prometheus สำหรับดึง/คำนวณ Time-Series |
| **Exposition Format** | รูปแบบข้อความ Plain-text ที่ Application ปล่อยที่ `/metrics` (`# HELP`, `# TYPE`, `metric_name{label="value"} 123`) |
| **Scrape** | การที่ Prometheus ดึง Metrics จาก Target ตาม interval ที่กำหนด (Pull Model) |
| **Recording Rule** | PromQL ที่คำนวณล่วงหน้าและเก็บเป็น Metric ใหม่ (名前 `record:xxx`) ลดภาระ Query ซ้ำ |
| **Remote Write** | การส่ง Metrics จาก Prometheus ไปยังปลายทางอื่น (InfluxDB, Thanos, VictoriaMetrics) |
| **Alert Rule** | นิพจน์ PromQL ที่เมื่อเงื่อนไขเป็นจริงต่อเนื่องตาม `for:` จะสร้าง Alert |
| **Routing Tree** | โครงสร้างต้นไม้ใน Alertmanager ที่กำหนดว่า Alert แต่ละประเภทจะไปยัง Receiver ใด |
| **Inhibition** | กฎที่ทำให้ Alert หนึ่งถูก suppress เมื่อมี Alert อีกตัวที่รุนแรงกว่ากำลัง fire อยู่ |
| **Silence** | การปิด Alert ชั่วคราวตาม Matcher (ใช้ตอน Maintenance) |
| **Histogram** | ประเภท Metric ที่เก็บการกระจายตัว (bucket) ใช้คำนวณ Percentile ผ่าน `histogram_quantile()` |
| **Summary** | ประเภท Metric ที่คำนวณ Quantile ฝั่ง Client (ข้อเสีย: merge ข้าม instance ไม่ได้) |
| **Service Discovery (SD)** | กลไกให้ Prometheus ค้นหา Target อัตโนมัติ (Kubernetes, Consul, EC2) |
| **Pushgateway** | ตัวกลางรับ Metrics แบบ Push สำหรับ Batch Job ที่อายุสั้น |
| **Exemplar** | ตัวอย่าง Trace ID ที่แนบมากับ Metrics (ใช้เชื่อม Metrics ↔ Traces) |

---

## บทหัวข้อ

---

## 3.3 Application Metrics (RED Method) + Instrumentation

### เรื่อง
การออกแบบและ implement Application Metrics ตามมาตรฐาน **RED Method** พร้อม Instrumentation ใน 3 ภาษา (Python, Go, Node.js)

### วัตถุประสงค์ / เป้าหมาย
- ให้ทุก Service ปล่อย Metrics ที่ตอบคำถาม: "Service นี้มีสุขภาพเป็นอย่างไร" ภายใน 3 ตัวชี้วัด
- ลด Cognitive Load ของ Support Engineer — ไม่ต้องจำ Metrics หลายร้อยตัว
- ทำให้ Dashboard และ Alert ใช้มาตรฐานเดียวกันทั้งองค์กร

### เนื้อหา / รายละเอียด

#### ทำไมต้อง RED (ไม่ใช่ USE)

| Method | ใช้กับ | Metrics |
|---|---|---|
| **USE** | Resource (CPU, Disk, Network) | Utilization, Saturation, Errors |
| **RED** | Service (API, Microservice) | Rate, Errors, Duration |

**กฎ:** ใช้ **USE** สำหรับ Infrastructure (เล่ม 2) และ **RED** สำหรับ Application (เล่ม 3) — อย่าสลับ

#### Metric Types ใน Prometheus

| Type | ลักษณะ | ใช้เมื่อ |
|---|---|---|
| **Counter** | เพิ่มอย่างเดียว รีเซ็ตเมื่อ restart | จำนวน Request, จำนวน Error |
| **Gauge** | ขึ้นลงได้ | Connection pool, Queue depth, Temperature |
| **Histogram** | เก็บ bucket ของค่า | Latency (แนะนำ!), Request size |
| **Summary** | คำนวณ quantile ฝั่ง client | Latency (เมื่อไม่ต้อง aggregate ข้าม instance) |

> **คำแนะนำ:** ใช้ **Histogram** สำหรับ Latency เสมอ เว้นแต่มีเหตุผลชัดเจน — เพราะ aggregate ข้าม instance ได้ด้วย `sum(rate(...))` แล้วค่อย `histogram_quantile()`

#### RED Metrics ที่ต้องมีในทุก Service

```
# R — Rate
http_requests_total{method, path, status}

# E — Errors (คำนวณจาก status >= 500)
http_requests_total{status=~"5.."}

# D — Duration (Histogram)
http_request_duration_seconds_bucket{le, method, path}
http_request_duration_seconds_sum
http_request_duration_seconds_count
```

#### Label Design (สำคัญมาก)

| Label | ควรใส่ | ไม่ควรใส่ |
|---|---|---|
| `method` | ✅ (GET/POST) | |
| `path` | ✅ (ใช้ route template เช่น `/users/:id` **ไม่ใช่** `/users/123`) | ❌ Raw path (Cardinality ระเบิด) |
| `status` | ✅ (200/500) | |
| `user_id` | ❌ | Cardinality Explosion |
| `request_id` | ❌ | ใช้ Exemplar แทน |

> **กฎเหล็ก:** **Cardinality** ต้อง < 10,000 ต่อ metric — ถ้าเกิน ให้ทบทวน Label

### การติดตั้ง / การตั้งค่า

#### Python (Flask/FastAPI) — `prometheus_client`

```python
# requirements.txt
# prometheus-client==0.20.0
# prometheus-fastapi-instrumentator==7.0.0

from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI()
Instrumentator().instrument(app).expose(app)   # /metrics พร้อม RED

# Custom metric ตัวอย่าง
from prometheus_client import Counter, Histogram, Gauge

order_created = Counter(
    "order_created_total", "Total orders created", ["channel", "status"]
)
order_value = Histogram(
    "order_value_thb", "Order value in THB",
    buckets=[100, 500, 1000, 5000, 10000, 50000]
)
active_sessions = Gauge("active_sessions", "Currently active sessions")

@app.post("/orders")
def create_order(channel: str, value: float):
    order_created.labels(channel=channel, status="success").inc()
    order_value.observe(value)
    return {"ok": True}
```

#### Go — `promhttp`

```go
// go.mod: github.com/prometheus/client_golang v1.19.0
package main

import (
    "net/http"
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promauto"
    "github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
    httpRequests = promauto.NewCounterVec(prometheus.CounterOpts{
        Name: "http_requests_total",
        Help: "Total HTTP requests",
    }, []string{"method", "path", "status"})

    httpDuration = promauto.NewHistogramVec(prometheus.HistogramOpts{
        Name:    "http_request_duration_seconds",
        Help:    "HTTP request latency",
        Buckets: []float64{0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10},
    }, []string{"method", "path"})
)

func metricsMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        timer := prometheus.NewTimer(httpDuration.WithLabelValues(r.Method, r.URL.Path))
        defer timer.ObserveDuration()
        rw := &statusRecorder{ResponseWriter: w, status: 200}
        next.ServeHTTP(rw, r)
        httpRequests.WithLabelValues(r.Method, r.URL.Path, http.StatusText(rw.status)).Inc()
    })
}

func main() {
    http.Handle("/metrics", promhttp.Handler())
    // ... routes
}
```

#### Node.js (Express) — `prom-client`

```javascript
// npm i prom-client@15
const client = require('prom-client');
const register = new client.Registry();
client.collectDefaultMetrics({ register });

const httpRequests = new client.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'path', 'status'],
  registers: [register],
});

const httpDuration = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request latency',
  labelNames: ['method', 'path'],
  buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5],
  registers: [register],
});

app.use((req, res, next) => {
  const end = httpDuration.startTimer({ method: req.method, path: req.route?.path || req.path });
  res.on('finish', () => {
    end();
    httpRequests.inc({ method: req.method, path: req.route?.path || req.path, status: res.statusCode });
  });
  next();
});

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุที่เป็นไปได้ | แนวทางแก้ไข |
|---|---|---|
| `/metrics` ตอบช้า (>1s) | Cardinality สูง, Metric เยอะเกิน | ทบทวน Label, ลบ Metric ที่ไม่ใช้ |
| Latency P99 กระโดด แต่ Average ปกติ | มี Slow request บางส่วน | ดู Histogram bucket ที่ `le="5"` ขึ้นไป |
| Error rate สูง แต่ log ไม่มี error | Error ถูก catch แต่ไม่ Inc counter | เพิ่ม `.inc()` ใน error handler |
| Metrics หายหลัง restart | Counter รีเซ็ต | ใช้ `rate()` ไม่ใช่ `increase()` ตรงๆ — Prometheus จัดการ reset ได้ |

### ลำดับการจัดการปัญหา (Metrics ไม่มา)

1. `curl http://<app>:<port>/metrics` — endpoint ทำงานไหม
2. ดู Prometheus → Status → Targets — Target UP ไหม
3. ถ้า DOWN: เช็ค Network/Firewall/Port
4. ถ้า UP แต่ไม่มี metric: ชื่อ metric ตรงกับที่ query ไหม (`{__name__=~".*order.*"}`)
5. ถ้า metric มีแต่ค่า 0: Code path ที่ Inc ถูกเรียกหรือยัง

### Template Code
→ ดูโค้ด Python/Go/Node ด้านบน

### Template Dashboard
→ ใช้ **Application RED Dashboard** (JSON อยู่ในหัวข้อ 3.9)

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** มาตรฐานเดียวทั้งองค์กร, Alert แม่นยำ, Dashboard เรียบง่าย
- **ข้อควรระวัง:** Cardinality Explosion, Label ที่เปลี่ยนค่าทุก request
- **ข้อดี:** ตอบโจทย์ SRE/SLI/SLO ได้ตรง, เปรียบเทียบ Service ต่างกันได้
- **ข้อเสีย:** RED ไม่ครอบคลุม Saturation — ต้องใช้ USE (เล่ม 2) เสริม
- **ข้อห้าม:** ❌ ใส่ `user_id`, `request_id`, `email` เป็น Label — ❌ ใช้ path ที่มี UUID

### ตัวอย่าง (Anti-pattern)

```python
# ❌ ผิด — Cardinality ระเบิด
http_requests.labels(path=f"/users/{user_id}").inc()

# ✅ ถูก
http_requests.labels(path="/users/:id").inc()
```

### สรุปย่อเพื่อจดจำ
> **RED = Rate, Errors, Duration** — Histogram สำหรับ Latency — Label น้อยแต่มีประโยชน์ — Cardinality < 10K

### แหล่งที่มา
- Google SRE Workbook, Chapter 6 (Monitoring)
- Prometheus Best Practices: https://prometheus.io/docs/practices/naming/
- Tom Wilkie, "RED Method" (2018)

---

## 3.11 Prometheus (ติดตั้ง, `prometheus.yml`, PromQL, Recording Rules, Remote Write)

### เรื่อง
การติดตั้ง Prometheus แบบ Production-grade พร้อม Config ที่รองรับ Static + Kubernetes SD + Pushgateway

### วัตถุประสงค์ / เป้าหมาย
- มี Prometheus Server ที่พร้อมรับ Metrics จากทุก Target
- Config ที่ maintainable (แยกไฟล์, ใช้ SD อัตโนมัติ)
- มี Recording Rules สำหรับ Query ที่ใช้บ่อย
- มี Remote Write ไปยัง Long-term Storage

### เนื้อหา / รายละเอียด

#### สถาปัตยกรรม

```
┌─────────────┐   Pull   ┌──────────────┐   Query  ┌─────────┐
│  Targets    │◀────────│  Prometheus  │◀─────────│ Grafana │
│ (App/Host)  │  /metrics│   Server     │          └─────────┘
└─────────────┘          │  + TSDB      │
                         │  + Rules     │────▶ Alert ──▶ Alertmanager
                         └──────┬───────┘
                                │ Remote Write
                                ▼
                         ┌──────────────┐
                         │ InfluxDB /   │
                         │ Thanos       │
                         └──────────────┘
```

#### Pull vs Push

| Model | ใช้เมื่อ | ตัวอย่าง |
|---|---|---|
| **Pull** | Service อายุยาว | Web API, DB Exporter |
| **Push (Pushgateway)** | Batch job อายุสั้น | Cron job, Lambda |
| **Push (Remote Write)** | ส่งออกจาก Prometheus | Multi-cluster federation |

### การติดตั้ง / การตั้งค่า

#### Docker Compose (Production-ready)

```yaml
version: "3.8"
services:
  prometheus:
    image: prom/prometheus:v2.53.0
    container_name: prometheus
    restart: unless-stopped
    user: "65534:65534"           # nobody — security
    command:
      - "--config.file=/etc/prometheus/prometheus.yml"
      - "--storage.tsdb.path=/prometheus"
      - "--storage.tsdb.retention.time=15d"
      - "--storage.tsdb.retention.size=50GB"
      - "--web.enable-lifecycle"            # hot-reload
      - "--web.enable-remote-write-receiver"
      - "--web.enable-admin-api"
      - "--log.level=info"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - ./rules:/etc/prometheus/rules:ro
      - prom-data:/prometheus
    ports:
      - "9090:9090"
    networks: [monitoring]

volumes:
  prom-data:

networks:
  monitoring:
    driver: bridge
```

#### `prometheus.yml` — ครบทุกโหมด

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  scrape_timeout: 10s
  external_labels:
    cluster: prod-th-1
    environment: production

# =========================
# Alertmanager
# =========================
alerting:
  alertmanagers:
    - static_configs:
        - targets: ["alertmanager:9093"]
      timeout: 10s

# =========================
# Rule files
# =========================
rule_files:
  - "/etc/prometheus/rules/*.yml"

# =========================
# Scrape configs
# =========================
scrape_configs:

  # --- 1) Prometheus itself
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  # --- 2) Static targets: Exporter
  - job_name: "node"
    static_configs:
      - targets:
          - "node-exporter-01:9100"
          - "node-exporter-02:9100"
        labels:
          env: prod

  # --- 3) Application Services (Static)
  - job_name: "app-services"
    metrics_path: /metrics
    scrape_interval: 10s
    static_configs:
      - targets: ["order-api:8000", "billing-api:8000"]
        labels:
          team: backend
          tier: critical
    relabel_configs:
      - source_labels: [__address__]
        regex: "(.+):(\\d+)"
        target_label: instance
        replacement: "$1"

  # --- 4) Kubernetes Service Discovery
  - job_name: "kubernetes-pods"
    kubernetes_sd_configs:
      - role: pod
        namespaces:
          names: ["prod", "staging"]
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: "true"
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        target_label: __address__
      - source_labels: [__meta_kubernetes_pod_label_app]
        target_label: app
      - source_labels: [__meta_kubernetes_namespace]
        target_label: namespace
      - source_labels: [__meta_kubernetes_pod_name]
        target_label: pod

  # --- 5) Pushgateway
  - job_name: "pushgateway"
    honor_labels: true           # important: keep pushed labels
    static_configs:
      - targets: ["pushgateway:9091"]

  # --- 6) Remote write receiver (optional)
```

> **Tip:** `honor_labels: true` ที่ Pushgateway — เพื่อให้ label ที่ Batch job push มา (`job`, `instance`) ไม่ถูกเขียนทับด้วย `job="pushgateway"`

### PromQL — RED Metrics ครบชุด

```promql
# ── RATE ─────────────────────────────────────────────
# Request per second รวมทุก path
sum(rate(http_requests_total[5m]))

# Request per second แยกตาม service
sum by (job) (rate(http_requests_total[5m]))

# ── ERRORS ───────────────────────────────────────────
# Error Rate (%)
sum(rate(http_requests_total{status=~"5.."}[5m]))
  / sum(rate(http_requests_total[5m])) * 100

# Error budget burn (5m)
sum(rate(http_requests_total{status=~"5.."}[5m]))

# ── DURATION ─────────────────────────────────────────
# P50/P90/P99 latency
histogram_quantile(0.50, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))
histogram_quantile(0.90, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))
histogram_quantile(0.99, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))

# P99 per route
histogram_quantile(0.99,
  sum by (le, path) (rate(http_request_duration_seconds_bucket[5m]))
)

# Average latency (ใช้เป็น secondary — อย่าใช้ตัดสินใจคนเดียว)
rate(http_request_duration_seconds_sum[5m])
  / rate(http_request_duration_seconds_count[5m])

# ── APDEX (Application Performance Index) ────────────
(
  sum(rate(http_request_duration_seconds_bucket{le="0.3"}[5m]))
  + sum(rate(http_request_duration_seconds_bucket{le="1.2"}[5m]))
) / 2 / sum(rate(http_request_duration_seconds_count[5m]))

# ── SATURATION (Supplementary) ───────────────────────
# In-flight requests
sum by (job) (http_requests_in_flight)
```

### Recording Rules

```yaml
# rules/app-red.yml
groups:
  - name: app-red
    interval: 30s
    rules:

      - record: job:http_requests:rate5m
        expr: sum by (job) (rate(http_requests_total[5m]))

      - record: job:http_errors:rate5m
        expr: sum by (job) (rate(http_requests_total{status=~"5.."}[5m]))

      - record: job:http_error_ratio:rate5m
        expr: |
          job:http_errors:rate5m
            / job:http_requests:rate5m

      - record: job:http_request_duration_seconds:p99_5m
        expr: |
          histogram_quantile(0.99,
            sum by (job, le) (rate(http_request_duration_seconds_bucket[5m]))
          )

      - record: job:http_request_duration_seconds:p50_5m
        expr: |
          histogram_quantile(0.50,
            sum by (job, le) (rate(http_request_duration_seconds_bucket[5m]))
          )
```

> **ทำไมต้อง Recording Rules:** Dashboard ที่ query `histogram_quantile(...)` ทุกครั้งจะช้าเมื่อข้อมูลเยอะ — Record ไว้จะเร็วกว่า 10–100×

### Remote Write (ไป InfluxDB / Thanos)

```yaml
remote_write:
  - url: "http://influxdb:8086/api/v1/prom/write?db=prometheus&rp=autogen"
    queue_config:
      capacity: 10000
      max_shards: 200
      max_samples_per_send: 5000
      batch_send_deadline: 5s
      min_backoff: 30ms
      max_backoff: 5s
    write_relabel_configs:
      # ไม่ส่ง metric ที่ cardinality สูงมาก
      - source_labels: [__name__]
        regex: "go_.*"
        action: drop
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| Target DOWN | Network, port, หรือ exporter ตาย | `curl` จาก Prometheus container ไปยัง target |
| Query timeout | Query กว้างเกิน, ไม่มี Record | เพิ่ม Recording Rule, ลด range |
| "too many samples" | Cardinality สูง | Drop metric ที่ไม่ใช้ใน `metric_relabel_configs` |
| TSDB disk เต็ม | Retention ยาวไป | ลด retention หรือ remote write ออก |

### ลำดับการจัดการปัญหา

1. `promtool check config prometheus.yml` — config ถูกไหม
2. UI → Status → Targets — Target UP?
3. UI → Status → Configuration — config โหลดหรือยัง
4. UI → Graph — query ทำงานไหม
5. ถ้า query ได้แต่ไม่ใช่ค่าที่คาด: ใช้ `curl /metrics | grep <name>` ที่ target

### Template Code
→ ดู `prometheus.yml` ด้านบน

### Template Dashboard
→ ดู 3.9

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** Source of truth ของ Metrics ทั้งหมด
- **ข้อควรระวัง:** Prometheus **ไม่ใช่** Long-term storage — ต้อง Remote Write ถ้าเก็บ >30 วัน
- **ข้อดี:** Pull Model ตรวจ Target DOWN ได้เอง, PromQL ทรงพลัง
- **ข้อเสีย:** Single-node (ไม่ HA โดยตัวมันเอง — ใช้ Thanos/Mimir เสริม)
- **ข้อห้าม:** ❌ ใช้ Prometheus แทน Log DB — ❌ เก็บ Cardinality > 1M samples

### ตัวอย่าง (Kubernetes SD Annotation)

```yaml
# Pod annotation ที่ทำให้ Prometheus auto-discover
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8000"
    prometheus.io/path: "/metrics"
```

### สรุปย่อเพื่อจดจำ
> **Prometheus** = Pull + TSDB + PromQL — Retention สั้น ตั้ง Remote Write — Recording Rule สำหรับ query หนัก — `promtool` ตรวจ config ก่อน deploy

### แหล่งที่มา
- https://prometheus.io/docs/
- Brian Brazil, *Prometheus: Up & Running* (O'Reilly, 2nd ed., 2023)
- https://prometheus.io/docs/practices/recording_rules/

---

## 3.9 Grafana (ติดตั้ง, Provisioning Data Source, Dashboard JSON)

### เรื่อง
การติดตั้ง Grafana และ Provisioning Data Source/Dashboard แบบ Code (Infrastructure-as-Code)

### วัตถุประสงค์ / เป้าหมาย
- Grafana ที่ provision จาก config (ไม่ใช่ manual click)
- Dashboard ที่ version-controlled ใน Git
- **Application RED Dashboard** พร้อมใช้

### เนื้อหา / รายละเอียด

#### Data Source ที่ควรมี

| Data Source | ใช้กับ | หมายเหตุ |
|---|---|---|
| Prometheus | Metrics (เล่ม 3, 5, 7) | Default |
| InfluxDB | Long-term metrics (เล่ม 4) | ถ้า Remote Write |
| Loki / Elasticsearch | Logs (เล่ม 4) | สำหรับ Log panel |
| Tempo / Jaeger | Traces | ถ้ามี Tracing |

### การติดตั้ง / การตั้งค่า

```yaml
# docker-compose (ต่อจาก Prometheus)
  grafana:
    image: grafana/grafana:11.1.0
    container_name: grafana
    restart: unless-stopped
    environment:
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_PASSWORD}
      GF_USERS_ALLOW_SIGN_UP: "false"
      GF_INSTALL_PLUGINS: ""
    volumes:
      - grafana-data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning:ro
      - ./grafana/dashboards:/var/lib/grafana/dashboards:ro
    ports:
      - "3000:3000"
    networks: [monitoring]

volumes:
  grafana-data:
```

#### Provisioning: Data Source

```yaml
# grafana/provisioning/datasources/prometheus.yml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: false
    jsonData:
      timeInterval: "15s"
      httpMethod: POST
      exemplarTraceIdDestinations:
        - name: trace_id
          datasourceUid: tempo
```

#### Provisioning: Dashboard Provider

```yaml
# grafana/provisioning/dashboards/default.yml
apiVersion: 1
providers:
  - name: "app-dashboards"
    orgId: 1
    folder: "Application"
    type: file
    disableDeletion: false
    updateIntervalSeconds: 30
    allowUiUpdates: false        # บังคับให้แก้ผ่าน Git
    options:
      path: /var/lib/grafana/dashboards
```

### Template Dashboard — Application RED Dashboard (JSON ย่อ)

```json
{
  "title": "Application RED — ${service}",
  "uid": "app-red-v1",
  "tags": ["red", "application"],
  "templating": {
    "list": [
      {
        "name": "service",
        "type": "query",
        "datasource": {"type": "prometheus", "uid": "prometheus"},
        "query": "label_values(http_requests_total, job)",
        "refresh": 1,
        "multi": true,
        "includeAll": true
      },
      {
        "name": "range",
        "type": "interval",
        "query": "1m,5m,15m,1h",
        "current": {"text": "5m", "value": "5m"}
      }
    ]
  },
  "panels": [
    {
      "id": 1, "type": "stat", "title": "Request Rate (req/s)",
      "gridPos": {"h": 6, "w": 6, "x": 0, "y": 0},
      "targets": [{
        "expr": "sum(rate(http_requests_total{job=~\"$service\"}[$range]))",
        "legendFormat": "Total"
      }]
    },
    {
      "id": 2, "type": "stat", "title": "Error Rate (%)",
      "gridPos": {"h": 6, "w": 6, "x": 6, "y": 0},
      "targets": [{
        "expr": "sum(rate(http_requests_total{job=~\"$service\",status=~\"5..\"}[$range])) / sum(rate(http_requests_total{job=~\"$service\"}[$range])) * 100"
      }],
      "fieldConfig": {"defaults": {
        "unit": "percent",
        "thresholds": {"steps": [
          {"color": "green", "value": null},
          {"color": "yellow", "value": 1},
          {"color": "red", "value": 5}
        ]}
      }}
    },
    {
      "id": 3, "type": "stat", "title": "P99 Latency",
      "gridPos": {"h": 6, "w": 6, "x": 12, "y": 0},
      "targets": [{
        "expr": "histogram_quantile(0.99, sum by (le) (rate(http_request_duration_seconds_bucket{job=~\"$service\"}[$range])))"
      }],
      "fieldConfig": {"defaults": {"unit": "s"}}
    },
    {
      "id": 4, "type": "stat", "title": "Apdex",
      "gridPos": {"h": 6, "w": 6, "x": 18, "y": 0},
      "targets": [{
        "expr": "(sum(rate(http_request_duration_seconds_bucket{job=~\"$service\",le=\"0.3\"}[$range])) + sum(rate(http_request_duration_seconds_bucket{job=~\"$service\",le=\"1.2\"}[$range]))) / 2 / sum(rate(http_request_duration_seconds_count{job=~\"$service\"}[$range]))"
      }],
      "fieldConfig": {"defaults": {"unit": "percentunit", "max": 1, "min": 0}}
    },
    {
      "id": 10, "type": "timeseries", "title": "Request Rate by Status",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 6},
      "targets": [{
        "expr": "sum by (status) (rate(http_requests_total{job=~\"$service\"}[$range]))",
        "legendFormat": "{{status}}"
      }]
    },
    {
      "id": 11, "type": "timeseries", "title": "Latency P50/P90/P99",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 6},
      "targets": [
        {"expr": "histogram_quantile(0.50, sum by (le) (rate(http_request_duration_seconds_bucket{job=~\"$service\"}[$range])))", "legendFormat": "P50"},
        {"expr": "histogram_quantile(0.90, sum by (le) (rate(http_request_duration_seconds_bucket{job=~\"$service\"}[$range])))", "legendFormat": "P90"},
        {"expr": "histogram_quantile(0.99, sum by (le) (rate(http_request_duration_seconds_bucket{job=~\"$service\"}[$range])))", "legendFormat": "P99"}
      ],
      "fieldConfig": {"defaults": {"unit": "s"}}
    }
  ],
  "time": {"from": "now-1h", "to": "now"},
  "refresh": "30s",
  "schemaVersion": 39
}
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| Dashboard ช้า | Query เยอะ/หนัก | ใช้ Recording Rule, ลด panel, ลด `$range` |
| Data source "not found" | UID ไม่ตรง | ใช้ fixed UID ใน provisioning |
| Provisioning ไม่โหลด | Path ผิด/permission | ตรวจ `GF_PATHS_PROVISIONING` และ mount |
| Dashboard แก้ใน UI ไม่ save | `allowUiUpdates: false` | ตั้งใจ — แก้ที่ Git เท่านั้น |

### ลำดับการจัดการปัญหา

1. Grafana → Configuration → Data Sources → Test
2. ถ้า test fail: `curl prometheus:9090/-/healthy` จาก grafana container
3. Dashboard ไม่ขึ้น: ตรวจ provisioning log (`docker logs grafana | grep -i provision`)
4. Panel ไม่มีข้อมูล: ใช้ Explore mode query ตรงก่อน

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** Visualization ที่ยืดหยุ่น, Provisioning-as-Code
- **ข้อควรระวัง:** อย่าแก้ Dashboard ใน UI — แก้ใน Git
- **ข้อดี:** รองรับหลาย data source, Alerting ในตัว (แต่ใช้ Alertmanager ดีกว่า)
- **ข้อเสีย:** ต้องจัดการ JSON เยอะ (ใช้ Grafana Terraform Provider ช่วยได้)
- **ข้อห้าม:** ❌ เก็บ credential ใน Dashboard JSON — ❌ ใช้ Dashboard แทน Log (ใช้ Kibana)

### ตัวอย่าง (Grafana Terraform)

```hcl
resource "grafana_data_source" "prometheus" {
  type = "prometheus"
  name = "Prometheus"
  url  = "http://prometheus:9090"
  is_default = true
}
```

### สรุปย่อเพื่อจดจำ
> **Grafana** — Provision จาก Git — Data Source UID ต้องตรง — Dashboard ใช้ templating `$service` — อย่าแก้ใน UI

### แหล่งที่มา
- https://grafana.com/docs/grafana/latest/administration/provisioning/
- https://grafana.com/grafana/dashboards/ (Community Dashboards)

---

## 3.10 Alertmanager (`alertmanager.yml` เต็ม, Routing Tree, Inhibition, Silence)

### เรื่อง
การตั้งค่า Alertmanager แบบ Production — Routing, Grouping, Inhibition, Silence

### วัตถุประสงค์ / เป้าหมาย
- Alert ไปถึงคนที่ถูกคนและเวลาที่เหมาะสม
- ไม่มี Alert ซ้ำ (Grouping)
- ไม่มี Alert ที่ไม่ actionable (Inhibition + Silence)

### เนื้อหา / รายละเอียด

#### หลักคิด 4 ข้อ

1. **Grouping** — รวม Alert ที่คล้ายกันส่งครั้งเดียว (`group_by: [alertname, cluster]`)
2. **Routing** — แยกตาม team/severity (Routing Tree)
3. **Inhibition** — suppress alert รอง เมื่อมี alert หลัก fire
4. **Silence** — ปิดชั่วคราวตอน maintenance

#### Severity Convention

| Severity | ความหมาย | SLA ตอบสนอง | ปลายทาง |
|---|---|---|---|
| `critical` | Production down / SLO burn | < 15 min | PagerDuty + Slack |
| `warning` | Degraded / ใกล้ burn | < 1 hour | Slack |
| `info` | Trend / capacity | < 1 day | Slack (low-priority) |

### การติดตั้ง / การตั้งค่า

```yaml
# docker-compose (ต่อ)
  alertmanager:
    image: prom/alertmanager:v0.27.0
    container_name: alertmanager
    restart: unless-stopped
    volumes:
      - ./alertmanager.yml:/etc/alertmanager/alertmanager.yml:ro
      - alertmanager-data:/alertmanager
    command:
      - "--config.file=/etc/alertmanager/alertmanager.yml"
      - "--storage.path=/alertmanager"
      - "--web.external-url=http://alertmanager.local:9093"
    ports:
      - "9093:9093"
    networks: [monitoring]

volumes:
  alertmanager-data:
```

#### `alertmanager.yml` — ครบทุกองค์ประกอบ

```yaml
global:
  resolve_timeout: 5m
  smtp_from: "alerts@example.com"
  smtp_smarthost: "smtp.example.com:587"
  smtp_auth_username: "alerts@example.com"
  smtp_auth_password_file: "/etc/alertmanager/smtp_pass"
  smtp_require_tls: true
  slack_api_url_file: "/etc/alertmanager/slack_url"

# =========================
# Templates (optional)
# =========================
templates:
  - "/etc/alertmanager/templates/*.tmpl"

# =========================
# Routing Tree
# =========================
route:
  receiver: "slack-default"
  group_by: ["alertname", "cluster", "service"]
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h

  routes:
    # 1) Critical → PagerDuty + Slack
    - matchers:
        - severity = "critical"
      receiver: "pagerduty-critical"
      group_wait: 10s
      group_interval: 2m
      repeat_interval: 1h
      continue: true          # ส่งต่อให้ rule ถัดไปด้วย

    - matchers:
        - severity = "critical"
      receiver: "slack-critical"

    # 2) Team-specific routing
    - matchers:
        - team = "erp"
        - severity = "warning"
      receiver: "slack-erp"
      repeat_interval: 2h

    - matchers:
        - team = "crm"
        - severity = "warning"
      receiver: "slack-crm"

    # 3) DB alerts ไป DBA
    - matchers:
        - alertname =~ "Postgres.*|Oracle.*|Mongo.*"
      receiver: "slack-dba"
      repeat_interval: 2h

    # 4) Info → email digest
    - matchers:
        - severity = "info"
      receiver: "email-info"
      repeat_interval: 24h

# =========================
# Inhibition Rules
# =========================
inhibit_rules:

  # ถ้า critical อยู่ — suppress warning ของ alertname เดียวกัน instance เดียวกัน
  - source_matchers:
      - severity = "critical"
    target_matchers:
      - severity = "warning"
    equal: ["alertname", "instance"]

  # ถ้า ServiceDown — suppress alert อื่นทั้งหมดของ service นั้น
  - source_matchers:
      - alertname = "ServiceDown"
    target_matchers:
      - severity =~ "warning|critical"
    equal: ["job", "instance"]

  # ถ้า Node Down — suppress alert ของ pod บน node นั้น
  - source_matchers:
      - alertname = "NodeDown"
    target_matchers:
      - severity != "critical"
    equal: ["node"]

# =========================
# Receivers
# =========================
receivers:

  - name: "slack-default"
    slack_configs:
      - channel: "#alerts-default"
        send_resolved: true
        title: '{{ template "slack.title" . }}'
        text: '{{ template "slack.text" . }}'

  - name: "slack-critical"
    slack_configs:
      - channel: "#alerts-critical"
        send_resolved: true
        color: '{{ if eq .Status "firing" }}danger{{ else }}good{{ end }}'
        title: '🔥 CRITICAL: {{ .GroupLabels.alertname }}'
        text: |
          *Summary:* {{ range .Alerts }}{{ .Annotations.summary }}{{ end }}
          *Cluster:* {{ .GroupLabels.cluster }}
          *Runbook:* {{ range .Alerts }}{{ .Annotations.runbook_url }}{{ end }}

  - name: "slack-erp"
    slack_configs:
      - channel: "#erp-alerts"
        send_resolved: true

  - name: "slack-crm"
    slack_configs:
      - channel: "#crm-alerts"
        send_resolved: true

  - name: "slack-dba"
    slack_configs:
      - channel: "#dba-alerts"
        send_resolved: true

  - name: "pagerduty-critical"
    pagerduty_configs:
      - routing_key_file: "/etc/alertmanager/pagerduty_key"
        description: '{{ .GroupLabels.alertname }} on {{ .GroupLabels.cluster }}'
        severity: 'critical'
        details:
          service: '{{ .GroupLabels.service }}'
          summary: '{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}'

  - name: "email-info"
    email_configs:
      - to: "ops-info@example.com"
        send_resolved: false
        headers:
          Subject: '[INFO] {{ .GroupLabels.alertname }}'
```

#### Alert Rules ที่ควรมี

```yaml
# rules/app-alerts.yml
groups:
  - name: app-slo
    rules:

      - alert: HighErrorRate
        expr: |
          job:http_error_ratio:rate5m > 0.05
        for: 5m
        labels:
          severity: critical
          team: backend
        annotations:
          summary: "Error rate > 5% on {{ $labels.job }}"
          description: "{{ $value | humanizePercentage }} of requests failing for 5m"
          runbook_url: "https://wiki.example.com/runbook/high-error-rate"

      - alert: HighLatencyP99
        expr: |
          job:http_request_duration_seconds:p99_5m > 2
        for: 10m
        labels:
          severity: warning
          team: backend
        annotations:
          summary: "P99 latency {{ $value }}s on {{ $labels.job }}"
          runbook_url: "https://wiki.example.com/runbook/high-latency"

      - alert: TrafficDrop
        expr: |
          (job:http_requests:rate5m
            / (job:http_requests:rate5m offset 1h)) < 0.5
          and job:http_requests:rate5m > 0
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Traffic drop > 50% on {{ $labels.job }}"

      - alert: ServiceDown
        expr: up{job=~".+"} == 0
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Target {{ $labels.instance }} down"
```

### `amtool` — ทดสอบ Routing ก่อน deploy

```bash
# ตรวจ config
amtool check-config alertmanager.yml

# ดู routing tree
amtool config routes show alertmanager.yml

# ทดสอบว่า alert จะไปที่ receiver ไหน
amtool config routes test \
  --config.file=alertmanager.yml \
  severity=critical team=backend alertname=HighErrorRate

# ทดสอบหลายชุด
amtool config routes test alertmanager.yml \
  severity=warning team=erp alertname=KafkaLag

# Query alert ที่กำลัง fire
amtool alert query --alertmanager.url=http://localhost:9093

# สร้าง Silence (ตอน maintenance)
amtool silence add \
  --alertmanager.url=http://localhost:9093 \
  --author="ops-oncall" \
  --comment="Planned maintenance 2025-01-15 02:00-04:00" \
  --duration=2h \
  --match='cluster="prod-th-1"' \
  --match='severity=~"warning|critical"'
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| Alert ไม่มา | Routing tree ตัด, inhibition | `amtool config routes test` |
| Alert ซ้ำเยอะ | `group_by` แคบไป, `repeat_interval` สั้น | ขยาย `group_by`, เพิ่ม `repeat_interval` |
| Alert มาจาก instance ที่ down | ไม่มี inhibition | เพิ่ม inhibition rule (ServiceDown) |
| Alert ระหว่าง maintenance | ไม่มี silence | ใช้ `amtool silence add` |
| PagerDuty ไม่ยิง | routing_key ผิด | ตรวจ secret + PagerDuty events API |

### ลำดับการจัดการปัญหา

1. `amtool check-config` — config valid?
2. `amtool config routes test <labels>` — ไป receiver ที่ถูก?
3. ดู Alertmanager UI (9093) → Alerts — Alert อยู่สถานะใด (suppressed/inhibited/firing)
4. ดู Silence list — มี silence ครอบอยู่?
5. ตรวจ Receiver credential (Slack webhook, PagerDuty key)

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** Alert ถึงคนถูกคน, ไม่มี noise
- **ข้อควรระวัง:** `continue: true` ต้องวางให้ถูก — ไม่งั้น alert ถูกส่งซ้ำที่เดียว
- **ข้อดี:** Routing Tree ทรงพลัง, Inhibit/Silence ลด noise ได้มาก
- **ข้อเสีย:** Config ยากต่อ debug — ต้องใช้ `amtool`
- **ข้อห้าม:** ❌ Alert ทุก metric (alert fatigue) — ❌ `repeat_interval` < 1h สำหรับ warning

### ตัวอย่าง (Slack Template)

```gotmpl
{{/* templates/slack.tmpl */}}
{{ define "slack.title" }}
[{{ .Status | toUpper }}] {{ .GroupLabels.alertname }} ({{ len .Alerts }} alerts)
{{ end }}

{{ define "slack.text" }}
{{ range .Alerts }}
• *{{ .Labels.job }}* / {{ .Labels.instance }}: {{ .Annotations.summary }}
{{ end }}
{{ end }}
```

### สรุปย่อเพื่อจดจำ
> **Alertmanager** — Grouping + Routing + Inhibition + Silence — `amtool check-config` และ `routes test` ก่อน deploy — severity 3 ระดับ (critical/warning/info) — อย่าให้ warning ยิง PagerDuty

### แหล่งที่มา
- https://prometheus.io/docs/alerting/latest/alertmanager/
- Rob Ewaschuk, "My Philosophy on Alerting" (Google SRE)
- https://www.prometheus.io/docs/alerting/latest/configuration/

---

## Workflow (อ้างอิงเล่ม 1 + Incident Playbook เฉพาะเล่ม)

### อ้างอิง Workflow หลักจากเล่ม 1

| Workflow | ใช้ในเล่มนี้เมื่อ |
|---|---|
| **PSR (Problem-Solution-Result)** | เขียนรายงานหลังจบ Incident ที่เกี่ยวกับ Metrics Platform |
| **RCA 5 Whys** | หาสาเหตุรากของ Alert ที่ fire ซ้ำ |
| **KPI SMART** | ตั้ง KPI ของ Metrics Platform (เช่น MTTA < 5m, Actionable Alert > 90%) |

→ Template เต็มอยู่ใน **เล่ม 1 หัวข้อ 4**

### Incident Playbook เฉพาะเล่ม 3

#### Playbook A: Alert ไม่มาเลย (No Alert Firing)

1. **ตรวจ Prometheus Targets** — `Status → Targets` — UP ทั้งหมด?
2. **ตรวจ Rule** — `Status → Rules` — Rule โหลดอยู่? มี error?
3. **ตรวจ Expression** — Graph → ใส่ PromQL ของ rule — ให้ผลลัพธ์ตรง?
4. **ตรวจ `for:` duration** — นานเกินไปจนไม่ fire?
5. **ตรวจ Alertmanager** — UI 9093 → Alerts — มี Alert เข้ามา?
6. **ตรวจ Routing** — `amtool config routes test`
7. **ตรวจ Receiver** — Slack webhook / PagerDuty key ยังใช้ได้?

#### Playbook B: Alert ท่วม (Alert Storm)

1. **Identify common label** — Alert ส่วนใหญ่มาจาก cluster/instance เดียว?
2. **Silence ชั่วคราว** — `amtool silence add --match='cluster="X"' --duration=30m --comment="Investigating storm"`
3. **หา Root Cause** — มักมาจาก NodeDown หรือ Network partition
4. **ตรวจ Inhibition rule** — ควรมี `ServiceDown` → suppress อื่น
5. **หลังจบ** — เพิ่ม inhibition rule / ปรับ `group_by`

#### Playbook C: Metrics หายจาก Grafana

1. **Data Source Test** — Grafana → Configuration → Data Sources → Prometheus → Save & Test
2. **Query ตรงใน Prometheus UI** — ถ้าได้ผล → Grafana panel ผิด
3. **ตรวจ Time Range** — panel time range ครอบข้อมูล?
4. **ตรวจ Templating** — `$service` resolve เป็นค่าอะไร? (`Dashboard → Inspect → Panel JSON`)
5. **ตรวจ Recording Rule** — Metric ที่ query เป็น record ออกหรือยัง (`prometheus_rule_group_last_evaluation_timestamp_seconds`)

#### Playbook D: Alertmanager CrashLoop

1. `docker logs alertmanager` — error อะไร
2. `amtool check-config alertmanager.yml` — YAML ผิด?
3. ตรวจ secret file (`smtp_pass`, `slack_url`, `pagerduty_key`) — มีอยู่จริง?
4. ตรวจ `alertmanager-data` volume permission — เขียน state ได้?
5. Rollback config ก่อนหน้า → ค่อยๆ เพิ่ม rule กลับ

---

## สรุป (ประโยชน์, ข้อดี, ข้อเสีย, ข้อห้าม)

### ประโยชน์ของเล่ม 3

- **Metrics Platform ครบวงจร:** Prometheus (เก็บ) + Grafana (แสดง) + Alertmanager (แจ้ง) พร้อมใช้ Production
- **มาตรฐาน RED Method:** ทุก Service วัดด้วยมาตรฐานเดียว — Support เปลี่ยนทีมได้ทันที
- **Config-as-Code:** Prometheus rules, Grafana dashboards, Alertmanager config อยู่ใน Git ทั้งหมด
- **Runbook พร้อม:** Incident Playbook 4 สถานการณ์ที่พบบ่อยที่สุด

### ข้อดี

| ด้าน | ผลลัพธ์ |
|---|---|
| **Detection** | MTTD (Mean Time To Detect) ลดจากชั่วโมง → นาที |
| **Diagnosis** | RED Dashboard ตอบ "อะไรพัง" ภายใน 30 วินาที |
| **Response** | Alert Routing ถึงคนถูกคน ลดการ ping ห้อง Slack |
| **Standardization** | Service ใหม่เพิ่ม Metrics ตาม template ได้ทันที |

### ข้อเสีย / ข้อจำกัด

- **Prometheus ไม่ HA โดยตัวมันเอง** — ถ้าต้องการ HA ต้องใช้ Thanos / Mimir / VictoriaMetrics (นอกขอบเขตเล่มนี้)
- **Cardinality Management** — ต้องมีวินัยเรื่อง Label ตลอด
- **Alertmanager Config ยาก** — ต้องใช้ `amtool` ทุกครั้ง — แนะนำให้มี GitOps review
- **Learning Curve** — PromQL ต้องใช้เวลาฝึก 2-4 สัปดาห์จึงจะคล่อง

### ข้อห้าม (สรุป)

1. ❌ **ห้ามใช้ Label ที่มี Cardinality สูง** (`user_id`, `request_id`, `session_id`) — ให้ใช้ Exemplar แทน
2. ❌ **ห้าม Alert ทุก Metric** — Alert เฉพาะ Symptom (SLI) ไม่ใช่ Cause (เช่น CPU > 80%)
3. ❌ **ห้ามแก้ Dashboard ใน Grafana UI** — แก้ใน Git เท่านั้น (`allowUiUpdates: false`)
4. ❌ **ห้ามใช้ `avg()` ตัดสินใจเรื่อง Latency** — ใช้ P99/P95 เสมอ
5. ❌ **ห้ามส่ง Alert `warning` ไป PagerDuty** — PagerDuty สำหรับ `critical` เท่านั้น
6. ❌ **ห้าม `repeat_interval` < 1h** สำหรับ `warning` — จะกลายเป็น noise
7. ❌ **ห้ามใช้ Prometheus เก็บ Metrics > 30 วัน** — ให้ Remote Write ไป Long-term Storage (เล่ม 4)
8. ❌ **ห้าม Deploy Alertmanager config โดยไม่รัน `amtool check-config`** — จะ crash loop

---

## เส้นทางอ่านต่อ

| ถ้าคุณเป็น | อ่านต่อ |
|---|---|
| Monitoring Engineer | → **เล่ม 4** (Log & TSDB) → **เล่ม 5** (Kafka/Redis Observability) |
| Business App Support | → **เล่ม 7** (CRM Support) |
| ERP Developer | → **เล่ม 8** (DDD) → **เล่ม 9** (DB) → **เล่ม 10** (Integration) |
| ERP Support (Full-stack) | → **เล่ม 4** → **เล่ม 5** → **เล่ม 8** → **เล่ม 9** → **เล่ม 10** |
| AI Engineer | → **เล่ม 4** → **เล่ม 5** → **เล่ม 6** |

---

> **เวอร์ชันเอกสาร:** 1.0
> **ผู้รับผิดชอบ:** SRE Team
> **ปรับปรุงล่าสุด:** ตามรอบ Quarter
> **สถานะ:** ✅ Ready for Review