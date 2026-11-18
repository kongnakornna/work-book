# การออกแบบการแบ่งหน้าและการกรองของ API

## การเปรียบเทียบแนวทางการแบ่งหน้า

| แนวทาง | หลักการ | ข้อดี | ข้อเสีย | เหมาะสมกับ |
|------|------|------|------|------|
| **Offset/Page** | `?page=1&size=20` | implement ง่าย, กระโดดหน้าแบบสุ่มได้ | ประสิทธิภาพแย่เมื่อแบ่งหน้าลึก, ข้อมูลคลาดเคลื่อน | หลังบ้านจัดการ, ชุดข้อมูลเล็ก |
| **Cursor** | `?cursor=eyJpZCI6MTAwfQ==&limit=20` | ประสิทธิภาพเสถียร, ข้อมูลเรียลไทม์แม่นยำ | กระโดดหน้าแบบสุ่มไม่ได้ | รายการฝั่งผู้ใช้, ข้อมูลเรียลไทม์ |
| **Keyset** | `?after_id=100&limit=20` | ประสิทธิภาพเร็วที่สุด (ใช้ index) | กระโดดหน้าไม่ได้, การเรียงลำดับจำกัด | สถานการณ์ที่เรียงตาม ID เท่านั้น |
| **Seek** | `?offset_id=100&size=20` | Keyset + การเรียงลำดับที่ยืดหยุ่น | implement ซับซ้อนเล็กน้อย | Feeds โซเชียลมีเดีย |

### แนวทางที่แนะนำ

- **ฝั่งจัดการ**: แบ่งหน้าแบบ Offset/Page (ต้องการฟังก์ชันกระโดดหน้า)
- **ฝั่งผู้ใช้**: แบ่งหน้าแบบ Cursor (สถานการณ์ข้อมูลเรียลไทม์)
- **ข้อมูลปริมาณมาก**: แบ่งหน้าแบบ Keyset/Seek (หลีกเลี่ยงประสิทธิภาพที่ลดลงจาก offset)

## ข้อกำหนดการแบ่งหน้าแบบ Offset/Page

### พารามิเตอร์คำขอ

```
GET /api/v1/orders?page=1&size=20&sort=createdAt,desc
```

| พารามิเตอร์ | ค่าเริ่มต้น | คำอธิบาย |
|------|--------|------|
| `page` | 1 | หมายเลขหน้า เริ่มจาก 1 |
| `size` | 20 | จำนวนรายการต่อหน้า สูงสุด 100 |
| `sort` | createdAt,desc | ฟิลด์และทิศทางการเรียงลำดับ |

### รูปแบบการตอบกลับ

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "records": [
      { "orderId": "ORD-2024-001", "status": "PAID", "totalAmount": "99.00" }
    ],
    "total": 100,
    "page": 1,
    "pageSize": 20,
    "totalPages": 5
  }
}
```

### การ implement

```java
public class PageRequest {
    private int page = 1;        // หมายเลขหน้า เริ่มจาก 1
    private int size = 20;       // จำนวนรายการต่อหน้า
    private String sort;         // การเรียงลำดับ: createdAt,desc

    public long getOffset() {
        return (long) (page - 1) * size;
    }

    public Sort getSort() {
        // แยกวิเคราะห์พารามิเตอร์ sort → ออบเจ็กต์ Spring Sort
    }
}

public class PageResult<T> {
    private List<T> records;
    private long total;
    private int page;
    private int pageSize;
    private int totalPages;

    public static <T> PageResult<T> of(List<T> records, long total, PageRequest request) {
        PageResult<T> result = new PageResult<>();
        result.records = records;
        result.total = total;
        result.page = request.getPage();
        result.pageSize = request.getSize();
        result.totalPages = (int) Math.ceil((double) total / request.getSize());
        return result;
    }
}
```

## ข้อกำหนดการแบ่งหน้าแบบ Cursor

### พารามิเตอร์คำขอ

```
GET /api/v1/orders?cursor=eyJjcmVhdGVkQXQiOiIyMDI0LTAxLTE1VDEwOjMwOjAwWiIsImlkIjoiT1JELTIwMjQtMDEwIn0=&limit=20
```

| พารามิเตอร์ | ค่าเริ่มต้น | คำอธิบาย |
|------|--------|------|
| `cursor` | ไม่มี | ตัวระบุที่เข้ารหัสของรายการสุดท้ายในหน้าก่อนหน้า |
| `limit` | 20 | จำนวนรายการต่อหน้า |
| `sort` | createdAt,desc | การเรียงลำดับ (ต้องสอดคล้องกับการเข้ารหัส cursor) |

### รูปแบบการตอบกลับ

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "records": [
      { "orderId": "ORD-2024-011", "status": "PAID", "createdAt": "2024-01-16T10:30:00Z" }
    ],
    "nextCursor": "eyJjcmVhdGVkQXQiOiIyMDI0LTAxLTE2VDEwOjMwOjAwWiIsImlkIjoiT1JELTIwMjQtMDExIn0=",
    "hasMore": true
  }
}
```

### การ implement การเข้ารหัส Cursor

```java
public class CursorCodec {
    private static final ObjectMapper mapper = new ObjectMapper();

    // เข้ารหัสออบเจ็กต์ cursor เป็น Base64
    public static String encode(Map<String, Object> cursorFields) {
        try {
            return Base64.getUrlEncoder().encodeToString(
                mapper.writeValueAsString(cursorFields).getBytes());
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Cursor encode failed", e);
        }
    }

    // ถอดรหัส cursor
    public static Map<String, Object> decode(String cursor) {
        try {
            byte[] bytes = Base64.getUrlDecoder().decode(cursor);
            return mapper.readValue(bytes, Map.class);
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid cursor", e);
        }
    }
}
```

## การออกแบบการกรอง

### การกรองพื้นฐาน

```
GET /api/v1/orders?status=PAID&customerId=USR-001
GET /api/v1/orders?status=PAID,SHIPPED          # การกรองหลายค่า (คั่นด้วยเครื่องหมายจุลภาค)
GET /api/v1/orders?createdAtFrom=2024-01-01&createdAtTo=2024-01-31  # การกรองช่วง
```

### การกรองขั้นสูง (การค้นหาที่ซับซ้อน)

```json
// POST /api/v1/orders/search
{
  "filters": [
    { "field": "status", "operator": "in", "value": ["PAID", "SHIPPED"] },
    { "field": "totalAmount", "operator": "gte", "value": 100 },
    { "field": "createdAt", "operator": "between", "value": ["2024-01-01", "2024-01-31"] }
  ],
  "sort": { "field": "createdAt", "order": "desc" },
  "page": { "page": 1, "size": 20 }
}
```

| ตัวดำเนินการ | คำอธิบาย | SQL ที่สอดคล้อง |
|--------|------|---------|
| `eq` | เท่ากับ | `=` |
| `neq` | ไม่เท่ากับ | `!=` |
| `in` | อยู่ใน | `IN` |
| `nin` | ไม่อยู่ใน | `NOT IN` |
| `gt` / `gte` | มากกว่า / มากกว่าหรือเท่ากับ | `>` / `>=` |
| `lt` / `lte` | น้อยกว่า / น้อยกว่าหรือเท่ากับ | `<` / `<=` |
| `between` | ช่วง | `BETWEEN` |
| `like` | ค้นหาแบบคลุมเครือ | `LIKE` |
| `contains` | ประกอบด้วย (array/string) | `@>` / `LIKE %...%` |

## การเลือกฟิลด์

อนุญาตให้ไคลเอนต์ขอเฉพาะฟิลด์ที่ต้องการ ลดปริมาณการถ่ายโอน:

```
GET /api/v1/orders?fields=orderId,status,totalAmount
```

```json
{
  "data": {
    "orderId": "ORD-2024-001",
    "status": "PAID",
    "totalAmount": "99.00"
  }
}
```

## แนวทางปฏิบัติที่ดีที่สุดสำหรับการแบ่งหน้า

1. **รูปแบบการแบ่งหน้าสม่ำเสมอ**: อินเทอร์เฟซรายการทั้งหมดใช้โครงสร้างการตอบกลับการแบ่งหน้าเดียวกัน (records/total/page/pageSize)
2. **จำกัด size สูงสุด**: `size` สูงสุด 100 เพื่อป้องกันการค้นหาขนาดใหญ่ทำให้ฐานข้อมูลล่ม
3. **ปรับปรุงการแบ่งหน้าลึก**: เมื่อ offset เกิน 10000 รายการ แนะนำให้เปลี่ยนไปใช้ Cursor หรือ Keyset
4. **แคชจำนวนรายการทั้งหมด**: `total` สามารถใช้แคชได้ ลดการค้นหา COUNT
5. **เพิ่ม index ให้ฟิลด์เรียงลำดับ**: `ORDER BY createdAt` ต้องมี index ที่สอดคล้อง
6. **แยก endpoint สำหรับการค้นหา**: การค้นหาที่ซับซ้อนใช้ endpoint เฉพาะ `POST /search` ไม่ปนกับ GET query
7. **การเรียงลำดับเริ่มต้น**: ให้การเรียงลำดับเริ่มต้นเสมอ เพื่อหลีกเลี่ยงผลลัพธ์การแบ่งหน้าที่ไม่เสถียร