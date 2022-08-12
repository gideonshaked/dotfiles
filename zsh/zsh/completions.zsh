#
# Custom completion functions
#

# Make bash completion work in zsh
# (see https://stackoverflow.com/questions/3249432/can-a-bash-tab-completion-script-be-used-in-zsh#answer-27853970)
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Autocomplete for aws-cli (different from auto-prompt)
complete -C "/usr/bin/aws_completer" aws

# Autocomplete for v and c functions (file: functions.bash)
_v_and_c_completion() {
    COMPREPLY=($(compgen -W "$(find "$PROJECTS/" -type d | cut -d "/" -f5-)" "${COMP_WORDS[1]}"))
}

complete -F _v_and_c_completion v
complete -F _v_and_c_completion c
