การประยุกต์ใช้ **TypeScript + Clean Architecture + Domain-Driven Design (DDD)** บน **AngularJS (1.x)** ร่วมกับ **Workflow ลำดับขั้นตอน (Thoughtworks / Task-Based Execution Flow)** เพื่อสร้าง **Prompt Template (TemplatePrompt)** สำหรับใช้งานร่วมกับ AI หรือ Copilot ในทุกสถานการณ์ของการพัฒนาซอฟต์แวร์

---

# 📚 Prompt Template Complete Suite (สำหรับ AngularJS 1.x + TypeScript + Clean Architecture + DDD)

---

## 🟢 Template 1: Prompt สำหรับสร้าง Feature/Module ใหม่แบบเต็มขั้น (New Feature Workflow)

```markdown
# Role Definition
คุณคือ Senior Frontend Developer และ Solutions Architect ผู้เชี่ยวชาญด้าน TypeScript, Clean Architecture, Domain-Driven Design (DDD) และ AngularJS (1.x) 

# Task Goal
ช่วยออกแบบและเขียนโค้ด Feature/Module ใหม่ตามรายละเอียดดังนี้:
[ระบุชื่อ Feature เช่น: Employee Management / Accounts Management]

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

```text
src/app/features/[feature-name]/
├── domain/
│   ├── entities/
│   ├── value-objects/
│   ├── repositories/
│   └── use-cases/
├── data/
│   ├── datasources/
│   ├── dtos/
│   ├── mappers/
│   └── repositories/
└── presentation/
    ├── controllers/
    ├── views/
    └── [feature].module.ts

```

### Step 3: Execution & Implementation (`/tb-executing-plans`)

เขียนโค้ดฉบับสมบูรณ์ที่พร้อมใช้งาน (Production-ready) ครบทุกไฟล์ตาม Clean Architecture:

1. **Domain Layer:** Entities, Value Objects, Repository Interfaces, Use Cases (Pure TS, ไม่ติด Framework)
2. **Data Layer:** DTOs, Mappers, API DataSources ($http), Repository Implementations
3. **Presentation Layer:** Controllers (ใช้ static $inject), Components/Views
4. **Module Registration:** ลงทะเบียน DI ใน AngularJS Module ด้วย `.factory()` และ `.controller()`

### Step 4: Verification & Proof of Work

* สรุปผลการดำเนินงาน
* แสดงขั้นตอนการทดสอบ (Unit Test / Integration Test scenario)

```

---

## 🔴 Template 2: Prompt สำหรับสืบสวนและแก้ไข Bug (Bug Fix Workflow - Path A & B)

```markdown
# Role Definition
คุณคือ Senior AngularJS (1.x) & TypeScript Engineer มืออาชีพ ปฏิบัติหน้าที่ในการแก้ Bug และทำ Root Cause Analysis ตามเกณฑ์ Clean Architecture และ DDD

# Problem Description
- Bug / Error Details: [ใส่ Log error หรือพฤติกรรมที่ไม่ถูกต้อง เช่น: Email ซ้ำแต่ระบบยังยอมให้สร้าง / Change detection ไม่ทำงานหลัง async call]
- Affected Module: [ระบุ Module ที่เกิดปัญหา]

---

# Execution Steps (ปฏิบัติตามลำดับขั้นตอนดังนี้)

### Step 1: Investigation (`/tb-investigate-error`)
1. วิเคราะห์ Root Cause ของปัญหาและจัดลำดับสาเหตุที่เป็นไปได้
2. ออกรายงานสรุปผลการวิเคราะห์ก่อนเริ่มวางแผนแก้ไข

### Step 2: Choose Path & Plan
- **หากแก้หลายจุด (Path A):** เรียกใช้ `/tb-writing-plans` เพื่อวางแผนและลงมือแก้ทีละจุดด้วย `/tb-executing-plans`
- **หากแก้จุดเดียว (Path B):** เรียกใช้ Test-Driven Development (`/tb-test-driven-development`) โดยการเขียน Test Case ที่พบล้มเหลวก่อน แล้วเขียนโค้ดแก้จน Test ผ่าน

### Step 3: Scrutinize & Impact Check (`/tb-scrutinize`)
1. ตรวจสอบ Side Effects ที่อาจกระทบกับ Module หรือ Service อื่น
2. ตรวจสอบ Memory Leaks, Scope Lifecycles, และการจัดการ Async บน AngularJS ($scope.$applyAsync())

### Step 4: Summary & Proof of Work
- รายงานสรุปการแก้ไขจุดเกิดปัญหา (Before vs After)
- แสดงวิธีการยืนยันความถูกต้องและการทดสอบ

```

---

## 🟡 Template 3: Prompt สำหรับการทำ Code Review (`Code_Review`)

```markdown
# Role Definition
คุณคือ Senior Angular Software Engineer และ Solutions Architect ผู้เชี่ยวชาญด้าน Clean Architecture, SOLID Principles, TypeScript และ AngularJS (1.x)

# Task Goal
รีวิวโค้ดชุดต่อไปนี้ ตามเกณฑ์มาตรฐาน Clean Architecture + DDD บน AngularJS 1.x

# Code to Review:
[วางโค้ดที่ต้องการรีวิวที่นี่]

---

# Review Criteria
วิเคราะห์โค้ดตาม 5 มิติ:
1. **Clean Architecture & SOLID:** การแบ่ง Layer (Domain, Data, Presentation) มีการรั่วไหลของ Business Logic หรือไม่ การใช้ Dependency Injection และ Interface Segregation
2. **AngularJS / TS Best Practices:** การจัดการ Async (`async/await`, `$q`), การป้องกัน Memory Leak, การผูก `this` context, การใช้ `static $inject` เพื่อป้องกัน Minification error
3. **Bug & Error Identification:** Edge cases, Null/Undefined checks, Unhandled Promise/Observable errors
4. **Impact Analysis:** ผลกระทบต่อ Module อื่น หรือ Side Effects
5. **Performance & Security:** Unnecessary re-renders, Scope leaks, Input sanitization (XSS)

# Output Format
## 1. 📊 สรุปภาพรวม (Overview) - คะแนนคุณภาพโค้ด (1-10)
## 2. 🚨 รายการ Critical Bugs / Errors (ถ้ามี)
## 3. ⚠️ Impact Analysis (วิเคราะห์ผลกระทบต่อส่วนอื่น)
## 4. 💡 Clean Architecture & Code Refactor Recommendations (แสดง Before vs After)

```

---

## 🔵 Template 4: Prompt สำหรับ Refactor Legacy AngularJS โค้ดเดิมเข้าสู่ Clean Architecture + DDD

```markdown
# Role Definition
คุณคือ Lead Software Architect ที่เชี่ยวชาญการปรับปรุงโครงสร้างโค้ด (Refactoring) จาก Legacy AngularJS (JavaScript) ไปสู่ TypeScript + Clean Architecture + DDD

# Legacy Code to Refactor:
[วาง Legacy Code / Controller / Service ที่นี่]

# Refactoring Rules:
1. **ไม่เปลี่ยนพฤติกรรมเดิมของระบบ (Behavior Preservation)**
2. **ห้ามแก้ไข Shared Utilities** หรือหมวดหมู่ร่วมกัน ยกเว้นการสร้าง Wrapper เพิ่มเติม
3. **แยก Layer ให้ชัดเจน:**
   - **Domain Layer:** Entities, Value Objects, Pure Business Logic (ไม่ขึ้นกับ AngularJS)
   - **Data Layer:** API Calls, DTOs, Mappers
   - **Presentation Layer:** Controller บางลง (Thin Controller) และใช้ Use Cases แทน

# Execution Steps:
1. วิเคราะห์ Spaghetti Code เดิม แล้วทำ Diagram (ASCII Flow) แสดงการแยก Responsibility
2. ออกแบบ Domain Entity & Use Case ในรูปแบบ TypeScript
3. แสดงโค้ด Refactored ฉบับสมบูรณ์
4. แสดงการลงทะเบียน DI ใน AngularJS Module

```

---

# 🚀 ตัวอย่างการใช้งานจริง (Walkthrough Example)

เมื่อนำ **Template 1** มาสั่งการตัวอย่างเพิ่มข้อมูลพนักงาน (POST `/employee`) บนระบบ AngularJS 1.x + TS + Clean Architecture + DDD ผลลัพธ์จากการประมวลผลจะเป็นดังนี้:

---

### Step 1: Brainstorming & Analysis (`/tb-brainstorming`)

#### 1. Concept & Requirements Analysis

* **Goal:** สร้าง API Connection และ Form Handling สำหรับเพิ่มข้อมูลพนักงาน (POST `http://localhost:8080/employee`)
* **Business Rules:**
* `id`: Autogenerate UUIDv4 จาก Domain Layer
* `full_name`: Required Input
* `email`: Required Input + Format Validation + Unique Check
* `created_at` / `updated_at`: ISO Date string ณ เวลาบันทึกข้อมูล



#### 2. Affected Areas & Impact Analysis

* **กระทบส่วนใดบ้าง:** สตรีมการส่งข้อมูลเฉพาะโมดูล `Employee` ใหม่ ไม่กระทบกับโมดูลเดิมในระบบ
* **ข้อกำหนด/ข้อห้าม:**
* ❌ ห้ามแก้ไข Core Module หรือ Shared Interceptors ของระบบ
* ❌ ห้ามเขียน HTTP Call ตรงใน Controller
* ❌ ห้ามเอา Business Validation ไปไว้ใน Controller



#### 3. ข้อดี / ข้อเสีย / ข้อควรระวัง

* **ข้อดี:** Business Logic บริสุทธิ์ สามารถนำ Domain / Use Cases ย้ายไป Angular (v18+) หรือ React ได้โดยไม่ต้องเขียน Logic ใหม่
* **ข้อเสีย:** มีไฟล์เพิ่มขึ้นเนื่องจากการแยก Layer (Domain, Data, Presentation)
* **ข้อควรระวัง:** AngularJS DI ต้องการ `public static $inject` เสมอ เพื่อป้องกันปัญหาเมื่อทำ Code Minification

#### 4. Flowchart (Data & Control Flow)

```
[ UI / View ] ──(User Input)──> [ EmployeeController ]
                                        │
                                        ▼ (Invoke)
                             [ CreateEmployeeUseCase ]
                                        │
                                        ├─► [ Employee Entity ] ──(Validate Rules)
                                        │
                                        ▼ (Persist)
                             [ IEmployeeRepository ] (Interface)
                                        │
                                        ▼ (Implements)
                           [ EmployeeApiRepositoryImpl ]
                                        │
                                        ▼ (HTTP POST)
                              [ $http / Backend API ]

```

---

### Step 2: Planning (`/tb-writing-plans`)

#### โครงสร้างไฟล์ในโมดูล `employee`

```text
src/app/features/employee/
├── domain/
│   ├── entities/
│   │   └── employee.entity.ts
│   ├── value-objects/
│   │   └── email.vo.ts
│   ├── repositories/
│   │   └── employee.repository.ts
│   └── use-cases/
│       └── create-employee.use-case.ts
├── data/
│   ├── datasources/
│   │   └── employee-api.datasource.ts
│   ├── dtos/
│   │   ├── create-employee-request.dto.ts
│   │   └── employee-response.dto.ts
│   ├── mappers/
│   │   └── employee.mapper.ts
│   └── repositories/
│       └── employee.repository.impl.ts
└── presentation/
    ├── controllers/
    │   └── employee-create.controller.ts
    └── employee.module.ts

```

---

### Step 3: Execution & Implementation (`/tb-executing-plans`)

#### 1. Domain Layer (Pure TypeScript)

`email.vo.ts`

```typescript
export class Email {
  private readonly value: string;

  constructor(email: string) {
    if (!email || !this.validate(email)) {
      throw new Error('รูปแบบอีเมลไม่ถูกต้อง');
    }
    this.value = email;
  }

  private validate(email: string): boolean {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }

  public getValue(): string {
    return this.value;
  }
}

```

`employee.entity.ts`

```typescript
import { Email } from '../value-objects/email.vo';

export class Employee {
  constructor(
    public readonly id: string,
    public fullName: string,
    public email: Email,
    public readonly createdAt: Date,
    public updatedAt: Date
  ) {
    if (!fullName || fullName.trim() === '') {
      throw new Error('กรุณาระบุชื่อ-นามสกุล');
    }
  }

  public static create(id: string, fullName: string, emailStr: string): Employee {
    const now = new Date();
    return new Employee(
      id,
      fullName,
      new Email(emailStr),
      now,
      now
    );
  }
}

```

`employee.repository.ts`

```typescript
import { Employee } from '../entities/employee.entity';

export interface IEmployeeRepository {
  create(employee: Employee): Promise<Employee>;
  existsByEmail(email: string): Promise<boolean>;
}

```

`create-employee.use-case.ts`

```typescript
import { Employee } from '../entities/employee.entity';
import { IEmployeeRepository } from '../repositories/employee.repository';

export class CreateEmployeeUseCase {
  constructor(private employeeRepo: IEmployeeRepository) {}

  public async execute(fullName: string, emailStr: string): Promise<Employee> {
    // Check Unique Email Rule
    const exists = await this.employeeRepo.existsByEmail(emailStr);
    if (exists) {
      throw new Error('อีเมลนี้ถูกใช้งานในระบบแล้ว');
    }

    // Auto-generate UUID
    const uuid = crypto.randomUUID ? crypto.randomUUID() : this.generateUUID();
    
    // Create Entity (Domain Rule Validation)
    const newEmployee = Employee.create(uuid, fullName, emailStr);

    // Save via Repository Interface
    return await this.employeeRepo.create(newEmployee);
  }

  private generateUUID(): string {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
      const r = (Math.random() * 16) | 0;
      const v = c === 'x' ? r : (r & 0x3) | 0x8;
      return v.toString(16);
    });
  }
}

```

#### 2. Data Layer

`employee-api.datasource.ts`

```typescript
export class EmployeeApiDataSource {
  public static $inject = ['$http'];

  constructor(private $http: ng.IHttpService) {}

  public async postEmployee(payload: any): Promise<any> {
    const res = await this.$http.post('http://localhost:8080/employee', payload);
    return res.data;
  }

  public async getEmployees(): Promise<any[]> {
    const res = await this.$http.get('http://localhost:8080/employees');
    return res.data as any[];
  }
}

```

`employee.repository.impl.ts`

```typescript
import { IEmployeeRepository } from '../../domain/repositories/employee.repository';
import { Employee } from '../../domain/entities/employee.entity';
import { EmployeeApiDataSource } from '../datasources/employee-api.datasource';

export class EmployeeRepositoryImpl implements IEmployeeRepository {
  public static $inject = ['EmployeeApiDataSource'];

  constructor(private dataSource: EmployeeApiDataSource) {}

  public async create(employee: Employee): Promise<Employee> {
    const dto = {
      id: employee.id,
      full_name: employee.fullName,
      email: employee.email.getValue(),
      created_at: employee.createdAt.toISOString(),
      updated_at: employee.updatedAt.toISOString(),
    };

    const res = await this.dataSource.postEmployee(dto);
    return Employee.create(res.id, res.full_name, res.email);
  }

  public async existsByEmail(email: string): Promise<boolean> {
    const list = await this.dataSource.getEmployees();
    return list.some((item) => item.email.toLowerCase() === email.toLowerCase());
  }
}

```

#### 3. Presentation Layer & DI Module

`employee-create.controller.ts`

```typescript
import { CreateEmployeeUseCase } from '../../domain/use-cases/create-employee.use-case';

export class EmployeeCreateController {
  public static $inject = ['$scope', 'CreateEmployeeUseCase'];

  public fullName: string = '';
  public email: string = '';
  public isLoading: boolean = false;
  public errorMessage: string = '';

  constructor(
    private $scope: ng.IScope,
    private createEmployeeUseCase: CreateEmployeeUseCase
  ) {}

  public async submit(): Promise<void> {
    this.errorMessage = '';
    this.isLoading = true;

    try {
      const result = await this.createEmployeeUseCase.execute(this.fullName, this.email);
      alert(`เพิ่มพนักงานเรียบร้อยแล้ว: ${result.fullName}`);
      this.resetForm();
    } catch (err: any) {
      this.errorMessage = err.message || 'เกิดข้อผิดพลาดในการบันทึกข้อมูล';
    } finally {
      this.isLoading = false;
      this.$scope.$applyAsync();
    }
  }

  private resetForm(): void {
    this.fullName = '';
    this.email = '';
  }
}

```

`employee.module.ts`

```typescript
import * as angular from 'angular';
import { EmployeeApiDataSource } from './data/datasources/employee-api.datasource';
import { EmployeeRepositoryImpl } from './data/repositories/employee.repository.impl';
import { CreateEmployeeUseCase } from './domain/use-cases/create-employee.use-case';
import { EmployeeCreateController } from './presentation/controllers/employee-create.controller';

export const EmployeeModule = angular
  .module('app.employee', [])
  .service('EmployeeApiDataSource', EmployeeApiDataSource)
  .service('IEmployeeRepository', EmployeeRepositoryImpl)
  .factory('CreateEmployeeUseCase', [
    'IEmployeeRepository',
    (repo: any) => new CreateEmployeeUseCase(repo),
  ])
  .controller('EmployeeCreateController', EmployeeCreateController).name;

```

---

### Step 4: Verification & Proof of Work

1. **Unit Test Scenarios (Domain Rules):**
* ทดสอบสร้าง `Employee` โดยไม่ระบุ `fullName` -> ต้อง throw Exception
* ทดสอบสร้าง `Email` รูปแบบไม่ถูกต้อง -> ต้อง throw Exception
* ทดสอบส่ง `email` ซ้ำ -> `CreateEmployeeUseCase` ต้องปฏิเสธงานก่อนเรียก `create`


2. **Integration Test Flow:**
* ส่ง Request `POST http://localhost:8080/employee` พร้อม Data DTO ที่แปลงค่าสำเร็จ
* ยืนยันการอัปเดต UI ด้วย `$scope.$applyAsync()` โดยไม่เกิด Scope Conflict ($digest already in progress)