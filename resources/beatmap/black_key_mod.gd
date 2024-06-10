class_name BlackKeyMod extends BeatmapMod

static var TIMING_ACTIONS = []

func get_timing_actions(playfield : RhythmPlayfield) -> Array[TimingAction]:
	playfield.backplane_material.enable_shader_pass('Clouds')
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
