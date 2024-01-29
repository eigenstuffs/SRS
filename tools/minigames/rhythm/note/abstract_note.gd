class_name AbstractNote extends Node3D
# TODO: yeah im not proud of this class hierarchy either...

@export var duration_seconds : float = 1

## Returns some score
func hit(_z : float) -> float: return 0.0

func hold(_z : float) -> void: pass

## Returns some score
func release(_z : float) -> float: return 0.0
