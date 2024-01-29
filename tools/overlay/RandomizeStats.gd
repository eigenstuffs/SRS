extends Button

@onready var PLAYER_STATS : PlayerStats = preload("res://resources/stats/player_stats.tres")

signal stats_changed

func _on_pressed():
	var random_stats : Array[int] = []
	for i: int in PLAYER_STATS.get_main_stats().size():
		random_stats.append(randi_range(0, 100))
	PLAYER_STATS.set_stats(random_stats)
	#print(PLAYER_STATS.get_main_stats())
