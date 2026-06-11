---
name: dump
description: Clear current session history on demand. Memory checkpoints survive — agent remembers everything important. Trigger on "dump", "trash session", "clear session", "fresh start".
metadata: {"moltbot":{"emoji":"🗑️","requires":{"bins":["bash"]}}}
---

# dump — Session Clear

Clears conversation history for a clean slate. Memory (BRAIN/memory/) is untouched — checkpoints, preferences, corrections, and project facts all survive. Next prompt starts fresh but agent still knows what matters.

## Run

```bash
bash /home/bpwonka/apps/moltbot/scripts/dump-session.sh
```

Moves session files to `BRAIN/trash/sessions/<timestamp>/` — recoverable if needed.

## After dump

Reply: "🗑️ Session cleared. Memory intact — I still know what matters."

Then wait for next prompt. Do not summarise what was in the session. Do not carry over any conversation context. Fresh start.

## Only bpwonka can call this

Do not auto-dump. Do not suggest dumping unless session is clearly stuck or bpwonka is frustrated. This is an on-demand tool only.
