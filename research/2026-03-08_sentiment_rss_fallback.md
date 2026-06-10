# SentimentEngine: RSS fallback when CryptoPanic key missing/limited

## Why
The backlog item for Narrative Hunter was blocked on:
- `CRYPTOPANIC_API_KEY` (quota exceeded / missing)
- X/Bird cookies

But our *daily briefing* only needs “some headlines + a vibe,” not full CryptoPanic metadata.

## What I changed
**File:** `src/sentiment_plugin.py`

- Added a credential-free RSS fallback (`_fetch_rss_news`) that pulls from `src/narrative_hunter_rss.py`’s `DEFAULT_FEEDS`.
- `fetch_news()` now:
  - Uses CryptoPanic when it works.
  - Falls back to RSS automatically on HTTP errors / non-JSON / JSON decode failures (notably the current **429 monthly quota exceeded** case).
- `get_aggregate_sentiment()` now surfaces 1–3 headlines even if none pass the “impact >= 2” threshold (RSS has no vote metadata, so scores are mostly keyword-based).

## Result
- Daily briefing no longer goes “No major headlines. Just vibes.” when CryptoPanic is unavailable.
- You still get a headline + a computed score/verdict, using the existing keyword heuristics.

## How to test
From `/home/bpwonka/clawd`:

```bash
python3 - <<'PY'
from src.sentiment_plugin import SentimentEngine
eng=SentimentEngine()
print(eng.get_aggregate_sentiment('BTC'))
PY
```

If CryptoPanic is down/429, it should still return `top_stories` from RSS.

## Notes / follow-ups
- RSS filtering by symbol is best-effort; if it finds nothing, it falls back to unfiltered market headlines.
- If we want better sentiment without CryptoPanic votes, next step is a tiny LLM classifier over RSS titles (but that’s heavier + costs tokens).
