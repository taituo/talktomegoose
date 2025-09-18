# Experimental Boilerplate Airframe

This repository ships with an optional reference implementation to accelerate early missions. Treat it as experimental: Maverick should confirm with the operator before engaging it, and teams may decide to replace or discard it.

## Modules
- `apps/landing-page/` — static hero page plus lightweight fetch hook to the briefing API.
- `apps/backend/` — Express shell hosting `/api/briefings`, `/api/telemetry`, and `/api/feature-flags` routes.
- `site/` — Astro documentation site rendering Markdown from `docs/`.

## Opt-In Procedure
1. Maverick runs the Ready Check (see `from_maverick_to_codex.md`) and records whether the boilerplate should stay active.
2. If accepted, Goose and Phoenix pair to keep the landing page and backend aligned.
3. If declined, archive or remove the `apps/` directories after recording an ADR.

## Extending the Airframe
- Add personas using the templates under `docs/personas/` and extend `scripts/start_tmux_codex.sh` with new panes.
- Keep optional experiments in feature branches until Maverick approves landing them in `main`.

Link back here when describing the boilerplate in external docs.
