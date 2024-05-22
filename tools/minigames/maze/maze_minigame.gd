class_name MazeMinigame extends Minigame
#extends Node3D

#TODO: fix 2D-3D-2.5D perspective
#TODO: add difficulty levels
#TODO: Ending scene

#parameters:
#Easy: W = L = 5, NKey = 2, r = 2
#Medium: W = L = 10, NKey = 3, r = 3
#Hard: W = L = 13, NKey = 5, r = 4
@onready var maze_metadata : MazeMeta = preload("res://tools/minigames/maze/maze_metadata.tres")
@onready var GAME_FINISHED_SFX = preload("res://tools/minigames/maze/sound/maze_game_finished.wav")
@onready var HURT_SFX = preload("res://tools/minigames/maze/sound/player_hurt.wav")
@onready var SPEED_UP_SFX = preload("res://tools/minigames/maze/sound/speed_up.wav")
@onready var KEY_SFX = preload("res://tools/minigames/maze/sound/key_get.wav")
@onready var DOOR_OPEN_SFX = preload("res://tools/minigames/maze/sound/door_open.wav")
@export var time_penalty : int = -5
var point_get : int = 0
var all_keys_got : bool = false

func end():
	Global.can_move = false
	$SfxPlayer.stream = GAME_FINISHED_SFX
	$SfxPlayer.play()
	emit_signal("ended")
	has_ended = true
	var stats_gained = calculate_stats(remaining_time, maze_metadata.diffMult)
	detailed_points = [[remaining_time, maze_metadata.diffMult], stats_gained]
	emit_signal("minigame_finished", detailed_points)

func _on_maze_generator_key_collected():
	$SfxPlayer.stream = KEY_SFX
	$SfxPlayer.play()
	point_get += 1
	update_points.emit(point_get)

func _on_maze_generator_all_key_collected():
	all_keys_got = true
	Global.can_move = false #pause movement for all
	#switching camera view
	await get_tree().create_timer(0.1).timeout
	await $MazePlayer/FollowingCamera.bird_view()
	await get_tree().create_timer(0.25).timeout
	$Goal.show_and_monitor()
	await get_tree().create_timer(1).timeout
	$MazePlayer/FollowingCamera.original_view()
	emit_signal("update_time", 2)
	#start the effect
	$SfxPlayer.stream = SPEED_UP_SFX
	$SfxPlayer.play()
	EffectRegistry.start_effect(self, "ImpactLines", [$EffectNode, 1.0])
	#increase speed for both enemies and player
	$MazePlayer.set_speed_modifier(2)
	$MazeGenerator.set_all_enemy_speed_modifier(2)
	Global.can_move = true #re-enable movement

func _on_goal_goal_touched():
	if all_keys_got:
		print("player unlocked the exit!")
		end()

func _on_maze_generator_enemy_met_player():
	EffectRegistry.start_effect(self, "Flash", [$EffectNode, Color(0.6, 0, 0, 0.4)])
	emit_signal("update_time", time_penalty)
	$SfxPlayer.stream = HURT_SFX
	$SfxPlayer.play()

func _physics_process(_delta: float) -> void:
	RenderingServer.global_shader_parameter_set('cpu_sync_time', Time.get_ticks_usec()*1e-6)

func calculate_stats(time : int, multiplier : int) -> Array[int]:
	var int_gained := roundi((3*time)/60) * multiplier
	var well_gained := roundi((4*time)/60 + 1) * multiplier
	return [0, int_gained, 0, well_gained]
