# Dotfiles Cleanup Design

## Goal

Strip the dotfiles repo down to what's actively used (bash, git, Claude config on a single Mac), fix git alias tab completion, and remove dead config for vim, screen, Linux, and deprecated tools.

## Files to Delete

- `vimrc`
- `vim/` (entire directory — plugins, colors)
- `screenrc`
- `xinitrc`
- `Xmodmap`
- `bash/linux.sh`
- `bash/docker-machine-completion.sh`

## File Changes

### `mybashrc`

Remove the platform-conditional `uname -s` switch. Source files in this order:

1. `$BD/all_platforms.sh`
2. `$BD/osx.sh` (loads Homebrew and bash-completion)
3. `$BD/aliases.sh` (defines aliases + git completion bindings)
4. `$BD/PS1.sh`

Keep the Google Cloud SDK lines and `direnv hook` at the bottom. Remove the `BD` variable's dependency on platform detection (it's always `$HOME/.bash`). Remove the WSL commented block.

### `bash/osx.sh`

Remove chruby/ruby lines (the `source chruby.sh`, `source auto.sh`, and `chruby ruby-3.2.1` lines). Keep:

- `BASH_SILENCE_DEPRECATION_WARNING`
- Homebrew `eval`
- bash-completion loading
- libpq paths
- Ghostty PATH

### `bash/aliases.sh`

Remove the entire `wrap_alias` function (lines 67–118), its invocation (line 122), and the `unset wrap_alias` line. Add `__git_complete` calls at the bottom for all git aliases that benefit from completion:

```bash
# Git alias tab completion (requires bash-completion loaded first)
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

Guarded by `type` check so it's a no-op if bash-completion isn't available. Includes `gpr` (pull --rebase) since it also takes remote/branch args.

### `setup.sh`

Remove:
- `_vim()` function entirely
- `_linux()` function entirely
- `rm $HOME/.screenrc` and `ln -s ... screenrc` lines

Keep: `_bash()`, `_git()`, `_claude()`. Remove the `case` block for Linux at the bottom. `all_platforms()` becomes just `_bash`, `_git`, `_claude`.

### `CLAUDE.md`

Update to reflect:
- Simplified structure (no vim, screen, Linux, X11)
- New source order in `mybashrc`
- Git alias completion via `__git_complete`
- Remove references to deleted files

### `bash_profile`

Remove dead lines: RVM sourcing, commented-out openssl/terraform. Keep only the `.bashrc` source.

## Files Not Changed

- `bashrc` — still sources `.mybashrc`, no changes needed
- `gitglobalignore` — still useful
- `claude/`, `claude-bacio/` — just added, no changes
- `bash/all_platforms.sh` — `git-mop`, history search, editor config all still used
- `bash/PS1.sh` — prompt with git branch still used

## Resulting Repo Structure

```
.gitignore
bash_profile
bashrc
mybashrc
gitglobalignore
setup.sh
CLAUDE.md
bash/
  aliases.sh
  all_platforms.sh
  osx.sh
  PS1.sh
  api_keys.sh (gitignored)
claude/
  settings.json
  statusline-command.sh
claude-bacio/
  settings.json
```
