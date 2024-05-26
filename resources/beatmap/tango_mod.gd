class_name TangoMod
## This is a very rough version of how a 'modfile' can be loaded to sync different
## effects with a beatmap.

# TODO: erm, delete me and this file later please
static var TIMING_ACTIONS = [
	[  0.865, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  1.380, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  1.894, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
	[  2.237, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  2.751, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  3.266, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
	[  3.608, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.4])],
  	[  3.866, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.4])],
	[  4.123, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.4])],
	[  4.466, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[  4.637, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
	[  4.980, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.4])],
	
	[  5.494, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.0, 1.0, 0.6, 0.685])],
	[  6.351, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])
		#EffectRegistry.start_effect(playfield, 'Sepia', [playfield.effects])
		EffectRegistry.start_effect(playfield, 'Vignette', [playfield.effects])
		EffectRegistry.free_effect('Bloom')],
	[  6.351,    'screen', 'enable', ['greyscale']],
	#[  5.666, 'playfield', func(playfield): 
		#EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.0, 1.0, 0.5, 0.685])],
	[ 13.208, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.4])],
	[ 13.551, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4])],
	[ 14.480 , 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.0, 1.0, 0.6, 1.0])],
	[ 15.608, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[ 15.951, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 1.0 ), 0.4])
		EffectRegistry.free_effect('Bloom')],
	[ 15.951,    'screen', 'disable', ['greyscale']],
	[ 17.323, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.4])
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 1.0, 0.25, 99999999.0])
		EffectRegistry.free_effect('Vignette')
		for key in playfield.keys: 
			key.enable_note_shader_pass('warp')
			key.enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))],
	[ 17.323,      'back', 'enable', ['radial_pattern']],
	
	[ 24.180, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.4])],
	[ 24.523, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.4])],
	
	[ 28.294, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.4])
		EffectRegistry.start_effect(playfield, 'ImpactLines', [playfield.effects, 0.7, 0.7])],
	
	#29.494 29.580 29.666 29.837 29.923 30.008 30.180 30.266 30.351
	
	[ 29.494, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 29.580, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 29.666, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[ 29.837, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 29.923, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 30.008, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.1), 0.3])],
	[ 30.180, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 30.266, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 30.351, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[ 30.523, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 30.609, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 30.695, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	# 32.237 32.323 32.408 32.580 32.666 32.751 32.923 33.008 33.094 33.266 33.351 33.437
	
	[ 32.237, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 32.323, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 32.408, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[ 32.580, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 32.666, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 32.751, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[ 32.923, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 33.008, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 33.094, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	[ 33.266, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 33.351, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.15), 0.05])],
	[ 33.437, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
		
		
	[ 35.837, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.2), 0.15])],
	[ 36.008, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.15])],
	[ 36.180, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.2])],
	[ 36.351, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.5), 0.2])],
	[ 36.523, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.35])
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.4, 0.0, 1.0, 0.4])],
	
	[ 38.580, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.2), 0.15])],
	[ 38.751, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.15])],
	[ 38.923, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.2])],
	[ 39.094, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.5), 0.2])],
	[ 39.266, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.35])
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.4, 0.0, 1.0, 0.4])],
	
	# 266 351 437 523 608 694 780 866 951 037 123 208 294 380 466 551 637
	[ 39.266, 'playfield', func(playfield): 
		playfield.keys[0].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 39.351, 'playfield', func(playfield): 
		playfield.keys[0].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[1].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 39.437, 'playfield', func(playfield): 
		playfield.keys[1].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[2].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 39.523, 'playfield', func(playfield): 
		playfield.keys[2].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[3].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 39.608, 'playfield', func(playfield): 
		playfield.keys[3].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[0].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 39.694, 'playfield', func(playfield): 
		playfield.keys[0].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[1].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 39.780, 'playfield', func(playfield): 
		playfield.keys[1].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[2].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 39.866, 'playfield', func(playfield): 
		playfield.keys[2].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[3].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 39.951, 'playfield', func(playfield): 
		playfield.keys[3].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[0].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 40.037, 'playfield', func(playfield): 
		playfield.keys[0].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[1].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 40.123, 'playfield', func(playfield): 
		playfield.keys[1].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[2].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 40.208, 'playfield', func(playfield): 
		playfield.keys[2].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[3].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 40.294, 'playfield', func(playfield): 
		playfield.keys[3].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[0].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 40.380, 'playfield', func(playfield): 
		playfield.keys[0].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[1].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 40.466, 'playfield', func(playfield): 
		playfield.keys[1].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[2].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 40.551, 'playfield', func(playfield): 
		playfield.keys[2].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		playfield.keys[3].enable_note_color_overwrite(Color(0.8, 0.4, 0.4, 1.0))],
	[ 40.637, 'playfield', func(playfield): 
		playfield.keys[3].enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])],
	
	[ 40.980, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.4])
		EffectRegistry.free_effect('Bloom')
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.625, 1.0, 0.4, 0.343])],
	[ 41.323, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.625, 0.4, 0.2])],
	[ 42.008, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.41666, 1.0, 0.6, 1.029])],
	[ 43.037, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.6, 1.0, 1.0, 0.343])],
	[ 43.380, 'playfield', func(playfield):
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.4]) 
		EffectRegistry.free_effect('Bloom')
		EffectRegistry.free_effect('ImpactLines')
		for key in playfield.keys: 
			key.disable_note_shader_pass('warp')
			key.disable_note_color_overwrite()],
	[ 43.380,      'back', 'disable', ['radial_pattern']],

	[ 44.580, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.0, 1.0, 0.4, 0.171])],	
	[ 44.751, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.4])
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 1.0, 0.25, 9999999.0])
		for key in playfield.keys: key.enable_note_color_overwrite(Color(0.38, 0.45, 0.91, 1.0))],
	[ 44.751,      'back', 'enable', ['Algae']],
	
	[ 51.951, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.4])
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.3125, 0.8, 0.35])],
	
	[ 52.980 + 0.086*0, 'playfield', func(playfield): 
		playfield.keys[0].enable_note_color_overwrite(Color(0.5, 0.46, 0.91, 1.0))],
	[ 52.980 + 0.086*1, 'playfield', func(playfield): 
		playfield.keys[0].enable_note_color_overwrite(Color(0.38, 0.45, 0.91, 1.0))
		playfield.keys[1].enable_note_color_overwrite(Color(0.5, 0.46, 0.91, 1.0))],
	[ 52.980 + 0.086*2, 'playfield', func(playfield): 
		playfield.keys[1].enable_note_color_overwrite(Color(0.38, 0.45, 0.91, 1.0))
		playfield.keys[2].enable_note_color_overwrite(Color(0.5, 0.46, 0.91, 1.0))],
	[ 52.980 + 0.086*3, 'playfield', func(playfield): 
		playfield.keys[2].enable_note_color_overwrite(Color(0.38, 0.45, 0.91, 1.0))
		playfield.keys[3].enable_note_color_overwrite(Color(0.5, 0.46, 0.91, 1.0))],
	[ 52.980 + 0.086*4, 'playfield', func(playfield): 
		playfield.keys[3].enable_note_color_overwrite(Color(0.38, 0.45, 0.91, 1.0))],
	
	[ 55.723, 'playfield', func(playfield): 
		#EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.4])
		EffectRegistry.start_effect(playfield, 'Vignette', [playfield.effects])
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.8, 0.0, 1.0, 0.4])
		for key in playfield.keys: key.disable_note_color_overwrite()],
	[ 55.723,      'back', 'disable', ['Algae']],
	[ 55.723,    'screen', 'enable', ['greyscale']],
	
	[ 57.780 + 0.171*0, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.2), 0.15])],
	[ 57.780 + 0.171*1, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.15])],
	[ 57.780 + 0.171*2, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.2])],
	[ 57.780 + 0.171*3, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.5), 0.2])],
	[ 57.780 + 0.171*4, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.35])
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.4, 0.0, 1.0, 0.4])],
	
	[ 60.523 + 0.171*0, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.2), 0.15])],
	[ 60.523 + 0.171*1, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.15])],
	[ 60.523 + 0.171*2, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.2])],
	[ 60.523 + 0.171*3, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.5), 0.2])],
	[ 60.523 + 0.171*4, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.6), 0.35])
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.4, 0.0, 1.0, 0.4])],
	
	[ 61.208, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.4])
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 1.0, 0.25, 9999999.0])
		EffectRegistry.free_effect('Vignette')
		for key in playfield.keys: key.enable_note_color_overwrite(Color(0.38, 0.45, 0.91, 1.0))],
	[ 61.208,    'screen', 'disable', ['greyscale']],
	[ 61.208,      'back', 'enable', ['Algae']],
	
	[ 62.923, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.4])
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 1.0, 0.3125, 0.8, 0.35])],
	
	[ 63.951, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.4])],
	[ 64.466, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.4])],
	[ 64.637, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.4])],
	[ 65.151, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.4), 0.4])],
	[ 65.323, 'playfield', func(playfield): EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.4])],
	[ 65.666, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.3), 0.3])
		EffectRegistry.start_effect(playfield, 'Bloom', [playfield.effects, 0.25, 1.0, 0.8, 0.342])],
	[ 66.008, 'playfield', func(playfield): 
		EffectRegistry.start_effect(playfield, 'Flash', [playfield.effects, Color(0.98, 0.98, 0.98, 0.8), 0.4])
		EffectRegistry.free_effect('Bloom')
		for key in playfield.keys: key.disable_note_color_overwrite()],
	[ 66.008,      'back', 'disable', ['Algae']],
	
	
	
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
			key.enable_note_color_overwrite(Color(0.8, 0.2, 0.2, 1.0))],
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
