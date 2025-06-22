extends BaseGameManager

class_name LibraryGameManager

var score := 0

@export var ui_manager: CanvasLayer

@onready var player = $Player

func get_score() -> int:
	return score
	
func _on_library_player_book_caught(amount: int) -> void:
	score += amount
	ui_manager.update_points(score)

func _on_library_player_bomb_caught() -> void:
	score -= 1
	ui_manager.update_points(score)
