extends Node3D

class_name LibraryMinigame

signal minigame_finished(num_points : int)

@export var points : int = 0

@onready var score_label : Label = $CanvasLayer/Overlay/ScoreLabel

func _ready():
	points = 0
	update_score()

func update_score():
	score_label.text = str(points)

#by default we gain and lose by 1 point. If we want to make some
#extra valuable books or damaging bombs, we can adjust that
#when calling the gain and lose points function

func gain_points(increment : int = 1):
	points += increment
	update_score()
	
func lose_points(decrease : int = 1):
	points -= decrease
	update_score()

func end():
	emit_signal("minigame_finished", points)
	print(points)

func _on_increase_point_pressed():
	gain_points()
	update_score()

func _on_decrease_point_pressed():
	lose_points()
	update_score()

func _on_timers_game_over():
	end()

func _on_library_player_book_collected():
	gain_points(1)

func _on_library_player_bomb_hit():
	lose_points(1)
