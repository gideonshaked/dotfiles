# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository using [Dotbot](https://github.com/anishathalye/dotbot) for installation and symlink management. Configuration files are organized by tool/purpose and symlinked to their expected locations.

## Commands

**Install/update dotfiles:**
```bash
./install            # Full install (macOS)
./install --minimal  # Minimal install (remote servers)
```

**Manage dotfiles:**
```bash
dotfiles update      # Pull latest changes and run install
dotfiles brewfile    # Update Homebrew package manifest
dotfiles dotbot      # Update Dotbot submodule
```

## Architecture

The install script runs Dotbot with `install.conf.yaml` (full) or `install-minimal.conf.yaml` (via `--minimal` flag).

### Minimal Install

For remote servers. Installs: SSH config, Claude Code + ccstatusline, git aliases, and portable bash config (aliases, functions, prompt). Sources `aliases.zsh` and `functions.zsh` from the same files used by the full zsh setup. Appends a source line to the existing `.bashrc` without overwriting it. ccstatusline install is failure-tolerant.

### Key Symlink Mappings (full install)

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

### Key Symlink Mappings (minimal install)

| Source in repo | Target location |
|----------------|-----------------|
| `term/zsh/aliases.zsh` | `~/.zsh/aliases.zsh` |
| `term/zsh/functions.zsh` | `~/.zsh/functions.zsh` |
| `term/bashrc.dotfiles` | `~/.bashrc.dotfiles` |
| `term/bash_prompt.bash` | `~/.bash_prompt` |
| `ssh/config` | `~/.ssh/config` |
| `git/gitalias.txt` | `~/.gitalias.txt` |
| `git/gitignore` | `~/.gitignore` |
| `claude/claude-settings.json` | `~/.claude/settings.json` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/ccstatusline-settings.json` | `~/.config/ccstatusline/settings.json` |
| `bin/claude-validate` | `~/bin/claude-validate` |
| `bin/sshkey` | `~/bin/sshkey` |
| `bin/git-nuke` | `~/bin/git-nuke` |

### Submodules

- `dotbot/` : Dotbot installer

### Zsh Configuration

`~/.zshrc` sources files from `~/.zsh/` in order: env, zsh_config, external, functions, aliases, path.

### Bash Configuration (minimal)

`~/.bashrc.dotfiles` is appended to the existing `~/.bashrc`. It sources `~/.zsh/functions.zsh`, `~/.zsh/aliases.zsh`, and `~/.bash_prompt`. The bash prompt is a pure-bash starship-like prompt showing user@host, directory, git branch, and virtualenv.

## Pre-commit Hooks

Uses pre-commit.ci with: ruff (lint + format), beautysh (shell), codespell, and standard pre-commit-hooks.
