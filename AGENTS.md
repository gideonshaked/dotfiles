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

For remote servers. Installs: SSH config, Claude/Codex agent config, ccstatusline, user-local npx via nvm, git aliases, and portable bash config (aliases, functions, prompt). Sources `aliases.zsh` and `functions.zsh` from the same files used by the full zsh setup. Appends a source line to both `.bashrc` and `.bash_profile` for login shell compatibility (e.g., tcsh exec-to-bash). The install owns `~/bin`; an existing `~/bin` is backed up before the repo bin is linked. ccstatusline install is failure-tolerant. Guarded against double-sourcing.

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
| `agents/codex/skills` | `~/.codex/skills` |
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
| `agents/codex/skills` | `~/.codex/skills` |
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

<!-- BEGIN BEADS INTEGRATION v:1 profile:full hash:f65d5d33 -->
## Issue Tracking with bd (beads)

**IMPORTANT**: This project uses **bd (beads)** for ALL issue tracking. Do NOT use markdown TODOs, task lists, or other tracking methods.

### Why bd?

- Dependency-aware: Track blockers and relationships between issues
- Git-friendly: Dolt-powered version control with native sync
- Agent-optimized: JSON output, ready work detection, discovered-from links
- Prevents duplicate tracking systems and confusion

### Quick Start

**Check for ready work:**

```bash
bd ready --json
```

**Create new issues:**

```bash
bd create "Issue title" --description="Detailed context" -t bug|feature|task -p 0-4 --json
bd create "Issue title" --description="What this issue is about" -p 1 --deps discovered-from:bd-123 --json
```

**Claim and update:**

```bash
bd update <id> --claim --json
bd update bd-42 --priority 1 --json
```

**Complete work:**

```bash
bd close bd-42 --reason "Completed" --json
```

### Issue Types

- `bug` - Something broken
- `feature` - New functionality
- `task` - Work item (tests, docs, refactoring)
- `epic` - Large feature with subtasks
- `chore` - Maintenance (dependencies, tooling)

### Priorities

- `0` - Critical (security, data loss, broken builds)
- `1` - High (major features, important bugs)
- `2` - Medium (default, nice-to-have)
- `3` - Low (polish, optimization)
- `4` - Backlog (future ideas)

### Workflow for AI Agents

1. **Check ready work**: `bd ready` shows unblocked issues
2. **Claim your task atomically**: `bd update <id> --claim`
3. **Work on it**: Implement, test, document
4. **Discover new work?** Create linked issue:
   - `bd create "Found bug" --description="Details about what was found" -p 1 --deps discovered-from:<parent-id>`
5. **Complete**: `bd close <id> --reason "Done"`

### Quality
- Use `--acceptance` and `--design` fields when creating issues
- Use `--validate` to check description completeness

### Lifecycle
- `bd defer <id>` / `bd supersede <id>` for issue management
- `bd stale` / `bd orphans` / `bd lint` for hygiene
- `bd human <id>` to flag for human decisions
- `bd formula list` / `bd mol pour <name>` for structured workflows

### Auto-Sync

bd automatically syncs via Dolt:

- Each write auto-commits to Dolt history
- Use `bd dolt push`/`bd dolt pull` for remote sync
- No manual export/import needed!

### Important Rules

- ✅ Use bd for ALL task tracking
- ✅ Always use `--json` flag for programmatic use
- ✅ Link discovered work with `discovered-from` dependencies
- ✅ Check `bd ready` before asking "what should I work on?"
- ❌ Do NOT create markdown TODO lists
- ❌ Do NOT use external issue trackers
- ❌ Do NOT duplicate tracking systems

For more details, see README.md and docs/QUICKSTART.md.

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
