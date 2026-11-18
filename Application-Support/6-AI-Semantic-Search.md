## เล่ม 6: AI & Semantic Search — "สาย AI Support"
**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับ

> **กลุ่มงาน:** AI Engineer, Support Engineer ที่ดูแล AI Application
> **Dependency:** อ่านเล่ม 4 (Log & Time-Series Analytics — เกี่ยวกับ Retrieval) และเล่ม 5 (Kafka/Redis — เกี่ยวกับ Data Pipeline) ก่อน
> **เวอร์ชัน:** 1.0

---

## บทนำ

### วัตถุประสงค์ของเล่ม

เล่มนี้ครอบคลุม **Observability ของระบบ AI ที่ใช้ Vector Database และ RAG (Retrieval-Augmented Generation)** — ระบบที่ตอบคำถามด้วยการค้นหาข้อมูลจาก Vector Store แล้วส่งให้ LLM สร้างคำตอบ เมื่ออ่านจบ ผู้อ่านจะสามารถ:

1. เข้าใจสถาปัตยกรรม Vector Database (Qdrant, Milvus, Weaviate, pgvector) ในมุม Observability
2. ติดตั้ง **Prometheus Exporter** สำหรับ Vector Database และดึง Metrics ที่สำคัญ
3. เข้าใจ **RAG Pipeline** (Embedding → Retrieval → Rerank → Generation) และจุดที่ต้อง Instrument
4. วัด **Retrieval Quality** (Recall@K, Precision, Semantic Relevance) และ **Generation Quality** (Faithfulness, Hallucination Rate)
5. ตั้ง Alert Rules สำหรับ RAG (RetrievalLatencyHigh, LowRecall, HallucinationRateSpike)
6. สร้าง Dashboard ที่ตอบ "RAG Pipeline กำลังมีปัญหาหรือไม่" ภายใน 10 วินาที
7. ใช้ Incident Playbook สำหรับ RAG โดยเฉพาะ

### เป้าหมายของเล่ม

| เป้าหมาย | ตัวชี้วัดความสำเร็จ |
|---|---|
| เห็น Retrieval Quality ก่อน user บ่น | Alert `RAGLowRecall` fire ก่อน answer quality ตก |
| ตรวจ Hallucination ได้ | Online eval sampling 1–5% ทำงาน |
| เห็น Latency ของแต่ละ Stage | Trace แยก Embed/Retrieve/Generate |
| Vector DB Health ครบ | Collection, Indexed Ratio, Search Latency |
| Incident Triage เร็ว | MTTR ลดลงจากการเห็น Trace + Metrics |

### สิ่งที่ **ไม่** อยู่ในเล่มนี้

- Application Metrics ทั่วไป (RED Method) → **เล่ม 3**
- Kafka/Redis Observability (Data Pipeline) → **เล่ม 5**
- Log Analysis (ELK) → **เล่ม 4**
- LLM Model Training / Fine-tuning → นอกขอบเขต (เฉพาะ Observability ของ Inference)
- Vector Database Internals (HNSW, IVF algorithm) → กล่าวถึงเฉพาะที่เกี่ยวกับ Monitoring

### ทำไม Vector Database + RAG อยู่เล่มเดียวกัน

Vector Database เป็น **component หลัก** ของ RAG Pipeline — การ Monitor แยกกันจะไม่ตอบคำถาม "ทำไมคำตอบผิด" เพราะปัญหาอาจอยู่ที่ Retrieval (ดึง chunk ผิด) หรือ Generation (LLM ไม่สนใจ context) การรวมไว้เล่มเดียวทำให้ AI Support Engineer เห็น **ทั้ง Pipeline** และวินิจฉัยได้ถูกจุด

---

## บทนิยาม (เฉพาะคำศัพท์ใหม่ในเล่มนี้)

### Vector Database

| คำศัพท์ | ความหมาย |
|---|---|
| **Vector Database** | ฐานข้อมูลที่เก็บ Embedding (Vector) และค้นหาด้วยความคล้ายคลึง (Similarity Search) |
| **Embedding** | การแปลงข้อความเป็น Vector (ตัวเลขหลายมิติ) — เช่น `text-embedding-3-small` (1536 dims) |
| **Similarity Search** | การค้นหา Vector ที่ใกล้ที่สุด (Cosine, Euclidean, Dot Product) |
| **ANN (Approximate Nearest Neighbor)** | การค้นหาแบบประมาณ (เร็วกว่า Exact แต่ recall < 100%) |
| **HNSW** | ดัชนีグラフสำหรับ ANN (Hierarchical Navigable Small World) |
| **Collection** | หน่วยเก็บข้อมูลใน Vector DB (เปรียบเหมือน Table) |
| **Indexed Ratio** | สัดส่วน Vector ที่ถูก index แล้ว (ถ้า < 1.0 = search อาจ fallback brute force) |
| **Recall@K** | สัดส่วนของ True Top-K ที่ระบบดึงได้ (เช่น Recall@10 = 0.95 หมายถึงได้ 9.5/10) |
| **Top-K** | จำนวนผลลัพธ์ที่ดึงมา (เช่น top_k=5) |
| **Reranker** | Model ที่จัดเรียงผลลัพธ์ใหม่ (Cross-Encoder) เพื่อเพิ่มความแม่นยำ |
| **Chunk** | ส่วนของเอกสารที่ถูกแบ่งเพื่อ Embed (เช่น 512 tokens/chunk) |

### RAG Pipeline

| คำศัพท์ | ความหมาย |
|---|---|
| **RAG (Retrieval-Augmented Generation)** | สถาปัตยกรรมที่ดึงข้อมูลภายนอกมาเสริมให้ LLM ตอบ |
| **Faithfulness** | ระดับที่คำตอบสอดคล้องกับ Context ที่ดึงมา (0–1) |
| **Hallucination** | คำตอบที่ LLM สร้างขึ้นเองโดยไม่มีหลักฐานใน Context |
| **Groundedness** | คำตอบมีรากฐานจาก Context จริง (ตรงข้ามกับ Hallucination) |
| **Context Precision** | สัดส่วนของ Chunk ที่ดึงมาว่าเกี่ยวข้องจริง |
| **Context Recall** | สัดส่วนของข้อมูลที่จำเป็นต่อการตอบถูกดึงมาครบ |
| **TTFT (Time to First Token)** | เวลาจนถึง token แรกของ LLM |
| **Trace / Span** | การติดตาม Request หนึ่งๆ ผ่าน Stage ต่างๆ (OpenTelemetry) |
| **Online Eval** | การประเมินคุณภาพบน Traffic จริง (Sampling 1–5%) |
| **Offline Eval** | การประเมินด้วย Golden Set (ก่อน Deploy) |
| **LLM-as-a-Judge** | การใช้ LLM อีกตัวเป็นผู้ให้คะแนน (เช่น `claude-sonnet-5`) |

---

## บทหัวข้อ

---

## 3.14 Vector Database (หลักการ, Embedding, Similarity Search, Metrics ที่ต้อง Monitor)

### เรื่อง
Observability ของ Vector Database — มุมมองที่ AI Support ต้องรู้เพื่อตอบว่า "Retrieval กำลังมีปัญหาหรือไม่"

### วัตถุประสงค์ / เป้าหมาย
- เห็น **Search Latency** และ **Recall** ก่อน user บ่นว่าค้นหาไม่เจอ
- ตรวจ **Indexed Ratio** (ถ้า < 1.0 = search fallback brute force → ช้า)
- ตรวจ **Memory** ของ Vector DB (Vector ใช้ RAM เยอะ)
- รู้ **Collection Size** และ **Index Build Time**

### เนื้อหา / รายละเอียด

#### Vector Database Comparison (2026)

| Database | จุดเด่น | Latency (Median) | Recall@10 | หมายเหตุ |
|---|---|---|---|---|
| **Qdrant** | Latency ต่ำสุด, Memory เบา | 4.55–7.2 ms | 99.1–99.3% | แนะนำสำหรับ RAG ทั่วไป |
| **Weaviate** | Recall สูงสุด out-of-the-box, QPS สูง | 4.9–9 ms | >99% | ดีสำหรับ High-throughput |
| **Milvus** | Scalable, Ecosystem ใหญ่ | 8.6 ms | 94.8% (default) | กิน RAM เยอะ (peak 2.6 GB ตอน index 100K) |
| **pgvector** | ใช้ PostgreSQL ที่มีอยู่ | 6.6–28 ms | 95.4% (default) | ตั้ง `hnsw.ef_search=100` → 98.4% |
| **Pinecone** | Managed SaaS | - | - | มี Open-source Monitoring Stack |

> **คำแนะนำ:** เลือกตาม Latency/Recall ที่ต้องการ — Qdrant สำหรับ Latency-sensitive, Weaviate สำหรับ Recall สูงสุด, pgvector ถ้าใช้ PostgreSQL อยู่แล้ว

#### Metrics ที่ต้อง Monitor (จัดลำดับความสำคัญ)

| ลำดับ | Metric | ความหมาย | ค่าปกติ |
|:---:|---|---|---|
| **1** | `search_latency_seconds` (Histogram) | เวลาค้นหา | P99 < 50 ms |
| **2** | `indexed_ratio` | สัดส่วน Vector ที่ index แล้ว | **1.0** (ถ้า < 1.0 = brute force) |
| **3** | `collection_vector_count` | จำนวน Vector | ตาม design |
| **4** | `memory_used_bytes` | Memory ของ Vector DB | < 80% ของ RAM |
| **5** | `search_requests_total` | จำนวน Search | เพิ่มขึ้น |
| **6** | `index_build_duration_seconds` | เวลาสร้าง Index | ตามขนาดข้อมูล |
| **7** | `deleted_vectors_total` | Vector ที่ถูกลบ (ยังไม่ compact) | ควรถูก optimize |
| **8** | `optimizer_status` | สถานะ Optimizer (Qdrant) | `done` |
| **9** | `cluster_status` | สถานะ Cluster | `green` |
| **10** | `recall_at_k` (custom) | Recall จาก Offline Eval | > 0.95 |

### การติดตั้ง / การตั้งค่า

#### Docker Compose (Qdrant + `qdrant-exporter`)

```yaml
version: "3.8"
services:

  # ── Qdrant
  qdrant:
    image: qdrant/qdrant:v1.19.0
    container_name: qdrant
    restart: unless-stopped
    volumes:
      - qdrant-data:/qdrant/storage
    ports:
      - "6333:6333"      # HTTP API
      - "6334:6334"      # gRPC
    environment:
      - QDRANT__SERVICE__GRPC_PORT=6334
      - QDRANT__TELEMETRY_DISABLED=true
    networks: [monitoring]

  # ── qdrant-exporter (Prometheus)
  qdrant-exporter:
    image: baselhusam/qdrant-exporter:latest
    container_name: qdrant-exporter
    restart: unless-stopped
    environment:
      - QDRANT_URL=http://qdrant:6333
      - QDRANT_API_KEY=${QDRANT_API_KEY}
      - EXPORTER_PORT=9153
    ports:
      - "9153:9153"
    depends_on: [qdrant]
    networks: [monitoring]

volumes:
  qdrant-data:

networks:
  monitoring:
    driver: bridge
```

> **หมายเหตุ:** `qdrant-exporter` ดึงข้อมูลจาก `/telemetry` และ `/cluster` ของ Qdrant — ให้ Metrics ที่ `qdrant/metrics` endpoint ไม่มี เช่น **per-collection vector count, indexed ratio, optimizer state, search latency by path type**

#### Prometheus Scrape Config

```yaml
# prometheus.yml (ต่อจากเล่ม 3)
scrape_configs:
  - job_name: "qdrant-exporter"
    static_configs:
      - targets: ["qdrant-exporter:9153"]
        labels:
          cluster: prod-vector-1
          env: production
    scrape_interval: 30s
```

#### Alert Rules — Vector Database

```yaml
# rules/vector-db-alerts.yml
groups:
  - name: vector-db-observability
    interval: 30s
    rules:

      # ═══════════════════════════════════════════
      # 1) Search Latency สูง
      # ═══════════════════════════════════════════
      - alert: VectorDBSearchLatencyHigh
        expr: |
          histogram_quantile(0.99,
            sum by (le, collection) (rate(qdrant_search_latency_seconds_bucket[5m]))
          ) > 0.1
        for: 10m
        labels:
          severity: warning
          team: ai-platform
        annotations:
          summary: "Vector search P99 > 100ms on {{ $labels.collection }}"
          description: "Index อาจไม่พอ / ข้อมูลเยอะเกิน — ตรวจ indexed_ratio"
          runbook_url: "https://wiki.example.com/runbook/vector-latency"

      # ═══════════════════════════════════════════
      # 2) Indexed Ratio ต่ำ (Search fallback brute force)
      # ═══════════════════════════════════════════
      - alert: VectorDBIndexedRatioLow
        expr: qdrant_indexed_vectors_ratio < 0.95
        for: 15m
        labels:
          severity: warning
          team: ai-platform
        annotations:
          summary: "Only {{ $value | humanizePercentage }} vectors indexed in {{ $labels.collection }}"
          description: "Index ยังสร้างไม่เสร็จ — search อาจ fallback brute force (ช้า)"
          runbook_url: "https://wiki.example.com/runbook/vector-index"

      # ═══════════════════════════════════════════
      # 3) Memory สูง
      # ═══════════════════════════════════════════
      - alert: VectorDBMemoryHigh
        expr: |
          (qdrant_memory_used_bytes / qdrant_memory_total_bytes) > 0.85
        for: 10m
        labels:
          severity: warning
          team: ai-platform
        annotations:
          summary: "Vector DB memory > 85%"
          description: "Vector ใช้ RAM เยอะ — ตรวจ collection size, เพิ่ม RAM"
          runbook_url: "https://wiki.example.com/runbook/vector-memory"

      # ═══════════════════════════════════════════
      # 4) Optimizer ค้าง (Deleted vectors ไม่ถูก compact)
      # ═══════════════════════════════════════════
      - alert: VectorDBOptimizerStuck
        expr: qdrant_optimizer_status{status!="done"} > 0
        for: 30m
        labels:
          severity: warning
          team: ai-platform
        annotations:
          summary: "Optimizer stuck in {{ $labels.collection }}"
          description: "Deleted vectors สะสม — ตรวจ disk, CPU"

      # ═══════════════════════════════════════════
      # 5) Cluster ไม่ healthy
      # ═══════════════════════════════════════════
      - alert: VectorDBClusterUnhealthy
        expr: qdrant_cluster_status{status!="green"} > 0
        for: 5m
        labels:
          severity: critical
          team: ai-platform
        annotations:
          summary: "Vector DB cluster status = {{ $labels.status }}"
          description: "ตรวจ peer count, Raft consensus, shard transfer"
```

#### PromQL — Vector DB ครบชุด

```promql
# ── Search Latency ────────────────────────────────────
# P99 Search Latency (per collection)
histogram_quantile(0.99,
  sum by (le, collection) (rate(qdrant_search_latency_seconds_bucket[5m]))
)

# Average Search Latency
rate(qdrant_search_latency_seconds_sum[5m])
  / rate(qdrant_search_latency_seconds_count[5m])

# ── Indexed Ratio ─────────────────────────────────────
# สัดส่วน Vector ที่ index แล้ว (ควร = 1.0)
qdrant_indexed_vectors_ratio

# ── Collection Size ───────────────────────────────────
# จำนวน Vector ต่อ collection
qdrant_collection_vectors

# จำนวน Points ต่อ collection
qdrant_collection_points

# ── Memory ────────────────────────────────────────────
qdrant_memory_used_bytes / qdrant_memory_total_bytes

# ── Search Rate ───────────────────────────────────────
rate(qdrant_search_requests_total[5m])

# ── Optimizer ─────────────────────────────────────────
qdrant_optimizer_status

# ── Cluster ───────────────────────────────────────────
qdrant_cluster_status
qdrant_cluster_peers
```

#### Dashboard JSON — Vector DB Overview

```json
{
  "title": "Vector DB Overview",
  "uid": "vector-db-overview-v1",
  "tags": ["vector-db", "rag"],
  "templating": {
    "list": [
      {
        "name": "collection",
        "type": "query",
        "datasource": {"type": "prometheus", "uid": "prometheus"},
        "query": "label_values(qdrant_collection_vectors, collection)",
        "refresh": 1,
        "multi": true,
        "includeAll": true
      }
    ]
  },
  "panels": [
    {
      "id": 1, "type": "stat", "title": "Collections",
      "gridPos": {"h": 4, "w": 6, "x": 0, "y": 0},
      "targets": [{"expr": "count(qdrant_collection_vectors{collection=~\"$collection\"})"}]
    },
    {
      "id": 2, "type": "stat", "title": "Total Vectors",
      "gridPos": {"h": 4, "w": 6, "x": 6, "y": 0},
      "targets": [{"expr": "sum(qdrant_collection_vectors{collection=~\"$collection\"})"}]
    },
    {
      "id": 3, "type": "stat", "title": "Indexed Ratio",
      "gridPos": {"h": 4, "w": 6, "x": 12, "y": 0},
      "targets": [{"expr": "min(qdrant_indexed_vectors_ratio{collection=~\"$collection\"})"}],
      "fieldConfig": {"defaults": {
        "unit": "percentunit",
        "thresholds": {"steps": [
          {"color": "red", "value": null},
          {"color": "yellow", "value": 0.95},
          {"color": "green", "value": 1}
        ]}
      }}
    },
    {
      "id": 4, "type": "stat", "title": "Memory Usage",
      "gridPos": {"h": 4, "w": 6, "x": 18, "y": 0},
      "targets": [{"expr": "qdrant_memory_used_bytes / qdrant_memory_total_bytes"}],
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
      "id": 10, "type": "timeseries", "title": "Search Latency P50/P90/P99",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 4},
      "targets": [
        {"expr": "histogram_quantile(0.50, sum by (le) (rate(qdrant_search_latency_seconds_bucket[5m])))", "legendFormat": "P50"},
        {"expr": "histogram_quantile(0.90, sum by (le) (rate(qdrant_search_latency_seconds_bucket[5m])))", "legendFormat": "P90"},
        {"expr": "histogram_quantile(0.99, sum by (le) (rate(qdrant_search_latency_seconds_bucket[5m])))", "legendFormat": "P99"}
      ],
      "fieldConfig": {"defaults": {"unit": "s"}}
    },
    {
      "id": 11, "type": "timeseries", "title": "Search Rate (req/s)",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 4},
      "targets": [{
        "expr": "rate(qdrant_search_requests_total{collection=~\"$collection\"}[5m])",
        "legendFormat": "{{collection}}"
      }]
    },
    {
      "id": 12, "type": "timeseries", "title": "Vectors per Collection",
      "gridPos": {"h": 7, "w": 8, "x": 0, "y": 12},
      "targets": [{
        "expr": "qdrant_collection_vectors{collection=~\"$collection\"}",
        "legendFormat": "{{collection}}"
      }]
    },
    {
      "id": 13, "type": "timeseries", "title": "Indexed Ratio",
      "gridPos": {"h": 7, "w": 8, "x": 8, "y": 12},
      "targets": [{
        "expr": "qdrant_indexed_vectors_ratio{collection=~\"$collection\"}",
        "legendFormat": "{{collection}}"
      }],
      "fieldConfig": {"defaults": {"unit": "percentunit", "min": 0, "max": 1}}
    },
    {
      "id": 14, "type": "timeseries", "title": "Memory Used",
      "gridPos": {"h": 7, "w": 8, "x": 16, "y": 12},
      "targets": [{"expr": "qdrant_memory_used_bytes"}],
      "fieldConfig": {"defaults": {"unit": "bytes"}}
    }
  ],
  "time": {"from": "now-1h", "to": "now"},
  "refresh": "30s"
}
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุที่เป็นไปได้ | แนวทางแก้ไข |
|---|---|---|
| Search Latency สูง | Indexed ratio < 1.0 (brute force), ข้อมูลเยอะ, RAM ไม่พอ | ตรวจ `indexed_ratio`, เพิ่ม RAM, optimize index |
| Indexed Ratio < 1.0 | Index ยังสร้างไม่เสร็จ | รอ optimizer, ตรวจ disk I/O, ลด batch size |
| Memory สูง | Collection ใหญ่, vector dimensions สูง | ลด dimensions (Matryoshka), เพิ่ม RAM, sharding |
| Optimizer ค้าง | Disk เต็ม, CPU ไม่พอ | ตรวจ disk, CPU, เพิ่ม resource |
| Cluster ไม่ healthy | Peer ล่ม, network partition | ตรวจ Raft consensus, restart peer |
| Recall ตก (custom metric) | Embedding drift, index เก่า | Re-index, ตรวจ embedding model version |

### ลำดับการจัดการปัญหา (Search Latency สูง)

1. **ยืนยัน Latency** — Grafana panel / `histogram_quantile(0.99, ...)`
2. **ตรวจ Indexed Ratio** — `qdrant_indexed_vectors_ratio` — < 1.0?
3. **ตรวจ Memory** — `qdrant_memory_used_bytes / qdrant_memory_total_bytes` — > 85%?
4. **ตรวจ Collection Size** — `qdrant_collection_vectors` — โตผิดปกติ?
5. **ตรวจ Optimizer** — `qdrant_optimizer_status` — ค้าง?
6. **แก้:**
   - Indexed ratio ต่ำ → รอ optimizer / เพิ่ม resource
   - Memory สูง → เพิ่ม RAM หรือลด dimensions
   - Collection ใหญ่ → sharding / ลด top_k

### Template Code
→ ดู Docker Compose, Alert Rules, PromQL ด้านบน

### Template Dashboard
→ ดู Vector DB Overview JSON ด้านบน

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** เห็น Retrieval Health ก่อน user บ่น, ตรวจ Index/Memory ได้
- **ข้อควรระวัง:** **Indexed Ratio < 1.0 = ช้า** — ต้อง Alert ทันที
- **ข้อดี:** `qdrant-exporter` ให้ Metrics ที่ native endpoint ไม่มี (per-collection, optimizer state)
- **ข้อเสีย:** Vector DB ต่างกันใช้ Exporter ต่างกัน — ต้องเลือกให้ตรง
- **ข้อห้าม:**
  - ❌ ใช้ Vector DB โดยไม่ Monitor Indexed Ratio
  - ❌ ปล่อยให้ Memory > 90% โดยไม่ Alert
  - ❌ ใช้ `top_k` สูงเกินจำเป็น (เช่น 100) — เพิ่ม Latency + Token cost
  - ❌ Ignore Optimizer status — deleted vectors สะสม ทำให้ช้า

### ตัวอย่าง (pgvector Monitoring)

```sql
-- pgvector: ตรวจ Index Size และ Recall
SELECT
  schemaname,
  relname AS table_name,
  pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
  pg_size_pretty(pg_indexes_size(relid)) AS index_size
FROM pg_catalog.pg_statio_user_tables
WHERE relname = 'embeddings';

-- ตั้ง HNSW ef_search ให้สูงขึ้นเพื่อ Recall ดีขึ้น
SET hnsw.ef_search = 100;  -- default 40 → 100 lifts recall from 95.4% to 98.4%
```

### สรุปย่อเพื่อจดจำ
> **Vector DB Observability** — Search Latency P99 < 50ms — Indexed Ratio = 1.0 — Memory < 80% — `qdrant-exporter` สำหรับ Qdrant — Alert `IndexedRatioLow` (สำคัญสุด)

### แหล่งที่มา
- https://github.com/baselhusam/qdrant_exporter
- https://qdrant.tech/documentation/guides/monitoring/
- Geekflare, "9 Best Open Source Vector Databases in 2026"
- Splunk AppDynamics, "Vector Database Metrics" (2026)

---

## 3.15 RAG (Retrieval-Augmented Generation) + Pipeline Monitoring

### เรื่อง
Observability ของ RAG Pipeline — มุมมองที่ AI Support ต้องรู้เพื่อตอบว่า "ทำไมคำตอบผิด" และ "Pipeline กำลังเสื่อมคุณภาพหรือไม่"

### วัตถุประสงค์ / เป้าหมาย
- แยก **Retrieval Error** vs **Generation Error** ได้
- วัด **Retrieval Quality** (Recall@K, Context Precision)
- วัด **Generation Quality** (Faithfulness, Hallucination Rate)
- เห็น **Latency ของแต่ละ Stage** (Embed, Retrieve, Rerank, Generate)
- Alert เมื่อ Quality ตกก่อน user ร้องเรียน

### เนื้อหา / รายละเอียด

#### RAG Pipeline — 6 Stages ที่ต้อง Trace

```
User Query
   │
   ▼
┌─────────────┐
│ Query Rewrite│  (optional)
└──────┬──────┘
       ▼
┌─────────────┐
│   Embed     │  Query → Vector
└──────┬──────┘
       ▼
┌─────────────┐
│  Retrieve   │  Vector DB Search (top_k)
└──────┬──────┘
       ▼
┌─────────────┐
│   Rerank    │  (optional) Cross-Encoder
└──────┬──────┘
       ▼
┌─────────────┐
│  Assemble   │  Build Prompt (chunks + instructions)
└──────┬──────┘
       ▼
┌─────────────┐
│  Generate   │  LLM Call
└──────┬──────┘
       ▼
    Answer
```

> **กฎสำคัญ:** ทุก Stage ต้องมี **Span แยก** — ถ้ารวมเป็น Span เดียวจะไม่รู้ว่าปัญหาอยู่ที่ Retrieval หรือ Generation

#### Metrics ที่ต้อง Monitor (4 ชั้น)

RAG Observability มี **4 Telemetry Layers**:

| Layer | เก็บอะไร | ตัวอย่าง |
|---|---|---|
| **1. Traces** | Per-call spans (Embed, Retrieve, Generate) | Trace ID, Span duration |
| **2. Metrics** | Aggregated counts/histograms | Latency P99, Token/request |
| **3. Eval Scores** | Online + Offline quality scores | Faithfulness, Recall@K |
| **4. Alerts** | แจ้งเตือนเมื่อ Regression | `RAGLowRecall`, `HallucinationSpike` |

#### Retrieval Metrics (สำคัญ)

| Metric | สูตร / ความหมาย | เป้า |
|---|---|---|
| **Recall@K** | สัดส่วน True Top-K ที่ดึงได้ | > 0.95 |
| **Context Precision** | สัดส่วน Chunk ที่ดึงมาเกี่ยวข้องจริง | > 0.8 |
| **Top Retrieval Score** | คะแนนความคล้ายคลึงสูงสุดต่อ Query | > 0.7 |
| **Context Tokens** | จำนวน Token ที่ใส่ใน Prompt | ตาม Budget |
| **Empty Result Rate** | สัดส่วน Query ที่ Retrieve ไม่ได้เลย | < 1% |

#### Generation Metrics (สำคัญ)

| Metric | ความหมาย | เป้า |
|---|---|---|
| **Faithfulness** | คำตอบสอดคล้องกับ Context | > 0.9 |
| **Hallucination Rate** | สัดส่วนคำตอบที่ไม่มีหลักฐาน | < 5% |
| **Answer Relevance** | คำตอบตรงคำถาม | > 0.85 |
| **TTFT (Time to First Token)** | เวลาจนถึง Token แรก | < 1s |
| **Generation Latency** | เวลาสร้างคำตอบทั้งหมด | < 5s |
| **Token Usage** | Input + Output Tokens | ตาม Budget |

#### Online Eval — Sampling 1–5%

> **กฎ:** ไม่สามารถ Eval ทุก Request ได้ (แพง + ช้า) — Sampling **1–5%** ของ Traffic จริงเพื่อวัด Faithfulness / Hallucination

```python
# ตัวอย่าง: Online Eval Sampling (Python)
import random
from opentelemetry import trace

def should_eval(request_id: str) -> bool:
    """Sample 2% of traffic for online eval"""
    return hash(request_id) % 100 < 2

def handle_query(query: str, request_id: str):
    trace_id = trace.get_current_span().get_span_context().trace_id
    
    # ... RAG pipeline ...
    answer = rag_pipeline(query)
    
    if should_eval(request_id):
        # Async eval (ไม่ block response)
        eval_score = llm_judge.evaluate(
            query=query,
            answer=answer,
            context=retrieved_chunks,
            trace_id=trace_id,
        )
        metrics.record_eval_score(eval_score)  # Prometheus Counter/Histogram
    
    return answer
```

### การติดตั้ง / การตั้งค่า

#### OpenTelemetry Instrumentation (Python)

```python
# pip install opentelemetry-api opentelemetry-sdk opentelemetry-exporter-otlp
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

provider = TracerProvider()
provider.add_span_processor(BatchSpanProcessor(OTLPSpanExporter(endpoint="http://otel-collector:4317")))
trace.set_tracer_provider(provider)
tracer = trace.get_tracer("rag-pipeline")

def rag_query(query: str):
    with tracer.start_as_current_span("rag.root") as root:
        # 1. Embed
        with tracer.start_as_current_span("rag.embed") as embed_span:
            query_vector = embed(query)
            embed_span.set_attribute("gen_ai.operation.name", "embeddings")
            embed_span.set_attribute("embedding.model", "text-embedding-3-small")
        
        # 2. Retrieve
        with tracer.start_as_current_span("rag.retrieve") as retrieve_span:
            chunks = vector_db.search(query_vector, top_k=5)
            retrieve_span.set_attribute("retrieval.top_k", 5)
            retrieve_span.set_attribute("retrieval.result_count", len(chunks))
            if chunks:
                retrieve_span.set_attribute("retrieval.top_score", chunks[0].score)
        
        # 3. Rerank (optional)
        with tracer.start_as_current_span("rag.rerank") as rerank_span:
            chunks = rerank(query, chunks)
            rerank_span.set_attribute("rerank.model", "cross-encoder")
        
        # 4. Assemble
        with tracer.start_as_current_span("rag.assemble") as assemble_span:
            prompt = build_prompt(query, chunks)
            assemble_span.set_attribute("context.token_count", count_tokens(prompt))
        
        # 5. Generate
        with tracer.start_as_current_span("rag.generate") as gen_span:
            answer = llm.generate(prompt)
            gen_span.set_attribute("gen_ai.operation.name", "chat")
            gen_span.set_attribute("gen_ai.usage.input_tokens", usage.input_tokens)
            gen_span.set_attribute("gen_ai.usage.output_tokens", usage.output_tokens)
        
        return answer
```

> **อ้างอิง:** OpenTelemetry มี **GenAI Semantic Conventions** สำหรับ RAG โดยเฉพาะ (อยู่ในสถานะ Development แต่ใช้ได้)

#### Prometheus Custom Metrics (RAG Quality)

```python
# metrics.py — Custom Prometheus metrics สำหรับ RAG
from prometheus_client import Counter, Histogram, Gauge

# ── Retrieval ─────────────────────────────────────────
rag_retrieval_latency = Histogram(
    "rag_retrieval_latency_seconds",
    "Time spent on vector search",
    ["collection", "top_k"],
    buckets=[0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5],
)

rag_retrieval_results = Histogram(
    "rag_retrieval_results_count",
    "Number of chunks returned",
    ["collection"],
    buckets=[0, 1, 2, 3, 5, 10, 20],
)

rag_retrieval_top_score = Histogram(
    "rag_retrieval_top_score",
    "Top similarity score per query",
    ["collection"],
    buckets=[0.1, 0.3, 0.5, 0.7, 0.8, 0.9, 1.0],
)

rag_empty_results_total = Counter(
    "rag_empty_results_total",
    "Queries that returned zero results",
    ["collection"],
)

# ── Generation ────────────────────────────────────────
rag_generation_latency = Histogram(
    "rag_generation_latency_seconds",
    "Time spent on LLM generation",
    ["model"],
    buckets=[0.5, 1, 2, 5, 10, 20, 30],
)

rag_ttft_seconds = Histogram(
    "rag_ttft_seconds",
    "Time to first token",
    ["model"],
    buckets=[0.1, 0.25, 0.5, 1, 2, 5],
)

rag_tokens_total = Counter(
    "rag_tokens_total",
    "Total tokens used",
    ["model", "type"],  # type = input | output
)

# ── Quality (Online Eval) ─────────────────────────────
rag_faithfulness_score = Histogram(
    "rag_faithfulness_score",
    "Faithfulness score from LLM judge",
    ["model", "route"],
    buckets=[0.1, 0.3, 0.5, 0.7, 0.8, 0.9, 1.0],
)

rag_hallucination_total = Counter(
    "rag_hallucination_total",
    "Answers with hallucination detected",
    ["model", "route"],
)

rag_recall_at_k = Gauge(
    "rag_recall_at_k",
    "Recall@K from offline eval",
    ["collection", "k"],
)
```

#### Alert Rules — RAG

```yaml
# rules/rag-alerts.yml
groups:
  - name: rag-observability
    interval: 30s
    rules:

      # ═══════════════════════════════════════════
      # 1) Retrieval Latency สูง
      # ═══════════════════════════════════════════
      - alert: RAGRetrievalLatencyHigh
        expr: |
          histogram_quantile(0.95,
            sum by (le, collection) (rate(rag_retrieval_latency_seconds_bucket[5m]))
          ) > 0.2
        for: 10m
        labels:
          severity: warning
          team: ai-platform
        annotations:
          summary: "RAG retrieval P95 > 200ms on {{ $labels.collection }}"
          description: "Vector search ช้า — ตรวจ Vector DB (indexed ratio, memory)"
          runbook_url: "https://wiki.example.com/runbook/rag-retrieval-latency"

      # ═══════════════════════════════════════════
      # 2) Empty Results (Retrieve ไม่ได้เลย)
      # ═══════════════════════════════════════════
      - alert: RAGEmptyResultsHigh
        expr: |
          rate(rag_empty_results_total[10m])
            / rate(rag_retrieval_latency_seconds_count[10m])
            > 0.05
        for: 10m
        labels:
          severity: warning
          team: ai-platform
        annotations:
          summary: "{{ $value | humanizePercentage }} queries returned empty results"
          description: "Retrieval ล้มเหลว — ตรวจ collection, embedding model, index"

      # ═══════════════════════════════════════════
      # 3) Top Score ต่ำ (Retrieve ได้แต่ไม่เกี่ยวข้อง)
      # ═══════════════════════════════════════════
      - alert: RAGLowRetrievalScore
        expr: |
          histogram_quantile(0.50,
            sum by (le, collection) (rate(rag_retrieval_top_score_bucket[15m]))
          ) < 0.6
        for: 20m
        labels:
          severity: warning
          team: ai-platform
        annotations:
          summary: "Median top retrieval score < 0.6 on {{ $labels.collection }}"
          description: "Chunk ที่ดึงมาไม่เกี่ยวข้อง — ตรวจ chunking, embedding model, index freshness"

      # ═══════════════════════════════════════════
      # 4) Hallucination Rate สูง (สำคัญสุด)
      # ═══════════════════════════════════════════
      - alert: RAGHighHallucinationRate
        expr: |
          rate(rag_hallucination_total[30m])
            / rate(rag_faithfulness_score_count[30m])
            > 0.05
        for: 30m
        labels:
          severity: critical
          team: ai-platform
        annotations:
          summary: "Hallucination rate > 5% on {{ $labels.route }}"
          description: "LLM สร้างคำตอบนอก Context — ตรวจ retrieval quality + prompt"
          runbook_url: "https://wiki.example.com/runbook/rag-hallucination"

      # ═══════════════════════════════════════════
      # 5) Faithfulness ตก
      # ═══════════════════════════════════════════
      - alert: RAGLowFaithfulness
        expr: |
          histogram_quantile(0.50,
            sum by (le, route) (rate(rag_faithfulness_score_bucket[30m]))
          ) < 0.85
        for: 30m
        labels:
          severity: warning
          team: ai-platform
        annotations:
          summary: "Median faithfulness < 0.85 on {{ $labels.route }}"
          description: "คำตอบไม่สอดคล้องกับ Context — ตรวจ prompt, context length"

      # ═══════════════════════════════════════════
      # 6) Generation Latency สูง
      # ═══════════════════════════════════════════
      - alert: RAGGenerationLatencyHigh
        expr: |
          histogram_quantile(0.95,
            sum by (le, model) (rate(rag_generation_latency_seconds_bucket[5m]))
          ) > 10
        for: 10m
        labels:
          severity: warning
          team: ai-platform
        annotations:
          summary: "RAG generation P95 > 10s on {{ $labels.model }}"
          description: "LLM ช้า — ตรวจ provider, rate limit, token count"

      # ═══════════════════════════════════════════
      # 7) Recall@K ตก (จาก Offline Eval)
      # ═══════════════════════════════════════════
      - alert: RAGLowRecall
        expr: rag_recall_at_k < 0.9
        for: 1h
        labels:
          severity: warning
          team: ai-platform
        annotations:
          summary: "Recall@{{ $labels.k }} = {{ $value }} (< 0.9)"
          description: "Retrieval quality ตก — ตรวจ embedding drift, index เก่า, chunking"
```

#### PromQL — RAG ครบชุด

```promql
# ── Retrieval ─────────────────────────────────────────
# Retrieval P95 latency
histogram_quantile(0.95,
  sum by (le, collection) (rate(rag_retrieval_latency_seconds_bucket[5m]))
)

# Empty result rate
rate(rag_empty_results_total[10m]) / rate(rag_retrieval_latency_seconds_count[10m])

# Top score (median)
histogram_quantile(0.50,
  sum by (le, collection) (rate(rag_retrieval_top_score_bucket[15m]))
)

# ── Generation ────────────────────────────────────────
# Generation P95 latency
histogram_quantile(0.95,
  sum by (le, model) (rate(rag_generation_latency_seconds_bucket[5m]))
)

# TTFT P95
histogram_quantile(0.95,
  sum by (le, model) (rate(rag_ttft_seconds_bucket[5m]))
)

# Token usage rate
rate(rag_tokens_total[5m])

# ── Quality ───────────────────────────────────────────
# Faithfulness (median)
histogram_quantile(0.50,
  sum by (le, route) (rate(rag_faithfulness_score_bucket[30m]))
)

# Hallucination rate
rate(rag_hallucination_total[30m]) / rate(rag_faithfulness_score_count[30m])

# Recall@K
rag_recall_at_k
```

#### Dashboard JSON — RAG Quality Overview

```json
{
  "title": "RAG Quality Overview",
  "uid": "rag-quality-v1",
  "tags": ["rag", "ai"],
  "templating": {
    "list": [
      {
        "name": "route",
        "type": "query",
        "datasource": {"type": "prometheus", "uid": "prometheus"},
        "query": "label_values(rag_generation_latency_seconds_count, route)",
        "refresh": 1,
        "multi": true,
        "includeAll": true
      }
    ]
  },
  "panels": [
    {
      "id": 1, "type": "stat", "title": "Faithfulness (Median)",
      "gridPos": {"h": 5, "w": 6, "x": 0, "y": 0},
      "targets": [{
        "expr": "histogram_quantile(0.50, sum by (le) (rate(rag_faithfulness_score_bucket{route=~\"$route\"}[30m])))"
      }],
      "fieldConfig": {"defaults": {
        "unit": "percentunit",
        "min": 0, "max": 1,
        "thresholds": {"steps": [
          {"color": "red", "value": null},
          {"color": "yellow", "value": 0.85},
          {"color": "green", "value": 0.9}
        ]}
      }}
    },
    {
      "id": 2, "type": "stat", "title": "Hallucination Rate",
      "gridPos": {"h": 5, "w": 6, "x": 6, "y": 0},
      "targets": [{
        "expr": "rate(rag_hallucination_total{route=~\"$route\"}[30m]) / rate(rag_faithfulness_score_count{route=~\"$route\"}[30m])"
      }],
      "fieldConfig": {"defaults": {
        "unit": "percent",
        "thresholds": {"steps": [
          {"color": "green", "value": null},
          {"color": "yellow", "value": 5},
          {"color": "red", "value": 10}
        ]}
      }}
    },
    {
      "id": 3, "type": "stat", "title": "Retrieval P95",
      "gridPos": {"h": 5, "w": 6, "x": 12, "y": 0},
      "targets": [{
        "expr": "histogram_quantile(0.95, sum by (le) (rate(rag_retrieval_latency_seconds_bucket[5m])))"
      }],
      "fieldConfig": {"defaults": {"unit": "s"}}
    },
    {
      "id": 4, "type": "stat", "title": "Generation P95",
      "gridPos": {"h": 5, "w": 6, "x": 18, "y": 0},
      "targets": [{
        "expr": "histogram_quantile(0.95, sum by (le) (rate(rag_generation_latency_seconds_bucket[5m])))"
      }],
      "fieldConfig": {"defaults": {"unit": "s"}}
    },
    {
      "id": 10, "type": "timeseries", "title": "Faithfulness Trend",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 5},
      "targets": [
        {"expr": "histogram_quantile(0.50, sum by (le) (rate(rag_faithfulness_score_bucket{route=~\"$route\"}[1h])))", "legendFormat": "P50"},
        {"expr": "histogram_quantile(0.10, sum by (le) (rate(rag_faithfulness_score_bucket{route=~\"$route\"}[1h])))", "legendFormat": "P10"}
      ],
      "fieldConfig": {"defaults": {"unit": "percentunit", "min": 0, "max": 1}}
    },
    {
      "id": 11, "type": "timeseries", "title": "Retrieval Score Distribution",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 5},
      "targets": [
        {"expr": "histogram_quantile(0.50, sum by (le) (rate(rag_retrieval_top_score_bucket[15m])))", "legendFormat": "P50 Top Score"},
        {"expr": "histogram_quantile(0.10, sum by (le) (rate(rag_retrieval_top_score_bucket[15m])))", "legendFormat": "P10 Top Score"}
      ],
      "fieldConfig": {"defaults": {"unit": "short", "min": 0, "max": 1}}
    },
    {
      "id": 12, "type": "timeseries", "title": "Stage Latency Breakdown (P95)",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 13},
      "targets": [
        {"expr": "histogram_quantile(0.95, sum by (le) (rate(rag_retrieval_latency_seconds_bucket[5m])))", "legendFormat": "Retrieval"},
        {"expr": "histogram_quantile(0.95, sum by (le) (rate(rag_generation_latency_seconds_bucket[5m])))", "legendFormat": "Generation"},
        {"expr": "histogram_quantile(0.95, sum by (le) (rate(rag_ttft_seconds_bucket[5m])))", "legendFormat": "TTFT"}
      ],
      "fieldConfig": {"defaults": {"unit": "s"}}
    },
    {
      "id": 13, "type": "timeseries", "title": "Empty Results Rate",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 13},
      "targets": [{
        "expr": "rate(rag_empty_results_total[10m]) / rate(rag_retrieval_latency_seconds_count[10m])",
        "legendFormat": "Empty Rate"
      }],
      "fieldConfig": {"defaults": {"unit": "percent"}}
    }
  ],
  "time": {"from": "now-6h", "to": "now"},
  "refresh": "30s"
}
```

### การวิเคราะห์และแนวทางแก้ไข

| อาการ | สาเหตุที่เป็นไปได้ | แนวทางแก้ไข |
|---|---|---|
| Hallucination สูง | Retrieval ดึง chunk ผิด, prompt ไม่ดี, context ยาวเกิน | ตรวจ Recall/Top Score, ปรับ prompt, ลด context |
| Faithfulness ตก | LLM ไม่สนใจ context, context มี noise | เพิ่ม Reranker, ลด chunk size, ปรับ prompt |
| Empty Results สูง | Index ว่าง, embedding model ไม่ตรง, collection ผิด | ตรวจ collection, re-index, ตรวจ embedding model |
| Top Score ต่ำ | Chunking ผิด, embedding drift, index เก่า | ปรับ chunk size, re-index, อัปเดต embedding model |
| Retrieval Latency สูง | Vector DB ช้า (indexed ratio, memory) | ตรวจ Vector DB (หัวข้อ 3.14) |
| Generation Latency สูง | LLM provider ช้า, token เยอะ | ลด context, เปลี่ยน model, ตรวจ rate limit |
| Recall@K ตก | Index เก่า, embedding drift, ข้อมูลใหม่ | Re-index, ตรวจ embedding version, อัปเดต golden set |

### ลำดับการจัดการปัญหา (Hallucination สูง)

1. **ยืนยัน Hallucination Rate** — Grafana panel / `rate(rag_hallucination_total[30m]) / rate(...)`
2. **ตรวจ Retrieval Quality** — `rag_recall_at_k`, `rag_retrieval_top_score` — ตก?
3. **ตรวจ Empty Results** — `rate(rag_empty_results_total[10m])` — สูง?
4. **ตรวจ Context Size** — `rag_context_tokens` — ยาวเกิน?
5. **ตรวจ Embedding Version** — ตรงกับ Index?
6. **ตรวจ Prompt Version** — มีการเปลี่ยน prompt ล่าสุด?
7. **แก้:**
   - Retrieval ตก → Re-index, ปรับ chunking
   - Context ยาว → ลด top_k / chunk size
   - Prompt ผิด → Rollback prompt version
   - LLM model เปลี่ยน → Pin model version

### Template Code
→ ดู OpenTelemetry Instrumentation, Custom Metrics, Alert Rules ด้านบน

### Template Dashboard
→ ดู RAG Quality Overview JSON ด้านบน

### สรุปย่อ / ประโยชน์ / ข้อควรระวัง / ข้อดี / ข้อเสีย / ข้อห้าม

- **ประโยชน์:** เห็น Quality ก่อน user บ่น, แยก Retrieval vs Generation Error ได้
- **ข้อควรระวัง:** **Online Eval แพง** — Sampling 1–5% พอ
- **ข้อดี:** Trace ช่วย Debug ได้ถึง Span ที่ผิด, Metrics เห็น Trend
- **ข้อเสีย:** ต้องมี LLM Judge (เพิ่ม cost), Eval ช้า (async)
- **ข้อห้าม:**
  - ❌ Eval ทุก Request (แพงเกินไป)
  - ❌ ใช้ Average แทน Percentile สำหรับ Latency
  - ❌ Pin model version ไม่ครบ (embedding, LLM, judge)
  - ❌ Ignore Empty Results — มักเป็นสาเหตุแรกของ Hallucination
  - ❌ ใช้ Golden Set เก่าโดยไม่อัปเดต — จะไม่จับ drift

### ตัวอย่าง (LLM-as-a-Judge สำหรับ Faithfulness)

```python
# ใช้ LLM ตัวเล็ก (เช่น claude-haiku) เป็น Judge
JUDGE_PROMPT = """
You are an evaluation judge. Given:
- Query: {query}
- Retrieved Context: {context}
- Answer: {answer}

Score the answer on Faithfulness (0-1):
- 1.0 = every claim in answer is supported by context
- 0.0 = answer contains claims not in context

Return only JSON: {"faithfulness": <float>, "hallucinated_claims": [<list>]}
"""

def judge_faithfulness(query, context, answer):
    response = judge_llm.generate(
        JUDGE_PROMPT.format(query=query, context=context, answer=answer),
        response_format={"type": "json_object"},
    )
    return json.loads(response)
```

### สรุปย่อเพื่อจดจำ
> **RAG Observability** — 4 Layers: Trace + Metric + Eval + Alert — แยก Span ทุก Stage — Online Eval 1–5% — Metrics: Recall@K, Top Score, Faithfulness, Hallucination Rate — Alert `RAGLowRecall`, `RAGHighHallucinationRate`

### แหล่งที่มา
- Respan, "RAG Observability: Spans, Metrics, and the 5 Dashboards" (2026)
- Last9, "RAG Pipeline Observability" (2026)
- Dataiku, "RAG observability: how to monitor retrieval quality" (2026)
- spancheck, "Hallucination rate measurement" (2026)
- OpenTelemetry GenAI Semantic Conventions

---

## Workflow (อ้างอิงเล่ม 1 + Incident Playbook เฉพาะเล่ม)

### อ้างอิง Workflow หลักจากเล่ม 1

| Workflow | ใช้ในเล่มนี้เมื่อ |
|---|---|
| **PSR** | เขียนรายงานหลัง Incident ที่เกี่ยวกับ RAG/Vector DB |
| **RCA 5 Whys** | หา Root Cause ของ Hallucination / Recall ตก |
| **KPI SMART** | ตั้ง KPI ของ RAG (เช่น Faithfulness > 0.9, Recall@10 > 0.95) |

→ Template เต็มอยู่ใน **เล่ม 1 หัวข้อ 4**

### Incident Playbook เฉพาะเล่ม 6

#### Playbook A: Hallucination Rate พุ่งสูง

1. **ยืนยัน Rate** — Grafana `RAGHighHallucinationRate` fire?
2. **ตรวจ Retrieval** — `rag_recall_at_k` และ `rag_retrieval_top_score` ตกพร้อมกัน?
3. **ตรวจ Empty Results** — `rag_empty_results_total` สูง?
4. **ตรวจ Context Tokens** — `rag_context_tokens` เปลี่ยน?
5. **ตรวจ Prompt Version** — มีการ deploy prompt ใหม่?
6. **ตรวจ LLM Model Version** — มีการอัปเดต model?
7. **ตรวจ Embedding Model** — ตรงกับ Index?
8. **แก้:**
   - Retrieval ตก → Re-index / rollback embedding
   - Prompt ผิด → Rollback prompt
   - Model เปลี่ยน → Pin model version

#### Playbook B: RetrievalLatencyHigh

1. **ยืนยัน Latency** — `RAGRetrievalLatencyHigh` fire
2. **ตรวจ Vector DB** — ใช้ Playbook Vector DB (หัวข้อ 3.14)
3. **ตรวจ Indexed Ratio** — < 1.0?
4. **ตรวจ Search Rate** — spike?
5. **แก้:**
   - Indexed ratio ต่ำ → รอ optimizer
   - Search rate สูง → scale Vector DB
   - Memory สูง → เพิ่ม RAM

#### Playbook C: RAGLowRecall (Retrieval Quality ตก)

1. **ยืนยัน Recall** — `rag_recall_at_k < 0.9`
2. **ตรวจ Top Score** — `rag_retrieval_top_score` ต่ำ?
3. **ตรวจ Empty Results** — สูง?
4. **ตรวจ Index Age** — Index เก่ากี่วัน?
5. **ตรวจ Embedding Model Version** — เปลี่ยน?
6. **ตรวจ Document Freshness** — มีเอกสารใหม่ที่ยังไม่ index?
7. **แก้:**
   - Re-index (ด้วย embedding model เดียวกัน)
   - อัปเดต golden set
   - ปรับ chunking strategy

#### Playbook D: Empty Results สูง

1. **ยืนยัน Rate** — `rate(rag_empty_results_total[10m]) / rate(...)` > 5%
2. **ตรวจ Collection** — มี Vector อยู่?
3. **ตรวจ Embedding** — embed query ได้Vector ไหม?
4. **ตรวจ top_k** — ตั้งต่ำเกินไป?
5. **ตรวจ Indexed Ratio** — < 1.0?
6. **แก้:**
   - Collection ว่าง → re-index
   - top_k ต่ำ → เพิ่ม
   - Embedding ผิด → ตรวจ model version

---

## สรุป (ประโยชน์, ข้อดี, ข้อเสีย, ข้อห้าม)

### ประโยชน์ของเล่ม 6

- **End-to-End RAG Visibility:** เห็นทั้ง Vector DB และ Pipeline Quality
- **แยกแยะ Root Cause:** รู้ว่าปัญหาอยู่ที่ Retrieval หรือ Generation
- **Quality-First Monitoring:** วัด Faithfulness / Hallucination ไม่ใช่แค่ Latency
- **Runbook พร้อม:** 4 Playbook สำหรับ Incident ที่พบบ่อย
- **Integration:** ใช้ Prometheus/Grafana/Alertmanager จากเล่ม 3

### ข้อดี

| ด้าน | ผลลัพธ์ |
|---|---|
| **MTTD** | เห็น Quality ตกก่อน user บ่น |
| **MTTR** | Trace ช่วยชี้จุดผิดได้ทันที |
| **Cost Control** | เห็น Token usage / Empty results |
| **Standardization** | ใช้ Metrics Platform เดียวกับเล่ม 3–5 |
| **Compliance** | Audit log จาก eval (spancheck) |

### ข้อเสีย / ข้อจำกัด

- **Online Eval แพง** — ต้องใช้ LLM Judge (Sampling 1–5%)
- **Trace Volume สูง** — ต้องมี Sampling สำหรับ Trace เช่นกัน
- **Vector DB ต่างกัน** — Exporter ต่างกัน (Qdrant, Milvus, Weaviate)
- **LLM-as-a-Judge ต้อง Calibrate** — กับ human labels ก่อนเชื่อถือ
- **Prompt/Model Versioning** — ต้อง Pin ทุกอย่าง ไม่งั้น Debug ไม่ได้

### ข้อห้าม (สรุป)

1. ❌ **ห้าม Eval ทุก Request** — Sampling 1–5% พอ
2. ❌ **ห้าม Monitor แค่ Latency** — ต้อง Monitor Quality (Recall, Faithfulness) ด้วย
3. ❌ **ห้ามรวม Retrieval + Generation เป็น Span เดียว** — แยกทุก Stage
4. ❌ **ห้ามใช้ Average สำหรับ Latency** — ใช้ P95/P99
5. ❌ **ห้าม Pin Model Version ไม่ครบ** — Embedding, LLM, Judge ต้อง Pin
6. ❌ **ห้าม Ignore Empty Results** — มักเป็นสาเหตุแรกของ Hallucination
7. ❌ **ห้ามใช้ Golden Set เก่า** — อัปเดตทุก Quarter
8. ❌ **ห้ามใช้ `top_k` สูงเกิน** — เพิ่ม Latency + Token cost
9. ❌ **ห้ามใช้ Vector DB โดยไม่ Monitor Indexed Ratio** — Search จะช้าโดยไม่รู้ตัว
10. ❌ **ห้าม Deploy RAG โดยไม่มี Online Eval** — จะไม่จับ Drift

---

## เส้นทางอ่านต่อ

| ถ้าคุณเป็น | อ่านต่อ |
|---|---|
| AI Engineer | → อ่านจบเส้นทาง E (เล่ม 1→4→5→6) แล้ว |
| AI Support | → ฝึก Kibana (เล่ม 4) + PromQL (เล่ม 3) เพิ่ม |
| Monitoring Engineer | → **เล่ม 7** (CRM Support) |
| ERP Developer | → **เล่ม 8** (DDD) → **เล่ม 9** (DB) → **เล่ม 10** (Integration) |

---

> **เวอร์ชันเอกสาร:** 1.0
> **ผู้รับผิดชอบ:** AI Platform Team + SRE Team
> **ปรับปรุงล่าสุด:** ตามรอบ Quarter
> **สถานะ:** ✅ Ready for Review

--- 