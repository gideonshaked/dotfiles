---
name: handoff
description: "Snapshot the session into beads memories so the next agent (Claude Code, Codex, or any bd-aware tool) picks it up automatically via bd prime."
when_to_use: "TRIGGER when: user runs /handoff, says 'wrap up' or 'hand off', mentions handing off to another agent, or asks you to summarize and persist session state."
allowed-tools:
  - Bash
effort: high
---

# Handoff

Persists the session's important state to beads so the next agent reads it automatically. Memories are injected into every new session by `bd prime`, so writing here is sufficient.

The `handoff-bd` script in this skill directory does all the deterministic work: running bd commands, validating keys, sanity-checking, and pushing to Dolt. Your job is to draft what goes into the plan and get user approval; the script applies it.

## Where each kind of state goes

The cardinal rule is to dedupe by meaning, not by session. Per-session keys (e.g. `handoff:2026-05-08`) accumulate forever and the script will reject them.

| State | Destination | Plan field |
|---|---|---|
| Durable insight ("auth uses JWT, not sessions") | `bd remember --key=<topic-slug>` | `memories[]` |
| In-progress work state on the active issue | `bd update <id> --notes` | `notes[]` |
| Session wrap-up summary | `bd remember --key=handoff:latest` (the only allowed `handoff:` key) | `session_summary` |
| Concrete follow-up the next agent should do | `bd create --type=task` | `tasks[]` |

## Steps

### 1. Survey current beads state

Run: ${CLAUDE_SKILL_DIR}/handoff-bd survey

The script emits JSON with three arrays: `ready`, `in_progress`, `handoff_memories`. Read it to know what's already tracked, what's claimed, and whether a prior `handoff:latest` exists.

Print the script's output as a direct text response so the user can see it without expanding the Bash tool result.

### 2. Draft the plan silently

Read back over the conversation and draft a plan JSON matching this shape (see `${CLAUDE_SKILL_DIR}/handoff-bd` docstring for the full schema):

- **memories**: each `{key, body}`. Topic slugs in kebab-case (`zsh-completion-stack`, `bd-version-mismatch`). One sentence per body. Atomic.
- **notes**: each `{id, body}`, only for issues actually touched this session and currently `in_progress`. Body uses the `COMPLETED: / IN PROGRESS: / NEXT:` convention.
- **session_summary**: 3-6 sentence narrative for `handoff:latest`. Mention the topic slugs you wrote so the next agent can grep for them. Skip if the session was trivial.
- **tasks**: only genuine TODOs. If it's not task-shaped, fold it into a topic memory instead.

### 3. Show the proposal to the user

Print the four sections in human-readable form (not raw JSON) so the user can edit by quoting back changes. Show the topic slugs, the issue ID for notes, and the count of memories/tasks. Then ask: "Write all of this? Edit anything? Skip a section?"

### 4. Apply edits, then run the script

Once approved, build the final plan as JSON in a temp file and pass it to the script via stdin:

  ${CLAUDE_SKILL_DIR}/handoff-bd apply < "$PLAN_FILE"

The script returns a summary JSON with: `memories[]` (slugs written), `notes[]` (issue IDs updated), `tasks[]` (id+title for each created), `session_summary_set` (bool), `leaked_keys_cleaned[]` (any per-session keys it had to forget), `pushed` (bool), `errors[]`.

If `errors` is non-empty, the script exited non-zero and `pushed` is false. Tell the user which step failed; do not retry silently.

### 5. Print a summary

Translate the script's summary JSON into a human-readable confirmation: count of memories, slugs, the in-progress issue updated, task IDs created, whether dolt push succeeded. Mention that the next session will see all of this automatically via `bd prime`.

## Rules

- **Capture findings, not actions.** "Ran git status" is noise. "Discovered the prebuilt /usr/local/bin/bd shadows the brew install" is signal.
- **Atomic, topic-keyed memories.** One insight per memory; key by topic slug, never by session/date.
- **`handoff:latest` is the only `handoff:`-prefixed key.** The script enforces this and exits non-zero on per-session keys.
- **Reference specific files, functions, or IDs** in memory bodies and notes. The next agent greps for these.
- **Refuse to fabricate.** If a section has nothing real, leave it empty in the plan. Do not invent work.
- **Do not touch unrelated issues.** Only put issues actually worked on this session into `notes[]`.
- **No secrets** in any beads field. The store syncs to a shared Dolt remote.
- **If the user names the next agent** ("hand off to Codex"), include that fact in the `session_summary` body, not as a separate memory.
