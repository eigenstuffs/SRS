class_name Note extends AbstractNote

var time : float = 0

func hit(z : float) -> float:
	queue_free()
	return z - global_position.z

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Mesh: $Mesh.set_instance_shader_parameter('alpha', min(1.0, time * 1.5))
	time += delta
