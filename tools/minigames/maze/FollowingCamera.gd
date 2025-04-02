extends Camera3D

#TODO: Solve clipping issues when animated sprite 3d is at the "correct" angle
@export var MIN_X : float
@export var MAX_X : float
@export var MIN_Z : float
@export var MAX_Z : float
@export var maze_generator : MazeGenerator
@export var following_player : Node

var ORIGINAL_ROT : Vector3
var BIRD_VIEW_ROT : Vector3 = Vector3(-80, 0, 0)
var GOAL_POS : Vector3
var curr_pos : Vector3

func _ready():
	set_goal_pos()

func _process(delta):
	global_position.x = clamp(global_position.x, MIN_X, MAX_X)

func bird_view(): #TODO: fix camera position after bird-view
	curr_pos = global_position
	var a = create_tween().set_parallel()
	a.tween_property(self, "rotation_degrees", BIRD_VIEW_ROT, 0.5)
	a.tween_property(self, "global_position", GOAL_POS, 0.5)
	a.tween_property
	await a.finished
	
func original_view():
	global_position = curr_pos
	set_rotation_degrees(ORIGINAL_ROT)

func set_goal_pos():
	MAX_X = maze_generator.mazeWidth + maze_generator.my_x
	MAX_Z = maze_generator.mazeLength + maze_generator.my_z
	GOAL_POS = Vector3(MAX_X-1, 7, MAX_Z-1)
	
	ORIGINAL_ROT = rotation_degrees
