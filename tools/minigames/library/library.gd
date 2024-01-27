extends Node3D

class_name LibraryMinigame

signal minigame_finished(num_points : int)

@export var points : int = 0

func _ready():
	pass

func end():
	emit_signal("minigame_finished", points)
