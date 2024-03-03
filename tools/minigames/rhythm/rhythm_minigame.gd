class_name RhythmMinigame extends Minigame

func _ready() -> void:
	pass
	
func _process(_delta : float) -> void:
	RenderingServer.global_shader_parameter_set('cpu_sync_time', Time.get_ticks_usec()*1e-6)
	
func end() -> void:
	minigame_finished.emit(0)
