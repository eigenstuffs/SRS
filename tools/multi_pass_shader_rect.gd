@tool
class_name MultiPassShaderRect extends ColorRect

const CLEAR_SHADER := preload('../resources/shaders/canvas_item/clear_shader_canvas_item.gdshader')

@export var anchor_preset : LayoutPreset = PRESET_FULL_RECT :
	set(value):
		anchor_preset = value
		set_anchors_preset(anchor_preset, true)

@export var passes : MultiPassShaderMaterial = MultiPassShaderMaterial.new():
	set(value):
		passes = MultiPassShaderMaterial.new() if not value else value
		passes.shader = CLEAR_SHADER if not passes.shader else passes.shader
		passes.is_canvas_item = true
		material = passes
		
func _init() -> void:
	passes.shader = CLEAR_SHADER if not passes.shader else passes.shader
	passes.is_canvas_item = true
	material = passes
	set_anchors_preset(anchor_preset, true)
