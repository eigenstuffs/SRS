extends Node3D

const BOOK = preload('res://tools/minigames/library/book/book.tscn')
const BOMB = preload("res://tools/minigames/library/bomb/bomb.tscn")

@export var spawn_interval_seconds : float = 1
@export var floor_position_y : float = 0.55

var time : float = 0
var spawn_time_next : float = 0
var active = false

@onready var area : SpawnArea = $SpawnArea

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		if time >= spawn_time_next:
			spawn_time_next += spawn_interval_seconds
			var obj
			if randi_range(0,4) != 0:
				obj = BOOK.instantiate()
			else:
				obj = BOMB.instantiate()
			add_child(obj)
			obj.global_position = area.get_random_point()
			obj.floor_position_y = floor_position_y
			obj.fall_speed = max(1.0, spawn_time_next/7.0)
			obj.quaternion = Quaternion.from_euler(Vector3(0.035, 30, -0.035) * randf_range(-1, 1))
		
		time += delta
