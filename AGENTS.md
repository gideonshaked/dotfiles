# AGENTS.md

This file provides guidance to coding agents (Claude Code, etc.) when working with code in this repository.

## Overview

Personal dotfiles repository using [Dotbot](https://github.com/anishathalye/dotbot) for installation and symlink management. Configuration files are organized by tool/purpose and symlinked to their expected locations.

Claude Code is the only supported agent. Codex support was removed.

## Commands

**Install/update dotfiles:**
```bash
./install            # Full install (macOS)
./install --minimal  # Minimal install (remote servers)
```

The installer only needs `git` and `python3` to create symlinks. The post-link agent steps additionally use `npx`, `jq`, `uv`, and `claude`; each step is failure-tolerant and skips (printing a `non-fatal` message) when its tool is missing.

**Manage dotfiles:**
```bash
dotfiles update              # Pull latest changes and run install
dotfiles update --minimal    # Same, but minimal install
dotfiles brewfile            # Update Homebrew package manifest
dotfiles dotbot              # Update Dotbot submodule
```

**Inspect agent usage:**
```bash
agent-usage                  # Skill invocations and MCP tool calls across all transcripts
agent-usage --since 2026-08-01
```

Every pruning decision in this repo rests on that measurement. Use it before adding or removing a skill, plugin, or MCP server, and again afterwards to check the change did what you expected.

**Run tests:**
```bash
uv run pytest tests/ -q
```

## Architecture

The install script initializes the Dotbot submodule and runs Dotbot with `install.conf.yaml`. The `--minimal` flag sets `DOTFILES_INSTALL_MODE=minimal`, and the same YAML file conditionally skips the full macOS links. Links are gated per-mode with `scripts/is-full-install` / `scripts/is-minimal-install` (both read `DOTFILES_INSTALL_MODE`).

### Shell configuration

zsh and bash are equal first-class citizens. Neither borrows from the other.

| File | Role |
|------|------|
| `term/common.sh` | POSIX configuration shared by both shells: environment, PATH, aliases, ssh-agent, secrets. Must stay POSIX-compatible: no arrays, no `[[ ]]`, no zsh globs, no bashisms. |
| `term/zshrc` | Sources `common.sh`, then zsh-only concerns: options, completion, fzf-tab, autosuggestions, syntax-highlighting. |
| `term/bashrc` | Sources `common.sh`, then bash-only concerns: shopt, bash completion, prompt fallback. |
| `term/bash_prompt.bash` | Pure-bash prompt, used only when starship is absent. |
| `term/zshenv` | Loaded before `/etc/zshrc`. Disables Apple Terminal session restore; sources `~/.cargo/env` because rustup writes that file directly. |

Both shells get starship, atuin, and fzf key bindings. fzf-tab, autosuggestions, and syntax-highlighting are zsh-only because no bash equivalent is wired up.

Secrets live at `~/.shell-secrets`, **outside the repository**, so they cannot be committed by accident. `common.sh` sources it if present.

### Agent provisioning

`bin/dotfiles-npx` is a wrapper that activates nvm-managed npx on demand; agent scripts call it rather than a system `npx`.

`install-claude-plugins` reads `extraKnownMarketplaces` and `enabledPlugins` from the linked `~/.claude/settings.json` (via `jq`) and adds/installs each marketplace and plugin.

`install-agent-mcps` registers `exa` (HTTP) and `gcloud` (via `dotfiles-npx`) with `claude mcp`, and prunes the retired AWS servers. Context7 setup is opt-in (`DOTFILES_INSTALL_CONTEXT7=1` or `CONTEXT7_API_KEY`); when run it writes the key to `~/.shell-secrets`.

**Tool budget is a scarce shared resource.** Claude Code defers every MCP tool behind `ToolSearch` once tool definitions exceed 10% of the context window, which hides low-tool-count servers like exa behind higher-count ones. Adding an MCP server means checking afterwards whether deferral has kicked in.

### Claude settings: personal and work profiles

`agents/claude/settings.personal.json` and `agents/claude/settings.work.json` are two complete files, one of which is symlinked to `~/.claude/settings.json`.

They are separate files rather than a base plus an overlay because Claude Code has no include or extend mechanism, and because a generated settings file would be clobbered by `/config`, which writes to `~/.claude/settings.json` directly. Symlinking keeps `/config` edits landing in the repo where git tracks them.

A plugin enabled in `~/.claude/settings.json` cannot be disabled per-project ([claude-code#34415](https://github.com/anthropics/claude-code/issues/34415), closed as duplicate, no workaround), so work plugins must be absent from the personal profile rather than merely overridden.

`tests/test_settings_split.py` asserts the two files differ **only** in `enabledPlugins`, `extraKnownMarketplaces`, and `pluginConfigs`. Add a shared setting to one file and not the other and the test fails. Do not weaken the allowlist to make a test pass.

### Minimal install

For remote servers. Installs: SSH config, Claude agent config, ccstatusline, user-local npx via nvm, git aliases, and the shared shell config plus `term/bashrc`. Appends a source line to both `.bashrc` and `.bash_profile` for login shell compatibility (e.g. tcsh exec-to-bash). The install owns `~/bin`; an existing `~/bin` is backed up before the repo bin is linked. Guarded against double-sourcing.

### SSH wrapper (`bin/s`)

The `s` script is an SSH wrapper that uses the Kitty SSH kitten when available, falling back to plain ssh. Dotfiles management on remotes is opt-in via flags: `--install-dotfiles`, `--reinstall-dotfiles`, `--update-dotfiles`. Default is just SSH with no dotfiles action.

### Key symlink mappings

| Source in repo | Target location | Install mode |
|----------------|-----------------|--------------|
| `term/common.sh` | `~/.shell-common` | both |
| `term/starship.toml` | `~/.config/starship.toml` | both |
| `git/gitalias.txt` | `~/.gitalias.txt` | both |
| `git/gitignore` | `~/.gitignore` | both |
| `ssh/config` | `~/.ssh/config` | both |
| `bin/` | `~/bin` | both |
| `term/zshrc` | `~/.zshrc` | full |
| `term/zshenv` | `~/.zshenv` | full |
| `term/bashrc` | `~/.bashrc.dotfiles` | minimal |
| `term/bash_prompt.bash` | `~/.bash_prompt` | minimal |
| `agents/claude/settings.personal.json` | `~/.claude/settings.json` | both |
| `agents/claude/ccstatusline-settings.json` | `~/.config/ccstatusline/settings.json` | both |
| `agents/claude/commands` | `~/.claude/commands` | both |
| `agents/claude/skills` | `~/.claude/skills` | both |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` | full |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` | full |

There is currently no global instructions file. `agents/shared/instructions.md` was deleted; recover it from commit `94feb3d` if a replacement is wanted.
