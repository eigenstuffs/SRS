extends Control

class_name EffectTestScene

signal start_music
signal boost_stats

signal music_ambience
signal music_chiptune
signal music_bgm1
signal music_bgm2

signal stop_music

signal sfx_truck
signal sfx_screams
signal sfx_door_knock
signal sfx_glass_break
signal sfx_page_flip
signal sfx_door_open
signal sfx_door_close
signal sfx_creepy_stinger
signal sfx_whoosh
signal sfx_boom

signal fade_black
signal fade_blacktowhite
signal fade_blacktored

signal fade_red
signal fade_redtowhite
signal fade_redtoblack

signal fade_white
signal fade_whitetored
signal fade_whitetoblack

signal fade_trans

signal cg_sky
signal cg_black
signal cg_death
signal cg_gamestart
signal cg_god
signal cg_room
signal cg_dining

signal add_OPP
signal add_OOC


func _on_option_button_item_selected(index):
	match index:
		0: emit_signal("sfx_door_knock")
		1: emit_signal("sfx_glass_break")
		2: emit_signal("sfx_page_flip")
		3: emit_signal("sfx_door_open")
		4: emit_signal("sfx_door_close")
		5: emit_signal("sfx_creepy_stinger")
		6: emit_signal("sfx_whoosh")
		7: emit_signal("sfx_boom")
