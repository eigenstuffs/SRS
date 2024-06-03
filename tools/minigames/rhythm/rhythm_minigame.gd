class_name RhythmMinigame extends Minigame

@onready var playfield : RhythmPlayfield = $Playfield

var last_note_time : float
var prepare_stage := false

func _ready() -> void:
	MinigameRegistry.get_metadata('Rhythm').time = 9999.0
	get_parent().get_parent().ui.gTime.queue_free()

func _process(delta: float) -> void:
	if $Playfield/Camera3D.fov != 75:
		var fov = $Playfield/Camera3D.fov
		$Playfield/Camera3D.fov = move_toward(fov, 75, 4.0*abs(fov - 75)*delta)

func _physics_process(delta: float) -> void:
	RenderingServer.global_shader_parameter_set('cpu_sync_time', Time.get_ticks_usec()*1e-6)
	if not has_ended and playfield.audio_synchronizer.time > last_note_time:
		end()
	# FIXME: cursed hack into minigame_holder
	var time_left = max(0, last_note_time - max(0, playfield.audio_synchronizer.time))
	get_parent().get_parent().ui.gLabel.text = str(time_left as int)
	get_parent().get_parent().ui.gBar.value = time_left
	
	if prepare_stage: return
	var beatmap_select := $BeatmapSelect/SubViewportContainer/SubViewport/BeatmapSelect
	if beatmap_select.has_chosen:
		playfield.beatmap = beatmap_select.current_beatmap
		playfield.prepare()
		
		last_note_time = playfield.hit_objects[-1].time
		MinigameRegistry.get_metadata('Rhythm').time = last_note_time - 3
		# FIXME: cursed hack into minigame_holder
		#get_parent().get_parent().ui.connect('startTimeOver', func(): playfield.start())
		
		prepare_stage = true
		await get_tree().create_timer(3.0).timeout
		EffectReg.free_effect('ColorFade')
		EffectReg.start_effect(self, 'ColorFade', [$Playfield/Effects, Color.WHITE, Color.TRANSPARENT, 0.65])
		$BeatmapSelect.free()
		playfield.visible = true
		$Environment.environment.sky_rotation = Vector3(0, deg_to_rad(-90), deg_to_rad(-270))
		$DirectionalLight3D.rotation_degrees = Vector3(-60, -130, 0)
		$Playfield/Camera3D.fov = 170
		await get_tree().create_timer(3.0).timeout
		playfield.start()
	
func end() -> void:
	if not has_ended:
		has_ended = true
		# FIXME: cursed hack into minigame_holder
		get_parent().get_parent().ui.gLabel.hide()
		get_parent().get_parent().ui.sLabel.show()
		get_parent().get_parent().ui.sLabel.text = "Finished!"
		get_parent().get_parent().ui.gameOver.emit()
		
		detailed_points = [playfield.scores, [1, 1, 0, 0]]
		minigame_finished.emit(detailed_points)

func _on_playfield_report_score(score: int) -> void:
	rough_points += score
	
	if score > 0: update_points.emit(rough_points)
