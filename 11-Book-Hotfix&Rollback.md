## 📘 เล่ม 11 (ฉบับขยาย): คู่มือ Hotfix & Rollback

> **หมายเหตุ:** เอกสารนี้เป็นฉบับขยายของเล่ม 11 ใน Master Index โดยเพิ่มรายละเอียดเชิงปฏิบัติสำหรับการแก้ไข Production แบบเร่งด่วน ได้แก่ Hotfix Decision Tree, Approval Workflow, Fast-track Testing, Rollback Strategies (Blue-Green/Canary/K8s/DB), Database Migration Hotfix, Communication Protocol, Verification Checklist, Post-Hotfix Procedures, Templates และ Runbooks รายScenario

---

## 11.0 บทนำและปรัชญา

### 11.0.1 Hotfix vs Normal Fix vs Emergency

```
┌─────────────────────────────────────────────────────────────┐
│           THREE PATHS FOR PRODUCTION ISSUES                 │
└─────────────────────────────────────────────────────────────┘

  Normal Fix              Hotfix                  Emergency Rollback
  ──────────              ──────                  ─────────────────
  • Bug ปกติ              • Bug เร่งด่วน            • ระบบล่ม/วิกฤต
  • ตาม Sprint            • นอก Sprint              • ต้องหยุดเลือดทันที
  • Full Process          • Fast-track              • ทันที
  • 1–2 สัปดาห์           • 1–2 วัน                 • นาที
  • ผ่าน CI/CD เต็ม       • ผ่าน CI/CD บางส่วน      • ข้ามได้ (ตามอำนาจ)
```

### 11.0.2 ปรัชญา 3 ข้อ

| หลักการ | ความหมาย | ผลลัพธ์ |
|---------|----------|---------|
| **Stop the Bleeding First** | หยุดผลกระทบก่อนแก้ Root Cause | ลด Blast Radius |
| **Minimal Change** | เปลี่ยนน้อยที่สุด | ลดความเสี่ยงใหม่ |
| **Rollback Ready** | มีแผนถอยกลับเสมอ | ลดความเสียหาย |

### 11.0.3 ข้อแตกต่างสำคัญ

```
Hotfix ≠ ลัดขั้นตอนทั้งหมด
Hotfix = ลดขั้นตอนที่ไม่จำเป็น แต่คงขั้นตอนที่ป้องกัน Disaster

ต้องมีเสมอ:
  ✅ Code Review (Fast-track)
  ✅ Test (เฉพาะจุด แต่ต้องมี)
  ✅ Staging Deploy (ถ้าเวลาเอื้อ)
  ✅ Backup ก่อน Deploy
  ✅ Monitoring หลัง Deploy

ข้ามได้ (ตามอำนาจ):
  ⚠️ Full Regression (เฉพาะจุด)
  ⚠️ Performance Test (ถ้าไม่กระทบ)
  ⚠️ Documentation (ตามทีหลัง)
```

---

## 11.1 บทบาทและความรับผิดชอบ

### 11.1.1 ผู้เกี่ยวข้องใน Hotfix

| บทบาท | หน้าที่ | อยู่ในทุก Hotfix? |
|-------|---------|:-----------------:|
| **On-call Engineer** | ตรวจพบ, Triage, เสนอ Hotfix | ✅ |
| **Incident Commander (IC)** | ตัดสินใจ Hotfix vs Rollback | ✅ (SEV-1/2) |
| **Hotfix Developer** | เขียน Hotfix | ✅ |
| **Reviewer** | Review Hotfix (Fast-track) | ✅ |
| **QA** | Test เฉพาะจุด | ✅ (ถ้าเวลาเอื้อ) |
| **DevOps** | Deploy, Monitor | ✅ |
| **Approver** | อนุมัติ Deploy | ✅ (ตามระดับ) |
| **Stakeholder** | รับทราบ | ✅ (SEV-1/2) |

### 11.1.2 อำนาจอนุมัติ (Approval Authority)

| ระดับ Hotfix | ผู้อนุมัติ | เงื่อนไข |
|--------------|-----------|----------|
| **Standard Hotfix** | Team Lead | Bug ปกติ, ไม่กระทบ Data |
| **Fast-track Hotfix** | DevOps Lead + Team Lead | SEV-2, กระทบ Business |
| **Emergency Hotfix** | IC + EM (Post-facto OK) | SEV-1, ระบบล่ม |
| **Rollback** | IC (Post-facto) | SEV-1, ต้องหยุดเลือด |
| **DB Rollback** | IC + DBA + EM | มี Data Loss Risk |

> ⚠️ **Post-facto** = อนุมัติทีหลังได้ แต่ต้องแจ้งทันทีและบันทึกเหตุผล

---

## 11.2 Hotfix Decision Tree

```
┌─────────────────────────────────────────────────────────────┐
│                  HOTFIX DECISION TREE                       │
└─────────────────────────────────────────────────────────────┘

  Production Issue Detected
         │
         ▼
  ┌──────────────────┐
  │ Severity?        │
  └────────┬─────────┘
           │
    ┌──────┼──────┬──────┐
   SEV-1  SEV-2  SEV-3  SEV-4
    │      │      │      │
    ▼      ▼      ▼      ▼
  ┌────┐ ┌────┐ ┌────┐ ┌────┐
  │Roll│ │Hot │ │Hot │ │Nor │
  │back│ │fix │ │fix │ │mal │
  │or  │ │Fast│ │Std │ │Fix │
  │Hot │ │trk │ │    │ │    │
  │fix │ │    │ │    │ │    │
  └──┬─┘ └──┬─┘ └──┬─┘ └──┬─┘
     │      │      │      │
     ▼      ▼      ▼      ▼
  ┌─────────────────────────────────┐
  │ ต้องแก้ Code หรือ Config?        │
  └────────────┬────────────────────┘
               │
        ┌──────┴──────┐
      Code          Config
        │              │
        ▼              ▼
  ┌──────────┐   ┌──────────┐
  │Hotfix    │   │Config    │
  │Branch    │   │Change    │
  │          │   │(Fast)    │
  └──────────┘   └──────────┘
```

**คำถามตัดสินใจ 5 ข้อ (ตอบภายใน 5 นาที):**

1. **Rollback ได้ไหม?** — ถ้าได้และปลอดภัย → Rollback ก่อน
2. **Hotfix ใช้เวลาเท่าไหร่?** — ถ้า > 1 ชั่วโมง และ Rollback ได้ → Rollback
3. **กระทบ Data ไหม?** — ถ้าใช่ → ต้อง DBA + Backup
4. **มี Workaround ไหม?** — ถ้ามี → ใช้ก่อน แล้ว Hotfix ตาม
5. **ต้อง Fast-track แค่ไหน?** — ตาม Severity

---

## 11.3 Hotfix Workflow (ละเอียด)

### 11.3.1 Standard Hotfix Workflow

```
┌─────────────────────────────────────────────────────────────┐
│              STANDARD HOTFIX WORKFLOW                       │
└─────────────────────────────────────────────────────────────┘

  Step 1: ตรวจพบ + Triage
         │  (On-call, ≤ 5 นาที)
         ▼
  Step 2: ตัดสินใจ Hotfix (ไม่ใช่ Rollback)
         │  (IC + Team Lead)
         ▼
  Step 3: สร้าง hotfix/* branch จาก main
         │  (Developer)
         ▼
  Step 4: แก้ไข (Minimal Change)
         │  (Developer)
         ▼
  Step 5: Test เฉพาะจุด (Fast-track)
         │  (Developer + QA ถ้ามี)
         ▼
  Step 6: Code Review (Fast-track)
         │  (Reviewer, ≤ 30 นาที)
         ▼
  Step 7: Deploy Staging + Smoke Test
         │  (DevOps)
         ▼
  Step 8: Approve + Deploy Production
         │  (Approver + DevOps)
         ▼
  Step 9: Monitor (≥ 30 นาที)
         │  (On-call + DevOps)
         ▼
  Step 10: Merge back to develop + main
         │  (Developer)
         ▼
  Step 11: Post-mortem + RCA
         │  (ทีม, ≤ 48 ชม.)
         ▼
  Step 12: Permanent Fix (ถ้าจำเป็น)
```

### 11.3.2 Fast-track Hotfix Workflow (SEV-2)

```
  Step 1: ตรวจพบ (On-call)
         │  ≤ 5 นาที
         ▼
  Step 2: IC ประกาศ Hotfix
         │  ทันที
         ▼
  Step 3: Developer สร้าง Branch + แก้
         │  ≤ 30 นาที
         ▼
  Step 4: Reviewer Review (1 คน)
         │  ≤ 15 นาที
         ▼
  Step 5: Deploy Staging + Smoke (ถ้าเวลาเอื้อ)
         │  ≤ 15 นาที
         ▼
  Step 6: Deploy Prod + Monitor
         │  ทันที
         ▼
  Step 7: Merge back + Post-mortem
```

### 11.3.3 Emergency Hotfix (SEV-1 — ระบบล่ม)

```
  Step 1: ตรวจพบ
         │
         ▼
  Step 2: IC ตัดสินใจ: Rollback หรือ Hotfix?
         │
    ┌────┴────┐
  Rollback  Hotfix
    │         │
    ▼         ▼
  ทันที    Developer แก้ (Pair)
  ≤ 1 นาที  ≤ 15 นาที
    │         │
    │         ▼
    │    Reviewer Review (ทันที)
    │         │
    │         ▼
    │    Deploy Prod (ข้าม Staging ถ้าจำเป็น)
    │         │
    └────┬────┘
         ▼
  Monitor + Post-facto Approval
         │
         ▼
  Merge back + RCA (≤ 24 ชม.)
```

---

## 11.4 Hotfix Branch Management

### 11.4.1 Branch Strategy

```
main (production)
├── hotfix/v1.0.1-fix-payment-timeout    ← สร้างจาก main
├── hotfix/v1.0.2-fix-null-email         ← สร้างจาก main
└── develop (staging)
```

### 11.4.2 Branch Naming Convention

| รูปแบบ | ตัวอย่าง | ใช้เมื่อ |
|--------|----------|----------|
| `hotfix/<version>-<desc>` | `hotfix/v1.0.1-fix-payment` | Standard |
| `hotfix/SEV1-<desc>` | `hotfix/SEV1-db-connection` | Emergency |
| `hotfix/<ticket>-<desc>` | `hotfix/PMS-301-timeout` | มี Ticket |

### 11.4.3 คำสั่ง Git (ครบถ้วน)

```bash
# 1. สร้าง Hotfix Branch จาก main (เสมอ)
git checkout main
git pull origin main
git checkout -b hotfix/v1.0.1-fix-payment-timeout

# 2. แก้ไข (Minimal Change)
# ... แก้ code ...

# 3. Test เฉพาะจุด
pytest pkg/payment/service_test.py -v
npm test -- payment.test.ts

# 4. Commit (Atomic, อธิบายชัด)
git add pkg/payment/service.py
git commit -m "fix(payment): increase timeout 10s → 30s

Fixes: #PMS-301
Severity: SEV-2
Impact: Payment failures affecting 15% transactions
Root Cause: Oracle ERP response time > 10s during peak

Reviewed-by: [Reviewer]
Approved-by: [IC]"

# 5. Push
git push origin hotfix/v1.0.1-fix-payment-timeout

# 6. สร้าง PR (Fast-track)
gh pr create --base main --head hotfix/v1.0.1-fix-payment-timeout \
  --title "[HOTFIX] fix payment timeout" \
  --body "See commit message"

# 7. หลัง Merge → Tag Version
git checkout main
git pull origin main
git tag -a v1.0.1 -m "Hotfix: payment timeout"
git push origin v1.0.1

# 8. Merge back to develop (สำคัญมาก!)
git checkout develop
git pull origin develop
git merge --no-ff v1.0.1
git push origin develop
```

### 11.4.4 ข้อห้ามใน Hotfix Branch

| ❌ ห้าม | เหตุผล |
|--------|--------|
| สร้างจาก `develop` | อาจมี Feature ที่ยังไม่พร้อม |
| เปลี่ยนหลายอย่าง | เพิ่มความเสี่ยง |
| Refactor | ไม่ใช่เวลา |
| Upgrade Dependency | เพิ่มความเสี่ยง |
| แก้ Formatting | Noise |
| Merge Feature Branch | ปนเปื้อน |

---

## 11.5 Fast-track Testing

### 11.5.1 Testing Matrix ตาม Severity

| Severity | Unit Test | Integration | Smoke | Regression | E2E | Staging |
|----------|:---------:|:-----------:|:-----:|:----------:|:---:|:-------:|
| **SEV-1** | ✅ เฉพาะจุด | ⚠️ ถ้ามีเวลา | ✅ | ❌ | ❌ | ⚠️ ถ้าจำเป็น |
| **SEV-2** | ✅ เฉพาะจุด | ✅ | ✅ | ⚠️ เฉพาะจุด | ❌ | ✅ |
| **SEV-3** | ✅ | ✅ | ✅ | ✅ เฉพาะจุด | ⚠️ | ✅ |
| **SEV-4** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

### 11.5.2 Smoke Test Checklist (5 นาที)

```markdown
# Smoke Test Checklist — Hotfix [Version]

## Critical Paths
- [ ] Health Check: GET /health → 200
- [ ] Login: SSO → Dashboard
- [ ] Core Feature ที่แก้: [ระบุ] → ทำงานได้
- [ ] Core Feature ที่เกี่ยวข้อง: [ระบุ] → ไม่พัง
- [ ] Database: Connection OK
- [ ] External Integration: [ระบุ] → OK

## Monitoring
- [ ] Error Rate < 1%
- [ ] Latency < 1s (P95)
- [ ] No OOMKilled
- [ ] No CrashLoopBackOff

## Verification
- [ ] Log ไม่มี Error ใหม่
- [ ] Metric กลับปกติ
- [ ] User Report (ถ้ามี) → แก้แล้ว
```

### 11.5.3 Test ที่ต้องมีเสมอ (แม้เร่งด่วน)

- ✅ **Test ที่ Reproduce Bug** — ยืนยันว่า Bug หาย
- ✅ **Test ที่ Critical Path** — ยืนยันว่า Core ยังทำงาน
- ✅ **Smoke Test** — ยืนยันว่า Deploy สำเร็จ

### 11.5.4 Test ที่ Skip ได้ (ตามอำนาจ)

- ⚠️ **Full Regression** — ถ้า Hotfix แคบมาก
- ⚠️ **Performance Test** — ถ้าไม่กระทบ Performance
- ⚠️ **E2E Test** — ถ้าเวลาไม่พอ (ชดเชยด้วย Manual Smoke)

---

## 11.6 Rollback Strategies (Deep Dive)

### 11.6.1 Rollback Decision Matrix (ขยาย)

| Severity | อาการ | กลยุทธ์ | ผู้อนุมัติ | เวลา | Data Loss Risk |
|----------|-------|---------|-----------|------|:--------------:|
| **SEV-1** | ระบบล่ม / >50% Error | Blue-Green Switch | IC (Post-facto) | < 1 นาที | ❌ |
| **SEV-1** | Data Corruption | DB Restore + App Rollback | IC + DBA + EM | 15–60 นาที | ⚠️ สูง |
| **SEV-2** | >10% Error | K8s Rollback | DevOps Lead | 5–10 นาที | ❌ |
| **SEV-2** | Feature หลักเสีย | Redeploy Previous | Team Lead | 10–20 นาที | ❌ |
| **SEV-3** | <10% Error | Redeploy Previous | Team Lead | 15–30 นาที | ❌ |
| **SEV-4** | Minor | Schedule Fix | PO | Next Deploy | ❌ |

### 11.6.2 Rollback Strategy Comparison

| Strategy | ข้อดี | ข้อเสีย | ใช้เมื่อ |
|----------|-------|---------|----------|
| **Blue-Green** | เร็ว (< 1 นาที), Zero Downtime | ต้องมี 2 Environment | SEV-1 |
| **Canary** | ค่อยๆ ลดความเสี่ยง | ช้ากว่า | SEV-2 |
| **K8s Rolling** | ง่าย, Built-in | ช้ากว่า Blue-Green | SEV-2/3 |
| **Redeploy Previous** | ง่าย, ชัวร์ | Downtime สั้น | SEV-3/4 |
| **Feature Flag** | ไม่ต้อง Deploy | ต้องมี Flag | ทุก Severity |
| **DB Rollback** | แก้ Data | เสี่ยง Data Loss | Data Issue |

### 11.6.3 Blue-Green Rollback

```
┌─────────────────────────────────────────────────────────────┐
│                  BLUE-GREEN ROLLBACK                        │
└─────────────────────────────────────────────────────────────┘

  ┌──────────────┐         ┌──────────────┐
  │    BLUE      │         │    GREEN     │
  │  (v1.0.0)    │         │  (v1.0.1)    │
  │  ✅ Stable   │         │  ❌ Bug      │
  └──────┬───────┘         └──────┬───────┘
         │                        │
         └────────┬───────────────┘
                  │
                  ▼
         ┌────────────────┐
         │  Load Balancer │
         │  (Selector)    │
         └────────────────┘
                  │
         ก่อน: → GREEN (v1.0.1)
         Rollback: → BLUE (v1.0.0) ทันที
```

**คำสั่ง:**

```bash
# ตรวจสอบสถานะปัจจุบัน
kubectl get service pms-api -n production -o jsonpath='{.spec.selector.version}'
# Output: green

# Rollback ไป Blue
kubectl patch service pms-api -n production \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/selector/version", "value": "blue"}]'

# ตรวจสอบ
kubectl get service pms-api -n production -o jsonpath='{.spec.selector.version}'
# Output: blue

# ตรวจสอบ Health
kubectl get pods -n production -l version=blue
curl https://pms.your-company.com/health
```

**ข้อควรระวัง:**
- ⚠️ Blue ต้องยัง Run อยู่ (ไม่ลบ)
- ⚠️ Database Schema ต้อง Compatible ทั้ง 2 Versions
- ⚠️ Session ต้องไม่ผูกกับ Version

### 11.6.4 Kubernetes Rollback

```bash
# ดู History
kubectl rollout history deployment/pms-api -n production

# Output:
# REVISION  CHANGE-CAUSE
# 1         Initial deploy
# 2         feat: add employee API
# 3         hotfix: fix payment timeout (BUG!)

# Rollback ไป Revision ก่อนหน้า
kubectl rollout undo deployment/pms-api -n production

# หรือระบุ Revision
kubectl rollout undo deployment/pms-api -n production --to-revision=1

# ตรวจสอบสถานะ
kubectl rollout status deployment/pms-api -n production

# ตรวจสอบ Pod
kubectl get pods -n production -l app=pms-api
```

**ข้อควรระวัง:**
- ⚠️ `rollout undo` จะย้อน Image + Config ทั้งหมด
- ⚠️ ถ้ามี DB Migration → ต้อง Rollback DB ด้วย (ถ้าจำเป็น)
- ⚠️ ตรวจสอบ `CHANGE-CAUSE` ให้ดีก่อน Undo

### 11.6.5 Canary Rollback

```
┌─────────────────────────────────────────────────────────────┐
│                    CANARY ROLLBACK                          │
└─────────────────────────────────────────────────────────────┘

  ┌──────────────────────────────────────┐
  │  Production Traffic                   │
  └──────────┬───────────────────────────┘
             │
      ┌──────┴──────┐
      │             │
      ▼             ▼
  ┌────────┐   ┌────────┐
  │ Stable │   │ Canary │
  │  (95%) │   │  (5%)  │
  │ v1.0.0 │   │ v1.0.1 │
  │   ✅   │   │   ❌   │
  └────────┘   └────────┘

  Rollback: ลด Canary → 0%, คง Stable 100%
  คำสั่ง: kubectl scale deployment/pms-api-canary --replicas=0
```

**คำสั่ง:**

```bash
# ลด Canary เป็น 0
kubectl scale deployment/pms-api-canary -n production --replicas=0

# หรือเปลี่ยน Traffic Split
kubectl patch virtualservice pms-api -n production \
  --type='merge' \
  -p='{"spec":{"http":[{"route":[{"destination":{"host":"pms-api-stable"},"weight":100}]}]}}'

# ลบ Canary Deployment
kubectl delete deployment pms-api-canary -n production
```

### 11.6.6 Feature Flag Rollback

```python
# ตัวอย่าง: ปิด Feature ด้วย Flag (ไม่ต้อง Deploy)
# config/features.yaml
features:
  new_payment_flow:
    enabled: false        # ← เปลี่ยนเป็น false ทันที
    rollout_percentage: 0
```

```bash
# ถ้าใช้ LaunchDarkly / Unleash / ConfigMap
# ผ่าน UI หรือ CLI:
unleash toggle new_payment_flow off

# หรือแก้ ConfigMap
kubectl edit configmap feature-flags -n production
# เปลี่ยน enabled: "false"
kubectl rollout restart deployment/pms-api -n production
```

**ข้อดี:** ไม่ต้อง Deploy, เร็วมาก (< 1 นาที)
**ข้อเสีย:** ต้องมี Flag ตั้งแต่แรก

### 11.6.7 Database Rollback

```
┌─────────────────────────────────────────────────────────────┐
│                  DATABASE ROLLBACK                          │
└─────────────────────────────────────────────────────────────┘

  ⚠️ ระวัง: DB Rollback = Data Loss Risk สูง
  ⚠️ ต้องมี Backup + DBA อนุมัติเสมอ
```

**ขั้นตอน:**

```bash
# 1. หยุด Traffic (Scale Down App)
kubectl scale deployment/pms-api -n production --replicas=0

# 2. Backup Current State (ก่อน Rollback)
pg_dump -h $DB_HOST -U $DB_USER -d pms_prod > backup_before_rollback_$(date +%Y%m%d_%H%M%S).sql

# 3. ตรวจสอบ Backup ที่จะ Restore
ls -lh backup_*.sql | tail -5

# 4. Restore Backup
psql -h $DB_HOST -U $DB_USER -d pms_prod < backup_20241118_0200.sql

# 5. ตรวจสอบ Data
psql -h $DB_HOST -U $DB_USER -d pms_prod -c "SELECT COUNT(*) FROM employees;"

# 6. Rollback App Version (ให้ตรงกับ Schema)
kubectl rollout undo deployment/pms-api -n production

# 7. Scale Up App
kubectl scale deployment/pms-api -n production --replicas=3

# 8. Monitor
kubectl rollout status deployment/pms-api -n production
```

**ข้อควรระวัง:**
- ⚠️ Data ที่เกิดหลัง Backup จะหาย
- ⚠️ ต้องแจ้ง Stakeholder ก่อน Restore
- ⚠️ ต้องมี DBA ดูแล
- ⚠️ ต้อง Backup Current ก่อน Restore (เผื่อ Rollback ซ้ำ)

### 11.6.8 Migration Rollback (Down Migration)

```python
# database/migrations/20241118_add_unique_email.py
def upgrade():
    op.create_index("employees", "email", unique=True)

def downgrade():
    op.drop_index("idx_employees_email", "employees")
```

```bash
# Rollback Migration
migrate -path ./migrations -database $DB_URL down 1

# ตรวจสอบ Version
migrate -path ./migrations -database $DB_URL version
```

**ข้อควรระวัง:**
- ⚠️ ต้องมี `downgrade()` ทุก Migration
- ⚠️ ต้อง Test Downgrade ก่อน Deploy Upgrade
- ⚠️ Migration ที่ลบ Column → Data หาย (ต้อง Backup)

---

## 11.7 Communication Protocol

### 11.7.1 Communication Matrix

| ช่วง | ผู้ส่ง | ผู้รับ | ช่องทาง | เนื้อหา |
|------|-------|-------|---------|---------|
| **ตรวจพบ** | On-call | IC + Team | Slack #incident | "ตรวจพบ X, กำลัง Triage" |
| **ตัดสินใจ Hotfix** | IC | ทีม + Stakeholder | Slack #incident | "จะ Hotfix, ETA 30 นาที" |
| **ระหว่างทำ** | IC | ทุกคน | Slack #incident | Update ทุก 15 นาที |
| **ก่อน Deploy** | DevOps | IC + Stakeholder | Slack #incident | "จะ Deploy, อนุมัติ?" |
| **หลัง Deploy** | DevOps | ทุกคน | Slack #incident | "Deploy สำเร็จ, Monitor" |
| **Resolved** | IC | ทุกคน | Slack + Email | Resolution Notice |
| **Post-mortem** | IC | ทุกคน | Email + Meeting | RCA Report |

### 11.7.2 Hotfix Announcement Template

```markdown
🔧 **HOTFIX IN PROGRESS — [INC-XXX]**

**Severity:** SEV-X
**Version:** v1.0.1
**Branch:** `hotfix/v1.0.1-fix-[desc]`
**Developer:** [ชื่อ]
**Reviewer:** [ชื่อ]
**ETA:** [HH:MM]

**Root Cause (เบื้องต้น):**
[สรุป]

**Fix:**
[สิ่งที่แก้]

**Impact during Hotfix:**
[Downtime? Feature ไหนกระทบ?]

**Status:**
- [ ] Coding
- [ ] Testing
- [ ] Reviewing
- [ ] Staging Deploy
- [ ] Prod Deploy
- [ ] Monitoring
```

### 11.7.3 Deploy Approval Template

```markdown
🚀 **DEPLOY APPROVAL REQUEST — [INC-XXX]**

**Version:** v1.0.1
**Environment:** Production
**Deploy Method:** [Blue-Green / K8s / Canary]

**Pre-Deploy Checklist:**
- [x] Code Review Approved
- [x] Smoke Test Staging ผ่าน
- [x] Backup DB แล้ว (ถ้ามี DB Change)
- [x] Rollback Plan พร้อม
- [x] Monitoring เปิดอยู่

**Rollback Plan:**
- Method: [K8s Rollback / Blue-Green Switch]
- Time: [< 5 นาที]
- Trigger: Error Rate > 5%

**Approver:** @[ชื่อ]
**Requested by:** @[ชื่อ]
```

---

## 11.8 Verification Checklist (หลัง Hotfix)

### 11.8.1 ทันทีหลัง Deploy (0–5 นาที)

- [ ] Health Check: `/health` → 200
- [ ] Pod Status: ทุก Pod Running
- [ ] Error Rate: < 1%
- [ ] Latency: P95 < 1s
- [ ] Log: ไม่มี Error ใหม่
- [ ] Smoke Test: Critical Path ผ่าน

### 11.8.2 ภายใน 30 นาที

- [ ] User Report Issue: แก้แล้ว (ถ้ามี)
- [ ] Metric: กลับปกติ
- [ ] Alert: ไม่มี Alert ใหม่
- [ ] Integration: External API OK
- [ ] Database: Connection OK
- [ ] User Feedback: ไม่มี Report ใหม่

### 11.8.3 ภายใน 2 ชั่วโมง

- [ ] ยืนยันเสถียร: Error Rate ปกติต่อเนื่อง
- [ ] ไม่มี Regression: Feature อื่นยังทำงาน
- [ ] ไม่มี Data Issue: ข้อมูลถูกต้อง
- [ ] แจ้ง Stakeholder: Resolved
- [ ] Merge back to develop: เรียบร้อย

### 11.8.4 Verification Template

```markdown
# Hotfix Verification — v1.0.1

**Incident:** INC-XXX
**Deployed:** [YYYY-MM-DD HH:MM]
**Verified by:** [ชื่อ]

## Immediate (T+5 min)
| Check | Result | Note |
|-------|--------|------|
| Health Check | ✅ 200 | — |
| Pod Status | ✅ 3/3 | — |
| Error Rate | ✅ 0.2% | — |
| Latency P95 | ✅ 450ms | — |
| Log | ✅ No new error | — |

## Short-term (T+30 min)
| Check | Result | Note |
|-------|--------|------|
| User Report | ✅ Fixed | Confirmed by user |
| Alert | ✅ No new alert | — |
| Integration | ✅ OK | Oracle ERP OK |

## Medium-term (T+2h)
| Check | Result | Note |
|-------|--------|------|
| Stability | ✅ Stable | 2h no issue |
| Regression | ✅ No issue | — |
| Data Integrity | ✅ OK | Verified with Finance |

## Verdict
✅ **RESOLVED** — Hotfix สำเร็จ

## Notes
- Merge back to develop: ✅ Done (commit abc123)
- Tag: v1.0.1
- Post-mortem: Scheduled 2024-11-20
```

---

## 11.9 Post-Hotfix Procedures

### 11.9.1 Timeline หลัง Hotfix

```
┌─────────────────────────────────────────────────────────────┐
│              POST-HOTFIX TIMELINE                           │
└─────────────────────────────────────────────────────────────┘

  T+0:      Deploy สำเร็จ
            │
  T+30 min: ยืนยันเสถียรเบื้องต้น
            │
  T+1 hr:   แจ้ง Stakeholder (Resolved)
            │
  T+2 hr:   Merge back to develop
            │
  T+1 day:  อัปเดต Runbook + Monitoring
            │
  T+2 day:  RCA เสร็จ
            │
  T+1 wk:   Permanent Fix (ถ้าจำเป็น)
            │
  T+1 mo:   Review + Lessons Learned
```

### 11.9.2 Merge Back Checklist

- [ ] Merge `hotfix/*` → `main` (ถ้ายังไม่ Merge)
- [ ] Tag version (`v1.0.1`)
- [ ] Merge `main` → `develop` (สำคัญที่สุด!)
- [ ] Push ทั้ง 2 Branch
- [ ] ตรวจสอบ CI ผ่านทั้ง 2 Branch
- [ ] แจ้งทีมว่า Merge back เสร็จ

```bash
# Merge back to develop
git checkout develop
git pull origin develop
git merge --no-ff v1.0.1
git push origin develop

# ตรวจสอบ
git log --oneline -5 develop
```

### 11.9.3 Runbook Update Checklist

- [ ] อัปเดต Runbook ของ Scenario ที่เกิด
- [ ] เพิ่ม Alert ที่จับปัญหานี้
- [ ] เพิ่ม Monitoring ที่เกี่ยวข้อง
- [ ] เพิ่ม Test ที่ป้องกัน Regression
- [ ] อัปเดต Documentation
- [ ] แชร์บทเรียนกับทีม

### 11.9.4 RCA Integration

Hotfix ทุกครั้งต้องมี RCA (ตามเล่ม 13):

- [ ] RCA ภายใน 48 ชั่วโมง
- [ ] Root Cause ชัดเจน
- [ ] Preventive Action ระบุ
- [ ] Owner + Due Date
- [ ] ติดตามจนเสร็จ

---

## 11.10 Templates (ครบชุด)

### 11.10.1 Hotfix Request Template

```markdown
# Hotfix Request: HF-001

**Date:** [YYYY-MM-DD HH:MM]
**Requested by:** [ชื่อ]
**Severity:** [SEV-1/2/3]
**Incident:** [INC-XXX]

## Problem
[อธิบายปัญหา + Impact]

## Root Cause
[สาเหตุ]

## Proposed Fix
[วิธีแก้]

## Scope of Change
- Files: [รายการ]
- Lines: [จำนวน]
- Risk: [Low/Medium/High]

## Testing Plan
- [ ] Reproduce Bug Test
- [ ] Critical Path Test
- [ ] Smoke Test
- [ ] Regression (เฉพาะจุด)

## Rollback Plan
- Method: [K8s / Blue-Green / Feature Flag]
- Time: [< 5 นาที]
- Trigger: [Error Rate > X%]

## Approval
| Role | Name | Status |
|------|------|--------|
| Team Lead | [ชื่อ] | ⏳ |
| DevOps Lead | [ชื่อ] | ⏳ |
| IC | [ชื่อ] | ⏳ |
```

### 11.10.2 Rollback Plan Template

```markdown
# Rollback Plan: RB-001

**For Hotfix:** v1.0.1
**Date:** [YYYY-MM-DD]

## Trigger Conditions
Rollback เมื่อ:
- [ ] Error Rate > 5% ต่อเนื่อง 5 นาที
- [ ] Latency P95 > 5s
- [ ] User Report > 10 รายใน 15 นาที
- [ ] Data Corruption detected
- [ ] IC สั่ง

## Rollback Method
**Primary:** [K8s Rollback / Blue-Green Switch]

```bash
kubectl rollout undo deployment/pms-api -n production
```

**Alternative:** [Feature Flag]
```bash
unleash toggle new_payment_flow off
```

**Last Resort:** [DB Restore]
```bash
./scripts/database-rollback.sh production <backup-id>
```

## Pre-Rollback Checklist
- [ ] แจ้ง Stakeholder
- [ ] Backup Current State
- [ ] หยุด Traffic (ถ้าจำเป็น)
- [ ] เตรียม Communication

## Post-Rollback Checklist
- [ ] Health Check
- [ ] Smoke Test
- [ ] Monitor 30 นาที
- [ ] แจ้ง Stakeholder
- [ ] บันทึก Timeline

## Verification
- [ ] Error Rate กลับปกติ
- [ ] User Report หยุด
- [ ] Metric กลับปกติ

## Owner
- **Rollback Lead:** [ชื่อ]
- **Approver:** [ชื่อ]
```

### 11.10.3 Post-Hotfix Report Template

```markdown
# Post-Hotfix Report: HF-001

**Hotfix Version:** v1.0.1
**Incident:** INC-XXX
**Deployed:** [YYYY-MM-DD HH:MM]
**Resolved:** [YYYY-MM-DD HH:MM]

## Summary
[สรุป 2-3 ประโยค]

## Timeline
| เวลา | เหตุการณ์ | ผู้รับผิดชอบ |
|------|----------|-------------|
| HH:MM | ตรวจพบ | On-call |
| HH:MM | ตัดสินใจ Hotfix | IC |
| HH:MM | สร้าง Branch | Dev |
| HH:MM | Review | Reviewer |
| HH:MM | Deploy Staging | DevOps |
| HH:MM | Deploy Prod | DevOps |
| HH:MM | Resolved | IC |

## Root Cause
[สาเหตุ]

## Fix Applied
[สิ่งที่แก้]

## Impact
- Duration: [X นาที]
- Users affected: [จำนวน]
- Transactions failed: [จำนวน]
- Data loss: [ไม่มี / มี]

## Verification
- [x] Health Check
- [x] Smoke Test
- [x] Monitor 2 ชั่วโมง
- [x] No Regression

## Lessons Learned
- [บทเรียน 1]
- [บทเรียน 2]

## Preventive Actions
| # | Action | Owner | Due |
|---|--------|-------|-----|
| 1 | เพิ่ม Alert | DevOps | [Date] |
| 2 | เพิ่ม Test | Dev | [Date] |
| 3 | อัปเดต Runbook | IC | [Date] |

## Merge Back
- [x] main → develop: commit abc123
- [x] Tag: v1.0.1
- [x] CI: ผ่าน
```

---

## 11.11 Runbooks รายScenario (Hotfix & Rollback)

### 11.11.1 Runbook: Rollback Payment API (SEV-1)

```markdown
# Runbook: Rollback Payment API

## Trigger
- Payment Error Rate > 50%
- Payment ล่มทั้งระบบ
- Data Corruption ใน Payment

## Decision (≤ 2 นาที)
1. Rollback ได้ไหม? → YES (K8s Rollback พร้อม)
2. Hotfix ใช้เวลา? → > 30 นาที
→ **ROLLBACK ทันที**

## Steps

### Step 1: แจ้ง IC + Stakeholder (30 วินาที)
```
🚨 ROLLBACK INITIATED — Payment API
Reason: Error Rate > 50%
Method: K8s Rollback
ETA: 2 นาที
```

### Step 2: Rollback (1 นาที)
```bash
kubectl rollout undo deployment/pms-api -n production
kubectl rollout status deployment/pms-api -n production
```

### Step 3: Verify (2 นาที)
```bash
curl https://pms.your-company.com/health
kubectl get pods -n production -l app=pms-api
# ตรวจสอบ Error Rate ใน Grafana
```

### Step 4: แจ้งผล
```
✅ ROLLBACK COMPLETE
Error Rate: 50% → 0.5%
Users: กลับใช้งานได้
```

### Step 5: Post-Rollback
- [ ] Monitor 30 นาที
- [ ] แจ้ง Stakeholder
- [ ] บันทึก Timeline
- [ ] Schedule RCA

## Escalation
- Rollback ไม่สำเร็จ → IC + EM + Architect
- มี Data Loss → DBA + EM
```

### 11.11.2 Runbook: Hotfix Null Email (SEV-2)

```markdown
# Runbook: Hotfix Null Email Bug

## Trigger
- POST /employee ด้วย email = null → 500 Error
- User Report > 5 ราย

## Decision
- Rollback? → ไม่ได้ (Feature ใหม่ ยังไม่มี Previous)
- Hotfix? → YES (แก้ Validation)
- ETA: 30 นาที

## Steps

### Step 1: สร้าง Branch
```bash
git checkout main && git pull
git checkout -b hotfix/v1.0.2-fix-null-email
```

### Step 2: แก้ Code (5 นาที)
```python
# pkg/employee/schemas.py
from pydantic import BaseModel, EmailStr, Field, field_validator

class EmployeeCreate(BaseModel):
    full_name: str = Field(..., min_length=1, max_length=255)
    email: EmailStr

    @field_validator('email', mode='before')
    @classmethod
    def email_not_none(cls, v):
        if v is None or (isinstance(v, str) and not v.strip()):
            raise ValueError('email is required')
        return v.strip().lower()
```

### Step 3: Test (5 นาที)
```bash
pytest pkg/employee/schemas_test.py -v
# ต้องผ่าน test_null_email, test_empty_email
```

### Step 4: Review + Deploy (15 นาที)
- Reviewer: 1 คน
- Deploy Staging + Smoke
- Deploy Prod

### Step 5: Verify
- [ ] POST ด้วย null → 400 (ไม่ใช่ 500)
- [ ] POST ด้วย email ปกติ → 201
- [ ] Error Rate กลับปกติ

## Merge Back
```bash
git checkout develop
git merge --no-ff v1.0.2
git push origin develop
```
```

### 11.11.3 Runbook: Rollback DB Migration (SEV-1)

```markdown
# Runbook: Rollback DB Migration

## Trigger
- Migration ใหม่ทำให้ Data หาย
- Schema ไม่ Compatible กับ App
- Performance วิกฤตหลัง Migration

## ⚠️ ระวัง: Data Loss Risk สูง

## Steps

### Step 1: หยุด Traffic (1 นาที)
```bash
kubectl scale deployment/pms-api -n production --replicas=0
```

### Step 2: แจ้ง Stakeholder
```
🚨 DB ROLLBACK IN PROGRESS
Reason: [ระบุ]
Impact: ระบบหยุดชั่วคราว 15-60 นาที
Data: [จะหายเฉพาะที่เกิดหลัง Backup]
```

### Step 3: Backup Current (5 นาที)
```bash
pg_dump -h $DB_HOST -U $DB_USER -d pms_prod > backup_before_rollback_$(date +%Y%m%d_%H%M%S).sql
```

### Step 4: Rollback Migration (5 นาที)
```bash
migrate -path ./migrations -database $DB_URL down 1
migrate -path ./migrations -database $DB_URL version
```

### Step 5: ตรวจสอบ Schema
```bash
psql -h $DB_HOST -U $DB_USER -d pms_prod -c "\d employees"
```

### Step 6: Rollback App
```bash
kubectl rollout undo deployment/pms-api -n production
```

### Step 7: Scale Up
```bash
kubectl scale deployment/pms-api -n production --replicas=3
kubectl rollout status deployment/pms-api -n production
```

### Step 8: Verify
- [ ] Health Check
- [ ] Data Integrity (กับ Finance)
- [ ] Smoke Test
- [ ] Monitor 1 ชั่วโมง

## Post-Rollback
- [ ] แจ้ง Stakeholder
- [ ] RCA ทันที (≤ 24 ชม.)
- [ ] ตรวจสอบ Data ที่หาย
- [ ] วางแผนกู้คืน Data (ถ้าจำเป็น)
```

### 11.11.4 Runbook: Feature Flag Kill Switch

```markdown
# Runbook: Feature Flag Kill Switch

## Trigger
- Feature ใหม่ทำให้ Error
- ต้องหยุด Feature ทันที (ไม่ต้อง Deploy)

## Steps (≤ 1 นาที)

### Step 1: ปิด Flag
```bash
# Unleash
unleash toggle new_payment_flow off

# หรือ LaunchDarkly
ldcli flags update new_payment_flow --on false

# หรือ ConfigMap
kubectl edit configmap feature-flags -n production
# เปลี่ยน enabled: "false"
kubectl rollout restart deployment/pms-api -n production
```

### Step 2: Verify
- [ ] Feature ปิดจริง (ทดสอบ)
- [ ] Error Rate กลับปกติ
- [ ] Core Feature ยังทำงาน

### Step 3: แจ้ง
```
✅ FEATURE FLAG OFF
Feature: new_payment_flow
Reason: [ระบุ]
Impact: Feature ถูกปิด, Core ยังทำงาน
Next: RCA + Fix
```

## ข้อดี
- ไม่ต้อง Deploy
- เร็วมาก (< 1 นาที)
- ไม่มี Downtime

## ข้อควรระวัง
- ⚠️ ต้องมี Flag ตั้งแต่แรก
- ⚠️ ต้องทดสอบ Flag ก่อน Production
```

---

## 11.12 KPIs สำหรับ Hotfix & Rollback

| KPI | คำนิยาม | เป้าหมาย | วิธีวัด |
|-----|---------|----------|---------|
| **Hotfix Frequency** | จำนวน Hotfix/เดือน | ≤ 3 | Git tags |
| **Hotfix Lead Time** | เวลาจากตรวจพบถึง Deploy | ≤ 2 ชั่วโมง | Incident log |
| **Hotfix Success Rate** | % Hotfix ที่สำเร็จครั้งแรก | ≥ 90% | Incident log |
| **Rollback Rate** | % Deploy ที่ต้อง Rollback | < 5% | Deploy log |
| **Rollback Time** | เวลาจากตัดสินใจถึง Rollback เสร็จ | ≤ 5 นาที | Incident log |
| **MTTR (Hotfix)** | เวลาแก้เฉลี่ย | ≤ 2 ชั่วโมง | Incident log |
| **Repeat Hotfix** | % Hotfix ที่ต้องแก้ซ้ำ | < 10% | Incident log |
| **Merge Back Compliance** | % ที่ Merge กลับ develop | 100% | Git audit |
| **RCA Completion** | % ที่ RCA เสร็จ ≤ 48 ชม. | 100% | RCA log |
| **Post-Deploy Incident** | % ที่มี Incident หลัง Hotfix | < 5% | Monitoring |

---

## 11.13 Anti-Patterns (ข้อห้าม)

### 11.13.1 Hotfix Anti-Patterns

| # | ❌ Anti-Pattern | ผลกระทบ | ✅ ควรทำ |
|---|----------------|---------|----------|
| 1 | สร้าง Hotfix จาก `develop` | ปนเปื้อน Feature ที่ยังไม่พร้อม | สร้างจาก `main` เสมอ |
| 2 | เปลี่ยนหลายอย่างใน Hotfix เดียว | เพิ่มความเสี่ยง, ยาก Rollback | Minimal Change |
| 3 | Refactor ใน Hotfix | เสี่ยง Bug ใหม่ | Refactor แยก |
| 4 | Upgrade Dependency | เสี่ยง Breaking Change | แยก Branch |
| 5 | ไม่มี Test | บั๊กหลุด | Test เฉพาะจุด |
| 6 | ข้าม Code Review | Bug ใหม่ | Review 1 คน (Fast-track) |
| 7 | Deploy Prod ทันที | ไม่มี Safety Net | Staging ก่อน (ถ้าเวลาเอื้อ) |
| 8 | ไม่ Backup ก่อน Deploy | กู้คืนไม่ได้ | Backup เสมอ (ถ้ามี DB) |
| 9 | ไม่มี Rollback Plan | แก้ไม่ได้ถ้าพัง | มี Plan ทุกครั้ง |
| 10 | ลืม Merge กลับ develop | Feature หาย | Merge back ทันที |
| 11 | ไม่ Monitor หลัง Deploy | ไม่รู้ว่าพัง | Monitor ≥ 30 นาที |
| 12 | ไม่มี RCA | เกิดซ้ำ | RCA ≤ 48 ชม. |

### 11.13.2 Rollback Anti-Patterns

| # | ❌ Anti-Pattern | ผลกระทบ | ✅ ควรทำ |
|---|----------------|---------|----------|
| 1 | Rollback โดยไม่มี Backup | Data Loss | Backup ก่อน |
| 2 | Rollback DB โดยไม่มี DBA | Data Corruption | DBA ดูแล |
| 3 | Rollback โดยไม่แจ้ง | ผู้ใช้สับสน | แจ้งทันที |
| 4 | Rollback แล้วไม่ Monitor | ไม่รู้ว่าหาย | Monitor ≥ 30 นาที |
| 5 | Rollback แล้วไม่ RCA | เกิดซ้ำ | RCA ทันที |
| 6 | ไม่มี Rollback Plan | ช้า | มี Plan ก่อน Deploy |
| 7 | Rollback พร้อมกันหลายส่วน | สับสน | ทีละส่วน |
| 8 | ลบ Version เก่าเร็วเกินไป | Rollback ไม่ได้ | เก็บ ≥ 3 Versions |
| 9 | ไม่ Test Rollback | Rollback ล้มเหลว | ซ้อม Rollback |
| 10 | ไม่มี Feature Flag | ต้อง Deploy ตลอด | มี Flag ตั้งแต่แรก |

---

## 11.14 Best Practices

### 11.14.1 Hotfix Best Practices

- ✅ **Minimal Change** — เปลี่ยนน้อยที่สุด
- ✅ **สร้างจาก main** — เสมอ
- ✅ **Test เฉพาะจุด** — Reproduce + Critical Path
- ✅ **Review 1 คน** — Fast-track (≤ 30 นาที)
- ✅ **Staging ก่อน** — ถ้าเวลาเอื้อ
- ✅ **Backup ก่อน** — ถ้ามี DB
- ✅ **Rollback Plan** — มีทุกครั้ง
- ✅ **Monitor ≥ 30 นาที** — หลัง Deploy
- ✅ **Merge กลับ develop** — ทันที
- ✅ **RCA ≤ 48 ชม.** — ทุกครั้ง
- ✅ **Tag Version** — v1.0.X
- ✅ **Document** — ครบทุกขั้น

### 11.14.2 Rollback Best Practices

- ✅ **Automate** — Script Rollback
- ✅ **ซ้อมเป็นประจำ** — Quarterly Drill
- ✅ **หลายทางเลือก** — Blue-Green, K8s, Feature Flag
- ✅ **เก็บ Version เก่า** — ≥ 3 Versions
- ✅ **Backup Database** — ก่อน Deploy เสมอ
- ✅ **Feature Flag** — สำหรับ Feature ใหม่
- ✅ **Monitor** — หลัง Rollback
- ✅ **แจ้งทันที** — Stakeholder
- ✅ **RCA** — ทันที
- ✅ **อัปเดต Runbook** — ตามบทเรียน

### 11.14.3 Do's & Don'ts (สรุป)

```
┌─────────────────────────────────────────────────────────────┐
│                    HOTFIX DO's & DON'Ts                     │
└─────────────────────────────────────────────────────────────┘

  ✅ DO                          ❌ DON'T
  ─────                          ────────
  • สร้างจาก main                • สร้างจาก develop
  • Minimal Change               • เปลี่ยนหลายอย่าง
  • Test เฉพาะจุด                • ข้าม Test
  • Review 1 คน                  • Merge โดยไม่ Review
  • Backup ก่อน                  • Deploy โดยไม่ Backup
  • มี Rollback Plan             • ไม่มี Plan
  • Monitor หลัง Deploy          • Deploy แล้วหาย
  • Merge กลับ develop           • ลืม Merge back
  • RCA ≤ 48 ชม.                 • ไม่มี RCA
  • Tag Version                  • ไม่ Tag
```

---

## 11.15 FAQ

**Q1: Hotfix ต่างจาก Normal Fix ยังไง?**
A: Hotfix = Fast-track (ลดขั้นตอน, เร่งเวลา), Normal Fix = Full Process (ตาม Sprint) — Hotfix ใช้เมื่อเร่งด่วนเท่านั้น

**Q2: เมื่อไหร่ควร Rollback แทน Hotfix?**
A: ถ้า Rollback ได้และปลอดภัย → Rollback ก่อน (เร็ว, ชัวร์) — Hotfix เมื่อ Rollback ไม่ได้หรือช้าเกิน

**Q3: ต้องมี Code Review ใน Hotfix ไหม?**
A: **ต้องมี** — แต่ Fast-track (1 คน, ≤ 30 นาที) — ห้าม Merge โดยไม่มี Review

**Q4: ถ้าไม่มีเวลา Test ทำไง?**
A: Test **ขั้นต่ำ** ที่ต้องมี: (1) Reproduce Bug (2) Critical Path (3) Smoke Test — ที่เหลือ Skip ได้ตามอำนาจ

**Q5: Rollback DB แล้ว Data หาย ทำไง?**
A: กู้คืนจาก Backup + แจ้ง Stakeholder + RCA + Preventive Action — **ต้อง Backup ก่อน Rollback เสมอ**

**Q6: Merge กลับ develop สำคัญแค่ไหน?**
A: **สำคัญมาก** — ถ้าไม่ Merge กลับ Feature จะหายใน Deploy ครั้งถัดไป (Develop ทับ)

**Q7: Feature Flag ต่างจาก Hotfix ยังไง?**
A: Feature Flag = ปิด Feature โดยไม่ Deploy (เร็ว < 1 นาที) — Hotfix = แก้ Code แล้ว Deploy (ช้ากว่า)

**Q8: ต้องแจ้งใครบ้างตอน Hotfix?**
A: ตาม Severity — SEV-1: IC + EM + Stakeholder + Exec, SEV-2: IC + EM + Stakeholder, SEV-3: IC + Team

**Q9: Hotfix บ่อยเกินไป แก้ยังไง?**
A: วิเคราะห์ RCA — อาจเป็น Process (Test ไม่พอ), Architecture (เปราะบาง), หรือ Team (ขาดคน) — แก้ที่ Root Cause

**Q10: ซ้อม Rollback บ่อยแค่ไหน?**
A: **ไตรมาสละครั้ง** (Quarterly Drill) — ทดสอบ Blue-Green Switch, K8s Rollback, DB Restore

---

## 11.16 Glossary

| คำ | ความหมาย |
|----|----------|
| **Hotfix** | การแก้ไข Production แบบเร่งด่วน |
| **Rollback** | การย้อนกลับ Version ก่อนหน้า |
| **Blue-Green** | Deploy 2 Environment สลับกัน |
| **Canary** | Deploy ทีละน้อย (5% → 100%) |
| **Feature Flag** | สวิตช์เปิด/ปิด Feature |
| **Fast-track** | ลดขั้นตอนเพื่อความเร็ว |
| **Post-facto** | อนุมัติทีหลัง |
| **Smoke Test** | Test พื้นฐานหลัง Deploy |
| **Minimal Change** | เปลี่ยนน้อยที่สุด |
| **Blast Radius** | ขอบเขตผลกระทบ |
| **Kill Switch** | สวิตช์ปิดระบบฉุกเฉิน |
| **Down Migration** | Migration ย้อนกลับ |
| **Merge Back** | Merge กลับ develop |
| **IC** | Incident Commander |
| **Drill** | การซ้อม |

---

## 11.17 ความเชื่อมโยงกับเล่มอื่น

| เล่ม | ความเชื่อมโยงกับเล่ม 11 |
|------|-------------------------|
| **เล่ม 5 (DevOps)** | CI/CD Pipeline, Blue-Green, Monitoring |
| **เล่ม 6 (Code Review)** | Fast-track Review ใน Hotfix |
| **เล่ม 7 (On-call)** | Incident Response → Hotfix/Rollback |
| **เล่ม 12 (CI/CD)** | Pipeline ที่ Hotfix ต้องผ่าน |
| **เล่ม 13 (RCA)** | RCA หลัง Hotfix ทุกครั้ง |
| **เล่ม 14 (Security)** | Security Hotfix (ถ้ามี Breach) |
| **เล่ม 15 (Knowledge)** | อัปเดต Runbook หลัง Hotfix |

---

## 11.18 สรุปสาระสำคัญ (Key Takeaways)

```text
┌─────────────────────────────────────────────────────────────┐
│                  HOTFIX & ROLLBACK                          │
│                     KEY TAKEAWAYS                           │
└─────────────────────────────────────────────────────────────┘

  1. Stop Bleeding First — หยุดผลกระทบก่อนแก้ Root Cause
  2. Rollback ก่อน ถ้าทำได้ — เร็วกว่า, ชัวร์กว่า
  3. Hotfix = Minimal Change — เปลี่ยนน้อยที่สุด
  4. สร้างจาก main เสมอ — ห้ามจาก develop
  5. Test ขั้นต่ำ — Reproduce + Critical Path + Smoke
  6. Review 1 คน — Fast-track แต่ต้องมี
  7. Backup ก่อน Deploy — ถ้ามี DB
  8. Rollback Plan — มีทุกครั้ง
  9. Monitor ≥ 30 นาที — หลัง Deploy
  10. Merge กลับ develop — ทันที (สำคัญมาก)
  11. RCA ≤ 48 ชม. — ทุก Hotfix
  12. Tag Version — v1.0.X
  13. Feature Flag — ลด Hotfix ที่ไม่จำเป็น
  14. ซ้อม Rollback — ไตรมาสละครั้ง
  15. วัดผลด้วย KPI — Frequency, Lead Time, Success Rate
```

---
 