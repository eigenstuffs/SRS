class_name EffectRegistry extends Node

const EFFECT_LIST_RESOURCE_DIR := 'res://resources/effect/default_effects.tres'

static var effects : Dictionary = {}

static func _static_init() -> void:
	var effect_list := load(EFFECT_LIST_RESOURCE_DIR)
	for effect in effect_list.effect_list:
		register(effect)
	
static func register(effect : Effect) -> void:
	assert(effect.name)
	effects[effect.name] = effect
	print('(effect_registry) Registered: %s' % effect.name)
	
static func start_effect(caller : Node, name_ : StringName, args : Array=[]) -> void:
	assert(effects.has(name_) and effects[name_])
	var effect : Effect = effects[name_]
	
	effect.start(args)
	if not effect.timer.get_parent():
		caller.add_child(effect.timer)
	
static func stop_effect(name_ : StringName) -> void:
	assert(effects.has(name_) and effects[name_])
	var effect : Effect = effects[name_]
	
	effect.stop()

static func get_effect(name_ : StringName) -> Effect:
	return effects[name_]

static func get_effect_progress(name_ : StringName) -> float:
	var timer : Timer = effects[name_].timer
	return 1.0 - (timer.time_left / timer.wait_time) if timer else 0.0

static func has_key(name_ : StringName) -> bool:
	return effects.has(name_)
