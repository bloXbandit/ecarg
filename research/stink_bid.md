# Research: The Stink Bid Strategy

**Goal:** Determine optimal limit order placement for catching "falling knives" (high volatility crashes) without getting wrecked.

**Core Concept:**
- **Volatility Scaling:** Order distance from current price must be proportional to volatility (ATR or BB width).
- **Low Volatility:** Place bids 1-3% below market.
- **High Volatility (Crash Mode):** Place bids 5-15% below market.

**Heuristic for implementation:**
1.  **Calculate Volatility:** Use Bollinger Band Width or ATR (Average True Range).
2.  **Dynamic Distance:**
    - If `Vol` is low (<2% daily range): Bid at -2%.
    - If `Vol` is med (2-5% daily range): Bid at -5%.
    - If `Vol` is extreme (>5% daily range): Bid at -10% to -15%.

**Indicators to Gate Bids:**
- **RSI (14):** Must be < 30 (Oversold).
- **Volume Profile:** Place bids at high-volume nodes (support levels) below current price.
- **Sentiment:** Fear & Greed < 20.

**Action Plan:**
- Modify `watchtower.py` to calculate dynamic bid levels based on volatility.
- Suggest specific "Stink Bid" prices in daily briefings or alerts.
