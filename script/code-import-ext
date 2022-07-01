#!/usr/bin/env bash
#
# Import extensions from vscode/extensions.txt to VS Code.
#

not_installed_exts() {
    local extensions=$(<vscode/extensions.txt)
    local current_extensions=$(code --list-extensions)
    extensions_not_installed=$(diff --new-line-format="" --unchanged-line-format="" <(echo "$extensions") <(echo "$current_extensions"))
}

install_exts() {
    if [[ -n "$extensions_not_installed" ]]; then
        while IFS= read -r extension; do
            code --install-extension "$extension"
        done <<< "$1"
    fi
}

main() {
    not_installed_exts

    install_exts "$extensions_not_installed"
}

main
