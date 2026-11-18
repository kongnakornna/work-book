# กรณีศึกษาการออกแบบ API ที่สมบูรณ์ของบริการชำระเงิน

> การออกแบบ REST API ของ Payment Bounded Context (Payment BC) แสดงสถานการณ์ทั่วไป เช่น idempotency, state machine, การ callback แบบอะซิงโครนัส

## โดเมนโมเดล

```
Payment (Aggregate Root)
├── PaymentId (ValueObject)
├── OrderId (ValueObject) — อ้างอิง Order Aggregate
├── PaymentStatus: UNPAID → PROCESSING → SUCCESS → REFUNDING → REFUNDED
│                                          ↘ FAILED
├── Money amount (ValueObject)
├── PaymentMethod (ValueObject): WECHAT_PAY / ALIPAY / CARD
├── PaymentChannel (Entity): บันทึกคำขอไปยังช่องทาง
│   ├── channelType
│   ├── channelOrderNo
│   └── channelStatus
└── List<PaymentEvent> (DomainEvent)
```

## 1. การออกแบบ Endpoint แบบ CQRS

### Command Endpoint (เขียน)

```
POST   /api/v1/payments                     → เริ่มชำระเงิน
POST   /api/v1/payments/{paymentId}/refund  → เริ่มคืนเงิน
PUT    /api/v1/payments/{paymentId}/cancel   → ยกเลิกการชำระเงิน

# Callback Endpoint (การแจ้งเตือนแบบอะซิงโครนัสจากบุคคลที่สาม)
POST   /api/v1/payments/callback/wechat      → Callback จาก WeChat Pay
POST   /api/v1/payments/callback/alipay      → Callback จาก Alipay
```

### Query Endpoint (อ่าน)

```
GET    /api/v1/payments/{paymentId}          → รายละเอียดการชำระเงิน
GET    /api/v1/payments/order/{orderId}      → รายการบันทึกการชำระเงินของคำสั่งซื้อ
```

## 2. การออกแบบ Idempotency

การออกแบบ idempotency ของ API การชำระเงินเป็นหัวใจสำคัญ: **ป้องกันการหักเงินซ้ำ**

### การใช้ Idempotency Key

```yaml
# เริ่มชำระเงิน — Idempotency Key ป้องกันคำขอชำระเงินซ้ำ
POST /api/v1/payments
Idempotency-Key: 550e8400-e29b-41d4-a716-446655440000
```

```java
@Service
public class PaymentService {
    private final PaymentRepository paymentRepository;
    private final IdempotencyService idempotencyService;

    public PaymentResult initiatePayment(CreatePaymentCommand command, String idempotencyKey) {
        // 1. ตรวจสอบ idempotency
        PaymentResult cached = idempotencyService.getCachedResult(idempotencyKey);
        if (cached != null) return cached;

        // 2. Idempotency ทางธุรกิจ: คำสั่งซื้อเดียวกันไม่สามารถเริ่มชำระเงินซ้ำได้
        paymentRepository.findByOrderId(command.orderId())
            .filter(p -> p.getStatus() != PaymentStatus.UNPAID)
            .ifPresent(p -> { throw new BusinessException(40001, "คำสั่งซื้อนี้ได้เริ่มชำระเงินแล้ว"); });

        // 3. ดำเนินการชำระเงิน
        Payment payment = Payment.create(command);
        PaymentResult result = paymentRepository.save(payment);

        // 4. แคชผลลัพธ์ idempotency
        idempotencyService.cacheResult(idempotencyKey, result);
        return result;
    }
}
```

### Idempotency ของการคืนเงิน

```java
public class Payment {
    public RefundRecord refund(Money amount, String reason) {
        // Idempotency ของ state machine: สถานะที่คืนเงินแล้วไม่สามารถคืนซ้ำได้
        if (this.status == PaymentStatus.REFUNDED) {
            throw new BusinessException(40001, "การชำระเงินนี้ได้คืนเงินเต็มจำนวนแล้ว");
        }
        // การคืนเงินบางส่วน: คำนวณยอดคงเหลือที่คืนได้
        Money refundable = this.amount.subtract(this.totalRefunded());
        if (amount.greaterThan(refundable)) {
            throw new BusinessException(40001, "ยอดคงเหลือที่คืนได้ไม่เพียงพอ",
                "คืนได้: " + refundable + "，ขอคืน: " + amount);
        }
        this.totalRefundedAmount = this.totalRefundedAmount.add(amount);
        if (this.totalRefundedAmount.equals(this.amount)) {
            this.status = PaymentStatus.REFUNDED;
        } else {
            this.status = PaymentStatus.REFUNDING;
        }
        addDomainEvent(new PaymentRefundedEvent(this.id, amount));
        return new RefundRecord(RefundId.generate(), amount, reason, LocalDateTime.now());
    }
}
```

## 3. การจัดการ Callback แบบอะซิงโครนัส

ข้อกำหนดในการจัดการการแจ้งเตือนแบบอะซิงโครนัส (Webhook) จากบุคคลที่สาม

### การออกแบบ Callback Endpoint

```java
@RestController
public class PaymentCallbackController {
    private final PaymentCallbackHandler callbackHandler;

    // Callback จาก WeChat Pay — จุดเข้าแบบรวม
    @PostMapping("/api/v1/payments/callback/wechat")
    public ResponseEntity<String> handleWechatCallback(@RequestBody String xmlBody,
                                                        @RequestHeader Map<String, String> headers) {
        // 1. ตรวจสอบลายเซ็น
        if (!WechatSignature.verify(xmlBody, headers)) {
            return ResponseEntity.status(401).body("signature verification failed");
        }

        // 2. จัดการ idempotency (ป้องกัน callback ซ้ำ)
        WechatNotify notify = WechatNotify.parse(xmlBody);
        return callbackHandler.handleCallback("WECHAT", notify.getOutTradeNo(), () -> {
            Payment payment = paymentRepository.findByOrderNo(notify.getOutTradeNo())
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found"));

            if (notify.isSuccess()) {
                payment.markSuccess(notify.getTransactionId(), notify.getPaidAt());
            } else {
                payment.markFailed(notify.getErrorCode());
            }
            paymentRepository.save(payment);
        });
    }

    // ส่งคืน "SUCCESS" เพื่อแจ้ง WeChat หยุด callback
    // ส่งคืนอย่างอื่น → WeChat จะลองใหม่ (สูงสุด 3 วัน)
}
```

### Callback Idempotency Handler

```java
@Service
public class PaymentCallbackHandler {

    public ResponseEntity<String> handleCallback(String channel, String outTradeNo,
                                                  Runnable businessLogic) {
        String lockKey = "callback:" + channel + ":" + outTradeNo;

        // Distributed lock ป้องกันการทำงานพร้อมกัน
        if (!redisLock.tryLock(lockKey, 30, TimeUnit.SECONDS)) {
            return ResponseEntity.ok("SUCCESS");  // เธรดอื่นกำลังประมวลผล
        }

        try {
            // Idempotency: callback ที่ประมวลผลแล้วจะไม่ทำซ้ำ
            if (redis.hasKey("callback:processed:" + outTradeNo)) {
                return ResponseEntity.ok("SUCCESS");
            }
            businessLogic.run();
            redis.set("callback:processed:" + outTradeNo, "1", 7, TimeUnit.DAYS);
            return ResponseEntity.ok("SUCCESS");

        } catch (Exception e) {
            log.error("Callback processing failed", e);
            return ResponseEntity.status(500).body("retry");
        } finally {
            redisLock.unlock(lockKey);
        }
    }
}
```

## 4. สายการแปลงออบเจ็กต์ข้อมูล

```
PaymentPO ↔ Payment (DO) ↔ PaymentDTO ↔ PaymentVO
```

### DO — Rich Model

```java
public class Payment extends AggregateRoot<PaymentId> {
    private PaymentId id;
    private OrderId orderId;
    private PaymentStatus status;
    private Money amount;
    private PaymentMethod method;
    private String channelOrderNo;    // หมายเลขคำสั่งซื้อของบุคคลที่สาม
    private Money totalRefundedAmount;

    // สร้างการชำระเงิน
    public static Payment create(OrderId orderId, Money amount, PaymentMethod method) {
        Payment payment = new Payment(PaymentId.generate(), orderId, amount, method);
        payment.status = PaymentStatus.UNPAID;
        payment.addDomainEvent(new PaymentInitiatedEvent(payment.id, orderId, amount));
        return payment;
    }

    // Callback การชำระเงินสำเร็จ
    public void markSuccess(String channelOrderNo, LocalDateTime paidAt) {
        if (this.status != PaymentStatus.PROCESSING) {
            // Idempotency: callback ที่สำเร็จแล้วให้忽略
            if (this.status == PaymentStatus.SUCCESS) return;
            throw new BusinessException(40001, "สถานะปัจจุบันไม่อนุญาตให้ทำเครื่องหมายสำเร็จ",
                "ปัจจุบัน: " + this.status);
        }
        this.status = PaymentStatus.SUCCESS;
        this.channelOrderNo = channelOrderNo;
        addDomainEvent(new PaymentSuccessEvent(this.id, this.orderId, this.amount, paidAt));
    }

    // คืนเงิน
    public void refund(Money amount, String reason) {
        if (this.status != PaymentStatus.SUCCESS) {
            throw new BusinessException(40001, "เฉพาะคำสั่งซื้อที่ชำระแล้วเท่านั้นที่คืนเงินได้");
        }
        Money refundable = this.amount.subtract(this.totalRefundedAmount);
        if (amount.greaterThan(refundable)) {
            throw new BusinessException(40001, "ยอดคงเหลือที่คืนได้ไม่เพียงพอ");
        }
        this.totalRefundedAmount = this.totalRefundedAmount.add(amount);
        this.status = amount.equals(this.amount) ? PaymentStatus.REFUNDED : PaymentStatus.REFUNDING;
        addDomainEvent(new PaymentRefundedEvent(this.id, this.orderId, amount));
    }
}
```

## 5. การตอบกลับแบบรวม

```json
// เริ่มชำระเงินสำเร็จ
POST /api/v1/payments → 201
{
  "code": 0,
  "message": "success",
  "data": {
    "paymentId": "PAY-2024-001",
    "orderId": "ORD-2024-001",
    "amount": "99.00",
    "method": "WECHAT_PAY",
    "status": "PROCESSING",
    "payUrl": "weixin://pay/...",
    "expiresIn": 300
  }
}

// Callback WeChat ประมวลผลสำเร็จ
POST /api/v1/payments/callback/wechat → 200
HTTP body: "SUCCESS"

// คืนเงินสำเร็จ
POST /api/v1/payments/PAY-2024-001/refund → 200
{
  "code": 0,
  "message": "success",
  "data": {
    "refundId": "REF-2024-001",
    "amount": "99.00",
    "status": "REFUNDED",
    "refundedAt": "2024-01-16T11:00:00Z"
  }
}
```

## 6. การออกแบบความปลอดภัย

| Endpoint | การยืนยันตัวตน | การจำกัดอัตรา | Idempotency | พิเศษ |
|------|------|------|------|------|
| POST /payments | JWT + การอนุญาต BC | 30/min/user | ✅ Idempotency-Key | ตรวจสอบความเป็นเจ้าของทรัพยากร |
| POST /payments/{id}/refund | JWT + บทบาท OPERATOR | 10/min/user | ✅ State machine + idempotency ทางธุรกิจ | ตรวจสอบจำนวนเงินคืน |
| POST /callback/* | ตรวจสอบลายเซ็น (ไม่มี JWT) | 100/min/IP | ✅ ตาราง deduplication + callback idempotency | IP whitelist |
| GET /payments/{id} | JWT | 200/min/user | Idempotent โดยธรรมชาติ | — |