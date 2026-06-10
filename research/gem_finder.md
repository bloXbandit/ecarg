# Research: The Gem Finder (DexScreener API)

**Objective:** Identify trending Solana tokens with organic volume (>1M) and liquidity (>$100k) using free DexScreener APIs.

## API Endpoints Identified

### 1. Boosted/Trending Tokens
*   **Endpoint:** `https://api.dexscreener.com/token-boosts/top/v1`
*   **Method:** GET
*   **Data:** Returns a list of boosted tokens.
*   **Filtering:** Filter JSON for `chainId: "solana"`.
*   **Pros:** Lists "hot" tokens active right now.
*   **Cons:** Paid boosts (often scams/cabals), need to verify metrics.

### 2. Token Metrics (Price/Vol/Liq)
*   **Endpoint:** `https://api.dexscreener.com/latest/dex/tokens/{tokenAddresses}`
*   **Method:** GET
*   **Limit:** Up to 30 addresses per call (comma-separated).
*   **Data:** Returns pairs including:
    *   `liquidity.usd`
    *   `volume.h24`
    *   `priceChange.h24`
    *   `pairCreatedAt` (Age check)

## Proposed Algorithm ("The Gem Filter")

1.  **Fetch Candidates:**
    *   Call `/token-boosts/top/v1` to get ~50 boosted tokens.
    *   Filter for `chainId == 'solana'`.
    *   Extract `tokenAddress` list.

2.  **Enrich Data:**
    *   Batch addresses (groups of 30).
    *   Call `/latest/dex/tokens/{addresses}`.

3.  **Apply Filters (The "Real Shit" Test):**
    *   **Liquidity:** > $50,000 (Min) / > $100,000 (Ideal)
    *   **Volume (24h):** > $500,000
    *   **Age:** > 1 hour (Filter instant rugs)
    *   **FDV:** < $50M (Upside potential)

4.  **Output:**
    *   List of tokens passing criteria.
    *   Risk score (using existing `scam_check.py` logic).

## Implementation Plan
1.  Create `src/gem_finder.py`.
2.  Implement `fetch_boosted_tokens()`.
3.  Implement `get_token_metrics(addresses)`.
4.  Implement `filter_gems(pairs)`.
5.  Add CLI command `python3 src/gem_finder.py --min-liq 50000`.

## Next Steps
*   [ ] Create `src/gem_finder.py` draft.
*   [ ] Add cron job to run Gem Finder every 4 hours and post results to a log file or Telegram.
