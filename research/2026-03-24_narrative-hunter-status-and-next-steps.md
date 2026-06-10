# Narrative Hunter status + next steps (2026-03-24)

## What I checked
Ran:
- `python3 src/narrative_hunter_check.py`

Results:
- **CryptoPanic:** **FAIL** — HTTP 429 with explicit message **monthly quota exceeded**.
  - Body: `{"status":"api_error","info":"API monthly quota exceeded - Upgrade your API plan: /developers/api/plans/"}`
- **Bird/X:** **FAIL** — no cookies found (`auth_token`, `ct0`). `bird check` cannot locate browser cookie DBs on this host.
- **RSS fallback:** **OK** — RSS pipeline works; parsed items successfully (CoinDesk sample).

## Interpretation
- CryptoPanic isn’t “broken”; we’re **out of monthly quota**. Nothing to do code-wise until plan resets or we upgrade.
- Bird isn’t authenticated on this machine. Until cookies are supplied (env or accessible browser profile), X-based narrative scraping won’t work.
- Narrative Hunter is still viable via **RSS fallback** (baseline) so the system isn’t dead-in-the-water.

## Recommended next steps (actionable)
1) **CryptoPanic:** upgrade plan or wait for monthly reset; then set/confirm `CRYPTOPANIC_API_KEY` in `/home/bpwonka/clawd/.env`.
2) **Bird cookies:** easiest headless path is to set env vars in `/home/bpwonka/clawd/.env`:
   - `BIRD_AUTH_TOKEN=...`
   - `BIRD_CT0=...`
   (grab from x.com cookies in a logged-in browser)
3) Optional: if we want to avoid X entirely, expand RSS sources + add dedupe/ranking across feeds.

## Proof
Command output summary:
- CryptoPanic: 429 monthly quota exceeded
- Bird: auth_token/ct0 missing
- RSS: OK
