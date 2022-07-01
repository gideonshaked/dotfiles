# Dotfiles 

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/not-stirred/dotfiles/master.svg)](https://results.pre-commit.ci/latest/github/not-stirred/dotfiles/master)
![GitHub repo size](https://img.shields.io/github/repo-size/not-stirred/dotfiles?color=orange)

My personal dotfiles. In my opinion, [dotfiles are NOT meant to be forked](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/#dotfiles-are-not-meant-to-be-forked). That being said, this repository contains lots of useful things ([shell functions](https://github.com/not-stirred/dotfiles/blob/master/shell/shell/functions.bash), [scripts](https://github.com/not-stirred/dotfiles/blob/master/bin/covid-stats), [gitconfig](https://github.com/not-stirred/dotfiles/blob/master/git/gitconfig)) that you can add to your personal setup. As such, I encourage anyone that thinks these dotfiles look useful to try to understand them first and then copy the parts that stand out to them.

This repository uses [Dotbot](https://github.com/anishathalye/dotbot) for installation.

## Install

Download this repository.

```bash
git clone --recursive https://github.com/not-stirred/dotfiles
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

```
├── aws         <- AWS config file
├── bin         <- Personal executable scripts written in Bash and Python
├── git         <- Git configuration files (aliases, custom formatting, etc.)
├── jupyter     <- Jupyter Notebook configuration
├── manifest    <- requirements.txt with dev tools
├── shell       <- Shell startup files
├── term        <- Starship and Hyper configuration
└── vscode      <- VS Code configuration and extensions list
```

## Credits

These dotfiles were inspired by [Anish Athalye's dotfiles](https://github.com/anishathalye/dotfiles).
