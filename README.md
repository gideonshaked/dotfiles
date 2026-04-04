# Dotfiles

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/gideonshaked/dotfiles/master.svg)](https://results.pre-commit.ci/latest/github/gideonshaked/dotfiles/master)

My personal dotfiles. In my opinion, [dotfiles are NOT meant to be forked](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/#dotfiles-are-not-meant-to-be-forked). That being said, this repository contains lots of useful things ([shell functions](https://github.com/gideonshaked/dotfiles/blob/master/term/zsh/functions.zsh), [scripts](https://github.com/gideonshaked/dotfiles/tree/master/bin), [gitconfig](https://github.com/gideonshaked/dotfiles/blob/master/git/gitconfig)) that you can add to your personal setup. As such, I encourage anyone that thinks these dotfiles look useful to try to understand them first and then copy the parts that stand out to them.

<p align="center">
  <a href="#install">Install</a> &bull;
  <a href="#contents">Contents</a> &bull;
  <a href="#notes">Notes</a> &bull;
  <a href="#credits">Credits</a>
</p>

## Install

### Full install (macOS)

```bash
git clone https://github.com/gideonshaked/dotfiles && cd dotfiles && ./install
```

### Minimal install (suitable for Linux and macOS)

A minimal installation intended primarily for headless linux servers.
Installs a portable bash config (prompt, aliases, functions), SSH config, Claude Code + ccstatusline, and git aliases without overwriting the existing shell config.

```bash
git clone https://github.com/gideonshaked/dotfiles && cd dotfiles && ./install --minimal
```

## Contents

```text
├── bin         <- Personal scripts (s, dotfiles, git-nuke, sshkey, claude-validate)
├── claude      <- Claude Code settings, ccstatusline config, and claude-skills submodule
├── clang       <- clang-format and clangd config
├── git         <- Git configuration files (aliases, custom formatting, etc.)
├── manifest    <- Brewfile
├── ssh         <- SSH config file
├── term        <- Shell configuration (zsh, bash, starship)
└── vscode      <- VS Code configuration and extensions list
```

## Notes

### `claude-skills` private submodule

The `claude/claude-skills` submodule is a private repo containing my global `CLAUDE.md` and skills. 
The install script handles not being able to access the skills repo gracefully, so it shouldn't be an issue if you install this repo and you're not me ;).

### SSH wrapper (`s`)

The [`s`](./bin/s) script is an SSH wrapper that uses the Kitty SSH kitten when available and falls back to plain ssh otherwise. It supports optional dotfiles management on remote hosts:

```bash
s host                          # Just SSH (default)
s --install-dotfiles host       # Install dotfiles (or update if present)
s --reinstall-dotfiles host     # Delete and reinstall from scratch
s --update-dotfiles host        # Pull latest and re-run install
```

### Dotfile management

After install, use the [`dotfiles`](./bin/dotfiles) utility:

```bash
dotfiles update              # Pull latest changes and run install
dotfiles update --minimal    # Same, but minimal install
dotfiles brewfile            # Update Homebrew package manifest
dotfiles dotbot              # Update Dotbot submodule
dotfiles skills              # Update Claude skills submodule
```

## Credits

These dotfiles were inspired by [Anish Athalye's dotfiles](https://github.com/anishathalye/dotfiles), and this repository uses [Dotbot](https://github.com/anishathalye/dotbot) for installation.
