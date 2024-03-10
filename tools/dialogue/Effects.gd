extends Node

func _ready():
	var vn : VisualNovelDialogue = get_parent()
	
	vn.connect("fade_black", fade_black)
	
	#signal start_music
#signal boost_stats
#
#signal music_ambience
#signal music_chiptune
#signal music_bgm1
#
#signal stop_music
#
#signal sfx_truck
#signal sfx_screams
#
#signal fade_black
#signal fade_red
#
#signal cg_death
#signal cg_gamestart
#signal cg_god
#
#signal name_player
	#
func fade_black():
	EffectRegistry.start_effect(self, "ColorFade", [$MultiPassShaderRect.material])
	
func fade_red():
	EffectRegistry.start_effect(self, "ColorFade", [$MultiPassShaderRect.material, Color(), Color()])
	await get_tree().create_timer(0.5).timeout
	EffectRegistry.start_effect(self, "ColorFade", [$MultiPassShaderRect.material, Color(), Color.TRANSPARENT])
	
	
	
