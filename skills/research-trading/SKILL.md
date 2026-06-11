---
name: research-trading
description: Focused session mode for WonkaTrade, crypto research, market analysis, and trading bot work. Loads only trading-relevant context. Trigger on "research mode", "trading mode", "wonkatrade", or any crypto/trading task.
metadata: {"moltbot":{"emoji":"📈","requires":{"bins":["curl","python3"]}}}
---

# research-trading — Research & Trading Session

Focused mode for WonkaTrade, crypto analysis, market lookups, and trading bot dev.

## Enter mode

Triggers: "research mode", "trading mode", "wonkatrade", any crypto pair or market question

```bash
BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
echo "{\"active\":true,\"mode\":\"research-trading\",\"entered_at\":$(date +%s),\"last_activity\":$(date +%s)}" \
  > "${BRAIN_DIR}/sessions/research_trading_mode.json"
echo "📈 Research/Trading Mode ON"
```

## Exit mode

Triggers: "research mode off", "trading mode off", exit after 45 min silence

```bash
BRAIN_DIR="${BRAIN_DIR:-/home/bpwonka/apps/moltbot/BRAIN}"
STATE="${BRAIN_DIR}/sessions/research_trading_mode.json"
[ -f "$STATE" ] && echo "{\"active\":false,\"exited_at\":$(date +%s)}" > "$STATE"
echo "📈 Research/Trading Mode OFF"
```

## Context rules

- Load: WonkaTrade project context from `BRAIN/agents/project_agent_state.md` (trading section only)
- Load: high-weight memory hits tagged `project` or `pattern` for WonkaTrade
- Do NOT load: mortgage data, personal preferences, unrelated history
- Target: 2–5K tokens round trip for analysis, 1–2K for quick lookups

## While in mode

- Prefix replies with 📈
- Focus on: WonkaTrade code, CCXT/Solana/DEX, crypto prices, strategy analysis
- For market data: use curl to public APIs (CoinGecko, Jupiter, etc.)
- For deep code/strategy work: route to ecarg-deep via sessions_spawn

## Market data — quick lookups

```bash
# CoinGecko price
curl -sf "https://api.coingecko.com/api/v3/simple/price?ids=solana&vs_currencies=usd" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d)"

# Jupiter token info (Solana DEX)
curl -sf "https://price.jup.ag/v4/price?ids=SOL" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d)"
```

## WonkaTrade project location

`/home/bpwonka/WonkaTrade/` — Python, CCXT, Solana/Jupiter integration

## Route to ecarg-deep when

- Reviewing or refactoring run_bot.py or strategy logic
- Debugging CCXT errors or swap failures
- Designing new trading strategies
- Any task requiring multi-step reasoning over code
