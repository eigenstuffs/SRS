extends CanvasLayer

class_name Reward

signal preview_done
signal display_finished

@onready var stats_container = $StatsContainer
@onready var score_tally = $ScoreTally
@onready var final_score = $FinalScore

var scores : Array
var stats_gained : Array
var done : bool = false

var final_bar_ind : Array = [0, 1, 2, 3] #corresponds to wis, int, cha, well

#set function that should be called after reward scene is instantiated
#pass the scores gained from the minigame and corresponding stats gained here
func set_vars(score : Array, stats : Array):
	scores = score
	stats_gained = stats

func _ready(): 
	set_final_target()
	stats_bar_update()
	hide_tally()
	hide_final()
	
func set_final_target():
	final_bar_ind = [0, 1, 2, 3]

func hide_tally():
	for line in score_tally.get_children():
		line.visible = false

func display_tally(scores : Array):
	for line_ind in score_tally.get_child_count():
		score_tally.get_child(line_ind).get_child(1).text = str(scores[line_ind])
		score_tally.get_child(line_ind).visible = true
		await get_tree().create_timer(0.65).timeout
	emit_signal("preview_done")
	
func hide_final():
	for line in final_score.get_children():
		line.visible = false

func display_final(stats_gained : Array):
	for line_ind in final_score.get_child_count():
		final_score.get_child(line_ind).get_child(1).text = "+" + str(stats_gained[final_bar_ind[line_ind]])
		final_score.get_child(line_ind).visible = true
		await get_tree().create_timer(0.65).timeout
	emit_signal("preview_done")

func stats_bar_update():
	for bar_index in stats_container.get_child_count():
		var current_bar : ProgressBar = stats_container.get_child(bar_index)
		current_bar.get_child(0).text = str(Global.get_stat(bar_index))
		var a = create_tween()
		a.tween_property(current_bar, "value", Global.get_stat(bar_index), 0.1)

func modify_stats(points_to_be_modified : Array):
	var result_stats = Global.get_main_stats()
	for i in range(0, points_to_be_modified.size()):
		result_stats[i] = result_stats[i] + points_to_be_modified[i]
	Global.set_stats(result_stats)
	done = true
	stats_bar_update()

func stats_change_preview(change_by : Array):
	for bar_index in stats_container.get_child_count():
		var current_bar : ProgressBar = stats_container.get_child(bar_index)
		current_bar.get_child(0).text = str(Global.get_stat(bar_index)) + " + " + str(change_by[bar_index])
		await get_tree().create_timer(0.35).timeout
	emit_signal("preview_done")

func start_display():
	display_tally(scores)
	await preview_done
	display_final(stats_gained)
	await preview_done
	stats_change_preview(stats_gained)
	await preview_done
	modify_stats(stats_gained)

func _on_confirm_button_pressed():
	if done:
		emit_signal("display_finished")
