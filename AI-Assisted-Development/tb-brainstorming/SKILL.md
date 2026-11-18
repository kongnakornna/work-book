---
name: tb-brainstorming
description: "Turn ideas into designs and specs through collaborative dialogue. Invoke only when the user's prompt explicitly contains 'tb-brainstorming'; never invoke automatically."
disable-model-invocation: true
---

# Brainstorming Ideas Into Designs

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design and get user approval.

## Communication Style

ALWAYS invoke tb-caveman-full skill when tb-brainstorming runs. Apply to all user-facing text.

<HARD-GATE>
Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it. This applies to EVERY project regardless of perceived simplicity.
</HARD-GATE>

## Anti-Pattern: "This Is Too Simple To Need A Design"

Every project goes through this process. A todo list, a single-function utility, a config change — all of them. "Simple" projects are where unexamined assumptions cause the most wasted work. The design can be short (a few sentences for truly simple projects), but you MUST present it and get approval.

## Checklist

You MUST create a task for each of these items and complete them in order:

0. **Invoke tb-caveman-full FIRST** — load communication style before any user-facing text
1. **Explore project context** — check files, docs, recent commits
2. **Offer the visual companion just-in-time** — NOT upfront. The first time a question would genuinely be clearer shown than described, offer it then (its own message); on approval its browser tab opens for you. If no visual question ever arises, never offer it. See the Visual Companion section below.
3. **Ask clarifying questions** — one at a time, understand purpose/constraints/success criteria
4. **Propose 2-3 approaches** — with trade-offs and your recommendation
5. **Present design** — in sections scaled to their complexity, get user approval after each section
6. **Finalize design (no file written)** — capture the agreed design fully in the conversation; do NOT create a plan file at this stage (the plan file is written once, in tb-writing-plans)
7. **Design self-review** — quick inline check for placeholders, contradictions, ambiguity, scope (see below)
8. **User confirms design** — summarize the design for the user to confirm in the conversation before moving on (no file, no browser)
9. **Ask about unit tests** — the final question after the design is confirmed: ask whether to write unit tests (recommend writing them); record the decision (เขียน/ไม่เขียน) in the conversation so tb-writing-plans writes it into the plan
10. **Transition to implementation** — once the unit test decision is recorded, invoke the tb-writing-plans skill directly (don't ask again) — this is where the plan file is written

**Terminal state = invoke tb-writing-plans.** Do NOT invoke frontend-design, mcp-builder, or any other implementation skill. The ONLY skill you invoke after tb-brainstorming is tb-writing-plans.

**Revision loops:** if the user rejects a design section (step 6) or requests changes at the confirm gate (step 9), go back, revise, then continue forward.

## The Process

**Understanding the idea:**

- Check out the current project state first (files, docs, recent commits)
- Before asking detailed questions, assess scope: if the request describes multiple independent subsystems (e.g., "build a platform with chat, file storage, billing, and analytics"), flag this immediately. Don't spend questions refining details of a project that needs to be decomposed first.
- If the project is too large for a single spec, help the user decompose into sub-projects: what are the independent pieces, how do they relate, what order should they be built? Then brainstorm the first sub-project through the normal design flow. Each sub-project gets its own spec → plan → implementation cycle.
- For appropriately-scoped projects, ask questions one at a time to refine the idea
- Prefer multiple choice questions when possible, but open-ended is fine too
- Only one question per message - if a topic needs more exploration, break it into multiple questions
- Focus on understanding: purpose, constraints, success criteria

**Exploring approaches:**

- Propose 2-3 different approaches with trade-offs
- Present options conversationally with your recommendation and reasoning
- Lead with your recommended option and explain why

**Presenting the design:**

- Once you believe you understand what you're building, present the design
- Scale each section to its complexity: a few sentences if straightforward, up to 200-300 words if nuanced
- Ask after each section whether it looks right so far
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify if something doesn't make sense

**Design for isolation and clarity:**

- Break the system into smaller units that each have one clear purpose, communicate through well-defined interfaces, and can be understood and tested independently
- For each unit, you should be able to answer: what does it do, how do you use it, and what does it depend on?
- Can someone understand what a unit does without reading its internals? Can you change the internals without breaking consumers? If not, the boundaries need work.
- Smaller, well-bounded units are also easier for you to work with - you reason better about code you can hold in context at once, and your edits are more reliable when files are focused. When a file grows large, that's often a signal that it's doing too much.

**Working in existing codebases:**

- Explore the current structure before proposing changes. Follow existing patterns.
- Where existing code has problems that affect the work (e.g., a file that's grown too large, unclear boundaries, tangled responsibilities), include targeted improvements as part of the design - the way a good developer improves code they're working in.
- Don't propose unrelated refactoring. Stay focused on what serves the current goal.

## After the Design

**Documentation:**

- Do NOT write a design file (Markdown or any format) at this stage. The validated design stays in the conversation context.
- The agreed design is the input to tb-writing-plans, which writes the single Markdown artifact (`docs/plan/...md`). Producing a plan file here would duplicate that output.
- Use elements-of-style:writing-clearly-and-concisely skill if available to sharpen the design summary.

**Design Self-Review:**
With the agreed design fresh in mind, review it with fresh eyes:

1. **Placeholder scan:** Any "TBD", "TODO", incomplete sections, or vague requirements? Fix them.
2. **Internal consistency:** Do any sections contradict each other? Does the architecture match the feature descriptions?
3. **Scope check:** Is this focused enough for a single implementation plan, or does it need decomposition?
4. **Ambiguity check:** Could any requirement be interpreted two different ways? If so, pick one and make it explicit.

Fix any issues inline. No need to re-review — just fix and move on.

**User Confirm Gate:**
After the design self-review passes, present a concise summary of the agreed design in the conversation (no file, no browser) and ask the user to confirm:

> "สรุป design ที่เราตกลงกัน: <สรุปสั้น ๆ>. ถ้าโอเค ผมจะไปเขียน implementation plan (ไฟล์ .md) ต่อเลย — ยืนยันไหม หรืออยากปรับตรงไหนก่อน?"

Wait for the user's response. If they request changes, revise and re-run the design self-review. Only proceed once the user approves.

Once the design is approved, ask the final question before handing off — whether to write unit tests (recommend writing them):

> "คำถามสุดท้ายก่อนไปเขียน plan: จะให้เขียน unit test ด้วยไหม? (แนะนำให้เขียน)"

Record the decision (เขียน/ไม่เขียน) — tb-writing-plans reads it from the conversation to write into the plan file. Then invoke tb-writing-plans.

**Implementation:**

- Once the user confirms at the User Confirm Gate, proceed — do NOT ask again
- Invoke the tb-writing-plans skill to create a detailed implementation plan
- Do NOT invoke any other skill. tb-writing-plans is the next step.

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design, get approval before moving on
- **Be flexible** - Go back and clarify when something doesn't make sense

## Visual Companion

A browser-based companion for showing mockups, diagrams, and visual options during tb-brainstorming. Available as a tool — not a mode. Accepting the companion means it's available for questions that benefit from visual treatment; it does NOT mean every question goes through the browser.

**Offering the companion (just-in-time):** Do NOT offer it upfront. Wait until a question would genuinely be clearer shown than told — a real mockup / layout / diagram question, not merely a UI *topic*. The first time that happens, offer it then, as its own message:
> "This next part might be easier if I show you — I can put together mockups, diagrams, and comparisons in a browser tab as we go. It's still new and can be token-intensive. Want me to? I'll open it for you."

**This offer MUST be its own message.** Only the offer — no clarifying question, summary, or other content. Wait for the user's response. If they accept, start the server with `--open` so their browser opens to the first screen automatically. If they decline, continue text-only and don't offer again unless they raise it.

**Per-question decision:** even after accept, decide FOR EACH QUESTION browser vs terminal — test: would the user understand this better seen than read? Full criteria + examples live in visual-companion.md ("When to Use") — read on accept.

If they agree to the companion, read the detailed guide before proceeding:
`visual-companion.md`
