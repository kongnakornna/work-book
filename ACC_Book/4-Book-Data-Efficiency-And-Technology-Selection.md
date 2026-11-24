# เล่ม 4: สถาปัตยกรรมข้อมูลและการออกแบบระบบ (Data Architecture & System Design)

## บทนำ

### คืออะไร
คู่มือเล่มนี้ว่าด้วย **ชั้นสถาปัตยกรรมข้อมูล** ที่รองรับระบบธุรกรรมทางการเงิน-บัญชี (เล่ม 1) และกลไกความน่าเชื่อถือ (เล่ม 2) ให้ทำงานได้อย่างมีประสิทธิภาพและตรวจสอบได้ (เล่ม 3) ครอบคลุมการเลือกรูปแบบข้อมูล (JSON vs Protocol Buffers), การออกแบบ API ที่ปลอดภัยจากการเรียกซ้ำ (Idempotency), การทำ Index เพื่อประสิทธิภาพการquery, การวิเคราะห์ประสิทธิภาพอัลกอริทึมด้วย Big O และการกำหนดตัวชี้วัดความสำเร็จ (KPI/SMART)

### คำนำ
ระบบที่ "ถูกต้อง" และ "ตรวจสอบได้" ยังคงล้มเหลวในทางปฏิบัติได้ หาก **ช้าเกินไป แพงเกินไป หรือขยายไม่ได้** เล่ม 3 ทำให้เราพิสูจน์ได้ว่าเกิดอะไรขึ้น แต่เล่ม 4 ตอบคำถามว่า *จะทำให้สิ่งนั้นเกิดขึ้นได้เร็วและคุ้มค่าได้อย่างไร* โดยไม่แลกด้วยความถูกต้องหรือความสามารถในการตรวจสอบ

### วัตถุประสงค์
1. อธิบายเกณฑ์การเลือกระหว่าง JSON และ Protocol Buffers ตามบริบทการใช้งาน
2. อธิบาย Idempotency ในบริบท RESTful API และการ implement ด้วย Python (ต่อยอดจากเล่ม 2)
3. อธิบายข้อดี/ข้อจำกัดของ Database Indexing และผลต่อ Big O
4. อธิบาย Big O Notation พร้อมตัวอย่าง Python
5. อธิบายการกำหนด KPI ด้วยหลัก SMART สำหรับวัดคุณภาพของสถาปัตยกรรม/บทนิยาม

### เป้าหมาย
ผู้อ่านสามารถ **เลือกเครื่องมือและออกแบบสถาปัตยกรรมข้อมูล** ที่สมดุลระหว่าง performance, ต้นทุน, ความถูกต้อง และความสามารถในการตรวจสอบ พร้อมกำหนดตัวชี้วัดที่วัดผลได้จริง

### ความรู้พื้นฐาน
- พื้นฐานฐานข้อมูลและ index (เล่ม 2)
- พื้นฐาน transaction และ constraint (เล่ม 2)
- แนวคิด audit และ traceability (เล่ม 3)
- พื้นฐานการเขียนโปรแกรม Python

---

## บทนิยาม

### 1. JSON vs Protocol Buffers

**คืออะไร:** สองรูปแบบการแลกเปลี่ยนข้อมูล (data serialization) ที่ใช้กันแพร่หลาย — JSON เป็น text format ที่มนุษย์อ่านได้, Protobuf เป็น binary format ที่มี schema บังคับ

**ทำไมต้องเปรียบเทียบ:** เพราะการเลือกรูปแบบข้อมูลมีผลโดยตรงต่อ **ขนาด, ความเร็ว, ความเข้มงวดของ schema และความเข้ากันได้กับสภาพแวดล้อม** (browser, mobile, microservice)

**ตารางเปรียบเทียบ:**

| รูปแบบ | Text (UTF-8) อ่านด้วยตาได้ | Binary อ่านด้วยตาไม่ได้ |
|---|---|---|
| **Schema** | ไม่บังคับ (เสริมด้วย JSON Schema / OpenAPI) | บังคับ ประกาศใน `.proto` |
| **Type** | string, number, boolean, null, array, object | int32/int64, float/double, bool, string, bytes, enum, message, repeated, map, oneof |
| **ขนาด** | ใหญ่ (ชื่อ field ซ้ำทุก record) | เล็กกว่าราว 3–10 เท่า (field number + varint) |
| **ความเร็ว** | parse text ช้ากว่า | decode binary เร็วกว่า |
| **Code generation** | ไม่ต้อง | ต้องใช้ `protoc` |
| **Browser** | native (`JSON.parse`) | ต้องใช้ library / gRPC-Web |
| **ใช้กับ** | REST, public API, frontend ↔ backend, config | gRPC, microservice ภายใน, mobile/IoT, event streaming |

**เพื่ออะไร / ประโยชน์:**
- **JSON:** เหมาะกับ public API, การ debug, config, การ integrate กับ browser โดยตรง — ต้นทุนต่ำในการเริ่มต้น
- **Protobuf:** เหมาะกับ internal microservice, mobile/IoT ที่ bandwidth จำกัด, event streaming ที่ต้องการ throughput สูง — ประหยัดขนาด 3–10 เท่าและ decode เร็วกว่า

**กลุ่มเป้าหมาย:** สถาปนิกระบบ, นักพัฒน backend/frontend, ทีม platform, ทีม mobile

**Insight:** การเลือกไม่ใช่ "อันไหนดีกว่า" แต่คือ **"ขอบเขตความเข้มงวดของ schema และสภาพแวดล้อมการใช้งาน"** — ถ้า schema เปลี่ยนบ่อยและต้อง debug ง่าย → JSON; ถ้า schema มั่นคงและ performance สำคัญ → Protobuf

---

### 2. Idempotency (ในบริบท RESTful API)

**คืออะไร:** คุณสมบัติที่การเรียกใช้งานเดียวกันซ้ำหลายครั้งให้ผลลัพธ์เหมือนกับการเรียกครั้งเดียว ในระบบ distributed การรับประกัน "exactly-once" เป็นเรื่องยาก แต่สามารถบรรลุ "effectively exactly-once" ได้ด้วย **idempotency token**

**ความหมายเชิงลึก (ต่อยอดจากเล่ม 2):**
- **คืออะไร:** การที่ `POST /payments` ด้วย `Idempotency-Key` เดียวกัน 100 ครั้ง ต้องตัดเงินเพียงครั้งเดียว และคืน response เดิมทุกครั้ง
- **ทำไมไม่เป็นแบบนี้ (ถ้าไม่มี idempotency):** network error ระหว่างทางทำให้ client ไม่รู้ว่าสำเร็จหรือไม่ → retry → เกิดรายการซ้ำ → เงินหาย/รายงานผิด
- **เพื่ออะไร:** ทำให้ client retry ได้อย่างปลอดภัย โดยไม่ต้อง implement logic ฝั่ง client ที่ซับซ้อน

**หลักการ implement:**
1. ระบุ operation ที่ต้องมี idempotency: `POST` ที่สร้าง resource, `PUT`, `DELETE`
2. Client สร้าง `Idempotency-Key` (UUID) ต่อ "logical operation" หนึ่งครั้ง ส่งใน header ทุกครั้งที่ retry
3. Server เก็บ key + response แรกไว้; เมื่อได้ key ซ้ำ คืน response เดิมโดยไม่ประมวลผลซ้ำ
4. ใช้ database `UNIQUE` constraint บน key + ทำ check-and-act ใน transaction เดียวกัน เพื่อกัน race condition

**กลุ่มเป้าหมาย:** นักพัฒนา API, ทีม payment, ทีม integration

---

### 3. Database Indexing

**คืออะไร:** โครงสร้างข้อมูลเสริม (ส่วนใหญ่เป็น B-Tree/B+Tree, หรือ Hash, GIN, GiST, BRIN) ที่เก็บค่าคอลัมน์แบบเรียงลำดับพร้อม pointer ไปยังแถวจริง — เหมือนสารบัญท้ายหนังสือ

**ทำไมต้องเป็นแบบนี้:** การค้นหาแบบ full scan มีความซับซ้อน O(n) — เมื่อข้อมูลโตขึ้น เวลาก็โตตามเชิงเส้น Index ลดความซับซ้อนการค้นหาเหลือ O(log n) ทำให้ query เร็วขึ้นมากในตารางใหญ่

**เพื่ออะไร / ประโยชน์:**
- เร่ง `WHERE`, `JOIN`, `ORDER BY`, `GROUP BY` บนคอลัมน์ที่ index
- บังคับ `UNIQUE` constraint ได้
- รองรับ full-text search (GIN), geospatial (GiST), time-series (BRIN)

**ข้อจำกัด:**
- **พื้นที่เพิ่ม:** index กิน disk และ memory
- **ช้าลงตอนเขียน:** ทุก `INSERT/UPDATE/DELETE` ต้องอัปเดต index ด้วย
- **ไม่ช่วย query ที่ไม่ใช้คอลัมน์นำ:** composite index ต้องใช้คอลัมน์ซ้ายสุดก่อน
- **อาจไม่ถูกใช้:** optimizer อาจเลือก full scan หาก selectivity ต่ำ
- **bloat:** ต้องมี maintenance (REINDEX/VACUUM)

**กลุ่มเป้าหมาย:** DBA, นักพัฒนา backend, สถาปนิกข้อมูล

**Insight:** Index เป็น **trade-off ระหว่าง read กับ write** — ตารางที่เขียนหนัก (event log, audit log) ควรมี index น้อยและเลือกเฉพาะที่จำเป็น

---

### 4. Big O Notation

**คืออะไร:** สัญกรณ์ที่ใช้บอก **อัตราการเติบโตของเวลาหรือหน่วยความจำ** ที่อัลกอริทึมใช้ เมื่อขนาดข้อมูล (n) เพิ่มขึ้น โดยเน้นกรณีแย่ที่สุด (Worst Case)

**ทำไมต้องเป็นแบบนี้:** เพราะการวัดเวลาเป็นวินาทีขึ้นกับ hardware แต่ Big O บอก **แนวโน้มการเติบโต** ที่เป็นอิสระจากเครื่อง ทำให้เปรียบเทียบอัลกอริทึมได้

**ตารางความซับซ้อนที่พบบ่อย:**

| Big O | ชื่อ | ตัวอย่าง |
|---|---|---|
| O(1) | Constant | Hash lookup, array index |
| O(log n) | Logarithmic | B-Tree index lookup, binary search |
| O(n) | Linear | Full table scan, linear search |
| O(n log n) | Linearithmic | Merge sort, sort + index build |
| O(n²) | Quadratic | Nested loop join (ไม่มี index) |
| O(2ⁿ) | Exponential | Brute-force subset |

**เพื่ออะไร / ประโยชน์:**
- เลือกอัลกอริทึม/โครงสร้างข้อมูลให้เหมาะกับขนาดข้อมูล
- ทำนายว่า query จะช้าลงแค่ไหนเมื่อข้อมูลโต 10 เท่า
- อธิบายให้ผู้บริหารเข้าใจว่าทำไมต้องเพิ่ม index หรือเปลี่ยนสถาปัตยกรรม

**กลุ่มเป้าหมาย:** นักพัฒนา, DBA, สถาปนิก

**Insight:** การทำ index เปลี่ยนความซับซ้อนจาก O(n) → O(log n) — นี่คือ **เหตุผลเชิงทฤษฎี** ที่อยู่เบื้องหลังข้อ 3

---

### 5. KPI และ SMART Criteria

**KPI (Key Performance Indicator)** คือตัวชี้วัดผลงานหลักที่ใช้วัดความสำเร็จของเป้าหมาย

**คืออะไร:** ตัวชี้วัดที่บอกว่าเราบรรลุเป้าหมายหรือไม่ มากน้อยเพียงใด

**วัตถุประสงค์:** ทำให้เป้าหมายไม่เป็นแค่ความปรารถนาลอยๆ แต่เป็นสิ่งที่วัดได้ ติดตามได้ และปรับปรุงได้

**เป้าหมายสูงสุด:** ทำให้ทุกคนในองค์กรเห็นภาพเดียวกันว่าอะไรคือ "สำเร็จ" และตัดสินใจบนข้อมูลจริง

**SMART Criteria:**

| ตัวอักษร | ความหมาย | ตัวอย่าง |
|---|---|---|
| **S — Specific** | ชัดเจน เฉพาะเจาะจง | "ลด p95 latency ของ payment API" |
| **M — Measurable** | วัดเป็นตัวเลขได้ | "จาก 800ms เหลือ 200ms" |
| **A — Achievable** | ท้าทายแต่ทำได้จริง | "ภายใน 3 เดือน ด้วยการเพิ่ม index" |
| **R — Relevant** | สอดคล้องกับเป้าหมายใหญ่ | "สอดคล้องกับเป้าหมายลดต้นทุนระบบ" |
| **T — Time-bound** | มีกรอบเวลาชัดเจน | "ภายใน Q2/2027" |

**กลุ่มเป้าหมาย:** ผู้บริหาร, หัวหน้าทีม, ทีม product

---

## หลักการทำงาน (Concept)

### สถาปัตยกรรมข้อมูล 4 ชั้น

```
┌──────────────────────────────────────────────────────────────┐
│  ชั้นที่ 1: Presentation / API Layer                             │
│  - เลือก JSON (public, browser) vs Protobuf (internal, gRPC)   │
│  - Idempotency-Key สำหรับ operation ที่มี side effect            │
└─────────────────────┬────────────────────────────────────────┘
                      ▼
┌──────────────────────────────────────────────────────────────┐
│  ชั้นที่ 2: Application / Business Logic                         │
│  - ตรวจสอบ schema (JSON Schema / protoc)                      │
│  - Retry loop สำหรับ deadlock/serialization failure (เล่ม 2)    │
│  - เรียก audit log (เล่ม 3)                                     │
└─────────────────────┬────────────────────────────────────────┘
                      ▼
┌──────────────────────────────────────────────────────────────┐
│  ชั้นที่ 3: Data Access Layer                                    │
│  - Database Indexing (B-Tree, GIN, BRIN)                     │
│  - Query ที่ความซับซ้อน O(log n) แทน O(n)                        │
│  - UNIQUE constraint บน idempotency key                      │
└─────────────────────┬────────────────────────────────────────┘
                      ▼
┌──────────────────────────────────────────────────────────────┐
│  ชั้นที่ 4: Storage & Observability                              │
│  - WAL/fsync (เล่ม 2) + append-only audit store (เล่ม 3)        │
│  - Metrics: latency, throughput, error rate                  │
│  - KPI/SMART ติดตามผล                                         │
└──────────────────────────────────────────────────────────────┘
```

### หลักการสำคัญ 3 ข้อ

**1. เลือกรูปแบบข้อมูลตามขอบเขต ไม่ใช่ตามกระแส**
Public API → JSON (อ่านง่าย, debug ง่าย); Internal microservice → Protobuf (เล็ก, เร็ว) การผสมกัน (JSON ที่ edge, Protobuf ภายใน) เป็นเรื่องปกติ

**2. ทำให้ operation ที่มี side effect เป็น idempotent**
ทุก endpoint ที่ตัดเงิน/สร้างรายการต้องมี `Idempotency-Key` + UNIQUE constraint — เพราะ network error เป็นเรื่องปกติ ไม่ใช่ข้อยกเว้น

**3. วัดผลด้วย Big O ก่อน แล้วจึงวัดด้วยวินาที**
ก่อน optimize ให้ถามว่าความซับซ้อนคืออะไร — ถ้าเป็น O(n²) การเพิ่ม hardware ไม่ช่วย แต่การเพิ่ม index (→ O(log n)) ช่วยได้มหาศาล

---

## Workflow และ Dataflow (แบบ PSR)

### Problem (ปัญหา)
ระบบการเงิน-บัญชีมีปัญหา 4 ด้านพร้อมกัน:
- **ช้า:** query รายงานใช้เวลาเป็นนาทีเพราะ full table scan (O(n)) บนตาราง transaction หลายล้านแถว
- **รายการซ้ำ:** client retry หลัง network error ทำให้เกิดการตัดเงินซ้ำ (ขาด idempotency)
- **Payload ใหญ่:** mobile app โหลด JSON ขนาดใหญ่เกินไป ทำให้ช้าบนเครือข่าย 3G
- **วัดผลไม่ได้:** ทีมไม่มี KPI ที่ชัดเจนว่าการปรับปรุงสำเร็จหรือไม่

### Solution (วิธีแก้)
1. **Database Indexing:** สร้าง B-Tree index บน `(account_id, created_at)` และ BRIN บน `created_at` สำหรับ time-range query → ลดความซับซ้อนจาก O(n) → O(log n)
2. **Idempotency:** เพิ่ม `Idempotency-Key` header + ตาราง `idempotency_keys` พร้อม UNIQUE constraint + transaction เดียวกัน
3. **Protobuf สำหรับ mobile/internal:** เปลี่ยน internal service communication เป็น gRPC/Protobuf ลด payload 3–10 เท่า; คง JSON ที่ public API
4. **KPI/SMART:** กำหนด "ลด p95 latency ของรายงานจาก 120s → 5s ภายใน Q2/2027" และ "zero duplicate payment ภายใน 1 เดือนหลัง deploy"

### Result (ผลลัพธ์)
- รายงานเร็วขึ้น 20–50 เท่า (จาก O(n) → O(log n))
- ไม่มีรายการซ้ำเมื่อ client retry
- Mobile payload เล็กลง 3–10 เท่า โหลดเร็วขึ้นบนเครือข่ายช้า
- ทีมมีตัวชี้วัดที่วัดได้จริง ติดตามผลได้ทุก sprint

---

## บทสรุป

### ประโยชน์ที่ได้รับ
- เข้าใจเกณฑ์การเลือก JSON vs Protobuf ตามบริบท
- สามารถ implement Idempotency สำหรับ API การเงินได้อย่างปลอดภัย
- เข้าใจข้อดี/ข้อจำกัดของ index และผลต่อ Big O
- อ่านและอธิบาย Big O ได้ พร้อมตัวอย่าง Python
- กำหนด KPI ด้วยหลัก SMART สำหรับวัดคุณภาพสถาปัตยกรรม

### ข้อควรระวัง
- **Index มากเกินไปทำให้เขียนช้า** — ต้องเลือกเฉพาะที่จำเป็นและติดตาม query plan
- **Idempotency ต้องจัดการ race condition** — ต้องใช้ UNIQUE constraint + transaction เดียวกัน มิฉะนั้นคำขอพร้อมกันอาจผ่านทั้งคู่
- **Protobuf ไม่ใช่คำตอบทุกกรณี** — public API ที่ต้อง debug ด้วยตาเปล่ายังคงเหมาะกับ JSON
- **Big O ไม่ได้บอกเวลาจริง** — ค่าคงที่ (constant factor) และ hardware มีผล; ใช้ Big O เพื่อเลือกแนวทาง แล้ววัดจริง
- **KPI ที่ไม่ SMART** ทำให้ทีมไล่ตามตัวเลขที่ผิด

### ข้อจำกัด
- คู่มือนี้ไม่ครอบคลุมการ tuning ฐานข้อมูลเฉพาะ vendor (PostgreSQL/MySQL/Oracle)
- ตัวอย่าง Big O เป็นการวิเคราะห์เชิงแนวคิด ไม่ใช่ benchmark จริง
- KPI ต้องปรับตามบริบทองค์กร

### ข้อห้าม
- ห้ามใช้ `SELECT *` บนตารางใหญ่โดยไม่มี index และ pagination
- ห้าม rely on application-level check สำหรับ idempotency โดยไม่มี database-level UNIQUE constraint (ซ้ำจากเล่ม 2)
- ห้ามสร้าง index ทุกคอลัมน์ "เผื่อไว้" — ทำให้ write ช้าและเปลืองพื้นที่
- ห้ามกำหนด KPI ที่วัดไม่ได้หรือไม่มีกรอบเวลา

---

## ตัวอย่างการใช้งานจริง 3–5 กรณี

### กรณีที่ 1: เลือก JSON vs Protobuf สำหรับระบบ Payment

**Problem:** ระบบ payment มีทั้ง public API (ให้ merchant เรียก) และ internal service (ระหว่าง payment-service กับ ledger-service) ต้องเลือกรูปแบบข้อมูล

**Solution:**
- **Public API → JSON:** merchant ต้องการ debug ง่าย, ใช้ curl/Postman ได้, ไม่ต้อง generate code
- **Internal → Protobuf/gRPC:** ledger-service รับ event หลายล้านรายการ/วัน ต้องการ throughput สูงและ payload เล็ก

**Result:** Public API ใช้งานง่าย; internal ลด bandwidth 3–10 เท่าและ decode เร็วขึ้น

---

### กรณีที่ 2: Idempotent Payment API ด้วย Python (FastAPI)

**Problem:** Client retry คำขอชำระเงินเมื่อ network error ทำให้ตัดเงินซ้ำ

**Solution:**
```python
import uuid
from fastapi import FastAPI, Header, HTTPException
from pydantic import BaseModel

app = FastAPI()

class PaymentRequest(BaseModel):
    amount: float
    currency: str

@app.post("/payments")
def create_payment(
    body: PaymentRequest,
    idempotency_key: str = Header(..., alias="Idempotency-Key"),
    conn=...,  # database connection
):
    with conn:  # transaction เดียว
        with conn.cursor() as cur:
            # 1) พยายามบันทึก key (UNIQUE constraint กันซ้ำ)
            cur.execute(
                """
                INSERT INTO idempotency_keys (key, status)
                VALUES (%s, 'in_progress')
                ON CONFLICT (key) DO NOTHING
                RETURNING key
                """,
                (idempotency_key,),
            )
            if not cur.fetchone():
                # key ซ้ำ → คืน response เดิม
                cur.execute(
                    "SELECT response_body FROM idempotency_keys WHERE key = %s",
                    (idempotency_key,),
                )
                saved = cur.fetchone()
                if saved and saved[0]:
                    return saved[0]
                raise HTTPException(409, "Request already in progress")

            # 2) ประมวลผล payment จริง
            response = {
                "payment_id": str(uuid.uuid4()),
                "amount": body.amount,
                "status": "created",
            }

            # 3) บันทึกผลลัพธ์กลับ
            cur.execute(
                """
                UPDATE idempotency_keys
                SET status = 'completed', response_body = %s
                WHERE key = %s
                """,
                (response, idempotency_key),
            )
            return response
```

**Result:** Client retry ได้อย่างปลอดภัย ไม่เกิดการตัดเงินซ้ำ

---

### กรณีที่ 3: Database Indexing สำหรับรายงาน

**Problem:** รายงาน "transaction ของบัญชี X ในช่วง 30 วัน" ใช้เวลา 120 วินาทีบนตาราง 50 ล้านแถว

**Solution:**
```sql
-- ก่อน: full scan O(n)
SELECT * FROM transactions
WHERE account_id = 'A-1001'
  AND created_at >= now() - interval '30 days';

-- สร้าง composite B-Tree index
CREATE INDEX idx_tx_account_created
ON transactions (account_id, created_at);

-- สำหรับ time-range query ทั้งระบบ ใช้ BRIN
CREATE INDEX idx_tx_created_brin
ON transactions USING BRIN (created_at);
```

**Result:** query เร็วขึ้นจาก 120s → 2–5s (O(log n) + index-only scan) — แต่ write ช้าลงเล็กน้อยเพราะต้องอัปเดต index

**ข้อควรระวัง:** ตรวจสอบด้วย `EXPLAIN ANALYZE` ว่า optimizer ใช้ index จริง

---

### กรณีที่ 4: Big O — Linear Search vs Binary Search ใน Python

**Problem:** ต้องค้นหา transaction ID ในรายการ 1 ล้านรายการ ต้องเลือกวิธี

**Solution:**
```python
import bisect
import time

# O(n) — linear search
def linear_search(arr, target):
    for i, x in enumerate(arr):
        if x == target:
            return i
    return -1

# O(log n) — binary search (ต้องเรียงลำดับแล้ว)
def binary_search(arr, target):
    idx = bisect.bisect_left(arr, target)
    if idx < len(arr) and arr[idx] == target:
        return idx
    return -1

# ทดสอบ
n = 1_000_000
arr = list(range(n))
sorted_arr = sorted(arr)
target = n - 1

t0 = time.perf_counter()
linear_search(arr, target)
t1 = time.perf_counter()
print(f"Linear: {t1 - t0:.6f}s")   # ~0.05s

t0 = time.perf_counter()
binary_search(sorted_arr, target)
t1 = time.perf_counter()
print(f"Binary: {t1 - t0:.6f}s")   # ~0.000001s
```

**Result:** Binary search เร็วกว่ามหาศาลเมื่อ n ใหญ่ — แสดงให้เห็นว่า O(log n) ต่างจาก O(n) อย่างไรเมื่อข้อมูลโต

**Insight:** นี่คือเหตุผลเดียวกับที่ database index (B-Tree) ทำงานเร็ว — มันคือ binary search บน disk

---

### กรณีที่ 5: KPI/SMART สำหรับการปรับปรุงสถาปัตยกรรม

**Problem:** ทีมต้องการปรับปรุงระบบแต่ไม่รู้จะวัดความสำเร็จอย่างไร

**Solution:** กำหนด KPI ตาม SMART:

| KPI | Specific | Measurable | Achievable | Relevant | Time-bound |
|---|---|---|---|---|---|
| ลด p95 latency ของ payment API | payment API | 800ms → 200ms | เพิ่ม index + cache | ลดต้นทุน + UX | Q2/2027 |
| Zero duplicate payment | payment endpoint | 0 duplicates/เดือน | Idempotency-Key + UNIQUE | ความถูกต้องทางการเงิน | 1 เดือนหลัง deploy |
| ลด mobile payload | mobile API | 500KB → 150KB | เปลี่ยนเป็น Protobuf | ลดต้นทุน bandwidth | Q3/2027 |
| ลดเวลา report | report query | 120s → 5s | Composite index | ผู้บริหารตัดสินใจเร็ว | Q2/2027 |

**Result:** ทีมมีเป้าหมายที่วัดได้จริง ติดตามผลได้ทุก sprint และสื่อสารกับผู้บริหารได้ชัดเจน

---

## การใช้งาน

### หลักการนำไปใช้
1. **เริ่มจากความซับซ้อน:** วัด Big O ของ operation ก่อน optimize — ถ้าเป็น O(n²) การเพิ่ม hardware ไม่ช่วย
2. **เลือก index ตาม query pattern:** ดู `EXPLAIN ANALYZE` และสร้าง index เฉพาะที่ใช้บ่อย
3. **ทำ idempotency ทุก endpoint ที่มี side effect:** ใช้ `Idempotency-Key` + UNIQUE constraint + transaction เดียวกัน
4. **เลือกรูปแบบข้อมูลตามขอบเขต:** JSON ที่ edge, Protobuf ภายใน
5. **กำหนด KPI ด้วย SMART:** ทุกการปรับปรุงต้องมีตัวชี้วัดที่วัดได้และกรอบเวลา

---

## แหล่งอ้างอิง (เล่ม 4)

### JSON vs Protocol Buffers
- Google, *Protocol Buffers Documentation* — schema, field number, varint, code generation
- JSON Schema / OpenAPI Specification — การเสริม schema ให้ JSON
- gRPC Documentation — การใช้ Protobuf กับ gRPC และ gRPC-Web

### Idempotency
- AWS Well-Architected Framework — idempotency token, เก็บ token + response, คืน response เดิม
- DEV Community, *A practical guide to idempotency keys* — UNIQUE constraint, request hash, `Idempotency-Replayed` header
- Huawei Cloud, *Idempotency Keys, Unique Constraints, and Atomic Writes* — business record + idempotency result ใน transaction เดียวกัน
- GitHub, *ACID Guarantees and Idempotency* — UNIQUE constraint บน key column

### Database Indexing
- PostgreSQL Documentation, *Chapter 11. Indexes* — B-Tree, Hash, GIN, GiST, BRIN
- Use The Index, Luke — การเลือก index ตาม query pattern
- PostgreSQL Documentation, *EXPLAIN* — การวิเคราะห์ query plan

### Big O
- Cormen et al., *Introduction to Algorithms* — พื้นฐาน asymptotic notation
- Python `bisect` module documentation — binary search ใน standard library
- Big-O Cheat Sheet — ตารางความซับซ้อนที่พบบ่อย

### KPI / SMART
- Drucker, *Management: Tasks, Responsibilities, Practices* — พื้นฐาน KPI
- Doran, G. T. (1981), *There's a S.M.A.R.T. way to write management's goals and objectives* — ต้นกำเนิด SMART criteria
- Balanced Scorecard Institute — การนำ KPI ไปใช้ในองค์กร

### เชื่อมโยงกับเล่มก่อนหน้า
- เล่ม 1: ระบบธุรกรรมทางการเงินและบัญชี (บริบททางธุรกิจ)
- เล่ม 2: ACID, constraint, idempotency (กลไกความน่าเชื่อถือ)
- เล่ม 3: Audit, Audit Log, Transaction Cycles (การตรวจสอบ)

---

**สรุปแก่นของเล่ม 4:** สถาปัตยกรรมข้อมูลที่ดีไม่ใช่การเลือกเทคโนโลยีที่เร็วที่สุดหรือใหม่ที่สุด แต่คือ **การเลือกเครื่องมือให้ตรงกับขอบเขต (JSON vs Protobuf)
, การทำให้ operation ที่มี side effect ปลอดภัยจากการเรียกซ้ำ (Idempotency), การเข้าใจความซับซ้อนเพื่อ optimize อย่างถูกจุด (Big O + Indexing) และการวัดผลด้วยตัวชี้วัดที่ชัดเจน (KPI/SMART)** — ทั้งหมดนี้ต้องทำงานร่วมกับความถูกต้อง (เล่ม 1), ความน่าเชื่อถือ (เล่ม 2) และความสามารถในการตรวจสอบ (เล่ม 3) เพื่อให้ระบบการเงิน-บัญชีไม่เพียง "ถูกต้อง" แต่ยัง "เร็ว คุ้มค่า และพิสูจน์ได้"

---
## เพิ่มเติมจากเล่ม 4: โค้ด Protobuf จริง, กลไก B-Tree Split/Merge และ KPI ค้าปลีก/POS

ต่อไปนี้เป็นส่วนเสริมทั้งสามส่วนที่คุณต้องการ โดยยึดตามสไตล์ของเล่ม 4 และเพิ่มเนื้อหาเชิงปฏิบัติที่สามารถนำไปใช้ได้จริง

---

### 1. ตัวอย่าง Protobuf Schema จริง

ในระบบการเงิน การออกแบบ schema ของ Protobuf ต้องคำนึงถึงความเข้ากันได้ของการเปลี่ยนแปลง schema (schema evolution) นอกเหนือจากประสิทธิภาพ ต่อไปนี้เป็นตัวอย่าง `.proto` สำหรับบริการชำระเงินภายใน ครอบคลุมประเด็นสำคัญต่างๆ เช่น `oneof`, `repeated`, `map`, `reserved` และอื่นๆ

```protobuf
syntax = "proto3";

package payment.v1;

option java_package = "com.example.payment.v1";
option java_multiple_files = true;
option go_package = "github.com/example/payment/v1;paymentv1";

import "google/protobuf/timestamp.proto";

// ---------- ข้อความคำขอ ----------

message PaymentRequest {
  // ไอดีคำขอ ป้องกันการทำซ้ำ
  string idempotency_key = 1;

  // ข้อมูลผู้ชำระเงิน
  string payer_account_id = 2;

  // ข้อมูลผู้รับเงิน
  string payee_account_id = 3;

  // จำนวนเงิน (หน่วยเป็นสตางค์ เพื่อหลีกเลี่ยงปัญหาทศนิยม)
  int64 amount_cents = 4;

  // สกุลเงิน ISO 4217
  string currency = 5;

  // วิธีการชำระเงิน ใช้ oneof เพื่อรองรับส่วนขยายในอนาคต
  oneof payment_method {
    BankTransfer bank_transfer = 6;
    CreditCard credit_card = 7;
    Wallet wallet = 8;
  }

  // ข้อมูลเมตาเสริม
  map<string, string> metadata = 9;

  // เวลาที่สร้าง (ฝั่งไคลเอนต์)
  google.protobuf.Timestamp client_created_at = 10;

  // หมายเลขฟิลด์ที่เลิกใช้แล้วต้อง reserve ไว้ เพื่อป้องกันการใช้ซ้ำ
  reserved 11, 12;
  reserved "old_payment_type", "legacy_channel";
}

message BankTransfer {
  string bank_code = 1;
  string account_number = 2;
}

message CreditCard {
  // จัดเก็บเฉพาะ token ไม่จัดเก็บหมายเลขบัตรจริง
  string token = 1;
  string last4 = 2;
}

message Wallet {
  string wallet_provider = 1;
  string wallet_account_id = 2;
}

// ---------- ข้อความตอบกลับ ----------

message PaymentResponse {
  string payment_id = 1;
  PaymentStatus status = 2;
  int64 amount_cents = 3;
  string currency = 4;
  google.protobuf.Timestamp server_created_at = 5;

  // ในกรณีที่ล้มเหลว จะมีรหัสข้อผิดพลาด
  string error_code = 6;
  string error_message = 7;
}

enum PaymentStatus {
  PAYMENT_STATUS_UNSPECIFIED = 0;
  PAYMENT_STATUS_PENDING = 1;
  PAYMENT_STATUS_SUCCEEDED = 2;
  PAYMENT_STATUS_FAILED = 3;
  PAYMENT_STATUS_REFUNDED = 4;
}

// ---------- คำจำกัดความบริการ ----------

service PaymentService {
  rpc CreatePayment(PaymentRequest) returns (PaymentResponse);
  rpc GetPayment(GetPaymentRequest) returns (PaymentResponse);
}

message GetPaymentRequest {
  string payment_id = 1;
}
```

**คำอธิบายประเด็นสำคัญ:**

| การออกแบบ | เหตุผล |
|---|---|
| `amount_cents` ใช้ `int64` | หลีกเลี่ยงปัญหาความแม่นยำของทศนิยมในระบบการเงิน |
| `oneof payment_method` | รองรับการเพิ่มวิธีการชำระเงินใหม่โดยไม่ทำให้ข้อความเดิมเสียหาย |
| `map<string, string> metadata` | รองรับฟิลด์เพิ่มเติมจากธุรกิจ |
| `reserved 11, 12` | หมายเลขฟิลด์ที่เลิกใช้แล้วต้อง reserve ไว้ ถ้ามีคนนำกลับมาใช้ซ้ำจะทำให้การเข้ารหัสผิดพลาด  |
| `PAYMENT_STATUS_UNSPECIFIED = 0` | ตามข้อกำหนดของ proto3 ค่า enum ต้องเริ่มต้นด้วย 0 |
| การนำเข้า `google.protobuf.Timestamp` | ใช้ประเภทเวลามาตรฐาน หลีกเลี่ยงการแปลงเขตเวลาที่กำหนดเอง |

**หมายเหตุเกี่ยวกับความเข้มงวดของ schema:** Protobuf บังคับใช้ schema ผ่าน `.proto` และ `protoc` การเพิ่มฟิลด์ใหม่เป็น "wire-safe" (ไคลเอนต์เก่าจะไม่สนใจฟิลด์ใหม่) แต่การลบฟิลด์ต้อง reserve หมายเลขฟิลด์ไว้ และต้องไม่นำหมายเลขฟิลด์กลับมาใช้ซ้ำ  นี่คือเหตุผลที่ระบบการเงินให้ความสำคัญกับ Protobuf มากกว่า JSON ในบริการภายใน—ความเข้มงวดของ schema คือสัญญา

---

### 2. กรณีศึกษา B-Tree Split/Merge

ในฐานะโครงสร้างพื้นฐานของ index ฐานข้อมูล พฤติกรรมของ B-Tree ภายใต้การแทรกและการลบส่งผลโดยตรงต่อประสิทธิภาพการเขียนและพื้นที่ว่าง ต่อไปนี้รวมหลักการทำงานจริงของ PostgreSQL อธิบายกลไก split และ merge

#### 2.1 หลักการ Split (การแยก)

เมื่อหน้า leaf เต็มและมีระเบียนใหม่เข้ามา PostgreSQL จะทำ **page split**: ย้ายข้อมูลบางส่วนจากหน้าเดิมไปยังหน้าใหม่ และแทรก pointer ใหม่ในหน้าแม่  หากหน้าแม่เต็มด้วย จะเกิดการ split แบบเรียกซ้ำแบบ "ลามขึ้น" จนถึง root; หาก root เต็ม จะสร้าง root ใหม่เพิ่มระดับของ tree ขึ้นหนึ่งชั้น

**กลยุทธ์การแยกของ PostgreSQL:** จากการสังเกตจริง หน้า leaf สามารถเก็บได้ประมาณ 366 ระเบียน (สมมติว่า index เป็น integer) หลังการ split หน้าเดิมเก็บประมาณ 90% (366 รายการ) และหน้าใหม่รับประมาณ 10%  การออกแบบนี้ทำให้หน้าเดิมมีพื้นที่เหลือ เพื่อรองรับการแทรกที่ตามมาโดยไม่ต้อง split บ่อยครั้ง

**"จุดอันตราย" ของการ split:** เมื่อรายการ index มีขนาดใหญ่ (ใกล้เคียง 1/3 ของหน้าหน่วยความจำ) การเลือกตำแหน่ง split อาจทำให้ระเบียนใหม่ไม่สามารถใส่ลงในหน้าใดหน้าหนึ่งได้ อีเมลใน PostgreSQL mailing list เคยรายงานข้อบกพร่อง: เมื่อ item ขนาดใหญ่รวมกลุ่มกัน การแบ่งตาม "จำนวน" อาจไม่สมดุลตาม "ขนาด" ทำให้ระเบียนที่เข้ามาใหม่ (1416 bytes) ไม่สามารถใส่ลงในหน้าขวาได้  สิ่งนี้เตือนเราว่า: **เมื่อสร้าง index บนฟิลด์ที่มีขนาดใหญ่หรือยาวไม่คงที่ (เช่น JSONB, text ขนาดยาว) ควรระวัง fragmentation ที่เกิดจากการ split**

#### 2.2 หลักการ Merge (การรวม)

เมื่อระเบียนในหน้าถูกลบจนเหลือน้อยเกินไป B-Tree จะทำ merge หรือ rebalance เพื่อคืนพื้นที่ กลไก merge ใน PostgreSQL หลักๆ แล้วอาศัย **"bottom-up index deletion"**: ในระหว่างการสแกน index จะทำเครื่องหมายระเบียนที่ตายแล้ว (LP_DEAD) และเมื่อคาดว่าจะเกิด page split จะลบระเบียนที่ตายแล้วแบบเชิงรุกเพื่อลดโอกาสในการ split 

**การเชื่อมโยงกับการออกแบบในทางปฏิบัติ:**
- **ตารางที่เขียนหนัก (เช่น ตารางธุรกรรม):** split บ่อยครั้งเป็นเรื่องปกติ แต่ต้องระวัง: หากใช้ UUID แบบสุ่มเป็น primary key การกระจายของการแทรกจะไม่ต่อเนื่อง ทำให้เกิด split บ่อยครั้งและหน้าเต็มบางส่วน (page fill factor ต่ำ) แนะนำให้ใช้ **UUIDv7 (เรียงตามเวลา)** หรือ **bigserial แบบ monotonic** เพื่อให้การแทรก concentrated ที่ด้านขวา ลด split
- **ตารางที่ลบหนัก (เช่น ตารางชั่วคราว, ตาราง session):** merge และ space reclaim มีความสำคัญมาก ควรตรวจสอบ `pg_stat_user_indexes` เป็นประจำเพื่อดู `idx_scan` และ `idx_tup_read/write` ประเมินว่า index ยังคุ้มค่าหรือไม่
- **ตาราง audit log (เชื่อมโยงกับเล่ม 3):** append-only แทบไม่มีการลบ ดังนั้น index ควร **ลดจำนวนลงให้เหลือน้อยที่สุด** และเลือกสร้างเฉพาะคอลัมน์ที่ใช้สอบถาม (เช่น `created_at`, `actor_id`) หลีกเลี่ยงการเพิ่ม overhead การเขียน

#### 2.3 ผลกระทบต่อ "Big O" (เชื่อมโยงกับเล่ม 4)

| การดำเนินการ | จำนวน I/O ระดับ B-Tree | คำอธิบาย |
|---|---|---|
| ค้นหา | O(log n) | ระดับความสูงของ tree ≈ log_fanout(n), fanout โดยปกติคือหลายร้อย |
| การแทรก (ไม่มี split) | O(log n) | ค้นหาตำแหน่ง + เขียน |
| การแทรก (เกิด split) | O(log n) + split overhead | split อาจลามขึ้น แต่ค่าคงที่น้อย |
| การลบ (ไม่มี merge) | O(log n) | ทำเครื่องหมายว่าตาย |
| Full scan | O(n) | สแกน leaf ทั้งหมดตามลำดับ |

**ข้อสรุป:** B-Tree ให้ความสามารถในการค้นหา O(log n) แต่ **"ราคา" คือการเขียนต้องรักษาสมดุลของ tree** ในระบบการเงิน ควรเลือกจำนวน index อย่างระมัดระวัง—index ทุกตัวทำให้การเขียนธุรกรรมช้าลง (เชื่อมโยงกับข้อควรระวังในส่วน Database Indexing ของเล่ม 4)

---

### 3. ตัวอย่าง KPI อุตสาหกรรมค้าส่ง/ค้าปลีก (POS)

ระบบ POS (Point of Sale) เป็นแหล่งข้อมูลหลักของ "_sell-through_" ในค้าปลีก ต่อไปนี้เป็นชุดตัวชี้วัดที่ออกแบบตามหลัก SMART โดยมีสินค้าคงคลัง POS และประสิทธิภาพพนักงานเป็นสองมิติ

#### 3.1 ตัวชี้วัดหลัก: Sell-Through (อัตราการขายหมด)

**คำจำกัดความ:** สัดส่วนของหน่วยที่ขายได้ต่อหน่วยที่พร้อมขายในช่วงเวลาหนึ่ง ใช้วัด "ความเร็วในการขาย" ของสินค้า 

**สูตร:**
```
Sell-Through (%) = (จำนวนหน่วยที่ขายได้ในช่วงเวลานั้น ÷ (สินค้าคงคลังต้นงวด + จำนวนที่รับเข้าในช่วงเวลานั้น)) × 100%
```

**SMART ของ KPI:**

| องค์ประกอบ | คำอธิบาย |
|---|---|
| **S**pecific | Sell-Through รายสัปดาห์ของ SKU ระดับ A (สินค้าขายดี) |
| **M**easurable | ข้อมูลจากระบบ POS โดยตรง > 20% ถือว่าผ่าน |
| **A**chievable | อ้างอิงค่าฐานของไตรมาสเดียวกันของปีที่แล้ว +10% |
| **R**elevant | สอดคล้องกับเป้าหมาย "ลดสินค้าคงค้าง ลดส่วนลด" |
| **T**ime-bound | ตรวจสอบทุกสัปดาห์ ถึงสิ้นไตรมาส |

**เกณฑ์การดำเนินการ:** SKU ที่ Sell-Through รายสัปดาห์ต่ำกว่า 20% จะกระตุ้นการเตือน ล่วงหน้าในการวางแผนโปรโมชันหรือการโอนสินค้าระหว่างสาขา 

#### 3.2 ตัวชี้วัดเสริม: Inventory Days of Supply (จำนวนวันในการขายหมด)

**สูตร:**
```
DOS = สินค้าคงคลังปัจจุบัน ÷ ยอดขายเฉลี่ยต่อวัน
```

**ตัวอย่าง:** SKU หนึ่งมียอดขายเฉลี่ย 50 ชิ้นต่อวัน สินค้าคงคลัง 600 ชิ้น → DOS = 12 วัน หากเป้าหมายคือ ≤ 14 วัน ถือว่าผ่าน

#### 3.3 ตัวชี้วัดประสิทธิภาพพนักงาน (ข้อมูล POS)

ระบบ POS สามารถติดตามยอดขายของพนักงานแต่ละคนได้ ตัวอย่างเช่น SHOPLINE POS รองรับการดูรายงาน "ประสิทธิภาพการขาย" รายวัน/รายสัปดาห์/รายเดือนของพนักงาน  ตัวชี้วัดหลัก:

| ตัวชี้วัด | สูตร | วัตถุประสงค์ |
|---|---|---|
| **ยอดขายต่อคน** | ยอดขายที่รับจริง (ไม่รวมคำสั่งซื้อที่ยกเลิก/คืนสินค้า) | ประเมินผลงาน |
| **จำนวนคำสั่งซื้อ** | จำนวนคำสั่งซื้อที่สำเร็จ | วัดปริมาณ |
| **มูลค่าคำสั่งซื้อเฉลี่ย** | ยอดขาย ÷ จำนวนคำสั่งซื้อ | วัดความสามารถในการขายเพิ่ม |

**ประเด็นสำคัญ:** ยอดขายควรอ้างอิงตาม "เวลาที่เปลี่ยนแปลงสถานะคำสั่งซื้อ" ไม่ใช่เวลาที่สร้าง ตัวอย่างเช่น หากพนักงาน A สร้างคำสั่งซื้อล่วงหน้า 100 หยวนในวันที่ 1 และลูกค้าชำระส่วนที่เหลือ 900 หยวนในวันที่ 10 ยอดขาย 100 หยวนจะนับในวันที่ 1 และ 900 หยวนนับในวันที่ 10  การออกแบบนี้ทำให้ตัวชี้วัดสอดคล้องกับ "การรับรู้รายได้" (เชื่อมโยงกับหลักการ accrual basis ในเล่ม 1)

#### 3.4 KPI ค้าปลีกเพิ่มเติม (เชื่อมโยงกับค้าส่ง)

| ตัวชี้วัด | สูตร | การนำไปใช้ |
|---|---|---|
| **Sell-In** | จำนวนที่จัดส่งไปยังร้านค้าปลีก ÷ จำนวนที่วางแผนกระจาย | วัดความสำเร็จในการกระจายสินค้าของซัพพลายเออร์  |
| **GMROII** | กำไรขั้นต้น ÷ มูลค่าสินค้าคงคลังเฉลี่ย | วัดประสิทธิภาพการใช้เงินทุนสินค้าคงคลัง  |
| **กำไรต่อนิ้วเชิงเส้น** | กำไร ÷ พื้นที่ชั้นวาง (นิ้ว) | ใช้ในการต่อรองพื้นที่ชั้นวาง |
| **อัตราการปฏิบัติตามคำสั่งซื้อ** | จำนวนที่จัดส่งจริง ÷ จำนวนที่สั่งซื้อ | วัดความน่าเชื่อถือของซัพพลายเออร์ |

#### 3.5 ตารางสรุป KPI แบบครบชุด (ตัวอย่าง SMART)

| KPI | ค่าปัจจุบัน | เป้าหมาย | กำหนดเวลา | เจ้าของ |
|---|---|---|---|---|
| Sell-Through รายสัปดาห์ (SKU ระดับ A) | 15% | ≥ 20% | สิ้นไตรมาส | ฝ่ายสินค้า |
| DOS (สินค้าขายดี 10 อันดับแรก) | 18 วัน | ≤ 14 วัน | 2 เดือน | ฝ่ายสินค้า + ซัพพลายเชน |
| มูลค่าคำสั่งซื้อเฉลี่ยต่อพนักงาน | ¥ 120 | ≥ ¥ 150 | 1 ไตรมาส | ผู้จัดการสาขา |
| อัตราความแม่นยำของสินค้าคงคลัง POS | 92% | ≥ 98% | 1 เดือน | ฝ่ายปฏิบัติการ |
| อัตราการเกิดซ้ำของลูกค้า (สมาชิก) | 25% | ≥ 30% | ครึ่งปี | การตลาด |

---

### สรุปการเชื่อมโยงกับเล่ม 4

ส่วนเสริมทั้งสามส่วนนี้เชื่อมโยงกับหลักการของเล่ม 4 ดังนี้:

1. **Protobuf schema จริง** → สะท้อนหลักการ "เลือกรูปแบบข้อมูลตามขอบเขต": บริการการเงินภายในใช้ Protobuf + schema เข้มงวด + `reserved` เพื่อรองรับการ evolution ในระยะยาว
2. **B-Tree split/merge** → สะท้อนหลักการ "เข้าใจ Big O เพื่อ optimize อย่างตรงจุด": index ให้ O(log n) แต่มีค่าใช้จ่ายในการเขียน (split) และพื้นที่ (merge) ต้องปรับสมดุลตามรูปแบบภาระงาน
3. **KPI ค้าปลีก/POS** → สะท้อนหลักการ "วัดผลด้วย SMART": Sell-Through, DOS, ยอดขายต่อคน ล้วนเป็นตัวชี้วัดที่วัดผลได้ มีกรอบเวลา และผูกกับเป้าหมายทางธุรกิจ