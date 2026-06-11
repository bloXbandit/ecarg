---
name: budget-check
description: Check daily token spend and per-prompt cost before any heavy model call. Auto-runs before routing to ecarg-deep. Trigger manually on "budget", "how much today", "spend check".
metadata: {"moltbot":{"emoji":"💸","requires":{"bins":["python3"]}}}
---

# budget-check

Hard limits:
- **$2.00/day** — blocks all model calls if hit
- **$0.02/prompt** — warns on fat inputs, suggests trimming

## Run before any ecarg-deep call

```bash
bash /home/bpwonka/apps/moltbot/scripts/budget-check.sh --json
```

- Exit 0 → proceed
- Exit 1 → daily cap hit — do not call ecarg-deep, tell bpwonka
- Exit 2 → prompt too large — trim context before routing

## Manual spend check

```bash
bash /home/bpwonka/apps/moltbot/scripts/budget-check.sh
```

## Check with prompt size estimate

```bash
bash /home/bpwonka/apps/moltbot/scripts/budget-check.sh --chars <input_char_count>
```

## Rules

- Always run this before sessions_spawn to ecarg-deep
- If daily cap is hit: reply "Daily budget reached ($2.00). Reset tomorrow." — no model call
- If prompt cap warning: trim the context block, try again
- Do not silently skip the check to be helpful — the cap exists for a reason
