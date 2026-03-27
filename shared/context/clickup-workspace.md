# ClickUp Workspace

## Workspace

- **Workspace ID**: 24512284
- **URL**: https://app.clickup.com/24512284

## Spaces

| Space | Used by | Purpose |
|---|---|---|
| Engineering | Engineering team | Feature work, bugs, technical tasks |
| Product | Product team | Roadmap, PRDs, feature specs |
| Data Marketplaces | Data / Analytics | Data pipeline work, marketplace integrations |
| Audience Generation | Data / Analytics | Audience Dictionary and panel work |
| Personal | All | Individual task management, scratch space |

## Task status workflow

Standard progression for engineering tasks:

```
To Do → In Progress → In Review → Done
```

- **To Do** — task is defined and ready to be picked up
- **In Progress** — actively being worked on; a branch exists
- **In Review** — PR created, awaiting review and merge
- **Done** — merged to develop (or completed if non-code work)

Some lists may have additional statuses (e.g., Blocked, QA). Check the specific list if a status update fails.

## Task IDs

ClickUp task IDs appear in URLs as alphanumeric strings, e.g.:
`https://app.clickup.com/t/abc123xyz` → task ID is `abc123xyz`

When referencing tasks in branches, commits, or PRs, use the bare ID:
- Branch: `feature_abc123_my-feature`
- Commit: `Add user authentication (abc123)`
- PR body: `https://app.clickup.com/t/abc123`

## Claude tag workflow

Tasks tagged `claude` are queued for Claude to work on autonomously:
- Pick up: search for tasks with the `claude` tag
- After completing: set status to Done, add a summary comment, remove the `claude` tag
- Tasks stay in their original space/list — the tag is just a routing flag

## CLI usage

The `clickup` CLI (installed by `setup.sh`) is available for task management:

```bash
clickup get <task-id>                     # Print task name, status, assignees, URL
clickup status <task-id> "in progress"    # Update task status
clickup comment <task-id> "message"       # Add a comment to a task
clickup assign <task-id> <username>       # Assign task to a workspace member
clickup unassign <task-id> <username>     # Remove assignee from a task
clickup search [options] [text...]        # Search tasks in workspace
```

### Search examples

```bash
clickup search --folder Studio bug        # Find tasks with "bug" in name, in Studio folder
clickup search --status "in progress"      # All in-progress tasks
clickup search --tag claude                # Tasks tagged for Claude
clickup search --assignee john             # Tasks assigned to john
clickup search --folder Studio --closed    # Include done/closed tasks
```

Search filters: `--space`, `--folder`, `--list`, `--status`, `--tag`, `--assignee`, `--closed`. Free text matches against task names. All filters are partial match and case-insensitive.
