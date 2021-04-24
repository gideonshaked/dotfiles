#!/usr/bin/env bash
#
# Completion script for "c" utility function
# Only possible args are every directory in $PROJECTS
#

_c_completions() {
    COMPREPLY=($(compgen -W "$(find $PROJECTS -mindepth 1  -maxdepth 1 -type d | awk '{n=split($NF,a,"/");print $5,a[n]}')" -- "${COMP_WORDS[1]}"))
}

complete -F _c_completions  c
