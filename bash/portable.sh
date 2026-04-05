# Portable bashrc — carried to remote machines by sshc
# Self-contained: no dependencies on brew, bash-completion, or local tools

# Git aliases
alias gb="git branch"
alias gs="git status"
alias gc="git checkout"
alias gcm="git commit -m"
alias ga="git add"
alias gl="git log --graph"
alias glm="gl master.."
alias gp="git pull"
alias gpr="git pull --rebase"
alias gap="git add -p"
alias gd="git diff"
alias push='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias whatdidido='git log --all --author=$USER --since=1.weeks --graph --decorate'

# Basic aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Prompt with git branch
parse_git_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "(${ref#refs/heads/}) "
}

RED="\[\033[0;31m\]"
BLUE="\[\033[1;34m\]"
CYAN="\[\033[1;36m\]"
NORMAL="\[\033[0;0m\]"

PS1="$CYAN\h $BLUE\W$RED \$(parse_git_branch)$NORMAL\$ "
PS1='\[\033]0;\W\007\]'$PS1
