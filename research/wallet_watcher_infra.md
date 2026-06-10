# Infrastructure: Wallet Watcher Daemon

## Objective
Keep `src/wallet_watcher_v2.py` running in the background persistently to monitor smart money wallets.

## Approach: Simple Shell Script Wrapper (Nohup)
Since we might not have `pm2` or root access for `systemd`, we will use a robust shell script wrapper with `nohup`.

## Script: `src/run_wallet_watcher.sh`
*   **Start:** Runs the python script in background, saves PID.
*   **Stop:** Kills the process using the PID file.
*   **Logs:** Redirects stdout/stderr to `logs/wallet_watcher.log`.

## Usage
*   `./src/run_wallet_watcher.sh start`
*   `./src/run_wallet_watcher.sh stop`
*   `./src/run_wallet_watcher.sh status`

## Cron Integration (Self-Healing)
We can add a cron job to check if the process is running every 5 minutes and restart it if it died.
`*/5 * * * * /home/bpwonka/clawd/src/run_wallet_watcher.sh start`

(The start function checks PID file existence before starting, so it's idempotent-ish, though strict PID checking is better).

## Implementation
1.  Create `src/run_wallet_watcher.sh`.
2.  Make executable.
3.  Add Cron job for reliability.
