extends MeshInstance3D

signal fishing_starts
signal fishing_ends

@onready var moving_bobber : RigidBody3D = $MovingBobber
@onready var floating_bobber : RigidBody3D = $FloatingBobber

var bobber_initial_v : Vector3 = Vector3(0, 5, 3)
var bobber_detached : bool = false

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if !bobber_detached:
			bobber_detached = true
			moving_bobber.launch(bobber_initial_v)
			emit_signal("fishing_starts")
		elif moving_bobber.is_in_water:
			bobber_detached = false
			floating_bobber.visible = false
			floating_bobber.transform = self.transform
			emit_signal("fishing_ends")

func _on_moving_bobber_water_entered():
	floating_bobber.transform = moving_bobber.transform
	floating_bobber.visible = true
	print("bobber moved")
