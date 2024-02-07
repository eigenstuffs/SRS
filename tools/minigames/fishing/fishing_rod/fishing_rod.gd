extends MeshInstance3D

@onready var bobber : RigidBody3D = $Bobber

var bobber_v : Vector3 = Vector3.ZERO
var gravity : Vector3 = Vector3.DOWN * 9.8
var activated : int = 0
var bobber_detached : bool = false
var bobber_pos

func _ready():
	bobber_pos = bobber.transform

func _physics_process(delta):
	bobber_v += gravity * delta
	if Input.is_action_just_pressed("ui_accept"):
		if bobber_detached == false:
			bobber_v = Vector3(0, 3, 3.5)
			bobber_detached = true
		else:
			bobber.transform = bobber_pos
			bobber_detached = false
	bobber.linear_velocity = bobber_v
