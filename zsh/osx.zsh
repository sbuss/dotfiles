# Colorize ls and set file-type colors
export CLICOLOR=1
export LSCOLORS="GxFxCxDxBxegedabagaced"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# coreutils to replace ls and others
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
alias ls="ls --color=auto"

# libpq
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"

# ghostty
export PATH="$PATH:/Applications/Ghostty.app/Contents/MacOS"
