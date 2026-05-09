<h1 align="center">Dotfiles</h1>

<p align="center">
  <a href="https://results.pre-commit.ci/latest/github/gideonshaked/dotfiles/master">
    <img alt="pre-commit.ci status" src="https://results.pre-commit.ci/badge/github/gideonshaked/dotfiles/master.svg">
  </a>
</p>

My personal dotfiles. In my opinion, [dotfiles are NOT meant to be forked](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/#dotfiles-are-not-meant-to-be-forked). That being said, this repository contains lots of useful things ([shell functions](https://github.com/gideonshaked/dotfiles/blob/master/term/zsh/functions.zsh), [scripts](https://github.com/gideonshaked/dotfiles/tree/master/bin), [gitconfig](https://github.com/gideonshaked/dotfiles/blob/master/git/gitconfig)) that you can add to your personal setup. As such, I encourage anyone that thinks these dotfiles look useful to try to understand them first and then copy the parts that stand out to them.

<p align="center">
  <a href="#install">Install</a> &bull;
  <a href="#contents">Contents</a> &bull;
  <a href="#credits">Credits</a>
</p>

## Install

### Full install (macOS)

```bash
git clone https://github.com/gideonshaked/dotfiles && cd dotfiles && ./install
```

### Minimal install (suitable for Linux and macOS)

A minimal installation intended primarily for headless linux servers.
Installs a portable bash config (prompt, aliases, functions), SSH config, agent configs, ccstatusline, user-local npx via nvm, and git aliases without overwriting the existing shell config.

```bash
git clone https://github.com/gideonshaked/dotfiles && cd dotfiles && ./install --minimal
```

## Contents

```text
├── agents      <- Claude and Codex config, skills, and agent plugin settings
├── bin         <- Personal scripts (s, dotfiles, git-nuke, sshkey, claude-validate)
├── clang       <- clang-format and clangd config
├── dotbot      <- Dotbot installer submodule
├── git         <- Git configuration files (aliases, custom formatting, etc.)
├── install.conf.yaml <- Dotbot install config for both full and minimal installs
├── manifest    <- Brewfile
├── scripts     <- Repo maintenance scripts
├── ssh         <- SSH config file
├── term        <- Shell configuration (zsh, bash, starship)
└── vscode      <- VS Code configuration and extensions list
```

## Dotfile management

After install, use the [`dotfiles`](./bin/dotfiles) utility:

```bash
dotfiles update              # Pull latest changes and run install
dotfiles update --minimal    # Same, but minimal install
dotfiles brewfile            # Update Homebrew package manifest
dotfiles dotbot              # Update Dotbot submodule
```

## Credits

These dotfiles were inspired by [Anish Athalye's dotfiles](https://github.com/anishathalye/dotfiles), and this repository uses [Dotbot](https://github.com/anishathalye/dotbot) for installation.
