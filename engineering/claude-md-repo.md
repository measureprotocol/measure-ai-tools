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

## Docker setup

<!-- Fill in the Docker profile name and port for this service.
     All services run via Docker Compose from the measure-docker repo. -->

- **Docker profile**: <!-- e.g. requester, studio, sampler -->
- **Container port**: <!-- e.g. 8000, 3006 -->
- **Docker settings**: <!-- e.g. requester/settings/docker.py (for Django repos) -->

```bash
# Start this service (from measure-docker/):
./env.sh up <profile>

# Start with related services:
./env.sh up <profile> <other-profile>

# Rebuild after dependency changes:
./env.sh build <profile>
```

## Running tests

```bash
# Via Docker (preferred — matches CI environment):
docker compose exec <service> python manage.py test
# or: docker compose exec <service> pytest
# or: docker compose exec <service> pnpm test

# Directly on host (if needed):
# pytest
# python manage.py test
# pnpm test
```

<!-- Any test conventions: where fixtures live, how to run a subset, etc. -->

## Database / migrations

<!-- ORM used, database name(s), how to run migrations.
     For Django: always give migrations descriptive names. -->

```bash
# Run migrations via Docker:
docker compose exec <service> python manage.py migrate

# Open a database shell:
./env.sh db <service>

# Create a new migration:
docker compose exec <service> python manage.py makemigrations <app> --name <descriptive_name>
```

## Logs and debugging

```bash
# Tail logs for this service:
docker compose logs -f <service>

# Open a shell inside the container:
docker compose exec <service> bash

# Open a Django shell:
./env.sh shell <service>
# or: docker compose exec <service> python manage.py shell
```

## Key environment variables

<!-- Variables an engineer needs to set to work in this repo.
     Docker-specific env is configured in measure-docker/.env and docker-compose.yml.
     Only list variables that engineers may need to override or be aware of. -->

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
