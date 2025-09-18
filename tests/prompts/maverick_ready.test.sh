#!/usr/bin/env bash
set -euo pipefail

FILE="from_to.md"
SEARCH_TERMS=("Ready Check" "Boilerplate Usage" "Codex Access" "Simulation Remote" "Personas joining")

for term in "${SEARCH_TERMS[@]}"; do
  if ! grep -q "$term" "$FILE"; then
    echo "Missing required Ready Check term '$term' in $FILE" >&2
    exit 1
  fi
done

echo "Maverick ready check template verified"
