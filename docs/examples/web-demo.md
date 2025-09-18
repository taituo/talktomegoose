# Web Demo Scenario

## Setup
1. Serve backend locally: `pnpm --dir apps/backend run dev`.
2. Open `apps/landing-page/index.html` in a browser using `live-server` or VS Code Live Preview.
3. Update `apps/landing-page/main.js` (future work) to fetch from `/api/briefings/current`.

## Personas
- Phoenix wires UI fetch logic and updates menu prompts.
- Hangman exposes CORS-friendly responses.
- Rooster records regression script using Playwright.

## Rollout Strategy
- Stage preview in Astro docs under `/docs/examples`.
- Collect feedback via `handoffs/<date>-radio-check.md`.
