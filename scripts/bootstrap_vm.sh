#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run with sudo for package installation." >&2
  exit 1
fi

apt-get update
apt-get install -y tmux

echo "Bootstrap complete (tmux installed)."
