#
# Configure external tools
#

# Projects directory
export PROJECTS="$HOME/src"

# Make topical directories available as environment variables
source "$HOME/.config/user-dirs.dirs"
export XDG_DESKTOP_DIR
export XDG_DOWNLOAD_DIR
export XDG_TEMPLATES_DIR
export XDG_PUBLICSHARE_DIR
export XDG_DOCUMENTS_DIR
export XDG_MUSIC_DIR
export XDG_PICTURES_DIR
export XDG_VIDEOS_DIR

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
# Inserted into ~/.zshrc by `conda init zsh`
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
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

# Make Kitty play nicely with SSH (see https://github.com/kovidgoyal/kitty/issues/1613#issuecomment-734753530)
if test "$TERM" = "xterm-kitty"
then
    alias ssh="kitty +kitten ssh"
fi
