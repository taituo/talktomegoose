#!/usr/bin/env bash
set -euo pipefail

SESSION_NAME="goose"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux binary missing; cannot validate session startup" >&2
  exit 1
fi

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  tmux kill-session -t "$SESSION_NAME"
fi

CODEX_DRY_RUN=1 "$REPO_ROOT/scripts/start_tmux_codex.sh" >/tmp/tmux_start.log

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  echo "Expected session '$SESSION_NAME' did not start" >&2
  exit 1
fi

assert_window() {
  local window="$1"
  if ! tmux list-windows -t "$SESSION_NAME" | grep -q "$window"; then
    echo "Window '$window' missing in session '$SESSION_NAME'" >&2
    tmux kill-session -t "$SESSION_NAME"
    exit 1
  fi
}

assert_window command
assert_window flightline
assert_window qa
assert_window ops

# flightline should have four panes for dev personas
PANE_COUNT=$(tmux list-panes -t "$SESSION_NAME":flightline | wc -l)
if [[ "$PANE_COUNT" -ne 4 ]]; then
  echo "Expected 4 panes in flightline, found $PANE_COUNT" >&2
  tmux kill-session -t "$SESSION_NAME"
  exit 1
fi

tmux capture-pane -pt "$SESSION_NAME":flightline.0 > /tmp/pane0.log
if ! grep -q "Persona Goose dry run" /tmp/pane0.log; then
  echo "Goose pane did not receive dry run command" >&2
  tmux kill-session -t "$SESSION_NAME"
  exit 1
fi

# Cleanup
tmux kill-session -t "$SESSION_NAME"
rm -f /tmp/tmux_start.log /tmp/pane0.log

echo "tmux start script validated"
