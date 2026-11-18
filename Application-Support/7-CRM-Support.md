## เล่ม 7: CRM Support — "สาย Business Application"

> **กลุ่มงาน:** Business Application Support, CRM Admin
> **Dependency:** อ่านเล่ม 1 (Foundation & Workflow) และเล่ม 3 (Application Metrics & Metrics Platform) ก่อน
> **เวอร์ชัน:** 1.0
**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับ

---

## บทนำ

### วัตถุประสงค์ของเล่ม

CRM (Customer Relationship Management) เป็นระบบที่ผู้ใช้ธุรกิจ (Sales, Marketing, Support) ใช้งานทุกวัน — เมื่อ CRM ล่มหรือช้า ธุรกิจหยุดชะงักทันที เล่มนี้จึงเน้น **Observability และ Incident Response สำหรับ CRM** โดยเฉพาะ เมื่ออ่านจบ ผู้อ่านจะสามารถ:

1. ระบุ **Critical Path** ของ CRM ที่ต้อง Monitor เป็นลำดับแรก
2. ติดตั้ง **Custom Prometheus Exporter** สำหรับ CRM Org Limits (API, Storage)
3. Monitor **Integration Health** (Billing, ERP, Marketing) ที่เชื่อมกับ CRM
4. วัด **User Experience Metrics** (Page Load, API Latency) ที่ส่งผลต่อ Adoption
5. ใช้ **Incident Playbook** สำหรับ CRM Outage, API Limit Hit, Integration Failure

### เป้าหมายของเล่ม

| เป้าหมาย | ตัวชี้วัดความสำเร็จ |
|---|---|
| เห็น API Limit ก่อนหมด | Alert `CRMApiLimitNearFull` fire ที่ 80% |
| เห็น Integration Failure ก่อน user บ่น | Alert `CRMIntegrationQueueBacklog` fire |
| เห็น UX ตกก่อน Adoption ลด | Page Load P95 < 3s |
| Incident Triage เร็ว | MTTR ลดลงจาก Playbook เฉพาะ CRM |

### สิ่งที่ **ไม่** อยู่ในเล่มนี้

- Prometheus/Grafana/Alertmanager ติดตั้ง → **เล่ม 3**
- Infrastructure Metrics (CPU/RAM) → **เล่ม 2**
- Log Analysis (ELK) → **เล่ม 4**
- Kafka/Redis Observability → **เล่ม 5**
- ERP Integration Patterns (Outbox, Saga) → **เล่ม 10**

---

## บทนิยาม (เฉพาะคำศัพท์ใหม่ในเล่มนี้)

| คำศัพท์ | ความหมาย |
|---|---|
| **Critical Path** | เส้นทางการทำงานหลักของ CRM ที่ถ้าล่มจะกระทบธุรกิจทันที (เช่น Login → ดู Lead → สร้าง Opportunity) |
| **Org Limits** | โควตาของ CRM Platform (Salesforce/HubSpot) — API Calls, Storage, Bulk API |
| **Rolling 24-Hour Window** | ช่วงเวลา 24 ชั่วโมงแบบเลื่อน — API Limit จะคืนก็ต่อเมื่อพ้น 24 ชม.นับจาก call แรก |
| **API Limit Exhaustion** | สถานะที่ API Calls หมดโควตา → Integration ถูกบล็อกทั้งหมด (403 `REQUEST_LIMIT_EXCEEDED`) |
| **Integration Health** | สถานะการเชื่อมต่อระหว่าง CRM กับระบบอื่น (Billing, ERP, Marketing) |
| **Dead Letter Queue (DLQ)** | คิวเก็บ Message ที่ประมวลผลไม่สำเร็จ — ต้อง Monitor อายุ (DLQ Age) |
| **Reconciliation Mismatch** | ข้อมูลระหว่าง CRM กับระบบอื่นไม่ตรงกัน (เช่น จำนวน Order ไม่ตรง) |
| **Experienced Page Time (EPT)** | Metric ของ Salesforce วัดเวลาโหลดหน้า Lightning |
| **TTFB (Time to First Byte)** | เวลาจนได้ byte แรกจาก Server |
| **Adoption Rate** | สัดส่วนผู้ใช้ที่ใช้งานจริง (DAU/MAU) — สัมพันธ์กับ Page Latency |

---

## บทหัวข้อ

---

## 3.1 CRM (Customer Relationship Management) — เต็มรูปแบบ

### เรื่อง
Observability และ Incident Response สำหรับ CRM Platform (Salesforce, HubSpot, Dynamics 365, Zoho)

### วัตถุประสงค์ / เป้าหมาย
- เห็น **Critical Path** ที่กระทบธุรกิจมากที่สุด
- ตรวจ **Org Limits** ก่อนหมดโควตา
- ตรวจ **Integration Health** ก่อน Sync ล้มเหลว
- วัด **UX Metrics** ที่ส่งผลต่อ Adoption
- มี **Incident Playbook** พร้อมใช้

### เนื้อหา / รายละเอียด

#### Critical Path ของ CRM — สิ่งที่ต้อง Monitor ก่อน

CRM มีกระบวนการทำงานหลัก (Critical Path) ที่ถ้าล่มจะกระทบรายได้ทันที:

```
┌──────────┐    ┌──────────┐    ┌──────────────┐    ┌──────────┐
│  Login   │───▶│  Search  │───▶│  View Lead   │───▶│  Create  │
│ (Auth)   │    │ (List)   │    │ / Account    │    │Opportunity│
└──────────┘    └──────────┘    └──────────────┘    └──────────┘
                                                           │
                                                           ▼
┌──────────┐    ┌──────────┐    ┌──────────────┐    ┌──────────┐
│  Report  │◀───│  Sync to │◀───│  Update      │◀───│  Quote   │
│  (BI)    │    │  ERP     │    │  Stage       │    │  (Price) │
└──────────┘    └──────────┘    └──────────────┘    └──────────┘
```

**กฎ:** Monitor **Login → Search → View → Create Opportunity → Sync to ERP** เป็นลำดับแรก — ถ้าขั้นตอนใดช้า/ล่ม ให้ Alert ทันที

#### Metrics ที่ต้อง Monitor (4 หมวด)

| หมวด | Metric | ความหมาย | เป้า |
|---|---|---|---|
| **1. Org Limits** | `crm_api_limit_remaining` | API Calls ที่เหลือ (Rolling 24h) | > 20% |
| | `crm_storage_used_percent` | Storage ที่ใช้ | < 80% |
| | `crm_bulk_api_remaining` | Bulk API ที่เหลือ | > 10% |
| **2. Integration** | `crm_integration_success_rate` | อัตราความสำเร็จ Sync | > 99% |
| | `crm_integration_latency_seconds` | เวลา Sync (P95) | < 5s |
| | `crm_dlq_age_seconds` | อายุ Message ใน DLQ | < 300s |
| | `crm_reconciliation_mismatch_total` | จำนวนข้อมูลไม่ตรง | 0 |
| **3. UX** | `crm_page_load_seconds` (Histogram) | เวลาโหลดหน้า (P95) | < 3s |
| | `crm_api_latency_seconds` (Histogram) | เวลา API ตอบ (P95) | < 1s |
| | `crm_error_rate` | อัตรา Error | < 1% |
| **4. Availability** | `crm_uptime` | สถานะ CRM (UP/DOWN) | 99.9% |
| | `crm_login_success_rate` | อัตรา Login สำเร็จ | > 99% |

#### Org Limits — ทำไมต้อง Monitor ก่อน

API Limits ของ CRM Platform (เช่น Salesforce) ทำงานบน **Rolling 24-Hour Window** — ถ้าใช้หมด จะต้องรอให้ call เก่าๆ หลุดออกจาก window (ไม่ใช่ reset เที่ยงคืน)

**ตัวอย่าง Salesforce Limits:**

| Limit | Developer | Enterprise |
|---|---|---|
| Daily API Requests | 15,000 | 100,000+ (ขึ้นกับ license) |
| Daily Bulk API Batches | จำกัด | จำกัด |
| Data Storage | จำกัด | ตามสัญญา |
| File Storage | จำกัด | ตามสัญญา |

> **กฎ:** ตั้ง Alert ที่ **80%** (Warning) และ **95%** (Critical) — อย่ารอให้หมด

### การติดตั้ง / การตั้งค่า

#### Custom Prometheus Exporter (`crm_limits_exporter.py`)

```python
# crm_limits_exporter.py — Custom Exporter สำหรับ Salesforce Org Limits
# pip install prometheus-client requests simple-salesforce
from prometheus_client import Gauge, start_http_server
from simple_salesforce import Salesforce
import os, time, logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# ── Metrics ──────────────────────────────────────────
api_limit_remaining = Gauge(
    'crm_api_limit_remaining', 'Remaining daily API calls'
)
api_limit_max = Gauge(
    'crm_api_limit_max', 'Maximum daily API calls'
)
api_usage_percent = Gauge(
    'crm_api_usage_percent', 'Percentage of daily API calls used'
)
storage_used_percent = Gauge(
    'crm_storage_used_percent', 'Percentage of data storage used'
)
bulk_api_remaining = Gauge(
    'crm_bulk_api_remaining', 'Remaining Bulk API batches'
)

# ── Salesforce Connection ────────────────────────────
def get_sf():
    return Salesforce(
        username=os.environ['SF_USERNAME'],
        password=os.environ['SF_PASSWORD'],
        security_token=os.environ['SF_TOKEN'],
        domain=os.environ.get('SF_DOMAIN', 'login'),
    )

# ── Poll Limits (ทุก 5 นาที = 1 API call) ────────────
def poll_limits():
    try:
        sf = get_sf()
        limits = sf.limits()
        
        # Daily API
        api = limits['DailyApiRequests']
        remaining = api['Remaining']
        max_calls = api['Max']
        used_pct = ((max_calls - remaining) / max_calls) * 100
        
        api_limit_remaining.set(remaining)
        api_limit_max.set(max_calls)
        api_usage_percent.set(used_pct)
        
        # Storage
        storage = limits['DataStorageMB']
        storage_used = ((storage['Max'] - storage['Remaining']) / storage['Max']) * 100
        storage_used_percent.set(storage_used)
        
        # Bulk API
        bulk = limits.get('DailyBulkApiBatches', {})
        bulk_api_remaining.set(bulk.get('Remaining', 0))
        
        logger.info(f"API: {remaining}/{max_calls} ({used_pct:.1f}%), "
                    f"Storage: {storage_used:.1f}%")
        
    except Exception as e:
        logger.error(f"Failed to poll limits: {e}")

if __name__ == '__main__':
    start_http_server(9187)  # Prometheus scrape port
    while True:
        poll_limits()
        time.sleep(300)       # 5 minutes
```

#### Prometheus Scrape Config

```yaml
# prometheus.yml (ต่อจากเล่ม 3)
scrape_configs:
  - job_name: "crm-limits"
    static_configs:
      - targets: ["crm-limits-exporter:9187"]
        labels:
          crm_platform: salesforce
          org: prod-sales
    scrape_interval: 5m      # polls limits ทุก 5m

  - job_name: "crm-integration"
    metrics_path: /metrics
    static_configs:
      - targets: ["crm-integration-service:8000"]
        labels:
          crm_platform: salesforce
          integration: billing-erp
```

#### Alert Rules — CRM

```yaml
# rules/crm-alerts.yml
groups:
  - name: crm-observability
    interval: 30s
    rules:

      # ═══════════════════════════════════════════
      # 1) API Limit ใกล้หมด (สำคัญสุด)
      # ═══════════════════════════════════════════
      - alert: CRMApiLimitNearFull
        expr: crm_api_usage_percent > 80
        for: 10m
        labels:
          severity: warning
          team: crm-admin
        annotations:
          summary: "CRM API limit {{ $value | humanizePercentage }} used"
          description: "เหลือ {{ $value }}% — ตรวจ integration ที่กิน API ผิดปกติ"
          runbook_url: "https://wiki.example.com/runbook/crm-api-limit"

      - alert: CRMApiLimitCritical
        expr: crm_api_usage_percent > 95
        for: 5m
        labels:
          severity: critical
          team: crm-admin
        annotations:
          summary: "CRM API limit > 95% — ใกล้หมด"
          description: "Integration จะถูกบล็อก — ตรวจสอบทันที"
          runbook_url: "https://wiki.example.com/runbook/crm-api-limit"

      # ═══════════════════════════════════════════
      # 2) Storage ใกล้เต็ม
      # ═══════════════════════════════════════════
      - alert: CRMStorageHigh
        expr: crm_storage_used_percent > 85
        for: 15m
        labels:
          severity: warning
          team: crm-admin
        annotations:
          summary: "CRM storage {{ $value }}% used"
          description: "ตรวจ Data Storage / File Storage — ลบข้อมูลเก่าหรือ archive"

      # ═══════════════════════════════════════════
      # 3) Integration Success Rate ตก
      # ═══════════════════════════════════════════
      - alert: CRMIntegrationFailure
        expr: |
          rate(crm_integration_success_total[10m])
            / rate(crm_integration_total[10m])
            < 0.99
        for: 10m
        labels:
          severity: warning
          team: integration
        annotations:
          summary: "Integration success rate < 99% on {{ $labels.connector }}"
          description: "ตรวจ DLQ, API errors, network"

      # ═══════════════════════════════════════════
      # 4) DLQ Age สูง (Message ค้างนาน)
      # ═══════════════════════════════════════════
      - alert: CRMIntegrationQueueBacklog
        expr: crm_dlq_age_seconds > 300
        for: 5m
        labels:
          severity: warning
          team: integration
        annotations:
          summary: "DLQ age > 5m on {{ $labels.connector }}"
          description: "Message ค้างใน DLQ นาน — ตรวจ consumer / downstream"

      # ═══════════════════════════════════════════
      # 5) Reconciliation Mismatch
      # ═══════════════════════════════════════════
      - alert: CRMReconciliationMismatch
        expr: crm_reconciliation_mismatch_total > 0
        for: 5m
        labels:
          severity: warning
          team: integration
        annotations:
          summary: "{{ $value }} mismatched records between CRM and {{ $labels.target }}"
          description: "ข้อมูลไม่ตรง — ตรวจ sync logic / mapping"

      # ═══════════════════════════════════════════
      # 6) Page Load ช้า (UX)
      # ═══════════════════════════════════════════
      - alert: CRMPageLoadSlow
        expr: |
          histogram_quantile(0.95,
            sum by (le, page) (rate(crm_page_load_seconds_bucket[5m]))
          ) > 3
        for: 15m
        labels:
          severity: warning
          team: crm-admin
        annotations:
          summary: "Page load P95 > 3s on {{ $labels.page }}"
          description: "UX แย่ — Adoption อาจลด — ตรวจ query / index / caching"

      # ═══════════════════════════════════════════
      # 7) API Latency สูง
      # ═══════════════════════════════════════════
      - alert: CRMApiLatencyHigh
        expr: |
          histogram_quantile(0.95,
            sum by (le) (rate(crm_api_latency_seconds_bucket[5m]))
          ) > 1
        for: 10m
        labels:
          severity: warning
          team: crm-admin
        annotations:
          summary: "CRM API P95 > 1s"
          description: "ตรวจ Salesforce status / network / integration load"
```

#### PromQL — CRM ครบชุด

```promql
# ── Org Limits ────────────────────────────────────────
# API usage percent
crm_api_usage_percent

# API remaining
crm_api_limit_remaining

# Storage used percent
crm_storage_used_percent

# Bulk API remaining
crm_bulk_api_remaining

# ── Integration ───────────────────────────────────────
# Success rate (10m)
rate(crm_integration_success_total[10m])
  / rate(crm_integration_total[10m])

# Integration latency P95
histogram_quantile(0.95,
  sum by (le, connector) (rate(crm_integration_latency_seconds_bucket[5m]))
)

# DLQ age
crm_dlq_age_seconds

# ── UX ────────────────────────────────────────────────
# Page load P50/P95/P99
histogram_quantile(0.50,
  sum by (le, page) (rate(crm_page_load_seconds_bucket[5m]))
)
histogram_quantile(0.95,
  sum by (le, page) (rate(crm_page_load_seconds_bucket[5m]))
)
histogram_quantile(0.99,
  sum by (le, page) (rate(crm_page_load_seconds_bucket[5m]))
)

# API latency P95
histogram_quantile(0.95,
  sum by (le, operation) (rate(crm_api_latency_seconds_bucket[5m]))
)

# ── Error Rate ────────────────────────────────────────
rate(crm_api_errors_total[5m])
  / rate(crm_api_requests_total[5m])
```

#### Dashboard JSON — CRM Health Overview

```json
{
  "title": "CRM Health Overview",
  "uid": "crm-health-v1",
  "tags": ["crm", "business-app"],
  "templating": {
    "list": [
      {
        "name": "org",
        "type": "query",
        "datasource": {"type": "prometheus", "uid": "prometheus"},
        "query": "label_values(crm_api_usage_percent, org)",
        "refresh": 1
      }
    ]
  },
  "panels": [
    {
      "id": 1, "type": "stat", "title": "API Limit Used",
      "gridPos": {"h": 5, "w": 6, "x": 0, "y": 0},
      "targets": [{"expr": "crm_api_usage_percent{org=\"$org\"}"}],
      "fieldConfig": {"defaults": {
        "unit": "percent",
        "thresholds": {"steps": [
          {"color": "green", "value": null},
          {"color": "yellow", "value": 80},
          {"color": "red", "value": 95}
        ]}
      }}
    },
    {
      "id": 2, "type": "stat", "title": "Storage Used",
      "gridPos": {"h": 5, "w": 6, "x": 6, "y": 0},
      "targets": [{"expr": "crm_storage_used_percent{org=\"$org\"}"}],
      "fieldConfig": {"defaults": {
        "unit": "percent",
        "thresholds": {"steps": [
          {"color": "green", "value": null},
          {"color": "yellow", "value": 80},
          {"color": "red", "value": 90}
        ]}
      }}
    },
    {
      "id": 3, "type": "stat", "title": "Integration Success",
      "gridPos": {"h": 5, "w": 6, "x": 12, "y": 0},
      "targets": [{
        "expr": "rate(crm_integration_success_total{org=\"$org\"}[10m]) / rate(crm_integration_total{org=\"$org\"}[10m])"
      }],
      "fieldConfig": {"defaults": {
        "unit": "percentunit",
        "thresholds": {"steps": [
          {"color": "red", "value": null},
          {"color": "yellow", "value": 0.99},
          {"color": "green", "value": 0.999}
        ]}
      }}
    },
    {
      "id": 4, "type": "stat", "title": "Page Load P95",
      "gridPos": {"h": 5, "w": 6, "x": 18, "y": 0},
      "targets": [{
        "expr": "histogram_quantile(0.95, sum by (le) (rate(crm_page_load_seconds_bucket{org=\"$org\"}[5m])))"
      }],
      "fieldConfig": {"defaults": {"unit": "s"}}
    },
    {
      "id": 10, "type": "timeseries", "title": "API Usage (24h)",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 5},
      "targets": [
        {"expr": "crm_api_usage_percent{org=\"$org\"}", "legendFormat": "Used %"},
        {"expr": "100", "legendFormat": "Limit"}
      ],
      "fieldConfig": {"defaults": {"unit": "percent", "max": 100}}
    },
    {
      "id": 11, "type": "timeseries", "title": "Integration Latency P95",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 5},
      "targets": [{
        "expr": "histogram_quantile(0.95, sum by (le, connector) (rate(crm_integration_latency_seconds_bucket[5m])))",
        "legendFormat": "{{connector}}"
      }],
      "fieldConfig": {"defaults": {"unit": "s"}}
    },
    {
      "id": 12, "type": "timeseries", "title": "Page Load P50/P95/P99",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 13},
      "targets": [
        {"expr": "histogram_quantile(0.50, sum by (le) (rate(crm_page_load_seconds_bucket[5m])))", "legendFormat": "P50"},
        {"expr": "histogram_quantile(0.95, sum by (le) (rate(crm_page_load_seconds_bucket[5m])))", "legendFormat": "P95"},
        {"expr": "histogram_quantile(0.99, sum by (le) (rate(crm_page_load_seconds_bucket[5m])))", "legendFormat": "P99"}
      ],
      "fieldConfig": {"defaults": {"unit": "s"}}
    },
    {
      "id": 13, "type": "timeseries", "title": "API Error Rate",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 13},
      "targets": [{
        "expr": "rate(crm_api_errors_total[5m]) / rate(crm_api_requests_total[5m])",
        "legendFormat": "Error Rate"
      }],
      "fieldConfig": {"defaults": {"unit": "percent"}}
    }
  ],
  "time": {"from": "now-24h", "to": "now"},
  "refresh": "1m"
}
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุที่เป็นไปได้ | แนวทางแก้ไข |
|---|---|---|
| API Usage > 80% | Integration กิน API ผิดปกติ / poll ถี่เกิน | ตรวจ Top consumers, ลด poll, ใช้ Bulk API |
| Storage > 85% | ข้อมูลโต / ไฟล์แนบเยอะ | Archive ข้อมูลเก่า, ลบไฟล์ที่ไม่ใช้, ซื้อ Storage เพิ่ม |
| Integration Success < 99% | API error, network, auth หมดอายุ | ตรวจ DLQ, ตรวจ token expiry, ตรวจ Salesforce status |
| DLQ Age > 5m | Consumer ตาย / downstream ช้า | ตรวจ Consumer log, restart, scale |
| Page Load P95 > 3s | Query ช้า, ไม่มี index, component เยอะ | ตรวจ SOQL, เพิ่ม index, ลด component |
| API Latency P95 > 1s | Salesforce ช้า / network | ตรวจ Salesforce Status API, ตรวจ network |

### ลำดับการจัดการปัญหา (API Limit ใกล้หมด)

1. **ยืนยัน Usage** — `crm_api_usage_percent` > 80%
2. **ตรวจ Top Consumers** — Salesforce Setup → System Overview → API Usage (หรือ `EventLogFile` สำหรับ Enterprise+)
3. **ตรวจ Integration ที่กิน API** — poll ถี่เกิน? (เช่น ทุก 1 นาที → เปลี่ยนเป็น 5 นาที)
4. **ตรวจ Bulk API** — ใช้ Bulk แทน REST สำหรับ batch?
5. **Pause Non-critical** — ปิด integration ที่ไม่จำเป็นชั่วคราว (`SF_CRITICAL_ONLY=true`)
6. **ขอ Limit Increase** — ติดต่อ Salesforce Support (ถ้าจำเป็น)
7. **ระหว่างแก้** — Monitor `crm_api_limit_remaining` ทุก 5 นาที

### Template Code
→ ดู `crm_limits_exporter.py`, Alert Rules, PromQL ด้านบน

### Template Dashboard
→ ดู CRM Health Overview JSON ด้านบน

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** เห็น API Limit ก่อนหมด, เห็น Integration Failure ก่อน user บ่น, เห็น UX ตกก่อน Adoption ลด
- **ข้อควรระวัง:** **API Limit เป็น Rolling 24h** — ไม่ reset เที่ยงคืน; **Poll Limits ทุก 5m = 1 API call** — อย่าถี่กว่านี้
- **ข้อดี:** Custom Exporter ยืดหยุ่น, Alert ครบทุกหมวด
- **ข้อเสีย:** Salesforce Limits API ต้องใช้ credential; บาง org ไม่มี `EventLogFile` (ต้อง Enterprise+)
- **ข้อห้าม:**
  - ❌ Poll Limits ถี่กว่า 5 นาที (เปลือง API call)
  - ❌ ใช้ REST API สำหรับ batch (>200 records) — ใช้ Bulk API
  - ❌ Ignore `DLQ Age` — Message ค้างจะกลายเป็น data loss
  - ❌ Monitor แค่ Uptime — ต้อง Monitor Limit + Integration + UX ด้วย
  - ❌ ใช้ `Average` สำหรับ Page Load — ใช้ P95/P99

### ตัวอย่าง (Salesforce Limits API Response)

```json
{
  "DailyApiRequests": {
    "Max": 100000,
    "Remaining": 15234
  },
  "DataStorageMB": {
    "Max": 10240,
    "Remaining": 2048
  },
  "DailyBulkApiBatches": {
    "Max": 15000,
    "Remaining": 12000
  }
}
```

### สรุปย่อเพื่อจดจำ
> **CRM Support** — Monitor 4 หมวด: Org Limits (API/Storage), Integration (Success/DLQ), UX (Page Load/API Latency), Availability — API Limit เป็น Rolling 24h — ตั้ง Alert 80%/95% — Custom Exporter polls ทุก 5m — Integration Failure ต้องดู DLQ Age

### แหล่งที่มา
- Salesforce Limits API: https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_limits.htm
- Valo.ai, "When Salesforce Goes Down" (2025)
- Salesforce Incident Runbook (2026)
- OmniCRM Monitoring & Metrics Docs (2026)
- Codecanis, "CRM UX Latency" (2026)

---

## Workflow (อ้างอิงเล่ม 1 + Incident Playbook เฉพาะเล่ม)

### อ้างอิง Workflow หลักจากเล่ม 1

| Workflow | ใช้ในเล่มนี้เมื่อ |
|---|---|
| **PSR** | เขียนรายงานหลัง CRM Incident |
| **RCA 5 Whys** | หา Root Cause ของ API Limit / Integration Failure |
| **KPI SMART** | ตั้ง KPI ของ CRM (เช่น API Usage < 80%, Page Load P95 < 3s) |

→ Template เต็มอยู่ใน **เล่ม 1 หัวข้อ 4**

### Incident Playbook เฉพาะเล่ม 7

#### Playbook A: CRM Outage / Salesforce Down

1. **ตรวจ Salesforce Status** — `curl https://api.status.salesforce.com/v1/incidents/active`
2. **ตรวจ Instance Status** — `curl https://api.status.salesforce.com/v1/instances/<instance>/status`
3. **ถ้า Salesforce Down** — Enable Fallback Mode (ถ้ามี), Monitor Status Page, แจ้งธุรกิจ
4. **ถ้า Salesforce ปกติ** — ตรวจ API Limits, Auth, Network
5. **ระหว่างรอ** — ใช้ Playbook B/C ตามอาการ

#### Playbook B: API Limit Exhausted (403 `REQUEST_LIMIT_EXCEEDED`)

1. **ยืนยัน** — `sf limits api display --target-org my-org --json | jq '.result[] | select(.name == "DailyApiRequests")'`
2. **ตรวจ Top Consumers** — `EventLogFile` (Enterprise+): `SELECT UserId, COUNT(Id) FROM EventLogFile WHERE EventType='API' AND LogDate=TODAY GROUP BY UserId ORDER BY COUNT(Id) DESC`
3. **Pause Non-critical** — `SF_CRITICAL_ONLY=true`
4. **รอ Reset** — Rolling 24h — รอ call เก่าหลุดออกจาก window
5. **ขอ Increase** — ติดต่อ Salesforce Support
6. **ป้องกัน** — ลด poll frequency, ใช้ Bulk API, Cache

#### Playbook C: Integration Failure / Data Sync ค้าง

1. **ตรวจ Integration Success Rate** — `rate(crm_integration_success_total[10m]) / rate(crm_integration_total[10m])`
2. **ตรวจ DLQ Age** — `crm_dlq_age_seconds` — Message ค้างนาน?
3. **ตรวจ Error Code** — `INVALID_SESSION_ID` (401) → re-auth; `UNABLE_TO_LOCK_ROW` (409) → retry with backoff; `MALFORMED_QUERY` → ตรวจ SOQL
4. **ตรวจ Salesforce Status** — ปกติ?
5. **แก้:**
   - Auth → re-authenticate
   - Row lock → retry with backoff
   - SOQL → ตรวจ code
   - Network → ตรวจ firewall/proxy

#### Playbook D: Page Load ช้า (UX ตก)

1. **ยืนยัน** — `histogram_quantile(0.95, ...crm_page_load_seconds...)` > 3s
2. **ตรวจ SOQL** — มี query ที่ไม่ใช้ index?
3. **ตรวจ Component** — Lightning component เยอะเกิน?
4. **ตรวจ Report** — มี report หนักๆ ที่รันพร้อมกัน?
5. **แก้:**
   - เพิ่ม index (Salesforce: Custom Index)
   - ลด component / ใช้ Lightning Web Component
   - เลื่อน Report หนักไป off-peak
   - ใช้ Cache (Platform Cache)

#### Playbook E: Storage ใกล้เต็ม

1. **ยืนยัน** — `crm_storage_used_percent` > 85%
2. **ตรวจ Storage Breakdown** — Setup → Storage Usage
3. **Archive ข้อมูลเก่า** — Opportunity ที่ปิด > 5 ปี, Case ที่ปิด > 3 ปี
4. **ลบไฟล์แนบ** — ไฟล์ที่ไม่ใช้, ไฟล์ใหญ่
5. **ซื้อ Storage เพิ่ม** — ถ้าจำเป็น

---

## สรุป (ประโยชน์, ข้อดี, ข้อเสีย, ข้อห้าม)

### ประโยชน์ของเล่ม 7

- **Critical Path Monitoring:** เห็นปัญหาที่กระทบธุรกิจก่อน
- **Org Limits Alert:** ไม่ถูกบล็อกเพราะ API หมด
- **Integration Health:** เห็น Sync Failure ก่อน Data Mismatch
- **UX Metrics:** เห็น Adoption ตกก่อนสาย
- **Runbook พร้อม:** 5 Playbook สำหรับ Incident ที่พบบ่อย

### ข้อดี

| ด้าน | ผลลัพธ์ |
|---|---|
| **MTTD** | เห็น API Limit / Integration Failure ทันที |
| **MTTR** | Playbook เฉพาะ → แก้เร็ว |
| **Cost Control** | ไม่ต้องซื้อ API เพิ่มเพราะใช้เกิน |
| **Adoption** | Page Load เร็ว → User ใช้จริง |
| **Compliance** | Storage ไม่เต็ม → ไม่ต้อง Emergency Archive |

### ข้อเสีย / ข้อจำกัด

- **Salesforce Limits API** ต้องใช้ credential และ poll ทุก 5m (เปลือง 1 API call)
- **`EventLogFile`** ต้อง Enterprise+ (ไม่ใช่ทุก org)
- **UX Metrics** ต้อง instrument เอง (Salesforce ไม่มี built-in Prometheus)
- **Integration Health** ต้องสร้าง custom metrics (ไม่มีมาตรฐาน)

### ข้อห้าม (สรุป)

1. ❌ **Poll Limits ถี่กว่า 5 นาที** — เปลือง API call
2. ❌ **ใช้ REST API สำหรับ batch** (>200 records) — ใช้ Bulk API
3. ❌ **Ignore DLQ Age** — Message ค้างจะกลายเป็น data loss
4. ❌ **Monitor แค่ Uptime** — ต้อง Monitor Limit + Integration + UX
5. ❌ **ใช้ Average สำหรับ Page Load** — ใช้ P95/P99
6. ❌ **รอ API หมดแล้วค่อยแก้** — ตั้ง Alert ที่ 80%
7. ❌ **ใช้ Default credentials** — ใช้ OAuth / Connected App
8. ❌ **ลืม Monitor Storage** — Storage เต็มทำให้สร้าง Record ไม่ได้

---

## เส้นทางอ่านต่อ

| ถ้าคุณเป็น | อ่านต่อ |
|---|---|
| Business App Support | → อ่านจบเส้นทาง B (เล่ม 1→3→7) แล้ว |
| CRM Admin | → ฝึก Salesforce Limits API + EventLogFile เพิ่ม |
| Integration Engineer | → **เล่ม 10** (ERP Integration Layer) |
| ERP Developer | → **เล่ม 8** (DDD) → **เล่ม 9** (DB) → **เล่ม 10** |

---

> **เวอร์ชันเอกสาร:** 1.0
> **ผู้รับผิดชอบ:** CRM Admin Team + SRE Team
> **ปรับปรุงล่าสุด:** ตามรอบ Quarter
> **สถานะ:** ✅ Ready for Review

--- 