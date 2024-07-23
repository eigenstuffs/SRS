#extends Node
### Script to enforce that window dimensions match the aspect ratio determined by
### the initial window resolution in the project settings.
###
### Fairly robust, but assumes a window stretch mode is set. Should be used as a
### global script.
#
#signal main_window_size_changed
#
#const INITIAL_SCALE_FACTOR : float = 0.7
### Whether or not the initial window size should scale with screen (monitor) resolution.
#const SHOULD_INIT_WITH_SCREEN_RESOLUTION : bool = true
#
### Wait time after the screen dimensions has changed before updating the dimensions
### accordingly.
#@export var update_interval_seconds : float = 0.4
#
#var last_window_size : Vector2i
#var last_window_position : Vector2i
#var timer : Timer = Timer.new()
#
#var aspect_ratio : float = float(_get_window_size_setting('viewport_width')) / _get_window_size_setting('viewport_height')
#
#func _ready() -> void:
	#var screen := DisplayServer.window_get_current_screen()
	#var screen_size := DisplayServer.screen_get_size(screen)
	#var size := DisplayServer.window_get_size()
#
	#resize_window(screen_size * DisplayServer.screen_get_scale(screen) * INITIAL_SCALE_FACTOR)
	## Keep resized window centered if set in project settings
	#if _get_window_size_setting('initial_position_type') == 1:
		#var centered_position = (screen_size - DisplayServer.window_get_size()) * 0.5
		#DisplayServer.window_set_position(centered_position)
#
	#last_window_size = size
	#main_window_size_changed.connect(_on_main_window_size_changed)
#
	#add_child(timer)
	#timer.timeout.connect(_on_timeout)
#
#func _physics_process(_delta : float) -> void:
	#if last_window_size != DisplayServer.window_get_size() or last_window_position != DisplayServer.window_get_position():
		#last_window_size = DisplayServer.window_get_size();
		#last_window_position = DisplayServer.window_get_position()
		#main_window_size_changed.emit()
#
#func _on_timeout() -> void:
	#if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		#resize_window(get_viewport().size)
	#timer.stop()
#
#func _on_main_window_size_changed() -> void:
	#timer.start(update_interval_seconds)
#
#func resize_window(size : Vector2i) -> void:
	#var new_size : Vector2i = get_aspect_ratio_corrected_resolution(size)
	#DisplayServer.window_set_size(new_size)
	#DisplayServer.window_set_position(DisplayServer.window_get_position() + (new_size - size).abs() / 2)
#
#func get_aspect_ratio_corrected_resolution(size : Vector2i) -> Vector2i:
	## Clamp size to the resolution of the screen
	#size = size.clamp(Vector2i(0, 0), DisplayServer.screen_get_size(DisplayServer.window_get_current_screen()))
	#if aspect_ratio >= size.aspect():
		#return Vector2i(size.x, round(size.x / aspect_ratio))
	#else:
		#return Vector2i(round(size.y * aspect_ratio), size.y)
#
#func _get_window_size_setting(field : String) -> Variant:
	#return ProjectSettings.get_setting_with_override('display/window/size/%s' % field)
