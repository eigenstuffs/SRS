extends Control

const DEFAULT_EFFECTS := preload('res://resources/effect/default_effects.gd')

var effects : Dictionary = {}
var effect_on : bool = false

func _ready() -> void:
	if Global.meta_data_dict["effect_on"]:
		register_all_effects()
		effect_on = true
	else: effect_on = false

func register_all_effects():
	for effect in DEFAULT_EFFECTS.new().effects:
		register(effect)
		
func register(effect : Effect) -> void:
	assert(effect.name, 'Effect#name is not set!')
	effects[effect.name] = effect
	print('(effect_registry) Registered: %s' % effect.name)
	
func start_effect(caller : Node, effect_name : StringName, args : Array=[]) -> void:
	print(not Global.meta_data_dict["effect_on"])
	if not Global.meta_data_dict["effect_on"]:
		return
	assert(effects.has(effect_name) and effects[effect_name])
	var effect : Effect = effects[effect_name]

	effect.start(args)
	if not effect.timer.get_parent():
		caller.add_child(effect.timer)
	
func stop_effect(effect_name : StringName) -> void:
	#assert(effects.has(effect_name) and effects[effect_name])
	if not Global.meta_data_dict["effect_on"]:
		return
	effects[effect_name].stop()
	
func free_effect(effect_name : StringName) -> void:
	#assert(effects.has(effect_name) and effects[effect_name])
	if not Global.meta_data_dict["effect_on"]:
		return
	effects[effect_name].queue_free()

func get_effect(effect_name : StringName) -> Effect:
	if not Global.meta_data_dict["effect_on"]:
		return null
	return effects[effect_name]

func get_effect_progress(effect_name : StringName) -> float:
	if not Global.meta_data_dict["effect_on"]:
		return 0
	var timer = effects[effect_name].timer
	return 1.0 - (timer.time_left / timer.wait_time) if is_instance_valid(timer) else 0.0

func has_key(effect_name : StringName) -> bool:
	if not Global.meta_data_dict["effect_on"]:
		return false
	return effects.has(effect_name)
