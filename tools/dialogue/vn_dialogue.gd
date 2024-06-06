extends Control

class_name VisualNovelDialogue

signal fade_black
signal fade_black_abrupt
signal fade_blacktored
signal fade_blacktowhite
signal fade_red
signal fade_redtowhite
signal fade_redtoblack
signal fade_white
signal fade_whitetored
signal fade_whitetoblack

signal fade_trans

signal flash_white

signal screen_shake

signal stop_music

signal sfx_door_knock
signal sfx_glass_break
signal sfx_page_flip
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
signal sfx_inquisitive
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
signal sfx_realization

signal sfx_heels_walking_metal
signal sfx_heels_walking_tile
signal sfx_heels_walking_wood_ext
signal sfx_heels_walking_wood_int
signal sfx_blanket_1
signal sfx_blanket_2
signal sfx_carcrash
signal sfx_chair_scoot_wood
signal sfx_curtains_heavy_1
signal sfx_cutlery_1
signal sfx_fabric_1
signal sfx_truck_horn
signal sfx_wardrobe_1
signal sfx_drawer_1
signal sfx_door_2
signal sfx_cutlery_2
signal sfx_bells_high
signal sfx_bells_low
signal sfx_bells_jingle
signal sfx_ominous_linger
signal sfx_ominous_quiet
signal sfx_ominous_mystery
signal sfx_ominous_buzz
signal sfx_dark_vibrate
signal sfx_dark_wash
signal sfx_ominous_funky
signal sfx_ominous_high
signal sfx_ambiance_scarywind
signal sfx_ambiance_blizzard
signal sfx_ambiance_people_1
signal sfx_ambiance_people_2
signal sfx_ambiance_morningbirds
signal sfx_twinkling_fairy
signal sfx_twinkling_chime
signal sfx_ambiance_fountain
signal sfx_footstep_walking_snow
signal sfx_ambiance_carriage_1
signal sfx_glasses_clink
signal sfx_glass_crash
signal sfx_coinflip_1
signal sfx_journal_writing
signal sfx_heels_running_wood_ext
signal sfx_horror_suspense_music
signal sfx_glass_hit_1
signal sfx_soft_wind

signal music_somber_death
signal music_more_intense
signal music_mysterious
signal music_first_stage
signal music_tea_time
signal music_social_warfare
signal music_church
signal music_church_welcoming
signal music_forest_2
signal music_town
signal music_ballroom
signal music_god
signal music_god_calm
signal music_sliceoflife
signal music_cecilia

signal pause_music
signal resume_music

signal stop_sfx
signal stop_looping_sfx

signal cg_sky
signal cg_black
signal cg_dining

signal cg_empty_fountain
signal cg_cecilia_fountain
signal cg_dead_snow

signal cg_winter
signal cg_white
signal stop_cg

signal cg_ballroom
signal cg_evening
signal cg_day
signal cg_night

signal cg_room
signal cg_room_blur

signal cg_god_bg
signal cg_god_neutral
signal cg_god_neutral_talk
signal cg_god_serious
signal cg_god_serious_talk
signal cg_god_smile
signal cg_god_smile_talk
signal cg_god_glitch
signal cg_exit_god
signal cg_town

signal cg_dining_light

signal overlay_blood_splatter

signal stop_overlay

signal add_OOC
signal add_OPP

signal remove_OOC
signal remove_OPP

signal hide_text
signal show_text
signal show_empty
signal show_next

const CHARACTER_LIST : CharacterList = preload("res://resources/characters/character_list.tres")
const CHOICE_BUTTON = preload("res://tools/dialogue/dialogue_choice.tscn")
const GOD_CHOICE_BUTTON = preload("res://tools/dialogue/god_dialogue_choice.tscn")

const GOD_DIALOGUE_TEXTURE = preload("res://assets/vn/Dialogue/Black Haze_God Dialogue.png")
const NORMAL_DIALOGUE_TEXTURE = preload("res://assets/vn/Dialogue/Dialogue Box.png")


@onready var box = $TextBox/Box
@onready var name_frame = $TextBox/NameFrame
@onready var label = $TextBox/Label
@onready var character_name = $TextBox/Name

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

var edgy_theme = false

func _ready():
	if text == null:
		text = Global.return_current_text()
	$EffectHandler.init()
		
	EffectAnim.play_backwards("FadeBlack")
	
	match text:
		Global.ACT1_CHAPTER1_SCENE1:
			alternate_text_box(true)
			edgy_theme = true
		Global.ACT1_CHAPTER1_SCENE2:
			alternate_text_box(true)
			edgy_theme = true
		Global.ACT1_CHAPTER1_SCENE3:
			alternate_text_box(true)
			edgy_theme = true
		_:
			alternate_text_box(false)
			edgy_theme = false
	
	text_box.hide()
	choice_ui.hide()
	
	await EffectAnim.animation_finished
	
	Global.data_dict["current_scene"] = text
	
	if text:
		self.connect("choice", choice_funnel)
		
		var string = FileAccess.get_file_as_string(text)
		result = JSON.parse_string(string)
		
		#init_parameters(0)
		next_anim()
		read_line(Global.data_dict["current_line"])
	else: print("Error: text doesn't exist within Dialogue node")

func read_line(key : int):	
	Global.data_dict["current_line"] = key
	next.hide()
	next.disabled = true
	choice_ui.hide()
	
	current_line = result.get(result.keys()[key])
	init_parameters(key)
	
	if current_line["text"]: current_line["text"] = current_line["text"].replace("[PlayerName]", Global.data_dict["player_name"])
	if current_line["text"]: current_line["text"] = current_line["text"].replace("[SeraphinaName]", Global.data_dict["seraphina_name"])
	
	if current_line["speaker"]: current_line["speaker"] = current_line["speaker"].replace("[PlayerName]", Global.data_dict["player_name"])
	if current_line["speaker"]: current_line["speaker"] = current_line["speaker"].replace("[SeraphinaName]", Global.data_dict["seraphina_name"])
	
	if current_line["delay"] != null:
		text_box.hide()
		await get_tree().create_timer(int(current_line["delay"])).timeout
	if current_line["remember"] != null:
		Global.add_event(current_line["remember"])
	if current_line["emit"]:
		if !current_line["emit"].split("|").has("hide_text"):
			text_box.show()
	else:
		text_box.show()
	
	if current_line["emit"] != null:
		var text = current_line["emit"].split("|")
		for i in text.size():
			print(text[i])
			self.emit_signal(text[i])
	if current_line["set var"] != null:
		var text = current_line["set var"].split("|")
		var variable = text[0]
		var value = text[1]
		print("set " + variable + " as " + value)
		Global.data_dict[variable] = value
	if current_line["flag"] != null:
		if current_line["flag"] != "slow":
			text_box.hide()
			settings_dropdown.stop_skip()
		
	if current_line["flag"] == "decision":
		if current_line["options"] != null:
			#var read_all = true
			#for i in current_line["options"].split("|"):
				#if !Global.data_dict["remembered"].has(i):
					#read_all = false
			if !edgy_theme:
				$Choice/Backdrop.position = Vector2(1950,0)
				choice_ui.show()
				var text : Array = current_line["options"].split("|")
				var a = create_tween()
				a.tween_property($Choice/Backdrop, "position", Vector2(960,0), .5).set_trans(Tween.TRANS_EXPO)
				await get_tree().create_timer(0.1).timeout
				for i in text:
					var button : TextureButton = CHOICE_BUTTON.instantiate()
					button.connect("pressed", choice_pressed)
					$Choice/Buttons.add_child(button)
					button.get_node("Label").text = i
					if Global.data_dict["remembered"].has(i):
						button["texture_normal"] = button["texture_disabled"]
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
			else:
				$GodChoice.modulate.a = 0
				$GodChoice.show()
				var text : Array = current_line["options"].split("|")
				for i in text:
					var a = GOD_CHOICE_BUTTON.instantiate()
					a.connect("pressed", choice_pressed)
					if Global.data_dict["remembered"].has(i):
						a["texture_normal"] = a["texture_disabled"]
					$GodChoice.add_child(a)
					a.get_node("Label").text = i
				var b = create_tween()
				b.tween_property(
					$GodChoice,
					"modulate:a",
					1,
					0.5
				)
				await b.finished
				await choice
				b = create_tween()
				b.tween_property(
					$GodChoice,
					"modulate:a",
					0,
					0.5
				)
				await b.finished
				for i in $GodChoice.get_children():
					i.queue_free()
				print("god choice finished")
	elif current_line["flag"] == "name_player":
		$EffectHandler.player_name_screen()
		await $EffectHandler.done
	elif current_line["flag"] == "name_seraphina":
		$EffectHandler.seraphina_name_screen()
		await $EffectHandler.done
	print('escaped')
	if current_line["text"] == null:
		text_box.hide()
		if current_line["flag"]:
			if current_line["flag"].split("|").has("autoplay"):
				await get_tree().create_timer(3).timeout
	else:
		label.text = current_line["text"]
		label.visible_characters = 1
		var num_chars = label.text.length()
		var total_time = Global.data_dict["text_speed"] * num_chars
		if current_line["flag"]:
			if current_line["flag"].split("|").has("slow"):
				total_time = total_time * 10
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
	
	if current_line["emit"]:
		if current_line["emit"].split("|").has("show_empty"):
			print("has show_empty")
			label.text = ""
			label.visible_characters = 1
			text_box.show()
			next.show()
			next.modulate.a = 0
			var b = create_tween()
			b.tween_property(next, "modulate:a", 1, 0.2)
			next.disabled = false
			finished_line.emit()
			if !settings_dropdown.autoplay:
				await next_pressed
			else:
				await get_tree().create_timer(
					1 - (int(settings_dropdown.skip) * 0.9)
				).timeout
	if current_line["emit"]:
		if current_line["emit"].split("|").has("show_next"):
			print("has show_next")
			label.text = ""
			label.visible_characters = 1
			text_box.hide()
			next.show()
			$TextBox/Settings.show()
			next.modulate.a = 0
			var b = create_tween()
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
		EffectAnim.speed_scale = 0.5
		await EffectAnim.animation_finished
		EffectAnim.speed_scale = 1
		#Global.save_data()
		get_tree().change_scene_to_file("res://scenes/menus/title.tscn")
	elif current_line["flag"] == "menu_abrupt":
		text_box.hide()
		EffectAnim.play("FadeBlackAbrupt")
		await EffectAnim.animation_finished
		#Global.save_data()
		get_tree().change_scene_to_file("res://scenes/menus/title.tscn")
	elif current_line["flag"] == "menu_lace":
		text_box.hide()
		EffectAnim.play("FadeLace")
		EffectAnim.speed_scale = 0.8
		await EffectAnim.animation_finished
		#Global.save_data()
		get_tree().change_scene_to_file("res://scenes/menus/title.tscn")
	elif current_line["flag"] == "free_zone_1":
		text_box.hide()
		EffectAnim.play("FadeBlack")
		EffectAnim.speed_scale = 0.5
		await EffectAnim.animation_finished
		EffectAnim.speed_scale = 1
		#Global.save_data()
		get_tree().change_scene_to_file("res://scenes/places/free_zone_1.tscn")
	elif current_line["flag"] == "free_zone_2":
		text_box.hide()
		EffectAnim.play("FadeBlack")
		EffectAnim.speed_scale = 0.5
		await EffectAnim.animation_finished
		EffectAnim.speed_scale = 1
		#Global.save_data()
		get_tree().change_scene_to_file("res://scenes/places/free_zone_2.tscn")
	elif current_line["flag"] == "quit":
		get_tree().quit()
	elif current_line["flag"] == "next_scene":
		text_box.hide()
		EffectAnim.play("FadeBlack")
		EffectAnim.speed_scale = 0.5
		await EffectAnim.animation_finished
		EffectAnim.speed_scale = 1
		#Global.save_data()
		get_tree().reload_current_scene()
	elif current_line["flag"] == "next_scene_lace":
		text_box.hide()
		EffectAnim.play("FadeLace")
		EffectAnim.speed_scale = 0.8
		await EffectAnim.animation_finished
		#Global.save_data()
		get_tree().reload_current_scene()
	elif current_line["flag"] == "next_scene_abrupt":
		text_box.hide()
		EffectAnim.play("FadeBlackAbrupt")
		await EffectAnim.animation_finished
		#Global.save_data()
		get_tree().reload_current_scene()
	
	if current_line["if remembered"] != null:
		var text = current_line["if remembered"].split("|")
		var condition = text[0]
		var target = text[1]
		var any_or_all
		if text.size() >= 3: any_or_all = text[2]
		else: any_or_all = null
		var ok = false
		
		for i in condition.split(","):
			if Global.data_dict["remembered"].has(i):
				print("HAS REMEMBERED ", i)
				ok = true
			else:
				if any_or_all == "any":
					pass
				else:
					ok = false
					break
					
		if ok: current_line["go to"] = target
	if current_line["check var"] != null:
		var text = current_line["check var"].split("|")
		var variable = text[0]
		var checker = text[1]
		var target = text[2]
		if Global.data_dict[variable] == checker:
			current_line["go to"] = target
			print(str(variable, " is ", checker, ". going to ", target))
			
	if $EffectHandler.BUSY:
		await $EffectHandler.NOT_BUSY
	
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
	
	if line["cecilia"]:
		sprite_handler.init_cecilia(line["cecilia"])
	
	if line["speaker"]:
		if line["speaker"] == "[Player":
			character_name.text = Global.data_dict["player_name"]
		else:
			character_name.text = line["speaker"]
		name_frame.show()
	else:
		character_name.text = ""
		name_frame.hide()

	if line["character"] != null && line["sprite"] != null:
		sprite_handler.init_sprite(
			line["character"].split("|"),
			line["sprite"].split("|")
		)
		
	else:
		sprite_handler.clear_sprites()

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
	var choice = current_line["option ids"].split("|")[which]
	current_line["go to"] = choice
	
func choice_pressed():
	for i in $Choice/Buttons.get_children():
		if i.button_pressed:
			Global.data_dict["remembered"].append(i.get_node("Label").text)
			choice.emit(i.get_index())
			return
	for i in $GodChoice.get_children():
		if i.button_pressed:
			Global.data_dict["remembered"].append(i.get_node("Label").text)
			choice.emit(i.get_index())
			return

func _input(event):
	if (event.is_action_pressed("ui_accept") or (event.is_action_pressed("LMB") and settings_dropdown.lmb)) and !settings_dropdown.busy:
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
	if !next.disabled:
		emit_signal("next_pressed")
	else:
		if a.is_running():
			a.pause()
			a.custom_step(current_time)
			emit_signal("next_pressed")

func alternate_text_box(yes: bool):
	if !yes:
		box.texture = NORMAL_DIALOGUE_TEXTURE
		label["theme_override_colors/default_color"] = Color("53431a")
		box.scale = Vector2(1,1)
		box.position = Vector2(104.5, 650)
	else:
		box.texture = GOD_DIALOGUE_TEXTURE
		name_frame.texture = null
		label["theme_override_colors/default_color"] = Color("ffffff")
		box.scale = Vector2(1.5,2.5)
		box.position = Vector2(-256, 320)
