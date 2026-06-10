# Narrative Hunter status (2026-03-23)

Backlog item: **Fix: "The Narrative Hunter" - Waiting on user: set `CRYPTOPANIC_API_KEY` + login to X for Bird cookies.**

## What I checked (on clawd host)
Ran:
- `python3 src/narrative_hunter_check.py`

Results:
- **CryptoPanic:** FAIL → HTTP **429** with message **"API monthly quota exceeded"**.
  - This is not a transient per-minute rate limit; it’s the monthly quota wall.
- **Bird (X/Twitter):** FAIL → no cookies found.
  - `bird check` output shows **auth_token** and **ct0** missing.
- **RSS fallback:** OK → at least one RSS feed (CoinDesk) fetch+parse works.
  - So Narrative Hunter can still run in “RSS-only” mode, but it will miss X-native narrative shifts.

## Implications
- Narrative Hunter is **operational via RSS fallback**, but **degraded**.
- To restore full signal:
  1) CryptoPanic needs a plan reset/upgrade or a new key with quota.
  2) Bird needs valid X cookies (auth_token + ct0), or a working cookie-source profile.

## Concrete next steps for Kenny/Wonka
### A) CryptoPanic
- Either upgrade plan or wait for the monthly reset.
- When you have a working key again:
  - Put it in `/home/bpwonka/clawd/.env` as:
    - `CRYPTOPANIC_API_KEY=...`

### B) Bird cookies (recommended quickest path: env vars)
- Log into https://x.com in a browser **on the machine where bird runs**.
- Extract cookies `auth_token` and `ct0`.
- Set in `/home/bpwonka/clawd/.env`:
  - `BIRD_AUTH_TOKEN=...`
  - `BIRD_CT0=...`

Then rerun:
- `python3 src/narrative_hunter_check.py`

Success criteria:
- Either (CryptoPanic OK + Bird OK) **OR** at minimum RSS OK (already true).
