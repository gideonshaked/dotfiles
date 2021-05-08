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

# List everything in the current directory with nice defaults
d() {
    du --human-readable --all --max-depth 1 $@ | sort --human-numeric-sort --reverse
}

# Open program silently and without making it dependent on an open terminal
open() {
    nohup "$@" &>/dev/null &
}

# Execute a command in a specific directory
xin() {
    cd "${1}" && shift && "${@}"
}

# Update vscode extensions list
upext() {
    xin "$PROJECTS/dotfiles" ./script/code-export-ext && git reset > /dev/null && git stage "vscode/extensions.txt" > /dev/null && git commit -m "Update extensions list" && git push
}

# Add current conda env to jupyter notebook
add2jupyter() {
    conda install -n "$CONDA_DEFAULT_ENV" ipykernel
    python -m ipykernel install --user --name "$CONDA_DEFAULT_ENV" --display-name "Python ($CONDA_DEFAULT_ENV)"
}

# Create file and directories on path to file if none exist
tp() {
    mkdir -p "${1%/*}" && touch "$1"
}

# Update dotfiles
dfu() {
    cd "$PROJECTS/dotfiles" && git pull --ff-only && ./install-profile "$(hostname)"
}

# Apt update servers
apt-servers() {
    UPDATE="sudo apt-get update -y && sudo apt-get upgrade -y"
    echo "-----phobos-----"
    ssh administrator@phobos "$UPDATE"
    echo
    echo "-----deimos-----"
    ssh administrator@deimos "$UPDATE"
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
