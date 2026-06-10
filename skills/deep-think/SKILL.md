---
name: deep-think
description: Route a task to ecarg-deep (gpt-5.5, thinking:medium) when it requires deep reasoning, code review, architecture decisions, debugging, or research. Handles the handoff and returns the answer seamlessly.
metadata: {"moltbot":{"emoji":"🧠"}}
---

# deep-think — Routing to ecarg-deep

ecarg runs on gpt-4o-mini — fast and cheap for all normal conversation.
When a task needs real reasoning depth, route it to ecarg-deep (gpt-5.5, thinking:medium).

The handoff is invisible to bpwonka. ecarg relays the answer directly, no meta-commentary.

---

## When to route

Route to ecarg-deep when the task involves:
- Code review, debugging, or architecture decisions
- Multi-step reasoning or research
- Writing or refactoring non-trivial code
- Analysing a file, log, or data set
- Any question where "let me think through this" is the honest answer

Do NOT route for:
- Casual chat, short questions, status checks
- Mode switches (mortgage mode, etc.)
- Simple lookups or one-liners
- Anything answerable in 1–2 sentences without reasoning

---

## How to route

Use the `sessions_spawn` tool with `agentId: "ecarg-deep"` and `thinking: "medium"`.

Construct a **self-contained prompt** — do not pass raw conversation history.
Distil into: what's needed, relevant context only, expected output format.

```
sessions_spawn({
  agentId: "ecarg-deep",
  thinking: "medium",
  task: `
[TASK]
<clear statement of what needs to be done>

[CONTEXT]
<only what's directly relevant — file snippets, error messages, prior decisions>
<strip anything unrelated to this specific task>

[OUTPUT]
<what format / level of detail you want back>
`
})
```

Keep the context block under 2000 tokens where possible.
Get the answer back, relay it to bpwonka directly — no "I asked another agent" framing unless asked.

Valid thinking levels: off, minimal, low, medium, high, xhigh.
Use `medium` for most deep tasks. `high` only for complex architecture or hard debugging.

---

## Cost awareness

ecarg-deep (gpt-5.5) costs ~20–100x more per call than ecarg (gpt-4o-mini).
A tight 1000-token prompt + 500-token answer ≈ $0.01.
A sloppy 8000-token dump ≈ $0.15+.

**Distil before routing. The smaller the prompt, the cheaper the answer.**
