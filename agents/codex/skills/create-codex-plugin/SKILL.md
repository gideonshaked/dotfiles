---
name: create-codex-plugin
description: "Build or scaffold a Codex plugin with a .codex-plugin/plugin.json manifest. Use when the user asks Codex to create, update, or reason about Codex plugin structure."
metadata:
  short-description: Build Codex plugins
---

# Create Codex Plugin

Guide Codex plugin creation using the local Codex plugin format.

## Steps

1. If the user provided a plugin name or description, use it. Otherwise ask what Codex plugin they want to build.

2. Gather only the missing requirements:

   - Which skills the plugin needs
   - Whether it needs hooks, scripts, assets, MCP servers, or app files
   - Whether it should be repo-local or home-local
   - Whether it needs a marketplace entry

3. Use the same structure as Codex's built-in `plugin-creator` skill:

   - The plugin root contains `.codex-plugin/plugin.json`
   - Optional plugin resources live under `skills/`, `hooks/`, `scripts/`, `assets/`, `.mcp.json`, or `.app.json`
   - Repo marketplace entries live at `.agents/plugins/marketplace.json`

4. Prefer running the bundled scaffold script from `agents/codex/skills/.system/plugin-creator/scripts/create_basic_plugin.py` instead of hand-writing the manifest.

5. After scaffolding, open `.codex-plugin/plugin.json` and replace placeholders only when the user has provided the needed details.

6. Validate any JSON or TOML files you create before presenting the result.

## Rules

- Do not use Claude Code plugin layout for Codex plugins.
- Do not create `CLAUDE.md`, Claude `commands/`, or Claude-specific plugin metadata unless the user explicitly asks for a Claude plugin.
- Keep plugin names lower-case hyphen-case.
- Keep generated plugin manifests minimal and valid.
