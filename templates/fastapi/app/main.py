"""Minimal FastAPI scaffold for Talk to Me Goose missions.

Personas can extend this module to implement CRUD endpoints plus dashboard
feeds. The in-memory store keeps the template self-contained; replace it with a
database or service integration when the mission calls for it.
"""

from __future__ import annotations

import os
from typing import Dict, List

from fastapi import Depends, FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(
    title="Talk to Me Goose API",
    description="Starter FastAPI template for persona collaboration and dashboards.",
    version="0.2.0",
)

API_KEY = os.getenv("TALKTO_API_KEY")


if API_KEY:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["http://localhost:3000", "http://127.0.0.1:3000"],
        allow_methods=["*"],
        allow_headers=["*"]
    )


def api_key_guard(request: Request) -> None:
    """Ensure requests present the expected mission key when configured."""

    if not API_KEY:
        return
    header_key = request.headers.get("x-mission-key")
    if header_key != API_KEY:
        raise HTTPException(status_code=401, detail="Invalid or missing mission key")


class Item(BaseModel):
    name: str
    description: str | None = None


class ItemUpdate(BaseModel):
    name: str | None = None
    description: str | None = None


# In-memory data store keyed by surrogate integer ID.
_ITEMS: Dict[int, Item] = {}


class PersonaEvent(BaseModel):
    id: str
    persona: str
    timestamp: str
    message: str


class GitActivity(BaseModel):
    id: str
    branch: str
    commit: str
    persona: str
    summary: str


class MergeAttempt(BaseModel):
    id: str
    branch: str
    status: str
    reviewers: List[str]


class TelemetryMetric(BaseModel):
    id: str
    metric: str
    value: str
    trend: str


_PERSONA_EVENTS: list[PersonaEvent] = [
    PersonaEvent(
        id="evt-001",
        persona="Maverick",
        timestamp="2025-09-18T11:02Z",
        message="Story mission cleared for launch. Phoenix owns chapter-01 on feature/phoenix-ch01.",
    ),
    PersonaEvent(
        id="evt-002",
        persona="Phoenix",
        timestamp="2025-09-18T11:12Z",
        message="Drafted cold open hook; handing to Goose for continuity review.",
    ),
]

_GIT_ACTIVITY: list[GitActivity] = [
    GitActivity(
        id="git-001",
        branch="feature/phoenix-ch01",
        commit="c0ffee1",
        persona="Phoenix",
        summary="Add inciting incident scene and update outline",
    ),
    GitActivity(
        id="git-002",
        branch="feature/goose-ch02",
        commit="bad1dea2",
        persona="Goose",
        summary="Continuity polish + glossary entry",
    ),
]

_MERGE_ATTEMPTS: list[MergeAttempt] = [
    MergeAttempt(
        id="pr-21",
        branch="feature/phoenix-ch01",
        status="awaiting review",
        reviewers=["Goose", "Rooster"],
    ),
    MergeAttempt(
        id="pr-22",
        branch="feature/maverick-epilogue",
        status="draft",
        reviewers=["Phoenix"],
    ),
]

_TELEMETRY: list[TelemetryMetric] = [
    TelemetryMetric(
        id="tele-001",
        metric="Words Drafted",
        value="2,340",
        trend="+320 since last sync",
    ),
    TelemetryMetric(
        id="tele-002",
        metric="Chapters Ready",
        value="1 / 4",
        trend="Phoenix ready for merge",
    ),
]


def _get_next_id() -> int:
    return max(_ITEMS.keys(), default=0) + 1


def _dashboard_payload():
    return {
        "events": _PERSONA_EVENTS,
        "git": _GIT_ACTIVITY,
        "merges": _MERGE_ATTEMPTS,
        "telemetry": _TELEMETRY,
    }


@app.get("/status", tags=["meta"], dependencies=[Depends(api_key_guard)])
def status() -> dict[str, str]:
    """Health probe that allows quick verification the API is reachable."""
    return {"service": "talktomegoose", "status": "ok"}


@app.get("/items", response_model=list[Item], tags=["items"], dependencies=[Depends(api_key_guard)])
def list_items() -> list[Item]:
    """Return every stored item in insertion order."""
    return list(_ITEMS.values())


@app.post("/items", response_model=Item, status_code=201, tags=["items"], dependencies=[Depends(api_key_guard)])
def create_item(item: Item) -> Item:
    """Create a new item and return it."""
    item_id = _get_next_id()
    _ITEMS[item_id] = item
    return item


@app.get("/items/{item_id}", response_model=Item, tags=["items"], dependencies=[Depends(api_key_guard)])
def read_item(item_id: int) -> Item:
    try:
        return _ITEMS[item_id]
    except KeyError as exc:  # pragma: no cover - FastAPI handles formatting
        raise HTTPException(status_code=404, detail="Item not found") from exc


@app.put("/items/{item_id}", response_model=Item, tags=["items"], dependencies=[Depends(api_key_guard)])
def update_item(item_id: int, payload: ItemUpdate) -> Item:
    try:
        current = _ITEMS[item_id]
    except KeyError as exc:  # pragma: no cover - FastAPI handles formatting
        raise HTTPException(status_code=404, detail="Item not found") from exc

    new_data = current.dict()
    if payload.name is not None:
        new_data["name"] = payload.name
    if payload.description is not None:
        new_data["description"] = payload.description

    updated = Item(**new_data)
    _ITEMS[item_id] = updated
    return updated


@app.delete("/items/{item_id}", status_code=204, tags=["items"], dependencies=[Depends(api_key_guard)])
def delete_item(item_id: int) -> None:
    try:
        del _ITEMS[item_id]
    except KeyError as exc:  # pragma: no cover - FastAPI handles formatting
        raise HTTPException(status_code=404, detail="Item not found") from exc


@app.get(
    "/dashboard/persona-events",
    response_model=list[PersonaEvent],
    tags=["dashboard"],
    dependencies=[Depends(api_key_guard)],
)
def get_persona_events() -> list[PersonaEvent]:
    return _PERSONA_EVENTS


@app.get(
    "/dashboard/git-activity",
    response_model=list[GitActivity],
    tags=["dashboard"],
    dependencies=[Depends(api_key_guard)],
)
def get_git_activity() -> list[GitActivity]:
    return _GIT_ACTIVITY


@app.get(
    "/dashboard/merge-attempts",
    response_model=list[MergeAttempt],
    tags=["dashboard"],
    dependencies=[Depends(api_key_guard)],
)
def get_merge_attempts() -> list[MergeAttempt]:
    return _MERGE_ATTEMPTS


@app.get(
    "/dashboard/telemetry",
    response_model=list[TelemetryMetric],
    tags=["dashboard"],
    dependencies=[Depends(api_key_guard)],
)
def get_telemetry() -> list[TelemetryMetric]:
    return _TELEMETRY


@app.get(
    "/dashboard/summary",
    tags=["dashboard"],
    dependencies=[Depends(api_key_guard)],
)
def get_dashboard_summary() -> dict[str, object]:
    payload = _dashboard_payload()
    payload["items"] = list(_ITEMS.values())
    return payload
