class_name RhythmMinigame extends Minigame

func _ready() -> void:
	pass
	
func end() -> void:
	minigame_finished.emit(0)
