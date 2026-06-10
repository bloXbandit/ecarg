# Research: The Narrative Hunter

**Goal:** Identify trending narratives (e.g., "AI Coins", "Gaming", "RWA") early by scraping news and social sentiment.

**Data Sources:**

1.  **CryptoPanic API:**
    -   **Status:** ⚠️ BROKEN (404 Error with current key).
    -   **Current Key:** `85d63e826583973f153db5bde9b1a7bf61f3ba14` (Returns 404 on all endpoints).
    -   **Action:** User needs to generate a new API key at `https://cryptopanic.com/developers/api/` and update `TOOLS.md`.
    -   **Endpoint:** `https://cryptopanic.com/api/v1/posts/?auth_token={KEY}&public=true`

2.  **Twitter (via Bird CLI):**
    -   **Status:** ❌ Inactive. Needs user login.
    -   **Requirement:** User must log in to `x.com` on Chrome/Safari/Firefox on the host machine.
    -   **Command:** `bird news --ai-only` or `bird trending`.
    -   **Action:** Add instruction to `TOOLS.md` to run `bird check` and login.

3.  **Web Search (Fallback):**
    -   **Query:** "Top crypto narratives this week", "trending crypto sectors".
    -   **Tools:** `web_search`.
    -   **Status:** Working. Can be used as a manual check.

**Next Steps:**
-   Ask user to refresh CryptoPanic key.
-   Ask user to log in to Twitter for Bird CLI.
-   Meanwhile, rely on manual `web_search` queries for narrative checks.
