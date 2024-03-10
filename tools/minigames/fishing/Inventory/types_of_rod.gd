extends Resource

class_name FishingRodTypes

@export var rod_one : Dictionary = {"name": "Default Fishing Rod", "description": "standard fishing rod. it catches fish.", "reel_strength": 1.0, "reel_size": 1.0}
@export var rod_two : Dictionary = {"name": "Cooler Fishing Rod", "description": "a fishing rod, but cooler.", "reel_strength": 1.1, "reel_size": 1.3}
@export var rod_three: Dictionary = {"name": "Superior Fishing Rod", "description": "they say that this is the rod of the masters.", "reel_strength": 1.3, "reel_size": 1.5}
@export var rod_four: Dictionary = {"name": "BEST Fishing Rod", "description": "a rod with faded lettering on the handle. 'Cult de Poisson'...?", "reel_strength": 2, "reel_size": 1.7}
@export var rod_list : Array[Dictionary] = [rod_one,rod_two, rod_three, rod_four]

var current_rod : Dictionary = rod_list[0]

func set_current_rod(num : int):
	current_rod = rod_list[num]

func get_current_rod(attribute : String = "ALL"):
	match attribute:
		"ALL":
			return [current_rod.get("name"), current_rod.get("reel_strength"), current_rod.get("reel_size")]
		"name":
			return current_rod.get("name")
		"reel_strength":
			return current_rod.get("reel_strength")
		"reel_size":
			return current_rod.get("reel_size")
