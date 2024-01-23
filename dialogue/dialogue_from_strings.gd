extends Control

class_name DialogueFromStrings

signal start_music
signal boost_stats

@onready var box = $Box
@onready var label = $Label
@onready var button = $Button

signal next
signal finished_reading

func read(text_array : Array[String]):
	for i in text_array.size():
		read_line(text_array[i])
		await next
	emit_signal("finished_reading")

func read_line(line : String):
	box.show()
	label.show()
	button.hide()
	label.text = line
	label.visible_characters = 0
	var num_chars = label.text.length()
	var total_time = Global.text_speed * num_chars
	var a = create_tween()
	a.tween_property(label, "visible_characters", num_chars, total_time)
	await a.finished
	button.show()

func _on_button_pressed():
	emit_signal("next")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if $Button/Next.visible:
			emit_signal("next")
