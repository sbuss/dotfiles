alias cim='vim'
alias cw='cd ~/workspace'

# Find and delete all pyc files
alias rmpyc='find . -name "*.pyc" -delete'
# grep only python files
alias pygrep='grep --include=*.py --exclude="*migrations*"'
# grep only html files
alias hgrep='grep --include=*.html'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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

# ctags - perform this from project root
alias tags="hash -r && ctags -R --python-kinds=-i ."
