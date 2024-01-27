extends Control

@onready var PLAYER_STATS : PlayerStats = preload("res://resources/stats/player_stats.tres")

@onready var stats_container = $StatsContainer
@onready var wisdom_bar = $StatsContainer/Wisdom
@onready var wisdom_label = $StatsContainer/Wisdom/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	wisdom_bar.value = 0
	var a = create_tween()
	a.tween_property(wisdom_bar, "value", PLAYER_STATS.wisdom, 0.2)
	await a.finished
	wisdom_label.text = str(PLAYER_STATS.wisdom)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
