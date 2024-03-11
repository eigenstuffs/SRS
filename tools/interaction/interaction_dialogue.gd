extends Interaction

@export var text : Array[String]

const DIALOGUE = preload("res://tools/dialogue/dialogue_from_strings.tscn")

func action():
	if text:
		print("Dialogue pop-up")
		Global.can_move = false
		var a = DIALOGUE.instantiate()
		if get_tree().current_scene.has_node("CanvasLayer/DialogueHolder"):
			var b = get_tree().current_scene.get_node("CanvasLayer/DialogueHolder")
			b.add_child(a)
			a.read(text)
			await a.finished_reading
			a.queue_free()
			emit_signal("end_interaction")
		Global.can_move = true
	else: print("Error: no dialogue file")
