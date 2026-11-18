---
name: dev-workflow-en
description: "Complete development workflow for any software project. Includes brainstorming, planning, execution, scrutiny, debugging, and planning-cards. Use for any development task from idea to production."
---

# Development Workflow Skill

> **Goal:** A comprehensive software development guide applicable to any project (Frontend, Backend, Full‑Stack) and any architectural pattern.

---

## Core Principles

1. **Separation of Concerns** — Isolate Business Logic, Infrastructure, and Presentation (Clean Architecture / Hexagonal / Onion).
2. **Dependency Rule** — Dependencies point inward only (inner layers know nothing about outer layers).
3. **Testability** — Write Unit Tests for every Use Case and Repository/Service containing business logic.
4. **Communication** — Use Thai when communicating with the user (except for code, paths, commands, and identifiers).

---

## 🧠 1. Brainstorming — Design Before Implementation

**Use when:** Starting a new task, feature, or major change.

### Steps

0. **Load communication style** (if available) — to align with the defined tone.
1. **Explore context** — Review project structure (files, docs, recent commits).
2. **Ask one question at a time** — Understand goals, constraints, and success criteria.
3. **Propose 2–3 approaches** — With trade-offs and a recommendation.
4. **Present Design** — Break down by complexity (Architecture, Components, Data Flow, Error Handling, Testing).
5. **Self-review the Design** — Check for unclear points, contradictions, or ambiguities.
6. **Get user approval** — Before proceeding.
7. **Ask about Unit Tests** — Recommend writing them.
8. **Hand off to Writing Plans** — After the design is approved.

> ⛔ **Do NOT write any code or create files until this step is complete.**

---

## 📝 2. Writing Plans — Creating Actionable Plans

**Use when:** An approved design (from Brainstorming) exists and a detailed plan is needed.

### Plan Structure

- **Language:** Written in Thai (except for code, paths, commands, identifiers).
- **Save to:** `docs/plan/YYYY-MM-DD-<feature-name>.md`
- **Auto-open file:** Use `code "docs/plan/..."` (if the `code` command is installed).

### Plan Sections

| Section | Description |
|---------|-------------|
| **Overview of Changes** | Summary table of all changes (Order, Layer, File, What to change). |
| **Each Section (workflow order)** | Specify `file:line`, `from → to`, and detailed edit (with actual code). |
| **Unit Tests** | Clearly state whether to write them and what cases to cover. |
| **Confirmation Gate** | Wait for the user to type `confirm start implement plan` before executing. |

> 🛑 **Do NOT start Implementation until the user confirms.**

---

## ⚙️ 3. Executing Plans — Implementing the Plan

**Use when:** The user confirms (`confirm start implement plan`) and the plan file is ready.

### Steps

1. **Load Plan** — Read `docs/plan/...md`.
2. **Verify against reality** — Open every file mentioned and compare with the "from" state.
3. **Execute all sections** — Follow the order, one pass, no stopping (except for critical issues).
4. **Write Unit Tests** — If the plan requires them.
5. **Verify** — Build passes, Tests pass (both old and new).
6. **Report results** — Summary table (✅ / ⚠️ / ❌) + Test results + Deviations (if any).

> 🚫 **No commit** — Leave the diff for the user to review and commit manually.

---

## 🔍 4. Scrutinize — Systematic Review of Plans/PRs/Code

**Use when:** You need to check if a plan or change is correct, complete, and has better alternatives.

### Steps

0. **Load communication style** (if available).
1. **Intent** — Understand the goal of the work.
2. **Is there a simpler way?** — Consider alternatives (do less, use existing, fix at another layer).
3. **Trace** — Walk the real code path (Entry → Call → Branch → State → Exit), including both changed and unchanged code.
4. **Verify** — Does the change actually do what it claims? Test Edge Cases, Concurrency, Error Paths.
5. **Report** — List findings with `file:line`, rationale, evidence, and fix suggestions.

> ✅ **Output:** Pass / Fix then Pass / Redo / Fail — with the primary reason.

---

## 🐞 5. Investigate Error — Disciplined Debugging

**Use when:** There is an error, exception, or unexpected behavior.

### Opening Mantra — Recite before starting

> 1. **First is reproducibility.** Build a reliable repro.
> 2. **Know the fail path.** Debugger first; then source trace + knob enumeration; then instrumentation.
> 3. **Question your hypothesis.** What would disprove it?
> 4. **Every run is a breadcrumb.** Keep a ledger of all experiments.

### Procedure

- **Reproduce** — Create a reliably failing test (1–5 seconds, deterministic).
- **Find fail path** — Use Debugger → Source Trace → Instrument (printf).
- **Generate hypotheses** — 3–5 ranked hypotheses and try to disprove them first.
- **Keep ledger** — Log every experiment (what changed → outcome → conclusion).
- **When root cause is found** — Ask the user: Write Plan first, or Fix now (with/without Unit Tests).

> 🛑 **Do NOT propose a fix without a reliable repro.**

---

## 🗂️ 6. Planning Cards — Miro-style Cards + Flowchart

**Use when:** The user requests "plan", "plan cards", "flowchart", or uses the `/planning-cards` command.

### Requirements

- **Output:** Markdown and/or HTML files at `docs/planning/{card-number}/rtrpms-{card-number}.{md|html}`
- **Language:** Thai, except for technical terms and file names.
- **Structure:** Title, Mermaid Flowchart (HTML only), Task/Objective Cards table, Error Code / i18n (if applicable), Open Questions, Manual Test.
- **Task Card:** Must have Layer Label (`[repo|service|handler|component|...]`), file path, Input, Output, Flow, Unit test requirement.
- **Objective Card:** Specify implementation details, Success Condition, Error Path.
- **Colors:** 🔵 Backend, 🟢 Frontend (for categorization).

### Pre-delivery Checks

- Every Task has both Task Card and Objective Card.
- Every Task Card has all required fields.
- Mermaid Flow matches the table content.
- File paths and function names are real (not fabricated).
- Manual Test covers both Positive and Negative cases.

> 💡 **If a layer requires zero code changes** — Do NOT create a Task Card; mention it in Open Questions instead.

---

## 🔄 Interaction of All 6 Steps
