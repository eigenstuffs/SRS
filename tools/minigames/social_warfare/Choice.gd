class_name SocialWarfareChoice extends Control

signal chosen(move : String)

var current_choice : String

func _on_fight_pressed():
	current_choice = "fight"
	chosen.emit("fight")

func _on_flee_pressed():
	current_choice = "flee"
	chosen.emit("flee")
