# Narrative Hunter — setup unblock (CryptoPanic key + X/Bird cookies)

Backlog item: **Fix: Narrative Hunter** (waiting on user creds). This note makes it plug-and-play.

## 1) CryptoPanic API key

`src/narrative_hunter_check.py` expects:
- `CRYPTOPANIC_API_KEY` in environment (preferred: `/home/bpwonka/clawd/.env`)

Steps:
1. Create/rotate key: https://cryptopanic.com/developers/api/
2. Add to `.env`:
   ```bash
   cd /home/bpwonka/clawd
   cp -n .env.example .env  # if you haven't already
   echo 'CRYPTOPANIC_API_KEY=YOUR_KEY_HERE' >> .env
   ```
3. Verify:
   ```bash
   python3 src/narrative_hunter_check.py
   ```

What “good” looks like:
- `[CryptoPanic] OK - CryptoPanic OK (results=...)`

Common failures:
- 401/403: wrong key or plan/quota
- 429: rate-limited (free plan is tight)

## 2) X/Twitter narratives (Bird)

`src/narrative_hunter_check.py` accepts **either**:
- working `bird` CLI (`bird check` succeeds), **or**
- explicit cookies via env:
  - `BIRD_AUTH_TOKEN`
  - `BIRD_CT0`

### Option A (preferred): use bird CLI
- Ensure the Moltbot **bird skill** is installed and `bird` is on PATH
- Make sure you’re logged into X in your main Chrome profile
- Run:
  ```bash
  bird check
  ```

If cookie extraction fails, try:
```bash
bird check --cookie-source chrome
```
(or set cookieSource/chromeProfileDir in `~/.config/bird/config.json5`)

### Option B (works anywhere): set cookies explicitly
1. Login at https://x.com
2. Open DevTools → Application (or Storage) → Cookies → `https://x.com`
3. Copy cookie values:
   - `auth_token`
   - `ct0`
4. Put into `/home/bpwonka/clawd/.env`:
   ```bash
   BIRD_AUTH_TOKEN=...  # value of auth_token cookie
   BIRD_CT0=...         # value of ct0 cookie
   ```
5. Verify:
   ```bash
   python3 src/narrative_hunter_check.py
   ```

## 3) Baseline even without creds: RSS fallback

Even if CryptoPanic + Bird aren’t configured yet, Narrative Hunter is not dead:
- `src/narrative_hunter_rss.py` aggregates headlines from a few accessible RSS feeds.

Try:
```bash
python3 src/narrative_hunter_rss.py --topics --limit 50
```

Note: CryptoPanic’s public RSS endpoints are behind Cloudflare/bot walls on servers, so we **do not** depend on them.

## Code change made today

Improved the Bird missing-config message in `src/narrative_hunter_check.py` to include exact cookie names + where to grab them in DevTools.
