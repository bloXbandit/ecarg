---
name: tg-download
description: Download files and attachments from Telegram messages to the Pi filesystem. Use when a user sends a document, photo, audio, video, or any file via Telegram and wants it saved locally, processed, or passed to another tool.
metadata: {"moltbot":{"emoji":"📥","requires":{"bins":["curl"],"env":["TELEGRAM_BOT_TOKEN"]}}}
---

# tg-download — Telegram Attachment Downloader

Saves Telegram attachments to `$BRAIN_DIR/downloads/` using the Telegram Bot API.
The `TELEGRAM_BOT_TOKEN` env var must be set (done by moltbot onboarding).

## How Telegram file downloads work

1. Every file sent to the bot has a `file_id` — visible in message context
2. Call `getFile` to resolve the server-side path
3. Download via `https://api.telegram.org/file/bot<TOKEN>/<file_path>`

## Download a file by file_id

```bash
FILE_ID="<file_id from message>"
DEST_DIR="/home/bpwonka/apps/moltbot/BRAIN/downloads"
TOKEN="$TELEGRAM_BOT_TOKEN"

# Step 1 — resolve file path
FILE_PATH=$(curl -sf "https://api.telegram.org/bot${TOKEN}/getFile?file_id=${FILE_ID}" \
  | grep -o '"file_path":"[^"]*"' | cut -d'"' -f4)

# Step 2 — derive filename
FILENAME=$(basename "$FILE_PATH")

# Step 3 — download
curl -sf "https://api.telegram.org/file/bot${TOKEN}/${FILE_PATH}" \
  -o "${DEST_DIR}/${FILENAME}"

echo "Saved: ${DEST_DIR}/${FILENAME}"
```

## Download with a clean name

```bash
# Rename on save
curl -sf "https://api.telegram.org/file/bot${TOKEN}/${FILE_PATH}" \
  -o "${DEST_DIR}/my-custom-name.pdf"
```

## Where to find file_id in message context

Moltbot injects media context lines when a file is received:
- `file_id: <id>` — use this directly
- `content_type: application/pdf` — tells you what it is
- `placeholder: <media:document>` — signals a saveable file

## Supported file types

| Type | Telegram field | Notes |
|---|---|---|
| Document | `document` | PDFs, ZIPs, any file |
| Photo | `photo` | Uses highest resolution |
| Audio | `audio` | MP3, M4A etc |
| Voice | `voice` | OGG/OPUS from voice messages |
| Video | `video` | MP4 etc |
| Video note | `video_note` | Circular video messages |

Animated stickers (TGS/WEBM) are not downloadable — static WEBP stickers only.

## Size limit

Telegram Bot API allows files up to **20 MB** via `getFile`.
Files larger than 20 MB cannot be fetched this way.

## After downloading

Common next steps:
- Read a PDF: use `nano-pdf` skill
- Transcribe audio: use `openai-whisper` skill
- Move to a project dir: `mv BRAIN/downloads/<file> /home/bpwonka/<project>/`

## Error handling

```bash
# Check if download succeeded
if [ ! -f "${DEST_DIR}/${FILENAME}" ]; then
  echo "ERROR: download failed — check TELEGRAM_BOT_TOKEN and file_id"
  exit 1
fi
```
