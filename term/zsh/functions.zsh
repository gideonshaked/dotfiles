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

# Update the nubio Cloudflare tunnel subdomain in SSH config
nubio() {
    if [[ -z "$1" ]]; then
        grep -A1 'Host nubio' ~/.ssh/config | grep HostName | awk '{print $2}'
        return
    fi
    local hostname
    if [[ "$1" == *".trycloudflare.com"* ]]; then
        hostname="${1#*://}"
        hostname="${hostname%%/*}"
    else
        hostname="$1.trycloudflare.com"
    fi
    local config=$(readlink -f ~/.ssh/config)
    sed -i '' '/^Host nubio$/,/^Host /s|^\([[:space:]]*HostName\) .*|\1 '"$hostname"'|' "$config"
    echo "nubio hostname set to $hostname"
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

# Make Kitty play nicely with SSH (see https://github.com/kovidgoyal/kitty/issues/1613#issuecomment-734753530)
if test "$TERM" = "xterm-kitty"
then
    s() {
        # Bootstrap minimal dotfiles on first connect (once per host)
        # Pipes script via stdin to bypass tcsh exec-to-bash issues
        # Use --force-reinstall to force re-install on the remote
        local reinstall=false
        local args=()
        for arg in "$@"; do
            case "$arg" in
                --force-reinstall) reinstall=true ;;
                *) args+=("$arg") ;;
            esac
        done
        set -- "${args[@]}"

        local cache_dir="$HOME/.cache/dotfiles-ssh"
        if $reinstall || [ ! -f "$cache_dir/$1" ]; then
            if $reinstall; then
                ssh "$@" bash << 'SETUP'
echo "Reinstalling dotfiles..."
[ -d ~/dotfiles ] || git clone --recursive https://github.com/gideonshaked/dotfiles ~/dotfiles
cd ~/dotfiles && git pull && ./install --minimal
grep -qF bashrc.dotfiles ~/.bashrc 2>/dev/null || echo '[ -f "$HOME/.bashrc.dotfiles" ] && . "$HOME/.bashrc.dotfiles"' >> ~/.bashrc
grep -qF bashrc.dotfiles ~/.bash_profile 2>/dev/null || echo '[ -f "$HOME/.bashrc.dotfiles" ] && . "$HOME/.bashrc.dotfiles"' >> ~/.bash_profile
SETUP
            else
                ssh "$@" bash << 'BOOTSTRAP'
if [ -f ~/.bashrc.dotfiles ]; then
    grep -qF bashrc.dotfiles ~/.bashrc 2>/dev/null || echo '[ -f "$HOME/.bashrc.dotfiles" ] && . "$HOME/.bashrc.dotfiles"' >> ~/.bashrc
    grep -qF bashrc.dotfiles ~/.bash_profile 2>/dev/null || echo '[ -f "$HOME/.bashrc.dotfiles" ] && . "$HOME/.bashrc.dotfiles"' >> ~/.bash_profile
    exit 0
fi
echo "Installing dotfiles..."
[ -d ~/dotfiles ] || git clone --recursive https://github.com/gideonshaked/dotfiles ~/dotfiles
cd ~/dotfiles && ./install --minimal
grep -qF bashrc.dotfiles ~/.bashrc 2>/dev/null || echo '[ -f "$HOME/.bashrc.dotfiles" ] && . "$HOME/.bashrc.dotfiles"' >> ~/.bashrc
grep -qF bashrc.dotfiles ~/.bash_profile 2>/dev/null || echo '[ -f "$HOME/.bashrc.dotfiles" ] && . "$HOME/.bashrc.dotfiles"' >> ~/.bash_profile
BOOTSTRAP
            fi
            mkdir -p "$cache_dir" && touch "$cache_dir/$1"
        fi
        case "$1" in
            shamir* | elkon*) ssh "$@" ;;
            *) kitty +kitten ssh "$@" ;;
        esac
    }
fi
