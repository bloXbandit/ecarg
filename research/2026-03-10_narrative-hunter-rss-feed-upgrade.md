# Narrative Hunter — RSS fallback feed upgrade (2026-03-10)

## Why this matters
The backlog item *“Narrative Hunter (Fix) — waiting on user: CRYPTOPANIC_API_KEY + Bird cookies”* is real, but it shouldn’t block us from getting **usable narrative signal**.

We already have an RSS-based fallback pipeline (`src/narrative_hunter_rss.py`) that requires **zero credentials** and is also used as a fallback inside `src/sentiment_plugin.py` when CryptoPanic is missing/returns garbage.

The main failure mode I’ve seen with “nice” news sources is bot protection (Cloudflare / cookie walls). Those feeds will work in a browser but fail on a headless server.

## What I changed
**Code change:** expanded the RSS source list to include 2 additional feeds that are consistently accessible server-side.

File:
- `src/narrative_hunter_rss.py`

Change:
- Added feeds:
  - `CryptoSlate` → `https://cryptoslate.com/feed/`
  - `Bitcoin Magazine` → `https://bitcoinmagazine.com/.rss/full/`
- Added a comment explicitly warning to avoid Cloudflare/cookie-walled sources.

## Notes / operational guidance
- **The Block**’s feed (`theblockcrypto.com/feed`) appears to be Cloudflare-blocked from server IPs (403 “Attention Required”). Not worth adding unless we proxy or use a browser fetcher.
- RSS items don’t include vote metadata, so anything expecting CryptoPanic votes must treat RSS as “headline-only” sentiment.

## Quick test commands
```bash
python3 src/narrative_hunter_rss.py --limit 10
python3 src/narrative_hunter_rss.py --topics
python3 src/narrative_hunter_check.py
```

## Next (if you want to fully close the backlog item)
- Set `CRYPTOPANIC_API_KEY` in `/home/bpwonka/clawd/.env`
- Log into X on the host that runs `bird`, refresh cookies, then re-run:
  - `bird check`
