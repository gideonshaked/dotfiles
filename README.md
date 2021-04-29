# Dotfiles 

[![Test](https://github.com/The-Kid-Gid/dotfiles/workflows/Test/badge.svg)](https://github.com/The-Kid-Gid/dotfiles/actions?query=workflow%3ATest)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/The-Kid-Gid/dotfiles/master.svg)](https://results.pre-commit.ci/latest/github/The-Kid-Gid/dotfiles/master)
![GitHub repo size](https://img.shields.io/github/repo-size/The-Kid-Gid/dotfiles?color=orange)

My personal dotfiles. In my opinion, [dotfiles are NOT meant to be forked](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/#dotfiles-are-not-meant-to-be-forked). That being said, this repository contains lots of useful things ([functions](https://github.com/The-Kid-Gid/dotfiles/blob/master/system/functions.bash), [scripts](https://github.com/The-Kid-Gid/dotfiles/blob/master/bin/covid-stats), [gitconfig](https://github.com/The-Kid-Gid/dotfiles/blob/master/git/gitconfig)) that you can add to your personal setup. As such, I encourage anyone that thinks these dotfiles look useful to try to understand them first and then copy the parts that stand out to them.

This repository uses [Dotbot](https://github.com/anishathalye/dotbot) for installation.

## Install

Download this repository.

```bash
git clone --recursive https://github.com/The-Kid-Gid/dotfiles
cd dotfiles
```

Choose a profile to install. Each [profile](https://github.com/The-Kid-Gid/dotfiles/tree/master/meta/profiles) installs a certain list of configs. [Each of the configs](https://github.com/The-Kid-Gid/dotfiles/tree/master/meta/configs) corresponds to a certain topic (example: `git`, which symlinks `gitconfig` and `gitaliases.txt`).

```bash
./install-profile <gideon-laptop, phobos, deimos>
```

Or you can install individual configs.

```bash
./install-standalone <bin, brew, git, pip, starship, system, vscode>
```

## Structure

- [`aws/`](https://github.com/The-Kid-Gid/dotfiles/tree/master/aws): AWS config file.
- [`bin/`](https://github.com/The-Kid-Gid/dotfiles/tree/master/bin): Contains some useful executables and is added to your `$PATH`.
- [`completions/`](https://github.com/The-Kid-Gid/dotfiles/tree/master/completions): Has completion scripts for custom functions/scripts that are automatically sourced.
- [`git/`](https://github.com/The-Kid-Gid/dotfiles/tree/master/git): Has `.gitconfig` as well as an alias file from [GitAlias/gitalias](https://github.com/GitAlias/gitalias) that is automatically included.
- [`manifest/`](https://github.com/The-Kid-Gid/dotfiles/tree/master/manifest): Has pip `requirements.txt` and `Brewfile` for dev tools.
- [`system/`](https://github.com/The-Kid-Gid/dotfiles/tree/master/system): Every bash file sourced by `.bashrc`.
- [`vscode/`](https://github.com/The-Kid-Gid/dotfiles/tree/master/vscode): VS Code `settings.json` as well as an `extensions.txt` file that contains every VS Code extension I have installed. These are automatically installed when you run `./install`.
- [`starship.toml`](https://github.com/The-Kid-Gid/dotfiles/blob/master/starship.toml): The configuration file for [Starship](https://starship.rs) prompt.

## Credits

These dotfiles were inspired by [Anish Athalye's dotfiles](https://github.com/anishathalye/dotfiles).
