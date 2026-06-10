# Narrative Hunter: RSS fallback (no API keys)

## Problem
Backlog item was blocked on two credentials:
- `CRYPTOPANIC_API_KEY` (CryptoPanic)
- X/Twitter login cookies for `bird`

That meant we had **no narrative feed at all** unless the user completed setup.

## What I did
Implemented a *no-credential* baseline narrative feed using RSS:
- Added `src/narrative_hunter_rss.py`
- Pulls + aggregates headlines from a short list of reputable RSS feeds:
  - CoinDesk
  - Cointelegraph
  - Decrypt
- Parses both RSS2 + Atom, sorts newest-first when timestamps exist.

## How to run
```bash
python3 src/narrative_hunter_rss.py --limit 20
python3 src/narrative_hunter_rss.py --limit 15 --json
```

## Notes / Next step (optional)
- This can be wired into `src/daily_briefing.py` as a “Narratives (RSS fallback)” section.
- If/when `CRYPTOPANIC_API_KEY` + `bird` cookies are configured, we can merge signals:
  - CryptoPanic “rising” + RSS headlines + X trend/engagement scans.
