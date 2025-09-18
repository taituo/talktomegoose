# Talk to Me Goose (Archived)

> This repository is no longer maintained. It remains public as a snapshot that future rebuilds can reference.

## Why it was archived
- The experiment was fun, but the environment became fragile: panes crashed regularly, automation drifted, and docs went stale faster than we could edit them.
- The old README and scripts pushed every persona into its own git clone. That isolation created constant sync headaches and duplicated history.
- Current best practice is to lean on `git worktree`: multiple working trees from a single repository, each on its own branch. It avoids redundant clones and keeps merges tidy.
- With those gaps—and the overall brittleness of the codebase—it is easier to start fresh than to patch every corner.

## What remains
This repo was trimmed to the minimum:
- `docs/` – a short roadmap for the next build.
- `handoffs/` – a sample inbox table (empty shell).
- `scripts/` – placeholder helpers; none are guaranteed to work.
- `Makefile` – tiny helper targets (tmux notice, cleanup stub).

All demos, templates, Astro assets, FastAPI experiments, and other heavy directories were removed.

## Plan 1: Barebones multi-agent loop (minimum viable)
Prove the workflow with the smallest possible setup before reviving the full “Top Gun” theme.

- **Roles**: two agents – Lead Developer and Coder.
- **Flow**: Lead breaks down tasks, issues instructions, and signs off. Coder implements changes.
- **Tooling**: single repository, one tmux session, two `codex` panes.
- **Git**: Lead works on the main branch, Coder in a feature branch (`feature/coder-*`), pushing small increments.
- **Success criteria**: the loop runs without constant manual babysitting.

## Plan 2: Full “Talk to Me Goose” framework (expanded)
After the baseline loop is stable, rebuild the full crew with solid foundations:

- **Personas**: Maverick (lead), Goose (core dev), Iceman (stability/review), Phoenix (frontend), Hangman (backend), Rooster (QA), Hondo (PM).
- **Git worktrees**: `git worktree add personas/Goose feature/goose-core`, etc. Each persona gets a worktree but shares one git history.
- **tmux orchestration**: a script that creates the session, windows, panes, cds into the worktree, and launches the AI CLI with that persona’s prompt.
- **Shared channels**: `handoffs/inbox.md` for tasks/questions, `logs/<persona>.md` for radio-check style updates.
- **Commit format**: `[Persona][Task#] Short message` to streamline Maverick’s reviews.
- **Optional control pane**: monitor git status or tail logs for quick situational awareness.

## How to reuse what’s here
Even though the repo is archived, you can still use it as scaffolding:

1. Fork or clone it.
2. Remove the remaining legacy stubs and implement Plan 1.
3. Document findings in `docs/` and create ADRs before expanding to Plan 2.

> ⚠️ **Warning**: nothing in this codebase is supported. Use it at your own risk—and preferably inside an isolated environment.

License and prior material remain under CC0. Fly safe, future crew!
