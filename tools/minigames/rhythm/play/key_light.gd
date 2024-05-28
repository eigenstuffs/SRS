extends OmniLight3D

@export var decay_speed := 8.0 # Light energy decay per second

func _physics_process(delta: float) -> void:
	light_energy = max(0, light_energy - delta*8.0)
