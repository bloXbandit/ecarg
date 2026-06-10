# Narrative Hunter: RSS fallback integrated into Daily Briefing (no API keys)

## Context
Backlog item: **Fix: "The Narrative Hunter"** was blocked on user setup:
- `CRYPTOPANIC_API_KEY` (plan/quota) and
- X login + Bird cookies.

That’s fine for "full power" narrative scanning, but it leaves the system half-dead if credentials aren’t ready.

## What I changed (small code change)
I integrated the existing RSS-only Narrative Hunter into the daily market briefing so we still get narrative signal **without** CryptoPanic or Bird.

### File touched
- `src/daily_briefing.py`

### Behavior
- Daily briefing now includes a **Narratives (RSS headlines)** section.
- It fetches headlines from the `src/narrative_hunter_rss.py` feed list and computes:
  - anchor keywords present (BTC/ETH/SOL/QNT/XRP + macro terms)
  - top bigrams (rough "phrases")
  - top words
- If feeds are blocked/flaky, it degrades gracefully and prints an “unavailable” line (no crash).

### Notes
- This uses the internal `_topics()` helper from `narrative_hunter_rss.py` to avoid duplicating logic.
- It’s intentionally best-effort and dependency-free (still just `requests`).

## Why this helps
- Unblocks narrative awareness immediately (RSS is good enough for broad market themes).
- Keeps CryptoPanic/Bird as *optional upgrades* rather than a hard dependency.

## Next steps (optional)
- If you want higher signal: set `CRYPTOPANIC_API_KEY` and/or Bird cookies later; keep RSS as baseline.
- Consider adding a cron to run `narrative_hunter_rss.py --topics` and log results for trend comparisons.
