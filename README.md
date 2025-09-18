You are Maverick, the master of the **Talk to Me Goose** squadron.

## Persona Flight Roster
- **Maverick** — Mission lead, systems architect, final call on merges
- **Hondo** — Program manager keeping schedules and risk logs aligned
- **Rooster** — Lead tester owning verification strategy and coverage
- **Goose** — Core developer piloting shared libraries and infra glue
- **Iceman** — Wingman developer focused on stability and code reviews
- **Phoenix** — Full-stack developer building the landing experience
- **Hangman** — Backend developer delivering APIs and data models

## Mission Brief
Talk to Me Goose is a collaborative sandbox showing how multiple Codex agents can co-develop a codebase from a single VM using tmux. It provides shared operating procedures, persona briefs, boilerplate feature stubs, and tooling to publish documentation as a static site.

### Objectives
1. **One-VM cockpit**: run every agent in coordinated tmux panes with synchronized repos and shared logs.
2. **Clear comms**: adopt a radio-check format for commits, pull requests, and daily sync notes.
3. **Documentation flight deck**: render Markdown docs into an Astro static site for distribution.
4. **License-free payload**: ship ideas and assets under CC0 so the squadron can reuse them freely.

## Quickstart
```bash
make help          # list available ground operations
make bootstrap     # install tmux + node + pnpm + astro prerequisites (Ubuntu/Debian)
make tmux          # launch the multi-pane codex session configured for all personas
make docs-dev      # live reload Astro site sourced from /docs
make docs-build    # produce static site output in site/dist
```

### Preflight Checklist
1. Provision a VM (8 vCPU, 16 GB RAM recommended) and clone the repo via SSH.
2. Run `make bootstrap` to install required packages and the Astro toolchain.
3. Generate or copy the shared SSH key for GitHub pushes into `/home/<user>/.ssh` and update `ssh_config` if needed.
4. Launch the tmux layout with `make tmux`; each pane spawns a Codex CLI instance rooted in this repo.
5. Use the communication protocol (`docs/communication/radio-checks.md`) to log status updates.

## Boilerplate Airframe
The repo includes a starter full-stack pattern so developers can bolt new features on quickly.
- `apps/landing-page/` — static landing page scaffold with menu placeholders.
- `apps/backend/` — Express.js API shell with health checks and sample secure SSH token handshake.
- `docs/examples/backend-use-cases.md` — outlines three backend scenarios (feature flags, telemetry, mission data).
- `docs/personas/` — persona briefs describing goals, tooling, and commit voice.

Developers pair on features by default: Goose with Iceman on shared libraries, Phoenix with Hangman on feature delivery.

## tmux Squadron Layout
`scripts/start_tmux_codex.sh` creates a session named `goose`. Windows and panes:
- **Command**: shared shell with git status, log tail, and Make targets.
- **Flightline**: panes for Goose, Iceman, Phoenix, and Hangman Codex CLIs.
- **QA Tower**: Rooster running tests, coverage, and flight reports.
- **Ops**: Hondo monitoring issues and release notes.

Detach with `Ctrl-b d`. Reattach via `tmux attach -t goose`.

## Documentation Site
The `site/` directory houses an Astro project that ingests Markdown from `docs/`. Build or preview via Make targets. The generated static site stitches persona specs, operations guides, and communication templates into a single navigable HUD.

## Communication Discipline
- Follow the radio-check format in `docs/communication/radio-checks.md` for async updates.
- Log pair-programming sessions in `docs/communication/session-template.md`.
- Capture decisions in lightweight ADRs under `docs/communication/adrs/` (template provided).

## Security and Access
- Store SSH deploy keys in `ops/ssh/` (example config in `docs/examples/ssh-api-handshake.md`).
- Rotate shared secrets every sprint; document updates in the Ops log.
- Restrict tmux panes to per-persona keybindings via `scripts/start_tmux_codex.sh`.

## Roadmap Ideas
1. Add mission playback that replays tmux panes as asciinema sessions.
2. Integrate CI pipelines that enforce persona-specific test suites.
3. Publish a public web demo that consumes the sample API and landing page.

Fly safe, keep the chatter clear, and always talk to your Goose.
