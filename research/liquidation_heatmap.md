# Research: The Poor Man's Liquidation Heatmap

**Objective:** Estimate liquidation clusters ("Pain Zones") for BTC/ETH/SOL using free Binance public data, since we don't have a paid CoinGlass/Hyblock API key.

## Theory
High leverage positions are often opened during periods of consolidation where Open Interest (OI) rises but price is stable.
*   **Longs:** Trapped if price drops below `Entry * (1 - 1/Leverage)`.
*   **Shorts:** Trapped if price rises above `Entry * (1 + 1/Leverage)`.

## Data Source
*   **API:** Binance Futures API (Free)
*   **Endpoint:** `GET /futures/data/openInterestHist`
    *   Parameters: `symbol`, `period` (e.g., "5m", "15m", "1h"), `limit` (max 500).
*   **Endpoint:** `GET /fapi/v1/klines` (Price data)

## Proposed Algorithm

1.  **Fetch Data:**
    *   Get 1h Candles (OHLCV) for the last 7 days.
    *   Get 1h Open Interest history for the last 7 days.

2.  **Identify "Commitment Zones":**
    *   Find candles where **OI Increased** significantly (> X% change) AND **Volume** was high.
    *   Use the `VWAP` (Volume Weighted Average Price) of that candle as the "Entry Price" for that cluster.

3.  **Calculate Liquidation Levels:**
    *   For each Commitment Zone, project liquidation prices for 25x, 50x, and 100x leverage.
    *   **Long Liq:** `EntryPrice * (1 - MaintenanceMargin)` (approx `Entry * (1 - 1/Lev)`)
    *   **Short Liq:** `EntryPrice * (1 + MaintenanceMargin)` (approx `Entry * (1 + 1/Lev)`)

4.  **Aggregate & Decay:**
    *   Group these levels into price buckets (e.g., $100 bins for BTC, $1 bins for SOL).
    *   Apply a "Decay Factor": Older clusters matter less (positions likely closed/re-margined).
    *   Subtract OI if subsequent candles show OI decreasing (positions closing).

5.  **Visualization / Alerting:**
    *   **Heatmap:** List top 3 price levels with highest "Implied Liquidations".
    *   **Alert:** If `Current Price` is within 1% of a major cluster -> **"LIQUIDATION MAGNET DETECTED"**.

## Implementation Plan
1.  Create `src/liquidation_engine.py`.
2.  Implement `fetch_binance_data(symbol)`.
3.  Implement `calculate_heat_zones(data)`.
4.  Integrate into `watchtower.py` as a "Magnet" signal.

## Challenges
*   **Cross Margin:** Traders add margin, moving their liq price. This model assumes Isolated or fixed margin.
*   **OI Noise:** OI changes for many reasons (hedging, spot arb).
*   **Accuracy:** This is an *estimation*, not exact exchange data.

## Next Steps
*   [ ] Write `src/liquidation_engine.py` prototype.
*   [ ] Test against known recent liquidation events to verify correlation.
