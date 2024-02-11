class_name Minigame extends SubViewport

## An abstract minigame. Should be extended in the main script for each minigame.

signal minigame_finished(points : int)
signal update_points(points : int)

@export var points : int = 0

func end() -> void:
	minigame_finished.emit(points)
	
# FIXME: I don't understand viewports and this is the only way I could get mouse
# inputs to pass through to the child subviewport!
func unhandled_input(event : InputEvent) -> void:
	pass
