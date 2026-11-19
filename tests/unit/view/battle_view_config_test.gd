extends GdUnitTestSuite
## Zoom and layout maths for the battle camera (story W1-20).

const PHONE_WIDTH: float = 1080.0


func test_battle_step_shows_nine_tiles_across() -> void:
	var z: float = BattleViewConfig.zoom_for_step(PHONE_WIDTH, 0)
	assert_float(PHONE_WIDTH / z).is_equal_approx(9.0 * BattleViewConfig.TILE_PX, 0.001)


func test_each_step_shows_its_tile_count() -> void:
	for step: int in BattleViewConfig.ZOOM_TILES_ACROSS.size():
		var tiles: int = BattleViewConfig.ZOOM_TILES_ACROSS[step]
		var z: float = BattleViewConfig.zoom_for_step(PHONE_WIDTH, step)
		assert_float(PHONE_WIDTH / z / BattleViewConfig.TILE_PX).is_equal_approx(float(tiles), 0.001)


func test_steps_out_of_range_are_clamped() -> void:
	var last: int = BattleViewConfig.ZOOM_TILES_ACROSS.size() - 1
	assert_float(BattleViewConfig.zoom_for_step(PHONE_WIDTH, -3)).is_equal(BattleViewConfig.zoom_for_step(PHONE_WIDTH, 0))
	assert_float(BattleViewConfig.zoom_for_step(PHONE_WIDTH, 99)).is_equal(BattleViewConfig.zoom_for_step(PHONE_WIDTH, last))


func test_three_zoom_steps_widening() -> void:
	assert_int(BattleViewConfig.ZOOM_TILES_ACROSS.size()).is_equal(3)
	assert_int(BattleViewConfig.ZOOM_TILES_ACROSS[0]).is_less(BattleViewConfig.ZOOM_TILES_ACROSS[2])


func test_battle_tile_is_finger_sized() -> void:
	# 48 dp at ~2.6 px/dp on a 1080-wide phone ≈ 125 px; a 9-across tile is 120 px, which the brief accepts (~46 dp).
	var tile_px: float = BattleViewConfig.zoom_for_step(PHONE_WIDTH, 0) * BattleViewConfig.TILE_PX
	assert_float(tile_px).is_greater_equal(110.0)


func test_camera_position_is_whole_pixels_and_centres_arena() -> void:
	var size: Vector2 = Vector2(1080, 1920)
	var arena: Vector2 = Vector2(7 * 32, 8 * 32)
	var z: float = BattleViewConfig.zoom_for_step(size.x, 0)
	var pos: Vector2 = BattleViewConfig.camera_position(size, z, arena)
	assert_float(pos.x).is_equal(arena.x * 0.5)
	assert_float(pos.y).is_equal(roundf(pos.y))


func test_world_to_cell_round_trip() -> void:
	var cell: Vector2i = Vector2i(4, 6)
	assert_that(BattleViewConfig.world_to_cell(BattleViewConfig.cell_center(cell))).is_equal(cell)
	assert_that(BattleViewConfig.world_to_cell(Vector2(-1, 5))).is_equal(Vector2i(-1, 0))
