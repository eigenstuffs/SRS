extends Resource

class_name FishStats

#i made them all dictionaries in case we want to add names/descriptions here for the inventory; not sure if it's rly necessary tho?? I think using arrays is also possible
@export var fishie_one : Dictionary = {"bite_time": 2, "rarity": 0.1, "sell_price": 200, "speed": 1.5}
@export var fishie_two : Dictionary = {"bite_time": 2, "rarity": 0.2, "sell_price": 150, "speed": 0.5}
@export var fishie_three : Dictionary = {"bite_time": 3, "rarity": 0.3, "sell_price": 100, "speed": 0.3}
@export var fishie_four : Dictionary = {"bite_time": 1, "rarity": 0.4, "sell_price": 50, "speed": 0.6}
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
	fishie.bite_time = fish_list[whatFish].get("bite_time")
	fishie.rarity = fish_list[whatFish].get("rarity")
	fishie.sell_price = fish_list[whatFish].get("sell_price")
