@tool
class_name ShaderPass extends Resource
## Represents information about a "shader pass" (i.e., information relevant
## within a shader pass for a [ShaderMaterial])

@export var name : StringName
@export var shader : Shader :
	set(value):
		shader = value
		_on_shader_set(shader)
			
@export var is_enabled_by_default : bool = false
## Used specifically for shader passes whose vertex shader conflicts with another
## shader pass's vertex shader. I.e., only one unique shader pass can be active
## at a time.
@export var is_unique_pass : bool = false
@export var default_uniforms : Dictionary = {}
@export var priority_overwrite : int = 999

func _init(name='', shader=null, is_enabled_by_default=false, is_unique_pass=false, default_uniforms={}, priority_overwrite=999) -> void:
	self.name = name
	self.shader = shader
	self.is_enabled_by_default = is_enabled_by_default
	self.is_unique_pass = is_unique_pass
	self.default_uniforms = default_uniforms
	self.priority_overwrite=priority_overwrite

func _on_shader_set(shader : Shader) -> void:
	if not shader: 
		default_uniforms = {}
		return
	else: for uniform in shader.get_shader_uniform_list():
		self.default_uniforms[uniform.name] = null
		
	# Set name to be name of shader file (without extension)
	if self.name.is_empty():
		self.name = shader.resource_path.get_file().trim_suffix('.gdshader')

func has_valid_priority_overwrite() -> bool:
	return priority_overwrite >= -128 and priority_overwrite <= 128
