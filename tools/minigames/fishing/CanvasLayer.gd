extends CanvasLayer

signal stop_loop
signal reeling_failed
signal reeling_success

@onready var force_bar : ProgressBar = $ForceBar
@onready var distance_bar : ProgressBar = $DistanceBar

var min_force_val = 30
var max_force_val = 150

var min_distance_val : float = 0
var base_distance_val : float  = 50
var max_distance_val : float = 100
var distance_movable : bool = false
@export var dist_dec_speed : float = 10
@export var dist_inc_speed : float = 10


func _ready():
	force_bar_reset()
	distance_bar_reset()

func _process(delta):
	if distance_movable == true:
		if Input.is_action_pressed("ui_accept"):
			distance_bar.value += dist_inc_speed * delta
		else:
			distance_bar.value -= dist_dec_speed * delta
	if distance_bar.value <= min_distance_val:
		distance_bar_reset()
		emit_signal("reeling_failed")
	if distance_bar.value >= max_distance_val:
		distance_bar_reset()
		emit_signal("reeling_success")

func _on_fishing_player_casting_time():
	force_bar.value = min_force_val
	force_bar.visible = true
	bar_animation()

func bar_animation():
	var a = create_tween().set_loops()
	a.tween_property(force_bar, "value", max_force_val, 1)
	a.tween_property(force_bar, "value", min_force_val, 1)
	await stop_loop
	a.kill()

func _on_fishing_player_fishing_time():
	emit_signal("stop_loop")
	force_bar_reset()

func force_bar_reset():
	force_bar.visible = false
	force_bar.value = min_force_val

func distance_bar_reset():
	distance_bar.visible = false
	distance_bar.value = base_distance_val
	distance_movable = false

func _on_fishing_reeling_minigame():
	distance_bar.visible = true
	distance_movable = true
	
