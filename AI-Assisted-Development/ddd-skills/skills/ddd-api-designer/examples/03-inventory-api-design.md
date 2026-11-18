# กรณีศึกษาการออกแบบ API บริการสต็อก

> การออกแบบ REST API ของ bounded context สต็อก (Inventory BC) แสดงสถานการณ์ CQRS เช่น การหักสต็อก การล็อก การปล่อย

## โดเมนโมเดล

```
Inventory (Aggregate Root)
├── SkuId
├── AvailableQty
├── LockedQty
└── WarehouseCode
```

## การออกแบบ Endpoint

| Endpoint | ประเภท | คำอธิบาย |
|----------|--------|----------|
| `POST /api/v1/inventory/lock` | Command | ล็อกสต็อก (สั่งซื้อ) |
| `POST /api/v1/inventory/release` | Command | ปล่อยสต็อก (ยกเลิก) |
| `POST /api/v1/inventory/deduct` | Command | หักสต็อก (ชำระเงิน) |
| `GET /api/v1/inventory/{skuId}` | Query | ค้นหาสต็อก |
| `GET /api/v1/inventory/warehouse/{code}` | Query | ภาพรวมสต็อกในคลัง |

## การออกแบบ Idempotency

การดำเนินการล็อก/หักสต็อกใช้ `Idempotency-Key` เพื่อป้องกันการประมวลผลซ้ำ ฝั่งเซิร์ฟเวอร์แคช TTL 24 ชม.