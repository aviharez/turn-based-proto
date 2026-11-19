class_name DemoSnapshot
extends RefCounted
## TEMPORARY (deleted in story W1-26): a hand-made battle snapshot in the shape of
## design/gdd/battle.md §3.11, so the grey-box view can be built before the sim exists.
## Values follow battle.md §7 (wk1_clearing) at the start of round 2, plus one extra tuyul
## (uid 5) so every intent kind and a stacked tile show at once for the W1-22 evidence.


static func week1_clearing() -> Dictionary:
	var elevation: Dictionary = {
		Vector2i(0, 3): 1, Vector2i(0, 4): 1, Vector2i(6, 3): 1, Vector2i(6, 4): 1,
	}
	var units: Array = [
		{"uid": 0, "id": "silat", "team": "hero", "cell": Vector2i(3, 6), "hp": 24, "hp_max": 30, "stance": ""},
		{"uid": 1, "id": "tuyul", "team": "enemy", "cell": Vector2i(3, 5), "hp": 8, "hp_max": 8, "stance": ""},
		{"uid": 2, "id": "tuyul", "team": "enemy", "cell": Vector2i(5, 6), "hp": 3, "hp_max": 8, "stance": ""},
		{"uid": 3, "id": "tuyul", "team": "enemy", "cell": Vector2i(6, 3), "hp": 8, "hp_max": 8, "stance": ""},
		{"uid": 4, "id": "brute", "team": "enemy", "cell": Vector2i(2, 6), "hp": 20, "hp_max": 20, "stance": ""},
		{"uid": 5, "id": "tuyul", "team": "enemy", "cell": Vector2i(4, 5), "hp": 8, "hp_max": 8, "stance": ""},
	]
	var intents: Array = [
		{"uid": 1, "kind": "melee", "tiles": [Vector2i(3, 6)], "damage": 2},
		{"uid": 2, "kind": "melee", "tiles": [Vector2i(4, 6)], "damage": 2},
		{"uid": 3, "kind": "approach", "tiles": [], "damage": 0},
		{"uid": 4, "kind": "smash", "tiles": [Vector2i(3, 6), Vector2i(4, 6)], "damage": 6},
		{"uid": 5, "kind": "melee", "tiles": [Vector2i(4, 6)], "damage": 2},
	]
	return {
		"round": 2, "phase": "player", "result": "",
		"grid": {"width": 7, "height": 8, "blocked": [Vector2i(2, 4), Vector2i(4, 4)], "elevation": elevation},
		"units": units,
		"hero": {"uid": 0, "focus": 3, "focus_max": 6, "moved": false, "acted": false},
		"intents": intents,
		"options": {
			"move": [Vector2i(4, 6), Vector2i(4, 7), Vector2i(3, 7), Vector2i(2, 7), Vector2i(5, 7), Vector2i(1, 7)],
			"strike": [Vector2i(3, 5), Vector2i(2, 6)],
			"guard": true, "parry": true,
		},
	}
