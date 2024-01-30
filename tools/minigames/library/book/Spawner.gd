extends Node3D

var next_time = 0
var time = 0

const BOOK = preload('res://tools/minigames/library/book/book.tscn')

func _process(delta: float) -> void:
	if time >= next_time:
		next_time += 1
		var book : Book = BOOK.instantiate()
		book.global_position = Vector3(randf_range(-5, 5), global_position.y, randf_range(-5, 5))
		add_child(book)
	time += delta
