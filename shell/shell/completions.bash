#
# Custom completion functions
#

# For shell function latexwc (file: functions.bash)
# Possible args are .tex files under the current directory
_latexwc_completion() {
    COMPREPLY=$(compgen -W "$(find . -type f)")
}

complete -F _latexwc_completion latexwc

# Autocomplete for aws-cli (different from auto-prompt)
complete -C "/usr/bin/aws_completer" aws
