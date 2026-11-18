# การออกแบบ API แบบ Idempotent

## ทำไมต้องมี Idempotent

ในระบบแบบกระจาย (distributed system) การหมดเวลาเครือข่าย (network timeout), การลองใหม่ของไคลเอนต์ (client retry), การบริโภคข้อความซ้ำจาก MQ (MQ duplicate consumption) ล้วนทำให้คำขอเดียวกันถูกดำเนินการหลายครั้ง การออกแบบแบบ idempotent ช่วยให้แน่ใจว่าคำขอที่ซ้ำกันไม่ก่อให้เกิดผลข้างเคียง (side effect)

### การดำเนินการใดบ้างที่ต้อง idempotent

| เมธอด | idempotent โดยธรรมชาติ? | คำอธิบาย |
|------|:----------:|------|
| GET | ✅ | ไม่แก้ไขสถานะ |
| PUT | ✅ | แทนที่ทั้งหมด ผลลัพธ์เหมือนกันเมื่อทำหลายครั้ง |
| DELETE | ✅ | การลบทรัพยากรที่ถูกลบแล้วให้ผลลัพธ์เหมือนเดิม |
| POST | ❌ | ทุกครั้งที่ทำจะสร้างทรัพยากรใหม่ ต้องจัดการแบบ idempotent |

## สี่แนวทางการทำให้เป็น idempotent

### 1. คีย์ idempotent (Idempotency-Key) — แนะนำที่สุด

ไคลเอนต์ส่งคีย์ที่ไม่ซ้ำกันใน header คำขอ เซิร์ฟเวอร์แคชผลลัพธ์เพื่อ deduplicate

```yaml
POST /api/v1/orders
Idempotency-Key: 550e8400-e29b-41d4-a716-446655440000
```

**ขั้นตอน**:

```
คำขอมาถึง → ค้นหาแคช (key → result)
  ├── พบ → ส่งคืนผลลัพธ์ที่แคชไว้ทันที (200 OK)
  └── ไม่พบ → ดำเนินการ logic ธุรกิจ → เก็บ (key, result) → ส่งคืนผลลัพธ์
```

**ข้อควรระวัง**:
- TTL ของแคชต้องเกินหน้าต่างการลองใหม่สูงสุด (แนะนำ 24 ชม.)
- ใช้ Redis + TTL ในการ implement
- พื้นที่คีย์ idempotent ควรใหญ่พอ (UUID v4)
- ผลลัพธ์ของคีย์ idempotent ต้องไม่เปลี่ยนแปลง: สำเร็จครั้งแรก → ส่งคืนสำเร็จตลอดไป; ล้มเหลวครั้งแรก → การลองใหม่ครั้งต่อไปดำเนินการต่อ (เมื่อธุรกิจมีสถานะต้องใช้ร่วมกับ state machine)

```java
public class IdempotencyFilter implements Filter {
    private final RedisTemplate<String, String> redis;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {
        HttpServletRequest req = (HttpServletRequest) request;
        String idempotencyKey = req.getHeader("Idempotency-Key");

        if (idempotencyKey != null && "POST".equalsIgnoreCase(req.getMethod())) {
            String cached = redis.opsForValue().get("idempotent:" + idempotencyKey);
            if (cached != null) {
                // ส่งคืนผลลัพธ์ที่แคชไว้
                response.getWriter().write(cached);
                return;
            }
        }
        chain.doFilter(request, response);
    }
}
```

### 2. ดัชนีเฉพาะทางธุรกิจ — ง่ายและเชื่อถือได้

ใช้ข้อจำกัด unique ของฐานข้อมูลเพื่อป้องกันการซ้ำ:

```sql
-- ข้อจำกัด unique ของหมายเลขคำสั่งซื้อ
ALTER TABLE orders ADD UNIQUE INDEX uk_order_no (order_no);
```

```java
try {
    orderRepository.save(order);
} catch (DuplicateKeyException e) {
    // หมายเลขคำสั่งซื้อซ้ำ → ส่งคืนข้อมูลคำสั่งซื้อที่สร้างแล้ว
    return orderRepository.findByOrderNo(order.getOrderNo());
}
```

### 3. State Machine — ป้องกันการทำซ้ำ

สถานะทางธุรกิจมีเส้นทางการเปลี่ยนที่ชัดเจน สถานะที่ประมวลผลแล้วไม่สามารถกระตุ้นซ้ำได้:

```java
public class Order {
    private OrderStatus status;

    public void confirm() {
        if (this.status != OrderStatus.DRAFT) {
            // DRAFT → CONFIRMED อนุญาตเพียงครั้งเดียว
            throw new BusinessException(40001, "สถานะปัจจุบันไม่อนุญาตให้ยืนยัน",
                "ปัจจุบัน: " + this.status + "，ต้องการ: DRAFT");
        }
        this.status = OrderStatus.CONFIRMED;
    }

    public void pay() {
        if (this.status != OrderStatus.CONFIRMED) {
            throw new BusinessException(40001, "สถานะปัจจุบันไม่อนุญาตให้ชำระเงิน");
        }
        this.status = OrderStatus.PAID;
    }
}
```

### 4. Idempotent ทางธุรกิจ (Optimistic Lock) — ไม่มีที่เก็บเพิ่มเติม

ใช้การอัปเดตแบบมีเงื่อนไขของฐานข้อมูล:

```sql
-- หักสต็อก: stock >= 1 เพื่อให้แน่ใจว่าจะไม่ขายเกิน
UPDATE product SET stock = stock - 1 WHERE id = ? AND stock >= 1;

-- หมายเลขเวอร์ชัน optimistic lock
UPDATE orders SET status = 'PAID', version = version + 1
WHERE id = ? AND version = ?;
```

## เมทริกซ์การเลือกกลยุทธ์ idempotent

| สถานการณ์ | แนวทางที่แนะนำ |
|------|---------|
| สร้างคำสั่งซื้อ (POST) | คีย์ idempotent + ดัชนี unique ของหมายเลขคำสั่งซื้อ |
| Callback การชำระเงิน | ดัชนีเฉพาะทางธุรกิจ (หมายเลขคำสั่งชำระเงิน) |
| เปลี่ยนสถานะ (PUT) | State machine + optimistic lock |
| หักสต็อก | การอัปเดตแบบมีเงื่อนไข (stock >= n) |
| การบริโภคข้อความ MQ | คีย์ idempotent ของ ID ข้อความ + ตาราง deduplication |

## แนวทางปฏิบัติที่ดีที่สุดสำหรับคีย์ idempotent

1. **คีย์ idempotent สร้างโดยไคลเอนต์**: UUID v4 เพื่อให้แน่ใจว่าไม่ซ้ำ
2. **ขอบเขตของคีย์ idempotent**: แยกตาม (key, endpoint) endpoint ต่างๆ สามารถใช้ key เดียวกันได้
3. **แคชผลลัพธ์ไม่เปลี่ยนแปลง**: สำเร็จครั้งแรก → ส่งคืนผลลัพธ์สำเร็จตลอดไป
4. **การออกแบบ TTL**: อย่างน้อย 24 ชม. สูงสุด 7 วัน (ขึ้นอยู่กับหน้าต่างการลองใหม่ของธุรกิจ)
5. **ขนาดคีย์ idempotent**: แนะนำภายใน 64 ไบต์ เนื่องจากเป็น Redis key ต้องควบคุมความยาว

## การนิยามคีย์ idempotent ใน OpenAPI

```yaml
paths:
  /orders:
    post:
      parameters:
        - name: Idempotency-Key
          in: header
          required: false
          schema:
            type: string
            format: uuid
          description: คีย์ idempotent ฝั่งไคลเอนต์ ป้องกันการสร้างซ้ำ
      responses:
        '201':
          description: สร้างครั้งแรก
        '200':
          description: ส่งคืนแบบ idempotent (คำขอซ้ำใช้คีย์ idempotent เดียวกัน)
          headers:
            Idempotent-Replayed:
              schema:
                type: boolean
              description: ระบุว่าการตอบกลับนี้เป็นผลลัพธ์ที่เล่นซ้ำ
```