# tb-brainstorming

แปลงไอเดียให้กลายเป็น design/spec ที่สมบูรณ์ผ่านบทสนทนาแบบ collaborative — ก่อนเริ่มเขียนโค้ด

> **ที่มา:** custom / ดัดแปลงมาจาก official **superpowers** brainstorming skill

## ทำอะไร

- เข้าใจ context ของ project ก่อน แล้วถามทีละคำถามเพื่อรีไฟน์ไอเดีย
- เสนอ design และ **ขอ approval ก่อนลงมือ implement เสมอ** (HARD-GATE)
- มี visual companion (เปิด local server แสดงภาพประกอบ) ผ่าน `scripts/`

## Trigger เมื่อไหร่

เรียกเฉพาะเมื่อ prompt ระบุ `/tb-brainstorming` โดยตรง เช่น:

```text
/tb-brainstorming ช่วยออกแบบ approval flow
```

ไม่ auto trigger จากงาน creative, การสร้าง feature / component, การเพิ่ม functionality หรือการแก้พฤติกรรมระบบ

## ติดตั้ง

### 1. ดึง repo ลงเครื่อง (ครั้งแรก)

```bash
git clone https://gitlab.thaibevapp.com/thaibev-development-guide/codestyle/ai-skill/development.git
```

ถ้ามีอยู่แล้ว อัปเดตด้วย:

```bash
cd development && git pull
```

### 2. Copy folder `tb-brainstorming` ไปวางที่ global skills folder ของ Copilot

- **macOS:** `~/.copilot/skills/tb-brainstorming`
- **Windows:** `%USERPROFILE%\.copilot\skills\tb-brainstorming`

```bash
# macOS
cp -R tb-brainstorming ~/.copilot/skills/
```
```powershell
# Windows (PowerShell)
Copy-Item -Recurse tb-brainstorming ~\.copilot\skills\
```

## Requirements

- GitHub Copilot (CLI)
- Node.js (สำหรับ visual companion server — optional)
