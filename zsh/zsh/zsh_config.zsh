#
# Configure Zsh
#

## Options
setopt correct                  								# Auto correct mistakes
setopt extendedglob             								# Extended globbing. Allows using regular expressions with *
setopt nocaseglob               								# Case insensitive globbing
setopt rcexpandparam            								# Array expansion with parameters
setopt nocheckjobs              								# Don't warn about running processes when exiting
setopt numericglobsort          								# Sort filenames numerically when it makes sense
setopt nobeep                   								# No beep
setopt inc_append_history       								# Immediately append history instead of overwriting
setopt histignorealldups        								# If a new command is a duplicate, remove the older one
setopt autocd                   								# if only directory path is entered, cd there.
setopt inc_append_history       								# save commands are added to the history immediately, otherwise only when shell exits.
setopt histignorespace          								# Don't save commands that start with space

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
HISTSIZE=10000
SAVEHIST=10000

## Plugins
plugins=(
    gh                          # GitHub CLI autocomletion
    colorize                    # Colorize cat / less
    zsh-autosuggestions         # Suggest commands based on history
    zsh-wakatime                # WakaTime plugin
    sudo                        # Run previous command with sudo
    zsh-syntax-highlighting     # Syntax highlighting for terminal input
)

## Oh-My-Zsh
source "/Users/$(whoami)/.oh-my-zsh/oh-my-zsh.sh"

## Powerlevel10k
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
source "$HOME/.p10k.zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

## Zsh Syntax Highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
