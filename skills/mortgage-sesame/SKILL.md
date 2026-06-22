**Network Note:** You are running on the Raspberry Pi. Use the bash/exec tool for LAN calls. `192.168.0.35:8000` is reachable from this machine when MortgageSesame is online. Do not refuse private IP access by default.

---
name: mortgage-sesame
description: Interact with the MortgageSesame backend API and manage Mortgage Mode — a focused session context for mortgage platform work. Triggers on "mortgage mode", "mortgage sesame", "ms mode", or any MortgageSesame API request. Auto-exits after 30 minutes of silence.
metadata: {"moltbot":{"emoji":"🏠","requires":{"bins":["curl","jq"],"env":["BACKEND_URL","AGENT_API_KEY"]}}}
---

# MortgageSesame — Mortgage Mode

FastAPI backend on LAN: `http://192.168.0.35:8000`
Auth: `Bearer $AGENT_API_KEY`
Mode state: `$BRAIN_DIR/sessions/mortgage_mode.json`

---

## Mortgage Mode

A focused session context. While active, Ecarg prioritises MortgageSesame API calls,
keeps context tight to mortgage tasks, and reminds bpwonka of mode status on each reply.

### Enter mode

Triggered by any of:
- "mortgage mode on"
- "mortgage sesame"
- "ms mode"
- Any direct MortgageSesame API request

```bash
BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
echo "{\"active\":true,\"entered_at\":$(date +%s),\"last_activity\":$(date +%s)}" \
  > "${BRAIN_DIR}/sessions/mortgage_mode.json"
echo "🏠 Mortgage Mode ON"
```

### Update activity (call this on every response while in mode)

```bash
BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
STATE="${BRAIN_DIR}/sessions/mortgage_mode.json"
if [ -f "$STATE" ]; then
  ENTERED=$(jq -r '.entered_at' "$STATE")
  echo "{\"active\":true,\"entered_at\":${ENTERED},\"last_activity\":$(date +%s)}" > "$STATE"
fi
```

### Check mode + auto-logout (call on each prompt while mode may be active)

```bash
BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
STATE="${BRAIN_DIR}/sessions/mortgage_mode.json"
TIMEOUT=1800  # 30 minutes

if [ ! -f "$STATE" ]; then echo "inactive"; exit 0; fi

ACTIVE=$(jq -r '.active' "$STATE")
LAST=$(jq -r '.last_activity' "$STATE")
NOW=$(date +%s)
ELAPSED=$((NOW - LAST))

if [ "$ACTIVE" != "true" ]; then echo "inactive"; exit 0; fi

if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
  echo "{\"active\":false,\"entered_at\":$(jq -r '.entered_at' "$STATE"),\"last_activity\":$LAST,\"exited_at\":$NOW,\"reason\":\"timeout\"}" > "$STATE"
  echo "timeout"
else
  REMAINING=$(( (TIMEOUT - ELAPSED) / 60 ))
  echo "active — ${REMAINING}m remaining"
fi
```

### Exit mode (manual)

Triggered by:
- "mortgage mode off"
- "exit mortgage mode"
- "ms off"

```bash
BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
STATE="${BRAIN_DIR}/sessions/mortgage_mode.json"
if [ -f "$STATE" ]; then
  ENTERED=$(jq -r '.entered_at' "$STATE")
  LAST=$(jq -r '.last_activity' "$STATE")
  echo "{\"active\":false,\"entered_at\":${ENTERED},\"last_activity\":${LAST},\"exited_at\":$(date +%s),\"reason\":\"manual\"}" > "$STATE"
fi
echo "🏠 Mortgage Mode OFF"
```

---

## Behaviour while in Mortgage Mode

- Prefix replies with `🏠` to signal mode is active
- Focus responses on mortgage tasks — don't drift to unrelated topics
- Update `last_activity` timestamp on every response
- If check returns `timeout`: announce exit before responding — "Mortgage Mode ended (30 min inactivity)"
- If check returns `active`: continue, no announcement needed unless asked

---

## API — health check

```bash
curl -sf --connect-timeout 5 "${BACKEND_URL}/health" \
  -H "Authorization: Bearer $AGENT_API_KEY" | jq .
```

## API — GET endpoint

```bash
curl -sf "${BACKEND_URL}/api/v1/<endpoint>" \
  -H "Authorization: Bearer $AGENT_API_KEY" | jq .
```

## API — POST with JSON

```bash
curl -sf -X POST "${BACKEND_URL}/api/v1/<endpoint>" \
  -H "Authorization: Bearer $AGENT_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}' | jq .
```

## API — upload a document

```bash
curl -sf -X POST "${BACKEND_URL}/api/v1/documents/upload" \
  -H "Authorization: Bearer $AGENT_API_KEY" \
  -F "file=@${BRAIN_DIR}/downloads/<filename>" | jq .
```

## API docs (browser)

`http://192.168.0.35:8000/docs`

---

## Notes

- Files for upload: pull via `tg-download` skill → `BRAIN/downloads/` → POST here
- Backend offline: `curl -sf --connect-timeout 3 "${BACKEND_URL}/health" || echo "Backend offline"`
- `jq` required for JSON parsing — install with `sudo apt install jq` if missing
