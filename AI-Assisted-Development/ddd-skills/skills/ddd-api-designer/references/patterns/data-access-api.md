# หลักการออกแบบ API ของชั้นเข้าถึงข้อมูล

การออกแบบอินเทอร์เฟซชั้น DAO:

- **การแยก Repository**: อินเทอร์เฟซ Repository ของโดเมนกำหนดในชั้น Domain ส่วนการนำไปใช้อยู่ในชั้น Infrastructure
- **การแยก CQS**: อินเทอร์เฟซ Query Repository และ Command Repository แยกจากกัน
- **การทำ Abstraction การแบ่งหน้า**: ใช้ Pageable/Page แบบ generic ร่วมกัน หลีกเลี่ยงการเปิดเผยโมเดลการแบ่งหน้าของ ORM
- **รูปแบบ Specification**: รูปแบบ Specification ห่อหุ้มเงื่อนไขการค้นหาที่ซับซ้อน เช่น UserSpecification.withStatus(Status.PAID).and(between(from, to))
- **การโหลดแบบ Lazy**: เมื่อออกแบบ API หลีกเลี่ยง N+1 query ใช้ Fetch Join หรือ EntityGraph