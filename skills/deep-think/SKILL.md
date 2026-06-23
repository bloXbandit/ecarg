# Deep Think Skill

Use this skill when the user asks for deeper reasoning, complex analysis, tradeoffs, strategy, debugging, financial/mortgage analysis, project controls analysis, trading/research logic, or explicitly asks to use ecarg-deep.

## Core Architecture

ecarg is the fast dispatcher.
ecarg-deep is the reasoning specialist.

ecarg should not solve deep tasks itself when the user explicitly asks for ecarg-deep or when the problem clearly needs deeper reasoning.

## Context Forwarding Rule

Before calling ecarg-deep, ecarg must forward only the context needed to answer well.

Include:
- The user's current request
- Important constraints from the current conversation
- Relevant facts already known from memory or session context
- Any numbers, dates, assumptions, file names, model names, or config details needed
- Desired output style or length
- Whether the user wants direct commands, analysis, or a decision

Do not forward:
- Full raw chat history
- Irrelevant prior messages
- Tool noise
- Logs unless the logs are needed
- Long memory dumps

The forwarded task packet should be compact, usually under 1,500 characters unless the task truly requires more.

## Subagent Call

Use `sessions_spawn` targeting:

agentId: `ecarg-deep`

The prompt to ecarg-deep must say:

"Answer the user directly. Start with `(deep)`. Return a final user-facing answer, not notes for ecarg."

## Relay Rule

After ecarg-deep returns:

If the deep response is under 1,200 characters:
- ecarg may restate it naturally.
- Preserve all important substance.
- Keep the `(deep)` marker.
- Do not water it down.

If the deep response is 1,200 characters or longer:
- ecarg must not summarize it.
- ecarg must say only:

Delegating to ecarg-deep...

Then post the deep response directly/verbatim.

Do not compress, paraphrase, rewrite, or shorten long deep responses.

## Failure Rule

If `sessions_spawn` fails, say plainly:

"ecarg-deep did not run. I’m answering with ecarg instead."

Then answer normally.

Do not pretend deep ran.

## Cost Rule

Use ecarg-deep only when:
- the user explicitly asks for it,
- the task needs deeper reasoning,
- the task involves high-stakes config/debugging,
- the task involves mortgage/trading/project-controls analysis with meaningful nuance,
- or ecarg is unsure and needs a stronger reasoning pass.

For simple questions, ecarg should answer directly.


