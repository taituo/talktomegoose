# Mission Dashboard Template Hangar

Spin up a Next.js UI that mirrors the tmux cockpit with ASCII-inspired split
panels. Use it to visualize persona comms, Git activity, and merge status while
the FastAPI template streams data.

## Inventory
- `templates/mission-dashboard/` — Next.js 14 project with a sample dashboard
  (`app/page.tsx`) and styling in `globals.css`.
- `templates/fastapi/app/main.py` — extend with endpoints such as `/api/events`
  and `/api/commits` to feed the dashboard in real time.

## Quickstart
```bash
cd templates/mission-dashboard
pnpm install
pnpm dev
```
Visit http://localhost:3000 to see the split-panel layout. The sample arrays in
`app/page.tsx` mimic tmux panes; swap them for `fetch` calls when your API is
ready.

## Recommended Squad
- **Maverick** orchestrates the story or mission and reviews dashboard updates.
- **Phoenix** (or front-end persona) owns the Next.js UI.
- **Goose** / **Hangman** wire FastAPI endpoints that expose mission data.
- **Rooster** validates data accuracy and visual alerts.

## Integration Tips
- Keep endpoints lightweight (e.g., `/api/persona-events`, `/api/git-activity`).
- Use Server-Sent Events or polling on the Next.js side if you want live refresh.
- Store serialized events (JSONL) so the dashboard can replay history.
- Deploy the dashboard alongside docs or host it via `next export` if you need a
  static build.
