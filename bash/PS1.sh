function parse_git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "("${ref#refs/heads/}") "
}

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[1;32m\]"
BLUE="\[\033[1;34m\]"
NORMAL="\[\033[0;0m\]"
CYAN="\[\033[1;36m\]"

PS1="$CYAN\h $BLUE\W$RED \$(parse_git_branch)$NORMAL\$ "
PS1='\[\033]0;\W\007\]'$PS1
