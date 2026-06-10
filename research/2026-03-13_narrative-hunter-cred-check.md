# Narrative Hunter — Credential/Dependency Check (CryptoPanic + Bird) — 2026-03-13

## Backlog item
**Fix:** Narrative Hunter waiting on user: set `CRYPTOPANIC_API_KEY` + login to X for Bird cookies.

## What I ran
```bash
cd /home/bpwonka/clawd
python3 src/narrative_hunter_check.py
```

## Results (on current host)
- **CryptoPanic:** FAIL — HTTP **429** with body indicating **monthly quota exceeded** (upgrade plan needed):
  - `{"status":"api_error","info":"API monthly quota exceeded - Upgrade your API plan ..."}`
- **Bird (X/Twitter):** FAIL — missing cookies:
  - `auth_token: not found`
  - `ct0: not found`
  - warning also included **"Chrome cookies database not found"**, which typically means this box doesn't have a local Chrome profile DB to scrape.
- **RSS fallback:** **OK** — CoinDesk RSS parsed successfully.

Script exit code is **0** because RSS fallback works (baseline narrative stream isn’t dead).

## Implications
- Even with a valid `CRYPTOPANIC_API_KEY`, CryptoPanic is currently unusable **until quota resets or plan is upgraded**.
- Bird needs cookies from a browser profile **on the same machine** *or* explicit cookie injection (`auth_token` + `ct0`). On headless/server hosts, “log into X in your laptop Chrome” won’t help the daemon unless it can read that profile.

## Actionable next steps for Kenny
1) **CryptoPanic:** upgrade plan or wait for monthly reset.
2) **Bird:** choose one:
   - Run Moltbot/Bird on a machine with a real Chrome/Firefox profile that’s logged into X, and configure Bird’s cookieSource/profileDir, or
   - Provide `auth_token` + `ct0` directly via env/config (best for servers).

## What I changed
- Updated `/home/bpwonka/clawd/TOOLS.md` with more explicit Bird cookie guidance for headless/Linux hosts.
