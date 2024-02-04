class_name RhythmMinigame extends Minigame

func _ready() -> void:
	pass
	
func _end() -> void:
	minigame_finished.emit(0)
