#!/usr/bin/env bash
# Launch Codex in full-auto mode for a given persona workspace.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE_ROOT="${PERSONA_WORKSPACES:-$REPO_ROOT/personas}"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <Persona> [Codex arguments...]" >&2
  exit 1
fi

persona="$1"
shift || true
workspace="$WORKSPACE_ROOT/$persona"

if [[ ! -d "$workspace" ]]; then
  echo "Workspace not found for persona '$persona' at $workspace." >&2
  echo "Run scripts/setup_persona_workspaces.sh or set PERSONA_WORKSPACES." >&2
  exit 1
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "Codex CLI missing; install it before launching." >&2
  exit 1
fi

exec codex --full-auto --cd "$workspace" "$@"
