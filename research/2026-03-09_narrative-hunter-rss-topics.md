# Narrative Hunter: RSS topics mode (no-API fallback)

Date: 2026-03-09

## Context
Backlog item: **Fix: Narrative Hunter** is blocked on credentials:
- `CRYPTOPANIC_API_KEY` (CryptoPanic)
- X login/cookies for `bird` CLI

We already have a no-credential baseline (`src/narrative_hunter_rss.py`) that aggregates crypto-news RSS headlines.

## What I changed
I extended `src/narrative_hunter_rss.py` to support a lightweight **topic/narrative summary** mode:
- New flag: `--topics`
- Outputs:
  - **Top words** (headline-derived frequency)
  - **Top bigrams** (2-word phrases)
  - **Anchors present** (tiny whitelist of important crypto terms/tickers like `bitcoin`, `ethereum`, `solana`, `sec`, `etf`, `stablecoin`, etc.)

This makes Narrative Hunter *useful even when CryptoPanic/Bird aren’t configured*.

## Usage
```bash
python3 src/narrative_hunter_rss.py --topics
python3 src/narrative_hunter_rss.py --topics --json
```

Notes:
- It’s deliberately dependency-free (stdlib + `requests`).
- It’s “rough”: headline tokenization + stopwords + word/bigram counts.

## Example output (today)
(Actual output will vary with news cycle.)
- Anchors present: bitcoin/ethereum/solana/coinbase/binance/stablecoin + some macro terms
- Top bigrams can surface what the news is *actually* talking about (e.g. “stablecoin payments”, “bitcoin treasury”, “middle east”, etc.)

## Next step (optional)
Once Kenny sets `CRYPTOPANIC_API_KEY` + Bird cookies, we can:
- Blend RSS topics + CryptoPanic “rising” posts + X trend scanning into a single narrative scorecard
- Add it into `daily_briefing.py` / `watchtower.py` as a short “Narratives” section
