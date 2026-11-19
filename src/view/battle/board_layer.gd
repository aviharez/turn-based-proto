class_name BoardLayer
extends Node2D
## Grey-box board: backdrop, frame, ground, terraces and blocked tiles, drawn from a snapshot.

var _width: int = 0
var _height: int = 0
var _blocked: Dictionary = {}    # Vector2i -> true
var _elevation: Dictionary = {}  # Vector2i -> int


## Reads the "grid" part of a battle snapshot (design/gdd/battle.md §3.11).
func show_grid(grid: Dictionary) -> void:
	_width = grid.get("width", 0)
	_height = grid.get("height", 0)
	_blocked.clear()
	for cell: Vector2i in grid.get("blocked", []):
		_blocked[cell] = true
	_elevation = (grid.get("elevation", {}) as Dictionary).duplicate()
	queue_redraw()


func _draw() -> void:
	var t: int = BattleViewConfig.TILE_PX
	var pad: int = BattleViewConfig.BACKDROP_TILES * t
	draw_rect(Rect2(-pad, -pad, _width * t + pad * 2, _height * t + pad * 2), BattleViewConfig.C_BACKDROP)
	draw_rect(Rect2(-t, -t, (_width + 2) * t, (_height + 2) * t), BattleViewConfig.C_FRAME)
	for y: int in _height:
		for x: int in _width:
			_draw_ground(Vector2i(x, y))
	# Raised and blocked tiles last, so their walls and shadows overlap the tile below.
	for y: int in _height:
		for x: int in _width:
			var cell: Vector2i = Vector2i(x, y)
			if _elevation.get(cell, 0) > 0:
				_draw_terrace(cell)
			if _blocked.has(cell):
				_draw_blocked(cell)


func _draw_ground(cell: Vector2i) -> void:
	var t: int = BattleViewConfig.TILE_PX
	var colour: Color = BattleViewConfig.C_GROUND_A if (cell.x + cell.y) % 2 == 0 else BattleViewConfig.C_GROUND_B
	var r: Rect2 = Rect2(cell.x * t, cell.y * t, t, t)
	draw_rect(r, colour)
	draw_rect(r, BattleViewConfig.C_GRID_LINE, false, 1.0)


func _draw_terrace(cell: Vector2i) -> void:
	var t: int = BattleViewConfig.TILE_PX
	var wall: int = BattleViewConfig.TERRACE_WALL_PX
	var below: Vector2i = cell + Vector2i.DOWN
	var tile: Rect2 = Rect2(cell.x * t, cell.y * t, t, t)
	draw_rect(tile, BattleViewConfig.C_TERRACE_TOP)
	draw_rect(tile, BattleViewConfig.C_GRID_LINE, false, 1.0)
	# Front wall only where the tile below is lower (3/4 view shows the south face).
	if _elevation.get(below, 0) < _elevation.get(cell, 0):
		draw_rect(Rect2(cell.x * t, (cell.y + 1) * t - wall, t, wall), BattleViewConfig.C_TERRACE_WALL)
		draw_rect(Rect2(cell.x * t, (cell.y + 1) * t, t, 3), BattleViewConfig.C_SHADOW)


func _draw_blocked(cell: Vector2i) -> void:
	var t: int = BattleViewConfig.TILE_PX
	var inset: int = 3
	draw_rect(Rect2(cell.x * t + inset + 2, cell.y * t + inset + 4, t - inset * 2, t - inset * 2), BattleViewConfig.C_SHADOW)
	draw_rect(Rect2(cell.x * t + inset, cell.y * t + inset, t - inset * 2, t - inset * 2), BattleViewConfig.C_BLOCKED)
	draw_rect(Rect2(cell.x * t + inset, cell.y * t + inset, t - inset * 2, (t - inset * 2) / 2), BattleViewConfig.C_BLOCKED_TOP)
