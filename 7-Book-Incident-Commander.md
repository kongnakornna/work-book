## 📘 เล่ม 7 (ฉบับขยาย): คู่มือ Incident Commander / On-call
**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับสมบูรณ์ (ส่วนที่ 1, 2 และภาค 1–3)

> **หมายเหตุ:** เอกสารนี้เป็นฉบับขยายของเล่ม 7 ใน Master Index โดยเพิ่มรายละเอียดเชิงปฏิบัติที่จำเป็นสำหรับการทำงานจริง ได้แก่ On-call Rotation, Triage Decision Tree, Runbooks รายScenario, Escalation Matrix, Communication Templates, War Room Protocol และ Handover Procedure

---
## 7.0 บทนำและขอบเขต

คู่มือนี้ครอบคลุม **สองบทบาทที่เกี่ยวข้องกันแต่ต่างกัน**:

| บทบาท | หน้าที่หลัก | อยู่ใน Incident |
|--------|------------|-----------------|
| **On-call Engineer** | รับ Alert, Triage เบื้องต้น, Mitigate ระดับแรก | ทุก Incident |
| **Incident Commander (IC)** | บริหาร Incident, ตัดสินใจ, สื่อสาร, ประสานทีม | SEV-1 / SEV-2 |

**หลักการสำคัญ:** On-call Engineer อาจทำหน้าที่ IC ไปด้วยใน SEV-3/4 แต่ใน SEV-1/2 **ต้องแยกบทบาท** เพื่อไม่ให้คนเดียวรับภาระทั้งแก้ปัญหาและสื่อสาร

---

## 7.1 บทบาทและความรับผิดชอบ (ละเอียด)

### 7.1.1 On-call Engineer

**ก่อนเกิดเหตุ:**
- ศึกษา Runbook และ Architecture ของระบบที่รับผิดชอบ
- ทดสอบ Access: K8s, Azure Portal, Database, Log Platform
- ตรวจสอบ Alert Channel ว่าแจ้งเตือนมาถึงตนจริง
- รู้จัก Escalation Path และเบอร์ติดต่อของทีมที่เกี่ยวข้อง

**ขณะเกิดเหตุ:**
- ตอบ Alert ภายใน SLA (≤ 5 นาทีสำหรับ SEV-1/2)
- Triage ตาม Decision Tree (หัวข้อ 7.4)
- Mitigate เบื้องต้น (Rollback / Restart / Scale / Feature Flag)
- บันทึก Timeline ทุก Action
- Escalate เมื่อเกินขอบเขตหรือเกินเวลา

**หลังเกิดเหตุ:**
- Handover ให้กะถัดไป (ถ้ายังไม่จบ)
- บันทึก Incident Report
- เข้าร่วม RCA
- อัปเดต Runbook ตามบทเรียน

### 7.1.2 Incident Commander (IC)

**บทบาทหลัก 5 อย่าง:**

| บทบาท | รายละเอียด |
|-------|-----------|
| **Decision Maker** | ตัดสินใจ Mitigate / Rollback / Escalate — ไม่ต้องแก้เอง |
| **Coordinator** | แบ่งงานให้ทีม (Ops, Dev, DBA, Security) |
| **Communicator** | สื่อสาร Stakeholder ตามรอบ (ทุก 15/30 นาที) |
| **Timekeeper** | จับเวลาและเตือนเมื่อใกล้ SLA |
| **Scribe** | หรือมอบหมายให้คนอื่นบันทึก Timeline |

**IC ไม่ควร:** ลงมือแก้โค้ดเอง, Debug เชิงลึกเอง, หรือหายไปจากช่องทางสื่อสาร

---

## 7.2 On-call Rotation Structure

### 7.2.1 โครงสร้างกะ

```
┌─────────────────────────────────────────────────────────────┐
│                   ON-CALL ROTATION MODEL                    │
└─────────────────────────────────────────────────────────────┘

  Primary On-call (รับ Alert ก่อน)
         │
         │ ไม่ตอบใน 5 นาที / Escalate
         ▼
  Secondary On-call (สำรอง)
         │
         │ ไม่ตอบใน 10 นาที / เกินขอบเขต
         ▼
  Team Lead / Engineering Manager
         │
         │ เกินขอบเขตทางเทคนิค
         ▼
  Architect / Vendor Support (ถ้ามี)
```

### 7.2.2 ตาราง Rotation (ตัวอย่าง)

| สัปดาห์ | Primary | Secondary | IC Backup |
|---------|---------|-----------|-----------|
| W1 | Dev A | Dev B | Tech Lead |
| W2 | Dev B | Dev C | Tech Lead |
| W3 | Dev C | Dev A | Tech Lead |
| W4 | Dev A | Dev C | Tech Lead |

**หลักปฏิบัติ:**
- หมุนเวียนทุก 1 สัปดาห์ (จันทร์–จันทร์)
- มี **Handover Meeting** ทุกวันจันทร์ 09:00 (15 นาที)
- ห้าม On-call ติดกันเกิน 2 สัปดาห์
- มี **Compensatory Rest** หลัง SEV-1 ที่ลากยาวข้ามคืน

### 7.2.3 Handover Template

```markdown
# On-call Handover — [วันที่]

**จาก:** [ชื่อ] → **ถึง:** [ชื่อ]

## สถานะระบบปัจจุบัน
- Overall: 🟢 Green / 🟡 Yellow / 🔴 Red
- Incident ที่ยังเปิดอยู่: [INC-XXX] — สถานะ: [Mitigated/Monitoring]
- Alert ที่ Watch อยู่: [รายการ]

## สิ่งที่เกิดขึ้นในกะ
- [เหตุการณ์สำคัญ 1]
- [เหตุการณ์สำคัญ 2]

## สิ่งที่ต้องจับตา
- [ความเสี่ยง 1]
- [งานค้าง 1]

## Access / Credentials ที่เพิ่งเปลี่ยน
- [ถ้ามี]

## หมายเหตุ
- [อื่นๆ]
```

---

## 7.3 Severity Levels (ขยายพร้อมเกณฑ์ตัดสิน)

| Severity | เกณฑ์ตัดสิน | ตัวอย่าง | SLA Respond | SLA Mitigate | ใครต้องแจ้ง |
|----------|------------|----------|-------------|--------------|-------------|
| **SEV-1** | ระบบล่มทั้งหมด / >50% Error / Data Loss / Security Breach | Payment ล่ม, DB ล่ม, ข้อมูลรั่ว | ≤ 5 นาที | ≤ 15 นาที | IC + EM + Stakeholder + Exec |
| **SEV-2** | >10% Error / Performance วิกฤต / Feature หลักใช้ไม่ได้ | Dashboard โหลด >30s, Sync ERP ล่ม | ≤ 10 นาที | ≤ 30 นาที | IC + EM + Stakeholder |
| **SEV-3** | <10% Error / Feature รองเสีย / Workaround ได้ | Report บางตัวผิด, UI เพี้ยน | ≤ 30 นาที | ≤ 2 ชั่วโมง | IC + Team |
| **SEV-4** | Minor / Cosmetic / ไม่กระทบธุรกิจ | Tooltip ผิด, สีเพี้ยน | ≤ 4 ชั่วโมง | ≤ 1 วัน | Team |

**เกณฑ์ Escalate ขึ้น Severity:**
- กระทบมากกว่า 1 ทีม → +1 ระดับ
- มี Data Loss / Security → +1 ระดับ (ขั้นต่ำ SEV-2)
- เกิน SLA Mitigate → +1 ระดับ
- Stakeholder ร้องเรียน → พิจารณา +1 ระดับ

---

## 7.4 Triage Decision Tree

```
┌─────────────────────────────────────────────────────────────┐
│                    TRIAGE DECISION TREE                     │
└─────────────────────────────────────────────────────────────┘

  Alert Triggered
         │
         ▼
  ┌──────────────────┐
  │ ระบบยังใช้งานได้? │
  └────────┬─────────┘
           │
    ┌──────┴──────┐
   Yes            No
    │              │
    ▼              ▼
┌────────┐   ┌──────────────┐
│ Error  │   │ ระบบล่มทั้งหมด │──► SEV-1
│ Rate?  │   └──────────────┘
└───┬────┘
    │
┌───┴────┐
│ >10%?  │──Yes──► SEV-2
└───┬────┘
    │ No
    ▼
┌────────────┐
│ <10% แต่  │──Yes──► SEV-3
│ กระทบหลัก? │
└───┬────────┘
    │ No
    ▼
  SEV-4 (บันทึก + Fix ตามรอบ)
```

**คำถาม Triage 5 ข้อ (ตอบเร็วภายใน 2 นาที):**
1. ระบบยังตอบสนองได้ไหม? (Health Check)
2. Error Rate เท่าไหร่? (Metric)
3. กระทบผู้ใช้กี่คน / กลุ่มไหน? (Blast Radius)
4. มี Data Loss หรือไม่? (Integrity)
5. เพิ่ง Deploy อะไรไปหรือเปล่า? (Change Correlation)

---

## 7.5 Runbooks รายScenario (Practical)

### 7.5.1 Runbook: API Error Rate สูง (5xx)

```markdown
# Runbook: High 5xx Error Rate

## Trigger
- Alert: HighErrorRate (rate(http_requests_total{status=~"5.."}[5m]) > 0.01)

## ขั้นตอน (ทำตามลำดับ)

### Step 1: ยืนยันปัญหา (1 นาที)
- เปิด Grafana → Dashboard: API Health
- ตรวจ Error Rate, Latency, Pod Status
- ถ้า Error Rate < 1% → ปิด Alert, บันทึก

### Step 2: หา Scope (2 นาที)
- Error กระจายทุก Pod หรือ Pod เดียว?
  - Pod เดียว → Restart Pod นั้น
  - ทุก Pod → ไป Step 3
- Error เกิดที่ Endpoint ไหน? → ดู Log filter by path

### Step 3: Correlation กับ Change (2 นาที)
- มี Deploy ล่าสุดภายใน 1 ชั่วโมงไหม?
  - มี → Rollback (ดู 11.4)
  - ไม่มี → ไป Step 4

### Step 4: Dependency Check (3 นาที)
- DB: Connection Pool เต็มไหม? → ดู metric
- Redis: Down ไหม? → ping / ดู metric
- External API (Oracle ERP): Timeout ไหม? → ดู log
- ถ้า Dependency ล่ม → Circuit Breaker ทำงานไหม?

### Step 5: Mitigate
- Scale Up: kubectl scale deployment/pms-api --replicas=6
- หรือ Feature Flag ปิดฟีเจอร์ที่ทำให้ Error
- หรือ Rollback

### Step 6: ยืนยันและปิด
- Error Rate กลับ < 0.1% ต่อเนื่อง 10 นาที → Resolve
- บันทึก Timeline + Escalate ถ้าเกิน 15 นาที

## Escalation
- เกิน 15 นาทีไม่ mitigate → IC + Tech Lead
- เกิน 30 นาที → EM + Architect
```

### 7.5.2 Runbook: Database Connection Pool Exhausted

```markdown
# Runbook: DB Connection Pool Exhausted

## Trigger
- Alert: DBPoolExhausted
- อาการ: API ตอบช้า / 5xx / Timeout

## ขั้นตอน

### Step 1: ยืนยัน (1 นาที)
- ดู metric: db_pool_active / db_pool_max
- ดู Slow Query Log

### Step 2: หา Culprit (3 นาที)
- Query ไหนกิน Connection นาน? → pg_stat_activity
- มี Long-running transaction ไหม?
- มี Connection Leak ไหม? (Connection ไม่ถูก Return)

### Step 3: Mitigate ทันที
- Kill Long-running query:
  SELECT pg_terminate_backend(pid) FROM pg_stat_activity
  WHERE state = 'active' AND now() - query_start > interval '5 minutes';
- Restart Pod ที่ Leak (ถ้า Leak)
- เพิ่ม Pool Size ชั่วคราว (ถ้าจำเป็น)

### Step 4: แก้ที่ต้นเหตุ
- ถ้า Leak → Fix code (ensure close in finally)
- ถ้า Slow Query → เพิ่ม Index / Optimize

## Escalation
- เกิน 10 นาที → DBA + Tech Lead
- กระทบ Payment → SEV-1 ทันที
```

### 7.5.3 Runbook: Oracle ERP Sync ล่ม

```markdown
# Runbook: Oracle ERP Integration Failure

## Trigger
- Alert: IntegrationFailure (Oracle ERP)
- อาการ: ข้อมูลไม่ Sync / Payment ค้างสถานะ Pending

## ขั้นตอน

### Step 1: ตรวจสถานะ (2 นาที)
- ดู Integration Dashboard: success rate, latency
- ตรวจ Oracle ERP Status Page (ถ้ามี)
- ดู Log: pkg/integration/oracle_erp

### Step 2: จำแนกประเภท Error
| Error | สาเหตุ | วิธีแก้ |
|-------|--------|---------|
| 401/403 | Token หมดอายุ | Refresh token |
| 429 | Rate Limit | Backoff + Retry |
| 500/503 | ERP ล่ม | Circuit Breaker + รอ |
| Timeout | Network/ERP ช้า | เพิ่ม timeout + Retry |
| 409 Conflict | Duplicate | ตรวจ Idempotency Key |

### Step 3: Mitigate
- เปิด Circuit Breaker (ถ้ายังไม่เปิด)
- หยุด Job ชั่วคราวเพื่อไม่ให้ Retry ซ้ำ
- แจ้ง User ว่า Sync ล่าช้า

### Step 4: Reconcile หลัง ERP กลับมา
- รัน Reconciliation Job
- ตรวจ Idempotency ว่าข้อมูลไม่ซ้ำ
- ยืนยันยอดกับ Finance

## Escalation
- เกิน 30 นาที → Architect + ERP Team
- มี Data Duplicate → SEV-1 (Finance Impact)
```

### 7.5.4 Runbook: Memory Leak / OOMKilled

```markdown
# Runbook: Pod OOMKilled

## Trigger
- Alert: PodCrashLooping / OOMKilled
- อาการ: Pod Restart บ่อย, 5xx เป็นช่วงๆ

## ขั้นตอน

### Step 1: ยืนยัน (2 นาที)
- kubectl describe pod <pod> -n production → ดู Last State: OOMKilled
- ดู Memory Usage Graph ย้อนหลัง 1 ชั่วโมง

### Step 2: Mitigate ทันที
- เพิ่ม Memory Limit ชั่วคราว:
  kubectl set resources deployment/pms-api --limits=memory=1Gi
- Restart Pod เพื่อให้ค่าใหม่มีผล
- Scale เพิ่มเพื่อกระจาย Load (ถ้าจำเป็น)

### Step 3: หา Root Cause
- ดู Heap Dump / Memory Profile
- หา Endpoint ที่กิน Memory สูง
- ตรวจ Leak: Object ไม่ถูก GC

### Step 4: Permanent Fix
- Fix code / Upgrade library
- ปรับ Resource Limit ถาวร
- เพิ่ม Alert ที่ Memory > 80%

## Escalation
- เกิน 20 นาที → Dev + Architect
```

---

## 7.6 Escalation Matrix

| สถานการณ์ | Escalate ถึง | ภายใน | ช่องทาง |
|-----------|-------------|-------|---------|
| SEV-1 ตรวจพบ | IC + EM + Stakeholder | 5 นาที | Slack #incident + โทร |
| SEV-2 ตรวจพบ | IC + EM | 10 นาที | Slack #incident |
| เกิน SLA Mitigate | IC + Tech Lead | ทันที | โทร |
| ต้อง Rollback | IC + DevOps Lead | 5 นาที | โทร |
| Security Breach | IC + Security + EM + Legal | ทันที | โทร + War Room |
| Data Loss | IC + DBA + Architect + EM | ทันที | War Room |
| Vendor Issue (Oracle) | IC + ERP Team + Vendor | 15 นาที | Email + โทร |
| สื่อ/ภายนอกสอบถาม | EM + PR (ห้ามตอบเอง) | ทันที | โอนสาย |

**Escalation Path (สายด่วน):**

```
On-call → Tech Lead → Engineering Manager → CTO
                ↘ Architect (technical)     ↘ CEO (business)
                ↘ DBA (data)                ↘ Legal (compliance)
                ↘ Security (breach)
```

---

## 7.7 Communication Templates

### 7.7.1 Initial Notification (SEV-1/2) — ส่งภายใน 5 นาที

```markdown
🚨 **INCIDENT DECLARED — [INC-XXX]**

**Severity:** SEV-1 / SEV-2
**Status:** Investigating
**Detected:** [HH:MM]
**Impact:** [ผู้ใช้กลุ่ม X, บริการ Y ล่ม]
**IC:** [ชื่อ]
**Channel:** #incident-INC-XXX

**What we know:**
- [ข้อเท็จจริง 1]
- [ข้อเท็จจริง 2]

**What we're doing:**
- [Action 1]
- [Action 2]

**Next update:** [HH:MM + 15/30 นาที]
```

### 7.7.2 Update Template — ส่งทุก 15 (SEV-1) / 30 (SEV-2) นาที

```markdown
🔄 **UPDATE — [INC-XXX]** ([HH:MM])

**Status:** Investigating / Mitigating / Monitoring / Resolved
**Impact:** [อัปเดต]

**Progress:**
- ✅ [สิ่งที่ทำเสร็จ]
- 🔄 [กำลังทำ]
- ⏳ [รอ]

**Next update:** [HH:MM]
```

### 7.7.3 Resolution Notification

```markdown
✅ **RESOLVED — [INC-XXX]**

**Duration:** [X ชั่วโมง Y นาที]
**Root Cause (เบื้องต้น):** [สรุปสั้น]
**Resolution:** [สิ่งที่ทำ]

**Impact Summary:**
- ผู้ใช้กระทบ: [จำนวน]
- Transaction ที่ Fail: [จำนวน — ถ้ามี]
- Data Loss: [ไม่มี / มี — รายละเอียด]

**Next Steps:**
- RCA: [วันที่] — Owner: [ชื่อ]
- Preventive Action: [วันที่]
- Post-mortem: [วันที่]

**Monitoring:** ติดตาม Metric ต่อเนื่อง 24 ชั่วโมง
```

### 7.7.4 External Communication (สำหรับ Stakeholder / ลูกค้า)

> ⚠️ **ห้าม On-call/IC สื่อสารภายนอกเอง** — ต้องผ่าน EM + PR เท่านั้น

```markdown
# External Notice (Draft)

**ระบบ:** [ชื่อระบบ]
**ระยะเวลา:** [Start] – [End]
**ผลกระทบ:** [อธิบายแบบไม่เป็นเทคนิค]
**สาเหตุ:** [อธิบายแบบไม่เป็นเทคนิค]
**การแก้ไข:** [สิ่งที่ทำ]
**มาตรการป้องกัน:** [สิ่งที่ทำเพื่อไม่ให้เกิดซ้ำ]
**ติดต่อ:** [Support Channel]
```

---

## 7.8 War Room Protocol (SEV-1)

```
┌─────────────────────────────────────────────────────────────┐
│                      WAR ROOM PROTOCOL                      │
└─────────────────────────────────────────────────────────────┘

  เปิด War Room (Slack Huddle / Zoom / ห้องจริง)
         │
         ▼
  ┌──────────────────────────────────────┐
  │ IC กำหนดบทบาทให้ทุกคนชัดเจน          │
  │ • IC: [ชื่อ] — Decision                    │
  │ • Ops: [ชื่อ] — Infra / K8s               │
  │ • Dev: [ชื่อ] — Code / Debug              │
  │ • DBA: [ชื่อ] — Database                  │
  │ • Scribe: [ชื่อ] — Timeline               │
  │ • Comms: [ชื่อ] — Stakeholder             │
  └──────────────────────────────────────┘
         │
         ▼
  กำหนดรอบ Update: ทุก 15 นาที
         │
         ▼
  ┌──────────────────────────────────────┐
  │ กฎใน War Room:                        │
  │ • IC เป็นคนตัดสินใจเท่านั้น            │
  │ • ห้ามคุยพร้อมกัน — ยกมือ                  │
  │ • ห้าม Blame — เน้นแก้ปัญหา                  │
  │ • ทุก Action ต้องแจ้ง IC ก่อนทำ          │
  │ • Scribe บันทึกทุกอย่าง                    │
  └──────────────────────────────────────┘
```

**Checklist เปิด War Room (2 นาที):**
- [ ] เปิด Channel #incident-INC-XXX
- [ ] เปิด Video Call
- [ ] แต่งตั้ง Scribe
- [ ] กำหนด Update Cadence
- [ ] แจ้ง Stakeholder ว่า War Room เปิด
- [ ] Pin ข้อมูลสำคัญ (Dashboard, Log Link, Runbook)

---

## 7.9 On-call Checklist (ขยาย)

### 7.9.1 ก่อนขึ้น On-call (สัปดาห์ก่อน)

- [ ] ศึกษา Runbook ทุก Scenario ในระบบที่รับผิดชอบ
- [ ] ทดสอบ Access: K8s, Azure, DB, Log, Grafana
- [ ] ทดสอบ Alert: ส่ง Test Alert เข้า Slack/โทร
- [ ] ตรวจสอบ Escalation Path และเบอร์ติดต่อ
- [ ] อ่าน Incident ล่าสุด 3 ตัว (บทเรียน)
- [ ] ตรวจสอบว่ามี Deploy Planned ในกะของตนหรือไม่
- [ ] เตรียม Laptop + Internet สำรอง + Hotspot
- [ ] แจ้งครอบครัว/คนใกล้ชิดว่าอาจต้องรับสายดึก

### 7.9.2 ระหว่าง On-call (ทุกวัน)

- [ ] ตรวจ Health Dashboard ตอนเช้า (09:00)
- [ ] ตรวจ Alert ที่ค้าง / Watch อยู่
- [ ] ตอบ Alert ภายใน SLA
- [ ] บันทึก Timeline ทุก Incident
- [ ] อัปเดต Handover ก่อนเลิกกะ
- [ ] ตรวจ Capacity (Disk, Memory, Connection) ก่อนนอน

### 7.9.3 หลัง Incident

- [ ] ยืนยันระบบเสถียร 30 นาทีหลัง Mitigate
- [ ] บันทึก Incident Report ครบถ้วน
- [ ] แจ้ง Stakeholder ตาม Severity
- [ ] เข้าร่วม RCA (ภายใน 48 ชั่วโมง)
- [ ] อัปเดต Runbook ตามบทเรียน
- [ ] เสนอ Preventive Action

---

## 7.10 KPI และ Metrics สำหรับ On-call (ขยาย)

| KPI | คำนิยาม | เป้าหมาย | วิธีวัด |
|-----|---------|----------|---------|
| **Alert Acknowledgment Time** | เวลาจาก Alert ถึง Acknowledge | ≤ 5 นาที (SEV-1/2) | Alert System |
| **MTTD** (Mean Time to Detect) | เวลาจาก Incident เกิดถึงตรวจพบ | ≤ 5 นาที | Monitoring |
| **MTTA** (Mean Time to Acknowledge) | เวลาจาก Alert ถึงรับ | ≤ 5 นาที | PagerDuty |
| **MTTM** (Mean Time to Mitigate) | เวลาจากรับถึง Mitigate | ≤ 15 นาที (SEV-1) | Incident Log |
| **MTTR** (Mean Time to Resolve) | เวลาจากเกิดถึง Resolve | ≤ 30 นาที (SEV-1/2) | Incident Log |
| **Escalation Accuracy** | % ที่ Escalate ถูกต้อง/ทันเวลา | ≥ 95% | Audit |
| **False Alert Rate** | % Alert ที่ไม่ใช่ปัญหาจริง | < 10% | Alert Review |
| **Post-mortem Completion** | % ที่เสร็จภายใน 48 ชม. | 100% | RCA Log |
| **Runbook Coverage** | % Scenario ที่มี Runbook | ≥ 90% | Doc Audit |
| **On-call Satisfaction** | ความพึงพอใจของ On-call | ≥ 4/5 | Survey |

---

## 7.11 ข้อห้าม (Prohibitions) — สำคัญมาก

| # | ข้อห้าม | เหตุผล |
|---|---------|--------|
| 1 | ❌ ห้าม Ignore Alert โดยไม่ Triage | อาจพลาด SEV-1 |
| 2 | ❌ ห้ามแก้ Production โดยไม่แจ้ง IC | อาจทำให้สถานการณ์แย่ลง |
| 3 | ❌ ห้าม Blame คนใน War Room | ทำให้คนกลัวไม่กล้าแจ้ง |
| 4 | ❌ ห้ามสื่อสารภายนอกเอง (SEV-1/2) | ต้องผ่าน EM + PR |
| 5 | ❌ ห้ามปิด Incident ก่อนยืนยันเสถียร 30 นาที | อาจกลับมาซ้ำ |
| 6 | ❌ ห้าม On-call ขาดการ Handover | กะถัดไปจะ Blind |
| 7 | ❌ ห้าม Deploy ระหว่าง SEV-1/2 (ยกเว้น Hotfix ที่ IC อนุมัติ) | เพิ่มความเสี่ยง |
| 8 | ❌ ห้ามใช้ Production เป็นที่ Debug | ต้องใช้ Staging |
| 9 | ❌ ห้ามเก็บ Secrets ใน War Room Chat | รั่วไหล |
| 10 | ❌ ห้าม Delay RCA เกิน 48 ชั่วโมง | รายละเอียดจะหาย |

---

## 7.12 ความเชื่อมโยงกับเล่มอื่น

| เล่ม | ความเชื่อมโยงกับเล่ม 7 |
|------|------------------------|
| **เล่ม 5 (DevOps)** | CI/CD, Observability, Alerting Rules — On-call ใช้ทุกวัน |
| **เล่ม 6 (Code Review)** | Hotfix ต้องผ่าน Review (Fast-track) |
| **เล่ม 11 (Hotfix & Rollback)** | Runbook Rollback, Hotfix Workflow — ใช้ร่วมกัน |
| **เล่ม 13 (RCA)** | หลัง Incident ต้องทำ RCA ตามเล่ม 13 |
| **เล่ม 14 (Security)** | Incident ที่เป็น Security Breach ต้องตาม Protocol เล่ม 14 |
| **เล่ม 15 (Knowledge)** | Runbook, Post-mortem, บทเรียน → Knowledge Base |

---

## 7.13 สรุปสาระสำคัญ (Key Takeaways)

```text
┌─────────────────────────────────────────────────────────────┐
│              INCIDENT COMMANDER / ON-CALL                   │
│                     KEY TAKEAWAYS                           │
└─────────────────────────────────────────────────────────────┘

  1. ตอบเร็ว (≤ 5 นาที) — Triage ตาม Decision Tree
  2. แยกบทบาท IC กับ Engineer ใน SEV-1/2
  3. Mitigate ก่อน Root Cause — หยุดเลือดก่อนผ่าตัด
  4. สื่อสารตาม Cadence — 15/30 นาที ไม่ขาด
  5. บันทึก Timeline ทุก Action — เพื่อ RCA
  6. Escalate ตาม Matrix — อย่าแบกคนเดียว
  7. War Room มีกฎชัด — IC ตัดสิน, Scribe บันทึก
  8. Handover ครบถ้วน — กะถัดไปไม่ Blind
  9. RCA ภายใน 48 ชม. — ป้องกันเกิดซ้ำ
  10. อัปเดต Runbook ทุกครั้ง — บทเรียนกลายเป็นความรู้
```

---
 