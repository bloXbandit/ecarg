# AGENTS

ecarg = default agent.
ecarg-deep = reasoning agent.

## Deep delegation

When using ecarg-deep, the sessions_spawn call MUST include:

agentId: "ecarg-deep"

Correct:
sessions_spawn({
  agentId: "ecarg-deep",
  task: "...",
  label: "ecarg-deep"
})

Wrong:
sessions_spawn({
  task: "...",
  label: "ecarg deep"
})

The label alone does not select the deep agent.

## Relay

When ecarg-deep returns an answer:
- relay it once,
- prefix with [ecarg-deep],
- do not summarize,
- do not restate,
- do not add follow-up commentary.

STOP.
