extends Control

class_name SharkTankUI

const PITCH_LIST : SharkTankPitchList = preload("res://tools/minigames/shark_tank/pitch_list.tres")

@onready var buttons : Control = $Buttons
@onready var responses : Control = $Responses
@onready var anim : AnimationPlayer = $Node2D/AnimationPlayer
@onready var dialogue_holder = $CanvasLayer/DialogueHolder

var following_mouse : bool = false
var held_button : Button = null
var diff : Vector2 = Vector2.ZERO

var current_pitch : SharkTankPitches = null
var previous_pitches : Array[SharkTankPitches] = []

var points = 0

signal minigame_finished(num : int)
signal update_points(num : int)

func _ready():
	for i in buttons.get_children():
		i.connect("pressed", _on_button_pressed)
		# i connect it through code cuz we dont know how
		# many buttons there will be
	responses.hide()
	buttons.hide()
	new_pitch()

func _input(event):
	if event.is_action_released("LMB") and held_button:
		held_button.button_pressed = false
		held_button = null
	
func _process(delta):
	if held_button:
		var mouse_pos = get_global_mouse_position()-diff
		held_button.position = mouse_pos

func _on_button_pressed():
	for i : Button in buttons.get_children():
		if i.button_pressed:
			held_button = i
			diff = get_global_mouse_position() - i.position

func _on_invest_pressed():
	$Node2D/AnimationPlayer.play("WalkIn")
	await $Node2D/AnimationPlayer.animation_finished
	buttons.show()
	responses.show()

func _on_negotiate_pressed():
	pass

func _on_pass_pressed():
	$Node2D/AnimationPlayer.play("WalkOut")
	buttons.hide()
	responses.hide()

func new_pitch():
	var list : Array[SharkTankPitches] = PITCH_LIST.pitch_list.duplicate(true)
	for i : SharkTankPitches in previous_pitches:
		list.erase(i)
	list.shuffle()
	var pitch = list[0]
	current_pitch = pitch
	Util.dialogue_from_strings(dialogue_holder,
		current_pitch.first_offer)
	await Util.util_finished
	
	
