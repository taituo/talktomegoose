"""Minimal FastAPI scaffold for Talk to Me Goose missions.

Personas can extend this module to implement CRUD endpoints. The in-memory
store keeps the template self-contained; replace it with a database or service
integration when the mission calls for it.
"""

from typing import Dict

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(
    title="Talk to Me Goose API",
    description="Starter FastAPI template for persona collaboration.",
    version="0.1.0",
)


class Item(BaseModel):
    name: str
    description: str | None = None


class ItemUpdate(BaseModel):
    name: str | None = None
    description: str | None = None


# In-memory data store keyed by surrogate integer ID.
_ITEMS: Dict[int, Item] = {}


def _get_next_id() -> int:
    return max(_ITEMS.keys(), default=0) + 1


@app.get("/status", tags=["meta"])
def status() -> dict[str, str]:
    """Health probe that allows quick verification the API is reachable."""
    return {"service": "talktomegoose", "status": "ok"}


@app.get("/items", response_model=list[Item], tags=["items"])
def list_items() -> list[Item]:
    """Return every stored item in insertion order."""
    return list(_ITEMS.values())


@app.post("/items", response_model=Item, status_code=201, tags=["items"])
def create_item(item: Item) -> Item:
    """Create a new item and return it."""
    item_id = _get_next_id()
    _ITEMS[item_id] = item
    return item


@app.get("/items/{item_id}", response_model=Item, tags=["items"])
def read_item(item_id: int) -> Item:
    try:
        return _ITEMS[item_id]
    except KeyError as exc:  # pragma: no cover - FastAPI handles formatting
        raise HTTPException(status_code=404, detail="Item not found") from exc


@app.put("/items/{item_id}", response_model=Item, tags=["items"])
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


@app.delete("/items/{item_id}", status_code=204, tags=["items"])
def delete_item(item_id: int) -> None:
    try:
        del _ITEMS[item_id]
    except KeyError as exc:  # pragma: no cover - FastAPI handles formatting
        raise HTTPException(status_code=404, detail="Item not found") from exc
