# Talk to Me Goose Backend

Express.js reference backend used by the squadron to demonstrate multi-agent collaboration.

## Scripts
- `pnpm --dir apps/backend run dev` — start server with watch mode.
- `pnpm --dir apps/backend run start` — run server once.

## Environment
- `PORT` (default `3001`)
- `GOOSE_PUBKEY` — SSH public key (required for telemetry endpoint)

## Routes
- `GET /api/briefings/current`
- `POST /api/telemetry`
- `PATCH /api/feature-flags/:flag`
