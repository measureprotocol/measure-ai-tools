#!/usr/bin/env bash
# measure-ai-tools setup
# Usage: ./setup.sh <role> [role2 ...]
# Available roles: engineering, data-science, product, operations

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
LOCAL_BIN="$HOME/.local/bin"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

# --- Output helpers ---

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}→${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn()    { echo -e "${YELLOW}⚠${NC}  $1"; }
error()   { echo -e "${RED}✗${NC} $1"; exit 1; }
header()  { echo -e "\n${BOLD}$1${NC}"; }

# --- Validate arguments ---

VALID_ROLES=("engineering" "data-science" "product" "operations")

if [ $# -eq 0 ]; then
    echo "Usage: ./setup.sh <role> [role2 ...]"
    echo "Available roles: ${VALID_ROLES[*]}"
    exit 1
fi

ROLES=("$@")

for role in "${ROLES[@]}"; do
    valid=false
    for vr in "${VALID_ROLES[@]}"; do
        [ "$role" = "$vr" ] && valid=true && break
    done
    if [ "$valid" = false ]; then
        error "Unknown role: '$role'. Available: ${VALID_ROLES[*]}"
    fi
    if [ ! -d "$REPO_DIR/$role" ]; then
        error "Role directory not found: $REPO_DIR/$role"
    fi
done

echo ""
echo -e "${BOLD}measure-ai-tools setup${NC}"
echo "Roles: ${ROLES[*]}"
echo "Repo:  $REPO_DIR"

# --- 1. Slash commands ---

header "1. Slash commands"

mkdir -p "$COMMANDS_DIR"

link_commands_from() {
    local dir="$1"
    local label="$2"
    if [ ! -d "$dir" ]; then return; fi

    shopt -s nullglob
    for cmd_file in "$dir"/*.md; do
        cmd_name=$(basename "$cmd_file" .md)
        target="$COMMANDS_DIR/$cmd_name.md"

        if [ -L "$target" ]; then
            rm "$target"
        elif [ -f "$target" ]; then
            warn "Skipping /$cmd_name — file exists at $target and is not a symlink. Remove it to use the shared version."
            continue
        fi

        ln -s "$cmd_file" "$target"
        success "  Linked /$cmd_name  ($label)"
    done
    shopt -u nullglob
}

# Link shared commands
link_commands_from "$REPO_DIR/shared/commands" "shared"

# Link role-specific commands
for role in "${ROLES[@]}"; do
    link_commands_from "$REPO_DIR/$role/commands" "$role"
done

# --- 2. ClickUp CLI ---

header "2. ClickUp CLI"

mkdir -p "$LOCAL_BIN"
ln -sf "$REPO_DIR/tools/clickup/clickup.py" "$LOCAL_BIN/clickup"
chmod +x "$LOCAL_BIN/clickup"
success "ClickUp CLI symlinked to $LOCAL_BIN/clickup"

if ! echo "$PATH" | grep -q "$LOCAL_BIN"; then
    warn "$LOCAL_BIN is not in your PATH."
    warn "Add to your ~/.zshrc or ~/.bashrc:  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# --- 3. Hooks ---

header "3. Hooks"

mkdir -p "$CLAUDE_DIR"

# Ensure settings.json exists
if [ ! -f "$SETTINGS_FILE" ]; then
    echo '{}' > "$SETTINGS_FILE"
fi

# Add protect-main hook via Python (handles JSON merging safely)
python3 - <<PYEOF
import json, os, sys

settings_file = "$SETTINGS_FILE"
repo_dir = "$REPO_DIR"
hook_script = os.path.join(repo_dir, "shared", "hooks", "protect-main.sh")

with open(settings_file) as f:
    try:
        settings = json.load(f)
    except json.JSONDecodeError:
        settings = {}

hooks = settings.setdefault("hooks", {})
pre_hooks = hooks.setdefault("PreToolUse", [])

# Check if already configured
already_added = any(
    any(h.get("command", "").endswith("protect-main.sh")
        for h in entry.get("hooks", []))
    for entry in pre_hooks
)

if not already_added:
    pre_hooks.append({
        "matcher": "Bash",
        "hooks": [{"type": "command", "command": hook_script}]
    })
    with open(settings_file, "w") as f:
        json.dump(settings, f, indent=2)
    print("  Hooks configured.")
else:
    print("  Hooks already configured, skipping.")
PYEOF

success "Hooks configured in $SETTINGS_FILE"

# --- 4. Permissions ---

header "4. Permissions"

# Merge role-specific permissions into global and workspace settings.
# Each role can provide a permissions.json with "global" and "workspace" sections.

merge_permissions() {
    python3 - "$@" <<'PYEOF'
import json, sys, os

settings_file = sys.argv[1]
permissions_file = sys.argv[2]
section = sys.argv[3]  # "global" or "workspace"

# Read the permissions template
with open(permissions_file) as f:
    template = json.load(f)

if section not in template:
    sys.exit(0)

new_allows = template[section].get("permissions", {}).get("allow", [])
if not new_allows:
    sys.exit(0)

# Read or create the target settings file
if os.path.exists(settings_file):
    with open(settings_file) as f:
        try:
            settings = json.load(f)
        except json.JSONDecodeError:
            settings = {}
else:
    settings = {}

# Merge permissions — add new entries, don't duplicate
perms = settings.setdefault("permissions", {})
existing = set(perms.get("allow", []))
merged = list(perms.get("allow", []))

added = 0
for entry in new_allows:
    if entry not in existing:
        merged.append(entry)
        existing.add(entry)
        added += 1

perms["allow"] = merged

with open(settings_file, "w") as f:
    json.dump(settings, f, indent=2)

print(f"  {added} new permissions added ({len(merged)} total)")
PYEOF
}

# Merge global permissions into ~/.claude/settings.json
for role in "${ROLES[@]}"; do
    perm_file="$REPO_DIR/$role/permissions.json"
    if [ -f "$perm_file" ]; then
        info "Merging $role global permissions into $SETTINGS_FILE"
        merge_permissions "$SETTINGS_FILE" "$perm_file" "global"
        success "  Global permissions updated ($role)"
    fi
done

# --- 5. Workspace setup ---

header "5. Workspace setup"

echo "  Claude Code works best when launched from a workspace root directory"
echo "  that contains all your Measure repos as sibling directories."
echo ""
echo "  This step installs:"
echo "    - <workspace>/.claude/settings.local.json  (pre-approved permissions)"
echo "    - <workspace>/CLAUDE.md  (workspace context for Claude)"
echo ""

# Detect workspace directory (parent of this repo)
DEFAULT_WORKSPACE="$(cd "$REPO_DIR/.." && pwd)"

read -r -p "  Workspace directory [$DEFAULT_WORKSPACE]: " WORKSPACE_DIR
WORKSPACE_DIR="${WORKSPACE_DIR:-$DEFAULT_WORKSPACE}"

# Expand ~ if present
WORKSPACE_DIR="${WORKSPACE_DIR/#\~/$HOME}"

if [ -z "$WORKSPACE_DIR" ]; then
    warn "Skipped workspace setup. You can re-run setup.sh later to configure it."
elif [ ! -d "$WORKSPACE_DIR" ]; then
    warn "Directory not found: $WORKSPACE_DIR — skipping workspace setup."
else
    # Install workspace permissions
    WORKSPACE_CLAUDE_DIR="$WORKSPACE_DIR/.claude"
    WORKSPACE_SETTINGS="$WORKSPACE_CLAUDE_DIR/settings.local.json"
    mkdir -p "$WORKSPACE_CLAUDE_DIR"

    for role in "${ROLES[@]}"; do
        perm_file="$REPO_DIR/$role/permissions.json"
        if [ -f "$perm_file" ]; then
            info "Merging $role workspace permissions into $WORKSPACE_SETTINGS"
            merge_permissions "$WORKSPACE_SETTINGS" "$perm_file" "workspace"
            success "  Workspace permissions updated ($role)"
        fi
    done

    # Install workspace CLAUDE.md
    WORKSPACE_CLAUDE_MD="$WORKSPACE_DIR/CLAUDE.md"
    WORKSPACE_TEMPLATE="$REPO_DIR/shared/claude-md-workspace.md"

    if [ ! -f "$WORKSPACE_CLAUDE_MD" ]; then
        if [ -f "$WORKSPACE_TEMPLATE" ]; then
            sed "s|~/measure-ai-tools|$REPO_DIR|g" "$WORKSPACE_TEMPLATE" > "$WORKSPACE_CLAUDE_MD"
            success "Created $WORKSPACE_CLAUDE_MD from template"
            warn "Open it and customize the repo table for your setup."
        fi
    else
        info "$WORKSPACE_CLAUDE_MD already exists — not overwriting"
        if ! grep -q "measure-ai-tools/shared/claude-md-global" "$WORKSPACE_CLAUDE_MD"; then
            warn "Your workspace CLAUDE.md doesn't include shared context. Consider adding:"
            warn "  @$REPO_DIR/shared/claude-md-global.md"
        fi
    fi

    success "Workspace configured at $WORKSPACE_DIR"
fi

# --- 6. ClickUp API token ---

header "6. ClickUp API token"

if [ -n "${CLICKUP_API_TOKEN:-}" ]; then
    success "CLICKUP_API_TOKEN already set"
else
    echo "  You need a ClickUp personal API token for ClickUp integration."
    echo "  Get one at: https://app.clickup.com/settings/apps"
    echo ""
    read -r -p "  Enter your ClickUp API token (or press Enter to skip): " TOKEN
    echo ""

    if [ -n "$TOKEN" ]; then
        # Detect shell rc file
        SHELL_RC="$HOME/.zshrc"
        [ -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.bashrc"

        {
            echo ""
            echo "# ClickUp API token (added by measure-ai-tools setup)"
            echo "export CLICKUP_API_TOKEN=\"$TOKEN\""
        } >> "$SHELL_RC"
        export CLICKUP_API_TOKEN="$TOKEN"
        success "CLICKUP_API_TOKEN saved to $SHELL_RC"
    else
        warn "Skipped. Set it later with: export CLICKUP_API_TOKEN='your_token'"
    fi
fi

# --- 7. Personal CLAUDE.md ---

header "7. Personal CLAUDE.md"

GLOBAL_CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"

if [ ! -f "$GLOBAL_CLAUDE_MD" ]; then
    cat > "$GLOBAL_CLAUDE_MD" <<TEMPLATE
@$REPO_DIR/shared/claude-md-global.md

## About me

<!-- Your name, role, team -->

## My current focus

<!-- What you're working on right now, primary responsibilities -->

## Projects I work in regularly

<!-- Which repos, what parts of the system you own or touch most -->

## My preferences

<!-- How you like to work with Claude: level of explanation, things to avoid, communication style -->
TEMPLATE
    success "Created $GLOBAL_CLAUDE_MD"
    warn "Open it and fill in the personal sections before your next Claude Code session."
else
    info "~/.claude/CLAUDE.md already exists — not overwriting"
    # Check if it includes our shared context
    if ! grep -q "measure-ai-tools/shared/claude-md-global" "$GLOBAL_CLAUDE_MD"; then
        warn "Your CLAUDE.md doesn't include shared context. Consider adding:"
        warn "  @$REPO_DIR/shared/claude-md-global.md"
    fi
fi

# --- Done ---

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
success "Setup complete for: ${ROLES[*]}"
echo ""
echo "What was configured:"
echo "  - Slash commands symlinked to ~/.claude/commands/"
echo "  - ClickUp CLI installed to ~/.local/bin/clickup"
echo "  - Protect-main hook in ~/.claude/settings.json"
echo "  - Permissions merged into ~/.claude/settings.json"
if [ -n "${WORKSPACE_DIR:-}" ] && [ -d "${WORKSPACE_DIR:-}" ]; then
echo "  - Workspace permissions at $WORKSPACE_DIR/.claude/settings.local.json"
echo "  - Workspace CLAUDE.md at $WORKSPACE_DIR/CLAUDE.md"
fi
echo ""
echo "Available commands:"
shopt -s nullglob
for role in "${ROLES[@]}"; do
    for cmd_file in "$REPO_DIR/$role/commands"/*.md; do
        echo "  /$(basename "$cmd_file" .md)"
    done
done
shopt -u nullglob
echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or: source ~/.zshrc) to reload PATH"
echo "  2. Edit ~/.claude/CLAUDE.md and fill in your personal sections"
if [ -n "${WORKSPACE_DIR:-}" ] && [ -d "${WORKSPACE_DIR:-}" ]; then
echo "  3. Review $WORKSPACE_DIR/CLAUDE.md and customize the repo table"
echo "  4. Copy a repo template when starting in a new codebase:"
else
echo "  3. Copy a repo template when starting in a new codebase:"
fi
for role in "${ROLES[@]}"; do
    echo "       cp $REPO_DIR/$role/claude-md-repo.md <repo>/CLAUDE.md"
done
echo ""
echo "Docs: $REPO_DIR/README.md"
echo ""
