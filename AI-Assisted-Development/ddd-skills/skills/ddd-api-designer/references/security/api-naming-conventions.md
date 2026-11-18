# มาตรฐานการตั้งชื่อ Endpoint API และออบเจ็กต์ข้อมูล

## Command API (การดำเนินการเขียน)

```
POST   /api/v1/orders                 # สร้างคำสั่งซื้อ
PUT    /api/v1/orders/{id}/confirm     # ยืนยันคำสั่งซื้อ
DELETE /api/v1/orders/{id}             # ยกเลิกคำสั่งซื้อ

กฎการตั้งชื่อ:
- ใช้คำนามพหูพจน์ (/orders ไม่ใช่ /order)
- การดำเนินการเขียนใช้คำกริยาต่อท้าย (confirm, cancel, approve, ship)
- หลีกเลี่ยงการซ้อนลึก (สูงสุด 2 ชั้น: /orders/{id}/items)
```

## Query API (การดำเนินการอ่าน)

```
GET    /api/v1/orders/{id}             # รายละเอียดคำสั่งซื้อ
GET    /api/v1/orders?status=PAID      # รายการคำสั่งซื้อ
GET    /api/v1/orders/{id}/items       # รายการสินค้าในคำสั่งซื้อ

กฎการตั้งชื่อ:
- ตั้งชื่อตามทรัพยากร
- พารามิเตอร์ค้นหา: ?status=PAID&page=1&size=20
- หลีกเลี่ยงคำกริยา: GET /getOrders ✗  → GET /orders ✓
```

## การเทียบเคียง Endpoint อ่าน/เขียนแบบ CQRS

```
Command (เขียน):
  POST   /orders             → CreateOrderCommand
  PUT    /orders/{id}/confirm → ConfirmOrderCommand
  DELETE /orders/{id}        → CancelOrderCommand

Query (อ่าน):
  GET /orders/{id}           → OrderDetailDTO (Materialized View)
  GET /orders?status=PAID    → OrderSummaryDTO[] (Read Model)
```

## มาตรฐานรหัสข้อผิดพลาด

| รหัส | สถานะ HTTP | ความหมาย | ลองใหม่ได้ |
|:--:|:--:|------|:--:|
| 0 | 200/201 | สำเร็จ | — |
| 40001 | 400 | OrderStatus ไม่อนุญาตให้ชำระเงิน | ไม่ได้ |
| 40002 | 400 | การตรวจสอบพารามิเตอร์ล้มเหลว | ไม่ได้ |
| 40401 | 404 | ไม่พบ Aggregate | ไม่ได้ |
| 40901 | 409 | ความขัดแย้งแบบพร้อมกัน (optimistic lock) | ได้ |
| 50000 | 500 | ข้อผิดพลาดภายในระบบ | ได้ |

## มาตรฐานฟิลด์สัญญาเหตุการณ์

เหตุการณ์โดเมนทุกตัวต้องประกอบด้วย:
- `eventId`: UUID, ไม่ซ้ำทั่วโลก
- `eventType`: ประเภทเหตุการณ์ เช่น `order.paid`
- `aggregateId`: ID ของ Aggregate ต้นทาง
- `occurredAt`: timestamp ที่เกิด
- `schemaVersion`: หมายเลขเวอร์ชัน schema
- `correlationId`: ID ที่เกี่ยวข้อง (ติดตามข้ามบริการ)
- `payload`: ข้อมูลทางธุรกิจ ซีเรียลไลซ์เป็น JSON

## กลยุทธ์ความเข้ากันได้ของเวอร์ชันเหตุการณ์

| กลยุทธ์ | วิธีการ | เหมาะสมกับ |
|------|------|------|
| เพิ่มฟิลด์เท่านั้น | ฟิลด์ใหม่ตั้งค่าเริ่มต้น | การอัปเกรดที่เข้ากันได้ |
| อัปเกรดเวอร์ชันหลัก | topic ใหม่ + เก็บ topic เก่าไว้ | ลายเซ็น API เปลี่ยนแปลง |
| การเขียนคู่ในช่วงเปลี่ยนผ่าน | เผยแพร่ v1 + v2 พร้อมกัน หลังจากผู้บริโภคอัปเกรดแล้วจึงปิด v1 | การย้ายที่ราบรื่น |

## รูปแบบการตอบกลับแบบรวม

```json
// สำเร็จ (รายการเดียว)
{ "code": 0, "message": "success", "data": { "id": "...", "status": "PAID" } }

// สำเร็จ (แบ่งหน้า)
{ "code": 0, "message": "success", "data": { "records": [...], "total": 100, "page": 1, "pageSize": 20 } }

// ข้อผิดพลาด
{ "code": 40001, "message": "สถานะคำสั่งซื้อไม่อนุญาตให้ชำระเงิน", "detail": "ปัจจุบัน: CANCELLED，ชำระได้: DRAFT" }

// ข้อผิดพลาดการตรวจสอบ
{ "code": 40002, "message": "การตรวจสอบพารามิเตอร์ล้มเหลว", "detail": [{ "field": "amount", "message": "จำนวนเงินต้องไม่เป็นค่าลบ" }] }
```