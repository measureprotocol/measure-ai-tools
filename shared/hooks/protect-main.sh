#!/usr/bin/env bash
# protect-main.sh
# PreToolUse hook — blocks accidental git pushes directly to main or master.
#
# Claude Code passes a JSON payload via stdin describing the tool call:
#   { "tool_name": "Bash", "tool_input": { "command": "git push origin main" } }
#
# Exit code 2 with a message to stderr blocks the action.
# Exit code 0 allows it.

INPUT=$(cat)

COMMAND=$(python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_input', {}).get('command', ''))
except Exception:
    print('')
" <<< "$INPUT" 2>/dev/null)

if echo "$COMMAND" | grep -qE "git push.*(origin )?(main|master)(\s|$)"; then
    echo "" >&2
    echo "Blocked: direct push to main/master is not allowed." >&2
    echo "" >&2
    echo "Use /pr to create a pull request to develop instead." >&2
    echo "If this is intentional (e.g. a hotfix release), push manually with:" >&2
    echo "  git push origin main" >&2
    echo "" >&2
    exit 2
fi

exit 0
