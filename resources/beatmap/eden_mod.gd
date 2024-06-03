class_name EdenMod extends BeatmapMod

static var TIMING_ACTIONS = [
	[ 6.927, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
	[ 10.355, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
	[ 10.355 , 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 0.0, 1.0, 0.5, 12.927 - 10.355])],
	[ 12.927 , 'playfield', func(playfield): 
		EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
		EffectReg.free_effect('Bloom')],
	[ 14.212, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
	[ 14.641, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
	#[ 15.070, 'playfield', func(playfield): 
		#EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
		#EffectReg.start_effect(playfield, 'ImpactLines', [playfield.effects, 0.7, 0.7])
		#EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 1.0, 0.3, 999999.0])],
	#[ 16.355, 'playfield', func(playfield): 
		#EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
		#EffectReg.free_effect('ImpactLines')
		#EffectReg.free_effect('Bloom')],
	[ 16.784, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
	[ 17.212, 'playfield', func(playfield): 
		EffectReg.start_effect(playfield, 'Vignette', [playfield.effects])
		EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 2.0])
		EffectReg.free_effect('InteriorWarm')],
	[ 17.212,    'screen', 'enable', ['greyscale']],
	
	#[ 25.784, 'playfield', func(playfield): 
		#EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
		#EffectReg.free_effect('Vignette')],
	#[ 25.784,    'screen', 'disable', ['greyscale']],
	[ 30.927, 'playfield', func(playfield): 
		EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
		#EffectReg.start_effect(playfield, 'Vignette', [playfield.effects])
		EffectReg.start_effect(playfield, 'InteriorWarm', [playfield.effects])],
	#[ 30.927,    'screen', 'enable', ['greyscale']],
	
	[ 58.355, 'playfield', func(playfield): 
		EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
		EffectReg.free_effect('Vignette')
		EffectReg.free_effect('InteriorWarm')],
	[ 58.355,    'screen', 'disable', ['greyscale']],
	[ 58.355,    'screen', 'disable', ['Clouds']],
	
	[ 85.784, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
	[ 99.498, 'playfield', func(playfield): 
		EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
		EffectReg.start_effect(playfield, 'ImpactLines', [playfield.effects, 0.7, 0.7])],
	[ 108.07, 'playfield', func(playfield): 
		EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
		EffectReg.free_effect('ImpactLines')],
		
	[ 113.212, 'playfield', func(playfield): 
		EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
		EffectReg.start_effect(playfield, 'ImpactLines', [playfield.effects, 0.7, 0.7])],
	[ 121.784, 'playfield', func(playfield): 
		EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])
		EffectReg.free_effect('ImpactLines')],
	[ 140.64, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])],
	#[ 10.355, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
	#[ 10.355, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
	#[ 10.355, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
	#[ 10.355, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 0.8])],
		
]

func get_timing_actions(playfield : RhythmPlayfield) -> Array[TimingAction]:
	EffectReg.start_effect(playfield, 'InteriorWarm', [playfield.effects])
	# FIXME: This is yucky! Seriously,
	var actions : Array[TimingAction] = []
	for action in TIMING_ACTIONS:
		var target : Variant = playfield.screen_space_material if action[1] == 'screen' else playfield.backplane_material if action[1] == 'back' else playfield
		if action[2] is Callable:
			actions.push_back(CallbackAction.new(action[0], action[2], [target]))
		elif action[2] == 'enable':
			actions.push_back(ShaderPassAction.new(action[0], target, ShaderPassAction.State.ENABLE, action[3]) if len(action) == 4 \
				else ShaderPassAction.new(action[0], target, ShaderPassAction.State.ENABLE, action[3], action[4]))
		elif action[2] == 'disable':
			actions.push_back(ShaderPassAction.new(action[0], target, ShaderPassAction.State.DISABLE, action[3]))
	return actions
