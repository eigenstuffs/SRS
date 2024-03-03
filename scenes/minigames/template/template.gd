extends Node2D

signal minigame_finished(player_won : bool)

func _ready():
	pass

func end():
	emit_signal("minigame_finished", true)
