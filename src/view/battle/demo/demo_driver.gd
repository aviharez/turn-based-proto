class_name DemoDriver
extends RefCounted
## TEMPORARY (deleted in story W1-26, when the real BattleSim answers commands).
## Lets the grey-box screen be tried by hand: `move` moves the hero and recomputes strike
## targets as adjacent enemies; `strike`, `guard` and `parry` use up the hero's action
## (guard/parry also spend Focus and set the stance); `end_turn` restarts the demo one round on. This is the only place the view side changes a snapshot.


static func apply(snapshot: Dictionary, command: Dictionary) -> Dictionary:
	var next: Dictionary = snapshot.duplicate(true)
	var action: String = command.get("action", "")
	if action == "end_turn":
		var fresh: Dictionary = DemoSnapshot.week1_clearing()
		fresh["round"] = int(snapshot.get("round", 0)) + 1
		return fresh
	if action in ["strike", "guard", "parry"]:
		return _spend_action(next, action)
	if action != "move":
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


static func _spend_action(next: Dictionary, action: String) -> Dictionary:
	var hero: Dictionary = next["hero"]
	var options: Dictionary = next["options"]
	hero["acted"] = true
	if action != "strike":
		hero["focus"] = int(hero["focus"]) - int((options["costs"] as Dictionary)[action])
		for unit: Dictionary in next["units"]:
			if int(unit["uid"]) == int(hero["uid"]):
				unit["stance"] = action
	options["strike"] = []
	options["guard"] = false
	options["parry"] = false
	return next
