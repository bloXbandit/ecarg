# Smart RSI Backtest (5 Years)

**Date Run:** 2026-02-22
**Data Source:** Yahoo Finance (BTC-USD)

## Strategy Logic
- **Buy:** RSI < 30 AND Price > 200 SMA
- **Sell:** RSI > 70 OR Price < 200 SMA
- **Initial Capital:** $1,000,000 (Whale Mode)

## Results
- **Strategy Return:** 7.19%
- **Buy & Hold:** 45.24%
- **Trades:** 12
- **Win Rate:** 58.33%
- **Max Drawdown:** -26.61%
- **Sharpe Ratio:** 0.08

## Raw Stats
```
Start                     2021-02-22 00:00:00
End                       2026-02-22 00:00:00
Duration                   1826 days 00:00:00
Exposure Time [%]                    14.61412
Equity Final [$]                 1071897.2221
Equity Peak [$]                 1143748.90565
Commissions [$]                   46189.65095
Return [%]                            7.18972
Buy & Hold Return [%]                45.23812
Return (Ann.) [%]                     1.39675
Volatility (Ann.) [%]                18.25169
CAGR [%]                              1.39752
Sharpe Ratio                          0.07653
Sortino Ratio                         0.11278
Calmar Ratio                          0.05249
Alpha [%]                             2.59974
Beta                                  0.10146
Max. Drawdown [%]                   -26.61025
Avg. Drawdown [%]                   -10.35728
Max. Drawdown Duration      929 days 00:00:00
Avg. Drawdown Duration      222 days 00:00:00
# Trades                                   12
Win Rate [%]                         58.33333
Best Trade [%]                       22.29392
Worst Trade [%]                     -17.40669
Avg. Trade [%]                        0.62749
Max. Trade Duration          41 days 00:00:00
Avg. Trade Duration          22 days 00:00:00
Profit Factor                         1.29351
Expectancy [%]                        1.39353
SQN                                   0.16971
Kelly Criterion                       0.06372
_strategy                    SmartRsiStrategy
_equity_curve                             ...
_trades                       Size  EntryB...
dtype: object
```