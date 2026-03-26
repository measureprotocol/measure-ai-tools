# measure-ai-tools

Shared AI resources for the Measure team — slash commands, CLAUDE.md templates, context documents, and utilities for Claude Code and other AI tools.

## Repository structure

```
measure-ai-tools/
├── setup.sh                         # Onboarding script — run this first
├── shared/
│   ├── claude-md-global.md          # Template for ~/.claude/CLAUDE.md (personal global config)
│   ├── hooks/
│   │   └── protect-main.sh          # Blocks accidental pushes to main/master
│   └── context/
│       ├── measure-overview.md      # Company and product context for AI tools
│       └── clickup-workspace.md     # ClickUp workspace structure and conventions
├── engineering/
│   ├── claude-md-repo.md            # Template for <repo>/CLAUDE.md in engineering repos
│   └── commands/                    # Slash commands for Claude Code
│       ├── start.md                 # /start — begin a feature branch
│       ├── pr.md                    # /pr — submit work as a pull request
│       ├── review.md                # /review — review a pull request
│       ├── merge.md                 # /merge — merge an approved PR
│       └── sync.md                  # /sync — sync develop from main
├── data-science/
│   ├── claude-md-repo.md
│   └── commands/
├── product/
│   ├── claude-md-repo.md
│   └── commands/
├── operations/
│   ├── claude-md-repo.md
│   └── commands/
├── tools/
│   └── clickup/
│       ├── clickup.py               # ClickUp REST API CLI
│       └── README.md
└── prompts/                         # Reusable prompt templates (all roles)
```

---

## Setup for new users

### 1. Clone this repo

```bash
git clone https://github.com/measureprotocol/measure-ai-tools ~/measure-ai-tools
```

We recommend cloning to `~/measure-ai-tools`. This path is assumed by `@include` references in all CLAUDE.md templates. If you clone elsewhere, update those paths in your personal files.

### 2. Run the setup script

```bash
cd ~/measure-ai-tools
./setup.sh engineering              # single role
./setup.sh engineering product      # multiple roles
```

Available roles: `engineering`, `data-science`, `product`, `operations`

The script will:
- Symlink slash commands for your role(s) into `~/.claude/commands/`
- Install the ClickUp CLI to `~/.local/bin/`
- Configure the protect-main hook in `~/.claude/settings.json`
- Create `~/.claude/CLAUDE.md` if it doesn't already exist
- Prompt for your `CLICKUP_API_TOKEN`

### 3. Fill in your personal CLAUDE.md

After setup, open `~/.claude/CLAUDE.md`. It will look like:

```markdown
@~/measure-ai-tools/shared/claude-md-global.md

## About me
<!-- Fill in: your role, what you're focused on -->

## Projects I work on
<!-- Fill in: which repos you work in regularly -->
```

Fill in the personal sections. The `@include` pulls in shared company context automatically — it updates whenever you `git pull` in this repo. You never need to copy or maintain those shared sections manually.

### 4. Set up CLAUDE.md in each repo you work in

When starting in a repo that doesn't have a `CLAUDE.md`, copy the template and customize it:

```bash
cp ~/measure-ai-tools/engineering/claude-md-repo.md ~/Projects/my-repo/CLAUDE.md
# Edit it: fill in the repo name, architecture, conventions, etc.
```

Commit it to the repo so the whole team benefits.

---

## Multi-role users

If you span multiple teams, pass all your roles to setup:

```bash
./setup.sh engineering data-science product
```

This symlinks commands from all specified roles. For your `~/.claude/CLAUDE.md`, look at the role templates for each team and pull in the sections most relevant to how you work. It's a one-time personal curation, not a mechanical merge.

---

## How updates propagate

When this repo is updated, pull and most things apply automatically:

| What changed | How you get it |
|---|---|
| Slash commands | Auto — symlinked. `git pull` is enough. |
| Hook scripts | Auto — referenced by path in the repo. |
| `@include` sections in CLAUDE.md | Auto — live path references. `git pull` updates them. |
| ClickUp CLI | Manual — re-run `./setup.sh` after significant updates. |
| New template sections | Manual — check the changelog and update your personal files if relevant. |

The only thing that drifts is personal additions in `~/.claude/CLAUDE.md` or `<repo>/CLAUDE.md`. If a template gains a section your copy should reflect, it won't auto-update. We'll flag these in PR descriptions.

---

## Using context docs with other AI tools

The `shared/context/` docs are written for AI consumption and work across tools:

**Claude.ai (web/desktop)** — upload to a shared Measure [Claude Project](https://claude.ai) so they're available to the whole team without pasting.

**ChatGPT** — paste into the conversation, or bake into a Custom GPT system prompt.

**Gemini / other tools** — paste as needed at the start of a conversation.

---

## For contributors

### Adding a slash command

Create a `.md` file in the appropriate role's `commands/` directory:

```markdown
One-line description of what this command does.

Arguments: $ARGUMENTS should be in the format "..."

Steps:
1. ...
2. ...
3. If a ClickUp ticket ID is available in this session: ...

Notes:
- ClickUp integration is always optional — degrade gracefully if no ticket provided
- Include multi-repo guidance if the command could span repos
- Test in at least two different repos before merging
```

Naming convention: commands are named for what the engineer *intends to do*, not the underlying operation. `/start` not `/create-branch`. `/pr` not `/push-and-open-pull-request`.

### Adding a context document

Add `.md` files to `shared/context/` (all roles) or `<role>/context/` (role-specific). Write for an AI reader: dense, factual, structured. Avoid prose. The test: could Claude read this and immediately use the information without asking follow-up questions?

### Updating a CLAUDE.md template

Templates are starting points that users customize. When updating, note in the PR whether existing users should update their personal copies. If yes, add a `## Migration note` section to the PR description.

### Adding a new role

1. Create `<role>/` with `commands/` and `claude-md-repo.md`
2. Update `setup.sh` to recognize the role name
3. Update this README

### Updating the ClickUp CLI

`tools/clickup/clickup.py` is copied (not symlinked) during setup. Users must re-run `./setup.sh` to pick up changes. Note breaking changes clearly in the PR.

---

## How slash commands work in Claude Code

Slash commands are `.md` files that Claude reads when you type `/command-name` in a session. The file becomes instructions Claude executes immediately. Key points:

- **Global commands** live in `~/.claude/commands/` and work in any repo
- **Project commands** live in `<repo>/.claude/commands/` and are committed to git
- `$ARGUMENTS` receives whatever follows the command name: `/start CU-abc123 user-auth` passes `CU-abc123 user-auth` as `$ARGUMENTS`
- Commands can run shell tools, tests, create PRs, and call external APIs — Claude executes the described steps
