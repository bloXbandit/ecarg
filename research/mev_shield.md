# Research: MEV Shield (Solana Protection)

**Goal:** Protect user's manual and automated trades from "Sandwich Attacks" and front-running on Solana.

**The Problem:**
-   Public RPCs broadcast transactions to the mempool (or equivalent gossip).
-   MEV bots spot large buy orders.
-   Bot buys before you (Front-run), price goes up.
-   Bot sells after you (Back-run), profit.
-   User gets: Worst price (High slippage).

**The Solution: Private RPCs / Jito Bundles**
1.  **Jito (The Gold Standard):**
    -   **Mechanism:** Sends transactions directly to the Jito Block Engine (JBE).
    -   **Benefit:** Transactions skip the public gossip layer. They are only executed if they are included in a bundle.
    -   **Tip:** Requires a small "tip" (lamports) to the validator.
    -   **Endpoint:** `https://mainnet.block-engine.jito.wtf`
    -   **Python Integration:** `jito-solana` SDK or direct RPC calls to their engine.

2.  **Triton One (Yellowstone):**
    -   **Mechanism:** Direct TPU (Transaction Processing Unit) routing.
    -   **Benefit:** Extremely low latency, bypasses public congestion.
    -   **Cost:** Paid service (expensive for retail).

3.  **Helius / QuickNode:**
    -   Offer "MEV Protection" modes in their paid tiers.

**Recommendation for "Smart Ass Trader":**
-   **Use Jito Bundles.** Even for single transactions.
-   **Why:** It's effectively free (just a small tip) and guarantees no front-running because the tx is not public until mined.

**Action Plan:**
1.  Update `src/execute_order.py` (and the underlying execution engine) to support Jito.
2.  Add a `JITO_FEE` constant (e.g., 0.0001 SOL).
3.  When executing a trade, wrap it in a Jito bundle with the tip.

**Drafting `src/jito_proxy.py`:**
-   Need to research the exact JSON-RPC payload for Jito's `sendBundle` or `sendTransaction` (MEV protected).

**Next Step:**
-   Create a prototype script `src/jito_test.py` to send a 0.00001 SOL transfer via Jito to verify connectivity.
