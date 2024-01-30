extends Node3D
## Represents a single rhythm game 'key' bound to a single keybind.
##
## The key only considers [class AbstractNote]s present within its hitbox (i.e.,
## only notes present within the hitbox will be hit. Multiple notes present
## within the hitbox are hit in the order in which they arrive.

@export var keybind : String = 'ui_accept'

@onready var hit_sound : AudioStreamPlayer = $HitSoundPlayer
@onready var y_origin = $Mesh.position.y
var depress_distance : float = 0.15
var depress_recover_time : float = 0.2
var current_score : float = 0
var note_queue : Array = []

func _input(event : InputEvent) -> void:
	if event.is_action_pressed(keybind): on_button_press()
	elif event.is_action_released(keybind): on_button_release()

func on_button_press() -> void:
	hit_sound.play()
	if note_queue.is_empty():
		print('bro hitting nothing!')
		return

	var note = note_queue.front()
	var hit_dist = note.hit(global_position.z)
	if note.is_queued_for_deletion():
		note_queue.pop_front()

	print('hit_dist: ' + str(hit_dist))
	$Mesh/Score.text = str(snapped(hit_dist, 1e-3))

func on_button_release() -> void:
	if note_queue.is_empty(): return

	var note = note_queue.front()
	var hit_dist = note.release(global_position.z)
	if note.is_queued_for_deletion():
		note_queue.pop_front()

		print('hit_dist: ' + str(hit_dist))
		$Mesh/Score.text = str(snapped(hit_dist, 1e-3))

func _process(delta : float) -> void:
	if Input.is_action_pressed(keybind):
		# Depressing the key is instantaneous for a better feel
		$Mesh.position.y = y_origin - depress_distance
		if not note_queue.is_empty():
			note_queue.front().hold(global_position.z)
	else:
		$Mesh.position.y = min(y_origin, $Mesh.position.y + (depress_distance / depress_recover_time) * delta)

func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.get_parent() is AbstractNote:
		note_queue.push_back(area.get_parent())

func _on_hitbox_area_exited(area: Area3D) -> void:
	var note = area.get_parent()
	if not note is AbstractNote: return
	
	# TODO: This is awful way of checking wtf
	var note_idx = note_queue.find(note)
	if note_idx >= 0:
		$Mesh/Score.text = 'MISS'
		note_queue.remove_at(note_idx)
	else:
		note.queue_free()
