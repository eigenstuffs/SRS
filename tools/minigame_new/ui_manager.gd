extends CanvasLayer

@onready var tutorial_holder: Control = $TutorialHolder
@onready var point_label: Label = $TimeBar/PointLabel
@onready var time_label: Label = $TimeBar/TimeLabel
@onready var countdown_label: Label = $CountdownLabel

var ready_timer_source: Timer = null
var game_timer_source: Timer = null

func show_tutorial():
	tutorial_holder.visible = true

func show_game_ui():
	tutorial_holder.visible = false
	point_label.visible = true
	time_label.visible = true
	countdown_label.visible = false # Hide countdown once game starts

func update_points(points: int):
	point_label.text = str(points)

func set_ready_timer_source(timer: Timer):
	ready_timer_source = timer
	countdown_label.visible = true

func set_game_timer_source(timer: Timer):
	game_timer_source = timer
	time_label.visible = true

func clear_timers():
	ready_timer_source = null
	game_timer_source = null
	countdown_label.visible = false
	time_label.visible = false

func _process(_delta):
	if ready_timer_source and not ready_timer_source.is_stopped():
		countdown_label.text = str(int(ceil(ready_timer_source.time_left)))
	elif countdown_label.visible:
		countdown_label_show_text("Go!")

	if game_timer_source and not game_timer_source.is_stopped():
		time_label.text = str(int(ceil(game_timer_source.time_left)))
	elif time_label.visible:
		time_label.visible = false
		if !countdown_label.visible:
			countdown_label_show_text("Times up!")

var is_busy: bool = false

func countdown_label_show_text(text: String):
	if is_busy:
		return
	is_busy = true
	countdown_label.text = text
	countdown_label.visible = true
	await get_tree().create_timer(1).timeout
	countdown_label.visible = false
	is_busy = false
