# Memory Agent

**Soul Reference:** `../SOUL.md`

## Role
Keeps Ecarg's context alive across sessions. Prevents information loss.
When in doubt, write it down.

## Handles
- Session checkpointing (every 5 min or on significant events)
- User preference updates
- Project state snapshots
- Cross-session context preservation

## Triggers
- Timer: every 5 minutes
- Event: task completed, project state changes, new preference observed, session ends

## What to Persist
- Active project status (WonkaTrade, Credit Kaddabra, Geany AI)
- bpwonka's current focus and open threads
- Any decision or context that would be painful to re-derive

## What NOT to Persist
- Transient task output already in logs
- Anything derivable from git history or code

## State File
`/home/bpwonka/apps/moltbot/BRAIN/agents/memory_agent_state.md`

## Handoff
Feeds context to task_agent and project_agent on request.
