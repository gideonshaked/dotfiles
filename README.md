# Dotfiles [![Lint](https://github.com/The-Kid-Gid/dotfiles/workflows/Lint/badge.svg)](https://github.com/The-Kid-Gid/dotfiles/actions?query=workflow%3ALint)

Title pretty much says it all. Because [dotfiles are meant to be forked](https://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked), you can and should fork this repository for your own purposes. Do be warned that although these should be completely capable of working on most machines, they are not tested or guaranteed to do so. This repository uses [Dotbot](https://github.com/anishathalye/dotbot) to install itself.

## Install

```bash
git clone --recursive https://github.com/The-Kid-Gid/dotfiles
cd dotfiles
./install  # Can also run with --verbose
```

## Structure

- [`bin/`](https://github.com/The-Kid-Gid/dotfiles/tree/master/bin): Contains some useful executables and is added to your `$PATH`.
- [`git/`](https://github.com/The-Kid-Gid/dotfiles/tree/master/git): Has `.gitconfig` as well as an alias file from [GitAlias/gitalias](https://github.com/GitAlias/gitalias) that is automatically included.
- [`system/`](https://github.com/The-Kid-Gid/dotfiles/tree/master/system): Every bash file sourced by `.bashrc`.
- [`vscode/`](https://github.com/The-Kid-Gid/dotfiles/tree/master/vscode): VS Code `settings.json` as well as an `extensions.txt` file that contains every VS Code extension I have installed. These are automatically installed when you run `./install`.
- [`starship.toml`](https://github.com/The-Kid-Gid/dotfiles/blob/master/starship.toml): The configuration file for [Starship](https://starship.rs) prompt.
