class_name EffectRegistry extends Node

const EFFECT_LIST_RESOURCE_DIR := 'res://resources/effect/default_effects.tres'

static var effects : Dictionary = {}

static func _static_init() -> void:
	var effect_list := load(EFFECT_LIST_RESOURCE_DIR)
	for effect in effect_list.effect_list:
		register(effect)
	
static func register(effect : Effect) -> void:
	assert(effect.name, 'Effect#name is not set!')
	effects[effect.name] = effect
	print('(effect_registry) Registered: %s' % effect.name)
	
static func start_effect(caller : Node, effect_name : StringName, args : Array=[]) -> void:
	assert(effects.has(effect_name) and effects[effect_name])
	var effect : Effect = effects[effect_name]
	
	effect.start(args)
	if not effect.timer.get_parent():
		caller.add_child(effect.timer)
	
static func stop_effect(effect_name : StringName) -> void:
	assert(effects.has(effect_name) and effects[effect_name])
	effects[effect_name].stop()
	
static func free_effect(effect_name : StringName) -> void:
	assert(effects.has(effect_name) and effects[effect_name])
	effects[effect_name].queue_free()

static func get_effect(effect_name : StringName) -> Effect:
	return effects[effect_name]

static func get_effect_progress(effect_name : StringName) -> float:
	var timer = effects[effect_name].timer
	return 1.0 - (timer.time_left / timer.wait_time) if is_instance_valid(timer) else 0.0

static func has_key(effect_name : StringName) -> bool:
	return effects.has(effect_name)
