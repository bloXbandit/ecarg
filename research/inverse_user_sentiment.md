# Inverse User Sentiment Tracker (Setup Phase)

**Date:** 2026-02-22
**Status:** 🟡 Pending Market Calls

## Objective
To test the "Inverse Cramer" hypothesis on this specific user: *Do the user's directional calls consistently counter-trade the actual market direction?*

## Methodology
1.  **Signal Detection:** Scan chat logs for directional keywords:
    *   **Bullish:** "buy", "long", "moon", "pump", "cheap", "bottom"
    *   **Bearish:** "sell", "short", "dump", "top", "crash", "expensive"
2.  **Timeframe:** Correlate signal timestamp with:
    *   1-Hour Price Action
    *   4-Hour Price Action
    *   24-Hour Price Action
3.  **Scoring:**
    *   **Inverse Genius:** Market moves opposite to user call > 60% of the time.
    *   **Retail Normie:** Market moves opposite ~50% (random walk).
    *   **Alpha God:** Market moves with user call > 60% of the time.

## Current Analysis (Session 40fe9a41...)
*   **User Focus:** Infrastructure & Dev (Backend tests, data integrity).
*   **Sentiment:** Neutral / Inquisitive.
*   **Detected Signals:** 0
*   **Conclusion:** User is currently building, not trading. No liquidation risk detected.

## Next Steps
*   Monitor for "FOMO" keywords during green candles.
*   Monitor for "Capitulation" keywords during red candles.
