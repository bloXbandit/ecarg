# Narrative Hunter — unblock checklist (CryptoPanic key + X/Bird cookies)

## Status
Backlog has one remaining unchecked item:
- **Fix: The Narrative Hunter** — waiting on user to set `CRYPTOPANIC_API_KEY` + login to X for Bird cookies.

I reviewed `BRAIN/backlog.md` today and confirmed there’s nothing to code until credentials are provided.

## What you need to do (Kenny/Wonka)
### 1) CryptoPanic
- Create/upgrade a CryptoPanic API key/plan as needed.
- Export in your environment:
  - `export CRYPTOPANIC_API_KEY="..."`

### 2) X/Twitter (Bird)
- Log in to X in the browser profile you want Moltbot to use.
- Capture Bird cookies per the Bird skill instructions (or existing `TOOLS.md` notes if present).

## Quick verification steps (after setting creds)
From `/home/bpwonka/clawd`:
- `python3 src/narrative_hunter_check.py --cryptopanic`
- `python3 src/narrative_hunter_check.py --bird`

## Next action once unblocked
- Wire `narrative_hunter_check.py` into the daily briefing/watchtower flow and confirm it posts a narrative summary without throwing auth/rate-limit errors.
