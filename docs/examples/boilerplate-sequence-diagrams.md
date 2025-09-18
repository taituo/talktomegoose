# Boilerplate Sequence Diagrams

Mermaid sequence diagrams showing how the optional boilerplate pieces collaborate. Each edition references the Express backend in `apps/backend` and the static landing page assets in `apps/landing-page`.

## Simple Edition
```mermaid
sequenceDiagram
  autonumber
  participant UserBrowser as Browser
  participant Landing as Landing Page Script (main.js)
  participant BriefingAPI as Briefing API (/api/briefings)

  UserBrowser->>Landing: Load `/apps/landing-page/index.html`
  Landing->>BriefingAPI: GET /current
  BriefingAPI-->>Landing: Mission briefing JSON
  note over Landing: `main.js` maps objectives into `<li>` entries
  Landing-->>UserBrowser: Render hero banner with mission + ETA
```

## Advanced Edition
```mermaid
sequenceDiagram
  autonumber
  participant Phoenix as Phoenix (UI)
  participant Express as Express Server (apps/backend/src/server.js)
  participant Briefings as Briefing Lib (lib/briefings.js)
  participant Telemetry as Telemetry Route (/api/telemetry)
  participant Rooster as Rooster (QA)

  Phoenix->>Express: GET /api/briefings/current
  Express->>Briefings: getCurrentBriefing()
  Briefings-->>Express: Mission payload + feature flags
  Express-->>Phoenix: JSON response consumed by `main.js`
  Phoenix->>Telemetry: POST { altitude, speed, status }
  note over Telemetry: Handler validates numbers in `routes/telemetry.js`
  Telemetry-->>Phoenix: 202 Accepted acknowledgement
  Rooster->>Express: Run `make verify`
  Express-->>Rooster: Lint + test status for release notes
  note over Rooster: Results logged into radio-check docs
```

## Hallucinated Edition
```mermaid
sequenceDiagram
  autonumber
  participant Maverick as Maverick
  participant Draft as Hallucinated Agent
  participant Express as Express Reality
  participant Docs as Boilerplate Docs

  Maverick->>Draft: "Where is the mission endpoint?"
  Draft-->>Maverick: "Try GET /api/talktomegoose/magic"
  note over Draft: Endpoint not defined in `apps/backend`
  Maverick->>Express: GET /api/talktomegoose/magic
  Express-->>Maverick: 404 Not Found
  Docs-->>Maverick: Read `docs/boilerplate/experimental.md`
  note over Maverick,Docs: Validate suggestions against source before coding
```
