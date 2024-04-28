extends Area3D

signal goal_touched

func _on_body_entered(body):
	if body is Player:
		emit_signal("goal_touched")
