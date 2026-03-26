# [System / Infrastructure Area]

<!-- Copy this file to the relevant project or use it as context in Claude.ai.
     Fill in each section. -->

@~/measure-ai-tools/shared/claude-md-global.md

---

## What this covers

<!-- What infrastructure, deployment pipeline, or operational area does this document address? -->

## System overview

<!-- What is this system responsible for?
     How does it fit into the broader Measure infrastructure? -->

## Infrastructure

<!-- Key components:
     - Cloud provider(s): GCP, AWS
     - Services used: App Engine, Cloud Run, GCS, BigQuery, RDS, etc.
     - Networking: VPCs, load balancers, DNS
     - Any relevant configuration: regions, project IDs, account IDs -->

## Environments

| Environment | Purpose | Notes |
|---|---|---|
| local | Development | |
| staging | Pre-production testing | |
| production | Live | |

<!-- How are environment-specific configs managed? .env files, Secret Manager, etc. -->

## Deployment process

```bash
# Fill in how to deploy this system
# e.g.:
gcloud app deploy
# or:
./deploy.sh production
```

<!-- What triggers a deployment? Is it automated via CI/CD or manual? -->

## Monitoring and alerts

<!-- Where do logs live? What monitoring is in place?
     What does on-call need to know? -->

## Access and credentials

<!-- How does someone get access to this system?
     Where are credentials stored? (Reference only — don't put actual secrets here.) -->

## Runbooks

<!-- Link to runbooks for common operational tasks or incidents. -->

## ClickUp

- **Space**: Engineering
- **Status flow**: To Do → In Progress → In Review → Done

## Things to know / avoid

<!-- Gotchas, known fragile areas, things that have caused incidents.
     e.g.: "The nightly job locks the jobs table — never run migrations during the 2–4am window." -->
