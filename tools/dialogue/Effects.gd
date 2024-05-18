extends Node

signal done

const PLAYER_NAME = preload("res://tools/player_name/player_name.tscn")
const SERAPHINA_NAME = preload("res://tools/player_name/seraphina_name.tscn")

const SFX_DOOR_KNOCK = preload("res://assets/sfx/person_knocking_1.mp3")
const SFX_GLASS_BREAK = preload("res://assets/sfx/breaking_glass_1.wav")
const SFX_PAGE_FLIP = preload("res://assets/sfx/paper_1.ogg")
const SFX_DOOR_OPEN_CLOSE = preload("res://assets/sfx/door_2.mp3")
const SFX_CREEPY_STINGER = preload("res://assets/sfx/creepy_stinger.wav")
const SFX_REVERSE_CYMBAL_OMNIOUS = preload("res://assets/sfx/swell_2.mp3")
const SFX_BOOM = preload("res://assets/sfx/boom_1.mp3")
const SFX_CHURCH_BELL = preload("res://assets/sfx/church_bell_1.mp3")
const SFX_IMPACT_1 = preload("res://assets/sfx/impact_!.ogg")
const SFX_IMPACT_2 = preload("res://assets/sfx/impact_2.ogg")
const SFX_SCHOOL_BELL = preload("res://assets/sfx/school_bell_1.ogg")
const SFX_BATTLE_START = preload("res://assets/sfx/battle_start_1.ogg")
const SFX_RAIN_LOOPING = preload("res://assets/sfx/rain_loop_1.ogg")
const SFX_SWITCH_CLICK = preload("res://assets/sfx/switch_1.ogg")
const SFX_AMBIANCE_ECHOES = preload("res://assets/sfx/ambiance_1.mp3")
const SFX_AMBIANCE_HEAVY = preload("res://assets/sfx/ambiance_2.wav")
const SFX_IMPACT_3 = preload("res://assets/sfx/impact_3.mp3")
const SFX_MELODY_SAVE = preload("res://assets/sfx/melody_1.wav")
const SFX_RATTLING_DOOR = preload("res://assets/sfx/door_1.mp3")
const SFX_REALIZATION = preload("res://assets/sfx/textbox_1.mp3")
const SFX_WHOOSH_FOAM = preload("res://assets/sfx/whoosh_1.wav")
const SFX_HAPPY = preload("res://assets/sfx/textbox_2.mp3")
const SFX_EPIPHANY = preload("res://assets/sfx/textbook_3.mp3")
const SFX_HEARTBEAT_LOOPING = preload("res://assets/sfx/heartbeat_loop_1.ogg")
const SFX_BELLS_MYSTERY = preload("res://assets/sfx/bells_1.wav")
const SFX_BELLS_COUNTDOWN = preload("res://assets/sfx/bells_2.wav")
const SFX_BELLS_MAGIC_CHIME = preload("res://assets/sfx/bells_3.wav")
const SFX_REVERSE_CYMBAL = preload("res://assets/sfx/swell_1.mp3")
const SFX_PRINTER_ERROR = preload("res://assets/sfx/error_1.mp3")
const SFX_CINEMATIC_GLITCH = preload("res://assets/sfx/error_2.mp3")
const SFX_STATIC_CRASH = preload("res://assets/sfx/error_3.mp3")
const SFX_URBAN_RAIN_LOOPING = preload("res://assets/sfx/rain_loop_2.mp3")
const SFX_GAME_CHIME = preload("res://assets/sfx/game_alert_1.mp3")
const SFX_GAME_SELECT = preload("res://assets/sfx/game_alert_2.mp3")
const SFX_FOOTSTEP_RUNNING_GRAVEL = preload("res://assets/sfx/footsteps_running_1.mp3")
const SFX_REALIZATION_BELLS = preload("res://assets/sfx/textbox_4.ogg")

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
	vn.connect("sfx_page_flip", play_sfx.bind(SFX_PAGE_FLIP))
	vn.connect("sfx_door_open_close", play_sfx.bind(SFX_DOOR_OPEN_CLOSE))
	vn.connect("sfx_impact_3", play_sfx.bind(SFX_IMPACT_3))
	vn.connect("sfx_creepy_stinger", play_sfx.bind(SFX_CREEPY_STINGER)) 
	vn.connect("sfx_reverse_cymbal_ominous", play_sfx.bind(SFX_REVERSE_CYMBAL_OMNIOUS))
	vn.connect("sfx_boom", play_sfx.bind(SFX_BOOM))
	vn.connect("sfx_church_bell", play_sfx.bind(SFX_CHURCH_BELL))
	vn.connect("sfx_impact_1", play_sfx.bind(SFX_IMPACT_1))
	vn.connect("sfx_impact_2", play_sfx.bind(SFX_IMPACT_2))
	vn.connect("sfx_school_bell", play_sfx.bind(SFX_SCHOOL_BELL))
	vn.connect("sfx_battle_start", play_sfx.bind(SFX_BATTLE_START))
	vn.connect("sfx_rain_looping", play_sfx_looping.bind(SFX_RAIN_LOOPING))
	vn.connect("sfx_switch_click", play_sfx.bind(SFX_SWITCH_CLICK))
	vn.connect("sfx_ambiance_echoes", play_sfx_looping.bind(SFX_AMBIANCE_ECHOES))
	vn.connect("sfx_ambiance_heavy", play_sfx_looping.bind(SFX_AMBIANCE_HEAVY))
	vn.connect("sfx_melody_save", play_sfx.bind(SFX_MELODY_SAVE))
	vn.connect("sfx_rattling_door", play_sfx.bind(SFX_RATTLING_DOOR))
	vn.connect("sfx_realization", play_sfx.bind(SFX_REALIZATION))
	vn.connect("sfx_whoosh_foam", play_sfx.bind(SFX_WHOOSH_FOAM))
	vn.connect("sfx_happy", play_sfx.bind(SFX_HAPPY))
	vn.connect("sfx_epiphany", play_sfx.bind(SFX_EPIPHANY))
	vn.connect("sfx_heartbeat_looping", play_sfx_looping.bind(SFX_HEARTBEAT_LOOPING))
	vn.connect("sfx_bells_mystery", play_sfx.bind(SFX_BELLS_MYSTERY))
	vn.connect("sfx_bells_countdown", play_sfx.bind(SFX_BELLS_COUNTDOWN))
	vn.connect("sfx_bells_magic_chime", play_sfx.bind(SFX_BELLS_MAGIC_CHIME))
	vn.connect("sfx_reverse_cymbal", play_sfx.bind(SFX_REVERSE_CYMBAL))
	vn.connect("sfx_printer_error", play_sfx.bind(SFX_PRINTER_ERROR))
	vn.connect("sfx_cinematic_glitch", play_sfx.bind(SFX_CINEMATIC_GLITCH))
	vn.connect("sfx_static_crash", play_sfx.bind(SFX_STATIC_CRASH))
	vn.connect("sfx_urban_rain_looping", play_sfx_looping.bind(SFX_URBAN_RAIN_LOOPING))
	vn.connect("sfx_game_chime", play_sfx.bind(SFX_GAME_CHIME))
	vn.connect("sfx_game_select", play_sfx.bind(SFX_GAME_SELECT))
	vn.connect("sfx_footstep_running_gravel", play_sfx.bind(SFX_FOOTSTEP_RUNNING_GRAVEL))
	vn.connect("sfx_realization_bells", play_sfx.bind(SFX_REALIZATION_BELLS))
	
	vn.connect("stop_sfx", stop_sfx)
	vn.connect("stop_looping_sfx", stop_sfx_looping)
	
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

func stop_sfx():
	EffectAnim.SfxPlayer.stop()
	
func play_sfx_looping(effect_name):
	EffectAnim.LoopPlayer.stream = effect_name
	EffectAnim.LoopPlayer.play()
	
func stop_sfx_looping():
	EffectAnim.LoopPlayer.stop()
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
