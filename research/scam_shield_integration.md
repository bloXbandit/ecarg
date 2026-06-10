# Research: Integration of Scam Shield into Telegram Workflow

**Goal:** Enable the user to type `/check <CA>` in Telegram and receive an instant risk assessment.

**Current State:**
-   `src/scam_check.py` exists and works via CLI.
-   Moltbot (me) receives messages via Telegram.

**Integration Strategy:**
1.  **Command Parsing:**
    -   When I receive a message starting with `/check` or `check` followed by a Contract Address (CA), I will trigger `src/scam_check.py`.
    -   Regex for Solana CA: `[1-9A-HJ-NP-Za-km-z]{32,44}`
    -   Regex for EVM CA: `0x[a-fA-F0-9]{40}`

2.  **Execution Flow:**
    -   **Input:** `/check So111...`
    -   **Action:** `python3 src/scam_check.py So111... --chain solana` (auto-detect chain if possible).
    -   **Output:** Capture stdout.
    -   **Reply:** Format stdout as a Telegram message.

3.  **Refinement of `src/scam_check.py` Output:**
    -   The current output is human-readable text.
    -   For Telegram, we might want a "Short Summary" mode (e.g., `✅ SAFE` or `🚨 SCAM`).
    -   Update: The current script prints a nice report. I can just send that block.

4.  **Security:**
    -   Do not allow the user to inject shell commands (sanitize input).
    -   Only allow alphanumeric characters in the CA argument.

**Next Steps:**
-   Add a "Command Handler" capability to my own instructions (MEMORY.md or similar) so I know to look for this pattern.
-   (Self-Correction): I am the agent. I just need to remember to do it.

**Action Item:**
-   Update `MEMORY.md` with a "Standing Order" to treat `/check <CA>` as a command to run `src/scam_check.py`.
