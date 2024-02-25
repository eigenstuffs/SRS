class_name ShaderPassAction extends TimingAction
	
enum State { DISABLE=0, ENABLE=1 }

@export var passes : Array ## Shape: Array[name: String]
@export var new_state : ShaderPassAction.State
@export var uniforms : Array ## Shape: Array[Dict[uniform_name: String, uniform_value: Variant]]

func _init(time_ : float, target_ : MultiPassShaderMaterial, new_state_ : ShaderPassAction.State, passes_ : Array, uniforms_ : Array=[]) -> void:
	super(time_, target_)
	self.new_state = new_state_; self.passes = passes_; self.uniforms = uniforms_
	match new_state_:
		ShaderPassAction.State.DISABLE:
			assert(uniforms_.is_empty())
		ShaderPassAction.State.ENABLE:
			if uniforms_.is_empty():
				self.uniforms.resize(len(passes_))
				self.uniforms.fill({})
			else:
				assert(len(passes_) == len(uniforms_))

func run() -> void:
	match self.new_state:
		ShaderPassAction.State.DISABLE:
			for pass_name in passes:
				target.disable_shader_pass(pass_name)
		ShaderPassAction.State.ENABLE:
			for i in range(len(passes)):
				# Call any callables in the shader pass's uniforms and set result
				# as uniform value
				for uniform_name in uniforms[i]:
					if uniforms[i][uniform_name] is Callable:
						uniforms[i][uniform_name] = uniforms[i][uniform_name].call()
				target.enable_shader_pass(passes[i], uniforms[i])
