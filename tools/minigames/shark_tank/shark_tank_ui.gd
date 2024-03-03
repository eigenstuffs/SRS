extends Control

class_name SharkTankUI

const PITCH_LIST : SharkTankPitchList = preload("res://tools/minigames/shark_tank/pitch_list.tres")
const DOCUMENT = preload("res://tools/minigames/shark_tank/document.tscn")

@onready var documents : Control = $Documents
@onready var responses : Control = $Responses
@onready var anim : AnimationPlayer = $Node2D/AnimationPlayer
@onready var dialogue_holder = $CanvasLayer/DialogueHolder

var following_mouse : bool = false
var held_button : Button = null
var diff : Vector2 = Vector2.ZERO

var current_pitch : SharkTankPitches = null
var previous_pitches : Array[SharkTankPitches] = []
var negotiations : int = 0

var points = 0

signal minigame_finished(num : int)
signal update_points(num : int)

func _ready():
	await get_tree().create_timer(10).timeout
	for i in documents.get_children():
		i.connect("pressed", _on_button_pressed)
		# i connect it through code cuz we dont know how
		# many buttons there will be
	responses.hide()
	documents.hide()
	new_pitch()

func _input(event):
	if event.is_action_released("LMB") and held_button:
		held_button.button_pressed = false
		held_button = null
	
func _process(_delta):
	if held_button:
		var mouse_pos = get_global_mouse_position()-diff
		held_button.position = mouse_pos
		documents.move_child(held_button, -1)

func _on_button_pressed():
	for i : Button in documents.get_children():
		if i.button_pressed:
			held_button = i
			diff = get_global_mouse_position() - i.position

func _on_invest_pressed():
	responses.hide()
	documents.hide()
	Util.dialogue_from_strings(dialogue_holder,
			current_pitch.deal_dialogue)
	await Util.util_finished
	$Node2D/AnimationPlayer.play("WalkOut")

func _on_negotiate_pressed():
	responses.hide()
	
	if current_pitch.available_negotiations == negotiations:
		_on_pass_pressed()
		return
		
	match negotiations:
		0:
			negotiations += 1
			Util.dialogue_from_strings(dialogue_holder,
			current_pitch.first_negotiate)
			await Util.util_finished
			Util.dialogue_from_strings(dialogue_holder,
			current_pitch.second_offer)
			await Util.util_finished
		1:
			negotiations += 1
			Util.dialogue_from_strings(dialogue_holder,
			current_pitch.second_negotiate)
			Util.dialogue_from_strings(dialogue_holder,
			current_pitch.third_offer)
			await Util.util_finished
		2:
			negotiations += 1
			Util.dialogue_from_strings(dialogue_holder,
			current_pitch.third_negotiate)
			Util.dialogue_from_strings(dialogue_holder,
			current_pitch.fourth_offer)
			await Util.util_finished
			
	responses.show()

func _on_pass_pressed():
	responses.hide()
	documents.hide()
	Util.dialogue_from_strings(dialogue_holder,
		current_pitch.no_deal_dialogue)
	await Util.util_finished
	
	$Node2D/AnimationPlayer.play("WalkOut")

func new_pitch():
	$Node2D/AnimationPlayer.play("WalkIn")
	await $Node2D/AnimationPlayer.animation_finished
	
	
	var list : Array[SharkTankPitches] = PITCH_LIST.pitch_list.duplicate(true)
	for i : SharkTankPitches in previous_pitches:
		list.erase(i)
	list.shuffle()
	var pitch = list[0]
	current_pitch = pitch
	
	for i in current_pitch.documents:
		var a : TextureButton = DOCUMENT.instantiate()
		documents.add_child(a)
		a.texture = i
	
	Util.dialogue_from_strings(dialogue_holder,
		current_pitch.pitch)
	await Util.util_finished
	negotiations = 0
	
	offer_loop()
	
func offer_loop():
	Util.dialogue_from_strings(dialogue_holder,
		current_pitch.first_offer)
	await Util.util_finished
	responses.show()
	documents.show()
	

