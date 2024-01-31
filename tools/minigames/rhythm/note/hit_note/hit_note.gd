class_name HitNote extends Note

@export var velocity : Vector3

func _ready() -> void:
	assert(velocity, 'velocity member must be set before _ready()!')
	mesh = $Mesh

func _process(delta: float) -> void:
	global_position += velocity * delta

func hit(z : float) -> float:
	queue_free()
	return z - global_position.z

func _on_visibility_notifier_screen_exited():
	queue_free()
