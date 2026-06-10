# Research: The Bullshit Detector (Scam Check)

**Goal:** Automate due diligence on tokens/projects to avoid "rug pulls" and "honeypots."

**Target APIs:**
1.  **GoPlus Security API:**
    -   **Pros:** Multi-chain (ETH, BSC, SOL, etc.), detects honeypots, slippage limits, hidden owner functions.
    -   **Docs:** https://docs.gopluslabs.io/
    -   **Endpoint:** `/api/v1/token_security/{chain_id}?contract_addresses={address}`
2.  **RugCheck.xyz (Solana specific):**
    -   **Pros:** Best-in-class for Solana (liquidity lock status, mutable metadata).
    -   **API:** https://api.rugcheck.xyz/v1/tokens/{mint}/report

**Implementation Plan (`src/scam_check.py`):**
1.  **Input:** Contract Address (CA) + Chain (default to SOL/ETH based on format).
2.  **Process:**
    -   Detect chain.
    -   Call GoPlus (or RugCheck for SOL).
    -   Parse "Is Honeypot?", "Buy/Sell Tax", "Renounced Ownership", "Liquidity Locked".
3.  **Output:** A simple "Safe / Risky / SCAM" score.

**Python Strategy:**
-   Use `requests` library.
-   No API key required for basic GoPlus tier (usually).
-   If high risk, Auto-Reply to user: "🚨 SCAM DETECTED. DO NOT BUY."

**Next Steps:**
-   Write `src/scam_check.py` to query GoPlus API.
