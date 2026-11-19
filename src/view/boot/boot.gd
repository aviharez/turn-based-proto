extends Control
## Boot screen placeholder. Replaced by the title screen in M1.
## View code: may read sim objects, must never change sim state.

@onready var _status: Label = %Status


func _ready() -> void:
	var rng: Rng = Rng.new(20261120)
	var grid: BattleGrid = BattleGrid.new()
	_status.text = "Runedeep %s\nGodot %s\nArena %dx%d · seed %d · first roll %d" % [
		ProjectSettings.get_setting("application/config/version"),
		Engine.get_version_info()["string"],
		grid.width, grid.height, rng.get_seed(), rng.next_int(100),
	]
