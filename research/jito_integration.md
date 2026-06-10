# Research: Jupiter Swap via Jito Bundles (MEV Protection)

**Goal:** Modify the trading execution logic to route Jupiter Swaps through Jito Bundles instead of public RPCs.

**Workflow:**
1.  **Get Quote:**
    -   Use Jupiter V6 Quote API: `https://quote-api.jup.ag/v6/quote`
    -   Params: `inputMint`, `outputMint`, `amount`, `slippageBps`.
2.  **Get Serialized Transaction:**
    -   Use Jupiter V6 Swap API: `https://quote-api.jup.ag/v6/swap`
    -   Payload: `quoteResponse`, `userPublicKey`, `wrapAndUnwrapSol: true`.
    -   **Critical:** Do NOT sign or send yet. Get the base64 `swapTransaction`.
3.  **Construct Jito Bundle:**
    -   Decode the Jupiter `swapTransaction` (base64 -> bytes).
    -   Create a `VersionedTransaction` (Solana Python SDK) from the bytes.
    -   Create a **Tip Transaction**:
        -   Transfer `0.0001 SOL` (or dynamic amount) to a random Jito Tip Account.
    -   **Sign Both Transactions** with the user's keypair.
    -   Encode both as base64 strings.
4.  **Send Bundle:**
    -   Endpoint: `https://mainnet.block-engine.jito.wtf/api/v1/bundles`
    -   Method: `sendBundle`
    -   Params: `[[encoded_swap_tx, encoded_tip_tx]]`

**Code Snippet (Concept):**

```python
import base64
import requests
from solana.rpc.api import Client
from solders.transaction import VersionedTransaction
from solders.keypair import Keypair

def execute_jito_swap(quote_response, user_keypair):
    # 1. Get Swap Tx from Jupiter
    swap_payload = {
        "quoteResponse": quote_response,
        "userPublicKey": str(user_keypair.pubkey()),
        "wrapAndUnwrapSol": True
    }
    resp = requests.post("https://quote-api.jup.ag/v6/swap", json=swap_payload).json()
    swap_tx_b64 = resp['swapTransaction']
    
    # 2. Deserialize
    swap_tx_bytes = base64.b64decode(swap_tx_b64)
    tx = VersionedTransaction.from_bytes(swap_tx_bytes)
    
    # 3. Create Tip Tx (See src/jito_proxy.py for details)
    tip_tx = create_tip_transaction(user_keypair, 10000) # 0.00001 SOL
    
    # 4. Sign
    # Swap tx is already partially signed? No, usually unsigned from API, but blockhash set.
    # Jupiter V6 returns a VersionedTransaction that needs signing.
    signed_tx = VersionedTransaction(tx.message, [user_keypair]) # Check if blockhash is fresh
    tip_tx.sign([user_keypair])
    
    # 5. Bundle
    bundle = [
        base64.b64encode(bytes(signed_tx)).decode('utf-8'),
        base64.b64encode(bytes(tip_tx)).decode('utf-8')
    ]
    
    # 6. Send
    send_bundle_to_jito(bundle)
```

**Key Challenges:**
-   **Blockhash Expiry:** The blockhash in the Jupiter quote/swap response must be valid when it hits Jito. Usually fine, but Jito is fast.
-   **Tip Amount:** Needs to be dynamic. 1000 lamports is min, but 10,000 is safer for landing.
-   **Library compatibility:** Ensure `solders` (new Solana library) is installed and compatible with `solana` SDK.

**Implementation Plan:**
1.  **Modify `JupiterSwapper.execute_swap()`:**
    -   After getting the `swapTransaction` from Jupiter, *do not* send it directly.
    -   Instead, pass it to a new function: `send_jito_bundle(swap_tx_b64, self.keypair)`.
2.  **Create `send_jito_bundle()`:**
    -   Decode the base64 `swapTransaction`.
    -   Sign it with `self.keypair`.
    -   Create and sign a tip transaction (send 0.00001 SOL to a random Jito tip account).
    -   Send both as a bundle to `https://mainnet.block-engine.jito.wtf/api/v1/bundles`.
3.  **Update `src/jito_proxy.py`:**
    -   Add `send_jito_bundle(swap_tx_b64, keypair)` function.
    -   This function will handle the decoding, signing, and bundling.
4.  **Test:**
    -   Run a micro swap (0.0005 SOL) to verify the bundle lands.
    -   Check `explorer.jito.wtf` for the bundle.

**Next Steps:**
-   Modify `src/jupiter_swapper.py` to use the new Jito flow.
-   Test with a tiny amount to ensure bundles are processed.
