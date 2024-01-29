class_name HitSliderTick extends Note

func _on_visibility_notifier_screen_exited() -> void:
	queue_free()

func _on_key_position_set(value : Vector3) -> void:
	$Mesh.set_instance_shader_parameter('start_pos', value)
