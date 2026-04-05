# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repo for syncing shell, editor, and system config across macOS and Linux machines. Files are symlinked into `$HOME` by `setup.sh`.

## Setup

```bash
./setup.sh
```

This symlinks all config files into `$HOME` (`.vimrc`, `.mybashrc`, `.bash_profile`, `.screenrc`, `.gitglobalignore`, etc.) and installs Vim plugins via Vundle. On Linux, it also links X11 config (`.xinitrc`, `.Xmodmap`).

## Architecture

- **`setup.sh`** — Entry point. Symlinks everything; runs `all_platforms()` then platform-specific setup. Destructive: removes existing dotfiles before linking.
- **`mybashrc`** — Main bash config dispatcher. Sources `bash/*.sh` files and platform-specific config based on `uname -s`.
- **`bash/`** — Modular bash config:
  - `all_platforms.sh` — Cross-platform settings (history search, `git-mop` branch cleanup, editor config)
  - `aliases.sh` — Git aliases (`gs`, `gc`, `push`, etc.), Docker aliases, `wrap_alias` for tab-completion on aliases
  - `osx.sh` — Homebrew, chruby (Ruby 3.2.1), libpq, Ghostty, bash-completion
  - `linux.sh` — Go, CUDA, Google Cloud SDK paths
  - `PS1.sh` — Prompt with git branch display
- **`bash_profile`** → sources `.bashrc`; `bashrc` → sources `.mybashrc`
- **`bash/api_keys.sh`** — Gitignored; holds local API keys
- **`claude/`** — Default Claude Code config (`~/.claude/`):
  - `settings.json` — Symlinked to `~/.claude/settings.json`
  - `statusline-command.sh` — Symlinked into both `~/.claude/` and `~/.claude-bacio/`. Renders git branch, context usage, and quota bars in the status line.
- **`claude-bacio/`** — Blaude config (`~/.claude-bacio/`):
  - `settings.json` — Symlinked to `~/.claude-bacio/settings.json`. Differs from default (has `effortLevel`, `skipDangerousModePermissionPrompt`).

## Key Conventions

- Config is split by platform (`osx.sh` vs `linux.sh`) and sourced conditionally via `uname -s`.
- Two Claude Code configs: default (`~/.claude/`) for work, personal (`~/.claude-bacio/`) via the `blaude` alias in `mybashrc` (`CLAUDE_CONFIG_DIR=~/.claude-bacio`).
- `git-mop` (in `all_platforms.sh`) cleans merged branches; use `-c` flag to actually delete (dry-run by default).
