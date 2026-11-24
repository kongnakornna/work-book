# เล่ม 2: ความน่าเชื่อถือของระบบธุรกรรม (ACID, Concurrency, Recovery, Idempotency)

## บทนำ

### คืออะไร
คู่มือเล่มนี้ว่าด้วย **ชั้นกลไกทางเทคนิค** ที่ทำให้ระบบธุรกรรมทางการเงินและบัญชี (ซึ่งอธิบายไว้ในเล่ม 1) มีความถูกต้อง เชื่อถือได้ และทนทานต่อสภาวะที่ผิดปกติ ได้แก่ **ACID**, **การควบคุม transaction** (BEGIN/COMMIT/ROLLBACK), **constraint**, **concurrency control** (locking/MVCC/isolation/deadlock), **crash recovery** (WAL/redo/fsync/replication) และ **Idempotency** สำหรับ API

### คำนำ
ในระบบการเงิน การสูญเสียความน่าเชื่อถือเพียงครั้งเดียวอาจหมายถึงเงินที่หายไป รายงานที่ผิด หรือการถูกตรวจสอบจากหน่วยงานกำกับดูแล กลไกในคู่มือเล่มนี้จึงไม่ได้เป็นเพียง "ฟีเจอร์ของฐานข้อมูล" แต่เป็น **หลักประกันว่ากฎธุรกิจจะถูกบังคับใช้อย่างถูกต้องเสมอ** แม้ในสภาวะที่ระบบทำงานพร้อมกันหรือล่มกลางคัน

### วัตถุประสงค์
1. อธิบาย ACID และกลไกที่ฐานข้อมูลใช้รับประกันคุณสมบัติทั้งสี่ข้อ
2. อธิบายกลไก constraint ที่บังคับกฎธุรกิจที่ระดับฐานข้อมูล
3. อธิบาย concurrency control (MVCC, locking, isolation level) และการจัดการ deadlock
4. อธิบาย WAL, fsync, crash recovery และ replication ในฐานะกลไก durability
5. อธิบาย Idempotency และการนำไปใช้กับ RESTful API พร้อมตัวอย่าง Python

### เป้าหมาย
ผู้อ่านสามารถ **ออกแบบ transaction ที่ปลอดภัย** เลือกใช้ isolation level ที่เหมาะสม จัดการ deadlock และทำให้ API รองรับการ retry โดยไม่สร้างรายการซ้ำ

### ความรู้พื้นฐาน
- พื้นฐานฐานข้อมูลเชิงสัมพันธ์ (ตาราง, คีย์, index)
- แนวคิดเรื่อง transaction และ SQL พื้นฐาน
- พื้นฐานการเขียนโปรแกรม (สำหรับตัวอย่าง Python)


## บทนิยาม

### 1. ACID

**คืออะไร:** ชุดคุณสมบัติ 4 ข้อของ transaction ที่รับประกันความถูกต้องของข้อมูลแม้มีการทำงานพร้อมกันหรือระบบล่ม

| คุณสมบัติ | ความหมาย | สิ่งที่รับประกัน |
|---|---|---|
| **Atomicity** | ทุก operation ใน transaction สำเร็จทั้งหมดหรือไม่สำเร็จเลย | หากเกิดความล้มเหลวกลางคัน จะไม่มีผลลัพธ์บางส่วนปรากฏ |
| **Consistency** | transaction พา database จาก state ที่ถูกต้องไปยัง state ที่ถูกต้อง | ข้อมูลไม่ละเมิดกฎ/constraint ที่กำหนด |
| **Isolation** | transaction ที่ทำงานพร้อมกันไม่รบกวนกัน | ผู้อื่นไม่เห็น transaction ที่ยังไม่ commit |
| **Durability** | เมื่อ commit แล้ว ข้อมูลจะคงอยู่แม้ระบบล่ม | การเปลี่ยนแปลงถูกบันทึกถาวร |

**ทำไมต้องเป็นแบบนี้:** เพราะระบบการเงินไม่สามารถยอมรับรายการ "ครึ่งๆ กลางๆ" หรือข้อมูลที่ขัดแย้งกันได้ ACID จึงเป็นสัญญาทางเทคนิคที่ทำให้ application สามารถเชื่อถือผลลัพธ์ของ transaction ได้

**ประโยชน์:** เป็นรากฐานของความน่าเชื่อถือทั้งหมดในระบบธุรกรรม


### 2. Transaction Control: BEGIN / COMMIT / ROLLBACK

**BEGIN:** เริ่มต้น transaction ใหม่
**COMMIT:** ยืนยันการเปลี่ยนแปลงทั้งหมดอย่างถาวร
**ROLLBACK:** ยกเลิกการเปลี่ยนแปลงทั้งหมดที่เกิดขึ้นตั้งแต่ BEGIN

**หลักการสำคัญ:** เมื่อมี statement ใด statement หนึ่งเกิด error ภายใน transaction PostgreSQL จะ **abort transaction ทั้งหมด** และปฏิเสธที่จะรันคำสั่งถัดไปจนกว่าจะมี `ROLLBACK` อย่างชัดเจน การ `ROLLBACK` จะย้อนทุกอย่างตั้งแต่ `BEGIN` รวมถึง statement ที่สำเร็จก่อนหน้า

**Undo log / Rollback mechanism:** ฐานข้อมูลเก็บข้อมูลก่อนการเปลี่ยนแปลงไว้ใน undo log (หรือใช้ MVCC tuple version) เพื่อให้สามารถย้อนกลับได้เมื่อ rollback

**ข้อควรระวัง:** Sequence (auto-increment) **ไม่ถูก rollback** — หมายเลขที่ถูกใช้ไปแล้วจะไม่ถูกนำกลับมาใช้ซ้ำ ทำให้เกิดช่องว่างใน ID ซึ่งเป็นเรื่องปกติ ไม่ใช่ bug


### 3. Constraints (PK, FK, UNIQUE, NOT NULL, CHECK, Trigger)

**คืออะไร:** กฎที่ฐานข้อมูลบังคับใช้เพื่อรักษาความถูกต้องของข้อมูล โดยไม่ต้องพึ่งพา application layer เพียงอย่างเดียว

| Constraint | หน้าที่ | ตัวอย่างในระบบการเงิน |
|---|---|---|
| **PRIMARY KEY (PK)** | ระบุเอกลักษณ์ของแต่ละแถว (เทียบเท่า UNIQUE + NOT NULL) | `transaction_id` |
| **FOREIGN KEY (FK)** | รักษาความสัมพันธ์ระหว่างตาราง | `account_id` อ้างอิงถึงตาราง `accounts` |
| **UNIQUE** | ห้ามค่าซ้ำ | `idempotency_key` ต่อผู้ใช้ |
| **NOT NULL** | ห้ามค่าว่าง | `amount` ต้องไม่เป็น NULL |
| **CHECK** | ตรวจสอบเงื่อนไข | `amount > 0`, `balance >= 0` |
| **Trigger** | โค้ดที่ทำงานอัตโนมัติเมื่อเกิดเหตุการณ์ | บันทึก audit log เมื่อมีการ UPDATE |

**Insight:** Constraint คือ **"กฎธุรกิจที่ถูกบังคับใช้โดยฐานข้อมูล"** ทำให้แม้ application มี bug หรือมีผู้พยายามเขียนข้อมูลโดยตรง ข้อมูลก็ยังคงถูกต้อง

PostgreSQL เก็บ constraint ทั้งหมดไว้ใน catalog `pg_constraint` โดยมีรหัสประเภท: `c` = check, `f` = foreign key, `n` = not-null, `p` = primary key, `u` = unique, `t` = constraint trigger, `x` = exclusion


### 4. Locking / MVCC และ Isolation Levels

**MVCC (Multi-Version Concurrency Control)** คือกลไกหลักที่ PostgreSQL ใช้เพื่อให้ **"ผู้อ่านไม่บล็อกผู้เขียน และผู้เขียนไม่บล็อกผู้อ่าน"**

**หลักการทำงานของ MVCC:**
- ทุกแถว (tuple) มีคอลัมน์ระบบ `xmin` (transaction ID ที่สร้าง version นี้) และ `xmax` (transaction ID ที่ลบ/แทนที่ version นี้; 0 หากยังมีชีวิต)
- เมื่อ `UPDATE` ฐานข้อมูลจะ **ไม่เขียนทับแถวเดิม** แต่สร้าง version ใหม่และทำเครื่องหมาย version เก่าว่าหมดอายุ
- ผู้อ่านแต่ละ transaction จะเห็น snapshot ของข้อมูล ณ เวลาที่เริ่มต้น (หรือตาม isolation level) ทำให้ไม่เห็นการเปลี่ยนแปลงที่ยังไม่ commit

**Isolation Level:** SQL มาตรฐานกำหนด 4 ระดับ ซึ่งควบคุมว่า transaction หนึ่งจะเห็นผลของ transaction อื่นหรือไม่:

| Level | Dirty Read | Non-repeatable Read | Phantom Read |
|---|---|---|---|
| Read Uncommitted | อาจเกิด | อาจเกิด | อาจเกิด |
| Read Committed (default ของ PostgreSQL) | ไม่เกิด | อาจเกิด | อาจเกิด |
| Repeatable Read | ไม่เกิด | ไม่เกิด | อาจเกิด (แต่ PostgreSQL ไม่เกิด) |
| Serializable | ไม่เกิด | ไม่เกิด | ไม่เกิด |

**Locking แบบชัดเจน (Explicit Locking):** เมื่อ MVCC ไม่เพียงพอ (เช่น ต้องป้องกัน lost update) ใช้ `SELECT ... FOR UPDATE` เพื่อล็อกแถวก่อนอ่าน-แก้-เขียน รูปแบบ `FOR UPDATE SKIP LOCKED` ใช้สำหรับ work queue ที่มีผู้บริโภคหลายรายแย่งงานกัน

**Deadlock:** เกิดขึ้นเมื่อ transaction สองตัวถือ lock ที่อีกฝ่ายต้องการและรอกันเป็นวงจร PostgreSQL ตรวจพบโดย process เบื้องหลังที่ทำงานทุก `deadlock_timeout` (ค่าเริ่มต้น 1 วินาที) และจะ abort transaction หนึ่งตัว (victim) พร้อม error `deadlock detected` (SQLSTATE 40P01)


### 5. WAL / Redo Log, fsync, Crash Recovery, Replication

**WAL (Write-Ahead Logging)** คือกลไกที่ PostgreSQL ใช้รับประกัน **Durability** และ **Crash Recovery** โดยหลักการคือ **เขียน log ของการเปลี่ยนแปลงลง WAL ก่อน** แล้วจึงเขียนข้อมูลจริงลง data file ภายหลัง

**fsync:** เมื่อเปิด (ค่าเริ่มต้น) PostgreSQL จะออก system call `fsync()` เพื่อบังคับให้ข้อมูลถูกเขียนลง disk จริง ทำให้ database cluster สามารถกู้คืนสู่สภาพที่สอดคล้องกันได้หลังระบบปฏิบัติการหรือฮาร์ดแวร์ crash การปิด `fsync` อาจเพิ่ม performance แต่เสี่ยงต่อ data corruption ที่กู้คืนไม่ได้หากไฟล์ระบบล่ม

**synchronous_commit:** ควบคุมว่าการ commit จะรอให้ WAL ถูก flush ลง disk หรือไม่ การตั้งเป็น `off` ไม่ทำให้ database  inconsistency แต่ transaction ที่ commit แล้วอาจสูญหายได้หาก crash — ฐานข้อมูลจะอยู่ใน state เสมือน transaction นั้นถูก abort อย่างสะอาด

**Crash Recovery:** เมื่อระบบกลับมา PostgreSQL จะ replay WAL เพื่อทำซ้ำ transaction ที่ commit แล้วแต่ยังไม่ถูกเขียนลง data file

**Replication:** WAL ยังถูกส่งไปยัง standby server ผ่าน **streaming replication** เพื่อให้สำเนาข้อมูลตามทัน primary เกือบเรียลไทม์


### 6. Idempotency

**คืออะไร:** คุณสมบัติที่การเรียกใช้งานเดียวกันซ้ำหลายครั้งให้ผลลัพธ์เหมือนกับการเรียกครั้งเดียว ในระบบ distributed การรับประกัน "exactly-once" เป็นเรื่องยากมาก แต่สามารถบรรลุผล "effectively exactly-once" ได้ด้วย **idempotency token**

**หลักการ implement สำหรับ RESTful API:**
1. **ระบุ operation ที่ต้องมี idempotency:** โดยทั่วไปคือ `POST` ที่สร้าง resource, `PUT`, `DELETE` และ operation ที่มี side effect
2. **ใช้ token ที่ไม่ซ้ำ:** client สร้าง `Idempotency-Key` (เช่น UUID) ต่อ "logical operation" หนึ่งครั้ง และส่งใน header ทุกครั้งที่ retry
3. **ตรวจสอบและบันทึกผลลัพธ์:** server เก็บ key และ response แรกไว้; เมื่อได้รับ key ซ้ำ จะคืน response เดิมโดยไม่ประมวลผลซ้ำ
4. **รับประกัน race condition ด้วย UNIQUE constraint:** ใช้ database `UNIQUE` constraint บนคอลัมน์ idempotency key และทำ check-and-act ภายใน transaction เดียวกัน เพื่อให้มีเพียงคำขอเดียวที่ชนะ


## หลักการทำงาน (Concept)

Transaction ที่เชื่อถือได้ต้องผ่านกลไกหลายชั้น **พร้อมกัน** ไม่ใช่แยกกัน:

```
Application เริ่ม transaction
        │
        ▼
BEGIN
        │
        ▼
MVCC Snapshot + Lock (ถ้าจำเป็น)
        │
        ▼
ดำเนินการ (Constraints ถูกบังคับใช้ที่ระดับ DB)
        │
        ├── สำเร็จ → COMMIT → WAL flush (fsync) → Durability
        │                                    │
        │                                    └── Replication (ถ้าตั้งค่า)
        │
        └── ผิดพลาด → ROLLBACK (ย้อนทุกอย่างตั้งแต่ BEGIN)
                        │
                        └── Retry (ถ้าเป็น serialization failure/deadlock)
```

**จุดเชื่อมโยงระหว่างกลไก:**
- **Atomicity** ถูกทำให้เกิดจริงด้วย `ROLLBACK` + undo/MVCC
- **Consistency** ถูกบังคับด้วย constraints
- **Isolation** ถูกทำให้เกิดจริงด้วย MVCC + isolation level + locking
- **Durability** ถูกทำให้เกิดจริงด้วย WAL + fsync (+ replication)


## Workflow และ Dataflow (PSR)

### Problem (ปัญหา)
ระบบการเงินเกิดรายการซ้ำเมื่อ client retry หลัง network error และบาง transaction ถูกบันทึกเพียงบางส่วนเมื่อระบบล่มกลางคัน นอกจากนี้ เมื่อมีผู้ใช้พร้อมกันจำนวนมาก เกิด deadlock และ lost update บ่อยครั้ง

### Solution (วิธีแก้)
ออกแบบระบบด้วยกลไก 5 ชั้น:
1. **ACID transaction** ครอบทุก operation ที่เกี่ยวกับการเงิน (BEGIN → COMMIT/ROLLBACK)
2. **Constraints** บังคับกฎธุรกิจที่ระดับฐานข้อมูล (CHECK `amount > 0`, UNIQUE `idempotency_key`, FK)
3. **Isolation level ที่เหมาะสม** (Read Committed สำหรับงานทั่วไป, Serializable สำหรับการโอนเงิน) + `SELECT ... FOR UPDATE` เมื่อจำเป็น
4. **WAL + fsync** สำหรับ durability, **replication** สำหรับ availability
5. **Idempotency-Key** สำหรับทุก endpoint ที่สร้างรายการ + UNIQUE constraint เพื่อกัน race condition

### Result (ผลลัพธ์)
- ไม่มีรายการซ้ำเมื่อ client retry
- Transaction ไม่ถูกบันทึกครึ่งๆ กลางๆ
- Deadlock ถูกตรวจจับและจัดการด้วย retry loop
- ข้อมูลคงอยู่แม้ระบบล่ม


## บทสรุป

### ประโยชน์ที่ได้รับ
- เข้าใจกลไกที่ทำให้ ACID เกิดขึ้นจริง ไม่ใช่แค่คำนิยาม
- สามารถออกแบบ constraint และ transaction ที่บังคับกฎธุรกิจได้อย่างมั่นใจ
- สามารถจัดการ concurrency, deadlock และ crash recovery ได้
- สามารถ implement Idempotency สำหรับ API การเงินได้

### ข้อควรระวัง
- **Isolation level ที่สูงขึ้นลด concurrency:** Serializable อาจทำให้ transaction ล้มเหลวบ่อยขึ้นเนื่องจาก serialization failure ต้องมี retry loop
- **`fsync = off` เสี่ยง data corruption:** ใช้เฉพาะในกรณีที่สามารถสร้าง database ใหม่จากข้อมูลภายนอกได้เท่านั้น
- **`synchronous_commit = off` ไม่ทำให้ข้อมูลเสียหาย แต่ transaction ที่ commit แล้วอาจหายไปหาก crash** — ใช้เมื่อ performance สำคัญกว่า durability ที่แน่นอน
- **Idempotency ต้องจัดการ race condition:** ต้องใช้ UNIQUE constraint + transaction เดียวกัน มิฉะนั้นคำขอที่มาพร้อมกันอาจผ่านการตรวจสอบทั้งคู่
- **Sequence ไม่ rollback:** ช่องว่างใน ID เป็นเรื่องปกติ ไม่ใช่ bug

### ข้อจำกัด
- ACID ไม่ได้แก้ปัญหากฎธุรกิจที่ออกแบบผิด — ต้องออกแบบ constraint และ workflow ให้ถูกต้องตั้งแต่ต้น
- WAL และ fsync มีต้นทุน performance — ต้องชั่งน้ำหนักกับความต้องการ durability
- MVCC ทำให้เกิด bloat (dead tuple) ซึ่งต้องจัดการด้วย vacuum

### ข้อห้าม
- ห้ามใช้ `fsync = off` ในระบบ production ที่มีข้อมูลจริงจัง
- ห้าม rely on application-level check สำหรับ idempotency โดยไม่มี database-level UNIQUE constraint
- ห้ามใช้ `SELECT ... FOR UPDATE` ใน transaction ที่ยาวนานโดยไม่จำเป็น เพราะจะบล็อกผู้อื่น


## ตัวอย่างการใช้งานจริง 3–5 กรณี

### กรณีที่ 1: การโอนเงินด้วย ACID Transaction

**Problem:** ต้องการโอนเงิน 500 บาทจากบัญชี A ไปยังบัญชี B โดยที่ยอดรวมต้องคงเดิมและต้องไม่เกิดการหักเงินซ้ำ

**Solution:**
```sql
BEGIN;
-- ตรวจสอบและล็อกแถวเพื่อป้องกัน lost update
SELECT balance FROM accounts WHERE id = 'A' FOR UPDATE;
-- ตรวจสอบว่ามียอดเพียงพอ (หรือใช้ CHECK constraint)
UPDATE accounts SET balance = balance - 500 WHERE id = 'A';
UPDATE accounts SET balance = balance + 500 WHERE id = 'B';
COMMIT;
```

หากขั้นตอนใดล้มเหลว `ROLLBACK` จะย้อนทั้งสอง UPDATE พร้อมกัน (Atomicity) และ `CHECK (balance >= 0)` จะป้องกันยอดติดลบ (Consistency)

**Result:** การโอนสำเร็จทั้งหมดหรือไม่สำเร็จเลย และไม่มี lost update เพราะ `FOR UPDATE` ล็อกแถวก่อนอ่าน


### กรณีที่ 2: Deadlock Detection และ Retry Loop

**Problem:** Transaction สองตัวอัปเดตแถวคนละลำดับ ทำให้เกิด deadlock

**Solution:** PostgreSQL ตรวจจับ deadlock ภายใน `deadlock_timeout` (1 วินาที) และ abort transaction หนึ่งตัวพร้อม SQLSTATE `40P01` Application ต้องมี **retry loop** ที่รองรับ serialization failure และ deadlock:

```python
import psycopg2
from psycopg2 import errors

def transfer_with_retry(conn, max_retries=3):
    for attempt in range(max_retries):
        try:
            with conn:  # จัดการ transaction อัตโนมัติ
                with conn.cursor() as cur:
                    cur.execute(
                        "UPDATE accounts SET balance = balance - 100 WHERE id = 1"
                    )
                    cur.execute(
                        "UPDATE accounts SET balance = balance + 100 WHERE id = 2"
                    )
            return True  # สำเร็จ
        except (errors.DeadlockDetected, errors.SerializationFailure):
            if attempt == max_retries - 1:
                raise
            continue  # retry
    return False
```

**Result:** Transaction ที่ถูก abort เนื่องจาก deadlock ถูก retry จนสำเร็จหรือถึงจำนวนครั้งสูงสุด


### กรณีที่ 3: Idempotent Payment API ด้วย Python (FastAPI)

**Problem:** Client อาจ retry คำขอชำระเงินเมื่อ network error ทำให้เกิดการตัดเงินซ้ำ

**Solution:** ใช้ `Idempotency-Key` + database UNIQUE constraint ภายใน transaction เดียวกัน:

```python
import uuid
from fastapi import FastAPI, Header, HTTPException
from pydantic import BaseModel
import psycopg2

app = FastAPI()

class PaymentRequest(BaseModel):
    amount: float
    currency: str

@app.post("/payments")
def create_payment(
    body: PaymentRequest,
    idempotency_key: str = Header(..., alias="Idempotency-Key"),
    conn=...  # database connection
):
    with conn:  # transaction
        with conn.cursor() as cur:
            # 1) พยายามบันทึก idempotency key (UNIQUE constraint จะกันซ้ำ)
            cur.execute(
                """
                INSERT INTO idempotency_keys (key, status)
                VALUES (%s, 'in_progress')
                ON CONFLICT (key) DO NOTHING
                RETURNING key
                """,
                (idempotency_key,),
            )
            inserted = cur.fetchone()

            if not inserted:
                # key ซ้ำ: คืน response เดิม
                cur.execute(
                    "SELECT response_body, status_code FROM idempotency_keys WHERE key = %s",
                    (idempotency_key,),
                )
                saved = cur.fetchone()
                if saved and saved[0]:
                    return saved[0]
                raise HTTPException(409, "Request already in progress")

            # 2) ประมวลผล payment จริง
            payment_id = str(uuid.uuid4())
            response = {
                "payment_id": payment_id,
                "amount": body.amount,
                "status": "created",
            }

            # 3) บันทึกผลลัพธ์กลับไปที่ idempotency key
            cur.execute(
                """
                UPDATE idempotency_keys
                SET status = 'completed', response_body = %s, status_code = 201
                WHERE key = %s
                """,
                (response, idempotency_key),
            )
            return response
```

**หลักการสำคัญ:**
- UNIQUE constraint บน `idempotency_keys.key` รับประกันว่ามีเพียงคำขอเดียวที่แทรกแถวสำเร็จ แม้มาพร้อมกัน
- การบันทึก key และการประมวลผล payment อยู่ใน **transaction เดียวกัน** เพื่อให้ atomic
- คำขอที่ซ้ำจะได้รับ response เดิม ไม่ใช่การประมวลผลใหม่

**Result:** Client สามารถ retry ได้อย่างปลอดภัยโดยไม่เกิดการตัดเงินซ้ำ


### กรณีที่ 4: Crash Recovery ด้วย WAL

**Problem:** ระบบล่มกลางคันหลัง `COMMIT` แต่ก่อนที่ data file จะถูกเขียนลง disk

**Solution:** PostgreSQL เขียน WAL ก่อน (`Write-Ahead Logging`) เมื่อ commit และ `fsync` ถูกเปิด WAL จะถูก flush ลง disk ทำให้เมื่อระบบกลับมา crash recovery สามารถ replay WAL เพื่อทำซ้ำ transaction ที่ commit แล้วแต่ยังไม่ถูกเขียนลง data file

**Result:** Transaction ที่ commit แล้วไม่สูญหาย และ database กลับสู่ state ที่สอดคล้องกัน


### กรณีที่ 5: การใช้ CHECK Constraint บังคับกฎธุรกิจ

**Problem:** ต้องการป้องกันไม่ให้บันทึกปริมาณสินค้าติดลบในตาราง `order_items`

**Solution:**
```sql
ALTER TABLE order_items
ADD CONSTRAINT order_items_quantity_check CHECK (quantity > 0);
```

เมื่อมีคำสั่ง `INSERT` ที่ `quantity = -2` ฐานข้อมูลจะปฏิเสธทันที และ transaction ทั้งหมดจะ abort หากไม่มีการจัดการ error ที่เหมาะสม

**Result:** ข้อมูลที่ไม่ถูกต้องไม่สามารถเข้าสู่ฐานข้อมูลได้ แม้ application จะมี bug


## แหล่งอ้างอิง (เล่ม 2)

### ACID
- PostgreSQL 16 Documentation, *Appendix M. Glossary* — นิยาม ACID ว่าเป็นชุดคุณสมบัติที่รับประกันความถูกต้องภายใต้ concurrency และความล้มเหลว; นิยาม Atomicity; นิยาม Durability
- AWS, *Oracle transaction model and PostgreSQL transactions* — คำอธิบาย Atomicity และ Durability ในบริบท PostgreSQL

### Transaction Control
- PostgreSQL Documentation (via Stack Overflow) — เมื่อเกิด error ภายใน transaction PostgreSQL จะ abort และต้อง `ROLLBACK` อย่างชัดเจน
- Dalibo, *PostgreSQL Transactions* — ทุก transaction ที่เริ่มด้วย BEGIN ต้องจบด้วย COMMIT หรือ ROLLBACK

### Constraints
- PostgreSQL Documentation, *52.13. pg_constraint* — รหัสประเภท constraint: c=check, f=FK, n=not-null, p=PK, u=unique, t=trigger, x=exclusion
- PostgreSQL Documentation — PK เทียบเท่า UNIQUE + NOT NULL

### MVCC และ Isolation
- CODECRUNCH, *Lecture 3 — MVCC, Locking, and Deadlocks* — หลักการ MVCC: "readers don't block writers, writers don't block readers"; `xmin`/`xmax`; `FOR UPDATE` ป้องกัน lost update; `SKIP LOCKED` สำหรับ work queue
- Microsoft Learn, *MVCC and snapshots* — `xmin` = transaction visible since, `xmax` = visible until

### Deadlock
- PostgreSQL Documentation, *19.12. Lock Management* — `deadlock_timeout` ค่าเริ่มต้น 1 วินาที
- CODECRUNCH, *Lecture 3* — deadlock คือ circular wait; PostgreSQL abort victim พร้อม SQLSTATE 40P01

### WAL / Recovery / Replication
- PostgreSQL Documentation, *19.5. Write Ahead Log* — `wal_level`, `fsync`, `synchronous_commit`; `fsync` ป้องกัน corruption หลัง crash
- Cybrosys, *Streaming Replication* — streaming replication ส่ง WAL ไปยัง standby อย่างต่อเนื่อง

### Idempotency
- AWS Well-Architected Framework — การใช้ idempotency token เพื่อ distinguishing new vs repeated requests; เก็บ token + response; คืน response เดิมเมื่อ token ซ้ำ; ระบุ operation ที่ต้องมี idempotency (POST, PUT, DELETE)
- DEV Community, *A practical guide to idempotency keys* — persist (TenantId, IdempotencyKey) ด้วย UNIQUE constraint; request hash; `Idempotency-Replayed` header
- Huawei Cloud, *Idempotency Keys, Unique Constraints, and Atomic Writes* — business record และ idempotency result ต้องอยู่ใน transaction เดียวกัน พร้อม UNIQUE constraint บน idempotency identity
- GitHub, *ACID Guarantees and Idempotency* — ใช้ UNIQUE constraint บน key column เพื่อความปลอดภัยจาก race condition; wrap check + operation ใน transaction เดียวกัน

---

**สรุปแก่นของเล่ม 2:** ความน่าเชื่อถือของระบบธุรกรรมไม่ได้มาจากกลไกใดกลไกหนึ่ง แต่มาจาก **การทำงานร่วมกันของ ACID, constraints, concurrency control, WAL/recovery และ idempotency** ในทุกชั้นของระบบ ตั้งแต่ฐานข้อมูลไปจนถึง API layer การออกแบบที่ถูกต้องต้องทำให้กลไกเหล่านี้ **บังคับใช้กฎธุรกิจซ้ำซ้อนกัน** (defense in depth) เพื่อให้แม้ชั้นหนึ่งล้มเหลว ชั้นอื่นยังคงรักษาความถูกต้องของข้อมูลไว้ได้