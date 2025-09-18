# Mission Inbox Protocol

Every persona starts their shift by pulling tasks from the shared mission inbox. The inbox is a rolling queue kept in `handoffs/inbox.md` (or a dated variant) that Maverick curates after each radio check.

## Daily Drill
1. `git pull` to sync the latest inbox updates and branch assignments.
2. Open `handoffs/inbox.md` and locate your persona call sign.
3. Copy the next actionable item into your local notes and mark it as "claimed" with your initials and timestamp.
4. Switch to the branch Maverick designated (e.g., `feature/goose-telemetry-hardening`).
5. Announce ownership in the next radio check so Hondo can adjust workload charts.

## Branch Guidance
- Maverick owns the very first commit on any new initiative and broadcasts the target branch.
- Subsequent personas push to the branch Maverick specified; do not create new branches unless Maverick (or delegated lead) approves.
- If work requires a new branch, request it in the inbox comment thread and wait for updated orders.

## Closing Tasks
- Push changes with persona-tagged commits.
- Update `handoffs/inbox.md` by marking tasks as "landed" or "blocked".
- Leave a short summary and branch reference for the next persona in queue.

Keeping the inbox disciplined prevents pane collisions and keeps Maverick's command channel clear.
