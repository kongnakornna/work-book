# ขอบเขตการแปลงสี่ชั้นของ DTO/VO/DO/PO

## ความหมายและตำแหน่งของออบเจ็กต์

| ออบเจ็กต์ | ชื่อเต็ม | ชั้น | หน้าที่ |
|------|------|------|------|
| **DO** | Domain Object | ชั้น Domain | Rich model มีพฤติกรรมทางธุรกิจ |
| **DTO** | Data Transfer Object | Application/Adapter | ถ่ายโอนข้ามชั้น/ข้ามบริการ |
| **VO** | View Object | ชั้น Adapter | สำหรับแสดงผลบนหน้าเพจ |
| **PO** | Persistent Object | Infrastructure | แมปกับฐานข้อมูล |

## สายการแปลง

```
Frontend VO ↔ Adapter DTO ↔ Application DO ↔ Infrastructure PO
```

## กฎการแปลง

### DO → DTO
```java
public class OrderAssembler {
    public static OrderDTO toDTO(Order order) {
        return OrderDTO.builder()
            .orderId(order.getId().getValue())
            .status(order.getStatus().name())
            .total(order.getTotalAmount().toString())
            .items(order.getItems().stream().map(OrderAssembler::toItemDTO).toList())
            .build();
    }
}
```

### PO → DO (ดำเนินการโดย Repository)
```java
// ชั้น Infrastructure
public class JpaOrderRepository implements OrderRepository {
    public Optional<Order> findById(OrderId id) {
        return jpaRepo.findById(id.getValue())
            .map(OrderMapper::toDomain);  // PO → DO
    }
}
```

### DO → PO (ดำเนินการโดย Repository)
```java
public void save(Order order) {
    OrderPO po = OrderMapper.toPO(order);  // DO → PO
    jpaRepo.save(po);
}
```

## ข้อตกลงตำแหน่งการแปลง

| การแปลง | ตำแหน่ง | เครื่องมือ |
|------|------|------|
| PO ↔ DO | Infrastructure Repository | Mapper/Converter |
| DO → DTO | Application Assembler | Assembler |
| DTO ↔ VO | Adapter Controller | WebConverter |

## DO หนึ่งตัว → DTO หลายตัว

Order aggregate root ตัวเดียวกันสามารถผลิตได้:
- `OrderDetailDTO` — หน้ารายละเอียด (ฟิลด์ครบถ้วน)
- `OrderSummaryDTO` — หน้ารายการ (ฟิลด์ย่อ)
- `OrderExportDTO` — การส่งออก (ฟิลด์เฉพาะ)

DTO แต่ละตัวหันหน้าไปยังสถานการณ์เฉพาะ หลีกเลี่ยง "สากล DTO" (DTO แบบอเนกประสงค์)