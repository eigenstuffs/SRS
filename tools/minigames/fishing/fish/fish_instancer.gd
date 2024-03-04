extends Node3D

signal fish_hooked
signal first_fish_info(bite_strength, speed, rarity)

const FISH = preload('res://tools/minigames/fishing/fish/fish.tscn')
@export var MAX_FISH_COUNT = 5

var active = true
var fish_array : Array[Fish] = []

@onready var FISH_STATS : FishStats = preload("res://tools/minigames/fishing/fish/fish_stats.tres")
@onready var area_left : SpawnArea = $SpawnAreaLeft
@onready var area_right : SpawnArea = $SpawnAreaRight
#@onready var area_top : SpawnArea = $SpawnAreaTop
@onready var area_bottom : SpawnArea = $SpawnAreaBottom
@onready var fish_folder : Node3D = $fish
@onready var bobber : FloatingBobber = get_node("../FishingPlayer/FishingRod/FloatingBobber")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#h00 4 functions, override return

func _process(delta: float) -> void:
	if active and $fish.get_child_count() <= MAX_FISH_COUNT:
		var spawn_pos
		var type = randi_range(0,9)
		var side = randi_range(0,2)
		match side:
			0:
				spawn_pos = area_left.get_random_point()
			1:
				spawn_pos = area_right.get_random_point()
			2:
				spawn_pos = area_bottom.get_random_point()
			#3:
				#spawn_pos = area_top.get_random_point()
		var fishie: Fish = FISH.instantiate()
		$fish.add_child(fishie)
		fishie.connect("im_lured", on_fishie_im_lured.bind(fishie))
		fishie.connect("im_hooked", on_fishie_im_hooked)
		FISH_STATS.set_fish_stats(type,fishie)
		fishie.global_position = spawn_pos
		

func _on_fishing_reeling_minigame():
	if fish_array.is_empty():
		print("array is empty")
	var bobber_pos = bobber.global_position
	#find the fish with the shortest distance
	#stop the movement of first fish
	var min_dist : float = 99999999
	var closest_fish : Fish
	for fishie in fish_array:
		fishie.state = Fish.STATES.WANDER #release the fish back to wander
		if (bobber_pos - fishie.global_position).length() <= min_dist:
			closest_fish = fishie
	fish_array = []
	fish_array.append(closest_fish)
	closest_fish.state = Fish.STATES.STOP
	emit_signal("first_fish_info", closest_fish.bite_strength, closest_fish.speed, closest_fish.rarity)

func _on_fishing_reeling_minigame_end(is_successful):
	var to_be_freed = fish_array[0]
	if is_successful:
		
		to_be_freed.queue_free()
	else:
		to_be_freed.state = Fish.STATES.WANDER
	fish_array = []
	for fish in fish_folder.get_children():
		fish.state = Fish.STATES.WANDER

func on_fishie_im_lured(fishie):
	fish_array.append(fishie)

func on_fishie_im_hooked():
	if !fish_array.is_empty():
		emit_signal("fish_hooked")
#bugs to fix:
#closest fish find no match when bobber lands directly on top
