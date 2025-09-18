#!/usr/bin/env bash
set -euo pipefail

SESSION_NAME=${SESSION_NAME:-goose}
PANES_DEFAULT="lead.0 flightline.0 flightline.1 flightline.2 flightline.3 qa.0 ops.0"
PANES=${PANES:-$PANES_DEFAULT}
PROMPT=${PROMPT:-"Are you finished, if yes say \"STANDBY\""}
INTERVAL=${INTERVAL:-30}
MARKER=${MARKER:-"STANDBY"}
SILENT=${SILENT:-0}

log() {
  if [[ "$SILENT" -ne 1 ]]; then
    printf '%s\n' "$1"
  fi
}

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux not found; install tmux before running this script." >&2
  exit 1
fi

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  echo "tmux session '$SESSION_NAME' not found." >&2
  exit 1
fi

IFS=' ' read -r -a pane_array <<< "$PANES"
if [[ ${#pane_array[@]} -eq 0 ]]; then
  echo "No panes specified." >&2
  exit 1
fi

declare -A acknowledged
for pane in "${pane_array[@]}"; do
  acknowledged[$pane]=0
done

all_finished() {
  for pane in "${pane_array[@]}"; do
    if [[ ${acknowledged[$pane]} -eq 0 ]]; then
      return 1
    fi
  done
  return 0
}

send_prompt() {
  local pane="$1"
  tmux send-keys -t "$SESSION_NAME:$pane" "$PROMPT" C-m
}

check_pane() {
  local pane="$1"
  local output
  if ! output=$(tmux capture-pane -pt "$SESSION_NAME:$pane" -S -200 2>/dev/null); then
    return
  fi
  if grep -Fq "$MARKER" <<< "$output"; then
    if [[ ${acknowledged[$pane]} -eq 0 ]]; then
      acknowledged[$pane]=1
      log "[$(date +%H:%M:%S)] Pane $pane acknowledged with '$MARKER'."
    fi
  fi
}

log "Monitoring panes: ${pane_array[*]} (interval: ${INTERVAL}s, marker: '${MARKER}')"

# initial prompt
for pane in "${pane_array[@]}"; do
  send_prompt "$pane"
  sleep 0.2
done

while true; do
  sleep "$INTERVAL"
  for pane in "${pane_array[@]}"; do
    if [[ ${acknowledged[$pane]} -eq 1 ]]; then
      continue
    fi
    send_prompt "$pane"
  done

  for pane in "${pane_array[@]}"; do
    check_pane "$pane"
  done

  if all_finished; then
    log "All panes responded with '$MARKER'. Exiting."
    exit 0
  fi

done
