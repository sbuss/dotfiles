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
