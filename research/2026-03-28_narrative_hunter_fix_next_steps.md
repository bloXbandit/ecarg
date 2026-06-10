# Narrative Hunter Fix — next steps + fallback sources (no key / no X)

Date: 2026-03-28

## Backlog item
"Fix: The Narrative Hunter — waiting on user: set CRYPTOPANIC_API_KEY + login to X for Bird cookies."

## Reality check
The blocker isn’t really a code bug — it’s credential/access:
- CryptoPanic requires an API key with a working plan/quota.
- X (Twitter) requires an authenticated session; Bird needs cookies.

So the most “impactful” fix we can do without credentials is:
1) Make the check script fail *loud and useful* (actionable diagnostics), and
2) Add a **fallback narrative signal** that does not require keys/login, so the feature isn’t dead while we wait.

## Proposed approach
### A) Tighten the failure mode (actionable)
When missing keys/cookies, output:
- which env var is missing
- where to add it (TOOLS.md location)
- a one-line command to validate (e.g., `python src/narrative_hunter_check.py --self-test`)

Also ensure non-zero exit code only when the user explicitly requested strict mode; otherwise log + continue so Watchtower doesn’t die.

### B) Add fallback sources (no key)
Use a *cheap*, keyless “narrative pulse” from:
- **CoinGecko trending search** (public endpoint)
- **DexScreener boosted/trending** (public API)

We don’t need perfect sentiment — we just need “what’s being talked about / moving” as a narrative proxy.

Minimal output format suggestion:
- `topics`: list of tickers/names
- `source`: coingecko|dexscreener
- `reason`: trending|boosted|volume_spike

### C) Wire into Watchtower without breaking existing key-based path
- If CryptoPanic key available → use it.
- Else if Bird cookies available → use it.
- Else → fall back to CoinGecko + DexScreener narrative pulse.

## Concrete next steps (small code change set)
1. Add `--self-test` to `src/narrative_hunter_check.py` that prints a checklist.
2. Add `src/narrative_pulse.py`:
   - fetch CoinGecko trending
   - fetch DexScreener boosted
   - normalize into a shared `PulseItem` dict
3. Update `watchtower.py`:
   - call narrative pulse when keys are missing
   - include top 5 items in the daily briefing/log

## Questions for Kenny/Wonka
- Do you want Narrative Hunter to be **strict** (error if no keys) or **best-effort** (fallback + warn)?
- For the fallback, should we constrain to majors only (BTC/ETH/SOL/QNT/XRP/BNB) or allow “random Solana garbage” too?
