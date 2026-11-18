## 📘 เล่ม 15 (ฉบับขยาย): คู่มือ Knowledge Management & Onboarding
**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับ
**Reference:** https://github.com/kongnakornna/work-book
> **หมายเหตุ:** เอกสารนี้เป็นฉบับขยายของเล่ม 15 ใน Master Index โดยเพิ่มรายละเอียดเชิงปฏิบัติสำหรับ Tech Lead, HR และสมาชิกใหม่ ได้แก่ Onboarding Program (30-60-90 วัน), Buddy System, Documentation Standards (Deep Dive), Knowledge Base Structure, Documentation-as-Code, Knowledge Sharing Practices, Training Curriculum, Bus Factor Management, Offboarding, Templates ครบชุด และ KPIs

---
## 15.0 บทนำและปรัชญา

### 15.0.1 ทำไม Knowledge Management & Onboarding ถึงสำคัญ?

```
┌─────────────────────────────────────────────────────────────┐
│              PROBLEM vs SOLUTION                            │
└─────────────────────────────────────────────────────────────┘

  ปัญหาของการไม่มีระบบ:
  • สมาชิกใหม่ใช้เวลา 1-2 เดือนกว่าจะทำงานได้
  • ความรู้อยู่ที่คนใดคนหนึ่ง (Bus Factor = 1)
  • คนลาออก → ความรู้หาย
  • ทำงานซ้ำ ( reinvent the wheel)
  • Documentation ล้าสมัย
  • Onboarding ไม่ Consistent

  Solution:
  • Onboarding Program ชัดเจน (30-60-90)
  • Knowledge Base ครบ
  • Documentation-as-Code
  • Knowledge Sharing สม่ำเสมอ
  • Bus Factor > 1
```

### 15.0.2 ปรัชญา 4 ข้อ

| หลักการ | ความหมาย | ผลลัพธ์ |
|---------|----------|---------|
| **Learn Fast** | Onboarding เร็ว | Productivity เร็ว |
| **Share Always** | แบ่งปันความรู้เสมอ | Bus Factor สูง |
| **Document as Code** | เอกสารอยู่ใน Repo | อัปเดตง่าย |
| **Continuous Learning** | เรียนรู้ตลอด | ทีมเก่งขึ้น |

### 15.0.3 ตัวเลขที่น่าสนใจ

```
┌─────────────────────────────────────────────────────────────┐
│              ONBOARDING IMPACT                              │
└─────────────────────────────────────────────────────────────┘

  • สมาชิกใหม่ใช้เวลา 3-6 เดือนกว่าจะทำงานได้เต็มที่
  • Onboarding ที่ดี → ลดเวลา 30-50%
  • ต้นทุนการ Replace พนักงาน = 50-200% ของเงินเดือน
  • Bus Factor = 1 → ความเสี่ยงสูงมาก
  • Documentation ที่ดี → ลด Support Request 40%
```

### 15.0.4 Knowledge Types

```
┌─────────────────────────────────────────────────────────────┐
│              KNOWLEDGE TYPES                                │
└─────────────────────────────────────────────────────────────┘

  ┌──────────────────────┐
  │  EXPLICIT KNOWLEDGE  │  เขียนออกมาได้ (Documentation)
  │  (ชัดแจ้ง)             │  → Wiki, README, ADR
  └──────────────────────┘

  ┌──────────────────────┐
  │  TACIT KNOWLEDGE     │  อยู่ในหัวคน (Experience)
  │  (ซ่อนเร้น)            │  → Pair Programming, Mentoring
  └──────────────────────┘

  เป้าหมาย: เปลี่ยน Tacit → Explicit ให้ได้มากที่สุด
```

---

## 15.1 บทบาทและความรับผิดชอบ

### 15.1.1 ผู้เกี่ยวข้องใน Knowledge Management & Onboarding

| บทบาท | หน้าที่ | อยู่ในทุกครั้ง? |
|-------|---------|:---------------:|
| **Tech Lead** | Owner ของ Knowledge Base | ✅ |
| **HR / People Ops** | Onboarding Program, Admin | ✅ |
| **Buddy / Mentor** | ดูแลสมาชิกใหม่รายวัน | ✅ |
| **Onboarding Coordinator** | ประสานงาน Onboarding | ✅ |
| **Documentation Owner** | ดูแลเอกสารแต่ละส่วน | ✅ |
| **All Team Members** | แบ่งปันความรู้, อัปเดตเอกสาร | ✅ |
| **Engineering Manager** | สนับสนุน, วัดผล | ✅ |

### 15.1.2 RACI Matrix (Knowledge & Onboarding)

| กิจกรรม | Tech Lead | HR | Buddy | Doc Owner | Team | EM |
|---------|:---------:|:--:|:-----:|:---------:|:----:|:--:|
| Onboarding Program | **A** | **R** | C | I | I | **A** |
| Day 1 Setup | C | **R** | **R** | I | I | I |
| Buddy Assignment | **A** | C | **R** | I | I | I |
| Technical Onboarding | **A** | I | **R** | C | C | I |
| Documentation | **A** | I | C | **R** | **R** | I |
| Knowledge Sharing | **A** | C | C | C | **R** | I |
| Bus Factor Review | **A** | I | I | C | C | **A** |
| Offboarding | **A** | **R** | C | **R** | C | **A** |

**R** = Responsible | **A** = Accountable | **C** = Consulted | **I** = Informed

### 15.1.3 บทบาท Buddy (ละเอียด)

**ก่อนวันแรก:**
- [ ] เตรียม Account (Email, SSO, Git, Azure, Slack)
- [ ] เตรียม Laptop + Access Card
- [ ] เตรียม Workspace / Desk
- [ ] ส่ง Welcome Email (ก่อน 1 วัน)
- [ ] เตรียม Onboarding Checklist

**วันแรก:**
- [ ] ต้อนรับที่ Office (หรือ Online)
- [ ] แนะนำทีม (Introduce)
- [ ] พา Tour Office (หรือ Virtual)
- [ ] Setup Environment
- [ ] มอบหมาย Task แรก (เล็กๆ)
- [ ] รับประทานอาหารกลางวันด้วย

**สัปดาห์แรก:**
- [ ] Daily Check-in (15 นาที)
- [ ] Pair Programming
- [ ] ตอบคำถาม
- [ ] Review PR แรก

**เดือนแรก:**
- [ ] Weekly 1-on-1
- [ ] Feedback
- [ ] ปรับ Onboarding Plan

### 15.1.4 คุณสมบัติ Buddy ที่ดี

| คุณสมบัติ | รายละเอียด |
|-----------|-----------|
| **Patient** | อดทน, ตอบคำถามซ้ำได้ |
| **Approachable** | เข้าถึงง่าย |
| **Knowledgeable** | รู้ระบบดี |
| **Communicative** | สื่อสารชัด |
| **Empathetic** | เข้าใจความรู้สึกคนใหม่ |
| **Organized** | มี Plan |
| **Positive** | สร้างบรรยากาศดี |

---

## 15.2 Onboarding Program (30-60-90 วัน)

### 15.2.1 ภาพรวม 30-60-90

```
┌─────────────────────────────────────────────────────────────┐
│              30-60-90 DAY ONBOARDING                        │
└─────────────────────────────────────────────────────────────┘

  Day 1-30: LEARN (เรียน)
  ├─ Setup Environment
  ├─ อ่าน Documentation
  ├─ Pair Programming
  ├─ Task เล็ก (Good First Issue)
  └─ เป้าหมาย: ทำงานเล็กได้

  Day 31-60: CONTRIBUTE (มีส่วนร่วม)
  ├─ Task ขนาดกลาง
  ├─ Review PR
  ├─ เข้า Sprint Planning
  └─ เป้าหมาย: ทำงานเองได้

  Day 61-90: OWN (เป็นเจ้าของ)
  ├─ Own Feature เล็ก
  ├─ Mentor Junior (ถ้ามี)
  ├─ เสนอ Idea
  └─ เป้าหมาย: ทำงานเต็มที่
```

### 15.2.2 Day 1 Checklist (ละเอียด)

**ก่อนวันแรก (Buddy + HR):**

- [ ] ส่ง Welcome Email พร้อมข้อมูล:
  - วันเวลาเริ่มงาน
  - สถานที่ / Link Online
  - สิ่งที่ต้องเตรียม (บัตรประชาชน, เอกสาร)
  - Dress Code
  - Parking / Transport
  - Contact Person (Buddy)
- [ ] เตรียม Account:
  - Email (@your-company.com)
  - SSO (Azure AD)
  - Git (GitHub/GitLab)
  - Azure Portal
  - Slack
  - Jira / Linear
  - Confluence / Notion
- [ ] เตรียม Hardware:
  - Laptop (MacBook / ThinkPad)
  - Monitor
  - Keyboard / Mouse
  - Headset
  - Access Card
- [ ] เตรียม Workspace:
  - Desk
  - Chair
  - Stationery
- [ ] เตรียม Documentation:
  - Team Handbook
  - Onboarding Guide
  - Architecture Overview

**วันแรก (Buddy):**

| เวลา | กิจกรรม | ผู้รับผิดชอบ |
|------|---------|-------------|
| 09:00 | ต้อนรับ + แนะนำทีม | Buddy + EM |
| 09:30 | Tour Office / Virtual Tour | Buddy |
| 10:00 | Setup Laptop + Account | IT + Buddy |
| 11:00 | อ่าน Team Handbook | Self |
| 12:00 | อาหารกลางวัน (กับทีม) | Buddy |
| 13:00 | Setup Development Environment | Buddy |
| 15:00 | แนะนำ Tools (Git, Slack, Jira) | Buddy |
| 16:00 | Task แรก (Good First Issue) | Buddy |
| 17:00 | Daily Check-in + Q&A | Buddy |

**วันแรก (New Member):**

- [ ] รับ Laptop + Access Card
- [ ] Setup Email + SSO
- [ ] Join Slack Channels:
  - #general
  - #team-[name]
  - #dev
  - #incidents
  - #random
- [ ] Clone Repo แรก
- [ ] Run Local (ด้วยความช่วยเหลือ)
- [ ] อ่าน Team Handbook (อย่างน้อย 30 นาที)
- [ ] แนะนำตัวใน #general
- [ ] ถามคำถาม (อย่างน้อย 3 ข้อ)

### 15.2.3 Week 1 Checklist

**Day 2–3:**

- [ ] Clone ทุก Repo ที่เกี่ยวข้อง
- [ ] Run Local ได้เอง
- [ ] อ่าน Architecture Overview
- [ ] อ่าน Coding Standard
- [ ] Pair Programming กับ Buddy (2 ชั่วโมง)
- [ ] แก้ Bug เล็ก (Typo, Comment)
- [ ] เปิด PR แรก
- [ ] Code Review PR แรก

**Day 4–5:**

- [ ] อ่าน ADR ทั้งหมด
- [ ] อ่าน Runbook
- [ ] เข้า Sprint Planning (Observer)
- [ ] เข้า Daily Standup
- [ ] ทำงาน Task เล็ก (Good First Issue)
- [ ] เปิด PR ที่ 2
- [ ] ทบทวน Onboarding Checklist
- [ ] 1-on-1 กับ Buddy (30 นาที)

**Week 1 Goals:**

- [ ] Environment ทำงานได้
- [ ] รู้จักทีม
- [ ] เข้าใจ Architecture ระดับสูง
- [ ] Merge PR แรก
- [ ] รู้ว่าใครเป็นใคร
- [ ] รู้ว่าถามใครเรื่องอะไร

### 15.2.4 Month 1 Checklist (Learn)

**Technical:**

- [ ] เข้าใจ Architecture ทั้งหมด
- [ ] เข้าใจ Data Model
- [ ] เข้าใจ API Contract
- [ ] เข้าใจ CI/CD Pipeline
- [ ] ทำงาน Task ขนาดเล็กได้เอง (≤ 1 วัน)
- [ ] Merge PR ≥ 3
- [ ] Review PR ≥ 2

**Process:**

- [ ] เข้าใจ Git Flow
- [ ] เข้าใจ Sprint Process
- [ ] เข้าใจ Code Review Process
- [ ] เข้าใจ Incident Process
- [ ] รู้จัก Runbook

**People:**

- [ ] รู้จักทีมทั้งหมด
- [ ] รู้ว่าใครเชี่ยวชาญอะไร
- [ ] รู้ Escalation Path

**Month 1 Review:**

- [ ] 1-on-1 กับ EM
- [ ] Feedback จาก Buddy
- [ ] Feedback ถึง Buddy
- [ ] ปรับ Onboarding Plan

### 15.2.5 Month 2 Checklist (Contribute)

**Technical:**

- [ ] ทำงาน Task ขนาดกลางได้เอง (≤ 3 วัน)
- [ ] Merge PR ≥ 5
- [ ] Review PR ≥ 5
- [ ] แก้ Bug ใน Module ที่ไม่คุ้นเคย
- [ ] เข้าใจ Testing Strategy
- [ ] เขียน Test เองได้

**Process:**

- [ ] นำเสนอใน Sprint Planning
- [ ] นำเสนอใน Sprint Review
- [ ] มีส่วนร่วมใน Retrospective
- [ ] เข้าใจ Incident Response

**People:**

- [ ] Pair Programming กับคนอื่น (ไม่ใช่ Buddy)
- [ ] ช่วยเหลือคนอื่น
- [ ] เข้า Social Event

**Month 2 Review:**

- [ ] 1-on-1 กับ EM
- [ ] Self-assessment
- [ ] Goal สำหรับ Month 3

### 15.2.6 Month 3 Checklist (Own)

**Technical:**

- [ ] Own Feature เล็ก (End-to-End)
- [ ] Merge PR ≥ 8
- [ ] Review PR ≥ 8
- [ ] แก้ Incident (ด้วยความช่วยเหลือ)
- [ ] เข้าใจ Observability
- [ ] เข้าใจ Security

**Process:**

- [ ] เสนอ Improvement Idea
- [ ] อัปเดต Documentation
- [ ] แชร์ความรู้ (Tech Talk / Brown Bag)

**People:**

- [ ] Mentor Junior (ถ้ามี)
- [ ] เป็น Buddy (ถ้ามี)
- [ ] เป็น Reviewer ที่เชื่อถือได้

**Month 3 Review:**

- [ ] 1-on-1 กับ EM
- [ ] Performance Review
- [ ] Goal ถัดไป

### 15.2.7 Onboarding Success Metrics

| Milestone | Target | วิธีวัด |
|-----------|--------|---------|
| **Environment Ready** | Day 1 | Checklist |
| **First PR Merged** | ≤ 5 วัน | Git Log |
| **First Feature Owned** | ≤ 30 วัน | Jira |
| **Working Independently** | ≤ 60 วัน | Manager Assessment |
| **Full Productivity** | ≤ 90 วัน | Manager Assessment |
| **Onboarding Satisfaction** | ≥ 4/5 | Survey |

---

## 15.3 Buddy System (Deep Dive)

### 15.3.1 Buddy vs Mentor vs Manager

| บทบาท | หน้าที่ | ความถี่ |
|-------|---------|---------|
| **Buddy** | ดูแลรายวัน, ตอบคำถาม, ช่วย Setup | Daily (Week 1-4) |
| **Mentor** | พัฒนาอาชีพ, ให้คำแนะนำระยะยาว | Bi-weekly |
| **Manager** | Performance, Career, Goal | Weekly |

### 15.3.2 Buddy Guidelines

**Do's:**

- ✅ ตอบคำถามทุกข้อ (ไม่ว่าดูโง่แค่ไหน)
- ✅ Check-in ทุกวัน (Week 1)
- ✅ Pair Programming อย่างน้อย 2 ครั้ง/สัปดาห์
- ✅ แนะนำคนในทีม
- ✅ แชร์ Context (ทำไม ทำแบบนี้)
- ✅ ให้ Feedback สร้างสรรค์
- ✅ รับฟัง

**Don'ts:**

- ❌ ตำหนิเวลาถาม
- ❌ บอกให้ "ไปอ่านเอง"
- ❌ ไม่มีเวลาให้
- ❌ ให้ Task ที่ใหญ่เกินไป
- ❌ ปล่อยให้เผชิญคนเดียว
- ❌ ลืม Check-in

### 15.3.3 Buddy Check-in Template

```markdown
# Buddy Check-in — [วันที่]

**Buddy:** [ชื่อ]
**New Member:** [ชื่อ]
**Week:** [N]

## สัปดาห์นี้
- ✅ [สิ่งที่ทำเสร็จ]
- ⚠️ [สิ่งที่ติดขัด]
- 📚 [สิ่งที่เรียนรู้]

## ปัญหา / คำถาม
1. [คำถาม 1]
2. [คำถาม 2]

## Plan สัปดาห์หน้า
1. [Plan 1]
2. [Plan 2]

## Feedback
- **สำหรับ New Member:** [Feedback]
- **สำหรับ Buddy:** [Feedback]
- **สำหรับ Process:** [Feedback]
```

### 15.3.4 Buddy Assignment

| เกณฑ์ | รายละเอียด |
|-------|-----------|
| **Experience** | ≥ 6 เดือนในทีม |
| **Availability** | มีเวลา ≥ 2 ชั่วโมง/วัน (Week 1) |
| **Patience** | อดทน, เข้าถึงง่าย |
| **Knowledge** | รู้ระบบดี |
| **Not Manager** | ไม่ใช่ Manager (เพื่อให้ถามได้สบาย) |

**Rotation:**
- Buddy 1 คนต่อ New Member 1 คน
- เปลี่ยน Buddy ได้ถ้าไม่ Compatible
- Buddy ไม่ควรมี New Member > 1 คนพร้อมกัน

---

## 15.4 Knowledge Base Structure (Deep Dive)

### 15.4.1 โครงสร้าง Knowledge Base

```
docs/
├── 00-start-here/
│   ├── README.md                    # จุดเริ่มต้น
│   ├── team-handbook.md             # คู่มือทีม
│   ├── glossary.md                  # ศัพท์เฉพาะ
│   └── faq.md                       # คำถามที่พบบ่อย
│
├── 01-onboarding/
│   ├── day-1-checklist.md
│   ├── week-1-checklist.md
│   ├── month-1-checklist.md
│   ├── environment-setup.md
│   ├── access-request.md
│   └── buddy-guide.md
│
├── 02-architecture/
│   ├── overview.md                  # ภาพรวมระบบ
│   ├── system-design.md
│   ├── data-model.md
│   ├── api-contract.md
│   ├── integration.md
│   └── adr/                         # Architecture Decision Records
│       ├── ADR-001-tech-stack.md
│       ├── ADR-002-database.md
│       └── ...
│
├── 03-development/
│   ├── coding-standard.md
│   ├── frontend-guide.md
│   ├── backend-guide.md
│   ├── testing-guide.md
│   ├── git-flow.md
│   └── code-review.md
│
├── 04-operations/
│   ├── ci-cd.md
│   ├── deployment.md
│   ├── monitoring.md
│   ├── runbook/
│   │   ├── api-error.md
│   │   ├── db-pool.md
│   │   ├── oracle-erp.md
│   │   └── ...
│   └── incident-response.md
│
├── 05-process/
│   ├── sprint-process.md
│   ├── po-ba-workflow.md
│   ├── qa-process.md
│   ├── hotfix-process.md
│   └── rca-process.md
│
├── 06-security/
│   ├── security-guide.md
│   ├── secrets-management.md
│   ├── compliance.md
│   └── incident-response.md
│
├── 07-integrations/
│   ├── oracle-erp.md
│   ├── databricks.md
│   ├── power-bi.md
│   └── azure-ad.md
│
├── 08-business/
│   ├── domain-overview.md
│   ├── finance-workflow.md
│   ├── accounting-workflow.md
│   └── glossary-business.md
│
└── 09-misc/
    ├── tools.md
    ├── contacts.md
    └── changelog.md
```

### 15.4.2 เอกสารแต่ละประเภท

| ประเภท | ตัวอย่าง | Owner | Review |
|--------|----------|-------|--------|
| **Handbook** | Team Handbook | Tech Lead | ปี |
| **Guide** | Coding Standard | Tech Lead | ไตรมาส |
| **Reference** | API Contract | Architect | เมื่อเปลี่ยน |
| **Runbook** | Incident Runbook | On-call Lead | ไตรมาส |
| **ADR** | Architecture Decision | Architect | เมื่อเปลี่ยน |
| **Tutorial** | Onboarding Guide | HR + Buddy | ไตรมาส |
| **FAQ** | Common Questions | ทุกคน | ไตรมาส |

### 15.4.3 Documentation Standards

| มาตรฐาน | รายละเอียด |
|---------|-----------|
| **Language** | ไทย + English (Technical Terms) |
| **Format** | Markdown |
| **Structure** | หัวข้อชัดเจน, มี TOC |
| **Examples** | มีตัวอย่างทุกครั้ง |
| **Diagrams** | Mermaid / Draw.io |
| **Links** | Internal Link ถูกต้อง |
| **Metadata** | Owner, Last Updated, Review Date |
| **Versioning** | Git |
| **Review** | ทุกไตรมาส |
| **Owner** | ระบุชัดเจน |

### 15.4.4 Document Template

```markdown
# [ชื่อเอกสาร]

**Owner:** [ชื่อ]
**Last Updated:** [YYYY-MM-DD]
**Review Date:** [YYYY-MM-DD]
**Status:** [Draft / Active / Deprecated]

---

## สารบัญ
- [หัวข้อ 1](#หัวข้อ-1)
- [หัวข้อ 2](#หัวข้อ-2)

---

## 1. Overview
[อธิบายภาพรวม]

## 2. เนื้อหา
[เนื้อหาหลัก]

### 2.1 [หัวข้อย่อย]
[เนื้อหา]

## 3. ตัวอย่าง
[ตัวอย่าง]

## 4. FAQ
**Q: [คำถาม]**
A: [คำตอบ]

## 5. References
- [ลิงก์ 1]
- [ลิงก์ 2]

## 6. Changelog
| Date | Change | Author |
|------|--------|--------|
| [Date] | [Change] | [Name] |
```

### 15.4.5 Documentation-as-Code (Docs in Repo)

```
┌─────────────────────────────────────────────────────────────┐
│              DOCUMENTATION-AS-CODE                          │
└─────────────────────────────────────────────────────────────┘

  ข้อดี:
  • Version Control (Git)
  • Review Process (PR)
  • CI Check (Link, Format)
  • Search ได้
  • อัปเดตง่าย (พร้อม Code)

  ข้อเสีย:
  • ต้องมีความรู้ Git
  • Search อาจไม่ดีเท่า Wiki
  • ต้อง Setup Tool
```

**Tool ที่แนะนำ:**

| Tool | ใช้ทำอะไร | ข้อดี |
|------|-----------|-------|
| **Markdown + Git** | Docs | Version Control |
| **MkDocs** | Static Site | สวย, Search |
| **Docusaurus** | Static Site | Versioning |
| **Confluence** | Wiki | WYSIWYG |
| **Notion** | Wiki | ยืดหยุ่น |
| **GitBook** | Docs | สวย |

### 15.4.6 Documentation CI Check

```yaml
# .github/workflows/docs.yml
name: Docs Check

on:
  pull_request:
    paths: ['docs/**', '*.md']

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Markdown Lint
        uses: avto-dev/markdown-lint@v1
        with:
          args: 'docs/'

      - name: Check Links
        uses: lycheeverse/lychee-action@v1
        with:
          args: --no-progress 'docs/**/*.md'

      - name: Check Spelling
        uses: crate-ci/typos@master
        with:
          files: docs/
```

---

## 15.5 Knowledge Sharing Practices

### 15.5.1 Knowledge Sharing Activities

| กิจกรรม | ความถี่ | เวลา | ผู้รับผิดชอบ | ผลลัพธ์ |
|---------|---------|------|-------------|---------|
| **Tech Talk** | 2 สัปดาห์ | 45 นาที | อาสาสมัคร | Video + Slide |
| **Brown Bag** | เดือน | 60 นาที | อาสาสมัคร | Notes |
| **Lunch & Learn** | เดือน | 60 นาที | อาสาสมัคร | Notes |
| **Retrospective** | Sprint | 60 นาที | Scrum Master | Action Items |
| **Pair Programming** | ต่อเนื่อง | — | ทุกคน | Knowledge Transfer |
| **Code Review** | ทุก PR | — | Reviewer | Comments |
| **Mob Programming** | ตามต้องการ | 2-4 ชั่วโมง | Facilitator | Code + Notes |
| **Postmortem** | หลัง Incident | 60 นาที | RCA Lead | RCA Report |
| **Wiki Editing** | ต่อเนื่อง | — | ทุกคน | Updated Docs |
| **Internal Blog** | ต่อเนื่อง | — | อาสาสมัคร | Posts |

### 15.5.2 Tech Talk Template

```markdown
# Tech Talk: [ชื่อ]

**Speaker:** [ชื่อ]
**Date:** [YYYY-MM-DD]
**Duration:** 45 นาที
**Audience:** [ทีม / ทุกคน]

## Abstract
[สรุป 2-3 ประโยค]

## Outline
1. [หัวข้อ 1] — 10 นาที
2. [หัวข้อ 2] — 20 นาที
3. [Demo] — 10 นาที
4. [Q&A] — 5 นาที

## Key Takeaways
- [Takeaway 1]
- [Takeaway 2]
- [Takeaway 3]

## Resources
- Slide: [link]
- Video: [link]
- Code: [link]
- Further Reading: [link]
```

### 15.5.3 Brown Bag Session Ideas

| หัวข้อ | เหมาะกับ |
|--------|----------|
| **New Library / Tool** | Dev |
| **Postmortem Lessons** | ทุกคน |
| **Architecture Deep Dive** | Dev, Architect |
| **Security Best Practices** | ทุกคน |
| **Product Demo** | ทุกคน |
| **Customer Story** | ทุกคน |
| **Career Path** | ทุกคน |
| **Book Review** | ทุกคน |
| **Conference Recap** | ทุกคน |

### 15.5.4 Internal Blog

```
┌─────────────────────────────────────────────────────────────┐
│              INTERNAL BLOG                                  │
└─────────────────────────────────────────────────────────────┘

  Platform: Confluence / Notion / GitHub Pages / Medium (Internal)

  ประเภทโพสต์:
  • Technical Deep Dive
  • Postmortem Lessons
  • How We Built X
  • Tool Review
  • Best Practices
  • Lessons Learned
  • Career Story

  ความถี่: ≥ 1 โพสต์/เดือน (ทีม)
```

### 15.5.5 Knowledge Sharing Metrics

| Metric | Target | วิธีวัด |
|--------|--------|---------|
| **Tech Talks** | ≥ 2/เดือน | Calendar |
| **Brown Bags** | ≥ 1/เดือน | Calendar |
| **Internal Posts** | ≥ 1/เดือน | Blog |
| **Documentation Updates** | ≥ 5/เดือน | Git |
| **Pair Programming** | ≥ 2/สัปดาห์/คน | Self-report |
| **Code Reviews** | 100% ของ PR | Git |

---

## 15.6 Training Curriculum

### 15.6.1 Developer Training (Beginner → Advanced)

**Level 1: Foundation (Week 1-4)**

| หัวข้อ | ระยะเวลา | รูปแบบ | Assessment |
|-------|----------|--------|------------|
| Team Overview + Architecture | 2 ชั่วโมง | Workshop | Q&A |
| Environment Setup | 4 ชั่วโมง | Hands-on | Setup Done |
| Git Flow + CI/CD | 2 ชั่วโมง | Workshop | PR Merged |
| Coding Standard | 1 ชั่วโมง | Self-study | Code Review |
| Testing Strategy | 2 ชั่วโมง | Hands-on | Test Written |

**Level 2: Intermediate (Month 2-3)**

| หัวข้อ | ระยะเวลา | รูปแบบ | Assessment |
|-------|----------|--------|------------|
| Clean Architecture | 3 ชั่วโมง | Workshop | Code Review |
| Database Design | 2 ชั่วโมง | Workshop | Schema Review |
| API Design | 2 ชั่วโมง | Workshop | API Review |
| Security Basics | 2 ชั่วโมง | Workshop | Quiz |
| Observability | 2 ชั่วโมง | Hands-on | Dashboard |

**Level 3: Advanced (Month 4-6)**

| หัวข้อ | ระยะเวลา | รูปแบบ | Assessment |
|-------|----------|--------|------------|
| System Design | 4 ชั่วโมง | Workshop | Design Review |
| Performance Tuning | 3 ชั่วโมง | Hands-on | Benchmark |
| Incident Response | 2 ชั่วโมง | Simulation | Drill |
| RCA | 2 ชั่วโมง | Workshop | RCA Report |
| Mentoring | ต่อเนื่อง | Practice | Feedback |

### 15.6.2 PO/BA Training

| หัวข้อ | ระยะเวลา | รูปแบบ |
|-------|----------|--------|
| System Overview | 2 ชั่วโมง | Workshop |
| User Story + AC | 3 ชั่วโมง | Workshop |
| Backlog Management | 2 ชั่วโมง | Workshop |
| Prioritization (MoSCoW) | 1 ชั่วโมง | Workshop |
| UAT Process | 2 ชั่วโมง | Hands-on |
| Stakeholder Management | 2 ชั่วโมง | Workshop |

### 15.6.3 QA Training

| หัวข้อ | ระยะเวลา | รูปแบบ |
|-------|----------|--------|
| Test Strategy + Pyramid | 2 ชั่วโมง | Workshop |
| Automation (pytest) | 4 ชั่วโมง | Hands-on |
| Automation (Playwright) | 4 ชั่วโมง | Hands-on |
| Performance Testing (k6) | 3 ชั่วโมง | Hands-on |
| Security Testing | 3 ชั่วโมง | Workshop |
| Test Data Management | 2 ชั่วโมง | Workshop |

### 15.6.4 DevOps Training

| หัวข้อ | ระยะเวลา | รูปแบบ |
|-------|----------|--------|
| CI/CD Deep Dive | 3 ชั่วโมง | Hands-on |
| Kubernetes Basics | 4 ชั่วโมง | Hands-on |
| Observability (Prometheus, Grafana) | 3 ชั่วโมง | Hands-on |
| Secrets Management | 2 ชั่วโมง | Hands-on |
| Incident Response | 2 ชั่วโมง | Simulation |
| Security (Container, IaC) | 3 ชั่วโมง | Workshop |

### 15.6.5 Training Matrix (สรุป)

| บทบาท | Level 1 | Level 2 | Level 3 | Annual |
|-------|:-------:|:-------:|:-------:|:------:|
| **Developer** | Week 1-4 | Month 2-3 | Month 4-6 | 40 ชม./ปี |
| **PO/BA** | Week 1 | Month 2 | Month 3 | 20 ชม./ปี |
| **QA** | Week 1 | Month 2 | Month 3 | 40 ชม./ปี |
| **DevOps** | Week 1 | Month 2 | Month 3 | 40 ชม./ปี |
| **Architect** | Week 1 | Month 2 | Month 3 | 40 ชม./ปี |

### 15.6.6 Training Resources

| ประเภท | ตัวอย่าง |
|--------|----------|
| **Internal Docs** | Team Handbook, Guides |
| **Video** | Recorded Tech Talks, Tutorials |
| **Courses** | Udemy, Coursera, Pluralsight |
| **Books** | Technical Books (Library) |
| **Certifications** | AWS, Azure, Kubernetes |
| **Conferences** | Local + International |
| **Workshops** | Internal + External |

---

## 15.7 Bus Factor Management

### 15.7.1 Bus Factor คืออะไร?

```
┌─────────────────────────────────────────────────────────────┐
│              BUS FACTOR                                     │
└─────────────────────────────────────────────────────────────┘

  Bus Factor = จำนวนคนที่ถ้าลาออก (หรือ "ถูกรถเมล์ชน")
               แล้วทีมจะไม่สามารถทำงานต่อได้

  Bus Factor = 1 → เสี่ยงสูงมาก (คนเดียวรู้)
  Bus Factor = 2 → เสี่ยงปานกลาง
  Bus Factor ≥ 3 → ดี

  เป้าหมาย: ทุก Module มี Bus Factor ≥ 2
```

### 15.7.2 Bus Factor Assessment

| Module | Primary Owner | Secondary Owner | Bus Factor | Risk |
|--------|--------------|----------------|:----------:|:----:|
| Payment API | Dev A | Dev B | 2 | 🟡 |
| Employee API | Dev B | Dev C | 2 | 🟡 |
| Oracle Integration | Dev A | — | 1 | 🔴 |
| Dashboard | Dev C | Dev A | 2 | 🟡 |
| CI/CD | DevOps A | DevOps B | 2 | 🟡 |
| Database | DBA A | — | 1 | 🔴 |
| Security | Security A | — | 1 | 🔴 |

### 15.7.3 Bus Factor Improvement Strategies

| Strategy | รายละเอียด | Timeline |
|----------|-----------|----------|
| **Pair Programming** | 2 คนทำงานด้วยกัน | ต่อเนื่อง |
| **Code Review Rotation** | หมุน Reviewer | ทุก PR |
| **Knowledge Transfer Session** | คนรู้ สอนคนอื่น | เดือน |
| **Documentation** | เขียนทุกอย่าง | ต่อเนื่อง |
| **Shadowing** | คนใหม่ตามคนเก่า | สัปดาห์ |
| **Rotation** | หมุนงาน | ไตรมาส |
| **Mob Programming** | ทั้งทีมทำด้วยกัน | ตามต้องการ |

### 15.7.4 Knowledge Transfer Plan (สำหรับ Bus Factor = 1)

```markdown
# Knowledge Transfer Plan: Oracle Integration

**Current Owner:** Dev A
**Target Owners:** Dev B, Dev C
**Timeline:** 4 สัปดาห์
**Risk:** 🔴 High (Bus Factor = 1)

## Week 1: Shadowing
- [ ] Dev B ตาม Dev A (2 วัน)
- [ ] Dev B อ่าน Code + Docs
- [ ] Dev B ถามคำถาม

## Week 2: Pair Programming
- [ ] Dev B + Dev A แก้ Bug ด้วยกัน
- [ ] Dev B เขียน Code, Dev A Review
- [ ] Dev C เริ่มตาม

## Week 3: Reverse Shadowing
- [ ] Dev B ทำงานเอง, Dev A ดู
- [ ] Dev C Pair กับ Dev B
- [ ] แก้ Incident ด้วยกัน

## Week 4: Handover
- [ ] Dev B แก้ Incident เดี่ยว (Dev A standby)
- [ ] Dev C แก้ Incident เดี่ยว (Dev B standby)
- [ ] อัปเดต Documentation
- [ ] Bus Factor = 3 ✅

## Success Criteria
- [ ] Dev B แก้ Incident ได้เอง
- [ ] Dev C เข้าใจ Architecture
- [ ] Documentation ครบ
- [ ] ไม่มี Incident ที่ Dev A ต้องแก้คนเดียว
```

### 15.7.5 Bus Factor Review (รายไตรมาส)

**คำถาม:**

- [ ] Module ไหนมี Bus Factor = 1?
- [ ] มี Plan แก้ไขไหม?
- [ ] Documentation ครบไหม?
- [ ] มีคนใหม่ที่พร้อมรับไหม?
- [ ] Risk ยอมรับได้ไหม?

---

## 15.8 Offboarding

### 15.8.1 Offboarding Checklist

**ก่อนวันสุดท้าย (2 สัปดาห์):**

- [ ] แจ้งทีม
- [ ] วางแผน Handover
- [ ] ระบุงานค้าง
- [ ] ระบุ Knowledge ที่ต้อง Transfer
- [ ] จัด Knowledge Transfer Session
- [ ] อัปเดต Documentation

**สัปดาห์สุดท้าย:**

- [ ] Handover งานทั้งหมด
- [ ] Pair Programming กับคนรับงาน
- [ ] Document สิ่งที่รู้
- [ ] Review PR ค้าง
- [ ] ปิด Task ใน Jira
- [ ] Exit Interview

**วันสุดท้าย:**

- [ ] คืน Laptop + Access Card
- [ ] Revoke Access:
  - [ ] Email
  - [ ] SSO
  - [ ] Git
  - [ ] Azure
  - [ ] Slack
  - [ ] Jira
  - [ ] Database
- [ ] คืนเอกสาร
- [ ] ส่งต่อ Contacts
- [ ] อำลา

### 15.8.2 Knowledge Transfer (Offboarding)

```markdown
# Knowledge Transfer: [ชื่อผู้ออก]

**Leaving:** [ชื่อ]
**Last Day:** [YYYY-MM-DD]
**Receivers:** [ชื่อ 1], [ชื่อ 2]

## Responsibilities
| Task | Frequency | Receiver | Status |
|------|-----------|----------|--------|
| Payment API | Daily | Dev B | ⏳ |
| Oracle Integration | Weekly | Dev C | ⏳ |
| On-call | Rotation | Dev B | ⏳ |

## Knowledge Areas
| Area | Depth | Receiver | Doc |
|------|-------|----------|-----|
| Payment Flow | Expert | Dev B | ✅ |
| Oracle API | Expert | Dev C | ⏳ |
| Runbook | Intermediate | Dev B | ✅ |

## Known Issues / Tech Debt
- [Issue 1] — [Context]
- [Issue 2] — [Context]

## Contacts
| Person | Role | Contact |
|--------|------|---------|
| [Name] | Oracle Vendor | [Email] |

## Handover Meetings
| Date | Topic | Attendees |
|------|-------|-----------|
| [Date] | Payment Deep Dive | Dev B, Dev C |

## Sign-off
- [ ] All Tasks Handed Over
- [ ] Documentation Updated
- [ ] Receivers Confident
```

### 15.8.3 Access Revocation Checklist

- [ ] Email Account (Disable)
- [ ] SSO (Revoke)
- [ ] Git (Remove from Org)
- [ ] Azure (Remove from Subscription)
- [ ] Slack (Deactivate)
- [ ] Jira (Deactivate)
- [ ] Database (Drop User)
- [ ] VPN (Revoke)
- [ ] Physical Access Card (Disable)
- [ ] Shared Password (Rotate — ถ้าใช้)

> ⚠️ **สำคัญ:** Revoke Access **ภายใน 24 ชั่วโมง** หลังวันสุดท้าย

---

## 15.9 Templates (ครบชุด)

### 15.9.1 Onboarding Checklist Template (Full)

```markdown
# Onboarding Checklist — [ชื่อ]

**Start Date:** [YYYY-MM-DD]
**Role:** [Developer / QA / PO / ...]
**Buddy:** [ชื่อ]
**Manager:** [ชื่อ]

## Pre-Day 1 (HR + Buddy)
- [ ] Welcome Email ส่งแล้ว
- [ ] Account สร้างแล้ว (Email, SSO, Git, ...)
- [ ] Laptop เตรียมแล้ว
- [ ] Access Card เตรียมแล้ว
- [ ] Workspace เตรียมแล้ว
- [ ] Onboarding Guide ส่งแล้ว

## Day 1
- [ ] ต้อนรับ + แนะนำทีม
- [ ] Tour Office / Virtual
- [ ] Setup Laptop + Account
- [ ] เข้า Slack Channels
- [ ] อ่าน Team Handbook
- [ ] Clone Repo แรก
- [ ] Task แรก (Good First Issue)
- [ ] Daily Check-in

## Week 1
- [ ] Environment ทำงานได้
- [ ] Run Local ได้
- [ ] อ่าน Architecture Overview
- [ ] อ่าน Coding Standard
- [ ] Pair Programming (2 ครั้ง)
- [ ] PR แรก Merge
- [ ] Code Review แรก
- [ ] 1-on-1 กับ Buddy
- [ ] Week 1 Review

## Month 1
- [ ] เข้าใจ Architecture
- [ ] เข้าใจ Data Model
- [ ] ทำงาน Task เล็กได้เอง
- [ ] Merge PR ≥ 3
- [ ] Review PR ≥ 2
- [ ] เข้า Sprint Planning
- [ ] 1-on-1 กับ EM
- [ ] Month 1 Review

## Month 2
- [ ] ทำงาน Task กลางได้เอง
- [ ] Merge PR ≥ 5
- [ ] Review PR ≥ 5
- [ ] นำเสนอใน Sprint Review
- [ ] Pair กับคนอื่น (ไม่ใช่ Buddy)
- [ ] Month 2 Review

## Month 3
- [ ] Own Feature เล็ก
- [ ] Merge PR ≥ 8
- [ ] Review PR ≥ 8
- [ ] แก้ Incident (ด้วยความช่วยเหลือ)
- [ ] แชร์ความรู้ (Tech Talk)
- [ ] Month 3 Review
- [ ] **Onboarding Complete** ✅

## Sign-off
- **Buddy:** [ชื่อ] — [Date]
- **Manager:** [ชื่อ] — [Date]
- **New Member:** [ชื่อ] — [Date]
```

### 15.9.2 Knowledge Transfer Template

```markdown
# Knowledge Transfer: [Topic]

**From:** [ชื่อ]
**To:** [ชื่อ 1], [ชื่อ 2]
**Date:** [YYYY-MM-DD]
**Type:** [Offboarding / Bus Factor / Rotation]

## Scope
[อธิบาย Knowledge ที่ Transfer]

## Areas
| Area | Depth | Priority | Status |
|------|-------|----------|--------|
| [Area 1] | Expert | High | ⏳ |
| [Area 2] | Working | Medium | ⏳ |

## Sessions
| Date | Topic | Duration | Attendees |
|------|-------|----------|-----------|
| [Date] | [Topic] | 2h | [Names] |

## Artifacts
- [ ] Documentation Updated
- [ ] Video Recorded
- [ ] Code Walkthrough
- [ ] Runbook Updated

## Verification
- [ ] Receiver อธิบายได้
- [ ] Receiver ทำงานได้เอง
- [ ] Receiver แก้ Incident ได้
- [ ] Documentation ครบ

## Sign-off
- **From:** [ชื่อ] — [Date]
- **To:** [ชื่อ] — [Date]
```

### 15.9.3 Exit Interview Template

```markdown
# Exit Interview

**Name:** [ชื่อ]
**Role:** [Role]
**Last Day:** [YYYY-MM-DD]
**Interviewer:** [ชื่อ]

## Reasons for Leaving
- [ ] Career Growth
- [ ] Compensation
- [ ] Work-Life Balance
- [ ] Management
- [ ] Team
- [ ] Other: [ระบุ]

## What Went Well
- [สิ่งที่ชอบ]

## What Could Be Improved
- [สิ่งที่ควรปรับ]

## Suggestions
- [ข้อเสนอแนะ]

## Would You Recommend Us?
- [ ] Yes
- [ ] No
- Why: [เหตุผล]

## Knowledge Transfer Status
- [ ] Complete
- [ ] Partial
- [ ] Not Started

## Notes
[หมายเหตุ]
```

### 15.9.4 Documentation Review Template

```markdown
# Documentation Review — [Document]

**Reviewer:** [ชื่อ]
**Date:** [YYYY-MM-DD]
**Document Owner:** [ชื่อ]
**Last Updated:** [YYYY-MM-DD]

## Checklist
- [ ] หัวข้อชัดเจน
- [ ] มี TOC
- [ ] มีตัวอย่าง
- [ ] Links ถูกต้อง
- [ ] Metadata ครบ (Owner, Date)
- [ ] Language ถูกต้อง
- [ ] Format ถูกต้อง
- [ ] Diagram (ถ้ามี) ชัดเจน
- [ ] ข้อมูลถูกต้อง
- [ ] ทันสมัย

## Issues Found
| # | Issue | Severity | Fix |
|---|-------|----------|-----|
| 1 | [Issue] | [H/M/L] | [Fix] |

## Verdict
- [ ] ✅ Approved
- [ ] ⚠️ Approved with Changes
- [ ] ❌ Needs Major Revision

## Next Review
[YYYY-MM-DD]
```

---

## 15.10 KPIs สำหรับ Knowledge Management & Onboarding

### 15.10.1 Onboarding KPIs

| KPI | คำนิยาม | เป้าหมาย | วิธีวัด |
|-----|---------|----------|---------|
| **Time to First PR** | เวลาจากวันแรกถึง PR แรก | ≤ 5 วัน | Git |
| **Time to First Merge** | เวลาจากวันแรกถึง Merge แรก | ≤ 7 วัน | Git |
| **Time to Productivity** | เวลาจากวันแรกถึงทำงานเอง | ≤ 60 วัน | Manager |
| **Time to Full Productivity** | เวลาจากวันแรกถึงเต็มที่ | ≤ 90 วัน | Manager |
| **Onboarding Satisfaction** | ความพึงพอใจ | ≥ 4.5/5 | Survey |
| **Buddy Satisfaction** | ความพึงพอใจ Buddy | ≥ 4/5 | Survey |
| **90-Day Retention** | % อยู่ครบ 90 วัน | ≥ 95% | HR |
| **1-Year Retention** | % อยู่ครบ 1 ปี | ≥ 85% | HR |

### 15.10.2 Knowledge Management KPIs

| KPI | คำนิยาม | เป้าหมาย | วิธีวัด |
|-----|---------|----------|---------|
| **Documentation Coverage** | % Module ที่มีเอกสาร | ≥ 90% | Audit |
| **Documentation Freshness** | % ที่ Review ≤ 3 เดือน | ≥ 80% | Audit |
| **Documentation Quality** | คะแนนคุณภาพ | ≥ 4/5 | Review |
| **Bus Factor ≥ 2** | % Module ที่ Bus Factor ≥ 2 | 100% | Assessment |
| **Knowledge Sharing** | จำนวน Sessions/เดือน | ≥ 2 | Calendar |
| **Internal Posts** | จำนวน Posts/เดือน | ≥ 1 | Blog |
| **Support Reduction** | % ลด Support Request | ≥ 30% | Support Log |
| **Search Success** | % หาเจอใน 1 ครั้ง | ≥ 80% | Analytics |

### 15.10.3 Knowledge Dashboard ตัวอย่าง

```
┌─────────────────────────────────────────────────────────────┐
│          KNOWLEDGE & ONBOARDING — Q4 2024                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ONBOARDING:                                                 │
│  Time to First PR:      █████████░  4 วัน  🟢               │
│  Time to Productivity:  ████████░░  55 วัน 🟢               │
│  Onboarding Sat:        █████████░  4.6/5  🟢              │
│  90-Day Retention:      ██████████  100%   🟢              │
│                                                              │
│  KNOWLEDGE:                                                  │
│  Doc Coverage:          ████████░░  85%    🟡              │
│  Doc Freshness:         ███████░░░  75%    🟡              │
│  Bus Factor ≥ 2:        ████████░░  80%    🟡              │
│  Knowledge Sharing:     █████████░  3/เดือน 🟢              │
│  Support Reduction:     ███████░░░  -35%   🟢              │
│                                                              │
│  Highlights:                                                 │
│  • New Member 3 คน Productivity เร็ว (≤ 60 วัน)               │
│  • Tech Talk 6 ครั้งใน Q4                                     │
│                                                              │
│  Concerns:                                                   │
│  • Documentation Freshness ต่ำ (75% vs 80%)                  │
│  • Bus Factor = 1: Oracle Integration, Database             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 15.11 Anti-Patterns

### 15.11.1 Onboarding Anti-Patterns

| # | ❌ Anti-Pattern | ผลกระทบ | ✅ ควรทำ |
|---|----------------|---------|----------|
| 1 | ไม่มี Buddy | ใหม่เผชิญคนเดียว | มี Buddy |
| 2 | ไม่มี Checklist | ลืม Setup | Checklist |
| 3 | Task ใหญ่ตั้งแต่วันแรก | ท้อ | Task เล็ก |
| 4 | ไม่มี Check-in | ไม่รู้ปัญหา | Check-in |
| 5 | "ไปอ่านเอง" | ใหม่หลง | แนะนำ |
| 6 | ไม่มี Documentation | ถามตลอด | เขียน Docs |
| 7 | ไม่มี Feedback | ไม่ปรับ | ให้ Feedback |
| 8 | ปล่อยให้จัดการเอง | Burnout | ช่วยเหลือ |
| 9 | ไม่มี Goal ชัด | ไม่มีทิศ | 30-60-90 |
| 10 | ไม่วัดผล | ไม่รู้ว่าดีไหม | KPI |

### 15.11.2 Knowledge Management Anti-Patterns

| # | ❌ Anti-Pattern | ผลกระทบ | ✅ ควรทำ |
|---|----------------|---------|----------|
| 1 | เอกสารล้าสมัย | หลอกคน | Review |
| 2 | ไม่มี Owner | ไม่มีคนดูแล | ระบุ Owner |
| 3 | Bus Factor = 1 | เสี่ยงสูง | Pair, Doc |
| 4 | เก็บความรู้ไว้ | ทีมไม่โต | แบ่งปัน |
| 5 | ไม่มี Review | ผิด | Review |
| 6 | Docs แยกจาก Code | ล้าสมัย | Docs-as-Code |
| 7 | ไม่มี Search | หาไม่เจอ | Search Tool |
| 8 | ไม่มี Structure | ยุ่งเหยิง | Folder Structure |
| 9 | ไม่มี Metadata | ไม่รู้ Updated | Metadata |
| 10 | ไม่แชร์ | ความรู้หาย | Sharing |

### 15.11.3 Documentation Anti-Patterns

| ❌ | ✅ |
|----|----|
| ยาว ไม่มี TOC | มี TOC |
| ไม่มีตัวอย่าง | มีตัวอย่าง |
| หัวข้อไม่ชัด | หัวข้อชัด |
| ไม่มี Diagram | มี Diagram |
| Links เสีย | ตรวจ Links |
| ไม่อัปเดต | Review ไตรมาส |
| ไม่มี Owner | ระบุ Owner |
| Language ปนกัน | Consistent |
| ไม่มี Version | Git |
| ไม่มี Changelog | มี Changelog |

---

## 15.12 Best Practices

### 15.12.1 Onboarding Best Practices

- ✅ **เตรียมก่อนวันแรก** — Account, Hardware, Workspace
- ✅ **Buddy System** — 1:1 ดูแล
- ✅ **Checklist 30-60-90** — ชัดเจน
- ✅ **Task เล็กวันแรก** — สร้าง Confidence
- ✅ **Daily Check-in** — Week 1
- ✅ **1-on-1 Weekly** — Month 1-3
- ✅ **Feedback สม่ำเสมอ** — ทั้ง 2 ทาง
- ✅ **Documentation ครบ** — อ่านได้เอง
- ✅ **วัดผล** — Time to Productivity
- ✅ **ปรับปรุง** — จาก Feedback

### 15.12.2 Knowledge Management Best Practices

- ✅ **Docs-as-Code** — อยู่ใน Git
- ✅ **Owner ชัด** — ทุกเอกสาร
- ✅ **Review ไตรมาส** — ไม่ล้าสมัย
- ✅ **Bus Factor ≥ 2** — ทุก Module
- ✅ **Knowledge Sharing** — สม่ำเสมอ
- ✅ **Templates** — มาตรฐาน
- ✅ **Search** — หาง่าย
- ✅ **Structure** — Folder ชัดเจน
- ✅ **Metadata** — Owner, Date, Status
- ✅ **CI Check** — Links, Format, Spelling

### 15.12.3 Do's & Don'ts

```
┌─────────────────────────────────────────────────────────────┐
│              KNOWLEDGE & ONBOARDING                         │
│                  DO's & DON'Ts                              │
└─────────────────────────────────────────────────────────────┘

  ✅ DO                          ❌ DON'T
  ─────                          ────────
  • เตรียมก่อนวันแรก             • ปล่อยให้จัดการเอง
  • มี Buddy                      • ไม่มี Buddy
  • Checklist 30-60-90            • ไม่มี Plan
  • Task เล็ก                     • Task ใหญ่
  • Check-in                      • ไม่สนใจ
  • Docs-as-Code                  • Docs แยกจาก Code
  • Owner ชัด                     • ไม่มี Owner
  • Review ไตรมาส                 • ปล่อยล้าสมัย
  • Bus Factor ≥ 2                • Bus Factor = 1
  • Knowledge Sharing             • เก็บความรู้
  • วัดผล                         • ไม่วัดผล
  • Feedback                      • ไม่ Feedback
```

---

## 15.13 FAQ

**Q1: Onboarding ใช้เวลานานแค่ไหน?**
A: **90 วัน** (30 Learn + 30 Contribute + 30 Own) — Productivity เต็มที่ 3-6 เดือน

**Q2: Buddy ต่างจาก Mentor ยังไง?**
A: Buddy = ดูแลรายวัน (Week 1-4), Mentor = พัฒนาอาชีพระยะยาว — Buddy อาจเป็น Mentor ในอนาคต

**Q3: ถ้าไม่มี Buddy ที่ Suitable ทำไง?**
A: หาคนที่ใกล้เคียง (≥ 6 เดือน, มีเวลา) — ถ้าไม่มีจริงๆ → Manager ดูแลชั่วคราว + หา Buddy ภายใน 2 สัปดาห์

**Q4: Documentation ควรอยู่ที่ไหน?**
A: **Docs-as-Code** (ใน Repo) — Version Control, Review, CI Check — หรือ Wiki (Confluence, Notion) ถ้าทีมถนัด

**Q5: Bus Factor = 1 แก้ยังไง?**
A: **Knowledge Transfer Plan** 4 สัปดาห์ — Shadowing → Pair → Reverse Shadow → Handover — เป้า Bus Factor ≥ 2

**Q6: ต้องแชร์ความรู้บ่อยแค่ไหน?**
A: **Tech Talk ≥ 2/เดือน, Brown Bag ≥ 1/เดือน** — หรือตามความเหมาะสม — เป้าหลักคือ **สม่ำเสมอ**

**Q7: วัดผล Onboarding ยังไง?**
A: **Time to First PR, Time to Productivity, Satisfaction, Retention** — Survey ที่ 30/60/90 วัน

**Q8: Documentation ล้าสมัย ทำไง?**
A: **Review ไตรมาส** — Owner รับผิดชอบ — CI Check (Links, Date) — ถ้าเกิน 6 เดือน → Flag

**Q9: Offboarding ต้องทำอะไรบ้าง?**
A: **Handover งาน + Knowledge Transfer + Revoke Access** — Access Revoke ภายใน 24 ชั่วโมงหลังวันสุดท้าย

**Q10: จะเริ่ม Knowledge Management ยังไง?**
A: (1) สร้าง Structure (2) เขียน Handbook (3) ระบุ Owner (4) Review ไตรมาส (5) Knowledge Sharing (6) วัดผล

---

## 15.14 Glossary

| คำ | ความหมาย |
|----|----------|
| **Onboarding** | การรับสมาชิกใหม่ |
| **Offboarding** | การส่งสมาชิกออก |
| **Buddy** | พี่เลี้ยงดูแลรายวัน |
| **Mentor** | ที่ปรึกษาพัฒนาอาชีพ |
| **Bus Factor** | จำนวนคนที่ขาดแล้วทีมแย่ |
| **Tacit Knowledge** | ความรู้ในหัวคน |
| **Explicit Knowledge** | ความรู้ที่เขียนออกมา |
| **Docs-as-Code** | เอกสารอยู่ใน Repo |
| **Knowledge Base** | ศูนย์รวมความรู้ |
| **Knowledge Transfer** | การถ่ายทอดความรู้ |
| **Shadowing** | การตามดูงาน |
| **Pair Programming** | 2 คนเขียน Code ด้วยกัน |
| **Mob Programming** | ทั้งทีมเขียนด้วยกัน |
| **Brown Bag** | Lunch & Learn |
| **Tech Talk** | การบรรยายเทคนิค |
| **Handbook** | คู่มือทีม |
| **ADR** | Architecture Decision Record |
| **Runbook** | คู่มือแก้ Incident |
| **Good First Issue** | Task เหมาะสำหรับใหม่ |
| **1-on-1** | ประชุมตัวต่อตัว |

---

## 15.15 ความเชื่อมโยงกับเล่มอื่น

| เล่ม | ความเชื่อมโยงกับเล่ม 15 |
|------|-------------------------|
| **เล่ม 1 (PO/BA)** | User Story Template ใน Docs |
| **เล่ม 2 (Full-Stack)** | Coding Standard, Guides |
| **เล่ม 3 (Architect)** | ADR, System Design |
| **เล่ม 4 (QA)** | Test Strategy, Test Cases |
| **เล่ม 5 (DevOps)** | Runbook, CI/CD Docs |
| **เล่ม 6 (Code Review)** | Review Checklist |
| **เล่ม 7 (On-call)** | Runbook, Incident Process |
| **เล่ม 8 (User)** | User Guide, FAQ |
| **เล่ม 9 (Management)** | Status Reports |
| **เล่ม 10 (AI-Assisted)** | Plan Docs, Decision Log |
| **เล่ม 11 (Hotfix)** | Hotfix Runbook |
| **เล่ม 12 (CI/CD)** | Git Flow, Pipeline Docs |
| **เล่ม 13 (RCA)** | RCA Reports, Lessons |
| **เล่ม 14 (Security)** | Security Policy, Training |

---

## 15.16 สรุปสาระสำคัญ (Key Takeaways)

```text
┌─────────────────────────────────────────────────────────────┐
│              KNOWLEDGE MANAGEMENT & ONBOARDING              │
│                     KEY TAKEAWAYS                           │
└─────────────────────────────────────────────────────────────┘

  1. Onboarding 30-60-90 — Learn → Contribute → Own
  2. เตรียมก่อนวันแรก — Account, Hardware, Workspace
  3. Buddy System — 1:1 ดูแลรายวัน
  4. Checklist ครบ — Day 1, Week 1, Month 1-3
  5. Task เล็กวันแรก — สร้าง Confidence
  6. Docs-as-Code — เอกสารอยู่ใน Git
  7. Owner ชัด — ทุกเอกสาร
  8. Review ไตรมาส — ไม่ล้าสมัย
  9. Bus Factor ≥ 2 — ทุก Module
  10. Knowledge Sharing — Tech Talk, Brown Bag
  11. Training Curriculum — ตาม Role
  12. Offboarding — Handover + Revoke Access
  13. วัดผล — Time to Productivity, Satisfaction
  14. Blameless — ไม่ตำหนิ
  15. ปรับปรุงเสมอ — จาก Feedback
```

---

> **หมายเหตุ:** เอกสารนี้เป็นส่วนขยายของเล่ม 15 ใน Master Index ควร Review ทุกไตรมาสร่วมกับ **HR** และ **Tech Lead** และอัปเดตตามการเปลี่ยนแปลงของทีม/องค์กร โดยมี **Tech Lead (หรือ HR)** เป็น Owner

---

## 🎉 สรุป: ชุดคู่มือครบ 15 เล่ม

```text
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│         COMPLETE WORK MANUALS (15 เล่ม) — DONE ✅            │
│                                                             │
│  ✅ เล่ม 1:  PO/BA                                           │
│  ✅ เล่ม 2:  Full-Stack Engineer                             │
│  ✅ เล่ม 3:  Solution Architect / Tech Lead                  │
│  ✅ เล่ม 4:  QA / Test Engineer                              │
│  ✅ เล่ม 5:  DevOps / Platform Engineer                      │
│  ✅ เล่ม 6:  Code Reviewer                                   │
│  ✅ เล่ม 7:  Incident Commander / On-call                    │
│  ✅ เล่ม 8:  ผู้ใช้ (Finance & Accounting)                  │
│  ✅ เล่ม 9:  ผู้บริหาร (Management / Stakeholder)           │
│  ✅ เล่ม 10: AI-Assisted Development (tb-* Skills)           │
│  ✅ เล่ม 11: Hotfix & Rollback                               │
│  ✅ เล่ม 12: CI/CD & Git Flow                                │
│  ✅ เล่ม 13: RCA (Root Cause Analysis)                       │
│  ✅ เล่ม 14: Security & Compliance                           │
│  ✅ เล่ม 15: Knowledge Management & Onboarding              │
│                                                             │
│  🎯 ครบทุก Role, ครบทุก Process, พร้อมใช้งานจริง           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```
 
