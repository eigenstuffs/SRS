extends Minigame

func unhandled_input(event: InputEvent) -> void:
	$PlayerCharacter.input(event)
