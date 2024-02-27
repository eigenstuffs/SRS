extends Control

class_name RewardScene

@onready var PLAYER_STATS : PlayerStats = preload("res://resources/stats/player_stats.tres")
@onready var stats_container = $StatsContainer

func _ready():
	stats_bar_update()
	PLAYER_STATS.changed.connect(on_stats_changed)
	
func stats_bar_update(slow : bool = false):
	for bar_index in stats_container.get_child_count():
		var current_bar : ProgressBar = stats_container.get_child(bar_index)
		current_bar.get_child(0).text = str(PLAYER_STATS.get_stat(bar_index))
		var a = create_tween()
		a.tween_property(current_bar, "value", PLAYER_STATS.get_stat(bar_index), 0.2)
		if slow:
			await a.finished
			await get_tree().create_timer(0.5).timeout

func on_stats_changed():
	stats_bar_update(true)

func _on_confirm_button_pressed():
	var change_by : Array[int] = [5, 1, -2, 4]
	stats_change_preview(change_by)
	await get_tree().create_timer(1.5).timeout
	modify_stats(change_by) #arbitrary numbers just for testing

func modify_stats(points_to_be_modified : Array[int]):
	var result_stats = PLAYER_STATS.get_main_stats()
	for i in range(0, points_to_be_modified.size()):
		result_stats[i] = result_stats[i] + points_to_be_modified[i]
	PLAYER_STATS.set_stats(result_stats)

func stats_change_preview(change_by : Array[int]):
	for bar_index in stats_container.get_child_count():
		var current_bar : ProgressBar = stats_container.get_child(bar_index)
		current_bar.get_child(0).text = str(PLAYER_STATS.get_stat(bar_index)) + " + " + str(change_by[bar_index])
