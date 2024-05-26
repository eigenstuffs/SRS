class_name TangoMod
## This is a very rough version of how a 'modfile' can be loaded to sync different
## effects with a beatmap.

# TODO: erm, delete me and this file later please
static var TIMING_ACTIONS = [
	[  0.865, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  0.865, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  1.380, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  1.894, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
	[  2.237, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  2.751, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  3.226, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
	[  3.608, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  3.866, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  4.123, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  4.466, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  4.637, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  4.980, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  5.494, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.0, 1.0, 0.6, 0.685])],
	[  6.351, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])
		EffectRegistry.free_effect('Bloom')],
	[  6.351,    'screen', 'enable', ['greyscale']],
	#[  5.666, 'playfield', func(playfield): 
		#EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.0, 1.0, 0.5, 0.685])],
	[ 13.208, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.4])],
	[ 13.551, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
	[ 14.480 , 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.0, 1.0, 0.6, 1.0])],
	[ 15.608, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[ 15.780, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0 ), 0.4])
		EffectRegistry.free_effect('Bloom')],
	[ 17.323, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.4])
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 1.0, 0.4, 99999999.0])
		for key in playfield.keys: 
			key.enable_note_shader_pass('warp')
			key.enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))],
	[ 17.323,    'screen', 'disable', ['greyscale']],
	[ 17.323,      'back', 'enable', ['radial_pattern']],
	
	[ 24.180, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.4])],
	[ 24.866, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
	
	#[ 17.323,    'screen',  'enable', ['flash', 'rain']],
	[ 73.133,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 73.712,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 74.992,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 75.230,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 75.406,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 75.615,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 76.746,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 77.060,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 77.361,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 77.970,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 78.274,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 78.572,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 79.755,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 80.601,    'screen',  'enable', ['flash'], [{'factor' : 0.05}]],
	[ 81.418,    'screen',  'enable', ['flash', 'impact_lines'], [{'factor' : 0.5, 'duration': 0.6}, {'weight' : 0.6, 'max_alpha' : 0.95}]],
	[ 81.418,      'back', 'disable', ['radial_pattern']],
	[ 81.418,    'screen', 'disable', ['greyscale']],
	[ 81.418, 'playfield', func(playfield): 
		for key in playfield.keys: 
			key.disable_note_shader_pass('warp')
			key.disable_note_color_overwrite()],
	[105.968,    'screen', 'enable',  ['flash']],
	[105.968,    'screen', 'disable', ['rain', 'impact_lines']]]

static func get_timing_actions(playfield : RhythmPlayfield) -> Array[TimingAction]:
	# FIXME: This is yucky! Seriously,
	var actions : Array[TimingAction] = []
	for action in TangoMod.TIMING_ACTIONS:
		var target : Variant = playfield.screen_space_material if action[1] == 'screen' else playfield.backplane_material if action[1] == 'back' else playfield
		if action[2] is Callable:
			actions.push_back(CallbackAction.new(action[0], action[2], [target]))
		elif action[2] == 'enable':
			actions.push_back(ShaderPassAction.new(action[0], target, ShaderPassAction.State.ENABLE, action[3]) if len(action) == 4 \
				else ShaderPassAction.new(action[0], target, ShaderPassAction.State.ENABLE, action[3], action[4]))
		elif action[2] == 'disable':
			actions.push_back(ShaderPassAction.new(action[0], target, ShaderPassAction.State.DISABLE, action[3]))
	return actions
