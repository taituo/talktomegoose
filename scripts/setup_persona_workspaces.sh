#!/usr/bin/env bash
# Prepare per-persona workspaces so each Codex pane operates in its own clone.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_DIR=${BASE_DIR:-"$REPO_ROOT/personas"}
PERSONAS_DEFAULT="Maverick Goose Iceman Phoenix Hangman Rooster Hondo"
PERSONAS=${PERSONAS:-$PERSONAS_DEFAULT}
REMOTE_URL=${REMOTE_URL:-$(git -C "$REPO_ROOT" remote get-url origin 2>/dev/null || echo "")}
DEFAULT_BRANCH=${DEFAULT_BRANCH:-$({
  git -C "$REPO_ROOT" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo "";
} | sed 's#^origin/##')}

if [[ -z "$DEFAULT_BRANCH" ]]; then
  if git -C "$REPO_ROOT" show-ref --verify --quiet refs/heads/master; then
    DEFAULT_BRANCH=master
  elif git -C "$REPO_ROOT" show-ref --verify --quiet refs/heads/main; then
    DEFAULT_BRANCH=main
  else
    DEFAULT_BRANCH=master
  fi
fi

mkdir -p "$BASE_DIR"

for persona in $PERSONAS; do
  workspace="$BASE_DIR/$persona"

  if [[ -d "$workspace/.git" ]]; then
    # Existing clone: ensure remotes and branch are up to date.
    if [[ -n "$REMOTE_URL" ]]; then
      git -C "$workspace" remote set-url origin "$REMOTE_URL" >/dev/null 2>&1 || true
    fi
    git -C "$workspace" fetch origin >/dev/null 2>&1 || true
    git -C "$workspace" checkout "$DEFAULT_BRANCH" >/dev/null 2>&1 || true
    git -C "$workspace" pull --ff-only origin "$DEFAULT_BRANCH" >/dev/null 2>&1 || true
    continue
  fi

  echo "Creating workspace for $persona at $workspace" >&2
  git -C "$REPO_ROOT" clone --local "$REPO_ROOT" "$workspace" >/dev/null 2>&1 || git -C "$REPO_ROOT" clone "$REPO_ROOT" "$workspace" >/dev/null 2>&1

  if [[ -n "$REMOTE_URL" ]]; then
    git -C "$workspace" remote set-url origin "$REMOTE_URL" >/dev/null 2>&1 || true
  fi

  git -C "$workspace" checkout "$DEFAULT_BRANCH" >/dev/null 2>&1 || true
  git -C "$workspace" pull --ff-only origin "$DEFAULT_BRANCH" >/dev/null 2>&1 || true

done
