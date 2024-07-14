extends Control

const SAVE_SCREEN = preload("res://tools/dialogue/save_screen.tscn")
const LOAD_SCREEN = preload("res://tools/debug/load_screen_route_testing.tscn")
var ls1 : LabelSettings
var ls2 : LabelSettings

func _ready():
	ls1 = LabelSettings.new()
	ls1.font_color = Color.BLACK
	ls2 = LabelSettings.new()
	ls2.font_color = Color.BLACK
	ls2.font_size = 32
	for item in $OtherStatusDisplay/OtherStats.get_children():
		item.label_settings = ls2

func display_data():
	#clear data first
	for item in $RememberedDisplay/VBoxContainer.get_children():
		item.queue_free()
	#add all remembered
	for item in Global.data_dict["remembered"]:
		var label = Label.new()
		label.text = str(item)
		label.label_settings = ls1
		$RememberedDisplay/VBoxContainer.add_child(label)
	#display other stats
	$OtherStatusDisplay/OtherStats/ooc.text = "OOC: " + str(Global.data_dict["ooc"])
	$OtherStatusDisplay/OtherStats/opp.text = "OPP: " + str(Global.data_dict["opp"])
	$OtherStatusDisplay/OtherStats/player_name.text = "Player Name: " + str(Global.data_dict["player_name"])
	$OtherStatusDisplay/OtherStats/seraphina_name.text = "Seraphina Name: " + str(Global.data_dict["seraphina_name"])
	$OtherStatusDisplay/OtherStats/type.text = "Type: " + str(Global.data_dict["type"])
	$OtherStatusDisplay/OtherStats/og_ro.text = "OG_RO: " + str(Global.data_dict["og_ro"])
	$OtherStatusDisplay/OtherStats/current_scene.text = "Current Scene: " + (Global.data_dict["current_scene"].replace("res://tools/dialogue/vn_scripts/Dialogue - ", "")).replace(".json", "")
	$OtherStatusDisplay/OtherStats/current_line.text = "Current Line: " + str(Global.data_dict["current_line"])
	$OtherStatusDisplay/OtherStats/saved_date.text = "Saved Date: " + str(Global.data_dict["saved_date"])
	$OtherStatusDisplay/OtherStats/god_bg_active.text = "God BG Active: " + str(Global.data_dict["god_bg_active"])
	$OtherStatusDisplay/OtherStats/last_god.text = "Last God: " + str(Global.data_dict["last_god"])
	$OtherStatusDisplay/OtherStats/active_fade.text = "Active Fade: " + str(Global.data_dict["active_fade"])
	$OtherStatusDisplay/OtherStats/active_cg.text = "Active CG: " + str(Global.data_dict["active_cg"])
	$OtherStatusDisplay/OtherStats/active_music.text = "Active Music: " + str(Global.data_dict["active_music"])
	$OtherStatusDisplay/OtherStats/active_looping.text = "Active Looping: " + str(Global.data_dict["active_looping"])

func _on_save_button_pressed():
	var a = SAVE_SCREEN.instantiate()
	add_child(a)
	a.init()
	await a.exited_save
	a.queue_free()

func _on_load_button_pressed():
	var a = LOAD_SCREEN.instantiate()
	add_child(a)
	a.init()
	await a.exited_load
	a.queue_free()
	display_data()

func _on_add_tag_text_submitted(new_text):
	if new_text != "":
		var new_tag = new_text
		$AddTag.text = ""
		Global.data_dict["remembered"].append(new_tag)
		display_data()
		$StatusMessage.text = new_tag + " has been added."

func _on_delete_tag_text_submitted(new_text):
	if new_text != "":
		var tbm_tag = new_text
		$DeleteTag.text = ""
		if Global.data_dict["remembered"].has(tbm_tag):
			Global.data_dict["remembered"].erase(tbm_tag)
			display_data()
			$StatusMessage.text = tbm_tag + " has been removed."
		else: $StatusMessage.text = "Tag " + tbm_tag + " does not exist."

func _on_modify_input_text_submitted(new_text):
	if new_text != "":
		var value = new_text
		$ModifyInput.text = ""
		var targetStat : String = $OtherStatusDisplay/OtherStats.find_child($TargetStat.get_item_text($TargetStat.selected)).name
		match targetStat:
			"ooc", "opp", "current_line":
				Global.data_dict[targetStat] = int(value)
			"god_bg_active":
				Global.data_dict[targetStat] = bool(value)
			_:
				if value == "null":
					Global.data_dict[targetStat] = null
				else: Global.data_dict[targetStat] = str(value)
		display_data()
		$StatusMessage.text = str(targetStat) + " has been set to " + str(value)
