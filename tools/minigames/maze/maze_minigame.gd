class_name MazeMinigame extends Minigame
#extends Node3D

@export var time_penalty : int = -5
var point_get : int = 0
var all_keys_got : bool = false

func _on_maze_generator_key_collected():
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
	await get_tree().create_timer(2.5).timeout
	$MazePlayer/FollowingCamera.original_view()
	#start the effect
	EffectRegistry.start_effect(self, "ImpactLines", [$EffectNode, 1.0])
	#increase speed for both enemies and player
	$MazePlayer.set_speed_modifier(2)
	$MazeGenerator.set_all_enemy_speed_modifier(2)
	Global.can_move = true #re-enable movement

func _on_goal_goal_touched():
	if all_keys_got:
		print("player unlocked the exit!")

func _on_maze_generator_enemy_met_player():
	EffectRegistry.start_effect(self, "Flash", [$EffectNode, Color(0.6, 0, 0, 0.4)])
	emit_signal("update_time", time_penalty)

func _physics_process(_delta: float) -> void:
	RenderingServer.global_shader_parameter_set('cpu_sync_time', Time.get_ticks_usec()*1e-6)
