# tb-executing-plans

แก้ code ตาม plan จาก tb-writing-plans — execute รวดเดียวทุก section แล้วรายงานตอนจบ

> **ที่มา:** custom จาก official **superpowers** executing-plans skill ให้เข้ากับ format plan ของ tb-writing-plans

## ทำอะไร

- อ่านไฟล์ plan (`docs/plan/*.md`) เช็ค code จริงเทียบ plan ก่อนแก้
- Execute ทุก section รวดเดียวตามลำดับ workflow — แก้เฉพาะที่ plan ระบุ minimal change
- เจอ code ไม่ตรง plan: เรื่องเล็กปรับตามเจตนาแล้วจดไว้ / กระทบ logic หยุดถาม
- เขียน unit test ตามที่ plan ระบุ (plan บอกเขียน → เขียน / บอกไม่เขียน → ข้าม / ไม่พูดถึงเลย → เขียน) + build/run test ให้ pass
- จบด้วยรายงานภาษาไทย (ตารางสถานะ, ผล test, deviation ทั้งหมด) — **ไม่ commit** ทิ้ง diff ให้ review เอง

## Trigger เมื่อไหร่

เมื่อมีไฟล์ plan จาก tb-writing-plans แล้วสั่ง implement เช่นพิมพ์ "ยืนยัน เริ่ม implement plan" (วลีจาก handoff ของ tb-writing-plans) หรือ "แก้ code ตาม plan"

## ติดตั้ง

### 1. ดึง repo ลงเครื่อง (ครั้งแรก)

```bash
git clone https://gitlab.thaibevapp.com/thaibev-development-guide/codestyle/ai-skill/development.git
```

ถ้ามีอยู่แล้ว อัปเดตด้วย:

```bash
cd development && git pull
```

### 2. Copy folder `tb-executing-plans` ไปวางที่ global skills folder ของ Copilot

- **macOS:** `~/.copilot/skills/tb-executing-plans`
- **Windows:** `%USERPROFILE%\.copilot\skills\tb-executing-plans`

```bash
# macOS
cp -R tb-executing-plans ~/.copilot/skills/
```
```powershell
# Windows (PowerShell)
Copy-Item -Recurse tb-executing-plans ~\.copilot\skills\
```

## Requirements

- GitHub Copilot (CLI)
