class_name BattleIntents
extends RefCounted
## Read-only helpers over the snapshot's "intents" list (design/gdd/battle.md §3.6, §3.11).


## Maps each targeted tile to the damages aimed at it, in intent order: {Vector2i: Array[int]}.
static func damage_by_tile(intents: Array) -> Dictionary:
	var out: Dictionary = {}
	for intent: Dictionary in intents:
		for cell: Vector2i in intent.get("tiles", []):
			if not out.has(cell):
				out[cell] = [] as Array[int]
			(out[cell] as Array[int]).append(int(intent.get("damage", 0)))
	return out


## Label for one tile: "6", or "2+6" when several intents hit the same tile.
static func label(damages: Array[int]) -> String:
	var parts: PackedStringArray = []
	for d: int in damages:
		parts.append(str(d))
	return "+".join(parts)


## True when the intent targets no tiles this round (for example "approach").
static func is_move_only(intent: Dictionary) -> bool:
	return (intent.get("tiles", []) as Array).is_empty()
