extends Resource

class_name MazeMeta

@export var mazeWidth : int
@export var mazeLength : int
@export var keyN : int
@export var min_radius : int
@export var diffMult : int


func set_custom(width : int, length : int, N : int, radius : int):
	mazeWidth = width
	mazeLength = length
	keyN = N
	min_radius = radius
	diffMult = max(mazeLength, mazeWidth)/5
	
func get_metadata() -> Array[int]:
	return [mazeWidth, mazeLength, keyN, min_radius]

func set_difficulty(diff : String):
	match diff:
		"Easy":
			mazeWidth = 5
			mazeLength = 5
			keyN = 2
			min_radius = 2
			diffMult = 1
		"Medium":
			mazeWidth = 10
			mazeLength = 10
			keyN = 3
			min_radius = 3
			diffMult = 2
		"Hard":
			mazeWidth = 13
			mazeLength = 13
			keyN = 5
			min_radius = 4
			diffMult = 3
