# Manual Checkpoint Protocol
# When to run: After significant work, before system changes, when requested

# Quick checkpoint command:
cp /home/bpwonka/BRAIN/sessions/current_session.md /home/bpwonka/BRAIN/checkpoints/manual_$(date +%Y%m%d_%H%M%S).md

# Full checkpoint command:
cd /home/bpwonka/BRAIN && tar -czf backups/brain_backup_$(date +%Y%m%d_%H%M%S).tar.gz *

# Recovery command:
# cd /home/bpwonka/BRAIN && tar -xzf backups/[backup_file].tar.gz