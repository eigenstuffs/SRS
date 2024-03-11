extends Control

const VN = preload("res://tools/dialogue/vn_dialogue.tscn")

func _ready():
	EffectAnim.play_backwards("FadeBlack")

func _on_texture_button_pressed():
	EffectAnim.play("FadeBlack")
	await EffectAnim.animation_finished
	
	get_tree().change_scene_to_packed(VN)
	
