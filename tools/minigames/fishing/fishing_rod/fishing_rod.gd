extends MeshInstance3D

signal fishing_starts
signal fishing_ends
signal fish_hooked

@onready var moving_bobber : RigidBody3D = $MovingBobber
@onready var floating_bobber : RigidBody3D = $FloatingBobber

var bobber_initial_v : Vector3 = Vector3(0, 5, 3)
var bobber_detached : bool = false
var retractable : bool = false
var in_reeling : bool = false

func _process(delta):
	if Input.is_action_just_released("ui_accept") and retractable == true:
		retract_bobber()

func _on_fishing_player_fishing_time():
	if !bobber_detached:
		bobber_detached = true
		moving_bobber.launch(bobber_initial_v)
		emit_signal("fishing_starts")
	#await get_tree().create_timer(2.5).timeout
	#if !retractable:
		#retract_bobber()

func _on_moving_bobber_water_entered():
	floating_bobber.transform = moving_bobber.transform
	floating_bobber.activate()
	floating_bobber.enable_being_monitored()
	retractable = true
	print("bobber moved")

func _on_floating_bobber_fish_hooked():
	if !in_reeling:
		in_reeling = true
		floating_bobber.disable_being_monitored()
		emit_signal("fish_hooked")

func retract_bobber():
	moving_bobber.disappear()
	floating_bobber.deactivate()
	floating_bobber.transform = moving_bobber.transform
	bobber_detached = false
	retractable = false
	in_reeling = false
	emit_signal("fishing_ends")
