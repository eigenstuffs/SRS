extends Area3D

signal goal_touched

@export var mg : MazeGenerator

func _ready():
	visible = false
	monitoring = false
	global_position = Vector3(mg.mazeWidth-1, 0.5, mg.mazeLength-1)

func show_and_monitor():
	global_position = Vector3(mg.mazeWidth-1, 0.5, mg.mazeLength-1)
	visible = true
	monitoring = true
	$AudioStreamPlayer.play()

func _on_body_entered(body):
	if body is Player:
		emit_signal("goal_touched")

#pop up particle effect (to attract player attention)
