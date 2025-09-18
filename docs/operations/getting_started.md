# Getting Started Flight Plan

This quick brief shows operators and Maverick how to bring Talk to Me Goose
online on a single VM. Pair it with `from_to.md` for the
canonical Ready Check script.

## 1. Prepare (or resume) the VM
All personas share this single machine. If you already have the repo cloned and
tooling installed, just pull the latest changes and jump to section 2.

1. Clone or update the repo: `git clone git@github.com:taituo/talktomegoose.git`
   (or `git pull` inside the existing checkout).
2. Confirm you have an OpenAI Codex-capable account and the Codex CLI configured on the VM.
3. Jos tmux puuttuu, aja `make bootstrap` **kerran per kone** (tai asenna se
   pakettivarastosta). Tarvitsetko Node 20:n, pnpm:n, Astron ja Python-työkalut
   valmiiksi? Aja `make app`; ohita se, jos haluat pysyä kevyessä tmux+git
   kokoonpanossa.
4. Run `make venv` **only if** you plan to use the optional FastAPI template;
   it creates or refreshes `.venv/` directly.
5. Run `make clone-template` to clone or update the shared
   `talktomegoose_test/` playground repository when you need that remote (or let
   `make mission-all` handle the full sequence).
6. Need the monitoring stack (FastAPI + dashboard)? Use `make demotime` to
   install its dependencies and display launch commands. Skip this if tmux +
   git are sufficient.
7. Want the heavier “everything” workflow (deps + tests)? Run `make mission-all`
   — useful for demos, optional for day-to-day coding.

## 2. Build the Mission Package
1. Create the scaffolding: `make mission-package MISSION="Flight Check" SPEC=https://…`.
2. Fill in `missions/<slug>/task.md` with objectives, constraints, and deliverables.
3. Ensure `missions/<slug>/brief.md` lists the agent roster, chain of command, and any optional infrastructure.
4. Note any special services (Docker containers, databases, queues) plus their ports so the squad avoids conflicts.

## 3. Prepare Persona Workspaces
1. Run `scripts/setup_persona_workspaces.sh` (automatically invoked by `make tmux`) to create or refresh `personas/<Persona>/` clones.
2. Each persona clone tracks the default branch (e.g., `master`). Developers can create feature branches locally without affecting other panes.
3. Need custom locations? Set `PERSONA_WORKSPACES=/alt/path make tmux` or export the variable before launching.

## 4. Launch Mission Control
1. Start the tmux layout: `make mission-control` (alias: `make tmux`).
2. Paneissa Codex käynnistyy automaattisesti `--full-auto`-tilassa. Jos joudut käynnistämään sen itse, aja `scripts/run_codex_persona.sh <Persona>` ja liitä persona-prompti `from_to.md`:stä.
3. Observers join read-only with `tmux attach -t goose -r`.
4. Monitor progress with helper targets as you go:
   - `make inbox` — print tasks from `handoffs/inbox.md`
   - `make mission-log` — tail recent entries in `logs/mission.log`
   - `make mission-status` — show a compact git graph
   - `make mission-summary` — curl the FastAPI dashboard summary (requires server; honour `DEMO_FASTAPI_PORT` if you changed ports)
5. Need local remotes? Run `make start-local-registry` (or `LOCAL_NAME=foo make local-demo-repo`) and set `LOCAL_DEMO_REPO=/path/to/local_registry/<persona>.git` before `make mission-all`.

## 5. Run the Ready Check
- Open `from_to.md` in the Maverick pane.
- Capture operator answers (VM health, Codex access, template plan).
- Log decisions in `handoffs/inbox.md` and `logs/mission.log`.

## 6. Execute the Mission Loop
1. Personas execute from `dev` (or feature branches that merge into `dev`) based on the mission brief and inbox prompts.
2. Run lightweight tests locally as you code; record noteworthy results in your Codex transcript.
3. When a milestone is ready, Rooster (or a specialised agent) can trigger broader verification, pull in Dockerised services, or stage data as required.
4. Maverick reviews the milestone, merges into `main`, and records the decision and debrief items in `missions/<slug>/brief.md` plus `logs/mission.log`.
5. `make clone-template` as needed (or rerun `make mission-all` / `make demotime`) so Maverick can monitor remote branches on `talktomegoose_test`.

## 7. Wrap Up
- Update radio checks and ADRs.
- Run `make docs-build` if docs changed.
- Commit, push, and archive mission artifacts.
- Shut everything down with `make mission-clean` if the VM is rotating to another squad.
