# Research: Jupiter Limit Order API (V2/Trigger)

## Overview
Jupiter allows placing limit orders on Solana via their "Trigger API" (formerly Limit Order V2).
The endpoint is: `https://api.jup.ag/trigger/v1/createOrder`.

## Usage
1.  **Construct Payload:**
    *   `maker`: User public key.
    *   `payer`: User public key (usually same as maker).
    *   `inputMint`: Address of token to sell (e.g., USDC).
    *   `outputMint`: Address of token to buy (e.g., SOL).
    *   `makingAmount`: Amount of input token (in lamports/atomic units).
    *   `takingAmount`: Amount of output token desired (in lamports).
    *   `expiredAt`: Unix timestamp (optional).

2.  **Send Request:**
    POST to `https://api.jup.ag/trigger/v1/createOrder`.

3.  **Sign & Submit:**
    The API returns a base64 encoded transaction. The bot needs to sign this with the private key and submit it to the network (or use Jupiter's `/execute` endpoint if available/supported).

## Implementation Plan
1.  Create `src/jupiter_limit.py`.
2.  Implement `create_limit_order(side, price, amount)`.
    *   Calculate `makingAmount` and `takingAmount` based on price.
    *   For BUY (SOL/USDC):
        *   Input: USDC (makingAmount = amount * price)
        *   Output: SOL (takingAmount = amount)
    *   For SELL (SOL/USDC):
        *   Input: SOL (makingAmount = amount)
        *   Output: USDC (takingAmount = amount * price)
3.  Add "Stink Bid" automation to `watchtower.py` (optional: auto-place order vs just alert).

## Constraints
*   Minimum order size is usually ~$5 USD.
*   Requires a valid RPC connection to submit (or use Jito bundle logic).

## References
*   Docs: `https://dev.jup.ag/docs/trigger-api/create-order`
