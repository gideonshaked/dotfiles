#
# Useful environment variables
#

export DEV="$HOME/Documents/personal/dev"
export DOTFILES="$HOME/Documents/personal/dev/dotfiles"

export CV="$HOME/Documents/personal/dev/resume"
export WEBSITE="$HOME/Documents/personal/dev/gideonshaked.github.io"

# Micro
export MICRO_TRUECOLOR=1
export EDITOR="micro"

# GCC
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Make GPG work for git signing
# https://gist.github.com/repodevs/a18c7bb42b2ab293155aca889d447f1b
export GPG_TTY=$(tty)

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-R

# Bun
export BUN_INSTALL="$HOME/.bun"

# Private local environment, such as API keys.
[ -f "$HOME/.zsh/secrets.zsh" ] && source "$HOME/.zsh/secrets.zsh"
