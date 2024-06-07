extends Node3D

signal stop_blinking

func blinking():
	var a = get_tree().create_tween().set_loops().set_ease(Tween.EASE_OUT)
	a.tween_property($Shelves, "modulate", Color(0.2, 0.2, 0.2), 1)
	a.tween_property($Shelves, "modulate", Color.WHITE, 1)
	await stop_blinking
	a.kill()
	$Shelves.modulate = Color.WHITE

func _on_library_stop_blinking():
	emit_signal("stop_blinking")
