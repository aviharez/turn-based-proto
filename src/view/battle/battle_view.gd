extends Node2D
## Grey-box battle screen (stories W1-20..W1-23).
## Reads a battle snapshot (design/gdd/battle.md §3.11) and never changes sim state.
## Until W1-26 it shows DemoSnapshot; pass `-- --zoom=N` on the command line to start at a zoom step.

@onready var _board: BoardLayer = %Board
@onready var _units: UnitLayer = %Units
@onready var _camera: BattleCamera = %Camera
@onready var _zoom_in: Button = %ZoomIn
@onready var _zoom_out: Button = %ZoomOut

var _snapshot: Dictionary = {}


func _ready() -> void:
	_zoom_in.pressed.connect(_camera.zoom_in)
	_zoom_out.pressed.connect(_camera.zoom_out)
	_camera.zoom_step_changed.connect(_on_zoom_step_changed)
	show_snapshot(DemoSnapshot.week1_clearing())
	_camera.set_step(_cmdline_zoom_step())
	_on_zoom_step_changed(_camera.get_step())


## Redraws the whole screen from a snapshot.
func show_snapshot(snapshot: Dictionary) -> void:
	_snapshot = snapshot
	var grid: Dictionary = snapshot.get("grid", {})
	_board.show_grid(grid)
	_units.show_units(snapshot.get("units", []), grid)
	var t: int = BattleViewConfig.TILE_PX
	_camera.arena_size_px = Vector2(int(grid.get("width", 0)) * t, int(grid.get("height", 0)) * t)


func _on_zoom_step_changed(step: int) -> void:
	_zoom_in.disabled = step <= 0
	_zoom_out.disabled = step >= _camera.step_count() - 1


func _cmdline_zoom_step() -> int:
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--zoom="):
			return int(arg.trim_prefix("--zoom="))
	return BattleViewConfig.DEFAULT_ZOOM_STEP
