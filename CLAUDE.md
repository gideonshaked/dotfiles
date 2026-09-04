# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Overview

Personal dotfiles repository using [Dotbot](https://github.com/anishathalye/dotbot) for installation and symlink management. Configuration files are organized by tool/purpose and symlinked to their expected locations.

Claude Code is the only supported agent. Codex support was removed.

## Commands

**Install/update dotfiles:**
```bash
./install                     # use the saved profile, or personal
./install --profile server    # use and remember a profile
./install --list              # show profiles and their modules
```

The installer only needs `git` and `python3` to create symlinks. The post-link agent steps additionally use `npx`, `jq`, `uv`, and `claude`; each step is failure-tolerant and skips (printing a `non-fatal` message) when its tool is missing.

**Manage dotfiles:**
```bash
dotfiles update              # Pull latest changes and run install
dotfiles brewfile            # Update Homebrew package manifest
dotfiles dotbot              # Update Dotbot submodule
```

**Run tests:**
```bash
uv run pytest tests/ -q
```

## Architecture

### Profiles and modules

A profile is an ordered list of module files under `modules/`, passed to Dotbot as several `-c` arguments. Dotbot accepts multiple config files natively, so composition needs no custom machinery, and no module contains a conditional.

| Profile | Modules |
|---------|---------|
| `personal` | settings-personal, core, macos |
| `work` | settings-work, core, macos |
| `server` | settings-personal, core |

| Module | Contents |
|--------|----------|
| `settings-personal` / `settings-work` | Only the `~/.claude/settings.json` link |
| `core` | Everything every machine gets: shell config, git, SSH, `~/bin`, Claude memory/skills/commands, and all install steps |
| `macos` | zshenv, gitconfig, VS Code, Homebrew shell tools, hushlogin |

**Module order matters.** The settings module is listed first because
`scripts/install-claude-plugins` reads `~/.claude/settings.json` and skips
silently when it is absent. Dotbot processes `-c` files left to right, so the
link must be created in an earlier module than the step that reads it. Putting
the settings link last meant a fresh machine installed zero plugins on its
first run.

The map lives in the `profile_modules` function in `install`. Adding a machine class means adding one `case` arm, not editing existing entries. It is a `case` statement rather than an associative array because macOS ships bash 3.2, which predates `declare -A`, and the bootstrap runs before Homebrew exists.

The chosen profile is remembered in `~/.dotfiles-profile`, so a bare `./install` repeats it. `--profile` overrides and updates the marker; `--dry-run` changes nothing. An unknown profile fails loudly rather than falling back to a default.

### Shell configuration

zsh and bash are equal first-class citizens. **One file configures both.**

| File | Role |
|------|------|
| `terminal/shellrc` | Symlinked to both `~/.zshrc` and `~/.bashrc.dotfiles`. A shared POSIX section, then a zsh branch and a bash branch, then a shared tools section. |
| `terminal/zshenv` | Loaded before `/etc/zshrc`, which is the only reason it is separate. Disables Apple Terminal session restore; sources `~/.cargo/env` because rustup writes that file directly. |
| `terminal/starship.toml` | Prompt config, a different format. |

`shellrc` sets `$__shell` to `zsh` or `bash` once, near the top. That is what makes the tools section shared rather than duplicated: `starship init "$__shell"`, `atuin init "$__shell"`, and the fzf key-bindings path are each written once and work in both.

**Both shells parse the entire file**, so zsh-only syntax must stay syntactically valid to bash even though it never executes there. Array assignment, `setopt`, `zstyle`, and `autoload` all satisfy that; a zsh glob such as `~/.ssh/^(config)` would not. Check with `bash -n terminal/shellrc && zsh -n terminal/shellrc` after editing.

fzf-tab, autosuggestions, and syntax-highlighting are zsh-only because no bash equivalent exists. Every plugin source is guarded with a file test, so a machine without them still starts cleanly.

Secrets live at `~/.shell-secrets`, **outside the repository**, so they cannot be committed by accident.

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

The drift has one routine cause: `/config` and `/model` write to `~/.claude/settings.json`, which links to whichever profile is installed, so the other profile falls behind. Run `dotfiles sync` after changing settings through the Claude Code UI. It copies every non-profile-specific key from the active profile to the other.

### The server profile

Drops the `macos` module and keeps everything else. `scripts/configure-bash-hooks` appends a source line to both `.bashrc` and `.bash_profile` for login-shell compatibility (e.g. tcsh exec-to-bash), guarded against double-sourcing. The install owns `~/bin`; an existing `~/bin` is backed up first.

### SSH config

`~/.ssh/config` is an entry point holding three `Include` lines and nothing
else. Hosts come from whichever files a profile links, so adding a machine
class never means editing a shared file.

Include order is precedence order, because OpenSSH takes the **first** value it
sees for each keyword:

| Directory | Tracked | Contents |
|-----------|---------|----------|
| `~/.ssh/local.d/` | no, and it lives outside the repo | Machine-local hosts. First, so it overrides anything managed. |
| `~/.ssh/config.d/` | yes, `ssh/config.d/` | One file per site: `01-github`, `02-umich`, `03-ucla`, `04-tau`, `05-nubio`. Linked by `core`. |
| `~/.ssh/platform.d/` | yes, `ssh/platform.d/` | `Host *` blocks. Last, so every specific host wins. Only `macos` so far, linked by the `macos` module. |

The numbers keep the `config.d` listing stable; they carry no meaning beyond
that, since the files define disjoint hosts. What the numbers deliberately do
**not** do is order the `Host *` block: that lives in its own directory,
included after the glob, so a future `06-` file can never sort past it.

`platform.d/macos` is the reason the split exists. It points `IdentityAgent` at
the 1Password socket under `~/Library/Group Containers/`, a path that cannot
exist on Linux. Before the split, `core` linked one `ssh/config` to every
profile, so the server profile got it.

Work hosts are **not** in the repo. `~/.ssh/local.d/octant` carries an EC2
instance id, an internal GCP project name, and a colleague's username; this
repository is public. A fresh work laptop needs that file copied over by hand.

A glob matching nothing is not an error, so a machine missing any of the three
directories is fine.

### SSH wrapper (`bin/s`)

The `s` script is an SSH wrapper that uses the Kitty SSH kitten when available, falling back to plain ssh. Dotfiles management on remotes is opt-in via flags: `--install-dotfiles`, `--reinstall-dotfiles`, `--update-dotfiles`. Default is just SSH with no dotfiles action.

### Symlink mappings

Read the files under `modules/`. They are the source of truth and a copy here would drift.

There is currently no global instructions file. `agents/shared/instructions.md` was deleted; recover it from commit `94feb3d` if a replacement is wanted.
