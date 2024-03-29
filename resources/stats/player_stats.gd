extends Resource

class_name PlayerStats

@export var wisdom : int
@export var intelligence : int
@export var charisma : int
@export var wellness : int
@export var money : int
@export var prestige : int

#currently it's only setting the four main stats,
#feel free to extend it to the other two stats when we need them
func set_stats(list : Array[int]):
	wisdom = list[0]
	intelligence = list[1]
	charisma = list[2]
	wellness = list[3]
	print("PLAYER STATS CHANGED: " + str(get_main_stats()))
	emit_changed()

func get_stat(index : int):
	match index:
		0:
			return wisdom
		1:
			return intelligence
		2:
			return charisma
		3: 
			return wellness
		4:
			return money
		5:
			return prestige
		_:
			print("invalid index!")
	return
	
#main stats means the first four
func get_main_stats() -> Array[int]:
	var output : Array[int] = [wisdom, intelligence, charisma, wellness]
	return output
	
