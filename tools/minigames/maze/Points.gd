extends Area3D

class_name Points

func _on_body_entered(body):
	if body is Player:
		queue_free()
