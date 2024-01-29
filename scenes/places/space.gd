extends Node3D

signal noTimeLeft

var turns = 5

@onready var interactor : Interactor = $Actors/Player.get_node("Interactor")
@onready var overlay : Overlay = $CanvasLayer/Overlay
@onready var turn_label : Label = $CanvasLayer/Overlay/Turns/Label

func _ready():
	interactor.connect("started_interaction", interacted)
	
func interacted():
	overlay.hide()
	turns -= 1
	turn_label.text = str(turns) + " turns left"
	await interactor.finished_interaction
	overlay.show()
	if turns==0:
		emit_signal("noTimeLeft")
