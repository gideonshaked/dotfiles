---
name: handoff
description: "Snapshot the session into beads memories so the next Codex, Claude Code, or bd-aware agent picks it up automatically via bd prime. Use when the user asks to hand off, wrap up, persist session state, or summarize work for the next agent."
metadata:
  short-description: Persist session handoff state in beads
---

# Handoff

Persists important session state to beads. `bd prime` injects those memories into new sessions, so writing here is enough for the next agent to recover context.

The `handoff-bd` helper next to this `SKILL.md` does the deterministic work: running `bd` commands, validating keys, sanity-checking, and pushing to Dolt. Your job is to draft what should be written, get user approval, then pass the final JSON plan to the helper.

## Where state goes

Do not create per-session handoff keys. `handoff:latest` is the only allowed `handoff:` key.

| State | Destination | Plan field |
|---|---|---|
| Durable insight | `bd remember --key=<topic-slug>` | `memories[]` |
| In-progress work state on an active issue | `bd update <id> --notes` | `notes[]` |
| Session wrap-up summary | `bd remember --key=handoff:latest` | `session_summary` |
| Concrete follow-up work | `bd create --type=task` | `tasks[]` |

## Steps

1. Survey current beads state:

   ```bash
   ./handoff-bd survey
   ```

   If your shell is not running from this skill directory, resolve `handoff-bd` next to this `SKILL.md` first. For a normal dotfiles install, that path is `~/.codex/skills/handoff/handoff-bd`.

   The helper emits JSON with `ready`, `in_progress`, and `handoff_memories`. Print the output directly so the user can see the current queue and any existing `handoff:latest`.

2. Draft the plan silently.

   Match the schema documented in the helper:

   ```json
   {
     "memories": [{"key": "<topic-slug>", "body": "<insight>"}],
     "notes": [{"id": "bd-42", "body": "COMPLETED: ... IN PROGRESS: ... NEXT: ..."}],
     "tasks": [{"title": "...", "description": "...", "type": "task", "priority": 2}],
     "session_summary": "narrative body for handoff:latest"
   }
   ```

   Use kebab-case topic slugs. Keep memories atomic. Only write notes for issues actually touched in this session and currently in progress. Make tasks only for genuine follow-up work.

3. Show the proposal to the user.

   Print the four sections in human-readable form, not raw JSON. Include topic slugs, issue IDs, and task counts. Ask: "Write all of this? Edit anything? Skip a section?"

4. Apply the approved plan.

   Write the final plan JSON to a temp file, then pass it to the helper via stdin:

   ```bash
   ./handoff-bd apply < "$PLAN_FILE"
   ```

   The helper returns summary JSON with `memories`, `notes`, `tasks`, `session_summary_set`, `leaked_keys_cleaned`, `pushed`, and `errors`.

5. Print a concise confirmation.

   Include counts, memory slugs, updated issue IDs, created task IDs, and whether `bd dolt push` succeeded. Mention that the next session will see the handoff via `bd prime`.

## Rules

- Capture findings, not routine actions.
- Use one insight per memory and key by topic, never by date or session.
- Only `handoff:latest` may use the `handoff:` prefix.
- Reference specific files, functions, issue IDs, or commands.
- Do not fabricate content. Leave empty sections empty.
- Do not touch unrelated issues.
- Do not put secrets in beads fields.
- If the user names the next agent, include that in `session_summary`, not as a separate memory.
