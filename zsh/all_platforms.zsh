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

# nvm: keep shell startup fast (sourcing nvm.sh eagerly adds ~500ms).
# prepend_default_node_to_path puts the default node version's real bin/ on
# PATH, so node, npm, npx, pnpm, yarn and corepack all resolve without ever
# sourcing nvm. It's called from .myzshrc *after* the platform files so it wins
# over Homebrew's node. nvm itself stays lazy; it's only needed to *switch*
# node versions.
export NVM_DIR="$HOME/.nvm"

prepend_default_node_to_path() {
    [ -s "$NVM_DIR/nvm.sh" ] || return
    # Resolve the default alias to a concrete version dir. The alias usually
    # holds "node" or "lts/*" (meaning "latest"), which isn't itself a dir, so
    # fall back to the highest installed version (zsh-native version sort).
    local ver
    local -a dirs
    ver=$([ -r "$NVM_DIR/alias/default" ] && cat "$NVM_DIR/alias/default")
    if [ -z "$ver" ] || [ ! -d "$NVM_DIR/versions/node/$ver/bin" ]; then
        dirs=( "$NVM_DIR"/versions/node/*(/N:t) )
        ver=${${(On)dirs}[1]}
    fi
    [ -n "$ver" ] && [ -d "$NVM_DIR/versions/node/$ver/bin" ] &&
        PATH="$NVM_DIR/versions/node/$ver/bin:$PATH"
}

# nvm stays lazy: source it only when `nvm` is actually invoked.
if [ -s "$NVM_DIR/nvm.sh" ]; then
    nvm() {
        unset -f nvm
        . "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
        nvm "$@"
    }
fi
