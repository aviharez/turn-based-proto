class_name BattleHudModel
extends RefCounted
## What the battle HUD shows, worked out from a snapshot (design/gdd/battle.md §3.11) with no
## nodes, so it can be unit-tested. Button availability and Focus costs come only from
## `options` (including `options.costs`); the view never reads Tuning.

const CAST_ENABLED_IN_WEEK1: bool = false


## Returns {round, hp, hp_max, focus, focus_max, buttons: {name: {enabled, cost}}}.
static func build(snapshot: Dictionary) -> Dictionary:
	var hero: Dictionary = snapshot.get("hero", {})
	var options: Dictionary = snapshot.get("options", {})
	var costs: Dictionary = options.get("costs", {})
	var hero_unit: Dictionary = BattleSelection.unit_by_uid(int(hero.get("uid", -1)), snapshot)
	var player_turn: bool = snapshot.get("phase", "") == "player" and String(snapshot.get("result", "")) == ""
	var can_act: bool = player_turn and not bool(hero.get("acted", false))
	return {
		"round": int(snapshot.get("round", 0)),
		"hp": int(hero_unit.get("hp", 0)),
		"hp_max": int(hero_unit.get("hp_max", 0)),
		"focus": int(hero.get("focus", 0)),
		"focus_max": int(hero.get("focus_max", 0)),
		"buttons": {
			"strike": {"enabled": can_act and not (options.get("strike", []) as Array).is_empty(), "cost": 0},
			"cast": {"enabled": CAST_ENABLED_IN_WEEK1, "cost": 0},
			"guard": {"enabled": player_turn and bool(options.get("guard", false)), "cost": int(costs.get("guard", 0))},
			"parry": {"enabled": player_turn and bool(options.get("parry", false)), "cost": int(costs.get("parry", 0))},
			"end_turn": {"enabled": player_turn, "cost": 0},
		},
	}


## The one-line explanation of an enemy intent as {key, args} for tr(), or {} for no line.
## Unit names use the key "UNIT_<ID>" (story W1-27).
static func intent_line(unit: Dictionary, intent: Dictionary) -> Dictionary:
	if unit.is_empty() or intent.is_empty():
		return {}
	var name_key: String = "UNIT_" + String(unit.get("id", "")).to_upper()
	var tiles: int = (intent.get("tiles", []) as Array).size()
	var damage: int = int(intent.get("damage", 0))
	if tiles == 0:
		return {"key": "UI_INTENT_APPROACH", "args": [name_key]}
	if tiles == 1:
		return {"key": "UI_INTENT_ATTACK", "args": [name_key, damage]}
	return {"key": "UI_INTENT_ATTACK_AREA", "args": [name_key, tiles, damage]}
