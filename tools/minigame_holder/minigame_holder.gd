class_name MinigameHolder extends Control

const MINIGAME_VIEWPORT_DIMS : Vector2 = Vector2(1600, 900)

var rough_points : int = 0
var detailed_points : Array = []

signal finished(detailed_points)
#detailed points should be in the format [array1, array2]
#array 1 should be the detailed score of that minigame, like how many books caught, how many bombs touched, etc.
#array 2 should be an array of four numbers which represent the increment in each stat

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
	rough_points = new
	$UI/PointLabel.text = str(rough_points)

func _on_ui_game_over():
	var game = $Game.get_child(0)
	game.end()
	await get_tree().create_timer(2).timeout
	rough_points = game.rough_points
	detailed_points = game.detailed_points
	finished.emit(detailed_points)
	game.queue_free()
