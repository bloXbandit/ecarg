# Narrative Hunter: unblock via RSS fallback (status + next actions)

Date: 2026-03-26

## What I did
- Opened the Narrative Hunter status item and ran the existing sanity-check script:
  - `python3 src/narrative_hunter_check.py`

## Results (current state)
- **CryptoPanic:** **FAIL** — API monthly quota exceeded (HTTP 429)
  - Body: `API monthly quota exceeded - Upgrade your API plan`
  - Conclusion: this is not a temporary “try later” 429; it’s a plan/quota wall until reset/upgrade.

- **Bird / X:** **FAIL** — no cookies found (`auth_token`, `ct0` missing)
  - `bird check` output indicates no cookies found across Safari/Chrome/Firefox; Chrome cookie DB not found.
  - Conclusion: on this machine, Bird can’t extract cookies automatically; needs explicit env vars or a configured browser profile.

- **RSS fallback:** **OK** — RSS pipeline works
  - Sample success: CoinDesk feed fetched + parsed.
  - Conclusion: Narrative Hunter is **not dead-in-the-water**: we can still surface narratives via RSS even without CryptoPanic/X.

## Recommendation
1) Treat RSS as the default narrative source until credentials are fixed.
2) When ready to restore full capability:
   - **CryptoPanic:** upgrade plan or wait for monthly reset, then set `CRYPTOPANIC_API_KEY`.
   - **Bird:** set cookies explicitly in `.env`:
     - `BIRD_AUTH_TOKEN=...`
     - `BIRD_CT0=...`

## Suggested immediate next code step (not done)
- Consider wiring watchtower/narrative logic to:
  - use RSS-only mode when `cryptopanic` returns quota exceeded, and
  - degrade gracefully when Bird cookies are missing.
  (This would turn the “waiting on user” backlog item into “works by default, upgrades with credentials”.)
