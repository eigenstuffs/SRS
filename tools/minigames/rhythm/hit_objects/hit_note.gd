class_name HitNote extends Note

const MISS_ALPHA_TRANSITION_TIME : float = 0.1
const MISS_ALPHA_MIN : float = 0.4 ## Min alpha during miss transition

@onready var death_timer : Timer = $DeathTimer
@onready var note_material : MultiPassShaderMaterial = $Mesh.get_surface_override_material(0)

func _ready() -> void:
	super()
	$Mesh.set_instance_shader_parameter('fade_in_position', spawn_point.global_position)
	$Mesh.set_instance_shader_parameter('fade_plane_normal', hit_point.global_transform.basis.z)
	$Mesh.set_instance_shader_parameter('fade_in_distance', fade_in_distance * scale.z)
	$Mesh.set_instance_shader_parameter('color_overwrite', color_overwrite)

func _process(delta: float) -> void:
	var timings : Array[float] = timings_supplier.call()
	if not is_missed:
		var t = (timings[0] - hit_time + timings[1]) / timings[1]
		position = spawn_point.position.lerp(hit_point.position, t)
	else:
		position += (position - hit_point.position).normalized() * 0.01
		$Mesh.set_instance_shader_parameter('fade_out_factor', 1.0 - death_timer.time_left / death_timer.wait_time)
		
	# NOTE: Setting instance uniforms are slow--don't do them often!
	if is_missed and alpha_overwrite > MISS_ALPHA_MIN:
		alpha_overwrite = max(MISS_ALPHA_MIN, alpha_overwrite - delta / MISS_ALPHA_TRANSITION_TIME)
		$Mesh.set_instance_shader_parameter('alpha_overwrite', alpha_overwrite)

func hit() -> void:
	queue_free()

func miss() -> void:
	super.miss()
	death_timer.start()
	$Mesh.set_instance_shader_parameter('fade_out_factor', 1.0 - death_timer.time_left / death_timer.wait_time)

func _on_death_timer_timeout() -> void:
	queue_free()

func _on_color_overwrite_changed(value : Color):
	$Mesh.set_instance_shader_parameter('color_overwrite', value)

func enable_shader_pass(pass_name : StringName, uniforms : Dictionary={}):
	note_material.enable_shader_pass(pass_name, uniforms)
	
func disable_shader_pass(pass_name : StringName):
	note_material.disable_shader_pass(pass_name)
