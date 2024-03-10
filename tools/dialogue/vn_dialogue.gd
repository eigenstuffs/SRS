extends Control

class_name VisualNovelDialogue

signal start_music
signal boost_stats

signal music_ambience
signal music_chiptune
signal music_bgm1

signal stop_music

signal sfx_truck
signal sfx_screams

signal fade_black
signal fade_red

signal cg_death
signal cg_gamestart
signal cg_god

signal name_player

const CHARACTER_LIST : CharacterList = preload("res://resources/characters/character_list.tres")
const CHOICE_BUTTON = preload("res://tools/dialogue/dialogue_choice.tscn")

@onready var box = $Box
@onready var name_frame = $NameFrame
@onready var label = $Label
@onready var character_name = $Name
@onready var remember = $Remember
@onready var next = $Next
@onready var choice_ui = $Choice

@onready var ui_elements : Array = [
	box,
	label
]

@export_file("*.json") var text

var result : Dictionary
var lines : Dictionary = {}
var current_line : Dictionary
var restorable_choices
var current_mood

signal next_pressed
signal done
signal choice(which : int)
signal finished_line

func _ready():
	if text:
		choice_ui.hide()
		self.connect("choice", choice_funnel)
		
		var string = FileAccess.get_file_as_string(text)
		result = JSON.parse_string(string)
		
		#init_parameters(0)
		next_anim()
		read_line(0)
	else: print("Error: text doesn't exist within Dialogue node")

func read_line(key : int):
	current_line = result.get(result.keys()[key])
	if current_line["run if"] != null:
		var text = current_line["run if"].split(",")
		var condition = text[1]
		var target = text[2]
		if Global.remembered.has(condition):
			init_parameters(key)
			current_line["go to"] = target
		else:
			next_line()
			return
	else:
		init_parameters(key)
	if current_line["delay"] != null:
		for i in ui_elements: i.hide()
		next.hide()
		choice_ui.hide()
		await get_tree().create_timer(int(current_line["delay"])).timeout
	for i in ui_elements: i.show()
	next.disabled = true
	next.hide()
	choice_ui.hide()
	remember.position = Vector2(1280,672)
	remember.modulate = Color(1,1,1,1)
	remember.hide()
	if current_line["text"] == null:
		for i in ui_elements: i.hide()
	if current_line["emit"] != null:
		var text = current_line["emit"].split(",")
		for i in text.size():
			print(text[i])
			self.emit_signal(text[i])
	if current_line["set"] != null:
		var text = current_line["set"].split(",")
		var variable = text[1]
		var value = text[2]
		Global.set(variable, value)
	if current_line["text"]: label.text = current_line["text"]
	if current_line["flag"] == "decision":
		for i in ui_elements: i.hide()
		next.hide()
		if current_line["options"] != null:
			$Choice/Backdrop.position = Vector2(1950,0)
			choice_ui.show()
			var text : Array = current_line["options"].split(",")
			var a = create_tween()
			a.tween_property($Choice/Backdrop, "position", Vector2(960,0), .5).set_trans(Tween.TRANS_EXPO)
			await get_tree().create_timer(0.1).timeout
			for i in text:
				var button : TextureButton = CHOICE_BUTTON.instantiate()
				button.connect("pressed", choice_pressed)
				$Choice/Buttons.add_child(button)
				button.get_node("Label").text = i
				button.position = Vector2(1140,-180)
			match $Choice/Buttons.get_child_count():
				1:
					var points = $Choice/Control/OneDecision.get_children()
					var b = create_tween()
					b.tween_property($Choice/Buttons.get_child(0), "position", points[0].position, 0.5).set_trans(Tween.TRANS_EXPO)
				2:
					var points = $Choice/Control/TwoDecisions.get_children()
					var b = create_tween()
					b.tween_property($Choice/Buttons.get_child(0), "position", points[0].position, 0.5).set_trans(Tween.TRANS_EXPO)
					await get_tree().create_timer(0.03).timeout
					b = create_tween()
					b.tween_property($Choice/Buttons.get_child(1), "position", points[1].position, 0.5).set_trans(Tween.TRANS_EXPO)
				3:
					var points = $Choice/Control/ThreeDecisions.get_children()
					var b = create_tween()
					b.tween_property($Choice/Buttons.get_child(0), "position", points[0].position, 0.5).set_trans(Tween.TRANS_EXPO)
					await get_tree().create_timer(0.03).timeout
					b = create_tween()
					b.tween_property($Choice/Buttons.get_child(1), "position", points[1].position, 0.5).set_trans(Tween.TRANS_EXPO)
					await get_tree().create_timer(0.03).timeout
					b = create_tween()
					b.tween_property($Choice/Buttons.get_child(2), "position", points[2].position, 0.5).set_trans(Tween.TRANS_EXPO)
				4:
					var points = $Choice/Control/FourDecisions.get_children()
					var b = create_tween()
					b.tween_property($Choice/Buttons.get_child(0), "position", points[0].position, 0.5).set_trans(Tween.TRANS_EXPO)
					await get_tree().create_timer(0.1).timeout
					b = create_tween()
					b.tween_property($Choice/Buttons.get_child(1), "position", points[1].position, 0.5).set_trans(Tween.TRANS_EXPO)
					await get_tree().create_timer(0.1).timeout
					b = create_tween()
					b.tween_property($Choice/Buttons.get_child(2), "position", points[2].position, 0.5).set_trans(Tween.TRANS_EXPO)
					await get_tree().create_timer(0.1).timeout
					b = create_tween()
					b.tween_property($Choice/Buttons.get_child(3), "position", points[3].position, 0.5).set_trans(Tween.TRANS_EXPO)
			await choice
			match $Choice/Buttons.get_child_count():
				1:
					var points = $Choice/AwayPos/OneDecision.get_children()
					var b = create_tween()
					b.tween_property($Choice/Buttons.get_child(0), "position", points[0].global_position, 0.5).set_trans(Tween.TRANS_EXPO)
				2:
					var points = $Choice/AwayPos/TwoDecisions.get_children()
					var b = create_tween()
					b.tween_property($Choice/Buttons.get_child(0), "position", points[0].global_position, 0.5).set_trans(Tween.TRANS_EXPO)
					await get_tree().create_timer(0.03).timeout
					b = create_tween()
					b.tween_property($Choice/Buttons.get_child(1), "position", points[1].global_position, 0.5).set_trans(Tween.TRANS_EXPO)
				3:
					var points = $Choice/AwayPos/ThreeDecisions.get_children()
					var b = create_tween()
					b.tween_property($Choice/Buttons.get_child(0), "position", points[0].global_position, 0.5).set_trans(Tween.TRANS_EXPO)
					await get_tree().create_timer(0.03).timeout
					b = create_tween()
					b.tween_property($Choice/Buttons.get_child(1), "position", points[1].global_position, 0.5).set_trans(Tween.TRANS_EXPO)
					await get_tree().create_timer(0.03).timeout
					b = create_tween()
					b.tween_property($Choice/Buttons.get_child(2), "position", points[2].global_position, 0.5).set_trans(Tween.TRANS_EXPO)
				4:
					var points = $Choice/AwayPos/FourDecisions.get_children()
					var b = create_tween()
					b.tween_property($Choice/Buttons.get_child(0), "position", points[0].global_position, 0.5).set_trans(Tween.TRANS_EXPO)
					await get_tree().create_timer(0.1).timeout
					b = create_tween()
					b.tween_property($Choice/Buttons.get_child(1), "position", points[1].global_position, 0.5).set_trans(Tween.TRANS_EXPO)
					await get_tree().create_timer(0.1).timeout
					b = create_tween()
					b.tween_property($Choice/Buttons.get_child(2), "position", points[2].global_position, 0.5).set_trans(Tween.TRANS_EXPO)
					await get_tree().create_timer(0.1).timeout
					b = create_tween()
					b.tween_property($Choice/Buttons.get_child(3), "position", points[3].global_position, 0.5).set_trans(Tween.TRANS_EXPO)
			await get_tree().create_timer(0.1).timeout
			a = create_tween()
			a.tween_property($Choice/Backdrop, "position", Vector2(1950,0), .5).set_trans(Tween.TRANS_EXPO)
			await a.finished
			for i in $Choice/Buttons.get_children():
				i.queue_free()
	elif current_line["flag"] == "name_player":
			$EffectHandler.player_name_screen()
			await $EffectHandler.done
	else:
		if current_line["add"] != null:
			#remember.show()
			#Global.remembered.append(current_line["add"])
			#if current_line["character"] != null:
				#remember.text = current_line["character"] + " will remember that."
			#else:
				#remember.text = "I will remember that."
			#var c = create_tween()
			#c.tween_property(remember, "position", Vector2(1097,600), 2)
			#c = create_tween()
			#c.tween_property(remember, "modulate", Color(1,1,1,0), 2)
			pass
		label.visible_characters = 0
		var num_chars = label.text.length()
		#var total_time = Global.text_speed * num_chars
		var total_time = 0.1
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
		if current_line["flag"] == "end":
			current_line["go to"] = null
		elif current_line["flag"] == "menu":
			pass
		elif current_line["flag"] == "quit":
			get_tree().quit()
	next_line()

func next_line():
	if current_line["go to"] != null:
		read_line(result.keys().find(str(current_line["go to"])))
	else:
		emit_signal("done")
		queue_free()
		
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

func init_parameters(key : int):
	var line = result.get(result.keys()[key])
	var char : Resource = null
	var prev_mood = current_mood
	if line["character"] != null:
		char = CHARACTER_LIST.list.get(line["character"])
		character_name.text = line["character"]
		name_frame.show()
	else:
		character_name.text = ""
		name_frame.hide()

func choice_funnel(which : int):
	var choice = current_line["options_id"].split(",")[which]
	current_line["go to"] = choice
	
func choice_pressed():
	for i in $Choice/Buttons.get_children():
		if i.button_pressed:
			choice.emit(i.get_index())
			return

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("done")
		queue_free()
	elif event.is_action_pressed("ui_accept"):
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
