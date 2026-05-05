# AGENTS.md

This file provides guidance to coding agents (Claude Code, etc.) when working with code in this repository.

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
dotfiles update              # Pull latest changes and run install
dotfiles update --minimal    # Same, but minimal install
dotfiles brewfile            # Update Homebrew package manifest
dotfiles dotbot              # Update Dotbot submodule
```

## Architecture

The install script initializes the Dotbot submodule and runs Dotbot with `install.conf.yaml`. The `--minimal` flag sets `DOTFILES_INSTALL_MODE=minimal`, and the same YAML file conditionally skips the full macOS links.

### Minimal Install

For remote servers. Installs: SSH config, Claude/Codex agent config, ccstatusline, git aliases, and portable bash config (aliases, functions, prompt). Sources `aliases.zsh` and `functions.zsh` from the same files used by the full zsh setup. Appends a source line to both `.bashrc` and `.bash_profile` for login shell compatibility (e.g., tcsh exec-to-bash). ccstatusline install is failure-tolerant. Guarded against double-sourcing.

### SSH Wrapper (`bin/s`)

The `s` script is an SSH wrapper that uses the Kitty SSH kitten when available, falling back to plain ssh. Dotfiles management on remotes is opt-in via flags: `--install-dotfiles`, `--reinstall-dotfiles`, `--update-dotfiles`. Default is just SSH with no dotfiles action.

### Key Symlink Mappings (full install)

| Source in repo | Target location |
|----------------|-----------------|
| `term/zshrc` | `~/.zshrc` |
| `term/zsh/` | `~/.zsh/` |
| `term/starship.toml` | `~/.config/starship.toml` |
| `git/gitconfig` | `~/.gitconfig` |
| `ssh/config` | `~/.ssh/config` |
| `agents/claude/settings.json` | `~/.claude/settings.json` |
| `agents/claude/ccstatusline-settings.json` | `~/.config/ccstatusline/settings.json` |
| `agents/shared/instructions.md` | `~/.claude/CLAUDE.md` |
| `agents/claude/commands` | `~/.claude/commands` |
| `agents/claude/skills` | `~/.claude/skills` |
| `agents/codex/config.toml` | `~/.codex/config.toml` |
| `agents/shared/instructions.md` | `~/.codex/AGENTS.md` |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` |
| `clang/clang-format` | `~/.clang-format` |
| `clang/config.yaml` | `~/Library/Preferences/clangd/config.yaml` |
| `bin/` | `~/bin` |

### Key Symlink Mappings (minimal install)

| Source in repo | Target location |
|----------------|-----------------|
| `term/zsh/` | `~/.zsh/` |
| `term/bashrc.dotfiles` | `~/.bashrc.dotfiles` |
| `term/bash_prompt.bash` | `~/.bash_prompt` |
| `ssh/config` | `~/.ssh/config` |
| `git/gitalias.txt` | `~/.gitalias.txt` |
| `git/gitignore` | `~/.gitignore` |
| `agents/claude/settings.json` | `~/.claude/settings.json` |
| `agents/claude/ccstatusline-settings.json` | `~/.config/ccstatusline/settings.json` |
| `agents/shared/instructions.md` | `~/.claude/CLAUDE.md` |
| `agents/claude/commands` | `~/.claude/commands` |
| `agents/claude/skills` | `~/.claude/skills` |
| `agents/codex/config.toml` | `~/.codex/config.toml` |
| `agents/shared/instructions.md` | `~/.codex/AGENTS.md` |
| `bin/` | `~/bin` |

### Submodules

- `dotbot/` : Dotbot installer

### Zsh Configuration

`~/.zshrc` sources files from `~/.zsh/` in order: env, zsh_config, external, functions, aliases, path.

### Bash Configuration (minimal)

`~/.bashrc.dotfiles` is sourced from both `~/.bashrc` and `~/.bash_profile` for login shell compatibility. It sources `~/.zsh/functions.zsh`, `~/.zsh/aliases.zsh`, and `~/.bash_prompt`. The bash prompt is a pure-bash starship-like prompt showing user@host, directory, git branch, and virtualenv. Has a double-source guard.

## Pre-commit Hooks

Uses pre-commit.ci with: ruff (lint + format), beautysh (shell), codespell, and standard pre-commit-hooks.

## Non-Interactive Shell Commands

**ALWAYS use non-interactive flags** with file operations to avoid hanging on confirmation prompts.

Shell commands like `cp`, `mv`, and `rm` may be aliased to include `-i` (interactive) mode on some systems, causing the agent to hang indefinitely waiting for y/n input.

**Use these forms instead:**
```bash
# Force overwrite without prompting
cp -f source dest           # NOT: cp source dest
mv -f source dest           # NOT: mv source dest
rm -f file                  # NOT: rm file

# For recursive operations
rm -rf directory            # NOT: rm -r directory
cp -rf source dest          # NOT: cp -r source dest
```

**Other commands that may prompt:**
- `scp` - use `-o BatchMode=yes` for non-interactive
- `ssh` - use `-o BatchMode=yes` to fail instead of prompting
- `apt-get` - use `-y` flag
- `brew` - use `HOMEBREW_NO_AUTO_UPDATE=1` env var

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:ca08a54f -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

## Session Completion

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
<!-- END BEADS INTEGRATION -->
