extends Node

signal ready_timer_done
signal game_timer_done

@onready var ready_timer := $ReadyTimer
@onready var game_timer := $GameTimer

func start_ready_timer(duration: float):
	ready_timer.wait_time = duration
	ready_timer.start()

func start_game_timer(duration: float):
	game_timer.wait_time = duration
	game_timer.start()

# give a one second buffer for UI
func _on_ready_timer_timeout() -> void:
	await get_tree().create_timer(1).timeout
	ready_timer_done.emit()

func _on_game_timer_timeout() -> void:
	await get_tree().create_timer(1).timeout
	game_timer_done.emit()
