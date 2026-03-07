#
# Useful aliases
#

# chmod
alias chmox="chmod +x"

# ls
alias ls="ls --color=auto"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

# cp
alias cp="cp -i"

# df
alias df="df -h"

# Make Kitty play nicely with SSH (see https://github.com/kovidgoyal/kitty/issues/1613#issuecomment-734753530)
if test "$TERM" = "xterm-kitty"
then
    alias s="kitty +kitten ssh"
fi

# gcloud
alias gc=gcloud

# Claude
alias claude="claude --dangerously-skip-permissions"
