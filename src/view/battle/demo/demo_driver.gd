class_name DemoDriver
extends RefCounted
## TEMPORARY (deleted in story W1-26, when the real BattleSim answers commands).
## Applies a `move` command to the demo snapshot so tap-to-move can be tried by hand, and
## recomputes strike targets as the enemies next to the hero. Other commands are ignored. This is the only place the view side changes a snapshot.


static func apply(snapshot: Dictionary, command: Dictionary) -> Dictionary:
	var next: Dictionary = snapshot.duplicate(true)
	if command.get("action", "") != "move":
		return next
	var hero: Dictionary = next["hero"]
	var to: Vector2i = command["to"]
	var strike: Array = []
	for unit: Dictionary in next["units"]:
		if int(unit["uid"]) == int(hero["uid"]):
			unit["cell"] = to
		elif unit["team"] == "enemy":
			var cell: Vector2i = unit["cell"]
			if absi(cell.x - to.x) + absi(cell.y - to.y) == 1:
				strike.append(cell)
	hero["moved"] = true
	var options: Dictionary = next["options"]
	options["move"] = []
	options["strike"] = strike
	return next
