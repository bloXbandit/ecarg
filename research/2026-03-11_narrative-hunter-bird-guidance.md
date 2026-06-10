# Narrative Hunter — Bird auth guidance improvement (2026-03-11)

## Goal
Backlog item was stuck on user setup: CryptoPanic key + Bird/X cookies. While we can’t conjure credentials, we can make the failure mode *actionable* so it doesn’t feel like the pipeline is “broken”.

## What I changed
Updated `src/narrative_hunter_check.py` to provide clearer, step-by-step remediation when `bird check` fails:

- Explicitly calls out the most common root causes (X cookies missing/expired, bird can’t read browser profile)
- Adds quick-fix checklist:
  1) ensure you’re logged into X in your main browser
  2) run `bird check` manually
  3) try `--cookie-source chrome` or set `~/.config/bird/config.json5` with `cookieSource` + `chromeProfileDir`

## File touched
- `src/narrative_hunter_check.py`

## Why this matters
This reduces “mystery failures” during setup and makes the remaining dependency (user login / cookie access) self-service.

## Next step (still required)
- Set `CRYPTOPANIC_API_KEY` in `/home/bpwonka/clawd/.env` if we want CryptoPanic back.
- Ensure Bird can read cookies from a browser profile that is logged into X.
