extends WorldEnvironment

func _process(delta: float) -> void:
	environment.sky_rotation.x += deg_to_rad(2.5 * delta)
