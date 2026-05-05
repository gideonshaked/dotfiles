---
name: codex-second-opinion
description: "Get Codex to audit Claude's mistakes."
when_to_use: "Use when the user asks for a second opinion, a Codex audit, an independent review, or wants to check Claude's work."
argument-hint: "[focus area or file path]"
allowed-tools:
  - Bash
effort: high
---

Invokes Codex in read-only sandbox mode to hunt for bugs, dead code, tech debt, and architectural errors that Claude left behind.

## Steps

1. Run: ${CLAUDE_SKILL_DIR}/codex-audit $ARGUMENTS

   The script detects the project language, builds an audit prompt, and runs codex exec in read-only mode. If the argument is a file/directory path it scopes the audit there; if it is a topic (e.g. "error handling") it focuses on that category; if empty it does a broad sweep.

2. Print the full output as a direct text response so the user can read it without expanding tool results.

3. Do not add your own commentary or soften the results. Let the audit stand on its own.
