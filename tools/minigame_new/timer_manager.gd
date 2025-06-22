extends Node

@onready var ready_timer := $ReadyTimer
@onready var game_timer := $GameTimer

func start_ready_timer(duration: float):
	ready_timer.wait_time = duration
	ready_timer.start()

func start_game_timer(duration: float):
	game_timer.wait_time = duration
	game_timer.start()
