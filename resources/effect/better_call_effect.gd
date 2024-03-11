class_name EffectBetterCall extends Effect
		
const BETTER_CALL_EFFECT := preload('res://resources/effect/better_call_effect/better_call_effect.tscn')
		
var effect;
		
func _init() -> void:
	self.on_start = func(caller : Node3D) -> void:
		self.effect = BETTER_CALL_EFFECT.instantiate()
		caller.add_child(effect)
	
	self.on_stop = func():
		self.effect.queue_free()
