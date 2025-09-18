You are Maverick, the master of the **Talk to Me Goose** squadron.

![Talk to Me Goose logo](goose.png)

> **No fighter-jet lore required.** Talk to Me Goose is an agentic launch platform: Maverick is the master controller, other personas are workers, and communication flows through git branches, spec files, and radio-check logs. Swap the visuals as you like; the coordination mechanics stay the same.

## Persona Flight Roster
- **Maverick** — Mission lead, systems architect, final call on merges
- **Hondo** — Program manager keeping schedules and risk logs aligned
- **Rooster** — Lead tester owning verification strategy and coverage
- **Goose** — Core developer piloting shared libraries and infra glue
- **Iceman** — Wingman developer focused on stability and code reviews
- **Phoenix** — Full-stack developer building the landing experience
- **Hangman** — Backend developer delivering APIs and data models

### Ground Control (Outside the Roster)
- **Operator** — the human running the VM and tmux session; boots Codex panes, approves automation, and keeps the squad on mission timeline.

### Agentic Flight Ops
This repo models an agentic Codex coding stack. Each persona is a Codex CLI instance speaking through structured `output` → `input` turns. Communication is enforced by branches, spec files, and the mission inbox so the squad never loses situational awareness:

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

- Maverick acts as master controller: broadcasts goals, collects intel, and delegates via tmux panes.
- Every persona syncs the mission inbox (`handoffs/inbox.md`) at shift start to pull assignments, specs, and branch orders.
- Each developer persona answers with `output` logs, requests help via `input` prompts, and hands artifacts back through git branches and spec markdown.
- Any number of agents can mirror a persona (e.g., multiple Gooses) as long as they tag commits and panes with the persona name plus a numeric suffix.
- Hondo tracks resource constraints and ensures GPT-Codex models have approvals to run from the shared VM.

#### Read-Only Observation
- Attach observers with `tmux attach -t goose -r` so they can watch personas without typing into panes.
- Start the full cockpit first via `make tmux`; observers can join and leave freely.

## Mission Brief
Talk to Me Goose is a collaborative sandbox showing how multiple Codex agents can co-develop a codebase from a single VM using tmux. It provides shared operating procedures, persona briefs, boilerplate feature stubs, and tooling to publish documentation as a static site.

### Objectives
1. **One-VM cockpit**: run every agent in coordinated tmux panes with synchronized repos and shared logs.
2. **Clear comms**: adopt a radio-check format for commits, pull requests, and daily sync notes.
3. **Documentation flight deck**: render Markdown docs into an Astro static site for distribution.
4. **License-free payload**: ship ideas and assets under CC0 so the squadron can reuse them freely.

### Codex Stack Signal
- Primary model: `gpt-codex` (or the latest Codex-compatible release on your platform). See `docs/operations/codex-requirements.md` for account prerequisites and quota warnings.
- Interface: Codex CLI inside tmux panes bootstrapped by `scripts/start_tmux_codex.sh`.
- Source control: Git with per-persona author identities and mission-branch workflows.
- Coordination: Structured Markdown logs, ADRs, the mission inbox, and the Astro doc site.

## Quickstart
```bash
make help          # list available ground operations
make bootstrap     # install tmux + node + pnpm + astro prerequisites (Ubuntu/Debian)
make mission-control # launch the multi-pane Codex tmux session (alias of make tmux)
make docs-dev      # live reload Astro site sourced from /docs
make docs-build    # produce static site output in site/dist
make verify        # run lint + tmux launch test + telemetry probe
make venv          # build/update FastAPI virtualenv (.venv/)
make clone-template # clone or update the talktomegoose_test repo for missions
```

### Mission Run Loop
1. **Bootstrap (once per VM)**: `make bootstrap` so every pane has tmux, Node, pnpm, and Astro.
2. **Launch Cockpit**: `make mission-control` (alias: `make tmux`) to create the shared `goose` session, then attach personas with the Codex CLI.
3. **Baseline Check**: `make test-unit` before coding to confirm the FastAPI template imports cleanly.
4. **Develop**: personas work from the single repo root (`talktomegoose/`), following Maverick’s branch orders in `handoffs/inbox.md`.
5. **Validate**: run `make verify` (or `pnpm test` with `ENABLE_TELEMETRY_TEST=1` when telemetry is wired) before handing changes back to Maverick.
6. Optional: `make clone-template` pulls the shared test repo (`taituo/talktomegoose_test`) so Maverick can monitor remote branches.

> FastAPI template note: it’s just an example payload for missions that want a
> sample backend. If you don’t need it, skip `make venv` and ignore the template
> directory; tmux + Git coordination works without it.

All personas share this working tree—no extra `/src/mission/...` directories are required. tmux panes provide isolation while keeping Git state in sync.

Need the full checklist? See `docs/operations/getting_started.md` for the
step-by-step flight plan paired with `from_maverick_to_codex.md`.

### Example Launch Output
```
$ make tmux
tmux session 'goose' deployed. Attach with: tmux attach -t goose

$ tests/git/remote.test.sh
Remote 'talktomegoose_test' already configured as git@github.com:taituo/talktomegoose_test.git
<ref output>
Remote communication validated for git@github.com:taituo/talktomegoose_test.git

$ tests/prompts/maverick_ready.test.sh
Maverick ready check template verified

$ CODEX_DRY_RUN=1 tests/tmux/start.test.sh
tmux start script validated
```

### Codex Testing Requirements
- Use a ChatGPT Plus (or higher) account with Codex access and a valid session token before running `make verify` (details in `docs/operations/codex-requirements.md`).
- Keep an eye on Codex rate limits; log quota alerts in radio checks so the squad can throttle requests.
- Test flows can be simulated via the shared ChatGPT conversation: https://chatgpt.com/share/68cbadca-7c64-8006-b614-9524f4df7447.
- Baseline automated tests focus on code quality (lint, prompts, tmux dry-run). Advanced integration tests should be run live with Codex agents attached.

### Preflight Checklist
1. Provision a VM (8 vCPU, 16 GB RAM recommended; minimum free disk 5 GB) and confirm `tmux -V` returns ≥ 3.2.
2. Clone `git@github.com:taituo/talktomegoose.git` via SSH and ensure Maverick holds deploy-key access.
3. Satisfy Codex account requirements in `docs/operations/codex-requirements.md` (ChatGPT Plus, valid session token, quota awareness).
4. Run `make bootstrap` or manually install tmux, Node 20, pnpm, and Astro.
5. Place shared SSH keys under `ops/ssh/` and configure `~/.ssh/config` if agents will push from the VM.
6. Launch the tmux layout with `make tmux`. Each pane spawns `gpt-codex` via the persona env files.
7. Sync the mission inbox (`handoffs/inbox.md`) to claim tasks and confirm branch orders from Maverick.
8. Use the radio-check protocol (`docs/communication/radio-checks.md`) to log status updates and branch assignments.
9. Ensure the simulation remote `git@github.com:taituo/talktomegoose_test.git` is reachable; `tests/git/remote.test.sh` will auto-wire it as `talktomegoose_test` if missing.

## Boilerplate Airframe (Optional)
Template scaffolds now live in `templates/` (see `docs/templates/fastapi.md`). Maverick records during the Ready Check whether the crew will fork the FastAPI starter or rebuild from scratch. Goose + Hangman shepherd shared utilities and routers, while Rooster insists every template change ships with matching tests; archive unused experiments after filing an ADR.

**Quick Start Scenario**: Begin with Maverick (master) and a single developer (Goose). Maverick seeds the branch and fills the inbox, while Goose runs a tight loop: `git pull`, check inbox/specs, implement, `git push`. Advanced multi-persona missions follow the same pattern at larger scale.

## tmux Squadron Layout
`scripts/start_tmux_codex.sh` creates a session named `goose`. Windows and panes:
- **Command**: shared shell with git status, log tail, and Make targets.
- **Flightline**: panes for Goose, Iceman, Phoenix, and Hangman Codex CLIs.
- **QA Tower**: Rooster running tests, coverage, and flight reports.
- **Ops**: Hondo monitoring issues and release notes.

The automated verification `tests/tmux/start.test.sh` runs this layout in dry-run mode to ensure panes initialize before agents attach.

Detach with `Ctrl-b d`. Reattach via `tmux attach -t goose`.

## Documentation Site
The `site/` directory houses an Astro project that ingests Markdown from `docs/` (including `docs/templates/fastapi.md`, `docs/operations/codex-requirements.md`, and all persona briefs). Build or preview via Make targets so the squad can browse the HUD and keep specifications current.

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
3. Publish a public web demo that consumes the FastAPI template.

Fly safe, keep the chatter clear, and always talk to your Goose.

## HOW: Mission Spin-Up
- **Base prompt for Maverick**: see `from_maverick_to_codex.md` for the canonical kickoff instructions that brief Codex on mission goals, resource constraints, and approval rules.
- **First contact**: Open a tmux pane, source `scripts/persona_env/Maverick.env`, and start Codex with `codex --persona Maverick --cwd /path/to/repo`.
- **Idea intake**: New contributors present mission intent to Maverick; once approved, Maverick relays tasks down the flight tree.
- **Branching**: Each developer operates on mission-specific branches (`feature/<persona>-<call-sign>`). Merge approval flows back through Maverick.
- **Inbox discipline**: Claim work from `handoffs/inbox.md`; Maverick seeds the first commit on new missions, then instructs which branch each persona should use.
- **Ready Check**: Complete the template inside `from_maverick_to_codex.md` (covering Codex access, boilerplate usage, branch targets) before letting personas unmute.
- **Scaling personas**: To add Selenium or other specialized personas, duplicate an env file, update the tmux script with a new pane, and extend docs under `docs/personas/`.

## Demo Milestones
1. **Mission Align** — Maverick, Hondo, and Rooster draft ADR001 and create radio check log.
2. **Telemetry Online** — Hangman and Rooster deliver signed telemetry endpoint with passing tmux + e2e tests.
3. **Landing Pass** — Phoenix ships interactive menus pulling mission briefings; optional Selenium persona validates flows.
4. **Docs Flyover** — Astro site deployed (GitHub Pages) and linked from repo README.

## Optional Personas
- **Sundown (Selenium Ace)** — evaluate using Selenium or Playwright for UI coverage; see `docs/personas/sundown-ui-test.md` for considerations before enabling.

Bring new ideas to Maverick first, showcase this codebase, and the mission lead will spin up the starter pack with Guardrails. Constraints, comms, and approvals live here—so the squad can throttle up fast.
