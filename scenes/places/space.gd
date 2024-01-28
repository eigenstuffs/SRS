extends Node3D

signal noTimeLeft

var turns = 5

@onready var interactor: Interactor = get_tree().current_scene.get_node("Actors/Player/Interactor")


func _ready():
	interactor.connect("interact", interacted)
	
func interacted():
	turns -= 1
	get_tree().current_scene.get_node("CanvasLayer/Overlay/Turns/Label").text = str(turns) + " turns left"
	if turns==0:
		pass
		#emit_signal("noTimeLeft")
