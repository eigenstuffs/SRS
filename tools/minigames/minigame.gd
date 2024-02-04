class_name Minigame extends SubViewport
## An abstract minigame. Should be extended in the main script for each minigame.

signal minigame_finished(points : int)
signal update_points(points : int)

@export var points : int = 0

func _end() -> void:
	minigame_finished.emit(points)
