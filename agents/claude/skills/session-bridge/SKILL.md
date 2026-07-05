---
name: session-bridge
description: "Use when moving local sessions between Claude Code and Codex, converting Claude Code JSONL into Codex rollout format, converting Codex rollout JSONL into Claude scrollback, or debugging cross-agent resume state."
when_to_use: "Use when the user asks to move, import, export, bridge, fork, resume, or convert sessions between Claude Code and Codex."
argument-hint: "[codex-to-claude|claude-to-codex] [session path] [project cwd]"
allowed-tools:
  - Bash
effort: medium
---

# Session Bridge

Use the shared `agent-session-bridge` script from `~/bin` or this repo's `bin/`.
Do not reimplement transcript conversion in the skill.

## Claude to Codex

1. Find the Claude session if the user did not provide one:

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

3. Verify the result:

   ```bash
   agent-session-bridge inspect --source <new-codex-rollout.jsonl>
   ```

4. Report the new session id and output path.

## Codex to Claude

1. Find the Codex rollout if needed:

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

3. Verify with `agent-session-bridge inspect --source <new-claude-session.jsonl>`.

## Rules

- Keep default redaction on. Use `--no-redact` only if the user explicitly asks
  and understands secrets may be copied.
- Keep internal Codex context out by default. Use `--include-internal` only when
  the user explicitly wants injected system/developer/AGENTS-style text.
- Do not promise perfect tool replay. The bridge preserves visible
  user/assistant text scrollback and target-agent resume metadata.
- If a picker does not show the imported session, provide the explicit path and
  resume command from the bridge output.
