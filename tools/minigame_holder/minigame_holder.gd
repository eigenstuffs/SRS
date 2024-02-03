extends Control

class_name MinigameHolder

const MINIGAME_LIST : MinigameList = preload("res://tools/minigames/MinigameList.tres")

var points : int = 0

signal finished(points)

func initiate_minigame(minigame : String):
	var list : Array = MINIGAME_LIST.minigame_list
	var resource : Minigame = list[list.find(minigame)]
	var a = load(resource.scene).instantiate()
	$Game.add_child(a)
	
	if resource.time != 0:
		$UI.gameTimeCount = resource.time
		$UI/GameTimer/TextureProgressBar.max_value = resource.time
		$UI/GameTimer/TextureProgressBar.value = resource.time
		$UI/GameTimer/TimeLabel.text = str(resource.time)
	
	a.connect("update_points", update_points)

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
