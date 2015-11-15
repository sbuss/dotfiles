alias cim='vim'
alias cw='cd ~/workspace'

# Find and delete all pyc files
alias rmpyc='find . -name "*.pyc" -delete'
# grep only python files
alias pygrep='grep --include=*.py --exclude="*migrations*"'
# grep only html files
alias hgrep='grep --include=*.html'

alias ls='ls --color=auto'

###
# Git aliases
###
alias gb="git branch"
alias gs="git status"
alias gc="git checkout"
alias ga="git add"
alias gl="git log --graph"
alias glm="gl master.."
alias gp="git pull"
alias gpr="git pull --rebase"
alias gd="git diff"
alias push='git push origin `git rev-parse --abbrev-ref HEAD`'
alias whatdidido='git log --all --author=$USER --since=1.weeks --graph --decorate'

# Postgres recovery
alias restartpostgres="rm /usr/local/var/postgres/postmaster.pid && pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"
