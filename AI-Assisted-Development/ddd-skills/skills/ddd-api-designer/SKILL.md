---
ชื่อ: ddd-api-designer
คำอธิบาย: การออกแบบ API จากโดเมนโมเดล — การแยก Command/Query ตาม CQRS, การออกแบบ REST API endpoint, สายการแปลงออบเจ็กต์ข้อมูล (PO→DO→DTO→VO), รูปแบบการตอบกลับแบบรวม, การสร้าง OpenAPI/Swagger, รูปแบบ BFF, การทำเวอร์ชัน API, และการออกแบบความปลอดภัย ใช้เมื่อผู้ใช้ถามเกี่ยวกับการออกแบบ API, REST API, OpenAPI, BFF, การออกแบบ DTO, การออกแบบอินเทอร์เฟซ, หรือการแปลงออบเจ็กต์ข้อมูล
สัญญาอนุญาต: Apache-2.0
---

# DDD API Designer

คู่มือการออกแบบครบวงจรจากโดเมนโมเดลสู่ REST API: การแยกอ่าน/เขียนแบบ CQRS, สายการแปลงออบเจ็กต์ข้อมูลสี่ชั้น (PO→DO→DTO→VO), รูปแบบการตอบกลับแบบรวม, การปรับให้เข้ากับหลายแพลตฟอร์มด้วย BFF, การจัดการเวอร์ชัน และการออกแบบความปลอดภัย

## Workflow

1. **ระบุ Command vs Query** — แบ่งพฤติกรรมโดเมนเป็น command (เขียน) และ query (อ่าน) เพื่อกำหนด Method และ endpoint
2. **ออกแบบสายการแปลงออบเจ็กต์ข้อมูล** — สร้างการแปลงสี่ชั้น PO→DO→DTO→VO แต่ละชั้นมีหน้าที่อิสระ
3. **ออกแบบ REST endpoint** — Command ใช้คำกริยาต่อท้าย, Query ใช้การตั้งชื่อตามทรัพยากร
4. **กำหนดรูปแบบการตอบกลับแบบรวม** — ห่อด้วย Result<T> + ระบบรหัสข้อผิดพลาดทางธุรกิจ
5. **ใช้ BFF** — หนึ่ง BFF ต่อหนึ่ง frontend, รวมข้อมูล + ปรับรูปแบบ + แปลงโปรโตคอล
6. **เลือกกลยุทธ์เวอร์ชัน** — แนะนำ URL Path: /api/v1/orders, เป็นมิตรกับ CDN
7. **ใช้การควบคุมความปลอดภัย** — AuthN + AuthZ + การตรวจสอบสามชั้น + การจำกัดอัตราแบบแตกต่าง

## When to Use

| ✅ ควรใช้เสมอเมื่อ | ❌ ข้ามเมื่อ |
|---|---|
| การออกแบบ API, REST API, การออกแบบอินเทอร์เฟซ | เครื่องมือภายในที่ไม่มีผู้บริโภคภายนอก |
| การออกแบบ DTO/VO, การแปลงออบเจ็กต์ข้อมูล | โปรเจกต์ GraphQL/gRPC |
| BFF / Backend for Frontend | ไม่มีโดเมนโมเดล → ใช้ domain-designer |
| OpenAPI / Swagger / เอกสาร API | CRUD ง่าย ๆ ไม่มี DDD |
| การจัดการเวอร์ชัน API / การออกแบบความปลอดภัย | ไมโครเซอร์วิส gRPC ล้วน (ใช้ protobuf IDL) |
| ต้องการเปิดเผย DDD aggregate เป็น REST API | ต้นแบบเร็วที่ไม่สนใจมาตรฐาน API |

## Boundary

### ✅ เหมาะสมชัดเจน
- ต้องการเปิดเผย DDD domain model เป็น REST API — การแยกอ่าน/เขียน CQRS, สายการแปลงออบเจ็กต์ข้อมูลครบถ้วน
- การออกแบบแยก Command/Query ตาม CQRS — Command DTO และ Query DTO แยกกัน วิวัฒน์ได้อิสระ
- การออกแบบ API แบบรวมสำหรับหลายแพลตฟอร์ม (Web/iOS/MiniApp) — รูปแบบ BFF ปรับตามแพลตฟอร์ม
- การออกแบบรูปแบบการตอบกลับแบบรวมและระบบรหัสข้อผิดพลาด — Result<T> + มาตรฐานรหัสข้อผิดพลาดทางธุรกิจ
- การส่งออกข้อกำหนด OpenAPI/Swagger — กลยุทธ์สร้างโค้ดให้อินเทอร์เฟซและ implementation ตรงกัน

### ⚠ ต้องประเมินอย่างระมัดระวัง
- ทีมไม่คุ้นเคยกับ DDD/CQRS → เรียนรู้แนวคิดพื้นฐานก่อน
- แอปพลิเคชันโมโนลิธิกไม่มีความต้องการขยาย → ประเมิน ROI อาจออกแบบเกินจำเป็น
- API เดิมไม่มีความต้องการความเข้ากันได้กับผู้บริโภค → การจัดการเวอร์ชันทำให้ง่ายขึ้นได้

### ❌ ไม่เหมาะ
- โปรเจกต์ GraphQL/gRPC → ใช้ IDL และเครื่องมือที่สอดคล้อง
- CRUD ง่าย ๆ ไม่มี DDD → ใช้ REST framework ทั่วไปหรือ domain-designer ก่อน
- ระยะต้นแบบ/สาธิตเร็ว → ใช้ API แบบง่ายก่อน แล้วค่อยนำมาตรฐานมาใช้
- ไมโครเซอร์วิส gRPC ล้วน → ใช้ protobuf IDL + gRPC interceptor
- เครื่องมือภายในที่ไม่มีผู้บริโภคภายนอก → ทำให้การออกแบบ API ง่ายขึ้น

## CQRS API Design

Command (เขียน) ขับด้วยคำกริยา, Query (อ่าน) ขับด้วยทรัพยากร:

| มิติ | Command | Query |
|------|---------|-------|
| HTTP Method | POST/PUT/DELETE | GET |
| คำกริยาใน URL | ต้องมี (confirm, cancel) | ไม่ต้องมี |
| Request body | Command object | มีเพียง query parameter |
| การแยก DTO | Command DTO แยก | Query DTO แยก |
| Idempotency | ต้องทำให้เกิด | โดยธรรมชาติเป็น idempotent |
| Cache | ไม่แคชเลย | ETag, max-age |
| Response | สรุปทรัพยากรที่สร้าง | data DTO / list |

หลักการ: Command DTO และ Query DTO ต้องแยกกันเสมอ Sub-resource ซ้อนกันได้ไม่เกิน 2 ชั้น ดูรายละเอียด [references/patterns/cqrs-api-design.md](references/patterns/cqrs-api-design.md)

## สายการแปลงออบเจ็กต์ข้อมูล (PO → DO → DTO → VO)

| Object | Layer | หน้าที่ | การมองเห็น |
|------|-----|------|--------|
| **PO** | Infrastructure | ORM mapping, สอดคล้องโครงสร้างฐานข้อมูล | ภายใน |
| **DO** | Domain | Rich model, มีพฤติกรรมทางธุรกิจ | ภายใน |
| **DTO** | Interface/App | การส่งข้อมูลข้ามชั้นข้ามบริการ | กึ่งภายใน |
| **VO** | Interface | ข้อมูลแสดงผลเฉพาะหน้า | ภายนอก |

ทิศทางอ่าน: PO→DO→DTO→VO; ทิศทางเขียน: VO→DTO→Command→DO→PO
DO หนึ่งตัวสามารถแปลงเป็น DTO ได้หลายตัวตามสถานการณ์ (DTO รายละเอียด, DTO สรุป ฯลฯ) Controller ไม่ส่งคืน domain object โดยตรง ดูรายละเอียด [references/examples-ref/data-object-transformation.md](references/examples-ref/data-object-transformation.md)

## มาตรฐานการออกแบบ API

| กฎ | ตัวอย่าง |
|------|------|
| คำนามพหูพจน์ | /orders ✓ |
| Kebab-case | /order-history ✓ |
| ซ้อนได้ไม่เกิน 2 ชั้น | /orders/{id}/items |
| คำกริยาต่อท้ายสำหรับเขียน | /orders/{id}/confirm |
| Query parameter | ?status=PAID&page=1 |
| ไม่มีคำกริยาใน URL | ❌ GET /getOrders → GET /orders |

HTTP Status: 201 Created (สร้าง), 200 OK (ค้นหา/อัปเดต), 204 No Content (ลบ), 400 (validation/ธุรกิจ), 404 (ไม่พบ), 409 (ชนกันแบบ concurrent), 429 (จำกัดอัตรา), 500 (ข้อผิดพลาดภายใน) ดูรายละเอียด [references/security/api-naming-conventions.md](references/security/api-naming-conventions.md)

## รูปแบบการตอบกลับแบบรวม

สำเร็จ: `{ "code": 0, "message": "success", "data": T }` — 201/200/204
ข้อผิดพลาด: `{ "code": 40001, "message": "...", "detail": "...", "requestId": "req-xxx" }` — 400/404/409/429/500

Response wrapper `Result<T>` ประกอบด้วย code + message + data + requestId การตอบกลับข้อผิดพลาดห้ามส่ง stack trace ดูรายละเอียด [references/examples-ref/unified-response-format.md](references/examples-ref/unified-response-format.md)

## BFF (Backend for Frontend)

หนึ่ง BFF ต่อหนึ่ง frontend (Web/iOS/MiniApp) หน้าที่:
- **Data aggregation**: รวมข้อมูลจากหลายบริการเป็นหน้า VO (เรียก frontend 1 ครั้งแทน N ครั้ง)
- **Format adaptation**: Web ฟิลด์เต็ม / มือถือฟิลด์ย่อ
- **Protocol conversion**: ภายใน gRPC → ภายนอก REST/JSON
- **Response shaping**: ลบฟิลด์ภายใน, เพิ่ม UI metadata

ต่างจาก API Gateway: BFF ทำ view aggregation (ระดับหน้า), Gateway ทำ routing + rate limiting (ระดับบริการ)
BFF ไม่เข้าถึงฐานข้อมูลโดยตรง ไม่มี business logic ดูรายละเอียด [references/patterns/BFF-design-pattern.md](references/patterns/BFF-design-pattern.md)

## การจัดการเวอร์ชัน API

| กลยุทธ์ | ตัวอย่าง | ความแนะนำ |
|------|------|:------:|
| **URL Path** ★ | `/api/v1/orders` → `/api/v2/orders` | ★★★★★ |
| Request Header | `Accept: vnd.company.v2+json` | ★★★☆☆ |
| Query Param | `/api/orders?version=2` | ★★☆☆☆ |

แนะนำ URL Path: ตรงไปตรงมา, เป็นมิตรกับ CDN, เข้ากันได้กับ Swagger กระบวนการย้าย: v1 → v1+v2 → v2 only → v1 sunset (410 Gone) ดูรายละเอียด [references/migration/api-versioning-strategies.md](references/migration/api-versioning-strategies.md)

## การออกแบบความปลอดภัย API

โมเดลความปลอดภัยสี่ชั้น:
1. **Authentication**: JWT Bearer Token / OAuth2 / API Key (ระหว่างบริการ)
2. **Authorization**: ตาม bounded context + ความเป็นเจ้าของทรัพยากร + บทบาท
3. **Input validation**: Controller รูปแบบ → Application ธุรกิจ → Domain invariant
4. **Rate limiting**: Command 50/s, Query 200/s, Auth 10/s ดูรายละเอียด [references/security/api-security-design.md](references/security/api-security-design.md)

## Gotchas — กับดักที่พบบ่อย

DTO เปิดเผย enum→string code | ใช้ Command/Query DTO ปนกัน→แยก | null safety→จัดการ Optional | VO ส่งผ่านฟิลด์ DB→ปรับตาม view |
ขาด idempotency→Idempotency-Key | ข้อผิดพลาดส่ง stack trace→requestId | ซ้อนลึก→≤2 ชั้น | ซีเรียลไลซ์ domain object→ผ่าน DTO/VO

## Rules

- **แยก Command/Query DTO** — การเขียนและการอ่านใช้ DTO อิสระ ห้ามใช้โครงสร้างเดียวกัน
- **Controller ทำ protocol conversion** — ชั้น Controller ทำเพียง HTTP protocol adaptation ไม่มี business logic หรือเรียก domain
- **คำนำหน้ารหัสข้อผิดพลาดแบบรวม** — รหัสธุรกิจ 5 หลัก: หลักแรกหมวด (4=client/5=server) + สองหลัก HTTP + สามหลักท้ายข้อผิดพลาดเฉพาะ
- **ขอบเขตหน้าที่ BFF** — BFF ทำเพียง data aggregation และ format adaptation ไม่เข้าถึงฐานข้อมูลโดยตรงหรือมี business rule
- **Response wrapping** — API response ทั้งหมดใช้ Result<T> ห่อ ยกเว้น 204 No Content และการดาวน์โหลดไฟล์

## FAQ

| คำถาม | คำตอบ |
|----------|--------|
| DO และ DTO มีฟิลด์เหมือนกัน ใช้ซ้ำได้ไหม? | ไม่ได้ DO มีพฤติกรรม DTO เป็นข้อมูลล้วน ทิศทางวิวัฒน์ต่างกัน |
| API ทั้งหมดต้องใช้รูปแบบการตอบกลับแบบรวมไหม? | ใช่ ยกเว้นดาวน์โหลดไฟล์, 204 |
| ออกแบบรหัสข้อผิดพลาดอย่างไร? | ตัวเลข 5 หลัก: หลักแรกหมวด+สองหลัก HTTP+สามหลักท้ายข้อผิดพลาดเฉพาะ |
| เมื่อไหร่ต้องมี BFF? | เมื่อมีหลายแพลตฟอร์ม frontend หรือ frontend ต้องรวมข้อมูลหลายบริการ |
| Sub-resource ซ้อนได้กี่ชั้น? | สูงสุด 2 ชั้น เกิน 2 ชั้นแสดงว่า aggregation boundary มีปัญหา |
| ใส่ business logic ใน Controller ได้ไหม? | ไม่ได้ ทำเพียง protocol conversion |

## Keywords

`CQRS API` `REST endpoint design` `PO DO DTO VO` `data object transformation` `unified response format` `BFF` `Backend for Frontend` `OpenAPI` `Swagger` `API versioning` `API security` `command query separation` `Result<T>` `response wrapper` `input validation` `rate limiting` `idempotency` `pagination design`

## References
- [references/patterns/cqrs-api-design.md](references/patterns/cqrs-api-design.md) — การออกแบบ CQRS API
- [references/examples-ref/data-object-transformation.md](references/examples-ref/data-object-transformation.md) — การแปลง PO↔DO↔DTO↔VO
- [references/patterns/BFF-design-pattern.md](references/patterns/BFF-design-pattern.md) — รูปแบบการออกแบบ BFF
- [references/security/api-security-design.md](references/security/api-security-design.md) — ความปลอดภัย API
- [references/migration/api-versioning-strategies.md](references/migration/api-versioning-strategies.md) — การจัดการเวอร์ชัน
- [references/security/api-naming-conventions.md](references/security/api-naming-conventions.md) — มาตรฐานการตั้งชื่อ
- [references/examples-ref/unified-response-format.md](references/examples-ref/unified-response-format.md) — การตอบกลับแบบรวม
- [references/security/openapi-specification.md](references/security/openapi-specification.md) — ข้อกำหนด OpenAPI 3.0
- [references/patterns/data-access-api.md](references/patterns/data-access-api.md) — การออกแบบ API ชั้นเข้าถึงข้อมูล
- [references/patterns/idempotency-design.md](references/patterns/idempotency-design.md) — การออกแบบ idempotency
- [references/patterns/pagination-filtering-design.md](references/patterns/pagination-filtering-design.md) — การแบ่งหน้าและการกรอง
- [references/architecture/partme-16-service-data-view.md](references/architecture/partme-16-service-data-view.md) — ความสัมพันธ์แบบร่วมมือ
- [references/architecture/clean-ddd-hexagonal-hexagonal.md](references/architecture/clean-ddd-hexagonal-hexagonal.md) — สถาปัตยกรรมหกเหลี่ยม
- [references/examples-ref/api-error-handling.md](references/examples-ref/api-error-handling.md) — การจัดการข้อผิดพลาด
- [references/security/api-rate-limiting.md](references/security/api-rate-limiting.md) — การออกแบบ rate limiting
- [references/examples-ref/event-driven-api.md](references/examples-ref/event-driven-api.md) — API ที่ขับด้วยเหตุการณ์

## Examples

- [examples/order-api-design.md](examples/order-api-design.md) — กรณีบริการคำสั่งซื้อ
- [examples/user-api-design.md](examples/user-api-design.md) — กรณีบริการผู้ใช้: ลงทะเบียน/เข้าสู่ระบบ/โปรไฟล์ + การออกแบบความปลอดภัย
- [examples/BFF-aggregation-example.md](examples/BFF-aggregation-example.md) — กรณี BFF aggregation: รวมข้อมูลหลายบริการสำหรับหน้าลายละเอียดคำสั่งซื้อ
- [examples/api-version-migration.md](examples/api-version-migration.md) — กรณีการย้ายเวอร์ชัน API: กระบวนการ v1 → v2 ทั้งหมด
- [examples/payment-api-design.md](examples/payment-api-design.md) — กรณี API บริการชำระเงิน: idempotency การคืนเงิน, state machine, การแจ้งเตือนแบบอะซิงโครนัส
- [examples/openapi-codegen-example.md](examples/openapi-codegen-example.md) — กรณีสร้างโค้ด OpenAPI: กลยุทธ์ Spec-first
- [examples/product-api-design.md](examples/product-api-design.md) — กรณี API บริการสินค้า
- [examples/inventory-api-design.md](examples/inventory-api-design.md) — กรณี API บริการสต็อก
- [examples/notification-api-design.md](examples/notification-api-design.md) — กรณี API บริการแจ้งเตือน
- [examples/search-api-design.md](examples/search-api-design.md) — กรณี API บริการค้นหา

---

## 🧭 DDD Skills Journey

> 📍 **ปัจจุบัน: `ddd-api-designer` — Step 4: การออกแบบ API และการแปลงข้อมูล**

```
Step 1 (awesome) → Step 2 (selector) → Step 3 (สถาปัตยกรรมลงมือ) → Step 4 (โดเมน+CQRS+API) → Step 5 (ตรวจสอบ) → Step 6 (เสริม) → Step 7 (เอกสาร)
                                                                    ↑
                                         ⭐ ddd-api-designer: โดเมนโมเดล → REST API
```

**← สถานีก่อนหน้า**: ส่งต่อให้สกิล **`ddd-domain-designer`** — มีโดเมนโมเดลก่อนแล้วค่อยออกแบบ API (ติดตั้ง: `npx skills add full-stack-skills/ddd-skills --skill ddd-domain-designer`)
**→ สถานีถัดไป**: ส่งต่อให้สกิล **`ddd-code-reviewer`** — ตรวจสอบความสอดคล้องของการออกแบบ API (ติดตั้ง: `npx skills add full-stack-skills/ddd-skills --skill ddd-code-reviewer`)
**🔗 ที่เกี่ยวข้อง**: ส่งต่อให้สกิล **`ddd-cqrs-architecture`** — CQRS เชิงลึก (ติดตั้ง: `npx skills add full-stack-skills/ddd-skills --skill ddd-cqrs-architecture`) | สกิล **`ddd-architecture-doc`** — ส่งออกเอกสาร OpenAPI (ติดตั้ง: `npx skills add full-stack-skills/ddd-skills --skill ddd-architecture-doc`)

> หลักการสำคัญ: Command และ Query ออกแบบแยกกัน จำสายการแปลงสี่ชั้น PO→DO→DTO→VO ให้แม่น DTO แยกจาก domain object, VO แยกจากโครงสร้างฐานข้อมูล