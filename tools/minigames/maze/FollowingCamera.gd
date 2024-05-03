extends Camera3D

@export var MIN_X : float
@export var MAX_X : float
@export var MIN_Z : float
@export var MAX_Z : float

var ORIGINAL_ROT : Vector3 = Vector3(-51.2, 0, 0)
var BIRD_VIEW_ROT : Vector3 = Vector3(-80, 0, 0)
var GOAL_POS : Vector3 = Vector3(9, 7, 9)
var curr_pos : Vector3

func _process(delta):
	global_position.x = clamp(global_position.x, MIN_X, MAX_X)
	global_position.z = clamp(global_position.z, MIN_Z, MAX_Z)

func bird_view():
	curr_pos = global_position
	var a = create_tween().set_parallel()
	a.tween_property(self, "rotation_degrees", BIRD_VIEW_ROT, 0.5)
	a.tween_property(self, "global_position", GOAL_POS, 0.5)
	a.tween_property
	await a.finished
	
func original_view():
	global_position = curr_pos
	set_rotation_degrees(ORIGINAL_ROT)
