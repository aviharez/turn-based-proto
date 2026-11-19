extends GdUnitTestSuite
## Intent marker maths (story W1-22).

const A: Vector2i = Vector2i(3, 6)
const B: Vector2i = Vector2i(4, 6)


func test_single_intent_maps_its_tiles() -> void:
	var by_tile: Dictionary = BattleIntents.damage_by_tile([{"uid": 1, "kind": "melee", "tiles": [A], "damage": 2}])
	assert_int(by_tile.size()).is_equal(1)
	assert_str(BattleIntents.label(by_tile[A])).is_equal("2")


func test_smash_marks_both_tiles() -> void:
	var by_tile: Dictionary = BattleIntents.damage_by_tile([{"uid": 4, "kind": "smash", "tiles": [A, B], "damage": 6}])
	assert_bool(by_tile.has(A) and by_tile.has(B)).is_true()


func test_stacked_intents_show_every_number_in_order() -> void:
	var intents: Array = [
		{"uid": 1, "kind": "melee", "tiles": [A], "damage": 2},
		{"uid": 4, "kind": "smash", "tiles": [A, B], "damage": 6},
	]
	var by_tile: Dictionary = BattleIntents.damage_by_tile(intents)
	assert_str(BattleIntents.label(by_tile[A])).is_equal("2+6")
	assert_str(BattleIntents.label(by_tile[B])).is_equal("6")


func test_approach_has_no_tiles_and_is_move_only() -> void:
	var approach: Dictionary = {"uid": 3, "kind": "approach", "tiles": [], "damage": 0}
	assert_bool(BattleIntents.is_move_only(approach)).is_true()
	assert_dict(BattleIntents.damage_by_tile([approach])).is_empty()


func test_no_intents_gives_empty_map() -> void:
	assert_dict(BattleIntents.damage_by_tile([])).is_empty()


func test_demo_snapshot_puts_hero_on_a_red_tile() -> void:
	var snap: Dictionary = DemoSnapshot.week1_clearing()
	var by_tile: Dictionary = BattleIntents.damage_by_tile(snap["intents"])
	assert_bool(by_tile.has(snap["units"][0]["cell"])).is_true()
	assert_str(BattleIntents.label(by_tile[B])).is_equal("2+6+2")
