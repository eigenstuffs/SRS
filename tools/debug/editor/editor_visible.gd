class_name EditorVisible extends Node3D
## A Node3D that is only visible in the editor

func _init() -> void:
	if not Engine.is_editor_hint():
		visible = false
