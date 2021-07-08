# Connect docker client to boot2docker VM
#export DOCKER_HOST=tcp://
#export DOCKER_HOST=tcp://localhost:4243
#export DOCKER_TLS_VERIFY=1

# enable bash completion in interactive shells
. /etc/bash_completion

# Python development
export PATH=$HOME/.local/bin:$PATH:/usr/local/go/bin

# CUDA
if [[ -d "/usr/local/cuda" ]]; then
    export PATH=/usr/local/cuda/bin:$PATH
fi

# X1 Carbon trackpoint config
#if [[ $(hostname) == "sierra" ]]; then
#    device='TPPS/2 Elan TrackPoint'
#    # Flat accel profile
#    xinput set-prop "$device" 'libinput Accel Profile Enabled' {0, 1}
#    # Set accel value
#    xinput set-prop "$device" 'libinput Accel Speed' .8
#fi

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

