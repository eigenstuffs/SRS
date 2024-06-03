extends Interaction

@export var minigame : String

func action():
	if minigame:
		print("Minigame pop-up")
		Global.can_move = false
		get_tree().current_scene.find_child("DirectionalLight3D").visible = false #turn off light
		Util.create_minigame(get_tree().current_scene.find_child("SubViewportContainer"), minigame)
		await Util.util_finished
		get_tree().current_scene.find_child("DirectionalLight3D").visible = true
		emit_signal("end_interaction")
		await get_tree().create_timer(0.5).timeout
		Global.can_move = true
	else: print("Error: no minigame attached (add a scene)")
