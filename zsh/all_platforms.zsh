# History search with up/down arrows
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Make pip always install files into the current virtualenv
export PIP_RESPECT_VIRTUALENV=true

# Clean up merged local branches (that don't match dev or master)
function git-mop {
  commit=$1
  to_delete=$(git branch --merged | egrep -v '^. (dev|master|main)$')
  if [ -z "$to_delete" ]; then
    echo "No branches to delete"
  else
    if [[ $commit == "-c" ]]; then
      echo "$to_delete" | xargs -n 1 git branch -d
      git prune
    else
      echo "$to_delete"
    fi
  fi
}

# Use vim
export EDITOR=vim

# Load API keys
if [[ -f $HOME/.bash/api_keys.sh ]]; then
  . $HOME/.bash/api_keys.sh
fi

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
