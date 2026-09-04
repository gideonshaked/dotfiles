<h1 align="center">Dotfiles</h1>

<p align="center">
  <a href="https://results.pre-commit.ci/latest/github/gideonshaked/dotfiles/master">
    <img alt="pre-commit.ci status" src="https://results.pre-commit.ci/badge/github/gideonshaked/dotfiles/master.svg">
  </a>
</p>

My personal dotfiles. In my opinion, [dotfiles are NOT meant to be forked](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/#dotfiles-are-not-meant-to-be-forked). That being said, this repository contains lots of useful things ([shell config](https://github.com/gideonshaked/dotfiles/blob/master/terminal/shellrc), [scripts](https://github.com/gideonshaked/dotfiles/tree/master/bin), [gitconfig](https://github.com/gideonshaked/dotfiles/blob/master/git/gitconfig)) that you can add to your personal setup. As such, I encourage anyone that thinks these dotfiles look useful to try to understand them first and then copy the parts that stand out to them.

<p align="center">
  <a href="#install">Install</a> &bull;
  <a href="#contents">Contents</a> &bull;
  <a href="#credits">Credits</a>
</p>

## Install

### Full install (macOS)

#### Prerequisites

- `git`
- `python3`
- `npx`
- `jq`
- `uv`
- Claude Code

#### Install command

```bash
git clone https://github.com/gideonshaked/dotfiles && cd dotfiles && ./install
```

### Profiles

A profile is a list of modules under `setup/modules/`. The chosen profile is remembered in
`~/.dotfiles-profile`, so a later bare `./install` repeats it.

| Profile | For | Modules |
|---------|-----|---------|
| `personal` | personal Mac (default) | core, macos, agents, agents-personal |
| `work` | work Mac | core, macos, agents, agents-work |
| `server` | headless Linux | core, agents, agents-personal |

```bash
./install --profile server   # headless server: bash, SSH, git, agent config, no macOS bits
./install --list             # show profiles and their modules
```

The install owns `~/bin`; an existing `~/bin` is backed up first.

## Contents

```text
├── agents      <- Claude config: memory, skills, commands, per-profile settings
├── bin         <- Commands meant to be typed (s, dotfiles)
├── dotbot      <- Dotbot installer submodule
├── git         <- Git configuration (gitconfig, global gitignore)
├── modules     <- Dotbot config, one file per module; profiles compose these
├── manifest    <- Brewfile
├── scripts     <- Repo maintenance scripts and install helpers
├── ssh         <- SSH config file
├── term        <- Shell configuration (one shellrc for zsh and bash, starship)
└── vscode      <- VS Code configuration and extensions list
```

## Dotfile management

After install, use the [`dotfiles`](./bin/dotfiles) utility:

```bash
dotfiles update              # Pull latest changes and run install
dotfiles brew                # Install all packages from the manifest
dotfiles brew --only-plugins # Install just the tracked VS Code extensions
dotfiles dotbot              # Update Dotbot submodule
```

## Credits

These dotfiles were inspired by [Anish Athalye's dotfiles](https://github.com/anishathalye/dotfiles), and this repository uses [Dotbot](https://github.com/anishathalye/dotbot) for installation.
