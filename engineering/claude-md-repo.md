# [Repo Name]

<!-- Copy this file to <repo>/CLAUDE.md and fill in each section.
     The @include below pulls in shared company and workflow context automatically.
     Keep your additions below the include line. -->

@~/measure-ai-tools/shared/claude-md-global.md

---

## What this repo does

<!-- One or two sentences: what problem does this service solve? Who uses it? -->

## Architecture

<!-- Key directories and what lives in each:
     src/
       api/       - REST endpoints
       models/    - database models
     ...
     Key external dependencies, databases, queues, external services. -->

## Local development setup

<!-- How to get it running:
     1. pyenv activate <env>
     2. source conf/local.sh
     3. python manage.py runserver
     Any non-obvious setup steps. -->

## Running tests

```bash
# Fill in the test command for this repo
pytest
# or: python manage.py test
# or: npm test
```

<!-- Any test conventions: where fixtures live, how to run a subset, etc. -->

## Database / migrations

<!-- ORM used, how to run migrations, naming conventions.
     For Django: always give migrations descriptive names. -->

## Key environment variables

<!-- Variables an engineer needs to set to work in this repo. -->

## ClickUp

- **Space**: <!-- Engineering / Data Marketplaces / etc. -->
- **Task ID format**: `abc123xyz` (bare alphanumeric, no prefix needed)
- **Status flow**: To Do → In Progress → In Review → Done

## Branch and PR conventions

- Branch from `develop`: `feature_<name>` or `feature_<ticket-id>_<name>`
- PRs target `develop`
- Include the ClickUp task URL in the PR body
- Keep PRs focused — one feature or fix per PR

## Things to know / avoid

<!-- Footguns, known sharp edges, things that have caused incidents.
     E.g.: "Never run migrations in production without a backup."
           "The payments module has a global lock — don't touch it concurrently."  -->
