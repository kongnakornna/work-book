# tb-writing-plans

แปลง spec/requirement ให้กลายเป็น **implementation plan** ที่บอกชัดว่าแก้จุดไหน จากอะไรเป็นอะไร เรียงตาม workflow ของโค้ด — ก่อนเริ่มแตะโค้ด

> **ที่มา:** custom / ดัดแปลงมาจาก official **superpowers** writing-plans skill

## ทำอะไร

- เขียนแผนโดยบอกชัดว่าแก้ **จุดไหน จากอะไรเป็นอะไร** ให้คนอ่านเข้าใจการเปลี่ยนแปลงทันที
- แบ่งเป็นหัวข้อชัดตาม workflow ของโค้ด (`api → handler → service → repo → database`) ถ้ามีส่วนเสริมเช่น `model` ให้วางก่อน workflow (`model → api → handler → …`)
- เปิดหัวไฟล์ plan ด้วย **ตารางภาพรวมการแก้ไข** (1 แถวต่อหัวข้อ: ลำดับ, layer, ไฟล์, สรุปสั้น) ให้เห็น workflow คร่าว ๆ ก่อนอ่านรายละเอียด
- แต่ละหัวข้อระบุ location (ไฟล์:บรรทัด), from → to, และรายละเอียดการแก้จริง — ไม่มี placeholder
- **ออกแผนเป็นไฟล์ Markdown (`.md`) ภาษาไทย** (คงโค้ด/พาธ/คำสั่ง/ชื่อฟังก์ชันเป็นภาษาอังกฤษ)
- บันทึกแผนที่ `<root-project>/docs/plan/YYYY-MM-DD-<feature-name>.md`
- **เปิดไฟล์ plan ให้อัตโนมัติ** หลังบันทึกเสร็จ (รัน `code <path>` แล้วบอกให้กด `Cmd+Shift+V` เพื่อดู preview — VS Code มี bug ที่ CLI ไม่ apply `workbench.editorAssociations` แต่เปิดจาก Explorer ได้ preview อัตโนมัติ ดูวิธีตั้งค่าใน [README หลัก](../README.md))
- **Confirm gate:** ผู้ใช้ต้องพิมพ์ `ยืนยัน เริ่ม implement plan` ก่อน จึงจะเรียก skill รันแผนถัดไป

## Trigger เมื่อไหร่

เมื่อมี spec หรือ requirement ของงานที่มีหลายขั้นตอน และต้องการวางแผนก่อนลงมือเขียนโค้ด
มักใช้ต่อจาก `tb-brainstorming` ที่ได้ design/spec มาแล้ว

## ติดตั้ง

### 1. ดึง repo ลงเครื่อง (ครั้งแรก)

```bash
git clone https://gitlab.thaibevapp.com/thaibev-development-guide/codestyle/ai-skill/development.git
```

ถ้ามีอยู่แล้ว อัปเดตด้วย:

```bash
cd development && git pull
```

### 2. Copy folder `tb-writing-plans` ไปวางที่ global skills folder ของ Copilot

- **macOS:** `~/.copilot/skills/tb-writing-plans`
- **Windows:** `%USERPROFILE%\.copilot\skills\tb-writing-plans`

```bash
# macOS
cp -R tb-writing-plans ~/.copilot/skills/
```
```powershell
# Windows (PowerShell)
Copy-Item -Recurse tb-writing-plans ~\.copilot\skills\
```

## Requirements

- GitHub Copilot (CLI)
- git (ใช้หา project root และ commit ระหว่างรันแผน)
