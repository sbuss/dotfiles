# Dotfiles Cleanup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Strip dotfiles repo to what's actively used (bash, git, vim essentials, Claude config) on a single Mac, and fix git alias tab completion.

**Architecture:** Delete dead files (screen, X11, Linux config, docker-machine). Trim vim to core settings + arpeggio + solarized. Reorder bash sourcing so bash-completion loads before aliases, then add `__git_complete` calls.

**Tech Stack:** Bash, Vim, Git

**Spec:** `docs/superpowers/specs/2026-04-05-dotfiles-cleanup-design.md`

---

### Task 1: Delete dead files

**Files:**
- Delete: `screenrc`
- Delete: `xinitrc`
- Delete: `Xmodmap`
- Delete: `bash/linux.sh`
- Delete: `bash/docker-machine-completion.sh`

- [ ] **Step 1: Remove the files**

```bash
git rm screenrc xinitrc Xmodmap bash/linux.sh bash/docker-machine-completion.sh
```

- [ ] **Step 2: Commit**

```bash
git commit -m "remove dead config: screen, X11, linux, docker-machine"
```

---

### Task 2: Trim vimrc

**Files:**
- Modify: `vimrc`

The current working tree has uncommitted arpeggio cleanup (removed NERDTree, fugitive, ropevim mappings). This task builds on that by removing all remaining dead config.

- [ ] **Step 1: Replace vimrc with trimmed version**

Write this content to `vimrc`:

```vim
set nocompatible

syn on
set shiftwidth=4
set noexpandtab
set autoindent

autocmd FileType markdown setlocal expandtab softtabstop=4 tabstop=8
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd FileType python setlocal expandtab softtabstop=4 tabstop=8
autocmd FileType ruby setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
autocmd FileType html setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=8
autocmd FileType javascript setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
autocmd FileType coffee setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
autocmd FileType htmldjango setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=8
autocmd FileType sh setlocal tabstop=8 expandtab
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4

set showmatch
set number
set foldmethod=indent

source $HOME/.vim/plugins

" Explicitly support 256 colors
set t_Co=256
set background=dark
let g:solarized_contrast="high"
colorscheme solarized

" wrap long lines and display them
setlocal wrap linebreak nolist
set virtualedit=
setlocal display+=lastline

noremap  <buffer> <silent> <Up>   gk
noremap  <buffer> <silent> <Down> gj
inoremap <buffer> <silent> <Up>   <C-o>gk
inoremap <buffer> <silent> <Down> <C-o>gj

" Moving around long lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

map <A-j> yyP
highlight Comment term=NONE ctermfg=Cyan

" Highlight things longer than 100 characters
set ruler
:match ErrorMsg '\%>100v.\+'
:set cc=78

" wildmenu shows menu suggestions
set wildmenu
set wildmode=longest:full
set completeopt+=longest
set wildignore+=*.pyc,*.git,*.o,*.class
set wildignorecase

" Store *.swp files in ~/.vim/swap
set directory=$HOME/.vim/swap//

" persistent undo
set undofile
set undodir=$HOME/.vim/undo//

" Arpeggio
call arpeggio#load()
" I'm too slow to hit j & f together, so lengthen the timeout on them
let g:arpeggio_timeoutlens = {'j':100, 'f':100}
Arpeggio inoremap jk <Esc>
Arpeggio noremap jf :w<CR>
Arpeggio noremap ls :ls<CR>
" Buffer movement
Arpeggio noremap wq <C-w>q
Arpeggio noremap wj <C-w>j
Arpeggio noremap wk <C-w>k
Arpeggio noremap wh <C-w>h
Arpeggio noremap wl <C-w>l
Arpeggio noremap ws <C-w>s
Arpeggio noremap wv <C-w>v
" fast up & down
Arpeggio noremap fd 10j
Arpeggio noremap fu 10k

set laststatus=2

" Use the system clipboard
"set clipboard=unnamedplus

" OSX brew-installed vim... breaks backspace? This fixes it.
set backspace=2
```

Removed: `guifont`, SmartHome/SmartEnd, ctags, NERDTree comments, flake8 comment, SuperTab, Go plugins + rtp, Syntastic, fugitive statusline, `statline_syntastic`, YCM/pipenv, `Marked()`, `syntax on` duplicate, `au BufRead ... *.go` (covered by filetype autocmd above).

- [ ] **Step 2: Verify vim launches without errors**

```bash
vim -u vimrc +q 2>&1
```

This will likely show errors about arpeggio not being found (plugins not installed in this directory context) — that's expected. The important thing is no vimscript syntax errors.

- [ ] **Step 3: Commit**

```bash
git add vimrc
git commit -m "trim vimrc: remove dead plugin config, keep arpeggio + solarized"
```

---

### Task 3: Trim vim/plugins

**Files:**
- Modify: `vim/plugins`

- [ ] **Step 1: Replace vim/plugins with trimmed version**

Write this content to `vim/plugins`:

```vim
" Vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/vundle'
Plugin 'kana/vim-arpeggio'
Plugin 'altercation/vim-colors-solarized'

call vundle#end()
filetype plugin indent on
```

Removed: syntastic, fugitive, flake8, indentpython, vim-go, vim-colorschemes (flazz), YouCompleteMe, afterglow, supertab.

- [ ] **Step 2: Commit**

```bash
git add vim/plugins
git commit -m "trim vim plugins to arpeggio + solarized only"
```

---

### Task 4: Clean up bash_profile

**Files:**
- Modify: `bash_profile`

- [ ] **Step 1: Replace bash_profile with just the bashrc source**

Write this content to `bash_profile`:

```bash
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
```

Removed: RVM sourcing, commented-out openssl and terraform lines.

- [ ] **Step 2: Commit**

```bash
git add bash_profile
git commit -m "clean up bash_profile: remove dead RVM/openssl/terraform lines"
```

---

### Task 5: Simplify mybashrc

**Files:**
- Modify: `mybashrc`

- [ ] **Step 1: Replace mybashrc with simplified version**

Write this content to `mybashrc`:

```bash
BD=$HOME/.bash

. $BD/all_platforms.sh
. $BD/osx.sh
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

Key changes: removed platform conditionals (`OSX_UNAME`/`LINUX_UNAME`, `uname -s` case), removed `docker-machine-completion.sh` sourcing, removed WSL commented block. Source order now: `all_platforms.sh` → `osx.sh` (loads bash-completion) → `aliases.sh` (uses `__git_complete`) → `PS1.sh`.

- [ ] **Step 2: Commit**

```bash
git add mybashrc
git commit -m "simplify mybashrc: remove platform conditionals, fix source order"
```

---

### Task 6: Remove ruby from osx.sh

**Files:**
- Modify: `bash/osx.sh`

- [ ] **Step 1: Remove chruby/ruby lines**

Remove these three lines from `bash/osx.sh`:

```bash
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.2.1
```

And the blank lines around them. The file should contain:

```bash
export BASH_SILENCE_DEPRECATION_WARNING=1
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Git completion
# if on osx then 'brew install bash-completion'
# see https://github.com/bobthecow/git-flow-completion/wiki/Install-Bash-git-completion
if hash brew 2> /dev/null; then
    if [ -f `brew --prefix`/etc/bash_completion ]; then
	. `brew --prefix`/etc/bash_completion
    fi
fi

# libpq
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"

# ghostty
export PATH="$PATH:/Applications/Ghostty.app/Contents/MacOS"
```

- [ ] **Step 2: Commit**

```bash
git add bash/osx.sh
git commit -m "remove ruby/chruby from osx.sh"
```

---

### Task 7: Fix git alias tab completion

**Files:**
- Modify: `bash/aliases.sh`

- [ ] **Step 1: Remove wrap_alias function and invocation**

Remove everything from line 57 (`# wrap_alias provides argument tab-completion in bash.`) through line 124 (`unset wrap_alias`). This is the entire `wrap_alias` function, its comment block, the `eval` invocation, and the `unset`.

- [ ] **Step 2: Add __git_complete calls at the bottom of aliases.sh**

Append to the end of `bash/aliases.sh`:

```bash

# Git alias tab completion (requires bash-completion loaded before this file)
if type __git_complete &>/dev/null; then
    __git_complete gc _git_checkout
    __git_complete gb _git_branch
    __git_complete ga _git_add
    __git_complete gp _git_pull
    __git_complete gpr _git_pull
    __git_complete gd _git_diff
    __git_complete gl _git_log
fi
```

- [ ] **Step 3: Test tab completion works**

Open a new bash shell and test:

```bash
source ~/.mybashrc
gc <tab>    # Should show branch names
gb <tab>    # Should show branch names
gd <tab>    # Should show files/branches
```

- [ ] **Step 4: Commit**

```bash
git add bash/aliases.sh
git commit -m "fix git alias tab completion with __git_complete"
```

---

### Task 8: Simplify setup.sh

**Files:**
- Modify: `setup.sh`

- [ ] **Step 1: Replace setup.sh with simplified version**

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
    rm -f $HOME/.bash_profile
    ln -s `pwd`/bash_profile $HOME/.bash_profile
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

Changes: removed `_linux()`, removed `all_platforms()` wrapper (just call functions directly), removed screenrc symlinking, removed Vundle clone + `PluginInstall` from `_vim()`, removed `OSX_UNAME`/`LINUX_UNAME` variables, removed `uname -s` case block at bottom, removed `uname -s` case in `_bash()` (always link bash_profile), added `mkdir` for `.vim/undo`, changed `rm` to `rm -f` to avoid errors on first run.

- [ ] **Step 2: Commit**

```bash
git add setup.sh
git commit -m "simplify setup.sh: remove linux, screen, auto-PluginInstall"
```

---

### Task 9: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Replace CLAUDE.md with updated version**

Write this content to `CLAUDE.md`:

```markdown
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repo for a single Mac. Files are symlinked into `$HOME` by `setup.sh`.

## Setup

```bash
./setup.sh
```

Symlinks config files into `$HOME` (`.vimrc`, `.mybashrc`, `.bash_profile`, `.gitglobalignore`). Vim plugins require a one-time manual install: clone Vundle into `~/.vim/bundle/Vundle.vim`, then run `vim -u ~/.vim/plugins +PluginInstall +qall`.

## Architecture

- **`setup.sh`** — Entry point. Symlinks everything via `_vim`, `_bash`, `_git`, `_claude` functions. Uses `rm -f` then `ln -s` pattern.
- **`mybashrc`** — Sources bash config files in order: `all_platforms.sh` → `osx.sh` (Homebrew, bash-completion) → `aliases.sh` (git aliases + `__git_complete`) → `PS1.sh`. Also loads Google Cloud SDK, direnv, and the `blaude` alias.
- **`bash/`** — Modular bash config:
  - `all_platforms.sh` — History search, `git-mop` branch cleanup, editor config
  - `osx.sh` — Homebrew, bash-completion, libpq, Ghostty PATH
  - `aliases.sh` — Git aliases (`gs`, `gc`, `push`, etc.) with `__git_complete` tab completion
  - `PS1.sh` — Prompt with git branch display
- **`bash/api_keys.sh`** — Gitignored; holds local API keys
- **`vimrc`** + **`vim/`** — Vim config with arpeggio key chords and solarized colorscheme. Plugins managed by Vundle (arpeggio + solarized only).
- **`claude/`** — Default Claude Code config (`~/.claude/`):
  - `settings.json` — Symlinked to `~/.claude/settings.json`
  - `statusline-command.sh` — Symlinked into both `~/.claude/` and `~/.claude-bacio/`
- **`claude-bacio/`** — Blaude config (`~/.claude-bacio/`):
  - `settings.json` — Symlinked to `~/.claude-bacio/settings.json`

## Key Conventions

- Two Claude Code configs: default (`~/.claude/`) for work, personal (`~/.claude-bacio/`) via the `blaude` alias (`CLAUDE_CONFIG_DIR=~/.claude-bacio`).
- `git-mop` (in `all_platforms.sh`) cleans merged branches; use `-c` flag to actually delete (dry-run by default).
- Source order in `mybashrc` matters: `osx.sh` must load before `aliases.sh` so `__git_complete` has the git completion functions available.
```

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "update CLAUDE.md for simplified repo"
```
