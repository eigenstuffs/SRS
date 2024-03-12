extends Node

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

var text_speed = 0.015
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
