extends Node

class_name Utilities

signal util_finished

const DIALOGUE_FROM_STRINGS = preload("res://dialogue/dialogue_from_strings.tscn")

func dialogue_from_strings(text_array : Array[String]):
	var a : DialogueFromStrings = DIALOGUE_FROM_STRINGS.instantiate()
	var b = get_tree().current_scene
	b.get_node("CanvasLayer/DialogueHolder").add_child(a)
	a.read(text_array)
	await a.finished_reading
	a.queue_free()
	emit_signal("util_finished")
