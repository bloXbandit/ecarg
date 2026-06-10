# Liquidation Heatmap Research (Attempt 3)

## Status
*   **Binance:** Blocked (451 Error).
*   **Bybit:** Blocked (403 Forbidden - likely Cloudflare geoblocking).

## New Plan: Kraken Futures API
Kraken is US-friendly(ish) and provides public market data.
*   **Endpoint:** `https://futures.kraken.com/derivatives/api/v3/tickers`
*   **Data:** Returns `openInterest` for all symbols.
*   **History:** Does Kraken provide OI history?
    *   Endpoint: `https://futures.kraken.com/derivatives/api/v3/history/market?symbol=PI_XBTUSD&resolution=1h` (Need to verify)

## Fallback: Coinglass Scraper (Risky/Hard)
Last resort is scraping Coinglass HTML, but that's brittle.

## Strategy Shift
If we cannot get historical OI, we cannot build the "Commitment Zone" model.
**Alternative:** Use **Volume Profile** as a proxy for liquidation clusters.
*   High Volume Nodes (HVN) = Areas of high commitment.
*   If price moves rapidly away from HVN, trapped traders exist.
*   Liquidation levels = HVN +/- (HVN / Leverage).

## Revised Implementation (Volume Profile Proxy)
1.  Fetch OHLCV from any accessible source (CoinGecko / Kraken / Coinbase).
2.  Calculate Volume Profile (Volume at Price).
3.  Identify High Volume Nodes.
4.  Project liquidation levels from HVNs.

## Data Source: CoinGecko (Free)
*   `https://api.coingecko.com/api/v3/coins/bitcoin/ohlc?vs_currency=usd&days=7`
*   Returns: `[time, open, high, low, close]` (No Volume? Need to check).
*   Better: `https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=usd&days=7` -> returns prices and total_volumes.

Let's try the Volume Profile approach. It's robust and API-friendly.
