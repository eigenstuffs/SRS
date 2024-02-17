class_name HitSlider extends Note

const FADE_OUT_DISTANCE : float = 3.0
const MISS_ALPHA_TRANSITION_TIME : float = 0.1
const MISS_ALPHA_MIN : float = 0.4 ## Min alpha during miss transition

var previous_length : float
var was_hit : bool = false
var alpha_overwrite : float = 1.0

func _ready() -> void:
	super()
	_set_shader_parameter('fade_in_position', spawn_point.global_position)
	_set_shader_parameter('fade_out_position', hit_point.global_position)
	_set_shader_parameter('fade_plane_normal', hit_point.global_transform.basis.z)
	_set_shader_parameter('fade_in_distance', fade_in_distance * scale.z)
	_set_shader_parameter('fade_out_distance', FADE_OUT_DISTANCE * scale.z)
	_set_shader_parameter('albedo', RandomColorGenerator.generate(hash((hit_time * 5.0) as int * 31415)))
	
	previous_length = spawn_point.global_position.distance_to(hit_point.global_position) / timings_supplier.call()[1] * duration
	set_length(previous_length)

func _process(delta: float) -> void:
	var timings : Array[float] = timings_supplier.call()
	var t = (timings[0] - hit_time + timings[1]) / timings[1]
	position = spawn_point.position.lerp(hit_point.position, t)
	
	# On miss, transition to lower alpha and increase fade out distance so that
	# the entire slider is visible on screen. This is done as an additional way
	# to denote that a missed slider cannot be re-hit.
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
	$Meshes/BackEnd.position.z *= length
	
func hit() -> void:
	super.hit()
	if not is_missed:
		_set_shader_parameter('fade_out_distance', 1e-7)
	was_hit = true

func release() -> void:
	queue_free()

func _set_shader_parameter(param_name : String, value : Variant) -> void:
	$Meshes/FrontEnd.set_instance_shader_parameter(param_name, value)
	$Meshes/Body.set_instance_shader_parameter(param_name, value)
	$Meshes/BackEnd.set_instance_shader_parameter(param_name, value)
