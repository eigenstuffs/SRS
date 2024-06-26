class_name HitSlider extends Note

const MISS_ALPHA_TRANSITION_TIME : float = 0.1
const MISS_ALPHA_MIN : float = 0.4 ## Min alpha during miss transition
const FADE_OUT_DISTANCE : float = 3.0

var previous_length : float
var was_hit : bool = false

@onready var front_material : MultiPassShaderMaterial = $Meshes/Bottom.get_surface_override_material(0)
@onready var body_material : MultiPassShaderMaterial = $Meshes/Body.get_surface_override_material(0)
@onready var back_material : MultiPassShaderMaterial = $Meshes/Top.get_surface_override_material(0)

func _ready() -> void:
	super()
	_set_shader_parameter('fade_in_position', spawn_point.global_position)
	_set_shader_parameter('fade_out_position', hit_point.global_position)
	_set_shader_parameter('fade_plane_normal', hit_point.global_transform.basis.z)
	_set_shader_parameter('fade_in_distance', fade_in_distance * scale.z)
	_set_shader_parameter('fade_out_distance', FADE_OUT_DISTANCE * scale.z)
	_set_shader_parameter('color_overwrite', color_overwrite)
	#_set_shader_parameter('albedo', RandomColorGenerator.generate(hash((hit_time * 5.0) as int * 31415)))
	
	previous_length = spawn_point.global_position.distance_to(hit_point.global_position) / timings_supplier.call()[1] * duration
	set_length(previous_length)

func _process(delta: float) -> void:
	var timings : Array[float] = timings_supplier.call()
	var t = (timings[0] - hit_time + timings[1]) / timings[1]
	position = spawn_point.position.lerp(hit_point.position, t)
	
	# On miss, transition to lower alpha and increase fade out distance so that
	# the entire slider is visible on screen. This is done as an additional way
	# to denote that a missed slider cannot be re-hit.
	# NOTE: Setting instance uniforms are slow--don't do them often!
	if is_missed and alpha_overwrite > MISS_ALPHA_MIN:
		alpha_overwrite = max(MISS_ALPHA_MIN, alpha_overwrite - delta / MISS_ALPHA_TRANSITION_TIME)
		_set_shader_parameter('alpha_overwrite', alpha_overwrite)
		if was_hit:
			_set_shader_parameter('fade_out_distance', lerp(1e-7, FADE_OUT_DISTANCE, (1 - alpha_overwrite) / MISS_ALPHA_MIN) * scale.z)

	# Update length in the case that the control points move
	var length : float = spawn_point.global_position.distance_to(hit_point.global_position) / timings[1] * duration
	if previous_length != length:
		set_length(length)
		previous_length = length

func set_length(length : float) -> void:
	$Meshes/Body.scale.z *= length
	$Meshes/Body.position.z = -length * 0.5
	$Meshes/Top.position.z *= length
	
func hit() -> void:
	super.hit()
	if not is_missed:
		_set_shader_parameter('fade_out_distance', 1e-7)
	was_hit = true

func release() -> void:
	queue_free()

func _set_shader_parameter(param_name : StringName, value : Variant) -> void:
	$Meshes/Bottom.set_instance_shader_parameter(param_name, value)
	$Meshes/Body.set_instance_shader_parameter(param_name, value)
	$Meshes/Top.set_instance_shader_parameter(param_name, value)
	
func _on_color_overwrite_changed(value : Color):
	_set_shader_parameter('color_overwrite', value)

func _on_mesh_angle_changed(value : float):
	$Meshes/Bottom.rotation.y = value
	$Meshes/Top.rotation.y = value

func enable_shader_pass(pass_name : StringName, uniforms : Dictionary={}):
	front_material.enable_shader_pass(pass_name, uniforms)
	body_material.enable_shader_pass(pass_name, uniforms)
	back_material.enable_shader_pass(pass_name, uniforms)
	
func disable_shader_pass(pass_name : StringName):
	front_material.disable_shader_pass(pass_name)
	body_material.disable_shader_pass(pass_name)
	back_material.disable_shader_pass(pass_name)
