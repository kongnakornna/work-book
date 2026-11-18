# tb-caveman-full

Communication-style rule (caveman-full) แบบใช้ร่วมกัน — บีบข้อความ user-facing ให้กระชับโดยคงเนื้อหา technical/design ครบ

> **ที่มา:** custom — แยกออกมาจาก section "Communication Style" เดิมใน tb-brainstorming เพื่อ reuse ข้ามหลาย skill

## ทำอะไร

- Rule คุมสไตล์ข้อความ user-facing: drop articles/filler/pleasantries/hedging, fragments OK, คงคำ technical + เนื้อหา design ครบ (บีบ filler ไม่บีบ content)
- ไทย: drop ครับ/ค่ะ/นะ + hedging (น่าจะ/อาจจะ)
- ถ้าอยู่ caveman mode อยู่แล้ว → skip ไม่ซ้อน
- เป็น **style ไม่ใช่ action** — invoke ครั้งเดียวตอนต้น rule ค้างใน context ทั้ง session

## Trigger เมื่อไหร่

- ไม่ใช่ skill ที่ผู้ใช้เรียกตรง ๆ — เป็น sub-skill ที่ skill อื่นเรียกใช้
- skill ที่อยากได้สไตล์นี้ชี้ด้วยชื่อ `tb-caveman-full` แล้ว invoke ก่อนออกข้อความ user-facing แรก (เช่น tb-brainstorming checklist step 0)

## ติดตั้ง

ติดตั้งเป็น global ให้ GitHub Copilot ไม่มี prompt ให้เลือก

```bash
npx skills add https://gitlab.thaibevapp.com/thaibev-development-guide/codestyle/ai-skill/development.git \
  --skill tb-caveman-full \
  --agent github-copilot -g -y
```

> **อัปเดต:** `npx skills update` (หรือรันคำสั่งเดิมซ้ำ)

> skill ที่เรียก tb-caveman-full (เช่น tb-brainstorming) ต้อง deploy ด้วย ถึงจะ invoke ติด

## Requirements

- GitHub Copilot (CLI)
