# กรณีศึกษาการออกแบบ API ที่สมบูรณ์ของบริการคำสั่งซื้อ

> อิงจาก DDD Order Aggregate แสดงให้เห็นอย่างครบถ้วนถึงการแยก CQRS, สายการแปลงออบเจ็กต์ข้อมูล, การปรับใช้ BFF

## โดเมนโมเดล

```
Order (Aggregate Root)
├── OrderId (ValueObject)
├── OrderStatus: DRAFT → PAID → SHIPPED → DELIVERED
│                   ↘ CANCELLED
├── CustomerId (ValueObject) — อ้างอิง Customer Aggregate
├── List<OrderItem> (Entity)
│   ├── OrderItemId
│   ├── ProductId — อ้างอิง Product Aggregate
│   ├── Quantity
│   └── UnitPrice
├── Money totalAmount (ValueObject)
└── List<DomainEvent>
```

## 1. การออกแบบ Endpoint แบบ CQRS

### Command Endpoint (เขียน)

```
POST   /api/v1/orders                    → สร้างคำสั่งซื้อ
PUT    /api/v1/orders/{orderId}/confirm   → ยืนยันคำสั่งซื้อ
PUT    /api/v1/orders/{orderId}/ship      → ทำเครื่องหมายจัดส่ง
PUT    /api/v1/orders/{orderId}/deliver   → ทำเครื่องหมายส่งถึง
DELETE /api/v1/orders/{orderId}           → ยกเลิกคำสั่งซื้อ
```

### Query Endpoint (อ่าน)

```
GET    /api/v1/orders/{orderId}           → รายละเอียดคำสั่งซื้อ
GET    /api/v1/orders?status=PAID&page=1  → รายการคำสั่งซื้อ
GET    /api/v1/orders/{orderId}/items     → รายการสินค้าในคำสั่งซื้อ
```

## 2. สายการแปลงออบเจ็กต์ข้อมูล

```
PO (OrderPO) ↔ DO (Order) ↔ DTO (OrderDTO) ↔ VO (OrderDetailVO / OrderSummaryVO)
```

### PO — ชั้น Infrastructure

```java
@Entity
@Table(name = "orders")
public class OrderPO {
    @Id
    private Long id;
    private String orderNo;
    private String status;       // ฐานข้อมูลเก็บเป็น string
    private Long customerId;
    private BigDecimal totalAmount;
    private String currency;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Integer version;     // optimistic lock
}
```

### DO — ชั้น Domain

```java
public class Order extends AggregateRoot<OrderId> {
    private OrderId id;
    private OrderStatus status;
    private CustomerId customerId;
    private Money totalAmount;
    private List<OrderItem> items;

    public Order(OrderId id, CustomerId customerId, List<OrderItem> items) {
        this.id = id;
        this.customerId = customerId;
        this.items = Collections.unmodifiableList(items);
        this.status = OrderStatus.DRAFT;
        this.totalAmount = calculateTotal();
        addDomainEvent(new OrderCreatedEvent(id, customerId, totalAmount));
    }

    public void confirm() {
        if (!status.canConfirm()) {
            throw new BusinessException(40001, "สถานะคำสั่งซื้อไม่อนุญาตให้ยืนยัน",
                "สถานะปัจจุบัน: " + status + ", สถานะที่ยืนยันได้: DRAFT");
        }
        this.status = OrderStatus.CONFIRMED;
        addDomainEvent(new OrderConfirmedEvent(id));
    }

    private Money calculateTotal() {
        return items.stream()
            .map(OrderItem::getSubtotal)
            .reduce(Money.ZERO, Money::add);
    }
}
```

### DTO — ชั้น Interface

```java
// Command DTO
public record CreateOrderRequest(
    @NotNull String customerId,
    @NotEmpty List<@Valid OrderItemRequest> items
) {
    public CreateOrderCommand toCommand() {
        return new CreateOrderCommand(
            CustomerId.of(this.customerId()),
            this.items().stream().map(OrderItemRequest::toItem).toList()
        );
    }
}

// Query DTO
public record OrderDetailDTO(
    String orderId,
    String status,
    String totalAmount,
    List<OrderItemDTO> items,
    String createdAt
) {}
```

### VO — มุมมองฝั่ง Frontend

```json
{
  "orderId": "ORD-2024-001",
  "status": "PAID",
  "statusText": "ชำระแล้ว",
  "totalAmount": "¥99.00",
  "items": [
    { "productName": "T-Shirt", "quantity": 2, "price": "¥49.50" }
  ],
  "actions": ["cancel", "apply_return"]
}
```

## 3. ตัวแปลง (Assembler)

```java
public class OrderAssembler {
    // DO → DTO (read direction)
    public static OrderDetailDTO toDetailDTO(Order order) {
        return new OrderDetailDTO(
            order.getId().getValue(),
            order.getStatus().name(),
            order.getTotalAmount().toString(),
            order.getItems().stream().map(OrderAssembler::toItemDTO).toList(),
            order.getCreatedAt().toString()
        );
    }

    public static OrderSummaryDTO toSummaryDTO(Order order) {
        return new OrderSummaryDTO(
            order.getId().getValue(),
            order.getStatus().name(),
            order.getTotalAmount().toString(),
            order.getItems().size()
        );
    }

    // Command → DO (write direction)
    public static Order toDomain(CreateOrderCommand command) {
        List<OrderItem> items = command.items().stream()
            .map(item -> new OrderItem(
                OrderItemId.generate(),
                ProductId.of(item.productId()),
                item.quantity(),
                item.unitPrice()
            )).toList();
        return new Order(OrderId.generate(), command.customerId(), items);
    }
}
```

## 4. การตอบกลับแบบรวม

```json
// สร้างคำสั่งซื้อสำเร็จ
POST /api/v1/orders → 201
{
  "code": 0,
  "message": "success",
  "data": {
    "orderId": "ORD-2024-001",
    "status": "DRAFT",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}

// ค้นหารายการคำสั่งซื้อ
GET /api/v1/orders?status=PAID&page=1 → 200
{
  "code": 0,
  "message": "success",
  "data": {
    "records": [
      { "orderId": "ORD-2024-001", "status": "PAID", "totalAmount": "99.00", "itemCount": 2 }
    ],
    "total": 1,
    "page": 1,
    "pageSize": 20,
    "totalPages": 1
  }
}
```

## 5. สรุป OpenAPI

```yaml
openapi: 3.0.3
info:
  title: Order Service API
  version: 1.0.0
servers:
  - url: https://api.example.com/api/v1
paths:
  /orders:
    post:
      tags: [Order Commands]
      summary: Create order
      requestBody:
        $ref: '#/components/schemas/CreateOrderRequest'
      responses:
        '201': { $ref: '#/components/schemas/OrderCreatedResponse' }
    get:
      tags: [Order Queries]
      summary: List orders
      parameters:
        - name: status
          in: query
          schema: { type: string }
      responses:
        '200': { $ref: '#/components/schemas/OrderListResponse' }
```