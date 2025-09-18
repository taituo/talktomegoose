#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run with sudo for package installation." >&2
  exit 1
fi

apt-get update
apt-get install -y tmux curl git build-essential python3 python3-venv

if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt-get install -y nodejs
fi

npm install -g pnpm astro@latest

echo "Development stack install complete."
