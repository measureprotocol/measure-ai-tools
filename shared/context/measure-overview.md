# Measure Protocol — Company and Product Overview

## What we do

Measure Protocol is a data and survey platform that connects brands and researchers (requesters) with a panel of real consumers (contributors) to run surveys and behavioral data collection at scale. We operate a multi-tenant platform with separate surfaces for different user types.

## Core concepts

**Contributors** — consumers who participate in surveys and data collection tasks via the Measure app or web. They earn rewards for their participation.

**Requesters** — brands, research agencies, and data buyers who commission surveys and purchase insights through the platform.

**Surveys / Studies** — the primary unit of work. Requesters create them; contributors complete them. Results flow through our data pipelines.

**Retro system** — our internal name for the job engine in `measure-workshop` that processes data pipelines and analytics jobs.

**Audience Dictionary** — a taxonomy of consumer segments built and maintained via `measure-audience-tools` (Assembly).

**Predict** — an agentic intelligence platform for brands, enabling pathway analysis and behavioral intelligence. Lives in `measure-predict`.

## Key repositories

| Repo | Role | Stack |
|---|---|---|
| `measure-backend` | Public-facing REST API, multi-tenant | Django, PostgreSQL |
| `measure-workshop` | Job engine, data pipelines (Retro) | Django (headless) |
| `measure-sampler` | Survey sampling, partner integrations | Django |
| `measure-requester` | Requester-facing web app | Django |
| `measure-contributor-web` | Contributor web app | Django |
| `measure-ios` | Contributor iOS app | Swift / Xcode |
| `measure-studio` | Internal tools and workflows | Next.js |
| `measure-predict` | Predict intelligence platform | Next.js |
| `measure-portal` | Client data access portal | Next.js + Superset |
| `measure-analytics` | Analytics data pipeline | Dagster |
| `measure-audience-tools` | Audience Dictionary builder (Assembly) | Next.js |
| `measure-commons` | Shared libraries | Python |

## Technology stack

**Backend services** — Python / Django, PostgreSQL, Redis. Environment managed with pyenv. Config via `conf/local.sh`.

**Frontend apps** — Next.js (React), TypeScript, Tailwind CSS.

**Data pipelines** — Dagster for orchestration, BigQuery and Firebolt for analytics storage.

**Infrastructure** — Google Cloud Platform (App Engine, Cloud Storage, BigQuery), some AWS.

**Mobile** — iOS (Swift, Xcode, CocoaPods).

## Local development environment

All services run locally via Docker Compose, orchestrated from the `measure-docker` repository. This is the standard way to develop and test — always prefer Docker over running services directly on the host.

### measure-docker layout

```
measure-docker/
├── docker-compose.yml    # All service definitions (profiles, healthchecks, networking)
├── env.sh                # CLI management tool — primary interface for engineers
├── dockerfiles/          # Per-service Dockerfiles
└── scripts/              # Seed scripts, entrypoints, test data generators
```

### env.sh commands

| Command | What it does |
|---|---|
| `./env.sh up` | Start all backend services (MySQL, Redis, Django apps) |
| `./env.sh up studio requester` | Start specific service profiles only |
| `./env.sh up all` | Start everything (all backends + all frontends) |
| `./env.sh up celery` | Start with Celery workers and beat schedulers |
| `./env.sh down` | Stop all containers |
| `./env.sh build all` | Build/rebuild all Docker images |
| `./env.sh seed` | Run migrations and load fixtures for all services |
| `./env.sh seed <service>` | Seed a specific service only |
| `./env.sh db <service>` | Open a MySQL shell for that service's database |
| `./env.sh manage <service> <cmd>` | Run a Django management command in a container |
| `./env.sh shell <service>` | Open a Django shell in a container |
| `./env.sh logs <service>` | Tail logs for a service |
| `./env.sh reset` | Nuclear option: tear down, rebuild, and reseed everything |

### Service profiles and ports

**Infrastructure** (always running):
- MySQL 8.0 (port 3306), Redis 7 (port 6379), MongoDB 7 (port 27017), Neo4j 4.4 (port 7474)

**Backend services** (Django):
| Service | Port | Profile |
|---|---|---|
| requester | 8000 | requester |
| contributor | 8001 | contributor |
| sampler | 6003 | sampler |
| workshop | 6007 | workshop |
| backend | 6008 | backend |
| taxonomy | 6002 | taxonomy |

**Frontend services** (Next.js / React):
| Service | Port | Profile |
|---|---|---|
| c2 | 3000 | c2 |
| msr-web | 3001 | msr-web |
| studio | 3006 | studio |
| predict | 3009 | predict |
| audience-tools | 4000 | audience-tools |

### Running commands in Docker

```bash
# Run tests for a service
docker compose exec <service> python manage.py test
docker compose exec <service> pytest

# Run a specific management command
docker compose exec <service> python manage.py migrate
docker compose exec <service> python manage.py createsuperuser

# Check logs
docker compose logs -f <service>

# Open a shell inside a container
docker compose exec <service> bash

# For Next.js services
docker compose exec <service> pnpm test
docker compose exec <service> pnpm build
```

### Docker networking

Services communicate using Docker service names as hostnames:
- Database host: `mysql` (not localhost)
- Redis host: `redis`
- Inter-service: `contributor:8001`, `sampler:6003`, `requester:8000`, etc.

Each Django service has a `settings/docker.py` that configures these Docker-internal hostnames.

### Multi-repo workspace structure

Engineers typically work from a single parent directory (e.g. `~/Projects/`) with all repos checked out as siblings. This allows Claude Code to read across repos when working on cross-service changes. The `measure-docker` directory sits alongside the service repos and mounts their source code via Docker volumes.

## Development conventions

- Django migrations should always have descriptive names, not auto-generated ones
- To run Django commands locally (outside Docker): `eval "$(pyenv init -)" && pyenv activate <env> && source conf/local.sh`
- To run Django commands in Docker: `docker compose exec <service> python manage.py <command>` (from `measure-docker/`)
- All documentation files use lowercase-with-dashes naming: `implementation-summary.md` not `IMPLEMENTATION_SUMMARY.md`
- Feature branches use `feature_` prefix; no folder structure in branch names
- Always use Docker for running and testing services locally — it ensures consistent environments and safe sandboxing
