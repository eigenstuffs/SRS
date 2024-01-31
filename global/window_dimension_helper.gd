extends Node
## Script to enforce that window dimensions match the aspect ratio determined by
## the initial window resolution in the project settings.
##
## Fairly robust, but assumes a window stretch mode is set. Should be used as a
## global script.

signal main_window_size_changed

const INITIAL_SCALE_FACTOR = 0.7

## Wait time after the screen dimensions has changed before updating the dimensions
## accordingly.
@export var update_interval_seconds : float = 0.05

var last_window_size : Vector2i
var last_window_position : Vector2i
var timer : Timer = Timer.new()

@onready var aspect_ratio : float = get_viewport().size.aspect() # x / y

func _ready() -> void:
	var viewport = get_tree().root
	var screen = DisplayServer.window_get_current_screen()

	# --- Retina Screen Resolution Correction ---
	# Source: https://forum.godotengine.org/t/is-there-some-mismatch-between-godot-window-size-pixels-and-os-x-window-size/40140/4
	var retina_scale = DisplayServer.screen_get_scale(screen)
	var relative_scale = 1.0
	if viewport.content_scale_factor != retina_scale:
		# We need to change, calculate the relative change in scale
		relative_scale = retina_scale / viewport.content_scale_factor
	# Apply the change, as well as resizing window based on previous scale and relative scale
	#viewport.content_scale_factor = retina_scale
	resize_window(viewport.size * relative_scale * INITIAL_SCALE_FACTOR)

	# Keep resized window centered if set in project settings
	if ProjectSettings.get_setting_with_override('display/window/size/initial_position_type') == 1:
		var centered_position = (DisplayServer.screen_get_size(screen) - viewport.size) * 0.5
		DisplayServer.window_set_position(centered_position, screen)

	last_window_size = viewport.size
	main_window_size_changed.connect(_on_main_window_size_changed)

	add_child(timer)
	timer.timeout.connect(_on_timeout)

func _process(_delta : float) -> void:
	if last_window_size != DisplayServer.window_get_size() or last_window_position != DisplayServer.window_get_position():
		last_window_size = DisplayServer.window_get_size();
		last_window_position = DisplayServer.window_get_position()
		main_window_size_changed.emit()

func _on_timeout() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		resize_window(get_viewport().size)

func _on_main_window_size_changed() -> void:
	timer.start(update_interval_seconds)

func resize_window(size : Vector2i) -> void:
	DisplayServer.window_set_size(get_aspect_ratio_corrected_resolution(size))

func get_aspect_ratio_corrected_resolution(size : Vector2i) -> Vector2i:
	# Clamp size to the resolution of the screen
	size = size.clamp(Vector2i(0, 0), DisplayServer.screen_get_size(DisplayServer.window_get_current_screen()))
	if size.x > size.y:
		return Vector2i(size.x, round(size.x / aspect_ratio))
	else:
		return Vector2i(round(size.y * aspect_ratio), size.y)
