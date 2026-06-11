---
name: deep-think
description: Route a task to ecarg-deep (gpt-5.5, thinking:medium) when it requires deep reasoning, code review, architecture decisions, debugging, or research. Handles budget check, handoff, result verification, and response tagging.
metadata: {"moltbot":{"emoji":"🧠"}}
---

# deep-think — Routing to ecarg-deep

ecarg runs on gpt-4o-mini. When a task needs real depth, route to ecarg-deep (gpt-5.5, thinking:medium).
The answer comes back tagged `(deep)` so bpwonka knows which model answered.

---

## Step 1 — Budget check (always first)

```bash
bash /home/bpwonka/apps/moltbot/scripts/budget-check.sh --json
```

- Exit 0 → proceed
- Exit 1 → reply: "Daily budget reached ($2.00). No deep calls today." — STOP
- Exit 2 → trim the context prompt, try again — do not proceed with fat input

---

## Step 2 — Build a self-contained prompt

Do NOT pass raw conversation history. Distil:

```
[TASK]
<one clear statement of what needs to be done>

[CONTEXT]
<only what's directly relevant — file snippets, error messages, prior decisions>
<strip everything unrelated to this specific task>

[OUTPUT]
<format and detail level expected>
```

Keep context block under 2000 tokens. If it's over, cut more.

---

## Step 3 — Spawn ecarg-deep

```
sessions_spawn({
  agentId: "ecarg-deep",
  thinking: "medium",
  task: "<your distilled prompt above>"
})
```

Use `thinking: "high"` only for complex architecture or hard multi-step debugging.
Use `thinking: "low"` for lighter reasoning tasks to save cost.

---

## Step 4 — Verify the result

Before relaying the answer, check:
- `result.status` is not "error"
- Result is not empty or a refusal
- Answer actually addresses the task

If the spawn failed or returned empty:
```
Reply: "ecarg-deep didn't return a usable answer. [state what failed]"
```
Do not fabricate an answer. Do not guess what ecarg-deep would have said.

---

## Step 5 — Relay with tag

Prepend `(deep)` to the response so bpwonka knows it came from ecarg-deep:

```
(deep) <ecarg-deep's answer>
```

No other framing. No "I asked another agent." Just the tag and the answer.

---

## When to route

Route when the task involves:
- Code review, debugging, refactoring non-trivial code
- Architecture decisions or design choices
- Multi-step reasoning or research
- Analysing files, logs, or data sets
- Any question where thinking through the problem is required

## When NOT to route

- Casual chat, short questions, status checks
- Mode switches
- Anything answerable in 1–2 sentences without reasoning
- When daily budget is hit

---

## Cost awareness

ecarg-deep (gpt-5.5) costs ~20–100x more per call than ecarg.
Tight 1000-token prompt + 500-token answer ≈ $0.01.
Sloppy 8000-token dump ≈ $0.15+.

Distil before routing. Always.
