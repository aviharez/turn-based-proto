class_name BattleGrid
extends RefCounted
## Tile grid for one battle floor. Pure data: no nodes, no rendering.

var width: int
var height: int
var _blocked: Dictionary = {}  # Vector2i -> true


func _init(grid_width: int = Tuning.ARENA_WIDTH, grid_height: int = Tuning.ARENA_HEIGHT) -> void:
	assert(grid_width > 0 and grid_height > 0, "BattleGrid: size must be positive")
	width = grid_width
	height = grid_height


func in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < width and cell.y < height


func set_blocked(cell: Vector2i, blocked: bool) -> void:
	if blocked:
		_blocked[cell] = true
	else:
		_blocked.erase(cell)


func is_walkable(cell: Vector2i) -> bool:
	return in_bounds(cell) and not _blocked.has(cell)


## Grid distance with 4-way movement.
static func manhattan(a: Vector2i, b: Vector2i) -> int:
	return absi(a.x - b.x) + absi(a.y - b.y)


## Walkable 4-way neighbours in a fixed order (up, right, down, left) so results are deterministic.
func neighbours(cell: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for dir: Vector2i in [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]:
		var next: Vector2i = cell + dir
		if is_walkable(next):
			result.append(next)
	return result
