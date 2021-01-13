eval "$(thefuck --alias)"

export WORKON_HOME="$HOME/.virtualenvs"
export PROJECT_HOME="$HOME/git"
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source "$HOME/.local/bin/virtualenvwrapper.sh"

source "$HOME/.local/bin/condawrapper.sh"