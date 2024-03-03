class_name Shadow extends Decal
## An imitation shadow implemented as a Decal node.
##
## [b]Note:[/b] The cull mask of the decal is set for all layers 
##   [b]EXCEPT LAYER 1[/b]! Be sure another bit is set in [code]VisualInstance3D[/code]->Layers 
##   if you want the shadow to be visible on your [code]MeshInstance3D[/code].

## Signaled when the shadow is entirely faded, just before [code]queue_free()[/code]
## is called
signal on_fully_faded

## Roughly corresponds to the size of the shadow, although the penumbra may be 
## larger. 
@export var radius : float = 1 : 
	set(value):
		radius = value
		size.x = radius * 2
		size.z = radius * 2
		
## Roughly corresponds to the opacity of the shadow
@export var alpha : float = 0.5 : 
	set(value):
		# TODO: OVERLAPPING SHADOWS ARE NOT VISUALLY DIFFERENTIABLE! 
		if should_fade: return
		
		alpha = value
		albedo_mix = lerp(0.3, 0.95, alpha)

@export var fade_time_seconds : float = 1

var should_fade : bool = false
var fade_time : float = 0

## Causes the shadow to "fade out" over [member Shadow.fade_time_seconds], calling 
## [code]queue_free()[/code] once fully faded.
func fade_out() -> void:
	should_fade = true
	
func _process(delta: float) -> void:
	if not should_fade: return
	
	# Decrease alpha smoothly, freeing self once fully faded
	albedo_mix = smoothstep(alpha, 0, fade_time / fade_time_seconds)
	if fade_time >= fade_time_seconds: 
		queue_free()
		on_fully_faded.emit()
	else:
		fade_time += delta
