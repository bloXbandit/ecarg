# Narrative Hunter: strengthen RSS fallback (no API keys)

Date: 2026-03-12

## Why
The only remaining unchecked backlog item is blocked on credentials:
- `CRYPTOPANIC_API_KEY` (CryptoPanic)
- X login/cookies for `bird`

So the highest-impact thing we can do *without* creds is make sure the **RSS fallback** is strong, diverse, and reliably fetchable from a server environment.

## What I did
1) **Tested additional RSS sources** for server-side accessibility (no JS/cookie walls) using a plain `requests` GET with a simple UA.

2) **Added two working, high-signal feeds** to `src/narrative_hunter_rss.py`:
- Blockworks — `https://blockworks.co/feed` (HTTP 200)
- The Defiant — `https://thedefiant.io/feed` (HTTP 200)

These broaden coverage beyond CoinDesk/Cointelegraph/Decrypt/CryptoSlate, especially for DeFi/market-structure narratives.

## Quick test results (server fetch)
- ✅ Blockworks: 200, `text/xml`
- ✅ The Defiant: 200, `application/xml`
- ❌ CoinGecko news RSS: 403 (blocked)
- ❌ Bankless RSS: 404 (no feed at that URL)
- ❌ FT crypto RSS attempt: 406

## Code change
File modified:
- `src/narrative_hunter_rss.py`

Change:
- appended Blockworks + The Defiant to `DEFAULT_FEEDS`

## How to use
- Headlines:
  - `python3 src/narrative_hunter_rss.py --limit 20`
- Rough “narratives” from headline tokens:
  - `python3 src/narrative_hunter_rss.py --topics`
- Machine-readable output:
  - `python3 src/narrative_hunter_rss.py --json`

## Next steps (when creds are available)
- Set `CRYPTOPANIC_API_KEY` in `/home/bpwonka/clawd/.env` and rerun:
  - `python3 src/narrative_hunter_check.py`
- Log into X in the host browser, then:
  - `bird check`

Once those pass, Narrative Hunter can incorporate faster “what’s pumping on CT” style signals again, but at least the RSS baseline is now more robust.
