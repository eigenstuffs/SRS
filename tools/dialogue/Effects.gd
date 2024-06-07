extends Node

signal done

var BUSY : bool = false

signal NOT_BUSY

const PLAYER_NAME = preload("res://tools/player_name/player_name.tscn")
const SERAPHINA_NAME = preload("res://tools/player_name/seraphina_name.tscn")

const SFX_DOOR_KNOCK = preload("res://assets/sfx/person_knocking_1.mp3")
const SFX_GLASS_BREAK = preload("res://assets/sfx/breaking_glass_1.wav")
const SFX_PAGE_FLIP = preload("res://assets/sfx/paper_1.ogg")
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
const SFX_DOOR_1 = preload("res://assets/sfx/door_1.mp3")
const SFX_INQUISITIVE = preload("res://assets/sfx/textbox_1.mp3")
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
const SFX_REALIZATION = preload("res://assets/sfx/textbox_4.ogg")

const SFX_HEELS_WALKING_METAL = preload("res://assets/sfx/heels_walking_metal_1.mp3")
const SFX_HEELS_WALKING_TILE = preload("res://assets/sfx/heels_walking_tile_1.mp3")
const SFX_HEELS_WALKING_WOOD_EXT = preload("res://assets/sfx/heels_walking_wood_1.mp3")
const SFX_HEELS_WALKING_WOOD_INT = preload("res://assets/sfx/heels_walking_wood_2.mp3")
const SFX_BLANKET_1 = preload("res://assets/sfx/blanket_1.mp3")
const SFX_BLANKET_2 = preload("res://assets/sfx/blanket_2.mp3")
const SFX_CARCRASH = preload("res://assets/sfx/carcrash_1.mp3")
const SFX_CHAIR_SCOOT_WOOD = preload("res://assets/sfx/chair_scoot_wood_1.mp3")
const SFX_CURTAINS_HEAVY_1 = preload("res://assets/sfx/curtains_1.mp3")
const SFX_CUTLERY_1 = preload("res://assets/sfx/cutlery_1.mp3")
const SFX_FABRIC_1 = preload("res://assets/sfx/fabric_1.mp3")
const SFX_TRUCK_HORN = preload("res://assets/sfx/semitruckhorn_1.mp3")
const SFX_WARDROBE_1 = preload("res://assets/sfx/wardrobe_1.mp3")
const SFX_DRAWER_1 = preload("res://assets/sfx/drawer_1.mp3")
const SFX_DOOR_2 = preload("res://assets/sfx/door_2.mp3")
const SFX_CUTLERY_2 = preload("res://assets/sfx/cutlery_2.mp3")
const SFX_BELLS_HIGH = preload("res://assets/sfx/bells_4.mp3")
const SFX_BELLS_LOW = preload("res://assets/sfx/bells_5.mp3")
const SFX_BELLS_JINGLE = preload("res://assets/sfx/bells_6.mp3")
const SFX_OMINOUS_LINGER = preload("res://assets/sfx/chime_ominous_1.mp3")
const SFX_OMINOUS_QUIET = preload("res://assets/sfx/chime_ominous_2.mp3")
const SFX_OMINOUS_MYSTERY = preload("res://assets/sfx/chime_ominous_3.mp3")
const SFX_OMINOUS_BUZZ = preload("res://assets/sfx/chime_ominous_4.mp3")
const SFX_DARK_VIBRATE = preload("res://assets/sfx/dark_swell_1.mp3")
const SFX_DARK_WASH = preload("res://assets/sfx/dark_swell_2.mp3")
const SFX_OMINOUS_FUNKY = preload("res://assets/sfx/chime_ominous_5.mp3")
const SFX_OMINOUS_HIGH = preload("res://assets/sfx/chime_ominous_6.mp3")
const SFX_AMBIANCE_SCARYWIND = preload("res://assets/sfx/ambiance_3.mp3")
const SFX_AMBIANCE_BLIZZARD = preload("res://assets/sfx/ambiance_4.mp3")
const SFX_AMBIANCE_PEOPLE_1 = preload("res://assets/sfx/ambiance_people_1.mp3")
const SFX_AMBIANCE_PEOPLE_2 = preload("res://assets/sfx/ambiance_people_2.mp3")
const SFX_AMBIANCE_MORNINGBIRDS = preload("res://assets/sfx/ambiance_5.wav")
const SFX_TWINKLING_FAIRY = preload("res://assets/sfx/twinkling_1.mp3")
const SFX_TWINKLING_CHIME = preload("res://assets/sfx/twinkling_2.mp3")
const SFX_AMBIANCE_FOUNTAIN = preload("res://assets/sfx/ambiance_water_1.mp3")
const SFX_FOOTSTEP_WALKING_SNOW = preload("res://assets/sfx/footsteps_walking_snow.mp3")
const SFX_AMBIANCE_CARRIAGE_1 = preload("res://assets/sfx/ambiance_6.mp3")
const SFX_WINE_GLASSES = preload("res://assets/sfx/larger-wine-glass-37877.mp3")
const SFX_GLASS_CRASH = preload("res://assets/sfx/breaking_glass_2.mp3")
const SFX_COIN_FLIP = preload("res://assets/sfx/coin_1.mp3")
const SFX_JOURNAL_WRITING = preload("res://assets/sfx/Journal writing.mp3")
const SFX_HEELS_RUNNING_WOOD_EXT = preload("res://assets/sfx/heels_running_wood_1.mp3")
const SFX_HORROR_SUSPENSE = preload("res://assets/sfx/suspense_strings_001wav-14805.mp3")
const SFX_GLASS_HIT = preload("res://assets/sfx/glass-hit-192119.mp3")
const SFX_SOFT_WIND = preload("res://assets/sfx/wind-1-44149.mp3")

const MUSIC_SOMBER_DEATH = preload("res://assets/music/Villianess Reborn Somber Death Theme Accepting Fate.mp3")
const MUSIC_MORE_INTENSE = preload("res://assets/music/Villianess Reborn A Little Faster More Intense Theme.mp3")
const MUSIC_MYSTERIOUS = preload("res://assets/music/Villianess Reborn Mysterious BGM.mp3")
const MUSIC_FIRST_STAGE = preload("res://assets/music/Villianess_Reborn_Minigame_Music_First_Stage.mp3")
const MUSIC_TEA_TIME = preload("res://assets/music/Villianess Reborn Tea Time Minigame.mp3")
const MUSIC_SOCIAL_WARFARE = preload("res://assets/music/Villianess Reborn Battle Social Warfare Music 1.mp3")
const MUSIC_CHURCH = preload("res://assets/music/Villianess Reborn Church.mp3")
const MUSIC_CECILIA = preload("res://assets/music/Villainess_Reborn_Cecilias_Theme_Numero_Dos.mp3")
const MUSIC_CHURCH_WELCOMING = preload("res://assets/music/Villianess Reborn Church (Welcoming).mp3")
const MUSIC_FOREST_2 = preload("res://assets/music/Villianess Reborn Forest Theme 2.mp3")
const MUSIC_TOWN = preload("res://assets/music/Villianess Reborn Town Theme.mp3")
const MUSIC_BALLROOM = preload("res://assets/music/Villianess Reborn Ballroom.mp3")
const MUSIC_GOD = preload("res://assets/music/Villianess Reborn God Theme.mp3")
const MUSIC_GOD_CALM = preload("res://assets/music/Villianess_Reborn_Calm_God_Theme.mp3")
const MUSIC_SLICEOFLIFE = preload("res://assets/music/Villianess Reborn Peppy Isekai Filler Episode Type Beat.mp3")

const SKY_CG = preload("res://assets/cgs/image0-2.jpg")
const BLACK_CG = preload("res://assets/cgs/New Project.png")
const GOD_CG = preload("res://assets/cgs/IMG_5160.png")
const ROOM_CG = preload("res://assets/cgs/cecilias room.png")
const BLUR_ROOM_CG = preload("res://assets/cgs/IMG_0552.png")
const DINING_CG = preload("res://assets/cgs/dininghall.png")
const DEAD_SNOW_CG = preload("res://assets/cgs/dead_snow.png")
const CECILIA_FOUNTAIN = preload("res://assets/cgs/Cecelia-fountain.png")
const EMPTY_FOUNTAIN = preload("res://assets/cgs/emtpy_fountain.png")
const CG_WINTER = preload("res://assets/cgs/cg_winter.png")
const CG_WHITE = preload("res://assets/cgs/cg_white.png")

const CG_DAY = preload("res://assets/cgs/bg_day_sky.png")
const CG_NIGHT = preload("res://assets/cgs/bg_night_sky.png")
const CG_EVENING = preload("res://assets/cgs/bg_sunset_sky.png")
const CG_BALLROOM = preload("res://assets/cgs/ballroom bg.png")
const CG_TOWN = preload("res://assets/cgs/town bg.png")
const CG_LIBRARY = preload("res://assets/library/Library_BG.png")

const OVERLAY_BLOOD_SPLATTER = preload("res://assets/vn/overlay/overlay_blood_splatter.png")

@onready var anim_god : AnimationPlayer = $AnimGod
@onready var anim_god_bg : AnimationPlayer = $AnimGod/AnimGodBG
@onready var overlay : TextureRect = $Overlay
@export_node_path("Control") var text_box

var song
var last_fade = ""

func init():
	match get_parent().text:
		Global.ACT1_CHAPTER1_SCENE1:
			cg_static(BLACK_CG)
			print("worked")
		Global.ACT1_CHAPTER1_SCENE2:
			cg_static(CG_WINTER)
		Global.ACT1_CHAPTER1_SCENE3:
			cg_static(BLACK_CG)
		Global.ACT1_CHAPTER2_SCENE1:
			cg_static(BLUR_ROOM_CG)
		Global.ACT1_CHAPTER2_SCENE2:
			cg_static(ROOM_CG)
		Global.ACT1_CHAPTER2_SCENE3:
			cg_static(CG_DAY)
		Global.ACT1_CHAPTER2_SCENE4:
			cg_static(CG_DAY)
		Global.ACT1_CHAPTER2_SCENE5:
			cg_static(CG_DAY)
		Global.ACT1_CHAPTER2_SCENE6:
			cg_static(CG_DAY)
		Global.ACT1_CHAPTER2_SCENE7:
			cg_static(DINING_CG)
		Global.ACT1_CHAPTER3_SCENE1:
			cg_static(ROOM_CG)
		Global.ACT1_CHAPTER3_SCENE2:
			cg_static(CG_DAY)
		Global.ACT1_CHAPTER3_SCENE3:
			cg_static(CG_EVENING)
		Global.ACT1_CHAPTER3_SCENE4:
			cg_static(CG_NIGHT)
		Global.ACT1_CHAPTER3_SCENE5:
			cg_static(CG_NIGHT)
		Global.ACT1_CHAPTER3_SCENE6:
			cg_static(CG_BALLROOM)
		Global.ACT1_CHAPTER3_SCENE7:
			cg_static(ROOM_CG)
			
	print(get_parent().text)

	var a = create_tween()
	a.tween_property(EffectAnim.MusicPlayer, "volume_db", -10, 3)
	a = create_tween()
	a.tween_property(EffectAnim.SfxPlayer, "volume_db", -10, 3)
	
	#to be changed back to VisualNovelDialogue
	#var vn : VisualNovelDialogue = get_parent()
	var vn : VisualNovelDialogue = get_parent()
	
	vn.connect("fade_black", fade_black)
	vn.connect("fade_black_abrupt", fade_black_abrupt)
	vn.connect("fade_blacktored", fade_blacktored)
	vn.connect("fade_blacktowhite", fade_blacktowhite)
	vn.connect("fade_red", fade_red)
	vn.connect("fade_redtowhite", fade_redtowhite)
	vn.connect("fade_redtoblack", fade_redtoblack)
	vn.connect("fade_white", fade_white)
	vn.connect("fade_whitetored", fade_whitetored)
	vn.connect("fade_whitetoblack", fade_whitetoblack)
	
	vn.connect("fade_trans", fade_trans)
	
	vn.connect("flash_white", flash_white)
	
	vn.connect("screen_shake", screen_shake)

	vn.connect("stop_music", stop_music)
	
	vn.connect("sfx_door_knock", play_sfx.bind(SFX_DOOR_KNOCK))
	vn.connect("sfx_glass_break", play_sfx.bind(SFX_GLASS_BREAK))
	vn.connect("sfx_page_flip", play_sfx.bind(SFX_PAGE_FLIP))
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
	vn.connect("sfx_rattling_door", play_sfx.bind(SFX_DOOR_1))
	vn.connect("sfx_inquisitive", play_sfx.bind(SFX_INQUISITIVE))
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
	vn.connect("sfx_realization", play_sfx.bind(SFX_REALIZATION))
	
	vn.connect("sfx_heels_walking_metal", play_sfx.bind(SFX_HEELS_WALKING_METAL))
	vn.connect("sfx_heels_walking_tile", play_sfx.bind(SFX_HEELS_WALKING_TILE))
	vn.connect("sfx_heels_walking_wood_ext", play_sfx.bind(SFX_HEELS_WALKING_WOOD_EXT))
	vn.connect("sfx_heels_walking_wood_int", play_sfx.bind(SFX_HEELS_WALKING_WOOD_INT))
	vn.connect("sfx_blanket_1", play_sfx.bind(SFX_BLANKET_1))
	vn.connect("sfx_blanket_2", play_sfx.bind(SFX_BLANKET_2))
	vn.connect("sfx_carcrash", play_sfx.bind(SFX_CARCRASH))
	vn.connect("sfx_chair_scoot_wood", play_sfx.bind(SFX_CHAIR_SCOOT_WOOD))
	vn.connect("sfx_curtains_heavy_1", play_sfx.bind(SFX_CURTAINS_HEAVY_1))
	vn.connect("sfx_cutlery_1", play_sfx.bind(SFX_CUTLERY_1))
	vn.connect("sfx_fabric_1", play_sfx.bind(SFX_FABRIC_1))
	vn.connect("sfx_truck_horn", play_sfx.bind(SFX_TRUCK_HORN))
	vn.connect("sfx_wardrobe_1", play_sfx.bind(SFX_WARDROBE_1))
	vn.connect("sfx_drawer_1", play_sfx.bind(SFX_DRAWER_1))
	vn.connect("sfx_door_2", play_sfx.bind(SFX_DOOR_2))
	vn.connect("sfx_cutlery_2", play_sfx.bind(SFX_CUTLERY_2))
	vn.connect("sfx_bells_high", play_sfx.bind(SFX_BELLS_HIGH))
	vn.connect("sfx_bells_low", play_sfx.bind(SFX_BELLS_LOW))
	vn.connect("sfx_bells_jingle", play_sfx.bind(SFX_BELLS_JINGLE))
	vn.connect("sfx_ominous_linger", play_sfx.bind(SFX_OMINOUS_LINGER))
	vn.connect("sfx_ominous_quiet", play_sfx.bind(SFX_OMINOUS_QUIET))
	vn.connect("sfx_ominous_mystery", play_sfx.bind(SFX_OMINOUS_MYSTERY))
	vn.connect("sfx_ominous_buzz", play_sfx.bind(SFX_OMINOUS_BUZZ))
	vn.connect("sfx_dark_vibrate", play_sfx.bind(SFX_DARK_VIBRATE))
	vn.connect("sfx_dark_wash", play_sfx.bind(SFX_DARK_WASH))
	vn.connect("sfx_ominous_funky", play_sfx.bind(SFX_OMINOUS_FUNKY))
	vn.connect("sfx_ominous_high", play_sfx.bind(SFX_OMINOUS_HIGH))
	vn.connect("sfx_ambiance_scarywind", play_sfx.bind(SFX_AMBIANCE_SCARYWIND))
	vn.connect("sfx_ambiance_blizzard", play_sfx.bind(SFX_AMBIANCE_BLIZZARD))
	vn.connect("sfx_ambiance_people_1", play_sfx.bind(SFX_AMBIANCE_PEOPLE_1))
	vn.connect("sfx_ambiance_people_2", play_sfx.bind(SFX_AMBIANCE_PEOPLE_2))
	vn.connect("sfx_ambiance_morningbirds", play_sfx.bind(SFX_AMBIANCE_MORNINGBIRDS))
	vn.connect("sfx_twinkling_fairy", play_sfx.bind(SFX_TWINKLING_FAIRY))
	vn.connect("sfx_twinkling_chime", play_sfx.bind(SFX_TWINKLING_CHIME))
	vn.connect("sfx_ambiance_fountain", play_sfx.bind(SFX_AMBIANCE_FOUNTAIN))
	vn.connect("sfx_footstep_walking_snow", play_sfx.bind(SFX_FOOTSTEP_WALKING_SNOW))
	vn.connect("sfx_ambiance_carriage_1", play_sfx.bind(SFX_AMBIANCE_CARRIAGE_1))
	vn.connect("sfx_glasses_clink", play_sfx.bind(SFX_WINE_GLASSES))
	vn.connect("sfx_glass_crash", play_sfx.bind(SFX_GLASS_CRASH))
	vn.connect("sfx_coinflip_1", play_sfx.bind(SFX_COIN_FLIP))
	vn.connect("sfx_heels_running_wood_ext", play_sfx.bind(SFX_HEELS_RUNNING_WOOD_EXT))
	vn.connect("sfx_horror_suspense_music", play_sfx.bind(SFX_HORROR_SUSPENSE))
	vn.connect("sfx_glass_hit_1", play_sfx.bind(SFX_GLASS_HIT))
	vn.connect("sfx_soft_wind", play_sfx.bind(SFX_SOFT_WIND))
	
	vn.connect("music_somber_death", play_music.bind(MUSIC_SOMBER_DEATH))
	vn.connect("music_more_intense", play_music.bind(MUSIC_MORE_INTENSE))
	vn.connect("music_mysterious", play_music.bind(MUSIC_MYSTERIOUS))
	vn.connect("music_first_stage", play_music.bind(MUSIC_FIRST_STAGE))
	vn.connect("music_tea_time", play_music.bind(MUSIC_TEA_TIME))
	vn.connect("music_social_warfare", play_music.bind(MUSIC_SOCIAL_WARFARE))
	vn.connect("music_church", play_music.bind(MUSIC_CHURCH))
	vn.connect("music_church_welcoming", play_music.bind(MUSIC_CHURCH_WELCOMING))
	vn.connect("music_forest_2", play_music.bind(MUSIC_FOREST_2))
	vn.connect("music_town", play_music.bind(MUSIC_TOWN))
	vn.connect("music_ballroom", play_music.bind(MUSIC_BALLROOM))
	vn.connect("music_god", play_music.bind(MUSIC_GOD))
	vn.connect("music_god_calm", play_music.bind(MUSIC_GOD_CALM))
	vn.connect("music_sliceoflife", play_music.bind(MUSIC_SLICEOFLIFE))
	vn.connect("music_cecilia", play_music.bind(MUSIC_CECILIA))
	
	vn.connect("pause_music", pause_music)
	vn.connect("resume_music", resume_music)
	
	vn.connect("stop_sfx", stop_sfx)
	vn.connect("stop_looping_sfx", stop_sfx_looping)
	
	vn.connect("cg_god_bg", cg_god_bg)
	vn.connect("cg_god_neutral", cg_god_neutral)
	vn.connect("cg_god_neutral_talk", cg_god_neutral_talk)
	vn.connect("cg_god_serious", cg_god_serious)
	vn.connect("cg_god_serious_talk", cg_god_serious_talk)
	vn.connect("cg_god_smile", cg_god_smile)
	vn.connect("cg_god_smile_talk", cg_god_smile_talk)
	vn.connect("cg_god_glitch", cg_god_glitch)
	vn.connect("cg_exit_god", cg_exit_god)
	
	vn.connect("cg_sky", cg_static.bind(SKY_CG))
	vn.connect("cg_black", cg_static.bind(BLACK_CG))
	vn.connect("cg_dining", cg_static.bind(DINING_CG))
	vn.connect("cg_dining_light", cg_static.bind(DINING_CG))
	
	vn.connect("cg_empty_fountain", cg_static.bind(EMPTY_FOUNTAIN))
	vn.connect("cg_cecilia_fountain", cg_static.bind(CECILIA_FOUNTAIN))
	vn.connect("cg_dead_snow", cg_static.bind(DEAD_SNOW_CG))
	
	vn.connect("cg_winter", cg_static.bind(CG_WINTER))
	vn.connect("cg_white", cg_static.bind(CG_WHITE))
	
	vn.connect("cg_ballroom", cg_static.bind(CG_BALLROOM))
	vn.connect("cg_evening", cg_static.bind(CG_EVENING))
	vn.connect("cg_day", cg_static.bind(CG_DAY))
	vn.connect("cg_night", cg_static.bind(CG_NIGHT))
	vn.connect("cg_town", cg_static.bind(CG_TOWN))
	
	vn.connect("cg_room_blur", cg_static.bind(BLUR_ROOM_CG))
	vn.connect("cg_room", cg_static.bind(ROOM_CG))
	
	vn.connect("stop_cg", stop_cg)
	
	vn.connect("overlay_blood_splatter", overlay_static.bind(OVERLAY_BLOOD_SPLATTER))
	
	vn.connect("stop_overlay", stop_overlay)
	
	vn.connect("add_OOC", add_OOC)
	vn.connect("add_OPP", add_OPP)
	
	vn.connect("remove_OOC", remove_OOC)
	vn.connect("remove_OPP", remove_OPP)
	
	vn.connect("hide_text", hide_text)
	vn.connect("show_text", show_text)

func fade_black():
	EffectAnim.play("FadeBlack")
	last_fade = "black"
	Global.data_dict["active_fade"] = "fade_black"
	await EffectAnim.animation_finished
	
func fade_black_abrupt():
	EffectAnim.play("FadeBlackAbrupt")
	last_fade = "black"
	Global.data_dict["active_fade"] = "fade_black_abrupt"
	await EffectAnim.animation_finished
	
func fade_blacktowhite():
	EffectAnim.play("FadeBlackToWhite")
	last_fade = "white"
	Global.data_dict["active_fade"] = "fade_blacktowhite"
	await EffectAnim.animation_finished
	
func fade_blacktored():
	EffectAnim.play("FadeBlackToRed")
	last_fade = "red"
	Global.data_dict["active_fade"] = "fade_blacktored"
	await EffectAnim.animation_finished
	
func fade_red():
	EffectAnim.play("FadeRed")
	last_fade = "red"
	Global.data_dict["active_fade"] = "fade_red"
	await EffectAnim.animation_finished
	
func fade_redtowhite():
	EffectAnim.play("FadeRedToWhite")
	last_fade = "white"
	Global.data_dict["active_fade"] = "fade_redtowhite"
	await EffectAnim.animation_finished
	
func fade_redtoblack():
	EffectAnim.play("FadeRedToBlack")
	last_fade = "black"
	Global.data_dict["active_fade"] = "fade_redtoblack"
	await EffectAnim.animation_finished
	
func fade_white():
	EffectAnim.play("FadeWhite")
	last_fade = "white"
	Global.data_dict["active_fade"] = "fade_white"
	await EffectAnim.animation_finished
	
func fade_whitetoblack():
	EffectAnim.play("FadeWhiteToBlack")
	last_fade = "black"
	Global.data_dict["active_fade"] = "fade_whitetoblack"
	await EffectAnim.animation_finished

func fade_whitetored():
	EffectAnim.play("FadeWhiteToRed")
	last_fade = "red"
	Global.data_dict["active_fade"] = "fade_whitetored"
	await EffectAnim.animation_finished
	
func fade_trans():
	Global.data_dict["active_fade"] = "fade_trans"
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
	
func flash_white():
	EffectAnim.play("FlashWhite")
	await EffectAnim.animation_finished

func screen_shake():
	$CameraAnim.play("screen_shake")
	await $CameraAnim.animation_finished

## MUSIC

func play_music(effect_name):
	EffectAnim.MusicPlayer.volume_db = -10
	EffectAnim.MusicPlayer.stream = effect_name
	EffectAnim.MusicPlayer.play(0)
	
func stop_music():
	BUSY = true
	var a = create_tween()
	a.tween_property(EffectAnim.MusicPlayer,
	"volume_db", -100, 1)
	await a.finished
	EffectAnim.MusicPlayer.stop()
	BUSY = false
	EffectAnim.MusicPlayer.volume_db = -10
	emit_signal("NOT_BUSY")
	
func pause_music():
	BUSY = true
	var a = create_tween()
	a.tween_property(EffectAnim.MusicPlayer,
	"volume_db", -100, 0.5)
	await a.finished
	BUSY = false
	EffectAnim.MusicPlayer.volume_db = -10
	emit_signal("NOT_BUSY")
	
func resume_music():
	BUSY = true
	var a = create_tween()
	a.tween_property(EffectAnim.MusicPlayer,
	"volume_db", -10, 0.5)
	await a.finished
	BUSY = false
	emit_signal("NOT_BUSY")
	
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
	BUSY = true
	var a = create_tween()
	a.tween_property(EffectAnim.LoopPlayer,
	"volume_db", -100, 1)
	await a.finished
	EffectAnim.LoopPlayer.stop()
	BUSY = false
	EffectAnim.LoopPlayer.volume_db = 0
	emit_signal("NOT_BUSY")
	
## CG

func cg_static(texture : Texture):
	BUSY = true
	if $CG.texture:
		$CG2.modulate.a = 0
		$CG2.texture = texture
		var a = create_tween()
		a.tween_property($CG2, "modulate:a", 1, 0.5)
		await a.finished
		$CG.texture = null
	elif $CG2.texture:
		$CG.texture = texture
		var a = create_tween()
		a.tween_property($CG2, "modulate:a", 0, 0.5)
		await a.finished
		$CG2.texture = null
	else:
		$CG.texture = texture
		$CG.modulate.a = 1
	BUSY = false
	emit_signal("NOT_BUSY")
	
func stop_cg():
	BUSY = true
	var a = create_tween()
	a.tween_property($CG, "modulate:a", 0, 0.5)
	await a.finished
	$CG.hide()
	$CG.modulate.a = 1
	BUSY = false
	emit_signal("NOT_BUSY")
	
func overlay_static(texture : Texture):
	BUSY = true
	overlay.texture = texture
	overlay.modulate.a = 0
	overlay.show()
	var a = create_tween()
	a.tween_property(overlay, "modulate:a", 1, 0.5)
	await a.finished
	BUSY = false
	emit_signal("NOT_BUSY")
	
func stop_overlay():
	BUSY = true
	var a = create_tween()
	a.tween_property(overlay, "modulate:a", 0, 0.5)
	await a.finished
	overlay.texture = null
	overlay.hide()
	overlay.modulate.a = 1
	BUSY = false
	emit_signal("NOT_BUSY")
	
func cg_god_bg():
	BUSY = true
	Global.data_dict["god_bg_active"] = true
	print("enter god")
	var a = create_tween()
	$AnimGod/Textures.modulate.a = 0
	a.tween_property($AnimGod/Textures,
	"modulate:a", 1, 0.5)
	anim_god_bg.play("God_BG")
	BUSY = false
	emit_signal("NOT_BUSY")

func cg_god_neutral():
	print("GOD NEUTRAL")
	anim_god.stop(false)
	Global.data_dict["last_god"] = "cg_god_neutral"
	#anim_god.play("RESET")
	#await anim_god.animation_finished
	anim_god.play("NeutralStatic")

func cg_god_neutral_talk():
	print("GOD NEUTRAL TALK")
	anim_god.stop(false)
	Global.data_dict["last_god"] = "cg_god_neutral_talk"
	#anim_god.play("RESET")
	#await anim_god.animation_finished
	anim_god.play("NeutralSpeaking")
	
func cg_god_serious():
	print("GOD SERIOUS")
	anim_god.stop(false)
	Global.data_dict["last_god"] = "cg_god_serious"
	#anim_god.play("RESET")
	#await anim_god.animation_finished
	anim_god.play("SeriousStatic")
	
func cg_god_serious_talk():
	print("GOD SERIOUS TALK")
	anim_god.stop(false)
	Global.data_dict["last_god"] = "cg_god_serious_talk"
	#anim_god.play("RESET")
	#await anim_god.animation_finished
	anim_god.play("SeriousSpeaking")

func cg_god_smile():
	print("GOD SMILE")
	anim_god.stop(false)
	Global.data_dict["last_god"] = "cg_god_smile"
	#anim_god.play("RESET")
	#await anim_god.animation_finished
	anim_god.play("SmileStatic")
	
func cg_god_smile_talk():
	print("GOD SMILE TALK")
	anim_god.stop(false)
	Global.data_dict["last_god"] = "cg_god_smile_talk"
	#anim_god.play("RESET")
	#await anim_god.animation_finished
	anim_god.play("SmileSpeaking")
	
func cg_god_glitch():
	print("GOD GLITCH")
	Global.data_dict["last_god"] = "cg_god_glitch"
	anim_god.stop(false)
	anim_god.play("Glitch")
	
func cg_exit_god():
	BUSY = true
	var a = create_tween()
	$AnimGod/Textures.modulate.a = 1
	a.tween_property($AnimGod/Textures,
	"modulate:a", 0, 0.5)
	await a.finished
	anim_god.stop()
	anim_god_bg.stop()
	BUSY = false
	Global.data_dict["god_bg_active"] = false
	emit_signal("NOT_BUSY")

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
	Global.data_dict["ooc"] += 1
	Global.data_dict["remembered"].append(str("OOC_reached_", Global.data_dict["ooc"]+1))
	
func add_OPP():
	Global.data_dict["opp"] += 1
	Global.data_dict["remembered"].append(str("OPP_reached_", Global.data_dict["opp"]+1))
	
func remove_OOC():
	Global.data_dict["ooc"] -= 1
	if Global.data_dict["remembered"].has(str("OOC_reached_", Global.data_dict["ooc"]+1)):
		Global.data_dict["remembered"].erase(str("OOC_reached_", Global.data_dict["ooc"]+1))
	
func remove_OPP():
	Global.data_dict["opp"] -= 1
	if Global.data_dict["remembered"].has(str("OPP_reached_", Global.data_dict["opp"]+1)):
		Global.data_dict["remembered"].erase(str("OPP_reached_", Global.data_dict["opp"]+1))

func hide_text():
	BUSY = true
	var a = create_tween()
	a.tween_property(get_node(text_box),
	"modulate:a", 0.01, .15)
	await a.finished
	#get_node(text_box)["mouse_filter"] = 2
	BUSY = false
	emit_signal("NOT_BUSY")

func show_text():
	BUSY = true
	var a = create_tween()
	a.tween_property(get_node(text_box),
	"modulate:a", 1, .15)
	await a.finished
	#get_node(text_box)["mouse_filter"] = 1
	BUSY = false
	emit_signal("NOT_BUSY")
