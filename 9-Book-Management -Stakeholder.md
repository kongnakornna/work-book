## 📘 เล่ม 9 (ฉบับขยาย): คู่มือผู้บริหาร (Management / Stakeholder)
**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับสมบูรณ์ (ส่วนที่ 1, 2 และภาค 1–3)

> **หมายเหตุ:** เอกสารนี้เป็นฉบับขยายของเล่ม 9 ใน Master Index โดยเพิ่มรายละเอียดเชิงปฏิบัติสำหรับผู้บริหาร ได้แก่ Governance Structure, KPI Dashboard เชิงลึก, Reporting Cadence (Weekly/Monthly/Quarterly), Decision Frameworks, Budget & Resource Management, Risk Management, Steering Committee Protocol, Change Control, Benefits Realization และ Templates ที่ใช้ได้จริง

---
## 9.0 บทนำและกลุ่มเป้าหมาย

คู่มือนี้สำหรับ **ผู้บริหารและผู้มีส่วนได้ส่วนเสีย** ที่ต้องการติดตาม กำกับ และตัดสินใจเชิงกลยุทธ์เกี่ยวกับโครงการ FinTech & Accounting Technology

### 9.0.1 กลุ่มผู้บริหารที่คู่มือนี้ครอบคลุม

| กลุ่ม | บทบาท | สิ่งที่ต้องรู้จากคู่มือนี้ |
|-------|-------|---------------------------|
| **Executive Sponsor** | ผู้สนับสนุนระดับสูง | Governance, Budget, Strategic Alignment |
| **Steering Committee** | คณะกรรมการกำกับ | Decision Framework, Risk, Escalation |
| **Project Sponsor** | ผู้สนับสนุนโครงการ | Status, KPI, Budget, Risks |
| **Finance Manager / Director** | ผู้บริหารการเงิน | Benefits, Cost, Compliance |
| **IT Manager / CIO** | ผู้บริหารไอที | Architecture, Security, Operations |
| **Business Owner** | เจ้าของกระบวนการ | Adoption, Benefits Realization |
| **PMO** | สำนักงานบริหารโครงการ | Reporting Standards, Governance |

### 9.0.2 บทบาทของผู้บริหารในโครงการ (RACI)

| กิจกรรม | Executive Sponsor | Steering Committee | Project Sponsor | PMO |
|---------|:-----------------:|:------------------:|:---------------:|:---:|
| อนุมัติงบประมาณ | **A** | **R** | C | C |
| อนุมัติ Scope Change (ใหญ่) | **A** | **R** | C | C |
| ตัดสินใจเชิงกลยุทธ์ | **A** | **R** | C | I |
| ติดตาม Status | I | **R** | **R** | **R** |
| บริหาร Risk ระดับองค์กร | **A** | **R** | C | C |
| Escalate ปัญหา | **A** | **R** | **R** | I |
| Benefits Realization | **A** | C | **R** | C |

**R** = Responsible | **A** = Accountable | **C** = Consulted | **I** = Informed

---

## 9.1 Governance Structure

### 9.1.1 โครงสร้างการกำกับดูแล

```
┌─────────────────────────────────────────────────────────────┐
│                   GOVERNANCE STRUCTURE                      │
└─────────────────────────────────────────────────────────────┘

  ┌──────────────────────────────────────┐
  │      EXECUTIVE SPONSOR (C-Level)     │
  │  • อนุมัติงบประมาณ lớn               │
  │  • ตัดสินใจเชิงกลยุทธ์                │
  │  • พบทุกไตรมาส                        │
  └──────────────────┬───────────────────┘
                     │
                     ▼
  ┌──────────────────────────────────────┐
  │      STEERING COMMITTEE              │
  │  • CIO, CFO, Business Owner, PM      │
  │  • อนุมัติ Scope / Budget Change     │
  │  • ตัดสินใจ Escalation                │
  │  • พบทุกเดือน                         │
  └──────────────────┬───────────────────┘
                     │
                     ▼
  ┌──────────────────────────────────────┐
  │      PROJECT SPONSOR                 │
  │  • ติดตาม Status รายสัปดาห์          │
  │  • แก้ปัญหา Operational              │
  │  • พบทุกสัปดาห์                       │
  └──────────────────┬───────────────────┘
                     │
                     ▼
  ┌──────────────────────────────────────┐
  │      PM / PMO                        │
  │  • บริหารโครงการรายวัน              │
  │  • รายงาน Status                     │
  │  • ประสานทีม                         │
  └──────────────────┬───────────────────┘
                     │
                     ▼
  ┌──────────────────────────────────────┐
  │      DELIVERY TEAM                   │
  │  PO, BA, Dev, QA, DevOps, Architect  │
  └──────────────────────────────────────┘
```

### 9.1.2 บทบาทและความรับผิดชอบของแต่ละระดับ

| ระดับ | ตัดสินใจเรื่อง | ความถี่การประชุม | Output |
|-------|---------------|-----------------|--------|
| **Executive Sponsor** | งบประมาณ lớn (>10M), Strategic Direction, Go/No-Go | ไตรมาส | Strategic Decision |
| **Steering Committee** | Scope Change, Budget Reallocation, Risk Acceptance | เดือน | Steering Minutes |
| **Project Sponsor** | Day-to-day Escalation, Resource Priority | สัปดาห์ | Weekly Status |
| **PM / PMO** | Operational, Timeline, Task Assignment | รายวัน | Daily Standup, PMO Report |

### 9.1.3 หลักการกำกับดูแล (Governance Principles)

1. **Single Point of Accountability** — ทุกเรื่องมีคนรับผิดชอบชัดเจน
2. **Decision at Right Level** — ตัดสินใจที่ระดับที่เหมาะสม ไม่ Escalate เกินจำเป็น
3. **Transparency** — ข้อมูลโปร่งใส ทุกคนเข้าถึงได้
4. **Data-Driven** — ตัดสินใจจากข้อมูล ไม่ใช่อารมณ์
5. **Timely Escalation** — Escalate ทันเวลา ไม่รอจนสาย
6. **Documented Decisions** — ทุกการตัดสินใจมีบันทึก
7. **Aligned with Strategy** — ทุกการตัดสินใจสอดคล้องกับกลยุทธ์องค์กร

---

## 9.2 KPI Dashboard เชิงลึก

### 9.2.1 KPI 4 มิติ (Balanced Scorecard)

```
┌─────────────────────────────────────────────────────────────┐
│              BALANCED SCORECARD FOR PROJECT                 │
└─────────────────────────────────────────────────────────────┘

  ┌─────────────────┐  ┌─────────────────┐
  │   FINANCIAL     │  │    CUSTOMER     │
  │  • Budget Used  │  │  • User Sat.    │
  │  • Cost/Feature │  │  • Adoption     │
  │  • ROI          │  │  • NPS          │
  └─────────────────┘  └─────────────────┘

  ┌─────────────────┐  ┌─────────────────┐
  │    PROCESS      │  │   LEARNING &    │
  │  • Velocity     │  │    GROWTH       │
  │  • Quality      │  │  • Team Skill   │
  │  • Lead Time    │  │  • Knowledge    │
  │  • Deployment   │  │  • Innovation   │
  └─────────────────┘  └─────────────────┘
```

### 9.2.2 KPI ระดับองค์กร (Executive Dashboard)

| หมวด | KPI | คำนิยาม | เป้าหมาย | วิธีวัด | Owner |
|------|-----|---------|----------|---------|-------|
| **Financial** | Budget Utilization | % งบที่ใช้ไป | 90–100% | Actual/Planned | PMO |
| **Financial** | Cost per Feature | ต้นทุนต่อ Feature | ≤ ฿500K | Total Cost/Features | PMO |
| **Financial** | ROI | ผลตอบแทนการลงทุน | ≥ 150% ใน 2 ปี | (Benefits/Cost)×100 | CFO |
| **Customer** | User Satisfaction | ความพึงพอใจผู้ใช้ | ≥ 4.5/5 | Survey | Business Owner |
| **Customer** | User Adoption | % ผู้ใช้ที่ใช้งานจริง | ≥ 90% | Active Users/Total | Business Owner |
| **Customer** | NPS | Net Promoter Score | ≥ 50 | Survey | Business Owner |
| **Process** | On-Time Delivery | % Sprint ที่ส่งตรงเวลา | ≥ 90% | Sprints On-Time/Total | PM |
| **Process** | Defect Leakage | % บั๊กที่หลุดถึง Prod | < 5% | Prod Bugs/Total Bugs | QA Lead |
| **Process** | Deployment Frequency | จำนวน Deploy/สัปดาห์ | ≥ 2 | CI/CD Metrics | DevOps |
| **Process** | MTTR | เวลาแก้ Incident เฉลี่ย | ≤ 30 นาที | Incident Log | On-call Lead |
| **Process** | System Uptime | % ระบบพร้อมใช้ | ≥ 99.9% | Monitoring | DevOps |
| **Learning** | Team Skill Coverage | % ทักษะที่ครอบคลุม | ≥ 80% | Skill Matrix | Tech Lead |
| **Learning** | Documentation Coverage | % Module ที่มีเอกสาร | ≥ 90% | Doc Audit | Tech Lead |
| **Learning** | Knowledge Sharing | จำนวน Sessions/เดือน | ≥ 2 | Calendar | Tech Lead |

### 9.2.3 Traffic Light Criteria

| สถานะ | ความหมาย | เกณฑ์ |
|-------|----------|-------|
| 🟢 **Green** | On Track | ≥ 90% ของเป้าหมาย |
| 🟡 **Yellow** | At Risk | 70–89% ของเป้าหมาย |
| 🔴 **Red** | Off Track | < 70% ของเป้าหมาย |
| ⚪ **Grey** | No Data | ยังไม่มีข้อมูล |

### 9.2.4 ตัวอย่าง Executive Dashboard (1 หน้า)

```
┌─────────────────────────────────────────────────────────────┐
│  PMS PROJECT — EXECUTIVE DASHBOARD                          │
│  Period: 2024-11-01 to 2024-11-30                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Overall Status: 🟡 YELLOW (At Risk)                        │
│  Progress: ████████████████░░░░ 78%                         │
│                                                              │
│  ┌────────────┐ ┌────────────┐ ┌────────────┐              │
│  │ BUDGET     │ │ SCHEDULE   │ │ QUALITY    │              │
│  │ 🟢 92%     │ │ 🟡 -5 days │ │ 🟢 4.6/5   │              │
│  │ Used       │ │ Delay      │ │ User Sat.  │              │
│  └────────────┘ └────────────┘ └────────────┘              │
│                                                              │
│  ┌────────────────────────────────────────────┐             │
│  │ TOP RISKS                                  │             │
│  │ 🔴 ERP Integration ล่าช้า — Mitigation: ...│             │
│  │ 🟡 Resource ขาด 1 Dev — Mitigation: ...    │             │
│  └────────────────────────────────────────────┘             │
│                                                              │
│  ┌────────────────────────────────────────────┐             │
│  │ DECISIONS NEEDED                           │             │
│  │ • อนุมัติ Budget +500K สำหรับ ERP Vendor  │             │
│  │ • เลือก: เลื่อน Go-Live vs ลด Scope       │             │
│  └────────────────────────────────────────────┘             │
└─────────────────────────────────────────────────────────────┘
```

### 9.2.5 KPI Trend Analysis

| KPI | เดือนที่แล้ว | เดือนนี้ | Trend | Action |
|-----|-------------|---------|-------|--------|
| Velocity | 42 SP | 38 SP | 📉 | ตรวจสอบ Blocker |
| Defect Leakage | 3% | 6% | 📈 ⚠️ | เพิ่ม QA Coverage |
| Uptime | 99.95% | 99.85% | 📉 | ตรวจ Incident |
| User Sat | 4.5 | 4.6 | 📈 ✅ | คงมาตรฐาน |
| Budget | 80% | 92% | 📈 ⚠️ | ตรวจ Burn Rate |

---

## 9.3 Reporting Cadence (รอบการรายงาน)

### 9.3.1 ตาราง Reporting

| ประเภทรายงาน | ผู้รับ | ความถี่ | รูปแบบ | จัดส่ง |
|-------------|-------|---------|--------|--------|
| **Daily Standup** | PMO + Team | รายวัน | ประชุม 15 นาที | 09:00 |
| **Weekly Status** | Project Sponsor | รายสัปดาห์ | Email + Dashboard | จันทร์ 10:00 |
| **Bi-Weekly Demo** | Stakeholder | 2 สัปดาห์ | Demo + Q&A | พฤหัส 14:00 |
| **Monthly Steering** | Steering Committee | รายเดือน | ประชุม + Deck | สัปดาห์แรก |
| **Quarterly Review** | Executive Sponsor | ไตรมาส | ประชุม + Report | สิ้นไตรมาส |
| **Annual Review** | Board | ปี | Report | สิ้นปี |

### 9.3.2 Weekly Status Report Template

```markdown
# Weekly Status Report — Week [NN]

**Project:** PMS Phase X
**Period:** [YYYY-MM-DD] – [YYYY-MM-DD]
**Report Date:** [YYYY-MM-DD]
**Prepared by:** [PM Name]

## 🎯 Executive Summary
**Overall Status:** 🟢 Green / 🟡 Yellow / 🔴 Red
**Progress:** [X]% complete
**This Week's Highlight:** [1-2 ประโยค]

## 📊 Key Metrics
| Metric | Target | This Week | Trend | Status |
|--------|--------|-----------|-------|--------|
| Sprint Velocity | 40 SP | 38 SP | 📉 | 🟡 |
| Stories Completed | 8 | 7 | → | 🟢 |
| Defects Open | < 10 | 12 | 📈 | 🟡 |
| Budget Used | 90% | 92% | 📈 | 🟡 |

## ✅ Accomplishments (This Week)
- [Achievement 1]
- [Achievement 2]
- [Achievement 3]

## 🔄 In Progress
- [Task 1] — [X]% — Owner: [Name]
- [Task 2] — [X]% — Owner: [Name]

## ⚠️ Blockers & Issues
| Issue | Impact | Owner | ETA |
|-------|--------|-------|-----|
| [Issue 1] | High | [Name] | [Date] |

## 📅 Next Week Plan
1. [Objective 1]
2. [Objective 2]
3. [Objective 3]

## 🚨 Decisions Needed
| Decision | Options | Deadline | Owner |
|----------|---------|----------|-------|
| [Decision 1] | A/B/C | [Date] | [Name] |

## 📎 Attachments
- Detailed Dashboard: [link]
- Sprint Burndown: [link]
```

### 9.3.3 Monthly Steering Committee Report Template

```markdown
# Steering Committee Report — [Month YYYY]

**Project:** PMS Phase X
**Meeting Date:** [YYYY-MM-DD]
**Attendees:** [รายชื่อ]
**Chair:** [ชื่อ]

## 📋 Agenda
1. Project Status Overview (10 นาที)
2. KPI Review (15 นาที)
3. Risks & Issues (15 นาที)
4. Budget Review (10 นาที)
5. Decisions Required (20 นาที)
6. Next Steps (5 นาที)

## 1. Project Status Overview
**Overall:** 🟡 Yellow
**Progress:** 78% (Plan: 82%)
**Schedule Variance:** -5 days
**Highlights:**
- [Highlight 1]
- [Highlight 2]
**Concerns:**
- [Concern 1]
- [Concern 2]

## 2. KPI Review
| KPI | Target | Actual | Status | Trend |
|-----|--------|--------|--------|-------|
| [KPI 1] | [T] | [A] | 🟢 | ↗️ |
| [KPI 2] | [T] | [A] | 🟡 | → |
| [KPI 3] | [T] | [A] | 🔴 | ↘️ |

## 3. Risks & Issues
### Top 3 Risks
| Risk | Impact | Prob. | Mitigation | Owner |
|------|--------|-------|------------|-------|
| [R1] | High | 60% | [Action] | [Name] |
| [R2] | Med | 40% | [Action] | [Name] |
| [R3] | Low | 20% | [Action] | [Name] |

### Open Issues
| ID | Issue | Severity | Status | Owner |
|----|-------|----------|--------|-------|
| [I1] | [Desc] | High | Open | [Name] |

## 4. Budget Review
| หมวด | Planned | Actual | Variance | % Used |
|------|---------|--------|----------|--------|
| Personnel | ฿5.0M | ฿4.6M | -฿0.4M | 92% |
| Infrastructure | ฿1.0M | ฿0.9M | -฿0.1M | 90% |
| Vendor | ฿0.5M | ฿0.5M | ฿0 | 100% |
| **TOTAL** | **฿6.5M** | **฿6.0M** | **-฿0.5M** | **92%** |

## 5. Decisions Required
| # | Decision | Options | Recommendation | Decision |
|---|----------|---------|----------------|----------|
| 1 | [Decision 1] | A/B/C | [B] | [Pending] |
| 2 | [Decision 2] | X/Y | [X] | [Approved] |

## 6. Action Items
| # | Action | Owner | Due Date | Status |
|---|--------|-------|----------|--------|
| 1 | [Action 1] | [Name] | [Date] | Open |
| 2 | [Action 2] | [Name] | [Date] | Done |

## 7. Next Meeting
**Date:** [YYYY-MM-DD]
**Focus:** [หัวข้อ]
```

### 9.3.4 Quarterly Executive Review Template

```markdown
# Quarterly Executive Review — Q[N] [YYYY]

**Project:** PMS Phase X
**Prepared for:** Executive Sponsor
**Period:** [Start] – [End]

## 🎯 Strategic Alignment
[อธิบายว่าโครงการสอดคล้องกับกลยุทธ์องค์กรอย่างไร]

## 📊 Overall Performance
| มิติ | สถานะ | สรุป |
|------|-------|------|
| Financial | 🟢 | ใช้ 92% ของงบ, ROI คาด 180% |
| Delivery | 🟡 | ล่าช้า 5 วัน, แต่ Scope ครบ |
| Quality | 🟢 | Defect < 3%, UAT Pass 95% |
| Adoption | 🟢 | User ใช้งาน 92% |

## 🏆 Key Achievements
- [Achievement 1]
- [Achievement 2]
- [Achievement 3]

## 📈 Benefits Realized
| Benefit | Target | Actual | Status |
|---------|--------|--------|--------|
| ลดเวลาทำงาน Manual | 50% | 45% | 🟡 |
| ลดข้อผิดพลาด | 80% | 85% | 🟢 |
| ประหยัดต้นทุน | ฿2M/ปี | ฿1.8M/ปี | 🟡 |

## 🚨 Strategic Risks
| Risk | Impact | Mitigation |
|------|--------|------------|
| [R1] | [Desc] | [Action] |

## 💡 Recommendations
1. [Recommendation 1]
2. [Recommendation 2]

## 🔮 Next Quarter Outlook
- [Outlook 1]
- [Outlook 2]

## 🙏 Asks from Executive
1. [Ask 1 — เช่น อนุมัติงบเพิ่ม]
2. [Ask 2 — เช่น เลือก Vendor]
```

---

## 9.4 Decision-Making Frameworks

### 9.4.1 Decision Types และผู้ตัดสินใจ

| ประเภทการตัดสินใจ | ผู้ตัดสินใจ | ระยะเวลา | ตัวอย่าง |
|-------------------|-----------|----------|----------|
| **Strategic** | Executive Sponsor | ≤ 2 สัปดาห์ | เปลี่ยน Technology Stack, เปลี่ยน Scope ใหญ่ |
| **Tactical** | Steering Committee | ≤ 1 สัปดาห์ | เพิ่ม Budget 10%, เปลี่ยน Timeline |
| **Operational** | Project Sponsor | ≤ 2 วัน | จัดลำดับ Feature, แก้ Blocker |
| **Technical** | Architect / Tech Lead | ≤ 1 วัน | เลือก Library, ออกแบบ API |
| **Day-to-day** | PM / Team | ทันที | Task Assignment |

### 9.4.2 Decision Framework — RAPID

```
┌─────────────────────────────────────────────────────────────┐
│                    RAPID FRAMEWORK                          │
└─────────────────────────────────────────────────────────────┘

  R — Recommend: ใครเสนอ?
  A — Agree:     ใครต้องเห็นชอบ? (Veto Power)
  P — Perform:   ใครลงมือ?
  I — Input:     ใครให้ข้อมูล?
  D — Decide:    ใครตัดสินใจ?
```

**ตัวอย่างการใช้ RAPID:**

| การตัดสินใจ | R | A | P | I | D |
|-------------|---|---|---|---|---|
| เลือก Vendor ERP | Architect | CFO | PM | BA, Dev | Steering |
| เพิ่ม Budget | PM | CFO | PMO | Finance | Exec Sponsor |
| เปลี่ยน Sprint Scope | PO | Project Sponsor | Dev | QA | PM |
| เลือก Tech Stack | Architect | Tech Lead | Dev | DevOps | Architect |

### 9.4.3 Decision Matrix (Weighted Scoring)

**ตัวอย่าง:** เลือก Vendor ERP

| Criteria | Weight | Vendor A | Vendor B | Vendor C |
|----------|--------|----------|----------|----------|
| ราคา | 30% | 3 (0.9) | 4 (1.2) | 2 (0.6) |
| ฟีเจอร์ | 25% | 4 (1.0) | 3 (0.75) | 5 (1.25) |
| Support | 20% | 5 (1.0) | 3 (0.6) | 3 (0.6) |
| Integration | 15% | 3 (0.45) | 5 (0.75) | 4 (0.6) |
| Reputation | 10% | 4 (0.4) | 4 (0.4) | 3 (0.3) |
| **Total** | **100%** | **3.75** | **3.70** | **3.35** |

**ผล:** Vendor A ชนะ (3.75) — แต่ต้องพิจารณา Qualitative เพิ่ม

### 9.4.4 Decision Record Template

```markdown
# Decision Record: DR-001

**Date:** [YYYY-MM-DD]
**Decision Maker:** [ชื่อ]
**RAPID:** R=[], A=[], P=[], I=[], D=[]

## Context
[บริบทและปัญหาที่ต้องตัดสินใจ]

## Options Considered
1. **Option A:** [อธิบาย]
   - Pros: [ข้อดี]
   - Cons: [ข้อเสีย]
   - Cost: [ประมาณการ]

2. **Option B:** [อธิบาย]
   - Pros: [ข้อดี]
   - Cons: [ข้อเสีย]
   - Cost: [ประมาณการ]

3. **Option C:** [อธิบาย]
   - Pros: [ข้อดี]
   - Cons: [ข้อเสีย]
   - Cost: [ประมาณการ]

## Decision
**เลือก:** Option [X]

**เหตุผล:**
- [เหตุผล 1]
- [เหตุผล 2]

## Consequences
### Positive
- [ผลบวก]

### Negative
- [ผลลบ]

### Risks
- [ความเสี่ยง + Mitigation]

## Next Steps
1. [Action 1] — Owner: [Name] — Due: [Date]
2. [Action 2] — Owner: [Name] — Due: [Date]

## Review Date
[วันที่ทบทวนการตัดสินใจ]

## Sign-off
- [ ] Executive Sponsor
- [ ] Steering Committee
- [ ] Project Sponsor
```

---

## 9.5 Budget & Resource Management

### 9.5.1 โครงสร้างงบประมาณ

| หมวด | รายละเอียด | % ของงบทั้งหมด |
|------|-----------|----------------|
| **Personnel** | เงินเดือนทีม, Consultant | 60–70% |
| **Infrastructure** | Cloud, License, Tools | 10–15% |
| **Software** | License, Subscription | 5–10% |
| **Vendor** | Outsource, Integration | 5–10% |
| **Training** | Upskilling, Certification | 2–5% |
| **Contingency** | สำรอง 10–15% | 10–15% |

### 9.5.2 Budget Tracking (Earned Value Management)

| Metric | สูตร | ความหมาย |
|--------|------|----------|
| **PV** (Planned Value) | งบที่วางแผน ณ วันนี้ | ควรใช้ไปเท่าไหร่ |
| **EV** (Earned Value) | งบตามงานที่ทำเสร็จ | งานที่ทำได้มีมูลค่าเท่าไหร่ |
| **AC** (Actual Cost) | งบที่ใช้จริง | ใช้ไปจริงเท่าไหร่ |
| **CV** (Cost Variance) | EV − AC | + = ประหยัด, − = เกิน |
| **SV** (Schedule Variance) | EV − PV | + = เร็วกว่า, − = ช้ากว่า |
| **CPI** (Cost Performance Index) | EV / AC | >1 = ดี, <1 = แย่ |
| **SPI** (Schedule Performance Index) | EV / PV | >1 = เร็ว, <1 = ช้า |
| **EAC** (Estimate at Completion) | BAC / CPI | ประมาณการงบสุดท้าย |
| **VAC** (Variance at Completion) | BAC − EAC | ผลต่างจากงบ |

### 9.5.3 Budget Health Check (รายเดือน)

```markdown
# Budget Health Check — [Month YYYY]

## Summary
| Metric | Value | Status |
|--------|-------|--------|
| BAC (Budget at Completion) | ฿6.5M | — |
| PV (Planned Value) | ฿5.2M | — |
| EV (Earned Value) | ฿5.0M | — |
| AC (Actual Cost) | ฿5.5M | — |
| CV (Cost Variance) | -฿0.5M | 🔴 |
| SV (Schedule Variance) | -฿0.2M | 🟡 |
| CPI | 0.91 | 🟡 |
| SPI | 0.96 | 🟡 |
| EAC | ฿7.14M | 🔴 |
| VAC | -฿0.64M | 🔴 |

## Analysis
- **CPI 0.91** → ใช้เงินเกินแผน 9%
- **EAC ฿7.14M** → คาดว่าจะเกินงบ ฿0.64M
- **สาเหตุ:** ERP Integration ซับซ้อนกว่าคาด

## Recommendations
1. ลด Scope ที่เป็น Nice-to-have (P3) ออก
2. เจรจา Vendor ลดราคา
3. ขออนุมัติ Budget เพิ่ม ฿0.7M

## Decisions Needed
- [ ] อนุมัติ Budget เพิ่ม ฿0.7M
- [ ] หรือ ลด Scope ตามข้อ 1
```

### 9.5.4 Resource Planning

| Role | ปัจจุบัน | ต้องการ | Gap | Action |
|------|---------|---------|-----|--------|
| PO | 1 | 1 | 0 | — |
| BA | 1 | 2 | +1 | หา Contract |
| Dev | 4 | 5 | +1 | Promote Junior |
| QA | 2 | 2 | 0 | — |
| DevOps | 1 | 1 | 0 | — |
| Architect | 1 | 1 | 0 | — |

**ตัวชี้วัด Resource:**
- **Utilization Rate:** % เวลาที่ใช้ในโครงการ (เป้า: 80–90%)
- **Billable Ratio:** % ที่คิดเงินได้ (ถ้าเป็น Outsource)
- **Skill Coverage:** % ทักษะที่ครอบคลุม (เป้า: ≥ 80%)

---

## 9.6 Risk Management

### 9.6.1 Risk Categories

| หมวด | ตัวอย่างความเสี่ยง |
|------|-------------------|
| **Strategic** | เปลี่ยนกลยุทธ์องค์กร, เปลี่ยน Sponsor |
| **Financial** | งบไม่พอ, Exchange Rate |
| **Technical** | Technology ไม่เสถียร, Integration ซับซ้อน |
| **Resource** | ขาดคน, Turnover สูง |
| **Schedule** | ล่าช้า, Dependency |
| **Compliance** | PDPA, SOX, Audit |
| **Vendor** | Vendor ล่ม, ส่งของช้า |
| **Security** | Data Breach, Vulnerability |
| **Operational** | ระบบล่ม, Data Loss |

### 9.6.2 Risk Assessment Matrix

```
         Impact
         Low   Med   High  Critical
    ┌─────┬─────┬─────┬─────┐
 H  │ 🟡  │ 🔴  │ 🔴  │ 🔴  │
 i  ├─────┼─────┼─────┼─────┤
 g  │ 🟢  │ 🟡  │ 🔴  │ 🔴  │
 h  ├─────┼─────┼─────┼─────┤
    │ 🟢  │ 🟢  │ 🟡  │ 🔴  │
 M  ├─────┼─────┼─────┼─────┤
 e  │ 🟢  │ 🟢  │ 🟢  │ 🟡  │
 d  └─────┴─────┴─────┴─────┘
         Low   Med   High  Critical
                Probability
```

### 9.6.3 Risk Register Template

```markdown
# Risk Register

| ID | Risk | Category | Prob. | Impact | Score | Response | Owner | Status |
|----|------|----------|-------|--------|-------|----------|-------|--------|
| R-001 | ERP Integration ล่าช้า | Technical | High | High | 🔴 9 | Mitigate | Architect | Open |
| R-002 | ขาด Dev 1 คน | Resource | Med | Med | 🟡 4 | Transfer | PM | Open |
| R-003 | Vendor ส่งของช้า | Vendor | Low | High | 🟡 3 | Accept | PM | Monitor |
| R-004 | PDPA ไม่ผ่าน | Compliance | Low | Critical | 🔴 4 | Mitigate | Security | Open |
| R-005 | Budget เกิน | Financial | Med | Med | 🟡 4 | Mitigate | CFO | Open |

**Score = Prob. × Impact** (1=Low, 2=Med, 3=High)
- 🟢 1–2: Low — Accept
- 🟡 3–4: Medium — Monitor
- 🔴 6–9: High — Action Required
```

### 9.6.4 Risk Response Strategies

| กลยุทธ์ | ใช้เมื่อ | ตัวอย่าง |
|---------|---------|----------|
| **Avoid** | ความเสี่ยงสูงมาก | เปลี่ยน Tech Stack |
| **Mitigate** | ลดโอกาส/ผลกระทบ | เพิ่ม Test, เพิ่มคน |
| **Transfer** | โอนให้คนอื่น | ซื้อ Insurance, Outsource |
| **Accept** | ต่ำ/ต้นทุนสูง | ยอมรับ + Contingency |
| **Escalate** | เกินอำนาจ | แจ้ง Steering |

### 9.6.5 Risk Review Cadence

| ระดับ | ความถี่ | ผู้ทบทวน |
|-------|---------|----------|
| Critical Risk | รายสัปดาห์ | Project Sponsor |
| High Risk | 2 สัปดาห์ | PM + Owner |
| Medium Risk | รายเดือน | PM |
| Low Risk | ไตรมาส | PMO |

---

## 9.7 Escalation Protocol

### 9.7.1 Escalation Levels

```
┌─────────────────────────────────────────────────────────────┐
│                   ESCALATION LEVELS                         │
└─────────────────────────────────────────────────────────────┘

  Level 1: Team Level
  ├─ เรื่อง: Task, Technical, Day-to-day
  ├─ Escalate ถึง: PM / Tech Lead
  └─ SLA: ≤ 1 วัน

  Level 2: Project Level
  ├─ เรื่อง: Blocker, Resource, Timeline
  ├─ Escalate ถึง: Project Sponsor
  └─ SLA: ≤ 3 วัน

  Level 3: Steering Level
  ├─ เรื่อง: Scope Change, Budget, Strategic
  ├─ Escalate ถึง: Steering Committee
  └─ SLA: ≤ 1 สัปดาห์

  Level 4: Executive Level
  ├─ เรื่อง: Strategic, Crisis, Go/No-Go
  ├─ Escalate ถึง: Executive Sponsor
  └─ SLA: ≤ 2 สัปดาห์
```

### 9.7.2 Escalation Criteria

| Escalate เมื่อ | ไปที่ | ภายใน |
|----------------|-------|-------|
| Blocker เกิน 2 วัน | Project Sponsor | ทันที |
| Budget เกิน 10% | Steering Committee | 3 วัน |
| Schedule ล่าช้า > 1 สัปดาห์ | Project Sponsor | ทันที |
| Risk ระดับ Critical ใหม่ | Steering Committee | 24 ชม. |
| Scope Change ใหญ่ | Steering Committee | 1 สัปดาห์ |
| Vendor Issue | Steering Committee | 3 วัน |
| Security Breach | Executive Sponsor | ทันที |
| Compliance Issue | Executive Sponsor | ทันที |

### 9.7.3 Escalation Template

```markdown
# Escalation: ESC-001

**Date:** [YYYY-MM-DD]
**From:** [ชื่อ]
**To:** [ชื่อ]
**Level:** [1/2/3/4]

## Issue
[อธิบายปัญหา]

## Impact
- **Business:** [ผลกระทบต่อธุรกิจ]
- **Timeline:** [ผลกระทบต่อเวลา]
- **Budget:** [ผลกระทบต่องบ]

## Background
[บริบท + สิ่งที่ทำไปแล้ว]

## Options
1. **Option A:** [อธิบาย] — Pros/Cons
2. **Option B:** [อธิบาย] — Pros/Cons
3. **Option C:** [อธิบาย] — Pros/Cons

## Recommendation
[แนะนำ Option ไหน + เหตุผล]

## Decision Needed By
[วันที่ต้องตัดสินใจ]

## Consequences if Delayed
[ถ้าไม่ตัดสินใจทันเวลา จะเกิดอะไร]

## Attachments
- [เอกสารประกอบ]
```

---

## 9.8 Steering Committee Protocol

### 9.8.1 องค์ประกอบ

| บทบาท | จำนวน | หน้าที่ |
|-------|-------|---------|
| **Chair** | 1 | ดำเนินการประชุม, ตัดสินใจขั้นสุดท้าย |
| **Members** | 3–7 | CIO, CFO, Business Owner, PM |
| **Secretary** | 1 | บันทึก Minutes, Track Actions |
| **Presenter** | ตามวาระ | PM, Tech Lead, BA |

### 9.8.2 วาระการประชุมมาตรฐาน (60–90 นาที)

```
1. Welcome & Agenda (5 นาที)
2. Review Previous Minutes (5 นาที)
3. Project Status (15 นาที)
4. KPI Review (10 นาที)
5. Risks & Issues (15 นาที)
6. Budget Review (10 นาที)
7. Decisions Required (20 นาที)
8. Action Items (5 นาที)
9. Next Meeting (5 นาที)
```

### 9.8.3 กฎการประชุม

- ✅ ส่ง Materials ล่วงหน้า ≥ 3 วัน
- ✅ เริ่ม-เลิกตรงเวลา
- ✅ ตัดสินใจเฉพาะเรื่องที่อยู่ในวาระ
- ✅ บันทึก Minutes + Action Items ทุกครั้ง
- ✅ ติดตาม Actions ในการประชุมครั้งถัดไป
- ❌ ห้าม Discuss รายละเอียด Technical ลึก
- ❌ ห้ามตัดสินใจโดยไม่มีข้อมูล

### 9.8.4 Minutes Template

```markdown
# Steering Committee Minutes

**Date:** [YYYY-MM-DD]
**Time:** [HH:MM] – [HH:MM]
**Location:** [ห้อง / Online]
**Chair:** [ชื่อ]
**Attendees:** [รายชื่อ]
**Apologies:** [รายชื่อ]
**Minutes by:** [ชื่อ]

## 1. Previous Minutes
- [ ] Approved / [ ] Approved with changes: [ระบุ]

## 2. Project Status
**Presented by:** [ชื่อ]
**Summary:** [สรุป 2-3 ประโยค]
**Status:** 🟡 Yellow

## 3. KPI Review
| KPI | Target | Actual | Status |
|-----|--------|--------|--------|
| [KPI] | [T] | [A] | 🟡 |

## 4. Risks & Issues
| Risk | Status | Note |
|------|--------|------|
| [R1] | Open | [Note] |

## 5. Budget
**Summary:** ใช้ 92% ของงบ, คาด EAC เกิน ฿0.64M

## 6. Decisions Made
| # | Decision | Owner | Status |
|---|----------|-------|--------|
| D1 | อนุมัติ Budget เพิ่ม ฿0.7M | CFO | ✅ Approved |
| D2 | เลื่อน Go-Live 2 สัปดาห์ | Sponsor | ✅ Approved |
| D3 | ลด Scope Feature X | PO | ⏳ Pending |

## 7. Action Items
| # | Action | Owner | Due | Status |
|---|--------|-------|-----|--------|
| A1 | เจรจา Vendor ลดราคา | PM | [Date] | Open |
| A2 | อัปเดต Risk Register | PMO | [Date] | Open |

## 8. Next Meeting
**Date:** [YYYY-MM-DD]
**Time:** [HH:MM]
**Agenda:** [หัวข้อ]

## Sign-off
**Chair:** _________________
**Secretary:** _________________
```

---

## 9.9 Change Control

### 9.9.1 ประเภทของ Change

| ประเภท | ผลกระทบ | ผู้อนุมัติ | กระบวนการ |
|--------|---------|-----------|-----------|
| **Minor** | < 5% Scope, < ฿100K, < 3 วัน | PM | Lightweight |
| **Medium** | 5–15% Scope, ฿100K–500K, 3–10 วัน | Project Sponsor | Standard |
| **Major** | > 15% Scope, > ฿500K, > 10 วัน | Steering Committee | Formal |
| **Strategic** | เปลี่ยนทิศทาง, Technology | Executive Sponsor | Full Review |

### 9.9.2 Change Request Template

```markdown
# Change Request: CR-001

**Date:** [YYYY-MM-DD]
**Requester:** [ชื่อ]
**Type:** [Minor/Medium/Major/Strategic]
**Priority:** [P0/P1/P2/P3]

## Description
[อธิบายการเปลี่ยนแปลง]

## Reason
[เหตุผลที่ต้องเปลี่ยน]

## Impact Analysis
| ด้าน | ผลกระทบ |
|------|---------|
| Scope | [รายละเอียด] |
| Schedule | [+X days] |
| Budget | [+฿Y] |
| Resources | [รายละเอียด] |
| Quality | [รายละเอียด] |
| Risk | [รายละเอียด] |

## Alternatives
1. **Option A:** [อธิบาย] — Pros/Cons
2. **Option B:** [อธิบาย] — Pros/Cons
3. **Do Nothing:** [ผลกระทบ]

## Recommendation
[แนะนำ Option ไหน + เหตุผล]

## Decision
- [ ] Approved
- [ ] Rejected
- [ ] Deferred

**Approved by:** _________________
**Date:** [YYYY-MM-DD]

## Implementation Plan
1. [Step 1] — Owner: [Name] — Due: [Date]
2. [Step 2] — Owner: [Name] — Due: [Date]

## Communication Plan
- [ ] แจ้งทีม
- [ ] อัปเดต Plan
- [ ] แจ้ง Stakeholder
```

### 9.9.3 Change Control Board (CCB)

| บทบาท | จำนวน | หน้าที่ |
|-------|-------|---------|
| **Chair** | 1 (Project Sponsor) | ตัดสินใจขั้นสุดท้าย |
| **Members** | 3–5 | PM, Architect, BA, Finance |
| **Secretary** | 1 | บันทึก, Track |

**ประชุม CCB:** ทุก 2 สัปดาห์ หรือตามต้องการ (กรณีเร่งด่วน)

---

## 9.10 Benefits Realization

### 9.10.1 Benefits Framework

```
┌─────────────────────────────────────────────────────────────┐
│                  BENEFITS REALIZATION                       │
└─────────────────────────────────────────────────────────────┘

  Project Output ──► Capability ──► Benefit ──► Strategic Goal
  (สิ่งที่สร้าง)     (สิ่งที่ทำได้)   (คุณค่า)     (เป้าหมายองค์กร)

  ตัวอย่าง:
  PMS System ──► Auto Reconciliation ──► ลดเวลาทำงาน 50% ──► ลดต้นทุน
```

### 9.10.2 Benefits Register

| ID | Benefit | Target | Actual | Status | Owner | Measure By |
|----|---------|--------|--------|--------|-------|-----------|
| B-001 | ลดเวลาทำงาน Manual | 50% | 45% | 🟡 | Finance Manager | Q4 2024 |
| B-002 | ลดข้อผิดพลาด | 80% | 85% | 🟢 | QA Lead | Q4 2024 |
| B-003 | ประหยัดต้นทุน | ฿2M/ปี | ฿1.8M | 🟡 | CFO | 2025 |
| B-004 | User Satisfaction | 4.5/5 | 4.6/5 | 🟢 | Business Owner | Q4 2024 |
| B-005 | Compliance 100% | 100% | 95% | 🟡 | Auditor | Q4 2024 |

### 9.10.3 Benefits Review (รายไตรมาส)

**คำถามที่ต้องตอบ:**
1. Benefit ที่ตั้งไว้บรรลุหรือไม่? (Target vs Actual)
2. อะไรเป็นอุปสรรค?
3. ต้องปรับ Target หรือไม่?
4. ต้องทำอะไรเพิ่มเพื่อให้บรรลุ?
5. ใครรับผิดชอบ?

### 9.10.4 Benefits Realization Report Template

```markdown
# Benefits Realization Report — Q[N] [YYYY]

## Summary
| Benefit | Target | Actual | Variance | Status |
|---------|--------|--------|----------|--------|
| [B-001] | 50% | 45% | -5% | 🟡 |
| [B-002] | 80% | 85% | +5% | 🟢 |

## Detailed Analysis

### B-001: ลดเวลาทำงาน Manual
- **Target:** 50%
- **Actual:** 45%
- **Variance:** -5%
- **Reason:** User ยังไม่คุ้นเคยกับระบบใหม่
- **Action:** เพิ่ม Training + Refresher
- **Owner:** Finance Manager
- **Due:** [Date]

## Overall Assessment
[สรุปภาพรวม]

## Recommendations
1. [Recommendation 1]
2. [Recommendation 2]

## Next Quarter Focus
- [Focus 1]
- [Focus 2]
```

---

## 9.11 Communication Plan

### 9.11.1 Stakeholder Communication Matrix

| Stakeholder | สิ่งที่ต้องรู้ | ความถี่ | ช่องทาง | ผู้ส่ง |
|-------------|---------------|---------|---------|--------|
| Executive Sponsor | Strategic Status | ไตรมาส | Meeting + Report | PM |
| Steering Committee | Status, Risks, Decisions | เดือน | Meeting | PM |
| Project Sponsor | Weekly Status | สัปดาห์ | Email + Dashboard | PM |
| Business Owner | Adoption, Benefits | 2 สัปดาห์ | Meeting | PM + BA |
| End Users | Changes, Tips | ตามต้องการ | Email + Intranet | BA |
| IT Team | Technical Changes | ตามต้องการ | Slack | Tech Lead |
| Finance Team | Budget, Costs | เดือน | Report | PMO |
| Auditor | Compliance | ไตรมาส | Report | PMO |

### 9.11.2 Communication Escalation

| สถานการณ์ | ผู้สื่อสาร | ผู้รับ | ช่องทาง |
|-----------|-----------|-------|---------|
| SEV-1 Incident | IC | Exec + Stakeholder | โทร + Email |
| Budget Overrun | PM | Steering | Meeting |
| Schedule Delay | PM | Sponsor | Email |
| Security Breach | Security | Exec + Legal | โทร |
| Media Inquiry | PR | External | ผ่าน PR เท่านั้น |

### 9.11.3 Communication Do's & Don'ts

**Do's:**
- ✅ สื่อสารเชิงรุก (Proactive)
- ✅ ใช้ข้อมูลจริง (Data-Driven)
- ✅ ระบุ Action + Owner + Due Date
- ✅ ใช้ภาษาที่เข้าใจง่าย (ไม่ใช่ Technical ล้วน)
- ✅ สื่อสาร Bad News เร็ว (ไม่ปิด)

**Don'ts:**
- ❌ ปิดข่าวร้าย
- ❌ สัญญาสิ่งที่ทำไม่ได้
- ❌ ใช้ศัพท์ Technical กับ Business
- ❌ Blame คนในที่ประชุม
- ❌ สื่อสารนอกช่องทางที่กำหนด

---

## 9.12 ข้อควรระวังสำหรับผู้บริหาร

| # | ข้อควรระวัง | เหตุผล |
|---|-------------|--------|
| 1 | อย่าตัดสินใจจากข้อมูลไม่ครบ | อาจผิดพลาด |
| 2 | อย่า Approve โดยไม่อ่าน | ความรับผิดชอบ |
| 3 | อย่า Micro-manage | ทีมเสียประสิทธิภาพ |
| 4 | อย่าเปลี่ยน Scope บ่อย | ทีมสับสน, ล่าช้า |
| 5 | อย่าละเลย Risk | อาจกลายเป็น Crisis |
| 6 | อย่าข้าม Governance | ขาดความโปร่งใส |
| 7 | อย่าฟังข้างเดียว | ต้องฟัง Technical |
| 8 | อย่าละเลย Benefits | ลงทุนไม่คุ้ม |
| 9 | อย่าละเลย Compliance | อาจโดนปรับ |
| 10 | อย่าละเลย People | ทีม Burnout |

---

## 9.13 FAQ สำหรับผู้บริหาร

**Q1: ต้องอ่านรายงานละเอียดแค่ไหน?**
A: Executive Summary + KPI + Risks + Decisions Needed — 5 นาทีก็เพียงพอ ถ้าสนใจดูรายละเอียดเพิ่มได้ที่ Attachment

**Q2: ถ้า KPI แดง ต้องทำอะไร?**
A: ดู Root Cause → ถามทีม → ตัดสินใจ Mitigation → ติดตาม — อย่าปล่อยให้แดงนาน

**Q3: ต่างกันอย่างไรระหว่าง Sponsor กับ Steering?**
A: Sponsor = ติดตามรายสัปดาห์, Steering = ตัดสินใจเชิงกลยุทธ์รายเดือน

**Q4: ต้อง Approve ทุก Change หรือไม่?**
A: ไม่ — Minor ให้ PM, Medium ให้ Sponsor, Major ให้ Steering — ตามระดับ

**Q5: ถ้า Budget เกิน ต้องทำไง?**
A: แจ้ง Steering ทันที + เสนอ Options (ลด Scope / เพิ่มงบ / เลื่อน) + Decision

**Q6: Risk ไหนต้อง Escalate?**
A: Critical Impact หรือ High Prob. × High Impact → Escalate ทันที

**Q7: ต้องเข้าร่วมประชุมทุกครั้งไหม?**
A: Steering = ควรมาก, Weekly = ส่งตัวแทนได้, Daily = ไม่ต้อง

**Q8: ถ้าไม่เห็นด้วยกับการตัดสินใจของทีม?**
A: พูดคุยกับ PM ก่อน → ถ้ายังไม่เห็นด้วย → Escalate ตามระดับ — อย่า Override โดยไม่ฟัง

**Q9: Benefits ไม่บรรลุ ต้องทำไง?**
A: วิเคราะห์สาเหตุ → ปรับ Action → ถ้าจำเป็น ปรับ Target + แจ้ง Steering

**Q10: จะรู้ได้ไงว่าโครงการมีปัญหาก่อนสาย?**
A: ติดตาม KPI Trend (ไม่ใช่แค่ค่าเดียว) + ฟังทีม + ดู Risk Register + Velocity

---

## 9.14 Glossary

| คำ | ความหมาย |
|----|----------|
| **BAC** | Budget at Completion — งบประมาณทั้งหมด |
| **CCB** | Change Control Board — คณะกรรมการอนุมัติ Change |
| **CPI** | Cost Performance Index — ดัชนีประสิทธิภาพต้นทุน |
| **EAC** | Estimate at Completion — ประมาณการงบสุดท้าย |
| **EV** | Earned Value — มูลค่างานที่ทำเสร็จ |
| **Governance** | การกำกับดูแล |
| **KPI** | Key Performance Indicator — ตัวชี้วัดหลัก |
| **NPS** | Net Promoter Score — คะแนนความภักดี |
| **PMO** | Project Management Office — สำนักงานบริหารโครงการ |
| **RAPID** | Recommend, Agree, Perform, Input, Decide — Framework ตัดสินใจ |
| **RACI** | Responsible, Accountable, Consulted, Informed |
| **ROI** | Return on Investment — ผลตอบแทนการลงทุน |
| **SPI** | Schedule Performance Index — ดัชนีประสิทธิภาพเวลา |
| **Steering Committee** | คณะกรรมการกำกับโครงการ |
| **VAC** | Variance at Completion — ผลต่างจากงบ |

---

## 9.15 ความเชื่อมโยงกับเล่มอื่น

| เล่ม | ความเชื่อมโยงกับเล่ม 9 |
|------|------------------------|
| **เล่ม 1 (PO/BA)** | User Story ที่ทีมทำ — ผู้บริหารติดตาม Progress |
| **เล่ม 3 (Architect)** | Architecture ที่ทีมออกแบบ — ผู้บริหารอนุมัติ Trade-off |
| **เล่ม 5 (DevOps)** | Deployment Metrics — ผู้บริหารดู Deployment Frequency, Uptime |
| **เล่ม 7 (On-call)** | Incident — ผู้บริหารรับแจ้ง SEV-1/2 |
| **เล่ม 11 (Hotfix)** | Hotfix — ผู้บริหารอนุมัติ Fast-track (ถ้าจำเป็น) |
| **เล่ม 13 (RCA)** | RCA — ผู้บริหารติดตาม Preventive Actions |
| **เล่ม 14 (Security)** | Compliance — ผู้บริหารรับผิดชอบ Compliance |

---

## 9.16 สรุปสาระสำคัญ (Key Takeaways)

```text
┌─────────────────────────────────────────────────────────────┐
│              MANAGEMENT / STAKEHOLDER                       │
│                     KEY TAKEAWAYS                           │
└─────────────────────────────────────────────────────────────┘

  1. Governance ชัดเจน — รู้ว่าใครตัดสินใจเรื่องอะไร
  2. KPI 4 มิติ — Financial, Customer, Process, Learning
  3. รายงานตาม Cadence — Weekly, Monthly, Quarterly
  4. ตัดสินใจตาม Framework — RAPID, Decision Matrix
  5. บริหาร Budget — ใช้ EVM (CPI, SPI, EAC)
  6. บริหาร Risk — Register + Review สม่ำเสมอ
  7. Escalate ตามระดับ — ไม่ข้ามขั้น
  8. Steering Committee — ประชุมมีวาระ + Minutes
  9. Change Control — อนุมัติตามระดับ ไม่ข้าม
  10. Benefits Realization — วัดผลจริง ไม่ใช่แค่ส่งมอบ
  11. สื่อสารเชิงรุก — Bad News เร็ว
  12. ระวัง 10 ข้อ — อย่า Micro-manage, อย่าข้าม Governance
```

---
 