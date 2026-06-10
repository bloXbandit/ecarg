#!/bin/bash
# Memory Checkpoint Script - Runs every 5 minutes
# Saves current session state to prevent data loss

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CHECKPOINT_DIR="/home/bpwonka/BRAIN/checkpoints"

# Create checkpoint
echo "# Checkpoint: $(date)" > $CHECKPOINT_DIR/session_$TIMESTAMP.md
echo "## Current Context" >> $CHECKPOINT_DIR/session_$TIMESTAMP.md
echo "Working directory: $(pwd)" >> $CHECKPOINT_DIR/session_$TIMESTAMP.md
echo "Recent commands: $(history | tail -10)" >> $CHECKPOINT_DIR/session_$TIMESTAMP.md

# Copy current session
cp /home/bpwonka/BRAIN/sessions/current_session.md $CHECKPOINT_DIR/latest_session.md

# Clean up old checkpoints (keep last 24 hours)
find $CHECKPOINT_DIR -name "session_*.md" -mtime +1 -delete

echo "Checkpoint saved: session_$TIMESTAMP.md"