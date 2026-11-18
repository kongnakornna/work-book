# 📘 เล่ม 5: คู่มือ DevOps / Platform Engineer
## Financial & Accounting Technology Solutions

---
# 📑 สารบัญ (Table of Contents)

- [1. บทนำ (Introduction)](#1-บทนำ-introduction)
- [2. บทนิยาม (Definitions)](#2-บทนิยาม-definitions)
- [3. บทบาทและความรับผิดชอบ (Roles & Responsibilities)](#3-บทบาทและความรับผิดชอบ-roles--responsibilities)
- [4. ความรู้พื้นฐานที่ต้องมี (Prerequisites)](#4-ความรู้พื้นฐานที่ต้องมี-prerequisites)
- [5. โครงสร้างการทำงาน (Team Structure)](#5-โครงสร้างการทำงาน-team-structure)
- [6. หลักการทำงาน (Concept)](#6-หลักการทำงาน-concept)
- [7. Workflow และ Dataflow](#7-workflow-และ-dataflow)
- [8. CI/CD Pipeline Standards](#8-cicd-pipeline-standards)
- [9. Infrastructure Standards](#9-infrastructure-standards)
- [10. Observability Standards](#10-observability-standards)
- [11. Security & Secrets Management](#11-security--secrets-management)
- [12. Deployment Strategies](#12-deployment-strategies)
- [13. Case Study](#13-case-study)
- [14. KPI & SMART Criteria](#14-kpi--smart-criteria)
- [15. คู่มือการทดสอบ (DevOps Validation Guide)](#15-คู่มือการทดสอบ-devops-validation-guide)
- [16. คู่มือการใช้งาน (DevOps Guide)](#16-คู่มือการใช้งาน-devops-guide)
- [17. คู่มือการบำรุงรักษา (Maintenance Guide)](#17-คู่มือการบำรุงรักษา-maintenance-guide)
- [18. คู่มือการขยาย/แก้ไข (Extension Guide)](#18-คู่มือการขยายแก้ไข-extension-guide)
- [19. Code Review & PR Checklist สำหรับ DevOps](#19-code-review--pr-checklist-สำหรับ-devops)
- [20. Root Cause Analysis (RCA)](#20-root-cause-analysis-rca)
- [21. ภาคผนวก: คำศัพท์สองภาษา และเอกสารอ้างอิง](#21-ภาคผนวก-คำศัพท์สองภาษา-และเอกสารอ้างอิง)

---

# 1. บทนำ (Introduction)

## 1.1 ภาพรวมคืออะไร (What is it?)

คู่มือนี้สำหรับ **DevOps Engineer**, **Platform Engineer**, **Site Reliability Engineer (SRE)** ในทีม **Financial & Accounting Technology Solutions** ที่รับผิดชอบ:

- ออกแบบและดูแล **CI/CD Pipeline**
- จัดการ **Infrastructure** (Docker, Kubernetes, Azure)
- ทำ **Observability** (Log, Metric, Trace, Alert)
- ดูแล **Security & Secrets Management**
- สนับสนุน **Incident Response** และ **Release Management**
- ทำให้ Deployment เร็ว ปลอดภัย และย้อนกลับได้

## 1.2 คำนำ (Preface)

ระบบ FinTech & Accounting ต้องการความเสถียรและความปลอดภัยสูง:

- **Downtime** กระทบการปิดบัญชีและการชำระเงินโดยตรง
- **ข้อมูลการเงิน** ต้องไม่สูญหายหรือซ้ำซ้อน
- **Compliance** เช่น SOX, PDPA, ISO 27001 ต้องมี Audit Trail
- **Integration** กับ Oracle ERP, Databricks, Power BI ต้องมี Monitoring ที่ดี
- **MTTR** ต้อง ≤ 30 นาทีสำหรับ SEV-1/2

DevOps ในที่นี้จึงไม่ใช่แค่ "คน Deploy" แต่ต้องเป็น **Platform Enabler** ที่ทำให้ทีม Dev/QA/PO ส่งมอบคุณค่าได้อย่างรวดเร็วและปลอดภัย

## 1.3 วัตถุประสงค์ (Objectives)

1. กำหนดมาตรฐาน CI/CD ของทีม FinTech & Accounting
2. ลด Change Failure Rate และ MTTR
3. ยกระดับ Observability ให้ตรวจจับปัญหาก่อนผู้ใช้รายงาน
4. สร้าง Infrastructure ที่ Scalable, Secure, Reproducible
5. ทำให้ Deployment เป็นเรื่องปกติ ไม่ใช่เหตุการณ์พิเศษ

## 1.4 เป้าหมาย (Goals)

- Deployment Frequency ≥ 2 ครั้ง/สัปดาห์
- Lead Time for Changes ≤ 3 วัน
- MTTR ≤ 30 นาที (SEV-1/2)
- Change Failure Rate < 15%
- System Uptime ≥ 99.9%
- Secrets Rotated ตามรอบ 100%

---

# 2. บทนิยาม (Definitions)

| คำ | ความหมาย |
|----|----------|
| **DevOps** | วัฒนธรรม + เครื่องมือที่รวม Dev และ Ops เพื่อส่งมอบเร็วและเสถียร |
| **SRE** | Site Reliability Engineer — วิศวกรที่ดูแลความน่าเชื่อถือของระบบ |
| **Platform Engineer** | วิศวกรที่สร้าง Internal Platform ให้ทีม Dev ใช้ |
| **CI (Continuous Integration)** | การรวมโค้ดบ่อยและตรวจสอบอัตโนมัติ |
| **CD (Continuous Delivery/Deployment)** | การส่งมอบ/Deploy อัตโนมัติ |
| **IaC (Infrastructure as Code)** | การจัดการ Infrastructure ผ่าน Code |
| **GitOps** | การใช้ Git เป็น Source of Truth สำหรับ Infrastructure |
| **Pipeline** | ลำดับขั้นตอนอัตโนมัติ (Lint → Test → Build → Deploy) |
| **Artifact** | ผลลัพธ์จากการ Build (Docker Image, Binary) |
| **Container** | แพ็กเกจที่รวม App + Dependency |
| **Orchestrator** | ระบบจัดการ Container (Kubernetes) |
| **Blue-Green Deployment** | Deploy สอง Environment แล้วสลับ |
| **Canary Deployment** | Deploy ให้ผู้ใช้บางส่วนก่อน |
| **Feature Flag** | สวิตช์เปิด/ปิดฟีเจอร์โดยไม่ต้อง Deploy |
| **Rollback** | การย้อนกลับ Version ก่อนหน้า |
| **Observability** | ความสามารถในการสังเกตระบบ (Log/Metric/Trace) |
| **SLO (Service Level Objective)** | เป้าหมายระดับบริการ |
| **SLI (Service Level Indicator)** | ตัววัดระดับบริการ |
| **SLA (Service Level Agreement)** | ข้อตกลงระดับบริการ |
| **Error Budget** | โควต้าความผิดพลาดที่ยอมรับได้ |
| **Runbook** | คู่มือแก้ไขเหตุการณ์ |
| **Post-mortem** | การวิเคราะห์หลังเกิด Incident |
| **Chaos Engineering** | การจงใจทำให้ระบบล่มเพื่อทดสอบ Resilience |
| **Secret** | ข้อมูลลับ (Password, Token, Key) |
| **SBOM** | Software Bill of Materials |

---

# 3. บทบาทและความรับผิดชอบ (Roles & Responsibilities)

## 3.1 Role Matrix

| กิจกรรม | DevOps | SRE | Platform | Dev | QA | Architect | PO/BA | Mgmt |
|---------|--------|-----|----------|-----|----|-----------|-------|------|
| CI/CD Pipeline | **R** | C | **R** | C | C | C | I | I |
| Infrastructure Design | **R** | C | **R** | I | I | **A** | I | I |
| Container Build | **R** | C | C | C | I | I | I | I |
| Kubernetes Manifest | **R** | C | **R** | C | I | C | I | I |
| Secrets Management | **R** | C | **R** | C | I | C | I | A |
| Observability Setup | **R** | **R** | C | C | C | C | I | I |
| Alerting Rules | C | **R** | C | C | I | C | I | I |
| Incident Response | **R** | **R** | C | C | I | C | I | A |
| Runbook | **R** | **R** | C | C | I | I | I | I |
| Performance Tuning | C | **R** | C | **R** | I | C | I | I |
| Security Scan | **R** | C | C | C | C | C | I | A |
| Release Approval | C | C | I | I | C | C | **R** | **A** |
| Cost Optimization | **R** | C | **R** | I | I | C | I | **A** |

**R** = Responsible | **A** = Accountable | **C** = Consulted | **I** = Informed

```bash
• RACI อ่านว่า เร-ซี่ (ออกเสียงคล้ายคำว่า "เรซซิ่ง" ที่ตัดเสียง "ง" ท้ายออก) หรือบางครั้งก็อ่านเรียงตัวว่า อาร์-เอ-ซี-ไอ


• R = Responsible อ่านว่า ริส-ปอน-ซิ-เบิล (แปลว่า ผู้รับผิดชอบลงมือทำ)
• A = Accountable อ่านว่า แอค-เคาน์-ทะ-เบิล (แปลว่า ผู้รับผิดชอบหลักและมีอำนาจตัดสินใจ)
• C = Consulted อ่านว่า คอน-ซัล-ทิด หรือ คอน-ซัล-เต็ด (แปลว่า ผู้ให้คำปรึกษา)
• I = Informed อ่านว่า อิน-ฟอร์มด์ (แปลว่า ผู้รับทราบข้อมูล)
คำย่อ RACI คือเครื่องมือบริหารโครงการที่ใช้กำหนดบทบาทและความรับผิดชอบของคนในทีมให้ชัดเจน 
• R = Responsible (ผู้รับผิดชอบลงมือทำ). คือคนที่ลงมือปฏิบัติงานนั้นให้สำเร็จตามที่ได้รับมอบหมาย ซึ่งใน 1 งานอาจมีผู้ลงมือทำหลายคนได้.
• A = Accountable (ผู้รับผิดชอบหลักและมีอำนาจตัดสินใจ). คือเจ้าของงานตัวจริงที่ต้องรับผิดชอบต่อผลลัพธ์สุดท้ายและเป็นคนอนุมัติงาน ซึ่งใน 1 งานควรมีเพียงคนเดียวเท่านั้นเพื่อไม่ให้เกิดความสับสน.
• C = Consulted (ผู้ให้คำปรึกษา). คือผู้เชี่ยวชาญหรือผู้เกี่ยวข้องที่ทีมต้องสอบถามข้อมูลและความคิดเห็นก่อนหรือระหว่างทำงาน.
• I = Informed (ผู้รับทราบข้อมูล). คือผู้ที่ต้องได้รับแจ้งอัปเดตความคืบหน้าหรือผลลัพธ์ของงาน แต่ไม่ได้มีส่วนร่วมในการลงมือทำหรือตัดสินใจโดยตรง

``` 

## 3.2 ความรับผิดชอบหลักของ DevOps Engineer

1. ออกแบบและดูแล CI/CD Pipeline
2. Build, Tag, Push Docker Image
3. Deploy ไปยัง Dev / Staging / Production
4. จัดการ Secrets (Azure Key Vault)
5. ตั้ง Observability (Log / Metric / Trace / Alert)
6. สนับสนุน Incident Response
7. ดูแล Rollback Procedure

## 3.3 ความรับผิดชอบหลักของ SRE

1. กำหนด SLO / SLI / Error Budget
2. ตั้ง Alert ที่มีสัญญาณรบกวนต่ำ (Low Noise)
3. ดูแล Capacity Planning
4. ทำ Performance Tuning
5. นำ Post-mortem
6. ทำ Chaos Engineering (ถ้าจำเป็น)

## 3.4 ความรับผิดชอบหลักของ Platform Engineer

1. สร้าง Internal Developer Platform
2. จัดทำ Self-service Tooling (Scaffold, Templates)
3. ดูแล Shared Infrastructure
4. ลด Cognitive Load ของทีม Dev
5. ทำ Golden Path สำหรับ Service ใหม่

## 3.5 ขอบเขตที่ DevOps ไม่ควรทำ

- ❌ Deploy Production โดยไม่มี Approval
- ❌ เก็บ Secrets ใน Git
- ❌ ฝัง Secrets ใน Docker Image
- ❌ เปิด SSH สาธารณะ
- ❌ ใช้ `latest` tag ใน Production
- ❌ ทำงาน Manual บน Production โดยไม่มี Audit

---

# 4. ความรู้พื้นฐานที่ต้องมี (Prerequisites)

| ด้าน | ความรู้ที่ต้องมี |
|------|------------------|
| Linux | Process, File System, Network, Permission |
| Networking | TCP/IP, DNS, TLS, Load Balancer, Firewall |
| Containers | Docker, Image, Registry, Multi-stage Build |
| Kubernetes | Pod, Deployment, Service, Ingress, ConfigMap, Secret, HPA |
| Cloud (Azure) | AKS, Key Vault, App Service, Monitor, Storage |
| CI/CD | GitHub Actions / GitLab CI, Pipeline as Code |
| IaC | Terraform / Bicep / Helm |
| GitOps | ArgoCD / Flux |
| Observability | Prometheus, Grafana, Loki, Tempo, OpenTelemetry |
| Security | OWASP, Trivy, Vault, RBAC, Network Policy |
| Scripting | Bash, Python, YAML |
| Business Domain | Finance/Accounting Workflow, ERP Integration |

---

# 5. โครงสร้างการทำงาน (Team Structure)

```text
┌─────────────────────────────────────────────────────────────┐
│                DEVOPS / PLATFORM STRUCTURE                  │
└─────────────────────────────────────────────────────────────┘

                    ┌──────────────┐
                    │  DevOps Lead │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │ CI/CD    │ │Infra/Ops │ │  SRE     │
        │ Engineer │ │ Engineer │ │          │
        └──────────┘ └──────────┘ └──────────┘
                           │
                           ▼
                 ┌─────────────────────┐
                 │  Dev / QA / PO Team │
                 └─────────────────────┘
```

## 5.1 การสื่อสาร

| กิจกรรม | ความถี่ | ผู้เข้าร่วม |
|---------|---------|------------|
| Daily Standup | ทุกวัน | DevOps, Dev, QA |
| Release Planning | 2 สัปดาห์/ครั้ง | DevOps, PO, QA |
| Change Advisory | ต่อ Release | DevOps, PO, Architect |
| Incident Review | ตามเหตุการณ์ | DevOps, SRE, On-call |
| Capacity Review | เดือน/ครั้ง | DevOps, SRE, Architect |
| Cost Review | ไตรมาส/ครั้ง | DevOps Lead, Mgmt |

## 5.2 Environment Matrix

| Environment | Branch | Deploy | Approval | DB |
|-------------|--------|--------|----------|-----|
| Development | `develop` | Auto | ❌ | Dev DB |
| Staging | `release/*` | Auto | ❌ | Staging DB |
| Production | `main` | Manual | ✅ 2 Approvers | Prod DB |
| Hotfix | `hotfix/*` | Fast-track | ✅ 1 Approver | Prod DB |

---

# 6. หลักการทำงาน (Concept)

## 6.1 หลักการ 7 ประการของ DevOps

1. **Automate Everything Repeatable** — ถ้าทำซ้ำได้ ต้อง Automate
2. **Infrastructure as Code** — ทุก Infra ต้องมาจาก Code
3. **Everything as Code** — Pipeline, Config, Alert, Runbook
4. **Immutable Infrastructure** — สร้างใหม่ ไม่แก้ของเดิม
5. **Shift-Left Security** — Scan ตั้งแต่ Commit
6. **Observable by Default** — Log/Metric/Trace ต้องมีทุก Service
7. **Fail Fast, Recover Faster** — ล้มเร็ว Detect เร็ว กู้คืนเร็ว

## 6.2 DORA Metrics

DORA (DevOps Research and Assessment) Metrics คือตัววัดประสิทธิภาพ DevOps 4 ตัว:

| Metric | ความหมาย | Elite Target |
|--------|----------|--------------|
| **Deployment Frequency** | ความถี่ Deploy | ≥ 1 ครั้ง/วัน |
| **Lead Time for Changes** | เวลาจาก Commit → Production | < 1 ชั่วโมง |
| **Change Failure Rate** | % Deploy ที่ทำให้เกิด Incident | < 5% |
| **MTTR** | เวลากู้คืนหลัง Incident | < 1 ชั่วโมง |

## 6.3 SRE Golden Signals

1. **Latency** — เวลาตอบสนอง
2. **Traffic** — ปริมาณ Request
3. **Errors** — อัตรา Error
4. **Saturation** — การใช้ Resource

## 6.4 The Three Ways of DevOps

| Way | หลักการ |
|-----|---------|
| **Flow** | เพิ่มความเร็วในการส่งมอบ (ลด WIP, Automate) |
| **Feedback** | รับ Feedback เร็ว (Monitoring, Testing) |
| **Continuous Learning** | เรียนรู้และปรับปรุง (Post-mortem, Kaizen) |

## 6.5 Error Budget

**SLO 99.9% = Error Budget 0.1%** ของเวลาในเดือน

- ถ้าใช้ Error Budget หมด → หยุด Feature ใหม่, เน้น Reliability
- ถ้า Error Budget เหลือเยอะ → กล้า Release Feature ใหม่ได้

## 6.6 Trade-off Framework

| มิติ | คำถาม |
|------|--------|
| **Speed** | ส่งมอบเร็วพอหรือไม่? |
| **Reliability** | เสถียรพอหรือไม่? |
| **Cost** | ค่าใช้จ่ายสมเหตุสมผลหรือไม่? |
| **Security** | ปลอดภัยพอหรือไม่? |

**Rule of Thumb:**

> ทำให้เร็วและปลอดภัย — ถ้าต้องเลือก ให้เลือกความปลอดภัยของข้อมูลการเงินก่อน

---

# 7. Workflow และ Dataflow

## 7.1 CI/CD Workflow หลัก

```text
┌──────────────────────────────────────────────────────────────┐
│                  CI/CD WORKFLOW                              │
└──────────────────────────────────────────────────────────────┘

  Git Push
     │
     ▼
┌─────────────────────────────────────────┐
│  CI PHASE                               │
│  1. Detect Changes                      │
│  2. Lint (ESLint, Ruff, Prettier)      │
│  3. Type Check (TS, MyPy)              │
│  4. Unit Test                           │
│  5. Integration Test                    │
│  6. Coverage Check (≥ 80%)              │
│  7. Security Scan (Trivy, Snyk)         │
│  8. Build Docker Image                  │
│  9. Push to Registry                    │
│ 10. Generate SBOM                       │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  CD PHASE                               │
│  Dev:      Auto Deploy                  │
│  Staging:  Auto Deploy                  │
│  Prod:     Manual + Approval + Blue-Green│
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  POST-DEPLOY                            │
│  1. Health Check                        │
│  2. Smoke Test                          │
│  3. Monitor Metric                      │
│  4. Alert Readiness                     │
│  5. Rollback Ready                      │
└─────────────────────────────────────────┘
```

## 7.2 Dataflow: Deployment

```text
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│ Git Push │──▶│ CI Build │──▶│ Registry │──▶│ K8s      │
│          │   │          │   │          │   │ Cluster  │
└──────────┘   └──────────┘   └──────────┘   └────┬─────┘
                                                    │
                                                    ▼
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│ Alert    │◀──│ Monitor  │◀──│ Log      │◀──│ Pods     │
│          │   │ Metric   │   │ Trace    │   │ Running  │
└──────────┘   └──────────┘   └──────────┘   └──────────┘
```

## 7.3 Incident Response Workflow

```text
Alert
  │
  ▼
Triage (Severity)
  │
  ▼
Notify (Stakeholder)
  │
  ▼
Mitigate (Rollback / Restart / Scale)
  │
  ▼
Resolve (Root Cause Fix)
  │
  ▼
RCA
  │
  ▼
Preventive Action
```

## 7.4 Release Timeline

| Day | Activity | Owner |
|-----|----------|-------|
| D-5 | Code Freeze | PO |
| D-4 | Build Release Branch | Dev |
| D-3 | Deploy Staging | DevOps |
| D-2 | QA Full Regression | QA |
| D-1 | UAT Sign-off | PO / Key User |
| D-0 | Deploy Production | DevOps |
| D+1 | Post-Release Monitor | DevOps / SRE |

---

# 8. CI/CD Pipeline Standards

## 8.1 Pipeline Stages

| Stage | เครื่องมือ | Target |
|-------|-----------|--------|
| Lint | ESLint, Ruff, Prettier | 0 Error |
| Type Check | TypeScript, MyPy | 0 Error |
| Unit Test | Vitest, pytest | Coverage ≥ 80% |
| Integration Test | httpx, Supertest | Critical Paths |
| Security Scan | Trivy, Snyk, Gitleaks | 0 Critical/High |
| Build | Docker Buildx | Multi-stage, Non-root |
| Push | Registry (ACR / GHCR) | Tagged with SHA |
| SBOM | Syft | Generated |
| Deploy | ArgoCD / kubectl | ตาม Environment |

## 8.2 GitHub Actions Workflow ตัวอย่าง

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop, 'release/**']
  pull_request:
    branches: [main, develop]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install deps
        run: pip install -r requirements.txt

      - name: Lint
        run: ruff check .

      - name: Type check
        run: mypy pkg/

      - name: Unit Test
        run: pytest --cov=pkg --cov-fail-under=80 --cov-report=xml

      - name: Upload Coverage
        uses: codecov/codecov-action@v4
        with:
          files: ./coverage.xml

      - name: Security scan
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'

      - name: Secret scan
        uses: gitleaks/gitleaks-action@v2

  build:
    needs: ci
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4

      - uses: docker/setup-buildx-action@v3

      - uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=sha,prefix=
            type=ref,event=branch
            type=semver,pattern={{version}}

      - uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  deploy-dev:
    needs: build
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    environment: development
    steps:
      - name: Deploy to Dev
        run: |
          kubectl set image deployment/pms-api \
            pms-api=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
            -n dev
          kubectl rollout status deployment/pms-api -n dev --timeout=5m

  deploy-staging:
    needs: build
    if: startsWith(github.ref, 'refs/heads/release/')
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - name: Deploy to Staging
        run: |
          kubectl set image deployment/pms-api \
            pms-api=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
            -n staging
          kubectl rollout status deployment/pms-api -n staging --timeout=10m

  deploy-prod:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment:
      name: production
    steps:
      - uses: actions/checkout@v4

      - name: Blue-Green Deploy
        run: ./scripts/deploy-blue-green.sh \
          ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}

      - name: Smoke Test
        run: ./scripts/smoke-test.sh production

      - name: Monitor Window
        run: ./scripts/monitor-5min.sh production
```

## 8.3 Branch-to-Environment Mapping

| Branch | Environment | Auto Deploy | Approval |
|--------|-------------|-------------|----------|
| `feature/*` | None (CI only) | ❌ | — |
| `develop` | Development | ✅ | ❌ |
| `release/*` | Staging | ✅ | ❌ |
| `main` | Production | ⚠️ Manual | ✅ 2 Approvers |
| `hotfix/*` | Staging → Prod | ⚠️ Fast-track | ✅ 1 Approver |

## 8.4 Pipeline Optimization

- **Caching**: Cache Dependencies (pip, npm, Docker layer)
- **Parallel Jobs**: รัน Job ที่ไม่ขึ้นต่อกันพร้อมกัน
- **Path Filter**: รันเฉพาะที่เปลี่ยน (paths-filter)
- **Matrix Strategy**: Test หลาย Version พร้อมกัน
- **Reusable Workflows**: ลด Duplication

## 8.5 CI/CD Checklist

- [ ] Pipeline ทุก Stage ผ่าน
- [ ] Coverage ≥ 80%
- [ ] Security Scan ผ่าน (0 Critical/High)
- [ ] Secret Scan ผ่าน
- [ ] Image Tagged ด้วย SHA
- [ ] SBOM Generated
- [ ] Smoke Test ผ่าน
- [ ] Rollback Ready
- [ ] Approval ครบ (Prod)
- [ ] Audit Log เก็บครบ

---

# 9. Infrastructure Standards

## 9.1 Container Standards

### 9.1.1 Dockerfile Best Practices

```dockerfile
# Multi-stage build
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.11-slim
RUN useradd -m -u 1000 app
WORKDIR /app
COPY --from=builder /root/.local /home/app/.local
COPY --chown=app:app . .

USER app
ENV PATH=/home/app/.local/bin:$PATH
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Checklist:**

- [ ] Multi-stage build
- [ ] Non-root user
- [ ] ไม่มี Secret ใน Image
- [ ] Base Image เป็น Distroless หรือ Slim
- [ ] Healthcheck
- [ ] ไม่มี `latest` tag ใน Production
- [ ] Pin Version ของ Base Image

### 9.1.2 Image Tagging Strategy

| Tag | ใช้เมื่อ |
|-----|----------|
| `<sha>` | ทุก Build (Immutable) |
| `<branch>` | Dev / Staging |
| `v<semver>` | Release |
| `latest` | ห้ามใช้ใน Production |

## 9.2 Kubernetes Standards

### 9.2.1 Manifest ตัวอย่าง

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pms-api
  labels:
    app: pms-api
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: pms-api
  template:
    metadata:
      labels:
        app: pms-api
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
      containers:
        - name: pms-api
          image: ghcr.io/org/pms-api:abc123
          ports:
            - containerPort: 8000
          resources:
            requests:
              cpu: 100m
              memory: 256Mi
            limits:
              cpu: 500m
              memory: 512Mi
          livenessProbe:
            httpGet:
              path: /health
              port: 8000
            initialDelaySeconds: 10
            periodSeconds: 30
          readinessProbe:
            httpGet:
              path: /ready
              port: 8000
            initialDelaySeconds: 5
            periodSeconds: 10
          envFrom:
            - configMapRef:
                name: pms-api-config
            - secretRef:
                name: pms-api-secrets
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            capabilities:
              drop: ["ALL"]
```

### 9.2.2 Kubernetes Checklist

- [ ] Resource Requests / Limits
- [ ] Liveness / Readiness Probes
- [ ] Non-root user
- [ ] Read-only Root Filesystem
- [ ] ไม่มี HostPath
- [ ] ไม่มี Secret ใน Manifest
- [ ] Horizontal Pod Autoscaler (HPA) ถ้าจำเป็น
- [ ] Pod Disruption Budget (PDB) สำหรับ Prod
- [ ] Network Policy
- [ ] Multi-replica (≥ 2) สำหรับ Prod

## 9.3 Infrastructure as Code

### 9.3.1 Terraform / Bicep Structure

```text
infra/
├── modules/
│   ├── aks/
│   ├── postgres/
│   ├── keyvault/
│   └── monitor/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
└── README.md
```

**Checklist:**

- [ ] State เก็บ Remote (Azure Storage / S3)
- [ ] State Lock
- [ ] Plan ก่อน Apply
- [ ] Code Review ทุก PR
- [ ] Tag Resources
- [ ] Version Pinned

### 9.3.2 GitOps

- ใช้ **ArgoCD** หรือ **Flux** เป็น Source of Truth
- Manifest เก็บใน Git
- PR = Change Request
- Approval = Merge + ArgoCD Sync
- Rollback = Revert Git

## 9.4 Infrastructure Checklist

- [ ] Docker Image (Multi-stage, Non-root)
- [ ] Kubernetes Manifest (Resource Limits, Probes)
- [ ] Secrets Management (Azure Key Vault)
- [ ] TLS/HTTPS ครบ
- [ ] SSO/RBAC
- [ ] Backup & Restore Procedure
- [ ] Disaster Recovery Plan
- [ ] Network Policy
- [ ] Cost Tags
- [ ] IaC Versioned

---

# 10. Observability Standards

## 10.1 Observability Stack

| ชั้น | เครื่องมือ | ใช้ทำอะไร |
|------|-----------|-----------|
| Log | Loki / ELK | Structured Logging |
| Metric | Prometheus + Grafana | Performance Monitoring |
| Trace | Tempo / Jaeger | Distributed Tracing |
| Alert | Alertmanager + Slack | Incident Alerting |
| Dashboard | Grafana | Visualization |

## 10.2 Structured Logging

```python
# ตัวอย่าง Structured Log
import logging
import json
import sys

logger = logging.getLogger("pms")
handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(json.JSONFormatter())
logger.addHandler(handler)
logger.setLevel(logging.INFO)

logger.info("payment_synced", extra={
    "payment_id": "abc-123",
    "erp_reference": "ERP-456",
    "correlation_id": "c7b8a9d0",
    "latency_ms": 245,
    "user_id": "u-789",
})
```

**ข้อกำหนด:**

- Format: JSON
- Fields บังคับ: `timestamp`, `level`, `service`, `correlation_id`, `message`
- ห้าม Log PII / Secrets
- Log Level: DEBUG (Dev), INFO (Prod), WARN, ERROR

## 10.3 Prometheus Metrics

```python
# ตัวอย่าง Metric
from prometheus_client import Counter, Histogram

http_requests_total = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["method", "path", "status"],
)

http_request_duration_seconds = Histogram(
    "http_request_duration_seconds",
    "HTTP request duration",
    ["method", "path"],
)
```

**Metrics ที่ควรมี:**

- `http_requests_total{method,path,status}`
- `http_request_duration_seconds{method,path}`
- `db_query_duration_seconds{query}`
- `external_api_duration_seconds{service}`
- `queue_depth{queue}`
- `error_total{type}`

## 10.4 Alerting Rules ตัวอย่าง

```yaml
# prometheus/rules.yml
groups:
  - name: pms-api
    rules:
      - alert: HighErrorRate
        expr: |
          rate(http_requests_total{status=~"5.."}[5m])
          /
          rate(http_requests_total[5m])
          > 0.01
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Error rate > 1% on {{ $labels.instance }}"
          runbook: "https://wiki/runbook/high-error-rate"

      - alert: HighLatency
        expr: |
          histogram_quantile(0.95,
            rate(http_request_duration_seconds_bucket[5m])
          ) > 1
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "p95 latency > 1s"

      - alert: PodCrashLooping
        expr: rate(kube_pod_container_status_restarts_total[15m]) > 0
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Pod {{ $labels.pod }} is crash looping"

      - alert: DiskSpaceLow
        expr: node_filesystem_avail_bytes / node_filesystem_size_bytes < 0.15
        for: 10m
        labels:
          severity: warning
```

## 10.5 Alert Quality

**Alert ที่ดี:**

- มี **Symptom** ไม่ใช่ **Cause** (Alert เมื่อผู้ใช้กระทบ)
- มี **Runbook**
- มี **Severity**
- มี **Owner**
- **Low Noise** — ไม่แจ้งเตือนซ้ำ

**Alert ที่ไม่ดี:**

- Alert ทุก Metric
- Alert ที่ไม่มี Action
- Alert ที่ Trigger บ่อยเกินไป

## 10.6 SLO / SLI

| SLI | SLO | Error Budget |
|-----|-----|--------------|
| Availability | 99.9% | 0.1% (43 นาที/เดือน) |
| Latency p95 | ≤ 500ms | — |
| Error Rate | ≤ 0.1% | — |
| Sync Success Rate | ≥ 99% | 1% |

## 10.7 Dashboard แนะนำ

- **RED Dashboard** (Rate, Error, Duration)
- **USE Dashboard** (Utilization, Saturation, Errors)
- **Business Dashboard** (ยอด Payment, Sync Rate)
- **SLO Dashboard** (Error Budget)

## 10.8 Observability Checklist

- [ ] Structured Log (JSON)
- [ ] Correlation ID ทุก Request
- [ ] Metrics หลัก (RED / USE)
- [ ] Alert มี Runbook
- [ ] Dashboard ครบ
- [ ] Trace เปิดใช้งาน
- [ ] Log ไม่มี PII / Secrets
- [ ] Retention ตามนโยบาย
- [ ] SLO กำหนดชัดเจน
- [ ] Error Budget ติดตาม

---

# 11. Security & Secrets Management

## 11.1 Secrets Management

**ข้อห้าม:**

- ❌ Hardcode Secrets ในโค้ด
- ❌ Commit `.env` ลง Git
- ❌ ฝัง Secrets ใน Docker Image
- ❌ Log Secrets
- ❌ แชร์ Secrets ทางแชท

**วิธีที่ถูกต้อง:**

- ✅ ใช้ **Azure Key Vault** / HashiCorp Vault
- ✅ ใช้ **GitHub Secrets** สำหรับ CI/CD
- ✅ ใช้ **K8s Secrets + External Secrets Operator**
- ✅ Rotate Secrets เป็นประจำ
- ✅ Principle of Least Privilege

## 11.2 External Secrets Operator

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: pms-api-secrets
  namespace: production
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: azure-keyvault
    kind: ClusterSecretStore
  target:
    name: pms-api-secrets
  data:
    - secretKey: DATABASE_URL
      remoteRef:
        key: pms-database-url
    - secretKey: ERP_TOKEN
      remoteRef:
        key: pms-erp-token
```

## 11.3 Secret Rotation

| Secret Type | Rotation Cycle |
|-------------|----------------|
| API Key | 90 วัน |
| DB Password | 90 วัน |
| TLS Certificate | ตาม CA (≤ 1 ปี) |
| Service Account | 180 วัน |

## 11.4 Supply Chain Security

- **SBOM** — Generate ทุก Build
- **Image Scan** — Trivy / Snyk
- **Dependency Scan** — Dependabot / Renovate
- **Signed Images** — Cosign / Notary
- **Verify Signatures** — ก่อน Deploy

## 11.5 Container Security

- Non-root user
- Read-only Root Filesystem
- Drop Capabilities
- ไม่มี Privileged
- Network Policy
- Pod Security Standards (Restricted)

## 11.6 Network Security

- Network Policy (Default Deny)
- TLS 1.2+ (mTLS ถ้าจำเป็น)
- WAF / Rate Limit
- Private Endpoint สำหรับ Database

## 11.7 Security Checklist

- [ ] Secrets ใน Key Vault
- [ ] ไม่มี Secret ใน Git / Image / Log
- [ ] Secret Rotation Plan
- [ ] SBOM ทุก Build
- [ ] Image Scan ผ่าน
- [ ] Image Signed + Verified
- [ ] Non-root Container
- [ ] Network Policy
- [ ] RBAC Least Privilege
- [ ] Audit Log เปิดใช้งาน
- [ ] TLS ครบ
- [ ] Backup Encrypted

---

# 12. Deployment Strategies

## 12.1 Strategy Matrix

| Strategy | ใช้เมื่อ | ข้อดี | ข้อเสีย |
|----------|---------|-------|---------|
| **Recreate** | Dev / ไม่สำคัญ | ง่าย | Downtime |
| **Rolling** | ทั่วไป | ไม่ Downtime | Rollback ช้า |
| **Blue-Green** | Prod สำคัญ | Rollback ทันที | ต้องมี 2x Resource |
| **Canary** | Prod เสี่ยงสูง | ลด Blast Radius | ซับซ้อน |
| **Feature Flag** | ฟีเจอร์ใหม่ | ปิดได้ทันที | ต้องดูแล Flag |

## 12.2 Blue-Green Deployment

```bash
#!/bin/bash
# scripts/deploy-blue-green.sh

NEW_TAG=$1
CURRENT=$(kubectl get service pms-api -n production \
  -o jsonpath='{.spec.selector.version}')

if [ "$CURRENT" == "blue" ]; then
  TARGET=green
else
  TARGET=blue
fi

echo "Deploying to $TARGET (current: $CURRENT)"

# Deploy to inactive environment
kubectl set image deployment/pms-api-$TARGET \
  pms-api=$NEW_TAG -n production

kubectl rollout status deployment/pms-api-$TARGET \
  -n production --timeout=10m

# Smoke test
./scripts/smoke-test.sh pms-api-$TARGET

# Switch traffic
kubectl patch service pms-api -n production \
  --type='json' \
  -p="[{\"op\": \"replace\", \"path\": \"/spec/selector/version\", \"value\": \"$TARGET\"}]"

echo "Switched traffic to $TARGET"

# Monitor for 5 minutes
./scripts/monitor-5min.sh production

if [ $? -ne 0 ]; then
  echo "Rollback!"
  kubectl patch service pms-api -n production \
    --type='json' \
    -p="[{\"op\": \"replace\", \"path\": \"/spec/selector/version\", \"value\": \"$CURRENT\"}]"
  exit 1
fi

echo "Deployment successful"
```

## 12.3 Canary Deployment

```yaml
# Argo Rollouts
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: pms-api
spec:
  replicas: 10
  strategy:
    canary:
      steps:
        - setWeight: 10
        - pause: { duration: 5m }
        - setWeight: 30
        - pause: { duration: 5m }
        - setWeight: 50
        - pause: { duration: 5m }
        - setWeight: 100
      analysis:
        templates:
          - templateName: success-rate
        startingStep: 1
        args:
          - name: service-name
            value: pms-api
```

## 12.4 Rollback

```bash
# Kubernetes Rollback
kubectl rollout undo deployment/pms-api -n production
kubectl rollout status deployment/pms-api -n production

# Blue-Green Rollback
kubectl patch service pms-api -n production \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/selector/version", "value": "blue"}]'

# Database Rollback (ถ้าจำเป็น)
./scripts/database-rollback.sh production <backup-id>
```

## 12.5 Rollback Decision Matrix

| Severity | อาการ | กลยุทธ์ | ผู้อนุมัติ | เวลา |
|----------|-------|---------|-----------|------|
| Critical | ระบบล่ม / >50% Error | Blue-Green Switch | Post-facto | < 1 นาที |
| High | >10% Error | K8s Rollback | DevOps Lead | 5–10 นาที |
| Medium | <10% Error | Redeploy Previous | Team Lead | 15–30 นาที |
| Low | Minor | Schedule Fix | PO | Next Deploy |

## 12.6 Deployment Checklist

- [ ] Build ผ่าน CI
- [ ] Image Tagged
- [ ] SBOM Generated
- [ ] Security Scan ผ่าน
- [ ] Approval ครบ (Prod)
- [ ] Backup Database (ถ้ามี Migration)
- [ ] Rollback Plan พร้อม
- [ ] Smoke Test พร้อม
- [ ] Monitor Dashboard เปิด
- [ ] Stakeholder แจ้งแล้ว

---

# 13. Case Study

## Case Study 1: Payment Reconciliation — CI/CD Setup

### 13.1.1 Scope

- Pipeline สำหรับ P2R Service
- Deploy ไป Dev / Staging / Prod
- Observability ครบ

### 13.1.2 Pipeline Design

```text
┌──────────────────────────────────────────────────────────┐
│              P2R PIPELINE                                │
└──────────────────────────────────────────────────────────┘

Build Stage:
- Lint + Type Check (5 นาที)
- Unit Test + Coverage (3 นาที)
- Integration Test (5 นาที)
- Security Scan (2 นาที)
- Docker Build + Push (3 นาที)

Total CI: ~18 นาที

Deploy:
- Dev: Auto (< 2 นาที)
- Staging: Auto (< 3 นาที)
- Prod: Manual Approval + Blue-Green (< 10 นาที)
```

### 13.1.3 Observability Setup

| Layer | Implementation |
|-------|----------------|
| Log | Structured JSON → Loki |
| Metric | Prometheus → Grafana |
| Trace | OpenTelemetry → Tempo |
| Alert | Alertmanager → Slack |

### 13.1.4 SLO

| SLI | SLO |
|-----|-----|
| Availability | 99.9% |
| Reconciliation Latency p95 | ≤ 3s |
| Import Success Rate | ≥ 99.5% |
| ERP Sync Success Rate | ≥ 99% |

### 13.1.5 KPI

| KPI | Target |
|-----|--------|
| Deployment Frequency | ≥ 2/สัปดาห์ |
| Lead Time for Changes | ≤ 3 วัน |
| Change Failure Rate | < 10% |
| MTTR | ≤ 30 นาที |

---

## Case Study 2: Oracle ERP Integration — Reliability

### 13.2.1 Architecture

```text
PMS API → Outbox Table → Queue → Worker → Oracle ERP Client
                                                  │
                                                  ▼
                                        Reconciler (Daily)
```

### 13.2.2 Reliability Measures

- **Outbox Pattern** — Transactional + Reliable
- **Idempotency-Key** — ป้องกันซ้ำ
- **Retry with Backoff** — 3 ครั้ง, 2–10s
- **Circuit Breaker** — ป้องกัน Cascade Failure
- **Dead Letter Queue** — Message ที่ล้มเหลว
- **Daily Reconciliation** — จับ Mismatch

### 13.2.3 Observability

- Metric: `erp_sync_success_total`, `erp_sync_failure_total`, `erp_sync_duration_seconds`
- Alert: Sync Failure Rate > 1% (Warning), > 5% (Critical)
- Alert: Reconciliation Mismatch > 0.5%

### 13.2.4 Runbook (Sync ล้มเหลว)

```markdown
# Runbook: ERP Sync Failure

## Symptoms
- Alert: erp_sync_failure_rate > 5%
- Dashboard: Sync Success Rate < 95%

## Triage
1. ตรวจ ERP Status Page
2. ตรวจ Network Connectivity
3. ตรวจ Token Expiration

## Mitigation
1. ถ้า ERP ล่ม → รอ + Monitor
2. ถ้า Token หมดอายุ → Rotate + Retry
3. ถ้า Network → ตรวจ Firewall / DNS

## Verification
- Sync Success Rate ≥ 99%
- Reconciliation Mismatch = 0

## Escalation
- L1: On-call DevOps
- L2: Integration Lead
- L3: ERP Admin
```

### 13.2.5 KPI

| KPI | Target |
|-----|--------|
| Sync Success Rate | ≥ 99% |
| Duplicate Rate | 0% |
| MTTR | ≤ 15 นาที |

---

## Case Study 3: Multi-Environment Deployment

### 13.3.1 Environment Strategy

| Env | Purpose | Data | Auto Deploy |
|-----|---------|------|-------------|
| Dev | Dev Testing | Synthetic | ✅ |
| Staging | UAT + QA | Anonymized Prod | ✅ |
| Prod | Production | Real | ⚠️ Manual |

### 13.3.2 Cost Optimization

- **Dev**: Auto-shutdown off-hours
- **Staging**: Auto-scale ตาม demand
- **Prod**: Reserved Instance + Autoscaling

### 13.3.3 Governance

- Promotion ต้องผ่าน Gate (Test + Approval)
- Secrets แยกตาม Environment
- Audit Log ทุก Deploy
- Backup ก่อน Migration

---

# 14. KPI & SMART Criteria

## 14.1 KPI หลักของ DevOps

| KPI | เป้าหมาย | วิธีวัด |
|-----|----------|---------|
| **Deployment Frequency** | ≥ 2 ครั้ง/สัปดาห์ | CI/CD Log |
| **Lead Time for Changes** | ≤ 3 วัน | Commit → Production |
| **Change Failure Rate** | < 15% | Failed Deploys / Total |
| **MTTR** | ≤ 30 นาที | Incident Log |
| **System Uptime** | ≥ 99.9% | Monitoring |
| **Pipeline Success Rate** | ≥ 95% | CI Report |
| **Pipeline Duration** | ≤ 20 นาที | CI Report |
| **Secrets Rotated** | 100% | Vault Audit |
| **Critical Vulnerabilities** | 0 | Security Scan |

## 14.2 KPI หลักของ SRE

| KPI | เป้าหมาย | วิธีวัด |
|-----|----------|---------|
| SLO Compliance | ≥ 99.9% | Monitoring |
| Error Budget Consumption | ≤ 100% | SLO Dashboard |
| Alert Noise Rate | < 10% | Alert Log |
| MTTR (SEV-1) | ≤ 30 นาที | Incident Log |
| Post-mortem Completion | 100% ≤ 48 ชม. | RCA Tracker |

## 14.3 SMART ตัวอย่าง

| SMART | รายละเอียด |
|-------|-----------|
| **S** | ลด Pipeline Duration ของ P2R Service |
| **M** | จาก 25 นาที → ≤ 15 นาที |
| **A** | เพิ่ม Caching + Parallel Jobs |
| **R** | ทำให้ Dev ได้ Feedback เร็วขึ้น |
| **T** | ภายใน Sprint ถัดไป |

---

# 15. คู่มือการทดสอบ (DevOps Validation Guide)

## 15.1 Pipeline Testing

| Test | วิธี |
|------|------|
| Lint | รันบน Local ก่อน Push |
| Pipeline Dry-run | ใช้ `act` หรือ Branch Test |
| Reusable Workflow | Test บน Branch ก่อน Merge |
| Rollback Test | ทดสอบ Rollback บน Staging |

## 15.2 Infrastructure Testing

| Test | วิธี |
|------|------|
| Terraform Plan | Review Plan ก่อน Apply |
| K8s Manifest Validation | `kubectl --dry-run=server` |
| Policy Check | OPA / Kyverno |
| Cost Estimation | Infracost |

## 15.3 Security Testing

| Test | เครื่องมือ | ความถี่ |
|------|-----------|---------|
| SAST | SonarQube / Semgrep | ทุก PR |
| DAST | OWASP ZAP | ทุก Release |
| Container Scan | Trivy | ทุก Build |
| Dependency Scan | Snyk / Dependabot | รายวัน |
| Secret Scan | Gitleaks | ทุก Commit |

## 15.4 Chaos Testing

| Test | วิธี |
|------|------|
| Pod Kill | `kubectl delete pod` |
| Network Delay | Chaos Mesh |
| CPU Stress | Stress-ng |
| DB Failover | Switch Primary/Replica |

**ทำเมื่อ:** ก่อน Release ใหญ่ หรือทุกไตรมาส

## 15.5 DR Testing

- **Frequency:** ทุกไตรมาส
- **Scope:** Restore Database + Deploy Service
- **Metric:** RTO ≤ 1 ชั่วโมง, RPO ≤ 15 นาที
- **Evidence:** Screenshot + Log

## 15.6 Validation Checklist

- [ ] Pipeline Dry-run ผ่าน
- [ ] Infra Plan Reviewed
- [ ] Security Scan ผ่าน
- [ ] Chaos Test ผ่าน (ถ้าจำเป็น)
- [ ] DR Drill ผ่าน
- [ ] Rollback Tested
- [ ] Monitoring ครบ
- [ ] Alert Tested

---

# 16. คู่มือการใช้งาน (DevOps Guide)

## 16.1 Daily Workflow ของ DevOps

```text
เช้า:
1. ตรวจ Pipeline Status
2. ตรวจ Alert ที่ค้างคืน
3. ตรวจ Resource Usage

ระหว่างวัน:
4. Review PR ที่เกี่ยวกับ Infra
5. Deploy Staging / Prod (ตาม Schedule)
6. แก้ Incident (ถ้ามี)

เย็น:
7. ตรวจ Cost Dashboard
8. อัปเดต Runbook
9. เตรียม Release ถัดไป
```

## 16.2 การ Deploy ไป Staging

```bash
# 1. Merge เข้า release branch
git checkout release/v1.2.0
git pull
git merge develop

# 2. Push
git push origin release/v1.2.0

# 3. Pipeline จะ Auto Deploy

# 4. ตรวจ Status
kubectl rollout status deployment/pms-api -n staging

# 5. Smoke Test
./scripts/smoke-test.sh staging
```

## 16.3 การ Deploy ไป Production

```bash
# 1. Merge เข้า main
git checkout main
git pull
git merge release/v1.2.0
git tag v1.2.0
git push origin main --tags

# 2. Pipeline จะรอ Approval

# 3. Approve ใน GitHub / UI

# 4. Monitor
kubectl rollout status deployment/pms-api-blue -n production
./scripts/smoke-test.sh production
./scripts/monitor-5min.sh production
```

## 16.4 การ Rollback

```bash
# K8s Rollback
kubectl rollout undo deployment/pms-api -n production

# Blue-Green Rollback
kubectl patch service pms-api -n production \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/selector/version", "value": "blue"}]'

# Database Rollback (ถ้าจำเป็น)
./scripts/database-rollback.sh production <backup-id>
```

## 16.5 การ Rotate Secret

```bash
# 1. Update Secret ใน Azure Key Vault
az keyvault secret set \
  --vault-name pms-vault \
  --name pms-erp-token \
  --value <new-token>

# 2. External Secrets Operator จะ Sync อัตโนมัติ (≤ 1 ชม.)

# 3. Force Sync (ถ้าจำเป็น)
kubectl annotate externalsecret pms-api-secrets \
  -n production force-sync="$(date +%s)" --overwrite

# 4. Restart Pod (ถ้าจำเป็น)
kubectl rollout restart deployment/pms-api -n production
```

## 16.6 Daily Checklist

- [ ] Pipeline ทุก Branch ผ่าน
- [ ] Alert ไม่ค้าง
- [ ] Resource Usage ปกติ
- [ ] Cost ตาม Budget
- [ ] Secrets ยังไม่หมดอายุ
- [ ] Backup สำเร็จ
- [ ] Certificate ยังไม่หมดอายุ

---

# 17. คู่มือการบำรุงรักษา (Maintenance Guide)

## 17.1 Routine Maintenance

| งาน | ความถี่ | Owner |
|-----|---------|-------|
| Dependency Update | สัปดาห์ | DevOps |
| Base Image Update | เดือน | DevOps |
| K8s Version Upgrade | ไตรมาส | DevOps / SRE |
| Certificate Renewal | ตามอายุ | DevOps |
| Secret Rotation | ตามรอบ | DevOps |
| DR Drill | ไตรมาส | SRE |
| Cost Review | ไตรมาส | DevOps Lead |
| Backup Verification | เดือน | DevOps |

## 17.2 Backup & Restore

**Backup:**

- Database: Daily Full + Hourly Incremental
- Retention: 30 วัน
- Storage: Encrypted, Cross-region
- Verify: Weekly Restore Test

**Restore:**

- RTO: ≤ 1 ชั่วโมง
- RPO: ≤ 15 นาที
- Procedure: Documented ใน Runbook

## 17.3 Capacity Planning

- ตรวจ Resource Usage ทุกเดือน
- คาดการณ์ Growth ตาม Business
- วางแผน Scale ล่วงหน้า 3 เดือน
- ใช้ HPA / Cluster Autoscaler

## 17.4 Documentation Maintenance

| เอกสาร | Owner | Review Cycle |
|--------|-------|--------------|
| Runbook | DevOps / SRE | ไตรมาส |
| Architecture Diagram | Architect | ไตรมาส |
| Pipeline Config | DevOps | ต่อ Release |
| Alert Rules | SRE | เดือน |
| DR Plan | SRE | ไตรมาส |
| Onboarding Guide | DevOps Lead | ไตรมาส |

## 17.5 Runbook Template

```markdown
# Runbook: [Incident Name]

## Symptoms
[อาการ]

## Impact
[ผลกระทบ]

## Triage
1. [ขั้นตอน]
2. [ขั้นตอน]

## Mitigation
1. [ขั้นตอน]
2. [ขั้นตอน]

## Verification
- [ ] Metric กลับปกติ
- [ ] Alert หยุด
- [ ] Smoke Test ผ่าน

## Rollback
[ขั้นตอน Rollback]

## Escalation
- L1: [ชื่อ/ช่องทาง]
- L2: [ชื่อ/ช่องทาง]
- L3: [ชื่อ/ช่องทาง]

## Post-Incident
- [ ] RCA
- [ ] Preventive Action
- [ ] Runbook Update
```

---

# 18. คู่มือการขยาย/แก้ไข (Extension Guide)

## 18.1 การเพิ่ม Service ใหม่

1. สร้าง Dockerfile ตาม Standard
2. สร้าง K8s Manifest (Deployment, Service, HPA)
3. สร้าง Pipeline
4. ตั้ง Observability (Log/Metric/Trace)
5. ตั้ง Alert
6. เขียน Runbook
7. Deploy Dev → Staging → Prod

## 18.2 การเพิ่ม Environment ใหม่

1. สร้าง Namespace
2. สร้าง ConfigMap / Secret
3. สร้าง Pipeline Stage
4. ตั้ง Access Control
5. ตั้ง Monitoring
6. ทดสอบ Deploy

## 18.3 การเพิ่ม Integration ใหม่

- ระบุ Protocol / Auth
- ตั้ง Timeout / Retry
- ตั้ง Circuit Breaker
- ตั้ง Monitoring
- ตั้ง Alert
- เขียน Runbook

## 18.4 Governance

- การเพิ่ม Service ต้องผ่าน Architect
- การเปลี่ยน Pipeline ต้องผ่าน DevOps Lead
- การเปลี่ยน Security ต้องผ่าน Security Review
- การเปลี่ยน Infra ต้องผ่าน IaC + Review
- การเปลี่ยน Alert ต้องผ่าน SRE

---

# 19. Code Review & PR Checklist สำหรับ DevOps

## 19.1 DevOps PR Checklist

- [ ] Dockerfile ตาม Standard
- [ ] Multi-stage, Non-root
- [ ] K8s Manifest มี Resource Limits
- [ ] มี Probes
- [ ] ไม่มี Secret ใน Repo
- [ ] Pipeline ผ่าน
- [ ] Security Scan ผ่าน
- [ ] SBOM Generated
- [ ] Rollback Plan
- [ ] Runbook อัปเดต (ถ้าจำเป็น)

## 19.2 สิ่งที่ DevOps Review ใน Dev PR

- [ ] Dockerfile เปลี่ยน → Image Size, Security
- [ ] Dependency ใหม่ → License, Vulnerability
- [ ] Config ใหม่ → Secret / Env
- [ ] Migration → Rollback Plan
- [ ] API ใหม่ → Health Check / Metric

## 19.3 สิ่งที่ DevOps ไม่ควรทำ

- ❌ Approve โดยไม่อ่าน Diff
- ❌ ปล่อย Secrets ผ่าน
- ❌ Deploy Prod โดยไม่มี Approval
- ❌ แก้ Production Manual โดยไม่มี Audit
- ❌ ใช้ `latest` tag ใน Prod

---

# 20. Root Cause Analysis (RCA)

## 20.1 ตัวอย่าง RCA: Production Downtime 45 นาที

### Problem
Production ล่ม 45 นาที ทำให้ผู้ใช้ Finance เข้าระบบไม่ได้

### Impact
- ผู้ใช้ 200 คนไม่สามารถทำงานได้
- Payment Sync หยุด
- SLA ผิดสัญญา

### Timeline

| เวลา | เหตุการณ์ |
|------|----------|
| 10:00 | Alert: High Error Rate |
| 10:02 | On-call Acknowledged |
| 10:05 | Triage: DB Connection Pool Exhausted |
| 10:10 | Mitigate: Restart Service (ชั่วคราว) |
| 10:15 | Error กลับมา |
| 10:20 | Rollback Deploy ล่าสุด |
| 10:30 | ระบบกลับปกติ |
| 10:45 | ยืนยันเสถียร |

### 5 Whys

1. **Why?** — DB Connection Pool เต็ม
2. **Why?** — Service เปิด Connection ใหม่ทุก Request (Bug)
3. **Why?** — Code Review ไม่จับ Bug นี้
4. **Why?** — ไม่มี Test ที่ตรวจ Connection Leak
5. **Why?** — ไม่มี Metric ที่ Track Connection Pool

### Root Cause
ขาด Metric + Test ที่ตรวจ Connection Leak ใน Service

### Corrective Action
- แก้ Bug Connection Leak
- Deploy Hotfix

### Preventive Action
- เพิ่ม Metric: `db_connection_pool_usage`
- เพิ่ม Alert: Pool Usage > 80%
- เพิ่ม Test: Connection Leak Test
- เพิ่ม Checklist: Resource Management ใน PR Review
- Update Runbook

### Monitoring
- KPI: DB Pool Usage < 80%
- Duration: 3 เดือน
- Owner: SRE Lead

## 20.2 RCA Checklist สำหรับ DevOps

- [ ] มี Timeline ครบ
- [ ] มี Evidence (Log, Metric, Trace)
- [ ] มี 5 Whys หรือ Fishbone
- [ ] ระบุ Root Cause ไม่ใช่ Symptom
- [ ] มี Corrective Action
- [ ] มี Preventive Action
- [ ] มี Owner + Due Date
- [ ] มีการติดตามผล
- [ ] Update Runbook / Alert / Checklist

---

# 21. ภาคผนวก: คำศัพท์สองภาษา และเอกสารอ้างอิง

## 21.1 คำศัพท์สองภาษา

| ไทย | English | ความหมาย |
|-----|---------|----------|
| การรวม Continuous | Continuous Integration (CI) | รวมโค้ดบ่อย + ตรวจอัตโนมัติ |
| การส่งมอบต่อเนื่อง | Continuous Delivery/Deployment (CD) | Deploy อัตโนมัติ |
| โครงสร้างพื้นฐานเป็นโค้ด | Infrastructure as Code (IaC) | จัดการ Infra ผ่าน Code |
| คอนเทนเนอร์ | Container | แพ็กเกจ App + Dependency |
| ตัวจัดการคอนเทนเนอร์ | Orchestrator | ระบบจัดการ Container |
| การ Deploy แบบน้ำเงิน-เขียว | Blue-Green Deployment | Deploy สอง Env แล้วสลับ |
| การ Deploy แบบคานารี | Canary Deployment | Deploy บางส่วนก่อน |
| ธงฟีเจอร์ | Feature Flag | เปิด/ปิดฟีเจอร์ |
| การย้อนกลับ | Rollback | กลับ Version ก่อน |
| ความสามารถในการสังเกต | Observability | Log/Metric/Trace |
| ตัวชี้วัดระดับบริการ | SLI | ตัววัดระดับบริการ |
| เป้าหมายระดับบริการ | SLO | เป้าหมายระดับบริการ |
| ข้อตกลงระดับบริการ | SLA | ข้อตกลงระดับบริการ |
| งบความผิดพลาด | Error Budget | โควต้าความผิดพลาด |
| คู่มือแก้เหตุ | Runbook | คู่มือ Incident |
| การวิเคราะห์หลังเกิดเหตุ | Post-mortem | วิเคราะห์หลัง Incident |
| ข้อมูลลับ | Secret | Password/Token/Key |
| บิลส่วนประกอบซอฟต์แวร์ | SBOM | Software Bill of Materials |
| การสแกนช่องโหว่ | Vulnerability Scan | ตรวจช่องโหว่ |
| การหมุน Secret | Secret Rotation | เปลี่ยน Secret ตามรอบ |
| การทดสอบความทนทาน | Chaos Engineering | จงใจทำให้ล่มเพื่อทดสอบ |
| การปรับขนาดอัตโนมัติ | Autoscaling | เพิ่ม/ลด Resource อัตโนมัติ |

## 21.2 เอกสารอ้างอิง

- Complete Multi-Role Work Manuals — Financial & Accounting Technology Solutions
- เล่ม 1: คู่มือ Product Owner / Business Analyst
- เล่ม 2: คู่มือ Full-Stack Engineer
- เล่ม 3: คู่มือ Solution Architect / Tech Lead
- เล่ม 4: คู่มือ QA / Test Engineer
- เล่ม 6: คู่มือ Code Reviewer
- เล่ม 7: คู่มือ Incident Commander / On-call
- เล่ม 10: คู่มือ AI-Assisted Development (`tb-*` Skills)
- เล่ม 11: คู่มือ Hotfix & Rollback
- เล่ม 12: คู่มือ CI/CD & Git Flow
- เล่ม 13: คู่มือ RCA
- เล่ม 14: คู่มือ Security & Compliance

## 21.3 มาตรฐานและ Framework อ้างอิง

- **Google SRE Book** — SRE Practices
- **The DevOps Handbook** — DevOps Principles
- **Accelerate** — DORA Metrics
- **12-Factor App** — Application Design
- **CNCF Landscape** — Cloud Native Tools
- **OWASP Top 10** — Security
- **CIS Benchmarks** — Container Security
- **NIST SP 800-190** — Container Security Guide
- **ISO/IEC 27001** — Information Security

---

# ✅ ภาคผนวกท้ายเล่ม: DevOps Daily Checklist

## ก่อนเริ่ม Sprint
- [ ] ตรวจ Pipeline Health
- [ ] ตรวจ Alert Noise
- [ ] ตรวจ Cost Trend
- [ ] ตรวจ Capacity
- [ ] อัปเดต Runbook

## ระหว่าง Sprint
- [ ] Review PR ที่เกี่ยวกับ Infra
- [ ] Deploy Staging
- [ ] Monitor Alert
- [ ] Rotate Secret (ตามรอบ)
- [ ] Update Documentation

## ก่อน Release
- [ ] Build ผ่าน CI
- [ ] Security Scan ผ่าน
- [ ] Approval ครบ
- [ ] Backup พร้อม
- [ ] Rollback Plan พร้อม
- [ ] Monitor Dashboard เปิด
- [ ] Stakeholder แจ้งแล้ว

## หลัง Release
- [ ] Monitor 5–30 นาที
- [ ] Smoke Test ผ่าน
- [ ] Metric กลับปกติ
- [ ] Alert ไม่ Trigger
- [ ] อัปเดต Runbook
- [ ] บันทึก Lessons Learned

---
 