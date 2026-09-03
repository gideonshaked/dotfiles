#
# ~/.shell-common: POSIX shell configuration shared by zsh and bash.
# Sourced by both ~/.zshrc and ~/.bashrc. Must stay POSIX-compatible:
# no arrays, no [[ ]], no zsh globs, no bashisms.
#

# Only run once per shell
[ -n "$__DOTFILES_COMMON" ] && return
__DOTFILES_COMMON=1

## ── Environment ───────────────────────────────────────────────────────────

export DEV="$HOME/Documents/personal/dev"
export DOTFILES="$DEV/dotfiles"
export CV="$DEV/resume"
export WEBSITE="$DEV/gideonshaked.github.io"

export EDITOR="micro"
export MICRO_TRUECOLOR=1
export BUN_INSTALL="$HOME/.bun"
export ENABLE_LSP_TOOLS=1        # Claude Code LSP tools

# Required for git commit signing
GPG_TTY=$(tty)
export GPG_TTY

# Colored man pages
export LESS=-R
export LESS_TERMCAP_mb=$(printf '\033[01;32m')
export LESS_TERMCAP_md=$(printf '\033[01;32m')
export LESS_TERMCAP_me=$(printf '\033[0m')
export LESS_TERMCAP_se=$(printf '\033[0m')
export LESS_TERMCAP_so=$(printf '\033[01;47;34m')
export LESS_TERMCAP_ue=$(printf '\033[0m')
export LESS_TERMCAP_us=$(printf '\033[01;36m')

## ── PATH ──────────────────────────────────────────────────────────────────

# Prepend a directory if it exists and is not already present.
_path_prepend() {
    [ -d "$1" ] || return 0
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1${PATH:+:$PATH}" ;;
    esac
}

_path_prepend /opt/homebrew/bin
_path_prepend "$BUN_INSTALL/bin"
_path_prepend "$HOME/.cargo/bin"
_path_prepend "$HOME/.local/bin"
_path_prepend "$HOME/bin"
export PATH

## ── Aliases ───────────────────────────────────────────────────────────────

alias ls="ls --color=auto"
alias df="df -h"

## ── SSH agent ─────────────────────────────────────────────────────────────
## Reuse an existing agent rather than spawning one per shell.

if [ -z "$SSH_AUTH_SOCK" ] && command -v ssh-agent >/dev/null 2>&1; then
    eval "$(ssh-agent -s)" >/dev/null 2>&1
    find "$HOME/.ssh" -maxdepth 1 -type f \
        ! -name '*.pub' ! -name 'config' ! -name 'known_hosts*' \
        -exec ssh-add {} + >/dev/null 2>&1
fi

## ── Secrets ───────────────────────────────────────────────────────────────
## API keys and anything else that must never be committed.

[ -f "$HOME/.shell-secrets" ] && . "$HOME/.shell-secrets"
