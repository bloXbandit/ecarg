#!/usr/bin/env bash
# session-extractor.sh
#
# Post-session hook — runs automatically when an ecarg session ends.
# Extracts only durable facts from the conversation and appends them
# to BRAIN/memory/ecarg.md with a cache weight tag.
#
# Cost: one gpt-4o-mini call, capped at 300 output tokens.
# Skips: sessions under 6 messages (nothing worth saving).
#
# Called by moltbot via hooks.onSessionEnd in moltbot.json.
# Args: $1 = session file path (jsonl)

set -euo pipefail

SESSION_FILE="${1:-}"
BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
MEMORY_FILE="$BRAIN_DIR/memory/ecarg.md"
MIN_MESSAGES=6
MAX_CHARS=6000   # how much of the session transcript to send — keeps the call cheap

mkdir -p "$(dirname "$MEMORY_FILE")"

# ── locate session file if not passed ────────────────────────────────────────

if [ -z "$SESSION_FILE" ]; then
  SESSION_DIR="$HOME/.clawdbot/agents/ecarg/sessions"
  SESSION_FILE=$(ls -t "$SESSION_DIR"/*.jsonl 2>/dev/null | head -1 || true)
fi

if [ -z "$SESSION_FILE" ] || [ ! -f "$SESSION_FILE" ]; then
  exit 0
fi

# ── skip short sessions ───────────────────────────────────────────────────────

MSG_COUNT=$(grep -c '"role"' "$SESSION_FILE" 2>/dev/null || echo 0)
if [ "$MSG_COUNT" -lt "$MIN_MESSAGES" ]; then
  exit 0
fi

# ── extract user+assistant text only, truncated ───────────────────────────────

TRANSCRIPT=$(
  python3 - "$SESSION_FILE" "$MAX_CHARS" <<'PY'
import sys, json, textwrap

path, max_chars = sys.argv[1], int(sys.argv[2])
lines = []
with open(path) as f:
    for line in f:
        try:
            obj = json.loads(line)
        except Exception:
            continue
        role = obj.get("role", "")
        content = obj.get("content", "")
        if isinstance(content, list):
            content = " ".join(p.get("text","") for p in content if isinstance(p,dict))
        if role in ("user", "assistant") and content.strip():
            lines.append(f"{role.upper()}: {content.strip()}")

text = "\n".join(lines)
# keep tail — recent context is most relevant
if len(text) > max_chars:
    text = "...(truncated)...\n" + text[-max_chars:]
print(text)
PY
)

if [ -z "$TRANSCRIPT" ]; then
  exit 0
fi

# ── call gpt-4o-mini to extract durable facts ─────────────────────────────────

PROMPT="You are a memory extractor for an AI agent named Ecarg. Read this conversation and extract ONLY facts worth remembering long-term.

Rules:
- Extract: preferences stated, decisions made, project facts (non-obvious), corrections given, patterns that worked
- Skip: task steps, greetings, things derivable from code/git, general knowledge, anything already obvious
- If nothing is worth saving, output exactly: NOTHING
- Output format (one block per fact, nothing else):

[WEIGHT:high|medium|low] [CATEGORY:preference|decision|project|correction|pattern]
<one or two sentences: what + why>

Weight guide:
- high = core preference or behaviour rule — always relevant
- medium = project decision or pattern — relevant when that project comes up
- low = minor fact — only inject when strongly matching

---
CONVERSATION:
$TRANSCRIPT"

RESPONSE=$(curl -sf https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$(jq -nc \
    --arg model "gpt-4o-mini" \
    --arg prompt "$PROMPT" \
    '{model:$model,max_tokens:300,temperature:0,messages:[{role:"user",content:$prompt}]}'
  )" | jq -r '.choices[0].message.content // ""')

if [ -z "$RESPONSE" ] || [ "$RESPONSE" = "NOTHING" ]; then
  exit 0
fi

# ── append to memory file ─────────────────────────────────────────────────────

TIMESTAMP=$(date +%Y-%m-%d)
SESSION_ID=$(basename "$SESSION_FILE" .jsonl)

cat >> "$MEMORY_FILE" <<ENTRY

<!-- session: $SESSION_ID | extracted: $TIMESTAMP -->
$RESPONSE
ENTRY

echo "🧠 session memory saved ($(echo "$RESPONSE" | grep -c '^\[WEIGHT' || true) entries)"
