extends GdUnitTestSuite
## Guards the relationships between Tuning constants that design/gdd/battle.md relies on.


func test_focus_start_within_max() -> void:
	assert_int(Tuning.FOCUS_START).is_between(0, Tuning.FOCUS_MAX)


func test_every_action_cost_is_affordable_at_max_focus() -> void:
	for cost: int in [Tuning.STRIKE_COST, Tuning.GUARD_COST, Tuning.PARRY_COST]:
		assert_int(cost).is_between(0, Tuning.FOCUS_MAX)


func test_parry_costs_more_than_guard() -> void:
	assert_int(Tuning.PARRY_COST).is_greater(Tuning.GUARD_COST)


func test_percentages_in_range() -> void:
	assert_int(Tuning.GUARD_REDUCTION_PCT).is_between(0, 100)
	assert_int(Tuning.PARRY_REFLECT_PCT).is_greater_equal(0)


func test_arena_fits_battle_view_with_frame() -> void:
	# Battle view shows 9 tiles across: arena + 1-tile frame on each side.
	assert_int(Tuning.ARENA_WIDTH + 2).is_equal(9)
