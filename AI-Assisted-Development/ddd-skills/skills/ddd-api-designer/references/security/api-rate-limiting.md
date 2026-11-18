# การออกแบบการจำกัดอัตรา API

กลยุทธ์การจำกัดอัตราแบบแตกต่าง:
- Command API: 50 req/s (การดำเนินการเขียนมีต้นทุนสูง)
- Query API: 200 req/s (การดำเนินการอ่านผ่อนปรนได้)
- Auth API: 10 req/s (ป้องกันการโจมตีแบบ brute force)
- ทั่วไป: 1000 req/s

วิธีการ implement: อัลกอริทึม Token Bucket รองรับทราฟฟิกแบบ burst
การตอบกลับเมื่อถูกจำกัดอัตรา: 429 Too Many Requests + header Retry-After