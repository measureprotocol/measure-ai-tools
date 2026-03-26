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

## Development conventions

- Django migrations should always have descriptive names, not auto-generated ones
- To run Django commands locally: `eval "$(pyenv init -)" && pyenv activate <env> && source conf/local.sh`
- All documentation files use lowercase-with-dashes naming: `implementation-summary.md` not `IMPLEMENTATION_SUMMARY.md`
- Feature branches use `feature_` prefix; no folder structure in branch names
