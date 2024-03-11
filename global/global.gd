extends Node

### UTILITIES

var can_move = true

### GAME

var remembered = []

### MODIFIABLE THROUGH DIALOGUE

var player_name : String = "You"
var seraphina_name : String = "Seraphina"

### OPTIONS

var text_speed = 0.015
var volume = 0.5

### DIALOGUE FILES

const ACT1_CHAPTER1 = "res://tools/dialogue/vn_scripts/Dialogue - a1c1.json"
const ACT1_CHAPTER1_PART2 = "res://tools/dialogue/vn_scripts/Dialogue - a1c1_2.json"

func return_current_text():
	if remembered.has("intro_done"):
		return ACT1_CHAPTER1_PART2
	else:
		return ACT1_CHAPTER1
	
