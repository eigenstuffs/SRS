extends Area3D

class_name Keys

signal collected

func _on_body_entered(body):
	if body is Player:
		emit_signal("collected")
		queue_free()
