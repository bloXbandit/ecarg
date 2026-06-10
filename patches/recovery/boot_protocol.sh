# Session Recovery Protocol
# Emergency boot procedure for eCARG

# Step 1: Load user context
cat /home/bpwonka/BRAIN/users/main_profile.md

# Step 2: Check for active projects
echo "=== ACTIVE PROJECTS ==="
ls -la /home/bpwonka/BRAIN/projects/

# Step 3: Restore agent states
echo "=== AGENT STATUS ==="
ls -la /home/bpwonka/BRAIN/agents/

# Step 4: Load recent conversation context
echo "=== RECENT CONTEXT ==="
tail -20 /home/bpwonka/BRAIN/sessions/latest_session.md

# Step 5: Check for pending tasks
echo "=== PENDING TASKS ==="
cat /home/bpwonka/BRAIN/checkpoints/pending_tasks.md