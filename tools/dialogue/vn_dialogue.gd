extends Control

class_name VisualNovelDialogue

signal fade_black
signal fade_blacktored
signal fade_blacktowhite
signal fade_red
signal fade_redtowhite
signal fade_redtoblack
signal fade_white
signal fade_whitetored
signal fade_whitetoblack

signal fade_trans

signal music_ambience
signal music_chiptune
signal music_bgm1
signal music_bgm2
signal stop_music

signal sfx_door_knock
signal sfx_glass_break
signal sfx_page_flip
signal sfx_door_open_close
signal sfx_impact_3
signal sfx_creepy_stinger
signal sfx_reverse_cymbal_ominous
signal sfx_boom
signal sfx_church_bell
signal sfx_impact_1
signal sfx_impact_2
signal sfx_school_bell
signal sfx_battle_start
signal sfx_rain_looping
signal sfx_switch_click
signal sfx_ambiance_echoes
signal sfx_ambiance_heavy
signal sfx_melody_save
signal sfx_rattling_door
signal sfx_realization
signal sfx_whoosh_foam
signal sfx_happy
signal sfx_epiphany
signal sfx_heartbeat_looping
signal sfx_bells_mystery
signal sfx_bells_countdown
signal sfx_bells_magic_chime
signal sfx_reverse_cymbal
signal sfx_printer_error
signal sfx_cinematic_glitch
signal sfx_static_crash
signal sfx_urban_rain_looping
signal sfx_game_chime
signal sfx_game_select
signal sfx_footstep_running_gravel
signal sfx_realization_bells

signal stop_sfx
signal stop_looping_sfx

signal cg_sky
signal cg_black
signal cg_dining

signal cg_god_bg
signal cg_god_neutral
signal cg_god_neutral_talk
signal cg_god_serious
signal cg_god_serious_talk
signal cg_god_smile
signal cg_god_smile_talk
signal cg_exit_god

signal add_OOC
signal add_OPP

const CHARACTER_LIST : CharacterList = preload("res://resources/characters/character_list.tres")
const CHOICE_BUTTON = preload("res://tools/dialogue/dialogue_choice.tscn")

@onready var box = $TextBox/Box
@onready var name_frame = $TextBox/NameFrame
@onready var label = $TextBox/Label
@onready var character_name = $TextBox/Name
@onready var remember = $TextBox/Remember
@onready var next = $TextBox/Next
@onready var choice_ui = $Choice
@onready var sprite_handler : SpriteHandler = $SpriteHandler
@onready var settings_dropdown : SettingsDropDown = $TextBox/Settings
@onready var text_box = $TextBox

@onready var ui_elements : Array = [
	box,
	label
	#$TextBox/Settings
]

@export_file("*.json") var text

var result : Dictionary
var lines : Dictionary = {}
var current_line : Dictionary
var restorable_choices
var current_mood

var a : Tween
var current_time : float

signal next_pressed
signal done
signal choice(which : int)
signal finished_line

func _ready():
	text_box.hide()
	choice_ui.hide()
	
	if text == null:
		text = Global.return_current_text()
	
	EffectAnim.play_backwards("FadeBlack")
	await EffectAnim.animation_finished
	if text:
		self.connect("choice", choice_funnel)
		
		var string = FileAccess.get_file_as_string(text)
		result = JSON.parse_string(string)
		
		#init_parameters(0)
		next_anim()
		read_line(0)
	else: print("Error: text doesn't exist within Dialogue node")

func read_line(key : int):
	next.hide()
	next.disabled = true
	choice_ui.hide()
	
	current_line = result.get(result.keys()[key])
	init_parameters(key)
	
	if current_line["delay"] != null:
		text.hide()
		await get_tree().create_timer(int(current_line["delay"])).timeout
	if current_line["add"] != null:
		Global.add_event(current_line["add"])
		print(Global.remembered)

	text_box.show()
	#remember.position = Vector2(1280,672)
	#remember.modulate = Color(1,1,1,1)
	#remember.hide()
	if current_line["emit"] != null:
		var text = current_line["emit"].split(",")
		for i in text.size():
			print(text[i])
			self.emit_signal(text[i])
	if current_line["set"] != null:
		var text = current_line["set"].split(",")
		var variable = text[0]
		var value = text[1]
		print("set " + variable + " as " + value)
		Global.set(variable, value)
	if current_line["flag"] != null:
		text_box.hide()
		settings_dropdown.stop_skip()
		
	if current_line["flag"] == "decision":
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
	elif current_line["flag"] == "name_seraphina":
		$EffectHandler.seraphina_name_screen()
		await $EffectHandler.done
	if current_line["text"] == null:
		text_box.hide()
	else:
		label.text = current_line["text"]
		label.visible_characters = 1
		var num_chars = label.text.length()
		var total_time = Global.text_speed * num_chars
		current_time = total_time
		a = create_tween()
		a.tween_property(label, "visible_characters", num_chars, total_time - (
			int(settings_dropdown.skip) * total_time * 0.9)
		)
		await a.finished
		var b = create_tween()
		next.show()
		next.modulate.a = 0
		b.tween_property(next, "modulate:a", 1, 0.2)
		next.disabled = false
		finished_line.emit()
		if !settings_dropdown.autoplay:
			await next_pressed
		else:
			await get_tree().create_timer(
				1 - (int(settings_dropdown.skip) * 0.9)
			).timeout
		if current_line["flag"] == "menu":
			text_box.hide()
			EffectAnim.play("FadeBlack")
			await EffectAnim.animation_finished
			get_tree().change_scene_to_file("res://scenes/menus/title.tscn")
		elif current_line["flag"] == "quit":
			get_tree().quit()
			
	if current_line["run if"] != null:
		var text = current_line["run if"].split(",")
		var condition = text[0]
		var target = text[1]
		if Global.remembered.has(condition):
			print("HAS CONDITION MET")
			current_line["go to"] = target
	next_line()

func next_line():
	if current_line["go to"] != null:
		read_line(result.keys().find(str(current_line["go to"])))
	else:
		emit_signal("done")
		
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
	sprite_handler.init_cecilia(line["cecilia"])
	var sprites

	if line["character"] != null && line["sprite"] != null:
		character_name.show()
		name_frame.show()
		sprite_handler.init_sprite(
			line["character"].split(","),
			line["sprite"].split(",")
		)
		if line["character"] == "Player":
			character_name.text = Global.player_name

	elif line["character"] != null:
		sprite_handler.clear_sprites()
		character_name.text = line["character"]
		character_name.show()
		name_frame.show()
	else:
		sprite_handler.clear_sprites()
		character_name.text = ""
		character_name.hide()
		name_frame.hide()
	if current_line["text"]:
		if character_name.text != "":
			settings_dropdown.add_to_log(
				"[b]" + character_name.text + ":[/b] " +
				current_line["text"]
			)
		else:
			settings_dropdown.add_to_log(
				current_line["text"]
			)

func choice_funnel(which : int):
	var choice = current_line["options_id"].split(",")[which]
	current_line["go to"] = choice
	
func choice_pressed():
	for i in $Choice/Buttons.get_children():
		if i.button_pressed:
			choice.emit(i.get_index())
			return

func _input(event):
	if event.is_action_pressed("ui_accept") or (event.is_action_pressed("LMB") and settings_dropdown.lmb):
		if !next.disabled:
			var a = create_tween()
			a.tween_property(next, "modulate:a", 0, 0.2)
			await a.finished
			emit_signal("next_pressed")
		elif a:
			if a.is_running():
				a.pause()
				a.custom_step(current_time)

func _on_next_pressed():
	var a = create_tween()
	a.tween_property(next, "modulate:a", 0, 0.2)
	await a.finished
	emit_signal("next_pressed")

func _on_settings_autoplay_started():
	emit_signal("next_pressed")
