# Research: The Whale Tracker (Smart Money Monitoring)

**Goal:** Detect large movements of BTC, ETH, SOL, QNT, and XRP to anticipate market dumps or pumps.

**Tools & APIs:**
1.  **Whale Alert API (Free Tier):**
    -   **Limit:** 10 requests/minute (Plenty for hourly checks).
    -   **Capabilities:** Returns large transactions across multiple blockchains.
    -   **Endpoint:** `https://api.whale-alert.io/v1/transactions`
    -   **Filter:** Minimum value (e.g., $500k).
    -   **Key:** User needs to sign up for a free key.

2.  **Etherscan / Solscan APIs:**
    -   **Goal:** Watch specific *known* smart money addresses (if identified).
    -   **Solscan:** Good for monitoring specific SPL token large transfers.
    -   **Etherscan:** `token_tx` endpoint for QNT whale movements.

**Implementation Strategy (`src/whale_watcher.py`):**
1.  **Poll Whale Alert API:**
    -   Every 10-60 minutes.
    -   Filter for: `BTC`, `ETH`, `SOL`, `QNT`, `XRP`.
    -   Filter min value: $1M USD.
    -   Filter transaction type: `transfer` (exchange inflows/outflows).

2.  **Exchange Flow Analysis:**
    -   **Inflow (Wallet -> Exchange):** 🔴 Bearish (Potential Sell Pressure).
    -   **Outflow (Exchange -> Wallet):** 🟢 Bullish (Accumulation/Cold Storage).

3.  **Alert Logic:**
    -   If > $10M Inflow to Binance/Coinbase -> **🚨 WHALE DUMP ALERT**.
    -   If > $10M Outflow to Unknown Wallet -> **🟢 WHALE ACCUMULATION ALERT**.

**Action Items:**
-   Register for Whale Alert API Key (Task for User).
-   Script `src/whale_watcher.py` to poll and parse these events.
-   Integrate into `watchtower.py` or run as cron.

**Command for User:**
`Please get a free API key from https://whale-alert.io/ and add it to .env as WHALE_ALERT_KEY`
