---
name: create-plugin
description: "Build a Claude Code plugin using best practices."
when_to_use: "Use when the user wants to create, scaffold, or build a Claude Code plugin or asks about plugin structure and best practices."
argument-hint: "[plugin name or description]"
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
effort: high
---

Guides you through creating a Claude Code plugin with proven patterns for skill architecture, state management, context efficiency, and hooks.

## Steps

1. If $ARGUMENTS is provided, use it as the plugin name/description. Otherwise, ask the user what plugin they want to build.

2. Gather requirements:
   - What skills does the plugin need?
   - Does it need Python scripts, MCP servers, hooks, or userConfig?
   - What state needs to persist across sessions?

3. Read the full best practices reference: ${CLAUDE_SKILL_DIR}/best-practices.md

4. Scaffold the plugin directory structure following those patterns. Key points:
   - Use skills/<name>/SKILL.md, not commands/<name>.md
   - Put Python code in bin/ with a shell entrypoint
   - SKILL.md is an orchestrator; deterministic steps belong in scripts
   - Do NOT use fenced code blocks in SKILL.md
   - Use ${CLAUDE_PLUGIN_ROOT} in bin/ scripts, ${CLAUDE_SKILL_DIR} in skill content

5. Build each component, running validation as you go.
