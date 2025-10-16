# Dotfiles

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/gideonshaked/dotfiles/master.svg)](https://results.pre-commit.ci/latest/github/gideonshaked/dotfiles/master)

- [Install](#install)
- [Directory Structure](#directory-structure)
- [Credits](#credits)

My personal dotfiles. In my opinion, [dotfiles are NOT meant to be forked](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/#dotfiles-are-not-meant-to-be-forked). That being said, this repository contains lots of useful things ([shell functions](https://github.com/gideonshaked/dotfiles/blob/master/term/zsh/functions.zsh), [scripts](https://github.com/gideonshaked/dotfiles/tree/master/bin), [gitconfig](https://github.com/gideonshaked/dotfiles/blob/master/git/gitconfig)) that you can add to your personal setup. As such, I encourage anyone that thinks these dotfiles look useful to try to understand them first and then copy the parts that stand out to them.

## Install

Download this repository.

```bash
git clone --recursive https://github.com/gideonshaked/dotfiles
```

Run the install script.

```bash
cd dotfiles
./install
```

You can update with the provided update function.

```bash
dfu
```

## Directory Structure

```text
├── clang       <- clang-format and clangd config
├── git         <- Git configuration files (aliases, custom formatting, etc.)
├── bin         <- Personal scripts
├── ssh         <- SSH config file
├── manifest    <- Brewfile
├── vscode      <- VS Code configuration and extensions list
└── term        <- Zsh/Starship configuration
```

## Credits

These dotfiles were inspired by [Anish Athalye's dotfiles](https://github.com/anishathalye/dotfiles), and this repository uses [Dotbot](https://github.com/anishathalye/dotbot) for installation.
