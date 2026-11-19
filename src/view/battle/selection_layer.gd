class_name SelectionLayer
extends Node2D
## Draws the current selection: the hero's move tiles and strike targets, or the selected
## enemy's intent tiles. Drawn between the board and the units.

var _move: Array = []
var _strike: Array = []
var _intent_tiles: Array = []
var _selected_cell: Vector2i = Vector2i(-1, -1)


## Rebuilds the highlights from a snapshot and the current selection.
func show_selection(selection: BattleSelection, snapshot: Dictionary) -> void:
	_move.clear()
	_strike.clear()
	_intent_tiles.clear()
	var unit: Dictionary = selection.selected_unit(snapshot)
	_selected_cell = unit.get("cell", Vector2i(-1, -1))
	if selection.is_hero_selected(snapshot):
		var options: Dictionary = snapshot.get("options", {})
		_move = (options.get("move", []) as Array).duplicate()
		_strike = (options.get("strike", []) as Array).duplicate()
	elif not unit.is_empty():
		_intent_tiles = (selection.selected_intent(snapshot).get("tiles", []) as Array).duplicate()
	queue_redraw()


func _draw() -> void:
	var t: int = BattleViewConfig.TILE_PX
	var inset: float = BattleViewConfig.HIGHLIGHT_INSET_PX
	for cell: Vector2i in _move:
		draw_rect(_tile_rect(cell, inset), BattleViewConfig.C_MOVE_FILL)
		draw_rect(_tile_rect(cell, inset), BattleViewConfig.C_MOVE_EDGE, false, 1.0)
	for cell: Vector2i in _intent_tiles:
		draw_rect(_tile_rect(cell, inset), BattleViewConfig.C_INTENT_SELECTED_FILL)
		draw_rect(_tile_rect(cell, inset), BattleViewConfig.C_DANGER, false, 2.0)
	for cell: Vector2i in _strike:
		draw_rect(_tile_rect(cell, inset), BattleViewConfig.C_STRIKE_EDGE, false, 2.0)
	if _selected_cell.x >= 0:
		# Selection ring: a square bracket around the selected unit's tile.
		var r: Rect2 = Rect2(_selected_cell.x * t, _selected_cell.y * t, t, t)
		draw_rect(r.grow(-0.5), BattleViewConfig.C_SELECT, false, 1.0)


func _tile_rect(cell: Vector2i, inset: float) -> Rect2:
	var t: int = BattleViewConfig.TILE_PX
	return Rect2(cell.x * t + inset, cell.y * t + inset, t - inset * 2.0, t - inset * 2.0)
