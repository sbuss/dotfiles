# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repo for macOS and Linux. Files are symlinked into `$HOME` by `setup.sh`. Zsh is the default shell; bash config is kept for `sshc` remote sessions and as legacy fallback.

## Setup

```bash
./setup.sh
```

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
