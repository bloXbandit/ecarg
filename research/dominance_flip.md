# Research: The Dominance Flip

## Hypothesis
Does rising BTC Dominance (simulated via falling ETH/BTC and SOL/BTC pairs) reliably crush alts? Specifically, does BTC pumping usually lead to Alts bleeding against BTC?

## Methodology
- **Data:** Daily close prices for BTC, ETH, SOL (Last 365 Days).
- **Metric:** Analyzed correlation between BTC daily % change and ETH/BTC ratio % change.
- **Regimes Definitions:**
    - **BTC_PUMP_ALTS_BLEED:** BTC > +2% AND ETH/BTC < -1% (Bitcoin sucks liquidity)
    - **EVERYTHING_PUMP:** BTC > +2% AND ETH/BTC > +1% (Rising tide)
    - **ALT_SEASON_MINI:** BTC Flat (-1% to 1%) AND ETH/BTC > +2% (Capital rotation)
    - **EVERYTHING_DUMP:** BTC < -2% AND ETH/BTC < -1% (Panic selling)
    - **BTC_DUMP_ALTS_RESILIENT:** BTC < -2% AND ETH/BTC > +1% (Flight to quality alts?)

## Results (Last 365 Days)

| Regime | Count | Avg ETH/BTC Change | Interpretation |
| :--- | :--- | :--- | :--- |
| **EVERYTHING_DUMP** | 39 | -2.97% | When BTC dumps, Alts get slaughtered (-2.97% *against* BTC, meaning ~-5% against USD). |
| **BTC_DUMP_ALTS_RESILIENT** | 3 | 1.90% | Extremely rare for Alts to hold up when BTC crashes. |
| **Neutral** | 238 | -0.38% | Most days are noise. |
| **EVERYTHING_PUMP** | 26 | 3.66% | When BTC pumps, Alts actually outperform often (Beta > 1). |
| **BTC_PUMP_ALTS_FLAT** | 11 | 0.16% | BTC pump doesn't always drag Alts up significantly. |
| **ALT_SEASON_MINI** | 35 | 3.92% | Flat BTC is the best environment for Alts. |
| **BTC_PUMP_ALTS_BLEED** | 12 | -2.05% | The "Dominance Flip" scenario is less common than the "Everything Pump" scenario. |

## Conclusion
**Myth Busted:** The idea that "BTC Pumping kills Alts" (Dominance Flip) happened only 12 times in the last year.
**Reality:** 
1. **Correlation is High:** When BTC pumps, Alts usually pump harder (26 times vs 12).
2. **Danger Zone:** The real danger is `EVERYTHING_DUMP` (39 times). When BTC falls, Alts fall *much* harder relative to BTC.
3. **Sweet Spot:** `ALT_SEASON_MINI` (35 times) shows that Alts thrive when BTC is boring (flat).

**Strategy Implication:**
- **Bull Market:** Long Alts (ETH/SOL) is better than Long BTC (higher beta).
- **Bear Market:** Short Alts is better than Short BTC (they bleed faster).
- **BTC Breakout:** Don't fear the "liquidity suck" too much; odds favor a follow-through.
