class_name Note extends Node3D

enum HitType {HIT, RELEASE, MISS}

@export var fade_in_distance : float = 1.5
@export var spawn_point : Node3D
@export var hit_point : Node3D
@export var hit_time : float = -1
@export var duration : float = -1
@export var color_overwrite : Color = Color.TRANSPARENT : 
	set(value):
		color_overwrite = value
		_on_color_overwrite_changed(value)
@export var mesh_angle := 0.0 : 
	set(value):
		mesh_angle = value
		_on_mesh_angle_changed(value)

var timings_supplier : Callable ## Shape: () -> [time : float, scroll_time : float]
var alpha_overwrite : float = 1.0
var is_held : bool = false
var is_missed : bool = false

func _ready() -> void:
	assert(timings_supplier, 'A timings supplier `Callable` must be assigned before _ready()!')
	assert(spawn_point and hit_point, 'Note endpoints must be assigned before _ready()!')

func hit() -> void: is_held = true

func release() -> void: is_held = false
	
func miss() -> void: is_missed = true

func _on_color_overwrite_changed(_value : Color):
	pass
	
func _on_mesh_angle_changed(value : float):
	pass

func enable_shader_pass(_pass_name : StringName, _uniforms : Dictionary={}):
	pass
	
func disable_shader_pass(_pass_name : StringName):
	pass
