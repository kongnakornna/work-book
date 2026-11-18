
# 1. บทนำและภาพรวมระบบ

## 1.1 วัตถุประสงค์
ระบบนี้ถูกออกแบบมาเพื่อรองรับการดำเนินงานของธุรกิจขนาดกลางถึงขนาดใหญ่ ครอบคลุมตั้งแต่การจัดการลูกค้า การเสนอราคา การสั่งซื้อ การจัดการสต็อก ไปจนถึงการติดตามงานและการชำระเงิน โดยนำหลักการ **Clean Architecture** มาใช้เพื่อให้ระบบมีความยืดหยุ่น บำรุงรักษาง่าย และสามารถขยายขีดความสามารถได้ในอนาคต

## 1.2 กลุ่มผู้ใช้งาน
| บทบาท | สิทธิ์ | โมดูลที่เกี่ยวข้อง |
|--------|--------|-------------------|
| **Admin** | สิทธิ์สูงสุด | ทุกโมดูล + จัดการผู้ใช้ + ดูรายงานทั้งหมด |
| **Manager** | สิทธิ์ระดับบริหาร | Job Card, Quotation, Purchase Order, Dashboard, Reports |
| **Staff** | สิทธิ์ปฏิบัติการ | Job Card, Customer Management, Inventory (ดู/แก้ไขบางส่วน) |
| **Technician** | สิทธิ์หน้างาน | Job Card (อัปเดตสถานะ), GPS Tracking, IoT |
| **Customer** | สิทธิ์จำกัด | Web Order System (WOS), ดูสถานะ订单 |

## 1.3 เทคโนโลยีหลัก
| องค์ประกอบ | เทคโนโลยี |
|------------|-----------|
| **Frontend** | Angular 18+ (Standalone Components), Tabler UI Theme, angular-tabler-icons |
| **State Management** | Signals + @ngrx/component-store |
| **Backend API** | Node.js (NestJS) / .NET Core 8 |
| **ฐานข้อมูล** | PostgreSQL (หลัก) + MongoDB (สำหรับ Document Management) |
| **Cache** | Redis |
| **Real-time** | Socket.IO (สำหรับ GPS Tracking) |
| **Queue** | BullMQ (Batch Jobs) |
| **Authentication** | JWT + Refresh Token |

---

# 2. สถาปัตยกรรมระบบ

## 2.1 แผนภาพสถาปัตยกรรมระดับสูง (High-Level Architecture)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           PRESENTATION LAYER                                │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐      │
│  │   Pages      │ │   Layouts    │ │   Shared     │ │   Components │      │
│  │ (Routing)    │ │ (Sidebar,    │ │ (Buttons,    │ │ (Reusable)   │      │
│  │              │ │  Header,     │ │  Cards,      │ │              │      │
│  │              │ │  Footer)     │ │  Modals)     │ │              │      │
│  └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘      │
│                              ▼                                             │
│                    [Angular Router + Guards]                                │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                             DOMAIN LAYER                                   │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐      │
│  │   Entities   │ │  Use Cases   │ │ Repositories │ │   Services   │      │
│  │ (Business    │ │ (Business    │ │ (Interfaces) │ │ (Domain      │      │
│  │  Objects)    │ │  Logic)      │ │              │ │  Services)   │      │
│  └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘      │
│                                                                             │
│  หลักการ: ไม่มีการพึ่งพาภายนอก — บริสุทธิ์ (Pure Business Logic)             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              DATA LAYER                                    │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐      │
│  │ Repositories │ │  DataSources │ │    DTOs      │ │   Mappers    │      │
│  │ (Implements  │ │ (API, Local, │ │ (Data        │ │ (Entity ↔    │      │
│  │  Interfaces) │ │  Cache)      │ │  Transfer)   │ │  DTO)        │      │
│  └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘      │
│                                                                             │
│  หลักการ: จัดการข้อมูลจากภายนอก — เปลี่ยนรูปแบบให้ Domain เข้าใจได้         │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            CORE LAYER                                      │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐      │
│  │   Config     │ │   Utils      │ │  Constants   │ │  Interceptors│      │
│  │ (App Settings│ │ (Helpers,    │ │ (Enums,      │ │ (HTTP,       │      │
│  │  Environment)│ │  Validators) │ │  Status)     │ │  Auth)       │      │
│  └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘      │
│                                                                             │
│  หลักการ: กลไกสนับสนุนการทำงานของทุกเลเยอร์                                │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 2.2 แผนภาพโครงสร้างโปรเจกต์ Angular (Folder Structure)

```
src/
├── app/
│   ├── core/                              # ⚙️ Core Layer
│   │   ├── config/
│   │   │   ├── app.config.ts              # ค่ากำหนดหลัก
│   │   │   └── api.config.ts              # API Endpoints
│   │   ├── constants/
│   │   │   ├── app.constants.ts
│   │   │   └── enums.ts                   # Enum ทั่วทั้งระบบ
│   │   ├── utils/
│   │   │   ├── validators.ts
│   │   │   ├── formatters.ts
│   │   │   └── helpers.ts
│   │   └── interceptors/
│   │       ├── auth.interceptor.ts
│   │       └── error.interceptor.ts
│   │
│   ├── shared/                            # 🔄 Shared Components
│   │   ├── components/
│   │   │   ├── buttons/
│   │   │   ├── cards/
│   │   │   ├── modals/
│   │   │   ├── tables/
│   │   │   └── forms/
│   │   ├── directives/
│   │   ├── pipes/
│   │   └── guards/
│   │
│   ├── features/                          # 📦 Feature Modules (Lazy Loading)
│   │   │
│   │   ├── auth/                          # 🔐 โมดูลที่ 1: Authentication
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── user.entity.ts
│   │   │   │   │   └── permission.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── login.use-case.ts
│   │   │   │   │   ├── logout.use-case.ts
│   │   │   │   │   ├── refresh-token.use-case.ts
│   │   │   │   │   └── check-permission.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── auth.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── auth.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       ├── login-request.dto.ts
│   │   │   │       └── login-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── login/
│   │   │       │   └── forgot-password/
│   │   │       └── components/
│   │   │           └── permission-guard/
│   │   │
│   │   ├── job-card/                      # 📋 โมดูลที่ 2: Job Card Management
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── job-card.entity.ts
│   │   │   │   │   ├── job-status.enum.ts
│   │   │   │   │   └── job-priority.enum.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-job.use-case.ts
│   │   │   │   │   ├── update-job.use-case.ts
│   │   │   │   │   ├── get-job.use-case.ts
│   │   │   │   │   ├── list-jobs.use-case.ts
│   │   │   │   │   ├── assign-job.use-case.ts
│   │   │   │   │   └── update-job-status.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── job-card.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── job-card.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── job-card.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       ├── create-job-request.dto.ts
│   │   │   │       └── job-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── job-list/
│   │   │       │   ├── job-detail/
│   │   │       │   ├── job-create/
│   │   │       │   └── job-board/         # Kanban View
│   │   │       └── components/
│   │   │           ├── job-card/
│   │   │           ├── job-filters/
│   │   │           └── job-timeline/
│   │   │
│   │   ├── customer/                      # 👤 โมดูลที่ 3: Customer Management
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── customer.entity.ts
│   │   │   │   │   └── customer-contact.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-customer.use-case.ts
│   │   │   │   │   ├── update-customer.use-case.ts
│   │   │   │   │   ├── get-customer.use-case.ts
│   │   │   │   │   ├── list-customers.use-case.ts
│   │   │   │   │   └── search-customers.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── customer.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── customer.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── customer.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── customer-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── customer-list/
│   │   │       │   ├── customer-detail/
│   │   │       │   └── customer-create/
│   │   │       └── components/
│   │   │           └── customer-search/
│   │   │
│   │   ├── quotation/                     # 📄 โมดูลที่ 4: Quotation
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── quotation.entity.ts
│   │   │   │   │   ├── quotation-item.entity.ts
│   │   │   │   │   └── quotation-status.enum.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-quotation.use-case.ts
│   │   │   │   │   ├── update-quotation.use-case.ts
│   │   │   │   │   ├── get-quotation.use-case.ts
│   │   │   │   │   ├── list-quotations.use-case.ts
│   │   │   │   │   ├── approve-quotation.use-case.ts
│   │   │   │   │   └── reject-quotation.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── quotation.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── quotation.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── quotation.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       ├── create-quotation-request.dto.ts
│   │   │   │       └── quotation-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── quotation-list/
│   │   │       │   ├── quotation-detail/
│   │   │       │   └── quotation-create/
│   │   │       └── components/
│   │   │           ├── quotation-pdf/
│   │   │           └── quotation-items/
│   │   │
│   │   ├── purchase-order/                # 🛒 โมดูลที่ 5: Purchase Order
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── purchase-order.entity.ts
│   │   │   │   │   ├── po-item.entity.ts
│   │   │   │   │   └── po-status.enum.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-po.use-case.ts
│   │   │   │   │   ├── update-po.use-case.ts
│   │   │   │   │   ├── get-po.use-case.ts
│   │   │   │   │   ├── list-pos.use-case.ts
│   │   │   │   │   └── approve-po.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── purchase-order.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── purchase-order.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── po.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── po-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── po-list/
│   │   │       │   ├── po-detail/
│   │   │       │   └── po-create/
│   │   │       └── components/
│   │   │           └── po-approval/
│   │   │
│   │   ├── inventory/                     # 📦 โมดูลที่ 6: Inventory Management
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── product.entity.ts
│   │   │   │   │   ├── category.entity.ts
│   │   │   │   │   └── stock-movement.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-product.use-case.ts
│   │   │   │   │   ├── update-product.use-case.ts
│   │   │   │   │   ├── get-product.use-case.ts
│   │   │   │   │   ├── list-products.use-case.ts
│   │   │   │   │   ├── adjust-stock.use-case.ts
│   │   │   │   │   └── get-stock-movements.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── inventory.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── inventory.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── inventory.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── product-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── product-list/
│   │   │       │   ├── product-detail/
│   │   │       │   ├── product-create/
│   │   │       │   └── stock-adjustment/
│   │   │       └── components/
│   │   │           ├── stock-alert/
│   │   │           └── barcode-scanner/
│   │   │
│   │   ├── payment/                       # 💳 โมดูลที่ 7: Payment Management
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── payment.entity.ts
│   │   │   │   │   ├── invoice.entity.ts
│   │   │   │   │   └── payment-status.enum.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-payment.use-case.ts
│   │   │   │   │   ├── get-payment.use-case.ts
│   │   │   │   │   ├── list-payments.use-case.ts
│   │   │   │   │   ├── verify-payment.use-case.ts
│   │   │   │   │   └── generate-invoice.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── payment.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── payment.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── payment.api.datasource.ts
│   │   │   │   │   └── payment-gateway.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── payment-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── payment-list/
│   │   │       │   ├── payment-detail/
│   │   │       │   ├── payment-create/
│   │   │       │   └── invoice-view/
│   │   │       └── components/
│   │   │           └── payment-gateway/
│   │   │
│   │   ├── dashboard/                     # 📊 โมดูลที่ 8: Dashboard & Reports
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── dashboard-stats.entity.ts
│   │   │   │   │   └── report.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── get-dashboard-stats.use-case.ts
│   │   │   │   │   ├── get-revenue-chart.use-case.ts
│   │   │   │   │   ├── generate-report.use-case.ts
│   │   │   │   │   └── export-report.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── dashboard.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── dashboard.repository.impl.ts
│   │   │   │   └── datasources/
│   │   │   │       └── dashboard.api.datasource.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── main-dashboard/
│   │   │       │   ├── reports/
│   │   │       │   └── analytics/
│   │   │       └── components/
│   │   │           ├── stats-cards/
│   │   │           ├── revenue-chart/
│   │   │           ├── recent-activities/
│   │   │           └── quick-actions/
│   │   │
│   │   ├── document/                      # 📁 โมดูลที่ 9: Document Management
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── document.entity.ts
│   │   │   │   │   └── document-folder.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── upload-document.use-case.ts
│   │   │   │   │   ├── get-document.use-case.ts
│   │   │   │   │   ├── list-documents.use-case.ts
│   │   │   │   │   ├── delete-document.use-case.ts
│   │   │   │   │   └── share-document.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── document.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── document.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── document.api.datasource.ts
│   │   │   │   │   └── document-storage.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── document-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── document-list/
│   │   │       │   ├── document-detail/
│   │   │       │   └── document-upload/
│   │   │       └── components/
│   │   │           └── document-preview/
│   │   │
│   │   ├── email/                         # ✉️ โมดูลที่ 10: Email Service
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── email-template.entity.ts
│   │   │   │   │   └── email-log.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── send-email.use-case.ts
│   │   │   │   │   ├── send-bulk-email.use-case.ts
│   │   │   │   │   ├── get-email-logs.use-case.ts
│   │   │   │   │   └── create-email-template.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── email.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── email.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── email.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── send-email-request.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── email-templates/
│   │   │       │   ├── email-logs/
│   │   │       │   └── email-compose/
│   │   │       └── components/
│   │   │           └── email-editor/
│   │   │
│   │   ├── batch/                         # ⏰ โมดูลที่ 11: Batch Jobs
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── batch-job.entity.ts
│   │   │   │   │   └── job-schedule.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-batch-job.use-case.ts
│   │   │   │   │   ├── get-batch-job.use-case.ts
│   │   │   │   │   ├── list-batch-jobs.use-case.ts
│   │   │   │   │   └── trigger-batch-job.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── batch-job.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── batch-job.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── batch.api.datasource.ts
│   │   │   │   │   └── queue.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── batch-job-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── batch-list/
│   │   │       │   └── batch-create/
│   │   │       └── components/
│   │   │           └── job-scheduler/
│   │   │
│   │   ├── i18n/                          # 🌍 โมดูลที่ 12: Multi-Language
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── translation.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── get-translation.use-case.ts
│   │   │   │   │   ├── set-language.use-case.ts
│   │   │   │   │   └── get-available-languages.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── translation.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── translation.repository.impl.ts
│   │   │   │   └── datasources/
│   │   │   │       ├── translation.api.datasource.ts
│   │   │   │       └── translation-local.datasource.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   └── language-selector/
│   │   │       └── pipes/
│   │   │           └── translate.pipe.ts
│   │   │
│   │   ├── iot/                           # 📡 โมดูลที่ 13: IoT & GPS Tracking
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── device.entity.ts
│   │   │   │   │   ├── gps-data.entity.ts
│   │   │   │   │   └── sensor-data.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── register-device.use-case.ts
│   │   │   │   │   ├── get-device-location.use-case.ts
│   │   │   │   │   ├── get-device-history.use-case.ts
│   │   │   │   │   └── get-sensor-data.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── iot.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── iot.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── iot.api.datasource.ts
│   │   │   │   │   └── socket.datasource.ts   # Real-time
│   │   │   │   └── dtos/
│   │   │   │       └── device-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── device-list/
│   │   │       │   ├── device-map/           # Google Maps Integration
│   │   │       │   └── device-detail/
│   │   │       └── components/
│   │   │           ├── gps-tracker/
│   │   │           └── device-status/
│   │   │
│   │   └── wos/                           # 🛍️ โมดูลที่ 14: Web Order System
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   ├── web-order.entity.ts
│   │       │   │   ├── order-item.entity.ts
│   │       │   │   └── order-status.enum.ts
│   │       │   ├── use-cases/
│   │       │   │   ├── create-web-order.use-case.ts
│   │       │   │   ├── get-web-order.use-case.ts
│   │       │   │   ├── list-web-orders.use-case.ts
│   │       │   │   ├── update-order-status.use-case.ts
│   │       │   │   └── cancel-order.use-case.ts
│   │       │   └── repositories/
│   │       │       └── web-order.repository.ts
│   │       ├── data/
│   │       │   ├── repositories/
│   │       │   │   └── web-order.repository.impl.ts
│   │       │   ├── datasources/
│   │       │   │   └── wos.api.datasource.ts
│   │       │   └── dtos/
│   │       │       └── web-order-response.dto.ts
│   │       └── presentation/
│   │           ├── pages/
│   │           │   ├── order-list/
│   │           │   ├── order-detail/
│   │           │   └── order-create/
│   │           └── components/
│   │               ├── order-summary/
│   │               └── order-tracking/
│   │
│   └── app.routes.ts                      # 🗺️ Main Routing (Lazy Loading)
│
├── assets/
│   ├── images/
│   ├── i18n/                              # ไฟล์แปลภาษา
│   │   ├── en.json
│   │   └── th.json
│   └── tabler/                            # Tabler Static Assets
│
├── environments/
│   ├── environment.ts
│   └── environment.prod.ts
│
└── styles.scss                            # Global Styles (Import Tabler)
```

---

## 2.3 แผนภาพ Dependency Flow (Clean Architecture)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                                  │
│              (Pages, Components, Layouts, Guards)                          │
│                                                                             │
│  หน้าที่: แสดงผล UI, จัดการ Event จากผู้ใช้, เรียก Use Cases              │
│  ✅ สามารถพึ่งพา: Domain, Core                                             │
│  ❌ ห้ามพึ่งพา: Data โดยตรง                                                 │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ เรียกใช้
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DOMAIN LAYER                                     │
│              (Entities, Use Cases, Repository Interfaces)                   │
│                                                                             │
│  หน้าที่: กำหนด Business Logic, กฎเกณฑ์ทางธุรกิจ                          │
│  ✅ สามารถพึ่งพา: Core (Utils, Constants)                                  │
│  ❌ ห้ามพึ่งพา: Presentation, Data                                          │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ▲
                                    │ implements
                                    │
┌─────────────────────────────────────────────────────────────────────────────┐
│                            DATA LAYER                                      │
│              (Repository Impl, DataSources, DTOs, Mappers)                  │
│                                                                             │
│  หน้าที่: จัดการข้อมูลจาก API, Database, Cache                             │
│  ✅ สามารถพึ่งพา: Domain, Core                                             │
│  ❌ ห้ามพึ่งพา: Presentation                                                │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ เรียก API / DB
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         EXTERNAL SYSTEMS                                   │
│              (REST API, Database, Redis, File Storage)                     │
└─────────────────────────────────────────────────────────────────────────────┘
```
การใช้ **TypeScript** ร่วมกับ **Clean Architecture** และ **Domain-Driven Design (DDD)** บน **AngularJS (1.x)** เป็นสิ่งที่ทำได้จริง แม้ AngularJS จะถูกออกแบบมาก่อนยุค TypeScript แต่ด้วย Dependency Injection (DI) ที่แข็งแกร่งของมัน ทำให้เราสามารถแยกชั้น (Layers) ตามหลัก Clean Architecture ได้อย่างสวยงาม

แนวทางนี้จะช่วยให้โค้ดของคุณ **ไม่ผูกติดกับเฟรมเวิร์ก (Framework-agnostic)** สามารถย้ายไป Angular สมัยใหม่หรือ React ได้ง่ายในอนาคต

ด้านล่างคือ **คู่มือการประยุกต์ใช้** แบบ Step-by-step พร้อมโครงสร้างโฟลเดอร์และโค้ดตัวอย่าง โดยใช้บริบท **Chatbot (OpenCode 3 Accounts)** เดิมของเรา

---

### 1. โครงสร้างโปรเจกต์ (Project Structure)

```text
src/
├── domain/                           # ชั้นหลัก (ไม่ขึ้นกับอะไรเลย)
│   ├── entities/                     # Entity หลัก
│   │   └── Message.ts
│   ├── aggregates/                   # Aggregate Root
│   │   └── ChatSession.ts
│   ├── value-objects/                # Value Objects
│   │   └── AccountId.ts
│   └── repositories/                 # Interface สำหรับชั้นนอก
│       └── IChatRepository.ts
│
├── application/                      # Use Cases ( orchestrator )
│   └── usecases/
│       └── SendMessageUseCase.ts
│
├── infrastructure/                   # ชั้นนอก (Implementation)
│   ├── services/
│   │   └── OpenCodeApiRepository.ts  # implements IChatRepository
│   └── config/
│       └── AccountConfig.ts
│
└── presentation/                     # ชั้น UI (AngularJS)
    ├── controllers/
    │   └── ChatController.ts
    └── module/
        └── app.module.ts             # ลงทะเบียน DI ของ AngularJS
```

---

### 2. การตั้งค่า TypeScript (`tsconfig.json`)

ต้องคอมไพล์ TypeScript เป็น JavaScript (ES5) เพื่อให้ AngularJS ทำงานได้

```json
{
  "compilerOptions": {
    "target": "ES5",
    "module": "CommonJS",
    "strict": true,
    "esModuleInterop": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "lib": ["ES6", "DOM"]
  },
  "include": ["src/**/*"]
}
```

---

### 3. ชั้น Domain (ใจกลางระบบ)

ที่นี่จะไม่มี `$http`, `$scope` หรืออะไรที่เกี่ยวกับ AngularJS เลย มีแต่ Business Logic ล้วนๆ

**`domain/entities/Message.ts`** (Entity พื้นฐาน)
```typescript
export class Message {
  constructor(
    public readonly role: 'user' | 'assistant' | 'system',
    public readonly content: string,
    public readonly timestamp: Date = new Date()
  ) {}

  // Business Rule: ข้อความต้องไม่ว่าง
  public isValid(): boolean {
    return this.content.trim().length > 0;
  }
}
```

**`domain/aggregates/ChatSession.ts`** (Aggregate Root - ดูแลความถูกต้องของแชท)
```typescript
import { Message } from '../entities/Message';

export class ChatSession {
  private _messages: Message[] = [];

  constructor(public readonly sessionId: string) {}

  public addMessage(message: Message): void {
    if (!message.isValid()) {
      throw new Error('ไม่สามารถเพิ่มข้อความว่างได้');
    }
    this._messages.push(message);
  }

  public getMessages(): Message[] {
    return [...this._messages]; // ป้องกันการแก้ไขจากภายนอก
  }

  public getLastUserMessage(): Message | undefined {
    return [...this._messages].reverse().find(m => m.role === 'user');
  }
}
```

**`domain/repositories/IChatRepository.ts`** (Interface สำหรับ Infrastructure)
```typescript
import { Message } from '../entities/Message';

export interface IChatRepository {
  // ส่งข้อความประวัติทั้งหมดไปให้ AI แล้วรับคำตอบกลับ
  sendMessage(accountId: string, messages: Message[]): Promise<Message>;
}
```

---

### 4. ชั้น Application (Use Cases)

ชั้นนี้จะสั่งงาน Domain และเรียก Repository ผ่าน Interface (ไม่รู้ว่าข้างนอกเป็นอย่างไร)

**`application/usecases/SendMessageUseCase.ts`**
```typescript
import { IChatRepository } from '../../domain/repositories/IChatRepository';
import { ChatSession } from '../../domain/aggregates/ChatSession';
import { Message } from '../../domain/entities/Message';

export class SendMessageUseCase {
  // รับ Interface มา ไม่รับ Implementation โดยตรง (Dependency Inversion)
  constructor(private chatRepository: IChatRepository) {}

  public async execute(
    accountId: string,
    session: ChatSession,
    userInput: string
  ): Promise<string> {
    // 1. สร้าง Entity ใหม่ตาม Business Logic
    const userMessage = new Message('user', userInput);
    
    // 2. เพิ่มเข้า Aggregate (Domain จะตรวจสอบความถูกต้องเอง)
    session.addMessage(userMessage);

    // 3. ดึงประวัติทั้งหมดเพื่อส่งให้ AI
    const history = session.getMessages();

    // 4. เรียก Repository (Infrastructure) เพื่อส่ง API
    const assistantMessage = await this.chatRepository.sendMessage(accountId, history);

    // 5. บันทึกคำตอบของ AI กลับเข้า Session
    session.addMessage(assistantMessage);

    // 6. ส่งเฉพาะเนื้อหากลับไปแสดงผลที่ UI
    return assistantMessage.content;
  }
}
```

---

### 5. ชั้น Infrastructure (Implementation จริง)

ชั้นนี้จะ Implement Repository ที่ประกาศไว้ใน Domain โดยใช้ `$http` ของ AngularJS

**`infrastructure/config/AccountConfig.ts`** (ข้อมูล 3 บัญชี)
```typescript
export interface IAccount {
  id: string;
  name: string;
  apiKey: string;
}

export const ACCOUNT_LIST: IAccount[] = [
  { id: 'acc-1', name: 'บัญชี A', apiKey: 'sk-aaaa' },
  { id: 'acc-2', name: 'บัญชี B', apiKey: 'sk-bbbb' },
  { id: 'acc-3', name: 'บัญชี C', apiKey: 'sk-cccc' },
];
```

**`infrastructure/services/OpenCodeApiRepository.ts`** (Implement IChatRepository)
```typescript
import { IChatRepository } from '../../domain/repositories/IChatRepository';
import { Message } from '../../domain/entities/Message';
import { IAccount, ACCOUNT_LIST } from '../config/AccountConfig';

// ใช้ Decorator เพื่อบอก AngularJS ว่าให้ Inject อะไรบ้าง (จำเป็น)
export class OpenCodeApiRepository implements IChatRepository {
  // ประกาศ static $inject เพื่อให้ minification ทำงานได้
  public static $inject = ['$http'];

  constructor(private $http: ng.IHttpService) {}

  async sendMessage(accountId: string, messages: Message[]): Promise<Message> {
    // ค้นหา Account
    const account = ACCOUNT_LIST.find(acc => acc.id === accountId);
    if (!account) throw new Error('ไม่พบบัญชีนี้');

    // แปลง Message Entity เป็น JSON Payload
    const payload = {
      model: 'opencode/big-pickle',
      messages: messages.map(m => ({ role: m.role, content: m.content })),
      temperature: 0.7,
    };

    try {
      const response = await this.$http({
        method: 'POST',
        url: 'https://api.opencode.ai/v1/chat/completions', // ปรับ URL จริง
        headers: {
          'Authorization': `Bearer ${account.apiKey}`,
          'Content-Type': 'application/json',
        },
        data: payload,
      }).toPromise(); // แปลง $q Promise เป็น async/await

      const replyContent = response.data.choices[0].message.content;
      
      // สร้าง Entity Message ใหม่สำหรับผู้ช่วย (Assistant)
      return new Message('assistant', replyContent);
    } catch (error) {
      console.error('API Error:', error);
      throw new Error('เรียก API ไม่สำเร็จ');
    }
  }
}
```

---

### 6. ชั้น Presentation (AngularJS Controllers)

Controller จะเหลือแค่รับ Event จาก UI แล้วส่งต่อ Use Case โดยไม่มีการยุ่งกับ Business Logic

**`presentation/controllers/ChatController.ts`**
```typescript
import { SendMessageUseCase } from '../../application/usecases/SendMessageUseCase';
import { ChatSession } from '../../domain/aggregates/ChatSession';
import { ACCOUNT_LIST } from '../../infrastructure/config/AccountConfig';

export class ChatController {
  // ให้ AngularJS DI จัดการ Injection
  public static $inject = ['$scope', 'SendMessageUseCase'];

  public messages: { role: string; content: string }[] = [];
  public userInput: string = '';
  public isLoading: boolean = false;
  public selectedAccountId: string = ACCOUNT_LIST[0].id;
  public accountList = ACCOUNT_LIST;

  private session: ChatSession;

  constructor(
    private $scope: ng.IScope,
    private sendMessageUseCase: SendMessageUseCase
  ) {
    // สร้าง Session ใหม่ (ID อาจจะมาจาก Route)
    this.session = new ChatSession('session-123');
  }

  public async send() {
    if (!this.userInput.trim() || this.isLoading) return;

    // แสดงข้อความผู้ใช้ทันที (Optimistic UI)
    this.messages.push({ role: 'user', content: this.userInput });
    const input = this.userInput;
    this.userInput = '';
    this.isLoading = true;

    try {
      // เรียก Use Case (ไม่ต้องรู้ว่าข้างในเรียก API ยังไง)
      const assistantReply = await this.sendMessageUseCase.execute(
        this.selectedAccountId,
        this.session,
        input
      );

      // แสดงข้อความตอบกลับ
      this.messages.push({ role: 'assistant', content: assistantReply });
    } catch (error: any) {
      alert('เกิดข้อผิดพลาด: ' + error.message);
    } finally {
      this.isLoading = false;
      this.$scope.$applyAsync(); // อัปเดต UI
    }
  }
}
```

---

### 7. การประกอบร่างด้วย AngularJS Module (Inversion of Control)

ขั้นตอนสำคัญคือการนำคลาสต่างๆ ไปจดทะเบียนในระบบ DI ของ AngularJS โดยใช้ Factory Pattern

**`presentation/module/app.module.ts`**
```typescript
import * as angular from 'angular';

// 1. Import ชั้น Infrastructure
import { OpenCodeApiRepository } from '../../infrastructure/services/OpenCodeApiRepository';
// 2. Import ชั้น Application
import { SendMessageUseCase } from '../../application/usecases/SendMessageUseCase';
// 3. Import Controller
import { ChatController } from '../controllers/ChatController';

// สร้าง AngularJS Module
const app = angular.module('chatbotApp', []);

// --- การลงทะเบียน DI (Manual Factory) ---

// ลงทะเบียน Repository (Infrastructure)
app.factory('IChatRepository', ['$http', ($http: ng.IHttpService) => {
  return new OpenCodeApiRepository($http);
}]);

// ลงทะเบียน Use Case (Application) โดย Inject Interface ที่ประกาศไว้
app.factory('SendMessageUseCase', ['IChatRepository', (repo: any) => {
  return new SendMessageUseCase(repo);
}]);

// ลงทะเบียน Controller
app.controller('ChatController', ChatController);

export default app;
```

---

### 8. สรุปข้อดีของแนวทางนี้ (ประโยชน์ที่ได้)

| หลักการ | การประยุกต์ใช้กับโค้ดของเรา |
| :--- | :--- |
| **Domain-Driven Design (DDD)** | เรามี `ChatSession` Aggregate ที่คอยตรวจสอบข้อความว่าง และ `Message` Entity ที่ไม่ขึ้นกับเฟรมเวิร์ก ทำให้ Business Logic อยู่ตรงกลาง |
| **Clean Architecture** | เส้นลูกศร Dependency ชี้เข้าหา **Domain** เสมอ (Controller -> Use Case -> Repository Interface <- Repository Implementation) ทำให้เราสามารถเปลี่ยนจาก `$http` เป็น `Fetch` หรือเปลี่ยนโมเดล AI ได้ โดยไม่ต้องแก้ Use Case หรือ Domain |
| **Separation of Concerns** | UI (Controller) ไม่รู้ว่ามีบัญชี 3 บัญชีอยู่ที่ไหน หรือ API ส่งยังไง มันรู้แค่ว่าต้องเรียก `sendMessageUseCase.execute()` |
| **Testability** | คุณสามารถทดสอบ `SendMessageUseCase` โดยส่ง `Mock` Repository เข้าไป โดยไม่ต้องเปิดเว็บเบราว์เซอร์เลย |

---

### ⚠️ ข้อควรระวังสำหรับ AngularJS + TypeScript

1. **Minification**: ต้องประกาศ `public static $inject` ทุกคลาสที่ต้องการ DI เสมอ (ดังตัวอย่าง)
2. **Build Tool**: ต้องมีตัวแปลง (เช่น Webpack, Gulp) เพื่อรวมไฟล์และแปลง TypeScript เป็น JavaScript ก่อนรันใน Browser
3. **`this` Context**: ใน AngularJS Controller ถ้าใช้ `async/await` หรือ `.then` ต้องระวังการผูก `this` (ใช้ Arrow Function หรือ `bind`)

 # Role Definition
คุณคือ Senior Angular Software Engineer และ Solutions Architect ผู้เชี่ยวชาญด้าน Clean Architecture, Solid Principles, RxJS/Signals, และ Code Reviewer มืออาชีพ หน้าที่ของคุณคือการตรวจรีวิวโค้ด ค้นหา Error, Bug, Code Smells และเสนอแนวทางการ refactor ตามมาตรฐานสากล

# Review Criteria (เกณฑ์การตรวจรีวิว)
ให้วิเคราะห์โค้ดตาม 5 มิติต่อไปนี้:
1. **Clean Architecture & SOLID:**
   - การแบ่ง Layer (Domain, Data/Infrastructure, Presentation) มีการรั่วไหลของ Business Logic หรือไม่
   - การใช้ Dependency Injection และ Interface Segregation
2. **Angular Best Practices:**
   - การจัดการ State (Signals / RxJS), ChangeDetectionStrategy.OnPush
   - ป้องกัน Memory Leak (การ unsubscribe, `takeUntilDestroyed`)
   - โครงสร้าง Component, Directives, Pipes, และ Services
3. **Bug & Error Identification:**
   - Edge cases, Null/Undefined checks, Unhandled Promise/Observable errors
4. **Impact Analysis (วิเคราะห์ผลกระทบ):**
   - ตรวจสอบว่าโค้ดที่เพิ่ม/แก้ไข ส่งผลกระทบต่อโมดูลอื่น หรือสร้าง Side Effects หรือไม่
5. **Performance & Security:**
   - Re-rendering ที่ไม่จำเป็น, Memory usage, XSS Vulnerabilities, API Security

# Output Format (รูปแบบการตอบกลับ)
ตอบกลับด้วยโครงสร้างที่อ่านง่าย ดังนี้:

## 1. 📊 สรุปภาพรวม (Overview)
- คะแนนคุณภาพโค้ด (1-10) และสรุปความเสี่ยงโดยรวม

## 2. 🚨 รายการ Critical Bugs / Errors (ถ้ามี)
- อธิบายปัญหา + ตำแหน่งโค้ด + ผลกระทบที่จะเกิดขึ้น

## 3. ⚠️ Impact Analysis (วิเคราะห์ผลกระทบต่อส่วนอื่น)
- จุดที่โค้ดนี้อาจไปกระทบกับ Module, Service หรือ State อื่นๆ ในระบบ

## 4. 💡 Clean Architecture & Code Refactor Recommendations
- เปรียบเทียบ Before vs After (พร้อมชิ้นส่วนโค้ดที่ปรับปรุงแล้ว)
- อธิบายเหตุผลเบื้องหลังการปรับปรุง (Why & How)

---

# Rules & Constraints (ข้อห้ามและข้อควรระวัง)
- ห้ามแนะนำคำตอบที่ไม่ปลอดภัยหรือไม่สอดคล้องกับ Angular Version ล่าสุด (ใช้ Signals/Standalone Components เป็นหลักหากทำได้)
- หากโค้ดที่ให้มาขาดข้อมูลบริบทที่จำเป็น ให้ระบุสมมติฐาน (Assumptions) ไว้ล่วงหน้า
- ให้คำนึงถึง Maintainability และ Readability ของทีมเป็นสำคัญ

Normal Workflow
------------------------------
developer-workflow — without ai
⚡Step 1
    รับ Story Task จาก Product Owner
    ประชุม · จดโน้ต · ตีความเอง · อาจเข้าใจผิด
⚡Step 2
    แปลงเป็น Technical Task
    ถกเถียงทีม · ไม่มีโครงสร้าง · ใช้เวลานาน
⚡Step 3.1 → 3.3
    ทำความเข้าใจ · วางแผน · ลงมือทำ
    วางแผนในหัว · ลุยเลย · try & error · แก้ซ้ำหลายรอบ
⚡Step 3.4
    ตรวจสอบความถูกต้อง
    ดูเองว่าน่าจะโอเค · ไม่มี checklist · ไม่มี safety net
⚡Step 3.5
    Proof of Work
    record · screenshot ทำเอง
⚡Step 4 — QA
    QA ตรวจสอบ
        ↩ พบ bug → ย้อนกลับไปแก้ · เสียเวลา · ส่งงานช้า
------------------------------

Normal Workflow · Step 3.1
⚡ tb-brainstorming
ทำความเข้าใจ Task ค้นหา assumption ที่ผิดพลาด และตั้งคำถามกับตัวเองก่อนลงมือทำ
Normal / Bug Fix Path A · Step 3.2
⚡ tb-writing-plans
วางแผน implementation แบ่งงานเป็น subtask ชัดเจน ก่อน execute ทุกครั้ง

Normal / Bug Fix Path A · Step 3.3
⚡ tb-executing-plans
ลงมือ implement ตาม plan ทีละขั้นตอน ไม่ข้ามหรือย่นขั้นตอนโดยพลการ
MANDATORY GATE · Step 3.4 / ทั้ง 2 Bug Path

------------------------------
Bug Fix Workflow
🔍Step 1 — เริ่มเสมอ
    tb-investigate-error
    
Path A — แก้หลายจุด
⚡Step 2
    tb-writing-plans
⚡Step 3
    tb-executing-plans

Path B — แก้จุดเดียว
⚡Step 2
    tb-test-driven-development
🛡 MANDATORY GATE — ทั้ง 2 path
    tb-scrutinize
------------------------------------------------------------
Bug Fix · เริ่มเสมอ
🔍 tb-investigate-error
วิเคราะห์ root cause จัดลำดับสาเหตุ และออก report ก่อนวางแผนแก้ไขทุกครั้ง

Bug Fix Path B · Step 2
⚡ tb-test-driven-development
เขียน test ก่อน แล้วค่อยเขียนโค้ดให้ test ผ่าน ใช้เมื่อแก้ bug จุดเดียว

🛡 tb-scrutinize
ตรวจสอบโค้ด logic และ side effects ก่อน merge — ต้องผ่านทุกครั้งไม่มีข้อยกเว้น

------------------------------------------------------------

skill
1. สั่ง copilot  
   - copilot
   - /tb-brainstorming
   - แล้ว เอาโจทย์มา วาง เพื่อให้  AI วิเคาะห์ 
   - /tb-writing-plans
   -  ถาม และ ให้ ทางเลือก แสดงแนวทางตัดสินใจ ไปจน กว่าจะ สมบุรณ์
   - /tb-executing-plans
   - เริ่ม ทำงาน ตาม plans
  
------------------------------------------------------------------------------------------------------------------------

# สั่ง copilot  
   - copilot
   - /tb-brainstorming
- GET http://localhost:8080/employees ดึงข้อมูลพนักงานทั้งหมด
Table Employee
Field มีดังนี้
id string (UUID),
full_name string,
email string,
created_at datetime,
updated_at datetime

Business logic (ตรรกะทางธุรกิจ) คือ กฎเกณฑ์ ขั้นตอนการทำงาน
ให้สร้าง API เส้น POST http://localhost:8080/employee สำหรับเพิ่มข้อมูลพนักงาน

รายละเอียด
- id ต้อง autogenerate เป็น UUID
- full_name เป็น input เป็น require field
- email เป็น input เป็น require field และห้ามซ้ำ
- created_at เป็นเวลาที่ Create รายการ
- updated_at ถ้าเป็นการ Create รายการ จะให้ updated_at เป็นเวลาที่ Create รายการ

- ตัวอย่าง โครงสร้าง Foder และ ไฟล์ ของ Modules
    ```bash

# 2. สถาปัตยกรรมระบบ

## 2.1 แผนภาพสถาปัตยกรรมระดับสูง (High-Level Architecture)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           PRESENTATION LAYER                                │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐      │
│  │   Pages      │ │   Layouts    │ │   Shared     │ │   Components │      │
│  │ (Routing)    │ │ (Sidebar,    │ │ (Buttons,    │ │ (Reusable)   │      │
│  │              │ │  Header,     │ │  Cards,      │ │              │      │
│  │              │ │  Footer)     │ │  Modals)     │ │              │      │
│  └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘      │
│                              ▼                                             │
│                    [Angular Router + Guards]                                │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                             DOMAIN LAYER                                   │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐      │
│  │   Entities   │ │  Use Cases   │ │ Repositories │ │   Services   │      │
│  │ (Business    │ │ (Business    │ │ (Interfaces) │ │ (Domain      │      │
│  │  Objects)    │ │  Logic)      │ │              │ │  Services)   │      │
│  └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘      │
│                                                                             │
│  หลักการ: ไม่มีการพึ่งพาภายนอก — บริสุทธิ์ (Pure Business Logic)             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              DATA LAYER                                    │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐      │
│  │ Repositories │ │  DataSources │ │    DTOs      │ │   Mappers    │      │
│  │ (Implements  │ │ (API, Local, │ │ (Data        │ │ (Entity ↔    │      │
│  │  Interfaces) │ │  Cache)      │ │  Transfer)   │ │  DTO)        │      │
│  └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘      │
│                                                                             │
│  หลักการ: จัดการข้อมูลจากภายนอก — เปลี่ยนรูปแบบให้ Domain เข้าใจได้         │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            CORE LAYER                                      │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐      │
│  │   Config     │ │   Utils      │ │  Constants   │ │  Interceptors│      │
│  │ (App Settings│ │ (Helpers,    │ │ (Enums,      │ │ (HTTP,       │      │
│  │  Environment)│ │  Validators) │ │  Status)     │ │  Auth)       │      │
│  └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘      │
│                                                                             │
│  หลักการ: กลไกสนับสนุนการทำงานของทุกเลเยอร์                                │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 2.2 แผนภาพโครงสร้างโปรเจกต์ Angular (Folder Structure)

```
src/
├── app/
│   ├── core/                              # ⚙️ Core Layer
│   │   ├── config/
│   │   │   ├── app.config.ts              # ค่ากำหนดหลัก
│   │   │   └── api.config.ts              # API Endpoints
│   │   ├── constants/
│   │   │   ├── app.constants.ts
│   │   │   └── enums.ts                   # Enum ทั่วทั้งระบบ
│   │   ├── utils/
│   │   │   ├── validators.ts
│   │   │   ├── formatters.ts
│   │   │   └── helpers.ts
│   │   └── interceptors/
│   │       ├── auth.interceptor.ts
│   │       └── error.interceptor.ts
│   │
│   ├── shared/                            # 🔄 Shared Components
│   │   ├── components/
│   │   │   ├── buttons/
│   │   │   ├── cards/
│   │   │   ├── modals/
│   │   │   ├── tables/
│   │   │   └── forms/
│   │   ├── directives/
│   │   ├── pipes/
│   │   └── guards/
│   │
│   ├── features/                          # 📦 Feature Modules (Lazy Loading)
│   │   │
│   │   ├── auth/                          # 🔐 โมดูลที่ 1: Authentication
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── user.entity.ts
│   │   │   │   │   └── permission.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── login.use-case.ts
│   │   │   │   │   ├── logout.use-case.ts
│   │   │   │   │   ├── refresh-token.use-case.ts
│   │   │   │   │   └── check-permission.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── auth.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── auth.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       ├── login-request.dto.ts
│   │   │   │       └── login-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── login/
│   │   │       │   └── forgot-password/
│   │   │       └── components/
│   │   │           └── permission-guard/
│   │   │
│   │   ├── job-card/                      # 📋 โมดูลที่ 2: Job Card Management
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── job-card.entity.ts
│   │   │   │   │   ├── job-status.enum.ts
│   │   │   │   │   └── job-priority.enum.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-job.use-case.ts
│   │   │   │   │   ├── update-job.use-case.ts
│   │   │   │   │   ├── get-job.use-case.ts
│   │   │   │   │   ├── list-jobs.use-case.ts
│   │   │   │   │   ├── assign-job.use-case.ts
│   │   │   │   │   └── update-job-status.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── job-card.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── job-card.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── job-card.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       ├── create-job-request.dto.ts
│   │   │   │       └── job-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── job-list/
│   │   │       │   ├── job-detail/
│   │   │       │   ├── job-create/
│   │   │       │   └── job-board/         # Kanban View
│   │   │       └── components/
│   │   │           ├── job-card/
│   │   │           ├── job-filters/
│   │   │           └── job-timeline/
│   │   │
│   │   ├── customer/                      # 👤 โมดูลที่ 3: Customer Management
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── customer.entity.ts
│   │   │   │   │   └── customer-contact.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-customer.use-case.ts
│   │   │   │   │   ├── update-customer.use-case.ts
│   │   │   │   │   ├── get-customer.use-case.ts
│   │   │   │   │   ├── list-customers.use-case.ts
│   │   │   │   │   └── search-customers.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── customer.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── customer.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── customer.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── customer-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── customer-list/
│   │   │       │   ├── customer-detail/
│   │   │       │   └── customer-create/
│   │   │       └── components/
│   │   │           └── customer-search/
│   │   │
│   │   ├── quotation/                     # 📄 โมดูลที่ 4: Quotation
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── quotation.entity.ts
│   │   │   │   │   ├── quotation-item.entity.ts
│   │   │   │   │   └── quotation-status.enum.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-quotation.use-case.ts
│   │   │   │   │   ├── update-quotation.use-case.ts
│   │   │   │   │   ├── get-quotation.use-case.ts
│   │   │   │   │   ├── list-quotations.use-case.ts
│   │   │   │   │   ├── approve-quotation.use-case.ts
│   │   │   │   │   └── reject-quotation.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── quotation.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── quotation.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── quotation.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       ├── create-quotation-request.dto.ts
│   │   │   │       └── quotation-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── quotation-list/
│   │   │       │   ├── quotation-detail/
│   │   │       │   └── quotation-create/
│   │   │       └── components/
│   │   │           ├── quotation-pdf/
│   │   │           └── quotation-items/
│   │   │
│   │   ├── purchase-order/                # 🛒 โมดูลที่ 5: Purchase Order
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── purchase-order.entity.ts
│   │   │   │   │   ├── po-item.entity.ts
│   │   │   │   │   └── po-status.enum.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-po.use-case.ts
│   │   │   │   │   ├── update-po.use-case.ts
│   │   │   │   │   ├── get-po.use-case.ts
│   │   │   │   │   ├── list-pos.use-case.ts
│   │   │   │   │   └── approve-po.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── purchase-order.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── purchase-order.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── po.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── po-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── po-list/
│   │   │       │   ├── po-detail/
│   │   │       │   └── po-create/
│   │   │       └── components/
│   │   │           └── po-approval/
│   │   │
│   │   ├── inventory/                     # 📦 โมดูลที่ 6: Inventory Management
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── product.entity.ts
│   │   │   │   │   ├── category.entity.ts
│   │   │   │   │   └── stock-movement.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-product.use-case.ts
│   │   │   │   │   ├── update-product.use-case.ts
│   │   │   │   │   ├── get-product.use-case.ts
│   │   │   │   │   ├── list-products.use-case.ts
│   │   │   │   │   ├── adjust-stock.use-case.ts
│   │   │   │   │   └── get-stock-movements.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── inventory.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── inventory.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── inventory.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── product-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── product-list/
│   │   │       │   ├── product-detail/
│   │   │       │   ├── product-create/
│   │   │       │   └── stock-adjustment/
│   │   │       └── components/
│   │   │           ├── stock-alert/
│   │   │           └── barcode-scanner/
│   │   │
│   │   ├── payment/                       # 💳 โมดูลที่ 7: Payment Management
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── payment.entity.ts
│   │   │   │   │   ├── invoice.entity.ts
│   │   │   │   │   └── payment-status.enum.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-payment.use-case.ts
│   │   │   │   │   ├── get-payment.use-case.ts
│   │   │   │   │   ├── list-payments.use-case.ts
│   │   │   │   │   ├── verify-payment.use-case.ts
│   │   │   │   │   └── generate-invoice.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── payment.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── payment.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── payment.api.datasource.ts
│   │   │   │   │   └── payment-gateway.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── payment-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── payment-list/
│   │   │       │   ├── payment-detail/
│   │   │       │   ├── payment-create/
│   │   │       │   └── invoice-view/
│   │   │       └── components/
│   │   │           └── payment-gateway/
│   │   │
│   │   ├── dashboard/                     # 📊 โมดูลที่ 8: Dashboard & Reports
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── dashboard-stats.entity.ts
│   │   │   │   │   └── report.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── get-dashboard-stats.use-case.ts
│   │   │   │   │   ├── get-revenue-chart.use-case.ts
│   │   │   │   │   ├── generate-report.use-case.ts
│   │   │   │   │   └── export-report.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── dashboard.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── dashboard.repository.impl.ts
│   │   │   │   └── datasources/
│   │   │   │       └── dashboard.api.datasource.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── main-dashboard/
│   │   │       │   ├── reports/
│   │   │       │   └── analytics/
│   │   │       └── components/
│   │   │           ├── stats-cards/
│   │   │           ├── revenue-chart/
│   │   │           ├── recent-activities/
│   │   │           └── quick-actions/
│   │   │
│   │   ├── document/                      # 📁 โมดูลที่ 9: Document Management
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── document.entity.ts
│   │   │   │   │   └── document-folder.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── upload-document.use-case.ts
│   │   │   │   │   ├── get-document.use-case.ts
│   │   │   │   │   ├── list-documents.use-case.ts
│   │   │   │   │   ├── delete-document.use-case.ts
│   │   │   │   │   └── share-document.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── document.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── document.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── document.api.datasource.ts
│   │   │   │   │   └── document-storage.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── document-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── document-list/
│   │   │       │   ├── document-detail/
│   │   │       │   └── document-upload/
│   │   │       └── components/
│   │   │           └── document-preview/
│   │   │
│   │   ├── email/                         # ✉️ โมดูลที่ 10: Email Service
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── email-template.entity.ts
│   │   │   │   │   └── email-log.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── send-email.use-case.ts
│   │   │   │   │   ├── send-bulk-email.use-case.ts
│   │   │   │   │   ├── get-email-logs.use-case.ts
│   │   │   │   │   └── create-email-template.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── email.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── email.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   └── email.api.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── send-email-request.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── email-templates/
│   │   │       │   ├── email-logs/
│   │   │       │   └── email-compose/
│   │   │       └── components/
│   │   │           └── email-editor/
│   │   │
│   │   ├── batch/                         # ⏰ โมดูลที่ 11: Batch Jobs
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── batch-job.entity.ts
│   │   │   │   │   └── job-schedule.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── create-batch-job.use-case.ts
│   │   │   │   │   ├── get-batch-job.use-case.ts
│   │   │   │   │   ├── list-batch-jobs.use-case.ts
│   │   │   │   │   └── trigger-batch-job.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── batch-job.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── batch-job.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── batch.api.datasource.ts
│   │   │   │   │   └── queue.datasource.ts
│   │   │   │   └── dtos/
│   │   │   │       └── batch-job-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── batch-list/
│   │   │       │   └── batch-create/
│   │   │       └── components/
│   │   │           └── job-scheduler/
│   │   │
│   │   ├── i18n/                          # 🌍 โมดูลที่ 12: Multi-Language
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── translation.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── get-translation.use-case.ts
│   │   │   │   │   ├── set-language.use-case.ts
│   │   │   │   │   └── get-available-languages.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── translation.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── translation.repository.impl.ts
│   │   │   │   └── datasources/
│   │   │   │       ├── translation.api.datasource.ts
│   │   │   │       └── translation-local.datasource.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   └── language-selector/
│   │   │       └── pipes/
│   │   │           └── translate.pipe.ts
│   │   │
│   │   ├── iot/                           # 📡 โมดูลที่ 13: IoT & GPS Tracking
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── device.entity.ts
│   │   │   │   │   ├── gps-data.entity.ts
│   │   │   │   │   └── sensor-data.entity.ts
│   │   │   │   ├── use-cases/
│   │   │   │   │   ├── register-device.use-case.ts
│   │   │   │   │   ├── get-device-location.use-case.ts
│   │   │   │   │   ├── get-device-history.use-case.ts
│   │   │   │   │   └── get-sensor-data.use-case.ts
│   │   │   │   └── repositories/
│   │   │   │       └── iot.repository.ts
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── iot.repository.impl.ts
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── iot.api.datasource.ts
│   │   │   │   │   └── socket.datasource.ts   # Real-time
│   │   │   │   └── dtos/
│   │   │   │       └── device-response.dto.ts
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── device-list/
│   │   │       │   ├── device-map/           # Google Maps Integration
│   │   │       │   └── device-detail/
│   │   │       └── components/
│   │   │           ├── gps-tracker/
│   │   │           └── device-status/
│   │   │
│   │   └── wos/                           # 🛍️ โมดูลที่ 14: Web Order System
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   ├── web-order.entity.ts
│   │       │   │   ├── order-item.entity.ts
│   │       │   │   └── order-status.enum.ts
│   │       │   ├── use-cases/
│   │       │   │   ├── create-web-order.use-case.ts
│   │       │   │   ├── get-web-order.use-case.ts
│   │       │   │   ├── list-web-orders.use-case.ts
│   │       │   │   ├── update-order-status.use-case.ts
│   │       │   │   └── cancel-order.use-case.ts
│   │       │   └── repositories/
│   │       │       └── web-order.repository.ts
│   │       ├── data/
│   │       │   ├── repositories/
│   │       │   │   └── web-order.repository.impl.ts
│   │       │   ├── datasources/
│   │       │   │   └── wos.api.datasource.ts
│   │       │   └── dtos/
│   │       │       └── web-order-response.dto.ts
│   │       └── presentation/
│   │           ├── pages/
│   │           │   ├── order-list/
│   │           │   ├── order-detail/
│   │           │   └── order-create/
│   │           └── components/
│   │               ├── order-summary/
│   │               └── order-tracking/
│   │
│   └── app.routes.ts                      # 🗺️ Main Routing (Lazy Loading)
│
├── assets/
│   ├── images/
│   ├── i18n/                              # ไฟล์แปลภาษา
│   │   ├── en.json
│   │   └── th.json
│   └── tabler/                            # Tabler Static Assets
│
├── environments/
│   ├── environment.ts
│   └── environment.prod.ts
│
└── styles.scss                            # Global Styles (Import Tabler)
```

    ```
 - หลักการทำงาน (Concept) 
 - Affected กับส่วนไหนบ้าง
 - แสดงรายการ ให้เห็นว่า จะทำงานกระบวการอย่างไร
 - ข้อกำหนด/ ข้อห้าม
  - ไม่แก้ โครงสร้างเดิม
  - ไม่แก้ Function เดิม ที่ใช้งานร่วมกัน
  - ข้อควรระวัง/ข้อดี/ ข้อเสีย
- ออกแบบ workflow วาดรูป dataflow ลักษณะ flowchart   เพื่ออธิบายกระบวนการ เพื่อ ทำความเข้าใจ
- โครงสร้าง Foder และ ไฟล์ ของ Modules
   ตัวอย่าง
    ```bash
   
    ```
- รายงานสรุปผลการดำเนิดการ อะไรไปบ้าง และบอกกระบวนการทดสอบผล
- /tb-writing-plans
- /tb-executing-plans

 Proof of Work 


บอกทุกอย่าง ทั้งโครงสร้าง ทั้งหมด  ใช้สำหรับ prom AI
- Step 1
-  - Step 2
- Step 2
-  writing-plans
   1. สร้าง module ใหม่ 

- Step 2
-  writing-plans
   1. สร้าง module ใหม่ 

- Step 3
 test-driven-development

- Step 4
tb-executing-plans

- Step 5
   Code_Review 

- Step 6
   Fixbug