#
# Useful bash aliases
#

alias dns="( nmcli dev list || nmcli dev show ) 2>/dev/null | grep DNS"

alias python="python3"
alias pip="pip3"

alias sloc="git ls-files \"*.py\" \"*.java\" \"*.sh\" \"*.bash\" \"*.ps1\" \"*.js\" | xargs wc -l"

alias chmox="chmod +x"

alias clip="xclip -selection c"

alias bat="batcat"

alias oops="fuck"

alias batt="upower -i $(upower -e | grep BAT) | grep --color=never -E 'state|to\ full|to\ empty|percentage'"

alias ls="ls --color=auto"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

alias a@d="ssh administrator@deimos"
alias a@p="ssh administrator@phobos"
