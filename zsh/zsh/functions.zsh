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

# Quickly open VS Code in a project directory
v() {
    code "$PROJECTS/$1"
}

# List everything in the current directory with nice defaults
d() {
    du --human-readable --all --max-depth 1 "$@" | sort --human-numeric-sort --reverse
}

# Open program silently and without making it dependent on an open terminal
open() {
    nohup "$@" &>/dev/null &
}

# Execute a command in a specific directory
xin() {
    original_dir=$(pwd)
    cd "$1"
    shift
    "${@}"
    cd "$original_dir"
}

# Add current conda env to jupyter notebook
addtojupyter() {
    python -m pip install ipykernel
    python -m ipykernel install --user --name "$CONDA_DEFAULT_ENV" --display-name "Python ($CONDA_DEFAULT_ENV)"
}

# Remove current conda env from jupyter notebook
removefromjupyter() {
    rm ~/.local/share/jupyter/kernels/test/ -rf
}

# Create file and directories on path to file if none exist
tp() {
    mkdir -p "${1%/*}" && touch "$1"
}

# Get proper word count from LaTeX doc
latexwc() {
    if [[ $# -eq 2 ]]; then
        wc_opts="$2"
    else
        wc_opts="-w"
    fi
    detex "$1" | wc "$wc_opts"
}

# Run both server management programs
servermg() {
    echo "Running 'aup'"
    echo
    aup
    echo
    echo "Running 'dup'"
    echo
    dup
}

# Start Virtualbox VM
startvm() {
    vboxmanage startvm "$1" --type headless
}

# Stop Virtualbox VM
stopvm() {
    vboxmanage controlvm "$1" acpipowerbutton
}

# Check Virtualbox VM status
vmstatus() {
    vboxmanage showvminfo "$1" | grep --color=never State
}

# Clear downloads
clrdl() {
    setopt localoptions rmstarsilent
    rm $HOME/tmp/dl/* -rf
}

# Clear bluetooth transfers
clrkde() {
    setopt localoptions rmstarsilent
    rm $HOME/tmp/kdeconnect/* -rf
}

# Clear misc temp files
clrmisc() {
    setopt localoptions rmstarsilent
    rm $HOME/tmp/misc/* -rf
}

# Clear temporary files
clrtmp() {
    clrdl
    clrkde
    clrmisc
}

## Dotfile management ##

# Update dotfiles
dfu() {
    cd "$PROJECTS/dotfiles" && git pull --ff-only && ./install
}

# Update VS Code extensions list
upext() {
    xin "$PROJECTS/dotfiles" ./script/code-export-ext && git reset > /dev/null && git stage "vscode/extensions.txt" > /dev/null && git commit -m "Update extensions list" && git push
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
