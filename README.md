# Dotfiles

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/gideonshaked/dotfiles/master.svg)](https://results.pre-commit.ci/latest/github/gideonshaked/dotfiles/master)

My personal dotfiles. In my opinion, [dotfiles are NOT meant to be forked](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/#dotfiles-are-not-meant-to-be-forked). That being said, this repository contains lots of useful things ([shell functions](https://github.com/gideonshaked/dotfiles/blob/master/term/zsh/functions.zsh), [scripts](https://github.com/gideonshaked/dotfiles/tree/master/bin), [gitconfig](https://github.com/gideonshaked/dotfiles/blob/master/git/gitconfig)) that you can add to your personal setup. As such, I encourage anyone that thinks these dotfiles look useful to try to understand them first and then copy the parts that stand out to them.

## Install

### Full install (macOS)

```bash
git clone --recursive https://github.com/gideonshaked/dotfiles && cd dotfiles && ./install
```

### Minimal install (remote servers)

One-shot setup for SSH hosts. Installs a portable bash config (prompt, aliases, functions), SSH config, Claude Code + ccstatusline, and git aliases without overwriting the existing shell config.

```bash
git clone --recursive https://github.com/gideonshaked/dotfiles && cd dotfiles && ./install --minimal
```

### Auto-bootstrap via SSH

The `s` function (Kitty SSH wrapper) automatically installs minimal dotfiles on first connection to a new host. Use `s --force-reinstall <host>` to pull latest changes and re-run the install.

### Management

After install, use the [`dotfiles`](./bin/dotfiles) utility:

```bash
dotfiles update      # Pull latest changes and run install
dotfiles brewfile    # Update Homebrew package manifest
dotfiles dotbot      # Update Dotbot submodule
```

## Directory Structure

```text
├── bin         <- Personal scripts (git-nuke, sshkey, dotfiles, claude-validate)
├── claude      <- Claude Code settings, global CLAUDE.md, and ccstatusline config
├── clang       <- clang-format and clangd config
├── git         <- Git configuration files (aliases, custom formatting, etc.)
├── manifest    <- Brewfile
├── ssh         <- SSH config file
├── term        <- Shell configuration (zsh, bash, starship)
└── vscode      <- VS Code configuration and extensions list
```

## Credits

These dotfiles were inspired by [Anish Athalye's dotfiles](https://github.com/anishathalye/dotfiles), and this repository uses [Dotbot](https://github.com/anishathalye/dotbot) for installation.
