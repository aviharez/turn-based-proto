extends Node2D
## Grey-box battle screen (stories W1-20..W1-23).
## Reads a battle snapshot (design/gdd/battle.md §3.11) and never changes sim state.
## Until W1-26 it shows DemoSnapshot and DemoDriver answers move commands.
## Debug args: `-- --zoom=N` starts at a zoom step, `-- --tap=X,Y` taps a cell at start (repeatable).

## A tap on a highlighted tile; the battle screen forwards it to BattleSim.apply().
signal command_requested(command: Dictionary)

@onready var _board: BoardLayer = %Board
@onready var _units: UnitLayer = %Units
@onready var _highlights: SelectionLayer = %Highlights
@onready var _intents: IntentLayer = %Intents
@onready var _intent_overlay: IntentOverlay = %IntentOverlay
@onready var _camera: BattleCamera = %Camera
@onready var _zoom_in: Button = %ZoomIn
@onready var _zoom_out: Button = %ZoomOut

var _snapshot: Dictionary = {}
var _selection: BattleSelection = BattleSelection.new()


func _ready() -> void:
	_zoom_in.pressed.connect(_camera.zoom_in)
	_zoom_out.pressed.connect(_camera.zoom_out)
	_camera.zoom_step_changed.connect(_on_zoom_step_changed)
	command_requested.connect(_on_demo_command)
	show_snapshot(DemoSnapshot.week1_clearing())
	_camera.set_step(_cmdline_zoom_step())
	_on_zoom_step_changed(_camera.get_step())
	for cell: Vector2i in _cmdline_taps():
		tap_cell(cell)


func _unhandled_input(event: InputEvent) -> void:
	# Buttons on the UI layer consume their own taps, so only world taps reach here.
	var touch: InputEventScreenTouch = event as InputEventScreenTouch
	if touch == null or not touch.pressed:
		return
	var world: Vector2 = get_viewport().get_canvas_transform().affine_inverse() * touch.position
	tap_cell(BattleViewConfig.world_to_cell(world))
	get_viewport().set_input_as_handled()


## Applies a tap on a cell: changes the selection, or emits a command.
func tap_cell(cell: Vector2i) -> void:
	var command: Dictionary = _selection.tap(cell, _snapshot)
	_highlights.show_selection(_selection, _snapshot)
	if not command.is_empty():
		command_requested.emit(command)


## Redraws the whole screen from a snapshot.
func show_snapshot(snapshot: Dictionary) -> void:
	_snapshot = snapshot
	var grid: Dictionary = snapshot.get("grid", {})
	_board.show_grid(grid)
	_units.show_units(snapshot.get("units", []), grid, BattleIntents.damage_by_tile(snapshot.get("intents", [])))
	_intents.show_intents(snapshot)
	_intent_overlay.show_intents(snapshot)
	var t: int = BattleViewConfig.TILE_PX
	_camera.arena_size_px = Vector2(int(grid.get("width", 0)) * t, int(grid.get("height", 0)) * t)
	_selection.refresh(snapshot)
	_highlights.show_selection(_selection, snapshot)


func _on_demo_command(command: Dictionary) -> void:
	show_snapshot(DemoDriver.apply(_snapshot, command))


func _on_zoom_step_changed(step: int) -> void:
	# World text is rasterised per zoom step (BattleViewConfig.draw_text_crisp).
	_units.queue_redraw()
	_intent_overlay.queue_redraw()
	_zoom_in.disabled = step <= 0
	_zoom_out.disabled = step >= _camera.step_count() - 1


func _cmdline_zoom_step() -> int:
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--zoom="):
			return int(arg.trim_prefix("--zoom="))
	return BattleViewConfig.DEFAULT_ZOOM_STEP


func _cmdline_taps() -> Array[Vector2i]:
	var taps: Array[Vector2i] = []
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--tap="):
			var xy: PackedStringArray = arg.trim_prefix("--tap=").split(",")
			if xy.size() == 2:
				taps.append(Vector2i(int(xy[0]), int(xy[1])))
	return taps
