class_name EffectColorFade extends Effect
		
func _init() -> void:
	self.on_run = func(material : MultiPassShaderMaterial, start_color : Color=Color.TRANSPARENT, end_color : Color=Color.BLACK) -> void:		
		assert(material.has_shader_pass('color_fade'))
		material.enable_shader_pass('color_fade', {'start_color' : start_color, 'end_color' : end_color, 'duration' : duration})
