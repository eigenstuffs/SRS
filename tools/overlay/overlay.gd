extends Control

@onready var PLAYER_STATS : PlayerStats = preload("res://resources/stats/player_stats.tres")
@onready var STATS_LIST : Array = [PLAYER_STATS.wisdom, PLAYER_STATS.intelligence, PLAYER_STATS.charisma, PLAYER_STATS.wellness]

@onready var stats_container = $StatsContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	stats_bar_update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func stats_bar_update():
	fetch_stats()
	for bar_index in stats_container.get_child_count():
		var current_bar : ProgressBar = stats_container.get_child(bar_index)
		var a = create_tween()
		a.tween_property(current_bar, "value", STATS_LIST[bar_index], 0.2)
		current_bar.get_child(0).text = str(STATS_LIST[bar_index])


func _on_radomize_stats_stats_changed():
	stats_bar_update()
	#print(STATS_LIST)

func fetch_stats():
	PLAYER_STATS = load("res://resources/stats/player_stats.tres")
	STATS_LIST = [PLAYER_STATS.wisdom, PLAYER_STATS.intelligence, PLAYER_STATS.charisma, PLAYER_STATS.wellness]
