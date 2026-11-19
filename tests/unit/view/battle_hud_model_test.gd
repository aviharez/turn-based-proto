extends GdUnitTestSuite
## HUD state rules (story W1-23): buttons follow `options`, Cast stays off in Week 1.

var _snap: Dictionary


func before_test() -> void:
	_snap = DemoSnapshot.week1_clearing()


func _buttons(snap: Dictionary) -> Dictionary:
	return BattleHudModel.build(snap)["buttons"]


func test_reads_hp_focus_and_round() -> void:
	var m: Dictionary = BattleHudModel.build(_snap)
	assert_int(m["hp"]).is_equal(24)
	assert_int(m["hp_max"]).is_equal(30)
	assert_int(m["focus"]).is_equal(3)
	assert_int(m["focus_max"]).is_equal(6)
	assert_int(m["round"]).is_equal(2)


func test_buttons_follow_options_on_player_turn() -> void:
	var b: Dictionary = _buttons(_snap)
	assert_bool(b["strike"]["enabled"]).is_true()
	assert_bool(b["guard"]["enabled"]).is_true()
	assert_bool(b["parry"]["enabled"]).is_true()
	assert_bool(b["end_turn"]["enabled"]).is_true()


func test_cast_is_always_disabled_in_week1() -> void:
	assert_bool(_buttons(_snap)["cast"]["enabled"]).is_false()


func test_guard_and_parry_off_when_sim_says_no_focus() -> void:
	_snap["options"]["guard"] = false
	_snap["options"]["parry"] = false
	var b: Dictionary = _buttons(_snap)
	assert_bool(b["guard"]["enabled"]).is_false()
	assert_bool(b["parry"]["enabled"]).is_false()
	assert_int(b["parry"]["cost"]).is_equal(2)


func test_costs_come_from_snapshot_options() -> void:
	_snap["options"]["costs"] = {"guard": 3, "parry": 5}
	var b: Dictionary = _buttons(_snap)
	assert_int(b["guard"]["cost"]).is_equal(3)
	assert_int(b["parry"]["cost"]).is_equal(5)


func test_strike_off_without_targets() -> void:
	_snap["options"]["strike"] = []
	assert_bool(_buttons(_snap)["strike"]["enabled"]).is_false()


func test_everything_off_outside_player_phase() -> void:
	_snap["phase"] = "enemy"
	for action: String in ["strike", "guard", "parry", "end_turn"]:
		assert_bool(_buttons(_snap)[action]["enabled"]).is_false()


func test_everything_off_after_battle_ends() -> void:
	_snap["result"] = "won"
	assert_bool(_buttons(_snap)["end_turn"]["enabled"]).is_false()


func test_intent_line_area_attack() -> void:
	var brute: Dictionary = BattleSelection.unit_by_uid(4, _snap)
	var intent: Dictionary = {"uid": 4, "kind": "smash", "tiles": [Vector2i(3, 6), Vector2i(4, 6)], "damage": 6}
	assert_dict(BattleHudModel.intent_line(brute, intent)).is_equal({"key": "UI_INTENT_ATTACK_AREA", "args": ["UNIT_BRUTE", 2, 6]})


func test_intent_line_single_and_approach() -> void:
	var tuyul: Dictionary = BattleSelection.unit_by_uid(1, _snap)
	assert_str(String(BattleHudModel.intent_line(tuyul, {"tiles": [Vector2i(3, 6)], "damage": 2})["key"])).is_equal("UI_INTENT_ATTACK")
	assert_str(String(BattleHudModel.intent_line(tuyul, {"tiles": [], "damage": 0})["key"])).is_equal("UI_INTENT_APPROACH")


func test_no_intent_line_without_selection() -> void:
	assert_dict(BattleHudModel.intent_line({}, {})).is_empty()
