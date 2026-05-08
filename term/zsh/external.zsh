#
# Configure external tools
#

# Conda/Mamba (lazy-loaded)
_lazy_conda_init() {
    unfunction conda mamba 2>/dev/null
    __conda_setup="$('/opt/homebrew/Caskroom/mambaforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh" ]; then
            . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh"
        else
            export PATH="/opt/homebrew/Caskroom/mambaforge/base/bin:$PATH"
        fi
    fi
    unset __conda_setup
    if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/mamba.sh" ]; then
        . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/mamba.sh"
    fi
}
conda() { _lazy_conda_init && conda "$@" }
mamba() { _lazy_conda_init && mamba "$@" }

# SSH agent (reuse existing agent if available)
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent) > /dev/null
    ssh-add ~/.ssh/^(config|known_hosts|known_hosts.old|*.pub) &> /dev/null
fi
