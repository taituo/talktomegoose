#!/usr/bin/env bash
set -euo pipefail

cat <<'MSG'
Talk to Me Goose (archived)
---------------------------
Automated tmux orchestration was removed during the archive cleanup.

Future rebuild idea (see docs/roadmap.md):
  - create git worktrees per persona
  - open tmux session "goose" with panes pointing at each worktree
  - launch Codex in each pane with the appropriate prompt

For now, start tmux manually:
  tmux new-session -s goose
  # add windows/panes as needed

MSG
