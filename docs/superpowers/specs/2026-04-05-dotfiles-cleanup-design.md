# Dotfiles Cleanup Design

## Goal

Strip the dotfiles repo down to what's actively used (bash, git, Claude config on a single Mac), fix git alias tab completion, and remove dead config for vim, screen, Linux, and deprecated tools.

## Files to Delete

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

### `vimrc`

Strip down to essential settings. Remove all plugin-dependent config except arpeggio.

**Keep:**
- Basic settings: `nocompatible`, `syn on`, `shiftwidth`, `autoindent`, `number`, `showmatch`, `backspace=2`
- Filetype indentation rules (python, markdown, sh, html, js, go) — keep coffee/ruby/htmldjango too, cheap insurance
- Color: `t_Co=256`, `background=dark`, `colorscheme solarized`, solarized contrast setting
- `highlight Comment` override
- Column width: `set cc=78`, `:match ErrorMsg` for >100 chars, `set ruler`
- Clipboard: `"set clipboard=unnamedplus` (commented out, as-is)
- Line wrapping display + `j`/`k` → `gj`/`gk` mappings
- `wildmenu`, `wildmode`, `wildignore`, `wildignorecase`
- Swap dir (`~/.vim/swap//`) and undo dir (`~/.vim/undo//`), `set undofile`
- `set laststatus=2`
- Arpeggio `call arpeggio#load()` + all arpeggio mappings
- `source $HOME/.vim/plugins`
- `set foldmethod=indent`

**Remove:**
- `set guifont` (GUI vim)
- SmartHome/SmartEnd functions + Home/End key mappings
- `set tags=` (ctags)
- `Marked()` function + arpeggio `md` mapping for it
- `set rtp+=$GOROOT/misc/vim` + Go plugin config (lines 187–204)
- Syntastic config (lines 222–230) + statusline references to Syntastic
- Fugitive statusline (`fugitive#statusline()`)
- SuperTab config (`omnifunc`, `SuperTabDefaultCompletionType`)
- YCM/pipenv integration (lines 237–250)
- NERDTree references (already commented)
- `statline_syntastic` variable
- Duplicate `syntax on` at line 189

### `vim/plugins`

Trim to just the plugins still needed:
- `gmarik/vundle` (Vundle itself)
- `kana/vim-arpeggio` (arpeggio mappings)
- `altercation/vim-colors-solarized` (colorscheme)

Remove: syntastic, fugitive, flake8, indentpython, vim-go, vim-colorschemes (flazz), YouCompleteMe, afterglow, supertab.

### `vim/colors/obsidian-sbuss.vim`

No changes — keep as-is.

### `setup.sh`

Simplify `_vim()`: remove Vundle clone + `PluginInstall` auto-run (user can run manually if needed). Keep symlinks for `.vimrc`, `.vim/plugins`, `.vim/colors`. Keep `mkdir` for `.vim/swap` and `.vim/undo`.

Remove:
- `_linux()` function entirely
- `rm $HOME/.screenrc` and `ln -s ... screenrc` lines

Keep: `_bash()`, `_git()`, `_claude()`, `_vim()`. Remove the `case` block for Linux at the bottom. `all_platforms()` becomes `_vim`, `_bash`, `_git`, `_claude`.

### `CLAUDE.md`

Update to reflect:
- Simplified structure (no screen, Linux, X11)
- Vim kept but trimmed (only arpeggio + solarized plugins)
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
- `vim/colors/obsidian-sbuss.vim` — custom colorscheme

## Resulting Repo Structure

```
.gitignore
bash_profile
bashrc
mybashrc
gitglobalignore
setup.sh
CLAUDE.md
vimrc
vim/
  plugins
  colors/
    obsidian-sbuss.vim
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
