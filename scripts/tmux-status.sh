#!/usr/bin/env bash
# tmux-status.sh
#
# Outputs a one-line token/cost summary for tmux status-right.
# Reads the latest TOKEN USAGE block from the log file.
#
# Add to ~/.tmux.conf:
#   set -g status-right '#(bash /home/bpwonka/apps/moltbot/scripts/tmux-status.sh)'
#   set -g status-interval 30
#
# Output example:
#   💰 in:1240 out:380 cache:60 $0.00310 | day:$0.021

BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
LOG_FILE="${TOKEN_USAGE_LOG:-$BRAIN_DIR/logs/token_usage.log}"

if [ ! -f "$LOG_FILE" ]; then
  echo "💰 no data"
  exit 0
fi

python3 - "$LOG_FILE" <<'PY'
import sys, re

log = open(sys.argv[1]).read()
blocks = [b for b in log.split("="*86) if "TOKEN USAGE" in b and "TOTAL" in b]

if not blocks:
    print("💰 no data")
    sys.exit(0)

# latest block
block = blocks[-1]

# today's total spend — sum all today's blocks
from datetime import datetime
today = datetime.now().strftime("%Y-%m-%d")
day_spend = 0.0
for b in blocks:
    if today in b:
        m = re.search(r'TOTAL\s+in:\s*\d+\s+out:\s*\d+.*\$([0-9.]+)', b)
        if m:
            day_spend += float(m.group(1))

# last call stats — find last session line
session_lines = [l for l in block.splitlines() if re.match(r'\s+\S{8,}', l) and 'in:' in l]
if session_lines:
    last = session_lines[-1]
    inp = re.search(r'in:\s*(\d+)', last)
    out = re.search(r'out:\s*(\d+)', last)
    cache = re.search(r'cacheR:\s*(\d+)', last)
    cost = re.search(r'\$([0-9.]+)\s*$', last)
    i = inp.group(1) if inp else "?"
    o = out.group(1) if out else "?"
    c = cache.group(1) if cache else "?"
    cc = cost.group(1) if cost else "?"
    print(f"💰 in:{i} out:{o} cR:{c} ${cc} | day:${day_spend:.4f}")
else:
    m = re.search(r'TOTAL\s+in:\s*(\d+)\s+out:\s*(\d+)\s+cacheR:\s*(\d+).*\$([0-9.]+)', block)
    if m:
        print(f"💰 in:{m.group(1)} out:{m.group(2)} cR:{m.group(3)} ${m.group(4)} | day:${day_spend:.4f}")
    else:
        print(f"💰 day:${day_spend:.4f}")
PY
