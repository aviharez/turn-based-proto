class_name BattleCamera
extends Camera2D
## Battle camera with 3 fixed zoom steps (no pinch). Position stays on whole world pixels.

signal zoom_step_changed(step: int)

## Arena size in world pixels; set by the battle view before the first frame.
var arena_size_px: Vector2 = Vector2.ZERO:
	set(value):
		arena_size_px = value
		_apply()

var _step: int = BattleViewConfig.DEFAULT_ZOOM_STEP


func _ready() -> void:
	get_viewport().size_changed.connect(_apply)
	_apply()


## Current zoom step (0 = closest, battle view).
func get_step() -> int:
	return _step


## Number of zoom steps available.
func step_count() -> int:
	return BattleViewConfig.ZOOM_TILES_ACROSS.size()


func set_step(step: int) -> void:
	var clamped: int = clampi(step, 0, step_count() - 1)
	if clamped == _step:
		return
	_step = clamped
	_apply()
	zoom_step_changed.emit(_step)


## Closer: fewer tiles across.
func zoom_in() -> void:
	set_step(_step - 1)


## Wider: more tiles across.
func zoom_out() -> void:
	set_step(_step + 1)


func _apply() -> void:
	if not is_inside_tree():
		return
	var viewport_size: Vector2 = get_viewport_rect().size
	var z: float = BattleViewConfig.zoom_for_step(viewport_size.x, _step)
	zoom = Vector2(z, z)
	position = BattleViewConfig.camera_position(viewport_size, z, arena_size_px)
