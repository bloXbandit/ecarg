# Self-Healing: Wallet Watcher Cron

Date: 2026-03-03

## Goal
Make `src/wallet_watcher_v2.py` self-heal if it crashes / PID file goes stale.

## What I changed
### 1) Added an `ensure` command to the runner
File: `src/run_wallet_watcher.sh`

- New subcommand: `ensure`
- Behavior:
  - If PID file exists *and* process is alive → no-op (prints running PID)
  - Otherwise → starts the watcher via existing `start()` logic (which also cleans stale PID files)

Usage:
```bash
cd /home/bpwonka/clawd
bash src/run_wallet_watcher.sh ensure
```

### 2) Installed a cron self-heal loop
User crontab now includes:
```cron
*/5 * * * * cd /home/bpwonka/clawd && bash src/run_wallet_watcher.sh ensure >> logs/wallet_watcher_self_heal.log 2>&1
```

This checks every 5 minutes and restarts the watcher if it’s not running.

## Notes
- Self-heal log: `logs/wallet_watcher_self_heal.log`
- Runner still uses `../WonkaTrade/venv/bin/python3` (same as before). If that path changes, update `src/run_wallet_watcher.sh`.
