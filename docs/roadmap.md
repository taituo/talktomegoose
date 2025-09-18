# Rebuild Roadmap

## Phase 1 – Barebones Multi-Agent Loop
- Roles: Lead Developer + Coder.
- One tmux session, two Codex panes.
- Lead owns the main branch; Coder works in a feature branch.
- Goal: prove the smallest agent pair can run without constant manual fixes.

## Phase 2 – Full “Talk to Me Goose” Line-up
- Personas: Maverick, Goose, Iceman, Phoenix, Hangman, Rooster, Hondo.
- Use `git worktree` structures: `git worktree add personas/Goose feature/goose-core`, etc.
- A tmux bootstrap script should create windows/panes and launch Codex in each worktree.
- Shared channels: `handoffs/inbox.md`, `logs/<persona>.md`.
- Commit format: `[Persona][Task#] Short description`.
- Add a monitoring pane for logs or git status if useful.

## Principles for the reboot
1. Keep scripts small and testable.
2. Document decisions (ADRs) before expanding scope.
3. Automate the tmux ↔ git link with worktrees—no more duplicate clones.
4. Validate each step with a test before moving on.
