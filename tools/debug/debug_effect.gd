extends Node3D

#@onready var screen_space_material : MultiPassShaderMaterial = $ScreenSpaceMesh.get_surface_override_material(0)

@onready var effect_list := $CanvasLayer/EffectList
@onready var env_list := $CanvasLayer/EnvironmentList

func _ready() -> void:
	for effect_name in EffectReg.effects:
		effect_list.add_item(effect_name)
	
func _process(_delta: float) -> void:
	RenderingServer.global_shader_parameter_set('cpu_sync_time', Time.get_ticks_usec()*1e-6)

func _on_item_list_item_activated(index: int) -> void:
	var entry = effect_list.get_item_text(index).split(' ')
	var effect_name : String = entry[0]
	var is_effect_started := len(entry) > 1

	# I hardcoded some special transitions for certain effects below. For example
	# ColorFade will go from black->transparent if it has already been triggered (transparent->black).
	
	# For some effects like ColorFade, certain parameters can have it auto-disable (and cleanup).
	# In the case of ColorFade, it will disable if the end fade color is transparent.
	# In the case of Blur, it will disable if the end blur amount is 0.0, etc.
	if is_effect_started:
		match effect_name:
			'ColorFade': EffectReg.start_effect(self, effect_name, [$PostProcessing, Color.BLACK, Color.TRANSPARENT])
			'SlideWhistle': EffectReg.start_effect(self, effect_name, [$PostProcessing, 0.0, 1.0])
			'Blur': EffectReg.start_effect(self, effect_name, [$PostProcessing, 1.0, 0.0])
			'Bloom': EffectReg.start_effect(self, effect_name, [$PostProcessing, 1.0, 0.0])
			'Sepia': EffectReg.start_effect(self, effect_name, [$PostProcessing, 0.8, 0.0])
			_: EffectReg.free_effect(effect_name)
	else: # Effect is stopped
		match effect_name:
			'Explosion': EffectReg.start_effect(self, effect_name, [$SpawnPoint, $PostProcessing])
			'BetterCall': EffectReg.start_effect(self, effect_name, [self])
			'InteriorWarm': EffectReg.start_effect(self, effect_name, [self])
			_:
				if EffectReg.get_effect(effect_name) is CanvasItemEffect:
					EffectReg.start_effect(self, effect_name, [$PostProcessing])
				else:
					EffectReg.start_effect(self, effect_name)
	
	# Effect state change (enabled/disabled) logic
	match effect_name:
		'Flash': pass
		_:
			effect_list.set_item_text(index, effect_name if is_effect_started else effect_name + ' [ENABLED]')
	
	print('Loaded %s!' % effect_name)


func _on_environment_list_item_activated(index: int) -> void:
	var entry = env_list.get_item_text(index).split(' ')
	var env_name : String = entry[0]
	var is_env_visible := len(entry) > 1

	if is_env_visible:
		match env_name:
			'Background2D': ($Background2D as CanvasLayer).visible = false
	else: # Effect is stopped
		match env_name:
			'Background2D': ($Background2D as CanvasLayer).visible = true
	
	match env_name:
		_:
			env_list.set_item_text(index, env_name if is_env_visible else env_name + ' [ENABLED]')
