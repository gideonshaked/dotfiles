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
setopt autocd                   # If only directory path is entered, cd there

## History
setopt inc_append_history       # Append each command to HISTFILE as it runs
setopt share_history            # Share history live across all open terminals
setopt hist_reduce_blanks       # Trim redundant whitespace before saving
setopt histignorealldups        # If a new command duplicates an older one, drop the older
setopt histignorespace          # Don't save commands prefixed with a space

HISTSIZE=100000
SAVEHIST=100000

## Completion zstyles
fpath=(/opt/homebrew/share/zsh-completions $fpath)
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:git-checkout:*' sort false

## zsh-autocomplete - real-time fish-like type-ahead menu and history widgets.
## Owns compinit; must be sourced before any compdef calls.
## -u tells compinit to skip the security check on /opt/homebrew/share, which
## is intentionally group-writable for Homebrew.
zstyle '*:compinit' arguments -u
## Up-arrow history menu: many entries, scrollable with PgUp/PgDn.
zstyle ':autocomplete:history-search-backward:*' list-lines 2000
zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 16
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

## fzf-tab - replaces the Tab completion menu with an fzf picker + preview.
## Must load after compinit and before autosuggestions/syntax-highlighting.
source /opt/homebrew/share/fzf-tab/fzf-tab.zsh
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath 2>/dev/null'
zstyle ':fzf-tab:*' switch-group '<' '>'

## zsh-autosuggestions - inline grey ghost text from history (accept with Right-arrow).
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

## zsh-syntax-highlighting (must be LAST)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## Starship prompt
eval "$(starship init zsh)"
