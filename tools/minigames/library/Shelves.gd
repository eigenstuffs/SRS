extends Node3D

@onready var left_shelf : Sprite3D = $LShelf
@onready var right_shelf : Sprite3D = $RShelf

signal stop_blinking

func blinking():
	var a = get_tree().create_tween().set_loops().set_ease(Tween.EASE_OUT)
	var b = get_tree().create_tween().set_loops().set_ease(Tween.EASE_OUT)
	a.tween_property(left_shelf, "modulate", Color(0.2, 0.2, 0.2), 1)
	b.tween_property(right_shelf, "modulate", Color(0.2, 0.2, 0.2), 1)
	a.tween_property(left_shelf, "modulate", Color.WHITE, 1)
	b.tween_property(right_shelf, "modulate", Color.WHITE, 1)
	await stop_blinking
	a.kill()
	b.kill()
	left_shelf.modulate = Color.WHITE
	right_shelf.modulate = Color.WHITE

func _on_library_stop_blinking():
	emit_signal("stop_blinking")
