extends Node

class_name Minigame
signal game_started
signal game_ended(score)

@export var minigame_name: String = "Default Name"
@export var ready_time := 3.0
@export var game_duration := 30.0

var is_game_running := false

@onready var timer_manager := $TimerManager
@onready var ui_manager := $UIManager
@onready var game_manager: Node = $GameManager #custom game manager for each minigame

func _ready():
	_show_tutorial()
	ui_manager.set_ready_timer_source(timer_manager.ready_timer)
	timer_manager.start_ready_timer(ready_time)
	timer_manager.ready_timer.timeout.connect(_on_ready_timer_timeout)
	timer_manager.game_timer.timeout.connect(_on_game_timer_timeout)

func _on_ready_timer_timeout():
	_start_game()

func _start_game():
	is_game_running = true
	emit_signal("game_started")
	ui_manager.set_game_timer_source(timer_manager.game_timer)
	timer_manager.start_game_timer(game_duration)
	if game_manager.has_method("start_game"):
		game_manager.start_game()
	ui_manager.show_game_ui()

func _on_game_timer_timeout():
	_end_game()

func _end_game():
	is_game_running = false
	ui_manager.clear_timers()
	var rough_score = get_rough_score()
	var stats_gained = calculate_stats_gained()
	emit_signal("game_ended", stats_gained)
	Util.create_reward_scene(minigame_name, rough_score, stats_gained, $ResultsLayer)

func _show_tutorial():
	ui_manager.show_tutorial()

func get_rough_score():
	if game_manager.has_method("get_rough_score"):
		return game_manager.get_rough_score()
	return [0]

func calculate_stats_gained():
	if game_manager.has_method("calculate_stats_gained"):
		return game_manager.calculate_stats_gained()
	return [0, 0, 0, 0]
