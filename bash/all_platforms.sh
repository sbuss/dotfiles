# make bash autocomplete with up arrow
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Make pip always install files into the current virtualenv
export PIP_RESPECT_VIRTUALENV=true


# Clean up merged local branches (that don't match dev or master)
function git-mop {
  commit=$1
  to_delete=`git branch --merged | egrep -v '^. (dev|master)$'`
  if [ -z "$to_delete" ]; then
    echo "No branches to delete"
  else
    if [[ $commit == "-c" ]]; then
      git branch -d $to_delete
      git prune
    else
      echo "$to_delete"
    fi
  fi
}

# Go development
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOPATH=$HOME/gopkgs
export PATH=$PATH:$GOPATH/bin
#alias gop="ln -s $1 $GOPATH/$2"
addgopkg () {
	ln -s $1 $GOPATH/src/$2
}
alias gop=addgopkg
