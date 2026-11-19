class_name IntentOverlay
extends Node2D
## Intent markers above the units: damage labels on targeted tiles ("2+6" when stacked)
## and a chevron over enemies that only approach this round.

var _labels: Dictionary = {}   # Vector2i -> String
var _chevrons: Array = []      # Vector2 head positions


## Reads "intents" and "units" from a snapshot.
func show_intents(snapshot: Dictionary) -> void:
	_labels.clear()
	_chevrons.clear()
	var by_tile: Dictionary = BattleIntents.damage_by_tile(snapshot.get("intents", []))
	for cell: Vector2i in by_tile:
		_labels[cell] = BattleIntents.label(by_tile[cell])
	var cells: Dictionary = {}
	for unit: Dictionary in snapshot.get("units", []):
		cells[int(unit["uid"])] = unit["cell"]
	for intent: Dictionary in snapshot.get("intents", []):
		if BattleIntents.is_move_only(intent) and cells.has(int(intent["uid"])):
			_chevrons.append(BattleViewConfig.cell_center(cells[int(intent["uid"])]))
	queue_redraw()


func _draw() -> void:
	var font: Font = ThemeDB.fallback_font
	var fs: int = BattleViewConfig.INTENT_FONT_PX
	var t: int = BattleViewConfig.TILE_PX
	for cell: Vector2i in _labels:
		var text: String = _labels[cell]
		var w: float = BattleViewConfig.text_width_world(self, font, text, fs)
		# Bottom-right corner of the tile, clear of the unit's HP bar.
		var box: Rect2 = Rect2(Vector2((cell.x + 1) * t - w - 4.0, (cell.y + 1) * t - fs - 3.0), Vector2(w + 3.0, fs + 2.0))
		draw_rect(box, BattleViewConfig.C_OUTLINE)
		draw_rect(box, BattleViewConfig.C_DANGER, false, 1.0)
		BattleViewConfig.draw_text_crisp(self, font, Vector2(box.position.x + 1.5, box.end.y - 2.5), text, fs, BattleViewConfig.C_RIM)
	for centre: Vector2 in _chevrons:
		var tip: Vector2 = centre + Vector2(0.0, -BattleViewConfig.TOKEN_RADIUS_PX - 13.0)
		for i: int in 2:
			var y: float = tip.y + i * 3.0
			draw_polyline(PackedVector2Array([Vector2(tip.x - 3.0, y - 2.0), Vector2(tip.x, y + 1.0), Vector2(tip.x + 3.0, y - 2.0)]), BattleViewConfig.C_APPROACH, 1.0)
