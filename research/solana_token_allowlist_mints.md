# Solana token allowlist (mints + decimals)

Verified mint addresses for execution allowlist.

## USDC
- Symbol: USDC
- Mint: `EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v`
- Decimals: 6
- Explorer: https://explorer.solana.com/address/EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v

## SOL (wrapped SOL mint used by Jupiter)
- Symbol: SOL
- Mint: `So11111111111111111111111111111111111111112`
- Decimals: 9
- Explorer: https://explorer.solana.com/address/So11111111111111111111111111111111111111112

## BONK (Bonk)
- Symbol: BONK
- Mint: `DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263`
- Decimals: 5
- Explorer: https://explorer.solana.com/address/DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263

## WIF (dogwifhat)
- Symbol: WIF
- Mint: `EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm`
- Decimals: 6
- Explorer: https://explorer.solana.com/address/EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm

## JUP (Jupiter)
- Symbol: JUP
- Mint: `JUPyiwrYJFskUPiHa7hkeR8VUtAeFoSYbKedZNsDvCN`
- Decimals: 6
- Explorer: https://explorer.solana.com/address/JUPyiwrYJFskUPiHa7hkeR8VUtAeFoSYbKedZNsDvCN

## How decimals were verified
Decimals were verified by reading the on-chain SPL Mint account (RPC `getAccountInfo`) and decoding the SPL Mint layout (decimals byte at offset 44).
