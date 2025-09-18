#!/usr/bin/env bash
set -euo pipefail

SESSION_NAME="goose"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_DRY_RUN=${CODEX_DRY_RUN:-}
WORKSPACE_ROOT="${PERSONA_WORKSPACES:-$REPO_ROOT/personas}"

BASE_DIR="$WORKSPACE_ROOT" "$REPO_ROOT/scripts/setup_persona_workspaces.sh"

CODEX_SUPPORTS_PERSONA=0
if command -v codex >/dev/null 2>&1; then
  if codex --help 2>/dev/null | grep -q -- '--persona'; then
    CODEX_SUPPORTS_PERSONA=1
  fi
fi

launch_codex() {
  local pane="$1"
  local persona="$2"
  local env_file="$REPO_ROOT/scripts/persona_env/${persona}.env"
  local workspace_dir="$WORKSPACE_ROOT/$persona"

  if [[ ! -d "$workspace_dir" ]]; then
    echo "Workspace for $persona missing at $workspace_dir; falling back to repo root." >&2
    workspace_dir="$REPO_ROOT"
  fi
  local cmd

  if [[ -n "$CODEX_DRY_RUN" ]]; then
    cmd="source $env_file && cd $workspace_dir && echo 'Persona ${persona} dry run — workspace: $workspace_dir — awaiting Codex attach.'"
  else
    if [[ "$CODEX_SUPPORTS_PERSONA" -eq 1 ]]; then
      cmd="source $env_file && cd $workspace_dir && if command -v codex >/dev/null 2>&1; then codex --persona $persona --cwd $workspace_dir; else echo 'Codex CLI missing; install before flight.'; exec bash; fi"
    else
      cmd="source $env_file && cd $workspace_dir && if command -v codex >/dev/null 2>&1; then echo 'Persona ${persona} pane ready in $workspace_dir. Launch Codex manually and paste the base prompt from from_to.md.'; codex --cd $workspace_dir; else echo 'Codex CLI missing; install before flight.'; exec bash; fi"
    fi
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
tmux new-window -t "$SESSION_NAME" -n lead -c "$WORKSPACE_ROOT/Maverick"
launch_codex "$SESSION_NAME":lead.0 Maverick

# Window 3: flightline (Goose, Iceman, Phoenix, Hangman)
tmux new-window -t "$SESSION_NAME" -n flightline -c "$WORKSPACE_ROOT/Goose"
tmux split-window -t "$SESSION_NAME":flightline -h -c "$WORKSPACE_ROOT/Iceman"
tmux split-window -t "$SESSION_NAME":flightline.0 -v -c "$WORKSPACE_ROOT/Phoenix"
tmux split-window -t "$SESSION_NAME":flightline.1 -v -c "$WORKSPACE_ROOT/Hangman"
launch_codex "$SESSION_NAME":flightline.0 Goose
launch_codex "$SESSION_NAME":flightline.1 Iceman
launch_codex "$SESSION_NAME":flightline.2 Phoenix
launch_codex "$SESSION_NAME":flightline.3 Hangman

# Window 4: qa (Rooster)
tmux new-window -t "$SESSION_NAME" -n qa -c "$WORKSPACE_ROOT/Rooster"
launch_codex "$SESSION_NAME":qa.0 Rooster

# Window 5: ops (Hondo)
tmux new-window -t "$SESSION_NAME" -n ops -c "$WORKSPACE_ROOT/Hondo"
launch_codex "$SESSION_NAME":ops.0 Hondo

tmux select-window -t "$SESSION_NAME":command
echo "tmux session '$SESSION_NAME' deployed. Attach with: tmux attach -t $SESSION_NAME"
