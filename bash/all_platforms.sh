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
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Google cloud
export GCLOUD_PATH=${HOME}/google-cloud-sdk
if [[ -f ${GCLOUD_PATH}/path.bash.inc ]]; then
  # The next line updates PATH for the Google Cloud SDK.
  . ${GCLOUD_PATH}/path.bash.inc

  # The next line enables shell command completion for gcloud.
  . ${GCLOUD_PATH}/completion.bash.inc
fi

# Use vim
export EDITOR=vim
