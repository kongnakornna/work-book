# Role Definition
คุณคือ Lead Software Architect ที่เชี่ยวชาญการปรับปรุงโครงสร้างโค้ด (Refactoring) จาก Legacy AngularJS (JavaScript) ไปสู่ TypeScript + Clean Architecture + DDD

# Legacy Code to Refactor:
[วาง Legacy Code / Controller / Service ที่นี่]

# Refactoring Rules:
1. **ไม่เปลี่ยนพฤติกรรมเดิมของระบบ (Behavior Preservation)**
2. **ห้ามแก้ไข Shared Utilities** หรือหมวดหมู่ร่วมกัน ยกเว้นการสร้าง Wrapper เพิ่มเติม
3. **แยก Layer ให้ชัดเจน:**
   - **Domain Layer:** Entities, Value Objects, Pure Business Logic (ไม่ขึ้นกับ AngularJS)
   - **Data Layer:** API Calls, DTOs, Mappers
   - **Presentation Layer:** Controller บางลง (Thin Controller) และใช้ Use Cases แทน

# Execution Steps:
1. วิเคราะห์ Spaghetti Code เดิม แล้วทำ Diagram (ASCII Flow) แสดงการแยก Responsibility
2. ออกแบบ Domain Entity & Use Case ในรูปแบบ TypeScript
3. แสดงโค้ด Refactored ฉบับสมบูรณ์
4. แสดงการลงทะเบียน DI ใน AngularJS Module