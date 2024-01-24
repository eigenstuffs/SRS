extends Node

signal util_finished

const DIALOGUE_FROM_STRINGS = preload("res://dialogue/dialogue_from_strings.tscn")

func dialogue_from_strings(holder : Control, text_array : Array[String]):
	var a : DialogueFromStrings = DIALOGUE_FROM_STRINGS.instantiate()
	holder.add_child(a)
	a.read(text_array)
	await a.finished_reading
	a.queue_free()
	emit_signal("util_finished")

func create_minigame(holder : Control, minigame : String):
	pass
