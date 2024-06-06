extends Control

var sub_lmb = true

func _process(_delta):
	if Rect2(Vector2(), size).has_point(
		get_local_mouse_position()
	):
		sub_lmb = false
	else:
		sub_lmb = true
