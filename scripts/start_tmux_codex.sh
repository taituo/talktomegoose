#!/usr/bin/env bash
set -euo pipefail

SESSION_NAME="goose"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_DRY_RUN=${CODEX_DRY_RUN:-}

launch_codex() {
  local pane="$1"
  local persona="$2"
  local env_file="$REPO_ROOT/scripts/persona_env/${persona}.env"
  local cmd

  if [[ -n "$CODEX_DRY_RUN" ]]; then
    cmd="source $env_file && cd $REPO_ROOT && echo 'Persona ${persona} dry run — awaiting Codex attach.'"
  else
    cmd="source $env_file && cd $REPO_ROOT && if command -v codex >/dev/null 2>&1; then codex --persona $persona --cwd $REPO_ROOT; else echo 'Codex CLI missing; install before flight.'; exec bash; fi"
  fi

  tmux send-keys -t "$pane" "$cmd" C-m
}

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  echo "tmux session '$SESSION_NAME' already active."
  exit 0
fi

# Window 1: command
TMUX='' tmux new-session -d -s "$SESSION_NAME" -n command -c "$REPO_ROOT"
tmux send-keys -t "$SESSION_NAME":command "clear && ls" C-m

# Window 2: lead (Maverick)
tmux new-window -t "$SESSION_NAME" -n lead -c "$REPO_ROOT"
launch_codex "$SESSION_NAME":lead.0 Maverick

# Window 3: flightline (Goose, Iceman, Phoenix, Hangman)
tmux new-window -t "$SESSION_NAME" -n flightline -c "$REPO_ROOT"
tmux split-window -t "$SESSION_NAME":flightline -h -c "$REPO_ROOT"
tmux split-window -t "$SESSION_NAME":flightline.0 -v -c "$REPO_ROOT"
tmux split-window -t "$SESSION_NAME":flightline.2 -v -c "$REPO_ROOT"
launch_codex "$SESSION_NAME":flightline.0 Goose
launch_codex "$SESSION_NAME":flightline.1 Iceman
launch_codex "$SESSION_NAME":flightline.2 Phoenix
launch_codex "$SESSION_NAME":flightline.3 Hangman

# Window 4: qa (Rooster)
tmux new-window -t "$SESSION_NAME" -n qa -c "$REPO_ROOT"
launch_codex "$SESSION_NAME":qa.0 Rooster

# Window 5: ops (Hondo)
tmux new-window -t "$SESSION_NAME" -n ops -c "$REPO_ROOT"
launch_codex "$SESSION_NAME":ops.0 Hondo

tmux select-window -t "$SESSION_NAME":command
echo "tmux session '$SESSION_NAME' deployed. Attach with: tmux attach -t $SESSION_NAME"
