extends Node3D

const FISH = preload('res://tools/minigames/fishing/fish/fish.tscn')

var active = true

@onready var area_left : SpawnArea = $SpawnAreaLeft
@onready var area_right : SpawnArea = $SpawnAreaRight
@onready var area_top : SpawnArea = $SpawnAreaTop
@onready var area_bottom : SpawnArea = $SpawnAreaBottom

# Called every frame. 'delta' is the elapsed time since the previous frame.
#h00 4 functions, override return

func _process(delta: float) -> void:
	if active and $fish.get_child_count() <= 3:
		var spawn_pos
		var side = randi_range(0,3)
		match side:
			0:
				spawn_pos = area_left.get_random_point()
			1:
				spawn_pos = area_right.get_random_point()
			2:
				spawn_pos = area_bottom.get_random_point()
			3:
				spawn_pos = area_top.get_random_point()
		var fishie: Fish = FISH.instantiate()
		$fish.add_child(fishie)
		fishie.global_position = spawn_pos
