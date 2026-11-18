# กรณีศึกษาการออกแบบ API ของบริการสินค้า

> การออกแบบ REST API ของ Product Bounded Context (Product BC) แสดงสถานการณ์เช่น การจัดการสินค้า การค้นหาตามหมวดหมู่ เป็นต้น

## โดเมนโมเดล

```
Product (Aggregate Root)
├── ProductId
├── Sku
├── Title / Description
├── Price / CostPrice
├── CategoryId
└── ProductStatus: DRAFT / ONLINE / OFFLINE / DELETED
```

## การออกแบบ Endpoint

| Endpoint | ประเภท | คำอธิบาย |
|------|------|------|
| `POST /api/v1/products` | Command | สร้างสินค้า |
| `PUT /api/v1/products/{id}` | Command | อัปเดตสินค้า |
| `PUT /api/v1/products/{id}/online` | Command | เปิดขาย |
| `PUT /api/v1/products/{id}/offline` | Command | ปิดขาย |
| `GET /api/v1/products/{id}` | Query | รายละเอียดสินค้า DTO |
| `GET /api/v1/products?category=&page=&size=` | Query | รายการสินค้า (แบ่งหน้า) |

## การออกแบบ DTO

- `ProductDetailDTO`: หน้ารายละเอียด (รวมคำอธิบาย, ข้อมูลจำเพาะ)
- `ProductSummaryDTO`: หน้ารายการ (ชื่อเรื่อง, ราคา, รูปปก)
- `ProductCreateCommand`: คำขอสร้างสินค้า