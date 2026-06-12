#!/usr/bin/env bash
# budget-check.sh
#
# Gate keeper — call before any model prompt.
# Checks daily spend against $2.00 hard cap.
# Estimates prompt cost from input char count and warns if > $0.02.
#
# Exit codes:
#   0 = OK to proceed
#   1 = daily cap hit — block
#   2 = prompt too expensive — warn (caller decides whether to proceed)
#
# Usage:
#   bash scripts/budget-check.sh                    # daily cap check only
#   bash scripts/budget-check.sh --chars 4200       # also check prompt size
#   bash scripts/budget-check.sh --json             # machine-readable output

set -euo pipefail

BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
LOG_FILE="${TOKEN_USAGE_LOG:-$BRAIN_DIR/logs/token_usage.log}"
DAILY_CAP="${DAILY_CAP:-2.00}"
PROMPT_CAP="${PROMPT_CAP:-0.02}"
INPUT_CHARS=0
JSON_MODE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --chars) INPUT_CHARS="${2:-0}"; shift 2 ;;
    --json)  JSON_MODE=true; shift ;;
    *) shift ;;
  esac
done

# ── read today's spend from log ───────────────────────────────────────────────

TODAY_SPEND=0
if [ -f "$LOG_FILE" ]; then
  TODAY_SPEND=$(python3 - "$LOG_FILE" <<'PY'
import sys, re
from datetime import datetime

log = open(sys.argv[1]).read()
today = datetime.now().strftime("%Y-%m-%d")
total = 0.0
# find TOTAL lines in today's reports
for block in log.split("="*86):
    if today in block:
        m = re.search(r'TOTAL\s+in:\s*\d+\s+out:\s*\d+.*\$([0-9.]+)', block)
        if m:
            total += float(m.group(1))
print(f"{total:.5f}")
PY
  )
fi

TODAY_SPEND="${TODAY_SPEND:-0}"

# ── estimate this prompt cost (chars / 4 ≈ tokens, gpt-4o-mini input rate) ───

PROMPT_COST=0
if [ "$INPUT_CHARS" -gt 0 ]; then
  PROMPT_COST=$(python3 -c "
chars = $INPUT_CHARS
tokens = chars / 4
cost = (tokens / 1_000_000) * 0.15  # gpt-4o-mini input rate
print(f'{cost:.5f}')
")
fi

# ── evaluate ──────────────────────────────────────────────────────────────────

OVER_DAILY=$(python3 -c "print('1' if float('$TODAY_SPEND') >= float('$DAILY_CAP') else '0')")
OVER_PROMPT=$(python3 -c "print('1' if float('$PROMPT_COST') >= float('$PROMPT_CAP') else '0')")

if [ "$JSON_MODE" = true ]; then
  python3 -c "
import json
print(json.dumps({
  'today_spend': float('$TODAY_SPEND'),
  'daily_cap': float('$DAILY_CAP'),
  'prompt_cost_est': float('$PROMPT_COST'),
  'prompt_cap': float('$PROMPT_CAP'),
  'over_daily': bool($OVER_DAILY),
  'over_prompt': bool($OVER_PROMPT),
}))"
  [ "$OVER_DAILY" = "1" ] && exit 1
  [ "$OVER_PROMPT" = "1" ] && exit 2
  exit 0
fi

if [ "$OVER_DAILY" = "1" ]; then
  echo "🚫 Daily cap hit (\$$TODAY_SPEND / \$$DAILY_CAP). No more model calls today."
  exit 1
fi

if [ "$OVER_PROMPT" = "1" ]; then
  echo "⚠️  Prompt estimated at \$$PROMPT_COST — over \$$PROMPT_CAP limit. Trim input or confirm."
  exit 2
fi

echo "✅ Budget OK — today: \$$TODAY_SPEND / \$$DAILY_CAP"
exit 0
