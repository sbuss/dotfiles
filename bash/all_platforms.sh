# make bash autocomplete with up arrow
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Make pip always install files into the current virtualenv
export PIP_RESPECT_VIRTUALENV=true


# Clean up merged local branches (that don't match dev or master)
function git-mop {
  commit=$1
  to_delete=`git branch --merged | egrep -v '^. (dev|master|main)$'`
  if [ -z "$to_delete" ]; then
    echo "No branches to delete"
  else
    if [[ $commit == "-c" ]]; then
      echo "$to_delete" | xargs -n 1 -r git branch -d
      git prune
    else
      echo "$to_delete"
    fi
  fi
}

# Use vim
export EDITOR=vim
