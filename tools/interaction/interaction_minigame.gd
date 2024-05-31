extends Interaction

@export var minigame : String

func action():
	if minigame:
		print("Minigame pop-up")
		Global.can_move = false
		Util.create_minigame(get_tree().current_scene.find_child("SubViewportContainer"), minigame)
		await Util.util_finished
		emit_signal("end_interaction")
		Global.can_move = true
	else: print("Error: no minigame attached (add a scene)")
