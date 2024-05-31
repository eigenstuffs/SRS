extends Interaction

@export var minigame : String

@export_node_path("Camera3D") var camera

func action():
	if minigame:
		print("Minigame pop-up")
		Global.can_move = false
		if camera: get_node(camera).current = false
		Util.create_minigame(get_tree().current_scene.find_child("SubViewportContainer"), minigame)
		await Util.util_finished
		emit_signal("end_interaction")
		if camera: get_node(camera).current = true
		Global.can_move = true
	else: print("Error: no minigame attached (add a scene)")
