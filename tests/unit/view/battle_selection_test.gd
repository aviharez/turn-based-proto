extends GdUnitTestSuite
## Tap-to-select rules (story W1-21). Uses the demo snapshot as the fixture.

const HERO_CELL: Vector2i = Vector2i(3, 6)
const BRUTE_CELL: Vector2i = Vector2i(2, 6)
const EMPTY_CELL: Vector2i = Vector2i(0, 0)
const MOVE_CELL: Vector2i = Vector2i(4, 7)
const STRIKE_CELL: Vector2i = Vector2i(3, 5)

var _snap: Dictionary
var _sel: BattleSelection


func before_test() -> void:
	_snap = DemoSnapshot.week1_clearing()
	_sel = BattleSelection.new()


func test_tap_hero_selects_it() -> void:
	assert_dict(_sel.tap(HERO_CELL, _snap)).is_empty()
	assert_bool(_sel.is_hero_selected(_snap)).is_true()


func test_tap_enemy_selects_it_and_exposes_intent() -> void:
	_sel.tap(BRUTE_CELL, _snap)
	assert_int(_sel.selected_uid).is_equal(4)
	assert_str(String(_sel.selected_intent(_snap)["kind"])).is_equal("smash")


func test_tap_empty_clears() -> void:
	_sel.tap(HERO_CELL, _snap)
	_sel.tap(EMPTY_CELL, _snap)
	assert_int(_sel.selected_uid).is_equal(BattleSelection.NONE)


func test_tap_same_unit_again_deselects() -> void:
	_sel.tap(BRUTE_CELL, _snap)
	_sel.tap(BRUTE_CELL, _snap)
	assert_int(_sel.selected_uid).is_equal(BattleSelection.NONE)


func test_hero_then_move_tile_emits_move_command() -> void:
	_sel.tap(HERO_CELL, _snap)
	assert_dict(_sel.tap(MOVE_CELL, _snap)).is_equal({"action": "move", "to": MOVE_CELL})


func test_hero_then_enemy_in_strike_options_emits_strike() -> void:
	_sel.tap(HERO_CELL, _snap)
	assert_dict(_sel.tap(STRIKE_CELL, _snap)).is_equal({"action": "strike", "target": STRIKE_CELL})


func test_move_tile_without_hero_selected_does_nothing() -> void:
	assert_dict(_sel.tap(MOVE_CELL, _snap)).is_empty()
	assert_int(_sel.selected_uid).is_equal(BattleSelection.NONE)


func test_tap_outside_arena_clears_and_sends_nothing() -> void:
	_sel.tap(HERO_CELL, _snap)
	assert_dict(_sel.tap(Vector2i(-1, 6), _snap)).is_empty()
	assert_dict(_sel.tap(Vector2i(7, 8), _snap)).is_empty()
	assert_int(_sel.selected_uid).is_equal(BattleSelection.NONE)


func test_tap_never_changes_snapshot() -> void:
	var before: Dictionary = _snap.duplicate(true)
	_sel.tap(HERO_CELL, _snap)
	_sel.tap(MOVE_CELL, _snap)
	assert_dict(_snap).is_equal(before)


func test_refresh_drops_selection_of_removed_unit() -> void:
	_sel.tap(BRUTE_CELL, _snap)
	var units: Array = _snap["units"]
	units.remove_at(4)
	_sel.refresh(_snap)
	assert_int(_sel.selected_uid).is_equal(BattleSelection.NONE)


func test_demo_driver_move_updates_hero_and_strike_targets() -> void:
	var next: Dictionary = DemoDriver.apply(_snap, {"action": "move", "to": Vector2i(5, 7)})
	assert_that((next["units"] as Array)[0]["cell"]).is_equal(Vector2i(5, 7))
	assert_array(next["options"]["strike"]).contains_exactly([Vector2i(5, 6)])
	assert_array(next["options"]["move"]).is_empty()
	assert_that(_snap["units"][0]["cell"]).is_equal(HERO_CELL)
