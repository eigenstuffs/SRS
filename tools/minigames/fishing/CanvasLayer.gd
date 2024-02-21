extends CanvasLayer

signal stop_loop
signal reeling_ended(is_successful : bool)

@onready var force_bar : ProgressBar = $ForceBar
@onready var distance_bar : ProgressBar = $DistanceBar
@onready var reel_bar : VScrollBar = $ReelBar
@onready var fish_bar : VScrollBar = $FishBar
@onready var timer : Timer = $Timer
@onready var score_board : Label = $Scoreboard

var min_force_val = 30
var max_force_val = 150

var min_distance_val : float = 0
var base_distance_val : float  = 50
var max_distance_val : float = 100
@export var dist_dec_speed : float = 40
@export var dist_inc_speed : float = 45

var min_reel_val = 0
var max_reel_val = 100
var base_reel_val = 100
@export var reel_speed = 60
@export var reel_size = 20

var base_fish_val = 55
@export var fish_move_interval : float = 1

var movable : bool = false
var fish_caught : int = 0

func _ready():
	force_bar_reset()
	distance_bar_reset()
	reel_bar_reset()
	fish_caught = 0
	movable = false

func _process(delta):
	if movable == true:
		if Input.is_action_pressed("ui_accept"):
			reel_bar.value -= reel_speed * delta
		else:
			reel_bar.value += reel_speed * delta
		if reel_bar.value <= fish_bar.value and reel_bar.value >= fish_bar.value - reel_size:
			distance_bar.value += dist_inc_speed * delta
		else:
			distance_bar.value -= dist_dec_speed * delta

	if distance_bar.value <= min_distance_val:
		distance_bar_reset()
		reel_bar_reset()
		movable = false
		emit_signal("reeling_ended", false)
	if distance_bar.value >= max_distance_val:
		distance_bar_reset()
		reel_bar_reset()
		movable = false
		emit_signal("reeling_ended", true)

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

# the resets
func force_bar_reset():
	force_bar.visible = false
	force_bar.value = min_force_val

func distance_bar_reset():
	distance_bar.visible = false
	distance_bar.value = base_distance_val
	
func reel_bar_reset():
	reel_bar.visible = false
	reel_bar.value = base_reel_val
	reel_bar.page = reel_size
	fish_bar.visible = false
	fish_bar.value = base_fish_val

# the activate
func distance_bar_activate():
	distance_bar.visible = true

func reel_bar_activate():
	reel_bar.visible = true
	fish_bar.visible = true
	fish_bar.value = base_fish_val

func _on_fishing_reeling_minigame():
	distance_bar_activate()
	reel_bar_activate()
	movable = true
	timer.start(fish_move_interval)

func _on_timer_timeout():
	#this can be even more polished by making the fish move in a relative range instead of an absolute range
	var a = create_tween()
	var current_value = fish_bar.value
	a.tween_property(fish_bar, "value", randi_range(current_value - 30, current_value + 30), fish_move_interval)

func _on_reeling_ended(is_successful):
	timer.stop()
	if is_successful:
		fish_caught += 1
		score_board.text = "Fish Caught x" + str(fish_caught)
