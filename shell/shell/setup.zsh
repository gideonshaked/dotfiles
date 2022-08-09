#
# Set up various programs
#

# Projects directory
export PROJECTS="$HOME/src"

# chmod
alias chmox="chmod +x"

# ls
alias ls="ls --color=auto"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
eval "$(dircolors -b)"

# cp
alias cp="cp -i"

# df
alias df="d -h"

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

# Virtualenvwrapper
export WORKON_HOME="$HOME/.virtualenvs"
export PROJECT_HOME="$PROJECTS"
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source "$HOME/.local/bin/virtualenvwrapper.sh"

# pre-commit fix (see https://github.com/PyCQA/isort/issues/1874)
export SETUPTOOLS_USE_DISTUTILS=stdlib

# Conda
# Inserted into ~/.bashrc by `conda init bash`
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
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
