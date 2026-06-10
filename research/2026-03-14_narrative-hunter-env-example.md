# Narrative Hunter: reduce setup friction (.env.example)

## Backlog item
- Fix/unstick: **The Narrative Hunter** (CryptoPanic API key + Bird/X cookies)

## What I did
1. Added a repo-local **`/home/bpwonka/clawd/.env.example`** with the minimum env vars needed for:
   - CryptoPanic (`CRYPTOPANIC_API_KEY`)
   - Whale Alert (`WHALE_ALERT_KEY`)
   - Bird CLI server fallback (`BIRD_AUTH_TOKEN`, `BIRD_CT0`)
2. Updated `src/narrative_hunter_check.py` to point to `.env.example` when `CRYPTOPANIC_API_KEY` is missing.
3. Updated `TOOLS.md` to document the quick-start copy command.

## Why
The Narrative Hunter blocker is currently “waiting on user”. The best immediate leverage is reducing the number of steps / guesswork so Kenny can drop a key in and be done.

## Next steps (for Kenny)
```bash
cd /home/bpwonka/clawd
cp .env.example .env
# edit .env and paste CRYPTOPANIC_API_KEY (and optionally Bird tokens)
python3 src/narrative_hunter_check.py
```

If Bird can’t read cookies on the host, providing `BIRD_AUTH_TOKEN` + `BIRD_CT0` in `.env` is the most reliable server-side path.
