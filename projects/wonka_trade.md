# WonkaTrade Project Documentation

**Location:** /home/bpwonka/WonkaTrade/
**Language:** Python
**Framework:** Appears to use CCXT for exchange integration
**Status:** Active (files present)

## Project Structure
```
WonkaTrade/
├── data/           # Data storage
├── logs/           # Log files
├── src/            # Source code
├── venv/           # Python virtual environment
├── New/            # (Undocumented directory)
├── dex_monitor.py  # DEX monitoring script
├── jupiter_status.py # Jupiter aggregator status
├── manual_test.py  # Manual testing script
├── run_bot.py      # Main bot runner (4364 bytes)
├── run_micro_test.py  # Micro testing
├── run_swap_test.py   # Swap testing
├── test_backup_dexes.py # Backup DEX testing
├── test_connect.py    # Connection testing
└── test_data_stream.py # Data stream testing
```

## Dependencies
- CCXT (cryptocurrency trading library)
- Python 3.11
- Virtual environment configured

## Next Steps
- Analyze run_bot.py architecture
- Document trading strategies
- Identify exchange integrations
- Set up monitoring/alerting