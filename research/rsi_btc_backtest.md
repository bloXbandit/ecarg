# Backtest Results: BTC RSI Mean Reversion (4H)

**Strategy:** Long Only. Buy when RSI(14) < 30. Sell when RSI(14) > 70.
**Asset:** BTC-USD
**Timeframe:** 4 Hours
**Period:** Last 1 Year (approx. Feb 2025 - Feb 2026)

## Executive Summary
The strategy yielded a **negative return of -20.95%** over the last year, despite a win rate slightly above 50% (53.57%). This suggests that while the entry signal (RSI < 30) often catches local bottoms, the exit signal (RSI > 70) is too slow or the market trends against the position significantly before recovering, leading to large drawdowns or selling at a loss if the "bounce" is weak.

## Detailed Metrics
- **Initial Balance:** $10,000.00
- **Final Balance:** $7,905.14
- **Net Profit/Loss:** -$2,094.86 (-20.95%)
- **Total Trades:** 56 (28 Round Trips)
- **Win Rate:** 53.57% (15 Winning Trades / 13 Losing Trades)

## Observations
- **Trend Fighting:** RSI < 30 is a counter-trend signal. In strong downtrends, RSI can stay oversold for long periods while price crashes. The strategy keeps holding until RSI > 70, which might happen at a much lower price level (a "dead cat bounce").
- **Exit Efficiency:** Waiting for RSI > 70 might be too greedy. A quicker exit (e.g., RSI > 50) or a stop-loss could improve performance.
- **Recent Performance:** The last 5 trades show some profitable swings, indicating the market might be ranging recently, which favors this strategy.

## Recommendations
1.  **Add Stop Loss:** Protect capital against strong downtrends.
2.  **Trend Filter:** Only take RSI < 30 buys if price is above a long-term moving average (e.g., SMA 200).
3.  **Adjust Exit:** Test exiting at RSI > 50 to capture smaller mean reversions.

## Trade Log (Sample)
*(See `src/research_rsi_btc.py` output for full details)*
- 2026-02-08: SELL @ 69,640 (RSI: 75.2)
- 2026-02-11: BUY @ 67,025 (RSI: 29.0)
- 2026-02-15: SELL @ 69,957 (RSI: 82.5)
- 2026-02-17: BUY @ 67,354 (RSI: 28.5)
- 2026-02-21: SELL @ 68,522 (RSI: 74.9)
