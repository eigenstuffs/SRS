extends Control

class_name Tutorial

signal confirm_pressed

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	emit_signal("confirm_pressed")

func _on_confirm_button_pressed():
	emit_signal("confirm_pressed")
