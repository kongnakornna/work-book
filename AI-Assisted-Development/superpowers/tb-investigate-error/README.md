# tb-investigate-error

วินัย debug 4 ข้อ (debug-mantra) สำหรับทุก session ที่ต้องสืบสวน error/bug — ท่อง mantra ก่อน แล้วทำตาม 4 ขั้นตอนตามลำดับ ก่อนเสนอวิธีแก้ใด ๆ

## ทำอะไร

บังคับวินัย 4 ข้อก่อนเสนอ fix:

1. **Reproduce reliably** — ต้อง reproduce ได้ก่อน ถ้า flaky ให้เพิ่ม rate ก่อน ถ้า reproduce ไม่ได้เลยให้หยุดและบอกตรง ๆ ห้ามเดา
2. **Know the fail path** — ไล่หาจุดพังตามลำดับ: debugger → source trace + knob enumeration → in-code instrumentation
3. **Falsify the hypothesis** — ตั้งสมมติฐาน 3–5 อันจัดอันดับ แล้วพยายาม "หักล้าง" ก่อนเชื่อ
4. **Every run is a breadcrumb** — จด ledger ทุกการทดลอง สมมติฐานใหม่ต้องไม่ขัดกับผลรันก่อนหน้าทุกครั้ง

เริ่ม session ด้วยการท่อง mantra block แบบ verbatim หนึ่งครั้ง แล้วค่อยลงมือ

## หลังยืนยัน Root Cause แล้ว

เมื่อ root cause ยืนยันได้ (ผ่านข้อ 3–4) skill จะถามขั้นตอนต่อไปผ่าน AskUserQuestion (เลือกจากปุ่ม ไม่ต้องพิมพ์) แล้วหยุดรอ:

1. **writing plan ก่อนแก้** → handoff ไป `tb-writing-plans` โดยใช้ root cause + fail path + file:line เป็น spec (เหมาะกับ fix หลายไฟล์/หลาย layer)
2. **แก้เลย + unit test** → แก้ minimal เฉพาะ fail path + เขียน unit test คลุมส่วนที่แก้ และ regression test ของ bug เดิม แล้ว verify build + tests
3. **แก้เลย ไม่ทำ unit test** → แก้ minimal อย่างเดียว test เดิมต้องยังผ่าน

ทุก option ไม่ commit — ทิ้ง diff ให้ user review เอง ถ้า root cause ยืนยันไม่ได้ จะรายงานผลแล้วจบ ไม่ขึ้นเมนู

## Trigger เมื่อไหร่

Copilot จะ activate skill นี้อัตโนมัติเมื่อผู้ใช้:

- รายงาน bug / บอกว่าระบบพัง / โยน error / ทำงานผิด
- paste stack trace หรือ error log
- ขอให้ debug / diagnose / investigate / ไล่หาสาเหตุ

## Communication Style

skill นี้จะ invoke `tb-caveman-full` ก่อนเสมอ — ข้อความที่คุยกับผู้ใช้ทั้งหมดถูกบีบแบบ caveman-full (ตัด filler/pleasantries/hedging เนื้อหา technical ครบ)

## ติดตั้ง

### 1. ดึง repo ลงเครื่อง (ครั้งแรก)

```bash
git clone https://gitlab.thaibevapp.com/thaibev-development-guide/codestyle/ai-skill/development.git
```

ถ้ามีอยู่แล้ว อัปเดตด้วย:

```bash
cd development && git pull
```

### 2. Copy folder `tb-investigate-error` ไปวางที่ global skills folder ของ Copilot

- **macOS:** `~/.copilot/skills/tb-investigate-error`
- **Windows:** `%USERPROFILE%\.copilot\skills\tb-investigate-error`

```bash
# macOS
cp -R tb-investigate-error ~/.copilot/skills/
```
```powershell
# Windows (PowerShell)
Copy-Item -Recurse tb-investigate-error ~\.copilot\skills\
```

## Requirements

- GitHub Copilot (CLI)
- skill `tb-caveman-full` (ต้อง copy ไปที่ `~/.copilot/skills/` ด้วย เพื่อใช้ communication style) — ถ้าไม่มี skill ยังทำงานได้แต่ข้อความจะไม่ถูกบีบ
- skill `tb-writing-plans` (สำหรับ option 1 — writing plan ก่อนแก้) — ถ้าไม่มี option 1 จะใช้ไม่ได้ แต่ option 2/3 ยังทำงานปกติ
