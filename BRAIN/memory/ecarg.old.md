
## [2026-06-10] preference
bpwonka wants token burn aggressively limited: no useless main-session keepalive/context noise, heartbeat at most once daily unless explicitly needed, memory should be cached/search-based instead of reloading bulk files, and long chat/history context should be trimmed unless needed for natural recall.

## [2026-06-10] preference
bpwonka wants aggressive memory settings: no useless cron noise in main context, heartbeat once per day, no full memory loading on every prompt, cache/query based instead of loaded all files, and keep Telegram history on-demand.

## [2026-06-10] decision
Made config changes: cheap primary model; deep agent only on request, smaller bootstrap/context settings, heartbeat off, suppressed mid-session memory loading.

## [2026-06-10] preference
bpwonka wants to limit token costs: set $0.03 cap on regular prompts. Send a warning or switch to simplified responses if they approach this cap. Allow a $0.20 cap for Deep Think tasks to maintain quality without hindering operational budget.

## [2026-06-10] preference
bpwonka wants to tag responses with (deep) for deep think tasks to identify costly requests easily.

## [2026-06-10] action
bpwonka has requested the token usage counts for prompts: check current input and output token usage during conversations. Store any notable costs associated. NOTE: Change log to capture cost during execution.

## [2026-06-10] action
bpwonka has requested the tracking of input and output token usage during conversations, totaling 491,014 tokens in this session with cost approximations of $2.89.

## [2026-06-10] action
bpwonka has requested improvements: increase cache efficiency by prioritizing frequently accessed data and implementing smarter purge strategies for rarely accessed items. Additionally, create a dynamic context trimming method for reducing retained context based on user interaction depth to maintain conciseness.

## [2026-06-10] action
bpwonka wants to implement a selective key points saving system, where only significant insights are retained while purging low-value interactions and old context dynamically. Input token counts should be capped at under 2,000 tokens per prompt, and daily overall token usage limited to 2,000 tokens to keep usage efficient and avoid overload.

## [2026-06-10] action
bpwonka has requested to implement dynamic context trimming to manage session tokens and keep overall usage within the optimal range. This will help avoid exceeding the token limits during interactions.

## [2026-06-10] action
bpwonka has requested immediate context trimming due to exceeding token usage (34,000 tokens) beyond the set limit (16,000 tokens). Implement strategies to reduce retained context dynamically during interactions to align with token usage goals.
