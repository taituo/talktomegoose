# Single-VM Operations Guide

## Overview
All personas share one VM and one repo clone. tmux keeps Codex agents isolated per pane while sharing filesystem state.

## VM Requirements
- Ubuntu 22.04 LTS or later
- 8 vCPU, 16 GB RAM, 40 GB disk
- SSH access through shared deploy key stored in `/home/<user>/.ssh/id_ed25519_goose`

## Bootstrap Steps
1. Clone repo using SSH: `git clone git@github.com:taituo/talktomegoose.git`.
2. Run `make bootstrap` to install:
   - tmux >= 3.2
   - Node.js 20.x + pnpm
   - Python3 (for auxiliary scripts)
3. Copy `.env.example` to `.env` and set secrets if needed.
4. Launch `make tmux`.

## tmux Layout
- Session name: `goose`
- Windows:
  1. `command`: root shell, make targets, git graph
  2. `flightline`: four panes for Goose, Iceman, Phoenix, Hangman (`codex --persona <name>`)
  3. `qa`: Rooster pane running tests on loop
  4. `ops`: Hondo pane tailing logs
- Key bindings: prefix `Ctrl-a`, `Ctrl-a r` reloads config, `Ctrl-a D` detaches others.

## Shared Artifacts
- `logs/mission.log` — appended by Maverick after major calls
- `logs/tests/latest.json` — produced by Rooster's test runs
- `handoffs/` — per-shift summaries

## Git Discipline
- Each persona sets `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL` using `scripts/persona_env/<persona>.env`.
- Commit messages follow `<Persona>: <concise message>`.
- Pushes happen from Maverick or Goose after review.

## Failure Recovery
- If a pane crashes, reattach with `tmux attach -t goose` and rerun the persona bootstrap:
  ```bash
  source scripts/persona_env/<persona>.env
  codex --persona <persona> --cwd /workspace/talktomegoose
  ```
- Keep backups of `logs/` and `docs/` in external storage nightly.

## Network Constraints
- Outbound internet limited to GitHub, Node registries, and telemetry sink.
- Use `make fetch-deps` to download dependencies via curated mirrors when offline.

## Testing Matrix
| Persona | Responsibility | Trigger |
|---------|----------------|---------|
| Goose   | `make lint`    | On PR open |
| Iceman  | `make test-unit` | Before review |
| Rooster | `make verify`  | On merge |

## Communication
All updates captured using radio checks (see `docs/communication/radio-checks.md`). Ops retains daily digests in `handoffs/`.
