# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository using [Dotbot](https://github.com/anishathalye/dotbot) for installation and symlink management. Configuration files are organized by tool/purpose and symlinked to their expected locations.

## Commands

**Install/update dotfiles:**
```bash
./install
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

Dotbot reads `install.conf.yaml` to:
1. Clean specified directories
2. Create symlinks from home directory locations to files in this repo
3. Run shell commands (sync git submodules, install pipx dependencies, run `brew bundle`)

### Key Symlink Mappings

| Source in repo | Target location |
|----------------|-----------------|
| `term/zshrc` | `~/.zshrc` |
| `term/zsh/` | `~/.zsh/` |
| `git/gitconfig` | `~/.gitconfig` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `bin/` | `~/bin/` |

### Zsh Configuration

`~/.zshrc` sources files from `~/.zsh/` in order: env → zsh_config → external → functions → aliases → path.

## Pre-commit Hooks

Uses pre-commit.ci with: black, isort, flake8 (Python), beautysh (shell), codespell, and standard pre-commit-hooks. Excludes `zsh/p10k.zsh`, `clang/config.yaml`, `ssh/config`, and `jupyter/`.
