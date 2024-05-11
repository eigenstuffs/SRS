class_name EffectList extends Resource

@export var effect_list : Array[Effect]

class EffectSlideWhistle extends CanvasItemEffect:
	const SDF_TRANSITION_SHADER := preload('../shaders/canvas_item/sdf_transition.gdshader')

	func _init() -> void:
		render_passes.push_back(CanvasItemRenderPass.new(SDF_TRANSITION_SHADER))
		
		self.name = 'SlideWhistle'
		self.duration = 1
		self.on_start = func(start_radius := 1.0, end_radius := 0.0, color_override := Color.BLACK, use_star_sdf := false):
			self.should_free_when_stopped = end_radius == 1.0
			render_passes[0].enable({
				'start_radius': start_radius,
				'end_radius': end_radius,
				'color_override': color_override,
				'use_star_sdf': use_star_sdf,
			})

class EffectImpactLines extends CanvasItemEffect:
	const IMPACT_LINE_SHADER := preload('../shaders/canvas_item/impact_lines.gdshader')

	func _init() -> void:
		render_passes.push_back(CanvasItemRenderPass.new(IMPACT_LINE_SHADER))
		
		super('ImpactLines', 0.0, 
			func(weight := 0.5, max_alpha := 0.7, bias_angle := 0.0, bias_weight := 0.0):
				render_passes[0].enable({
					'weight': weight,
					'max_alpha': max_alpha,
					'bias_angle': bias_angle,
					'bias_weight': bias_weight}),
			func(): 
				queue_free())

class EffectBlur extends CanvasItemEffect:
	const BLUR_SHADER := preload('../shaders/canvas_item/blur.gdshader')
	const SCREEN_NOISE_SHADER := preload('../shaders/canvas_item/screen_noise.gdshader')

	func _init() -> void:
		render_passes.push_back(CanvasItemRenderPass.new(BLUR_SHADER)) # Horizontal pass
		render_passes.push_back(CanvasItemRenderPass.new(BLUR_SHADER)) # Vertical pass
		render_passes.push_back(CanvasItemRenderPass.new(SCREEN_NOISE_SHADER)) 
		
		super('Blur', 0.2,
			func(t0 := 0.0, t1 := 1.0):
				self.should_free_when_stopped = t1 <= 0.0
				render_passes[0].enable({'t0' : t0, 't1' : t1, 'duration': duration, 'direction': Vector2(1, 0)})
				render_passes[1].enable({'t0' : t0, 't1' : t1, 'duration': duration, 'direction': Vector2(0, 1)})
				render_passes[2].enable({'t0' : t0, 't1' : t1, 'duration': duration}))

class EffectColorFade extends CanvasItemEffect:
	const COLOR_FADE_SHADER := preload('../shaders/canvas_item/color_fade.gdshader')

	func _init() -> void:
		render_passes.push_back(CanvasItemRenderPass.new(COLOR_FADE_SHADER))
		
		super('ColorFade', 1.0, 
			func(from := Color.TRANSPARENT, to := Color.BLACK) -> void:
				self.should_free_when_stopped = to.a <= 0.0
				render_passes[0].enable({'start_color' : from, 'end_color' : to, 'duration' : duration}))

class EffectFlash extends EffectColorFade:
	func _init() -> void:
		super()
		self.name = 'Flash'
		self.should_free_when_stopped = true
		self.on_start = func(color := Color(0.98, 0.98, 0.98, 0.6), flash_duration := 0.35) -> void:
			self.duration = flash_duration
			render_passes[0].enable({
				'start_color' : color, 
				'end_color' : Color(color.r, color.g, color.b, 0), 
				'duration' : flash_duration})

class EffectKuwahara extends CanvasItemEffect:
	const KUWAHARA_FILTER := preload('../shaders/canvas_item/kuwahara.gdshader')

	func _init() -> void:
		render_passes.push_back(CanvasItemRenderPass.new(KUWAHARA_FILTER))
		
		super('Kuwahara', 0.0, 
			func(radius := 10.0, offset := Vector2(0, 0)) -> void:
				render_passes[0].enable({'radius' : radius, 'offset' : offset}))
				
class EffectSepia extends CanvasItemEffect:
	const LINEAR_COLOR_MAP_SHADER := preload('../shaders/canvas_item/linear_color_map.gdshader')

	func _init() -> void:
		render_passes.push_back(CanvasItemRenderPass.new(LINEAR_COLOR_MAP_SHADER))
		
		super('Sepia', 1.0, 
			func(t0 := 0.0, t1 := 0.8) -> void:
				self.should_free_when_stopped = t1 <= 0.0
				render_passes[0].enable({
					'transformation_matrix' : get_color_space_transformation_matrix(), 
					't0' : t0,
					't1' : t1,
					'duration': duration}))
		
	func get_color_space_transformation_matrix():
		return Basis(
			Vector3(0.393, 0.769, 0.189),
			Vector3(0.349, 0.686, 0.168),
			Vector3(0.272, 0.534, 0.131)
		)

class EffectVignette extends CanvasItemEffect:
	const VIGNETTE_SHADER := preload('../shaders/canvas_item/vignette.gdshader')

	func _init() -> void:
		render_passes.push_back(CanvasItemRenderPass.new(VIGNETTE_SHADER))
		
		super('Vignette', 0.0, 
			func(): render_passes[0].enable(),
			func(): queue_free())
			
class EffectBetterCall extends Effect:
	const BETTER_CALL_EFFECT := preload('./better_call_effect/better_call_effect.tscn')
		
	var effect_node : Node
		
	func _init() -> void:
		super('BetterCall', 0.0, 
			func(parent : Node3D):
				self.effect_node = BETTER_CALL_EFFECT.instantiate()
				parent.add_child(self.effect_node),
			func(): 
				queue_free(),
			func():
				self.effect_node.queue_free())
				
class EffectInteriorWarm extends Effect:
	const INTERIOR_WARM_EFFECT := preload('./interior_warm_effect/interior_warm_effect.tscn')
		
	var effect_node : Node
		
	func _init() -> void:
		super('InteriorWarm', 0.0, 
			func(parent : Node3D):
				self.effect_node = INTERIOR_WARM_EFFECT.instantiate()
				parent.add_child(self.effect_node),
			func(): 
				queue_free(),
			func():
				self.effect_node.queue_free())
				
class EffectSphereRaytraced extends CanvasItemEffect:
	const SPHERE_RAYTRACED_SHADER := preload('../shaders/canvas_item/sphere_raytraced.gdshader')

	func _init() -> void:
		render_passes.push_back(CanvasItemRenderPass.new(SPHERE_RAYTRACED_SHADER))
		
		super('SphereRaytraced', 0.0)

class EffectSphereRaymarched extends CanvasItemEffect:
	const SPHERE_RAYMARCHED_SHADER := preload('../shaders/canvas_item/sphere_raymarched.gdshader')

	func _init() -> void:
		render_passes.push_back(CanvasItemRenderPass.new(SPHERE_RAYMARCHED_SHADER))
		
		super('SphereRaymarched', 0.0)
		
class EffectBloom extends CanvasItemEffect:
	const BLOOM_SHADER := preload('../shaders/canvas_item/bloom.gdshader')

	func _init() -> void:
		render_passes.push_back(CanvasItemRenderPass.new(BLOOM_SHADER)) # Horizontal pass
		render_passes.push_back(CanvasItemRenderPass.new(BLOOM_SHADER)) # Vertical pass
		
		super('Bloom', 0.2,
			func(t0 := 0.0, t1 := 1.0, strength := 0.35):
				self.should_free_when_stopped = t1 <= 0.0
				render_passes[0].enable({'t0' : t0, 't1' : t1, 'duration': duration, 'direction': Vector2(1, 0), 'strength': strength*0.5})
				render_passes[1].enable({'t0' : t0, 't1' : t1, 'duration': duration, 'direction': Vector2(0, 1), 'strength': strength*0.5}))

class EffectExplosion extends Effect:
	const EXPLOSION_EFFECT := preload('./explosion_effect/explosion_effect.tscn')
		
	var effect_node : ExplosionEffect
		
	func _init() -> void:
		super('Explosion', 3.0, 
			func(parent : Node3D, flash_node : Control):
				self.effect_node = EXPLOSION_EFFECT.instantiate()
				parent.add_child(self.effect_node)
				
				# Hit stop!
				Engine.time_scale = 0.001
				EffectRegistry.start_effect(parent, 'Flash', [flash_node, Color(0.98, 0.98, 0.98, 0.5), 99999.0])
				self.effect_node.start_anticiation()
				await parent.get_tree().create_timer(0.4*Engine.time_scale).timeout
				
				Engine.time_scale = 1.0
				EffectRegistry.start_effect(parent, 'Flash', [flash_node, Color(0.98, 0.98, 0.98, 0.6), 0.1])
				self.effect_node.start_explosion(),
			func(): queue_free(),
			func(): pass)

static func _static_init() -> void:
	EffectRegistry.register(EffectImpactLines.new())  # Impact lines for zooming!
	EffectRegistry.register(EffectSlideWhistle.new()) # Transition for signed distance field
	EffectRegistry.register(EffectBlur.new())         # Blurs everything behind
	EffectRegistry.register(EffectColorFade.new())    # Fades to a chosen color
	EffectRegistry.register(EffectFlash.new())        # Flash!
	EffectRegistry.register(EffectBetterCall.new())
	EffectRegistry.register(EffectKuwahara.new())     # Emulates a 'painted' appearance (good for blending 3D objects with 2D art)
	EffectRegistry.register(EffectSepia.new())        # Adds a sepia filter
	EffectRegistry.register(EffectVignette.new())     # Adds a vignette (goes well with sepia filter)
	EffectRegistry.register(EffectInteriorWarm.new()) # Adds fake glow and particles emulating dust (for more cohesive scenes)
	EffectRegistry.register(EffectSphereRaytraced.new())
	EffectRegistry.register(EffectSphereRaymarched.new())
	EffectRegistry.register(EffectBloom.new())
	EffectRegistry.register(EffectExplosion.new())
