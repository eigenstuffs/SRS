extends Control

class_name Overlay

@onready var PLAYER_STATS : PlayerStats = preload("res://resources/stats/player_stats.tres")

@onready var stats_container = $StatsContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	stats_bar_update()
	PLAYER_STATS.changed.connect(on_stats_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func stats_bar_update():
	for bar_index in stats_container.get_child_count():
		var current_bar : ProgressBar = stats_container.get_child(bar_index)
		var a = create_tween()
		a.tween_property(current_bar, "value", PLAYER_STATS.get_stat(bar_index), 0.2)
		current_bar.get_child(0).text = str(PLAYER_STATS.get_stat(bar_index))
	
func on_stats_changed():
	stats_bar_update()
