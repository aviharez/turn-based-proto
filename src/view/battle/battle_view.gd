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
@onready var _hud: BattleHud = %Hud

var _snapshot: Dictionary = {}
var _selection: BattleSelection = BattleSelection.new()


func _ready() -> void:
	_hud.zoom_in_pressed.connect(_camera.zoom_in)
	_hud.zoom_out_pressed.connect(_camera.zoom_out)
	_hud.action_pressed.connect(_on_action_pressed)
	_camera.zoom_step_changed.connect(_on_zoom_step_changed)
	command_requested.connect(_on_demo_command)
	show_snapshot(DemoSnapshot.week1_clearing())
	_camera.set_step(_cmdline_zoom_step())
	_on_zoom_step_changed(_camera.get_step())
	for cell: Vector2i in _cmdline_taps():
		tap_cell(cell)
	if "--layout-check" in OS.get_cmdline_user_args():
		_print_layout_check.call_deferred()


## Debug: prints the top edge of every thumb control against the bottom-60% line.
func _print_layout_check() -> void:
	await get_tree().process_frame
	var h: float = get_viewport_rect().size.y
	var line: float = h * BattleViewConfig.THUMB_ZONE_TOP_FRACTION
	var top: float = h
	var smallest: float = INF
	for c: Control in _hud.touch_controls():
		var r: Rect2 = c.get_global_rect()
		top = minf(top, r.position.y)
		smallest = minf(smallest, minf(r.size.x, r.size.y))
	print("LAYOUT viewport=%s line_y=%.0f highest_control_y=%.0f smallest_side=%.0f inside_bottom60=%s" % [get_viewport_rect().size, line, top, smallest, top >= line])


func _unhandled_input(event: InputEvent) -> void:
	# Left-button press only: on phones a touch also arrives as an emulated mouse press, and HUD
	# buttons consume that press, so a tap on a button never also taps the tile behind it.
	var press: InputEventMouseButton = event as InputEventMouseButton
	if press == null or not press.pressed or press.button_index != MOUSE_BUTTON_LEFT:
		return
	var world: Vector2 = get_viewport().get_canvas_transform().affine_inverse() * press.position
	tap_cell(BattleViewConfig.world_to_cell(world))
	get_viewport().set_input_as_handled()


## Applies a tap on a cell: changes the selection, or emits a command.
func tap_cell(cell: Vector2i) -> void:
	var command: Dictionary = _selection.tap(cell, _snapshot)
	_highlights.show_selection(_selection, _snapshot)
	_refresh_hud()
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
	_refresh_hud()


func _refresh_hud() -> void:
	var model: Dictionary = BattleHudModel.build(_snapshot)
	var line: Dictionary = BattleHudModel.intent_line(_selection.selected_unit(_snapshot), _selection.selected_intent(_snapshot))
	_hud.show_model(model, line)


## Strike with one target hits it; with several it selects the hero so the targets light up.
func _on_action_pressed(action: String) -> void:
	match action:
		"strike":
			var targets: Array = (_snapshot.get("options", {}) as Dictionary).get("strike", [])
			if targets.size() == 1:
				command_requested.emit({"action": "strike", "target": targets[0]})
			else:
				var hero: Dictionary = _snapshot.get("hero", {})
				_selection.selected_uid = int(hero.get("uid", BattleSelection.NONE))
				_highlights.show_selection(_selection, _snapshot)
				_refresh_hud()
		"guard", "parry", "end_turn":
			command_requested.emit({"action": action})


func _on_demo_command(command: Dictionary) -> void:
	show_snapshot(DemoDriver.apply(_snapshot, command))


func _on_zoom_step_changed(step: int) -> void:
	# World text is rasterised per zoom step (BattleViewConfig.draw_text_crisp).
	_units.queue_redraw()
	_intent_overlay.queue_redraw()
	_hud.set_zoom_limits(step <= 0, step >= _camera.step_count() - 1)


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
