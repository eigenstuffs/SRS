extends Area3D

class_name Interactor

var current_interaction : Interaction = null

signal started_interaction
signal finished_interaction

func _on_area_entered(area):
	if area is Interaction and current_interaction == null:
		current_interaction = area
		if current_interaction.get_parent() is NPC:
			current_interaction.get_parent().in_range()
		
func _on_area_exited(area):
	if area is Interaction and current_interaction == area:
		if current_interaction.get_parent() is NPC:
			current_interaction.get_parent().out_range()
		current_interaction = null

func _input(event):
	if event.is_action_pressed("ui_accept") and Global.can_move:
		if current_interaction:
			current_interaction.action()
			emit_signal("started_interaction")
			#await(current_interaction.end_interaction)
			#emit_signal("finished_interaction")
