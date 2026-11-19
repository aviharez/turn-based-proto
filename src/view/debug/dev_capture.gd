extends Node
## Debug-only capture helper for devlog material (autoload "DevCapture").
## F9 (or a 3-finger tap on a phone): saves a full-resolution screenshot.
## Running from the editor/desktop: res://production/devlog/media/inbox/
## On a phone: user://devlog/ (pull with `adb pull`), or just use Android's screen recorder.
## Does nothing in release exports.

const KEY: Key = KEY_F9
const TOUCHES_FOR_CAPTURE: int = 3

var _touches: Dictionary = {}


func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed and not key_event.echo and key_event.keycode == KEY:
			capture()
	elif event is InputEventScreenTouch:
		var touch: InputEventScreenTouch = event
		if touch.pressed:
			_touches[touch.index] = true
			if _touches.size() >= TOUCHES_FOR_CAPTURE:
				_touches.clear()
				capture()
		else:
			_touches.erase(touch.index)


## Saves the current frame and returns the file path ("" on failure).
func capture() -> String:
	var image: Image = get_viewport().get_texture().get_image()
	var dir: String = _target_dir()
	DirAccess.make_dir_recursive_absolute(dir)
	var stamp: String = Time.get_datetime_string_from_system().replace(":", "").replace("-", "").replace("T", "-")
	var path: String = "%s/shot-%s.png" % [dir, stamp]
	if image.save_png(path) != OK:
		push_warning("DevCapture: could not save %s" % path)
		return ""
	print("DevCapture: saved ", ProjectSettings.globalize_path(path))
	return path


func _target_dir() -> String:
	if OS.has_feature("editor") or OS.get_name() in ["Linux", "macOS", "Windows"]:
		return "res://production/devlog/media/inbox"
	return "user://devlog"
