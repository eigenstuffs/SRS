extends Control

const MAX_LETTER_LENGTH = 12
var uppercase : bool = false
var input : String = ""

@onready var letters = $Letters
@onready var buttons = $VBoxContainer/Buttons

signal done

func _ready():
	$VBoxContainer/Buttons/a.grab_focus()
	for i in buttons.get_children():
		i.connect("pressed", button_pressed)

func _on_uppercase_toggled(toggled_on):
	uppercase = toggled_on
	$Uppercase.visible = uppercase
	$Lowercase.visible = !uppercase

func _on_delete_pressed():
	input = input.erase(input.length() - 1, 1)
	update_name()

func _on_done_pressed():
	Global.rename_seraphina(input)
	emit_signal("done")
	queue_free()

func button_pressed():
	if input.length() < MAX_LETTER_LENGTH:
		for i in buttons.get_children():
			if i.button_pressed:
				i.button_pressed = false
				var _char = get_character(i)
				if uppercase: _char = _char.to_upper()
				input = input + _char
				print(input)
				update_name()

func get_character(i):
	match i.name:
		"TextureButton27":
			return null
		"TextureButton27":
			return null
		"TextureButton40":
			return "@"
		"TextureButton41":
			return "&"
		"TextureButton42":
			return "-"
		"TextureButton43":
			return "#"
		"TextureButton44":
			return "$"
		"TextureButton45":
			return "*"
		"TextureButton46":
			return "^"
		"TextureButton47":
			return ":"
		"TextureButton48":
			return "/"
		"TextureButton49":
			return "?"
		"TextureButton50":
			return "!"
		"TextureButton51":
			return "("
		"TextureButton52":
			return ")"
		_:
			return i.name

func update_name():
	var chars = input.split("")
	print(input.split(""))
	
	for i in range(min(chars.size(), MAX_LETTER_LENGTH)):
		var child = letters.get_child(i)
		if child != null:
			child.text = chars[i]
			child.visible = true
		
	for i in range(chars.size(), letters.get_child_count()):
		var child = letters.get_child(i)
		child.text = ""
		child.visible = false
