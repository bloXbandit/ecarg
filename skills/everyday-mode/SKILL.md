---
name: everyday-mode
description: Default lean session mode for general tasks, quick questions, and casual conversation. Minimal context, fast, cheap. Active unless another mode is triggered.
metadata: {"moltbot":{"emoji":"⚡"}}
---

# everyday-mode — Default Session

The default state. No mode prefix needed.

## Context rules

- Load: last 2 turns only + high-weight memory hits (minScore 0.62, max 3 results)
- Do NOT inject: full conversation history, project files, API docs
- Bootstrap: SOUL.md identity block only (1500 chars max)
- Target: 1–3K tokens round trip

## Response rules

- Answer first, explain only if asked
- If the answer fits in one line — one line
- No summaries of completed actions
- Do not pad responses to seem thorough

## When to stay in everyday mode

- Casual questions, status checks, quick tasks
- Anything answerable without project-specific context
- Mode switches ("mortgage mode", "research mode")

## When to exit everyday mode

- bpwonka explicitly triggers mortgage / research-trading mode
- Task clearly requires project context — ask which mode, don't guess

## Token target

Input: under 2K tokens. Output: under 1K. If a response needs more, it probably needs a mode switch or ecarg-deep.
