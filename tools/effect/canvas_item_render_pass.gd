class_name CanvasItemRenderPass extends CanvasLayer

const CLEAR_SHADER := preload('res://resources/shaders/canvas_item/clear_shader_canvas_item.gdshader')

@export var priority : int
@export var shader : Shader

var screen_space_color_rect : ColorRect

func _init(shader_ : Shader, priority_ := 0) -> void:
	screen_space_color_rect = ColorRect.new()
	screen_space_color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen_space_color_rect.material = ShaderMaterial.new()
	screen_space_color_rect.material.shader = shader_
	add_child(screen_space_color_rect)
	
	self.shader = shader_
	self.priority = priority_

func enable(uniforms : Dictionary = {}):
	assert(shader, 'A shader must be assigned to this shader pass to enable!')
	_set_shader(shader)
	
	var material := screen_space_color_rect.material
	for uniform_name in uniforms:
		var uniform_value : Variant = uniforms[uniform_name]
		material.set_shader_parameter(uniform_name, uniform_value)
	material.set_shader_parameter('start_time', Time.get_ticks_usec()*1e-6)
	
func disable():
	_set_shader(CLEAR_SHADER)

func _set_shader(shader_ : Shader): 
	screen_space_color_rect.material.shader = shader_
