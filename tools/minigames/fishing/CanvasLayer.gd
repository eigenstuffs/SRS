extends CanvasLayer

@onready var force_bar : ProgressBar = $ForceBar

var min_force_val = 30
var max_force_val = 150
var is_running : bool = false

func _ready():
	force_bar.value = min_force_val

func _process(delta):
	pass

func _on_fishing_player_casting_time():
	var a = create_tween()
	a.tween_property(force_bar, "value", max_force_val, 1)
	a.tween_property(force_bar, "value", min_force_val, 1)
