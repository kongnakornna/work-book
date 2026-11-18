/tb-brainstorming

[ความต้องการ / Task Spec]
- Endpoint: POST http://localhost:8080/employee (สร้างพนักงานใหม่)
- Context: ต่อยอดจาก GET http://localhost:8080/employees

[Business Logic Requirements]
1. id: autogenerate เป็น UUID v4
2. full_name: required field, ห้ามว่าง
3. email: required field, ห้ามว่าง และ ห้ามซ้ำกับที่มีในระบบ
4. created_at: เวลาปัจจุบัน (UTC) ตอนสร้างรายการ
5. updated_at: ให้มีค่าเท่ากับ created_at ณ ตอนสร้างรายการ

[ข้อกำหนดและข้อห้าม (Strict Rules)]
- ห้ามแก้ไขโครงสร้างโฟลเดอร์เดิมของระบบ
- ห้ามแก้ไข Shared Functions หรือ Shared Utilities ที่มีโมดูลอื่นใช้อยู่แล้ว
- ให้ใช้ Clean Architecture ตามโครงสร้างที่กำหนดในโปรเจกต์ (Handler -> Service -> Repository)

[สิ่งที่ต้องทำในขั้นตอนนี้]
1. วิเคราะห์ Concept และ Edge Cases (เช่น Email Case-Sensitivity, Concurrent Requests)
2. วิเคราะห์ Impact / Affected Modules ที่อาจเกิดขึ้น
3. วาด ASCII Flowchart แสดง Dataflow ตั้งแต่ Client (HTTP) -> Handler -> Service -> Repository -> Database/Memory
4. สรุปข้อควรระวัง / ข้อดี / ข้อเสีย ของแนวทางการออกแบบ