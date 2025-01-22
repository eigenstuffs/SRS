extends Node2D

class_name Minigame2D

enum TYPE{COUNTDOWN, COUNTUP, OTHERS}

@export_enum("Countdown", "Countup", "Others") var type: int
@export var time: int = 60 #time of the minigame; depending on the type
@export var player_health: int = 3
@export_file("*.tscn") var reward_scene = ""

func _ready():
	#some initialization
	pass

func _end():
	pass

func _calculate_score():
	pass

func return_to_previous_scene():
	Global.minigames_played_this_zone += 1
	get_tree().change_scene_to_file(Global.last_free_zone)

func create_reward_scene(scores : Array, stats_gained : Array, canvas_layer):
	var a : Reward = load(reward_scene).instantiate()
	a.set_vars(scores, stats_gained)
	canvas_layer.add_child(a)
	await get_tree().create_timer(1).timeout
	a.start_display()
	await a.display_finished
	a.queue_free()
