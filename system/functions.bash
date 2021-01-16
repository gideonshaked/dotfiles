#
# Things too long for an alias and too short for a standalone script
#


# Make a new directory and enter it.
mk() {
    mkdir "$@" && cd "$@"
}

# Quickly enter a project directory.
c() {
    cd "$PROJECTS/$1"
}

# Quickly open VSCode in a project directory
v() {
    code "$PROJECTS/$1"
}

# Open program silently and without making it dependent on an open terminal
open() {
    nohup "$@" &>/dev/null &
}

# Execute a command in a specific directory
xin() {
    cd "${1}" && shift && "${@}"
}

# Add current conda env to jupyter notebook
add2jupyter() {
    conda install -n "$CONDA_DEFAULT_ENV" ipykernel
    python -m ipykernel install --user --name "$CONDA_DEFAULT_ENV" --display-name "Python ($CONDA_DEFAULT_ENV)"
}

# Update dotfiles
dfu() {
    cd "$PROJECTS/dotfiles" && git pull --ff-only && ./install-profile "$(hostname)"
}

# Print current directory following symlinks
here() {
    local loc
    if [ "$#" -eq 1 ]; then
        loc=$(realpath "$1")
    else
        loc=$(realpath ".")
    fi
    ln -sfn "${loc}" "$HOME/.shell.here"
    echo "here -> $(readlink $HOME/.shell.here)"
}

# Remove from PATH
path_remove() {
    PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}

# Append to PATH
path_append() {
    path_remove "$1"
    PATH="${PATH:+"$PATH:"}$1"
}

# Prepend to PATH
path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}
