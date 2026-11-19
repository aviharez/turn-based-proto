class_name BattleHud
extends Control
## Battle HUD on the UI CanvasLayer, at native resolution: round, HP, Focus pips, the intent
## line, the action bar (Strike, Cast, Guard, Parry), End turn and zoom. Everything a thumb
## presses sits in the bottom 60% of the screen. Built in code from BattleViewConfig sizes.

signal action_pressed(action: String)
signal zoom_in_pressed
signal zoom_out_pressed

const ACTIONS: Array[String] = ["strike", "cast", "guard", "parry"]
const ACTION_KEYS: Dictionary = {
	"strike": "UI_STRIKE", "cast": "UI_CAST", "guard": "UI_GUARD", "parry": "UI_PARRY", "end_turn": "UI_END_TURN",
}

var _buttons: Dictionary = {}       # action -> Button
var _cost_badges: Dictionary = {}   # action -> Label
var _round_label: Label
var _hp_bar: ProgressBar
var _hp_label: Label
var _focus_row: HBoxContainer
var _focus_label: Label
var _intent_label: Label
var _zoom_in: Button
var _zoom_out: Button


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	theme = _make_theme()
	_build_top()
	_build_bottom()


## Every control a thumb can press, for layout checks.
func touch_controls() -> Array[Control]:
	var out: Array[Control] = []
	for b: Button in _buttons.values():
		out.append(b)
	out.append(_zoom_in)
	out.append(_zoom_out)
	return out


## Updates every widget from a BattleHudModel.build() result and an intent line ({} for none).
func show_model(model: Dictionary, intent_line: Dictionary) -> void:
	_round_label.text = _fmt("UI_ROUND", [model["round"]])
	_hp_bar.max_value = maxi(1, int(model["hp_max"]))
	_hp_bar.value = int(model["hp"])
	_hp_label.text = "%s %d/%d" % [tr("UI_HP"), model["hp"], model["hp_max"]]
	_focus_label.text = tr("UI_FOCUS")
	_set_pips(int(model["focus"]), int(model["focus_max"]))
	var buttons: Dictionary = model["buttons"]
	for action: String in _buttons:
		var state: Dictionary = buttons.get(action, {})
		(_buttons[action] as Button).disabled = not bool(state.get("enabled", false))
		if _cost_badges.has(action):
			(_cost_badges[action] as Label).text = str(state.get("cost", 0))
	if intent_line.is_empty():
		_intent_label.text = ""
	else:
		var args: Array = (intent_line["args"] as Array).duplicate()
		if not args.is_empty():
			args[0] = tr(String(args[0]))  # unit name key
		_intent_label.text = _fmt(String(intent_line["key"]), args)


func set_zoom_limits(at_closest: bool, at_widest: bool) -> void:
	_zoom_in.disabled = at_closest
	_zoom_out.disabled = at_widest


## tr() with printf args. Shows the bare key when its translation is missing or has the wrong
## number of placeholders, so a missing string is visible instead of crashing the format.
func _fmt(key: String, args: Array) -> String:
	var text: String = tr(key)
	if text == key or text.count("%") != args.size():
		return key
	return text % args


func _build_top() -> void:
	var c: Dictionary = BattleViewConfig.HUD
	_round_label = Label.new()
	_round_label.position = Vector2(c["margin"], c["margin"])
	_round_label.add_theme_font_size_override("font_size", c["font_small"])
	add_child(_round_label)


func _build_bottom() -> void:
	var c: Dictionary = BattleViewConfig.HUD
	var column: VBoxContainer = VBoxContainer.new()
	column.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	column.offset_left = c["margin"]
	column.offset_right = -c["margin"]
	column.offset_bottom = -c["margin"]
	column.grow_vertical = Control.GROW_DIRECTION_BEGIN
	column.add_theme_constant_override("separation", c["gap"])
	add_child(column)
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE

	_intent_label = Label.new()
	_intent_label.custom_minimum_size.y = c["font_small"] + 12
	_intent_label.add_theme_font_size_override("font_size", c["font_small"])
	_intent_label.add_theme_color_override("font_color", BattleViewConfig.C_APPROACH)
	_intent_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(_intent_label)

	var status: HBoxContainer = HBoxContainer.new()
	status.add_theme_constant_override("separation", c["gap"])
	column.add_child(status)
	status.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var hp_box: Control = Control.new()
	hp_box.custom_minimum_size = Vector2(0, c["bar_h"])
	hp_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status.add_child(hp_box)
	hp_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_hp_bar = ProgressBar.new()
	_hp_bar.show_percentage = false
	_hp_bar.set_anchors_preset(Control.PRESET_FULL_RECT)
	_hp_bar.add_theme_stylebox_override("background", _box(BattleViewConfig.C_HP_BACK, BattleViewConfig.C_OUTLINE, 6))
	_hp_bar.add_theme_stylebox_override("fill", _box(BattleViewConfig.C_HP_HERO.darkened(0.25), BattleViewConfig.C_OUTLINE, 6))
	hp_box.add_child(_hp_bar)
	_hp_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_hp_label = Label.new()
	_hp_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hp_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_hp_label.add_theme_font_size_override("font_size", c["font_small"])
	hp_box.add_child(_hp_label)
	_focus_label = Label.new()
	_focus_label.add_theme_font_size_override("font_size", c["font_small"])
	_focus_label.add_theme_color_override("font_color", BattleViewConfig.C_FOCUS)
	status.add_child(_focus_label)
	_focus_row = HBoxContainer.new()
	_focus_row.add_theme_constant_override("separation", 8)
	_focus_row.alignment = BoxContainer.ALIGNMENT_END
	status.add_child(_focus_row)
	_focus_row.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var actions: HBoxContainer = HBoxContainer.new()
	actions.add_theme_constant_override("separation", c["gap"])
	column.add_child(actions)
	actions.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for action: String in ACTIONS:
		var b: Button = _make_button(action, c["action_h"])
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		actions.add_child(b)
		if action == "guard" or action == "parry":
			_add_cost_badge(action, b)

	var last: HBoxContainer = HBoxContainer.new()
	last.add_theme_constant_override("separation", c["gap"])
	column.add_child(last)
	last.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var end_turn: Button = _make_button("end_turn", c["row_h"])
	end_turn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	last.add_child(end_turn)
	_zoom_in = _make_plain_button("+", c["row_h"])
	_zoom_in.tooltip_text = "UI_ZOOM_IN"
	_zoom_in.pressed.connect(func() -> void: zoom_in_pressed.emit())
	last.add_child(_zoom_in)
	_zoom_out = _make_plain_button("−", c["row_h"])
	_zoom_out.tooltip_text = "UI_ZOOM_OUT"
	_zoom_out.pressed.connect(func() -> void: zoom_out_pressed.emit())
	last.add_child(_zoom_out)


func _make_button(action: String, height: int) -> Button:
	var b: Button = Button.new()
	b.text = ACTION_KEYS[action]  # auto-translated by the Button
	b.custom_minimum_size = Vector2(BattleViewConfig.HUD["min_touch"], height)
	b.pressed.connect(func() -> void: action_pressed.emit(action))
	_buttons[action] = b
	return b


func _make_plain_button(text: String, side: int) -> Button:
	var b: Button = Button.new()
	b.text = text
	b.auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED
	b.custom_minimum_size = Vector2(side, side)
	b.add_theme_font_size_override("font_size", BattleViewConfig.HUD["font_big"])
	return b


func _add_cost_badge(action: String, button: Button) -> void:
	var badge: Label = Label.new()
	badge.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	badge.offset_left = -64
	badge.offset_top = 10
	badge.offset_right = -10
	badge.offset_bottom = 64
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.add_theme_font_size_override("font_size", BattleViewConfig.HUD["font_small"])
	badge.add_theme_color_override("font_color", BattleViewConfig.C_OUTLINE)
	badge.add_theme_stylebox_override("normal", _box(BattleViewConfig.C_FOCUS, BattleViewConfig.C_OUTLINE, 27))
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(badge)
	_cost_badges[action] = badge


func _set_pips(focus: int, focus_max: int) -> void:
	while _focus_row.get_child_count() < focus_max:
		var pip: Panel = Panel.new()
		pip.custom_minimum_size = Vector2.ONE * BattleViewConfig.HUD["pip"]
		pip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		pip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_focus_row.add_child(pip)
	for i: int in _focus_row.get_child_count():
		var pip: Panel = _focus_row.get_child(i)
		pip.visible = i < focus_max
		var fill: Color = BattleViewConfig.C_FOCUS if i < focus else BattleViewConfig.C_HP_BACK
		pip.add_theme_stylebox_override("panel", _box(fill, BattleViewConfig.C_OUTLINE, BattleViewConfig.HUD["pip"] / 2))


func _make_theme() -> Theme:
	var t: Theme = Theme.new()
	t.default_font_size = BattleViewConfig.HUD["font_big"]
	t.set_stylebox("normal", "Button", _box(BattleViewConfig.C_BUTTON, BattleViewConfig.C_OUTLINE, 14))
	t.set_stylebox("hover", "Button", _box(BattleViewConfig.C_BUTTON, BattleViewConfig.C_OUTLINE, 14))
	t.set_stylebox("pressed", "Button", _box(BattleViewConfig.C_BUTTON_PRESSED, BattleViewConfig.C_OUTLINE, 14))
	t.set_stylebox("disabled", "Button", _box(BattleViewConfig.C_BUTTON_DISABLED, BattleViewConfig.C_OUTLINE, 14))
	t.set_stylebox("focus", "Button", StyleBoxEmpty.new())
	t.set_color("font_color", "Button", BattleViewConfig.C_RIM)
	t.set_color("font_hover_color", "Button", BattleViewConfig.C_RIM)
	t.set_color("font_pressed_color", "Button", BattleViewConfig.C_RIM)
	t.set_color("font_disabled_color", "Button", BattleViewConfig.C_TEXT_DISABLED)
	t.set_color("font_color", "Label", BattleViewConfig.C_RIM)
	t.set_color("font_outline_color", "Label", BattleViewConfig.C_OUTLINE)
	t.set_constant("outline_size", "Label", 8)
	return t


static func _box(fill: Color, border: Color, radius: int) -> StyleBoxFlat:
	var s: StyleBoxFlat = StyleBoxFlat.new()
	s.bg_color = fill
	s.border_color = border
	s.set_border_width_all(4)
	s.set_corner_radius_all(radius)
	return s
