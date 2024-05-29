class_name CaitSithMod
## This is a very rough version of how a 'modfile' can be loaded to sync different
## effects with a beatmap.

# TODO: erm, delete me and this file later please
static var TIMING_ACTIONS = [
	[ 0.000, 'playfield', func(playfield): pass],
		#for key in playfield.keys: 
			#key.enable_note_shader_pass('warp')
			#key.enable_note_color_overwrite(Color(0.2, 0.1, 0.5, 1.0))
		#EffectReg.start_effect(playfield, 'Blur', [playfield.screen_space_material])],
		#pass],
		
		
	[ 2.535, 'playfield', func(playfield):
		EffectReg.start_effect(playfield, 'BetterCall', [playfield])],
		
		
		
	[ 2.535, 'screen', 'enable', ['flash'], [{'factor' : 0.7, 'duration': 2.0}]],]

static func get_timing_actions(playfield : RhythmPlayfield) -> Array[TimingAction]:
	# FIXME: This is yucky! Seriously,
	var actions : Array[TimingAction] = []
	for action in CaitSithMod.TIMING_ACTIONS:
		var target : Variant = playfield.screen_space_material if action[1] == 'screen' else playfield.backplane_material if action[1] == 'back' else playfield
		if action[2] is Callable:
			actions.push_back(CallbackAction.new(action[0], action[2], [target]))
		elif action[2] == 'enable':
			actions.push_back(ShaderPassAction.new(action[0], target, ShaderPassAction.State.ENABLE, action[3]) if len(action) == 4 \
				else ShaderPassAction.new(action[0], target, ShaderPassAction.State.ENABLE, action[3], action[4]))
		elif action[2] == 'disable':
			actions.push_back(ShaderPassAction.new(action[0], target, ShaderPassAction.State.DISABLE, action[3]))
	return actions
