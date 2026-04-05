export BASH_SILENCE_DEPRECATION_WARNING=1
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Bash completion
if hash brew 2> /dev/null; then
    if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
        . "$(brew --prefix)/etc/bash_completion"
    else
        echo "bash-completion not found. Install with: brew install bash-completion"
    fi
fi

# libpq
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"

# ghostty
export PATH="$PATH:/Applications/Ghostty.app/Contents/MacOS"
