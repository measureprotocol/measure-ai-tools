Submit the current branch as a pull request to develop.

Steps:

1. Check current branch. If on `develop`, `main`, or `master`, stop and tell the user to run this from a feature branch.

2. Check for uncommitted changes with `git status` and `git diff --stat`:
   - If there are staged or unstaged changes, ask the user for a commit message and commit them: `git add -A && git commit -m "<message>"`
   - If the working tree is clean, skip this step.

3. Run tests to catch any obvious failures before submitting:
   - Auto-detect the test command by looking for: `pytest.ini`, `pyproject.toml` (pytest section), `manage.py`, `package.json` (test script), `Makefile` (test target).
   - Run the tests and report results.
   - If tests fail, show the failures and ask the user: "Tests are failing — do you want to proceed with the PR anyway, or fix them first?" Do not block automatically.

4. Push the branch:
   ```
   git push -u origin <current-branch>
   ```

5. Build the PR body:
   - Summarize the changes made on this branch (from the diff and commit messages).
   - If a ClickUp ticket ID is known from this session (set by `/start`), include a line: `ClickUp: https://app.clickup.com/t/<ticket-id>`
   - If no ticket ID is known, include a placeholder: `ClickUp: <!-- add task URL -->`

6. Create the PR:
   ```
   gh pr create --base develop --title "<readable title>" --body "<body>"
   ```

7. If a ClickUp ticket ID is known:
   - Run: `clickup status <ticket-id> "in review"`
   - Run: `clickup comment <ticket-id> "PR created: <pr-url>"`
   - If `clickup` fails, warn but do not fail the overall command.

8. Report the PR URL. Remind the user that a reviewer needs to approve before merging with `/merge`.

Notes:
- ClickUp integration is optional — if no ticket ID is available, create the PR without it.
- If working across multiple repos with changes on the same feature branch, repeat these steps for each repo.
