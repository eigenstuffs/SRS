extends MeshInstance3D

@onready var bobber : RigidBody3D = $Bobber

var bobber_v : Vector3 = Vector3.ZERO
var gravity : Vector3 = Vector3.DOWN * 2
var activated : int = 0


func _physics_process(delta):
	if Input.is_action_pressed("ui_accept"):
		bobber_v = Vector3(1, 2, 0)
		activated = 1
	bobber_v += activated * gravity * delta
	bobber.transform.origin += bobber_v * delta
