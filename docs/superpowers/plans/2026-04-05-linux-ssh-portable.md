# Linux Support + Portable SSH Config Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restore Linux platform support and add an `sshc` function that carries git aliases + prompt to ephemeral remote machines.

**Architecture:** Re-add `uname -s` platform switch in `mybashrc`, create minimal `bash/linux.sh` for bash-completion, create `bash/portable.sh` with self-contained git aliases + prompt, add `sshc` wrapper function to `bash/aliases.sh`.

**Tech Stack:** Bash, base64

**Spec:** `docs/superpowers/specs/2026-04-05-linux-ssh-portable-design.md`

---

### Task 1: Create bash/linux.sh

**Files:**
- Create: `bash/linux.sh`

- [ ] **Step 1: Create the file**

Write this content to `bash/linux.sh`:

```bash
# Enable bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
```

- [ ] **Step 2: Commit**

```bash
git add bash/linux.sh
git commit -m "add minimal linux.sh with bash-completion"
```

---

### Task 2: Restore platform switch in mybashrc

**Files:**
- Modify: `mybashrc`

- [ ] **Step 1: Replace mybashrc with platform-aware version**

Write this content to `mybashrc`:

```bash
BD=$HOME/.bash

. $BD/all_platforms.sh

case $(uname -s) in
  Darwin)
    . $BD/osx.sh
    ;;
  Linux)
    . $BD/linux.sh
    ;;
esac

. $BD/aliases.sh
. $BD/PS1.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sbuss/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/sbuss/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sbuss/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/sbuss/Downloads/google-cloud-sdk/completion.bash.inc'; fi
export PATH="$HOME/.local/bin:$PATH"

alias blaude="CLAUDE_CONFIG_DIR=~/.claude-bacio claude --dangerously-skip-permissions"
eval "$(direnv hook bash)"
```

Key change: `osx.sh` is now inside a `case` block. `aliases.sh` and `PS1.sh` stay outside (sourced on all platforms, after platform-specific completion is loaded).

- [ ] **Step 2: Commit**

```bash
git add mybashrc
git commit -m "restore platform switch in mybashrc for linux support"
```

---

### Task 3: Make setup.sh platform-aware

**Files:**
- Modify: `setup.sh`

- [ ] **Step 1: Replace setup.sh with platform-aware version**

Write this content to `setup.sh`:

```bash
#!/bin/bash

_vim() {
    rm -f $HOME/.vimrc
    ln -s `pwd`/vimrc $HOME/.vimrc

    rm -f $HOME/.vim/plugins
    mkdir -p $HOME/.vim
    mkdir -p $HOME/.vim/colors
    mkdir -p $HOME/.vim/swap
    mkdir -p $HOME/.vim/undo
    ln -s `pwd`/vim/plugins $HOME/.vim/plugins
    ln -s `pwd`/vim/colors/*.vim $HOME/.vim/colors/
}

_bash() {
    rm -f $HOME/.mybashrc
    if [[ ! -d $HOME/.bash ]]; then
        ln -s `pwd`/bash $HOME/.bash
    fi
    ln -s `pwd`/mybashrc $HOME/.mybashrc
    case $(uname -s) in
      Darwin)
        rm -f $HOME/.bash_profile
        ln -s `pwd`/bash_profile $HOME/.bash_profile
        ;;
    esac
    if ! grep 'mybashrc' $HOME/.bashrc; then
      echo ". $HOME/.mybashrc" >> $HOME/.bashrc
    fi
}

_git() {
    rm -f $HOME/.gitglobalignore
    ln -s `pwd`/gitglobalignore $HOME/.gitglobalignore
    git config --global core.excludesfile $HOME/.gitglobalignore
}

_claude() {
    # Default claude config (~/.claude)
    mkdir -p $HOME/.claude
    rm -f $HOME/.claude/settings.json
    rm -f $HOME/.claude/statusline-command.sh
    ln -s `pwd`/claude/settings.json $HOME/.claude/settings.json
    ln -s `pwd`/claude/statusline-command.sh $HOME/.claude/statusline-command.sh

    # Blaude config (~/.claude-bacio)
    mkdir -p $HOME/.claude-bacio
    rm -f $HOME/.claude-bacio/settings.json
    rm -f $HOME/.claude-bacio/statusline-command.sh
    ln -s `pwd`/claude-bacio/settings.json $HOME/.claude-bacio/settings.json
    ln -s `pwd`/claude/statusline-command.sh $HOME/.claude-bacio/statusline-command.sh
}

_vim
_bash
_git
_claude
```

Only change from current: `_bash()` wraps the `bash_profile` symlink in `case $(uname -s) in Darwin)` so it only runs on macOS.

- [ ] **Step 2: Commit**

```bash
git add setup.sh
git commit -m "make setup.sh platform-aware for bash_profile"
```

---

### Task 4: Create bash/portable.sh

**Files:**
- Create: `bash/portable.sh`

- [ ] **Step 1: Create the portable bashrc**

Write this content to `bash/portable.sh`:

```bash
# Portable bashrc — carried to remote machines by sshc
# Self-contained: no dependencies on brew, bash-completion, or local tools

# Git aliases
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

# Basic aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Prompt with git branch
parse_git_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "(${ref#refs/heads/}) "
}

RED="\[\033[0;31m\]"
BLUE="\[\033[1;34m\]"
CYAN="\[\033[1;36m\]"
NORMAL="\[\033[0;0m\]"

PS1="$CYAN\h $BLUE\W$RED \$(parse_git_branch)$NORMAL\$ "
PS1='\[\033]0;\W\007\]'$PS1
```

Note: uses `$(...)` instead of backticks for `push` alias to avoid quoting issues when base64-encoded and decoded on the remote.

- [ ] **Step 2: Commit**

```bash
git add bash/portable.sh
git commit -m "add portable bashrc for sshc remote sessions"
```

---

### Task 5: Add sshc function to aliases.sh

**Files:**
- Modify: `bash/aliases.sh`

- [ ] **Step 1: Append sshc function to the end of bash/aliases.sh**

Add this block after the `__git_complete` `fi` at the end of the file:

```bash

# SSH with portable bashrc (git aliases + prompt on remote machines)
sshc() {
    local rc
    rc=$(base64 < "$HOME/.bash/portable.sh")
    ssh -t "$@" "echo '$rc' | base64 -d > /tmp/.bashrc_portable && bash --rcfile /tmp/.bashrc_portable"
}
```

- [ ] **Step 2: Test locally**

Verify the function loads without errors:

```bash
source bash/aliases.sh
type sshc
```

Expected: `sshc is a function`

- [ ] **Step 3: Commit**

```bash
git add bash/aliases.sh
git commit -m "add sshc function for portable bash on remote machines"
```

---

### Task 6: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Replace CLAUDE.md with updated version**

Write this content to `CLAUDE.md`:

```markdown
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repo for macOS and Linux. Files are symlinked into `$HOME` by `setup.sh`.

## Setup

` ` `bash
./setup.sh
` ` `

Symlinks config files into `$HOME` (`.vimrc`, `.mybashrc`, `.bash_profile` on macOS, `.gitglobalignore`). Vim plugins require a one-time manual install: clone Vundle into `~/.vim/bundle/Vundle.vim`, then run `vim -u ~/.vim/plugins +PluginInstall +qall`.

## Architecture

- **`setup.sh`** — Entry point. Symlinks everything via `_vim`, `_bash`, `_git`, `_claude` functions. Uses `rm -f` then `ln -s` pattern. `bash_profile` is only linked on macOS.
- **`mybashrc`** — Sources bash config in order: `all_platforms.sh` → `osx.sh` or `linux.sh` (platform-conditional, loads bash-completion) → `aliases.sh` (git aliases + `__git_complete` + `sshc`) → `PS1.sh`. Also loads Google Cloud SDK, direnv, and the `blaude` alias.
- **`bash/`** — Modular bash config:
  - `all_platforms.sh` — History search, `git-mop` branch cleanup, editor config
  - `osx.sh` — Homebrew, bash-completion, libpq, Ghostty PATH
  - `linux.sh` — Bash-completion (Linux path)
  - `aliases.sh` — Git aliases (`gs`, `gc`, `push`, etc.) with `__git_complete` tab completion, `sshc` function
  - `PS1.sh` — Prompt with git branch display
  - `portable.sh` — Self-contained git aliases + prompt, carried to remote machines by `sshc`
- **`bash/api_keys.sh`** — Gitignored; holds local API keys
- **`vimrc`** + **`vim/`** — Vim config with arpeggio key chords and solarized colorscheme. Plugins managed by Vundle (arpeggio + solarized only).
- **`claude/`** — Default Claude Code config (`~/.claude/`):
  - `settings.json` — Symlinked to `~/.claude/settings.json`
  - `statusline-command.sh` — Symlinked into both `~/.claude/` and `~/.claude-bacio/`
- **`claude-bacio/`** — Blaude config (`~/.claude-bacio/`):
  - `settings.json` — Symlinked to `~/.claude-bacio/settings.json`

## Key Conventions

- Platform config is split by OS (`osx.sh` vs `linux.sh`) and sourced conditionally via `uname -s` in `mybashrc`.
- Source order matters: platform file (bash-completion) must load before `aliases.sh` (`__git_complete`).
- Two Claude Code configs: default (`~/.claude/`) for work, personal (`~/.claude-bacio/`) via the `blaude` alias (`CLAUDE_CONFIG_DIR=~/.claude-bacio`).
- `git-mop` (in `all_platforms.sh`) cleans merged branches; use `-c` flag to actually delete (dry-run by default).
- `sshc` carries `portable.sh` (git aliases + prompt) to remote machines via base64 encoding. Use like `ssh`: `sshc user@host`.
```

IMPORTANT: The code fence in the Setup section should use actual backticks, not the spaced-out backticks shown above.

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "update CLAUDE.md with linux support and sshc docs"
```
