# Storyteller Template

A lightweight scaffold for narrative missions where Maverick coordinates
personas writing a multi-chapter story. Each chapter lives in its own Markdown
file under `chapters/`, and the outline keeps the squad aligned on arcs and
characters.

## Structure
- `outline.md` — the mission brief for the story (themes, cast, timeline).
- `chapters/` — numbered Markdown files (`chapter-01.md`, `chapter-02.md`, …)
  that personas author in parallel on feature branches.
- `notes/` — shared scratchpad for worldbuilding, glossary, or TODO lists.

## Suggested Persona Squad
- **Maverick** — story showrunner; keeps outline updated and merges chapters.
- **Phoenix** — lead narrative designer drafting chapter beats.
- **Goose** — continuity editor cross-checking characters and timelines.
- **Rooster** — QA reviewer ensuring tone consistency and catching plot holes.

## Workflow
1. `make mission-control` to launch tmux panes and brief the squad.
2. Maverick seeds `outline.md` and creates `chapters/chapter-01.md` with a stub.
3. Assign each persona a chapter via `handoffs/inbox.md` (one chapter per
   feature branch, e.g., `feature/phoenix-ch01`).
4. Merge chapters back through Maverick; track story status in
   `notes/story-dashboard.md`.

> Tip: pair this template with the `mission-all` make target to ensure
> dependencies, tmux layout, and validation run before the writing sprint.
