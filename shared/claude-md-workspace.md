# Measure Workspace

<!-- This is a template for the CLAUDE.md at your workspace root (e.g. ~/Projects/CLAUDE.md).
     It tells Claude about the multi-repo structure and Docker-based local environment.
     Copy this file to your workspace root and customize the repo table below. -->

@~/measure-ai-tools/shared/claude-md-global.md

---

## Workspace structure

This is a multi-repo workspace. All Measure repositories are checked out as sibling directories under this folder. Each repo may have its own `CLAUDE.md` with repo-specific context — check those first when working in a specific repo.

### How to navigate

- **When I name a system or repo**, match it to the right subdirectory. I may use nicknames or abbreviations.
- **Be lazy about exploration.** Don't preemptively read through repos that aren't involved. Explore only what's needed.
- **For cross-repo changes**, identify the minimal set of files affected rather than reading everything.

### Key repos

<!-- Update this table to reflect your most-used repos. Remove what you don't use. -->

| Repo | What it is | Stack |
|---|---|---|
| `measure-backend` | Public-facing REST API | Django |
| `measure-workshop` | Job engine / data pipelines (Retro) | Django |
| `measure-sampler` | Survey sampling service | Django |
| `measure-requester` | Requester web app | Django |
| `measure-contributor-web` | Contributor web app | Django |
| `measure-studio` | Internal tools and workflows | Next.js |
| `measure-predict` | Predict intelligence platform | Next.js |
| `measure-docker` | Docker Compose orchestration for all services | Docker |
| `measure-ai-tools` | Shared AI tooling (this repo) | Bash / Python |

## Local environment

All services run in Docker via `measure-docker/`. This is the standard way to develop and test.

### Quick reference

```bash
# From the measure-docker/ directory:
./env.sh up                          # Start all backends
./env.sh up studio requester         # Start specific profiles
./env.sh up all                      # Start everything
./env.sh down                        # Stop all containers
./env.sh seed                        # Run all migrations and load fixtures
./env.sh build all                   # Rebuild all images
./env.sh logs <service>              # Tail logs
./env.sh db <service>                # MySQL shell
./env.sh manage <service> <cmd>      # Django management command
./env.sh shell <service>             # Django shell
```

### Running tests and commands

```bash
# Always prefer running inside Docker:
docker compose exec <service> python manage.py test
docker compose exec <service> pytest
docker compose exec <service> pnpm test
docker compose exec <service> pnpm build

# Check logs:
docker compose logs -f <service>
```

### Important notes

- Docker commands must be run from the `measure-docker/` directory (that's where `docker-compose.yml` lives)
- Services communicate via Docker network names: `mysql`, `redis`, `contributor`, `requester`, `sampler`, etc.
- Each Django service has a `settings/docker.py` that configures Docker-internal hostnames
- Frontend services are accessible on localhost at their mapped ports (see measure-overview context for port table)
