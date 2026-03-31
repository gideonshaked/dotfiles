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

For remote servers. Installs: SSH config, Claude Code + ccstatusline, git aliases, and portable bash config (aliases, functions, prompt). Sources `aliases.zsh` and `functions.zsh` from the same files used by the full zsh setup. Appends a source line to both `.bashrc` and `.bash_profile` for login shell compatibility (e.g., tcsh exec-to-bash). ccstatusline install is failure-tolerant. Guarded against double-sourcing.

### SSH Auto-Bootstrap

The `s()` function (Kitty SSH wrapper in `functions.zsh`) auto-installs minimal dotfiles on first connection to a new host. Uses a local cache at `~/.cache/dotfiles-ssh/` to avoid repeat checks. Use `s --force-reinstall <host>` to pull and re-run the install. The bootstrap pipes the install script via stdin to work with any remote login shell (bash, tcsh, etc.).

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
| `bin/claude-validate` | `~/bin/claude-validate` |
| `bin/dotfiles` | `~/bin/dotfiles` |
| `bin/git-nuke` | `~/bin/git-nuke` |
| `bin/sshkey` | `~/bin/sshkey` |

### Key Symlink Mappings (minimal install)

| Source in repo | Target location |
|----------------|-----------------|
| `term/zsh/` | `~/.zsh/` |
| `term/bashrc.dotfiles` | `~/.bashrc.dotfiles` |
| `term/bash_prompt.bash` | `~/.bash_prompt` |
| `ssh/config` | `~/.ssh/config` |
| `git/gitalias.txt` | `~/.gitalias.txt` |
| `git/gitignore` | `~/.gitignore` |
| `claude/claude-settings.json` | `~/.claude/settings.json` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/ccstatusline-settings.json` | `~/.config/ccstatusline/settings.json` |
| `bin/claude-validate` | `~/bin/claude-validate` |
| `bin/dotfiles` | `~/bin/dotfiles` |
| `bin/git-nuke` | `~/bin/git-nuke` |
| `bin/sshkey` | `~/bin/sshkey` |

### Submodules

- `dotbot/` : Dotbot installer

### Zsh Configuration

`~/.zshrc` sources files from `~/.zsh/` in order: env, zsh_config, external, functions, aliases, path.

### Bash Configuration (minimal)

`~/.bashrc.dotfiles` is sourced from both `~/.bashrc` and `~/.bash_profile` for login shell compatibility. It sources `~/.zsh/functions.zsh`, `~/.zsh/aliases.zsh`, and `~/.bash_prompt`. The bash prompt is a pure-bash starship-like prompt showing user@host, directory, git branch, and virtualenv. Has a double-source guard.

## Pre-commit Hooks

Uses pre-commit.ci with: ruff (lint + format), beautysh (shell), codespell, and standard pre-commit-hooks.
