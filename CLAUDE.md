# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repo for macOS and Linux. Files are symlinked into `$HOME` by `setup.sh`.

## Setup

```bash
./setup.sh
```

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
