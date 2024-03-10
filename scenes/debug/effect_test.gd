extends Node3D

var start_color := Color.TRANSPARENT
var end_color := Color.BLACK

@onready var mat_canvas = $CanvasLayer/MultiPassShaderRect.material
@onready var mat_spatial = $ScreenSpaceMesh.get_surface_override_material(0)

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed('ui_accept'): return
	
	#if EffectRegistry.get_effect('ColorFade').is_running:
		#var t = EffectRegistry.get_effect_progress('ColorFade')
		#var start_color0 = Color(end_color.r, end_color.g, end_color.b, t)
		#EffectRegistry.start_effect(self, 'ColorFade', [mat_canvas, start_color0, start_color])
	#else:
	EffectRegistry.start_effect(self, 'ColorFade', [mat_canvas, start_color, end_color])
		
	#EffectRegistry.start_effect(self, 'Blur', [mat_spatial])
	#($ScreenSpaceMesh as MeshInstance3D).get_surface_override_material(0).enable_shader_pass('blur')

func _process(delta: float) -> void:
	RenderingServer.global_shader_parameter_set('cpu_sync_time', Time.get_ticks_usec()*1e-6)
