extends Control

@onready var text = $TextEdit

func _on_skip_pressed():
	Util.create_minigame($CanvasLayer, $TextEdit.text)
