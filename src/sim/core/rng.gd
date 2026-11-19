class_name Rng
extends RefCounted
## Deterministic random source for the simulation.
##
## The ONLY place in the project allowed to touch RandomNumberGenerator.
## Seed it once per run; save and restore it with get_state()/set_state().
## Use fork() to give a subsystem its own stream so adding a roll in one
## system never shifts the rolls of another.

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _seed: int = 0


func _init(seed_value: int = 0) -> void:
	_seed = seed_value
	_rng.seed = seed_value


## The seed this stream was created with.
func get_seed() -> int:
	return _seed


## Integer in [0, max_exclusive). max_exclusive must be > 0.
func next_int(max_exclusive: int) -> int:
	assert(max_exclusive > 0, "Rng.next_int: max_exclusive must be > 0")
	return _rng.randi_range(0, max_exclusive - 1)


## Integer in [from, to], both included.
func range_int(from: int, to: int) -> int:
	assert(from <= to, "Rng.range_int: from must be <= to")
	return _rng.randi_range(from, to)


## Float in [0, 1).
func next_float() -> float:
	return _rng.randf()


## True with the given probability (0..1).
func chance(probability: float) -> bool:
	return _rng.randf() < probability


## Random element of a non-empty array.
func pick(items: Array) -> Variant:
	assert(not items.is_empty(), "Rng.pick: items must not be empty")
	return items[next_int(items.size())]


## Shuffles the array in place (Fisher-Yates).
func shuffle(items: Array) -> void:
	for i: int in range(items.size() - 1, 0, -1):
		var j: int = next_int(i + 1)
		var tmp: Variant = items[i]
		items[i] = items[j]
		items[j] = tmp


## A new independent stream derived from this seed and a label (e.g. &"loot").
func fork(label: StringName) -> Rng:
	return Rng.new(hash(str(_seed) + ":" + String(label)))


## Opaque state for save games.
func get_state() -> int:
	return _rng.state


func set_state(state: int) -> void:
	_rng.state = state
