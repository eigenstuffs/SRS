class_name FishingMinigame extends Minigame
#extends Node3D #remember to change this back
# signals and end() are already defined in Minigame class .. see minigame.gd

@onready var fishing_rod = $FishingPlayer/FishingRod
@onready var force_bar = $CanvasLayer/ForceBar

signal reeling_minigame
signal reeling_minigame_end(is_successful : bool)

var force_multiplier : float = 1
var fish_caught : int = 0

func _ready():
	await get_tree().create_timer(3).timeout # wait for countdown timer
	
func end() -> void:
	emit_signal("minigame_finished", fish_caught)
	# see library_minigame.gd for example
	
func _process(delta):
	force_multiplier = force_bar.value / 100
	fishing_rod.bobber_initial_v.z = 3 * force_multiplier


func _on_canvas_layer_reeling_ended(is_successful):
	emit_signal("reeling_minigame_end", is_successful)
	if is_successful:
		fish_caught += 1
		update_points.emit(fish_caught)

func _on_fish_instancer_fish_hooked():
	emit_signal("reeling_minigame")
