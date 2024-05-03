extends Area3D

class_name Keys

signal collected

@export var spin_speed : float = 50

func _on_body_entered(body):
	if body is Player:
		emit_signal("collected")
		queue_free()

func _physics_process(delta):
	set_rotation_degrees(rotation_degrees + Vector3(0, spin_speed * delta, 0))
