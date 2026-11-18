# กรณีศึกษาการย้ายเวอร์ชัน API: v1 → v2

> แสดงกระบวนการย้ายเวอร์ชัน API จาก v1 ไป v2 อย่างครบถ้วน รวมถึงการวิเคราะห์การเปลี่ยนแปลง กลยุทธ์ความเข้ากันได้ และความแตกต่างของ OpenAPI

## ความเป็นมา

API บริการคำสั่งซื้อ v1 ทำงานมา 1 ปีแล้ว ทีมผลิตภัณฑ์ต้องการเพิ่มฟีเจอร์ต่อไปนี้:
1. รองรับหลายสกุลเงิน (เดิมมีเฉพาะหยวน)
2. รายการคำสั่งซื้อต้องแยกแสดงผล
3. เพิ่มมาตรฐานการแบ่งหน้า

การเปลี่ยนแปลงเหล่านี้เกี่ยวข้องกับการเปลี่ยนฟิลด์ใน response body ไม่เข้ากันกับ v1 จึงจำเป็นต้องมี v2

## การวิเคราะห์การเปลี่ยนแปลง

| รายการเปลี่ยนแปลง | ประเภท | v1 | v2 |
|--------|------|----|----|
| ชื่อฟิลด์ ID | เปลี่ยนชื่อ | `id` (int) | `orderId` (string) |
| รูปแบบจำนวนเงิน | เปลี่ยนชนิด | `amount` (number) | `totalAmount` (string) + `currency` |
| รายการคำสั่งซื้อ | เพิ่มใหม่ | ไม่มีลิสต์แยก | `items` array |
| การห่อ response | เปลี่ยนโครงสร้าง | ข้อมูลดิบ | ห่อด้วย `Result<T>` |
| การแบ่งหน้า | มาตรฐาน | ไม่มีมาตรฐานการแบ่งหน้า | `page/size/total/records` |

## v1 endpoint

### v1 OpenAPI

```yaml
openapi: 3.0.3
info:
  title: Order Service API
  version: 1.0.0
servers:
  - url: https://api.example.com/api/v1

paths:
  /orders:
    get:
      summary: List orders
      parameters:
        - name: status
          in: query
          schema:
            type: string
      responses:
        '200':
          description: Order list
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/OrderV1'
    post:
      summary: Create order
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateOrderRequestV1'
      responses:
        '201':
          description: Created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderV1'

components:
  schemas:
    OrderV1:
      type: object
      properties:
        id:
          type: integer
          example: 1
        status:
          type: string
          example: PAID
        amount:
          type: number
          example: 99.00

    CreateOrderRequestV1:
      type: object
      properties:
        customer_id:
          type: integer
        items:
          type: array
          items:
            type: object
            properties:
              product_id:
                type: integer
              quantity:
                type: integer
```

### ตัวอย่างการตอบกลับ v1

```json
// GET /api/v1/orders?status=PAID
[
  {
    "id": 1,
    "status": "PAID",
    "amount": 99.00
  },
  {
    "id": 2,
    "status": "PAID",
    "amount": 199.00
  }
]

// POST /api/v1/orders
{
  "id": 3,
  "status": "DRAFT",
  "amount": 299.00
}
```

## v2 endpoint

### v2 OpenAPI

```yaml
openapi: 3.0.3
info:
  title: Order Service API
  version: 2.0.0
servers:
  - url: https://api.example.com/api/v2

paths:
  /orders:
    get:
      summary: List orders with pagination
      parameters:
        - name: status
          in: query
          schema:
            type: string
            enum: [DRAFT, PAID, SHIPPED, CANCELLED]
        - name: page
          in: query
          schema:
            type: integer
            default: 1
        - name: size
          in: query
          schema:
            type: integer
            default: 20
      responses:
        '200':
          description: Paginated order list
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderListResponseV2'
    post:
      summary: Create order
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateOrderRequestV2'
      responses:
        '201':
          description: Created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApiResponse'

components:
  schemas:
    OrderV2:
      type: object
      properties:
        orderId:
          type: string
          example: ORD-2024-001
        status:
          type: string
          example: PAID
        totalAmount:
          type: string
          example: "99.00"
        currency:
          type: string
          example: CNY
        items:
          type: array
          items:
            $ref: '#/components/schemas/OrderItemV2'
        createdAt:
          type: string
          format: date-time

    OrderItemV2:
      type: object
      properties:
        productName:
          type: string
        quantity:
          type: integer
        unitPrice:
          type: string
        subtotal:
          type: string

    OrderListResponseV2:
      type: object
      properties:
        code:
          type: integer
          example: 0
        message:
          type: string
        data:
          type: object
          properties:
            records:
              type: array
              items:
                $ref: '#/components/schemas/OrderSummaryV2'
            total:
              type: integer
              example: 100
            page:
              type: integer
              example: 1
            pageSize:
              type: integer
              example: 20

    OrderSummaryV2:
      type: object
      properties:
        orderId:
          type: string
        status:
          type: string
        totalAmount:
          type: string
        itemCount:
          type: integer
        createdAt:
          type: string
          format: date-time

    ApiResponse:
      type: object
      properties:
        code:
          type: integer
          example: 0
        message:
          type: string
          example: success
        data:
          type: object

    CreateOrderRequestV2:
      type: object
      required: [customerId, items, currency]
      properties:
        customerId:
          type: string
        currency:
          type: string
          enum: [CNY, USD, EUR]
        items:
          type: array
          items:
            type: object
            properties:
              productId:
                type: string
              quantity:
                type: integer
```

### ตัวอย่างการตอบกลับ v2

```json
// GET /api/v2/orders?status=PAID&page=1
{
  "code": 0,
  "message": "success",
  "data": {
    "records": [
      {
        "orderId": "ORD-2024-001",
        "status": "PAID",
        "totalAmount": "99.00",
        "itemCount": 2,
        "currency": "CNY",
        "createdAt": "2024-01-15T10:30:00Z"
      }
    ],
    "total": 1,
    "page": 1,
    "pageSize": 20,
    "totalPages": 1
  }
}

// POST /api/v2/orders
{
  "code": 0,
  "message": "success",
  "data": {
    "orderId": "ORD-2024-003",
    "status": "DRAFT",
    "createdAt": "2024-01-16T14:00:00Z"
  }
}
```

## กลยุทธ์ความเข้ากันได้: การทำงานคู่ขนานสองเวอร์ชัน

### แนวทางการRouting

```
API Gateway:
  /api/v1/*  → Order Service v1 (deployment เก่า)
  /api/v2/*  → Order Service v2 (deployment ใหม่)

Internal routing:
  v1 service  → v1 DB schema
  v2 service  → v2 DB schema (migrated)
```

### ชั้น Adapter (การแปลงข้อมูล v1 → v2)

เมื่อผู้ใช้ v1 เรียก endpoint v2 จะแปลงผ่าน adapter:

```java
@Component
public class OrderV1ToV2Adapter {

    public OrderListResponseV2 adapt(List<OrderV1> v1Orders) {
        List<OrderSummaryV2> records = v1Orders.stream()
            .map(v1 -> new OrderSummaryV2(
                "ORD-" + v1.getId(),           // id → orderId
                v1.getStatus(),
                String.format("%.2f", v1.getAmount()),  // number → string
                0,                             // itemCount (v1 ไม่มี)
                null                           // createdAt (v1 ไม่มี timestamp)
            ))
            .collect(toList());

        return new OrderListResponseV2(
            0, "success",
            new PaginatedData<>(records, records.size(), 1, records.size(), 1)
        );
    }
}
```

## ไทม์ไลน์การย้าย

```
2024-Q1: ออกแบบ + พัฒนา v2
2024-Q2: เปิดตัว v2, v1 + v2 ทำงานคู่ขนาน
          └── แจ้งไคลเอนต์ v1 ทั้งหมดให้เริ่มย้าย
2024-Q3: ช่วงเลิกใช้ v1
          └── เพิ่ม Deprecated header ในการตอบกลับ v1
          └── ตรวจสอบปริมาณการใช้งาน v1
2024-Q4: ปิด v1
          └── endpoint v1 ส่งคืน 410 Gone
          └── ลบโค้ดและ deployment v1
```

## คู่มือการย้ายสำหรับไคลเอนต์

```markdown
# ย้ายไป Order API v2

## การเปลี่ยนแปลงสำคัญ

1. `id` → `orderId` (int → string)
2. การตอบกลับเปลี่ยนเป็นห่อด้วย Result<T>
3. การแบ่งหน้าเป็นมาตรฐาน records/page/size/total
4. จำนวนเงินเปลี่ยนเป็นรูปแบบสตริง "99.00" + เพิ่มฟิลด์ currency

## ขั้นตอนการย้าย

### Step 1: อัปเดต request
```diff
- POST /api/v1/orders
- { "customer_id": 1, "items": [...] }
+ POST /api/v2/orders
+ { "customerId": "USR-001", "currency": "CNY", "items": [...] }
```

### Step 2: อัปเดตการ parse response
```diff
- const orderId = response.id;
+ const orderId = response.data.orderId;
```

### Step 3: อัปเดตการจัดการการแบ่งหน้า
```diff
- const total = response.length;
+ const total = response.data.total;
+ const page = response.data.page;
```

## แผนสำรอง
หากพบปัญหาความเข้ากันได้ ให้สลับกลับไปใช้ endpoint /api/v1/ และรายงานปัญหา
v1 จะปิดให้บริการใน 2024-Q4
```