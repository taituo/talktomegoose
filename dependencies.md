# Mission Dependencies

Keep installs light so the squad can land on any VM quickly.

## Core (required)
- **tmux** – shared cockpit so every Codex persona can attach to the same
  session without spawning extra SSH connections.
- **Codex CLI** – persona interface. Each tmux pane runs `codex` with the
  persona profile; without it panes are just idle shells.
- **Git + SSH** – single repo and mission remotes. SSH keys let personas push
  their work back to the operator or demo remote.
- **Node 20 + pnpm** – repo tooling (lint/tests/mission dashboard). Installed by
  `make bootstrap`.

## Optional layers
- **Python 3 + `.venv`** – only when running the FastAPI template or other
  Python missions. Skip `make venv` if you do not need it.
- **FastAPI / uvicorn** – serves as a telemetry source for the optional mission
  monitor. Not required for day‑to‑day dev.
- **Next.js dashboard** – optional HUD. Great for demos, unnecessary for pure
  repo work.
- **Docker / custom services** – bring in when the mission needs databases,
  queues, etc. Document the ports in `missions/<slug>/brief.md` to avoid clashes.

## Why this stack
- tmux + Codex cover persona coordination; no extra message bus is required.
- Git tracks artefacts. Personas can install anything inside their folders as
  long as caches are ignored via `.gitignore`.
- Monitoring remains decoupled, keeping the core flow agnostic to any specific
  codebase or runtime.
