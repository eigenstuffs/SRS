extends Area3D

signal goal_touched

func _ready():
	visible = false
	monitoring = false

func show_and_monitor():
	visible = true
	monitoring = true

func _on_body_entered(body):
	if body is Player:
		emit_signal("goal_touched")

#pop up particle effect (to attract player attention)
