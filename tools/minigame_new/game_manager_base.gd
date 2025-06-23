extends Node

class_name BaseGameManager

func start_game():
	push_warning("It seems like 'start_game' is not defined in the extended class, so the base abstract function is being called -- BaseGameManager.gd")

func end_game():
	push_warning("It seems like 'end_game' is not defined in the extended class, so the base abstract function is being called -- BaseGameManager.gd")
	
func get_rough_score() -> Array[int]:
	return [0]

func calculate_stats_gained() -> Array[int]:
	return [0, 0, 0, 0]
