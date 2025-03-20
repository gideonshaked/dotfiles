#
# Things too long for an alias and too short for a standalone script
#

# Open a class folder
class() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: class <class_name>"
        return 1
    fi

    local class_name="$1"
    local class_dir="$CLASSES/$class_name"

    if [[ ! -d "$class_dir" ]]; then
        echo "Class directory $class_dir does not exist."
        return 1
    fi

    cd "$class_dir" || return
}

# Make a new directory and enter it
mk() {
    mkdir "$@" && cd "$@"
}

# Quickly open VS code in the current directory
c() {
    code $(pwd)
}

# List everything in the current directory with nice defaults
d() {
    du -h -d 1  "$@" | sort --human-numeric-sort --reverse
}

# Start programs silently and without making them dependent on an open terminal
start() {
    nohup "$@" > /dev/null 2> /dev/null
}

# Execute a command in a specific directory
xin() {
    cd "$1"
    shift
    "${@}"
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

# Update dotfiles
dfu() {
    cd "$DEV/dotfiles" && git pull --ff-only && ./install
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

# Update file that tracks installed Homebrew packages
update_brewfile() {
    brew bundle dump --all --force --file "$DOTFILES/manifest/Brewfile"
}

# Update Dotbot
update_dotbot() {
    cd $DOTFILES && git submodule update --init --recursive
}
