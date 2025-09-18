# Storyteller Template Hangar

Use this template when Maverick wants the squad to co-author long-form
narratives (novels, serials, lore docs). It complements the FastAPI template by
focusing on text collaboration instead of code.

## Inventory
- `templates/storyteller/outline.md` — global story brief and chapter targets.
- `templates/storyteller/chapters/` — per-chapter Markdown stubs.
- `templates/storyteller/notes/` — shared worldbuilding scratchpad.

## Recommended Squad
- **Maverick** (showrunner) keeps outline + merges branches.
- **Phoenix** (lead writer) blocks out beats and polishes prose.
- **Goose** (continuity editor) ensures characters and timelines align.
- **Rooster** (QA) reviews chapters for tone and logic regressions.
- Optional: **Hondo** logs approvals; **Iceman** handles structural edits.

## Mission Flow
1. Run `make mission-all` (or `make mission-control`) to boot tmux and prep
   dependencies.
2. Maverick seeds `outline.md` and assigns chapters via `handoffs/inbox.md`.
3. Each persona drafts in their chapter file on a feature branch (e.g.,
   `feature/phoenix-ch01`).
4. Use pull requests to merge chapters, with Goose + Rooster reviewing.
5. Publish compiled chapters (e.g., `notes/story-dashboard.md`) or export to
   docs as needed.

## Tips
- Keep chapters short to reduce merge conflicts.
- Log major plot decisions in ADRs so future missions can continue the arc.
- Pair two personas on tricky chapters: Phoenix drafts, Goose edits live via
  tmux for rapid iteration.
