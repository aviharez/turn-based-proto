class_name IntentLayer
extends Node2D
## Enemy intents under the units: red tiles and a line from each enemy to what it will hit.
## The tile under the hero pulses when the hero is in danger.

var _tiles: Dictionary = {}       # Vector2i -> Array[int]
var _lines: Array = []            # [from: Vector2, to: Vector2]
var _hero_cell: Vector2i = Vector2i(-1, -1)
var _time: float = 0.0


## Reads "intents", "units" and "hero" from a snapshot.
func show_intents(snapshot: Dictionary) -> void:
	var intents: Array = snapshot.get("intents", [])
	_tiles = BattleIntents.damage_by_tile(intents)
	_lines.clear()
	var cells: Dictionary = {}
	for unit: Dictionary in snapshot.get("units", []):
		cells[int(unit["uid"])] = unit["cell"]
	for intent: Dictionary in intents:
		var from: Vector2i = cells.get(int(intent["uid"]), Vector2i(-1, -1))
		if from.x < 0:
			continue
		for cell: Vector2i in intent.get("tiles", []):
			_lines.append([BattleViewConfig.cell_center(from), BattleViewConfig.cell_center(cell)])
	var hero_uid: int = int((snapshot.get("hero", {}) as Dictionary).get("uid", -1))
	_hero_cell = cells.get(hero_uid, Vector2i(-1, -1))
	set_process(_tiles.has(_hero_cell))
	queue_redraw()


func _process(delta: float) -> void:
	_time += delta
	queue_redraw()


func _draw() -> void:
	var t: int = BattleViewConfig.TILE_PX
	var inset: float = BattleViewConfig.HIGHLIGHT_INSET_PX
	for cell: Vector2i in _tiles:
		var r: Rect2 = Rect2(cell.x * t + inset, cell.y * t + inset, t - inset * 2.0, t - inset * 2.0)
		var fill: Color = BattleViewConfig.C_INTENT_FILL
		if cell == _hero_cell:
			var wave: float = 0.5 + 0.5 * sin(_time * TAU * BattleViewConfig.DANGER_PULSE_HZ)
			fill.a = lerpf(BattleViewConfig.DANGER_PULSE_ALPHA_MIN, BattleViewConfig.DANGER_PULSE_ALPHA_MAX, wave)
		draw_rect(r, fill)
		draw_rect(r, BattleViewConfig.C_DANGER, false, 1.0)
	for line: Array in _lines:
		var from: Vector2 = line[0]
		var to: Vector2 = line[1]
		draw_line(from, to, BattleViewConfig.C_DANGER, 1.0)
		draw_circle(to, 1.5, BattleViewConfig.C_DANGER)
