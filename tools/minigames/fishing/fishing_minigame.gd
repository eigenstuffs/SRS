#class_name FishingMinigame extends Minigame
extends Node3D #remember to change this back
# signals and end() are already defined in Minigame class .. see minigame.gd


func _ready():
	await get_tree().create_timer(3).timeout # wait for countdown timer
	

func end() -> void:
	pass # override the minigame.gd function for game-specific calls
	# see library_minigame.gd for example
	
func _process(delta):
	pass
