# Narrative Hunter: unblock steps for CryptoPanic + Bird/X (2026-03-27)

## Goal
Unblock the backlog item:
- **Fix: The Narrative Hunter** — waiting on user: set `CRYPTOPANIC_API_KEY` + login to X for Bird cookies.

This isn’t a code fix as much as **credential + auth setup**. Here’s the clean checklist for Wonka/Kenny.

## CryptoPanic API Key
1) Create/sign in: https://cryptopanic.com/developers/api/
2) Get an API key and decide **plan tier** (free is often enough for lightweight headline polling; quotas vary).
3) Add to environment where `narrative_hunter_check.py` runs:

```bash
export CRYPTOPANIC_API_KEY="..."
```

If running under systemd/pm2/cron, put it in the service env file (not your shell).

### Quick smoke test
```bash
python -c "import os; assert os.getenv('CRYPTOPANIC_API_KEY')"
python src/narrative_hunter_check.py --source cryptopanic --limit 10
```

Expected: JSON/articles returned. If you get 401/403 → bad key/plan; if 429 → rate-limit.

## Bird (X/Twitter) cookies
Bird needs **real browser login cookies**.

1) Log into X in Chrome.
2) Export cookies in Netscape format (recommended) using a cookies exporter extension.
3) Save to a file and set env var pointing to it, e.g.:

```bash
export BIRD_COOKIE_FILE="$HOME/.config/bird/x.cookies.txt"
```

4) Smoke test:
```bash
bird search "(BTC OR ETH OR SOL) (ETF OR hack OR exploit OR lawsuit)" --limit 20
```

If it fails with auth errors: cookies expired or missing `auth_token`.

## Security notes
- Don’t commit keys/cookies.
- Prefer a dedicated low-priv X account for automation.
- Rotate cookies periodically; expect them to expire.

## Recommendation
Given fragility of X cookies, treat Bird as a **best-effort enhancer**:
- Primary: CryptoPanic headlines
- Secondary: Bird for extra context
- On Bird failure: continue with CryptoPanic-only instead of failing the whole narrative job.
