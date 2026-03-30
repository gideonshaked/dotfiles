# Global CLAUDE.md

## Communication Style

Keep outputs simple and concise. Avoid jargon and unnecessary complexity. When writing docs, lab writeups, or summaries, prefer plain language and shorter explanations unless explicitly asked for detail.

## Quality Checks

When working with JSON schemas (especially problem.json, config.yaml), always validate against the schema before presenting results. Run validation commands proactively rather than waiting for user to report errors.

## Deployment & Infrastructure

For GCP/cloud deployment tasks: always test SSH commands locally first, verify path resolution, check that CLI flags match the actual tool's help output, and ensure scripts are idempotent before deploying to multiple nodes.

## Project Setup

Always use uv over pip for all Python projects. When setting up or modifying projects, ensure full uv integration (pyproject.toml, lock files) not just venv creation.

## API Integration

When working with external APIs (OpenRouter, Harbor, etc.), always verify model names include required prefixes, check that CLI flags match current API versions by reading --help output, and handle API failures gracefully without flooding output.
