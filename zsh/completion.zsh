# Initialize zsh completion system
autoload -Uz compinit && compinit

# Git alias completion — tells zsh which git subcommand each alias wraps
compdef _git gc=git-checkout
compdef _git gb=git-branch
compdef _git ga=git-add
compdef _git gap=git-add
compdef _git gp=git-pull
compdef _git gpr=git-pull
compdef _git gd=git-diff
compdef _git gl=git-log
