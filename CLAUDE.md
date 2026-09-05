# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles using [Dotbot](https://github.com/anishathalye/dotbot) for symlink management. Configuration is grouped by tool and linked to where each tool expects it. Claude Code is the only agent this repository configures.

## Commands

**Install/update dotfiles:**
```bash
./install                     # use the saved profile, or personal
./install --profile server    # use and remember a profile
./install --list              # show profiles and their modules
```

The installer only needs `git` and `python3` to create symlinks. The post-link steps additionally use `brew`, `npx`, `jq`, `uv`, and `claude`; each step is failure-tolerant and skips (printing a `non-fatal` message) when its tool is missing.

**Manage dotfiles:**
```bash
dotfiles update              # Pull latest changes and run install
dotfiles brew                # Install everything in the manifest
dotfiles dotbot              # Update Dotbot submodule
```

**Lint:**
```bash
pre-commit run --all-files                        # what CI runs
shellcheck install bin/* setup/scripts/*          # not in pre-commit; run it by hand
bash -n terminal/shellrc && zsh -n terminal/shellrc
```

`.github/workflows/lint.yml` runs pre-commit on push and pull request. There are no tests.

## Architecture

### Profiles and modules

A profile is an ordered list of module files under `setup/modules/`, passed to Dotbot as several `-c` arguments. Dotbot accepts multiple config files natively, so composition needs no custom machinery, and no module contains a conditional.

| Profile | Modules |
|---------|---------|
| `personal` | settings-personal, core, macos |
| `work` | settings-work, core, macos |
| `server` | settings-personal, core |

| Module | Contents |
|--------|----------|
| `settings-personal` / `settings-work` | Only the `~/.claude/settings.json` link |
| `core` | Everything every machine gets: shell config, git, SSH, `~/bin`, Claude memory/skills/commands, and all install steps |
| `macos` | zshenv, the macOS half of the gitconfig, the 1Password SSH block, VS Code, hushlogin |

**Module order matters.** The settings module is listed first because
`setup/scripts/install-claude-plugins` reads `~/.claude/settings.json` and skips
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
| `terminal/ghostty.config` | Terminal rendering. cmux links libghostty and reads the Ghostty config rather than shipping its own, so this is cmux's renderer config. |
| `terminal/cmux.json` | Everything cmux-specific: sidebar, notifications, automation. JSONC. cmux resolves symlinks before an atomic write, so a linked file survives being saved from its UI. |

`shellrc` sets `$__shell` to `zsh` or `bash` once, near the top. That is what makes the tools section shared rather than duplicated: `starship init "$__shell"`, `atuin init "$__shell"`, and the fzf key-bindings path are each written once and work in both.

**Both shells parse the entire file**, so zsh-only syntax must stay syntactically valid to bash even though it never executes there. Array assignment, `setopt`, `zstyle`, and `autoload` all satisfy that; a zsh glob such as `~/.ssh/^(config)` would not. Check with `bash -n terminal/shellrc && zsh -n terminal/shellrc` after editing.

fzf-tab, autosuggestions, and syntax-highlighting are zsh-only because no bash equivalent exists. Every plugin source is guarded with a file test, so a machine without them still starts cleanly.

Secrets live at `~/.shell-secrets`, **outside the repository**, so they cannot be committed by accident.

### What install-packages provides

macOS installs Homebrew if it is absent and runs `brew bundle`, so the whole
manifest lands. Linux cannot: Homebrew ships bottles only for
`/home/linuxbrew/.linuxbrew`, which needs root, and at a writable prefix every
formula compiles from source. Many of these machines have no sudo, so each tool
is fetched as a released binary under `$HOME` instead.

| Tool | Needed by | Linux source |
|------|-----------|--------------|
| starship, fzf, atuin | `terminal/shellrc` | own installers, `~/.local/bin` |
| `uv` | `uvx`, which runs ssh-mcp | astral installer |
| `jq` | `install-claude-plugins`, `claude-validate` | static binary from releases |
| `node` | `npx`, for ccstatusline and the gcloud MCP | current LTS tarball, resolved from the release index |
| `claude` | everything under `agents/claude/` | `claude.ai/install.sh`, both platforms |
| `ruff` | `claude-validate`, for edited Python | `uv tool install` |
| `pre-commit` | this repository's git hooks | `uv tool install` |
| `bd`, `dolt` | the issue database in `.beads` | release tarballs |

`jq` installs before `node` and `bd` because both resolve their version from a
release index read with it.

Every Linux installer is guarded by `have <tool> && return 0`, so it installs
what is missing and never upgrades. `brew bundle` does upgrade, so the two
platforms can drift; a clean machine cannot hit this.

Dotbot runs shell steps without a login shell, so they inherit a PATH that
predates the install. `setup/scripts/lib/path.sh` is sourced by every step that
needs a tool, and prepends `~/.local/bin` and both Homebrew prefixes. Without
it a tool installed seconds earlier is invisible.

### Agent provisioning

`bin/` holds only commands meant to be typed: `dotfiles` and `s`. What
`~/.claude/settings.json` names by absolute path is linked to a fixed `$HOME`
location instead, since the repository's own path differs per machine:
`agents/claude/hooks/claude-validate` to `~/.claude/hooks/`.

npx comes from `node`: the manifest on macOS, the LTS tarball on Linux. There
is no nvm wrapper. The statusLine and the gcloud MCP both run through
`bash -lc`, which sources the login shell and so has the real PATH.

`install-claude-plugins` reads `extraKnownMarketplaces` and `enabledPlugins` from the linked `~/.claude/settings.json` (via `jq`) and adds/installs each marketplace and plugin.

`install-mcps` holds one function per server: `exa` (HTTP), `gcloud` (npx through `bash -lc`), `ssh-mcp` (uvx) and `context7`. Each checks what is already registered and re-adds only when the stored command no longer matches, so an older definition is replaced rather than kept.

Context7 is registered directly over HTTP rather than through `ctx7 setup`,
which opens an OAuth device flow and waits for a browser that a server does not
have, ignoring `--yes`. The endpoint is the same with or without a key; when
`CONTEXT7_API_KEY` is set it becomes an `Authorization` header and is written to
`~/.shell-secrets`.

**Tool budget is a scarce shared resource.** Claude Code defers every MCP tool behind `ToolSearch` once tool definitions exceed 10% of the context window, which hides low-tool-count servers like exa behind higher-count ones. Adding an MCP server means checking afterwards whether deferral has kicked in.

### Claude settings: personal and work profiles

`agents/claude/settings.personal.json` and `agents/claude/settings.work.json` are two complete files, one of which is symlinked to `~/.claude/settings.json`.

They are separate files rather than a base plus an overlay because Claude Code has no include or extend mechanism, and because a generated settings file would be clobbered by `/config`, which writes to `~/.claude/settings.json` directly. Symlinking keeps `/config` edits landing in the repo where git tracks them.

A plugin enabled in `~/.claude/settings.json` cannot be disabled per-project ([claude-code#34415](https://github.com/anthropics/claude-code/issues/34415), closed as duplicate, no workaround), so work plugins must be absent from the personal profile rather than merely overridden.

`/config` and `/model` write to `~/.claude/settings.json`, which links to whichever profile is installed, so the other profile falls behind. Keeping them in step is a manual edit.

### The server profile

Drops the `macos` module and keeps everything else. `setup/scripts/configure-bash-hooks` appends a source line to both `.bashrc` and `.bash_profile` for login-shell compatibility (e.g. tcsh exec-to-bash), guarded against double-sourcing. The install owns `~/bin`; an existing `~/bin` is backed up first.

### SSH config

`~/.ssh/config` is an entry point holding three `Include` lines and nothing
else. Include order is precedence order, because OpenSSH takes the **first**
value it sees for each keyword:

| Directory | Tracked | Contents |
|-----------|---------|----------|
| `~/.ssh/private.d/` | no, gitignored | Every host: `umich`, `ucla`, `tau`, `octant`, `afterquery`. First, so it overrides anything managed. |
| `~/.ssh/config.d/` | yes, `ssh/config.d/` | `01-github` only. Linked by `core`. |
| `~/.ssh/platform.d/` | yes, `ssh/platform.d/` | `Host *` blocks. Last, so every specific host wins. `01-macos`, linked by the `macos` module. |

Only github and the macOS platform block are tracked. Everything naming a real
host is private: the repository is public, and the host files carry usernames,
internal hostnames, an EC2 instance id and a GCP project.

The private files still live in the repo, at `ssh/private.d/`, gitignored and
symlinked as a directory. They are edited alongside everything else and dotbot
owns the link, but git never sees them. Two consequences: they are the only
copy, so `git clean -fdx` destroys them, and a fresh clone has no
`ssh/private.d` at all. The link carries `ignore-missing` for that reason, so
the install succeeds on a machine that has not been given them yet.

The numbers carry no meaning beyond keeping a listing stable. The `Host *`
block is deliberately not among them: it lives in its own directory included
after the glob, so a later file cannot sort past it and start winning over
specific hosts.

`platform.d/01-macos` is why the split exists. It points `IdentityAgent` at the
1Password socket under `~/Library/Group Containers/`, a path that cannot exist
on Linux, and `core` used to link one `ssh/config` to every profile.

A glob matching nothing is not an error, so a machine missing any of the three
directories is fine.

### SSH wrapper (`bin/s`)

The `s` script is a plain `ssh` wrapper. Dotfiles management on remotes is
opt-in via flags: `--install-dotfiles`, `--reinstall-dotfiles`,
`--update-dotfiles`. Default is just SSH with no dotfiles action.

Nothing here ships terminfo to the remote. cmux reports `TERM=xterm-256color`,
which every host already has, so plain `ssh` renders correctly. A terminal
that advertises an exotic `TERM` instead (`xterm-kitty`, `xterm-ghostty`)
would need its entry compiled into `~/.terminfo` on each host once; do not
reach for a per-connection wrapper such as the Kitty SSH kitten to do it,
because those only fire when wrapping the literal `ssh` command and are
bypassed by `gcloud compute ssh`, a cloudflared `ProxyCommand` and any jump
host.

### The Homebrew manifest

`manifest/Brewfile` lists dependencies of this repository's configuration and
nothing else: 16 formulae, 3 casks, and the VS Code extensions. Every entry is
required by a file in this repo, and each carries a comment naming the file
that needs it.

Nothing regenerates it. `brew bundle dump` writes the machine's full inventory,
which was 52 formulae and 82 casks, so the `dotfiles brewfile` subcommand that
called it is gone. `dotfiles brew` still installs from the manifest.

That means the manifest is no longer a machine backup. Adding a package to a
machine does not add it here; it belongs here only when something in the repo
starts depending on it.

### Git configuration

`git/gitconfig` is linked by `core` and ends with an include of
`~/.gitconfig.local`, which the `macos` module points at `git/gitconfig-macos`.
Git ignores a missing include, so Linux simply gets the shared half. That split
exists because `osxkeychain` is macOS-only; the `gh` credential helper is
written as `!command -v gh ... && gh auth git-credential` so it works anywhere
and exits quietly when `gh` is absent.

### Vendor-installed skills

`agents/claude/skills/.gitignore` excludes skills that other tooling writes into
that directory on every install. Tracking them would mean committing someone
else's artifact and taking churn on every vendor update.

### Symlink mappings

Read the files under `setup/modules/`. They are the source of truth and a copy here would drift.
