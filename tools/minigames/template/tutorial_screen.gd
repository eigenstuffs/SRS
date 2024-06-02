extends Control

class_name Tutorial

signal confirm_pressed

func _on_confirm_button_pressed():
	emit_signal("confirm_pressed")
