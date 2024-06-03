extends Node

signal util_finished
signal tutorial_finished

const UTIL_DIALOGUE = preload("res://tools/dialogue/util_dialogue.tscn")
const MINIGAME_HOLDER = preload("res://tools/minigame/minigame_holder.tscn")
const REWARD_SCENE_LIST = preload("res://resources/minigame/reward_scene_list.tres")
const TUTORIAL_LIST = preload("res://resources/minigame/tutorial_list.tres")

func popup_dialogue(holder : CanvasLayer, text_array : Array[String], names : Array):
	var a : UtilDialogue = UTIL_DIALOGUE.instantiate()
	holder.add_child(a)
	a.read(text_array, names)
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
	a.queue_free()
	create_reward_scene(minigame, points[0], points[1], a, canvas_layer)
	return points

func create_reward_scene(minigame : String, scores : Array, stats_gained : Array, scene, canvas_layer):
	var desired_scene = REWARD_SCENE_LIST.find_scene(minigame)
	var a : Reward = desired_scene.instantiate()
	a.set_vars(scores, stats_gained)
	canvas_layer.add_child(a)
	if scene is MinigameHolder: scene.is_finished = true
	await get_tree().create_timer(1).timeout
	a.start_display()
	await a.display_finished
	a.queue_free()
	emit_signal("util_finished")

func show_tutorial(which : String, scene):
	var desired_tutorial = TUTORIAL_LIST.find_scene(which)
	var a : Tutorial = desired_tutorial.instantiate()
	scene.add_child(a)
	#a.position = Vector2(960, 540)
	await a.confirm_pressed
	a.queue_free()
	Global.add_event(which)
	emit_signal("tutorial_finished")
