#
# Things too long for an alias and too short for a standalone script
#

# Make a new directory and enter it
mk() {
    mkdir "$@" && cd "$@"
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

# Show the fixed nubio Cloudflare tunnel hostname
nubio() {
    if [[ $# -gt 0 ]]; then
        echo "nubio now uses a fixed hostname in ~/.ssh/config"
        return 1
    fi
    grep -A4 'Host nubio' ~/.ssh/config | awk '$1 == "HostName" {
        print $2
        exit
    }'
}

# Update all Claude Code marketplaces and plugins
cplu() {
    claude plugins marketplace update
    local plugins=($(claude plugins list --json | jq -r '.[].id'))
    if [[ ${#plugins[@]} -eq 0 ]]; then
        echo "No plugins installed"
        return 1
    fi
    for plugin in "${plugins[@]}"; do
        claude plugin update "$plugin"
    done
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
