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

# fzf - key bindings only: Ctrl-T (file picker), Alt-C (cd picker).
# Skip completion.zsh; it would rebind Tab and clash with zsh-autocomplete.
# Atuin (sourced below) takes over Ctrl-R after this.
[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

# atuin - smarter shell history (rebinds Ctrl+R, leaves Up arrow alone for zsh-autocomplete)
[ -x /opt/homebrew/bin/atuin ] && eval "$(atuin init zsh --disable-up-arrow)"
