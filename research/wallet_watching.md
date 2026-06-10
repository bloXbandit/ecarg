# Research: Wallet Watching (Smart Money Tracking)

## Objective
Monitor specific "Smart Money" or "Insider" wallets on Solana for real-time trade signals (Copy Trading Lite).

## Methods
1.  **Polling (RPC):**
    *   Periodically call `getSignaturesForAddress` for target wallets.
    *   Parse new transactions to identify SWAPS (using logs or instruction parsing).
    *   Pros: Simple, works with standard RPC.
    *   Cons: Rate limits, latency (might miss the pump).

2.  **Websockets (WSS):**
    *   Use `solana.rpc.websocket_api` to `accountSubscribe`.
    *   Receive notifications when lamports/data change.
    *   Fetch transaction details immediately upon signal.
    *   Pros: Low latency, real-time.
    *   Cons: Requires stable WSS connection (Helius/QuickNode free tiers have limits).

3.  **Third-Party APIs:**
    *   **SolanaTracker.io:** Specialized API for wallet tracking.
    *   **Birdeye / GMGN:** Paid APIs for smart money signals.

## Proposed Architecture (Free Tier)
*   **Target List:** `BRAIN/smart_money.json` (List of addresses to watch).
*   **Engine:** `src/wallet_watcher_v2.py`
    *   Connects to WSS (e.g., Helius/Triton free).
    *   Subscribes to `accountSubscribe` for targets.
    *   On update -> `get_transaction` -> Parse for "SWAP" instructions (Raydium/Jupiter).
    *   If Buy -> Alert "whale bought X".

## Implementation Draft
```python
import asyncio
from solana.rpc.websocket_api import connect
from solders.pubkey import Pubkey

async def watch_wallet(address):
    async with connect("wss://api.mainnet-beta.solana.com") as websocket:
        await websocket.account_subscribe(Pubkey.from_string(address))
        print(f"Watching {address}...")
        while True:
            msg = await websocket.recv()
            print(f"Activity detected on {address}: {msg}")
            # Trigger analysis
```

## Next Steps
1.  Identify 3-5 "Smart Money" wallets (need user input or research).
2.  Prototype `src/wallet_watcher_v2.py`.
