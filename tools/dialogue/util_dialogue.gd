extends Control

class_name UtilDialogue

@onready var box = $TextBox/Box
@onready var name_frame = $TextBox/NameFrame
@onready var label = $TextBox/Label
@onready var character_name = $TextBox/Name
@onready var next = $TextBox/Next

@export var text : Array[String]

var a : Tween
var current_time : float

signal next_pressed
signal done
signal finished_line

signal finished_reading

func _ready():
	$TextBox.hide()

func read(text : Array, names : Array):
	print(text)
	print(names)
	
	next_anim()
	
	for i in text.size():
		$TextBox.show()
		
		if names[i] != "null":
			print("set name")
			character_name.text = names[i]
		else:
			character_name.text = ""
			
		if names[i] != "null":
			name_frame.show()
		else:
			name_frame.hide()
		
		label.text = text[i]
		label.visible_characters = 1
		var num_chars = text[i].length()
		var total_time = Global.data_dict["text_speed"] * num_chars
		a = create_tween()
		a.tween_property(label, "visible_characters", num_chars, total_time)
		await a.finished
		
		var b = create_tween()
		next.show()
		next.modulate.a = 0
		b.tween_property(next, "modulate:a", 1, 0.2)
		next.disabled = false
		finished_line.emit()
		
		await next_pressed
	emit_signal("finished_reading")
		
func next_anim():
	if !next.disabled:
		await get_tree().create_timer(.6).timeout
		var a = create_tween()
		a.tween_property(next, "modulate:a", 0.55, 0.25)
		await get_tree().create_timer(.6).timeout
		a = create_tween()
		a.tween_property(next, "modulate:a", 1, 0.25)
		next_anim()
	else:
		await finished_line
		next_anim()

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("LMB"):
		if !next.disabled:
			var a = create_tween()
			a.tween_property(next, "modulate:a", 0, 0.2)
			await a.finished
			emit_signal("next_pressed")

func _on_next_pressed():
	var a = create_tween()
	a.tween_property(next, "modulate:a", 0, 0.2)
	await a.finished
	emit_signal("next_pressed")
