# ข้อกำหนดรูปแบบการตอบกลับแบบรวม

## การออกแบบหลัก

ทุกการตอบกลับ API ใช้รูปแบบ envelope เดียวกัน (`Result<T>`):

```json
{
  "code": 0,
  "message": "success",
  "data": { /* type-specific payload */ },
  "requestId": "req-abc123",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

## คำจำกัดความประเภทการตอบกลับ

### การตอบกลับสำเร็จ: ออบเจ็กต์เดียว

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "orderId": "ORD-2024-001",
    "status": "PAID",
    "totalAmount": "99.00",
    "items": [
      { "itemId": "ITEM-001", "productName": "T-Shirt", "quantity": 2, "price": "49.50" }
    ]
  },
  "requestId": "req-abc123"
}
```

### การตอบกลับสำเร็จ: รายการแบบแบ่งหน้า

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "records": [
      { "orderId": "ORD-2024-001", "status": "PAID", "totalAmount": "99.00" },
      { "orderId": "ORD-2024-002", "status": "DRAFT", "totalAmount": "150.00" }
    ],
    "total": 100,
    "page": 1,
    "pageSize": 20,
    "totalPages": 5
  },
  "requestId": "req-abc123"
}
```

### การตอบกลับสำเร็จ: ไม่มีเนื้อหา (204)

```http
HTTP/1.1 204 No Content
Content-Length: 0
```

ใช้สำหรับการดำเนินการ DELETE — ไม่มี body ของการตอบกลับ

### การตอบกลับข้อผิดพลาด: ข้อผิดพลาดทางธุรกิจ

```json
{  
  "code": 40001,
  "message": "สถานะคำสั่งซื้อไม่อนุญาตให้ชำระเงิน",
  "detail": "สถานะปัจจุบัน：CANCELLED，สถานะการชำระเงิน：DRAFT",
  "requestId": "req-abc123",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

### การตอบกลับข้อผิดพลาด: ข้อผิดพลาดการตรวจสอบ

```json
{
  "code": 40002,
  "message": "การตรวจสอบพารามิเตอร์ล้มเหลว",
  "detail": [
    { "field": "amount", "message": "จำนวนเงินต้องไม่ติดลบ" },
    { "field": "customerId", "message": "รหัสลูกค้าต้องไม่ว่างเปล่า" },
    { "field": "items", "message": "รายการสั่งซื้อต้องไม่ว่างเปล่า" }
  ],
  "requestId": "req-abc123"
}
```

### การตอบกลับข้อผิดพลาด: ไม่พบ

```json
{
  "code": 40401,
  "message": "ไม่พบคำสั่งซื้อ",
  "detail": "orderId: ORD-2024-999",
  "requestId": "req-abc123"
}
```

### การตอบกลับข้อผิดพลาด: ความขัดแย้ง / การแก้ไขพร้อมกัน

```json
{
  "code": 40901,
  "message": "ข้อมูลดังกล่าวได้รับการแก้ไขโดยการดำเนินการอื่นๆ แล้ว",
  "detail": "เวอร์ชันที่คาดหวัง: 3, เวอร์ชันปัจจุบัน: 5",
  "requestId": "req-abc123"
}
```

### การตอบกลับข้อผิดพลาด: ข้อผิดพลาดของระบบ (500)

```json
{
  "code": 50000,
  "message": "ข้อผิดพลาดภายในระบบ",
  "requestId": "req-abc123"
}
```

## ระบบรหัสข้อผิดพลาด

### การจัดสรรช่วงรหัส

| ช่วงรหัส | หมวดหมู่ | สถานะ HTTP | คำอธิบาย |
|:----------:|----------|:-----------:|-------------|
| 0 | สำเร็จ | 200/201 | สำเร็จ |
| 40001-40099 | การละเมิดกฎทางธุรกิจ | 400 | กฎของโดเมนป้องกันการดำเนินการ |
| 40100-40199 | การยืนยันตัวตน | 401 | ข้อมูลรับรองหายไปหรือไม่ถูกต้อง |
| 40300-40399 | การอนุญาต | 403 | สิทธิ์ไม่เพียงพอ |
| 40401-40499 | ไม่พบ | 404 | ไม่พบทรัพยากร |
| 40901-40999 | ความขัดแย้ง | 409 | Optimistic lock / ซ้ำ |
| 41201-41299 | เงื่อนไขเบื้องต้นล้มเหลว | 412 | เวอร์ชันไม่ตรงกัน |
| 42901-42999 | การจำกัดอัตรา | 429 | คำขอมากเกินไป |
| 50000-50099 | ข้อผิดพลาดของระบบ | 500 | ข้อผิดพลาดภายในที่ไม่คาดคิด |
| 50301-50399 | บริการไม่พร้อมใช้งาน | 503 | บริการปลายทางไม่พร้อมใช้งาน |

### หลักการตั้งชื่อรหัส

```
XXYYY
│└── หมายเลขข้อผิดพลาดเฉพาะ (001-999)
└── หมวดหมู่:
    0  = สำเร็จ
    40 = ข้อผิดพลาดฝั่งไคลเอนต์ (4xx)
    41 = การยืนยันตัวตน (401)
    43 = ถูกห้าม (403)
    44 = ไม่พบ (404)
    49 = ความขัดแย้ง (409)
    42 = การจำกัดอัตรา (429)
    50 = ข้อผิดพลาดเซิร์ฟเวอร์ (500)
    53 = บริการไม่พร้อมใช้งาน (503)
```

## การนำ Response Wrapper ไปใช้

### Java

```java
public class Result<T> {
    private int code;
    private String message;
    private T data;
    private String detail;
    private String requestId;
    private String timestamp;

    // Success
    public static <T> Result<T> success(T data) {
        return new Result<>(0, "success", data, null, null, now());
    }

    // Error with detail
    public static <T> Result<T> error(int code, String message, Object detail) {
        return new Result<>(code, message, null, detail, null, now());
    }

    // System error with requestId
    public static <T> Result<T> systemError(String requestId) {
        return new Result<>(50000, "ข้อผิดพลาดภายในระบบ", null, null, requestId, now());
    }
}
```

### TypeScript

```typescript
interface ApiResponse<T> {
  code: number;
  message: string;
  data?: T;
  detail?: any;
  requestId: string;
  timestamp: string;
}

interface PaginatedData<T> {
  records: T[];
  total: number;
  page: number;
  pageSize: number;
  totalPages: number;
}

// Usage
type OrderListResponse = ApiResponse<PaginatedData<OrderSummary>>;
type OrderDetailResponse = ApiResponse<OrderDetail>;
```

## กลยุทธ์การจัดการข้อยกเว้น

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(BusinessException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<?> handleBusiness(BusinessException e) {
        return Result.error(e.getCode(), e.getMessage(), e.getDetail());
    }

    @ExceptionHandler(ValidationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<?> handleValidation(ValidationException e) {
        return Result.error(40002, "การตรวจสอบพารามิเตอร์ล้มเหลว", e.getErrors());
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public Result<?> handleNotFound(ResourceNotFoundException e) {
        return Result.error(40401, e.getMessage(), e.getResourceId());
    }

    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public Result<?> handleSystem(Exception e, HttpServletRequest request) {
        log.error("System error", e);
        return Result.systemError(request.getAttribute("requestId").toString());
    }
}
```

## แนวทางปฏิบัติ

1. **ห่อการตอบกลับเสมอ**: การตอบกลับ API ทั้งหมดใช้ envelope `Result<T>` ยกเว้นเฉพาะ health check และการดาวน์โหลดไฟล์
2. **รหัสข้อผิดพลาดสอดคล้องกัน**: ข้อผิดพลาดเดียวกันใน endpoint ต่างๆ ส่งคืนรหัสเดียวกัน ห้ามใช้รหัสซ้ำข้ามประเภทข้อผิดพลาดที่แตกต่างกัน
3. **ไม่มี stack trace**: การตอบกลับข้อผิดพลาดไม่รวม stack trace ใช้ `requestId` สำหรับการเชื่อมโยง log ฝั่งเซิร์ฟเวอร์
4. **รวม requestId**: ทุกการตอบกลับมี requestId สำหรับ debug แนบกับ log เพื่อการติดตาม
5. ** timestamp รูปแบบ ISO 8601**: ค่า datetime ทั้งหมดใช้รูปแบบ ISO 8601 พร้อม timezone
6. **หลีกเลี่ยง null ใน data**: หากไม่มีข้อมูล ให้ละเว้นฟิลด์ `data` ทั้งหมด หรือส่งคืนออบเจ็กต์ว่าง `{}`