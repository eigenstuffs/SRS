extends Interaction

@export var minigame : PackedScene

func action():
	if minigame:
		print("Minigame pop-up")
		Global.can_move = false
		var a = minigame.instantiate()
		if get_tree().current_scene.has_node("CanvasLayer/MinigameHolder"):
			var b = get_tree().current_scene.get_node("CanvasLayer/MinigameHolder")
			b.add_child(a)
			await a.minigame_finished
			a.queue_free()
			emit_signal("end_interaction")
		Global.can_move = true
	else: print("Error: no minigame attached (add a scene)")
