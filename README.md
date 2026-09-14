<h1 align="center">Dotfiles</h1>

<p align="center">
  <a href="https://github.com/gideonshaked/dotfiles/actions/workflows/lint.yml">
    <img alt="lint status" src="https://github.com/gideonshaked/dotfiles/actions/workflows/lint.yml/badge.svg">
  </a>
</p>

My personal dotfiles. In my opinion, [dotfiles are NOT meant to be forked](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/#dotfiles-are-not-meant-to-be-forked). That being said, this repository contains lots of useful things ([shell config](https://github.com/gideonshaked/dotfiles/blob/master/terminal/shellrc), [scripts](https://github.com/gideonshaked/dotfiles/tree/master/bin), [gitconfig](https://github.com/gideonshaked/dotfiles/blob/master/git/gitconfig)) that you can add to your personal setup. As such, I encourage anyone that thinks these dotfiles look useful to try to understand them first and then copy the parts that stand out to them.

<p align="center">
  <a href="#install">Install</a> &bull;
  <a href="#contents">Contents</a> &bull;
  <a href="#credits">Credits</a>
</p>

## Install

```bash
git clone https://github.com/gideonshaked/dotfiles && cd dotfiles && ./install --profile <profile>
```

Only `git` and `python3` are needed to run the install.
Everything else the configuration depends on is installed by the run itself, including Claude Code.

Profiles are different versions of my dotfiles, so that they can be used across multiple differing machines (personal laptop, work laptop, linux servers, etc).
The chosen profile is remembered in `~/.dotfiles-profile`, so a later bare `./install` reinstalls the originally installed profile.

| Profile | For | Modules |
|---------|-----|---------|
| `personal` | personal Mac (default) | settings-personal, core, macos |
| `work` | work Mac | settings-work, core, macos |
| `server` | headless Linux | settings-personal, core |

## Dotfile management

After install, use the [`dotfiles`](./bin/dotfiles) utility:

```bash
dotfiles update              # Pull latest changes and run install
dotfiles brew                # Install everything in the manifest
dotfiles dotbot              # Update Dotbot submodule
```

## Contents

```text
├── agents      <- Claude config: memory, skills, commands, hooks, per-profile settings
├── bin         <- Commands meant to be typed (s, dotfiles)
├── dotbot      <- Dotbot installer submodule
├── git         <- Git configuration (gitconfig, global gitignore)
├── manifest    <- Brewfile: what this repo's configuration depends on
├── setup       <- The installer: modules/ compose profiles, scripts/ run after linking
├── ssh         <- SSH config; host files are gitignored and stay out of this repo
├── terminal    <- Shell and terminal config (one shellrc for zsh and bash, starship, cmux)
└── vscode      <- VS Code settings, keybindings and extension list
```

## Credits

These dotfiles were inspired by [Anish Athalye's dotfiles](https://github.com/anishathalye/dotfiles), and this repository uses [Dotbot](https://github.com/anishathalye/dotbot) for installation.
