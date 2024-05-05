extends Control

@onready var metadata : MazeMeta = preload("res://tools/minigames/maze/maze_metadata.tres")

func launch_minigame():
	Util.create_minigame($CanvasLayer, "Maze")
	$HBoxContainer.visible = false

func _on_easy_pressed():
	metadata.set_difficulty("Easy")
	launch_minigame()

func _on_medium_pressed():
	metadata.set_difficulty("Medium")
	launch_minigame()

func _on_hard_pressed():
	metadata.set_difficulty("Hard")
	launch_minigame()
