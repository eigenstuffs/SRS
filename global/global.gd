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

### DIALOGUE FILES

const ACT1_CHAPTER1_SCENE1 = "res://tools/dialogue/vn_scripts/Dialogue - a1c1_1.json"
const ACT1_CHAPTER1_SCENE2 = "res://tools/dialogue/vn_scripts/Dialogue - a1c1_2.json"
const ACT1_CHAPTER1_SCENE3 = "res://tools/dialogue/vn_scripts/Dialogue - a1c1_3.json"

func return_current_text():
	if data_dict["remembered"].has("a1c1_3"):
		return ACT1_CHAPTER1_SCENE3
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

var player_hp : int = 10 # poise 
var player_mp : int = 5  
var player_max_hp : int = 10
var player_max_mp : int = 5
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
	
	"player_wisdom" : player_wisdom,
	"player_intelligence" : player_intelligence,
	"player_charisma" : player_charisma,
	"player_wellness" : player_wellness,
	"player_money" : player_money,
	"player_prestige" : player_prestige,
	"player_cards" : card_list.card_list,
	
	"player_hp" : player_hp,
	"player_mp" : player_mp,
	"player_max_hp" : player_max_hp,
	"player_max_mp" : player_max_mp,
	"player_level" : player_level,
	"player_defense_ratio" : player_defense_ratio,
	"player_offense_ratio" : player_offense_ratio
}
	
func _ready():
	load_data()
	
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
	control.get_children()[-1].add_child(color_rect)
	await get_tree().create_timer(0.2).timeout # idk if this is needed
	# ...then we remove all the loaded effects.
	for effect_name in EffectReg.effects.keys(): EffectReg.free_effect(effect_name)
	color_rect.queue_free()

func save_data():
	var dir = DirAccess.open(save_dir)
	if !dir:
		DirAccess.make_dir_recursive_absolute(save_dir)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	print("Saved data.")
	file.store_var(data_dict)
	file.close()

func load_data():
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		data_dict = file.get_var()
		file.close()
		print("Loaded data.")
	else:
		save_data()
		print("Saved and loaded new file.")
		load_data()
