extends Node

signal util_finished

const DIALOGUE_FROM_STRINGS = preload("res://tools/dialogue/dialogue_from_strings.tscn")
const MINIGAME_HOLDER = preload("res://tools/minigame_holder/minigame_holder.tscn")

func dialogue_from_strings(holder : Control, text_array : Array[String]):
	var a : DialogueFromStrings = DIALOGUE_FROM_STRINGS.instantiate()
	holder.add_child(a)
	a.read(text_array)
	await a.finished_reading
	a.queue_free()
	emit_signal("util_finished")

func create_minigame(canvas_layer : CanvasLayer, minigame : String):
	var a : MinigameHolder = MINIGAME_HOLDER.instantiate()
	canvas_layer.add_child(a)
	a.initiate_minigame(minigame)
	await a.finished
	var points = a.points
	a.queue_free()
	emit_signal("util_finished")
	return points
