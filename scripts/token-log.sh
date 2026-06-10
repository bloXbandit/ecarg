#!/usr/bin/env bash
# token-log.sh
#
# Parses moltbot session JSONL files and produces a line-item token usage report.
# Reads OpenAI usage fields (prompt_tokens, completion_tokens, total_tokens) logged
# per assistant turn, tallies by session, and appends a daily summary to
# BRAIN/logs/token_usage.log
#
# Usage:
#   bash scripts/token-log.sh              # report today's sessions
#   bash scripts/token-log.sh --all        # report all sessions
#   bash scripts/token-log.sh --summary    # just print running totals from log
#
# Costs (update if model pricing changes):
#   gpt-5.5:      $3.00 / 1M input,  $15.00 / 1M output
#   gpt-5.4:      $2.00 / 1M input,  $10.00 / 1M output
#   gpt-5.4-mini: $0.15 / 1M input,   $0.60 / 1M output
#   gpt-4o-mini:  $0.15 / 1M input,   $0.60 / 1M output
#
# Hook into daily cron or call manually from Telegram: "token usage"

set -euo pipefail

BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
SESSION_DIR="${HOME}/.clawdbot/agents/ecarg/sessions"
LOG_FILE="${BRAIN_DIR}/logs/token_usage.log"
MODE="${1:---today}"

mkdir -p "$(dirname "$LOG_FILE")"

# ── model cost table (per 1M tokens) ─────────────────────────────────────────

declare -A INPUT_COST=(
  ["gpt-5.5"]="3.00"
  ["gpt-5.4"]="2.00"
  ["gpt-5.4-mini"]="0.15"
  ["gpt-4o-mini"]="0.15"
)
declare -A OUTPUT_COST=(
  ["gpt-5.5"]="15.00"
  ["gpt-5.4"]="10.00"
  ["gpt-5.4-mini"]="0.60"
  ["gpt-4o-mini"]="0.60"
)

# ── summary mode — just print the log ────────────────────────────────────────

if [ "$MODE" = "--summary" ]; then
  if [ ! -f "$LOG_FILE" ]; then
    echo "No token log yet at $LOG_FILE"
    exit 0
  fi
  cat "$LOG_FILE"
  exit 0
fi

# ── select sessions to parse ─────────────────────────────────────────────────

if [ ! -d "$SESSION_DIR" ]; then
  echo "No session dir found at $SESSION_DIR"
  exit 1
fi

if [ "$MODE" = "--all" ]; then
  FILES=$(ls "$SESSION_DIR"/*.jsonl 2>/dev/null || true)
else
  # today only
  TODAY=$(date +%Y-%m-%d)
  FILES=$(find "$SESSION_DIR" -name "*.jsonl" -newer /tmp/.token-log-sentinel 2>/dev/null || \
          find "$SESSION_DIR" -name "*.jsonl" | xargs ls -t | head -20 || true)
  touch /tmp/.token-log-sentinel
fi

if [ -z "$FILES" ]; then
  echo "No sessions found."
  exit 0
fi

# ── parse and report ──────────────────────────────────────────────────────────

python3 - "$LOG_FILE" $FILES <<'PY'
import sys, json, os
from collections import defaultdict
from datetime import datetime

log_file = sys.argv[1]
session_files = sys.argv[2:]

# cost table
input_cost  = {"gpt-5.5":3.00,"gpt-5.4":2.00,"gpt-5.4-mini":0.15,"gpt-4o-mini":0.15}
output_cost = {"gpt-5.5":15.00,"gpt-5.4":10.00,"gpt-5.4-mini":0.60,"gpt-4o-mini":0.60}

def model_cost(model, inp, out):
    ic = input_cost.get(model, 0)
    oc = output_cost.get(model, 0)
    return (inp / 1_000_000 * ic) + (out / 1_000_000 * oc)

totals = defaultdict(lambda: {"input":0,"output":0,"calls":0,"cost":0.0})
lines = []
grand_input = grand_output = grand_calls = 0
grand_cost = 0.0

for path in sorted(session_files):
    sid = os.path.basename(path).replace(".jsonl","")
    sess_input = sess_output = sess_calls = 0
    sess_cost = 0.0
    model = "gpt-5.5"  # default

    try:
        with open(path) as f:
            for line in f:
                try:
                    obj = json.loads(line)
                except:
                    continue
                # pick up model name if logged
                if obj.get("model"):
                    model = obj["model"].split("/")[-1]
                usage = obj.get("usage") or obj.get("token_usage") or {}
                inp = usage.get("prompt_tokens") or usage.get("input_tokens") or 0
                out = usage.get("completion_tokens") or usage.get("output_tokens") or 0
                if inp or out:
                    cost = model_cost(model, inp, out)
                    sess_input  += inp
                    sess_output += out
                    sess_calls  += 1
                    sess_cost   += cost
                    totals[model]["input"]  += inp
                    totals[model]["output"] += out
                    totals[model]["calls"]  += 1
                    totals[model]["cost"]   += cost
    except Exception as e:
        lines.append(f"  WARN: could not parse {sid}: {e}")
        continue

    if sess_calls:
        grand_input  += sess_input
        grand_output += sess_output
        grand_calls  += sess_calls
        grand_cost   += sess_cost
        lines.append(
            f"  {sid[:30]:<30}  in:{sess_input:>7}  out:{sess_output:>6}  "
            f"calls:{sess_calls:>3}  ${sess_cost:.5f}"
        )

timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
report = [f"\n{'='*70}", f"  TOKEN REPORT — {timestamp}", f"{'='*70}"]
report += lines
report.append(f"\n  {'BY MODEL':-<50}")
for m, d in sorted(totals.items()):
    report.append(
        f"  {m:<20}  in:{d['input']:>8}  out:{d['output']:>7}  "
        f"calls:{d['calls']:>4}  ${d['cost']:.5f}"
    )
report.append(f"\n  {'TOTAL':<20}  in:{grand_input:>8}  out:{grand_output:>7}  "
              f"calls:{grand_calls:>4}  ${grand_cost:.5f}")
report.append(f"{'='*70}")

out_str = "\n".join(report)
print(out_str)

with open(log_file, "a") as f:
    f.write(out_str + "\n")

print(f"\n  Appended to {log_file}")
PY
