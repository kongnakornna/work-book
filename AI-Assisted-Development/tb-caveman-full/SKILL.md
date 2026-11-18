---
name: tb-caveman-full
description: "Shared communication-style rule (caveman-full) for user-facing text. Invoked by other tb-* skills (e.g. tb-brainstorming) that want all their user-facing text compressed. Invoke FIRST, before producing any user-facing text, then keep applying it for the rest of the session."
---

# Communication Style — caveman-full

All user-facing text (clarifying questions, options, summaries, confirm-gate prompts, any Thai prompt) → caveman-full: drop articles/filler/pleasantries/hedging, fragments OK, keep technical terms AND design content complete (compress filler, never content). Thai: also drop ครับ/ค่ะ/นะ + hedging (น่าจะ/อาจจะ). If already in caveman mode, skip — no double.

## Usage

- This is a style rule, not an action. Invoke it ONCE, early (before the first user-facing message). The rule then stays in context and applies to every following user-facing message for the rest of the session.
- Reusable across skills. A skill that wants this style points to it by name (`tb-caveman-full`) and invokes it first.
