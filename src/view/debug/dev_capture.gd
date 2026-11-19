extends Node
## Debug-only capture helper for devlog material (autoload "DevCapture").
## F9 (or a 3-finger tap on a phone): saves a full-resolution screenshot.
## Running from the editor/desktop: res://production/devlog/media/inbox/
## On a phone: user://devlog/ (pull with `adb pull`), or just use Android's screen recorder.
## Does nothing in release exports.
## Scripted: `-- --capture-to=/abs/path.png [--capture-frames=N]` saves the frame after N frames
## (default 20) and quits; used for QA evidence at any window shape.

const KEY: Key = KEY_F9
const TOUCHES_FOR_CAPTURE: int = 3
const DEFAULT_CAPTURE_FRAMES: int = 20

var _touches: Dictionary = {}


func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return
	var target: String = _user_arg("--capture-to=")
	if target != "":
		_capture_and_quit(target, int(_user_arg("--capture-frames=", str(DEFAULT_CAPTURE_FRAMES))))


func _capture_and_quit(path: String, frames: int) -> void:
	for i: int in frames:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var image: Image = get_viewport().get_texture().get_image()
	if image.save_png(path) == OK:
		print("DevCapture: saved %s (%dx%d)" % [path, image.get_width(), image.get_height()])
	else:
		push_warning("DevCapture: could not save %s" % path)
	get_tree().quit()


static func _user_arg(prefix: String, fallback: String = "") -> String:
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with(prefix):
			return arg.trim_prefix(prefix)
	return fallback


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
