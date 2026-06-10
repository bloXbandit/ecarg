# Fix: Narrative Hunter credentials (CryptoPanic + Bird)

## What I did
- Added a small sanity-check script: `src/narrative_hunter_check.py`
  - Verifies `CRYPTOPANIC_API_KEY` is set and can hit the CryptoPanic developer v2 endpoint.
  - Runs `bird check` and prints the resulting status/output.
- Updated `/home/bpwonka/clawd/TOOLS.md` with:
  - The correct env var (`CRYPTOPANIC_API_KEY`) instead of hard-coding a key.
  - Bird/X login steps and a single command to validate both dependencies.

## Current status (on this machine)
Running `python3 src/narrative_hunter_check.py` produced:
- **CryptoPanic:** HTTP **429** — *"API monthly quota exceeded"* (suggests the existing key/plan is out of quota).
- **Bird:** missing `auth_token` + `ct0` cookies (not logged into X in any detected browser profile).

## Next steps for Wonka
1. **CryptoPanic**
   - Rotate the key at: https://cryptopanic.com/developers/api/
   - Ensure it’s set in `/home/bpwonka/clawd/.env` as:
     - `CRYPTOPANIC_API_KEY=...`
   - If 429 persists even after rotating, it’s likely plan/quota related (may need an upgraded plan or fewer requests).

2. **Bird (X/Twitter)**
   - Log in to https://x.com in your normal browser on the host.
   - Re-run:
     - `bird check`
     - or `python3 src/narrative_hunter_check.py`

## Files changed
- `src/narrative_hunter_check.py` (new)
- `TOOLS.md` (updated)
