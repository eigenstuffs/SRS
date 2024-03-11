extends Node

signal done

const PLAYER_NAME = preload("res://tools/player_name/player_name.tscn")
const SERAPHINA_NAME = preload("res://tools/player_name/seraphina_name.tscn")

const SKY_CG = preload("res://assets/image0-2.jpg")
const BLACK_CG = preload("res://assets/cgs/New Project.png")
const GOD_CG = preload("res://assets/cgs/IMG_5160.png")
const ROOM_CG = preload("res://assets/cgs/IMG_0552.png")

@onready var audio = $Music
@onready var sfx = $SFX

var song
var last_fade = ""

func _ready():
	match Global.return_current_text():
		Global.ACT1_CHAPTER1_PART1:
			cg_sky()
		Global.ACT1_CHAPTER1_PART2:
			cg_room()
		Global.ACT1_CHAPTER2_PART1:
			cg_room()
		_:
			cg_black()
	
	var vn : VisualNovelDialogue = get_parent()
	
	vn.connect("fade_black", fade_black)
	vn.connect("fade_blacktored", fade_blacktored)
	vn.connect("fade_blacktowhite", fade_blacktowhite)
	vn.connect("fade_red", fade_red)
	vn.connect("fade_redtowhite", fade_redtowhite)
	vn.connect("fade_redtoblack", fade_redtoblack)
	vn.connect("fade_white", fade_white)
	vn.connect("fade_whitetored", fade_whitetored)
	vn.connect("fade_whitetoblack", fade_whitetoblack)
	
	vn.connect("fade_trans", fade_trans)
	
	vn.connect("music_ambience", music_ambience)
	vn.connect("music_chiptune", music_chiptune)
	vn.connect("music_bgm1", music_bgm1)
	vn.connect("stop_music", stop_music)
	vn.connect("sfx_truck", sfx_truck)
	vn.connect("sfx_screams", sfx_screams)
		
	vn.connect("cg_sky", cg_sky)
	vn.connect("cg_god", cg_god)
	vn.connect("cg_black", cg_black)
	
	vn.connect("add_OOC", add_OOC)
	vn.connect("add_OPP", add_OPP)
	
	
	
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
	EffectAnim.play("FadeBlack")
	last_fade = "black"
	await EffectAnim.animation_finished
	
func fade_blacktowhite():
	EffectAnim.play("FadeBlackToWhite")
	last_fade = "white"
	await EffectAnim.animation_finished
	
func fade_blacktored():
	EffectAnim.play("FadeBlackToRed")
	last_fade = "red"
	await EffectAnim.animation_finished
	
func fade_red():
	EffectAnim.play("FadeRed")
	last_fade = "red"
	await EffectAnim.animation_finished
	
func fade_redtowhite():
	EffectAnim.play("FadeRedToWhite")
	last_fade = "white"
	await EffectAnim.animation_finished
	
func fade_redtoblack():
	EffectAnim.play("FadeRedToBlack")
	last_fade = "black"
	await EffectAnim.animation_finished
	
func fade_white():
	EffectAnim.play("FadeWhite")
	last_fade = "white"
	await EffectAnim.animation_finished
	
func fade_whitetoblack():
	EffectAnim.play("FadeWhiteToBlack")
	last_fade = "black"
	await EffectAnim.animation_finished

func fade_whitetored():
	EffectAnim.play("FadeWhiteToRed")
	last_fade = "red"
	await EffectAnim.animation_finished
	
func fade_trans():
	match last_fade:
		"white":
			EffectAnim.play_backwards("FadeWhite")
		"black":
			EffectAnim.play_backwards("FadeBlack")
		"red":
			EffectAnim.play_backwards("FadeRed")
		_:
			print("no last fade")
	await EffectAnim.animation_finished

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
	
func cg_sky():
	$CG.texture = SKY_CG
	$CG.show()
	
func cg_black():
	$CG.texture = BLACK_CG
	$CG.show()
	
func cg_room():
	$CG.texture = ROOM_CG
	$CG.show()
	
func cg_god():
	$AnimationPlayer.play("God_BG")
	var a = create_tween()
	a.tween_property($AnimationPlayer/TextureRect,
	"modulate:a", 1, 2)
	await a.finished
	a = create_tween()
	a.tween_property($GodCG, "modulate:a", 1, 1).set_trans(Tween.TRANS_EXPO)

func player_name_screen():
	var a = PLAYER_NAME.instantiate()
	$Priority.add_child(a)
	await a.done
	done.emit()
	
func seraphina_name_screen():
	var a = SERAPHINA_NAME.instantiate()
	$Priority.add_child(a)
	await a.done
	done.emit()
	
func add_OOC():
	Global.ooc += 1
	
func add_OPP():
	Global.opp += 1
