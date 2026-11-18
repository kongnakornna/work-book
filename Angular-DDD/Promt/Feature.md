# Role Definition
คุณคือ Senior Frontend Developer และ Solutions Architect ผู้เชี่ยวชาญด้าน TypeScript, Clean Architecture, Domain-Driven Design (DDD) และ AngularJS (1.x) 

# Task Goal
ช่วยออกแบบและเขียนโค้ด feature/Module ใหม่ตามรายละเอียดดังนี้:
[ระบุชื่อ feature เช่น: Employee Management / Accounts Management]

### Requirement Details:
- Endpoint/Action: [เช่น POST http://localhost:8080/employee]
- Business Logic & Rules:
  1. [ข้อกำหนด 1 เช่น: id ต้อง autogenerate เป็น UUID]
  2. [ข้อกำหนด 2 เช่น: full_name เป็น required field]
  3. [ข้อกำหนด 3 เช่น: email เป็น require และห้ามซ้ำ]
  4. [ข้อกำหนด 4 เช่น: created_at และ updated_at ต้องกำหนดเป็นเวลาปัจจุบัน]

---

# Execution Steps (ปฏิบัติตามลำดับขั้นตอนดังนี้)

### Step 1: Brainstorming & Analysis (`/tb-brainstorming`)
1. วิเคราะห์ความเข้าใจของ Task และค้นหา Assumptions ที่อาจผิดพลาด
2. วิเคราะห์ข้อกำหนด (Business Rules) และ Edge Cases
3. ระบุส่วนที่กระทบ (Impact Analysis) และระบุข้อห้าม:
   - ห้ามแก้ไขโครงสร้างเดิมของโปรเจกต์
   - ห้ามแก้ไข Common/Shared functions ที่ใช้งานร่วมกันโดยไม่จำเป็น
4. แสดง ข้อดี / ข้อเสีย / ข้อควรระวัง ของแนวทางที่เลือก
5. วาด Data Flow / Sequence Diagram ด้วย ASCII Flowchart แสดงกระบวนการทำงานจาก Presentation -> Application (Use Case) -> Domain (Entity/Value Object) -> Data/Infrastructure

### Step 2: Planning (`/tb-writing-plans`)
ระบุโครงสร้างโฟลเดอร์และไฟล์ทั้งหมดของ Module ตามแนวทาง Clean Architecture + DDD บน AngularJS 1.x:

# โมดูล xxx  (feature Module)

## 1. ภาพรวมของโมดูล

โมดูล xxx ทำหน้าที่จัดการข้อมูล xxx ทั้งหมดในระบบ ครอบคลุมการจัดการบริษัท (Companies),
ผู้ติดต่อ (Contacts), ยานพาหนะ (Vehicles) และประวัติการเข้ารับบริการ (Service History)
ออกแบบตามหลัก Clean Architecture โดยแบ่งเป็น 3 ชั้น (Layers) ได้แก่ Domain, Data และ Presentation

## 2. โครงสร้างโฟลเดอร์

```
feature/
├── domain/
│   ├── entities/
│   │   └── feature.entity.ts
│   ├── repositories/
│   │   └── feature.repository.ts
│   └── use-cases/
│       ├── list-features.use-case.ts
│       ├── list-features.use-case.spec.ts
│       ├── create-feature.use-case.ts
│       └── create-feature.use-case.spec.ts
├── data/
│   ├── datasources/
│   │   └── feature.api.datasource.ts
│   ├── dtos/
│   │   └── feature-response.dto.ts
│   └── repositories/
│       └── feature.repository.impl.ts
└── presentation/
    └── pages/
        └── feature-list/
            ├── feature-list.component.ts
            ├── feature-list.component.html
            └── feature-list.component.spec.ts
```

## 3. ไฟล์สำคัญและหน้าที่

### Domain Layer
- **`domain/entities/feature.entity.ts`** — กำหนด Entity หลักของ xxx  ซึ่งเป็นโครงสร้างข้อมูลที่ไม่ขึ้นกับเทคโนโลยีใด ๆ
- **`domain/repositories/feature.repository.ts`** — Interface ของ Repository ที่กำหนดสัญญาระหว่าง Domain และ Data Layer
- **`domain/use-cases/list-features.use-case.ts`** — Use Case สำหรับดึงรายการ xxx  (รองรับการค้นหาและแบ่งหน้า)
- **`domain/use-cases/create-feature.use-case.ts`** — Use Case สำหรับสร้าง xxx ใหม่

### Data Layer
- **`data/datasources/feature.api.datasource.ts`** — จัดการการสื่อสารกับ API ภายนอก (ICMON API)
- **`data/dtos/feature-response.dto.ts`** — DTO (Data Transfer Object) สำหรับแปลงข้อมูลที่ได้จาก API
- **`data/repositories/feature.repository.impl.ts`** — Implement Repository ตาม Interface ที่ Domain กำหนด โดยเรียกใช้ Datasource

### Presentation Layer
- **`presentation/pages/feature-list/feature-list.component.ts`** — Standalone Component สำหรับแสดงรายการ xxx  (เส้นทาง: `/features`)
- **`presentation/pages/feature-list/feature-list.component.html`** — เทมเพลตของหน้าแสดงรายการ xxx 

## 4. API Endpoints ที่ใช้งาน

โมดูลนี้ทำงานร่วมกับ **ICMON API v1** ผ่าน endpoints ดังนี้:

### features
| Method | Endpoint | คำอธิบาย |
|--------|----------|----------|
| GET | `/api/v1/features` | ค้นหา xxx  (รองรับ pagination) |
| POST | `/api/v1/features` | สร้าง xxx ใหม่ |
| GET | `/api/v1/features/{id}` | ดึงข้อมูล xxx ตาม ID |
| PUT | `/api/v1/features/{id}` | อัปเดตข้อมูล xxx  |
| DELETE | `/api/v1/features/{id}` | ลบ xxx  (soft delete) |
| GET | `/api/v1/features/phone/{phone}` | ค้นหา xxx ตามเบอร์โทรศัพท์ |
| GET | `/api/v1/features/{id}/history` | ดึงประวัติการเข้ารับบริการของ xxx  |

### Cars
| Method | Endpoint | คำอธิบาย |
|--------|----------|----------|
| POST | `/api/v1/cars` | สร้างรถใหม่ |
| GET | `/api/v1/cars/feature/{featureId}` | ดึงรายการรถของ xxx  |
| GET | `/api/v1/cars/plate/{licensePlate}` | ค้นหารถตามทะเบียน |
| GET | `/api/v1/cars/{id}` | ดึงข้อมูลรถตาม ID |
| PUT | `/api/v1/cars/{id}` | อัปเดตข้อมูลรถ |
| DELETE | `/api/v1/cars/{id}` | ลบรถ (soft delete) |



Step 3: Execution & Implementation (/tb-executing-plans)
เขียนโค้ดฉบับสมบูรณ์ที่พร้อมใช้งาน (Production-ready) ครบทุกไฟล์ตาม Clean Architecture:

Domain Layer: Entities, Value Objects, Repository Interfaces, Use Cases (Pure TS, ไม่ติด Framework)

Data Layer: DTOs, Mappers, API DataSources ($http), Repository Implementations

Presentation Layer: Controllers (ใช้ static $inject), Components/Views

Module Registration: ลงทะเบียน DI ใน AngularJS Module ด้วย .factory() และ .controller()

Step 4: Verification & Proof of Work
สรุปผลการดำเนินงาน

แสดงขั้นตอนการทดสอบ (Unit Test / Integration Test scenario)