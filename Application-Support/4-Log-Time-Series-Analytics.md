## เล่ม 4: Log & Time-Series Analytics — "ค้นหาและวิเคราะห์ข้อมูลย้อนหลัง"

> **กลุ่มงาน:** Support Engineer, Forensic Analyst, SRE
> **Dependency:** อ่านเล่ม 1 (Foundation & Workflow) ก่อน — แนะนำอ่านเล่ม 3 (Metrics Platform) ประกอบ
> **เวอร์ชัน:** 1.0

---

## บทนำ

### วัตถุประสงค์ของเล่ม

เล่มนี้ครอบคลุม **"Data Backend สำหรับ Analytics"** สองระบบที่ทำหน้าที่ complementary กัน:

| ระบบ | เก็บอะไร | ตอบคำถามอะไร | ใช้ตอน |
|---|---|---|---|
| **ELK Stack** | Log (ข้อความ) | "เกิดอะไรขึ้นตอน 14:32:15?" | Incident Investigation, Forensic |
| **InfluxDB** | Metrics (ตัวเลข, long-term) | "แนวโน้ม 6 เดือนเป็นอย่างไร?" | Capacity Planning, Trend Analysis |

เมื่ออ่านจบ ผู้อ่านจะสามารถ:

1. ติดตั้งและตั้งค่า **ELK Stack** (Elasticsearch + Logstash + Kibana) พร้อม Filebeat
2. เขียน **Grok Pattern** เพื่อ parse log ของ Application
3. ใช้ **KQL** (Kibana Query Language) สำหรับ Incident Investigation
4. ตั้งค่า **ILM** (Index Lifecycle Management) เพื่อจัดการพื้นที่ดิสก์
5. เชื่อม **Prometheus Remote Write → InfluxDB** เพื่อเก็บ Metrics ระยะยาว
6. สร้าง Dashboard ทั้งใน Kibana และ Grafana (คู่กับ InfluxDB)

### เป้าหมายของเล่ม

| เป้าหมาย | ตัวชี้วัดความสำเร็จ |
|---|---|
| Log ค้นหาได้ภายใน 30 วินาที | MTTR ลดลงจากการค้นหา Log |
| Metrics เก็บได้ > 1 ปี | ตอบ Capacity Planning ได้ |
| ไม่มี Disk Full | ILM ทำงาน, Retention ตามนโยบาย |
| Forensic ทำได้ | Log เก็บครบ + Immutable |

### สิ่งที่ **ไม่** อยู่ในเล่มนี้

- Metrics Real-time (Prometheus/Grafana) → **เล่ม 3**
- Kafka/Redis Observability → **เล่ม 5**
- Application Logging Best Practice (ใน Code) → **เล่ม 8** (DDD)
- Workflow PSR/RCA/KPI → **เล่ม 1**

### ทำไม ELK + InfluxDB อยู่เล่มเดียวกัน

ทั้งคู่เป็น **"Data Backend สำหรับ Analytics"** — ใช้คู่กับ Grafana (เล่ม 3) แต่ **ไม่ได้ทำ Alerting Real-time** (นั่นคือหน้าที่ Prometheus + Alertmanager) การแยกเล่มตามบทบาท (Role-based) ทำให้ Support Engineer ที่ต้องสอบสวน Incident ได้อ่านทั้งสองระบบในเล่มเดียว

---

## บทนิยาม (เฉพาะคำศัพท์ใหม่ในเล่มนี้)

| คำศัพท์ | ความหมาย |
|---|---|
| **ELK Stack** | Elasticsearch + Logstash + Kibana (บางครั้งเรียกว่า Elastic Stack เมื่อรวม Beats) |
| **Index** | หน่วยเก็บข้อมูลใน Elasticsearch (เปรียบเหมือน Table ใน RDBMS) |
| **Shard** | ชิ้นส่วนของ Index ที่กระจายอยู่หลาย Node |
| **Replica** | สำเนาของ Shard เพื่อ HA |
| **Mapping** | Schema ของ Index (Field ไหนเป็น text/keyword/date) |
| **Grok Pattern** | Regex แบบมีชื่อ ใช้ใน Logstash เพื่อ parse log (`%{IP:client_ip}`) |
| **KQL** | Kibana Query Language — ภาษาคิวรีใน Kibana (`status:500 and service:order`) |
| **ILM** | Index Lifecycle Management — นโยบายหมุนเวียน index (Hot→Warm→Cold→Delete) |
| **Data Stream** | Abstraction เหนือ Index สำหรับ append-only log (แนะนำแทน Index ตรงๆ) |
| **Filebeat** | Lightweight shipper — อ่าน log file แล้วส่งเข้า Logstash/Elasticsearch |
| **Logstash Pipeline** | Input → Filter → Output |
| **Ingest Node** | Elasticsearch Node ที่ parse document ก่อน index (แทน Logstash ได้บางกรณี) |
| **InfluxDB** | Time-Series Database (TSDB) — เน้น write throughput สูง, retention นาน |
| **Bucket** | หน่วยเก็บข้อมูลใน InfluxDB 2.x (แทน Database+Retention Policy ใน 1.x) |
| **Flux** | ภาษาคิวรีของ InfluxDB 2.x (แทน InfluxQL) |
| **Remote Write** | Prometheus ส่ง Metrics ไปยังปลายทาง (InfluxDB รองรับผ่าน `/api/v1/prom/write`) |
| **Downsampling** | ลดความละเอียดของข้อมูลเก่า (1s → 1m) เพื่อประหยัดพื้นที่ |
| **Retention Policy** | นโยบายลบข้อมูลเก่าอัตโนมัติ |

---

## บทหัวข้อ

---

## 3.8 ELK Stack (Elasticsearch, Logstash, Kibana) + Filebeat + Grok Pattern + ILM

### เรื่อง
การติดตั้งและตั้งค่า ELK Stack แบบ Production-grade สำหรับเก็บและค้นหา Log ของ Application

### วัตถุประสงค์ / เป้าหมาย
- รวม Log จากทุก Service ไว้ที่เดียว (Centralized Logging)
- ค้นหา Log ย้อนหลังได้ภายในไม่กี่วินาที (Sub-second search)
- จัดการพื้นที่ดิสก์อัตโนมัติด้วย ILM
- Forensic Investigation ได้ (Log เก็บครบ + Query ได้)

### เนื้อหา / รายละเอียด

#### สถาปัตยกรรม

```
┌──────────┐    ┌──────────┐    ┌──────────────┐    ┌─────────┐
│ App Logs │───▶│ Filebeat │───▶│  Logstash    │───▶│Elastic  │◀─── Kibana
│ (files)  │    │ (shipper)│    │ (parse/     │    │search   │
└──────────┘    └──────────┘    │  enrich)    │    │(store/  │
                                └──────────────┘    │ search) │
                                                    └─────────┘
```

#### ทำไมต้องมี Logstash ถ้ามี Ingest Node

| สถานการณ์ | ใช้ |
|---|---|
| Parse ง่าย (JSON log) | Ingest Node (ไม่ต้องมี Logstash) |
| Parse ซับซ้อน (Grok หลายชั้น, GeoIP, Enrichment) | Logstash |
| ต้อง buffer (คิว) เมื่อ Elasticsearch ล่ม | Logstash (Persistent Queue) |
| Throughput สูงมาก (>50K EPS) | Logstash + Kafka |
| ต้องการ Centralized Pipeline Management | Logstash |

> **คำแนะนำ:** เริ่มจาก **Filebeat → Elasticsearch (Ingest Pipeline)** ก่อน — เพิ่ม Logstash เมื่อต้องการ parse ซับซ้อน

#### Log Structure ที่ดี (JSON Structured Logging)

```json
{
  "@timestamp": "2025-01-15T14:32:15.123Z",
  "level": "ERROR",
  "service": "order-api",
  "instance": "order-api-7d9f-abc",
  "trace_id": "abc123def456",
  "span_id": "span-789",
  "user_id": "u-42",
  "message": "Payment failed",
  "error": {
    "type": "PaymentGatewayTimeout",
    "stack": "..."
  },
  "http": {
    "method": "POST",
    "path": "/orders",
    "status": 500,
    "duration_ms": 2345
  }
}
```

> **กฎ:** Log ทุกบรรทัดควรเป็น **JSON เดียว** (1 event = 1 line) — ง่ายต่อการ parse และค้นหา

### การติดตั้ง / การตั้งค่า

#### Docker Compose (ELK Stack)

```yaml
version: "3.8"
services:

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.15.0
    container_name: elasticsearch
    restart: unless-stopped
    environment:
      - discovery.type=single-node          # dev; prod ใช้ multi-node
      - xpack.security.enabled=true
      - ELASTIC_PASSWORD=${ES_PASSWORD}
      - ES_JAVA_OPTS=-Xms4g -Xmx4g
      - bootstrap.memory_lock=true
    ulimits:
      memlock: { soft: -1, hard: -1 }
      nofile:  { soft: 65536, hard: 65536 }
    volumes:
      - es-data:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"
    networks: [logging]

  logstash:
    image: docker.elastic.co/logstash/logstash:8.15.0
    container_name: logstash
    restart: unless-stopped
    volumes:
      - ./logstash/pipeline:/usr/share/logstash/pipeline:ro
      - ./logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml:ro
      - logstash-data:/usr/share/logstash/data
    environment:
      - "LS_JAVA_OPTS=-Xms1g -Xmx1g"
      - xpack.monitoring.enabled=false
    ports:
      - "5044:5044"          # Beats input
      - "9600:9600"          # Monitoring API
    depends_on: [elasticsearch]
    networks: [logging]

  kibana:
    image: docker.elastic.co/kibana/kibana:8.15.0
    container_name: kibana
    restart: unless-stopped
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - ELASTICSEARCH_USERNAME=kibana_system
      - ELASTICSEARCH_PASSWORD=${KIBANA_PASSWORD}
    ports:
      - "5601:5601"
    depends_on: [elasticsearch]
    networks: [logging]

  filebeat:
    image: docker.elastic.co/beats/filebeat:8.15.0
    container_name: filebeat
    restart: unless-stopped
    user: root                                    # ต้องอ่าน /var/log
    volumes:
      - ./filebeat/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
      - /var/log/app:/var/log/app:ro
      - filebeat-data:/usr/share/filebeat/data
    command: ["filebeat", "-e", "-strict.perms=false"]
    depends_on: [logstash]
    networks: [logging]

volumes:
  es-data:
  logstash-data:
  filebeat-data:

networks:
  logging:
    driver: bridge
```

#### `filebeat.yml` — ครบทุกโหมด

```yaml
filebeat.inputs:

  # ── 1) Application Log (JSON)
  - type: filestream
    id: app-json
    enabled: true
    paths:
      - /var/log/app/*.log
    parsers:
      - ndjson:
          target: ""                # เก็บ field ที่ root
          overwrite_keys: true
          add_error_key: true
    fields:
      log_type: application
      environment: production
    fields_under_root: false

  # ── 2) Nginx Access Log (plain text → parse ที่ Logstash)
  - type: filestream
    id: nginx-access
    enabled: true
    paths:
      - /var/log/nginx/access.log
    fields:
      log_type: nginx_access
      environment: production

  # ── 3) System Log
  - type: filestream
    id: system-log
    enabled: true
    paths:
      - /var/log/syslog
      - /var/log/messages
    fields:
      log_type: system

  # ── 4) Multiline (stack trace รวมเป็น event เดียว)
  - type: filestream
    id: java-stacktrace
    enabled: false
    paths:
      - /var/log/app-java/*.log
    parsers:
      - multiline:
          type: pattern
          pattern: '^\s+(at |\.\.\.)'   # บรรทัดขึ้นต้นด้วย space + at = ต่อจากบรรทัดก่อน
          negate: true
          match: after
          max_lines: 500

# ── Output
output.logstash:
  hosts: ["logstash:5044"]
  loadbalance: true
  worker: 2

# ── (ทางเลือก) ส่งตรง Elasticsearch โดยไม่ผ่าน Logstash
# output.elasticsearch:
#   hosts: ["elasticsearch:9200"]
#   username: "elastic"
#   password: "${ES_PASSWORD}"
#   pipeline: "app-parse-pipeline"

# ── Processor (ทำที่ Filebeat ก่อนส่ง — ลดภาระ Logstash)
processors:
  - add_host_metadata:
      when.not.contains.tags: forwarded
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - drop_fields:
      fields: ["agent.ephemeral_id", "agent.id", "ecs.version"]
      ignore_missing: true

# ── Monitoring
monitoring.enabled: true
monitoring.elasticsearch:
  hosts: ["http://elasticsearch:9200"]
  username: "elastic"
  password: "${ES_PASSWORD}"

# ── Logging
logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
```

#### `logstash.conf` — พร้อม Grok Pattern

```ruby
# logstash/pipeline/main.conf

input {
  beats {
    port => 5044
    codec => "json"
  }
}

filter {

  # ═══════════════════════════════════════════
  # 1) Application JSON — ผ่านไปเลย (parse แล้ว)
  # ═══════════════════════════════════════════
  if [fields][log_type] == "application" {
    # Normalize level
    mutate {
      uppercase => { "level" => "level" }
      add_field => { "[@metadata][target_index]" => "app-logs" }
    }

    # ถ้ามี trace_id → เก็บไว้ใช้ correlate
    if [trace_id] {
      mutate { add_tag => ["has_trace"] }
    }

    # Error log → tag พิเศษ
    if [level] == "ERROR" or [level] == "FATAL" {
      mutate { add_tag => ["error_log"] }
    }
  }

  # ═══════════════════════════════════════════
  # 2) Nginx Access Log — Grok Parse
  # ═══════════════════════════════════════════
  else if [fields][log_type] == "nginx_access" {
    grok {
      match => {
        "message" => '%{IPORHOST:client_ip} - %{DATA:remote_user} \[%{HTTPDATE:timestamp}\] "%{WORD:http_method} %{DATA:url_path} HTTP/%{NUMBER:http_version}" %{NUMBER:http_status:int} %{NUMBER:bytes_sent:int} "%{DATA:referrer}" "%{DATA:user_agent}" %{NUMBER:request_time:float}'
      }
      tag_on_failure => ["_grokparsefailure_nginx"]
    }

    date {
      match => ["timestamp", "dd/MMM/yyyy:HH:mm:ss Z"]
      target => "@timestamp"
    }

    # GeoIP (ต้องมี plugin logstash-filter-geoip)
    geoip {
      source => "client_ip"
      target => "geo"
      fields => ["country_name", "city_name", "location"]
    }

    # User-Agent parse
    useragent {
      source => "user_agent"
      target => "ua"
    }

    mutate {
      convert => { "http_status" => "integer" }
      add_field => { "[@metadata][target_index]" => "nginx-access" }
      remove_field => ["timestamp", "message"]
    }

    # Tag error (4xx, 5xx)
    if [http_status] >= 500 {
      mutate { add_tag => ["server_error"] }
    } else if [http_status] >= 400 {
      mutate { add_tag => ["client_error"] }
    }
  }

  # ═══════════════════════════════════════════
  # 3) System Log — parse แบบง่าย
  # ═══════════════════════════════════════════
  else if [fields][log_type] == "system" {
    grok {
      match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:host} %{DATA:program}(?:\[%{POSINT:pid}\])?: %{GREEDYDATA:syslog_message}" }
      tag_on_failure => ["_grokparsefailure_syslog"]
    }

    date {
      match => ["syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss"]
      target => "@timestamp"
    }

    mutate {
      add_field => { "[@metadata][target_index]" => "system-logs" }
    }
  }

  # ═══════════════════════════════════════════
  # 4) Common enrichment
  # ═══════════════════════════════════════════
  mutate {
    add_field => {
      "ingested_at" => "%{+yyyy-MM-dd'T'HH:mm:ss.SSSZ}"
      "log_source" => "%{[fields][environment]}"
    }
  }

  # ลบ field ที่ไม่ใช้
  mutate {
    remove_field => ["[fields]", "[agent]", "[ecs]", "[input]", "[host][os]", "[host][ip]"]
  }
}

output {

  # ── Data Stream (แนะนำ — จัดการ ILM อัตโนมัติ)
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    user => "elastic"
    password => "${ES_PASSWORD}"
    data_stream => "true"
    data_stream_type => "logs"
    data_stream_dataset => "app"
    data_stream_namespace => "production"
  }

  # ── Debug (เปิดชั่วคราว)
  # stdout { codec => rubydebug }

  # ── Dead letter (parse fail)
  if "_grokparsefailure" in [tags] or "_grokparsefailure_nginx" in [tags] {
    file {
      path => "/var/log/logstash/failed/%{+yyyy-MM-dd}.log"
      codec => line { format => "%{message}" }
    }
  }
}
```

#### ILM Policy — จัดการ Retention

```json
PUT _ilm/policy/logs-app-policy
{
  "policy": {
    "phases": {
      "hot": {
        "min_age": "0ms",
        "actions": {
          "rollover": {
            "max_primary_shard_size": "50gb",
            "max_age": "1d"
          },
          "set_priority": { "priority": 100 }
        }
      },
      "warm": {
        "min_age": "7d",
        "actions": {
          "shrink": { "number_of_shards": 1 },
          "forcemerge": { "max_num_segments": 1 },
          "set_priority": { "priority": 50 }
        }
      },
      "cold": {
        "min_age": "30d",
        "actions": {
          "set_priority": { "priority": 0 },
          "readonly": {}
        }
      },
      "delete": {
        "min_age": "90d",
        "actions": { "delete": {} }
      }
    }
  }
}
```

> **สรุป ILM:** Hot (0-7d) → Warm (7-30d) → Cold (30-90d) → Delete (>90d) — ปรับตาม compliance ขององค์กร

#### Data Stream Template

```json
PUT _index_template/logs-app-template
{
  "index_patterns": ["logs-app.production-*"],
  "data_stream": {},
  "template": {
    "settings": {
      "index.lifecycle.name": "logs-app-policy",
      "number_of_shards": 2,
      "number_of_replicas": 1
    },
    "mappings": {
      "properties": {
        "@timestamp":  { "type": "date" },
        "level":       { "type": "keyword" },
        "service":     { "type": "keyword" },
        "instance":    { "type": "keyword" },
        "trace_id":    { "type": "keyword" },
        "span_id":     { "type": "keyword" },
        "user_id":     { "type": "keyword" },
        "message":     { "type": "text" },
        "error.type":  { "type": "keyword" },
        "http.method": { "type": "keyword" },
        "http.path":   { "type": "keyword" },
        "http.status": { "type": "integer" },
        "http.duration_ms": { "type": "long" }
      }
    }
  }
}
```

> **Mapping Rule:** `keyword` สำหรับ field ที่ใช้ filter/aggregate, `text` สำหรับ field ที่ต้อง full-text search

### Kibana KQL Queries สำหรับ Incident Investigation

```kql
# ── หา Error ทั้งหมดใน 1 ชั่วโมงล่าสุด
level: "ERROR" and @timestamp >= now-1h

# ── Error ของ service เดียว
level: "ERROR" and service: "order-api"

# ── HTTP 5xx จาก Nginx
http_status >= 500 and log_type: "nginx_access"

# ── ตาม trace_id (correlate ข้าม service)
trace_id: "abc123def456"

# ── Error ที่มี stack trace (multiline)
level: "ERROR" and error.stack: *

# ── Slow request (> 2s)
http.duration_ms > 2000

# ── Error ตามช่วงเวลา (Incident window)
level: "ERROR" and @timestamp >= "2025-01-15T14:30:00" and @timestamp <= "2025-01-15T14:45:00"

# ── User ที่เจอ error
user_id: "u-42" and level: "ERROR"

# ── Wildcard (ระวัง performance)
service: order-* and level: (ERROR or FATAL)

# ── Negative (ไม่รวม field)
NOT level: "INFO" and NOT level: "DEBUG"

# ── Regex (ใช้ sparingly)
message: /timeout after \d+ms/

# ── Exists
error.type: *

# ── Aggregate ด้วย Kibana Lens (Visualization)
# - Count by service (top 10)
# - Error rate by service over time
# - P95 http.duration_ms by endpoint
```

#### Saved Search ที่ควรมี (สำหรับ Support)

| ชื่อ | KQL | ใช้เมื่อ |
|---|---|---|
| `errors-last-hour` | `level: ERROR and @timestamp >= now-1h` | ตรวจสุขภาพ |
| `errors-by-service` | `level: ERROR` (Lens: count by service) | หา service ที่มีปัญหา |
| `slow-api` | `http.duration_ms > 2000` | หา slow endpoint |
| `5xx-errors` | `http.status >= 500` | Incident triage |
| `trace-lookup` | (ใส่ trace_id ทีละครั้ง) | Correlate ข้าม service |
| `security-audit` | `event.category: authentication and event.outcome: failure` | Security review |

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| Log ไม่เข้า Elasticsearch | Filebeat → Logstash connection fail | ตรวจ `output.logstash` + port 5044 |
| `_grokparsefailure` | Pattern ไม่ match log format | ทดสอบ Grok ด้วย Kibana Dev Tools (`POST _ingest/pipeline/_simulate`) |
| ค้นหาช้า (>5s) | Index ใหญ่เกิน, mapping ผิด | ILM rollover + forcemerge + ใช้ `keyword` |
| Disk เต็ม | Retention ยาวเกิน | ILM delete phase + shrink |
| Kibana แสดง `unmapped` | Mapping ไม่ประกาศ field | ใส่ใน template, reindex |
| Log ซ้ำ | Filebeat อ่านไฟล์ซ้ำหลัง restart | ตรวจ `filebeat-data` volume + `filebeat.registry` |
| JSON parse fail | Log ไม่ใช่ JSON valid | ตรวจ multiline + JSON escaping |

### ลำดับการจัดการปัญหา

**Log ไม่เข้า Elasticsearch:**

1. `curl http://localhost:5044` — Logstash port เปิด?
2. ดู Log Filebeat: `docker logs filebeat | grep -i error`
3. ดู Log Logstash: `docker logs logstash | grep -i error`
4. ตรวจ Elasticsearch: `curl -u elastic:PASS http://localhost:9200/_cluster/health`
5. ตรวจ Index: `curl -u elastic:PASS "http://localhost:9200/_cat/indices?v"`
6. ตรวจ Pipeline: `curl -u elastic:PASS "http://localhost:9200/_ingest/pipeline?pretty"`

**ค้นหาช้า:**

1. Kibana Dev Tools: `GET logs-app.production-*/_search?profile=true` — ดู profile
2. ตรวจ Shard: `GET _cat/shards/logs-app.production-*?v` — shard ใหญ่เกิน 50GB?
3. ตรวจ Mapping: `GET logs-app.production-*/_mapping` — ใช้ keyword ถูก?
4. ใช้ `now-1h` แทน `now-30d` — ลด time range

### Template Code
→ ดู `filebeat.yml`, `logstash.conf`, ILM, Template ด้านบน

### Template Dashboard (Kibana)

```json
{
  "version": "8.15.0",
  "objects": [
    {
      "id": "error-log-overview",
      "type": "dashboard",
      "attributes": {
        "title": "Error Log Overview",
        "panels": [
          {
            "gridData": { "x": 0, "y": 0, "w": 24, "h": 8, "i": "1" },
            "panelIndex": "1",
            "embeddableConfig": {
              "title": "Error Count by Service (Last 24h)"
            },
            "panelRefName": "panel_1"
          },
          {
            "gridData": { "x": 0, "y": 8, "w": 12, "h": 10, "i": "2" },
            "panelIndex": "2",
            "embeddableConfig": {
              "title": "Error Timeline"
            }
          },
          {
            "gridData": { "x": 12, "y": 8, "w": 12, "h": 10, "i": "3" },
            "panelIndex": "3",
            "embeddableConfig": {
              "title": "Top Error Types"
            }
          },
          {
            "gridData": { "x": 0, "y": 18, "w": 24, "h": 12, "i": "4" },
            "panelIndex": "4",
            "embeddableConfig": {
              "title": "Recent Error Logs (Raw)"
            }
          }
        ],
        "timeRestore": true,
        "timeFrom": "now-24h",
        "timeTo": "now"
      }
    }
  ]
}
```

> **Tip:** สร้าง Dashboard ใน Kibana UI แล้ว **Export** → เก็บ JSON ใน Git → **Import** ตอน deploy (ใช้ Kibana Saved Objects API)

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** Centralized Logging, Forensic Investigation, Correlate ข้าม Service ด้วย trace_id
- **ข้อควรระวัง:** **Disk** — Log โตเร็วมาก ต้องมี ILM ตั้งแต่วันแรก
- **ข้อดี:** ค้นหาเร็ว (Elasticsearch), Grok ยืดหยุ่น, Kibana Visualize ดี
- **ข้อเสีย:** Resource เยอะ (ES ต้องการ RAM 4GB+), Logstash กิน CPU, Mapping ผิดแก้ยาก
- **ข้อห้าม:**
  - ❌ เก็บ **Log ที่มี PII/Secret** (password, token, credit card) — ต้อง mask ก่อน
  - ❌ ใช้ ELK เป็น Metrics DB (ใช้ Prometheus/InfluxDB)
  - ❌ เก็บ Log > 90 วันโดยไม่มี Downsampling/ILM
  - ❌ ใช้ `*` wildcard ใน KQL โดยไม่จำเป็น — ช้ามาก
  - ❌ Log JSON ที่ nested ลึกเกิน 3 ชั้น — mapping ระเบิด

### ตัวอย่าง (Mask PII ด้วย Logstash)

```ruby
filter {
  mutate {
    gsub => [
      "message", "(?i)password=\S+", "password=***",
      "message", "\b\d{13,16}\b", "***-CREDIT-CARD-***",
      "message", "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}", "***@***"
    ]
  }
}
```

### สรุปย่อเพื่อจดจำ
> **ELK** = Elasticsearch (เก็บ) + Logstash (parse) + Kibana (search) + Filebeat (ship) — **ILM ตั้งแต่แรก** — **Grok** สำหรับ plain text, **JSON** สำหรับ structured — **Mapping keyword vs text** — **Mask PII** ก่อนเข้า

### แหล่งที่มา
- https://www.elastic.co/guide/en/elastic-stack/current/index.html
- https://www.elastic.co/guide/en/logstash/current/plugins-filters-grok.html
- https://www.elastic.co/guide/en/elasticsearch/reference/current/index-lifecycle-management.html
- Elastic, *Elasticsearch: The Definitive Guide* (free online)

---

## 3.13 InfluxDB (Time-Series DB, Remote Write จาก Prometheus, Long-term Retention)

### เรื่อง
การติดตั้ง InfluxDB 2.x และตั้งค่า Prometheus Remote Write เพื่อเก็บ Metrics ระยะยาว (Long-term Retention)

### วัตถุประสงค์ / เป้าหมาย
- เก็บ Metrics ได้ > 1 ปี (Prometheus เก็บได้ 15-30 วัน)
- ตอบ Capacity Planning ("CPU โตเท่าไรใน 6 เดือน?")
- Downsampling อัตโนมัติ (1s → 1m → 1h)
- ใช้ Grafana เป็น UI (ไม่ต้องใช้ InfluxDB UI)

### เนื้อหา / รายละเอียด

#### ทำไมต้อง InfluxDB (ไม่ใช่ Prometheus อย่างเดียว)

| ด้าน | Prometheus | InfluxDB |
|---|---|---|
| Retention | 15-30 วัน | 1+ ปี |
| Write throughput | ปานกลาง | สูงมาก |
| Downsampling | ไม่มีในตัว | มี (Tasks) |
| Query language | PromQL | Flux (หรือ InfluxQL) |
| Alerting | มี | ไม่เน้น (ใช้ Prometheus) |
| HA | ต้องใช้ Thanos/Mimir | InfluxDB Enterprise หรือ OSS cluster |

> **สรุป:** Prometheus = **Real-time + Alert**, InfluxDB = **Long-term + Capacity Planning**

#### InfluxDB 1.x vs 2.x vs 3.x

| Version | สถานะ | แนะนำ |
|---|---|---|
| 1.8 | Legacy | ❌ ไม่แนะนำสำหรับโปรเจกต์ใหม่ |
| 2.7 | Stable, Flux | ✅ แนะนำ (บทนี้ใช้ 2.x) |
| 3.x | ออกใหม่, ใช้ SQL | ⚠️ ใหม่ — รอ ecosystem |

### การติดตั้ง / การตั้งค่า

#### Docker Compose (InfluxDB 2.7)

```yaml
  influxdb:
    image: influxdb:2.7
    container_name: influxdb
    restart: unless-stopped
    environment:
      - DOCKER_INFLUXDB_INIT_MODE=setup
      - DOCKER_INFLUXDB_INIT_USERNAME=admin
      - DOCKER_INFLUXDB_INIT_PASSWORD=${INFLUX_PASSWORD}
      - DOCKER_INFLUXDB_INIT_ORG=myorg
      - DOCKER_INFLUXDB_INIT_BUCKET=prometheus
      - DOCKER_INFLUXDB_INIT_RETENTION=0          # 0 = infinite; ตั้งทีหลัง
      - DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=${INFLUX_TOKEN}
    volumes:
      - influx-data:/var/lib/influxdb2
      - influx-config:/etc/influxdb2
    ports:
      - "8086:8086"
    networks: [monitoring]

volumes:
  influx-data:
  influx-config:
```

#### สร้าง Bucket + Retention Policy (InfluxDB UI หรือ CLI)

```bash
# CLI (ใช้ influx CLI)
influx bucket create \
  --name prometheus-raw \
  --retention 30d \
  --org myorg \
  --token $INFLUX_TOKEN

influx bucket create \
  --name prometheus-1m \
  --retention 365d \
  --org myorg \
  --token $INFLUX_TOKEN

influx bucket create \
  --name prometheus-1h \
  --retention 1825d \
  --org myorg \
  --token $INFLUX_TOKEN
```

#### Prometheus → InfluxDB (Remote Write)

```yaml
# prometheus.yml (ต่อจากเล่ม 3)
remote_write:
  - url: "http://influxdb:8086/api/v1/prom/write?org=myorg&bucket=prometheus-raw"
    bearer_token_file: /etc/prometheus/influx_token
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
      - source_labels: [__name__]
        regex: "prometheus_.*"
        action: drop
      - source_labels: [__name__]
        regex: "scrape_.*"
        action: drop
```

> **หมายเหตุ:** InfluxDB 2.7 รองรับ Prometheus Remote Write ผ่าน `/api/v1/prom/write?org=<org>&bucket=<bucket>` — ต้องตั้ง `Authorization: Bearer <token>` ด้วย

#### เพิ่ม Authorization Header

```bash
# สร้าง token file
echo -n "$INFLUX_TOKEN" > /etc/prometheus/influx_token
chmod 600 /etc/prometheus/influx_token
```

#### Downsampling Task (InfluxDB 2.x — Flux)

```javascript
// Task: downsampling 1m → 1h (รันทุกชั่วโมง)
option task = {name: "downsample-1h", every: 1h}

from(bucket: "prometheus-1m")
  |> range(start: -2h)                         // ย้อนหลัง 2h เผื่อ delay
  |> filter(fn: (r) => r._measurement == "http_requests_total")
  |> filter(fn: (r) => r._field == "value")
  |> aggregateWindow(every: 1h, fn: mean, createEmpty: false)
  |> set(key: "_measurement", value: "http_requests_total_1h")
  |> to(bucket: "prometheus-1h", org: "myorg")
```

```javascript
// Task: downsampling raw → 1m (รันทุก 5 นาที)
option task = {name: "downsample-1m", every: 5m}

from(bucket: "prometheus-raw")
  |> range(start: -15m)
  |> filter(fn: (r) => r._field == "value")
  |> aggregateWindow(every: 1m, fn: mean, createEmpty: false)
  |> to(bucket: "prometheus-1m", org: "myorg")
```

> **Downsampling Strategy:** Raw (30d, 1s) → 1m (1y) → 1h (5y) — ลดพื้นที่ 60× ในแต่ละชั้น

### Flux Query — ตัวอย่างที่ Support ต้องใช้

```javascript
// ── 1) CPU trend 6 เดือน
from(bucket: "prometheus-1h")
  |> range(start: -180d)
  |> filter(fn: (r) => r._measurement == "node_cpu_seconds_total")
  |> filter(fn: (r) => r._field == "value")
  |> filter(fn: (r) => r.mode == "idle")
  |> aggregateWindow(every: 1d, fn: mean)

// ── 2) Request rate เปรียบเทียบเดือนนี้ vs เดือนที่แล้ว
thisMonth = from(bucket: "prometheus-1h")
  |> range(start: -30d)
  |> filter(fn: (r) => r._measurement == "http_requests_total")
  |> aggregateWindow(every: 1d, fn: sum)

lastMonth = from(bucket: "prometheus-1h")
  |> range(start: -60d, stop: -30d)
  |> filter(fn: (r) => r._measurement == "http_requests_total")
  |> aggregateWindow(every: 1d, fn: sum)
  |> timeShift(duration: 30d)

union(tables: [thisMonth, lastMonth])

// ── 3) Top 10 services by error count (last 7d)
from(bucket: "prometheus-1m")
  |> range(start: -7d)
  |> filter(fn: (r) => r._measurement == "http_requests_total")
  |> filter(fn: (r) => r.status =~ /^5/)
  |> group(columns: ["job"])
  |> sum()
  |> group()
  |> sort(columns: ["_value"], desc: true)
  |> limit(n: 10)

// ── 4) Disk usage growth (capacity planning)
from(bucket: "prometheus-1h")
  |> range(start: -90d)
  |> filter(fn: (r) => r._measurement == "node_filesystem_avail_bytes")
  |> filter(fn: (r) => r.instance == "prod-01:9100")
  |> aggregateWindow(every: 1d, fn: min)

// ── 5) SLO burn rate (30-day window)
total = from(bucket: "prometheus-1m")
  |> range(start: -30d)
  |> filter(fn: (r) => r._measurement == "http_requests_total")
  |> sum()

errors = from(bucket: "prometheus-1m")
  |> range(start: -30d)
  |> filter(fn: (r) => r._measurement == "http_requests_total")
  |> filter(fn: (r) => r.status =~ /^5/)
  |> sum()

(errorCount: errors, totalCount: total)
// SLO = 1 - (errorCount / totalCount)
```

### การตั้งค่า Grafana Data Source (InfluxDB)

```yaml
# grafana/provisioning/datasources/influxdb.yml
apiVersion: 1
datasources:
  - name: InfluxDB
    type: influxdb
    access: proxy
    url: http://influxdb:8086
    jsonData:
      version: Flux
      organization: myorg
      defaultBucket: prometheus-1m
      tlsSkipVerify: false
    secureJsonData:
      token: ${INFLUX_TOKEN}
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุ | แก้ไข |
|---|---|---|
| Remote write fail | Token ผิด, org/bucket ไม่มี | ตรวจ `influx auth list` + bucket |
| Query ช้ามาก | Bucket ใหญ่, ไม่ downsample | เพิ่ม Task + Query จาก bucket ที่ downsampled |
| Disk เต็ม | Retention 0 (infinite) | ตั้ง retention + downsample |
| Downsample Task fail | Flux syntax ผิด | ตรวจ Task log ใน UI |
| Grafana query ว่าง | Time range กว้างเกิน | ใช้ bucket ที่เหมาะสม + ลด time range |
| Remote write queue full | InfluxDB ช้า/ล่ม | ตรวจ `prometheus_remote_storage_*` metrics |

### ลำดับการจัดการปัญหา

**Remote Write ไม่ทำงาน:**

1. `curl -H "Authorization: Bearer $TOKEN" http://influxdb:8086/api/v2/buckets` — token ถูกไหม
2. ตรวจ Prometheus: `prometheus_remote_storage_samples_failed_total` metric
3. ดู Prometheus log: `docker logs prometheus | grep -i remote`
4. ตรวจ InfluxDB: `docker logs influxdb`
5. ทดสอบเขียนตรง: `curl -XPOST http://influxdb:8086/api/v1/prom/write?org=myorg&bucket=prometheus-raw ...`

**Query ช้า:**

1. ใช้ `prometheus-1h` bucket สำหรับ query > 7d
2. ลด `range(start: -X)` — ใช้ duration ที่แคบที่สุด
3. เพิ่ม `aggregateWindow` — ลดจำนวน point
4. ตรวจ cardinality: `influx query 'import "influxdata/influxdb/schema" schema.tagKeys(bucket: "prometheus-raw")'`

### Template Code
→ ดู Docker Compose, Remote Write, Flux Tasks ด้านบน

### Template Dashboard (Grafana + InfluxDB — Long-term Metrics)

```json
{
  "title": "Long-term Metrics (InfluxDB)",
  "uid": "longterm-metrics-v1",
  "tags": ["influxdb", "capacity"],
  "templating": {
    "list": [
      {
        "name": "bucket",
        "type": "query",
        "datasource": {"type": "influxdb", "uid": "influxdb"},
        "query": "buckets()",
        "refresh": 1
      },
      {
        "name": "range",
        "type": "custom",
        "query": "1d,7d,30d,90d,180d,1y",
        "current": {"text": "90d", "value": "90d"}
      }
    ]
  },
  "panels": [
    {
      "id": 1, "type": "timeseries", "title": "CPU Trend ($range)",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 0},
      "targets": [{
        "datasource": {"type": "influxdb", "uid": "influxdb"},
        "query": "from(bucket: \"$bucket\") |> range(start: -$range) |> filter(fn: (r) => r._measurement == \"node_cpu_seconds_total\") |> filter(fn: (r) => r.mode == \"idle\") |> aggregateWindow(every: 1d, fn: mean)"
      }]
    },
    {
      "id": 2, "type": "timeseries", "title": "Request Rate ($range)",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 0},
      "targets": [{
        "datasource": {"type": "influxdb", "uid": "influxdb"},
        "query": "from(bucket: \"$bucket\") |> range(start: -$range) |> filter(fn: (r) => r._measurement == \"http_requests_total\") |> aggregateWindow(every: 1d, fn: sum)"
      }]
    },
    {
      "id": 3, "type": "timeseries", "title": "Disk Usage Growth ($range)",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 8},
      "targets": [{
        "datasource": {"type": "influxdb", "uid": "influxdb"},
        "query": "from(bucket: \"$bucket\") |> range(start: -$range) |> filter(fn: (r) => r._measurement == \"node_filesystem_avail_bytes\") |> aggregateWindow(every: 1d, fn: min)"
      }]
    },
    {
      "id": 4, "type": "stat", "title": "SLO (30d)",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 8},
      "targets": [{
        "datasource": {"type": "influxdb", "uid": "influxdb"},
        "query": "import \"math\"\ntotal = from(bucket: \"$bucket\") |> range(start: -30d) |> filter(fn: (r) => r._measurement == \"http_requests_total\") |> sum()\nerrors = from(bucket: \"$bucket\") |> range(start: -30d) |> filter(fn: (r) => r._measurement == \"http_requests_total\") |> filter(fn: (r) => r.status =~ /^5/) |> sum()\njoin(tables: {t: total, e: errors}, on: [\"_measurement\"]) |> map(fn: (r) => ({r with _value: 1.0 - (r._value_e / r._value_t)}))"
      }]
    }
  ],
  "time": {"from": "now-90d", "to": "now"},
  "refresh": "5m"
}
```

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** Metrics เก็บได้เป็นปี, Capacity Planning, Downsampling ประหยัดพื้นที่
- **ข้อควรระวัง:** **Retention = 0 = infinite** — ต้องตั้งให้ชัด
- **ข้อดี:** Write throughput สูง, Flux ยืดหยุ่น, Downsampling ในตัว
- **ข้อเสีย:** Flux ต้องเรียนรู้ใหม่ (ต่างจาก PromQL), UI ไม่สวยเท่า Grafana
- **ข้อห้าม:**
  - ❌ ใช้ InfluxDB เป็น Real-time Alerting (ใช้ Prometheus + Alertmanager)
  - ❌ เก็บ Raw 1s > 30 วัน (ให้ Downsample)
  - ❌ ตั้ง Retention 0 โดยไม่ตั้งใจ — Disk จะเต็ม
  - ❌ Query `from(bucket:"...")` โดยไม่ระบุ `range` — ดึงทั้งหมด ช้ามาก
  - ❌ ใช้ InfluxDB เป็น Log Store (ใช้ ELK)

### ตัวอย่าง (Prometheus Remote Write กับ Downsampling ครบ Pipeline)

```
Prometheus (15d, 15s resolution)
    │
    ├─▶ Remote Write ─▶ InfluxDB Raw (30d, 15s)
    │                       │
    │                       ├─▶ Task 5m ─▶ InfluxDB 1m (1y)
    │                       │                    │
    │                       │                    ├─▶ Task 1h ─▶ InfluxDB 1h (5y)
    │                       │
    └─▶ Alerting (Alertmanager)
```

### สรุปย่อเพื่อจดจำ
> **InfluxDB** = Long-term TSDB — Prometheus Remote Write → Raw (30d) → Downsample 1m (1y) → 1h (5y) — **Flux** Query — ใช้ Grafana เป็น UI — ไม่ใช่ Alerting

### แหล่งที่มา
- https://docs.influxdata.com/influxdb/v2/
- https://docs.influxdata.com/flux/v0/
- https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write
- https://docs.influxdata.com/influxdb/v2/write-data/no-code/use-telegraf/auto-config/

---

## Workflow (อ้างอิงเล่ม 1 + Incident Playbook เฉพาะเล่ม)

### อ้างอิง Workflow หลักจากเล่ม 1

| Workflow | ใช้ในเล่มนี้เมื่อ |
|---|---|
| **PSR** | เขียนรายงานหลัง Incident ที่ใช้ Log Investigation |
| **RCA 5 Whys** | หา Root Cause จาก Log Pattern |
| **KPI SMART** | ตั้ง KPI ของ Logging (เช่น Log Search < 5s, Retention 90d) |

→ Template เต็มอยู่ใน **เล่ม 1 หัวข้อ 4**

### Incident Playbook เฉพาะเล่ม 4

#### Playbook A: Forensic Investigation — "หา Timeline ของ Incident"

**ขั้นตอน:**

1. **กำหนด Time Window** — จาก Alert ที่ fire (เช่น 14:30–14:45)
2. **Search Error Log ใน Window:**
   ```kql
   level: ERROR and @timestamp >= "2025-01-15T14:30:00" and @timestamp <= "2025-01-15T14:45:00"
   ```
3. **Group by Service** — service ไหนเริ่ม error ก่อน?
4. **หา First Error** — sort by @timestamp asc → ดู 10 รายการแรก
5. **ดึง trace_id** — จาก First Error → search `trace_id: "abc123"` ข้าม service
6. **Correlate กับ Metrics** — เปิด Grafana (เล่ม 3) ช่วงเวลาเดียวกัน
7. **บันทึก Timeline:**
   ```
   14:30:12 — First error in order-api (trace_id abc123)
   14:30:15 — DB connection pool exhausted (log จาก db-proxy)
   14:30:20 — Alert HighErrorRate fired
   14:30:25 — Billing service timeout
   14:31:00 — Order service circuit breaker open
   ```
8. **เขียน PSR Report** (อ้างอิงเล่ม 1)

#### Playbook B: Log ไม่เข้า (Pipeline Broken)

1. **ตรวจ Filebeat** — `docker logs filebeat | tail -50` — มี error shipping?
2. **ตรวจ Logstash** — `docker logs logstash | grep -i error` — pipeline error?
3. **ตรวจ Elasticsearch** — `curl http://localhost:9200/_cluster/health` — RED?
4. **ตรวจ Index** — `curl "http://localhost:9200/_cat/indices/logs-*?v"` — index สร้างใหม่?
5. **ตรวจ Disk** — `df -h` — ES disk เต็ม?
6. **ตรวจ Watermark** — `GET _cat/allocation?v` — มี node ที่ disk > 85%?
7. **ระหว่างแก้** — ใช้ `stdout { codec => rubydebug }` ใน Logstash เพื่อดู raw event

#### Playbook C: Disk เต็ม (Log Retention)

1. **ตรวจ Index เก่า** — `GET _cat/indices/logs-*?v&s=index` — index ไหนเก่า/ใหญ่?
2. **ตรวจ ILM** — `GET logs-app.production-*/_ilm/explain` — ILM ทำงาน?
3. **Manual Delete** (ฉุกเฉิน):
   ```bash
   # ลบ index ที่เก่ากว่า 90 วัน
   curl -XDELETE "http://localhost:9200/logs-app.production-2024.10.*"
   ```
4. **Force Merge** — `POST logs-app.production-2024.12.01/_forcemerge?max_num_segments=1`
5. **ปรับ ILM** — ลด `delete.min_age` จาก 90d → 30d (ชั่วคราว)
6. **เพิ่ม Disk** — ถาวร

#### Playbook D: InfluxDB Remote Write ล้มเหลว

1. **ตรวจ Prometheus metric** — `prometheus_remote_storage_samples_failed_total`
2. **ตรวจ Prometheus log** — `docker logs prometheus | grep -i "remote storage"`
3. **ตรวจ InfluxDB** — `curl http://localhost:8086/health`
4. **ตรวจ Token** — `curl -H "Authorization: Bearer $TOKEN" http://localhost:8086/api/v2/buckets`
5. **ตรวจ Bucket** — มีจริงไหม?
6. **ระหว่างแก้** — Prometheus จะ buffer ไว้ (WAL) — แต่มีขีดจำกัด (`max_shards`)
7. **ถ้า buffer เต็ม** — Metrics จะหาย — ต้องแจ้งใน Incident Report

---

## สรุป (ประโยชน์, ข้อดี, ข้อเสีย, ข้อห้าม)

### ประโยชน์ของเล่ม 4

- **Centralized Logging:** Log จากทุก Service รวมที่เดียว ค้นหาด้วย KQL
- **Forensic Capability:** ตอบ "เกิดอะไรขึ้น" ได้ด้วย Timeline + trace_id correlation
- **Long-term Metrics:** Capacity Planning จากข้อมูล 1–5 ปี
- **Cost-Effective:** Downsampling ลดพื้นที่ 60× โดยไม่เสียประโยชน์
- **Integration:** Grafana ใช้ได้ทั้ง Prometheus (real-time) และ InfluxDB (long-term)

### ข้อดี

| ด้าน | ผลลัพธ์ |
|---|---|
| **MTTR** | ลดลง 40–60% จากการค้นหา Log เร็วขึ้น |
| **Forensic** | ตอบคำถาม "ใครทำอะไรเมื่อไร" ได้ |
| **Capacity** | วางแผนซื้อ Hardware ล่วงหน้าได้ |
| **Compliance** | เก็บ Log 90 วันตาม พ.ร.บ.คอมพิวเตอร์ |
| **Debugging** | trace_id correlate ข้าม Service |

### ข้อเสีย / ข้อจำกัด

- **Resource:** ELK ต้องการ RAM 4GB+ (ES) + 1GB (Logstash), InfluxDB 2GB+
- **Complexity:** Pipeline มี 4 component (Filebeat → Logstash → ES → Kibana) — debug ยาก
- **Learning Curve:** Grok + Flux + KQL ต้องฝึก
- **Cost:** Disk สำหรับ Log โตเร็วมาก (100 GB/เดือนสำหรับ中型ระบบ)
- **Mapping Change:** เปลี่ยน mapping ใน ES ทำได้ยาก (reindex)

### ข้อห้าม (สรุป)

1. ❌ **ห้ามเก็บ Log ที่มี PII/Secret** (password, token, credit card, เลขบัตร ปชช.) — ต้อง Mask
2. ❌ **ห้ามใช้ ELK เป็น Metrics DB** — ใช้ Prometheus (real-time) + InfluxDB (long-term)
3. ❌ **ห้ามใช้ InfluxDB เป็น Log Store** — ใช้ ELK
4. ❌ **ห้ามตั้ง Retention = 0** ใน InfluxDB โดยไม่ตั้งใจ — Disk จะเต็ม
5. ❌ **ห้ามใช้ `*` wildcard ใน KQL** โดยไม่จำเป็น — ช้ามาก
6. ❌ **ห้าม Log JSON nested ลึกเกิน 3 ชั้น** — mapping ระเบิด
7. ❌ **ห้าม Deploy ELK โดยไม่มี ILM** — Disk จะเต็มใน < 1 เดือน
8. ❌ **ห้ามใช้ `from(bucket:"...")` โดยไม่มี `range()`** ใน Flux — ดึงทั้งหมด ช้ามาก
9. ❌ **ห้ามใช้ InfluxDB เป็น Alerting** — ใช้ Prometheus + Alertmanager
10. ❌ **ห้ามใช้ Default password** (elastic, admin) — ต้องตั้งรหัสที่แข็งแรง

---

## เส้นทางอ่านต่อ

| ถ้าคุณเป็น | อ่านต่อ |
|---|---|
| Monitoring Engineer | → **เล่ม 5** (Kafka/Redis Observability) |
| Business App Support | → **เล่ม 7** (CRM Support) |
| ERP Support (Full-stack) | → **เล่ม 5** → **เล่ม 8** → **เล่ม 9** → **เล่ม 10** |
| AI Engineer | → **เล่ม 5** → **เล่ม 6** (AI & RAG) |
| Forensic Analyst | → ฝึก Kibana + Flux เพิ่ม (นอกเล่ม) |

---

> **เวอร์ชันเอกสาร:** 1.0
> **ผู้รับผิดชอบ:** SRE Team
> **ปรับปรุงล่าสุด:** ตามรอบ Quarter
> **สถานะ:** ✅ Ready for Review

---

 