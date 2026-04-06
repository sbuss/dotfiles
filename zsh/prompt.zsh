# Enable prompt substitution
setopt PROMPT_SUBST

git_prompt_info() {
    local ref dirty
    ref=$(git symbolic-ref --short HEAD 2>/dev/null) || return
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        dirty="%F{red}*%f"
    fi
    echo " %F{green}(${ref}${dirty}%F{green})%f"
}

virtualenv_prompt_info() {
    [[ -n $VIRTUAL_ENV ]] && echo "%F{242}(${VIRTUAL_ENV:t}) %f"
}

PROMPT='$(virtualenv_prompt_info)%F{blue}%~%f$(git_prompt_info) $ '
RPROMPT='%F{242}%T%f'

# Window title: current directory
precmd() {
    print -Pn "\e]0;%~\a"
}
