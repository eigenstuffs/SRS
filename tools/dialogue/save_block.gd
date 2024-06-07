extends Button

signal delete_save

var save_path : String
@onready var delete_button = $Delete

func _ready():
	toggle_delete_visibility(false)

func _on_delete_mouse_entered():
	toggle_delete_visibility(true)

func _on_delete_mouse_exited():
	toggle_delete_visibility(false)

func _on_delete_pressed():
	print("pressed")
	emit_signal("delete_save")

func toggle_delete_visibility(state):
	$Delete/ColorRect.visible = state
	$Delete/Label.visible = state
#
#func _on_mouse_entered():
	#toggle_delete_visibility(true)
#
#func _on_mouse_exited():
	#toggle_delete_visibility(false)
