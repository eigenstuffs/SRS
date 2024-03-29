extends Node3D

signal noTimeLeft

@export var turns : int = 5

@onready var interactor : Interactor = $Actors/Player.get_node("Interactor")
@onready var overlay = $CanvasLayer/Overlay
@onready var turn_label : Label = $CanvasLayer/Overlay/Turns/TextureRect/Label

func _ready():
	interactor.connect("started_interaction", interacted)
	
func interacted():
	overlay.hide()
	turns -= 1
	turn_label.text = str(turns) + " turns left"
	await interactor.finished_interaction
	overlay.show()
	if turns==0:
		Global.can_move = false
		EffectAnim.play("FadeBlack")
		await EffectAnim.animation_finished
		get_tree().change_scene_to_file("res://scenes/menus/title.tscn")
		Global.can_move = true
