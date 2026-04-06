# Zsh Default Shell Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add zsh as the default shell config on macOS/Linux, with native completion and prompt.

**Architecture:** Create a `zsh/` directory mirroring the `bash/` structure. New `myzshrc` dispatcher sources zsh-native config files. `setup.sh` gets a `_zsh()` function. Bash config stays as legacy fallback and for `sshc`/`portable.sh`.

**Tech Stack:** Zsh, compinit/compdef

**Spec:** `docs/superpowers/specs/2026-04-05-zsh-default-design.md`

---

### Task 1: Create zsh/all_platforms.zsh

**Files:**
- Create: `zsh/all_platforms.zsh`

- [ ] **Step 1: Create the file**

Write this content to `zsh/all_platforms.zsh`:

```zsh
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
```

Note: `xargs -r` removed (not supported on macOS). API keys path made absolute since zsh won't be sourced from the bash directory.

- [ ] **Step 2: Commit**

```bash
git add zsh/all_platforms.zsh
git commit -m "add zsh/all_platforms.zsh with history search, git-mop, exports"
```

---

### Task 2: Create zsh/osx.zsh

**Files:**
- Create: `zsh/osx.zsh`

- [ ] **Step 1: Create the file**

Write this content to `zsh/osx.zsh`:

```zsh
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# libpq
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"

# ghostty
export PATH="$PATH:/Applications/Ghostty.app/Contents/MacOS"
```

No bash-completion needed — zsh has built-in completion. No `BASH_SILENCE_DEPRECATION_WARNING`.

- [ ] **Step 2: Commit**

```bash
git add zsh/osx.zsh
git commit -m "add zsh/osx.zsh with Homebrew, libpq, Ghostty"
```

---

### Task 3: Create zsh/linux.zsh

**Files:**
- Create: `zsh/linux.zsh`

- [ ] **Step 1: Create the file**

Write this content to `zsh/linux.zsh`:

```zsh
# Linux-specific zsh config
# Zsh completion is built-in, no package needed
```

- [ ] **Step 2: Commit**

```bash
git add zsh/linux.zsh
git commit -m "add zsh/linux.zsh placeholder"
```

---

### Task 4: Create zsh/aliases.zsh

**Files:**
- Create: `zsh/aliases.zsh`

- [ ] **Step 1: Create the file**

Write this content to `zsh/aliases.zsh`:

```zsh
alias cim='vim'
alias cw='cd ~/workspace'

# Find and delete all pyc files
alias rmpyc='find . -name "*.pyc" -delete'
# grep only python files
alias pygrep='grep --include=*.py --exclude="*migrations*"'
# grep only html files
alias hgrep='grep --include=*.html'

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

###
# Git aliases
###
alias gb="git branch"
alias gs="git status"
alias gc="git checkout"
alias gcm="git commit -m"
alias ga="git add"
alias gl="git log --graph"
alias glm="gl master.."
alias gp="git pull"
alias gpr="git pull --rebase"
alias gap="git add -p"
alias gd="git diff"
alias push='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias whatdidido='git log --all --author=$USER --since=1.weeks --graph --decorate'

# Postgres recovery
alias restartpostgres="rm /usr/local/var/postgres/postmaster.pid && pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"

# SSH with portable bashrc (git aliases + prompt on remote machines)
sshc() {
    local rc
    rc=$(base64 < "$HOME/.bash/portable.sh")
    ssh -t "$@" "echo '$rc' | base64 -d > /tmp/.bashrc_portable && bash --rcfile /tmp/.bashrc_portable"
}
```

No `dircolors` block (macOS doesn't have it). No `__git_complete` (handled by `completion.zsh`). Uses `$(...)` instead of backticks for `push` alias.

- [ ] **Step 2: Commit**

```bash
git add zsh/aliases.zsh
git commit -m "add zsh/aliases.zsh with git aliases and sshc"
```

---

### Task 5: Create zsh/completion.zsh

**Files:**
- Create: `zsh/completion.zsh`

- [ ] **Step 1: Create the file**

Write this content to `zsh/completion.zsh`:

```zsh
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
```

- [ ] **Step 2: Commit**

```bash
git add zsh/completion.zsh
git commit -m "add zsh/completion.zsh with compinit and git alias completion"
```

---

### Task 6: Create zsh/prompt.zsh

**Files:**
- Create: `zsh/prompt.zsh`

- [ ] **Step 1: Create the file**

Write this content to `zsh/prompt.zsh`:

```zsh
# Enable prompt substitution
setopt PROMPT_SUBST

parse_git_branch() {
    local ref
    ref=$(git symbolic-ref HEAD 2>/dev/null) || return
    echo "(${ref#refs/heads/}) "
}

# Prompt: hostname dir (branch) $
# Matches the bash PS1 style: cyan hostname, blue dir, red branch
PROMPT='%F{cyan}%m %F{blue}%1~%F{red} $(parse_git_branch)%f$ '

# Window title: current directory
precmd() {
    print -Pn "\e]0;%1~\a"
}
```

- [ ] **Step 2: Commit**

```bash
git add zsh/prompt.zsh
git commit -m "add zsh/prompt.zsh with git branch display"
```

---

### Task 7: Create myzshrc

**Files:**
- Create: `myzshrc`

- [ ] **Step 1: Create the file**

Write this content to `myzshrc`:

```zsh
ZD=$HOME/.zsh

. $ZD/all_platforms.zsh

case $(uname -s) in
  Darwin)
    . $ZD/osx.zsh
    ;;
  Linux)
    . $ZD/linux.zsh
    ;;
esac

. $ZD/aliases.zsh
. $ZD/completion.zsh
. $ZD/prompt.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sbuss/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sbuss/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sbuss/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sbuss/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="$HOME/.local/bin:$PATH"

alias blaude="CLAUDE_CONFIG_DIR=~/.claude-bacio claude --dangerously-skip-permissions"
eval "$(direnv hook zsh)"
```

Note: Google Cloud SDK has zsh-specific files (`path.zsh.inc`, `completion.zsh.inc`). Direnv hook uses `zsh` not `bash`.

- [ ] **Step 2: Commit**

```bash
git add myzshrc
git commit -m "add myzshrc as main zsh config dispatcher"
```

---

### Task 8: Update setup.sh

**Files:**
- Modify: `setup.sh`

- [ ] **Step 1: Add _zsh function and call it**

Add the `_zsh()` function after `_claude()` and add `_zsh` to the execution list at the bottom. The function should:

```bash
_zsh() {
    rm -f $HOME/.myzshrc
    if [[ ! -d $HOME/.zsh ]]; then
        ln -s `pwd`/zsh $HOME/.zsh
    fi
    ln -s `pwd`/myzshrc $HOME/.myzshrc
    if [ -f $HOME/.zshrc ]; then
        if ! grep 'myzshrc' $HOME/.zshrc 2>/dev/null; then
            echo ". $HOME/.myzshrc" >> $HOME/.zshrc
        fi
    else
        echo ". $HOME/.myzshrc" > $HOME/.zshrc
    fi
}
```

Add `_zsh` to the execution block so it becomes:

```bash
_vim
_bash
_git
_claude
_zsh
```

- [ ] **Step 2: Commit**

```bash
git add setup.sh
git commit -m "add _zsh to setup.sh for zsh config symlinking"
```

---

### Task 9: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Update CLAUDE.md**

Replace the content of `CLAUDE.md` with:

```markdown
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repo for macOS and Linux. Files are symlinked into `$HOME` by `setup.sh`. Zsh is the default shell; bash config is kept for `sshc` remote sessions and as legacy fallback.

## Setup

` ` `bash
./setup.sh
` ` `

Symlinks config files into `$HOME` (`.vimrc`, `.myzshrc`, `.mybashrc`, `.bash_profile` on macOS, `.gitglobalignore`). Automatically clones Vundle and installs vim plugins.

## Architecture

- **`setup.sh`** — Entry point. Symlinks everything via `_vim`, `_bash`, `_git`, `_claude`, `_zsh` functions. Uses `rm -f` then `ln -s` pattern.
- **`myzshrc`** — Main zsh config dispatcher. Sources: `all_platforms.zsh` → `osx.zsh` or `linux.zsh` → `aliases.zsh` → `completion.zsh` → `prompt.zsh`. Also loads Google Cloud SDK, direnv, and the `blaude` alias.
- **`zsh/`** — Modular zsh config (default shell):
  - `all_platforms.zsh` — History search, `git-mop` branch cleanup, editor config
  - `osx.zsh` — Homebrew, libpq, Ghostty PATH
  - `linux.zsh` — Linux-specific zsh config
  - `aliases.zsh` — Git aliases (`gs`, `gc`, `push`, etc.), `sshc` function
  - `completion.zsh` — `compinit` + `compdef` for git alias tab completion
  - `prompt.zsh` — Prompt with git branch display
- **`mybashrc`** — Legacy bash config dispatcher. Sources `bash/` files with platform switch.
- **`bash/`** — Bash config (legacy + remote):
  - `portable.sh` — Self-contained git aliases + prompt, carried to remote machines by `sshc`
  - `all_platforms.sh`, `osx.sh`, `linux.sh`, `aliases.sh`, `PS1.sh` — Legacy bash equivalents
- **`bash/api_keys.sh`** — Gitignored; holds local API keys
- **`vimrc`** + **`vim/`** — Vim config with arpeggio key chords and solarized colorscheme. Plugins managed by Vundle (arpeggio + solarized only).
- **`claude/`** — Default Claude Code config (`~/.claude/`):
  - `settings.json` — Symlinked to `~/.claude/settings.json`
  - `statusline-command.sh` — Symlinked into both `~/.claude/` and `~/.claude-bacio/`
- **`claude-bacio/`** — Blaude config (`~/.claude-bacio/`):
  - `settings.json` — Symlinked to `~/.claude-bacio/settings.json`

## Key Conventions

- Zsh is the default shell. Config is in `zsh/` directory, dispatched by `myzshrc`.
- Platform config is split by OS (`osx.zsh` vs `linux.zsh`) and sourced conditionally via `uname -s`.
- Two Claude Code configs: default (`~/.claude/`) for work, personal (`~/.claude-bacio/`) via the `blaude` alias (`CLAUDE_CONFIG_DIR=~/.claude-bacio`).
- `git-mop` (in `all_platforms.zsh`) cleans merged branches; use `-c` flag to actually delete (dry-run by default).
- `sshc` carries `portable.sh` (git aliases + prompt) to remote machines via base64 encoding. Use like `ssh`: `sshc user@host`. Remote sessions use bash.
```

IMPORTANT: The code fence in the Setup section should use actual backticks, not the spaced-out ones shown above.

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "update CLAUDE.md for zsh as default shell"
```

---

### Task 10: Test zsh config

- [ ] **Step 1: Run setup.sh**

```bash
./setup.sh
```

Verify no errors and that `~/.zsh` symlink and `~/.myzshrc` symlink exist.

- [ ] **Step 2: Test zsh config in a subshell**

```bash
zsh -c 'source ~/.myzshrc && echo "EDITOR=$EDITOR" && type gc && type sshc && type git-mop'
```

Expected: EDITOR=vim, gc is an alias, sshc is a function, git-mop is a function.

- [ ] **Step 3: Commit any fixes if needed**
