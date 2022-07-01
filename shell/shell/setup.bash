#
# Set up various programs
#

# Projects directory
export PROJECTS="$HOME/src"

# Micro
export MICRO_TRUECOLOR=1
export EDITOR="micro"

# Rendermark
export RENDERMARK_DEFAULT_FILEPATH="README.md"

# GCC
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Virtualenvwrapper
export WORKON_HOME="$HOME/.virtualenvs"
export PROJECT_HOME="$PROJECTS"
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/bin/virtualenvwrapper.sh

# The Fuck
eval "$(thefuck --alias)"

# Issue with pre-commit (see https://github.com/PyCQA/isort/issues/1874)
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
conda deactivate
