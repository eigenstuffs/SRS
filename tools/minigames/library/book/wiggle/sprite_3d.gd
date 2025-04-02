extends Sprite3D

const BOOK1 = preload("res://assets/library/book1-1.png")
const BOOK2 = preload("res://assets/library/book2-1.png")
const BOOK3 = preload("res://assets/library/book3-1.png")

func _ready():
	var rand_int = randi_range(0, 3)
	match rand_int:
		0: texture = BOOK1
		1: texture = BOOK2
		2: texture = BOOK3
		_: texture = BOOK1
