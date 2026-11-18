---
name: tb-writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Communication Style

ALWAYS invoke tb-caveman-full skill when tb-writing-plans runs. Apply to all user-facing text.

## Overview

Write an implementation plan that states exactly **which points to change, from what to what**, so a reader immediately understands each edit. Order the changes to follow the code's runtime workflow, e.g. `api → handler → service → repo → database`.

If a change is a supporting addition (e.g. a new `model`), place it **before** the workflow, e.g. `model → api → handler → …`.

Assume the engineer is skilled but knows almost nothing about our toolset or problem domain. Give them enough that they understand every change without guessing.

**Language — write the plan in Thai:** all natural-language content of the plan
(goal, per-section explanations, "from what → to what" descriptions, section
titles, etc.) **must be written in Thai**. Keep in English only: code, file
paths / names, terminal commands, function / variable / type names, and
technical terms that become ambiguous when translated (the English term may be
kept in parentheses).

**Save plans to:** `docs/plan/YYYY-MM-DD-<feature-name>.md`
- Use the workspace root path already available from context — do NOT run `git rev-parse` or any terminal command to resolve the path.
- The plan is a single self-contained Markdown (`.md`) file.
- (User preferences for plan location override this default.)

**Auto-open the plan:** right after saving the file, run this terminal command
so the plan opens in VS Code immediately:

```bash
code "docs/plan/YYYY-MM-DD-<feature-name>.md"
```

Known limitation: VS Code ignores `workbench.editorAssociations` for files
opened via the CLI (open bug — microsoft/vscode#192954), so this opens the
**text editor**, not the Markdown preview. The handoff message below therefore
tells the user to press `Cmd+Shift+V` (`Ctrl+Shift+V` on Windows). Opening the
file from the Explorer sidebar does apply the association and shows the
preview directly.

If the `code` command is unavailable, skip this step silently — do not treat it
as an error.

## Plan Structure

**Start the plan with an overview table (`## ภาพรวมการแก้ไข`)** before any
detail section — one row per section, in the same workflow order: number,
layer, file, one-line summary of the change. This lets the reader grasp the
overall workflow before reading the details. Example:

```markdown
## ภาพรวมการแก้ไข

| # | Layer | ไฟล์ | สิ่งที่แก้ |
|---|-------|------|-----------|
| 1 | model | model.go | เพิ่ม struct Employee + EmployeeDTO |
| 2 | handler | handler.go | เพิ่ม endpoint POST /employee, bind JSON → 400, email ซ้ำ → 409 |
| 3 | service | service.go | generate UUID, set created_at/updated_at, เรียก repo.Save |
| 4 | repo | repository.go | Save ตรวจ email ซ้ำ + write lock |
```

Divide the plan into **clear sections**, one per point being changed, laid out
in workflow order (supporting additions first, then `api → handler → service →
repo → database`, or whatever layers this codebase uses).

Each section must make the change unambiguous:

- **Location** — the exact file and, where useful, the line range being touched
  (`exact/path/to/file.ext:123-145`).
- **From → to** — what the code does now and what it will do after the change,
  stated plainly enough that the reader understands the transformation.
- **Change detail** — the concrete edit: show the actual code where a code
  change is involved. No placeholders, no "TBD", no "handle edge cases" without
  saying how.

Keep the section order aligned with how a request flows through the code, so
reading top-to-bottom reads like tracing the request.

## Unit Test Decision

The plan MUST state explicitly whether unit tests will be written. Add a
`## Unit Tests` section to the plan containing one of:

- **เขียน** — list the cases to cover (per section changed, plus any specific
  cases like "duplicate email → 409").
- **ไม่เขียน** — state the reason briefly.

Take the decision from the brainstorming design (tb-brainstorming records it).
If no decision exists in the conversation context, **ask the user before
writing the plan** — recommend writing unit tests.

## Session Handoff Message

Right after the plan file is written and saved, print this block for the user
(replace the path with the real saved plan path). The paste message must be in
its own fenced code block so the user can copy it in one action:

````
✅ Plan เสร็จแล้ว: docs/plan/YYYY-MM-DD-<feature-name>.md
เปิดไฟล์ให้แล้ว — กด Cmd+Shift+V (Windows: Ctrl+Shift+V) เพื่อดูแบบ preview

แนะนำ: เริ่ม implement ใน session ใหม่เพื่อประหยัด token
1. copy ข้อความด้านล่างเก็บไว้ก่อน:

```
@docs/plan/YYYY-MM-DD-<feature-name>.md
อ่าน plan นี้แล้วสรุปสั้น ๆ ก่อน จากนั้น
ยืนยัน เริ่ม implement plan
```

2. พิมพ์ /clear
3. paste ข้อความที่ copy ไว้ใน session ใหม่
````

## Confirm Gate

After the plan file is written and saved, **stop and wait**. Do NOT invoke any
next skill (execution or otherwise) until the user has typed **exactly**:

```
ยืนยัน เริ่ม implement plan
```

Until that phrase is received, take no execution action. This gate applies every
time, regardless of how simple the plan looks.

## Execution Handoff

Once the user has typed `ยืนยัน เริ่ม implement plan`, start execution
immediately:

- **REQUIRED SUB-SKILL:** Use tb-executing-plans
