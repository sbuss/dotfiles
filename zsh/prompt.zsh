# Enable prompt substitution
setopt PROMPT_SUBST

parse_git_branch() {
    local ref
    ref=$(git symbolic-ref HEAD 2>/dev/null) || return
    echo "(${ref#refs/heads/}) "
}

# Prompt: hostname dir (branch) $
# Matches the bash PS1 style: cyan hostname, blue dir, red branch
PROMPT='%F{cyan}%m %F{blue}%1~%F{red} $(parse_git_branch)%f$ '

# Window title: current directory
precmd() {
    print -Pn "\e]0;%1~\a"
}
