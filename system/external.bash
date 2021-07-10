eval "$(thefuck --alias)"

export WORKON_HOME="$HOME/.virtualenvs"
export PROJECT_HOME="$HOME/git"
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source "$HOME/.local/bin/virtualenvwrapper.sh"

if command -v tab &> /dev/null
then
    source "$HOME/.local/share/tab/completion/tab.bash"
fi

eval "$(rbenv init -)"
