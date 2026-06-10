#!/usr/bin/env bash
# post-onboard-pi.sh
#
# Run AFTER: moltbot onboard --install-daemon
#
# What this does:
#   1. Locates the moltbot config written by the onboarding wizard
#   2. Deep-merges our multi-model + context settings into it
#      (preserves auth profiles, channels, gateway config the wizard set)
#   3. Sets up the BRAIN workspace directory structure inside the repo
#   4. Prints the ~/.profile exports needed to wire everything up
#
# Usage:
#   bash /home/bpwonka/apps/moltbot/scripts/post-onboard-pi.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BRAIN_DIR="$REPO_DIR/BRAIN"

# ── resolve config path (respects env overrides) ─────────────────────────────

resolve_config_path() {
  if [ -n "${MOLTBOT_CONFIG_PATH:-}" ]; then echo "$MOLTBOT_CONFIG_PATH"; return; fi
  if [ -n "${CLAWDBOT_CONFIG_PATH:-}" ]; then echo "$CLAWDBOT_CONFIG_PATH"; return; fi
  local state_dir="${MOLTBOT_STATE_DIR:-${CLAWDBOT_STATE_DIR:-}}"
  if [ -n "$state_dir" ]; then echo "$state_dir/moltbot.json"; return; fi
  # prefer ~/.moltbot if it exists and ~/.clawdbot does not
  if [ -d "$HOME/.moltbot" ] && [ ! -d "$HOME/.clawdbot" ]; then
    echo "$HOME/.moltbot/moltbot.json"; return
  fi
  echo "$HOME/.clawdbot/moltbot.json"
}

CONFIG_PATH="$(resolve_config_path)"
BACKUP_PATH="${CONFIG_PATH}.pre-ecarg.bak"

# ── sanity checks ─────────────────────────────────────────────────────────────

echo "=== Ecarg post-onboard setup ==="
echo ""

if [ ! -f "$CONFIG_PATH" ]; then
  echo "ERROR: moltbot config not found at $CONFIG_PATH"
  echo "Run 'moltbot onboard --install-daemon' first, then re-run this script."
  exit 1
fi

if ! command -v node &>/dev/null; then
  echo "ERROR: node is required (install Node 22+)"
  exit 1
fi

echo "Repo     : $REPO_DIR"
echo "Config   : $CONFIG_PATH"
echo "BRAIN    : $BRAIN_DIR"
echo ""

# ── back up existing config ───────────────────────────────────────────────────

cp "$CONFIG_PATH" "$BACKUP_PATH"
echo "[1/4] Backup saved → $BACKUP_PATH"

# ── create BRAIN directory structure ─────────────────────────────────────────

mkdir -p \
  "$BRAIN_DIR/agents" \
  "$BRAIN_DIR/memory" \
  "$BRAIN_DIR/projects" \
  "$BRAIN_DIR/sessions"
chmod +x "$REPO_DIR/scripts/session-extractor.sh"
echo "[2/4] BRAIN directories created"

# ── merge multi-model config ──────────────────────────────────────────────────

REPO_DIR_ESC="$REPO_DIR" node --input-type=module <<'EOF'
import fs from "fs";

const configPath = process.env.MOLTBOT_CONFIG_PATH
  || process.env.CLAWDBOT_CONFIG_PATH
  || `${process.env.HOME}/.clawdbot/moltbot.json`;

const repoDir = process.env.REPO_DIR_ESC;
const brainDir = `${repoDir}/BRAIN`;

const existing = JSON.parse(fs.readFileSync(configPath, "utf8"));

function deepMerge(target, source) {
  const out = { ...target };
  for (const [key, value] of Object.entries(source)) {
    if (
      value !== null &&
      typeof value === "object" &&
      !Array.isArray(value) &&
      typeof out[key] === "object" &&
      out[key] !== null &&
      !Array.isArray(out[key])
    ) {
      out[key] = deepMerge(out[key], value);
    } else {
      out[key] = value;
    }
  }
  return out;
}

const patch = {
  agents: {
    defaults: {
      workspace: brainDir,
      thinkingDefault: "off",
      bootstrapMaxChars: 2000,
      contextTokens: 16000,
      contextPruning: {
        mode: "cache-ttl",
        keepLastAssistants: 4,
        softTrimRatio: 0.4,
        hardClearRatio: 0.75
      },
      compaction: {
        mode: "safeguard",
        maxHistoryShare: 0.30,
        memoryFlush: {
          enabled: true,
          softThresholdTokens: 10000
        }
      },
      subagents: {
        model: "openai/gpt-4o-mini",
        maxConcurrent: 1
      },
      heartbeat: null,
      timeoutSeconds: 45,
      typingMode: "thinking"
    },
    // agents.list is fully owned by us — always replace
    list: [
      {
        id: "ecarg",
        default: true,
        model: {
          primary: "openai/gpt-4o-mini",
          fallbacks: ["openai/gpt-5.4-mini"]
        }
      },
      {
        id: "ecarg-deep",
        model: {
          primary: "openai/gpt-5.5",
          fallbacks: ["openai/gpt-5.4"]
        }
      }
    ]
  },
  models: {
    mode: "merge",
    providers: {
      openai: {
        baseUrl: "https://api.openai.com/v1",
        apiKey: "OPENAI_API_KEY",
        api: "openai-completions",
        models: [
          {
            id: "gpt-5.4-mini",
            name: "GPT-5.4 Mini",
            contextWindow: 400000,
            reasoning: false,
            input: ["text", "image"]
          },
          {
            id: "gpt-5.5",
            name: "GPT-5.5",
            contextWindow: 1000000,
            reasoning: true,
            input: ["text", "image"]
          },
          {
            id: "gpt-5.4",
            name: "GPT-5.4 (fallback)",
            contextWindow: 1000000,
            reasoning: true,
            input: ["text", "image"]
          },
          {
            id: "gpt-4o-mini",
            name: "GPT-4o Mini (fallback)",
            contextWindow: 128000,
            reasoning: false,
            input: ["text", "image"]
          }
        ]
      }
    }
  }
};

const merged = deepMerge(existing, patch);
merged.agents.list = patch.agents.list;

fs.writeFileSync(configPath, JSON.stringify(merged, null, 2) + "\n", { mode: 0o600 });

console.log("Config patched:");
console.log("  ecarg (default)  → openai/gpt-4o-mini  [chat, fast, cheap]");
console.log("  ecarg-deep       → openai/gpt-5.5      [thinking:medium, deep tasks only]");
console.log(`  workspace       → ${brainDir}`);
EOF

echo "[3/4] Config merged"

# ── print required ~/.profile exports ────────────────────────────────────────

echo ""
echo "[4/4] Add these to ~/.profile on this Pi (if not already set):"
echo ""
echo "  export OPENAI_API_KEY=sk-..."
echo "  export TELEGRAM_BOT_TOKEN=<your-bot-token>"
echo "  export BACKEND_URL=http://192.168.0.35:8000
  export AGENT_API_KEY=a7630cf806fdf23dd20c7fcfbb14ad3c800dd9b4aa7ab26e484cf9930ae66c5b"
echo "  export BRAIN_DIR=/home/bpwonka/apps/moltbot/BRAIN"
echo "  export MOLTBOT_CONFIG_PATH=$CONFIG_PATH"
echo ""
echo "Then reload: source ~/.profile"
echo ""

# ── restart gateway ───────────────────────────────────────────────────────────

echo "Restarting moltbot gateway..."
pkill -9 -f moltbot-gateway 2>/dev/null || true
sleep 1
nohup moltbot gateway run --bind loopback --port 18789 --force \
  > /tmp/moltbot-gateway.log 2>&1 &
sleep 2

if pgrep -f moltbot-gateway > /dev/null; then
  echo "Gateway running. Logs: tail -f /tmp/moltbot-gateway.log"
else
  echo "WARNING: gateway did not start. Check: tail -f /tmp/moltbot-gateway.log"
fi

echo ""
echo "=== Done ==="
echo "Verify: moltbot channels status --probe"
