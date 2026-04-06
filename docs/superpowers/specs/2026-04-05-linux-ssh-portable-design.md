# Linux Support + Portable SSH Config Design

## Goal

Restore Linux platform support in the dotfiles repo and add an `sshc` function that carries a portable bashrc (git aliases + prompt) to ephemeral remote machines.

## Part 1: Restore Linux Support

### `mybashrc`

Re-add `uname -s` case switch to conditionally source `osx.sh` or `linux.sh`. Source order:

1. `$BD/all_platforms.sh`
2. `$BD/osx.sh` OR `$BD/linux.sh` (based on `uname -s`)
3. `$BD/aliases.sh`
4. `$BD/PS1.sh`

Both platform files load bash-completion, so `__git_complete` in `aliases.sh` works on both platforms. Keep Google Cloud SDK, direnv, and blaude alias after the platform-conditional block.

### `bash/linux.sh` (new)

Minimal — just bash-completion loading:

```bash
# Enable bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
```

No Go, CUDA, Docker, or Google Cloud SDK paths (unlike the old version).

### `setup.sh`

Re-add platform awareness:
- `_bash()`: wrap `bash_profile` symlinking in a macOS-only case (Linux doesn't use `.bash_profile` the same way)
- No `_linux()` function needed — there's no X11 config to symlink anymore. The bash dir symlink already makes `linux.sh` available.

## Part 2: Portable SSH Config

### `bash/portable.sh` (new)

A self-contained file with no external dependencies. Contains:

- Git aliases: `gb`, `gs`, `gc`, `gcm`, `ga`, `gl`, `glm`, `gp`, `gpr`, `gap`, `gd`, `push`, `whatdidido`
- Basic aliases: `ll`, `la`, `l`
- `parse_git_branch` function
- PS1 prompt with git branch display

Does NOT contain:
- `__git_complete` calls (requires bash-completion on remote, which may not be installed)
- `dircolors` / color ls (may not be available)
- `brew` anything
- `sshc` itself (avoid recursion)
- Docker/ctags/postgres aliases (not needed on remote)

### `bash/aliases.sh`

Add `sshc` function at the bottom. The function:

1. Reads `$HOME/.bash/portable.sh`
2. Base64-encodes it
3. SSHes to the target with `-t` for TTY allocation
4. On the remote: decodes into a temp file, starts bash with `--rcfile` pointing to it

```bash
sshc() {
    local rc
    rc=$(base64 < "$HOME/.bash/portable.sh")
    ssh -t "$@" "echo '$rc' | base64 -d > /tmp/.bashrc_portable && bash --rcfile /tmp/.bashrc_portable"
}
```

Passes all arguments through to `ssh`, so `sshc user@host`, `sshc -p 2222 host`, etc. all work.

## Files Changed

- **Modify:** `mybashrc` — re-add platform switch
- **Modify:** `bash/aliases.sh` — add `sshc` function
- **Modify:** `setup.sh` — platform-conditional bash_profile linking
- **Modify:** `CLAUDE.md` — document linux support and sshc
- **Create:** `bash/linux.sh` — minimal bash-completion
- **Create:** `bash/portable.sh` — self-contained git aliases + prompt

## Files Not Changed

- `bashrc`, `bash_profile`, `gitglobalignore`
- `bash/all_platforms.sh`, `bash/osx.sh`, `bash/PS1.sh`
- `vimrc`, `vim/`
- `claude/`, `claude-bacio/`
