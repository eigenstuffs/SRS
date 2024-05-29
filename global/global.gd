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

var og_ro : String

### OPTIONS

var text_speed = 0.01
var volume = 0.5

### DIALOGUE FILES

const ACT1_CHAPTER1_PART1 = "res://tools/dialogue/vn_scripts/Dialogue - a1c1.json"
const ACT1_CHAPTER1_PART2 = "res://tools/dialogue/vn_scripts/Dialogue - a1c1_2.json"
const ACT1_CHAPTER2_PART1 = "res://tools/dialogue/vn_scripts/Dialogue - a1c2_1.json"
const ACT1_CHAPTER2_PART2 = "res://tools/dialogue/vn_scripts/Dialogue - a1c2_2.json"

func return_current_text():
	if remembered.has("a1c2_1"):
		return ACT1_CHAPTER2_PART2
	elif remembered.has("a1c1_2"):
		return ACT1_CHAPTER2_PART1
	elif remembered.has("a1c1_1"):
		return ACT1_CHAPTER1_PART2
	else:
		return ACT1_CHAPTER1_PART1
		
func add_event(event : String):
	remembered.append(event)
	
func rename_seraphina(name : String):
	seraphina_name = name
	
func rename_player(name : String):
	player_name = name

### PLAYER STATS

@onready var player_wisdom : int = 0
@onready var player_intelligence : int = 0
@onready var player_charisma : int = 0
@onready var player_wellness : int = 0
@onready var player_money : int = 0
@onready var player_prestige : int = 0

@onready var player_cards : Array[Card] = card_list.card_list

var player_hp : int = 10 # poise 
var player_mp : int = 5  
var player_level : int = 1 # repute
var player_defense_ratio : float = 1
var player_offense_ratio : float = 1

# main four stats

func set_stats(list : Array[int]):
	player_wisdom = list[0]
	player_intelligence = list[1]
	player_charisma = list[2]
	player_wellness = list[3]
	print("PLAYER STATS CHANGED: " + str(get_main_stats()))

func get_stat(index : int) -> int:
	match index:
		0:
			return player_wisdom
		1:
			return player_intelligence
		2:
			return player_charisma
		3: 
			return player_wellness
		4:
			return player_money
		5:
			return player_prestige
		_:
			print("invalid index!")
			return -999
	
func get_main_stats() -> Array[int]:
	var output : Array[int] = [player_wisdom,
		player_intelligence,
		player_charisma,
		player_wellness]
	return output
