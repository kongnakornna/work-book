## คู่มือการทำงาน Application Support — เล่ม 1: Foundation & Workflow

**เวอร์ชัน:** 1.0 | **สถานะ:** เอกสารหลัก (Mandatory Reading) | **กลุ่มเป้าหมาย:** ทุกสายงานในทีม Application Support

> **หมายเหตุ:** เล่มนี้เป็น "ฐานราก" ของคู่มือทั้งชุด (10 เล่ม) ทุกเล่มจะอ้างอิงกลับมาที่นี่ในเรื่อง Workflow (PSR, RCA, KPI SMART) และหลักการ Monitoring Framework

---

## 1. บทนำ

### 1.1 วัตถุประสงค์

คู่มือเล่มนี้จัดทำขึ้นเพื่อ:

1. **สร้างมาตรฐานการทำงานร่วมกัน** สำหรับทีม Application Support ทุกสายงาน ตั้งแต่ Monitoring Engineer, Business Application Support, ERP Support, DBA ไปจนถึง AI Support
2. **กำหนดกระบวนการจัดการปัญหาที่วัดผลได้** ผ่าน PSR (Post-Incident Review), RCA (Root Cause Analysis) และ KPI SMART
3. **อธิบายหลักการ Monitoring Framework** ที่ทุกเครื่องมือในเล่มถัดไปจะยึดถือ (Pull vs Push, Agent vs Agentless, RED/USE Method)
4. **จัดเตรียม Template ที่ใช้ซ้ำได้** ทั้ง PSR Report, RCA Worksheet, KPI Scorecard และ Dashboard สำหรับติดตาม Workflow

### 1.2 เป้าหมาย

| เป้าหมาย | ตัวชี้วัดความสำเร็จ |
|---|---|
| ทีมใหม่สามารถเริ่มงานได้ภายใน 5 วันทำการ | Onboarding Checklist ครบ 100% |
| Incident ระดับ P1 ทุกครั้งมี PSR ภายใน 48 ชั่วโมง | % PSR Completion ≥ 95% |
| Incident ซ้ำ (Recurring Incident) ลดลง | อัตรา Incident ซ้ำ ≤ 5% ต่อไตรมาส |
| KPI ของทีมเป็น SMART และติดตามได้รายเดือน | KPI Scorecard อัปเดตทุกเดือน 100% |
| การเลือก Monitoring Framework มีเหตุผลรองรับ | Architecture Decision Record (ADR) ทุก Framework |

---

## 2. บทนิยาม

คำศัพท์ในเล่มนี้เป็น "ภาษากลาง" ที่ทุกเล่มถัดไปใช้อ้างอิง

### 2.1 คำศัพท์ด้าน Observability

| คำศัพท์ | ความหมาย |
|---|---|
| **Metric** | ค่าที่วัดได้ ณ จุดเวลาหนึ่ง เก็บใน Time-Series Database เพื่อ Query และ Alert |
| **Log** | ข้อความเหตุการณ์ที่เกิดในระบบ ใช้สำหรับ Forensic และ Root Cause |
| **Trace** | การติดตาม Request หนึ่งครั้งตั้งแต่ต้นจนจบผ่านหลาย Service (Distributed Tracing) |
| **Observability** | ความสามารถเข้าใจสภาวะภายในระบบจากข้อมูลที่สังเกตได้ (Metrics + Logs + Traces) |
| **Pull Model** | Monitoring Server ไปดึงข้อมูลจาก Target ตาม Interval (เช่น Prometheus Scrape) |
| **Push Model** | Target ส่งข้อมูลมาให้ Monitoring Server เอง (เช่น StatsD, OpenTelemetry) |
| **Agent-based** | ติดตั้ง Collector บน Host เพื่อเก็บ Metrics/Logs |
| **Agentless** | Query ระยะไกลผ่าน SNMP, WMI, API โดยไม่ต้องติดตั้ง Agent |
| **Exporter** | Process ที่แปลง Metrics ของระบบหนึ่งเป็นรูปแบบที่ Prometheus อ่านได้ |
| **Scrape Interval** | ความถี่ที่ Prometheus ไปดึง Metrics (ค่าเริ่มต้น 15 วินาที) |
| **Cardinality** | จำนวน Unique Combination ของ Label — Cardinality สูงทำให้ Prometheus หนัก |
| **SLI** | Service Level Indicator — ตัวชี้วัดระดับบริการ (เช่น Availability, Latency) |
| **SLO** | Service Level Objective — เป้าหมายของ SLI (เช่น 99.9% Availability) |
| **SLA** | Service Level Agreement — ข้อตกลงระดับบริการกับลูกค้า (มีบทลงโทษ) |
| **Error Budget** | จำนวนความล้มเหลวที่ยอมรับได้ (1 - SLO) เช่น SLO 99.9% → Error Budget 0.1% |

### 2.2 Framework การ Monitor

| คำศัพท์ | ความหมาย |
|---|---|
| **RED Method** | Rate, Errors, Duration — สำหรับ Request-driven Service |
| **USE Method** | Utilization, Saturation, Errors — สำหรับ Resource (CPU, Memory, Disk) |
| **Four Golden Signals** | Latency, Traffic, Errors, Saturation — ของ Google SRE |
| **MTTD** | Mean Time to Detect — เวลาเฉลี่ยในการตรวจจับปัญหา |
| **MTTR** | Mean Time to Resolve — เวลาเฉลี่ยในการแก้ไขปัญหา |
| **MTBF** | Mean Time Between Failures — เวลาเฉลี่ยระหว่างความล้มเหลว |

### 2.3 Workflow และ Incident Management

| คำศัพท์ | ความหมาย |
|---|---|
| **Incident** | เหตุการณ์ที่ทำให้บริการหยุดชะงักหรือลดลงอย่างมีนัยสำคัญ |
| **Severity (P1–P4)** | ระดับความรุนแรงของ Incident (P1 = วิกฤตที่สุด) |
| **PSR / PIR** | Post-Incident Review — การทบทวนหลังเกิด Incident แบบ Blameless |
| **RCA** | Root Cause Analysis — การวิเคราะห์สาเหตุราก |
| **Postmortem** | เอกสารสรุปเหตุการณ์คล้าย PSR (มักใช้ใน Google SRE) |
| **Blameless** | วัฒนธรรมการทบทวนที่มุ่งเน้นระบบ ไม่ตำหนิบุคคล |
| **Action Item** | งานที่ต้องทำหลัง PSR พร้อม Owner และ Due Date |
| **KPI** | Key Performance Indicator — ตัวชี้วัดผลการดำเนินงานหลัก |
| **SMART** | Specific, Measurable, Achievable, Relevant, Time-bound |
| **Runbook** | ขั้นตอนปฏิบัติงานสำหรับสถานการณ์เฉพาะ |
| **Playbook** | ชุด Runbook สำหรับ Incident ประเภทหนึ่ง ๆ |

### 2.4 คำศัพท์ที่จะเจอในเล่มถัดไป (Preview)

| คำศัพท์ | เล่มที่อธิบายเต็ม |
|---|---|
| PromQL | เล่ม 3 |
| Consumer Lag | เล่ม 5, 10 |
| Cache Hit Rate | เล่ม 5, 10 |
| Grok Pattern | เล่ม 4 |
| Aggregate Root (DDD) | เล่ม 8 |
| Embedding | เล่ม 6 |
| RAG | เล่ม 6 |

---

## 3. บทหัวข้อ: Monitoring Frameworks

### 3.1 เรื่อง

**Monitoring Frameworks: การเลือกใช้ Pull vs Push และ Agent-based vs Agentless ในสภาพแวดล้อมจริง**

### 3.2 วัตถุประสงค์ของหัวข้อนี้

เพื่อให้ทีม Support เข้าใจ Trade-off ของ Monitoring Framework ทั้งสองมิติ (Pull/Push และ Agent/Agentless) สามารถเลือกใช้ได้อย่างมีเหตุผล และออกแบบ Monitoring Architecture ที่ไม่ซ้ำซ้อน ลด Load บนระบบ และครอบคลุมทั้ง Static และ Dynamic Environment

### 3.3 เป้าหมายของหัวข้อนี้

1. สามารถอธิบายความแตกต่างของ Pull/Push และ Agent/Agentless ได้
2. สามารถเลือก Framework ที่เหมาะสมกับ Environment (Kubernetes, VM, Serverless, Network Device) ได้
3. สามารถตั้งค่า Hybrid Monitoring (Pull + Push) ใน `prometheus.yml` ได้
4. มี Architecture Decision Record (ADR) สำหรับการเลือก Framework ขององค์กร

### 3.4 เนื้อหา / รายละเอียด

#### 3.4.1 ทำไมต้องมี Monitoring Framework?

การ Monitor ระบบหนึ่งระบบอาจใช้เครื่องมือหลายตัว (Prometheus, Node Exporter, OpenTelemetry Collector, ELK, InfluxDB) หากไม่มีหลักการเลือกที่ชัดเจน จะเกิดปัญหา:

- **Data Silos:** Metrics อยู่หลายที่ ไม่สามารถ Correlation ได้
- **Overlap:** เก็บ Metrics ซ้ำซ้อน เปลือง Resource
- **Gaps:** บางส่วนของระบบไม่มีใคร Monitor
- **Operational Overhead:** ดูแล Agent หลายประเภท หลาย Version

Monitoring Framework คือ **"ชุดหลักการ"** ที่ช่วยตัดสินใจว่า "จะเก็บอะไร ด้วยวิธีไหน จากที่ไหน ไปเก็บที่ใด"

#### 3.4.2 มิติที่ 1: Pull Model vs Push Model

**Pull Model** คือ Monitoring Server เป็นผู้ริเริ่มไปดึงข้อมูลจาก Target ตาม Interval ที่กำหนด

```
[Prometheus Server] --HTTP GET /metrics--> [Target: Node Exporter :9100]
                    <--Metrics Response-----
         (ทุก 15 วินาที)
```

**Push Model** คือ Target เป็นผู้ส่งข้อมูลมาให้ Monitoring Server หรือ Collector

```
[Application] --HTTP POST--> [StatsD / OTel Collector] --> [Backend]
              (เมื่อมี Event)
```

**ตารางเปรียบเทียบ:**

| มิติ | Pull Model | Push Model |
|---|---|---|
| **ผู้ริเริ่ม** | Monitoring Server | Target |
| **เครื่องมือตัวอย่าง** | Prometheus, Zabbix (Active Check) | StatsD, OpenTelemetry, Graphite |
| **การตรวจ Target Down** | ง่าย — ถ้า Scrape ไม่ได้ = Down | ยาก — ต้องใช้ Dead Man's Switch |
| **Short-lived Job (Batch, Lambda)** | พลาด — Job จบก่อน Scrape | เหมาะ — Push เมื่อจบ |
| **Firewall / NAT** | ต้องเปิด Inbound Port ที่ Target | Target ต้องเรียก Outbound ได้เท่านั้น |
| **Centralized Control** | สูง — แก้ Config ที่ Server เดียว | ต่ำ — แก้ที่ Target ทุกตัว |
| **Cardinality Control** | ทำได้ง่ายด้วย Relabel | ทำได้ยาก |
| **ตัวอย่างที่เหมาะ** | Kubernetes Pods, Long-running Services, VM | Serverless, Batch Job, Edge Device, IoT |

#### 3.4.3 มิติที่ 2: Agent-based vs Agentless

**Agent-based** คือติดตั้ง Process บน Host เพื่อเก็บ Metrics/Logs

```
[Host] → [Node Exporter / Filebeat / OTel Agent] → [Backend]
```

**Agentless** คือ Query ระยะไกลผ่าน Protocol มาตรฐาน

```
[Monitoring Server] → SNMP / WMI / Database API → [Target]
```

**ตารางเปรียบเทียบ:**

| มิติ | Agent-based | Agentless |
|---|---|---|
| **Visibility** | ลึก — Process, JVM, Custom Metrics, Application Layer | ตื้น — Device-level, Database-level |
| **Setup** | ติดตั้ง + จัดการ Version ทุก Host | ตั้งค่าที่ Monitoring Server |
| **Resource บน Target** | มี Overhead (CPU, Memory) | ไม่มี Agent |
| **Security** | ต้องจัดการ Agent Credential | ใช้ Protocol มาตรฐาน (SNMP v3, TLS) |
| **เหมาะกับ** | Application Monitoring, Custom Business Metrics, Log Shipping | Network Device, Cloud API, Database ที่ไม่สามารถติดตั้ง Agent ได้ |
| **ตัวอย่าง** | Node Exporter, Filebeat, OTel Collector | SNMP Exporter, Blackbox Exporter, CloudWatch Exporter |

#### 3.4.4 การเลือก Framework ตาม Environment

| Environment | แนะนำ | เหตุผล |
|---|---|---|
| **Kubernetes (Production)** | Pull (Prometheus) + K8s Service Discovery + Agent (Node Exporter, Kube-State-Metrics) | Dynamic Pod, ใช้ SD ค้นหา Target อัตโนมัติ |
| **VM / Bare Metal** | Pull (Static Config) + Agent (Node Exporter) | Static Target ตั้งใน `static_configs` |
| **Serverless (Lambda, Cloud Functions)** | Push (OTel Collector / CloudWatch → Prometheus) | Short-lived ไม่สามารถ Pull ได้ |
| **Batch Job (Cron, Spark)** | Push ผ่าน Pushgateway | Job จบก่อน Scrape |
| **Network Device (Router, Switch, Firewall)** | Agentless ผ่าน SNMP Exporter | ติดตั้ง Agent ไม่ได้ |
| **Database (PostgreSQL, Oracle, MongoDB)** | Agent-based Exporter (postgres_exporter, oracledb_exporter) หรือ Agentless (CloudWatch) | ขึ้นกับว่า DB อยู่ที่ไหน |
| **Edge / IoT** | Push (MQTT → Telegraf/OTel → Backend) | Network ไม่เสถียร, NAT |

#### 3.4.5 สถาปัตยกรรมที่แนะนำสำหรับองค์กร (Reference Architecture)

```
┌─────────────────────────────────────────────────────────────────┐
│                        Kubernetes Cluster                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐   │
│  │ App Pods     │  │ Node Exporter│  │ Kube-State-Metrics   │   │
│  │ /metrics     │  │ :9100        │  │ :8080                │   │
│  └──────┬───────┘  └──────┬───────┘  └──────────┬───────────┘   │
│         │                 │                     │               │
│         └─────────────────┴─────────────────────┘               │
│                           │ (Pull via K8s SD)                    │
└───────────────────────────┼─────────────────────────────────────┘
                            ▼
                  ┌─────────────────────┐
                  │  Prometheus Server  │  ◄── Pull Static (VM)
                  │  (Central)          │  ◄── Pull SNMP (Network)
                  └──────────┬──────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
        ┌──────────┐   ┌──────────┐   ┌──────────────┐
        │ Grafana  │   │ Alert    │   │ Remote Write │
        │          │   │ manager  │   │ → InfluxDB   │
        └──────────┘   └──────────┘   └──────────────┘

┌──────────────────────────────────────────────────────────────┐
│                   Serverless / Batch Jobs                     │
│  Lambda → OTel Collector → Pushgateway → Prometheus (Pull)   │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                      Log Pipeline                             │
│  App Logs → Filebeat (Agent) → Logstash → Elasticsearch      │
└──────────────────────────────────────────────────────────────┘
```

#### 3.4.6 การติดตั้ง / การตั้งค่า

**A. Prometheus Hybrid Configuration (Pull Static + Pull K8s SD + Pull Pushgateway)**

```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'prod-th'
    region: 'ap-southeast-1'

scrape_configs:
  # 1) Pull: Static Targets (VM / Bare Metal)
  - job_name: 'node-static'
    scrape_interval: 15s
    static_configs:
      - targets:
          - 'vm-app-01.internal:9100'
          - 'vm-app-02.internal:9100'
          - 'vm-db-01.internal:9100'
        labels:
          env: 'production'
          tier: 'app'

  # 2) Pull: Kubernetes Service Discovery
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        target_label: __address__
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
      - source_labels: [__meta_kubernetes_namespace]
        action: replace
        target_label: namespace
      - source_labels: [__meta_kubernetes_pod_name]
        action: replace
        target_label: pod

  # 3) Pull: Pushgateway (Batch Job ที่ Push เข้ามา)
  - job_name: 'pushgateway'
    honor_labels: true
    static_configs:
      - targets: ['pushgateway.internal:9091']
        labels:
          source: 'batch-job'

  # 4) Pull: SNMP (Network Device) ผ่าน snmp_exporter
  - job_name: 'snmp-network'
    scrape_interval: 60s
    metrics_path: /snmp
    params:
      module: [if_mib]
    static_configs:
      - targets:
          - 'switch-core-01.internal'
          - 'router-edge-01.internal'
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: snmp-exporter.internal:9116
```

**B. Pushgateway Setup (Docker Compose)**

```yaml
# docker-compose.pushgateway.yml
services:
  pushgateway:
    image: prom/pushgateway:v1.9.0
    ports:
      - "9091:9091"
    command:
      - "--web.enable-admin-api"  # สำหรับลบ metrics ที่ค้าง
      - "--persistence.file=/data/pushgateway.data"
      - "--persistence.interval=5m"
    volumes:
      - pushgateway-data:/data

volumes:
  pushgateway-data:
```

**C. OpenTelemetry Collector Setup (สำหรับ Serverless / Batch)**

```yaml
# otel-collector-config.yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch:
    timeout: 10s
    send_batch_size: 1024
  memory_limiter:
    check_interval: 1s
    limit_mib: 512

exporters:
  # ส่งต่อไปยัง Prometheus ผ่าน Remote Write
  prometheusremotewrite:
    endpoint: "http://prometheus.internal:9090/api/v1/write"
    tls:
      insecure: true
  # ส่ง Log ไป ELK
  elasticsearch:
    endpoints: ["http://elasticsearch.internal:9200"]
    logs_index: "otel-logs"

service:
  pipelines:
    metrics:
      receivers: [otlp]
      processors: [memory_limiter, batch]
      exporters: [prometheusremotewrite]
    logs:
      receivers: [otlp]
      processors: [memory_limiter, batch]
      exporters: [elasticsearch]
```

**D. ตัวอย่าง Batch Job ที่ Push Metrics (Python)**

```python
# batch_job_metrics.py
from prometheus_client import CollectorRegistry, Gauge, push_to_gateway
import time

registry = CollectorRegistry()

job_duration = Gauge('batch_job_duration_seconds', 'Duration of batch job',
                     ['job_name'], registry=registry)
job_records = Gauge('batch_job_records_processed', 'Records processed',
                    ['job_name'], registry=registry)
job_status = Gauge('batch_job_last_status', 'Last run status (1=success, 0=fail)',
                   ['job_name'], registry=registry)

def run_batch(job_name: str):
    start = time.time()
    try:
        records = process_records()  # งานจริง
        job_records.labels(job_name=job_name).set(records)
        job_status.labels(job_name=job_name).set(1)
    except Exception as e:
        job_status.labels(job_name=job_name).set(0)
        raise
    finally:
        job_duration.labels(job_name=job_name).set(time.time() - start)
        # Push เมื่อ Job จบ
        push_to_gateway('pushgateway.internal:9091', job=job_name, registry=registry)

if __name__ == '__main__':
    run_batch('daily-reconciliation')
```

**E. Recording Rules เพื่อลด Cardinality**

```yaml
# rules/framework-records.yml
groups:
  - name: framework-recording-rules
    interval: 30s
    rules:
      # Recording Rule ลด Cardinality ของ Metrics ที่มี Label เยอะ
      - record: job:http_requests:rate5m
        expr: sum(rate(http_requests_total[5m])) by (job)
      - record: instance:node_cpu:rate5m
        expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

#### 3.4.7 การวิเคราะห์และแนวทางแก้ไข

**Decision Tree: การเลือก Pull หรือ Push**

```
เริ่มต้น
  │
  ├── Target เป็น Long-running Service?
  │     ├── ใช่ → Pull (Prometheus Scrape)
  │     │        ├── อยู่บน Kubernetes? → ใช้ K8s SD
  │     │        └── อยู่บน VM/Static? → ใช้ static_configs
  │     └── ไม่ (Batch/Serverless)
  │          ├── Job มีอายุ > Scrape Interval? → Pull (แต่อาจพลาด)
  │          └── Job มีอายุ < Scrape Interval? → Push (Pushgateway หรือ OTel)
  │
  └── Target อยู่หลัง Firewall/NAT ที่เปิด Inbound ไม่ได้?
        ├── ใช่ → Push (OTel / Telegraf → Backend)
        └── ไม่ → Pull
```

**ตารางวินิจฉัยปัญหา Framework:**

| อาการ | สาเหตุที่เป็นไปได้ | แนวทางแก้ไข |
|---|---|---|
| Metrics หายช่วงสั้น ๆ (Gap) | Pull Interval ไม่ทัน Short-lived State | เปลี่ยนเป็น Push หรือลด Scrape Interval เฉพาะ Job นั้น |
| Prometheus เข้าถึง Target ไม่ได้ | Firewall ปิด Inbound Port ที่ Target | ใช้ Pushgateway หรือ Prometheus Agent ที่อยู่ใกล้ Target |
| Agent ใช้ CPU/Memory สูง | Exporter เก็บ Metrics ถี่เกินไป หรือ Cardinality สูง | ลด Cardinality (Relabel/Drop), เพิ่ม Scrape Interval, ใช้ Recording Rules |
| Cardinailty ระเบิด (Prometheus OOM) | Label ที่มีค่ามากเกิน (user_id, request_id) | ใช้ Relabel Drop หรือ Aggregate ที่ Recording Rule |
| Target Down แต่ไม่มี Alert | ไม่มี `up == 0` Rule หรือ Missing `for` | เพิ่ม `InstanceDown` Alert Rule |
| Batch Job Fail แต่ไม่มีข้อมูล | ไม่ได้ Push หรือ Push ก่อน Job จบ | ตรวจ push_to_gateway ใน Code, ใช้ `defer` หรือ `finally` |
| Duplicate Metrics | หลาย Exporter เก็บ Metrics ซ้ำ | ใช้ Relabel Drop, รวม Exporter, กำหนด Ownership |

**Runbook: "Metrics หาย — จะเริ่มจากไหน?"**

1. **ตรวจสอบ Target Availability**
   ```bash
   # ดูว่า Target ถูก Scrape หรือไม่
   curl -s http://prometheus.internal:9090/api/v1/targets | jq '.data.activeTargets[] | select(.health != "up")'
   ```
2. **ตรวจสอบ Exporter โดยตรง**
   ```bash
   curl -sf http://target-host:9100/metrics | head -5
   ```
3. **ตรวจสอบ Prometheus Log**
   ```bash
   docker logs prometheus 2>&1 | grep -i "error\|scrape"
   ```
4. **ตรวจสอบ Network Path**
   ```bash
   # จาก Prometheus Server ไปหา Target
   curl -v --max-time 5 http://target-host:9100/metrics
   ```
5. **ตรวจสอบ Cardinality**
   ```promql
   # Top 10 Metrics ที่มี Cardinality สูงสุด
   topk(10, count by (__name__)({__name__=~".+"}))
   ```
6. **แก้ไขและยืนยัน**
   ```promql
   up{job="node-static"}
   ```

**Runbook: "Pushgateway มี Metrics ค้าง"**

1. ตรวจสอบ Metrics ที่ค้าง:
   ```bash
   curl -s http://pushgateway.internal:9091/metrics | grep '^push_time_seconds'
   ```
2. ลบ Metrics ที่ค้าง (ระวัง: ต้องมี `--web.enable-admin-api`):
   ```bash
   # ลบทั้ง Job
   curl -X DELETE http://pushgateway.internal:9091/metrics/job/daily-reconciliation
   # หรือลบ Group ที่ระบุ
   curl -X DELETE http://pushgateway.internal:9091/metrics/job/daily-reconciliation/instance/batch-01
   ```
3. ตั้ง Alert สำหรับ Stale Metrics:
   ```yaml
   - alert: PushgatewayStaleMetric
     expr: time() - push_time_seconds > 86400
     for: 1h
     annotations:
       summary: "Pushgateway metric stale > 24h for {{ $labels.job }}"
   ```

#### 3.4.8 ลำดับการจัดการปัญหา (Framework Incident)

| ลำดับ | ขั้นตอน | ผู้รับผิดชอบ | เวลาที่คาดหวัง |
|:---:|---|---|---|
| 1 | **Detect** — Alert `InstanceDown` หรือ `NoData` | Alertmanager | ทันที |
| 2 | **Triage** — ระบุว่า Target Down, Exporter Down หรือ Network | On-call Support | ≤ 5 นาที |
| 3 | **Isolate** — แยก Scope ว่าเป็น Target เดียว หรือทั้ง Cluster | On-call Support | ≤ 10 นาที |
| 4 | **Communicate** — แจ้ง Stakeholder ด้วย Impact + ETA | Incident Commander | ≤ 15 นาที |
| 5 | **Mitigate** — Restart Exporter, เปิด Firewall, เปลี่ยน Pull → Push ชั่วคราว | Support + Network | ≤ 30 นาที |
| 6 | **Verify** — ยืนยัน Metrics กลับมา, ไม่มี Gap | Support | ≤ 5 นาที |
| 7 | **RCA** — วิเคราะห์ Root Cause (ตาม 4.2) | Support + Owner | ≤ 48 ชั่วโมง |
| 8 | **Action Item** — ป้องกันการเกิดซ้ำ | Owner | ตาม Due Date |

#### 3.4.9 Template Code

**A. `prometheus.yml` Template (พร้อมใช้ใน Production)**

ดูตัวอย่างเต็มในหัวข้อ 3.4.6 A

**B. Alert Rules สำหรับ Framework Health**

```yaml
# rules/framework-alerts.yml
groups:
  - name: framework-health
    rules:
      # Target Down
      - alert: TargetDown
        expr: up == 0
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Target {{ $labels.instance }} (job={{ $labels.job }}) is down"
          description: "Prometheus cannot scrape target for 2 minutes"

      # Pushgateway Metrics ค้าง
      - alert: PushgatewayStaleMetric
        expr: time() - push_time_seconds > 86400
        for: 1h
        labels:
          severity: warning
        annotations:
          summary: "Pushgateway metric stale > 24h: {{ $labels.job }}"
          description: "Job may have stopped running or failed silently"

      # Prometheus Scrape Duration สูง
      - alert: PrometheusSlowScrape
        expr: |
          histogram_quantile(0.99,
            sum(rate(prometheus_target_scrape_pool_sync_total[5m])) by (le, scrape_job)
          ) > 10
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Slow scrape (>10s) for job {{ $labels.scrape_job }}"
          description: "Exporter หรือ Network ช้า — ตรวจสอบ Target"

      # Prometheus Cardinality สูง
      - alert: PrometheusHighCardinality
        expr: prometheus_tsdb_head_series > 5000000
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Prometheus series count > 5M"
          description: "ตรวจสอบ Metrics ที่มี Cardinality สูงและ Drop ด้วย Relabel"

      # Prometheus Remote Write Failing
      - alert: PrometheusRemoteWriteFailing
        expr: rate(prometheus_remote_storage_failed_samples_total[5m]) > 0
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Remote write failing to {{ $labels.remote_name }}"
```

**C. Architecture Decision Record (ADR) Template**

```markdown
# ADR-001: Monitoring Framework สำหรับ [System Name]

## Status
Proposed / Accepted / Deprecated / Superseded

## Context
อธิบาย System ที่ต้อง Monitor, Environment, ข้อจำกัด (Firewall, Cloud, Budget)

## Decision
เลือก Framework อะไร (Pull/Push, Agent/Agentless) เพราะอะไร

## Consequences
### Positive
- ...
### Negative
- ...
### Neutral
- ...

## Alternatives Considered
| ทางเลือก | ข้อดี | ข้อเสีย | เหตุผลที่ไม่เลือก |
|---|---|---|---|
| Pull Agent | ... | ... | ... |
| Push | ... | ... | ... |

## References
- Link to Prometheus Config
- Link to Runbook
- Link to Dashboard
```

#### 3.4.10 Template Dashboard

**Grafana Dashboard: Monitoring Framework Health**

```json
{
  "title": "Framework Health Overview",
  "uid": "framework-health-v1",
  "refresh": "30s",
  "time": {"from": "now-6h", "to": "now"},
  "panels": [
    {
      "id": 1,
      "title": "Targets Up vs Down",
      "type": "stat",
      "gridPos": {"h": 6, "w": 6, "x": 0, "y": 0},
      "targets": [
        {
          "expr": "sum(up == 1)",
          "legendFormat": "Up",
          "instant": true
        },
        {
          "expr": "sum(up == 0)",
          "legendFormat": "Down",
          "instant": true
        }
      ],
      "fieldConfig": {
        "defaults": {
          "thresholds": {
            "steps": [
              {"color": "red", "value": null},
              {"color": "green", "value": 1}
            ]
          }
        }
      }
    },
    {
      "id": 2,
      "title": "Scrape Duration p99 (seconds)",
      "type": "timeseries",
      "gridPos": {"h": 6, "w": 9, "x": 6, "y": 0},
      "targets": [{
        "expr": "histogram_quantile(0.99, sum(rate(prometheus_target_scrape_pool_sync_total[5m])) by (le, scrape_job))",
        "legendFormat": "{{scrape_job}}"
      }]
    },
    {
      "id": 3,
      "title": "Prometheus Series Count",
      "type": "stat",
      "gridPos": {"h": 6, "w": 9, "x": 15, "y": 0},
      "targets": [{
        "expr": "prometheus_tsdb_head_series",
        "instant": true
      }],
      "fieldConfig": {
        "defaults": {
          "thresholds": {
            "steps": [
              {"color": "green", "value": null},
              {"color": "yellow", "value": 1000000},
              {"color": "red", "value": 5000000}
            ]
          }
        }
      }
    },
    {
      "id": 4,
      "title": "Targets Down by Job",
      "type": "table",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 6},
      "targets": [{
        "expr": "up == 0",
        "format": "table",
        "instant": true
      }],
      "transformations": [
        {
          "id": "organize",
          "options": {
            "excludeByName": {"Time": true, "__name__": true},
            "renameByName": {
              "instance": "Instance",
              "job": "Job",
              "env": "Env"
            }
          }
        }
      ]
    },
    {
      "id": 5,
      "title": "Pushgateway Last Push Age",
      "type": "table",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 6},
      "targets": [{
        "expr": "time() - push_time_seconds",
        "format": "table",
        "instant": true
      }],
      "transformations": [
        {
          "id": "organize",
          "options": {
            "renameByName": {"Value": "Age (seconds)", "job": "Job", "instance": "Instance"}
          }
        }
      ]
    }
  ]
}
```

**การนำเข้า Dashboard:**

1. ไปที่ Grafana → Dashboards → New → Import
2. วาง JSON ข้างต้น หรือบันทึกเป็นไฟล์ `.json` แล้ว Upload
3. เลือก Data Source เป็น Prometheus
4. กด Import

#### 3.4.11 สรุปย่อ

Monitoring Framework มีสองมิติหลัก (Pull/Push และ Agent/Agentless) ไม่มีคำตอบเดียวที่ใช้ได้ทุก Environment ต้องเลือกตามลักษณะของ Target (Long-running vs Ephemeral), ข้อจำกัดของ Network (Firewall, NAT), และระดับ Visibility ที่ต้องการ (Device-level vs Application-level) องค์กรส่วนใหญ่ใช้ Hybrid Model: Pull สำหรับ Kubernetes และ VM, Push สำหรับ Serverless และ Batch Job, Agentless สำหรับ Network Device

#### 3.4.12 ประโยชน์ที่ได้รับ

1. **ลด Overlap:** รู้ว่าส่วนไหนควรใช้ Framework ใด ไม่เก็บซ้ำ
2. **ครอบคลุมทุก Environment:** Static, Dynamic, Serverless, Network Device
3. **ลด Operational Overhead:** Agent น้อยลง ถ้าใช้ Agentless ได้
4. **Cardinality Control:** รู้วิธีใช้ Relabel และ Recording Rules
5. **Cost Optimization:** เลือก Framework ที่เหมาะกับ Workload ลดค่าใช้จ่าย Cloud

#### 3.4.13 ข้อควรระวัง

1. **Pull Interval vs Job Duration:** ถ้า Job สั้นกว่า Scrape Interval จะพลาด — ใช้ Push
2. **Pushgateway ไม่ใช่ Queue:** ถ้า Pushgateway ล่ม Metrics จะหาย — ต้องมี HA หรือ Fallback
3. **Firewall Rule:** Pull ต้องเปิด Inbound ที่ Target — ต้องประสาน Network Team
4. **Cardinality ที่ไม่ควบคุม:** Label ที่มีค่า Unique สูง (user_id, request_id) ทำให้ Prometheus OOM
5. **Agent Version Drift:** Agent หลาย Version ทำให้ Metrics ไม่สอดคล้อง — ต้องมี Version Management

#### 3.4.14 ข้อดี

1. **มาตรฐาน Open Source แข็งแรง:** Prometheus, OpenTelemetry เป็นมาตรฐาน Industry
2. **ยืดหยุ่น:** ผสม Pull + Push ได้ตามความเหมาะสม
3. **Zero-touch Service Discovery:** K8s SD ค้นหา Pod อัตโนมัติ
4. **Community ใหญ่:** Plugin และ Exporter มีให้เลือกมาก
5. **Vendor-neutral:** ไม่ผูกกับ Vendor รายเดียว

#### 3.4.15 ข้อเสีย

1. **Operational Complexity:** Hybrid Model ต้องดูแลหลาย Component
2. **Learning Curve:** PromQL, Relabel, Service Discovery มี Learning Curve
3. **Data Silos:** ถ้าไม่วางแผนดี Metrics กระจายหลายที่
4. **Resource Consumption:** Prometheus ใช้ Disk และ Memory มากเมื่อ Cardinality สูง
5. **Pushgateway ไม่เหมาะกับ High-volume:** เป็น Single Point of Failure

#### 3.4.16 ข้อห้าม

1. **ห้ามใช้ Pull Model กับ Batch Job ที่มีอายุสั้นกว่า Scrape Interval** — จะพลาด Metrics
2. **ห้ามเปิด Inbound Port บน Target สู่ Public Internet** — ใช้ VPN หรือ Private Link
3. **ห้ามใช้ Label ที่มี Cardinality สูง** (user_id, request_id, email) โดยไม่ Aggregate
4. **ห้ามใช้ Pushgateway เป็น Long-term Storage** — ใช้แค่ Buffer ชั่วคราว
5. **ห้ามใช้ Agent-based บนระบบ Resource จำกัดมาก** โดยไม่ทดสอบ Overhead
6. **ห้ามใช้ Framework ต่างกันในระบบเดียวกันโดยไม่มี ADR** — จะเกิด Data Silos

#### 3.4.17 ตัวอย่าง

**สถานการณ์:** องค์กรมี Kubernetes Cluster (Production), VM 20 เครื่อง (Legacy), AWS Lambda 50 ฟังก์ชัน, Network Switch 10 ตัว

**แนวทาง:**
- **K8s:** Prometheus + K8s SD (Pull) + Node Exporter (Agent) + Kube-State-Metrics
- **VM:** Prometheus Static Config (Pull) + Node Exporter (Agent)
- **Lambda:** CloudWatch → OTel Collector → Prometheus Remote Write (Push)
- **Network:** SNMP Exporter (Agentless)
- **Batch Job (Cron):** Pushgateway (Push)

**ผลลัพธ์:** Metrics ทั้งหมดอยู่ใน Prometheus เดียว, Grafana เดียว, Alertmanager เดียว — Single Pane of Glass

#### 3.4.18 สรุปย่อเพื่อจดจำ

> **"Pull สำหรับ Long-running, Push สำหรับ Ephemeral, Agent สำหรับ Depth, Agentless สำหรับ Reach"**
>
> **"ไม่มี Framework เดียวที่ครอบจักรวาล — Hybrid คือคำตอบ แต่ต้องมี ADR ทุกครั้ง"**

#### 3.4.19 แหล่งที่มาและแหล่งอ้างอิง

1. Prometheus Documentation — *Pull Model and Pushgateway*: https://prometheus.io/docs/practices/pushing/
2. OpenTelemetry Documentation — *Collector Configuration*: https://opentelemetry.io/docs/collector/
3. Google SRE Book — *Monitoring Distributed Systems*: https://sre.google/sre-book/monitoring-distributed-systems/
4. Logz.io — *Infrastructure Monitoring Frameworks*: https://logz.io/learn/infrastructure-monitoring/
5. Datasentinel — *Monitoring Architecture Patterns*: https://datasentinel.com/
6. Prometheus Best Practices — *Instrumentation*: https://prometheus.io/docs/practices/instrumentation/

---

## 4. Workflow

Workflow ทั้งสามส่วน (PSR, RCA, KPI SMART) เป็น **มาตรฐานกลาง** ที่ทุกเล่มในชุดคู่มือนี้จะอ้างอิงกลับมา

```
                    ┌─────────────────────┐
                    │   Incident เกิดขึ้น  │
                    └──────────┬──────────┘
                               ▼
                    ┌─────────────────────┐
                    │  Detect + Triage    │
                    │  (MTTD)             │
                    └──────────┬──────────┘
                               ▼
                    ┌─────────────────────┐
                    │  Mitigate + Resolve │
                    │  (MTTR)             │
                    └──────────┬──────────┘
                               ▼
                    ┌─────────────────────┐
                    │  PSR (4.1)          │
                    │  Blameless Review   │
                    └──────────┬──────────┘
                               ▼
                    ┌─────────────────────┐
                    │  RCA (4.2)          │
                    │  Root Cause         │
                    └──────────┬──────────┘
                               ▼
                    ┌─────────────────────┐
                    │  Action Items       │
                    │  (Owner + Due Date) │
                    └──────────┬──────────┘
                               ▼
                    ┌─────────────────────┐
                    │  KPI SMART (4.3)    │
                    │  วัดผลและปรับปรุง   │
                    └─────────────────────┘
```

---

### 4.1 PSR (Post-Incident Review)

#### 4.1.1 เรื่อง

**PSR: กระบวนการทบทวนหลังเกิด Incident แบบ Blameless เพื่อเรียนรู้และป้องกันการเกิดซ้ำ**

#### 4.1.2 วัตถุประสงค์ของหัวข้อนี้

เพื่อให้ทีม Support มีกระบวนการที่เป็นมาตรฐานในการทบทวน Incident อย่างเป็นระบบ ไม่ใช่แค่ปิด Ticket — และสามารถสร้าง Action Item ที่วัดผลได้จริง

#### 4.1.3 เป้าหมายของหัวข้อนี้

1. PSR Report สำหรับ Incident ระดับ P1 เสร็จภายใน **48 ชั่วโมง**
2. PSR Report สำหรับ Incident ระดับ P2 เสร็จภายใน **5 วันทำการ**
3. Action Item ทุกตัวมี **Owner + Due Date + Acceptance Criteria**
4. Action Item สำเร็จตามกำหนด ≥ 90%
5. Incident ซ้ำ (Recurring) ลดลง ≤ 5% ต่อไตรมาส

#### 4.1.4 เนื้อหา / รายละเอียด

**PSR คืออะไร?**

PSR (Post-Incident Review) หรือ PIR (Post-Incident Review) หรือ Postmortem คือ **กระบวนการทบทวน Incident อย่างเป็นระบบ** หลัง Incident สงบลง เพื่อ:

1. **ทำความเข้าใจ** ว่าเกิดอะไรขึ้น (What happened)
2. **วิเคราะห์** ว่าทำไมจึงเกิดขึ้น (Why it happened)
3. **ระบุ** สิ่งที่ทำได้ดีและสิ่งที่ต้องปรับปรุง (What went well / What to improve)
4. **กำหนด** Action Item เพื่อป้องกันการเกิดซ้ำ (How to prevent)

**Severity Level และ PSR Requirement:**

| Severity | คำอธิบาย | ตัวอย่าง | PSR Required? | กำหนดเวลา |
|---|---|---|---|---|
| **P1** | ระบบล่มทั้งหมด หรือ Impact ต่อรายได้สูง | Payment Gateway Down, CRM ล่มทั้งระบบ | ✅ บังคับ | ≤ 48 ชั่วโมง |
| **P2** | ฟีเจอร์หลักเสีย หรือ Impact ปานกลาง | Checkout ช้า, Report Gen ไม่ได้ | ✅ บังคับ | ≤ 5 วันทำการ |
| **P3** | ฟีเจอร์รองเสีย, มี Workaround | Dashboard แสดงผลผิด, Export ช้า | ⚠️ Optional | ตามดุลพินิจ |
| **P4** | Cosmetic, ไม่มี Impact | Typo, UI ผิดเล็กน้อย | ❌ ไม่ต้อง | — |

**หลักการ 5 ประการของ PSR ที่ดี:**

1. **Blameless:** มุ่งเน้นระบบและกระบวนการ ไม่ตำหนิบุคคล
2. **Timely:** ทำทันทีหลัง Incident สงบ (ไม่เกิน 48 ชั่วโมงสำหรับ P1)
3. **Factual:** ใช้ข้อมูลจริง (Timeline, Log, Metrics) ไม่ใช่ความรู้สึก
4. **Actionable:** ทุก Finding ต้องนำไปสู่ Action Item ที่วัดผลได้
5. **Shared:** เผยแพร่ให้ทั้งองค์กรเรียนรู้ ไม่ใช่เฉพาะทีมที่เกิดเหตุ

#### 4.1.5 การติดตั้ง / การตั้งค่า (PSR Process Setup)

**A. PSR Workflow (Jira / Linear / Notion)**

```
Incident Created (P1/P2)
    │
    ├── Auto-create PSR Task (Linked to Incident)
    │   ├── Assignee: Incident Commander
    │   ├── Due Date: +48h (P1) / +5d (P2)
    │   └── Template: PSR Report
    │
    ├── Data Collection (ระหว่าง/หลัง Incident)
    │   ├── Timeline (จาก Slack, Alertmanager, Logs)
    │   ├── Metrics Snapshot (จาก Grafana)
    │   └── Log Snippets (จาก ELK)
    │
    ├── PSR Meeting (60 นาที)
    │   ├── Attendees: IC, On-call, Dev Lead, DBA, Product Owner
    │   ├── Facilitator: ไม่ใช่ IC (เพื่อความเป็นกลาง)
    │   └── Agenda: Timeline → What went well → What to improve → Action Items
    │
    ├── PSR Report Published
    │   ├── Shared: Wiki / Notion / Confluence
    │   └── Notify: #engineering, #leadership
    │
    └── Action Items Tracked
        ├── Created ใน Jira (Epic: PSR Action Items)
        ├── Reviewed: Weekly
        └── Closed: เมื่อ Acceptance Criteria ผ่าน
```

**B. Jira Automation Rule (ตัวอย่าง)**

```yaml
# jira-automation-psr.yml
trigger:
  type: issue_created
  filter:
    project: OPS
    issue_type: Incident
    priority: [P1, P2]

actions:
  - create_issue:
      project: OPS
      issue_type: PSR
      summary: "PSR: {{trigger.issue.summary}}"
      description: "Linked to {{trigger.issue.key}}"
      assignee: "{{trigger.issue.assignee}}"
      due_date: "{{trigger.issue.created.plusHours(48)}}"
      link:
        type: "relates to"
        issue: "{{trigger.issue.key}}"
      labels: ["psr-auto-created"]
```

**C. Slack Workflow (PSR Notification)**

```yaml
# .github/workflows/psr-notify.yml
name: PSR Notification
on:
  issues:
    types: [opened, closed]

jobs:
  notify:
    if: contains(github.event.issue.labels.*.name, 'psr')
    runs-on: ubuntu-latest
    steps:
      - name: Notify Slack
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "PSR {{ github.event.action }}: {{ github.event.issue.title }}",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*PSR {{ github.event.action }}*\n<{{ github.event.issue.html_url }}|{{ github.event.issue.title }}>"
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

#### 4.1.6 การวิเคราะห์และแนวทางแก้ไข

**PSR ที่ดี vs PSR ที่แย่:**

| ด้าน | PSR ที่ดี | PSR ที่แย่ |
|---|---|---|
| **ภาษา** | "ระบบไม่มี Circuit Breaker ทำให้ Cascade" | "Developer X ไม่ระวัง" |
| **Timeline** | มี Timestamp ทุกเหตุการณ์ | "ประมาณ 10 โมง" |
| **Finding** | "Connection Pool ไม่มี Monitoring" | "ระบบช้า" |
| **Action Item** | "เพิ่ม Alert Connection Pool > 80% ภายใน 2 สัปดาห์ (Owner: A)" | "ปรับปรุงระบบ" |
| **การเผยแพร่** | Share ทั้ง Org + Leadership | เก็บใน Folder ส่วนตัว |

**ตารางวินิจฉัยปัญหา PSR Process:**

| อาการ | สาเหตุ | แนวทางแก้ไข |
|---|---|---|
| PSR ไม่เสร็จตามกำหนด | ไม่มี Facilitator, ไม่มี Template | Auto-create + Assign Facilitator + Template |
| Action Item ไม่ถูกปิด | ไม่มี Owner ชัดเจน, ไม่มี Due Date | บังคับ Owner + Due + Acceptance Criteria |
| PSR กลายเป็น "หาคนผิด" | ไม่มี Blameless Culture | Facilitator ย้ำ Blameless, Leadership สนับสนุน |
| Incident ซ้ำ | RCA ไม่ลึกพอ | ใช้ 5 Whys ถึง Process Gap, ไม่หยุดที่ Human Error |
| PSR ไม่ถูกอ่าน | ไม่มี Communication Plan | Share ใน #engineering, Weekly Digest, Leadership Review |

**Runbook: "จะทำ PSR อย่างไรให้ได้ผล?"**

1. **ก่อนประชุม (T-24h):** รวบรวม Timeline, Metrics Snapshot, Log Snippets
2. **ระหว่างประชุม (60 นาที):**
   - 10 นาที: Timeline Walkthrough (IC เล่า)
   - 15 นาที: What went well?
   - 20 นาที: What to improve? (Facilitator คุมไม่ให้ Blame)
   - 15 นาที: Action Items (Owner + Due + Acceptance Criteria)
3. **หลังประชุม (T+48h):** เผยแพร่ PSR Report
4. **ติดตาม (Weekly):** Review Action Item Status
5. **ปิด (T+30d):** ตรวจสอบ Acceptance Criteria

#### 4.1.7 ลำดับการจัดการปัญหา (PSR Incident Flow)

| ลำดับ | ขั้นตอน | ผู้รับผิดชอบ | Output |
|:---:|---|---|---|
| 1 | Incident ถูก Resolve (P1/P2) | On-call | Incident Closed |
| 2 | Auto-create PSR Task | Automation | PSR Ticket |
| 3 | Assign Facilitator (ไม่ใช่ IC) | Incident Commander | Facilitator |
| 4 | Collect Data (Timeline, Metrics, Logs) | IC + Support | Evidence Bundle |
| 5 | PSR Meeting | Facilitator | Meeting Notes |
| 6 | Draft PSR Report | IC | Draft |
| 7 | Review PSR Report | Dev Lead + Product Owner | Reviewed |
| 8 | Publish PSR Report | Facilitator | Published Doc |
| 9 | Create Action Items | IC + Owner | Jira Tickets |
| 10 | Weekly Follow-up | Team Lead | Status Update |
| 11 | Close Action Items | Owner | Verified |

#### 4.1.8 Template Code

**A. PSR Report Template (Markdown)**

```markdown
# PSR Report: [Incident Title]

**Incident ID:** INC-XXXX
**Severity:** P1 / P2
**Date:** YYYY-MM-DD
**Duration:** HH:MM (Start: HH:MM UTC+7, End: HH:MM UTC+7)
**Impact:** [จำนวนผู้ใช้ / ระบบ / รายได้]
**Author:** [ชื่อ IC]
**Facilitator:** [ชื่อ]
**Status:** Draft / Reviewed / Published

---

## 1. Executive Summary
[2-3 ประโยคสรุป: เกิดอะไร, ผลกระทบ, แก้อย่างไร]

## 2. Impact
| มิติ | รายละเอียด |
|---|---|
| **Users Affected** | XXX users (XX% of MAU) |
| **Systems Affected** | Checkout Service, Payment Gateway |
| **Revenue Impact** | ประมาณ XX,XXX บาท |
| **SLA Breach** | ✅ / ❌ (SLO 99.9%, Actual 99.5%) |
| **Customer Complaints** | XX tickets |

## 3. Timeline
| เวลา (UTC+7) | เหตุการณ์ | ผู้ดำเนินการ |
|---|---|---|
| 10:00 | Alert `HighErrorRate` ถูก Fire | Alertmanager |
| 10:02 | On-call Ack Alert | Support A |
| 10:05 | เริ่ม Triage — ตรวจ Dashboard | Support A |
| 10:10 | Escalate ไป Dev Lead | Support A |
| 10:15 | ระบุสาเหตุ: Database Connection Pool Exhausted | Dev Lead |
| 10:20 | Mitigate: เพิ่ม Pool Size (Config Change) | DBA |
| 10:25 | Error Rate กลับสู่ปกติ | Support A |
| 10:30 | Incident Resolved | IC |

## 4. Root Cause
[อ้างอิง RCA Section — สรุป 1-2 ประโยค]

**Root Cause:** [ระบุชัดเจน]

## 5. What Went Well
- Alert ทำงานถูกต้อง (Detect ภายใน 30 วินาที)
- Communication ชัดเจนใน #incident-checkout
- DBA เข้ามาช่วยเร็ว

## 6. What to Improve
- ไม่มี Alert สำหรับ Connection Pool Utilization
- ไม่มี Runbook สำหรับ Connection Pool Exhaustion
- Change Management ไม่ได้ Review Pool Config

## 7. Action Items
| ID | Action | Owner | Due Date | Acceptance Criteria | Status |
|---|---|---|---|---|---|
| AI-01 | เพิ่ม Alert Connection Pool > 80% | Support A | 2026-11-25 | Alert ยิงใน Staging | Open |
| AI-02 | เขียน Runbook Connection Pool | Support B | 2026-11-30 | Runbook Published | Open |
| AI-03 | เพิ่ม Connection Pool ใน Change Checklist | Dev Lead | 2026-12-05 | Checklist Updated | Open |

## 8. Lessons Learned
[บทเรียนสำคัญ 2-3 ข้อ — เผยแพร่ให้ Org]

## 9. Supporting Evidence
- Grafana Snapshot: [Link]
- Kibana Query: [Link]
- Slack Thread: [Link]
- Prometheus Query: [Link]

## 10. Approvals
| Role | Name | Date | Signature |
|---|---|---|---|
| Incident Commander | | | |
| Dev Lead | | | |
| Product Owner | | | |
```

**B. PSR Meeting Agenda Template**

```markdown
# PSR Meeting — [Incident ID]

**Date:** YYYY-MM-DD
**Time:** 60 นาที
**Facilitator:** [ชื่อ]
**Attendees:** [รายชื่อ]

## Agenda
1. **Timeline Walkthrough** (10 นาที) — IC เล่า
2. **What Went Well** (15 นาที) — ทุกคนมีสิทธิ์พูด
3. **What to Improve** (20 นาที) — Facilitator คุมไม่ให้ Blame
4. **Action Items** (15 นาที) — Owner + Due + Acceptance Criteria

## Ground Rules
- Blameless: มุ่งเน้นระบบ ไม่ใช่คน
- Factual: ใช้ข้อมูลจริง
- Constructive: ทุก Finding ต้องนำไปสู่ Action
- Time-boxed: ไม่เกิน 60 นาที

## Output
- PSR Report (Draft)
- Action Items (Jira Tickets)
- Communication Plan
```

#### 4.1.9 Template Dashboard

**Grafana Dashboard: PSR & Incident Metrics**

```json
{
  "title": "PSR & Incident Overview",
  "uid": "psr-overview-v1",
  "refresh": "5m",
  "time": {"from": "now-30d", "to": "now"},
  "panels": [
    {
      "id": 1,
      "title": "Incidents by Severity (30d)",
      "type": "barchart",
      "gridPos": {"h": 8, "w": 8, "x": 0, "y": 0},
      "targets": [{
        "expr": "sum by (severity) (increase(incidents_total[30d]))",
        "legendFormat": "{{severity}}"
      }]
    },
    {
      "id": 2,
      "title": "PSR Completion Rate (P1 + P2)",
      "type": "gauge",
      "gridPos": {"h": 8, "w": 8, "x": 8, "y": 0},
      "targets": [{
        "expr": "sum(psr_completed_on_time) / sum(psr_required) * 100",
        "instant": true
      }],
      "fieldConfig": {
        "defaults": {
          "thresholds": {
            "steps": [
              {"color": "red", "value": null},
              {"color": "yellow", "value": 80},
              {"color": "green", "value": 95}
            ]
          },
          "unit": "percent"
        }
      }
    },
    {
      "id": 3,
      "title": "Action Item Completion Rate",
      "type": "gauge",
      "gridPos": {"h": 8, "w": 8, "x": 16, "y": 0},
      "targets": [{
        "expr": "sum(action_items_closed) / sum(action_items_total) * 100",
        "instant": true
      }],
      "fieldConfig": {
        "defaults": {
          "thresholds": {
            "steps": [
              {"color": "red", "value": null},
              {"color": "yellow", "value": 80},
              {"color": "green", "value": 90}
            ]
          },
          "unit": "percent"
        }
      }
    },
    {
      "id": 4,
      "title": "MTTR Trend (P1)",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 8},
      "targets": [{
        "expr": "avg(mttr_minutes{severity=\"P1\"})",
        "legendFormat": "MTTR P1 (min)"
      }],
      "fieldConfig": {
        "defaults": {"unit": "m"}
      }
    },
    {
      "id": 5,
      "title": "Recurring Incidents (Top 5)",
      "type": "table",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 8},
      "targets": [{
        "expr": "topk(5, sum by (root_cause) (increase(incidents_total[30d])))",
        "format": "table",
        "instant": true
      }],
      "transformations": [
        {
          "id": "organize",
          "options": {
            "renameByName": {"Value": "Count", "root_cause": "Root Cause"}
          }
        }
      ]
    },
    {
      "id": 6,
      "title": "Overdue Action Items",
      "type": "table",
      "gridPos": {"h": 8, "w": 24, "x": 0, "y": 16},
      "targets": [{
        "expr": "action_items_due_date < time() and action_items_status == 0",
        "format": "table",
        "instant": true
      }],
      "transformations": [
        {
          "id": "organize",
          "options": {
            "renameByName": {
              "id": "ID",
              "owner": "Owner",
              "due_date": "Due Date",
              "description": "Description"
            }
          }
        }
      ]
    }
  ]
}
```

#### 4.1.10 สรุปย่อ

PSR คือกระบวนการทบทวน Incident อย่างเป็นระบบแบบ Blameless ที่มุ่งเน้นการเรียนรู้และป้องกันการเกิดซ้ำ ไม่ใช่การหาคนผิด ต้องทำภายใน 48 ชั่วโมงสำหรับ P1 และ 5 วันทำการสำหรับ P2 ทุก PSR ต้องมี Timeline, Impact, RCA, Action Item ที่มี Owner + Due Date + Acceptance Criteria

#### 4.1.11 ประโยชน์ที่ได้รับ

1. **เรียนรู้จาก Incident:** ไม่ปล่อยให้เหตุการณ์ผ่านไปโดยไม่ได้อะไร
2. **ป้องกันการเกิดซ้ำ:** Action Item ที่วัดผลได้
3. **ปรับปรุงกระบวนการ:** ระบุ Process Gap ไม่ใช่แค่ Technical Fix
4. **สร้างวัฒนธรรม:** Blameless Culture ทำให้ทีมกล้ารายงานความจริง
5. **สื่อสารกับ Stakeholder:** PSR Report เป็นหลักฐานความโปร่งใส

#### 4.1.12 ข้อควรระวัง

1. **อย่าทำ PSR เป็นพิธีกรรม:** ต้องได้ Action Item ที่วัดผลได้จริง
2. **อย่าให้ PSR กลายเป็น Blame Session:** Facilitator ต้องคุม
3. **อย่าละเลย Timeline:** Timeline ที่ไม่แม่นทำให้ RCA ผิด
4. **อย่าตั้ง Action Item กว้างเกินไป:** "ปรับปรุงระบบ" ไม่ใช่ Action Item
5. **อย่าทิ้ง Action Item:** ต้องติดตาม Weekly

#### 4.1.13 ข้อดี

1. **เป็นระบบ:** มี Template และ Process ชัดเจน
2. **วัดผลได้:** PSR Completion Rate, Action Item Completion Rate
3. **Scalable:** ใช้ได้ทั้ง Incident เล็กและใหญ่
4. **สร้างวัฒนธรรม:** Blameless Culture ทำให้ทีมเรียนรู้
5. **Audit Trail:** มีหลักฐานสำหรับ Compliance

#### 4.1.14 ข้อเสีย

1. **ใช้เวลา:** PSR Meeting 60 นาที + Report 2-4 ชั่วโมง
2. **ต้องมี Facilitator:** ต้องฝึกฝน
3. **อาจกลายเป็น Checkbox:** ถ้าองค์กรไม่จริงจัง
4. **ไม่เหมาะกับ P3/P4:** Overhead สูงเกินไป

#### 4.1.15 ข้อห้าม

1. **ห้ามใช้ PSR เพื่อหาคนผิด** — จะทำลายวัฒนธรรม
2. **ห้ามเลื่อน PSR เกิน 48 ชั่วโมง (P1)** — ข้อมูลจะเลือนหาย
3. **ห้ามตั้ง Action Item โดยไม่มี Owner** — จะไม่มีใครรับผิดชอบ
4. **ห้ามตั้ง Action Item โดยไม่มี Due Date** — จะค้างตลอดไป
5. **ห้ามปิด PSR โดยไม่มี RCA** — จะไม่รู้สาเหตุราก
6. **ห้ามใช้ PSR แทน RCA** — ทั้งสองเป็นกระบวนการต่างกัน (ดู 4.2)

#### 4.1.16 ตัวอย่าง

**สถานการณ์:** Checkout Service ล่ม 25 นาที กระทบผู้ใช้ 5,000 คน

**PSR Summary:**
- **Impact:** 5,000 users, ~200,000 บาท, SLA Breach
- **Timeline:** Alert 10:00 → Ack 10:02 → Root Cause 10:15 → Fix 10:20 → Resolved 10:25
- **Root Cause:** Database Connection Pool ขนาด 10 ไม่พอรับ Traffic Peak
- **What Went Well:** Alert เร็ว, DBA ตอบสนองเร็ว
- **What to Improve:** ไม่มี Alert Pool Utilization, ไม่มี Runbook
- **Action Items:**
  - AI-01: เพิ่ม Alert Pool > 80% (Owner: Support A, Due: +7d)
  - AI-02: เขียน Runbook (Owner: Support B, Due: +14d)
  - AI-03: เพิ่ม Pool Size ใน HPA (Owner: Dev Lead, Due: +30d)

#### 4.1.17 สรุปย่อเพื่อจดจำ

> **"PSR = Blameless + Factual + Actionable"**
>
> **"P1: 48 ชั่วโมง | P2: 5 วัน | P3/P4: ตามดุลพินิจ"**
>
> **"Action Item ที่ดี = Owner + Due Date + Acceptance Criteria"**

#### 4.1.18 แหล่งที่มาและแหล่งอ้างอิง

1. Google SRE Book — *Postmortem Culture*: https://sre.google/sre-book/postmortem-culture/
2. PagerDuty — *Post-Incident Reviews*: https://response.pagerduty.com/after/post_mortem_process/
3. Etsy — *Debriefing Facilitation Guide*: https://github.com/etsy/DebriefingFacilitationGuide
4. Atlassian — *Incident Postmortem Template*: https://www.atlassian.com/incident-management/postmortem/templates
5. Jeli — *Learning from Incidents*: https://www.jeli.io/

---

### 4.2 RCA (Root Cause Analysis)

#### 4.2.1 เรื่อง

**RCA: กระบวนการวิเคราะห์สาเหตุรากด้วยเทคนิค 5 Whys, Ishikawa (Fishbone) และ Fault Tree Analysis**

#### 4.2.2 วัตถุประสงค์ของหัวข้อนี้

เพื่อให้ทีม Support สามารถค้นหาสาเหตุที่แท้จริงของปัญหา ไม่ใช่แค่แก้ Symptom — และสามารถใช้เทคนิค RCA ที่เหมาะสมกับสถานการณ์

#### 4.2.3 เป้าหมายของหัวข้อนี้

1. RCA เสร็จภายใน 48 ชั่วโมงหลัง PSR (สำหรับ P1)
2. Root Cause ที่ระบุต้องเป็น **Process Gap** หรือ **Systemic Issue** ไม่ใช่ "Human Error"
3. ทุก RCA ต้องมี **Evidence** ประกอบ (Log, Metrics, Trace)
4. Action Item จาก RCA ต้องป้องกันการเกิดซ้ำได้จริง (วัดผลได้)

#### 4.2.4 เนื้อหา / รายละเอียด

**RCA คืออะไร?**

RCA (Root Cause Analysis) คือกระบวนการ **ระบุสาเหตุที่แท้จริง** ของความล้มเหลว เพื่อให้สามารถแก้ไขได้อย่างถาวร ไม่ใช่แค่แก้ Symptom

**Symptom vs Root Cause:**

| ระดับ | ตัวอย่าง | การแก้ไข |
|---|---|---|
| **Symptom** | ระบบช้า | Restart Service (ชั่วคราว) |
| **Proximate Cause** | Database Query ช้า | เพิ่ม Index (แก้ตรงจุด) |
| **Root Cause** | ไม่มี Process ตรวจสอบ Query Performance ก่อน Deploy | เพิ่ม Query Review ใน CI/CD (ถาวร) |

**เทคนิค RCA ที่ใช้บ่อย:**

**1. 5 Whys (Taiichi Ohno, Toyota Production System)**

ถาม "ทำไม" ซ้ำ ๆ 5 ครั้ง เพื่อไล่จาก Symptom ไป Root Cause

**2. Ishikawa (Fishbone) Diagram**

จัดหมวดหมู่สาเหตุที่เป็นไปได้ใน 6 หมวด (6M): Man, Machine, Method, Material, Measurement, Environment

**3. Fault Tree Analysis (FTA)**

วิเคราะห์เชิง Deductive จาก Top Event ลงไปยัง Basic Events ด้วย Logic Gate (AND, OR)

**4. Pareto Analysis**

ระบุ 20% ของสาเหตุที่ทำให้เกิด 80% ของปัญหา

**5. Kepner-Tregoe Problem Analysis**

เปรียบเทียบ "คือ" กับ "ไม่ใช่" เพื่อแคบขอบเขตปัญหา

#### 4.2.5 การติดตั้ง / การตั้งค่า (RCA Process Setup)

**A. RCA Workflow (ผูกกับ PSR)**

```
PSR Meeting เสร็จ
    │
    ├── ระบุว่า Incident ต้องการ RCA หรือไม่
    │   ├── P1 → บังคับ RCA
    │   ├── P2 → บังคับถ้า Recurring
    │   └── P3/P4 → Optional
    │
    ├── Assign RCA Owner (Support + Dev + DBA)
    │
    ├── เลือกเทคนิค RCA
    │   ├── ปัญหาง่าย, Linear → 5 Whys
    │   ├── ปัญหาซับซ้อน, หลายปัจจัย → Ishikawa
    │   ├── ระบบ Safety-critical → FTA
    │   └── ปัญหาเกิดซ้ำ → Pareto
    │
    ├── เก็บ Evidence
    │   ├── Log (ELK)
    │   ├── Metrics (Prometheus/Grafana)
    │   ├── Trace (Jaeger/Tempo)
    │   └── Change History (Git, CI/CD)
    │
    ├── ประชุม RCA (60-90 นาที)
    │
    ├── Draft RCA Report
    │
    ├── Review + Approve
    │
    └── สร้าง Action Item (ผูกกับ PSR)
```

**B. Evidence Collection Template (Markdown)**

```markdown
# Evidence Bundle — [Incident ID]

## 1. Metrics Snapshot
- Grafana Snapshot: [Link]
- Prometheus Query: `rate(http_requests_total{status=~"5.."}[5m])`
- ช่วงเวลาที่เกิดปัญหา: YYYY-MM-DD HH:MM - HH:MM

## 2. Log Snippets
- Kibana Query: `service: checkout AND level: ERROR`
- Correlation ID: `abc-123-def`
- Stack Trace: (แนบ)

## 3. Trace
- Trace ID: `xyz-789`
- Span ที่ช้าที่สุด: `PaymentGateway.charge` (5.2s)

## 4. Change History
- Deploy ล่าสุด: `v2.3.1` (YYYY-MM-DD HH:MM)
- Config Change: `DB_POOL_SIZE 10 → 10` (ไม่มี Change)
- Migration: `20261115_add_index` (YYYY-MM-DD)

## 5. Related Incidents
- INC-XXXX (2026-10-15) — Root Cause คล้ายกัน
- INC-YYYY (2026-09-20) — Root Cause คล้ายกัน
```

#### 4.2.6 การวิเคราะห์และแนวทางแก้ไข

**A. วิธีใช้ 5 Whys อย่างถูกต้อง**

**❌ 5 Whys ที่แย่ (หยุดที่ Human Error):**
```
Why 1: ระบบล่ม? → Database Connection Pool หมด
Why 2: Pool หมด? → มี Query ช้า
Why 3: Query ช้า? → ไม่มี Index
Why 4: ไม่มี Index? → Developer ลืม
Why 5: ลืม? → Human Error  ← หยุดผิดที่
```

**✅ 5 Whys ที่ดี (ไปถึง Process Gap):**
```
Why 1: ระบบล่ม? → Database Connection Pool หมด
Why 2: Pool หมด? → มี Query ช้า (5s ต่อ Query)
Why 3: Query ช้า? → ไม่มี Index บน column `status`
Why 4: ไม่มี Index? → ไม่มี Query Performance Review ใน Code Review
Why 5: ไม่มี Review? → CI/CD ไม่มี Slow Query Check ← Root Cause (Process Gap)
```

**B. วิธีใช้ Ishikawa (Fishbone)**

```
                          ┌─── Man ─────────────┐
                          │ • ไม่มี Training     │
                          │ • On-call ใหม่       │
                          └──────────────────────┘
                          ┌─── Machine ──────────┐
                          │ • DB Server CPU 100% │
                          │ • Disk I/O Saturation│
                          └──────────────────────┘
                          ┌─── Method ───────────┐
   [Incident:             │ • ไม่มี Index Review │
    Checkout              │ • ไม่มี Runbook      │
    Timeout] ────────────┤ └──────────────────────┘
                          ┌─── Material ─────────┐
                          │ • Library Version เก่า│
                          └──────────────────────┘
                          ┌─── Measurement ──────┐
                          │ • ไม่มี Alert Pool   │
                          └──────────────────────┘
                          ┌─── Environment ──────┐
                          │ • Traffic Peak       │
                          └──────────────────────┘
```

**C. วิธีใช้ Fault Tree Analysis (FTA)**

```
                    [Checkout Timeout]
                            │
                          (OR)
              ┌─────────────┼─────────────┐
              ▼             ▼             ▼
        [DB Slow]    [Network Slow]  [App Bug]
              │             │             │
            (AND)         (OR)          (AND)
        ┌─────┴─────┐   ┌───┴───┐    ┌───┴───┐
        ▼           ▼   ▼       ▼    ▼       ▼
    [No Index] [Pool  [Loss]  [Jitter] [Null] [Race]
                Full]
```

**ตารางวินิจฉัยปัญหา RCA:**

| อาการ | สาเหตุที่เป็นไปได้ | แนวทางแก้ไข |
|---|---|---|
| RCA หยุดที่ "Human Error" | ไม่ได้ถามต่อ | ถามต่อว่า "ทำไมระบบอนุญาตให้ Human Error เกิดได้" |
| RCA ไม่มี Evidence | เก็บข้อมูลไม่พอ | ใช้ Evidence Bundle Template, เก็บก่อนจบ Incident |
| RCA ใช้เวลานาน | ไม่มี Facilitator | Assign Facilitator, Time-box 90 นาที |
| RCA ได้ข้อสรุปไม่ตรงกัน | ไม่มี Consensus Method | ใช้ Dot Voting หรือ Fist of Five |
| RCA ไม่นำไปสู่ Action | ไม่ได้ Focus ที่ Process | ทุก Finding ต้อง Map ไป Action Item |

**Runbook: "จะทำ RCA อย่างไรให้ได้ Root Cause จริง?"**

1. **เตรียม Evidence** (ก่อนประชุม)
   - Metrics, Logs, Traces, Change History
2. **เลือกเทคนิค** (ตามความซับซ้อน)
   - Linear → 5 Whys
   - Multi-factor → Ishikawa
   - Safety-critical → FTA
3. **ประชุม RCA** (60-90 นาที)
   - 15 นาที: ทบทวน Timeline
   - 30 นาที: ใช้เทคนิค RCA
   - 15 นาที: ระบุ Root Cause
   - 15 นาที: Map ไป Action Item
4. **เขียน RCA Report** (2-4 ชั่วโมง)
5. **Review + Approve**
6. **Track Action Item** (Weekly)

#### 4.2.7 ลำดับการจัดการปัญหา (RCA Flow)

| ลำดับ | ขั้นตอน | ผู้รับผิดชอบ | Output |
|:---:|---|---|---|
| 1 | PSR Meeting ระบุว่า Incident ต้องการ RCA | Facilitator | RCA Required = Yes |
| 2 | Assign RCA Owner | Team Lead | Owner |
| 3 | เลือกเทคนิค RCA | RCA Owner | Technique Selected |
| 4 | Collect Evidence | Support + Dev + DBA | Evidence Bundle |
| 5 | RCA Meeting (60-90 นาที) | Facilitator | Findings |
| 6 | Draft RCA Report | RCA Owner | Draft |
| 7 | Review + Approve | Dev Lead + Product Owner | Approved |
| 8 | Map Findings → Action Items | RCA Owner + IC | Action Items |
| 9 | Publish RCA Report | Facilitator | Published |
| 10 | Track Action Items | Team Lead | Status Update |
| 11 | Verify Prevention | Team Lead | Verified |

#### 4.2.8 Template Code

**A. RCA Report Template (Markdown)**

```markdown
# RCA Report: [Incident Title]

**Incident ID:** INC-XXXX
**Linked PSR:** PSR-XXXX
**RCA Owner:** [ชื่อ]
**Technique:** 5 Whys / Ishikawa / FTA
**Date:** YYYY-MM-DD
**Status:** Draft / Reviewed / Approved

---

## 1. Problem Statement
[อธิบายปัญหา 1-2 ประโยค: เกิดอะไร, ที่ไหน, เมื่อไหร่, ผลกระทบ]

**Example:** Checkout Service ตอบสนองช้า (p99 > 5s) ระหว่างเวลา 10:00-10:25 UTC+7 กระทบผู้ใช้ 5,000 คน

## 2. Evidence
| ประเภท | รายละเอียด | Link |
|---|---|---|
| Metrics | p99 Latency 5.2s, Connection Pool 100% | [Grafana] |
| Logs | `ERROR: connection timeout` 1,234 ครั้ง | [Kibana] |
| Traces | `PaymentGateway.charge` 5.2s | [Jaeger] |
| Change | Deploy v2.3.1 (10:00) | [Git] |

## 3. Analysis (5 Whys)

| Why | Question | Answer | Evidence |
|---|---|---|---|
| 1 | ทำไม Checkout ช้า? | Database Connection Pool หมด | Metric `db_pool_used = 100%` |
| 2 | ทำไม Pool หมด? | Query ใช้เวลา 5s ต่อ Query | Slow Query Log |
| 3 | ทำไม Query ช้า? | ไม่มี Index บน `orders.status` | EXPLAIN PLAN |
| 4 | ทำไมไม่มี Index? | ไม่มี Query Performance Review ใน Code Review | Code Review Checklist |
| 5 | ทำไมไม่มี Review? | CI/CD ไม่มี Slow Query Check | CI/CD Config |

## 4. Root Cause
**Primary Root Cause:** CI/CD Pipeline ไม่มี Slow Query Detection ทำให้ Query ที่ไม่มี Index ผ่านเข้าสู่ Production ได้

**Contributing Factors:**
- Connection Pool Size ไม่ได้ถูก Monitor
- ไม่มี Runbook สำหรับ Connection Pool Exhaustion
- Traffic เพิ่มขึ้น 3x จาก Campaign (ไม่ได้คาดการณ์)

## 5. 5 Whys Diagram
```
[Checkout ช้า]
    │ Why?
    ▼
[DB Pool หมด]
    │ Why?
    ▼
[Query 5s]
    │ Why?
    ▼
[ไม่มี Index]
    │ Why?
    ▼
[ไม่มี Query Review]
    │ Why?
    ▼
[CI/CD ไม่มี Slow Query Check]  ← Root Cause
```

## 6. Action Items
| ID | Action | Owner | Due | Acceptance Criteria | Priority |
|---|---|---|---|---|---|
| AI-01 | เพิ่ม Slow Query Check ใน CI/CD | Dev Lead | +14d | PR ที่มี Query > 1s ถูก Flag | High |
| AI-02 | เพิ่ม Index บน `orders.status` | DBA | +3d | EXPLAIN PLAN ใช้ Index | High |
| AI-03 | เพิ่ม Alert Connection Pool > 80% | Support A | +7d | Alert ยิงใน Staging | High |
| AI-04 | เขียน Runbook Connection Pool | Support B | +14d | Runbook Published | Medium |
| AI-05 | ทบทวน Capacity Planning | SRE | +30d | Capacity Plan Updated | Medium |

## 7. Lessons Learned
1. **Process Gap สำคัญกว่า Technical Fix** — การเพิ่ม Index แก้ปัญหาเฉพาะหน้า แต่การเพิ่ม Slow Query Check ป้องกันการเกิดซ้ำ
2. **Monitoring ต้องครอบคลุม Resource** — Connection Pool เป็น Resource ที่มักถูกลืม
3. **Capacity Planning ต้องรวม Campaign** — Traffic Peak จาก Campaign ต้องถูกคาดการณ์ล่วงหน้า

## 8. Verification Plan
| Action Item | วิธี Verify | กำหนด |
|---|---|---|
| AI-01 | สร้าง PR ที่มี Slow Query → ต้องถูก Flag | +14d |
| AI-02 | รัน EXPLAIN → ต้องใช้ Index | +3d |
| AI-03 | รัน Load Test → Alert ต้องยิง | +7d |
| AI-04 | ทดสอบ Runbook ใน Staging | +14d |
| AI-05 | Review Capacity Plan กับ SRE | +30d |

## 9. Approvals
| Role | Name | Date |
|---|---|---|
| RCA Owner | | |
| Dev Lead | | |
| Product Owner | | |
| SRE Lead | | |
```

**B. 5 Whys Worksheet Template**

```markdown
# 5 Whys Worksheet — [Incident ID]

**Problem Statement:** [อธิบายปัญหา]

**Technique:** 5 Whys
**Facilitator:** [ชื่อ]
**Participants:** [รายชื่อ]

---

## Why Chain

| # | Why | Answer | Evidence | Confidence |
|---|---|---|---|---|
| 1 | Why did [problem] happen? | | | High/Med/Low |
| 2 | Why did [answer 1] happen? | | | |
| 3 | Why did [answer 2] happen? | | | |
| 4 | Why did [answer 3] happen? | | | |
| 5 | Why did [answer 4] happen? | | | |

**Root Cause:** [สรุป]

**Validation:** [อธิบายว่าทำไมจึงมั่นใจว่านี่คือ Root Cause]

**Action Items:**
| ID | Action | Owner | Due |
|---|---|---|---|
| | | | |
```

**C. Ishikawa (Fishbone) Diagram Template**

```markdown
# Ishikawa Diagram — [Incident ID]

**Problem (Head):** [อธิบายปัญหา]

**Technique:** Fishbone (6M)

---

## Man (คน)
- [ ] ไม่มี Training สำหรับ On-call ใหม่
- [ ] ไม่มี Second Pair of Eyes ใน Change

## Machine (เครื่อง)
- [ ] DB Server CPU 100%
- [ ] Disk I/O Saturation

## Method (กระบวนการ)
- [ ] ไม่มี Query Review ใน CI/CD
- [ ] ไม่มี Runbook สำหรับ Connection Pool

## Material (ข้อมูล/วัสดุ)
- [ ] Library Version เก่า (Known Bug)
- [ ] Config ผิด

## Measurement (การวัด)
- [ ] ไม่มี Alert Connection Pool
- [ ] ไม่มี Dashboard สำหรับ Slow Query

## Environment (สภาพแวดล้อม)
- [ ] Traffic Peak จาก Campaign
- [ ] Network Latency สูง

---

## Prioritization (Dot Voting)
| สาเหตุ | Votes | Priority |
|---|---|---|
| ไม่มี Query Review | 5 | High |
| ไม่มี Alert Pool | 4 | High |
| Traffic Peak | 3 | Medium |
| Library Version เก่า | 1 | Low |

## Root Cause(s)
[สาเหตุที่ได้ Priority สูงสุด]
```

#### 4.2.9 Template Dashboard

**Grafana Dashboard: RCA Evidence Collection**

```json
{
  "title": "RCA Evidence — [Incident ID]",
  "uid": "rca-evidence-v1",
  "refresh": "30s",
  "time": {"from": "now-2h", "to": "now"},
  "panels": [
    {
      "id": 1,
      "title": "Error Rate (5m)",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 0},
      "targets": [{
        "expr": "sum(rate(http_requests_total{status=~\"5..\"}[5m])) by (service)",
        "legendFormat": "{{service}}"
      }]
    },
    {
      "id": 2,
      "title": "P99 Latency (5m)",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 0},
      "targets": [{
        "expr": "histogram_quantile(0.99, sum(rate(http_request_duration_seconds_bucket[5m])) by (le, service))",
        "legendFormat": "{{service}}"
      }]
    },
    {
      "id": 3,
      "title": "DB Connection Pool Usage",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 8},
      "targets": [{
        "expr": "db_pool_used / db_pool_max * 100",
        "legendFormat": "{{instance}}"
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "max": 100,
          "thresholds": {
            "steps": [
              {"color": "green", "value": null},
              {"color": "yellow", "value": 80},
              {"color": "red", "value": 95}
            ]
          }
        }
      }
    },
    {
      "id": 4,
      "title": "Slow Queries (>1s)",
      "type": "table",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 8},
      "targets": [{
        "expr": "topk(10, pg_stat_statements_mean_time_seconds)",
        "format": "table",
        "instant": true
      }],
      "transformations": [
        {
          "id": "organize",
          "options": {
            "renameByName": {"query": "Query", "Value": "Mean Time (s)"}
          }
        }
      ]
    },
    {
      "id": 5,
      "title": "Deploy & Change Events",
      "type": "annotations",
      "gridPos": {"h": 4, "w": 24, "x": 0, "y": 16},
      "datasource": {"type": "grafana", "uid": "-- Grafana --"},
      "targets": [{
        "expr": "deploy_event",
        "format": "table"
      }]
    }
  ]
}
```

#### 4.2.10 สรุปย่อ

RCA คือกระบวนการค้นหาสาเหตุรากที่แท้จริง ไม่ใช่แค่ Symptom ใช้เทคนิค 5 Whys (Linear), Ishikawa (Multi-factor), FTA (Safety-critical), Pareto (Recurring) Root Cause ที่ดีต้องเป็น Process Gap หรือ Systemic Issue ไม่ใช่ "Human Error" ทุก RCA ต้องมี Evidence และ Action Item ที่วัดผลได้

#### 4.2.11 ประโยชน์ที่ได้รับ

1. **แก้ที่ต้นเหตุ:** ลดการเกิดซ้ำ
2. **ประหยัดระยะยาว:** ไม่ต้อง Restart Service ซ้ำ ๆ
3. **ปรับปรุง Process:** ระบุ Process Gap
4. **หลักฐาน:** มี Evidence สำหรับ Audit
5. **สร้างวัฒนธรรม:** ทีมเรียนรู้จาก Root Cause

#### 4.2.12 ข้อควรระวัง

1. **อย่าหยุดที่ "Human Error":** ต้องถามต่อว่า "ทำไมระบบอนุญาต"
2. **อย่าเลือกเทคนิคผิด:** 5 Whys ไม่เหมาะกับ Multi-factor Problem
3. **อย่าละเลย Evidence:** RCA ที่ไม่มี Evidence = ความคิดเห็น
4. **อย่าทำ RCA คนเดียว:** ต้องมี Facilitator และ Participants หลายมุมมอง
5. **อย่าลืม Contributing Factors:** บาง Incident มีหลายสาเหตุ

#### 4.2.13 ข้อดี

1. **ระบบ:** มีเทคนิคที่พิสูจน์แล้ว
2. **ยืดหยุ่น:** เลือกเทคนิคได้ตามสถานการณ์
3. **วัดผลได้:** Action Item ที่ Verify ได้
4. **Scalable:** ใช้ได้ทั้ง Incident เล็กและใหญ่

#### 4.2.14 ข้อเสีย

1. **ใช้เวลา:** 60-90 นาทีสำหรับประชุม + 2-4 ชั่วโมงสำหรับ Report
2. **ต้องมี Facilitator:** ต้องฝึกฝน
3. **อาจ Bias:** ถ้า Participants ไม่หลากหลาย
4. **ไม่เหมาะกับ Incident เร่งด่วน:** ต้อง Mitigate ก่อน แล้วค่อย RCA

#### 4.2.15 ข้อห้าม

1. **ห้ามสรุป RCA จากข้อมูลไม่เพียงพอ** — ต้องมี Evidence
2. **ห้ามหยุดที่ "Human Error"** — ต้องถามต่อถึง Process
3. **ห้ามทำ RCA คนเดียว** — ต้องมี Participants หลายมุมมอง
4. **ห้ามใช้ RCA เป็น Blame Session** — ต้อง Blameless
5. **ห้ามตั้ง Action Item ที่วัดผลไม่ได้** — ต้องมี Acceptance Criteria
6. **ห้ามปิด RCA โดยไม่ Verify Action Item** — ต้องตรวจสอบว่าป้องกันได้จริง

#### 4.2.16 ตัวอย่าง

**สถานการณ์:** Checkout Service ล่ม 25 นาที

**การประยุกต์ใช้ 5 Whys:**
```
1. Why Checkout ช้า? → DB Connection Pool หมด
2. Why Pool หมด? → Query ใช้เวลา 5s
3. Why Query ช้า? → ไม่มี Index บน orders.status
4. Why ไม่มี Index? → ไม่มี Query Review ใน CI/CD
5. Why ไม่มี Review? → CI/CD ไม่มี Slow Query Check ← Root Cause
```

**การประยุกต์ใช้ Ishikawa:**
- **Man:** ไม่มี Training Query Performance
- **Machine:** DB CPU 100%
- **Method:** ไม่มี Query Review
- **Material:** Library Version เก่า
- **Measurement:** ไม่มี Alert Pool
- **Environment:** Traffic Peak

**Root Cause:** Method (ไม่มี Query Review) + Measurement (ไม่มี Alert Pool)

**Action Items:**
- AI-01: เพิ่ม Slow Query Check ใน CI/CD
- AI-02: เพิ่ม Index บน orders.status
- AI-03: เพิ่ม Alert Connection Pool > 80%
- AI-04: เขียน Runbook Connection Pool
- AI-05: ทบทวน Capacity Planning

#### 4.2.17 สรุปย่อเพื่อจดจำ

> **"RCA = หาต้นตอ ไม่ใช่ใบไม้ที่ร่วง"**
>
> **"5 Whys สำหรับ Linear, Ishikawa สำหรับ Multi-factor, FTA สำหรับ Safety-critical"**
>
> **"หยุดที่ Process Gap ไม่ใช่ Human Error"**

#### 4.2.18 แหล่งที่มาและแหล่งอ้างอิง

1. Taiichi Ohno — *Toyota Production System* (5 Whys)
2. Kaoru Ishikawa — *Guide to Quality Control* (Fishbone)
3. IEEE 982.1 — *Standard for Measures to Detect Unacceptable Software Reliability*
4. iSixSigma — *Root Cause Analysis*: https://www.isixsigma.com/tools-templates/cause-effect/
5. ASQ — *Fishbone Diagram*: https://asq.org/quality-resources/fishbone
6. Kepner & Tregoe — *The New Rational Manager*

---

### 4.3 KPI SMART

#### 4.3.1 เรื่อง

**KPI SMART: การกำหนดตัวชี้วัดผลการดำเนินงานสำหรับทีม Application Support ตามหลัก SMART**

#### 4.3.2 วัตถุประสงค์ของหัวข้อนี้

เพื่อให้ทีม Support มี KPI ที่ชัดเจน วัดได้ และเชื่อมโยงกับเป้าหมายธุรกิจ — ไม่ใช่ KPI ที่ตั้งขึ้นลอย ๆ

#### 4.3.3 เป้าหมายของหัวข้อนี้

1. KPI ทุกตัวในทีมเป็น SMART 100%
2. KPI ติดตามผลทุกเดือน
3. KPI เชื่อมโยงกับ SLO ของระบบ
4. KPI ใช้เป็นเครื่องมือปรับปรุง ไม่ใช่เครื่องมือลงโทษ
5. ทีมเข้าใจว่าทำไม KPI แต่ละตัวถึงสำคัญ

#### 4.3.4 เนื้อหา / รายละเอียด

**KPI SMART คืออะไร?**

KPI ที่ดีต้องเป็น **SMART**:

| ตัวอักษร | ความหมาย | คำถามที่ต้องตอบ | ตัวอย่างแย่ | ตัวอย่างดี |
|---|---|---|---|---|
| **S** — Specific | เจาะจง | "วัดอะไร กับใคร ในบริบทไหน" | "ปรับปรุงบริการ" | "ลด MTTR ของ P1 Incident" |
| **M** — Measurable | วัดได้ | "วัดอย่างไร หน่วยอะไร" | "ดีขึ้น" | "MTTR ≤ 30 นาที" |
| **A** — Achievable | บรรลุได้ | "Baseline เท่าไร เป้าสมเหตุสมผลไหม" | "MTTR ≤ 0 นาที" | "MTTR ≤ 30 นาที (Baseline 60)" |
| **R** — Relevant | สอดคล้อง | "เกี่ยวกับเป้าหมายธุรกิจไหม" | "จำนวน Ticket ที่ปิด" | "Customer Satisfaction ≥ 4.5" |
| **T** — Time-bound | มีกรอบเวลา | "ภายในเมื่อไหร่" | "ทำให้ดีขึ้น" | "ภายใน Q4/2026" |

**KPI ที่แนะนำสำหรับ Application Support:**

| หมวด | KPI | สูตร | เป้าหมาย | เหตุผล |
|---|---|---|---|---|
| **Availability** | Application Uptime | `(Total Time - Downtime) / Total Time × 100` | ≥ 99.9% | SLA กับลูกค้า |
| **Speed** | MTTR (P1) | `Σ Resolve Time / จำนวน P1` | ≤ 30 นาที | ลด Downtime |
| **Speed** | MTTR (P2) | `Σ Resolve Time / จำนวน P2` | ≤ 4 ชั่วโมง | ลดผลกระทบ |
| **Speed** | First Response Time | `Σ (First Response - Ticket Created) / จำนวน Ticket` | ≤ 15 นาที | ตอบสนองเร็ว |
| **Quality** | PSR Completion Rate (P1/P2) | `PSR ที่เสร็จตามกำหนด / PSR ที่ต้องทำ × 100` | ≥ 95% | เรียนรู้จาก Incident |
| **Quality** | Action Item Completion Rate | `Action Item ที่ปิดตามกำหนด / Action Item ทั้งหมด × 100` | ≥ 90% | ป้องกันการเกิดซ้ำ |
| **Quality** | Recurring Incident Rate | `Incident ซ้ำ / Incident ทั้งหมด × 100` | ≤ 5% | ลดปัญหาเดิม |
| **Quality** | Change Success Rate | `Change ที่สำเร็จ / Change ทั้งหมด × 100` | ≥ 95% | ลด Change Failure |
| **Customer** | CSAT | `Σ คะแนน / จำนวนผู้ตอบ` | ≥ 4.5/5 | ความพึงพอใจลูกค้า |
| **Customer** | SLA Compliance | `SLA ที่บรรลุ / SLA ทั้งหมด × 100` | ≥ 99% | รักษาสัญญา |
| **Efficiency** | Automation Rate | `Task ที่ Automate / Task ทั้งหมด × 100` | ≥ 60% | ลด Manual Work |
| **Learning** | Knowledge Base Coverage | `KB ที่มี / Incident Type ทั้งหมด × 100` | ≥ 80% | Onboarding เร็ว |

**Anti-Pattern ของ KPI ที่ต้องหลีกเลี่ยง:**

| Anti-Pattern | ตัวอย่าง | ปัญหา |
|---|---|---|
| **Vanity Metric** | จำนวน Ticket ที่ปิด | ปิด Ticket โดยไม่แก้ปัญหา |
| **Single Metric** | ดูแค่ MTTR | ทีมเร่งแก้จนคุณภาพลด |
| **Gaming** | ตั้ง KPI "ปิด Ticket ภายใน 1 ชั่วโมง" | ทีมปิด Ticket ก่อนแก้จริง |
| **Unmeasurable** | "ปรับปรุงบริการ" | วัดไม่ได้ |
| **Too Many** | KPI 30 ตัว | โฟกัสกระจัดกระจาย |

#### 4.3.5 การติดตั้ง / การตั้งค่า (KPI Setup)

**A. KPI Definition Template (Markdown)**

```markdown
# KPI Definition: [ชื่อ KPI]

## 1. Basic Info
- **KPI ID:** KPI-XXX
- **KPI Name:** [ชื่อ]
- **Category:** Availability / Speed / Quality / Customer / Efficiency / Learning
- **Owner:** [ชื่อผู้รับผิดชอบ]
- **Review Frequency:** Monthly / Quarterly

## 2. SMART Definition
- **Specific:** [วัดอะไร กับใคร ในบริบทไหน]
- **Measurable:** [สูตรและหน่วย]
- **Achievable:** [Baseline และเป้าหมาย พร้อมเหตุผล]
- **Relevant:** [เชื่อมโยงกับเป้าหมายธุรกิจอย่างไร]
- **Time-bound:** [กรอบเวลา]

## 3. Formula
```
KPI = [สูตร]
```

## 4. Data Source
- **Source:** [Prometheus / Jira / Grafana / Survey]
- **Query:** [PromQL / JQL / SQL]
- **Refresh:** [Real-time / Daily / Monthly]

## 5. Targets
| Period | Baseline | Target | Stretch |
|---|---|---|---|
| Q4/2026 | 60 min | 30 min | 20 min |
| Q1/2027 | 30 min | 25 min | 15 min |

## 6. Thresholds
| สถานะ | ช่วง | การดำเนินการ |
|---|---|---|
| 🟢 Green | ≥ Target | ไม่ต้องดำเนินการ |
| 🟡 Yellow | 80%-99% ของ Target | ทบทวนสาเหตุ |
| 🔴 Red | < 80% ของ Target | สร้าง Action Plan |

## 7. Reporting
- **Dashboard:** [Link]
- **Report:** Monthly KPI Scorecard
- **Audience:** Team Lead, Manager, Stakeholder

## 8. Related KPIs
- [KPI-YYY] — [ความสัมพันธ์]

## 9. History
| Date | Change | Reason |
|---|---|---|
| 2026-11-18 | Created | Initial |
```

**B. PromQL สำหรับ KPI ที่วัดจาก Metrics**

```promql
# Availability (Application Uptime)
(
  sum(up{job="app"})
  /
  count(up{job="app"})
) * 100

# MTTR (ต้องมี Metrics จาก Incident Management)
avg(incident_resolve_time_minutes{severity="P1"})

# Error Budget Burn Rate
(
  sum(rate(http_requests_total{status=~"5.."}[1h]))
  /
  sum(rate(http_requests_total[1h]))
) / (1 - 0.999)   # SLO 99.9%
```

**C. JQL สำหรับ KPI ที่วัดจาก Jira**

```jql
-- PSR Completion Rate (P1/P2)
project = OPS AND issuetype = PSR
AND created >= startOfMonth()
AND status = Done
AND resolution = Done
AND (due <= resolutiondate)

-- Action Item Completion Rate
project = OPS AND issuetype = "Action Item"
AND created >= startOfMonth()
AND status = Done
AND due <= resolutiondate

-- Recurring Incident Rate
project = OPS AND issuetype = Incident
AND created >= startOfMonth()
AND labels in (recurring)
```

**D. KPI Scorecard Template (Markdown)**

```markdown
# KPI Scorecard — [เดือน/ไตรมาส]

**Period:** YYYY-MM
**Owner:** [ชื่อ Team Lead]
**Review Date:** YYYY-MM-DD

---

## 1. Summary
| หมวด | KPI ทั้งหมด | Green | Yellow | Red |
|---|---|---|---|---|
| Availability | 1 | 1 | 0 | 0 |
| Speed | 3 | 2 | 1 | 0 |
| Quality | 4 | 3 | 1 | 0 |
| Customer | 2 | 2 | 0 | 0 |
| Efficiency | 1 | 0 | 1 | 0 |
| Learning | 1 | 1 | 0 | 0 |
| **Total** | **12** | **9** | **3** | **0** |

## 2. KPI Detail

### KPI-01: Application Uptime
- **Target:** ≥ 99.9%
- **Actual:** 99.95%
- **Status:** 🟢 Green
- **Trend:** ↑ (จาก 99.92% เดือนที่แล้ว)
- **Comment:** ปรับปรุงจากเดือนที่แล้ว

### KPI-02: MTTR (P1)
- **Target:** ≤ 30 นาที
- **Actual:** 28 นาที
- **Status:** 🟢 Green
- **Trend:** → (คงที่)
- **Comment:** ยังอยู่ในเป้า แต่ใกล้ขีดจำกัด

### KPI-03: MTTR (P2)
- **Target:** ≤ 4 ชั่วโมง
- **Actual:** 4.5 ชั่วโมง
- **Status:** 🟡 Yellow
- **Trend:** ↑ (จาก 3.8 ชั่วโมง)
- **Comment:** เกิดจาก Incident ที่ต้องรอ Vendor — Action Plan: เพิ่ม Vendor Escalation Process

### KPI-04: PSR Completion Rate
- **Target:** ≥ 95%
- **Actual:** 100%
- **Status:** 🟢 Green
- **Trend:** ↑
- **Comment:** ทีมทำ PSR ครบทุก Incident

### KPI-05: Action Item Completion Rate
- **Target:** ≥ 90%
- **Actual:** 85%
- **Status:** 🟡 Yellow
- **Trend:** ↓ (จาก 92%)
- **Comment:** Action Item 3 ตัวค้างเกิน Due — Action Plan: เพิ่ม Weekly Review

### KPI-06: Recurring Incident Rate
- **Target:** ≤ 5%
- **Actual:** 3%
- **Status:** 🟢 Green
- **Trend:** ↓
- **Comment:** ลดลงจากการเพิ่ม Slow Query Check

## 3. Action Plan (สำหรับ Yellow/Red)
| KPI | Action | Owner | Due |
|---|---|---|---|
| KPI-03 | เพิ่ม Vendor Escalation Process | Support A | +14d |
| KPI-05 | เพิ่ม Weekly Action Item Review | Team Lead | +7d |

## 4. Next Month Focus
- ปรับปรุง MTTR (P2) ให้ ≤ 4 ชั่วโมง
- ปิด Action Item ที่ค้าง
- เตรียม Capacity Planning สำหรับ Campaign

## 5. Approvals
| Role | Name | Date |
|---|---|---|
| Team Lead | | |
| Manager | | |
```

#### 4.3.6 การวิเคราะห์และแนวทางแก้ไข

**ตารางวินิจฉัยปัญหา KPI:**

| อาการ | สาเหตุ | แนวทางแก้ไข |
|---|---|---|
| KPI ไม่บรรลุเป้า | เป้าสูงเกินไป (ไม่ Achievable) | ทบทวน Baseline, ปรับเป้าให้สมเหตุสมผล |
| KPI บรรลุแต่ลูกค้าไม่พอใจ | KPI ไม่ Relevant | ทบทวน KPI ให้เชื่อมกับ CSAT |
| ทีมไม่สนใจ KPI | ไม่มี Ownership | Assign Owner, เชื่อมกับ Performance Review (แบบ Constructive) |
| KPI ไม่ถูกวัด | ไม่มี Automation | สร้าง Dashboard, Automation ด้วย PromQL/JQL |
| KPI ถูก Gaming | ตั้ง KPI ผิด | ทบทวน KPI, เพิ่ม Counter-metric |
| KPI มากเกินไป | ตั้ง 20-30 ตัว | ลดเหลือ 8-12 ตัวที่สำคัญ |

**Runbook: "จะตั้ง KPI อย่างไรให้ได้ผล?"**

1. **เริ่มจากเป้าหมายธุรกิจ** (Top-down)
   - เช่น "ลด Customer Complaint 20%" → KPI: CSAT ≥ 4.5, MTTR ≤ 30 นาที
2. **กำหนด Baseline** (จากข้อมูลจริง)
   - ดูข้อมูล 3-6 เดือนย้อนหลัง
3. **ตั้งเป้า SMART**
   - Achievable: Baseline + 20-30%
4. **เลือก Metrics ที่วัดได้**
   - Prometheus, Jira, Survey
5. **สร้าง Dashboard**
   - Grafana KPI Scorecard
6. **Review Monthly**
   - ปรับเป้าถ้าจำเป็น
7. **Connect to Action**
   - ถ้า Yellow/Red → Action Plan

#### 4.3.7 ลำดับการจัดการปัญหา (KPI Flow)

| ลำดับ | ขั้นตอน | ผู้รับผิดชอบ | Output |
|:---:|---|---|---|
| 1 | กำหนดเป้าหมายธุรกิจ (Top-down) | Leadership | Business Goals |
| 2 | ระบุ KPI ที่เชื่อมโยง | Team Lead | KPI List |
| 3 | กำหนด Baseline | Data Analyst | Baseline Data |
| 4 | ตั้งเป้า SMART | Team Lead + Leadership | KPI Definition |
| 5 | สร้าง Dashboard | Support Engineer | Grafana Dashboard |
| 6 | ติดตาม Monthly | Team Lead | KPI Scorecard |
| 7 | วิเคราะห์ Yellow/Red | Team Lead + Owner | Action Plan |
| 8 | ปรับปรุง | Owner | Improvement |
| 9 | Review Quarterly | Leadership | Strategic Adjustment |

#### 4.3.8 Template Code

**A. KPI Definition Template (Full)**

ดูตัวอย่างเต็มในหัวข้อ 4.3.5 A

**B. KPI Scorecard Template (Full)**

ดูตัวอย่างเต็มในหัวข้อ 4.3.5 D

**C. PromQL สำหรับ KPI Dashboard**

```promql
# Application Uptime (%)
(
  sum(up{job="app"})
  /
  count(up{job="app"})
) * 100

# Error Budget Remaining (%)
(
  1 - (
    sum(increase(http_requests_total{status=~"5.."}[30d]))
    /
    sum(increase(http_requests_total[30d]))
  ) / (1 - 0.999)
) * 100

# MTTR Trend (P1)
avg_over_time(incident_resolve_time_minutes{severity="P1"}[30d])

# Change Success Rate
(
  sum(change_success_total)
  /
  sum(change_total)
) * 100
```

#### 4.3.9 Template Dashboard

**Grafana Dashboard: KPI Scorecard**

```json
{
  "title": "Application Support KPI Scorecard",
  "uid": "kpi-scorecard-v1",
  "refresh": "1h",
  "time": {"from": "now-30d", "to": "now"},
  "panels": [
    {
      "id": 1,
      "title": "Application Uptime",
      "type": "stat",
      "gridPos": {"h": 6, "w": 6, "x": 0, "y": 0},
      "targets": [{
        "expr": "(sum(up{job=\"app\"}) / count(up{job=\"app\"})) * 100",
        "instant": true
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "decimals": 2,
          "thresholds": {
            "steps": [
              {"color": "red", "value": null},
              {"color": "yellow", "value": 99.9},
              {"color": "green", "value": 99.95}
            ]
          }
        }
      }
    },
    {
      "id": 2,
      "title": "MTTR (P1)",
      "type": "stat",
      "gridPos": {"h": 6, "w": 6, "x": 6, "y": 0},
      "targets": [{
        "expr": "avg(incident_resolve_time_minutes{severity=\"P1\"})",
        "instant": true
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "m",
          "thresholds": {
            "steps": [
              {"color": "green", "value": null},
              {"color": "yellow", "value": 30},
              {"color": "red", "value": 60}
            ]
          }
        }
      }
    },
    {
      "id": 3,
      "title": "PSR Completion Rate",
      "type": "stat",
      "gridPos": {"h": 6, "w": 6, "x": 12, "y": 0},
      "targets": [{
        "expr": "(sum(psr_completed_on_time) / sum(psr_required)) * 100",
        "instant": true
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "thresholds": {
            "steps": [
              {"color": "red", "value": null},
              {"color": "yellow", "value": 80},
              {"color": "green", "value": 95}
            ]
          }
        }
      }
    },
    {
      "id": 4,
      "title": "CSAT",
      "type": "stat",
      "gridPos": {"h": 6, "w": 6, "x": 18, "y": 0},
      "targets": [{
        "expr": "avg(csat_score)",
        "instant": true
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "none",
          "decimals": 2,
          "max": 5,
          "thresholds": {
            "steps": [
              {"color": "red", "value": null},
              {"color": "yellow", "value": 4.0},
              {"color": "green", "value": 4.5}
            ]
          }
        }
      }
    },
    {
      "id": 5,
      "title": "Error Budget Remaining",
      "type": "gauge",
      "gridPos": {"h": 8, "w": 8, "x": 0, "y": 6},
      "targets": [{
        "expr": "(1 - (sum(increase(http_requests_total{status=~\"5..\"}[30d])) / sum(increase(http_requests_total[30d]))) / (1 - 0.999)) * 100",
        "instant": true
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "thresholds": {
            "steps": [
              {"color": "red", "value": null},
              {"color": "yellow", "value": 25},
              {"color": "green", "value": 50}
            ]
          }
        }
      }
    },
    {
      "id": 6,
      "title": "Recurring Incident Rate",
      "type": "stat",
      "gridPos": {"h": 8, "w": 8, "x": 8, "y": 6},
      "targets": [{
        "expr": "(sum(incidents_recurring) / sum(incidents_total)) * 100",
        "instant": true
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "thresholds": {
            "steps": [
              {"color": "green", "value": null},
              {"color": "yellow", "value": 5},
              {"color": "red", "value": 10}
            ]
          }
        }
      }
    },
    {
      "id": 7,
      "title": "Action Item Completion Rate",
      "type": "stat",
      "gridPos": {"h": 8, "w": 8, "x": 16, "y": 6},
      "targets": [{
        "expr": "(sum(action_items_closed) / sum(action_items_total)) * 100",
        "instant": true
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "thresholds": {
            "steps": [
              {"color": "red", "value": null},
              {"color": "yellow", "value": 80},
              {"color": "green", "value": 90}
            ]
          }
        }
      }
    },
    {
      "id": 8,
      "title": "MTTR Trend (P1 vs P2)",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 14},
      "targets": [
        {
          "expr": "avg(incident_resolve_time_minutes{severity=\"P1\"})",
          "legendFormat": "P1"
        },
        {
          "expr": "avg(incident_resolve_time_minutes{severity=\"P2\"})",
          "legendFormat": "P2"
        }
      ],
      "fieldConfig": {
        "defaults": {"unit": "m"}
      }
    },
    {
      "id": 9,
      "title": "KPI Status Summary",
      "type": "table",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 14},
      "targets": [{
        "expr": "kpi_status",
        "format": "table",
        "instant": true
      }],
      "transformations": [
        {
          "id": "organize",
          "options": {
            "renameByName": {
              "kpi": "KPI",
              "target": "Target",
              "actual": "Actual",
              "status": "Status"
            }
          }
        }
      ]
    }
  ]
}
```

#### 4.3.10 สรุปย่อ

KPI SMART คือตัวชี้วัดผลการดำเนินงานที่ Specific, Measurable, Achievable, Relevant, Time-bound KPI ที่ดีต้องเชื่อมโยงกับเป้าหมายธุรกิจ มี Owner ชัดเจน วัดผลได้ทุกเดือน และไม่ควรมีมากเกินไป (8-12 ตัวหลัก) ต้องหลีกเลี่ยง Vanity Metric, Single Metric และ Gaming

#### 4.3.11 ประโยชน์ที่ได้รับ

1. **ทิศทางชัดเจน:** ทีมรู้ว่าต้องโฟกัสอะไร
2. **วัดผลได้:** ติดตามความคืบหน้าได้ทุกเดือน
3. **ปรับปรุงต่อเนื่อง:** ระบุจุดที่ต้องพัฒนา
4. **Alignment:** เชื่อมโยงกับเป้าหมายธุรกิจ
5. ** Accountability:** มี Owner ชัดเจน

#### 4.3.12 ข้อควรระวัง

1. **KPI มากเกินไป:** ทำให้โฟกัสกระจัดกระจาย — ควรมี 8-12 ตัว
2. **KPI ที่ Gaming ได้:** เช่น จำนวน Ticket ที่ปิด → ควรมี Quality Counter-metric
3. **KPI ที่ไม่ Relevant:** เช่น จำนวน Login → ไม่ได้สะท้อนคุณภาพ
4. **KPI ที่ไม่ Achievable:** เช่น MTTR ≤ 0 นาที → ทำให้ทีมท้อ
5. **KPI ที่ไม่มี Owner:** จะไม่มีใครรับผิดชอบ

#### 4.3.13 ข้อดี

1. **เป็นระบบ:** มี Framework ที่ชัดเจน (SMART)
2. **วัดผลได้:** ติดตามได้ทุกเดือน
3. **Alignment:** เชื่อมโยงกับธุรกิจ
4. **Scalable:** ใช้ได้ทั้งทีมเล็กและใหญ่
5. **Transparent:** ทุกคนเห็นข้อมูลเดียวกัน

#### 4.3.14 ข้อเสีย

1. **อาจ Gaming:** ถ้าออกแบบไม่ดี
2. **ต้องมีข้อมูล:** ต้องมี Data Pipeline
3. **ใช้เวลาตั้งแต่เริ่ม:** ต้องกำหนด Baseline
4. **อาจทำให้ทีมเครียด:** ถ้าใช้ลงโทษ

#### 4.3.15 ข้อห้าม

1. **ห้ามใช้ KPI เดียวตัดสินผลงานทั้งหมด** — ต้องดูทั้ง Quality, Speed, Satisfaction
2. **ห้ามตั้ง KPI ที่ Gaming ได้ง่าย** — เช่น จำนวน Ticket ที่ปิด
3. **ห้ามใช้ KPI เป็นเครื่องมือลงโทษ** — ใช้เป็นเครื่องมือปรับปรุง
4. **ห้ามตั้ง KPI มากเกินไป** — ควรมี 8-12 ตัว
5. **ห้ามตั้ง KPI โดยไม่มี Owner** — จะไม่มีใครรับผิดชอบ
6. **ห้ามตั้ง KPI ที่ไม่ Measurable** — จะวัดไม่ได้

#### 4.3.16 ตัวอย่าง

**KPI ที่ดีสำหรับทีม Application Support:**

| KPI | สูตร | Baseline | Target | Time-bound |
|---|---|---|---|---|
| Application Uptime | `(Total - Downtime)/Total × 100` | 99.85% | ≥ 99.9% | Q4/2026 |
| MTTR (P1) | `Σ Resolve / #P1` | 60 นาที | ≤ 30 นาที | Q4/2026 |
| PSR Completion Rate | `PSR on-time / PSR required × 100` | 70% | ≥ 95% | Q4/2026 |
| Action Item Completion Rate | `AI closed / AI total × 100` | 60% | ≥ 90% | Q4/2026 |
| CSAT | `Σ Score / #Respondents` | 4.2 | ≥ 4.5 | Q4/2026 |

**KPI ที่แย่ (Anti-Pattern):**

| KPI | ปัญหา |
|---|---|
| "ปิด Ticket ภายใน 1 ชั่วโมง" | Gaming — ปิดก่อนแก้ |
| "จำนวน Login" | Vanity Metric — ไม่สะท้อนคุณภาพ |
| "ปรับปรุงระบบ" | Unmeasurable |
| "MTTR ≤ 0 นาที" | Not Achievable |

#### 4.3.17 สรุปย่อเพื่อจดจำ

> **"KPI = SMART — ถ้าไม่ Measurable ก็ไม่ใช่ KPI"**
>
> **"KPI ที่ดี = Owner + Baseline + Target + Time-bound + Counter-metric"**
>
> **"KPI 8-12 ตัวกำลังดี — มากกว่านั้นโฟกัสกระจัดกระจาย"**

#### 4.3.18 แหล่งที่มาและแหล่งอ้างอิง

1. Peter Drucker — *Management: Tasks, Responsibilities, Practices* (MBO)
2. George T. Doran — *There's a S.M.A.R.T. Way to Write Management's Goals and Objectives* (1981)
3. ITIL 4 — *Service Level Management*
4. Google SRE — *SLO, SLI, Error Budget*: https://sre.google/workbook/implementing-slos/
5. HCLTech — *KPI for Application Support*: https://www.hcltech.com/
6. SysAid — *IT KPI Best Practices*: https://www.sysaid.com/

---

## 5. สรุป

### 5.1 ประโยชน์ที่ได้รับ

คู่มือเล่ม 1 (Foundation & Workflow) เป็น **ฐานราก** ของคู่มือทั้ง 10 เล่ม มอบประโยชน์หลัก:

1. **ภาษากลาง:** นิยามศัพท์ที่ทุกเล่มใช้ร่วมกัน ลดความสับสน
2. **หลักการ Monitoring Framework:** เข้าใจ Pull/Push, Agent/Agentless และเลือกใช้ได้อย่างมีเหตุผล
3. **Workflow มาตรฐาน:** PSR, RCA, KPI SMART ที่วัดผลได้
4. **Template พร้อมใช้:** PSR Report, RCA Worksheet, KPI Scorecard, Dashboard
5. **วัฒนธรรม Blameless:** เรียนรู้จาก Incident ไม่ใช่หาคนผิด

### 5.2 ข้อดี

1. **Holistic:** ครอบคลุมทั้งหลักการ (Monitoring Framework) และกระบวนการ (PSR, RCA, KPI)
2. **Practical:** ทุกหัวข้อมี Template และตัวอย่างที่นำไปใช้ได้ทันที
3. **Measurable:** PSR, RCA, KPI วัดผลได้ด้วย Metrics
4. **Scalable:** ใช้ได้ทั้งทีมเล็กและใหญ่
5. **Foundation for All:** ทุกเล่มถัดไปอ้างอิงกลับมาที่นี่

### 5.3 ข้อเสีย

1. **ความกว้าง vs ความลึก:** แต่ละหัวข้อไม่ลงลึกเท่าเอกสารเฉพาะทาง (ต้องอ่านเล่มถัดไป)
2. **ต้องปรับใช้กับ Context:** Template ต้องปรับให้เข้ากับองค์กร
3. **ต้องมี Facilitator:** PSR และ RCA ต้องมีคนฝึกฝน
4. **Technology เปลี่ยนเร็ว:** Framework และ Best Practice ต้องอัปเดตเป็นระยะ

### 5.4 ข้อห้าม

1. **ห้ามทำ PSR แบบ Blameful** — ต้องมุ่งเน้นระบบและกระบวนการ
2. **ห้ามใช้ KPI เดียวตัดสินผลงาน** — ต้องดูทั้ง Quality, Speed, Satisfaction
3. **ห้ามสรุป RCA จากข้อมูลไม่เพียงพอ** — ต้องมี Evidence
4. **ห้ามหยุด RCA ที่ "Human Error"** — ต้องถามต่อถึง Process Gap
5. **ห้ามใช้ Pull Model กับ Batch Job ที่อายุสั้นกว่า Scrape Interval** — จะพลาด Metrics
6. **ห้ามใช้ Label ที่มี Cardinality สูง** — ทำให้ Prometheus OOM
7. **ห้ามใช้ KPI เป็นเครื่องมือลงโทษ** — ใช้เป็นเครื่องมือปรับปรุง
8. **ห้ามตั้ง Action Item โดยไม่มี Owner + Due Date** — จะค้างตลอดไป

### 5.5 ก้าวต่อไป

หลังจากอ่านเล่ม 1 จบแล้ว ผู้อ่านสามารถเลือกเส้นทางตามสายงาน:

| สายงาน | เล่มถัดไป |
|---|---|
| Monitoring Engineer | เล่ม 2 → 3 → 4 → 5 |
| Business Application Support (CRM) | เล่ม 3 → 7 |
| ERP Developer | เล่ม 3 → 8 → 9 → 10 |
| ERP Support | เล่ม 3 → 4 → 5 → 8 → 9 → 10 |
| AI Engineer | เล่ม 4 → 5 → 6 |

> **"Foundation & Workflow" — เรียนรู้นิสัยก่อนเรียนเครื่องมือ**  
> **"PSR Blameless + RCA ถึง Process + KPI SMART" — หัวใจของทีม Support ที่ยั่งยืน**

---