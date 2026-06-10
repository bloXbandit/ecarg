# Narrative Hunter fix (still waiting on user creds)

## Backlog item
**Fix:** Narrative Hunter is blocked until:
- `CRYPTOPANIC_API_KEY` is set (valid plan/quota)
- Bird/X cookies are present (logged in)

## What I changed
### 1) Improved the sanity-check script output
File: `src/narrative_hunter_check.py`

Changes:
- Clearer “how to set CRYPTOPANIC_API_KEY” message + link
- Better CryptoPanic HTTP error hints for 401/403 and 429
- `bird check` now has a timeout (20s) and gives a more actionable failure message

This doesn’t magically create credentials, but it makes the failure mode self-explanatory and reduces "wtf" time.

## What still needs Kenny
1) Add in `/home/bpwonka/clawd/.env`:
   - `CRYPTOPANIC_API_KEY=...`
2) Ensure X is logged in on the host browser (so Bird can read cookies), then:
   - `bird check`
   - `python3 src/narrative_hunter_check.py`

## Quick verification
After creds are set:
- `python3 src/narrative_hunter_check.py` should return exit code 0 via either:
  - CryptoPanic + Bird, OR
  - RSS fallback (baseline)
