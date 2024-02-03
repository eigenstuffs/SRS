extends Node3D

const BOOK = preload('res://tools/minigames/library/book/book.tscn')

@export var spawn_interval_seconds : float = 1.0
@export var floor_position_y : float = 0.55

var time : float = 0
var spawn_time_next : float = 0

@onready var area : SpawnArea = $SpawnArea

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time >= spawn_time_next:
		spawn_time_next += spawn_interval_seconds
		var book : Book = BOOK.instantiate()
		add_child(book)
		book.global_position = area.get_random_point()
		book.floor_position_y = floor_position_y
	
	time += delta
