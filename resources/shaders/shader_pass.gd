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

func _init(name_='', shader_=null, is_enabled_by_default_=false, is_unique_pass_=false, default_uniforms_={}, priority_overwrite_=999) -> void:
	self.name = name_
	self.shader = shader_
	self.is_enabled_by_default = is_enabled_by_default_
	self.is_unique_pass = is_unique_pass_
	self.default_uniforms = default_uniforms_
	self.priority_overwrite = priority_overwrite_

func _on_shader_set(value : Shader) -> void:
	if not value: 
		default_uniforms = {}
		return
	else: for uniform in value.get_shader_uniform_list():
		self.default_uniforms[uniform.name] = null
		
	# Set name to be name of shader file (without extension)
	if self.name.is_empty():
		self.name = value.resource_path.get_file().trim_suffix('.gdshader')

func has_valid_priority_overwrite() -> bool:
	return priority_overwrite >= -128 and priority_overwrite <= 128
