# Zsh as Default Shell Design

## Goal

Make zsh the default shell config on macOS (and Linux). Bash config stays for `portable.sh` (used by `sshc` on remote machines) and as legacy fallback.

## New Files

### `myzshrc`

Main zsh config dispatcher, sourced from `~/.zshrc`. Sources in order:

1. `zsh/all_platforms.zsh` — shared config (history search with zsh `bindkey`, `git-mop`, exports, editor)
2. `zsh/osx.zsh` or `zsh/linux.zsh` (platform-conditional via `uname -s`)
3. `zsh/aliases.zsh` — git aliases, `sshc` function
4. `zsh/completion.zsh` — `compinit` + git alias completion
5. `zsh/prompt.zsh` — prompt with git branch

### `zsh/all_platforms.zsh`

Zsh version of `bash/all_platforms.sh`:
- History search via `bindkey "^[[A" history-search-backward` / `"^[[B" history-search-forward`
- `PIP_RESPECT_VIRTUALENV=true`
- `git-mop` function (same syntax, works in zsh)
- `EDITOR=vim`
- API keys sourcing

### `zsh/osx.zsh`

- Homebrew `eval`
- libpq paths
- Ghostty PATH
- No bash-completion needed (zsh has built-in completion)
- No `BASH_SILENCE_DEPRECATION_WARNING` (not applicable to zsh)

### `zsh/linux.zsh`

Minimal — placeholder for future Linux-specific zsh config.

### `zsh/aliases.zsh`

Same git aliases as `bash/aliases.sh`:
- `gb`, `gs`, `gc`, `gcm`, `ga`, `gl`, `glm`, `gp`, `gpr`, `gap`, `gd`, `push`, `whatdidido`
- Basic aliases: `cim`, `cw`, `rmpyc`, `pygrep`, `hgrep`, `ll`, `la`, `l`
- `sshc` function (unchanged — `portable.sh` stays bash for remotes)
- No `__git_complete` — zsh handles this natively via `completion.zsh`

### `zsh/completion.zsh`

- `autoload -Uz compinit && compinit`
- Register git aliases for completion: `compdef _git gc=git-checkout gb=git-branch ga=git-add gp=git-pull gpr=git-pull gd=git-diff gl=git-log gap=git-add`

### `zsh/prompt.zsh`

Same visual style as current bash prompt (hostname, directory, git branch in color) using zsh syntax:
- `%F{cyan}%m %F{blue}%1~%F{red} $(parse_git_branch)%f$ `
- `parse_git_branch` function (same logic, works in zsh)
- Window title via `precmd` hook

## Changes to Existing Files

### `setup.sh`

- Add `_zsh()` function: symlinks `myzshrc` → `~/.myzshrc`, ensures `~/.zshrc` sources it
- Call `_zsh` from main execution
- Remove bash-completion auto-install from `_bash()` macOS section (not needed for zsh; bash users can install manually)

### `CLAUDE.md`

Update to reflect zsh as default, new directory structure.

## Files Not Changed

- `bash/` directory — stays for `portable.sh` (sshc), `all_platforms.sh`, and legacy bash config
- `mybashrc`, `bashrc`, `bash_profile` — stay as legacy fallback
- `vimrc`, `vim/` — no changes
- `claude/`, `claude-bacio/` — no changes
- `gitglobalignore` — no changes

## Notes

- Google Cloud SDK, direnv, and blaude alias move into `myzshrc` (same as `mybashrc`)
- `sshc` stays bash-based: it SSHes to remote machines that have bash, carrying `portable.sh`
- Bash config is not removed, just no longer the primary path on macOS
