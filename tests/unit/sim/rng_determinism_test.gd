extends GdUnitTestSuite
## Rng must give identical sequences for identical seeds — the sim depends on it.

const SEED_A: int = 12345
const SEED_B: int = 54321
const ROLLS: int = 200


func _roll_sequence(rng: Rng) -> Array[int]:
	var out: Array[int] = []
	for i: int in ROLLS:
		out.append(rng.next_int(1000))
	return out


func test_same_seed_same_sequence() -> void:
	assert_array(_roll_sequence(Rng.new(SEED_A))).is_equal(_roll_sequence(Rng.new(SEED_A)))


func test_different_seed_different_sequence() -> void:
	assert_array(_roll_sequence(Rng.new(SEED_A))).is_not_equal(_roll_sequence(Rng.new(SEED_B)))


func test_state_restore_replays_rolls() -> void:
	var rng: Rng = Rng.new(SEED_A)
	rng.next_int(10)
	var saved: int = rng.get_state()
	var first: Array[int] = _roll_sequence(rng)
	rng.set_state(saved)
	assert_array(_roll_sequence(rng)).is_equal(first)


func test_fork_is_independent_of_parent_rolls() -> void:
	var a: Rng = Rng.new(SEED_A)
	var b: Rng = Rng.new(SEED_A)
	b.next_int(10)  # extra roll on the parent must not shift the forked stream
	assert_array(_roll_sequence(a.fork(&"loot"))).is_equal(_roll_sequence(b.fork(&"loot")))


func test_next_int_stays_in_range() -> void:
	var rng: Rng = Rng.new(SEED_B)
	for i: int in ROLLS:
		assert_int(rng.next_int(3)).is_between(0, 2)


func test_shuffle_keeps_all_items_and_is_deterministic() -> void:
	var a: Array = [1, 2, 3, 4, 5, 6]
	var b: Array = [1, 2, 3, 4, 5, 6]
	Rng.new(SEED_A).shuffle(a)
	Rng.new(SEED_A).shuffle(b)
	assert_array(a).is_equal(b)
	assert_array(a).contains_exactly_in_any_order([1, 2, 3, 4, 5, 6])
