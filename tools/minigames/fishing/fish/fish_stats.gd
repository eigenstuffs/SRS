extends Resource

class_name FishStats

#FIXME: Add more skins and randomize them
const common_skin = preload("res://tools/minigames/fishing/assets/Fishies/fish_common1_spritesheet.png")
const rare_skin = preload("res://tools/minigames/fishing/assets/Fishies/fish_rare1_spritesheet.png")
const epic_skin = preload("res://tools/minigames/fishing/assets/Fishies/fish_epic1_spritesheet.png")
const legendary_skin = preload("res://tools/minigames/fishing/assets/Fishies/fish_legendary1_spritesheet.png")

#i made them all dictionaries in case we want to add names/descriptions here for the inventory; not sure if it's rly necessary tho?? I think using arrays is also possible
@export var fishie_one : Dictionary = {"bite_strength": 3, "rarity": "legendary", "sell_price": 200, "speed": 1.5, "skin": legendary_skin}
@export var fishie_two : Dictionary = {"bite_strength": 2, "rarity": "epic", "sell_price": 150, "speed": 1.0, "skin": epic_skin}
@export var fishie_three : Dictionary = {"bite_strength": 2, "rarity": "rare", "sell_price": 100, "speed": 0.3, "skin": rare_skin}
@export var fishie_four : Dictionary = {"bite_strength": 1.5, "rarity": "common", "sell_price": 50, "speed": 0.6, "skin": common_skin}
@export var fish_list : Array[Dictionary] = [fishie_one, fishie_two, fishie_three, fishie_four]


func set_fish_stats(fish_type : int, fishie: Fish):
	var whatFish : int = 3
	match fish_type:
		0: 
			whatFish = 0
		1,2:
			whatFish = 1
		3,4,5:
			whatFish = 2
		6,7,8,9:
			whatFish = 3
	fishie.speed = fish_list[whatFish].get("speed")
	fishie.bite_strength = fish_list[whatFish].get("bite_strength")
	fishie.rarity = fish_list[whatFish].get("rarity")
	fishie.sell_price = fish_list[whatFish].get("sell_price")
	fishie.skin.set_texture(fish_list[whatFish].get("skin"))
