extends Node3D

class_name FreeZone

signal noTimeLeft

@export var turns : int = 3

@onready var interactor : Interactor = $Actors/Player.get_node("Interactor")
@onready var overlay = $CanvasLayer/Overlay
@onready var turn_label : Label = $CanvasLayer/Overlay/Turns/TextureRect/Label

func _ready():
	EffectAnim.play_backwards("FadeBlack")
	interactor.connect("started_interaction", interacted)
	if !Global.data_dict["remembered"].has("FreeZone"):
		Util.show_tutorial("FreeZone", $TutorialHolder)
	turn_label.text = str(turns) + " turns left"
	set_turn_left()
	check_turn_left()
	
func interacted():
	overlay.hide()
	turns -= 1
	turn_label.text = str(turns) + " turns left"
	await interactor.finished_interaction
	overlay.show()
	check_turn_left()

func set_turn_left():
	turns = turns - Global.minigames_played_this_zone
	turn_label.text = str(turns) + " turns left"

func check_turn_left():
	if turns==0:
		Global.can_move = false
		overlay.hide()
		EffectAnim.play("FadeBlack")
		await EffectAnim.animation_finished
		Global.minigames_played_this_zone = 0
		get_tree().change_scene_to_file("res://tools/dialogue/vn_dialogue.tscn")
		Global.can_move = true
