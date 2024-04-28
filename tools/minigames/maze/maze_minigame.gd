class_name MazeMinigame extends Minigame
#extends Node3D

var point_get : int = 0
var all_keys_got : bool = false

func _on_maze_generator_key_collected():
	point_get += 1
	update_points.emit(point_get)

func _on_maze_generator_all_key_collected():
	all_keys_got = true

func _on_goal_goal_touched():
	if all_keys_got:
		print("player unlocked the exit!")
