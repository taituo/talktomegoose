# Template Sequence Diagrams

Mermaid diagrams showing how personas can collaborate around the optional
FastAPI scaffold in `templates/fastapi/`. Treat the API + dashboard as
monitoring utilities—tmux + git remain the primary collaboration layer.

## Simple Edition
```mermaid
sequenceDiagram
  autonumber
  participant Pilot as Maverick
  participant Brief as Mission Brief
  participant Hangman as Hangman (Backend)
  participant Dev as dev branch

  Pilot->>Brief: Publish mission package + chain of command
  Brief-->>Hangman: Assign CRUD task + spec URL
  Hangman->>Dev: Push feature work into dev branch
  Hangman-->>Pilot: Ping ready for optional testing
  Pilot->>Dev: Merge milestone after spot checks
```

## Advanced Edition
```mermaid
sequenceDiagram
  autonumber
  participant Maverick as Maverick
  participant Goose as Goose (Core)
  participant Hangman as Hangman (Backend)
  participant Rooster as Rooster (QA)
  participant Monitor as Optional Monitor Stack

  Maverick->>Goose: Request shared repository helpers
  Goose->>Hangman: Provide reusable CRUD service class
  Hangman->>Monitor: Publish telemetry endpoint (optional)
  Rooster->>Hangman: Kick off milestone verification
  Hangman-->>Rooster: Test results + logs
  Rooster-->>Maverick: Green light for merge into main
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
