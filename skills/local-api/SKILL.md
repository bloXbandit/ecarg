---
name: local-api
description: Connect to and query local network APIs — home servers, LAN services, local trading bots, Pi-hosted endpoints, or any service on the same network as the Pi. Use when a URL contains a private IP (192.168.x.x, 10.x.x.x, 172.16-31.x.x) or localhost/hostname.
metadata: {"moltbot":{"emoji":"🔌","requires":{"bins":["curl"]}}}
---

# local-api — LAN & Local Service Access

Ecarg runs on the Pi with gateway bound to LAN (`bind: lan`, port 18789).
It can reach any service on the same network without going through the internet.

## Common patterns

### GET a local endpoint

```bash
curl -sf http://192.168.1.X:PORT/endpoint | jq .
```

### POST with JSON

```bash
curl -sf -X POST http://192.168.1.X:PORT/endpoint \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'
```

### With auth header

```bash
curl -sf http://192.168.1.X:PORT/endpoint \
  -H "Authorization: Bearer $LOCAL_API_TOKEN"
```

### Check if a local service is up

```bash
curl -sf --connect-timeout 3 http://192.168.1.X:PORT/health && echo "UP" || echo "DOWN"
```

## Known local services

| Service | Address | Notes |
|---|---|---|
| Moltbot gateway | `ws://127.0.0.1:18789` | Local agent control plane |
| MortgageSesame backend | `http://192.168.0.35:8000` | FastAPI — mortgage platform API |
| WonkaTrade | TBD | Add IP:PORT when running |

## Pi gateway is accessible from LAN at

```
ws://<pi-ip>:18789
http://<pi-ip>:18789
```

Find Pi's IP: `hostname -I | awk '{print $1}'`

## mDNS / Bonjour

With `discovery.mdns.mode: full`, the Pi advertises itself on the local network.
Other devices can reach it at `moltbot.local:18789` without knowing the IP.

## Private IP ranges (always LAN — never internet)

- `10.0.0.0/8`
- `172.16.0.0/12`
- `192.168.0.0/16`
- `127.0.0.1` / `localhost`

## Timeout recommendation

Always set `--connect-timeout 5` for local requests — if a service is down you don't want to hang.
