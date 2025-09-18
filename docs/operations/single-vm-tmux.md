# Single-VM Operations Guide

## Overview
All personas share one VM but operate from individual Git workspaces located at `personas/<Persona>/`. tmux keeps Codex agents isolated per pane while the operator (Ground Control) manages approvals and infrastructure. `make tmux` provisions the workspaces automatically so each pane can pull, branch, and commit without stepping on another persona.

## VM Requirements
- Ubuntu 22.04 LTS or later
- 8 vCPU, 16 GB RAM, 40 GB disk
- SSH access through shared deploy key stored in `/home/<user>/.ssh/id_ed25519_goose`
- ChatGPT Plus (or higher) account with Codex access; see `docs/operations/codex-requirements.md`

## Bootstrap Steps
1. Clone repo using SSH: `git clone git@github.com:taituo/talktomegoose.git`.
2. Aja `make bootstrap` asentaaksesi tmuxin (tai käytä omaa paketinhallintaa). Tarvitsetko Node 20:n, pnpm:n, Astron ja Python-työkalut valmiiksi? Aja silloin `make app`.
3. Copy `.env.example` to `.env` and set secrets if needed.
4. Launch `make mission-control` (alias: `make tmux`) to deploy the `goose` session (or run `make mission-all` / `make demotime` to perform cloning, dependency install, venv, and checks in one go). The launch script calls `scripts/setup_persona_workspaces.sh` to create/refresh per-persona clones under `personas/`.
5. Before personas start coding, run `make test-unit` to confirm the FastAPI template imports successfully; Rooster logs the result.
6. Cycle `make verify` (lint + pnpm test) prior to merges; set `ENABLE_TELEMETRY_TEST=1` when the telemetry endpoint exists.
7. Need local or private remotes? Use `make start-local-registry` or `LOCAL_DEMO_REPO=/path/to/bare.git make mission-all` to switch away from the default GitHub repo.

## tmux Layout
- Session name: `goose`
- Windows:
  1. `command`: root shell, make targets, git graph (repo root)
  2. `flightline`: neljä paneelia Gooselle, Icemanille, Phoenixille ja Hangmanille (käynnistyy automaattisesti `personas/<Persona>`-hakemistoon `codex --full-auto` -tilassa)
  3. `qa`: Rooster-paneeli testejä varten (`personas/Rooster`)
  4. `ops`: Hondo-paneeli logien seurantaan (`personas/Hondo`)
- Key bindings: prefix `Ctrl-a`, `Ctrl-a r` reloads config, `Ctrl-a D` detaches others.

## Persona Workspaces
- `scripts/setup_persona_workspaces.sh` maintains the clones under `personas/<Persona>/` (ignored by Git).
- Each workspace tracks the default branch (e.g., `master`); personas can `git pull` to sync with Maverick’s latest changes, then branch locally (`feature/goose-...`) before committing.
- Override the workspace root by exporting `PERSONA_WORKSPACES=/some/path` prior to running `make tmux`.
- Use `make mission-clean` to tear down tmux and demo services when rotating crews or resetting the VM.

## Shared Artifacts
- `logs/mission.log` — appended by Maverick after major calls
- `logs/tests/latest.json` — produced by Rooster's test runs
- `handoffs/` — per-shift summaries
- `handoffs/inbox.md` — queue of persona tasks seeded by Maverick
- Git remote `talktomegoose_test` — external playground repo used to validate communication tests
- `docs/templates/fastapi.md` — template hangar status

## Git Discipline
- Each persona sets `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL` using `scripts/persona_env/<persona>.env`.
- Commit messages follow `<Persona>: <concise message>`.
- Pushes happen from Maverick or Goose after review.
- Maintain access to simulation remote `git@github.com:taituo/talktomegoose_test.git`; tests will configure it automatically if reachable.
- Inbox discipline: personas claim work in `handoffs/inbox.md`; Maverick controls the first commit on each new mission and directs the target branch.
- Developer loop: `git pull`, review inbox/spec files, update code, run `make verify`, push commits.
- Hondo (manager) maintains a CHANGELOG (e.g., `docs/communication/changelog.md`) summarizing each mission cycle.

## Prompt Watchdog
- Use `scripts/codex_prompt_watch.sh` to broadcast a reminder to each persona pane every 30 seconds (default) until the pane responds with `STANDBY`.
- Example: `./scripts/codex_prompt_watch.sh` or `INTERVAL=60 PANES="lead.0 flightline.0" ./scripts/codex_prompt_watch.sh`.
- The script captures pane output with `tmux capture-pane`; the marker can be changed via `MARKER="DONE"`.
- Stop monitoring by pressing `Ctrl-C`. The loop exits automatically once all tracked panes echo the marker.

## Failure Recovery
- If a pane crashes, reattach with `tmux attach -t goose` and rerun the persona bootstrap:
```bash
  source scripts/persona_env/<persona>.env
  scripts/run_codex_persona.sh <persona>
  # liitä persona-prompti from_to.md:stä kun Codex avautuu
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
