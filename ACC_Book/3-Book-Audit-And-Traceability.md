# เล่ม 3: Audit และการตรวจสอบย้อนกลับ (Audit, Audit Log, Auditing Transaction Cycles)

## บทนำ

### คืออะไร
คู่มือเล่มนี้ว่าด้วย **ชั้นการตรวจสอบ** ที่ทำให้ระบบธุรกรรมทางการเงินและบัญชี (เล่ม 1) และกลไกความน่าเชื่อถือทางเทคนิค (เล่ม 2) กลายเป็นระบบที่ **“พิสูจน์ได้”** ว่าใครทำอะไร เมื่อไร กับข้อมูลอะไร ผลลัพธ์เป็นอย่างไร และข้อมูลนั้นไม่ถูกแก้ไขย้อนหลังโดยไม่ได้รับอนุญาต ครอบคลุมตั้งแต่ Audit, Audit Log, องค์ประกอบของบันทึกการตรวจสอบ, tamper-evident logging ไปจนถึงการตรวจสอบ transaction cycles ตามข้อกำหนดของมาตรฐานสากล

### คำนำ
ระบบการเงินที่ “ถูกต้อง” แต่ “พิสูจน์ไม่ได้” ยังคงเป็นระบบที่มีความเสี่ยง เมื่อเกิดข้อพิพาท การทุจริต หรือการตรวจสอบจากหน่วยงานกำกับดูแล องค์กรต้องสามารถแสดง **หลักฐานที่เชื่อถือได้** ว่าทุกรายการเกิดขึ้นจริง ได้รับอนุมัติ และไม่ถูกแก้ไขย้อนหลัง คู่มือเล่มนี้จึงวาง Audit ไว้เป็น **ความสามารถที่ต้องออกแบบตั้งแต่ต้น** (audit-by-design) ไม่ใช่สิ่งที่เพิ่มเข้ามาภายหลัง

### วัตถุประสงค์
1. อธิบายความหมาย วัตถุประสงค์ และองค์ประกอบขั้นต่ำของ Audit Log ตามมาตรฐาน NIST SP 800-92 และ NIST SP 800-53 (AU-3)
2. อธิบายหลักการ **tamper-evident / append-only** และการใช้งาน hash chain ในระบบการเงิน
3. อธิบาย **transaction cycle assertions** ตาม ISA 315 (Revised 2019) และวิธีเชื่อม audit เข้ากับวงจรต่างๆ
4. เชื่อม Audit เข้ากับกรอบ **COSO Internal Control** และข้อกำหนด **SOX Section 404 / PCAOB AS 2201**
5. ยกตัวอย่างการออกแบบ audit log และกรณีศึกษา 3–5 กรณี

### เป้าหมาย
ผู้อ่านสามารถ **ออกแบบ audit trail ที่ตอบโจทย์การตรวจสอบภายใน/ภายนอก** และรองรับข้อกำหนดด้าน compliance ได้ โดยเฉพาะในระบบการเงิน-บัญชีที่มีความเสี่ยงสูง

### ความรู้พื้นฐาน
- พื้นฐานระบบฐานข้อมูล (จากเล่ม 2: transaction, constraint, MVCC)
- พื้นฐานกระบวนการทางบัญชี (จากเล่ม 1: transaction cycle, double-entry)
- ความเข้าใจเบื้องต้นเรื่อง internal control และการตรวจสอบ


## บทนิยาม

### 1. Audit และ Audit Log

**Audit** คือกระบวนการตรวจสอบอย่างเป็นระบบว่า operation ต่างๆ ถูกต้อง เป็นไปตามกฎ และสามารถพิสูจน์ได้ด้วยหลักฐาน

**Audit Log** คือบันทึกเหตุการณ์ (event record) ที่เกิดขึ้นในระบบ โดยมีเป้าหมายเพื่อให้ผู้ตรวจสอบ ผู้กำกับดูแล หรือผู้สอบสวนสามารถตอบคำถามได้ว่า **เกิดอะไรขึ้น ใครเป็นผู้ริเริ่ม และผลลัพธ์คืออะไร** Audit log ที่ดีต้องเป็น **append-only** และสามารถ **ตรวจสอบย้อนกลับได้**

**ทำไมต้องเป็นแบบนี้:** NIST SP 800-92 ระบุว่า audit log “บอกผู้สอบสวน ผู้ตรวจสอบ ลูกค้า หรือผู้กำกับดูแลว่าเกิดอะไรขึ้นและใครหรืออะไรเป็นผู้ริเริ่ม” และ log management คือกระบวนการสร้าง ส่ง จัดเก็บ เข้าถึง และกำจัด log data อย่างเป็นระบบ

**เพื่ออะไร / ประโยชน์:**
- **การสอบสวนและนิติวิทยาศาสตร์ดิจิทัล (forensic analysis):** ระบุ security incidents, policy violations, fraudulent activity
- **การตรวจสอบและธรรมาภิบาล:** ผู้ตรวจสอบใช้ log data เมื่อ performing audits; เจ้าหน้าที่ compliance ใช้ verifying compliance หรือ documenting evidence
- **การปฏิบัติตามกฎหมาย/ข้อบังคับ:** SOX, PCI DSS, GDPR และอื่นๆ กำหนดให้มี audit trail สำหรับระบบที่มีผลต่อข้อมูลทางการเงิน

**กลุ่มเป้าหมาย:** ผู้ตรวจสอบภายใน/ภายนอก, เจ้าหน้าที่ compliance, ผู้ดูแลระบบ, ทีมตอบสนองเหตุการณ์, ผู้พัฒนาแอปพลิเคชัน, และผู้บริหารที่ต้องรับผิดชอบต่อรายงานทางการเงิน


### 2. องค์ประกอบขั้นต่ำของ Audit Record (What, When, Where, Source, Outcome, Identity)

**คืออะไร:** มาตรฐาน NIST SP 800-53 (AU-3) กำหนดว่า audit record ต้องมีข้อมูลเพียงพอที่จะระบุ **ประเภทของเหตุการณ์, เวลา, สถานที่, แหล่งที่มา, ผลลัพธ์ และตัวตนของผู้ที่เกี่ยวข้อง**

**รายละเอียดตาม AU-3:**

| องค์ประกอบ | คำอธิบาย | ตัวอย่างในระบบการเงิน |
|---|---|---|
| **What type of event** | ประเภทของเหตุการณ์ | `PAYMENT_CREATED`, `INVOICE_UPDATED`, `LOGIN_FAILED` |
| **When** | เวลาที่เกิดเหตุการณ์ (timestamp) | ISO 8601 UTC พร้อม timezone |
| **Where** | สถานที่/ระบบ/โฮสต์ที่เกิดเหตุการณ์ | `payment-service`, `db-prod-01` |
| **Source** | แหล่งที่มาของเหตุการณ์ | IP address, service name, user agent |
| **Outcome** | ผลลัพธ์ของเหตุการณ์ | `success`, `failure`, `denied` |
| **Identity** | ตัวตนของผู้ใช้/process ที่เกี่ยวข้อง | `user_id`, `service_account`, `session_id` |

**Additional Information (AU-3(1)):** อาจรวม time stamps, source/destination addresses, user/process identifiers, event descriptions, success/fail indications, filenames involved, และ access control rules ที่ถูกเรียกใช้

**Insight:** OWASP Logging Cheat Sheet สรุปสั้นๆ ว่า application log ต้องบันทึก **“when, where, who and what”** สำหรับทุก event ซึ่งสอดคล้องกับ AU-3


### 3. Tamper-Evident และ Append-Only Audit Log

**คืออะไร:**
- **Append-only:** เขียนได้อย่างเดียว ห้าม update หรือ delete ข้อมูลที่บันทึกแล้ว
- **Tamper-evident:** แม้จะมีผู้พยายามแก้ไขข้อมูลย้อนหลัง ระบบสามารถ **ตรวจจับการแก้ไขนั้นได้** (ไม่ใช่ป้องกันไม่ให้แก้ แต่ทำให้การแก้ไข “มองเห็นได้”)

**หลักการทำงาน:**
- ใช้ **cryptographic hash chain** เช่น SHA-256: แต่ละ record เก็บ hash ของ record ก่อนหน้า (หรือ hash ของ内容和 record ก่อนหน้า) ทำให้หากแก้ไข record ใด record หนึ่ง hash ของ record ถัดไปจะเปลี่ยนไปด้วย และการตรวจสอบจะล้มเหลว
- **Merkle tree** และ **external anchoring** ทำให้การปลอมแปลงย้อนหลังของ anchored events ถูกตรวจจับได้ และผู้ตรวจสอบสามารถ validate subset ของ events ได้อย่างอิสระด้วย hash-chain และ Merkle proofs
- **Blockchain tables** (เช่นใน Oracle) ใช้ row-level cryptographic chaining: แต่ละ row เชื่อมกับ row ก่อนหน้าด้วย hash ทำให้ append-only inserts ป้องกัน update/delete และรักษา cryptographic chain ของ row ไว้

**ตัวอย่างมาตรฐาน:** VeritasChain Protocol (VCP) ใช้ SHA-256 hash chains และ UUIDv7 timestamps ตามลำดับเวลา เพื่อสร้าง tamper-evident, append-only records ที่บุคคลที่สามสามารถ verify ได้โดยไม่ต้องเชื่อถือผู้เก็บ record

**ทำไมต้องเป็นแบบนี้:** ในระบบการเงิน หลักฐานที่ “แก้ไขได้” โดยผู้ดูแลระบบหรือ attacker จะมีน้ำหนักน้อยมากในการตรวจสอบ SOX auditors ต้องการ “full history: the actual SQL statement, who requested it, who approved it, the business justification, and the timestamp” และต้องเป็นหลักฐานที่ไม่สามารถสร้างย้อนหลังได้ (cannot be retroactively created)


### 4. Auditing Transaction Cycles และ Assertions

**Transaction Cycle** คือกลุ่มของ transaction ที่เกี่ยวข้องกันซึ่งไหลผ่านระบบการเงิน-บัญชี ได้แก่:
- **Revenue Cycle** (วงจรรายได้): การขาย การเรียกเก็บเงิน เงินสดรับ
- **Expenditure Cycle** (วงจรรายจ่าย): การจัดซื้อ การจ่ายเงิน
- **Payroll Cycle** (วงจรเงินเดือน): การจ่ายค่าจ้าง
- **Inventory / Production Cycle** (วงจรสินค้าคงคลัง/การผลิต): การผลิต การคิดต้นทุน

**Assertions ตาม ISA 315 (Revised 2019):** ผู้ตรวจสอบใช้ assertions เป็นกรอบในการออกแบบ процедуรวบรวมหลักฐานว่าข้อมูลในงบการเงินถูกต้อง

**Assertions เกี่ยวกับ classes of transactions และ events (สำหรับรอบระยะเวลาที่ตรวจสอบ):**

| Assertion | ความหมาย | ความเสี่ยงที่พบบ่อย |
|---|---|---|
| **Occurrence** | transaction ที่บันทึกหรือเปิดเผยได้ **เกิดขึ้นจริง** และเป็นของกิจการนั้น | รายการที่ไม่มีอยู่จริง (fictitious transactions) |
| **Completeness** | transaction ทั้งหมดที่ **ควรบันทึกได้ถูกบันทึกครบถ้วน** | รายการที่เกิดขึ้นแต่ไม่ถูกบันทึก (understatement) |
| **Accuracy** | จำนวนเงินและข้อมูลอื่นๆ ถูกบันทึกอย่างเหมาะสม | จำนวนเงินผิด, คำนวณผิด |
| **Cut-off** | transaction ถูกบันทึกใน **รอบระยะเวลาบัญชีที่ถูกต้อง** | บันทึกข้ามงวด (window dressing) |
| **Classification** | บันทึกในบัญชีที่เหมาะสม | บันทึกผิดหมวด |
| **Presentation** | การรวม/แยกและการเปิดเผยเหมาะสม | การเปิดเผยไม่ครบ |

**Assertions เกี่ยวกับ account balances (ณ วันสิ้นงวด):** Existence, Rights and obligations, Completeness, Accuracy/valuation/allocation, Classification, Presentation

**Insight:** Audit log ที่ดีต้องช่วยให้ผู้ตรวจสอบ **ทดสอบ assertions เหล่านี้ได้** ตัวอย่างเช่น:
- **Occurrence:** audit log แสดงว่า transaction ถูกสร้างโดย authorized user จริง
- **Completeness:** audit log แสดงทุก transaction ที่เข้าระบบ รวมถึงที่ล้มเหลว
- **Cut-off:** audit log มี timestamp ที่เชื่อถือได้และ synchronized


### 5. ความเชื่อมโยงกับ COSO และ SOX 404 / PCAOB AS 2201

**COSO Internal Control – Integrated Framework** นิยาม internal control ว่าเป็นกระบวนการที่ให้ **reasonable assurance** เกี่ยวกับ operations, reporting, และ compliance ในบริบททางบัญชี control ครอบคลุม assertion ด้าน **Accuracy** (จำนวนเงิน) และ **Integrity** (posted records cannot be altered without an audit trail) หนึ่งในห้าองค์ประกอบของ COSO คือ **Information and Communication** ซึ่งครอบคลุม audit trail และ reporting ที่ทำให้คนที่เหมาะสมเห็นและดำเนินการกับข้อมูลที่ถูกต้อง

**SOX Section 404** กำหนดให้บริษัทมหาชนมี internal control over financial reporting และให้ตรวจสอบประจำปี ระบบที่แตะต้องข้อมูลทางการเงินอยู่ใน scope และ auditors ตรวจสอบ **IT General Controls (ITGC)** 4 ด้าน ได้แก่ change management, access controls, **audit trail**, และ program development

**สิ่งที่ auditors ต้องการจาก audit trail (SOX/ITGC):**
- ประวัติเต็ม: SQL statement จริง, ใครขอ, ใครอนุมัติ, business justification, และ timestamp
- หลักฐานต่อเนื่อง 12–18 เดือนก่อนการยื่นไฟลิ่ง
- ทุก action tied to individual identity (ไม่ใช่ shared credentials)
- Approval chain ที่บันทึกในระบบก่อน SQL execute (ไม่ใช่ screenshot จาก chat)

**PCAOB AS 2201** กำหนดข้อกำหนดสำหรับการตรวจสอบ internal control over financial reporting ที่ integrate กับการตรวจสอบงบการเงิน และ ITGC (logical access, change management, program development, computer operations) ต้องได้รับการสนับสนุนด้วย **documented evidence** ไม่ใช่แค่คำอธิบายกระบวนการ


## หลักการทำงาน (Concept)

### Audit-by-Design: Audit ต้องถูกออกแบบพร้อมกับระบบ

Audit ที่ดีไม่ใช่การเพิ่ม log ทีหลัง แต่ต้องถูกออกแบบให้ **ฝังอยู่ในทุกชั้น** ของระบบ:

```
┌──────────────────────────────────────────────────────────────┐
│  ชั้นที่ 1: Application Layer                                │
│  - บันทึก business events (เช่น PAYMENT_CREATED)             │
│  - ระบุ actor, action, entity, before/after                 │
└─────────────────────┬────────────────────────────────────────┘
                      ▼
┌──────────────────────────────────────────────────────────────┐
│  ชั้นที่ 2: Database Layer                                    │
│  - Trigger / Change Data Capture (CDC)                       │
│  - บันทึก DML/DDL ที่กระทบข้อมูลทางการเงิน                   │
│  - บังคับใช้ constraints (จากเล่ม 2)                         │
└─────────────────────┬────────────────────────────────────────┘
                      ▼
┌──────────────────────────────────────────────────────────────┐
│  ชั้นที่ 3: Audit Log Store (Append-Only + Tamper-Evident)   │
│  - Hash chain (SHA-256) + Merkle tree                        │
│  - Timestamp ที่ synchronized (NTP/PTP)                      │
│  - External anchoring (ถ้าต้องการ)                           │
└─────────────────────┬────────────────────────────────────────┘
                      ▼
┌──────────────────────────────────────────────────────────────┐
│  ชั้นที่ 4: Access & Retention                               │
│  - RBAC: เฉพาะผู้มีสิทธิ์เข้าถึง audit log                   │
│  - Retention: ตามกฎหมาย/สัญญา + ลบอย่างปลอดภัย              │
│  - Monitoring: ตรวจสอบว่า logging ไม่หยุด                    │
└──────────────────────────────────────────────────────────────┘
```

### หลักการสำคัญ 3 ข้อ

**1. บันทึกให้ครบแต่ไม่มากเกินไป (Data Minimization)**
OWASP แนะนำว่าไม่ควรบันทึก access tokens หรือ session identifiers โดยตรง แต่ให้ลบ, mask, sanitize, hash หรือ encrypt และ NIST SP 800-92 กล่าวถึง data minimization เป็นหลักการ

**2. เวลาต้องเชื่อถือได้ (Synchronized Time)**
OWASP ระบุว่า “Synchronize time across all servers and devices” เพราะ timestamp ที่ไม่ตรงกันทำให้ไม่สามารถ correlate กับแหล่งอื่นได้ VCP ใช้ UUIDv7 ที่เรียงตามเวลาและ ISO 8601 + int64 nanoseconds เพื่อความแม่นยำ

**3. ตรวจสอบได้โดยไม่ต้องเชื่อใจผู้เก็บ (Trustless Verification)**
Audit log ที่ดีต้องอนุญาตให้บุคคลที่สาม (ผู้ตรวจสอบ, regulator) verify integrity ได้โดยไม่ต้องเชื่อถือผู้ดูแลระบบ VCP กล่าวชัดว่า “any third party can verify—from regulators to auditors to market participants—without trusting the record keeper”


## Workflow และ Dataflow (แบบ PSR)

### Problem (ปัญหา)
เมื่อเกิดข้อพิพาททางการเงิน องค์กรไม่สามารถพิสูจน์ได้ว่า:
- ใครแก้อะไร เมื่อไร และเพราะอะไร
- ข้อมูลก่อน/หลังการแก้ไขเป็นอย่างไร
- การแก้ไขได้รับอนุมัติหรือไม่
- Audit log ถูกแก้ไขย้อนหลังหรือไม่

นอกจากนี้ ผู้ตรวจสอบภายนอก (SOX/PCAOB) ต้องการหลักฐานต่อเนื่อง 12–18 เดือน และต้องการเห็น **full history** ของการเปลี่ยนแปลงข้อมูลทางการเงิน ไม่ใช่แค่สถานะสุดท้าย

### Solution (วิธีแก้)
ออกแบบ **Audit Trail 4 ชั้น**:
1. **Application-level audit:** บันทึก business events ทุกครั้งที่มีการสร้าง/แก้ไข/ลบข้อมูลสำคัญ พร้อม `actor`, `action`, `entity`, `before`, `after`, `outcome`, `timestamp`, `source`
2. **Database-level audit:** ใช้ trigger หรือ CDC บันทึก DML/DDL ที่กระทบตารางทางการเงิน พร้อม `who requested`, `who approved`, `business justification`
3. **Tamper-evident storage:** เขียน audit entry ลง **append-only store** พร้อม **SHA-256 hash chain** (แต่ละ entry เก็บ hash ของ entry ก่อนหน้า) และใช้ **Merkle tree** สำหรับการ verify แบบ batch
4. **Access & Retention controls:** ใช้ RBAC จำกัดผู้เข้าถึง; กำหนด retention ตามกฎหมาย; monitor ว่า logging ไม่หยุด; alert เมื่อพบความพยายามแก้ไข audit log

### Result (ผลลัพธ์)
- สามารถตอบคำถาม auditors ได้ทันที: “Who ran this DML on the production financial database on March 14th?”
- มีหลักฐานต่อเนื่องที่ไม่สามารถสร้างย้อนหลังได้
- การแก้ไข audit log ถูกตรวจจับได้ด้วย hash chain
- ผ่านข้อกำหนด SOX ITGC ด้าน audit trail และ PCAOB AS 2201 documentation requirements


## บทสรุป

### ประโยชน์ที่ได้รับ
- เข้าใจองค์ประกอบขั้นต่ำของ audit record ตาม NIST AU-3 (what, when, where, source, outcome, identity)
- สามารถออกแบบ audit log แบบ tamper-evident ด้วย hash chain และ append-only store
- เข้าใจวิธีเชื่อม audit เข้ากับ transaction cycle assertions (occurrence, completeness, accuracy, cut-off, classification)
- สามารถเตรียมระบบให้พร้อมสำหรับการตรวจสอบ SOX 404 / PCAOB AS 2201

### ข้อควรระวัง
- **เวลา:** ต้อง synchronize clock across systems มิฉะนั้น audit log จะ correlate ไม่ได้
- **ข้อมูลอ่อนไหว:** ห้ามบันทึก access tokens หรือ session identifiers โดยตรง; ต้อง mask/hash/encrypt
- **Retention มีสองขอบ:** ต้องไม่ทำลาย log ก่อนครบกำหนด และต้องไม่เก็บนานเกินความจำเป็น
- **Audit log ต้องอยู่นอกระบบที่ถูกตรวจสอบ:** ควรส่ง log ไปยังระบบแยก (SIEM หรือ centralized log) และจำกัดสิทธิ์การลบ
- **Hash chain ต้องต่อเนื่อง:** log ที่ chained เป็นบางช่วงไม่ใช่หลักฐานที่สมบูรณ์

### ข้อจำกัด
- Tamper-evident ไม่ได้ป้องกันการแก้ไข แต่ทำให้ **ตรวจจับได้** — ต้องมีกระบวนการตอบสนองเมื่อตรวจพบ
- Hash chain ในระบบ distributed ต้องจัดการ concurrency (global lock หรือ per-process chain) ซึ่งมี trade-off ด้าน performance
- Audit log ที่มากเกินไป会增加ต้นทุนพื้นที่และทำให้วิเคราะห์ยาก — ต้องเลือกบันทึกเฉพาะเหตุการณ์ที่มีนัยสำคัญ (AU-2 event logging)

### ข้อห้าม
- ห้ามใช้ shared credentials ในระบบที่ต้องมี audit trail — ทุก action ต้อง tied to individual identity
- ห้ามอนุมัติ change ใน chat/standup โดยไม่มี system of record — auditors ต้องการ approval chain ที่บันทึกไว้ก่อน execute
- ห้ามลบ audit log ก่อนครบ retention period
- ห้ามถือว่า log ที่ไม่มีการป้องกัน integrity เป็น “หลักฐาน” ที่เชื่อถือได้


## ตัวอย่างการใช้งานจริง 3–5 กรณี

### กรณีที่ 1: Audit Log Entry สำหรับการอนุมัติใบแจ้งหนี้

**Problem:** ต้องการพิสูจน์ว่าใบแจ้งหนี้ INV-001 ถูกเปลี่ยนสถานะจาก `pending` เป็น `approved` โดยผู้มีอำนาจ และไม่ถูกแก้ไขย้อนหลัง

**Solution:** สร้าง structured audit entry พร้อม hash chain:

```json
{
  "event_id": "018f3c2e-7b1a-7c3d-9e4f-2a1b3c4d5e6f",
  "timestamp": "2026-11-24T10:15:30.123456789Z",
  "event_type": "INVOICE_STATUS_CHANGED",
  "actor": {
    "user_id": "u-1001",
    "role": "finance_manager",
    "auth_method": "sso"
  },
  "entity": {
    "type": "invoice",
    "id": "INV-001"
  },
  "action": "UPDATE",
  "before": { "status": "pending" },
  "after": { "status": "approved" },
  "outcome": "success",
  "source": {
    "ip": "203.0.113.10",
    "service": "invoice-service",
    "host": "app-prod-03"
  },
  "context": {
    "correlation_id": "req-abc-123",
    "business_justification": "PO-2026-0456 approved by procurement"
  },
  "prev_hash": "a3f5...9c2d",
  "hash": "e7b1...4f8a"
}
```

**การคำนวณ hash:** `hash = SHA256(prev_hash || canonical_json(event_without_hash))` และเก็บ `prev_hash` ของ entry ก่อนหน้าไว้ใน entry ใหม่ ทำให้เกิด chain

**Result:** ผู้ตรวจสอบสามารถ verify integrity ของ chain ได้ และเห็น before/after ชัดเจน


### กรณีที่ 2: การใช้ Trigger บันทึก Database Change สำหรับ SOX

**Problem:** SOX auditors ต้องการเห็นทุก DML ที่แก้ไขตาราง `invoices` พร้อมผู้ขอ ผู้อนุมัติ และ justification

**Solution:** สร้างตาราง `audit_log` แบบ append-only และ trigger บน `invoices`:

```sql
CREATE TABLE audit_log (
    id BIGSERIAL PRIMARY KEY,
    table_name TEXT NOT NULL,
    operation TEXT NOT NULL,
    row_id TEXT NOT NULL,
    changed_by TEXT NOT NULL,
    approved_by TEXT,
    justification TEXT,
    old_data JSONB,
    new_data JSONB,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    prev_hash TEXT,
    hash TEXT NOT NULL
);

CREATE OR REPLACE FUNCTION log_invoice_change()
RETURNS TRIGGER AS $$
DECLARE
    prev TEXT;
    new_hash TEXT;
BEGIN
    SELECT hash INTO prev FROM audit_log ORDER BY id DESC LIMIT 1;
    new_hash := encode(
        digest(
            coalesce(prev, '') || row_to_json(NEW)::text || clock_timestamp()::text,
            'sha256'
        ),
        'hex'
    );

    INSERT INTO audit_log (
        table_name, operation, row_id, changed_by, old_data, new_data, prev_hash, hash
    ) VALUES (
        TG_TABLE_NAME, TG_OP, NEW.id::text,
        current_setting('app.user_id'),
        CASE WHEN TG_OP = 'UPDATE' THEN row_to_json(OLD)::jsonb ELSE NULL END,
        row_to_json(NEW)::jsonb,
        prev, new_hash
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_invoice_audit
AFTER INSERT OR UPDATE ON invoices
FOR EACH ROW EXECUTE FUNCTION log_invoice_change();
```

**หมายเหตุ:** ในระบบจริง ควรใช้ `pgcrypto` สำหรับ `digest()` และควรéviter การ query `ORDER BY id DESC LIMIT 1` ใน trigger สำหรับระบบที่มี concurrency สูง ควรใช้ approach ที่ปลอดภัยกว่า (เช่น per-row chain หรือ advisory lock) ตัวอย่างนี้แสดงหลักการ

**Result:** ทุกการเปลี่ยนแปลงใน `invoices` ถูกบันทึกพร้อม hash chain; auditors สามารถ query เพื่อดู full history ได้


### กรณีที่ 3: การทดสอบ Cut-off ด้วย Audit Log

**Problem:** ผู้ตรวจสอบต้องการทดสอบว่า revenue ถูกบันทึกในรอบระยะเวลาที่ถูกต้อง (cut-off) โดยเฉพาะรายการใกล้สิ้นปี

**Solution:** ใช้ audit log ที่มี timestamp ที่เชื่อถือได้ เปรียบเทียบ `event_timestamp` (เวลาที่เกิดธุรกรรมจริง เช่น การส่งมอบสินค้า) กับ `posting_timestamp` (เวลาที่บันทึกบัญชี) หากทั้งสองต่างกันข้ามปี ให้ตรวจสอบเพิ่มเติม

**Result:** สามารถระบุรายการที่อาจถูกบันทึกผิดงวด และทดสอบ cut-off assertion ได้อย่างเป็นระบบ


### กรณีที่ 4: การตรวจสอบ Integrity ของ Audit Log ด้วย Hash Chain

**Problem:** ต้องการพิสูจน์ว่า audit log ไม่ถูกแก้ไขย้อนหลัง

**Solution:** เขียนฟังก์ชัน verify ที่คำนวณ hash ของแต่ละ entry ใหม่และเปรียบเทียบกับ `hash` ที่เก็บไว้ รวมถึงตรวจสอบว่า `prev_hash` ของ entry ที่ n ตรงกับ `hash` ของ entry ที่ n-1

```python
import hashlib
import json

def verify_chain(entries):
    prev = None
    for entry in entries:
        stored_hash = entry.pop("hash")
        stored_prev = entry.pop("prev_hash")

        if stored_prev != prev:
            return False, f"prev_hash mismatch at {entry['event_id']}"

        canonical = json.dumps(entry, sort_keys=True, separators=(",", ":"))
        recomputed = hashlib.sha256(
            ((prev or "") + canonical).encode()
        ).hexdigest()

        if recomputed != stored_hash:
            return False, f"hash mismatch at {entry['event_id']}"

        prev = stored_hash
    return True, "OK"
```

**Result:** หากมี entry ใดถูกแก้ไข แม้แต่ character เดียว hash จะเปลี่ยน และการ verify จะล้มเหลว ทำให้ตรวจพบการแก้ไขได้


### กรณีที่ 5: การตอบคำถาม SOX Auditor ด้วย Audit Trail

**Problem:** SOX auditor ถามว่า “Show me every database change made to your financial reporting systems in the last 12 months. Who approved each one, and why.”

**Solution:** ใช้ audit trail ที่มีฟิลด์:
- `who requested` (individual identity ผ่าน SSO)
- `who approved` (role-based workflow ที่ requester ≠ approver)
- `business justification`
- `SQL statement จริง`
- `timestamp`
- `approval chain` ที่บันทึกก่อน execute

**Result:** สามารถ export หลักฐาน 12–18 เดือนที่ต่อเนื่องและตรวจสอบได้ ตอบโจทย์ ITGC audit procedure โดยตรง


## แหล่งอ้างอิง (เล่ม 3)

### Audit Log และองค์ประกอบ
- NIST SP 800-92r1 (ipd), *Cybersecurity Log Management Planning Guide* — นิยาม log management, บทบาทของผู้ใช้ log, และหลักการ append-only
- NIST SP 800-53 AU-3, *Content of Audit Records* (via IBM Cloud Docs) — องค์ประกอบ what, when, where, source, outcome, identity
- OWASP Logging Cheat Sheet (via SecurityBoulevard) — “when, where, who and what”; ไม่บันทึก tokens/session IDs; retention สองขอบ; synchronize time
- Safeguard.sh, *What Should You Log to a SIEM* — AU-3 รายละเอียด, AU-11 retention, AU-6 review

### Tamper-Evident / Append-Only
- VeritasChain Protocol (VCP) Fact Sheet — SHA-256 hash chains, UUIDv7, append-only records, third-party verification without trusting record keeper
- ScienceDirect (Oracle Blockchain Tables) — row-level cryptographic chaining, append-only inserts, tamper detection
- VeritasChain, *What is VCP?* — Merkle trees, external anchoring, independent validation

### Transaction Cycles และ Assertions
- ACCA, *The audit of assertions* (ISA 315 Revised 2019) — Occurrence, Completeness, Accuracy, Cut-off, Classification, Presentation
- PASAA, *Financial Audit Manual Training Workshop* — existence, rights, completeness, accuracy, valuation, classification, cut-off; payroll cut-off tests
- Modern Auditing (Semantic Scholar) — audit objectives สำหรับ expenditure, payroll, production, revenue cycles

### COSO และ SOX/PCAOB
- COSO Internal Control – Integrated Framework (via Supervizor) — นิยาม internal control, integrity และ audit trail
- COSO (via Stampli) — Information and Communication ครอบคลุม audit trail และ reporting
- Bytebase, *Database Change Management for SOX Compliance* — SOX 404, ITGC 4 domains, audit trail requirements, 12–18 เดือนของหลักฐาน, 6 คำถามของ auditors
- PCAOB AS 2201 (via IFAC/PCAOB) — การตรวจสอบ ICFR ที่ integrate กับ financial statement audit
- Cloudapper, *SOX Auditors and IT General Controls* — PCAOB AS 2201 และ AS 2110 ต้องการ documented evidence สำหรับ ITGC

### IIA Standards (บริบทเพิ่มเติม)
- IIA Global Internal Audit Standards 2024 — ขยาย mandate ของ internal audit ไปยัง data governance และ technology-enabled control environments

---

**สรุปแก่นของเล่ม 3:** Audit ที่มีคุณภาพไม่ใช่ “log ที่มีข้อมูลเยอะ” แต่คือ **ระบบที่ออกแบบให้ตอบคำถามเชิงตรวจสอบได้** ว่าใครทำอะไร เมื่อไร ที่ไหน ผลลัพธ์เป็นอย่างไร และข้อมูลนั้นไม่ถูกแก้ไข โดยใช้ **AU-3 เป็นองค์ประกอบขั้นต่ำ**, **hash chain + append-only** เป็นกลไก tamper-evident, **ISA 315 assertions** เป็นกรอบทดสอบ transaction cycles, และ **COSO/SOX/PCAOB** เป็นกรอบ compliance ที่กำหนดว่าองค์กรต้องพิสูจน์อะไรได้จริง