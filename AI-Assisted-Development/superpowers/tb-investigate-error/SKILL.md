---
name: tb-investigate-error
description: Four-mantra debugging discipline — reproduce, trace the fail path, falsify the hypothesis, cross-reference every breadcrumb. Recite the mantra block verbatim at the start of any debugging session, then apply the four steps in order before proposing any fix. Use proactively whenever debugging starts — user reports a bug, says something is broken/throwing/failing, asks to debug/diagnose/investigate an issue, or pastes a stack trace or error log.
---

# Debug Mantra

Four-step discipline for any debug session. Recite verbatim, then apply in order.

## Communication Style

ALWAYS invoke tb-caveman-full skill when tb-investigate-error runs. Apply to all user-facing text.

## Recite this — verbatim, as the first thing in your first response

> **Mantra:**
> 1. **First is reproducibility.** Can the issue be reproduced reliably?
> 2. **Know the fail path.** Debugger first; then source trace + knob enumeration; then in-code instrumentation.
> 3. **Question your hypothesis.** What would disprove it?
> 4. **Every run is a breadcrumb.** Cross-reference all of them.

Then begin work.

---

## 1. Reproduce reliably

Build a runnable repro before anything else.

- **Reliable repro** → capture the exact steps, inputs, and environment as a runnable artifact: failing test, curl script, CLI invocation, replay harness.
- **Flaky repro** → the bug is not yet debuggable. Raise the rate first: loop the trigger, parallelise, add stress, narrow timing windows, inject sleeps. 50% flake is debuggable; 1% is not.
- **No repro at all** → stop. Say so explicitly. Ask the user for env access, captured artifacts (HAR, log dump, core), or permission to instrument. Do **not** proceed to hypothesise.

Target: a fast (1–5 s), deterministic pass/fail signal. Pin time, seed the RNG, freeze network, isolate filesystem.

## 2. Know the fail path

Once reproducible, find *where* the code breaks and *what stops it from breaking*. The differential narrows the search. Try in this order — escalate only when the prior tactic fails.

1. **Attach a debugger.** If the env supports it, attach and step to the failure site. One breakpoint beats ten logs. Do this **before** turning any knobs.
2. **Source trace + knob enumeration.** If no debugger (or it can't reach the bug), trace the code path end-to-end and list every knob that can influence the outcome:
   - config flags, env vars, feature toggles
   - branch conditions, input shape
   - timing, concurrency, build options
   Each knob is a candidate axis to flip in the differential. Flip one at a time.
3. **In-code instrumentation.** If outside knobs can't move the failure, go inside: `printf` / log statements at the suspected fail site, dump the relevant internal state. Tag every probe with a unique prefix (e.g. `[DBG-a4f2]`) so cleanup is a single grep. Let the trace show where reality diverges from your model.

## 3. Falsify the hypothesis

When a candidate root cause surfaces, scrutinise it **before** testing it.

- Does it actually explain the symptom end-to-end? Walk it through.
- What is the simplest **proof**? What is the cleanest **disproof**?
- Run the **disproof first**. If the hypothesis survives, it's real. If it dies, you saved yourself from chasing a phantom.
- Generate 3–5 ranked hypotheses, not one. Single-hypothesis thinking anchors on the first plausible idea.

## 4. Every run is a breadcrumb

Maintain a running **ledger** of every experiment in this session. Each entry: what changed, what happened, what it ruled in or out.

- When a new hypothesis surfaces, walk the ledger. Does it hold for **every** prior observation, not just the most recent?
- If any past run contradicts it, the hypothesis is wrong or incomplete — refine or discard.
- When in doubt, design the **single experiment** whose outcome makes it certain. Run that next, instead of churning on adjacent runs.
- Update the ledger after every run. It is your memory across the session.

---

## Operating rules

- Recite the mantra block **once** per debug session, in your first response. Do not re-recite mid-session.
- Recite **verbatim**. Never paraphrase, shorten, or skip lines of the recital.
- If the user says "skip the mantra" → skip the recital but still apply the four steps silently.
- Apply the four steps **in order**:
  - Do not propose a fix before #1 is satisfied (reliable repro exists).
  - Do not start testing hypotheses before #2 has narrowed the fail path.
  - Do not commit to a hypothesis before #3 has tried to disprove it.
  - Do not declare a hypothesis correct until #4 confirms it against every prior breadcrumb.
- If you catch yourself proposing a fix without a reliable repro, stop and return to step 1.
- The mantra is a constraint **you** carry through the session — not advice to deliver back to the user.

## Post-Investigation Options

Applies only when the root cause is **confirmed** — the hypothesis survived #3 and holds
against every breadcrumb in #4. If the root cause is not confirmed (no repro, all
hypotheses dead), report the findings and stop — do not show this menu.

Right after reporting the confirmed root cause, print the summary line:

```
🔍 Root cause ยืนยันแล้ว: <สรุปสาเหตุ 1 บรรทัด พร้อม file:line>
```

Then call the **AskUserQuestion** tool with one question ("เลือกขั้นตอนต่อไป") and
these three options:

1. **writing plan ก่อนแก้** — เหมาะกับ fix หลายไฟล์/หลาย layer
2. **แก้เลย + unit test**
3. **แก้เลย ไม่ทำ unit test**

**Gate:** take no edit action until the user selects an option. A free-text
"Other" reply → answer it, then ask again via AskUserQuestion.

**On option 1 — plan first:**
- **REQUIRED SUB-SKILL:** Use tb-writing-plans. Feed it the investigation output as the
  spec: confirmed root cause, fail path, affected `file:line` list, and the ledger's
  ruled-in/ruled-out findings.

**On option 2 — fix + unit test:**
- Apply the minimal fix for the confirmed root cause. Touch only the fail path; follow
  the codebase's existing style, naming, and patterns. No refactoring, no new
  dependencies or abstractions.
- Write unit tests following the project's existing test patterns and location
  conventions: cover the changed code **and** add a regression test that reproduces the
  original bug (fails before the fix, passes after).
- Verify: build/compile passes, new tests and existing tests pass. Report actual
  results. Do not commit — leave the diff for the user to review.

**On option 3 — fix only:**
- Same minimal fix and verification as option 2, without writing unit tests. Existing
  tests must still pass. Do not commit.

## Integration

- **tb-caveman-full** — communication style, invoke first.
- **tb-writing-plans** — option 1 handoff; converts the confirmed root cause into an
  executable plan (which in turn hands off to tb-executing-plans).
