
# Git completion
# if on osx then 'brew install bash-completion'
# see https://github.com/bobthecow/git-flow-completion/wiki/Install-Bash-git-completion
if hash brew 2> /dev/null; then
    if [ -f `brew --prefix`/etc/bash_completion ]; then
	. `brew --prefix`/etc/bash_completion
    fi
fi

if hash brew 2> /dev/null; then
    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
fi


# Connect docker client to boot2docker VM
#export DOCKER_HOST=tcp://
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm

# Python development
export PATH=/usr/local/share/python:$PATH
export WORKON_HOME=$HOME/envs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
. /usr/local/share/python/virtualenvwrapper.sh

# Make sure we're using Homebrew's python binary by default
export PATH=/usr/local/bin:$PATH
# Homebrew npm
export PATH=/usr/local/share/npm/bin:$PATH
export PATH=/usr/local/lib/node_modules:$PATH
