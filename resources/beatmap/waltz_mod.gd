class_name WaltzMod
## This is a very rough version of how a 'modfile' can be loaded to sync different
## effects with a beatmap.

# TODO: erm, delete me and this file later please
static var TIMING_ACTIONS = [
	[  2.895,    'screen',  'enable', ['flash', 'albedo'], [{'factor' : 0.05}, {'albedo' : Color(0.8, 0.5, 0.5, 0.06)}]],

	[  3.568,    'screen',  'enable', ['flash'], [{'factor' : 0.1}]],

	[  4.254,    'screen',  'enable', ['flash'], [{'factor' : 0.15}]],
	[  4.873,    'screen',  'enable', ['flash'], [{'factor' : 0.2}]],

	[  5.535,    'screen',  'enable', ['flash'], [{'factor' : 0.4, 'duration' : 0.6}]],
	[  5.535,      'back',  'enable', ['albedo_fade'], [{'albedo' : Color(0, 0, 0, 1), 'fade_time' : 8.0}]],
	[ 5.535,    'screen', 'disable', ['albedo']],
	[ 11.05,    'screen',  'enable', ['flash']],
	[ 11.05,      'back', 'disable', ['albedo_fade']],
	[ 45.403,      'back',  'enable', ['albedo_fade'], [{'albedo' : Color(0.1, 0.1, 0.1, 0.985), 'fade_time' : 4.0}]],
	[ 46.803,    'screen',  'enable', ['flash', 'greyscale']],
	[ 46.803, 'playfield', func(playfield):
	for key in playfield.keys: 
		key.enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))],
	[ 74.128,    'screen',  'enable', ['flash', 'impact_lines']],
	[ 74.128,    'screen', 'disable', ['greyscale']],
		[ 74.128, 'playfield', func(playfield):
	for key in playfield.keys: 
		key.disable_note_color_overwrite()],
	[ 74.128,      'back', 'disable', ['albedo_fade']],
	[ 111.151,    'screen',  'enable', ['flash']],
	[ 111.151,     'screen',  'disable', ['impact_lines']]]

static func get_timing_actions(playfield : RhythmPlayfield) -> Array[TimingAction]:
	# FIXME: This is yucky! Seriously,
	var actions : Array[TimingAction] = []
	for action in WaltzMod.TIMING_ACTIONS:
		var target : Variant = playfield.screen_space_material if action[1] == 'screen' else playfield.backplane_material if action[1] == 'back' else playfield
		if action[2] is Callable:
			actions.push_back(CallbackAction.new(action[0], action[2], [target]))
		elif action[2] == 'enable':
			actions.push_back(ShaderPassAction.new(action[0], target, ShaderPassAction.State.ENABLE, action[3]) if len(action) == 4 \
				else ShaderPassAction.new(action[0], target, ShaderPassAction.State.ENABLE, action[3], action[4]))
		elif action[2] == 'disable':
			actions.push_back(ShaderPassAction.new(action[0], target, ShaderPassAction.State.DISABLE, action[3]))
	return actions
