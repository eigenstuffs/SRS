extends Control

signal setting_closed

# Called when the node enters the scene tree for the first time.
func _ready():
	print("settings initiated")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_button_pressed():
	emit_signal("setting_closed")
	queue_free()
