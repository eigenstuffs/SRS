extends Control

@onready var scroll = $VScrollBar

signal log_closed

@onready var vbox_height = $ScrollContainer/VBoxContainer.size.y

func init():
	vbox_height = $ScrollContainer/VBoxContainer.size.y
	scroll.value = 1
	
	if vbox_height <= 550:
		scroll.hide()
	else:
		scroll.show()
		$ScrollContainer.scroll_vertical = (vbox_height - 600) * scroll.value

func _on_v_scroll_bar_value_changed(value):
	$ScrollContainer.scroll_vertical = (vbox_height - 600) * value

func _on_texture_button_pressed():
	log_closed.emit()

func _on_v_scroll_bar_mouse_entered():
	print("over scroll")
