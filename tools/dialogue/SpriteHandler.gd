class_name SpriteHandler extends Control

@export_node_path("Label") var name_string
@export_node_path("TextureRect") var cecilia_texture
@export_node_path("RichTextLabel") var text
@export_node_path("TextureRect") var name_frame
@export_node_path("Label") var name_frame_text

var focused_char = null

const CHARACTER_SPRITE = preload("res://tools/dialogue/character_sprite.tscn")
const CHARACTER_LIST = preload("res://resources/characters/character_list.tres")
const CECILIA = preload("res://resources/characters/cecilia.tres")

func init_sprite(character_list : Array[String], sprite_list : Array[String]):
	print(character_list)
	
	for i in character_list:
		if i.contains("!"):
			focused_char = i.replace("!", "")
			get_node(name_string).text = focused_char
			break
		elif character_list.size() == 1:
			if i.contains("-"):
				get_node(name_string).text = ""
				focused_char = null
			else:
				focused_char = i
				get_node(name_string).text = i
			break
		else:
			var temp = character_list.duplicate(true)
			temp.erase("null")
			temp.erase("null")
			temp.erase("null")
			temp.erase("null")
			if temp.size() == 1:
				focused_char = temp[0]
				get_node(name_string).text = temp[0]
				break
			else:
				focused_char = null
			
	for i in character_list.size():
		character_list[i] = character_list[i].replace("!","")
		character_list[i] = character_list[i].replace("-","")
		
	if get_node(name_string).text == "" or get_node(name_string).text == null:
		get_node(name_frame).hide()
	else:
		get_node(name_frame).show()
	
	for i in $HBoxContainer.get_children():
		$HBoxContainer.remove_child(i)
		i.queue_free()
	
	if sprite_list.size() == character_list.size():
		for i : Character in CHARACTER_LIST.list:
			if character_list.has(i.name):
				print(i.name)
				var a = CHARACTER_SPRITE.instantiate()
				$HBoxContainer.add_child(a)
				var texture : Texture
				
				## pick the texture
				
				for j in i.textures:
					if j.resource_path.ends_with(sprite_list[
						character_list.find(i.name)
					] + ".PNG"):
						texture = j
				
				a.texture = texture
			
		## add nulls
		
		for i in character_list.size():
			if character_list[i] == "null":
				var a = CHARACTER_SPRITE.instantiate()
				$HBoxContainer.add_child(a)
				$HBoxContainer.move_child(
					a, i
				)
				a.modulate.a = 0
		if focused_char: print('focused: ' + focused_char)
		for i in $HBoxContainer.get_child_count():
			if focused_char != "" and focused_char != null:
				if focused_char != character_list[i-1]:
					$HBoxContainer.get_child(i-1).modulate = Color("969696")
			if character_list[i-1] != "null":
				$HBoxContainer.get_child(i-1).modulate.a = 0
				var q = create_tween()
				q.tween_property($HBoxContainer.get_child(i-1),
				"modulate:a", 1, 0.2)
			else:
				$HBoxContainer.get_child(i-1).modulate.a = 0
					
		match $HBoxContainer.get_child_count():
			1:
				pass
			2:
				$HBoxContainer["theme_override_constants/separation"] = -160
			3:
				$HBoxContainer["theme_override_constants/separation"] = -240
			4:
				$HBoxContainer["theme_override_constants/separation"] = -320
			5:
				$HBoxContainer["theme_override_constants/separation"] = -400
	
func init_cecilia(sprite):
	if sprite:
		get_node(cecilia_texture).modulate.a = 0
		for i in CECILIA.textures:
			if i.resource_path.ends_with(
				sprite + ".PNG"
			):
				var a = create_tween()
				a.tween_property(
					get_node(cecilia_texture),
					"modulate:a",
					1,
					0.2
				)
				get_node(cecilia_texture).texture = i
				get_node(text).position.x = 432
				get_node(text).size.x = 1216
				get_node(name_frame).position.x = 432
				get_node(name_frame_text).position.x = 432+40
				break
	else:
			get_node(text).position.x = 256
			get_node(text).size.x = 1364
			get_node(name_frame).position.x = 360
			get_node(name_frame_text).position.x = 400
