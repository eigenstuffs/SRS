extends Control

const VN = preload("res://tools/dialogue/vn_dialogue.tscn")

func _ready():
	EffectAnim.play_backwards("FadeBlack")

func _on_texture_button_pressed():
	EffectAnim.play("FadeBlack")
	await EffectAnim.animation_finished
	
	get_tree().change_scene_to_packed(VN)

func _on_library_pressed():
	Util.create_minigame($CanvasLayer, "Library")

func _on_fishing_pressed():
	Util.create_minigame($CanvasLayer, "Fishing")

func _on_rhythm_pressed():
	Util.create_minigame($CanvasLayer, "Rhythm")
	
func _process(_delta):
	if $CanvasLayer.get_child_count() > 0:
		$TextureButton.disabled = true
		$Library.disabled = true
		$Fishing.disabled = true
		$Rhythm.disabled = true
	else:
		$TextureButton.disabled = false
		$Library.disabled = false
		$Fishing.disabled = false
		$Rhythm.disabled = false
