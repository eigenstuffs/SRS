extends CanvasLayer

@onready var force_bar : ProgressBar = $ForceBar

var min_force_val = 30
var max_force_val = 150
var bar_active : bool = false

func _ready():
	force_bar.value = min_force_val
	force_bar.visible = false

func _process(delta):
	pass

func _on_fishing_player_casting_time():
	force_bar.visible = true
	bar_animation()

func bar_animation():
	force_bar.value = min_force_val
	var a = create_tween().set_loops()
	a.tween_property(force_bar, "value", max_force_val, 1)
	a.tween_property(force_bar, "value", min_force_val, 1)

func _on_fishing_player_fishing_time():
	force_bar.visible = false
