extends Interaction

@export_file("*.json") var file

const DIALOGUE = preload("res://tools/dialogue/dialogue.tscn")

func action():
	if file:
		print("Dialogue pop-up")
		Global.can_move = false
		var a = DIALOGUE.instantiate()
		if get_tree().current_scene.has_node("CanvasLayer/DialogueHolder"):
			var b = get_tree().current_scene.get_node("CanvasLayer/DialogueHolder")
			b.add_child(a)
			a.text = file
			a.start()
			await a.done
			emit_signal("end_interaction")
		Global.can_move = true
	else: print("Error: no dialogue file (attach a .json)")
