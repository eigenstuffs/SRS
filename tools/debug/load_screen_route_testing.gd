extends Control

var save_dir = "user://villainess_saves/"

const SAVE_BLOCK = preload("res://tools/dialogue/save_block.tscn")

signal exited_load

func init():
	for i in $ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	
	var dir = DirAccess.open(save_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".dat") and file_name.contains("_") and !file_name.contains("meta_data"):
				var file_path = save_dir + file_name
				print("Processing file: " + file_path)
				var file = FileAccess.open(file_path, FileAccess.READ)
				var get_var = file.get_var()
				#print(get_var)
				
				var a = SAVE_BLOCK.instantiate()
				$ScrollContainer/VBoxContainer.add_child(a)
				a.delete_button.visible = false
				a.get_node("Metadata").text = str(
					get_var["player_name"], "\n",
					(get_var["current_scene"].replace(
						"res://tools/dialogue/vn_scripts/Dialogue - ",
						""
					)).replace(".json", "")
				)
				if get_var["saved_date"]:
					a.get_node("SaveDate").text = str(
						"Save created on:\n", get_var["saved_date"].replace("T", " ")
					)
				a.save_path = file_path
				if !get_var["saved_date"]:
					a.modulate.a = 0.5
				a.connect("pressed", button_pressed)
				
				file.close()
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Failed to open directory.")
		
	$VScrollBar.max_value = $ScrollContainer.get_v_scroll_bar().max_value
	$VScrollBar.min_value = $ScrollContainer.get_v_scroll_bar().min_value

func button_pressed():
	print("pressed")
	for i in $ScrollContainer/VBoxContainer.get_children():
		if i.button_pressed:
			i.button_pressed = false
			EffectAnim.MusicPlayer.stop()
			EffectAnim.LoopPlayer.stop()
			Global.load_data(i.save_path)
			EffectAnim.play("FlashWhite")

func _on_texture_button_pressed():
	emit_signal("exited_load")
	print("exiting load")
