class_name SimEvent
extends RefCounted
## Something that happened in the simulation, for the view to animate.
##
## The sim never touches nodes; it returns a list of SimEvents and the view
## plays them in order. Keep `data` to plain values (int, float, String,
## Vector2i, arrays/dictionaries of those) so events can be logged and replayed.

var type: StringName
var data: Dictionary


func _init(event_type: StringName, event_data: Dictionary = {}) -> void:
	type = event_type
	data = event_data


func _to_string() -> String:
	return "%s %s" % [type, data]
