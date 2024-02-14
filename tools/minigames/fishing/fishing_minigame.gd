#class_name FishingMinigame extends Minigame
extends Node3D #remember to change this back
# signals and end() are already defined in Minigame class .. see minigame.gd
@onready var fishing_rod = $FishingPlayer/FishingRod
@onready var force_bar = $CanvasLayer/ForceBar

var force_multiplier : float = 1

func _ready():
	await get_tree().create_timer(3).timeout # wait for countdown timer
	

func end() -> void:
	pass # override the minigame.gd function for game-specific calls
	# see library_minigame.gd for example
	
func _process(delta):
	force_multiplier = force_bar.value / 100
	fishing_rod.bobber_initial_v.z = 3 * force_multiplier
