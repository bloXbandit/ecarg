# Session Context Summary (Recovered from chat logs)

This is a distilled recap of prior conversations (Feb–Mar 2026) to keep the agent in-context.

## People / Names
- User: **Kenny**
  - Address: **Wonka** (professional), **Kenny** (casual)
- Assistant: **eCARG** ("ecarg")
- Channel observed: Telegram chat id `7488398568` ("babyGrey")

## Persona / Tone
- "Smart Ass Trader" persona: cynical, competent, snarky, decisive.
- Key vibe: stop vibes-based trading; use mechanical rules; default to **sit on hands**.

## Operating Model (what we’re building)
We run a multi-part system:
- **Watchtower** market scans (scheduled) → regime/risk posture
- **Gem Finder** scans → candidates/watchlist
- **Wallet Watcher** keepalive + flow → confirmation/alerts
- **Daily Briefing** → a snarky market synopsis message
- **Scam Check** (`/check <CA>`) → immediate safety gate
- **WonkaTrade** (`../WonkaTrade/`) → live execution path (Jupiter swaps / Jito routing)

## Decision Doctrine (from chats)
- **Default:** SIT ON YOUR HANDS.
- Don’t chase green candles; if market already up 5–8% on the day, assume you missed bottom → wait for retrace.
- Focus on “Pain Points” / “Fakeout Pumps”.
- A key risk lens is **Liquidation Cascade / Air Pockets** (low-volume zones where price gaps fast).
  - This was implemented as `src/research_liquidation_cascade.py` and intended to be integrated into Watchtower alerts.

## CryptoPanic / Sentiment
- CryptoPanic sentiment intended as an input to the bot’s decision protocol.
- CryptoPanic v1 endpoints were 404; developer/v2 endpoint works.

## Execution Issues / Lessons
- There was a critical issue where “swaps” appeared like SOL transfers out with no USDC coming back (felt like donation to Jupiter).
- There were errors/bugs in the bot runs (missing vars, indentation error, etc.).
- A major focus was validating **real Jupiter swaps** (not dummy transfers), including micro tests.
- Practical constraint: very tiny amounts can fail quotes/minimums; infra needs sane minimum sizing.

## Requested Enhancements
- Trailing stop / position manager to prevent account nuking.
- Background work when idle: backtests, data sourcing for ETH/SOL/BTC/QNT/XRP/BNB; improve protocol.

## Notable phrases / recurring motifs
- "Phantom funds" = user’s manual trading account + eventual permission for agent to execute.
- "Smart Ass Market Update" = daily synopsis format.
