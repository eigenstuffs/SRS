extends Control

var size_decay_speed := 5.0
var angle_decay_speed := 0.6666666

func _ready() -> void:
	$ScoreLabel.label_settings = $ScoreLabel.label_settings.duplicate()

func update_combo_text(new_combo : int) -> void:
	var combo_string = '' if new_combo == 0 else str(new_combo)
	
	if $ComboLabel.text != combo_string:
		$ComboLabel.scale = Vector2(1.5, 1.5)
	$ComboLabel.text = combo_string
	
func update_score_text(new_score : String, score_color : Color) -> void:
	if $ScoreLabel.text == new_score:
		$ScoreLabel.scale = Vector2(1.2, 1.2)
		return
	$ScoreLabel.scale = Vector2(1.5, 1.5)
	$ScoreLabel.text = new_score
	$ScoreLabel.label_settings.font_color = score_color
	$ScoreLabel.rotation = randf_range(-0.15, 0.15)

func _physics_process(delta: float) -> void:
	$ComboLabel.scale = Vector2(maxf(1.0, $ComboLabel.scale.x - delta*size_decay_speed), maxf(1.0, $ComboLabel.scale.y - delta*size_decay_speed))
	$ScoreLabel.scale = Vector2(maxf(1.0, $ScoreLabel.scale.x - delta*size_decay_speed), maxf(1.0, $ScoreLabel.scale.y - delta*size_decay_speed))
	if $ScoreLabel.rotation != 0:
		var use_min := signf($ScoreLabel.rotation) == -1
		$ScoreLabel.rotation -= signf($ScoreLabel.rotation) * delta*angle_decay_speed
		$ScoreLabel.rotation = min(0.0, $ScoreLabel.rotation) if use_min else max(0.0, $ScoreLabel.rotation)
