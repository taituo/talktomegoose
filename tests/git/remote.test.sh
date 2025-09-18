#!/usr/bin/env bash
set -euo pipefail

REMOTE_NAME=${REMOTE_NAME:-talktomegoose_test}
REMOTE_URL=${REMOTE_URL:-git@github.com:taituo/talktomegoose_test.git}

if ! command -v git >/dev/null 2>&1; then
  echo "git binary missing; cannot verify remote communication" >&2
  exit 1
fi

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [[ -z "$repo_root" ]]; then
  echo "Run this test from within a git repository" >&2
  exit 1
fi

current_url=$(git config --get remote."$REMOTE_NAME".url || true)
if [[ -z "$current_url" ]]; then
  echo "Configuring remote '$REMOTE_NAME' -> $REMOTE_URL for test" >&2
  git remote add "$REMOTE_NAME" "$REMOTE_URL" >/dev/null 2>&1 || git remote set-url "$REMOTE_NAME" "$REMOTE_URL"
else
  echo "Remote '$REMOTE_NAME' already configured as $current_url"
fi

if ! git ls-remote "$REMOTE_URL" HEAD >/tmp/remote_test_refs.log 2>/tmp/remote_test_error.log; then
  echo "Failed to reach $REMOTE_URL. See /tmp/remote_test_error.log" >&2
  exit 1
fi

cat /tmp/remote_test_refs.log
rm -f /tmp/remote_test_refs.log /tmp/remote_test_error.log

echo "Remote communication validated for $REMOTE_URL"
