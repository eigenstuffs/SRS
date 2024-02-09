extends MeshInstance3D

@onready var bobber : RigidBody3D = $Bobber

var bobber_initial_v : Vector3 = Vector3(0, 5, 3)
var bobber_detached : bool = false
var bobber_pos

func _ready():
	bobber_pos = bobber.transform

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if !bobber_detached:
			bobber_detached = true
			bobber.launch(bobber_initial_v)
		else:
			bobber_detached = false
			bobber.transform = bobber_pos
			bobber.linear_velocity = Vector3.ZERO
