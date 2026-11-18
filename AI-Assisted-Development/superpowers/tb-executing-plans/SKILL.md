---
name: tb-executing-plans
description: Use when a plan file from tb-writing-plans (docs/plan/*.md) exists and the user asks to implement it — e.g. "ยืนยัน เริ่ม implement plan", "implement plan", "แก้ code ตาม plan", or pastes/references a docs/plan file and asks to start coding.
---

# Executing Plans

## Communication Style

ALWAYS invoke tb-caveman-full skill when tb-executing-plans runs. Apply to all user-facing text.

**Language:** talk to the user and write the final report in Thai. Code, file paths, commands, and technical terms stay in English (same convention as tb-writing-plans).

## Overview

Take a plan written by tb-writing-plans and implement it: load the plan, verify it against the real code, execute every section in one pass, write unit tests when the plan calls for them (see Step 3), verify build + tests, then report in Thai. Do **not** commit — leave the diff for the user to review. Work directly on the current branch — do not create branches or worktrees.

## Step 1: Load and Review Plan

1. Read the plan file (`docs/plan/YYYY-MM-DD-<feature-name>.md`).
2. Read the `## ภาพรวมการแก้ไข` table → create one todo/checklist item per section (use whatever task-tracking the environment provides; a plain markdown checklist in the reply is fine).
3. Open **every** file the plan touches **before editing anything**. Compare the real code against each section's "from" state.
4. If the plan has a critical gap — file missing, structure changed beyond recognition, instruction unreadable — **stop and ask** before starting. Do not guess.

## Step 2: Execute All Sections

Run through every section in plan order (workflow order), one pass, no stopping between sections.

Per section:
- Edit only what the plan specifies. Minimal change. Follow the codebase's existing style, naming, and patterns.
- No extra refactoring, no scope creep, no new dependencies or abstractions the plan didn't ask for.

**When real code doesn't match the plan:**
- Small drift (line numbers shifted, minor rename, trivially adaptable snippet) → adapt to the plan's intent, continue, and record the deviation for the final report.
- Drift that affects logic, data flow, or structure → **stop immediately**, report what differs, and ask before proceeding.

## Step 3: Unit Tests

Check the plan's unit test decision (the `## Unit Tests` section, or any part of the plan mentioning unit tests):

- **Plan says write unit tests** → write them covering every section changed, following the project's existing test patterns and location conventions. If the plan names specific cases (e.g. duplicate email → 409), the tests must include those cases.
- **Plan says do NOT write unit tests** → skip this step. Step 4 still runs the existing test suite.
- **Plan doesn't mention unit tests at all** → default: write them (same as the "write" case above).

## Step 4: Verify

1. Build/compile must pass.
2. Run the full unit test suite — new tests (if written in Step 3) **and** existing tests must pass.
3. On failure: analyze root cause first.
   - Fix doesn't touch logic/data flow → fix it and re-run.
   - Fix requires changing logic or deviating from the plan → **stop**, report, ask.
4. Never claim done without real build + test output in hand.

## Step 5: Final Report (Thai, no commit)

Print a Thai report containing:

1. **ตารางสรุป** mirroring the plan's `ภาพรวมการแก้ไข` table:

```markdown
| # | Layer | ไฟล์ | สถานะ | Note |
|---|-------|------|--------|------|
| 1 | model | model.go | ✅ | ตาม plan |
| 2 | handler | handler.go | ⚠️ | line เลื่อนจาก plan, ปรับตามเจตนาแล้ว |
```

- ✅ = done per plan, ⚠️ = done with deviation (Note says what differed), ❌ = blocked.

2. **ผล verify** — actual numbers: build result, `X passed / Y failed`.
3. **Deviations** — every adaptation made in Step 2 must appear here. Never silent.
4. Closing line: tell the user to review the diff and commit themselves — this skill does not commit.

## Stop-and-Ask Triggers

Stop and ask the user (never guess) when:
- Plan has a critical gap before starting
- Code drift affects logic/structure (Step 2)
- Test failure requires a logic change to fix (Step 4)
- Any instruction is ambiguous

## Integration

- **tb-writing-plans** — produces the plan this skill executes; its handoff message ("ยืนยัน เริ่ม implement plan") is this skill's main trigger.
- **tb-caveman-full** — communication style, invoke first.
