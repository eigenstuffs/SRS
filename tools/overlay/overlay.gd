extends Control

class_name Overlay

@onready var PLAYER_STATS : PlayerStats = preload("res://resources/stats/player_stats.tres")
@onready var SETTINGS = preload("res://tools/settings/settings.tscn")
@onready var stats_container = $StatsContainer
@onready var setting_button = $SettingButton


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

func _on_setting_button_pressed():
	#check if we are in a minigame or other scenes that you shouldn't call settings
	if Global.can_move == false: 
		return
	setting_button.disabled = true
	Global.can_move = false
	var a = get_tree().root
	if a.has_node("/root/Settings"):
		pass
	else:
		var b = SETTINGS.instantiate()
		a.add_child(b)
		b.connect("setting_closed", setting_closed_func)
	print("button pressed")

func setting_closed_func():
	Global.can_move = true
	setting_button.disabled = false


func _on_reward_test_pressed():
	#Util.create_reward_scene("Fishing", [2, 3, 6, 1], [0, 0, 2, 3])
	assert('fixme!')
	pass
