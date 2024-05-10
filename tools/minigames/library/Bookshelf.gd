extends Area3D

class_name Bookshelf

signal player_entered

func _on_body_entered(body):
	if body is LibraryPlayer:
		emit_signal("player_entered")
