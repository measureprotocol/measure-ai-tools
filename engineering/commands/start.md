Start a new feature branch and optionally update the linked ClickUp task.

Arguments: $ARGUMENTS can be:
- Just a branch name: `user-auth`
- A ClickUp task ID followed by a branch name: `abc123 user-auth`

Steps:

1. Parse $ARGUMENTS:
   - If the first word looks like a ClickUp task ID (alphanumeric, no spaces, typically 6-12 chars), treat it as the ticket ID and the remainder as the branch name.
   - Otherwise treat the entire argument as the branch name.
   - The branch name should be lowercase with hyphens (e.g. `user-auth`, not `UserAuth`).

2. Ensure the working tree is clean. If there are uncommitted changes, surface them and ask the user how to proceed before continuing.

3. Switch to develop and pull latest:
   ```
   git checkout develop
   git pull origin develop
   ```

4. Create and switch to the new feature branch:
   - If a ticket ID was provided: `git checkout -b feature_<ticket-id>_<branch-name>`
   - Otherwise: `git checkout -b feature_<branch-name>`

5. If a ClickUp ticket ID was provided:
   - Run: `clickup status <ticket-id> "in progress"`
   - Run: `clickup comment <ticket-id> "Branch <branch-name> created. Starting work."`
   - If the `clickup` command is not found or returns an error, warn the user but do not fail — continue without ClickUp integration.

6. Confirm: report the branch name and what was done. Remind the user to use `/pr` when ready to submit.

Notes:
- ClickUp integration is optional. If no ticket ID is given, just create the branch.
- If working across multiple repos, create the branch in each repo as needed during implementation.
