extends Node

@onready var card_list = preload("res://resources/cards/CardList.tres")

### UTILITIES

var can_move = true

### GAME

var remembered = []
var ooc = 0
var opp = 1

### MODIFIABLE THROUGH DIALOGUE

var player_name : String = "You"
var seraphina_name : String = "Seraphina"

var type : String
var og_ro : String

### OPTIONS

var text_speed = 0.01
var volume = 0.5
var effect_on = false

var saved_date

var god_bg_active : bool = false
var last_god : String
var active_fade : String
var active_cg : String
var active_music : String
var active_looping : String

### DIALOGUE FILES 

const ACT1_CHAPTER1_SCENE1 = "res://tools/dialogue/vn_scripts/Dialogue - a1c1_1.json"
const ACT1_CHAPTER1_SCENE2 = "res://tools/dialogue/vn_scripts/Dialogue - a1c1_2.json"
const ACT1_CHAPTER1_SCENE3 = "res://tools/dialogue/vn_scripts/Dialogue - a1c1_3.json"
const ACT1_CHAPTER2_SCENE1 = "res://tools/dialogue/vn_scripts/Dialogue - a1c2_1.json"
const ACT1_CHAPTER2_SCENE2 = "res://tools/dialogue/vn_scripts/Dialogue - a1c2_2.json"
const ACT1_CHAPTER2_SCENE3 = "res://tools/dialogue/vn_scripts/Dialogue - a1c2_3.json"
const ACT1_CHAPTER2_SCENE4 = "res://tools/dialogue/vn_scripts/Dialogue - a1c2_4.json"
const ACT1_CHAPTER2_SCENE5 = "res://tools/dialogue/vn_scripts/Dialogue - a1c2_5.json"
const ACT1_CHAPTER2_SCENE6 = "res://tools/dialogue/vn_scripts/Dialogue - a1c2_6.json"
const ACT1_CHAPTER2_SCENE7 = "res://tools/dialogue/vn_scripts/Dialogue - a1c2_7.json"
const ACT1_CHAPTER3_SCENE1 = "res://tools/dialogue/vn_scripts/Dialogue - a1c3_1.json"
const ACT1_CHAPTER3_SCENE2 = "res://tools/dialogue/vn_scripts/Dialogue - a1c3_2.json"
const ACT1_CHAPTER3_SCENE3 = "res://tools/dialogue/vn_scripts/Dialogue - a1c3_3.json"
const ACT1_CHAPTER3_SCENE4 = "res://tools/dialogue/vn_scripts/Dialogue - a1c3_4.json"
const ACT1_CHAPTER3_SCENE5 = "res://tools/dialogue/vn_scripts/Dialogue - a1c3_5.json"
const ACT1_CHAPTER3_SCENE6 = "res://tools/dialogue/vn_scripts/Dialogue - a1c3_6.json"
const ACT1_CHAPTER3_SCENE7 = "res://tools/dialogue/vn_scripts/Dialogue - a1c3_7.json"

var current_scene = ACT1_CHAPTER1_SCENE1
var current_line = 0

func return_current_text():
	
	if data_dict["remembered"].has("a1c3_6"):
		return ACT1_CHAPTER3_SCENE7 # current newest
	elif data_dict["remembered"].has("a1c3_5"):
		return ACT1_CHAPTER3_SCENE6
	elif data_dict["remembered"].has("a1c3_4"):
		return ACT1_CHAPTER3_SCENE5
	elif data_dict["remembered"].has("a1c3_3"):
		return ACT1_CHAPTER3_SCENE4
	elif data_dict["remembered"].has("a1c3_2"):
		return ACT1_CHAPTER3_SCENE3
	elif data_dict["remembered"].has("a1c3_1"):
		return ACT1_CHAPTER3_SCENE2
	elif data_dict["remembered"].has("a1c2_7"):
		return ACT1_CHAPTER3_SCENE1
	elif data_dict["remembered"].has("a1c2_6"):
		return ACT1_CHAPTER2_SCENE7
	elif data_dict["remembered"].has("a1c2_5"):
		return ACT1_CHAPTER2_SCENE6
	elif data_dict["remembered"].has("a1c2_4"):
		return ACT1_CHAPTER2_SCENE5
	elif data_dict["remembered"].has("a1c2_3"):
		return ACT1_CHAPTER2_SCENE4
	elif data_dict["remembered"].has("a1c2_2"):
		return ACT1_CHAPTER2_SCENE3
	elif data_dict["remembered"].has("a1c2_1"):
		return ACT1_CHAPTER2_SCENE2
	elif data_dict["remembered"].has("a1c1_3"):
		return ACT1_CHAPTER2_SCENE1
	elif data_dict["remembered"].has("a1c1_2"):
		return ACT1_CHAPTER1_SCENE3
	elif data_dict["remembered"].has("a1c1_1"):
		return ACT1_CHAPTER1_SCENE2
	else:
		return ACT1_CHAPTER1_SCENE1
		
func add_event(event : String):
	data_dict["remembered"].append(event)
	
func rename_seraphina(name : String):
	data_dict["seraphina_name"] = name
	
func rename_player(name : String):
	data_dict["player_name"] = name

### PLAYER STATS

@onready var player_wisdom : int = 50
@onready var player_intelligence : int = 50
@onready var player_charisma : int = 50
@onready var player_wellness : int = 50
@onready var player_money : int = 0
@onready var player_prestige : int = 0

@onready var player_cards : Array[Card] = card_list.card_list

var player_hp : int = 20 # poise 
var player_mp : int = 10
var player_max_hp : int = 20
var player_max_mp : int = 10
var player_level : int = 1 # repute
var player_defense_ratio : float = 1
var player_offense_ratio : float = 1

# main four stats

func set_stats(list : Array[int]):
	data_dict["player_wisdom"] = list[0]
	data_dict["player_intelligence"] = list[1]
	data_dict["player_charisma"] = list[2]
	data_dict["player_wellness"] = list[3]
	print("PLAYER STATS CHANGED: " + str(get_main_stats()))

func get_stat(index : int) -> int:
	match index:
		0:
			return data_dict["player_wisdom"]
		1:
			return data_dict["player_intelligence"]
		2:
			return data_dict["player_charisma"]
		3: 
			return data_dict["player_wellness"]
		4:
			return data_dict["player_money"]
		5:
			return data_dict["player_prestige"]
		_:
			print("invalid index!")
			return -999
	
func get_main_stats() -> Array[int]:
	var output : Array[int] = [data_dict["player_wisdom"],
		data_dict["player_intelligence"],
		data_dict["player_charisma"],
		data_dict["player_wellness"]]
	return output

## SAVING AND LOADING

var save_dir = "user://villainess_saves/"
var save_path = save_dir + "save.dat"
var meta_data_path = save_dir + "meta_data.dat"

@onready var original_data_dict = {
	"remembered" : [],
	"ooc" : 0,
	"opp" : 0,
	"player_name" : "No name.",
	"seraphina_name" : "Nothing yet!",
	"type" : "Nothing yet!",
	"og_ro" : "Nobody yet!",
	"text_speed" : 0.01,
	"volume" : 0.5,
	"current_scene" : ACT1_CHAPTER1_SCENE1,
	"current_line" : 0,
	"saved_date": null,
	
	"player_wisdom" : 0,
	"player_intelligence" : 0,
	"player_charisma" : 0,
	"player_wellness" : 0,
	"player_money" : 0,
	"player_prestige" : 0,
	"player_cards" : card_list.card_list,
	
	"player_hp" : 20,
	"player_mp" : 10,
	"player_max_hp" : 20,
	"player_max_mp" : 10,
	"player_level" : 1,
	"player_defense_ratio" : 1,
	"player_offense_ratio" : 1,
	
	"god_bg_active" : false,
	"last_god" : null,
	"active_fade" : null,
	"active_cg" : null,
	"active_music" : null,
	"active_looping" : null
}

@onready var data_dict = {
	"remembered" : remembered,
	"ooc" : ooc,
	"opp" : opp,
	"player_name" : player_name,
	"seraphina_name" : seraphina_name,
	"type" : type,
	"og_ro" : og_ro,
	"text_speed" : text_speed,
	"volume" : volume,
	"current_scene" : current_scene,
	"current_line" : current_line,
	"saved_date" : saved_date,
	
	"player_wisdom" : player_wisdom,
	"player_intelligence" : player_intelligence,
	"player_charisma" : player_charisma,
	"player_wellness" : player_wellness,
	"player_money" : player_money,
	"player_prestige" : player_prestige,
	"player_cards" : card_list.card_list, #Potential arbitrary execution
	
	"player_hp" : player_hp,
	"player_mp" : player_mp,
	"player_max_hp" : player_max_hp,
	"player_max_mp" : player_max_mp,
	"player_level" : player_level,
	"player_defense_ratio" : player_defense_ratio,
	"player_offense_ratio" : player_offense_ratio,
	
	"god_bg_active" : god_bg_active,
	"last_god" : last_god,
	"active_fade" : active_fade,
	"active_cg" : active_cg,
	"active_music" : active_music,
	"active_looping" : active_looping
}

@onready var meta_data_dict = {
	"effect_on" : effect_on
}

func _init() -> void:
	# Sets **window** (like actual OS window) background to black
	RenderingServer.set_default_clear_color(Color.BLACK)

func _ready():
	#var window = get_window()
	## And get the current screen the window's in
	#var screen = window.current_screen
	## Get the usable rect for that screen
	#var screen_rect = DisplayServer.screen_get_usable_rect(screen)
	## Get the window's size
	#var window_size = window.get_size_with_decorations()
	## Set its position to the middle
	#window.position = screen_rect.position + (screen_rect.size / 2 - window_size / 2)
	
	
	load_meta_data()
	for i in 100:
		var dynamic_path = save_dir + "save_" + str(i) + ".dat"
		load_data(dynamic_path)
	if meta_data_dict["effect_on"]:
		await get_tree().create_timer(0.1).timeout #evil timer here again
		precompile_effects()
	else: print("effect turned off")
	# FIXME: evil timer to wait for noise textures to generate i hate this but im too lazy to make a proper
	await get_tree().create_timer(0.1).timeout
	EffectReg.start_effect(self, 'FilmGrain', [self.get_node('/root/EffectReg')])


func reset_data(dynamic_path : String):
	var dir = DirAccess.open(save_dir)
	if !dir:
		DirAccess.make_dir_recursive_absolute(save_dir)
	var file = FileAccess.open(dynamic_path, FileAccess.WRITE)
	print("Saved data. " + dynamic_path)
	file.store_var(original_data_dict)
	file.close()

func save_data(dynamic_path : String):
	var dir = DirAccess.open(save_dir)
	if !dir:
		DirAccess.make_dir_recursive_absolute(save_dir)
	var file = FileAccess.open(dynamic_path, FileAccess.WRITE)
	print("Saved data. " + dynamic_path)
	file.store_var(data_dict)
	file.close()
	
func create_save(dynamic_path : String):
	var dir = DirAccess.open(save_dir)
	if !dir:
		DirAccess.make_dir_recursive_absolute(save_dir)
	var file = FileAccess.open(dynamic_path, FileAccess.WRITE)
	print("Created data." + dynamic_path)
	file.store_var(original_data_dict)
	file.close()

func load_data(dynamic_path : String):
	var file = FileAccess.open(dynamic_path, FileAccess.READ)
	if file:
		# TODO: turn off object decoding or make sure that arbitrary code doesn't get executed
		data_dict = file.get_var()
		file.close()
		print("Loaded data.")
	else:
		create_save(dynamic_path)
		print("Created and loaded new file. " + dynamic_path)
		load_data(dynamic_path)

func save_meta_data():
	var dir = DirAccess.open(save_dir)
	if !dir:
		DirAccess.make_dir_recursive_absolute(save_dir)
	var file = FileAccess.open(meta_data_path, FileAccess.WRITE)
	print("Saved metadata." + meta_data_path)
	file.store_var(meta_data_dict)
	file.close()

func load_meta_data():
	var file = FileAccess.open(meta_data_path, FileAccess.READ)
	if file:
		meta_data_dict = file.get_var()
		file.close()
		print("Loaded meta data.")
	else:
		save_meta_data()
		print("Created and loaded new file. " + meta_data_path)
		load_meta_data()

func precompile_effects():
	# --- EFFECT SHADER PRECOMPILATION --- 
	# A black ColorRect is used to hide all the shaders drawn on the screen!
	var color_rect := ColorRect.new()
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	color_rect.color = Color.BLACK
	color_rect.z_index = RenderingServer.CANVAS_ITEM_Z_MAX
	
	# FIXME: This is an awful way for 'shader precompilation'! ew! ew!
	# FIXME: This could crash the game on very low end devices.
	var control := self.get_node('/root/EffectReg')
	# We load all effects to the screen (ensuring they are *visible* i.e., rendered)
	for effect_name in EffectReg.effects.keys(): EffectReg.start_effect(self, effect_name, [control])
	await get_tree().create_timer(0.2).timeout # idk if this is needed
	control.add_child(color_rect) #FIXME: I can still see the effects :(
	# ...then we remove all the loaded effects.
	for effect_name in EffectReg.effects.keys(): EffectReg.free_effect(effect_name)
	
	color_rect.queue_free()
	print("all effect compiled")

func _physics_process(delta: float) -> void:
	RenderingServer.global_shader_parameter_set('cpu_sync_time', Time.get_ticks_usec()*1e-6)

func _process(_delta):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"), Global.data_dict["volume"]
	)
