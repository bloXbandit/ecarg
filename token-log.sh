#!/usr/bin/env bash
# Parse Moltbot JSONL session logs and report token/cost usage.
set -euo pipefail

BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
SESSION_DIR="${SESSION_DIR:-$HOME/.clawdbot/agents/ecarg/sessions}"
LOG_FILE="${TOKEN_USAGE_LOG:-$BRAIN_DIR/logs/token_usage.log}"
MODE="${1:---today}"
mkdir -p "$(dirname "$LOG_FILE")"

case "$MODE" in
  --today|--all|--summary) ;;
  *) echo "Usage: $0 [--today|--all|--summary]" >&2; exit 2 ;;
esac

if [ "$MODE" = "--summary" ]; then
  [ -f "$LOG_FILE" ] && cat "$LOG_FILE" || echo "No token log yet at $LOG_FILE"
  exit 0
fi

[ -d "$SESSION_DIR" ] || { echo "No session dir found at $SESSION_DIR" >&2; exit 1; }

python3 - "$SESSION_DIR" "$LOG_FILE" "$MODE" <<'PY'
import json, sys
from pathlib import Path
from collections import defaultdict
from datetime import datetime, timezone

session_dir = Path(sys.argv[1])
log_file = Path(sys.argv[2])
mode = sys.argv[3]
today = datetime.now().astimezone().date()

# Fallback estimates, USD per 1M tokens. Provider logged cost wins when nonzero.
PRICE = {
    "gpt-5.5": {"input": 3.00, "output": 15.00, "cacheRead": 0.30, "cacheWrite": 3.00},
    "gpt-5.4": {"input": 2.00, "output": 10.00, "cacheRead": 0.20, "cacheWrite": 2.00},
    "gpt-5.4-mini": {"input": 0.15, "output": 0.60, "cacheRead": 0.015, "cacheWrite": 0.15},
    "gpt-4o-mini": {"input": 0.15, "output": 0.60, "cacheRead": 0.075, "cacheWrite": 0.15},
}

def parse_ts(value):
    if not isinstance(value, str):
        return None
    try:
        return datetime.fromisoformat(value.replace("Z", "+00:00"))
    except Exception:
        return None

def model_key(model):
    if not model:
        return "unknown"
    return str(model).split("/")[-1]

def estimate(model, u):
    p = PRICE.get(model_key(model), {})
    return sum((float(u.get(k) or 0) / 1_000_000) * float(p.get(k, 0)) for k in ("input", "output", "cacheRead", "cacheWrite"))

def usage_cost(u, model):
    c = u.get("cost") if isinstance(u.get("cost"), dict) else {}
    total = c.get("total")
    if isinstance(total, (int, float)) and total > 0:
        return float(total), "logged"
    return estimate(model, u), "estimated"

files = sorted(session_dir.glob("*.jsonl"))
rows = []
by_model = defaultdict(lambda: {"input":0,"output":0,"cacheRead":0,"cacheWrite":0,"totalTokens":0,"calls":0,"cost":0.0})
grand = {"input":0,"output":0,"cacheRead":0,"cacheWrite":0,"totalTokens":0,"calls":0,"cost":0.0}

for path in files:
    sess = {"input":0,"output":0,"cacheRead":0,"cacheWrite":0,"totalTokens":0,"calls":0,"cost":0.0}
    models = defaultdict(int)
    first_ts = last_ts = None
    include_file = mode == "--all"

    with path.open("r", encoding="utf-8", errors="replace") as f:
        for line in f:
            try:
                obj = json.loads(line)
            except Exception:
                continue
            ts = parse_ts(obj.get("timestamp"))
            if ts:
                first_ts = first_ts or ts
                last_ts = ts
                if mode == "--today" and ts.astimezone().date() == today:
                    include_file = True
            msg = obj.get("message") if isinstance(obj.get("message"), dict) else {}
            if msg.get("role") != "assistant":
                continue
            u = msg.get("usage") if isinstance(msg.get("usage"), dict) else None
            if not u:
                continue
            if mode == "--today" and ts and ts.astimezone().date() != today:
                continue
            model = model_key(msg.get("model") or obj.get("model") or "unknown")
            vals = {k:int(u.get(k) or 0) for k in ("input","output","cacheRead","cacheWrite","totalTokens")}
            if not any(vals.values()):
                continue
            cost, _source = usage_cost(u, model)
            for k,v in vals.items():
                sess[k] += v; by_model[model][k] += v; grand[k] += v
            sess["calls"] += 1; by_model[model]["calls"] += 1; grand["calls"] += 1
            sess["cost"] += cost; by_model[model]["cost"] += cost; grand["cost"] += cost
            models[model] += 1

    if include_file and sess["calls"]:
        top_model = max(models.items(), key=lambda x: x[1])[0] if models else "unknown"
        rows.append((path.stem, top_model, first_ts, last_ts, sess))

stamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S %Z")
period = "today" if mode == "--today" else "all sessions"
out = ["="*86, f"TOKEN USAGE — {stamp} — {period}", "="*86]
if not rows:
    out.append("No usage rows found.")
else:
    out.append("Sessions:")
    for sid, model, first_ts, last_ts, s in rows:
        out.append(f"  {sid[:24]:<24} {model:<16} in:{s['input']:>8} out:{s['output']:>7} cacheR:{s['cacheRead']:>8} cacheW:{s['cacheWrite']:>7} calls:{s['calls']:>4} ${s['cost']:.5f}")
out.append("\nBy model:")
for model, d in sorted(by_model.items(), key=lambda kv: kv[1]["cost"], reverse=True):
    if d["calls"]:
        out.append(f"  {model:<20} in:{d['input']:>9} out:{d['output']:>8} cacheR:{d['cacheRead']:>9} cacheW:{d['cacheWrite']:>8} calls:{d['calls']:>5} ${d['cost']:.5f}")
out.append(f"\nTOTAL                in:{grand['input']:>9} out:{grand['output']:>8} cacheR:{grand['cacheRead']:>9} cacheW:{grand['cacheWrite']:>8} calls:{grand['calls']:>5} ${grand['cost']:.5f}")
out.append("Note: uses logged provider cost when present; otherwise fallback estimates from scripts/token-log.sh.")
out.append("="*86)
report = "\n".join(out)
print(report)
with log_file.open("a", encoding="utf-8") as f:
    f.write(report + "\n")
print(f"\nAppended to {log_file}")
PY
