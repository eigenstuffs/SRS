extends Control

@onready var flee_anim : AnimationPlayer = $Flee
@onready var progress_bar : ProgressBar = $ProgressBar

var running = false

signal finished

var escaped = false

func initiate():
	progress_bar.value = 10
	flee_anim.play("Enter")
	await flee_anim.animation_finished
	running = true
	scale_text()
	while running:
		progress_bar.value -= 0.1
		if progress_bar.value >= 99.5:
			escaped = true
			running = false
			flee_anim.call_deferred("play", "ExitWon")
			await flee_anim.animation_finished
			emit_signal("finished")
		elif progress_bar.value == 0:
			running = false
			flee_anim.call_deferred("play", "ExitFail")
			await flee_anim.animation_finished
			emit_signal("finished")
		await get_tree().create_timer(0.01).timeout

func _input(event):
	if event.is_action_pressed("ui_accept") and running:
		progress_bar.value += 4

func _process(_delta):
	if running:
		$Node2D.position = Vector2(1408, 576)
		$Node2D.position.x -= (0.09 * (progress_bar.value/0.01))

func scale_text():
	if running:
		$Label["theme_override_font_sizes/font_size"] = 48
		await get_tree().create_timer(0.25).timeout
		$Label["theme_override_font_sizes/font_size"] = 32
		await get_tree().create_timer(0.25).timeout
		scale_text()
