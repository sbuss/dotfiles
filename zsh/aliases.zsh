alias cim='vim'
alias cw='cd ~/workspace'

# Find and delete all pyc files
alias rmpyc='find . -name "*.pyc" -delete'
# grep only python files
alias pygrep='grep --include=*.py --exclude="*migrations*"'
# grep only html files
alias hgrep='grep --include=*.html'

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Colors for grep, diff, and other utils
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'

###
# Git aliases
###
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

# Postgres recovery
alias restartpostgres="rm /usr/local/var/postgres/postmaster.pid && pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"

# SSH with portable bashrc (git aliases + prompt on remote machines)
sshc() {
    local rc
    rc=$(base64 < "$HOME/.bash/portable.sh")
    ssh -t "$@" "echo '$rc' | base64 -d > /tmp/.bashrc_portable && bash --rcfile /tmp/.bashrc_portable"
}
