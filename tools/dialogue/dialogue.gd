extends Control

class_name Dialogue

signal start_music
signal boost_stats

const CHARACTER_LIST : CharacterList = preload("res://resources/characters/character_list.tres")

@onready var box = $Box
@onready var sprite = $Sprite
@onready var label = $Label
@onready var remember = $Remember
@onready var button = $Button
@onready var choice_ui = $Choice
@onready var options = $Choice/Options
@onready var optionOne = $Choice/Options/OptionOne
@onready var optionTwo = $Choice/Options/OptionTwo
@onready var optionThree = $Choice/Options/OptionThree

var text

var result : Dictionary
var lines : Dictionary = {}
var current_line : Dictionary
var restorable_choices
var new_sprite = true
var current_mood

signal next
signal done
signal choice(which : int)

func start():
	if text:
		choice_ui.hide()
		
		self.connect("choice", choice_funnel)
		
		var string = FileAccess.get_file_as_string(text)
		result = JSON.parse_string(string)
		
		#init_parameters(0)
		read_line(0)
	else: print("Error: text doesn't exist within Dialogue node")

func read_line(key : int):
	current_line = result.get(result.keys()[key])
	if current_line["run if"] != null:
		if Global.remembered.has(current_line["run if"]):
			init_parameters(key)
		else:
			next_line()
			return
	else:
		init_parameters(key)
	if current_line["delay"] != null:
		box.hide()
		sprite.hide()
		label.hide()
		button.hide()
		choice_ui.hide()
		await get_tree().create_timer(int(current_line["delay"])).timeout
	box.show()
	sprite.show()
	label.show()
	button.hide()
	choice_ui.hide()
	remember.position = Vector2(1280,672)
	remember.modulate = Color(1,1,1,1)
	remember.hide()
	if current_line["emit"] != null:
		emit_signal(current_line["emit"])
	if current_line["text"]: label.text = current_line["text"]
	if current_line["flag"] == "decision":
		box.hide()
		sprite.hide()
		label.hide()
		button.hide()
		if current_line["options"] != null:
			var text = current_line["options"].split(",")
			$Choice/Backdrop.position = Vector2(-1920,0)
			$Choice/Graphic.position = Vector2(960,0)
			options.position = Vector2(0,-960)
			choice_ui.show()
			var a = create_tween()
			a.tween_property($Choice/Backdrop, "position", Vector2(0,0), .5).set_trans(Tween.TRANS_EXPO)
			a = create_tween()
			a.tween_property(options, "position", Vector2(0,0), 0.5).set_trans(Tween.TRANS_EXPO)
			var b = create_tween()
			b.tween_property($Choice/Graphic, "position", Vector2(0,0), .5).set_trans(Tween.TRANS_EXPO)
			button.hide()
			await choice
			a = create_tween()
			a.tween_property($Choice/Backdrop, "position", Vector2(-1920,0), .5).set_trans(Tween.TRANS_EXPO)
			a = create_tween()
			a.tween_property(options, "position", Vector2(0,1000), 0.5).set_trans(Tween.TRANS_EXPO)
			b = create_tween()
			b.tween_property($Choice/Graphic, "position", Vector2(960,0), .5).set_trans(Tween.TRANS_EXPO)
			await b.finished
	else:
		if current_line["flag"] == "end":
			current_line["go to"] = null
		if current_line["add"] != null:
			remember.show()
			Global.remembered.append(current_line["add"])
			remember.text = current_line["character"] + " will remember that."
			var c = create_tween()
			c.tween_property(remember, "position", Vector2(1280,600), 2)
			c = create_tween()
			c.tween_property(remember, "modulate", Color(1,1,1,0), 2)
		if new_sprite:
			sprite.position = Vector2(0,608)
			var d = create_tween()
			d.tween_property(sprite, "position", Vector2(0,0), 0.2).set_trans(Tween.TRANS_EXPO)
		label.visible_characters = 0
		var num_chars = label.text.length()
		var total_time = Global.text_speed * num_chars
		var a = create_tween()
		a.tween_property(label, "visible_characters", num_chars, total_time)
		await a.finished
		button.show()
		await next
	next_line()

func next_line():
	if current_line["go to"] != null:
		read_line(result.keys().find(current_line["go to"]))
	else:
		emit_signal("done")
		queue_free()

func init_parameters(key : int):
	var line = result.get(result.keys()[key])
	var char : Resource = null
	var prev_mood = current_mood
	if line["character"] != null:
		char = CHARACTER_LIST.list.get(line["character"])
		match line["sprite"]:
			"happy":
				sprite.texture = char.happy
				current_mood = "happy"
			"neutral":
				sprite.texture = char.neutral
				current_mood = "neutral"
			"sad":
				sprite.texture = char.sad
				current_mood = "sad"
	if line["flag"] == "decision":
		current_mood = null
	if current_mood == prev_mood:
		new_sprite = false
	else: new_sprite = true

func choice_funnel(which : int):
	var choice = current_line["options_id"].split(",")[which]
	current_line["go to"] = choice

func _on_button_pressed():
	emit_signal("next")

func _on_option_one_pressed():
	emit_signal("choice", 0)

func _on_option_two_pressed():
	emit_signal("choice", 1)

func _on_option_three_pressed():
	emit_signal("choice", 2)

func _on_option_one_mouse_entered():
	var a = create_tween()
	a.tween_property(optionOne, "scale", Vector2(1.1,1.1), 0.1)

func _on_option_two_mouse_entered():
	var a = create_tween()
	a.tween_property(optionTwo, "scale", Vector2(1.1,1.1), 0.1)

func _on_option_three_mouse_entered():
	var a = create_tween()
	a.tween_property(optionThree, "scale", Vector2(1.1,1.1), 0.1)

func _on_option_one_mouse_exited():
	var a = create_tween()
	a.tween_property(optionOne, "scale", Vector2(1,1), 0.1)

func _on_option_two_mouse_exited():
	var a = create_tween()
	a.tween_property(optionTwo, "scale", Vector2(1,1), 0.1)

func _on_option_three_mouse_exited():
	var a = create_tween()
	a.tween_property(optionThree, "scale", Vector2(1,1), 0.1)

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("LMB"):
		if $Button/Next.visible:
			emit_signal("next")
