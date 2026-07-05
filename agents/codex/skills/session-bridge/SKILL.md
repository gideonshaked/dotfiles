---
name: session-bridge
description: "Use when moving local sessions between Codex and Claude Code, converting Codex rollout JSONL into Claude scrollback, converting Claude Code JSONL into Codex rollout format, or debugging cross-agent resume state."
metadata:
  short-description: Convert Codex and Claude sessions
---

# Session Bridge

Use the shared `agent-session-bridge` script from `~/bin` or this repo's `bin/`.
Do not reimplement transcript conversion in the skill.

## Common Workflows

### Codex to Claude

1. Find the Codex rollout if the user did not provide one:

   ```bash
   agent-session-bridge find --agent codex --cwd "$PWD"
   ```

2. Convert it:

   ```bash
   agent-session-bridge codex-to-claude \
     --source <rollout.jsonl> \
     --cwd "$PWD" \
     --model claude-opus-4-8 \
     --update-state \
     --copy-resume-command
   ```

3. Verify the output:

   ```bash
   agent-session-bridge inspect --source <new-claude-session.jsonl>
   ```

4. Tell the user the new session id, output path, and that the Claude resume
   command is on the clipboard.

### Claude to Codex

1. Find the Claude Code session if needed:

   ```bash
   agent-session-bridge find --agent claude --cwd "$PWD"
   ```

2. Convert it:

   ```bash
   agent-session-bridge claude-to-codex \
     --source <claude-session.jsonl> \
     --cwd "$PWD" \
     --model gpt-5.5 \
     --update-state
   ```

3. Verify with `agent-session-bridge inspect --source <new-codex-rollout.jsonl>`.

## Rules

- Keep default redaction on. Use `--no-redact` only if the user explicitly asks
  and understands secrets may be copied.
- Keep internal Codex context out by default. Use `--include-internal` only when
  the user explicitly wants system/developer/AGENTS-style injected text.
- Do not promise perfect tool replay. The bridge preserves visible
  user/assistant text scrollback and target-agent resume metadata.
- If the target agent does not show the session in a picker, give the explicit
  path and resume command from the bridge output.
