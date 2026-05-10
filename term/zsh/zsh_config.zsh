#
# Configure Zsh
#

## Options
setopt extendedglob             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob               # Case insensitive globbing
setopt rcexpandparam            # Array expansion with parameters
setopt nocheckjobs              # Don't warn about running processes when exiting
setopt numericglobsort          # Sort filenames numerically when it makes sense
setopt nobeep                   # No beep
setopt inc_append_history       # Immediately append history instead of overwriting
setopt histignorealldups        # If a new command is a duplicate, remove the older one
setopt autocd                   # if only directory path is entered, cd there.
setopt histignorespace          # Don't save commands that start with space

HISTSIZE=10000
SAVEHIST=10000

## Completion configuration (must run before compinit)
fpath=(/opt/homebrew/share/zsh-completions $fpath)

# Multi-stage matcher: exact, case-insensitive, partial-word, then approximate
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Required by fzf-tab so it can capture the unambiguous prefix instead of zsh's own menu
zstyle ':completion:*' menu no

## compinit (-u skips the security check on /opt/homebrew/share, which is
## intentionally group-writable for Homebrew)
autoload -Uz compinit && compinit -u

## fzf-tab - replaces tab menu with fzf + preview pane.
## Must load after compinit and before autosuggestions/syntax-highlighting.
source /opt/homebrew/share/fzf-tab/fzf-tab.zsh

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath 2>/dev/null'
zstyle ':fzf-tab:*' switch-group '<' '>'

## zsh-autosuggestions (after fzf-tab)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

## zsh-syntax-highlighting (must be LAST)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## Starship prompt
eval "$(starship init zsh)"
