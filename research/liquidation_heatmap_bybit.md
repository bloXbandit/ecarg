# Liquidation Heatmap Research

## API Issues
Binance Futures API (`fapi.binance.com`) is geofenced for US IPs, returning 451 Errors.

## Alternative: Bybit API
Bybit provides free Open Interest data via their V5 Market API without authentication for public data.

### Bybit Endpoint
*   **URL:** `https://api.bybit.com/v5/market/open-interest`
*   **Method:** GET
*   **Params:**
    *   `category`: `linear` (for USDT perps)
    *   `symbol`: `BTCUSDT`
    *   `intervalTime`: `1h` (Matches our candle timeframe)
    *   `limit`: 200 (Max 200, need to paginate or just use last 200 hours = 8.3 days)

### Kline Endpoint
*   **URL:** `https://api.bybit.com/v5/market/kline`
*   **Method:** GET
*   **Params:**
    *   `category`: `linear`
    *   `symbol`: `BTCUSDT`
    *   `interval`: `60` (1h)
    *   `limit`: 200

## Plan Update
Switch `src/liquidation_engine.py` to use Bybit V5 API instead of Binance. Bybit is generally friendlier to US IPs for public data (though trading is restricted).

## Revised Implementation
1.  Fetch Klines from Bybit.
2.  Fetch OI History from Bybit.
3.  Apply same "Commitment Zone" logic.
