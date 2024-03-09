class_name RhythmMinigame extends Minigame

@onready var playfield : RhythmPlayfield = $Playfield

var last_note_time : float

func _ready() -> void:
	last_note_time = playfield.hit_objects[-1].time
	MinigameRegistry.get_metadata('Rhythm').time = last_note_time - 3
	
	# FIXME: cursed hack into minigame_holder
	get_parent().get_parent().ui.connect('startTimeOver', func(): playfield.start())
	get_parent().get_parent().ui.gTime.queue_free()
	
func _process(_delta : float) -> void:
	RenderingServer.global_shader_parameter_set('cpu_sync_time', Time.get_ticks_usec()*1e-6)

func _physics_process(delta: float) -> void:
	if not has_ended and playfield.audio_synchronizer.time > last_note_time:
		end()
	# FIXME: cursed hack into minigame_holder
	var time_left = max(0, last_note_time - max(0, playfield.audio_synchronizer.time))
	get_parent().get_parent().ui.gLabel.text = str(time_left as int)
	get_parent().get_parent().ui.gBar.value = time_left
	
	
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
