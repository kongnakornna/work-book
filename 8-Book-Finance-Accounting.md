## 📘 เล่ม 8 (ฉบับขยาย): คู่มือผู้ใช้ (Finance & Accounting)

> **หมายเหตุ:** เอกสารนี้เป็นฉบับขยายของเล่ม 8 ใน Master Index โดยเพิ่มรายละเอียดเชิงปฏิบัติสำหรับผู้ใช้จริง ได้แก่ Field-by-Field Guide, Business Rules, Approval Workflow, Error Code Reference, Period-End Close, Key User / UAT Guide, FAQ และ Glossary

---

## 8.0 บทนำและกลุ่มเป้าหมาย

คู่มือนี้สำหรับ **ผู้ใช้ด้านการเงินและบัญชี** ที่ใช้งานระบบ **PMS (Payment Management System)** ในชีวิตประจำวัน

### 8.0.1 กลุ่มผู้ใช้ที่คู่มือนี้ครอบคลุม

| กลุ่มผู้ใช้ | บทบาท | ใช้ระบบทำอะไร |
|------------|-------|----------------|
| **Finance Staff** | ผู้บันทึกข้อมูล | บันทึก Payment, กระทบยอด, ออกรายงาน |
| **Finance Supervisor** | ผู้ตรวจสอบ | Review / Approve Payment |
| **Finance Manager** | ผู้อนุมัติ | Approve วงเงินสูง, ดู Dashboard |
| **Accounting Staff** | ผู้บันทึกบัญชี | กระทบยอด, ปิดงวด |
| **Key User** | ตัวแทนผู้ใช้ | ให้ Requirement, ทดสอบ UAT |
| **Auditor** | ผู้ตรวจสอบ | ดู Audit Trail, ออกรายงาน |

### 8.0.2 สิ่งที่ต้องเตรียมก่อนใช้งาน

- [ ] Azure AD Account (SSO) ที่ได้รับอนุมัติแล้ว
- [ ] สิทธิ์การเข้าถึงตาม Role (ขอจาก IT Admin)
- [ ] Browser เวอร์ชันล่าสุด (Chrome / Edge / Firefox)
- [ ] Network ที่เชื่อมต่อระบบได้ (VPN ถ้าอยู่นอกองค์กร)
- [ ] อ่านคู่มือนี้จบอย่างน้อยหัวข้อ 8.1–8.4

---

## 8.1 การเข้าสู่ระบบและภาพรวมหน้าจอ

### 8.1.1 ขั้นตอน Login (SSO)

```
1. เปิด Browser → เข้า URL: https://pms.your-company.com
2. คลิกปุ่ม [Sign in with Microsoft]
3. ระบบพาไปหน้า Azure AD Login
4. กรอก Email (@your-company.com) → Next
5. กรอก Password → Sign in
6. (ถ้าเปิด MFA) ยืนยันผ่าน Microsoft Authenticator
7. ระบบพากลับเข้า PMS → Dashboard
```

**หมายเหตุ:**
- ไม่ต้องจำ Password แยก — ใช้ Azure AD Account เดียวกับ Email
- Session หมดอายุใน **8 ชั่วโมง** หรือเมื่อปิด Browser
- ถ้า Login ไม่ได้ ดูหัวข้อ 8.6.1

### 8.1.2 ภาพรวมหน้าจอ Dashboard

```
┌────────────────────────────────────────────────────────────────┐
│  PMS — Payment Management System          [🔔] [👤 Somchai ▼]  │
├──────────────┬─────────────────────────────────────────────────┤
│              │  📊 FINANCIAL DASHBOARD                         │
│  📋 Menu     │  ┌──────────┐ ┌──────────┐ ┌──────────┐        │
│              │  │ Balance  │ │ Income   │ │ Expense  │        │
│  • Dashboard │  │ ฿ 12.5M  │ │ ฿ 3.2M   │ │ ฿ 1.8M   │        │
│  • Payment   │  └──────────┘ └──────────┘ └──────────┘        │
│  • Recon     │  ┌────────────────────────────────────┐        │
│  • Reports   │  │  Recent Transactions               │        │
│  • Master    │  │  • PAY-2024-001  ฿ 50,000  ✅      │        │
│    Data      │  │  • PAY-2024-002  ฿ 120,000 ⏳      │        │
│  • Audit     │  │  • PAY-2024-003  ฿ 15,000  ✅      │        │
│  • Settings  │  └────────────────────────────────────┘        │
└──────────────┴─────────────────────────────────────────────────┘
```

**องค์ประกอบหน้าจอ:**
| ส่วน | หน้าที่ |
|------|---------|
| **Sidebar Menu** | นำทางไปยังฟังก์ชันหลัก |
| **Notification (🔔)** | แจ้งเตือน Payment รอ Approve, งานค้าง |
| **User Menu (👤)** | Profile, Logout, Language |
| **Dashboard Cards** | สรุปยอดเงิน, รายรับ, รายจ่าย |
| **Recent Transactions** | รายการล่าสุด |

### 8.1.3 สิทธิ์การเข้าถึงตาม Role

| ฟังก์ชัน | Finance Staff | Supervisor | Manager | Auditor |
|----------|:-------------:|:----------:|:-------:|:-------:|
| ดู Dashboard | ✅ | ✅ | ✅ | ✅ |
| สร้าง Payment | ✅ | ✅ | ✅ | ❌ |
| แก้ไข Payment (Draft) | ✅ | ✅ | ✅ | ❌ |
| Approve Payment | ❌ | ✅ | ✅ | ❌ |
| ลบ Payment | ❌ | ❌ | ✅ | ❌ |
| Reconciliation | ✅ | ✅ | ✅ | ดูได้ |
| ออกรายงาน | ✅ | ✅ | ✅ | ✅ |
| Master Data | ดูได้ | ✅ | ✅ | ดูได้ |
| Audit Trail | ดูของตน | ✅ | ✅ | ✅ |

> ⚠️ ถ้าไม่เห็นเมนูที่ควรมี → ติดต่อ IT Admin ขอสิทธิ์

---

## 8.2 การบันทึก Payment (ละเอียด)

### 8.2.1 Payment Lifecycle

```
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│  Draft   │──►│ Pending  │──►│ Approved │──►│  Paid    │
│          │   │ Approval │   │          │   │          │
└──────────┘   └──────────┘   └──────────┘   └──────────┘
     │              │              │
     │              │              │
     ▼              ▼              ▼
┌──────────┐   ┌──────────┐   ┌──────────┐
│ Deleted  │   │ Rejected │   │ Cancelled│
└──────────┘   └──────────┘   └──────────┘
```

| สถานะ | ความหมาย | แก้ไขได้? |
|-------|----------|:---------:|
| **Draft** | บันทึกแล้วแต่ยังไม่ส่ง | ✅ |
| **Pending Approval** | ส่งขออนุมัติแล้ว | ❌ (ต้อง Reject ก่อน) |
| **Approved** | อนุมัติแล้ว | ❌ |
| **Paid** | จ่ายเงินแล้ว | ❌ |
| **Rejected** | ถูกปฏิเสธ | ✅ (แก้แล้วส่งใหม่) |
| **Cancelled** | ยกเลิก | ❌ |
| **Deleted** | ลบ | ❌ |

### 8.2.2 ขั้นตอนสร้าง Payment ใหม่

**Step 1: เปิดหน้าสร้าง**

```
เมนู Payment → คลิก [+ New Payment]
```

**Step 2: กรอกข้อมูล (Field-by-Field)**

| Field | คำอธิบาย | จำเป็น | ตัวอย่าง | Validation |
|-------|----------|:------:|----------|------------|
| **Payment Date** | วันที่จ่าย | ✅ | 2024-11-18 | ต้องไม่เป็นวันในอนาคต |
| **Amount** | จำนวนเงิน | ✅ | 50000.00 | > 0, ทศนิยม 2 ตำแหน่ง |
| **Currency** | สกุลเงิน | ✅ | THB | THB / USD / EUR |
| **Vendor** | ผู้รับเงิน | ✅ | ABC Co., Ltd. | เลือกจาก Master Data |
| **Description** | รายละเอียด | ✅ | ค่าบริการ IT ประจำเดือน | ≤ 500 ตัวอักษร |
| **Reference** | เลขอ้างอิง | ❌ | INV-2024-1234 | ≤ 50 ตัวอักษร |
| **Cost Center** | ศูนย์ต้นทุน | ✅ | CC-IT-01 | เลือกจาก Master |
| **GL Account** | บัญชีแยกประเภท | ✅ | 5100-IT Expense | เลือกจาก Master |
| **Payment Method** | วิธีจ่าย | ✅ | Bank Transfer | Transfer / Cheque / Cash |
| **Due Date** | วันครบกำหนด | ✅ | 2024-11-30 | ≥ Payment Date |
| **Attachment** | เอกสารแนบ | ❌ | Invoice.pdf | PDF/JPG, ≤ 10MB |

**Step 3: ตรวจสอบและบันทึก**

```
1. ตรวจสอบข้อมูลทุกช่อง (ดู Checklist 8.2.4)
2. คลิก [Save as Draft] — ถ้าต้องการแก้ไขต่อ
   หรือ [Submit for Approval] — ถ้าพร้อมส่ง
3. ระบบแสดง Confirmation + Record ID (PAY-YYYY-XXXX)
4. บันทึก Record ID ไว้ติดตาม
```

### 8.2.3 Business Rules ที่ต้องรู้

| กฎ | รายละเอียด |
|----|-----------|
| **วงเงินอนุมัติ** | ≤ 50,000 → Supervisor<br>> 50,000–500,000 → Manager<br>> 500,000 → Director |
| **Duplicate Check** | ระบบเตือนถ้า Amount + Vendor + Reference ซ้ำภายใน 30 วัน |
| **Future Date** | ไม่สามารถบันทึกวันในอนาคตเกิน 7 วัน |
| **Backdate** | ย้อนหลังได้ไม่เกิน 30 วัน (เกินต้องขอ Manager) |
| **Currency Rate** | USD/EUR ใช้ Rate ณ วันที่บันทึก (ระบบดึงอัตโนมัติ) |
| **Attachment** | ถ้า Amount > 100,000 **บังคับ**แนบ Invoice |
| **Cost Center** | ต้องเป็น Active เท่านั้น |

### 8.2.4 Checklist ก่อน Submit Payment

- [ ] Amount ถูกต้อง (ตรวจกับ Invoice)
- [ ] Currency ถูกต้อง
- [ ] Vendor ถูกต้อง (ไม่ใช่ Vendor ที่ Inactive)
- [ ] Description ชัดเจน ( auditors ต้องเข้าใจ)
- [ ] Cost Center ถูกต้อง
- [ ] GL Account ถูกต้อง
- [ ] Reference ตรงกับ Invoice
- [ ] Due Date ไม่เลยกำหนด
- [ ] เอกสารแนบครบ (ถ้า > 100,000)
- [ ] ไม่ใช่รายการซ้ำ (ตรวจ Recent Transactions)

### 8.2.5 การแก้ไข / ยกเลิก Payment

| สถานะปัจจุบัน | ทำอะไรได้ | วิธี |
|---------------|----------|------|
| Draft | แก้ไขได้ทุก Field | เปิด → แก้ → Save |
| Draft | ลบ | เปิด → [Delete] → Confirm |
| Pending | แก้ไม่ได้ | ต้องให้ Supervisor [Reject] ก่อน |
| Approved | แก้ไม่ได้ | ต้อง Manager [Cancel] แล้วสร้างใหม่ |
| Paid | แก้ไม่ได้ | ต้องทำ Journal Adjustment |

---

## 8.3 การกระทบยอด (Reconciliation)

### 8.3.1 ประเภทการกระทบยอด

| ประเภท | ความถี่ | ผู้รับผิดชอบ | เครื่องมือ |
|--------|---------|-------------|-----------|
| **Bank Reconciliation** | รายวัน | Finance Staff | หน้ากระทบยอด |
| **ERP Reconciliation** | รายวัน | Accounting | หน้ากระทบยอด + Report |
| **Intercompany Reconciliation** | รายเดือน | Accounting | Report |
| **Petty Cash Reconciliation** | รายสัปดาห์ | Finance Staff | Manual + Form |

### 8.3.2 ขั้นตอน Bank Reconciliation

```
Step 1: เตรียมข้อมูล
   ├─ ดาวน์โหลด Bank Statement (จาก Internet Banking)
   └─ ตรวจสอบว่า PMS Sync ข้อมูลครบ

Step 2: เปิดหน้ากระทบยอด
   └─ เมนู Reconciliation → เลือก [Bank Reconciliation]

Step 3: เลือกบัญชีและช่วงวันที่
   ├─ Bank Account: [เลือก]
   └─ Period: [Start] – [End]

Step 4: ระบบแสดง 2 ฝั่ง
   ├─ ฝั่งซ้าย: รายการใน PMS
   └─ ฝั่งขวา: รายการใน Bank Statement

Step 5: จับคู่ (Match)
   ├─ Auto-Match: ระบบจับคู่ให้อัตโนมัติ (ตรง Amount + Date + Ref)
   └─ Manual Match: ลากรายการมาจับคู่เอง (กรณีไม่ตรง)

Step 6: ตรวจสอบรายการที่ไม่ตรง
   ├─ รายการใน PMS แต่ไม่มีใน Bank → Outstanding
   ├─ รายการใน Bank แต่ไม่มีใน PMS → ต้องสอบถาม / บันทึกเพิ่ม
   └─ Amount ไม่ตรง → ตรวจสอบค่าธรรมเนียม / Rate

Step 7: ยืนยัน
   ├─ ตรวจสอบผลต่าง (ต้อง = 0)
   └─ คลิก [Confirm Reconciliation]

Step 8: ออกรายงาน
   └─ Export Reconciliation Report (PDF) เก็บไว้
```

### 8.3.3 สถานะการจับคู่

| สถานะ | ความหมาย | สี |
|-------|----------|-----|
| **Matched** | จับคู่แล้ว | 🟢 เขียว |
| **Unmatched (PMS)** | มีใน PMS ไม่มีใน Bank | 🟡 เหลือง |
| **Unmatched (Bank)** | มีใน Bank ไม่มีใน PMS | 🔴 แดง |
| **Discrepancy** | Amount ไม่ตรง | 🟠 ส้ม |
| **Manually Matched** | จับคู่ด้วยมือ | 🔵 ฟ้า |

### 8.3.4 Checklist ก่อน Confirm Reconciliation

- [ ] ผลต่างสุทธิ = 0
- [ ] รายการ Unmatched ทั้งหมดมีคำอธิบาย
- [ ] ไม่มี Discrepancy ที่ยังไม่แก้
- [ ] ตรวจสอบค่าธรรมเนียมธนาคาร
- [ ] ตรวจสอบรายการซ้ำ
- [ ] Export Report เก็บไว้
- [ ] แจ้ง Supervisor รับทราบ (ถ้ามีรายการค้าง)

---

## 8.4 การออกรายงาน (Reports)

### 8.4.1 ประเภทรายงานหลัก

| รายงาน | ใช้ทำอะไร | ผู้ใช้หลัก | ความถี่ |
|--------|-----------|-----------|---------|
| **Payment Register** | รายการ Payment ทั้งหมด | Finance, Auditor | รายวัน |
| **Payment Aging** | Payment ค้างชำระตามช่วงเวลา | Finance | รายสัปดาห์ |
| **Cash Position** | เงินคงเหลือแต่ละบัญชี | Manager | รายวัน |
| **Reconciliation Report** | ผลการกระทบยอด | Accounting | รายวัน |
| **Expense by Cost Center** | รายจ่ายแยกศูนย์ต้นทุน | Manager | รายเดือน |
| **Vendor Summary** | สรุปการจ่ายตาม Vendor | Finance | รายเดือน |
| **Audit Trail Report** | ประวัติการแก้ไข | Auditor | ตามต้องการ |
| **Tax Report (VAT/WHT)** | ภาษีหัก ณ ที่จ่าย | Accounting | รายเดือน |

### 8.4.2 ขั้นตอนออกรายงาน

```
1. เมนู Reports → เลือกรายงาน
2. กำหนด Filter:
   ├─ Period: [Start Date] – [End Date]
   ├─ Cost Center: [All / เลือก]
   ├─ Status: [All / Approved / Paid / ...]
   └─ Format: [Excel / PDF / CSV]
3. คลิก [Generate]
4. รอระบบประมวลผล (≤ 30 วินาที)
5. คลิก [Download] หรือ [Email to me]
```

### 8.4.3 Tips การใช้รายงาน

- **Excel Export** — ใช้เมื่อต้องวิเคราะห์ต่อ (Pivot, Filter)
- **PDF Export** — ใช้เมื่อต้อง Sign-off / เก็บเป็นเอกสาร
- **CSV Export** — ใช้เมื่อ Import เข้าระบบอื่น
- **Scheduled Report** — ตั้งให้ส่งอัตโนมัติทุกเช้า (เมนู Reports → Schedules)

### 8.4.4 การอ่านรายงาน Payment Aging

```
┌─────────────────────────────────────────────────────────────┐
│  PAYMENT AGING REPORT — ณ วันที่ 2024-11-18                  │
├──────────────┬────────┬────────┬────────┬────────┬─────────┤
│  Vendor      │ 0-30   │ 31-60  │ 61-90  │ >90    │ Total   │
├──────────────┼────────┼────────┼────────┼────────┼─────────┤
│  ABC Co.     │ 50,000 │ 20,000 │  0     │  0     │ 70,000  │
│  XYZ Ltd.    │ 30,000 │  0     │ 10,000 │  5,000 │ 45,000  │
├──────────────┼────────┼────────┼────────┼────────┼─────────┤
│  TOTAL       │ 80,000 │ 20,000 │ 10,000 │  5,000 │ 115,000 │
└──────────────┴────────┴────────┴────────┴────────┴─────────┘
```

| ช่วง | ความหมาย | Action |
|------|----------|--------|
| 0–30 วัน | ปกติ | ติดตามตามรอบ |
| 31–60 วัน | เริ่มค้าง | ติดตามเร่ง |
| 61–90 วัน | ค้างนาน | แจ้ง Supervisor |
| > 90 วัน | วิกฤต | แจ้ง Manager + วางแผน |

---

## 8.5 Period-End Close (ปิดงวด)

### 8.5.1 Timeline การปิดงวดรายเดือน

```
┌─────────────────────────────────────────────────────────────┐
│              MONTH-END CLOSE TIMELINE                       │
└─────────────────────────────────────────────────────────────┘

  วันที่ 1-3:  บันทึก Transaction ทั้งหมด
              │
  วันที่ 4:    กระทบยอด Bank + ERP
              │
  วันที่ 5:    ตรวจสอบรายการค้าง (Outstanding)
              │
  วันที่ 6:    ออกรายงานภาษี (VAT/WHT)
              │
  วันที่ 7:    Supervisor Review
              │
  วันที่ 8:    Manager Approve + Lock Period
              │
  วันที่ 9-10: เก็บเอกสาร + Archive
```

### 8.5.2 Checklist ก่อนปิดงวด

**ด้าน Transaction:**
- [ ] Payment ทั้งหมดบันทึกครบ
- [ ] ไม่มี Draft ค้าง
- [ ] ไม่มี Pending Approval ค้าง
- [ ] ไม่มี Payment ที่รอ Paid นานผิดปกติ

**ด้าน Reconciliation:**
- [ ] Bank Reconciliation ครบทุกบัญชี
- [ ] ERP Reconciliation ครบ
- [ ] ผลต่าง = 0 ทุกบัญชี
- [ ] รายการ Outstanding มีคำอธิบาย

**ด้านรายงาน:**
- [ ] Payment Register ครบ
- [ ] Tax Report ครบ
- [ ] Expense by Cost Center ครบ
- [ ] Export เก็บไว้ทุกฉบับ

**ด้านการอนุมัติ:**
- [ ] Supervisor Review แล้ว
- [ ] Manager Approve แล้ว
- [ ] Lock Period ในระบบแล้ว

### 8.5.3 ข้อควรระวังช่วงปิดงวด

| ข้อควรระวัง | ผลกระท� |
|-------------|---------|
| ห้าม Backdate หลัง Lock Period | ระบบจะ Block |
| ห้ามแก้ Master Data ระหว่างปิด | อาจกระทบ Report |
| ต้อง Export ก่อน Lock | หลัง Lock แก้ไม่ได้ |
| ต้อง Backup เอกสาร | Audit ต้องใช้ |

---

## 8.6 การแก้ไขปัญหาเบื้องต้น (ฉบับขยาย)

### 8.6.1 ปัญหา Login

| อาการ | สาเหตุ | วิธีแก้ |
|-------|--------|---------|
| Login ไม่ได้ — "Invalid credentials" | Password ผิด / Account ถูก Lock | Reset Password ที่ Azure AD |
| Login ไม่ได้ — "Account not found" | ยังไม่มี Account | ติดต่อ IT Admin |
| Login ไม่ได้ — "MFA required" | ยังไม่ตั้ง MFA | ตั้งผ่าน Microsoft Authenticator |
| Login ได้แต่เข้าไม่ได้ — "Access Denied" | ไม่มีสิทธิ์ Role | ติดต่อ IT Admin ขอสิทธิ์ |
| Session หมดอายุบ่อย | Network / Browser | ตรวจ Network, ลอง Chrome |
| หน้า Login ค้าง | Cache | Ctrl+F5, ลอง Incognito Mode |

### 8.6.2 ปัญหาการบันทึก

| Error Code | ข้อความ | สาเหตุ | วิธีแก้ |
|------------|---------|--------|---------|
| **E-1001** | "Amount must be greater than 0" | Amount ≤ 0 | ตรวจสอบ Amount |
| **E-1002** | "Duplicate payment detected" | ซ้ำภายใน 30 วัน | ตรวจ Recent, เปลี่ยน Ref |
| **E-1003** | "Vendor is inactive" | Vendor ถูกปิด | ติดต่อ Master Data Admin |
| **E-1004** | "Cost center is invalid" | CC ไม่มี / ปิด | เลือก CC ที่ Active |
| **E-1005** | "Attachment required for amount > 100,000" | ไม่แนบเอกสาร | แนบ Invoice |
| **E-1006** | "Payment date cannot be in the future" | วันที่อนาคต | เปลี่ยนเป็นวันนี้ |
| **E-1007** | "Backdate exceeds 30 days" | ย้อนเกิน 30 วัน | ขอ Manager อนุมัติ |
| **E-1008** | "Period is locked" | งวดถูกล็อก | ติดต่อ Accounting |
| **E-1009** | "Currency rate not found" | ไม่มี Rate วันนั้น | แจ้ง Admin เพิ่ม Rate |
| **E-1010** | "Approval limit exceeded" | เกินวงเงิน Role | ส่งให้ Role สูงกว่า |

### 8.6.3 ปัญหาหน้าจอ / Performance

| อาการ | สาเหตุ | วิธีแก้ |
|-------|--------|---------|
| หน้าโหลดช้า | Cache / Network | Ctrl+F5, ตรวจ Network, ลอง Browser อื่น |
| หน้าจอค้าง | Session / Network | Refresh, Login ใหม่ |
| ข้อมูลไม่แสดง | Filter / สิทธิ์ | ตรวจ Filter, ตรวจ Role |
| Export ไม่ได้ | Pop-up Block | อนุญาต Pop-up |
| Report ค้างนาน | ข้อมูลเยอะ | ลดช่วงวันที่, รอ, แจ้ง Support |
| Layout เพี้ยน | Browser เก่า | อัปเดต Browser, ลอง Chrome |

### 8.6.4 ปัญหาข้อมูล

| อาการ | วิธีตรวจสอบ | วิธีแก้ |
|-------|-------------|---------|
| ยอดไม่ตรงกับ Bank | ดู Reconciliation Report | กระทบยอดใหม่ |
| ยอดไม่ตรงกับ ERP | ดู ERP Sync Status | แจ้ง IT ถ้า Sync ล่ม |
| ข้อมูลหาย | ดู Audit Trail | ตรวจว่าถูกแก้/ลบโดยใคร |
| Payment ซ้ำ | ดู Recent + Search Ref | ยกเลิกตัวซ้ำ (ถ้าได้) |
| สถานะไม่เปลี่ยน | ดู Approval Status | ตรวจว่า Approver อนุมัติหรือยัง |
| ไม่เห็นรายการที่เพิ่งบันทึก | Filter / Cache | ล้าง Filter, Refresh |

---

## 8.7 การติดต่อ Support (ฉบับขยาย)

### 8.7.1 Support Tiers

```
┌─────────────────────────────────────────────────────────────┐
│                    SUPPORT TIERS                            │
└─────────────────────────────────────────────────────────────┘

  Level 1: Help Desk (ภายในองค์กร)
  ├─ เรื่อง: Login, Password, สิทธิ์, การใช้งานเบื้องต้น
  ├─ ช่องทาง: โทรภายใน / Ticket
  └─ SLA: ≤ 4 ชั่วโมง

  Level 2: ทีม FinTech & Accounting
  ├─ เรื่อง: Business Logic, ข้อมูลผิด, Report ผิด
  ├─ ช่องทาง: Ticket / Email
  └─ SLA: ≤ 1 วันทำการ

  Level 3: Full-Stack Engineer (On-call)
  ├─ เรื่อง: Bug, ระบบล่ม, ข้อมูลหาย
  ├─ ช่องทาง: Ticket → Escalate
  └─ SLA: ตาม Severity (ดูเล่ม 7)
```

### 8.7.2 ข้อมูลที่ต้องแจ้งเมื่อติดต่อ Support

**บังคับ (ขาดไม่ได้):**
- [ ] ชื่อ-นามสกุล + Email
- [ ] เวลาที่เกิดปัญหา (ระบุ Timezone)
- [ ] หน้าที่เกิดปัญหา (URL / เมนู)
- [ ] สิ่งที่ทำก่อนเกิดปัญหา (Step-by-step)
- [ ] ข้อความ Error (ถ้ามี — แนบ Screenshot)

**ถ้ามี (ช่วยให้แก้เร็วขึ้น):**
- [ ] Record ID (PAY-XXXX, INC-XXXX)
- [ ] Screenshot / Video
- [ ] Browser + Version
- [ ] จำนวนครั้งที่เกิด (ครั้งเดียว / ทุกครั้ง)
- [ ] ผลกระทบ (ทำงานต่อได้ไหม)

### 8.7.3 Template การแจ้งปัญหา

```markdown
# Support Ticket

**ผู้แจ้ง:** [ชื่อ] — [Email]
**วันที่/เวลา:** [YYYY-MM-DD HH:MM]
**หน้า/เมนู:** [Payment / Reconciliation / ...]
**Record ID:** [ถ้ามี]

## อาการ
[อธิบายสิ่งที่เกิดขึ้น]

## ขั้นตอนที่ทำ
1. [Step 1]
2. [Step 2]
3. [Step 3]

## ผลที่คาดหวัง
[สิ่งที่ควรเกิดขึ้น]

## ผลที่เกิดขึ้นจริง
[สิ่งที่เกิดขึ้น]

## ข้อความ Error
[Copy ข้อความ / แนบ Screenshot]

## ผลกระทบ
[ ] ทำงานต่อไม่ได้  [ ] ทำงานได้แต่ช้า  [ ] แค่สงสัย

## แนบไฟล์
- Screenshot: [filename]
```

### 8.7.4 ช่องทางติดต่อ

| ช่องทาง | ใช้เมื่อ | Response Time |
|---------|---------|---------------|
| **Help Desk (โทร)** | เร่งด่วน, ระบบล่ม | ≤ 30 นาที |
| **Ticket System** | ปัญหาทั่วไป | ≤ 4 ชั่วโมง |
| **Email** | เรื่องไม่เร่ง | ≤ 1 วัน |
| **Slack #pms-support** | ถามเร็วๆ | Best effort |
| **Emergency (โทร)** | SEV-1 ระบบล่ม | ≤ 5 นาที |

---

## 8.8 ข้อควรระวังด้านความปลอดภัย

### 8.8.1 ข้อห้าม (Prohibitions)

| # | ข้อห้าม | เหตุผล |
|---|---------|--------|
| 1 | ❌ ห้ามแชร์ Password ให้ใคร | Account รั่วไหล |
| 2 | ❌ ห้ามใช้ Public Wi-Fi บันทึกข้อมูลสำคัญ | ดักข้อมูลได้ |
| 3 | ❌ ห้ามถ่าย Screenshot ข้อมูลลูกค้าลง Social | PDPA |
| 4 | ❌ ห้าม Login แทนกัน | Audit ไม่ชัด |
| 5 | ❌ ห้าม Leave Session ค้างโดยไม่ Logout | คนอื่นใช้ต่อได้ |
| 6 | ❌ ห้าม Forward Email ที่มีข้อมูลการเงินออกนอกองค์กร | รั่วไหล |
| 7 | ❌ ห้ามใช้ USB ส่วนตัว Copy ข้อมูล | นำไวรัส/ข้อมูลออก |
| 8 | ❌ ห้าม Approve Payment ที่ไม่ตรวจสอบ | ความรับผิดชอบ |

### 8.8.2 ข้อปฏิบัติ (Do's)

- ✅ Logout ทุกครั้งหลังใช้งาน
- ✅ ใช้ Password ที่แข็งแรง + MFA
- ✅ ตรวจสอบข้อมูลก่อน Submit ทุกครั้ง
- ✅ เก็บ Record ID / เอกสารอ้างอิง
- ✅ รายงาน Suspicious Activity ทันที
- ✅ Lock Screen เมื่อลุกจากโต๊ะ
- ✅ ใช้ VPN เมื่ออยู่นอกองค์กร
- ✅ อัปเดต Browser สม่ำเสมอ

### 8.8.3 PDPA / Data Privacy

| ประเภทข้อมูล | การจัดการ |
|-------------|-----------|
| **ข้อมูลลูกค้า (PII)** | ใช้ตามหน้าที่, ห้ามแชร์ |
| **ข้อมูลการเงิน** | เก็บเป็นความลับ, ห้ามถ่ายรูป |
| **ข้อมูล Vendor** | ใช้ตามสัญญา, ห้ามเปิดเผย |
| **Log/Audit** | เก็บตามนโยบาย (≥ 5 ปี) |

> ⚠️ ถ้าพบข้อมูลรั่วไหล → แจ้งทันทีที่ **Security Team** + **DPO**

---

## 8.9 คู่มือสำหรับ Key User / UAT

### 8.9.1 บทบาท Key User

| หน้าที่ | รายละเอียด |
|---------|-----------|
| **ให้ Requirement** | บอกความต้องการกับ BA/PO |
| **ทดสอบ UAT** | ทดสอบระบบก่อน Go-Live |
| **Sign-off** | ยืนยันว่าระบบใช้งานได้ |
| **Feedback** | รายงาน Bug / ข้อเสนอแนะ |
| **Train User** | ช่วยสอนเพื่อนร่วมงาน |

### 8.9.2 ขั้นตอน UAT

```
1. รับ Test Case + Test Data จาก QA
2. ทดสอบตาม Scenario ใน Staging Environment
3. บันทึกผล: Pass / Fail / Blocked
4. ถ้า Fail → รายงาน Defect (ตาม Template 8.9.3)
5. ถ้า Pass → Sign-off
6. เข้าร่วม UAT Review Meeting
```

### 8.9.3 UAT Test Case Template

```markdown
# UAT Test Case: UTC-001

**Scenario:** บันทึก Payment ปกติ
**Priority:** P0
**Tester:** [ชื่อ Key User]
**Date:** [YYYY-MM-DD]

## Preconditions
- Login เป็น Finance Staff
- มี Vendor "ABC Co." ใน Master Data

## Steps
1. ไปที่ Payment → New
2. กรอก Amount = 50,000
3. Currency = THB
4. Vendor = ABC Co.
5. Description = "Test payment"
6. Cost Center = CC-IT-01
7. GL Account = 5100
8. Payment Method = Bank Transfer
9. Due Date = [วันนี้ + 7]
10. คลิก Submit for Approval

## Expected
- ระบบแสดง "Payment created: PAY-2024-XXXX"
- สถานะ = Pending Approval
- Notification ส่งถึง Supervisor

## Actual
[ผลจริง]

## Status
[ ] Pass  [ ] Fail  [ ] Blocked

## Comments
[หมายเหตุ]
```

### 8.9.4 UAT Sign-off Template

```markdown
# UAT Sign-off

**Project:** PMS Phase X
**UAT Period:** [Start] – [End]
**Key Users:** [รายชื่อ]

## Summary
| Module | Total TC | Pass | Fail | Pass Rate |
|--------|----------|------|------|-----------|
| Payment | 20 | 19 | 1 | 95% |
| Recon | 15 | 15 | 0 | 100% |
| Reports | 10 | 9 | 1 | 90% |

## Open Issues
| ID | Description | Severity | Status |
|----|-------------|----------|--------|
| BUG-001 | Export PDF ผิด Format | Low | Accepted |

## Sign-off Decision
[ ] ✅ Ready for Go-Live
[ ] ⚠️ Ready with Conditions (ระบุ)
[ ] ❌ Not Ready

**ลงชื่อ:** _________________
**ชื่อ:** [Key User Lead]
**วันที่:** [YYYY-MM-DD]
```

---

## 8.10 Keyboard Shortcuts และ Tips

### 8.10.1 Shortcuts ที่ใช้บ่อย

| Shortcut | ฟังก์ชัน |
|----------|----------|
| `Ctrl + S` | Save (ในฟอร์ม) |
| `Ctrl + Enter` | Submit |
| `Esc` | ปิด Modal / ยกเลิก |
| `Ctrl + F` | ค้นหา (ในตาราง) |
| `Ctrl + P` | Print Report |
| `Alt + ←` | ย้อนกลับ |
| `G + D` | ไป Dashboard |
| `G + P` | ไป Payment |
| `G + R` | ไป Reports |
| `?` | แสดง Shortcuts ทั้งหมด |

### 8.10.2 Tips การใช้งาน

- **ใช้ Filter** ทุกครั้งก่อน Export (ลดข้อมูล, เร็วขึ้น)
- **ตั้ง Scheduled Report** สำหรับรายงานที่ใช้ทุกวัน
- **ใช้ Search** (Ctrl+F ในตาราง) แทนการเลื่อนหา
- **Save Draft** ก่อน Submit ถ้าไม่แน่ใจ
- **Pin** เมนูที่ใช้บ่อย (คลิกขวา → Pin)
- **ดู Audit Trail** ทุกครั้งที่สงสัยว่าข้อมูลเปลี่ยน

---

## 8.11 FAQ (คำถามที่พบบ่อย)

**Q1: ลืม Password ทำไง?**
A: ไปที่ https://myaccount.microsoft.com → Reset Password หรือติดต่อ IT Help Desk

**Q2: Login ได้แต่ไม่เห็นเมนู Payment?**
A: Role ยังไม่ครบ → ติดต่อ IT Admin ขอสิทธิ์ Finance Staff

**Q3: บันทึก Payment แล้ว Amount ไม่ตรง?**
A: ตรวจสอบ Currency Rate ณ วันนั้น (USD/EUR) หรือติดต่อ Support

**Q4: กระทบยอดแล้วผลต่างไม่เป็น 0?**
A: ตรวจสอบ: (1) รายการ Outstanding (2) ค่าธรรมเนียมธนาคาร (3) รายการซ้ำ — ถ้ายังไม่หาย แจ้ง Accounting

**Q5: Export Excel แล้วเปิดไม่ได้?**
A: ตรวจสอบว่า Download เสร็จ, ลอง Excel เวอร์ชันใหม่, ลอง Export เป็น CSV

**Q6: Approval ค้างนาน ทำไง?**
A: ดู Notification ว่า Pending ที่ใคร → ติดต่อ Approver โดยตรง หรือแจ้ง Supervisor

**Q7: ปิดงวดแล้วแต่ต้องแก้รายการ?**
A: ต้องขอ **Period Reopen** จาก Accounting Manager (มีเอกสารอนุมัติ)

**Q8: ระบบช้ามากช่วงปิดงวด?**
A: เป็นช่วง Peak → หลีกเลี่ยงช่วง 09:00–11:00, ใช้ Filter ให้แคบลง, แจ้ง IT ถ้าช้ามากผิดปกติ

**Q9: ข้อมูลหายจาก Dashboard?**
A: ตรวจ Filter (อาจตั้งช่วงวันที่ผิด) → ล้าง Filter → Refresh (Ctrl+F5)

**Q10: ต้อง Print Report เพื่อ Sign-off ทำไง?**
A: Export PDF → Print → เซ็น → Scan → เก็บเข้า Document System

---

## 8.12 Glossary (ศัพท์ที่ใช้)

| คำ | ความหมาย |
|----|----------|
| **PMS** | Payment Management System — ระบบบริหารการจ่ายเงิน |
| **SSO** | Single Sign-On — Login ครั้งเดียวใช้ได้หลายระบบ |
| **MFA** | Multi-Factor Authentication — ยืนยันตัวตน 2 ชั้น |
| **Reconciliation** | การกระทบยอด — ตรวจสอบว่าข้อมูล 2 แหล่งตรงกัน |
| **Outstanding** | รายการค้าง — ยังไม่จับคู่ |
| **Discrepancy** | ความไม่ตรงกันของยอด |
| **Cost Center (CC)** | ศูนย์ต้นทุน — หน่วยที่รับผิดชอบค่าใช้จ่าย |
| **GL Account** | บัญชีแยกประเภท — หมวดบัญชี |
| **Period Close** | การปิดงวด — ล็อกข้อมูลของเดือน |
| **UAT** | User Acceptance Testing — ทดสอบโดยผู้ใช้ |
| **Audit Trail** | ประวัติการแก้ไข — ใครทำอะไรเมื่อไหร่ |
| **Vendor** | ผู้ขาย / ผู้รับเงิน |
| **Aging** | การจัดกลุ่มตามระยะเวลาค้าง |
| **PDPA** | พ.ร.บ.คุ้มครองข้อมูลส่วนบุคคล |
| **ERP** | Enterprise Resource Planning — ระบบบริหารองค์กร (เช่น Oracle) |

---

## 8.13 ความเชื่อมโยงกับเล่มอื่น

| เล่ม | ความเชื่อมโยงกับเล่ม 8 |
|------|------------------------|
| **เล่ม 1 (PO/BA)** | User Story ที่ User ใช้งาน — Key User ให้ Requirement |
| **เล่ม 4 (QA)** | UAT ที่ Key User ทดสอบ |
| **เล่ม 7 (On-call)** | Incident ที่ User Report → On-call รับช่วง |
| **เล่ม 13 (RCA)** | ปัญหาที่ User Report → RCA |
| **เล่ม 14 (Security)** | ความปลอดภัยของข้อมูลที่ User จัดการ |

---

## 8.14 สรุปสาระสำคัญ (Key Takeaways)

```text
┌─────────────────────────────────────────────────────────────┐
│              FINANCE & ACCOUNTING USER                      │
│                     KEY TAKEAWAYS                           │
└─────────────────────────────────────────────────────────────┘

  1. Login ด้วย SSO — Logout ทุกครั้ง
  2. บันทึก Payment — ตรวจ Checklist ก่อน Submit
  3. กระทบยอด — ผลต่างต้อง = 0 ก่อน Confirm
  4. ออกรายงาน — Filter ให้แคบ, Export เก็บไว้
  5. ปิดงวด — ทำตาม Timeline, Export ก่อน Lock
  6. Error — ดู Code, แก้ตามตาราง 8.6
  7. แจ้ง Support — ให้ข้อมูลครบ (Record ID, Screenshot)
  8. ความปลอดภัย — ห้ามแชร์ Password, ใช้ VPN
  9. Key User — ทดสอบ UAT, Sign-off ก่อน Go-Live
  10. สงสัย — ดู FAQ (8.11), ถาม Help Desk
```

---

 