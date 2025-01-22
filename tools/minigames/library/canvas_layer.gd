extends CanvasLayer

const FILLED_HEART = preload("res://assets/library/Heart_Filled.png")
const EMPTY_HEART = preload("res://assets/library/Heart_Empty.png")
const COUNTDOWN_TIME: int = 3

var heart_array: Array #life remain
var score: int = 0
var time_remain: int = 0
var countdown_time_remain: int = COUNTDOWN_TIME

func _ready():
	MinigameEventBus.connect("player_hurt", _on_player_hurt)
	MinigameEventBus.connect("player_scored", _on_player_scored)

func init(game_param: Dictionary): #init to be called by the main game
	#Set time
	var total_time = game_param["time"]
	time_remain = total_time
	$UI/GameTimer/TimeLabel.text = str(time_remain)
	$UI/GameTimer/TextureProgressBar.max_value = time_remain
	$UI/GameTimer/TextureProgressBar.value = time_remain
	
	#Set health bar
	var num_of_health = game_param["player_health"]
	for i in range(num_of_health):
		var a = TextureRect.new()
		a.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		a.custom_minimum_size = Vector2(50, 50)
		a.texture = FILLED_HEART
		$HBoxContainer.add_child(a)
		heart_array.append(a)
	
	#Start countdown
	countdown_init()

func remove_heart() -> bool:
	if heart_array.size() > 0:
		heart_array[heart_array.size() - 1].texture = EMPTY_HEART
		heart_array.pop_back()
		if heart_array.size() > 0: return true
		else: return false
	return false

func _on_player_hurt():
	score = 0
	_update_point_label()
	if !remove_heart():
		MinigameEventBus.emit_signal("game_over")
		_on_game_over()

func _on_player_scored():
	score += 1
	_update_point_label()

func _update_point_label():
	$UI/PointLabel.text = str(score)

func _on_game_time_timeout():
	time_remain -= 1
	$UI/GameTimer/TimeLabel.text = str(time_remain)
	$UI/GameTimer/TextureProgressBar.value = time_remain
	if time_remain <= 0:
		MinigameEventBus.emit_signal("times_up")
		$UI/GameTimer/GameTime.stop()

func countdown_init():
	$UI/StartTimer.show()
	$UI/StartTimer/Label.text = str(countdown_time_remain)
	$UI/StartTimer/StartTime.start()

func _on_start_time_timeout():
	countdown_time_remain -= 1
	if countdown_time_remain > 0:
		$UI/StartTimer/Label.text = str(countdown_time_remain)
	elif countdown_time_remain == 0:
		$UI/StartTimer/Label.text = "GO!"
		MinigameEventBus.emit_signal("game_start")
		$UI/GameTimer/GameTime.start()
	else:
		$UI/StartTimer.hide()
		$UI/StartTimer/StartTime.stop()

func _on_game_over():
	$UI/GameTimer/GameTime.stop()
	$UI/StartTimer.show()
	$UI/StartTimer/Label.text = "GAME OVER..."
