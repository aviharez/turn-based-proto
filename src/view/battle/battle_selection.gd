class_name BattleSelection
extends RefCounted
## Tap handling for the battle view, kept free of nodes so it can be unit-tested.
## Reads a snapshot (design/gdd/battle.md §3.11) and turns a tapped cell into either a
## new selection or a command dictionary. It never changes the snapshot.

const NONE: int = -1

## uid of the selected unit, or NONE.
var selected_uid: int = NONE


## Handles a tap on `cell`. Returns a command dictionary to send to the sim, or {} when
## the tap only changed the selection.
func tap(cell: Vector2i, snapshot: Dictionary) -> Dictionary:
	var grid: Dictionary = snapshot.get("grid", {})
	if not _in_arena(cell, grid):
		selected_uid = NONE
		return {}
	if is_hero_selected(snapshot):
		var options: Dictionary = snapshot.get("options", {})
		if (options.get("strike", []) as Array).has(cell):
			return {"action": "strike", "target": cell}
		if (options.get("move", []) as Array).has(cell):
			return {"action": "move", "to": cell}
	var unit: Dictionary = unit_at(cell, snapshot)
	if unit.is_empty() or int(unit["uid"]) == selected_uid:
		selected_uid = NONE
	else:
		selected_uid = int(unit["uid"])
	return {}


## Drops the selection if its unit is gone from a new snapshot (died, battle ended).
func refresh(snapshot: Dictionary) -> void:
	if selected_uid != NONE and selected_unit(snapshot).is_empty():
		selected_uid = NONE


func clear() -> void:
	selected_uid = NONE


func is_hero_selected(snapshot: Dictionary) -> bool:
	var hero: Dictionary = snapshot.get("hero", {})
	return selected_uid != NONE and int(hero.get("uid", NONE)) == selected_uid


## The selected unit's snapshot entry, or {} when nothing is selected.
func selected_unit(snapshot: Dictionary) -> Dictionary:
	return unit_by_uid(selected_uid, snapshot)


## The snapshot entry of the unit with `uid`, or {}.
static func unit_by_uid(uid: int, snapshot: Dictionary) -> Dictionary:
	for unit: Dictionary in snapshot.get("units", []):
		if int(unit["uid"]) == uid:
			return unit
	return {}


## The selected enemy's intent entry, or {} when no enemy (or one with no intent) is selected.
func selected_intent(snapshot: Dictionary) -> Dictionary:
	for intent: Dictionary in snapshot.get("intents", []):
		if int(intent["uid"]) == selected_uid:
			return intent
	return {}


static func unit_at(cell: Vector2i, snapshot: Dictionary) -> Dictionary:
	for unit: Dictionary in snapshot.get("units", []):
		if unit["cell"] == cell:
			return unit
	return {}


static func _in_arena(cell: Vector2i, grid: Dictionary) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < int(grid.get("width", 0)) and cell.y < int(grid.get("height", 0))
