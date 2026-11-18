## คู่มือการทำงาน Application Support — เล่ม 2: Infrastructure & Network Monitoring
**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับ

**เวอร์ชัน:** 1.0 | **สถานะ:** เอกสารบังคับสำหรับสาย Monitoring | **กลุ่มเป้าหมาย:** Monitoring Engineer, Infrastructure Support, Network Support

> ** Dependency:** ผู้อ่านต้องผ่านเล่ม 1 (Foundation & Workflow) มาแล้ว โดยเฉพาะหัวข้อ 3.5 Monitoring Frameworks (Pull/Push, Agent/Agentless) และ Workflow 4.1–4.3


## 1. บทนำ

### 1.1 วัตถุประสงค์

คู่มือเล่มนี้จัดทำขึ้นเพื่อให้ทีม Application Support ที่รับผิดชอบด้าน Infrastructure และ Network สามารถ:

1. **ติดตั้งและตั้งค่า** เครื่องมือ Monitoring พื้นฐาน ได้แก่ Node Exporter, iperf3_exporter, SNMP Exporter และ Blackbox Exporter
2. **อ่านและตีความ Metrics** ระดับ Host และ Network ได้อย่างถูกต้อง โดยแยกแยะระหว่าง CPU Bottleneck, Memory Pressure, Disk Saturation, Network Latency, Packet Loss และ Jitter
3. **วิเคราะห์และแก้ไขปัญหา** Infrastructure และ Network ด้วย Runbook ที่เป็นขั้นตอน
4. **สร้าง Dashboard และ Alert** ที่พร้อมใช้งานจริงจาก Template ที่ให้ไว้

### 1.2 เป้าหมาย

| เป้าหมาย | ตัวชี้วัดความสำเร็จ |
|---|---|
| ทีมสามารถติดตั้ง Node Exporter บน Linux Host ได้ด้วยตนเอง | ติดตั้งสำเร็จ 100% ภายใน 15 นาที/Host |
| MTTD ของ Host Resource Incident ลดลง | Detect ภายใน 5 นาที (จาก Alert) |
| แยกแยะปัญหา Host vs Network ได้ถูกต้อง | Diagnostic Accuracy ≥ 90% |
| Dashboard ครอบคลุม CPU, Memory, Disk, Network | Dashboard Coverage 100% |
| Alert ที่ Actionable ไม่เกิด Alert Fatigue | False Positive Rate ≤ 10% |


## 2. บทนิยาม (เฉพาะคำศัพท์ใหม่ในเล่มนี้)

| คำศัพท์ | ความหมาย |
|---|---|
| **Node Exporter** | Prometheus Exporter สำหรับ Linux Host เปิด Metrics ที่ Port 9100 |
| **iperf3_exporter** | Exporter ที่รัน iperf3 เพื่อวัด Bandwidth, Jitter และ Packet Loss |
| **SNMP Exporter** | Exporter ที่แปลง SNMP OID จาก Network Device เป็น Prometheus Metrics |
| **Blackbox Exporter** | Exporter ที่ Probe Endpoint (ICMP, HTTP, TCP, DNS) จากภายนอก |
| **Textfile Collector** | กลไกของ Node Exporter ในการอ่าน Custom Metrics จากไฟล์ `.prom` |
| **iowait** | % เวลาที่ CPU รอ Disk I/O — สูงบ่งชี้ Disk Bottleneck |
| **Load Average** | ค่าเฉลี่ย Process ที่รอ CPU ใน 1/5/15 นาที — ไม่เท่ากับ CPU Utilization |
| **MemAvailable** | Memory ที่ Application ใช้ได้จริง (รวม Reclaimable Cache) |
| **Predict Linear** | ฟังก์ชัน PromQL สำหรับพยากรณ์ค่าในอนาคต (ใช้กับ Disk เต็ม) |
| **Jitter** | ความแปรปรวนของ Packet Delay (Inter-packet Delay Variation) |
| **RTT** | Round-Trip Time — เวลาไปกลับของ Packet |
| **Packet Loss** | % Packet ที่หายไประหว่างทาง |
| **P95 / P99** | Percentile ที่ 95 และ 99 — ใช้ดู Tail Latency |
| **SNMP OID** | Object Identifier ของ Network Device ที่ใช้ Query ค่า |
| **if_mib** | MIB มาตรฐานสำหรับ Interface Metrics (Bandwidth, Errors, Drops) |
| **RED Method** | Rate, Errors, Duration (อ้างอิงเล่ม 1) |
| **USE Method** | Utilization, Saturation, Errors (อ้างอิงเล่ม 1) |


## 3. บทหัวข้อ

---

### 3.2 Host / Infrastructure Metrics

#### 3.2.1 เรื่อง

**Host / Infrastructure Metrics: การติดตั้ง Node Exporter การอ่าน Metrics พื้นฐานของ Linux Host และการวินิจฉัยปัญหา Resource Exhaustion**

#### 3.2.2 วัตถุประสงค์ของหัวข้อนี้

เพื่อให้ทีม Support สามารถติดตั้ง Node Exporter ตั้งค่า Prometheus Scrape อ่าน Metrics CPU, Memory, Disk, Filesystem, Network และ Kernel ได้อย่างถูกต้อง และวินิจฉัยปัญหา Resource Exhaustion เบื้องต้นได้โดยไม่ต้องพึ่ง Developer

#### 3.2.3 เป้าหมายของหัวข้อนี้

1. ติดตั้ง Node Exporter เป็น Systemd Service บน Linux Host ได้
2. เข้าใจ Metrics สำคัญ 5 กลุ่ม (CPU, Memory, Disk, Filesystem, Network)
3. เขียน PromQL สำหรับ Dashboard และ Alert ได้
4. ใช้ Textfile Collector สำหรับ Custom Metrics (Cron Job, Certificate Expiry)
5. วินิจฉัยปัญหา CPU, Memory, Disk ได้จาก Metrics

#### 3.2.4 เนื้อหา / รายละเอียด

**Node Exporter คืออะไร?**

Node Exporter เป็น Single Static Binary ที่อ่านข้อมูลจาก `/proc` และ `/sys` แล้วเปิดเผยเป็น Prometheus Metrics ผ่าน HTTP ที่ Port 9100 (ค่าเริ่มต้น) Metrics ที่ให้มีมากกว่า 1,000 Series แต่มีเพียงไม่กี่ตัวที่สำคัญต่อการ Alert

**Metrics หลัก 5 กลุ่ม:**

| กลุ่ม | Metrics สำคัญ | ใช้ตอบคำถาม |
|---|---|---|
| **CPU** | `node_cpu_seconds_total` (แยก Mode), `node_load1/5/15` | CPU ทำงานหนักจริงหรือรอ I/O? |
| **Memory** | `node_memory_MemAvailable_bytes`, `node_memory_MemTotal_bytes`, `node_memory_SwapFree_bytes` | Memory เหลือพอไหม? เริ่ม Swap หรือยัง? |
| **Disk** | `node_disk_io_time_seconds_total`, `node_disk_read/write_time_seconds_total` | Disk ทำงานเต็ม Capacity ไหม? |
| **Filesystem** | `node_filesystem_avail_bytes`, `node_filesystem_size_bytes`, `node_filesystem_files_free` | Disk จะเต็มเมื่อไหร่? Inode หมดหรือยัง? |
| **Network** | `node_network_receive/transmit_bytes_total`, `node_network_receive/transmit_drop_total` | Network มี Error หรือ Drop ไหม? |

**ข้อแตกต่างสำคัญที่ต้องเข้าใจ:**

- **Load Average ≠ CPU Utilization:** Load Average นับ Process ที่รอ CPU **และ** รอ Disk I/O (Uninterruptible Sleep) — ถ้า Load สูงแต่ CPU Idle สูง แสดงว่า Disk Bottleneck
- **MemFree ≠ MemAvailable:** `MemFree` คือ Memory ที่ว่างเปล่า ส่วน `MemAvailable` รวม Reclaimable Cache ที่ Application ใช้ได้ — ต้องใช้ `MemAvailable` ในการประเมิน Memory Pressure
- **Disk Utilization 100% ≠ Disk เต็ม:** Utilization คือ % เวลาที่ Disk ทำงาน (Busy) — ไม่เกี่ยวกับพื้นที่ว่าง

#### 3.2.5 การติดตั้ง / การตั้งค่า

**A. ติดตั้ง Node Exporter (Systemd — Production Way)**

```bash
# 1) ดาวน์โหลด Binary (ตรวจสอบ Version ล่าสุดจาก GitHub Releases)
cd /tmp
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.12.1/node_exporter-1.12.1.linux-amd64.tar.gz
tar xvf node_exporter-1.12.1.linux-amd64.tar.gz
sudo cp node_exporter-1.12.1.linux-amd64/node_exporter /usr/local/bin/

# 2) สร้าง System User (ไม่มี Home, ไม่มี Shell)
sudo useradd --system --no-create-home --shell /usr/sbin/nologin node_exporter

# 3) ตรวจสอบว่า Binary ทำงาน
/usr/local/bin/node_exporter --version
```

> **หมายเหตุ:** โปรเจกต์ Node Exporter แนะนำ **ไม่ให้ Containerize** เพราะหน้าที่หลักคืออ่าน `/proc` และ `/sys` ของ Host — Container จะเห็นข้อมูลไม่ตรงกับ Host จริง

**B. สร้าง Systemd Unit**

```ini
# /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter \
  --collector.systemd \
  --collector.textfile.directory=/var/lib/node_exporter/textfile \
  --web.listen-address=:9100

[Install]
WantedBy=multi-user.target
```

`--collector.systemd` เปิด Metrics ของ Systemd Unit States ทำให้ Alert เมื่อ Service ใด ๆ เข้า Failed State ได้โดยไม่ต้องเขียน Check แยกทุก Service

`--collector.textfile.directory` เปิด Textfile Collector สำหรับ Custom Metrics (ดูหัวข้อ 3.2.5 D)

**C. เปิดใช้งาน Firewall (จำเป็น — ห้ามข้าม)**

`/metrics` ไม่มี Authentication และเปิดเผยข้อมูลมากกว่าที่คาด (Kernel Version, Filesystem, Network Interface) ต้องจำกัดให้เฉพาะ Prometheus Server เข้าถึงได้

```bash
# อนุญาตเฉพาะ Prometheus Server (ปรับ IP ตามจริง)
sudo ufw allow from 10.0.1.5 to any port 9100 proto tcp
# บล็อก Port 9100 จากที่อื่นทั้งหมด
sudo ufw deny 9100/tcp
```

หาก Exporter Traffic ต้องผ่าน Untrusted Network ให้ใช้ TLS และ Basic Auth ผ่าน `--web.config.file`

**D. ตั้งค่า Textfile Collector สำหรับ Custom Metrics**

Textfile Collector อนุญาตให้เขียน Metrics ใด ๆ ลงไฟล์ `.prom` แล้ว Node Exporter จะอ่านและ Expose ให้อัตโนมัติ เหมาะกับ Cron Job, Certificate Expiry, RAID Status

```python
# /usr/local/bin/custom_metrics.py — สร้าง Custom Metrics สำหรับ Textfile Collector
from prometheus_client import CollectorRegistry, Gauge, write_to_textfile
import os

registry = CollectorRegistry()

# ตัวอย่าง: Backup Success Timestamp
backup_last_success = Gauge(
    'backup_last_success_timestamp_seconds',
    'Unix timestamp of last successful backup',
    registry=registry
)

# ตัวอย่าง: Certificate Days Remaining
cert_days = Gauge(
    'ssl_certificate_days_remaining',
    'Days until SSL certificate expires',
    ['domain'],
    registry=registry
)

# เขียนค่าจริง (ในที่นี้เป็นตัวอย่าง)
backup_last_success.set(1735689600)  # 2025-01-01
cert_days.labels(domain='api.example.com').set(45)

# เขียนไฟล์ .prom (ต้องลงท้ายด้วย .prom)
os.makedirs('/var/lib/node_exporter/textfile', exist_ok=True)
write_to_textfile(
    '/var/lib/node_exporter/textfile/custom_metrics.prom',
    registry
)
```

ตั้ง Cron Job ให้รันทุก 5 นาที:

```bash
# /etc/cron.d/custom-metrics
*/5 * * * * root /usr/bin/python3 /usr/local/bin/custom_metrics.py
```

**E. ตั้งค่า Prometheus Scrape**

```yaml
# prometheus.yml — เพิ่มใน scrape_configs
scrape_configs:
  - job_name: 'node'
    scrape_interval: 15s
    static_configs:
      - targets:
          - '10.0.1.10:9100'
          - '10.0.1.11:9100'
        labels:
          env: 'production'
          tier: 'app'
```

หลัง Reload Prometheus ให้ตรวจสอบที่หน้า Targets และ Query `up{job="node"}` — ค่า `1` หมายถึง Scrape ล่าสุดสำเร็จ

#### 3.2.6 การวิเคราะห์และแนวทางแก้ไข

**ตารางวินิจฉัย Host Metrics:**

| อาการ | Metrics ที่ต้องดู | สาเหตุที่เป็นไปได้ | แนวทางแก้ไข |
|---|---|---|---|
| ระบบช้า | `node_cpu_seconds_total{mode="iowait"}` สูง | Disk Bottleneck | ตรวจ Disk Utilization, ย้าย Workload, เพิ่ม IOPS |
| ระบบช้า | `node_load1` สูง แต่ `idle` สูง | Process รอ Disk I/O (Uninterruptible) | ตรวจ `node_disk_io_time_seconds_total` |
| Application OOM | `node_memory_MemAvailable_bytes` < 10% | Memory ไม่พอ หรือ Leak | เพิ่ม Memory, ตรวจ Leak, ปรับ Heap Size |
| เริ่ม Swap | `node_memory_SwapFree_bytes` ลดลง | Memory Pressure | เพิ่ม Memory, ลด Cache, ตรวจ Process ที่ใช้ Memory สูง |
| Disk เต็ม | `node_filesystem_avail_bytes` < 15% | Log Growth, Temp Files, Archive | Rotate Log, ลบ Temp, ขยาย Disk, ตั้ง Retention |
| Inode หมด | `node_filesystem_files_free` < 5% | ไฟล์เล็กจำนวนมาก | ลบไฟล์ขยะ, ตรวจ Application ที่สร้างไฟล์ถี่ |
| Disk Busy 100% | `rate(node_disk_io_time_seconds_total[5m])` ≈ 1 | Disk Saturation | ตรวจ Slow Query, ย้าย Log ไป Disk แยก |
| Network Drop | `rate(node_network_receive_drop_total[5m])` > 0 | Buffer Overflow, Network Congestion | ตรวจ Switch, เพิ่ม Buffer, ตรวจ Duplex |
| Service Failed | `node_systemd_unit_state{state="failed"} == 1` | Service Crash | ตรวจ `journalctl -u <service>`, Restart, ตรวจ Config |

**Runbook: "Host CPU สูง — เริ่มจากไหน?"**

1. **แยกแยะ Mode ของ CPU**
   ```promql
   # ดู % เวลาแยกตาม Mode
   sum by (mode) (rate(node_cpu_seconds_total{instance="host:9100"}[5m])) * 100
   ```
   - `user` สูง → Application ใช้ CPU หนัก → ตรวจ Process, Profile
   - `system` สูง → Kernel ทำงานหนัก → ตรวจ Syscall, Network Stack
   - `iowait` สูง → Disk Bottleneck → ไปข้อ 2
   - `idle` สูง แต่ Load สูง → Process รอ I/O → ไปข้อ 2

2. **ตรวจ Disk I/O**
   ```promql
   rate(node_disk_io_time_seconds_total{instance="host:9100"}[5m]) * 100
   ```
   ถ้า > 80% → Disk Saturation → ตรวจ Slow Query, ย้าย Workload

3. **ตรวจ Process ที่ใช้ CPU สูง** (บน Host)
   ```bash
   top -b -n 1 | head -20
   pidstat -u 1 5
   ```

4. **ตรวจ Load Average vs CPU**
   ```bash
   uptime
   # Load > CPU Core Count และ idle สูง → I/O Wait
   ```

**Runbook: "Disk จะเต็ม — จะรู้ล่วงหน้าได้อย่างไร?"**

ใช้ `predict_linear` ใน Alert Rule:

```promql
# แจ้งเตือนถ้า Disk จะเต็มภายใน 4 ชั่วโมง
predict_linear(node_filesystem_avail_bytes{fstype!~"tmpfs|overlay"}[1h], 4*3600) < 0
```

#### 3.2.7 ลำดับการจัดการปัญหา (Host Incident)

| ลำดับ | ขั้นตอน | ผู้รับผิดชอบ | เวลาที่คาดหวัง |
|:---:|---|---|---|
| 1 | **Detect** — Alert `HostHighCpuLoad`, `HostMemoryPressure`, `HostDiskWillFillIn4Hours` | Alertmanager | ทันที |
| 2 | **Triage** — แยกแยะ CPU / Memory / Disk / Network | On-call Support | ≤ 5 นาที |
| 3 | **Isolate** — ระบุว่าเป็น Host เดียว หรือทั้ง Cluster | On-call Support | ≤ 10 นาที |
| 4 | **Mitigate** — Restart Service, เพิ่ม Memory/Disk, ย้าย Workload | Support + Infra | ≤ 30 นาที |
| 5 | **Verify** — Metrics กลับสู่ปกติ | Support | ≤ 5 นาที |
| 6 | **RCA** — วิเคราะห์ Root Cause (อ้างอิงเล่ม 1 ข้อ 4.2) | Support + Owner | ≤ 48 ชั่วโมง |

#### 3.2.8 Template Code

**A. Alert Rules — Host (พร้อมใช้)**

```yaml
# rules/host-alerts.yml
groups:
  - name: host-alerts
    rules:
      # CPU สูง (ไม่รวม iowait)
      - alert: HostHighCpuLoad
        expr: |
          100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 85
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "High CPU on {{ $labels.instance }}"
          description: "CPU usage is {{ $value | printf \"%.1f\" }}% for 10 minutes"

      # CPU iowait สูง (Disk Bottleneck)
      - alert: HostHighIowait
        expr: |
          avg by(instance) (rate(node_cpu_seconds_total{mode="iowait"}[5m])) * 100 > 20
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "High iowait on {{ $labels.instance }}"
          description: "iowait is {{ $value | printf \"%.1f\" }}% — check disk"

      # Memory Available ต่ำ
      - alert: HostMemoryPressure
        expr: |
          node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100 < 10
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Memory pressure on {{ $labels.instance }}"
          description: "Available memory below 10%"

      # Disk จะเต็มภายใน 4 ชั่วโมง
      - alert: HostDiskWillFillIn4Hours
        expr: |
          predict_linear(
            node_filesystem_avail_bytes{fstype!~"tmpfs|overlay"}[1h], 4*3600
          ) < 0
        for: 30m
        labels:
          severity: critical
        annotations:
          summary: "Disk will fill in 4h on {{ $labels.instance }}"
          description: "Filesystem {{ $labels.mountpoint }} is filling fast"

      # Inode ใกล้หมด
      - alert: HostFilesystemAlmostOutOfFiles
        expr: |
          node_filesystem_files_free{fstype!~"tmpfs|overlay"}
          / node_filesystem_files{fstype!~"tmpfs|overlay"} * 100 < 5
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Inode almost full on {{ $labels.instance }}:{{ $labels.mountpoint }}"

      # Disk I/O Saturation
      - alert: HostDiskIoSaturation
        expr: |
          rate(node_disk_io_time_seconds_total[5m]) * 100 > 90
        for: 15m
        labels:
          severity: warning
        annotations:
          summary: "Disk I/O saturation on {{ $labels.instance }}:{{ $labels.device }}"

      # Service Failed
      - alert: HostSystemdServiceFailed
        expr: node_systemd_unit_state{state="failed"} == 1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Systemd unit {{ $labels.name }} failed on {{ $labels.instance }}"
```

**B. PromQL สำหรับ Dashboard (Host)**

```promql
# CPU Utilization (%)
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# CPU iowait (%)
avg by(instance) (rate(node_cpu_seconds_total{mode="iowait"}[5m])) * 100

# Memory Available (%)
node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100

# Filesystem Usage (%)
(1 - node_filesystem_avail_bytes{fstype!~"tmpfs|overlay"}
     / node_filesystem_size_bytes{fstype!~"tmpfs|overlay"}) * 100

# Disk I/O Utilization (%)
rate(node_disk_io_time_seconds_total[5m]) * 100

# Network Receive Bandwidth (Mbps)
rate(node_network_receive_bytes_total{device!~"lo|docker.*"}[5m]) * 8 / 1000000

# Load Average vs CPU Cores
node_load1 / count by(instance) (node_cpu_seconds_total{mode="idle"}) 
```

**C. Custom Metrics — Certificate Expiry**

```python
# cert_expiry_checker.py — ตรวจสอบอายุ Certificate
import ssl, socket, time, os
from prometheus_client import CollectorRegistry, Gauge, write_to_textfile

DOMAINS = ['api.example.com', 'app.example.com', 'admin.example.com']
registry = CollectorRegistry()
cert_days = Gauge('ssl_certificate_days_remaining',
                  'Days until SSL certificate expires',
                  ['domain'], registry=registry)

for domain in DOMAINS:
    try:
        ctx = ssl.create_default_context()
        with socket.create_connection((domain, 443), timeout=5) as sock:
            with ctx.wrap_socket(sock, server_hostname=domain) as ssock:
                cert = ssock.getpeercert()
                expiry = ssl.cert_time_to_seconds(cert['notAfter'])
                days = (expiry - time.time()) / 86400
                cert_days.labels(domain=domain).set(days)
    except Exception:
        cert_days.labels(domain=domain).set(-1)  # -1 = Error

write_to_textfile('/var/lib/node_exporter/textfile/cert_expiry.prom', registry)
```

#### 3.2.9 Template Dashboard

**A. Dashboard ID 1860 — Node Exporter Full (แนะนำ)**

Dashboard **1860** คือ Dashboard มาตรฐานจาก Grafana Labs ที่ครอบคลุม Metrics เกือบทั้งหมดของ Node Exporter — CPU, Memory, Disk, Network, Load, Processes

**วิธี Import:**
1. Grafana → Dashboards → New → Import
2. ใส่ ID `1860`
3. เลือก Data Source: Prometheus
4. กด Import

**B. Dashboard JSON — Host Critical Overview (Custom)**

```json
{
  "title": "Host Critical Overview",
  "uid": "host-critical-v1",
  "refresh": "30s",
  "time": {"from": "now-6h", "to": "now"},
  "panels": [
    {
      "id": 1,
      "title": "CPU Utilization (%)",
      "type": "gauge",
      "gridPos": {"h": 6, "w": 6, "x": 0, "y": 0},
      "targets": [{
        "expr": "100 - (avg by(instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)"
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "thresholds": {
            "steps": [
              {"color": "green", "value": null},
              {"color": "yellow", "value": 70},
              {"color": "red", "value": 85}
            ]
          }
        }
      }
    },
    {
      "id": 2,
      "title": "Memory Available (%)",
      "type": "gauge",
      "gridPos": {"h": 6, "w": 6, "x": 6, "y": 0},
      "targets": [{
        "expr": "node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100"
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "thresholds": {
            "steps": [
              {"color": "red", "value": null},
              {"color": "yellow", "value": 10},
              {"color": "green", "value": 25}
            ]
          }
        }
      }
    },
    {
      "id": 3,
      "title": "Disk Usage (%) — /",
      "type": "gauge",
      "gridPos": {"h": 6, "w": 6, "x": 12, "y": 0},
      "targets": [{
        "expr": "(1 - node_filesystem_avail_bytes{mountpoint=\"/\"} / node_filesystem_size_bytes{mountpoint=\"/\"}) * 100"
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "thresholds": {
            "steps": [
              {"color": "green", "value": null},
              {"color": "yellow", "value": 80},
              {"color": "red", "value": 90}
            ]
          }
        }
      }
    },
    {
      "id": 4,
      "title": "Disk I/O Utilization (%)",
      "type": "gauge",
      "gridPos": {"h": 6, "w": 6, "x": 18, "y": 0},
      "targets": [{
        "expr": "rate(node_disk_io_time_seconds_total[5m]) * 100"
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "thresholds": {
            "steps": [
              {"color": "green", "value": null},
              {"color": "yellow", "value": 70},
              {"color": "red", "value": 90}
            ]
          }
        }
      }
    },
    {
      "id": 5,
      "title": "CPU Mode Breakdown (stacked %)",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 6},
      "targets": [{
        "expr": "sum by(mode) (rate(node_cpu_seconds_total[5m])) * 100",
        "legendFormat": "{{mode}}"
      }],
      "fieldConfig": {
        "defaults": {"unit": "percent", "custom": {"stacking": {"mode": "normal"}}}
      }
    },
    {
      "id": 6,
      "title": "Filesystem Usage — All Mounts",
      "type": "bargauge",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 6},
      "targets": [{
        "expr": "(1 - node_filesystem_avail_bytes{fstype!~\"tmpfs|overlay\"} / node_filesystem_size_bytes{fstype!~\"tmpfs|overlay\"}) * 100",
        "legendFormat": "{{instance}} {{mountpoint}}"
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "max": 100,
          "thresholds": {
            "steps": [
              {"color": "green", "value": null},
              {"color": "yellow", "value": 80},
              {"color": "red", "value": 90}
            ]
          }
        }
      }
    }
  ]
}
```

#### 3.2.10 สรุปย่อ

Node Exporter คือเครื่องมือมาตรฐานสำหรับเก็บ Metrics ของ Linux Host ผ่าน Port 9100 ต้องติดตั้งเป็น Systemd Service (ไม่ Containerize) เปิด Firewall ให้เฉพาะ Prometheus เข้าถึง Metrics สำคัญ 5 กลุ่มคือ CPU (ดู iowait), Memory (ดู MemAvailable), Disk (ดู io_time), Filesystem (ดู avail + inode) และ Network (ดู drops) ใช้ Textfile Collector สำหรับ Custom Metrics และ `predict_linear` สำหรับพยากรณ์ Disk เต็ม

#### 3.2.11 ประโยชน์ที่ได้รับ

1. **Visibility ลึก:** เห็น Metrics ระดับ Kernel/Process ที่ Cloud Provider ไม่ให้
2. **Capacity Planning:** พยากรณ์ Disk เต็มล่วงหน้าด้วย `predict_linear`
3. **Custom Metrics:** ใช้ Textfile Collector เก็บ Metrics ที่ไม่มีใน Default
4. **มาตรฐาน:** Dashboard 1860 พร้อมใช้ ครอบคลุมเกือบทุก Metric
5. **ต้นทุนต่ำ:** Open Source ไม่มีค่าใช้จ่าย

#### 3.2.12 ข้อควรระวัง

1. **MemAvailable ไม่เท่ากับ MemFree:** ใช้ `MemAvailable` ในการประเมิน Memory Pressure
2. **Load Average สูง ≠ CPU 100%:** ต้องดู `iowait` และ Run Queue
3. **Disk Utilization ≠ Disk เต็ม:** Utilization คือ Busy %, เต็ม คือ Avail Bytes
4. **Textfile Collector ต้อง Atomic Write:** ใช้ `write_to_textfile()` เพื่อป้องกัน Partial Read
5. **Firewall ต้องเปิดเฉพาะ Prometheus:** `/metrics` ไม่มี Authentication

#### 3.2.13 ข้อดี

1. **Metrics ครบ:** CPU, Memory, Disk, Network, Kernel, Systemd
2. **Single Binary:** ติดตั้งง่าย ไม่มี Dependency
3. **Community ใหญ่:** Dashboard 1860 พร้อมใช้
4. **Textfile Collector:** ยืดหยุ่นสำหรับ Custom Metrics

#### 3.2.14 ข้อเสีย

1. **ต้องติดตั้ง Agent ทุก Host:** จัดการ Version ให้สอดคล้อง
2. **ไม่เหมาะกับ Container:** Container เห็น `/proc` ไม่ตรงกับ Host
3. **Cardinality สูง:** Metrics มากกว่า 1,000 Series ต้องบริหาร

#### 3.2.15 ข้อห้าม

1. **ห้าม Containerize Node Exporter** — ให้ใช้ Static Binary ใต้ Systemd
2. **ห้ามเปิด Port 9100 สู่ Public** — ต้องจำกัดเฉพาะ Prometheus
3. **ห้ามใช้ `MemFree` ประเมิน Memory Pressure** — ใช้ `MemAvailable`
4. **ห้าม Ignore Alert Disk จะเต็มภายใน 4 ชั่วโมง**
5. **ห้ามใช้ `Average` สำหรับ CPU Utilization** — ใช้ `rate()` บน Counter

#### 3.2.16 ตัวอย่าง

**สถานการณ์:** Host `app-01` มี Alert `HostHighIowait` (iowait 25%)

**การวิเคราะห์:**
1. ตรวจ `node_disk_io_time_seconds_total` → Utilization 95% → Disk Saturation
2. ตรวจ Slow Query → พบ Query ไม่มี Index ทำงานทุกนาที
3. ตรวจ Process → พบ `postgres` เขียน Temp File จำนวนมาก
4. **Root Cause:** Query ไม่มี Index ทำให้ Sort บน Disk
5. **แก้ไข:** เพิ่ม Index, เพิ่ม `work_mem` ชั่วคราว → iowait ลดลงเหลือ 5%

#### 3.2.17 สรุปย่อเพื่อจดจำ

> **“CPU ดู iowait, Memory ดู Available, Disk ดู io_time, FS ดู avail + inode, Network ดู drops”**
>
> **“Node Exporter = Static Binary + Systemd + Firewall + Textfile Collector”**
>
> **“predict_linear คือเพื่อนรักสำหรับ Disk เต็ม”**

#### 3.2.18 แหล่งที่มาและแหล่งอ้างอิง

1. AlertKick — *Node exporter setup: Linux server metrics in Prometheus (2026 guide)*: https://alertkick.com/blog/prometheus-node-exporter-setup/ 
2. Guance — *Monitor Linux hosts with Prometheus and Node Exporter*: https://www.guance.com/learn/articles/monitor-linux-prometheus-node-exporter 
3. Prometheus — *Node exporter textfile collector*: https://prometheus.github.io/client_python/exporting/textfile/ 
4. Grafana Labs — *Node Exporter Full (ID 1860)*: https://grafana.com/grafana/dashboards/1860-node-exporter-full/ 
5. Platform9 — *Node OS Monitoring Alert Rules*: https://docs.platform9.com/managed-kubernetes/5.13/bareos-what-is-bareos/catapult-rules-alarms/node-os-monitoring 

---

### 3.4 Network Metrics

#### 3.4.1 เรื่อง

**Network Metrics: การวัด Latency, Packet Loss, Jitter และ Bandwidth ด้วย iperf3_exporter, Blackbox Exporter และ SNMP Exporter**

#### 3.4.2 วัตถุประสงค์ของหัวข้อนี้

เพื่อให้ทีม Support สามารถวัดและตีความ Network Metrics (Latency, Loss, Jitter, Bandwidth) และแยกแยะปัญหา Network ออกจาก Application ได้อย่างมีหลักฐาน

#### 3.4.3 เป้าหมายของหัวข้อนี้

1. ติดตั้ง iperf3_exporter และตั้งค่า Probe UDP สำหรับ Jitter/Loss
2. ใช้ Blackbox Exporter วัด ICMP RTT และ HTTP Latency
3. ใช้ SNMP Exporter เก็บ Interface Metrics จาก Network Device
4. เขียน PromQL และ Alert สำหรับ Network Metrics
5. วินิจฉัยปัญหา Network vs Application ด้วย Metrics

#### 3.4.4 เนื้อหา / รายละเอียด

**Network Metrics หลัก 4 ตัว:**

| Metric | ความหมาย | หน่วย | ผลกระทบ |
|---|---|---|---|
| **Latency (RTT)** | เวลาไปกลับของ Packet | ms | ทุก Application รู้สึกได้หากสูง |
| **Packet Loss** | % Packet ที่หายไป | % | TCP Retransmission, Throughput ตก |
| **Jitter** | ความแปรปรวนของ Latency | ms | VoIP/Video กระตุก, เสียงขาดหาย |
| **Bandwidth** | ปริมาณข้อมูลต่อหน่วยเวลา | Mbps | Throughput ของ Application |

**เครื่องมือที่ใช้:**

| เครื่องมือ | วัดอะไร | วิธีทำงาน |
|---|---|---|
| **iperf3_exporter** | Bandwidth, Jitter, Loss (UDP) | รัน iperf3 ไปยัง Target ตาม Interval แล้ว Export ผลเป็น Metrics |
| **Blackbox Exporter** | ICMP RTT, HTTP Latency, TCP Connect | Probe จากภายนอก (Agentless) แล้ว Export `probe_*` Metrics |
| **SNMP Exporter** | Interface Bandwidth, Errors, Drops | Query SNMP OID จาก Network Device แล้วแปลงเป็น Metrics |

#### 3.4.5 การติดตั้ง / การตั้งค่า

**A. iperf3_exporter — ติดตั้งและตั้งค่า**

iperf3_exporter ต้องมี **iperf3 Binary** ติดตั้งอยู่บนเครื่องเดียวกับ Exporter และ Target ต้องรัน `iperf3 -s` ไว้

```bash
# 1) ติดตั้ง iperf3 บน Exporter Host และ Target
sudo apt install iperf3 -y

# 2) ดาวน์โหลด iperf3_exporter
curl -L -o iperf3_exporter \
  https://github.com/yuvaldekel/iperf3_exporter/releases/download/v0.0.0/iperf3_exporter-v0.0.0.linux-amd64
chmod +x iperf3_exporter

# 3) สร้าง Config File
cat > /etc/iperf3_exporter/config.yaml <<'EOF'
metricsPath: /metrics
probePath: /probe
timeout: 30s
logging:
  level: info
  format: logfmt
targets:
  - target: target-server-1.internal
    port: 5201
    interval: 1h
    protocol: udp
    period: 10s
  - target: target-server-2.internal
    port: 5201
    interval: 1h
    protocol: udp
    period: 10s
EOF

# 4) รัน Exporter
./iperf3_exporter --config.file=/etc/iperf3_exporter/config.yaml
```

**B. Prometheus Scrape สำหรับ iperf3_exporter**

iperf3_exporter ใช้ `/probe` Endpoint และรับ Target ผ่าน `__param_target` พร้อม Relabel Configuration

```yaml
scrape_configs:
  - job_name: 'iperf3'
    metrics_path: /probe
    scrape_interval: 5m
    scrape_timeout: 60s
    static_configs:
      - targets:
          - target-server-1.internal
          - target-server-2.internal
    params:
      port: ['5201']
      protocol: ['udp']
      period: ['10s']
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: iperf3-exporter.internal:9579
```

**C. Metrics ที่ iperf3_exporter ให้ (UDP Mode)**

| Metric | ความหมาย | หน่วย |
|---|---|---|
| `iperf3_up` | Probe สำเร็จหรือไม่ (1/0) | — |
| `iperf3_sent_jitter_ms` | Jitter ของ Packet ที่ส่ง (UDP เท่านั้น) | ms |
| `iperf3_lost_percent` | % Packet ที่หายไป (UDP เท่านั้น) | % |
| `iperf3_lost_packets` | จำนวน Packet ที่หายไป | packets |
| `iperf3_sent_bytes` | Bytes ที่ส่ง | bytes |
| `iperf3_received_bytes` | Bytes ที่รับ | bytes |

**D. Blackbox Exporter — ICMP Probe**

Blackbox Exporter ใช้สำหรับ Probe จากภายนอก (Agentless) วัด RTT โดยไม่ต้องติดตั้ง Agent บน Target

```yaml
# blackbox.yml
modules:
  icmp_ipv4:
    prober: icmp
    timeout: 5s
    icmp:
      preferred_ip_protocol: "ip4"
  http_2xx:
    prober: http
    timeout: 5s
    http:
      preferred_ip_protocol: "ip4"
```

```yaml
# prometheus.yml — Blackbox Scrape
scrape_configs:
  - job_name: 'blackbox-icmp'
    metrics_path: /probe
    params:
      module: [icmp_ipv4]
    static_configs:
      - targets:
          - target-server-1.internal
          - target-server-2.internal
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackbox-exporter.internal:9115
```

Blackbox Exporter ให้ Metrics `probe_icmp_duration_seconds{phase="rtt"}` สำหรับ RTT โดยตรง และ `probe_success` สำหรับ Reachability

**E. SNMP Exporter — Network Device**

SNMP Exporter ใช้ `if_mib` Module สำหรับ Switch, Router, Access Point โดย Query OID มาตรฐานของ Interface

```yaml
# prometheus.yml — SNMP Scrape
scrape_configs:
  - job_name: 'snmp-network'
    scrape_interval: 60s
    metrics_path: /snmp
    params:
      module: [if_mib]
    static_configs:
      - targets:
          - switch-core-01.internal
          - router-edge-01.internal
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: snmp-exporter.internal:9116
```

#### 3.4.6 การวิเคราะห์และแนวทางแก้ไข

**ตารางวินิจฉัย Network Metrics:**

| อาการ | Metrics ที่ต้องดู | สาเหตุที่เป็นไปได้ | แนวทางแก้ไข |
|---|---|---|---|
| Application ช้า | `probe_icmp_duration_seconds{phase="rtt"}` ปกติ แต่ App Response ช้า | ปัญหา Application ไม่ใช่ Network | ตรวจ App Metrics (เล่ม 3), Database, Thread Pool |
| Latency สูง | `probe_icmp_duration_seconds{phase="rtt"}` สูง | Distance, Congestion, Route | ตรวจเส้นทาง, เพิ่ม Bandwidth, ใช้ CDN |
| Packet Loss | `iperf3_lost_percent` > 1% | Congestion, Duplex Mismatch, Cable | ตรวจ Interface Errors, Duplex, QoS |
| Jitter สูง | `iperf3_sent_jitter_ms` > 30ms | Congestion, Buffer Bloat, Route Change | ตั้ง QoS, เพิ่ม Buffer, ตรวจเส้นทางสำรอง |
| Bandwidth ตก | `rate(node_network_receive_bytes_total[5m])` ลดลง | Link Down, Congestion | ตรวจ `node_network_up`, ตรวจ Switch |
| Network Drop | `rate(node_network_receive_drop_total[5m])` > 0 | Buffer Overflow | ตรวจ Ring Buffer, เพิ่ม Buffer, ตรวจ Duplex |

**Jitter Threshold สำหรับ Real-time Application:**

| บริการ | Jitter ที่ยอมรับได้ | แหล่งอ้างอิง |
|---|---|---|
| **Voice (VoIP)** | ≤ 20–30 ms (ยอดเยี่ยม), ≤ 60 ms (พอใช้) | ITU-T G.114, Huawei Grading |
| **Video Conference** | ≤ 30 ms (Good), ≤ 50 ms (Poor) | Huawei Video Grading |
| **HD Video** | ≤ 50 ms | ITU-T G.114 |

> **หมายเหตุ:** Jitter ที่ > 50 ms ทำให้การสนทนาแทบเป็นไปไม่ได้ — ต้อง Alert ที่ 30 ms สำหรับ Voice/Video

**Runbook: "ผู้ใช้แจ้งช้า — เป็น Network หรือ Application?"**

1. **วัด ICMP RTT** (Blackbox Exporter)
   ```promql
   probe_icmp_duration_seconds{phase="rtt", instance="target:80"}
   ```
   - ถ้า RTT > 100 ms → Network Latency → ไปข้อ 2
   - ถ้า RTT < 10 ms แต่ App ช้า → Application → ไปเล่ม 3

2. **วัด Packet Loss** (iperf3 หรือ Blackbox)
   ```promql
   iperf3_lost_percent{instance="target:5201"} > 1
   ```
   - ถ้า Loss > 1% → Network Congestion → ตรวจ Switch/Router

3. **วัด Jitter** (iperf3 UDP)
   ```promql
   iperf3_sent_jitter_ms{instance="target:5201"} > 30
   ```
   - ถ้า Jitter > 30 ms → Congestion/Buffer Bloat → ตั้ง QoS

4. **ตรวจ Interface Errors** (SNMP)
   ```promql
   rate(ifInErrors{instance="switch:161"}[5m]) > 0
   ```
   - ถ้ามี Errors → Cable/Duplex → ตรวจ Physical Layer

#### 3.4.7 ลำดับการจัดการปัญหา (Network Incident)

| ลำดับ | ขั้นตอน | ผู้รับผิดชอบ | เวลาที่คาดหวัง |
|:---:|---|---|---|
| 1 | **Detect** — Alert `HighNetworkJitter`, `HighPacketLoss`, `NetworkInterfaceDown` | Alertmanager | ทันที |
| 2 | **Triage** — แยก Network vs Application ด้วย ICMP RTT | On-call Support | ≤ 5 นาที |
| 3 | **Isolate** — ระบุว่าเป็น Link, Device หรือ Path | Support + Network | ≤ 15 นาที |
| 4 | **Escalate** — ส่งต่อทีม Network พร้อมหลักฐาน (Metrics, Traceroute) | Support | ≤ 15 นาที |
| 5 | **Mitigate** — เปลี่ยนเส้นทาง, ตั้ง QoS, เพิ่ม Bandwidth | Network Team | ≤ 30 นาที |
| 6 | **Verify** — Jitter/Loss กลับสู่ปกติ | Support | ≤ 5 นาที |
| 7 | **RCA** — วิเคราะห์ Root Cause | Support + Network | ≤ 48 ชั่วโมง |

#### 3.4.8 Template Code

**A. Alert Rules — Network**

```yaml
# rules/network-alerts.yml
groups:
  - name: network-alerts
    rules:
      # Jitter สูง (UDP)
      - alert: HighNetworkJitter
        expr: iperf3_sent_jitter_ms > 30
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Jitter > 30ms on {{ $labels.instance }}"
          description: "Real-time voice/video may be affected"

      # Packet Loss สูง (UDP)
      - alert: HighPacketLoss
        expr: iperf3_lost_percent > 1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Packet loss > 1% on {{ $labels.instance }}"

      # ICMP RTT สูง
      - alert: HighIcmpRtt
        expr: probe_icmp_duration_seconds{phase="rtt"} > 0.1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "ICMP RTT > 100ms to {{ $labels.instance }}"

      # Target ไม่ตอบ ICMP
      - alert: IcmpProbeFailed
        expr: probe_success{job="blackbox-icmp"} == 0
        for: 3m
        labels:
          severity: critical
        annotations:
          summary: "ICMP probe failed to {{ $labels.instance }}"

      # Interface Down
      - alert: NetworkInterfaceDown
        expr: node_network_up{device!~"lo|docker.*"} == 0
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Interface {{ $labels.device }} down on {{ $labels.instance }}"

      # Interface Errors (SNMP)
      - alert: SnmpInterfaceErrors
        expr: rate(ifInErrors{job="snmp-network"}[5m]) > 0
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Interface errors on {{ $labels.instance }}:{{ $labels.ifName }}"
```

**B. PromQL สำหรับ Network Dashboard**

```promql
# ICMP RTT (ms)
probe_icmp_duration_seconds{phase="rtt"} * 1000

# Jitter (ms) — iperf3 UDP
iperf3_sent_jitter_ms

# Packet Loss (%) — iperf3 UDP
iperf3_lost_percent

# Network Receive Bandwidth (Mbps) — per interface
rate(node_network_receive_bytes_total{device!~"lo|docker.*"}[5m]) * 8 / 1000000

# Network Transmit Bandwidth (Mbps)
rate(node_network_transmit_bytes_total{device!~"lo|docker.*"}[5m]) * 8 / 1000000

# Interface Receive Errors per Second
rate(node_network_receive_errs_total[5m])

# Interface Receive Drops per Second
rate(node_network_receive_drop_total[5m])

# SNMP Interface In/Out (bps)
rate(ifHCInOctets{job="snmp-network"}[5m]) * 8
rate(ifHCOutOctets{job="snmp-network"}[5m]) * 8
```

**C. Blackbox Exporter Configuration (Full)**

```yaml
# blackbox.yml
modules:
  icmp_ipv4:
    prober: icmp
    timeout: 5s
    icmp:
      preferred_ip_protocol: "ip4"
  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
      valid_status_codes: [200, 201, 204]
      method: GET
      preferred_ip_protocol: "ip4"
  tcp_connect:
    prober: tcp
    timeout: 5s
    tcp:
      preferred_ip_protocol: "ip4"
```

#### 3.4.9 Template Dashboard

**A. Dashboard — Network Quality Overview (Custom JSON)**

```json
{
  "title": "Network Quality Overview",
  "uid": "network-quality-v1",
  "refresh": "1m",
  "time": {"from": "now-6h", "to": "now"},
  "panels": [
    {
      "id": 1,
      "title": "ICMP RTT p95 (ms)",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 0},
      "targets": [{
        "expr": "probe_icmp_duration_seconds{phase=\"rtt\"} * 1000",
        "legendFormat": "{{instance}}"
      }],
      "fieldConfig": {"defaults": {"unit": "ms"}}
    },
    {
      "id": 2,
      "title": "Jitter (ms) — iperf3 UDP",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 0},
      "targets": [{
        "expr": "iperf3_sent_jitter_ms",
        "legendFormat": "{{instance}}"
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "ms",
          "thresholds": {
            "steps": [
              {"color": "green", "value": null},
              {"color": "yellow", "value": 30},
              {"color": "red", "value": 50}
            ]
          }
        }
      }
    },
    {
      "id": 3,
      "title": "Packet Loss (%)",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 8},
      "targets": [{
        "expr": "iperf3_lost_percent",
        "legendFormat": "{{instance}}"
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "thresholds": {
            "steps": [
              {"color": "green", "value": null},
              {"color": "yellow", "value": 1},
              {"color": "red", "value": 5}
            ]
          }
        }
      }
    },
    {
      "id": 4,
      "title": "Network Bandwidth (Mbps)",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 8},
      "targets": [
        {
          "expr": "rate(node_network_receive_bytes_total{device!~\"lo|docker.*\"}[5m]) * 8 / 1000000",
          "legendFormat": "RX {{instance}} {{device}}"
        },
        {
          "expr": "rate(node_network_transmit_bytes_total{device!~\"lo|docker.*\"}[5m]) * 8 / 1000000",
          "legendFormat": "TX {{instance}} {{device}}"
        }
      ],
      "fieldConfig": {"defaults": {"unit": "Mbps"}}
    },
    {
      "id": 5,
      "title": "Interface Drops (per second)",
      "type": "table",
      "gridPos": {"h": 8, "w": 24, "x": 0, "y": 16},
      "targets": [{
        "expr": "rate(node_network_receive_drop_total[5m]) > 0",
        "format": "table",
        "instant": true
      }],
      "transformations": [
        {
          "id": "organize",
          "options": {
            "renameByName": {
              "instance": "Host",
              "device": "Interface",
              "Value": "Drops/s"
            }
          }
        }
      ]
    }
  ]
}
```

**B. Dashboard แนะนำจาก Grafana Labs**

| Dashboard | ID | 用途 |
|---|---|---|
| **Ping — All Hosts** | 26070 | ICMP Ping ทุก Host ใน Honeycomb View |
| **Node Exporter Full** | 1860 | Network Metrics จาก Node Exporter (RX/TX/Drops) |
| **SNMP Interface Detail** | — | Interface Metrics จาก SNMP (ต้องสร้างเอง หรือใช้ Community) |

#### 3.4.10 สรุปย่อ

Network Metrics มี 4 ตัวหลัก: Latency (RTT), Packet Loss, Jitter, Bandwidth ใช้ iperf3_exporter สำหรับ UDP Jitter/Loss, Blackbox Exporter สำหรับ ICMP RTT (Agentless), SNMP Exporter สำหรับ Network Device และ Node Exporter สำหรับ Host-level Network Metrics การวินิจฉัยต้องแยก Network vs Application ด้วย ICMP RTT ก่อนเสมอ Jitter ที่ > 30 ms มีผลต่อ Voice/Video

#### 3.4.11 ประโยชน์ที่ได้รับ

1. **แยกแยะ Network vs Application:** ลดเวลา Escalate ผิดทีม
2. **หลักฐานชัดเจน:** Metrics เป็นกลาง ไม่ขึ้นกับ Application
3. **Capacity Planning:** เห็น Bandwidth Trend และ Interface Errors
4. **SLA Monitoring:** วัด Jitter/Loss สำหรับ Voice/Video SLA

#### 3.4.12 ข้อควรระวัง

1. **iperf3 ใช้ Bandwidth จริง:** ต้อง Schedule นอกเวลา Peak หรือใช้ Bitrate ต่ำ
2. **Blackbox ICMP ต้องมี NET_RAW:** Container ต้องให้ Capability `NET_RAW`
3. **SNMP ต้องเปิด Service บน Device:** ตรวจ Community String / SNMPv3 Credential
4. **Jitter วัดได้เฉพาะ UDP:** TCP ไม่มี Jitter (มี Retransmission แทน)

#### 3.4.13 ข้อดี

1. **Agentless สำหรับ Network Device:** SNMP ไม่ต้องติดตั้ง Agent
2. **Blackbox Probe จากภายนอก:** วัดประสบการณ์ผู้ใช้จริง
3. **iperf3 วัด Bandwidth/Jitter/Loss ครบ:** ในเครื่องมือเดียว

#### 3.4.14 ข้อเสีย

1. **iperf3 ใช้ Resource:** รัน Test ทุก 5 นาทีอาจกระทบ Production
2. **SNMP เป็น Polling:** ไม่ Real-time เท่า Streaming Telemetry
3. **Blackbox ต้องมี Target ที่ Probe ได้:** ไม่เหมาะกับ Internal Service ที่ไม่มี Endpoint

#### 3.4.15 ข้อห้าม

1. **ห้ามรัน iperf3 Test ที่ Bandwidth สูงในเวลา Peak** — กระทบ Production
2. **ห้ามใช้ TCP สำหรับ Jitter Measurement** — ใช้ UDP เท่านั้น
3. **ห้าม Ignore Jitter Alert ในระบบ Voice/Video** — แม้ Latency/Loss จะปกติ
4. **ห้ามใช้ SNMPv1/v2c ใน Untrusted Network** — ใช้ SNMPv3
5. **ห้ามสรุป Network จาก Latency เพียงอย่างเดียว** — ต้องดู Loss และ Jitter ร่วม

#### 3.4.16 ตัวอย่าง

**สถานการณ์:** ผู้ใช้ Teams แจ้งเสียงกระตุกช่วงบ่าย

**การวิเคราะห์:**
1. Blackbox ICMP RTT → 25 ms (ปกติ) → ไม่ใช่ Latency
2. iperf3 Jitter → 80 ms (สูงมาก) → Jitter คือปัญหา
3. iperf3 Loss → 2% → มี Loss ร่วม
4. SNMP Interface Errors → ไม่มี → ไม่ใช่ Physical Layer
5. **Root Cause:** Uplink Congestion ช่วงบ่าย (Backup Job รันพร้อมกัน)
6. **แก้ไข:** ตั้ง QoS สำหรับ Voice Traffic, ย้าย Backup Job ไปกลางคืน
7. **ผลลัพธ์:** Jitter ลดลงเหลือ 15 ms, Loss เหลือ 0%

#### 3.4.17 สรุปย่อเพื่อจดจำ

> **“RTT ปกติ แต่ App ช้า = Application ไม่ใช่ Network”**
>
> **“Jitter > 30ms = Voice/Video มีปัญหา — Alert ทันที”**
>
> **“iperf3 UDP = Jitter + Loss, Blackbox ICMP = RTT, SNMP = Interface”**

#### 3.4.18 แหล่งที่มาและแหล่งอ้างอิง

1. iperf3_exporter — *Prometheus Exporter for iPerf3*: https://pkg.go.dev/github.com/yuvaldekel/iperf3_exporter 
2. Blackbox Exporter — *ICMP Probe*: https://github.com/prometheus/blackbox_exporter 
3. SNMP Exporter — *if_mib Module*: https://github.com/prometheus/snmp_exporter 
4. Huawei — *5G B2B Service Experience Standard White Paper* (Jitter Grading): https://carrier.huawei.com/ 
5. ITU-T G.114 — *One-way Transmission Time*: https://www.itu.int/rec/T-REC-G.114 
6. Grafana Labs — *Ping — All Hosts (ID 26070)*: https://grafana.com/grafana/dashboards/26070-ping-all-hosts/ 

---

### 3.12 Jitter

#### 3.12.1 เรื่อง

**Jitter: ความแปรปรวนของ Packet Delay ที่ส่งผลต่อ Real-time Application (VoIP, Video Conference) — การวัด การตีความ และการแก้ไข**

#### 3.12.2 วัตถุประสงค์ของหัวข้อนี้

เพื่อให้ทีม Support เข้าใจ Jitter ในเชิงลึก สามารถวัดและตีความ Jitter แยกแยะจาก Latency/Packet Loss และวินิจฉัยปัญหาคุณภาพเสียง/วิดีโอได้

#### 3.12.3 เป้าหมายของหัวข้อนี้

1. อธิบายความแตกต่างระหว่าง Latency, Jitter, Packet Loss ได้
2. วัด Jitter ด้วย iperf3_exporter และ Tools อื่น
3. เข้าใจ Threshold Jitter สำหรับ VoIP และ Video ตามมาตรฐาน ITU-T
4. วินิจฉัยสาเหตุ Jitter (Congestion, Buffer Bloat, Route Change)
5. แก้ไข Jitter ด้วย QoS และ Network Tuning

#### 3.12.4 เนื้อหา / รายละเอียด

**Jitter คืออะไร?**

Jitter คือ **ความแปรปรวนของเวลาที่ Packet มาถึง** (Inter-packet Delay Variation) เครือข่ายที่มี Latency คงที่ 100 ms ไม่มี Jitter แต่หาก Latency เปลี่ยนจาก 100 ms เป็น 150 ms เป็น 80 ms สลับกัน → เกิด Jitter

**Latency vs Jitter vs Packet Loss:**

| มิติ | Latency | Jitter | Packet Loss |
|---|---|---|---|
| **นิยาม** | เวลาไปกลับ | ความแปรปรวนของเวลา | % Packet หาย |
| **ผลต่อ VoIP** | เสียงล่าช้า | เสียงกระตุก/ขาดหาย | เสียงหายเป็นช่วง |
| **หน่วย** | ms | ms | % |
| **วัดด้วย** | ICMP RTT | iperf3 UDP, RTP RTCP | iperf3 UDP, SNMP |
| **แก้ไข** | เพิ่ม Bandwidth, CDN | QoS, Buffer, Jitter Buffer | เพิ่ม Bandwidth, แก้ Cable |

**สาเหตุหลักของ Jitter:**

1. **Network Congestion:** Queue ที่ Router มี Packet รอมาก ทำให้ Delay ไม่คงที่
2. **Buffer Bloat:** Buffer ขนาดใหญ่ที่ Router ทำให้ Packet ถูก Queue นานเกินไป
3. **Route Change:** เส้นทางเปลี่ยนกลางทาง (BGP Flap, Failover)
4. **Serialization Delay:** Packet ขนาดต่างกันทำให้เวลา Send ต่างกัน
5. **Application Processing:** Jitter ที่เกิดจาก Application (ไม่ใช่ Network) — ต้องวัดแยก Layer

**Jitter Threshold ตามมาตรฐาน:**

| บริการ | Good | Fair | Poor | แหล่งอ้างอิง |
|---|---|---|---|---|
| **Voice (VoIP)** | ≤ 10 ms | ≤ 20 ms | ≤ 60 ms | Huawei / YD/T1071-2000 |
| **Voice (ITU-T G.114)** | — | ≤ 20 ms (ยอดเยี่ยม) | ≤ 60 ms (พอใช้) | ITU-T G.114 |
| **Video Conference** | ≤ 30 ms | ≤ 30 ms | ≤ 50 ms | Huawei Video Grading |
| **HD Video** | — | ≤ 50 ms | > 50 ms (กระตุก) | ITU-T G.114 |

> **กฎง่าย ๆ:** Jitter > 30 ms → Alert Warning; Jitter > 50 ms → Alert Critical (สำหรับ Voice/Video)

#### 3.12.5 การติดตั้ง / การตั้งค่า (การวัด Jitter)

**A. วัด Jitter ด้วย iperf3_exporter (UDP Mode)**

iperf3_exporter วัด Jitter ได้เฉพาะ **UDP Mode** ผ่าน Metric `iperf3_sent_jitter_ms`

```yaml
# prometheus.yml — iperf3 UDP สำหรับ Jitter
scrape_configs:
  - job_name: 'iperf3-jitter'
    metrics_path: /probe
    scrape_interval: 5m
    scrape_timeout: 60s
    static_configs:
      - targets:
          - voice-gateway.internal
          - video-bridge.internal
    params:
      port: ['5201']
      protocol: ['udp']
      period: ['10s']
      bitrate: ['1M']    # จำกัด Bitrate เพื่อไม่กระทบ Production
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: iperf3-exporter.internal:9579
```

**B. วัด Jitter ด้วย RTP (สำหรับ VoIP โดยเฉพาะ)**

หากมี VoIP Gateway ที่รองรับ RTCP ให้ใช้ `heplify` หรือ Homer เพื่อวัด Jitter จาก RTP โดยตรง — Metric `heplify_rtcp_jitter` มี Threshold > 10 ms

**C. ตั้งค่า Prometheus Scrape สำหรับ Jitter**

```yaml
scrape_configs:
  - job_name: 'jitter-monitoring'
    metrics_path: /probe
    scrape_interval: 5m
    static_configs:
      - targets: ['voice-gateway.internal']
    params:
      protocol: ['udp']
      period: ['10s']
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: iperf3-exporter.internal:9579
```

#### 3.12.6 การวิเคราะห์และแนวทางแก้ไข

**ตารางวินิจฉัย Jitter:**

| อาการ | Metrics ที่ต้องดู | สาเหตุที่เป็นไปได้ | แนวทางแก้ไข |
|---|---|---|---|
| เสียงกระตุก | `iperf3_sent_jitter_ms` > 30 | Congestion | ตั้ง QoS, เพิ่ม Bandwidth |
| เสียงขาดหายเป็นช่วง | Jitter > 50 + Loss > 1% | Congestion + Buffer Overflow | เพิ่ม Buffer, ตั้ง QoS |
| Jitter สูงเฉพาะช่วงบ่าย | Jitter > 30 เฉพาะ 13:00–17:00 | Backup Job รันพร้อมกัน | ย้าย Backup ไปกลางคืน, ตั้ง QoS |
| Jitter สูงทั้งวัน | Jitter > 50 ตลอด | Buffer Bloat ที่ Router | ตั้ง Buffer Size, ใช้ AQM (fq_codel) |
| Jitter สูงหลัง Failover | Jitter > 30 หลัง Route Change | เส้นทางใหม่มี Congestion | ตรวจเส้นทางสำรอง, เพิ่ม Bandwidth |
| Jitter สูงแต่ RTT ปกติ | `probe_icmp_duration_seconds{phase="rtt"}` ปกติ | Application Processing (ไม่ใช่ Network) | ตรวจ App Metrics, Jitter Buffer |

**Runbook: "เสียงกระตุก — จะแก้ Jitter อย่างไร?"**

1. **วัด Jitter ด้วย iperf3 UDP**
   ```promql
   iperf3_sent_jitter_ms{instance="voice-gateway:5201"}
   ```
   - ถ้า > 30 ms → ไปข้อ 2
   - ถ้า < 30 ms → ตรวจ Application/Jitter Buffer

2. **ตรวจ Packet Loss ร่วม**
   ```promql
   iperf3_lost_percent{instance="voice-gateway:5201"}
   ```
   - ถ้า Loss > 1% → Congestion + Buffer Overflow → เพิ่ม Buffer, ตั้ง QoS

3. **ตรวจ Interface Utilization**
   ```promql
   rate(node_network_receive_bytes_total{device="eth0"}[5m]) * 8 / 1000000
   ```
   - ถ้า > 80% ของ Link Capacity → Congestion → เพิ่ม Bandwidth หรือจัดลำดับความสำคัญ

4. **ตรวจ QoS Configuration** (บน Router/Switch)
   ```bash
   # ตัวอย่าง Cisco
   show policy-map interface
   # ต้องเห็น Voice Traffic อยู่ใน Priority Queue
   ```

5. **ตรวจ Buffer Bloat**
   ```bash
   # ใช้ flent หรือ tcptrace วัด Buffer Bloat
   flent rrul -H target-host
   ```
   - ถ้า Buffer Bloat สูง → ใช้ AQM (fq_codel, CAKE)

6. **แก้ไขและยืนยัน**
   ```promql
   iperf3_sent_jitter_ms{instance="voice-gateway:5201"} < 30
   ```

#### 3.12.7 ลำดับการจัดการปัญหา (Jitter Incident)

| ลำดับ | ขั้นตอน | ผู้รับผิดชอบ | เวลาที่คาดหวัง |
|:---:|---|---|---|
| 1 | **Detect** — Alert `HighNetworkJitter` (> 30 ms) | Alertmanager | ทันที |
| 2 | **Triage** — แยก Network Jitter vs Application Jitter | Support | ≤ 5 นาที |
| 3 | **Measure** — วัด Jitter + Loss + RTT พร้อมกัน | Support | ≤ 10 นาที |
| 4 | **Isolate** — ระบุว่าเป็น Link, Router, หรือ Path | Support + Network | ≤ 15 นาที |
| 5 | **Mitigate** — ตั้ง QoS, เพิ่ม Buffer, เปลี่ยนเส้นทาง | Network Team | ≤ 30 นาที |
| 6 | **Verify** — Jitter < 30 ms | Support | ≤ 5 นาที |
| 7 | **RCA** — วิเคราะห์สาเหตุราก | Support + Network | ≤ 48 ชั่วโมง |

#### 3.12.8 Template Code

**A. Alert Rules — Jitter (Voice/Video)**

```yaml
# rules/jitter-alerts.yml
groups:
  - name: jitter-alerts
    rules:
      # Jitter Warning (Voice/Video)
      - alert: VoiceVideoJitterWarning
        expr: iperf3_sent_jitter_ms{job="iperf3-jitter"} > 30
        for: 5m
        labels:
          severity: warning
          service: voice-video
        annotations:
          summary: "Jitter > 30ms on {{ $labels.instance }}"
          description: "Voice/Video quality degraded. Jitter: {{ $value | printf \"%.1f\" }}ms"

      # Jitter Critical
      - alert: VoiceVideoJitterCritical
        expr: iperf3_sent_jitter_ms{job="iperf3-jitter"} > 50
        for: 3m
        labels:
          severity: critical
          service: voice-video
        annotations:
          summary: "Jitter > 50ms on {{ $labels.instance }}"
          description: "Voice/Video unusable. Jitter: {{ $value | printf \"%.1f\" }}ms"

      # Jitter + Packet Loss (Compound)
      - alert: VoiceVideoJitterWithLoss
        expr: |
          iperf3_sent_jitter_ms > 30
          and
          iperf3_lost_percent > 1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Jitter + Loss on {{ $labels.instance }}"
          description: "Jitter {{ $value }}ms with packet loss — check congestion"
```

**B. PromQL สำหรับ Jitter Dashboard**

```promql
# Jitter (ms) — iperf3 UDP
iperf3_sent_jitter_ms

# Jitter p95 (ถ้ามี Histogram)
histogram_quantile(0.95, sum(rate(iperf3_jitter_seconds_bucket[5m])) by (le, instance))

# Jitter + Loss (Compound View)
iperf3_sent_jitter_ms > 30 and iperf3_lost_percent > 1

# RTP Jitter (heplify — สำหรับ VoIP)
heplify_rtcp_jitter
```

**C. Script วัด Jitter ด้วย iperf3 (Manual Verification)**

```bash
#!/bin/bash
# jitter_test.sh — วัด Jitter ด้วย iperf3 UDP
TARGET=${1:-voice-gateway.internal}
DURATION=${2:-10}
BITRATE=${3:-1M}

echo "Testing Jitter to ${TARGET} (UDP, ${DURATION}s, ${BITRATE})..."

iperf3 -c "${TARGET}" -u -b "${BITRATE}" -t "${DURATION}" -J | \
  jq '.end.sum.jitter_ms, .end.sum.lost_percent'

# Output:
# 12.345  (jitter ms)
# 0.5     (loss %)
```

#### 3.12.9 Template Dashboard

**A. Dashboard — Jitter & Voice Quality (Custom JSON)**

```json
{
  "title": "Jitter & Voice Quality",
  "uid": "jitter-quality-v1",
  "refresh": "1m",
  "time": {"from": "now-6h", "to": "now"},
  "panels": [
    {
      "id": 1,
      "title": "Jitter (ms) — Current vs Threshold",
      "type": "gauge",
      "gridPos": {"h": 8, "w": 8, "x": 0, "y": 0},
      "targets": [{
        "expr": "iperf3_sent_jitter_ms",
        "legendFormat": "{{instance}}"
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "ms",
          "max": 100,
          "thresholds": {
            "steps": [
              {"color": "green", "value": null},
              {"color": "yellow", "value": 30},
              {"color": "red", "value": 50}
            ]
          }
        }
      }
    },
    {
      "id": 2,
      "title": "Jitter Trend (6h)",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 16, "x": 8, "y": 0},
      "targets": [{
        "expr": "iperf3_sent_jitter_ms",
        "legendFormat": "{{instance}}"
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "ms",
          "custom": {
            "thresholdsStyle": {"mode": "line"}
          },
          "thresholds": {
            "steps": [
              {"color": "green", "value": null},
              {"color": "yellow", "value": 30},
              {"color": "red", "value": 50}
            ]
          }
        }
      }
    },
    {
      "id": 3,
      "title": "Packet Loss (%)",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 8},
      "targets": [{
        "expr": "iperf3_lost_percent",
        "legendFormat": "{{instance}}"
      }],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "thresholds": {
            "steps": [
              {"color": "green", "value": null},
              {"color": "yellow", "value": 1},
              {"color": "red", "value": 5}
            ]
          }
        }
      }
    },
    {
      "id": 4,
      "title": "Jitter + Loss Compound Alert",
      "type": "stat",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 8},
      "targets": [{
        "expr": "iperf3_sent_jitter_ms > 30 and iperf3_lost_percent > 1",
        "instant": true
      }],
      "fieldConfig": {
        "defaults": {
          "mappings": [
            {"type": "value", "options": {"0": {"text": "OK", "color": "green"}}},
            {"type": "value", "options": {"1": {"text": "DEGRADED", "color": "red"}}}
          ]
        }
      }
    }
  ]
}
```

**B. Dashboard แนะนำสำหรับ VoIP**

| Dashboard |用途 |
|---|---|
| **Jitter & Voice Quality** (Custom ข้างต้น) | ดู Jitter + Loss + Compound Alert |
| **Homer / heplify** | วิเคราะห์ RTP Jitter จาก VoIP โดยตรง |

#### 3.12.10 สรุปย่อ

Jitter คือความแปรปรวนของ Packet Delay ที่ส่งผลต่อ VoIP/Video วัดได้ด้วย iperf3_exporter (UDP) หรือ RTP Metrics Threshold ที่ปลอดภัยคือ ≤ 30 ms (Warning) และ ≤ 50 ms (Critical) สาเหตุหลักคือ Congestion, Buffer Bloat, Route Change แก้ไขด้วย QoS, AQM (fq_codel), และเพิ่ม Bandwidth ต้องแยก Network Jitter vs Application Jitter ด้วย ICMP RTT

#### 3.12.11 ประโยชน์ที่ได้รับ

1. **คุณภาพเสียง/วิดีโอ:** มั่นใจได้ว่า Real-time Service ทำงานได้
2. **หลักฐาน:** Metrics Jitter ใช้คุยกับ Network Team ได้
3. **Early Warning:** Alert ที่ 30 ms ก่อนผู้ใช้รู้สึก
4. **Capacity Planning:** เห็น Jitter Trend ก่อนเกิดปัญหา

#### 3.12.12 ข้อควรระวัง

1. **iperf3 ใช้ Bandwidth จริง:** จำกัด Bitrate (`1M`) และ Schedule นอก Peak
2. **Jitter วัดได้เฉพาะ UDP:** TCP ไม่มี Jitter (มี Retransmission แทน)
3. **Jitter อาจมาจาก Application:** ต้องวัด RTT แยก Layer
4. **Threshold ขึ้นกับ Codec:** Opus ทน Jitter ได้ดีกว่า G.711

#### 3.12.13 ข้อดี

1. **วัดได้ด้วย Open Source:** iperf3 ไม่มีค่าใช้จ่าย
2. **Threshold ชัดเจน:** ตามมาตรฐาน ITU-T
3. **แก้ไขได้ตรงจุด:** QoS, AQM, Buffer

#### 3.12.14 ข้อเสีย

1. **iperf3 Test กระทบ Production:** ต้อง Schedule อย่างระวัง
2. **Jitter เปลี่ยนแปลงเร็ว:** ต้อง Scrape ถี่ (1–5 นาที)
3. **ไม่มี Metric Jitter จาก Node Exporter โดยตรง:** ต้องใช้ iperf3 หรือ RTP

#### 3.12.15 ข้อห้าม

1. **ห้าม Ignore Jitter Alert ในระบบ Voice/Video** — แม้ Latency/Loss จะปกติ
2. **ห้ามใช้ TCP วัด Jitter** — ใช้ UDP เท่านั้น
3. **ห้ามรัน iperf3 Test ที่ Bitrate สูงใน Peak** — กระทบ Production
4. **ห้ามสรุป Jitter จาก Network โดยไม่วัด RTT แยก** — อาจเป็น Application Jitter

#### 3.12.16 ตัวอย่าง

**สถานการณ์:** Voice Gateway มี Alert `VoiceVideoJitterWarning` (Jitter 45 ms)

**การวิเคราะห์:**
1. ตรวจ `iperf3_lost_percent` → 2% → มี Loss ร่วม
2. ตรวจ Interface Utilization → 85% → Congestion
3. ตรวจ QoS บน Router → Voice Traffic ไม่อยู่ใน Priority Queue
4. **Root Cause:** Backup Job ใช้ Bandwidth จน Voice ขาด QoS
5. **แก้ไข:** ตั้ง QoS ให้ Voice อยู่ใน Priority Queue, ย้าย Backup ไปกลางคืน
6. **ผลลัพธ์:** Jitter ลดลงเหลือ 12 ms, Loss 0%

#### 3.12.17 สรุปย่อเพื่อจดจำ

> **“Jitter = Latency ที่ไม่คงที่ — ศัตรูของ Voice/Video”**
>
> **“≤ 30 ms = Warning, ≤ 50 ms = Critical — ตาม ITU-T”**
>
> **“iperf3 UDP + QoS + AQM = แก้ Jitter ได้ตรงจุด”**

#### 3.12.18 แหล่งที่มาและแหล่งอ้างอิง

1. Huawei — *5G B2B Service Experience Standard White Paper* (Jitter Grading for Voice/Video): https://carrier.huawei.com/ 
2. ITU-T G.114 — *One-way Transmission Time*: https://www.itu.int/rec/T-REC-G.114 
3. iperf3_exporter — *UDP Jitter Metrics*: https://pkg.go.dev/github.com/yuvaldekel/iperf3_exporter 
4. heplify / Homer — *RTP Jitter Monitoring*: https://github.com/sipcapture/homer 
5. Bundesnetzagentur — *Jitter Thresholds for Voice/Video*: https://www.bundesnetzagentur.de/ 

---

## 4. Workflow (อ้างอิงเล่ม 1 + Incident Playbook เฉพาะเล่ม 2)

> **Workflow หลัก (PSR, RCA, KPI SMART) อยู่ในเล่ม 1 หัวข้อ 4.1–4.3** — เล่ม 2 ใช้ Workflow เดียวกัน แต่มี Incident Playbook เฉพาะสำหรับ Host/Network

### 4.1 PSR (Post-Incident Review) — การประยุกต์ใช้กับ Host/Network Incident

**Severity Mapping สำหรับ Host/Network:**

| Severity | เงื่อนไข | ตัวอย่าง | PSR Required | กำหนดเวลา |
|---|---|---|---|---|
| **P1** | Host Down ทั้ง Cluster หรือ Network ขาดทั้ง Site | Load Balancer ล่ม, Switch Core Down | ✅ บังคับ | ≤ 48 ชั่วโมง |
| **P2** | Host Resource Exhaustion หรือ Network Degraded | Disk เต็ม 95%, Jitter > 50 ms | ✅ บังคับ | ≤ 5 วันทำการ |
| **P3** | Host Resource Warning หรือ Network Warning | Disk 85%, Jitter > 30 ms | ⚠️ Optional | ตามดุลพินิจ |
| **P4** | Cosmetic | Dashboard แสดงผลผิด | ❌ ไม่ต้อง | — |

**Template PSR สำหรับ Host/Network:**

```markdown
# PSR Report: [Host/Network Incident Title]

**Incident ID:** INC-XXXX
**Severity:** P1 / P2
**Date:** YYYY-MM-DD
**Duration:** HH:MM
**Impact:** [จำนวน Host / Network Segment ที่กระทบ]
**Author:** [ชื่อ IC]
**Facilitator:** [ชื่อ]

## 1. Executive Summary
[สรุป 2-3 ประโยค: เกิดอะไร, ผลกระทบ, แก้อย่างไร]

## 2. Impact
| มิติ | รายละเอียด |
|---|---|
| **Hosts Affected** | X hosts |
| **Services Affected** | Checkout, Payment |
| **Users Affected** | XXX users |
| **SLA Breach** | ✅ / ❌ |

## 3. Timeline
| เวลา | เหตุการณ์ | ผู้ดำเนินการ |
|---|---|---|
| 10:00 | Alert `HostDiskWillFillIn4Hours` Fire | Alertmanager |
| 10:02 | On-call Ack | Support A |
| 10:05 | ตรวจ Disk Growth | Support A |
| 10:10 | พบ Log ไม่ Rotate | Support A |
| 10:15 | แก้ `logrotate` + ลบ Log เก่า | Support A |
| 10:20 | Disk กลับมา 60% | Support A |
| 10:25 | Incident Resolved | IC |

## 4. Root Cause
[อ้างอิง RCA — สรุป 1-2 ประโยค]

## 5. What Went Well
- Alert ทำงานถูกต้อง (Detect ภายใน 30 วินาที)
- Runbook Disk เต็มใช้ได้ผล

## 6. What to Improve
- ไม่มี Alert Log Growth Rate
- Log Retention Policy ไม่ชัดเจน

## 7. Action Items
| ID | Action | Owner | Due | Acceptance Criteria |
|---|---|---|---|---|
| AI-01 | เพิ่ม Alert Log Growth > 1GB/h | Support A | +7d | Alert ยิงใน Staging |
| AI-02 | กำหนด Log Retention 30 วัน | Infra | +14d | Config Updated |

## 8. Supporting Evidence
- Grafana Snapshot: [Link]
- Prometheus Query: [Link]
- Disk Usage Trend: [Link]
```

### 4.2 RCA — การประยุกต์ใช้กับ Host/Network Incident

**5 Whys สำหรับ Host Incident:**

```
Why 1: Host Disk เต็ม? → Log Growth ไม่ถูก Rotate
Why 2: Log ไม่ Rotate? → logrotate Config ไม่ครอบคลุม Log ใหม่
Why 3: Config ไม่ครอบคลุม? → ไม่มี Process Update logrotate เมื่อ Deploy Service ใหม่
Why 4: ไม่มี Process? → CI/CD ไม่ได้ตรวจ logrotate Config
Why 5: CI/CD ไม่ตรวจ? → ไม่มี Checklist สำหรับ Log Management  ← Root Cause (Process Gap)
```

**Ishikawa (Fishbone) สำหรับ Network Incident:**

```
                    [Jitter สูง]
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
   [Network]        [Application]      [Environment]
   • Congestion     • Jitter Buffer    • Backup Job
   • Buffer Bloat   • Codec            • Peak Hour
   • Route Change   • Thread Pool      • Campaign
```

**Evidence Bundle สำหรับ Network Incident:**

```markdown
# Evidence Bundle — Network Incident INC-XXXX

## 1. Metrics Snapshot
- Jitter: 80 ms (ปกติ < 20 ms)
- Loss: 2% (ปกติ < 0.1%)
- RTT: 25 ms (ปกติ)

## 2. iperf3 Output
\`\`\`
[  5]  0.00-10.00  sec  1.25 MBytes  1.05 Mbits/sec  0.080 ms  123/1000 (12%)
\`\`\`

## 3. SNMP Interface Errors
- `ifInErrors`: 0
- `ifOutDiscards`: 1,234 → Buffer Overflow

## 4. Change History
- Backup Job เริ่ม 13:00 (ปกติ 02:00)

## 5. Traceroute
- Path เปลี่ยนจาก ISP-A → ISP-B (Failover)
```

### 4.3 KPI SMART — การประยุกต์ใช้กับ Host/Network

**KPI ที่แนะนำสำหรับทีม Host/Network Support:**

| KPI | สูตร | Baseline | Target | Time-bound |
|---|---|---|---|---|
| **Host Uptime** | `(Total - Downtime) / Total × 100` | 99.9% | ≥ 99.95% | Q4/2026 |
| **MTTD (Host)** | `Σ Detect Time / #Incidents` | 10 นาที | ≤ 5 นาที | Q4/2026 |
| **MTTR (Host)** | `Σ Resolve Time / #Incidents` | 45 นาที | ≤ 30 นาที | Q4/2026 |
| **Network Availability** | `(Total - Downtime) / Total × 100` | 99.5% | ≥ 99.9% | Q4/2026 |
| **Jitter Compliance** | `% เวลาที่ Jitter < 30 ms` | 85% | ≥ 95% | Q4/2026 |
| **Alert Accuracy** | `True Positive / Total Alert × 100` | 80% | ≥ 90% | Q4/2026 |
| **Dashboard Coverage** | `% Host ที่มี Dashboard ครบ` | 70% | ≥ 95% | Q4/2026 |

**KPI Scorecard Template (Host/Network):**

```markdown
# KPI Scorecard — Host/Network — [เดือน]

| KPI | Target | Actual | Status | Trend | Action |
|---|---|---|---|---|---|
| Host Uptime | ≥ 99.95% | 99.97% | 🟢 | ↑ | — |
| MTTD | ≤ 5 นาที | 3 นาที | 🟢 | ↓ | — |
| MTTR | ≤ 30 นาที | 28 นาที | 🟢 | → | — |
| Network Availability | ≥ 99.9% | 99.85% | 🟡 | ↓ | ตรวจ Link Redundancy |
| Jitter Compliance | ≥ 95% | 92% | 🟡 | → | เพิ่ม QoS |
| Alert Accuracy | ≥ 90% | 85% | 🟡 | ↓ | ปรับ Threshold |
| Dashboard Coverage | ≥ 95% | 90% | 🟡 | ↑ | เพิ่ม Host ใหม่ |
```

---

## 5. สรุป

### 5.1 ประโยชน์ที่ได้รับ

คู่มือเล่ม 2 (Infrastructure & Network Monitoring) มอบความสามารถให้ทีม Support ในการ:

1. **ติดตั้งและตั้งค่า** Node Exporter, iperf3_exporter, Blackbox Exporter และ SNMP Exporter ได้ด้วยตนเอง
2. **อ่านและตีความ Metrics** Host และ Network ได้อย่างถูกต้อง — แยกแยะ CPU/Memory/Disk/Network
3. **วินิจฉัยปัญหา** Resource Exhaustion และ Network Degradation ด้วย Runbook ที่เป็นขั้นตอน
4. **สร้าง Dashboard และ Alert** จาก Template ที่พร้อมใช้ — ลดเวลา Setup
5. **วัดและแก้ไข Jitter** สำหรับ Voice/Video ตามมาตรฐาน ITU-T

### 5.2 ข้อดี

1. **End-to-End Visibility:** ครอบคลุมตั้งแต่ Host ถึง Network
2. **Template พร้อมใช้:** Dashboard JSON, Alert Rules, Custom Metrics Script
3. **มาตรฐานอุตสาหกรรม:** ใช้ Threshold ตาม ITU-T/Huawei
4. **Cost-effective:** Open Source ทั้งหมด
5. **Scale ได้:** ใช้ได้ตั้งแต่ 10 Host ถึง 1,000 Host

### 5.3 ข้อเสีย

1. **ต้องติดตั้ง Agent ทุก Host:** Node Exporter ต้องจัดการ Version
2. **iperf3 ใช้ Bandwidth จริง:** ต้อง Schedule อย่างระวัง
3. **SNMP เป็น Polling:** ไม่ Real-time เท่า Streaming Telemetry
4. **ไม่มี Metric Jitter จาก Node Exporter โดยตรง:** ต้องใช้ iperf3 หรือ RTP

### 5.4 ข้อห้าม

1. **ห้าม Containerize Node Exporter** — ใช้ Static Binary ใต้ Systemd
2. **ห้ามเปิด Port 9100 สู่ Public** — จำกัดเฉพาะ Prometheus
3. **ห้ามใช้ `MemFree` ประเมิน Memory Pressure** — ใช้ `MemAvailable`
4. **ห้าม Ignore Alert Disk จะเต็มภายใน 4 ชั่วโมง**
5. **ห้ามรัน iperf3 Test ที่ Bitrate สูงใน Peak** — กระทบ Production
6. **ห้ามใช้ TCP วัด Jitter** — ใช้ UDP เท่านั้น
7. **ห้ามสรุป Network จาก Latency เพียงอย่างเดียว** — ต้องดู Loss และ Jitter ร่วม
8. **ห้าม Ignore Jitter Alert ใน Voice/Video** — แม้ Latency/Loss จะปกติ

### 5.5 ก้าวต่อไป

หลังจากอ่านเล่ม 2 จบแล้ว ผู้อ่านสามารถ:

- **อ่านเล่ม 3 (Application Metrics & Metrics Platform)** เพื่อเชื่อมโยง Host Metrics กับ Application Metrics (RED Method) และตั้งค่า Prometheus/Grafana/Alertmanager เต็มรูปแบบ
- **อ่านเล่ม 4 (Log & Time-Series Analytics)** เพื่อเก็บ Log และ Long-term Metrics สำหรับ Forensic
- **อ่านเล่ม 5 (Messaging & Caching)** สำหรับ Kafka/Redis Observability

> **“Host คือรากฐาน — Network คือทางเชื่อม — Metrics คือภาษาที่ใช้คุยกัน”**
>
> **“Node Exporter ดู iowait, iperf3 ดู Jitter, Blackbox ดู RTT, SNMP ดู Interface”**
>
> **“แยก Network vs Application ให้ได้ก่อนเสมอ — อย่า Escalate ผิดทีม”**

---