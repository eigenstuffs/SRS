extends Camera3D

@export var MIN_X : float
@export var MAX_X : float
@export var MIN_Z : float
@export var MAX_Z : float

func _process(delta):
	global_position.x = clamp(global_position.x, MIN_X, MAX_X)
	global_position.z = clamp(global_position.z, MIN_Z, MAX_Z)
