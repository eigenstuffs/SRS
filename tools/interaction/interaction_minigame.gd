extends Interaction

@export var minigame : String
@export_file("*.tscn") var minigame_scene
@export_file("*.tscn") var current_zone

#func action():
	#if minigame:
		#print("Minigame pop-up")
		#Global.can_move = false
		#get_tree().current_scene.find_child("DirectionalLight3D").visible = false #turn off light
		#Util.create_minigame(get_tree().current_scene.find_child("SubViewportContainer"), minigame)
		#await Util.util_finished
		#get_tree().current_scene.find_child("DirectionalLight3D").visible = true
		#emit_signal("end_interaction")
		#await get_tree().create_timer(0.5).timeout
		#Global.can_move = true
	#else: print("Error: no minigame attached (add a scene)")

func action():
	if minigame_scene:
		print("Minigame pop-up")
		Global.can_move = false
		get_tree().current_scene.find_child("DirectionalLight3D").visible = false #turn off light
		Global.last_free_zone = current_zone
		get_tree().change_scene_to_file(minigame_scene)
		Global.can_move = true
		
	else: print("Error: no minigame attached (add a scene)")
