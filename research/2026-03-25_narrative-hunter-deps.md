# Narrative Hunter dependencies (CryptoPanic key + X cookies)

Date: 2026-03-25

## Backlog item
**Fix: "The Narrative Hunter"** — waiting on user to set `CRYPTOPANIC_API_KEY` and log in to X for Bird cookies.

## Status / what I checked
This item is blocked on credentials that only you can provide:

### 1) CryptoPanic
- The Narrative Hunter needs `CRYPTOPANIC_API_KEY` in the environment.
- Without it, the script can’t fetch narrative/news data.

**Action needed:**
- Get a new CryptoPanic API key (or confirm the plan/quota is active).
- Put it somewhere the runtime can see it (e.g. `.env`, service env vars, or the gateway config env injection—whatever you’re using for the rest of Clawd).

### 2) X/Twitter via Bird
- Bird requires authenticated cookies.
- That requires logging into X in a browser profile and exporting/pointing Bird at the cookies (per the Bird skill setup).

**Action needed:**
- Log in to X on the machine running Moltbot/Clawd.
- Provide cookies in the expected location/format for Bird.

## Next step once creds are present (I can do immediately after)
- Run `src/narrative_hunter_check.py` end-to-end.
- Confirm it produces a clean summary output.
- Wire it into the daily brief / whatever surface you want (watchtower alert vs daily digest).

## Minimal checklist for you
1. Provide `CRYPTOPANIC_API_KEY`
2. Provide Bird/X cookies
3. Tell me where you want these stored (dotenv vs gateway env vs systemd/pm2 env)
