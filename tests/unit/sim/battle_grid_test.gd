extends GdUnitTestSuite


func test_default_size_matches_tuning() -> void:
	var grid: BattleGrid = BattleGrid.new()
	assert_int(grid.width).is_equal(Tuning.ARENA_WIDTH)
	assert_int(grid.height).is_equal(Tuning.ARENA_HEIGHT)


func test_corners_in_bounds_and_outside_not() -> void:
	var grid: BattleGrid = BattleGrid.new(7, 8)
	assert_bool(grid.in_bounds(Vector2i(0, 0))).is_true()
	assert_bool(grid.in_bounds(Vector2i(6, 7))).is_true()
	assert_bool(grid.in_bounds(Vector2i(7, 0))).is_false()
	assert_bool(grid.in_bounds(Vector2i(0, -1))).is_false()


func test_blocked_cell_is_not_walkable_until_cleared() -> void:
	var grid: BattleGrid = BattleGrid.new(7, 8)
	var cell: Vector2i = Vector2i(3, 3)
	grid.set_blocked(cell, true)
	assert_bool(grid.is_walkable(cell)).is_false()
	grid.set_blocked(cell, false)
	assert_bool(grid.is_walkable(cell)).is_true()


func test_corner_has_two_neighbours_in_fixed_order() -> void:
	var grid: BattleGrid = BattleGrid.new(7, 8)
	var result: Array[Vector2i] = grid.neighbours(Vector2i(0, 0))
	assert_array(result).is_equal([Vector2i(1, 0), Vector2i(0, 1)])


func test_manhattan_distance() -> void:
	assert_int(BattleGrid.manhattan(Vector2i(0, 0), Vector2i(3, 4))).is_equal(7)
