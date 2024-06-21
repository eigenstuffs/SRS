extends HBoxContainer

@onready var offense : TextureProgressBar = $Offense
@onready var defense : TextureProgressBar = $Defense

func _process(delta):
	var offense_bar_percentage : float = (offense.value - offense.min_value) / (offense.max_value - offense.min_value)
	offense.tint_progress = Color(1 * (1 - max(0, (offense_bar_percentage - 0.5) * 2)), offense_bar_percentage * 2, 0, 0.75)
	var defense_bar_percentage : float = (defense.value - defense.min_value) / (defense.max_value - defense.min_value)
	defense.tint_progress = Color(1 * (1 - max(0, (defense_bar_percentage - 0.5) * 2)), defense_bar_percentage * 2, 0, 0.75)
