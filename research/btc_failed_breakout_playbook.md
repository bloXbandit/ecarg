# BTC Failed Breakout Short (Playbook)

**Purpose:** repeatable, rules-based short entry for BTC when a breakout fails and price starts to reverse.

This is the exact pattern we used on 2026-03-04 around ~74k.

## Core idea
A strong up-move makes a new local high, but buyers fail to hold it. When price closes back below the prior breakout level, that’s a trap / failed breakout. The edge is not prediction; it’s **structure + confirmation**.

## Inputs
- Timeframes: 15m structure, 5m confirmation
- Levels:
  - `prior15_high`: the high from the 15 minutes **before** the last 15-minute window
  - `last15_high`: the high of the most recent closed 15-minute window

## Trigger (SHORT NOW)
Fire a short alert when BOTH are true:
1. **New high event:** `last15_high > prior15_high`
2. **Failure confirmation:** the last closed **5m candle** closes **below** `prior15_high`

This is the “new high → failed hold” trap.

## Optional early trigger (more aggressive)
- 5m close < prior 15m low (breakdown). Use only if the goal is to catch downside early.

## Risk rules (non-negotiable)
- **Invalidation stop:** above the new high (`last15_high`) + buffer.
  - Typical buffer: 0.1%–0.3% depending on volatility.
- **No averaging up** unless explicitly allowed.

## Take-profit framework
Because 10% down days are rare, treat this as a scalp unless broader structure breaks:
- TP1: +1–2% move in your favor (lock profit)
- TP2: +3–5% if momentum continues
- Leave a small runner only if breakdown continues (lower lows on 15m).

## When NOT to short
- If price reclaims and starts closing back above `prior15_high` (failed failure) → skip or exit.
- If the move is grinding higher with no rejection close → do nothing.

## Implementation notes
- This playbook is implemented by `src/btc_alerts.py` under the **failed breakout** trigger.
- Alerts should be **deduped per 5m candle** to avoid spam.

## What to log for improvement
- Timestamp of signal, `prior15_high`, `last15_high`, 5m close
- Entry price, stop, exits, realized PnL
- Whether the move hit TP1/TP2 and max adverse excursion (MAE)
