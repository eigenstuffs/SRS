class_name MinigameHolder extends Control

const MINIGAME_VIEWPORT_DIMS : Vector2 = Vector2(1600, 900)

var points : int = 0

signal finished(points)

func initiate_minigame(which : String):
	if MinigameRegistry.has_key(which):
		var metadata : MinigameInfo = MinigameRegistry.get_metadata(which)
		var minigame : Minigame = load(metadata.scene).instantiate()
		minigame.size = MINIGAME_VIEWPORT_DIMS
		$Game.add_child(minigame)
		minigame.connect("update_points", update_points)
		
		if metadata.time <= 0: return
		$UI.gameTimeCount = metadata.time
		$UI/GameTimer/TextureProgressBar.max_value = metadata.time
		$UI/GameTimer/TextureProgressBar.value = metadata.time
		$UI/GameTimer/TimeLabel.text = str(metadata.time)
	else:
		printerr("No such minigame %s!" % which)

func update_points(new : int):
	points = new
	$UI/PointLabel.text = str(points)

func _on_ui_game_over():
	var game = $Game.get_child(0)
	game.end()
	await get_tree().create_timer(2).timeout
	points = game.points
	finished.emit(points)
	game.queue_free()
