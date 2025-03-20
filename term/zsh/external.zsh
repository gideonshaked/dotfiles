#
# Configure external tools
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

# free
alias free="free -m"

# Micro
export MICRO_TRUECOLOR=1
export EDITOR="micro"

# Rendermark
export RENDERMARK_DEFAULT_FILEPATH="README.md"

# GCC
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# The Fuck
eval "$(thefuck --alias)"

# rbenv
eval "$(rbenv init - zsh)"

# pre-commit fix (see https://github.com/PyCQA/isort/issues/1874)
export SETUPTOOLS_USE_DISTUTILS=stdlib

# Conda
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
conda deactivate  # (not inserted)

# Mamba
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/mambaforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/mambaforge/base/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/mamba.sh" ]; then
    . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<
conda deactivate  # (not inserted)

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-R

# Wakatime
export ZSH_WAKATIME_PROJECT_DETECTION=true

# Make Kitty play nicely with SSH (see https://github.com/kovidgoyal/kitty/issues/1613#issuecomment-734753530)
if test "$TERM" = "xterm-kitty"
then
    alias s="kitty +kitten ssh"
fi

# Make GPG work for git signing
# https://gist.github.com/repodevs/a18c7bb42b2ab293155aca889d447f1b
export GPG_TTY=$(tty)

# Configure ruby
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh

# SSH agent
eval $(ssh-agent) > /dev/null
ssh-add ~/.ssh/^(config|known_hosts|known_hosts.old|*.pub) &> /dev/null

# Copilot in terminal
eval "$(gh copilot alias -- zsh)"
