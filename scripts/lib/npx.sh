#!/usr/bin/env bash

DOTFILES_NVM_VERSION="${DOTFILES_NVM_VERSION:-v0.40.4}"
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

dotfiles_npx_usable() {
    command -v npx >/dev/null 2>&1 && npx --version >/dev/null 2>&1
}

dotfiles_npx_load_nvm() {
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        # shellcheck disable=SC1091
        . "$NVM_DIR/nvm.sh"
        if ! dotfiles_npx_usable && command -v nvm >/dev/null 2>&1; then
            nvm use --silent default >/dev/null 2>&1 || nvm use --silent --lts >/dev/null 2>&1 || true
        fi
    fi
}

dotfiles_npx_activate() {
    dotfiles_npx_usable && return 0
    dotfiles_npx_load_nvm
    dotfiles_npx_usable
}

dotfiles_npx_add_loader() {
    local file="$1"

    touch "$file"
    if grep -qF 'DOTFILES NVM LOADER' "$file"; then
        return 0
    fi

    cat >> "$file" <<'EOF'

# BEGIN DOTFILES NVM LOADER
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
if [ -s "$NVM_DIR/nvm.sh" ] && ! npx --version >/dev/null 2>&1 && command -v nvm >/dev/null 2>&1; then
    nvm use --silent default >/dev/null 2>&1 || nvm use --silent --lts >/dev/null 2>&1 || true
fi
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
# END DOTFILES NVM LOADER
EOF
}

dotfiles_npx_install_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && return 0

    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${DOTFILES_NVM_VERSION}/install.sh" | PROFILE=/dev/null bash
    elif command -v wget >/dev/null 2>&1; then
        wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/${DOTFILES_NVM_VERSION}/install.sh" | PROFILE=/dev/null bash
    else
        echo "curl/wget not found, cannot install nvm (non-fatal)"
        return 1
    fi
}

dotfiles_npx_install_node() {
    dotfiles_npx_install_nvm || return 1
    dotfiles_npx_load_nvm
    if ! command -v nvm >/dev/null 2>&1; then
        echo "nvm install failed (non-fatal)"
        return 1
    fi

    nvm install --lts
    nvm alias default 'lts/*' >/dev/null 2>&1 || true
}
