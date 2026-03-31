#
# Portable bash prompt, mimics starship layout
# Shows: user@host directory (branch) ❯
#

__dotfiles_prompt_command() {
    local last_exit=$?

    # Colors (ANSI escape codes wrapped for PS1)
    local reset='\[\033[0m\]'
    local green='\[\033[32m\]'
    local purple='\[\033[35m\]'
    local red='\[\033[31m\]'
    local yellow='\[\033[33m\]'
    local bold_green='\[\033[1;32m\]'
    local bold_blue='\[\033[1;34m\]'
    local bold_cyan='\[\033[1;36m\]'

    # user@host directory
    PS1="${bold_green}\u${reset}@${bold_cyan}\h${reset} ${bold_blue}\w${reset}"

    # Git branch: skip entirely if no .git anywhere up the tree
    local git_dir
    if git_dir="$(git rev-parse --git-dir 2>/dev/null)"; then
        local branch
        # Read HEAD directly instead of spawning another git process
        if [ -f "$git_dir/HEAD" ]; then
            read -r head < "$git_dir/HEAD"
            case "$head" in
                ref:*) branch="${head#ref: refs/heads/}" ;;
                *)     branch="${head:0:7}" ;;  # detached, show short SHA
            esac
        fi
        if [ -n "$branch" ]; then
            PS1+=" ${purple}(${branch})${reset}"
        fi
    fi

    # Virtual environment
    if [ -n "$VIRTUAL_ENV" ]; then
        PS1+=" ${yellow}($(basename "$VIRTUAL_ENV"))${reset}"
    elif [ -n "$CONDA_DEFAULT_ENV" ] && [ "$CONDA_DEFAULT_ENV" != "base" ]; then
        PS1+=" ${yellow}(${CONDA_DEFAULT_ENV})${reset}"
    fi

    # Prompt character: green on success, red on failure
    if [ "$last_exit" -ne 0 ]; then
        PS1+=" ${red}❯${reset} "
    else
        PS1+=" ${green}❯${reset} "
    fi
}

# Disable default virtualenv prompt prefix (we handle it ourselves)
export VIRTUAL_ENV_DISABLE_PROMPT=1

PROMPT_COMMAND=__dotfiles_prompt_command
