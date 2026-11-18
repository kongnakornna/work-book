## 📘 เล่ม 13 (ฉบับขยาย): คู่มือ RCA (Root Cause Analysis)
**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับสมบูรณ์ (ส่วนที่ 1, 2 และภาค 1–3)

> **หมายเหตุ:** เอกสารนี้เป็นฉบับขยายของเล่ม 13 ใน Master Index โดยเพิ่มรายละเอียดเชิงปฏิบัติสำหรับการวิเคราะห์หาสาเหตุราก ได้แก่ RCA Types & Triggers, 6-Step Process (Deep Dive), Tools ขั้นสูง (5 Whys, Fishbone, FTA, Kepner-Tregoe, Apollo), Timeline Reconstruction, Evidence Collection, Blameless Culture, Contributing Factors, Action Planning, Postmortem Protocol, Templates ครบชุด และ KPIs

---
## 13.0 บทนำและปรัชญา

### 13.0.1 RCA คืออะไร (ไม่ใช่อะไร)

```
┌─────────────────────────────────────────────────────────────┐
│              RCA: WHAT IT IS / IS NOT                       │
└─────────────────────────────────────────────────────────────┘

  ✅ RCA IS:
  • การหาสาเหตุที่แท้จริง (Root Cause)
  • การป้องกันไม่ให้เกิดซ้ำ (Prevention)
  • การเรียนรู้จากความล้มเหลว (Learning)
  • Blameless (ไม่หาคนผิด)

  ❌ RCA IS NOT:
  • การหาคนผิด (Blame Game)
  • การแก้ที่ Symptom (Band-aid)
  • การเขียนรายงานเพื่อรายงาน
  • การประชุมเพื่อประชุม
  • การตำหนิทีม (Witch Hunt)
```

### 13.0.2 ปรัชญา 4 ข้อ

| หลักการ | ความหมาย | ผลลัพธ์ |
|---------|----------|---------|
| **Blameless** | เน้นระบบ ไม่ใช่คน | ทีมกล้าแจ้ง |
| **Systemic** | หาสาเหตุเชิงระบบ | แก้ที่ต้นเหตุ |
| **Evidence-Based** | ใช้ข้อมูล ไม่เดา | แม่นยำ |
| **Action-Oriented** | มี Action จริง | ไม่เกิดซ้ำ |

### 13.0.3 ทำไม RCA ถึงสำคัญ?

```
┌─────────────────────────────────────────────────────────────┐
│              RCA IMPACT                                     │
└─────────────────────────────────────────────────────────────┘

  ไม่มี RCA:              มี RCA:
  ─────────              ────────
  Incident เกิดซ้ำ        Incident ลดลง
  ทีมกลัวแจ้ง             ทีมกล้าแจ้ง
  แก้ที่ Symptom          แก้ที่ Root Cause
  ความรู้หาย              ความรู้สะสม
  ต้นทุนสูง               ต้นทุนลด
```

### 13.0.4 ประโยชน์ของ RCA

| ด้าน | ประโยชน์ |
|------|----------|
| **Reliability** | ระบบเสถียรขึ้น, Incident ลด |
| **Cost** | ลดต้นทุน Downtime, ลดค่าแก้ |
| **People** | ทีมเรียนรู้, Confidence สูง |
| **Process** | Process ดีขึ้น, Documentation ครบ |
| **Compliance** | Audit ผ่าน, Regulator พอใจ |

---

## 13.1 บทบาทและความรับผิดชอบ

### 13.1.1 ผู้เกี่ยวข้องใน RCA

| บทบาท | หน้าที่ | อยู่ในทุก RCA? |
|-------|---------|:---------------:|
| **RCA Lead** | นำ RCA, ประสานทีม, เขียน Report | ✅ |
| **Incident Commander** | ให้ข้อมูล Incident | ✅ (ถ้ามี Incident) |
| **Subject Matter Expert (SME)** | ให้ข้อมูล Technical | ✅ |
| **Scribe** | บันทึก Timeline, Notes | ✅ |
| **Action Owner** | รับผิดชอบ Preventive Action | ✅ |
| **Facilitator** | ดำเนิน Meeting | ⚠️ (ถ้ามี) |
| **Stakeholder** | รับทราบผล | ✅ (SEV-1/2) |

### 13.1.2 บทบาท RCA Lead (ละเอียด)

**ก่อน RCA:**
- [ ] รวบรวมข้อมูลเบื้องต้น (Log, Metric, Timeline)
- [ ] กำหนดผู้เข้าร่วม (SME ที่เกี่ยวข้อง)
- [ ] กำหนดเวลา + สถานที่
- [ ] เตรียม Template

**ระหว่าง RCA:**
- [ ] ดำเนินการประชุมตามวาระ
- [ ] ใช้ Tools (5 Whys, Fishbone)
- [ ] ให้ทุกคนมีส่วนร่วม
- [ ] ควบคุมเวลา
- [ ] บันทึก Notes

**หลัง RCA:**
- [ ] เขียน Report
- [ ] กำหนด Action + Owner + Due
- [ ] ติดตาม Action
- [ ] เผยแพร่บทเรียน

### 13.1.3 คุณสมบัติ RCA Lead ที่ดี

| คุณสมบัติ | รายละเอียด |
|-----------|-----------|
| **Curious** | ถาม "ทำไม" จนถึงราก |
| **Objective** | ไม่ Bias, ไม่ด่วนสรุป |
| **Facilitator** | ทำให้ทุกคนมีส่วนร่วม |
| **Detail-Oriented** | ใส่ใจรายละเอียด |
| **Systems Thinker** | มองภาพรวม |
| **Blameless** | ไม่หาคนผิด |
| **Action-Oriented** | เน้น Action จริง |

---

## 13.2 RCA Types & Triggers

### 13.2.1 ประเภทของ RCA

| ประเภท | ใช้เมื่อ | เวลา | ความลึก |
|--------|----------|------|---------|
| **Formal RCA** | SEV-1, SEV-2, Incident ซ้ำ | 2–8 ชั่วโมง | ลึก |
| **Lightweight RCA** | SEV-3, Minor Incident | 30–60 นาที | ปานกลาง |
| **Rapid RCA** | Incident เร่งด่วน | 15–30 นาที | ตื้น |
| **Proactive RCA** | ก่อนเกิด (Risk) | ตามต้องการ | ลึก |
| **Problem Management** | ปัญหาเรื้อรัง | หลายวัน | ลึกมาก |

### 13.2.2 Triggers (เมื่อไหร่ต้องทำ RCA)

```
┌─────────────────────────────────────────────────────────────┐
│              RCA TRIGGERS                                   │
└─────────────────────────────────────────────────────────────┘

  ✅ บังคับ:
  • SEV-1 (Critical) — ทุกครั้ง
  • SEV-2 (High) — ทุกครั้ง
  • Data Loss — ทุกครั้ง
  • Security Breach — ทุกครั้ง
  • Compliance Violation — ทุกครั้ง

  ✅ แนะนำ:
  • SEV-3 ที่เกิดซ้ำ (≥ 2 ครั้งใน 1 เดือน)
  • Near Miss (เกือบเกิด)
  • Deploy Failure
  • Hotfix ที่ต้องทำ

  ⚠️ Optional:
  • SEV-4 (Minor)
  • Cosmetic Issue
  • ไม่มี Impact
```

### 13.2.3 RCA Severity Mapping

| Severity | RCA Type | Timeline | ผู้เข้าร่วม |
|----------|----------|----------|-----------|
| **SEV-1** | Formal RCA | ≤ 48 ชั่วโมง | IC + SME + EM + Architect |
| **SEV-2** | Formal RCA | ≤ 72 ชั่วโมง | IC + SME + Tech Lead |
| **SEV-3** | Lightweight | ≤ 1 สัปดาห์ | On-call + Dev |
| **SEV-4** | Optional | ตามต้องการ | On-call |
| **Repeat** | Problem Mgmt | ทันที | ทีมที่เกี่ยวข้อง |

### 13.2.4 Near Miss (เกือบเกิด)

> **Near Miss** = Incident ที่เกือบเกิด แต่ถูกจับได้ทัน

**ตัวอย่าง:**
- Alert แจ้งเตือนก่อนระบบล่ม → แก้ทัน
- Test จับ Bug ก่อน Merge
- User Report ก่อนกระทบลูกค้าคนอื่น

**ทำไมต้อง RCA Near Miss:**
- ต้นทุนต่ำ (ยังไม่เสียหาย)
- ป้องกัน Incident จริง
- เรียนรู้ได้เร็ว

---

## 13.3 6-Step RCA Process (Deep Dive)

### 13.3.1 ภาพรวม 6 ขั้น

```
┌─────────────────────────────────────────────────────────────┐
│                  RCA 6-STEP PROCESS                         │
└─────────────────────────────────────────────────────────────┘

  ┌──────────────────────┐
  │ 1. Define Problem    │  ระบุปัญหาให้ชัด
  └──────────┬───────────┘
             ▼
  ┌──────────────────────┐
  │ 2. Collect Data      │  รวบรวมข้อมูล
  └──────────┬───────────┘
             ▼
  ┌──────────────────────┐
  │ 3. Identify Causes   │  หาสาเหตุที่เป็นไปได้
  └──────────┬───────────┘
             ▼
  ┌──────────────────────┐
  │ 4. Find Root Cause   │  หาสาเหตุราก
  └──────────┬───────────┘
             ▼
  ┌──────────────────────┐
  │ 5. Implement Fix     │  วางแผนและแก้ไข
  └──────────┬───────────┘
             ▼
  ┌──────────────────────┐
  │ 6. Monitor & Verify  │  ติดตามผล
  └──────────────────────┘
```

### 13.3.2 Step 1: Define Problem (ระบุปัญหา)

**เป้าหมาย:** อธิบายปัญหาให้ชัด วัดได้ ไม่กำกวม

**ต้องตอบ 5W1H:**

| คำถาม | ตัวอย่าง |
|-------|----------|
| **What** | เกิดอะไรขึ้น? (ระบบ Payment ล่ม) |
| **When** | เกิดเมื่อไหร่? (2024-11-18 14:30) |
| **Where** | เกิดที่ไหน? (Production, Region TH) |
| **Who** | ใครได้รับผลกระทบ? (User 500 คน) |
| **Why** | ทำไมสำคัญ? (กระทบรายได้ ฿2M) |
| **How** | กระทบอย่างไร? (Payment Fail 100%) |

**Problem Statement Template:**

```markdown
## Problem Statement

**Incident:** INC-XXX
**Severity:** SEV-1
**Date:** 2024-11-18 14:30 ICT
**Duration:** 45 นาที

**What:** ระบบ Payment ล่มทั้งหมด (Error Rate 100%)
**Who:** User 500 คน, Transaction 250 รายการ
**Impact:** รายได้สูญเสีย ฿2M, SLA ผิดสัญญา
**Scope:** Production Region TH เท่านั้น (Region อื่นปกติ)

**Measurable:**
- Error Rate: 0% → 100% → 0.5%
- Latency P95: 200ms → 30s+ → 250ms
- Failed Transactions: 250 รายการ
```

**ข้อผิดพลาดที่พบบ่อย:**

| ❌ ผิด | ✅ ถูก |
|--------|--------|
| "ระบบช้า" | "Latency P95 > 5s (จาก 200ms)" |
| "User บ่น" | "User Report 50 รายใน 15 นาที" |
| "Database มีปัญหา" | "DB Connection Pool เต็ม 100/100" |

### 13.3.3 Step 2: Collect Data (รวบรวมข้อมูล)

**เป้าหมาย:** รวบรวมหลักฐานที่เกี่ยวข้องทั้งหมด

**Data Sources:**

| ประเภท | แหล่งข้อมูล | ตัวอย่าง |
|--------|------------|----------|
| **Logs** | App, System, Access | Error Stack, Request Log |
| **Metrics** | Prometheus, Grafana | CPU, Memory, Latency, Error Rate |
| **Traces** | Jaeger, Tempo | Distributed Trace |
| **Alerts** | Alertmanager | Alert History |
| **Timeline** | Incident Log | เวลาที่เกิดเหตุการณ์ |
| **Changes** | Git, CI/CD | Deploy, Config Change |
| **Interviews** | ทีมที่เกี่ยวข้อง | มุมมองจากคน |
| **Config** | Config Files | ค่าที่ตั้ง |
| **DB** | Query Log, Slow Log | Query ที่ช้า |

**Evidence Collection Checklist:**

- [ ] **Logs:** App Log, System Log, Access Log (ช่วงเวลา ± 1 ชั่วโมง)
- [ ] **Metrics:** CPU, Memory, Disk, Network, Latency, Error Rate
- [ ] **Traces:** Request ที่ Fail, Duration, Span
- [ ] **Alerts:** Alert ที่ Trigger, Timing
- [ ] **Deploy History:** Commit, Time, Author
- [ ] **Config Changes:** What, When, Who
- [ ] **DB:** Slow Query, Connection Count
- [ ] **External:** Third-party Status, Network
- [ ] **User Reports:** Severity, Timing
- [ ] **Timeline:** Incident Log จาก IC

**Evidence Preservation:**

```
⚠️ สำคัญ: ต้องเก็บ Evidence ก่อน Cleanup

- Logs: Export ทันที (ก่อน Rotate)
- Metrics: Snapshot (ก่อน Data หาย)
- Pod: kubectl describe (ก่อน Restart)
- DB: pg_stat_activity (ก่อน Kill)
- Config: git diff (ก่อน Revert)
```

**Data Collection Template:**

```markdown
## Evidence Log

| # | Type | Source | Collected By | Time | Link/Path |
|---|------|--------|--------------|------|-----------|
| 1 | Log | App Server | DevOps | 15:00 | /logs/app-20241118.log |
| 2 | Metric | Grafana | On-call | 15:02 | dashboard/payment-api |
| 3 | Trace | Jaeger | Dev | 15:05 | trace-id/abc123 |
| 4 | Deploy | Git | DevOps | 15:10 | commit/def456 |
| 5 | Config | K8s | DevOps | 15:12 | kubectl get cm |
```

### 13.3.4 Step 3: Identify Causes (หาสาเหตุที่เป็นไปได้)

**เป้าหมาย:** ระดมสมองหาสาเหตุที่เป็นไปได้ทั้งหมด

**Tools:**

| Tool | ใช้เมื่อ | ข้อดี |
|------|----------|-------|
| **5 Whys** | ปัญหาง่าย | เร็ว, ตรง |
| **Fishbone** | ปัญหาซับซ้อน | ครอบคลุม 6 หมวด |
| **FTA** | ปัญหาหลายชั้น | เชื่อมโยงเหตุ-ผล |
| **Brainstorming** | ไม่รู้ทิศ | ระดมความคิด |
| **Kepner-Tregoe** | ต้อง Priorities | มีระบบ |

**Brainstorming Rules:**

```
┌─────────────────────────────────────────────────────────────┐
│              BRAINSTORMING RULES                            │
└─────────────────────────────────────────────────────────────┘

  ✅ ห้ามวิจารณ์ (No Criticism)
  ✅ ทุก Idea มีค่า (Wild Ideas Welcome)
  ✅ ต่อยอด (Build on Others)
  ✅ เน้นปริมาณ (Quantity First)
  ✅ บันทึกทุกอย่าง (Write Everything)
```

### 13.3.5 Step 4: Find Root Cause (หาสาเหตุราก)

**เป้าหมาย:** ระบุสาเหตุที่แท้จริง (ไม่ใช่ Symptom)

**หลักการ:**

```
┌─────────────────────────────────────────────────────────────┐
│              SYMPTOM vs ROOT CAUSE                          │
└─────────────────────────────────────────────────────────────┘

  Symptom: ระบบล่ม
    │
    ▼
  Why? → API Error 500
    │
    ▼
  Why? → DB Connection Failed
    │
    ▼
  Why? → Connection Pool เต็ม
    │
    ▼
  Why? → Long-running Query
    │
    ▼
  Why? → Missing Index
    │
    ▼
  Root Cause: ไม่มี Index บน email
```

**เกณฑ์ Root Cause ที่ดี:**

| เกณฑ์ | คำถาม |
|-------|-------|
| **Necessary** | ถ้าแก้แล้ว ปัญหาหายไหม? |
| **Sufficient** | ถ้าไม่แก้ ปัญหาเกิดไหม? |
| **Actionable** | แก้ได้จริงไหม? |
| **Systemic** | เป็นปัญหาเชิงระบบ ไม่ใช่คน? |
| **Evidence-Based** | มีหลักฐานสนับสนุน? |

### 13.3.6 Step 5: Implement Fix (วางแผนและแก้ไข)

**เป้าหมาย:** วางแผน Action ที่ป้องกันการเกิดซ้ำ

**ประเภท Action:**

| ประเภท | ความหมาย | ตัวอย่าง |
|--------|----------|----------|
| **Corrective** | แก้ปัญหาเฉพาะหน้า | Restart Service |
| **Preventive** | ป้องกันไม่ให้เกิดซ้ำ | เพิ่ม Index, เพิ่ม Test |
| **Detective** | ตรวจพบเร็วขึ้น | เพิ่ม Alert |
| **Mitigating** | ลดผลกระทบ | Circuit Breaker |
| **Process** | ปรับ Process | เพิ่ม Review Step |

**SMART Action Criteria:**

| ตัวอักษร | ความหมาย | ตัวอย่าง |
|----------|----------|----------|
| **S**pecific | ชัดเจน | "เพิ่ม Unique Index บน email" |
| **M**easurable | วัดได้ | "ลด Query Time 80%" |
| **A**chievable | ทำได้ | "ภายใน 1 Sprint" |
| **R**elevant | เกี่ยวข้อง | "แก้ Root Cause" |
| **T**ime-bound | มีกำหนด | "ภายใน 2024-11-25" |

### 13.3.7 Step 6: Monitor & Verify (ติดตามผล)

**เป้าหมาย:** ยืนยันว่า Action ได้ผลจริง

**Monitoring Plan:**

```markdown
## Monitoring Plan

| Action | KPI | Target | Duration | Owner |
|--------|-----|--------|----------|-------|
| เพิ่ม Index | Query Time | < 100ms | 30 วัน | DBA |
| เพิ่ม Alert | MTTD | < 5 นาที | 30 วัน | DevOps |
| เพิ่ม Test | Coverage | +5% | 30 วัน | Dev |
| อัปเดต Runbook | Time to Resolve | < 30 นาที | 30 วัน | IC |
```

**Verification Questions:**

- [ ] ปัญหาหายจริงไหม? (ไม่มี Incident ซ้ำ)
- [ ] KPI ดีขึ้นไหม?
- [ ] Action เสร็จจริงไหม?
- [ ] บทเรียนถูกบันทึกไหม?
- [ ] ทีมรับทราบไหม?

---

## 13.4 RCA Tools (Deep Dive)

### 13.4.1 5 Whys (Deep Dive)

**หลักการ:** ถาม "ทำไม" 5 ครั้ง (หรือจนถึงราก)

**ตัวอย่าง 1: Payment ล่ม**

```
Problem: Payment ล่ม 45 นาที

Why 1: ทำไม Payment ล่ม?
→ API ตอบ 500 Error

Why 2: ทำไม API ตอบ 500?
→ DB Connection Failed

Why 3: ทำไม Connection Failed?
→ Connection Pool เต็ม (100/100)

Why 4: ทำไม Pool เต็ม?
→ มี Long-running Query ค้าง 20+ connections

Why 5: ทำไม Query นาน?
→ ไม่มี Index บน email → Full Collection Scan

Root Cause: ไม่มี Index บน email
```

**ตัวอย่าง 2: Deploy ล้มเหลว**

```
Problem: Deploy ล้มเหลว 3 ครั้งใน 1 สัปดาห์

Why 1: ทำไม Deploy ล้มเหลว?
→ Test Fail ใน CI

Why 2: ทำไม Test Fail?
→ Flaky Test (pass/fail สลับ)

Why 3: ทำไม Flaky?
→ Test ใช้ Shared Database

Why 4: ทำไมใช้ Shared DB?
→ ไม่มี Test DB แยก

Why 5: ทำไมไม่มี Test DB แยก?
→ ไม่ได้ Setup ใน CI Pipeline

Root Cause: ไม่มี Isolated Test DB ใน CI
```

**5 Whys Best Practices:**

| ✅ ควรทำ | ❌ ไม่ควรทำ |
|----------|-------------|
| ถามจนถึงราก | หยุดที่ 5 เสมอ |
| ใช้ Evidence | เดาคำตอบ |
| Blameless | ตำหนิคน |
| Branching ได้ | บังคับเส้นเดียว |
| บันทึกทุกWhy | ข้ามขั้น |

**5 Whys Limitations:**

- ⚠️ อาจ Bias (คนถามชี้ทิศ)
- ⚠️ ไม่เหมาะกับปัญหาหลายสาเหตุ
- ⚠️ อาจหยุดที่ Symptom
- ⚠️ ไม่แสดง Contributing Factors

### 13.4.2 Fishbone Diagram (Ishikawa)

**หลักการ:** แบ่งสาเหตุเป็น 6 หมวด (6M)

```
┌─────────────────────────────────────────────────────────────┐
│                  FISHBONE DIAGRAM (6M)                      │
└─────────────────────────────────────────────────────────────┘

  Man          Method         Machine
   │             │              │
   │             │              │
   ▼             ▼              ▼
  ┌──┐         ┌──┐           ┌──┐
  │  │         │  │           │  │
  └──┴─────────┴──┴───────────┴──┴──────► Problem
  ┌──┐         ┌──┐           ┌──┐
  │  │         │  │           │  │
  └──┴─────────┴──┴───────────┴──┴
   ▲             ▲              ▲
   │             │              │
  Material    Measurement    Environment
```

**6M Categories:**

| หมวด | คำถาม | ตัวอย่าง |
|------|-------|----------|
| **Man** (People) | คนทำอะไรผิด? | ขาด Training, ลืมขั้นตอน |
| **Method** (Process) | Process ผิด? | ไม่มี Checklist, ไม่มี Review |
| **Machine** (Technology) | เครื่องมีปัญหา? | Server เต็ม, Network ล่ม |
| **Material** (Data/Input) | ข้อมูลผิด? | Data ไม่ครบ, Input ผิด |
| **Measurement** (Monitoring) | วัดผลผิด? | ไม่มี Alert, Metric ผิด |
| **Environment** (Context) | สภาพแวดล้อม? | Peak Load, Network |

**ตัวอย่าง: Payment ล่ม (Fishbone)**

```
                    Man
                     │
              ┌──────┴──────┐
              │ Dev ใหม่     │
              │ ไม่รู้ Schema│
              └─────────────┘
                     │
                    Method
                     │
              ┌──────┴──────┐
              │ ไม่มี Index  │
              │ Review       │
              │ ไม่มี Checklist│
              └─────────────┘
                     │
                    Machine
                     │
              ┌──────┴──────┐
              │ DB Pool 100  │
              │ ไม่พอ         │
              └─────────────┘
                     │
Problem ◄────────────┼────────────►
                     │
                    Material
                     │
              ┌──────┴──────┐
              │ Email ซ้ำ    │
              │ ไม่ Normalize│
              └─────────────┘
                     │
                    Measurement
                     │
              ┌──────┴──────┐
              │ ไม่มี Alert  │
              │ Pool > 80%   │
              └─────────────┘
                     │
                    Environment
                     │
              ┌──────┴──────┐
              │ Peak Hours   │
              │ โหลดสูง      │
              └─────────────┘
```

**Fishbone Best Practices:**

- ✅ ระดมสมองทุกหมวด
- ✅ ใช้ Sticky Notes / Whiteboard
- ✅ จัดกลุ่ม Cause
- ✅ Vote หา Cause ที่น่าจะเป็น
- ✅ ใช้ 5 Whys ต่อในแต่ละ Cause

### 13.4.3 Fault Tree Analysis (FTA)

**หลักการ:** แสดงความสัมพันธ์เชิงตรรกะระหว่างเหตุและผล

```
┌─────────────────────────────────────────────────────────────┐
│                  FAULT TREE EXAMPLE                         │
└─────────────────────────────────────────────────────────────┘

              [Payment ล่ม]
                    │
              ┌─────┴─────┐
              │    OR     │
              └─────┬─────┘
              ┌─────┴─────┐
              │           │
         [DB ล่ม]     [App Crash]
              │           │
        ┌─────┴─────┐ ┌───┴───┐
        │    OR     │ │  OR   │
        └─────┬─────┘ └───┬───┘
        ┌─────┴──┐    ┌───┴───┐
        │        │    │       │
      [Full]  [Down] [OOM] [Bug]

  OR = เกิดจากสาเหตุใดก็ได้
  AND = ต้องเกิดพร้อมกัน
```

**FTA Symbols:**

| Symbol | ความหมาย |
|--------|----------|
| **OR Gate** | เกิดจากสาเหตุใดก็ได้ |
| **AND Gate** | ต้องเกิดพร้อมกัน |
| **Basic Event** | สาเหตุพื้นฐาน |
| **Intermediate** | เหตุการณ์กลาง |

**FTA เหมาะกับ:**
- ระบบซับซ้อน (หลาย Layer)
- Safety-Critical
- ต้องคำนวณ Probability
- มีหลายสาเหตุที่เป็นไปได้

### 13.4.4 Kepner-Tregoe Problem Analysis

**หลักการ:** แยกแยะ "คืออะไร" vs "ไม่ใช่อะไร"

```
┌─────────────────────────────────────────────────────────────┐
│              KEPNER-TREGOE MATRIX                           │
└─────────────────────────────────────────────────────────────┘

  | ประเภท | IS (คือ)           | IS NOT (ไม่ใช่)     | Distinction |
  |--------|---------------------|---------------------|-------------|
  | What   | Payment ล่ม        | Employee API ปกติ   | Payment only|
  | Where  | Region TH          | Region SG           | TH config   |
  | When   | 14:30-15:15        | ตั้งแต่เช้า          | หลัง Deploy |
  | Who    | User 500 คน        | Admin ปกติ          | Regular User|
  | How    | Error 500          | Timeout             | 500 Error   |
```

**Distinction → Cause:**

```
Distinction: เกิดหลัง Deploy 14:00
→ Cause: Deploy ใหม่มี Bug

Distinction: Region TH เท่านั้น
→ Cause: Config TH ผิด
```

### 13.4.5 Apollo RCA Method

**หลักการ:** หา "Cause-and-Effect Chain" ที่ชัดเจน

**ขั้นตอน:**

1. **Define Problem** — ระบุให้ชัด
2. **Find Cause-and-Effect** — หา Chain
3. **Verify** — ตรวจสอบด้วย Evidence
4. **Fix** — แก้ที่ Root
5. **Prevent** — ป้องกัน

**Apollo เหมาะกับ:**
- ปัญหาที่มี Chain ชัดเจน
- ต้องการ Action ที่ชัด
- มี Evidence ครบ

### 13.4.6 การเลือก Tool

```
┌─────────────────────────────────────────────────────────────┐
│                  TOOL SELECTION GUIDE                       │
└─────────────────────────────────────────────────────────────┘

  ปัญหาง่าย? ──Yes──► 5 Whys
       │
       No
       │
       ▼
  ปัญหาหลายสาเหตุ? ──Yes──► Fishbone
       │
       No
       │
       ▼
  ต้องคำนวณ Prob? ──Yes──► FTA
       │
       No
       │
       ▼
  ต้องการ Action ชัด? ──Yes──► Apollo
       │
       No
       │
       ▼
  ใช้ Kepner-Tregoe
```

---

## 13.5 PSR Framework (Problem-Solution-Result)

### 13.5.1 โครงสร้าง PSR

```
┌─────────────────────────────────────────────────────────────┐
│                    PSR FRAMEWORK                            │
└─────────────────────────────────────────────────────────────┘

  ┌──────────────────────┐
  │ 1. PROBLEM           │  ปัญหาคืออะไร?
  │    • Symptom         │  อาการที่เห็น
  │    • Impact          │  ผลกระทบ
  │    • Scope           │  ขอบเขต
  └──────────┬───────────┘
             ▼
  ┌──────────────────────┐
  │ 2. SOLUTION          │  แก้อย่างไร?
  │    • Root Cause      │  สาเหตุราก
  │    • Action          │  สิ่งที่ทำ
  │    • Owner           │  ใครทำ
  └──────────┬───────────┘
             ▼
  ┌──────────────────────┐
  │ 3. RESULT            │  ผลเป็นอย่างไร?
  │    • Outcome         │  ผลลัพธ์
  │    • Metric          │  วัดผลได้
  │    • Learning        │  บทเรียน
  └──────────────────────┘
```

### 13.5.2 ตัวอย่าง PSR

```markdown
# PSR: Payment Timeout

## Problem
Payment ล่ม 45 นาที กระทบ 500 users, สูญเสีย ฿2M
Error Rate: 100% (ปกติ 0.1%)

## Solution
**Root Cause:** ไม่มี Index บน email → Full Scan → Pool เต็ม

**Actions:**
1. เพิ่ม Unique Index บน email (DBA, 1 วัน)
2. เพิ่ม Alert Pool > 80% (DevOps, 2 วัน)
3. เพิ่ม Test Concurrent (Dev, 1 Sprint)

## Result
- Error Rate: 100% → 0.1%
- Query Time: 5s → 50ms (ลด 99%)
- MTTD: 15 นาที → 3 นาที (ลด 80%)
- Incident ซ้ำ: 0 ครั้งใน 3 เดือน
```

---

## 13.6 RCA for Different Incident Types

### 13.6.1 RCA สำหรับ Availability Incident (ระบบล่ม)

**Data ที่ต้องเก็บ:**
- Uptime/Downtime
- Error Rate
- Latency
- Pod Status
- Deploy History
- Dependency Status

**คำถามหลัก:**
- อะไรทำให้ระบบหยุด?
- ทำไมไม่ Auto-recover?
- ทำไม Alert ช้า?
- ทำไมไม่ Rollback?

### 13.6.2 RCA สำหรับ Performance Incident (ช้า)

**Data ที่ต้องเก็บ:**
- Latency P50/P95/P99
- Throughput
- CPU/Memory
- Slow Query
- N+1 Query
- Cache Hit Rate

**คำถามหลัก:**
- ช้าตรงไหน? (App, DB, Network)
- ทำไมช้า? (Load, Query, Config)
- ทำไม Scale ไม่ทัน?

### 13.6.3 RCA สำหรับ Data Incident (ข้อมูลผิด)

**Data ที่ต้องเก็บ:**
- Audit Trail
- Change Log
- DB Snapshot
- Backup
- User Report

**คำถามหลัก:**
- ข้อมูลผิดอย่างไร?
- ผิดเมื่อไหร่?
- ใครแก้?
- แก้ทำไม?
- กู้คืนได้ไหม?

### 13.6.4 RCA สำหรับ Security Incident (Breach)

**Data ที่ต้องเก็บ:**
- Access Log
- Auth Log
- Network Log
- Audit Trail
- SIEM Alert

**คำถามหลัก:**
- เข้ามาได้อย่างไร?
- เข้าถึงอะไร?
- ออกไปกี่ข้อมูล?
- ตรวจพบช้าไหม?
- มี Control อะไรพลาด?

### 13.6.5 RCA สำหรับ Deployment Failure (Deploy พัง)

**Data ที่ต้องเก็บ:**
- Deploy Log
- CI/CD Log
- Test Report
- Rollback Log
- Change Diff

**คำถามหลัก:**
- Deploy อะไร?
- Test ทำไมไม่จับ?
- Rollback ทำไมช้า?
- Approval Process ผิดไหม?

---

## 13.7 Timeline Reconstruction

### 13.7.1 หลักการสร้าง Timeline

```
┌─────────────────────────────────────────────────────────────┐
│              TIMELINE RECONSTRUCTION                        │
└─────────────────────────────────────────────────────────────┘

  T-24h ──────► T-1h ──────► T-0 (Incident) ──────► T+1h
  (Pre)         (Pre)         (During)               (Post)
```

**Timeline ต้องมี:**
- Timestamp (แม่นยำวินาที)
- Event (อะไรเกิดขึ้น)
- Actor (ใครทำ / อะไรทำ)
- Source (หลักฐานจากไหน)

### 13.7.2 Timeline Template

```markdown
# Incident Timeline: INC-XXX

| เวลา | Event | Actor | Source |
|------|-------|-------|--------|
| 13:00 | Deploy v1.2.0 | DevOps | CI/CD Log |
| 14:00 | Traffic เพิ่ม (Peak) | System | Grafana |
| 14:25 | DB Pool Active = 80 | System | Metric |
| 14:28 | DB Pool Active = 100 | System | Metric |
| 14:30 | Error Rate = 5% | System | Grafana |
| 14:31 | Alert: HighErrorRate | Alertmanager | Alert Log |
| 14:33 | On-call Acknowledged | On-call A | PagerDuty |
| 14:35 | IC ประกาศ SEV-1 | IC | Slack |
| 14:40 | Rollback ตัดสินใจ | IC | Slack |
| 14:42 | Rollback เริ่ม | DevOps | K8s Log |
| 14:45 | Rollback เสร็จ | DevOps | K8s Log |
| 14:50 | Error Rate = 0.5% | System | Grafana |
| 15:15 | ยืนยันเสถียร | IC | Slack |
| 15:30 | Incident Resolved | IC | Slack |
```

### 13.7.3 Timeline Analysis

**คำถามที่ต้องตอบ:**

| ช่วง | คำถาม |
|------|-------|
| **Pre-Incident** | มี Change อะไร? มี Warning อะไร? |
| **Detection** | ตรวจพบช้าไหม? ทำไม? |
| **Response** | ตอบสนองเร็วไหม? ตัดสินใจถูกไหม? |
| **Mitigation** | Mitigate เร็วไหม? วิธีถูกไหม? |
| **Recovery** | ฟื้นตัวเร็วไหม? ครบไหม? |

**Gap Analysis:**

```
Detection Time = Alert Time - Incident Start
             = 14:31 - 14:28 = 3 นาที ✅ (< 5 นาที)

Response Time = Acknowledge - Alert
              = 14:33 - 14:31 = 2 นาที ✅ (< 5 นาที)

Mitigation Time = Rollback Complete - Acknowledge
                = 14:45 - 14:33 = 12 นาที ✅ (< 15 นาที)

Total MTTR = Resolved - Incident Start
           = 15:30 - 14:28 = 62 นาที ⚠️ (> 30 นาที)
```

---

## 13.8 Evidence Collection (Deep Dive)

### 13.8.1 ประเภท Evidence

| ประเภท | ตัวอย่าง | ความน่าเชื่อถือ |
|--------|----------|:---------------:|
| **Direct** | Log, Trace, Metric | สูง |
| **Circumstantial** | Timeline, Correlation | ปานกลาง |
| **Testimonial** | Interview | ต่ำ |
| **Documentary** | Config, Code | สูง |

### 13.8.2 Evidence Preservation Checklist

- [ ] **Logs** — Export ก่อน Rotate (ปกติ 7–30 วัน)
- [ ] **Metrics** — Snapshot ก่อน Data หาย (ปกติ 15 วัน)
- [ ] **Traces** — Export Trace ID ที่เกี่ยวข้อง
- [ ] **Pod** — `kubectl describe` ก่อน Restart
- [ ] **DB** — `pg_stat_activity` ก่อน Kill
- [ ] **Config** — `git diff` ก่อน Revert
- [ ] **Screenshot** — Grafana, Dashboard
- [ ] **Chat** — Slack Transcript
- [ ] **Interview** — บันทึกเสียง/โน้ต

### 13.8.3 Chain of Custody

```
┌─────────────────────────────────────────────────────────────┐
│              CHAIN OF CUSTODY                               │
└─────────────────────────────────────────────────────────────┘

  Evidence → Collected By → Stored At → Accessed By → Used In
     │            │             │           │           │
  Timestamp   Name/Role    Location    Name/Time   Report
```

**Template:**

```markdown
## Evidence Chain of Custody

| # | Evidence | Collected By | Time | Stored At | Accessed By |
|---|----------|--------------|------|-----------|-------------|
| 1 | app.log | DevOps A | 15:00 | S3://evidence/INC-XXX/ | RCA Lead |
| 2 | Metric Snapshot | On-call B | 15:02 | S3://evidence/INC-XXX/ | RCA Lead |
| 3 | Trace abc123 | Dev C | 15:05 | Jaeger | RCA Lead |
```

### 13.8.4 Evidence Anti-Patterns

| ❌ Anti-Pattern | ผลกระทบ | ✅ ควรทำ |
|----------------|---------|----------|
| ลบ Log ก่อน RCA | หลักฐานหาย | Export ก่อน |
| Restart Pod ทันที | State หาย | `describe` ก่อน |
| เดาจากความจำ | ไม่แม่น | ใช้ Log |
| เชื่อคนเดียว | Bias | หลายแหล่ง |
| ไม่บันทึก Source | ไม่ตรวจสอบได้ | บันทึกทุกแหล่ง |

---

## 13.9 Blameless Culture (วัฒนธรรมไม่หาคนผิด)

### 13.9.1 หลักการ Blameless

```
┌─────────────────────────────────────────────────────────────┐
│              BLAMELESS PRINCIPLES                           │
└─────────────────────────────────────────────────────────────┘

  1. คนทำผิดเพราะระบบอนุญาต → แก้ระบบ ไม่ใช่คน
  2. ทุกคนทำดีที่สุด ณ ขณะนั้น → ไม่ตัดสินย้อนหลัง
  3. ความผิดพลาดคือบทเรียน → เรียนรู้ ไม่ลงโทษ
  4. กล้าแจ้ง = ปลอดภัย → ไม่กลัวถูกตำหนิ
  5. เน้น Systemic → ไม่ใช่ Individual
```

### 13.9.2 Blameless vs Blameful

| ประเด็น | Blameful ❌ | Blameless ✅ |
|---------|------------|--------------|
| คำถาม | "ใครทำ?" | "อะไรทำให้เกิด?" |
| โฟกัส | คน | ระบบ |
| ผลลัพธ์ | กลัว, ปิดข่าว | กล้าแจ้ง, เรียนรู้ |
| Action | ลงโทษ | แก้ระบบ |
| วัฒนธรรม | Toxic | Learning |

### 13.9.3 ตัวอย่าง Blameless Language

**❌ Blameful:**

```
"Dev A ลืมเพิ่ม Index ทำให้ระบบล่ม"
"Ops B ตอบช้า ทำให้ MTTR สูง"
"QA C Test ไม่ครบ ทำให้บั๊กหลุด"
```

**✅ Blameless:**

```
"ระบบไม่มี Checklist บังคับ Index Review"
"Alert ไม่ชัด ทำให้ On-call ไม่รู้ Priority"
"Test Coverage ไม่ครอบคลุม Concurrent Scenario"
```

### 13.9.4 วิธีสร้าง Blameless Culture

- ✅ **Leadership ต้องนำ** — ผู้บริหารไม่ตำหนิ
- ✅ **แยกคนออกจากปัญหา** — เน้นระบบ
- ✅ **ให้รางวัลการแจ้ง** — ไม่ลงโทษ
- ✅ **แชร์บทเรียน** — ทุกคนเรียนรู้
- ✅ **Action ที่ Systemic** — ไม่ใช่ "ระวังมากขึ้น"
- ✅ **ทำให้ปลอดภัย** — Psychological Safety

---

## 13.10 Contributing Factors Analysis

### 13.10.1 Root Cause vs Contributing Factors

```
┌─────────────────────────────────────────────────────────────┐
│              ROOT vs CONTRIBUTING                           │
└─────────────────────────────────────────────────────────────┘

  Root Cause:
  • จำเป็นและเพียงพอ
  • ถ้าแก้ → ปัญหาหาย
  • มี 1 (หรือน้อย)

  Contributing Factors:
  • ทำให้รุนแรงขึ้น / เร็วขึ้น
  • ไม่จำเป็นแต่มีผล
  • มีหลายตัว
```

### 13.10.2 ตัวอย่าง Contributing Factors

**Incident:** Payment ล่ม 45 นาที

**Root Cause:** ไม่มี Index บน email

**Contributing Factors:**
| # | Factor | ผลกระทบ |
|---|--------|---------|
| 1 | ไม่มี Alert Pool > 80% | ตรวจพบช้า 3 นาที |
| 2 | Runbook ไม่มี Scenario นี้ | แก้ช้า 5 นาที |
| 3 | Deploy Friday | ไม่มีคนเฝ้า |
| 4 | Pool Size เล็ก | เต็มเร็ว |
| 5 | ไม่มี Circuit Breaker | ลามทั้งระบบ |

### 13.10.3 Contributing Factors Categories

| หมวด | ตัวอย่าง |
|------|----------|
| **Technical** | Config ผิด, Architecture เปราะ |
| **Process** | ไม่มี Review, ไม่มี Checklist |
| **People** | ขาด Training, ไม่มี On-call |
| **Environment** | Peak Load, Network |
| **Detection** | Alert ไม่มี, Alert ช้า |
| **Response** | Runbook ไม่มี, Escalation ช้า |
| **Recovery** | Rollback ช้า, Backup ไม่มี |

### 13.10.4 Contributing Factors Template

```markdown
## Contributing Factors

| # | Factor | Category | Impact | Action |
|---|--------|----------|--------|--------|
| 1 | Alert Pool > 80% ไม่มี | Detection | MTTD +3 นาที | เพิ่ม Alert |
| 2 | Runbook ไม่มี Scenario | Response | MTTR +5 นาที | อัปเดต Runbook |
| 3 | Deploy Friday | Process | ไม่มีคนเฝ้า | ห้าม Deploy Friday |
| 4 | Pool Size = 100 | Technical | เต็มเร็ว | เพิ่ม Pool |
| 5 | ไม่มี Circuit Breaker | Technical | ลามทั้งระบบ | เพิ่ม CB |
```

---

## 13.11 Action Planning

### 13.11.1 ประเภท Action (ละเอียด)

| ประเภท | ความหมาย | ตัวอย่าง | Timeline |
|--------|----------|----------|----------|
| **Corrective** | แก้ปัญหาเฉพาะหน้า | Restart, Rollback | ทันที |
| **Preventive** | ป้องกันเกิดซ้ำ | Index, Test, Review | 1 Sprint |
| **Detective** | ตรวจพบเร็วขึ้น | Alert, Monitor | 1 Sprint |
| **Mitigating** | ลดผลกระทบ | Circuit Breaker, Retry | 1–2 Sprint |
| **Process** | ปรับ Process | Checklist, Review | 1 Sprint |
| **Training** | ฝึกคน | Workshop | 1 เดือน |

### 13.11.2 SMART Action Criteria (ขยาย)

| ตัวอักษร | คำถาม | ตัวอย่างผิด | ตัวอย่างถูก |
|----------|-------|-------------|-------------|
| **S**pecific | ชัดเจนไหม? | "ปรับปรุงระบบ" | "เพิ่ม Index บน email" |
| **M**easurable | วัดได้ไหม? | "เร็วขึ้น" | "Query Time < 100ms" |
| **A**chievable | ทำได้ไหม? | "Zero Bug" | "Coverage +5%" |
| **R**elevant | เกี่ยวกับ Root Cause? | "เพิ่ม Feature" | "เพิ่ม Test Concurrent" |
| **T**ime-bound | มีกำหนดไหม? | "เร็วๆ นี้" | "ภายใน 2024-11-25" |

### 13.11.3 Action Priority Matrix

```
┌─────────────────────────────────────────────────────────────┐
│              ACTION PRIORITY MATRIX                         │
└─────────────────────────────────────────────────────────────┘

         Impact
         Low    High
    ┌─────┬─────┬─────┐
 H  │ P2  │ P1  │ P0  │
 i  ├─────┼─────┼─────┤
 g  │ P3  │ P2  │ P1  │
 h  ├─────┼─────┼─────┤
    │ P3  │ P3  │ P2  │
 L  └─────┴─────┴─────┘
         Low    High
              Effort

  P0: ทำทันที (≤ 1 สัปดาห์)
  P1: ทำเร็ว (≤ 1 Sprint)
  P2: ทำตามแผน (≤ 1 เดือน)
  P3: ทำเมื่อมีเวลา (Backlog)
```

### 13.11.4 Action Register Template

```markdown
# Action Register: INC-XXX

| # | Action | Type | Priority | Owner | Due | Status |
|---|--------|------|----------|-------|-----|--------|
| 1 | เพิ่ม Index บน email | Preventive | P0 | DBA A | 2024-11-20 | ⏳ |
| 2 | เพิ่ม Alert Pool > 80% | Detective | P0 | DevOps B | 2024-11-21 | ⏳ |
| 3 | อัปเดต Runbook DB Pool | Process | P1 | IC C | 2024-11-25 | ⏳ |
| 4 | เพิ่ม Test Concurrent | Preventive | P1 | Dev D | Sprint 25 | ⏳ |
| 5 | เพิ่ม Circuit Breaker | Mitigating | P2 | Architect | Sprint 26 | ⏳ |
| 6 | Training Pool Mgmt | Training | P3 | Tech Lead | Q1 2025 | ⏳ |
```

### 13.11.5 Action Tracking

```
┌─────────────────────────────────────────────────────────────┐
│              ACTION TRACKING CADENCE                        │
└─────────────────────────────────────────────────────────────┘

  P0 (≤ 1 สัปดาห์): ติดตามรายวัน
  P1 (≤ 1 Sprint): ติดตามรายสัปดาห์
  P2 (≤ 1 เดือน): ติดตาม 2 สัปดาห์
  P3 (Backlog): ติดตามรายไตรมาส

  Review Meeting: ทุก 2 สัปดาห์ (RCA Lead + Owners)
```

### 13.11.6 Action Completion Criteria

- [ ] Action เสร็จจริง (ไม่ใช่แค่ "ทำแล้ว")
- [ ] Test/Verify แล้ว
- [ ] Documentation อัปเดต
- [ ] ทีมรับทราบ
- [ ] KPI ดีขึ้น (ถ้าวัดได้)
- [ ] ปิดใน Register

---

## 13.12 Follow-up & Monitoring

### 13.12.1 Monitoring Plan

```markdown
# Monitoring Plan: INC-XXX

| Action | KPI | Baseline | Target | Duration | Owner |
|--------|-----|----------|--------|----------|-------|
| เพิ่ม Index | Query Time P95 | 5s | < 100ms | 30 วัน | DBA |
| เพิ่ม Alert | MTTD | 15 นาที | < 5 นาที | 30 วัน | DevOps |
| เพิ่ม Test | Coverage | 80% | 85% | 30 วัน | Dev |
| อัปเดต Runbook | MTTR | 62 นาที | < 30 นาที | 30 วัน | IC |
```

### 13.12.2 Recurrence Check

```
┌─────────────────────────────────────────────────────────────┐
│              RECURRENCE MONITORING                          │
└─────────────────────────────────────────────────────────────┘

  หลัง RCA เสร็จ → ติดตาม 30/60/90 วัน
         │
         ▼
  Incident ซ้ำ?
         │
    ┌────┴────┐
   No        Yes
    │         │
    ▼         ▼
  ✅ ปิด   🔴 RCA ใหม่
           (ทำไม Action ไม่พอ?)
```

### 13.12.3 Effectiveness Review

**คำถาม 30 วันหลัง RCA:**

- [ ] Incident ซ้ำไหม?
- [ ] KPI ดีขึ้นไหม?
- [ ] Action เสร็จจริงไหม?
- [ ] มี Action ใหม่ที่ต้องทำไหม?
- [ ] บทเรียนถูกเผยแพร่ไหม?
- [ ] ปิด RCA ได้ไหม?

### 13.12.4 RCA Closure Checklist

- [ ] Root Cause ระบุชัด
- [ ] Contributing Factors ครบ
- [ ] Action ทั้งหมดมี Owner + Due
- [ ] Action สำเร็จ ≥ 90%
- [ ] KPI ดีขึ้นตามเป้า
- [ ] ไม่มี Incident ซ้ำใน 30 วัน
- [ ] Report เผยแพร่
- [ ] บทเรียนบันทึกใน Knowledge Base
- [ ] RCA Lead + EM Sign-off

---

## 13.13 RCA Report Template (ครบชุด)

```markdown
# RCA Report: INC-XXX

**Incident:** INC-XXX
**Severity:** SEV-1
**Date:** [YYYY-MM-DD]
**Duration:** [X ชั่วโมง Y นาที]
**RCA Lead:** [ชื่อ]
**Participants:** [รายชื่อ]
**Report Date:** [YYYY-MM-DD]
**Status:** [Draft / Final]

---

## 1. Executive Summary
[สรุป 3–5 ประโยค: เกิดอะไร, ทำไม, แก้อย่างไร, ป้องกันอย่างไร]

## 2. Problem Statement
**What:** [อธิบาย]
**When:** [เวลา]
**Where:** [สถานที่]
**Who:** [ผู้ได้รับผลกระทบ]
**Impact:** [ผลกระทบ + ตัวเลข]
**Scope:** [ขอบเขต]

## 3. Timeline
| เวลา | Event | Actor | Source |
|------|-------|-------|--------|
| HH:MM | [Event] | [ชื่อ] | [Log] |

## 4. Evidence Collected
| # | Type | Source | Link |
|---|------|--------|------|
| 1 | Log | App Server | [link] |
| 2 | Metric | Grafana | [link] |

## 5. Root Cause Analysis

### 5.1 5 Whys
1. **Why?** — [คำตอบ]
2. **Why?** — [คำตอบ]
3. **Why?** — [คำตอบ]
4. **Why?** — [คำตอบ]
5. **Why?** — [คำตอบ]

### 5.2 Root Cause
[ระบุ Root Cause ชัดเจน]

### 5.3 Contributing Factors
| # | Factor | Category | Impact |
|---|--------|----------|--------|
| 1 | [Factor] | [Category] | [Impact] |

### 5.4 Fishbone (ถ้ามี)
[แนบ Diagram]

## 6. Actions

### 6.1 Corrective (แก้เฉพาะหน้า)
| # | Action | Owner | Due | Status |
|---|--------|-------|-----|--------|
| 1 | [Action] | [ชื่อ] | [Date] | ✅ |

### 6.2 Preventive (ป้องกัน)
| # | Action | Owner | Due | Status |
|---|--------|-------|-----|--------|
| 1 | [Action] | [ชื่อ] | [Date] | ⏳ |

### 6.3 Detective (ตรวจพบเร็ว)
| # | Action | Owner | Due | Status |
|---|--------|-------|-----|--------|
| 1 | [Action] | [ชื่อ] | [Date] | ⏳ |

## 7. Monitoring Plan
| KPI | Baseline | Target | Duration | Owner |
|-----|----------|--------|----------|-------|
| [KPI] | [Base] | [Target] | [Days] | [Name] |

## 8. Lessons Learned
- [บทเรียน 1]
- [บทเรียน 2]
- [บทเรียน 3]

## 9. What Went Well
- [สิ่งที่ดี 1]
- [สิ่งที่ดี 2]

## 10. What Could Be Improved
- [สิ่งที่ปรับ 1]
- [สิ่งที่ปรับ 2]

## 11. Attachments
- Timeline Detail: [link]
- Log Export: [link]
- Metric Snapshot: [link]
- Fishbone Diagram: [link]
- Trace: [link]

## 12. Sign-off
- **RCA Lead:** [ชื่อ] — [Date]
- **Engineering Manager:** [ชื่อ] — [Date]
- **Stakeholder:** [ชื่อ] — [Date]
```

---

## 13.14 Postmortem Meeting Protocol

### 13.14.1 วาระการประชุม (60–90 นาที)

```
1. Welcome & Ground Rules (5 นาที)
   • Blameless reminder
   • Agenda

2. Timeline Review (15 นาที)
   • ทีมเล่า Timeline
   • เติมข้อมูล

3. Root Cause Analysis (25 นาที)
   • 5 Whys / Fishbone
   • ยืนยัน Root Cause

4. Contributing Factors (10 นาที)
   • ระบุ Factors

5. Action Planning (20 นาที)
   • กำหนด Action + Owner + Due

6. Lessons Learned (10 นาที)
   • What went well
   • What to improve

7. Close (5 นาที)
   • สรุป
   • Next steps
```

### 13.14.2 Ground Rules

- ✅ **Blameless** — ไม่ตำหนิใคร
- ✅ **Evidence-Based** — ใช้ข้อมูล
- ✅ **ทุกคนมีส่วนร่วม** — ไม่มี HiPPO
- ✅ **Time-boxed** — ตามวาระ
- ✅ **Action-Oriented** — จบด้วย Action
- ✅ **Confidential** — สิ่งที่พูดในห้อง อยู่ในห้อง (ยกเว้นบทเรียน)

### 13.14.3 บทบาทใน Postmortem

| บทบาท | หน้าที่ |
|-------|---------|
| **Facilitator** | ดำเนินการ, Time-box |
| **RCA Lead** | นำวิเคราะห์ |
| **Scribe** | บันทึก Minutes |
| **SME** | ให้ข้อมูล Technical |
| **Action Owner** | รับ Action |
| **Stakeholder** | รับฟัง (ไม่บังคับ) |

---

## 13.15 RCA for Different Severities

### 13.15.1 SEV-1 (Critical)

```
┌─────────────────────────────────────────────────────────────┐
│              SEV-1 RCA                                      │
└─────────────────────────────────────────────────────────────┘

  Timeline: ≤ 48 ชั่วโมง
  Type: Formal RCA
  Participants: IC + SME + EM + Architect + Stakeholder
  Duration: 2–4 ชั่วโมง
  Tools: 5 Whys + Fishbone + FTA
  Output: Full Report + Exec Summary
  Approval: EM + Stakeholder
```

### 13.15.2 SEV-2 (High)

```
  Timeline: ≤ 72 ชั่วโมง
  Type: Formal RCA (Lightweight)
  Participants: IC + SME + Tech Lead
  Duration: 1–2 ชั่วโมง
  Tools: 5 Whys
  Output: Full Report
  Approval: Tech Lead
```

### 13.15.3 SEV-3 (Medium)

```
  Timeline: ≤ 1 สัปดาห์
  Type: Lightweight RCA
  Participants: On-call + Dev
  Duration: 30–60 นาที
  Tools: 5 Whys
  Output: RCA Note (ครึ่งหน้า)
  Approval: Tech Lead
```

### 13.15.4 SEV-4 (Low)

```
  Timeline: ตามต้องการ
  Type: Optional
  Participants: On-call
  Duration: 15 นาที
  Tools: 5 Whys (ถ้าจำเป็น)
  Output: Note ใน Ticket
  Approval: —
```

---

## 13.16 KPIs สำหรับ RCA

| KPI | คำนิยาม | เป้าหมาย | วิธีวัด |
|-----|---------|----------|---------|
| **RCA Completion Time** | เวลาจาก Incident ถึง RCA เสร็จ | ≤ 48 ชม. (SEV-1) | RCA Log |
| **RCA Coverage** | % Incident ที่มี RCA | 100% (SEV-1/2) | Incident Log |
| **Action Completion Rate** | % Action ที่เสร็จตาม Due | ≥ 90% | Action Register |
| **Action Effectiveness** | % Action ที่ KPI ดีขึ้น | ≥ 85% | KPI Tracking |
| **Recurrence Rate** | % Incident ที่เกิดซ้ำ | < 5% | Incident Log |
| **RCA Quality Score** | คะแนนคุณภาพ RCA | ≥ 4/5 | Peer Review |
| **Time to Action** | เวลาจาก RCA ถึง Action แรก | ≤ 7 วัน | Action Log |
| **MTTR Improvement** | MTTR ดีขึ้นหลัง RCA | ≥ 20% | Incident Log |
| **Near Miss Reporting** | จำนวน Near Miss ที่รายงาน | ≥ 5/ไตรมาส | Report Log |
| **Learning Sharing** | จำนวนครั้งที่แชร์บทเรียน | ≥ 2/ไตรมาส | Calendar |

### 13.16.1 RCA Dashboard ตัวอย่าง

```
┌─────────────────────────────────────────────────────────────┐
│              RCA METRICS — Q4 2024                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  RCA Coverage:            ██████████  100%  🟢             │
│  Completion Time (SEV-1): █████████░  42 ชม. 🟢             │
│  Action Completion:       █████████░  92%   🟢             │
│  Action Effectiveness:    ████████░░  88%   🟢             │
│  Recurrence Rate:         █░░░░░░░░░  3%    🟢             │
│  RCA Quality:             ████████░░  4.3/5 🟢             │
│  MTTR Improvement:        ████████░░  -28%  🟢             │
│  Near Miss Reports:       ███████░░░  7     🟢             │
│                                                              │
│  Highlights:                                                 │
│  • Incident ลดลง 40% จาก Q3                                │
│  • MTTR ลดจาก 62 → 45 นาที                                 │
│                                                              │
│  Concerns:                                                   │
│  • Action บางตัวล่าช้า (P2/P3)                              │
│  • Near Miss Report ยังน้อย                                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 13.17 Anti-Patterns

### 13.17.1 RCA Anti-Patterns

| # | ❌ Anti-Pattern | ผลกระทบ | ✅ ควรทำ |
|---|----------------|---------|----------|
| 1 | หาคนผิด | ทีมกลัว, ปิดข่าว | Blameless |
| 2 | แก้ที่ Symptom | เกิดซ้ำ | หา Root Cause |
| 3 | หยุดที่ 5 Whys | อาจไม่ถึงราก | ถามจนถึงราก |
| 4 | ไม่มี Timeline | ไม่เห็นภาพ | สร้าง Timeline |
| 5 | ไม่มี Contributing Factors | แก้ไม่ครบ | ระบุ Factors |
| 6 | Action ไม่มี Owner | ไม่มีคนทำ | ระบุ Owner |
| 7 | Action กว้างเกิน | ทำไม่ได้ | SMART |
| 8 | ไม่มี Due Date | ไม่เสร็จ | ระบุ Due |
| 9 | ไม่ติดตาม Action | ไม่เกิดผล | ติดตาม |
| 10 | ไม่แชร์บทเรียน | เกิดซ้ำที่อื่น | แชร์ |
| 11 | Report ยาว ไม่มีสรุป | ไม่มีคนอ่าน | Exec Summary |
| 12 | ไม่มี Blameless | Toxic | สร้าง Culture |

### 13.17.2 5 Whys Anti-Patterns

| ❌ | ✅ |
|----|----|
| เดาคำตอบ | ใช้ Evidence |
| หยุดที่ 5 | ถามจนถึงราก |
| ชี้คน | ชี้ระบบ |
| เส้นเดียว | Branching |
| ไม่บันทึก | บันทึกทุก Why |

### 13.17.3 Action Anti-Patterns

| ❌ | ✅ |
|----|----|
| "ระวังมากขึ้น" | "เพิ่ม Checklist" |
| "Train ทีม" | "เพิ่ม Test Coverage" |
| "ปรับปรุงระบบ" | "เพิ่ม Index บน email" |
| ไม่มี Owner | มี Owner ชัด |
| ไม่มี Due | มี Due Date |

---

## 13.18 Best Practices

### 13.18.1 Do's

- ✅ **Blameless** — เน้นระบบ ไม่ใช่คน
- ✅ **Evidence-Based** — ใช้ข้อมูล ไม่เดา
- ✅ **Timeline ละเอียด** — วินาที
- ✅ **Contributing Factors** — ระบุครบ
- ✅ **SMART Action** — ชัด วัดได้ มี Due
- ✅ **Owner ชัด** — ทุก Action
- ✅ **ติดตาม** — ทุก 2 สัปดาห์
- ✅ **แชร์บทเรียน** — ทุกทีม
- ✅ **Near Miss** — รายงานด้วย
- ✅ **Proactive RCA** — ก่อนเกิด

### 13.18.2 Don'ts

- ❌ หาคนผิด
- ❌ แก้ที่ Symptom
- ❌ เดาคำตอบ
- ❌ Action กว้างเกิน
- ❌ ไม่มี Owner
- ❌ ไม่มี Due
- ❌ ไม่ติดตาม
- ❌ ไม่แชร์
- ❌ Report ยาว ไม่มีสรุป
- ❌ ละเลย Near Miss

---

## 13.19 FAQ

**Q1: RCA ต่างจาก Incident Report ยังไง?**
A: Incident Report = บันทึกเหตุการณ์ (What/When/Who), RCA = วิเคราะห์สาเหตุ (Why/How to prevent) — Incident Report เป็น Input ของ RCA

**Q2: ต้องทำ RCA ทุก Incident ไหม?**
A: **ไม่** — บังคับ SEV-1/2, แนะนำ SEV-3 ที่ซ้ำ, Optional SEV-4

**Q3: RCA ใช้เวลานานแค่ไหน?**
A: SEV-1: 2–4 ชั่วโมง (Meeting) + ≤ 48 ชม. (Report), SEV-2: 1–2 ชั่วโมง, SEV-3: 30–60 นาที

**Q4: ถ้าหา Root Cause ไม่ได้ ทำไง?**
A: (1) รวบรวม Evidence เพิ่ม (2) ใช้ Tool อื่น (3) ปรึกษา SME (4) ถ้ายังไม่ได้ → ระบุ Contributing Factors + Action ที่ Mitigate

**Q5: Root Cause มีได้หลายตัวไหม?**
A: **ได้** — แต่ส่วนใหญ่มี 1 Primary + หลาย Contributing — ถ้ามีหลาย Root → ใช้ Fishbone/FTA

**Q6: Blameless จริงๆ หมายความว่าอะไร?**
A: ไม่ได้หมายความว่าไม่รับผิดชอบ — หมายความว่า **ไม่ตำหนิคน** แต่ **แก้ระบบ** — คนยังรับผิดชอบ Action แต่ไม่ถูกลงโทษ

**Q7: Action เท่าไหร่ถึงพอ?**
A: **ตาม Root Cause + Contributing Factors** — ปกติ 3–7 Actions — น้อยเกินไป = แก้ไม่ครบ, มากเกินไป = ทำไม่ไหว

**Q8: ต้อง RCA Incident ที่ Rollback แก้ได้ไหม?**
A: **ต้อง** — เพราะ Rollback แก้ Symptom ไม่ได้แก้ Root Cause — ถ้าไม่ RCA → เกิดซ้ำ

**Q9: Near Miss ต้อง RCA ไหม?**
A: **แนะนำ** — ต้นทุนต่ำ, ป้องกัน Incident จริง — แต่ใช้ Lightweight RCA

**Q10: วัดผล RCA ยังไง?**
A: ดู KPIs 13.16 — หลักๆ คือ Recurrence Rate, Action Completion, MTTR Improvement

---

## 13.20 Glossary

| คำ | ความหมาย |
|----|----------|
| **RCA** | Root Cause Analysis — การวิเคราะห์สาเหตุราก |
| **Root Cause** | สาเหตุที่แท้จริง (แก้แล้วปัญหาหาย) |
| **Symptom** | อาการที่เห็น (ไม่ใช่สาเหตุ) |
| **Contributing Factor** | ปัจจัยที่ทำให้รุนแรงขึ้น |
| **Blameless** | วัฒนธรรมไม่หาคนผิด |
| **5 Whys** | ถาม "ทำไม" 5 ครั้ง |
| **Fishbone** | แผนภาพก้างปลา (6M) |
| **FTA** | Fault Tree Analysis |
| **PSR** | Problem-Solution-Result |
| **Postmortem** | การประชุมหลัง Incident |
| **Near Miss** | เกือบเกิด |
| **Corrective** | Action แก้เฉพาะหน้า |
| **Preventive** | Action ป้องกัน |
| **Detective** | Action ตรวจพบเร็ว |
| **SMART** | Specific, Measurable, Achievable, Relevant, Time-bound |
| **Chain of Custody** | การบันทึกหลักฐาน |
| **MTTD** | Mean Time to Detect |
| **MTTR** | Mean Time to Resolve |
| **SME** | Subject Matter Expert |
| **HiPPO** | Highest Paid Person's Opinion |

---

## 13.21 ความเชื่อมโยงกับเล่มอื่น

| เล่ม | ความเชื่อมโยงกับเล่ม 13 |
|------|-------------------------|
| **เล่ม 1 (PO/BA)** | Requirement ที่ผิด → RCA |
| **เล่ม 2 (Full-Stack)** | Code Bug → RCA |
| **เล่ม 3 (Architect)** | Architecture → RCA |
| **เล่ม 4 (QA)** | Test ที่พลาด → RCA |
| **เล่ม 5 (DevOps)** | Infrastructure → RCA |
| **เล่ม 7 (On-call)** | Incident Response → RCA |
| **เล่ม 10 (AI-Assisted)** | /tb-investigate-error → RCA |
| **เล่ม 11 (Hotfix)** | Hotfix → RCA |
| **เล่ม 12 (CI/CD)** | Deploy Failure → RCA |
| **เล่ม 14 (Security)** | Security Incident → RCA |
| **เล่ม 15 (Knowledge)** | บทเรียน → Knowledge Base |

---

## 13.22 สรุปสาระสำคัญ (Key Takeaways)

```text
┌─────────────────────────────────────────────────────────────┐
│                  RCA (ROOT CAUSE ANALYSIS)                  │
│                     KEY TAKEAWAYS                           │
└─────────────────────────────────────────────────────────────┘

  1. RCA ≠ หาคนผิด — Blameless Culture
  2. 6 Steps — Define → Collect → Identify → Find → Fix → Monitor
  3. 5 Whys — ถามจนถึงราก ไม่หยุดที่ 5
  4. Fishbone — 6M (Man, Method, Machine, Material, Measurement, Environment)
  5. Evidence-Based — ใช้ข้อมูล ไม่เดา
  6. Timeline ละเอียด — วินาที
  7. Root Cause vs Contributing — แยกให้ชัด
  8. SMART Action — ชัด วัดได้ มี Due
  9. Owner ชัด — ทุก Action
  10. ติดตาม — ทุก 2 สัปดาห์
  11. วัดผล — Recurrence, Action Completion, MTTR
  12. แชร์บทเรียน — ทุกทีม
  13. Near Miss — รายงานด้วย
  14. Report — Exec Summary + Detail
  15. ปิด RCA — Action ≥ 90% + ไม่ซ้ำ 30 วัน
```

---