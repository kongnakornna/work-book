# Simplify Branch Workflow — Design

วันที่: 2026-06-30

## ปัญหา

ทีมลองใช้ flow skills แล้วงงกับการจัดการ branch ปัจจุบัน flow เริ่มงานด้วยการสร้าง
**worktree** (โฟลเดอร์แยก) ผ่าน `tb-using-git-worktrees` ซึ่งมี logic หนัก (detect
isolation, native tool, fallback, .gitignore, baseline test) และจบงานด้วย menu 4
ตัวเลือก (merge / PR / keep / discard) ผ่าน `tb-finishing-a-development-branch`
พร้อม cleanup worktree — ซับซ้อนเกินกว่าที่ทีมต้องการ

## เป้าหมาย

ตัดให้เหลือพฤติกรรมเดียวที่เข้าใจง่าย:

- **เริ่ม implement** = แตก branch ใหม่จาก HEAD ปัจจุบันเสมอ (AI ตั้งชื่อจากงาน แล้วบอก user)
- **ทำเสร็จ** = รัน test → commit ที่ branch ใหม่ → รายงานว่า commit ไหน แล้วหยุด
- ไม่มี worktree, ไม่มี push, ไม่มี merge/PR/discard menu

## ขอบเขตการเปลี่ยนแปลง

### 1. ลบ skill ย่อย 2 ตัว
ลบโฟลเดอร์ทั้งหมด:
- `tb-using-git-worktrees/`
- `tb-finishing-a-development-branch/`

### 2. tb-executing-plans/SKILL.md
- **Step 0 (เริ่ม):** จาก "Set up isolated workspace via tb-using-git-worktrees"
  → "สร้าง branch ใหม่": `git checkout -b <ชื่อที่ AI ตั้งจากงาน>` แตกจาก HEAD ปัจจุบัน
  แล้วบอก user ว่าตั้งชื่ออะไร ไม่มี worktree / ไม่มี baseline test gate / ไม่ต้อง
  setup ใหม่ (อยู่ working dir เดิม deps มีอยู่แล้ว)
- **Step 3 (จบ):** จาก "Use tb-finishing-a-development-branch" → "commit แล้วหยุด":
  รัน test → ให้แน่ใจว่างาน commit ครบบน branch ใหม่ → รายงาน commit range แล้วจบ
  ไม่ push / ไม่ merge / ไม่ menu
- ลบ reference 2 skill ที่ section Integration

### 3. tb-subagent-driven-development/SKILL.md
- กล่อง process diagram: `Set up isolated workspace (tb-using-git-worktrees)`
  → `สร้าง branch ใหม่`; `Use tb-finishing-a-development-branch`
  → `commit สถานะสุดท้าย + รายงาน จบ`
- แก้ Example workflow + section Integration + Red Flags ที่อ้าง 2 skill
- per-task commit เหมือนเดิม (implementer commit ทุก task อยู่แล้ว)

### 4. tb-writing-plans/SKILL.md
- แก้ถ้อยคำที่พูดถึง "isolated worktree ... created via tb-using-git-worktrees"
  → "branch ใหม่ที่สร้างตอน execute"

### 5. README.md
- ลบ 2 แถวในตาราง Skills: `tb-using-git-worktrees` และ `tb-finishing-a-development-branch`

## สิ่งที่ไม่แตะ (โดยเจตนา)

- `tb-requesting-code-review/code-reviewer.md:35` — ใช้ `git worktree add /tmp/review-SHA`
  เป็นเทคนิคของ reviewer ดู revision อื่นแบบ read-only คนละเรื่องกับ worktree ของ workflow
- README บรรทัด "branch dev" ในหัวข้อ Contribute — เป็น branching policy ของ repo เอง

## พฤติกรรมใหม่ที่ user เห็น

```
[เริ่ม] AI: สร้าง branch ใหม่ feature/add-login แตกจาก master แล้วนะครับ
[ทำงาน] ... implement + test + commit ...
[จบ]   AI: เสร็จแล้ว — test ผ่าน, commit ไว้ที่ feature/add-login (abc123..def456) จบครับ
```

## Acceptance Criteria

- [ ] โฟลเดอร์ `tb-using-git-worktrees/` และ `tb-finishing-a-development-branch/` ถูกลบ
- [ ] tb-executing-plans เริ่มด้วยการสร้าง branch ใหม่ (ไม่ใช่ worktree) และจบด้วย commit + รายงาน (ไม่มี menu)
- [ ] tb-subagent-driven-development diagram/example/integration/red-flags ไม่อ้าง 2 skill ที่ลบแล้ว
- [ ] tb-writing-plans ไม่พูดถึง worktree
- [ ] README ไม่มี 2 แถว skill ที่ลบ
- [ ] ไม่มี reference ค้างไปยัง `tb-using-git-worktrees` / `tb-finishing-a-development-branch` ในไฟล์ใด (ยกเว้นเอกสาร spec นี้)
