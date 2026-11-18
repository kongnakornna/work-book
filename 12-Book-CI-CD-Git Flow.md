## 📘 เล่ม 12 (ฉบับขยาย): คู่มือ CI/CD & Git Flow

> **หมายเหตุ:** เอกสารนี้เป็นฉบับขยายของเล่ม 12 ใน Master Index โดยเพิ่มรายละเอียดเชิงปฏิบัติสำหรับ Developer และ DevOps ได้แก่ Git Flow เชิงลึก, Branch Lifecycle, Commit Convention, CI/CD Pipeline Stages (ครบทุกขั้น), GitHub Actions Workflows จริง, Environment Management, Database Migration Pipeline, Security Scanning, Artifact Management, Deployment Strategies, Monorepo Considerations, Templates และ KPIs

---

## 12.0 บทนำและปรัชญา

### 12.0.1 ทำไมต้อง CI/CD & Git Flow?

```
┌─────────────────────────────────────────────────────────────┐
│              PROBLEM vs SOLUTION                            │
└─────────────────────────────────────────────────────────────┘

  ปัญหาแบบเดิม:
  • Merge Conflict บ่อย → เสียเวลา
  • Deploy ด้วยมือ → ผิดพลาดง่าย
  • ไม่มี Test อัตโนมัติ → บั๊กหลุด
  • ไม่มี Standard → แต่ละคนทำต่างกัน
  • Rollback ยาก → ระบบล่มนาน

  Solution: CI/CD + Git Flow
  • Branch Strategy ชัดเจน → Merge ง่าย
  • Pipeline อัตโนมัติ → Deploy เร็ว
  • Test ทุก Commit → บั๊กน้อย
  • Standard ทุกคน → คาดเดาได้
  • Rollback ง่าย → MTTR ต่ำ
```

### 12.0.2 ปรัชญา 3 ข้อ

| หลักการ | ความหมาย | ผลลัพธ์ |
|---------|----------|---------|
| **Small Batches** | Merge บ่อย, Branch อายุสั้น | Merge Conflict น้อย |
| **Automate Everything** | Lint, Test, Build, Deploy | ผิดพลาดน้อย, เร็ว |
| **Fail Fast** | จับ Error เร็วที่สุด | แก้ไขถูก, ต้นทุนต่ำ |

### 12.0.3 CI vs CD vs CD

| ตัวย่อ | ความหมาย | ขอบเขต |
|--------|----------|---------|
| **CI** (Continuous Integration) | Merge Code บ่อย + Test อัตโนมัติ | Code → Test → Build |
| **CD** (Continuous Delivery) | พร้อม Deploy ตลอด (Manual Trigger) | Build → Staging → (Manual) Prod |
| **CD** (Continuous Deployment) | Deploy อัตโนมัติทุกครั้ง | Build → Staging → Prod (Auto) |

> ⚠️ โปรเจกต์นี้ใช้ **Continuous Delivery** — Deploy Prod ต้องมี Manual Approval

---

## 12.1 Git Flow (Deep Dive)

### 12.1.1 โครงสร้าง Branch

```
┌─────────────────────────────────────────────────────────────┐
│                    GIT FLOW STRUCTURE                       │
└─────────────────────────────────────────────────────────────┘

  main (production, protected)
   │
   │  ●──────●──────────●──────────●──── (tags: v1.0.0, v1.0.1, v1.1.0)
   │         │          │          │
   │         │          │          │
   │  ┌──────┘          │          │
   │  │                 │          │
   │  ▼                 ▼          ▼
  develop (staging, protected)
   │
   │  ●───●───●───●───●───●───●───●
   │      │   │       │       │
   │      │   │       │       │
   │      ▼   ▼       ▼       ▼
  feature/*  bugfix/*  enhancement/*  refactor/*
   │
   │  (merge กลับ develop เมื่อเสร็จ)
   │
  release/* (created from develop)
   │
   │  ●───●───●───●
   │              │
   │              ▼ (merge to main + develop)
   │
  hotfix/* (created from main)
   │
   │  ●───●
   │      │
   │      ▼ (merge to main + develop)
```

### 12.1.2 ประเภท Branch และ Lifecycle

| Branch | สร้างจาก | Merge ไป | อายุ | ป้องกัน? |
|--------|---------|----------|-----|:--------:|
| **main** | — | — | ตลอด | ✅ |
| **develop** | main | — | ตลอด | ✅ |
| **feature/*** | develop | develop | 1–5 วัน | ❌ |
| **bugfix/*** | develop | develop | 1–3 วัน | ❌ |
| **enhancement/*** | develop | develop | 1–3 วัน | ❌ |
| **refactor/*** | develop | develop | 1–5 วัน | ❌ |
| **chore/*** | develop | develop | < 1 วัน | ❌ |
| **release/*** | develop | main + develop | 1–2 สัปดาห์ | ✅ |
| **hotfix/*** | main | main + develop | 1–2 วัน | ✅ |

### 12.1.3 Branch Protection Rules

```
┌─────────────────────────────────────────────────────────────┐
│              BRANCH PROTECTION (main & develop)             │
└─────────────────────────────────────────────────────────────┘

  ✅ Require Pull Request before merging
  ✅ Require Approvals: 1 (develop), 2 (main)
  ✅ Dismiss stale approvals on new commits
  ✅ Require status checks to pass:
     • lint
     • type-check
     • unit-test
     • integration-test
     • security-scan
     • build
  ✅ Require conversation resolution
  ✅ Require linear history (Squash Merge)
  ✅ No force push
  ✅ No deletion
  ❌ Allow bypass (ไม่ให้ใคร bypass)
```

### 12.1.4 Branch Naming Convention (ขยาย)

| ประเภท | Pattern | ตัวอย่าง | หมายเหตุ |
|--------|---------|----------|----------|
| Feature | `feature/<TICKET>-<desc>` | `feature/PMS-101-add-employee-api` | desc สั้นๆ |
| Bugfix | `bugfix/<TICKET>-<desc>` | `bugfix/PMS-202-fix-null-email` | desc ระบุ Bug |
| Enhancement | `enhancement/<TICKET>-<desc>` | `enhancement/PMS-303-improve-loading` | ปรับปรุง |
| Refactor | `refactor/<TICKET>-<scope>` | `refactor/PMS-404-clean-auth-service` | ไม่เปลี่ยน Behavior |
| Chore | `chore/<TICKET>-<task>` | `chore/PMS-505-update-deps` | งานจุกจิก |
| Hotfix | `hotfix/<version>-<desc>` | `hotfix/v1.0.1-fix-payment` | ด่วน |
| Release | `release/<version>` | `release/v1.2.0` | เตรียม Release |
| Docs | `docs/<TICKET>-<desc>` | `docs/PMS-606-update-readme` | เอกสาร |
| Test | `test/<TICKET>-<desc>` | `test/PMS-707-add-e2e` | เพิ่ม Test |

**กฎการตั้งชื่อ:**
- ✅ ใช้ **kebab-case** (ตัวเล็ก + ขีดกลาง)
- ✅ ใส่ **Ticket ID** เสมอ
- ✅ **desc** สั้น กระชับ (≤ 5 คำ)
- ❌ ห้ามใช้ space, ตัวพิมพ์ใหญ่, อักขระพิเศษ
- ❌ ห้ามตั้งชื่อกว้าง (เช่น `feature/fix`)

### 12.1.5 Branch Lifecycle Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                BRANCH LIFECYCLE                             │
└─────────────────────────────────────────────────────────────┘

  Day 0: สร้าง Feature Branch
         git checkout -b feature/PMS-101-add-employee-api develop
         │
         ▼
  Day 0–3: Develop + Commit (Atomic)
         git commit -m "feat(employee): add model"
         git commit -m "feat(employee): add repository"
         │
         ▼
  Day 3: Push + PR
         git push -u origin feature/PMS-101-add-employee-api
         gh pr create --base develop
         │
         ▼
  Day 3: CI Runs (Lint, Test, Build)
         │
    ┌────┴────┐
   Pass      Fail
    │         │
    │         ▼
    │    Fix → Push → CI Runs
    │
    ▼
  Day 3–4: Code Review
         │
    ┌────┴────┐
  Approve   Request Changes
    │         │
    │         ▼
    │    Fix → Push → Review
    │
    ▼
  Day 4: Squash Merge to develop
         gh pr merge --squash --delete-branch
         │
         ▼
  Day 4: Branch ลบ (อัตโนมัติ)
```

**อายุ Branch ที่ดี:**
- ✅ Feature: **≤ 5 วัน**
- ✅ Bugfix: **≤ 3 วัน**
- ⚠️ ถ้าเกิน → แบ่ง Branch (Stacked PRs)

### 12.1.6 Merge Strategies

| Strategy | ใช้เมื่อ | ประวัติ |
|----------|---------|--------|
| **Squash & Merge** | Feature → develop (แนะนำ) | Linear, 1 Commit |
| **Merge Commit** | Release → main | เก็บ History |
| **Rebase** | Feature update develop | Linear |
| **Fast-forward** | ไม่แนะนำ (ซับซ้อน) | — |

**ตัวอย่าง Squash Merge:**

```bash
# Feature มี 5 Commits
git log --oneline feature/PMS-101
# abc123 feat: add router
# def456 feat: add service
# ghi789 feat: add repository
# jkl012 feat: add model
# mno345 feat: add tests

# Squash Merge → develop (1 Commit)
gh pr merge 101 --squash --delete-branch
# develop มี 1 Commit: "feat(employee): add POST /employee API (#101)"
```

### 12.1.7 Conflict Resolution

```bash
# 1. Update develop
git checkout develop
git pull origin develop

# 2. Rebase Feature onto develop
git checkout feature/PMS-101-add-employee-api
git rebase develop

# 3. แก้ Conflict (ถ้ามี)
# ... แก้ไฟล์ ...
git add <file>
git rebase --continue

# 4. Force Push (เพราะ Rebase เปลี่ยน History)
git push --force-with-lease origin feature/PMS-101-add-employee-api

# 5. ถ้าอยากยกเลิก Rebase
git rebase --abort
```

**ข้อควรระวัง:**
- ⚠️ ใช้ `--force-with-lease` (ไม่ใช่ `--force`)
- ⚠️ ห้าม Rebase Branch ที่คนอื่นใช้ร่วม
- ⚠️ ต้องแจ้งทีมก่อน Force Push

---

## 12.2 Commit Convention (Conventional Commits)

### 12.2.1 โครงสร้าง Commit Message

```
<type>(<scope>): <subject>

<body>

<footer>
```

| ส่วน | จำเป็น | ความยาว | ตัวอย่าง |
|------|:------:|---------|----------|
| **type** | ✅ | 1 คำ | `feat`, `fix` |
| **scope** | ⚠️ | 1 คำ | `employee`, `payment` |
| **subject** | ✅ | ≤ 72 ตัว | `add POST /employee` |
| **body** | ❌ | ตามต้องการ | อธิบาย Why |
| **footer** | ❌ | ตามต้องการ | `Closes: #101` |

### 12.2.2 Types (ครบ)

| Type | ใช้เมื่อ | ตัวอย่าง |
|------|---------|----------|
| `feat` | ฟีเจอร์ใหม่ | `feat(employee): add POST /employee` |
| `fix` | แก้บั๊ก | `fix(payment): increase timeout 10s → 30s` |
| `refactor` | Refactor (ไม่เปลี่ยน Behavior) | `refactor(auth): extract token validation` |
| `perf` | ปรับ Performance | `perf(query): add index on email` |
| `test` | เพิ่ม/แก้ Test | `test(employee): add duplicate email test` |
| `docs` | เอกสาร | `docs(readme): update setup guide` |
| `style` | Formatting (ไม่เปลี่ยน Logic) | `style: apply prettier` |
| `chore` | งานจุกจิก | `chore(deps): update fastapi to 0.109` |
| `ci` | CI/CD | `ci: add trivy scan` |
| `build` | Build System | `build: upgrade to Python 3.12` |
| `revert` | ย้อน Commit | `revert: feat(employee): add API` |

### 12.2.3 ตัวอย่าง Commit ที่ดี vs ไม่ดี

**❌ ไม่ดี:**

```
fix bug
update code
WIP
asdf
แก้ไข
```

**✅ ดี:**

```
feat(employee): add POST /employee endpoint

- Auto-generate UUID v4 for id
- Validate full_name (required, non-whitespace)
- Normalize email to lowercase
- Reject duplicate email with 409 Conflict
- Add unique index on email

Closes: #PMS-101
Reviewed-by: @reviewer
```

**✅ ดี (Bug Fix):**

```
fix(payment): increase Oracle ERP timeout 10s → 30s

Root Cause: Oracle ERP response time > 10s during peak hours
Impact: Payment failures affecting 15% transactions
Fix: Increase timeout + add retry with backoff

Fixes: #PMS-301
Severity: SEV-2
```

### 12.2.4 Breaking Changes

```
feat(api)!: change POST /employee response format

BREAKING CHANGE: Response now returns `data` wrapper
instead of raw object. Clients must update parsing.

Before:
{ "id": "...", "full_name": "..." }

After:
{ "data": { "id": "...", "full_name": "..." } }

Migration Guide: docs/migration/v2.md
```

### 12.2.5 Commit Hooks (Automation)

```bash
# .husky/commit-msg (validate commit message)
npx --no -- commitlint --edit "$1"

# commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'refactor', 'perf', 'test',
      'docs', 'style', 'chore', 'ci', 'build', 'revert'
    ]],
    'subject-max-length': [2, 'always', 72],
    'scope-case': [2, 'always', 'kebab-case'],
  },
};

# .husky/pre-commit (lint + test staged)
npx lint-staged
```

```json
// package.json
{
  "lint-staged": {
    "*.{ts,tsx}": ["eslint --fix", "prettier --write"],
    "*.py": ["ruff check --fix", "ruff format"]
  }
}
```

---

## 12.3 CI/CD Pipeline Stages (ครบทุกขั้น)

### 12.3.1 ภาพรวม Pipeline

```
┌─────────────────────────────────────────────────────────────┐
│                  CI/CD PIPELINE OVERVIEW                    │
└─────────────────────────────────────────────────────────────┘

  ┌──────────────────────────────────────────────────────┐
  │                    CI PHASE (ทุก Branch)             │
  └──────────────────────────────────────────────────────┘
  1. Detect Changes (paths-filter)
  2. Lint (ESLint, Ruff, Prettier)
  3. Type Check (TypeScript, MyPy)
  4. Unit Tests (Jest, pytest)
  5. Integration Tests (Supertest, httpx)
  6. Coverage Check (≥ 80%)
  7. Security Scan (Trivy, SonarQube)
  8. Build Validation
         │
         ▼
  ┌──────────────────────────────────────────────────────┐
  │                    BUILD PHASE                       │
  └──────────────────────────────────────────────────────┘
  9.  Build Docker Image
  10. Tag (branch-sha, semver)
  11. Push to Registry
  12. Generate SBOM
         │
         ▼
  ┌──────────────────────────────────────────────────────┐
  │                    CD PHASE                          │
  └──────────────────────────────────────────────────────┘
  13. Develop → Auto Deploy (Dev)
  14. Release → Auto Deploy (Staging)
  15. Main → Manual Approval → Prod (Blue-Green)
```

### 12.3.2 Stage 1: Detect Changes

```yaml
# .github/workflows/ci-cd.yml
- name: Detect changes
  uses: dorny/paths-filter@v3
  id: filter
  with:
    filters: |
      frontend:
        - 'web/**'
        - 'package.json'
      backend:
        - 'api/**'
        - 'pkg/**'
        - 'requirements.txt'
      database:
        - 'database/migrations/**'
      infra:
        - 'infra/**'
        - '.github/workflows/**'
```

**ประโยชน์:** รันเฉพาะ Job ที่จำเป็น → เร็วขึ้น

### 12.3.3 Stage 2–3: Lint + Type Check

```yaml
# Backend
- name: Lint (ruff)
  if: steps.filter.outputs.backend == 'true'
  run: ruff check .

- name: Format check (ruff)
  run: ruff format --check .

- name: Type check (mypy)
  run: mypy pkg/ api/

# Frontend
- name: Lint (eslint)
  if: steps.filter.outputs.frontend == 'true'
  run: npm run lint

- name: Type check (tsc)
  run: npm run type-check

- name: Format check (prettier)
  run: npx prettier --check .
```

### 12.3.4 Stage 4–5: Test

```yaml
- name: Unit tests (backend)
  if: steps.filter.outputs.backend == 'true'
  run: pytest pkg/ --cov=pkg --cov-report=xml --cov-fail-under=80

- name: Integration tests
  run: pytest api/ -v

- name: Unit tests (frontend)
  if: steps.filter.outputs.frontend == 'true'
  run: npm test -- --coverage --watchAll=false

- name: Upload coverage
  uses: codecov/codecov-action@v4
  with:
    files: ./coverage.xml
    fail_ci_if_error: true
```

### 12.3.5 Stage 6: Coverage Check

```yaml
- name: Coverage gate
  run: |
    COVERAGE=$(grep -oP 'line-rate="\K[0-9.]+' coverage.xml | head -1)
    COVERAGE_PCT=$(echo "$COVERAGE * 100" | bc)
    if (( $(echo "$COVERAGE_PCT < 80" | bc -l) )); then
      echo "Coverage $COVERAGE_PCT% < 80%"
      exit 1
    fi
```

### 12.3.6 Stage 7: Security Scan

```yaml
# Dependency scan
- name: Dependency scan (Trivy)
  uses: aquasecurity/trivy-action@master
  with:
    scan-type: 'fs'
    scan-ref: '.'
    severity: 'CRITICAL,HIGH'
    exit-code: '1'

# Container scan
- name: Container scan (Trivy)
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'your-org/pms-api:${{ github.sha }}'
    severity: 'CRITICAL,HIGH'
    exit-code: '1'

# Secret scan
- name: Secret scan (Gitleaks)
  uses: gitleaks/gitleaks-action@v2
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

# SAST (SonarQube)
- name: SonarQube Scan
  uses: sonarsource/sonarqube-scan-action@master
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
```

### 12.3.7 Stage 8–11: Build + Push

```yaml
- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v3

- name: Login to Registry
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}

- name: Extract metadata
  id: meta
  uses: docker/metadata-action@v5
  with:
    images: ghcr.io/your-org/pms-api
    tags: |
      type=sha,prefix=sha-
      type=ref,event=branch
      type=semver,pattern={{version}}
      type=semver,pattern={{major}}.{{minor}}

- name: Build and push
  uses: docker/build-push-action@v5
  with:
    context: .
    push: true
    tags: ${{ steps.meta.outputs.tags }}
    labels: ${{ steps.meta.outputs.labels }}
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

### 12.3.8 Stage 12: SBOM Generation

```yaml
- name: Generate SBOM
  uses: anchore/sbom-action@v0
  with:
    image: ghcr.io/your-org/pms-api:${{ github.sha }}
    format: spdx-json
    output-file: sbom.spdx.json

- name: Upload SBOM
  uses: actions/upload-artifact@v4
  with:
    name: sbom
    path: sbom.spdx.json
```

### 12.3.9 Stage 13–15: Deploy

```yaml
# Dev (Auto)
deploy-dev:
  needs: build
  if: github.ref == 'refs/heads/develop'
  runs-on: ubuntu-latest
  environment: development
  steps:
    - uses: actions/checkout@v4
    - name: Deploy to Dev
      run: |
        kubectl set image deployment/pms-api \
          pms-api=ghcr.io/your-org/pms-api:sha-${{ github.sha }} \
          -n dev
        kubectl rollout status deployment/pms-api -n dev --timeout=5m

# Staging (Auto)
deploy-staging:
  needs: build
  if: startsWith(github.ref, 'refs/heads/release/')
  runs-on: ubuntu-latest
  environment: staging
  steps:
    - uses: actions/checkout@v4
    - name: Deploy to Staging
      run: |
        kubectl set image deployment/pms-api \
          pms-api=ghcr.io/your-org/pms-api:sha-${{ github.sha }} \
          -n staging
        kubectl rollout status deployment/pms-api -n staging --timeout=5m

# Prod (Manual Approval + Blue-Green)
deploy-prod:
  needs: build
  if: github.ref == 'refs/heads/main'
  runs-on: ubuntu-latest
  environment:
    name: production
    url: https://pms.your-company.com
  steps:
    - uses: actions/checkout@v4
    - name: Blue-Green Deploy
      run: ./scripts/deploy-blue-green.sh ${{ github.sha }}
    - name: Verify
      run: ./scripts/verify-deployment.sh
    - name: Notify
      if: always()
      uses: 8398a7/action-slack@v3
      with:
        status: ${{ job.status }}
        webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

---

## 12.4 Branch-to-Environment Mapping

### 12.4.1 ตาราง Environment

| Branch | Environment | Auto Deploy | Approval | Database | URL |
|--------|-------------|:-----------:|:--------:|----------|-----|
| `feature/*` | ❌ None | — | — | — | — |
| `develop` | **Development** | ✅ | ❌ | Dev DB | dev.pms.example.com |
| `release/*` | **Staging** | ✅ | ❌ | Staging DB | staging.pms.example.com |
| `main` | **Production** | ⚠️ Manual | ✅ 2 Approvers | Prod DB | pms.example.com |
| `hotfix/*` | Staging → Prod | ⚠️ Fast-track | ✅ 1 Approver | Prod DB | — |

### 12.4.2 Environment Configuration

```
┌─────────────────────────────────────────────────────────────┐
│              ENVIRONMENT HIERARCHY                          │
└─────────────────────────────────────────────────────────────┘

  Development (develop)
  ├─ Purpose: Test Feature ใหม่
  ├─ Data: Mock / Anonymized
  ├─ Uptime: Best effort
  ├─ Access: ทีม Dev
  └─ Deploy: ทุก Commit

  Staging (release/*)
  ├─ Purpose: Test ก่อน Prod (เหมือน Prod)
  ├─ Data: Anonymized Prod-like
  ├─ Uptime: 99%
  ├─ Access: ทีม Dev + QA + Key User
  └─ Deploy: ทุก Release

  Production (main)
  ├─ Purpose: ใช้งานจริง
  ├─ Data: จริง
  ├─ Uptime: 99.9%
  ├─ Access: User
  └─ Deploy: Manual Approval
```

### 12.4.3 Environment Variables

```yaml
# .github/workflows/ci-cd.yml
env:
  development:
    DATABASE_URL: ${{ secrets.DEV_DATABASE_URL }}
    REDIS_URL: ${{ secrets.DEV_REDIS_URL }}
    LOG_LEVEL: debug
    FEATURE_FLAGS: "all"
  staging:
    DATABASE_URL: ${{ secrets.STAGING_DATABASE_URL }}
    REDIS_URL: ${{ secrets.STAGING_REDIS_URL }}
    LOG_LEVEL: info
    FEATURE_FLAGS: "production"
  production:
    DATABASE_URL: ${{ secrets.PROD_DATABASE_URL }}
    REDIS_URL: ${{ secrets.PROD_REDIS_URL }}
    LOG_LEVEL: warn
    FEATURE_FLAGS: "production"
```

---

## 12.5 Release Process

### 12.5.1 Release Lifecycle

```
┌─────────────────────────────────────────────────────────────┐
│                  RELEASE LIFECYCLE                          │
└─────────────────────────────────────────────────────────────┘

  Week 1: Feature Freeze
         │
         ▼
  Day 1: สร้าง release/v1.2.0 จาก develop
         git checkout -b release/v1.2.0 develop
         │
         ▼
  Day 1–3: Stabilize (แก้ Bug เท่านั้น)
         • Update version ใน package.json
         • Update CHANGELOG.md
         • Test บน Staging
         │
         ▼
  Day 4: QA Sign-off (UAT)
         │
         ▼
  Day 5: Merge to main
         gh pr create --base main --head release/v1.2.0
         gh pr merge --merge (ไม่ Squash — เก็บ History)
         │
         ▼
  Day 5: Tag
         git tag -a v1.2.0 -m "Release v1.2.0"
         git push origin v1.2.0
         │
         ▼
  Day 5: Merge back to develop
         git checkout develop
         git merge --no-ff release/v1.2.0
         git push origin develop
         │
         ▼
  Day 5: Deploy Prod (Manual)
         │
         ▼
  Day 5: ลบ release/v1.2.0
```

### 12.5.2 Release Checklist

```markdown
# Release Checklist — v1.2.0

## Pre-Release
- [ ] Feature Freeze (ไม่มี Feature ใหม่)
- [ ] ทุก Feature ใน develop ผ่าน Code Review
- [ ] CI ผ่านทุก Branch
- [ ] UAT Sign-off
- [ ] CHANGELOG อัปเดต
- [ ] Version bump (package.json, pyproject.toml)
- [ ] Migration Test บน Staging
- [ ] Performance Test (ถ้าจำเป็น)
- [ ] Security Scan ผ่าน

## Release Day
- [ ] สร้าง release/v1.2.0
- [ ] Deploy Staging + Smoke Test
- [ ] QA Final Check
- [ ] PR to main (2 Approvers)
- [ ] Merge to main
- [ ] Tag v1.2.0
- [ ] Merge back to develop
- [ ] Deploy Prod (Blue-Green)
- [ ] Verify Prod

## Post-Release
- [ ] Monitor 24 ชั่วโมง
- [ ] แจ้ง Stakeholder
- [ ] ลบ release/v1.2.0
- [ ] อัปเดต Documentation
- [ ] Retrospective
```

### 12.5.3 Version Strategy (Semantic Versioning)

```
MAJOR.MINOR.PATCH

MAJOR: Breaking Change (1.0.0 → 2.0.0)
MINOR: Feature ใหม่ (1.0.0 → 1.1.0)
PATCH: Bug Fix (1.0.0 → 1.0.1)
```

| Version | ตัวอย่าง | เมื่อไหร่ |
|---------|----------|----------|
| `1.0.0` | Initial Release | Go-Live ครั้งแรก |
| `1.1.0` | Feature ใหม่ | เพิ่ม Payment API |
| `1.1.1` | Bug Fix | แก้ Timeout |
| `2.0.0` | Breaking Change | เปลี่ยน API Contract |

---

## 12.6 Database Migration Pipeline

### 12.6.1 Migration Strategy

```
┌─────────────────────────────────────────────────────────────┐
│              DATABASE MIGRATION PIPELINE                    │
└─────────────────────────────────────────────────────────────┘

  Migration File Pushed
         │
         ▼
  CI: Validate Migration
  ├─ Syntax check
  ├─ Dry-run on Dev DB
  └─ Test Upgrade + Downgrade
         │
         ▼
  Deploy Dev (Auto)
  ├─ Run migration
  └─ Smoke test
         │
         ▼
  Deploy Staging (Auto)
  ├─ Backup Staging DB
  ├─ Run migration
  └─ Test
         │
         ▼
  Deploy Prod (Manual)
  ├─ Backup Prod DB ← สำคัญ!
  ├─ Dry-run
  ├─ Wait Approval (2 คน)
  ├─ Run migration
  └─ Verify
```

### 12.6.2 Migration Best Practices

| หลักการ | รายละเอียด |
|---------|-----------|
| **Backward Compatible** | Migration ใหม่ต้องไม่ทำให้ App เก่าพัง |
| **Idempotent** | Run ซ้ำได้ไม่ Error |
| **Reversible** | มี `downgrade()` ทุกครั้ง |
| **Small** | ทีละ Migration ไม่รวมกัน |
| **Tested** | Test บน Staging ก่อน Prod |
| **Backed Up** | Backup DB ก่อน Run Prod |

### 12.6.3 Migration Naming Convention

```
database/migrations/
├── 20241101_000001_create_employees.py
├── 20241105_000002_add_email_unique_index.py
├── 20241110_000003_add_department_column.py
└── 20241115_000004_create_payments.py
```

**รูปแบบ:** `YYYYMMDD_HHMMSS_<description>.py`

### 12.6.4 Zero-Downtime Migration Pattern

```python
# ❌ ไม่ดี: เพิ่ม Column ที่ NOT NULL ทันที (Lock Table)
def upgrade():
    op.add_column('employees', sa.Column('department', sa.String(), nullable=False))

# ✅ ดี: แบ่งเป็น 3 Steps
# Step 1: เพิ่ม Column แบบ Nullable
def upgrade():
    op.add_column('employees', sa.Column('department', sa.String(), nullable=True))

# Step 2: Backfill Data (รันแยก)
def backfill():
    op.execute("UPDATE employees SET department = 'General' WHERE department IS NULL")

# Step 3: เปลี่ยนเป็น NOT NULL (Run หลัง Backfill เสร็จ)
def upgrade_final():
    op.alter_column('employees', 'department', nullable=False)
```

### 12.6.5 Migration Workflow (GitHub Actions)

```yaml
name: Database Migration

on:
  push:
    branches: [develop, main, 'release/**']
    paths: ['database/migrations/**']

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Validate syntax
        run: |
          for f in database/migrations/*.py; do
            python -m py_compile "$f"
          done
      - name: Test upgrade/downgrade
        run: |
          migrate -path ./migrations -database ${{ secrets.DEV_DB }} up
          migrate -path ./migrations -database ${{ secrets.DEV_DB }} down 1
          migrate -path ./migrations -database ${{ secrets.DEV_DB }} up

  migrate-dev:
    needs: validate
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    environment: development
    steps:
      - uses: actions/checkout@v4
      - name: Run migrations
        run: |
          docker run --rm \
            -e DATABASE_URL=${{ secrets.DEV_DATABASE_URL }} \
            migrate/migrate -path=/migrations \
            -database ${{ secrets.DEV_DATABASE_URL }} up

  migrate-staging:
    needs: validate
    if: startsWith(github.ref, 'refs/heads/release/')
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v4
      - name: Backup
        run: ./scripts/backup-database.sh staging
      - name: Dry-run
        run: ./scripts/dry-run-migration.sh staging
      - name: Run migrations
        run: ./scripts/run-migration.sh staging

  migrate-prod:
    needs: validate
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment:
      name: production
    steps:
      - uses: actions/checkout@v4
      - name: Backup
        run: ./scripts/backup-database.sh production
      - name: Dry-run
        run: ./scripts/dry-run-migration.sh production
      - name: Wait for approval
        uses: trstringer/manual-approval@v1
        with:
          approvers: senior-dev-team
          minimum-approvals: 2
      - name: Run migrations
        run: ./scripts/run-migration.sh production
      - name: Verify
        run: ./scripts/verify-migration.sh production
```

---

## 12.7 Security Scanning (Deep Dive)

### 12.7.1 Security Scan Types

| Scan | เครื่องมือ | จับอะไร | เมื่อไหร่ |
|------|-----------|---------|----------|
| **SAST** | SonarQube, CodeQL | Code Vulnerability | ทุก PR |
| **DAST** | OWASP ZAP | Runtime Vulnerability | Staging Deploy |
| **SCA** | Trivy, Dependabot | Dependency CVE | ทุก PR + Daily |
| **Secret Scan** | Gitleaks, TruffleHog | Secrets ใน Git | ทุก PR |
| **Container Scan** | Trivy | Image CVE | ทุก Build |
| **IaC Scan** | Checkov, tfsec | Infra Misconfig | ทุก PR (infra/*) |
| **License Scan** | FOSSA | License Issue | Weekly |

### 12.7.2 Security Gate Rules

```yaml
# ห้าม Merge ถ้า:
- Critical Vulnerabilities > 0
- High Vulnerabilities > 0 (ใน Production Code)
- Secrets detected > 0
- SAST Critical > 0
- License ไม่ Compatible
```

### 12.7.3 Dependabot Configuration

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
    groups:
      production:
        patterns: ["*"]
        exclude-patterns: ["pytest*", "mypy*"]

  - package-ecosystem: "npm"
    directory: "/web"
    schedule:
      interval: "weekly"
    groups:
      frontend:
        patterns: ["react*", "@types/*"]

  - package-ecosystem: "docker"
    directory: "/"
    schedule:
      interval: "weekly"

  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
```

---

## 12.8 Artifact Management

### 12.8.1 Artifact Types

| Artifact | ที่เก็บ | อายุ | ใช้เมื่อ |
|----------|--------|------|----------|
| **Docker Image** | GHCR / ACR | 90 วัน | Deploy |
| **SBOM** | Artifact Storage | 1 ปี | Audit |
| **Test Report** | Artifact Storage | 30 วัน | Debug |
| **Coverage Report** | Codecov | 90 วัน | Quality |
| **Build Logs** | GitHub Actions | 90 วัน | Debug |
| **Release Notes** | Git Tag | ตลอด | Reference |
| **Binary** | Artifact Storage | 1 ปี | Rollback |

### 12.8.2 Image Tagging Strategy

```
ghcr.io/your-org/pms-api:sha-abc123def     (ทุก Commit)
ghcr.io/your-org/pms-api:develop            (Branch)
ghcr.io/your-org/pms-api:v1.2.0             (Semver)
ghcr.io/your-org/pms-api:v1.2               (Major.Minor)
ghcr.io/your-org/pms-api:latest             (Latest Stable)
```

**กฎ:**
- ✅ ใช้ `sha-` สำหรับ Deploy (ไม่ใช้ `latest`)
- ✅ ใช้ `v*` สำหรับ Release
- ❌ ห้าม Deploy `latest` ขึ้น Prod

### 12.8.3 Retention Policy

```yaml
# ลบ Artifact เก่าอัตโนมัติ
- name: Cleanup old images
  uses: actions/delete-package-versions@v5
  with:
    package-name: 'pms-api'
    package-type: 'container'
    min-versions-to-keep: 10
    delete-only-untagged-versions: 'true'
    ignore-versions: '^v\d+\.\d+\.\d+$'
```

---

## 12.9 Deployment Strategies

### 12.9.1 Deployment Comparison

| Strategy | Downtime | Rollback | ความเสี่ยง | ใช้เมื่อ |
|----------|:--------:|:--------:|-----------|----------|
| **Recreate** | ⚠️ มี | ช้า | สูง | Dev only |
| **Rolling** | ❌ ไม่มี | ปานกลาง | ปานกลาง | Dev/Staging |
| **Blue-Green** | ❌ ไม่มี | เร็ว (< 1 นาที) | ต่ำ | Prod |
| **Canary** | ❌ ไม่มี | เร็ว | ต่ำสุด | Prod (Feature ใหม่) |
| **Feature Flag** | ❌ ไม่มี | ทันที | ต่ำสุด | Prod (ทดสอบ) |

### 12.9.2 Blue-Green Deploy Script

```bash
#!/bin/bash
# scripts/deploy-blue-green.sh
set -euo pipefail

VERSION=$1
NAMESPACE=${2:-production}
APP=pms-api

# Determine current active
CURRENT=$(kubectl get service $APP -n $NAMESPACE \
  -o jsonpath='{.spec.selector.version}')
if [ "$CURRENT" = "blue" ]; then
  TARGET="green"
else
  TARGET="blue"
fi

echo "Current: $CURRENT → Target: $TARGET"

# Deploy to target
kubectl set image deployment/$APP-$TARGET \
  $APP=ghcr.io/your-org/pms-api:sha-$VERSION \
  -n $NAMESPACE

# Wait for rollout
kubectl rollout status deployment/$APP-$TARGET -n $NAMESPACE --timeout=5m

# Smoke test (target before switch)
TARGET_URL="http://$APP-$TARGET.$NAMESPACE.svc.cluster.local"
if ! curl -sf "$TARGET_URL/health"; then
  echo "Smoke test failed — aborting"
  exit 1
fi

# Switch traffic
kubectl patch service $APP -n $NAMESPACE \
  --type='json' \
  -p="[{\"op\": \"replace\", \"path\": \"/spec/selector/version\", \"value\": \"$TARGET\"}]"

echo "Switched to $TARGET"

# Monitor 5 minutes
sleep 300

# Check error rate
ERROR_RATE=$(curl -s "http://prometheus:9090/api/v1/query?query=rate(http_requests_total{status=~\"5..\"}[5m])" | jq '.data.result[0].value[1]')
if (( $(echo "$ERROR_RATE > 0.01" | bc -l) )); then
  echo "Error rate too high — rolling back"
  kubectl patch service $APP -n $NAMESPACE \
    --type='json' \
    -p="[{\"op\": \"replace\", \"path\": \"/spec/selector/version\", \"value\": \"$CURRENT\"}]"
  exit 1
fi

echo "Deploy successful — $TARGET is live"
```

### 12.9.3 Canary Deploy

```yaml
# infra/canary/pms-api-canary.yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: pms-api
  namespace: production
spec:
  replicas: 5
  strategy:
    canary:
      steps:
        - setWeight: 10
        - pause: { duration: 5m }
        - setWeight: 25
        - pause: { duration: 10m }
        - setWeight: 50
        - pause: { duration: 10m }
        - setWeight: 100
      analysis:
        templates:
          - templateName: success-rate
        startingStep: 1
```

---

## 12.10 Monorepo Considerations

### 12.10.1 Monorepo Structure

```
pms/
├── .github/workflows/
│   ├── ci-frontend.yml
│   ├── ci-backend.yml
│   ├── ci-infra.yml
│   └── deploy.yml
├── web/                    # Frontend (React)
│   ├── package.json
│   └── src/
├── api/                    # API (FastAPI)
│   ├── main.py
│   └── modules/
├── pkg/                    # Shared Python
├── database/migrations/
├── infra/                  # K8s, Terraform
└── docs/
```

### 12.10.2 Path Filters (สำคัญมาก)

```yaml
# รันเฉพาะ Job ที่ไฟล์เปลี่ยน
- uses: dorny/paths-filter@v3
  id: filter
  with:
    filters: |
      frontend:
        - 'web/**'
        - 'package.json'
        - 'package-lock.json'
      backend:
        - 'api/**'
        - 'pkg/**'
        - 'requirements.txt'
        - 'pyproject.toml'
      database:
        - 'database/migrations/**'
      infra:
        - 'infra/**'
        - '.github/workflows/**'
      docs:
        - 'docs/**'
        - '*.md'
```

### 12.10.3 Conditional Jobs

```yaml
jobs:
  lint-backend:
    if: needs.changes.outputs.backend == 'true'
    # ...

  lint-frontend:
    if: needs.changes.outputs.frontend == 'true'
    # ...

  deploy:
    if: needs.changes.outputs.backend == 'true' || needs.changes.outputs.frontend == 'true'
    # ...
```

---

## 12.11 Pipeline Performance

### 12.11.1 เทคนิคทำให้ Pipeline เร็ว

| เทคนิค | ผลลัพธ์ | ตัวอย่าง |
|--------|---------|----------|
| **Path Filters** | รันเฉพาะที่เปลี่ยน | dorny/paths-filter |
| **Parallel Jobs** | รันพร้อมกัน | Lint + Test + Scan |
| **Caching** | ไม่ Download ซ้ำ | pip cache, npm cache |
| **Matrix Build** | ทดสอบหลาย Version พร้อมกัน | Python 3.10/3.11/3.12 |
| **Docker Layer Cache** | Build Image เร็ว | cache-from: type=gha |
| **Test Splitting** | แบ่ง Test รันขนาน | pytest-xdist |
| **Shallow Clone** | Clone เร็ว | fetch-depth: 1 |
| **Skip CI** | ข้ามเมื่อไม่จำเป็น | `[skip ci]` |

### 12.11.2 ตัวอย่าง Pipeline ที่เร็ว

```yaml
jobs:
  changes:
    runs-on: ubuntu-latest
    outputs:
      backend: ${{ steps.filter.outputs.backend }}
      frontend: ${{ steps.filter.outputs.frontend }}
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 1
      - uses: dorny/paths-filter@v3
        id: filter
        with:
          filters: |
            backend: ['api/**', 'pkg/**', 'requirements.txt']
            frontend: ['web/**', 'package.json']

  backend-ci:
    needs: changes
    if: needs.changes.outputs.backend == 'true'
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python: ['3.10', '3.11', '3.12']
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 1
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python }}
          cache: 'pip'
      - run: pip install -r requirements.txt
      - run: ruff check .
      - run: mypy pkg/ api/
      - run: pytest -n auto --cov=pkg --cov-fail-under=80
```

**เป้าหมาย Pipeline Time:**

| Stage | เป้าหมาย | เหตุผล |
|-------|----------|--------|
| Lint + Type Check | ≤ 2 นาที | Fast Feedback |
| Unit Test | ≤ 5 นาที | Fast Feedback |
| Integration Test | ≤ 10 นาที | Before Merge |
| Build | ≤ 5 นาที | Cached |
| **Total (PR)** | **≤ 15 นาที** | Developer ไม่ออกนอกเรื่อง |

---

## 12.12 Templates (ครบชุด)

### 12.12.1 PR Template

```markdown
# Pull Request: [ชื่อ]

**Ticket:** [JIRA/GitHub Issue Link]
**Type:** [Feature/Bugfix/Refactor/Chore]
**Priority:** [P0/P1/P2/P3]
**Target Branch:** [develop/main]

## 📝 What
[อธิบายสิ่งที่เปลี่ยนแปลง]

## 🎯 Why
[เหตุผลที่เปลี่ยนแปลง]

## 🔧 How
[วิธีที่ใช้]

## 📸 Screenshots (ถ้ามี UI Changes)
[แนบรูป]

## 🧪 Test Plan
- [ ] Unit Test ผ่าน
- [ ] Integration Test ผ่าน
- [ ] Manual Test บน Staging
- [ ] Performance Test (ถ้าจำเป็น)

## ⚠️ Risks & Rollback Plan
[ความเสี่ยงและวิธี Rollback]

## 📎 Checklist
- [ ] Code follows style guide
- [ ] Tests pass (CI ผ่าน)
- [ ] Documentation updated
- [ ] No secrets committed
- [ ] Breaking changes documented (ถ้ามี)
- [ ] Migration included (ถ้ามี)

## 🤖 AI-Assisted (ถ้าใช้ tb-*)
- [ ] /tb-brainstorming
- [ ] /tb-writing-plans
- [ ] /tb-executing-plans
- [ ] /tb-scrutinize
```

### 12.12.2 Issue Template (Bug)

```markdown
# Bug Report

**Severity:** [Critical/High/Medium/Low]
**Environment:** [Dev/Staging/Prod]
**Version:** [v1.2.0]

## Description
[อธิบายบั๊ก]

## Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Expected Behavior
[สิ่งที่ควรเกิดขึ้น]

## Actual Behavior
[สิ่งที่เกิดขึ้น]

## Evidence
- Screenshot: [link]
- Log: [link]
- Trace ID: [id]

## Environment Details
- Browser: [Chrome 120]
- OS: [macOS 14]
- User: [user@example.com]
```

### 12.12.3 Release Notes Template

```markdown
# Release Notes — v1.2.0

**Release Date:** [YYYY-MM-DD]
**Type:** Minor Release

## 🎉 New Features
- **Employee API** (#101): เพิ่ม POST /employee สำหรับสร้างพนักงาน
- **Payment Timeout** (#102): เพิ่ม Configurable Timeout สำหรับ Oracle ERP

## 🐛 Bug Fixes
- **Duplicate Email** (#201): แก้ Bug Duplicate Email ไม่ถูก Block
- **Null Email** (#202): แก้ 500 Error เมื่อ email = null

## ⚡ Performance
- **Database Index** (#301): เพิ่ม Index บน email (ลด Query Time 80%)

## 🔒 Security
- **Dependency Update** (#401): อัปเดต FastAPI 0.109 → 0.115 (แก้ CVE-2024-XXXX)

## 🔧 Breaking Changes
- ⚠️ **API Response Format**: POST /employee ตอนนี้ Return `{ data: {...} }` แทน `{...}`
  - Migration: ดู [docs/migration/v2.md](docs/migration/v2.md)

## 📊 Metrics
- Test Coverage: 82% → 85%
- Pipeline Time: 18 min → 14 min

## 🙏 Contributors
@dev1, @dev2, @qa1

## 📎 Links
- Full Changelog: [link]
- Docker Image: `ghcr.io/your-org/pms-api:v1.2.0`
- SBOM: [link]
```

### 12.12.4 CHANGELOG Template

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- ...

### Changed
- ...

### Fixed
- ...

## [1.2.0] - 2024-11-18

### Added
- Employee API (#101)
- Payment Timeout Config (#102)

### Fixed
- Duplicate Email Bug (#201)
- Null Email 500 Error (#202)

### Security
- Update FastAPI to 0.115 (#401)

## [1.1.0] - 2024-11-01
...
```

---

## 12.13 KPIs สำหรับ CI/CD

| KPI | คำนิยาม | เป้าหมาย | วิธีวัด |
|-----|---------|----------|---------|
| **Deployment Frequency** | จำนวน Deploy/สัปดาห์ | ≥ 2 | Deploy log |
| **Lead Time for Changes** | Commit → Prod | ≤ 3 วัน | Git + Deploy log |
| **Change Failure Rate** | % Deploy ที่ต้อง Rollback | < 15% | Deploy log |
| **MTTR** | เวลาแก้ Incident เฉลี่ย | ≤ 30 นาที | Incident log |
| **Pipeline Duration** | เวลา CI/CD (PR) | ≤ 15 นาที | CI metrics |
| **Pipeline Success Rate** | % ที่ CI ผ่านครั้งแรก | ≥ 90% | CI metrics |
| **Test Coverage** | % Code ที่มี Test | ≥ 80% | Coverage tool |
| **Flaky Test Rate** | % Test ที่ไม่เสถียร | < 2% | CI metrics |
| **Security Issues** | Critical/High ที่ค้าง | 0 | Scan report |
| **Branch Age** | อายุ Branch เฉลี่ย | ≤ 5 วัน | Git metrics |

### 12.13.1 DORA Metrics

```
┌─────────────────────────────────────────────────────────────┐
│                  DORA METRICS (4 ตัว)                       │
└─────────────────────────────────────────────────────────────┘

  ┌────────────────────┐  ┌────────────────────┐
  │  Deployment        │  │  Lead Time for     │
  │  Frequency         │  │  Changes           │
  │  ≥ 2/สัปดาห์       │  │  ≤ 3 วัน            │
  └────────────────────┘  └────────────────────┘

  ┌────────────────────┐  ┌────────────────────┐
  │  Change Failure    │  │  MTTR              │
  │  Rate              │  │                    │
  │  < 15%             │  │  ≤ 30 นาที         │
  └────────────────────┘  └────────────────────┘
```

### 12.13.2 Dashboard ตัวอย่าง

```
┌─────────────────────────────────────────────────────────────┐
│              CI/CD METRICS — Sprint 24                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Deployment Frequency:    ████████░░  4/สัปดาห์  🟢        │
│  Lead Time:               ███████░░░  2.5 วัน    🟢        │
│  Change Failure Rate:     ██░░░░░░░░  8%         🟢        │
│  MTTR:                    ███░░░░░░░  22 นาที    🟢        │
│                                                              │
│  Pipeline Duration:       ███████░░░  14 นาที    🟢        │
│  Pipeline Success Rate:   █████████░  92%        🟢        │
│  Test Coverage:           ████████░░  82%        🟢        │
│  Flaky Test Rate:         █░░░░░░░░░  1.5%       🟢        │
│                                                              │
│  Highlights:                                                 │
│  • Pipeline เร็วขึ้น 4 นาที (Path Filter + Cache)          │
│  • Change Failure Rate ลดจาก 15% → 8%                      │
│                                                              │
│  Concerns:                                                   │
│  • Test Coverage ยังต่ำกว่าเป้าเล็กน้อย (82% vs 85%)       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 12.14 Anti-Patterns

### 12.14.1 Git Anti-Patterns

| # | ❌ Anti-Pattern | ผลกระทบ | ✅ ควรทำ |
|---|----------------|---------|----------|
| 1 | Commit ตรงไปที่ main | ไม่มี Review | ใช้ PR |
| 2 | Branch อายุยาว (> 1 สัปดาห์) | Merge Conflict | Branch สั้น |
| 3 | Commit ใหญ่ (1000+ lines) | Review ยาก | Commit Atomic |
| 4 | Commit Message ไม่สื่อ | หา Bug ยาก | Conventional Commits |
| 5 | Force Push ไป main | History หาย | Protected Branch |
| 6 | Merge โดยไม่ Test | บั๊กหลุด | CI ต้องผ่าน |
| 7 | Commit Secrets | รั่วไหล | Secret Scan |
| 8 | ไม่ Rebase ก่อน PR | Conflict | Rebase ก่อน PR |
| 9 | Merge Commit รก | History ยาก | Squash Merge |
| 10 | ลบ Branch ที่ยังไม่ Merge | งานหาย | Merge ก่อนลบ |

### 12.14.2 CI/CD Anti-Patterns

| # | ❌ Anti-Pattern | ผลกระทบ | ✅ ควรทำ |
|---|----------------|---------|----------|
| 1 | Pipeline นาน (> 30 นาที) | Developer รอ | Path Filter + Parallel |
| 2 | Test Flaky | ไม่มั่นใจ | Fix Flaky Test |
| 3 | Skip Test เพื่อให้ผ่าน | บั๊กหลุด | Fix Test |
| 4 | Deploy ด้วยมือ | ผิดพลาด | Automate |
| 5 | ไม่มี Rollback | แก้ไม่ได้ | มี Plan |
| 6 | ไม่ Monitor หลัง Deploy | ไม่รู้ว่าพัง | Monitor |
| 7 | Deploy Friday | เสี่ยง Weekend | หลีกเลี่ยง |
| 8 | Deploy โดยไม่มี Approval | เสี่ยง | Manual Approval |
| 9 | ใช้ `latest` Tag | ไม่ Reproducible | ใช้ SHA/Semver |
| 10 | ไม่มี Backup ก่อน Deploy | กู้ไม่ได้ | Backup |

---

## 12.15 Best Practices

### 12.15.1 Git Best Practices

- ✅ **Branch สั้น** — ≤ 5 วัน
- ✅ **Commit Atomic** — 1 Commit = 1 Change
- ✅ **Commit Message ชัด** — Conventional Commits
- ✅ **Rebase ก่อน PR** — ลด Conflict
- ✅ **Squash Merge** — History Linear
- ✅ **Protected Branches** — main, develop
- ✅ **Code Review** — 1–2 Approvers
- ✅ **Delete Branch หลัง Merge** — ไม่รก

### 12.15.2 CI/CD Best Practices

- ✅ **Pipeline เร็ว** — ≤ 15 นาที
- ✅ **Path Filter** — รันเฉพาะที่เปลี่ยน
- ✅ **Parallel Jobs** — Lint + Test + Scan
- ✅ **Caching** — pip, npm, Docker
- ✅ **Security Scan** — ทุก PR
- ✅ **Coverage Gate** — ≥ 80%
- ✅ **Manual Approval** — Prod
- ✅ **Blue-Green** — Zero Downtime
- ✅ **Monitor** — หลัง Deploy
- ✅ **Rollback Ready** — มี Plan

### 12.15.3 Release Best Practices

- ✅ **Feature Freeze** — ก่อน Release
- ✅ **UAT Sign-off** — ก่อน Merge main
- ✅ **Semantic Versioning** — v1.2.0
- ✅ **CHANGELOG** — อัปเดตทุก Release
- ✅ **Tag** — ทุก Release
- ✅ **Merge Back** — main → develop
- ✅ **Monitor 24 ชม.** — หลัง Release
- ✅ **Retrospective** — หลัง Release

---

## 12.16 FAQ

**Q1: ต่างกันระหว่าง develop กับ main?**
A: `develop` = Staging (Test Feature ใหม่), `main` = Production (ใช้งานจริง) — Merge จาก develop → main ผ่าน release/*

**Q2: Feature Branch ควรอยู่นานแค่ไหน?**
A: **≤ 5 วัน** — ถ้านานกว่า → แบ่ง Branch (Stacked PRs) หรือ Merge บางส่วนก่อน

**Q3: ต้อง Rebase หรือ Merge develop เข้า Feature?**
A: **Rebase** (แนะนำ) — History Linear, Conflict น้อยกว่า — แต่ต้อง Force Push (ด้วย `--force-with-lease`)

**Q4: Squash Merge หรือ Merge Commit?**
A: **Squash** สำหรับ Feature → develop (1 Commit/Feature) — **Merge Commit** สำหรับ Release → main (เก็บ History)

**Q5: ถ้า CI ไม่ผ่าน ทำไง?**
A: **ห้าม Merge** — แก้ Test/Lint ให้ผ่านก่อน — ถ้าเป็น Flaky Test → Fix Flaky Test (ไม่ Skip)

**Q6: Deploy Friday ได้ไหม?**
A: **ไม่แนะนำ** — ถ้าจำเป็น → มี On-call + Rollback Plan + Monitor — บางบริษัทห้าม Deploy Friday หลัง 14:00

**Q7: Migration ต้อง Backup ก่อนไหม?**
A: **ต้อง Backup เสมอ** — โดยเฉพาะ Prod — ถ้า Migration ล้มเหลว → Rollback ได้

**Q8: ใช้ `latest` Tag ได้ไหม?**
A: **ห้าม** ใช้ `latest` บน Prod — ใช้ `sha-` หรือ `v*` เท่านั้น (Reproducible)

**Q9: Pipeline นานเกินไป ทำไง?**
A: ใช้ **Path Filter** (รันเฉพาะที่เปลี่ยน) + **Parallel Jobs** + **Cache** — เป้า ≤ 15 นาที

**Q10: ลบ Branch เก่าเมื่อไหร่?**
A: **หลัง Merge ทันที** — GitHub/GitLab ตั้ง Auto-delete ได้ — เก็บแค่ `main`, `develop`, `release/*`

---

## 12.17 Glossary

| คำ | ความหมาย |
|----|----------|
| **CI** | Continuous Integration — Merge + Test อัตโนมัติ |
| **CD** | Continuous Delivery / Deployment |
| **Git Flow** | Branch Strategy (main, develop, feature, release, hotfix) |
| **Conventional Commits** | รูปแบบ Commit Message |
| **Squash Merge** | รวม Commit เป็น 1 |
| **Rebase** | ย้าย Base ของ Branch |
| **Protected Branch** | Branch ที่ห้าม Push ตรง |
| **Path Filter** | รัน CI เฉพาะไฟล์ที่เปลี่ยน |
| **SBOM** | Software Bill of Materials |
| **SAST** | Static Application Security Testing |
| **DAST** | Dynamic Application Security Testing |
| **SCA** | Software Composition Analysis |
| **Blue-Green** | Deploy 2 Environment สลับ |
| **Canary** | Deploy ทีละน้อย |
| **DORA** | DevOps Research and Assessment (Metrics) |
| **Semantic Versioning** | MAJOR.MINOR.PATCH |
| **Feature Flag** | สวิตช์เปิด/ปิด Feature |
| **Monorepo** | หลาย Project ใน Repo เดียว |
| **Pipeline** | ลำดับขั้นตอน CI/CD |
| **Artifact** | ไฟล์ที่ Build ออกมา |

---

## 12.18 ความเชื่อมโยงกับเล่มอื่น

| เล่ม | ความเชื่อมโยงกับเล่ม 12 |
|------|-------------------------|
| **เล่ม 2 (Full-Stack)** | Coding Standards ที่ CI ตรวจ |
| **เล่ม 4 (QA)** | Test ที่รันใน Pipeline |
| **เล่ม 5 (DevOps)** | Infrastructure, Deployment |
| **เล่ม 6 (Code Review)** | Review ก่อน Merge |
| **เล่ม 7 (On-call)** | Incident ที่เกิดจาก Deploy |
| **เล่ม 11 (Hotfix)** | Hotfix Branch Workflow |
| **เล่ม 13 (RCA)** | RCA หลัง Deploy Failure |
| **เล่ม 14 (Security)** | Security Scan ใน Pipeline |

---

## 12.19 สรุปสาระสำคัญ (Key Takeaways)

```text
┌─────────────────────────────────────────────────────────────┐
│                  CI/CD & GIT FLOW                           │
│                     KEY TAKEAWAYS                           │
└─────────────────────────────────────────────────────────────┘

  1. Git Flow — main, develop, feature, release, hotfix
  2. Branch สั้น — ≤ 5 วัน
  3. Commit Atomic — 1 Commit = 1 Change
  4. Conventional Commits — feat, fix, refactor, ...
  5. Squash Merge — Feature → develop
  6. Merge Commit — Release → main
  7. CI ต้องผ่าน — Lint, Test, Scan, Build
  8. Path Filter — รันเฉพาะที่เปลี่ยน
  9. Pipeline เร็ว — ≤ 15 นาที
  10. Security Scan — ทุก PR
  11. Coverage Gate — ≥ 80%
  12. Manual Approval — Prod
  13. Blue-Green — Zero Downtime
  14. Migration — Backup ก่อนเสมอ
  15. Semantic Versioning — v1.2.0
  16. Tag ทุก Release
  17. Merge Back — main → develop
  18. Monitor หลัง Deploy
  19. Rollback Ready — มี Plan
  20. DORA Metrics — วัดผล 4 ตัว
```

---
 