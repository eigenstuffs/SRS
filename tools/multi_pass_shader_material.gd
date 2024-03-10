class_name MultiPassShaderMaterial extends ShaderMaterial
## A material that provides easy scriptable access to shader passes within a
## [ShaderMaterial] based on the [ShaderPass]s present within 
## [member MultiPassShaderMaterial.shader_passes]
##
## A 'base' shader can be specified by setting the first pass of the material.
## This shader pass will be used when no shader pass labeled 'unique' is enabled.

const CLEAR_SHADER_SPATIAL := preload('res://resources/shaders/spatial/clear_shader_spatial.gdshader')
const CLEAR_SHADER_CANVAS := preload('res://resources/shaders/canvas_item/clear_shader_canvas_item.gdshader')
const BASE_SHADER_NAME := 'base'

static var enabled_passes : Dictionary = {}

@export var is_canvas_item : bool = false
@export var shader_passes : Array[ShaderPass] = []

var shader_map : Dictionary = {}
var unique_enabled_shader_name : StringName
var is_initialized : bool = false
var clear_shader : Shader

func _create_base_shader_pass() -> void:
	var base_shader := self.shader.duplicate()
	var base_shader_default_uniforms := {}
	
	for uniform in base_shader.get_shader_uniform_list():
		base_shader_default_uniforms[uniform.name] = get_shader_parameter(uniform.name)
	self.shader_passes.push_back(ShaderPass.new(BASE_SHADER_NAME, base_shader, true, true, base_shader_default_uniforms, self.render_priority))

## If not run manually, shader passes will be lazily initialized
# TODO: Permit instance uniforms
func initialize_passes():
	if self.shader_passes.is_empty(): return
	
	self.clear_shader = CLEAR_SHADER_CANVAS if is_canvas_item else CLEAR_SHADER_SPATIAL
	if self.shader:
		_create_base_shader_pass()
		unique_enabled_shader_name = BASE_SHADER_NAME
	
	# Chain shader passes together
	var pass_material : ShaderMaterial = self
	for i in range(len(self.shader_passes)):
		var shader_pass := self.shader_passes[i]
		shader_map[shader_pass.name] = [pass_material, shader_pass]
		
		# FIXME: Wtf is this control flow???
		pass_material.shader = clear_shader
		if shader_pass.is_enabled_by_default:
			pass_material.shader = shader_pass.shader.duplicate()
			if shader_pass.is_unique_pass:
				if unique_enabled_shader_name and shader_pass.name != BASE_SHADER_NAME:
					if unique_enabled_shader_name == BASE_SHADER_NAME:
						printerr('Shader pass \'%s\' is marked as unique and enabled by default, but a base ' % shader_pass.name + \
							'shader for this object already is present! Base shader will overwrite this unique default-enabled shader pass.')
					else:
						printerr('Multiple shader passes have been marked as unique and enabled by default! Highest unique ' + \
							'default-enabled shader pass will overwrite all others!')
					pass_material.shader = clear_shader
				else:
					unique_enabled_shader_name = shader_pass.name
		
		pass_material.render_priority = shader_pass.priority_overwrite if shader_pass.has_valid_priority_overwrite() else -len(self.shader_passes) + i
		pass_material.next_pass = ShaderMaterial.new()
		pass_material = pass_material.next_pass
		
	self.is_initialized = true

func has_shader_pass(pass_name : StringName) -> bool:
	if self.is_initialized:
		return shader_map.has(pass_name) and shader_map[pass_name] != null
	else:
		return not shader_passes.filter(func(shader_pass : ShaderPass): return shader_pass.name == pass_name).is_empty()

func enable_shader_pass(pass_name : StringName, uniforms : Dictionary={}):
	assert(pass_name != BASE_SHADER_NAME, 'Shader pass name \'%s\' is reserved!' % BASE_SHADER_NAME)
	# Lazy initialization of bindings
	if not is_initialized: initialize_passes()
	_enable_shader_pass(pass_name, uniforms)
	MultiPassShaderMaterial.enabled_passes[pass_name] = null

func _enable_shader_pass(pass_name : StringName, uniforms : Dictionary={}):
	assert(self.is_initialized and shader_map[pass_name])
	
	var material : ShaderMaterial = shader_map[pass_name][0]
	var shader_pass : ShaderPass = shader_map[pass_name][1]
	
	if self.is_canvas_item:
		material.set_shader(shader_pass.shader)
		
		var uniform_dict : Dictionary = shader_pass.default_uniforms if uniforms.is_empty() else uniforms
		for uniform_name in uniform_dict:
			var uniform_value : Variant = uniform_dict[uniform_name]
			material.set_shader_parameter(uniform_name, uniform_value)
		material.set_shader_parameter('start_time', Time.get_ticks_usec()*1e-6)
		return
	
	if shader_pass.is_unique_pass and unique_enabled_shader_name != shader_pass.name:
		if shader_map.has(unique_enabled_shader_name):
			shader_map[unique_enabled_shader_name][0].set_shader(clear_shader)
		unique_enabled_shader_name = shader_pass.name
	
	if material.shader == clear_shader:
		material.set_shader(shader_pass.shader)
	
	var uniform_dict : Dictionary = shader_pass.default_uniforms if uniforms.is_empty() else uniforms
	for uniform_name in uniform_dict:
		var uniform_value : Variant = uniform_dict[uniform_name]
		material.set_shader_parameter(uniform_name, uniform_value)
	material.set_shader_parameter('start_time', Time.get_ticks_usec()*1e-6)

func disable_shader_pass(pass_name : StringName):
	assert(pass_name != BASE_SHADER_NAME, 'Shader pass name \'%s\' is reserved!' % BASE_SHADER_NAME)
	assert(self.is_initialized and shader_map[pass_name])
	var material : ShaderMaterial = shader_map[pass_name][0]
	var shader_pass : ShaderPass = shader_map[pass_name][1]
	
	if shader_pass.is_unique_pass and unique_enabled_shader_name == shader_pass.name:
		_enable_shader_pass(BASE_SHADER_NAME)
	if material.shader != clear_shader:
		material.set_shader(clear_shader)
	MultiPassShaderMaterial.enabled_passes.erase(pass_name)
