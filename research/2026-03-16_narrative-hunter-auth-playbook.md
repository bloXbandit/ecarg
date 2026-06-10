# Narrative Hunter: auth + fallback playbook (CryptoPanic + Bird)

## Why this exists
Narrative Hunter has two “moving parts” that break in production:
1) **CryptoPanic API key** (rate limits / plan issues / missing env)
2) **X/Twitter access via Bird** (cookies missing/expired; headless hosts can’t scrape browser cookie DB)

This note is the fastest path to get it working on the box that actually runs Clawd/Moltbot.

---

## Sanity check command (single entrypoint)
Run:
```bash
cd /home/bpwonka/clawd
python3 src/narrative_hunter_check.py
```
Success criteria:
- **Ideal:** CryptoPanic OK + Bird OK
- **Acceptable baseline:** RSS fallback OK (so the pipeline isn’t dead)

---

## Step 1 — CryptoPanic API key
1) Create/edit:
```bash
cd /home/bpwonka/clawd
cp -n .env.example .env
nano .env
```
2) Add:
```dotenv
CRYPTOPANIC_API_KEY=...your_key...
```
3) Re-run the check:
```bash
python3 src/narrative_hunter_check.py
```

If you get 401/403: wrong key or plan quota.
If you get 429: rate limited — either wait, reduce polling, or upgrade plan.

---

## Step 2 — Bird/X access (two ways)

### Option A (desktop-like host): use browser cookies
If the box has Chrome/Firefox with an active X login:
1) Log into https://x.com
2) Run:
```bash
bird check
# or
python3 src/narrative_hunter_check.py
```
3) If Bird can’t find the cookies DB, configure Bird’s cookie source/profile:
- `bird check --cookie-source chrome`
- set `chromeProfileDir` in `~/.config/bird/config.json5`

### Option B (server/headless): set cookies explicitly (recommended)
If the machine running this is headless or doesn’t have your browser profile, **just provide cookies**.

Set these env vars:
```dotenv
BIRD_AUTH_TOKEN=... 
BIRD_CT0=...
```
Then:
```bash
python3 src/narrative_hunter_check.py
```

Note: as of 2026-03-16, `src/narrative_hunter_check.py` treats **BIRD_AUTH_TOKEN + BIRD_CT0** as “Bird configured” even if the `bird` CLI isn’t installed on PATH. This avoids false negatives on servers.

---

## RSS fallback
Even with no keys/cookies, Narrative Hunter should not be dead. The check script also validates that at least one RSS feed parses via `src/narrative_hunter_rss.py`.

If RSS fails, it’s usually network/DNS or temporary feed flakiness; rerun later.
