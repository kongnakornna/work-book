# การออกแบบ API ที่ขับเคลื่อนด้วยเหตุการณ์

เหตุการณ์โดเมนแพร่กระจายระหว่าง bounded context ผ่านข้อความแบบอะซิงโครนัส:
- การตั้งชื่อเหตุการณ์: {Aggregate}.{Action}.Occurred (เช่น Order.Paid.Occurred)
- สัญญาเหตุการณ์: eventId + eventType + aggregateId + occurredAt + payload
- การรับประกันการส่ง: ส่งอย่างน้อยหนึ่งครั้ง (At-Least-Once) ผู้บริโภค implement idempotent deduplication
- Event API: POST /api/v1/events/publish — เผยแพร่เหตุการณ์