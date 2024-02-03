extends Node3D

const NPC = preload('res://scenes/actors/wandering_npc.tscn')

@export var spawn_interval_seconds : float = 1.0

var time : float = 0
var spawn_time_next : float = 0
var active = false

@onready var area_left : SpawnArea = $SpawnAreaLeft
@onready var area_right : SpawnArea = $SpawnAreaRight

# Called every frame. 'delta' is the elapsed time since the previous frame.
#h00 4 functions, override return
func _process(delta: float) -> void:
	if active:
		if time >= spawn_time_next:
			spawn_time_next += spawn_interval_seconds
			
			var is_left_start : bool = randf() < 0.5
			var spawn_pos = area_left.get_random_point() if is_left_start else area_right.get_random_point()
			var end_pos = area_right.get_random_point() if is_left_start else area_left.get_random_point()
			
			var npc : WanderingNPC = NPC.instantiate()
			add_child(npc)
			npc.global_position = spawn_pos
			npc.orientation = (end_pos - spawn_pos).normalized() * WanderingNPC.SPEED
			
		
		time += delta
