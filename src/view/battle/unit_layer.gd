class_name UnitLayer
extends Node2D
## Grey-box unit tokens: shadow, body, pale rim on enemies, initial letter, HP bar.

var _units: Array = []
var _elevation: Dictionary = {}


## Reads "units" and "grid.elevation" from a battle snapshot (design/gdd/battle.md §3.11).
func show_units(units: Array, grid: Dictionary) -> void:
	_units = units.duplicate(true)
	_elevation = (grid.get("elevation", {}) as Dictionary).duplicate()
	queue_redraw()


func _draw() -> void:
	var font: Font = ThemeDB.fallback_font
	var sorted: Array = _units.duplicate()
	sorted.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return (a["cell"] as Vector2i).y < (b["cell"] as Vector2i).y)
	for unit: Dictionary in sorted:
		_draw_unit(unit, font)


func _draw_unit(unit: Dictionary, font: Font) -> void:
	var cell: Vector2i = unit["cell"]
	var lift: float = BattleViewConfig.TERRACE_WALL_PX * 0.5 if _elevation.get(cell, 0) > 0 else 0.0
	var centre: Vector2 = BattleViewConfig.cell_center(cell) - Vector2(0.0, 3.0 + lift)
	var r: float = BattleViewConfig.TOKEN_RADIUS_PX
	var is_enemy: bool = unit.get("team", "") == "enemy"
	var body: Color = _body_colour(unit.get("id", ""))
	# contact shadow
	draw_set_transform(centre + Vector2(1.0, r - 1.0), 0.0, Vector2(1.0, 0.4))
	draw_circle(Vector2.ZERO, r, BattleViewConfig.C_SHADOW)
	draw_set_transform(Vector2.ZERO)
	draw_circle(centre, r + 1.0, BattleViewConfig.C_OUTLINE)
	draw_circle(centre, r, body)
	if is_enemy:
		draw_arc(centre, r, PI, PI * 1.5, 8, BattleViewConfig.C_RIM, 1.0)
	var letter: String = String(unit.get("id", "?")).substr(0, 1).to_upper()
	var fs: int = BattleViewConfig.TOKEN_FONT_PX
	draw_string(font, centre + Vector2(-r, fs * 0.35), letter, HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, fs, BattleViewConfig.C_RIM)
	_draw_hp(centre - Vector2(r, r + 5.0), r * 2.0, unit, is_enemy)


func _draw_hp(origin: Vector2, width: float, unit: Dictionary, is_enemy: bool) -> void:
	var hp: int = unit.get("hp", 0)
	var hp_max: int = maxi(1, unit.get("hp_max", 1))
	draw_rect(Rect2(origin, Vector2(width, 3.0)), BattleViewConfig.C_OUTLINE)
	draw_rect(Rect2(origin + Vector2.ONE, Vector2(width - 2.0, 1.0)), BattleViewConfig.C_HP_BACK)
	var fill: float = (width - 2.0) * float(hp) / float(hp_max)
	var colour: Color = BattleViewConfig.C_HP_FILL if is_enemy else BattleViewConfig.C_HP_HERO
	draw_rect(Rect2(origin + Vector2.ONE, Vector2(fill, 1.0)), colour)


func _body_colour(id: String) -> Color:
	match id:
		"silat":
			return BattleViewConfig.C_HERO
		"tuyul":
			return BattleViewConfig.C_TUYUL
		_:
			return BattleViewConfig.C_BRUTE
