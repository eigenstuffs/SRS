extends MeshInstance3D

signal fishing_starts
signal fishing_ends
signal fish_hooked

@onready var moving_bobber : RigidBody3D = $MovingBobber
@onready var floating_bobber : RigidBody3D = $FloatingBobber

var bobber_initial_v : Vector3 = Vector3(0, 5, 3)
var bobber_detached : bool = false
var retractable : bool = false

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and retractable == true:
		retract_bobber()

func _on_moving_bobber_water_entered():
	floating_bobber.transform = moving_bobber.transform
	floating_bobber.visible = true
	retractable = true
	print("bobber moved")


func _on_fishing_player_fishing_time():
	if !bobber_detached:
		bobber_detached = true
		moving_bobber.launch(bobber_initial_v)
		emit_signal("fishing_starts")

func _on_fishing_player_walking_time():
	pass

func _on_floating_bobber_fish_hooked():
	emit_signal("fish_hooked")

func retract_bobber():
	bobber_detached = false
	retractable = false
	moving_bobber.disappear()
	floating_bobber.visible = false
	floating_bobber.transform = moving_bobber.transform
	emit_signal("fishing_ends")
