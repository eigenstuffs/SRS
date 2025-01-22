extends Minigame2D

var book_num: int = 0
var bomb_num: int = 0

func _ready():
	MinigameEventBus.connect("game_start", _on_game_start)
	MinigameEventBus.connect("game_over", _on_game_over)
	MinigameEventBus.connect("times_up", _on_times_up)
	
	$LibraryPlayer2D.can_move = false
	$ItemSpawner.active = false
	
	var game_param: Dictionary = {"type": type, "time": time, "player_health": player_health}
	$LibraryCanvas.init(game_param)

func toggle_movement(state: bool):
	$LibraryPlayer2D.can_move = state
	$ItemSpawner.active = state
	
func _on_game_start():
	toggle_movement(true)

func _on_game_over():
	$LibraryPlayer2D.failed = true
	_end()

func _on_times_up():
	_end()

func _end():
	toggle_movement(false)
	book_num = $LibraryCanvas.score
	bomb_num = player_health - $LibraryCanvas.heart_array.size()
	var stats_gained = _calculate_score()
	
	await get_tree().create_timer(2.5).timeout
	await create_reward_scene([book_num, bomb_num], stats_gained, $RewardLayer)
	return_to_previous_scene()
	
func _calculate_score():
	#NOTICE: Prob not the most balanced scheme; to be worked optimized
	
	var int_gained = max(0, roundi(book_num * 0.3 - bomb_num * 0.1))
	var well_gained = max(0, roundi(book_num * 0.2 - bomb_num * 0.05))
	return [0, int_gained, 0, well_gained]
