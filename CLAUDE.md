# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository using [Dotbot](https://github.com/anishathalye/dotbot) for installation and symlink management. Configuration files are organized by tool/purpose and symlinked to their expected locations. Supports both full (macOS) and minimal (cross-platform) install profiles.

## Commands

**Full install (macOS — default):**
```bash
./install
```

**Minimal install (cross-platform — Linux/macOS):**
```bash
./install minimal
```

**Lint all files:**
```bash
make lint
# or directly:
pre-commit run --all-files
```

**Clean Python cache:**
```bash
make clean
```

## Architecture

The install script auto-installs Oh My Zsh and Starship if missing, then runs Dotbot configs and optionally Homebrew.

### Install Profiles

- **`./install`** (or `./install full`): Runs `install.core.conf.yaml` + `install.extras.conf.yaml`, full `Brewfile`, and merges MCP servers.
- **`./install minimal`**: Runs `install.core.conf.yaml`, `Brewfile.core` (macOS only), and merges MCP servers.

### Key Symlink Mappings

**Core** (`install.core.conf.yaml` — cross-platform):

| Source in repo | Target location |
|----------------|-----------------|
| `term/zshrc` | `~/.zshrc` |
| `term/zsh/` | `~/.zsh/` |
| `term/starship.toml` | `~/.config/starship.toml` |
| `git/gitconfig` | `~/.gitconfig` |
| `ssh/config` | `~/.ssh/config` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `claude/skills/commands/` | `~/.claude/commands/` |
| `ccstatusline/settings.json` | `~/.config/ccstatusline/settings.json` |
| `bin/` | `~/bin/` |

**Extras** (`install.extras.conf.yaml` — macOS only):

| Source in repo | Target location |
|----------------|-----------------|
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` |
| `clang/clang-format` | `~/.clang-format` |
| `clang/config.yaml` | `~/Library/Preferences/clangd/config.yaml` |

### Submodules

- `dotbot/` — Dotbot installer
- `claude/skills/` — Private repo ([claude-skills](https://github.com/gideonshaked/claude-skills)) containing Claude Code custom commands and prompts

### Zsh Configuration

`~/.zshrc` sources files from `~/.zsh/` in order: env → zsh_config → external → functions → aliases → path.

## Pre-commit Hooks

Uses pre-commit.ci with: black, isort, flake8 (Python), beautysh (shell), codespell, and standard pre-commit-hooks. Excludes `clang/config.yaml` and `ssh/config`.
