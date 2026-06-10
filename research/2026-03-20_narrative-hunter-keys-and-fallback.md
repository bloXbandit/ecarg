# Narrative Hunter — keys, quota reality check, and the no-API fallback

Date: 2026-03-20

## TL;DR
- **RSS fallback works today** (CoinDesk/others) → Narrative Hunter is not dead-in-the-water.
- **CryptoPanic is currently failing with `HTTP 429` + `monthly quota exceeded`** on our key/plan.
- **Bird/X cookies are missing on this box** (no Chrome cookie DB found; auth_token/ct0 not found).

## What I checked (on the clawd host)
Ran:

```bash
cd /home/bpwonka/clawd
python3 src/narrative_hunter_check.py
```

Observed:
- CryptoPanic: `HTTP 429` with JSON message indicating **monthly quota exceeded**.
- Bird: `bird check` fails (no cookies found).
- RSS fallback: **OK** (CoinDesk feed parsed).

## Recommended path forward (so Narrative Hunter becomes “full power”)

### 1) CryptoPanic: fix is not “try later” — it’s quota/plan
CryptoPanic uses `429` for both rate-limits and quota exhaustion. In our case it’s **monthly quota exceeded**.

Options:
- Upgrade CryptoPanic plan / rotate key tied to a plan with quota: <https://cryptopanic.com/developers/api/plans/>
- Keep current plan and accept that **CryptoPanic is unavailable until the monthly reset**.
- If you only need *some* narrative signal, rely on RSS headlines (already implemented).

### 2) Bird: easiest fix is just provide cookies via `.env`
If Bird can’t find the browser cookie DB on this machine, the most reliable server/headless setup is:

1) Log into <https://x.com> in your normal browser
2) DevTools → Application/Storage → Cookies → `https://x.com`
3) Copy cookie values:
   - `auth_token`
   - `ct0`
4) Put into `/home/bpwonka/clawd/.env`:

```dotenv
BIRD_AUTH_TOKEN=...
BIRD_CT0=...
```

Then re-run:

```bash
python3 src/narrative_hunter_check.py
```

## Notes on the RSS fallback
The current baseline implementation lives in:
- `/home/bpwonka/clawd/src/narrative_hunter_rss.py`

It aggregates a small set of high-signal feeds and can also print crude “topics”:

```bash
python3 src/narrative_hunter_rss.py --topics
```

This is good enough for:
- “What are media narratives pushing right now?”
- Anchor topics (ETF/SEC/hack/stablecoins/BTC/ETH/SOL etc.)

But it will *not* capture:
- Twitter/X narrative rotations
- Telegram/Discord memecoin churn

## Code change made
I updated `/home/bpwonka/clawd/src/narrative_hunter_check.py` to detect the **monthly quota exceeded** case and say so explicitly, instead of a generic “rate limited; try later”.
