# Connect docker client to boot2docker VM
#export DOCKER_HOST=tcp://
#export DOCKER_HOST=tcp://localhost:4243
#export DOCKER_TLS_VERIFY=1

# enable bash completion in interactive shells
. /etc/bash_completion

# Python development
export PATH=$HOME/.local/bin:$PATH
export WORKON_HOME=$HOME/envs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
. $HOME/.local/bin/virtualenvwrapper.sh
