#!/usr/bin/env bash
#
# Completion script for "WC" utility function
# Possible args are .tex files under current directory
#

_WC_completion() {
    COMPREPLY=$(compgen -W "$(find . -type f)")
}

complete -F _WC_completion WC
