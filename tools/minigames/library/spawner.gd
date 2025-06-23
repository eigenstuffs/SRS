extends Node2D

class_name LibrarySpawner

const BOOK := preload("res://tools/minigames/library/items/book.tscn")
const BOMB := preload("res://tools/minigames/library/items/bomb.tscn")

@export var spawn_interval: float = 2.0

@onready var left_limit: Marker2D = $LeftLimit
@onready var right_limit: Marker2D = $RightLimit
@onready var timer: Timer = $Timer
@onready var item_folder: Node2D = $ItemFolder

var active: bool = false:
	set(value):
		active = value
		if active:
			start_countdown()
		else:
			stop_countdown()

func start_countdown():
	timer.start()

func stop_countdown():
	timer.stop()

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout():
	var random_x = randi_range(left_limit.position.x, right_limit.position.x)
	
	var item_to_spawn
	var random_ind = randi_range(0, 10)
	if random_ind < 7:
		item_to_spawn = BOOK
	else: item_to_spawn = BOMB

	var a = item_to_spawn.instantiate()
	item_folder.add_child(a)
	a.position.x = random_x
	
	start_countdown()
