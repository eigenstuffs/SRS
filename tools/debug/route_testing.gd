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
	for item in $OtherStats.get_children():
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
	$OtherStats/OOC.text = "OOC: " + str(Global.data_dict["ooc"])
	$OtherStats/OPP.text = "OPP: " + str(Global.data_dict["opp"])
	$OtherStats/PlayerName.text = "Player Name: " + str(Global.data_dict["player_name"])
	$OtherStats/SeraphinaName.text = "Seraphina Name: " + str(Global.data_dict["seraphina_name"])
	$OtherStats/Type.text = "Type: " + str(Global.data_dict["type"])
	$OtherStats/OG_RO.text = "OG_RO: " + str(Global.data_dict["og_ro"])
	$OtherStats/CurrentScene.text = "Current Scene: " + (Global.data_dict["current_scene"].replace("res://tools/dialogue/vn_scripts/Dialogue - ", "")).replace(".json", "")
	$OtherStats/SavedDate.text = "Saved Date: " + str(Global.data_dict["saved_date"])

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
