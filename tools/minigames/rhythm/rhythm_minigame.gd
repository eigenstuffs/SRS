class_name RhythmMinigame extends Minigame

@onready var playfield : RhythmPlayfield = $Playfield

var last_note_time : float
var prepare_stage := false

func _ready() -> void:
	MinigameRegistry.get_metadata('Rhythm').time = -1.0
	get_parent().get_parent().ui.gTime.queue_free()

func _process(delta: float) -> void:
	if $Playfield/Camera3D.fov != 75:
		var fov = $Playfield/Camera3D.fov
		$Playfield/Camera3D.fov = move_toward(fov, 75, 4.0*abs(fov - 75)*delta)

func _physics_process(delta: float) -> void:
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
		
		var last_hit_object := playfield.hit_objects[-1]
		last_note_time = last_hit_object.time + last_hit_object.duration + 3.0
		MinigameRegistry.get_metadata('Rhythm').time = last_note_time
		# FIXME: cursed hack into minigame_holder
		get_parent().get_parent().ui.connect('startTimeOver', func(): playfield.start())
		
		prepare_stage = true
		await get_tree().create_timer(2.5).timeout
		EffectReg.free_effect('ColorFade')
		EffectReg.start_effect(self, 'ColorFade', [$Playfield/Effects, Color.WHITE, Color.TRANSPARENT, 0.65])
		$BeatmapSelect.free()
		playfield.visible = true
		$Environment.environment.sky_rotation = Vector3(0, deg_to_rad(-90), deg_to_rad(-270))
		$DirectionalLight3D.rotation_degrees = Vector3(-60, -130, 0)
		$Playfield/Camera3D.fov = 170
		await get_tree().create_timer(3.0).timeout
		get_parent().get_parent().start.call()
	
func end() -> void:
	if not has_ended:
		has_ended = true
		# FIXME: cursed hack into minigame_holder
		get_parent().get_parent().ui.gLabel.hide()
		get_parent().get_parent().ui.sLabel.show()
		get_parent().get_parent().ui.sLabel.text = "Finished!"
		get_parent().get_parent().ui.gameOver.emit()
		
		var combo_multiplier := 0.0
		if playfield.max_combo != 0:
			combo_multiplier = 1.5 if not playfield.combo_was_broken else lerpf(0.7, 1.0, min(1.0, playfield.max_combo / len(playfield.beatmap.objects)))
		var score_sum : float = playfield.scores[0] + playfield.scores[1] + playfield.scores[2] + playfield.scores[3] + playfield.scores[4]
		var type_multiplier := 1.0
		type_multiplier -= 0.1 * playfield.scores[1] / score_sum
		type_multiplier -= 0.3 * playfield.scores[2] / score_sum
		type_multiplier -= 0.5 * playfield.scores[3] / score_sum
		type_multiplier -= 0.8 * playfield.scores[4] / score_sum
		
		var beatmap := playfield.beatmap
		var duration := beatmap.objects[-1].time + beatmap.objects[-1].duration
		var difficulty := len(beatmap.objects)/(duration + 1e-8) # Difficulty is just note density LOL
		var difficulty_multiplier := (log(difficulty+1) + 1)/log(10) # Ranges from 1 to 1.343 at 10 stars
		print('Combo Multiplier (%d): %f, Type Multiplier: %f, Difficulty Multiplier: %f' % [playfield.max_combo, combo_multiplier, type_multiplier, difficulty_multiplier])
		var multiplier := combo_multiplier*type_multiplier*difficulty_multiplier
		
		detailed_points = [playfield.scores, [ceili(8*multiplier), ceili(6*multiplier), 0, 0]]
		minigame_finished.emit(detailed_points)

func _on_playfield_report_score(score: int) -> void:
	rough_points += score
	
	if score > 0: update_points.emit(rough_points)
