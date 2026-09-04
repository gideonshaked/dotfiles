# shellcheck shell=bash
#
# Dotbot runs shell steps without a login shell, so they inherit whatever PATH
# the caller had. On a machine where install-packages has just installed
# Homebrew, that PATH predates it and nothing brew provides is findable.
#
# Both Homebrew prefixes are listed because the Linux one differs from macOS,
# ~/.local/bin because the Claude Code native installer puts claude there.
PATH="${HOME}/.local/bin:${HOME}/.bun/bin:${HOME}/.cargo/bin:/opt/homebrew/bin:/usr/local/bin:/home/linuxbrew/.linuxbrew/bin:${PATH}"
export PATH
