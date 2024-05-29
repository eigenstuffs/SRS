class_name SocialWarfareChoice extends Control

signal chosen(move : String)

var current_choice : String

func _on_fight_pressed():
	chosen.emit("fight")
	current_choice = "fight"

func _on_flee_pressed():
	chosen.emit("flee")
	current_choice = "flee"
