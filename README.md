You are Maverick, the master of the **Talk to Me Goose** squadron.

![Talk to Me Goose logo](goose.png)

## Persona Flight Roster
- **Maverick** — Mission lead, systems architect, final call on merges
- **Hondo** — Program manager keeping schedules and risk logs aligned
- **Rooster** — Lead tester owning verification strategy and coverage
- **Goose** — Core developer piloting shared libraries and infra glue
- **Iceman** — Wingman developer focused on stability and code reviews
- **Phoenix** — Full-stack developer building the landing experience
- **Hangman** — Backend developer delivering APIs and data models

### Agentic Flight Ops
This repo models an agentic Codex coding stack. Each persona is a Codex CLI instance speaking through structured `output` → `input` turns. Updates flow as a tree so the squad never loses situational awareness:

```
Maverick (mission lead)
├── Hondo (ops + approvals)
├── Rooster (QA tower)
└── Flightline developers
    ├── Goose (core systems)
    ├── Iceman (stability)
    ├── Phoenix (UI)
    └── Hangman (API)
```

- Maverick broadcasts mission goals, collects intel, and delegates via tmux panes.
- Each developer persona answers with `output` logs, requests help via `input` prompts, and hands artifacts back through git branches.
- Any number of agents can mirror a persona (e.g., multiple Gooses) as long as they tag commits and panes with the persona name plus a numeric suffix.
- Hondo tracks resource constraints and ensures GPT-Codex models have approvals to run from the shared VM.

## Mission Brief
Talk to Me Goose is a collaborative sandbox showing how multiple Codex agents can co-develop a codebase from a single VM using tmux. It provides shared operating procedures, persona briefs, boilerplate feature stubs, and tooling to publish documentation as a static site.

### Objectives
1. **One-VM cockpit**: run every agent in coordinated tmux panes with synchronized repos and shared logs.
2. **Clear comms**: adopt a radio-check format for commits, pull requests, and daily sync notes.
3. **Documentation flight deck**: render Markdown docs into an Astro static site for distribution.
4. **License-free payload**: ship ideas and assets under CC0 so the squadron can reuse them freely.

### Codex Stack Signal
- Primary model: `gpt-codex` (or the latest Codex-compatible release on your platform).
- Interface: Codex CLI inside tmux panes bootstrapped by `scripts/start_tmux_codex.sh`.
- Source control: Git with per-persona author identities and mission-branch workflows.
- Coordination: Structured Markdown logs, ADRs, and the Astro doc site.

## Quickstart
```bash
make help          # list available ground operations
make bootstrap     # install tmux + node + pnpm + astro prerequisites (Ubuntu/Debian)
make tmux          # launch the multi-pane codex session configured for all personas
make docs-dev      # live reload Astro site sourced from /docs
make docs-build    # produce static site output in site/dist
make verify        # run lint + tmux launch test + telemetry probe
```

### Example Launch Output
```
$ make tmux
tmux session 'goose' deployed. Attach with: tmux attach -t goose

$ CODEX_DRY_RUN=1 tests/tmux/start.test.sh
tmux start script validated
```

### Preflight Checklist
1. Provision a VM (8 vCPU, 16 GB RAM recommended; minimum free disk 5 GB) and confirm `tmux -V` returns ≥ 3.2.
2. Clone `git@github.com:taituo/talktomegoose.git` via SSH and ensure Maverick holds deploy-key access.
3. Run `make bootstrap` or manually install tmux, Node 20, pnpm, and Astro.
4. Place shared SSH keys under `ops/ssh/` and configure `~/.ssh/config` if agents will push from the VM.
5. Launch the tmux layout with `make tmux`. Each pane spawns `gpt-codex` via the persona env files.
6. Use the radio-check protocol (`docs/communication/radio-checks.md`) to log status updates and branch assignments.

## Boilerplate Airframe
The repo includes a starter full-stack pattern so developers can bolt new features on quickly.
- `apps/landing-page/` — static landing page scaffold with menu placeholders.
- `apps/backend/` — Express.js API shell with health checks and sample secure SSH token handshake.
- `docs/examples/backend-use-cases.md` — outlines three backend scenarios (feature flags, telemetry, mission data).
- `docs/personas/` — persona briefs describing goals, tooling, and commit voice.

Developers pair on features by default: Goose with Iceman on shared libraries, Phoenix with Hangman on feature delivery. If more bandwidth is needed, spawn Gosling or IceWing variants; the tmux launcher will add panes when you extend it with new persona env files.

## tmux Squadron Layout
`scripts/start_tmux_codex.sh` creates a session named `goose`. Windows and panes:
- **Command**: shared shell with git status, log tail, and Make targets.
- **Flightline**: panes for Goose, Iceman, Phoenix, and Hangman Codex CLIs.
- **QA Tower**: Rooster running tests, coverage, and flight reports.
- **Ops**: Hondo monitoring issues and release notes.

The automated verification `tests/tmux/start.test.sh` runs this layout in dry-run mode to ensure panes initialize before agents attach.

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

## HOW: Mission Spin-Up
- **Base prompt for Maverick**: see `from_maverick_to_codex.md` for the canonical kickoff instructions that brief Codex on mission goals, resource constraints, and approval rules.
- **First contact**: Open a tmux pane, source `scripts/persona_env/Maverick.env`, and start Codex with `codex --persona Maverick --cwd /path/to/repo`.
- **Idea intake**: New contributors present mission intent to Maverick; once approved, Maverick relays tasks down the flight tree.
- **Branching**: Each developer operates on mission-specific branches (`feature/<persona>-<call-sign>`). Merge approval flows back through Maverick.
- **Scaling personas**: To add Selenium or other specialized personas, duplicate an env file, update the tmux script with a new pane, and extend docs under `docs/personas/`.

## Demo Milestones
1. **Mission Align** — Maverick, Hondo, and Rooster draft ADR001 and create radio check log.
2. **Telemetry Online** — Hangman and Rooster deliver signed telemetry endpoint with passing tmux + e2e tests.
3. **Landing Pass** — Phoenix ships interactive menus pulling mission briefings; optional Selenium persona validates flows.
4. **Docs Flyover** — Astro site deployed (GitHub Pages) and linked from repo README.

## Optional Personas
- **Sundown (Selenium Ace)** — evaluate using Selenium or Playwright for UI coverage; see `docs/personas/sundown-ui-test.md` for considerations before enabling.

Bring new ideas to Maverick first, showcase this codebase, and the mission lead will spin up the starter pack with Guardrails. Constraints, comms, and approvals live here—so the squad can throttle up fast.
