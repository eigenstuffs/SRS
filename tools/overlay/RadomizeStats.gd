extends Button

@onready var PLAYER_STATS : PlayerStats = preload("res://resources/stats/player_stats.tres")
@onready var stats_list : Array = [PLAYER_STATS.wisdom, PLAYER_STATS.intelligence, PLAYER_STATS.charisma, PLAYER_STATS.wellness]

signal stats_changed

func _on_pressed():
	for stats_index in stats_list.size():
		stats_list[stats_index] = randi_range(0, 100)
		PLAYER_STATS
	emit_signal("stats_changed")
	print(stats_list)
