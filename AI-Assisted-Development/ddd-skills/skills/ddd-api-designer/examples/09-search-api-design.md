# กรณีศึกษาการออกแบบ API ของบริการค้นหา

> การออกแบบ REST API ของ Search Bounded Context (Search BC) แสดงการออกแบบ Materialized View ในฝั่ง Query ของ CQRS

## โดเมนโมเดล

```
SearchIndex (Read Model)
├── DocumentId
├── DocumentType
├── Title / Content
├── Tags[]
└── IndexedAt
```

## การออกแบบ Endpoint

| Endpoint | ประเภท | คำอธิบาย |
|------|------|------|
| `GET /api/v1/search?q=&type=&page=` | Query | ค้นหาแบบเต็มข้อความ |
| `POST /api/v1/search/index` | Command | สร้างดัชนีใหม่ |
| `GET /api/v1/search/suggest?q=` | Query | คำแนะนำการค้นหา |
| `GET /api/v1/search/facets?field=` | Query | สถิติแบบรวมกลุ่ม |

## ประเด็นสำคัญในการออกแบบฝั่ง Query

- ผลลัพธ์การค้นหาใช้การแบ่งหน้าแบบ Cursor (`?cursor=xxx&size=20`)
- รองรับการเลือกฟิลด์ (`?fields=id,title,summary`)
- จัดเรียงผลลัพธ์ตามความเกี่ยวข้อง (คะแนนจากมากไปน้อย)