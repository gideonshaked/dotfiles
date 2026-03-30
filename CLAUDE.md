# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository using [Dotbot](https://github.com/anishathalye/dotbot) for installation and symlink management. Configuration files are organized by tool/purpose and symlinked to their expected locations.

## Commands

**Install/update dotfiles:**
```bash
./install
```

**Manage dotfiles:**
```bash
dotfiles update      # Pull latest changes and run install
dotfiles brewfile    # Update Homebrew package manifest
dotfiles dotbot      # Update Dotbot submodule
```

## Architecture

The install script auto-installs Oh My Zsh and Starship if missing, then runs Dotbot with `install.conf.yaml` and optionally Homebrew.

### Key Symlink Mappings

| Source in repo | Target location |
|----------------|-----------------|
| `term/zshrc` | `~/.zshrc` |
| `term/zsh/` | `~/.zsh/` |
| `term/starship.toml` | `~/.config/starship.toml` |
| `git/gitconfig` | `~/.gitconfig` |
| `ssh/config` | `~/.ssh/config` |
| `claude/claude-settings.json` | `~/.claude/settings.json` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/ccstatusline-settings.json` | `~/.config/ccstatusline/settings.json` |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` |
| `clang/clang-format` | `~/.clang-format` |
| `clang/config.yaml` | `~/Library/Preferences/clangd/config.yaml` |
| `bin/` | `~/bin/` |

### Submodules

- `dotbot/` — Dotbot installer

### Zsh Configuration

`~/.zshrc` sources files from `~/.zsh/` in order: env → zsh_config → external → functions → aliases → path.

## Pre-commit Hooks

Uses pre-commit.ci with: beautysh (shell), codespell, and standard pre-commit-hooks.
