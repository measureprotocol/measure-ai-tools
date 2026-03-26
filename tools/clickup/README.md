# ClickUp CLI

Thin wrapper around the ClickUp REST API v2. Used by engineering slash commands and hooks to update task status, add comments, and manage assignees without going through the MCP server.

## Why a CLI instead of MCP?

The MCP ClickUp integration is great for conversational use ("what's in my queue?"). For automated workflow steps — "move this ticket to In Progress when I start a branch" — a deterministic CLI call is more reliable, faster, and works in hooks and CI.

## Setup

Installed automatically by `setup.sh`. To install manually:

```bash
cp clickup.py ~/.local/bin/clickup
chmod +x ~/.local/bin/clickup
```

Requires `~/.local/bin` on your PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Set your API token (get one at https://app.clickup.com/settings/apps):

```bash
export CLICKUP_API_TOKEN="your_token"
```

## Usage

```bash
clickup get <task-id>                  # Print task details
clickup status <task-id> <status>      # Update status
clickup comment <task-id> <message>    # Add a comment
clickup assign <task-id> <username>    # Assign to a team member
clickup unassign <task-id> <username>  # Remove assignee
```

## Status names

Status names must match exactly what's configured in ClickUp for the task's list. Common values in the Engineering space:

- `to do`
- `in progress`
- `in review`
- `done`

Check your list's settings in ClickUp if a status update fails — the name is case-insensitive but must otherwise match.

## Environment variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `CLICKUP_API_TOKEN` | Yes | — | Personal API token |
| `CLICKUP_WORKSPACE_ID` | No | `24512284` | Override if you have multiple workspaces |

## No external dependencies

`clickup.py` uses only Python stdlib. Python 3.10+ required (uses `dict | None` type hints).
