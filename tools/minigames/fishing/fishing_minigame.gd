class_name FishingMinigame extends Minigame
#extends Node3D #remember to change this back
# signals and end() are already defined in Minigame class .. see minigame.gd

@onready var fishing_rod = $FishingPlayer/FishingRod
var force_bar_val

signal reeling_minigame
signal reeling_minigame_end(is_successful : bool)

var force_multiplier : float = 1
var fish_caught : int = 0
var fish_caught_by_type : Array[int] = [0, 0, 0, 0]

func _ready():
	force_bar_val = $CanvasLayer.get_force_bar_val()
	await get_tree().create_timer(3).timeout # wait for countdown timer
	
func end() -> void:
	var stats_gained : Array[int] = calculate_stats(fish_caught_by_type)
	detailed_points = [fish_caught_by_type, stats_gained]
	emit_signal("minigame_finished", [fish_caught_by_type, stats_gained])
	
func _process(delta):
	force_bar_val = $CanvasLayer.get_force_bar_val()
	force_multiplier = force_bar_val / 100


func _on_canvas_layer_reeling_ended(is_successful, rarity):
	emit_signal("reeling_minigame_end", is_successful)
	if is_successful:
		fish_caught += 1
		update_points.emit(fish_caught)
		update_fish_caught_by_type(rarity)
		

func _on_fish_instancer_fish_hooked():
	emit_signal("reeling_minigame")

func update_fish_caught_by_type(type):
	match type:
		"common":
			fish_caught_by_type[0] += 1
		"rare":
			fish_caught_by_type[1] += 1
		"epic":
			fish_caught_by_type[2] += 1
		"legendary": fish_caught_by_type[3] += 1
	print(type + " fish caught")
func calculate_stats(fish_types) -> Array[int]:
	var wellness_gained = roundi(0.2*fish_types[0] + 0.45 * fish_types[1] + 1.0*fish_types[2] + 1.5 *fish_types[3])
	var charisma_gained = roundi(0.1*fish_types[0] + 0.3*fish_types[1] + 0.5*fish_types[2] + 0.7*fish_types[3])
	return [0, 0, charisma_gained, wellness_gained]


func _on_fishing_player_releasing_rod():
	fishing_rod.bobber_initial_v.z = 3 * force_multiplier
