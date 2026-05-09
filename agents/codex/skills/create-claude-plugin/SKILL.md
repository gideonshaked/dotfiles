---
name: create-claude-plugin
description: "Build or scaffold a Claude Code plugin using the user's Claude plugin best practices. Use when the user asks Codex to create, update, or reason about Claude Code plugin structure."
metadata:
  short-description: Build Claude Code plugins
---

# Create Claude Plugin

Guide Claude Code plugin creation with the user's established plugin patterns.

## Steps

1. If the user provided a plugin name or description, use it. Otherwise ask what Claude Code plugin they want to build.

2. Gather only the missing requirements:

   - Which skills the plugin needs
   - Whether it needs Python scripts, MCP servers, hooks, or user config
   - What state needs to persist across sessions

3. Read the shared reference `best-practices.md` in this skill directory before designing or editing plugin files.

4. Scaffold or modify the plugin using those patterns:

   - Use `skills/<name>/SKILL.md`, not command files, for user-invoked workflows
   - Put Python code in `bin/` with a shell entrypoint
   - Keep `SKILL.md` as an orchestrator
   - Put deterministic behavior in scripts
   - Use `${CLAUDE_PLUGIN_ROOT}` in plugin scripts and `${CLAUDE_SKILL_DIR}` in Claude skill content

5. Validate as you go with the plugin's own checks or the relevant Claude plugin command.

## Boundaries

- Use Codex's existing `plugin-creator` skill for Codex plugins.
- Use this skill only when the target artifact is a Claude Code plugin.
