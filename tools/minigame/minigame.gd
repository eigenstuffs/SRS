class_name Minigame extends SubViewport

## An abstract minigame. Should be extended in the main script for each minigame.

signal minigame_finished(detailed_points : int)
signal update_points(points : int)
signal update_time(seconds : int) #call this to add or deduct time from the minigame
signal ended
signal get_remaining_time

var rough_points : int = 0
@export var detailed_points : Array = []
var remaining_time : int #for specific minigames that can end early

var has_ended := false

func end() -> void:
	has_ended = true
	minigame_finished.emit(detailed_points)
	
# FIXME: I don't understand viewports and this is the only way I could get mouse
# inputs to pass through to the child subviewport!
func unhandled_input(_event : InputEvent) -> void:
	pass

func start_game():
	pass
