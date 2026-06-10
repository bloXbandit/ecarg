---
name: save-memory
description: Persist a fact, preference, decision, or learned pattern to long-term memory. Call this proactively when something worth remembering surfaces in conversation — without being asked.
metadata: {"moltbot":{"emoji":"🧠","requires":{"bins":["date"]}}}
---

# save-memory — Incremental Learning

Writes a compact entry to `BRAIN/memory/ecarg.md`. The file is watched and re-indexed into
SQLite vector search within 3 seconds — available for recall in future sessions automatically.

---

## When to save (save these)

- bpwonka states a preference, a rule, or a "don't do X"
- A decision is made that will affect future work (architecture choice, API selected, direction confirmed)
- A fact about a project that isn't obvious from the code (why something was done, what failed, what's next)
- A fix or workaround that took effort to find — so it's not re-derived next time
- bpwonka corrects Ecarg — save the correction as a rule

## When NOT to save (skip these)

- Ephemeral task state ("currently working on X") — that's in the conversation
- Things derivable from reading the code or git log
- General knowledge — only save what's specific to bpwonka, the projects, or Ecarg's behaviour
- Anything already in SOUL.md or a SKILL.md

---

## Write a memory entry

```bash
BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
MEMORY_FILE="${BRAIN_DIR}/memory/ecarg.md"
mkdir -p "$(dirname "$MEMORY_FILE")"

TIMESTAMP=$(date +%Y-%m-%d)
CATEGORY="$1"   # preference | decision | project | correction | pattern
BODY="$2"       # one or two tight sentences — what + why

cat >> "$MEMORY_FILE" <<ENTRY

## [$TIMESTAMP] $CATEGORY
$BODY
ENTRY

echo "🧠 saved"
```

**Categories:**
- `preference` — how bpwonka wants things done
- `decision` — architectural or directional call made
- `project` — non-obvious fact about WonkaTrade, MortgageSesame, Credit Kaddabra, etc.
- `correction` — Ecarg was wrong; record the right behaviour
- `pattern` — a recurring approach that works

---

## Recall

Memory is queried automatically on session start via `memorySearch` (vector similarity, top 4 results,
minScore 0.55). No explicit recall command needed for session context.

For mid-session recall when the topic shifts:

```bash
# memorySearch handles this — no bash needed.
# If you need to read the raw file:
BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
grep -A3 "KEYWORD" "${BRAIN_DIR}/memory/ecarg.md" | head -30
```

---

## Entry format rules

- One entry per fact. Don't bundle unrelated things.
- Max 2 sentences per entry. If it needs more, it belongs in a project doc, not memory.
- Be specific. "bpwonka prefers X" not "user mentioned something about X".
- Include *why* when known — it's what makes the memory useful later.
