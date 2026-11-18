# กรณีศึกษาการสร้างโค้ดจาก OpenAPI

> แสดงกลยุทธ์ Spec-first: การสร้างโครงร่างฝั่งเซิร์ฟเวอร์และ SDK ฝั่งไคลเอนต์จากข้อกำหนด OpenAPI

## การเลือกกลยุทธ์

| กลยุทธ์ | เหมาะสมกับ | ขั้นตอนการทำงาน |
|------|------|--------|
| **Code-first** | บริการภายใน, พัฒนาเร็ว | ใส่ annotation → ส่งออก Spec ตอนรันไทม์ → สร้างไคลเอนต์ |
| **Spec-first** | API สาธารณะ, การทำงานร่วมกันในทีม | เขียน YAML ก่อน → สร้างโครงร่างฝั่งเซิร์ฟเวอร์ → เติม business logic |
| **Hybrid** | ระดับองค์กร, ผู้บริโภคหลายราย | ใช้ annotation + ตรวจสอบข้อกำหนด → ส่งออก → สร้าง SDK |

**แนะนำ**: บริการ DDD ภายในใช้ Code-first (SpringDoc), API สาธารณะใช้ Spec-first (openapi-generator)

## สถานการณ์: ข้อกำหนด API บริการชำระเงิน (Spec-first)

### 1. เขียนข้อกำหนด OpenAPI

```yaml
# payment-api-v1.yaml
openapi: 3.0.3
info:
  title: Payment Service API
  version: 1.0.0
  description: API บริการชำระเงิน — เริ่มชำระ, callback, คืนเงิน
servers:
  - url: https://api.example.com/api/v1

paths:
  /payments:
    post:
      operationId: initiatePayment
      tags: [Payment Commands]
      parameters:
        - name: Idempotency-Key
          in: header
          required: true
          schema:
            type: string
            format: uuid
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/InitiatePaymentRequest'
      responses:
        '201':
          description: เริ่มชำระสำเร็จ
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaymentCreatedResponse'
        '400':
          $ref: '#/components/responses/BusinessError'
      x-springdoc-default: "40001"

  /payments/{paymentId}:
    get:
      operationId: getPayment
      tags: [Payment Queries]
      parameters:
        - name: paymentId
          in: path
          required: true
          schema:
            type: string
            pattern: '^PAY-\d{4}-\d{3,6}$'
      responses:
        '200':
          description: รายละเอียดการชำระเงิน
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaymentDetailResponse'

components:
  schemas:
    InitiatePaymentRequest:
      type: object
      required: [orderId, amount, currency, method]
      properties:
        orderId:
          type: string
          example: ORD-2024-001
        amount:
          type: string
          example: "99.00"
        currency:
          type: string
          enum: [CNY, USD]
        method:
          type: string
          enum: [WECHAT_PAY, ALIPAY, CARD]

    PaymentCreatedData:
      type: object
      properties:
        paymentId:
          type: string
        status:
          type: string
          enum: [PROCESSING]
        payUrl:
          type: string
        expiresIn:
          type: integer

    PaymentCreatedResponse:
      type: object
      properties:
        code:
          type: integer
          example: 0
        message:
          type: string
        data:
          $ref: '#/components/schemas/PaymentCreatedData'

    PaymentDetailData:
      type: object
      properties:
        paymentId:
          type: string
        orderId:
          type: string
        status:
          type: string
        amount:
          type: string
        method:
          type: string
        channelOrderNo:
          type: string
        createdAt:
          type: string
          format: date-time

    PaymentDetailResponse:
      type: object
      properties:
        code:
          type: integer
        message:
          type: string
        data:
          $ref: '#/components/schemas/PaymentDetailData'

    ApiError:
      type: object
      properties:
        code:
          type: integer
        message:
          type: string
        detail:
          type: string
        requestId:
          type: string

  responses:
    BusinessError:
      description: ข้อผิดพลาดทางธุรกิจ
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ApiError'
```

### 2. สร้างโครงร่างฝั่งเซิร์ฟเวอร์

```bash
# ใช้ openapi-generator สร้างเซิร์ฟเวอร์ Java Spring
openapi-generator generate \
  -i payment-api-v1.yaml \
  -g spring \
  -o payment-service \
  --api-package com.example.payment.adapter.inbound.web \
  --model-package com.example.payment.adapter.inbound.dto \
  --additional-properties=interfaceOnly=true

# โครงสร้างไดเรกทอรีที่สร้าง
payment-service/
├── src/main/java/com/example/payment/adapter/inbound/
│   ├── web/
│   │   ├── PaymentApi.java                     # อินเทอร์เฟซที่สร้าง
│   │   └── PaymentApiController.java           # โครงร่างที่สร้าง
│   └── dto/
│       ├── InitiatePaymentRequest.java         # request DTO ที่สร้าง
│       ├── PaymentCreatedResponse.java         # response DTO ที่สร้าง
│       └── ApiError.java                       # error DTO ที่สร้าง
```

### 3. Implement business logic

```java
@RestController
public class PaymentController implements PaymentApi {

    private final PaymentApplicationService paymentService;

    @Override
    public ResponseEntity<PaymentCreatedResponse> initiatePayment(
            String idempotencyKey,
            InitiatePaymentRequest request) {

        // 1. request DTO → command object
        InitiatePaymentCommand command = new InitiatePaymentCommand(
            OrderId.of(request.getOrderId()),
            Money.of(request.getAmount(), Currency.valueOf(request.getCurrency())),
            PaymentMethod.valueOf(request.getMethod())
        );

        // 2. เรียก application service
        PaymentResult result = paymentService.initiate(command, idempotencyKey);

        // 3. domain result → response DTO
        PaymentCreatedData data = new PaymentCreatedData();
        data.setPaymentId(result.getPaymentId());
        data.setStatus("PROCESSING");
        data.setPayUrl(result.getPayUrl());
        data.setExpiresIn(300);

        PaymentCreatedResponse response = new PaymentCreatedResponse();
        response.setCode(0);
        response.setMessage("success");
        response.setData(data);

        return ResponseEntity.status(201).body(response);
    }
}
```

### 4. สร้าง SDK ฝั่งไคลเอนต์

```bash
# สร้างไคลเอนต์ TypeScript
openapi-generator generate \
  -i payment-api-v1.yaml \
  -g typescript-axios \
  -o payment-client-ts

# สร้างไคลเอนต์ Java
openapi-generator generate \
  -i payment-api-v1.yaml \
  -g java \
  -o payment-client-java
```

### 5. การใช้งานฝั่งไคลเอนต์

```typescript
// ไคลเอนต์ TypeScript
import { PaymentApi } from './payment-client-ts';

const api = new PaymentApi();

// เริ่มชำระเงิน
const response = await api.initiatePayment(
  { orderId: "ORD-2024-001", amount: "99.00", currency: "CNY", method: "WECHAT_PAY" },
  { headers: { "Idempotency-Key": uuidv4() } }
);

console.log(response.data.data.payUrl);  // weixin://pay/...
```

## แนวทาง Code-first (SpringDoc annotation)

```java
@RestController
@RequestMapping("/api/v1/payments")
@Tag(name = "Payment Commands", description = "endpoint คำสั่งชำระเงิน")
public class PaymentController {

    @Operation(summary = "เริ่มชำระเงิน", operationId = "initiatePayment")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "เริ่มชำระสำเร็จ"),
        @ApiResponse(responseCode = "400", description = "ข้อผิดพลาดทางธุรกิจ",
            content = @Content(schema = @Schema(implementation = ApiError.class)))
    })
    @PostMapping
    public ResponseEntity<PaymentCreatedResponse> initiatePayment(
            @RequestHeader("Idempotency-Key") @Parameter(description = "คีย์ idempotency")
            String idempotencyKey,
            @RequestBody @Valid InitiatePaymentRequest request) {
        // ...
    }
}
```

ส่งออก Spec:

```yaml
# application.yml
springdoc:
  api-docs:
    path: /api-docs
  swagger-ui:
    path: /swagger-ui.html
  packages-to-scan: com.example.payment.adapter.inbound.web
```

```bash
# ส่งออกข้อกำหนด OpenAPI ตอนรันไทม์
curl http://localhost:8080/api-docs > payment-api-spec.yaml
```

## แนวทางปฏิบัติที่ดีที่สุดสำหรับการสร้างโค้ด OpenAPI

1. **หนึ่งไฟล์ Spec ต่อหนึ่ง BC**: Spec ของ Order BC และ Payment BC จัดการแยกกัน
2. **ใช้ operationId ให้ตรงกับชื่อเมธอด**: เพื่อความสะดวกในการแมปเมธอดของโค้ดที่สร้าง
3. **Interface-first** (interfaceOnly=true): สร้างอินเทอร์เฟซ ไม่สร้าง implementation เพื่อหลีกเลี่ยงการเขียนทับโค้ดธุรกิจ
4. **DTO และ VO ไม่ผ่านการสร้างโค้ด**: DTO/VO ในโปรเจกต์ DDD ควรออกแบบด้วยมือ โครงสร้าง annotation ไม่เหมาะกับ DTO ที่ซับซ้อน
5. **นำ Spec เข้าสู่ version control**: ทุกการเปลี่ยนแปลง API ต้องอัปเดตไฟล์ Spec
6. **Spec diff เป็นส่วนหนึ่งของ Code Review**: ตรวจสอบการเปลี่ยนแปลง Spec ก่อน merge
7. **สร้าง SDK ฝั่งไคลเอนต์ตามต้องการ**: อย่า commit SDK ที่สร้างลงใน repository ให้สร้างผ่าน CI ตามต้องการ