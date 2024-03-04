class_name EffectBlur extends Effect
		
var material : MultiPassShaderMaterial;
var end_size : float
		
func _init() -> void:
	self.on_start = func(material_ : MultiPassShaderMaterial, start_size : float=0, end_size_ : float=64, directions : float=3, quality : int=2, noise_factor :float=0.03) -> void:
		self.material = material_
		self.end_size = end_size_
		
		assert(material.has_shader_pass(self.name))
		material.enable_shader_pass(self.name, {
			'directions' : directions, 
			'quality' : quality, 
			'start_size' : start_size,
			'end_size' : end_size,
			'noise_factor' : noise_factor,
			'duration' : duration})
	
	self.on_stop = func():
		assert(material.has_shader_pass(self.name))
		if end_size <= 0.0:
			material.disable_shader_pass(self.name)
