---
name: token-usage
description: Report token usage and estimated cost broken down by session and model. Trigger on "token usage", "how much have i spent", "cost report", "token report".
metadata: {"moltbot":{"emoji":"💰","requires":{"bins":["python3"]}}}
---

# token-usage — Cost Tracking

Parses session JSONL logs, tallies tokens per call, and reports cost line-by-line by session and model.
Appends a timestamped entry to `BRAIN/logs/token_usage.log` for history.

## Today's usage
```bash
BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
bash /home/bpwonka/apps/moltbot/scripts/token-log.sh --today
```

## All-time usage
```bash
bash /home/bpwonka/apps/moltbot/scripts/token-log.sh --all
```

## Running totals (log file only, no parsing)
```bash
bash /home/bpwonka/apps/moltbot/scripts/token-log.sh --summary
```

## Output format
```
======================================================================
  TOKEN REPORT — 2026-06-10 14:32
======================================================================
  abc123def456...              in:  1240  out:   380  calls:  4  $0.00621
  zyx987...                    in:   540  out:   120  calls:  2  $0.00180

  BY MODEL --------------------------------------------------
  gpt-5.5              in:    1780  out:    500  calls:   6  $0.00801
  gpt-4o-mini          in:       0  out:      0  calls:   0  $0.00000

  TOTAL                in:    1780  out:    500  calls:   6  $0.00801
======================================================================
```

## Cost rates (update if OpenAI changes pricing)

| Model | Input /1M | Output /1M |
|---|---|---|
| gpt-5.5 | $3.00 | $15.00 |
| gpt-5.4 | $2.00 | $10.00 |
| gpt-5.4-mini | $0.15 | $0.60 |
| gpt-4o-mini | $0.15 | $0.60 |

Update rates in `scripts/token-log.sh` cost table if pricing changes.
