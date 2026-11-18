## 📘 เล่ม 14 (ฉบับขยาย): คู่มือ Security & Compliance
**ผู้แต่ง:** kongnakorn jantakun  
**อีเมล:** kongnakornjantakun@gmail.com  
**สถานะ:** ต้นฉบับ
**Reference:** https://github.com/kongnakornna/work-book

> **หมายเหตุ:** เอกสารนี้เป็นฉบับขยายของเล่ม 14 ใน Master Index โดยเพิ่มรายละเอียดเชิงปฏิบัติสำหรับทุกฝ่ายที่เกี่ยวข้องกับความปลอดภัยของระบบ FinTech & Accounting ได้แก่ Threat Modeling, OWASP Top 10 (Deep Dive), Authentication & Authorization Patterns, Secrets Management, Data Protection & Encryption, Security Testing, Secure SDLC, Compliance Frameworks (PDPA/GDPR/PCI-DSS/SOX/ISO 27001), Security Incident Response, Audit & Evidence, Templates และ KPIs

---
## 14.0 บทนำและปรัชญา

### 14.0.1 ทำไม Security & Compliance ถึงสำคัญ?

```
┌─────────────────────────────────────────────────────────────┐
│              RISK vs REWARD                                 │
└─────────────────────────────────────────────────────────────┘

  ความเสี่ยงถ้าไม่ทำ:
  • Data Breach → เสียชื่อเสียง + ค่าปรับ
  • Compliance Violation → ถูกปรับ + หยุดดำเนินการ
  • Financial Loss → โอนเงินผิด, ถูกขโมย
  • Legal Liability → ฟ้องร้อง
  • Loss of Trust → ลูกค้าหนี

  ผลตอบแทนถ้าทำ:
  • Trust → ลูกค้าเชื่อมั่น
  • Compliance → ผ่าน Audit
  • Reliability → ระบบเสถียร
  • Competitive Advantage → ได้เปรียบ
```

### 14.0.2 ปรัชญา 4 ข้อ

| หลักการ | ความหมาย | ผลลัพธ์ |
|---------|----------|---------|
| **Defense in Depth** | หลายชั้นป้องกัน | ถ้าชั้นหนึ่งพลาด ยังมีชั้นอื่น |
| **Least Privilege** | ให้สิทธิ์เท่าที่จำเป็น | ลด Blast Radius |
| **Zero Trust** | ไม่เชื่อใครโดยปริยาย | ตรวจสอบทุกครั้ง |
| **Shift Left** | ความปลอดภัยตั้งแต่ต้น | ต้นทุนต่ำ, แก้เร็ว |

### 14.0.3 Security คือ "ทุกคน" ไม่ใช่ "ทีม Security"

```
┌─────────────────────────────────────────────────────────────┐
│              SECURITY RESPONSIBILITY                        │
└─────────────────────────────────────────────────────────────┘

  ❌ ผิด: Security เป็นหน้าที่ของทีม Security เท่านั้น

  ✅ ถูก: ทุกคนมีส่วนร่วม
  • PO/BA — ระบุ Security Requirement
  • Dev — เขียน Code ปลอดภัย
  • QA — ทดสอบ Security
  • DevOps — Config ปลอดภัย
  • Architect — ออกแบบปลอดภัย
  • Reviewer — Review Security
  • On-call — Response Incident
  • Management — สนับสนุน + Compliance
  • User — ใช้งานปลอดภัย
```

### 14.0.4 CIA Triad

```
┌─────────────────────────────────────────────────────────────┐
│                    CIA TRIAD                                │
└─────────────────────────────────────────────────────────────┘

  ┌──────────────────────┐
  │  CONFIDENTIALITY     │  ข้อมูลเห็นเฉพาะผู้มีสิทธิ์
  │  (ความลับ)            │  → Encryption, Access Control
  └──────────┬───────────┘
             │
  ┌──────────┴───────────┐
  │  INTEGRITY           │  ข้อมูลไม่ถูกแก้ไขโดยไม่ได้รับอนุญาต
  │  (ความถูกต้อง)         │  → Hash, Signature, Audit Log
  └──────────┬───────────┘
             │
  ┌──────────┴───────────┐
  │  AVAILABILITY        │  ข้อมูลพร้อมใช้เมื่อต้องการ
  │  (ความพร้อมใช้)        │  → Backup, Redundancy, DDoS Protection
  └──────────────────────┘
```

---

## 14.1 บทบาทและความรับผิดชอบ

### 14.1.1 ผู้เกี่ยวข้องใน Security & Compliance

| บทบาท | หน้าที่ | ระดับ |
|-------|---------|:-----:|
| **CISO / Security Lead** | กำหนดนโยบาย, กำกับ | Strategic |
| **Security Engineer** | ออกแบบ Control, ติดตั้ง Tool | Tactical |
| **Security Analyst (SOC)** | Monitor, Detect, Respond | Operational |
| **DPO (Data Protection Officer)** | PDPA/GDPR Compliance | Compliance |
| **Compliance Officer** | Audit, SOX, ISO | Compliance |
| **Architect** | Secure Architecture | Design |
| **Developer** | Secure Code | Implementation |
| **QA** | Security Testing | Testing |
| **DevOps** | Secure Infra, Secrets | Operations |
| **PM** | Security Requirement | Planning |
| **Management** | สนับสนุน, อนุมัติ | Governance |
| **User** | ใช้งานปลอดภัย | Usage |

### 14.1.2 RACI Matrix (Security Activities)

| กิจกรรม | CISO | Security Eng | Dev | DevOps | QA | Architect | Mgmt |
|---------|:----:|:------------:|:---:|:------:|:--:|:---------:|:----:|
| Security Policy | **A** | R | C | C | I | C | **A** |
| Threat Modeling | C | **R** | C | C | I | **R** | I |
| Secure Code | I | C | **R** | C | C | C | I |
| Secrets Mgmt | **A** | C | C | **R** | I | C | I |
| Security Testing | I | **R** | C | C | **R** | I | I |
| Vulnerability Mgmt | **A** | **R** | C | C | C | C | I |
| Incident Response | **A** | **R** | C | C | I | C | I |
| Compliance Audit | **A** | C | C | C | C | C | **A** |
| Access Review | **A** | **R** | I | C | I | I | C |
| Training | **A** | **R** | I | I | I | I | C |

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
### 14.1.3 Security Team Structure (ตัวอย่าง)

```
┌─────────────────────────────────────────────────────────────┐
│              SECURITY TEAM STRUCTURE                        │
└─────────────────────────────────────────────────────────────┘

              ┌──────────────────┐
              │      CISO        │
              │  (Strategic)     │
              └────────┬─────────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
  ┌──────────┐  ┌──────────┐  ┌────────────┐
  │ Security │  │   SOC    │  │   DPO      │
  │ Engineer │  │ (24/7)   │  │(Compliance)│
  └──────────┘  └──────────┘  └────────────┘
        │              │
        ▼              ▼
  ┌──────────┐  ┌──────────┐
  │ AppSec   │  │ Incident │
  │ (Code)   │  │ Response │
  └──────────┘  └──────────┘
```

---

## 14.2 Security Principles (Deep Dive)

### 14.2.1 Defense in Depth

```
┌─────────────────────────────────────────────────────────────┐
│              DEFENSE IN DEPTH (7 Layers)                    │
└─────────────────────────────────────────────────────────────┘

  Layer 1: Physical      — Data Center, Access Card
  Layer 2: Network       — Firewall, WAF, DDoS
  Layer 3: Perimeter     — API Gateway, Rate Limit
  Layer 4: Endpoint      — Antivirus, EDR
  Layer 5: Application   — Input Validation, Auth
  Layer 6: Data          — Encryption, Masking
  Layer 7: Policies      — Training, Audit

  ถ้าชั้นหนึ่งพลาด → ชั้นอื่นยังป้องกัน
```

### 14.2.2 Least Privilege

| ระดับ | หลักการ | ตัวอย่าง |
|-------|---------|----------|
| **User** | ให้ Role เท่าที่จำเป็น | Finance Staff ไม่มี Admin |
| **Service** | Service Account แยก | API A ไม่ใช้ Credential ของ B |
| **Database** | DB User เฉพาะ | App User ไม่มี DROP |
| **Network** | Firewall Rule แคบ | เปิดเฉพาะ Port ที่ใช้ |
| **Cloud** | IAM Policy แคบ | S3 Read เฉพาะ Bucket |
| **Time** | ให้ชั่วคราว | Just-in-Time Access |

### 14.2.3 Zero Trust

```
┌─────────────────────────────────────────────────────────────┐
│                    ZERO TRUST                               │
└─────────────────────────────────────────────────────────────┘

  หลักการ: "Never Trust, Always Verify"

  • ไม่เชื่อ Network (แม้อยู่ใน Internal)
  • ตรวจสอบทุก Request (Auth + Authz)
  • Micro-segmentation
  • Continuous Verification
  • Least Privilege Access
```

### 14.2.4 Shift Left

```
┌─────────────────────────────────────────────────────────────┐
│                    SHIFT LEFT                               │
└─────────────────────────────────────────────────────────────┘

  แบบเดิม (Shift Right):
  Design → Code → Test → Deploy → [Security] → พบ Bug → แพง!

  Shift Left:
  [Security] → Design → [Security] → Code → [Security] → Test → Deploy
  → พบ Bug เร็ว → ถูกกว่า

  ต้นทุนแก้ Bug:
  • Design: 1x
  • Code: 10x
  • Test: 100x
  • Production: 1000x
```

### 14.2.5 Secure by Design / Secure by Default

| หลักการ | ความหมาย | ตัวอย่าง |
|---------|----------|----------|
| **Secure by Design** | ออกแบบให้ปลอดภัยตั้งแต่ต้น | Threat Model ก่อน Code |
| **Secure by Default** | ค่าเริ่มต้นปลอดภัย | Encryption เปิด默认, Password Policy แข็ง |
| **Fail Secure** | ถ้าพัง ให้ Fail แบบปลอดภัย | Auth ล่ม → Deny (ไม่ใช่ Allow) |
| **Privacy by Design** | ออกแบบโดยคำนึง Privacy | Data Minimization |

---

## 14.3 OWASP Top 10 (Deep Dive)

### 14.3.1 OWASP Top 10 (2021) Overview

| # | ความเสี่ยง | ความหมาย | ตัวอย่าง |
|---|-----------|----------|----------|
| A01 | Broken Access Control | ควบคุมสิทธิ์ผิด | User ดูข้อมูลคนอื่น |
| A02 | Cryptographic Failures | เข้ารหัสผิด | เก็บ Password Plaintext |
| A03 | Injection | ฉีด Code | SQL Injection, XSS |
| A04 | Insecure Design | ออกแบบไม่ปลอดภัย | ไม่มี Rate Limit |
| A05 | Security Misconfiguration | ตั้งค่าผิด | Debug Mode บน Prod |
| A06 | Vulnerable Components | Library เก่า | Log4j |
| A07 | Auth Failures | Auth ผิด | Weak Password, No MFA |
| A08 | Data Integrity Failures | ข้อมูลไม่ถูกตรวจสอบ | ไม่ Verify Signature |
| A09 | Logging Failures | Log ไม่พอ | ไม่มี Log การ Login |
| A10 | SSRF | Server-Side Request Forgery | ให้ Server เรียก URL ภายใน |

### 14.3.2 A01: Broken Access Control (Deep Dive)

**อาการ:**
- User เข้าถึงข้อมูลคนอื่น (IDOR)
- User ทำ Action ที่ไม่มีสิทธิ์
- ไม่ตรวจสอบ Authorization ที่ API

**ตัวอย่าง Bug:**

```python
# ❌ ผิด: ไม่ตรวจสอบว่า User เป็นเจ้าของ
@router.get("/employee/{id}")
async def get_employee(id: str):
    return await repo.find_by_id(id)
    # User A ดูข้อมูล User B ได้!

# ✅ ถูก: ตรวจสอบ Authorization
@router.get("/employee/{id}")
async def get_employee(id: str, user: User = Depends(get_current_user)):
    emp = await repo.find_by_id(id)
    if emp is None:
        raise HTTPException(404)
    if user.role != "admin" and emp.owner_id != user.id:
        raise HTTPException(403, "Forbidden")
    return emp
```

**การป้องกัน:**

| Control | รายละเอียด |
|---------|-----------|
| **RBAC** | Role-Based Access Control |
| **ABAC** | Attribute-Based (Context) |
| **Authorization Check ทุก Endpoint** | ไม่เว้น |
| **Deny by Default** | ถ้าไม่ระบุ = Deny |
| **Test IDOR** | ลองเข้าถึง ID อื่น |
| **Centralized Authz** | ไม่กระจาย Logic |

### 14.3.3 A02: Cryptographic Failures

**อาการ:**
- เก็บ Password Plaintext
- ใช้ MD5/SHA1 สำหรับ Password
- ไม่เข้ารหัสข้อมูลสำคัญ
- ใช้ HTTP (ไม่ HTTPS)

**ตัวอย่าง:**

```python
# ❌ ผิด: MD5 (ไม่ปลอดภัย)
import hashlib
hashed = hashlib.md5(password.encode()).hexdigest()

# ✅ ถูก: bcrypt / argon2
from passlib.hash import bcrypt
hashed = bcrypt.hash(password)

# หรือ argon2 (แนะนำ)
from argon2 import PasswordHasher
ph = PasswordHasher()
hashed = ph.hash(password)
```

**การป้องกัน:**

| ข้อมูล | วิธี |
|--------|------|
| **Password** | bcrypt / argon2 + Salt |
| **PII** | AES-256 Encryption |
| **Data in Transit** | TLS 1.3 |
| **Data at Rest** | Disk Encryption, TDE |
| **Secrets** | Vault / KMS |
| **API Key** | Hash + Rotate |

### 14.3.4 A03: Injection

**ประเภทย่อย:**

| ประเภท | ตัวอย่าง | การป้องกัน |
|--------|----------|-----------|
| **SQL Injection** | `' OR 1=1--` | Parameterized Query |
| **NoSQL Injection** | `{"$gt": ""}` | Input Validation, Type Check |
| **Command Injection** | `; rm -rf /` | ไม่ใช้ Shell, Allowlist |
| **XSS** | `<script>alert(1)</script>` | Escape, CSP |
| **LDAP Injection** | `*)(uid=*` | Escape |
| **Template Injection** | `{{7*7}}` | Sandbox |

**SQL Injection ตัวอย่าง:**

```python
# ❌ ผิด: String Concat
query = f"SELECT * FROM users WHERE email = '{email}'"
# Input: ' OR '1'='1 → SELECT * FROM users WHERE email = '' OR '1'='1'

# ✅ ถูก: Parameterized
await db.fetch_one(
    "SELECT * FROM users WHERE email = $1", email
)

# ✅ ถูก: ORM
await User.filter(email=email).first()
```

**XSS ตัวอย่าง:**

```typescript
// ❌ ผิด: dangerouslySetInnerHTML
<div dangerouslySetInnerHTML={{__html: userInput}} />

// ✅ ถูก: Text Content
<div>{userInput}</div>

// ✅ ถูก: Sanitize
import DOMPurify from 'dompurify';
<div dangerouslySetInnerHTML={{__html: DOMPurify.sanitize(userInput)}} />
```

**การป้องกัน Injection:**

- ✅ **Parameterized Query** — เสมอ
- ✅ **Input Validation** — Type, Length, Format
- ✅ **Output Encoding** — Escape ตาม Context
- ✅ **Allowlist** — ไม่ใช้ Blacklist
- ✅ **CSP** — Content Security Policy
- ✅ **WAF** — Web Application Firewall

### 14.3.5 A04: Insecure Design

**อาการ:**
- ไม่มี Threat Model
- ไม่มี Rate Limit
- ไม่มี Anti-Automation
- ไม่มี Business Logic Validation

**ตัวอย่าง:**

```python
# ❌ ผิด: ไม่มี Rate Limit
@router.post("/login")
async def login(email: str, password: str):
    # Brute force ได้ไม่จำกัด
    ...

# ✅ ถูก: Rate Limit + Lockout
@router.post("/login")
@limiter.limit("5/minute")
async def login(email: str, password: str):
    # หลัง 5 ครั้งผิด → Lock 15 นาที
    if await is_locked(email):
        raise HTTPException(429, "Too many attempts")
    ...
```

**การป้องกัน:**

- ✅ **Threat Modeling** — ก่อน Code
- ✅ **Rate Limiting** — ทุก Endpoint สำคัญ
- ✅ **Anti-Automation** — CAPTCHA, Bot Detection
- ✅ **Business Logic Test** — ทดสอบ Abuse Case
- ✅ **Secure Design Review** — ก่อน Implement

### 14.3.6 A05: Security Misconfiguration

**อาการ:**
- Debug Mode บน Prod
- Default Password
- Open S3 Bucket
- Verbose Error (เผย Stack Trace)
- ไม่ปิด Port ที่ไม่ใช้

**ตัวอย่าง:**

```python
# ❌ ผิด: Debug บน Prod
app = FastAPI(debug=True)  # เผย Stack Trace

# ✅ ถูก: Debug เฉพาะ Dev
app = FastAPI(debug=settings.env == "development")

# ❌ ผิด: CORS *
app.add_middleware(CORSMiddleware, allow_origins=["*"])

# ✅ ถูก: CORS Allowlist
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://pms.your-company.com"],
    allow_credentials=True,
)
```

**การป้องกัน:**

- ✅ **Hardening Checklist** — ทุก Environment
- ✅ **No Default Credentials** — เปลี่ยนทันที
- ✅ **Disable Debug** — บน Prod
- ✅ **Minimal Ports** — ปิดที่ไม่ใช้
- ✅ **Error Handling** — ไม่เผยข้อมูล
- ✅ **IaC Scan** — Checkov, tfsec
- ✅ **Config as Code** — Review ทุกครั้ง

### 14.3.7 A06: Vulnerable Components

**อาการ:**
- Library เก่า (มี CVE)
- ไม่ Update Dependency
- ใช้ Library ที่ไม่ Maintain

**ตัวอย่าง CVE:**

| CVE | Library | ผลกระทบ |
|-----|---------|---------|
| CVE-2021-44228 | Log4j | RCE (Critical) |
| CVE-2022-22965 | Spring4Shell | RCE |
| CVE-2023-44487 | HTTP/2 | DoS |

**การป้องกัน:**

- ✅ **SCA Scan** — Trivy, Dependabot, Snyk
- ✅ **Update สม่ำเสมอ** — Weekly
- ✅ **Pin Version** — Lock File
- ✅ **SBOM** — รู้ว่ามีอะไร
- ✅ **Remove Unused** — ลด Attack Surface
- ✅ **Monitor CVE** — Feed

### 14.3.8 A07: Identification & Authentication Failures

**อาการ:**
- Weak Password Policy
- ไม่มี MFA
- Session ไม่หมดอายุ
- Credential Stuffing ได้

**ตัวอย่าง:**

```python
# ❌ ผิด: ไม่มี Password Policy
if len(password) < 6:
    raise ValidationError("too short")

# ✅ ถูก: Policy แข็ง
import re

def validate_password(password: str):
    if len(password) < 12:
        raise ValidationError("min 12 chars")
    if not re.search(r"[A-Z]", password):
        raise ValidationError("need uppercase")
    if not re.search(r"[a-z]", password):
        raise ValidationError("need lowercase")
    if not re.search(r"\d", password):
        raise ValidationError("need digit")
    if not re.search(r"[!@#$%^&*]", password):
        raise ValidationError("need special")
    if password in COMMON_PASSWORDS:
        raise ValidationError("too common")
```

**การป้องกัน:**

- ✅ **MFA** — บังคับสำหรับ Admin
- ✅ **Strong Password Policy** — ≥ 12 chars
- ✅ **Session Timeout** — 8 ชั่วโมง
- ✅ **Account Lockout** — หลัง 5 ครั้งผิด
- ✅ **SSO** — Azure AD, OAuth2
- ✅ **Credential Stuffing Protection** — Breach Check

### 14.3.9 A08: Software & Data Integrity Failures

**อาการ:**
- ไม่ Verify Signature
- ใช้ Library จาก Untrusted Source
- CI/CD ไม่ Secure
- Deserialization ไม่ปลอดภัย

**การป้องกัน:**

- ✅ **Signature Verification** — Docker, Package
- ✅ **SBOM** — รู้อะไรอยู่ใน Image
- ✅ **Signed Commits** — GPG
- ✅ **CI/CD Security** — Secrets, Access
- ✅ **Avoid Deserialization** — ใช้ JSON แทน Pickle

### 14.3.10 A09: Security Logging & Monitoring Failures

**อาการ:**
- ไม่มี Log การ Login
- Log ไม่มี Timestamp
- ไม่มี Alert
- Log มี PII
- ไม่มี Retention

**ตัวอย่าง:**

```python
# ❌ ผิด: Log Password
logger.info(f"Login: {email}/{password}")

# ✅ ถูก: Log แบบปลอดภัย
logger.info(
    "Login attempt",
    extra={
        "email": mask_email(email),
        "success": success,
        "ip": request.client.host,
        "user_agent": request.headers.get("user-agent"),
    },
)
```

**การป้องกัน:**

- ✅ **Structured Logging** — JSON
- ✅ **Log Events สำคัญ** — Login, Access, Change
- ✅ **No PII/Secrets** — Mask
- ✅ **Centralized Log** — Loki, ELK
- ✅ **Alert** — SEV-1 Events
- ✅ **Retention** — ≥ 1 ปี (Compliance)

### 14.3.11 A10: SSRF

**อาการ:**
- ให้ User ระบุ URL
- Server เรียก URL นั้น
- เข้าถึง Internal Resource

**ตัวอย่าง:**

```python
# ❌ ผิด: ให้ User ระบุ URL ได้
@router.post("/fetch")
async def fetch(url: str):
    async with httpx.AsyncClient() as client:
        return await client.get(url)
    # User ใส่ http://169.254.169.254/ (AWS Metadata)

# ✅ ถูก: Allowlist
ALLOWED_HOSTS = {"api.oracle.com", "api.partner.com"}

@router.post("/fetch")
async def fetch(url: str):
    parsed = urlparse(url)
    if parsed.hostname not in ALLOWED_HOSTS:
        raise HTTPException(400, "Host not allowed")
    if parsed.scheme not in ("https",):
        raise HTTPException(400, "HTTPS only")
    ...
```

**การป้องกัน:**

- ✅ **Allowlist** — ไม่ใช้ Blacklist
- ✅ **Validate URL** — Scheme, Host, Port
- ✅ **Block Internal IP** — 127.0.0.1, 169.254.x.x, 10.x.x.x
- ✅ **Network Policy** — Egress Control
- ✅ **Disable Redirect** — หรือ Validate

---

## 14.4 Authentication & Authorization (Deep Dive)

### 14.4.1 Authentication Methods

| วิธี | ความปลอดภัย | ใช้เมื่อ |
|------|:-----------:|----------|
| **Password** | ต่ำ | Legacy |
| **Password + MFA** | ปานกลาง | ทั่วไป |
| **SSO (OIDC/SAML)** | สูง | Enterprise |
| **OAuth2** | สูง | API, Third-party |
| **API Key** | ปานกลาง | Service-to-Service |
| **mTLS** | สูง | Service Mesh |
| **Biometric** | สูง | Mobile |

### 14.4.2 OAuth2 / OIDC Flow

```
┌─────────────────────────────────────────────────────────────┐
│              OAUTH2 AUTHORIZATION CODE FLOW                 │
└─────────────────────────────────────────────────────────────┘

  User → App → Azure AD (SSO)
              │
              ▼
        Login + MFA
              │
              ▼
        Authorization Code → App
              │
              ▼
        App → Azure AD: Exchange Code for Token
              │
              ▼
        Access Token + ID Token + Refresh Token
              │
              ▼
        App → API: Bearer Token
              │
              ▼
        API: Validate Token → Response
```

**Token Best Practices:**

| หัวข้อ | Best Practice |
|--------|---------------|
| **Access Token** | อายุสั้น (15 นาที) |
| **Refresh Token** | อายุยาว (7 วัน), Rotate |
| **Storage** | HttpOnly Cookie / Secure Storage |
| **Transport** | HTTPS เท่านั้น |
| **Validation** | Signature, Exp, Iss, Aud |
| **Revocation** | รองรับ |

### 14.4.3 JWT Validation (ตัวอย่าง)

```python
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import jwt, JWTError

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> User:
    token = credentials.credentials
    try:
        payload = jwt.decode(
            token,
            settings.JWT_PUBLIC_KEY,
            algorithms=["RS256"],
            audience=settings.JWT_AUDIENCE,
            issuer=settings.JWT_ISSUER,
        )
    except JWTError as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    user = await user_repo.find_by_id(payload["sub"])
    if user is None or not user.is_active:
        raise HTTPException(401)
    return user
```

### 14.4.4 RBAC Implementation

```python
# pkg/auth/rbac.py
from enum import Enum
from functools import wraps
from fastapi import Depends, HTTPException

class Role(str, Enum):
    ADMIN = "admin"
    MANAGER = "manager"
    STAFF = "staff"
    AUDITOR = "auditor"

class Permission(str, Enum):
    PAYMENT_CREATE = "payment:create"
    PAYMENT_APPROVE = "payment:approve"
    PAYMENT_DELETE = "payment:delete"
    REPORT_VIEW = "report:view"
    USER_MANAGE = "user:manage"

ROLE_PERMISSIONS = {
    Role.ADMIN: {p for p in Permission},
    Role.MANAGER: {
        Permission.PAYMENT_CREATE,
        Permission.PAYMENT_APPROVE,
        Permission.REPORT_VIEW,
    },
    Role.STAFF: {
        Permission.PAYMENT_CREATE,
        Permission.REPORT_VIEW,
    },
    Role.AUDITOR: {
        Permission.REPORT_VIEW,
    },
}

def require_permission(*permissions: Permission):
    async def checker(user: User = Depends(get_current_user)) -> User:
        user_perms = ROLE_PERMISSIONS.get(user.role, set())
        if not all(p in user_perms for p in permissions):
            raise HTTPException(403, "Forbidden")
        return user
    return checker

@router.post("/payment", dependencies=[Depends(require_permission(Permission.PAYMENT_CREATE))])
async def create_payment(...):
    ...
```

### 14.4.5 ABAC (Attribute-Based Access Control)

```python
# ตัวอย่าง: เข้าถึงได้เฉพาะ Payment ของตัวเอง หรือ Manager ขึ้นไป
@router.get("/payment/{id}")
async def get_payment(id: str, user: User = Depends(get_current_user)):
    payment = await repo.find_by_id(id)
    if payment is None:
        raise HTTPException(404)

    # ABAC Rules
    is_owner = payment.created_by == user.id
    is_manager = user.role in (Role.MANAGER, Role.ADMIN)
    is_same_department = payment.department == user.department

    if not (is_owner or is_manager or is_same_department):
        raise HTTPException(403)

    return payment
```

### 14.4.6 Service-to-Service Auth

```python
# mTLS หรือ Service Token
# ตัวอย่าง: Service Token (JWT)

# Service A → Service B
token = jwt.encode(
    {
        "iss": "service-a",
        "sub": "service-a",
        "aud": "service-b",
        "exp": datetime.utcnow() + timedelta(minutes=5),
        "scope": "payment:read",
    },
    private_key,
    algorithm="RS256",
)

# Service B: Validate
payload = jwt.decode(
    token,
    service_a_public_key,
    algorithms=["RS256"],
    audience="service-b",
)
```

### 14.4.7 Session Management

| หัวข้อ | Best Practice |
|--------|---------------|
| **Session ID** | Random 256-bit |
| **Storage** | HttpOnly + Secure + SameSite |
| **Timeout** | 8 ชั่วโมง (Idle: 30 นาที) |
| **Rotation** | หลัง Login / Privilege Change |
| **Revocation** | Logout, Admin, Breach |
| **Concurrent** | จำกัด (เช่น 3 devices) |

---

## 14.5 Secrets Management (Deep Dive)

### 14.5.1 ประเภท Secrets

| ประเภท | ตัวอย่าง | อายุ |
|--------|----------|-----|
| **Password** | DB, Admin | 90 วัน |
| **API Key** | Third-party | 90 วัน |
| **Token** | OAuth, JWT | ตาม Policy |
| **Certificate** | TLS, mTLS | 1 ปี |
| **Encryption Key** | AES | 1 ปี |
| **Connection String** | DB, Redis | 90 วัน |
| **SSH Key** | Server | 1 ปี |

### 14.5.2 Secrets Anti-Patterns (ข้อห้าม)

| # | ❌ Anti-Pattern | ผลกระทบ |
|---|----------------|---------|
| 1 | Hardcode ใน Code | รั่วไหลทาง Git |
| 2 | Commit `.env` | รั่วไหล |
| 3 | ฝังใน Docker Image | รั่วไหล |
| 4 | Log Secrets | รั่วไหล |
| 5 | ส่ง Secrets ทาง Chat/Email | รั่วไหล |
| 6 | ใช้ Secret เดียวทุก Environment | Blast Radius |
| 7 | ไม่ Rotate | ค้างนาน |
| 8 | เก็บ Plaintext | อ่านได้ |
| 9 | ใช้ Default Secret | รู้กันทั่วไป |
| 10 | แชร์ Secret กันหลายคน | ไม่รู้ว่าใคร |

### 14.5.3 Secrets Management Solution

```
┌─────────────────────────────────────────────────────────────┐
│              SECRETS MANAGEMENT STACK                       │
└─────────────────────────────────────────────────────────────┘

  ┌──────────────────────────────────────┐
  │  HashiCorp Vault / Azure Key Vault   │
  │  (Central Store)                      │
  └──────────────┬───────────────────────┘
                 │
                 ▼
  ┌──────────────────────────────────────┐
  │  External Secrets Operator           │
  │  (Sync to K8s)                        │
  └──────────────┬───────────────────────┘
                 │
                 ▼
  ┌──────────────────────────────────────┐
  │  K8s Secrets (Encrypted)             │
  └──────────────┬───────────────────────┘
                 │
                 ▼
  ┌──────────────────────────────────────┐
  │  Application (Runtime)               │
  │  อ่านจาก Env / Volume                 │
  └──────────────────────────────────────┘
```

### 14.5.4 ตัวอย่าง: Azure Key Vault + FastAPI

```python
# config.py
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    env: str = "development"

    @property
    def db_password(self) -> str:
        if self.env == "development":
            return "dev-password"  # Dev only
        client = SecretClient(
            vault_url=f"https://pms-{self.env}.vault.azure.net/",
            credential=DefaultAzureCredential(),
        )
        return client.get_secret("db-password").value


settings = Settings()
```

### 14.5.5 ตัวอย่าง: K8s External Secrets

```yaml
# infra/external-secrets/db-credentials.yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: db-credentials
  namespace: production
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: azure-keyvault
    kind: ClusterSecretStore
  target:
    name: db-credentials
    creationPolicy: Owner
  data:
    - secretKey: password
      remoteRef:
        key: db-password
    - secretKey: username
      remoteRef:
        key: db-username
```

### 14.5.6 Secret Rotation

```
┌─────────────────────────────────────────────────────────────┐
│              SECRET ROTATION PROCESS                        │
└─────────────────────────────────────────────────────────────┘

  Step 1: สร้าง Secret ใหม่
         │
         ▼
  Step 2: เพิ่ม Secret ใหม่ (ยังใช้เก่าได้)
         │
         ▼
  Step 3: Deploy App ด้วย Secret ใหม่
         │
         ▼
  Step 4: Verify App ใช้ Secret ใหม่ได้
         │
         ▼
  Step 5: ลบ Secret เก่า
         │
         ▼
  Step 6: Audit + Log
```

**Automation:**

```yaml
# Azure Key Vault: Auto-rotate
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  value        = random_password.db.result
  key_vault_id = azurerm_key_vault.main.id

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"  # 30 วันก่อนหมด
    }
    expire_after         = "P90D"  # หมดอายุ 90 วัน
    notify_before_expiry = "P29D"
  }
}
```

### 14.5.7 Secret Scanning (ก่อน Commit)

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
```

```yaml
# .github/workflows/security.yml
- name: Gitleaks
  uses: gitleaks/gitleaks-action@v2
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**ถ้าพบ Secret ใน Git:**

1. **Rotate ทันที** — Secret นั้นถือว่ารั่วไหลแล้ว
2. **ลบจาก History** — `git filter-repo` / BFG
3. **Force Push** — แจ้งทีม
4. **RCA** — ทำไมหลุดได้
5. **Preventive** — เพิ่ม Hook, Training

---

## 14.6 Data Protection & Encryption

### 14.6.1 Data Classification

| ระดับ | ตัวอย่าง | การจัดการ |
|-------|----------|-----------|
| **Public** | Marketing, Docs | ไม่ต้องป้องกัน |
| **Internal** | Internal Wiki, Code | Access Control |
| **Confidential** | Customer Data, PII | Encrypt + Access Control |
| **Restricted** | Secrets, Financial | Encrypt + Audit + MFA |
| **Regulated** | PDPA/GDPR Data | Compliance + Encrypt |

### 14.6.2 Encryption Standards

| ข้อมูล | Algorithm | Key Size |
|--------|-----------|----------|
| **Symmetric** | AES | 256-bit |
| **Asymmetric** | RSA | 4096-bit |
| **Asymmetric** | ECDSA | 256-bit (P-256) |
| **Hash** | SHA-256 / SHA-3 | 256-bit |
| **Password Hash** | Argon2id | — |
| **HMAC** | HMAC-SHA256 | — |
| **TLS** | TLS 1.3 | — |

### 14.6.3 Encryption at Rest

```
┌─────────────────────────────────────────────────────────────┐
│              ENCRYPTION AT REST                             │
└─────────────────────────────────────────────────────────────┘

  Layer 1: Disk Encryption (TDE / LUKS)
  Layer 2: Database Encryption (Column-level)
  Layer 3: Application Encryption (Field-level)

  ตัวอย่าง: Field-level Encryption (PII)
```

```python
# pkg/crypto/field.py
from cryptography.fernet import Fernet

class FieldEncryptor:
    def __init__(self, key: bytes):
        self.cipher = Fernet(key)

    def encrypt(self, plaintext: str) -> str:
        return self.cipher.encrypt(plaintext.encode()).decode()

    def decrypt(self, ciphertext: str) -> str:
        return self.cipher.decrypt(ciphertext.encode()).decode()


# ใช้กับ PII
encryptor = FieldEncryptor(settings.field_key)

employee.email = encryptor.encrypt("somchai@example.com")
```

### 14.6.4 Encryption in Transit

```python
# HTTPS บังคับ
from fastapi.middleware.httpsredirect import HTTPSRedirectMiddleware
app.add_middleware(HTTPSRedirectMiddleware)

# HSTS Header
@app.middleware("http")
async def add_security_headers(request, call_next):
    response = await call_next(request)
    response.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["Content-Security-Policy"] = "default-src 'self'"
    return response
```

### 14.6.5 PII Masking

| Context | ตัวอย่าง |
|---------|----------|
| **Log** | `s***@example.com` |
| **UI (list)** | `****-****-****-1234` |
| **API (non-owner)** | `***-**-6789` |
| **Export** | เฉพาะผู้มีสิทธิ์ |

```python
def mask_email(email: str) -> str:
    if "@" not in email:
        return "***"
    local, domain = email.split("@", 1)
    masked_local = local[0] + "*" * (len(local) - 1) if len(local) > 1 else "*"
    return f"{masked_local}@{domain}"


def mask_phone(phone: str) -> str:
    return phone[:3] + "*" * (len(phone) - 6) + phone[-3:]
```

### 14.6.6 Data Retention & Deletion

| ข้อมูล | Retention | การลบ |
|--------|-----------|-------|
| **Financial Records** | 5–10 ปี | Archive |
| **Customer PII** | ตามสัญญา | Soft Delete → Hard Delete |
| **Logs** | 1 ปี | Auto-delete |
| **Backups** | 90 วัน | Rotate |
| **Audit Trail** | 5 ปี | Archive |

**Right to Erasure (PDPA/GDPR):**

```python
async def delete_user_data(user_id: str):
    # 1. Soft Delete
    await user_repo.soft_delete(user_id)

    # 2. Anonymize (เก็บ Reference)
    await user_repo.anonymize(user_id, {
        "email": f"deleted-{user_id}@deleted.local",
        "full_name": "Deleted User",
        "phone": None,
    })

    # 3. Archive (ถ้าต้องเก็บตามกฎหมาย)
    await archive_service.archive(user_id)

    # 4. Hard Delete (หลัง Retention)
    # (Cron Job)
```

---

## 14.7 Security Testing

### 14.7.1 ประเภท Security Testing

| ประเภท | ทำเมื่อ | เครื่องมือ | จับอะไร |
|--------|---------|-----------|---------|
| **SAST** | ทุก PR | SonarQube, CodeQL | Code Vuln |
| **DAST** | Staging Deploy | OWASP ZAP, Burp | Runtime Vuln |
| **SCA** | ทุก PR + Daily | Trivy, Dependabot | Dependency CVE |
| **Secret Scan** | ทุก PR | Gitleaks, TruffleHog | Secrets |
| **Container Scan** | ทุก Build | Trivy | Image CVE |
| **IaC Scan** | ทุก PR (infra) | Checkov, tfsec | Misconfig |
| **Pen Test** | ก่อน Release ใหญ่ | Manual / Vendor | ทุกอย่าง |
| **Threat Model** | ก่อน Design | Manual | Design Flaw |

### 14.7.2 SAST Configuration

```yaml
# .github/workflows/security.yml
- name: SAST (SonarQube)
  uses: sonarsource/sonarqube-scan-action@master
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
  with:
    args: >
      -Dsonar.qualitygate.wait=true
      -Dsonar.security.hotspots.reviewed=true
```

### 14.7.3 DAST Configuration

```yaml
- name: DAST (OWASP ZAP)
  uses: zaproxy/action-full-scan@v0.10.0
  with:
    target: 'https://staging.pms.example.com'
    rules_file_name: '.zap/rules.tsv'
    cmd_options: '-a'
    fail_action: true
```

### 14.7.4 Security Testing Checklist

**ก่อน Merge (ทุก PR):**
- [ ] SAST ผ่าน (ไม่มี Critical/High)
- [ ] Secret Scan ผ่าน
- [ ] Dependency Scan ผ่าน
- [ ] Unit Test Security Cases

**ก่อน Deploy Staging:**
- [ ] Container Scan ผ่าน
- [ ] IaC Scan ผ่าน
- [ ] DAST ผ่าน (ถ้ามี Endpoint ใหม่)

**ก่อน Deploy Production:**
- [ ] Pen Test ผ่าน (Release ใหญ่)
- [ ] Security Sign-off
- [ ] Threat Model Updated

### 14.7.5 Threat Modeling (STRIDE)

| ตัวอักษร | ความหมาย | ตัวอย่าง |
|---------|----------|----------|
| **S**poofing | ปลอมตัว | ปลอม Token |
| **T**ampering | แก้ไข | แก้ Request |
| **R**epudiation | ปฏิเสธ | ไม่มี Audit |
| **I**nformation Disclosure | เปิดเผย | เผย Stack Trace |
| **D**enial of Service | ทำให้ล่ม | DDoS |
| **E**levation of Privilege | ยกระดับสิทธิ์ | User → Admin |

**Threat Model Template:**

```markdown
# Threat Model: [Feature]

## Data Flow
User → API → DB
     ↓
   External (Oracle)

## Trust Boundaries
1. Internet ↔ API Gateway
2. API Gateway ↔ API
3. API ↔ DB
4. API ↔ External

## Threats (STRIDE)
| # | Threat | Category | Mitigation |
|---|--------|----------|------------|
| 1 | ปลอม Token | Spoofing | JWT Signature |
| 2 | แก้ Request | Tampering | HTTPS, Signature |
| 3 | ไม่มี Audit | Repudiation | Audit Log |
| 4 | เผย Stack Trace | Info Disclosure | Error Handler |
| 5 | DDoS | DoS | Rate Limit, WAF |
| 6 | User → Admin | Elevation | RBAC |
```

---

## 14.8 Secure SDLC

### 14.8.1 Security ในแต่ละ Phase

```
┌─────────────────────────────────────────────────────────────┐
│              SECURE SDLC                                    │
└─────────────────────────────────────────────────────────────┘

  Phase 1: Requirements
  ├─ Security Requirements
  └─ Compliance Requirements

  Phase 2: Design
  ├─ Threat Modeling
  └─ Secure Design Review

  Phase 3: Development
  ├─ Secure Coding Standards
  ├─ SAST
  └─ Secret Scan

  Phase 4: Testing
  ├─ Security Test Cases
  ├─ DAST
  └─ Pen Test

  Phase 5: Deployment
  ├─ Container Scan
  ├─ IaC Scan
  └─ Security Sign-off

  Phase 6: Operations
  ├─ Monitoring
  ├─ Vulnerability Mgmt
  └─ Incident Response
```

### 14.8.2 Security Requirements (Phase 1)

**ตัวอย่าง Security User Story:**

```markdown
# User Story: Secure Login

**As a** Finance Staff
**I want** Login ด้วย SSO + MFA
**So that** บัญชีของฉันปลอดภัย

## Acceptance Criteria
- **Given** User ยังไม่ Login
  **When** เข้า /login
  **Then** ถูก Redirect ไป Azure AD
- **Given** User Login สำเร็จ
  **When** เข้า Dashboard
  **Then** Session หมดอายุใน 8 ชั่วโมง
- **Given** User Login ผิด 5 ครั้ง
  **When** Login ครั้งที่ 6
  **Then** Account ถูก Lock 15 นาที

## Security Requirements
- [ ] MFA บังคับสำหรับ Admin
- [ ] Password Policy: ≥ 12 chars, Mixed
- [ ] Session: HttpOnly, Secure, SameSite
- [ ] Audit Log: Login, Logout, Fail
```

### 14.8.3 Secure Coding Standards

| หัวข้อ | Standard |
|--------|----------|
| **Input Validation** | Allowlist, Type, Length |
| **Output Encoding** | ตาม Context |
| **Parameterized Query** | เสมอ |
| **Error Handling** | ไม่เผย Stack Trace |
| **Logging** | ไม่มี PII/Secrets |
| **Auth** | ตรวจสอบทุก Endpoint |
| **Secrets** | Vault เท่านั้น |
| **Dependencies** | Pin Version, Update |
| **Crypto** | Standard Algorithm |
| **File Upload** | Validate Type, Size |

### 14.8.4 Security Code Review Checklist

- [ ] Input Validation ครบ
- [ ] Output Encoding ครบ
- [ ] Parameterized Query
- [ ] Authorization Check ทุก Endpoint
- [ ] ไม่มี Hardcoded Secrets
- [ ] ไม่มี PII ใน Log
- [ ] Error Handling ปลอดภัย
- [ ] Crypto ถูกต้อง
- [ ] Dependency ปลอดภัย
- [ ] ไม่มี Debug Code

---

## 14.9 Compliance Frameworks

### 14.9.1 ภาพรวม Compliance

| มาตรฐาน | ใช้กับ | ข้อกำหนดหลัก |
|---------|--------|-------------|
| **PDPA** | ข้อมูลส่วนบุคคล (ไทย) | Consent, Rights, Breach Notification |
| **GDPR** | EU Citizen | คล้าย PDPA + DPO |
| **PCI-DSS** | บัตรเครดิต | 12 Requirements |
| **SOX** | Financial Reporting | Internal Control, Audit |
| **ISO 27001** | ISMS | 114 Controls |
| **SOC 2** | Service Provider | Trust Principles |

### 14.9.2 PDPA (พ.ร.บ.คุ้มครองข้อมูลส่วนบุคคล)

**หลักการ:**

| หลักการ | ความหมาย |
|---------|----------|
| **Consent** | ต้องขอ Consent ก่อนเก็บ |
| **Purpose Limitation** | ใช้ตามวัตถุประสงค์ที่แจ้ง |
| **Data Minimization** | เก็บเท่าที่จำเป็น |
| **Accuracy** | ข้อมูลถูกต้อง |
| **Storage Limitation** | เก็บตามระยะเวลา |
| **Integrity & Confidentiality** | ปลอดภัย |
| **Accountability** | รับผิดชอบ |

**Data Subject Rights:**

| สิทธิ์ | ความหมาย | SLA |
|--------|----------|-----|
| **Right to Access** | ขอดูข้อมูล | 30 วัน |
| **Right to Rectification** | ขอแก้ไข | 30 วัน |
| **Right to Erasure** | ขอลบ | 30 วัน |
| **Right to Restrict** | ขอจำกัดการใช้ | 30 วัน |
| **Right to Portability** | ขอโอนข้อมูล | 30 วัน |
| **Right to Object** | คัดค้าน | 30 วัน |

**Breach Notification:**

```
┌─────────────────────────────────────────────────────────────┐
│              PDPA BREACH NOTIFICATION                       │
└─────────────────────────────────────────────────────────────┘

  พบ Breach → แจ้ง PDPC ภายใน 72 ชั่วโมง
            → แจ้ง Data Subject โดยเร็ว

  ต้องแจ้ง:
  • ลักษณะ Breach
  • ข้อมูลที่กระทบ
  • ผลกระทบ
  • มาตรการแก้ไข
  • ช่องทางติดต่อ
```

### 14.9.3 PCI-DSS (ถ้าเกี่ยวกับบัตร)

**12 Requirements:**

| # | Requirement |
|---|-------------|
| 1 | Firewall Configuration |
| 2 | ไม่ใช้ Default Password |
| 3 | Protect Stored Data |
| 4 | Encrypt Transmission |
| 5 | Antivirus |
| 6 | Secure Systems |
| 7 | Need-to-Know Access |
| 8 | Unique ID + MFA |
| 9 | Physical Access |
| 10 | Log & Monitor |
| 11 | Test Security |
| 12 | Security Policy |

> ⚠️ **หมายเหตุ:** โปรเจกต์นี้ **ไม่เก็บข้อมูลบัตร** (ใช้ Payment Gateway) → ไม่ต้อง PCI-DSS เต็มรูปแบบ แต่ต้อง **SAQ A** (Self-Assessment)

### 14.9.4 SOX (ถ้าเป็น Public Company)

| หัวข้อ | ข้อกำหนด |
|--------|----------|
| **Internal Control** | มี Control ที่วัดได้ |
| **Audit Trail** | ทุก Transaction มี Log |
| **Segregation of Duties** | แยกคนสร้าง/อนุมัติ |
| **Access Control** | Least Privilege |
| **Change Management** | Approval Process |
| **Financial Reporting** | ถูกต้อง |

### 14.9.5 ISO 27001

**14 Domains:**

| # | Domain | ตัวอย่าง |
|---|--------|----------|
| 1 | Information Security Policies | นโยบาย |
| 2 | Organization of Info Security | โครงสร้าง |
| 3 | Human Resource Security | Training, NDA |
| 4 | Asset Management | Inventory |
| 5 | Access Control | RBAC |
| 6 | Cryptography | Encryption |
| 7 | Physical Security | Data Center |
| 8 | Operations Security | Backup, Malware |
| 9 | Communications Security | Network |
| 10 | System Acquisition | SDLC |
| 11 | Supplier Relationships | Vendor |
| 12 | Incident Management | Response |
| 13 | Business Continuity | DR |
| 14 | Compliance | Audit |

---

## 14.10 Security Incident Response

### 14.10.1 Incident Response Phases

```
┌─────────────────────────────────────────────────────────────┐
│              INCIDENT RESPONSE (6 Phases)                   │
└─────────────────────────────────────────────────────────────┘

  ┌──────────────┐
  │ 1. Prepare   │  เตรียม Plan, Team, Tool
  └──────┬───────┘
         ▼
  ┌──────────────┐
  │ 2. Detect    │  SIEM, Alert, User Report
  └──────┬───────┘
         ▼
  ┌──────────────┐
  │ 3. Contain   │  Isolate, Revoke, Block
  └──────┬───────┘
         ▼
  ┌──────────────┐
  │ 4. Eradicate │  Remove Threat, Patch
  └──────┬───────┘
         ▼
  ┌──────────────┐
  │ 5. Recover   │  Restore, Monitor
  └──────┬───────┘
         ▼
  ┌──────────────┐
  │ 6. Lessons   │  RCA, Improve
  └──────────────┘
```

### 14.10.2 Security Incident Types

| ประเภท | ตัวอย่าง | Severity |
|--------|----------|:--------:|
| **Data Breach** | PII รั่วไหล | SEV-1 |
| **Unauthorized Access** | Admin ถูกขโมย | SEV-1 |
| **Malware** | Ransomware | SEV-1 |
| **DDoS** | ระบบล่ม | SEV-1/2 |
| **Phishing** | User ถูกหลอก | SEV-2 |
| **Insider Threat** | พนักงานขโมย | SEV-1 |
| **Vulnerability** | CVE Critical | SEV-2 |

### 14.10.3 Containment Strategies

| สถานการณ์ | Containment |
|-----------|-------------|
| **Account Compromised** | Revoke Token, Reset Password, MFA |
| **Data Leak** | Block Egress, Isolate Host |
| **Malware** | Isolate Network, Kill Process |
| **DDoS** | Rate Limit, WAF, CDN |
| **Insider** | Revoke Access, Preserve Evidence |

### 14.10.4 Evidence Preservation (Forensics)

**สำคัญ: ต้องเก็บ Evidence ก่อน Remediate**

| Evidence | วิธีเก็บ |
|----------|---------|
| **Memory** | Memory Dump |
| **Disk** | Snapshot |
| **Log** | Export |
| **Network** | PCAP |
| **Chat/Email** | Export |
| **Screenshot** | Capture |

**Chain of Custody:**

```markdown
# Chain of Custody

| # | Evidence | Collected By | Time | Hash | Stored At |
|---|----------|--------------|------|------|-----------|
| 1 | Memory Dump | Security A | 15:00 | SHA256:abc | S3://evidence |
| 2 | Disk Image | Security A | 15:30 | SHA256:def | S3://evidence |
| 3 | Log Export | DevOps B | 15:45 | SHA256:ghi | S3://evidence |
```

### 14.10.5 Communication (Security Incident)

| ผู้รับ | เนื้อหา | Timing |
|-------|---------|--------|
| **CISO** | ทันที | ≤ 15 นาที |
| **EM** | สรุป | ≤ 30 นาที |
| **Legal** | ถ้ากระทบกฎหมาย | ≤ 1 ชั่วโมง |
| **DPO** | ถ้ากระทบ PII | ≤ 1 ชั่วโมง |
| **Exec** | SEV-1 | ≤ 1 ชั่วโมง |
| **PDPC** | ถ้า Breach | ≤ 72 ชั่วโมง |
| **User** | ถ้ากระทบ | ตามความเหมาะสม |
| **Media** | ผ่าน PR เท่านั้น | ตาม PR |

### 14.10.6 Security Incident Report Template

```markdown
# Security Incident Report: SEC-001

**Incident:** SEC-001
**Type:** Data Breach / Unauthorized Access / ...
**Severity:** SEV-1
**Detected:** [YYYY-MM-DD HH:MM]
**Contained:** [YYYY-MM-DD HH:MM]
**Resolved:** [YYYY-MM-DD HH:MM]
**Incident Lead:** [ชื่อ]

## Summary
[สรุป 3–5 ประโยค]

## Impact
- **Data affected:** [ประเภท + จำนวน]
- **Users affected:** [จำนวน]
- **Systems affected:** [รายการ]
- **Business impact:** [ระบุ]

## Timeline
| เวลา | Event | Actor |
|------|-------|-------|
| HH:MM | Detected | SIEM |
| HH:MM | Acknowledged | SOC |
| HH:MM | Contained | Security |
| HH:MM | Eradicated | Security |
| HH:MM | Recovered | DevOps |

## Attack Vector
[ช่องทางที่ถูกโจมตี]

## Root Cause
[สาเหตุ]

## Containment Actions
- [Action 1]
- [Action 2]

## Eradication Actions
- [Action 1]

## Recovery Actions
- [Action 1]

## Evidence Preserved
- [Evidence 1]
- [Evidence 2]

## Notification
- [ ] CISO
- [ ] Legal
- [ ] DPO
- [ ] PDPC (ถ้า Breach)
- [ ] Users (ถ้ากระทบ)

## Lessons Learned
- [บทเรียน 1]
- [บทเรียน 2]

## Preventive Actions
| # | Action | Owner | Due |
|---|--------|-------|-----|
| 1 | [Action] | [ชื่อ] | [Date] |

## Attachments
- Evidence Log: [link]
- Log Export: [link]
- RCA Report: [link]
```

---

## 14.11 Audit & Evidence

### 14.11.1 Audit Types

| ประเภท | ผู้ทำ | ความถี่ |
|--------|-------|---------|
| **Internal Audit** | Internal Audit Team | ไตรมาส |
| **External Audit** | Big 4, Vendor | ปี |
| **Compliance Audit** | Regulator | ตามกฎหมาย |
| **Pen Test** | Vendor | ปี / ก่อน Release ใหญ่ |
| **Vulnerability Assessment** | Internal / Vendor | ไตรมาส |
| **Access Review** | Security / Manager | ไตรมาส |

### 14.11.2 Audit Evidence Checklist

**Access Control:**
- [ ] User List + Role
- [ ] Access Review Records
- [ ] Privileged Access Log
- [ ] Termination Process

**Change Management:**
- [ ] Change Request
- [ ] Approval Records
- [ ] Deploy Log
- [ ] Rollback Records

**Logging & Monitoring:**
- [ ] Log Retention
- [ ] Alert Configuration
- [ ] Incident Log
- [ ] Review Records

**Data Protection:**
- [ ] Encryption Evidence
- [ ] Data Classification
- [ ] Retention Policy
- [ ] Deletion Records

**Business Continuity:**
- [ ] Backup Log
- [ ] DR Test Records
- [ ] RTO/RPO Document

**Vendor Management:**
- [ ] Vendor List
- [ ] Contract
- [ ] Security Assessment
- [ ] SLA

### 14.11.3 Audit Log Requirements

| หัวข้อ | ข้อกำหนด |
|--------|----------|
| **Who** | User ID |
| **What** | Action |
| **When** | Timestamp (UTC) |
| **Where** | IP, Resource |
| **Result** | Success/Fail |
| **Tamper-proof** | Append-only |
| **Retention** | ≥ 5 ปี (Financial) |

```python
# Audit Log ตัวอย่าง
audit_logger.info(
    "Payment approved",
    extra={
        "event": "payment.approve",
        "user_id": user.id,
        "user_role": user.role,
        "resource": f"payment/{payment.id}",
        "action": "approve",
        "amount": payment.amount,
        "ip": request.client.host,
        "user_agent": request.headers.get("user-agent"),
        "timestamp": datetime.utcnow().isoformat(),
        "result": "success",
    },
)
```

---

## 14.12 Security Training & Awareness

### 14.12.1 Training Matrix

| กลุ่ม | หัวข้อ | ความถี่ | รูปแบบ |
|-------|--------|---------|--------|
| **ทุกคน** | Security Awareness | ปี | E-learning |
| **ทุกคน** | Phishing Simulation | ไตรมาส | Simulation |
| **Developer** | Secure Coding | ปี | Workshop |
| **Developer** | OWASP Top 10 | ปี | Workshop |
| **DevOps** | Cloud Security | ปี | Hands-on |
| **Management** | Security Governance | ปี | Workshop |
| **Key User** | Data Handling | ปี | E-learning |

### 14.12.2 Phishing Simulation

```
┌─────────────────────────────────────────────────────────────┐
│              PHISHING SIMULATION                            │
└─────────────────────────────────────────────────────────────┘

  Step 1: ส่ง Phishing Email (จำลอง)
         │
         ▼
  Step 2: วัดผล (Click Rate, Report Rate)
         │
         ▼
  Step 3: ถ้า Click → แสดง Training
         │
         ▼
  Step 4: รายงานผลให้ Management
         │
         ▼
  Step 5: ปรับปรุง Program
```

**เป้าหมาย:**

| KPI | Target |
|-----|--------|
| Click Rate | < 5% |
| Report Rate | > 80% |
| Training Completion | 100% |

---

## 14.13 KPIs สำหรับ Security & Compliance

| KPI | คำนิยาม | เป้าหมาย | วิธีวัด |
|-----|---------|----------|---------|
| **Critical Vulnerabilities** | จำนวน CVE Critical ที่เปิด | 0 | Scan Report |
| **High Vulnerabilities** | จำนวน CVE High ที่เปิด | ≤ 5 | Scan Report |
| **MTTP (Critical)** | Mean Time to Patch | ≤ 7 วัน | Patch Log |
| **MTTP (High)** | Mean Time to Patch | ≤ 30 วัน | Patch Log |
| **Secret Leaks** | จำนวน Secrets ที่หลุด | 0 | Scan Report |
| **Security Incidents** | จำนวน Incident/ไตรมาส | ≤ 1 | Incident Log |
| **MTTD (Security)** | Mean Time to Detect | ≤ 1 ชั่วโมง | SIEM |
| **MTTR (Security)** | Mean Time to Respond | ≤ 4 ชั่วโมง | Incident Log |
| **Access Review Completion** | % ที่ Review ตามรอบ | 100% | Audit |
| **Training Completion** | % พนักงานที่อบรม | 100% | LMS |
| **Phishing Click Rate** | % ที่ Click | < 5% | Simulation |
| **Compliance Audit Pass** | % ที่ผ่าน | 100% | Audit |
| **Pen Test Critical** | จำนวน Critical ที่พบ | 0 | Pen Test Report |
| **SBOM Coverage** | % Image ที่มี SBOM | 100% | CI Log |

### 14.13.1 Security Dashboard ตัวอย่าง

```
┌─────────────────────────────────────────────────────────────┐
│              SECURITY METRICS — Q4 2024                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Critical Vulns:      ██████████  0     🟢                 │
│  High Vulns:          ███████░░░  3     🟢                 │
│  MTTP (Critical):     █████████░  5 วัน 🟢                 │
│  Secret Leaks:        ██████████  0     🟢                 │
│  Security Incidents:  ████████░░  1     🟢                 │
│  MTTD:                ████████░░  45 นาที 🟢               │
│  MTTR:                ███████░░░  3 ชม.  🟢                │
│  Access Review:       ██████████  100%  🟢                 │
│  Training:            ██████████  100%  🟢                 │
│  Phishing Click:      ██░░░░░░░░  3%    🟢                 │
│  Compliance Audit:    ██████████  Pass  🟢                 │
│                                                              │
│  Highlights:                                                 │
│  • ไม่มี Critical Vulnerability ใน 3 เดือน                    │
│  • Phishing Click Rate ลดจาก 12% → 3%                      │
│                                                              │
│  Concerns:                                                   │
│  • High Vulnerabilities ใน Dev Dependencies (3)             │
│  • ต้องเพิ่ม Pen Test ก่อน Release ใหญ่                         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 14.14 Anti-Patterns

### 14.14.1 Security Anti-Patterns

| # | ❌ Anti-Pattern | ผลกระทบ | ✅ ควรทำ |
|---|----------------|---------|----------|
| 1 | Hardcode Secrets | รั่วไหล | Vault |
| 2 | ไม่มี MFA | Account ถูกขโมย | MFA บังคับ |
| 3 | Tin tưởng Input | Injection | Validate |
| 4 | Debug บน Prod | เผยข้อมูล | Disable |
| 5 | ไม่ Update Dependency | CVE | Update |
| 6 | ใช้ MD5/SHA1 Password | Crack ง่าย | Argon2 |
| 7 | Log Password | รั่วไหล | Mask |
| 8 | ไม่มี Rate Limit | Brute Force | Rate Limit |
| 9 | CORS * | CSRF | Allowlist |
| 10 | Không có Audit Log | ตรวจไม่ได้ | Audit |
| 11 | ใช้ HTTP | ดักข้อมูล | HTTPS |
| 12 | Default Password | รู้กัน | เปลี่ยน |
| 13 | ไม่มี Backup | กู้ไม่ได้ | Backup |
| 14 | Không có Incident Plan | Panic | Plan |
| 15 | ไม่ Training | Phishing | Training |

### 14.14.2 Compliance Anti-Patterns

| ❌ | ✅ |
|----|----|
| ไม่มี Data Inventory | มี Registry |
| ไม่มี Consent | ขอ Consent |
| เก็บนานเกิน | Retention Policy |
| ไม่มี DPO | มี DPO |
| ไม่แจ้ง Breach | แจ้ง 72 ชม. |
| ไม่มี Audit Log | มี + Retention |
| ไม่มี Access Review | Review ไตรมาส |
| ไม่มี Training | Training ปี |

---

## 14.15 Best Practices

### 14.15.1 Do's

- ✅ **Defense in Depth** — หลายชั้น
- ✅ **Least Privilege** — เท่าที่จำเป็น
- ✅ **Zero Trust** — ตรวจสอบทุกครั้ง
- ✅ **Shift Left** — Security ตั้งแต่ต้น
- ✅ **Secrets ใน Vault** — ไม่ Hardcode
- ✅ **MFA** — บังคับ
- ✅ **Encryption** — At Rest + Transit
- ✅ **Input Validation** — Allowlist
- ✅ **Audit Log** — ครบ + Tamper-proof
- ✅ **Security Testing** — SAST, DAST, SCA
- ✅ **Incident Plan** — ซ้อมเป็นประจำ
- ✅ **Training** — ทุกปี
- ✅ **Compliance** — ตามกฎหมาย

### 14.15.2 Don'ts

- ❌ Hardcode Secrets
- ❌ Commit `.env`
- ❌ Log PII
- ❌ ใช้ MD5/SHA1 Password
- ❌ Debug บน Prod
- ❌ CORS *
- ❌ ไม่มี Rate Limit
- ❌ ใช้ HTTP
- ❌ Default Password
- ❌ ไม่ Update Dependency
- ❌ ไม่มี Audit Log
- ❌ ไม่มี Incident Plan
- ❌ ไม่ Training
- ❌ ไม่มี Access Review
- ❌ เก็บข้อมูลนานเกิน

---

## 14.16 FAQ

**Q1: Security เป็นหน้าที่ของใคร?**
A: **ทุกคน** — ไม่ใช่แค่ทีม Security — Dev เขียน Code ปลอดภัย, QA ทดสอบ, DevOps Config, User ใช้งานปลอดภัย

**Q2: ต้องทำ Pen Test บ่อยแค่ไหน?**
A: **ปีละครั้ง** + **ก่อน Release ใหญ่** — หรือเมื่อมี Feature ที่กระทบ Security มาก

**Q3: ถ้าพบ Secret ใน Git ทำไง?**
A: (1) **Rotate ทันที** (2) ลบจาก History (3) Force Push (4) RCA (5) เพิ่ม Preventive — Secret นั้นถือว่ารั่วไหลแล้ว

**Q4: MFA บังคับทุกคนไหม?**
A: **แนะนำทุกคน** — บังคับอย่างน้อย Admin + ผู้เข้าถึงข้อมูลสำคัญ — User ทั่วไปแนะนำ

**Q5: ต้องเข้ารหัส Database ไหม?**
A: **ต้อง** — อย่างน้อย TDE (Transparent Data Encryption) — Field-level สำหรับ PII (เช่น email, phone)

**Q6: Log เก็บนานแค่ไหน?**
A: **≥ 1 ปี** สำหรับ Security Log — **≥ 5 ปี** สำหรับ Financial (SOX) — ตาม Compliance

**Q7: ถ้าไม่แน่ใจว่าเป็น Incident ไหม?**
A: **รายงานก่อน** — ทีม Security จะ Triage — False Positive ดีกว่า Miss

**Q8: PDPA ต้องมี DPO ไหม?**
A: **ถ้าเป็น Core Business** (เช่น FinTech) → **ต้องมี** — ถ้าไม่ใช่ → อาจไม่บังคับ แต่แนะนำ

**Q9: ต้องทำ Threat Model ทุก Feature ไหม?**
A: **ไม่** — ทำเมื่อ Feature กระทบ Security (Auth, Payment, PII) — Feature เล็กอาจใช้ Checklist แทน

**Q10: วัดผล Security ยังไง?**
A: ดู KPIs 14.13 — หลักๆ คือ Critical Vulns = 0, MTTP, Secret Leaks = 0, Incidents, Training

---

## 14.17 Glossary

| คำ | ความหมาย |
|----|----------|
| **CIA** | Confidentiality, Integrity, Availability |
| **RBAC** | Role-Based Access Control |
| **ABAC** | Attribute-Based Access Control |
| **MFA** | Multi-Factor Authentication |
| **SSO** | Single Sign-On |
| **OIDC** | OpenID Connect |
| **JWT** | JSON Web Token |
| **SAST** | Static Application Security Testing |
| **DAST** | Dynamic Application Security Testing |
| **SCA** | Software Composition Analysis |
| **SBOM** | Software Bill of Materials |
| **CVE** | Common Vulnerabilities and Exposures |
| **CVSS** | Common Vulnerability Scoring System |
| **WAF** | Web Application Firewall |
| **DDoS** | Distributed Denial of Service |
| **SSRF** | Server-Side Request Forgery |
| **XSS** | Cross-Site Scripting |
| **CSRF** | Cross-Site Request Forgery |
| **IDOR** | Insecure Direct Object Reference |
| **PDPA** | พ.ร.บ.คุ้มครองข้อมูลส่วนบุคคล |
| **GDPR** | General Data Protection Regulation |
| **PCI-DSS** | Payment Card Industry Data Security Standard |
| **SOX** | Sarbanes-Oxley Act |
| **ISO 27001** | Information Security Management |
| **DPO** | Data Protection Officer |
| **TDE** | Transparent Data Encryption |
| **KMS** | Key Management Service |
| **HSM** | Hardware Security Module |
| **SOC** | Security Operations Center |
| **SIEM** | Security Information and Event Management |
| **MTTD** | Mean Time to Detect |
| **MTTR** | Mean Time to Respond |
| **MTTP** | Mean Time to Patch |
| **STRIDE** | Spoofing, Tampering, Repudiation, Info Disclosure, DoS, Elevation |
| **PII** | Personally Identifiable Information |

---

## 14.18 ความเชื่อมโยงกับเล่มอื่น

| เล่ม | ความเชื่อมโยงกับเล่ม 14 |
|------|-------------------------|
| **เล่ม 1 (PO/BA)** | Security Requirement ใน User Story |
| **เล่ม 2 (Full-Stack)** | Secure Coding, Auth, Validation |
| **เล่ม 3 (Architect)** | Secure Architecture, Threat Model |
| **เล่ม 4 (QA)** | Security Testing, DAST |
| **เล่ม 5 (DevOps)** | Secrets, Container Scan, Infra |
| **เล่ม 6 (Code Review)** | Security Review Checklist |
| **เล่ม 7 (On-call)** | Security Incident Response |
| **เล่ม 10 (AI-Assisted)** | Scrutinize ตรวจ Security |
| **เล่ม 11 (Hotfix)** | Security Hotfix |
| **เล่ม 12 (CI/CD)** | Security Scan ใน Pipeline |
| **เล่ม 13 (RCA)** | RCA Security Incident |
| **เล่ม 15 (Knowledge)** | Security Training, Documentation |

---

## 14.19 สรุปสาระสำคัญ (Key Takeaways)

```text
┌─────────────────────────────────────────────────────────────┐
│              SECURITY & COMPLIANCE                          │
│                     KEY TAKEAWAYS                           │
└─────────────────────────────────────────────────────────────┘

  1. Security = ทุกคน — ไม่ใช่แค่ทีม Security
  2. CIA Triad — Confidentiality, Integrity, Availability
  3. Defense in Depth — 7 Layers
  4. Least Privilege — เท่าที่จำเป็น
  5. Zero Trust — Never Trust, Always Verify
  6. Shift Left — Security ตั้งแต่ Design
  7. OWASP Top 10 — รู้ + ป้องกัน
  8. Secrets Management — Vault, Rotate, Scan
  9. Encryption — At Rest + Transit
  10. Auth — MFA + SSO + Strong Policy
  11. Authz — RBAC + Check ทุก Endpoint
  12. Security Testing — SAST, DAST, SCA, Pen Test
  13. Threat Modeling — STRIDE ก่อน Code
  14. Secure SDLC — ทุก Phase
  15. Compliance — PDPA, GDPR, PCI-DSS, SOX, ISO 27001
  16. Incident Response — 6 Phases
  17. Audit — Log + Evidence + Retention
  18. Training — ทุกปี + Phishing Simulation
  19. วัดผล — Critical Vulns = 0, MTTP, Secret Leaks = 0
  20. อย่าละเลย — Security คือ Continuous
```

---
 
