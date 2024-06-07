extends Control

@onready var scroll = $VScrollBar

signal log_closed

@onready var vbox_height = $ScrollContainer/VBoxContainer.size.y

func _ready():
	$VScrollBar.max_value = $ScrollContainer.get_v_scroll_bar().max_value
	$VScrollBar.min_value = $ScrollContainer.get_v_scroll_bar().min_value

func _on_v_scroll_bar_value_changed(value):
	$ScrollContainer.scroll_vertical = value

func _on_texture_button_pressed():
	log_closed.emit()

func _on_v_scroll_bar_mouse_entered():
	print("over scroll")
