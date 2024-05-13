class_name MinigameHolder extends Control

const MINIGAME_VIEWPORT_DIMS : Vector2 = Vector2(1600, 900)

@onready var ui : Control = $UI

var rough_points : int = 0
var detailed_points : Array = []
var is_finished := false :
	set(value):
		is_finished = value
		ui.sLabel.visible = false

signal finished(detailed_points)
#detailed points should be in the format [array1, array2]
#array 1 should be the detailed score of that minigame, like how many books caught, how many bombs touched, etc.
#array 2 should be an array of four numbers which represent the increment in each stat

var game : Minigame

func initiate_minigame(which : String):	
	if MinigameRegistry.has_key(which):
		var metadata : MinigameInfo = MinigameRegistry.get_metadata(which)
		var minigame : Minigame = load(metadata.scene).instantiate()
		minigame.size = MINIGAME_VIEWPORT_DIMS
		$Game.add_child(minigame)
		minigame.connect("update_points", update_points)
		minigame.connect("update_time", update_time)
		minigame.connect("ended", game_end_early)
		minigame.connect("get_remaining_game", set_game_remaining_time)
		
		if metadata.time <= 0: return
		ui.gameTimeCount = metadata.time
		$UI/GameTimer/TextureProgressBar.max_value = metadata.time
		$UI/GameTimer/TextureProgressBar.value = metadata.time
		$UI/GameTimer/TimeLabel.text = str(metadata.time)
	else:
		printerr("No such minigame %s!" % which)

func _process(delta: float) -> void:
	if is_finished:
		self.scale = Vector2(lerp(self.scale.x, 1.75, delta * 15), lerp(self.scale.y, 1.75, delta * 15))
	

func update_points(new : int):
	rough_points = new
	$UI/PointLabel.text = str(rough_points)
	
func update_time(delta : int):
	$UI.modify_game_time(delta)
	
func get_remaining_time() -> int:
	return $UI.gameTimeCount

func _on_ui_game_over():
	assert(game)
	game.remaining_time = get_remaining_time()
	game.end()
	await get_tree().create_timer(2).timeout
	rough_points = game.rough_points
	detailed_points = game.detailed_points
	finished.emit(detailed_points)
	#game.queue_free()

func _on_game_child_entered_tree(node: Node) -> void:
	if node is Minigame: game = node

func game_end_early(): #assuming that game calls its own end early
	print("game ends early")
	game.remaining_time = get_remaining_time()
	$UI.display_message("Finished!")
	await get_tree().create_timer(2).timeout
	rough_points = game.rough_points
	detailed_points = game.detailed_points
	finished.emit(detailed_points)

func set_game_remaining_time():
	game.remaining_time = get_remaining_time()
