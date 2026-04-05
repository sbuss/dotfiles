#!/usr/bin/env bash
# Claude Code status line: git branch, worktree info, commits behind main,
# model name, context usage, and quota bars.

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')

# ---------------------------------------------------------------------------
# Helper: render a compact progress bar  [####......] pct%
# Usage: make_bar <used_pct> <width>
# ---------------------------------------------------------------------------
make_bar() {
  local pct="${1:-0}"
  local width="${2:-10}"
  local filled
  filled=$(echo "$pct $width" | awk '{printf "%d", ($1/100)*$2 + 0.5}')
  [ "$filled" -gt "$width" ] && filled=$width
  local empty=$(( width - filled ))
  local bar=""
  local i
  for i in $(seq 1 "$filled"); do bar="${bar}#"; done
  for i in $(seq 1 "$empty");  do bar="${bar}."; done
  printf "[%s] %d%%" "$bar" "$pct"
}

# ---------------------------------------------------------------------------
# Git section
# ---------------------------------------------------------------------------
git_out=""
if [ -n "$cwd" ]; then
  branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    worktree_name=$(echo "$input" | jq -r '.worktree.name // empty')
    behind=$(git -C "$cwd" -c gc.auto=0 rev-list --count "HEAD..origin/main" 2>/dev/null)

    git_out="branch: $branch"
    # Detect worktree: compare cwd's toplevel against the main worktree root
    wt_toplevel=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
    main_wt_root=$(git -C "$cwd" -c gc.auto=0 worktree list --porcelain 2>/dev/null | awk '/^worktree / { print $2; exit }')
    if [ -n "$main_wt_root" ] && [ -n "$wt_toplevel" ] && [ "$wt_toplevel" != "$main_wt_root" ]; then
      rel_wt="${wt_toplevel#$main_wt_root/}"
      git_out="$git_out  worktree: $rel_wt"
    fi
    if [ -n "$behind" ] && [ "$behind" -gt 0 ]; then
      git_out="$git_out  (${behind} behind main)"
    fi
  fi
fi

# ---------------------------------------------------------------------------
# Model name
# ---------------------------------------------------------------------------
model_name=$(echo "$input" | jq -r '.model.display_name // empty')

# ---------------------------------------------------------------------------
# Context usage bar
# ---------------------------------------------------------------------------
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_out=""
if [ -n "$ctx_pct" ]; then
  ctx_bar=$(make_bar "$(printf '%.0f' "$ctx_pct")" 10)
  ctx_out="ctx: $ctx_bar"
fi

# ---------------------------------------------------------------------------
# Rate limit bars (5-hour session and 7-day weekly)
# ---------------------------------------------------------------------------
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

quota_out=""
if [ -n "$five_pct" ]; then
  five_bar=$(make_bar "$(printf '%.0f' "$five_pct")" 10)
  quota_out="5h: $five_bar"
fi
if [ -n "$week_pct" ]; then
  week_bar=$(make_bar "$(printf '%.0f' "$week_pct")" 10)
  if [ -n "$quota_out" ]; then
    quota_out="$quota_out  7d: $week_bar"
  else
    quota_out="7d: $week_bar"
  fi
fi

# ---------------------------------------------------------------------------
# Assemble final output
# Line 1: git info and model name
# Line 2: percentage bars (context, quota)
# ---------------------------------------------------------------------------
line1="$git_out"

line2=""
for section in "$model_name" "$ctx_out" "$quota_out"; do
  if [ -n "$section" ]; then
    if [ -n "$line2" ]; then
      line2="$line2  |  $section"
    else
      line2="$section"
    fi
  fi
done

if [ -n "$line1" ] && [ -n "$line2" ]; then
  printf "%s\n%s" "$line1" "$line2"
elif [ -n "$line1" ]; then
  printf "%s" "$line1"
elif [ -n "$line2" ]; then
  printf "%s" "$line2"
fi
