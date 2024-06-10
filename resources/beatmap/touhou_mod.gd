class_name TouhouMod extends BeatmapMod

static var TIMING_ACTIONS = [
[ 1.853, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 16.853 + 0.469*0, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*1, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*2, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*3, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*4, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*5, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*6, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*7, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*8, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*9, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*10, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*11, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*12, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*13, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.8])],
[ 16.853 + 0.469*14, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 16.853 + 0.469*15, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
#[ 22.713 + 0.234*3, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
#[ 22.713 + 0.234*4, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
#[ 22.713 + 0.234*5, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
#[ 22.713 + 0.234*6, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 16.853 + 0.469*16, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*8, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*9, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*10, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*11, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*12, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*13, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*14, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*15, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*16, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*17, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*18, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*19, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*20, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*21, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*22, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*23, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*24, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*25, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*26, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*27, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*28, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*29, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*30, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 22.713 + 0.234*31, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
#[ 31.619, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])], 
[ 39.353,    'screen', 'enable', ['greyscale']],
[ 39.353, 'playfield', func(playfield): 
	EffectReg.start_effect(playfield, 'Vignette', [playfield.effects])
	EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 2.0])],
[ 40.759 , 'playfield', func(playfield): 
	EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
	EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.3, 41.228 - 40.759])],
#[ 41.228 , 'playfield', func(playfield): 
	#EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
	#EffectReg.free_effect('Bloom')],
[ 44.978, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])],
[ 45.447, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])],
[ 45.916, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])],
[ 46.384, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])],
[ 48.259 , 'playfield', func(playfield): 
	EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
	EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.3, 48.728 - 48.259])],
#[ 48.728 , 'playfield', func(playfield): 
	#EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
	#EffectReg.free_effect('Bloom')],
[ 52.478, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])],
[ 52.947, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])],
[ 53.416, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])],
[ 53.844, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])],
[ 54.353, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(1.0,1.0,1.0, 1.0), 2.0])],
[ 61.853, 'playfield', func(playfield): 
	EffectReg.start_effect(playfield, 'InteriorWarm', [playfield.effects])
	EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
[ 69.119, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 74.978, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])],
[ 75.447, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])],
[ 75.916, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])],
[ 76.384, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])],
[ 84.353, 'playfield', func(playfield): 
	EffectReg.free_effect('InteriorWarm')
	EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 84.353,    'screen', 'disable', ['greyscale']],
[ 84.353,    'back', 'enable', ['Clouds']],
[ 103.103, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 133.103, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 138.728, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 139.197, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 139.666, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 140.134, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 146.228, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 146.697, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 147.166, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 147.634, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 148.103, 'playfield', func(playfield): 
	EffectReg.start_effect(playfield, 'Sepia', [playfield.effects])
	EffectReg.start_effect(playfield, 'Vignette', [playfield.effects])
	EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 148.103,    'back', 'disable', ['Clouds']],
[ 162.166, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 0.0, 1.0, 0.5, 163.103 - 162.166])],
	#EffectReg.free_effect('Sepia')],
# [ 162.166 bloom
[ 163.103, 'playfield', func(playfield): 
	EffectReg.free_effect('Vignette')
	EffectReg.free_effect('Bloom')
	EffectReg.free_effect('Sepia')
	EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
[ 163.103,    'back', 'enable', ['Clouds']],
# [ 163.103 bloom off, sepia off, cloud on
# [ 191.228 bloom grow
[ 191.228, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 0.0, 1.0, 0.8, 191.228 - 193.103])],

[ 193.103, 'playfield', func(playfield): 
	EffectReg.free_effect('Bloom')
	EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.8, 1.0])
	EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(1.0,1.0,1.0, 1.0), 2.5])],
]

func get_timing_actions(playfield : RhythmPlayfield) -> Array[TimingAction]:
	playfield.find_child('Fumo').visible = true
	
	EffectReg.start_effect(playfield, 'InteriorWarm', [playfield.effects])
	EffectReg.start_effect(playfield, 'BetterCall', [playfield])
	
	# FIXME: This is yucky! Seriously,
	var actions : Array[TimingAction] = []
	for action in TIMING_ACTIONS:
		var target : Variant = playfield.screen_space_material if action[1] == 'screen' else playfield.backplane_material if action[1] == 'back' else playfield
		if not Global.meta_data_dict["effect_on"] and action[1] == 'back':
			continue
		if action[2] is Callable:
			actions.push_back(CallbackAction.new(action[0], action[2], [target]))
		elif action[2] == 'enable':
			actions.push_back(ShaderPassAction.new(action[0], target, ShaderPassAction.State.ENABLE, action[3]) if len(action) == 4 \
				else ShaderPassAction.new(action[0], target, ShaderPassAction.State.ENABLE, action[3], action[4]))
		elif action[2] == 'disable':
			actions.push_back(ShaderPassAction.new(action[0], target, ShaderPassAction.State.DISABLE, action[3]))
	return actions
