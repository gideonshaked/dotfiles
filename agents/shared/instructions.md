# Global Agent Instructions

## Documentation Lookups

When a question involves a library, framework, SDK, API, CLI tool, or cloud service, query context7 (`mcp__plugin_context7_context7__resolve-library-id` then `query-docs`) before answering, even when local evidence already suggests an answer. Local files tell you what's broken; docs tell you whether the proposed fix is the right one. Skip only for pure refactors, business-logic debugging, or general programming concepts.

## Communication Style

Keep outputs simple and concise. Avoid jargon and unnecessary complexity. When writing docs, lab writeups, or summaries, prefer plain language and shorter explanations unless explicitly asked for detail.

## Quality Checks

When working with JSON schemas (especially problem.json, config.yaml), always validate against the schema before presenting results. Run validation commands proactively rather than waiting for user to report errors.

## Deployment & Infrastructure

For GCP/cloud deployment tasks: always test SSH commands locally first, verify path resolution, check that CLI flags match the actual tool's help output, and ensure scripts are idempotent before deploying to multiple nodes.

## Project Setup

Always use uv over pip for all Python projects. When setting up or modifying projects, ensure full uv integration (pyproject.toml, lock files) not just venv creation.

## Dependencies

Adding a dependency is always fine when we are actually using it. Do not frame "we have to add a dependency" as a downside, risk, or tradeoff in design discussions, plan comparisons, or code review. The only relevant question is whether the dependency solves the problem; if it does, add it and move on. Do not propose hand-rolled reimplementations of library functionality just to avoid the dep.

## Git

Use `master` over `main` as the default branch name when creating new repos or branches.

## JSON Schemas

When defining JSON schemas in documentation, always provide both: (1) a data-agnostic schema template showing all fields with type annotations (e.g. `"<string>"`, `"<number>"`, `"<any>"`), and (2) a full concrete example with realistic data. The schema template is the reference; the example demonstrates usage.

## Shell and JSON

Never pass JSON with dynamic or multi-line string values via `echo` in shell commands. Newlines, quotes, and special characters will break the command. Instead, write JSON to a temp file (e.g. with `python3 -c "import json; json.dump(...)"`) and pass the file path as an argument or redirect it to stdin.

## API Integration

When working with external APIs (OpenRouter, Harbor, etc.), always verify model names include required prefixes, check that CLI flags match current API versions by reading --help output, and handle API failures gracefully without flooding output.

## Style Preferences

- Do NOT use em-dashes (—) or stylistic colons in prose, docs, or commit messages; they fail lint and are disliked
- Keep taglines and copywriting natural; avoid stiff/marketing-style phrasing in READMEs and copy
- When posting GitHub review comments, consolidate findings before posting (avoid noisy multi-comment posts)
- When writing R/Rmd assignments, match the lecture's exact methods (e.g., difference-in-means for permutation tests, not F-statistic) and avoid adding unrequested plots/tests/formatting

## Verification Before Claims

- Before posting review findings or making claims about code behavior, trace the actual code path to verify
- Do not make broad claims (e.g., 'X can silently fail') without checking the specific conditions
- When fixing a failing test, make fixes version/context-agnostic rather than hardcoding the current value

## Workflow Preferences

- Ask before making code edits when the user says 'yeah' or similar; they may want a PR comment/suggestion rather than a direct change
- When suggesting a command the user should run in their terminal, do NOT print the command for them to copy/paste. Instead pipe it into `pbcopy` via Bash so it lands on the clipboard directly. Then tell them it's on the clipboard and what it does. Example: `printf '%s' 'gcloud auth login' | pbcopy`. Exception: if they explicitly ask to see the command.

## Version Bumps & Releases

- Always create a git tag after a version bump; do not forget
- Check for tag conflicts before pushing tags
- Push both the branch AND the tag
- When fixing version-related tests, make them version-agnostic (read from package metadata, e.g., `importlib.metadata`) rather than hardcoding the new value

## Design & Implementation Discipline

- Do NOT add backward compatibility unless explicitly requested
- Prefer minimal, single-mode designs over multi-mode/aggregation-flag designs; ask before adding optionality
- Default to MINIMAL scope: before writing any design doc or implementation, list what was asked for and what you plan to add beyond that, and confirm before proceeding
- Prefer manual curation over scripted batch transforms when working with vocabularies or authoritative datasets
- Launch long-running agents/jobs in the background by default

## Code Hygiene

- Never keep dead code as scaffolding "in case we need it later." If a class, function, module, or test is unused today, delete it. Git history is the retrieval mechanism, not the source tree.

## Prompt Files

- Keep prompts separate from code. Store prompts in dedicated prompt/template files, ideally under their own prompts/templates directory, and load them from code rather than embedding long prompt strings inline.
- Prefer template files such as Jinja2 templates when prompts need variables or structured rendering.
