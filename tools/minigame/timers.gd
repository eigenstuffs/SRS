extends Control

signal startTimeOver
signal gameOver

@export var startTimeCount = 3
@export var gameTimeCount = 60
@onready var sTime: Timer = $StartTimer/StartTime
@onready var sLabel: Label = $StartTimer/Label
@onready var gTime: Timer = $GameTimer/GameTime
@onready var gLabel: Label = $GameTimer/TimeLabel
@onready var gBar : TextureProgressBar = $GameTimer/TextureProgressBar

func _ready():
	sTime.start()
	sLabel.show()

func _on_start_time_timeout():
	startTimeCount -= 1
	if (startTimeCount==0):
		sTime.stop()
		sLabel.text = "Start!"
		await(get_tree().create_timer(1.0).timeout)
		sLabel.hide()
		startTimeOver.emit()
	else:
		sLabel.text = str(startTimeCount)

func _on_start_time_over():
	gLabel.show()
	if is_instance_valid(gTime): gTime.start()

func _on_game_time_timeout():
	gameTimeCount -= 1
	if gameTimeCount <= 0:
		gTime.stop()
		gLabel.hide()
		sLabel.show()
		sLabel.text = "Finished!"
		emit_signal("gameOver")
	else:
		gLabel.text = str(gameTimeCount)
		gBar.value = gameTimeCount
		

func modify_game_time(delta : int):
	gameTimeCount += delta
	gLabel.text = str(gameTimeCount)
	gBar.value = gameTimeCount
	
func display_message(msg : String):
	sLabel.text = msg
	sLabel.show()
