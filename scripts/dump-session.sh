#!/usr/bin/env bash
# dump-session.sh
#
# Clears the current session history for ecarg.
# Memory checkpoints (BRAIN/memory/) are NOT touched — context survives.
# Called by the dump skill when bpwonka says "dump" or "trash session".
#
# Usage: bash scripts/dump-session.sh [agentId]

set -euo pipefail

AGENT_ID="${1:-ecarg}"
SESSION_DIR="$HOME/.clawdbot/agents/$AGENT_ID/sessions"
BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"

if [ ! -d "$SESSION_DIR" ]; then
  echo "No session dir found at $SESSION_DIR"
  exit 0
fi

# count before
COUNT=$(ls "$SESSION_DIR"/*.jsonl 2>/dev/null | wc -l || echo 0)

if [ "$COUNT" -eq 0 ]; then
  echo "No sessions to clear."
  exit 0
fi

# move to trash (recoverable) rather than hard delete
TRASH_DIR="$BRAIN_DIR/trash/sessions/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$TRASH_DIR"
mv "$SESSION_DIR"/*.jsonl "$TRASH_DIR/" 2>/dev/null || true

echo "🗑️  $COUNT session file(s) cleared → $TRASH_DIR"
echo "Memory checkpoints intact at $BRAIN_DIR/memory/"
echo "Fresh session starts on next prompt."
