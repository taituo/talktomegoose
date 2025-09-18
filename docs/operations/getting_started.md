# Getting Started Flight Plan

This quick brief shows operators and Maverick how to bring Talk to Me Goose
online on a single VM. Pair it with `from_maverick_to_codex.md` for the
canonical Ready Check script.

## 1. Prepare (or resume) the VM
All personas share this single machine. If you already have the repo cloned and
tooling installed, just pull the latest changes and jump to section 2.

1. Clone or update the repo: `git clone git@github.com:taituo/talktomegoose.git`
   (or `git pull` inside the existing checkout).
2. Run `make bootstrap` **once per machine** to install tmux, Node 20, pnpm, and
   Astro.
3. Create/activate a Python virtual environment if you plan to use the FastAPI template:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r templates/fastapi/requirements.txt
   ```

## 2. Launch Mission Control
1. Start the tmux layout: `make tmux`.
2. Attach Codex sessions in each pane (`codex --persona <Name> --cwd ...`).
3. Observers join read-only with `tmux attach -t goose -r`.

## 3. Run the Ready Check
- Open `from_maverick_to_codex.md` in the Maverick pane.
- Capture operator answers (VM health, Codex access, template plan).
- Log decisions in `handoffs/inbox.md` and `logs/mission.log`.

## 4. Execute the Mission Loop
1. `make test-unit` — FastAPI template smoke test before coding.
2. Personas implement tasks from the shared repo root (`talktomegoose/`).
3. `make verify` — lint + pnpm tests (set `ENABLE_TELEMETRY_TEST=1` when the
   telemetry endpoint exists).
4. Maverick reviews branches and merges after Rooster signs off.

## 5. Wrap Up
- Update radio checks and ADRs.
- Run `make docs-build` if docs changed.
- Commit, push, and archive mission artifacts.
