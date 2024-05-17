extends Node

signal done

const PLAYER_NAME = preload("res://tools/player_name/player_name.tscn")
const SERAPHINA_NAME = preload("res://tools/player_name/seraphina_name.tscn")

const SFX_DOOR_KNOCK = preload("res://assets/sfx/person_knocking_1.mp3")
const SFX_GLASS_BREAK = preload("res://assets/sfx/breaking_glass_1.wav")
const SFX_RAIN_LOOPING = preload("res://assets/sfx/rain_loop_1.ogg")
const SFX_SWITCH_CLICK = preload("res://assets/sfx/switch_1.ogg")
const SFX_AMBIANCE_ECHOES = preload("res://assets/sfx/ambiance_1.mp3")

const SKY_CG = preload("res://assets/image0-2.jpg")
const BLACK_CG = preload("res://assets/cgs/New Project.png")
const GOD_CG = preload("res://assets/cgs/IMG_5160.png")
const ROOM_CG = preload("res://assets/cgs/IMG_0552.png")
const DINING_CG = preload("res://assets/cgs/dininghall.png")

@onready var audio = $Music
@onready var sfx = $SFX

var song
var last_fade = ""

func _ready():
	match Global.return_current_text():
		Global.ACT1_CHAPTER1_PART1:
			cg_sky()
			var a = create_tween()
			a.tween_property($SFX, "volume_db", -10, 3)
			$SFX.play()
		Global.ACT1_CHAPTER1_PART2:
			cg_room()
			var a = create_tween()
			a.tween_property($SFX, "volume_db", -10, 3)
			$SFX.play()
		Global.ACT1_CHAPTER2_PART1:
			cg_room()
			var a = create_tween()
			a.tween_property($Music, "volume_db", -15, 3)
			$Music.play()
		Global.ACT1_CHAPTER2_PART2:
			cg_dining()
			var a = create_tween()
			a.tween_property($Music, "volume_db", -15, 3)
			$Music.play()
	
	#to be changed back to VisualNovelDialogue
	#var vn : VisualNovelDialogue = get_parent()
	var vn : EffectTestScene = get_parent()
	
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
	vn.connect("music_bgm2", music_bgm1)
	vn.connect("stop_music", stop_music)
	
	vn.connect("sfx_door_knock", play_sfx.bind(SFX_DOOR_KNOCK))
	vn.connect("sfx_glass_break", play_sfx.bind(SFX_GLASS_BREAK))
	vn.connect("sfx_page_flip", play_sfx.bind("SfxPageFlip"))
	vn.connect("sfx_door_open", play_sfx.bind("SfxDoorOpen"))
	vn.connect("sfx_door_close", play_sfx.bind("SfxDoorClose"))
	vn.connect("sfx_creepy_stinger", play_sfx.bind("SfxCreepyStinger")) 
	vn.connect("sfx_reverse_cymbal_ominous", play_sfx.bind("SfxReverseCymbalOminous"))
	vn.connect("sfx_boom", play_sfx.bind("SfxBoom"))
	vn.connect("sfx_church_bell", play_sfx.bind("SfxChurchBell"))
	vn.connect("sfx_impact_1", play_sfx.bind("SfxImpact1"))
	vn.connect("sfx_impact_2", play_sfx.bind("SfxImpact2"))
	vn.connect("sfx_school_bell", play_sfx.bind("SfxSchoolBell"))
	vn.connect("sfx_battle_start", play_sfx.bind("SfxBattleStart"))
	vn.connect("sfx_rain_looping", play_sfx_looping.bind(SFX_RAIN_LOOPING))
	vn.connect("sfx_switch_click", play_sfx.bind(SFX_SWITCH_CLICK))
	vn.connect("sfx_ambiance_echoes", play_sfx_looping.bind(SFX_AMBIANCE_ECHOES))
		
	vn.connect("cg_sky", cg_sky)
	vn.connect("cg_god", cg_god)
	vn.connect("cg_black", cg_black)
	vn.connect("cg_dining", cg_dining)
	
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

## MUSIC
func music_ambience():
	$SFX.play()
	
func music_chiptune():
	pass
	
func music_bgm1():
	pass
	
func stop_music():
	audio.stop()
	
## SFX

func play_sfx(effect_name):
	EffectAnim.SfxPlayer.stream = effect_name
	EffectAnim.SfxPlayer.play()
	
func play_sfx_looping(effect_name):
	EffectAnim.LoopPlayer.stream = effect_name
	EffectAnim.LoopPlayer.play()
	
## CG
func cg_sky():
	$CG.texture = SKY_CG
	$CG.show()
	
func cg_black():
	$CG.texture = BLACK_CG
	$CG.show()
	
func cg_room():
	$CG.texture = ROOM_CG
	$CG.show()
	
func cg_dining():
	$CG.texture = DINING_CG
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
