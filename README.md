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
git clone https://github.com/gideonshaked/dotfiles && cd dotfiles && ./install
```

Only `git` and `python3` are needed to create the symlinks; both ship with
macOS and every Linux this targets. Everything else the configuration depends
on is installed by the run itself, including Claude Code.

### Profiles

A profile is an ordered list of modules under `setup/modules/`, passed to
Dotbot as several `-c` arguments. The chosen profile is remembered in
`~/.dotfiles-profile`, so a later bare `./install` repeats it.

| Profile | For | Modules |
|---------|-----|---------|
| `personal` | personal Mac (default) | settings-personal, core, macos |
| `work` | work Mac | settings-work, core, macos |
| `server` | headless Linux | settings-personal, core |

```bash
./install --profile server   # headless Linux: shell, git, SSH, Claude, no macOS bits
./install --list             # show profiles and their modules
./install --dry-run          # report what would change, touch nothing
```

The install owns `~/bin`; an existing `~/bin` is backed up first.

macOS gets its packages from Homebrew and the Brewfile. Linux cannot use
Homebrew, which needs root for the only prefix with prebuilt bottles, so the
tools it needs are fetched as released binaries under `$HOME` and no step
requires sudo.

## Contents

```text
├── agents      <- Claude config: memory, skills, commands, hooks, per-profile settings
├── bin         <- Commands meant to be typed (s, dotfiles)
├── dotbot      <- Dotbot installer submodule
├── git         <- Git configuration (gitconfig, global gitignore)
├── manifest    <- Brewfile: what this repo's configuration depends on
├── setup       <- The installer: modules/ compose profiles, scripts/ run after linking
├── ssh         <- SSH config; host files are gitignored and stay out of this repo
├── terminal    <- Shell configuration (one shellrc for zsh and bash, starship)
└── vscode      <- VS Code settings, keybindings and extension list
```

## Dotfile management

After install, use the [`dotfiles`](./bin/dotfiles) utility:

```bash
dotfiles update              # Pull latest changes and run install
dotfiles brew                # Install everything in the manifest
dotfiles dotbot              # Update Dotbot submodule
```

## Credits

These dotfiles were inspired by [Anish Athalye's dotfiles](https://github.com/anishathalye/dotfiles), and this repository uses [Dotbot](https://github.com/anishathalye/dotbot) for installation.
