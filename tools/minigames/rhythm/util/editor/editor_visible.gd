class_name EditorVisible extends Node3D

func _init() -> void:
	if not Engine.is_editor_hint():
		visible = false
