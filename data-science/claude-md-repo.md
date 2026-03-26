# [Repo / Project Name]

<!-- Copy this file to <repo>/CLAUDE.md and fill in each section. -->

@~/measure-ai-tools/shared/claude-md-global.md

---

## What this project does

<!-- What analytical or data problem does this solve? What are the outputs? Who consumes them? -->

## Data sources

<!-- Where does input data come from?
     BigQuery datasets, Firebolt tables, GCS buckets, external APIs, etc.
     Include dataset/table names if they're specific to this project. -->

## Outputs

<!-- What does this produce? Tables, files, reports, model artifacts?
     Where do they go and who uses them? -->

## Architecture

<!-- Key directories:
     pipelines/   - Dagster pipeline definitions
     queries/     - SQL or query builder files
     notebooks/   - exploratory notebooks
     models/      - ML model code if applicable
     ...
     How data flows through the system. -->

## Environment setup

```bash
# Fill in the setup steps for this project
# e.g.:
pyenv activate analytics
pip install -r requirements.txt
source conf/local.sh
```

## Running locally

```bash
# Fill in how to run pipelines, queries, or notebooks locally
# e.g. for Dagster:
dagster dev
```

## Running on schedule / in production

<!-- How are jobs triggered in production? Dagster Cloud, cron, manual? -->

## Key libraries and tools

<!-- Dagster, Pandas, BigQuery client, dbt, etc. — anything non-obvious. -->

## Testing

```bash
# Fill in test command
pytest
```

<!-- What should be tested: query correctness, schema validation, pipeline behavior? -->

## ClickUp

- **Space**: <!-- Data Marketplaces / Audience Generation / etc. -->
- **Status flow**: To Do → In Progress → In Review → Done

## Things to know / avoid

<!-- Known data quality issues, slow queries, rate limits, anything that has caused problems. -->
