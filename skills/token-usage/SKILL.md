---
name: token-usage
description: Report Moltbot token usage and estimated cost from local session JSONL logs. Use when asked "token usage", "cost report", "how much have I spent", or "token report".
metadata: {"moltbot":{"emoji":"💰","requires":{"bins":["python3"]}}}
---

# token-usage

Use the local script; it parses Moltbot JSONL logs under `~/.clawdbot/agents/ecarg/sessions`.

```bash
bash /home/bpwonka/apps/moltbot/scripts/token-log.sh --today
bash /home/bpwonka/apps/moltbot/scripts/token-log.sh --all
bash /home/bpwonka/apps/moltbot/scripts/token-log.sh --summary
```

The parser reads `message.usage.input`, `output`, `cacheRead`, `cacheWrite`, `totalTokens`, and logged `cost.total` when present. If logged cost is zero/missing, it uses fallback estimates in `scripts/token-log.sh`.
