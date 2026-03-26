Sync the develop branch with any new changes from main.

Use this periodically to keep develop current with production, and before cutting a release.

Steps:

1. Fetch the latest from origin:
   ```
   git fetch origin
   ```

2. Switch to develop:
   ```
   git checkout develop
   ```

3. Pull the latest develop:
   ```
   git pull origin develop
   ```

4. Merge main (or master) into develop:
   ```
   git merge origin/main
   ```
   If `origin/main` does not exist, try `origin/master`. If neither exists, report this and stop.

5. If there are merge conflicts:
   - Show the conflicting files.
   - Ask the user how they want to resolve them before proceeding.
   - Do not attempt to auto-resolve conflicts.

6. If the merge completed cleanly, push:
   ```
   git push origin develop
   ```

7. Report: how many commits were pulled in (if any), and whether the push succeeded.

Notes:
- If working across multiple repos, repeat these steps for each one.
- This command does not touch ClickUp.
