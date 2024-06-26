class_name SettingsDropDown extends Control

signal autoplay_started
signal exit_log

const LOG_TEXT = preload("res://tools/dialogue/log_text.tscn")

@onready var buttons = $Buttons
@onready var dropdown = $DropDown

@export_node_path("Control") var text_box

var autoplay = false
var hide = false
var skip = false
var lmb = true

var busy = false

var log_text : Array[String] = []

@onready var other_buttons = [
	$SettingsButton,
	$SaveButton,
	$LoadButton
]

func _ready():
	buttons.hide()
	
func _process(_delta):
	if Rect2(Vector2(), size).has_point(
		get_local_mouse_position()
	):
		lmb = false
	elif !$MouseBlocker.sub_lmb:
		lmb = false
	else:
		lmb = true

func _on_skip_pressed():
	#autoplay = $Buttons/Skip.button_pressed
	skip = $Buttons/Skip.button_pressed
	$Buttons/Autoplay.button_pressed = false
	autoplay = $Buttons/Skip.button_pressed
	
	if skip: autoplay_started.emit()
	#$Buttons/Autoplay.button_pressed = false

func _on_autoplay_pressed():
	skip = false
	autoplay = $Buttons/Autoplay.button_pressed
	#skip = false
	print($Buttons/Autoplay.button_pressed)
	$Buttons/Skip.button_pressed = false
	print(autoplay)
	#if autoplay: skip = false
	if autoplay: autoplay_started.emit()
	#$Buttons/Skip.button_pressed = false

func _on_log_pressed():
	busy = true
	get_tree().paused = true
	
	for i in $Log/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for i in log_text:
		var a = LOG_TEXT.instantiate()
		a.text = i
		$Log/ScrollContainer/VBoxContainer.add_child(a)
	
	$Log.show()
	
	$Log.init()
		
	$DropDown.disabled = true

	for i in $Buttons.get_children():
		i.disabled = true
	for i in other_buttons:
		i.disabled = true
	
			
	await $Log.log_closed
	
	$Log.hide()
	await get_tree().create_timer(0.1).timeout
	
		
	$DropDown.disabled = false

	for i in $Buttons.get_children():
		i.disabled = false
	for i in other_buttons:
		i.disabled = false
	
	get_tree().paused = false
	busy = false

func _on_hide_pressed():
	busy = true
	autoplay = false
	lmb = false
	skip = false
	$Buttons/Autoplay.button_pressed = false
	$Buttons/Skip.button_pressed = false
	var a = create_tween()
	a.tween_property(
		get_node(text_box),
		"modulate:a",
		0,
		0.4
	)
	await a.finished
	get_tree().paused = true
	
	$DropDown.disabled = true
	for i in $Buttons.get_children():
		i.disabled = true
	for i in other_buttons:
		i.disabled = true
	get_tree().paused = true
	
	await exit_log
	
	a = create_tween()
	a.tween_property(
		get_node(text_box),
		"modulate:a",
		1,
		0.4
	)
	
	await a.finished
	get_tree().paused = false
	$DropDown.disabled = false

	for i in $Buttons.get_children():
		i.disabled = false
	for i in other_buttons:
		i.disabled = false
	lmb = true
	busy = false

func stop_skip():
	skip = false
	autoplay = $Buttons/Autoplay.button_pressed
	$Buttons/Autoplay.button_pressed = $Buttons/Autoplay.button_pressed
	$Buttons/Skip.button_pressed = false

func _on_drop_down_pressed():
	print("pressed")
	if dropdown.button_pressed:
		buttons.show()
	else:
		buttons.hide()

func _on_settings_button_pressed():
	busy = true
	get_tree().paused = true
	
	for i in $Buttons.get_children():
		i.disabled = true
	for i in other_buttons:
		i.disabled = true
	$DropDown.disabled = true
	
	$Settings.show()
	$Settings.init()
	await $Settings.exit_settings
	$Settings.hide()
	
	await get_tree().create_timer(0.1).timeout
	
	$DropDown.disabled = false
	for i in $Buttons.get_children():
		i.disabled = false
	for i in other_buttons:
		i.disabled = false
	get_tree().paused = false
	busy = false
	
func _on_save_button_pressed():
	busy = true
	get_tree().paused = true
	for i in $Buttons.get_children():
		i.disabled = true
	for i in other_buttons:
		i.disabled = true
	$DropDown.disabled = true
	
	$SaveScreen.show()
	$SaveScreen.init()
	await $SaveScreen.exited_save
	$SaveScreen.hide()
	
	await get_tree().create_timer(0.1).timeout
	
	$DropDown.disabled = false
	for i in $Buttons.get_children():
		i.disabled = false
	for i in other_buttons:
		i.disabled = false
	get_tree().paused = false
	busy = false

func _on_load_button_pressed():
	busy = true
	get_tree().paused = true
	for i in $Buttons.get_children():
		i.disabled = true
	for i in other_buttons:
		i.disabled = true
	$DropDown.disabled = true
	
	$LoadScreen.show()
	$LoadScreen.init()
	await $LoadScreen.exited_load
	$LoadScreen.hide()
	
	await get_tree().create_timer(0.1).timeout
	
	$DropDown.disabled = false
	for i in $Buttons.get_children():
		i.disabled = false
	for i in other_buttons:
		i.disabled = false
	get_tree().paused = false
	busy = false

func add_to_log(text : String):
	log_text.append(text)
	if log_text.size() > 19:
		log_text.remove_at(0)

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("LMB"):
		emit_signal("exit_log")
