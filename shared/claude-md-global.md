# Measure — Shared Team Context

<!-- This file is included by reference in each team member's ~/.claude/CLAUDE.md.
     It is maintained centrally in measure-ai-tools and updates automatically on git pull.
     Do not copy content from here into your personal file — just keep the @include. -->

@~/measure-ai-tools/shared/context/measure-overview.md

@~/measure-ai-tools/shared/context/clickup-workspace.md

---

## Team conventions

### Git workflow

- `develop` (or `dev`) is always the main development branch
- `main` (or `master`) is the production branch — only merged from develop for releases
- Feature branches use the prefix `feature_`, e.g. `feature_user-auth` or `feature_CU-abc123_user-auth`
- Always branch from `develop`; PRs always target `develop`
- Never push directly to `main` or `master`

### Commit messages

- Use the imperative mood: "Add user auth" not "Added user auth"
- Keep the subject line under 72 characters
- Reference the ClickUp task ID where relevant: `Fix login redirect (CU-abc123)`

### Pull requests

- One feature or fix per PR — keep diffs focused
- Include the ClickUp task URL in the PR body
- PRs require at least one review before merge
- Delete the feature branch after merge

### ClickUp

- Every piece of work should have a ClickUp task
- Update task status as you move through the workflow: In Progress → In Review → Done
- Add a comment when creating a branch and when creating a PR
- Reference the task ID in commit messages and PR descriptions

### Engineering slash commands

Engineers have access to these commands (installed via `setup.sh`):

| Command | When to use |
|---|---|
| `/start [ticket-id] [branch-name]` | Beginning work on a new feature or fix |
| `/pr` | Ready to submit work for review |
| `/review [pr-number]` | Reviewing a teammate's pull request |
| `/merge [pr-number]` | Merging an approved PR |
| `/sync` | Getting develop up to date with main |
