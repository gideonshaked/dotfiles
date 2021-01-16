#
# Useful bash aliases
#

alias a@d='ssh administrator@deimos'
alias a@p='ssh administrator@phobos'

alias update='sudo apt update -y && sudo apt upgrade -y'

alias dns='( nmcli dev list || nmcli dev show ) 2>/dev/null | grep DNS'

alias bwbackup='bw-user-backup'

alias python='python3'

alias wscli="java $HOME/.local/bin/wscli/src/wscli.java"

alias sloc="git ls-files \"*.py\" \"*.java\" \"*.sh\" \"*.bash\" \"*.ps1\" \"*.js\" | xargs wc -l"

alias bd=". bd -si"

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias chmox="chmod +x"
