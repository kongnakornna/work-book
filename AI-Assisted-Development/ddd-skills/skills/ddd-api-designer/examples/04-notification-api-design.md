# กรณีศึกษาการออกแบบ API บริการแจ้งเตือน

> การออกแบบ REST API ของ Notification Bounded Context (Notification BC) แสดงสถานการณ์เช่น การส่งข้อความ การจัดการเทมเพลต เป็นต้น

## โดเมนโมเดล

```
Notification (Entity)
├── NotificationId
├── UserId
├── Channel: EMAIL / SMS / PUSH
├── TemplateId
├── Status: PENDING / SENT / FAILED
└── SentAt
```

## การออกแบบ Endpoint

| Endpoint | ประเภท | คำอธิบาย |
|------|------|------|
| `POST /api/v1/notifications/send` | Command | ส่งการแจ้งเตือน |
| `POST /api/v1/notifications/batch` | Command | ส่งแบบเป็นชุด |
| `GET /api/v1/notifications/{id}` | Query | รายละเอียดการแจ้งเตือน |
| `GET /api/v1/notifications?userId=&status=` | Query | รายการการแจ้งเตือนของผู้ใช้ |
| `POST /api/v1/notification-templates` | Command | สร้างเทมเพลต |
| `GET /api/v1/notification-templates` | Query | รายการเทมเพลต |