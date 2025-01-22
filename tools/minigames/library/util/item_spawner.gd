extends Node2D

class_name ItemSpawner

const BOOK = preload("res://tools/minigames/library/items/book/book_2d.tscn")
const BOMB = preload("res://tools/minigames/library/items/bomb/bomb_2d.tscn")

@export var spawn_interval_seconds : float = 1
@export var floor_position_y : float = 0.55

var time : float = 0
var spawn_time_next : float = 0
var active = false

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
			obj.position = Vector2(randf_range($LeftBound.position.x, $RightBound.position.x), position.y)
			obj.floor_position_y = floor_position_y
			obj.fall_speed = min(max(1.0, spawn_time_next/7.0), 3.0)
		
		time += delta
