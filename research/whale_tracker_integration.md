# Research: Integration of Whale Tracker into Cron Workflow

**Goal:** Automate the execution of `src/whale_watcher.py` every hour to detect market movements.

**Steps:**

1.  **Environment Setup:**
    -   The script requires `WHALE_ALERT_KEY` in the environment.
    -   Need to update `TOOLS.md` with instructions on how to get this key (Free tier: 10 req/min).

2.  **Cron Job Configuration:**
    -   Frequency: Every hour (`0 * * * *`).
    -   Command: `/usr/bin/python3 /home/bpwonka/clawd/src/whale_watcher.py`
    -   Output handling: Append to a log file (`logs/whale_alerts.log`) or pipe to a Telegram sender script if critical.

3.  **Alerting Logic (Optional Expansion):**
    -   Currently, `whale_watcher.py` prints to stdout.
    -   To send alerts, we can pipe the output to `moltbot message send`.
    -   Example Cron:
        ```bash
        0 * * * * python3 /home/bpwonka/clawd/src/whale_watcher.py | grep "🚨" | xargs -I {} moltbot message send --to 7488398568 --message "{}"
        ```
    -   Or modify `whale_watcher.py` to call `moltbot` directly if a threshold is met (e.g., >$10M exchange inflow).

**Action Items:**
-   Update `TOOLS.md` with API key instructions.
-   Create a wrapper script `src/run_whale_scan.sh` that sets up the environment and runs the python script.
-   Add the cron job using `crontab -e`.
