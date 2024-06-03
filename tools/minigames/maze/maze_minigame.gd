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
const FIRST_STAGE_MUSIC = preload("res://tools/minigames/maze/sound/Villianess_Reborn_Minigame_Music_First_Stage.mp3")
const FASTER_MUSIC = preload("res://tools/minigames/maze/sound/Villianess_Reborn_Minigame_Music_More_Intense.mp3")

@export var time_penalty : int = -3
var point_get : int = 0
var all_keys_got : bool = false

func _ready():
	pause_all_movement()

func game_start():
	resume_all_movement()

func end():
	pause_all_movement()
	$SfxPlayer.stream = GAME_FINISHED_SFX
	$SfxPlayer.play()
	music_fade_out()
	emit_signal("ended")
	has_ended = true
	var stats_gained = calculate_stats(remaining_time, maze_metadata.diffMult)
	detailed_points = [[remaining_time, maze_metadata.diffMult], stats_gained]
	await $SfxPlayer.finished
	emit_signal("minigame_finished", detailed_points)

func _on_maze_generator_key_collected():
	$SfxPlayer.stream = KEY_SFX
	$SfxPlayer.play()
	point_get += 1
	update_points.emit(point_get)

func _on_maze_generator_all_key_collected():
	all_keys_got = true
	pause_all_movement()
	emit_signal("update_time", "pause")
	#switching camera view
	await get_tree().create_timer(0.1).timeout
	await $MazePlayer/FollowingCamera.bird_view()
	await get_tree().create_timer(0.25).timeout
	$Goal.show_and_monitor()
	await get_tree().create_timer(1).timeout
	$MazePlayer/FollowingCamera.original_view()
	emit_signal("update_time", "resume")
	#start the effect
	$SfxPlayer.stream = SPEED_UP_SFX
	$SfxPlayer.play()
	EffectReg.start_effect(self, "ImpactLines", [$EffectNode, 1.0])
	#increase speed for both enemies and player
	$MazePlayer.set_speed_modifier(2)
	$MazeGenerator.set_all_enemy_speed_modifier(2)
	resume_all_movement()
	await music_fade_out()
	$MusicPlayer.stream = FASTER_MUSIC
	$MusicPlayer.play()

func _on_goal_goal_touched():
	if all_keys_got:
		print("player unlocked the exit!")
		end()

func _on_maze_generator_enemy_met_player():
	EffectReg.start_effect(self, "Flash", [$EffectNode, Color(0.6, 0, 0, 0.4)])
	emit_signal("update_time", time_penalty)
	$SfxPlayer.stream = HURT_SFX
	$SfxPlayer.play()

func _physics_process(_delta: float) -> void:
	RenderingServer.global_shader_parameter_set('cpu_sync_time', Time.get_ticks_usec()*1e-6)

func calculate_stats(time : int, multiplier : int) -> Array[int]:
	var wis_gained := roundi((time)/10) * multiplier
	var well_gained := roundi((time)/10 + 1) * multiplier
	return [wis_gained, 0, 0, well_gained]
	
func music_fade_out():
	var a = create_tween()
	a.tween_property($MusicPlayer, "volume_db", -80, 2.0)
	await a.finished
	$MusicPlayer.stop()
	$MusicPlayer.volume_db = -8
	
func pause_all_movement():
	$MazePlayer.can_move = false
	for child in $EnemyFolder.get_children():
		child.can_move = false

func resume_all_movement():
	$MazePlayer.can_move = true
	for child in $EnemyFolder.get_children():
		child.can_move = true
