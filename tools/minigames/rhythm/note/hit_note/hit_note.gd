class_name HitNote extends Note

@export var velocity : Vector3 = Vector3.FORWARD :
	set(value):
		velocity = value
		_on_set_velocity()

func _process(delta: float) -> void:
	global_position += velocity * delta

func hit(z : float) -> float:
	queue_free()
	return z - global_position.z

func _on_visibility_notifier_screen_exited():
	queue_free()

func _on_set_velocity() -> void: pass

func _on_set_key_position(value : Vector3) -> void:
	$Mesh.set_instance_shader_parameter('target_position', value)
