extends Node3D

signal noTimeLeft

@export var turns : int = 3

@onready var interactor : Interactor = $Actors/Player.get_node("Interactor")
@onready var overlay = $CanvasLayer/Overlay
@onready var turn_label : Label = $CanvasLayer/Overlay/Turns/TextureRect/Label

func _ready():
	EffectAnim.play_backwards("FadeBlack")
	turn_label.text = str(turns) + " turns left"
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
		Global.save_data()
		get_tree().change_scene_to_file("res://tools/dialogue/vn_dialogue.tscn")
		Global.can_move = true
