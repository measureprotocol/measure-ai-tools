Review a pull request: fetch the branch, run tests, and provide a structured code review.

Arguments: $ARGUMENTS is a PR number (e.g. `42`) or a GitHub PR URL.

Steps:

1. Get PR details:
   ```
   gh pr view $ARGUMENTS
   ```
   Note the branch name, author, base branch, and PR description.

2. Check out the branch locally:
   ```
   gh pr checkout $ARGUMENTS
   ```

3. Run tests and report results:
   - Auto-detect the test command (same logic as `/pr`).
   - Run tests and clearly state: pass, fail, or skipped (if no test runner found).

4. Read the full diff:
   ```
   git diff develop...HEAD
   ```

5. Provide a structured review with these sections:

   **Summary** — what does this PR do? Describe the change in your own words based on the diff, not just the PR description.

   **Code quality** — readability, naming, structure, duplication, anything that could be simplified.

   **Correctness** — potential bugs, edge cases, off-by-one errors, unhandled errors, race conditions.

   **Security** — any obvious concerns: SQL injection, unvalidated input, secrets in code, exposed endpoints, permission checks.

   **Tests** — is the change adequately tested? Are there cases not covered?

   **Questions for the author** — anything unclear that needs explanation before approval.

   **Recommendation** — one of:
   - ✅ Approve — looks good, ready to merge
   - 🔄 Request changes — specific items must be addressed
   - 💬 Discuss — needs conversation before a decision

6. Return to the previous branch:
   ```
   git checkout -
   ```

Notes:
- The review is informational — it does not automatically approve or request changes via GitHub. Run `gh pr review $ARGUMENTS --approve` or `--request-changes` separately if you want to record your review on GitHub.
- Be direct and specific. "This function is hard to follow" is less useful than "Lines 42–58 could be extracted into a named helper — the three nested conditions make the intent unclear."
