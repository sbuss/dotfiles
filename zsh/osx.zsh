# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# libpq
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"

# ghostty
export PATH="$PATH:/Applications/Ghostty.app/Contents/MacOS"
