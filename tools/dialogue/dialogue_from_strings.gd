extends Control

class_name DialogueFromStrings

signal start_music
signal boost_stats

@onready var box = $Box
@onready var label = $Label
@onready var next = $Next

signal next_pressed
signal finished_line
signal finished_reading

func read(text_array : Array[String]):
	for i in text_array.size():
		read_line(text_array[i])
		await next_pressed
	emit_signal("finished_reading")

func read_line(line : String):
	box.show()
	label.show()
	label.text = line
	label.visible_characters = 0
	var num_chars = label.text.length()
	var total_time = Global.text_speed * num_chars
	var a = create_tween()
	a.tween_property(label, "visible_characters", num_chars, total_time)
	await a.finished
	var b = create_tween()
	next.show()
	next.modulate.a = 0
	b.tween_property(next, "modulate:a", 1, 0.2)
	next.disabled = false
	finished_line.emit()
	await next_pressed
	next_pressed.emit()
	
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
		if next.visible:
			emit_signal("next")
