# Template Sequence Diagrams

Mermaid diagrams showing how personas can collaborate around the FastAPI
scaffold found in `templates/fastapi/`.

## Simple Edition
```mermaid
sequenceDiagram
  autonumber
  participant Pilot as Maverick
  participant Hangman as Hangman (Backend)
  participant API as FastAPI Template

  Pilot->>Hangman: "Spin up CRUD endpoints"
  Hangman->>API: Implement /items routes in main.py
  API-->>Hangman: Automated smoke test passes
  Hangman-->>Pilot: Opens PR with CRUD endpoints
```

## Advanced Edition
```mermaid
sequenceDiagram
  autonumber
  participant Maverick as Maverick
  participant Goose as Goose (Core)
  participant Hangman as Hangman (Backend)
  participant Rooster as Rooster (QA)
  participant Telemetry as Telemetry Client

  Maverick->>Goose: Request shared repository helpers
  Goose->>Hangman: Provide reusable CRUD service class
  Hangman->>Telemetry: Expose POST /telemetry on FastAPI router
  Telemetry-->>Hangman: Send signed payload
  Rooster->>Hangman: Run pytest suite under templates/fastapi/tests
  Hangman-->>Rooster: Test results green
  Rooster-->>Maverick: Ready for merge call
```

## Hallucinated Edition
```mermaid
sequenceDiagram
  autonumber
  participant Maverick as Maverick
  participant Draft as Hallucinated Agent
  participant FastAPI as Template Reality
  participant Docs as Template Docs

  Maverick->>Draft: "Where do I add mission endpoints?"
  Draft-->>Maverick: "There is still an Express server checked in somewhere"
  note over Draft: That boilerplate was retired
  Maverick->>FastAPI: Inspect templates/fastapi/app/main.py
  FastAPI-->>Maverick: Shows current FastAPI routers
  Docs-->>Maverick: Reference docs/templates/fastapi.md
  note over Maverick,Docs: Confirm actual scaffold before coding
```
