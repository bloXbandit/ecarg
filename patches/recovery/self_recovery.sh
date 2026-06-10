#!/bin/bash
# eCARG Self-Recovery System
# This script helps me recover my memory after system restarts

echo "🧠 eCARG Memory Recovery System"
echo "================================"

# Check if BRAIN directory exists
if [ ! -d "/home/bpwonka/BRAIN" ]; then
    echo "❌ BRAIN directory missing - performing emergency setup"
    mkdir -p /home/bpwonka/BRAIN/{sessions,projects,users,agents,checkpoints,recovery,backups}
    echo "✅ BRAIN structure created"
fi

# Load user profile
echo ""
echo "👤 User Profile:"
if [ -f "/home/bpwonka/BRAIN/users/main_profile.md" ]; then
    grep -E "^\*\*" /home/bpwonka/BRAIN/users/main_profile.md | head -5
else
    echo "⚠️  No user profile found - need to build relationship"
fi

# Show active projects
echo ""
echo "📁 Active Projects:"
if [ -d "/home/bpwonka/BRAIN/projects" ]; then
    ls -1 /home/bpwonka/BRAIN/projects/*.md 2>/dev/null | xargs -I {} basename {} .md | sed 's/^/  - /'
fi

# Check for recent sessions
echo ""
echo "💬 Recent Activity:"
if [ -f "/home/bpwonka/BRAIN/sessions/current_session.md" ]; then
    echo "  Last session: $(stat -c %y /home/bpwonka/BRAIN/sessions/current_session.md | cut -d' ' -f1,2)"
fi

# Show agent status
echo ""
echo "🤖 Helper Agents:"
ls -1 /home/bpwonka/BRAIN/agents/*.md 2>/dev/null | xargs -I {} basename {} .md | sed 's/^/  - /'

echo ""
echo "✅ Recovery complete - ready to assist!"
echo "💡 Run './boot_protocol.sh' for detailed recovery info"