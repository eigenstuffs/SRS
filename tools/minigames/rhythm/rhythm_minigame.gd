class_name RhythmMinigame extends Minigame

@onready var playfield : RhythmPlayfield = $Playfield

func _ready() -> void:
	pass
	
func _process(_delta : float) -> void:
	RenderingServer.global_shader_parameter_set('cpu_sync_time', Time.get_ticks_usec()*1e-6)
	
func end() -> void:
	detailed_points = [playfield.scores, [1, 1, 0, 0]]
	minigame_finished.emit(detailed_points)
	
