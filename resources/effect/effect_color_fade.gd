class_name EffectColorFade extends Effect

var material : MultiPassShaderMaterial;
var end_color : Color

func _init() -> void:
	self.on_start = func(material_ : MultiPassShaderMaterial, start_color : Color=Color.TRANSPARENT, end_color_ : Color=Color.BLACK) -> void:
		self.material = material_
		self.end_color = end_color_
		
		assert(material.has_shader_pass(self.name))
		material.enable_shader_pass(self.name, {'start_color' : start_color, 'end_color' : end_color, 'duration' : duration})
	
	self.on_stop = func():
		assert(material.has_shader_pass(self.name))
		if end_color == Color.TRANSPARENT:
			material.disable_shader_pass(self.name)
