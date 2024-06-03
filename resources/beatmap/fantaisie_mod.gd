class_name FantaisieMod extends BeatmapMod

static var TIMING_ACTIONS = [
[ 8.836, 'playfield', func(playfield): 
		EffectReg.start_effect(playfield, 'ImpactLines', [playfield.effects, 0.7, 0.7])
		EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])
		EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.5, 1.0])
		for key in playfield.keys: 
			key.enable_note_shader_pass('warp')],
			#key.enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))],
[ 18.836 + 0.086*0, 'playfield', func(playfield): 
		EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])
		for key in playfield.keys: 
			key.disable_note_shader_pass('warp')],
[ 18.836 + 0.086*1, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*2, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*3, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*4, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*5, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*6, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*7, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*8, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*9, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*10, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*11, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*12, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*13, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*14, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*15, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*16, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*17, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*18, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*19, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*20, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*21, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*22, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*23, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*24, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*25, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*26, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*27, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*28, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*29, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*30, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*31, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*32, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*33, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*34, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*35, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*36, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*37, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*38, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*39, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*40, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*41, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*42, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*43, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*44, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*45, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*46, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*47, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*48, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*49, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*50, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*51, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*52, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*53, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*54, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*55, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*56, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*57, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*58, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*59, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*60, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*61, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*62, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*63, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*64, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*65, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*66, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*67, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*68, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*69, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*70, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 18.836 + 0.086*71, 'playfield', func(playfield): EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.4, 0.15])],
[ 26.336, 'playfield', func(playfield): 
		EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])
		EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.5, 1.0])
		for key in playfield.keys: 
			key.enable_note_shader_pass('warp')],
[ 33.836,    'screen', 'enable', ['greyscale']],
[ 33.836, 'playfield', func(playfield): 
		EffectReg.free_effect('ImpactLines')
		EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])
		EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.5, 1.0])
		for key in playfield.keys: 
			key.disable_note_shader_pass('warp')],
[ 36.336,    'screen', 'disable', ['greyscale']],
[ 36.336, 'playfield', func(playfield): 
		EffectReg.start_effect(playfield, 'ImpactLines', [playfield.effects, 0.7, 0.7])
		EffectReg.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0), 1.0])
		EffectReg.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.0, 0.5, 1.0])
		for key in playfield.keys: 
			key.enable_note_color_overwrite(Color(0.85, 0.05, 0.05, 1.0))
			key.enable_note_shader_pass('warp')],
]

func get_timing_actions(playfield : RhythmPlayfield) -> Array[TimingAction]:
	playfield.backplane_material.enable_shader_pass('Spheres')
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
