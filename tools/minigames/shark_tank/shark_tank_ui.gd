extends Control

class_name SharkTankUI

signal minigame_finished()

@onready var buttons : Control = $Buttons

var following_mouse : bool = false
var held_button : Button = null
var diff : Vector2 = Vector2.ZERO

func _ready():
	for i in buttons.get_children():
		i.connect("pressed", _on_button_pressed)
		# i connect it through code cuz we dont know how
		# many buttons there will be

func _input(event):
	if event.is_action_released("LMB") and held_button:
		held_button.button_pressed = false
		held_button = null
	
func _process(delta):
	if held_button:
		var mouse_pos = get_global_mouse_position()-diff
		held_button.position = mouse_pos

func _on_button_pressed():
	for i : Button in buttons.get_children():
		if i.button_pressed:
			held_button = i
			diff = get_global_mouse_position() - i.position
