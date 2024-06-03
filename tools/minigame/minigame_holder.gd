class_name MinigameHolder extends Control

const MINIGAME_VIEWPORT_DIMS : Vector2 = Vector2(1600, 900)
const TUTORIAL_LIST = preload("res://resources/minigame/tutorial_list.tres")

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
var start

func initiate_minigame(which : String):	
	if MinigameRegistry.has_key(which):
		var metadata : MinigameInfo = MinigameRegistry.get_metadata(which)
		var minigame : Minigame = load(metadata.scene).instantiate()
		minigame.size = MINIGAME_VIEWPORT_DIMS
		$Game.add_child(minigame)
		minigame.update_points.connect(update_points)
		minigame.update_time.connect(update_time)
		minigame.ended.connect(game_end_early)
		minigame.get_remaining_time.connect(set_game_remaining_time)
		# very cursed, but no time to improve!
		start = func():
			if Global.data_dict["remembered"].has(which):
				$UI.start_sTime()
			else:
				show_tutorial(which)
		
			ui.gameTimeCount = metadata.time
			$UI/StartTimer.visible = true
			$UI/GameTimer/TextureProgressBar.max_value = metadata.time
			$UI/GameTimer/TextureProgressBar.value = metadata.time
			$UI/GameTimer/TimeLabel.text = str(metadata.time)
		
		if metadata.time > 0: start.call()
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
	if is_finished: return
	game.remaining_time = get_remaining_time()
	game.end()
	await game.minigame_finished
	rough_points = game.rough_points
	detailed_points = game.detailed_points
	finished.emit(detailed_points)
	#EffectReg.start_effect(self, 'Blur', [self])
	is_finished = true

func _on_game_child_entered_tree(node: Node) -> void:
	if node is Minigame: game = node

func game_end_early(): #assuming that game calls its own end early
	print("game ends early")
	pause_time()
	game.remaining_time = get_remaining_time()
	$UI.display_message("Finished!")
	await game.minigame_finished
	rough_points = game.rough_points
	detailed_points = game.detailed_points
	finished.emit(detailed_points)
	#EffectReg.start_effect(self, 'Blur', [self])
	is_finished = true

func set_game_remaining_time():
	game.remaining_time = get_remaining_time()
	
func _physics_process(delta: float) -> void:
	RenderingServer.global_shader_parameter_set('cpu_sync_time', Time.get_ticks_usec()*1e-6)

func pause_time():
	$UI.pause_game_time()

func show_tutorial(which : String):
	var desired_tutorial = TUTORIAL_LIST.find_scene(which)
	var a : Tutorial = desired_tutorial.instantiate()
	$Tutorial.add_child(a)
	await a.confirm_pressed
	a.queue_free()
	$UI.start_sTime()
	Global.add_event(which)

func _on_ui_start_time_over():
	game.game_start()
