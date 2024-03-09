extends Node

signal util_finished

const DIALOGUE_FROM_STRINGS = preload("res://tools/dialogue/dialogue_from_strings.tscn")
const MINIGAME_HOLDER = preload('res://tools/minigame/minigame_holder.tscn')
const REWARD_SCENE_LIST = preload("res://resources/minigame/reward_scene_list.tres")

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
	var points = a.detailed_points
	print(points)
	emit_signal("util_finished")
	create_reward_scene(minigame, points[0], points[1], a, canvas_layer)
	return points

func create_reward_scene(minigame : String, scores : Array, stats_gained : Array, scene, canvas_layer):
	var desired_scene = REWARD_SCENE_LIST.find_scene(minigame)
	var a : Reward = desired_scene.instantiate()
	a.set_vars(scores, stats_gained)

	canvas_layer.add_child(a)
	print('hi')
	scene.is_finished = true
	#await get_tree().create_timer(1).timeout
	#a.start_display()
	#print('hi2')
	#await a.display_finished
	#print('hi3')
	#a.queue_free()
	#scene.queue_free()
	#emit_signal("util_finished")
