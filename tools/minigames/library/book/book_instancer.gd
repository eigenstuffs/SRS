extends Node3D

const BOOK = preload('res://tools/minigames/library/book/book.tscn')
const BOMB = preload("res://tools/minigames/library/bomb/bomb.tscn")

@export var spawn_interval_seconds : float = 0.001
@export var floor_position_y : float = 0.55

var time := 0.0
var books_spawned := 0
var spawn_time_next : float = 0
var active = false

@onready var area : SpawnArea = $SpawnArea

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active and books_spawned < 2750:
		if time >= spawn_time_next:
			spawn_time_next += spawn_interval_seconds
			for i in range(8):
				var obj
				obj = BOOK.instantiate()
				add_child(obj)
				obj.global_position = area.get_random_point()
				obj.floor_position_y = floor_position_y
				obj.fall_speed = min(max(1.0, spawn_time_next/7.0), 3.0)
				obj.quaternion = Quaternion.from_euler(Vector3(randf_range(-1.0, -0.2), 0, randf_range(-0.2, 0.2) * maxf(0.0, 2.0 - time)))
			books_spawned += 8
		time += delta
