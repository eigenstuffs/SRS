class_name SpriteHandler extends Control

@export_node_path("Label") var name_string
@export_node_path("TextureRect") var cecilia_texture
@export_node_path("RichTextLabel") var text
@export_node_path("TextureRect") var name_frame
@export_node_path("Label") var name_frame_text

var focused_char = null
var prior_sprite_list = [""]
var prior_character_list = [""]

const CHARACTER_SPRITE = preload("res://tools/dialogue/character_sprite.tscn")
const CHARACTER_LIST = preload("res://resources/characters/character_list.tres")
const CECILIA = preload("res://resources/characters/cecilia.tres")

func init_sprite(character_list : Array[String], sprite_list : Array[String]):
	if sprite_list == prior_sprite_list and character_list == prior_character_list:
		pass
	else:
		for i in $HBoxContainer.get_children():
			$HBoxContainer.remove_child(i)
			i.queue_free()
		
		if sprite_list.size() == character_list.size():
			prior_character_list = character_list
			prior_sprite_list = sprite_list
			
			var clean_character_list = character_list.duplicate(true)
			for k in character_list.size():
					clean_character_list[k] = character_list[k].replace("-", "")
			print(CHARACTER_LIST.list)
			for i in clean_character_list:
				var current_resource : Character = CHARACTER_LIST.list[0]
				for k in CHARACTER_LIST.list:
					if i == k.name:
						current_resource = k
			
			
			#for i in CHARACTER_LIST.list.size():
				#clean_character_list = character_list.duplicate(true)
				#for k in character_list.size():
					#clean_character_list[k] = character_list[k].replace("-", "")
				#if clean_character_list.has(CHARACTER_LIST.list[i].name):
					#var a = CHARACTER_SPRITE.instantiate()
					#$HBoxContainer.add_child(a)
					#a.name = str(i)
					#var texture : Texture
					#
					### pick the texture
					#
					#for j in CHARACTER_LIST.list[i].textures:
						#if j.resource_path.ends_with(sprite_list[
							#clean_character_list.find(CHARACTER_LIST.list[i].name)
						#] + ".PNG") or j.resource_path.ends_with(sprite_list[
							#clean_character_list.find(CHARACTER_LIST.list[i].name)
						#] + ".png"):
							#texture = j
					#
					#a.texture = texture
				#elif clean_character_list.has():
					#var a = CHARACTER_SPRITE.instantiate()
					#$HBoxContainer.add_child(a)
					#a.name = CHARACTER_LIST.list[i].name
					#a.modulate.a = 0
			## add nulls

				
			for i in $HBoxContainer.get_child_count():
				if character_list[i-1].contains("-"):
					$HBoxContainer.get_child(i-1).modulate = Color("969696")
				$HBoxContainer.get_child(i-1).modulate.a = 0
				var q = create_tween()
				q.tween_property($HBoxContainer.get_child(i-1),
				"modulate:a", 1, 0.2)
						
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
	var clean_sprite = sprite.replace(",", "")
	if sprite:
		get_node(cecilia_texture).modulate.a = 0
		for i in CECILIA.textures:
			if i.resource_path.ends_with(
				clean_sprite + ".PNG"
			) or i.resource_path.ends_with(
				clean_sprite + ".png"
			):
				if sprite.has("-"):
					get_node(cecilia_texture).modulate = Color("969696")
				get_node(cecilia_texture).modulate.a = 0
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

func clear_sprites():
	for i in $HBoxContainer.get_children():
		var a = create_tween()
		a.tween_property(i, "modulate:a", 0, 0.5)
	await get_tree().create_timer(0.5).timeout
	for i in $HBoxContainer.get_children():
		$HBoxContainer.remove_child(i)
		i.queue_free()
	prior_sprite_list = null
