PEA Lab Kit (v8) - ta1          อ่านก่อน / READ ME FIRST
=====================================================================
ขั้นที่ 0: แตกไฟล์ zip ทั้งหมดก่อนเสมอ
  Windows: คลิกขวาที่ zip > Extract All      macOS: ดับเบิลคลิก zip
Step 0: always EXTRACT the whole zip first.

เลือกโฟลเดอร์ตามเครื่องของคุณ แล้วทำตามลำดับเลข 1 > 2 > 3
Open the folder for your computer and run the files in number order.

 Windows/                        macOS-Linux/
   1_setup.cmd     ติดตั้ง          0_HOW-TO-RUN.txt  (อ่านก่อน)
   2_check.cmd     ตรวจสอบ          1_setup.sh
   3_uninstall.cmd หลังจบอบรม       2_check.sh
                                    3_uninstall.sh

 lab-files/   ไฟล์ Key และ Config ของ Lab  ห้ามเปิด แก้ไข หรือส่งต่อ
              Lab key and config - do not open, edit or share.

WINDOWS
  ดับเบิลคลิกไฟล์ตามลำดับ ถ้าขึ้น "Windows protected your PC" กด More info > Run anyway

macOS  (ห้ามดับเบิลคลิกไฟล์ .sh / do NOT double-click)
  เปิด Terminal (Cmd+Space พิมพ์ Terminal) พิมพ์ "bash " (มีเว้นวรรค)
  ลากไฟล์ 1_setup.sh จาก Finder มาวางใน Terminal แล้วกด Enter
  ทำแบบเดียวกันกับ 2_check.sh (ผลจะเปิดใน TextEdit อัตโนมัติ)
  ดูภาพประกอบใน macOS-Linux/0_HOW-TO-RUN.txt
  ถ้าเผลอดับเบิลคลิกแล้วขึ้น "Apple could not verify ..." ให้กด Done ห้ามกด Move to Trash

หลังติดตั้ง ใช้งานด้วยคำสั่ง / After setup, connect with:
  ssh lab-pg1 | ssh lab-pg2 | ssh lab-infra   = ใช้ปกติ ผ่าน Bastion 1 (default path)
  ssh alt-pg1 | ssh alt-pg2 | ssh alt-infra   = เส้นทางสำรอง ผ่าน Bastion 2 ใช้เมื่อวิทยากรแจ้งเท่านั้น

ssh lab-tunnel (เปิดค้างไว้ หน้าต่างจะว่างเปล่า เป็นเรื่องปกติ ไม่มี Shell)
  ส่ง Port ของเครื่อง Lab มาที่ Notebook ของคุณ ใช้ใน Browser และ pgAdmin
  ปิดหน้าต่างหรือ Notebook เข้าโหมด Sleep = tunnel ปิด ให้สั่ง ssh lab-tunnel ใหม่
  (ถ้า Bastion 1 มีปัญหา ใช้ ssh alt-tunnel แทน)
    localhost:15432 = PostgreSQL pg1       localhost:15433 = PostgreSQL pg2
    localhost:16432 = PgBouncer            localhost:15000 / 15001 = HAProxy เขียน / อ่าน
    http://localhost:13000 = Grafana       http://localhost:19090 = Prometheus
    http://localhost:18025 = Mailpit (กล่องอีเมลแจ้งเตือน)
  ถ้าขึ้น "cannot listen to port" / "Could not request local forwarding" หรือ tunnel
  ปิดทันที แปลว่ามีโปรแกรมอื่นใช้ Port เหล่านี้อยู่ ให้ปิดโปรแกรมนั้น หรือแจ้งผู้ช่วยวิทยากร

pgAdmin 4 (วิธีหลัก: ให้ pgAdmin ใช้ Bastion เป็น SSH Tunnel)
  Connection: Host = ta1-pg1, Port = 5432, Username = student
  SSH Tunnel: Tunnel host = 146.190.6.43, Port = 22, Username = ta1,
              Authentication = Identity file > เลือกไฟล์ id_lab ในโฟลเดอร์ .ssh/pea-lab
              (ถ้า Bastion 1 มีปัญหา ใช้ Tunnel host = 159.89.209.96)
  วิธีสำรอง: เปิด ssh lab-tunnel ค้างไว้ แล้วใน pgAdmin ใช้ Host = 127.0.0.1, Port = 15432

ส่งไฟล์ check-result.txt (อยู่ในโฟลเดอร์ Windows หรือ macOS-Linux) ให้วิทยากร
  ข้อ [7] บรรทัด "OK (allowed, service not running yet)" เป็นเรื่องปกติก่อนติดตั้งโปรแกรมนั้น
  ถ้าเห็นคำว่า BLOCKED ให้แจ้งวิทยากร

1_setup ทำอะไรกับเครื่องของคุณ / What setup changes
  - สร้างโฟลเดอร์ ~/.ssh/pea-lab (Key และ Config ของ Lab)
  - สำรอง ~/.ssh/config เดิมเป็น config.bak แล้วเพิ่มบรรทัด "Include pea-lab/config" บนสุด 1 บรรทัด
  - ไม่แตะ Key หรือการตั้งค่าอื่นของคุณ
  - ถ้าเคยติดตั้ง Kit ชุดอื่นไว้ในเครื่องนี้ Kit นี้จะใช้แทนชุดเดิม
    (ทุก Kit ใช้โฟลเดอร์ ~/.ssh/pea-lab เดียวกัน ติดตั้งชุดเดิมใหม่เมื่อต้องการกลับไปใช้)
3_uninstall คืนค่าอย่างไร / What uninstall does
  - ลบเฉพาะบรรทัด "Include pea-lab/config" (การแก้ไขอื่นของคุณยังอยู่ครบ)
  - ย้ายโฟลเดอร์ pea-lab ไปถังขยะ (Recycle Bin / Trash) กู้คืนได้
  - ถ้า config เหมือนเดิมทุกอย่าง จะย้าย config.bak ไปถังขยะด้วย ถ้าไม่เหมือนจะเก็บไว้ให้

Instructor team kit (ta1). For the named team member only - do not share. Revoked after the course.
v8: host keys of the Bastions and of your 3 Lab VMs are pre-loaded (no yes/no prompt).
