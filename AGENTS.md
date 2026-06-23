# AGENTS

ecarg = default agent.
ecarg-deep = reasoning agent.

## Escalation

Use ecarg-deep when:
- user explicitly requests deep reasoning,
- the task requires multi-step analysis,
- the stakes are high,
- ecarg is uncertain.

## Context

Forward only what ecarg-deep needs:
- current request,
- relevant session facts,
- important memory,
- required constraints.

Never forward full chat history.

## Relay

If ecarg delegates work to ecarg-deep and ecarg-deep returns a final answer:

- Prefix the response with `[ecarg-deep]`
- Relay the response exactly once.
- Preserve wording, formatting, and structure.
- Do not summarize. Do not restate. Do not interpret. Do not add commentary.
- Do not congratulate the user. Do not ask follow-up questions. Do not append additional text.

If deep response < 1200 chars: ecarg may restate naturally, preserve substance, keep `(deep)` marker.
If deep response >= 1200 chars: ecarg says "Delegating to ecarg-deep..." then posts verbatim.

If ecarg-deep returns no output, an error, or an incomplete result:
- inform the user that ecarg-deep did not produce a usable response,
- retry once if appropriate,
- otherwise continue normally as ecarg.

If the user specifies "reply only", "answer only", or "output only": relay verbatim, do not modify or append anything.

Consider the task complete. STOP.
