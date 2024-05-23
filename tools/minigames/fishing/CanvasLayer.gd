extends CanvasLayer

signal stop_loop
signal reeling_ended(is_successful : bool)

const MISS = preload("res://tools/minigames/fishing/sounds/miss.mp3")
const HOOKED = preload("res://tools/minigames/fishing/sounds/hooked.mp3")
const CAUGHT = preload("res://tools/minigames/fishing/sounds/fish_caught.mp3")

@onready var ROD_TYPE : FishingRodTypes = preload("res://tools/minigames/fishing/Inventory/types_of_rod.tres")
@onready var force_bar : TextureProgressBar = $ForceBarBackground/ForceBar
@onready var force_bar_area = $ForceBarBackground
@onready var distance_bar : TextureProgressBar = $ReelBarBackground/DistanceBar
@onready var reel_bar_area = $ReelBarBackground
@onready var reel_bar : VScrollBar = $ReelBarBackground/ReelBar
@onready var fish_bar : VScrollBar = $ReelBarBackground/FishBar
@onready var timer : Timer = $Timer
@onready var exclaim : TextureRect = $FishCaught
@onready var miss : TextureRect = $Miss
@onready var plus_one : TextureRect = $PlusOne

var min_force_val = 30
var max_force_val = 150

var min_distance_val : float = 0
var base_distance_val : float  = 50
var max_distance_val : float = 100
@export var default_dist_dec_speed : float = 30
var starting_dist_dec_speed : float = 10
@export var dist_inc_speed : float = 45
var bite_strength_multiplier : float = 1 
var rod_strength_multiplier : float = 1

var min_reel_val = 0
var max_reel_val = 100
var base_reel_val = 100
@export var reel_speed = 60
@export var reel_size = 20
var size_multiplier : float = 1

var base_fish_val = 55
@export var fish_move_interval : float = 1
var fish_speed_multiplier : float = 1

var movable : bool = false
var current_fish_rarity : String
var reeling_now : bool = false
var first_entered : bool = false

func _ready():
	icons_reset()
	rod_strength_multiplier = ROD_TYPE.get_current_rod("reel_strength")
	size_multiplier = ROD_TYPE.get_current_rod("reel_size")
	force_bar_reset()
	reel_bar_reset()
	movable = false

func _process(delta):
	#FIXME: somehow if multipliers too small the bar won't increase/decrease at all (fixed with larger num but still want them to be smaller
	if movable == true:
		if Input.is_action_pressed("ui_accept"):
			reel_bar.value -= reel_speed * delta
		else:
			reel_bar.value += reel_speed * delta
		if reel_bar.value <= fish_bar.value and reel_bar.value >= fish_bar.value - (reel_size * size_multiplier):
			if !first_entered:
				first_entered = true
			distance_bar.value += dist_inc_speed * rod_strength_multiplier * delta
		else:
			var dist_dec_speed : float
			if first_entered:
				dist_dec_speed = default_dist_dec_speed
			else:
				dist_dec_speed = starting_dist_dec_speed
			distance_bar.value -= dist_dec_speed * bite_strength_multiplier * delta

	if distance_bar.value <= min_distance_val:
		reel_bar_reset()
		movable = false
		emit_signal("reeling_ended", false, current_fish_rarity)
	if distance_bar.value >= max_distance_val:
		reel_bar_reset()
		movable = false
		emit_signal("reeling_ended", true, current_fish_rarity)
		
	#update the progress bars' tint
	var force_bar_percentage : float = (force_bar.value - min_force_val) / (max_force_val - min_force_val)
	force_bar.tint_progress = Color(1 * (1 - max(0, (force_bar_percentage - 0.5) * 2)), force_bar_percentage * 2, 0, 0.75)
	var dist_bar_percentage : float = (distance_bar.value - min_distance_val) / (max_distance_val - min_distance_val)
	distance_bar.tint_progress = Color(1 * (1 - max(0, (dist_bar_percentage - 0.5) * 2)), dist_bar_percentage * 2, 0, 0.75)

func _on_fishing_player_casting_time():
	force_bar.value = min_force_val
	force_bar_area.visible = true
	bar_animation()

func bar_animation():
	var a = create_tween().set_loops()
	a.tween_property(force_bar, "value", max_force_val, 1)
	a.tween_property(force_bar, "value", min_force_val, 1)
	await stop_loop
	a.kill()	

# the resets
func force_bar_reset():
	force_bar_area.visible = false
	force_bar.value = min_force_val
	
	
func reel_bar_reset():
	reel_bar_area.visible = false
	reel_bar.value = base_reel_val
	reel_bar.page = reel_size * size_multiplier
	fish_bar.value = base_fish_val
	distance_bar.value = base_distance_val

# the activate

func reel_bar_activate():
	reel_bar_area.visible = true
	fish_bar.value = base_fish_val
	first_entered = false

func _on_fishing_reeling_minigame():
	if !reeling_now:
		reeling_now = true
		show_and_fade_icon(exclaim)
		$SfxPlayer.stream = HOOKED
		$SfxPlayer.play()
		await get_tree().create_timer(0.5).timeout
		reel_bar_activate()
		movable = true
		timer.start(fish_move_interval)

func _on_timer_timeout():
	#this can be even more polished by making the fish move in a relative range instead of an absolute range
	var a = create_tween()
	var current_value = fish_bar.value
	a.tween_property(fish_bar, "value", randi_range(current_value - 30, current_value + 30), fish_move_interval * fish_speed_multiplier)

func _on_reeling_ended(is_successful, current_fish_rarity):
	timer.stop()
	reeling_now = false
	if is_successful:
		show_and_fade_icon(plus_one)
		$SfxPlayer.stream = CAUGHT
		$SfxPlayer.play()
	else:
		show_and_fade_icon(miss)
		$SfxPlayer.stream = MISS
		$SfxPlayer.play()

#change bite_strength_multiplier
func _on_fish_instancer_first_fish_info(bite_strength, speed, rarity):
	bite_strength_multiplier = bite_strength
	fish_speed_multiplier = 1/speed
	current_fish_rarity = rarity

func get_force_bar_val():
	return force_bar.value

func show_and_fade_icon(node : Control):
	node.self_modulate.a = 1
	var b = create_tween().set_parallel()
	b.tween_property(node, "self_modulate:a", 0, 0.75)
	if node != exclaim:
		b.tween_property(node, "position:y", node.position.y - 50, 0.75)
		await b.finished
		node.position.y = node.position.y + 50

func icons_reset():
	exclaim.self_modulate.a = 0
	miss.self_modulate.a = 0
	plus_one.self_modulate.a = 0


func _on_fishing_player_releasing_rod():
	emit_signal("stop_loop")
	force_bar_reset()
