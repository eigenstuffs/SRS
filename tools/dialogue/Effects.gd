extends Node

const PLAYER_NAME = preload("res://tools/player_name/player_name.tscn")

@onready var audio = $Music
@onready var sfx = $SFX

var song

signal done

func _ready():
	var vn : VisualNovelDialogue = get_parent()
	
	vn.connect("fade_black", fade_black)
	vn.connect("fade_red", fade_red)
	vn.connect("music_ambience", music_ambience)
	vn.connect("music_chiptune", music_chiptune)
	vn.connect("music_bgm1", music_bgm1)
	vn.connect("stop_music", stop_music)
	vn.connect("sfx_truck", sfx_truck)
	vn.connect("sfx_screams", sfx_screams)
	vn.connect("name_player", player_name_screen)
	
#signal start_music
#signal boost_stats
#
#signal music_ambience
#signal music_chiptune
#signal music_bgm1
#
#signal stop_music
#
#signal sfx_truck
#signal sfx_screams
#
#signal fade_black
#signal fade_red
#
#signal cg_death
#signal cg_gamestart
#signal cg_god
#
#signal name_player
	#
func fade_black():
	EffectRegistry.start_effect(self, "ColorFade", [$MultiPassShaderRect.material])
	
func fade_red():
	EffectRegistry.start_effect(self, "ColorFade", [$MultiPassShaderRect.material, Color.TRANSPARENT, Color(176,11,30)])
	await get_tree().create_timer(2).timeout
	EffectRegistry.start_effect(self, "ColorFade", [$MultiPassShaderRect.material, Color(176,11,30), Color.TRANSPARENT])
	
func music_ambience():
	print("music ambience")
	audio.stream = song
	audio.play()
	
func music_chiptune():
	print("music chiptune")
	audio.stream = song
	audio.play()
	
func music_bgm1():
	audio.stream = song
	audio.play()
	
func stop_music():
	audio.stop()
	
func sfx_truck():
	sfx.stream = song
	sfx.play()
	
func sfx_screams():
	sfx.stream = song
	sfx.play()
	
func player_name_screen():
	var a = PLAYER_NAME.instantiate()
	get_tree().paused = true
	add_child(a)
	await a.done
	get_tree().paused = false
	emit_signal("done")
	
	
