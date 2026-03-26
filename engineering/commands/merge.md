Merge an approved pull request, clean up the branch, and close out the ClickUp task.

Arguments: $ARGUMENTS is a PR number (e.g. `42`).

Steps:

1. View the PR to confirm its state:
   ```
   gh pr view $ARGUMENTS
   ```
   Note the branch name and PR body (used to extract the ClickUp task URL).

2. Confirm the PR is approved and checks have passed. If it is not approved or checks are failing, warn the user and ask them to confirm before proceeding.

3. Merge the PR using a merge commit (preserves history):
   ```
   gh pr merge $ARGUMENTS --merge --delete-branch
   ```
   The `--delete-branch` flag removes the remote branch automatically.

4. Switch to develop and pull:
   ```
   git checkout develop
   git pull origin develop
   ```

5. Delete the local branch if it still exists:
   ```
   git branch -d <branch-name>
   ```
   (Use `-D` only if the branch was not fully merged and the user confirms.)

6. Extract the ClickUp task ID from the PR body if present (look for `app.clickup.com/t/<id>`):
   - Run: `clickup status <ticket-id> "done"`
   - Run: `clickup comment <ticket-id> "Merged to develop via PR #$ARGUMENTS."`
   - If `clickup` fails or no task ID is found, warn but do not fail.

7. Confirm: report that the PR was merged, the branch was deleted, and the ClickUp task was updated.

Notes:
- If working across multiple repos, perform steps 4–5 in each repo.
- Do not use `--squash` or `--rebase` unless the repo's CLAUDE.md specifies otherwise — the default merge commit keeps history intact.
